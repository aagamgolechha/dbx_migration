# Databricks notebook source
from pyspark.sql import Window
from pyspark.sql import functions as F
from pyspark.sql.types import DecimalType, DoubleType, StringType
from abi_utils.medallion import TableUtility as TU
from abi_utils.medallion import Medallion
from utilities.generic_etl_import import bt_logger
from pyspark.sql import SparkSession
from functools import reduce
from operator import add
import datetime

logger = bt_logger()
spark = SparkSession.builder.getOrCreate()

RPV1 = "WBLM"  # Wholesaler Brand Line Monthly
RPV2 = "WBL6"  # Wholesaler Brand Line 6-month
RPV3 = "WFLM"  # Wholesaler Family Line Monthly
RPV4 = "WFL6"  # Wholesaler Family Line 6-month
RPV5 = "MBLM"  # MCA Brand Line Monthly
RPV6 = "MBL6"  # MCA Brand Line 6-month
RPV7 = "MFLM"  # MCA Family Line Monthly
RPV8 = "MFL6"  # MCA Family Line 6-month
RPV9 = "DBLM"  # Director Brand Line Monthly
RPV10 = "DBL6"  # Director Brand Line 6-month
RPV11 = "DFLM"  # Director Family Line Monthly
RPV12 = "DFL6"  # Director Family Line 6-month
RPV13 = "SBLM"  # State Brand Line Monthly
RPV14 = "SBL6"  # State Brand Line 6-month
RPV15 = "SFLM"  # State Family Line Monthly
RPV16 = "SFL6"  # State Family Line 6-month
RPV17 = "SFT6"  # State Family altline 6-month
RPV18 = "STL6"  # State altfam Line 6-month
RPV19 = "STT6"  # State altfam altline 6-month
RPV20 = "SALM"  # State All Line Monthly
RPV21 = "SAL6"  # State All Line 6-month
RPV22 = "ABL6"  # All Brand Line 6-month
RPV23 = "AFL6"  # All Family Line 6-month
RPV24 = "AAA6"  # All All All 6-month (Total US)
PROXIES = 24

BY_CLAUSES = {}
MERGE_STATEMENTS = {}
SORT_STATEMENTS = {}
TIME_DESCRIPTIONS = {}

def promotion_forecast_tfix(bgt_le_dly_flg,snap_year,closemon,strmon,closfobr):
    """
    Main function to generate the promotion forecast and rate/volume proxy (RPV) calculations for a given snapshot year and budget/lead daily flag.

    This function orchestrates the full ETL pipeline for the promotion forecast, including:
    - Reading and transforming forecast and actuals data from multiple source tables.
    - Applying business rules for rate, discount, and volume calculations.
    - Calculating tier weights, pyramid weights, and RPV proxies using dynamic SQL and Spark DataFrame operations.
    - Handling special logic for military promotions, state-specific rules, and forced overrides.
    - Producing the final output DataFrame with all required forecast and actual metrics, and writing it to the gold table.

    Args:
        snap_year (int): The forecast snapshot year.
        bgt_le_dly_flg (str): Budget/Daily flag (e.g., 'D').

    Returns:
        None. Writes the final DataFrame to the gold table as specified in the configuration.
    """
    now = datetime.datetime.now()
    logger.info(f"closemon = {closemon}")
    logger.info(f"strmon = {strmon}")
    logger.info(f"closfobr = {closfobr}")
    DEFAULT_FAM = "All Other Brands"
    year = snap_year
    
    read_snap = "PlanB_BNAAP"
    closfobr = closfobr if bgt_le_dly_flg == 'D' else 0
    newclose = 12 + strmon if bgt_le_dly_flg == 'D' else 12+closemon
    ZERORPV = "N"
    
    force_rate_rpv = "Y"
    current_date = now.strftime("%Y-%m-%d")

    logger.info("TFIX CODE EXECUTION STARTED")
    logger.info(f"Snap Year: {snap_year}, Current Year: {year}")

    logger.info("CHECKPOINT 1: Reading forecast data from mod_snap_bnaap table")
    forecast_data_read = spark.read.table(
        TU.get_fully_qualified_table_name(
            "finance", "maco", "mod_snap_bnaap"
        )
    )
    forecast_data_read = forecast_data_read.filter((F.col("snap_yr") == snap_year) & (F.col("bgt_le_dly_flg")==bgt_le_dly_flg))

    rename_map = {
        "promo_beg_dt": "fromdate",
        "promo_end_dt": "thrudate",
        "rtl_lvl": "rtl_level",
        "cnsmptn_typ_cd": "on_off_prem",
        "civmil_flg": "civmil",
        "promo_typ": "prom_type",
        "alchl_ind": "alc_ind",
        "wslr_nbr": "wslr",
        "brnd_cd": "bnd",
        "pkg_grp_seq_id": "grp",
        "deal_hdr_seq_id": "qd_group",
        "mkt_ln_cd": "line",
        "pkg_brrl_equiv_fct": "becv",
        "curr_max_disc_amt": "sug_disc",
        "max_alwnc_rate": "max_rate",
        "promo_status": "status",
        "state_cd": "state",
        "qd_max_qty": "qdHigh",
        "qd_min_qty": "qdLow",
    }


    for old_name, new_name in rename_map.items():
        forecast_data_read = forecast_data_read.withColumnRenamed(old_name, new_name)
    forecast_data_read = forecast_data_read.withColumn(
        "line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit(''))
    ).withColumn("state", F.coalesce(F.lpad(F.col("state"),2,'0'),F.lit('')))
    highlow_dataset = forecast_data_read

    logger.info("CHECKPOINT 2: Completed column renaming and data preparation")

    for i in range(1, 13):
        forecast_data_read = (
            forecast_data_read.withColumnRenamed(f"cr_pmt_actual_amt_{i }", f"actdol{i }")
            .withColumnRenamed(f"grss_prmtd_vol_{i }", f"actgpv{i }")
            .withColumnRenamed(f"aap_grss_prmtd_vol_{i }", f"aapgpv{i }")
            .withColumnRenamed(f"aap_paid_amt_{i }", f"aappaid{i }")
            .withColumnRenamed(f"nbr_promos_paid_{i }", f"promosPaid{i }")
        )
    forecast_data_read.createOrReplaceTempView("forecastData_view")

    consolidated_ln_cd = TU.get_fully_qualified_table_name(
        "radar", "revenue_system", "consolidated_ln_cd"
    )
    consolidated_brnd = TU.get_fully_qualified_table_name(
        "radar", "revenue_system", "consolidated_brnd"
    )
    consolidated_wslr = TU.get_fully_qualified_table_name(
        "radar", "revenue_system", "consolidated_wslr"
    )

    forecast_data = spark.sql(
        f"""
                SELECT a.grp,
                a.rtl_level,
                a.civmil,
                a.alc_ind,
                a.fromdate,
                a.thrudate,
                a.sug_disc,
                a.max_rate,
                a.qd_group,
                a.on_off_prem,
                a.status,
                a.becv,
                a.state,
                a.actdol1,
                a.actdol2,
                a.actdol3,
                a.actdol4,
                a.actdol5,
                a.actdol6,
                a.actdol7,
                a.actdol8,
                a.actdol9,
                a.actdol10,
                a.actdol11,
                a.actdol12,
                a.actgpv1,
                a.actgpv2,
                a.actgpv3,
                a.actgpv4,
                a.actgpv5,
                a.actgpv6,
                a.actgpv7,
                a.actgpv8,
                a.actgpv9,
                a.actgpv10,
                a.actgpv11,
                a.actgpv12,
                a.qdLow,
                a.qdHigh,
                a.prom_type,
                a.aapgpv1,
                a.aapgpv2,
                a.aapgpv3,
                a.aapgpv4,
                a.aapgpv5,
                a.aapgpv6,
                a.aapgpv7,
                a.aapgpv8,
                a.aapgpv9,
                a.aapgpv10,
                a.aapgpv11,
                a.aapgpv12,
                a.aappaid1,
                a.aappaid2,
                a.aappaid3,
                a.aappaid4,
                a.aappaid5,
                a.aappaid6,
                a.aappaid7,
                a.aappaid8,
                a.aappaid9,
                a.aappaid10,
                a.aappaid11,
                a.aappaid12,
                a.promosPaid1,
                a.promosPaid2,
                a.promosPaid3,
                a.promosPaid4,
                a.promosPaid5,
                a.promosPaid6,
                a.promosPaid7,
                a.promosPaid8,
                a.promosPaid9,
                a.promosPaid10,
                a.promosPaid11,
                a.promosPaid12,
                coalesce(B.brnd_cd, a.bnd) AS bnd,
                coalesce(C.mkt_ln_cd, a.line) AS LINE,
                CASE
                WHEN D.src_wslr_nbr IS NOT NULL
                AND D.eff_dt <= "{current_date}" THEN D.wslr_nbr
                ELSE a.WSLR
                END AS wslr
                FROM forecastData_view a
                LEFT JOIN {consolidated_brnd } B ON a.BND = B.src_brnd_cd
                LEFT JOIN {consolidated_ln_cd } C ON a.line = C.src_mkt_ln_cd
                LEFT JOIN {consolidated_wslr } D ON a.WSLR = D.src_wslr_nbr
            """
    )

    forecast_data = forecast_data.withColumn(
        "rtl_level",
        F.when((F.col("grp") == 568) & (F.col("rtl_level") == "1"), "3").otherwise(
            F.col("rtl_level")
        ),
    )

    logger.info("CHECKPOINT 3: Loaded forecast data with consolidated brand/line/wholesaler mappings")

    month_info = [
        (i, F.to_date(F.lit(f"{year }-{i :02d}-01"))) for i in range(1, 13)
    ]
    days_in_month_dict = {
        i: F.dayofmonth(F.last_day(F.to_date(F.lit(f"{year }-{i :02d}-01"))))
        for i in range(1, 13)
    }

    for i, mon1 in month_info:
        days_col = f"days{i }"
        days_in_month = days_in_month_dict[i]
        forecast_data = forecast_data.withColumn("MON1", mon1)
        forecast_data = forecast_data.withColumn("DAYS", days_in_month)
        forecast_data = forecast_data.withColumn(
            days_col,
            F.when(
                (F.month("fromdate") == i) & (F.month("thrudate") == i),
                F.unix_date("thrudate") - F.unix_date("fromdate") + 1,
            )
            .when(
                F.month("fromdate") == i,
                F.col("DAYS") - (F.unix_date("fromdate") - F.unix_date("MON1")),
            )
            .when(
                F.month("thrudate") == i, F.unix_date("thrudate") - F.unix_date("MON1") + 1
            )
            .when((F.month("fromdate") < i) & (F.month("thrudate") > i), F.col("DAYS"))
            .otherwise(F.lit(0)),
        )

    keep_cols = (
        [
            "wslr",
            "bnd",
            "line",
            "grp",
            "rtl_level",
            "civmil",
            "alc_ind",
            "fromdate",
            "thrudate",
            "sug_disc",
            "max_rate",
            "qd_group",
            "on_off_prem",
            "status",
            "becv",
            "state",
        ]
        + [f"actdol{i }" for i in range(1, 13)]
        + [f"actgpv{i }" for i in range(1, 13)]
        + ["qdLow", "qdHigh", "prom_type"]
        + [f"aappaid{i }" for i in range(1, 13)]
        + [f"aapgpv{i }" for i in range(1, 13)]
        + [f"promosPaid{i }" for i in range(1, 13)]
        + [f"days{i }" for i in range(1, 13)]
    )

    forecast_data = forecast_data.select(*keep_cols)

    init_cols = {}
    for i in range(1, 13):
        init_cols[f"maxRates{i }"] = F.lit(0)
        init_cols[f"maxDisc{i }"] = F.lit(0)
        init_cols[f"promoDays{i }"] = F.lit(0)
    rate_weights = forecast_data.select("*", *[v.alias(k) for k, v in init_cols.items()])


    rate_weights = rate_weights.withColumn(
        "sug_disc",
        F.when(F.col("sug_disc") == 0, F.col("max_rate") * 2).otherwise(F.col("sug_disc")),
    )

    exprs = [
        "wslr",
        "bnd",
        "line",
        "grp",
        "rtl_level",
        "qd_group",
        "civmil",
        "on_off_prem",
        "alc_ind",
        "qdLow",
        "qdHigh",
        "prom_type",
    ]

    for i in range(1, 13):
        exprs.append(
            F.when(
                (F.month(F.col("fromdate")) <= i) & (i <= F.month(F.col("thrudate"))),
                F.col("max_rate"),
            )
            .otherwise(F.lit(0))
            .alias(f"maxRates{i }")
        )
        exprs.append(
            F.when(
                (F.month(F.col("fromdate")) <= i) & (i <= F.month(F.col("thrudate"))),
                F.col("sug_disc"),
            )
            .otherwise(F.lit(0))
            .alias(f"maxDisc{i }")
        )
        exprs.append(
            F.when(
                (F.month(F.col("fromdate")) <= i) & (i <= F.month(F.col("thrudate"))),
                F.col(f"days{i }"),
            )
            .otherwise(F.lit(0))
            .alias(f"promoDays{i }")
        )
    rate_weights = rate_weights.select(*exprs)


    rate_weights = rate_weights.withColumn("promoFlag", F.lit(1))

    logger.info("CHECKPOINT 4: Created rate_weights with maxRates, maxDisc, and promoDays")

    rate_weights1 = rate_weights.withColumn(
        "promoFlag",
        F.when(F.col("rtl_level") != "1", 2).when(F.col("civmil") != "B", 2).otherwise(1),
    )


    rate_weights = rate_weights1.filter(F.col("promoFlag") == 2)

    rate_weights_gm = rate_weights1.filter(F.col("promoFlag") == 1)

    rate_weight_cols = (
        [
            "wslr",
            "bnd",
            "line",
            "grp",
            "rtl_level",
            "qd_group",
            "civmil",
            "on_off_prem",
            "alc_ind",
            "qdLow",
            "qdHigh",
            "prom_type",
        ]
        + [f"maxRates{i }" for i in range(1, 13)]
        + [f"promoDays{i }" for i in range(1, 13)]
        + [f"maxDisc{i }" for i in range(1, 13)]
    )

    rate_weights = rate_weights.select(*rate_weight_cols)

    rate_weights_gm = rate_weights_gm.select(*rate_weight_cols)

    max_rates_cols = [f"maxRates{i }" for i in range(1, 13)]
    max_disc_cols = [f"maxDisc{i }" for i in range(1, 13)]
    promo_days_cols = [f"promoDays{i }" for i in range(1, 13)]

    agg_exprs = [
        F.avg(c).alias(c) for c in max_rates_cols + max_disc_cols + promo_days_cols
    ] + [
        F.first("civmil").alias("civmil"),
        F.first("on_off_prem").alias("on_off_prem"),
        F.first("alc_ind").alias("alc_ind"),
    ]

    rate_weights = rate_weights.groupBy("wslr", "bnd", "line", "rtl_level", "qd_group").agg(
        *agg_exprs
    )


    rate_weights_gm = rate_weights_gm.withColumn(
        "lowHigh", F.concat(F.trim(F.col("qdLow")), F.lit("-"), F.trim(F.col("qdHigh")))
    )

    rate_weights_gm_qd = rate_weights_gm.select(
        ["wslr", "bnd", "line", "qd_group", "lowHigh", "prom_type"]
    )

    rate_weights_gm_qd = rate_weights_gm_qd.dropDuplicates(
        ["wslr", "bnd", "line", "qd_group", "lowHigh"]
    )

    track_q_ds_weighted = rate_weights_gm_qd.filter("prom_type='QD' ")


    window_spec = Window.partitionBy("wslr", "bnd", "line", "qd_group").orderBy("lowHigh")
    rate_weights_gm_qd_list_2 = rate_weights_gm_qd.withColumn(
        "row_num", F.row_number().over(window_spec)
    )

    rate_weights_gm_qd_list = (
        rate_weights_gm_qd_list_2.groupBy("wslr", "bnd", "line", "qd_group")
        .pivot("row_num")
        .agg(F.first("lowHigh"))
    )

    for i in range(1, len(rate_weights_gm_qd_list.columns) - 4 + 1):
        rate_weights_gm_qd_list = rate_weights_gm_qd_list.withColumnRenamed(
            str(i), f"col{i }"
        )

    num_cols = len(rate_weights_gm_qd_list.columns) - 4

    col_list = [f"col{i }" for i in range(1, num_cols + 1)]

    for c in col_list:
        rate_weights_gm_qd_list = rate_weights_gm_qd_list.withColumn(
            c, F.when(F.col(c) != "", F.trim(F.col(c))).otherwise(None)
        )

    rate_weights_gm_qd_list = rate_weights_gm_qd_list.withColumn(
        "QD_LowHigh", F.concat_ws(",", *[F.col(c) for c in col_list])
    )
    rate_weights_gm_qd_list = rate_weights_gm_qd_list.withColumn(
        "QD_LowHigh", F.regexp_replace("QD_LowHigh", r",+$", "")
    )

    rate_weights_gm_qd_list = rate_weights_gm_qd_list.select(
        "wslr", "bnd", "line", "qd_group", "QD_LowHigh"
    )


    rate_weights_gm_qd = rate_weights_gm_qd.join(
        rate_weights_gm_qd_list, ["wslr", "bnd", "line", "qd_group"], "inner"
    )

    tier_weights_wbl = spark.read.table(
        TU.get_fully_qualified_table_name("finance", "maco", "tier_weights_wbl")
    )

    tier_weights_wbl = tier_weights_wbl.select(
        F.col("wslr_nbr").alias("wslr"),
        F.col("brnd_cd").alias("bnd"),
        F.col("mkt_ln_cd").alias("line"),
        F.col("low_high_cd").alias("lowHigh"),
        F.col("qd_low_high_cd").alias("QD_LowHigh"),
        F.col("tier_wght").alias("tierWght"),
    )
    tier_weights_wbl = tier_weights_wbl.withColumn(
        "line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit('')))

    tier_weights = tier_weights_wbl.select(
        "wslr", "bnd", "line", "lowHigh", "QD_LowHigh", "tierWght"
    )


    rate_weights_gm_qd = rate_weights_gm_qd.join(
        tier_weights, ["wslr", "bnd", "line", "lowHigh", "QD_LowHigh"], "left"
    )

    tier_weights_wfl = spark.read.table(
        TU.get_fully_qualified_table_name("finance", "maco", "tier_weights_wfl")
    ).select(
        F.col("wslr_nbr").alias("wslr"),
        F.col("custom_family_nm").alias("family"),
        F.col("mkt_ln_cd").alias("line"),
        F.col("low_high_cd").alias("lowHigh"),
        F.col("qd_low_high_cd").alias("QD_LowHigh"),
        F.col("tier_wght").alias("tierWght"),
    )
    tier_weights_wfl = tier_weights_wfl.withColumn(
        "line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit('')))

    tier_weights_fam = tier_weights_wfl.withColumnRenamed("tierWght", "famTierWght").select(
        "wslr", "family", "line", "lowHigh", "QD_LowHigh", "famTierWght"
    )

    makefamsmart_df = spark.read.table(
        TU.get_fully_qualified_table_name("radar", "maco", "makefamsmart")
    ).select(
        F.col("brnd_cd").alias("bnd"),
        F.col("custom_family_nm").alias("family"),
        F.col("custom_fam_ord").alias("famord"),
    )
    makefamsmart_df1 = makefamsmart_df.select("bnd", "family")


    rate_weights_gm_qd = rate_weights_gm_qd.join(
        F.broadcast(makefamsmart_df1), "bnd", "left"
    )

    rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
        "family", F.coalesce(F.col("family"), F.lit(DEFAULT_FAM))
    ).select(
        "wslr",
        "bnd",
        "line",
        "lowHigh",
        "QD_LowHigh",
        "family",
        "prom_type",
        "qd_group",
        "tierWght",
    )


    rate_weights_gm_qd = rate_weights_gm_qd.join(
        F.broadcast(tier_weights_fam),
        ["wslr", "family", "line", "lowHigh", "QD_LowHigh"],
        "left",
    )

    tier_weights_sfl = spark.read.table(
        TU.get_fully_qualified_table_name(
            "finance", "maco", "tier_weights_sfl")
    ).select(
        F.col("state_nm").alias("state"),
        F.col("custom_family_nm").alias("family"),
        F.col("mkt_ln_cd").alias("line"),
        F.col("low_high_cd").alias("lowHigh"),
        F.col("qd_low_high_cd").alias("QD_LowHigh"),
        F.col("tier_wght").alias("tierWght"),
    )

    tier_weights_state = (
        tier_weights_sfl.withColumnRenamed("tierWght", "stateTierWght")
        .withColumn("state", F.coalesce(F.lpad(F.col("state"),2,'0'),F.lit('')))
        .withColumn("line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit('')))
        .select("state", "family", "line", "lowHigh", "QD_LowHigh", "stateTierWght")
    )

    wslr_sas_manual = spark.read.table(
        TU.get_fully_qualified_table_name("commercial", "wholesaler", "wholesaler")
    ).selectExpr(
        "wslr_nbr as wslr",
        "wslr_st_cd as state",
        "sls_regn_cd as  reg",
        "sls_dirctr_cd as wslrsdir",
        "wslr_city_st_txt as wslrcity",
        "mca_cd as  mca",
        "wslr_st_cd as  statcode",
    )

    wslr_sas_manual = wslr_sas_manual.withColumn(
        "wslr", F.coalesce(F.lpad(F.col("wslr"),5,'0'),F.lit('')))\
         .withColumn(
        "state", F.coalesce(F.lpad(F.col("state"),2,'0'),F.lit('')))

    wslr_info_temp = wslr_sas_manual.filter(F.col("reg") != F.lit(90))

    wslr_info = wslr_info_temp.select("wslr", "state")

    rate_weights_gm_qd = rate_weights_gm_qd.join(F.broadcast(wslr_info), ["wslr"], "left")
    rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
        "state", F.coalesce(F.col("state"), F.lit(""))
    )

    rate_weights_gm_qd = rate_weights_gm_qd.join(
        F.broadcast(tier_weights_state),
        ["state", "family", "line", "lowHigh", "QD_LowHigh"],
        "left",
    )


    rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
        "tierUsed", F.when(F.col("tierWght").isNotNull(), F.lit("WBL"))
    )
    rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
        "tierUsed",
        F.when(F.col("tierWght").isNull(), F.lit("WFL")).otherwise(F.col("tierUsed")),
    )
    rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
        "tierWght",
        F.when(F.col("tierWght").isNull(), F.col("famTierWght")).otherwise(
            F.col("tierWght")
        ),
    )
    rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
        "tierUsed",
        F.when(F.col("tierWght").isNull(), F.lit("SFL")).otherwise(F.col("tierUsed")),
    )
    rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
        "tierWght",
        F.when(F.col("tierWght").isNull(), F.col("stateTierWght")).otherwise(
            F.col("tierWght")
        ),
    )
    rate_weights_gm_qd = rate_weights_gm_qd.filter(F.col("tierWght").isNotNull())
    rate_weights_gm_qd = rate_weights_gm_qd.drop(
        "family", "famTierWght", "stateTierWght", "state"
    )

    tier_wght_chk = rate_weights_gm_qd.groupBy("wslr", "bnd", "line", "qd_group").agg(
        F.sum("tierWght").alias("tierWghtTotal")
    )
    rate_weights_gm_qd = rate_weights_gm_qd.join(
        tier_wght_chk, ["wslr", "bnd", "line", "qd_group"], "inner"
    )
    rate_weights_gm_qd = rate_weights_gm_qd.filter(F.round("tierWghtTotal") == 1)
    rate_weights_gm_qd = rate_weights_gm_qd.drop("tierWghtTotal")

    rate_weights_gm = rate_weights_gm.alias("a").join(
        rate_weights_gm_qd.alias("b"),
        ["wslr", "bnd", "line", "qd_group", "lowHigh"],
        "left",
    )
    rate_weights_gm = rate_weights_gm.select(
        "a.*", "b.tierUsed", "b.tierWght", "b.Qd_LowHigh"
    )
    rate_gm = rate_weights_gm.filter(F.col("tierWght").isNull())
    rate_gm_qd = rate_weights_gm.filter(F.col("tierWght").isNotNull())
    rate_weights_gm = rate_gm

    rate_weights_gm_qd = rate_gm_qd

    max_rates_cols = [f"maxRates{i }" for i in range(1, 13)]
    max_disc_cols = [f"maxDisc{i }" for i in range(1, 13)]

    for rate_col, disc_col in zip(max_rates_cols, max_disc_cols):
        rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
            rate_col,
            F.when(
                F.col("tierWght").isNotNull(),
                F.when(F.col(rate_col).isNull(), 0).otherwise(F.col(rate_col))
                * F.col("tierWght"),
            ).otherwise(F.col(rate_col)),
        )
        rate_weights_gm_qd = rate_weights_gm_qd.withColumn(
            disc_col,
            F.when(
                F.col("tierWght").isNotNull(),
                F.when(F.col(disc_col).isNull(), 0).otherwise(F.col(disc_col))
                * F.col("tierWght"),
            ).otherwise(F.col(disc_col)),
        )

    tier_weights_export = rate_weights_gm_qd

    tier_weights_export = tier_weights_export.dropDuplicates(
        ["wslr", "bnd", "line", "qd_group", "lowHigh", "QD_LowHigh"]
    )

    group_cols = ["wslr", "bnd", "line", "rtl_level", "qd_group"]

    max_rates_cols = [f"maxRates{i }" for i in range(1, 13)]
    max_disc_cols = [f"maxDisc{i }" for i in range(1, 13)]
    promo_days_cols = [f"promoDays{i }" for i in range(1, 13)]

    id_cols = ["civmil", "on_off_prem", "alc_ind"]

    agg_exprs = (
        [F.sum(col).alias(col) for col in max_rates_cols + max_disc_cols]
        + [F.avg(col).alias(col) for col in promo_days_cols]
        + [F.first(col, ignorenulls=True).alias(col) for col in id_cols]
    )

    rate_weights_gm_qd = rate_weights_gm_qd.groupBy(*group_cols).agg(*agg_exprs)

    group_cols = ["wslr", "bnd", "line", "qd_group"]

    track_q_ds_weighted = (
        track_q_ds_weighted.groupBy(*group_cols)
        .count()
        .withColumnRenamed("count", "tierCount")
    )
    tier_weights_export = tier_weights_export.select(
        ["wslr", "bnd", "line", "lowHigh", "QD_LowHigh", "tierUsed", "tierWght"]
    )

    tier_weights_export = tier_weights_export.dropDuplicates(
        ["wslr", "bnd", "line", "lowHigh", "QD_LowHigh"]
    )

    tier_weights_export = tier_weights_export.join(
        F.broadcast(makefamsmart_df), "bnd", "left"
    )

    tier_weights_export = tier_weights_export.withColumns(
        {
            "family": F.coalesce(F.col("family"), F.lit(DEFAULT_FAM)),
            "famord": F.coalesce(F.col("famord"), F.lit(90)),
        }
    )

    logger.info("CHECKPOINT 5: Completed tier weights calculation and family mapping")


    linecode_raw = spark.read.table(
        TU.get_fully_qualified_table_name("commercial", "product", "market_line")
    )
    linecode_raw.createOrReplaceTempView("linecode_raw")
    package_info = spark.sql(
        """
                SELECT mkt_ln_cd AS LINE,
                mkt_ln_nm AS linedesc
                FROM linecode_raw
                ORDER BY LINE
            """
    )

    tier_weights_export = tier_weights_export.join(
        F.broadcast(package_info), "line", "left"
    )

    wslr_info = wslr_info_temp.select(["wslr", "state", "reg", "wslrsdir", "wslrcity"])

    tier_weights_export = tier_weights_export.join(F.broadcast(wslr_info), ["wslr"], "left")

    qd_not_weighted = rate_weights_gm.filter(F.col("prom_type") == "QD")

    qd_not_weighted = qd_not_weighted.dropDuplicates(
        ["wslr", "bnd", "line", "qd_group", "lowHigh"]
    )

    qd_not_weighted_tier_cnt = (
        qd_not_weighted.groupBy("wslr", "bnd", "line", "qd_group")
        .count()
        .withColumnRenamed("count", "_freq_")
    )
    qd_not_weighted_tier_cnt = qd_not_weighted_tier_cnt.filter(F.col("_freq_") > 1)

    qd_not_weighted = qd_not_weighted.join(
        F.broadcast(qd_not_weighted_tier_cnt), ["wslr", "bnd", "line", "qd_group"], "inner"
    ).drop("_freq_")

    qd_not_weighted = qd_not_weighted.dropDuplicates(
        ["wslr", "bnd", "line", "qd_group", "qdLow", "qdHigh"]
    )

    qd_not_weighted = qd_not_weighted.join(
        F.broadcast(makefamsmart_df), "bnd", "left"
    ).withColumns(
        {
            "family": F.coalesce(F.col("family"), F.lit(DEFAULT_FAM)),
            "famord": F.coalesce(F.col("famord"), F.lit(90)),
        }
    )

    qd_not_weighted.createOrReplaceTempView("qdNotWeighted")
    wslr_info.createOrReplaceTempView("wslrInfo")
    package_info.createOrReplaceTempView("packageInfo")

    group_cols = ["wslr", "bnd", "line", "rtl_level", "qd_group"]

    var_cols = (
        [f"maxRates{i }" for i in range(1, 13)]
        + [f"promoDays{i }" for i in range(1, 13)]
        + [f"maxDisc{i }" for i in range(1, 13)]
    )

    id_cols = ["civmil", "on_off_prem", "alc_ind"]

    agg_exprs = [F.mean(c).alias(c) for c in var_cols] + [
        F.first(c).alias(c) for c in id_cols
    ]

    rate_weights_gm = rate_weights_gm.groupBy(*group_cols).agg(*agg_exprs)

    rate_weights_gm = rate_weights_gm.unionByName(rate_weights_gm_qd)


    def apply_coalesce_and_weight(df, i):
        """
        For a given Spark DataFrame and month index i (1-12), this function:
        - Coalesces nulls to 0 for maxRates{i}, promoDays{i}, and maxDisc{i} columns.
        - Multiplies maxRates{i} and maxDisc{i} by promoDays{i} to weight the rate and discount by the number of promo days.
        Returns the transformed DataFrame.
        """
        max_rates_col = f"maxRates{i }"
        promo_days_col = f"promoDays{i }"
        max_disc_col = f"maxDisc{i }"

        transformations = {
            max_rates_col: F.coalesce(F.col(max_rates_col), F.lit(0)),
            promo_days_col: F.coalesce(F.col(promo_days_col), F.lit(0)),
            max_disc_col: F.coalesce(F.col(max_disc_col), F.lit(0)),
        }
        df = df.withColumns(transformations)

        weight_transformations = {
            max_rates_col: F.col(max_rates_col) * F.col(promo_days_col),
            max_disc_col: F.col(max_disc_col) * F.col(promo_days_col),
        }
        df = df.withColumns(weight_transformations)
        return df


    for i in range(1, 13):
        rate_weights = apply_coalesce_and_weight(rate_weights, i)

    logger.info("CHECKPOINT 6: Applied coalesce and weight transformations to rate_weights")

    high_low = highlow_dataset.filter(
        (F.col("rtl_level") == "1")
        & (F.col("civmil") == "B")
        & (F.col("on_off_prem") == "B")
        & (F.col("prom_type") != "QD")
        & (F.col("grp") != 568)
    ).select("wslr", "bnd", "line", "fromdate", "thrudate", "max_rate", "alc_ind")

    for i in range(1, 13):
        rate_col = f"rate{i }"
        high_low = high_low.withColumn(
            rate_col,
            F.when(
                (F.month(F.col("fromdate")) <= i) & (i <= F.month(F.col("thrudate"))),
                F.col("max_rate"),
            ).otherwise(F.lit(None)),
        )

    agg_exprs = []

    for i in range(1, 13):
        agg_exprs.extend(
            [
                F.countDistinct(f"rate{i }").alias(f"count{i }"),
                F.max(f"rate{i }").alias(f"max{i }"),
                F.min(f"rate{i }").alias(f"min{i }"),
            ]
        )

    high_low_count = high_low.groupBy("wslr", "bnd", "line", "alc_ind").agg(*agg_exprs)

    for i in range(1, 13):
        high_low_count = high_low_count.withColumn(
            f"hlCnt{i }", F.when(F.col(f"count{i }") > 1, 1).otherwise(0)
        ).withColumn(
            f"factor{i }",
            F.when(
                F.col(f"min{i }") > 0,
                F.when((F.col(f"max{i }") / F.col(f"min{i }") * 1.25) > 5, 5).otherwise(
                    F.col(f"max{i }") / F.col(f"min{i }") * 1.25
                ),
            ).otherwise(F.lit(1)),
        )

    hlcnt_cols = [f"hlCnt{i }" for i in range(1, 13)]
    high_low_count = high_low_count.withColumn(
        "hlCntSum", reduce(add, [F.col(c) for c in hlcnt_cols])
    )

    high_low_count = high_low_count.filter(F.col("hlCntSum") >= 2)

    high_low_count = high_low_count.drop(*hlcnt_cols).drop("hlCntSum")


    rate_weights_gm = rate_weights_gm.join(
        F.broadcast(high_low_count), ["wslr", "bnd", "line", "alc_ind"], "left"
    )


    condition = (
        (F.col("rtl_level") == "1")
        & (F.col("civmil") == "B")
        & (F.col("on_off_prem") == "B")
    )
    for i in range(1, 13):
        max_rates_col = f"maxRates{i }"
        highr_col = f"max{i }"
        promo_days_cols = f"promoDays{i }"
        factor_col = f"factor{i }"
        rate_weights_gm = rate_weights_gm.withColumn(
            promo_days_cols,
            F.when(
                condition & (F.col(max_rates_col) == F.col(highr_col)),
                F.col(promo_days_cols) * F.col(factor_col),
            ).otherwise(F.col(promo_days_cols)),
        )

    alc_cnts = rate_weights_gm

    for alc_type, col_prefix in [("A", "BothCnt"), ("S", "StrongCnt"), ("W", "WeakCnt")]:
        for i in range(1, 13):
            max_rates_col = f"maxRates{i }"
            cnt_col = f"{col_prefix }{i }"
            alc_cnts = alc_cnts.withColumn(
                cnt_col,
                F.when(
                    F.col(max_rates_col).isNotNull() & (F.col("alc_ind") == alc_type),
                    F.lit(1),
                ).otherwise(F.lit(0)),
            )


    both_cnt_cols = [f"BothCnt{i }" for i in range(1, 13)]
    strong_cnt_cols = [f"StrongCnt{i }" for i in range(1, 13)]
    weak_cnt_cols = [f"WeakCnt{i }" for i in range(1, 13)]
    all_cnt_cols = both_cnt_cols + strong_cnt_cols + weak_cnt_cols

    alc_cnts = alc_cnts.groupBy("wslr", "bnd", "line").agg(
        *[F.sum(col).alias(col) for col in all_cnt_cols]
    )

    wslr_st = wslr_info_temp.select("wslr", "state")

    rate_weights_gm = rate_weights_gm.join(F.broadcast(wslr_st), ["wslr"], "left")

    rate_weights_gm = rate_weights_gm.join(F.broadcast(makefamsmart_df1), "bnd", "left")
    rate_weights_gm = rate_weights_gm.withColumn(
        "family", F.coalesce(F.col("family"), F.lit(DEFAULT_FAM))
    )

    rate_weights_gm = rate_weights_gm.join(alc_cnts, ["wslr", "bnd", "line"], "inner")

    alc_weight = spark.read.table(
        TU.get_fully_qualified_table_name("finance", "maco", "alc_weight")
    ).selectExpr(
        "mkt_ln_cd as line",
        "wslr_st_cd as state",
        "custom_family_nm as family",
        "strong_alc_wt as strongwgt",
        "weak_alc_wt as weakwgt",
    )


    alc_weight_st_fam = spark.read.table(
        TU.get_fully_qualified_table_name("finance", "maco", "alc_st_fam_weight")
    ).selectExpr(
        "wslr_st_cd as state",
        "custom_family_nm as family",
        "brnd_grp_strong_alc_wt as FamStrongWgt",
        "brnd_grp_weak_alc_wt as FamweakWgt",
    )


    rate_weights_gm = rate_weights_gm.join(
        F.broadcast(alc_weight), ["state", "family", "line"], "left"
    )
    rate_weights_gm = rate_weights_gm.join(
        F.broadcast(alc_weight_st_fam), ["state", "family"], "left"
    )


    rate_weights_gm = rate_weights_gm.withColumn(
        "WeakWgt",
        F.when(F.col("StrongWgt").isNull(), F.col("FamWeakWgt")).otherwise(
            F.col("WeakWgt")
        ),
    ).withColumn(
        "StrongWgt",
        F.when(F.col("StrongWgt").isNull(), F.col("FamStrongWgt")).otherwise(
            F.col("StrongWgt")
        ),
    )

    rate_weights_gm = rate_weights_gm.fillna({"StrongWgt": 0, "weakWgt": 0})
    rate_weights_gm = rate_weights_gm.withColumn(
        "StrongFactor",
        F.when(
            (F.col("StrongWgt") > 0) & (F.col("WeakWgt") > 0),
            F.col("StrongWgt") / F.col("WeakWgt"),
        ).otherwise(F.lit(1)),
    )

    base_condition = (
        (F.col("civmil") == "B") & (F.col("on_off_prem") == "B") & (F.col("alc_ind") == "S")
    )

    promo_transforms = {}
    for i in range(1, 13):
        promo_col = f"promoDays{i }"
        both_cnt_col = f"BothCnt{i }"
        strong_cnt_col = f"StrongCnt{i }"
        weak_cnt_col = f"WeakCnt{i }"

        promo_transforms[promo_col] = (
            F.when(
                base_condition
                & (F.col(both_cnt_col) == 0)
                & (F.col(strong_cnt_col) > 0)
                & (F.col(weak_cnt_col) > 0),
                F.col(promo_col) * F.col("StrongFactor"),
            )
            .otherwise(F.col(promo_col))
            .alias(promo_col)
        )

    existing_cols = [
        col for col in rate_weights_gm.columns if not col.startswith("promoDays")
    ]
    select_exprs = [F.col(col) for col in existing_cols] + list(promo_transforms.values())
    rate_weights_gm = rate_weights_gm.select(*select_exprs)

    monthly_transforms = {}
    other_cols = [
        col
        for col in rate_weights_gm.columns
        if not col.startswith("maxRates")
        and not col.startswith("maxDisc")
        and not col.startswith("promoDays")
    ]

    for i in range(1, 13):
        promo_days_col = f"promoDays{i }"
        monthly_transforms[promo_days_col] = F.coalesce(
            F.col(promo_days_col), F.lit(0)
        ).alias(promo_days_col)

    for i in range(1, 13):
        max_rates_col = f"maxRates{i }"
        promo_days_col = f"promoDays{i }"
        max_disc_col = f"maxDisc{i }"

        monthly_transforms[max_rates_col] = (
            F.coalesce(F.col(max_rates_col), F.lit(0))
            * F.coalesce(F.col(promo_days_col), F.lit(0))
        ).alias(max_rates_col)
        monthly_transforms[max_disc_col] = (
            F.coalesce(F.col(max_disc_col), F.lit(0))
            * F.coalesce(F.col(promo_days_col), F.lit(0))
        ).alias(max_disc_col)

    select_exprs = [F.col(col) for col in other_cols] + list(monthly_transforms.values())
    rate_weights_gm = rate_weights_gm.select(*select_exprs)

    promo_cols = [f"promoDays{i }" for i in range(1, 13)]
    rate_weights_days = rate_weights.groupBy(["wslr", "bnd", "line", "rtl_level"]).agg(
        *[F.sum(F.col(c)).alias(c) for c in promo_cols]
    )

    rate_weights_gm_days = rate_weights_gm.groupBy(
        ["wslr", "bnd", "line", "rtl_level"]
    ).agg(*[F.sum(F.col(c)).alias(c) for c in promo_cols])

    rate_weights = rate_weights.drop(
        "promoDays1",
        "promoDays2",
        "promoDays3",
        "promoDays4",
        "promoDays5",
        "promoDays6",
        "promoDays7",
        "promoDays8",
        "promoDays9",
        "promoDays10",
        "promoDays11",
        "promoDays12",
    )
    rate_weights_gm = rate_weights_gm.drop(
        "promoDays1",
        "promoDays2",
        "promoDays3",
        "promoDays4",
        "promoDays5",
        "promoDays6",
        "promoDays7",
        "promoDays8",
        "promoDays9",
        "promoDays10",
        "promoDays11",
        "promoDays12",
    )

    rate_weights = rate_weights.join(
        rate_weights_days, ["wslr", "bnd", "line", "rtl_level"], "inner"
    )

    rate_weights_gm = rate_weights_gm.join(
        rate_weights_gm_days, ["wslr", "bnd", "line", "rtl_level"], "inner"
    )
    for i in range(1, 13):
        promo_col = f"promoDays{i }"
        rate_col = f"maxRates{i }"
        disc_col = f"maxDisc{i }"

        rate_weights = rate_weights.withColumn(
            rate_col,
            F.when(F.col(promo_col) > 0, F.col(rate_col) / F.col(promo_col)).otherwise(
                F.lit(0)
            ),
        )

        rate_weights = rate_weights.withColumn(
            disc_col,
            F.when(F.col(promo_col) > 0, F.col(disc_col) / F.col(promo_col)).otherwise(
                F.lit(0)
            ),
        )

    for i in range(1, 13):
        promo_col = f"promoDays{i }"
        rate_col = f"maxRates{i }"
        disc_col = f"maxDisc{i }"

        rate_weights_gm = rate_weights_gm.withColumn(
            rate_col,
            F.when(F.col(promo_col) > 0, F.col(rate_col) / F.col(promo_col)).otherwise(
                F.lit(0)
            ),
        )

        rate_weights_gm = rate_weights_gm.withColumn(
            disc_col,
            F.when(F.col(promo_col) > 0, F.col(disc_col) / F.col(promo_col)).otherwise(
                F.lit(0)
            ),
        )

    max_rates_cols = [f"maxRates{i }" for i in range(1, 13)]
    max_disc_cols = [f"maxDisc{i }" for i in range(1, 13)]
    sum_cols = max_rates_cols + max_disc_cols

    rate_weights = rate_weights.groupBy("wslr", "bnd", "line", "rtl_level").agg(
        *[F.sum(F.col(c)).alias(c) for c in sum_cols]
    )
    rate_weights_gm = rate_weights_gm.groupBy("wslr", "bnd", "line", "rtl_level").agg(
        *[F.sum(F.col(c)).alias(c) for c in sum_cols]
    )

    rate_weights = rate_weights.unionByName(rate_weights_gm)

    rate_weights.write.mode("overwrite").option("overwriteSchema", "true").saveAsTable(
        "rateweights_temp_1"
    )
    rate_weights = spark.table("rateweights_temp_1")

    logger.info("CHECKPOINT 6A: Rate weights union completed and saved to rateweights_temp_1")

    pyramid_weights = (
        spark.read.table(
            TU.get_fully_qualified_table_name(
                "finance", "maco", "pyramid_weights"
            )
        )
        .withColumnRenamed("wslr_nbr", "wslr")
        .withColumnRenamed("brnd_cd", "bnd")
        .withColumnRenamed("mkt_ln_cd", "line")
        .withColumnRenamed("rtl_lvl", "rtl_level")
        .withColumnRenamed("adj_grss_prmtd_vol","adjGpv")
        .withColumn(
            "gm_vol", F.when(F.col("rtl_level") == 1, F.col("adjGpv")).otherwise(F.lit(0))
        )
    )

    pyramid_weights = pyramid_weights.withColumn(
        "line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit('')))\
            .withColumn(
        "wslr", F.coalesce(F.lpad(F.col("wslr"),5,'0'),F.lit('')))

    wslr_info = wslr_info_temp.select("wslr", "state")

    pyramid_weights = pyramid_weights.join(wslr_info, ["wslr"], "left")

    pyramid_weights = pyramid_weights.cache()

    pyramid_weights_stgm = (
        pyramid_weights.groupBy("state")
        .agg(F.sum("gm_vol").alias("gm_vol"), F.sum("adjGpv").alias("adjGpv"))
        .withColumn("state_GM_per", F.col("gm_vol") / F.col("adjGpv"))
        .select("state", "state_GM_per")
    )


    pyramid_weights_tot = pyramid_weights.groupBy("wslr", "bnd", "line").agg(
        F.sum("adjGpv").alias("tot_adjGpv")
    )
    pyramid_weights = (
        pyramid_weights.join(pyramid_weights_tot, ["wslr", "bnd", "line"], "inner")
        .withColumn("level_percent", F.col("adjGpv") / F.col("tot_adjGpv"))
        .select("wslr", "bnd", "line", "rtl_level", "level_percent", "adjGpv")
    )


    pyramid_weights_wfl = (
        pyramid_weights.join(makefamsmart_df1, "bnd", "left")
        .withColumn("family", F.coalesce(F.col("family"), F.lit(DEFAULT_FAM)))
        .groupBy("wslr", "family", "line", "rtl_level")
        .agg(F.sum("adjGpv").alias("adjGpv"))
    )


    tpyramid_weights_wfl = pyramid_weights_wfl.groupBy("wslr", "family", "line").agg(
        F.sum("adjGpv").alias("tot_adjGpv")
    )
    pyramid_weights_wfl = (
        pyramid_weights_wfl.join(tpyramid_weights_wfl, ["wslr", "family", "line"], "inner")
        .withColumnRenamed("adjGpv", "wfl_adjGpv")
        .withColumn("wfl_level_percent", F.col("wfl_adjGpv") / F.col("tot_adjGpv"))
    )
    pyramid_weights_wfl = pyramid_weights_wfl.select(
        "wslr", "family", "line", "rtl_level", "wfl_level_percent", "wfl_adjGpv"
    )

    wslr_info = wslr_info.orderBy("wslr").dropDuplicates(["wslr"])
    pyramid_weights_sfl = (
        pyramid_weights_wfl.join(wslr_info, ["wslr"], "left")
        .withColumnRenamed("wfl_adjGpv", "adjGpv")
        .groupBy("state", "family", "line", "rtl_level")
        .agg(F.sum("adjGpv").alias("adjGpv"))
    )

    tpyramid_weights_sfl = pyramid_weights_sfl.groupBy("state", "family", "line").agg(
        F.sum("adjGpv").alias("tot_adjGpv")
    )
    pyramid_weights_sfl = (
        pyramid_weights_sfl.join(tpyramid_weights_sfl, ["state", "family", "line"], "inner")
        .withColumnRenamed("adjGpv", "sfl_adjGpv")
        .withColumn("sfl_level_percent", F.col("sfl_adjGpv") / F.col("tot_adjGpv"))
        .select("state", "family", "line", "rtl_level", "sfl_level_percent", "sfl_adjGpv")
    )


    rate_weights = rate_weights.join(
        pyramid_weights, ["wslr", "bnd", "line", "rtl_level"], "left"
    )

    rate_check = (
        rate_weights.withColumn("adjGPV", F.coalesce(F.col("adjGpv"), F.lit(0)))
        .select("wslr", "bnd", "line", "adjGPV")
        .groupBy("wslr", "bnd", "line")
        .agg(F.sum("adjGPV").alias("adjGpv"))
        .filter(F.col("adjGpv") == 0)
        .select("wslr", "bnd", "line")
    )

    pyramid_weights_found = pyramid_weights.withColumn("wghtLevel", F.lit("WBL")).select(
        "wslr", "bnd", "line", "wghtLevel"
    )

    pyramid_weights.unpersist()

    pyramid_weights_found = pyramid_weights_found.dropDuplicates(["wslr", "bnd", "line"])

    pyramid_weights_found = pyramid_weights_found.join(
        rate_check, ["wslr", "bnd", "line"], "left_anti"
    )

    rate_weights = rate_weights.join(pyramid_weights_found, ["wslr", "bnd", "line"], "left")

    rate_weights = rate_weights.join(makefamsmart_df1, "bnd", "left").withColumn(
        "family", F.coalesce(F.col("family"), F.lit(DEFAULT_FAM))
    )


    rate_weights = rate_weights.select(
        "wslr",
        "family",
        "bnd",
        "line",
        "rtl_level",
        "maxRates1",
        "maxRates2",
        "maxRates3",
        "maxRates4",
        "maxRates5",
        "maxRates6",
        "maxRates7",
        "maxRates8",
        "maxRates9",
        "maxRates10",
        "maxRates11",
        "maxRates12",
        "maxDisc1",
        "maxDisc2",
        "maxDisc3",
        "maxDisc4",
        "maxDisc5",
        "maxDisc6",
        "maxDisc7",
        "maxDisc8",
        "maxDisc9",
        "maxDisc10",
        "maxDisc11",
        "maxDisc12",
        "adjGpv",
        "level_percent",
        "wghtLevel",
    )

    rate_weights = rate_weights.join(
        pyramid_weights_wfl, ["wslr", "family", "line", "rtl_level"], "left"
    )

    rate_weights = (
        rate_weights.withColumn(
            "adjGpv_new",
            F.when(
                (F.col("wghtLevel").isin(["", "   "]))
                | (F.col("wghtLevel").isNull())
                & F.col("adjGpv").isNull()
                & F.col("wfl_adjGpv").isNotNull(),
                F.col("wfl_adjGpv"),
            ).otherwise(F.col("adjGpv")),
        )
        .withColumn(
            "level_percent",
            F.when(
                (F.col("wghtLevel").isin(["", "   "]) | (F.col("wghtLevel").isNull()))
                & F.col("adjGpv").isNull()
                & F.col("wfl_adjGpv").isNotNull(),
                F.col("wfl_level_percent"),
            ).otherwise(F.col("level_percent")),
        )
        .withColumn(
            "wghtLevel",
            F.when(
                (F.col("wghtLevel").isin(["", "   "]) | (F.col("wghtLevel").isNull()))
                & F.col("adjGpv").isNull()
                & F.col("wfl_adjGpv").isNotNull(),
                F.lit("WFL"),
            ).otherwise(F.col("wghtLevel")),
        )
        .drop("wfl_level_percent", "wfl_adjGpv", "adjGpv")
        .withColumnRenamed("adjGpv_new", "adjGpv")
    )

    rate_check = (
        rate_weights.withColumn("adjGPV", F.coalesce(F.col("adjGpv"), F.lit(0)))
        .select("wslr", "bnd", "line", "adjGpv")
        .groupBy("wslr", "bnd", "line")
        .agg(F.sum("adjGPV").alias("adjGpv"))
        .filter(F.col("adjGpv") == 0)
        .select("wslr", "bnd", "line")
    )

    pyramid_weights_found_wfl = (
        rate_weights.filter(F.col("wghtLevel") == "WFL")
        .select("wslr", "bnd", "line")
        .dropDuplicates(["wslr", "bnd", "line"])
    )

    pyramid_weights_found_wfl = pyramid_weights_found_wfl.join(
        F.broadcast(rate_check), ["wslr", "bnd", "line"], "left_anti"
    ).withColumn("matched", F.lit(1))

    rate_weights = (
        rate_weights.join(pyramid_weights_found_wfl, ["wslr", "bnd", "line"], "left")
        .withColumn(
            "wghtLevel",
            F.when(F.col("matched") == 1, F.lit("WFL")).otherwise(F.col("wghtLevel")),
        )
        .drop("matched")
        .join(wslr_info, ["wslr"], "left")
        .join(pyramid_weights_sfl, ["state", "family", "line", "rtl_level"], "left")
        .withColumn(
            "adjGpv_new",
            F.when(
                (F.col("wghtLevel").isin(["", "   "]) | (F.col("wghtLevel").isNull()))
                & F.col("adjGpv").isNull()
                & F.col("sfl_adjGpv").isNotNull(),
                F.col("sfl_adjGpv"),
            ).otherwise(F.col("adjGpv")),
        )
        .withColumn(
            "level_percent",
            F.when(
                (F.col("wghtLevel").isin(["", "   "]) | (F.col("wghtLevel").isNull()))
                & F.col("adjGpv").isNull()
                & F.col("sfl_adjGpv").isNotNull(),
                F.col("sfl_level_percent"),
            ).otherwise(F.col("level_percent")),
        )
        .withColumn(
            "wghtLevel",
            F.when(
                (F.col("wghtLevel").isin(["", "   "]) | (F.col("wghtLevel").isNull()))
                & F.col("adjGpv").isNull()
                & F.col("sfl_adjGpv").isNotNull(),
                F.lit("SFL"),
            ).otherwise(F.col("wghtLevel")),
        )
        .drop("sfl_level_percent", "sfl_adjGpv", "adjGpv")
        .withColumnRenamed("adjGpv_new", "adjGpv")
    )

    rate_check = (
        rate_weights.withColumn("adjGPV", F.coalesce(F.col("adjGpv"), F.lit(0)))
        .select("wslr", "bnd", "line", "adjGpv")
        .groupBy("wslr", "bnd", "line")
        .agg(F.sum("adjGPV").alias("adjGpv"))
        .filter(F.col("adjGpv") == 0)
        .select("wslr", "bnd", "line")
    )

    pyramid_weights_found_sfl = (
        rate_weights.filter(F.col("wghtLevel") == "SFL")
        .select("wslr", "bnd", "line")
        .distinct()
        .join(
            F.broadcast(rate_check.select("wslr", "bnd", "line").distinct()),
            ["wslr", "bnd", "line"],
            "left_anti",
        )
        .withColumn("matched", F.lit(1))
    )

    rate_weights = (
        rate_weights.join(pyramid_weights_found_sfl, ["wslr", "bnd", "line"], "left")
        .withColumn(
            "wghtLevel",
            F.when(F.col("matched") == 1, F.lit("SFL")).otherwise(F.col("wghtLevel")),
        )
        .drop("matched")
    )

    rate_weights = (
        rate_weights.join(F.broadcast(pyramid_weights_stgm), ["state"], "left")
        .withColumn(
            "state_GM_per",
            F.when(F.col("state_GM_per").isNull(), F.lit(0.95)).otherwise(
                F.col("state_GM_per")
            ),
        )
        .withColumn(
            "state_GM_per",
            F.when(F.col("state_GM_per") > 0.95, F.lit(0.95)).otherwise(
                F.col("state_GM_per")
            ),
        )
        .withColumn("pyramidTierCnt", F.lit(1))
    )

    rate_weights.write.mode("overwrite").option("overwriteSchema", "true").saveAsTable(
        "rateweights_temp_2"
    )
    rate_weights = spark.table("rateweights_temp_2")
    

    rate_weights_tier_cnt = rate_weights.groupBy("wslr", "bnd", "line").agg(
        F.sum("pyramidTierCnt").alias("pyramidTierCnt"), F.sum("adjGpv").alias("tot_adjGpv")
    )

    rate_weights_base = rate_weights.drop("pyramidTierCnt").alias("base")

    rate_weights_tier_cnt_agg = rate_weights_tier_cnt.alias("agg")

    rate_weights = rate_weights_base.join(
        rate_weights_tier_cnt_agg, ["wslr", "bnd", "line"], "inner"
    ).select(F.col("base.*"), F.col("agg.pyramidTierCnt"), F.col("agg.tot_adjGpv"))

    rate_weights = (
        rate_weights.withColumn(
            "tot_adjGpv",
            F.when(
                (F.col("adjGpv").isNull()) & (F.col("pyramidTierCnt") == 1), F.lit(99999)
            ).otherwise(F.col("tot_adjGpv")),
        )
        .withColumn(
            "level_percent",
            F.when(
                (F.col("adjGpv").isNull()) & (F.col("pyramidTierCnt") == 1), F.lit(1)
            ).otherwise(F.col("level_percent")),
        )
        .withColumn(
            "wghtLevel",
            F.when(
                (F.col("adjGpv").isNull()) & (F.col("pyramidTierCnt") == 1), F.lit("999")
            ).otherwise(F.col("wghtLevel")),
        )
        .withColumn(
            "adjGpv",
            F.when(
                (F.col("adjGpv").isNull()) & (F.col("pyramidTierCnt") == 1), F.lit(99999)
            ).otherwise(F.col("adjGpv")),
        )
    )


    rate_weights = (
        rate_weights.withColumn(
            "adjGpv_new",
            F.when(
                (F.col("adjGpv").isNull())
                & (F.col("pyramidTierCnt") > 1)
                & ((F.col("wghtLevel").isin("", "   ")) | (F.col("wghtLevel").isNull())),
                F.lit(99999),
            ).otherwise(F.col("adjGpv")),
        )
        .withColumn(
            "tot_adjGpv",
            F.when(
                (F.col("adjGpv").isNull())
                & (F.col("pyramidTierCnt") > 1)
                & ((F.col("wghtLevel").isin("", "   ")) | (F.col("wghtLevel").isNull())),
                F.lit(99999),
            ).otherwise(F.col("tot_adjGpv")),
        )
        .withColumn(
            "level_percent",
            F.when(
                (F.col("adjGpv").isNull())
                & (F.col("pyramidTierCnt") > 1)
                & ((F.col("wghtLevel").isin("", "   ")) | (F.col("wghtLevel").isNull())),
                F.lit(1) / F.col("pyramidTierCnt"),
            ).otherwise(F.col("level_percent")),
        )
        .withColumn(
            "wghtLevel",
            F.when(
                (F.col("adjGpv").isNull())
                & (F.col("pyramidTierCnt") > 1)
                & ((F.col("wghtLevel").isin("", "   ")) | (F.col("wghtLevel").isNull())),
                F.lit("AVG"),
            ).otherwise(F.col("wghtLevel")),
        )
        .drop("adjGpv")
        .withColumnRenamed("adjGpv_new", "adjGpv")
    )

    rate_weights2thru5 = rate_weights.filter(
        (F.col("rtl_level") != 1) & (F.col("level_percent").isNotNull())
    ).coalesce(15)


    rate_weights2thru5 = rate_weights2thru5.groupBy(["wslr", "bnd", "line"]).agg(
        F.mean(F.col("level_percent")).alias("level_percent2thru5")
    )

    rate_weights = rate_weights.join(rate_weights2thru5, ["wslr", "bnd", "line"], "left")


    pyramid_cols = [f"pyramidWght{i }" for i in range(1, 13)]
    max_rate_cols = [f"maxRates{i }" for i in range(1, 13)]

    for i in range(12):
        rate_weights = rate_weights.withColumn(pyramid_cols[i], F.lit(0))

    for i in range(12):
        rate_weights = rate_weights.withColumn(
            pyramid_cols[i],
            F.when(F.col(max_rate_cols[i]) != 0, F.col("level_percent")).otherwise(
                F.col(pyramid_cols[i])
            ),
        )

    for i in range(1, 13):
        pyramid_col = f"pyramidWght{i }"
        add_level_one_col = f"addLevelOne{i }"
        add_lower_level_col = f"addLowerLevel{i }"

        rate_weights = rate_weights.withColumn(
            add_lower_level_col,
            F.when(
                F.col("tot_adjGPV").isNotNull()
                & (F.col("rtl_level") != 1)
                & F.col(pyramid_col).isNull()
                & F.col("level_percent2thru5").isNull(),
                F.lit(1),
            ).otherwise(F.lit(0)),
        )

        rate_weights = rate_weights.withColumn(
            add_level_one_col,
            F.when(
                F.col("tot_adjGPV").isNotNull()
                & (F.col("rtl_level") == 1)
                & F.col(pyramid_col).isNull(),
                F.lit(1),
            ).otherwise(F.lit(0)),
        )

        rate_weights = rate_weights.withColumn(
            pyramid_col,
            F.when(
                F.col("tot_adjGPV").isNotNull()
                & (F.col("rtl_level") != 1)
                & F.col(pyramid_col).isNull(),
                F.when(
                    F.col("level_percent2thru5").isNotNull(), F.col("level_percent2thru5")
                ).otherwise(F.lit(0.05)),
            )
            .when(
                F.col("tot_adjGPV").isNotNull()
                & (F.col("rtl_level") == 1)
                & F.col(pyramid_col).isNull(),
                F.col("state_GM_per"),
            )
            .otherwise(F.col(pyramid_col)),
        )

    pyramid_cols = [f"pyramidWght{i }" for i in range(1, 13)]
    add_level_one_cols = [f"addLevelOne{i }" for i in range(1, 13)]
    add_lower_level_cols = [f"addLowerLevel{i }" for i in range(1, 13)]

    agg_exprs = (
        [F.sum(col).alias(f"tot_{col }") for col in pyramid_cols]
        + [F.sum(col).alias(col) for col in add_level_one_cols]
        + [F.sum(col).alias(col) for col in add_lower_level_cols]
    )

    rate_weights_tot = rate_weights.groupBy("wslr", "bnd", "line").agg(*agg_exprs)

    rate_weights = rate_weights.drop(
        "addLevelOne1",
        "addLevelOne2",
        "addLevelOne3",
        "addLevelOne4",
        "addLevelOne5",
        "addLevelOne6",
        "addLevelOne7",
        "addLevelOne8",
        "addLevelOne9",
        "addLevelOne10",
        "addLevelOne11",
        "addLevelOne12",
        "addLowerLevel1",
        "addLowerLevel2",
        "addLowerLevel3",
        "addLowerLevel4",
        "addLowerLevel5",
        "addLowerLevel6",
        "addLowerLevel7",
        "addLowerLevel8",
        "addLowerLevel9",
        "addLowerLevel10",
        "addLowerLevel11",
        "addLowerLevel12",
    )


    rate_weights = rate_weights.join(rate_weights_tot, ["wslr", "bnd", "line"], "inner")


    for i in range(1, 13):
        pyramid_col = f"pyramidWght{i }"
        tot_col = f"tot_pyramidWght{i }"
        adj_col = f"adjPyramidWght{i }"

        rate_weights = rate_weights.withColumn(
            adj_col,
            F.when(F.col(tot_col) > 0, F.col(pyramid_col) / F.col(tot_col)).otherwise(0),
        )

    adj_rate_weights2thru5 = rate_weights.filter(F.col("rtl_level") != 1)

    adj_rate_weights2thru5 = adj_rate_weights2thru5.orderBy(["wslr", "bnd", "line"])

    adj_cols = [f"adjPyramidWght{i }" for i in range(1, 13)]
    output_cols = [f"adjWghtTwoThruFive{i }" for i in range(1, 13)]

    agg_exprs = [F.sum(F.col(c)).alias(o) for c, o in zip(adj_cols, output_cols)]

    adj_rate_weights2thru5 = adj_rate_weights2thru5.groupBy("wslr", "bnd", "line").agg(
        *agg_exprs
    )

    rate_weights = rate_weights.join(
        adj_rate_weights2thru5, ["wslr", "bnd", "line"], "left"
    )
    has_gm = rate_weights

    for i in range(1, 13):
        pyramid_col = f"pyramidWght{i }"
        has_gm_col = f"hasGM{i }"

        has_gm = has_gm.withColumn(
            has_gm_col,
            F.when(
                (F.col("rtl_level") == 1)
                & (F.col(pyramid_col).isNotNull())
                & (F.col(pyramid_col) != 0),
                F.lit(1),
            ).otherwise(F.lit(0)),
        )

    has_gm_cols = [f"hasGM{i }" for i in range(1, 13)]

    agg_exprs = [F.sum(col).alias(col) for col in has_gm_cols]

    has_gm = has_gm.groupBy("wslr", "bnd", "line").agg(*agg_exprs)

    rate_weights = rate_weights.join(has_gm, ["wslr", "bnd", "line"], "inner")
    pyramid_tier_cnt = rate_weights

    for i in range(1, 13):
        max_rate_col = f"maxRates{i }"
        tier_cnt_col = f"pyramidTierCnt{i }"

        pyramid_tier_cnt = pyramid_tier_cnt.withColumn(
            tier_cnt_col, F.when(F.col(max_rate_col) > 0, 1).otherwise(0)
        )


    pyramid_tier_cnt_cols = [f"pyramidTierCnt{i }" for i in range(1, 13)]

    agg_exprs = [F.sum(col).alias(col) for col in pyramid_tier_cnt_cols]

    pyramid_tier_cnt = pyramid_tier_cnt.groupBy("wslr", "bnd", "line").agg(*agg_exprs)


    rate_weights = rate_weights.drop("pyramidTierCnt")

    rate_weights = rate_weights.join(pyramid_tier_cnt, ["wslr", "bnd", "line"], "inner")

    for i in range(1, 13):

        pyramid_col = f"pyramidWght{i }"
        adj_col = f"adjPyramidWght{i }"
        add_level_one_col = f"addLevelOne{i }"
        add_lower_level_col = f"addLowerLevel{i }"
        adj_two_five_col = f"adjWghtTwoThruFive{i }"
        max_rate_col = f"maxRates{i }"
        has_gm_col = f"hasGM{i }"
        tier_cnt_col = f"pyramidTierCnt{i }"

        rate_weights = rate_weights.withColumn(
            adj_col,
            F.when(
                (F.col(add_level_one_col) >= 1)
                & (F.col("rtl_level") == 1)
                & (F.col(tier_cnt_col) > 1)
                & F.col(pyramid_col).isNotNull()
                & (F.col(pyramid_col) != 0),
                F.col("state_GM_per"),
            )
            .when(
                (F.col(add_level_one_col) >= 1)
                & (F.col("rtl_level") != 1)
                & (F.col(tier_cnt_col) > 1)
                & F.col(pyramid_col).isNotNull()
                & (F.col(pyramid_col) != 0),
                (F.col(adj_col) / F.col(adj_two_five_col)) * (1 - F.col("state_GM_per")),
            )
            .when(
                (F.col(add_level_one_col) >= 1)
                & (F.col("rtl_level") == 1)
                & (F.col(tier_cnt_col) == 1),
                F.lit(1),
            )
            .otherwise(F.col(adj_col)),
        )

        rate_weights = rate_weights.withColumn(
            adj_col,
            F.when(
                (F.col(add_lower_level_col) >= 1)
                & (F.col("rtl_level") == 1)
                & F.col(pyramid_col).isNotNull()
                & (F.col(pyramid_col) != 0),
                F.col("state_GM_per"),
            )
            .when(
                (F.col(add_lower_level_col) >= 1)
                & (F.col("rtl_level") != 1)
                & (F.col(has_gm_col) >= 1)
                & F.col(pyramid_col).isNotNull()
                & (F.col(pyramid_col) != 0),
                (F.col(adj_col) / F.col(adj_two_five_col)) * (1 - F.col("state_GM_per")),
            )
            .otherwise(F.col(adj_col)),
        )

        rate_weights = rate_weights.withColumn(
            adj_col,
            F.when(
                (F.col("wghtLevel") == "AVG")
                & (F.col("rtl_level") == 1)
                & (F.col(has_gm_col) >= 1)
                & (F.col(tier_cnt_col) > 1)
                & F.col(pyramid_col).isNotNull()
                & (F.col(pyramid_col) != 0),
                F.col("state_GM_per"),
            )
            .when(
                (F.col("wghtLevel") == "AVG")
                & (F.col("rtl_level") != 1)
                & (F.col(has_gm_col) >= 1)
                & (F.col(tier_cnt_col) > 1),
                (1 - F.col("state_GM_per")) / (F.col(tier_cnt_col) - 1),
            )
            .when(
                (F.col("wghtLevel") == "AVG")
                & (F.col("rtl_level") == 1)
                & (F.col(has_gm_col) >= 1)
                & (F.col(tier_cnt_col) == 1),
                F.lit(1),
            )
            .otherwise(F.col(adj_col)),
        )

        rate_weights = rate_weights.withColumn(
            adj_col, F.when(F.col(max_rate_col) == 0, F.lit(0)).otherwise(F.col(adj_col))
        )
    columns_to_keep = (
        ["wslr", "bnd", "line", "rtl_level", "wghtLevel", "state_GM_per", "adjGpv"]
        + [f"maxRates{i }" for i in range(1, 13)]
        + [f"adjPyramidWght{i }" for i in range(1, 13)]
        + [f"maxDisc{i }" for i in range(1, 13)]
    )

    column_rename_map = {
        "wslr": "wslr_nbr",
        "bnd": "brnd_cd",
        "line": "mkt_ln_cd",
        "rtl_level": "rtl_lvl",
        "adjGpv": "adj_grss_prmtd_vol",
        "wghtLevel": "weight_lvl",
        "state_GM_per": "st_gen_mkt_pct",
    }

    for i in range(1, 13):
        column_rename_map[f"maxRates{i }"] = f"max_rate_{i }"
        column_rename_map[f"maxDisc{i }"] = f"curr_max_disc_amt_{i }"
        column_rename_map[f"adjPyramidWght{i }"] = f"adj_pyramid_wght_{i }"

    rate_weights = rate_weights.select(*columns_to_keep)
    rateweights_out = rate_weights
    for internal_name, external_name in column_rename_map.items():
        if internal_name in rateweights_out.columns:
            rateweights_out = rateweights_out.withColumnRenamed(
                internal_name, external_name
            )

    rateweights_out.write.mode("overwrite").option("overwriteSchema", "true").saveAsTable(
        "rate_weights_intermediate"
    )

    
    

    rate_weights1 = spark.read.table("rate_weights_intermediate")

    reverse_column_rename_map = {
        external_name: internal_name
        for internal_name, external_name in column_rename_map.items()
    }
    for external_name, internal_name in reverse_column_rename_map.items():
        if external_name in rate_weights1.columns:
            rate_weights1 = rate_weights1.withColumnRenamed(external_name, internal_name)

    rate_weights_transforms = {}
    for i in range(1, 13):
        max_rate_col = f"maxRates{i }"
        max_disc_col = f"maxDisc{i }"
        adj_col = f"adjPyramidWght{i }"

        rate_weights_transforms[max_rate_col] = F.col(max_rate_col) * F.col(adj_col)
        rate_weights_transforms[max_disc_col] = F.col(max_disc_col) * F.col(adj_col)

    rate_weights1 = rate_weights1.withColumns(rate_weights_transforms)
    rate_weights1 = rate_weights1.drop("state_GM_per", "adjGpv")

    max_rates_cols = [f"maxRates{i }" for i in range(1, 13)]
    max_disc_cols = [f"maxDisc{i }" for i in range(1, 13)]

    agg_exprs = [F.sum(col).alias(col) for col in max_rates_cols] + [
        F.sum(col).alias(col) for col in max_disc_cols
    ]

    rate_weights1 = rate_weights1.groupBy("wslr", "bnd", "line").agg(*agg_exprs)


    logger.info("CHECKPOINT 6B: Completed pyramid weight adjustments and aggregation")

    qd_tier_cnt = forecast_data.groupBy("wslr", "bnd", "line", "qd_group").agg(
        F.count("*").alias("_freq_")
    )

    forecast_data = forecast_data.join(
        qd_tier_cnt, ["wslr", "bnd", "line", "qd_group"], "inner"
    )
    forecast_data = forecast_data.withColumn(
        "becv", F.when(F.col("becv").isNull(), F.lit(0.07258065)).otherwise(F.col("becv"))
    )

    for i in range(1, 13):
        actgpv = f"actgpv{i }"
        actdol = f"actdol{i }"
        promos_offered = f"promosOffered{i }"
        disc_dol = f"discDol{i }"
        disc_max = f"discMax{i }"
        days = f"days{i }"
        maxdol = f"maxdol{i }"
        forecast_data = (
            forecast_data.withColumn(
                actgpv, F.when(F.col(actgpv).isNull(), F.lit(0)).otherwise(F.col(actgpv))
            )
            .withColumn(
                actdol, F.when(F.col(actdol).isNull(), F.lit(0)).otherwise(F.col(actdol))
            )
            .withColumn("max_rate", F.col("max_rate").cast(DecimalType(10, 4)))
            .withColumn(
                maxdol, F.round(F.col(actgpv) / F.col("becv")).cast(DecimalType(10, 5))
            )
        )
        forecast_data = (
            forecast_data.withColumn(maxdol, F.col(maxdol) * F.col("max_rate"))
            .withColumn(
                maxdol,
                F.when(F.col(actdol) > F.col(maxdol), F.col(actdol)).otherwise(
                    F.round(F.col(maxdol))
                ),
            )
            .withColumn(
                "sug_disc",
                F.when(F.col("sug_disc") == 0, F.col("max_rate") * F.lit(2)).otherwise(
                    F.col("sug_disc")
                ),
            )
            .withColumn("split", F.col("max_rate") / F.col("sug_disc"))
            .withColumn(disc_dol, (F.col(actdol) / F.col("split")))
            .withColumn(disc_max, (F.col(maxdol) / F.col("split")))
            .withColumn(promos_offered, F.lit(0))
        )
        forecast_data = (
            forecast_data.withColumn(
                promos_offered,
                F.when((F.col("_freq_") > 0) & (F.col(days) > 0), F.lit(1)).otherwise(
                    F.col(promos_offered)
                ),
            )
            .withColumn(
                days,
                F.when(
                    (F.col("_freq_") > 0) & (F.col("status") == "C"), F.lit(0)
                ).otherwise(F.col(days)),
            )
            .withColumn(
                days,
                F.when(
                    (F.col("_freq_") > 0) & (F.col("rtl_level") != "1"), F.lit(0)
                ).otherwise(F.col(days)),
            )
            .withColumn(
                days,
                F.when((F.col("_freq_") > 0), (F.col(days) / F.col("_freq_"))).otherwise(
                    F.col(days)
                ),
            )
        )
    forecast_data = forecast_data.drop("_freq_")

    actdol = [f"actdol{i }" for i in range(1, 13)]
    actgpv = [f"actgpv{i }" for i in range(1, 13)]
    days = [f"days{i }" for i in range(1, 13)]
    promos_offered = [f"promosOffered{i }" for i in range(1, 13)]
    promos_paid = [f"promosPaid{i }" for i in range(1, 13)]
    maxdol = [f"maxdol{i }" for i in range(1, 13)]
    disc_dol = [f"discDol{i }" for i in range(1, 13)]
    disc_max = [f"discMax{i }" for i in range(1, 13)]
    aappaid = [f"aappaid{i }" for i in range(1, 13)]
    aapgpv = [f"aapgpv{i }" for i in range(1, 13)]

    agg_exprs = (
        [F.sum(F.col(col_name)).alias(col_name) for col_name in actdol]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in actgpv]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in days]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in promos_offered]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in promos_paid]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in maxdol]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in disc_dol]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in disc_max]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in aappaid]
        + [F.sum(F.col(col_name)).alias(col_name) for col_name in aapgpv]
        + [F.first(F.col(col_name)).alias(col_name) for col_name in ["state", "becv"]]
    )

    forecast_data = forecast_data.groupBy("wslr", "bnd", "line").agg(*agg_exprs)

    forecast_data = forecast_data.join(rate_weights1, ["wslr", "bnd", "line"], "inner")

    forecast_data = (
        forecast_data.withColumn(
            "days1", F.when(F.col("days1") > 31, 31).otherwise(F.col("days1"))
        )
        .withColumn("days2", F.when(F.col("days2") > 28, 28).otherwise(F.col("days2")))
        .withColumn("days3", F.when(F.col("days3") > 31, 31).otherwise(F.col("days3")))
        .withColumn("days4", F.when(F.col("days4") > 30, 30).otherwise(F.col("days4")))
        .withColumn("days5", F.when(F.col("days5") > 31, 31).otherwise(F.col("days5")))
        .withColumn("days6", F.when(F.col("days6") > 30, 30).otherwise(F.col("days6")))
        .withColumn("days7", F.when(F.col("days7") > 31, 31).otherwise(F.col("days7")))
        .withColumn("days8", F.when(F.col("days8") > 31, 31).otherwise(F.col("days8")))
        .withColumn("days9", F.when(F.col("days9") > 30, 30).otherwise(F.col("days9")))
        .withColumn("days10", F.when(F.col("days10") > 31, 31).otherwise(F.col("days10")))
        .withColumn("days11", F.when(F.col("days11") > 30, 30).otherwise(F.col("days11")))
        .withColumn("days12", F.when(F.col("days12") > 31, 31).otherwise(F.col("days12")))
    )

    for i in range(1, 13):
        forecast_data = forecast_data.withColumnRenamed(f"maxRates{i }", f"wgtdRate{i }")

    forecast_data.write.mode("overwrite").option("overwriteSchema", "true").saveAsTable(
        "forecastData_intermediate_data"
    )

    volume_hold = spark.read.table(
        TU.get_fully_qualified_table_name("finance", "maco", "promo_volume")
    )

    volume_hold = (
        volume_hold.withColumnRenamed("wslr_nbr", "wslr")
        .withColumnRenamed("brnd_cd", "bnd")
        .withColumnRenamed("mkt_ln_cd", "line")
        .withColumn(
            "rank",
            F.dense_rank().over(
                Window.partitionBy("snap_yr", "bgt_le_dly_flg").orderBy(F.desc("volume_id"))
            ),
        )
    )

    volume_hold = volume_hold.withColumn(
        "line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit('')))\
            .withColumn(
        "wslr", F.coalesce(F.lpad(F.col("wslr"),5,'0'),F.lit('')))

    volume_hold.createOrReplaceTempView("volume_hold")

    vol0 = spark.sql(
        f"""
                SELECT promo_vol_1,
                promo_vol_2,
                promo_vol_3,
                promo_vol_4,
                promo_vol_5,
                promo_vol_6,
                promo_vol_7,
                promo_vol_8,
                promo_vol_9,
                promo_vol_10,
                promo_vol_11,
                promo_vol_12,
                snap_yr,
                bgt_le_dly_flg,
                coalesce(B.brnd_cd, a.bnd) AS bnd,
                coalesce(C.mkt_ln_cd, a.line) AS LINE,
                CASE
                WHEN D.src_wslr_nbr IS NOT NULL
                AND D.eff_dt <= "{current_date}" THEN D.wslr_nbr
                ELSE a.wslr
                END AS wslr
                FROM volume_hold a
                LEFT JOIN {consolidated_brnd } B ON a.bnd = B.src_brnd_cd
                LEFT JOIN {consolidated_ln_cd } C ON a.line = C.src_mkt_ln_cd
                LEFT JOIN {consolidated_wslr } D ON a.wslr = D.src_wslr_nbr
                WHERE  rank = 1
            """
    )
    vol_down = vol0


    for i in range(1, 13):
        if bgt_le_dly_flg == 'D':
            vol0 = vol0.filter((F.col("snap_yr").isin(snap_year-1,snap_year)) & (F.col("bgt_le_dly_flg") !="B"))
            vol0 = vol0.withColumn(
                f"vol{i }",
                F.when((F.col("snap_yr") == snap_year - 1), F.col(f"promo_vol_{i }")
                ).otherwise(F.lit(0)),
            )
            if newclose > 12:
                j = 12 + i
                vol0 = vol0.withColumn(
                    f"vol{j }",
                    F.when((F.col("snap_yr") == snap_year), F.col(f"promo_vol_{i }")
                    ).otherwise(F.lit(0)),
                )
            vol0 = vol0.withColumn(f"vol{i }", F.coalesce(F.col(f"vol{i }"), F.lit(0)))
        else:
            vol0 = vol0.filter((F.col("snap_yr").isin(snap_year-1,snap_year)))
            vol0 = vol0.withColumn(
                f"vol{i }",
                F.when((F.col("bgt_le_dly_flg") != 'B') &
                    (F.col("snap_yr") == snap_year-1), F.col(f"promo_vol_{i }")
                ).otherwise(F.lit(0)),
            )
            if newclose > 12:
                j = 12 + i
                vol0 = vol0.withColumn(
                    f"vol{j }",
                    F.when((F.col("bgt_le_dly_flg") == 'B') &
                        (F.col("snap_yr") == snap_year), F.col(f"promo_vol_{i }")
                    ).otherwise(F.lit(0)),
                )
            vol0 = vol0.withColumn(f"vol{i }", F.coalesce(F.col(f"vol{i }"), F.lit(0)))


    vol_cols = ["wslr", "bnd", "line"] + [f"vol{i }" for i in range(1, int(newclose) + 1)]
    vol0 = vol0.select(*vol_cols)


    vol = [f"vol{i }" for i in range(1, int(newclose) + 1)]
    vol0 = vol0.groupBy(["wslr", "bnd", "line"]).agg(
        *[F.sum(col).alias(col) for col in vol]
    )

    vol_taken = vol0


    logger.info("CHECKPOINT 7: Completed vol0 aggregation and volume calculations")
    def process_actual_gpv():
        """
        Processes actual gross promoted volume (GPV) data for the current or prior year, depending on the value of `closemon`.

        If `closemon` is 0, selects and deduplicates the current actuals (wslr, bnd, line) from the forecast data, applying brand, line, and wholesaler mappings.
        If `closemon` is not 0, selects actual GPV and days columns for all months, applies mappings, renames columns for months 13-24, caps days to month maximums, and aggregates by (wslr, bnd, line).

        Returns:
            pyspark.sql.DataFrame: Processed DataFrame of actual GPV and days by wholesaler, brand, and line, with columns adjusted for the reporting period.
        """
        if closemon == 0:

            curr_actuals = forecast_data.select("wslr", "bnd", "line")
            curr_actuals.createOrReplaceTempView("currActuals")
            curr_actuals = spark.sql(
                f"""
                        SELECT coalesce(B.brnd_cd, a.bnd) AS bnd,
                        coalesce(C.mkt_ln_cd, a.line) AS LINE,
                        CASE
                        WHEN D.src_wslr_nbr IS NOT NULL
                        AND D.eff_dt <= "{current_date}" THEN D.wslr_nbr
                        ELSE a.wslr
                        END AS wslr
                        FROM currActuals a
                        LEFT JOIN {consolidated_brnd } B ON a.bnd = B.src_brnd_cd
                        LEFT JOIN {consolidated_ln_cd } C ON a.line = C.src_mkt_ln_cd
                        LEFT JOIN {consolidated_wslr } D ON a.wslr = D.src_wslr_nbr
                    """
            )
            curr_actuals = curr_actuals.dropDuplicates(["wslr", "bnd", "line"])
        else:

            curr_cols_1 = (
                ["wslr", "bnd", "line"]
                + [f"actgpv{i }" for i in range(1, 13)]
                + [f"days{i }" for i in range(1, 13)]
            )
            curr_actuals = forecast_data.select(*curr_cols_1)
            curr_actuals.createOrReplaceTempView("currActuals")
            curr_actuals = spark.sql(
                f"""
                        SELECT days1,
                        days2,
                        days3,
                        days4,
                        days5,
                        days6,
                        days7,
                        days8,
                        days9,
                        days10,
                        days11,
                        days12,
                        actgpv1,
                        actgpv2,
                        actgpv3,
                        actgpv4,
                        actgpv5,
                        actgpv6,
                        actgpv7,
                        actgpv8,
                        actgpv9,
                        actgpv10,
                        actgpv11,
                        actgpv12,
                        coalesce(B.brnd_cd, a.bnd) AS bnd,
                        coalesce(C.mkt_ln_cd, a.line) AS LINE,
                        CASE
                        WHEN D.src_wslr_nbr IS NOT NULL
                        AND D.eff_dt <= "{current_date}" THEN D.wslr_nbr
                        ELSE a.wslr
                        END AS wslr
                        FROM currActuals a
                        LEFT JOIN {consolidated_brnd } B ON a.bnd = B.src_brnd_cd
                        LEFT JOIN {consolidated_ln_cd } C ON a.line = C.src_mkt_ln_cd
                        LEFT JOIN {consolidated_wslr } D ON a.wslr = D.src_wslr_nbr
                    """
            )

            for i in range(1, 13):
                curr_actuals = curr_actuals.withColumnRenamed(
                    f"actgpv{i }", f"actgpv{i +12 }"
                )
                curr_actuals = curr_actuals.withColumnRenamed(f"days{i }", f"days{i +12 }")
            curr_cols = (
                ["wslr", "bnd", "line"]
                + [f"actgpv{i }" for i in range(13, int(newclose) + 1)]
                + [f"days{i }" for i in range(13, int(newclose) + 1)]
            )
            curr_actuals = curr_actuals.select(*curr_cols)
            curr_actuals = curr_actuals.orderBy(["wslr", "bnd", "line"])

            summary_vars_curr = [f"actgpv{i }" for i in range(13, int(newclose) + 1)] + [
                f"days{i }" for i in range(13, int(newclose) + 1)
            ]

            curr_actuals = curr_actuals.groupBy(["wslr", "bnd", "line"]).agg(
                *[F.sum(F.col(c)).alias(c) for c in summary_vars_curr]
            )

            for i in range(13, int(newclose) + 1):
                month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][(i - 13) % 12]
                curr_actuals = curr_actuals.withColumn(
                    f"days{i }",
                    F.when(F.col(f"days{i }") > month_days, month_days).otherwise(
                        F.col(f"days{i }")
                    ),
                )
            cols = (
                ["wslr", "bnd", "line"]
                + [f"actgpv{i }" for i in range(13, int(newclose) + 1)]
                + [f"days{i }" for i in range(13, int(newclose) + 1)]
            )
            curr_actuals = curr_actuals.select(*cols)
        return curr_actuals


    curr_actuals = process_actual_gpv()

    logger.info("CHECKPOINT 7A: Completed process_actual_gpv() - processed current actuals")

    if ZERORPV == "N":
        vol0 = vol0.join(curr_actuals, ["wslr", "bnd", "line"], "right")
    else:
        vol0 = vol0.join(curr_actuals, ["wslr", "bnd", "line"], "outer")

    wslr_info = wslr_info_temp.select(["wslr", "state", "mca", "wslrsdir"])
    wslr_info = wslr_info.dropDuplicates(["wslr"])

    vol0 = vol0.join(wslr_info, ["wslr"], "left")

    makefamsmart_df = spark.read.table(
        TU.get_fully_qualified_table_name("radar", "maco", "makefamsmart")
    ).select(
        F.col("brnd_cd").alias("bnd"),
        F.col("custom_family_nm").alias("family"),
        F.col("custom_fam_ord").alias("famord"),
        F.col("custom_short_fam_nm").alias("shortfam"),
    )
    makefamsmart_df_fam = makefamsmart_df.select("bnd", "shortfam")
    vol0 = vol0.join(makefamsmart_df_fam, "bnd", "left").withColumn(
        "shortfam", F.coalesce(F.col("shortfam"), F.lit(DEFAULT_FAM))
    )

    rvsd_prior_yr_proxy = spark.read.table(
        TU.get_fully_qualified_table_name("finance", "maco", "proxy_file")
    )
    rvsd_prior_yr_proxy = rvsd_prior_yr_proxy.filter((F.col("bgt_le_dly_flg")==bgt_le_dly_flg))
    rvsd_prior_yr_proxy=rvsd_prior_yr_proxy.withColumnRenamed("wslr_nbr", "wslr").withColumnRenamed("brnd_cd", "bnd").withColumnRenamed("mkt_ln_cd", "line")
    for i in range(1,13):
        rvsd_prior_yr_proxy = rvsd_prior_yr_proxy.withColumnRenamed(f"nbr_promo_days_{i}", f"days{i}")\
            .withColumnRenamed(f"grss_prmtd_vol_{i}", f"gpv{i}")\
            .withColumnRenamed(f"max_dol_offered_{i}", f"maxDol{i}")\
            .withColumnRenamed(f"cr_pmt_actual_amt_{i}", f"paid{i}")\
            .withColumnRenamed(f"nbr_promos_paid_{i}", f"promospaid{i}")\
            .withColumnRenamed(f"nbr_promos_offered_{i}", f"promosoffered{i}")

    rvsd_prior_yr_proxy = rvsd_prior_yr_proxy.withColumn(
        "line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit('')))\
            .withColumn(
        "wslr", F.coalesce(F.lpad(F.col("wslr"),5,'0'),F.lit('')))

    rvsd_prior_yr_proxy.createOrReplaceTempView("Rvsd_PriorYrProxy")

    prev_year = spark.sql(
        f"""
                SELECT gpv1,
                gpv2,
                gpv3,
                gpv4,
                gpv5,
                gpv6,
                gpv7,
                gpv8,
                gpv9,
                gpv10,
                gpv11,
                gpv12,
                days1,
                days2,
                days3,
                days4,
                days5,
                days6,
                days7,
                days8,
                days9,
                days10,
                days11,
                days12,
                coalesce(B.brnd_cd, a.bnd) AS bnd,
                coalesce(C.mkt_ln_cd, a.line) AS LINE,
                CASE
                WHEN D.src_wslr_nbr IS NOT NULL
                AND D.eff_dt <= "{current_date}" THEN D.wslr_nbr
                ELSE a.wslr
                END AS wslr
                FROM Rvsd_PriorYrProxy a
                LEFT JOIN {consolidated_brnd } B ON a.bnd = B.src_brnd_cd
                LEFT JOIN {consolidated_ln_cd } C ON a.line = C.src_mkt_ln_cd
                LEFT JOIN {consolidated_wslr } D ON a.wslr = D.src_wslr_nbr
            """
    )
    for i in range(1, 13):
        prev_year = prev_year.withColumnRenamed(f"gpv{i }", f"actgpv{i }")

    agg_sum = [F.sum(F.col(f"actgpv{i }")).alias(f"actgpv{i }") for i in range(1, 13)] + [
        F.sum(F.col(f"days{i }")).alias(f"days{i }") for i in range(1, 13)
    ]

    prev_year = prev_year.groupBy(["wslr", "bnd", "line"]).agg(*agg_sum)

    month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    days_capping_transforms = {}

    for i, max_days in enumerate(month_days, 1):
        days_col = f"days{i }"
        days_capping_transforms[days_col] = F.when(
            F.col(days_col) > max_days, max_days
        ).otherwise(F.col(days_col))

    prev_year = prev_year.withColumns(days_capping_transforms)

    vol0 = vol0.join(prev_year, ["wslr", "bnd", "line"], "left")



    for i in range(1, int(newclose) + 1):
        vol_col = f"vol{i }"
        gpv_col = f"actgpv{i }"
        if vol_col not in vol0.columns:

            vol0 = vol0.withColumn(vol_col, F.lit(0))
        if gpv_col not in vol0.columns:
            vol0 = vol0.withColumn(gpv_col, F.lit(0))
        vol0 = vol0.withColumn(
            vol_col, F.when(F.col(vol_col).isNull(), 0).otherwise(F.col(vol_col))
        )
        vol0 = vol0.withColumn(
            gpv_col, F.when(F.col(gpv_col).isNull(), 0).otherwise(F.col(gpv_col))
        )
        if ZERORPV == "N":
            for i in range(1, int(newclose) + 1):
                vol0 = vol0.withColumn(
                    vol_col, F.when(F.col(gpv_col) == 0, 0).otherwise(F.col(vol_col))
                )

    for i in range(1, int(newclose) + 1):
        days_col = f"days{i }"
        gpv_col = f"actgpv{i }"
        wght_col = f"dayWght{i }"
        if days_col not in vol0.columns:
            vol0 = vol0.withColumn(days_col, F.lit(0))

        vol0 = vol0.withColumn(
            days_col, F.when(F.col(days_col).isNull(), 0).otherwise(F.col(days_col))
        )

        vol0 = vol0.withColumn(wght_col, F.col(days_col) * F.col(gpv_col))

    vol0 = vol0.withColumn("altfam", F.col("shortfam"))
    vol0 = vol0.withColumn("altline", F.col("line"))

    vol0.createOrReplaceTempView("vol0")


    logger.info("CHECKPOINT 7B: Completed vol0 preparation with altfam, altline, and weights")


    RPV_DICT = {i: globals()[f"RPV{i }"] for i in range(1, PROXIES + 1)}

    def makeby():
        """
        Equivalent to SAS %MACRO MAKEBY
        Sets up RPV proxies sort, summary, and merge statements
        This macro analyzes each RPV proxy code and builds dynamic SQL statements
        """
        global BY_CLAUSES, MERGE_STATEMENTS, SORT_STATEMENTS, TIME_DESCRIPTIONS
        
        logger.info("CHECKPOINT 8: Starting makeby() - Building RPV proxy statements")

        for i in range(1, PROXIES + 1):
            rpv_code = RPV_DICT[i]

            geo_level = rpv_code[0] if len(rpv_code) > 0 else "A"
            if geo_level == "W":
                by_a = "WSLR"
            elif geo_level == "M":
                by_a = "STATE, MCA"
            elif geo_level == "D":
                by_a = "STATE, wslrsdir"
            elif geo_level == "S":
                by_a = "STATE"
            elif geo_level == "A":
                by_a = ""
            else:
                by_a = ""

            brand_level = rpv_code[1] if len(rpv_code) > 1 else "A"
            if brand_level == "B":
                by_b = "BND"
            elif brand_level == "F":
                by_b = "shortfam"
            elif brand_level == "A":
                by_b = ""
            elif brand_level == "T":
                by_b = "altfam"
            else:
                by_b = ""

            package_level = rpv_code[2] if len(rpv_code) > 2 else "A"
            if package_level == "L":
                by_c = "LINE"
            elif package_level == "A":
                by_c = ""
            elif package_level == "T":
                by_c = "altline"
            else:
                by_c = ""

            time_level = rpv_code[3] if len(rpv_code) > 3 else "6"
            if time_level == "Y":
                time_desc = "YEAR-TO-DATE"
            elif time_level == "P":
                time_desc = "PREV YEAR-END"
            elif time_level == "M":
                time_desc = "MONTH (PREV YEAR)"
            elif time_level == "3":
                time_desc = "3 MONTH MOVING AVG"
            elif time_level == "6":
                time_desc = "6 MONTH MOVING AVG"
            elif time_level == "9":
                time_desc = "9 MONTH MOVING AVG"
            elif time_level == "2":
                time_desc = "12 MONTH MOVING AVG"
            else:
                time_desc = "6 MONTH MOVING AVG"

            by_parts = [by_a, by_b, by_c]
            by_clause = ", ".join([part for part in by_parts if part])
            BY_CLAUSES[i] = by_clause
            TIME_DESCRIPTIONS[i] = time_desc

            default_sql = f"""
                    SELECT {', '.join ([f'SUM(COALESCE(vol{j }, 0)) as vol{j }'for j in range (1 ,newclose +1 )])}, {', '.join ([f'SUM(COALESCE(actGPV{j }, 0)) as actGPV{j }'for j in range (1 ,newclose +1 )])}, {', '.join ([f'SUM(dayWght{j }) as dayWght{j }'for j in range (1 ,newclose +1 )])}
                    FROM vol0
                """
            if rpv_code.startswith("AAA"):

                sort_sql = default_sql
            elif by_clause:

                sort_sql = f"""
                        SELECT {by_clause }, {', '.join ([f'SUM(COALESCE(vol{j }, 0)) as vol{j }'for j in range (1 ,newclose +1 )])}, {', '.join ([f'SUM(COALESCE(actGPV{j }, 0)) as actGPV{j }'for j in range (1 ,newclose +1 )])}, {', '.join ([f'SUM(dayWght{j }) as dayWght{j }'for j in range (1 ,newclose +1 )])}
                        FROM vol0
                        GROUP BY {by_clause }
                        ORDER BY {by_clause }
                    """
            else:

                sort_sql = default_sql

            SORT_STATEMENTS[i] = sort_sql

            merge_base_cols = "rpv.WSLR, rpv.MCA, rpv.STATE, rpv.wslrsdir, rpv.BND, rpv.shortfam, rpv.altfam, rpv.altline, rpv.LINE"

            merge_rpv_cols = ", ".join(
                [f"COALESCE(rpv.RPV{j }, vol.PROXY{j }) as RPV{j }" for j in range(1, 13)]
            )
            merge_days_cols = ", ".join(
                [
                    f"CASE WHEN rpv.days{j } IS NOT NULL THEN rpv.days{j } WHEN vol.dayProxy{j } IS NOT NULL THEN vol.dayProxy{j } ELSE NULL END as days{j }"
                    for j in range(1, 13)
                ]
            )

            merge_proxy_used_cols = ", ".join(
                [
                    f"CASE WHEN rpv.RPV{j } IS NOT NULL THEN rpv.PROXY_USED{j } WHEN vol.PROXY{j } IS NOT NULL THEN {i } ELSE rpv.PROXY_USED{j } END as PROXY_USED{j }"
                    for j in range(1, 13)
                ]
            )
            default_sql = f"""
                    SELECT {merge_base_cols }, {merge_rpv_cols }, {merge_days_cols }, {merge_proxy_used_cols }
                    FROM RPV rpv
                    CROSS JOIN vol{i } vol
                """
            if rpv_code.startswith("AAA"):

                merge_sql = default_sql
            elif by_clause:

                join_conditions = [
                    f"rpv.{col .strip ()} = vol.{col .strip ()}"
                    for col in by_clause.split(",")
                ]
                join_condition = " AND ".join(join_conditions)

                merge_sql = f"""
                        SELECT {merge_base_cols }, {merge_rpv_cols }, {merge_days_cols }, {merge_proxy_used_cols }
                        FROM RPV rpv
                        LEFT JOIN vol{i } vol ON {join_condition }
                    """
            else:

                merge_sql = default_sql

            MERGE_STATEMENTS[i] = merge_sql


    makeby()


    logger.info("CHECKPOINT 9: Completed makeby() - Generated all RPV proxy statements")

    def makesort():
        """
        Equivalent to SAS %MACRO MAKESORT
        Executes all SORT statements to create VOL1-VOL24 datasets
        This runs the dynamic SQL statements created by MAKEBY
        """
        vol_datasets = {}

        for i in range(1, PROXIES + 1):

            vol_df = spark.sql(SORT_STATEMENTS[i])
            vol_df.createOrReplaceTempView(f"VOL{i }_SUMMARY")
            vol_datasets[i] = vol_df

        return vol_datasets


    makesort()


    logger.info("CHECKPOINT 10: Completed makesort() - Created VOL1-VOL24 datasets")

    def makerpv():
        """
        Equivalent TO SAS % MACRO MAKERPV Updates VOL1 - VOL24 datasets WITH RPV calculations This implements the complex RPV calculation logic based ON TIME frames
        """
        updated_vol_datasets = {}

        for i in range(1, PROXIES + 1):
            rpv_code = RPV_DICT[i]
            time_level = rpv_code[3] if len(rpv_code) > 3 else "6"

            if time_level == "3":
                open_month = max(1, newclose - 2)  # 3 month moving average
            elif time_level == "6":
                open_month = max(1, newclose - 5)  # 6 month moving average
            elif time_level == "9":
                open_month = max(1, newclose - 8)  # 9 month moving average
            elif time_level == "2":
                open_month = max(1, newclose - 11)  # 12 month moving average
            else:
                open_month = 1

            proxy_calcs = []
            dayproxy_calcs = []
            trackproxy_calcs = []

            for j in range(1, 13):

                if time_level == "M":

                    rpv_calc = f"CASE WHEN VOL{j } > 0 THEN actGPV{j } / VOL{j } ELSE NULL END as PROXY{j }"
                    day_calc = f"CASE WHEN actGPV{j } > 0 THEN dayWght{j } / actGPV{j } ELSE NULL END as dayProxy{j }"

                elif time_level == "P":

                    vol_sum = " + ".join([f"COALESCE(VOL{k }, 0)" for k in range(1, 13)])
                    actgpv_sum = " + ".join(
                        [f"COALESCE(actGPV{k }, 0)" for k in range(1, 13)]
                    )

                    daywght_sum = " + ".join(
                        [f"COALESCE(dayWght{k }, 0)" for k in range(1, 13)]
                    )
                    daywght_hasdata = " OR ".join(
                        [f"dayWght{k } IS NOT NULL" for k in range(1, 13)]
                    )

                    rpv_calc = f"CASE WHEN ({vol_sum }) > 0 THEN ({actgpv_sum }) / ({vol_sum }) ELSE NULL END as PROXY{j }"
                    day_calc = f"CASE WHEN ({actgpv_sum }) > 0 AND ({daywght_hasdata }) THEN ({daywght_sum }) / ({actgpv_sum }) ELSE NULL END as dayProxy{j }"

                elif time_level == "Y":

                    vol_sum = " + ".join(
                        [f"COALESCE(VOL{k }, 0)" for k in range(1, newclose + 1)]
                    )
                    actgpv_sum = " + ".join(
                        [f"COALESCE(actGPV{k }, 0)" for k in range(1, newclose + 1)]
                    )

                    daywght_sum = " + ".join(
                        [f"COALESCE(dayWght{k }, 0)" for k in range(1, newclose + 1)]
                    )
                    daywght_hasdata = " OR ".join(
                        [f"dayWght{k } IS NOT NULL" for k in range(1, newclose + 1)]
                    )

                    rpv_calc = f"CASE WHEN ({vol_sum }) > 0 THEN ({actgpv_sum }) / ({vol_sum }) ELSE NULL END as PROXY{j }"
                    day_calc = f"CASE WHEN ({actgpv_sum }) > 0 AND ({daywght_hasdata }) THEN ({daywght_sum }) / ({actgpv_sum }) ELSE NULL END as dayProxy{j }"

                else:

                    vol_sum = " + ".join(
                        [f"COALESCE(VOL{k }, 0)" for k in range(open_month, newclose + 1)]
                    )
                    actgpv_sum = " + ".join(
                        [
                            f"COALESCE(actGPV{k }, 0)"
                            for k in range(open_month, newclose + 1)
                        ]
                    )

                    daywght_sum = " + ".join(
                        [
                            f"COALESCE(dayWght{k }, 0)"
                            for k in range(open_month, newclose + 1)
                        ]
                    )
                    daywght_hasdata = " OR ".join(
                        [
                            f"dayWght{k } IS NOT NULL"
                            for k in range(open_month, newclose + 1)
                        ]
                    )

                    rpv_calc = f"CASE WHEN ({vol_sum }) > 0 THEN ({actgpv_sum }) / ({vol_sum }) ELSE NULL END as PROXY{j }"
                    day_calc = f"CASE WHEN ({actgpv_sum }) > 0 AND ({daywght_hasdata }) THEN ({daywght_sum }) / ({actgpv_sum }) ELSE NULL END as dayProxy{j }"

                if ZERORPV == "N":

                    rpv_calc_parts = rpv_calc.split(" as ")
                    column_name = rpv_calc_parts[1]

                    if time_level == "M":

                        rpv_calc = f"CASE WHEN VOL{j } > 0 AND actGPV{j } / VOL{j } != 0 THEN actGPV{j } / VOL{j } ELSE NULL END as {column_name }"
                    elif time_level in ["P", "Y"]:

                        vol_sum = " + ".join(
                            [f"COALESCE(VOL{k }, 0)" for k in range(1, newclose + 1)]
                        )
                        actgpv_sum = " + ".join(
                            [f"COALESCE(actGPV{k }, 0)" for k in range(1, newclose + 1)]
                        )
                        rpv_calc = f"CASE WHEN ({vol_sum }) > 0 AND ({actgpv_sum }) / ({vol_sum }) != 0 THEN ({actgpv_sum }) / ({vol_sum }) ELSE NULL END as {column_name }"
                    else:

                        vol_sum = " + ".join(
                            [
                                f"COALESCE(VOL{k }, 0)"
                                for k in range(open_month, newclose + 1)
                            ]
                        )
                        actgpv_sum = " + ".join(
                            [
                                f"COALESCE(actGPV{k }, 0)"
                                for k in range(open_month, newclose + 1)
                            ]
                        )
                        rpv_calc = f"CASE WHEN ({vol_sum }) > 0 AND ({actgpv_sum }) / ({vol_sum }) != 0 THEN ({actgpv_sum }) / ({vol_sum }) ELSE NULL END as {column_name }"

                track_calc = f"CASE WHEN ({rpv_calc .split (' as ')[0 ]}) IS NOT NULL THEN {i } ELSE NULL END as TRACKPROXY{j }"

                proxy_calcs.append(rpv_calc)
                dayproxy_calcs.append(day_calc)
                trackproxy_calcs.append(track_calc)

            base_columns = []
            if BY_CLAUSES[i]:
                base_columns = [col.strip() for col in BY_CLAUSES[i].split(",")]

            if base_columns:
                base_select = ", ".join(base_columns) + ", "
            else:
                base_select = ""

            rpv_sql = f"""
                    SELECT {base_select }{', '.join (proxy_calcs +dayproxy_calcs +trackproxy_calcs )}
                    FROM VOL{i }_SUMMARY
                """

            vol_rpv_df = spark.sql(rpv_sql)

            vol_rpv_df.createOrReplaceTempView(f"VOL{i }")
            updated_vol_datasets[i] = vol_rpv_df

        return updated_vol_datasets


    makerpv()

    logger.info("CHECKPOINT 11: Completed makerpv() - Calculated RPV values for all VOL datasets")

    RPV = vol0.select(
        "WSLR", "MCA", "STATE", "wslrsdir", "BND", "shortfam", "LINE", "altfam", "altline"
    )


    def mergeall(rpv_df):
        """
        Equivalent to SAS %MACRO MERGEALL
        Executes all merge statements to assign proxy values hierarchically
        This implements the proxy hierarchy - if a higher priority proxy has a value, use it
        """

        current_rpv = rpv_df

        for j in range(1, newclose + 1):
            current_rpv = current_rpv.withColumn(f"RPV{j }", F.lit(None).cast("double"))
            current_rpv = current_rpv.withColumn(f"days{j }", F.lit(None))
            current_rpv = current_rpv.withColumn(
                f"PROXY_USED{j }", F.lit(None).cast("double")
            )
        current_rpv.createOrReplaceTempView("RPV")

        for i in range(1, PROXIES + 1):

            merged_df = spark.sql(MERGE_STATEMENTS[i])
            merged_df.createOrReplaceTempView("RPV")
            current_rpv = merged_df

        return current_rpv


    rpv = mergeall(RPV)

    logger.info("CHECKPOINT 12: Completed mergeall() - Assigned proxy values hierarchically")

    RPVTREND = spark.sql(
        """
            SELECT wslr,
            bnd,
            LINE,
            proxy1,
            dayProxy1
            FROM vol2
        """
    )

    RPVTREND = RPVTREND.withColumnRenamed("proxy1", "sixMonthProxy").withColumnRenamed(
        "dayProxy1", "sixMonthDays"
    )
    RPVTREND = RPVTREND.filter(
        (F.col("sixMonthProxy").isNotNull()) & (F.col("sixMonthDays").isNotNull())
    )


    rpv_proxy = rpv.select(
        F.col("WSLR").alias("wslr_nbr").cast(StringType()),
        F.col("BND").alias("brnd_cd").cast(StringType()),
        F.col("LINE").alias("mkt_ln_cd").cast(StringType()),
        F.col("MCA").alias("mca_cd").cast(StringType()),
        F.col("wslrsdir").alias("wslr_sls_dir").cast(StringType()),
        F.col("STATE").alias("state_cd").cast(StringType()),
        F.col("shortfam").alias("custom_short_fam_nm").cast(StringType()),
        F.col("altfam").alias("custom_family_nm").cast(StringType()),
        F.col("altline").alias("line_cd").cast(StringType()),
        F.col("RPV1").alias("rpv_pct_override_1").cast(DecimalType(38, 20)),
        F.col("RPV2").alias("rpv_pct_override_2").cast(DecimalType(38, 20)),
        F.col("RPV3").alias("rpv_pct_override_3").cast(DecimalType(38, 20)),
        F.col("RPV4").alias("rpv_pct_override_4").cast(DecimalType(38, 20)),
        F.col("RPV5").alias("rpv_pct_override_5").cast(DecimalType(38, 20)),
        F.col("RPV6").alias("rpv_pct_override_6").cast(DecimalType(38, 20)),
        F.col("RPV7").alias("rpv_pct_override_7").cast(DecimalType(38, 20)),
        F.col("RPV8").alias("rpv_pct_override_8").cast(DecimalType(38, 20)),
        F.col("RPV9").alias("rpv_pct_override_9").cast(DecimalType(38, 20)),
        F.col("RPV10").alias("rpv_pct_override_10").cast(DecimalType(38, 20)),
        F.col("RPV11").alias("rpv_pct_override_11").cast(DecimalType(38, 20)),
        F.col("RPV12").alias("rpv_pct_override_12").cast(DecimalType(38, 20)),
        F.col("days1").alias("nbr_promo_days_1").cast(DecimalType(10, 4)),
        F.col("days2").alias("nbr_promo_days_2").cast(DecimalType(10, 4)),
        F.col("days3").alias("nbr_promo_days_3").cast(DecimalType(10, 4)),
        F.col("days4").alias("nbr_promo_days_4").cast(DecimalType(10, 4)),
        F.col("days5").alias("nbr_promo_days_5").cast(DecimalType(10, 4)),
        F.col("days6").alias("nbr_promo_days_6").cast(DecimalType(10, 4)),
        F.col("days7").alias("nbr_promo_days_7").cast(DecimalType(10, 4)),
        F.col("days8").alias("nbr_promo_days_8").cast(DecimalType(10, 4)),
        F.col("days9").alias("nbr_promo_days_9").cast(DecimalType(10, 4)),
        F.col("days10").alias("nbr_promo_days_10").cast(DecimalType(10, 4)),
        F.col("days11").alias("nbr_promo_days_11").cast(DecimalType(10, 4)),
        F.col("days12").alias("nbr_promo_days_12").cast(DecimalType(10, 4)),
        F.col("PROXY_USED1").alias("adj_pyramid_wght_1").cast(DoubleType()),
        F.col("PROXY_USED2").alias("adj_pyramid_wght_2").cast(DoubleType()),
        F.col("PROXY_USED3").alias("adj_pyramid_wght_3").cast(DoubleType()),
        F.col("PROXY_USED4").alias("adj_pyramid_wght_4").cast(DoubleType()),
        F.col("PROXY_USED5").alias("adj_pyramid_wght_5").cast(DoubleType()),
        F.col("PROXY_USED6").alias("adj_pyramid_wght_6").cast(DoubleType()),
        F.col("PROXY_USED7").alias("adj_pyramid_wght_7").cast(DoubleType()),
        F.col("PROXY_USED8").alias("adj_pyramid_wght_8").cast(DoubleType()),
        F.col("PROXY_USED9").alias("adj_pyramid_wght_9").cast(DoubleType()),
        F.col("PROXY_USED10").alias("adj_pyramid_wght_10").cast(DoubleType()),
        F.col("PROXY_USED11").alias("adj_pyramid_wght_11").cast(DoubleType()),
        F.col("PROXY_USED12").alias("adj_pyramid_wght_12").cast(DoubleType()),
    )

    rpv_proxy.write.mode("overwrite").option("overwriteSchema", "true").saveAsTable(
        "rpv_proxy_intermediate"
    )


    forecast_data = spark.read.table("forecastData_intermediate_data")

    rpv = spark.read.table("rpv_proxy_intermediate")
    for i in range(1, 13):
        rpv = (
            rpv.withColumnRenamed(f"rpv_pct_override_{i }", f"rpv{i }")
            .withColumnRenamed(f"adj_pyramid_wght_{i }", f"proxy_used{i }")
            .withColumnRenamed(f"nbr_promo_days_{i }", f"days{i }")
        )

    rpv = (
        rpv.withColumnRenamed("wslr_nbr", "wslr")
        .withColumnRenamed("brnd_cd", "bnd")
        .withColumnRenamed("mkt_ln_cd", "line")
    )

    for i in range(1, 13):
        rpv = rpv.withColumnRenamed(f"rpv{i }", f"rpvProxy{i }").withColumnRenamed(
            f"days{i }", f"dayProxy{i }"
        )
    keep_cols = (
        ["wslr", "bnd", "line"]
        + [f"rpvProxy{i }" for i in range(1, 13)]
        + [f"dayProxy{i }" for i in range(1, 13)]
        + [f"proxy_used{i }" for i in range(1, 13)]
    )

    rpv = rpv.select(*keep_cols)

    forecast_data = forecast_data.join(rpv, ["wslr", "bnd", "line"], "inner")

    forecast_data = forecast_data.join(
        F.broadcast(RPVTREND), ["wslr", "bnd", "line"], "left"
    )
    days_cols = [f"days{i }" for i in range(1, 13)]
    
    sum_expr = reduce(
        add,
        [
            F.when(
                F.col(c) > F.lit("0").cast(DecimalType(38, 20)),
                F.col(c).cast(DecimalType(38, 20)),
            ).otherwise(F.lit("0").cast(DecimalType(38, 20)))
            for c in days_cols
        ],
    )
    cnt_expr = reduce(
        add, [F.when(F.col(c) > 0, F.lit(1)).otherwise(F.lit(0)) for c in days_cols]
    )

    forecast_data = forecast_data.withColumn("avgDays", sum_expr)
    forecast_data = forecast_data.withColumn("avgDayCnt", cnt_expr)

    forecast_data = (
        forecast_data.withColumn(
            "avgDays",
            F.when(
                F.col("avgDayCnt") > 0, F.round(F.col("avgDays") / F.col("avgDayCnt"), 3)
            ).otherwise(F.col("avgDays")),
        )
        .withColumn(
            "sixMonthProxy",
            F.when(F.col("sixMonthProxy").isNull(), F.lit(0)).otherwise(
                F.col("sixMonthProxy")
            ),
        )
        .withColumn(
            "sixMonthDays",
            F.when(F.col("sixMonthDays").isNull(), F.lit(0)).otherwise(
                F.col("sixMonthDays")
            ),
        )
    )

    for i in range(1, 13):
        days_i = f"days{i }"
        proxy_used_i = f"proxy_used{i }"
        rpv_proxy_i = f"rpvProxy{i }"
        day_proxy_i = f"dayProxy{i }"
        change_proxy_i = f"changeProxy{i }"

        forecast_data = forecast_data.withColumn(change_proxy_i, F.lit(0))

        cond = (
            (F.col(days_i) > 0)
            & (F.abs(F.col(days_i) - F.col("avgDays")) <= 4)
            & (F.col(proxy_used_i) == 1)
            & (F.col("sixMonthProxy") > 0)
            & (F.col("sixMonthDays") > 0)
            & (F.abs(F.col("sixMonthProxy") - F.col(rpv_proxy_i)) >= 0.25)
        )

        forecast_data = (
            forecast_data.withColumn(
                day_proxy_i, F.when(cond, F.col("sixMonthDays")).otherwise(F.col(day_proxy_i))
            )
            .withColumn(
                change_proxy_i, F.when(cond, F.lit(1)).otherwise(F.col(change_proxy_i))
            )
            .withColumn(
                rpv_proxy_i,
                F.when(cond, F.col("sixMonthProxy")).otherwise(F.col(rpv_proxy_i)),
            )
            
        )

    temp_cols = ["avgDays", "avgDayCnt", "sixMonthProxy", "sixMonthDays"] + [
        f"proxy_used{i }" for i in range(1, 13)
    ]
    forecast_data = forecast_data.drop(*temp_cols)

    wslr_info = wslr_info_temp.select("wslr", "statcode", "wslrsdir").dropDuplicates(
        ["wslr"]
    )
    forecast_data = forecast_data.join(F.broadcast(wslr_info), ["wslr"], "left")

    sum_expr = " + ".join([f"changeProxy{i }" for i in range(1, 13)])

    pkg_dft = spark.read.table(
        TU.get_fully_qualified_table_name("commercial", "product", "package_group")
    )
    pkg_dft = (
        pkg_dft.withColumnRenamed("mkt_ln_cd", "line")
        .withColumnRenamed("DRAFT_OPT_CD", "Pkgdft")
        .withColumnRenamed("pkg_brrl_equiv_fct", "becv")
    )
    window_spec = Window.partitionBy("line").orderBy(F.col("beg_eff_dt").desc())
    pkg_dft = pkg_dft.withColumn("row", F.row_number().over(window_spec))
    pkg_dft = pkg_dft.filter(F.col("row") == 1).drop('row')
    pkg_dft1 = (
        pkg_dft.select("line", "Pkgdft")
        .withColumn("line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit('')))
        .dropDuplicates(["line"])
    )

    forecast_data = forecast_data.join(F.broadcast(pkg_dft1), "line", "left")
    forecast_data = forecast_data.withColumn(
        "Pkgdft",
        F.when(
            (F.col("Pkgdft").isin("", " ")) | (F.col("Pkgdft").isNull()), F.lit("P")
        ).otherwise(F.col("Pkgdft")),
    )
    rpv_day = spark.read.table(
        TU.get_fully_qualified_table_name("radar", "maco", "Rpv_day_weights")
    )
    
    rpv_day = rpv_day.withColumnRenamed("state_cd", "State")\
        .withColumnRenamed("wslr_sls_dir", "Wslrsdir")\
        .withColumnRenamed("draft_opt_cd", "Pkgdft")

    rpv_day = (
        rpv_day.select(["State", "Wslrsdir", "Pkgdft", "Rpv_Per_Day"])
        .withColumn("state", F.coalesce(F.lpad(F.col("state"),2,'0'),F.lit('')))\
        .withColumn("Rpv_Per_Day", F.col("Rpv_Per_Day").cast(DoubleType()))
    )


    forecast_data = forecast_data.join(
        F.broadcast(rpv_day), ["State", "Wslrsdir", "Pkgdft"], "left"
    )


    logger.info("CHECKPOINT 13: Joined RPV proxy data and RPV_day_weights to forecast_data")
    def calculate_final_rpv(df):
        """
        Adjusts and calculates the final RPV (Rate Per Volume) values for each month in the input DataFrame.

        For each month (1-12), this function:
        - Sets default RPV per day if missing.
        - Calculates the difference in promo days between forecast and proxy.
        - Adjusts the RPV value based on the day difference using business rules.
        - Caps the RPV value at 1.
        - Computes the difference between adjusted and original RPV.
        - Drops temporary calculation columns.

        Args:
            df (pyspark.sql.DataFrame): Input DataFrame containing columns for days, dayProxy, rpvProxy, and Rpv_Per_Day.

        Returns:
            pyspark.sql.DataFrame: DataFrame with adjusted RPV columns (Rpv1-Rpv12) and RPV difference columns (rpvDiff1-rpvDiff12).
        """
        df = df.withColumn(
            "Rpv_Per_Day", F.coalesce(F.col("Rpv_Per_Day"), F.lit(1.0 / 30.0))
        )
        days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        for i, month_days in enumerate(days_in_month, 1):
            df = df.withColumn(f"daysInMonth{i }", F.lit(month_days))
            df = df.withColumn(f"DayChg{i }", F.lit(0))
            df = df.withColumn(f"RpvAdj{i }", F.lit(0))
            df = df.withColumn(f"Rpv{i }", F.lit(0))
            df = df.withColumn("RpvDay", F.col("Rpv_Per_Day"))
            df = df.withColumn(
                f"DayChg{i }",
                F.when(
                    (F.col(f"days{i }") > 0) & (F.col(f"dayProxy{i }") > 0),
                    F.round(F.col(f"days{i }") - F.col(f"dayProxy{i }")),
                ).otherwise(F.lit(0)),
            )
            df = df.withColumn(
                "RpvDay",
                F.when(
                    (F.col(f"days{i }") > 0) & (F.col(f"dayProxy{i }") > 0),
                    F.least(
                        F.col("RpvDay"), F.col(f"RpvProxy{i }") / F.col(f"dayProxy{i }")
                    ),
                ).otherwise(F.col("RpvDay")),
            )
            df = df.withColumn(
                f"RpvAdj{i }",
                F.when(
                    F.col(f"DayChg{i }") > 0,
                    F.when(
                        (F.col(f"DayChg{i }") >= 1) & (F.col(f"DayChg{i }") <= 3),
                        F.col(f"DayChg{i }") * 0.25 * (1.0 / month_days),
                    )
                    .when(
                        (F.col(f"DayChg{i }") >= 4) & (F.col(f"DayChg{i }") <= 5),
                        F.col(f"DayChg{i }") * 0.75 * (1.0 / month_days),
                    )
                    .otherwise(F.col(f"DayChg{i }") * (1.0 / month_days)),
                )
                .when(
                    F.col(f"DayChg{i }") <= -4,
                    F.when(
                        (F.col(f"DayChg{i }") == -4) | (F.col(f"DayChg{i }") == -5),
                        F.col(f"DayChg{i }") * 0.25 * F.col("RpvDay"),
                    )
                    .when(
                        (F.col(f"DayChg{i }") <= -6) & (F.col(f"DayChg{i }") >= -25),
                        F.col(f"DayChg{i }") * 0.80 * F.col("RpvDay"),
                    )
                    .otherwise(F.col(f"DayChg{i }") * F.col("RpvDay")),
                )
                .otherwise(F.lit(0)),
            )
            df = df.withColumn(
                f"Rpv{i }",
                F.when(
                    (F.col(f"days{i }") > 0) & (F.col(f"dayProxy{i }") > 0),
                    F.col(f"rpvProxy{i }") + F.col(f"RpvAdj{i }"),
                ).otherwise(F.col(f"rpvProxy{i }")),
            )
            df = df.withColumn(
                f"Rpv{i }",
                F.when(F.col(f"Rpv{i }") > 1, F.lit(1)).otherwise(F.col(f"Rpv{i }")),
            )
            df = df.withColumn(f"rpvDiff{i }", F.col(f"Rpv{i }") - F.col(f"rpvProxy{i }"))
        temp_calc_cols = ["Wslrsdir", "Pkgdft"]
        df = df.drop(*temp_calc_cols)
        return df


    forecast_data = calculate_final_rpv(forecast_data)
    mil_promos = highlow_dataset
    mil_promos.createOrReplaceTempView("milPromos")
    if read_snap != "PlanB_PREV":
        mil_promos = spark.sql(
            f"""
                    SELECT a.civmil,
                    a.fromdate,
                    a.thrudate,
                    a.sug_disc,
                    a.max_rate,
                    coalesce(B.brnd_cd, a.bnd) AS bnd,
                    coalesce(C.mkt_ln_cd, a.line) AS LINE,
                    CASE
                    WHEN D.src_wslr_nbr IS NOT NULL
                    AND D.eff_dt <= "{current_date}" THEN D.wslr_nbr
                    ELSE a.WSLR
                    END AS wslr
                    FROM milPromos a
                    LEFT JOIN {consolidated_brnd } B ON a.BND = B.src_brnd_cd
                    LEFT JOIN {consolidated_ln_cd } C ON a.line = C.src_mkt_ln_cd
                    LEFT JOIN {consolidated_wslr } D ON a.WSLR = D.src_wslr_nbr
                """
        )

    mil_promos = mil_promos.withColumn("wslr", F.lpad(F.col("wslr"), 5, "0")).withColumn(
        "line", F.lpad(F.col("line"), 3, "0")
    )
    month_info = [
        (i, F.to_date(F.lit(f"{year }-{i :02d}-01"))) for i in range(1, 13)
    ]
    days_in_month_dict = {
        i: F.dayofmonth(F.last_day(F.to_date(F.lit(f"{year }-{i :02d}-01"))))
        for i in range(1, 13)
    }

    for i, mon1 in month_info:
        days_col = f"days{i }"
        days_in_month = days_in_month_dict[i]
        mil_promos = mil_promos.withColumn("MON1", mon1)
        mil_promos = mil_promos.withColumn("DAYS", days_in_month)
        mil_promos = mil_promos.withColumn(
            days_col,
            F.when(
                (F.month(F.col("fromdate")) == i) & (F.month(F.col("thrudate")) == i),
                F.unix_date(F.col("thrudate")) - F.unix_date(F.col("fromdate")) + 1,
            )
            .when(
                F.month(F.col("fromdate")) == i,
                F.col("DAYS")
                - (F.unix_date(F.col("fromdate")) - F.unix_date(F.col("MON1"))),
            )
            .when(
                F.month(F.col("thrudate")) == i,
                F.unix_date(F.col("thrudate")) - F.unix_date(F.col("MON1")) + 1,
            )
            .when(
                (F.month(F.col("fromdate")) < i) & (F.month(F.col("thrudate")) > i),
                F.col("DAYS"),
            )
            .otherwise(F.lit(0)),
        )
    mil_promos = mil_promos.select(
        "wslr", "bnd", "line", "civmil", *[f"days{i }" for i in range(1, 13)]
    )
    for i in range(1, 13):

        mil_promos = mil_promos.withColumn(
            f"PromoCount{i }", F.when(F.col(f"days{i }") > 0, F.lit(1)).otherwise(F.lit(0))
        )
        mil_promos = mil_promos.withColumn(
            f"MilCount{i }",
            F.when((F.col("civmil") == "M") & (F.col(f"days{i }") > 0), F.lit(1)).otherwise(
                F.lit(0)
            ),
        )

    count_vars = [f"PromoCount{i }" for i in range(1, 13)] + [
        f"MilCount{i }" for i in range(1, 13)
    ]
    mil_promos = mil_promos.groupBy("wslr", "bnd", "line").agg(
        *[F.sum(F.col(col)).alias(col) for col in count_vars]
    )

    mil_count_cols = [f"MilCount{i }" for i in range(1, 13)]
    sum_expr = " + ".join(mil_count_cols)
    mil_promos = mil_promos.filter(F.expr(f"({sum_expr }) > 0"))

    channel_volume = spark.read.table(
        TU.get_fully_qualified_table_name("finance","revenue_system","channel_volume")
    )
    
    product = spark.read.table(
        TU.get_fully_qualified_table_name("commercial", "product", "product")
    )
    brand = spark.read.table(
        TU.get_fully_qualified_table_name("commercial", "product", "brand")
    )
    wholesaler = spark.read.table(
        TU.get_fully_qualified_table_name("commercial", "wholesaler", "wholesaler")
    )
    channel_volume.createOrReplaceTempView("channel_volume")
    brand.createOrReplaceTempView("brand")
    product.createOrReplaceTempView("product")
    wholesaler.createOrReplaceTempView("wholesaler")
    makefamsmart_df_2 = makefamsmart_df.select("bnd", "family")
    makefamsmart_df_2.createOrReplaceTempView("makefamsmart_df_2")

    military_vol = spark.sql(
        """
                SELECT w.wslr_nbr AS wslr, 
                b.family,
                p.mkt_ln_cd AS LINE,
                v.segment_nm AS SEGMENT,RTLR_TYP_CD,
                sum(dlvrd_bbl_equiv_qty) AS bbls
                FROM channel_volume v
                LEFT JOIN product p ON v.pdcn_cd = p.pdcn_cd
                LEFT JOIN makefamsmart_df_2 b ON p.brnd_cd = b.bnd
                INNER JOIN wholesaler w ON w.wslr_nbr = v.wslr_nbr
                WHERE volume_id =
                (SELECT max(volume_id)
                FROM channel_volume)
                AND RTLR_TYP_CD IN ('11',
                '21',
                '23',
                '24',
                '31')
                AND w.WSLR_TYP_CD IN ('BB',
                'WB',
                'WS',
                'NE',
                'WN',
                'CW',
                'IW')
                AND w.budnet_actv_flg = 'Y'
                GROUP BY ALL
            """
    )
    military_vol = military_vol.withColumn(
        "family", F.coalesce(F.col("family"), F.lit(DEFAULT_FAM))
    )
    military_vol = military_vol.withColumn(
        "segment",
        F.when(F.col("RTLR_TYP_CD") != "11", F.lit("CIVILIAN")).otherwise(
            F.lit("MILITARY")
        ),
    )
    military_vol.createOrReplaceTempView("militaryVol")
    military_vol = spark.sql(
        f"""
                SELECT a.segment,
                a.family,
                a.bbls,
                coalesce(C.mkt_ln_cd, a.line) AS LINE,
                CASE
                WHEN D.src_wslr_nbr IS NOT NULL
                AND D.eff_dt <= "{current_date}" THEN D.wslr_nbr
                ELSE a.WSLR
                END AS wslr
                FROM militaryVol a
                LEFT JOIN {consolidated_ln_cd } C ON a.line = C.src_mkt_ln_cd
                LEFT JOIN {consolidated_wslr } D ON a.WSLR = D.src_wslr_nbr
            """
    )
    military_vol = military_vol.groupBy("wslr", "family", "line", "segment").agg(
        F.sum(F.col("bbls")).alias("bbls")
    )

    military_vol = military_vol.withColumn(
        "milVol", F.when(F.col("segment") == "MILITARY", F.col("bbls")).otherwise(F.lit(0))
    )
    military_vol = military_vol.withColumn(
        "civVol", F.when(F.col("segment") != "MILITARY", F.col("bbls")).otherwise(F.lit(0))
    )
    military_vol = military_vol.withColumn("totalVol", F.col("bbls")).drop("bbls")

    military_vol = military_vol.filter(F.col("totalVol") >= 0)

    cols_to_sum = ["milVol", "civVol", "totalVol"]

    military_vol = military_vol.groupBy("wslr", "family", "line").agg(
        *[F.sum(F.col(col)).alias(col) for col in cols_to_sum]
    )

    military_vol = military_vol.withColumn(
        "MilPer", F.coalesce(F.col("milVol") / F.col("totalVol"), F.lit(0))
    )
    military_vol = military_vol.select("wslr", "family", "line", "MilPer")


    makefamsmart_df_2 = makefamsmart_df.select("bnd", "family")

    mil_promos = mil_promos.join(makefamsmart_df_2, "bnd", "left").withColumn(
        "family", F.coalesce(F.col("family"), F.lit(DEFAULT_FAM))
    )

    mil_promos = mil_promos.select(
        "wslr",
        "family",
        "bnd",
        "line",
        *[f"PromoCount{i }" for i in range(1, 13)],
        *[f"MilCount{i }" for i in range(1, 13)],
    )

    mil_promos = mil_promos.join(military_vol, ["wslr", "family", "line"], "left").drop(
        "family"
    )

    forecast_data = forecast_data.join(mil_promos, ["wslr", "bnd", "line"], "left")

    forecast_data = forecast_data.withColumn("AdjForMil", F.lit("N"))
    for i in range(1, 13):
        forecast_data = forecast_data.withColumn(
            f"PromoCount{i }", F.coalesce(F.col(f"PromoCount{i }"), F.lit(0))
        )
        forecast_data = forecast_data.withColumn(
            f"MilCount{i }", F.coalesce(F.col(f"MilCount{i }"), F.lit(0))
        )
        forecast_data = forecast_data.withColumn(
            f"Rpv{i }",
            F.when(
                (F.col(f"PromoCount{i }") > 0)
                & (F.col(f"MilCount{i }") > 0)
                & (F.col(f"MilCount{i }") == F.col(f"PromoCount{i }"))
                & (F.col("MilPer") >= 0),
                F.col("MilPer"),
            ).otherwise(F.col(f"Rpv{i }")),
        )
        forecast_data = forecast_data.withColumn(
            "AdjForMil",
            F.when(
                (F.col(f"PromoCount{i }") > 0)
                & (F.col(f"MilCount{i }") > 0)
                & (F.col(f"MilCount{i }") == F.col(f"PromoCount{i }"))
                & (F.col("MilPer") >= 0),
                F.lit("Y"),
            ).otherwise(F.col("AdjForMil")),
        )

    drop_mil_cols = (
        [f"PromoCount{i }" for i in range(1, 13)]
        + [f"MilCount{i }" for i in range(1, 13)]
        + ["MilPer"]
    )
    forecast_data = forecast_data.drop(*drop_mil_cols)
    forecast_data.write.mode("overwrite").option("overwriteSchema", "true").saveAsTable(
        "forecastData_intermediate_data_1"
    )

    curr_year_actuals = spark.read.table("forecastData_intermediate_data_1")
    forecast_data = spark.read.table("forecastData_intermediate_data_1")


    for i in range(1, 13):
        curr_year_actuals = (
            curr_year_actuals.withColumnRenamed(f"maxdol{i }", f"maxdol{i +12 }")
            .withColumnRenamed(f"actdol{i }", f"actdol{i +12 }")
            .withColumnRenamed(f"actgpv{i }", f"actgpv{i +12 }")
            .withColumnRenamed(f"promosOffered{i }", f"promosOffered{i +12 }")
            .withColumnRenamed(f"promosPaid{i }", f"promosPaid{i +12 }")
        )

    curr_cols = (
        ["wslr", "bnd", "line"]
        + [f"maxdol{i }" for i in range(13, 25)]
        + [f"actdol{i }" for i in range(13, 25)]
        + [f"actgpv{i }" for i in range(13, 25)]
        + [f"promosOffered{i }" for i in range(13, 25)]
        + [f"promosPaid{i }" for i in range(13, 25)]
    )

    curr_year_actuals = curr_year_actuals.select(*curr_cols)
    summary_vars_curr = (
        [f"maxdol{i }" for i in range(13, 25)]
        + [f"actdol{i }" for i in range(13, 25)]
        + [f"actgpv{i }" for i in range(13, 25)]
        + [f"promosOffered{i }" for i in range(13, 25)]
        + [f"promosPaid{i }" for i in range(13, 25)]
    )
    curr_year_actuals = curr_year_actuals.groupBy("wslr", "bnd", "line").agg(
        *[F.sum(F.col(col)).alias(col) for col in summary_vars_curr]
    )


    logger.info("CHECKPOINT 14: Completed current year actuals aggregation")

    max_rate_dollars = rvsd_prior_yr_proxy

    max_rate_dollars = max_rate_dollars.join(makefamsmart_df_fam, "bnd", "left").withColumn(
        "shortfam", F.coalesce(F.col("shortfam"), F.lit(DEFAULT_FAM))
    )
    max_rate_dollars.createOrReplaceTempView("maxRateDollars")
    max_rate_dollars = spark.sql(
        f"""
                SELECT shortfam,
                gpv1,
                gpv2,
                gpv3,
                gpv4,
                gpv5,
                gpv6,
                gpv7,
                gpv8,
                gpv9,
                gpv10,
                gpv11,
                gpv12,
                paid1,
                paid2,
                paid3,
                paid4,
                paid5,
                paid6,
                paid7,
                paid8,
                paid9,
                paid10,
                paid11,
                paid12,
                maxDol1,
                maxDol2,
                maxDol3,
                maxDol4,
                maxDol5,
                maxDol6,
                maxDol7,
                maxDol8,
                maxDol9,
                maxDol10,
                maxDol11,
                maxDol12,
                promosOffered1,
                promosPaid1,
                promosOffered2,
                promosPaid2,
                promosOffered3,
                promosPaid3,
                promosPaid3,
                promosOffered4,
                promosPaid4,
                promosOffered5,
                promosPaid5,
                promosOffered6,
                promosPaid6,
                promosOffered7,
                promosPaid7,
                promosOffered8,
                promosPaid8,
                promosOffered9,
                promosPaid9,
                promosOffered10,
                promosPaid10,
                promosOffered11,
                promosPaid11,
                promosOffered12,
                promosPaid12,
                coalesce(B.brnd_cd, a.bnd) AS bnd,
                coalesce(C.mkt_ln_cd, a.line) AS LINE,
                CASE
                WHEN D.src_wslr_nbr IS NOT NULL
                AND D.eff_dt <= "{current_date}" THEN D.wslr_nbr
                ELSE a.wslr
                END AS wslr
                FROM maxRateDollars a
                LEFT JOIN {consolidated_brnd } B ON a.bnd = B.src_brnd_cd
                LEFT JOIN {consolidated_ln_cd } C ON a.line = C.src_mkt_ln_cd
                LEFT JOIN {consolidated_wslr } D ON a.wslr = D.src_wslr_nbr
            """
    )
    for i in range(1, 13):
        max_rate_dollars = max_rate_dollars.withColumnRenamed(
            f"paid{i }", f"actdol{i }"
        ).withColumnRenamed(f"gpv{i }", f"actgpv{i }")

    hist_cols = (
        ["wslr", "shortfam", "bnd", "line"]
        + [f"maxdol{i }" for i in range(1, 13)]
        + [f"actgpv{i }" for i in range(1, 13)]
        + [f"actdol{i }" for i in range(1, 13)]
        + [f"promosOffered{i }" for i in range(1, 13)]
        + [f"promosPaid{i }" for i in range(1, 13)]
    )

    max_rate_dollars = max_rate_dollars.select(*hist_cols)
    summary_vars_hist = (
        [f"maxdol{i }" for i in range(1, 13)]
        + [f"actgpv{i }" for i in range(1, 13)]
        + [f"actdol{i }" for i in range(1, 13)]
        + [f"promosOffered{i }" for i in range(1, 13)]
        + [f"promosPaid{i }" for i in range(1, 13)]
    )
    agg_exprs = [F.sum(F.col(col)).alias(col) for col in summary_vars_hist] + [
        F.first(F.col("shortfam")).alias("shortfam")
    ]
    max_rate_dollars = max_rate_dollars.groupBy("wslr", "bnd", "line").agg(*agg_exprs)

    max_rate_dollars = max_rate_dollars.join(
        curr_year_actuals, ["wslr", "bnd", "line"], "outer"
    ).drop("shortfam")
    max_rate_dollars = max_rate_dollars.join(makefamsmart_df_fam, "bnd", "left")
    max_rate_dollars = max_rate_dollars.withColumn(
        "shortfam", F.coalesce(F.col("shortfam"), F.lit(DEFAULT_FAM))
    )

    summary_vars_24 = (
        [f"maxdol{i }" for i in range(1, 25)]
        + [f"actdol{i }" for i in range(1, 25)]
        + [f"actgpv{i }" for i in range(1, 25)]
        + [f"promosOffered{i }" for i in range(1, 25)]
        + [f"promosPaid{i }" for i in range(1, 25)]
    )
    agg_sum = [F.sum(F.col(c)).alias(c) for c in summary_vars_24]
    max_rate_dollars = max_rate_dollars.groupBy("wslr", "shortfam", "bnd", "line").agg(
        *agg_sum
    )

    for i in range(1, 25):
        for col_prefix in ["actgpv", "actdol", "maxdol", "promosOffered", "promosPaid"]:
            col_name = f"{col_prefix }{i }"
            max_rate_dollars = max_rate_dollars.withColumn(
                col_name, F.coalesce(F.col(col_name), F.lit(0))
            )
    summary_vars_24 = (
        [f"maxdol{i }" for i in range(1, 13)]
        + [f"actdol{i }" for i in range(1, 13)]
        + [f"actgpv{i }" for i in range(1, 13)]
        + [f"promosOffered{i }" for i in range(1, 13)]
        + [f"promosPaid{i }" for i in range(1, 13)]
    )
    forecast_data = forecast_data.drop(*summary_vars_24)

    forecast_data = forecast_data.join(
        max_rate_dollars, ["wslr", "bnd", "line"], "left"
    ).drop("shortfam")
    forecast_data = forecast_data.join(makefamsmart_df_fam, "bnd", "left").withColumn(
        "shortfam", F.coalesce(F.col("shortfam"), F.lit(DEFAULT_FAM))
    )

    combined = max_rate_dollars.drop("shortfam")
    pkg_dft_2 = (
        pkg_dft.select("line", "becv")
        .dropDuplicates(["line"])
    )
    max_rate_dollars = max_rate_dollars.join(pkg_dft_2, "line", "left")


    actdol_cols = [f"actdol{i }" for i in range(1, 25)]
    maxdol_cols = [f"maxdol{i }" for i in range(1, 25)]

    for c in actdol_cols + maxdol_cols:
        max_rate_dollars = max_rate_dollars.withColumn(c, F.coalesce(F.col(c), F.lit(0)))

    for i in range(1, 25):
        max_rate_dollars = max_rate_dollars.withColumn(
            f"RateUtil{i }",
            F.when(
                F.col(f"maxdol{i }") > 0, F.col(f"actdol{i }") / F.col(f"maxdol{i }")
            ).otherwise(F.lit(0)),
        )

    x = int(newclose) - 5
    for cnt_var, i in enumerate(range(x, int(newclose) + 1), 1):
        max_rate_dollars = max_rate_dollars.withColumn(
            f"LastSix{cnt_var }", F.col(f"RateUtil{i }")
        )

    max_rate_dollars = max_rate_dollars.withColumn(
        "LastSixArray", F.array([F.col(f"LastSix{i }") for i in range(1, 7)])
    )

    max_rate_dollars = max_rate_dollars.withColumn(
        "SortedArray", F.expr("reverse(array_sort(LastSixArray))")
    )

    for i in range(1, 7):
        max_rate_dollars = max_rate_dollars.withColumn(
            f"MaxSix{i }",
            F.when(F.expr(f"SortedArray[{i -1 }]") == 0, None).otherwise(
                F.expr(f"SortedArray[{i -1 }]")
            ),
        )

    max_rate_dollars = max_rate_dollars.withColumn(
        "bndRateUtil",
        F.expr(
            """
            CASE 
                WHEN size(filter(array(MaxSix1,MaxSix2,MaxSix3), x -> x is not null)) = 0 THEN 0
                ELSE aggregate(
                    filter(array(MaxSix1,MaxSix2,MaxSix3), x -> x is not null),
                    cast(0.0 as double),
                    (acc, x) -> acc + x
                ) / size(filter(array(MaxSix1,MaxSix2,MaxSix3), x -> x is not null))
            END
        """
        ),
    )

    max_rate_dollars = max_rate_dollars.withColumn(
        "bndRateUtil",
        F.when(F.col("bndRateUtil").isNull(), F.lit(0)).otherwise(F.col("bndRateUtil")),
    ).withColumn(
        "bndRateUtil",
        F.when(F.col("bndRateUtil") > 1, F.lit(1)).otherwise(F.col("bndRateUtil")),
    )

    drop_cols = (
        ["SortedLastSix"]
        + [f"MaxSix{i }" for i in range(1, 7)]
        + [f"LastSix{i }" for i in range(1, 7)]
    )
    max_rate_dollars = max_rate_dollars.drop(*drop_cols)


    columns_to_keep = (
        ["wslr", "bnd", "shortfam", "line"] + actdol_cols + maxdol_cols + ["bndRateUtil"]
    )
    max_rate_dollars = max_rate_dollars.select(*columns_to_keep)

    agg_cols = actdol_cols + maxdol_cols
    agg_exprs = [F.sum(F.col(c)).alias(c) for c in agg_cols]
    max_rate_dollars_fam = max_rate_dollars.groupBy("wslr", "shortfam", "line").agg(
        *agg_exprs
    )

    actdol_cols = [f"actdol{i }" for i in range(1, 25)]
    maxdol_cols = [f"maxdol{i }" for i in range(1, 25)]

    for c in actdol_cols + maxdol_cols:
        max_rate_dollars_fam = max_rate_dollars_fam.withColumn(
            c, F.coalesce(F.col(c), F.lit(0))
        )

    for i in range(1, 25):
        max_rate_dollars_fam = max_rate_dollars_fam.withColumn(
            f"RateUtil{i }",
            F.when(
                F.col(f"maxdol{i }") > 0, F.col(f"actdol{i }") / F.col(f"maxdol{i }")
            ).otherwise(F.lit(0)),
        )

    x = int(newclose) - 5
    for cnt_var, i in enumerate(range(x, int(newclose) + 1), 1):
        max_rate_dollars_fam = max_rate_dollars_fam.withColumn(
            f"LastSix{cnt_var }", F.col(f"RateUtil{i }")
        )


    max_rate_dollars_fam = max_rate_dollars_fam.withColumn(
        "LastSixArray", F.array([F.col(f"LastSix{i }") for i in range(1, 7)])
    )

    max_rate_dollars_fam = max_rate_dollars_fam.withColumn(
        "SortedArray", F.expr("reverse(array_sort(LastSixArray))")
    )

    for i in range(1, 7):
        max_rate_dollars_fam = max_rate_dollars_fam.withColumn(
            f"MaxSix{i }",
            F.when(F.expr(f"SortedArray[{i -1 }]") == 0, None).otherwise(
                F.expr(f"SortedArray[{i -1 }]")
            ),
        )
    #max_rate_dollars_fam.printSchema()

    max_rate_dollars_fam = max_rate_dollars_fam.withColumn(
        "famRateUtil",
        F.expr(
            """
            CASE 
                WHEN size(filter(array(MaxSix1,MaxSix2,MaxSix3), x -> x is not null)) = 0 THEN 0
                ELSE aggregate(
                    filter(array(MaxSix1,MaxSix2,MaxSix3), x -> x is not null),
                    cast(0.0 as double),
                    (acc, x) -> acc + x
                ) / size(filter(array(MaxSix1,MaxSix2,MaxSix3), x -> x is not null))
            END
        """
        ),
    )


    max_rate_dollars_fam = max_rate_dollars_fam.withColumn(
        "famRateUtil",
        F.when(F.col("famRateUtil").isNull(), F.lit(0)).otherwise(F.col("famRateUtil")),
    ).withColumn(
        "famRateUtil",
        F.when(F.col("famRateUtil") > 1, F.lit(1)).otherwise(F.col("famRateUtil")),
    )

    drop_cols = (
        ["SortedLastSix"]
        + [f"MaxSix{i }" for i in range(1, 7)]
        + [f"LastSix{i }" for i in range(1, 7)]
    )
    max_rate_dollars_fam = max_rate_dollars_fam.drop(*drop_cols)

    columns_to_keep = ["wslr", "shortfam", "line", "famRateUtil"]
    max_rate_dollars_fam = max_rate_dollars_fam.select(*columns_to_keep)

    rate_util = max_rate_dollars.join(
        max_rate_dollars_fam, ["wslr", "shortfam", "line"], "left"
    )
    rate_util = rate_util.select(
        "wslr", "bnd", "shortfam", "line", "bndRateUtil", "famRateUtil"
    )

    rate_util = (
        rate_util.withColumn("utilUsed", F.lit(" "))
        .withColumn("fcstRateUtil", F.col("bndRateUtil"))
        .withColumn("utilUsed", F.lit("B"))
        .withColumn(
            "utilUsed",
            F.when(F.col("fcstRateUtil") == 0, F.lit("F")).otherwise(F.col("utilUsed")),
        )
        .withColumn(
            "fcstRateUtil",
            F.when(F.col("fcstRateUtil") == 0, F.col("famRateUtil")).otherwise(
                F.col("fcstRateUtil")
            ),
        )
        .withColumn(
            "utilUsed",
            F.when(
                (F.col("bndRateUtil") == 0) & (F.col("famRateUtil") == 0), F.lit(" ")
            ).otherwise(F.col("utilUsed")),
        )
        .withColumn(
            "fcstRateUtil",
            F.when(
                (F.col("bndRateUtil") == 0) & (F.col("famRateUtil") == 0), F.lit(1)
            ).otherwise(F.col("fcstRateUtil")),
        )
        .withColumn(
            "fcstRateUtil",
            F.when(F.col("fcstRateUtil") > 1, F.lit(1)).otherwise(F.col("fcstRateUtil")),
        )
    )

    rate_util = rate_util.select("wslr", "bnd", "line", "fcstRateUtil", "utilUsed")
    forecast_data = forecast_data.join(rate_util, ["wslr", "bnd", "line"], "left")

    logger.info("CHECKPOINT 15: Completed rate utilization calculations and joined to forecast_data")

    wslr_info = wslr_info_temp.select("wslr", "state").dropDuplicates(["wslr"])
    rate_util = rate_util.join(wslr_info, ["wslr"], "left")
    rate_util = rate_util.withColumn(
        "line", F.when(F.col("line").isin(""), F.lit(None)).otherwise(F.col("line"))
    )


    for i in range(1, 13):

        forecast_data = forecast_data.withColumn(
            f"wgtdRate{i }", F.coalesce(F.col(f"wgtdRate{i }"), F.lit(0))
        )
        forecast_data = forecast_data.withColumn(
            f"rate{i }", F.col(f"wgtdRate{i }") * F.col("fcstRateUtil")
        )

    keep_col = ["wslr", "bnd", "line"] + [f"vol{i }" for i in range(1, int(newclose) + 1)]

    vol_taken = vol_taken.select(*keep_col)
    not_taken = combined.join(vol_taken, ["wslr", "bnd", "line"], "left")


    logger.info("CHECKPOINT 15A: Starting not_taken logic - offered but not taken analysis")

    def sum_expr(cols):
        return reduce(add, [F.col(c) for c in cols])


    def apply_not_taken_forecast_logic(df, newclose):
        x = newclose - 5
        y = newclose + 1
        y = 24 if y == 25 else y
        
        for i in range(1, newclose + 1):
            df = df.withColumn(f"vol{i }", F.coalesce(F.col(f"vol{i }"), F.lit(0)))
        for i in range(1, 25):
            df = df.withColumn(
                f"promosOffered{i }", F.coalesce(F.col(f"promosOffered{i }"), F.lit(0))
            )
            df = df.withColumn(f"actdol{i }", F.coalesce(F.col(f"actdol{i }"), F.lit(0)))

        promos_x_to_newclose = [f"promosOffered{i }" for i in range(x, newclose + 1)]
        actdol_x_to_newclose = [f"actdol{i }" for i in range(x, newclose + 1)]
        promos_y_to_24 = [f"promosOffered{i }" for i in range(y, 25)]
        vol_x_to_newclose = [f"vol{i }" for i in range(x, newclose + 1)]
        actdol_newclose_to_24 = [f"actdol{i }" for i in range(newclose, 25)]

        df = (
            df.withColumn("actdol_newclose_to_24_sum", sum_expr(actdol_newclose_to_24))
            .withColumn("promos_x_to_newclose", sum_expr(promos_x_to_newclose))
            .withColumn("actdol_x_to_newclose", sum_expr(actdol_x_to_newclose))
            .withColumn("promos_y_to_24", sum_expr(promos_y_to_24))
            .withColumn("vol_x_to_newclose", sum_expr(vol_x_to_newclose))
            .withColumn(
                "vol_x_to_newclose", F.col("vol_x_to_newclose"))
            )
        

        cond1 = (F.col("promos_x_to_newclose") > 0) & (F.col("actdol_x_to_newclose") > 0)
        cond2 = (F.col("promos_x_to_newclose") == 0) & (F.col("promos_y_to_24") > 0)
        cond3 = (F.col("vol_x_to_newclose") == 0 )
        else_block = ~(cond1 | cond2 | cond3)
        for i in range(1, 13):
            actdol_i = F.col(f"actdol{i }")
            promos_i = F.col(f"promosOffered{i }")
            promos_i_13 = F.col(f"promosOffered{i +12 }")
            zero_fcst = f"zeroFcst{i }"

            df = df.withColumn(zero_fcst, F.when(cond1 | cond2 | cond3, F.lit(1)))

            df = df.withColumn(
                zero_fcst,
                F.when(
                    else_block & (F.col("actdol_newclose_to_24_sum") == 0), F.lit(0)
                ).otherwise(F.col(zero_fcst)),
            )

            df = df.withColumn(
                zero_fcst,
                F.when(else_block & ((actdol_i > 0) & (promos_i > 0)), F.lit(1)).otherwise(
                    F.col(zero_fcst)
                ),
            )

            df = df.withColumn(
                zero_fcst,
                F.when(
                    else_block & ((promos_i == 0) & (promos_i_13 > 0)), F.lit(1)
                ).otherwise(F.col(zero_fcst)),
            )

        return df


    not_taken = apply_not_taken_forecast_logic(not_taken, newclose)

    not_taken = not_taken.withColumn(
        "line", F.when(F.col("line").isin(""), F.lit(None)).otherwise(F.col("line"))
    )
    final_cols = ["wslr", "bnd", "line"] + [f"zeroFcst{i }" for i in range(1, 13)]
    not_taken = not_taken.select(*final_cols)


    forecast_data = forecast_data.join(not_taken, ["wslr", "bnd", "line"], "left")
    drop_cols = (
        [f"actdol{i }" for i in range(1, 13)]
        + [f"actgpv{i }" for i in range(1, 13)]
        + [f"promosOffered{i }" for i in range(1, 13)]
        + [f"promosPaid{i }" for i in range(1, 13)]
        + [f"maxdol{i }" for i in range(1, 13)]
    )
    forecast_data = forecast_data.drop(*drop_cols)
    rename_mappings = {}
    for i in range(1, 13):
        rename_mappings[f"actdol{12 +i }"] = f"actdol{i }"
        rename_mappings[f"actgpv{12 +i }"] = f"actgpv{i }"
        rename_mappings[f"maxdol{12 +i }"] = f"maxdol{i }"
        rename_mappings[f"promosOffered{12 +i }"] = f"promosOffered{i }"
        rename_mappings[f"promosPaid{12 +i }"] = f"promosPaid{i }"

    for old_name, new_name in rename_mappings.items():
        forecast_data = forecast_data.withColumnRenamed(old_name, new_name)

    for i in range(1, 13):
        zero_fcst = f"zeroFcst{i }"
        rpv = f"rpv{i }"
        rate = f"rate{i }"
        promos = f"promosOffered{i }"

        forecast_data = (
            forecast_data.withColumn(
                zero_fcst,
                F.when(F.col(zero_fcst).isNull(), F.lit(1)).otherwise(F.col(zero_fcst)),
            )
            .withColumn(
                promos, F.when(F.col(promos).isNull(), F.lit(0)).otherwise(F.col(promos))
            )
            .withColumn(rpv, F.col(rpv) * F.col(zero_fcst))
            .withColumn(rate, F.col(rate) * F.col(zero_fcst))
            .withColumn(rpv, F.when(F.col(promos) == 0, 0).otherwise(F.col(rpv)))
            .withColumn(rate, F.when(F.col(promos) == 0, 0).otherwise(F.col(rate)))
        )

    if force_rate_rpv.upper() == "Y":
        
        logger.info("CHECKPOINT 15B: Applying force_rate_rpv logic from fix_raterpv table")
        
        rate_rpv = spark.read.table(
            TU.get_fully_qualified_table_name("radar", "maco", "fix_raterpv")
        )
        rate_rpv = (
            rate_rpv.withColumnRenamed("wslr_nbr", "wslr")
            .withColumnRenamed("brnd_cd", "bnd")
            .withColumnRenamed("mkt_ln_cd", "line")
        )
        rate_rpv = rate_rpv.withColumn(
        "wslr", F.coalesce(F.lpad(F.col("wslr"),5,'0'),F.lit('')))\
            .withColumn(
        "line", F.coalesce(F.lpad(F.col("line"),3,'0'),F.lit('')))

        for i in range(1, 13):
            rate_rpv = rate_rpv.withColumnRenamed(
                f"promo_rate_override_{i }", f"fixrate{i }"
            ).withColumnRenamed(f"rpv_pct_override_{i }", f"fixrpv{i }")

        rate_rpv = rate_rpv.filter((F.col("wslr").isNotNull()) & (F.col("wslr") != "99999"))

        forecast_data = forecast_data.join(rate_rpv, on=["wslr", "bnd", "line"], how="left")

        for i in range(1, 13):
            forecast_data = forecast_data.withColumn(
                f"rpv{i }",
                F.when(F.col(f"fixrpv{i }").isNotNull(), F.col(f"fixrpv{i }")).otherwise(
                    F.col(f"rpv{i }")
                ),
            ).withColumn(
                f"rate{i }",
                F.when(F.col(f"fixrate{i }").isNotNull(), F.col(f"fixrate{i }")).otherwise(
                    F.col(f"rate{i }")
                ),
            )

        force_cols = [f"fixrpv{i }" for i in range(1, 13)] + [
            f"fixrate{i }" for i in range(1, 13)
        ]
        forecast_data = forecast_data.drop(*force_cols)
    fcst_volume = vol_down
    if bgt_le_dly_flg == 'D':
        fcst_volume = fcst_volume.filter((F.col("snap_yr") == snap_year) & (F.col("bgt_le_dly_flg") != 'B'))
    else:
        fcst_volume = fcst_volume.filter((F.col("snap_yr") == snap_year) & (F.col("bgt_le_dly_flg") == 'B'))

    for i in range(1, 13):
        vol_col = f"vol{i }"
        cur_col = f"promo_vol_{i }"
        fcst_volume = fcst_volume.withColumn(vol_col,F.col(cur_col))\
        .withColumn(vol_col, F.when(F.col(vol_col).isNull(), 0).otherwise(F.col(vol_col)))
    
    vol_columns = [f"vol{i }" for i in range(1, 13)]
    agg_exprs = [F.sum(F.col(c)).alias(c) for c in vol_columns]
    fcst_volume = fcst_volume.groupBy("wslr", "bnd", "line").agg(*agg_exprs)

    fcst_output = forecast_data.join(fcst_volume, ["wslr", "bnd", "line"], "left")
    columns_to_keep = (
        ["wslr", "bnd", "line"]
        + [f"vol{i }" for i in range(1, 13)]
        + [f"rpv{i }" for i in range(1, 13)]
        + [f"rate{i }" for i in range(1, 13)]
        + [f"actdol{i }" for i in range(1, 13)]
        + [f"actgpv{i }" for i in range(1, 13)]
        + [f"promosOffered{i }" for i in range(1, 13)]
        + [f"promosPaid{i }" for i in range(1, 13)]
        + [f"days{i }" for i in range(1, 13)]
        + [f"maxdol{i }" for i in range(1, 13)]
        + [f"wgtdRate{i }" for i in range(1, 13)]
        + [f"discDol{i }" for i in range(1, 13)]
        + [f"discMax{i }" for i in range(1, 13)]
        + [f"aappaid{i }" for i in range(1, 13)]
        + [f"aapgpv{i }" for i in range(1, 13)]
        + [f"maxDisc{i }" for i in range(1, 13)]
    )

    fcst_output = fcst_output.select(*columns_to_keep)

    fcst_output = fcst_output.join(pkg_dft_2, "line", "left")

    wslr_info = wslr_info_temp.select("wslr", "statcode").dropDuplicates(["wslr"])
    fcst_output = fcst_output.join(wslr_info, "wslr", "left")
    rate_cols = [f"rate{i}" for i in range(1, 13)]
    rpv_cols = [f"rpv{i}" for i in range(1, 13)]
    wgtd_rate_cols = [f"wgtdRate{i}" for i in range(1, 13)]
    cols_to_fix = rate_cols + rpv_cols + wgtd_rate_cols
    fcst_output = fcst_output.select(*[
    (F.coalesce(F.col(c), F.lit(0)).alias(c) if c in cols_to_fix else F.col(c))
    for c in fcst_output.columns
    ])


    logger.info("CHECKPOINT 16: Completed forecast volume calculations and joined to fcst_output")



    def sas_fcstoutput_transform(df, closemon, closfobr):
        """
        Transforms the forecast output DataFrame to apply business rules for calculating forecasted and actual dollars, GPV, and related metrics.

        This function:
        - Ensures nulls are replaced with default values for key columns.
        - Calculates forecasted GPV and dollars for each month using volume, RPV, and rate.
        - Applies actuals if promo conditions are met or for closed months, with special handling for certain states.
        - Caps dollars and GPV to actuals if actuals exceed forecasted values.
        - Calculates and adjusts max discount, split, disc max, and disc dollars based on business logic.
        - Ensures all output columns are non-null and filtered for non-zero records.
        - Returns a DataFrame with the final set of columns for downstream reporting.

        Args:
            df (pyspark.sql.DataFrame): Input DataFrame containing forecast and actuals data.
            closemon (int): The last closed month for most states.
            closfobr (int): The last closed month for special states.

        Returns:
            pyspark.sql.DataFrame: Transformed DataFrame with forecasted and actual metrics for each month.
        """

        df = df.withColumn(
            "becv",
            F.when(F.col("becv").isNull(), F.lit(0.07258065)).otherwise(F.col("becv")),
        )

        months = range(1, 13)
        gpv = [f"gpv{i }" for i in months]
        orig_gpv = [f"orig_gpv{i }" for i in months]
        rpv = [f"rpv{i }" for i in months]
        rate = [f"rate{i }" for i in months]
        vol = [f"vol{i }" for i in months]
        dol = [f"dol{i }" for i in months]
        actdol = [f"actdol{i }" for i in months]
        actgpv = [f"actgpv{i }" for i in months]
        promos_paid = [f"promosPaid{i }" for i in months]
        promos_offered = [f"promosOffered{i }" for i in months]
        maxdol = [f"maxdol{i }" for i in months]
        wgtd_rate = [f"wgtdRate{i }" for i in months]
        max_disc = [f"maxDisc{i }" for i in months]
        disc_dol = [f"discDol{i }" for i in months]
        disc_max = [f"discMax{i }" for i in months]
        aappaid = [f"aappaid{i }" for i in months]
        aapgpv = [f"aapgpv{i }" for i in months]

        for i in months:
            df = df.withColumn(
                vol[i - 1],
                F.when(F.col(vol[i - 1]).isNull(), F.lit(0)).otherwise(F.col(vol[i - 1])),
            )

        for i in months:
            df = df.withColumn(gpv[i - 1], F.col(vol[i - 1]) * F.col(rpv[i - 1]))

        for i in months:
            df = df.withColumn(
                dol[i - 1], F.col(rate[i - 1]) * (F.col(gpv[i - 1]) / F.col("becv"))
            )

        for i in months:
            df = df.withColumn(
                dol[i - 1],
                F.when(
                    F.col(promos_paid[i - 1]) >= F.col(promos_offered[i - 1]),
                    F.col(actdol[i - 1]),
                ).otherwise(F.col(dol[i - 1])),
            ).withColumn(
                gpv[i - 1],
                F.when(
                    F.col(promos_paid[i - 1]) >= F.col(promos_offered[i - 1]),
                    F.col(actgpv[i - 1]),
                ).otherwise(F.col(gpv[i - 1])),
            )

        for i in months:
            condition = (F.col(f"actdol{i }") > F.col(f"dol{i }")) | (
                F.col(f"actgpv{i }") > F.col(f"gpv{i }")
            )

            df = df.withColumn(
                f"dol_temp_{i }",
                F.when(condition, F.col(f"actdol{i }")).otherwise(F.col(f"dol{i }")),
            )
            df = df.withColumn(
                f"gpv_temp_{i }",
                F.when(condition, F.col(f"actgpv{i }")).otherwise(F.col(f"gpv{i }")),
            )

            df = df.drop(f"dol{i }", f"gpv{i }")
            df = df.withColumnRenamed(f"dol_temp_{i }", f"dol{i }")
            df = df.withColumnRenamed(f"gpv_temp_{i }", f"gpv{i }")

        for i in months:
            df = df.withColumn(orig_gpv[i - 1], F.col(gpv[i - 1]))

        special_states = ["CT", "ID", "OH", "KS", "KY", "WV", "MI"]
        for i in months:
            df = df.withColumn(
                dol[i - 1],
                F.when(
                    (F.col("statcode").isin(special_states))
                    & (F.lit(i) <= F.lit(closfobr)),
                    F.col(actdol[i - 1]),
                )
                .when(
                    (~F.col("statcode").isin(special_states))
                    & (F.lit(i) <= F.lit(closemon)),
                    F.col(actdol[i - 1]),
                )
                .otherwise(F.col(dol[i - 1])),
            ).withColumn(
                gpv[i - 1],
                F.when(
                    (F.col("statcode").isin(special_states))
                    & (F.lit(i) <= F.lit(closfobr)),
                    F.col(actgpv[i - 1]),
                )
                .when(
                    (~F.col("statcode").isin(special_states))
                    & (F.lit(i) <= F.lit(closemon)),
                    F.col(actgpv[i - 1]),
                )
                .otherwise(F.col(gpv[i - 1])),
            )

        for i in months:

            cond1 = (
                (F.lit(i) > F.lit(closemon))
                & (F.col(promos_paid[i - 1]) < F.col(promos_offered[i - 1]))
                & (~F.col("statcode").isin(special_states))
            )

            cond2 = (
                (F.lit(i) > F.lit(closfobr))
                & (F.col(promos_paid[i - 1]) < F.col(promos_offered[i - 1]))
                & (F.col("statcode").isin(special_states))
            )

            maxdol_expr = F.round(
                (F.col(gpv[i - 1]) / F.col("becv")) * F.col(wgtd_rate[i - 1]), 4
            )

            maxdol_final = F.when(
                F.col(dol[i - 1]) > maxdol_expr, F.col(dol[i - 1])
            ).otherwise(maxdol_expr)

            max_disc_expr = F.when(
                F.col(max_disc[i - 1]) == 0, F.col(wgtd_rate[i - 1]) * 2
            ).otherwise(F.col(max_disc[i - 1]))
            split_expr = F.col(wgtd_rate[i - 1]) / max_disc_expr

            split_expr_special = F.when(F.col(max_disc[i - 1]) == 0, F.lit(0.5)).otherwise(
                F.col(wgtd_rate[i - 1]) / F.col(max_disc[i - 1])
            )

            disc_max_expr = F.round(maxdol_final / split_expr, 4)
            disc_dol_expr = F.round(F.col(dol[i - 1]) / split_expr, 4)
            disc_max_expr_special = F.round(maxdol_final / split_expr_special, 4)
            disc_dol_expr_special = F.round(F.col(dol[i - 1]) / split_expr_special, 4)

            df = (
                df.withColumn(
                    maxdol[i - 1],
                    F.when(cond1, maxdol_final)
                    .otherwise(F.col(maxdol[i - 1])),
                )
                .withColumn(
                    max_disc[i - 1],
                    F.when(cond1, max_disc_expr)
                    .otherwise(F.col(max_disc[i - 1])),
                )
                .withColumn(
                    disc_max[i - 1],
                    F.when(cond1, disc_max_expr)
                    .otherwise(F.col(disc_max[i - 1])),
                )
                .withColumn(
                    disc_dol[i - 1],
                    F.when(cond1, disc_dol_expr)
                    .otherwise(F.col(disc_dol[i - 1])),
                )
            )
            df = (
                df.withColumn(
                    maxdol[i - 1],
                    F.when(cond2, maxdol_final)
                    .otherwise(F.col(maxdol[i - 1])),
                )
                .withColumn(
                    max_disc[i - 1],
                    F.when(cond2, F.col(max_disc[i - 1]))
                    .otherwise(F.col(max_disc[i - 1])),
                )
                .withColumn(
                    disc_max[i - 1],
                    F.when(cond2, disc_max_expr_special)
                    .otherwise(F.col(disc_max[i - 1])),
                )
                .withColumn(
                    disc_dol[i - 1],
                    F.when(cond2, disc_dol_expr_special)
                    .otherwise(F.col(disc_dol[i - 1])),
                )
            )

        for i in months:
            df = df.withColumn(
                gpv[i - 1],
                F.when(F.col(gpv[i - 1]).isNull(), F.lit(0)).otherwise(F.col(gpv[i - 1])),
            )
            df = df.withColumn(
                actgpv[i - 1],
                F.when(F.col(actgpv[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(actgpv[i - 1])
                ),
            )
            df = df.withColumn(
                dol[i - 1],
                F.when(F.col(dol[i - 1]).isNull(), F.lit(0)).otherwise(F.col(dol[i - 1])),
            )
            df = df.withColumn(
                actdol[i - 1],
                F.when(F.col(actdol[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(actdol[i - 1])
                ),
            )
            df = df.withColumn(
                maxdol[i - 1],
                F.when(F.col(maxdol[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(maxdol[i - 1])
                ),
            )
            df = df.withColumn(
                disc_max[i - 1],
                F.when(F.col(disc_max[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(disc_max[i - 1])
                ),
            )
            df = df.withColumn(
                disc_dol[i - 1],
                F.when(F.col(disc_dol[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(disc_dol[i - 1])
                ),
            )
            df = df.withColumn(
                promos_paid[i - 1],
                F.when(F.col(promos_paid[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(promos_paid[i - 1])
                ),
            )
            df = df.withColumn(
                promos_offered[i - 1],
                F.when(F.col(promos_offered[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(promos_offered[i - 1])
                ),
            )
            df = df.withColumn(
                aappaid[i - 1],
                F.when(F.col(aappaid[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(aappaid[i - 1])
                ),
            )
            df = df.withColumn(
                aapgpv[i - 1],
                F.when(F.col(aapgpv[i - 1]).isNull(), F.lit(0)).otherwise(
                    F.col(aapgpv[i - 1])
                ),
            )

        sum_expr = (
            reduce(add, [F.col(g) for g in gpv])
            + reduce(add, [F.col(d) for d in dol])
            + reduce(add, [F.col(a) for a in aappaid])
            + reduce(add, [F.col(a) for a in aapgpv])
            + reduce(add, [F.col(p) for p in promos_offered])
        )
        df = df.filter(sum_expr != 0)

        keep_cols = (
            ["wslr", "bnd", "line"]
            + actdol
            + dol
            + actgpv
            + gpv
            + promos_offered
            + promos_paid
            + [f"days{i }" for i in months]
            + maxdol
            + disc_dol
            + disc_max
            + aappaid
            + aapgpv
        )
        return df.select(*keep_cols)


    fcst_output = sas_fcstoutput_transform(fcst_output, closemon, closfobr)

    logger.info("CHECKPOINT 17: Completed sas_fcstoutput_transform - transformed forecast output")

    for i in range(1, 13):
        fcst_output = fcst_output.withColumnRenamed(f"dol{i }", f"pyedol{i }")
        fcst_output = fcst_output.withColumnRenamed(f"gpv{i }", f"pyegpv{i }")

    fcst_output = fcst_output.withColumn("alwtype", F.lit("N"))
    
    rename_map = {
        "wslr": "wslr_nbr",
        "bnd": "brnd_cd",
        "line": "mkt_ln_cd",
        "alwtype": "alw_typ_flg",
        **{f"actdol{i}": f"act_alw_dol_amt_{i}" for i in range(1, 13)},
        **{f"actgpv{i}": f"act_grss_prmtd_vol_{i}" for i in range(1, 13)},
        **{f"pyedol{i}": f"pye_alw_dol_amt_{i}" for i in range(1, 13)},
        **{f"pyegpv{i}": f"pye_grss_prmtd_vol_{i}" for i in range(1, 13)},
        **{f"maxdol{i}": f"max_dol_offered_{i}" for i in range(1, 13)},
        **{f"days{i}": f"nbr_promo_days_{i}" for i in range(1, 13)},
        **{f"promosOffered{i}": f"nbr_promos_offered_{i}" for i in range(1, 13)},
        **{f"promosPaid{i}": f"nbr_promos_paid_{i}" for i in range(1, 13)},
        **{f"aappaid{i}": f"aap_paid_amt_{i}" for i in range(1, 13)},
        **{f"aapgpv{i}": f"aap_grss_prmtd_vol_{i}" for i in range(1, 13)},
        **{f"discDol{i}": f"dscnt_dol_amt_utilized_{i}" for i in range(1, 13)},
        **{f"discMax{i}": f"dscnt_max_amt_{i}" for i in range(1, 13)}
    }

    
    for old_col, new_col in rename_map.items():
        if old_col in fcst_output.columns:
            fcst_output = fcst_output.withColumnRenamed(old_col, new_col)

    selected_columns = rename_map.values()
    fcst_output_2 = fcst_output.select(*selected_columns)

    fcst_output_3 = fcst_output_2.withColumn("snap_yr",F.lit(snap_year))\
            .withColumn("bgt_le_dly_flg",F.lit(bgt_le_dly_flg))\
            .withColumn('__created_tsp',F.current_timestamp())

    specbase_dly_config_path = ("../../../blt/finance/maco/configs/specbase_dly.yaml")
    specbase_dly_medallion = Medallion(config_path=specbase_dly_config_path)

    specbase_dly_medallion.write_to_gold(df=fcst_output_3)
    spark.sql("""drop table if exists forecastData_intermediate_data""")
    spark.sql("""drop table if exists rpv_proxy_intermediate""")
    spark.sql("""drop table if exists rate_weights_intermediate""")
    spark.sql("drop table if exists forecastData_intermediate_data_1")
    spark.sql("drop table if exists rateweights_temp_1")
    logger.info("CHECKPOINT 18: Final output written to finance.maco.specbase_dly")
    logger.info("TFIX CODE EXECUTION COMPLETED SUCCESSFULLY")

if __name__ == "__main__":
    dbutils.widgets.text("snap_year","")
    snap_year= dbutils.widgets.get("snap_year")
    dbutils.widgets.text("bgt_le_dly_flg","D")
    bgt_le_dly_flg= dbutils.widgets.get("bgt_le_dly_flg")
    dbutils.widgets.text("closemon", "")
    closemon = dbutils.widgets.get("closemon")
    dbutils.widgets.text("strmon", "")
    strmon = dbutils.widgets.get("strmon")
    dbutils.widgets.text("closfobr", "")
    closfobr = dbutils.widgets.get("closfobr")
    if (
        (bgt_le_dly_flg.upper() not in ["B", "D", "L"])
        or (len(snap_year) != 4)
        or closemon == "" 
        or strmon == "" 
        or closfobr == ""
    ):
        raise ValueError(
            "snap_year parameter is missing or invalid. Please pass a valid numeric year (e.g., 2025) or bgt_le_dly_flg parameter should be passed with expected value as B or D or L or closemon parameter is missing or invalid. Please pass a valid numeric month (e.g., 1 to 12) or strmon parameter is missing or invalid. Please pass a valid numeric month (e.g., 1 to 12) or closfobr parameter is missing or invalid. Please pass a valid numeric month (e.g., 1 to 12)"
        )
    promotion_forecast_tfix(bgt_le_dly_flg,int(snap_year),int(closemon),int(strmon),int(closfobr))
    
