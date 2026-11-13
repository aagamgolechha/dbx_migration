# Databricks notebook source
# MAGIC %md
# MAGIC # 400_LOAD_CBM002 --> transform_analytics_fact_thecb_cbm002
# MAGIC Converted from SAS to PySpark
# MAGIC Source: 400_LOAD_CBM002.sas

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

# Pyspark Functions
from datetime import datetime
from pyspark.sql import functions as F
from pyspark.sql.types import *
from pyspark.sql import Window

# COMMAND ----------

# Job Start Time

_job_start_time = datetime.now()
log_msg(
    f"Job started: transform_analytics_fact_thecb_cbm002 | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)

# COMMAND ----------

# Step: Pre-declaraed parameters

dbutils.widgets.text("current_term", "2265", "Current Term")
dbutils.widgets.text("prior_term", "2262", "Prior Term")
dbutils.widgets.text("future_term", "2268", "Future Term")
dbutils.widgets.text("snapshot_type", "End of Term", "Snapshot Type")

current_term = dbutils.widgets.get("current_term")
prior_term = dbutils.widgets.get("prior_term")
future_term = dbutils.widgets.get("future_term")
snapshot_type = dbutils.widgets.get("snapshot_type")

# COMMAND ----------

# Source Tables
adw_term_dim = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("ADW_TERM_DIM")

ps_class_attribute = read_table(f"{student}.{bronze}.PS_CLASS_ATTRIBUTE").alias(
    "PS_CLASS_ATTRIBUTE"
)
ps_crse_attr_value = read_table(f"{student}.{bronze}.PS_CRSE_ATTR_VALUE").alias(
    "PS_CRSE_ATTR_VALUE"
)
ps_crse_attributes = read_table(f"{student}.{bronze}.PS_CRSE_ATTRIBUTES").alias(
    "PS_CRSE_ATTRIBUTES"
)
ps_crse_catalog = read_table(f"{student}.{bronze}.PS_CRSE_CATALOG").alias(
    "PS_CRSE_CATALOG"
)
ps_class_tbl = read_table(f"{student}.{bronze}.PS_CLASS_TBL").alias("PS_CLASS_TBL")
ps_class_assoc = read_table(f"{student}.{bronze}.PS_CLASS_ASSOC").alias(
    "PS_CLASS_ASSOC"
)
ps_uta_cb_loc_vw = read_table(f"{student}.{bronze}.PS_UTA_CB_LOC_VW").alias(
    "PS_UTA_CB_LOC_VW"
)
ps_utz_pt100_dtl = read_table(f"{student}.{bronze}.PS_UTZ_PT100_DTL").alias(
    "PS_UTZ_PT100_DTL"
)
ps_sctn_cmbnd = read_table(f"{student}.{bronze}.PS_SCTN_CMBND").alias("PS_SCTN_CMBND")
ps_stdnt_enrl = read_table(f"{student}.{bronze}.PS_STDNT_ENRL").alias("PS_STDNT_ENRL")
ps_acad_plan = read_table(f"{student}.{bronze}.PS_ACAD_PLAN").alias("PS_ACAD_PLAN")
ps_acad_plan_tbl = read_table(f"{student}.{bronze}.PS_ACAD_PLAN_TBL").alias(
    "PS_ACAD_PLAN_TBL"
)
ps_acad_plan_owner = read_table(f"{student}.{bronze}.PS_ACAD_PLAN_OWNER").alias(
    "PS_ACAD_PLAN_OWNER"
)
ps_acad_prog = read_table(f"{student}.{bronze}.PS_ACAD_PROG").alias("PS_ACAD_PROG")
ps_stdnt_car_term = read_table(f"{student}.{bronze}.PS_STDNT_CAR_TERM").alias(
    "PS_STDNT_CAR_TERM"
)
ps_pers_nid = read_table(f"{student}.{bronze}.PS_PERS_NID").alias("PS_PERS_NID")
ps_external_system = read_table(f"{student}.{bronze}.PS_EXTERNAL_SYSTEM").alias(
    "PS_EXTERNAL_SYSTEM"
)
ps_adm_appl_prog = read_table(f"{student}.{bronze}.PS_ADM_APPL_PROG").alias(
    "PS_ADM_APPL_PROG"
)
ps_adm_appl_data = read_table(f"{student}.{bronze}.PS_ADM_APPL_DATA").alias(
    "PS_ADM_APPL_DATA"
)
ps_adm_appl_rcr_ca = read_table(f"{student}.{bronze}.PS_ADM_APPL_RCR_CA").alias(
    "PS_ADM_APPL_RCR_CA"
)
ps_hcr_div_ethnic_i = read_table(f"{student}.{bronze}.PS_HCR_DIV_ETHNIC_I").alias(
    "PS_HCR_DIV_ETHNIC_I"
)
ps_hcr_ethnic_grp_i = read_table(f"{student}.{bronze}.PS_HCR_ETHNIC_GRP_I").alias(
    "PS_HCR_ETHNIC_GRP_I"
)
ps_person_sa = read_table(f"{student}.{bronze}.PS_PERSON_SA").alias("PS_PERSON_SA")
ps_pers_data_effdt = read_table(f"{student}.{bronze}.PS_PERS_DATA_EFFDT").alias(
    "PS_PERS_DATA_EFFDT"
)
ps_person = read_table(f"{student}.{bronze}.PS_PERSON").alias("PS_PERSON")
ps_residency_off = read_table(f"{student}.{bronze}.PS_RESIDENCY_OFF").alias(
    "PS_RESIDENCY_OFF"
)
ps_stdnt_test_comp = read_table(f"{student}.{bronze}.PS_STDNT_TEST_COMP").alias(
    "PS_STDNT_TEST_COMP"
)
ps_uta_tsi_section = read_table(f"{student}.{bronze}.PS_UTA_TSI_SECTION").alias(
    "PS_UTA_TSI_SECTION"
)
ps_uta_tsi_sta_exm = read_table(f"{student}.{bronze}.PS_UTA_TSI_STA_EXM").alias(
    "PS_UTA_TSI_STA_EXM"
)
ps_uta_tsi_trm_exm = read_table(f"{student}.{bronze}.PS_UTA_TSI_TRM_EXM").alias(
    "PS_UTA_TSI_TRM_EXM"
)
ps_trns_test_dtl = read_table(f"{student}.{bronze}.PS_TRNS_TEST_DTL").alias(
    "PS_TRNS_TEST_DTL"
)
ps_trns_crse_dtl = read_table(f"{student}.{bronze}.PS_TRNS_CRSE_DTL").alias(
    "PS_TRNS_CRSE_DTL"
)

# COMMAND ----------

# Merge_Terms
# Part-0
df_cbm002_merge_terms_part0 = adw_term_dim.filter(
    (F.col("ADW_TERM_DIM.STRM") == F.lit(current_term))
    & (F.col("ADW_TERM_DIM.ACAD_CAREER") == F.lit("UGRD"))
)

df_cbm002_merge_terms_part0 = df_cbm002_merge_terms_part0.select(
    F.col("ADW_TERM_DIM.STRM"),
    F.col("ADW_TERM_DIM.ACAD_CAREER"),
    F.col("ADW_TERM_DIM.TERM_BEGIN_DT"),
    F.col("ADW_TERM_DIM.TERM_END_DT"),
    F.col("ADW_TERM_DIM.TERM_SK"),
    F.col("ADW_TERM_DIM.CENSUS_DT"),
    F.col("ADW_TERM_DIM.STRM").alias("Current_Term"),
)

# Part-1
df_cbm002_merge_terms_part1 = adw_term_dim.filter(
    (F.col("ADW_TERM_DIM.ACAD_CAREER") == F.lit("UGRD"))
    & (F.col("ADW_TERM_DIM.STRM") == F.lit(prior_term))
    & (
        F.current_timestamp().cast("DATE")
        > F.col("ADW_TERM_DIM.TERM_END_DT").cast("DATE")
    )
)

df_cbm002_merge_terms_part1 = df_cbm002_merge_terms_part1.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ADW_TERM_DIM.STRM")).over(
        Window.partitionBy("ADW_TERM_DIM.ACAD_CAREER")
    ),
)

df_cbm002_merge_terms_part1 = df_cbm002_merge_terms_part1.filter(
    F.col("ADW_TERM_DIM.STRM") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_merge_terms_part1 = df_cbm002_merge_terms_part1.select(
    F.col("ADW_TERM_DIM.STRM"),
    F.col("ADW_TERM_DIM.ACAD_CAREER"),
    F.col("ADW_TERM_DIM.TERM_BEGIN_DT"),
    F.col("ADW_TERM_DIM.TERM_END_DT"),
    F.col("ADW_TERM_DIM.TERM_SK"),
    F.col("ADW_TERM_DIM.CENSUS_DT"),
    F.when(
        (F.substring(F.col("ADW_TERM_DIM.STRM"), 4, 1) == F.lit("8")),
        F.coalesce((F.col("ADW_TERM_DIM.STRM").cast("BIGINT") + F.lit(4)), F.lit(0)).cast("STRING"),
    )
    .otherwise((F.col("ADW_TERM_DIM.STRM").cast("BIGINT") + F.lit(3)).cast("STRING"))
    .alias("Current_Term"),
)

# Merge -> Part-0 & Part-1
df_cbm002_merge_terms = df_cbm002_merge_terms_part0.union(df_cbm002_merge_terms_part1)

# COMMAND ----------

# Term_Setup
df_cbm002_term_setup = df_cbm002_merge_terms.alias("MERGE_TERMS")

df_cbm002_term_setup = df_cbm002_term_setup.withColumn(
    "Current_Term_End_Date",
    F.max(F.date_format(F.col("MERGE_TERMS.TERM_END_DT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(F.col("MERGE_TERMS.ACAD_CAREER"))
    ),
)

df_cbm002_term_setup = df_cbm002_term_setup.select(
    F.col("MERGE_TERMS.STRM"),
    F.col("MERGE_TERMS.TERM_BEGIN_DT"),
    F.col("MERGE_TERMS.TERM_END_DT"),
    F.col("MERGE_TERMS.TERM_SK"),
    F.col("MERGE_TERMS.CENSUS_DT"),
    F.col("MERGE_TERMS.Current_Term"),
    F.col("MERGE_TERMS.ACAD_CAREER"),
    F.col("Current_Term_End_Date"),
)

# COMMAND ----------

# future_census

df_future_census = adw_term_dim.filter(
    (F.col("ADW_TERM_DIM.STRM") == F.lit(future_term))
    & (F.col("ADW_TERM_DIM.ACAD_CAREER") == F.lit("UGRD"))
)

df_future_census = df_future_census.select(F.col("ADW_TERM_DIM.CENSUS_DT")).collect()

future_census = df_future_census[0][0]

# COMMAND ----------

# Read source and extract variables
_df = df_cbm002_term_setup
_rows = _df.collect()

for _row in _rows:
    _d = _row.asDict()
    if str(_d.get("STRM", "")) == str(_d.get("Current_Term", "")):
        current_term_begin_date = str(_d["TERM_BEGIN_DT"])
        current_term_end_date = str(_d["TERM_END_DT"])
        current_term_sk = str(_d["TERM_SK"])
        current_term_census_date = str(_d["CENSUS_DT"])
        log_msg(
            ", current_term_begin_date: "
            + current_term_begin_date
            + ", current_term_end_date: "
            + current_term_end_date
            + ", current_term_sk: "
            + current_term_sk
            + ", current_term_census_date: "
            + current_term_census_date
        )
    else:
        prior_term_begin_date = str(_d["TERM_BEGIN_DT"])
        prior_term_end_date = str(_d["TERM_END_DT"])
        prior_term_sk = str(_d["TERM_SK"])
        prior_term_census_date = str(_d["CENSUS_DT"])
        log_msg(
            ", prior_term_begin_date: "
            + prior_term_begin_date
            + ", prior_term_end_date: "
            + prior_term_end_date
            + ", prior_term_sk: "
            + prior_term_sk
            + ", prior_term_census_date: "
            + prior_term_census_date
        )

# COMMAND ----------

# Step: Class Attribute Info
df_cbm002_class_attribute = ps_class_attribute.join(
    ps_crse_attr_value,
    on=(
        (F.col("PS_CLASS_ATTRIBUTE.CRSE_ATTR") == F.col("PS_CRSE_ATTR_VALUE.CRSE_ATTR"))
        & (
            F.col("PS_CLASS_ATTRIBUTE.CRSE_ATTR_VALUE")
            == F.col("PS_CRSE_ATTR_VALUE.CRSE_ATTR_VALUE")
        )
    ),
    how="inner",
)

df_cbm002_class_attribute = df_cbm002_class_attribute.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_CRSE_ATTR_VALUE.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "PS_CRSE_ATTR_VALUE.CRSE_ATTR", "PS_CRSE_ATTR_VALUE.CRSE_ATTR_VALUE"
        )
    ),
)

df_cbm002_class_attribute = df_cbm002_class_attribute.filter(
    F.date_format(F.col("PS_CRSE_ATTR_VALUE.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_class_attribute = df_cbm002_class_attribute.select(
    F.col("PS_CLASS_ATTRIBUTE.CRSE_ID"),
    F.col("PS_CLASS_ATTRIBUTE.CRSE_OFFER_NBR"),
    F.col("PS_CLASS_ATTRIBUTE.STRM"),
    F.col("PS_CLASS_ATTRIBUTE.SESSION_CODE"),
    F.col("PS_CLASS_ATTRIBUTE.CLASS_SECTION"),
    F.col("PS_CRSE_ATTR_VALUE.CRSE_ATTR").alias("ATTRVALTBL_ATTR"),
    F.col("PS_CRSE_ATTR_VALUE.CRSE_ATTR_VALUE").alias("ATTRVALTBL_ATTR_VALUE"),
).orderBy(
    F.col("CRSE_ID").asc(),
    F.col("CRSE_OFFER_NBR").asc(),
    F.col("STRM").asc(),
    F.col("SESSION_CODE").asc(),
    F.col("CLASS_SECTION").asc(),
)

# COMMAND ----------

# Step : CBM002_CLASS_ATTRIBUTES — BY-group catx/retain → sort_array + collect_list
# Sorts by ATTRVALTBL_ATTR / ATTRVALTBL_ATTR_VALUE

df_cbm002_class_attributes = df_cbm002_class_attribute.groupBy(
    "CRSE_ID", "CRSE_OFFER_NBR", "STRM", "SESSION_CODE", "CLASS_SECTION"
).agg(
    F.concat_ws(",", F.sort_array(F.collect_list(F.col("ATTRVALTBL_ATTR")))).alias(
        "ATTR_LIST"
    ),
    F.concat_ws(
        ",", F.sort_array(F.collect_list(F.col("ATTRVALTBL_ATTR_VALUE")))
    ).alias("VAL_LIST"),
)

# COMMAND ----------

# CBM002_CRSE_ATTRIBUTE
df_cbm002_crse_attribute = ps_crse_attributes.filter(
    F.date_format(F.col("PS_CRSE_ATTRIBUTES.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    <= F.date_format(F.lit(current_term_begin_date), "yyyy-MM-dd HH:mm:ss")
)

df_cbm002_crse_attribute = df_cbm002_crse_attribute.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_CRSE_ATTRIBUTES.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("PS_CRSE_ATTRIBUTES.CRSE_ID", "PS_CRSE_ATTRIBUTES.CRSE_ATTR")
    ),
)

df_cbm002_crse_attribute = df_cbm002_crse_attribute.filter(
    F.date_format(F.col("PS_CRSE_ATTRIBUTES.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_crse_attribute = df_cbm002_crse_attribute.select(
    F.col("PS_CRSE_ATTRIBUTES.CRSE_ATTR"),
    F.col("PS_CRSE_ATTRIBUTES.CRSE_ATTR_VALUE"),
    F.col("PS_CRSE_ATTRIBUTES.CRSE_ID"),
    F.col("PS_CRSE_ATTRIBUTES.EFFDT"),
    F.col("PS_CRSE_ATTRIBUTES.SCC_ROW_ADD_DTTM"),
    F.col("PS_CRSE_ATTRIBUTES.SCC_ROW_ADD_OPRID"),
    F.col("PS_CRSE_ATTRIBUTES.SCC_ROW_UPD_DTTM"),
    F.col("PS_CRSE_ATTRIBUTES.SCC_ROW_UPD_OPRID"),
)

# COMMAND ----------

# Step: CBM002_COURSE_ATTRIBUTE — BY-group catx/retain → sort_array + collect_list
# Sorts by CRSE_ATTR / CRSE_ATTR_VALUE

df_cbm002_course_attribute = df_cbm002_crse_attribute.groupBy("CRSE_ID").agg(
    F.concat_ws(",", F.sort_array(F.collect_list(F.col("CRSE_ATTR")))).alias(
        "CRSE_ATTR_LIST"
    ),
    F.concat_ws(",", F.sort_array(F.collect_list(F.col("CRSE_ATTR_VALUE")))).alias(
        "CRSE_VAL_LIST"
    ),
)

# COMMAND ----------

# CBM002_CORE_COURSE
df_cbm002_core_course = ps_crse_catalog.filter(
    (
        F.date_format(F.col("PS_CRSE_CATALOG.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.lit(current_term_begin_date), "yyyy-MM-dd HH:mm:ss")
    )
    & (F.col("PS_CRSE_CATALOG.EFF_STATUS") == F.lit("A"))
)

df_cbm002_core_course = df_cbm002_core_course.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_CRSE_CATALOG.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("PS_CRSE_CATALOG.CRSE_ID")
    ),
)

df_cbm002_core_course = df_cbm002_core_course.filter(
    F.date_format(F.col("PS_CRSE_CATALOG.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_core_course = df_cbm002_core_course.select(
    F.col("PS_CRSE_CATALOG.CRSE_ID"),
    F.col("PS_CRSE_CATALOG.COMPONENT_PRIMARY"),
    F.col("PS_CRSE_CATALOG.CRSE_CONTACT_HRS"),
    F.col("PS_CRSE_CATALOG.RQMNT_DESIGNTN"),
)

# COMMAND ----------

# Step: Course_Info
cbm002_class_attributes = df_cbm002_class_attributes.alias("CBM002_CLASS_ATTRIBUTES")
cbm002_course_attribute = df_cbm002_course_attribute.alias("CBM002_COURSE_ATTRIBUTE")
cbm002_core_course = df_cbm002_core_course.alias("CBM002_CORE_COURSE")
df_cbm002_course_info = (
    ps_class_tbl.join(
        ps_class_assoc,
        on=(
            (F.col("PS_CLASS_TBL.STRM") == F.col("PS_CLASS_ASSOC.STRM"))
            & (
                F.col("PS_CLASS_TBL.SESSION_CODE")
                == F.col("PS_CLASS_ASSOC.SESSION_CODE")
            )
            & (F.col("PS_CLASS_TBL.CRSE_ID") == F.col("PS_CLASS_ASSOC.CRSE_ID"))
            & (
                F.col("PS_CLASS_TBL.CRSE_OFFER_NBR")
                == F.col("PS_CLASS_ASSOC.CRSE_OFFER_NBR")
            )
            & (
                F.col("PS_CLASS_TBL.ASSOCIATED_CLASS")
                == F.col("PS_CLASS_ASSOC.ASSOCIATED_CLASS")
            )
        ),
        how="left",
    )
    .join(
        ps_uta_cb_loc_vw,
        on=(F.col("PS_CLASS_TBL.LOCATION") == F.col("PS_UTA_CB_LOC_VW.LOCATION")),
        how="left",
    )
    .join(
        cbm002_class_attributes,
        on=(
            (F.col("PS_CLASS_TBL.STRM") == F.col("CBM002_CLASS_ATTRIBUTES.STRM"))
            & (
                F.col("PS_CLASS_TBL.CRSE_ID")
                == F.col("CBM002_CLASS_ATTRIBUTES.CRSE_ID")
            )
            & (
                F.col("PS_CLASS_TBL.CRSE_OFFER_NBR")
                == F.col("CBM002_CLASS_ATTRIBUTES.CRSE_OFFER_NBR")
            )
            & (
                F.col("PS_CLASS_TBL.SESSION_CODE")
                == F.col("CBM002_CLASS_ATTRIBUTES.SESSION_CODE")
            )
            & (
                F.col("PS_CLASS_TBL.CLASS_SECTION")
                == F.col("CBM002_CLASS_ATTRIBUTES.CLASS_SECTION")
            )
        ),
        how="left",
    )
    .join(
        ps_utz_pt100_dtl,
        on=(
            (
                F.col("PS_CLASS_TBL.CATALOG_NBR")
                == F.col("PS_UTZ_PT100_DTL.UTZ_SETUP_RESULT")
            )
            & (
                F.col("PS_CLASS_TBL.SUBJECT")
                == F.col("PS_UTZ_PT100_DTL.UTZ_SETUP_RESULT")
            )
            & (
                F.substring(F.col("CBM002_CLASS_ATTRIBUTES.CLASS_SECTION"), 1, 1)
                == F.lit("C")
            )
            & (F.col("PS_UTZ_PT100_DTL.UTZ_SETUP_ID") == F.lit("UTA_R0202"))
            & (F.col("PS_UTZ_PT100_DTL.UTZ_SETUP_VALUE") == F.lit("NCBO"))
            & (F.col("PS_UTZ_PT100_DTL.UTZ_SETUP_VALUE") == F.lit("ARL"))
        ),
        how="left",
    )
    .join(
        ps_sctn_cmbnd,
        on=(
            (F.col("PS_CLASS_TBL.STRM") == F.col("PS_SCTN_CMBND.STRM"))
            & (
                F.col("PS_CLASS_TBL.SESSION_CODE")
                == F.col("PS_SCTN_CMBND.SESSION_CODE")
            )
            & (F.col("PS_CLASS_TBL.CLASS_NBR") == F.col("PS_SCTN_CMBND.CLASS_NBR"))
        ),
        how="left",
    )
    .join(
        cbm002_course_attribute,
        on=(F.col("PS_CLASS_TBL.CRSE_ID") == F.col("CBM002_COURSE_ATTRIBUTE.CRSE_ID")),
        how="left",
    )
    .join(
        cbm002_core_course,
        on=(
            F.col("CBM002_COURSE_ATTRIBUTE.CRSE_ID")
            == F.col("CBM002_CORE_COURSE.CRSE_ID")
        ),
        how="left",
    )
)

# COMMAND ----------

df_cbm002_course_info = df_cbm002_course_info.withColumn(
    "OFFSITE_LOC_CD_NEW",
    F.when(
        (
            ~F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD").isin(["0", "6", "9"])
            & F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD").isNotNull()
            & (F.trim(F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD")) != F.lit(""))
        ),
        F.substring(
            F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOC_VALUE"),
            (F.length(F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOC_VALUE")) - F.lit(4)),
            5,
        ),
    ).otherwise(F.lit("")),
)

df_cbm002_course_info = df_cbm002_course_info.withColumn(
    "EXT_LOC_FICE_NEW",
    F.when(
        F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD").isin(["0", "6", "9"]),
        F.when(
            (
                F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOC_VALUE").isNull()
                | (F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOC_VALUE") == F.lit(""))
            ),
            F.lit(""),
        ).otherwise(
            F.trim(
                F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOC_VALUE").cast("BIGINT").cast("STRING")
            )
        ),
    ).otherwise(F.lit("")),
)

df_cbm002_course_info = df_cbm002_course_info.withColumn(
    "UTA_CB_LOCATION_CD_NEW",
    F.when(
        (F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD") == F.lit("")), F.lit("0")
    ).otherwise(F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD")),
)

df_cbm002_course_info = df_cbm002_course_info.withColumn(
    "CB_Exclude_NEW",
    F.when(
        (
            F.locate("EXCLUDE", F.upper(F.col("cbm002_class_attributes.VAL_LIST")))
            != F.lit(0)
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

df_cbm002_course_info = df_cbm002_course_info.withColumn(
    "NCBO_NEW",
    F.when(
        (
            F.col("PS_UTZ_PT100_DTL.UTZ_SETUP_RESULT").isNotNull()
            & (F.col("PS_UTZ_PT100_DTL.UTZ_SETUP_RESULT") != F.lit(""))
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

df_cbm002_course_info = df_cbm002_course_info.withColumn(
    "MathCore_NEW",
    F.when(
        F.col("CBM002_CORE_COURSE.RQMNT_DESIGNTN").isin(["020", "2092", "092"]),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

df_cbm002_course_info = df_cbm002_course_info.withColumn(
    "ReadCore_NEW",
    F.when(
        F.col("CBM002_CORE_COURSE.RQMNT_DESIGNTN").isin(
            ["040", "060", "070", "080", "098", "4094", "8098"]
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

df_cbm002_course_info = df_cbm002_course_info.withColumn(
    "WriteCore_NEW",
    F.when(
        F.col("CBM002_CORE_COURSE.RQMNT_DESIGNTN").isin(["010", "1091"]), F.lit(1)
    ).otherwise(F.lit(0)),
)

# COMMAND ----------

df_cbm002_course_info = df_cbm002_course_info.select(
    F.col("PS_CLASS_TBL.ACAD_CAREER"),
    F.col("PS_CLASS_TBL.ACAD_GROUP"),
    F.col("PS_CLASS_TBL.ACAD_ORG"),
    F.col("PS_CLASS_TBL.CAMPUS"),
    F.col("PS_CLASS_TBL.CATALOG_NBR"),
    F.col("PS_CLASS_TBL.CLASS_NBR"),
    F.col("PS_CLASS_TBL.CLASS_SECTION"),
    F.col("PS_CLASS_TBL.CLASS_STAT"),
    F.col("PS_CLASS_TBL.CLASS_TYPE"),
    F.col("PS_SCTN_CMBND.SCTN_COMBINED_ID").alias("COMBINED_SECTION_ID"),
    F.col("PS_CLASS_TBL.CRSE_ID"),
    F.col("PS_CLASS_TBL.CRSE_OFFER_NBR"),
    F.col("PS_CLASS_TBL.END_DT"),
    F.col("PS_CLASS_TBL.ENRL_TOT"),
    F.col("PS_CLASS_TBL.INSTITUTION"),
    F.col("PS_CLASS_TBL.INSTRUCTION_MODE"),
    F.col("PS_CLASS_TBL.LOCATION"),
    F.col("PS_CLASS_TBL.SESSION_CODE"),
    F.col("PS_CLASS_TBL.SSR_COMPONENT"),
    F.col("PS_CLASS_TBL.START_DT"),
    F.col("PS_CLASS_TBL.STRM"),
    F.col("PS_CLASS_TBL.SUBJECT"),
    F.col("PS_CLASS_ASSOC.COMPONENT_PRIMARY"),
    F.col("PS_CLASS_ASSOC.CRSE_CONTACT_HRS"),
    F.col("PS_CLASS_ASSOC.UNITS_MAXIMUM"),
    F.col("OFFSITE_LOC_CD_NEW").alias("OFFSITE_LOC_CD"),
    F.col("EXT_LOC_FICE_NEW").alias("EXT_LOC_FICE"),
    F.col("UTA_CB_LOCATION_CD_NEW").alias("UTA_CB_LOCATION_CD"),
    F.col("CBM002_CLASS_ATTRIBUTES.ATTR_LIST").alias("CLASS_ATTR_LIST"),
    F.col("CBM002_CLASS_ATTRIBUTES.VAL_LIST").alias("CLASS_VAL_LIST"),
    F.col("CBM002_COURSE_ATTRIBUTE.CRSE_ATTR_LIST"),
    F.col("CBM002_COURSE_ATTRIBUTE.CRSE_VAL_LIST"),
    F.col("CB_Exclude_NEW").alias("CB_Exclude"),
    F.col("NCBO_NEW").alias("NCBO"),
    F.col("MathCore_NEW").alias("MathCore"),
    F.col("ReadCore_NEW").alias("ReadCore"),
    F.col("WriteCore_NEW").alias("WriteCore"),
)

# COMMAND ----------

# Step: Enrollment_Current_term
term_setup = df_cbm002_term_setup.alias("TERM_SETUP")

df_cbm002_studentenrollment = ps_stdnt_enrl.join(
    term_setup,
    on=(
        (F.col("PS_STDNT_ENRL.STRM") == F.col("TERM_SETUP.STRM"))
        & (F.col("PS_STDNT_ENRL.INSTITUTION") == F.lit("UTARL"))
        & (F.col("PS_STDNT_ENRL.STDNT_ENRL_STATUS") == F.lit("E"))
        & (
            (F.col("PS_STDNT_ENRL.ENRL_ACTN_RSN_LAST") != F.lit("CENS"))
            | F.col("PS_STDNT_ENRL.ENRL_ACTN_RSN_LAST").isNull()
            | (F.trim(F.col("PS_STDNT_ENRL.ENRL_ACTN_RSN_LAST")) == F.lit(""))
        )
        & (F.col("PS_STDNT_ENRL.ACAD_CAREER") == F.lit("UGRD"))
        & (F.col("PS_STDNT_ENRL.UNT_TAKEN") > F.lit(0))
    ),
    how="inner",
)

df_cbm002_studentenrollment = df_cbm002_studentenrollment.filter(
    (F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF") != F.lit("AU"))
    | (F.col("PS_STDNT_ENRL.GRADING_BASIS_ENRL") != F.lit("AUD"))
)

# COMMAND ----------

df_cbm002_studentenrollment = df_cbm002_studentenrollment.select(
    F.col("PS_STDNT_ENRL.ACAD_CAREER"),
    F.col("PS_STDNT_ENRL.ACAD_PROG"),
    F.col("PS_STDNT_ENRL.ASSOCIATED_CLASS"),
    F.col("PS_STDNT_ENRL.ASSOCIATION_99"),
    F.col("PS_STDNT_ENRL.AUDIT_GRADE_BASIS"),
    F.col("PS_STDNT_ENRL.CLASS_NBR"),
    F.col("PS_STDNT_ENRL.CLASS_PRMSN_NBR"),
    F.col("PS_STDNT_ENRL.CRSE_CAREER"),
    F.col("PS_STDNT_ENRL.CRSE_COUNT"),
    F.col("PS_STDNT_ENRL.CRSE_GRADE_INPUT"),
    F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF"),
    F.col("PS_STDNT_ENRL.DROP_CLASS_IF_ENRL"),
    F.col("PS_STDNT_ENRL.DYN_CLASS_NBR"),
    F.col("PS_STDNT_ENRL.EARN_CREDIT"),
    F.col("PS_STDNT_ENRL.EMPLID"),
    F.col("PS_STDNT_ENRL.ENRL_ACTION_LAST"),
    F.col("PS_STDNT_ENRL.ENRL_ACTN_PRC_LAST"),
    F.col("PS_STDNT_ENRL.ENRL_ACTN_RSN_LAST"),
    F.col("PS_STDNT_ENRL.ENRL_ADD_DT"),
    F.col("PS_STDNT_ENRL.ENRL_DROP_DT"),
    F.col("PS_STDNT_ENRL.ENRL_REQ_SOURCE"),
    F.col("PS_STDNT_ENRL.ENRL_STATUS_REASON"),
    F.col("PS_STDNT_ENRL.GRADE_CATEGORY"),
    F.col("PS_STDNT_ENRL.GRADE_DT"),
    F.col("PS_STDNT_ENRL.GRADE_POINTS"),
    F.col("PS_STDNT_ENRL.GRADE_POINTS_FA"),
    F.col("PS_STDNT_ENRL.GRADING_BASIS_DT"),
    F.col("PS_STDNT_ENRL.GRADING_BASIS_ENRL"),
    F.col("PS_STDNT_ENRL.GRADING_SCHEME_ENR"),
    F.col("PS_STDNT_ENRL.GRD_PTS_PER_UNIT"),
    F.col("PS_STDNT_ENRL.INCLUDE_IN_GPA"),
    F.col("PS_STDNT_ENRL.INSTITUTION"),
    F.col("PS_STDNT_ENRL.INSTRUCTOR_ID"),
    F.col("PS_STDNT_ENRL.LAST_DROP_DT_STMP"),
    F.col("PS_STDNT_ENRL.LAST_DROP_TM_STMP"),
    F.col("PS_STDNT_ENRL.LAST_ENRL_DT_STMP"),
    F.col("PS_STDNT_ENRL.LAST_ENRL_TM_STMP"),
    F.col("PS_STDNT_ENRL.LAST_UPD_DT_STMP"),
    F.col("PS_STDNT_ENRL.LAST_UPD_ENREQ_SRC"),
    F.col("PS_STDNT_ENRL.LAST_UPD_TM_STMP"),
    F.col("PS_STDNT_ENRL.MANDATORY_GRD_BAS"),
    F.col("PS_STDNT_ENRL.NOTIFY_STDNT_CHNG"),
    F.col("PS_STDNT_ENRL.OPRID"),
    F.col("PS_STDNT_ENRL.OVRD_GRADING_BASIS"),
    F.col("PS_STDNT_ENRL.RELATE_CLASS_NBR_1"),
    F.col("PS_STDNT_ENRL.RELATE_CLASS_NBR_2"),
    F.col("PS_STDNT_ENRL.REPEAT_CANDIDATE"),
    F.col("PS_STDNT_ENRL.REPEAT_CODE"),
    F.col("PS_STDNT_ENRL.REPEAT_DT"),
    F.col("PS_STDNT_ENRL.RQMNT_DESIGNTN"),
    F.col("PS_STDNT_ENRL.RQMNT_DESIGNTN_GRD"),
    F.col("PS_STDNT_ENRL.RQMNT_DESIGNTN_OPT"),
    F.col("PS_STDNT_ENRL.RSRV_CAP_NBR"),
    F.col("PS_STDNT_ENRL.SEL_GROUP"),
    F.col("PS_STDNT_ENRL.SESSION_CODE"),
    F.col("PS_STDNT_ENRL.SESSN_ENRL_CNTL"),
    F.col("PS_STDNT_ENRL.STATUS_DT"),
    F.col("PS_STDNT_ENRL.STDNT_ENRL_STATUS"),
    F.col("PS_STDNT_ENRL.STDNT_POSITIN"),
    F.col("PS_STDNT_ENRL.STRM"),
    F.col("PS_STDNT_ENRL.TSCRPT_NOTE_EXISTS"),
    F.col("PS_STDNT_ENRL.TSCRPT_NOTE_ID"),
    F.col("PS_STDNT_ENRL.UNITS_ATTEMPTED"),
    F.col("PS_STDNT_ENRL.UNT_BILLING"),
    F.col("PS_STDNT_ENRL.UNT_EARNED"),
    F.col("PS_STDNT_ENRL.UNT_PRGRSS"),
    F.col("PS_STDNT_ENRL.UNT_PRGRSS_FA"),
    F.col("PS_STDNT_ENRL.UNT_TAKEN"),
    F.col("PS_STDNT_ENRL.VALID_ATTEMPT"),
    F.col("TERM_SETUP.TERM_BEGIN_DT"),
    F.col("TERM_SETUP.TERM_END_DT"),
    F.col("TERM_SETUP.CENSUS_DT"),
    F.col("TERM_SETUP.Current_Term"),
    F.col("TERM_SETUP.Current_Term_End_Date"),
)

# COMMAND ----------

# Checkpoint 1: materialize df_cbm002_studentenrollment to break the upstream DAG
_tmp_stageA_tbl = f"{analytics}.{staging}._tmp_cbm002_studentenrollment"
write_df_to_table(
    df_cbm002_studentenrollment,
    _tmp_stageA_tbl,
    mode="overwrite",
    overwriteSchema="true",
)
df_cbm002_studentenrollment = read_table(_tmp_stageA_tbl).alias(
    "CBM002_StudentEnrollment"
)
log_msg(f"Checkpoint 1 materialized: {_tmp_stageA_tbl}")

# COMMAND ----------

# Step: Prior Core Course Enrollment
cbm002_course_info = df_cbm002_course_info.alias("CBM002_Course_Info")
cbm002_studentenrollment = df_cbm002_studentenrollment.alias("CBM002_StudentEnrollment")

df_priorcorecourseenrollment = cbm002_studentenrollment.join(
    ps_stdnt_enrl,
    on=(
        (F.col("CBM002_StudentEnrollment.EMPLID") == F.col("PS_STDNT_ENRL.EMPLID"))
        & (
            F.col("CBM002_StudentEnrollment.ACAD_CAREER")
            == F.col("PS_STDNT_ENRL.ACAD_CAREER")
        )
        & (F.col("PS_STDNT_ENRL.STRM") < F.lit(current_term))
        & (F.col("PS_STDNT_ENRL.STDNT_ENRL_STATUS") == F.lit("E"))
        & (F.col("PS_STDNT_ENRL.UNT_TAKEN") > F.lit(0))
    ),
    how="left",
).join(
    cbm002_course_info,
    on=(
        (F.col("PS_STDNT_ENRL.STRM") == F.col("CBM002_Course_Info.STRM"))
        & (
            F.col("PS_STDNT_ENRL.SESSION_CODE")
            == F.col("CBM002_Course_Info.SESSION_CODE")
        )
        & (F.col("PS_STDNT_ENRL.CLASS_NBR") == F.col("CBM002_Course_Info.CLASS_NBR"))
    ),
    how="inner",
)

df_priorcorecourseenrollment = df_priorcorecourseenrollment.filter(
    (F.col("PS_STDNT_ENRL.STRM") <= F.lit(prior_term))
    & (
        F.date_format(F.col("CBM002_Course_Info.END_DT"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.lit(prior_term_end_date), "yyyy-MM-dd HH:mm:ss")
    )
    & (
        (F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF") != F.lit("AU"))
        | (F.col("PS_STDNT_ENRL.GRADING_BASIS_ENRL") != F.lit("AUD"))
    )
)

# COMMAND ----------

_winSpec_1 = Window.partitionBy(F.col("CBM002_StudentEnrollment.EMPLID"))

df_priorcorecourseenrollment = df_priorcorecourseenrollment.withColumn(
    "MathCoreCoursePriorEnrolled",
    F.max(
        F.when(
            (
                (
                    (F.col("CBM002_Course_Info.MathCore") == F.lit(1))
                    & F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF").isin(["A", "B", "C"])
                )
                | (
                    F.col("PS_STDNT_ENRL.STRM").isin(["2202", "2205", "2208"])
                    & (F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF") == F.lit("P"))
                )
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_winSpec_1),
)

df_priorcorecourseenrollment = df_priorcorecourseenrollment.withColumn(
    "ReadCoreCoursePriorEnrolled",
    F.max(
        F.when(
            (
                (
                    (F.col("CBM002_Course_Info.ReadCore") == F.lit(1))
                    & F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF").isin(["A", "B", "C"])
                )
                | (
                    F.col("PS_STDNT_ENRL.STRM").isin(["2202", "2205", "2208"])
                    & (F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF") == F.lit("P"))
                )
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_winSpec_1),
)

df_priorcorecourseenrollment = df_priorcorecourseenrollment.withColumn(
    "WriteCoreCoursePriorEnrolled",
    F.max(
        F.when(
            (
                (
                    (F.col("CBM002_Course_Info.WriteCore") == F.lit(1))
                    & F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF").isin(["A", "B", "C"])
                )
                | (
                    F.col("PS_STDNT_ENRL.STRM").isin(["2202", "2205", "2208"])
                    & (F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF") == F.lit("P"))
                )
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_winSpec_1),
)

df_priorcorecourseenrollment = df_priorcorecourseenrollment.select(
    F.col("CBM002_StudentEnrollment.ACAD_CAREER"),
    F.col("CBM002_StudentEnrollment.EMPLID"),
    F.col("MathCoreCoursePriorEnrolled"),
    F.col("ReadCoreCoursePriorEnrolled"),
    F.col("WriteCoreCoursePriorEnrolled"),
).distinct()

# COMMAND ----------

# Step: Prior Enrolled
df_priorenrolled = cbm002_studentenrollment.join(
    ps_stdnt_enrl,
    on=(
        (F.col("CBM002_StudentEnrollment.EMPLID") == F.col("PS_STDNT_ENRL.EMPLID"))
        & (F.col("PS_STDNT_ENRL.STRM") < F.lit(current_term))
    ),
    how="left",
)

df_priorenrolled = df_priorenrolled.filter(
    (
        F.coalesce(F.trim(F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF")), F.lit(""))
        != F.lit("AU")
    )
    | (
        F.coalesce(F.trim(F.col("PS_STDNT_ENRL.GRADING_BASIS_ENRL")), F.lit(""))
        != F.lit("AUD")
    )
)

df_priorenrolled = df_priorenrolled.withColumn(
    "PriorEnrolled",
    F.when(
        (
            F.col("PS_STDNT_ENRL.EMPLID").isNotNull()
            & (F.trim(F.col("PS_STDNT_ENRL.EMPLID")) != F.lit(""))
        ),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_priorenrolled = df_priorenrolled.select(
    F.col("CBM002_StudentEnrollment.ACAD_CAREER"),
    F.col("CBM002_StudentEnrollment.EMPLID"),
    F.col("PriorEnrolled"),
).distinct()

# COMMAND ----------

# Step: Enrollment+Course
priorcorecourseenrollment = df_priorcorecourseenrollment.alias(
    "PriorCoreCourseEnrollment"
)
priorenrolled = df_priorenrolled.alias("PriorEnrolled")

df_cbm002_enrollment = (
    cbm002_studentenrollment.join(
        cbm002_course_info,
        on=(
            (F.col("CBM002_StudentEnrollment.STRM") == F.col("CBM002_Course_Info.STRM"))
            & (
                F.col("CBM002_StudentEnrollment.SESSION_CODE")
                == F.col("CBM002_Course_Info.SESSION_CODE")
            )
            & (
                F.col("CBM002_StudentEnrollment.CLASS_NBR")
                == F.col("CBM002_Course_Info.CLASS_NBR")
            )
            & (F.col("CBM002_Course_Info.INSTITUTION") == F.lit("UTARL"))
            & (F.col("CBM002_StudentEnrollment.STDNT_ENRL_STATUS") == F.lit("E"))
            & (F.col("CBM002_StudentEnrollment.UNT_TAKEN") > F.lit(0))
            & (
                (F.col("CBM002_StudentEnrollment.ENRL_ACTN_RSN_LAST") != F.lit("CENS"))
                | F.col("CBM002_StudentEnrollment.ENRL_ACTN_RSN_LAST").isNull()
                | (F.col("CBM002_StudentEnrollment.ENRL_ACTN_RSN_LAST") == F.lit(""))
            )
            & F.col("CBM002_Course_Info.CLASS_STAT").isin(["A", "S"])
            & F.col("CBM002_Course_Info.CLASS_TYPE").isin(["E", "N"])
            & (F.col("CBM002_StudentEnrollment.ACAD_CAREER") == F.lit("UGRD"))
        ),
        how="inner",
    )
    .join(
        priorcorecourseenrollment,
        on=(
            (
                F.col("CBM002_StudentEnrollment.EMPLID")
                == F.col("PriorCoreCourseEnrollment.EMPLID")
            )
            & (
                F.col("CBM002_StudentEnrollment.ACAD_CAREER")
                == F.col("PriorCoreCourseEnrollment.ACAD_CAREER")
            )
        ),
        how="left",
    )
    .join(
        priorenrolled,
        on=(
            (F.col("CBM002_StudentEnrollment.EMPLID") == F.col("PriorEnrolled.EMPLID"))
            & (
                F.col("CBM002_StudentEnrollment.ACAD_CAREER")
                == F.col("PriorEnrolled.ACAD_CAREER")
            )
        ),
        how="left",
    )
)

# COMMAND ----------

df_cbm002_enrollment = df_cbm002_enrollment.withColumn(
    "Current_Term_Reportable_New",
    F.when(
        (
            (
                (
                    F.col("CBM002_StudentEnrollment.STRM")
                    == F.col("CBM002_StudentEnrollment.Current_Term")
                )
                & (F.trim(F.col("CBM002_StudentEnrollment.SESSION_CODE")) == F.lit("1"))
                & F.substring(F.col("CBM002_StudentEnrollment.STRM"), 4, 1).isin(
                    ["2", "8"]
                )
            )
            | (
                (
                    F.col("CBM002_StudentEnrollment.STRM")
                    == F.col("CBM002_StudentEnrollment.Current_Term")
                )
                & (
                    F.trim(F.col("CBM002_StudentEnrollment.SESSION_CODE"))
                    == F.lit("5W2")
                )
                & (
                    F.substring(F.col("CBM002_StudentEnrollment.STRM"), 4, 1)
                    == F.lit("5")
                )
            )
            | (
                (
                    F.col("CBM002_StudentEnrollment.STRM")
                    == F.col("CBM002_StudentEnrollment.Current_Term")
                )
                & (F.col("CBM002_StudentEnrollment.SESSION_CODE") != F.lit("1"))
                & F.substring(F.col("CBM002_StudentEnrollment.STRM"), 4, 1).isin(
                    ["2", "8"]
                )
                & (
                    F.date_format(
                        F.col("CBM002_Course_Info.END_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    <= F.date_format(
                        F.col("CBM002_StudentEnrollment.Current_Term_End_Date"),
                        "yyyy-MM-dd HH:mm:ss",
                    )
                )
            )
            | (
                (
                    F.col("CBM002_StudentEnrollment.STRM")
                    == F.col("CBM002_StudentEnrollment.Current_Term")
                )
                & (F.col("CBM002_StudentEnrollment.SESSION_CODE") != F.lit("5W2"))
                & (
                    F.substring(F.col("CBM002_StudentEnrollment.STRM"), 4, 1)
                    == F.lit("5")
                )
                & (
                    F.date_format(
                        F.col("CBM002_Course_Info.END_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    <= F.date_format(
                        F.col("CBM002_StudentEnrollment.Current_Term_End_Date"),
                        "yyyy-MM-dd HH:mm:ss",
                    )
                )
            )
            | (
                (
                    (
                        F.col("CBM002_StudentEnrollment.Current_Term").cast("BIGINT")
                        - F.col("CBM002_StudentEnrollment.STRM").cast("BIGINT")
                    )
                    > F.lit(0)
                )
                & (F.col("CBM002_StudentEnrollment.SESSION_CODE") != F.lit("5W2"))
                & F.substring(
                    F.col("CBM002_StudentEnrollment.Current_Term"), 4, 1
                ).isin(["2", "8"])
                & (
                    F.date_format(
                        F.col("CBM002_Course_Info.END_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    <= F.date_format(
                        F.col("CBM002_StudentEnrollment.Current_Term_End_Date"),
                        "yyyy-MM-dd HH:mm:ss",
                    )
                )
                & (
                    F.date_format(
                        F.col("CBM002_Course_Info.END_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    > F.date_format(
                        F.col("CBM002_StudentEnrollment.TERM_END_DT"),
                        "yyyy-MM-dd HH:mm:ss",
                    )
                )
            )
            | (
                (
                    (
                        F.col("CBM002_StudentEnrollment.Current_Term").cast("BIGINT")
                        - F.col("CBM002_StudentEnrollment.STRM").cast("BIGINT")
                    )
                    > F.lit(0)
                )
                & (F.col("CBM002_StudentEnrollment.SESSION_CODE") != F.lit("1"))
                & (
                    F.substring(F.col("CBM002_StudentEnrollment.Current_Term"), 4, 1)
                    == F.lit("5")
                )
                & (
                    F.date_format(
                        F.col("CBM002_Course_Info.END_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    <= F.date_format(
                        F.col("CBM002_StudentEnrollment.Current_Term_End_Date"),
                        "yyyy-MM-dd HH:mm:ss",
                    )
                )
                & (
                    F.date_format(
                        F.col("CBM002_Course_Info.END_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    > F.date_format(
                        F.col("CBM002_StudentEnrollment.TERM_END_DT"),
                        "yyyy-MM-dd HH:mm:ss",
                    )
                )
            )
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

# COMMAND ----------

df_cbm002_enrollment = df_cbm002_enrollment.withColumn(
    "MathCoreCourseEnrolled_New",
    F.when(
        (
            (
                (F.col("CBM002_Course_Info.MathCore") == F.lit(1))
                & F.col("CBM002_StudentEnrollment.CRSE_GRADE_OFF").isin(["A", "B", "C"])
            )
            | (
                F.col("CBM002_StudentEnrollment.STRM").isin(["2202", "2205", "2208"])
                & (F.col("CBM002_StudentEnrollment.CRSE_GRADE_OFF") == F.lit("P"))
            )
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

df_cbm002_enrollment = df_cbm002_enrollment.withColumn(
    "ReadCoreCourseEnrolled_New",
    F.when(
        (
            (
                (F.col("CBM002_Course_Info.ReadCore") == F.lit(1))
                & F.col("CBM002_StudentEnrollment.CRSE_GRADE_OFF").isin(["A", "B", "C"])
            )
            | (
                F.col("CBM002_StudentEnrollment.STRM").isin(["2202", "2205", "2208"])
                & (F.col("CBM002_StudentEnrollment.CRSE_GRADE_OFF") == F.lit("P"))
            )
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

df_cbm002_enrollment = df_cbm002_enrollment.withColumn(
    "WriteCoreCourseEnrolled_New",
    F.when(
        (
            (
                (F.col("CBM002_Course_Info.WriteCore") == F.lit(1))
                & F.col("CBM002_StudentEnrollment.CRSE_GRADE_OFF").isin(["A", "B", "C"])
            )
            | (
                F.col("CBM002_StudentEnrollment.STRM").isin(["2202", "2205", "2208"])
                & (F.col("CBM002_StudentEnrollment.CRSE_GRADE_OFF") == F.lit("P"))
            )
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

# COMMAND ----------

df_cbm002_enrollment = df_cbm002_enrollment.withColumn(
    "MathCoreCoursePriorEnrolled_New",
    F.when(
        (F.col("PriorCoreCourseEnrollment.MathCoreCoursePriorEnrolled") == F.lit(1)),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm002_enrollment = df_cbm002_enrollment.withColumn(
    "ReadCoreCoursePriorEnrolled_New",
    F.when(
        (F.col("PriorCoreCourseEnrollment.ReadCoreCoursePriorEnrolled") == F.lit(1)),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm002_enrollment = df_cbm002_enrollment.withColumn(
    "WriteCoreCoursePriorEnrolled_New",
    F.when(
        (F.col("PriorCoreCourseEnrollment.WriteCoreCoursePriorEnrolled") == F.lit(1)),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm002_enrollment = df_cbm002_enrollment.select(
    F.col("CBM002_StudentEnrollment.ACAD_CAREER"),
    F.col("CBM002_StudentEnrollment.ACAD_PROG"),
    F.col("CBM002_StudentEnrollment.CRSE_CAREER"),
    F.col("CBM002_StudentEnrollment.EMPLID"),
    F.col("CBM002_StudentEnrollment.ENRL_STATUS_REASON"),
    F.col("CBM002_StudentEnrollment.INSTITUTION"),
    F.col("CBM002_StudentEnrollment.STRM"),
    F.col("CBM002_Course_Info.SESSION_CODE"),
    F.col("CBM002_Course_Info.SUBJECT"),
    F.col("CBM002_Course_Info.CLASS_NBR"),
    F.col("CBM002_Course_Info.CATALOG_NBR"),
    F.col("CBM002_StudentEnrollment.UNT_EARNED"),
    F.col("CBM002_StudentEnrollment.UNT_PRGRSS"),
    F.col("CBM002_StudentEnrollment.UNT_TAKEN"),
    F.col("CBM002_Course_Info.START_DT"),
    F.col("CBM002_Course_Info.END_DT"),
    F.col("CBM002_StudentEnrollment.TERM_END_DT"),
    F.col("CBM002_StudentEnrollment.CENSUS_DT"),
    F.col("CBM002_StudentEnrollment.Current_Term_End_Date"),
    F.col("CBM002_Course_Info.CLASS_SECTION"),
    F.col("CBM002_Course_Info.CLASS_STAT"),
    F.col("CBM002_Course_Info.CLASS_TYPE"),
    F.col("CBM002_StudentEnrollment.GRADE_CATEGORY"),
    F.col("CBM002_StudentEnrollment.GRADE_POINTS"),
    F.col("CBM002_Course_Info.CRSE_ID"),
    F.col("CBM002_Course_Info.CRSE_OFFER_NBR"),
    F.col("CBM002_Course_Info.INSTRUCTION_MODE"),
    F.col("CBM002_Course_Info.LOCATION"),
    F.col("CBM002_Course_Info.ENRL_TOT"),
    F.col("CBM002_Course_Info.SSR_COMPONENT"),
    F.col("CBM002_Course_Info.COMPONENT_PRIMARY"),
    F.col("CBM002_Course_Info.CRSE_CONTACT_HRS"),
    F.col("CBM002_Course_Info.UNITS_MAXIMUM"),
    F.col("CBM002_Course_Info.ACAD_GROUP"),
    F.col("CBM002_Course_Info.ACAD_ORG"),
    F.col("CBM002_Course_Info.CAMPUS"),
    F.col("CBM002_Course_Info.OFFSITE_LOC_CD"),
    F.col("CBM002_Course_Info.EXT_LOC_FICE"),
    F.col("CBM002_Course_Info.UTA_CB_LOCATION_CD"),
    F.col("CBM002_Course_Info.CB_Exclude"),
    F.col("CBM002_StudentEnrollment.REPEAT_CANDIDATE"),
    F.col("CBM002_Course_Info.CLASS_ATTR_LIST"),
    F.col("CBM002_Course_Info.CLASS_VAL_LIST"),
    F.col("CBM002_StudentEnrollment.TERM_BEGIN_DT"),
    F.col("CBM002_Course_Info.NCBO"),
    F.col("CBM002_StudentEnrollment.CRSE_GRADE_OFF"),
    F.col("CBM002_Course_Info.COMBINED_SECTION_ID"),
    F.col("CBM002_Course_Info.CRSE_ATTR_LIST"),
    F.col("CBM002_Course_Info.CRSE_VAL_LIST"),
    F.col("CBM002_StudentEnrollment.Current_Term"),
    F.lit("").alias("Core_Course"),
    F.col("Current_Term_Reportable_New").alias("Current_Term_Reportable"),
    F.col("MathCoreCourseEnrolled_New").alias("MathCoreCourseEnrolled"),
    F.col("ReadCoreCourseEnrolled_New").alias("ReadCoreCourseEnrolled"),
    F.col("WriteCoreCourseEnrolled_New").alias("WriteCoreCourseEnrolled"),
    F.col("MathCoreCoursePriorEnrolled_New").alias("MathCoreCoursePriorEnrolled"),
    F.col("ReadCoreCoursePriorEnrolled_New").alias("ReadCoreCoursePriorEnrolled"),
    F.col("WriteCoreCoursePriorEnrolled_New").alias("WriteCoreCoursePriorEnrolled"),
    F.col("PriorEnrolled.PriorEnrolled"),
)

# COMMAND ----------

# CBM002_Cohort
df_cbm002_cohort = df_cbm002_enrollment.alias("CBM002_Enrollment")

df_cbm002_cohort = df_cbm002_cohort.filter(
    F.col("CBM002_Enrollment.Current_Term_Reportable") == F.lit("Yes")
)

_winSpec_2 = Window.partitionBy(
    F.col("CBM002_Enrollment.Current_Term"), F.col("CBM002_Enrollment.EMPLID")
)

# Max - MathCoreCourseEnrolled
df_cbm002_cohort = df_cbm002_cohort.withColumn(
    "_sel_tmp_0_0",
    F.max(F.col("CBM002_Enrollment.MathCoreCourseEnrolled")).over(_winSpec_2),
)
df_cbm002_cohort = df_cbm002_cohort.withColumn(
    "MathCoreCourseEnrolled_New",
    F.when((F.col("_sel_tmp_0_0") == F.lit(1)), F.lit("Y")).otherwise(F.lit("N")),
).drop("_sel_tmp_0_0")

# Max - ReadCoreCourseEnrolled
df_cbm002_cohort = df_cbm002_cohort.withColumn(
    "_sel_tmp_1_0",
    F.max(F.col("CBM002_Enrollment.ReadCoreCourseEnrolled")).over(_winSpec_2),
)
df_cbm002_cohort = df_cbm002_cohort.withColumn(
    "ReadCoreCourseEnrolled_New",
    F.when((F.col("_sel_tmp_1_0") == F.lit(1)), F.lit("Y")).otherwise(F.lit("N")),
).drop("_sel_tmp_1_0")

# Max - WriteCoreCourseEnrolled
df_cbm002_cohort = df_cbm002_cohort.withColumn(
    "_sel_tmp_2_0",
    F.max(F.col("CBM002_Enrollment.WriteCoreCourseEnrolled")).over(_winSpec_2),
)
df_cbm002_cohort = df_cbm002_cohort.withColumn(
    "WriteCoreCourseEnrolled_New",
    F.when((F.col("_sel_tmp_2_0") == F.lit(1)), F.lit("Y")).otherwise(F.lit("N")),
).drop("_sel_tmp_2_0")

# Flex
df_cbm002_cohort = df_cbm002_cohort.withColumn(
    "Flex_New",
    F.when(
        (
            (
                (
                    F.col("CBM002_Enrollment.Current_Term").cast("BIGINT")
                    - F.col("CBM002_Enrollment.STRM").cast("BIGINT")
                )
                > F.lit(0)
            )
            & (
                F.col("CBM002_Enrollment.START_DT")
                <= F.col("CBM002_Enrollment.CENSUS_DT")
            )
            & (
                F.col("CBM002_Enrollment.END_DT")
                > F.col("CBM002_Enrollment.TERM_END_DT")
            )
            & (
                F.col("CBM002_Enrollment.END_DT")
                <= F.col("CBM002_Enrollment.Current_Term_End_date")
            )
        ),
        F.lit("6"),
    )
    .when(
        (
            (
                (
                    F.col("CBM002_Enrollment.Current_Term").cast("BIGINT")
                    - F.col("CBM002_Enrollment.STRM").cast("BIGINT")
                )
                > F.lit(0)
            )
            & (
                F.col("CBM002_Enrollment.START_DT")
                > F.col("CBM002_Enrollment.CENSUS_DT")
            )
            & (
                F.col("CBM002_Enrollment.END_DT")
                > F.col("CBM002_Enrollment.TERM_END_DT")
            )
            & (
                F.col("CBM002_Enrollment.END_DT")
                <= F.col("CBM002_Enrollment.Current_Term_End_date")
            )
        ),
        F.lit("6"),
    )
    .otherwise(F.lit(None)),
)

df_cbm002_cohort = df_cbm002_cohort.withColumn(
    "Year_New",
    F.concat(F.lit("20"), F.substring(F.col("CBM002_Enrollment.Current_Term"), 2, 2)),
)

# COMMAND ----------

df_cbm002_cohort = df_cbm002_cohort.select(
    F.col("CBM002_Enrollment.ACAD_CAREER"),
    F.col("CBM002_Enrollment.ACAD_PROG"),
    F.col("CBM002_Enrollment.CRSE_CAREER"),
    F.col("CBM002_Enrollment.EMPLID"),
    F.col("CBM002_Enrollment.STRM"),
    F.col("CBM002_Enrollment.TERM_END_DT"),
    F.col("CBM002_Enrollment.CENSUS_DT"),
    F.col("CBM002_Enrollment.Current_Term_End_date"),
    F.col("CBM002_Enrollment.TERM_BEGIN_DT"),
    F.col("CBM002_Enrollment.Current_Term"),
    F.col("MathCoreCourseEnrolled_New").alias("MathCoreCourseEnrolled"),
    F.col("ReadCoreCourseEnrolled_New").alias("ReadCoreCourseEnrolled"),
    F.col("WriteCoreCourseEnrolled_New").alias("WriteCoreCourseEnrolled"),
    F.col("CBM002_Enrollment.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_Enrollment.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_Enrollment.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_Enrollment.PriorEnrolled"),
    F.col("Flex_New").alias("Flex"),
    F.col("Year_New").alias("Year"),
).distinct()

# COMMAND ----------

# Step: Acad Plan Info
# ACAD_PLAN_MAX_EFFSEQ -> MAX EFFSEQ
df_ACAD_PLAN_MAX_EFFSEQ = ps_acad_plan.withColumn(
    "_agg_tmp_0",
    F.max(F.col("PS_ACAD_PLAN.EFFSEQ")).over(
        Window.partitionBy(
            "PS_ACAD_PLAN.EMPLID",
            "PS_ACAD_PLAN.ACAD_CAREER",
            "PS_ACAD_PLAN.STDNT_CAR_NBR",
            "PS_ACAD_PLAN.EFFDT",
        )
    ),
)

df_ACAD_PLAN_MAX_EFFSEQ = df_ACAD_PLAN_MAX_EFFSEQ.filter(
    F.col("PS_ACAD_PLAN.EFFSEQ") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

# COMMAND ----------

# ACAD_PLAN_MAX_EFFSEQ -> MAX EFFSEQ
df_ACAD_PLAN_MIN_PLANSEQ = df_ACAD_PLAN_MAX_EFFSEQ.alias("ACAD_PLAN_MAX_EFFSEQ")

df_ACAD_PLAN_MIN_PLANSEQ = df_ACAD_PLAN_MIN_PLANSEQ.withColumn(
    "_agg_tmp_0",
    F.min(F.col("ACAD_PLAN_MAX_EFFSEQ.PLAN_SEQUENCE")).over(
        Window.partitionBy(
            "ACAD_PLAN_MAX_EFFSEQ.EMPLID",
            "ACAD_PLAN_MAX_EFFSEQ.ACAD_CAREER",
            "ACAD_PLAN_MAX_EFFSEQ.STDNT_CAR_NBR",
            "ACAD_PLAN_MAX_EFFSEQ.EFFDT",
        )
    ),
)

df_ACAD_PLAN_MIN_PLANSEQ = df_ACAD_PLAN_MIN_PLANSEQ.filter(
    (F.col("ACAD_PLAN_MAX_EFFSEQ.PLAN_SEQUENCE") == F.col("_agg_tmp_0"))
).drop("_agg_tmp_0")

# COMMAND ----------

# cbm002_max_acad_plan
df_cbm002_max_acad_plan = df_cbm002_cohort.alias("CBM002_Cohort")

df_cbm002_max_acad_plan = df_cbm002_max_acad_plan.join(
    df_ACAD_PLAN_MIN_PLANSEQ.alias("ACAD_PLAN_MIN_PLANSEQ"),
    on=(
        (F.col("CBM002_Cohort.EMPLID") == F.col("ACAD_PLAN_MIN_PLANSEQ.EMPLID"))
        & (
            F.col("CBM002_Cohort.ACAD_CAREER")
            == F.col("ACAD_PLAN_MIN_PLANSEQ.ACAD_CAREER")
        )
        & (
            F.date_format(
                F.col("CBM002_Cohort.Current_Term_End_date"), "yyyy-MM-dd HH:mm:ss"
            )
            >= F.date_format(
                F.col("ACAD_PLAN_MIN_PLANSEQ.EFFDT"), "yyyy-MM-dd HH:mm:ss"
            )
        )
    ),
    how="left",
)

df_cbm002_max_acad_plan = df_cbm002_max_acad_plan.withColumn(
    "_agg_tmp_0",
    F.max(
        F.date_format(F.col("ACAD_PLAN_MIN_PLANSEQ.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    ).over(
        Window.partitionBy(
            "CBM002_Cohort.STRM",
            "CBM002_Cohort.EMPLID",
            "CBM002_Cohort.ACAD_CAREER",
            "ACAD_PLAN_MIN_PLANSEQ.STDNT_CAR_NBR",
        )
    ),
)

df_cbm002_max_acad_plan = df_cbm002_max_acad_plan.filter(
    F.date_format(F.col("ACAD_PLAN_MIN_PLANSEQ.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_max_acad_plan = df_cbm002_max_acad_plan.select(
    F.col("CBM002_Cohort.ACAD_CAREER"),
    F.col("CBM002_Cohort.ACAD_PROG"),
    F.col("CBM002_Cohort.CRSE_CAREER"),
    F.col("CBM002_Cohort.EMPLID"),
    F.col("CBM002_Cohort.STRM"),
    F.col("CBM002_Cohort.TERM_BEGIN_DT"),
    F.col("CBM002_Cohort.TERM_END_DT"),
    F.col("CBM002_Cohort.CENSUS_DT"),
    F.col("CBM002_Cohort.Current_Term_End_date"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.STDNT_CAR_NBR"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.EFFDT"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.EFFSEQ"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.ACAD_PLAN"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.REQ_TERM"),
    F.col("CBM002_Cohort.Current_Term"),
    F.col("CBM002_Cohort.MathCoreCourseEnrolled"),
    F.col("CBM002_Cohort.ReadCoreCourseEnrolled"),
    F.col("CBM002_Cohort.WriteCoreCourseEnrolled"),
    F.col("CBM002_Cohort.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_Cohort.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_Cohort.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_Cohort.PriorEnrolled"),
    F.col("CBM002_Cohort.Flex"),
    F.col("CBM002_Cohort.Year"),
).distinct()

# COMMAND ----------

# Checkpoint 2: materialize df_cbm002_max_acad_plan to break the upstream DAG
_tmp_stageB_tbl = f"{analytics}.{staging}._tmp_cbm002_max_acad_plan"
write_df_to_table(
    df_cbm002_max_acad_plan, _tmp_stageB_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm002_max_acad_plan = read_table(_tmp_stageB_tbl).alias("CBM002_max_acad_plan")
log_msg(f"Checkpoint 2 materialized: {_tmp_stageB_tbl}")

# COMMAND ----------

# Step: AcadPlan_tbl
df_cbm002_acad_plan = df_cbm002_max_acad_plan.alias("CBM002_max_acad_plan")

df_cbm002_acad_plan = df_cbm002_acad_plan.join(
    ps_acad_plan_tbl,
    on=(
        (F.col("CBM002_max_acad_plan.ACAD_PLAN") == F.col("PS_ACAD_PLAN_TBL.ACAD_PLAN"))
        & (
            F.date_format(
                F.col("CBM002_max_acad_plan.Current_Term_End_date"),
                "yyyy-MM-dd HH:mm:ss",
            )
            >= F.date_format(F.col("PS_ACAD_PLAN_TBL.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        )
    ),
    how="inner",
)

df_cbm002_acad_plan = df_cbm002_acad_plan.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_ACAD_PLAN_TBL.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "CBM002_max_acad_plan.ACAD_PLAN", "CBM002_max_acad_plan.TERM_END_DT"
        )
    ),
)

df_cbm002_acad_plan = df_cbm002_acad_plan.filter(
    F.date_format(F.col("PS_ACAD_PLAN_TBL.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_acad_plan = df_cbm002_acad_plan.select(
    F.col("CBM002_max_acad_plan.ACAD_CAREER"),
    F.col("CBM002_max_acad_plan.ACAD_PROG"),
    F.col("CBM002_max_acad_plan.CRSE_CAREER"),
    F.col("CBM002_max_acad_plan.EMPLID"),
    F.col("CBM002_max_acad_plan.STRM"),
    F.col("CBM002_max_acad_plan.TERM_BEGIN_DT"),
    F.col("CBM002_max_acad_plan.TERM_END_DT"),
    F.col("CBM002_max_acad_plan.CENSUS_DT"),
    F.col("CBM002_max_acad_plan.Current_Term_End_date"),
    F.col("CBM002_max_acad_plan.STDNT_CAR_NBR"),
    F.col("CBM002_max_acad_plan.EFFDT"),
    F.col("CBM002_max_acad_plan.EFFSEQ"),
    F.col("CBM002_max_acad_plan.ACAD_PLAN"),
    F.col("CBM002_max_acad_plan.REQ_TERM"),
    F.col("PS_ACAD_PLAN_TBL.EFFDT").alias("PLAN_TBL_EFFDT"),
    F.col("PS_ACAD_PLAN_TBL.ACAD_PROG").alias("PLAN_TBL_ACAD_PROG"),
    F.col("PS_ACAD_PLAN_TBL.ACAD_PLAN_TYPE"),
    F.col("CBM002_max_acad_plan.Current_Term"),
    F.col("CBM002_max_acad_plan.MathCoreCourseEnrolled"),
    F.col("CBM002_max_acad_plan.ReadCoreCourseEnrolled"),
    F.col("CBM002_max_acad_plan.WriteCoreCourseEnrolled"),
    F.col("CBM002_max_acad_plan.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_max_acad_plan.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_max_acad_plan.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_max_acad_plan.PriorEnrolled"),
    F.col("CBM002_max_acad_plan.Flex"),
    F.col("CBM002_max_acad_plan.Year"),
)

# COMMAND ----------

# Step: Plan Owner, Carterm
df_cbm002_acad_plan_info = df_cbm002_acad_plan.alias("CBM002_acad_plan")

df_cbm002_acad_plan_info = (
    df_cbm002_acad_plan_info.join(
        ps_acad_plan_owner,
        on=(
            (
                F.col("CBM002_acad_plan.ACAD_PLAN")
                == F.col("PS_ACAD_PLAN_OWNER.ACAD_PLAN")
            )
            & (
                F.date_format(
                    F.col("CBM002_acad_plan.PLAN_TBL_EFFDT"), "yyyy-MM-dd HH:mm:ss"
                )
                == F.date_format(
                    F.col("PS_ACAD_PLAN_OWNER.EFFDT"), "yyyy-MM-dd HH:mm:ss"
                )
            )
        ),
        how="inner",
    )
    .join(
        ps_acad_prog,
        on=(
            (F.col("CBM002_acad_plan.EMPLID") == F.col("PS_ACAD_PROG.EMPLID"))
            & (
                F.col("CBM002_acad_plan.ACAD_CAREER")
                == F.col("PS_ACAD_PROG.ACAD_CAREER")
            )
            & (
                F.col("CBM002_acad_plan.STDNT_CAR_NBR")
                == F.col("PS_ACAD_PROG.STDNT_CAR_NBR")
            )
            & (
                F.date_format(F.col("CBM002_acad_plan.EFFDT"), "yyyy-MM-dd HH:mm:ss")
                == F.date_format(F.col("PS_ACAD_PROG.EFFDT"), "yyyy-MM-dd HH:mm:ss")
            )
            & (F.col("CBM002_acad_plan.EFFSEQ") == F.col("PS_ACAD_PROG.EFFSEQ"))
            & (
                F.col("PS_ACAD_PROG.INSTITUTION")
                == F.col("PS_ACAD_PLAN_OWNER.INSTITUTION")
            )
        ),
        how="inner",
    )
    .join(
        ps_stdnt_car_term,
        on=(
            (F.col("CBM002_acad_plan.EMPLID") == F.col("PS_STDNT_CAR_TERM.EMPLID"))
            & (F.col("CBM002_acad_plan.STRM") == F.col("PS_STDNT_CAR_TERM.STRM"))
            & (
                F.col("CBM002_acad_plan.ACAD_CAREER")
                == F.col("PS_STDNT_CAR_TERM.ACAD_CAREER")
            )
            & (
                F.col("CBM002_acad_plan.STDNT_CAR_NBR")
                == F.col("PS_STDNT_CAR_TERM.STDNT_CAR_NBR")
            )
        ),
        how="inner",
    )
)

df_cbm002_acad_plan_info = df_cbm002_acad_plan_info.select(
    F.col("CBM002_acad_plan.ACAD_CAREER"),
    F.col("CBM002_acad_plan.ACAD_PROG"),
    F.col("CBM002_acad_plan.CRSE_CAREER"),
    F.col("CBM002_acad_plan.EMPLID"),
    F.col("CBM002_acad_plan.STRM"),
    F.col("CBM002_acad_plan.TERM_BEGIN_DT"),
    F.col("CBM002_acad_plan.TERM_END_DT"),
    F.col("CBM002_acad_plan.CENSUS_DT"),
    F.col("PS_ACAD_PLAN_OWNER.INSTITUTION"),
    F.col("CBM002_acad_plan.Current_Term_End_date"),
    F.col("PS_ACAD_PLAN_OWNER.ACAD_ORG"),
    F.col("CBM002_acad_plan.STDNT_CAR_NBR"),
    F.col("CBM002_acad_plan.EFFDT"),
    F.col("CBM002_acad_plan.EFFSEQ"),
    F.col("CBM002_acad_plan.ACAD_PLAN"),
    F.col("CBM002_acad_plan.REQ_TERM"),
    F.col("CBM002_acad_plan.PLAN_TBL_EFFDT"),
    F.col("CBM002_acad_plan.PLAN_TBL_ACAD_PROG"),
    F.col("CBM002_acad_plan.ACAD_PLAN_TYPE"),
    F.col("PS_ACAD_PROG.ADMIT_TERM"),
    F.col("PS_ACAD_PROG.DEGR_CHKOUT_STAT"),
    F.col("PS_STDNT_CAR_TERM.ACAD_LEVEL_BOT"),
    F.col("PS_STDNT_CAR_TERM.ACAD_LEVEL_EOT"),
    F.col("PS_STDNT_CAR_TERM.ACAD_PROG_PRIMARY"),
    F.col("PS_STDNT_CAR_TERM.TOT_CUMULATIVE"),
    F.col("CBM002_acad_plan.Current_Term"),
    F.col("CBM002_acad_plan.MathCoreCourseEnrolled"),
    F.col("CBM002_acad_plan.ReadCoreCourseEnrolled"),
    F.col("CBM002_acad_plan.WriteCoreCourseEnrolled"),
    F.col("CBM002_acad_plan.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_acad_plan.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_acad_plan.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_acad_plan.PriorEnrolled"),
    F.col("CBM002_acad_plan.Flex"),
    F.col("CBM002_acad_plan.Year"),
)

# COMMAND ----------

# Step: SSN

# PS_EXTERNAL_SYSTEM
df_External_System = ps_external_system.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_EXTERNAL_SYSTEM.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "PS_EXTERNAL_SYSTEM.EMPLID", "PS_EXTERNAL_SYSTEM.EXTERNAL_SYSTEM"
        )
    ),
)

df_External_System = df_External_System.filter(
    F.date_format(F.col("PS_EXTERNAL_SYSTEM.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

# COMMAND ----------

# CBM002_SSN
cbm002_acad_plan_info = df_cbm002_acad_plan_info.alias("CBM002_ACAD_PLAN_INFO")
external_system = df_External_System.alias("External_System")

df_cbm002_ssn = cbm002_acad_plan_info.join(
    ps_pers_nid,
    on=(
        (F.col("CBM002_ACAD_PLAN_INFO.EMPLID") == F.col("PS_PERS_NID.EMPLID"))
        & (F.col("PS_PERS_NID.COUNTRY") == F.lit("USA"))
        & (F.col("PS_PERS_NID.NATIONAL_ID_TYPE") == F.lit("PR"))
    ),
    how="left",
).join(
    external_system,
    on=(
        (F.col("CBM002_ACAD_PLAN_INFO.EMPLID") == F.col("External_System.EMPLID"))
        & (F.col("External_System.EXTERNAL_SYSTEM") == F.lit("CB"))
    ),
    how="left",
)

df_cbm002_ssn = df_cbm002_ssn.withColumn(
    "National_Id_New",
    F.when(
        (
            ~F.substring(F.col("PS_PERS_NID.NATIONAL_ID"), 1, 2).isin(["XX", "99"])
            & (F.col("PS_PERS_NID.NATIONAL_ID") != F.lit(" "))
            & (
                (
                    F.col("PS_PERS_NID.NATIONAL_ID").isNotNull()
                    & (F.trim(F.col("PS_PERS_NID.NATIONAL_ID")) != F.lit(""))
                )
                | F.col("PS_PERS_NID.NATIONAL_ID").isNotNull()
            )
        ),
        F.col("PS_PERS_NID.NATIONAL_ID"),
    )
    .when(
        (
            ~F.substring(F.col("External_System.EXTERNAL_SYSTEM_ID"), 1, 2).isin(
                ["XX", "99"]
            )
            & (F.col("External_System.EXTERNAL_SYSTEM_ID") != F.lit(" "))
            & (
                (
                    F.col("External_System.EXTERNAL_SYSTEM_ID").isNotNull()
                    & (F.trim(F.col("External_System.EXTERNAL_SYSTEM_ID")) != F.lit(""))
                )
                | F.col("External_System.EXTERNAL_SYSTEM_ID").isNotNull()
            )
        ),
        F.col("External_System.EXTERNAL_SYSTEM_ID"),
    )
    .otherwise(
        F.concat(F.lit("9"), F.substring(F.col("CBM002_ACAD_PLAN_INFO.EMPLID"), 3, 8))
    ),
)

# COMMAND ----------

df_cbm002_ssn = df_cbm002_ssn.select(
    F.col("CBM002_ACAD_PLAN_INFO.ACAD_CAREER"),
    F.col("National_Id_New").alias("National_Id"),
    F.col("CBM002_ACAD_PLAN_INFO.ACAD_PROG"),
    F.col("CBM002_ACAD_PLAN_INFO.CRSE_CAREER"),
    F.col("CBM002_ACAD_PLAN_INFO.EMPLID"),
    F.col("CBM002_ACAD_PLAN_INFO.STRM"),
    F.col("CBM002_ACAD_PLAN_INFO.TERM_BEGIN_DT"),
    F.col("CBM002_ACAD_PLAN_INFO.TERM_END_DT"),
    F.col("CBM002_ACAD_PLAN_INFO.CENSUS_DT"),
    F.col("CBM002_ACAD_PLAN_INFO.Current_Term_End_date"),
    F.col("CBM002_ACAD_PLAN_INFO.ACAD_ORG"),
    F.col("CBM002_ACAD_PLAN_INFO.STDNT_CAR_NBR"),
    F.col("CBM002_ACAD_PLAN_INFO.EFFDT"),
    F.col("CBM002_ACAD_PLAN_INFO.EFFSEQ"),
    F.col("CBM002_ACAD_PLAN_INFO.ACAD_PLAN"),
    F.col("CBM002_ACAD_PLAN_INFO.REQ_TERM"),
    F.col("CBM002_ACAD_PLAN_INFO.PLAN_TBL_EFFDT"),
    F.col("CBM002_ACAD_PLAN_INFO.PLAN_TBL_ACAD_PROG"),
    F.col("CBM002_ACAD_PLAN_INFO.ADMIT_TERM"),
    F.col("CBM002_ACAD_PLAN_INFO.DEGR_CHKOUT_STAT"),
    F.col("CBM002_ACAD_PLAN_INFO.ACAD_LEVEL_BOT"),
    F.col("CBM002_ACAD_PLAN_INFO.ACAD_LEVEL_EOT"),
    F.col("CBM002_ACAD_PLAN_INFO.ACAD_PROG_PRIMARY"),
    F.col("CBM002_ACAD_PLAN_INFO.TOT_CUMULATIVE"),
    F.col("CBM002_ACAD_PLAN_INFO.Current_Term"),
    F.col("CBM002_ACAD_PLAN_INFO.MathCoreCourseEnrolled"),
    F.col("CBM002_ACAD_PLAN_INFO.ReadCoreCourseEnrolled"),
    F.col("CBM002_ACAD_PLAN_INFO.WriteCoreCourseEnrolled"),
    F.col("CBM002_ACAD_PLAN_INFO.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_ACAD_PLAN_INFO.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_ACAD_PLAN_INFO.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_ACAD_PLAN_INFO.PriorEnrolled"),
    F.col("CBM002_ACAD_PLAN_INFO.Flex"),
    F.col("CBM002_ACAD_PLAN_INFO.INSTITUTION"),
    F.col("CBM002_ACAD_PLAN_INFO.Year"),
).distinct()

# COMMAND ----------

# Step: Admission Data
# MAX_EFFSEQ

df_MAX_EFFSEQ = ps_adm_appl_prog.withColumn(
    "_agg_tmp_0",
    F.max(F.col("PS_ADM_APPL_PROG.EFFSEQ")).over(
        Window.partitionBy(
            "PS_ADM_APPL_PROG.EMPLID",
            "PS_ADM_APPL_PROG.ACAD_CAREER",
            "PS_ADM_APPL_PROG.ADMIT_TERM",
            "PS_ADM_APPL_PROG.EFFDT",
        )
    ),
)

df_MAX_EFFSEQ = df_MAX_EFFSEQ.filter(
    F.col("PS_ADM_APPL_PROG.EFFSEQ") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

# COMMAND ----------

# ACAD_PROG_EFFDT
max_effseq = df_MAX_EFFSEQ.alias("MAX_EFFSEQ")

df_ACAD_PROG_EFFDT = max_effseq.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("MAX_EFFSEQ.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "MAX_EFFSEQ.EMPLID", "MAX_EFFSEQ.ACAD_CAREER", "MAX_EFFSEQ.ADMIT_TERM"
        )
    ),
)

df_ACAD_PROG_EFFDT = df_ACAD_PROG_EFFDT.filter(
    F.date_format(F.col("MAX_EFFSEQ.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

# COMMAND ----------

# CBM002_ADMISSIONS
df_cbm002_admissions = df_cbm002_ssn.alias("CBM002_SSN")
acad_prog_effdt = df_ACAD_PROG_EFFDT.alias("ACAD_PROG_EFFDT")

df_cbm002_admissions = df_cbm002_admissions.join(
    acad_prog_effdt,
    on=(
        (F.col("CBM002_SSN.EMPLID") == F.col("ACAD_PROG_EFFDT.EMPLID"))
        & (F.col("CBM002_SSN.ACAD_CAREER") == F.col("ACAD_PROG_EFFDT.ACAD_CAREER"))
        & (
            F.col("CBM002_SSN.STRM").cast("BIGINT")
            >= F.col("ACAD_PROG_EFFDT.ADMIT_TERM").cast("BIGINT")
        )
    ),
    how="left",
)

df_cbm002_admissions = df_cbm002_admissions.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ACAD_PROG_EFFDT.ADMIT_TERM")).over(
        Window.partitionBy("CBM002_SSN.EMPLID", "CBM002_SSN.ACAD_CAREER")
    ),
)

df_cbm002_admissions = df_cbm002_admissions.withColumn(
    "ADM_APPL_NBR",
    F.max(F.col("ACAD_PROG_EFFDT.ADM_APPL_NBR")).over(
        Window.partitionBy(F.col("CBM002_SSN.EMPLID"), F.col("CBM002_SSN.ACAD_CAREER"))
    ),
)

df_cbm002_admissions = df_cbm002_admissions.filter(
    F.col("ACAD_PROG_EFFDT.ADMIT_TERM") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_admissions = df_cbm002_admissions.select(
    F.col("CBM002_SSN.ACAD_CAREER"),
    F.col("CBM002_SSN.National_Id"),
    F.col("CBM002_SSN.ACAD_PROG"),
    F.col("CBM002_SSN.CRSE_CAREER"),
    F.col("CBM002_SSN.EMPLID"),
    F.col("CBM002_SSN.STRM"),
    F.col("CBM002_SSN.TERM_BEGIN_DT"),
    F.col("CBM002_SSN.TERM_END_DT"),
    F.col("CBM002_SSN.CENSUS_DT"),
    F.col("CBM002_SSN.Current_Term_End_date"),
    F.col("CBM002_SSN.ACAD_ORG"),
    F.col("CBM002_SSN.STDNT_CAR_NBR"),
    F.col("CBM002_SSN.EFFDT"),
    F.col("CBM002_SSN.EFFSEQ"),
    F.col("CBM002_SSN.ACAD_PLAN"),
    F.col("CBM002_SSN.REQ_TERM"),
    F.col("CBM002_SSN.PLAN_TBL_EFFDT"),
    F.col("CBM002_SSN.PLAN_TBL_ACAD_PROG"),
    F.col("CBM002_SSN.ADMIT_TERM"),
    F.col("CBM002_SSN.DEGR_CHKOUT_STAT"),
    F.col("CBM002_SSN.ACAD_LEVEL_BOT"),
    F.col("CBM002_SSN.ACAD_LEVEL_EOT"),
    F.col("CBM002_SSN.ACAD_PROG_PRIMARY"),
    F.col("CBM002_SSN.TOT_CUMULATIVE"),
    F.col("ADM_APPL_NBR"),
    F.col("ACAD_PROG_EFFDT.APPL_PROG_NBR"),
    F.col("ACAD_PROG_EFFDT.STDNT_CAR_NBR").alias("ADM_STDNT_CAR_NBR"),
    F.col("ACAD_PROG_EFFDT.ADMIT_TERM").alias("ADM_ADMIT_TERM"),
    F.col("CBM002_SSN.Current_Term"),
    F.col("CBM002_SSN.MathCoreCourseEnrolled"),
    F.col("CBM002_SSN.ReadCoreCourseEnrolled"),
    F.col("CBM002_SSN.WriteCoreCourseEnrolled"),
    F.col("CBM002_SSN.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_SSN.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_SSN.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_SSN.PriorEnrolled"),
    F.col("CBM002_SSN.Flex"),
    F.col("CBM002_SSN.INSTITUTION"),
    F.col("CBM002_SSN.Year"),
).distinct()

# COMMAND ----------

# Step: EAP Flag
cbm002_admissions = df_cbm002_admissions.alias("CBM002_Admissions")
df_cbm002_eap = cbm002_admissions.join(
    ps_adm_appl_data,
    on=(
        (F.col("CBM002_Admissions.EMPLID") == F.col("PS_ADM_APPL_DATA.EMPLID"))
        & (
            F.col("CBM002_Admissions.ACAD_CAREER")
            == F.col("PS_ADM_APPL_DATA.ACAD_CAREER")
        )
        & (
            F.col("CBM002_Admissions.ADM_STDNT_CAR_NBR")
            == F.col("PS_ADM_APPL_DATA.STDNT_CAR_NBR")
        )
        & (
            F.col("CBM002_Admissions.ADM_APPL_NBR")
            == F.col("PS_ADM_APPL_DATA.ADM_APPL_NBR")
        )
    ),
    how="left",
).join(
    ps_adm_appl_rcr_ca,
    on=(
        (F.col("CBM002_Admissions.EMPLID") == F.col("PS_ADM_APPL_RCR_CA.EMPLID"))
        & (
            F.col("CBM002_Admissions.ACAD_CAREER")
            == F.col("PS_ADM_APPL_RCR_CA.ACAD_CAREER")
        )
        & (
            F.col("CBM002_Admissions.ADM_STDNT_CAR_NBR")
            == F.col("PS_ADM_APPL_RCR_CA.STDNT_CAR_NBR")
        )
        & (
            F.col("CBM002_Admissions.ADM_APPL_NBR")
            == F.col("PS_ADM_APPL_RCR_CA.ADM_APPL_NBR")
        )
        & (
            F.col("CBM002_Admissions.INSTITUTION")
            == F.col("PS_ADM_APPL_RCR_CA.INSTITUTION")
        )
        & (F.col("PS_ADM_APPL_RCR_CA.RECRUITMENT_CAT") == F.lit("AUEA"))
    ),
    how="left",
)

df_cbm002_eap = df_cbm002_eap.withColumn(
    "EAPStudent_New",
    F.when(
        (
            (F.col("CBM002_Admissions.ACAD_CAREER") == F.lit("UGRD"))
            & F.col("PS_ADM_APPL_DATA.ADMIT_TYPE").isin(["1", "5"])
            & (F.col("CBM002_Admissions.ACAD_PROG") == F.lit("UGNDS"))
            & (F.col("PS_ADM_APPL_RCR_CA.RECRUITMENT_CAT") == F.lit("AUEA"))
        ),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm002_eap = df_cbm002_eap.select(
    F.col("CBM002_Admissions.ACAD_CAREER"),
    F.col("CBM002_Admissions.National_Id"),
    F.col("CBM002_Admissions.ACAD_PROG"),
    F.col("CBM002_Admissions.CRSE_CAREER"),
    F.col("CBM002_Admissions.EMPLID"),
    F.col("CBM002_Admissions.STRM"),
    F.col("CBM002_Admissions.TERM_BEGIN_DT"),
    F.col("CBM002_Admissions.TERM_END_DT"),
    F.col("CBM002_Admissions.CENSUS_DT"),
    F.col("CBM002_Admissions.Current_Term_End_date"),
    F.col("CBM002_Admissions.ACAD_ORG"),
    F.col("CBM002_Admissions.STDNT_CAR_NBR"),
    F.col("CBM002_Admissions.EFFDT"),
    F.col("CBM002_Admissions.EFFSEQ"),
    F.col("CBM002_Admissions.ACAD_PLAN"),
    F.col("CBM002_Admissions.REQ_TERM"),
    F.col("CBM002_Admissions.PLAN_TBL_EFFDT"),
    F.col("CBM002_Admissions.PLAN_TBL_ACAD_PROG"),
    F.col("CBM002_Admissions.ADMIT_TERM"),
    F.col("CBM002_Admissions.DEGR_CHKOUT_STAT"),
    F.col("CBM002_Admissions.ACAD_LEVEL_BOT"),
    F.col("CBM002_Admissions.ACAD_LEVEL_EOT"),
    F.col("CBM002_Admissions.ACAD_PROG_PRIMARY"),
    F.col("CBM002_Admissions.TOT_CUMULATIVE"),
    F.col("CBM002_Admissions.ADM_APPL_NBR"),
    F.col("CBM002_Admissions.ADM_ADMIT_TERM"),
    F.col("PS_ADM_APPL_DATA.ADMIT_TYPE"),
    F.col("PS_ADM_APPL_RCR_CA.RECRUITMENT_CAT"),
    F.col("CBM002_Admissions.Current_Term"),
    F.col("CBM002_Admissions.MathCoreCourseEnrolled"),
    F.col("CBM002_Admissions.ReadCoreCourseEnrolled"),
    F.col("CBM002_Admissions.WriteCoreCourseEnrolled"),
    F.col("CBM002_Admissions.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_Admissions.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_Admissions.WriteCoreCoursePriorEnrolled"),
    F.col("EAPStudent_New").alias("EAPStudent"),
    F.col("CBM002_Admissions.PriorEnrolled"),
    F.col("CBM002_Admissions.Flex"),
    F.col("CBM002_Admissions.INSTITUTION"),
    F.col("CBM002_Admissions.Year"),
).distinct()

# COMMAND ----------

# Step: ETHNIC_INFO
# ETHN_GRP_MAX_EFFDT

df_ETHN_GRP_MAX_EFFDT = ps_hcr_ethnic_grp_i.filter(
    (F.col("PS_HCR_ETHNIC_GRP_I.EFF_STATUS") == F.lit("A"))
    & (
        F.date_format(F.col("PS_HCR_ETHNIC_GRP_I.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.current_timestamp(), "yyyy-MM-dd HH:mm:ss")
    )
    & (F.col("PS_HCR_ETHNIC_GRP_I.SETID") == F.lit("USA"))
)

df_ETHN_GRP_MAX_EFFDT = df_ETHN_GRP_MAX_EFFDT.withColumn(
    "_agg_tmp_0",
    F.max(
        F.date_format(F.col("PS_HCR_ETHNIC_GRP_I.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    ).over(Window.partitionBy("PS_HCR_ETHNIC_GRP_I.ETHNIC_GRP_CD")),
)

df_ETHN_GRP_MAX_EFFDT = df_ETHN_GRP_MAX_EFFDT.filter(
    F.date_format(F.col("PS_HCR_ETHNIC_GRP_I.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_ETHN_GRP_MAX_EFFDT = df_ETHN_GRP_MAX_EFFDT.select(
    F.col("PS_HCR_ETHNIC_GRP_I.DESCR50"),
    F.col("PS_HCR_ETHNIC_GRP_I.DESCRSHORT"),
    F.col("PS_HCR_ETHNIC_GRP_I.EFF_STATUS"),
    F.col("PS_HCR_ETHNIC_GRP_I.EFFDT"),
    F.col("PS_HCR_ETHNIC_GRP_I.ETHNIC_CATEGORY"),
    F.col("PS_HCR_ETHNIC_GRP_I.ETHNIC_GROUP"),
    F.col("PS_HCR_ETHNIC_GRP_I.ETHNIC_GRP_CD"),
    F.col("PS_HCR_ETHNIC_GRP_I.SETID"),
).distinct()

# COMMAND ----------

# ETHENIC_INFO
ethn_grp_max_effdt = df_ETHN_GRP_MAX_EFFDT.alias("ETHN_GRP_MAX_EFFDT")

df_ethnic_info = ps_hcr_div_ethnic_i.join(
    ethn_grp_max_effdt,
    on=(
        F.col("PS_HCR_DIV_ETHNIC_I.ETHNIC_GRP_CD")
        == F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GRP_CD")
    ),
    how="inner",
)

df_ethnic_info = df_ethnic_info.groupBy("PS_HCR_DIV_ETHNIC_I.EMPLID").agg(
    F.max(
        F.when(
            (F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP") == F.lit("1")), F.lit("1")
        ).otherwise(F.lit(None))
    ).alias("Race_White"),
    F.max(
        F.when(
            (F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP") == F.lit("2")), F.lit("2")
        ).otherwise(F.lit(None))
    ).alias("Race_Black"),
    F.max(
        F.when(
            (F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP") == F.lit("4")), F.lit("4")
        ).otherwise(F.lit(None))
    ).alias("Race_Asian"),
    F.max(
        F.when(
            (F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP") == F.lit("5")), F.lit("5")
        ).otherwise(F.lit(None))
    ).alias("Race_AmIndAlsknNatv"),
    F.max(
        F.when(
            (
                (F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP") == F.lit("7"))
                | F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP").isNull()
                | (F.trim(F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP")) == F.lit(""))
            ),
            F.lit("7"),
        ).otherwise(F.lit(None))
    ).alias("Race_UnknwnNotRptd"),
    F.max(
        F.when(
            (F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP") == F.lit("8")), F.lit("8")
        ).otherwise(F.lit(None))
    ).alias("Race_NatHawnOPI"),
    F.min(
        F.when(
            (F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP") == F.lit("3")), F.lit("1")
        ).otherwise(F.lit("3"))
    ).alias("ETHNIC_ORIGIN"),
    F.countDistinct(F.col("ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP"))
    .cast("STRING")
    .alias("ETHNIC_COUNT"),
)

df_ethnic_info = df_ethnic_info.distinct()

# COMMAND ----------

# Step: EMPLID_DATA
# EMPLID_GENDER_MAX_EFFDT
df_EMPLID_GENDER_MAX_EFFDT = ps_pers_data_effdt.filter(
    (F.col("PS_PERS_DATA_EFFDT.EFFDT") <= F.current_timestamp())
)
df_EMPLID_GENDER_MAX_EFFDT = df_EMPLID_GENDER_MAX_EFFDT.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_PERS_DATA_EFFDT.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("PS_PERS_DATA_EFFDT.EMPLID")
    ),
)

df_EMPLID_GENDER_MAX_EFFDT = df_EMPLID_GENDER_MAX_EFFDT.filter(
    F.date_format(F.col("PS_PERS_DATA_EFFDT.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_EMPLID_GENDER_MAX_EFFDT = df_EMPLID_GENDER_MAX_EFFDT.select(
    F.col("PS_PERS_DATA_EFFDT.EMPLID"),
    F.when(~F.col("PS_PERS_DATA_EFFDT.SEX").isin(["M", "F"]), F.lit("U"))
    .otherwise(F.col("PS_PERS_DATA_EFFDT.SEX"))
    .alias("GENDER"),
).distinct()

# COMMAND ----------

# EMPLID_DATA
emplid_gender_max_effdt = df_EMPLID_GENDER_MAX_EFFDT.alias("EMPLID_GENDER_MAX_EFFDT")

df_emplid_data = ps_person_sa.join(
    emplid_gender_max_effdt,
    on=(F.col("PS_PERSON_SA.EMPLID") == F.col("EMPLID_GENDER_MAX_EFFDT.EMPLID")),
    how="outer",
).join(
    ps_person,
    on=(F.col("PS_PERSON_SA.EMPLID") == F.col("PS_PERSON.EMPLID")),
    how="outer",
)

df_emplid_data = df_emplid_data.select(
    F.coalesce(
        F.col("PS_PERSON_SA.EMPLID"),
        F.col("EMPLID_GENDER_MAX_EFFDT.EMPLID"),
        F.col("PS_PERSON.EMPLID"),
    ).alias("EMPLID"),
    F.when((F.col("PS_PERSON_SA.FERPA") == F.lit("Y")), F.lit("2"))
    .otherwise(F.lit("0"))
    .alias("FERPA_FLAG"),
    F.col("EMPLID_GENDER_MAX_EFFDT.GENDER"),
    F.when(
        F.col("PS_PERSON.BIRTHDATE").isNotNull(),
        F.date_format(F.col("PS_PERSON.BIRTHDATE").cast("date"), F.lit("yyyyMMdd")),
    )
    .otherwise(F.lit(""))
    .alias("BIRTHDATE"),
)

# COMMAND ----------

# Step: Student Info
cbm002_eap = df_cbm002_eap.alias("CBM002_EAP")
ethnic_info = df_ethnic_info.alias("ETHNIC_INFO")
emplid_data = df_emplid_data.alias("EMPLID_DATA")

df_cbm002_studentinfo = cbm002_eap.join(
    ethnic_info,
    on=(F.col("CBM002_EAP.EMPLID") == F.col("ETHNIC_INFO.EMPLID")),
    how="left",
).join(
    emplid_data,
    on=(F.col("CBM002_EAP.EMPLID") == F.col("EMPLID_DATA.EMPLID")),
    how="left",
)

df_cbm002_studentinfo = df_cbm002_studentinfo.withColumn(
    "_agg_tmp_0",
    F.max(F.col("CBM002_EAP.STRM")).over(Window.partitionBy("CBM002_EAP.EMPLID")),
)

df_cbm002_studentinfo = df_cbm002_studentinfo.filter(
    F.col("CBM002_EAP.STRM") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_studentinfo = df_cbm002_studentinfo.withColumn(
    "ETHNIC_ORIGIN_NEW",
    F.when(
        (
            F.col("ETHNIC_INFO.EMPLID").isNull()
            | (F.trim(F.col("ETHNIC_INFO.EMPLID")) == F.lit(""))
        ),
        F.lit("3"),
    ).otherwise(F.col("ETHNIC_INFO.ETHNIC_ORIGIN")),
)

df_cbm002_studentinfo = df_cbm002_studentinfo.select(
    F.col("CBM002_EAP.ACAD_CAREER"),
    F.col("CBM002_EAP.National_Id"),
    F.col("CBM002_EAP.ACAD_PROG"),
    F.col("CBM002_EAP.CRSE_CAREER"),
    F.col("CBM002_EAP.EMPLID"),
    F.col("CBM002_EAP.STRM"),
    F.col("CBM002_EAP.TERM_BEGIN_DT"),
    F.col("CBM002_EAP.TERM_END_DT"),
    F.col("CBM002_EAP.CENSUS_DT"),
    F.col("CBM002_EAP.Current_Term_End_date"),
    F.col("CBM002_EAP.ACAD_ORG"),
    F.col("CBM002_EAP.STDNT_CAR_NBR"),
    F.col("CBM002_EAP.EFFDT"),
    F.col("CBM002_EAP.EFFSEQ"),
    F.col("CBM002_EAP.ACAD_PLAN"),
    F.col("CBM002_EAP.REQ_TERM"),
    F.col("CBM002_EAP.PLAN_TBL_EFFDT"),
    F.col("CBM002_EAP.PLAN_TBL_ACAD_PROG"),
    F.col("CBM002_EAP.ADMIT_TERM"),
    F.col("CBM002_EAP.DEGR_CHKOUT_STAT"),
    F.col("CBM002_EAP.ACAD_LEVEL_BOT"),
    F.col("CBM002_EAP.ACAD_LEVEL_EOT"),
    F.col("CBM002_EAP.ACAD_PROG_PRIMARY"),
    F.col("CBM002_EAP.TOT_CUMULATIVE"),
    F.col("CBM002_EAP.ADM_APPL_NBR"),
    F.col("CBM002_EAP.ADM_ADMIT_TERM"),
    F.col("CBM002_EAP.ADMIT_TYPE"),
    F.col("CBM002_EAP.RECRUITMENT_CAT"),
    F.col("CBM002_EAP.Current_Term"),
    F.col("ETHNIC_INFO.Race_White"),
    F.col("ETHNIC_INFO.Race_Black"),
    F.col("ETHNIC_INFO.Race_Asian"),
    F.col("ETHNIC_INFO.Race_AmIndAlsknNatv"),
    F.col("ETHNIC_INFO.Race_UnknwnNotRptd"),
    F.col("ETHNIC_INFO.Race_NatHawnOPI"),
    F.col("ETHNIC_ORIGIN_NEW").alias("ETHNIC_ORIGIN"),
    F.col("ETHNIC_INFO.ETHNIC_COUNT"),
    F.col("EMPLID_DATA.FERPA_FLAG"),
    F.col("EMPLID_DATA.GENDER"),
    F.col("EMPLID_DATA.BIRTHDATE"),
    F.col("CBM002_EAP.MathCoreCourseEnrolled"),
    F.col("CBM002_EAP.ReadCoreCourseEnrolled"),
    F.col("CBM002_EAP.WriteCoreCourseEnrolled"),
    F.col("CBM002_EAP.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_EAP.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_EAP.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_EAP.EAPStudent"),
    F.col("CBM002_EAP.PriorEnrolled"),
    F.col("CBM002_EAP.Flex"),
    F.col("CBM002_EAP.INSTITUTION"),
    F.col("CBM002_EAP.Year"),
).distinct()

# COMMAND ----------

# Step: International Students
df_cbm002_international = df_cbm002_studentinfo.alias("CBM002_StudentInfo")
df_cbm002_international = df_cbm002_international.join(
    ps_residency_off,
    on=(
        (F.col("CBM002_StudentInfo.EMPLID") == F.col("PS_RESIDENCY_OFF.EMPLID"))
        & (
            F.col("CBM002_StudentInfo.ACAD_CAREER")
            == F.col("PS_RESIDENCY_OFF.ACAD_CAREER")
        )
        & (F.col("CBM002_StudentInfo.STRM") >= F.col("PS_RESIDENCY_OFF.EFFECTIVE_TERM"))
    ),
    how="left",
)

df_cbm002_international = df_cbm002_international.withColumn(
    "_agg_tmp_0",
    F.max(F.col("PS_RESIDENCY_OFF.EFFECTIVE_TERM")).over(
        Window.partitionBy(
            "CBM002_StudentInfo.EMPLID",
            "CBM002_StudentInfo.ACAD_CAREER",
            "CBM002_StudentInfo.STRM",
        )
    ),
)

df_cbm002_international = df_cbm002_international.filter(
    F.col("PS_RESIDENCY_OFF.EFFECTIVE_TERM") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_international = df_cbm002_international.withColumn(
    "International_New",
    F.when(
        (
            (F.col("PS_RESIDENCY_OFF.TUITION_RES") == F.lit("1"))
            & F.col("PS_RESIDENCY_OFF.TUITION_EXCPT").isin(["1403A", "1528A"])
            & (F.col("PS_RESIDENCY_OFF.RESIDENCY") == F.lit("4"))
        ),
        F.lit(None),
    )
    .when((F.col("PS_RESIDENCY_OFF.RESIDENCY") == F.lit("4")), F.lit("6"))
    .otherwise(F.lit(None)),
)

df_cbm002_international = df_cbm002_international.select(
    F.col("CBM002_StudentInfo.ACAD_CAREER"),
    F.col("CBM002_StudentInfo.National_Id"),
    F.col("CBM002_StudentInfo.ACAD_PROG"),
    F.col("CBM002_StudentInfo.CRSE_CAREER"),
    F.col("CBM002_StudentInfo.EMPLID"),
    F.col("CBM002_StudentInfo.STRM"),
    F.col("CBM002_StudentInfo.TERM_BEGIN_DT"),
    F.col("CBM002_StudentInfo.TERM_END_DT"),
    F.col("CBM002_StudentInfo.CENSUS_DT"),
    F.col("CBM002_StudentInfo.Current_Term_End_date"),
    F.col("CBM002_StudentInfo.ACAD_ORG"),
    F.col("CBM002_StudentInfo.STDNT_CAR_NBR"),
    F.col("CBM002_StudentInfo.EFFDT"),
    F.col("CBM002_StudentInfo.EFFSEQ"),
    F.col("CBM002_StudentInfo.ACAD_PLAN"),
    F.col("CBM002_StudentInfo.REQ_TERM"),
    F.col("CBM002_StudentInfo.PLAN_TBL_EFFDT"),
    F.col("CBM002_StudentInfo.PLAN_TBL_ACAD_PROG"),
    F.col("CBM002_StudentInfo.ADMIT_TERM"),
    F.col("CBM002_StudentInfo.DEGR_CHKOUT_STAT"),
    F.col("CBM002_StudentInfo.ACAD_LEVEL_BOT"),
    F.col("CBM002_StudentInfo.ACAD_LEVEL_EOT"),
    F.col("CBM002_StudentInfo.ACAD_PROG_PRIMARY"),
    F.col("CBM002_StudentInfo.TOT_CUMULATIVE"),
    F.col("CBM002_StudentInfo.ADM_APPL_NBR"),
    F.col("CBM002_StudentInfo.ADM_ADMIT_TERM"),
    F.col("CBM002_StudentInfo.ADMIT_TYPE"),
    F.col("CBM002_StudentInfo.RECRUITMENT_CAT"),
    F.col("CBM002_StudentInfo.Current_Term"),
    F.col("CBM002_StudentInfo.Race_White"),
    F.col("CBM002_StudentInfo.Race_Black"),
    F.col("CBM002_StudentInfo.Race_Asian"),
    F.col("CBM002_StudentInfo.Race_AmIndAlsknNatv"),
    F.col("CBM002_StudentInfo.Race_UnknwnNotRptd"),
    F.col("CBM002_StudentInfo.Race_NatHawnOPI"),
    F.col("CBM002_StudentInfo.ETHNIC_ORIGIN"),
    F.col("CBM002_StudentInfo.ETHNIC_COUNT"),
    F.col("CBM002_StudentInfo.FERPA_FLAG"),
    F.col("CBM002_StudentInfo.GENDER"),
    F.col("CBM002_StudentInfo.BIRTHDATE"),
    F.col("PS_RESIDENCY_OFF.TUITION_EXCPT"),
    F.col("PS_RESIDENCY_OFF.TUITION_RES"),
    F.col("International_New").alias("International"),
    F.col("CBM002_StudentInfo.MathCoreCourseEnrolled"),
    F.col("CBM002_StudentInfo.ReadCoreCourseEnrolled"),
    F.col("CBM002_StudentInfo.WriteCoreCourseEnrolled"),
    F.col("CBM002_StudentInfo.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_StudentInfo.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_StudentInfo.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_StudentInfo.EAPStudent"),
    F.col("CBM002_StudentInfo.PriorEnrolled"),
    F.col("CBM002_StudentInfo.Flex"),
    F.col("CBM002_StudentInfo.INSTITUTION"),
    F.col("CBM002_StudentInfo.Year"),
).distinct()

# COMMAND ----------

# Checkpoint 3: materialize df_cbm002_international to break the upstream DAG
_tmp_stageC_tbl = f"{analytics}.{staging}._tmp_cbm002_international"
write_df_to_table(
    df_cbm002_international, _tmp_stageC_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm002_international = read_table(_tmp_stageC_tbl).alias("CBM002_International")
log_msg(f"Checkpoint 3 materialized: {_tmp_stageC_tbl}")

# COMMAND ----------

# Step: Distinct Students
cbm002_international = df_cbm002_international.alias("CBM002_International")

df_distinctstudents = cbm002_international.select(
    F.col("CBM002_International.EMPLID"),
    F.col("CBM002_International.STRM"),
    F.col("CBM002_International.CENSUS_DT"),
).distinct()

# COMMAND ----------

# Step: Test Scores
distinctstudents = df_distinctstudents.alias("DistinctStudents")

df_cbm002_test_scores = distinctstudents.join(
    ps_stdnt_test_comp,
    on=(
        (F.col("DistinctStudents.EMPLID") == F.col("PS_STDNT_TEST_COMP.EMPLID"))
        & F.col("PS_STDNT_TEST_COMP.TEST_ID").isin(
            [
                "ACT",
                "SAT I",
                "TAKS",
                "THEA",
                "COMPASS",
                "ASSET",
                "ACCUPLACER",
                "STANFORD",
                "MAPS",
                "TSIA",
                "TSIA2",
            ]
        )
    ),
    how="left",
)

df_cbm002_test_scores = df_cbm002_test_scores.filter(
    F.col("PS_STDNT_TEST_COMP.TEST_COMPONENT").isNotNull()
)

_winSpec_4 = Window.partitionBy(
    F.col("DistinctStudents.STRM"),
    F.col("DistinctStudents.EMPLID"),
    F.col("PS_STDNT_TEST_COMP.TEST_ID"),
    F.col("PS_STDNT_TEST_COMP.TEST_COMPONENT"),
)

df_cbm002_test_scores = df_cbm002_test_scores.withColumn(
    "_agg_tmp_0",
    F.max(F.col("PS_STDNT_TEST_COMP.SCORE")).over(_winSpec_4),
)

df_cbm002_test_scores = df_cbm002_test_scores.filter(
    F.col("PS_STDNT_TEST_COMP.SCORE") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm002_test_scores = df_cbm002_test_scores.withColumn(
    "_sel_tmp_0_0",
    F.max(
        F.date_format(F.col("PS_STDNT_TEST_COMP.TEST_DT"), "yyyy-MM-dd HH:mm:ss")
    ).over(_winSpec_4),
)

df_cbm002_test_scores = df_cbm002_test_scores.withColumn(
    "TestBeforeCensus",
    F.when(
        (
            F.date_format(F.col("DistinctStudents.CENSUS_DT"), "yyyy-MM-dd HH:mm:ss")
            >= F.date_format(F.col("_sel_tmp_0_0"), "yyyy-MM-dd HH:mm:ss")
        ),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
).drop("_sel_tmp_0_0")

df_cbm002_test_scores = df_cbm002_test_scores.withColumn(
    "TEST_DT", F.max(F.col("PS_STDNT_TEST_COMP.TEST_DT")).over(_winSpec_4)
)

df_cbm002_test_scores = (
    df_cbm002_test_scores.select(
        F.col("DistinctStudents.EMPLID"),
        F.col("DistinctStudents.STRM"),
        F.col("TestBeforeCensus"),
        F.col("PS_STDNT_TEST_COMP.SCORE"),
        F.col("PS_STDNT_TEST_COMP.TEST_ID"),
        F.col("PS_STDNT_TEST_COMP.TEST_COMPONENT"),
        F.col("TEST_DT"),
    )
    .distinct()
    .orderBy(
        F.col("STRM").asc(),
        F.col("EMPLID").asc(),
        F.col("TEST_ID").asc(),
        F.col("TestBeforeCensus").asc(),
        F.col("TEST_COMPONENT").asc(),
        F.col("SCORE").asc(),
    )
)

# COMMAND ----------

# Step: Max Test Scores
df_max_test_scores = df_cbm002_test_scores.alias("CBM002_Test_Scores")

_win_spec = Window.partitionBy(
    F.col("CBM002_Test_Scores.STRM"), F.col("CBM002_Test_Scores.EMPLID")
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Math_ACT",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACT"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
                & (
                    F.date_format(
                        F.col("CBM002_Test_Scores.TEST_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    >= F.lit("2023-02-01 00:00:00").cast("TIMESTAMP")
                )
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Read_ACT",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACT"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("READ"))
                & (
                    F.date_format(
                        F.col("CBM002_Test_Scores.TEST_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    >= F.lit("2023-02-01 00:00:00").cast("TIMESTAMP")
                )
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Write_ACT",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACT"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("ENGL"))
                & (
                    F.date_format(
                        F.col("CBM002_Test_Scores.TEST_DT"), "yyyy-MM-dd HH:mm:ss"
                    )
                    >= F.lit("2023-02-01 00:00:00").cast("TIMESTAMP")
                )
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Math_Taks",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TAKS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Read_Taks",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TAKS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("EGLA"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

# COMMAND ----------

df_max_test_scores = df_max_test_scores.withColumn(
    "Write_Taks",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TAKS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("EGLA"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_SAT",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("SAT I"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATHS"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "VERBAL_SAT",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("SAT I"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("EBRWS"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Total_SAT",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("SAT I"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("TOT02"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_SAT_Old",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("SAT I"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "VERBAL_SAT_Old",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("SAT I"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("VERB"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Total_SAT_Old",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("SAT I"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("SATT2"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

# COMMAND ----------

df_max_test_scores = df_max_test_scores.withColumn(
    "English_Composite_ACT",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACT"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("TSIC"))
                & (
                    F.col("CBM002_Test_Scores.TEST_DT")
                    >= F.lit("2023-02-01 00:00:00").cast("TIMESTAMP")
                )
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_THEA",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("THEA"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_THEA",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("THEA"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("READ"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_THEA",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("THEA"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WR"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_COMPASS",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("COMPASS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_COMPASS",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("COMPASS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("READ"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_COMPASS",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("COMPASS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRS"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

# COMMAND ----------

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_ASSET",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ASSET"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_ASSET",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ASSET"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("READ"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_ASSET",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ASSET"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRS"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_ACCUPLACER",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACCUPLACER"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_ACCUPLACER",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACCUPLACER"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("READ"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_ACCUPLACER",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACCUPLACER"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("SS"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_STANFORD",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("STANFORD"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

# COMMAND ----------

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_STANFORD",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("STANFORD"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("READ"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_STANFORD",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("STANFORD"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("STUD"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_MAPS",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("MAPS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_MAPS",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("MAPS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("READ"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_MAPS",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("MAPS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRO"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITEESSAY_COMPASS",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("COMPASS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRE"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITEESSAY_ASSET",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ASSET"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRE"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

# COMMAND ----------

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITEESSAY_ACCUPLACER",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACCUPLACER"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRE"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITEESSAY_STANFORD",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("STANFORD"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("EGLA"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITEESSAY_MAPS",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("MAPS"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRE"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_TSIA",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_TSIA",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("READ"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_TSIA",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRMC"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_TSIA2",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA2"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

# COMMAND ----------

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_TSIA2",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA2"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("ELAR"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_TSIA2",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA2"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("ELAR"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITEESSAY_TSIA",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("WRE"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITEESSAY_TSIA2",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA2"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("ELARE"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "MATH_TSIA2_Diagnostic",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA2"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATHD"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "READ_TSIA2_Diagnostic",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA2"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("ELARD"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "WRITE_TSIA2_Diagnostic",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("TSIA2"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("ELARD"))
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

# COMMAND ----------

df_max_test_scores = df_max_test_scores.withColumn(
    "Math_ACT_Old",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACT"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("MATH"))
                & (
                    F.col("CBM002_Test_Scores.TEST_DT")
                    < F.lit("2023-02-01 00:00:00").cast("TIMESTAMP")
                )
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Verbal_ACT_Old",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACT"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("ENGL"))
                & (
                    F.col("CBM002_Test_Scores.TEST_DT")
                    < F.lit("2023-02-01 00:00:00").cast("TIMESTAMP")
                )
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

df_max_test_scores = df_max_test_scores.withColumn(
    "Total_ACT_Old",
    F.max(
        F.when(
            (
                (F.col("CBM002_Test_Scores.TEST_ID") == F.lit("ACT"))
                & (F.col("CBM002_Test_Scores.TEST_COMPONENT") == F.lit("COMP"))
                & (
                    F.col("CBM002_Test_Scores.TEST_DT")
                    < F.lit("2023-02-01 00:00:00").cast("TIMESTAMP")
                )
            ),
            F.col("CBM002_Test_Scores.SCORE"),
        ).otherwise(F.lit(0))
    ).over(_win_spec),
)

# COMMAND ----------

df_max_test_scores = df_max_test_scores.select(
    F.col("CBM002_Test_Scores.STRM"),
    F.col("CBM002_Test_Scores.EMPLID"),
    F.col("Math_ACT"),
    F.col("Read_ACT"),
    F.col("Write_ACT"),
    F.col("Math_Taks"),
    F.col("Read_Taks"),
    F.col("Write_Taks"),
    F.col("MATH_SAT"),
    F.col("VERBAL_SAT"),
    F.col("Total_SAT"),
    F.col("MATH_SAT_Old"),
    F.col("VERBAL_SAT_Old"),
    F.col("Total_SAT_Old"),
    F.col("English_Composite_ACT"),
    F.col("MATH_THEA"),
    F.col("READ_THEA"),
    F.col("WRITE_THEA"),
    F.col("MATH_COMPASS"),
    F.col("READ_COMPASS"),
    F.col("WRITE_COMPASS"),
    F.col("MATH_ASSET"),
    F.col("READ_ASSET"),
    F.col("WRITE_ASSET"),
    F.col("MATH_ACCUPLACER"),
    F.col("READ_ACCUPLACER"),
    F.col("WRITE_ACCUPLACER"),
    F.col("MATH_STANFORD"),
    F.col("READ_STANFORD"),
    F.col("WRITE_STANFORD"),
    F.col("MATH_MAPS"),
    F.col("READ_MAPS"),
    F.col("WRITE_MAPS"),
    F.col("WRITEESSAY_COMPASS"),
    F.col("WRITEESSAY_ASSET"),
    F.col("WRITEESSAY_ACCUPLACER"),
    F.col("WRITEESSAY_STANFORD"),
    F.col("WRITEESSAY_MAPS"),
    F.col("MATH_TSIA"),
    F.col("READ_TSIA"),
    F.col("WRITE_TSIA"),
    F.col("MATH_TSIA2"),
    F.col("READ_TSIA2"),
    F.col("WRITE_TSIA2"),
    F.col("WRITEESSAY_TSIA"),
    F.col("WRITEESSAY_TSIA2"),
    F.col("MATH_TSIA2_Diagnostic"),
    F.col("READ_TSIA2_Diagnostic"),
    F.col("WRITE_TSIA2_Diagnostic"),
    F.col("Math_ACT_Old"),
    F.col("Verbal_ACT_Old"),
    F.col("Total_ACT_Old"),
).distinct()

# COMMAND ----------

# CBM002_CalculatedScores
df_cbm002_calculatedscores = df_max_test_scores.alias("MAX_TEST_SCORES")

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "Math_ACT_New",
    F.when(
        (F.col("MAX_TEST_SCORES.Math_ACT") >= F.lit(22)),
        F.col("MAX_TEST_SCORES.Math_ACT"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "Read_ACT_New",
    F.when(
        (
            (F.col("MAX_TEST_SCORES.English_Composite_ACT") >= F.lit(40))
            & (F.col("MAX_TEST_SCORES.Read_ACT") > F.lit(0))
        ),
        F.col("MAX_TEST_SCORES.Read_ACT"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "Write_ACT_New",
    F.when(
        (
            (F.col("MAX_TEST_SCORES.English_Composite_ACT") >= F.lit(40))
            & (F.col("MAX_TEST_SCORES.Write_ACT") > F.lit(0))
        ),
        F.col("MAX_TEST_SCORES.Write_ACT"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "MATH_SAT_New",
    F.when(
        (
            (
                (F.col("MAX_TEST_SCORES.MATH_SAT") >= F.lit(530))
                | (F.col("MAX_TEST_SCORES.VERBAL_SAT") >= F.lit(480))
            )
            & (F.col("MAX_TEST_SCORES.MATH_SAT") >= F.lit(0))
        ),
        F.col("MAX_TEST_SCORES.MATH_SAT"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "VERBAL_SAT_New",
    F.when(
        (
            (
                (F.col("MAX_TEST_SCORES.MATH_SAT") >= F.lit(530))
                | (F.col("MAX_TEST_SCORES.VERBAL_SAT") >= F.lit(480))
            )
            & (F.col("MAX_TEST_SCORES.VERBAL_SAT") >= F.lit(0))
        ),
        F.col("MAX_TEST_SCORES.VERBAL_SAT"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "Total_SAT_New",
    F.when(
        (F.col("MAX_TEST_SCORES.Total_SAT") > F.lit(0)),
        F.col("MAX_TEST_SCORES.Total_SAT"),
    ).otherwise(
        (
            F.coalesce(F.col("MAX_TEST_SCORES.MATH_SAT"), F.lit(0))
            + F.coalesce(F.col("MAX_TEST_SCORES.VERBAL_SAT"), F.lit(0))
        )
    ),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "English_Composite_ACT_New",
    F.when(
        (F.col("MAX_TEST_SCORES.English_Composite_ACT") >= F.lit(40)),
        F.col("MAX_TEST_SCORES.English_Composite_ACT"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "MATH_SAT_Old_New",
    F.when(
        (
            (
                F.coalesce(F.col("MAX_TEST_SCORES.MATH_SAT_Old"), F.lit(0))
                + F.coalesce(F.col("MAX_TEST_SCORES.VERBAL_SAT_Old"), F.lit(0))
            )
            >= F.lit(1070)
        ),
        F.col("MAX_TEST_SCORES.MATH_SAT_Old"),
    ).otherwise(F.lit(0)),
)

# COMMAND ----------

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "VERBAL_SAT_Old_New",
    F.when(
        (
            (
                F.coalesce(F.col("MAX_TEST_SCORES.MATH_SAT_Old"), F.lit(0))
                + F.coalesce(F.col("MAX_TEST_SCORES.VERBAL_SAT_Old"), F.lit(0))
            )
            >= F.lit(1070)
        ),
        F.col("MAX_TEST_SCORES.VERBAL_SAT_Old"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "Total_SAT_Old_New",
    F.when(
        (
            F.col("MAX_TEST_SCORES.Total_SAT_Old")
            > (
                F.coalesce(F.col("MAX_TEST_SCORES.MATH_SAT_Old"), F.lit(0))
                + F.coalesce(F.col("MAX_TEST_SCORES.VERBAL_SAT_Old"), F.lit(0))
            )
        ),
        F.col("MAX_TEST_SCORES.Total_SAT_Old"),
    ).otherwise(
        (
            F.coalesce(F.col("MAX_TEST_SCORES.MATH_SAT_Old"), F.lit(0))
            + F.coalesce(F.col("MAX_TEST_SCORES.VERBAL_SAT_Old"), F.lit(0))
        )
    ),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "Math_ACT_Old_New",
    F.when(
        (
            (F.col("MAX_TEST_SCORES.Total_ACT_Old") >= F.lit(23))
            & (F.col("MAX_TEST_SCORES.Math_ACT_Old") >= F.lit(19))
        ),
        F.col("MAX_TEST_SCORES.Math_ACT_Old"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "Verbal_ACT_Old_New",
    F.when(
        (
            (F.col("MAX_TEST_SCORES.Total_ACT_Old") >= F.lit(23))
            & (F.col("MAX_TEST_SCORES.Verbal_ACT_Old") >= F.lit(19))
        ),
        F.col("MAX_TEST_SCORES.Verbal_ACT_Old"),
    ).otherwise(F.lit(0)),
)

df_cbm002_calculatedscores = df_cbm002_calculatedscores.withColumn(
    "Total_ACT_Old_New",
    F.when(
        (F.col("MAX_TEST_SCORES.Total_ACT_Old") >= F.lit(23)),
        F.col("MAX_TEST_SCORES.Total_ACT_Old"),
    ).otherwise(F.lit(0)),
)

# COMMAND ----------

df_cbm002_calculatedscores = df_cbm002_calculatedscores.select(
    F.col("MAX_TEST_SCORES.STRM"),
    F.col("MAX_TEST_SCORES.EMPLID"),
    F.col("Math_ACT_New").alias("Math_ACT"),
    F.col("Read_ACT_New").alias("Read_ACT"),
    F.col("Write_ACT_New").alias("Write_ACT"),
    F.col("MAX_TEST_SCORES.Math_Taks"),
    F.col("MAX_TEST_SCORES.Read_Taks"),
    F.col("MAX_TEST_SCORES.Write_Taks"),
    F.col("MATH_SAT_New").alias("MATH_SAT"),
    F.col("VERBAL_SAT_New").alias("VERBAL_SAT"),
    F.col("Total_SAT_New").alias("Total_SAT"),
    F.col("English_Composite_ACT_New").alias("English_Composite_ACT"),
    F.col("MAX_TEST_SCORES.MATH_THEA"),
    F.col("MAX_TEST_SCORES.READ_THEA"),
    F.col("MAX_TEST_SCORES.WRITE_THEA"),
    F.col("MAX_TEST_SCORES.MATH_COMPASS"),
    F.col("MAX_TEST_SCORES.READ_COMPASS"),
    F.col("MAX_TEST_SCORES.WRITE_COMPASS"),
    F.col("MAX_TEST_SCORES.MATH_ASSET"),
    F.col("MAX_TEST_SCORES.READ_ASSET"),
    F.col("MAX_TEST_SCORES.WRITE_ASSET"),
    F.col("MAX_TEST_SCORES.MATH_ACCUPLACER"),
    F.col("MAX_TEST_SCORES.READ_ACCUPLACER"),
    F.col("MAX_TEST_SCORES.WRITE_ACCUPLACER"),
    F.col("MAX_TEST_SCORES.MATH_STANFORD"),
    F.col("MAX_TEST_SCORES.READ_STANFORD"),
    F.col("MAX_TEST_SCORES.WRITE_STANFORD"),
    F.col("MAX_TEST_SCORES.MATH_MAPS"),
    F.col("MAX_TEST_SCORES.READ_MAPS"),
    F.col("MAX_TEST_SCORES.WRITE_MAPS"),
    F.col("MAX_TEST_SCORES.WRITEESSAY_COMPASS"),
    F.col("MAX_TEST_SCORES.WRITEESSAY_ACCUPLACER"),
    F.col("MAX_TEST_SCORES.WRITEESSAY_ASSET"),
    F.col("MAX_TEST_SCORES.WRITEESSAY_STANFORD"),
    F.col("MAX_TEST_SCORES.WRITEESSAY_MAPS"),
    F.col("MAX_TEST_SCORES.MATH_TSIA"),
    F.col("MAX_TEST_SCORES.READ_TSIA"),
    F.col("MAX_TEST_SCORES.WRITE_TSIA"),
    F.col("MAX_TEST_SCORES.MATH_TSIA2"),
    F.col("MAX_TEST_SCORES.READ_TSIA2"),
    F.col("MAX_TEST_SCORES.WRITE_TSIA2"),
    F.col("MAX_TEST_SCORES.WRITEESSAY_TSIA"),
    F.col("MAX_TEST_SCORES.WRITEESSAY_TSIA2"),
    F.col("MATH_SAT_Old_New").alias("MATH_SAT_Old"),
    F.col("VERBAL_SAT_Old_New").alias("VERBAL_SAT_Old"),
    F.col("Total_SAT_Old_New").alias("Total_SAT_Old"),
    F.col("MAX_TEST_SCORES.MATH_TSIA2_Diagnostic"),
    F.col("MAX_TEST_SCORES.READ_TSIA2_Diagnostic"),
    F.col("MAX_TEST_SCORES.WRITE_TSIA2_Diagnostic"),
    F.col("Math_ACT_Old_New").alias("Math_ACT_Old"),
    F.col("Verbal_ACT_Old_New").alias("Verbal_ACT_Old"),
    F.col("Total_ACT_Old_New").alias("Total_ACT_Old"),
)

# COMMAND ----------

# Checkpoint 4: materialize df_cbm002_calculatedscores to break the upstream DAG
_tmp_stageD_tbl = f"{analytics}.{staging}._tmp_cbm002_calculatedscores"
write_df_to_table(
    df_cbm002_calculatedscores,
    _tmp_stageD_tbl,
    mode="overwrite",
    overwriteSchema="true",
)
df_cbm002_calculatedscores = read_table(_tmp_stageD_tbl).alias(
    "CBM002_CalculatedScores"
)
log_msg(f"Checkpoint 4 materialized: {_tmp_stageD_tbl}")

# COMMAND ----------

# Step: SAT/ACT/TAKS TestScores Final
cbm002_calculatedscores = df_cbm002_calculatedscores.alias("CBM002_CalculatedScores")

df_testscores_final = cbm002_international.join(
    cbm002_calculatedscores,
    on=(
        F.col("CBM002_International.EMPLID") == F.col("CBM002_CalculatedScores.EMPLID")
    ),
    how="left",
)

df_testscores_final = df_testscores_final.withColumn(
    "Race_UnknwnNotRptd_New",
    F.when(
        (
            F.col("CBM002_International.International").isNotNull()
            & (F.trim(F.col("CBM002_International.International")) != F.lit(""))
        ),
        F.lit(None),
    )
    .when(
        (
            F.col("CBM002_International.ETHNIC_ORIGIN").isin(["1", "3"])
            & (
                F.col("CBM002_International.Race_White").isNull()
                | (F.trim(F.col("CBM002_International.Race_White")) == F.lit(""))
            )
            & (
                F.col("CBM002_International.Race_Black").isNull()
                | (F.trim(F.col("CBM002_International.Race_Black")) == F.lit(""))
            )
            & (
                F.col("CBM002_International.Race_Asian").isNull()
                | (F.trim(F.col("CBM002_International.Race_Asian")) == F.lit(""))
            )
            & (
                F.col("CBM002_International.Race_AmIndAlsknNatv").isNull()
                | (
                    F.trim(F.col("CBM002_International.Race_AmIndAlsknNatv"))
                    == F.lit("")
                )
            )
            & (
                F.col("CBM002_International.International").isNull()
                | (F.trim(F.col("CBM002_International.International")) == F.lit(""))
            )
            & (
                F.col("CBM002_International.Race_NatHawnOPI").isNull()
                | (F.trim(F.col("CBM002_International.Race_NatHawnOPI")) == F.lit(""))
            )
        ),
        F.lit("7"),
    )
    .otherwise(F.col("CBM002_International.Race_UnknwnNotRptd")),
)

# COMMAND ----------

df_testscores_final = df_testscores_final.select(
    F.col("CBM002_International.ACAD_CAREER"),
    F.col("CBM002_International.National_Id"),
    F.col("CBM002_International.ACAD_PROG"),
    F.col("CBM002_International.CRSE_CAREER"),
    F.col("CBM002_International.EMPLID"),
    F.col("CBM002_International.INSTITUTION"),
    F.col("CBM002_International.STRM"),
    F.col("CBM002_International.TERM_BEGIN_DT"),
    F.col("CBM002_International.TERM_END_DT"),
    F.col("CBM002_International.CENSUS_DT"),
    F.col("CBM002_International.Current_Term_End_date"),
    F.col("CBM002_International.ACAD_ORG"),
    F.col("CBM002_International.STDNT_CAR_NBR"),
    F.col("CBM002_International.EFFDT"),
    F.col("CBM002_International.EFFSEQ"),
    F.col("CBM002_International.ACAD_PLAN"),
    F.col("CBM002_International.REQ_TERM"),
    F.col("CBM002_International.PLAN_TBL_EFFDT"),
    F.col("CBM002_International.PLAN_TBL_ACAD_PROG"),
    F.col("CBM002_International.ADMIT_TERM"),
    F.col("CBM002_International.DEGR_CHKOUT_STAT"),
    F.col("CBM002_International.ACAD_LEVEL_BOT"),
    F.col("CBM002_International.ACAD_LEVEL_EOT"),
    F.col("CBM002_International.ACAD_PROG_PRIMARY"),
    F.col("CBM002_International.TOT_CUMULATIVE"),
    F.col("CBM002_International.ADM_APPL_NBR"),
    F.col("CBM002_International.ADM_ADMIT_TERM"),
    F.col("CBM002_International.ADMIT_TYPE"),
    F.col("CBM002_International.RECRUITMENT_CAT"),
    F.col("CBM002_International.Current_Term"),
    F.col("CBM002_International.Race_White"),
    F.col("CBM002_International.Race_Black"),
    F.col("CBM002_International.Race_Asian"),
    F.col("CBM002_International.Race_AmIndAlsknNatv"),
    F.col("Race_UnknwnNotRptd_New").alias("Race_UnknwnNotRptd"),
    F.col("CBM002_International.Race_NatHawnOPI"),
    F.col("CBM002_International.ETHNIC_ORIGIN"),
    F.col("CBM002_International.ETHNIC_COUNT"),
    F.col("CBM002_International.FERPA_FLAG"),
    F.col("CBM002_International.GENDER"),
    F.col("CBM002_International.BIRTHDATE"),
    F.col("CBM002_International.TUITION_EXCPT"),
    F.col("CBM002_International.TUITION_RES"),
    F.col("CBM002_International.International"),
    F.col("CBM002_CalculatedScores.Math_ACT"),
    F.col("CBM002_CalculatedScores.Math_Taks"),
    F.col("CBM002_CalculatedScores.MATH_SAT"),
    F.col("CBM002_CalculatedScores.VERBAL_SAT"),
    F.col("CBM002_CalculatedScores.Total_SAT"),
    F.col("CBM002_CalculatedScores.English_Composite_ACT"),
    F.col("CBM002_CalculatedScores.MATH_THEA"),
    F.col("CBM002_CalculatedScores.READ_THEA"),
    F.col("CBM002_CalculatedScores.WRITE_THEA"),
    F.col("CBM002_CalculatedScores.MATH_COMPASS"),
    F.col("CBM002_CalculatedScores.READ_COMPASS"),
    F.col("CBM002_CalculatedScores.WRITE_COMPASS"),
    F.col("CBM002_CalculatedScores.MATH_ASSET"),
    F.col("CBM002_CalculatedScores.READ_ASSET"),
    F.col("CBM002_CalculatedScores.WRITE_ASSET"),
    F.col("CBM002_CalculatedScores.MATH_ACCUPLACER"),
    F.col("CBM002_CalculatedScores.READ_ACCUPLACER"),
    F.col("CBM002_CalculatedScores.WRITE_ACCUPLACER"),
    F.col("CBM002_CalculatedScores.MATH_STANFORD"),
    F.col("CBM002_CalculatedScores.READ_STANFORD"),
    F.col("CBM002_CalculatedScores.WRITE_STANFORD"),
    F.col("CBM002_CalculatedScores.MATH_MAPS"),
    F.col("CBM002_CalculatedScores.READ_MAPS"),
    F.col("CBM002_CalculatedScores.WRITE_MAPS"),
    F.col("CBM002_International.MathCoreCourseEnrolled"),
    F.col("CBM002_International.ReadCoreCourseEnrolled"),
    F.col("CBM002_International.WriteCoreCourseEnrolled"),
    F.col("CBM002_International.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_International.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_International.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_International.EAPStudent"),
    F.col("CBM002_CalculatedScores.Read_ACT"),
    F.col("CBM002_CalculatedScores.Write_ACT"),
    F.col("CBM002_CalculatedScores.Read_Taks"),
    F.col("CBM002_CalculatedScores.Write_Taks"),
    F.col("CBM002_CalculatedScores.WRITEESSAY_COMPASS"),
    F.col("CBM002_CalculatedScores.WRITEESSAY_ACCUPLACER"),
    F.col("CBM002_CalculatedScores.WRITEESSAY_ASSET"),
    F.col("CBM002_CalculatedScores.WRITEESSAY_STANFORD"),
    F.col("CBM002_CalculatedScores.WRITEESSAY_MAPS"),
    F.col("CBM002_International.PriorEnrolled"),
    F.col("CBM002_International.Flex"),
    F.col("CBM002_International.Year"),
    F.col("CBM002_CalculatedScores.MATH_TSIA"),
    F.col("CBM002_CalculatedScores.READ_TSIA"),
    F.col("CBM002_CalculatedScores.WRITE_TSIA"),
    F.col("CBM002_CalculatedScores.MATH_TSIA2"),
    F.col("CBM002_CalculatedScores.READ_TSIA2"),
    F.col("CBM002_CalculatedScores.WRITE_TSIA2"),
    F.col("CBM002_CalculatedScores.WRITEESSAY_TSIA"),
    F.col("CBM002_CalculatedScores.WRITEESSAY_TSIA2"),
    F.col("CBM002_CalculatedScores.MATH_SAT_Old"),
    F.col("CBM002_CalculatedScores.VERBAL_SAT_Old"),
    F.col("CBM002_CalculatedScores.Total_SAT_Old"),
    F.col("CBM002_CalculatedScores.MATH_TSIA2_Diagnostic"),
    F.col("CBM002_CalculatedScores.READ_TSIA2_Diagnostic"),
    F.col("CBM002_CalculatedScores.WRITE_TSIA2_Diagnostic"),
    F.col("CBM002_CalculatedScores.Math_ACT_Old"),
    F.col("CBM002_CalculatedScores.Verbal_ACT_Old"),
    F.col("CBM002_CalculatedScores.Total_ACT_Old"),
).distinct()

# COMMAND ----------

# Step: TSI Source Table
df_tsi_source = distinctstudents.join(
    ps_uta_tsi_section,
    (F.col("DistinctStudents.EMPLID") == F.col("PS_UTA_TSI_SECTION.EMPLID")),
    "left",
)

df_tsi_source = df_tsi_source.filter(
    (F.col("PS_UTA_TSI_SECTION.UTA_TSI_AREA").isNotNull())
    & (F.trim(F.col("PS_UTA_TSI_SECTION.UTA_TSI_AREA")) != F.lit(""))
)

df_tsi_source = df_tsi_source.select(
    F.col("DistinctStudents.EMPLID"),
    F.col("DistinctStudents.STRM"),
    F.col("DistinctStudents.CENSUS_DT"),
    F.col("PS_UTA_TSI_SECTION.DATE_TAKEN"),
    F.col("PS_UTA_TSI_SECTION.EFFDT"),
    F.col("PS_UTA_TSI_SECTION.UTA_TEST_DT"),
    F.col("PS_UTA_TSI_SECTION.UTA_TSI_AREA"),
    F.col("PS_UTA_TSI_SECTION.UTA_TSI_METHOD"),
    F.col("PS_UTA_TSI_SECTION.UTA_TSI_SCORE"),
    F.col("PS_UTA_TSI_SECTION.UTA_TSI_STATUS"),
)

# COMMAND ----------

# Step: Max TSI Section C/Asmt-TPlac
tsi_source = df_tsi_source.alias("TSI_Source")

df_tsi_section_c = tsi_source.filter(
    (F.col("TSI_Source.UTA_TSI_STATUS") == F.lit("C"))
    & F.col("TSI_Source.UTA_TSI_METHOD").isin(
        [
            "ACT",
            "SAT",
            "TAKS",
            "CORB",
            "THEA",
            "TASP",
            "COMP",
            "ASST",
            "ACCU",
            "STAN",
            "MAPS",
            "TXCB",
            "TSIA",
            "TSI2",
        ]
    )
)

df_tsi_section_c = df_tsi_section_c.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("TSI_Source.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "TSI_Source.STRM",
            "TSI_Source.EMPLID",
            "TSI_Source.UTA_TSI_AREA",
            "TSI_Source.UTA_TSI_METHOD",
        )
    ),
)

df_tsi_section_c = df_tsi_section_c.filter(
    (
        F.date_format(F.col("TSI_Source.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        == F.col("_agg_tmp_0")
    )
    & (
        F.date_format(F.col("TSI_Source.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.col("TSI_Source.CENSUS_DT"), "yyyy-MM-dd HH:mm:ss")
    )
).drop("_agg_tmp_0")

df_tsi_section_c = (
    df_tsi_section_c.groupBy(
        "TSI_Source.STRM",
        "TSI_Source.EMPLID",
        "TSI_Source.UTA_TSI_AREA",
        "TSI_Source.UTA_TSI_METHOD",
    )
    .agg(F.max(F.col("TSI_Source.UTA_TSI_SCORE")).alias("UTA_TSI_SCORE"))
    .distinct()
)

df_tsi_section_c = df_tsi_section_c.orderBy(
    F.col("STRM").asc(),
    F.col("EMPLID").asc(),
    F.col("UTA_TSI_METHOD").asc(),
    F.col("UTA_TSI_AREA").asc(),
)

# COMMAND ----------

# Step: MAX TSI Status (Other Method)
df_tsi_other_method = tsi_source.filter(
    (F.col("TSI_Source.UTA_TSI_METHOD") == F.lit("OTHR"))
    & (
        F.date_format(F.col("TSI_Source.DATE_TAKEN"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.col("TSI_Source.CENSUS_DT"), "yyyy-MM-dd HH:mm:ss")
    )
    & (F.coalesce(F.trim(F.col("TSI_Source.DATE_TAKEN")), F.lit("")) != F.lit(""))
)

df_tsi_other_method = df_tsi_other_method.select(
    F.col("TSI_Source.EMPLID"),
    F.col("TSI_Source.STRM"),
    F.col("TSI_Source.UTA_TSI_AREA"),
    F.col("TSI_Source.UTA_TSI_METHOD"),
    F.col("TSI_Source.UTA_TSI_STATUS"),
)

# COMMAND ----------

# Step: Max TSI Comp
df_max_tsi_comp = tsi_source.filter(
    F.coalesce(F.trim(F.col("TSI_Source.UTA_TSI_STATUS")), F.lit("")) == F.lit("C")
)

df_max_tsi_comp = df_max_tsi_comp.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("TSI_Source.DATE_TAKEN"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "TSI_Source.STRM",
            "TSI_Source.EMPLID",
            "TSI_Source.UTA_TSI_AREA",
            "TSI_Source.UTA_TSI_STATUS",
        )
    ),
)

df_max_tsi_comp = df_max_tsi_comp.filter(
    (
        (
            F.coalesce(
                F.date_format(F.col("TSI_Source.DATE_TAKEN"), "yyyy-MM-dd HH:mm:ss"),
                F.lit(""),
            )
            == F.coalesce(F.col("_agg_tmp_0"), F.lit(""))
        )
        & (
            F.coalesce(
                F.date_format(F.col("TSI_Source.DATE_TAKEN"), "yyyy-MM-dd HH:mm:ss"),
                F.lit(""),
            )
            <= F.date_format(F.current_timestamp(), "yyyy-MM-dd HH:mm:ss")
        )
    )
).drop("_agg_tmp_0")

df_max_tsi_comp = df_max_tsi_comp.select(
    F.col("TSI_Source.EMPLID"),
    F.col("TSI_Source.STRM"),
    F.col("TSI_Source.CENSUS_DT"),
    F.col("TSI_Source.DATE_TAKEN"),
    F.col("TSI_Source.UTA_TSI_AREA"),
    F.col("TSI_Source.UTA_TSI_STATUS"),
    F.when(
        (
            F.date_format(F.col("TSI_Source.CENSUS_DT"), "yyyy-MM-dd HH:mm:ss")
            == F.date_format(F.lit(current_term_census_date), "yyyy-MM-dd HH:mm:ss")
        ),
        F.date_format(F.lit(future_census), "yyyy-MM-dd HH:mm:ss"),
    )
    .when(
        (
            F.date_format(F.col("TSI_Source.CENSUS_DT"), "yyyy-MM-dd HH:mm:ss")
            != F.date_format(F.lit(current_term_census_date), "yyyy-MM-dd HH:mm:ss")
        ),
        F.date_format(F.lit(current_term_census_date), "yyyy-MM-dd HH:mm:ss"),
    )
    .alias("Future_Census"),
).distinct()

df_max_tsi_comp = df_max_tsi_comp.orderBy(
    F.col("STRM").asc(),
    F.col("EMPLID").asc(),
    F.col("UTA_TSI_AREA").asc(),
    F.col("UTA_TSI_STATUS").asc(),
)

# COMMAND ----------

# Step: MAX TSI Sta Sec
df_max_tsi_sta_sec = ps_uta_tsi_sta_exm.join(
    tsi_source,
    on=(F.col("PS_UTA_TSI_STA_EXM.EMPLID") == F.col("TSI_Source.EMPLID")),
    how="inner",
)

df_max_tsi_sta_sec = df_max_tsi_sta_sec.filter(
    (F.col("PS_UTA_TSI_STA_EXM.UTA_TSI_OVERALL") != F.lit("C"))
    & (F.col("TSI_Source.UTA_TSI_STATUS") == F.lit("C"))
)

df_max_tsi_sta_sec = df_max_tsi_sta_sec.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("TSI_Source.DATE_TAKEN"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "TSI_Source.STRM",
            "TSI_Source.EMPLID",
            "TSI_Source.UTA_TSI_AREA",
            "TSI_Source.UTA_TSI_STATUS",
        )
    ),
)

df_max_tsi_sta_sec = df_max_tsi_sta_sec.filter(
    (
        F.date_format(F.col("TSI_Source.DATE_TAKEN"), "yyyy-MM-dd HH:mm:ss")
        == F.col("_agg_tmp_0")
    )
    & (
        F.date_format(F.col("TSI_Source.DATE_TAKEN"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.col("TSI_Source.CENSUS_DT"), "yyyy-MM-dd HH:mm:ss")
    )
    & (F.coalesce(F.trim(F.col("TSI_Source.DATE_TAKEN")), F.lit("")) != F.lit(""))
).drop("_agg_tmp_0")

df_max_tsi_sta_sec = df_max_tsi_sta_sec.select(
    F.col("TSI_Source.STRM"),
    F.col("PS_UTA_TSI_STA_EXM.EMPLID"),
    F.col("TSI_Source.UTA_TSI_AREA"),
    F.col("PS_UTA_TSI_STA_EXM.STATUS_DT"),
)

# COMMAND ----------

# Step: TSI STA SEC
# Check for previously reported
df_tsi_sta_sec = df_max_tsi_sta_sec.alias("MAX_TSI_Sta_Sec")

df_tsi_sta_sec = df_tsi_sta_sec.groupBy(
    "MAX_TSI_Sta_Sec.STRM", "MAX_TSI_Sta_Sec.EMPLID"
).agg(
    F.max(
        F.when(
            (F.col("MAX_TSI_Sta_Sec.UTA_TSI_AREA") == F.lit("M")), F.lit(1)
        ).otherwise(F.lit(0))
    ).alias("MATH_TSI_PRIOR_REPORTED"),
    F.max(
        F.when(
            (F.col("MAX_TSI_Sta_Sec.UTA_TSI_AREA") == F.lit("R")), F.lit(1)
        ).otherwise(F.lit(0))
    ).alias("READ_TSI_PRIOR_REPORTED"),
    F.max(
        F.when(
            (F.col("MAX_TSI_Sta_Sec.UTA_TSI_AREA") == F.lit("W")), F.lit(1)
        ).otherwise(F.lit(0))
    ).alias("WRITE_TSI_PRIOR_REPORTED"),
)

# COMMAND ----------

# Step: TSI Section C / TPLAC
df_tsi_section_c_final = df_tsi_section_c.alias("TSI_Section_C")

_win_spec_2 = Window.partitionBy(
    F.col("TSI_Section_C.STRM"), F.col("TSI_Section_C.EMPLID")
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_ACTMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ACT"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_ACTMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ACT"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_ACTMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ACT"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_SATMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("SAT"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_SATMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("SAT"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_SATMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("SAT"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_TAKSMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TAKS"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

# COMMAND ----------

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_TAKSMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TAKS"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_TAKSMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TAKS"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_CORBMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("CORB"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_CORBMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("CORB"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_CORBMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("CORB"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_THEAMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("THEA"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_THEAMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("THEA"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

# COMMAND ----------

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_THEAMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("THEA"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_TASPMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TASP"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_TASPMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TASP"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_TASPMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TASP"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_COMPMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("COMP"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_COMPMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("COMP"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_COMPMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("COMP"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

# COMMAND ----------

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_ASSTMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ASST"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_ASSTMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ASST"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_ASSTMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ASST"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_ACCUMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ACCU"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_ACCUMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ACCU"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_ACCUMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("ACCU"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_STANMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("STAN"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

# COMMAND ----------

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_STANMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("STAN"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_STANMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("STAN"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_MAPSMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit(" MAPS"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_MAPSMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("MAPS"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_MAPSMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("MAPS"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_TSIAMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TSIA"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_TSIAMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TSIA"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

# COMMAND ----------

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_TSIAMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TSIA"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_TXCBMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TCXB"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_TXCBMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TCXB"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_TXCBMETHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TCXB"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Math_TSI_TSIA2METHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TSI2"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("M"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Read_TSI_TSIA2METHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TSI2"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("R"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

df_tsi_section_c_final = df_tsi_section_c_final.withColumn(
    "Write_TSI_TSIA2METHOD",
    F.max(
        F.when(
            (
                (F.col("TSI_Section_C.UTA_TSI_METHOD") == F.lit("TSI2"))
                & (F.col("TSI_Section_C.UTA_TSI_AREA") == F.lit("W"))
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_win_spec_2),
)

# COMMAND ----------


df_tsi_section_c_final = df_tsi_section_c_final.select(
    F.col("TSI_Section_C.STRM"),
    F.col("TSI_Section_C.EMPLID"),
    F.col("Math_TSI_ACTMETHOD"),
    F.col("Read_TSI_ACTMETHOD"),
    F.col("Write_TSI_ACTMETHOD"),
    F.col("Math_TSI_SATMETHOD"),
    F.col("Read_TSI_SATMETHOD"),
    F.col("Write_TSI_SATMETHOD"),
    F.col("Math_TSI_TAKSMETHOD"),
    F.col("Read_TSI_TAKSMETHOD"),
    F.col("Write_TSI_TAKSMETHOD"),
    F.col("Math_TSI_CORBMETHOD"),
    F.col("Read_TSI_CORBMETHOD"),
    F.col("Write_TSI_CORBMETHOD"),
    F.col("Math_TSI_THEAMETHOD"),
    F.col("Read_TSI_THEAMETHOD"),
    F.col("Write_TSI_THEAMETHOD"),
    F.col("Math_TSI_TASPMETHOD"),
    F.col("Read_TSI_TASPMETHOD"),
    F.col("Write_TSI_TASPMETHOD"),
    F.col("Math_TSI_COMPMETHOD"),
    F.col("Read_TSI_COMPMETHOD"),
    F.col("Write_TSI_COMPMETHOD"),
    F.col("Math_TSI_ASSTMETHOD"),
    F.col("Read_TSI_ASSTMETHOD"),
    F.col("Write_TSI_ASSTMETHOD"),
    F.col("Math_TSI_ACCUMETHOD"),
    F.col("Read_TSI_ACCUMETHOD"),
    F.col("Write_TSI_ACCUMETHOD"),
    F.col("Math_TSI_STANMETHOD"),
    F.col("Read_TSI_STANMETHOD"),
    F.col("Write_TSI_STANMETHOD"),
    F.col("Math_TSI_MAPSMETHOD"),
    F.col("Read_TSI_MAPSMETHOD"),
    F.col("Write_TSI_MAPSMETHOD"),
    F.col("Math_TSI_TSIAMETHOD"),
    F.col("Read_TSI_TSIAMETHOD"),
    F.col("Write_TSI_TSIAMETHOD"),
    F.col("Math_TSI_TXCBMETHOD"),
    F.col("Read_TSI_TXCBMETHOD"),
    F.col("Write_TSI_TXCBMETHOD"),
    F.col("Math_TSI_TSIA2METHOD"),
    F.col("Read_TSI_TSIA2METHOD"),
    F.col("Write_TSI_TSIA2METHOD"),
).distinct()

# COMMAND ----------

# Step: TSI Sec Comp Final
df_tsi_sec_comp_final = df_max_tsi_comp.alias("Max_TSI_Comp")
df_tsi_sec_comp_final = (
    df_tsi_sec_comp_final.groupBy("Max_TSI_Comp.STRM", "Max_TSI_Comp.EMPLID")
    .agg(
        F.max(
            F.when(
                (
                    (F.col("Max_TSI_Comp.DATE_TAKEN") > F.col("Max_TSI_Comp.CENSUS_DT"))
                    & (
                        F.col("Max_TSI_Comp.DATE_TAKEN")
                        < F.col("Max_TSI_Comp.Future_Census")
                    )
                    & (F.col("Max_TSI_Comp.UTA_TSI_AREA") == F.lit("M"))
                ),
                F.lit(1),
            ).otherwise(F.lit(0))
        ).alias("MathTSIPassedAfterCensus"),
        F.max(
            F.when(
                (
                    (F.col("Max_TSI_Comp.DATE_TAKEN") > F.col("Max_TSI_Comp.CENSUS_DT"))
                    & (
                        F.col("Max_TSI_Comp.DATE_TAKEN")
                        < F.col("Max_TSI_Comp.Future_Census")
                    )
                    & (F.col("Max_TSI_Comp.UTA_TSI_AREA") == F.lit("R"))
                ),
                F.lit(1),
            ).otherwise(F.lit(0))
        ).alias("ReadTSIPassedAfterCensus"),
        F.max(
            F.when(
                (
                    (F.col("Max_TSI_Comp.DATE_TAKEN") > F.col("Max_TSI_Comp.CENSUS_DT"))
                    & (
                        F.col("Max_TSI_Comp.DATE_TAKEN")
                        < F.col("Max_TSI_Comp.Future_Census")
                    )
                    & (F.col("Max_TSI_Comp.UTA_TSI_AREA") == F.lit("W"))
                ),
                F.lit(1),
            ).otherwise(F.lit(0))
        ).alias("WriteTSIPassedAfterCensus"),
    )
    .distinct()
)

# COMMAND ----------

# Step: TSI Status( Other Method) Final
# Create temp view: TSI_Status_Final
df_tsi_status_final = df_tsi_other_method.alias("TSI_Other_Method")
df_tsi_status_final = (
    df_tsi_status_final.groupBy("TSI_Other_Method.STRM", "TSI_Other_Method.EMPLID")
    .agg(
        F.max(
            F.when(
                (
                    (F.col("TSI_Other_Method.UTA_TSI_AREA") == F.lit("M"))
                    & (F.col("TSI_Other_Method.UTA_TSI_STATUS") == F.lit("C"))
                ),
                F.lit(1),
            ).otherwise(F.lit(0))
        ).alias("MATH_TSI_STATUS"),
        F.max(
            F.when(
                (
                    (F.col("TSI_Other_Method.UTA_TSI_AREA") == F.lit("R"))
                    & (F.col("TSI_Other_Method.UTA_TSI_STATUS") == F.lit("C"))
                ),
                F.lit(1),
            ).otherwise(F.lit(0))
        ).alias("READ_TSI_STATUS"),
        F.max(
            F.when(
                (
                    (F.col("TSI_Other_Method.UTA_TSI_AREA") == F.lit("W"))
                    & (F.col("TSI_Other_Method.UTA_TSI_STATUS") == F.lit("C"))
                ),
                F.lit(1),
            ).otherwise(F.lit(0))
        ).alias("WRITE_TSI_STATUS"),
    )
    .distinct()
)

# COMMAND ----------

# Step: TSI Final
# Max_TSI_TermExmp

df_Max_TSI_TermExmp = ps_uta_tsi_trm_exm.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_UTA_TSI_TRM_EXM.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("PS_UTA_TSI_TRM_EXM.EMPLID", "PS_UTA_TSI_TRM_EXM.STRM")
    ),
)
df_Max_TSI_TermExmp = df_Max_TSI_TermExmp.filter(
    (
        F.date_format(F.col("PS_UTA_TSI_TRM_EXM.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        == F.col("_agg_tmp_0")
    )
    & (
        F.date_format(F.col("PS_UTA_TSI_TRM_EXM.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.current_timestamp(), "yyyy-MM-dd HH:mm:ss")
    )
).drop("_agg_tmp_0")

df_Max_TSI_TermExmp = df_Max_TSI_TermExmp.distinct()

# COMMAND ----------

# cbm002_tsi
ps_uta_tsi_sta_exm_extract2 = ps_uta_tsi_sta_exm.alias("PS_UTA_TSI_STA_EXM_Extract2")
testscores_final = df_testscores_final.alias("TestScores_Final")
max_tsi_termexmp = df_Max_TSI_TermExmp.alias("Max_TSI_TermExmp")
tsi_section_c_final = df_tsi_section_c_final.alias("TSI_Section_C_Final")
tsi_sec_comp_final = df_tsi_sec_comp_final.alias("TSI_SEC_COMP_FINAL")
tsi_status_final = df_tsi_status_final.alias("TSI_Status_Final")
tsi_sta_sec = df_tsi_sta_sec.alias("TSI_STA_SEC")

df_cbm002_tsi = testscores_final.join(
    ps_uta_tsi_sta_exm,
    (F.col("TestScores_Final.EMPLID") == F.col("PS_UTA_TSI_STA_EXM.EMPLID")),
    "left",
)

df_cbm002_tsi = (
    df_cbm002_tsi.join(
        ps_uta_tsi_sta_exm_extract2,
        on=(
            (
                F.col("TestScores_Final.EMPLID")
                == F.col("PS_UTA_TSI_STA_EXM_Extract2.EMPLID")
            )
            & (F.col("PS_UTA_TSI_STA_EXM_Extract2.UTA_TSI_OVERALL") == F.lit("C"))
            & (
                F.date_format(
                    F.col("PS_UTA_TSI_STA_EXM_Extract2.STATUS_DT"),
                    "yyyy-MM-dd HH:mm:ss",
                )
                <= F.date_format(
                    F.col("TestScores_Final.CENSUS_DT"), "yyyy-MM-dd HH:mm:ss"
                )
            )
        ),
        how="left",
    )
    .join(
        max_tsi_termexmp,
        on=(
            (F.col("TestScores_Final.EMPLID") == F.col("Max_TSI_TermExmp.EMPLID"))
            & (F.col("TestScores_Final.STRM") == F.col("Max_TSI_TermExmp.STRM"))
        ),
        how="left",
    )
    .join(
        tsi_section_c_final,
        on=(
            (F.col("TestScores_Final.EMPLID") == F.col("TSI_Section_C_Final.EMPLID"))
            & (F.col("TestScores_Final.STRM") == F.col("TSI_Section_C_Final.STRM"))
        ),
        how="left",
    )
    .join(
        tsi_sec_comp_final,
        on=(
            (F.col("TestScores_Final.EMPLID") == F.col("TSI_SEC_COMP_FINAL.EMPLID"))
            & (F.col("TestScores_Final.STRM") == F.col("TSI_SEC_COMP_FINAL.STRM"))
        ),
        how="left",
    )
    .join(
        tsi_status_final,
        on=(
            (F.col("TestScores_Final.EMPLID") == F.col("TSI_Status_Final.EMPLID"))
            & (F.col("TestScores_Final.STRM") == F.col("TSI_Status_Final.STRM"))
        ),
        how="left",
    )
    .join(
        tsi_sta_sec,
        on=(
            (F.col("TestScores_Final.EMPLID") == F.col("TSI_STA_SEC.EMPLID"))
            & (F.col("TestScores_Final.STRM") == F.col("TSI_STA_SEC.STRM"))
        ),
        how="left",
    )
)

# COMMAND ----------

df_cbm002_tsi = df_cbm002_tsi.withColumn(
    "STATUS_DT_NEW",
    (F.col("PS_UTA_TSI_STA_EXM.STATUS_DT").cast("DATE")).cast("TIMESTAMP"),
)

df_cbm002_tsi = df_cbm002_tsi.withColumn(
    "MATH_TSI_PRIOR_REPORTED_NEW",
    F.when(F.col("TestScores_Final.PriorEnrolled") == F.lit("N"), F.lit(0))
    .when(
        (
            (F.col("PS_UTA_TSI_STA_EXM_Extract2.EMPLID").isNotNull())
            & (F.col("PS_UTA_TSI_STA_EXM_Extract2.EMPLID") != F.lit(""))
        ),
        F.lit(1),
    )
    .when((F.col("TSI_STA_SEC.MATH_TSI_PRIOR_REPORTED") == F.lit(1)), F.lit(1))
    .otherwise(F.lit(0)),
)


df_cbm002_tsi = df_cbm002_tsi.withColumn(
    "READ_TSI_PRIOR_REPORTED_NEW",
    F.when(F.col("TestScores_Final.PriorEnrolled") == F.lit("N"), F.lit(0))
    .when(
        (
            (F.col("PS_UTA_TSI_STA_EXM_Extract2.EMPLID").isNotNull())
            & (F.col("PS_UTA_TSI_STA_EXM_Extract2.EMPLID") != F.lit(""))
        ),
        F.lit(1),
    )
    .when((F.col("TSI_STA_SEC.READ_TSI_PRIOR_REPORTED") == F.lit(1)), F.lit(1))
    .otherwise(F.lit(0)),
)

df_cbm002_tsi = df_cbm002_tsi.withColumn(
    "WRITE_TSI_PRIOR_REPORTED_NEW",
    F.when(F.col("TestScores_Final.PriorEnrolled") == F.lit("N"), F.lit(0))
    .when(
        (
            (F.col("PS_UTA_TSI_STA_EXM_Extract2.EMPLID").isNotNull())
            & (F.col("PS_UTA_TSI_STA_EXM_Extract2.EMPLID") != F.lit(""))
        ),
        F.lit(1),
    )
    .when((F.col("TSI_STA_SEC.WRITE_TSI_PRIOR_REPORTED") == F.lit(1)), F.lit(1))
    .otherwise(F.lit(0)),
)

df_cbm002_tsi = df_cbm002_tsi.withColumn(
    "MathTSIEndOfTerm_NEW",
    F.when(
        (
            (F.col("TSI_SEC_COMP_FINAL.MathTSIPassedAfterCensus") == F.lit(1))
            | (
                (
                    (F.col("PS_UTA_TSI_STA_EXM.UTA_MATH_STATUS") == F.lit("Y"))
                    | (F.col("PS_UTA_TSI_STA_EXM.UTA_TSI_OVERALL") == F.lit("C"))
                )
                & (
                    F.col("PS_UTA_TSI_STA_EXM.STATUS_DT")
                    > F.col("TestScores_Final.CENSUS_DT")
                )
            )
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

# COMMAND ----------

df_cbm002_tsi = df_cbm002_tsi.withColumn(
    "ReadTSIEndOfTerm_NEW",
    F.when(
        (
            (F.col("TSI_SEC_COMP_FINAL.ReadTSIPassedAfterCensus") == F.lit(1))
            | (
                (
                    (F.col("PS_UTA_TSI_STA_EXM.UTA_READ_STATUS") == F.lit("Y"))
                    | (F.col("PS_UTA_TSI_STA_EXM.UTA_TSI_OVERALL") == F.lit("C"))
                )
                & (
                    F.col("PS_UTA_TSI_STA_EXM.STATUS_DT")
                    > F.col("TestScores_Final.CENSUS_DT")
                )
            )
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

df_cbm002_tsi = df_cbm002_tsi.withColumn(
    "WriteTSIEndOfTerm_NEW",
    F.when(
        (
            (F.col("TSI_SEC_COMP_FINAL.WriteTSIPassedAfterCensus") == F.lit(1))
            | (
                (
                    (F.col("PS_UTA_TSI_STA_EXM.UTA_WRITE_STATUS") == F.lit("Y"))
                    | (F.col("PS_UTA_TSI_STA_EXM.UTA_TSI_OVERALL") == F.lit("C"))
                )
                & (
                    F.col("PS_UTA_TSI_STA_EXM.STATUS_DT")
                    > F.col("TestScores_Final.CENSUS_DT")
                )
            )
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

df_cbm002_tsi = df_cbm002_tsi.withColumn(
    "TSI_Oblig_Waived_NEW",
    F.when((F.col("TestScores_Final.EAPStudent") == F.lit("Y")), F.lit("2")).otherwise(
        F.lit("0")
    ),
)

# COMMAND ----------

df_cbm002_tsi = df_cbm002_tsi.select(
    F.col("TestScores_Final.ACAD_CAREER"),
    F.col("TestScores_Final.National_Id"),
    F.col("TestScores_Final.ACAD_PROG"),
    F.col("TestScores_Final.CRSE_CAREER"),
    F.col("TestScores_Final.EMPLID"),
    F.col("TestScores_Final.INSTITUTION"),
    F.col("TestScores_Final.STRM"),
    F.col("TestScores_Final.TERM_BEGIN_DT"),
    F.col("TestScores_Final.TERM_END_DT"),
    F.col("TestScores_Final.CENSUS_DT"),
    F.col("TestScores_Final.Current_Term_End_date"),
    F.col("TestScores_Final.ACAD_ORG"),
    F.col("TestScores_Final.STDNT_CAR_NBR"),
    F.col("TestScores_Final.EFFDT"),
    F.col("TestScores_Final.EFFSEQ"),
    F.col("TestScores_Final.ACAD_PLAN"),
    F.col("TestScores_Final.REQ_TERM"),
    F.col("TestScores_Final.PLAN_TBL_EFFDT"),
    F.col("TestScores_Final.PLAN_TBL_ACAD_PROG"),
    F.col("TestScores_Final.ADMIT_TERM"),
    F.col("TestScores_Final.DEGR_CHKOUT_STAT"),
    F.col("TestScores_Final.ACAD_LEVEL_BOT"),
    F.col("TestScores_Final.ACAD_LEVEL_EOT"),
    F.col("TestScores_Final.ACAD_PROG_PRIMARY"),
    F.col("TestScores_Final.TOT_CUMULATIVE"),
    F.col("TestScores_Final.ADM_APPL_NBR"),
    F.col("TestScores_Final.ADM_ADMIT_TERM"),
    F.col("TestScores_Final.ADMIT_TYPE"),
    F.col("TestScores_Final.RECRUITMENT_CAT"),
    F.col("TestScores_Final.Current_Term"),
    F.col("TestScores_Final.Race_White"),
    F.col("TestScores_Final.Race_Black"),
    F.col("TestScores_Final.Race_Asian"),
    F.col("TestScores_Final.Race_AmIndAlsknNatv"),
    F.col("TestScores_Final.Race_UnknwnNotRptd"),
    F.col("TestScores_Final.Race_NatHawnOPI"),
    F.col("TestScores_Final.ETHNIC_ORIGIN"),
    F.col("TestScores_Final.ETHNIC_COUNT"),
    F.col("TestScores_Final.FERPA_FLAG"),
    F.col("TestScores_Final.GENDER"),
    F.col("TestScores_Final.BIRTHDATE"),
    F.col("TestScores_Final.TUITION_EXCPT"),
    F.col("TestScores_Final.TUITION_RES"),
    F.col("TestScores_Final.International"),
    F.col("STATUS_DT_NEW").alias("STATUS_DT"),
    F.col("PS_UTA_TSI_STA_EXM.UTA_MATH_STATUS"),
    F.col("PS_UTA_TSI_STA_EXM.UTA_READ_STATUS"),
    F.col("PS_UTA_TSI_STA_EXM.UTA_TSI_EXMPT_TYP"),
    F.col("PS_UTA_TSI_STA_EXM.UTA_TSI_OVERALL"),
    F.col("PS_UTA_TSI_STA_EXM.UTA_WRITE_STATUS"),
    F.col("MATH_TSI_PRIOR_REPORTED_NEW").alias("MATH_TSI_PRIOR_REPORTED"),
    F.col("READ_TSI_PRIOR_REPORTED_NEW").alias("READ_TSI_PRIOR_REPORTED"),
    F.col("WRITE_TSI_PRIOR_REPORTED_NEW").alias("WRITE_TSI_PRIOR_REPORTED"),
    F.col("Max_TSI_TermExmp.UTA_TSI_TERM_EXMP"),
    F.col("MathTSIEndOfTerm_NEW").alias("MathTSIEndOfTerm"),
    F.col("ReadTSIEndOfTerm_NEW").alias("ReadTSIEndOfTerm"),
    F.col("WriteTSIEndOfTerm_NEW").alias("WriteTSIEndOfTerm"),
    F.col("TSI_Status_Final.MATH_TSI_STATUS"),
    F.col("TSI_Status_Final.READ_TSI_STATUS"),
    F.col("TSI_Status_Final.WRITE_TSI_STATUS"),
    F.col("TSI_Section_C_Final.Math_TSI_ACTMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_ACTMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_ACTMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_SATMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_SATMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_SATMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_TAKSMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_TAKSMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_TAKSMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_CORBMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_CORBMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_CORBMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_THEAMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_THEAMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_THEAMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_TASPMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_TASPMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_TASPMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_COMPMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_COMPMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_COMPMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_ASSTMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_ASSTMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_ASSTMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_ACCUMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_ACCUMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_ACCUMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_STANMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_STANMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_STANMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_MAPSMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_MAPSMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_MAPSMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_TSIAMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_TSIAMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_TSIAMETHOD"),
    F.col("TSI_Section_C_Final.Math_TSI_TXCBMETHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_TXCBMETHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_TXCBMETHOD"),
    F.col("TSI_Oblig_Waived_NEW").alias("TSI_Oblig_Waived"),
    F.col("TestScores_Final.Math_ACT"),
    F.col("TestScores_Final.Read_ACT"),
    F.col("TestScores_Final.Write_ACT"),
    F.col("TestScores_Final.Math_Taks"),
    F.col("TestScores_Final.MATH_SAT"),
    F.col("TestScores_Final.VERBAL_SAT"),
    F.col("TestScores_Final.Total_SAT"),
    F.col("TestScores_Final.English_Composite_ACT"),
    F.col("TestScores_Final.MATH_THEA"),
    F.col("TestScores_Final.READ_THEA"),
    F.col("TestScores_Final.WRITE_THEA"),
    F.col("TestScores_Final.MATH_COMPASS"),
    F.col("TestScores_Final.READ_COMPASS"),
    F.col("TestScores_Final.WRITE_COMPASS"),
    F.col("TestScores_Final.MATH_ASSET"),
    F.col("TestScores_Final.READ_ASSET"),
    F.col("TestScores_Final.WRITE_ASSET"),
    F.col("TestScores_Final.MATH_ACCUPLACER"),
    F.col("TestScores_Final.READ_ACCUPLACER"),
    F.col("TestScores_Final.WRITE_ACCUPLACER"),
    F.col("TestScores_Final.MATH_STANFORD"),
    F.col("TestScores_Final.READ_STANFORD"),
    F.col("TestScores_Final.WRITE_STANFORD"),
    F.col("TestScores_Final.MATH_MAPS"),
    F.col("TestScores_Final.READ_MAPS"),
    F.col("TestScores_Final.WRITE_MAPS"),
    F.col("TestScores_Final.MathCoreCourseEnrolled"),
    F.col("TestScores_Final.ReadCoreCourseEnrolled"),
    F.col("TestScores_Final.WriteCoreCourseEnrolled"),
    F.col("TestScores_Final.MathCoreCoursePriorEnrolled"),
    F.col("TestScores_Final.ReadCoreCoursePriorEnrolled"),
    F.col("TestScores_Final.WriteCoreCoursePriorEnrolled"),
    F.col("TestScores_Final.EAPStudent"),
    F.col("TestScores_Final.Read_Taks"),
    F.col("TestScores_Final.Write_Taks"),
    F.col("TestScores_Final.WRITEESSAY_COMPASS"),
    F.col("TestScores_Final.WRITEESSAY_ACCUPLACER"),
    F.col("TestScores_Final.WRITEESSAY_ASSET"),
    F.col("TestScores_Final.WRITEESSAY_STANFORD"),
    F.col("TestScores_Final.WRITEESSAY_MAPS"),
    F.col("TestScores_Final.PriorEnrolled"),
    F.col("TestScores_Final.Flex"),
    F.col("TestScores_Final.Year"),
    F.col("TSI_Section_C_Final.Math_TSI_TSIA2METHOD"),
    F.col("TSI_Section_C_Final.Read_TSI_TSIA2METHOD"),
    F.col("TSI_Section_C_Final.Write_TSI_TSIA2METHOD"),
    F.col("TestScores_Final.MATH_TSIA"),
    F.col("TestScores_Final.READ_TSIA"),
    F.col("TestScores_Final.WRITE_TSIA"),
    F.col("TestScores_Final.MATH_TSIA2"),
    F.col("TestScores_Final.READ_TSIA2"),
    F.col("TestScores_Final.WRITE_TSIA2"),
    F.col("TestScores_Final.WRITEESSAY_TSIA"),
    F.col("TestScores_Final.WRITEESSAY_TSIA2"),
    F.col("TestScores_Final.MATH_SAT_Old"),
    F.col("TestScores_Final.VERBAL_SAT_Old"),
    F.col("TestScores_Final.Total_SAT_Old"),
    F.col("TestScores_Final.MATH_TSIA2_Diagnostic"),
    F.col("TestScores_Final.READ_TSIA2_Diagnostic"),
    F.col("TestScores_Final.WRITE_TSIA2_Diagnostic"),
    F.col("TestScores_Final.Math_ACT_Old"),
    F.col("TestScores_Final.Verbal_ACT_Old"),
    F.col("TestScores_Final.Total_ACT_Old"),
).distinct()

# COMMAND ----------

# Checkpoint 5: materialize df_cbm002_tsi to break the upstream DAG
_tmp_stageE_tbl = f"{analytics}.{staging}._tmp_cbm002_tsi"
write_df_to_table(
    df_cbm002_tsi, _tmp_stageE_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm002_tsi = read_table(_tmp_stageE_tbl).alias("CBM002_TSI")
log_msg(f"Checkpoint 5 materialized: {_tmp_stageE_tbl}")

# COMMAND ----------

# Step: Transfer Course & Test Detail
df_Min_Articulation_Term = ps_trns_test_dtl

df_Min_Articulation_Term = df_Min_Articulation_Term.filter(
    (F.col("PS_TRNS_TEST_DTL.ACAD_CAREER") == F.lit("UGRD"))
    & ((F.col("PS_TRNS_TEST_DTL.TEST_ID")).isin(["AP", "CLEP", "IB"]))
    & (F.trim(F.col("PS_TRNS_TEST_DTL.EARN_CREDIT")) == F.lit("Y"))
    & (
        F.trim(F.col("PS_TRNS_TEST_DTL.RQMNT_DESIGNTN")).isin(
            [
                "010",
                "020",
                "040",
                "060",
                "070",
                "080",
                "090",
                "2092",
                "1091",
                "092",
                "098",
                "4094",
                "8098",
            ]
        )
    )
)

df_Min_Articulation_Term = df_Min_Articulation_Term.withColumn(
    "_agg_tmp_0",
    F.min(F.col("PS_TRNS_TEST_DTL.ARTICULATION_TERM")).over(
        Window.partitionBy(
            F.col("PS_TRNS_TEST_DTL.EMPLID"),
            F.col("PS_TRNS_TEST_DTL.TEST_ID"),
            F.col("PS_TRNS_TEST_DTL.RQMNT_DESIGNTN"),
        )
    ),
)

df_Min_Articulation_Term = df_Min_Articulation_Term.filter(
    F.col("PS_TRNS_TEST_DTL.ARTICULATION_TERM") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_Min_Articulation_Term = df_Min_Articulation_Term.distinct()

# COMMAND ----------

# Create temp view: CBM002_Transfer_Course
df_cbm002_transfer_course = df_cbm002_tsi.alias("CBM002_TSI")
min_articulation_term = df_Min_Articulation_Term.alias("Min_Articulation_Term")

df_cbm002_transfer_course = df_cbm002_transfer_course.join(
    min_articulation_term,
    on=(
        (F.col("CBM002_TSI.EMPLID") == F.col("Min_Articulation_Term.EMPLID"))
        & (
            F.col("CBM002_TSI.ACAD_CAREER")
            == F.col("Min_Articulation_Term.ACAD_CAREER")
        )
    ),
    how="left",
).join(
    ps_trns_crse_dtl,
    on=(
        (F.col("CBM002_TSI.EMPLID") == F.col("PS_TRNS_CRSE_DTL.EMPLID"))
        & (F.col("CBM002_TSI.ACAD_CAREER") == F.lit("UGRD"))
        & (F.col("CBM002_TSI.INSTITUTION") == F.lit("UTARL"))
        & F.col("PS_TRNS_CRSE_DTL.RQMNT_DESIGNTN").isin(
            ["010", "020", "040", "060", "070", "080", "090"]
        )
        & (F.col("PS_TRNS_CRSE_DTL.EARN_CREDIT") == F.lit("Y"))
    ),
    how="left",
)

# COMMAND ----------

_winSpec_5 = Window.partitionBy(F.col("CBM002_TSI.EMPLID"))

df_cbm002_transfer_course = df_cbm002_transfer_course.withColumn(
    "Math_ArticulationTerm",
    F.min(
        F.when(
            F.col("Min_Articulation_Term.RQMNT_DESIGNTN").isin(["020", "2092", "092"]),
            F.col("Min_Articulation_Term.ARTICULATION_TERM"),
        )
    ).over(_winSpec_5),
)

df_cbm002_transfer_course = df_cbm002_transfer_course.withColumn(
    "Read_ArticulationTerm",
    F.min(
        F.when(
            F.col("Min_Articulation_Term.RQMNT_DESIGNTN").isin(
                ["040", "060", "070", "080", "098", "4094", "8098"]
            ),
            F.col("Min_Articulation_Term.ARTICULATION_TERM"),
        )
    ).over(_winSpec_5),
)
df_cbm002_transfer_course = df_cbm002_transfer_course.withColumn(
    "Write_ArticulationTerm",
    F.min(
        F.when(
            F.col("Min_Articulation_Term.RQMNT_DESIGNTN").isin(["010", "1091"]),
            F.col("Min_Articulation_Term.ARTICULATION_TERM"),
        )
    ).over(_winSpec_5),
)

df_cbm002_transfer_course = df_cbm002_transfer_course.withColumn(
    "Math_Transfer_Course",
    F.max(
        F.when(
            (
                F.col("PS_TRNS_CRSE_DTL.RQMNT_DESIGNTN").isin(["020", "2092", "092"])
                & F.col("PS_TRNS_CRSE_DTL.EMPLID").isNotNull()
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_winSpec_5),
)

df_cbm002_transfer_course = df_cbm002_transfer_course.withColumn(
    "Read_Transfer_Course",
    F.max(
        F.when(
            (
                F.col("PS_TRNS_CRSE_DTL.RQMNT_DESIGNTN").isin(
                    ["040", "060", "070", "080", "090", "098", "4094", "8098"]
                )
                & F.col("PS_TRNS_CRSE_DTL.EMPLID").isNotNull()
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_winSpec_5),
)

df_cbm002_transfer_course = df_cbm002_transfer_course.withColumn(
    "Write_Transfer_Course",
    F.max(
        F.when(
            (
                F.col("PS_TRNS_CRSE_DTL.RQMNT_DESIGNTN").isin(["010", "1091"])
                & F.col("PS_TRNS_CRSE_DTL.EMPLID").isNotNull()
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).over(_winSpec_5),
)

# COMMAND ----------

df_cbm002_transfer_course = df_cbm002_transfer_course.withColumn(
    "MathTSIWaived",
    F.when((F.col("CBM002_TSI.TSI_Oblig_Waived") == F.lit("2")), F.lit("6"))
    .when(F.col("CBM002_TSI.TSI_Oblig_Waived").isin(["4", "5", "6"]), F.lit("0"))
    .when((F.col("CBM002_TSI.MATH_TSI_PRIOR_REPORTED") == F.lit(1)), F.lit("0"))
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("ACT"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
            & (F.col("CBM002_TSI.Math_ACT") > F.lit(0))
        ),
        F.lit("J"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("ACT"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("2"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("SAT"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
            & (F.col("CBM002_TSI.MATH_SAT") > F.lit(0))
        ),
        F.lit("C"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("SAT"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
            & (F.col("CBM002_TSI.MATH_SAT") == F.lit(0))
            & (F.col("CBM002_TSI.MATH_SAT_Old") > F.lit(0))
        ),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("TAKS"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("4"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("UNDS"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("7"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("MAD"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("D"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("MIL"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("E"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("AD"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("F"),
    )
    .when(
        (
            (F.col("CBM002_TSI.EAPStudent") == F.lit("Y"))
            & (
                (F.col("CBM002_TSI.UTA_READ_STATUS") == F.lit("Y"))
                | (F.col("CBM002_TSI.UTA_WRITE_STATUS") == F.lit("Y"))
            )
        ),
        F.lit("G"),
    )
    .when(
        (F.col("CBM002_TSI.Math_TSI_TXCBMETHOD") == F.lit(1)),
        F.lit("B"),
    )
    .when(
        (
            (F.col("CBM002_TSI.Math_TSI_ACTMETHOD") == F.lit(1))
            & (F.col("CBM002_TSI.Math_ACT") > F.lit(0))
        ),
        F.lit("J"),
    )
    .when(
        (F.col("CBM002_TSI.Math_TSI_ACTMETHOD") == F.lit(1)),
        F.lit("2"),
    )
    .when(
        (F.col("CBM002_TSI.Math_TSI_SATMETHOD") == F.lit(1)),
        F.lit("C"),
    )
    .when(
        (F.col("CBM002_TSI.Math_TSI_TAKSMETHOD") == F.lit(1)),
        F.lit("4"),
    )
    .when(
        (F.col("CBM002_TSI.Math_TSI_CORBMETHOD") == F.lit(1)),
        F.lit("5"),
    )
    .otherwise(F.lit("1")),
)

# COMMAND ----------

df_cbm002_transfer_course = df_cbm002_transfer_course.withColumn(
    "ReadTSIWaived",
    F.when((F.col("CBM002_TSI.TSI_Oblig_Waived") == F.lit("2")), F.lit("6"))
    .when(F.col("CBM002_TSI.TSI_Oblig_Waived").isin(["4", "5", "6"]), F.lit("0"))
    .when((F.col("CBM002_TSI.READ_TSI_PRIOR_REPORTED") == F.lit(1)), F.lit("0"))
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("ACT"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
            & (F.col("CBM002_TSI.Read_ACT") > F.lit(0))
        ),
        F.lit("J"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("ACT"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("2"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("SAT"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
            & (F.col("CBM002_TSI.VERBAL_SAT") > F.lit(0))
        ),
        F.lit("C"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("SAT"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
            & (F.col("CBM002_TSI.VERBAL_SAT") == F.lit(0))
            & (F.col("CBM002_TSI.VERBAL_SAT_Old") > F.lit(0))
        ),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("TAKS"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("4"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("UNDS"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("7"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("MAD"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("D"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("MIL"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("E"),
    )
    .when(
        (
            (F.col("CBM002_TSI.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP") == F.lit("AD"))
            & (F.col("CBM002_TSI.STATUS_DT") <= F.col("CBM002_TSI.CENSUS_DT"))
        ),
        F.lit("F"),
    )
    .when(
        (
            (F.col("CBM002_TSI.EAPStudent") == F.lit("Y"))
            & (
                (F.col("CBM002_TSI.UTA_MATH_STATUS") == F.lit("Y"))
                | (F.col("CBM002_TSI.UTA_WRITE_STATUS") == F.lit("Y"))
            )
        ),
        F.lit("G"),
    )
    .when(
        (F.col("CBM002_TSI.Read_TSI_TXCBMETHOD") == F.lit(1)),
        F.lit("B"),
    )
    .when(
        (
            (F.col("CBM002_TSI.Read_TSI_ACTMETHOD") == F.lit(1))
            & (F.col("CBM002_TSI.Read_ACT") > F.lit(0))
        ),
        F.lit("J"),
    )
    .when(
        (F.col("CBM002_TSI.Read_TSI_ACTMETHOD") == F.lit(1)),
        F.lit("2"),
    )
    .when(
        (F.col("CBM002_TSI.Read_TSI_SATMETHOD") == F.lit(1)),
        F.lit("C"),
    )
    .when(
        (F.col("CBM002_TSI.Read_TSI_TAKSMETHOD") == F.lit(1)),
        F.lit("4"),
    )
    .when(
        (F.col("CBM002_TSI.Read_TSI_CORBMETHOD") == F.lit(1)),
        F.lit("5"),
    )
    .otherwise(F.lit("1")),
)

# COMMAND ----------

df_cbm002_transfer_course = df_cbm002_transfer_course.select(
    F.col("CBM002_TSI.ACAD_CAREER"),
    F.col("CBM002_TSI.National_Id"),
    F.col("CBM002_TSI.ACAD_PROG"),
    F.col("CBM002_TSI.CRSE_CAREER"),
    F.col("CBM002_TSI.EMPLID"),
    F.col("CBM002_TSI.INSTITUTION"),
    F.col("CBM002_TSI.STRM"),
    F.col("CBM002_TSI.TERM_BEGIN_DT"),
    F.col("CBM002_TSI.TERM_END_DT"),
    F.col("CBM002_TSI.CENSUS_DT"),
    F.col("CBM002_TSI.Current_Term_End_date"),
    F.col("CBM002_TSI.ACAD_ORG"),
    F.col("CBM002_TSI.STDNT_CAR_NBR"),
    F.col("CBM002_TSI.EFFDT"),
    F.col("CBM002_TSI.EFFSEQ"),
    F.col("CBM002_TSI.ACAD_PLAN"),
    F.col("CBM002_TSI.REQ_TERM"),
    F.col("CBM002_TSI.PLAN_TBL_EFFDT"),
    F.col("CBM002_TSI.PLAN_TBL_ACAD_PROG"),
    F.col("CBM002_TSI.ADMIT_TERM"),
    F.col("CBM002_TSI.DEGR_CHKOUT_STAT"),
    F.col("CBM002_TSI.ACAD_LEVEL_BOT"),
    F.col("CBM002_TSI.ACAD_LEVEL_EOT"),
    F.col("CBM002_TSI.ACAD_PROG_PRIMARY"),
    F.col("CBM002_TSI.TOT_CUMULATIVE"),
    F.col("CBM002_TSI.ADM_APPL_NBR"),
    F.col("CBM002_TSI.ADM_ADMIT_TERM"),
    F.col("CBM002_TSI.ADMIT_TYPE"),
    F.col("CBM002_TSI.RECRUITMENT_CAT"),
    F.col("CBM002_TSI.Current_Term"),
    F.col("CBM002_TSI.Race_White"),
    F.col("CBM002_TSI.Race_Black"),
    F.col("CBM002_TSI.Race_Asian"),
    F.col("CBM002_TSI.Race_AmIndAlsknNatv"),
    F.col("CBM002_TSI.Race_UnknwnNotRptd"),
    F.col("CBM002_TSI.Race_NatHawnOPI"),
    F.col("CBM002_TSI.ETHNIC_ORIGIN"),
    F.col("CBM002_TSI.ETHNIC_COUNT"),
    F.col("CBM002_TSI.FERPA_FLAG"),
    F.col("CBM002_TSI.GENDER"),
    F.col("CBM002_TSI.BIRTHDATE"),
    F.col("CBM002_TSI.TUITION_EXCPT"),
    F.col("CBM002_TSI.TUITION_RES"),
    F.col("CBM002_TSI.International"),
    F.col("CBM002_TSI.STATUS_DT"),
    F.col("CBM002_TSI.UTA_MATH_STATUS"),
    F.col("CBM002_TSI.UTA_READ_STATUS"),
    F.col("CBM002_TSI.UTA_TSI_EXMPT_TYP"),
    F.col("CBM002_TSI.UTA_TSI_OVERALL"),
    F.col("CBM002_TSI.UTA_WRITE_STATUS"),
    F.col("CBM002_TSI.UTA_TSI_TERM_EXMP"),
    F.col("CBM002_TSI.MathTSIEndOfTerm"),
    F.col("CBM002_TSI.ReadTSIEndOfTerm"),
    F.col("CBM002_TSI.WriteTSIEndOfTerm"),
    F.col("CBM002_TSI.MATH_TSI_STATUS"),
    F.col("CBM002_TSI.READ_TSI_STATUS"),
    F.col("CBM002_TSI.WRITE_TSI_STATUS"),
    F.col("Math_ArticulationTerm"),
    F.col("Read_ArticulationTerm"),
    F.col("Write_ArticulationTerm"),
    F.col("Math_Transfer_Course"),
    F.col("Read_Transfer_Course"),
    F.col("Write_Transfer_Course"),
    F.col("CBM002_TSI.TSI_Oblig_Waived"),
    F.col("CBM002_TSI.MATH_TSI_PRIOR_REPORTED"),
    F.col("CBM002_TSI.READ_TSI_PRIOR_REPORTED"),
    F.col("CBM002_TSI.WRITE_TSI_PRIOR_REPORTED"),
    F.col("CBM002_TSI.Math_TSI_ACTMETHOD"),
    F.col("CBM002_TSI.Read_TSI_ACTMETHOD"),
    F.col("CBM002_TSI.Write_TSI_ACTMETHOD"),
    F.col("CBM002_TSI.Math_TSI_SATMETHOD"),
    F.col("CBM002_TSI.Read_TSI_SATMETHOD"),
    F.col("CBM002_TSI.Write_TSI_SATMETHOD"),
    F.col("CBM002_TSI.Math_TSI_TAKSMETHOD"),
    F.col("CBM002_TSI.Read_TSI_TAKSMETHOD"),
    F.col("CBM002_TSI.Write_TSI_TAKSMETHOD"),
    F.col("CBM002_TSI.Math_TSI_CORBMETHOD"),
    F.col("CBM002_TSI.Read_TSI_CORBMETHOD"),
    F.col("CBM002_TSI.Write_TSI_CORBMETHOD"),
    F.col("CBM002_TSI.Math_TSI_THEAMETHOD"),
    F.col("CBM002_TSI.Read_TSI_THEAMETHOD"),
    F.col("CBM002_TSI.Write_TSI_THEAMETHOD"),
    F.col("CBM002_TSI.Math_TSI_TASPMETHOD"),
    F.col("CBM002_TSI.Read_TSI_TASPMETHOD"),
    F.col("CBM002_TSI.Write_TSI_TASPMETHOD"),
    F.col("CBM002_TSI.Math_TSI_COMPMETHOD"),
    F.col("CBM002_TSI.Read_TSI_COMPMETHOD"),
    F.col("CBM002_TSI.Write_TSI_COMPMETHOD"),
    F.col("CBM002_TSI.Math_TSI_ASSTMETHOD"),
    F.col("CBM002_TSI.Read_TSI_ASSTMETHOD"),
    F.col("CBM002_TSI.Write_TSI_ASSTMETHOD"),
    F.col("CBM002_TSI.Math_TSI_ACCUMETHOD"),
    F.col("CBM002_TSI.Read_TSI_ACCUMETHOD"),
    F.col("CBM002_TSI.Write_TSI_ACCUMETHOD"),
    F.col("CBM002_TSI.Math_TSI_STANMETHOD"),
    F.col("CBM002_TSI.Read_TSI_STANMETHOD"),
    F.col("CBM002_TSI.Write_TSI_STANMETHOD"),
    F.col("CBM002_TSI.Math_TSI_MAPSMETHOD"),
    F.col("CBM002_TSI.Read_TSI_MAPSMETHOD"),
    F.col("CBM002_TSI.Write_TSI_MAPSMETHOD"),
    F.col("CBM002_TSI.Math_TSI_TSIAMETHOD"),
    F.col("CBM002_TSI.Read_TSI_TSIAMETHOD"),
    F.col("CBM002_TSI.Write_TSI_TSIAMETHOD"),
    F.col("CBM002_TSI.Math_ACT"),
    F.col("CBM002_TSI.Read_ACT"),
    F.col("CBM002_TSI.Write_ACT"),
    F.col("CBM002_TSI.Math_Taks"),
    F.col("CBM002_TSI.MATH_SAT"),
    F.col("CBM002_TSI.VERBAL_SAT"),
    F.col("CBM002_TSI.Total_SAT"),
    F.col("CBM002_TSI.English_Composite_ACT"),
    F.col("CBM002_TSI.MATH_THEA"),
    F.col("CBM002_TSI.READ_THEA"),
    F.col("CBM002_TSI.WRITE_THEA"),
    F.col("CBM002_TSI.MATH_COMPASS"),
    F.col("CBM002_TSI.READ_COMPASS"),
    F.col("CBM002_TSI.WRITE_COMPASS"),
    F.col("CBM002_TSI.MATH_ASSET"),
    F.col("CBM002_TSI.READ_ASSET"),
    F.col("CBM002_TSI.WRITE_ASSET"),
    F.col("CBM002_TSI.MATH_ACCUPLACER"),
    F.col("CBM002_TSI.READ_ACCUPLACER"),
    F.col("CBM002_TSI.WRITE_ACCUPLACER"),
    F.col("CBM002_TSI.MATH_STANFORD"),
    F.col("CBM002_TSI.READ_STANFORD"),
    F.col("CBM002_TSI.WRITE_STANFORD"),
    F.col("CBM002_TSI.MATH_MAPS"),
    F.col("CBM002_TSI.READ_MAPS"),
    F.col("CBM002_TSI.WRITE_MAPS"),
    F.col("MathTSIWaived"),
    F.col("ReadTSIWaived"),
    F.col("CBM002_TSI.MathCoreCourseEnrolled"),
    F.col("CBM002_TSI.ReadCoreCourseEnrolled"),
    F.col("CBM002_TSI.WriteCoreCourseEnrolled"),
    F.col("CBM002_TSI.MathCoreCoursePriorEnrolled"),
    F.col("CBM002_TSI.ReadCoreCoursePriorEnrolled"),
    F.col("CBM002_TSI.WriteCoreCoursePriorEnrolled"),
    F.col("CBM002_TSI.EAPStudent"),
    F.col("CBM002_TSI.Read_Taks"),
    F.col("CBM002_TSI.Write_Taks"),
    F.col("CBM002_TSI.WRITEESSAY_COMPASS"),
    F.col("CBM002_TSI.WRITEESSAY_ACCUPLACER"),
    F.col("CBM002_TSI.WRITEESSAY_ASSET"),
    F.col("CBM002_TSI.WRITEESSAY_STANFORD"),
    F.col("CBM002_TSI.WRITEESSAY_MAPS"),
    F.col("CBM002_TSI.Flex"),
    F.col("CBM002_TSI.Year"),
    F.col("CBM002_TSI.Math_TSI_TXCBMETHOD"),
    F.col("CBM002_TSI.Read_TSI_TXCBMETHOD"),
    F.col("CBM002_TSI.Write_TSI_TXCBMETHOD"),
    F.col("CBM002_TSI.Math_TSI_TSIA2METHOD"),
    F.col("CBM002_TSI.Read_TSI_TSIA2METHOD"),
    F.col("CBM002_TSI.Write_TSI_TSIA2METHOD"),
    F.col("CBM002_TSI.MATH_TSIA"),
    F.col("CBM002_TSI.READ_TSIA"),
    F.col("CBM002_TSI.WRITE_TSIA"),
    F.col("CBM002_TSI.MATH_TSIA2"),
    F.col("CBM002_TSI.READ_TSIA2"),
    F.col("CBM002_TSI.WRITE_TSIA2"),
    F.col("CBM002_TSI.WRITEESSAY_TSIA"),
    F.col("CBM002_TSI.WRITEESSAY_TSIA2"),
    F.col("CBM002_TSI.MATH_SAT_Old"),
    F.col("CBM002_TSI.VERBAL_SAT_Old"),
    F.col("CBM002_TSI.Total_SAT_Old"),
    F.col("CBM002_TSI.MATH_TSIA2_Diagnostic"),
    F.col("CBM002_TSI.READ_TSIA2_Diagnostic"),
    F.col("CBM002_TSI.WRITE_TSIA2_Diagnostic"),
    F.col("CBM002_TSI.Math_ACT_Old"),
    F.col("CBM002_TSI.Verbal_ACT_Old"),
    F.col("CBM002_TSI.Total_ACT_Old"),
).distinct()

# COMMAND ----------

# Step: Report Logic-1
# Create temp view: CBM002_ReportLogic
df_cbm002_reportlogic = df_cbm002_transfer_course.alias("CBM002_Transfer_Course")

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "Semester_New",
    F.when(
        (F.substring(F.col("CBM002_Transfer_Course.Current_Term"), 4, 1) == F.lit("8")),
        F.lit("1"),
    )
    .when(
        (F.substring(F.col("CBM002_Transfer_Course.Current_Term"), 4, 1) == F.lit("2")),
        F.lit("2"),
    )
    .when(
        (F.substring(F.col("CBM002_Transfer_Course.Current_Term"), 4, 1) == F.lit("5")),
        F.lit("3"),
    )
    .otherwise(F.lit(" ")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "TSIMathExemptedByCensus_New",
    F.when(
        F.col("CBM002_Transfer_Course.TSI_Oblig_Waived").isin(["1", "2", "3"]),
        F.lit("0"),
    )
    .when((F.col("CBM002_Transfer_Course.MATH_TSI_STATUS") == F.lit(1)), F.lit("2"))
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") != F.lit("NONE"))
            | (F.col("CBM002_Transfer_Course.UTA_MATH_STATUS") == F.lit("Y"))
        ),
        F.lit("1"),
    )
    .otherwise(F.lit("0")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "MathScore_ACT_SAT_New",
    F.when(
        (F.col("CBM002_Transfer_Course.MathTSIWaived") == F.lit("J")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.Math_ACT").cast("BIGINT")).cast("STRING"),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_Transfer_Course.MathTSIWaived") == F.lit("2")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.Math_ACT_Old").cast("BIGINT")).cast(
                "STRING"
            ),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_Transfer_Course.MathTSIWaived") == F.lit("C")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.MATH_SAT").cast("BIGINT")).cast("STRING"),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_Transfer_Course.MathTSIWaived") == F.lit("3")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.MATH_SAT_Old").cast("BIGINT")).cast(
                "STRING"
            ),
            3,
            "0",
        ),
    )
    .otherwise(F.lit("000")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "MathCompScore_ACT_SAT_New",
    F.when(
        (F.col("CBM002_Transfer_Course.MathTSIWaived") == F.lit("2")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.Total_ACT_Old").cast("BIGINT")).cast(
                "STRING"
            ),
            4,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_Transfer_Course.MathTSIWaived") == F.lit("3")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.Total_SAT_Old").cast("BIGINT")).cast(
                "STRING"
            ),
            4,
            "0",
        ),
    )
    .otherwise(F.lit("0000")),
)

# COMMAND ----------

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "MathScore_TAKS_New",
    F.when(
        (F.col("CBM002_Transfer_Course.MathTSIWaived") == F.lit("4")),
        F.lpad(F.col("CBM002_Transfer_Course.Math_Taks").cast("STRING"), 4, "0"),
    ).otherwise(F.lit("0000")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "TSIMathAtPlacement_New",
    F.when((F.col("CBM002_Transfer_Course.MathTSIWaived") != F.lit("1")), F.lit("0"))
    .when(
        (
            (F.col("CBM002_Transfer_Course.Math_TSI_THEAMETHOD") == F.lit(1))
            | (F.col("CBM002_Transfer_Course.Math_TSI_TASPMETHOD") == F.lit(1))
        ),
        F.lit("1"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Math_TSI_COMPMETHOD") == F.lit(1)),
        F.lit("2"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Math_TSI_ASSTMETHOD") == F.lit(1)),
        F.lit("3"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Math_TSI_ACCUMETHOD") == F.lit(1)),
        F.lit("4"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Math_TSI_STANMETHOD") == F.lit(1)),
        F.lit("5"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Math_TSI_MAPSMETHOD") == F.lit(1)),
        F.lit("6"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Math_TSI_TSIA2METHOD") == F.lit(1)),
        F.lit("9"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Math_TSI_TSIAMETHOD") == F.lit(1)),
        F.lit("8"),
    )
    .otherwise(F.lit("7")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "TSIReadExemptedByCensus_New",
    F.when(
        F.col("CBM002_Transfer_Course.TSI_Oblig_Waived").isin(["1", "2", "3"]),
        F.lit("0"),
    )
    .when((F.col("CBM002_Transfer_Course.READ_TSI_STATUS") == F.lit(1)), F.lit("2"))
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") != F.lit("NONE"))
            | (F.col("CBM002_Transfer_Course.UTA_READ_STATUS") == F.lit("Y"))
        ),
        F.lit("1"),
    )
    .otherwise(F.lit("0")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "TSIWriteExemptedByCensus_New",
    F.when(
        F.col("CBM002_Transfer_Course.TSI_Oblig_Waived").isin(["1", "2", "3"]),
        F.lit("0"),
    )
    .when((F.col("CBM002_Transfer_Course.WRITE_TSI_STATUS") == F.lit(1)), F.lit("2"))
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") != F.lit("NONE"))
            | (F.col("CBM002_Transfer_Course.UTA_WRITE_STATUS") == F.lit("Y"))
        ),
        F.lit("1"),
    )
    .otherwise(F.lit("0")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "MathFirstLevelCollegeCourse_New",
    F.when(
        (F.col("CBM002_Transfer_Course.Math_Transfer_Course") == F.lit(1)), F.lit("2")
    )
    .when(
        (F.col("CBM002_Transfer_Course.MathCoreCoursePriorEnrolled") == F.lit("Y")),
        F.lit("1"),
    )
    .when(
        (
            F.col("CBM002_Transfer_Course.Math_ArticulationTerm").isNotNull()
            & (
                F.trim(F.col("CBM002_Transfer_Course.Math_ArticulationTerm"))
                != F.lit("")
            )
            & (
                F.col("CBM002_Transfer_Course.Math_ArticulationTerm")
                < F.lit(current_term)
            )
        ),
        F.lit("1"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Math_ArticulationTerm") == F.lit(current_term)),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.EAPStudent") == F.lit("Y"))
            & (F.col("CBM002_Transfer_Course.MathCoreCourseEnrolled") == F.lit("Y"))
        ),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.EAPStudent") == F.lit("N"))
            & (F.col("CBM002_Transfer_Course.MathCoreCourseEnrolled") == F.lit("Y"))
        ),
        F.lit("4"),
    )
    .otherwise(F.lit("0")),
)

# COMMAND ----------

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "WriteTSIWaived_New",
    F.when((F.col("CBM002_Transfer_Course.TSI_Oblig_Waived") == F.lit("2")), F.lit("6"))
    .when(
        F.col("CBM002_Transfer_Course.TSI_Oblig_Waived").isin(["4", "5", "6"]),
        F.lit("0"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.WRITE_TSI_PRIOR_REPORTED") == F.lit(1)),
        F.lit("0"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("ACT"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
            & (F.col("CBM002_Transfer_Course.Write_ACT") > F.lit(0))
        ),
        F.lit("J"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("ACT"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
        ),
        F.lit("2"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("SAT"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
            & (F.col("CBM002_Transfer_Course.VERBAL_SAT") > F.lit(0))
        ),
        F.lit("C"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("SAT"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
            & (F.col("CBM002_Transfer_Course.VERBAL_SAT") == F.lit(0))
            & (F.col("CBM002_Transfer_Course.VERBAL_SAT_Old") > F.lit(0))
        ),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("TAKS"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
        ),
        F.lit("4"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("UNDS"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
        ),
        F.lit("7"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("MAD"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
        ),
        F.lit("D"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("MIL"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
        ),
        F.lit("E"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.UTA_TSI_OVERALL") == F.lit("C"))
            & (F.col("CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP") == F.lit("AD"))
            & (
                F.col("CBM002_Transfer_Course.STATUS_DT")
                <= F.col("CBM002_Transfer_Course.CENSUS_DT")
            )
        ),
        F.lit("F"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.EAPStudent") == F.lit("Y"))
            & ((F.col("CBM002_Transfer_Course.UTA_WRITE_STATUS") == F.lit("Y")))
        ),
        F.lit("G"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Write_TSI_TXCBMETHOD") == F.lit(1)),
        F.lit("B"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.Write_TSI_ACTMETHOD") == F.lit(1))
            & (F.col("CBM002_Transfer_Course.Write_ACT") > F.lit(0))
        ),
        F.lit("J"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.Write_TSI_ACTMETHOD") == F.lit(1))
            & F.col("CBM002_Transfer_Course.ReadTSIWaived").isin(["1", "2"])
        ),
        F.lit("2"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.Write_TSI_SATMETHOD") == F.lit(1))
            & F.col("CBM002_Transfer_Course.ReadTSIWaived").isin(
                [
                    "1",
                    "C",
                ]
            )
        ),
        F.lit("C"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.Write_TSI_TAKSMETHOD") == F.lit(1))
            & F.col("CBM002_Transfer_Course.ReadTSIWaived").isin(
                [
                    "1",
                    "4",
                ]
            )
        ),
        F.lit("4"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.Write_TSI_CORBMETHOD") == F.lit(1))
            & F.col("CBM002_Transfer_Course.ReadTSIWaived").isin(
                [
                    "1",
                    "5",
                ]
            )
        ),
        F.lit("5"),
    )
    .otherwise(F.lit("1")),
)

# COMMAND ----------

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "ReadScore_ACT_SAT_New",
    F.when(
        (F.col("CBM002_Transfer_Course.ReadTSIWaived") == F.lit("J")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.Read_ACT").cast("BIGINT")).cast("STRING"),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_Transfer_Course.ReadTSIWaived") == F.lit("2")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.Verbal_ACT_Old").cast("BIGINT")).cast(
                "STRING"
            ),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_Transfer_Course.ReadTSIWaived") == F.lit("C")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.VERBAL_SAT").cast("BIGINT")).cast("STRING"),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_Transfer_Course.ReadTSIWaived") == F.lit("3")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.VERBAL_SAT_Old").cast("BIGINT")).cast(
                "STRING"
            ),
            3,
            "0",
        ),
    )
    .otherwise(F.lit("000")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "ReadCompScore_ACT_SAT_New",
    F.when(
        (F.col("CBM002_Transfer_Course.ReadTSIWaived") == F.lit("2")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.Total_ACT_Old").cast("BIGINT")).cast(
                "STRING"
            ),
            4,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_Transfer_Course.ReadTSIWaived") == F.lit("3")),
        F.lpad(
            (F.col("CBM002_Transfer_Course.Total_SAT_Old").cast("BIGINT")).cast(
                "STRING"
            ),
            4,
            "0",
        ),
    )
    .otherwise(F.lit("0000")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "ReadScore_TAKS_New",
    F.when(
        (F.col("CBM002_Transfer_Course.ReadTSIWaived") == F.lit("4")),
        F.lpad(F.col("CBM002_Transfer_Course.Read_Taks").cast("STRING"), 4, "0"),
    ).otherwise(F.lit("0000")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "TSIReadAtPlacement_New",
    F.when((F.col("CBM002_Transfer_Course.ReadTSIWaived") != F.lit("1")), F.lit("0"))
    .when(
        (
            (F.col("CBM002_Transfer_Course.Read_TSI_THEAMETHOD") == F.lit(1))
            | (F.col("CBM002_Transfer_Course.Read_TSI_TASPMETHOD") == F.lit(1))
        ),
        F.lit("1"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Read_TSI_COMPMETHOD") == F.lit(1)),
        F.lit("2"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Read_TSI_ASSTMETHOD") == F.lit(1)),
        F.lit("3"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Read_TSI_ACCUMETHOD") == F.lit(1)),
        F.lit("4"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Read_TSI_STANMETHOD") == F.lit(1)),
        F.lit("5"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Read_TSI_MAPSMETHOD") == F.lit(1)),
        F.lit("6"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Read_TSI_TSIA2METHOD") == F.lit(1)),
        F.lit("9"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Read_TSI_TSIAMETHOD") == F.lit(1)),
        F.lit("8"),
    )
    .otherwise(F.lit("7")),
)

# COMMAND ----------

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "ReadFirstLevelCollegeCourse_New",
    F.when(
        (F.col("CBM002_Transfer_Course.Read_Transfer_Course") == F.lit(1)), F.lit("2")
    )
    .when(
        (F.col("CBM002_Transfer_Course.ReadCoreCoursePriorEnrolled") == F.lit("Y")),
        F.lit("1"),
    )
    .when(
        (
            (
                F.col("CBM002_Transfer_Course.Read_ArticulationTerm").isNotNull()
                & (F.col("CBM002_Transfer_Course.Read_ArticulationTerm") != F.lit(""))
            )
            & (
                F.col("CBM002_Transfer_Course.Read_ArticulationTerm")
                < F.lit(current_term)
            )
        ),
        F.lit("1"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Read_ArticulationTerm") == F.lit(current_term)),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.EAPStudent") == F.lit("Y"))
            & (F.col("CBM002_Transfer_Course.ReadCoreCourseEnrolled") == F.lit("Y"))
        ),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.EAPStudent") == F.lit("N"))
            & (F.col("CBM002_Transfer_Course.ReadCoreCourseEnrolled") == F.lit("Y"))
        ),
        F.lit("4"),
    )
    .otherwise(F.lit("0")),
)

df_cbm002_reportlogic = df_cbm002_reportlogic.withColumn(
    "WriteFirstLevelCollegeCourse_New",
    F.when(
        (F.col("CBM002_Transfer_Course.Write_Transfer_Course") == F.lit(1)), F.lit("2")
    )
    .when(
        (F.col("CBM002_Transfer_Course.WriteCoreCoursePriorEnrolled") == F.lit("Y")),
        F.lit("1"),
    )
    .when(
        (
            (
                F.col("CBM002_Transfer_Course.Write_ArticulationTerm").isNotNull()
                & (F.col("CBM002_Transfer_Course.Write_ArticulationTerm") != F.lit(""))
            )
            & (
                F.col("CBM002_Transfer_Course.Write_ArticulationTerm")
                < F.lit(current_term)
            )
        ),
        F.lit("1"),
    )
    .when(
        (F.col("CBM002_Transfer_Course.Write_ArticulationTerm") == F.lit(current_term)),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.EAPStudent") == F.lit("Y"))
            & (F.col("CBM002_Transfer_Course.WriteCoreCourseEnrolled") == F.lit("Y"))
        ),
        F.lit("3"),
    )
    .when(
        (
            (F.col("CBM002_Transfer_Course.EAPStudent") == F.lit("N"))
            & (F.col("CBM002_Transfer_Course.WriteCoreCourseEnrolled") == F.lit("Y"))
        ),
        F.lit("4"),
    )
    .otherwise(F.lit("0")),
)

# COMMAND ----------

df_cbm002_reportlogic = df_cbm002_reportlogic.select(
    F.lit("2").alias("RecordCode"),
    F.lit("003656").alias("FiceCode"),
    F.col("CBM002_Transfer_Course.National_Id"),
    F.col("Semester_New").alias("Semester"),
    F.col("CBM002_Transfer_Course.Year"),
    F.col("CBM002_Transfer_Course.FERPA_FLAG").alias("Ferpa"),
    F.col("CBM002_Transfer_Course.GENDER"),
    F.col("CBM002_Transfer_Course.BIRTHDATE"),
    F.col("CBM002_Transfer_Course.TSI_Oblig_Waived").alias("TSIWaiverExemption"),
    F.col("CBM002_Transfer_Course.ETHNIC_ORIGIN"),
    F.col("CBM002_Transfer_Course.Race_White").alias("White"),
    F.col("CBM002_Transfer_Course.Race_Black").alias("Black"),
    F.col("CBM002_Transfer_Course.Race_Asian").alias("Asian"),
    F.col("CBM002_Transfer_Course.Race_AmIndAlsknNatv").alias("AmericanIndAlsknNatv"),
    F.col("CBM002_Transfer_Course.International"),
    F.col("CBM002_Transfer_Course.Race_UnknwnNotRptd").alias("UnknownNotReported"),
    F.col("CBM002_Transfer_Course.Race_NatHawnOPI").alias(
        "NativeHawnOthPacificIslander"
    ),
    F.col("CBM002_Transfer_Course.Flex"),
    F.col("TSIMathExemptedByCensus_New").alias("TSIMathExemptedByCensus"),
    F.col("CBM002_Transfer_Course.MathTSIWaived").alias("TSIMathWaiverExempted"),
    F.col("MathScore_ACT_SAT_New").alias("MathScore_ACT_SAT"),
    F.col("MathCompScore_ACT_SAT_New").alias("MathCompScore_ACT_SAT"),
    F.col("MathScore_TAKS_New").alias("MathScore_TAKS"),
    F.col("TSIMathAtPlacement_New").alias("TSIMathAtPlacement"),
    F.col("MathFirstLevelCollegeCourse_New").alias("MathFirstLevelCollegeCourse"),
    F.col("TSIReadExemptedByCensus_New").alias("TSIReadExemptedByCensus"),
    F.col("TSIWriteExemptedByCensus_New").alias("TSIWriteExemptedByCensus"),
    F.col("CBM002_Transfer_Course.ReadTSIWaived"),
    F.col("WriteTSIWaived_New").alias("WriteTSIWaived"),
    F.col("ReadScore_ACT_SAT_New").alias("ReadScore_ACT_SAT"),
    F.col("ReadCompScore_ACT_SAT_New").alias("ReadCompScore_ACT_SAT"),
    F.col("ReadScore_TAKS_New").alias("ReadScore_TAKS"),
    F.col("TSIReadAtPlacement_New").alias("TSIReadAtPlacement"),
    F.col("ReadFirstLevelCollegeCourse_New").alias("ReadFirstLevelCollegeCourse"),
    F.col("WriteFirstLevelCollegeCourse_New").alias("WriteFirstLevelCollegeCourse"),
    F.lit(None).alias("MathTSIABEDiagnosticScore"),
    F.lit(None).alias("ReadTSIABEDiagnosticScore"),
    F.lit(None).alias("WriteTSIABEDiagnosticScore"),
    F.lit("0").alias("AlternateMathMethod"),
    F.lit("0").alias("AlternateReadMethod"),
    F.lit("0").alias("AlternateWriteMethod"),
    F.col("CBM002_Transfer_Course.MATH_THEA"),
    F.col("CBM002_Transfer_Course.READ_THEA"),
    F.col("CBM002_Transfer_Course.WRITE_THEA"),
    F.col("CBM002_Transfer_Course.MATH_COMPASS"),
    F.col("CBM002_Transfer_Course.READ_COMPASS"),
    F.col("CBM002_Transfer_Course.WRITE_COMPASS"),
    F.col("CBM002_Transfer_Course.MATH_ASSET"),
    F.col("CBM002_Transfer_Course.READ_ASSET"),
    F.col("CBM002_Transfer_Course.WRITE_ASSET"),
    F.col("CBM002_Transfer_Course.MATH_ACCUPLACER"),
    F.col("CBM002_Transfer_Course.READ_ACCUPLACER"),
    F.col("CBM002_Transfer_Course.WRITE_ACCUPLACER"),
    F.col("CBM002_Transfer_Course.MATH_STANFORD"),
    F.col("CBM002_Transfer_Course.READ_STANFORD"),
    F.col("CBM002_Transfer_Course.WRITE_STANFORD"),
    F.col("CBM002_Transfer_Course.MATH_MAPS"),
    F.col("CBM002_Transfer_Course.READ_MAPS"),
    F.col("CBM002_Transfer_Course.WRITE_MAPS"),
    F.col("CBM002_Transfer_Course.MathTSIEndOfTerm"),
    F.col("CBM002_Transfer_Course.ReadTSIEndOfTerm"),
    F.col("CBM002_Transfer_Course.WriteTSIEndOfTerm"),
    F.col("CBM002_Transfer_Course.TSI_Oblig_Waived"),
    F.col("CBM002_Transfer_Course.EMPLID"),
    F.col("CBM002_Transfer_Course.Current_Term"),
    F.col("CBM002_Transfer_Course.WRITEESSAY_COMPASS"),
    F.col("CBM002_Transfer_Course.WRITEESSAY_ACCUPLACER"),
    F.col("CBM002_Transfer_Course.WRITEESSAY_ASSET"),
    F.col("CBM002_Transfer_Course.WRITEESSAY_STANFORD"),
    F.col("CBM002_Transfer_Course.WRITEESSAY_MAPS"),
    F.col("CBM002_Transfer_Course.Write_TSI_ACCUMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_ACTMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_ASSTMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_COMPMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_CORBMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_MAPSMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_SATMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_STANMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_TAKSMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_TASPMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_THEAMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_TSIAMETHOD"),
    F.col("CBM002_Transfer_Course.ACAD_PLAN"),
    F.col("CBM002_Transfer_Course.ADMIT_TERM"),
    F.col("CBM002_Transfer_Course.ACAD_LEVEL_BOT"),
    F.col("CBM002_Transfer_Course.ACAD_PROG_PRIMARY"),
    F.col("CBM002_Transfer_Course.TOT_CUMULATIVE"),
    F.col("CBM002_Transfer_Course.EAPStudent"),
    F.col("CBM002_Transfer_Course.Math_TSI_TXCBMETHOD"),
    F.col("CBM002_Transfer_Course.Read_TSI_TXCBMETHOD"),
    F.col("CBM002_Transfer_Course.Write_TSI_TXCBMETHOD"),
    F.col("CBM002_Transfer_Course.MATH_TSIA"),
    F.col("CBM002_Transfer_Course.READ_TSIA"),
    F.col("CBM002_Transfer_Course.WRITE_TSIA"),
    F.col("CBM002_Transfer_Course.MATH_TSIA2"),
    F.col("CBM002_Transfer_Course.READ_TSIA2"),
    F.col("CBM002_Transfer_Course.WRITE_TSIA2"),
    F.col("CBM002_Transfer_Course.WRITEESSAY_TSIA"),
    F.col("CBM002_Transfer_Course.WRITEESSAY_TSIA2"),
    F.col("CBM002_Transfer_Course.English_Composite_ACT"),
    F.col("CBM002_Transfer_Course.Total_SAT"),
    F.col("CBM002_Transfer_Course.Read_ACT"),
    F.col("CBM002_Transfer_Course.Write_ACT"),
    F.col("CBM002_Transfer_Course.VERBAL_SAT"),
    F.col("CBM002_Transfer_Course.Write_Taks"),
    F.col("CBM002_Transfer_Course.Write_TSI_TSIA2METHOD"),
    F.col("CBM002_Transfer_Course.MATH_SAT_Old"),
    F.col("CBM002_Transfer_Course.VERBAL_SAT_Old"),
    F.col("CBM002_Transfer_Course.Total_SAT_Old"),
    F.col("CBM002_Transfer_Course.MATH_TSIA2_Diagnostic"),
    F.col("CBM002_Transfer_Course.READ_TSIA2_Diagnostic"),
    F.col("CBM002_Transfer_Course.WRITE_TSIA2_Diagnostic"),
    F.col("CBM002_Transfer_Course.Math_ACT_Old"),
    F.col("CBM002_Transfer_Course.Verbal_ACT_Old"),
    F.col("CBM002_Transfer_Course.Total_ACT_Old"),
).distinct()

# COMMAND ----------

# Checkpoint 6: materialize df_cbm002_reportlogic to break the upstream DAG
_tmp_stageF_tbl = f"{analytics}.{staging}._tmp_cbm002_reportlogic"
write_df_to_table(
    df_cbm002_reportlogic, _tmp_stageF_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm002_reportlogic = read_table(_tmp_stageF_tbl).alias("CBM002_ReportLogic")
log_msg(f"Checkpoint 6 materialized: {_tmp_stageF_tbl}")

# COMMAND ----------

# Step: Report Logic-2
# Create temp view: CBM002_ReportingLogic2
df_cbm002_reportinglogic2 = df_cbm002_reportlogic.alias("CBM002_ReportLogic")

df_cbm002_reportinglogic2 = df_cbm002_reportinglogic2.withColumn(
    "TSIMathAssesmentScore_New",
    F.when((F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("0")), F.lit("000"))
    .when(
        (F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("1")),
        F.lpad(F.col("CBM002_ReportLogic.MATH_THEA").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("2")),
        F.lpad(F.col("CBM002_ReportLogic.MATH_COMPASS").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("3")),
        F.lpad(F.col("CBM002_ReportLogic.MATH_ASSET").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("4")),
        F.lpad(F.col("CBM002_ReportLogic.MATH_ACCUPLACER").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("5")),
        F.lpad(F.col("CBM002_ReportLogic.MATH_STANFORD").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("6")),
        F.lpad(F.col("CBM002_ReportLogic.MATH_MAPS").cast("STRING"), 3, "0"),
    )
    .when((F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("7")), F.lit("000"))
    .when(
        (F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("8")),
        F.lpad(F.col("CBM002_ReportLogic.MATH_TSIA").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIMathAtPlacement") == F.lit("9")),
        F.lpad(F.col("CBM002_ReportLogic.MATH_TSIA2").cast("STRING"), 3, "0"),
    ),
)

df_cbm002_reportinglogic2 = df_cbm002_reportinglogic2.withColumn(
    "TSIReadAssesmentScore_New",
    F.when((F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("0")), F.lit("000"))
    .when(
        (F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("1")),
        F.lpad(F.col("CBM002_ReportLogic.READ_THEA").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("2")),
        F.lpad(F.col("CBM002_ReportLogic.READ_COMPASS").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("3")),
        F.lpad(F.col("CBM002_ReportLogic.READ_ASSET").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("4")),
        F.lpad(F.col("CBM002_ReportLogic.READ_ACCUPLACER").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("5")),
        F.lpad(F.col("CBM002_ReportLogic.READ_STANFORD").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("6")),
        F.lpad(F.col("CBM002_ReportLogic.READ_MAPS").cast("STRING"), 3, "0"),
    )
    .when((F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("7")), F.lit("000"))
    .when(
        (F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("8")),
        F.lpad(F.col("CBM002_ReportLogic.READ_TSIA").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportLogic.TSIReadAtPlacement") == F.lit("9")),
        F.lpad(F.col("CBM002_ReportLogic.READ_TSIA2").cast("STRING"), 3, "0"),
    ),
)

df_cbm002_reportinglogic2 = df_cbm002_reportinglogic2.withColumn(
    "WriteScore_ACT_SAT_New",
    F.when(
        (F.col("CBM002_ReportLogic.WriteTSIWaived") == F.lit("J")),
        F.lpad(
            (F.col("CBM002_ReportLogic.Write_ACT").cast("BIGINT")).cast("STRING"),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_ReportLogic.WriteTSIWaived") == F.lit("2")),
        F.lpad(
            (F.col("CBM002_ReportLogic.Verbal_ACT_Old").cast("BIGINT")).cast("STRING"),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_ReportLogic.WriteTSIWaived") == F.lit("C")),
        F.lpad(
            (F.col("CBM002_ReportLogic.VERBAL_SAT").cast("BIGINT")).cast("STRING"),
            3,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_ReportLogic.WriteTSIWaived") == F.lit("3")),
        F.lpad(
            (F.col("CBM002_ReportLogic.VERBAL_SAT_Old").cast("BIGINT")).cast("STRING"),
            3,
            "0",
        ),
    )
    .otherwise(F.lit("000")),
)

# COMMAND ----------

df_cbm002_reportinglogic2 = df_cbm002_reportinglogic2.withColumn(
    "WriteCompScore_ACT_SAT_New",
    F.when(
        (F.col("CBM002_ReportLogic.WriteTSIWaived") == F.lit("2")),
        F.lpad(
            (F.col("CBM002_ReportLogic.Total_ACT_Old").cast("BIGINT")).cast("STRING"),
            4,
            "0",
        ),
    )
    .when(
        (F.col("CBM002_ReportLogic.WriteTSIWaived") == F.lit("3")),
        F.lpad(
            (F.col("CBM002_ReportLogic.Total_SAT_Old").cast("BIGINT")).cast("STRING"),
            4,
            "0",
        ),
    )
    .otherwise(F.lit("0000")),
)

df_cbm002_reportinglogic2 = df_cbm002_reportinglogic2.withColumn(
    "WriteScore_TAKS_New",
    F.when(
        (F.col("CBM002_ReportLogic.WriteTSIWaived") == F.lit("4")),
        F.lpad(F.col("CBM002_ReportLogic.Write_Taks").cast("STRING"), 4, "0"),
    ).otherwise(F.lit("0000")),
)

df_cbm002_reportinglogic2 = df_cbm002_reportinglogic2.withColumn(
    "TSIWriteAtPlacement_New",
    F.when((F.col("CBM002_ReportLogic.WriteTSIWaived") != F.lit("1")), F.lit("0"))
    .when(
        (
            (F.col("CBM002_ReportLogic.Write_TSI_THEAMETHOD") == F.lit(1))
            | (F.col("CBM002_ReportLogic.Write_TSI_TASPMETHOD") == F.lit(1))
        ),
        F.lit("1"),
    )
    .when(
        (F.col("CBM002_ReportLogic.Write_TSI_COMPMETHOD") == F.lit(1)),
        F.lit("2"),
    )
    .when(
        (F.col("CBM002_ReportLogic.Write_TSI_ASSTMETHOD") == F.lit(1)),
        F.lit("3"),
    )
    .when(
        (F.col("CBM002_ReportLogic.Write_TSI_ACCUMETHOD") == F.lit(1)),
        F.lit("4"),
    )
    .when(
        (F.col("CBM002_ReportLogic.Write_TSI_STANMETHOD") == F.lit(1)),
        F.lit("5"),
    )
    .when(
        (F.col("CBM002_ReportLogic.Write_TSI_MAPSMETHOD") == F.lit(1)),
        F.lit("6"),
    )
    .when(
        (F.col("CBM002_ReportLogic.Write_TSI_TSIA2METHOD") == F.lit(1)),
        F.lit("9"),
    )
    .when(
        (F.col("CBM002_ReportLogic.Write_TSI_TSIAMETHOD") == F.lit(1)),
        F.lit("8"),
    )
    .otherwise(F.lit("7")),
)

# COMMAND ----------

df_cbm002_reportinglogic2 = df_cbm002_reportinglogic2.select(
    F.col("CBM002_ReportLogic.RecordCode"),
    F.trim(F.col("CBM002_ReportLogic.Current_Term")).alias("ReportingTerm"),
    F.col("CBM002_ReportLogic.FiceCode"),
    F.col("CBM002_ReportLogic.National_Id"),
    F.col("CBM002_ReportLogic.EMPLID"),
    F.col("CBM002_ReportLogic.Semester"),
    F.col("CBM002_ReportLogic.Year"),
    F.col("CBM002_ReportLogic.Ferpa"),
    F.col("CBM002_ReportLogic.Gender"),
    F.col("CBM002_ReportLogic.BirthDate"),
    F.col("CBM002_ReportLogic.TSIWaiverExemption"),
    F.col("CBM002_ReportLogic.Ethnic_Origin"),
    F.col("CBM002_ReportLogic.White"),
    F.col("CBM002_ReportLogic.Black"),
    F.col("CBM002_ReportLogic.Asian"),
    F.col("CBM002_ReportLogic.AmericanIndAlsknNatv"),
    F.col("CBM002_ReportLogic.International"),
    F.col("CBM002_ReportLogic.UnknownNotReported"),
    F.col("CBM002_ReportLogic.NativeHawnOthPacificIslander"),
    F.col("CBM002_ReportLogic.Flex"),
    F.col("CBM002_ReportLogic.TSIMathExemptedByCensus"),
    F.col("CBM002_ReportLogic.TSIMathWaiverExempted"),
    F.col("CBM002_ReportLogic.MathScore_ACT_SAT"),
    F.col("CBM002_ReportLogic.MathCompScore_ACT_SAT"),
    F.col("CBM002_ReportLogic.MathScore_TAKS"),
    F.col("CBM002_ReportLogic.TSIMathAtPlacement"),
    F.col("TSIMathAssesmentScore_New").alias("TSIMathAssesmentScore"),
    F.col("CBM002_ReportLogic.AlternateMathMethod"),
    F.lit(None).alias("MathTSIEndOfReportPeriod"),
    F.col("CBM002_ReportLogic.MathFirstLevelCollegeCourse"),
    F.col("CBM002_ReportLogic.TSIReadExemptedByCensus"),
    F.col("CBM002_ReportLogic.ReadTSIWaived").alias("TSIReadWaiverExempted"),
    F.col("CBM002_ReportLogic.ReadScore_ACT_SAT"),
    F.col("CBM002_ReportLogic.ReadCompScore_ACT_SAT"),
    F.col("CBM002_ReportLogic.ReadScore_TAKS"),
    F.col("CBM002_ReportLogic.TSIReadAtPlacement"),
    F.col("TSIReadAssesmentScore_New").alias("TSIReadAssesmentScore"),
    F.col("CBM002_ReportLogic.AlternateReadMethod"),
    F.lit(None).alias("ReadTSIEndOfReportPeriod"),
    F.col("CBM002_ReportLogic.ReadFirstLevelCollegeCourse"),
    F.col("CBM002_ReportLogic.TSIWriteExemptedByCensus"),
    F.col("CBM002_ReportLogic.WriteTSIWaived").alias("TSIWriteWaiverExempted"),
    F.col("WriteScore_ACT_SAT_New").alias("WriteScore_ACT_SAT"),
    F.col("WriteCompScore_ACT_SAT_New").alias("WriteCompScore_ACT_SAT"),
    F.col("WriteScore_TAKS_New").alias("WriteScore_TAKS"),
    F.col("TSIWriteAtPlacement_New").alias("TSIWriteAtPlacement"),
    F.col("CBM002_ReportLogic.AlternateWriteMethod"),
    F.lit(None).alias("WriteTSIEndOfReportPeriod"),
    F.col("CBM002_ReportLogic.WriteFirstLevelCollegeCourse"),
    F.col("CBM002_ReportLogic.MathTSIABEDiagnosticScore"),
    F.col("CBM002_ReportLogic.ReadTSIABEDiagnosticScore"),
    F.col("CBM002_ReportLogic.WriteTSIABEDiagnosticScore"),
    F.col("CBM002_ReportLogic.ACAD_PLAN").alias("AcademicPlan"),
    F.col("CBM002_ReportLogic.ADMIT_TERM").alias("AdmitTerm"),
    F.col("CBM002_ReportLogic.ACAD_LEVEL_BOT").alias("AcademicLevelBOT"),
    F.col("CBM002_ReportLogic.ACAD_PROG_PRIMARY").alias("AcademicProgram"),
    F.col("CBM002_ReportLogic.TOT_CUMULATIVE").alias("TotalCumulativeHours"),
    F.col("CBM002_ReportLogic.EAPStudent"),
    F.col("CBM002_ReportLogic.Write_ACT"),
    F.col("CBM002_ReportLogic.WRITEESSAY_COMPASS"),
    F.col("CBM002_ReportLogic.WRITEESSAY_ACCUPLACER"),
    F.col("CBM002_ReportLogic.WRITEESSAY_ASSET"),
    F.col("CBM002_ReportLogic.WRITEESSAY_STANFORD"),
    F.col("CBM002_ReportLogic.WRITEESSAY_MAPS"),
    F.col("CBM002_ReportLogic.WRITEESSAY_TSIA"),
    F.col("CBM002_ReportLogic.WRITEESSAY_TSIA2"),
    F.col("CBM002_ReportLogic.WRITE_ACCUPLACER"),
    F.col("CBM002_ReportLogic.WRITE_ASSET"),
    F.col("CBM002_ReportLogic.WRITE_COMPASS"),
    F.col("CBM002_ReportLogic.WRITE_MAPS"),
    F.col("CBM002_ReportLogic.WRITE_STANFORD"),
    F.col("CBM002_ReportLogic.WRITE_THEA"),
    F.col("CBM002_ReportLogic.WRITE_TSIA"),
    F.col("CBM002_ReportLogic.WRITE_TSIA2"),
    F.col("CBM002_ReportLogic.MathTSIEndOfTerm"),
    F.col("CBM002_ReportLogic.ReadTSIEndOfTerm"),
    F.col("CBM002_ReportLogic.WriteTSIEndOfTerm"),
    F.col("CBM002_ReportLogic.MATH_TSIA2_Diagnostic"),
    F.col("CBM002_ReportLogic.READ_TSIA2_Diagnostic"),
    F.col("CBM002_ReportLogic.WRITE_TSIA2_Diagnostic"),
)

# COMMAND ----------

# Step: CBM002 Final Data
df_cbm002_final = df_cbm002_reportinglogic2.alias("CBM002_ReportingLogic2")

df_cbm002_final = df_cbm002_final.withColumn(
    "TSIWriteAssesmentScore_New",
    F.when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("0")),
        F.lit("000"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("1")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITE_THEA").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("2")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITE_COMPASS").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("3")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITE_ASSET").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("4")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITE_ACCUPLACER").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("5")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITE_STANFORD").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("6")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITE_MAPS").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("7")),
        F.lit("000"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("8")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITE_TSIA").cast("STRING"), 3, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("9")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITE_TSIA2").cast("STRING"), 3, "0"),
    ),
)

df_cbm002_final = df_cbm002_final.withColumn(
    "WriteEssayScore_New",
    F.when(
        F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement").isin(["0", "1"]), F.lit("0")
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("2")),
        F.lpad(
            F.col("CBM002_ReportingLogic2.WRITEESSAY_COMPASS").cast("STRING"), 1, "0"
        ),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("3")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITEESSAY_ASSET").cast("STRING"), 1, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("4")),
        F.lpad(
            F.col("CBM002_ReportingLogic2.WRITEESSAY_ACCUPLACER").cast("STRING"), 1, "0"
        ),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("5")),
        F.lpad(
            F.col("CBM002_ReportingLogic2.WRITEESSAY_STANFORD").cast("STRING"), 1, "0"
        ),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("6")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITEESSAY_MAPS").cast("STRING"), 1, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("7")), F.lit("0")
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("8")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITEESSAY_TSIA").cast("STRING"), 1, "0"),
    )
    .when(
        (F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement") == F.lit("9")),
        F.lpad(F.col("CBM002_ReportingLogic2.WRITEESSAY_TSIA2").cast("STRING"), 1, "0"),
    ),
)

# COMMAND ----------


def refine_col(placement_col: str, diagnostic_col: str):
    placement_cond = F.col(placement_col).cast("BIGINT")
    diagnostic_cond = F.col(diagnostic_col).cast("BIGINT")

    return (
        F.when(placement_cond.isin(F.lit(0), F.lit(7)), F.lit("0"))
        .when(
            diagnostic_cond.between(F.lit(1), F.lit(6)), diagnostic_cond.cast("string")
        )
        .otherwise(F.lit("0"))
    )


df_cbm002_final = (
    df_cbm002_final.withColumn(
        "MathTSIABEDiagnosticScore_New",
        refine_col(
            "CBM002_ReportingLogic2.TSIMathAtPlacement",
            "CBM002_ReportingLogic2.MATH_TSIA2_Diagnostic",
        ),
    )
    .withColumn(
        "ReadTSIABEDiagnosticScore_New",
        refine_col(
            "CBM002_ReportingLogic2.TSIReadAtPlacement",
            "CBM002_ReportingLogic2.READ_TSIA2_Diagnostic",
        ),
    )
    .withColumn(
        "WriteTSIABEDiagnosticScore_New",
        refine_col(
            "CBM002_ReportingLogic2.TSIWriteAtPlacement",
            "CBM002_ReportingLogic2.WRITE_TSIA2_Diagnostic",
        ),
    )
)

# COMMAND ----------

df_cbm002_final = df_cbm002_final.select(
    F.substring(F.col("CBM002_ReportingLogic2.RecordCode"), 1, 1).alias("RecordCode"),
    F.substring(F.col("CBM002_ReportingLogic2.ReportingTerm"), 1, 4).alias(
        "ReportingTerm"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.FiceCode"), 1, 6).alias("FiceCode"),
    F.substring(F.col("CBM002_ReportingLogic2.National_Id"), 1, 9).alias("National_Id"),
    F.substring(F.col("CBM002_ReportingLogic2.EMPLID"), 1, 11).alias("EMPLID"),
    F.substring(F.col("CBM002_ReportingLogic2.Semester"), 1, 1).alias("Semester"),
    F.substring(F.col("CBM002_ReportingLogic2.Year"), 1, 4).alias("Year"),
    F.substring(F.col("CBM002_ReportingLogic2.Ferpa"), 1, 1).alias("Ferpa"),
    F.substring(F.col("CBM002_ReportingLogic2.Gender"), 1, 1).alias("Gender"),
    F.col("CBM002_ReportingLogic2.BirthDate").alias("BirthDate"),
    F.substring(F.col("CBM002_ReportingLogic2.TSIWaiverExemption"), 1, 1).alias(
        "TSIWaiverExemption"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.Ethnic_Origin"), 1, 1).alias(
        "Ethnic_Origin"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.White"), 1, 1).alias("White"),
    F.substring(F.col("CBM002_ReportingLogic2.Black"), 1, 1).alias("Black"),
    F.substring(F.col("CBM002_ReportingLogic2.Asian"), 1, 1).alias("Asian"),
    F.substring(F.col("CBM002_ReportingLogic2.AmericanIndAlsknNatv"), 1, 1).alias(
        "AmericanIndAlsknNatv"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.International"), 1, 1).alias(
        "International"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.UnknownNotReported"), 1, 1).alias(
        "UnknownNotReported"
    ),
    F.substring(
        F.col("CBM002_ReportingLogic2.NativeHawnOthPacificIslander"), 1, 1
    ).alias("NativeHawnOthPacificIslander"),
    F.substring(F.col("CBM002_ReportingLogic2.Flex"), 1, 1).alias("Flex"),
    F.substring(F.col("CBM002_ReportingLogic2.TSIMathExemptedByCensus"), 1, 1).alias(
        "TSIMathExemptedByCensus"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.TSIMathWaiverExempted"), 1, 1).alias(
        "TSIMathWaiverExempted"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.MathScore_ACT_SAT"), 1, 3).alias(
        "MathScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.MathCompScore_ACT_SAT"), 1, 4).alias(
        "MathCompScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.MathScore_TAKS"), 1, 4).alias(
        "MathScore_TAKS"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.TSIMathAtPlacement"), 1, 1).alias(
        "TSIMathAtPlacement"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.TSIMathAssesmentScore"), 1, 3).alias(
        "TSIMathAssesmentScore"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.AlternateMathMethod"), 1, 1).alias(
        "AlternateMathMethod"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.MathTSIEndOfReportPeriod"), 1, 1).alias(
        "MathTSIEndOfReportPeriod"
    ),
    F.substring(
        F.col("CBM002_ReportingLogic2.MathFirstLevelCollegeCourse"), 1, 1
    ).alias("MathFirstLevelCollegeCourse"),
    F.substring(F.col("CBM002_ReportingLogic2.TSIReadExemptedByCensus"), 1, 1).alias(
        "TSIReadExemptedByCensus"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.TSIReadWaiverExempted"), 1, 1).alias(
        "TSIReadWaiverExempted"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.ReadScore_ACT_SAT"), 1, 3).alias(
        "ReadScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.ReadCompScore_ACT_SAT"), 1, 4).alias(
        "ReadCompScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.ReadScore_TAKS"), 1, 4).alias(
        "ReadScore_TAKS"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.TSIReadAtPlacement"), 1, 1).alias(
        "TSIReadAtPlacement"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.TSIReadAssesmentScore"), 1, 3).alias(
        "TSIReadAssesmentScore"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.AlternateReadMethod"), 1, 1).alias(
        "AlternateReadMethod"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.ReadTSIEndOfReportPeriod"), 1, 1).alias(
        "ReadTSIEndOfReportPeriod"
    ),
    F.substring(
        F.col("CBM002_ReportingLogic2.ReadFirstLevelCollegeCourse"), 1, 1
    ).alias("ReadFirstLevelCollegeCourse"),
    F.substring(F.col("CBM002_ReportingLogic2.TSIWriteExemptedByCensus"), 1, 1).alias(
        "TSIWriteExemptedByCensus"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.TSIWriteWaiverExempted"), 1, 1).alias(
        "TSIWriteWaiverExempted"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.WriteScore_ACT_SAT"), 1, 3).alias(
        "WriteScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.WriteCompScore_ACT_SAT"), 1, 4).alias(
        "WriteCompScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.WriteScore_TAKS"), 1, 4).alias(
        "WriteScore_TAKS"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.TSIWriteAtPlacement"), 1, 1).alias(
        "TSIWriteAtPlacement"
    ),
    F.substring(F.col("TSIWriteAssesmentScore_New"), 1, 3).alias(
        "TSIWriteAssesmentScore"
    ),
    F.substring(F.col("WriteEssayScore_New"), 1, 1).alias("WriteEssayScore"),
    F.substring(F.col("CBM002_ReportingLogic2.AlternateWriteMethod"), 1, 1).alias(
        "AlternateWriteMethod"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.WriteTSIEndOfReportPeriod"), 1, 1).alias(
        "WriteTSIEndOfReportPeriod"
    ),
    F.substring(
        F.col("CBM002_ReportingLogic2.WriteFirstLevelCollegeCourse"), 1, 1
    ).alias("WriteFirstLevelCollegeCourse"),
    F.substring(F.col("MathTSIABEDiagnosticScore_New"), 1, 1).alias(
        "MathTSIABEDiagnosticScore"
    ),
    F.substring(F.col("ReadTSIABEDiagnosticScore_New"), 1, 1).alias(
        "ReadTSIABEDiagnosticScore"
    ),
    F.substring(F.col("WriteTSIABEDiagnosticScore_New"), 1, 1).alias(
        "WriteTSIABEDiagnosticScore"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.AcademicPlan"), 1, 10).alias(
        "AcademicPlan"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.AdmitTerm"), 1, 4).alias("AdmitTerm"),
    F.substring(F.col("CBM002_ReportingLogic2.AcademicLevelBOT"), 1, 3).alias(
        "AcademicLevelBOT"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.AcademicProgram"), 1, 5).alias(
        "AcademicProgram"
    ),
    F.col("CBM002_ReportingLogic2.TotalCumulativeHours")
    .cast("decimal(10,3)")
    .alias("TotalCumulativeHours"),
    F.substring(F.col("CBM002_ReportingLogic2.EAPStudent"), 1, 1).alias("EAPStudent"),
    F.substring(F.col("CBM002_ReportingLogic2.MathTSIEndOfTerm"), 1, 1).alias(
        "MathTSIEndOfTerm"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.ReadTSIEndOfTerm"), 1, 1).alias(
        "ReadTSIEndOfTerm"
    ),
    F.substring(F.col("CBM002_ReportingLogic2.WriteTSIEndOfTerm"), 1, 1).alias(
        "WriteTSIEndOfTerm"
    ),
)

# COMMAND ----------

df_cbm002_census_final = df_cbm002_final.select(
    F.col("RecordCode"),
    F.col("ReportingTerm"),
    F.col("FiceCode"),
    F.col("National_Id"),
    F.col("EMPLID"),
    F.col("Semester"),
    F.col("Year"),
    F.col("Ferpa"),
    F.col("Gender"),
    F.col("BirthDate"),
    F.col("TSIWaiverExemption"),
    F.col("Ethnic_Origin"),
    F.col("White"),
    F.col("Black"),
    F.col("Asian"),
    F.col("AmericanIndAlsknNatv"),
    F.col("International"),
    F.col("UnknownNotReported"),
    F.col("NativeHawnOthPacificIslander"),
    F.col("Flex"),
    F.col("TSIMathExemptedByCensus"),
    F.col("TSIMathWaiverExempted"),
    F.col("MathScore_ACT_SAT"),
    F.col("MathCompScore_ACT_SAT"),
    F.col("MathScore_TAKS"),
    F.col("TSIMathAtPlacement"),
    F.col("TSIMathAssesmentScore"),
    F.col("AlternateMathMethod"),
    F.col("MathTSIEndOfReportPeriod"),
    F.col("MathFirstLevelCollegeCourse"),
    F.col("TSIReadExemptedByCensus"),
    F.col("TSIReadWaiverExempted"),
    F.col("ReadScore_ACT_SAT"),
    F.col("ReadCompScore_ACT_SAT"),
    F.col("ReadScore_TAKS"),
    F.col("TSIReadAtPlacement"),
    F.col("TSIReadAssesmentScore"),
    F.col("AlternateReadMethod"),
    F.col("ReadTSIEndOfReportPeriod"),
    F.col("ReadFirstLevelCollegeCourse"),
    F.col("TSIWriteExemptedByCensus"),
    F.col("TSIWriteWaiverExempted"),
    F.col("WriteScore_ACT_SAT"),
    F.col("WriteCompScore_ACT_SAT"),
    F.col("WriteScore_TAKS"),
    F.col("TSIWriteAtPlacement"),
    F.col("TSIWriteAssesmentScore"),
    F.col("WriteEssayScore"),
    F.col("AlternateWriteMethod"),
    F.col("WriteTSIEndOfReportPeriod"),
    F.col("WriteFirstLevelCollegeCourse"),
    F.col("MathTSIABEDiagnosticScore"),
    F.col("ReadTSIABEDiagnosticScore"),
    F.col("WriteTSIABEDiagnosticScore"),
    F.col("AcademicPlan"),
    F.col("AdmitTerm"),
    F.col("AcademicLevelBOT"),
    F.col("AcademicProgram"),
    F.col("TotalCumulativeHours"),
    F.col("EAPStudent"),
)

# COMMAND ----------

# Write fact_thecb_cbm002_census
# Output: fact_thecb_cbm002_census → analytics.staging  (from Release3 output_table_map)

if (
    spark.catalog.tableExists(f"{analytics}.{staging}.fact_thecb_cbm002_census")
    == False
):
    write_df_to_table(
        df_cbm002_census_final,
        f"{analytics}.{staging}.fact_thecb_cbm002_census",
        mode="overwrite",
    )
else:
    existing_records = read_table(f"{analytics}.{staging}.fact_thecb_cbm002_census")
    remaining_records = existing_records.filter(f"ReportingTerm != {current_term}")

    final_df_records = remaining_records.unionByName(df_cbm002_census_final)

    write_df_to_table(
        final_df_records,
        f"{analytics}.{staging}.fact_thecb_cbm002_census",
        mode="overwrite",
    )

log_msg(f"fact_thecb_cbm002_census written — row count: {get_count(df_cbm002_final)}")

# COMMAND ----------

# Step: Replacing Census Day Data
# Create temp view: CBM002_Census_info
adw_cbm002_census = read_table(f"{analytics}.{staging}.fact_thecb_cbm002_census").alias(
    "ADW_CBM002_CENSUS"
)

df_cbm002_census_info = df_cbm002_final.alias("CBM002_Final")
df_cbm002_census_info = df_cbm002_census_info.join(
    adw_cbm002_census,
    on=(
        (F.col("CBM002_Final.EMPLID") == F.col("ADW_CBM002_CENSUS.EMPLID"))
        & (F.col("CBM002_Final.Semester") == F.col("ADW_CBM002_CENSUS.Semester"))
        & (F.col("CBM002_Final.Year") == F.col("ADW_CBM002_CENSUS.Year"))
    ),
    how="left",
)

df_cbm002_census_info = df_cbm002_census_info.withColumn(
    "TSIMathExemptedByCensus_New",
    F.when(
        (
            F.col("ADW_CBM002_CENSUS.TSIMathExemptedByCensus").isNull()
            | (F.col("ADW_CBM002_CENSUS.TSIMathExemptedByCensus") == F.lit(""))
        ),
        F.col("CBM002_Final.TSIMathExemptedByCensus"),
    ).otherwise(F.col("ADW_CBM002_CENSUS.TSIMathExemptedByCensus")),
)

df_cbm002_census_info = df_cbm002_census_info.withColumn(
    "TSIReadExemptedByCensus_New",
    F.when(
        (
            F.col("ADW_CBM002_CENSUS.TSIReadExemptedByCensus").isNull()
            | (F.col("ADW_CBM002_CENSUS.TSIReadExemptedByCensus") == F.lit(""))
        ),
        F.col("CBM002_Final.TSIReadExemptedByCensus"),
    ).otherwise(F.col("ADW_CBM002_CENSUS.TSIReadExemptedByCensus")),
)

df_cbm002_census_info = df_cbm002_census_info.withColumn(
    "TSIWriteExemptedByCensus_New",
    F.when(
        (
            F.col("ADW_CBM002_CENSUS.TSIWriteExemptedByCensus").isNull()
            | (F.col("ADW_CBM002_CENSUS.TSIWriteExemptedByCensus") == F.lit(""))
        ),
        F.col("CBM002_Final.TSIWriteExemptedByCensus"),
    ).otherwise(F.col("ADW_CBM002_CENSUS.TSIWriteExemptedByCensus")),
)

# COMMAND ----------

df_cbm002_census_info = df_cbm002_census_info.select(
    F.col("CBM002_Final.RecordCode"),
    F.col("CBM002_Final.ReportingTerm"),
    F.col("CBM002_Final.FiceCode"),
    F.col("CBM002_Final.National_Id"),
    F.col("CBM002_Final.EMPLID"),
    F.col("CBM002_Final.Semester"),
    F.col("CBM002_Final.Year"),
    F.col("CBM002_Final.Ferpa"),
    F.col("CBM002_Final.Gender"),
    F.col("CBM002_Final.BirthDate"),
    F.col("CBM002_Final.TSIWaiverExemption"),
    F.col("CBM002_Final.Ethnic_Origin"),
    F.col("CBM002_Final.White"),
    F.col("CBM002_Final.Black"),
    F.col("CBM002_Final.Asian"),
    F.col("CBM002_Final.AmericanIndAlsknNatv"),
    F.col("CBM002_Final.International"),
    F.col("CBM002_Final.UnknownNotReported"),
    F.col("CBM002_Final.NativeHawnOthPacificIslander"),
    F.col("CBM002_Final.Flex"),
    F.col("TSIMathExemptedByCensus_New").alias("TSIMathExemptedByCensus"),
    F.col("CBM002_Final.TSIMathWaiverExempted"),
    F.col("CBM002_Final.MathScore_ACT_SAT"),
    F.col("CBM002_Final.MathCompScore_ACT_SAT"),
    F.col("CBM002_Final.MathScore_TAKS"),
    F.col("CBM002_Final.TSIMathAtPlacement"),
    F.col("CBM002_Final.TSIMathAssesmentScore"),
    F.col("CBM002_Final.AlternateMathMethod"),
    F.col("CBM002_Final.MathTSIEndOfReportPeriod"),
    F.col("CBM002_Final.MathFirstLevelCollegeCourse"),
    F.col("TSIReadExemptedByCensus_New").alias("TSIReadExemptedByCensus"),
    F.col("CBM002_Final.TSIReadWaiverExempted"),
    F.col("CBM002_Final.ReadScore_ACT_SAT"),
    F.col("CBM002_Final.ReadCompScore_ACT_SAT"),
    F.col("CBM002_Final.ReadScore_TAKS"),
    F.col("CBM002_Final.TSIReadAtPlacement"),
    F.col("CBM002_Final.TSIReadAssesmentScore"),
    F.col("CBM002_Final.AlternateReadMethod"),
    F.col("CBM002_Final.ReadTSIEndOfReportPeriod"),
    F.col("CBM002_Final.ReadFirstLevelCollegeCourse"),
    F.col("TSIWriteExemptedByCensus_New").alias("TSIWriteExemptedByCensus"),
    F.col("CBM002_Final.TSIWriteWaiverExempted"),
    F.col("CBM002_Final.WriteScore_ACT_SAT"),
    F.col("CBM002_Final.WriteCompScore_ACT_SAT"),
    F.col("CBM002_Final.WriteScore_TAKS"),
    F.col("CBM002_Final.TSIWriteAtPlacement"),
    F.col("CBM002_Final.TSIWriteAssesmentScore"),
    F.col("CBM002_Final.WriteEssayScore"),
    F.col("CBM002_Final.AlternateWriteMethod"),
    F.col("CBM002_Final.WriteTSIEndOfReportPeriod"),
    F.col("CBM002_Final.WriteFirstLevelCollegeCourse"),
    F.col("CBM002_Final.MathTSIABEDiagnosticScore"),
    F.col("CBM002_Final.ReadTSIABEDiagnosticScore"),
    F.col("CBM002_Final.WriteTSIABEDiagnosticScore"),
    F.col("CBM002_Final.AcademicPlan"),
    F.col("CBM002_Final.AdmitTerm"),
    F.col("CBM002_Final.AcademicLevelBOT"),
    F.col("CBM002_Final.AcademicProgram"),
    F.col("CBM002_Final.TotalCumulativeHours"),
    F.col("CBM002_Final.EAPStudent"),
    F.col("CBM002_Final.MathTSIEndOfTerm"),
    F.col("CBM002_Final.ReadTSIEndOfTerm"),
    F.col("CBM002_Final.WriteTSIEndOfTerm"),
)

# COMMAND ----------

# Create temp view: cbm002_work_tbl
df_cbm002_work_tbl = df_cbm002_census_info.alias("CBM002_Census_info")

df_cbm002_work_tbl = df_cbm002_work_tbl.withColumn(
    "MathTSIEndOfReportPeriod_New",
    F.when(
        F.col("CBM002_Census_info.TSIWaiverExemption").isin(["1", "2", "3"]), F.lit("0")
    )
    .when(
        F.col("CBM002_Census_info.TSIMathExemptedByCensus").isin(["1", "2"]),
        F.lit("2"),
    )
    .when((F.col("CBM002_Census_info.MathTSIEndOfTerm") == F.lit(1)), F.lit("1"))
    .otherwise(F.lit("0")),
)

df_cbm002_work_tbl = df_cbm002_work_tbl.withColumn(
    "ReadTSIEndOfReportPeriod_New",
    F.when(
        F.col("CBM002_Census_info.TSIWaiverExemption").isin(["1", "2", "3"]), F.lit("0")
    )
    .when(
        F.col("CBM002_Census_info.TSIReadExemptedByCensus").isin(["1", "2"]),
        F.lit("2"),
    )
    .when((F.col("CBM002_Census_info.ReadTSIEndOfTerm") == F.lit(1)), F.lit("1"))
    .otherwise(F.lit("0")),
)

df_cbm002_work_tbl = df_cbm002_work_tbl.withColumn(
    "WriteTSIEndOfReportPeriod_New",
    F.when(
        F.col("CBM002_Census_info.TSIWaiverExemption").isin(["1", "2", "3"]), F.lit("0")
    )
    .when(
        F.col("CBM002_Census_info.TSIWriteExemptedByCensus").isin(["1", "2"]),
        F.lit("2"),
    )
    .when((F.col("CBM002_Census_info.WriteTSIEndOfTerm") == F.lit(1)), F.lit("1"))
    .otherwise(F.lit("0")),
)

# COMMAND ----------

df_cbm002_work_tbl = df_cbm002_work_tbl.select(
    F.substring(F.col("CBM002_Census_info.RecordCode"), 1, 1).alias("RecordCode"),
    F.substring(F.col("CBM002_Census_info.ReportingTerm"), 1, 4).alias("ReportingTerm"),
    F.substring(F.col("CBM002_Census_info.FiceCode"), 1, 6).alias("FiceCode"),
    F.substring(F.col("CBM002_Census_info.National_Id"), 1, 9).alias("National_Id"),
    F.substring(F.col("CBM002_Census_info.EMPLID"), 1, 11).alias("EMPLID"),
    F.substring(F.col("CBM002_Census_info.Semester"), 1, 1).alias("Semester"),
    F.substring(F.col("CBM002_Census_info.Year"), 1, 4).alias("Year"),
    F.substring(F.col("CBM002_Census_info.Ferpa"), 1, 1).alias("Ferpa"),
    F.substring(F.col("CBM002_Census_info.Gender"), 1, 1).alias("Gender"),
    F.col("CBM002_Census_info.BirthDate").alias("BirthDate"),
    F.substring(F.col("CBM002_Census_info.TSIWaiverExemption"), 1, 1).alias(
        "TSIWaiverExemption"
    ),
    F.substring(F.col("CBM002_Census_info.Ethnic_Origin"), 1, 1).alias("Ethnic_Origin"),
    F.substring(F.col("CBM002_Census_info.White"), 1, 1).alias("White"),
    F.substring(F.col("CBM002_Census_info.Black"), 1, 1).alias("Black"),
    F.substring(F.col("CBM002_Census_info.Asian"), 1, 1).alias("Asian"),
    F.substring(F.col("CBM002_Census_info.AmericanIndAlsknNatv"), 1, 1).alias(
        "AmericanIndAlsknNatv"
    ),
    F.substring(F.col("CBM002_Census_info.International"), 1, 1).alias("International"),
    F.substring(F.col("CBM002_Census_info.UnknownNotReported"), 1, 1).alias(
        "UnknownNotReported"
    ),
    F.substring(F.col("CBM002_Census_info.NativeHawnOthPacificIslander"), 1, 1).alias(
        "NativeHawnOthPacificIslander"
    ),
    F.substring(F.col("CBM002_Census_info.Flex"), 1, 1).alias("Flex"),
    F.substring(F.col("CBM002_Census_info.TSIMathExemptedByCensus"), 1, 1).alias(
        "TSIMathExemptedByCensus"
    ),
    F.substring(F.col("CBM002_Census_info.TSIMathWaiverExempted"), 1, 1).alias(
        "TSIMathWaiverExempted"
    ),
    F.substring(F.col("CBM002_Census_info.MathScore_ACT_SAT"), 1, 3).alias(
        "MathScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_Census_info.MathCompScore_ACT_SAT"), 1, 4).alias(
        "MathCompScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_Census_info.MathScore_TAKS"), 1, 4).alias(
        "MathScore_TAKS"
    ),
    F.substring(F.col("CBM002_Census_info.TSIMathAtPlacement"), 1, 1).alias(
        "TSIMathAtPlacement"
    ),
    F.substring(F.col("CBM002_Census_info.TSIMathAssesmentScore"), 1, 3).alias(
        "TSIMathAssesmentScore"
    ),
    F.substring(F.col("CBM002_Census_info.AlternateMathMethod"), 1, 1).alias(
        "AlternateMathMethod"
    ),
    F.col("MathTSIEndOfReportPeriod_New").alias("MathTSIEndOfReportPeriod"),
    F.substring(F.col("CBM002_Census_info.MathFirstLevelCollegeCourse"), 1, 1).alias(
        "MathFirstLevelCollegeCourse"
    ),
    F.substring(F.col("CBM002_Census_info.TSIReadExemptedByCensus"), 1, 1).alias(
        "TSIReadExemptedByCensus"
    ),
    F.substring(F.col("CBM002_Census_info.TSIReadWaiverExempted"), 1, 1).alias(
        "TSIReadWaiverExempted"
    ),
    F.substring(F.col("CBM002_Census_info.ReadScore_ACT_SAT"), 1, 3).alias(
        "ReadScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_Census_info.ReadCompScore_ACT_SAT"), 1, 4).alias(
        "ReadCompScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_Census_info.ReadScore_TAKS"), 1, 4).alias(
        "ReadScore_TAKS"
    ),
    F.substring(F.col("CBM002_Census_info.TSIReadAtPlacement"), 1, 1).alias(
        "TSIReadAtPlacement"
    ),
    F.substring(F.col("CBM002_Census_info.TSIReadAssesmentScore"), 1, 3).alias(
        "TSIReadAssesmentScore"
    ),
    F.substring(F.col("CBM002_Census_info.AlternateReadMethod"), 1, 1).alias(
        "AlternateReadMethod"
    ),
    F.col("ReadTSIEndOfReportPeriod_New").alias("ReadTSIEndOfReportPeriod"),
    F.substring(F.col("CBM002_Census_info.ReadFirstLevelCollegeCourse"), 1, 1).alias(
        "ReadFirstLevelCollegeCourse"
    ),
    F.substring(F.col("CBM002_Census_info.TSIWriteExemptedByCensus"), 1, 1).alias(
        "TSIWriteExemptedByCensus"
    ),
    F.substring(F.col("CBM002_Census_info.TSIWriteWaiverExempted"), 1, 1).alias(
        "TSIWriteWaiverExempted"
    ),
    F.substring(F.col("CBM002_Census_info.WriteScore_ACT_SAT"), 1, 3).alias(
        "WriteScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_Census_info.WriteCompScore_ACT_SAT"), 1, 4).alias(
        "WriteCompScore_ACT_SAT"
    ),
    F.substring(F.col("CBM002_Census_info.WriteScore_TAKS"), 1, 4).alias(
        "WriteScore_TAKS"
    ),
    F.substring(F.col("CBM002_Census_info.TSIWriteAtPlacement"), 1, 1).alias(
        "TSIWriteAtPlacement"
    ),
    F.substring(F.col("CBM002_Census_info.TSIWriteAssesmentScore"), 1, 3).alias(
        "TSIWriteAssesmentScore"
    ),
    F.substring(F.col("CBM002_Census_info.WriteEssayScore"), 1, 1).alias(
        "WriteEssayScore"
    ),
    F.substring(F.col("CBM002_Census_info.AlternateWriteMethod"), 1, 1).alias(
        "AlternateWriteMethod"
    ),
    F.col("WriteTSIEndOfReportPeriod_New").alias("WriteTSIEndOfReportPeriod"),
    F.substring(F.col("CBM002_Census_info.WriteFirstLevelCollegeCourse"), 1, 1).alias(
        "WriteFirstLevelCollegeCourse"
    ),
    F.substring(F.col("CBM002_Census_info.MathTSIABEDiagnosticScore"), 1, 1).alias(
        "MathTSIABEDiagnosticScore"
    ),
    F.substring(F.col("CBM002_Census_info.ReadTSIABEDiagnosticScore"), 1, 1).alias(
        "ReadTSIABEDiagnosticScore"
    ),
    F.substring(F.col("CBM002_Census_info.WriteTSIABEDiagnosticScore"), 1, 1).alias(
        "WriteTSIABEDiagnosticScore"
    ),
    F.substring(F.col("CBM002_Census_info.AcademicPlan"), 1, 10).alias("AcademicPlan"),
    F.substring(F.col("CBM002_Census_info.AdmitTerm"), 1, 4).alias("AdmitTerm"),
    F.substring(F.col("CBM002_Census_info.AcademicLevelBOT"), 1, 3).alias(
        "AcademicLevelBOT"
    ),
    F.substring(F.col("CBM002_Census_info.AcademicProgram"), 1, 5).alias(
        "AcademicProgram"
    ),
    F.col("CBM002_Census_info.TotalCumulativeHours")
    .cast("decimal(10,3)")
    .alias("TotalCumulativeHours"),
    F.substring(F.col("CBM002_Census_info.EAPStudent"), 1, 1).alias("EAPStudent"),
)

# COMMAND ----------

# Write fact_thecb_cbm002_work
# Output: fact_thecb_cbm002_work → analytics.staging  (from Release3 output_table_map)

write_df_to_table(
    df_cbm002_work_tbl,
    f"{analytics}.{staging}.fact_thecb_cbm002_work",
    mode="overwrite",
)

log_msg(f"fact_thecb_cbm002_work written — row count: {get_count(df_cbm002_work_tbl)}")

# COMMAND ----------

# Step: CB Reported
df_cbm002_cbreported_final = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm002_work"
).alias("ADW_CBM002_WORK")

df_cbm002_cbreported_final = df_cbm002_cbreported_final.select(
    F.col("ADW_CBM002_WORK.RecordCode"),
    F.col("ADW_CBM002_WORK.FiceCode"),
    F.col("ADW_CBM002_WORK.National_Id"),
    F.col("ADW_CBM002_WORK.Semester"),
    F.col("ADW_CBM002_WORK.Year"),
    F.col("ADW_CBM002_WORK.Ferpa"),
    F.col("ADW_CBM002_WORK.Gender"),
    F.lit("").alias("Unused"),
    F.col("ADW_CBM002_WORK.BirthDate"),
    F.col("ADW_CBM002_WORK.TSIWaiverExemption"),
    F.col("ADW_CBM002_WORK.Ethnic_Origin"),
    F.col("ADW_CBM002_WORK.White"),
    F.col("ADW_CBM002_WORK.Black"),
    F.col("ADW_CBM002_WORK.Asian"),
    F.col("ADW_CBM002_WORK.AmericanIndAlsknNatv"),
    F.col("ADW_CBM002_WORK.International"),
    F.col("ADW_CBM002_WORK.UnknownNotReported"),
    F.col("ADW_CBM002_WORK.NativeHawnOthPacificIslander"),
    F.col("ADW_CBM002_WORK.Flex"),
    F.lit("").alias("Unused2"),
    F.col("ADW_CBM002_WORK.TSIMathExemptedByCensus"),
    F.col("ADW_CBM002_WORK.TSIMathWaiverExempted"),
    F.col("ADW_CBM002_WORK.MathScore_ACT_SAT"),
    F.col("ADW_CBM002_WORK.MathCompScore_ACT_SAT"),
    F.col("ADW_CBM002_WORK.MathScore_TAKS"),
    F.col("ADW_CBM002_WORK.TSIMathAtPlacement"),
    F.col("ADW_CBM002_WORK.TSIMathAssesmentScore"),
    F.col("ADW_CBM002_WORK.AlternateMathMethod"),
    F.col("ADW_CBM002_WORK.MathTSIEndOfReportPeriod"),
    F.col("ADW_CBM002_WORK.MathFirstLevelCollegeCourse"),
    F.col("ADW_CBM002_WORK.TSIReadExemptedByCensus"),
    F.col("ADW_CBM002_WORK.TSIReadWaiverExempted"),
    F.col("ADW_CBM002_WORK.ReadScore_ACT_SAT"),
    F.col("ADW_CBM002_WORK.ReadCompScore_ACT_SAT"),
    F.col("ADW_CBM002_WORK.ReadScore_TAKS"),
    F.col("ADW_CBM002_WORK.TSIReadAtPlacement"),
    F.col("ADW_CBM002_WORK.TSIReadAssesmentScore"),
    F.col("ADW_CBM002_WORK.AlternateReadMethod"),
    F.col("ADW_CBM002_WORK.ReadTSIEndOfReportPeriod"),
    F.col("ADW_CBM002_WORK.ReadFirstLevelCollegeCourse"),
    F.col("ADW_CBM002_WORK.TSIWriteExemptedByCensus"),
    F.col("ADW_CBM002_WORK.TSIWriteWaiverExempted"),
    F.col("ADW_CBM002_WORK.WriteScore_ACT_SAT"),
    F.col("ADW_CBM002_WORK.WriteCompScore_ACT_SAT"),
    F.col("ADW_CBM002_WORK.WriteScore_TAKS"),
    F.col("ADW_CBM002_WORK.TSIWriteAtPlacement"),
    F.col("ADW_CBM002_WORK.TSIWriteAssesmentScore"),
    F.col("ADW_CBM002_WORK.WriteEssayScore"),
    F.col("ADW_CBM002_WORK.AlternateWriteMethod"),
    F.col("ADW_CBM002_WORK.WriteTSIEndOfReportPeriod"),
    F.col("ADW_CBM002_WORK.WriteFirstLevelCollegeCourse"),
    F.col("ADW_CBM002_WORK.MathTSIABEDiagnosticScore"),
    F.col("ADW_CBM002_WORK.ReadTSIABEDiagnosticScore"),
    F.col("ADW_CBM002_WORK.WriteTSIABEDiagnosticScore"),
).distinct()

# COMMAND ----------

# Output File Path
output_path = f"{student_ext_output_path}"


# Helper: fixed-width character field (left-justified, space-padded, truncated to width)
def fmt_char(col_name, width):
    return F.rpad(
        F.substring(F.coalesce(F.col(col_name).cast("string"), F.lit("")), 1, width),
        width,
        " ",
    )


# Helper: zero-filled numeric field
def fmt_zero_fill(col_name, width):
    return F.lpad(
        F.coalesce(F.col(col_name).cast("long").cast("string"), F.lit("0")), width, "0"
    )


# COMMAND ----------

df_fixed_width = df_cbm002_cbreported_final.withColumn(
    "fixed_width_line",
    F.concat(
        fmt_char("RecordCode", 1),  # @1
        fmt_char("FiceCode", 6),  # @2
        fmt_char("National_Id", 9),  # @8
        fmt_char("Semester", 1),  # @17
        fmt_char("Year", 4),  # @18
        fmt_char("Ferpa", 1),  # @22
        fmt_char("Gender", 1),  # @23
        fmt_char("Unused", 1),  # @24
        fmt_char("BirthDate", 8),  # @25
        fmt_char("TSIWaiverExemption", 1),  # @33
        fmt_char("Ethnic_Origin", 1),  # @34
        fmt_char("White", 1),  # @35
        fmt_char("Black", 1),  # @36
        fmt_char("Asian", 1),  # @37
        fmt_char("AmericanIndAlsknNatv", 1),  # @38
        fmt_char("International", 1),  # @39
        fmt_char("UnknownNotReported", 1),  # @40
        fmt_char("NativeHawnOthPacificIslander", 1),  # @41
        fmt_char("Flex", 1),  # @42
        fmt_char("Unused2", 2),  # @43
        fmt_char("TSIMathExemptedByCensus", 1),  # @45
        fmt_char("TSIMathWaiverExempted", 1),  # @46
        fmt_char("MathScore_ACT_SAT", 3),  # @47
        fmt_char("MathCompScore_ACT_SAT", 4),  # @50
        fmt_char("MathScore_TAKS", 4),  # @54
        fmt_char("TSIMathAtPlacement", 1),  # @58
        fmt_char("TSIMathAssesmentScore", 3),  # @59
        fmt_char("AlternateMathMethod", 1),  # @62
        fmt_char("MathTSIEndOfReportPeriod", 1),  # @63
        fmt_char("MathFirstLevelCollegeCourse", 1),  # @64
        fmt_char("TSIReadExemptedByCensus", 1),  # @65
        fmt_char("TSIReadWaiverExempted", 1),  # @66
        fmt_char("ReadScore_ACT_SAT", 3),  # @67
        fmt_char("ReadCompScore_ACT_SAT", 4),  # @70
        fmt_char("ReadScore_TAKS", 4),  # @74
        fmt_char("TSIReadAtPlacement", 1),  # @78
        fmt_char("TSIReadAssesmentScore", 3),  # @79
        fmt_char("AlternateReadMethod", 1),  # @82
        fmt_char("ReadTSIEndOfReportPeriod", 1),  # @83
        fmt_char("ReadFirstLevelCollegeCourse", 1),  # @84
        fmt_char("TSIWriteExemptedByCensus", 1),  # @85
        fmt_char("TSIWriteWaiverExempted", 1),  # @86
        fmt_char("WriteScore_ACT_SAT", 3),  # @87
        fmt_char("WriteCompScore_ACT_SAT", 4),  # @90
        fmt_char("WriteScore_TAKS", 4),  # @94
        fmt_char("TSIWriteAtPlacement", 1),  # @98
        fmt_char("TSIWriteAssesmentScore", 3),  # @99
        fmt_char("WriteEssayScore", 1),  # @102
        fmt_char("AlternateWriteMethod", 1),  # @103
        fmt_char("WriteTSIEndOfReportPeriod", 1),  # @104
        fmt_char("WriteFirstLevelCollegeCourse", 1),  # @105
        fmt_char("MathTSIABEDiagnosticScore", 1),  # @106
        fmt_char("ReadTSIABEDiagnosticScore", 1),  # @107
        fmt_char("WriteTSIABEDiagnosticScore", 1),  # @108
    ),
)

# Data lines DataFrame
df_data_lines = df_fixed_width.select(F.col("fixed_width_line").alias("value"))

# COMMAND ----------

# FILE: Write CBM002_{current_term}_{sysdate9}.txt — header + data + EOF
# Get SEMESTER and YEAR from first record for header construction
record_count = df_cbm002_cbreported_final.count()

if record_count > 0:
    first_row = df_cbm002_cbreported_final.select("SEMESTER", "YEAR").first()
    semester_val = first_row["SEMESTER"]
    year_val = first_row["YEAR"]
    # Build header line (same width as data records)
    header_text = (
        f"HY2K003656CBM002"
        f"{semester_val[:1]}"
        f"{year_val[:4]}"
        f"C0105JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU"
    )
    header_line = header_text

    # Build EOF line
    eof_text = f"EOF1{str(record_count).rjust(5, '0')}"
    eof_line = eof_text

    # Create header and EOF DataFrames with sort keys
    header_df = spark.createDataFrame([(header_line, 0)], ["value", "_sort_key"])
    eof_df = spark.createDataFrame([(eof_line, 2)], ["value", "_sort_key"])
    data_df = df_data_lines.withColumn("_sort_key", F.lit(1))

    # Union: header (0) + data (1) + EOF (2), ordered by sort key
    df_full_file = (
        header_df.unionAll(data_df)
        .unionAll(eof_df)
        .orderBy("_sort_key")
        .select("value")
    )

else:
    data_df = df_data_lines.withColumn("_sort_key", F.lit(1))

    df_full_file = data_df.orderBy("_sort_key").select("value")


# SAS date format: 23JUN2026 (SYSDATE9.)
sysdate9 = datetime.now().strftime("%d%b%Y").upper()

# Write to text file
cbm_filename = f"CBM002_{current_term}_{sysdate9}"
(df_full_file.coalesce(1).write.mode("overwrite").text(f"{output_path}{cbm_filename}"))

# Rename part file to final filename
_part_files = dbutils.fs.ls(f"{output_path}{cbm_filename}")
_part_file = [f.path for f in _part_files if f.name.startswith("part-")][0]
dbutils.fs.cp(_part_file, f"{output_path}{cbm_filename}.txt")
dbutils.fs.rm(f"{output_path}{cbm_filename}", recurse=True)

log_msg(f"Written: {output_path}{cbm_filename}.txt")

# COMMAND ----------

# Drop checkpoint temp tables now that the final write is complete

for _tmp_tbl in (
    _tmp_stageA_tbl,
    _tmp_stageB_tbl,
    _tmp_stageC_tbl,
    _tmp_stageD_tbl,
    _tmp_stageE_tbl,
    _tmp_stageF_tbl,
):
    try:
        drop_table(_tmp_tbl)
        log_msg(f"Dropped checkpoint temp table: {_tmp_tbl}")
    except Exception as _e:
        log_msg(f"WARN: could not drop {_tmp_tbl}: {_e}")

# COMMAND ----------

# Job End Time

_job_end_time = datetime.now()
_job_elapsed = _job_end_time - _job_start_time
log_msg(
    f"Job completed: transform_analytics_fact_thecb_cbm002 | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} | Elapsed: {str(_job_elapsed)}",
    "info",
)
