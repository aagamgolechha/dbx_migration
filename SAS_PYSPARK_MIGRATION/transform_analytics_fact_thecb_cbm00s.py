# Databricks notebook source
# /// script
# [tool.databricks.environment]
# environment_version = "5"
# ///
# MAGIC %md
# MAGIC # 400_LOAD_CBM00S --> transform_analytics_fact_thecb_cbm00s
# MAGIC Converted from SAS to PySpark
# MAGIC Source: 400_LOAD_CBM00S.sas

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

# Pyspark Imports
from datetime import datetime
from pyspark.sql import functions as F
from pyspark.sql.types import *
from pyspark.sql import Window

# COMMAND ----------

# Job start Time
_job_start_time = datetime.now()
log_msg(
    f"Job started: transform_analytics_fact_thecb_cbm00s | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)

# COMMAND ----------

# Dynamic parameters : Current Term and Prior Term
dbutils.widgets.text("current_term", "2262", "Current Term")
dbutils.widgets.text("prior_term", "2258", "Prior Term")

current_term = dbutils.widgets.get("current_term")
prior_term = dbutils.widgets.get("prior_term")

# COMMAND ----------

adw_term_dim = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("ADW_TERM_DIM")

adw_dept_dim = read_table(f"{analytics}.{silver}.dim_thecb_department").alias("ADW_DEPT_DIM")

adw_cbm_dlrnorpt = read_table(
    f"{analytics}.{silver}.fact_thecb_distance_learning"
).alias("ADW_CBM_DLRNORPT")
adw_cbm_excess_hours = read_table(
    f"{analytics}.{silver}.fact_thecb_excess_hours"
).alias("ADW_CBM_EXCESS_HOURS")
adw_cbm_3peatdev = read_table(f"{analytics}.{silver}.fact_thecb_three_repeat").alias(
    "ADW_CBM_3PEATDEV"
)
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
ps_stdnt_enrl = read_table(f"{student}.{bronze}.PS_STDNT_ENRL").alias("PS_STDNT_ENRL")
ps_sctn_cmbnd = read_table(f"{student}.{bronze}.PS_SCTN_CMBND").alias("PS_SCTN_CMBND")
ps_acad_plan = read_table(f"{student}.{bronze}.PS_ACAD_PLAN").alias("PS_ACAD_PLAN")
ps_acad_plan_owner = read_table(f"{student}.{bronze}.PS_ACAD_PLAN_OWNER").alias(
    "PS_ACAD_PLAN_OWNER"
)
ps_acad_plan_tbl = read_table(f"{student}.{bronze}.PS_ACAD_PLAN_TBL").alias(
    "PS_ACAD_PLAN_TBL"
)
ps_acad_prog = read_table(f"{student}.{bronze}.PS_ACAD_PROG").alias("PS_ACAD_PROG")
ps_stdnt_car_term = read_table(f"{student}.{bronze}.PS_STDNT_CAR_TERM").alias(
    "PS_STDNT_CAR_TERM"
)
ps_uta_unfunded = read_table(f"{student}.{bronze}.PS_UTA_UNFUNDED").alias(
    "PS_UTA_UNFUNDED"
)
ps_utacadplan_dtl = read_table(f"{student}.{bronze}.PS_UTA_ACADPLAN_DTL").alias(
    "PS_UTA_ACADPLAN_DTL"
)
ps_trns_crse_dtl = read_table(f"{student}.{bronze}.PS_TRNS_CRSE_DTL").alias(
    "PS_TRNS_CRSE_DTL"
)
ps_person_sa = read_table(f"{student}.{bronze}.PS_PERSON_SA").alias("PS_PERSON_SA")
ps_srvc_ind_data = read_table(f"{student}.{bronze}.PS_SRVC_IND_DATA").alias(
    "PS_SRVC_IND_DATA"
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
ps_uta_heh_plan_tb = read_table(f"{student}.{bronze}.PS_UTA_HEH_PLAN_TB").alias(
    "PS_UTA_HEH_PLAN_TB"
)
ps_trns_test_dtl = read_table(f"{student}.{bronze}.PS_TRNS_TEST_DTL").alias(
    "PS_TRNS_TEST_DTL"
)
ps_ext_course = read_table(f"{student}.{bronze}.PS_EXT_COURSE").alias("PS_EXT_COURSE")
uta_cb_crse_inventory = read_table(
    f"{analytics}.{reference}.fact_thecb_course_inventory"
).alias("UTA_CB_CRSE_INVENTORY")
uta_cb_formula_funding = read_table(
    f"{analytics}.{reference}.fact_thecb_formula_funding"
).alias("UTA_CB_FORMULA_FUNDING")

# COMMAND ----------

# CBM00S_Term

df_cbm00s_term_part0 = adw_term_dim.filter(
    (F.coalesce(F.col("ADW_TERM_DIM.STRM"), F.lit("")) == F.lit(current_term))
    & (F.coalesce(F.col("ADW_TERM_DIM.ACAD_CAREER"), F.lit("")) == F.lit("UGRD"))
)

df_cbm00s_term_part0 = df_cbm00s_term_part0.select(
    F.col("ADW_TERM_DIM.STRM"),
    F.col("ADW_TERM_DIM.ACAD_CAREER"),
    F.col("ADW_TERM_DIM.TERM_BEGIN_DT"),
    F.col("ADW_TERM_DIM.TERM_END_DT"),
    F.col("ADW_TERM_DIM.TERM_SK"),
    F.col("ADW_TERM_DIM.CENSUS_DT"),
    F.col("ADW_TERM_DIM.STRM").alias("Current_Term"),
)

df_cbm00s_term_part1 = adw_term_dim.filter(
    (F.coalesce(F.col("ADW_TERM_DIM.ACAD_CAREER"), F.lit("")) == F.lit("UGRD"))
    & (F.coalesce(F.col("ADW_TERM_DIM.STRM"), F.lit("")) == F.lit(prior_term))
    & (
        F.date_format(F.current_date(), "yyyy-MM-dd")
        > F.date_format(F.col("ADW_TERM_DIM.TERM_END_DT"), "yyyy-MM-dd")
    )
)

df_cbm00s_term_part1 = df_cbm00s_term_part1.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ADW_TERM_DIM.STRM")).over(
        Window.partitionBy("ADW_TERM_DIM.ACAD_CAREER")
    ),
)

df_cbm00s_term_part1 = df_cbm00s_term_part1.filter(
    F.coalesce(F.col("ADW_TERM_DIM.STRM"), F.lit(""))
    == F.coalesce(F.col("_agg_tmp_0"), F.lit(""))
).drop("_agg_tmp_0")

df_cbm00s_term_part1 = df_cbm00s_term_part1.select(
    F.col("ADW_TERM_DIM.STRM"),
    F.col("ADW_TERM_DIM.ACAD_CAREER"),
    F.col("ADW_TERM_DIM.TERM_BEGIN_DT"),
    F.col("ADW_TERM_DIM.TERM_END_DT"),
    F.col("ADW_TERM_DIM.TERM_SK"),
    F.col("ADW_TERM_DIM.CENSUS_DT"),
    F.when(
        (F.substring(F.col("ADW_TERM_DIM.STRM"), 4, 1) == F.lit("8")),
        F.coalesce(F.col("ADW_TERM_DIM.STRM").cast("BIGINT") + F.lit(4), F.lit(0)).cast("STRING"),
    )
    .otherwise(F.coalesce(F.col("ADW_TERM_DIM.STRM").cast("BIGINT") + F.lit(3), F.lit(0)).cast("STRING"))
    .alias("Current_Term"),
)

# Union
df_cbm00s_term = df_cbm00s_term_part0.union(df_cbm00s_term_part1)

# COMMAND ----------

# Term_Setup
df_term_setup = df_cbm00s_term.alias("CBM00S_Term")
_winSpec_0 = Window.partitionBy(F.col("CBM00S_Term.ACAD_CAREER"))

df_term_setup = df_term_setup.withColumn(
    "Current_Term_End_Date", F.max(F.col("CBM00S_Term.TERM_END_DT")).over(_winSpec_0)
)

df_term_setup = df_term_setup.select(
    F.col("CBM00S_Term.STRM"),
    F.col("CBM00S_Term.TERM_BEGIN_DT"),
    F.col("CBM00S_Term.TERM_END_DT"),
    F.col("CBM00S_Term.TERM_SK"),
    F.col("CBM00S_Term.CENSUS_DT"),
    F.col("CBM00S_Term.Current_Term"),
    F.col("CBM00S_Term.ACAD_CAREER"),
    F.col("Current_Term_End_Date"),
)

# COMMAND ----------

# Read source and extract variables
_df = df_term_setup
_rows = _df.collect()

for _row in _rows:
    _d = _row.asDict()
    if str(_d.get("STRM", "")) == str(_d.get("Current_Term", "")):
        # Current-term row
        current_term = str(_d["STRM"])
        current_term_begin_date = str(_d["TERM_BEGIN_DT"])
        current_term_end_date = str(_d["TERM_END_DT"])
        current_term_sk = str(_d["TERM_SK"])
        current_term_census_date = str(_d["CENSUS_DT"])
        log_msg(
            "current_term: "
            + current_term
            + ", current_term_begin_date: "
            + current_term_begin_date
            + ", current_term_end_date: "
            + current_term_end_date
            + ", current_term_sk: "
            + current_term_sk
            + ", current_term_census_date: "
            + current_term_census_date
        )
    else:
        # Prior-term row
        prior_term = str(_d["STRM"])
        prior_term_begin_date = str(_d["TERM_BEGIN_DT"])
        prior_term_end_date = str(_d["TERM_END_DT"])
        prior_term_sk = str(_d["TERM_SK"])
        prior_term_census_date = str(_d["CENSUS_DT"])
        log_msg(
            "prior_term: "
            + prior_term
            + ", prior_term_begin_date: "
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
# CBM00S_CLASS_ATTRIBUTE

df_cbm00s_class_attribute = ps_class_attribute.join(
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

df_cbm00s_class_attribute = df_cbm00s_class_attribute.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_CRSE_ATTR_VALUE.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "PS_CRSE_ATTR_VALUE.CRSE_ATTR", "PS_CRSE_ATTR_VALUE.CRSE_ATTR_VALUE"
        )
    ),
)

df_cbm00s_class_attribute = df_cbm00s_class_attribute.filter(
    F.date_format(F.col("PS_CRSE_ATTR_VALUE.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm00s_class_attribute = df_cbm00s_class_attribute.select(
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

# Step : CBM00S_CLASS_ATTRIBUTES — BY-group catx/retain → sort_array + collect_list
# SAS sorts by ATTRVALTBL_ATTR / ATTRVALTBL_ATTR_VALUE before concatenation.

group_cols = ["CRSE_ID", "CRSE_OFFER_NBR", "STRM", "SESSION_CODE", "CLASS_SECTION"]

# Pass 1 — ATTR_LIST sorted by ATTRVALTBL_ATTR (ascending)
df_attr = (
    df_cbm00s_class_attribute.select(group_cols + ["ATTRVALTBL_ATTR"])
    .groupBy(group_cols)
    .agg(
        F.concat_ws(
            ",", F.sort_array(F.collect_list(F.trim(F.col("ATTRVALTBL_ATTR"))))
        ).alias("ATTR_LIST")
    )
)

# Pass 2 — VAL_LIST sorted by ATTRVALTBL_ATTR_VALUE (ascending)
df_val = (
    df_cbm00s_class_attribute.select(group_cols + ["ATTRVALTBL_ATTR_VALUE"])
    .groupBy(group_cols)
    .agg(
        F.concat_ws(
            ",", F.sort_array(F.collect_list(F.trim(F.col("ATTRVALTBL_ATTR_VALUE"))))
        ).alias("VAL_LIST")
    )
)

# Pass 3 — Inner join (SAS: if a and b)
df_CBM00S_CLASS_ATTRIBUTES = (
    df_attr.alias("CLS_ATTR")
    .join(df_val.alias("CLS_VAL"), on=group_cols, how="inner")
    .select(
        F.col("CLS_ATTR.CRSE_ID"),
        F.col("CLS_ATTR.CRSE_OFFER_NBR"),
        F.col("CLS_ATTR.STRM"),
        F.col("CLS_ATTR.SESSION_CODE"),
        F.col("CLS_ATTR.CLASS_SECTION"),
        F.col("CLS_ATTR.ATTR_LIST"),
        F.col("CLS_VAL.VAL_LIST"),
    )
)

# COMMAND ----------

# CBM00S_CRSE_ATTRIBUTE

df_cbm00s_crse_attribute = ps_crse_attributes.filter(
    F.date_format(F.col("PS_CRSE_ATTRIBUTES.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    <= F.date_format(F.lit(current_term_begin_date), "yyyy-MM-dd HH:mm:ss")
)

df_cbm00s_crse_attribute = df_cbm00s_crse_attribute.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_CRSE_ATTRIBUTES.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("PS_CRSE_ATTRIBUTES.CRSE_ID")
    ),
)

df_cbm00s_crse_attribute = df_cbm00s_crse_attribute.filter(
    (
        F.date_format(F.col("PS_CRSE_ATTRIBUTES.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        == F.col("_agg_tmp_0")
    )
    & (
        F.date_format(F.col("PS_CRSE_ATTRIBUTES.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        < F.date_format(F.current_timestamp(), "yyyy-MM-dd HH:mm:ss")
    )
).drop("_agg_tmp_0")

df_cbm00s_crse_attribute = df_cbm00s_crse_attribute.select(
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

# Step: CBM00S_COURSE_ATTRIBUTE — BY-group catx/retain → sort_array + collect_list
# SAS sorts by CRSE_ATTR / CRSE_ATTR_VALUE before concatenation.

# Pass 1 — CRSE_ATTR_LIST sorted by CRSE_ATTR (ascending)
df_crse_attr = (
    df_cbm00s_crse_attribute.select("CRSE_ID", "CRSE_ATTR")
    .groupBy("CRSE_ID")
    .agg(
        F.concat_ws(
            ",", F.sort_array(F.collect_list(F.trim(F.col("CRSE_ATTR"))))
        ).alias("CRSE_ATTR_LIST")
    )
)

# Pass 2 — CRSE_VAL_LIST sorted by CRSE_ATTR_VALUE (ascending)
df_crse_val = (
    df_cbm00s_crse_attribute.select("CRSE_ID", "CRSE_ATTR_VALUE")
    .groupBy("CRSE_ID")
    .agg(
        F.concat_ws(
            ",", F.sort_array(F.collect_list(F.trim(F.col("CRSE_ATTR_VALUE"))))
        ).alias("CRSE_VAL_LIST")
    )
)

# Pass 3 — Inner join (SAS: if a and b)
df_CBM00S_COURSE_ATTRIBUTE = (
    df_crse_attr.alias("ATTR")
    .join(df_crse_val.alias("VAL"), on="CRSE_ID", how="inner")
    .select(
        F.col("ATTR.CRSE_ID"),
        F.col("ATTR.CRSE_ATTR_LIST"),
        F.col("VAL.CRSE_VAL_LIST"),
    )
)

# COMMAND ----------

# CBM00S_CORE_COURSE

df_cbm00s_core_course = ps_crse_catalog.filter(
    (
        F.date_format(F.col("PS_CRSE_CATALOG.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.lit(current_term_begin_date), "yyyy-MM-dd HH:mm:ss")
    )
    & (F.coalesce(F.col("PS_CRSE_CATALOG.EFF_STATUS"), F.lit("")) == F.lit("A"))
)

df_cbm00s_core_course = df_cbm00s_core_course.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_CRSE_CATALOG.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("PS_CRSE_CATALOG.CRSE_ID")
    ),
)

df_cbm00s_core_course = df_cbm00s_core_course.filter(
    F.date_format(F.col("PS_CRSE_CATALOG.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm00s_core_course = df_cbm00s_core_course.select(
    F.col("PS_CRSE_CATALOG.CRSE_ID"),
    F.col("PS_CRSE_CATALOG.COMPONENT_PRIMARY"),
    F.col("PS_CRSE_CATALOG.CRSE_CONTACT_HRS"),
    F.col("PS_CRSE_CATALOG.RQMNT_DESIGNTN"),
)

# COMMAND ----------

# Step: Course_Info
# CBM00S_Course_Info

cbm00s_class_attributes = df_CBM00S_CLASS_ATTRIBUTES.alias("CBM00S_CLASS_ATTRIBUTES")
cbm00s_course_attributes = df_CBM00S_COURSE_ATTRIBUTE.alias("CBM00S_COURSE_ATTRIBUTE")
cbm00s_core_course = df_cbm00s_core_course.alias("CBM00S_CORE_COURSE")

df_cbm00s_course_info = (
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
        cbm00s_class_attributes,
        on=(
            (F.col("PS_CLASS_TBL.STRM") == F.col("CBM00S_CLASS_ATTRIBUTES.STRM"))
            & (
                F.col("PS_CLASS_TBL.CRSE_ID")
                == F.col("CBM00S_CLASS_ATTRIBUTES.CRSE_ID")
            )
            & (
                F.col("PS_CLASS_TBL.CRSE_OFFER_NBR")
                == F.col("CBM00S_CLASS_ATTRIBUTES.CRSE_OFFER_NBR")
            )
            & (
                F.col("PS_CLASS_TBL.SESSION_CODE")
                == F.col("CBM00S_CLASS_ATTRIBUTES.SESSION_CODE")
            )
            & (
                F.col("PS_CLASS_TBL.CLASS_SECTION")
                == F.col("CBM00S_CLASS_ATTRIBUTES.CLASS_SECTION")
            )
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
        cbm00s_course_attributes,
        on=(F.col("PS_CLASS_TBL.CRSE_ID") == F.col("CBM00S_COURSE_ATTRIBUTE.CRSE_ID")),
        how="left",
    )
    .join(
        cbm00s_core_course,
        on=(
            F.col("CBM00S_COURSE_ATTRIBUTE.CRSE_ID")
            == F.col("CBM00S_CORE_COURSE.CRSE_ID")
        ),
        how="left",
    )
)

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "OFFSITE_LOC_CD",
    F.when(
        (
            ~F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD").isin(["0", "6", "9"])
            & F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD").isNotNull()
        ),
        F.substring(
            F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOC_VALUE"),
            (F.length(F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOC_VALUE")) - F.lit(4)),
            5,
        ),
    ).otherwise(F.lit("")),
)

# COMMAND ----------

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "EXT_LOC_FICE",
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

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "UTA_CB_LOCATION_CD",
    F.when(
        (F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD") == F.lit("")), F.lit("0")
    ).otherwise(F.col("PS_UTA_CB_LOC_VW.UTA_CB_LOCATION_CD")),
)

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "CB_Exclude",
    F.when(
        (
            F.expr("LOCATE('EXCLUDE', UPPER(CBM00S_CLASS_ATTRIBUTES.VAL_LIST))")
            != F.lit(0)
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "NCBO",
    F.when(
        (
            (F.expr("LOCATE('NCBO', CBM00S_CLASS_ATTRIBUTES.ATTR_LIST)") > F.lit(0))
            | (F.expr("LOCATE('NCBOCO', CBM00S_CLASS_ATTRIBUTES.VAL_LIST)") > F.lit(0))
        ),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "Core_Course",
    F.when(
        F.col("CBM00S_CORE_COURSE.RQMNT_DESIGNTN").isin(
            [
                "020",
                "2092",
                "092",
                "040",
                "060",
                "070",
                "080",
                "098",
                "4094",
                "8098",
                "010",
                "1091",
                "030",
                "050",
                "3093",
                "5095",
            ]
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

# COMMAND ----------

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "MathCore",
    F.when(
        F.col("CBM00S_CORE_COURSE.RQMNT_DESIGNTN").isin(["020", "2092", "092"]),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "ReadCore",
    F.when(
        F.col("CBM00S_CORE_COURSE.RQMNT_DESIGNTN").isin(
            ["040", "060", "070", "080", "098", "4094", "8098"]
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "WriteCore",
    F.when(
        F.col("CBM00S_CORE_COURSE.RQMNT_DESIGNTN").isin(["010", "1091"]), F.lit(1)
    ).otherwise(F.lit(0)),
)

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "DLRN_Course",
    F.when(
        (F.expr("LOCATE('DLRN', UPPER(CBM00S_CLASS_ATTRIBUTES.ATTR_LIST))") > F.lit(0)),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm00s_course_info = df_cbm00s_course_info.withColumn(
    "AP_Course",
    F.when(
        (F.expr("LOCATE('HEH', UPPER(CBM00S_CLASS_ATTRIBUTES.ATTR_LIST))") > F.lit(0)),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm00s_course_info = df_cbm00s_course_info.select(
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
    F.col("OFFSITE_LOC_CD"),
    F.col("EXT_LOC_FICE"),
    F.col("UTA_CB_LOCATION_CD"),
    F.col("CBM00S_CLASS_ATTRIBUTES.ATTR_LIST").alias("CLASS_ATTR_LIST"),
    F.col("CBM00S_CLASS_ATTRIBUTES.VAL_LIST").alias("CLASS_VAL_LIST"),
    F.col("CBM00S_COURSE_ATTRIBUTE.CRSE_ATTR_LIST"),
    F.col("CBM00S_COURSE_ATTRIBUTE.CRSE_VAL_LIST"),
    F.col("CB_Exclude"),
    F.col("NCBO"),
    F.col("Core_Course"),
    F.col("MathCore"),
    F.col("ReadCore"),
    F.col("WriteCore"),
    F.col("DLRN_Course"),
    F.col("AP_Course"),
)

# COMMAND ----------

# Step: Enrollment_Current_term
# CBM00S_StudentEnrollment

term_setup = df_term_setup.alias("Term_Setup")

df_cbm00s_studentenrollment = ps_stdnt_enrl.join(
    term_setup,
    on=(F.col("PS_STDNT_ENRL.STRM") == F.col("Term_Setup.STRM")),
    how="inner",
)

df_cbm00s_studentenrollment = df_cbm00s_studentenrollment.select(
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
    F.col("Term_Setup.TERM_BEGIN_DT"),
    F.col("Term_Setup.TERM_END_DT"),
    F.col("Term_Setup.CENSUS_DT"),
    F.col("Term_Setup.Current_Term"),
    F.col("Term_Setup.Current_Term_End_Date"),
)

# COMMAND ----------

# Step: Enrollment+Course
# CBM00S_Enrollment

cbm00s_course_info = df_cbm00s_course_info.alias("CBM00S_Course_Info")

df_cbm00s_enrollment = df_cbm00s_studentenrollment.alias("CBM00S_StudentEnrollment")
df_cbm00s_enrollment = df_cbm00s_enrollment.join(
    cbm00s_course_info,
    on=(
        (F.col("CBM00S_StudentEnrollment.STRM") == F.col("CBM00S_Course_Info.STRM"))
        & (
            F.col("CBM00S_StudentEnrollment.SESSION_CODE")
            == F.col("CBM00S_Course_Info.SESSION_CODE")
        )
        & (
            F.col("CBM00S_StudentEnrollment.CLASS_NBR")
            == F.col("CBM00S_Course_Info.CLASS_NBR")
        )
        & (F.trim(F.col("CBM00S_StudentEnrollment.STDNT_ENRL_STATUS")) == F.lit("E"))
        & (
            (
                F.trim(F.col("CBM00S_StudentEnrollment.ENRL_ACTN_RSN_LAST"))
                != F.lit("CENS")
            )
            | (F.col("CBM00S_StudentEnrollment.ENRL_ACTN_RSN_LAST").isNull())
            | (
                F.trim(F.col("CBM00S_StudentEnrollment.ENRL_ACTN_RSN_LAST"))
                == F.lit("")
            )
        )
        & (F.trim(F.col("CBM00S_Course_Info.CLASS_STAT")).isin(["A", "S"]))
        & F.trim(F.col("CBM00S_Course_Info.CLASS_TYPE")).isin(["E", "N"])
        & (F.trim(F.col("CBM00S_Course_Info.INSTITUTION")) == F.lit("UTARL"))
    ),
    how="inner",
)

df_cbm00s_enrollment = df_cbm00s_enrollment.filter(
    (F.col("CBM00S_Course_Info.ACAD_ORG") != F.lit("TRAN"))
    & (
        F.coalesce(F.col("CBM00S_StudentEnrollment.CRSE_GRADE_OFF"), F.lit(""))
        != F.lit("AU")
    )
)

df_cbm00s_enrollment = df_cbm00s_enrollment.select(
    F.col("CBM00S_StudentEnrollment.ACAD_CAREER"),
    F.col("CBM00S_StudentEnrollment.ACAD_PROG"),
    F.col("CBM00S_StudentEnrollment.CRSE_CAREER"),
    F.col("CBM00S_StudentEnrollment.EMPLID"),
    F.col("CBM00S_StudentEnrollment.ENRL_STATUS_REASON"),
    F.col("CBM00S_StudentEnrollment.INSTITUTION"),
    F.col("CBM00S_StudentEnrollment.STRM"),
    F.col("CBM00S_Course_Info.SESSION_CODE"),
    F.col("CBM00S_Course_Info.SUBJECT"),
    F.col("CBM00S_Course_Info.CLASS_NBR"),
    F.col("CBM00S_Course_Info.CATALOG_NBR"),
    F.col("CBM00S_StudentEnrollment.UNT_EARNED"),
    F.col("CBM00S_StudentEnrollment.UNT_PRGRSS"),
    F.col("CBM00S_StudentEnrollment.UNT_TAKEN"),
    F.col("CBM00S_Course_Info.START_DT"),
    F.col("CBM00S_Course_Info.END_DT"),
    F.col("CBM00S_StudentEnrollment.TERM_END_DT"),
    F.col("CBM00S_StudentEnrollment.CENSUS_DT"),
    F.col("CBM00S_StudentEnrollment.Current_Term_End_Date"),
    F.col("CBM00S_Course_Info.CLASS_SECTION"),
    F.col("CBM00S_Course_Info.CLASS_STAT"),
    F.col("CBM00S_Course_Info.CLASS_TYPE"),
    F.col("CBM00S_StudentEnrollment.GRADE_CATEGORY"),
    F.col("CBM00S_StudentEnrollment.GRADE_POINTS"),
    F.col("CBM00S_Course_Info.CRSE_ID"),
    F.col("CBM00S_Course_Info.CRSE_OFFER_NBR"),
    F.col("CBM00S_Course_Info.INSTRUCTION_MODE"),
    F.col("CBM00S_Course_Info.LOCATION"),
    F.col("CBM00S_Course_Info.ENRL_TOT"),
    F.col("CBM00S_Course_Info.SSR_COMPONENT"),
    F.col("CBM00S_Course_Info.COMPONENT_PRIMARY"),
    F.col("CBM00S_Course_Info.CRSE_CONTACT_HRS"),
    F.col("CBM00S_Course_Info.UNITS_MAXIMUM"),
    F.col("CBM00S_Course_Info.ACAD_GROUP"),
    F.col("CBM00S_Course_Info.ACAD_ORG"),
    F.col("CBM00S_Course_Info.CAMPUS"),
    F.col("CBM00S_Course_Info.OFFSITE_LOC_CD"),
    F.col("CBM00S_Course_Info.EXT_LOC_FICE"),
    F.col("CBM00S_Course_Info.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_Course_Info.CB_Exclude"),
    F.col("CBM00S_StudentEnrollment.REPEAT_CANDIDATE"),
    F.col("CBM00S_Course_Info.CLASS_ATTR_LIST"),
    F.col("CBM00S_Course_Info.CLASS_VAL_LIST"),
    F.col("CBM00S_StudentEnrollment.TERM_BEGIN_DT"),
    F.col("CBM00S_Course_Info.NCBO"),
    F.col("CBM00S_StudentEnrollment.CRSE_GRADE_OFF"),
    F.col("CBM00S_Course_Info.COMBINED_SECTION_ID"),
    F.col("CBM00S_Course_Info.CRSE_ATTR_LIST"),
    F.col("CBM00S_Course_Info.CRSE_VAL_LIST"),
    F.col("CBM00S_StudentEnrollment.Current_Term"),
    F.col("CBM00S_Course_Info.Core_Course"),
    F.col("CBM00S_Course_Info.MathCore"),
    F.col("CBM00S_Course_Info.ReadCore"),
    F.col("CBM00S_Course_Info.WriteCore"),
    F.col("CBM00S_Course_Info.DLRN_Course"),
    F.col("CBM00S_Course_Info.AP_Course"),
)

# COMMAND ----------

# Checkpoint 1: materialize df_cbm00s_enrollment to break the upstream DAG
_tmp_stageA_tbl = f"{analytics}.{staging}._tmp_cbm00s_enrollment"
write_df_to_table(
    df_cbm00s_enrollment, _tmp_stageA_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm00s_enrollment = read_table(_tmp_stageA_tbl).alias("CBM00S_Enrollment")
log_msg(f"Checkpoint 1 materialized: {_tmp_stageA_tbl}")

# COMMAND ----------

# CBM00S_DLRN_Unduplicated

df_cbm00s_dlrn_unduplicated = adw_cbm_dlrnorpt.select(
    F.col("ADW_CBM_DLRNORPT.STRM"), F.col("ADW_CBM_DLRNORPT.EMPLID")
).distinct()

# CBM00S_DLRN
cbm00s_dlrn_unduplicated = df_cbm00s_dlrn_unduplicated.alias("CBM00S_DLRN_Unduplicated")
cbm00s_enrollment = df_cbm00s_enrollment.alias("CBM00S_Enrollment")

df_cbm00s_dlrn = cbm00s_enrollment.join(
    cbm00s_dlrn_unduplicated,
    on=(
        (
            F.col("CBM00S_Enrollment.Current_Term")
            == F.col("CBM00S_DLRN_Unduplicated.STRM")
        )
        & (
            F.col("CBM00S_Enrollment.EMPLID")
            == F.col("CBM00S_DLRN_Unduplicated.EMPLID")
        )
    ),
    how="left",
)

df_cbm00s_dlrn = df_cbm00s_dlrn.withColumn(
    "DLRN_Student",
    F.when(
        (
            F.coalesce(F.trim(F.col("CBM00S_DLRN_Unduplicated.EMPLID")), F.lit(""))
            == F.lit("")
        ),
        F.lit("No"),
    ).otherwise(F.lit("Yes")),
)

# COMMAND ----------

df_cbm00s_dlrn = df_cbm00s_dlrn.withColumn(
    "Current_Semester_Reportable",
    F.when(
        (
            (
                (
                    F.col("CBM00S_Enrollment.STRM")
                    == F.col("CBM00S_Enrollment.Current_Term")
                )
                & (F.trim(F.col("CBM00S_Enrollment.SESSION_CODE")) == F.lit("1"))
                & F.substring(F.col("CBM00S_Enrollment.STRM"), 4, 1).isin(["2", "8"])
            )
            | (
                (
                    F.col("CBM00S_Enrollment.STRM")
                    == F.col("CBM00S_Enrollment.Current_Term")
                )
                & (F.trim(F.col("CBM00S_Enrollment.SESSION_CODE")) == F.lit("5W2"))
                & (F.substring(F.col("CBM00S_Enrollment.STRM"), 4, 1) == F.lit("5"))
            )
            | (
                (
                    F.col("CBM00S_Enrollment.STRM")
                    == F.col("CBM00S_Enrollment.Current_Term")
                )
                & (F.col("CBM00S_Enrollment.SESSION_CODE") != F.lit("1"))
                & F.substring(F.col("CBM00S_Enrollment.STRM"), 4, 1).isin(["2", "8"])
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.Current_Term_End_date")
                )
            )
            | (
                (
                    F.col("CBM00S_Enrollment.STRM")
                    == F.col("CBM00S_Enrollment.Current_Term")
                )
                & (F.col("CBM00S_Enrollment.SESSION_CODE") != F.lit("5W2"))
                & (F.substring(F.col("CBM00S_Enrollment.STRM"), 4, 1) == F.lit("5"))
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.Current_Term_End_date")
                )
            )
            | (
                (
                    (
                        F.col("CBM00S_Enrollment.Current_Term").cast("BIGINT")
                        - F.col("CBM00S_Enrollment.STRM").cast("BIGINT")
                    )
                    > F.lit(0)
                )
                & (F.col("CBM00S_Enrollment.SESSION_CODE") != F.lit("5W2"))
                & F.substring(F.col("CBM00S_Enrollment.Current_Term"), 4, 1).isin(
                    ["2", "8"]
                )
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.Current_Term_End_date")
                )
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    > F.col("CBM00S_Enrollment.TERM_END_DT")
                )
            )
            | (
                (
                    (
                        F.col("CBM00S_Enrollment.Current_Term").cast("BIGINT")
                        - F.col("CBM00S_Enrollment.STRM").cast("BIGINT")
                    )
                    > F.lit(0)
                )
                & (F.col("CBM00S_Enrollment.SESSION_CODE") != F.lit("1"))
                & (
                    F.substring(F.col("CBM00S_Enrollment.Current_Term"), 4, 1)
                    == F.lit("5")
                )
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.Current_Term_End_date")
                )
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    > F.col("CBM00S_Enrollment.TERM_END_DT")
                )
            )
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

# COMMAND ----------

df_cbm00s_dlrn = df_cbm00s_dlrn.withColumn(
    "Test",
    F.when(
        (
            (
                (
                    F.col("CBM00S_Enrollment.STRM")
                    == F.col("CBM00S_Enrollment.Current_Term")
                )
                & (F.trim(F.col("CBM00S_Enrollment.SESSION_CODE")) == F.lit("1"))
                & F.substring(F.col("CBM00S_Enrollment.STRM"), 4, 1).isin(["2", "8"])
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.TERM_END_DT")
                )
            )
            | (
                (
                    F.col("CBM00S_Enrollment.STRM")
                    == F.col("CBM00S_Enrollment.Current_Term")
                )
                & (F.trim(F.col("CBM00S_Enrollment.SESSION_CODE")) == F.lit("5W2"))
                & (F.substring(F.col("CBM00S_Enrollment.STRM"), 4, 1) == F.lit("5"))
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.TERM_END_DT")
                )
            )
            | (
                (
                    F.col("CBM00S_Enrollment.STRM")
                    == F.col("CBM00S_Enrollment.Current_Term")
                )
                & (F.col("CBM00S_Enrollment.SESSION_CODE") != F.lit("1"))
                & F.substring(F.col("CBM00S_Enrollment.STRM"), 4, 1).isin(["2", "8"])
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.Current_Term_End_date")
                )
            )
            | (
                (
                    F.col("CBM00S_Enrollment.STRM")
                    == F.col("CBM00S_Enrollment.Current_Term")
                )
                & (F.col("CBM00S_Enrollment.SESSION_CODE") != F.lit("5W2"))
                & (F.substring(F.col("CBM00S_Enrollment.STRM"), 4, 1) == F.lit("5"))
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.Current_Term_End_date")
                )
            )
            | (
                (
                    (
                        F.col("CBM00S_Enrollment.Current_Term").cast("BIGINT")
                        - F.col("CBM00S_Enrollment.STRM").cast("BIGINT")
                    )
                    > F.lit(0)
                )
                & (F.col("CBM00S_Enrollment.SESSION_CODE") != F.lit("5W2"))
                & F.substring(F.col("CBM00S_Enrollment.Current_Term"), 4, 1).isin(
                    ["2", "8"]
                )
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.Current_Term_End_date")
                )
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    > F.col("CBM00S_Enrollment.TERM_END_DT")
                )
            )
            | (
                (
                    (
                        F.col("CBM00S_Enrollment.Current_Term").cast("BIGINT")
                        - F.col("CBM00S_Enrollment.STRM").cast("BIGINT")
                    )
                    > F.lit(0)
                )
                & (F.col("CBM00S_Enrollment.SESSION_CODE") != F.lit("1"))
                & (
                    F.substring(F.col("CBM00S_Enrollment.Current_Term"), 4, 1)
                    == F.lit("5")
                )
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    <= F.col("CBM00S_Enrollment.Current_Term_End_date")
                )
                & (
                    F.col("CBM00S_Enrollment.END_DT")
                    > F.col("CBM00S_Enrollment.TERM_END_DT")
                )
            )
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

# COMMAND ----------

df_cbm00s_dlrn = df_cbm00s_dlrn.select(
    F.col("CBM00S_Enrollment.ACAD_CAREER"),
    F.col("CBM00S_Enrollment.ACAD_PROG"),
    F.col("CBM00S_Enrollment.CRSE_CAREER"),
    F.col("CBM00S_Enrollment.EMPLID"),
    F.col("CBM00S_Enrollment.ENRL_STATUS_REASON"),
    F.col("CBM00S_Enrollment.GRADE_CATEGORY"),
    F.col("CBM00S_Enrollment.GRADE_POINTS"),
    F.col("CBM00S_Enrollment.INSTITUTION"),
    F.col("CBM00S_Enrollment.STRM"),
    F.col("CBM00S_Enrollment.UNT_EARNED"),
    F.col("CBM00S_Enrollment.UNT_PRGRSS"),
    F.col("CBM00S_Enrollment.UNT_TAKEN"),
    F.col("CBM00S_Enrollment.CLASS_NBR"),
    F.col("CBM00S_Enrollment.CLASS_SECTION"),
    F.col("CBM00S_Enrollment.CLASS_STAT"),
    F.col("CBM00S_Enrollment.CLASS_TYPE"),
    F.lit("").alias("COMBINED_SECTION"),
    F.col("CBM00S_Enrollment.CRSE_ID"),
    F.col("CBM00S_Enrollment.CRSE_OFFER_NBR"),
    F.col("CBM00S_Enrollment.END_DT"),
    F.col("CBM00S_Enrollment.INSTRUCTION_MODE"),
    F.col("CBM00S_Enrollment.LOCATION"),
    F.col("CBM00S_Enrollment.START_DT"),
    F.col("CBM00S_Enrollment.SUBJECT"),
    F.col("CBM00S_Enrollment.TERM_BEGIN_DT"),
    F.col("CBM00S_Enrollment.TERM_END_DT"),
    F.col("CBM00S_Enrollment.CENSUS_DT"),
    F.col("DLRN_Student"),
    F.lit("").alias("Prior_Term"),
    F.col("CBM00S_Enrollment.CB_Exclude"),
    F.col("CBM00S_Enrollment.ENRL_TOT"),
    F.col("CBM00S_Enrollment.SSR_COMPONENT"),
    F.col("CBM00S_Enrollment.COMPONENT_PRIMARY"),
    F.col("CBM00S_Enrollment.CRSE_CONTACT_HRS"),
    F.col("CBM00S_Enrollment.UNITS_MAXIMUM"),
    F.col("CBM00S_Enrollment.SESSION_CODE"),
    F.col("CBM00S_Enrollment.Current_Term_End_date"),
    F.col("CBM00S_Enrollment.CATALOG_NBR"),
    F.col("CBM00S_Enrollment.ACAD_GROUP"),
    F.col("CBM00S_Enrollment.ACAD_ORG"),
    F.col("CBM00S_Enrollment.CAMPUS"),
    F.col("CBM00S_Enrollment.OFFSITE_LOC_CD"),
    F.col("CBM00S_Enrollment.EXT_LOC_FICE"),
    F.col("CBM00S_Enrollment.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_Enrollment.REPEAT_CANDIDATE"),
    F.col("CBM00S_Enrollment.CLASS_ATTR_LIST"),
    F.col("CBM00S_Enrollment.CLASS_VAL_LIST"),
    F.col("CBM00S_Enrollment.NCBO"),
    F.col("CBM00S_Enrollment.COMBINED_SECTION_ID"),
    F.col("CBM00S_Enrollment.CRSE_GRADE_OFF"),
    F.col("CBM00S_Enrollment.CRSE_ATTR_LIST"),
    F.col("CBM00S_Enrollment.CRSE_VAL_LIST"),
    F.col("CBM00S_Enrollment.Current_Term"),
    F.col("Current_Semester_Reportable"),
    F.col("CBM00S_Enrollment.Core_Course"),
    F.col("Test"),
    F.col("CBM00S_Enrollment.MathCore"),
    F.col("CBM00S_Enrollment.ReadCore"),
    F.col("CBM00S_Enrollment.WriteCore"),
    F.col("CBM00S_Enrollment.DLRN_Course"),
    F.col("CBM00S_Enrollment.AP_Course"),
).distinct()

# COMMAND ----------

# CBM00S_CBReported

cbm00s_dlrn = df_cbm00s_dlrn.alias("CBM00S_DLRN")

df_cbm00s_cbreported = cbm00s_dlrn.filter(
    F.coalesce(F.col("Current_Semester_Reportable"), F.lit("")) == F.lit("Yes")
)

df_cbm00s_cbreported = df_cbm00s_cbreported.withColumn(
    "CB_Reported_Student",
    F.when(
        (
            (
                F.coalesce(F.col("CBM00S_DLRN.Current_Semester_Reportable"), F.lit(""))
                == F.lit("Yes")
            )
            & (F.coalesce(F.col("CBM00S_DLRN.DLRN_Student"), F.lit("")) == F.lit("No"))
            & (
                F.coalesce(F.col("CBM00S_DLRN.CRSE_GRADE_OFF"), F.lit(""))
                != F.lit("AU")
            )
        ),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm00s_cbreported = df_cbm00s_cbreported.withColumn(
    "CB_Reported_Course",
    F.when(
        (
            (F.col("CBM00S_DLRN.Current_Semester_Reportable") == F.lit("Yes"))
            & (F.col("CBM00S_DLRN.CB_Exclude") == F.lit("No"))
            & (F.col("CBM00S_DLRN.ACAD_GROUP") != F.lit("TRAN"))
            & ~F.col("CBM00S_DLRN.SUBJECT").isin(["ASA", "EXCH"])
        ),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm00s_cbreported = df_cbm00s_cbreported.select(
    F.col("CBM00S_DLRN.ACAD_CAREER"),
    F.col("CBM00S_DLRN.ACAD_PROG"),
    F.col("CBM00S_DLRN.CRSE_CAREER"),
    F.col("CBM00S_DLRN.EMPLID"),
    F.col("CBM00S_DLRN.ENRL_STATUS_REASON"),
    F.col("CBM00S_DLRN.GRADE_CATEGORY"),
    F.col("CBM00S_DLRN.GRADE_POINTS"),
    F.col("CBM00S_DLRN.INSTITUTION"),
    F.col("CBM00S_DLRN.STRM"),
    F.col("CBM00S_DLRN.UNT_EARNED"),
    F.col("CBM00S_DLRN.UNT_PRGRSS"),
    F.col("CBM00S_DLRN.UNT_TAKEN"),
    F.col("CBM00S_DLRN.CLASS_NBR"),
    F.col("CBM00S_DLRN.CLASS_SECTION"),
    F.col("CBM00S_DLRN.CLASS_STAT"),
    F.col("CBM00S_DLRN.CLASS_TYPE"),
    F.col("CBM00S_DLRN.COMBINED_SECTION"),
    F.col("CBM00S_DLRN.CRSE_ID"),
    F.col("CBM00S_DLRN.CRSE_OFFER_NBR"),
    F.col("CBM00S_DLRN.END_DT"),
    F.col("CBM00S_DLRN.INSTRUCTION_MODE"),
    F.col("CBM00S_DLRN.LOCATION"),
    F.col("CBM00S_DLRN.START_DT"),
    F.col("CBM00S_DLRN.SUBJECT"),
    F.col("CBM00S_DLRN.TERM_BEGIN_DT"),
    F.col("CBM00S_DLRN.TERM_END_DT"),
    F.col("CBM00S_DLRN.CENSUS_DT"),
    F.col("CBM00S_DLRN.DLRN_Student"),
    F.col("CBM00S_DLRN.Prior_Term"),
    F.col("CBM00S_DLRN.CB_Exclude"),
    F.col("CBM00S_DLRN.ENRL_TOT"),
    F.col("CBM00S_DLRN.SSR_COMPONENT"),
    F.col("CBM00S_DLRN.COMPONENT_PRIMARY"),
    F.col("CBM00S_DLRN.CRSE_CONTACT_HRS"),
    F.col("CBM00S_DLRN.UNITS_MAXIMUM"),
    F.col("CBM00S_DLRN.SESSION_CODE"),
    F.col("CBM00S_DLRN.Current_Term_End_date"),
    F.col("CBM00S_DLRN.CATALOG_NBR"),
    F.col("CBM00S_DLRN.ACAD_GROUP"),
    F.col("CBM00S_DLRN.ACAD_ORG"),
    F.col("CBM00S_DLRN.CAMPUS"),
    F.col("CBM00S_DLRN.OFFSITE_LOC_CD"),
    F.col("CBM00S_DLRN.EXT_LOC_FICE"),
    F.col("CBM00S_DLRN.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_DLRN.REPEAT_CANDIDATE"),
    F.col("CBM00S_DLRN.CLASS_ATTR_LIST"),
    F.col("CBM00S_DLRN.CLASS_VAL_LIST"),
    F.col("CBM00S_DLRN.NCBO"),
    F.col("CBM00S_DLRN.COMBINED_SECTION_ID"),
    F.col("CBM00S_DLRN.CRSE_GRADE_OFF"),
    F.col("CBM00S_DLRN.CRSE_ATTR_LIST"),
    F.col("CBM00S_DLRN.CRSE_VAL_LIST"),
    F.col("CB_Reported_Student"),
    F.col("CB_Reported_Course"),
    F.col("CBM00S_DLRN.Current_Semester_Reportable"),
    F.col("CBM00S_DLRN.Core_Course"),
    F.col("CBM00S_DLRN.Current_Term"),
    F.col("CBM00S_DLRN.Test"),
    F.col("CBM00S_DLRN.MathCore"),
    F.col("CBM00S_DLRN.ReadCore"),
    F.col("CBM00S_DLRN.WriteCore"),
    F.col("CBM00S_DLRN.DLRN_Course"),
    F.col("CBM00S_DLRN.AP_Course"),
)

# COMMAND ----------

# CBM00S_COMBINED_SECTION
cbm00s_cbreported = df_cbm00s_cbreported.alias("CBM00S_CBReported")

df_cbm00s_combined_section = cbm00s_cbreported.filter(
    F.col("CBM00S_CBReported.COMBINED_SECTION_ID").isNotNull()
)

df_cbm00s_combined_section = (
    df_cbm00s_combined_section.select(
        F.col("CBM00S_CBReported.INSTITUTION"),
        F.col("CBM00S_CBReported.STRM"),
        F.col("CBM00S_CBReported.CLASS_NBR"),
        F.col("CBM00S_CBReported.SESSION_CODE"),
        F.col("CBM00S_CBReported.COMBINED_SECTION_ID"),
        F.lit(current_term).alias("Current_Term"),
    )
    .distinct()
    .orderBy(
        F.col("STRM").asc(),
        F.col("SESSION_CODE").asc(),
        F.col("COMBINED_SECTION_ID").asc(),
    )
)

# COMMAND ----------

# Step: CBM00S_COMBINED_ID — SAS retain+first.group counter → dense_rank Window
# Assign a 2-character alpha code (AA-Z9) to each combined section group using dense_rank
# ordered by STRM/SESSION_CODE/COMBINED_SECTION_ID within the current term.
# DATA step: WORK.CBM00S_COMBINED_ID
# The SAS DATA step assigns a sequential 0-based counter per Current_Term ordered by COMBINED_SECTION_ID.
# dense_rank - 1 reproduces the counter. The 2-char code encodes (counter // 36) and (counter % 36) into positions from the ALPHA string "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".

_ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

df_CBM00S_COMBINED_ID = (
    df_cbm00s_combined_section.withColumn(
        "group_num",
        F.dense_rank().over(
            Window.partitionBy(F.col("Current_Term")).orderBy(
                F.col("STRM").asc(),
                F.col("SESSION_CODE").asc(),
                F.col("COMBINED_SECTION_ID").asc(),
            )
        )
        - 1,
    )
    .withColumn("A", F.floor(F.col("group_num") / F.lit(36)) + F.lit(1))
    .withColumn("B", F.pmod(F.col("group_num"), F.lit(36)) + F.lit(1))
    .withColumn(
        "COMBINED_SECTION_CODE",
        F.expr(f"substring('{_ALPHA}', A, 1) || substring('{_ALPHA}', B, 1)"),
    )
    .drop("A", "B", "group_num")
    .orderBy("Current_Term", "STRM", "SESSION_CODE", "COMBINED_SECTION_ID")
)

# COMMAND ----------

# Step: Adding Combined Section Code
# CBM00S_COMBINED_SECTION_CODE

cbm00s_combined_id = df_CBM00S_COMBINED_ID.alias("CBM00S_COMBINED_ID")

df_cbm00s_combined_section_code = cbm00s_cbreported.join(
    cbm00s_combined_id,
    on=(
        (F.col("CBM00S_CBReported.STRM") == F.col("CBM00S_COMBINED_ID.STRM"))
        & (
            F.col("CBM00S_CBReported.SESSION_CODE")
            == F.col("CBM00S_COMBINED_ID.SESSION_CODE")
        )
        & (
            F.col("CBM00S_CBReported.CLASS_NBR")
            == F.col("CBM00S_COMBINED_ID.CLASS_NBR")
        )
        & (
            F.col("CBM00S_CBReported.COMBINED_SECTION_ID")
            == F.col("CBM00S_COMBINED_ID.COMBINED_SECTION_ID")
        )
    ),
    how="left",
)

df_cbm00s_combined_section_code = df_cbm00s_combined_section_code.select(
    F.col("CBM00S_CBReported.ACAD_CAREER"),
    F.col("CBM00S_CBReported.ACAD_PROG"),
    F.col("CBM00S_CBReported.CRSE_CAREER"),
    F.col("CBM00S_CBReported.EMPLID"),
    F.col("CBM00S_CBReported.ENRL_STATUS_REASON"),
    F.col("CBM00S_CBReported.GRADE_CATEGORY"),
    F.col("CBM00S_CBReported.GRADE_POINTS"),
    F.col("CBM00S_CBReported.INSTITUTION"),
    F.col("CBM00S_CBReported.STRM"),
    F.col("CBM00S_CBReported.UNT_EARNED"),
    F.col("CBM00S_CBReported.UNT_PRGRSS"),
    F.col("CBM00S_CBReported.UNT_TAKEN"),
    F.col("CBM00S_CBReported.CLASS_NBR"),
    F.col("CBM00S_CBReported.CLASS_SECTION"),
    F.col("CBM00S_CBReported.CLASS_STAT"),
    F.col("CBM00S_CBReported.CLASS_TYPE"),
    F.col("CBM00S_CBReported.COMBINED_SECTION"),
    F.col("CBM00S_CBReported.CRSE_ID"),
    F.col("CBM00S_CBReported.CRSE_OFFER_NBR"),
    F.col("CBM00S_CBReported.END_DT"),
    F.col("CBM00S_CBReported.INSTRUCTION_MODE"),
    F.col("CBM00S_CBReported.LOCATION"),
    F.col("CBM00S_CBReported.START_DT"),
    F.col("CBM00S_CBReported.SUBJECT"),
    F.col("CBM00S_CBReported.TERM_BEGIN_DT"),
    F.col("CBM00S_CBReported.TERM_END_DT"),
    F.col("CBM00S_CBReported.CENSUS_DT"),
    F.col("CBM00S_CBReported.DLRN_Student"),
    F.col("CBM00S_CBReported.Prior_Term"),
    F.col("CBM00S_CBReported.CB_Exclude"),
    F.col("CBM00S_CBReported.ENRL_TOT"),
    F.col("CBM00S_CBReported.SSR_COMPONENT"),
    F.col("CBM00S_CBReported.COMPONENT_PRIMARY"),
    F.col("CBM00S_CBReported.CRSE_CONTACT_HRS"),
    F.col("CBM00S_CBReported.UNITS_MAXIMUM"),
    F.col("CBM00S_CBReported.SESSION_CODE"),
    F.col("CBM00S_CBReported.Current_Term_End_date"),
    F.col("CBM00S_CBReported.CATALOG_NBR"),
    F.col("CBM00S_CBReported.ACAD_GROUP"),
    F.col("CBM00S_CBReported.ACAD_ORG"),
    F.col("CBM00S_CBReported.CAMPUS"),
    F.col("CBM00S_CBReported.OFFSITE_LOC_CD"),
    F.col("CBM00S_CBReported.EXT_LOC_FICE"),
    F.col("CBM00S_CBReported.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_CBReported.REPEAT_CANDIDATE"),
    F.col("CBM00S_CBReported.CLASS_ATTR_LIST"),
    F.col("CBM00S_CBReported.CLASS_VAL_LIST"),
    F.col("CBM00S_CBReported.NCBO"),
    F.col("CBM00S_CBReported.CRSE_GRADE_OFF"),
    F.col("CBM00S_COMBINED_ID.COMBINED_SECTION_CODE"),
    F.col("CBM00S_CBReported.CRSE_ATTR_LIST"),
    F.col("CBM00S_CBReported.CRSE_VAL_LIST"),
    F.col("CBM00S_CBReported.CB_Reported_Student"),
    F.col("CBM00S_CBReported.CB_Reported_Course"),
    F.col("CBM00S_CBReported.Current_Semester_Reportable"),
    F.col("CBM00S_CBReported.Core_Course"),
    F.col("CBM00S_CBReported.Current_Term"),
    F.col("CBM00S_CBReported.Test"),
    F.col("CBM00S_CBReported.MathCore"),
    F.col("CBM00S_CBReported.ReadCore"),
    F.col("CBM00S_CBReported.WriteCore"),
    F.col("CBM00S_CBReported.DLRN_Course"),
    F.col("CBM00S_CBReported.AP_Course"),
)

# COMMAND ----------

# CBM00S_CHECKTOTALSCH

cbm00s_combined_section_code = df_cbm00s_combined_section_code.alias(
    "CBM00S_COMBINED_SECTION_CODE"
)

df_cbm00s_checktotalsch = cbm00s_combined_section_code.groupBy(
    "EMPLID", "STRM", "ACAD_PROG"
).agg(F.sum(F.col("CBM00S_COMBINED_SECTION_CODE.UNT_TAKEN")).alias("UNT_TAKEN_SEM"))

# COMMAND ----------

# Step: Identify Zero SCH Students
# CBM00S_ZeroSCH

cbm00s_checktotalsch = df_cbm00s_checktotalsch.alias("CBM00S_CHECKTOTALSCH")

df_cbm00s_zerosch = cbm00s_combined_section_code.join(
    cbm00s_checktotalsch,
    on=(
        (
            F.col("CBM00S_COMBINED_SECTION_CODE.STRM")
            == F.col("CBM00S_CHECKTOTALSCH.STRM")
        )
        & (
            F.col("CBM00S_COMBINED_SECTION_CODE.EMPLID")
            == F.col("CBM00S_CHECKTOTALSCH.EMPLID")
        )
        & (
            F.col("CBM00S_COMBINED_SECTION_CODE.ACAD_PROG")
            == F.col("CBM00S_CHECKTOTALSCH.ACAD_PROG")
        )
        & (F.col("CBM00S_CHECKTOTALSCH.UNT_TAKEN_SEM") >= F.lit(1))
    ),
    how="left",
)

df_cbm00s_zerosch = df_cbm00s_zerosch.filter(
    F.col("CBM00S_CHECKTOTALSCH.UNT_TAKEN_SEM") >= F.lit(1)
)

df_cbm00s_zerosch = df_cbm00s_zerosch.select(
    F.col("CBM00S_COMBINED_SECTION_CODE.ACAD_CAREER"),
    F.col("CBM00S_COMBINED_SECTION_CODE.ACAD_PROG"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CRSE_CAREER"),
    F.col("CBM00S_COMBINED_SECTION_CODE.EMPLID"),
    F.col("CBM00S_COMBINED_SECTION_CODE.ENRL_STATUS_REASON"),
    F.col("CBM00S_COMBINED_SECTION_CODE.GRADE_CATEGORY"),
    F.col("CBM00S_COMBINED_SECTION_CODE.GRADE_POINTS"),
    F.col("CBM00S_COMBINED_SECTION_CODE.INSTITUTION"),
    F.col("CBM00S_COMBINED_SECTION_CODE.STRM"),
    F.col("CBM00S_COMBINED_SECTION_CODE.UNT_EARNED"),
    F.col("CBM00S_COMBINED_SECTION_CODE.UNT_PRGRSS"),
    F.col("CBM00S_COMBINED_SECTION_CODE.UNT_TAKEN"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CLASS_NBR"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CLASS_SECTION"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CLASS_STAT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CLASS_TYPE"),
    F.col("CBM00S_COMBINED_SECTION_CODE.COMBINED_SECTION"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CRSE_ID"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CRSE_OFFER_NBR"),
    F.col("CBM00S_COMBINED_SECTION_CODE.END_DT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.INSTRUCTION_MODE"),
    F.col("CBM00S_COMBINED_SECTION_CODE.LOCATION"),
    F.col("CBM00S_COMBINED_SECTION_CODE.START_DT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.SUBJECT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.TERM_BEGIN_DT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.TERM_END_DT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CENSUS_DT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.DLRN_Student"),
    F.col("CBM00S_COMBINED_SECTION_CODE.Prior_Term"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CB_Exclude"),
    F.col("CBM00S_COMBINED_SECTION_CODE.ENRL_TOT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.SSR_COMPONENT"),
    F.col("CBM00S_COMBINED_SECTION_CODE.COMPONENT_PRIMARY"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CRSE_CONTACT_HRS"),
    F.col("CBM00S_COMBINED_SECTION_CODE.UNITS_MAXIMUM"),
    F.col("CBM00S_COMBINED_SECTION_CODE.SESSION_CODE"),
    F.col("CBM00S_COMBINED_SECTION_CODE.Current_Term_End_date"),
    F.col("CBM00S_CHECKTOTALSCH.UNT_TAKEN_SEM"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CATALOG_NBR"),
    F.col("CBM00S_COMBINED_SECTION_CODE.ACAD_GROUP"),
    F.col("CBM00S_COMBINED_SECTION_CODE.ACAD_ORG"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CAMPUS"),
    F.col("CBM00S_COMBINED_SECTION_CODE.OFFSITE_LOC_CD"),
    F.col("CBM00S_COMBINED_SECTION_CODE.EXT_LOC_FICE"),
    F.col("CBM00S_COMBINED_SECTION_CODE.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_COMBINED_SECTION_CODE.REPEAT_CANDIDATE"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CLASS_ATTR_LIST"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CLASS_VAL_LIST"),
    F.col("CBM00S_COMBINED_SECTION_CODE.NCBO"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CRSE_GRADE_OFF"),
    F.col("CBM00S_COMBINED_SECTION_CODE.COMBINED_SECTION_CODE"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CRSE_ATTR_LIST"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CRSE_VAL_LIST"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CB_Reported_Student"),
    F.col("CBM00S_COMBINED_SECTION_CODE.CB_Reported_Course"),
    F.col("CBM00S_COMBINED_SECTION_CODE.Current_Semester_Reportable"),
    F.col("CBM00S_COMBINED_SECTION_CODE.Core_Course"),
    F.col("CBM00S_COMBINED_SECTION_CODE.Current_Term"),
    F.col("CBM00S_COMBINED_SECTION_CODE.MathCore"),
    F.col("CBM00S_COMBINED_SECTION_CODE.ReadCore"),
    F.col("CBM00S_COMBINED_SECTION_CODE.WriteCore"),
    F.col("CBM00S_COMBINED_SECTION_CODE.DLRN_Course"),
    F.col("CBM00S_COMBINED_SECTION_CODE.AP_Course"),
).distinct()

# COMMAND ----------

# Checkpoint 2: materialize df_cbm00s_zerosch to break the upstream DAG
_tmp_stageB_tbl = f"{analytics}.{staging}._tmp_zerosch"
write_df_to_table(
    df_cbm00s_zerosch, _tmp_stageB_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm00s_zerosch = read_table(_tmp_stageB_tbl).alias("CBM00S_ZeroSCH")
log_msg(f"Checkpoint 2 materialized: {_tmp_stageB_tbl}")

# COMMAND ----------

# Step: Acad Plan Info
# CBM00S_max_acad_plan

df_ACAD_PLAN_MAX_EFFSEQ = ps_acad_plan.join(
    ps_acad_plan_owner,
    on=(
        (F.col("PS_ACAD_PLAN.ACAD_PLAN") == F.col("PS_ACAD_PLAN_OWNER.ACAD_PLAN"))
        & (F.col("PS_ACAD_PLAN.EFFDT") >= F.col("PS_ACAD_PLAN_OWNER.EFFDT"))
    ),
    how="inner",
).join(
    adw_dept_dim,
    on=(
        (F.col("ADW_DEPT_DIM.is_current") == F.lit(True))
        & (F.col("PS_ACAD_PLAN_OWNER.ACAD_ORG") == F.col("ADW_DEPT_DIM.DEPT"))
    ),
    how="inner",
)

df_ACAD_PLAN_MAX_EFFSEQ = df_ACAD_PLAN_MAX_EFFSEQ.withColumn(
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
    F.coalesce(F.col("PS_ACAD_PLAN.EFFSEQ"), F.lit(""))
    == F.coalesce(F.col("_agg_tmp_0"), F.lit(""))
).drop("_agg_tmp_0")

df_ACAD_PLAN_MAX_EFFSEQ = df_ACAD_PLAN_MAX_EFFSEQ.select(
    F.col("PS_ACAD_PLAN.EMPLID"),
    F.col("PS_ACAD_PLAN.ACAD_CAREER"),
    F.col("PS_ACAD_PLAN.STDNT_CAR_NBR"),
    F.col("PS_ACAD_PLAN.EFFDT"),
    F.col("PS_ACAD_PLAN.EFFSEQ"),
    F.col("PS_ACAD_PLAN.ACAD_PLAN"),
    F.col("PS_ACAD_PLAN.DECLARE_DT"),
    F.col("PS_ACAD_PLAN.PLAN_SEQUENCE"),
    F.col("PS_ACAD_PLAN.REQ_TERM"),
    F.col("PS_ACAD_PLAN.COMPLETION_TERM"),
    F.col("PS_ACAD_PLAN.STDNT_DEGR"),
    F.col("PS_ACAD_PLAN.DEGR_CHKOUT_STAT"),
    F.col("PS_ACAD_PLAN.ADVIS_STATUS"),
    F.col("PS_ACAD_PLAN.SSR_APT_INSTANCE"),
    F.col("PS_ACAD_PLAN.SSR_YR_OF_PROG"),
    F.col("PS_ACAD_PLAN.SCC_ROW_ADD_OPRID"),
    F.col("PS_ACAD_PLAN.SCC_ROW_ADD_DTTM"),
    F.col("PS_ACAD_PLAN.SCC_ROW_UPD_OPRID"),
    F.col("PS_ACAD_PLAN.SCC_ROW_UPD_DTTM"),
).distinct()

# COMMAND ----------

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
    F.coalesce(F.col("ACAD_PLAN_MAX_EFFSEQ.PLAN_SEQUENCE"), F.lit(""))
    == F.coalesce(F.col("_agg_tmp_0"), F.lit(""))
).drop("_agg_tmp_0")

# COMMAND ----------

df_cbm00s_max_acad_plan = df_cbm00s_zerosch.alias("CBM00S_ZeroSCH")
acad_plan_min_planseq = df_ACAD_PLAN_MIN_PLANSEQ.alias("ACAD_PLAN_MIN_PLANSEQ")

df_cbm00s_max_acad_plan = df_cbm00s_max_acad_plan.join(
    acad_plan_min_planseq,
    on=(
        (F.col("CBM00S_ZeroSCH.EMPLID") == F.col("ACAD_PLAN_MIN_PLANSEQ.EMPLID"))
        & (
            F.col("CBM00S_ZeroSCH.ACAD_CAREER")
            == F.col("ACAD_PLAN_MIN_PLANSEQ.ACAD_CAREER")
        )
        & (
            F.col("CBM00S_ZeroSCH.Current_Term_End_date")
            >= F.col("ACAD_PLAN_MIN_PLANSEQ.EFFDT")
        )
    ),
    how="left",
)

df_cbm00s_max_acad_plan = df_cbm00s_max_acad_plan.withColumn(
    "_agg_tmp_0",
    F.max(
        F.date_format(F.col("ACAD_PLAN_MIN_PLANSEQ.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    ).over(
        Window.partitionBy(
            "CBM00S_ZeroSCH.STRM",
            "CBM00S_ZeroSCH.EMPLID",
            "CBM00S_ZeroSCH.ACAD_CAREER",
            "ACAD_PLAN_MIN_PLANSEQ.STDNT_CAR_NBR",
        )
    ),
)
df_cbm00s_max_acad_plan = df_cbm00s_max_acad_plan.filter(
    F.date_format(F.col("ACAD_PLAN_MIN_PLANSEQ.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm00s_max_acad_plan = df_cbm00s_max_acad_plan.select(
    F.col("CBM00S_ZeroSCH.ACAD_CAREER"),
    F.col("CBM00S_ZeroSCH.ACAD_PROG"),
    F.col("CBM00S_ZeroSCH.CRSE_CAREER"),
    F.col("CBM00S_ZeroSCH.EMPLID"),
    F.col("CBM00S_ZeroSCH.ENRL_STATUS_REASON"),
    F.col("CBM00S_ZeroSCH.GRADE_CATEGORY"),
    F.col("CBM00S_ZeroSCH.GRADE_POINTS"),
    F.col("CBM00S_ZeroSCH.INSTITUTION"),
    F.col("CBM00S_ZeroSCH.STRM"),
    F.col("CBM00S_ZeroSCH.UNT_EARNED"),
    F.col("CBM00S_ZeroSCH.UNT_PRGRSS"),
    F.col("CBM00S_ZeroSCH.UNT_TAKEN"),
    F.col("CBM00S_ZeroSCH.CLASS_NBR"),
    F.col("CBM00S_ZeroSCH.CLASS_SECTION"),
    F.col("CBM00S_ZeroSCH.CLASS_STAT"),
    F.col("CBM00S_ZeroSCH.CLASS_TYPE"),
    F.col("CBM00S_ZeroSCH.COMBINED_SECTION"),
    F.col("CBM00S_ZeroSCH.CRSE_ID"),
    F.col("CBM00S_ZeroSCH.CRSE_OFFER_NBR"),
    F.col("CBM00S_ZeroSCH.END_DT"),
    F.col("CBM00S_ZeroSCH.INSTRUCTION_MODE"),
    F.col("CBM00S_ZeroSCH.LOCATION"),
    F.col("CBM00S_ZeroSCH.START_DT"),
    F.col("CBM00S_ZeroSCH.SUBJECT"),
    F.col("CBM00S_ZeroSCH.TERM_BEGIN_DT"),
    F.col("CBM00S_ZeroSCH.TERM_END_DT"),
    F.col("CBM00S_ZeroSCH.CENSUS_DT"),
    F.col("CBM00S_ZeroSCH.DLRN_Student"),
    F.col("CBM00S_ZeroSCH.Prior_Term"),
    F.col("CBM00S_ZeroSCH.CB_Exclude"),
    F.col("CBM00S_ZeroSCH.ENRL_TOT"),
    F.col("CBM00S_ZeroSCH.SSR_COMPONENT"),
    F.col("CBM00S_ZeroSCH.COMPONENT_PRIMARY"),
    F.col("CBM00S_ZeroSCH.CRSE_CONTACT_HRS"),
    F.col("CBM00S_ZeroSCH.UNITS_MAXIMUM"),
    F.col("CBM00S_ZeroSCH.SESSION_CODE"),
    F.col("CBM00S_ZeroSCH.Current_Term_End_date"),
    F.col("CBM00S_ZeroSCH.UNT_TAKEN_SEM"),
    F.col("CBM00S_ZeroSCH.CATALOG_NBR"),
    F.col("CBM00S_ZeroSCH.ACAD_GROUP"),
    F.col("CBM00S_ZeroSCH.ACAD_ORG"),
    F.col("CBM00S_ZeroSCH.CAMPUS"),
    F.col("CBM00S_ZeroSCH.OFFSITE_LOC_CD"),
    F.col("CBM00S_ZeroSCH.EXT_LOC_FICE"),
    F.col("CBM00S_ZeroSCH.UTA_CB_LOCATION_CD"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.STDNT_CAR_NBR"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.EFFDT"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.EFFSEQ"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.ACAD_PLAN"),
    F.col("ACAD_PLAN_MIN_PLANSEQ.REQ_TERM"),
    F.col("CBM00S_ZeroSCH.REPEAT_CANDIDATE"),
    F.col("CBM00S_ZeroSCH.CLASS_ATTR_LIST"),
    F.col("CBM00S_ZeroSCH.CLASS_VAL_LIST"),
    F.col("CBM00S_ZeroSCH.NCBO"),
    F.col("CBM00S_ZeroSCH.CRSE_GRADE_OFF"),
    F.col("CBM00S_ZeroSCH.COMBINED_SECTION_CODE"),
    F.col("CBM00S_ZeroSCH.CRSE_ATTR_LIST"),
    F.col("CBM00S_ZeroSCH.CRSE_VAL_LIST"),
    F.col("CBM00S_ZeroSCH.CB_Reported_Student"),
    F.col("CBM00S_ZeroSCH.CB_Reported_Course"),
    F.col("CBM00S_ZeroSCH.Current_Semester_Reportable"),
    F.col("CBM00S_ZeroSCH.Core_Course"),
    F.col("CBM00S_ZeroSCH.Current_Term"),
    F.col("CBM00S_ZeroSCH.MathCore"),
    F.col("CBM00S_ZeroSCH.ReadCore"),
    F.col("CBM00S_ZeroSCH.WriteCore"),
    F.col("CBM00S_ZeroSCH.DLRN_Course"),
    F.col("CBM00S_ZeroSCH.AP_Course"),
).distinct()

# COMMAND ----------

# Step: AcadPlan_tbl
# CBM00S_acad_plan
df_cbm00s_acad_plan = df_cbm00s_max_acad_plan.alias("CBM00S_MAX_ACAD_PLAN")

df_cbm00s_acad_plan = df_cbm00s_acad_plan.join(
    ps_acad_plan_tbl,
    on=(
        (F.col("CBM00S_MAX_ACAD_PLAN.ACAD_PLAN") == F.col("PS_ACAD_PLAN_TBL.ACAD_PLAN"))
        & (
            F.col("CBM00S_MAX_ACAD_PLAN.Current_Term_End_date")
            >= F.col("PS_ACAD_PLAN_TBL.EFFDT")
        )
    ),
    how="inner",
)

df_cbm00s_acad_plan = df_cbm00s_acad_plan.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("PS_ACAD_PLAN_TBL.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "CBM00S_MAX_ACAD_PLAN.ACAD_PLAN", "CBM00S_MAX_ACAD_PLAN.TERM_END_DT"
        )
    ),
)

df_cbm00s_acad_plan = df_cbm00s_acad_plan.filter(
    F.date_format(F.col("PS_ACAD_PLAN_TBL.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_cbm00s_acad_plan = df_cbm00s_acad_plan.select(
    F.col("CBM00S_MAX_ACAD_PLAN.ACAD_CAREER"),
    F.col("CBM00S_MAX_ACAD_PLAN.ACAD_PROG"),
    F.col("CBM00S_MAX_ACAD_PLAN.CRSE_CAREER"),
    F.col("CBM00S_MAX_ACAD_PLAN.EMPLID"),
    F.col("CBM00S_MAX_ACAD_PLAN.ENRL_STATUS_REASON"),
    F.col("CBM00S_MAX_ACAD_PLAN.GRADE_CATEGORY"),
    F.col("CBM00S_MAX_ACAD_PLAN.GRADE_POINTS"),
    F.col("CBM00S_MAX_ACAD_PLAN.INSTITUTION"),
    F.col("CBM00S_MAX_ACAD_PLAN.STRM"),
    F.col("CBM00S_MAX_ACAD_PLAN.UNT_EARNED"),
    F.col("CBM00S_MAX_ACAD_PLAN.UNT_PRGRSS"),
    F.col("CBM00S_MAX_ACAD_PLAN.UNT_TAKEN"),
    F.col("CBM00S_MAX_ACAD_PLAN.CLASS_NBR"),
    F.col("CBM00S_MAX_ACAD_PLAN.CLASS_SECTION"),
    F.col("CBM00S_MAX_ACAD_PLAN.CLASS_STAT"),
    F.col("CBM00S_MAX_ACAD_PLAN.CLASS_TYPE"),
    F.col("CBM00S_MAX_ACAD_PLAN.COMBINED_SECTION"),
    F.col("CBM00S_MAX_ACAD_PLAN.CRSE_ID"),
    F.col("CBM00S_MAX_ACAD_PLAN.CRSE_OFFER_NBR"),
    F.col("CBM00S_MAX_ACAD_PLAN.END_DT"),
    F.col("CBM00S_MAX_ACAD_PLAN.INSTRUCTION_MODE"),
    F.col("CBM00S_MAX_ACAD_PLAN.LOCATION"),
    F.col("CBM00S_MAX_ACAD_PLAN.START_DT"),
    F.col("CBM00S_MAX_ACAD_PLAN.SUBJECT"),
    F.col("CBM00S_MAX_ACAD_PLAN.TERM_BEGIN_DT"),
    F.col("CBM00S_MAX_ACAD_PLAN.TERM_END_DT"),
    F.col("CBM00S_MAX_ACAD_PLAN.CENSUS_DT"),
    F.col("CBM00S_MAX_ACAD_PLAN.DLRN_Student"),
    F.col("CBM00S_MAX_ACAD_PLAN.Prior_Term"),
    F.col("CBM00S_MAX_ACAD_PLAN.CB_Exclude"),
    F.col("CBM00S_MAX_ACAD_PLAN.ENRL_TOT"),
    F.col("CBM00S_MAX_ACAD_PLAN.SSR_COMPONENT"),
    F.col("CBM00S_MAX_ACAD_PLAN.COMPONENT_PRIMARY"),
    F.col("CBM00S_MAX_ACAD_PLAN.CRSE_CONTACT_HRS"),
    F.col("CBM00S_MAX_ACAD_PLAN.UNITS_MAXIMUM"),
    F.col("CBM00S_MAX_ACAD_PLAN.SESSION_CODE"),
    F.col("CBM00S_MAX_ACAD_PLAN.Current_Term_End_date"),
    F.col("CBM00S_MAX_ACAD_PLAN.UNT_TAKEN_SEM"),
    F.col("CBM00S_MAX_ACAD_PLAN.CATALOG_NBR"),
    F.col("CBM00S_MAX_ACAD_PLAN.ACAD_GROUP"),
    F.col("CBM00S_MAX_ACAD_PLAN.ACAD_ORG"),
    F.col("CBM00S_MAX_ACAD_PLAN.CAMPUS"),
    F.col("CBM00S_MAX_ACAD_PLAN.OFFSITE_LOC_CD"),
    F.col("CBM00S_MAX_ACAD_PLAN.EXT_LOC_FICE"),
    F.col("CBM00S_MAX_ACAD_PLAN.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_MAX_ACAD_PLAN.STDNT_CAR_NBR"),
    F.col("CBM00S_MAX_ACAD_PLAN.EFFDT"),
    F.col("CBM00S_MAX_ACAD_PLAN.EFFSEQ"),
    F.col("CBM00S_MAX_ACAD_PLAN.ACAD_PLAN"),
    F.col("CBM00S_MAX_ACAD_PLAN.REQ_TERM"),
    F.col("PS_ACAD_PLAN_TBL.EFFDT").alias("PLAN_TBL_EFFDT"),
    F.col("PS_ACAD_PLAN_TBL.ACAD_PROG").alias("PLAN_TBL_ACAD_PROG"),
    F.col("PS_ACAD_PLAN_TBL.ACAD_PLAN_TYPE"),
    F.col("CBM00S_MAX_ACAD_PLAN.REPEAT_CANDIDATE"),
    F.col("CBM00S_MAX_ACAD_PLAN.CLASS_ATTR_LIST"),
    F.col("CBM00S_MAX_ACAD_PLAN.CLASS_VAL_LIST"),
    F.col("CBM00S_MAX_ACAD_PLAN.NCBO"),
    F.col("CBM00S_MAX_ACAD_PLAN.CRSE_GRADE_OFF"),
    F.col("CBM00S_MAX_ACAD_PLAN.COMBINED_SECTION_CODE"),
    F.col("CBM00S_MAX_ACAD_PLAN.CRSE_ATTR_LIST"),
    F.col("CBM00S_MAX_ACAD_PLAN.CRSE_VAL_LIST"),
    F.col("CBM00S_MAX_ACAD_PLAN.CB_Reported_Student"),
    F.col("CBM00S_MAX_ACAD_PLAN.CB_Reported_Course"),
    F.col("CBM00S_MAX_ACAD_PLAN.Current_Semester_Reportable"),
    F.col("CBM00S_MAX_ACAD_PLAN.Core_Course"),
    F.col("CBM00S_MAX_ACAD_PLAN.Current_Term"),
    F.col("CBM00S_MAX_ACAD_PLAN.MathCore"),
    F.col("CBM00S_MAX_ACAD_PLAN.ReadCore"),
    F.col("CBM00S_MAX_ACAD_PLAN.WriteCore"),
    F.col("CBM00S_MAX_ACAD_PLAN.DLRN_Course"),
    F.col("CBM00S_MAX_ACAD_PLAN.AP_Course"),
)

# COMMAND ----------

# MaxAcadProg

df_Max_Effdt_PlanSeq = ps_acad_prog.withColumn(
    "_agg_tmp_0",
    F.max(F.col("PS_ACAD_PROG.EFFSEQ")).over(
        Window.partitionBy(
            "PS_ACAD_PROG.EMPLID",
            "PS_ACAD_PROG.ACAD_CAREER",
            "PS_ACAD_PROG.STDNT_CAR_NBR",
            "PS_ACAD_PROG.EFFDT",
        )
    ),
)

df_Max_Effdt_PlanSeq = df_Max_Effdt_PlanSeq.filter(
    F.coalesce(F.col("PS_ACAD_PROG.EFFSEQ"), F.lit(""))
    == F.coalesce(F.col("_agg_tmp_0"), F.lit(""))
).drop("_agg_tmp_0")

# COMMAND ----------

df_maxacadprog = df_Max_Effdt_PlanSeq.alias("Max_Effdt_PlanSeq")

df_maxacadprog = df_maxacadprog.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("Max_Effdt_PlanSeq.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "Max_Effdt_PlanSeq.EMPLID",
            "Max_Effdt_PlanSeq.ACAD_CAREER",
            "Max_Effdt_PlanSeq.STDNT_CAR_NBR",
        )
    ),
)

df_maxacadprog = df_maxacadprog.filter(
    F.date_format(F.col("Max_Effdt_PlanSeq.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

df_maxacadprog = df_maxacadprog.select(
    F.col("Max_Effdt_PlanSeq.EMPLID"),
    F.col("Max_Effdt_PlanSeq.ACAD_CAREER"),
    F.col("Max_Effdt_PlanSeq.STDNT_CAR_NBR"),
    F.col("Max_Effdt_PlanSeq.EFFDT"),
    F.col("Max_Effdt_PlanSeq.EFFSEQ"),
    F.col("Max_Effdt_PlanSeq.INSTITUTION"),
    F.col("Max_Effdt_PlanSeq.ACAD_PROG"),
    F.col("Max_Effdt_PlanSeq.PROG_STATUS"),
    F.col("Max_Effdt_PlanSeq.PROG_ACTION"),
    F.col("Max_Effdt_PlanSeq.ACTION_DT"),
    F.col("Max_Effdt_PlanSeq.PROG_REASON"),
    F.col("Max_Effdt_PlanSeq.ADMIT_TERM"),
    F.col("Max_Effdt_PlanSeq.EXP_GRAD_TERM"),
    F.col("Max_Effdt_PlanSeq.REQ_TERM"),
    F.col("Max_Effdt_PlanSeq.ACAD_LOAD_APPR"),
    F.col("Max_Effdt_PlanSeq.CAMPUS"),
    F.col("Max_Effdt_PlanSeq.DEGR_CHKOUT_STAT"),
    F.col("Max_Effdt_PlanSeq.COMPLETION_TERM"),
    F.col("Max_Effdt_PlanSeq.ACAD_PROG_DUAL"),
    F.col("Max_Effdt_PlanSeq.JOINT_PROG_APPR"),
    F.col("Max_Effdt_PlanSeq.ADM_APPL_NBR"),
    F.col("Max_Effdt_PlanSeq.APPL_PROG_NBR"),
    F.col("Max_Effdt_PlanSeq.DATA_FROM_ADM_APPL"),
    F.col("Max_Effdt_PlanSeq.SSR_RS_CANDIT_NBR"),
    F.col("Max_Effdt_PlanSeq.SSR_APT_INSTANCE"),
    F.col("Max_Effdt_PlanSeq.SSR_YR_OF_PROG"),
    F.col("Max_Effdt_PlanSeq.SSR_SHIFT"),
    F.col("Max_Effdt_PlanSeq.SSR_COHORT_ID"),
    F.col("Max_Effdt_PlanSeq.SCC_ROW_ADD_OPRID"),
    F.col("Max_Effdt_PlanSeq.SCC_ROW_ADD_DTTM"),
    F.col("Max_Effdt_PlanSeq.SCC_ROW_UPD_OPRID"),
    F.col("Max_Effdt_PlanSeq.SCC_ROW_UPD_DTTM"),
)

# COMMAND ----------

# Step: Plan Owner, Carterm
# CBM00S_ACAD_PLAN_INFO
cbm00s_acad_plan = df_cbm00s_acad_plan.alias("CBM00S_acad_plan")
maxacadprog = df_maxacadprog.alias("MaxAcadProg")

df_cbm00s_acad_plan_info = cbm00s_acad_plan.join(
    maxacadprog,
    on=(
        (F.col("CBM00S_acad_plan.EMPLID") == F.col("MaxAcadProg.EMPLID"))
        & (F.col("CBM00S_acad_plan.ACAD_CAREER") == F.col("MaxAcadProg.ACAD_CAREER"))
        & (
            F.col("CBM00S_acad_plan.STDNT_CAR_NBR")
            == F.col("MaxAcadProg.STDNT_CAR_NBR")
        )
    ),
    how="inner",
).join(
    ps_stdnt_car_term,
    on=(
        (F.col("CBM00S_acad_plan.EMPLID") == F.col("PS_STDNT_CAR_TERM.EMPLID"))
        & (F.col("CBM00S_acad_plan.STRM") == F.col("PS_STDNT_CAR_TERM.STRM"))
        & (
            F.col("CBM00S_acad_plan.ACAD_CAREER")
            == F.col("PS_STDNT_CAR_TERM.ACAD_CAREER")
        )
        & (
            F.col("CBM00S_acad_plan.STDNT_CAR_NBR")
            == F.col("PS_STDNT_CAR_TERM.STDNT_CAR_NBR")
        )
    ),
    how="inner",
)

df_cbm00s_acad_plan_info = df_cbm00s_acad_plan_info.filter(
    F.col("PS_STDNT_CAR_TERM.ACAD_PROG_PRIMARY").isNotNull()
)

df_cbm00s_acad_plan_info = (
    df_cbm00s_acad_plan_info.withColumn(
        "_sel_tmp_0_0",
        F.approx_count_distinct(F.col("CBM00S_acad_plan.CLASS_NBR")).over(
            Window.partitionBy()
        ),
    )
    .withColumn(
        "ADDL_ENRL",
        F.when((F.col("_sel_tmp_0_0") > F.lit(1)), F.lit("Y")).otherwise(F.lit("N")),
    )
    .drop("_sel_tmp_0_0")
)

# COMMAND ----------

df_cbm00s_acad_plan_info = df_cbm00s_acad_plan_info.select(
    F.col("CBM00S_acad_plan.ACAD_CAREER"),
    F.col("CBM00S_acad_plan.ACAD_PROG"),
    F.col("CBM00S_acad_plan.CRSE_CAREER"),
    F.col("CBM00S_acad_plan.EMPLID"),
    F.col("CBM00S_acad_plan.ENRL_STATUS_REASON"),
    F.col("CBM00S_acad_plan.GRADE_CATEGORY"),
    F.col("CBM00S_acad_plan.GRADE_POINTS"),
    F.col("CBM00S_acad_plan.INSTITUTION"),
    F.col("CBM00S_acad_plan.STRM"),
    F.col("CBM00S_acad_plan.UNT_EARNED"),
    F.col("CBM00S_acad_plan.UNT_PRGRSS"),
    F.col("CBM00S_acad_plan.UNT_TAKEN"),
    F.col("CBM00S_acad_plan.CLASS_NBR"),
    F.col("CBM00S_acad_plan.CLASS_SECTION"),
    F.col("CBM00S_acad_plan.CLASS_STAT"),
    F.col("CBM00S_acad_plan.CLASS_TYPE"),
    F.col("CBM00S_acad_plan.COMBINED_SECTION"),
    F.col("CBM00S_acad_plan.CRSE_ID"),
    F.col("CBM00S_acad_plan.CRSE_OFFER_NBR"),
    F.col("CBM00S_acad_plan.END_DT"),
    F.col("CBM00S_acad_plan.INSTRUCTION_MODE"),
    F.col("CBM00S_acad_plan.LOCATION"),
    F.col("CBM00S_acad_plan.START_DT"),
    F.col("CBM00S_acad_plan.SUBJECT"),
    F.col("CBM00S_acad_plan.TERM_BEGIN_DT"),
    F.col("CBM00S_acad_plan.TERM_END_DT"),
    F.col("CBM00S_acad_plan.CENSUS_DT"),
    F.col("CBM00S_acad_plan.DLRN_Student"),
    F.col("CBM00S_acad_plan.Prior_Term"),
    F.col("CBM00S_acad_plan.CB_Exclude"),
    F.col("CBM00S_acad_plan.ENRL_TOT"),
    F.col("CBM00S_acad_plan.SSR_COMPONENT"),
    F.col("CBM00S_acad_plan.COMPONENT_PRIMARY"),
    F.col("CBM00S_acad_plan.CRSE_CONTACT_HRS"),
    F.col("CBM00S_acad_plan.UNITS_MAXIMUM"),
    F.col("CBM00S_acad_plan.SESSION_CODE"),
    F.col("CBM00S_acad_plan.Current_Term_End_date"),
    F.col("CBM00S_acad_plan.UNT_TAKEN_SEM"),
    F.col("CBM00S_acad_plan.CATALOG_NBR"),
    F.col("CBM00S_acad_plan.ACAD_GROUP"),
    F.lit(None).alias("ACAD_ORG"),
    F.col("CBM00S_acad_plan.CAMPUS"),
    F.col("CBM00S_acad_plan.OFFSITE_LOC_CD"),
    F.col("CBM00S_acad_plan.EXT_LOC_FICE"),
    F.col("CBM00S_acad_plan.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_acad_plan.STDNT_CAR_NBR"),
    F.col("CBM00S_acad_plan.EFFDT"),
    F.col("CBM00S_acad_plan.EFFSEQ"),
    F.col("CBM00S_acad_plan.ACAD_PLAN"),
    F.col("CBM00S_acad_plan.REQ_TERM"),
    F.col("CBM00S_acad_plan.PLAN_TBL_EFFDT"),
    F.col("CBM00S_acad_plan.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_acad_plan.ACAD_PLAN_TYPE"),
    F.col("MaxAcadProg.ADMIT_TERM"),
    F.col("MaxAcadProg.DEGR_CHKOUT_STAT"),
    F.col("PS_STDNT_CAR_TERM.ACAD_LEVEL_BOT"),
    F.col("PS_STDNT_CAR_TERM.ACAD_LEVEL_EOT"),
    F.col("PS_STDNT_CAR_TERM.ACAD_PROG_PRIMARY"),
    F.col("PS_STDNT_CAR_TERM.TOT_CUMULATIVE"),
    F.col("CBM00S_acad_plan.REPEAT_CANDIDATE"),
    F.col("ADDL_ENRL"),
    F.col("CBM00S_acad_plan.CLASS_ATTR_LIST"),
    F.col("CBM00S_acad_plan.CLASS_VAL_LIST"),
    F.col("CBM00S_acad_plan.NCBO"),
    F.col("CBM00S_acad_plan.CRSE_GRADE_OFF"),
    F.col("CBM00S_acad_plan.COMBINED_SECTION_CODE"),
    F.col("CBM00S_acad_plan.CRSE_ATTR_LIST"),
    F.col("CBM00S_acad_plan.CRSE_VAL_LIST"),
    F.col("CBM00S_acad_plan.CB_Reported_Student"),
    F.col("CBM00S_acad_plan.CB_Reported_Course"),
    F.col("CBM00S_acad_plan.Current_Semester_Reportable"),
    F.col("CBM00S_acad_plan.Core_Course"),
    F.col("CBM00S_acad_plan.Current_Term"),
    F.col("CBM00S_acad_plan.MathCore"),
    F.col("CBM00S_acad_plan.ReadCore"),
    F.col("CBM00S_acad_plan.WriteCore"),
    F.col("CBM00S_acad_plan.DLRN_Course"),
    F.col("CBM00S_acad_plan.AP_Course"),
)

# COMMAND ----------

# Step: Student class level for Flex
# CBMS_FLEX_STUDENT_LEVEL
df_cbms_flex_student_level = df_cbm00s_acad_plan_info.alias("CBM00S_ACAD_PLAN_INFO")

df_cbms_flex_student_level = df_cbms_flex_student_level.join(
    ps_stdnt_car_term,
    on=(
        (
            F.col("CBM00S_ACAD_PLAN_INFO.STRM")
            != F.col("CBM00S_ACAD_PLAN_INFO.Current_Term")
        )
        & (F.col("CBM00S_ACAD_PLAN_INFO.EMPLID") == F.col("PS_STDNT_CAR_TERM.EMPLID"))
        & (
            F.col("CBM00S_ACAD_PLAN_INFO.Current_Term")
            == F.col("PS_STDNT_CAR_TERM.STRM")
        )
        & (
            F.col("CBM00S_ACAD_PLAN_INFO.ACAD_CAREER")
            == F.col("PS_STDNT_CAR_TERM.ACAD_CAREER")
        )
    ),
    how="left",
)

df_cbms_flex_student_level = df_cbms_flex_student_level.withColumn(
    "ACAD_LEVEL_BOT_NEW",
    F.when(
        (
            F.col("PS_STDNT_CAR_TERM.EMPLID").isNotNull()
            & (F.trim(F.col("PS_STDNT_CAR_TERM.EMPLID")) != F.lit(""))
        ),
        F.col("PS_STDNT_CAR_TERM.ACAD_LEVEL_BOT"),
    ).otherwise(F.col("CBM00S_ACAD_PLAN_INFO.ACAD_LEVEL_BOT")),
)

df_cbms_flex_student_level = df_cbms_flex_student_level.withColumn(
    "ACAD_LEVEL_EOT_NEW",
    F.when(
        (
            F.col("PS_STDNT_CAR_TERM.EMPLID").isNotNull()
            & (F.trim(F.col("PS_STDNT_CAR_TERM.EMPLID")) != F.lit(""))
        ),
        F.col("PS_STDNT_CAR_TERM.ACAD_LEVEL_EOT"),
    ).otherwise(F.col("CBM00S_ACAD_PLAN_INFO.ACAD_LEVEL_EOT")),
)

# COMMAND ----------

df_cbms_flex_student_level = df_cbms_flex_student_level.select(
    F.col("CBM00S_ACAD_PLAN_INFO.ACAD_CAREER"),
    F.col("CBM00S_ACAD_PLAN_INFO.ACAD_PROG"),
    F.col("CBM00S_ACAD_PLAN_INFO.CRSE_CAREER"),
    F.col("CBM00S_ACAD_PLAN_INFO.EMPLID"),
    F.col("CBM00S_ACAD_PLAN_INFO.ENRL_STATUS_REASON"),
    F.col("CBM00S_ACAD_PLAN_INFO.GRADE_CATEGORY"),
    F.col("CBM00S_ACAD_PLAN_INFO.GRADE_POINTS"),
    F.col("CBM00S_ACAD_PLAN_INFO.INSTITUTION"),
    F.col("CBM00S_ACAD_PLAN_INFO.STRM"),
    F.col("CBM00S_ACAD_PLAN_INFO.UNT_EARNED"),
    F.col("CBM00S_ACAD_PLAN_INFO.UNT_PRGRSS"),
    F.col("CBM00S_ACAD_PLAN_INFO.UNT_TAKEN"),
    F.col("CBM00S_ACAD_PLAN_INFO.CLASS_NBR"),
    F.col("CBM00S_ACAD_PLAN_INFO.CLASS_SECTION"),
    F.col("CBM00S_ACAD_PLAN_INFO.CLASS_STAT"),
    F.col("CBM00S_ACAD_PLAN_INFO.CLASS_TYPE"),
    F.col("CBM00S_ACAD_PLAN_INFO.COMBINED_SECTION"),
    F.col("CBM00S_ACAD_PLAN_INFO.CRSE_ID"),
    F.col("CBM00S_ACAD_PLAN_INFO.CRSE_OFFER_NBR"),
    F.col("CBM00S_ACAD_PLAN_INFO.END_DT"),
    F.col("CBM00S_ACAD_PLAN_INFO.INSTRUCTION_MODE"),
    F.col("CBM00S_ACAD_PLAN_INFO.LOCATION"),
    F.col("CBM00S_ACAD_PLAN_INFO.START_DT"),
    F.col("CBM00S_ACAD_PLAN_INFO.SUBJECT"),
    F.col("CBM00S_ACAD_PLAN_INFO.TERM_BEGIN_DT"),
    F.col("CBM00S_ACAD_PLAN_INFO.TERM_END_DT"),
    F.col("CBM00S_ACAD_PLAN_INFO.CENSUS_DT"),
    F.col("CBM00S_ACAD_PLAN_INFO.DLRN_Student"),
    F.col("CBM00S_ACAD_PLAN_INFO.Prior_Term"),
    F.col("CBM00S_ACAD_PLAN_INFO.CB_Exclude"),
    F.col("CBM00S_ACAD_PLAN_INFO.ENRL_TOT"),
    F.col("CBM00S_ACAD_PLAN_INFO.SSR_COMPONENT"),
    F.col("CBM00S_ACAD_PLAN_INFO.COMPONENT_PRIMARY"),
    F.col("CBM00S_ACAD_PLAN_INFO.CRSE_CONTACT_HRS"),
    F.col("CBM00S_ACAD_PLAN_INFO.UNITS_MAXIMUM"),
    F.col("CBM00S_ACAD_PLAN_INFO.SESSION_CODE"),
    F.col("CBM00S_ACAD_PLAN_INFO.Current_Term_End_date"),
    F.col("CBM00S_ACAD_PLAN_INFO.UNT_TAKEN_SEM"),
    F.col("CBM00S_ACAD_PLAN_INFO.CATALOG_NBR"),
    F.col("CBM00S_ACAD_PLAN_INFO.ACAD_GROUP"),
    F.col("CBM00S_ACAD_PLAN_INFO.ACAD_ORG"),
    F.col("CBM00S_ACAD_PLAN_INFO.CAMPUS"),
    F.col("CBM00S_ACAD_PLAN_INFO.OFFSITE_LOC_CD"),
    F.col("CBM00S_ACAD_PLAN_INFO.EXT_LOC_FICE"),
    F.col("CBM00S_ACAD_PLAN_INFO.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_ACAD_PLAN_INFO.STDNT_CAR_NBR"),
    F.col("CBM00S_ACAD_PLAN_INFO.EFFDT"),
    F.col("CBM00S_ACAD_PLAN_INFO.EFFSEQ"),
    F.col("CBM00S_ACAD_PLAN_INFO.ACAD_PLAN"),
    F.col("CBM00S_ACAD_PLAN_INFO.REQ_TERM"),
    F.col("CBM00S_ACAD_PLAN_INFO.PLAN_TBL_EFFDT"),
    F.col("CBM00S_ACAD_PLAN_INFO.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_ACAD_PLAN_INFO.ACAD_PLAN_TYPE"),
    F.col("CBM00S_ACAD_PLAN_INFO.ADMIT_TERM"),
    F.col("CBM00S_ACAD_PLAN_INFO.DEGR_CHKOUT_STAT"),
    F.col("ACAD_LEVEL_BOT_NEW").alias("ACAD_LEVEL_BOT"),
    F.col("ACAD_LEVEL_EOT_NEW").alias("ACAD_LEVEL_EOT"),
    F.col("CBM00S_ACAD_PLAN_INFO.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_ACAD_PLAN_INFO.TOT_CUMULATIVE"),
    F.col("CBM00S_ACAD_PLAN_INFO.REPEAT_CANDIDATE"),
    F.col("CBM00S_ACAD_PLAN_INFO.ADDL_ENRL"),
    F.col("CBM00S_ACAD_PLAN_INFO.CLASS_ATTR_LIST"),
    F.col("CBM00S_ACAD_PLAN_INFO.CLASS_VAL_LIST"),
    F.col("CBM00S_ACAD_PLAN_INFO.NCBO"),
    F.col("CBM00S_ACAD_PLAN_INFO.CRSE_GRADE_OFF"),
    F.col("CBM00S_ACAD_PLAN_INFO.COMBINED_SECTION_CODE"),
    F.col("CBM00S_ACAD_PLAN_INFO.CRSE_ATTR_LIST"),
    F.col("CBM00S_ACAD_PLAN_INFO.CRSE_VAL_LIST"),
    F.col("CBM00S_ACAD_PLAN_INFO.CB_Reported_Student"),
    F.col("CBM00S_ACAD_PLAN_INFO.CB_Reported_Course"),
    F.col("CBM00S_ACAD_PLAN_INFO.Current_Semester_Reportable"),
    F.col("CBM00S_ACAD_PLAN_INFO.Core_Course"),
    F.col("CBM00S_ACAD_PLAN_INFO.Current_Term"),
    F.col("CBM00S_ACAD_PLAN_INFO.MathCore"),
    F.col("CBM00S_ACAD_PLAN_INFO.ReadCore"),
    F.col("CBM00S_ACAD_PLAN_INFO.WriteCore"),
    F.col("CBM00S_ACAD_PLAN_INFO.DLRN_Course"),
    F.col("CBM00S_ACAD_PLAN_INFO.AP_Course"),
)

# COMMAND ----------

# Step: Funded, Unfunded
# CBM00S_with_funding
df_cbm00s_with_funding = df_cbms_flex_student_level.alias("CBMS_FLEX_STUDENT_LEVEL")

df_cbm00s_with_funding = (
    df_cbm00s_with_funding.join(
        ps_uta_unfunded,
        on=(
            (F.col("CBMS_FLEX_STUDENT_LEVEL.STRM") <= F.lit("2088"))
            & (F.col("CBMS_FLEX_STUDENT_LEVEL.STRM") == F.col("PS_UTA_UNFUNDED.STRM"))
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.EMPLID")
                == F.col("PS_UTA_UNFUNDED.EMPLID")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_CAREER")
                == F.col("PS_UTA_UNFUNDED.ACAD_CAREER")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_PROG")
                == F.col("PS_UTA_UNFUNDED.ACAD_PROG")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.INSTITUTION")
                == F.col("PS_UTA_UNFUNDED.INSTITUTION")
            )
            & (F.col("PS_UTA_UNFUNDED.UTA_UNFN_TYPE") == F.lit("X"))
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_ID")
                == F.col("PS_UTA_UNFUNDED.CRSE_ID")
            )
            & (F.col("PS_UTA_UNFUNDED.UTA_UNFN_TYPE") == F.lit("D"))
            & (F.col("PS_UTA_UNFUNDED.UTA_UNFN_TYPE") == F.lit("R"))
            & (F.col("PS_UTA_UNFUNDED.UTA_UNFN_UNITS") > F.lit(0))
        ),
        how="left",
    )
    .join(
        adw_cbm_excess_hours,
        on=(
            (
                F.col("CBMS_FLEX_STUDENT_LEVEL.EMPLID")
                == F.col("ADW_CBM_EXCESS_HOURS.EMPLID")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.Current_Term")
                == F.col("ADW_CBM_EXCESS_HOURS.STRM")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_CAREER")
                == F.col("ADW_CBM_EXCESS_HOURS.ACAD_CAREER")
            )
        ),
        how="left",
    )
    .join(
        adw_cbm_3peatdev,
        on=(
            (
                F.col("CBMS_FLEX_STUDENT_LEVEL.Current_Term")
                == F.col("ADW_CBM_3PEATDEV.STRM")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.EMPLID")
                == F.col("ADW_CBM_3PEATDEV.EMPLID")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_CAREER")
                == F.col("ADW_CBM_3PEATDEV.ACAD_CAREER")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.INSTITUTION")
                == F.col("ADW_CBM_3PEATDEV.INSTITUTION")
            )
            & (
                F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_ID")
                == F.col("ADW_CBM_3PEATDEV.CRSE_ID")
            )
            & F.col("ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE").isin(["R", "D"])
        ),
        how="left",
    )
)

df_cbm00s_with_funding = df_cbm00s_with_funding.withColumn(
    "EXC_FLAG",
    F.when(
        (
            F.col("ADW_CBM_EXCESS_HOURS.EMPLID").isNotNull()
            & (F.trim(F.col("ADW_CBM_EXCESS_HOURS.EMPLID")) != F.lit(""))
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

df_cbm00s_with_funding = df_cbm00s_with_funding.withColumn(
    "FLAG_3PEAT",
    F.when(
        (
            (F.col("ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE") == F.lit("R"))
            & (F.col("ADW_CBM_3PEATDEV.UNT_TAKEN") > F.lit(0))
            & (F.col("ADW_CBM_3PEATDEV.UTA_CB_EXCL_FLAG") == F.lit("N"))
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

# COMMAND ----------

df_cbm00s_with_funding = df_cbm00s_with_funding.withColumn(
    "DVLP_FLAG",
    F.when(
        (F.col("ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE") == F.lit("D")), F.lit("Yes")
    ).otherwise(F.lit("No")),
)

df_cbm00s_with_funding = df_cbm00s_with_funding.withColumn(
    "PHYED_CNT_FLG",
    F.when(
        (
            F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_PROG").isin(["UGNDS", "SPEC"])
            & F.col("CBMS_FLEX_STUDENT_LEVEL.SUBJECT").isin(["EXSA", "DNCE"])
            & (F.col("CBMS_FLEX_STUDENT_LEVEL.REPEAT_CANDIDATE") == F.lit("Y"))
            & (F.col("CBMS_FLEX_STUDENT_LEVEL.ADDL_ENRL") == F.lit("N"))
        ),
        F.lit("Y"),
    ).otherwise(F.lit("N")),
)

df_cbm00s_with_funding = df_cbm00s_with_funding.withColumn(
    "Unfunded_Flag",
    F.when(
        (
            (
                F.expr("LOCATE('UNFN', UPPER(cbms_flex_student_level.CLASS_VAL_LIST))")
                != F.lit(0)
            )
            | (
                F.expr("LOCATE('UNFN', UPPER(cbms_flex_student_level.CLASS_ATTR_LIST))")
                != F.lit(0)
            )
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

# COMMAND ----------

df_cbm00s_with_funding = df_cbm00s_with_funding.select(
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_CAREER"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_PROG"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_CAREER"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.EMPLID"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ENRL_STATUS_REASON"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.GRADE_CATEGORY"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.GRADE_POINTS"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.INSTITUTION"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.STRM"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.UNT_EARNED"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.UNT_PRGRSS"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.UNT_TAKEN"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CLASS_NBR"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CLASS_SECTION"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CLASS_STAT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CLASS_TYPE"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.COMBINED_SECTION"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_ID"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_OFFER_NBR"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.END_DT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.INSTRUCTION_MODE"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.LOCATION"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.START_DT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.SUBJECT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.TERM_BEGIN_DT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.TERM_END_DT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CENSUS_DT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.DLRN_Student"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.Prior_Term"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CB_Exclude"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ENRL_TOT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.SSR_COMPONENT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.COMPONENT_PRIMARY"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_CONTACT_HRS"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.UNITS_MAXIMUM"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.SESSION_CODE"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.Current_Term_End_date"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.UNT_TAKEN_SEM"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CATALOG_NBR"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_GROUP"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_ORG"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CAMPUS"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.OFFSITE_LOC_CD"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.EXT_LOC_FICE"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.UTA_CB_LOCATION_CD"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.STDNT_CAR_NBR"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.EFFDT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.EFFSEQ"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_PLAN"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.REQ_TERM"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.PLAN_TBL_EFFDT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.PLAN_TBL_ACAD_PROG"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_PLAN_TYPE"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ADMIT_TERM"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.DEGR_CHKOUT_STAT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_LEVEL_BOT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_LEVEL_EOT"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ACAD_PROG_PRIMARY"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.TOT_CUMULATIVE"),
    F.col("PS_UTA_UNFUNDED.UTA_UNFN_TYPE"),
    F.col("PS_UTA_UNFUNDED.UTA_UNFN_UNITS"),
    F.col("ADW_CBM_EXCESS_HOURS.EMPLID").alias("Excess_Emplid"),
    F.col("ADW_CBM_3PEATDEV.CRSE_ID").alias("THREEP_CRSE_ID"),
    F.col("ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE").alias("THREEP_UNFN_TYPE"),
    F.col("ADW_CBM_3PEATDEV.UNT_TAKEN").alias("THREEP_UNT_TAKEN"),
    F.col("EXC_FLAG"),
    F.col("FLAG_3PEAT"),
    F.col("DVLP_FLAG"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.REPEAT_CANDIDATE"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ADDL_ENRL"),
    F.col("PHYED_CNT_FLG"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CLASS_ATTR_LIST"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CLASS_VAL_LIST"),
    F.col("Unfunded_Flag"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.Core_Course"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.NCBO"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_GRADE_OFF"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.COMBINED_SECTION_CODE"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_ATTR_LIST"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CRSE_VAL_LIST"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CB_Reported_Student"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.CB_Reported_Course"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.Current_Semester_Reportable"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.Current_Term"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.MathCore"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.ReadCore"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.WriteCore"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.DLRN_Course"),
    F.col("CBMS_FLEX_STUDENT_LEVEL.AP_Course"),
)

# COMMAND ----------

# Step: 12H Flag-Min Units Req
# CBM00S_12H_Flag
df_cbm00s_12h_flag = df_cbm00s_with_funding.alias("CBM00S_with_funding")

df_cbm00s_12h_flag = df_cbm00s_12h_flag.join(
    ps_utacadplan_dtl,
    on=(
        (
            F.col("CBM00S_with_funding.ACAD_PLAN")
            == F.col("PS_UTA_ACADPLAN_DTL.ACAD_PLAN")
        )
        & (
            F.col("CBM00S_with_funding.ACAD_CAREER")
            == F.col("PS_UTA_ACADPLAN_DTL.ACAD_CAREER")
        )
        & (
            F.col("CBM00S_with_funding.TERM_BEGIN_DT")
            >= F.col("PS_UTA_ACADPLAN_DTL.EFFDT")
        )
        & (
            F.col("CBM00S_with_funding.INSTITUTION")
            == F.col("PS_UTA_ACADPLAN_DTL.INSTITUTION")
        )
    ),
    how="left",
)

df_cbm00s_12h_flag = df_cbm00s_12h_flag.withColumn(
    "_agg_tmp_0",
    F.max(F.col("PS_UTA_ACADPLAN_DTL.EFFDT")).over(
        Window.partitionBy(
            "CBM00S_with_funding.INSTITUTION",
            "CBM00S_with_funding.ACAD_CAREER",
            "CBM00S_with_funding.ACAD_PLAN",
            "CBM00S_with_funding.TERM_BEGIN_DT",
        )
    ),
)

df_cbm00s_12h_flag = df_cbm00s_12h_flag.filter(
    F.col("_agg_tmp_0").isNull()
    | (
        F.date_format(F.col("PS_UTA_ACADPLAN_DTL.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        == F.date_format(F.col("_agg_tmp_0"), "yyyy-MM-dd HH:mm:ss")
    )
).drop("_agg_tmp_0")

# COMMAND ----------

df_cbm00s_12h_flag = df_cbm00s_12h_flag.select(
    F.col("CBM00S_with_funding.ACAD_CAREER"),
    F.col("CBM00S_with_funding.ACAD_PROG"),
    F.col("CBM00S_with_funding.CRSE_CAREER"),
    F.col("CBM00S_with_funding.EMPLID"),
    F.col("CBM00S_with_funding.ENRL_STATUS_REASON"),
    F.col("CBM00S_with_funding.GRADE_CATEGORY"),
    F.col("CBM00S_with_funding.GRADE_POINTS"),
    F.col("CBM00S_with_funding.INSTITUTION"),
    F.col("CBM00S_with_funding.STRM"),
    F.col("CBM00S_with_funding.UNT_EARNED"),
    F.col("CBM00S_with_funding.UNT_PRGRSS"),
    F.col("CBM00S_with_funding.UNT_TAKEN"),
    F.col("CBM00S_with_funding.CLASS_NBR"),
    F.col("CBM00S_with_funding.CLASS_SECTION"),
    F.col("CBM00S_with_funding.CLASS_STAT"),
    F.col("CBM00S_with_funding.CLASS_TYPE"),
    F.col("CBM00S_with_funding.COMBINED_SECTION"),
    F.col("CBM00S_with_funding.CRSE_ID"),
    F.col("CBM00S_with_funding.CRSE_OFFER_NBR"),
    F.col("CBM00S_with_funding.END_DT"),
    F.col("CBM00S_with_funding.INSTRUCTION_MODE"),
    F.col("CBM00S_with_funding.LOCATION"),
    F.col("CBM00S_with_funding.START_DT"),
    F.col("CBM00S_with_funding.SUBJECT"),
    F.col("CBM00S_with_funding.TERM_BEGIN_DT"),
    F.col("CBM00S_with_funding.TERM_END_DT"),
    F.col("CBM00S_with_funding.CENSUS_DT"),
    F.col("CBM00S_with_funding.DLRN_Student"),
    F.col("CBM00S_with_funding.Prior_Term"),
    F.col("CBM00S_with_funding.CB_Exclude"),
    F.col("CBM00S_with_funding.ENRL_TOT"),
    F.col("CBM00S_with_funding.SSR_COMPONENT"),
    F.col("CBM00S_with_funding.COMPONENT_PRIMARY"),
    F.col("CBM00S_with_funding.CRSE_CONTACT_HRS"),
    F.col("CBM00S_with_funding.UNITS_MAXIMUM"),
    F.col("CBM00S_with_funding.SESSION_CODE"),
    F.col("CBM00S_with_funding.Current_Term_End_date"),
    F.col("CBM00S_with_funding.UNT_TAKEN_SEM"),
    F.col("CBM00S_with_funding.CATALOG_NBR"),
    F.col("CBM00S_with_funding.ACAD_GROUP"),
    F.col("CBM00S_with_funding.ACAD_ORG"),
    F.col("CBM00S_with_funding.CAMPUS"),
    F.col("CBM00S_with_funding.OFFSITE_LOC_CD"),
    F.col("CBM00S_with_funding.EXT_LOC_FICE"),
    F.col("CBM00S_with_funding.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_with_funding.STDNT_CAR_NBR"),
    F.col("CBM00S_with_funding.EFFDT"),
    F.col("CBM00S_with_funding.EFFSEQ"),
    F.col("CBM00S_with_funding.ACAD_PLAN"),
    F.col("CBM00S_with_funding.REQ_TERM"),
    F.col("CBM00S_with_funding.PLAN_TBL_EFFDT"),
    F.col("CBM00S_with_funding.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_with_funding.ACAD_PLAN_TYPE"),
    F.col("CBM00S_with_funding.ADMIT_TERM"),
    F.col("CBM00S_with_funding.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_with_funding.ACAD_LEVEL_BOT"),
    F.col("CBM00S_with_funding.ACAD_LEVEL_EOT"),
    F.col("CBM00S_with_funding.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_with_funding.TOT_CUMULATIVE"),
    F.col("CBM00S_with_funding.UTA_UNFN_TYPE"),
    F.col("CBM00S_with_funding.UTA_UNFN_UNITS"),
    F.col("CBM00S_with_funding.Excess_Emplid"),
    F.col("CBM00S_with_funding.THREEP_CRSE_ID"),
    F.col("CBM00S_with_funding.THREEP_UNFN_TYPE"),
    F.col("CBM00S_with_funding.THREEP_UNT_TAKEN"),
    F.col("CBM00S_with_funding.EXC_FLAG"),
    F.col("CBM00S_with_funding.FLAG_3PEAT"),
    F.col("CBM00S_with_funding.DVLP_FLAG"),
    F.col("CBM00S_with_funding.REPEAT_CANDIDATE"),
    F.col("CBM00S_with_funding.ADDL_ENRL"),
    F.col("CBM00S_with_funding.PHYED_CNT_FLG"),
    F.col("CBM00S_with_funding.CLASS_ATTR_LIST"),
    F.col("CBM00S_with_funding.CLASS_VAL_LIST"),
    F.col("CBM00S_with_funding.Unfunded_Flag"),
    F.col("PS_UTA_ACADPLAN_DTL.MIN_UNITS_REQD"),
    F.col("CBM00S_with_funding.CORE_COURSE"),
    F.col("CBM00S_with_funding.NCBO"),
    F.col("CBM00S_with_funding.CRSE_GRADE_OFF"),
    F.col("CBM00S_with_funding.COMBINED_SECTION_CODE"),
    F.col("CBM00S_with_funding.CRSE_ATTR_LIST"),
    F.col("CBM00S_with_funding.CRSE_VAL_LIST"),
    F.col("CBM00S_with_funding.CB_Reported_Student"),
    F.col("CBM00S_with_funding.CB_Reported_Course"),
    F.col("CBM00S_with_funding.Current_Semester_Reportable"),
    F.col("CBM00S_with_funding.Current_Term"),
    F.col("CBM00S_with_funding.MathCore"),
    F.col("CBM00S_with_funding.ReadCore"),
    F.col("CBM00S_with_funding.WriteCore"),
    F.col("CBM00S_with_funding.DLRN_Course"),
    F.col("CBM00S_with_funding.AP_Course"),
)

# COMMAND ----------

# Checkpoint 3: materialize df_cbm00s_12h_flag to break the upstream DAG
_tmp_stageC_tbl = f"{analytics}.{staging}._tmp_cbm00s_12h_flag_400_LOAD_CBM00S"
write_df_to_table(
    df_cbm00s_12h_flag, _tmp_stageC_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm00s_12h_flag = read_table(_tmp_stageC_tbl).alias("CBM00S_12H_Flag")
log_msg(f"Checkpoint 3 materialized: {_tmp_stageC_tbl}")

# COMMAND ----------

# CBM00S_12H_Flag_Unduplicated
df_cbm00s_12h_flag_unduplicated = df_cbm00s_12h_flag.alias("CBM00S_12H_Flag")

df_cbm00s_12h_flag_unduplicated = df_cbm00s_12h_flag_unduplicated.filter(
    (F.trim(F.col("CBM00S_12H_Flag.ACAD_PROG_PRIMARY")) != F.lit(""))
)

df_cbm00s_12h_flag_unduplicated = df_cbm00s_12h_flag_unduplicated.withColumn(
    "_sel_tmp_0_0",
    F.max(F.col("CBM00S_12H_Flag.MIN_UNITS_REQD")).over(
        Window.partitionBy(
            F.col("CBM00S_12H_Flag.EMPLID"),
            F.col("CBM00S_12H_Flag.STRM"),
            F.col("CBM00S_12H_Flag.CLASS_NBR"),
        )
    ),
)

df_cbm00s_12h_flag_unduplicated = df_cbm00s_12h_flag_unduplicated.withColumn(
    "MIN_UNITS_REQD",
    F.when((F.col("_sel_tmp_0_0") > F.lit(120)), F.col("_sel_tmp_0_0")).otherwise(
        F.when(
            (F.col("CBM00S_12H_Flag.ACAD_CAREER") == F.lit("UGRD")), F.lit(120)
        ).otherwise(F.lit(None))
    ),
).drop("_sel_tmp_0_0")

# COMMAND ----------

df_cbm00s_12h_flag_unduplicated = df_cbm00s_12h_flag_unduplicated.select(
    F.col("CBM00S_12H_Flag.ACAD_CAREER"),
    F.col("CBM00S_12H_Flag.ACAD_PROG"),
    F.col("CBM00S_12H_Flag.CRSE_CAREER"),
    F.col("CBM00S_12H_Flag.EMPLID"),
    F.col("CBM00S_12H_Flag.ENRL_STATUS_REASON"),
    F.col("CBM00S_12H_Flag.GRADE_CATEGORY"),
    F.col("CBM00S_12H_Flag.GRADE_POINTS"),
    F.col("CBM00S_12H_Flag.INSTITUTION"),
    F.col("CBM00S_12H_Flag.STRM"),
    F.col("CBM00S_12H_Flag.UNT_EARNED"),
    F.col("CBM00S_12H_Flag.UNT_PRGRSS"),
    F.col("CBM00S_12H_Flag.UNT_TAKEN"),
    F.col("CBM00S_12H_Flag.CLASS_NBR"),
    F.col("CBM00S_12H_Flag.CLASS_SECTION"),
    F.col("CBM00S_12H_Flag.CLASS_STAT"),
    F.col("CBM00S_12H_Flag.CLASS_TYPE"),
    F.col("CBM00S_12H_Flag.COMBINED_SECTION"),
    F.col("CBM00S_12H_Flag.CRSE_ID"),
    F.col("CBM00S_12H_Flag.CRSE_OFFER_NBR"),
    F.col("CBM00S_12H_Flag.END_DT"),
    F.col("CBM00S_12H_Flag.INSTRUCTION_MODE"),
    F.col("CBM00S_12H_Flag.LOCATION"),
    F.col("CBM00S_12H_Flag.START_DT"),
    F.col("CBM00S_12H_Flag.SUBJECT"),
    F.col("CBM00S_12H_Flag.TERM_BEGIN_DT"),
    F.col("CBM00S_12H_Flag.TERM_END_DT"),
    F.col("CBM00S_12H_Flag.CENSUS_DT"),
    F.col("CBM00S_12H_Flag.DLRN_Student"),
    F.col("CBM00S_12H_Flag.Prior_Term"),
    F.col("CBM00S_12H_Flag.CB_Exclude"),
    F.col("CBM00S_12H_Flag.ENRL_TOT"),
    F.col("CBM00S_12H_Flag.SSR_COMPONENT"),
    F.col("CBM00S_12H_Flag.COMPONENT_PRIMARY"),
    F.col("CBM00S_12H_Flag.CRSE_CONTACT_HRS"),
    F.col("CBM00S_12H_Flag.UNITS_MAXIMUM"),
    F.col("CBM00S_12H_Flag.SESSION_CODE"),
    F.col("CBM00S_12H_Flag.Current_Term_End_date"),
    F.col("CBM00S_12H_Flag.UNT_TAKEN_SEM"),
    F.col("CBM00S_12H_Flag.CATALOG_NBR"),
    F.col("CBM00S_12H_Flag.ACAD_GROUP"),
    F.col("CBM00S_12H_Flag.ACAD_ORG"),
    F.col("CBM00S_12H_Flag.CAMPUS"),
    F.col("CBM00S_12H_Flag.OFFSITE_LOC_CD"),
    F.col("CBM00S_12H_Flag.EXT_LOC_FICE"),
    F.col("CBM00S_12H_Flag.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_12H_Flag.STDNT_CAR_NBR"),
    F.col("CBM00S_12H_Flag.EFFDT"),
    F.col("CBM00S_12H_Flag.EFFSEQ"),
    F.col("CBM00S_12H_Flag.ACAD_PLAN"),
    F.col("CBM00S_12H_Flag.REQ_TERM"),
    F.col("CBM00S_12H_Flag.PLAN_TBL_EFFDT"),
    F.col("CBM00S_12H_Flag.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_12H_Flag.ADMIT_TERM"),
    F.col("CBM00S_12H_Flag.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_12H_Flag.ACAD_LEVEL_BOT"),
    F.col("CBM00S_12H_Flag.ACAD_LEVEL_EOT"),
    F.col("CBM00S_12H_Flag.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_12H_Flag.TOT_CUMULATIVE"),
    F.col("CBM00S_12H_Flag.UTA_UNFN_TYPE"),
    F.col("CBM00S_12H_Flag.UTA_UNFN_UNITS"),
    F.col("CBM00S_12H_Flag.Excess_Emplid"),
    F.col("CBM00S_12H_Flag.THREEP_CRSE_ID"),
    F.col("CBM00S_12H_Flag.THREEP_UNFN_TYPE"),
    F.col("CBM00S_12H_Flag.THREEP_UNT_TAKEN"),
    F.col("CBM00S_12H_Flag.EXC_FLAG"),
    F.col("CBM00S_12H_Flag.FLAG_3PEAT"),
    F.col("CBM00S_12H_Flag.DVLP_FLAG"),
    F.col("CBM00S_12H_Flag.REPEAT_CANDIDATE"),
    F.col("CBM00S_12H_Flag.ADDL_ENRL"),
    F.col("CBM00S_12H_Flag.PHYED_CNT_FLG"),
    F.col("CBM00S_12H_Flag.CLASS_ATTR_LIST"),
    F.col("CBM00S_12H_Flag.CLASS_VAL_LIST"),
    F.col("CBM00S_12H_Flag.Unfunded_Flag"),
    F.col("MIN_UNITS_REQD"),
    F.col("CBM00S_12H_Flag.CORE_COURSE"),
    F.col("CBM00S_12H_Flag.NCBO"),
    F.col("CBM00S_12H_Flag.CRSE_GRADE_OFF"),
    F.col("CBM00S_12H_Flag.COMBINED_SECTION_CODE"),
    F.col("CBM00S_12H_Flag.CRSE_ATTR_LIST"),
    F.col("CBM00S_12H_Flag.CRSE_VAL_LIST"),
    F.col("CBM00S_12H_Flag.CB_Reported_Student"),
    F.col("CBM00S_12H_Flag.CB_Reported_Course"),
    F.col("CBM00S_12H_Flag.Current_Semester_Reportable"),
    F.col("CBM00S_12H_Flag.Current_Term"),
    F.col("CBM00S_12H_Flag.MathCore"),
    F.col("CBM00S_12H_Flag.ReadCore"),
    F.col("CBM00S_12H_Flag.WriteCore"),
    F.col("CBM00S_12H_Flag.DLRN_Course"),
    F.col("CBM00S_12H_Flag.AP_Course"),
).distinct()

# COMMAND ----------

# Step: Prior Core Course Enrollment
# CBM00S_Core_Crse_Enrl
cbm00s_12h_flag_unduplicated = df_cbm00s_12h_flag_unduplicated.alias(
    "CBM00S_12H_Flag_Unduplicated"
)

df_cbm00s_core_crse_enrl = cbm00s_12h_flag_unduplicated.join(
    ps_stdnt_enrl,
    on=(
        (F.col("CBM00S_12H_Flag_Unduplicated.EMPLID") == F.col("PS_STDNT_ENRL.EMPLID"))
        & (
            F.col("CBM00S_12H_Flag_Unduplicated.ACAD_CAREER")
            == F.col("PS_STDNT_ENRL.ACAD_CAREER")
        )
        & (F.col("CBM00S_12H_Flag_Unduplicated.STRM") > F.col("PS_STDNT_ENRL.STRM"))
        & (F.col("PS_STDNT_ENRL.ACAD_CAREER") == F.lit("UGRD"))
        & (F.col("PS_STDNT_ENRL.STDNT_ENRL_STATUS") == F.lit("E"))
        & (F.col("PS_STDNT_ENRL.INSTITUTION") == F.lit("UTARL"))
        & (F.col("PS_STDNT_ENRL.UNT_TAKEN") > F.lit(0))
        & F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF").isin(["A", "B", "C", "D", "P"])
    ),
    how="inner",
)

df_cbm00s_core_crse_enrl = df_cbm00s_core_crse_enrl.join(
    cbm00s_course_info,
    on=(
        (F.col("PS_STDNT_ENRL.STRM") == F.col("CBM00S_Course_Info.STRM"))
        & (
            F.col("PS_STDNT_ENRL.SESSION_CODE")
            == F.col("CBM00S_Course_Info.SESSION_CODE")
        )
        & (F.col("PS_STDNT_ENRL.CLASS_NBR") == F.col("CBM00S_Course_Info.CLASS_NBR"))
        & (F.col("CBM00S_Course_Info.Core_Course") == F.lit("Yes"))
    ),
    how="inner",
)

df_cbm00s_core_crse_enrl = df_cbm00s_core_crse_enrl.withColumn(
    "_agg_tmp_0",
    F.min(F.col("PS_STDNT_ENRL.STRM")).over(
        Window.partitionBy(
            "CBM00S_12H_Flag_Unduplicated.EMPLID",
            "CBM00S_12H_Flag_Unduplicated.ACAD_CAREER",
        )
    ),
)

df_cbm00s_core_crse_enrl = df_cbm00s_core_crse_enrl.filter(
    F.coalesce(F.col("PS_STDNT_ENRL.STRM"), F.lit(""))
    == F.coalesce(F.col("_agg_tmp_0"), F.lit(""))
).drop("_agg_tmp_0")

df_cbm00s_core_crse_enrl = df_cbm00s_core_crse_enrl.select(
    F.col("PS_STDNT_ENRL.STRM").alias("Prior_Enrolled_Term"),
    F.col("CBM00S_12H_Flag_Unduplicated.EMPLID"),
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_CAREER"),
    F.col("CBM00S_12H_Flag_Unduplicated.STRM"),
    F.col("CBM00S_12H_Flag_Unduplicated.CRSE_ID"),
).distinct()

# COMMAND ----------

# Step: Prior Core Enrollment
# CBM00S_Prior_Enrollment

cbm00s_core_crse_enrl = df_cbm00s_core_crse_enrl.alias("CBM00S_Core_Crse_Enrl")

df_cbm00s_prior_enrollment = cbm00s_12h_flag_unduplicated.join(
    cbm00s_core_crse_enrl,
    on=(
        (
            F.col("CBM00S_12H_Flag_Unduplicated.STRM")
            == F.col("CBM00S_Core_Crse_Enrl.STRM")
        )
        & (
            F.col("CBM00S_12H_Flag_Unduplicated.EMPLID")
            == F.col("CBM00S_Core_Crse_Enrl.EMPLID")
        )
        & (
            F.col("CBM00S_12H_Flag_Unduplicated.ACAD_CAREER")
            == F.col("CBM00S_Core_Crse_Enrl.ACAD_CAREER")
        )
        & (
            F.col("CBM00S_12H_Flag_Unduplicated.CRSE_ID")
            == F.col("CBM00S_Core_Crse_Enrl.CRSE_ID")
        )
    ),
    how="left",
)

# COMMAND ----------

df_cbm00s_prior_enrollment = df_cbm00s_prior_enrollment.select(
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_CAREER"),
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_PROG"),
    F.col("CBM00S_12H_Flag_Unduplicated.CRSE_CAREER"),
    F.col("CBM00S_12H_Flag_Unduplicated.EMPLID"),
    F.col("CBM00S_12H_Flag_Unduplicated.ENRL_STATUS_REASON"),
    F.col("CBM00S_12H_Flag_Unduplicated.GRADE_CATEGORY"),
    F.col("CBM00S_12H_Flag_Unduplicated.GRADE_POINTS"),
    F.col("CBM00S_12H_Flag_Unduplicated.INSTITUTION"),
    F.col("CBM00S_12H_Flag_Unduplicated.STRM"),
    F.col("CBM00S_12H_Flag_Unduplicated.UNT_EARNED"),
    F.col("CBM00S_12H_Flag_Unduplicated.UNT_PRGRSS"),
    F.col("CBM00S_12H_Flag_Unduplicated.UNT_TAKEN"),
    F.col("CBM00S_12H_Flag_Unduplicated.CLASS_NBR"),
    F.col("CBM00S_12H_Flag_Unduplicated.CLASS_SECTION"),
    F.col("CBM00S_12H_Flag_Unduplicated.CLASS_STAT"),
    F.col("CBM00S_12H_Flag_Unduplicated.CLASS_TYPE"),
    F.col("CBM00S_12H_Flag_Unduplicated.COMBINED_SECTION"),
    F.col("CBM00S_12H_Flag_Unduplicated.CRSE_ID"),
    F.col("CBM00S_12H_Flag_Unduplicated.CRSE_OFFER_NBR"),
    F.col("CBM00S_12H_Flag_Unduplicated.END_DT"),
    F.col("CBM00S_12H_Flag_Unduplicated.INSTRUCTION_MODE"),
    F.col("CBM00S_12H_Flag_Unduplicated.LOCATION"),
    F.col("CBM00S_12H_Flag_Unduplicated.START_DT"),
    F.col("CBM00S_12H_Flag_Unduplicated.SUBJECT"),
    F.col("CBM00S_12H_Flag_Unduplicated.TERM_BEGIN_DT"),
    F.col("CBM00S_12H_Flag_Unduplicated.TERM_END_DT"),
    F.col("CBM00S_12H_Flag_Unduplicated.CENSUS_DT"),
    F.col("CBM00S_12H_Flag_Unduplicated.DLRN_Student"),
    F.col("CBM00S_12H_Flag_Unduplicated.Prior_Term"),
    F.col("CBM00S_12H_Flag_Unduplicated.CB_Exclude"),
    F.col("CBM00S_12H_Flag_Unduplicated.ENRL_TOT"),
    F.col("CBM00S_12H_Flag_Unduplicated.SSR_COMPONENT"),
    F.col("CBM00S_12H_Flag_Unduplicated.COMPONENT_PRIMARY"),
    F.col("CBM00S_12H_Flag_Unduplicated.CRSE_CONTACT_HRS"),
    F.col("CBM00S_12H_Flag_Unduplicated.UNITS_MAXIMUM"),
    F.col("CBM00S_12H_Flag_Unduplicated.SESSION_CODE"),
    F.col("CBM00S_12H_Flag_Unduplicated.Current_Term_End_date"),
    F.col("CBM00S_12H_Flag_Unduplicated.UNT_TAKEN_SEM"),
    F.col("CBM00S_12H_Flag_Unduplicated.CATALOG_NBR"),
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_GROUP"),
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_ORG"),
    F.col("CBM00S_12H_Flag_Unduplicated.CAMPUS"),
    F.col("CBM00S_12H_Flag_Unduplicated.OFFSITE_LOC_CD"),
    F.col("CBM00S_12H_Flag_Unduplicated.EXT_LOC_FICE"),
    F.col("CBM00S_12H_Flag_Unduplicated.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_12H_Flag_Unduplicated.STDNT_CAR_NBR"),
    F.col("CBM00S_12H_Flag_Unduplicated.EFFDT"),
    F.col("CBM00S_12H_Flag_Unduplicated.EFFSEQ"),
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_PLAN"),
    F.col("CBM00S_12H_Flag_Unduplicated.REQ_TERM"),
    F.col("CBM00S_12H_Flag_Unduplicated.PLAN_TBL_EFFDT"),
    F.col("CBM00S_12H_Flag_Unduplicated.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_12H_Flag_Unduplicated.ADMIT_TERM"),
    F.col("CBM00S_12H_Flag_Unduplicated.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_LEVEL_BOT"),
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_LEVEL_EOT"),
    F.col("CBM00S_12H_Flag_Unduplicated.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_12H_Flag_Unduplicated.TOT_CUMULATIVE"),
    F.col("CBM00S_12H_Flag_Unduplicated.UTA_UNFN_TYPE"),
    F.col("CBM00S_12H_Flag_Unduplicated.UTA_UNFN_UNITS"),
    F.col("CBM00S_12H_Flag_Unduplicated.Excess_Emplid"),
    F.col("CBM00S_12H_Flag_Unduplicated.THREEP_CRSE_ID"),
    F.col("CBM00S_12H_Flag_Unduplicated.THREEP_UNFN_TYPE"),
    F.col("CBM00S_12H_Flag_Unduplicated.THREEP_UNT_TAKEN"),
    F.col("CBM00S_12H_Flag_Unduplicated.EXC_FLAG"),
    F.col("CBM00S_12H_Flag_Unduplicated.FLAG_3PEAT"),
    F.col("CBM00S_12H_Flag_Unduplicated.DVLP_FLAG"),
    F.col("CBM00S_12H_Flag_Unduplicated.REPEAT_CANDIDATE"),
    F.col("CBM00S_12H_Flag_Unduplicated.ADDL_ENRL"),
    F.col("CBM00S_12H_Flag_Unduplicated.PHYED_CNT_FLG"),
    F.col("CBM00S_12H_Flag_Unduplicated.CLASS_ATTR_LIST"),
    F.col("CBM00S_12H_Flag_Unduplicated.CLASS_VAL_LIST"),
    F.col("CBM00S_12H_Flag_Unduplicated.Unfunded_Flag"),
    F.col("CBM00S_12H_Flag_Unduplicated.MIN_UNITS_REQD"),
    F.col("CBM00S_12H_Flag_Unduplicated.CORE_COURSE"),
    F.col("CBM00S_Core_Crse_Enrl.Prior_Enrolled_Term"),
    F.col("CBM00S_12H_Flag_Unduplicated.NCBO"),
    F.col("CBM00S_12H_Flag_Unduplicated.CRSE_GRADE_OFF"),
    F.col("CBM00S_12H_Flag_Unduplicated.COMBINED_SECTION_CODE"),
    F.col("CBM00S_12H_Flag_Unduplicated.CRSE_ATTR_LIST"),
    F.col("CBM00S_12H_Flag_Unduplicated.CRSE_VAL_LIST"),
    F.col("CBM00S_12H_Flag_Unduplicated.CB_Reported_Student"),
    F.col("CBM00S_12H_Flag_Unduplicated.CB_Reported_Course"),
    F.col("CBM00S_12H_Flag_Unduplicated.Current_Semester_Reportable"),
    F.col("CBM00S_12H_Flag_Unduplicated.Current_Term"),
    F.col("CBM00S_12H_Flag_Unduplicated.MathCore"),
    F.col("CBM00S_12H_Flag_Unduplicated.ReadCore"),
    F.col("CBM00S_12H_Flag_Unduplicated.WriteCore"),
    F.col("CBM00S_12H_Flag_Unduplicated.DLRN_Course"),
    F.col("CBM00S_12H_Flag_Unduplicated.AP_Course"),
)

# COMMAND ----------

# Step: Ferpa Flag
# CBM00S_Ferpa
df_cbm00s_ferpa = df_cbm00s_prior_enrollment.alias("CBM00S_Prior_Enrollment")

df_cbm00s_ferpa = df_cbm00s_ferpa.join(
    ps_person_sa,
    on=(F.col("CBM00S_Prior_Enrollment.EMPLID") == F.col("PS_PERSON_SA.EMPLID")),
    how="left",
).join(
    ps_srvc_ind_data,
    on=(
        (F.col("CBM00S_Prior_Enrollment.EMPLID") == F.col("PS_SRVC_IND_DATA.EMPLID"))
        & (
            F.col("CBM00S_Prior_Enrollment.INSTITUTION")
            == F.col("PS_SRVC_IND_DATA.INSTITUTION")
        )
        & (F.col("PS_SRVC_IND_DATA.SRVC_IND_CD") == F.lit("GDR"))
        & (
            F.col("CBM00S_Prior_Enrollment.STRM")
            >= F.col("PS_SRVC_IND_DATA.SRVC_IND_ACT_TERM")
        )
    ),
    how="left",
)

df_cbm00s_ferpa = df_cbm00s_ferpa.withColumn(
    "GDR_Indicator",
    F.when(
        (
            F.col("PS_SRVC_IND_DATA.EMPLID").isNotNull()
            & (F.trim(F.col("PS_SRVC_IND_DATA.EMPLID")) != F.lit(""))
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

# COMMAND ----------

df_cbm00s_ferpa = df_cbm00s_ferpa.select(
    F.col("CBM00S_Prior_Enrollment.ACAD_CAREER"),
    F.col("CBM00S_Prior_Enrollment.ACAD_PROG"),
    F.col("CBM00S_Prior_Enrollment.CRSE_CAREER"),
    F.col("CBM00S_Prior_Enrollment.EMPLID"),
    F.col("CBM00S_Prior_Enrollment.ENRL_STATUS_REASON"),
    F.col("CBM00S_Prior_Enrollment.GRADE_CATEGORY"),
    F.col("CBM00S_Prior_Enrollment.GRADE_POINTS"),
    F.col("CBM00S_Prior_Enrollment.INSTITUTION"),
    F.col("CBM00S_Prior_Enrollment.STRM"),
    F.col("CBM00S_Prior_Enrollment.UNT_EARNED"),
    F.col("CBM00S_Prior_Enrollment.UNT_PRGRSS"),
    F.col("CBM00S_Prior_Enrollment.UNT_TAKEN"),
    F.col("CBM00S_Prior_Enrollment.CLASS_NBR"),
    F.col("CBM00S_Prior_Enrollment.CLASS_SECTION"),
    F.col("CBM00S_Prior_Enrollment.CLASS_STAT"),
    F.col("CBM00S_Prior_Enrollment.CLASS_TYPE"),
    F.col("CBM00S_Prior_Enrollment.COMBINED_SECTION"),
    F.col("CBM00S_Prior_Enrollment.CRSE_ID"),
    F.col("CBM00S_Prior_Enrollment.CRSE_OFFER_NBR"),
    F.col("CBM00S_Prior_Enrollment.END_DT"),
    F.col("CBM00S_Prior_Enrollment.INSTRUCTION_MODE"),
    F.col("CBM00S_Prior_Enrollment.LOCATION"),
    F.col("CBM00S_Prior_Enrollment.START_DT"),
    F.col("CBM00S_Prior_Enrollment.SUBJECT"),
    F.col("CBM00S_Prior_Enrollment.TERM_BEGIN_DT"),
    F.col("CBM00S_Prior_Enrollment.TERM_END_DT"),
    F.col("CBM00S_Prior_Enrollment.CENSUS_DT"),
    F.col("CBM00S_Prior_Enrollment.DLRN_Student"),
    F.col("CBM00S_Prior_Enrollment.Prior_Term"),
    F.col("CBM00S_Prior_Enrollment.CB_Exclude"),
    F.col("CBM00S_Prior_Enrollment.ENRL_TOT"),
    F.col("CBM00S_Prior_Enrollment.SSR_COMPONENT"),
    F.col("CBM00S_Prior_Enrollment.COMPONENT_PRIMARY"),
    F.col("CBM00S_Prior_Enrollment.CRSE_CONTACT_HRS"),
    F.col("CBM00S_Prior_Enrollment.UNITS_MAXIMUM"),
    F.col("CBM00S_Prior_Enrollment.SESSION_CODE"),
    F.col("CBM00S_Prior_Enrollment.Current_Term_End_date"),
    F.col("CBM00S_Prior_Enrollment.UNT_TAKEN_SEM"),
    F.col("CBM00S_Prior_Enrollment.CATALOG_NBR"),
    F.col("CBM00S_Prior_Enrollment.ACAD_GROUP"),
    F.col("CBM00S_Prior_Enrollment.ACAD_ORG"),
    F.col("CBM00S_Prior_Enrollment.CAMPUS"),
    F.col("CBM00S_Prior_Enrollment.OFFSITE_LOC_CD"),
    F.col("CBM00S_Prior_Enrollment.EXT_LOC_FICE"),
    F.col("CBM00S_Prior_Enrollment.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_Prior_Enrollment.STDNT_CAR_NBR"),
    F.col("CBM00S_Prior_Enrollment.EFFDT"),
    F.col("CBM00S_Prior_Enrollment.EFFSEQ"),
    F.col("CBM00S_Prior_Enrollment.ACAD_PLAN"),
    F.col("CBM00S_Prior_Enrollment.REQ_TERM"),
    F.col("CBM00S_Prior_Enrollment.PLAN_TBL_EFFDT"),
    F.col("CBM00S_Prior_Enrollment.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_Prior_Enrollment.ADMIT_TERM"),
    F.col("CBM00S_Prior_Enrollment.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_Prior_Enrollment.ACAD_LEVEL_BOT"),
    F.col("CBM00S_Prior_Enrollment.ACAD_LEVEL_EOT"),
    F.col("CBM00S_Prior_Enrollment.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_Prior_Enrollment.TOT_CUMULATIVE"),
    F.col("CBM00S_Prior_Enrollment.UTA_UNFN_TYPE"),
    F.col("CBM00S_Prior_Enrollment.UTA_UNFN_UNITS"),
    F.col("CBM00S_Prior_Enrollment.Excess_Emplid"),
    F.col("CBM00S_Prior_Enrollment.THREEP_CRSE_ID"),
    F.col("CBM00S_Prior_Enrollment.THREEP_UNFN_TYPE"),
    F.col("CBM00S_Prior_Enrollment.THREEP_UNT_TAKEN"),
    F.col("CBM00S_Prior_Enrollment.EXC_FLAG"),
    F.col("CBM00S_Prior_Enrollment.FLAG_3PEAT"),
    F.col("CBM00S_Prior_Enrollment.DVLP_FLAG"),
    F.col("CBM00S_Prior_Enrollment.REPEAT_CANDIDATE"),
    F.col("CBM00S_Prior_Enrollment.ADDL_ENRL"),
    F.col("CBM00S_Prior_Enrollment.PHYED_CNT_FLG"),
    F.col("CBM00S_Prior_Enrollment.CLASS_ATTR_LIST"),
    F.col("CBM00S_Prior_Enrollment.CLASS_VAL_LIST"),
    F.col("CBM00S_Prior_Enrollment.Unfunded_Flag"),
    F.col("CBM00S_Prior_Enrollment.MIN_UNITS_REQD"),
    F.col("CBM00S_Prior_Enrollment.CORE_COURSE"),
    F.col("CBM00S_Prior_Enrollment.Prior_Enrolled_Term"),
    F.col("PS_PERSON_SA.FERPA"),
    F.col("GDR_Indicator"),
    F.col("CBM00S_Prior_Enrollment.NCBO"),
    F.col("CBM00S_Prior_Enrollment.CRSE_GRADE_OFF"),
    F.col("CBM00S_Prior_Enrollment.COMBINED_SECTION_CODE"),
    F.col("CBM00S_Prior_Enrollment.CRSE_ATTR_LIST"),
    F.col("CBM00S_Prior_Enrollment.CRSE_VAL_LIST"),
    F.col("CBM00S_Prior_Enrollment.CB_Reported_Student"),
    F.col("CBM00S_Prior_Enrollment.CB_Reported_Course"),
    F.col("CBM00S_Prior_Enrollment.Current_Semester_Reportable"),
    F.col("CBM00S_Prior_Enrollment.Current_Term"),
    F.col("CBM00S_Prior_Enrollment.MathCore"),
    F.col("CBM00S_Prior_Enrollment.ReadCore"),
    F.col("CBM00S_Prior_Enrollment.WriteCore"),
    F.col("CBM00S_Prior_Enrollment.DLRN_Course"),
    F.col("CBM00S_Prior_Enrollment.AP_Course"),
)

# COMMAND ----------

# Step: SSN
# CBM00S_SSN

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

external_system = df_External_System.alias("External_System")
cbm00s_ferpa = df_cbm00s_ferpa.alias("CBM00S_Ferpa")

df_cbm00s_ssn = cbm00s_ferpa.join(
    ps_pers_nid,
    on=(
        (F.col("CBM00S_Ferpa.EMPLID") == F.col("PS_PERS_NID.EMPLID"))
        & (F.col("PS_PERS_NID.COUNTRY") == F.lit("USA"))
        & (F.col("PS_PERS_NID.NATIONAL_ID_TYPE") == F.lit("PR"))
    ),
    how="left",
).join(
    external_system,
    on=(
        (F.col("CBM00S_Ferpa.EMPLID") == F.col("External_System.EMPLID"))
        & (F.col("External_System.EXTERNAL_SYSTEM") == F.lit("CB"))
    ),
    how="left",
)

df_cbm00s_ssn = df_cbm00s_ssn.withColumn(
    "National_Id_New",
    F.when(
        (
            ~F.substring(F.col("PS_PERS_NID.NATIONAL_ID"), 1, 2).isin(["XX", "99"])
            & (F.trim(F.col("PS_PERS_NID.NATIONAL_ID")) != F.lit(""))
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
            & (F.trim(F.col("External_System.EXTERNAL_SYSTEM_ID")) != F.lit(""))
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
    .otherwise(F.concat(F.lit("9"), F.substring(F.col("CBM00S_Ferpa.EMPLID"), 3, 8))),
)

# COMMAND ----------

df_cbm00s_ssn = df_cbm00s_ssn.select(
    F.col("CBM00S_Ferpa.ACAD_CAREER"),
    F.col("National_Id_New").alias("National_Id"),
    F.col("CBM00S_Ferpa.ACAD_PROG"),
    F.col("CBM00S_Ferpa.CRSE_CAREER"),
    F.col("CBM00S_Ferpa.EMPLID"),
    F.col("CBM00S_Ferpa.ENRL_STATUS_REASON"),
    F.col("CBM00S_Ferpa.GRADE_CATEGORY"),
    F.col("CBM00S_Ferpa.GRADE_POINTS"),
    F.col("CBM00S_Ferpa.INSTITUTION"),
    F.col("CBM00S_Ferpa.STRM"),
    F.col("CBM00S_Ferpa.UNT_EARNED"),
    F.col("CBM00S_Ferpa.UNT_PRGRSS"),
    F.col("CBM00S_Ferpa.UNT_TAKEN"),
    F.col("CBM00S_Ferpa.CLASS_NBR"),
    F.col("CBM00S_Ferpa.CLASS_SECTION"),
    F.col("CBM00S_Ferpa.CLASS_STAT"),
    F.col("CBM00S_Ferpa.CLASS_TYPE"),
    F.col("CBM00S_Ferpa.COMBINED_SECTION"),
    F.col("CBM00S_Ferpa.CRSE_ID"),
    F.col("CBM00S_Ferpa.CRSE_OFFER_NBR"),
    F.col("CBM00S_Ferpa.END_DT"),
    F.col("CBM00S_Ferpa.INSTRUCTION_MODE"),
    F.col("CBM00S_Ferpa.LOCATION"),
    F.col("CBM00S_Ferpa.START_DT"),
    F.col("CBM00S_Ferpa.SUBJECT"),
    F.col("CBM00S_Ferpa.TERM_BEGIN_DT"),
    F.col("CBM00S_Ferpa.TERM_END_DT"),
    F.col("CBM00S_Ferpa.CENSUS_DT"),
    F.col("CBM00S_Ferpa.DLRN_Student"),
    F.col("CBM00S_Ferpa.Prior_Term"),
    F.col("CBM00S_Ferpa.CB_Exclude"),
    F.col("CBM00S_Ferpa.ENRL_TOT"),
    F.col("CBM00S_Ferpa.SSR_COMPONENT"),
    F.col("CBM00S_Ferpa.COMPONENT_PRIMARY"),
    F.col("CBM00S_Ferpa.CRSE_CONTACT_HRS"),
    F.col("CBM00S_Ferpa.UNITS_MAXIMUM"),
    F.col("CBM00S_Ferpa.SESSION_CODE"),
    F.col("CBM00S_Ferpa.Current_Term_End_date"),
    F.col("CBM00S_Ferpa.UNT_TAKEN_SEM"),
    F.col("CBM00S_Ferpa.CATALOG_NBR"),
    F.col("CBM00S_Ferpa.ACAD_GROUP"),
    F.col("CBM00S_Ferpa.ACAD_ORG"),
    F.col("CBM00S_Ferpa.CAMPUS"),
    F.col("CBM00S_Ferpa.OFFSITE_LOC_CD"),
    F.col("CBM00S_Ferpa.EXT_LOC_FICE"),
    F.col("CBM00S_Ferpa.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_Ferpa.STDNT_CAR_NBR"),
    F.col("CBM00S_Ferpa.EFFDT"),
    F.col("CBM00S_Ferpa.EFFSEQ"),
    F.col("CBM00S_Ferpa.ACAD_PLAN"),
    F.col("CBM00S_Ferpa.REQ_TERM"),
    F.col("CBM00S_Ferpa.PLAN_TBL_EFFDT"),
    F.col("CBM00S_Ferpa.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_Ferpa.ADMIT_TERM"),
    F.col("CBM00S_Ferpa.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_Ferpa.ACAD_LEVEL_BOT"),
    F.col("CBM00S_Ferpa.ACAD_LEVEL_EOT"),
    F.col("CBM00S_Ferpa.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_Ferpa.TOT_CUMULATIVE"),
    F.col("CBM00S_Ferpa.UTA_UNFN_TYPE"),
    F.col("CBM00S_Ferpa.UTA_UNFN_UNITS"),
    F.col("CBM00S_Ferpa.Excess_Emplid"),
    F.col("CBM00S_Ferpa.THREEP_CRSE_ID"),
    F.col("CBM00S_Ferpa.THREEP_UNFN_TYPE"),
    F.col("CBM00S_Ferpa.THREEP_UNT_TAKEN"),
    F.col("CBM00S_Ferpa.EXC_FLAG"),
    F.col("CBM00S_Ferpa.FLAG_3PEAT"),
    F.col("CBM00S_Ferpa.DVLP_FLAG"),
    F.col("CBM00S_Ferpa.REPEAT_CANDIDATE"),
    F.col("CBM00S_Ferpa.ADDL_ENRL"),
    F.col("CBM00S_Ferpa.PHYED_CNT_FLG"),
    F.col("CBM00S_Ferpa.CLASS_ATTR_LIST"),
    F.col("CBM00S_Ferpa.CLASS_VAL_LIST"),
    F.col("CBM00S_Ferpa.Unfunded_Flag"),
    F.col("CBM00S_Ferpa.MIN_UNITS_REQD"),
    F.col("CBM00S_Ferpa.CORE_COURSE"),
    F.col("CBM00S_Ferpa.Prior_Enrolled_Term"),
    F.col("CBM00S_Ferpa.FERPA"),
    F.col("CBM00S_Ferpa.GDR_Indicator"),
    F.col("CBM00S_Ferpa.NCBO"),
    F.col("CBM00S_Ferpa.CRSE_GRADE_OFF"),
    F.col("CBM00S_Ferpa.COMBINED_SECTION_CODE"),
    F.col("CBM00S_Ferpa.CRSE_ATTR_LIST"),
    F.col("CBM00S_Ferpa.CRSE_VAL_LIST"),
    F.col("CBM00S_Ferpa.CB_Reported_Student"),
    F.col("CBM00S_Ferpa.CB_Reported_Course"),
    F.col("CBM00S_Ferpa.Current_Semester_Reportable"),
    F.col("CBM00S_Ferpa.Current_Term"),
    F.col("CBM00S_Ferpa.MathCore"),
    F.col("CBM00S_Ferpa.ReadCore"),
    F.col("CBM00S_Ferpa.WriteCore"),
    F.col("CBM00S_Ferpa.DLRN_Course"),
    F.col("CBM00S_Ferpa.AP_Course"),
).distinct()

# COMMAND ----------

# Step: Admission Data
# CBM00S_Admissions

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

df_ACAD_PROG_EFFDT = df_MAX_EFFSEQ.alias("MAX_EFFSEQ")

df_ACAD_PROG_EFFDT = df_ACAD_PROG_EFFDT.withColumn(
    "_agg_tmp_0",
    F.max(F.date_format(F.col("max_effseq.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy(
            "max_effseq.EMPLID", "max_effseq.ACAD_CAREER", "max_effseq.ADMIT_TERM"
        )
    ),
)

df_ACAD_PROG_EFFDT = df_ACAD_PROG_EFFDT.filter(
    F.date_format(F.col("max_effseq.EFFDT"), "yyyy-MM-dd HH:mm:ss")
    == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

# COMMAND ----------

cbm00s_ssn = df_cbm00s_ssn.alias("CBM00S_SSN")
acad_prog_effdt = df_ACAD_PROG_EFFDT.alias("ACAD_PROG_EFFDT")

df_cbm00s_admissions = cbm00s_ssn.join(
    acad_prog_effdt,
    on=(
        (F.col("CBM00S_SSN.EMPLID") == F.col("ACAD_PROG_EFFDT.EMPLID"))
        & (F.col("CBM00S_SSN.ACAD_CAREER") == F.col("ACAD_PROG_EFFDT.ACAD_CAREER"))
        & (
            F.col("CBM00S_SSN.STRM").cast("BIGINT")
            >= F.col("ACAD_PROG_EFFDT.ADMIT_TERM").cast("BIGINT")
        )
    ),
    how="left",
)

_winSpec_3 = Window.partitionBy(
    F.col("CBM00S_SSN.EMPLID"),
    F.col("CBM00S_SSN.ACAD_CAREER"),
    F.col("CBM00S_SSN.SUBJECT"),
    F.col("CBM00S_SSN.CATALOG_NBR"),
    F.col("CBM00S_SSN.CLASS_NBR"),
)

df_cbm00s_admissions = df_cbm00s_admissions.withColumn(
    "ADM_APPL_NBR", F.max(F.col("ACAD_PROG_EFFDT.ADM_APPL_NBR")).over(_winSpec_3)
)

df_cbm00s_admissions = df_cbm00s_admissions.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ACAD_PROG_EFFDT.ADMIT_TERM")).over(_winSpec_3),
)

df_cbm00s_admissions = df_cbm00s_admissions.filter(
    F.col("ACAD_PROG_EFFDT.ADMIT_TERM") == F.col("_agg_tmp_0")
).drop("_agg_tmp_0")

# COMMAND ----------

df_cbm00s_admissions = df_cbm00s_admissions.select(
    F.col("CBM00S_SSN.ACAD_CAREER"),
    F.col("CBM00S_SSN.National_Id"),
    F.col("CBM00S_SSN.ACAD_PROG"),
    F.col("CBM00S_SSN.CRSE_CAREER"),
    F.col("CBM00S_SSN.EMPLID"),
    F.col("CBM00S_SSN.ENRL_STATUS_REASON"),
    F.col("CBM00S_SSN.GRADE_CATEGORY"),
    F.col("CBM00S_SSN.GRADE_POINTS"),
    F.col("CBM00S_SSN.INSTITUTION"),
    F.col("CBM00S_SSN.STRM"),
    F.col("CBM00S_SSN.UNT_EARNED"),
    F.col("CBM00S_SSN.UNT_PRGRSS"),
    F.col("CBM00S_SSN.UNT_TAKEN"),
    F.col("CBM00S_SSN.CLASS_NBR"),
    F.col("CBM00S_SSN.CLASS_SECTION"),
    F.col("CBM00S_SSN.CLASS_STAT"),
    F.col("CBM00S_SSN.CLASS_TYPE"),
    F.col("CBM00S_SSN.COMBINED_SECTION"),
    F.col("CBM00S_SSN.CRSE_ID"),
    F.col("CBM00S_SSN.CRSE_OFFER_NBR"),
    F.col("CBM00S_SSN.END_DT"),
    F.col("CBM00S_SSN.INSTRUCTION_MODE"),
    F.col("CBM00S_SSN.LOCATION"),
    F.col("CBM00S_SSN.START_DT"),
    F.col("CBM00S_SSN.SUBJECT"),
    F.col("CBM00S_SSN.TERM_BEGIN_DT"),
    F.col("CBM00S_SSN.TERM_END_DT"),
    F.col("CBM00S_SSN.CENSUS_DT"),
    F.col("CBM00S_SSN.DLRN_Student"),
    F.col("CBM00S_SSN.Prior_Term"),
    F.col("CBM00S_SSN.CB_Exclude"),
    F.col("CBM00S_SSN.ENRL_TOT"),
    F.col("CBM00S_SSN.SSR_COMPONENT"),
    F.col("CBM00S_SSN.COMPONENT_PRIMARY"),
    F.col("CBM00S_SSN.CRSE_CONTACT_HRS"),
    F.col("CBM00S_SSN.UNITS_MAXIMUM"),
    F.col("CBM00S_SSN.SESSION_CODE"),
    F.col("CBM00S_SSN.Current_Term_End_date"),
    F.col("CBM00S_SSN.UNT_TAKEN_SEM"),
    F.col("CBM00S_SSN.CATALOG_NBR"),
    F.col("CBM00S_SSN.ACAD_GROUP"),
    F.col("CBM00S_SSN.ACAD_ORG"),
    F.col("CBM00S_SSN.CAMPUS"),
    F.col("CBM00S_SSN.OFFSITE_LOC_CD"),
    F.col("CBM00S_SSN.EXT_LOC_FICE"),
    F.col("CBM00S_SSN.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_SSN.STDNT_CAR_NBR"),
    F.col("CBM00S_SSN.EFFDT"),
    F.col("CBM00S_SSN.EFFSEQ"),
    F.col("CBM00S_SSN.ACAD_PLAN"),
    F.col("CBM00S_SSN.REQ_TERM"),
    F.col("CBM00S_SSN.PLAN_TBL_EFFDT"),
    F.col("CBM00S_SSN.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_SSN.ADMIT_TERM"),
    F.col("CBM00S_SSN.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_SSN.ACAD_LEVEL_BOT"),
    F.col("CBM00S_SSN.ACAD_LEVEL_EOT"),
    F.col("CBM00S_SSN.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_SSN.TOT_CUMULATIVE"),
    F.col("CBM00S_SSN.UTA_UNFN_TYPE"),
    F.col("CBM00S_SSN.UTA_UNFN_UNITS"),
    F.col("CBM00S_SSN.Excess_Emplid"),
    F.col("CBM00S_SSN.THREEP_CRSE_ID"),
    F.col("CBM00S_SSN.THREEP_UNFN_TYPE"),
    F.col("CBM00S_SSN.THREEP_UNT_TAKEN"),
    F.col("CBM00S_SSN.EXC_FLAG"),
    F.col("CBM00S_SSN.FLAG_3PEAT"),
    F.col("CBM00S_SSN.DVLP_FLAG"),
    F.col("CBM00S_SSN.REPEAT_CANDIDATE"),
    F.col("CBM00S_SSN.ADDL_ENRL"),
    F.col("CBM00S_SSN.PHYED_CNT_FLG"),
    F.col("CBM00S_SSN.CLASS_ATTR_LIST"),
    F.col("CBM00S_SSN.CLASS_VAL_LIST"),
    F.col("CBM00S_SSN.Unfunded_Flag"),
    F.col("CBM00S_SSN.MIN_UNITS_REQD"),
    F.col("CBM00S_SSN.CORE_COURSE"),
    F.col("CBM00S_SSN.Prior_Enrolled_Term"),
    F.col("CBM00S_SSN.FERPA"),
    F.col("CBM00S_SSN.GDR_Indicator"),
    F.col("CBM00S_SSN.NCBO"),
    F.col("CBM00S_SSN.CRSE_GRADE_OFF"),
    F.col("CBM00S_SSN.COMBINED_SECTION_CODE"),
    F.col("ADM_APPL_NBR"),
    F.col("ACAD_PROG_EFFDT.APPL_PROG_NBR"),
    F.col("ACAD_PROG_EFFDT.STDNT_CAR_NBR").alias("ADM_STDNT_CAR_NBR"),
    F.col("ACAD_PROG_EFFDT.ADMIT_TERM").alias("ADM_ADMIT_TERM"),
    F.col("CBM00S_SSN.CRSE_ATTR_LIST"),
    F.col("CBM00S_SSN.CRSE_VAL_LIST"),
    F.col("CBM00S_SSN.CB_Reported_Student"),
    F.col("CBM00S_SSN.CB_Reported_Course"),
    F.col("CBM00S_SSN.Current_Semester_Reportable"),
    F.col("CBM00S_SSN.Current_Term"),
    F.col("CBM00S_SSN.MathCore"),
    F.col("CBM00S_SSN.ReadCore"),
    F.col("CBM00S_SSN.WriteCore"),
    F.col("CBM00S_SSN.DLRN_Course"),
    F.col("CBM00S_SSN.AP_Course"),
).distinct()

# COMMAND ----------

# Checkpoint 4: materialize df_cbm00s_admissions to break the upstream DAG
_tmp_stageD_tbl = f"{analytics}.{staging}._tmp_admissions"
write_df_to_table(
    df_cbm00s_admissions, _tmp_stageD_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm00s_admissions = read_table(_tmp_stageD_tbl).alias("CBM00S_Admissions")
log_msg(f"Checkpoint 4 materialized: {_tmp_stageD_tbl}")

# COMMAND ----------

# Step: EAP Flag
# CBM00S_EAP
df_cbm00s_eap = df_cbm00s_admissions.alias("CBM00S_Admissions")

df_cbm00s_eap = df_cbm00s_eap.join(
    ps_adm_appl_data,
    on=(
        (F.col("CBM00S_Admissions.EMPLID") == F.col("PS_ADM_APPL_DATA.EMPLID"))
        & (
            F.col("CBM00S_Admissions.ACAD_CAREER")
            == F.col("PS_ADM_APPL_DATA.ACAD_CAREER")
        )
        & (
            F.col("CBM00S_Admissions.ADM_STDNT_CAR_NBR")
            == F.col("PS_ADM_APPL_DATA.STDNT_CAR_NBR")
        )
        & (
            F.col("CBM00S_Admissions.ADM_APPL_NBR")
            == F.col("PS_ADM_APPL_DATA.ADM_APPL_NBR")
        )
    ),
    how="left",
).join(
    ps_adm_appl_rcr_ca,
    on=(
        (F.col("CBM00S_Admissions.EMPLID") == F.col("PS_ADM_APPL_RCR_CA.EMPLID"))
        & (
            F.col("CBM00S_Admissions.ACAD_CAREER")
            == F.col("PS_ADM_APPL_RCR_CA.ACAD_CAREER")
        )
        & (
            F.col("CBM00S_Admissions.ADM_STDNT_CAR_NBR")
            == F.col("PS_ADM_APPL_RCR_CA.STDNT_CAR_NBR")
        )
        & (
            F.col("CBM00S_Admissions.ADM_APPL_NBR")
            == F.col("PS_ADM_APPL_RCR_CA.ADM_APPL_NBR")
        )
        & (
            F.col("CBM00S_Admissions.INSTITUTION")
            == F.col("PS_ADM_APPL_RCR_CA.INSTITUTION")
        )
        & (F.col("PS_ADM_APPL_RCR_CA.RECRUITMENT_CAT") == F.lit("AUEA"))
    ),
    how="left",
)

# COMMAND ----------

df_cbm00s_eap = df_cbm00s_eap.select(
    F.col("CBM00S_Admissions.ACAD_CAREER"),
    F.col("CBM00S_Admissions.National_Id"),
    F.col("CBM00S_Admissions.ACAD_PROG"),
    F.col("CBM00S_Admissions.CRSE_CAREER"),
    F.col("CBM00S_Admissions.EMPLID"),
    F.col("CBM00S_Admissions.ENRL_STATUS_REASON"),
    F.col("CBM00S_Admissions.GRADE_CATEGORY"),
    F.col("CBM00S_Admissions.GRADE_POINTS"),
    F.col("CBM00S_Admissions.INSTITUTION"),
    F.col("CBM00S_Admissions.STRM"),
    F.col("CBM00S_Admissions.UNT_EARNED"),
    F.col("CBM00S_Admissions.UNT_PRGRSS"),
    F.col("CBM00S_Admissions.UNT_TAKEN"),
    F.col("CBM00S_Admissions.CLASS_NBR"),
    F.col("CBM00S_Admissions.CLASS_SECTION"),
    F.col("CBM00S_Admissions.CLASS_STAT"),
    F.col("CBM00S_Admissions.CLASS_TYPE"),
    F.col("CBM00S_Admissions.COMBINED_SECTION"),
    F.col("CBM00S_Admissions.CRSE_ID"),
    F.col("CBM00S_Admissions.CRSE_OFFER_NBR"),
    F.col("CBM00S_Admissions.END_DT"),
    F.col("CBM00S_Admissions.INSTRUCTION_MODE"),
    F.col("CBM00S_Admissions.LOCATION"),
    F.col("CBM00S_Admissions.START_DT"),
    F.col("CBM00S_Admissions.SUBJECT"),
    F.col("CBM00S_Admissions.TERM_BEGIN_DT"),
    F.col("CBM00S_Admissions.TERM_END_DT"),
    F.col("CBM00S_Admissions.CENSUS_DT"),
    F.col("CBM00S_Admissions.DLRN_Student"),
    F.col("CBM00S_Admissions.Prior_Term"),
    F.col("CBM00S_Admissions.CB_Exclude"),
    F.col("CBM00S_Admissions.ENRL_TOT"),
    F.col("CBM00S_Admissions.SSR_COMPONENT"),
    F.col("CBM00S_Admissions.COMPONENT_PRIMARY"),
    F.col("CBM00S_Admissions.CRSE_CONTACT_HRS"),
    F.col("CBM00S_Admissions.UNITS_MAXIMUM"),
    F.col("CBM00S_Admissions.SESSION_CODE"),
    F.col("CBM00S_Admissions.Current_Term_End_date"),
    F.col("CBM00S_Admissions.UNT_TAKEN_SEM"),
    F.col("CBM00S_Admissions.CATALOG_NBR"),
    F.col("CBM00S_Admissions.ACAD_GROUP"),
    F.col("CBM00S_Admissions.ACAD_ORG"),
    F.col("CBM00S_Admissions.CAMPUS"),
    F.col("CBM00S_Admissions.OFFSITE_LOC_CD"),
    F.col("CBM00S_Admissions.EXT_LOC_FICE"),
    F.col("CBM00S_Admissions.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_Admissions.STDNT_CAR_NBR"),
    F.col("CBM00S_Admissions.EFFDT"),
    F.col("CBM00S_Admissions.EFFSEQ"),
    F.col("CBM00S_Admissions.ACAD_PLAN"),
    F.col("CBM00S_Admissions.REQ_TERM"),
    F.col("CBM00S_Admissions.PLAN_TBL_EFFDT"),
    F.col("CBM00S_Admissions.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_Admissions.ADMIT_TERM"),
    F.col("CBM00S_Admissions.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_Admissions.ACAD_LEVEL_BOT"),
    F.col("CBM00S_Admissions.ACAD_LEVEL_EOT"),
    F.col("CBM00S_Admissions.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_Admissions.TOT_CUMULATIVE"),
    F.col("CBM00S_Admissions.UTA_UNFN_TYPE"),
    F.col("CBM00S_Admissions.UTA_UNFN_UNITS"),
    F.col("CBM00S_Admissions.Excess_Emplid"),
    F.col("CBM00S_Admissions.THREEP_CRSE_ID"),
    F.col("CBM00S_Admissions.THREEP_UNFN_TYPE"),
    F.col("CBM00S_Admissions.THREEP_UNT_TAKEN"),
    F.col("CBM00S_Admissions.EXC_FLAG"),
    F.col("CBM00S_Admissions.FLAG_3PEAT"),
    F.col("CBM00S_Admissions.DVLP_FLAG"),
    F.col("CBM00S_Admissions.REPEAT_CANDIDATE"),
    F.col("CBM00S_Admissions.ADDL_ENRL"),
    F.col("CBM00S_Admissions.PHYED_CNT_FLG"),
    F.col("CBM00S_Admissions.CLASS_ATTR_LIST"),
    F.col("CBM00S_Admissions.CLASS_VAL_LIST"),
    F.col("CBM00S_Admissions.Unfunded_Flag"),
    F.col("CBM00S_Admissions.MIN_UNITS_REQD"),
    F.col("CBM00S_Admissions.CORE_COURSE"),
    F.col("CBM00S_Admissions.Prior_Enrolled_Term"),
    F.col("CBM00S_Admissions.FERPA"),
    F.col("CBM00S_Admissions.GDR_Indicator"),
    F.col("CBM00S_Admissions.NCBO"),
    F.col("CBM00S_Admissions.CRSE_GRADE_OFF"),
    F.col("CBM00S_Admissions.COMBINED_SECTION_CODE"),
    F.col("CBM00S_Admissions.ADM_APPL_NBR"),
    F.col("CBM00S_Admissions.ADM_ADMIT_TERM"),
    F.col("PS_ADM_APPL_DATA.ADMIT_TYPE"),
    F.col("PS_ADM_APPL_RCR_CA.RECRUITMENT_CAT"),
    F.col("CBM00S_Admissions.CRSE_ATTR_LIST"),
    F.col("CBM00S_Admissions.CRSE_VAL_LIST"),
    F.col("CBM00S_Admissions.CB_Reported_Student"),
    F.col("CBM00S_Admissions.CB_Reported_Course"),
    F.col("CBM00S_Admissions.Current_Semester_Reportable"),
    F.col("CBM00S_Admissions.Current_Term"),
    F.col("CBM00S_Admissions.MathCore"),
    F.col("CBM00S_Admissions.ReadCore"),
    F.col("CBM00S_Admissions.WriteCore"),
    F.col("CBM00S_Admissions.DLRN_Course"),
    F.col("CBM00S_Admissions.AP_Course"),
)

# COMMAND ----------

# Step: AP and DLRN - CBM00S_AP
df_cbm00s_ap = df_cbm00s_eap.alias("CBM00S_EAP")

df_cbm00s_ap = df_cbm00s_ap.join(
    ps_uta_heh_plan_tb,
    on=(
        (F.col("CBM00S_EAP.ACAD_CAREER") == F.col("PS_UTA_HEH_PLAN_TB.ACAD_CAREER"))
        & (F.col("CBM00S_EAP.ACAD_PLAN") == F.col("PS_UTA_HEH_PLAN_TB.ACAD_PLAN"))
    ),
    how="left",
)

df_cbm00s_ap = df_cbm00s_ap.select(
    F.col("CBM00S_EAP.ACAD_CAREER"),
    F.col("CBM00S_EAP.National_Id"),
    F.col("CBM00S_EAP.ACAD_PROG"),
    F.col("CBM00S_EAP.CRSE_CAREER"),
    F.col("CBM00S_EAP.EMPLID"),
    F.col("CBM00S_EAP.ENRL_STATUS_REASON"),
    F.col("CBM00S_EAP.GRADE_CATEGORY"),
    F.col("CBM00S_EAP.GRADE_POINTS"),
    F.col("CBM00S_EAP.INSTITUTION"),
    F.col("CBM00S_EAP.STRM"),
    F.col("CBM00S_EAP.UNT_EARNED"),
    F.col("CBM00S_EAP.UNT_PRGRSS"),
    F.col("CBM00S_EAP.UNT_TAKEN"),
    F.col("CBM00S_EAP.CLASS_NBR"),
    F.col("CBM00S_EAP.CLASS_SECTION"),
    F.col("CBM00S_EAP.CLASS_STAT"),
    F.col("CBM00S_EAP.CLASS_TYPE"),
    F.col("CBM00S_EAP.COMBINED_SECTION"),
    F.col("CBM00S_EAP.CRSE_ID"),
    F.col("CBM00S_EAP.CRSE_OFFER_NBR"),
    F.col("CBM00S_EAP.END_DT"),
    F.col("CBM00S_EAP.INSTRUCTION_MODE"),
    F.col("CBM00S_EAP.LOCATION"),
    F.col("CBM00S_EAP.START_DT"),
    F.col("CBM00S_EAP.SUBJECT"),
    F.col("CBM00S_EAP.TERM_BEGIN_DT"),
    F.col("CBM00S_EAP.TERM_END_DT"),
    F.col("CBM00S_EAP.CENSUS_DT"),
    F.col("CBM00S_EAP.DLRN_Student"),
    F.col("CBM00S_EAP.Prior_Term"),
    F.col("CBM00S_EAP.CB_Exclude"),
    F.col("CBM00S_EAP.ENRL_TOT"),
    F.col("CBM00S_EAP.SSR_COMPONENT"),
    F.col("CBM00S_EAP.COMPONENT_PRIMARY"),
    F.col("CBM00S_EAP.CRSE_CONTACT_HRS"),
    F.col("CBM00S_EAP.UNITS_MAXIMUM"),
    F.col("CBM00S_EAP.SESSION_CODE"),
    F.col("CBM00S_EAP.Current_Term_End_date"),
    F.col("CBM00S_EAP.UNT_TAKEN_SEM"),
    F.col("CBM00S_EAP.CATALOG_NBR"),
    F.col("CBM00S_EAP.ACAD_GROUP"),
    F.col("CBM00S_EAP.ACAD_ORG"),
    F.col("CBM00S_EAP.CAMPUS"),
    F.col("CBM00S_EAP.OFFSITE_LOC_CD"),
    F.col("CBM00S_EAP.EXT_LOC_FICE"),
    F.col("CBM00S_EAP.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_EAP.STDNT_CAR_NBR"),
    F.col("CBM00S_EAP.EFFDT"),
    F.col("CBM00S_EAP.EFFSEQ"),
    F.col("CBM00S_EAP.ACAD_PLAN"),
    F.col("CBM00S_EAP.REQ_TERM"),
    F.col("CBM00S_EAP.PLAN_TBL_EFFDT"),
    F.col("CBM00S_EAP.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_EAP.ADMIT_TERM"),
    F.col("CBM00S_EAP.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_EAP.ACAD_LEVEL_BOT"),
    F.col("CBM00S_EAP.ACAD_LEVEL_EOT"),
    F.col("CBM00S_EAP.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_EAP.TOT_CUMULATIVE"),
    F.col("CBM00S_EAP.UTA_UNFN_TYPE"),
    F.col("CBM00S_EAP.UTA_UNFN_UNITS"),
    F.col("CBM00S_EAP.Excess_Emplid"),
    F.col("CBM00S_EAP.THREEP_CRSE_ID"),
    F.col("CBM00S_EAP.THREEP_UNFN_TYPE"),
    F.col("CBM00S_EAP.THREEP_UNT_TAKEN"),
    F.col("CBM00S_EAP.EXC_FLAG"),
    F.col("CBM00S_EAP.FLAG_3PEAT"),
    F.col("CBM00S_EAP.DVLP_FLAG"),
    F.col("CBM00S_EAP.REPEAT_CANDIDATE"),
    F.col("CBM00S_EAP.ADDL_ENRL"),
    F.col("CBM00S_EAP.PHYED_CNT_FLG"),
    F.col("CBM00S_EAP.CLASS_ATTR_LIST"),
    F.col("CBM00S_EAP.CLASS_VAL_LIST"),
    F.col("CBM00S_EAP.Unfunded_Flag"),
    F.col("CBM00S_EAP.MIN_UNITS_REQD"),
    F.col("CBM00S_EAP.CORE_COURSE"),
    F.col("CBM00S_EAP.Prior_Enrolled_Term"),
    F.col("CBM00S_EAP.FERPA"),
    F.col("CBM00S_EAP.GDR_Indicator"),
    F.col("CBM00S_EAP.NCBO"),
    F.col("CBM00S_EAP.CRSE_GRADE_OFF"),
    F.col("CBM00S_EAP.COMBINED_SECTION_CODE"),
    F.col("CBM00S_EAP.ADM_APPL_NBR"),
    F.col("CBM00S_EAP.ADM_ADMIT_TERM"),
    F.col("CBM00S_EAP.ADMIT_TYPE"),
    F.col("CBM00S_EAP.RECRUITMENT_CAT"),
    F.col("CBM00S_EAP.CRSE_ATTR_LIST"),
    F.col("CBM00S_EAP.CRSE_VAL_LIST"),
    F.when(
        (
            F.col("PS_UTA_HEH_PLAN_TB.ACAD_PLAN").isNotNull()
            & (F.col("PS_UTA_HEH_PLAN_TB.ACAD_PLAN") != F.lit(""))
        ),
        F.lit("Yes"),
    )
    .otherwise(F.lit("No"))
    .alias("AP_Student"),
    F.col("CBM00S_EAP.DLRN_Course"),
    F.col("CBM00S_EAP.AP_Course"),
    F.col("CBM00S_EAP.CB_Reported_Student"),
    F.col("CBM00S_EAP.CB_Reported_Course"),
    F.col("CBM00S_EAP.Current_Semester_Reportable"),
    F.col("CBM00S_EAP.Current_Term"),
    F.col("CBM00S_EAP.MathCore"),
    F.col("CBM00S_EAP.ReadCore"),
    F.col("CBM00S_EAP.WriteCore"),
)

# COMMAND ----------

# Step: Prior College Class
# CBM00S_Prior_College_Course
df_cbm00s_prior_college_course = df_cbm00s_ap.alias("CBM00S_AP")

df_cbm00s_prior_college_course = df_cbm00s_prior_college_course.join(
    ps_trns_test_dtl,
    on=(
        (F.col("CBM00S_AP.EMPLID") == F.col("PS_TRNS_TEST_DTL.EMPLID"))
        & (F.col("CBM00S_AP.ACAD_CAREER") == F.col("PS_TRNS_TEST_DTL.ACAD_CAREER"))
        & F.col("PS_TRNS_TEST_DTL.TEST_ID").isin(["AP", "CLEP", "IB"])
        & F.col("PS_TRNS_TEST_DTL.RQMNT_DESIGNTN").isin(
            [
                "020",
                "2092",
                "092",
                "040",
                "060",
                "070",
                "080",
                "098",
                "4094",
                "8098",
                "010",
                "1091",
            ]
        )
    ),
    how="left",
).join(
    ps_trns_crse_dtl,
    on=(
        (F.col("CBM00S_AP.EMPLID") == F.col("PS_TRNS_CRSE_DTL.EMPLID"))
        & (F.col("PS_TRNS_CRSE_DTL.ACAD_CAREER") == F.lit("UGRD"))
        & (F.col("PS_TRNS_CRSE_DTL.INSTITUTION") == F.lit("UTARL"))
        & F.col("PS_TRNS_CRSE_DTL.RQMNT_DESIGNTN").isin(
            [
                "020",
                "2092",
                "092",
                "040",
                "060",
                "070",
                "080",
                "098",
                "4094",
                "8098",
                "010",
                "1091",
            ]
        )
    ),
    how="left",
)

_winSpec_4 = Window.partitionBy(
    F.col("PS_TRNS_TEST_DTL.EMPLID"), F.col("PS_TRNS_TEST_DTL.ACAD_CAREER")
)

df_cbm00s_prior_college_course = df_cbm00s_prior_college_course.withColumn(
    "_agg_tmp_0",
    F.min(F.col("PS_TRNS_TEST_DTL.ARTICULATION_TERM")).over(_winSpec_4),
)

df_cbm00s_prior_college_course = df_cbm00s_prior_college_course.filter(
    F.coalesce(F.col("PS_TRNS_TEST_DTL.ARTICULATION_TERM"), F.lit(""))
    == F.coalesce(F.col("_agg_tmp_0"), F.lit(""))
).drop("_agg_tmp_0")

df_cbm00s_prior_college_course = df_cbm00s_prior_college_course.withColumn(
    "ARTICULATION_TERM_NEW",
    F.min(F.col("PS_TRNS_TEST_DTL.ARTICULATION_TERM")).over(_winSpec_4),
)

df_cbm00s_prior_college_course = df_cbm00s_prior_college_course.withColumn(
    "Prior_Crse_Transfer",
    F.when(
        (
            F.col("PS_TRNS_CRSE_DTL.RQMNT_DESIGNTN").isNotNull()
            & (F.col("PS_TRNS_CRSE_DTL.RQMNT_DESIGNTN") != F.lit(""))
        ),
        F.lit("Yes"),
    ).otherwise(F.lit("No")),
)

# COMMAND ----------

df_cbm00s_prior_college_course = df_cbm00s_prior_college_course.select(
    F.col("CBM00S_AP.ACAD_CAREER"),
    F.col("CBM00S_AP.National_Id"),
    F.col("CBM00S_AP.ACAD_PROG"),
    F.col("CBM00S_AP.CRSE_CAREER"),
    F.col("CBM00S_AP.EMPLID"),
    F.col("CBM00S_AP.ENRL_STATUS_REASON"),
    F.col("CBM00S_AP.GRADE_CATEGORY"),
    F.col("CBM00S_AP.GRADE_POINTS"),
    F.col("CBM00S_AP.INSTITUTION"),
    F.col("CBM00S_AP.STRM"),
    F.col("CBM00S_AP.UNT_EARNED"),
    F.col("CBM00S_AP.UNT_PRGRSS"),
    F.col("CBM00S_AP.UNT_TAKEN"),
    F.col("CBM00S_AP.CLASS_NBR"),
    F.col("CBM00S_AP.CLASS_SECTION"),
    F.col("CBM00S_AP.CLASS_STAT"),
    F.col("CBM00S_AP.CLASS_TYPE"),
    F.col("CBM00S_AP.COMBINED_SECTION"),
    F.col("CBM00S_AP.CRSE_ID"),
    F.col("CBM00S_AP.CRSE_OFFER_NBR"),
    F.col("CBM00S_AP.END_DT"),
    F.col("CBM00S_AP.INSTRUCTION_MODE"),
    F.col("CBM00S_AP.LOCATION"),
    F.col("CBM00S_AP.START_DT"),
    F.col("CBM00S_AP.SUBJECT"),
    F.col("CBM00S_AP.TERM_BEGIN_DT"),
    F.col("CBM00S_AP.TERM_END_DT"),
    F.col("CBM00S_AP.CENSUS_DT"),
    F.col("CBM00S_AP.DLRN_Student"),
    F.col("CBM00S_AP.Prior_Term"),
    F.col("CBM00S_AP.CB_Exclude"),
    F.col("CBM00S_AP.ENRL_TOT"),
    F.col("CBM00S_AP.SSR_COMPONENT"),
    F.col("CBM00S_AP.COMPONENT_PRIMARY"),
    F.col("CBM00S_AP.CRSE_CONTACT_HRS"),
    F.col("CBM00S_AP.UNITS_MAXIMUM"),
    F.col("CBM00S_AP.SESSION_CODE"),
    F.col("CBM00S_AP.Current_Term_End_date"),
    F.col("CBM00S_AP.UNT_TAKEN_SEM"),
    F.col("CBM00S_AP.CATALOG_NBR"),
    F.col("CBM00S_AP.ACAD_GROUP"),
    F.col("CBM00S_AP.ACAD_ORG"),
    F.col("CBM00S_AP.CAMPUS"),
    F.col("CBM00S_AP.OFFSITE_LOC_CD"),
    F.col("CBM00S_AP.EXT_LOC_FICE"),
    F.col("CBM00S_AP.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_AP.STDNT_CAR_NBR"),
    F.col("CBM00S_AP.EFFDT"),
    F.col("CBM00S_AP.EFFSEQ"),
    F.col("CBM00S_AP.ACAD_PLAN"),
    F.col("CBM00S_AP.REQ_TERM"),
    F.col("CBM00S_AP.PLAN_TBL_EFFDT"),
    F.col("CBM00S_AP.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_AP.ADMIT_TERM"),
    F.col("CBM00S_AP.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_AP.ACAD_LEVEL_BOT"),
    F.col("CBM00S_AP.ACAD_LEVEL_EOT"),
    F.col("CBM00S_AP.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_AP.TOT_CUMULATIVE"),
    F.col("CBM00S_AP.UTA_UNFN_TYPE"),
    F.col("CBM00S_AP.UTA_UNFN_UNITS"),
    F.col("CBM00S_AP.Excess_Emplid"),
    F.col("CBM00S_AP.THREEP_CRSE_ID"),
    F.col("CBM00S_AP.THREEP_UNFN_TYPE"),
    F.col("CBM00S_AP.THREEP_UNT_TAKEN"),
    F.col("CBM00S_AP.EXC_FLAG"),
    F.col("CBM00S_AP.FLAG_3PEAT"),
    F.col("CBM00S_AP.DVLP_FLAG"),
    F.col("CBM00S_AP.REPEAT_CANDIDATE"),
    F.col("CBM00S_AP.ADDL_ENRL"),
    F.col("CBM00S_AP.PHYED_CNT_FLG"),
    F.col("CBM00S_AP.CLASS_ATTR_LIST"),
    F.col("CBM00S_AP.CLASS_VAL_LIST"),
    F.col("CBM00S_AP.Unfunded_Flag"),
    F.col("CBM00S_AP.MIN_UNITS_REQD"),
    F.col("CBM00S_AP.CORE_COURSE"),
    F.col("CBM00S_AP.Prior_Enrolled_Term"),
    F.col("CBM00S_AP.FERPA"),
    F.col("CBM00S_AP.GDR_Indicator"),
    F.col("CBM00S_AP.NCBO"),
    F.col("CBM00S_AP.CRSE_GRADE_OFF"),
    F.col("CBM00S_AP.COMBINED_SECTION_CODE"),
    F.col("CBM00S_AP.ADM_APPL_NBR"),
    F.col("CBM00S_AP.ADM_ADMIT_TERM"),
    F.col("CBM00S_AP.ADMIT_TYPE"),
    F.col("CBM00S_AP.RECRUITMENT_CAT"),
    F.coalesce(F.col("ARTICULATION_TERM_NEW"), F.lit(" ")).alias("ARTICULATION_TERM"),
    F.col("CBM00S_AP.CRSE_ATTR_LIST"),
    F.col("CBM00S_AP.CRSE_VAL_LIST"),
    F.col("CBM00S_AP.AP_Student"),
    F.col("CBM00S_AP.AP_Course"),
    F.col("CBM00S_AP.DLRN_Course"),
    F.col("CBM00S_AP.CB_Reported_Student"),
    F.col("CBM00S_AP.CB_Reported_Course"),
    F.col("CBM00S_AP.Current_Semester_Reportable"),
    F.col("Prior_Crse_Transfer"),
    F.col("CBM00S_AP.Current_Term"),
    F.col("CBM00S_AP.MathCore"),
    F.col("CBM00S_AP.ReadCore"),
    F.col("CBM00S_AP.WriteCore"),
).distinct()

# COMMAND ----------

# Step: PRE1998
# CBMS_PRE98

# df_PRE_0998_ENRL
df_PRE_0998_ENRL = ps_stdnt_enrl.filter(
    (F.coalesce(F.col("PS_STDNT_ENRL.STRM"), F.lit("")) < F.lit("0998"))
    & (F.coalesce(F.col("PS_STDNT_ENRL.STDNT_ENRL_STATUS"), F.lit("")) == F.lit("E"))
    & (
        (F.coalesce(F.col("PS_STDNT_ENRL.CRSE_GRADE_OFF"), F.lit("")) != F.lit("AU"))
        | (
            F.coalesce(F.col("PS_STDNT_ENRL.GRADING_BASIS_ENRL"), F.lit(""))
            != F.lit("AUD")
        )
    )
)

# df_PRE_0998_TRNS
df_PRE_0998_TRNS = ps_trns_crse_dtl.filter(
    (F.col("PS_TRNS_CRSE_DTL.TERM_YEAR") > F.lit(1900))
    & (
        (F.col("PS_TRNS_CRSE_DTL.TERM_YEAR") < F.lit(1999))
        | (
            (F.col("PS_TRNS_CRSE_DTL.TERM_YEAR") == F.lit(1999))
            & ~F.col("PS_TRNS_CRSE_DTL.EXT_TERM").isin(["FALL", "WINT"])
        )
    )
)

# df_PS_EXT_COURSE_PRE_0998
df_PS_EXT_COURSE_PRE_0998 = ps_ext_course.filter(
    (F.col("ps_ext_course.TERM_YEAR") > F.lit(1900))
    & (
        (F.col("ps_ext_course.TERM_YEAR") < F.lit(1999))
        | (
            (F.col("ps_ext_course.TERM_YEAR") == F.lit(1999))
            & ~F.col("ps_ext_course.EXT_TERM").isin(["FALL", "WINT"])
        )
    )
)

cbm00s_prior_college_course = df_cbm00s_prior_college_course.alias(
    "CBM00S_Prior_College_Course"
)
pre_0998_enrl = df_PRE_0998_ENRL.alias("PRE_0998_ENRL")
pre_0998_trns = df_PRE_0998_TRNS.alias("PRE_0998_TRNS")
ps_ext_course_pre_0998 = df_PS_EXT_COURSE_PRE_0998.alias("PS_EXT_COURSE_PRE_0998")

df_cbms_pre98 = (
    cbm00s_prior_college_course.join(
        pre_0998_enrl,
        on=(
            F.col("CBM00S_Prior_College_Course.ACAD_LEVEL_BOT").isin(
                ["10", "20", "30", "40"]
            )
            & (
                F.col("CBM00S_Prior_College_Course.EMPLID")
                == F.col("PRE_0998_ENRL.EMPLID")
            )
        ),
        how="left",
    )
    .join(
        pre_0998_trns,
        on=(
            (
                F.col("PRE_0998_ENRL.EMPLID").isNull()
                | (F.trim(F.col("PRE_0998_ENRL.EMPLID")) == F.lit(""))
            )
            & (
                F.col("CBM00S_Prior_College_Course.EMPLID")
                == F.col("PRE_0998_TRNS.EMPLID")
            )
        ),
        how="left",
    )
    .join(
        ps_ext_course_pre_0998,
        on=(
            (
                F.col("PRE_0998_ENRL.EMPLID").isNull()
                | (F.trim(F.col("PRE_0998_ENRL.EMPLID")) == F.lit(""))
            )
            & (
                F.col("PRE_0998_TRNS.EMPLID").isNull()
                | (F.trim(F.col("PRE_0998_TRNS.EMPLID")) == F.lit(""))
            )
            & (
                F.col("CBM00S_Prior_College_Course.EMPLID")
                == F.col("PS_EXT_COURSE_PRE_0998.EMPLID")
            )
        ),
        how="left",
    )
)

# COMMAND ----------

df_cbms_pre98 = df_cbms_pre98.select(
    F.col("CBM00S_Prior_College_Course.ACAD_CAREER"),
    F.col("CBM00S_Prior_College_Course.National_Id"),
    F.col("CBM00S_Prior_College_Course.ACAD_PROG"),
    F.col("CBM00S_Prior_College_Course.CRSE_CAREER"),
    F.col("CBM00S_Prior_College_Course.EMPLID"),
    F.col("CBM00S_Prior_College_Course.ENRL_STATUS_REASON"),
    F.col("CBM00S_Prior_College_Course.GRADE_CATEGORY"),
    F.col("CBM00S_Prior_College_Course.GRADE_POINTS"),
    F.col("CBM00S_Prior_College_Course.INSTITUTION"),
    F.col("CBM00S_Prior_College_Course.STRM"),
    F.col("CBM00S_Prior_College_Course.UNT_EARNED"),
    F.col("CBM00S_Prior_College_Course.UNT_PRGRSS"),
    F.col("CBM00S_Prior_College_Course.UNT_TAKEN"),
    F.col("CBM00S_Prior_College_Course.CLASS_NBR"),
    F.col("CBM00S_Prior_College_Course.CLASS_SECTION"),
    F.col("CBM00S_Prior_College_Course.CLASS_STAT"),
    F.col("CBM00S_Prior_College_Course.CLASS_TYPE"),
    F.col("CBM00S_Prior_College_Course.COMBINED_SECTION"),
    F.col("CBM00S_Prior_College_Course.CRSE_ID"),
    F.col("CBM00S_Prior_College_Course.CRSE_OFFER_NBR"),
    F.col("CBM00S_Prior_College_Course.END_DT"),
    F.col("CBM00S_Prior_College_Course.INSTRUCTION_MODE"),
    F.col("CBM00S_Prior_College_Course.LOCATION"),
    F.col("CBM00S_Prior_College_Course.START_DT"),
    F.col("CBM00S_Prior_College_Course.SUBJECT"),
    F.col("CBM00S_Prior_College_Course.TERM_BEGIN_DT"),
    F.col("CBM00S_Prior_College_Course.TERM_END_DT"),
    F.col("CBM00S_Prior_College_Course.CENSUS_DT"),
    F.col("CBM00S_Prior_College_Course.DLRN_Student"),
    F.col("CBM00S_Prior_College_Course.Prior_Term"),
    F.col("CBM00S_Prior_College_Course.CB_Exclude"),
    F.col("CBM00S_Prior_College_Course.ENRL_TOT"),
    F.col("CBM00S_Prior_College_Course.SSR_COMPONENT"),
    F.col("CBM00S_Prior_College_Course.COMPONENT_PRIMARY"),
    F.col("CBM00S_Prior_College_Course.CRSE_CONTACT_HRS"),
    F.col("CBM00S_Prior_College_Course.UNITS_MAXIMUM"),
    F.col("CBM00S_Prior_College_Course.SESSION_CODE"),
    F.col("CBM00S_Prior_College_Course.Current_Term_End_date"),
    F.col("CBM00S_Prior_College_Course.UNT_TAKEN_SEM"),
    F.col("CBM00S_Prior_College_Course.CATALOG_NBR"),
    F.col("CBM00S_Prior_College_Course.ACAD_GROUP"),
    F.col("CBM00S_Prior_College_Course.ACAD_ORG"),
    F.col("CBM00S_Prior_College_Course.CAMPUS"),
    F.col("CBM00S_Prior_College_Course.OFFSITE_LOC_CD"),
    F.col("CBM00S_Prior_College_Course.EXT_LOC_FICE"),
    F.col("CBM00S_Prior_College_Course.UTA_CB_LOCATION_CD"),
    F.col("CBM00S_Prior_College_Course.STDNT_CAR_NBR"),
    F.col("CBM00S_Prior_College_Course.EFFDT"),
    F.col("CBM00S_Prior_College_Course.EFFSEQ"),
    F.col("CBM00S_Prior_College_Course.ACAD_PLAN"),
    F.col("CBM00S_Prior_College_Course.REQ_TERM"),
    F.col("CBM00S_Prior_College_Course.PLAN_TBL_EFFDT"),
    F.col("CBM00S_Prior_College_Course.PLAN_TBL_ACAD_PROG"),
    F.col("CBM00S_Prior_College_Course.ADMIT_TERM"),
    F.col("CBM00S_Prior_College_Course.DEGR_CHKOUT_STAT"),
    F.col("CBM00S_Prior_College_Course.ACAD_LEVEL_BOT"),
    F.col("CBM00S_Prior_College_Course.ACAD_LEVEL_EOT"),
    F.col("CBM00S_Prior_College_Course.ACAD_PROG_PRIMARY"),
    F.col("CBM00S_Prior_College_Course.TOT_CUMULATIVE"),
    F.col("CBM00S_Prior_College_Course.UTA_UNFN_TYPE"),
    F.col("CBM00S_Prior_College_Course.UTA_UNFN_UNITS"),
    F.col("CBM00S_Prior_College_Course.Excess_Emplid"),
    F.col("CBM00S_Prior_College_Course.THREEP_CRSE_ID"),
    F.col("CBM00S_Prior_College_Course.THREEP_UNFN_TYPE"),
    F.col("CBM00S_Prior_College_Course.THREEP_UNT_TAKEN"),
    F.col("CBM00S_Prior_College_Course.EXC_FLAG"),
    F.col("CBM00S_Prior_College_Course.FLAG_3PEAT"),
    F.col("CBM00S_Prior_College_Course.DVLP_FLAG"),
    F.col("CBM00S_Prior_College_Course.REPEAT_CANDIDATE"),
    F.col("CBM00S_Prior_College_Course.ADDL_ENRL"),
    F.col("CBM00S_Prior_College_Course.PHYED_CNT_FLG"),
    F.col("CBM00S_Prior_College_Course.CLASS_ATTR_LIST"),
    F.col("CBM00S_Prior_College_Course.CLASS_VAL_LIST"),
    F.col("CBM00S_Prior_College_Course.Unfunded_Flag"),
    F.col("CBM00S_Prior_College_Course.MIN_UNITS_REQD"),
    F.col("CBM00S_Prior_College_Course.CORE_COURSE"),
    F.col("CBM00S_Prior_College_Course.Prior_Enrolled_Term"),
    F.col("CBM00S_Prior_College_Course.FERPA"),
    F.col("CBM00S_Prior_College_Course.GDR_Indicator"),
    F.col("CBM00S_Prior_College_Course.NCBO"),
    F.col("CBM00S_Prior_College_Course.CRSE_GRADE_OFF"),
    F.col("CBM00S_Prior_College_Course.COMBINED_SECTION_CODE"),
    F.col("CBM00S_Prior_College_Course.ADM_APPL_NBR"),
    F.col("CBM00S_Prior_College_Course.ADM_ADMIT_TERM"),
    F.col("CBM00S_Prior_College_Course.ADMIT_TYPE"),
    F.col("CBM00S_Prior_College_Course.RECRUITMENT_CAT"),
    F.col("CBM00S_Prior_College_Course.ARTICULATION_TERM"),
    F.col("CBM00S_Prior_College_Course.CRSE_ATTR_LIST"),
    F.col("CBM00S_Prior_College_Course.CRSE_VAL_LIST"),
    F.col("CBM00S_Prior_College_Course.AP_Student"),
    F.col("CBM00S_Prior_College_Course.AP_Course"),
    F.col("CBM00S_Prior_College_Course.DLRN_Course"),
    F.col("CBM00S_Prior_College_Course.CB_Reported_Student"),
    F.col("CBM00S_Prior_College_Course.CB_Reported_Course"),
    F.col("CBM00S_Prior_College_Course.Current_Semester_Reportable"),
    F.col("CBM00S_Prior_College_Course.Prior_Crse_Transfer"),
    F.col("CBM00S_Prior_College_Course.Current_Term"),
    F.col("CBM00S_Prior_College_Course.MathCore"),
    F.col("CBM00S_Prior_College_Course.ReadCore"),
    F.col("CBM00S_Prior_College_Course.WriteCore"),
    F.when(
        (
            (F.trim(F.col("PRE_0998_ENRL.EMPLID")) != F.lit(""))
            | (F.trim(F.col("PRE_0998_TRNS.EMPLID")) != F.lit(""))
            | (F.trim(F.col("PS_EXT_COURSE_PRE_0998.EMPLID")) != F.lit(""))
        ),
        F.lit("Y"),
    )
    .otherwise(F.lit("N"))
    .alias("PRE1998"),
).distinct()

# COMMAND ----------

# Checkpoint 5: materialize df_cbms_pre98 to break the upstream DAG
_tmp_stageE_tbl = f"{analytics}.{staging}._tmp_cbm00s_pre98"
write_df_to_table(
    df_cbms_pre98, _tmp_stageE_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbms_pre98 = read_table(_tmp_stageE_tbl).alias("CBMS_PRE98")
log_msg(f"Checkpoint 5 materialized: {_tmp_stageE_tbl}")

# COMMAND ----------

# CBM00S_Business_Logic
df_cbm00s_business_logic = df_cbms_pre98.alias("CBMS_PRE98")

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Instruction_Type",
    F.when(
        (F.expr("LOCATE('INDP', UPPER(cbms_pre98.CLASS_VAL_LIST))") > F.lit(0)),
        F.lit("5"),
    )
    .when(
        (F.expr("LOCATE('PRAC', UPPER(cbms_pre98.CLASS_VAL_LIST))") > F.lit(0)),
        F.lit("3"),
    )
    .when(
        (F.expr("LOCATE('PVTL', UPPER(cbms_pre98.CLASS_VAL_LIST))") > F.lit(0)),
        F.lit("6"),
    )
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("LEC")), F.lit("1"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("LAB")), F.lit("2"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("PRA")), F.lit("3"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("SEM")), F.lit("4"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("IND")), F.lit("5"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("PRI")), F.lit("6"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("THE")), F.lit("8"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("DTN")), F.lit("9"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("INV")), F.lit("0"))
    .when((F.col("CBMS_PRE98.SSR_COMPONENT") == F.lit("CLN")), F.lit("C"))
    .otherwise(F.lit("#")),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Student_Classification_Desc",
    F.when((F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("10")), F.lit("Freshman"))
    .when((F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("20")), F.lit("Sophomore"))
    .when((F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("30")), F.lit("Junior"))
    .when((F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("40")), F.lit("Senior"))
    .when(F.col("CBMS_PRE98.ACAD_LEVEL_BOT").isin(["50", "60"]), F.lit("Post-Bacc"))
    .when(
        F.col("CBMS_PRE98.ACAD_PROG_PRIMARY").isin(["CERT", "SPEC", "MASTR"]),
        F.lit("Masters"),
    )
    .when(
        (F.col("CBMS_PRE98.ACAD_PLAN") == F.lit("DNP_NP_AP")),
        F.lit("Prof- Practice Doct"),
    )
    .when(
        (
            (
                F.substring(
                    F.substring(F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6),
                    (
                        F.length(F.substring(F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6))
                        - F.lit(1)
                    ),
                    2,
                )
                == F.lit("DB")
            )
            & (F.col("CBMS_PRE98.GDR_Indicator") == F.lit("Yes"))
        ),
        F.lit("Doctoral"),
    )
    .when(
        (
            (
                F.substring(
                    F.substring(F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6),
                    (
                        F.length(F.substring(F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6))
                        - F.lit(1)
                    ),
                    2,
                )
                == F.lit("DB")
            )
            & (F.col("CBMS_PRE98.GDR_Indicator") == F.lit("No"))
        ),
        F.lit("Masters"),
    )
    .when((F.col("CBMS_PRE98.ACAD_PROG_PRIMARY") == F.lit("DOCT")), F.lit("Doctoral"))
    .otherwise(F.lit(" ")),
)

# COMMAND ----------

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Student_Classification",
    F.when((F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("10")), F.lit("1"))
    .when((F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("20")), F.lit("2"))
    .when((F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("30")), F.lit("3"))
    .when((F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("40")), F.lit("4"))
    .when(F.col("CBMS_PRE98.ACAD_LEVEL_BOT").isin(["50", "60"]), F.lit("5"))
    .when(
        F.col("CBMS_PRE98.ACAD_PROG_PRIMARY").isin(["CERT", "SPEC", "MASTR"]),
        F.lit("6"),
    )
    .when((F.col("CBMS_PRE98.ACAD_PLAN") == F.lit("DNP_NP_AP")), F.lit("8"))
    .when(
        (
            (
                F.substring(
                    F.substring(F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6),
                    (
                        F.length(F.substring(F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6))
                        - F.lit(1)
                    ),
                    2,
                )
                == F.lit("DB")
            )
            & (F.col("CBMS_PRE98.GDR_Indicator") == F.lit("Yes"))
        ),
        F.lit("7"),
    )
    .when(
        (
            (
                F.substring(
                    F.substring(F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6),
                    (
                        F.length(F.substring(F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6))
                        - F.lit(1)
                    ),
                    2,
                )
                == F.lit("DB")
            )
            & (F.col("CBMS_PRE98.GDR_Indicator") == F.lit("No"))
        ),
        F.lit("6"),
    )
    .when((F.col("CBMS_PRE98.ACAD_PROG_PRIMARY") == F.lit("DOCT")), F.lit("7"))
    .otherwise(F.lit(" ")),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Non_Disclosure",
    F.when((F.col("CBMS_PRE98.FERPA") == F.lit("Y")), F.lit("2")).otherwise(F.lit("0")),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "SCH_Value",
    F.when(
        (
            (F.col("CBMS_PRE98.CLASS_TYPE") == F.lit("N"))
            | (F.substring(F.col("CBMS_PRE98.CATALOG_NBR"), 2, 1) == F.lit("0"))
        ),
        F.lit("0000"),
    ).otherwise(
        F.concat(
            F.lit("0"),
            (
                F.substring(F.col("CBMS_PRE98.CATALOG_NBR"), 2, 1).cast("BIGINT")
                * F.lit(100)
            ).cast("STRING"),
        )
    ),
)

# COMMAND ----------

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "SCH_State_Funded",
    F.when(
        (
            (F.col("CBMS_PRE98.FLAG_3PEAT") == F.lit("Yes"))
            | (F.col("CBMS_PRE98.DVLP_FLAG") == F.lit("Yes"))
            | (F.col("CBMS_PRE98.EXC_FLAG") == F.lit("Yes"))
            | (F.col("CBMS_PRE98.Unfunded_Flag") == F.lit("Yes"))
            | (F.col("CBMS_PRE98.CLASS_TYPE") == F.lit("N"))
            | (F.substring(F.col("CBMS_PRE98.CATALOG_NBR"), 2, 1) == F.lit("0"))
            | (F.col("CBMS_PRE98.CB_Reported_Student") == F.lit("No"))
            | (F.col("CBMS_PRE98.CB_Reported_Course") == F.lit("No"))
        ),
        F.lit("0000"),
    ).otherwise(
        F.concat(
            F.lit("0"),
            (
                F.substring(F.col("CBMS_PRE98.CATALOG_NBR"), 2, 1).cast("BIGINT")
                * F.lit(100)
            ).cast("STRING"),
        )
    ),
)
df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "SCH_Not_State_Funded",
    F.when(
        (
            (
                (F.col("CBMS_PRE98.EXC_FLAG") == F.lit("Yes"))
                | (F.col("CBMS_PRE98.FLAG_3PEAT") == F.lit("Yes"))
                | (F.col("CBMS_PRE98.DVLP_FLAG") == F.lit("Yes"))
                | (F.col("CBMS_PRE98.Unfunded_Flag") == F.lit("Yes"))
                | (F.col("CBMS_PRE98.CB_Reported_Student") == F.lit("No"))
                | (F.col("CBMS_PRE98.CB_Reported_Course") == F.lit("No"))
            )
            & (F.col("CBMS_PRE98.CLASS_TYPE") != F.lit("N"))
            & (F.substring(F.col("CBMS_PRE98.CATALOG_NBR"), 2, 1) != F.lit("0"))
        ),
        F.concat(
            F.lit("0"),
            (
                F.substring(F.col("CBMS_PRE98.CATALOG_NBR"), 2, 1).cast("BIGINT")
                * F.lit(100)
            ).cast("STRING"),
        ),
    ).otherwise(F.lit("0000")),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Grad_12H",
    F.when(
        (
            (F.col("CBMS_PRE98.ACAD_LEVEL_BOT") == F.lit("40"))
            & (
                (
                    F.col("CBMS_PRE98.MIN_UNITS_REQD")
                    - F.col("CBMS_PRE98.TOT_CUMULATIVE")
                )
                <= F.lit(12)
            )
            & ~F.col("CBMS_PRE98.DEGR_CHKOUT_STAT").isin(["", " ", "DN", "WD"])
            & (F.col("CBMS_PRE98.UNT_TAKEN_SEM") > F.lit(0))
            & (
                F.substring(F.col("CBMS_PRE98.CATALOG_NBR"), 1, 1).cast("BIGINT")
                >= F.lit(5)
            )
        ),
        F.lit("1"),
    ).otherwise(F.lit("0")),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Other_Higher_Ed_Site",
    F.when(
        (F.trim(F.col("CBMS_PRE98.EXT_LOC_FICE")) == F.lit("")), F.lit(None)
    ).otherwise(
        F.trim(
            F.lpad(
                F.col("CBMS_PRE98.EXT_LOC_FICE").cast("BIGINT").cast("STRING"), 6, "0"
            )
        )
    ),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Instruction_Mode_New",
    F.when((F.col("CBMS_PRE98.INSTRUCTION_MODE") == F.lit("02")), F.lit("7")).otherwise(
        F.substring(F.col("CBMS_PRE98.INSTRUCTION_MODE"), 2, 1)
    ),
)

# COMMAND ----------

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "SCH_Not_Funded_Reason",
    F.when(
        (
            (
                (F.col("CBMS_PRE98.FLAG_3PEAT") == F.lit("Yes"))
                | (F.col("CBMS_PRE98.DVLP_FLAG") == F.lit("Yes"))
                | (F.col("CBMS_PRE98.EXC_FLAG") == F.lit("Yes"))
                | (F.col("CBMS_PRE98.Unfunded_Flag") == F.lit("Yes"))
            )
            & (F.col("CBMS_PRE98.CLASS_TYPE") != F.lit("N"))
            & (F.substring(F.col("CBMS_PRE98.CATALOG_NBR"), 2, 1) != F.lit("0"))
        ),
        F.when((F.col("CBMS_PRE98.DVLP_FLAG") == F.lit("Yes")), F.lit("1")).otherwise(
            F.when(
                (F.col("CBMS_PRE98.FLAG_3PEAT") == F.lit("Yes")), F.lit("2")
            ).otherwise(
                F.when(
                    (
                        (F.col("CBMS_PRE98.EXC_FLAG") == F.lit("Yes"))
                        & F.col("CBMS_PRE98.ACAD_LEVEL_BOT").isin(
                            ["10", "20", "30", "40", "50", "60"]
                        )
                        & F.col("CBMS_PRE98.ACAD_PROG").isin(["UGRD", "UGRD2", "UGNDS"])
                    ),
                    F.lit("3"),
                ).otherwise(
                    F.when(
                        (
                            (F.col("CBMS_PRE98.Unfunded_Flag") == F.lit("Yes"))
                            | (F.col("CBMS_PRE98.PHYED_CNT_FLG") == F.lit("Yes"))
                        ),
                        F.lit("4"),
                    ).otherwise(
                        F.when(
                            (
                                (
                                    (F.col("CBMS_PRE98.EXC_FLAG") == F.lit("Yes"))
                                    & (
                                        F.substring(
                                            F.substring(
                                                F.col("CBMS_PRE98.ACAD_PLAN"), 1, 6
                                            ),
                                            (
                                                F.length(
                                                    F.substring(
                                                        F.col("CBMS_PRE98.ACAD_PLAN"),
                                                        1,
                                                        6,
                                                    )
                                                )
                                                - F.lit(1)
                                            ),
                                            -1,
                                        )
                                        == F.lit("DB")
                                    )
                                    & (
                                        F.col("CBMS_PRE98.GDR_Indicator")
                                        == F.lit("Yes")
                                    )
                                )
                                | (
                                    F.col("CBMS_PRE98.ACAD_PROG_PRIMARY")
                                    == F.lit("DOCT")
                                )
                            ),
                            F.lit("8"),
                        ).otherwise(F.lit("0 "))
                    )
                )
            )
        ),
    ).otherwise(F.lit("0")),
)

# COMMAND ----------

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "HighSchool_Credit",
    F.when(
        (
            (
                (F.col("CBMS_PRE98.ACAD_CAREER") == F.lit("UGRD"))
                & F.col("CBMS_PRE98.ADMIT_TYPE").isin(["1", "5"])
            )
            & (F.col("CBMS_PRE98.ACAD_PROG") == F.lit("UGNDS"))
            & (F.col("CBMS_PRE98.RECRUITMENT_CAT") == F.lit("AUEA"))
        ),
        F.lit("1"),
    ).otherwise(F.lit("0")),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Developmental_Education",
    F.when((F.col("CBMS_PRE98.NCBO") == F.lit("Y")), F.lit("9")).otherwise(
        F.when(
            (
                (F.expr("LOCATE('DVLP', UPPER(cbms_pre98.CLASS_ATTR_LIST))") > F.lit(0))
                & (F.substring(F.col("CBMS_PRE98.CLASS_SECTION"), 1, 1) != F.lit("C"))
            ),
            F.lit("1"),
        ).otherwise(
            F.when(
                (
                    (
                        F.expr("LOCATE('DVLP', UPPER(cbms_pre98.CLASS_ATTR_LIST))")
                        > F.lit(0)
                    )
                    & (
                        F.substring(F.col("CBMS_PRE98.CLASS_SECTION"), 1, 1)
                        == F.lit("C")
                    )
                ),
                F.lit("8"),
            ).otherwise(
                F.when(
                    (
                        (
                            F.expr("LOCATE('DVLP', UPPER(cbms_pre98.CLASS_ATTR_LIST))")
                            == F.lit(0)
                        )
                        & (
                            F.substring(F.col("CBMS_PRE98.CLASS_SECTION"), 1, 1)
                            == F.lit("C")
                        )
                    ),
                    F.lit("B"),
                ).otherwise(F.lit("0"))
            )
        )
    ),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "First_College_Level_Course",
    F.when(
        (
            F.col("CBMS_PRE98.Prior_Enrolled_Term").isNull()
            | (F.trim(F.col("CBMS_PRE98.Prior_Enrolled_Term")) == F.lit(""))
        ),
        F.when(
            (
                (F.col("CBMS_PRE98.ACAD_CAREER") == F.lit("UGRD"))
                & F.col("CBMS_PRE98.CRSE_GRADE_OFF").isin(["A", "B", "C", "P"])
                & (F.col("CBMS_PRE98.CORE_COURSE") == F.lit("Yes"))
            ),
            F.when((F.col("CBMS_PRE98.MathCore") == F.lit(1)), F.lit("1")).otherwise(
                F.when(
                    (F.col("CBMS_PRE98.ReadCore") == F.lit(1)), F.lit("2")
                ).otherwise(
                    F.when(
                        (F.col("CBMS_PRE98.WriteCore") == F.lit(1)), F.lit("3")
                    ).otherwise(F.lit("0"))
                )
            ),
        ).otherwise(F.lit("0")),
    ).otherwise(F.lit("0")),
)

# COMMAND ----------

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Course_Grade",
    F.when((F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("A")), F.lit("1")).otherwise(
        F.when(
            (F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("B")), F.lit("2")
        ).otherwise(
            F.when(
                (F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("C")), F.lit("3")
            ).otherwise(
                F.when(
                    (F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("D")), F.lit("4")
                ).otherwise(
                    F.when(
                        (F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("F")), F.lit("5")
                    ).otherwise(
                        F.when(
                            F.col("CBMS_PRE98.CRSE_GRADE_OFF").isin(["I", "Z"]),
                            F.lit("6"),
                        ).otherwise(
                            F.when(
                                F.col("CBMS_PRE98.CRSE_GRADE_OFF").isin(["W", "Q"]),
                                F.lit("7"),
                            ).otherwise(
                                F.when(
                                    F.col("CBMS_PRE98.CRSE_GRADE_OFF").isin(["P", "R"]),
                                    F.lit("8"),
                                ).otherwise(
                                    F.when(
                                        (
                                            (
                                                F.col("CBMS_PRE98.SSR_COMPONENT")
                                                == F.lit("LAB")
                                            )
                                            & (
                                                F.col(
                                                    "CBMS_PRE98.CRSE_GRADE_OFF"
                                                ).isNull()
                                                | (
                                                    F.trim(
                                                        F.col(
                                                            "CBMS_PRE98.CRSE_GRADE_OFF"
                                                        )
                                                    )
                                                    == F.lit("")
                                                )
                                            )
                                        ),
                                        F.lit("8"),
                                    ).otherwise(F.lit("X"))
                                )
                            )
                        )
                    )
                )
            )
        )
    ),
)

# COMMAND ----------

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Grade_Value",
    F.when((F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("A")), F.lit("400")).otherwise(
        F.when(
            (F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("B")), F.lit("300")
        ).otherwise(
            F.when(
                (F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("C")), F.lit("200")
            ).otherwise(
                F.when(
                    (F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("D")), F.lit("100")
                ).otherwise(
                    F.when(
                        (F.col("CBMS_PRE98.CRSE_GRADE_OFF") == F.lit("F")), F.lit("000")
                    ).otherwise(
                        F.when(
                            F.col("CBMS_PRE98.CRSE_GRADE_OFF").isin(
                                ["I", "Z", "W", "Q", "P", "R"]
                            ),
                            F.lit(None),
                        ).otherwise(F.lit(None))
                    )
                )
            )
        )
    ),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Off_Campus_Location",
    F.when(
        (F.col("CBMS_PRE98.OFFSITE_LOC_CD") != F.lit("")),
        F.trim(
            F.lpad(
                F.col("CBMS_PRE98.OFFSITE_LOC_CD").cast("BIGINT").cast("STRING"), 5, "0"
            )
        ),
    ).otherwise(F.lit(None)),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Flex_entry",
    F.when(
        (
            (F.col("CBMS_PRE98.Current_Term") == F.col("CBMS_PRE98.STRM"))
            & (F.col("CBMS_PRE98.SESSION_CODE") != F.lit("1"))
            & (F.col("CBMS_PRE98.END_DT") <= F.col("CBMS_PRE98.Current_Term_End_date"))
            & (F.col("CBMS_PRE98.START_DT") > F.col("CBMS_PRE98.CENSUS_DT"))
        ),
        F.lit("1"),
    )
    .when(
        (
            (
                (
                    F.col("CBMS_PRE98.Current_Term").cast("BIGINT")
                    - F.col("CBMS_PRE98.STRM").cast("BIGINT")
                )
                > F.lit(0)
            )
            & (F.col("CBMS_PRE98.START_DT") <= F.col("CBMS_PRE98.CENSUS_DT"))
            & (F.col("CBMS_PRE98.END_DT") > F.col("CBMS_PRE98.TERM_END_DT"))
            & (F.col("CBMS_PRE98.END_DT") <= F.col("CBMS_PRE98.Current_Term_End_date"))
        ),
        F.lit("6"),
    )
    .when(
        (
            (
                (
                    F.col("CBMS_PRE98.Current_Term").cast("BIGINT")
                    - F.col("CBMS_PRE98.STRM").cast("BIGINT")
                )
                > F.lit(0)
            )
            & (F.col("CBMS_PRE98.START_DT") > F.col("CBMS_PRE98.CENSUS_DT"))
            & (F.col("CBMS_PRE98.END_DT") > F.col("CBMS_PRE98.TERM_END_DT"))
            & (F.col("CBMS_PRE98.END_DT") <= F.col("CBMS_PRE98.Current_Term_End_date"))
        ),
        F.lit("6"),
    )
    .otherwise(F.lit(None)),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Inter_Institution_Identifier",
    F.when(
        (
            (F.col("CBMS_PRE98.CAMPUS") != F.lit("MAIN"))
            & (F.col("CBMS_PRE98.UTA_CB_LOCATION_CD").isin(["0", "6", "9"]))
        ),
        F.lit("0"),
    )
    .when(
        (
            (F.col("CBMS_PRE98.CAMPUS") != F.lit("MAIN"))
            & (F.col("CBMS_PRE98.UTA_CB_LOCATION_CD") == F.lit("1"))
        ),
        F.lit("1"),
    )
    .otherwise(F.lit("0")),
)

# COMMAND ----------

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Semester",
    F.when(
        (F.substring(F.col("CBMS_PRE98.Current_Term"), 4, 1) == F.lit("8")), F.lit("1")
    )
    .when(
        (F.substring(F.col("CBMS_PRE98.Current_Term"), 4, 1) == F.lit("2")), F.lit("2")
    )
    .when(
        (F.substring(F.col("CBMS_PRE98.Current_Term"), 4, 1) == F.lit("5")), F.lit("3")
    )
    .otherwise(F.lit(" ")),
)

df_cbm00s_business_logic = df_cbm00s_business_logic.withColumn(
    "Year",
    F.when(
        (
            (F.col("CBMS_PRE98.SESSION_CODE") == F.lit("DYN"))
            & (F.col("CBMS_PRE98.END_DT") > F.col("CBMS_PRE98.TERM_END_DT"))
            & (F.col("CBMS_PRE98.END_DT") <= F.col("CBMS_PRE98.Current_Term_End_date"))
            & (F.substring(F.col("CBMS_PRE98.STRM"), 4, 1) == F.lit("8"))
        ),
        (
            F.concat(F.lit("20"), F.substring(F.col("CBMS_PRE98.STRM"), 2, 2)).cast(
                "BIGINT"
            )
            + F.lit(1)
        ).cast("STRING"),
    ).otherwise(F.concat(F.lit("20"), F.substring(F.col("CBMS_PRE98.STRM"), 2, 2))),
)

# COMMAND ----------

df_cbm00s_business_logic = df_cbm00s_business_logic.select(
    F.lit("S").alias("Record_Code"),
    F.lit("003656").alias("College_Code"),
    F.col("CBMS_PRE98.STRM"),
    F.trim(F.col("CBMS_PRE98.EMPLID")).alias("EMPLID"),
    F.col("CBMS_PRE98.National_Id"),
    F.trim(F.col("CBMS_PRE98.SUBJECT")).alias("SUBJECT"),
    F.trim(
        F.lpad(F.col("CBMS_PRE98.CATALOG_NBR").cast("BIGINT").cast("STRING"), 4, "0")
    ).alias("CATALOG_NBR"),
    F.trim(F.lpad(F.col("CBMS_PRE98.CLASS_NBR").cast("STRING"), 5, "0")).alias(
        "CLASS_NBR"
    ),
    F.col("Instruction_Type"),
    F.col("Student_Classification_Desc"),
    F.col("Student_Classification"),
    F.col("Non_Disclosure"),
    F.col("SCH_Value"),
    F.col("SCH_State_Funded"),
    F.col("SCH_Not_State_Funded"),
    F.col("Grad_12H"),
    F.coalesce(F.col("CBMS_PRE98.UTA_CB_LOCATION_CD"), F.lit(0)).alias("Location_Code"),
    F.col("Other_Higher_Ed_Site"),
    F.col("Instruction_Mode_new").alias("Instruction_Mode"),
    F.col("SCH_Not_Funded_Reason"),
    F.col("HighSchool_Credit"),
    F.col("Developmental_Education"),
    F.col("First_College_Level_Course"),
    F.col("Course_Grade"),
    F.col("Grade_Value"),
    F.trim(F.col("CBMS_PRE98.COMBINED_SECTION_CODE")).alias("Composite_Class_Code"),
    F.col("Off_Campus_Location"),
    F.col("Flex_entry"),
    F.col("Inter_Institution_Identifier"),
    F.col("Semester"),
    F.col("Year"),
    F.date_format(
        F.date_format(F.col("CBMS_PRE98.START_DT"), "yyyy-MM-dd"), "yyyyMMdd"
    ).alias("START_DT"),
    F.date_format(
        F.date_format(F.col("CBMS_PRE98.END_DT"), "yyyy-MM-dd"), "yyyyMMdd"
    ).alias("END_DT"),
    F.col("CBMS_PRE98.CRSE_ID"),
    F.col("CBMS_PRE98.CRSE_OFFER_NBR"),
    F.col("CBMS_PRE98.CLASS_TYPE"),
    F.col("CBMS_PRE98.ACAD_CAREER"),
    F.col("CBMS_PRE98.ACAD_PROG"),
    F.col("CBMS_PRE98.ACAD_GROUP"),
    F.col("CBMS_PRE98.ACAD_ORG"),
    F.col("CBMS_PRE98.CAMPUS"),
    F.col("CBMS_PRE98.STDNT_CAR_NBR"),
    F.col("CBMS_PRE98.ACAD_PLAN"),
    F.col("CBMS_PRE98.ACAD_LEVEL_BOT"),
    F.col("CBMS_PRE98.ACAD_LEVEL_EOT"),
    F.col("CBMS_PRE98.DEGR_CHKOUT_STAT"),
    F.col("CBMS_PRE98.MIN_UNITS_REQD"),
    F.col("CBMS_PRE98.LOCATION"),
    F.col("CBMS_PRE98.TERM_BEGIN_DT"),
    F.col("CBMS_PRE98.TERM_END_DT"),
    F.col("CBMS_PRE98.CENSUS_DT"),
    F.col("CBMS_PRE98.CB_Exclude"),
    F.col("CBMS_PRE98.ENRL_TOT"),
    F.col("CBMS_PRE98.COMPONENT_PRIMARY"),
    F.col("CBMS_PRE98.SESSION_CODE"),
    F.col("CBMS_PRE98.Current_Term_End_date"),
    F.col("CBMS_PRE98.CRSE_GRADE_OFF"),
    F.col("CBMS_PRE98.UNT_PRGRSS"),
    F.col("CBMS_PRE98.UNT_EARNED"),
    F.col("CBMS_PRE98.UNT_TAKEN_SEM"),
    F.col("CBMS_PRE98.UNT_TAKEN"),
    F.col("CBMS_PRE98.REQ_TERM"),
    F.col("CBMS_PRE98.TOT_CUMULATIVE"),
    F.col("CBMS_PRE98.UTA_UNFN_TYPE"),
    F.col("CBMS_PRE98.UTA_UNFN_UNITS"),
    F.coalesce(F.col("CBMS_PRE98.Prior_Enrolled_Term"), F.lit(" ")).alias(
        "Prior_Enrolled_Term"
    ),
    F.col("CBMS_PRE98.FERPA"),
    F.col("CBMS_PRE98.ADMIT_TERM"),
    F.col("CBMS_PRE98.ADM_APPL_NBR"),
    F.col("CBMS_PRE98.ADM_ADMIT_TERM"),
    F.col("CBMS_PRE98.ADMIT_TYPE"),
    F.col("CBMS_PRE98.RECRUITMENT_CAT"),
    F.col("CBMS_PRE98.ARTICULATION_TERM"),
    F.col("CBMS_PRE98.CRSE_ATTR_LIST"),
    F.col("CBMS_PRE98.CRSE_VAL_LIST"),
    F.col("CBMS_PRE98.CLASS_ATTR_LIST"),
    F.col("CBMS_PRE98.CLASS_VAL_LIST"),
    F.col("CBMS_PRE98.CORE_COURSE"),
    F.col("CBMS_PRE98.GDR_Indicator"),
    F.col("CBMS_PRE98.EXC_FLAG"),
    F.col("CBMS_PRE98.DVLP_FLAG"),
    F.col("CBMS_PRE98.FLAG_3PEAT"),
    F.col("CBMS_PRE98.PHYED_CNT_FLG"),
    F.col("CBMS_PRE98.Unfunded_Flag"),
    F.col("CBMS_PRE98.AP_Student"),
    F.col("CBMS_PRE98.AP_Course"),
    F.col("CBMS_PRE98.DLRN_Student"),
    F.col("CBMS_PRE98.DLRN_Course"),
    F.col("CBMS_PRE98.CB_Reported_Student"),
    F.col("CBMS_PRE98.CB_Reported_Course"),
    F.col("CBMS_PRE98.Current_Semester_Reportable"),
    F.col("CBMS_PRE98.Prior_Crse_Transfer"),
    F.substring(F.trim(F.col("CBMS_PRE98.Current_Term")), 1, 4)
    .cast("string")
    .alias("Current_Term"),
    F.col("CBMS_PRE98.PRE1998"),
).orderBy(
    F.col("CATALOG_NBR").asc(),
    F.col("SUBJECT").asc(),
    F.col("CLASS_NBR").asc(),
    F.col("STRM").asc(),
)

# COMMAND ----------

# CBM00S_Final
df_cbm00s_final = df_cbm00s_business_logic.alias("CBM00S_Business_Logic")

df_cbm00s_final = df_cbm00s_final.select(
    F.substring(F.col("CBM00S_Business_Logic.Record_Code"), 1, 1).alias("Record_Code"),
    F.substring(F.col("CBM00S_Business_Logic.College_Code"), 1, 6).alias(
        "College_Code"
    ),
    F.substring(F.col("CBM00S_Business_Logic.STRM"), 1, 4).alias("STRM"),
    F.substring(F.col("CBM00S_Business_Logic.EMPLID"), 1, 10).alias("EMPLID"),
    F.substring(F.col("CBM00S_Business_Logic.National_Id"), 1, 9).alias("National_Id"),
    F.substring(F.col("CBM00S_Business_Logic.SUBJECT"), 1, 7).alias("SUBJECT"),
    F.substring(F.col("CBM00S_Business_Logic.CATALOG_NBR"), 1, 7).alias("CATALOG_NBR"),
    F.substring(F.col("CBM00S_Business_Logic.CLASS_NBR"), 1, 7).alias("CLASS_NBR"),
    F.substring(F.col("CBM00S_Business_Logic.Instruction_Type"), 1, 1).alias(
        "Instruction_Type"
    ),
    F.substring(
        F.col("CBM00S_Business_Logic.Student_Classification_Desc"), 1, 20
    ).alias("Student_Classification_Desc"),
    F.substring(F.col("CBM00S_Business_Logic.Student_Classification"), 1, 1).alias(
        "Student_Classification"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Non_Disclosure"), 1, 1).alias(
        "Non_Disclosure"
    ),
    F.substring(F.col("CBM00S_Business_Logic.SCH_Value"), 1, 4).alias("SCH_Value"),
    F.substring(F.col("CBM00S_Business_Logic.SCH_State_Funded"), 1, 4).alias(
        "SCH_State_Funded"
    ),
    F.substring(F.col("CBM00S_Business_Logic.SCH_Not_State_Funded"), 1, 4).alias(
        "SCH_Not_State_Funded"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Grad_12H"), 1, 1).alias("Grad_12H"),
    F.substring(F.col("CBM00S_Business_Logic.Location_Code"), 1, 1).alias(
        "Location_Code"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Other_Higher_Ed_Site"), 1, 6).alias(
        "Other_Higher_Ed_Site"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Instruction_Mode"), 1, 1).alias(
        "Instruction_Mode"
    ),
    F.substring(F.col("CBM00S_Business_Logic.SCH_Not_Funded_Reason"), 1, 1).alias(
        "SCH_Not_Funded_Reason"
    ),
    F.substring(F.col("CBM00S_Business_Logic.HighSchool_Credit"), 1, 1).alias(
        "HighSchool_Credit"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Developmental_Education"), 1, 1).alias(
        "Developmental_Education"
    ),
    F.substring(F.col("CBM00S_Business_Logic.First_College_Level_Course"), 1, 1).alias(
        "First_College_Level_Course"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Course_Grade"), 1, 1).alias(
        "Course_Grade"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Grade_Value"), 1, 3).alias("Grade_Value"),
    F.substring(F.col("CBM00S_Business_Logic.Composite_Class_Code"), 1, 2).alias(
        "Composite_Class_Code"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Off_Campus_Location"), 1, 5).alias(
        "Off_Campus_Location"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Flex_entry"), 1, 1).alias("Flex_entry"),
    F.substring(
        F.col("CBM00S_Business_Logic.Inter_Institution_Identifier"), 1, 1
    ).alias("Inter_Institution_Identifier"),
    F.substring(F.col("CBM00S_Business_Logic.Semester"), 1, 1).alias("Semester"),
    F.substring(F.col("CBM00S_Business_Logic.Year"), 1, 4).alias("Year"),
    F.substring(F.col("CBM00S_Business_Logic.START_DT"), 1, 8).alias("START_DT"),
    F.substring(F.col("CBM00S_Business_Logic.END_DT"), 1, 8).alias("END_DT"),
    F.substring(F.col("CBM00S_Business_Logic.CRSE_ID"), 1, 6).alias("CRSE_ID"),
    F.col("CBM00S_Business_Logic.CRSE_OFFER_NBR")
    .cast("bigint")
    .alias("CRSE_OFFER_NBR"),
    F.substring(F.col("CBM00S_Business_Logic.CLASS_TYPE"), 1, 1).alias("CLASS_TYPE"),
    F.substring(F.col("CBM00S_Business_Logic.ACAD_CAREER"), 1, 4).alias("ACAD_CAREER"),
    F.substring(F.col("CBM00S_Business_Logic.ACAD_PROG"), 1, 5).alias("ACAD_PROG"),
    F.substring(F.col("CBM00S_Business_Logic.ACAD_GROUP"), 1, 5).alias("ACAD_GROUP"),
    F.substring(F.col("CBM00S_Business_Logic.ACAD_ORG"), 1, 10).alias("ACAD_ORG"),
    F.substring(F.col("CBM00S_Business_Logic.CAMPUS"), 1, 5).alias("CAMPUS"),
    F.col("CBM00S_Business_Logic.STDNT_CAR_NBR").cast("bigint").alias("STDNT_CAR_NBR"),
    F.substring(F.col("CBM00S_Business_Logic.ACAD_PLAN"), 1, 10).alias("ACAD_PLAN"),
    F.substring(F.col("CBM00S_Business_Logic.ACAD_LEVEL_BOT"), 1, 3).alias(
        "ACAD_LEVEL_BOT"
    ),
    F.substring(F.col("CBM00S_Business_Logic.ACAD_LEVEL_EOT"), 1, 3).alias(
        "ACAD_LEVEL_EOT"
    ),
    F.substring(F.col("CBM00S_Business_Logic.DEGR_CHKOUT_STAT"), 1, 2).alias(
        "DEGR_CHKOUT_STAT"
    ),
    F.col("CBM00S_Business_Logic.MIN_UNITS_REQD")
    .cast("decimal(7,2)")
    .alias("MIN_UNITS_REQD"),
    F.substring(F.col("CBM00S_Business_Logic.LOCATION"), 1, 10).alias("LOCATION"),
    F.to_date(F.col("CBM00S_Business_Logic.TERM_BEGIN_DT"), "yyyyMMdd").alias(
        "TERM_BEGIN_DT"
    ),
    F.to_date(F.col("CBM00S_Business_Logic.TERM_END_DT"), "yyyyMMdd").alias(
        "TERM_END_DT"
    ),
    F.to_date(F.col("CBM00S_Business_Logic.CENSUS_DT"), "yyyyMMdd").alias("CENSUS_DT"),
    F.substring(F.col("CBM00S_Business_Logic.CB_Exclude"), 1, 8).alias("CB_Exclude"),
    F.col("CBM00S_Business_Logic.ENRL_TOT").cast("bigint").alias("ENRL_TOT"),
    F.substring(F.col("CBM00S_Business_Logic.COMPONENT_PRIMARY"), 1, 3).alias(
        "COMPONENT_PRIMARY"
    ),
    F.substring(F.col("CBM00S_Business_Logic.SESSION_CODE"), 1, 3).alias(
        "SESSION_CODE"
    ),
    F.to_date(F.col("CBM00S_Business_Logic.Current_Term_End_date"), "yyyyMMdd").alias(
        "Current_Term_End_date"
    ),
    F.substring(F.col("CBM00S_Business_Logic.CRSE_GRADE_OFF"), 1, 3).alias(
        "CRSE_GRADE_OFF"
    ),
    F.col("CBM00S_Business_Logic.UNT_PRGRSS").cast("decimal(7,2)").alias("UNT_PRGRSS"),
    F.col("CBM00S_Business_Logic.UNT_EARNED").cast("decimal(7,2)").alias("UNT_EARNED"),
    F.col("CBM00S_Business_Logic.UNT_TAKEN_SEM")
    .cast("decimal(7,2)")
    .alias("UNT_TAKEN_SEM"),
    F.col("CBM00S_Business_Logic.UNT_TAKEN").cast("decimal(7,2)").alias("UNT_TAKEN"),
    F.substring(F.col("CBM00S_Business_Logic.REQ_TERM"), 1, 4).alias("REQ_TERM"),
    F.col("CBM00S_Business_Logic.TOT_CUMULATIVE")
    .cast("decimal(10,3)")
    .alias("TOT_CUMULATIVE"),
    F.substring(F.col("CBM00S_Business_Logic.UTA_UNFN_TYPE"), 1, 1).alias(
        "UTA_UNFN_TYPE"
    ),
    F.col("CBM00S_Business_Logic.UTA_UNFN_UNITS")
    .cast("bigint")
    .alias("UTA_UNFN_UNITS"),
    F.substring(F.col("CBM00S_Business_Logic.Prior_Enrolled_Term"), 1, 4).alias(
        "Prior_Enrolled_Term"
    ),
    F.substring(F.col("CBM00S_Business_Logic.FERPA"), 1, 1).alias("FERPA"),
    F.substring(F.col("CBM00S_Business_Logic.ADMIT_TERM"), 1, 4).alias("ADMIT_TERM"),
    F.substring(F.col("CBM00S_Business_Logic.ADM_APPL_NBR"), 1, 8).alias(
        "ADM_APPL_NBR"
    ),
    F.substring(F.col("CBM00S_Business_Logic.ADM_ADMIT_TERM"), 1, 4).alias(
        "ADM_ADMIT_TERM"
    ),
    F.substring(F.col("CBM00S_Business_Logic.ADMIT_TYPE"), 1, 3).alias("ADMIT_TYPE"),
    F.substring(F.col("CBM00S_Business_Logic.RECRUITMENT_CAT"), 1, 4).alias(
        "RECRUITMENT_CAT"
    ),
    F.substring(F.col("CBM00S_Business_Logic.ARTICULATION_TERM"), 1, 4).alias(
        "ARTICULATION_TERM"
    ),
    F.substring(F.col("CBM00S_Business_Logic.CRSE_ATTR_LIST"), 1, 50).alias(
        "CRSE_ATTR_LIST"
    ),
    F.substring(F.col("CBM00S_Business_Logic.CRSE_VAL_LIST"), 1, 50).alias(
        "CRSE_VAL_LIST"
    ),
    F.substring(F.col("CBM00S_Business_Logic.CLASS_ATTR_LIST"), 1, 50).alias(
        "CLASS_ATTR_LIST"
    ),
    F.substring(F.col("CBM00S_Business_Logic.CLASS_VAL_LIST"), 1, 100).alias(
        "CLASS_VAL_LIST"
    ),
    F.substring(F.col("CBM00S_Business_Logic.CORE_COURSE"), 1, 8).alias("CORE_COURSE"),
    F.substring(F.col("CBM00S_Business_Logic.GDR_Indicator"), 1, 8).alias(
        "GDR_Indicator"
    ),
    F.substring(F.col("CBM00S_Business_Logic.EXC_FLAG"), 1, 8).alias("EXC_FLAG"),
    F.substring(F.col("CBM00S_Business_Logic.DVLP_FLAG"), 1, 8).alias("DVLP_FLAG"),
    F.substring(F.col("CBM00S_Business_Logic.FLAG_3PEAT"), 1, 8).alias("FLAG_3PEAT"),
    F.substring(F.col("CBM00S_Business_Logic.PHYED_CNT_FLG"), 1, 8).alias(
        "PHYED_CNT_FLG"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Unfunded_Flag"), 1, 8).alias(
        "Unfunded_Flag"
    ),
    F.substring(F.col("CBM00S_Business_Logic.AP_Student"), 1, 8).alias("AP_Student"),
    F.substring(F.col("CBM00S_Business_Logic.AP_Course"), 1, 1).alias("AP_Course"),
    F.substring(F.col("CBM00S_Business_Logic.DLRN_Student"), 1, 8).alias(
        "DLRN_Student"
    ),
    F.substring(F.col("CBM00S_Business_Logic.DLRN_Course"), 1, 1).alias("DLRN_Course"),
    F.substring(F.col("CBM00S_Business_Logic.CB_Reported_Student"), 1, 1).alias(
        "CB_Reported_Student"
    ),
    F.substring(F.col("CBM00S_Business_Logic.CB_Reported_Course"), 1, 1).alias(
        "CB_Reported_Course"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Current_Semester_Reportable"), 1, 8).alias(
        "Current_Semester_Reportable"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Prior_Crse_Transfer"), 1, 8).alias(
        "Prior_Crse_Transfer"
    ),
    F.substring(F.col("CBM00S_Business_Logic.Current_Term"), 1, 4).alias(
        "Current_Term"
    ),
    F.substring(F.col("CBM00S_Business_Logic.PRE1998"), 1, 8).alias("PRE1998"),
)

# COMMAND ----------

# Step 40: Write fact_thecb_cbm00s_work
# Output: fact_thecb_cbm00s_work → analytics.staging  (from Release3 output_table_map)

write_df_to_table(
    df_cbm00s_final,
    f"{analytics}.{staging}.fact_thecb_cbm00s_work",
    mode="overwrite",
)

log_msg(f"fact_thecb_cbm00s_work written — row count: {get_count(df_cbm00s_final)}")

# COMMAND ----------

# CBM00S_CBReported
adw_cbm00s_work = read_table(f"{analytics}.{staging}.fact_thecb_cbm00s_work").alias(
    "ADW_CBM00S_WORK"
)

df_cbm00s_cbreported_final = adw_cbm00s_work.filter(
    (F.coalesce(F.col("ADW_CBM00S_WORK.CB_Reported_Student"), F.lit("")) == F.lit("Y"))
    & (F.coalesce(F.col("ADW_CBM00S_WORK.CB_Reported_Course"), F.lit("")) == F.lit("Y"))
)

df_cbm00s_cbreported_final = df_cbm00s_cbreported_final.select(
    F.col("ADW_CBM00S_WORK.Record_Code"),
    F.col("ADW_CBM00S_WORK.College_Code"),
    F.col("ADW_CBM00S_WORK.National_Id"),
    F.col("ADW_CBM00S_WORK.SUBJECT"),
    F.col("ADW_CBM00S_WORK.CATALOG_NBR"),
    F.col("ADW_CBM00S_WORK.CLASS_NBR"),
    F.col("ADW_CBM00S_WORK.Instruction_Type"),
    F.col("ADW_CBM00S_WORK.Student_Classification"),
    F.col("ADW_CBM00S_WORK.Non_Disclosure"),
    F.col("ADW_CBM00S_WORK.SCH_Value"),
    F.col("ADW_CBM00S_WORK.SCH_State_Funded"),
    F.col("ADW_CBM00S_WORK.SCH_Not_State_Funded"),
    F.col("ADW_CBM00S_WORK.Grad_12H"),
    F.col("ADW_CBM00S_WORK.Location_Code"),
    F.col("ADW_CBM00S_WORK.Other_Higher_Ed_Site"),
    F.col("ADW_CBM00S_WORK.Instruction_Mode"),
    F.col("ADW_CBM00S_WORK.SCH_Not_Funded_Reason"),
    F.col("ADW_CBM00S_WORK.HighSchool_Credit"),
    F.col("ADW_CBM00S_WORK.Developmental_Education"),
    F.col("ADW_CBM00S_WORK.First_College_Level_Course"),
    F.col("ADW_CBM00S_WORK.Course_Grade"),
    F.col("ADW_CBM00S_WORK.Grade_Value"),
    F.col("ADW_CBM00S_WORK.Composite_Class_Code"),
    F.col("ADW_CBM00S_WORK.Off_Campus_Location"),
    F.col("ADW_CBM00S_WORK.Flex_entry"),
    F.col("ADW_CBM00S_WORK.Inter_Institution_Identifier"),
    F.col("ADW_CBM00S_WORK.Semester"),
    F.col("ADW_CBM00S_WORK.Year"),
    F.col("ADW_CBM00S_WORK.START_DT"),
    F.col("ADW_CBM00S_WORK.END_DT"),
)

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

df_fixed_width = df_cbm00s_cbreported_final.withColumn(
    "fixed_width_line",
    F.concat(
        fmt_char("Record_Code", 1),  # @1
        fmt_char("College_Code", 6),  # @2
        fmt_char("National_Id", 9),  # @8
        fmt_char("SUBJECT", 7),  # @17
        fmt_char("CATALOG_NBR", 7),  # @24
        fmt_char("CLASS_NBR", 7),  # @31
        fmt_char("Instruction_Type", 1),  # @38
        fmt_char("Student_Classification", 1),  # @39
        fmt_char("Non_Disclosure", 1),  # @40
        fmt_char("SCH_Value", 4),  # @41
        fmt_char("SCH_State_Funded", 4),  # @45
        fmt_char("SCH_Not_State_Funded", 4),  # @49
        fmt_char("Grad_12H", 1),  # @53
        fmt_char("Location_Code", 1),  # @54
        fmt_char("Other_Higher_Ed_Site", 6),  # @55
        fmt_char("Instruction_Mode", 1),  # @61
        fmt_char("SCH_Not_Funded_Reason", 1),  # @62
        fmt_char("HighSchool_Credit", 1),  # @63
        fmt_char("Developmental_Education", 1),  # @64
        fmt_char("First_College_Level_Course", 1),  # @65
        fmt_char("Course_Grade", 1),  # @66
        fmt_char("Grade_Value", 3),  # @67
        fmt_char("Composite_Class_Code", 2),  # @70
        fmt_char("Off_Campus_Location", 5),  # @72
        fmt_char("Flex_entry", 1),  # @77
        fmt_char("Inter_Institution_Identifier", 1),  # @78
        fmt_char("Semester", 1),  # @79
        fmt_char("Year", 4),  # @80
        fmt_char("START_DT", 8),  # @84
        fmt_char("END_DT", 8),  # @92
    ),
)

# Data lines DataFrame
df_data_lines = df_fixed_width.select(F.col("fixed_width_line").alias("value"))

# COMMAND ----------

# FILE: Write CBM00S_{current_term}_{sysdate9}.txt — header + data + EOF
# Get SEMESTER and YEAR from first record for header construction
first_row = df_cbm00s_cbreported_final.select("SEMESTER", "YEAR").first()
semester_val = first_row["SEMESTER"] or " "
year_val = first_row["YEAR"] or "    "
record_count = df_cbm00s_cbreported_final.count()

# SAS date format: 23JUN2026 (SYSDATE9.)
sysdate9 = datetime.now().strftime("%d%b%Y").upper()

# Build header line (same width as data records)
header_text = (
    f"HY2K003656CBM00S"
    f"{semester_val[:1]}"
    f"{year_val[:4]}"
    f"C0099JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU"
)
header_line = header_text

# Build EOF line
eof_text = f"EOF1{str(record_count).rjust(6, '0')}"
eof_line = eof_text

# Create header and EOF DataFrames with sort keys
header_df = spark.createDataFrame([(header_line, 0)], ["value", "_sort_key"])
eof_df = spark.createDataFrame([(eof_line, 2)], ["value", "_sort_key"])
data_df = df_data_lines.withColumn("_sort_key", F.lit(1))

# Union: header (0) + data (1) + EOF (2), ordered by sort key
df_full_file = (
    header_df.unionAll(data_df).unionAll(eof_df).orderBy("_sort_key").select("value")
)

# Write to text file
cbm_filename = f"CBM00S_{current_term}_{sysdate9}"
(df_full_file.coalesce(1).write.mode("overwrite").text(f"{output_path}{cbm_filename}"))

# Rename part file to final filename
_part_files = dbutils.fs.ls(f"{output_path}{cbm_filename}")
_part_file = [f.path for f in _part_files if f.name.startswith("part-")][0]
dbutils.fs.cp(_part_file, f"{output_path}{cbm_filename}.txt")
dbutils.fs.rm(f"{output_path}{cbm_filename}", recurse=True)

log_msg(f"Written: {output_path}{cbm_filename}.txt")

# COMMAND ----------

# Step: SCHBuckets
# SCHBuckets

df_schbuckets = adw_cbm00s_work.join(
    uta_cb_crse_inventory,
    on=(
        (
            F.col("ADW_CBM00S_WORK.SUBJECT")
            == F.col("UTA_CB_CRSE_INVENTORY.SUBJECT_CODE")
        )
        & (
            F.col("ADW_CBM00S_WORK.CATALOG_NBR")
            == F.col("UTA_CB_CRSE_INVENTORY.CATALOG_NUMBER")
        )
        & (
            F.col("ADW_CBM00S_WORK.STRM")
            >= F.col("UTA_CB_CRSE_INVENTORY.INVENTORYSTARTTERM")
        )
        & (
            F.col("ADW_CBM00S_WORK.STRM")
            <= F.col("UTA_CB_CRSE_INVENTORY.INVENTORYENDTERM")
        )
    ),
    how="left",
)

df_schbuckets = df_schbuckets.withColumn(
    "UNFUNDED_SCH_TOTAL",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
            & (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("Y"))
            & (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("No"))
        ),
        F.when(
            (
                (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                | (
                    F.substring(F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2)
                    == F.lit("99")
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0)),
    ).otherwise(
        F.when(
            (
                (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                | (
                    F.substring(F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2)
                    == F.lit("99")
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "LOWER_LEVEL_EXCEED_STATE",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
            & (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("Y"))
        ),
        F.when(
            (
                (
                    (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                )
                & (
                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["1", "2"])
                    | F.col("ADW_CBM00S_WORK.Student_Classification").isin(["1", "2"])
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0)),
    ).otherwise(
        F.when(
            (
                (
                    (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                )
                & (
                    (
                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNotNull()
                        & (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") != F.lit(""))
                        & (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").cast("BIGINT")
                            <= F.lit(2)
                        )
                    )
                    | (
                        (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNull()
                            | (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") == F.lit(""))
                        )
                        & (
                            F.substring(
                                F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1
                            ).cast("BIGINT")
                            <= F.lit(2)
                        )
                    )
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

df_schbuckets = df_schbuckets.withColumn(
    "NOT_STATE_FUNDED_LOWER",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
        ),
        F.lit(0),
    ).otherwise(
        F.when(
            (
                (
                    F.substring(F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2)
                    == F.lit("99")
                )
                & (
                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["1", "2"])
                    | F.col("ADW_CBM00S_WORK.Student_Classification").isin(["1", "2"])
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "NOT_STATE_FUNDED_UPPER",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
        ),
        F.lit(0),
    ).otherwise(
        F.when(
            (
                (
                    F.substring(F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2)
                    == F.lit("99")
                )
                & (
                    (
                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["3", "4"])
                        & ~F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                            ["1", "2"]
                        )
                    )
                    | (
                        F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                            ["3", "4", "5"]
                        )
                        & ~F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["1", "2"])
                        & (
                            (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("0"))
                            | (
                                (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("1"))
                                & (F.col("ADW_CBM00S_WORK.PRE1998") == F.lit("Y"))
                            )
                        )
                    )
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "LOWER_LEVEL_UNFUNDED_TOTAL",
    F.coalesce(
        F.when(
            (
                (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
                & (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("Y"))
            ),
            F.when(
                (
                    (
                        (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                    )
                    & (
                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["1", "2"])
                        | F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                            ["1", "2"]
                        )
                    )
                ),
                (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
            ).otherwise(F.lit(0)),
        ).otherwise(
            F.when(
                (
                    (
                        (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                        | (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                        | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                    )
                    & (
                        (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNotNull()
                            & (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") != F.lit(""))
                            & (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").cast(
                                    "BIGINT"
                                )
                                <= F.lit(2)
                            )
                        )
                        | (
                            (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNull()
                                | (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                    == F.lit("")
                                )
                            )
                            & (
                                F.substring(
                                    F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1
                                ).cast("BIGINT")
                                <= F.lit(2)
                            )
                        )
                    )
                ),
                (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
            ).otherwise(F.lit(0))
        ),
        F.lit(0),
    )
    + F.coalesce(
        F.when(
            (
                (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
            ),
            F.lit(0),
        ).otherwise(
            F.when(
                (
                    (
                        F.substring(
                            F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2
                        )
                        == F.lit("99")
                    )
                    & (
                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["1", "2"])
                        | F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                            ["1", "2"]
                        )
                    )
                ),
                (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
            ).otherwise(F.lit(0))
        ),
        F.lit(0),
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "LOWER_LEVEL_FUNDED",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
        ),
        F.lit(0),
    ).otherwise(
        F.when(
            (
                (
                    F.substring(F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2)
                    != F.lit("99")
                )
                & (
                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["1", "2"])
                    | F.col("ADW_CBM00S_WORK.Student_Classification").isin(["1", "2"])
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "LOWER_LEVEL_TOTAL",
    (
        F.coalesce(
            (
                F.coalesce(
                    F.when(
                        (
                            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
                            & (
                                F.col("ADW_CBM00S_WORK.CB_Reported_Course")
                                == F.lit("Y")
                            )
                        ),
                        F.when(
                            (
                                (
                                    (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                                    | (
                                        F.col("ADW_CBM00S_WORK.DVLP_FLAG")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.FLAG_3PEAT")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.Unfunded_Flag")
                                        == F.lit("Yes")
                                    )
                                )
                                & (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                        ["1", "2"]
                                    )
                                    | F.col(
                                        "ADW_CBM00S_WORK.Student_Classification"
                                    ).isin(["1", "2"])
                                )
                            ),
                            (
                                F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT")
                                / F.lit(100)
                            ),
                        ).otherwise(F.lit(0)),
                    ).otherwise(
                        F.when(
                            (
                                (
                                    (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                                    | (
                                        F.col("ADW_CBM00S_WORK.DVLP_FLAG")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.FLAG_3PEAT")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.Unfunded_Flag")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.CB_Reported_Student")
                                        == F.lit("N")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.CB_Reported_Course")
                                        == F.lit("N")
                                    )
                                )
                                & (
                                    (
                                        F.col(
                                            "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                        ).isNotNull()
                                        & (
                                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                            != F.lit("")
                                        )
                                        & (
                                            F.col(
                                                "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                            ).cast("BIGINT")
                                            <= F.lit(2)
                                        )
                                    )
                                    | (
                                        (
                                            F.col(
                                                "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                            ).isNull()
                                            | (
                                                F.col(
                                                    "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                                )
                                                == F.lit("")
                                            )
                                        )
                                        & (
                                            F.substring(
                                                F.col("ADW_CBM00S_WORK.CATALOG_NBR"),
                                                1,
                                                1,
                                            ).cast("BIGINT")
                                            <= F.lit(2)
                                        )
                                    )
                                )
                            ),
                            (
                                F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT")
                                / F.lit(100)
                            ),
                        ).otherwise(F.lit(0))
                    ),
                    F.lit(0),
                )
                + F.coalesce(
                    F.when(
                        (
                            (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                        ),
                        F.lit(0),
                    ).otherwise(
                        F.when(
                            (
                                (
                                    F.substring(
                                        F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"),
                                        9,
                                        2,
                                    )
                                    == F.lit("99")
                                )
                                & (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                        ["1", "2"]
                                    )
                                    | F.col(
                                        "ADW_CBM00S_WORK.Student_Classification"
                                    ).isin(["1", "2"])
                                )
                            ),
                            (
                                F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT")
                                / F.lit(100)
                            ),
                        ).otherwise(F.lit(0))
                    ),
                    F.lit(0),
                )
            ),
            F.lit(0),
        )
        + F.coalesce(
            F.when(
                (
                    (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                ),
                F.lit(0),
            ).otherwise(
                F.when(
                    (
                        (
                            F.substring(
                                F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2
                            )
                            != F.lit("99")
                        )
                        & (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["1", "2"])
                            | F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                ["1", "2"]
                            )
                        )
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0))
            ),
            F.lit(0),
        )
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "UPPER_LEVEL_EXCEED_STATE",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
            & (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("Y"))
        ),
        F.when(
            F.expr(
                "(ADW_CBM00S_WORK.EXC_FLAG = 'Yes' OR ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' OR ADW_CBM00S_WORK.FLAG_3PEAT = 'Yes' OR ADW_CBM00S_WORK.PHYED_CNT_FLG = 'Yes' OR ADW_CBM00S_WORK.Unfunded_Flag = 'Yes') AND ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3', '4') AND ADW_CBM00S_WORK.Student_Classification NOT IN ('1', '2')) OR (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('5', '6') AND ADW_CBM00S_WORK.Student_Classification IN ('3', '4'))) AND (ADW_CBM00S_WORK.Grad_12H = '0' OR (ADW_CBM00S_WORK.Grad_12H = '1' AND ADW_CBM00S_WORK.PRE1998 = 'Y'))"
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0)),
    ).otherwise(
        F.when(
            (
                (
                    (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                )
                & (
                    (
                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNotNull()
                        & (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") != F.lit(""))
                        & F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["3", "4"])
                    )
                    | (
                        (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNull()
                            | (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") == F.lit(""))
                        )
                        & F.substring(F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1).isin(
                            ["3", "4"]
                        )
                    )
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

df_schbuckets = df_schbuckets.withColumn(
    "UPPER_LEVEL_UNFUNDED_TOTAL",
    (
        F.coalesce(
            F.when(
                (
                    (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
                    & (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("Y"))
                ),
                F.when(
                    F.expr(
                        "(ADW_CBM00S_WORK.EXC_FLAG = 'Yes' OR ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' OR ADW_CBM00S_WORK.FLAG_3PEAT = 'Yes' OR ADW_CBM00S_WORK.PHYED_CNT_FLG = 'Yes' OR ADW_CBM00S_WORK.Unfunded_Flag = 'Yes') AND ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3', '4') AND ADW_CBM00S_WORK.Student_Classification NOT IN ('1', '2')) OR (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('5', '6') AND ADW_CBM00S_WORK.Student_Classification IN ('3', '4'))) AND (ADW_CBM00S_WORK.Grad_12H = '0' OR (ADW_CBM00S_WORK.Grad_12H = '1' AND ADW_CBM00S_WORK.PRE1998 = 'Y'))"
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0)),
            ).otherwise(
                F.when(
                    (
                        (
                            (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                            | (
                                F.col("ADW_CBM00S_WORK.CB_Reported_Student")
                                == F.lit("N")
                            )
                            | (
                                F.col("ADW_CBM00S_WORK.CB_Reported_Course")
                                == F.lit("N")
                            )
                        )
                        & (
                            (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNotNull()
                                & (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                    != F.lit("")
                                )
                                & F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                    ["3", "4"]
                                )
                            )
                            | (
                                (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNull()
                                    | (
                                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                        == F.lit("")
                                    )
                                )
                                & F.substring(
                                    F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1
                                ).isin(["3", "4"])
                            )
                        )
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0))
            ),
            F.lit(0),
        )
        + F.coalesce(
            F.when(
                (
                    (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                ),
                F.lit(0),
            ).otherwise(
                F.when(
                    (
                        (
                            F.substring(
                                F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2
                            )
                            == F.lit("99")
                        )
                        & (
                            (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                    ["3", "4"]
                                )
                                & ~F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                    ["1", "2"]
                                )
                            )
                            | (
                                F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                    ["3", "4"]
                                )
                                & ~F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                    ["1", "2"]
                                )
                                & (
                                    (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("0"))
                                    | (
                                        (
                                            F.col("ADW_CBM00S_WORK.Grad_12H")
                                            == F.lit("1")
                                        )
                                        & (
                                            F.col("ADW_CBM00S_WORK.PRE1998")
                                            == F.lit("Y")
                                        )
                                    )
                                )
                            )
                        )
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0))
            ),
            F.lit(0),
        )
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "UPPER_LEVEL_FUNDED",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
        ),
        F.lit(0),
    ).otherwise(
        F.when(
            (
                (
                    F.substring(F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2)
                    != F.lit("99")
                )
                & (
                    (
                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["3", "4"])
                        & ~F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                            ["1", "2"]
                        )
                    )
                    | (
                        F.col("ADW_CBM00S_WORK.Student_Classification").isin(["3", "4"])
                        & ~F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(["1", "2"])
                        & (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("0"))
                    )
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "UPPER_LEVEL_TOTAL",
    (
        F.coalesce(
            (
                F.coalesce(
                    F.when(
                        (
                            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
                            & (
                                F.col("ADW_CBM00S_WORK.CB_Reported_Course")
                                == F.lit("Y")
                            )
                        ),
                        F.when(
                            F.expr(
                                "(ADW_CBM00S_WORK.EXC_FLAG = 'Yes' OR ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' OR ADW_CBM00S_WORK.FLAG_3PEAT = 'Yes' OR ADW_CBM00S_WORK.PHYED_CNT_FLG = 'Yes' OR ADW_CBM00S_WORK.Unfunded_Flag = 'Yes') AND ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3', '4') AND ADW_CBM00S_WORK.Student_Classification NOT IN ('1', '2')) OR (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('5', '6') AND ADW_CBM00S_WORK.Student_Classification IN ('3', '4'))) AND (ADW_CBM00S_WORK.Grad_12H = '0' OR (ADW_CBM00S_WORK.Grad_12H = '1' AND ADW_CBM00S_WORK.PRE1998 = 'Y'))"
                            ),
                            (
                                F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT")
                                / F.lit(100)
                            ),
                        ).otherwise(F.lit(0)),
                    ).otherwise(
                        F.when(
                            (
                                (
                                    (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                                    | (
                                        F.col("ADW_CBM00S_WORK.DVLP_FLAG")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.FLAG_3PEAT")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.Unfunded_Flag")
                                        == F.lit("Yes")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.CB_Reported_Student")
                                        == F.lit("N")
                                    )
                                    | (
                                        F.col("ADW_CBM00S_WORK.CB_Reported_Course")
                                        == F.lit("N")
                                    )
                                )
                                & (
                                    (
                                        F.col(
                                            "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                        ).isNotNull()
                                        & (
                                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                            != F.lit("")
                                        )
                                        & F.col(
                                            "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                        ).isin(["3", "4"])
                                    )
                                    | (
                                        (
                                            F.col(
                                                "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                            ).isNull()
                                            | (
                                                F.col(
                                                    "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                                )
                                                == F.lit("")
                                            )
                                        )
                                        & F.substring(
                                            F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1
                                        ).isin(["3", "4"])
                                    )
                                )
                            ),
                            (
                                F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT")
                                / F.lit(100)
                            ),
                        ).otherwise(F.lit(0))
                    ),
                    F.lit(0),
                )
                + F.coalesce(
                    F.when(
                        (
                            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                            | (
                                F.col("ADW_CBM00S_WORK.CB_Reported_Course")
                                == F.lit("N")
                            )
                            | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                        ),
                        F.lit(0),
                    ).otherwise(
                        F.when(
                            (
                                (
                                    F.substring(
                                        F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"),
                                        9,
                                        2,
                                    )
                                    == F.lit("99")
                                )
                                & (
                                    (
                                        F.col(
                                            "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                        ).isin(["3", "4"])
                                        & ~F.col(
                                            "ADW_CBM00S_WORK.Student_Classification"
                                        ).isin(["1", "2"])
                                    )
                                    | (
                                        F.col(
                                            "ADW_CBM00S_WORK.Student_Classification"
                                        ).isin(["3", "4"])
                                        & ~F.col(
                                            "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                        ).isin(["1", "2"])
                                        & (
                                            (
                                                F.col("ADW_CBM00S_WORK.Grad_12H")
                                                == F.lit("0")
                                            )
                                            | (
                                                (
                                                    F.col("ADW_CBM00S_WORK.Grad_12H")
                                                    == F.lit("1")
                                                )
                                                & (
                                                    F.col("ADW_CBM00S_WORK.PRE1998")
                                                    == F.lit("Y")
                                                )
                                            )
                                        )
                                    )
                                )
                            ),
                            (
                                F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT")
                                / F.lit(100)
                            ),
                        ).otherwise(F.lit(0))
                    ),
                    F.lit(0),
                )
            ),
            F.lit(0),
        )
        + F.coalesce(
            F.when(
                (
                    (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                ),
                F.lit(0),
            ).otherwise(
                F.when(
                    (
                        (
                            F.substring(
                                F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2
                            )
                            != F.lit("99")
                        )
                        & (
                            (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                    ["3", "4"]
                                )
                                & ~F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                    ["1", "2"]
                                )
                            )
                            | (
                                F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                    ["3", "4"]
                                )
                                & ~F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                    ["1", "2"]
                                )
                                & (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("0"))
                            )
                        )
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0))
            ),
            F.lit(0),
        )
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "MASTER_LEVEL_UNFUNDED",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
            & (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("Y"))
        ),
        F.when(
            (
                (
                    (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                )
                & (
                    (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") == F.lit("5"))
                    | (
                        (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") == F.lit("6"))
                        & (
                            F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                ["5", "6"]
                            )
                            | (
                                (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("1"))
                                & (F.col("ADW_CBM00S_WORK.PRE1998") == F.lit("N"))
                            )
                        )
                    )
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0)),
    ).otherwise(
        F.when(
            (
                (
                    (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                )
                & (
                    (
                        (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNotNull()
                            & (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") != F.lit(""))
                            & (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                == F.lit("5")
                            )
                        )
                        | (
                            (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNull()
                                | (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                    == F.lit("")
                                )
                            )
                            & (
                                F.substring(F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1)
                                == F.lit("5")
                            )
                        )
                    )
                    | (
                        (
                            (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNotNull()
                                & (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                    != F.lit("")
                                )
                                & (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                    == F.lit("6")
                                )
                            )
                            | (
                                (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNull()
                                    | (
                                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                        == F.lit("")
                                    )
                                )
                                & (
                                    F.substring(
                                        F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1
                                    )
                                    == F.lit("6")
                                )
                            )
                        )
                        & (
                            F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                ["5", "6"]
                            )
                            | (
                                (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("1"))
                                & (F.col("ADW_CBM00S_WORK.PRE1998") == F.lit("N"))
                            )
                        )
                    )
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "MASTER_LEVEL_FUNDED",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
        ),
        F.lit(0),
    ).otherwise(
        F.when(
            (
                (
                    F.substring(F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2)
                    != F.lit("99")
                )
                & (
                    (
                        (
                            (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") == F.lit("5"))
                            & F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                ["5", "6", "7", "8"]
                            )
                        )
                        | (
                            F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                                ["5", "6"]
                            )
                            & F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                ["6", "7", "8"]
                            )
                        )
                    )
                    | (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("1"))
                )
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "MASTER_LEVEL_TOTAL",
    (
        F.coalesce(
            F.when(
                (
                    (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("Y"))
                    & (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("Y"))
                ),
                F.when(
                    (
                        (
                            (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                        )
                        & (
                            (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") == F.lit("5"))
                            | (
                                (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                    == F.lit("6")
                                )
                                & (
                                    F.col(
                                        "ADW_CBM00S_WORK.Student_Classification"
                                    ).isin(["5", "6"])
                                    | (
                                        (
                                            F.col("ADW_CBM00S_WORK.Grad_12H")
                                            == F.lit("1")
                                        )
                                        & (
                                            F.col("ADW_CBM00S_WORK.PRE1998")
                                            == F.lit("N")
                                        )
                                    )
                                )
                            )
                        )
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0)),
            ).otherwise(
                F.when(
                    (
                        (
                            (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                            | (
                                F.col("ADW_CBM00S_WORK.CB_Reported_Student")
                                == F.lit("N")
                            )
                            | (
                                F.col("ADW_CBM00S_WORK.CB_Reported_Course")
                                == F.lit("N")
                            )
                        )
                        & (
                            (
                                (
                                    F.col(
                                        "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                    ).isNotNull()
                                    & (
                                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                        != F.lit("")
                                    )
                                    & (
                                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                        == F.lit("5")
                                    )
                                )
                                | (
                                    (
                                        F.col(
                                            "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                        ).isNull()
                                        | (
                                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                            == F.lit("")
                                        )
                                    )
                                    & (
                                        F.substring(
                                            F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1
                                        )
                                        == F.lit("5")
                                    )
                                )
                            )
                            | (
                                (
                                    (
                                        F.col(
                                            "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                        ).isNotNull()
                                        & (
                                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                            != F.lit("")
                                        )
                                        & (
                                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                            == F.lit("6")
                                        )
                                    )
                                    | (
                                        (
                                            F.col(
                                                "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                            ).isNull()
                                            | (
                                                F.col(
                                                    "UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"
                                                )
                                                == F.lit("")
                                            )
                                        )
                                        & (
                                            F.substring(
                                                F.col("ADW_CBM00S_WORK.CATALOG_NBR"),
                                                1,
                                                1,
                                            )
                                            == F.lit("6")
                                        )
                                    )
                                )
                                & (
                                    F.col(
                                        "ADW_CBM00S_WORK.Student_Classification"
                                    ).isin(["5", "6"])
                                    | (
                                        (
                                            F.col("ADW_CBM00S_WORK.Grad_12H")
                                            == F.lit("1")
                                        )
                                        & (
                                            F.col("ADW_CBM00S_WORK.PRE1998")
                                            == F.lit("N")
                                        )
                                    )
                                )
                            )
                        )
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0))
            ),
            F.lit(0),
        )
        + F.coalesce(
            F.when(
                (
                    (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                ),
                F.lit(0),
            ).otherwise(
                F.when(
                    (
                        (
                            F.substring(
                                F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2
                            )
                            != F.lit("99")
                        )
                        & (
                            (
                                (
                                    (
                                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                        == F.lit("5")
                                    )
                                    & F.col(
                                        "ADW_CBM00S_WORK.Student_Classification"
                                    ).isin(["5", "6", "7", "8"])
                                )
                                | (
                                    F.col(
                                        "ADW_CBM00S_WORK.Student_Classification"
                                    ).isin(["5", "6"])
                                    & F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isin(
                                        ["6", "7", "8"]
                                    )
                                )
                            )
                            | (F.col("ADW_CBM00S_WORK.Grad_12H") == F.lit("1"))
                        )
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0))
            ),
            F.lit(0),
        )
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "DOCTORAL_LEVEL_UNFUNDED",
    F.when(
        (
            (
                (
                    (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                )
                & (
                    (
                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNotNull()
                        & (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") != F.lit(""))
                        & (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").cast("BIGINT")
                            > F.lit(5)
                        )
                    )
                    | (
                        (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNull()
                            | (F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL") == F.lit(""))
                        )
                        & (
                            F.substring(
                                F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1
                            ).cast("BIGINT")
                            > F.lit(5)
                        )
                    )
                )
            )
            & F.col("ADW_CBM00S_WORK.Student_Classification").isin(["7", "8"])
        ),
        (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
    ).otherwise(F.lit(0)),
)

df_schbuckets = df_schbuckets.withColumn(
    "DOCTORAL_LEVEL_FUNDED",
    F.when(
        (
            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
        ),
        F.lit(0),
    ).otherwise(
        F.when(
            (
                (
                    F.substring(F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2)
                    != F.lit("99")
                )
                & (
                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").cast("BIGINT")
                    > F.lit(5)
                )
                & F.col("ADW_CBM00S_WORK.Student_Classification").isin(["7", "8"])
            ),
            (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
        ).otherwise(F.lit(0))
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.withColumn(
    "DOCTORAL_LEVEL_TOTAL",
    (
        F.coalesce(
            F.when(
                (
                    (
                        (
                            (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                            | (
                                F.col("ADW_CBM00S_WORK.CB_Reported_Course")
                                == F.lit("N")
                            )
                            | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                            | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                        )
                        & (
                            (
                                F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNotNull()
                                & (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                    != F.lit("")
                                )
                                & (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").cast(
                                        "BIGINT"
                                    )
                                    > F.lit(5)
                                )
                            )
                            | (
                                (
                                    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").isNull()
                                    | (
                                        F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL")
                                        == F.lit("")
                                    )
                                )
                                & (
                                    F.substring(
                                        F.col("ADW_CBM00S_WORK.CATALOG_NBR"), 1, 1
                                    ).cast("BIGINT")
                                    > F.lit(5)
                                )
                            )
                        )
                    )
                    & F.col("ADW_CBM00S_WORK.Student_Classification").isin(["7", "8"])
                ),
                (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
            ).otherwise(F.lit(0)),
            F.lit(0),
        )
        + F.coalesce(
            F.when(
                (
                    (F.col("ADW_CBM00S_WORK.CB_Reported_Student") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.CB_Reported_Course") == F.lit("N"))
                    | (F.col("ADW_CBM00S_WORK.DVLP_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.FLAG_3PEAT") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.EXC_FLAG") == F.lit("Yes"))
                    | (F.col("ADW_CBM00S_WORK.Unfunded_Flag") == F.lit("Yes"))
                ),
                F.lit(0),
            ).otherwise(
                F.when(
                    (
                        (
                            F.substring(
                                F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"), 9, 2
                            )
                            != F.lit("99")
                        )
                        & (
                            F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL").cast("BIGINT")
                            > F.lit(5)
                        )
                        & F.col("ADW_CBM00S_WORK.Student_Classification").isin(
                            ["7", "8"]
                        )
                    ),
                    (F.col("ADW_CBM00S_WORK.SCH_Value").cast("BIGINT") / F.lit(100)),
                ).otherwise(F.lit(0))
            ),
            F.lit(0),
        )
    ),
)

# COMMAND ----------

df_schbuckets = df_schbuckets.select(
    F.col("ADW_CBM00S_WORK.Record_Code"),
    F.col("ADW_CBM00S_WORK.College_Code"),
    F.col("ADW_CBM00S_WORK.STRM"),
    F.col("ADW_CBM00S_WORK.EMPLID"),
    F.col("ADW_CBM00S_WORK.National_Id"),
    F.col("ADW_CBM00S_WORK.SUBJECT"),
    F.col("ADW_CBM00S_WORK.CATALOG_NBR"),
    F.col("ADW_CBM00S_WORK.CLASS_NBR"),
    F.col("ADW_CBM00S_WORK.Instruction_Type"),
    F.col("ADW_CBM00S_WORK.Student_Classification_Desc"),
    F.col("ADW_CBM00S_WORK.Student_Classification"),
    F.col("ADW_CBM00S_WORK.Non_Disclosure"),
    F.col("ADW_CBM00S_WORK.SCH_Value"),
    F.col("ADW_CBM00S_WORK.SCH_State_Funded"),
    F.col("ADW_CBM00S_WORK.SCH_Not_State_Funded"),
    F.col("ADW_CBM00S_WORK.Grad_12H"),
    F.col("ADW_CBM00S_WORK.Location_Code"),
    F.col("ADW_CBM00S_WORK.Other_Higher_Ed_Site"),
    F.col("ADW_CBM00S_WORK.Instruction_Mode"),
    F.col("ADW_CBM00S_WORK.SCH_Not_Funded_Reason"),
    F.col("ADW_CBM00S_WORK.HighSchool_Credit"),
    F.col("ADW_CBM00S_WORK.Developmental_Education"),
    F.col("ADW_CBM00S_WORK.First_College_Level_Course"),
    F.col("ADW_CBM00S_WORK.Course_Grade"),
    F.col("ADW_CBM00S_WORK.Grade_Value"),
    F.col("ADW_CBM00S_WORK.Composite_Class_Code"),
    F.col("ADW_CBM00S_WORK.Off_Campus_Location"),
    F.col("ADW_CBM00S_WORK.Flex_entry"),
    F.col("ADW_CBM00S_WORK.Inter_Institution_Identifier"),
    F.col("ADW_CBM00S_WORK.Semester"),
    F.col("ADW_CBM00S_WORK.Year"),
    F.col("ADW_CBM00S_WORK.START_DT"),
    F.col("ADW_CBM00S_WORK.END_DT"),
    F.col("ADW_CBM00S_WORK.CRSE_ID"),
    F.col("ADW_CBM00S_WORK.CRSE_OFFER_NBR"),
    F.col("ADW_CBM00S_WORK.CLASS_TYPE"),
    F.col("ADW_CBM00S_WORK.ACAD_CAREER"),
    F.col("ADW_CBM00S_WORK.ACAD_PROG"),
    F.col("ADW_CBM00S_WORK.ACAD_GROUP"),
    F.col("ADW_CBM00S_WORK.ACAD_ORG"),
    F.col("ADW_CBM00S_WORK.CAMPUS"),
    F.col("ADW_CBM00S_WORK.STDNT_CAR_NBR"),
    F.col("ADW_CBM00S_WORK.ACAD_LEVEL_BOT"),
    F.col("ADW_CBM00S_WORK.ACAD_LEVEL_EOT"),
    F.col("ADW_CBM00S_WORK.DEGR_CHKOUT_STAT"),
    F.col("ADW_CBM00S_WORK.MIN_UNITS_REQD"),
    F.col("ADW_CBM00S_WORK.LOCATION"),
    F.col("ADW_CBM00S_WORK.TERM_BEGIN_DT"),
    F.col("ADW_CBM00S_WORK.TERM_END_DT"),
    F.col("ADW_CBM00S_WORK.CENSUS_DT"),
    F.col("ADW_CBM00S_WORK.CB_Exclude"),
    F.col("ADW_CBM00S_WORK.ENRL_TOT"),
    F.col("ADW_CBM00S_WORK.COMPONENT_PRIMARY"),
    F.col("ADW_CBM00S_WORK.SESSION_CODE"),
    F.col("ADW_CBM00S_WORK.Current_Term_End_date"),
    F.col("ADW_CBM00S_WORK.CRSE_GRADE_OFF"),
    F.col("ADW_CBM00S_WORK.UNT_PRGRSS"),
    F.col("ADW_CBM00S_WORK.UNT_EARNED"),
    F.col("ADW_CBM00S_WORK.UNT_TAKEN_SEM"),
    F.col("ADW_CBM00S_WORK.UNT_TAKEN"),
    F.col("ADW_CBM00S_WORK.REQ_TERM"),
    F.col("ADW_CBM00S_WORK.TOT_CUMULATIVE"),
    F.col("ADW_CBM00S_WORK.UTA_UNFN_TYPE"),
    F.col("ADW_CBM00S_WORK.UTA_UNFN_UNITS"),
    F.col("ADW_CBM00S_WORK.Prior_Enrolled_Term"),
    F.col("ADW_CBM00S_WORK.FERPA"),
    F.col("ADW_CBM00S_WORK.ADMIT_TERM"),
    F.col("ADW_CBM00S_WORK.ADM_APPL_NBR"),
    F.col("ADW_CBM00S_WORK.ADM_ADMIT_TERM"),
    F.col("ADW_CBM00S_WORK.ADMIT_TYPE"),
    F.col("ADW_CBM00S_WORK.RECRUITMENT_CAT"),
    F.col("ADW_CBM00S_WORK.ARTICULATION_TERM"),
    F.col("ADW_CBM00S_WORK.CRSE_ATTR_LIST"),
    F.col("ADW_CBM00S_WORK.CRSE_VAL_LIST"),
    F.col("ADW_CBM00S_WORK.CLASS_ATTR_LIST"),
    F.col("ADW_CBM00S_WORK.CLASS_VAL_LIST"),
    F.col("ADW_CBM00S_WORK.CORE_COURSE"),
    F.col("ADW_CBM00S_WORK.GDR_Indicator"),
    F.col("ADW_CBM00S_WORK.EXC_FLAG"),
    F.col("ADW_CBM00S_WORK.DVLP_FLAG"),
    F.col("ADW_CBM00S_WORK.FLAG_3PEAT"),
    F.col("ADW_CBM00S_WORK.PHYED_CNT_FLG"),
    F.col("ADW_CBM00S_WORK.Unfunded_Flag"),
    F.col("ADW_CBM00S_WORK.AP_Student"),
    F.col("ADW_CBM00S_WORK.AP_Course"),
    F.col("ADW_CBM00S_WORK.DLRN_Course"),
    F.col("ADW_CBM00S_WORK.DLRN_Student"),
    F.col("ADW_CBM00S_WORK.CB_Reported_Student"),
    F.col("ADW_CBM00S_WORK.CB_Reported_Course"),
    F.col("ADW_CBM00S_WORK.Current_Semester_Reportable"),
    F.col("ADW_CBM00S_WORK.Prior_Crse_Transfer"),
    F.col("ADW_CBM00S_WORK.Current_Term"),
    F.col("UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE"),
    F.col("UTA_CB_CRSE_INVENTORY.COURSE_SCH"),
    F.col("UTA_CB_CRSE_INVENTORY.COURSE_LEVEL"),
    F.col("UTA_CB_CRSE_INVENTORY.FUND_YEAR"),
    F.col("UTA_CB_CRSE_INVENTORY.FORMULA_CODE"),
    F.col("UNFUNDED_SCH_TOTAL"),
    F.col("LOWER_LEVEL_EXCEED_STATE"),
    F.lit(0).alias("LOWER_LEVEL_EXCEED_DEVELOP"),
    F.col("NOT_STATE_FUNDED_LOWER"),
    F.col("NOT_STATE_FUNDED_UPPER"),
    F.col("LOWER_LEVEL_UNFUNDED_TOTAL"),
    F.col("LOWER_LEVEL_FUNDED"),
    F.col("LOWER_LEVEL_TOTAL"),
    F.col("UPPER_LEVEL_EXCEED_STATE"),
    F.lit(0).alias("UPPER_LEVEL_EXCEED_DEVELOP"),
    F.col("UPPER_LEVEL_UNFUNDED_TOTAL"),
    F.col("UPPER_LEVEL_FUNDED"),
    F.col("UPPER_LEVEL_TOTAL"),
    F.col("MASTER_LEVEL_UNFUNDED"),
    F.col("MASTER_LEVEL_FUNDED"),
    F.col("MASTER_LEVEL_TOTAL"),
    F.col("DOCTORAL_LEVEL_UNFUNDED"),
    F.col("DOCTORAL_LEVEL_FUNDED"),
    F.col("DOCTORAL_LEVEL_TOTAL"),
).distinct()

# COMMAND ----------

# Step: SCHSummary
# SCHSummary
df_schsummary = df_schbuckets.alias("SCHBuckets")

df_schsummary = df_schsummary.join(
    adw_dept_dim,
    on=(
        (F.col("schbuckets.ACAD_ORG") == F.col("ADW_DEPT_DIM.DEPT"))
        & (F.coalesce(F.col("ADW_DEPT_DIM.is_current"), F.lit(False)) == F.lit(True))
    ),
    how="left",
).join(
    adw_term_dim,
    on=(
        (F.col("schbuckets.Current_Term") == F.col("ADW_TERM_DIM.STRM"))
        & (F.coalesce(F.col("ADW_TERM_DIM.ACAD_CAREER"), F.lit("")) == F.lit("UGRD"))
    ),
    how="left",
)

_winSpec_5 = Window.partitionBy(
    F.col("schbuckets.CB_Reported_Course"),
    F.col("schbuckets.CB_Reported_Student"),
    F.col("schbuckets.ACAD_ORG"),
    F.col("schbuckets.ACAD_GROUP"),
    F.col("schbuckets.Instruction_Type"),
    F.col("schbuckets.CLASS_NBR"),
    F.col("schbuckets.CATALOG_NBR"),
    F.col("schbuckets.SUBJECT"),
    F.col("schbuckets.STRM"),
)

df_schsummary = (
    df_schsummary.withColumn(
        "UNFUNDED_SCH_TOTAL",
        F.sum(F.col("schbuckets.UNFUNDED_SCH_TOTAL")).over(_winSpec_5),
    )
    .withColumn(
        "LOWER_LEVEL_EXCEED_STATE",
        F.sum(F.col("schbuckets.LOWER_LEVEL_EXCEED_STATE")).over(_winSpec_5),
    )
    .withColumn(
        "LOWER_LEVEL_EXCEED_DEVELOP",
        F.sum(F.col("schbuckets.LOWER_LEVEL_EXCEED_DEVELOP")).over(_winSpec_5),
    )
    .withColumn(
        "NOT_STATE_FUNDED_LOWER",
        F.sum(F.col("schbuckets.NOT_STATE_FUNDED_LOWER")).over(_winSpec_5),
    )
    .withColumn(
        "NOT_STATE_FUNDED_UPPER",
        F.sum(F.col("schbuckets.NOT_STATE_FUNDED_UPPER")).over(_winSpec_5),
    )
    .withColumn(
        "LOWER_LEVEL_UNFUNDED_TOTAL",
        F.sum(F.col("schbuckets.LOWER_LEVEL_UNFUNDED_TOTAL")).over(_winSpec_5),
    )
    .withColumn(
        "LOWER_LEVEL_FUNDED",
        F.sum(F.col("schbuckets.LOWER_LEVEL_FUNDED")).over(_winSpec_5),
    )
    .withColumn(
        "LOWER_LEVEL_TOTAL",
        F.sum(F.col("schbuckets.LOWER_LEVEL_TOTAL")).over(_winSpec_5),
    )
    .withColumn(
        "UPPER_LEVEL_EXCEED_STATE",
        F.sum(F.col("schbuckets.UPPER_LEVEL_EXCEED_STATE")).over(_winSpec_5),
    )
    .withColumn(
        "UPPER_LEVEL_EXCEED_DEVELOP",
        F.sum(F.col("schbuckets.UPPER_LEVEL_EXCEED_DEVELOP")).over(_winSpec_5),
    )
    .withColumn(
        "UPPER_LEVEL_UNFUNDED_TOTAL",
        F.sum(F.col("schbuckets.UPPER_LEVEL_UNFUNDED_TOTAL")).over(_winSpec_5),
    )
    .withColumn(
        "UPPER_LEVEL_FUNDED",
        F.sum(F.col("schbuckets.UPPER_LEVEL_FUNDED")).over(_winSpec_5),
    )
    .withColumn(
        "UPPER_LEVEL_TOTAL",
        F.sum(F.col("schbuckets.UPPER_LEVEL_TOTAL")).over(_winSpec_5),
    )
    .withColumn(
        "MASTER_LEVEL_UNFUNDED",
        F.sum(F.col("schbuckets.MASTER_LEVEL_UNFUNDED")).over(_winSpec_5),
    )
    .withColumn(
        "MASTER_LEVEL_FUNDED",
        F.sum(F.col("schbuckets.MASTER_LEVEL_FUNDED")).over(_winSpec_5),
    )
    .withColumn(
        "MASTER_LEVEL_TOTAL",
        F.sum(F.col("schbuckets.MASTER_LEVEL_TOTAL")).over(_winSpec_5),
    )
    .withColumn(
        "DOCTORAL_LEVEL_UNFUNDED",
        F.sum(F.col("schbuckets.DOCTORAL_LEVEL_UNFUNDED")).over(_winSpec_5),
    )
    .withColumn(
        "DOCTORAL_LEVEL_FUNDED",
        F.sum(F.col("schbuckets.DOCTORAL_LEVEL_FUNDED")).over(_winSpec_5),
    )
    .withColumn(
        "DOCTORAL_LEVEL_TOTAL",
        F.sum(F.col("schbuckets.DOCTORAL_LEVEL_TOTAL")).over(_winSpec_5),
    )
    .withColumn("_sel_tmp_19_0", F.count(F.col("schbuckets.EMPLID")).over(_winSpec_5))
    .withColumn(
        "Total_SCH",
        (
            (F.col("_sel_tmp_19_0") * F.col("schbuckets.SCH_Value").cast("BIGINT"))
            / F.lit(100)
        ),
    )
    .drop("_sel_tmp_19_0")
    .withColumn("Student_Count", F.count(F.col("schbuckets.EMPLID")).over(_winSpec_5))
)

# COMMAND ----------

df_schsummary = df_schsummary.select(
    F.col("schbuckets.STRM"),
    F.col("ADW_TERM_DIM.DESCR").alias("TermDescription"),
    F.col("schbuckets.SUBJECT"),
    F.col("schbuckets.CATALOG_NBR"),
    F.col("schbuckets.CLASS_NBR"),
    F.col("schbuckets.ACAD_GROUP"),
    F.col("ADW_DEPT_DIM.COLLEGE_DESCR"),
    F.col("schbuckets.ACAD_ORG"),
    F.col("ADW_DEPT_DIM.DEPT_DESCR"),
    F.col("schbuckets.Instruction_Type"),
    F.col("schbuckets.CORE_COURSE"),
    F.col("schbuckets.AP_Course"),
    F.col("schbuckets.DLRN_Course"),
    F.col("schbuckets.Flex_entry"),
    F.col("schbuckets.CIP_OR_FUND_CODE"),
    F.col("schbuckets.COURSE_SCH"),
    F.col("schbuckets.COURSE_LEVEL"),
    F.col("schbuckets.FUND_YEAR"),
    F.col("schbuckets.FORMULA_CODE"),
    F.col("UNFUNDED_SCH_TOTAL"),
    F.col("LOWER_LEVEL_EXCEED_STATE"),
    F.col("LOWER_LEVEL_EXCEED_DEVELOP"),
    F.col("NOT_STATE_FUNDED_LOWER"),
    F.col("NOT_STATE_FUNDED_UPPER"),
    F.col("LOWER_LEVEL_UNFUNDED_TOTAL"),
    F.col("LOWER_LEVEL_FUNDED"),
    F.col("LOWER_LEVEL_TOTAL"),
    F.col("UPPER_LEVEL_EXCEED_STATE"),
    F.col("UPPER_LEVEL_EXCEED_DEVELOP"),
    F.col("UPPER_LEVEL_UNFUNDED_TOTAL"),
    F.col("UPPER_LEVEL_FUNDED"),
    F.col("UPPER_LEVEL_TOTAL"),
    F.col("MASTER_LEVEL_UNFUNDED"),
    F.col("MASTER_LEVEL_FUNDED"),
    F.col("MASTER_LEVEL_TOTAL"),
    F.col("DOCTORAL_LEVEL_UNFUNDED"),
    F.col("DOCTORAL_LEVEL_FUNDED"),
    F.col("DOCTORAL_LEVEL_TOTAL"),
    F.col("Total_SCH"),
    F.col("Student_Count"),
    F.col("schbuckets.CB_Reported_Course"),
    F.col("schbuckets.CB_Reported_Student"),
    F.lit(current_term_census_date).alias("CENSUS_DT"),
).distinct()

# COMMAND ----------

# FTSE
df_ftse = df_schsummary.alias("SCHSummary")

df_ftse = df_ftse.withColumn(
    "UGRD_HRS",
    F.coalesce(F.col("SCHSummary.LOWER_LEVEL_TOTAL"), F.lit(0))
    + F.coalesce(F.col("SCHSummary.UPPER_LEVEL_TOTAL"), F.lit(0)),
)

df_ftse = df_ftse.withColumn(
    "UGRD_LOWER_FTSE",
    F.when(
        (
            (F.col("SCHSummary.CB_Reported_Course") == F.lit("Y"))
            & (F.col("SCHSummary.CB_Reported_Student") == F.lit("Y"))
        ),
        (F.col("SCHSummary.LOWER_LEVEL_FUNDED") / F.lit(15)),
    ).otherwise((F.col("SCHSummary.LOWER_LEVEL_UNFUNDED_TOTAL") / F.lit(15))),
)

df_ftse = df_ftse.withColumn(
    "UGRD_UPPER_FTSE",
    F.when(
        (
            (F.col("SCHSummary.CB_Reported_Course") == F.lit("Y"))
            & (F.col("SCHSummary.CB_Reported_Student") == F.lit("Y"))
        ),
        (F.col("SCHSummary.UPPER_LEVEL_FUNDED") / F.lit(15)),
    ).otherwise((F.col("SCHSummary.UPPER_LEVEL_UNFUNDED_TOTAL") / F.lit(15))),
)

df_ftse = df_ftse.withColumn(
    "UGRD_FTSE",
    F.when(
        (
            (F.col("SCHSummary.CB_Reported_Course") == F.lit("Y"))
            & (F.col("SCHSummary.CB_Reported_Student") == F.lit("Y"))
        ),
        (
            (
                F.coalesce(F.col("SCHSummary.LOWER_LEVEL_FUNDED"), F.lit(0))
                + F.coalesce(F.col("SCHSummary.UPPER_LEVEL_FUNDED"), F.lit(0))
            )
            / F.lit(15)
        ),
    ).otherwise(
        (
            (
                F.coalesce(F.col("SCHSummary.LOWER_LEVEL_UNFUNDED_TOTAL"), F.lit(0))
                + F.coalesce(F.col("SCHSummary.UPPER_LEVEL_UNFUNDED_TOTAL"), F.lit(0))
            )
            / F.lit(15)
        )
    ),
)

df_ftse = df_ftse.withColumn(
    "DOCTORAL_FTSE",
    F.when(
        (
            (F.col("SCHSummary.CB_Reported_Course") == F.lit("Y"))
            & (F.col("SCHSummary.CB_Reported_Student") == F.lit("Y"))
        ),
        (F.col("SCHSummary.DOCTORAL_LEVEL_FUNDED") / F.lit(9)),
    ).otherwise((F.col("SCHSummary.DOCTORAL_LEVEL_UNFUNDED") / F.lit(9))),
)

df_ftse = df_ftse.withColumn(
    "MASTER_FTSE",
    F.when(
        (
            (F.col("SCHSummary.CB_Reported_Course") == F.lit("Y"))
            & (F.col("SCHSummary.CB_Reported_Student") == F.lit("Y"))
        ),
        (F.col("SCHSummary.MASTER_LEVEL_FUNDED") / F.lit(12)),
    ).otherwise((F.col("SCHSummary.MASTER_LEVEL_UNFUNDED") / F.lit(12))),
)

df_ftse = df_ftse.withColumn(
    "STATE_FUNDED_FTSE",
    (
        (
            F.coalesce(
                (
                    (
                        F.coalesce(F.col("SCHSummary.LOWER_LEVEL_FUNDED"), F.lit(0))
                        + F.coalesce(F.col("SCHSummary.UPPER_LEVEL_FUNDED"), F.lit(0))
                    )
                    / F.lit(15)
                ),
                F.lit(0),
            )
            + F.coalesce(
                (F.col("SCHSummary.MASTER_LEVEL_FUNDED") / F.lit(12)), F.lit(0)
            )
        )
        + F.coalesce((F.col("SCHSummary.DOCTORAL_LEVEL_FUNDED") / F.lit(9)), F.lit(0))
    ),
)

# COMMAND ----------

df_ftse = df_ftse.withColumn(
    "UNFUNDED_FTSE",
    F.when(
        (
            (
                (
                    F.col("SCHSummary.COURSE_LEVEL").isNotNull()
                    & (F.col("SCHSummary.COURSE_LEVEL") != F.lit(""))
                )
                & F.col("SCHSummary.COURSE_LEVEL").isin(["1", "2", "3", "4"])
            )
            | (
                (
                    F.col("SCHSummary.COURSE_LEVEL").isNull()
                    | (F.col("SCHSummary.COURSE_LEVEL") == F.lit(""))
                )
                & F.substring(F.col("SCHSummary.CATALOG_NBR"), 1, 1).isin(
                    ["1", "2", "3", "4"]
                )
            )
        ),
        (F.col("SCHSummary.UNFUNDED_SCH_TOTAL") / F.lit(15)),
    ).otherwise(
        F.when(
            (
                (
                    (
                        F.col("SCHSummary.COURSE_LEVEL").isNotNull()
                        & (F.col("SCHSummary.COURSE_LEVEL") != F.lit(""))
                    )
                    & (F.col("SCHSummary.COURSE_LEVEL") == F.lit("5"))
                )
                | (
                    (
                        F.col("SCHSummary.COURSE_LEVEL").isNull()
                        | (F.col("SCHSummary.COURSE_LEVEL") == F.lit(""))
                    )
                    & (F.substring(F.col("SCHSummary.CATALOG_NBR"), 1, 1) == F.lit("5"))
                )
            ),
            (F.col("SCHSummary.UNFUNDED_SCH_TOTAL") / F.lit(12)),
        ).otherwise(
            F.when(
                (
                    (
                        (
                            F.col("SCHSummary.COURSE_LEVEL").isNotNull()
                            & (F.col("SCHSummary.COURSE_LEVEL") != F.lit(""))
                        )
                        & (F.col("SCHSummary.COURSE_LEVEL") == F.lit("6"))
                    )
                    | (
                        (
                            F.col("SCHSummary.COURSE_LEVEL").isNull()
                            | (F.col("SCHSummary.COURSE_LEVEL") == F.lit(""))
                        )
                        & (
                            F.substring(F.col("SCHSummary.CATALOG_NBR"), 1, 1)
                            == F.lit("6")
                        )
                    )
                ),
                (F.col("SCHSummary.UNFUNDED_SCH_TOTAL") / F.lit(9)),
            ).otherwise(F.lit(0))
        )
    ),
)

# COMMAND ----------

df_ftse = df_ftse.withColumn(
    "TOTAL_FTSE",
    (
        (
            (
                F.coalesce(
                    (
                        (
                            F.coalesce(F.col("SCHSummary.LOWER_LEVEL_FUNDED"), F.lit(0))
                            + F.coalesce(
                                F.col("SCHSummary.UPPER_LEVEL_FUNDED"), F.lit(0)
                            )
                        )
                        / F.lit(15)
                    ),
                    F.lit(0),
                )
                + F.coalesce(
                    (F.col("SCHSummary.MASTER_LEVEL_FUNDED") / F.lit(12)), F.lit(0)
                )
            )
            + F.coalesce(
                (F.col("SCHSummary.DOCTORAL_LEVEL_FUNDED") / F.lit(9)), F.lit(0)
            )
        )
        + F.coalesce(
            F.when(
                (
                    (
                        (
                            F.col("SCHSummary.COURSE_LEVEL").isNotNull()
                            & (F.col("SCHSummary.COURSE_LEVEL") != F.lit(""))
                        )
                        & F.col("SCHSummary.COURSE_LEVEL").isin(["1", "2", "3", "4"])
                    )
                    | (
                        (
                            F.col("SCHSummary.COURSE_LEVEL").isNull()
                            | (F.col("SCHSummary.COURSE_LEVEL") == F.lit(""))
                        )
                        & F.substring(F.col("SCHSummary.CATALOG_NBR"), 1, 1).isin(
                            ["1", "2", "3", "4"]
                        )
                    )
                ),
                (F.col("SCHSummary.UNFUNDED_SCH_TOTAL") / F.lit(15)),
            ).otherwise(
                F.when(
                    (
                        (
                            (
                                F.col("SCHSummary.COURSE_LEVEL").isNotNull()
                                & (F.col("SCHSummary.COURSE_LEVEL") != F.lit(""))
                            )
                            & (F.col("SCHSummary.COURSE_LEVEL") == F.lit("5"))
                        )
                        | (
                            (
                                F.col("SCHSummary.COURSE_LEVEL").isNull()
                                | (F.col("SCHSummary.COURSE_LEVEL") == F.lit(""))
                            )
                            & (
                                F.substring(F.col("SCHSummary.CATALOG_NBR"), 1, 1)
                                == F.lit("5")
                            )
                        )
                    ),
                    (F.col("SCHSummary.UNFUNDED_SCH_TOTAL") / F.lit(12)),
                ).otherwise(
                    F.when(
                        (
                            (
                                (
                                    F.col("SCHSummary.COURSE_LEVEL").isNotNull()
                                    & (F.col("SCHSummary.COURSE_LEVEL") != F.lit(""))
                                )
                                & (F.col("SCHSummary.COURSE_LEVEL") == F.lit("6"))
                            )
                            | (
                                (
                                    F.col("SCHSummary.COURSE_LEVEL").isNull()
                                    | (F.col("SCHSummary.COURSE_LEVEL") == F.lit(""))
                                )
                                & (
                                    F.substring(F.col("SCHSummary.CATALOG_NBR"), 1, 1)
                                    == F.lit("6")
                                )
                            )
                        ),
                        (F.col("SCHSummary.UNFUNDED_SCH_TOTAL") / F.lit(9)),
                    ).otherwise(F.lit(0))
                )
            ),
            F.lit(0),
        )
    ),
)

# COMMAND ----------

df_ftse = df_ftse.select(
    F.col("SCHSummary.STRM"),
    F.col("SCHSummary.TermDescription"),
    F.col("SCHSummary.SUBJECT"),
    F.col("SCHSummary.CATALOG_NBR"),
    F.col("SCHSummary.CLASS_NBR"),
    F.col("SCHSummary.ACAD_GROUP"),
    F.col("SCHSummary.COLLEGE_DESCR"),
    F.col("SCHSummary.ACAD_ORG"),
    F.col("SCHSummary.DEPT_DESCR"),
    F.col("SCHSummary.Instruction_Type"),
    F.col("SCHSummary.CORE_COURSE"),
    F.col("SCHSummary.AP_Course"),
    F.col("SCHSummary.DLRN_Course"),
    F.col("SCHSummary.Flex_entry"),
    F.col("SCHSummary.CIP_OR_FUND_CODE"),
    F.col("SCHSummary.COURSE_SCH"),
    F.col("SCHSummary.COURSE_LEVEL"),
    F.col("SCHSummary.FUND_YEAR"),
    F.col("SCHSummary.FORMULA_CODE"),
    F.col("SCHSummary.UNFUNDED_SCH_TOTAL"),
    F.col("SCHSummary.LOWER_LEVEL_EXCEED_STATE"),
    F.col("SCHSummary.LOWER_LEVEL_EXCEED_DEVELOP"),
    F.col("SCHSummary.NOT_STATE_FUNDED_LOWER"),
    F.col("SCHSummary.NOT_STATE_FUNDED_UPPER"),
    F.col("SCHSummary.LOWER_LEVEL_UNFUNDED_TOTAL"),
    F.col("SCHSummary.LOWER_LEVEL_FUNDED"),
    F.col("SCHSummary.LOWER_LEVEL_TOTAL"),
    F.col("SCHSummary.UPPER_LEVEL_EXCEED_STATE"),
    F.col("SCHSummary.UPPER_LEVEL_EXCEED_DEVELOP"),
    F.col("SCHSummary.UPPER_LEVEL_UNFUNDED_TOTAL"),
    F.col("SCHSummary.UPPER_LEVEL_FUNDED"),
    F.col("SCHSummary.UPPER_LEVEL_TOTAL"),
    F.col("SCHSummary.MASTER_LEVEL_UNFUNDED"),
    F.col("SCHSummary.MASTER_LEVEL_FUNDED"),
    F.col("SCHSummary.MASTER_LEVEL_TOTAL"),
    F.col("SCHSummary.DOCTORAL_LEVEL_UNFUNDED"),
    F.col("SCHSummary.DOCTORAL_LEVEL_FUNDED"),
    F.col("SCHSummary.DOCTORAL_LEVEL_TOTAL"),
    F.col("SCHSummary.Total_SCH"),
    F.col("SCHSummary.Student_Count"),
    F.col("SCHSummary.CB_Reported_Course"),
    F.col("SCHSummary.CB_Reported_Student"),
    F.col("UGRD_HRS"),
    F.col("UGRD_LOWER_FTSE"),
    F.col("UGRD_UPPER_FTSE"),
    F.col("UGRD_FTSE"),
    F.col("DOCTORAL_FTSE"),
    F.col("MASTER_FTSE"),
    F.col("STATE_FUNDED_FTSE"),
    F.col("UNFUNDED_FTSE"),
    F.col("TOTAL_FTSE"),
    F.col("SCHSummary.CENSUS_DT"),
)

# COMMAND ----------

# Step: WSCH
# WSCH
df_wsch = df_ftse.alias("FTSE")

df_wsch = df_wsch.join(
    uta_cb_formula_funding,
    on=(
        (F.col("FTSE.FUND_YEAR") == F.col("UTA_CB_FORMULA_FUNDING.FUND_YEAR"))
        & (F.col("FTSE.FORMULA_CODE") == F.col("UTA_CB_FORMULA_FUNDING.FORMULA_CODE"))
    ),
    how="left",
)

df_wsch = df_wsch.withColumn(
    "UGRD_LOWER_DIV_WT_HRS_NEW",
    (
        F.when(
            (
                (F.col("FTSE.CB_Reported_Course").substr(1, 1) == F.lit("Y"))
                & (F.col("FTSE.CB_Reported_Student").substr(1, 1) == F.lit("Y"))
            ),
            F.when(F.col("FTSE.LOWER_LEVEL_FUNDED").isNull(), F.lit(None)).otherwise(
                F.col("FTSE.LOWER_LEVEL_FUNDED").cast("decimal(38,2)")
            ),
        ).otherwise(
            F.when(
                F.col("FTSE.LOWER_LEVEL_UNFUNDED_TOTAL").isNull(), F.lit(None)
            ).otherwise(F.col("FTSE.LOWER_LEVEL_UNFUNDED_TOTAL").cast("decimal(38,2)"))
        )
        * F.col("UTA_CB_FORMULA_FUNDING.LOWER_DIVISION")
    ).cast("decimal(38,2)"),
)

df_wsch = df_wsch.withColumn(
    "UGRD_UPPER_DIV_WT_HRS_NEW",
    (
        F.when(
            (
                (F.col("FTSE.CB_Reported_Course").substr(1, 1) == F.lit("Y"))
                & (F.col("FTSE.CB_Reported_Student").substr(1, 1) == F.lit("Y"))
            ),
            F.when(F.col("FTSE.UPPER_LEVEL_FUNDED").isNull(), F.lit(None)).otherwise(
                F.col("FTSE.UPPER_LEVEL_FUNDED").cast("decimal(38,2)")
            ),
        ).otherwise(
            F.when(
                F.col("FTSE.UPPER_LEVEL_UNFUNDED_TOTAL").isNull(), F.lit(None)
            ).otherwise(F.col("FTSE.UPPER_LEVEL_UNFUNDED_TOTAL").cast("decimal(38,2)"))
        )
        * F.col("UTA_CB_FORMULA_FUNDING.UPPER_DIVISION")
    ).cast("decimal(38,2)"),
)

df_wsch = df_wsch.withColumn(
    "UGRD_WT_HRS_NEW",
    (
        (
            F.when(
                (
                    (F.col("FTSE.CB_Reported_Course").substr(1, 1) == F.lit("Y"))
                    & (F.col("FTSE.CB_Reported_Student").substr(1, 1) == F.lit("Y"))
                ),
                F.when(
                    F.col("FTSE.LOWER_LEVEL_FUNDED").isNull(), F.lit(None)
                ).otherwise(F.col("FTSE.LOWER_LEVEL_FUNDED").cast("decimal(38,2)")),
            ).otherwise(
                F.when(
                    F.col("FTSE.LOWER_LEVEL_UNFUNDED_TOTAL").isNull(), F.lit(None)
                ).otherwise(
                    F.col("FTSE.LOWER_LEVEL_UNFUNDED_TOTAL").cast("decimal(38,2)")
                )
            )
            * F.col("UTA_CB_FORMULA_FUNDING.LOWER_DIVISION")
        )
        + (
            F.when(
                (
                    (F.col("FTSE.CB_Reported_Course").substr(1, 1) == F.lit("Y"))
                    & (F.col("FTSE.CB_Reported_Student").substr(1, 1) == F.lit("Y"))
                ),
                F.when(
                    F.col("FTSE.UPPER_LEVEL_FUNDED").isNull(), F.lit(None)
                ).otherwise(F.col("FTSE.UPPER_LEVEL_FUNDED").cast("decimal(38,2)")),
            ).otherwise(
                F.when(
                    F.col("FTSE.UPPER_LEVEL_UNFUNDED_TOTAL").isNull(), F.lit(None)
                ).otherwise(
                    F.col("FTSE.UPPER_LEVEL_UNFUNDED_TOTAL").cast("decimal(38,2)")
                )
            )
            * F.col("UTA_CB_FORMULA_FUNDING.UPPER_DIVISION")
        )
    ).cast("decimal(38,2)"),
)

# COMMAND ----------

df_wsch = df_wsch.withColumn(
    "MASTER_WT_HRS_NEW",
    (
        F.when(
            (
                (F.col("FTSE.CB_Reported_Course").substr(1, 1) == F.lit("Y"))
                & (F.col("FTSE.CB_Reported_Student").substr(1, 1) == F.lit("Y"))
            ),
            F.when(F.col("FTSE.MASTER_LEVEL_FUNDED").isNull(), F.lit(None)).otherwise(
                F.col("FTSE.MASTER_LEVEL_FUNDED").cast("decimal(38,2)")
            ),
        ).otherwise(
            F.when(F.col("FTSE.MASTER_LEVEL_UNFUNDED").isNull(), F.lit(None)).otherwise(
                F.col("FTSE.MASTER_LEVEL_UNFUNDED").cast("decimal(38,2)")
            )
        )
        * F.col("UTA_CB_FORMULA_FUNDING.MASTERS")
    ).cast("decimal(38,2)"),
)

df_wsch = df_wsch.withColumn(
    "DOCTORAL_WT_HRS_NEW",
    (
        F.when(
            (
                (F.col("FTSE.CB_Reported_Course").substr(1, 1) == F.lit("Y"))
                & (F.col("FTSE.CB_Reported_Student").substr(1, 1) == F.lit("Y"))
            ),
            F.when(F.col("FTSE.DOCTORAL_LEVEL_FUNDED").isNull(), F.lit(None)).otherwise(
                F.col("FTSE.DOCTORAL_LEVEL_FUNDED").cast("decimal(38,2)")
            ),
        ).otherwise(
            F.when(
                F.col("FTSE.DOCTORAL_LEVEL_UNFUNDED").isNull(), F.lit(None)
            ).otherwise(F.col("FTSE.DOCTORAL_LEVEL_UNFUNDED").cast("decimal(38,2)"))
        )
        * F.col("UTA_CB_FORMULA_FUNDING.DOCTORAL")
    ).cast("decimal(38,2)"),
)

df_wsch = df_wsch.withColumn(
    "STATE_FUNDED_WT_HRS_NEW",
    (
        (
            F.col("FTSE.LOWER_LEVEL_FUNDED").cast("decimal(38,2)")
            * F.col("UTA_CB_FORMULA_FUNDING.LOWER_DIVISION")
        )
        + (
            F.col("FTSE.UPPER_LEVEL_FUNDED").cast("decimal(38,2)")
            * F.col("UTA_CB_FORMULA_FUNDING.UPPER_DIVISION")
        )
        + (
            F.col("FTSE.MASTER_LEVEL_FUNDED").cast("decimal(38,2)")
            * F.col("UTA_CB_FORMULA_FUNDING.MASTERS")
        )
        + (
            F.col("FTSE.DOCTORAL_LEVEL_FUNDED").cast("decimal(38,2)")
            * F.col("UTA_CB_FORMULA_FUNDING.DOCTORAL")
        )
    ).cast("decimal(38,2)"),
)

# COMMAND ----------

df_wsch = df_wsch.select(
    F.col("FTSE.STRM").substr(1, 4).alias("STRM"),
    F.col("FTSE.TermDescription").substr(1, 30).alias("TermDescription"),
    F.col("FTSE.SUBJECT").substr(1, 7).alias("SUBJECT"),
    F.col("FTSE.CATALOG_NBR").substr(1, 7).alias("CATALOG_NBR"),
    F.col("FTSE.CLASS_NBR").substr(1, 7).alias("CLASS_NBR"),
    F.col("FTSE.ACAD_GROUP").substr(1, 5).alias("ACAD_GROUP"),
    F.col("FTSE.COLLEGE_DESCR").substr(1, 30).alias("COLLEGE_DESCR"),
    F.col("FTSE.ACAD_ORG").substr(1, 10).alias("ACAD_ORG"),
    F.col("FTSE.DEPT_DESCR").substr(1, 30).alias("DEPT_DESCR"),
    F.col("FTSE.Instruction_Type").substr(1, 1).alias("Instruction_Type"),
    F.col("FTSE.CORE_COURSE").substr(1, 8).alias("CORE_COURSE"),
    F.col("FTSE.AP_Course").substr(1, 1).alias("AP_Course"),
    F.col("FTSE.DLRN_Course").substr(1, 1).alias("DLRN_Course"),
    F.col("FTSE.Flex_entry").substr(1, 1).alias("Flex_entry"),
    F.col("FTSE.CIP_OR_FUND_CODE").substr(1, 10).alias("CIP_OR_FUND_CODE"),
    F.col("FTSE.COURSE_SCH").substr(1, 40).alias("COURSE_SCH"),
    F.col("FTSE.COURSE_LEVEL").substr(1, 40).alias("COURSE_LEVEL"),
    F.col("FTSE.FUND_YEAR").substr(1, 9).alias("FUND_YEAR"),
    F.col("FTSE.CB_Reported_Course").substr(1, 1).alias("CB_Reported_Course"),
    F.col("FTSE.CB_Reported_Student").substr(1, 1).alias("CB_Reported_Student"),
    F.col("FTSE.FORMULA_CODE").cast("decimal(4,0)").alias("FORMULA_CODE"),
    F.col("FTSE.UNFUNDED_SCH_TOTAL").cast("bigint").alias("UNFUNDED_SCH_TOTAL"),
    F.col("FTSE.LOWER_LEVEL_EXCEED_STATE")
    .cast("bigint")
    .alias("LOWER_LEVEL_EXCEED_STATE"),
    F.col("FTSE.LOWER_LEVEL_EXCEED_DEVELOP")
    .cast("bigint")
    .alias("LOWER_LEVEL_EXCEED_DEVELOP"),
    F.col("FTSE.NOT_STATE_FUNDED_LOWER").cast("bigint").alias("NOT_STATE_FUNDED_LOWER"),
    F.col("FTSE.NOT_STATE_FUNDED_UPPER").cast("bigint").alias("NOT_STATE_FUNDED_UPPER"),
    F.col("FTSE.LOWER_LEVEL_UNFUNDED_TOTAL")
    .cast("bigint")
    .alias("LOWER_LEVEL_UNFUNDED_TOTAL"),
    F.col("FTSE.LOWER_LEVEL_FUNDED").cast("bigint").alias("LOWER_LEVEL_FUNDED"),
    F.col("FTSE.LOWER_LEVEL_TOTAL").cast("bigint").alias("LOWER_LEVEL_TOTAL"),
    F.col("FTSE.UPPER_LEVEL_EXCEED_STATE")
    .cast("bigint")
    .alias("UPPER_LEVEL_EXCEED_STATE"),
    F.col("FTSE.UPPER_LEVEL_EXCEED_DEVELOP")
    .cast("bigint")
    .alias("UPPER_LEVEL_EXCEED_DEVELOP"),
    F.col("FTSE.UPPER_LEVEL_UNFUNDED_TOTAL")
    .cast("bigint")
    .alias("UPPER_LEVEL_UNFUNDED_TOTAL"),
    F.col("FTSE.UPPER_LEVEL_FUNDED").cast("bigint").alias("UPPER_LEVEL_FUNDED"),
    F.col("FTSE.UPPER_LEVEL_TOTAL").cast("bigint").alias("UPPER_LEVEL_TOTAL"),
    F.col("FTSE.MASTER_LEVEL_UNFUNDED").cast("bigint").alias("MASTER_LEVEL_UNFUNDED"),
    F.col("FTSE.MASTER_LEVEL_FUNDED").cast("bigint").alias("MASTER_LEVEL_FUNDED"),
    F.col("FTSE.MASTER_LEVEL_TOTAL").cast("bigint").alias("MASTER_LEVEL_TOTAL"),
    F.col("FTSE.DOCTORAL_LEVEL_UNFUNDED")
    .cast("bigint")
    .alias("DOCTORAL_LEVEL_UNFUNDED"),
    F.col("FTSE.DOCTORAL_LEVEL_FUNDED").cast("bigint").alias("DOCTORAL_LEVEL_FUNDED"),
    F.col("FTSE.DOCTORAL_LEVEL_TOTAL").cast("bigint").alias("DOCTORAL_LEVEL_TOTAL"),
    F.col("FTSE.Total_SCH").cast("bigint").alias("Total_SCH"),
    F.col("FTSE.Student_Count").cast("bigint").alias("Student_Count"),
    F.col("FTSE.UGRD_HRS").cast("bigint").alias("UGRD_HRS"),
    F.col("FTSE.CENSUS_DT").cast("date").alias("CENSUS_DT"),
    F.col("FTSE.UGRD_LOWER_FTSE").cast("decimal(38,10)").alias("UGRD_LOWER_FTSE"),
    F.col("FTSE.UGRD_UPPER_FTSE").cast("decimal(38,10)").alias("UGRD_UPPER_FTSE"),
    F.col("FTSE.UGRD_FTSE").cast("decimal(38,10)").alias("UGRD_FTSE"),
    F.col("FTSE.DOCTORAL_FTSE").cast("decimal(38,10)").alias("DOCTORAL_FTSE"),
    F.col("FTSE.MASTER_FTSE").cast("decimal(38,10)").alias("MASTER_FTSE"),
    F.col("FTSE.STATE_FUNDED_FTSE").cast("decimal(38,10)").alias("STATE_FUNDED_FTSE"),
    F.col("FTSE.UNFUNDED_FTSE").cast("decimal(38,10)").alias("UNFUNDED_FTSE"),
    F.col("FTSE.TOTAL_FTSE").cast("decimal(38,10)").alias("TOTAL_FTSE"),
    F.col("UGRD_LOWER_DIV_WT_HRS_NEW")
    .cast("decimal(38,2)")
    .alias("UGRD_LOWER_DIV_WT_HRS"),
    F.col("UGRD_UPPER_DIV_WT_HRS_NEW")
    .cast("decimal(38,2)")
    .alias("UGRD_UPPER_DIV_WT_HRS"),
    F.col("UGRD_WT_HRS_NEW").cast("decimal(38,2)").alias("UGRD_WT_HRS"),
    F.col("MASTER_WT_HRS_NEW").cast("decimal(38,2)").alias("MASTER_WT_HRS"),
    F.col("DOCTORAL_WT_HRS_NEW").cast("decimal(38,2)").alias("DOCTORAL_WT_HRS"),
    F.col("STATE_FUNDED_WT_HRS_NEW").cast("decimal(38,2)").alias("STATE_FUNDED_WT_HRS"),
)

# COMMAND ----------

# Step 45: Write fact_thecb_cbm00s_sch_work
# Output: fact_thecb_cbm00s_sch_work → analytics.staging
write_df_to_table(
    df_wsch,
    f"{analytics}.{staging}.fact_thecb_cbm00s_sch_work",
    mode="overwrite",
    overwriteSchema="true",
)

log_msg(f"fact_thecb_cbm00s_sch_work written — row count: {get_count(df_wsch)}")

# COMMAND ----------

# Drop checkpoint temp tables now that the final write is complete
for _tmp_tbl in (
    _tmp_stageA_tbl,
    _tmp_stageB_tbl,
    _tmp_stageC_tbl,
    _tmp_stageD_tbl,
    _tmp_stageE_tbl,
):
    try:
        drop_table(_tmp_tbl)
        log_msg(f"Dropped checkpoint temp table: {_tmp_tbl}")
    except Exception as _e:
        log_msg(f"WARN: could not drop {_tmp_tbl}: {_e}")

# COMMAND ----------

log_msg(f"fact_thecb_cbm00s_sch_work written — row count: {get_count(df_wsch)}")

_job_end_time = datetime.now()
_job_elapsed = _job_end_time - _job_start_time
log_msg(
    f"Job completed: transform_analytics_fact_thecb_cbm00s | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} | Elapsed: {str(_job_elapsed)}",
    "info",
)
