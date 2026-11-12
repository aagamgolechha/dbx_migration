# Databricks notebook source
# MAGIC %md
# MAGIC # 400_LOAD_CBM008 --> transform_analytics_fact_thecb_cbm008
# MAGIC
# MAGIC **Purpose:** Build the THECB CBM008 faculty/instructor report — one record per instructor per class section per term — with rank, tenure, salary, FTE, ethnicity, citizenship, full-time flag, teaching load credit and responsibility factor, written to the analytics work table that feeds the state fixed-width file.
# MAGIC
# MAGIC **Parameters:** `current_term` (default 2262), `prior_term` (default 2258)
# MAGIC
# MAGIC **Pipeline Flow (98 steps across 153 cells):**
# MAGIC
# MAGIC | Phase | Steps | Description |
# MAGIC |-------|-------|-------------|
# MAGIC | **Term Setup** | 1–3 | Import libraries, set ANSI off, build CBM008_Term/TermDimension_Manual from ADW_TERM_DIM, derive UNIQ_STRM and USER_INPUT_STRM (filters to current_term with APPT_BEGIN/END dates and STRM_PREV) |
# MAGIC | **Class-Instructor Read** | 4 | Join PS_CLASS_INSTR to USER_INPUT_STRM on current + prior term; exclude EXC/NON assign types |
# MAGIC | **HRA/HRE History** | 5–7 | HRA_FISCAL_YEAR (title_cd < 0115), HRE_UNIQ_SSN (distinct SSNs), CHECK_ID_CHANGE (prior SSN lookup) |
# MAGIC | **HRE Processing & Title Decode** | 8–9 | PROCESS_HRE_FILE (overlap days, days-in-appt, salary splits A/D/X/R/Z), READ_HRA_TITLE_CD (HRA title/position/group for instructor) |
# MAGIC | **EMPLID Resolution** | 10–15 | PERS_NID lookup, UNIQ_NATL_ID_MAX_ASOF, EXT_SYS HRS lookup, GET_A_CRSE_ID, MISSING_HRS_ID, FOUND_HRS_ID — resolves SSN → EMPLID via multiple systems |
# MAGIC | **HRE Name & Title** | 16–17 | READ_HRE_2 (second HRE read for non-instructor records), DECODE_TITLE_CODE_INSTR (nested IFC for instructor classification + faculty rank) |
# MAGIC | **Missing HRE + Names** | 18–24 | MISSING_HRE_SSN handling, NAMES_MAX_EFFDT, NAMES_HRS_PRI_PRF, GET_NAMES, GET_DOB, PERS_DATA_MAX_EFFDT, GET_GENDER |
# MAGIC | **HRE SSN + HRA Title** | 25–26 | FOUND_HRE_SSN (union found/missing), READ_HRA_TITLE_INSTR (HRA appt/salary/position join) |
# MAGIC | **Acct-Code & Fund-Code** | 27–29 | UTA_DEPTBDGT_ER_MAX_EFFSEQ, READ_4_ACCT_CD, READ_4_FUND_CD_FUNCTION — derive account and fund codes for salary classification |
# MAGIC | **EMPLID Validation** | 30–35 | LOOKUP_EMPLID, NAMES_MAX_EFFDT, EMPLID_IN_NAMES_CHECK, HR_PS_EMP_MAX_ACTION, LOOKUP_EMPLID_EXTERNAL_SYS (HRS + CB) |
# MAGIC | **Salary Computation** | 36–39 | HRA_BEGIN_AND_END_DT, DAYS_IN_APPT, OVLP_REDIS (overlap redistribution), SALARY_AND_PCT_TIME (percent-time A/C/D/E, salary by fund type) |
# MAGIC | **Additional Pay & Job** | 40–47 | READ_4_ADDL_PAY, JOB_MAX_EFFDT/EFFSEQ, READ_4_JOB_ACCT_CD, ADDL_READ_4_ACCT_CD/FUND_CD, ADDL_OVLP_ALLOC_REDIS, ADDL_SALARY |
# MAGIC | **Faculty Member Build** | 48–51 | FACULTY_MEMBER (union main + addl salary), DECODE_TITLE_CODE_1 (instructor/faculty classif), READ_HRA_MAJOR_APPT, DECODE_TITLE_CODE_2 (rank from major title) |
# MAGIC | **Tenure & Org Validation** | 52–60 | UTA_TENURE_MAX_ORG, POSITION_DATA_MAX_EFFDT, READ_TENURE_RECORD (3-way join), ACAD_ORG_MAX_EFFDT, VALIDATE_ORG, FOUND/MISSING_ACAD_ORG, GET_A_CRSEID, READ_4_PRIMARY_APPT |
# MAGIC | **Ethnicity & Citizenship** | 61–69 | ETHNIC_GRP_MAX_EFFDT, CALC_ETHN_GRP, GET_ETHNIC_INFO, CITIZENSHIP_COUNTRY, CHECK_CITIZENSHIP, VISA_PMT_MAX_EFFDT, IDS_W_GOOD_PERMIT_TYPES, CHECK_VISA_TYPE, INTERNATIONAL_CALC |
# MAGIC | **Percent & Salary Calc** | 70–72 | PERCENT_CALC (01/02/11/12/13 appointment buckets), AGG_SALARY (state/designated/restricted/aux/overload), SALARY_CALC (format + zero-fill) |
# MAGIC | **Compliance & Hire** | 73–75 | FACULTY_COMPLIANCE , NEW_HIRE_CALC (archive + HRA prior year check), CALC_SEM_YEAR (semester/year decode from STRM) |
# MAGIC | **STRM & Class Joins** | 76–82 | STRM_PREV_CALC, INSTR_MIN_MTG_NBR, CLASS_WITH_INSTR, Distinct Combined Sections, READ_4_CLASSES, LOOKUP_COMBINED_WRKLD, SCTN_COMBND_TEACH_LD_CRED |
# MAGIC | **Filtering & Enrollment** | 83–87 | FLEX_ENTRY_CALC, CHECK_CB_EXCLUDE, NON_DLRN_STDNTS, CLASSES_WITH_STDNTS, CHECK_STDNT_ENROLL |
# MAGIC | **Final Assembly** | 88–97 | FORMAT_HRE_NAME_UL, FORMAT_CBM008, CRSE_ID_CHECK, UNIT_CD_APPT, ADMIN_UNIT_CD (CASE map 40+ unit codes), DEPT_CUR_RECORDS, MAX_COL_EFFDT, ADDL_FIELDS (person dim join), FULL_TIME_FLG |
# MAGIC | **Output** | 98 | Write final DataFrame to `fact_thecb_cbm008_work` (overwrite) |
# MAGIC
# MAGIC **Source Tables:** ADW_TERM_DIM, PS_CLASS_INSTR, PS_UTA_HRA_TBL, PS_UTA_HRE_TBL, PS_PERS_NID, PS_NAMES, PS_HCR_ETHNIC_GRP_I, PS_HCR_DIV_ETHNIC_I, PS_CITIZENSHIP, PS_VISA_PMT_DATA, PS_CLASS_TBL, PS_CLASS_ATTRIBUTE, PS_STDNT_ENRL, PS_SCTN_CMBND, PS_INSTR_TERM_DTL, PS_UTA_HRA_ARCHIVE, PS_POSITION_DATA, PS_UTA_TT_TENURE, PS_ACAD_ORG_TBL, PS_UTZ_PT100_DTL, PS_UTA_HR_ACCTCDCA, PS_UTA_DEPTBDGT_ER, ADW_CBM_DLRNORPT, ADW_PERSON_DIM, ADW_DEPT_DIM
# MAGIC
# MAGIC **Target Table:** `fact_thecb_cbm008_work`

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

# Step 1: Import PySpark SQL functions, types, and Window utilities
from pyspark.sql import functions as F
from pyspark.sql.types import *
from pyspark.sql import Window

# SAS-equivalent cast semantics: SAS INPUT(<str>, BESTn.) returns missing (.)
# for non-numeric/blank input. ANSI-off makes Spark's failed casts return NULL,
# matching SAS missing semantics exactly. See LP10.
spark.conf.set("spark.sql.ansi.enabled", False)


# Helper function to log view/table name and count
# OPTIMIZATION: count() triggers a full Spark action (evaluates entire upstream DAG).
# Default do_count=False skips the expensive count for intermediate steps;
# pass do_count=True only at checkpoints / final output where we need the count.
def log_view_count(view_name, df, do_count=False):
    if do_count:
        count = df.count()
        print(f"View: {view_name}, Count: {count}")
        return count
    else:
        print(f"View: {view_name} (lazy — count skipped)")
        return -1


_job_start_time = datetime.now()
log_msg(
    f"Job started: transform_analytics_fact_thecb_cbm008 | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)


# /* Parameter default value(s) for 400_LOAD_CBM008 */
# Define input parameters for the notebook
dbutils.widgets.text("current_term", "2262", "Current Term")
dbutils.widgets.text("prior_term", "2258", "Prior Term")

# Get parameter values
current_term = dbutils.widgets.get("current_term")
prior_term = dbutils.widgets.get("prior_term")

# COMMAND ----------

# Step 1b: CBM008_Term + CBM008_TermDimension_Manual
# Source: SAS PROC SQL creates work.CBM008_Term (UNION ALL of current_term and prior_term rows
# from ADW_TERM_DIM with a computed Current_Term) and work.CBM008_TermDimension_Manual (adds
# Current_Term_End_Date via MAX(TERM_END_DT) over ACAD_CAREER). Required by Step 73 join.
# This block was missing from Final_converted — restored from auto_converted lines 84-141.

df_cbm008_term_part0 = read_table(f"{analytics}.{silver}.dim_thecb_term").alias(
    "ADW_TERM_DIM"
)
df_cbm008_term_part0 = df_cbm008_term_part0.filter(
    (
        (F.col("adw_term_dim.STRM") == F.lit(current_term))
        & (F.col("adw_term_dim.ACAD_CAREER") == F.lit("UGRD"))
    )
)
df_cbm008_term_part0 = df_cbm008_term_part0.select(
    F.col("adw_term_dim.STRM"),
    F.col("adw_term_dim.ACAD_CAREER"),
    F.col("adw_term_dim.TERM_BEGIN_DT"),
    F.col("adw_term_dim.TERM_END_DT"),
    # F.col("adw_term_dim.TERM_SK"),
    F.col("adw_term_dim.CENSUS_DT"),
    F.col("adw_term_dim.STRM").alias("Current_Term"),
)

df_cbm008_term_part1 = read_table(f"{analytics}.{silver}.dim_thecb_term").alias(
    "ADW_TERM_DIM"
)
df_cbm008_term_part1 = df_cbm008_term_part1.filter(
    (
        (F.col("adw_term_dim.ACAD_CAREER") == F.lit("UGRD"))
        & (F.col("adw_term_dim.STRM") == F.lit(prior_term))
        & (
            F.current_timestamp().cast("DATE")
            > F.col("adw_term_dim.TERM_END_DT").cast("DATE")
        )
    )
)
df_cbm008_term_part1 = df_cbm008_term_part1.withColumn(
    "_agg_tmp_0",
    F.max(F.col("adw_term_dim.STRM")).over(
        Window.partitionBy("adw_term_dim.ACAD_CAREER")
    ),
)
df_cbm008_term_part1 = df_cbm008_term_part1.filter(
    (F.col("adw_term_dim.STRM") == F.col("_agg_tmp_0"))
)
df_cbm008_term_part1 = df_cbm008_term_part1.drop("_agg_tmp_0")
df_cbm008_term_part1 = df_cbm008_term_part1.select(
    F.col("adw_term_dim.STRM"),
    F.col("adw_term_dim.ACAD_CAREER"),
    F.col("adw_term_dim.TERM_BEGIN_DT"),
    F.col("adw_term_dim.TERM_END_DT"),
    # F.col("adw_term_dim.TERM_SK"),
    F.col("adw_term_dim.CENSUS_DT"),
    F.when(
        (F.substring(F.col("adw_term_dim.STRM"), 4, 1) == F.lit("8")),
        (F.col("adw_term_dim.STRM").cast("BIGINT") + F.lit(4)).cast("STRING"),
    )
    .otherwise((F.col("adw_term_dim.STRM").cast("BIGINT") + F.lit(3)).cast("STRING"))
    .alias("Current_Term"),
)
df_cbm008_term = df_cbm008_term_part0.union(df_cbm008_term_part1)

# CBM008_TermDimension_Manual = CBM008_Term + Current_Term_End_Date (MAX over ACAD_CAREER)
df_cbm008_termdimension_manual = df_cbm008_term.alias("CBM008_Term")
_winSpec_termdim = Window.partitionBy(F.col("cbm008_term.ACAD_CAREER"))
df_cbm008_termdimension_manual = df_cbm008_termdimension_manual.withColumn(
    "Current_Term_End_Date",
    F.max(F.col("cbm008_term.TERM_END_DT")).over(_winSpec_termdim),
)
df_cbm008_termdimension_manual = df_cbm008_termdimension_manual.select(
    F.col("cbm008_term.STRM"),
    F.col("cbm008_term.TERM_BEGIN_DT"),
    F.col("cbm008_term.TERM_END_DT"),
    # F.col("cbm008_term.TERM_SK"),
    F.col("cbm008_term.CENSUS_DT"),
    F.col("cbm008_term.Current_Term"),
    F.col("cbm008_term.ACAD_CAREER"),
    F.col("Current_Term_End_Date"),
)


# COMMAND ----------

# Step 2: UNIQ_STRM
# Create temp view: UNIQ_STRM_CBM008
df_uniq_strm_cbm008 = read_table(f"{analytics}.{silver}.dim_thecb_term").alias(
    "ADW_TERM_DIM"
)
df_uniq_strm_cbm008 = df_uniq_strm_cbm008.select(
    F.col("adw_term_dim.STRM"),
    F.col("adw_term_dim.ACAD_YEAR"),
    (F.col("adw_term_dim.ACAD_YEAR") + F.lit(1)).alias("UTSHARE_FISCAL_YEAR"),
    F.substring(F.col("adw_term_dim.STRM"), 4, 1).alias("CBM_TERM"),
    F.col("adw_term_dim.TERM_END_DT"),
    F.col("adw_term_dim.CENSUS_DT"),
    F.col("adw_term_dim.TERM_BEGIN_DT"),
)
df_uniq_strm_cbm008 = df_uniq_strm_cbm008.distinct()
log_view_count("UNIQ_STRM_CBM008", df_uniq_strm_cbm008)

# COMMAND ----------

# Step 3: USER_INPUT_STRM
# Create temp view: USER_INPUT_STRM_CBM008
df_user_input_strm_cbm008 = df_uniq_strm_cbm008.alias("UNIQ_STRM_CBM008")
df_user_input_strm_cbm008 = df_user_input_strm_cbm008.filter(
    (F.col("uniq_strm_cbm008.STRM") == F.lit(current_term))
)
df_user_input_strm_cbm008 = df_user_input_strm_cbm008.select(
    F.col("uniq_strm_cbm008.STRM"),
    F.col("uniq_strm_cbm008.ACAD_YEAR"),
    F.col("uniq_strm_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("uniq_strm_cbm008.CBM_TERM"),
    F.when(
        (F.col("uniq_strm_cbm008.CBM_TERM") == F.lit("2")),
        F.expr(
            "CAST(CAST(uniq_strm_cbm008.UTSHARE_FISCAL_YEAR AS INT) AS STRING) || '0116'"
        ),
    )
    .when(
        (F.col("uniq_strm_cbm008.CBM_TERM") == F.lit("5")),
        F.expr(
            "CAST(CAST(uniq_strm_cbm008.UTSHARE_FISCAL_YEAR AS INT) AS STRING) || '0601'"
        ),
    )
    .when(
        (F.col("uniq_strm_cbm008.CBM_TERM") == F.lit("8")),
        F.expr("CAST(CAST(uniq_strm_cbm008.ACAD_YEAR AS INT) AS STRING) || '0901'"),
    )
    .otherwise(F.lit(""))
    .alias("APPT_BEGIN_DT"),
    F.when(
        (F.col("uniq_strm_cbm008.CBM_TERM") == F.lit("2")),
        F.expr(
            "CAST(CAST(uniq_strm_cbm008.UTSHARE_FISCAL_YEAR AS INT) AS STRING) || '0531'"
        ),
    )
    .when(
        (F.col("uniq_strm_cbm008.CBM_TERM") == F.lit("5")),
        F.expr(
            "CAST(CAST(uniq_strm_cbm008.UTSHARE_FISCAL_YEAR AS INT) AS STRING) || '0831'"
        ),
    )
    .when(
        (F.col("uniq_strm_cbm008.CBM_TERM") == F.lit("8")),
        F.expr("CAST(CAST(uniq_strm_cbm008.ACAD_YEAR + 1 AS INT) AS STRING) || '0115'"),
    )
    .otherwise(F.lit(""))
    .alias("APPT_END_DT"),
    F.col("uniq_strm_cbm008.TERM_END_DT"),
    F.col("uniq_strm_cbm008.CENSUS_DT"),
    (
        F.coalesce(
            F.col("uniq_strm_cbm008.STRM").cast("BIGINT"), F.lit(0)
        )
        - F.when(
            (F.substring(F.col("uniq_strm_cbm008.STRM"), 4, 1) == F.lit("2")),
            F.lit(4),
        ).otherwise(F.lit(3))
        - F.when(
            (F.col("uniq_strm_cbm008.STRM") == F.lit("2002")), F.lit(1000)
        ).otherwise(F.lit(0))
    )
    .cast("STRING")
    .alias("STRM_PREV"),
    F.col("uniq_strm_cbm008.TERM_BEGIN_DT"),
)
log_view_count("USER_INPUT_STRM_CBM008", df_user_input_strm_cbm008)

# COMMAND ----------

# Step 4: READ_CLASS_ISNTR_TBL
# Create temp view: CLASS_INSTR_BY_TERM
df_class_instr_by_term = read_table(f"{student}.{bronze}.PS_CLASS_INSTR").alias(
    "PS_CLASS_INSTR"
)
df_class_instr_by_term = df_class_instr_by_term.join(
    df_user_input_strm_cbm008.alias("USER_INPUT_STRM_CBM008"),
    (
        (F.col("ps_class_instr.STRM") == F.col("user_input_strm_cbm008.STRM"))
        | (
            (F.col("ps_class_instr.STRM") == F.col("user_input_strm_cbm008.STRM_PREV"))
            & (
                F.col("ps_class_instr.SESSION_CODE")
                == F.when(
                    (F.substring(F.col("ps_class_instr.STRM"), 4, 1) == F.lit("5")),
                    F.lit("5W2"),
                ).otherwise(F.lit("1"))
            )
        )
    ),
    "inner",
)
df_class_instr_by_term = df_class_instr_by_term.filter(
    (
        F.col("ps_class_instr.EMPLID").isNotNull()
        & ~F.col("ps_class_instr.ASSIGN_TYPE").isin(["EXC", "NON"])
    )
)
df_class_instr_by_term = df_class_instr_by_term.select(
    F.col("ps_class_instr.EMPLID"),
    F.col("ps_class_instr.STRM"),
    F.col("user_input_strm_cbm008.STRM").alias("IN_STRM"),
    F.col("user_input_strm_cbm008.ACAD_YEAR"),
    F.col("user_input_strm_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("user_input_strm_cbm008.CBM_TERM"),
    F.col("user_input_strm_cbm008.APPT_BEGIN_DT"),
    F.col("user_input_strm_cbm008.APPT_END_DT"),
    F.col("user_input_strm_cbm008.TERM_END_DT"),
    F.col("user_input_strm_cbm008.CENSUS_DT"),
    F.col("user_input_strm_cbm008.STRM_PREV").alias("IN_STRM_PREV"),
    F.col("user_input_strm_cbm008.TERM_BEGIN_DT"),
)
df_class_instr_by_term = df_class_instr_by_term.distinct()
log_view_count("CLASS_INSTR_BY_TERM (READ_CLASS_ISNTR_TBL)", df_class_instr_by_term)

# COMMAND ----------

# Step 5: HRA_FISCAL_YEAR
# Create temp view: HRA_FISCAL_YEAR_CBM008
df_hra_fiscal_year_cbm008 = read_table(f"{student}.{bronze}.PS_UTA_HRA_TBL").alias(
    "PS_UTA_HRA_TBL"
)
df_hra_fiscal_year_cbm008 = df_hra_fiscal_year_cbm008.join(
    df_user_input_strm_cbm008.alias("USER_INPUT_STRM_CBM008"),
    (
        F.col("ps_uta_hra_tbl.UTA_HRA_FISCALYEAR")
        == F.col("user_input_strm_cbm008.ACAD_YEAR")
    ),
    "inner",
)
df_hra_fiscal_year_cbm008 = df_hra_fiscal_year_cbm008.filter(
    (
        (F.col("ps_uta_hra_tbl.UTA_HRA_END_DT") != F.lit("00000000"))
        & (F.col("ps_uta_hra_tbl.UTA_HRA_TITLE_CD") < F.lit("0115"))
    )
)
df_hra_fiscal_year_cbm008 = df_hra_fiscal_year_cbm008.select(
    F.col("ps_uta_hra_tbl.SSN"),
    F.col("ps_uta_hra_tbl.UTA_HRA_FISCALYEAR"),
    F.col("user_input_strm_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("user_input_strm_cbm008.APPT_BEGIN_DT"),
    F.col("user_input_strm_cbm008.APPT_END_DT"),
    F.col("ps_uta_hra_tbl.UTA_HRA_BEGIN_DT"),
    F.col("ps_uta_hra_tbl.UTA_HRA_END_DT"),
    F.col("ps_uta_hra_tbl.UTA_HRA_JOB_GRPCD"),
    F.col("user_input_strm_cbm008.CBM_TERM"),
    F.col("ps_uta_hra_tbl.UTA_HRA_TITLE_CD"),
    F.col("user_input_strm_cbm008.STRM"),
    F.col("user_input_strm_cbm008.TERM_END_DT"),
    F.col("user_input_strm_cbm008.CENSUS_DT"),
    F.col("ps_uta_hra_tbl.EMPLID"),
    F.col("user_input_strm_cbm008.TERM_BEGIN_DT"),
)
log_view_count("HRA_FISCAL_YEAR_CBM008", df_hra_fiscal_year_cbm008)

# COMMAND ----------

# Step 6: HRE_UNIQ_SSN
# Create temp view: HRE_UNIQ_SSN_CBM008
df_hre_uniq_ssn_cbm008 = read_table(f"{student}.{bronze}.PS_UTA_HRE_TBL").alias(
    "PS_UTA_HRE_TBL"
)
df_hre_uniq_ssn_cbm008 = df_hre_uniq_ssn_cbm008.select(F.col("ps_uta_hre_tbl.SSN"))
df_hre_uniq_ssn_cbm008 = df_hre_uniq_ssn_cbm008.distinct()
log_view_count("HRE_UNIQ_SSN_CBM008", df_hre_uniq_ssn_cbm008)

# COMMAND ----------

# Step 7: CHECK_ID_CHANGE
# Create temp view: CHECK_ID_CHANGE_CBM008
df_check_id_change_cbm008 = read_table(f"{student}.{bronze}.PS_UTA_HRE_TBL").alias(
    "PS_UTA_HRE_TBL"
)
df_check_id_change_cbm008 = df_check_id_change_cbm008.join(
    df_hre_uniq_ssn_cbm008.alias("HRE_UNIQ_SSN_CBM008"),
    (F.col("ps_uta_hre_tbl.UTA_HRE_PRIOR_SSN") == F.col("hre_uniq_ssn_cbm008.SSN")),
    "left",
)
df_check_id_change_cbm008 = df_check_id_change_cbm008.select(
    F.col("ps_uta_hre_tbl.SSN"),
    F.col("ps_uta_hre_tbl.UTA_HR_SOURCE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_NAME"),
    F.col("ps_uta_hre_tbl.UTA_HRE_NAME_FML"),
    F.col("ps_uta_hre_tbl.UTA_HRE_PRIOR_SSN"),
    F.col("ps_uta_hre_tbl.STREET1"),
    F.col("ps_uta_hre_tbl.STREET2"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CITY"),
    F.col("ps_uta_hre_tbl.UTA_HRE_STATE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_ZIPCODE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_HOME_PHONE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CAMPUS_BOX"),
    F.col("ps_uta_hre_tbl.DEPTNAME"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CAMPUSBLDG"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CAMPUS_RM"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CAMPUS_PH"),
    F.col("ps_uta_hre_tbl.UTA_HRE_EMAIL"),
    F.col("ps_uta_hre_tbl.UTA_HRE_UT_EID"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CAMPUS_FAX"),
    F.col("ps_uta_hre_tbl.UTA_HRE_ADDR_SW"),
    F.col("ps_uta_hre_tbl.UTA_HRE_TELE_SW"),
    F.col("ps_uta_hre_tbl.UTA_HRE_BIRTH_DATE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_GENDER"),
    F.col("ps_uta_hre_tbl.UTA_HRE_ETHNIC_CD"),
    F.col("ps_uta_hre_tbl.UTA_HRE_USCIT"),
    F.col("ps_uta_hre_tbl.UTA_HRE_EDUC_LEVEL"),
    F.col("ps_uta_hre_tbl.UTA_HRE_STATUS"),
    F.col("ps_uta_hre_tbl.UTA_HRE_TENURE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_LONGEVITY"),
    F.col("ps_uta_hre_tbl.UTA_HRE_LONG_SVCMO"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CNT_SVC_DT"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CNTSVC_MOS"),
    F.col("ps_uta_hre_tbl.UTA_HRE_ST_SVCMO"),
    F.col("ps_uta_hre_tbl.UTA_HRE_TERM_DATE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_MAJORTITLE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_PCTTIMETOT"),
    F.col("ps_uta_hre_tbl.UTA_HRE_PCT_IND"),
    F.col("ps_uta_hre_tbl.UTA_HRE_BRP_STAT"),
    F.col("ps_uta_hre_tbl.UTA_HRE_BRP_AMT"),
    F.col("ps_uta_hre_tbl.UTA_HRE_IMM_EXP_DT"),
    F.col("ps_uta_hre_tbl.UTA_HRE_MAJAPPTSEQ"),
    F.col("ps_uta_hre_tbl.UTA_HRE_BRP_RATE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_RET_CD"),
    F.col("ps_uta_hre_tbl.UTA_HRE_PREVMAJTTL"),
    F.col("ps_uta_hre_tbl.UTA_HRE_COMPSTSVCM"),
    F.col("ps_uta_hre_tbl.UTA_HRE_OCOMPSVCMO"),
    F.col("ps_uta_hre_tbl.UTA_HRE_OAGCYSVCMO"),
    F.col("ps_uta_hre_tbl.UTA_HRE_ASOFDATE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_NAME_UPD"),
    F.col("ps_uta_hre_tbl.UTA_HRE_HMADDRUPD"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CAMPADRUPD"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CEMAIL_UPD"),
    F.col("ps_uta_hre_tbl.UTA_HRE_ETH_UPD"),
    F.col("ps_uta_hre_tbl.UTA_HRE_EMPLID"),
    F.col("ps_uta_hre_tbl.UTA_HRE_NAME_UL"),
    F.col("ps_uta_hre_tbl.UTA_HRE_STREET1_UL"),
    F.col("ps_uta_hre_tbl.UTA_HRE_STREET2_UL"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CITY_UL"),
    F.col("ps_uta_hre_tbl.EMPLID"),
    F.when(F.col("hre_uniq_ssn_cbm008.SSN").isNotNull(), F.lit("Y"))
    .otherwise(F.lit("N"))
    .alias("FOUND_NEWID"),
)
log_view_count("CHECK_ID_CHANGE_CBM008", df_check_id_change_cbm008)

# COMMAND ----------

# Step 8: PROCESS_HRE_FILE
# Create temp view: PROCESS_HRE_FILE_CBM008
df_process_hre_file_cbm008 = df_check_id_change_cbm008.alias("CHECK_ID_CHANGE_CBM008")
df_process_hre_file_cbm008 = df_process_hre_file_cbm008.filter(
    (
        (
            (
                (
                    (
                        F.col("check_id_change_cbm008.UTA_HRE_NAME").isNotNull()
                        & (F.col("check_id_change_cbm008.UTA_HRE_NAME") != F.lit(""))
                    )
                    & (
                        F.col("check_id_change_cbm008.UTA_HRE_CNT_SVC_DT").isNotNull()
                        & (
                            F.col("check_id_change_cbm008.UTA_HRE_CNT_SVC_DT")
                            != F.lit("")
                        )
                    )
                )
                & F.col("check_id_change_cbm008.UTA_HRE_STATUS").isin(["8", "R", "A"])
            )
            & (F.col("check_id_change_cbm008.FOUND_NEWID") == F.lit("N"))
        )
        & (
            ~F.col("check_id_change_cbm008.UTA_HRE_NAME_UL").contains("*")
            | ~F.upper(F.col("check_id_change_cbm008.UTA_HRE_NAME_UL")).contains(
                "DO NOT"
            )
        )
    )
)
df_process_hre_file_cbm008 = df_process_hre_file_cbm008.select(
    F.col("check_id_change_cbm008.SSN"),
    F.col("check_id_change_cbm008.UTA_HRE_PRIOR_SSN"),
    F.col("check_id_change_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("check_id_change_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("check_id_change_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("check_id_change_cbm008.UTA_HRE_GENDER"),
    F.col("check_id_change_cbm008.UTA_HRE_NAME_UL"),
    F.col("check_id_change_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("check_id_change_cbm008.UTA_HRE_STATUS"),
)
log_view_count("PROCESS_HRE_FILE_CBM008", df_process_hre_file_cbm008)

# COMMAND ----------

# Step 9: READ_HRA_TITLE_CD
# Create temp view: READ_HRA_TITLE_CD_CBM008
df_read_hra_title_cd_cbm008 = df_process_hre_file_cbm008.alias(
    "PROCESS_HRE_FILE_CBM008"
)
df_read_hra_title_cd_cbm008 = df_read_hra_title_cd_cbm008.join(
    df_hra_fiscal_year_cbm008.alias("HRA_FISCAL_YEAR_CBM008"),
    (F.col("process_hre_file_cbm008.SSN") == F.col("hra_fiscal_year_cbm008.SSN")),
    "inner",
)
df_read_hra_title_cd_cbm008 = df_read_hra_title_cd_cbm008.select(
    F.col("process_hre_file_cbm008.SSN"),
    F.col("process_hre_file_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("process_hre_file_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("process_hre_file_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("process_hre_file_cbm008.UTA_HRE_GENDER"),
    F.col("process_hre_file_cbm008.UTA_HRE_NAME_UL"),
    F.col("process_hre_file_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("process_hre_file_cbm008.UTA_HRE_STATUS"),
    F.col("hra_fiscal_year_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("hra_fiscal_year_cbm008.APPT_BEGIN_DT"),
    F.col("hra_fiscal_year_cbm008.APPT_END_DT"),
    F.col("hra_fiscal_year_cbm008.CBM_TERM"),
    F.col("hra_fiscal_year_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("hra_fiscal_year_cbm008.STRM"),
    F.col("hra_fiscal_year_cbm008.TERM_END_DT"),
    F.col("hra_fiscal_year_cbm008.CENSUS_DT"),
    F.col("hra_fiscal_year_cbm008.EMPLID"),
    F.col("hra_fiscal_year_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("hra_fiscal_year_cbm008.UTA_HRA_TITLE_CD"),
    F.col("hra_fiscal_year_cbm008.TERM_BEGIN_DT"),
)
df_read_hra_title_cd_cbm008 = df_read_hra_title_cd_cbm008.distinct()

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Join)
# Create temp view: HRA_TITLE_WITH_SAL_FTE
df_hra_title_with_sal_fte = df_read_hra_title_cd_cbm008.alias(
    "READ_HRA_TITLE_CD_CBM008"
)
df_hra_title_with_sal_fte = df_hra_title_with_sal_fte.join(
    read_table(f"{student}.{bronze}.PS_UTA_CB8_SAL_FTE").alias(
        "PS_UTA_CB8_SAL_FTE"
    ),
    (
        (F.col("read_hra_title_cd_cbm008.EMPLID") == F.col("ps_uta_cb8_sal_fte.EMPLID"))
        & (F.col("read_hra_title_cd_cbm008.STRM") == F.col("ps_uta_cb8_sal_fte.STRM"))
    ),
    "left",
)
df_hra_title_with_sal_fte = df_hra_title_with_sal_fte.filter(
    F.col("ps_uta_cb8_sal_fte.EMPLID").isNotNull()
)
df_hra_title_with_sal_fte = df_hra_title_with_sal_fte.select(
    F.col("read_hra_title_cd_cbm008.SSN"),
    F.col("read_hra_title_cd_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_hra_title_cd_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("read_hra_title_cd_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_hra_title_cd_cbm008.UTA_HRE_GENDER"),
    F.col("read_hra_title_cd_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_hra_title_cd_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_hra_title_cd_cbm008.UTA_HRE_STATUS"),
    F.col("read_hra_title_cd_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("read_hra_title_cd_cbm008.APPT_BEGIN_DT"),
    F.col("read_hra_title_cd_cbm008.APPT_END_DT"),
    F.col("read_hra_title_cd_cbm008.CBM_TERM"),
    F.col("read_hra_title_cd_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("read_hra_title_cd_cbm008.STRM"),
    F.col("read_hra_title_cd_cbm008.TERM_END_DT"),
    F.col("read_hra_title_cd_cbm008.CENSUS_DT"),
    F.col("read_hra_title_cd_cbm008.EMPLID"),
    F.col("read_hra_title_cd_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("read_hra_title_cd_cbm008.UTA_HRA_TITLE_CD"),
    F.col("ps_uta_cb8_sal_fte.COMPRATE"),
    F.col("ps_uta_cb8_sal_fte.DEPTID"),
    F.col("ps_uta_cb8_sal_fte.POSITION_NBR"),
    F.col("ps_uta_cb8_sal_fte.STD_HOURS"),
    F.when(F.col("ps_uta_cb8_sal_fte.EMPLID").isNotNull(), F.lit("Y"))
    .otherwise(F.lit("N"))
    .alias("FACULTY_MEMBER"),
    F.col("read_hra_title_cd_cbm008.TERM_BEGIN_DT"),
)
log_view_count("HRA_TITLE_WITH_SAL_FTE (READ_HRA_TITLE_CD)", df_hra_title_with_sal_fte)

# COMMAND ----------

# Step 10: READ_PERS_NID_INSTR
# Create temp view: INSTR_WITH_PERS_NID
df_instr_with_pers_nid = df_class_instr_by_term.alias("CLASS_INSTR_BY_TERM")
df_instr_with_pers_nid = df_instr_with_pers_nid.join(
    read_table(f"{student}.{bronze}.PS_PERS_NID").alias("PS_PERS_NID"),
    (
        (
            (
                (F.col("ps_pers_nid.NATIONAL_ID_TYPE") == F.lit("PR"))
                & (F.col("ps_pers_nid.COUNTRY") == F.lit("USA"))
            )
            & (F.col("class_instr_by_term.EMPLID") == F.col("ps_pers_nid.EMPLID"))
        )
        & ~F.col("ps_pers_nid.NATIONAL_ID").isin(
            ["999999999", "999-99-9999", "XXXXXXXXX", "XXX-XX-XXXX"]
        )
    ),
    "left",
)
df_instr_with_pers_nid = df_instr_with_pers_nid.select(
    F.col("class_instr_by_term.EMPLID"),
    F.col("class_instr_by_term.STRM"),
    F.col("class_instr_by_term.IN_STRM"),
    F.col("class_instr_by_term.ACAD_YEAR"),
    F.col("class_instr_by_term.UTSHARE_FISCAL_YEAR"),
    F.col("class_instr_by_term.CBM_TERM"),
    F.col("class_instr_by_term.APPT_BEGIN_DT"),
    F.col("class_instr_by_term.APPT_END_DT"),
    F.col("class_instr_by_term.TERM_END_DT"),
    F.col("class_instr_by_term.CENSUS_DT"),
    F.col("class_instr_by_term.IN_STRM_PREV"),
    F.col("class_instr_by_term.TERM_BEGIN_DT"),
    F.col("ps_pers_nid.NATIONAL_ID").alias("HRS_ID_NID"),
)
log_view_count("INSTR_WITH_PERS_NID (READ_PERS_NID_INSTR)", df_instr_with_pers_nid)

# COMMAND ----------

# Step 11: UNIQ_NATL_ID_MAX_ASOF
# Create temp view: NATL_ID_MAX_ASOF
df_natl_id_max_asof = read_table(f"{student}.{bronze}.PS_UTA_HR_PS_EMP").alias(
    "PS_UTA_HR_PS_EMP"
)
df_natl_id_max_asof = df_natl_id_max_asof.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_uta_hr_ps_emp.UTA_HR_ASOFDATE")).over(
        Window.partitionBy("ps_uta_hr_ps_emp.EMPLID")
    ),
)
df_natl_id_max_asof = df_natl_id_max_asof.filter(
    (F.col("ps_uta_hr_ps_emp.UTA_HR_ASOFDATE") == F.col("_agg_tmp_0"))
)
df_natl_id_max_asof = df_natl_id_max_asof.drop("_agg_tmp_0")
df_natl_id_max_asof = df_natl_id_max_asof.select(
    F.col("ps_uta_hr_ps_emp.EMPLID"), F.col("ps_uta_hr_ps_emp.NATIONAL_ID")
)
df_natl_id_max_asof = df_natl_id_max_asof.distinct()
log_view_count("NATL_ID_MAX_ASOF (UNIQ_NATL_ID_MAX_ASOF)", df_natl_id_max_asof)

# COMMAND ----------

# Step 12: READ_EXT_SYS_HRS_INSTR
# Create temp view: INSTR_WITH_HRS_ID
df_instr_with_hrs_id = df_instr_with_pers_nid.alias("INSTR_WITH_PERS_NID")
df_instr_with_hrs_id = df_instr_with_hrs_id.join(
    df_natl_id_max_asof.alias("NATL_ID_MAX_ASOF"),
    (
        (
            F.col("instr_with_pers_nid.HRS_ID_NID").isNull()
            | (F.col("instr_with_pers_nid.HRS_ID_NID") == F.lit(""))
        )
        & (F.col("instr_with_pers_nid.EMPLID") == F.col("natl_id_max_asof.EMPLID"))
    ),
    "left",
)
df_instr_with_hrs_id = df_instr_with_hrs_id.select(
    F.col("instr_with_pers_nid.EMPLID"),
    F.col("instr_with_pers_nid.STRM"),
    F.col("instr_with_pers_nid.IN_STRM"),
    F.col("instr_with_pers_nid.ACAD_YEAR"),
    F.col("instr_with_pers_nid.UTSHARE_FISCAL_YEAR"),
    F.col("instr_with_pers_nid.CBM_TERM"),
    F.col("instr_with_pers_nid.APPT_BEGIN_DT"),
    F.col("instr_with_pers_nid.APPT_END_DT"),
    F.col("instr_with_pers_nid.TERM_END_DT"),
    F.col("instr_with_pers_nid.CENSUS_DT"),
    F.col("instr_with_pers_nid.IN_STRM_PREV"),
    F.col("instr_with_pers_nid.HRS_ID_NID"),
    F.col("natl_id_max_asof.NATIONAL_ID").alias("HRS_ID_PS_EMP"),
    F.when(
        F.col("natl_id_max_asof.NATIONAL_ID").isNotNull(),
        F.trim(F.col("natl_id_max_asof.NATIONAL_ID")),
    )
    .otherwise(F.trim(F.col("instr_with_pers_nid.HRS_ID_NID")))
    .alias("HRS_ID"),
    F.col("instr_with_pers_nid.TERM_BEGIN_DT"),
)
log_view_count("INSTR_WITH_HRS_ID (READ_EXT_SYS_HRS_INSTR)", df_instr_with_hrs_id)

# COMMAND ----------

# Step 13: GET_A_CRSE_ID_INSTR
# Create temp view: INSTR_WITH_CRSE_ID
df_instr_with_crse_id = df_instr_with_hrs_id.alias("INSTR_WITH_HRS_ID")
df_instr_with_crse_id = df_instr_with_crse_id.join(
    read_table(f"{student}.{bronze}.PS_CLASS_INSTR").alias("PS_CLASS_INSTR"),
    (
        (
            ~F.col("ps_class_instr.ASSIGN_TYPE").isin(["EXC", "NON"])
            & (F.col("instr_with_hrs_id.EMPLID") == F.col("ps_class_instr.EMPLID"))
        )
        & (
            (F.col("instr_with_hrs_id.IN_STRM") == F.col("ps_class_instr.STRM"))
            | (
                (
                    F.coalesce(
                        F.col("instr_with_hrs_id.IN_STRM").cast("BIGINT"), F.lit(0)
                    )
                    - F.when(
                        (
                            F.substring(F.col("instr_with_hrs_id.IN_STRM"), 4, 1)
                            == F.lit("2")
                        ),
                        F.lit(4),
                    ).otherwise(F.lit(3))
                    - F.when(
                        (F.col("instr_with_hrs_id.IN_STRM") == F.lit("2002")),
                        F.lit(1000),
                    ).otherwise(F.lit(0))
                ).cast("STRING")
                == F.col("ps_class_instr.STRM")
            )
        )
    ),
    "left",
)
df_instr_with_crse_id = df_instr_with_crse_id.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_class_instr.STRM")).over(
        Window.partitionBy("instr_with_hrs_id.EMPLID", "instr_with_hrs_id.IN_STRM")
    ),
)
df_instr_with_crse_id = df_instr_with_crse_id.filter(
    (F.col("ps_class_instr.STRM") == F.col("_agg_tmp_0"))
)
df_instr_with_crse_id = df_instr_with_crse_id.drop("_agg_tmp_0")
df_instr_with_crse_id = df_instr_with_crse_id.select(
    F.col("instr_with_hrs_id.EMPLID"),
    F.col("instr_with_hrs_id.STRM"),
    F.lit("").alias("FOUND_IN_EMPLID_TBL"),
    F.col("instr_with_hrs_id.IN_STRM"),
    F.col("instr_with_hrs_id.ACAD_YEAR"),
    F.col("instr_with_hrs_id.UTSHARE_FISCAL_YEAR"),
    F.col("instr_with_hrs_id.CBM_TERM"),
    F.col("instr_with_hrs_id.APPT_BEGIN_DT"),
    F.col("instr_with_hrs_id.APPT_END_DT"),
    F.col("instr_with_hrs_id.TERM_END_DT"),
    F.col("instr_with_hrs_id.CENSUS_DT"),
    F.col("instr_with_hrs_id.IN_STRM_PREV"),
    F.col("instr_with_hrs_id.HRS_ID_NID"),
    F.col("instr_with_hrs_id.HRS_ID_PS_EMP"),
    F.col("instr_with_hrs_id.HRS_ID"),
    F.col("ps_class_instr.ASSIGN_TYPE"),
    F.col("ps_class_instr.ASSIGNMENT_PCT"),
    F.col("ps_class_instr.AUTO_CALC_WRKLD"),
    F.col("ps_class_instr.CLASS_MTG_NBR"),
    F.col("ps_class_instr.CLASS_SECTION"),
    F.col("ps_class_instr.CONTACT_MINUTES"),
    F.col("ps_class_instr.CRSE_ID"),
    F.col("ps_class_instr.CRSE_OFFER_NBR"),
    F.col("ps_class_instr.EMPL_RCD"),
    F.col("ps_class_instr.GRADE_RSTR_ACCESS"),
    F.col("ps_class_instr.INSTR_ASSIGN_SEQ"),
    F.col("ps_class_instr.INSTR_LOAD_FACTOR"),
    F.col("ps_class_instr.INSTR_ROLE"),
    F.col("ps_class_instr.SCHED_PRINT_INSTR"),
    F.col("ps_class_instr.SESSION_CODE"),
    F.col("ps_class_instr.WEEK_WORKLOAD_HRS"),
    F.col("instr_with_hrs_id.TERM_BEGIN_DT"),
)
log_view_count("INSTR_WITH_CRSE_ID (GET_A_CRSE_ID_INSTR)", df_instr_with_crse_id)

# COMMAND ----------

# Step 14: MISSING_HRS_ID
# Create temp view: INSTR_MISSING_HRS_ID
df_instr_missing_hrs_id = df_instr_with_crse_id.alias("INSTR_WITH_CRSE_ID")
df_instr_missing_hrs_id = df_instr_missing_hrs_id.filter(
    (
        F.col("instr_with_crse_id.HRS_ID").isNull()
        | (F.col("instr_with_crse_id.HRS_ID") == F.lit(""))
    )
)
df_instr_missing_hrs_id = df_instr_missing_hrs_id.select(
    F.col("instr_with_crse_id.EMPLID"),
    F.col("instr_with_crse_id.STRM"),
    F.col("instr_with_crse_id.FOUND_IN_EMPLID_TBL"),
    F.col("instr_with_crse_id.IN_STRM"),
    F.col("instr_with_crse_id.ACAD_YEAR"),
    F.col("instr_with_crse_id.UTSHARE_FISCAL_YEAR"),
    F.col("instr_with_crse_id.CBM_TERM"),
    F.col("instr_with_crse_id.APPT_BEGIN_DT"),
    F.col("instr_with_crse_id.APPT_END_DT"),
    F.col("instr_with_crse_id.TERM_END_DT"),
    F.col("instr_with_crse_id.CENSUS_DT"),
    F.col("instr_with_crse_id.IN_STRM_PREV"),
    F.col("instr_with_crse_id.HRS_ID_NID"),
    F.col("instr_with_crse_id.HRS_ID_PS_EMP"),
    F.col("instr_with_crse_id.HRS_ID"),
    F.col("instr_with_crse_id.ASSIGN_TYPE"),
    F.col("instr_with_crse_id.ASSIGNMENT_PCT"),
    F.col("instr_with_crse_id.AUTO_CALC_WRKLD"),
    F.col("instr_with_crse_id.CLASS_MTG_NBR"),
    F.col("instr_with_crse_id.CLASS_SECTION"),
    F.col("instr_with_crse_id.CONTACT_MINUTES"),
    F.col("instr_with_crse_id.CRSE_ID"),
    F.col("instr_with_crse_id.CRSE_OFFER_NBR"),
    F.col("instr_with_crse_id.EMPL_RCD"),
    F.col("instr_with_crse_id.GRADE_RSTR_ACCESS"),
    F.col("instr_with_crse_id.INSTR_ASSIGN_SEQ"),
    F.col("instr_with_crse_id.INSTR_LOAD_FACTOR"),
    F.col("instr_with_crse_id.INSTR_ROLE"),
    F.col("instr_with_crse_id.SCHED_PRINT_INSTR"),
    F.col("instr_with_crse_id.SESSION_CODE"),
    F.col("instr_with_crse_id.WEEK_WORKLOAD_HRS"),
    F.col("instr_with_crse_id.TERM_BEGIN_DT"),
)
log_view_count("INSTR_MISSING_HRS_ID (MISSING_HRS_ID)", df_instr_missing_hrs_id)

# COMMAND ----------

# Step 15: FOUND_HRS_ID
# Create temp view: INSTR_FOUND_HRS_ID
df_instr_found_hrs_id = df_instr_with_crse_id.alias("INSTR_WITH_CRSE_ID")
df_instr_found_hrs_id = df_instr_found_hrs_id.filter(
    (
        F.col("instr_with_crse_id.HRS_ID").isNotNull()
        & (F.col("instr_with_crse_id.HRS_ID") != F.lit(""))
    )
)
df_instr_found_hrs_id = df_instr_found_hrs_id.select(
    F.col("instr_with_crse_id.EMPLID"),
    F.col("instr_with_crse_id.STRM"),
    F.col("instr_with_crse_id.FOUND_IN_EMPLID_TBL"),
    F.col("instr_with_crse_id.IN_STRM"),
    F.col("instr_with_crse_id.ACAD_YEAR"),
    F.col("instr_with_crse_id.UTSHARE_FISCAL_YEAR"),
    F.col("instr_with_crse_id.CBM_TERM"),
    F.col("instr_with_crse_id.APPT_BEGIN_DT"),
    F.col("instr_with_crse_id.APPT_END_DT"),
    F.col("instr_with_crse_id.TERM_END_DT"),
    F.col("instr_with_crse_id.CENSUS_DT"),
    F.col("instr_with_crse_id.IN_STRM_PREV"),
    F.col("instr_with_crse_id.HRS_ID_NID"),
    F.col("instr_with_crse_id.HRS_ID_PS_EMP"),
    F.col("instr_with_crse_id.HRS_ID"),
    F.col("instr_with_crse_id.ASSIGN_TYPE"),
    F.col("instr_with_crse_id.ASSIGNMENT_PCT"),
    F.col("instr_with_crse_id.AUTO_CALC_WRKLD"),
    F.col("instr_with_crse_id.CLASS_MTG_NBR"),
    F.col("instr_with_crse_id.CLASS_SECTION"),
    F.col("instr_with_crse_id.CONTACT_MINUTES"),
    F.col("instr_with_crse_id.CRSE_ID"),
    F.col("instr_with_crse_id.CRSE_OFFER_NBR"),
    F.col("instr_with_crse_id.EMPL_RCD"),
    F.col("instr_with_crse_id.GRADE_RSTR_ACCESS"),
    F.col("instr_with_crse_id.INSTR_ASSIGN_SEQ"),
    F.col("instr_with_crse_id.INSTR_LOAD_FACTOR"),
    F.col("instr_with_crse_id.INSTR_ROLE"),
    F.col("instr_with_crse_id.SCHED_PRINT_INSTR"),
    F.col("instr_with_crse_id.SESSION_CODE"),
    F.col("instr_with_crse_id.WEEK_WORKLOAD_HRS"),
    F.col("instr_with_crse_id.TERM_BEGIN_DT"),
)
log_view_count("INSTR_FOUND_HRS_ID (FOUND_HRS_ID)", df_instr_found_hrs_id)

# COMMAND ----------

# Step 16: READ_HRE_2
# Create temp view: HRE_NAME_LOOKUP
df_hre_name_lookup = df_instr_found_hrs_id.alias("INSTR_FOUND_HRS_ID")
df_hre_name_lookup = df_hre_name_lookup.join(
    read_table(f"{student}.{bronze}.PS_UTA_HRE_TBL").alias("PS_UTA_HRE_TBL"),
    (F.col("instr_found_hrs_id.HRS_ID") == F.col("ps_uta_hre_tbl.SSN")),
    "left",
)
df_hre_name_lookup = df_hre_name_lookup.filter(
    (
        ~F.col("ps_uta_hre_tbl.UTA_HRE_NAME_UL").contains("*")
        | ~F.upper(F.col("ps_uta_hre_tbl.UTA_HRE_NAME_UL")).contains("DO NOT")
    )
)
df_hre_name_lookup = df_hre_name_lookup.select(
    F.col("instr_found_hrs_id.EMPLID"),
    F.col("instr_found_hrs_id.STRM"),
    F.col("instr_found_hrs_id.FOUND_IN_EMPLID_TBL"),
    F.col("instr_found_hrs_id.IN_STRM"),
    F.col("instr_found_hrs_id.ACAD_YEAR"),
    F.col("instr_found_hrs_id.UTSHARE_FISCAL_YEAR"),
    F.col("instr_found_hrs_id.CBM_TERM"),
    F.col("instr_found_hrs_id.APPT_BEGIN_DT"),
    F.col("instr_found_hrs_id.APPT_END_DT"),
    F.col("instr_found_hrs_id.TERM_END_DT"),
    F.col("instr_found_hrs_id.CENSUS_DT"),
    F.col("instr_found_hrs_id.IN_STRM_PREV"),
    F.col("instr_found_hrs_id.HRS_ID_NID"),
    F.col("instr_found_hrs_id.HRS_ID_PS_EMP"),
    F.col("instr_found_hrs_id.HRS_ID"),
    F.col("instr_found_hrs_id.ASSIGN_TYPE"),
    F.col("instr_found_hrs_id.ASSIGNMENT_PCT"),
    F.col("instr_found_hrs_id.AUTO_CALC_WRKLD"),
    F.col("instr_found_hrs_id.CLASS_MTG_NBR"),
    F.col("instr_found_hrs_id.CLASS_SECTION"),
    F.col("instr_found_hrs_id.CONTACT_MINUTES"),
    F.col("instr_found_hrs_id.CRSE_ID"),
    F.col("instr_found_hrs_id.CRSE_OFFER_NBR"),
    F.col("instr_found_hrs_id.EMPL_RCD"),
    F.col("instr_found_hrs_id.GRADE_RSTR_ACCESS"),
    F.col("instr_found_hrs_id.INSTR_ASSIGN_SEQ"),
    F.col("instr_found_hrs_id.INSTR_LOAD_FACTOR"),
    F.col("instr_found_hrs_id.INSTR_ROLE"),
    F.col("instr_found_hrs_id.SCHED_PRINT_INSTR"),
    F.col("instr_found_hrs_id.SESSION_CODE"),
    F.col("instr_found_hrs_id.WEEK_WORKLOAD_HRS"),
    F.lit("1").alias("FACULTY_COMPLIANCE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_MAJORTITLE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_NAME"),
    F.col("ps_uta_hre_tbl.SSN").alias("HRE_SSN"),
    F.col("ps_uta_hre_tbl.UTA_HRE_MAJAPPTSEQ"),
    F.col("ps_uta_hre_tbl.UTA_HRE_BIRTH_DATE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_GENDER"),
    F.col("ps_uta_hre_tbl.UTA_HRE_NAME_UL"),
    F.col("ps_uta_hre_tbl.UTA_HRE_CNT_SVC_DT"),
    F.lit("1").alias("COMPLIANCE"),
    F.col("ps_uta_hre_tbl.UTA_HRE_STATUS"),
    F.col("instr_found_hrs_id.TERM_BEGIN_DT"),
)
log_view_count("HRE_NAME_LOOKUP (READ_HRE_2)", df_hre_name_lookup)

# COMMAND ----------

# Step 17: DECODE_TITLE_CODE_INSTR
# Create temp view: DECODED_TITLE_INSTR
df_decoded_title_instr = df_hre_name_lookup.alias("HRE_NAME_LOOKUP")
df_decoded_title_instr = df_decoded_title_instr.select(
    F.col("hre_name_lookup.EMPLID"),
    F.col("hre_name_lookup.STRM"),
    F.col("hre_name_lookup.FOUND_IN_EMPLID_TBL"),
    F.col("hre_name_lookup.IN_STRM"),
    F.col("hre_name_lookup.ACAD_YEAR"),
    F.col("hre_name_lookup.UTSHARE_FISCAL_YEAR"),
    F.col("hre_name_lookup.CBM_TERM"),
    F.col("hre_name_lookup.APPT_BEGIN_DT"),
    F.col("hre_name_lookup.APPT_END_DT"),
    F.col("hre_name_lookup.TERM_END_DT"),
    F.col("hre_name_lookup.CENSUS_DT"),
    F.col("hre_name_lookup.IN_STRM_PREV"),
    F.col("hre_name_lookup.HRS_ID_NID"),
    F.col("hre_name_lookup.HRS_ID_PS_EMP"),
    F.col("hre_name_lookup.HRS_ID"),
    F.col("hre_name_lookup.ASSIGN_TYPE"),
    F.col("hre_name_lookup.ASSIGNMENT_PCT"),
    F.col("hre_name_lookup.AUTO_CALC_WRKLD"),
    F.col("hre_name_lookup.CLASS_MTG_NBR"),
    F.col("hre_name_lookup.CLASS_SECTION"),
    F.col("hre_name_lookup.CONTACT_MINUTES"),
    F.col("hre_name_lookup.CRSE_ID"),
    F.col("hre_name_lookup.CRSE_OFFER_NBR"),
    F.col("hre_name_lookup.EMPL_RCD"),
    F.col("hre_name_lookup.GRADE_RSTR_ACCESS"),
    F.col("hre_name_lookup.INSTR_ASSIGN_SEQ"),
    F.col("hre_name_lookup.INSTR_LOAD_FACTOR"),
    F.col("hre_name_lookup.INSTR_ROLE"),
    F.col("hre_name_lookup.SCHED_PRINT_INSTR"),
    F.col("hre_name_lookup.SESSION_CODE"),
    F.col("hre_name_lookup.WEEK_WORKLOAD_HRS"),
    F.col("hre_name_lookup.FACULTY_COMPLIANCE"),
    F.col("hre_name_lookup.UTA_HRE_MAJORTITLE"),
    F.when(
        F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
            ["0006", "0007", "0008", "0009", "0010"]
        ),
        F.lit("PROF"),
    )
    .otherwise(
        F.when(
            (F.col("hre_name_lookup.UTA_HRE_MAJORTITLE") == F.lit("0000")),
            F.lit("EMRT"),
        ).otherwise(
            F.when(
                F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                    [
                        "0011",
                        "0013",
                        "0014",
                        "0015",
                        "0021",
                        "0024",
                        "0025",
                        "0034",
                        "0035",
                        "0044",
                        "0045",
                        "0047",
                        "0056",
                        "0029",
                    ]
                ),
                F.lit("ADJ"),
            ).otherwise(
                F.when(
                    F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                        ["0012", "0022", "0032"]
                    ),
                    F.lit("VPRF"),
                ).otherwise(
                    F.when(
                        F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                            ["0016", "0017", "0018", "0019", "0020"]
                        ),
                        F.lit("ASSC"),
                    ).otherwise(
                        F.when(
                            F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                                ["0027", "0028", "0030", "0031"]
                            ),
                            F.lit("ASST"),
                        ).otherwise(
                            F.when(
                                F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                                    ["0040", "0041"]
                                ),
                                F.lit("INST"),
                            ).otherwise(
                                F.when(
                                    F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                                        ["0049", "0050", "0051"]
                                    ),
                                    F.lit("LECT"),
                                ).otherwise(
                                    F.when(
                                        (
                                            F.col("hre_name_lookup.UTA_HRE_MAJORTITLE")
                                            == F.lit("0096")
                                        ),
                                        F.lit("UNDF"),
                                    ).otherwise(
                                        F.when(
                                            (
                                                (
                                                    F.col(
                                                        "hre_name_lookup.UTA_HRE_MAJORTITLE"
                                                    )
                                                    > F.lit("0062")
                                                )
                                                & (
                                                    F.col(
                                                        "hre_name_lookup.UTA_HRE_MAJORTITLE"
                                                    )
                                                    < F.lit("0096")
                                                )
                                            ),
                                            F.lit("TA"),
                                        ).otherwise(F.lit(""))
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    .alias("INSTRUCTOR_CLASSIF"),
    F.when(
        F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
            ["0006", "0007", "0008", "0009", "0010"]
        ),
        F.lit("1"),
    )
    .otherwise(
        F.when(
            F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                [
                    "0000",
                    "0011",
                    "0013",
                    "0014",
                    "0015",
                    "0021",
                    "0024",
                    "0025",
                    "0034",
                    "0035",
                    "0044",
                    "0045",
                    "0047",
                    "0056",
                    "0029",
                    "0012",
                    "0022",
                    "0032",
                    "0049",
                    "0050",
                    "0051",
                    "0096",
                ]
            ),
            F.lit("5"),
        ).otherwise(
            F.when(
                F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                    ["0016", "0017", "0018", "0019", "0020"]
                ),
                F.lit("2"),
            ).otherwise(
                F.when(
                    F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                        ["0027", "0028", "0030", "0031"]
                    ),
                    F.lit("3"),
                ).otherwise(
                    F.when(
                        F.col("hre_name_lookup.UTA_HRE_MAJORTITLE").isin(
                            ["0040", "0041"]
                        ),
                        F.lit("4"),
                    ).otherwise(
                        F.when(
                            (
                                (
                                    F.col("hre_name_lookup.UTA_HRE_MAJORTITLE")
                                    > F.lit("0062")
                                )
                                & (
                                    F.col("hre_name_lookup.UTA_HRE_MAJORTITLE")
                                    < F.lit("0096")
                                )
                            ),
                            F.lit("6"),
                        ).otherwise(F.lit(""))
                    )
                )
            )
        )
    )
    .alias("FACULTY_CLASSIF"),
    F.col("hre_name_lookup.HRE_SSN"),
    F.col("hre_name_lookup.UTA_HRE_NAME"),
    F.col("hre_name_lookup.UTA_HRE_MAJAPPTSEQ"),
    F.col("hre_name_lookup.UTA_HRE_BIRTH_DATE"),
    F.col("hre_name_lookup.UTA_HRE_GENDER"),
    F.col("hre_name_lookup.UTA_HRE_NAME_UL"),
    F.col("hre_name_lookup.UTA_HRE_CNT_SVC_DT"),
    F.col("hre_name_lookup.COMPLIANCE"),
    F.col("hre_name_lookup.UTA_HRE_STATUS"),
    F.col("hre_name_lookup.TERM_BEGIN_DT"),
)

# COMMAND ----------

log_view_count("DECODED_TITLE_INSTR (DECODE_TITLE_CODE_INSTR)", df_decoded_title_instr)

# COMMAND ----------

# Step 18: MISSING_HRE_SSN
# Create temp view: INSTR_MISSING_HRE_SSN
df_instr_missing_hre_ssn = df_decoded_title_instr.alias("DECODED_TITLE_INSTR")
df_instr_missing_hre_ssn = df_instr_missing_hre_ssn.filter(
    (
        F.col("decoded_title_instr.HRE_SSN").isNull()
        | (F.col("decoded_title_instr.HRE_SSN") == F.lit(""))
    )
)
df_instr_missing_hre_ssn = df_instr_missing_hre_ssn.select(
    F.col("decoded_title_instr.EMPLID"),
    F.col("decoded_title_instr.STRM"),
    F.col("decoded_title_instr.FOUND_IN_EMPLID_TBL"),
    F.col("decoded_title_instr.IN_STRM"),
    F.col("decoded_title_instr.ACAD_YEAR"),
    F.col("decoded_title_instr.UTSHARE_FISCAL_YEAR"),
    F.col("decoded_title_instr.CBM_TERM"),
    F.col("decoded_title_instr.APPT_BEGIN_DT"),
    F.col("decoded_title_instr.APPT_END_DT"),
    F.col("decoded_title_instr.TERM_END_DT"),
    F.col("decoded_title_instr.CENSUS_DT"),
    F.col("decoded_title_instr.IN_STRM_PREV"),
    F.col("decoded_title_instr.HRS_ID_NID"),
    F.col("decoded_title_instr.HRS_ID_PS_EMP"),
    F.col("decoded_title_instr.HRS_ID"),
    F.col("decoded_title_instr.ASSIGN_TYPE"),
    F.col("decoded_title_instr.ASSIGNMENT_PCT"),
    F.col("decoded_title_instr.AUTO_CALC_WRKLD"),
    F.col("decoded_title_instr.CLASS_MTG_NBR"),
    F.col("decoded_title_instr.CLASS_SECTION"),
    F.col("decoded_title_instr.CONTACT_MINUTES"),
    F.col("decoded_title_instr.CRSE_ID"),
    F.col("decoded_title_instr.CRSE_OFFER_NBR"),
    F.col("decoded_title_instr.EMPL_RCD"),
    F.col("decoded_title_instr.GRADE_RSTR_ACCESS"),
    F.col("decoded_title_instr.INSTR_ASSIGN_SEQ"),
    F.col("decoded_title_instr.INSTR_LOAD_FACTOR"),
    F.col("decoded_title_instr.INSTR_ROLE"),
    F.col("decoded_title_instr.SCHED_PRINT_INSTR"),
    F.col("decoded_title_instr.SESSION_CODE"),
    F.col("decoded_title_instr.WEEK_WORKLOAD_HRS"),
    F.col("decoded_title_instr.FACULTY_COMPLIANCE"),
    F.col("decoded_title_instr.COMPLIANCE"),
    F.col("decoded_title_instr.TERM_BEGIN_DT"),
)

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Set Operators)
# Create temp view: INSTR_COMBINED
df_instr_combined_part0 = df_instr_missing_hrs_id.alias("instr_missing_hrs_id")
df_instr_combined_part0 = df_instr_combined_part0.select(
    F.col("instr_missing_hrs_id.EMPLID"),
    F.col("instr_missing_hrs_id.STRM"),
    F.col("instr_missing_hrs_id.FOUND_IN_EMPLID_TBL"),
    F.col("instr_missing_hrs_id.IN_STRM"),
    F.col("instr_missing_hrs_id.ACAD_YEAR"),
    F.col("instr_missing_hrs_id.UTSHARE_FISCAL_YEAR"),
    F.col("instr_missing_hrs_id.CBM_TERM"),
    F.col("instr_missing_hrs_id.APPT_BEGIN_DT"),
    F.col("instr_missing_hrs_id.APPT_END_DT"),
    F.col("instr_missing_hrs_id.TERM_END_DT"),
    F.col("instr_missing_hrs_id.CENSUS_DT"),
    F.col("instr_missing_hrs_id.IN_STRM_PREV"),
    F.col("instr_missing_hrs_id.HRS_ID_NID"),
    F.col("instr_missing_hrs_id.HRS_ID_PS_EMP"),
    F.col("instr_missing_hrs_id.HRS_ID"),
    F.col("instr_missing_hrs_id.ASSIGN_TYPE"),
    F.col("instr_missing_hrs_id.ASSIGNMENT_PCT"),
    F.col("instr_missing_hrs_id.AUTO_CALC_WRKLD"),
    F.col("instr_missing_hrs_id.CLASS_MTG_NBR"),
    F.col("instr_missing_hrs_id.CLASS_SECTION"),
    F.col("instr_missing_hrs_id.CONTACT_MINUTES"),
    F.col("instr_missing_hrs_id.CRSE_ID"),
    F.col("instr_missing_hrs_id.CRSE_OFFER_NBR"),
    F.col("instr_missing_hrs_id.EMPL_RCD"),
    F.col("instr_missing_hrs_id.GRADE_RSTR_ACCESS"),
    F.col("instr_missing_hrs_id.INSTR_ASSIGN_SEQ"),
    F.col("instr_missing_hrs_id.INSTR_LOAD_FACTOR"),
    F.col("instr_missing_hrs_id.INSTR_ROLE"),
    F.col("instr_missing_hrs_id.SCHED_PRINT_INSTR"),
    F.col("instr_missing_hrs_id.SESSION_CODE"),
    F.col("instr_missing_hrs_id.WEEK_WORKLOAD_HRS"),
    F.expr("'9' || SUBSTRING(instr_missing_hrs_id.EMPLID, 3, 8)").alias("OUT_SSN"),
    F.lit("").alias("COMPLIANCE"),
    F.col("instr_missing_hrs_id.TERM_BEGIN_DT"),
)
df_instr_combined_part1 = df_instr_missing_hre_ssn.alias("instr_missing_hre_ssn")
df_instr_combined_part1 = df_instr_combined_part1.select(
    F.col("instr_missing_hre_ssn.EMPLID"),
    F.col("instr_missing_hre_ssn.STRM"),
    F.col("instr_missing_hre_ssn.FOUND_IN_EMPLID_TBL"),
    F.col("instr_missing_hre_ssn.IN_STRM"),
    F.col("instr_missing_hre_ssn.ACAD_YEAR"),
    F.col("instr_missing_hre_ssn.UTSHARE_FISCAL_YEAR"),
    F.col("instr_missing_hre_ssn.CBM_TERM"),
    F.col("instr_missing_hre_ssn.APPT_BEGIN_DT"),
    F.col("instr_missing_hre_ssn.APPT_END_DT"),
    F.col("instr_missing_hre_ssn.TERM_END_DT"),
    F.col("instr_missing_hre_ssn.CENSUS_DT"),
    F.col("instr_missing_hre_ssn.IN_STRM_PREV"),
    F.col("instr_missing_hre_ssn.HRS_ID_NID"),
    F.col("instr_missing_hre_ssn.HRS_ID_PS_EMP"),
    F.col("instr_missing_hre_ssn.HRS_ID"),
    F.col("instr_missing_hre_ssn.ASSIGN_TYPE"),
    F.col("instr_missing_hre_ssn.ASSIGNMENT_PCT"),
    F.col("instr_missing_hre_ssn.AUTO_CALC_WRKLD"),
    F.col("instr_missing_hre_ssn.CLASS_MTG_NBR"),
    F.col("instr_missing_hre_ssn.CLASS_SECTION"),
    F.col("instr_missing_hre_ssn.CONTACT_MINUTES"),
    F.col("instr_missing_hre_ssn.CRSE_ID"),
    F.col("instr_missing_hre_ssn.CRSE_OFFER_NBR"),
    F.col("instr_missing_hre_ssn.EMPL_RCD"),
    F.col("instr_missing_hre_ssn.GRADE_RSTR_ACCESS"),
    F.col("instr_missing_hre_ssn.INSTR_ASSIGN_SEQ"),
    F.col("instr_missing_hre_ssn.INSTR_LOAD_FACTOR"),
    F.col("instr_missing_hre_ssn.INSTR_ROLE"),
    F.col("instr_missing_hre_ssn.SCHED_PRINT_INSTR"),
    F.col("instr_missing_hre_ssn.SESSION_CODE"),
    F.col("instr_missing_hre_ssn.WEEK_WORKLOAD_HRS"),
    F.col("instr_missing_hre_ssn.HRS_ID").alias("OUT_SSN"),
    F.col("instr_missing_hre_ssn.COMPLIANCE"),
    F.col("instr_missing_hre_ssn.TERM_BEGIN_DT"),
)
df_instr_combined = df_instr_combined_part0.union(df_instr_combined_part1)
log_view_count("INSTR_COMBINED (MISSING_HRE_SSN)", df_instr_combined)

# COMMAND ----------

# Step 19: NAMES_MAX_EFFDT
# Create temp view: NAMES_MAX_EFFDT_CBM008
df_names_max_effdt_cbm008 = read_table(f"{student}.{bronze}.PS_NAMES").alias(
    "PS_NAMES"
)
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.filter(
    (
        (
            (F.col("ps_names.EFF_STATUS") == F.lit("A"))
            & (F.col("ps_names.EFFDT") <= F.current_timestamp())
        )
        & F.col("ps_names.NAME_TYPE").isin(["HRS", "PRI", "PRF"])
    )
)
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_names.EFFDT")).over(
        Window.partitionBy("ps_names.EMPLID", "ps_names.NAME_TYPE")
    ),
)
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.filter(
    (F.col("ps_names.EFFDT") == F.col("_agg_tmp_0"))
)
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.drop("_agg_tmp_0")
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.select(
    F.col("ps_names.COUNTRY_NM_FORMAT"),
    F.col("ps_names.EFF_STATUS"),
    F.col("ps_names.EFFDT"),
    F.col("ps_names.EMPLID"),
    F.col("ps_names.FIRST_NAME"),
    F.col("ps_names.FIRST_NAME_SRCH"),
    F.col("ps_names.LAST_NAME"),
    F.col("ps_names.LAST_NAME_PREF_NLD"),
    F.col("ps_names.LAST_NAME_SRCH"),
    F.col("ps_names.LASTUPDDTTM"),
    F.col("ps_names.LASTUPDOPRID"),
    F.col("ps_names.MIDDLE_NAME"),
    F.col("ps_names.NAME"),
    F.col("ps_names.NAME_AC"),
    F.col("ps_names.NAME_DISPLAY"),
    F.col("ps_names.NAME_DISPLAY_SRCH"),
    F.col("ps_names.NAME_FORMAL"),
    F.col("ps_names.NAME_INITIALS"),
    F.col("ps_names.NAME_PREFIX"),
    F.col("ps_names.NAME_ROYAL_PREFIX"),
    F.col("ps_names.NAME_ROYAL_SUFFIX"),
    F.col("ps_names.NAME_SUFFIX"),
    F.col("ps_names.NAME_TITLE"),
    F.col("ps_names.NAME_TYPE"),
    F.col("ps_names.PARTNER_LAST_NAME"),
    F.col("ps_names.PARTNER_ROY_PREFIX"),
    F.col("ps_names.PREF_FIRST_NAME"),
    F.col("ps_names.SECOND_LAST_NAME"),
    F.col("ps_names.SECOND_LAST_SRCH"),
    F.when((F.col("ps_names.NAME_TYPE") == F.lit("HRS")), F.lit(1))
    .otherwise(
        F.when((F.col("ps_names.NAME_TYPE") == F.lit("PRI")), F.lit(2)).otherwise(
            F.lit(3)
        )
    )
    .alias("ORDER"),
)
log_view_count("NAMES_MAX_EFFDT_CBM008", df_names_max_effdt_cbm008)

# COMMAND ----------

# Step 20: NAMES_HRS_PRI_PRF
# Create temp view: NAMES_HRS_PRI_PRF_CBM008
df_names_hrs_pri_prf_cbm008 = df_names_max_effdt_cbm008.alias("NAMES_MAX_EFFDT_CBM008")
df_names_hrs_pri_prf_cbm008 = df_names_hrs_pri_prf_cbm008.withColumn(
    "_agg_tmp_0",
    F.min(F.col("names_max_effdt_cbm008.ORDER")).over(
        Window.partitionBy("names_max_effdt_cbm008.EMPLID")
    ),
)
df_names_hrs_pri_prf_cbm008 = df_names_hrs_pri_prf_cbm008.filter(
    (F.col("names_max_effdt_cbm008.ORDER") == F.col("_agg_tmp_0"))
)
df_names_hrs_pri_prf_cbm008 = df_names_hrs_pri_prf_cbm008.drop("_agg_tmp_0")
df_names_hrs_pri_prf_cbm008 = df_names_hrs_pri_prf_cbm008.select(
    F.col("names_max_effdt_cbm008.COUNTRY_NM_FORMAT"),
    F.col("names_max_effdt_cbm008.EFF_STATUS"),
    F.col("names_max_effdt_cbm008.EFFDT"),
    F.col("names_max_effdt_cbm008.EMPLID"),
    F.col("names_max_effdt_cbm008.FIRST_NAME"),
    F.col("names_max_effdt_cbm008.FIRST_NAME_SRCH"),
    F.col("names_max_effdt_cbm008.LAST_NAME"),
    F.col("names_max_effdt_cbm008.LAST_NAME_PREF_NLD"),
    F.col("names_max_effdt_cbm008.LAST_NAME_SRCH"),
    F.col("names_max_effdt_cbm008.LASTUPDDTTM"),
    F.col("names_max_effdt_cbm008.LASTUPDOPRID"),
    F.col("names_max_effdt_cbm008.MIDDLE_NAME"),
    F.col("names_max_effdt_cbm008.NAME"),
    F.col("names_max_effdt_cbm008.NAME_AC"),
    F.col("names_max_effdt_cbm008.NAME_DISPLAY"),
    F.col("names_max_effdt_cbm008.NAME_DISPLAY_SRCH"),
    F.col("names_max_effdt_cbm008.NAME_FORMAL"),
    F.col("names_max_effdt_cbm008.NAME_INITIALS"),
    F.col("names_max_effdt_cbm008.NAME_PREFIX"),
    F.col("names_max_effdt_cbm008.NAME_ROYAL_PREFIX"),
    F.col("names_max_effdt_cbm008.NAME_ROYAL_SUFFIX"),
    F.col("names_max_effdt_cbm008.NAME_SUFFIX"),
    F.col("names_max_effdt_cbm008.NAME_TITLE"),
    F.col("names_max_effdt_cbm008.NAME_TYPE"),
    F.col("names_max_effdt_cbm008.PARTNER_LAST_NAME"),
    F.col("names_max_effdt_cbm008.PARTNER_ROY_PREFIX"),
    F.col("names_max_effdt_cbm008.PREF_FIRST_NAME"),
    F.col("names_max_effdt_cbm008.SECOND_LAST_NAME"),
    F.col("names_max_effdt_cbm008.SECOND_LAST_SRCH"),
)
log_view_count("NAMES_HRS_PRI_PRF_CBM008", df_names_hrs_pri_prf_cbm008)

# COMMAND ----------

# Step 21: GET_NAMES
# Create temp view: GET_NAMES_CBM008
df_get_names_cbm008 = df_instr_combined.alias("INSTR_COMBINED")
df_get_names_cbm008 = df_get_names_cbm008.join(
    df_names_hrs_pri_prf_cbm008.alias("NAMES_HRS_PRI_PRF_CBM008"),
    (F.col("instr_combined.EMPLID") == F.col("names_hrs_pri_prf_cbm008.EMPLID")),
    "left",
)
df_get_names_cbm008 = df_get_names_cbm008.select(
    F.col("instr_combined.EMPLID"),
    F.col("instr_combined.STRM"),
    F.col("instr_combined.FOUND_IN_EMPLID_TBL"),
    F.col("instr_combined.IN_STRM"),
    F.col("instr_combined.ACAD_YEAR"),
    F.col("instr_combined.UTSHARE_FISCAL_YEAR"),
    F.col("instr_combined.CBM_TERM"),
    F.col("instr_combined.APPT_BEGIN_DT"),
    F.col("instr_combined.APPT_END_DT"),
    F.col("instr_combined.TERM_END_DT"),
    F.col("instr_combined.CENSUS_DT"),
    F.col("instr_combined.IN_STRM_PREV"),
    F.col("instr_combined.HRS_ID_NID"),
    F.col("instr_combined.HRS_ID_PS_EMP"),
    F.col("instr_combined.HRS_ID"),
    F.col("instr_combined.ASSIGN_TYPE"),
    F.col("instr_combined.ASSIGNMENT_PCT"),
    F.col("instr_combined.AUTO_CALC_WRKLD"),
    F.col("instr_combined.CLASS_MTG_NBR"),
    F.col("instr_combined.CLASS_SECTION"),
    F.col("instr_combined.CONTACT_MINUTES"),
    F.col("instr_combined.CRSE_ID"),
    F.col("instr_combined.CRSE_OFFER_NBR"),
    F.col("instr_combined.EMPL_RCD"),
    F.col("instr_combined.GRADE_RSTR_ACCESS"),
    F.col("instr_combined.INSTR_ASSIGN_SEQ"),
    F.col("instr_combined.INSTR_LOAD_FACTOR"),
    F.col("instr_combined.INSTR_ROLE"),
    F.col("instr_combined.SCHED_PRINT_INSTR"),
    F.col("instr_combined.SESSION_CODE"),
    F.col("instr_combined.WEEK_WORKLOAD_HRS"),
    F.col("instr_combined.OUT_SSN"),
    F.col("names_hrs_pri_prf_cbm008.NAME"),
    F.col("names_hrs_pri_prf_cbm008.FIRST_NAME"),
    F.col("names_hrs_pri_prf_cbm008.LAST_NAME"),
    F.col("names_hrs_pri_prf_cbm008.MIDDLE_NAME"),
    F.col("instr_combined.COMPLIANCE"),
    F.col("instr_combined.TERM_BEGIN_DT"),
)
log_view_count("GET_NAMES_CBM008", df_get_names_cbm008)

# COMMAND ----------

# Step 22: GET_DOB
# Create temp view: GET_DOB_CBM008
df_get_dob_cbm008 = df_get_names_cbm008.alias("GET_NAMES_CBM008")
df_get_dob_cbm008 = df_get_dob_cbm008.join(
    read_table(f"{student}.{bronze}.PS_PERSON").alias("PS_PERSON"),
    (F.col("get_names_cbm008.EMPLID") == F.col("ps_person.EMPLID")),
    "left",
)
df_get_dob_cbm008 = df_get_dob_cbm008.select(
    F.col("get_names_cbm008.EMPLID"),
    F.col("get_names_cbm008.STRM"),
    F.col("get_names_cbm008.FOUND_IN_EMPLID_TBL"),
    F.col("get_names_cbm008.IN_STRM"),
    F.col("get_names_cbm008.ACAD_YEAR"),
    F.col("get_names_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("get_names_cbm008.CBM_TERM"),
    F.col("get_names_cbm008.APPT_BEGIN_DT"),
    F.col("get_names_cbm008.APPT_END_DT"),
    F.col("get_names_cbm008.TERM_END_DT"),
    F.col("get_names_cbm008.CENSUS_DT"),
    F.col("get_names_cbm008.IN_STRM_PREV"),
    F.col("get_names_cbm008.HRS_ID_NID"),
    F.col("get_names_cbm008.HRS_ID_PS_EMP"),
    F.col("get_names_cbm008.HRS_ID"),
    F.col("get_names_cbm008.ASSIGN_TYPE"),
    F.col("get_names_cbm008.ASSIGNMENT_PCT"),
    F.col("get_names_cbm008.AUTO_CALC_WRKLD"),
    F.col("get_names_cbm008.CLASS_MTG_NBR"),
    F.col("get_names_cbm008.CLASS_SECTION"),
    F.col("get_names_cbm008.CONTACT_MINUTES"),
    F.col("get_names_cbm008.CRSE_ID"),
    F.col("get_names_cbm008.CRSE_OFFER_NBR"),
    F.col("get_names_cbm008.EMPL_RCD"),
    F.col("get_names_cbm008.GRADE_RSTR_ACCESS"),
    F.col("get_names_cbm008.INSTR_ASSIGN_SEQ"),
    F.col("get_names_cbm008.INSTR_LOAD_FACTOR"),
    F.col("get_names_cbm008.INSTR_ROLE"),
    F.col("get_names_cbm008.SCHED_PRINT_INSTR"),
    F.col("get_names_cbm008.SESSION_CODE"),
    F.col("get_names_cbm008.WEEK_WORKLOAD_HRS"),
    F.col("get_names_cbm008.OUT_SSN"),
    F.col("get_names_cbm008.NAME"),
    F.col("get_names_cbm008.FIRST_NAME"),
    F.col("get_names_cbm008.LAST_NAME"),
    F.col("get_names_cbm008.MIDDLE_NAME"),
    F.col("ps_person.BIRTHDATE"),
    F.col("get_names_cbm008.COMPLIANCE"),
    F.col("get_names_cbm008.TERM_BEGIN_DT"),
)
log_view_count("GET_DOB_CBM008", df_get_dob_cbm008)

# COMMAND ----------

# Step 23: PERS_DATA_MAX_EFFDT
# Create temp view: PERS_DATA_MAX_EFFDT_CBM008
df_pers_data_max_effdt_cbm008 = read_table(
    f"{student}.{bronze}.PS_PERS_DATA_EFFDT"
).alias("PS_PERS_DATA_EFFDT")
df_pers_data_max_effdt_cbm008 = df_pers_data_max_effdt_cbm008.filter(
    (F.col("ps_pers_data_effdt.EFFDT") <= F.current_timestamp())
)
df_pers_data_max_effdt_cbm008 = df_pers_data_max_effdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_pers_data_effdt.EFFDT")).over(
        Window.partitionBy("ps_pers_data_effdt.EMPLID")
    ),
)
df_pers_data_max_effdt_cbm008 = df_pers_data_max_effdt_cbm008.filter(
    (F.col("ps_pers_data_effdt.EFFDT") == F.col("_agg_tmp_0"))
)
df_pers_data_max_effdt_cbm008 = df_pers_data_max_effdt_cbm008.drop("_agg_tmp_0")
df_pers_data_max_effdt_cbm008 = df_pers_data_max_effdt_cbm008.select(
    F.col("ps_pers_data_effdt.ALTER_EMPLID"),
    F.col("ps_pers_data_effdt.EFFDT"),
    F.col("ps_pers_data_effdt.EMPLID"),
    F.col("ps_pers_data_effdt.FT_STUDENT"),
    F.col("ps_pers_data_effdt.HIGHEST_EDUC_LVL"),
    F.col("ps_pers_data_effdt.LANG_CD"),
    F.col("ps_pers_data_effdt.LASTUPDDTTM"),
    F.col("ps_pers_data_effdt.LASTUPDOPRID"),
    F.col("ps_pers_data_effdt.MAR_STATUS"),
    F.col("ps_pers_data_effdt.MAR_STATUS_DT"),
    F.col("ps_pers_data_effdt.SEX"),
)
log_view_count("PERS_DATA_MAX_EFFDT_CBM008", df_pers_data_max_effdt_cbm008)

# COMMAND ----------

# Step 24: GET_GENDER
# Create temp view: GET_GENDER_CBM008
df_get_gender_cbm008 = df_get_dob_cbm008.alias("GET_DOB_CBM008")
df_get_gender_cbm008 = df_get_gender_cbm008.join(
    df_pers_data_max_effdt_cbm008.alias("PERS_DATA_MAX_EFFDT_CBM008"),
    (F.col("get_dob_cbm008.EMPLID") == F.col("pers_data_max_effdt_cbm008.EMPLID")),
    "left",
)
df_get_gender_cbm008 = df_get_gender_cbm008.select(
    F.col("get_dob_cbm008.EMPLID"),
    F.col("get_dob_cbm008.STRM"),
    F.col("get_dob_cbm008.FOUND_IN_EMPLID_TBL"),
    F.col("get_dob_cbm008.IN_STRM"),
    F.col("get_dob_cbm008.ACAD_YEAR"),
    F.col("get_dob_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("get_dob_cbm008.CBM_TERM"),
    F.col("get_dob_cbm008.APPT_BEGIN_DT"),
    F.col("get_dob_cbm008.APPT_END_DT"),
    F.col("get_dob_cbm008.TERM_END_DT"),
    F.col("get_dob_cbm008.CENSUS_DT"),
    F.col("get_dob_cbm008.IN_STRM_PREV"),
    F.col("get_dob_cbm008.HRS_ID_NID"),
    F.col("get_dob_cbm008.HRS_ID_PS_EMP"),
    F.col("get_dob_cbm008.HRS_ID"),
    F.col("get_dob_cbm008.ASSIGN_TYPE"),
    F.col("get_dob_cbm008.ASSIGNMENT_PCT"),
    F.col("get_dob_cbm008.AUTO_CALC_WRKLD"),
    F.col("get_dob_cbm008.CLASS_MTG_NBR"),
    F.col("get_dob_cbm008.CLASS_SECTION"),
    F.col("get_dob_cbm008.CONTACT_MINUTES"),
    F.col("get_dob_cbm008.CRSE_ID"),
    F.col("get_dob_cbm008.CRSE_OFFER_NBR"),
    F.col("get_dob_cbm008.EMPL_RCD"),
    F.col("get_dob_cbm008.GRADE_RSTR_ACCESS"),
    F.col("get_dob_cbm008.INSTR_ASSIGN_SEQ"),
    F.col("get_dob_cbm008.INSTR_LOAD_FACTOR"),
    F.col("get_dob_cbm008.INSTR_ROLE"),
    F.col("get_dob_cbm008.SCHED_PRINT_INSTR"),
    F.col("get_dob_cbm008.SESSION_CODE"),
    F.col("get_dob_cbm008.WEEK_WORKLOAD_HRS"),
    F.col("get_dob_cbm008.OUT_SSN"),
    F.col("get_dob_cbm008.NAME"),
    F.col("get_dob_cbm008.FIRST_NAME"),
    F.col("get_dob_cbm008.LAST_NAME"),
    F.col("get_dob_cbm008.MIDDLE_NAME"),
    F.col("get_dob_cbm008.BIRTHDATE"),
    F.when(
        F.upper(F.col("pers_data_max_effdt_cbm008.SEX")).isin(["M", "F"]),
        F.upper(F.col("pers_data_max_effdt_cbm008.SEX")),
    )
    .otherwise(F.lit("U"))
    .alias("GENDER"),
    F.col("get_dob_cbm008.COMPLIANCE"),
    F.col("get_dob_cbm008.TERM_BEGIN_DT"),
)
log_view_count("GET_GENDER_CBM008", df_get_gender_cbm008)

# COMMAND ----------

# Step 25: FOUND_HRE_SSN
# Create temp view: INSTR_FOUND_HRE_SSN
df_instr_found_hre_ssn = df_decoded_title_instr.alias("DECODED_TITLE_INSTR")
df_instr_found_hre_ssn = df_instr_found_hre_ssn.filter(
    (
        F.col("decoded_title_instr.HRE_SSN").isNotNull()
        & (F.col("decoded_title_instr.HRE_SSN") != F.lit(""))
    )
)
df_instr_found_hre_ssn = df_instr_found_hre_ssn.select(
    F.col("decoded_title_instr.EMPLID").alias("CIT_CHK_EMPLID"),
    F.col("decoded_title_instr.STRM"),
    F.col("decoded_title_instr.FOUND_IN_EMPLID_TBL"),
    F.col("decoded_title_instr.IN_STRM"),
    F.col("decoded_title_instr.ACAD_YEAR"),
    F.col("decoded_title_instr.UTSHARE_FISCAL_YEAR"),
    F.col("decoded_title_instr.CBM_TERM"),
    F.col("decoded_title_instr.APPT_BEGIN_DT"),
    F.col("decoded_title_instr.APPT_END_DT"),
    F.col("decoded_title_instr.TERM_END_DT"),
    F.col("decoded_title_instr.CENSUS_DT"),
    F.col("decoded_title_instr.IN_STRM_PREV"),
    F.col("decoded_title_instr.HRS_ID_NID"),
    F.col("decoded_title_instr.HRS_ID_PS_EMP"),
    F.col("decoded_title_instr.HRS_ID"),
    F.col("decoded_title_instr.ASSIGN_TYPE"),
    F.col("decoded_title_instr.ASSIGNMENT_PCT"),
    F.col("decoded_title_instr.AUTO_CALC_WRKLD"),
    F.col("decoded_title_instr.CLASS_MTG_NBR"),
    F.col("decoded_title_instr.CLASS_SECTION"),
    F.col("decoded_title_instr.CONTACT_MINUTES"),
    F.col("decoded_title_instr.CRSE_ID"),
    F.col("decoded_title_instr.CRSE_OFFER_NBR"),
    F.col("decoded_title_instr.EMPL_RCD"),
    F.col("decoded_title_instr.GRADE_RSTR_ACCESS"),
    F.col("decoded_title_instr.INSTR_ASSIGN_SEQ"),
    F.col("decoded_title_instr.INSTR_LOAD_FACTOR"),
    F.col("decoded_title_instr.INSTR_ROLE"),
    F.col("decoded_title_instr.SCHED_PRINT_INSTR"),
    F.col("decoded_title_instr.SESSION_CODE"),
    F.col("decoded_title_instr.WEEK_WORKLOAD_HRS"),
    F.col("decoded_title_instr.FACULTY_COMPLIANCE"),
    F.col("decoded_title_instr.UTA_HRE_MAJORTITLE"),
    F.col("decoded_title_instr.INSTRUCTOR_CLASSIF"),
    F.when(
        (
            F.col("decoded_title_instr.FACULTY_CLASSIF").isNull()
            | (F.col("decoded_title_instr.FACULTY_CLASSIF") == F.lit(""))
        ),
        F.lit(""),
    )
    .otherwise(F.lit("5"))
    .alias("FACULTY_CLASSIF"),
    F.col("decoded_title_instr.HRE_SSN"),
    F.col("decoded_title_instr.UTA_HRE_NAME").alias("FACULTY_NAME"),
    F.col("decoded_title_instr.UTA_HRE_MAJAPPTSEQ"),
    F.col("decoded_title_instr.UTA_HRE_BIRTH_DATE"),
    F.col("decoded_title_instr.UTA_HRE_GENDER"),
    F.col("decoded_title_instr.UTA_HRE_NAME_UL"),
    F.col("decoded_title_instr.UTA_HRE_CNT_SVC_DT"),
    F.col("decoded_title_instr.COMPLIANCE"),
    F.col("decoded_title_instr.UTA_HRE_STATUS"),
    F.col("decoded_title_instr.TERM_BEGIN_DT"),
)
log_view_count("INSTR_FOUND_HRE_SSN (FOUND_HRE_SSN)", df_instr_found_hre_ssn)

# COMMAND ----------

# Step 26: READ_HRA_TITLE_INSTR
# Create temp view: HRA_TITLE_INSTR
df_hra_title_instr = df_instr_found_hre_ssn.alias("INSTR_FOUND_HRE_SSN")
df_hra_title_instr = df_hra_title_instr.join(
    read_table(f"{student}.{bronze}.PS_UTA_CB8_SAL_FTE").alias(
        "PS_UTA_CB8_SAL_FTE"
    ),
    (
        (
            F.col("instr_found_hre_ssn.CIT_CHK_EMPLID")
            == F.col("ps_uta_cb8_sal_fte.EMPLID")
        )
        & (F.col("instr_found_hre_ssn.IN_STRM") == F.col("ps_uta_cb8_sal_fte.STRM"))
    ),
    "left",
)
df_hra_title_instr = df_hra_title_instr.select(
    F.col("instr_found_hre_ssn.IN_STRM"),
    F.col("instr_found_hre_ssn.ACAD_YEAR"),
    F.col("instr_found_hre_ssn.UTSHARE_FISCAL_YEAR"),
    F.col("instr_found_hre_ssn.CBM_TERM"),
    F.col("instr_found_hre_ssn.APPT_BEGIN_DT"),
    F.col("instr_found_hre_ssn.APPT_END_DT"),
    F.col("instr_found_hre_ssn.TERM_END_DT"),
    F.col("instr_found_hre_ssn.CENSUS_DT"),
    F.col("instr_found_hre_ssn.UTA_HRE_MAJORTITLE"),
    F.col("instr_found_hre_ssn.HRE_SSN").alias("SSN"),
    F.col("instr_found_hre_ssn.UTA_HRE_MAJAPPTSEQ"),
    F.col("instr_found_hre_ssn.UTA_HRE_BIRTH_DATE"),
    F.col("instr_found_hre_ssn.UTA_HRE_GENDER"),
    F.col("instr_found_hre_ssn.UTA_HRE_NAME_UL"),
    F.col("instr_found_hre_ssn.UTA_HRE_CNT_SVC_DT"),
    F.col("ps_uta_cb8_sal_fte.COMPRATE"),
    F.col("ps_uta_cb8_sal_fte.POSITION_NBR"),
    F.col("ps_uta_cb8_sal_fte.STD_HOURS"),
    F.col("instr_found_hre_ssn.COMPLIANCE"),
    F.col("instr_found_hre_ssn.UTA_HRE_STATUS"),
    F.col("instr_found_hre_ssn.TERM_BEGIN_DT"),
)
df_hra_title_instr = df_hra_title_instr.distinct()

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Set Operators)
# Create temp view: INSTR_ALL_SOURCES
df_instr_all_sources_part0 = df_hra_title_instr.alias("hra_title_instr")
df_instr_all_sources_part0 = df_instr_all_sources_part0.select(
    F.col("hra_title_instr.IN_STRM"),
    F.col("hra_title_instr.ACAD_YEAR"),
    F.col("hra_title_instr.UTSHARE_FISCAL_YEAR"),
    F.col("hra_title_instr.CBM_TERM"),
    F.col("hra_title_instr.APPT_BEGIN_DT"),
    F.col("hra_title_instr.APPT_END_DT"),
    F.col("hra_title_instr.TERM_END_DT"),
    F.col("hra_title_instr.CENSUS_DT"),
    F.col("hra_title_instr.UTA_HRE_MAJORTITLE"),
    F.col("hra_title_instr.SSN"),
    F.col("hra_title_instr.UTA_HRE_MAJAPPTSEQ"),
    F.col("hra_title_instr.UTA_HRE_BIRTH_DATE"),
    F.col("hra_title_instr.UTA_HRE_GENDER"),
    F.col("hra_title_instr.UTA_HRE_NAME_UL"),
    F.col("hra_title_instr.UTA_HRE_CNT_SVC_DT"),
    F.col("hra_title_instr.COMPRATE"),
    F.col("hra_title_instr.POSITION_NBR"),
    F.col("hra_title_instr.STD_HOURS"),
    F.col("hra_title_instr.COMPLIANCE"),
    F.col("hra_title_instr.UTA_HRE_STATUS"),
    F.lit("INSTR").alias("SOURCE"),
    F.col("hra_title_instr.TERM_BEGIN_DT"),
)
df_instr_all_sources_part1 = df_hra_title_with_sal_fte.alias("hra_title_with_sal_fte")
df_instr_all_sources_part1 = df_instr_all_sources_part1.select(
    F.col("hra_title_with_sal_fte.STRM").alias("IN_STRM"),
    F.col("hra_title_with_sal_fte.UTA_HRA_FISCALYEAR").alias("ACAD_YEAR"),
    F.col("hra_title_with_sal_fte.UTSHARE_FISCAL_YEAR"),
    F.col("hra_title_with_sal_fte.CBM_TERM"),
    F.col("hra_title_with_sal_fte.APPT_BEGIN_DT"),
    F.col("hra_title_with_sal_fte.APPT_END_DT"),
    F.col("hra_title_with_sal_fte.TERM_END_DT"),
    F.col("hra_title_with_sal_fte.CENSUS_DT"),
    F.col("hra_title_with_sal_fte.UTA_HRE_MAJORTITLE"),
    F.col("hra_title_with_sal_fte.SSN"),
    F.col("hra_title_with_sal_fte.UTA_HRE_MAJAPPTSEQ"),
    F.col("hra_title_with_sal_fte.UTA_HRE_BIRTH_DATE"),
    F.col("hra_title_with_sal_fte.UTA_HRE_GENDER"),
    F.col("hra_title_with_sal_fte.UTA_HRE_NAME_UL"),
    F.col("hra_title_with_sal_fte.UTA_HRE_CNT_SVC_DT"),
    F.col("hra_title_with_sal_fte.COMPRATE"),
    F.col("hra_title_with_sal_fte.POSITION_NBR"),
    F.col("hra_title_with_sal_fte.STD_HOURS"),
    F.when((F.col("hra_title_with_sal_fte.FACULTY_MEMBER") == F.lit("Y")), F.lit("1"))
    .otherwise(F.lit("0"))
    .alias("COMPLIANCE"),
    F.col("hra_title_with_sal_fte.UTA_HRE_STATUS"),
    F.lit("HRA").alias("SOURCE"),
    F.col("hra_title_with_sal_fte.TERM_BEGIN_DT"),
)
df_instr_all_sources = df_instr_all_sources_part0.union(
    df_instr_all_sources_part1
).distinct()

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Join)
# Create temp view: INSTR_DEDUPED
df_instr_deduped = df_instr_all_sources.alias("INSTR_ALL_SOURCES")
_winSpec_1 = Window.partitionBy(
    F.col("instr_all_sources.IN_STRM"),
    F.col("instr_all_sources.SSN"),
    F.col("instr_all_sources.POSITION_NBR"),
    F.col("instr_all_sources.COMPRATE"),
)
df_instr_deduped = df_instr_deduped.withColumn(
    "COMPLIANCE", F.max(F.col("instr_all_sources.COMPLIANCE")).over(_winSpec_1)
)

df_instr_deduped = df_instr_deduped.withColumn(
    "SOURCE", F.min(F.col("instr_all_sources.SOURCE")).over(_winSpec_1)
)
df_instr_deduped = df_instr_deduped.select(
    F.col("instr_all_sources.IN_STRM"),
    F.col("instr_all_sources.ACAD_YEAR"),
    F.col("instr_all_sources.UTSHARE_FISCAL_YEAR"),
    F.col("instr_all_sources.CBM_TERM"),
    F.col("instr_all_sources.APPT_BEGIN_DT"),
    F.col("instr_all_sources.APPT_END_DT"),
    F.col("instr_all_sources.TERM_END_DT"),
    F.col("instr_all_sources.CENSUS_DT"),
    F.col("instr_all_sources.UTA_HRE_MAJORTITLE"),
    F.col("instr_all_sources.SSN"),
    F.col("instr_all_sources.UTA_HRE_MAJAPPTSEQ"),
    F.col("instr_all_sources.UTA_HRE_BIRTH_DATE"),
    F.col("instr_all_sources.UTA_HRE_GENDER"),
    F.col("instr_all_sources.UTA_HRE_NAME_UL"),
    F.col("instr_all_sources.UTA_HRE_CNT_SVC_DT"),
    F.col("instr_all_sources.COMPRATE"),
    F.col("instr_all_sources.POSITION_NBR"),
    F.col("instr_all_sources.STD_HOURS"),
    F.col("COMPLIANCE"),
    F.col("instr_all_sources.UTA_HRE_STATUS"),
    F.col("SOURCE"),
    F.col("instr_all_sources.TERM_BEGIN_DT"),
)
df_instr_deduped = df_instr_deduped.distinct()
log_view_count("INSTR_DEDUPED", df_instr_deduped)

# COMMAND ----------

# Step 27: UTA_DEPTBDGT_ER_MAX_EFFSEQ
# Create temp view: DEPTBDGT_ER_MAX_EFFSEQ_CBM008
df_deptbdgt_er_max_effseq_cbm008 = read_table(
    f"{student}.{bronze}.PS_UTA_DEPTBDGT_ER"
).alias("PS_UTA_DEPTBDGT_ER")
df_deptbdgt_er_max_effseq_cbm008 = df_deptbdgt_er_max_effseq_cbm008.filter(
    (
        (
            (F.col("ps_uta_deptbdgt_er.SETID") == F.lit("UTARL"))
            & (
                F.trim(F.col("ps_uta_deptbdgt_er.ERNCD")).isNull()
                | (F.trim(F.col("ps_uta_deptbdgt_er.ERNCD")) == F.lit(""))
            )
        )
        & (F.col("ps_uta_deptbdgt_er.HP_USED_DISTRIBUTN") == F.lit("Y"))
    )
)
df_deptbdgt_er_max_effseq_cbm008 = df_deptbdgt_er_max_effseq_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_uta_deptbdgt_er.EFFSEQ")).over(
        Window.partitionBy(
            "ps_uta_deptbdgt_er.SETID",
            "ps_uta_deptbdgt_er.POSITION_NBR",
            "ps_uta_deptbdgt_er.FISCAL_YEAR",
            "ps_uta_deptbdgt_er.EFFDT",
        )
    ),
)
df_deptbdgt_er_max_effseq_cbm008 = df_deptbdgt_er_max_effseq_cbm008.filter(
    (F.col("ps_uta_deptbdgt_er.EFFSEQ") == F.col("_agg_tmp_0"))
)
df_deptbdgt_er_max_effseq_cbm008 = df_deptbdgt_er_max_effseq_cbm008.drop("_agg_tmp_0")
df_deptbdgt_er_max_effseq_cbm008 = df_deptbdgt_er_max_effseq_cbm008.select(
    F.col("ps_uta_deptbdgt_er.ACCT_CD"),
    F.col("ps_uta_deptbdgt_er.BUDGET_AMT"),
    F.col("ps_uta_deptbdgt_er.BUDGET_SEQ"),
    F.col("ps_uta_deptbdgt_er.DIST_PCT"),
    F.col("ps_uta_deptbdgt_er.EFFDT"),
    F.col("ps_uta_deptbdgt_er.EFFSEQ"),
    F.col("ps_uta_deptbdgt_er.EMPL_RCD"),
    F.col("ps_uta_deptbdgt_er.EMPLID"),
    F.col("ps_uta_deptbdgt_er.ERNCD"),
    F.col("ps_uta_deptbdgt_er.FISCAL_YEAR"),
    F.col("ps_uta_deptbdgt_er.FUNDING_END_DT"),
    F.col("ps_uta_deptbdgt_er.GL_PAY_TYPE"),
    F.col("ps_uta_deptbdgt_er.HP_EXCESS"),
    F.col("ps_uta_deptbdgt_er.HP_FRINGE_GROUP"),
    F.col("ps_uta_deptbdgt_er.HP_REDIRECT_ACCT"),
    F.col("ps_uta_deptbdgt_er.HP_USED_DISTRIBUTN"),
    F.col("ps_uta_deptbdgt_er.JOBCODE"),
    F.col("ps_uta_deptbdgt_er.PERCENT_EFFORT"),
    F.col("ps_uta_deptbdgt_er.POSITION_NBR"),
    F.col("ps_uta_deptbdgt_er.POSITION_POOL_ID"),
    F.col("ps_uta_deptbdgt_er.SETID"),
    F.col("ps_uta_deptbdgt_er.SETID_JOBCODE"),
)
df_deptbdgt_er_max_effseq_cbm008 = df_deptbdgt_er_max_effseq_cbm008.distinct()
log_view_count("DEPTBDGT_ER_MAX_EFFSEQ_CBM008", df_deptbdgt_er_max_effseq_cbm008)

# COMMAND ----------

# Step 28: READ_4_ACCT_CD
# Create temp view: READ_4_ACCT_CD_CBM008
df_read_4_acct_cd_cbm008 = df_instr_deduped.alias("INSTR_DEDUPED")
df_read_4_acct_cd_cbm008 = df_read_4_acct_cd_cbm008.join(
    df_deptbdgt_er_max_effseq_cbm008.alias("DEPTBDGT_ER_MAX_EFFSEQ_CBM008"),
    (
        (
            (
                F.col("instr_deduped.POSITION_NBR")
                == F.col("deptbdgt_er_max_effseq_cbm008.POSITION_NBR")
            )
            & (
                F.col("instr_deduped.UTSHARE_FISCAL_YEAR")
                == F.col("deptbdgt_er_max_effseq_cbm008.FISCAL_YEAR")
            )
        )
        & (
            F.col("deptbdgt_er_max_effseq_cbm008.EFFDT")
            <= (
                F.expr("TO_DATE(instr_deduped.APPT_END_DT, 'yyyyMMdd')").cast(
                    "TIMESTAMP"
                )
                + F.expr("MAKE_INTERVAL(0, 0, 0, 0, 0, 0)")
            ).cast("TIMESTAMP")
        )
    ),
    "left",
)
df_read_4_acct_cd_cbm008 = df_read_4_acct_cd_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("deptbdgt_er_max_effseq_cbm008.EFFDT")).over(
        Window.partitionBy(
            "instr_deduped.POSITION_NBR", "instr_deduped.UTSHARE_FISCAL_YEAR"
        )
    ),
)
df_read_4_acct_cd_cbm008 = df_read_4_acct_cd_cbm008.withColumn(
    "_agg_tmp_1",
    F.max(F.col("deptbdgt_er_max_effseq_cbm008.EFFDT")).over(
        Window.partitionBy(
            "instr_deduped.POSITION_NBR", "instr_deduped.UTSHARE_FISCAL_YEAR"
        )
    ),
)
df_read_4_acct_cd_cbm008 = df_read_4_acct_cd_cbm008.filter(
    (
        F.col("_agg_tmp_0").isNull()
        | (F.col("deptbdgt_er_max_effseq_cbm008.EFFDT") == F.col("_agg_tmp_1"))
    )
)
df_read_4_acct_cd_cbm008 = df_read_4_acct_cd_cbm008.drop("_agg_tmp_0", "_agg_tmp_1")
df_read_4_acct_cd_cbm008 = df_read_4_acct_cd_cbm008.select(
    F.col("instr_deduped.SSN"),
    F.col("deptbdgt_er_max_effseq_cbm008.ACCT_CD"),
    F.col("deptbdgt_er_max_effseq_cbm008.DIST_PCT"),
    F.col("instr_deduped.UTA_HRE_MAJAPPTSEQ"),
    F.col("instr_deduped.APPT_BEGIN_DT"),
    F.col("instr_deduped.APPT_END_DT"),
    F.col("instr_deduped.CBM_TERM"),
    F.col("instr_deduped.UTSHARE_FISCAL_YEAR"),
    F.col("instr_deduped.UTA_HRE_MAJORTITLE"),
    F.col("instr_deduped.IN_STRM").alias("STRM"),
    F.col("instr_deduped.TERM_END_DT"),
    F.col("instr_deduped.CENSUS_DT"),
    F.col("instr_deduped.UTA_HRE_BIRTH_DATE"),
    F.col("instr_deduped.UTA_HRE_GENDER"),
    F.col("instr_deduped.UTA_HRE_NAME_UL"),
    F.col("instr_deduped.UTA_HRE_CNT_SVC_DT"),
    F.col("instr_deduped.COMPRATE"),
    F.col("instr_deduped.POSITION_NBR"),
    F.col("instr_deduped.STD_HOURS"),
    F.col("instr_deduped.COMPLIANCE"),
    F.col("instr_deduped.ACAD_YEAR"),
    F.col("instr_deduped.UTA_HRE_STATUS"),
    F.col("instr_deduped.SOURCE"),
    F.col("instr_deduped.TERM_BEGIN_DT"),
)
df_read_4_acct_cd_cbm008 = df_read_4_acct_cd_cbm008.distinct()
df_read_4_acct_cd_cbm008 = df_read_4_acct_cd_cbm008.orderBy(
    F.col("SSN").asc(),
    F.col("COMPRATE").asc(),
    F.col("UTSHARE_FISCAL_YEAR").asc(),
    F.col("POSITION_NBR").asc(),
    F.col("DIST_PCT").desc(),
)

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: User Written)


# DATA step: cumulative TOT_DIST_PCT per (SSN, COMPRATE, UTSHARE_FISCAL_YEAR, POSITION_NBR)
# SAS BY-group retain pattern:
#   if first.POSITION_NBR then TOT_DIST_PCT=0;
#   if TOT_DIST_PCT < 100 then output;  -- output BEFORE increment
#   TOT_DIST_PCT = SUM(DIST_PCT, TOT_DIST_PCT);
# The key is: output when cumulative sum BEFORE current row is < 100
_tot_dist_window_before = (
    Window.partitionBy("SSN", "COMPRATE", "UTSHARE_FISCAL_YEAR", "POSITION_NBR")
    .orderBy(F.col("DIST_PCT").desc())
    .rowsBetween(Window.unboundedPreceding, -1)  # Sum of rows BEFORE current row
)
# Cumulative sum BEFORE current row (0 for first row in partition)
df_acct_cd_redistributed = df_read_4_acct_cd_cbm008.withColumn(
    "TOT_DIST_PCT_BEFORE",
    F.coalesce(
        F.sum(F.coalesce(F.col("DIST_PCT"), F.lit(0))).over(_tot_dist_window_before),
        F.lit(0),
    ),
)
# SAS filter: if TOT_DIST_PCT < 100 then output (checking BEFORE increment)
df_acct_cd_redistributed = df_acct_cd_redistributed.filter(
    F.col("TOT_DIST_PCT_BEFORE") < F.lit(100)
)
# Cumulative sum INCLUDING current row for downstream use
_tot_dist_window = (
    Window.partitionBy("SSN", "COMPRATE", "UTSHARE_FISCAL_YEAR", "POSITION_NBR")
    .orderBy(F.col("DIST_PCT").desc())
    .rowsBetween(Window.unboundedPreceding, Window.currentRow)
)
df_acct_cd_redistributed = df_acct_cd_redistributed.withColumn(
    "TOT_DIST_PCT",
    F.sum(F.coalesce(F.col("DIST_PCT"), F.lit(0))).over(_tot_dist_window),
)
df_acct_cd_redistributed = df_acct_cd_redistributed.drop("TOT_DIST_PCT_BEFORE")


# COMMAND ----------

# Step 29: READ_4_FUND_CD_FUNCTION
# Create temp view: READ_4_FUND_CD_FUNCTION_CBM008
df_read_4_fund_cd_function_cbm008 = df_acct_cd_redistributed.alias(
    "ACCT_CD_REDISTRIBUTED"
)
df_read_4_fund_cd_function_cbm008 = df_read_4_fund_cd_function_cbm008.join(
    read_table(f"{student}.{bronze}.PS_UTA_HR_ACCTCDCA").alias(
        "PS_UTA_HR_ACCTCDCA"
    ),
    (F.col("acct_cd_redistributed.ACCT_CD") == F.col("ps_uta_hr_acctcdca.ACCT_CD")),
    "left",
)
df_read_4_fund_cd_function_cbm008 = df_read_4_fund_cd_function_cbm008.select(
    F.col("acct_cd_redistributed.SSN"),
    F.col("acct_cd_redistributed.ACCT_CD"),
    F.col("acct_cd_redistributed.DIST_PCT"),
    F.col("ps_uta_hr_acctcdca.CHARTFIELD1"),
    F.col("ps_uta_hr_acctcdca.CLASS_FLD"),
    F.col("ps_uta_hr_acctcdca.FUND_CODE"),
    F.col("acct_cd_redistributed.UTA_HRE_MAJAPPTSEQ"),
    F.col("acct_cd_redistributed.APPT_BEGIN_DT"),
    F.col("acct_cd_redistributed.APPT_END_DT"),
    F.col("acct_cd_redistributed.CBM_TERM"),
    F.col("acct_cd_redistributed.UTSHARE_FISCAL_YEAR"),
    F.col("acct_cd_redistributed.UTA_HRE_MAJORTITLE"),
    F.col("acct_cd_redistributed.STRM"),
    F.col("acct_cd_redistributed.TERM_END_DT"),
    F.col("acct_cd_redistributed.CENSUS_DT"),
    F.col("acct_cd_redistributed.UTA_HRE_BIRTH_DATE"),
    F.col("acct_cd_redistributed.UTA_HRE_GENDER"),
    F.col("acct_cd_redistributed.UTA_HRE_NAME_UL"),
    F.col("acct_cd_redistributed.UTA_HRE_CNT_SVC_DT"),
    F.col("acct_cd_redistributed.COMPRATE"),
    F.col("acct_cd_redistributed.POSITION_NBR"),
    F.col("acct_cd_redistributed.STD_HOURS"),
    # SAS INPUT(...,BEST8.) handles whitespace; Python cast needs explicit trim
    F.trim(F.col("ps_uta_hr_acctcdca.CLASS_FLD")).cast("BIGINT").alias("CLASS_FLD_NBR"),
    F.col("acct_cd_redistributed.COMPLIANCE"),
    F.col("acct_cd_redistributed.ACAD_YEAR"),
    F.col("acct_cd_redistributed.UTA_HRE_STATUS"),
    F.col("acct_cd_redistributed.SOURCE"),
    F.col("acct_cd_redistributed.TERM_BEGIN_DT"),
)

# COMMAND ----------

# Checkpoint X: materialize df_read_4_fund_cd_function_cbm008 to break the upstream
# DAG (Steps 1-29) at the midpoint of cells 2-107. Without this, Steps 30-60 each
# re-analyze the full ~29-step lineage, contributing ~1.5 min of the 3m 21s phase.
# Temp table is dropped immediately after the Step 98 write completes.
_tmp_stageX_tbl = f"{analytics}.{staging}._tmp_cbm008_stageX_read4fundcd"
write_df_to_table(
    df_read_4_fund_cd_function_cbm008,
    _tmp_stageX_tbl,
    mode="overwrite",
    overwriteSchema="true",
)
df_read_4_fund_cd_function_cbm008 = read_table(_tmp_stageX_tbl).alias(
    "READ_4_FUND_CD_FUNCTION_CBM008"
)
log_msg(f"Checkpoint X materialized: {_tmp_stageX_tbl}")
log_view_count(
    "READ_4_FUND_CD_FUNCTION_CBM008 (Checkpoint X)",
    df_read_4_fund_cd_function_cbm008,
    do_count=True,
)

# COMMAND ----------

# Step 30: LOOKUP_EMPLID
# Create temp view: EMPLID_LOOKUP
df_emplid_lookup = df_read_4_fund_cd_function_cbm008.alias(
    "READ_4_FUND_CD_FUNCTION_CBM008"
)
df_emplid_lookup = df_emplid_lookup.join(
    read_table(f"{student}.{bronze}.PS_PERS_NID").alias("PS_PERS_NID"),
    (F.col("read_4_fund_cd_function_cbm008.SSN") == F.col("ps_pers_nid.NATIONAL_ID")),
    "left",
)
df_emplid_lookup = df_emplid_lookup.select(
    F.col("read_4_fund_cd_function_cbm008.SSN"),
    F.col("read_4_fund_cd_function_cbm008.ACCT_CD"),
    F.col("read_4_fund_cd_function_cbm008.DIST_PCT"),
    F.col("read_4_fund_cd_function_cbm008.CHARTFIELD1"),
    F.col("read_4_fund_cd_function_cbm008.CLASS_FLD"),
    F.col("read_4_fund_cd_function_cbm008.FUND_CODE"),
    F.col("ps_pers_nid.EMPLID").alias("CIT_CHK_EMPLID_PERS_NID"),
    F.col("read_4_fund_cd_function_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_4_fund_cd_function_cbm008.APPT_BEGIN_DT"),
    F.col("read_4_fund_cd_function_cbm008.APPT_END_DT"),
    F.col("read_4_fund_cd_function_cbm008.CBM_TERM"),
    F.col("read_4_fund_cd_function_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("read_4_fund_cd_function_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("read_4_fund_cd_function_cbm008.STRM"),
    F.col("read_4_fund_cd_function_cbm008.TERM_END_DT"),
    F.col("read_4_fund_cd_function_cbm008.CENSUS_DT"),
    F.col("read_4_fund_cd_function_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_4_fund_cd_function_cbm008.UTA_HRE_GENDER"),
    F.col("read_4_fund_cd_function_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_4_fund_cd_function_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_4_fund_cd_function_cbm008.COMPRATE"),
    F.col("read_4_fund_cd_function_cbm008.POSITION_NBR"),
    F.col("read_4_fund_cd_function_cbm008.STD_HOURS"),
    F.col("read_4_fund_cd_function_cbm008.CLASS_FLD_NBR"),
    F.col("read_4_fund_cd_function_cbm008.COMPLIANCE"),
    F.col("read_4_fund_cd_function_cbm008.ACAD_YEAR"),
    F.col("read_4_fund_cd_function_cbm008.UTA_HRE_STATUS"),
    F.col("read_4_fund_cd_function_cbm008.SOURCE"),
    F.col("read_4_fund_cd_function_cbm008.TERM_BEGIN_DT"),
)
log_view_count("EMPLID_LOOKUP (LOOKUP_EMPLID)", df_emplid_lookup)

# COMMAND ----------

# Step 31: NAMES_MAX_EFFDT
# Create temp view: NAMES_MAX_EFFDT_CBM008
df_names_max_effdt_cbm008 = read_table(f"{student}.{bronze}.PS_NAMES").alias(
    "PS_NAMES"
)
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.filter(
    (
        (
            (F.col("ps_names.NAME_TYPE") == F.lit("PRI"))
            & ~F.upper(F.col("ps_names.NAME")).contains("DO NOT USE")
        )
        & (F.col("ps_names.EFFDT") <= F.current_timestamp())
    )
)
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_names.EFFDT")).over(Window.partitionBy("ps_names.EMPLID")),
)
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.filter(
    (F.col("ps_names.EFFDT") == F.col("_agg_tmp_0"))
)
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.drop("_agg_tmp_0")
df_names_max_effdt_cbm008 = df_names_max_effdt_cbm008.select(F.col("ps_names.EMPLID"))
log_view_count("NAMES_MAX_EFFDT_CBM008", df_names_max_effdt_cbm008)

# COMMAND ----------

# Step 32: EMPLID_IN_NAMES_CHECK
# Create temp view: EMPLID_IN_NAMES_CHECK_CBM008
df_emplid_in_names_check_cbm008 = read_table(
    f"{student}.{bronze}.PS_UTA_HR_PS_EMP"
).alias("PS_UTA_HR_PS_EMP")
df_emplid_in_names_check_cbm008 = df_emplid_in_names_check_cbm008.join(
    df_names_max_effdt_cbm008.alias("NAMES_MAX_EFFDT_CBM008"),
    (F.col("ps_uta_hr_ps_emp.EMPLID") == F.col("names_max_effdt_cbm008.EMPLID")),
    "left",
)
df_emplid_in_names_check_cbm008 = df_emplid_in_names_check_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_uta_hr_ps_emp.UTA_HR_ASOFDATE")).over(
        Window.partitionBy("ps_uta_hr_ps_emp.NATIONAL_ID")
    ),
)
df_emplid_in_names_check_cbm008 = df_emplid_in_names_check_cbm008.filter(
    (F.col("ps_uta_hr_ps_emp.UTA_HR_ASOFDATE") == F.col("_agg_tmp_0"))
)
df_emplid_in_names_check_cbm008 = df_emplid_in_names_check_cbm008.drop("_agg_tmp_0")
df_emplid_in_names_check_cbm008 = df_emplid_in_names_check_cbm008.select(
    F.col("ps_uta_hr_ps_emp.EMPLID"),
    F.col("ps_uta_hr_ps_emp.NATIONAL_ID"),
    F.when(
        (
            F.col("names_max_effdt_cbm008.EMPLID").isNull()
            | (F.col("names_max_effdt_cbm008.EMPLID") == F.lit(""))
        ),
        F.lit("N"),
    )
    .otherwise(F.lit("Y"))
    .alias("FOUND_IN_NAMES"),
    F.col("ps_uta_hr_ps_emp.ACTION_DT"),
)
df_emplid_in_names_check_cbm008 = df_emplid_in_names_check_cbm008.distinct()
log_view_count("EMPLID_IN_NAMES_CHECK_CBM008", df_emplid_in_names_check_cbm008)

# COMMAND ----------

# Step 33: HR_PS_EMP_MAX_ACTION_ASOFDT
# Create temp view: EMP_MAX_ACTION_ASOFDT_CBM008
df_emp_max_action_asofdt_cbm008 = df_emplid_in_names_check_cbm008.alias(
    "EMPLID_IN_NAMES_CHECK_CBM008"
)
df_emp_max_action_asofdt_cbm008 = df_emp_max_action_asofdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("emplid_in_names_check_cbm008.ACTION_DT")).over(
        Window.partitionBy("emplid_in_names_check_cbm008.NATIONAL_ID")
    ),
)
df_emp_max_action_asofdt_cbm008 = df_emp_max_action_asofdt_cbm008.filter(
    (F.col("emplid_in_names_check_cbm008.ACTION_DT") == F.col("_agg_tmp_0"))
)
df_emp_max_action_asofdt_cbm008 = df_emp_max_action_asofdt_cbm008.drop("_agg_tmp_0")
df_emp_max_action_asofdt_cbm008 = df_emp_max_action_asofdt_cbm008.select(
    F.col("emplid_in_names_check_cbm008.EMPLID"),
    F.col("emplid_in_names_check_cbm008.NATIONAL_ID"),
    F.col("emplid_in_names_check_cbm008.FOUND_IN_NAMES"),
)
log_view_count("EMP_MAX_ACTION_ASOFDT_CBM008", df_emp_max_action_asofdt_cbm008)

# COMMAND ----------

# Step 34: LOOKUP_EMPLID_EXTERNAL_SYS
# Create temp view: EMPLID_EXT_SYS
df_emplid_ext_sys = df_emplid_lookup.alias("EMPLID_LOOKUP")
df_emplid_ext_sys = df_emplid_ext_sys.join(
    df_emp_max_action_asofdt_cbm008.alias("EMP_MAX_ACTION_ASOFDT_CBM008"),
    (
        (
            F.col("emplid_lookup.CIT_CHK_EMPLID_PERS_NID").isNull()
            | (F.col("emplid_lookup.CIT_CHK_EMPLID_PERS_NID") == F.lit(""))
        )
        & (
            F.col("emplid_lookup.SSN")
            == F.col("emp_max_action_asofdt_cbm008.NATIONAL_ID")
        )
    ),
    "left",
)
df_emplid_ext_sys = df_emplid_ext_sys.select(
    F.col("emplid_lookup.SSN"),
    F.col("emplid_lookup.ACCT_CD"),
    F.col("emplid_lookup.DIST_PCT"),
    F.col("emplid_lookup.CHARTFIELD1"),
    F.col("emplid_lookup.CLASS_FLD"),
    F.col("emplid_lookup.FUND_CODE"),
    F.col("emplid_lookup.CIT_CHK_EMPLID_PERS_NID"),
    F.col("emp_max_action_asofdt_cbm008.EMPLID").alias("CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("emp_max_action_asofdt_cbm008.FOUND_IN_NAMES"),
    F.col("emplid_lookup.UTA_HRE_MAJAPPTSEQ"),
    F.col("emplid_lookup.APPT_BEGIN_DT"),
    F.col("emplid_lookup.APPT_END_DT"),
    F.col("emplid_lookup.CBM_TERM"),
    F.col("emplid_lookup.UTSHARE_FISCAL_YEAR"),
    F.col("emplid_lookup.UTA_HRE_MAJORTITLE"),
    F.col("emplid_lookup.STRM"),
    F.col("emplid_lookup.TERM_END_DT"),
    F.col("emplid_lookup.CENSUS_DT"),
    F.col("emplid_lookup.UTA_HRE_BIRTH_DATE"),
    F.col("emplid_lookup.UTA_HRE_GENDER"),
    F.col("emplid_lookup.UTA_HRE_NAME_UL"),
    F.col("emplid_lookup.UTA_HRE_CNT_SVC_DT"),
    F.col("emplid_lookup.COMPRATE"),
    F.col("emplid_lookup.POSITION_NBR"),
    F.col("emplid_lookup.STD_HOURS"),
    F.col("emplid_lookup.CLASS_FLD_NBR"),
    F.col("emplid_lookup.COMPLIANCE"),
    F.col("emplid_lookup.ACAD_YEAR"),
    F.col("emplid_lookup.UTA_HRE_STATUS"),
    F.col("emplid_lookup.SOURCE"),
    F.col("emplid_lookup.TERM_BEGIN_DT"),
)
log_view_count("EMPLID_EXT_SYS (LOOKUP_EMPLID_EXTERNAL_SYS)", df_emplid_ext_sys)

# COMMAND ----------

# Step 35: LOOKUP_EMPLID_EXTERNAL_SYS_CB
# Create temp view: EMPLID_EXT_SYS_CB
df_emplid_ext_sys_cb = df_emplid_ext_sys.alias("EMPLID_EXT_SYS")
df_emplid_ext_sys_cb = df_emplid_ext_sys_cb.join(
    read_table(f"{student}.{bronze}.PS_EXTERNAL_SYSTEM").alias(
        "PS_EXTERNAL_SYSTEM"
    ),
    (
        (
            (
                (
                    F.col("emplid_ext_sys.CIT_CHK_EMPLID_PERS_NID").isNull()
                    | (F.col("emplid_ext_sys.CIT_CHK_EMPLID_PERS_NID") == F.lit(""))
                )
                & (
                    F.col("emplid_ext_sys.CIT_CHK_EMPLID_HR_PS_EMP").isNull()
                    | (F.col("emplid_ext_sys.CIT_CHK_EMPLID_HR_PS_EMP") == F.lit(""))
                )
            )
            & (
                F.col("emplid_ext_sys.SSN")
                == F.col("ps_external_system.EXTERNAL_SYSTEM_ID")
            )
        )
        & (F.col("ps_external_system.EXTERNAL_SYSTEM") == F.lit("CB_ID"))
    ),
    "left",
)
df_emplid_ext_sys_cb = df_emplid_ext_sys_cb.select(
    F.col("emplid_ext_sys.SSN"),
    F.col("emplid_ext_sys.ACCT_CD"),
    F.col("emplid_ext_sys.DIST_PCT"),
    F.col("emplid_ext_sys.CHARTFIELD1"),
    F.col("emplid_ext_sys.CLASS_FLD"),
    F.col("emplid_ext_sys.FUND_CODE"),
    F.col("emplid_ext_sys.CIT_CHK_EMPLID_PERS_NID"),
    F.col("emplid_ext_sys.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("emplid_ext_sys.FOUND_IN_NAMES"),
    F.col("ps_external_system.EMPLID").alias("CIT_CHK_EMPLID_EXT_SYS"),
    F.when(
        F.col("ps_external_system.EMPLID").isNotNull(),
        F.col("ps_external_system.EMPLID"),
    )
    .otherwise(
        F.when(
            F.col("emplid_ext_sys.CIT_CHK_EMPLID_HR_PS_EMP").isNotNull(),
            F.col("emplid_ext_sys.CIT_CHK_EMPLID_HR_PS_EMP"),
        ).otherwise(F.col("emplid_ext_sys.CIT_CHK_EMPLID_PERS_NID"))
    )
    .alias("CIT_CHK_EMPLID"),
    F.col("emplid_ext_sys.UTA_HRE_MAJAPPTSEQ"),
    F.col("emplid_ext_sys.APPT_BEGIN_DT"),
    F.col("emplid_ext_sys.APPT_END_DT"),
    F.col("emplid_ext_sys.CBM_TERM"),
    F.col("emplid_ext_sys.UTSHARE_FISCAL_YEAR"),
    F.col("emplid_ext_sys.UTA_HRE_MAJORTITLE"),
    F.col("emplid_ext_sys.STRM"),
    F.col("emplid_ext_sys.TERM_END_DT"),
    F.col("emplid_ext_sys.CENSUS_DT"),
    F.col("emplid_ext_sys.UTA_HRE_BIRTH_DATE"),
    F.col("emplid_ext_sys.UTA_HRE_GENDER"),
    F.col("emplid_ext_sys.UTA_HRE_NAME_UL"),
    F.col("emplid_ext_sys.UTA_HRE_CNT_SVC_DT"),
    F.col("emplid_ext_sys.COMPRATE"),
    F.col("emplid_ext_sys.POSITION_NBR"),
    F.col("emplid_ext_sys.STD_HOURS"),
    F.col("emplid_ext_sys.CLASS_FLD_NBR"),
    F.col("emplid_ext_sys.COMPLIANCE"),
    F.col("emplid_ext_sys.ACAD_YEAR"),
    F.col("emplid_ext_sys.UTA_HRE_STATUS"),
    F.col("emplid_ext_sys.SOURCE"),
    F.col("emplid_ext_sys.TERM_BEGIN_DT"),
)
df_emplid_ext_sys_cb = df_emplid_ext_sys_cb.distinct()
log_view_count(
    "EMPLID_EXT_SYS_CB (LOOKUP_EMPLID_EXTERNAL_SYS_CB)", df_emplid_ext_sys_cb
)

# COMMAND ----------

# Step 36: HRA_BEGIN_AND_END_DT
# Create temp view: HRA_BEGIN_AND_END_DT_CBM008
df_hra_begin_and_end_dt_cbm008 = df_emplid_ext_sys_cb.alias("EMPLID_EXT_SYS_CB")
df_hra_begin_and_end_dt_cbm008 = df_hra_begin_and_end_dt_cbm008.select(
    F.col("emplid_ext_sys_cb.SSN"),
    F.col("emplid_ext_sys_cb.ACCT_CD"),
    F.col("emplid_ext_sys_cb.DIST_PCT"),
    F.col("emplid_ext_sys_cb.CHARTFIELD1"),
    F.col("emplid_ext_sys_cb.CLASS_FLD"),
    F.col("emplid_ext_sys_cb.FUND_CODE"),
    F.col("emplid_ext_sys_cb.CIT_CHK_EMPLID_PERS_NID"),
    F.col("emplid_ext_sys_cb.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("emplid_ext_sys_cb.FOUND_IN_NAMES"),
    F.col("emplid_ext_sys_cb.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("emplid_ext_sys_cb.CIT_CHK_EMPLID"),
    F.col("emplid_ext_sys_cb.UTA_HRE_MAJAPPTSEQ"),
    F.col("emplid_ext_sys_cb.APPT_BEGIN_DT"),
    F.col("emplid_ext_sys_cb.APPT_END_DT"),
    F.col("emplid_ext_sys_cb.CBM_TERM"),
    F.col("emplid_ext_sys_cb.UTSHARE_FISCAL_YEAR"),
    F.col("emplid_ext_sys_cb.UTA_HRE_MAJORTITLE"),
    F.col("emplid_ext_sys_cb.STRM"),
    F.col("emplid_ext_sys_cb.TERM_END_DT"),
    F.col("emplid_ext_sys_cb.CENSUS_DT"),
    F.col("emplid_ext_sys_cb.UTA_HRE_BIRTH_DATE"),
    F.col("emplid_ext_sys_cb.UTA_HRE_GENDER"),
    F.col("emplid_ext_sys_cb.UTA_HRE_NAME_UL"),
    F.col("emplid_ext_sys_cb.UTA_HRE_CNT_SVC_DT"),
    F.col("emplid_ext_sys_cb.COMPRATE"),
    F.col("emplid_ext_sys_cb.POSITION_NBR"),
    F.col("emplid_ext_sys_cb.STD_HOURS"),
    F.col("emplid_ext_sys_cb.CLASS_FLD_NBR"),
    F.col("emplid_ext_sys_cb.COMPLIANCE"),
    F.col("emplid_ext_sys_cb.ACAD_YEAR"),
    F.col("emplid_ext_sys_cb.UTA_HRE_STATUS"),
    F.col("emplid_ext_sys_cb.SOURCE"),
    F.col("emplid_ext_sys_cb.TERM_BEGIN_DT"),
)
log_view_count("HRA_BEGIN_AND_END_DT_CBM008", df_hra_begin_and_end_dt_cbm008)

# COMMAND ----------

# Step 37: DAYS_IN_APPT
# Create temp view: DAYS_IN_APPT_CBM008
df_days_in_appt_cbm008 = df_hra_begin_and_end_dt_cbm008.alias(
    "HRA_BEGIN_AND_END_DT_CBM008"
)
df_days_in_appt_cbm008 = df_days_in_appt_cbm008.select(
    F.col("hra_begin_and_end_dt_cbm008.SSN"),
    F.col("hra_begin_and_end_dt_cbm008.ACCT_CD"),
    F.col("hra_begin_and_end_dt_cbm008.DIST_PCT"),
    F.col("hra_begin_and_end_dt_cbm008.CHARTFIELD1"),
    F.col("hra_begin_and_end_dt_cbm008.CLASS_FLD"),
    F.col("hra_begin_and_end_dt_cbm008.FUND_CODE"),
    F.col("hra_begin_and_end_dt_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("hra_begin_and_end_dt_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("hra_begin_and_end_dt_cbm008.FOUND_IN_NAMES"),
    F.col("hra_begin_and_end_dt_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("hra_begin_and_end_dt_cbm008.CIT_CHK_EMPLID"),
    F.col("hra_begin_and_end_dt_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("hra_begin_and_end_dt_cbm008.APPT_BEGIN_DT"),
    F.col("hra_begin_and_end_dt_cbm008.APPT_END_DT"),
    F.col("hra_begin_and_end_dt_cbm008.CBM_TERM"),
    F.col("hra_begin_and_end_dt_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("hra_begin_and_end_dt_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("hra_begin_and_end_dt_cbm008.STRM"),
    F.col("hra_begin_and_end_dt_cbm008.TERM_END_DT"),
    F.col("hra_begin_and_end_dt_cbm008.CENSUS_DT"),
    F.col("hra_begin_and_end_dt_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("hra_begin_and_end_dt_cbm008.UTA_HRE_GENDER"),
    F.col("hra_begin_and_end_dt_cbm008.UTA_HRE_NAME_UL"),
    F.col("hra_begin_and_end_dt_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("hra_begin_and_end_dt_cbm008.COMPRATE"),
    F.col("hra_begin_and_end_dt_cbm008.POSITION_NBR"),
    F.col("hra_begin_and_end_dt_cbm008.STD_HOURS"),
    F.col("hra_begin_and_end_dt_cbm008.CLASS_FLD_NBR"),
    F.col("hra_begin_and_end_dt_cbm008.COMPLIANCE"),
    F.col("hra_begin_and_end_dt_cbm008.ACAD_YEAR"),
    F.col("hra_begin_and_end_dt_cbm008.UTA_HRE_STATUS"),
    F.col("hra_begin_and_end_dt_cbm008.SOURCE"),
    F.col("hra_begin_and_end_dt_cbm008.TERM_BEGIN_DT"),
)
log_view_count("DAYS_IN_APPT_CBM008", df_days_in_appt_cbm008)

# COMMAND ----------

# Step 38: OVLP_REDIS

# Create temp view: OVLP_REDIS_CBM008
df_ovlp_redis_cbm008 = df_days_in_appt_cbm008.alias("DAYS_IN_APPT_CBM008")
df_ovlp_redis_cbm008 = df_ovlp_redis_cbm008.select(
    F.col("days_in_appt_cbm008.SSN"),
    F.col("days_in_appt_cbm008.ACCT_CD"),
    F.col("days_in_appt_cbm008.DIST_PCT"),
    F.col("days_in_appt_cbm008.CHARTFIELD1"),
    F.col("days_in_appt_cbm008.CLASS_FLD"),
    F.col("days_in_appt_cbm008.FUND_CODE"),
    F.col("days_in_appt_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("days_in_appt_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("days_in_appt_cbm008.FOUND_IN_NAMES"),
    F.col("days_in_appt_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("days_in_appt_cbm008.CIT_CHK_EMPLID"),
    F.col("days_in_appt_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("days_in_appt_cbm008.APPT_BEGIN_DT"),
    F.col("days_in_appt_cbm008.APPT_END_DT"),
    # SAS: (STD_HOURS/40)*DIST_PCT - add null/empty handling to match OVLP_ALLOC_REDIS pattern
    F.when(
        (
            (
                F.col("days_in_appt_cbm008.DIST_PCT").isNull()
                | (F.col("days_in_appt_cbm008.DIST_PCT") == F.lit(""))
            )
            | (
                F.col("days_in_appt_cbm008.STD_HOURS").isNull()
                | (F.col("days_in_appt_cbm008.STD_HOURS") == F.lit(""))
            )
        ),
        F.lit(0),
    )
    .otherwise(
        (F.col("days_in_appt_cbm008.STD_HOURS") / F.lit(40))
        * F.col("days_in_appt_cbm008.DIST_PCT")
    )
    .alias("OVLP_PERCENT_TIME_REDIS"),
    F.when(
        (
            (
                F.col("days_in_appt_cbm008.DIST_PCT").isNull()
                | (F.col("days_in_appt_cbm008.DIST_PCT") == F.lit(""))
            )
            | (
                F.col("days_in_appt_cbm008.COMPRATE").isNull()
                | (F.col("days_in_appt_cbm008.COMPRATE") == F.lit(""))
            )
        ),
        F.lit(0),
    )
    .otherwise(
        (
            (
                F.col("days_in_appt_cbm008.COMPRATE")
                * F.col("days_in_appt_cbm008.DIST_PCT")
            )
            / F.lit(100)
        )
    )
    .alias("OVLP_ALLOC_REDIS"),
    F.col("days_in_appt_cbm008.CBM_TERM"),
    F.col("days_in_appt_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("days_in_appt_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("days_in_appt_cbm008.STRM"),
    F.col("days_in_appt_cbm008.TERM_END_DT"),
    F.col("days_in_appt_cbm008.CENSUS_DT"),
    F.col("days_in_appt_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("days_in_appt_cbm008.UTA_HRE_GENDER"),
    F.col("days_in_appt_cbm008.UTA_HRE_NAME_UL"),
    F.col("days_in_appt_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("days_in_appt_cbm008.CLASS_FLD_NBR"),
    F.col("days_in_appt_cbm008.COMPLIANCE"),
    F.col("days_in_appt_cbm008.ACAD_YEAR"),
    F.col("days_in_appt_cbm008.UTA_HRE_STATUS"),
    F.col("days_in_appt_cbm008.SOURCE"),
    F.col("days_in_appt_cbm008.TERM_BEGIN_DT"),
)
log_view_count("OVLP_REDIS_CBM008", df_ovlp_redis_cbm008)

# COMMAND ----------

# Step 39: SALARY_AND_PCT_TIME
# Create temp view: SALARY_AND_PCT_TIME_CBM008
df_salary_and_pct_time_cbm008 = df_ovlp_redis_cbm008.alias("OVLP_REDIS_CBM008")
_winSpec_2 = Window.partitionBy(
    F.col("ovlp_redis_cbm008.SSN"), F.col("ovlp_redis_cbm008.STRM")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_0_0",
    F.sum(
        F.when(
            (
                (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") >= F.lit(100))
                & (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") <= F.lit(199))
            ),
            F.col("ovlp_redis_cbm008.OVLP_PERCENT_TIME_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "PCT_TIME_A", F.col("_sel_tmp_0_0").cast("INT")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_0_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_1_0",
    F.sum(
        F.when(
            (
                (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") >= F.lit(400))
                & (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") <= F.lit(499))
            ),
            F.col("ovlp_redis_cbm008.OVLP_PERCENT_TIME_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "PCT_TIME_C", F.col("_sel_tmp_1_0").cast("INT")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_1_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_2_0",
    F.sum(
        F.when(
            (
                (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") >= F.lit(200))
                & (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") <= F.lit(203))
            ),
            F.col("ovlp_redis_cbm008.OVLP_PERCENT_TIME_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "PCT_TIME_D", F.col("_sel_tmp_2_0").cast("INT")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_2_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_3_0",
    F.sum(
        F.when(
            (
                (
                    (
                        (
                            (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") >= F.lit(300))
                            & (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") <= F.lit(399))
                        )
                        | (
                            (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") >= F.lit(500))
                            & (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") <= F.lit(899))
                        )
                    )
                    | (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") == F.lit(997))
                )
                | (F.col("ovlp_redis_cbm008.CLASS_FLD_NBR") >= F.lit(999))
            ),
            F.col("ovlp_redis_cbm008.OVLP_PERCENT_TIME_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "PCT_TIME_E", F.col("_sel_tmp_3_0").cast("INT")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_3_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_4_0",
    F.sum(
        F.when(
            (F.substring(F.col("ovlp_redis_cbm008.FUND_CODE"), 1, 2) == F.lit("21")),
            F.col("ovlp_redis_cbm008.OVLP_ALLOC_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "SALARY_A", F.col("_sel_tmp_4_0").cast("INT")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_4_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_5_0",
    F.sum(
        F.when(
            F.substring(F.col("ovlp_redis_cbm008.FUND_CODE"), 1, 2).isin(["31", "32"]),
            F.col("ovlp_redis_cbm008.OVLP_ALLOC_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)

# COMMAND ----------

df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "SALARY_D", F.col("_sel_tmp_5_0").cast("INT")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_5_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_6_0",
    F.sum(
        F.when(
            (F.substring(F.col("ovlp_redis_cbm008.FUND_CODE"), 1, 1) == F.lit("4")),
            F.col("ovlp_redis_cbm008.OVLP_ALLOC_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "SALARY_X", F.col("_sel_tmp_6_0").cast("INT")
)

# COMMAND ----------

df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_6_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_7_0",
    F.sum(
        F.when(
            F.col("ovlp_redis_cbm008.FUND_CODE").isin(
                ["5100", "5200", "5300", "5400", "5500", "5600"]
            ),
            F.col("ovlp_redis_cbm008.OVLP_ALLOC_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "SALARY_R", F.col("_sel_tmp_7_0").cast("INT")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_7_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "_sel_tmp_8_0",
    F.sum(
        F.when(
            (
                (
                    ~F.col("ovlp_redis_cbm008.FUND_CODE").isin(
                        ["5100", "5200", "5300", "5400", "5500", "5600"]
                    )
                    & (
                        F.substring(F.col("ovlp_redis_cbm008.FUND_CODE"), 1, 1)
                        != F.lit("4")
                    )
                )
                & ~F.substring(F.col("ovlp_redis_cbm008.FUND_CODE"), 1, 2).isin(
                    ["21", "31", "32"]
                )
            ),
            F.col("ovlp_redis_cbm008.OVLP_ALLOC_REDIS"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_2),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.withColumn(
    "SALARY_Z", F.col("_sel_tmp_8_0").cast("INT")
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.drop("_sel_tmp_8_0")
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.select(
    F.col("ovlp_redis_cbm008.SSN"),
    F.col("ovlp_redis_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("ovlp_redis_cbm008.FOUND_IN_NAMES"),
    F.col("ovlp_redis_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("ovlp_redis_cbm008.CIT_CHK_EMPLID"),
    F.col("ovlp_redis_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("ovlp_redis_cbm008.APPT_BEGIN_DT"),
    F.col("ovlp_redis_cbm008.APPT_END_DT"),
    F.col("PCT_TIME_A"),
    F.col("PCT_TIME_C"),
    F.col("PCT_TIME_D"),
    F.col("PCT_TIME_E"),
    F.col("SALARY_A"),
    F.col("SALARY_D"),
    F.col("SALARY_X"),
    F.col("SALARY_R"),
    F.col("SALARY_Z"),
    F.col("ovlp_redis_cbm008.CBM_TERM"),
    F.col("ovlp_redis_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("ovlp_redis_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("ovlp_redis_cbm008.STRM"),
    F.col("ovlp_redis_cbm008.TERM_END_DT"),
    F.col("ovlp_redis_cbm008.CENSUS_DT"),
    F.col("ovlp_redis_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("ovlp_redis_cbm008.UTA_HRE_GENDER"),
    F.col("ovlp_redis_cbm008.UTA_HRE_NAME_UL"),
    F.col("ovlp_redis_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("ovlp_redis_cbm008.COMPLIANCE"),
    F.col("ovlp_redis_cbm008.ACAD_YEAR"),
    F.col("ovlp_redis_cbm008.UTA_HRE_STATUS"),
    F.col("ovlp_redis_cbm008.SOURCE"),
    F.col("ovlp_redis_cbm008.TERM_BEGIN_DT"),
)
df_salary_and_pct_time_cbm008 = df_salary_and_pct_time_cbm008.distinct()
log_view_count("SALARY_AND_PCT_TIME_CBM008", df_salary_and_pct_time_cbm008)

# COMMAND ----------

# Step 40: READ_4_ADDL_PAY
# Create temp view: READ_4_ADDL_PAY_CBM008
df_read_4_addl_pay_cbm008 = df_salary_and_pct_time_cbm008.alias(
    "SALARY_AND_PCT_TIME_CBM008"
)
df_read_4_addl_pay_cbm008 = df_read_4_addl_pay_cbm008.join(
    read_table(f"{student}.{bronze}.PS_UTA_HR_ADDL_PAY").alias(
        "PS_UTA_HR_ADDL_PAY"
    ),
    (
        (
            (
                F.col("salary_and_pct_time_cbm008.CIT_CHK_EMPLID")
                == F.col("ps_uta_hr_addl_pay.EMPLID")
            )
            & (
                F.col("ps_uta_hr_addl_pay.EFFDT").cast("DATE")
                >= F.expr(
                    "TO_DATE(salary_and_pct_time_cbm008.APPT_BEGIN_DT, 'yyyyMMdd')"
                )
            )
        )
        & (
            F.col("ps_uta_hr_addl_pay.EFFDT").cast("DATE")
            <= F.expr("TO_DATE(salary_and_pct_time_cbm008.APPT_END_DT, 'yyyyMMdd')")
        )
    ),
    "left",
)
df_read_4_addl_pay_cbm008 = df_read_4_addl_pay_cbm008.filter(
    (
        F.col("salary_and_pct_time_cbm008.CIT_CHK_EMPLID").isNotNull()
        & (F.col("salary_and_pct_time_cbm008.CIT_CHK_EMPLID") != F.lit(""))
    )
)
df_read_4_addl_pay_cbm008 = df_read_4_addl_pay_cbm008.select(
    F.col("salary_and_pct_time_cbm008.SSN"),
    F.col("salary_and_pct_time_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("salary_and_pct_time_cbm008.FOUND_IN_NAMES"),
    F.col("salary_and_pct_time_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("salary_and_pct_time_cbm008.CIT_CHK_EMPLID"),
    F.col("salary_and_pct_time_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("salary_and_pct_time_cbm008.APPT_BEGIN_DT"),
    F.col("salary_and_pct_time_cbm008.APPT_END_DT"),
    F.col("salary_and_pct_time_cbm008.PCT_TIME_A"),
    F.col("salary_and_pct_time_cbm008.PCT_TIME_C"),
    F.col("salary_and_pct_time_cbm008.PCT_TIME_D"),
    F.col("salary_and_pct_time_cbm008.PCT_TIME_E"),
    F.col("salary_and_pct_time_cbm008.SALARY_A"),
    F.col("salary_and_pct_time_cbm008.SALARY_D"),
    F.col("salary_and_pct_time_cbm008.SALARY_X"),
    F.col("salary_and_pct_time_cbm008.SALARY_R"),
    F.col("salary_and_pct_time_cbm008.SALARY_Z"),
    F.col("salary_and_pct_time_cbm008.CBM_TERM"),
    F.col("ps_uta_hr_addl_pay.EMPL_RCD"),
    F.col("ps_uta_hr_addl_pay.EFFDT").alias("EFFDT_UTA_HR_ADDL_PAY"),
    F.col("ps_uta_hr_addl_pay.ACCT_CD").alias("ADDL_PAY_ACCT_CD"),
    F.col("ps_uta_hr_addl_pay.OTH_PAY").alias("ADDL_PAY_OTH_PAY"),
    F.col("salary_and_pct_time_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("salary_and_pct_time_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("salary_and_pct_time_cbm008.STRM"),
    F.col("salary_and_pct_time_cbm008.TERM_END_DT"),
    F.col("salary_and_pct_time_cbm008.CENSUS_DT"),
    F.col("salary_and_pct_time_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("salary_and_pct_time_cbm008.UTA_HRE_GENDER"),
    F.col("salary_and_pct_time_cbm008.UTA_HRE_NAME_UL"),
    F.col("salary_and_pct_time_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("salary_and_pct_time_cbm008.COMPLIANCE"),
    F.col("salary_and_pct_time_cbm008.ACAD_YEAR"),
    F.col("salary_and_pct_time_cbm008.UTA_HRE_STATUS"),
    F.col("salary_and_pct_time_cbm008.SOURCE"),
    F.col("salary_and_pct_time_cbm008.TERM_BEGIN_DT"),
)
log_view_count("READ_4_ADDL_PAY_CBM008", df_read_4_addl_pay_cbm008)

# COMMAND ----------

# Step 41: JOB_MAX_EFFDT
# Create temp view: JOB_MAX_EFFDT_CBM008
df_job_max_effdt_cbm008 = read_table(f"{student}.{bronze}.PS_JOB").alias("PS_JOB")
df_job_max_effdt_cbm008 = df_job_max_effdt_cbm008.filter(
    (
        (F.col("ps_job.COMPANY") == F.lit("ARL"))
        & (F.col("ps_job.EFFDT") <= F.current_timestamp())
    )
)
df_job_max_effdt_cbm008 = df_job_max_effdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_job.EFFDT")).over(
        Window.partitionBy("ps_job.EMPLID", "ps_job.EMPL_RCD")
    ),
)
df_job_max_effdt_cbm008 = df_job_max_effdt_cbm008.filter(
    (F.col("ps_job.EFFDT") == F.col("_agg_tmp_0"))
)
df_job_max_effdt_cbm008 = df_job_max_effdt_cbm008.drop("_agg_tmp_0")
# OPTIMIZATION: Select only columns needed downstream instead of all ~140 PS_JOB columns.
# Step 42 window needs EFFSEQ; Step 43 join uses EMPLID, EMPL_RCD and selects POSITION_NBR.
df_job_max_effdt_cbm008 = df_job_max_effdt_cbm008.select(
    F.col("ps_job.EMPLID"),
    F.col("ps_job.EMPL_RCD"),
    F.col("ps_job.EFFDT"),
    F.col("ps_job.EFFSEQ"),
    F.col("ps_job.POSITION_NBR"),
)
log_view_count("JOB_MAX_EFFDT_CBM008", df_job_max_effdt_cbm008)

# COMMAND ----------

# Step 42: JOB_MAX_EFFSEQ
# Create temp view: JOB_MAX_EFFSEQ_CBM008
df_job_max_effseq_cbm008 = df_job_max_effdt_cbm008.alias("JOB_MAX_EFFDT_CBM008")
df_job_max_effseq_cbm008 = df_job_max_effseq_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("job_max_effdt_cbm008.EFFSEQ")).over(
        Window.partitionBy(
            "job_max_effdt_cbm008.EMPLID", "job_max_effdt_cbm008.EMPL_RCD"
        )
    ),
)
df_job_max_effseq_cbm008 = df_job_max_effseq_cbm008.filter(
    (F.col("job_max_effdt_cbm008.EFFSEQ") == F.col("_agg_tmp_0"))
)
df_job_max_effseq_cbm008 = df_job_max_effseq_cbm008.drop("_agg_tmp_0")
# OPTIMIZATION: Only EMPLID, EMPL_RCD (join keys) and POSITION_NBR (output) needed in Step 43
df_job_max_effseq_cbm008 = df_job_max_effseq_cbm008.select(
    F.col("job_max_effdt_cbm008.EMPLID"),
    F.col("job_max_effdt_cbm008.EMPL_RCD"),
    F.col("job_max_effdt_cbm008.POSITION_NBR"),
)
log_view_count("JOB_MAX_EFFSEQ_CBM008", df_job_max_effseq_cbm008)

# COMMAND ----------

# Step 43: READ_4_JOB_ACCT_CD
# Create temp view: READ_4_JOB_ACCT_CD_CBM008
df_read_4_job_acct_cd_cbm008 = df_read_4_addl_pay_cbm008.alias("READ_4_ADDL_PAY_CBM008")
df_read_4_job_acct_cd_cbm008 = df_read_4_job_acct_cd_cbm008.join(
    df_job_max_effseq_cbm008.alias("JOB_MAX_EFFSEQ_CBM008"),
    (
        (
            F.col("read_4_addl_pay_cbm008.CIT_CHK_EMPLID")
            == F.col("job_max_effseq_cbm008.EMPLID")
        )
        & (
            F.col("read_4_addl_pay_cbm008.EMPL_RCD")
            == F.col("job_max_effseq_cbm008.EMPL_RCD")
        )
    ),
    "left",
)
df_read_4_job_acct_cd_cbm008 = df_read_4_job_acct_cd_cbm008.filter(
    (
        (
            F.col("read_4_addl_pay_cbm008.ADDL_PAY_ACCT_CD").isNull()
            | (F.col("read_4_addl_pay_cbm008.ADDL_PAY_ACCT_CD") == F.lit(""))
        )
        | (F.trim(F.col("read_4_addl_pay_cbm008.ADDL_PAY_ACCT_CD")) == F.lit(""))
    )
)
df_read_4_job_acct_cd_cbm008 = df_read_4_job_acct_cd_cbm008.select(
    F.col("read_4_addl_pay_cbm008.SSN"),
    F.col("read_4_addl_pay_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("read_4_addl_pay_cbm008.FOUND_IN_NAMES"),
    F.col("read_4_addl_pay_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("read_4_addl_pay_cbm008.CIT_CHK_EMPLID"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_4_addl_pay_cbm008.APPT_BEGIN_DT"),
    F.col("read_4_addl_pay_cbm008.APPT_END_DT"),
    F.col("read_4_addl_pay_cbm008.PCT_TIME_A"),
    F.col("read_4_addl_pay_cbm008.PCT_TIME_C"),
    F.col("read_4_addl_pay_cbm008.PCT_TIME_D"),
    F.col("read_4_addl_pay_cbm008.PCT_TIME_E"),
    F.col("read_4_addl_pay_cbm008.SALARY_A"),
    F.col("read_4_addl_pay_cbm008.SALARY_D"),
    F.col("read_4_addl_pay_cbm008.SALARY_X"),
    F.col("read_4_addl_pay_cbm008.SALARY_R"),
    F.col("read_4_addl_pay_cbm008.SALARY_Z"),
    F.col("read_4_addl_pay_cbm008.CBM_TERM"),
    F.col("read_4_addl_pay_cbm008.EMPL_RCD"),
    F.col("read_4_addl_pay_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("read_4_addl_pay_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("read_4_addl_pay_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("job_max_effseq_cbm008.POSITION_NBR"),
    F.col("read_4_addl_pay_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("read_4_addl_pay_cbm008.STRM"),
    F.col("read_4_addl_pay_cbm008.TERM_END_DT"),
    F.col("read_4_addl_pay_cbm008.CENSUS_DT"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_GENDER"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_4_addl_pay_cbm008.COMPLIANCE"),
    F.col("read_4_addl_pay_cbm008.ACAD_YEAR"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_STATUS"),
    F.col("read_4_addl_pay_cbm008.SOURCE"),
    F.col("read_4_addl_pay_cbm008.TERM_BEGIN_DT"),
)
log_view_count("READ_4_JOB_ACCT_CD_CBM008", df_read_4_job_acct_cd_cbm008)

# COMMAND ----------

# Step 44: ADDL_READ_4_ACCT_CD
# Create temp view: ADDL_READ_4_ACCT_CD_CBM008
df_addl_read_4_acct_cd_cbm008 = df_read_4_job_acct_cd_cbm008.alias(
    "READ_4_JOB_ACCT_CD_CBM008"
)
df_addl_read_4_acct_cd_cbm008 = df_addl_read_4_acct_cd_cbm008.join(
    df_deptbdgt_er_max_effseq_cbm008.alias("DEPTBDGT_ER_MAX_EFFSEQ_CBM008"),
    (
        (
            (
                F.col("read_4_job_acct_cd_cbm008.POSITION_NBR")
                == F.col("deptbdgt_er_max_effseq_cbm008.POSITION_NBR")
            )
            & (
                F.col("read_4_job_acct_cd_cbm008.UTSHARE_FISCAL_YEAR")
                == F.col("deptbdgt_er_max_effseq_cbm008.FISCAL_YEAR")
            )
        )
        & (
            F.col("deptbdgt_er_max_effseq_cbm008.EFFDT")
            <= (
                F.expr(
                    "TO_DATE(read_4_job_acct_cd_cbm008.APPT_END_DT, 'yyyyMMdd')"
                ).cast("TIMESTAMP")
                + F.expr("MAKE_INTERVAL(0, 0, 0, 0, 0, 0)")
            ).cast("TIMESTAMP")
        )
    ),
    "left",
)
df_addl_read_4_acct_cd_cbm008 = df_addl_read_4_acct_cd_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("deptbdgt_er_max_effseq_cbm008.EFFDT")).over(
        Window.partitionBy(
            "read_4_job_acct_cd_cbm008.POSITION_NBR",
            "read_4_job_acct_cd_cbm008.UTSHARE_FISCAL_YEAR",
        )
    ),
)
df_addl_read_4_acct_cd_cbm008 = df_addl_read_4_acct_cd_cbm008.withColumn(
    "_agg_tmp_1",
    F.max(F.col("deptbdgt_er_max_effseq_cbm008.EFFDT")).over(
        Window.partitionBy(
            "read_4_job_acct_cd_cbm008.POSITION_NBR",
            "read_4_job_acct_cd_cbm008.UTSHARE_FISCAL_YEAR",
        )
    ),
)
df_addl_read_4_acct_cd_cbm008 = df_addl_read_4_acct_cd_cbm008.filter(
    (
        F.col("_agg_tmp_0").isNull()
        | (F.col("deptbdgt_er_max_effseq_cbm008.EFFDT") == F.col("_agg_tmp_1"))
    )
)
df_addl_read_4_acct_cd_cbm008 = df_addl_read_4_acct_cd_cbm008.drop(
    "_agg_tmp_0", "_agg_tmp_1"
)
df_addl_read_4_acct_cd_cbm008 = df_addl_read_4_acct_cd_cbm008.select(
    F.col("read_4_job_acct_cd_cbm008.SSN"),
    F.col("read_4_job_acct_cd_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("read_4_job_acct_cd_cbm008.FOUND_IN_NAMES"),
    F.col("read_4_job_acct_cd_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("read_4_job_acct_cd_cbm008.CIT_CHK_EMPLID"),
    F.col("read_4_job_acct_cd_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_4_job_acct_cd_cbm008.APPT_BEGIN_DT"),
    F.col("read_4_job_acct_cd_cbm008.APPT_END_DT"),
    F.col("read_4_job_acct_cd_cbm008.PCT_TIME_A"),
    F.col("read_4_job_acct_cd_cbm008.PCT_TIME_C"),
    F.col("read_4_job_acct_cd_cbm008.PCT_TIME_D"),
    F.col("read_4_job_acct_cd_cbm008.PCT_TIME_E"),
    F.col("read_4_job_acct_cd_cbm008.SALARY_A"),
    F.col("read_4_job_acct_cd_cbm008.SALARY_D"),
    F.col("read_4_job_acct_cd_cbm008.SALARY_X"),
    F.col("read_4_job_acct_cd_cbm008.SALARY_R"),
    F.col("read_4_job_acct_cd_cbm008.SALARY_Z"),
    F.col("read_4_job_acct_cd_cbm008.CBM_TERM"),
    F.col("read_4_job_acct_cd_cbm008.EMPL_RCD"),
    F.col("read_4_job_acct_cd_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("read_4_job_acct_cd_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("read_4_job_acct_cd_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("read_4_job_acct_cd_cbm008.POSITION_NBR"),
    F.col("read_4_job_acct_cd_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("deptbdgt_er_max_effseq_cbm008.ACCT_CD").alias("ACCT_CD_ADDL"),
    F.col("deptbdgt_er_max_effseq_cbm008.DIST_PCT").alias("DIST_PCT_ADDL"),
    F.col("read_4_job_acct_cd_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("read_4_job_acct_cd_cbm008.STRM"),
    F.col("read_4_job_acct_cd_cbm008.TERM_END_DT"),
    F.col("read_4_job_acct_cd_cbm008.CENSUS_DT"),
    F.col("read_4_job_acct_cd_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_4_job_acct_cd_cbm008.UTA_HRE_GENDER"),
    F.col("read_4_job_acct_cd_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_4_job_acct_cd_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_4_job_acct_cd_cbm008.COMPLIANCE"),
    F.col("read_4_job_acct_cd_cbm008.ACAD_YEAR"),
    F.col("read_4_job_acct_cd_cbm008.UTA_HRE_STATUS"),
    F.col("read_4_job_acct_cd_cbm008.SOURCE"),
    F.col("read_4_job_acct_cd_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Set Operators)
# Create temp view: ADDL_ACCT_AND_PAY
df_addl_acct_and_pay_part0 = df_addl_read_4_acct_cd_cbm008.alias(
    "addl_read_4_acct_cd_cbm008"
)
df_addl_acct_and_pay_part0 = df_addl_acct_and_pay_part0.select(
    F.col("addl_read_4_acct_cd_cbm008.SSN"),
    F.col("addl_read_4_acct_cd_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("addl_read_4_acct_cd_cbm008.FOUND_IN_NAMES"),
    F.col("addl_read_4_acct_cd_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("addl_read_4_acct_cd_cbm008.CIT_CHK_EMPLID"),
    F.col("addl_read_4_acct_cd_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("addl_read_4_acct_cd_cbm008.APPT_BEGIN_DT"),
    F.col("addl_read_4_acct_cd_cbm008.APPT_END_DT"),
    F.col("addl_read_4_acct_cd_cbm008.PCT_TIME_A"),
    F.col("addl_read_4_acct_cd_cbm008.PCT_TIME_C"),
    F.col("addl_read_4_acct_cd_cbm008.PCT_TIME_D"),
    F.col("addl_read_4_acct_cd_cbm008.PCT_TIME_E"),
    F.col("addl_read_4_acct_cd_cbm008.SALARY_A"),
    F.col("addl_read_4_acct_cd_cbm008.SALARY_D"),
    F.col("addl_read_4_acct_cd_cbm008.SALARY_X"),
    F.col("addl_read_4_acct_cd_cbm008.SALARY_R"),
    F.col("addl_read_4_acct_cd_cbm008.SALARY_Z"),
    F.col("addl_read_4_acct_cd_cbm008.CBM_TERM"),
    F.col("addl_read_4_acct_cd_cbm008.EMPL_RCD"),
    F.col("addl_read_4_acct_cd_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("addl_read_4_acct_cd_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("addl_read_4_acct_cd_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("addl_read_4_acct_cd_cbm008.POSITION_NBR"),
    F.col("addl_read_4_acct_cd_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("addl_read_4_acct_cd_cbm008.ACCT_CD_ADDL"),
    (F.col("addl_read_4_acct_cd_cbm008.DIST_PCT_ADDL") / F.lit(100)).alias(
        "DIST_PCT_ADDL"
    ),
    F.col("addl_read_4_acct_cd_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("addl_read_4_acct_cd_cbm008.STRM"),
    F.col("addl_read_4_acct_cd_cbm008.TERM_END_DT"),
    F.col("addl_read_4_acct_cd_cbm008.CENSUS_DT"),
    F.col("addl_read_4_acct_cd_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("addl_read_4_acct_cd_cbm008.UTA_HRE_GENDER"),
    F.col("addl_read_4_acct_cd_cbm008.UTA_HRE_NAME_UL"),
    F.col("addl_read_4_acct_cd_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("addl_read_4_acct_cd_cbm008.COMPLIANCE"),
    F.col("addl_read_4_acct_cd_cbm008.ACAD_YEAR"),
    F.col("addl_read_4_acct_cd_cbm008.UTA_HRE_STATUS"),
    F.col("addl_read_4_acct_cd_cbm008.SOURCE"),
    F.col("addl_read_4_acct_cd_cbm008.TERM_BEGIN_DT"),
)
df_addl_acct_and_pay_part1 = df_read_4_addl_pay_cbm008.alias("read_4_addl_pay_cbm008")
df_addl_acct_and_pay_part1 = df_addl_acct_and_pay_part1.filter(
    (
        F.col("read_4_addl_pay_cbm008.ADDL_PAY_ACCT_CD").isNotNull()
        & (F.col("read_4_addl_pay_cbm008.ADDL_PAY_ACCT_CD") != F.lit(""))
    )
)
df_addl_acct_and_pay_part1 = df_addl_acct_and_pay_part1.select(
    F.col("read_4_addl_pay_cbm008.SSN"),
    F.col("read_4_addl_pay_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("read_4_addl_pay_cbm008.FOUND_IN_NAMES"),
    F.col("read_4_addl_pay_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("read_4_addl_pay_cbm008.CIT_CHK_EMPLID"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_4_addl_pay_cbm008.APPT_BEGIN_DT"),
    F.col("read_4_addl_pay_cbm008.APPT_END_DT"),
    F.col("read_4_addl_pay_cbm008.PCT_TIME_A"),
    F.col("read_4_addl_pay_cbm008.PCT_TIME_C"),
    F.col("read_4_addl_pay_cbm008.PCT_TIME_D"),
    F.col("read_4_addl_pay_cbm008.PCT_TIME_E"),
    F.col("read_4_addl_pay_cbm008.SALARY_A"),
    F.col("read_4_addl_pay_cbm008.SALARY_D"),
    F.col("read_4_addl_pay_cbm008.SALARY_X"),
    F.col("read_4_addl_pay_cbm008.SALARY_R"),
    F.col("read_4_addl_pay_cbm008.SALARY_Z"),
    F.col("read_4_addl_pay_cbm008.CBM_TERM"),
    F.col("read_4_addl_pay_cbm008.EMPL_RCD"),
    F.col("read_4_addl_pay_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("read_4_addl_pay_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("read_4_addl_pay_cbm008.ADDL_PAY_OTH_PAY"),
    F.lit("").alias("POSITION_NBR"),
    F.col("read_4_addl_pay_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("read_4_addl_pay_cbm008.ADDL_PAY_ACCT_CD").alias("ACCT_CD_ADDL"),
    F.lit(1).alias("DIST_PCT_ADDL"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("read_4_addl_pay_cbm008.STRM"),
    F.col("read_4_addl_pay_cbm008.TERM_END_DT"),
    F.col("read_4_addl_pay_cbm008.CENSUS_DT"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_GENDER"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_4_addl_pay_cbm008.COMPLIANCE"),
    F.col("read_4_addl_pay_cbm008.ACAD_YEAR"),
    F.col("read_4_addl_pay_cbm008.UTA_HRE_STATUS"),
    F.col("read_4_addl_pay_cbm008.SOURCE"),
    F.col("read_4_addl_pay_cbm008.TERM_BEGIN_DT"),
)
df_addl_acct_and_pay = df_addl_acct_and_pay_part0.union(df_addl_acct_and_pay_part1)
log_view_count("ADDL_ACCT_AND_PAY (ADDL_READ_4_ACCT_CD)", df_addl_acct_and_pay)

# COMMAND ----------

# Step 45: ADDL_READ_4_FUND_CD_FUNCTION
# Create temp view: ADDL_READ_4_FUND_CD_CBM008
df_addl_read_4_fund_cd_cbm008 = df_addl_acct_and_pay.alias("ADDL_ACCT_AND_PAY")
df_addl_read_4_fund_cd_cbm008 = df_addl_read_4_fund_cd_cbm008.join(
    read_table(f"{student}.{bronze}.PS_UTA_HR_ACCTCDCA").alias(
        "PS_UTA_HR_ACCTCDCA"
    ),
    (
        (
            F.col("addl_acct_and_pay.ACCT_CD_ADDL").isNotNull()
            & (F.col("addl_acct_and_pay.ACCT_CD_ADDL") != F.lit(""))
        )
        & (
            F.col("addl_acct_and_pay.ACCT_CD_ADDL")
            == F.col("ps_uta_hr_acctcdca.ACCT_CD")
        )
    ),
    "left",
)
df_addl_read_4_fund_cd_cbm008 = df_addl_read_4_fund_cd_cbm008.select(
    F.col("addl_acct_and_pay.SSN"),
    F.col("addl_acct_and_pay.CIT_CHK_EMPLID_PERS_NID"),
    F.col("addl_acct_and_pay.FOUND_IN_NAMES"),
    F.col("addl_acct_and_pay.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("addl_acct_and_pay.CIT_CHK_EMPLID"),
    F.col("addl_acct_and_pay.EMPL_RCD"),
    F.col("addl_acct_and_pay.UTA_HRE_MAJAPPTSEQ"),
    F.col("addl_acct_and_pay.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("addl_acct_and_pay.APPT_BEGIN_DT"),
    F.col("addl_acct_and_pay.APPT_END_DT"),
    F.col("addl_acct_and_pay.CBM_TERM"),
    F.col("addl_acct_and_pay.UTSHARE_FISCAL_YEAR"),
    F.col("addl_acct_and_pay.ACCT_CD_ADDL"),
    F.col("addl_acct_and_pay.DIST_PCT_ADDL"),
    F.col("addl_acct_and_pay.PCT_TIME_A"),
    F.col("addl_acct_and_pay.PCT_TIME_C"),
    F.col("addl_acct_and_pay.PCT_TIME_D"),
    F.col("addl_acct_and_pay.PCT_TIME_E"),
    F.col("addl_acct_and_pay.SALARY_A"),
    F.col("addl_acct_and_pay.SALARY_D"),
    F.col("addl_acct_and_pay.SALARY_X"),
    F.col("addl_acct_and_pay.SALARY_R"),
    F.col("addl_acct_and_pay.SALARY_Z"),
    F.col("addl_acct_and_pay.ADDL_PAY_ACCT_CD"),
    F.col("addl_acct_and_pay.ADDL_PAY_OTH_PAY"),
    F.col("addl_acct_and_pay.POSITION_NBR"),
    F.col("ps_uta_hr_acctcdca.CLASS_FLD").alias("CLASS_FLD_ADDL"),
    F.col("ps_uta_hr_acctcdca.FUND_CODE").alias("FUND_CODE_ADDL"),
    F.col("addl_acct_and_pay.UTA_HRE_MAJORTITLE"),
    F.col("addl_acct_and_pay.STRM"),
    F.col("addl_acct_and_pay.TERM_END_DT"),
    F.col("addl_acct_and_pay.CENSUS_DT"),
    F.col("addl_acct_and_pay.UTA_HRE_BIRTH_DATE"),
    F.col("addl_acct_and_pay.UTA_HRE_GENDER"),
    F.col("addl_acct_and_pay.UTA_HRE_NAME_UL"),
    F.col("addl_acct_and_pay.UTA_HRE_CNT_SVC_DT"),
    F.col("addl_acct_and_pay.COMPLIANCE"),
    F.col("addl_acct_and_pay.ACAD_YEAR"),
    F.col("addl_acct_and_pay.UTA_HRE_STATUS"),
    F.col("addl_acct_and_pay.SOURCE"),
    F.col("addl_acct_and_pay.TERM_BEGIN_DT"),
)
log_view_count("ADDL_READ_4_FUND_CD_CBM008", df_addl_read_4_fund_cd_cbm008)

# COMMAND ----------

# Step 46: ADDL_OVLP_ALLOC_REDIS
# Create temp view: ADDL_OVLP_ALLOC_REDIS_CBM008
df_addl_ovlp_alloc_redis_cbm008 = df_addl_read_4_fund_cd_cbm008.alias(
    "ADDL_READ_4_FUND_CD_CBM008"
)
df_addl_ovlp_alloc_redis_cbm008 = df_addl_ovlp_alloc_redis_cbm008.select(
    F.col("addl_read_4_fund_cd_cbm008.SSN"),
    F.col("addl_read_4_fund_cd_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("addl_read_4_fund_cd_cbm008.FOUND_IN_NAMES"),
    F.col("addl_read_4_fund_cd_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("addl_read_4_fund_cd_cbm008.CIT_CHK_EMPLID"),
    F.col("addl_read_4_fund_cd_cbm008.EMPL_RCD"),
    F.col("addl_read_4_fund_cd_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("addl_read_4_fund_cd_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("addl_read_4_fund_cd_cbm008.APPT_BEGIN_DT"),
    F.col("addl_read_4_fund_cd_cbm008.APPT_END_DT"),
    F.col("addl_read_4_fund_cd_cbm008.CBM_TERM"),
    F.col("addl_read_4_fund_cd_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("addl_read_4_fund_cd_cbm008.ACCT_CD_ADDL"),
    F.col("addl_read_4_fund_cd_cbm008.DIST_PCT_ADDL"),
    F.col("addl_read_4_fund_cd_cbm008.PCT_TIME_A"),
    F.col("addl_read_4_fund_cd_cbm008.PCT_TIME_C"),
    F.col("addl_read_4_fund_cd_cbm008.PCT_TIME_D"),
    F.col("addl_read_4_fund_cd_cbm008.PCT_TIME_E"),
    F.col("addl_read_4_fund_cd_cbm008.SALARY_A"),
    F.col("addl_read_4_fund_cd_cbm008.SALARY_D"),
    F.col("addl_read_4_fund_cd_cbm008.SALARY_X"),
    F.col("addl_read_4_fund_cd_cbm008.SALARY_R"),
    F.col("addl_read_4_fund_cd_cbm008.SALARY_Z"),
    F.col("addl_read_4_fund_cd_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("addl_read_4_fund_cd_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("addl_read_4_fund_cd_cbm008.POSITION_NBR"),
    F.col("addl_read_4_fund_cd_cbm008.CLASS_FLD_ADDL"),
    F.col("addl_read_4_fund_cd_cbm008.FUND_CODE_ADDL"),
    (
        F.col("addl_read_4_fund_cd_cbm008.ADDL_PAY_OTH_PAY")
        * F.col("addl_read_4_fund_cd_cbm008.DIST_PCT_ADDL")
    )
    .cast("INT")
    .alias("OVLP_ALLOC_REDIS_ADDL"),
    F.col("addl_read_4_fund_cd_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("addl_read_4_fund_cd_cbm008.STRM"),
    F.col("addl_read_4_fund_cd_cbm008.TERM_END_DT"),
    F.col("addl_read_4_fund_cd_cbm008.CENSUS_DT"),
    F.col("addl_read_4_fund_cd_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("addl_read_4_fund_cd_cbm008.UTA_HRE_GENDER"),
    F.col("addl_read_4_fund_cd_cbm008.UTA_HRE_NAME_UL"),
    F.col("addl_read_4_fund_cd_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("addl_read_4_fund_cd_cbm008.COMPLIANCE"),
    F.col("addl_read_4_fund_cd_cbm008.ACAD_YEAR"),
    F.col("addl_read_4_fund_cd_cbm008.UTA_HRE_STATUS"),
    F.col("addl_read_4_fund_cd_cbm008.SOURCE"),
    F.col("addl_read_4_fund_cd_cbm008.TERM_BEGIN_DT"),
)
log_view_count("ADDL_OVLP_ALLOC_REDIS_CBM008", df_addl_ovlp_alloc_redis_cbm008)

# COMMAND ----------

# Step 47: ADDL_SALARY
# Create temp view: ADDL_SALARY_CBM008
df_addl_salary_cbm008 = df_addl_ovlp_alloc_redis_cbm008.alias(
    "ADDL_OVLP_ALLOC_REDIS_CBM008"
)
_winSpec_3 = Window.partitionBy(
    F.col("addl_ovlp_alloc_redis_cbm008.SSN"),
    F.col("addl_ovlp_alloc_redis_cbm008.STRM"),
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "_sel_tmp_0_0",
    F.sum(
        F.when(
            (
                F.substring(F.col("addl_ovlp_alloc_redis_cbm008.FUND_CODE_ADDL"), 1, 2)
                == F.lit("21")
            ),
            F.col("addl_ovlp_alloc_redis_cbm008.OVLP_ALLOC_REDIS_ADDL"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_3),
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "SALARY_A_ADDL", F.col("_sel_tmp_0_0").cast("INT")
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.drop("_sel_tmp_0_0")
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "_sel_tmp_1_0",
    F.sum(
        F.when(
            F.substring(
                F.col("addl_ovlp_alloc_redis_cbm008.FUND_CODE_ADDL"), 1, 2
            ).isin(["31", "32"]),
            F.col("addl_ovlp_alloc_redis_cbm008.OVLP_ALLOC_REDIS_ADDL"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_3),
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "SALARY_D_ADDL", F.col("_sel_tmp_1_0").cast("INT")
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.drop("_sel_tmp_1_0")
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "_sel_tmp_2_0",
    F.sum(
        F.when(
            (
                F.substring(F.col("addl_ovlp_alloc_redis_cbm008.FUND_CODE_ADDL"), 1, 1)
                == F.lit("4")
            ),
            F.col("addl_ovlp_alloc_redis_cbm008.OVLP_ALLOC_REDIS_ADDL"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_3),
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "SALARY_X_ADDL", F.col("_sel_tmp_2_0").cast("INT")
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.drop("_sel_tmp_2_0")
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "_sel_tmp_3_0",
    F.sum(
        F.when(
            F.col("addl_ovlp_alloc_redis_cbm008.FUND_CODE_ADDL").isin(
                ["5100", "5200", "5300", "5400", "5500", "5600"]
            ),
            F.col("addl_ovlp_alloc_redis_cbm008.OVLP_ALLOC_REDIS_ADDL"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_3),
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "SALARY_R_ADDL", F.col("_sel_tmp_3_0").cast("INT")
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.drop("_sel_tmp_3_0")
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "_sel_tmp_4_0",
    F.sum(
        F.when(
            (
                (
                    ~F.col("addl_ovlp_alloc_redis_cbm008.FUND_CODE_ADDL").isin(
                        ["5100", "5200", "5300", "5400", "5500", "5600"]
                    )
                    & (
                        F.substring(
                            F.col("addl_ovlp_alloc_redis_cbm008.FUND_CODE_ADDL"), 1, 1
                        )
                        != F.lit("4")
                    )
                )
                & ~F.substring(
                    F.col("addl_ovlp_alloc_redis_cbm008.FUND_CODE_ADDL"), 1, 2
                ).isin(["21", "31", "32"])
            ),
            F.col("addl_ovlp_alloc_redis_cbm008.OVLP_ALLOC_REDIS_ADDL"),
        ).otherwise(F.lit(0))
    ).over(_winSpec_3),
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.withColumn(
    "SALARY_Z_ADDL", F.col("_sel_tmp_4_0").cast("INT")
)
df_addl_salary_cbm008 = df_addl_salary_cbm008.drop("_sel_tmp_4_0")

# COMMAND ----------

df_addl_salary_cbm008 = df_addl_salary_cbm008.select(
    F.col("addl_ovlp_alloc_redis_cbm008.SSN"),
    F.col("addl_ovlp_alloc_redis_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("addl_ovlp_alloc_redis_cbm008.FOUND_IN_NAMES"),
    F.col("addl_ovlp_alloc_redis_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("addl_ovlp_alloc_redis_cbm008.CIT_CHK_EMPLID"),
    F.col("addl_ovlp_alloc_redis_cbm008.EMPL_RCD"),
    F.col("addl_ovlp_alloc_redis_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("addl_ovlp_alloc_redis_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("addl_ovlp_alloc_redis_cbm008.APPT_BEGIN_DT"),
    F.col("addl_ovlp_alloc_redis_cbm008.APPT_END_DT"),
    F.col("addl_ovlp_alloc_redis_cbm008.CBM_TERM"),
    F.col("addl_ovlp_alloc_redis_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("addl_ovlp_alloc_redis_cbm008.ACCT_CD_ADDL"),
    F.col("addl_ovlp_alloc_redis_cbm008.DIST_PCT_ADDL"),
    F.col("addl_ovlp_alloc_redis_cbm008.PCT_TIME_A"),
    F.col("addl_ovlp_alloc_redis_cbm008.PCT_TIME_C"),
    F.col("addl_ovlp_alloc_redis_cbm008.PCT_TIME_D"),
    F.col("addl_ovlp_alloc_redis_cbm008.PCT_TIME_E"),
    F.col("addl_ovlp_alloc_redis_cbm008.SALARY_A"),
    F.col("addl_ovlp_alloc_redis_cbm008.SALARY_D"),
    F.col("addl_ovlp_alloc_redis_cbm008.SALARY_X"),
    F.col("addl_ovlp_alloc_redis_cbm008.SALARY_R"),
    F.col("addl_ovlp_alloc_redis_cbm008.SALARY_Z"),
    F.col("addl_ovlp_alloc_redis_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("addl_ovlp_alloc_redis_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("addl_ovlp_alloc_redis_cbm008.POSITION_NBR"),
    # SAS source (L11350-L11354): ADDL_OVLP_ALLOC_REDIS_CBM008.CLASS_FLD_ADDL as ADDL_CLASS_FLD
    #                             ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL as ADDL_FUND_CODE
    F.col("addl_ovlp_alloc_redis_cbm008.CLASS_FLD_ADDL").alias("ADDL_CLASS_FLD"),
    F.col("addl_ovlp_alloc_redis_cbm008.FUND_CODE_ADDL").alias("ADDL_FUND_CODE"),
    F.col("addl_ovlp_alloc_redis_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("SALARY_A_ADDL"),
    F.col("SALARY_D_ADDL"),
    F.col("SALARY_X_ADDL"),
    F.col("SALARY_R_ADDL"),
    F.col("SALARY_Z_ADDL"),
    F.col("addl_ovlp_alloc_redis_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("addl_ovlp_alloc_redis_cbm008.STRM"),
    F.col("addl_ovlp_alloc_redis_cbm008.TERM_END_DT"),
    F.col("addl_ovlp_alloc_redis_cbm008.CENSUS_DT"),
    F.col("addl_ovlp_alloc_redis_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("addl_ovlp_alloc_redis_cbm008.UTA_HRE_GENDER"),
    F.col("addl_ovlp_alloc_redis_cbm008.UTA_HRE_NAME_UL"),
    F.col("addl_ovlp_alloc_redis_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("addl_ovlp_alloc_redis_cbm008.COMPLIANCE"),
    F.col("addl_ovlp_alloc_redis_cbm008.ACAD_YEAR"),
    F.col("addl_ovlp_alloc_redis_cbm008.UTA_HRE_STATUS"),
    F.col("addl_ovlp_alloc_redis_cbm008.SOURCE"),
    F.col("addl_ovlp_alloc_redis_cbm008.TERM_BEGIN_DT"),
)
log_view_count("ADDL_SALARY_CBM008", df_addl_salary_cbm008)

# COMMAND ----------

# Step 48: FACULTY_MEMBER
# Create temp view: FACULTY_MEMBER_CBM008
df_faculty_member_cbm008 = df_addl_salary_cbm008.alias("ADDL_SALARY_CBM008")
df_faculty_member_cbm008 = df_faculty_member_cbm008.select(
    F.col("addl_salary_cbm008.SSN"),
    F.col("addl_salary_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("addl_salary_cbm008.FOUND_IN_NAMES"),
    F.col("addl_salary_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("addl_salary_cbm008.CIT_CHK_EMPLID"),
    F.col("addl_salary_cbm008.EMPL_RCD"),
    F.col("addl_salary_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("addl_salary_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("addl_salary_cbm008.APPT_BEGIN_DT"),
    F.col("addl_salary_cbm008.APPT_END_DT"),
    F.col("addl_salary_cbm008.CBM_TERM"),
    F.col("addl_salary_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("addl_salary_cbm008.ACCT_CD_ADDL"),
    F.col("addl_salary_cbm008.DIST_PCT_ADDL"),
    F.col("addl_salary_cbm008.PCT_TIME_A"),
    F.col("addl_salary_cbm008.PCT_TIME_C"),
    F.col("addl_salary_cbm008.PCT_TIME_D"),
    F.col("addl_salary_cbm008.PCT_TIME_E"),
    F.col("addl_salary_cbm008.SALARY_A"),
    F.col("addl_salary_cbm008.SALARY_D"),
    F.col("addl_salary_cbm008.SALARY_X"),
    F.col("addl_salary_cbm008.SALARY_R"),
    F.col("addl_salary_cbm008.SALARY_Z"),
    F.col("addl_salary_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("addl_salary_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("addl_salary_cbm008.POSITION_NBR"),
    F.col("addl_salary_cbm008.ADDL_CLASS_FLD"),
    F.col("addl_salary_cbm008.ADDL_FUND_CODE"),
    F.col("addl_salary_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("addl_salary_cbm008.SALARY_A_ADDL"),
    F.col("addl_salary_cbm008.SALARY_D_ADDL"),
    F.col("addl_salary_cbm008.SALARY_X_ADDL"),
    F.col("addl_salary_cbm008.SALARY_R_ADDL"),
    F.col("addl_salary_cbm008.SALARY_Z_ADDL"),
    F.col("addl_salary_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("addl_salary_cbm008.STRM"),
    F.col("addl_salary_cbm008.TERM_END_DT"),
    F.col("addl_salary_cbm008.CENSUS_DT"),
    F.col("addl_salary_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("addl_salary_cbm008.UTA_HRE_GENDER"),
    F.col("addl_salary_cbm008.UTA_HRE_NAME_UL"),
    F.col("addl_salary_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("addl_salary_cbm008.COMPLIANCE"),
    F.col("addl_salary_cbm008.ACAD_YEAR"),
    F.col("addl_salary_cbm008.UTA_HRE_STATUS"),
    F.col("addl_salary_cbm008.SOURCE"),
    F.col("addl_salary_cbm008.TERM_BEGIN_DT"),
)
log_view_count("FACULTY_MEMBER_CBM008", df_faculty_member_cbm008)

# COMMAND ----------

# Step 49: DECODE_TITLE_CODE_1
# Create temp view: DECODE_TITLE_CODE_1_CBM008
df_decode_title_code_1_cbm008 = df_faculty_member_cbm008.alias("FACULTY_MEMBER_CBM008")
df_decode_title_code_1_cbm008 = df_decode_title_code_1_cbm008.select(
    F.col("faculty_member_cbm008.SSN"),
    F.col("faculty_member_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("faculty_member_cbm008.FOUND_IN_NAMES"),
    F.col("faculty_member_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("faculty_member_cbm008.CIT_CHK_EMPLID"),
    F.col("faculty_member_cbm008.EMPL_RCD"),
    F.col("faculty_member_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("faculty_member_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("faculty_member_cbm008.APPT_BEGIN_DT"),
    F.col("faculty_member_cbm008.APPT_END_DT"),
    F.col("faculty_member_cbm008.CBM_TERM"),
    F.col("faculty_member_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("faculty_member_cbm008.ACCT_CD_ADDL"),
    F.col("faculty_member_cbm008.DIST_PCT_ADDL"),
    F.col("faculty_member_cbm008.PCT_TIME_A"),
    F.col("faculty_member_cbm008.PCT_TIME_C"),
    F.col("faculty_member_cbm008.PCT_TIME_D"),
    F.col("faculty_member_cbm008.PCT_TIME_E"),
    F.col("faculty_member_cbm008.SALARY_A"),
    F.col("faculty_member_cbm008.SALARY_D"),
    F.col("faculty_member_cbm008.SALARY_X"),
    F.col("faculty_member_cbm008.SALARY_R"),
    F.col("faculty_member_cbm008.SALARY_Z"),
    F.col("faculty_member_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("faculty_member_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("faculty_member_cbm008.POSITION_NBR"),
    F.col("faculty_member_cbm008.ADDL_CLASS_FLD"),
    F.col("faculty_member_cbm008.ADDL_FUND_CODE"),
    F.col("faculty_member_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("faculty_member_cbm008.SALARY_A_ADDL"),
    F.col("faculty_member_cbm008.SALARY_D_ADDL"),
    F.col("faculty_member_cbm008.SALARY_X_ADDL"),
    F.col("faculty_member_cbm008.SALARY_R_ADDL"),
    F.col("faculty_member_cbm008.SALARY_Z_ADDL"),
    F.when(
        F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
            ["0006", "0007", "0008", "0009", "0010"]
        ),
        F.lit("PROF"),
    )
    .otherwise(
        F.when(
            (F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE") == F.lit("0000")),
            F.lit("EMRT"),
        ).otherwise(
            F.when(
                F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                    [
                        "0011",
                        "0013",
                        "0014",
                        "0015",
                        "0021",
                        "0024",
                        "0025",
                        "0034",
                        "0035",
                        "0044",
                        "0045",
                        "0047",
                        "0056",
                        "0029",
                    ]
                ),
                F.lit("ADJ"),
            ).otherwise(
                F.when(
                    F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                        ["0012", "0022", "0032"]
                    ),
                    F.lit("VPRF"),
                ).otherwise(
                    F.when(
                        F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                            ["0016", "0017", "0018", "0019", "0020"]
                        ),
                        F.lit("ASSC"),
                    ).otherwise(
                        F.when(
                            F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                                ["0027", "0028", "0030", "0031"]
                            ),
                            F.lit("ASST"),
                        ).otherwise(
                            F.when(
                                F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                                    ["0040", "0041"]
                                ),
                                F.lit("INST"),
                            ).otherwise(
                                F.when(
                                    F.col(
                                        "faculty_member_cbm008.UTA_HRE_MAJORTITLE"
                                    ).isin(["0049", "0050", "0051"]),
                                    F.lit("LECT"),
                                ).otherwise(
                                    F.when(
                                        (
                                            F.col(
                                                "faculty_member_cbm008.UTA_HRE_MAJORTITLE"
                                            )
                                            == F.lit("0096")
                                        ),
                                        F.lit("UNDF"),
                                    ).otherwise(
                                        F.when(
                                            (
                                                (
                                                    F.col(
                                                        "faculty_member_cbm008.UTA_HRE_MAJORTITLE"
                                                    )
                                                    > F.lit("0062")
                                                )
                                            ),
                                            F.lit("TA"),
                                        ).otherwise(F.lit(""))
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    .alias("INSTRUCTOR_CLASSIF"),
    F.when(
        F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
            ["0006", "0007", "0008", "0009", "0010"]
        ),
        F.lit("1"),
    )
    .otherwise(
        F.when(
            F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                [
                    "0000",
                    "0011",
                    "0013",
                    "0014",
                    "0015",
                    "0021",
                    "0024",
                    "0025",
                    "0034",
                    "0035",
                    "0044",
                    "0045",
                    "0047",
                    "0056",
                    "0029",
                    "0012",
                    "0022",
                    "0032",
                    "0049",
                    "0050",
                    "0051",
                    "0096",
                ]
            ),
            F.lit("5"),
        ).otherwise(
            F.when(
                F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                    ["0016", "0017", "0018", "0019", "0020"]
                ),
                F.lit("2"),
            ).otherwise(
                F.when(
                    F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                        ["0027", "0028", "0030", "0031"]
                    ),
                    F.lit("3"),
                ).otherwise(
                    F.when(
                        F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE").isin(
                            ["0040", "0041"]
                        ),
                        F.lit("4"),
                    ).otherwise(
                        F.when(
                            (
                                (
                                    F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE")
                                    > F.lit("0062")
                                )
                            ),
                            F.lit("6"),
                        ).otherwise(F.lit(""))
                    )
                )
            )
        )
    )
    .alias("FACULTY_CLASSIF"),
    F.col("faculty_member_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("faculty_member_cbm008.STRM"),
    F.col("faculty_member_cbm008.TERM_END_DT"),
    F.col("faculty_member_cbm008.CENSUS_DT"),
    F.col("faculty_member_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("faculty_member_cbm008.UTA_HRE_GENDER"),
    F.col("faculty_member_cbm008.UTA_HRE_NAME_UL"),
    F.col("faculty_member_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("faculty_member_cbm008.COMPLIANCE"),
    F.col("faculty_member_cbm008.ACAD_YEAR"),
    F.col("faculty_member_cbm008.UTA_HRE_STATUS"),
    F.col("faculty_member_cbm008.SOURCE"),
    F.col("faculty_member_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

# Step 50: READ_HRA_MAJOR_APPT
# Create temp view: READ_HRA_MAJOR_APPT_CBM008
df_read_hra_major_appt_cbm008 = df_decode_title_code_1_cbm008.alias(
    "DECODE_TITLE_CODE_1_CBM008"
)
df_read_hra_major_appt_cbm008 = df_read_hra_major_appt_cbm008.join(
    read_table(f"{student}.{bronze}.PS_UTA_HRA_TBL").alias("PS_UTA_HRA_TBL"),
    (
        (
            (F.col("decode_title_code_1_cbm008.SSN") == F.col("ps_uta_hra_tbl.SSN"))
            & (
                F.col("decode_title_code_1_cbm008.ACAD_YEAR")
                == F.col("ps_uta_hra_tbl.UTA_HRA_FISCALYEAR")
            )
        )
        & (
            F.col("decode_title_code_1_cbm008.UTA_HRE_MAJAPPTSEQ").cast("BIGINT")
            == F.col("ps_uta_hra_tbl.UTA_HRA_APPT_SEQNR")
        )
    ),
    "left",
)
df_read_hra_major_appt_cbm008 = df_read_hra_major_appt_cbm008.select(
    F.col("decode_title_code_1_cbm008.SSN"),
    F.col("decode_title_code_1_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("decode_title_code_1_cbm008.FOUND_IN_NAMES"),
    F.col("decode_title_code_1_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("decode_title_code_1_cbm008.CIT_CHK_EMPLID"),
    F.col("decode_title_code_1_cbm008.EMPL_RCD"),
    F.col("decode_title_code_1_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("decode_title_code_1_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("decode_title_code_1_cbm008.APPT_BEGIN_DT"),
    F.col("decode_title_code_1_cbm008.APPT_END_DT"),
    F.col("decode_title_code_1_cbm008.CBM_TERM"),
    F.col("decode_title_code_1_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("decode_title_code_1_cbm008.ACCT_CD_ADDL"),
    F.col("decode_title_code_1_cbm008.DIST_PCT_ADDL"),
    F.col("decode_title_code_1_cbm008.PCT_TIME_A"),
    F.col("decode_title_code_1_cbm008.PCT_TIME_C"),
    F.col("decode_title_code_1_cbm008.PCT_TIME_D"),
    F.col("decode_title_code_1_cbm008.PCT_TIME_E"),
    F.col("decode_title_code_1_cbm008.SALARY_A"),
    F.col("decode_title_code_1_cbm008.SALARY_D"),
    F.col("decode_title_code_1_cbm008.SALARY_X"),
    F.col("decode_title_code_1_cbm008.SALARY_R"),
    F.col("decode_title_code_1_cbm008.SALARY_Z"),
    F.col("decode_title_code_1_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("decode_title_code_1_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("decode_title_code_1_cbm008.POSITION_NBR"),
    F.col("decode_title_code_1_cbm008.ADDL_CLASS_FLD"),
    F.col("decode_title_code_1_cbm008.ADDL_FUND_CODE"),
    F.col("decode_title_code_1_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("decode_title_code_1_cbm008.SALARY_A_ADDL"),
    F.col("decode_title_code_1_cbm008.SALARY_D_ADDL"),
    F.col("decode_title_code_1_cbm008.SALARY_X_ADDL"),
    F.col("decode_title_code_1_cbm008.SALARY_R_ADDL"),
    F.col("decode_title_code_1_cbm008.SALARY_Z_ADDL"),
    F.substring(F.trim(F.col("ps_uta_hra_tbl.UTA_HRA_UNIT_CD")), 1, 4).alias(
        "UTA_HRA_UNIT_CD"
    ),
    F.col("decode_title_code_1_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("decode_title_code_1_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("decode_title_code_1_cbm008.FACULTY_CLASSIF"),
    F.col("decode_title_code_1_cbm008.STRM"),
    F.col("decode_title_code_1_cbm008.TERM_END_DT"),
    F.col("decode_title_code_1_cbm008.CENSUS_DT"),
    F.col("decode_title_code_1_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("decode_title_code_1_cbm008.UTA_HRE_GENDER"),
    F.col("decode_title_code_1_cbm008.UTA_HRE_NAME_UL"),
    F.col("decode_title_code_1_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("decode_title_code_1_cbm008.COMPLIANCE"),
    F.col("decode_title_code_1_cbm008.ACAD_YEAR"),
    F.col("ps_uta_hra_tbl.UTA_HRA_ACCT_10"),
    F.col("ps_uta_hra_tbl.UTA_HRA_POSITIONID"),
    F.col("ps_uta_hra_tbl.UTA_HRA_TITLE_CD"),
    F.col("decode_title_code_1_cbm008.UTA_HRE_STATUS"),
    F.col("decode_title_code_1_cbm008.SOURCE"),
    F.col("decode_title_code_1_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

# Step 51: DECODE_TITLE_CODE_2
# Create temp view: DECODE_TITLE_CODE_2_CBM008
df_decode_title_code_2_cbm008 = df_read_hra_major_appt_cbm008.alias(
    "READ_HRA_MAJOR_APPT_CBM008"
)
df_decode_title_code_2_cbm008 = df_decode_title_code_2_cbm008.select(
    F.col("read_hra_major_appt_cbm008.SSN"),
    F.col("read_hra_major_appt_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("read_hra_major_appt_cbm008.FOUND_IN_NAMES"),
    F.col("read_hra_major_appt_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("read_hra_major_appt_cbm008.CIT_CHK_EMPLID"),
    F.col("read_hra_major_appt_cbm008.EMPL_RCD"),
    F.col("read_hra_major_appt_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_hra_major_appt_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("read_hra_major_appt_cbm008.APPT_BEGIN_DT"),
    F.col("read_hra_major_appt_cbm008.APPT_END_DT"),
    F.col("read_hra_major_appt_cbm008.CBM_TERM"),
    F.col("read_hra_major_appt_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("read_hra_major_appt_cbm008.ACCT_CD_ADDL"),
    F.col("read_hra_major_appt_cbm008.DIST_PCT_ADDL"),
    F.col("read_hra_major_appt_cbm008.PCT_TIME_A"),
    F.col("read_hra_major_appt_cbm008.PCT_TIME_C"),
    F.col("read_hra_major_appt_cbm008.PCT_TIME_D"),
    F.col("read_hra_major_appt_cbm008.PCT_TIME_E"),
    F.col("read_hra_major_appt_cbm008.SALARY_A"),
    F.col("read_hra_major_appt_cbm008.SALARY_D"),
    F.col("read_hra_major_appt_cbm008.SALARY_X"),
    F.col("read_hra_major_appt_cbm008.SALARY_R"),
    F.col("read_hra_major_appt_cbm008.SALARY_Z"),
    F.col("read_hra_major_appt_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("read_hra_major_appt_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("read_hra_major_appt_cbm008.POSITION_NBR"),
    F.col("read_hra_major_appt_cbm008.ADDL_CLASS_FLD"),
    F.col("read_hra_major_appt_cbm008.ADDL_FUND_CODE"),
    F.col("read_hra_major_appt_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("read_hra_major_appt_cbm008.SALARY_A_ADDL"),
    F.col("read_hra_major_appt_cbm008.SALARY_D_ADDL"),
    F.col("read_hra_major_appt_cbm008.SALARY_X_ADDL"),
    F.col("read_hra_major_appt_cbm008.SALARY_R_ADDL"),
    F.col("read_hra_major_appt_cbm008.SALARY_Z_ADDL"),
    F.when(
        (F.col("read_hra_major_appt_cbm008.INSTRUCTOR_CLASSIF") == F.lit("")),
        F.when(
            F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                ["0006", "0007", "0008", "0009", "0010"]
            ),
            F.lit("PROF"),
        ).otherwise(
            F.when(
                (F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD") == F.lit("0000")),
                F.lit("EMRT"),
            ).otherwise(
                F.when(
                    F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                        [
                            "0011",
                            "0013",
                            "0014",
                            "0015",
                            "0021",
                            "0024",
                            "0025",
                            "0034",
                            "0035",
                            "0044",
                            "0045",
                            "0047",
                            "0056",
                            "0029",
                        ]
                    ),
                    F.lit("ADJ"),
                ).otherwise(
                    F.when(
                        F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                            ["0012", "0022", "0032"]
                        ),
                        F.lit("VPRF"),
                    ).otherwise(
                        F.when(
                            F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                                ["0016", "0017", "0018", "0019", "0020"]
                            ),
                            F.lit("ASSC"),
                        ).otherwise(
                            F.when(
                                F.col(
                                    "read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD"
                                ).isin(["0027", "0028", "0030", "0031"]),
                                F.lit("ASST"),
                            ).otherwise(
                                F.when(
                                    F.col(
                                        "read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD"
                                    ).isin(["0040", "0041"]),
                                    F.lit("INST"),
                                ).otherwise(
                                    F.when(
                                        F.col(
                                            "read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD"
                                        ).isin(["0049", "0050", "0051"]),
                                        F.lit("LECT"),
                                    ).otherwise(
                                        F.when(
                                            (
                                                F.col(
                                                    "read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD"
                                                )
                                                == F.lit("0096")
                                            ),
                                            F.lit("UNDF"),
                                        ).otherwise(
                                            F.when(
                                                (
                                                    (
                                                        F.col(
                                                            "read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD"
                                                        )
                                                        > F.lit("0062")
                                                    )
                                                    & (
                                                        F.col(
                                                            "read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD"
                                                        )
                                                        < F.lit("0096")
                                                    )
                                                ),
                                                F.lit("TA"),
                                            ).otherwise(F.lit(""))
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        ),
    )
    .otherwise(F.col("read_hra_major_appt_cbm008.INSTRUCTOR_CLASSIF"))
    .alias("INSTRUCTOR_CLASSIF"),
    F.when(
        (
            (F.col("read_hra_major_appt_cbm008.FACULTY_CLASSIF") == F.lit(""))
            & (F.col("read_hra_major_appt_cbm008.SOURCE") == F.lit("INSTR"))
        ),
        F.when(
            F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                ["0006", "0007", "0008", "0009", "0010"]
            ),
            F.lit("1"),
        ).otherwise(
            F.when(
                F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                    [
                        "0000",
                        "0011",
                        "0013",
                        "0014",
                        "0015",
                        "0021",
                        "0024",
                        "0025",
                        "0034",
                        "0035",
                        "0044",
                        "0045",
                        "0047",
                        "0056",
                        "0029",
                        "0012",
                        "0022",
                        "0032",
                        "0049",
                        "0050",
                        "0051",
                        "0096",
                    ]
                ),
                F.lit("5"),
            ).otherwise(
                F.when(
                    F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                        ["0016", "0017", "0018", "0019", "0020"]
                    ),
                    F.lit("2"),
                ).otherwise(
                    F.when(
                        F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                            ["0027", "0028", "0030", "0031"]
                        ),
                        F.lit("3"),
                    ).otherwise(
                        F.when(
                            F.col("read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD").isin(
                                ["0040", "0041"]
                            ),
                            F.lit("4"),
                        ).otherwise(
                            F.when(
                                (
                                    (
                                        F.col(
                                            "read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD"
                                        )
                                        > F.lit("0062")
                                    )
                                    & (
                                        F.col(
                                            "read_hra_major_appt_cbm008.UTA_HRA_TITLE_CD"
                                        )
                                        < F.lit("0096")
                                    )
                                ),
                                F.lit("6"),
                            ).otherwise(F.lit(""))
                        )
                    )
                )
            )
        ),
    )
    .otherwise(F.col("read_hra_major_appt_cbm008.FACULTY_CLASSIF"))
    .alias("FACULTY_CLASSIF"),
    F.col("read_hra_major_appt_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("read_hra_major_appt_cbm008.STRM"),
    F.col("read_hra_major_appt_cbm008.TERM_END_DT"),
    F.col("read_hra_major_appt_cbm008.CENSUS_DT"),
    F.col("read_hra_major_appt_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_hra_major_appt_cbm008.UTA_HRE_GENDER"),
    F.col("read_hra_major_appt_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_hra_major_appt_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_hra_major_appt_cbm008.COMPLIANCE"),
    F.col("read_hra_major_appt_cbm008.ACAD_YEAR"),
    F.col("read_hra_major_appt_cbm008.UTA_HRA_ACCT_10"),
    F.col("read_hra_major_appt_cbm008.UTA_HRA_POSITIONID"),
    F.col("read_hra_major_appt_cbm008.UTA_HRE_STATUS"),
    F.col("read_hra_major_appt_cbm008.SOURCE"),
    F.col("read_hra_major_appt_cbm008.UTA_HRA_UNIT_CD"),
    F.col("read_hra_major_appt_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Set Operators)
# Create temp view: TITLE_AND_GENDER
df_title_and_gender_part0 = df_decode_title_code_2_cbm008.alias(
    "decode_title_code_2_cbm008"
)
df_title_and_gender_part0 = df_title_and_gender_part0.select(
    F.col("decode_title_code_2_cbm008.SSN"),
    F.col("decode_title_code_2_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("decode_title_code_2_cbm008.FOUND_IN_NAMES"),
    F.col("decode_title_code_2_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("decode_title_code_2_cbm008.CIT_CHK_EMPLID"),
    F.col("decode_title_code_2_cbm008.EMPL_RCD"),
    F.col("decode_title_code_2_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("decode_title_code_2_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("decode_title_code_2_cbm008.APPT_BEGIN_DT"),
    F.col("decode_title_code_2_cbm008.APPT_END_DT"),
    F.col("decode_title_code_2_cbm008.CBM_TERM"),
    F.col("decode_title_code_2_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("decode_title_code_2_cbm008.ACCT_CD_ADDL"),
    F.col("decode_title_code_2_cbm008.DIST_PCT_ADDL"),
    F.col("decode_title_code_2_cbm008.PCT_TIME_A"),
    F.col("decode_title_code_2_cbm008.PCT_TIME_C"),
    F.col("decode_title_code_2_cbm008.PCT_TIME_D"),
    F.col("decode_title_code_2_cbm008.PCT_TIME_E"),
    F.col("decode_title_code_2_cbm008.SALARY_A"),
    F.col("decode_title_code_2_cbm008.SALARY_D"),
    F.col("decode_title_code_2_cbm008.SALARY_X"),
    F.col("decode_title_code_2_cbm008.SALARY_R"),
    F.col("decode_title_code_2_cbm008.SALARY_Z"),
    F.col("decode_title_code_2_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("decode_title_code_2_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("decode_title_code_2_cbm008.POSITION_NBR"),
    F.col("decode_title_code_2_cbm008.ADDL_CLASS_FLD"),
    F.col("decode_title_code_2_cbm008.ADDL_FUND_CODE"),
    F.col("decode_title_code_2_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("decode_title_code_2_cbm008.SALARY_A_ADDL"),
    F.col("decode_title_code_2_cbm008.SALARY_D_ADDL"),
    F.col("decode_title_code_2_cbm008.SALARY_X_ADDL"),
    F.col("decode_title_code_2_cbm008.SALARY_R_ADDL"),
    F.col("decode_title_code_2_cbm008.SALARY_Z_ADDL"),
    F.col("decode_title_code_2_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("decode_title_code_2_cbm008.FACULTY_CLASSIF"),
    F.col("decode_title_code_2_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("decode_title_code_2_cbm008.STRM"),
    F.col("decode_title_code_2_cbm008.TERM_END_DT"),
    F.col("decode_title_code_2_cbm008.CENSUS_DT"),
    F.col("decode_title_code_2_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("decode_title_code_2_cbm008.UTA_HRE_GENDER"),
    F.col("decode_title_code_2_cbm008.UTA_HRE_NAME_UL"),
    F.col("decode_title_code_2_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("decode_title_code_2_cbm008.COMPLIANCE"),
    F.col("decode_title_code_2_cbm008.ACAD_YEAR"),
    F.col("decode_title_code_2_cbm008.UTA_HRA_ACCT_10"),
    F.col("decode_title_code_2_cbm008.UTA_HRA_POSITIONID"),
    F.col("decode_title_code_2_cbm008.UTA_HRE_STATUS"),
    F.col("decode_title_code_2_cbm008.SOURCE"),
    F.col("decode_title_code_2_cbm008.UTA_HRA_UNIT_CD"),
    F.col("decode_title_code_2_cbm008.TERM_BEGIN_DT"),
)
df_title_and_gender_part1 = df_get_gender_cbm008.alias("get_gender_cbm008")
df_title_and_gender_part1 = df_title_and_gender_part1.select(
    F.col("get_gender_cbm008.HRS_ID").alias("SSN"),
    F.lit("").alias("CIT_CHK_EMPLID_PERS_NID"),
    F.lit("").alias("FOUND_IN_NAMES"),
    F.lit("").alias("CIT_CHK_EMPLID_EXT_SYS"),
    F.col("get_gender_cbm008.EMPLID").alias("CIT_CHK_EMPLID"),
    F.col("get_gender_cbm008.EMPL_RCD"),
    F.lit("").alias("UTA_HRE_MAJAPPTSEQ"),
    F.lit(None).alias("EFFDT_UTA_HR_ADDL_PAY"),
    F.col("get_gender_cbm008.APPT_BEGIN_DT"),
    F.col("get_gender_cbm008.APPT_END_DT"),
    F.col("get_gender_cbm008.CBM_TERM"),
    F.col("get_gender_cbm008.UTSHARE_FISCAL_YEAR"),
    F.lit("").alias("ACCT_CD_ADDL"),
    F.lit(None).alias("DIST_PCT_ADDL"),
    F.lit(0).alias("PCT_TIME_A"),
    F.lit(0).alias("PCT_TIME_C"),
    F.lit(0).alias("PCT_TIME_D"),
    F.lit(0).alias("PCT_TIME_E"),
    F.lit(0).alias("SALARY_A"),
    F.lit(0).alias("SALARY_D"),
    F.lit(0).alias("SALARY_X"),
    F.lit(0).alias("SALARY_R"),
    F.lit(0).alias("SALARY_Z"),
    F.lit("").alias("ADDL_PAY_ACCT_CD"),
    F.lit(None).alias("ADDL_PAY_OTH_PAY"),
    F.lit("").alias("POSITION_NBR"),
    F.lit("").alias("ADDL_CLASS_FLD"),
    F.lit("").alias("ADDL_FUND_CODE"),
    F.lit(None).alias("OVLP_ALLOC_REDIS_ADDL"),
    F.lit(0).alias("SALARY_A_ADDL"),
    F.lit(0).alias("SALARY_D_ADDL"),
    F.lit(0).alias("SALARY_X_ADDL"),
    F.lit(0).alias("SALARY_R_ADDL"),
    F.lit(0).alias("SALARY_Z_ADDL"),
    F.lit("").alias("INSTRUCTOR_CLASSIF"),
    F.lit("").alias("FACULTY_CLASSIF"),
    F.lit("").alias("UTA_HRE_MAJORTITLE"),
    F.col("get_gender_cbm008.STRM"),
    F.col("get_gender_cbm008.TERM_END_DT"),
    F.col("get_gender_cbm008.CENSUS_DT"),
    F.date_format(
        F.expr("CAST(CAST(get_gender_cbm008.BIRTHDATE AS DATE) AS TIMESTAMP)"),
        F.lit("%y%m%d"),
    ).alias("UTA_HRE_BIRTH_DATE"),
    F.col("get_gender_cbm008.GENDER").alias("UTA_HRE_GENDER"),
    F.trim(F.col("get_gender_cbm008.NAME")).alias("UTA_HRE_NAME_UL"),
    F.lit("").alias("UTA_HRE_CNT_SVC_DT"),
    F.col("get_gender_cbm008.COMPLIANCE"),
    F.col("get_gender_cbm008.ACAD_YEAR"),
    F.lit("").alias("UTA_HRA_ACCT_10"),
    F.lit("").alias("UTA_HRA_POSITIONID"),
    F.lit("").alias("UTA_HRE_STATUS"),
    F.lit("").alias("SOURCE"),
    F.lit("").alias("UTA_HRA_UNIT_CD"),
    F.col("get_gender_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

df_title_and_gender = df_title_and_gender_part0.union(df_title_and_gender_part1)
log_view_count("TITLE_AND_GENDER (READ_HRA/DECODE_TITLE_CODE_2)", df_title_and_gender)

# COMMAND ----------

# Step 52: UTA_TENURE_MAX_ORG_UPD_DT
# Create temp view: UTA_TENURE_MAX_ORG_UPD_DT_CBM008
df_uta_tenure_max_org_upd_dt_cbm008 = read_table(
    f"{student}.{bronze}.PS_UTA_TT_TENURE"
).alias("PS_UTA_TT_TENURE")
df_uta_tenure_max_org_upd_dt_cbm008 = df_uta_tenure_max_org_upd_dt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_uta_tt_tenure.ACAD_ORG")).over(
        Window.partitionBy("ps_uta_tt_tenure.UTA_TT_EMPLID")
    ),
)
df_uta_tenure_max_org_upd_dt_cbm008 = df_uta_tenure_max_org_upd_dt_cbm008.withColumn(
    "_agg_tmp_1",
    F.max(F.col("ps_uta_tt_tenure.UTA_TT_LAST_UPDT")).over(
        Window.partitionBy("ps_uta_tt_tenure.UTA_TT_EMPLID")
    ),
)
df_uta_tenure_max_org_upd_dt_cbm008 = df_uta_tenure_max_org_upd_dt_cbm008.filter(
    (
        F.col("ps_uta_tt_tenure.ACAD_ORG").eqNullSafe(F.col("_agg_tmp_0"))
        & (F.col("ps_uta_tt_tenure.UTA_TT_LAST_UPDT") == F.col("_agg_tmp_1"))
    )
)
df_uta_tenure_max_org_upd_dt_cbm008 = df_uta_tenure_max_org_upd_dt_cbm008.drop(
    "_agg_tmp_0", "_agg_tmp_1"
)
df_uta_tenure_max_org_upd_dt_cbm008 = df_uta_tenure_max_org_upd_dt_cbm008.select(
    F.col("ps_uta_tt_tenure.ACAD_ORG"),
    F.col("ps_uta_tt_tenure.DESCRSHORT"),
    F.col("ps_uta_tt_tenure.UTA_TT_BASE_DATE"),
    F.col("ps_uta_tt_tenure.UTA_TT_CREATED_DT"),
    F.col("ps_uta_tt_tenure.UTA_TT_CURR_LEAVE"),
    F.col("ps_uta_tt_tenure.UTA_TT_DECISION"),
    F.col("ps_uta_tt_tenure.UTA_TT_DEP_RSN"),
    F.col("ps_uta_tt_tenure.UTA_TT_DEPARTUREDT"),
    F.col("ps_uta_tt_tenure.UTA_TT_EMPLID"),
    F.col("ps_uta_tt_tenure.UTA_TT_EXPTENUREDT"),
    F.col("ps_uta_tt_tenure.UTA_TT_FOLLOWUPREV"),
    F.col("ps_uta_tt_tenure.UTA_TT_FOLWUPRVDEC"),
    F.col("ps_uta_tt_tenure.UTA_TT_HIRE_DT"),
    F.col("ps_uta_tt_tenure.UTA_TT_LAST_UPDT"),
    F.col("ps_uta_tt_tenure.UTA_TT_LST_PROM_DT"),
    F.col("ps_uta_tt_tenure.UTA_TT_MIS_ADJ_REA"),
    F.col("ps_uta_tt_tenure.UTA_TT_MISC_ADJ"),
    F.col("ps_uta_tt_tenure.UTA_TT_NXT_TEN_REV"),
    F.col("ps_uta_tt_tenure.UTA_TT_PRIOREARNYR"),
    F.col("ps_uta_tt_tenure.UTA_TT_PRIORLEAVYR"),
    F.col("ps_uta_tt_tenure.UTA_TT_RANK"),
    F.col("ps_uta_tt_tenure.UTA_TT_STATUS"),
    F.col("ps_uta_tt_tenure.UTA_TT_TEN_EXT_YRS"),
    F.col("ps_uta_tt_tenure.UTA_TT_TENURE_DT"),
    F.col("ps_uta_tt_tenure.UTA_TT_TENURE_REV"),
    F.col("ps_uta_tt_tenure.UTA_TT_TERM"),
    F.col("ps_uta_tt_tenure.UTA_TT_THRD_YR_REV"),
    F.col("ps_uta_tt_tenure.UTA_TT_THRDYRREVDT"),
    F.col("ps_uta_tt_tenure.UTA_TT_YRS_TENURE"),
)
log_view_count("UTA_TENURE_MAX_ORG_UPD_DT_CBM008", df_uta_tenure_max_org_upd_dt_cbm008)

# COMMAND ----------

# Step 53: POSITION_DATA_MAX_EFFDT
# Create temp view: POSITION_DATA_MAX_EFFDT_CBM008
df_position_data_max_effdt_cbm008 = read_table(
    f"{student}.{bronze}.PS_POSITION_DATA"
).alias("PS_POSITION_DATA")
df_position_data_max_effdt_cbm008 = df_position_data_max_effdt_cbm008.filter(
    (F.col("ps_position_data.EFFDT") <= F.current_timestamp())
)
df_position_data_max_effdt_cbm008 = df_position_data_max_effdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_position_data.EFFDT")).over(
        Window.partitionBy("ps_position_data.POSITION_NBR")
    ),
)
df_position_data_max_effdt_cbm008 = df_position_data_max_effdt_cbm008.filter(
    (F.col("ps_position_data.EFFDT") == F.col("_agg_tmp_0"))
)
df_position_data_max_effdt_cbm008 = df_position_data_max_effdt_cbm008.drop("_agg_tmp_0")
df_position_data_max_effdt_cbm008 = df_position_data_max_effdt_cbm008.select(
    F.col("ps_position_data.POSITION_NBR"), F.col("ps_position_data.DEPTID")
)
log_view_count("POSITION_DATA_MAX_EFFDT_CBM008", df_position_data_max_effdt_cbm008)

# COMMAND ----------

# Step 54: READ_TENURE_RECORD
# Create temp view: READ_TENURE_RECORD_CBM008
df_read_tenure_record_cbm008 = df_title_and_gender.alias("TITLE_AND_GENDER")
df_read_tenure_record_cbm008 = df_read_tenure_record_cbm008.join(
    df_uta_tenure_max_org_upd_dt_cbm008.alias("UTA_TENURE_MAX_ORG_UPD_DT_CBM008"),
    (
        (
            F.col("title_and_gender.CIT_CHK_EMPLID").isNotNull()
            & (F.col("title_and_gender.CIT_CHK_EMPLID") != F.lit(""))
        )
        & (
            F.col("title_and_gender.CIT_CHK_EMPLID")
            == F.col("uta_tenure_max_org_upd_dt_cbm008.UTA_TT_EMPLID")
        )
    ),
    "left",
)
df_read_tenure_record_cbm008 = df_read_tenure_record_cbm008.join(
    df_position_data_max_effdt_cbm008.alias("POSITION_DATA_MAX_EFFDT_CBM008"),
    (
        F.col("title_and_gender.UTA_HRA_POSITIONID")
        == F.col("position_data_max_effdt_cbm008.POSITION_NBR")
    ),
    "left",
)

rank_col = F.col("uta_tenure_max_org_upd_dt_cbm008.UTA_TT_RANK").cast("string")

rank_map = F.create_map(
    F.lit("10"), F.lit("1"),
    F.lit("20"), F.lit("2"),
    F.lit("30"), F.lit("3"),
    F.lit("40"), F.lit("5"),
    F.lit("50"), F.lit("6"),
    F.lit("60"), F.lit("4"),
)

df_read_tenure_record_cbm008 = df_read_tenure_record_cbm008.join(
    read_table(f"{student}.{bronze}.PS_UTZ_PT100_DTL").alias("PS_UTZ_PT100_DTL"),
    (
        (
            (
                (F.col("ps_utz_pt100_dtl.UTZ_PROG_ID") == F.lit("UTAS0036"))
                & (F.col("ps_utz_pt100_dtl.UTZ_SETUP_ID") == F.lit("DEPTID_ACADORG"))
            )
            & (
                F.col("position_data_max_effdt_cbm008.DEPTID")
                == F.col("ps_utz_pt100_dtl.UTZ_SETUP_VALUE")
            )
        )
        & (
            (
                (
                    F.col("ps_utz_pt100_dtl.UTZ_SETUP_RESULT").isNull()
                    | (F.col("ps_utz_pt100_dtl.UTZ_SETUP_RESULT") == F.lit(""))
                )
                | (
                    (F.col("ps_utz_pt100_dtl.UTZ_SETUP_RESULT") == F.lit("EQUAL"))
                    & (
                        F.col("title_and_gender.UTA_HRA_ACCT_10")
                        == F.col("ps_utz_pt100_dtl.UTZ_SETUP_SUBRSLT")
                    )
                )
            )
            | (
                (F.col("ps_utz_pt100_dtl.UTZ_SETUP_RESULT") == F.lit("NOT EQUAL"))
                & (
                    F.col("title_and_gender.UTA_HRA_ACCT_10")
                    != F.col("ps_utz_pt100_dtl.UTZ_SETUP_SUBRSLT")
                )
            )
        )
    ),
    "left",
)
df_read_tenure_record_cbm008 = df_read_tenure_record_cbm008.select(
    F.col("title_and_gender.SSN"),
    F.col("title_and_gender.CIT_CHK_EMPLID_PERS_NID"),
    F.col("title_and_gender.FOUND_IN_NAMES"),
    F.col("title_and_gender.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("title_and_gender.CIT_CHK_EMPLID"),
    F.col("title_and_gender.EMPL_RCD"),
    F.col("title_and_gender.UTA_HRE_MAJAPPTSEQ"),
    F.col("title_and_gender.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("title_and_gender.APPT_BEGIN_DT"),
    F.col("title_and_gender.APPT_END_DT"),
    F.col("title_and_gender.CBM_TERM"),
    F.col("title_and_gender.UTSHARE_FISCAL_YEAR"),
    F.col("title_and_gender.ACCT_CD_ADDL"),
    F.col("title_and_gender.DIST_PCT_ADDL"),
    F.col("title_and_gender.PCT_TIME_A"),
    F.col("title_and_gender.PCT_TIME_C"),
    F.col("title_and_gender.PCT_TIME_D"),
    F.col("title_and_gender.PCT_TIME_E"),
    F.col("title_and_gender.SALARY_A"),
    F.col("title_and_gender.SALARY_D"),
    F.col("title_and_gender.SALARY_X"),
    F.col("title_and_gender.SALARY_R"),
    F.col("title_and_gender.SALARY_Z"),
    F.col("title_and_gender.ADDL_PAY_ACCT_CD"),
    F.col("title_and_gender.ADDL_PAY_OTH_PAY"),
    F.col("title_and_gender.POSITION_NBR"),
    F.col("title_and_gender.ADDL_CLASS_FLD"),
    F.col("title_and_gender.ADDL_FUND_CODE"),
    F.col("title_and_gender.OVLP_ALLOC_REDIS_ADDL"),
    F.col("title_and_gender.SALARY_A_ADDL"),
    F.col("title_and_gender.SALARY_D_ADDL"),
    F.col("title_and_gender.SALARY_X_ADDL"),
    F.col("title_and_gender.SALARY_R_ADDL"),
    F.col("title_and_gender.SALARY_Z_ADDL"),
    F.when(
        (
            F.col("uta_tenure_max_org_upd_dt_cbm008.ACAD_ORG").isNull()
            | (F.col("uta_tenure_max_org_upd_dt_cbm008.ACAD_ORG") == F.lit(""))
        ),
        F.col("ps_utz_pt100_dtl.UTZ_SETUP_SUBVALUE"),
    )
    .otherwise(F.col("uta_tenure_max_org_upd_dt_cbm008.ACAD_ORG"))
    .alias("ACAD_ORG"),
    F.col("uta_tenure_max_org_upd_dt_cbm008.UTA_TT_RANK"),
    F.col("uta_tenure_max_org_upd_dt_cbm008.UTA_TT_STATUS"),
    F.col("title_and_gender.UTA_HRE_MAJORTITLE"),
    F.col("title_and_gender.STRM"),
    F.coalesce(
        rank_map[rank_col],
        F.lit("0")
    ).alias("RANK_CBM"),
    F.col("title_and_gender.TERM_END_DT"),
    F.col("title_and_gender.CENSUS_DT"),
    F.col("title_and_gender.UTA_HRE_BIRTH_DATE"),
    F.col("title_and_gender.UTA_HRE_GENDER"),
    F.col("title_and_gender.UTA_HRE_NAME_UL"),
    F.col("title_and_gender.FACULTY_CLASSIF"),
    F.col("title_and_gender.INSTRUCTOR_CLASSIF"),
    F.col("title_and_gender.UTA_HRE_CNT_SVC_DT"),
    F.col("title_and_gender.COMPLIANCE"),
    F.col("title_and_gender.ACAD_YEAR"),
    F.col("title_and_gender.UTA_HRE_STATUS"),
    F.col("title_and_gender.SOURCE"),
    F.col("title_and_gender.UTA_HRA_UNIT_CD"),
    F.col("title_and_gender.TERM_BEGIN_DT"),
)

# COMMAND ----------

log_view_count("READ_TENURE_RECORD_CBM008", df_read_tenure_record_cbm008)

# COMMAND ----------

# Step 55: ACAD_ORG_MAX_EFFDT
# Create temp view: ACAD_ORG_MAX_EFFDT_CBM008
df_acad_org_max_effdt_cbm008 = read_table(
    f"{student}.{bronze}.PS_ACAD_ORG_TBL"
).alias("PS_ACAD_ORG_TBL")
df_acad_org_max_effdt_cbm008 = df_acad_org_max_effdt_cbm008.filter(
    (
        (F.col("ps_acad_org_tbl.EFFDT") <= F.current_timestamp())
        & (F.col("ps_acad_org_tbl.EFF_STATUS") == F.lit("A"))
    )
)
df_acad_org_max_effdt_cbm008 = df_acad_org_max_effdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_acad_org_tbl.EFFDT")).over(
        Window.partitionBy("ps_acad_org_tbl.ACAD_ORG")
    ),
)
df_acad_org_max_effdt_cbm008 = df_acad_org_max_effdt_cbm008.filter(
    (F.col("ps_acad_org_tbl.EFFDT") == F.col("_agg_tmp_0"))
)
df_acad_org_max_effdt_cbm008 = df_acad_org_max_effdt_cbm008.drop("_agg_tmp_0")
df_acad_org_max_effdt_cbm008 = df_acad_org_max_effdt_cbm008.select(
    F.col("ps_acad_org_tbl.ACAD_ORG"),
    F.col("ps_acad_org_tbl.EFFDT"),
    F.col("ps_acad_org_tbl.EFF_STATUS"),
    F.col("ps_acad_org_tbl.DESCR"),
    F.col("ps_acad_org_tbl.DESCRSHORT"),
    F.col("ps_acad_org_tbl.DESCRFORMAL"),
    F.col("ps_acad_org_tbl.INSTITUTION"),
    F.col("ps_acad_org_tbl.CAMPUS"),
    F.col("ps_acad_org_tbl.MANAGER_ID"),
    F.col("ps_acad_org_tbl.INSTR_EDIT"),
    F.col("ps_acad_org_tbl.CAMPUS_EDIT"),
    F.col("ps_acad_org_tbl.SUBJECT_EDIT"),
    F.col("ps_acad_org_tbl.COURSE_EDIT"),
)
log_view_count("ACAD_ORG_MAX_EFFDT_CBM008", df_acad_org_max_effdt_cbm008)

# COMMAND ----------

# Step 56: VALIDATE_ORG
# Create temp view: VALIDATE_ORG_CBM008
df_validate_org_cbm008 = df_read_tenure_record_cbm008.alias("READ_TENURE_RECORD_CBM008")
df_validate_org_cbm008 = df_validate_org_cbm008.join(
    df_acad_org_max_effdt_cbm008.alias("ACAD_ORG_MAX_EFFDT_CBM008"),
    (
        (
            F.col("read_tenure_record_cbm008.ACAD_ORG").isNotNull()
            & (F.col("read_tenure_record_cbm008.ACAD_ORG") != F.lit(""))
        )
        & (
            F.col("read_tenure_record_cbm008.ACAD_ORG")
            == F.col("acad_org_max_effdt_cbm008.ACAD_ORG")
        )
    ),
    "left",
)
df_validate_org_cbm008 = df_validate_org_cbm008.select(
    F.col("read_tenure_record_cbm008.SSN"),
    F.col("read_tenure_record_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("read_tenure_record_cbm008.FOUND_IN_NAMES"),
    F.col("read_tenure_record_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("read_tenure_record_cbm008.CIT_CHK_EMPLID"),
    F.col("read_tenure_record_cbm008.EMPL_RCD"),
    F.col("read_tenure_record_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_tenure_record_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("read_tenure_record_cbm008.APPT_BEGIN_DT"),
    F.col("read_tenure_record_cbm008.APPT_END_DT"),
    F.col("read_tenure_record_cbm008.CBM_TERM"),
    F.col("read_tenure_record_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("read_tenure_record_cbm008.ACCT_CD_ADDL"),
    F.col("read_tenure_record_cbm008.DIST_PCT_ADDL"),
    F.col("read_tenure_record_cbm008.PCT_TIME_A"),
    F.col("read_tenure_record_cbm008.PCT_TIME_C"),
    F.col("read_tenure_record_cbm008.PCT_TIME_D"),
    F.col("read_tenure_record_cbm008.PCT_TIME_E"),
    F.col("read_tenure_record_cbm008.SALARY_A"),
    F.col("read_tenure_record_cbm008.SALARY_D"),
    F.col("read_tenure_record_cbm008.SALARY_X"),
    F.col("read_tenure_record_cbm008.SALARY_R"),
    F.col("read_tenure_record_cbm008.SALARY_Z"),
    F.col("read_tenure_record_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("read_tenure_record_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("read_tenure_record_cbm008.POSITION_NBR"),
    F.col("read_tenure_record_cbm008.ADDL_CLASS_FLD"),
    F.col("read_tenure_record_cbm008.ADDL_FUND_CODE"),
    F.col("read_tenure_record_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("read_tenure_record_cbm008.SALARY_A_ADDL"),
    F.col("read_tenure_record_cbm008.SALARY_D_ADDL"),
    F.col("read_tenure_record_cbm008.SALARY_X_ADDL"),
    F.col("read_tenure_record_cbm008.SALARY_R_ADDL"),
    F.col("read_tenure_record_cbm008.SALARY_Z_ADDL"),
    F.col("read_tenure_record_cbm008.ACAD_ORG"),
    F.col("read_tenure_record_cbm008.UTA_TT_RANK"),
    F.col("read_tenure_record_cbm008.UTA_TT_STATUS"),
    F.col("read_tenure_record_cbm008.UTA_HRE_MAJORTITLE"),
    F.when(
        (F.length(F.trim(F.col("acad_org_max_effdt_cbm008.DESCRSHORT"))) > F.lit(4)),
        F.lit(""),
    )
    .otherwise(F.trim(F.col("acad_org_max_effdt_cbm008.DESCRSHORT")))
    .alias("ACAD_ORG_UNITCD"),
    F.col("read_tenure_record_cbm008.STRM"),
    F.col("read_tenure_record_cbm008.RANK_CBM"),
    F.col("read_tenure_record_cbm008.TERM_END_DT"),
    F.col("read_tenure_record_cbm008.CENSUS_DT"),
    F.col("read_tenure_record_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_tenure_record_cbm008.UTA_HRE_GENDER"),
    F.col("read_tenure_record_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_tenure_record_cbm008.FACULTY_CLASSIF"),
    F.col("read_tenure_record_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("read_tenure_record_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_tenure_record_cbm008.COMPLIANCE"),
    F.col("read_tenure_record_cbm008.ACAD_YEAR"),
    F.col("read_tenure_record_cbm008.UTA_HRE_STATUS"),
    F.col("read_tenure_record_cbm008.SOURCE"),
    F.col("read_tenure_record_cbm008.UTA_HRA_UNIT_CD"),
    F.col("read_tenure_record_cbm008.TERM_BEGIN_DT"),
)
log_view_count("VALIDATE_ORG_CBM008", df_validate_org_cbm008)

# COMMAND ----------

# Step 57: FOUND_ACAD_ORG_UNITCD
# Create temp view: FOUND_ACAD_ORG_UNITCD_CBM008
df_found_acad_org_unitcd_cbm008 = df_validate_org_cbm008.alias("VALIDATE_ORG_CBM008")
df_found_acad_org_unitcd_cbm008 = df_found_acad_org_unitcd_cbm008.filter(
    ~(
        (F.col("validate_org_cbm008.ACAD_ORG_UNITCD") == F.lit(""))
        & F.col("validate_org_cbm008.RANK_CBM").isin(["5", "6"])
    )
)
df_found_acad_org_unitcd_cbm008 = df_found_acad_org_unitcd_cbm008.select(
    F.col("validate_org_cbm008.SSN"),
    F.col("validate_org_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("validate_org_cbm008.FOUND_IN_NAMES"),
    F.col("validate_org_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("validate_org_cbm008.CIT_CHK_EMPLID"),
    F.col("validate_org_cbm008.EMPL_RCD"),
    F.col("validate_org_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("validate_org_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("validate_org_cbm008.APPT_BEGIN_DT"),
    F.col("validate_org_cbm008.APPT_END_DT"),
    F.col("validate_org_cbm008.CBM_TERM"),
    F.col("validate_org_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("validate_org_cbm008.ACCT_CD_ADDL"),
    F.col("validate_org_cbm008.DIST_PCT_ADDL"),
    F.col("validate_org_cbm008.PCT_TIME_A"),
    F.col("validate_org_cbm008.PCT_TIME_C"),
    F.col("validate_org_cbm008.PCT_TIME_D"),
    F.col("validate_org_cbm008.PCT_TIME_E"),
    F.col("validate_org_cbm008.SALARY_A"),
    F.col("validate_org_cbm008.SALARY_D"),
    F.col("validate_org_cbm008.SALARY_X"),
    F.col("validate_org_cbm008.SALARY_R"),
    F.col("validate_org_cbm008.SALARY_Z"),
    F.col("validate_org_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("validate_org_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("validate_org_cbm008.POSITION_NBR"),
    F.col("validate_org_cbm008.ADDL_CLASS_FLD"),
    F.col("validate_org_cbm008.ADDL_FUND_CODE"),
    F.col("validate_org_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("validate_org_cbm008.SALARY_A_ADDL"),
    F.col("validate_org_cbm008.SALARY_D_ADDL"),
    F.col("validate_org_cbm008.SALARY_X_ADDL"),
    F.col("validate_org_cbm008.SALARY_R_ADDL"),
    F.col("validate_org_cbm008.SALARY_Z_ADDL"),
    F.col("validate_org_cbm008.ACAD_ORG"),
    F.col("validate_org_cbm008.UTA_TT_RANK"),
    F.col("validate_org_cbm008.UTA_TT_STATUS"),
    F.col("validate_org_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("validate_org_cbm008.ACAD_ORG_UNITCD"),
    F.col("validate_org_cbm008.STRM"),
    F.col("validate_org_cbm008.RANK_CBM"),
    F.col("validate_org_cbm008.TERM_END_DT"),
    F.col("validate_org_cbm008.CENSUS_DT"),
    F.col("validate_org_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("validate_org_cbm008.UTA_HRE_GENDER"),
    F.col("validate_org_cbm008.UTA_HRE_NAME_UL"),
    F.col("validate_org_cbm008.FACULTY_CLASSIF"),
    F.col("validate_org_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("validate_org_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("validate_org_cbm008.COMPLIANCE"),
    F.col("validate_org_cbm008.ACAD_YEAR"),
    F.col("validate_org_cbm008.UTA_HRE_STATUS"),
    F.col("validate_org_cbm008.SOURCE"),
    F.col("validate_org_cbm008.UTA_HRA_UNIT_CD"),
    F.col("validate_org_cbm008.TERM_BEGIN_DT"),
)
log_view_count("FOUND_ACAD_ORG_UNITCD_CBM008", df_found_acad_org_unitcd_cbm008)

# COMMAND ----------

# Step 58: MISSING_ACAD_ORG_UNITCD
# Create temp view: MISSING_ACAD_ORG_UNITCD_CBM008
df_missing_acad_org_unitcd_cbm008 = df_validate_org_cbm008.alias("VALIDATE_ORG_CBM008")
df_missing_acad_org_unitcd_cbm008 = df_missing_acad_org_unitcd_cbm008.filter(
    (
        (F.col("validate_org_cbm008.ACAD_ORG_UNITCD") == F.lit(""))
        & F.col("validate_org_cbm008.RANK_CBM").isin(["5", "6"])
    )
)
df_missing_acad_org_unitcd_cbm008 = df_missing_acad_org_unitcd_cbm008.select(
    F.col("validate_org_cbm008.SSN"),
    F.col("validate_org_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("validate_org_cbm008.FOUND_IN_NAMES"),
    F.col("validate_org_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("validate_org_cbm008.CIT_CHK_EMPLID"),
    F.col("validate_org_cbm008.EMPL_RCD"),
    F.col("validate_org_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("validate_org_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("validate_org_cbm008.APPT_BEGIN_DT"),
    F.col("validate_org_cbm008.APPT_END_DT"),
    F.col("validate_org_cbm008.CBM_TERM"),
    F.col("validate_org_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("validate_org_cbm008.ACCT_CD_ADDL"),
    F.col("validate_org_cbm008.DIST_PCT_ADDL"),
    F.col("validate_org_cbm008.PCT_TIME_A"),
    F.col("validate_org_cbm008.PCT_TIME_C"),
    F.col("validate_org_cbm008.PCT_TIME_D"),
    F.col("validate_org_cbm008.PCT_TIME_E"),
    F.col("validate_org_cbm008.SALARY_A"),
    F.col("validate_org_cbm008.SALARY_D"),
    F.col("validate_org_cbm008.SALARY_X"),
    F.col("validate_org_cbm008.SALARY_R"),
    F.col("validate_org_cbm008.SALARY_Z"),
    F.col("validate_org_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("validate_org_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("validate_org_cbm008.POSITION_NBR"),
    F.col("validate_org_cbm008.ADDL_CLASS_FLD"),
    F.col("validate_org_cbm008.ADDL_FUND_CODE"),
    F.col("validate_org_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("validate_org_cbm008.SALARY_A_ADDL"),
    F.col("validate_org_cbm008.SALARY_D_ADDL"),
    F.col("validate_org_cbm008.SALARY_X_ADDL"),
    F.col("validate_org_cbm008.SALARY_R_ADDL"),
    F.col("validate_org_cbm008.SALARY_Z_ADDL"),
    F.col("validate_org_cbm008.ACAD_ORG"),
    F.col("validate_org_cbm008.UTA_TT_RANK"),
    F.col("validate_org_cbm008.UTA_TT_STATUS"),
    F.col("validate_org_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("validate_org_cbm008.ACAD_ORG_UNITCD"),
    F.col("validate_org_cbm008.STRM"),
    F.col("validate_org_cbm008.RANK_CBM"),
    F.col("validate_org_cbm008.TERM_END_DT"),
    F.col("validate_org_cbm008.CENSUS_DT"),
    F.col("validate_org_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("validate_org_cbm008.UTA_HRE_GENDER"),
    F.col("validate_org_cbm008.UTA_HRE_NAME_UL"),
    F.col("validate_org_cbm008.FACULTY_CLASSIF"),
    F.col("validate_org_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("validate_org_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("validate_org_cbm008.COMPLIANCE"),
    F.col("validate_org_cbm008.ACAD_YEAR"),
    F.col("validate_org_cbm008.UTA_HRE_STATUS"),
    F.col("validate_org_cbm008.SOURCE"),
    F.col("validate_org_cbm008.UTA_HRA_UNIT_CD"),
    F.col("validate_org_cbm008.TERM_BEGIN_DT"),
)
log_view_count("MISSING_ACAD_ORG_UNITCD_CBM008", df_missing_acad_org_unitcd_cbm008)

# COMMAND ----------

# Step 59: GET_A_CRSEID
# Create temp view: GET_A_CRSEID_CBM008
df_get_a_crseid_cbm008 = df_missing_acad_org_unitcd_cbm008.alias(
    "MISSING_ACAD_ORG_UNITCD_CBM008"
)
df_get_a_crseid_cbm008 = df_get_a_crseid_cbm008.join(
    read_table(f"{student}.{bronze}.PS_CLASS_INSTR").alias("PS_CLASS_INSTR"),
    (
        (
            ~F.col("ps_class_instr.ASSIGN_TYPE").isin(["EXC", "NON"])
            & (
                F.col("missing_acad_org_unitcd_cbm008.CIT_CHK_EMPLID")
                == F.col("ps_class_instr.EMPLID")
            )
        )
        & (F.col("missing_acad_org_unitcd_cbm008.STRM") == F.col("ps_class_instr.STRM"))
    ),
    "left",
)
df_get_a_crseid_cbm008 = df_get_a_crseid_cbm008.select(
    F.col("missing_acad_org_unitcd_cbm008.SSN"),
    F.col("missing_acad_org_unitcd_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("missing_acad_org_unitcd_cbm008.FOUND_IN_NAMES"),
    F.col("missing_acad_org_unitcd_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("missing_acad_org_unitcd_cbm008.CIT_CHK_EMPLID"),
    F.col("missing_acad_org_unitcd_cbm008.EMPL_RCD"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("missing_acad_org_unitcd_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("missing_acad_org_unitcd_cbm008.APPT_BEGIN_DT"),
    F.col("missing_acad_org_unitcd_cbm008.APPT_END_DT"),
    F.col("missing_acad_org_unitcd_cbm008.CBM_TERM"),
    F.col("missing_acad_org_unitcd_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("missing_acad_org_unitcd_cbm008.ACCT_CD_ADDL"),
    F.col("missing_acad_org_unitcd_cbm008.DIST_PCT_ADDL"),
    F.col("missing_acad_org_unitcd_cbm008.PCT_TIME_A"),
    F.col("missing_acad_org_unitcd_cbm008.PCT_TIME_C"),
    F.col("missing_acad_org_unitcd_cbm008.PCT_TIME_D"),
    F.col("missing_acad_org_unitcd_cbm008.PCT_TIME_E"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_A"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_D"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_X"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_R"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_Z"),
    F.col("missing_acad_org_unitcd_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("missing_acad_org_unitcd_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("missing_acad_org_unitcd_cbm008.POSITION_NBR"),
    F.col("missing_acad_org_unitcd_cbm008.ADDL_CLASS_FLD"),
    F.col("missing_acad_org_unitcd_cbm008.ADDL_FUND_CODE"),
    F.col("missing_acad_org_unitcd_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_A_ADDL"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_D_ADDL"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_X_ADDL"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_R_ADDL"),
    F.col("missing_acad_org_unitcd_cbm008.SALARY_Z_ADDL"),
    F.col("missing_acad_org_unitcd_cbm008.ACAD_ORG"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_TT_RANK"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_TT_STATUS"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("missing_acad_org_unitcd_cbm008.ACAD_ORG_UNITCD"),
    F.col("missing_acad_org_unitcd_cbm008.STRM"),
    F.col("missing_acad_org_unitcd_cbm008.RANK_CBM"),
    F.col("ps_class_instr.CRSE_ID"),
    F.col("ps_class_instr.CRSE_OFFER_NBR"),
    F.col("missing_acad_org_unitcd_cbm008.TERM_END_DT"),
    F.col("missing_acad_org_unitcd_cbm008.CENSUS_DT"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_HRE_GENDER"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_HRE_NAME_UL"),
    F.col("missing_acad_org_unitcd_cbm008.FACULTY_CLASSIF"),
    F.col("missing_acad_org_unitcd_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("missing_acad_org_unitcd_cbm008.COMPLIANCE"),
    F.col("missing_acad_org_unitcd_cbm008.ACAD_YEAR"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_HRE_STATUS"),
    F.col("missing_acad_org_unitcd_cbm008.SOURCE"),
    F.col("missing_acad_org_unitcd_cbm008.UTA_HRA_UNIT_CD"),
    F.col("missing_acad_org_unitcd_cbm008.TERM_BEGIN_DT"),
)
log_view_count("GET_A_CRSEID_CBM008", df_get_a_crseid_cbm008)

# COMMAND ----------

# Step 60: READ_4_PRIMARY_APPT
# Create temp view: READ_4_PRIMARY_APPT_CBM008
df_read_4_primary_appt_cbm008 = df_get_a_crseid_cbm008.alias("GET_A_CRSEID_CBM008")
df_read_4_primary_appt_cbm008 = df_read_4_primary_appt_cbm008.select(
    F.col("get_a_crseid_cbm008.SSN"),
    F.col("get_a_crseid_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("get_a_crseid_cbm008.FOUND_IN_NAMES"),
    F.col("get_a_crseid_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("get_a_crseid_cbm008.CIT_CHK_EMPLID"),
    F.col("get_a_crseid_cbm008.EMPL_RCD"),
    F.col("get_a_crseid_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("get_a_crseid_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("get_a_crseid_cbm008.APPT_BEGIN_DT"),
    F.col("get_a_crseid_cbm008.APPT_END_DT"),
    F.col("get_a_crseid_cbm008.CBM_TERM"),
    F.col("get_a_crseid_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("get_a_crseid_cbm008.ACCT_CD_ADDL"),
    F.col("get_a_crseid_cbm008.DIST_PCT_ADDL"),
    F.col("get_a_crseid_cbm008.PCT_TIME_A"),
    F.col("get_a_crseid_cbm008.PCT_TIME_C"),
    F.col("get_a_crseid_cbm008.PCT_TIME_D"),
    F.col("get_a_crseid_cbm008.PCT_TIME_E"),
    F.col("get_a_crseid_cbm008.SALARY_A"),
    F.col("get_a_crseid_cbm008.SALARY_D"),
    F.col("get_a_crseid_cbm008.SALARY_X"),
    F.col("get_a_crseid_cbm008.SALARY_R"),
    F.col("get_a_crseid_cbm008.SALARY_Z"),
    F.col("get_a_crseid_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("get_a_crseid_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("get_a_crseid_cbm008.POSITION_NBR"),
    F.col("get_a_crseid_cbm008.ADDL_CLASS_FLD"),
    F.col("get_a_crseid_cbm008.ADDL_FUND_CODE"),
    F.col("get_a_crseid_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("get_a_crseid_cbm008.SALARY_A_ADDL"),
    F.col("get_a_crseid_cbm008.SALARY_D_ADDL"),
    F.col("get_a_crseid_cbm008.SALARY_X_ADDL"),
    F.col("get_a_crseid_cbm008.SALARY_R_ADDL"),
    F.col("get_a_crseid_cbm008.SALARY_Z_ADDL"),
    F.col("get_a_crseid_cbm008.ACAD_ORG"),
    F.col("get_a_crseid_cbm008.UTA_TT_RANK"),
    F.col("get_a_crseid_cbm008.UTA_TT_STATUS"),
    F.col("get_a_crseid_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("get_a_crseid_cbm008.ACAD_ORG_UNITCD"),
    F.col("get_a_crseid_cbm008.STRM"),
    F.col("get_a_crseid_cbm008.RANK_CBM"),
    F.col("get_a_crseid_cbm008.CRSE_ID"),
    F.col("get_a_crseid_cbm008.CRSE_OFFER_NBR"),
    F.col("get_a_crseid_cbm008.TERM_END_DT"),
    F.col("get_a_crseid_cbm008.CENSUS_DT"),
    F.col("get_a_crseid_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("get_a_crseid_cbm008.UTA_HRE_GENDER"),
    F.col("get_a_crseid_cbm008.UTA_HRE_NAME_UL"),
    F.col("get_a_crseid_cbm008.FACULTY_CLASSIF"),
    F.col("get_a_crseid_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("get_a_crseid_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("get_a_crseid_cbm008.COMPLIANCE"),
    F.col("get_a_crseid_cbm008.ACAD_YEAR"),
    F.col("get_a_crseid_cbm008.UTA_HRE_STATUS"),
    F.col("get_a_crseid_cbm008.SOURCE"),
    F.col("get_a_crseid_cbm008.UTA_HRA_UNIT_CD"),
    F.col("get_a_crseid_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Set Operators)
# Create temp view: ACAD_ORG_COMBINED
df_acad_org_combined_part0 = df_found_acad_org_unitcd_cbm008.alias(
    "found_acad_org_unitcd_cbm008"
)
df_acad_org_combined_part0 = df_acad_org_combined_part0.select(
    F.col("found_acad_org_unitcd_cbm008.SSN"),
    F.col("found_acad_org_unitcd_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("found_acad_org_unitcd_cbm008.FOUND_IN_NAMES"),
    F.col("found_acad_org_unitcd_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("found_acad_org_unitcd_cbm008.CIT_CHK_EMPLID"),
    F.col("found_acad_org_unitcd_cbm008.EMPL_RCD"),
    F.col("found_acad_org_unitcd_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("found_acad_org_unitcd_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("found_acad_org_unitcd_cbm008.APPT_BEGIN_DT"),
    F.col("found_acad_org_unitcd_cbm008.APPT_END_DT"),
    F.col("found_acad_org_unitcd_cbm008.CBM_TERM"),
    F.col("found_acad_org_unitcd_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("found_acad_org_unitcd_cbm008.ACCT_CD_ADDL"),
    F.col("found_acad_org_unitcd_cbm008.DIST_PCT_ADDL"),
    F.col("found_acad_org_unitcd_cbm008.PCT_TIME_A"),
    F.col("found_acad_org_unitcd_cbm008.PCT_TIME_C"),
    F.col("found_acad_org_unitcd_cbm008.PCT_TIME_D"),
    F.col("found_acad_org_unitcd_cbm008.PCT_TIME_E"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_A"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_D"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_X"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_R"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_Z"),
    F.col("found_acad_org_unitcd_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("found_acad_org_unitcd_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("found_acad_org_unitcd_cbm008.POSITION_NBR"),
    F.col("found_acad_org_unitcd_cbm008.ADDL_CLASS_FLD"),
    F.col("found_acad_org_unitcd_cbm008.ADDL_FUND_CODE"),
    F.col("found_acad_org_unitcd_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_A_ADDL"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_D_ADDL"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_X_ADDL"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_R_ADDL"),
    F.col("found_acad_org_unitcd_cbm008.SALARY_Z_ADDL"),
    F.col("found_acad_org_unitcd_cbm008.ACAD_ORG"),
    F.col("found_acad_org_unitcd_cbm008.UTA_TT_RANK"),
    F.col("found_acad_org_unitcd_cbm008.UTA_TT_STATUS"),
    F.col("found_acad_org_unitcd_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("found_acad_org_unitcd_cbm008.ACAD_ORG_UNITCD"),
    F.col("found_acad_org_unitcd_cbm008.STRM"),
    F.col("found_acad_org_unitcd_cbm008.RANK_CBM"),
    F.lit("").alias("CRSE_ID"),
    F.lit(None).alias("CRSE_OFFER_NBR"),
    F.col("found_acad_org_unitcd_cbm008.TERM_END_DT"),
    F.col("found_acad_org_unitcd_cbm008.CENSUS_DT"),
    F.col("found_acad_org_unitcd_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("found_acad_org_unitcd_cbm008.UTA_HRE_GENDER"),
    F.col("found_acad_org_unitcd_cbm008.UTA_HRE_NAME_UL"),
    F.col("found_acad_org_unitcd_cbm008.FACULTY_CLASSIF"),
    F.col("found_acad_org_unitcd_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("found_acad_org_unitcd_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("found_acad_org_unitcd_cbm008.COMPLIANCE"),
    F.col("found_acad_org_unitcd_cbm008.ACAD_YEAR"),
    F.col("found_acad_org_unitcd_cbm008.UTA_HRE_STATUS"),
    F.col("found_acad_org_unitcd_cbm008.SOURCE"),
    F.col("found_acad_org_unitcd_cbm008.UTA_HRA_UNIT_CD"),
    F.col("found_acad_org_unitcd_cbm008.TERM_BEGIN_DT"),
)
df_acad_org_combined_part1 = df_read_4_primary_appt_cbm008.alias(
    "read_4_primary_appt_cbm008"
)
df_acad_org_combined_part1 = df_acad_org_combined_part1.select(
    F.col("read_4_primary_appt_cbm008.SSN"),
    F.col("read_4_primary_appt_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("read_4_primary_appt_cbm008.FOUND_IN_NAMES"),
    F.col("read_4_primary_appt_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("read_4_primary_appt_cbm008.CIT_CHK_EMPLID"),
    F.col("read_4_primary_appt_cbm008.EMPL_RCD"),
    F.col("read_4_primary_appt_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_4_primary_appt_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("read_4_primary_appt_cbm008.APPT_BEGIN_DT"),
    F.col("read_4_primary_appt_cbm008.APPT_END_DT"),
    F.col("read_4_primary_appt_cbm008.CBM_TERM"),
    F.col("read_4_primary_appt_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("read_4_primary_appt_cbm008.ACCT_CD_ADDL"),
    F.col("read_4_primary_appt_cbm008.DIST_PCT_ADDL"),
    F.col("read_4_primary_appt_cbm008.PCT_TIME_A"),
    F.col("read_4_primary_appt_cbm008.PCT_TIME_C"),
    F.col("read_4_primary_appt_cbm008.PCT_TIME_D"),
    F.col("read_4_primary_appt_cbm008.PCT_TIME_E"),
    F.col("read_4_primary_appt_cbm008.SALARY_A"),
    F.col("read_4_primary_appt_cbm008.SALARY_D"),
    F.col("read_4_primary_appt_cbm008.SALARY_X"),
    F.col("read_4_primary_appt_cbm008.SALARY_R"),
    F.col("read_4_primary_appt_cbm008.SALARY_Z"),
    F.col("read_4_primary_appt_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("read_4_primary_appt_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("read_4_primary_appt_cbm008.POSITION_NBR"),
    F.col("read_4_primary_appt_cbm008.ADDL_CLASS_FLD"),
    F.col("read_4_primary_appt_cbm008.ADDL_FUND_CODE"),
    F.col("read_4_primary_appt_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("read_4_primary_appt_cbm008.SALARY_A_ADDL"),
    F.col("read_4_primary_appt_cbm008.SALARY_D_ADDL"),
    F.col("read_4_primary_appt_cbm008.SALARY_X_ADDL"),
    F.col("read_4_primary_appt_cbm008.SALARY_R_ADDL"),
    F.col("read_4_primary_appt_cbm008.SALARY_Z_ADDL"),
    F.col("read_4_primary_appt_cbm008.ACAD_ORG"),
    F.col("read_4_primary_appt_cbm008.UTA_TT_RANK"),
    F.col("read_4_primary_appt_cbm008.UTA_TT_STATUS"),
    F.col("read_4_primary_appt_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("read_4_primary_appt_cbm008.ACAD_ORG_UNITCD"),
    F.col("read_4_primary_appt_cbm008.STRM"),
    F.col("read_4_primary_appt_cbm008.RANK_CBM"),
    F.col("read_4_primary_appt_cbm008.CRSE_ID"),
    F.col("read_4_primary_appt_cbm008.CRSE_OFFER_NBR"),
    F.col("read_4_primary_appt_cbm008.TERM_END_DT"),
    F.col("read_4_primary_appt_cbm008.CENSUS_DT"),
    F.col("read_4_primary_appt_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_4_primary_appt_cbm008.UTA_HRE_GENDER"),
    F.col("read_4_primary_appt_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_4_primary_appt_cbm008.FACULTY_CLASSIF"),
    F.col("read_4_primary_appt_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("read_4_primary_appt_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_4_primary_appt_cbm008.COMPLIANCE"),
    F.col("read_4_primary_appt_cbm008.ACAD_YEAR"),
    F.col("read_4_primary_appt_cbm008.UTA_HRE_STATUS"),
    F.col("read_4_primary_appt_cbm008.SOURCE"),
    F.col("read_4_primary_appt_cbm008.UTA_HRA_UNIT_CD"),
    F.col("read_4_primary_appt_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

df_acad_org_combined = df_acad_org_combined_part0.union(df_acad_org_combined_part1)

# COMMAND ----------

# Checkpoint A: materialize df_acad_org_combined to break the upstream DAG (Steps 1-60)
# before the Spark Connect plan-analysis overhead accumulates over Steps 61-87.
# Without this, every cell in the 61-87 chain re-analyzes the full ~60-step lineage.
# Temp table is dropped immediately after the Step 98 write completes.
_tmp_stageA_tbl = f"{analytics}.{staging}._tmp_cbm008_stageA_acad_org"
write_df_to_table(
    df_acad_org_combined, _tmp_stageA_tbl, mode="overwrite", overwriteSchema="true"
)
df_acad_org_combined = read_table(_tmp_stageA_tbl).alias("ACAD_ORG_COMBINED")
log_msg(f"Checkpoint A materialized: {_tmp_stageA_tbl}")
log_view_count("ACAD_ORG_COMBINED (Checkpoint A)", df_acad_org_combined, do_count=True)

# COMMAND ----------

# Step 61: ETHNIC_GRP_MAX_EFFDT
# Create temp view: ETHNIC_GRP_MAX_EFFDT_CBM008
df_ethnic_grp_max_effdt_cbm008 = read_table(
    f"{student}.{bronze}.PS_HCR_ETHNIC_GRP_I"
).alias("PS_HCR_ETHNIC_GRP_I")
df_ethnic_grp_max_effdt_cbm008 = df_ethnic_grp_max_effdt_cbm008.filter(
    (F.col("ps_hcr_ethnic_grp_i.EFFDT") <= F.current_timestamp())
)
df_ethnic_grp_max_effdt_cbm008 = df_ethnic_grp_max_effdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_hcr_ethnic_grp_i.EFFDT")).over(
        Window.partitionBy(
            "ps_hcr_ethnic_grp_i.SETID", "ps_hcr_ethnic_grp_i.ETHNIC_GRP_CD"
        )
    ),
)
df_ethnic_grp_max_effdt_cbm008 = df_ethnic_grp_max_effdt_cbm008.filter(
    (F.col("ps_hcr_ethnic_grp_i.EFFDT") == F.col("_agg_tmp_0"))
)
df_ethnic_grp_max_effdt_cbm008 = df_ethnic_grp_max_effdt_cbm008.drop("_agg_tmp_0")
df_ethnic_grp_max_effdt_cbm008 = df_ethnic_grp_max_effdt_cbm008.select(
    F.col("ps_hcr_ethnic_grp_i.DESCR50"),
    F.col("ps_hcr_ethnic_grp_i.DESCRSHORT"),
    F.col("ps_hcr_ethnic_grp_i.EFF_STATUS"),
    F.col("ps_hcr_ethnic_grp_i.EFFDT"),
    F.col("ps_hcr_ethnic_grp_i.ETHNIC_CATEGORY"),
    F.col("ps_hcr_ethnic_grp_i.ETHNIC_GROUP"),
    F.col("ps_hcr_ethnic_grp_i.ETHNIC_GRP_CD"),
    F.col("ps_hcr_ethnic_grp_i.SETID"),
)
log_view_count("ETHNIC_GRP_MAX_EFFDT_CBM008", df_ethnic_grp_max_effdt_cbm008)

# COMMAND ----------

# Step 62: CALC_ETHN_GRP
# Create temp view: CALC_ETHN_GRP_CBM008
df_calc_ethn_grp_cbm008 = read_table(
    f"{student}.{bronze}.PS_HCR_DIV_ETHNIC_I"
).alias("PS_HCR_DIV_ETHNIC_I")
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.join(
    df_ethnic_grp_max_effdt_cbm008.alias("ETHNIC_GRP_MAX_EFFDT_CBM008"),
    (
        F.col("ps_hcr_div_ethnic_i.ETHNIC_GRP_CD")
        == F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GRP_CD")
    ),
    "inner",
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.filter(
    (
        (F.col("ps_hcr_div_ethnic_i.REG_REGION") == F.lit("USA"))
        & (F.col("ethnic_grp_max_effdt_cbm008.SETID") == F.lit("USA"))
    )
)
_winSpec_4 = Window.partitionBy(F.col("ps_hcr_div_ethnic_i.EMPLID"))
# NOTE: The derived ETHNIC_GROUP withColumn is moved to AFTER all RACE_* derivations
# below. withColumn("ETHNIC_GROUP", ...) replaces the original qualified column
# `ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP`, which the subsequent RACE_* expressions
# still need to reference.
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "ETHNIC_ORIGIN",
    F.min(
        F.when(
            (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("3")),
            F.lit("1"),
        ).otherwise(F.lit("3"))
    ).over(_winSpec_4),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "RACE_WHITE",
    F.max(
        F.when(
            (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("1")),
            F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP"),
        ).otherwise(F.lit(None).cast("string"))
    ).over(_winSpec_4),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "RACE_AFRICAN_AMERICAN",
    F.max(
        F.when(
            (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("2")),
            F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP"),
        ).otherwise(F.lit(None).cast("string"))
    ).over(_winSpec_4),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "RACE_ASIAN",
    F.max(
        F.when(
            (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("4")),
            F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP"),
        ).otherwise(F.lit(None).cast("string"))
    ).over(_winSpec_4),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "RACE_AMERICAN_INDIAN",
    F.max(
        F.when(
            (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("5")),
            F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP"),
        ).otherwise(F.lit(None).cast("string"))
    ).over(_winSpec_4),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "RACE_INTERNATIONAL",
    F.max(
        F.when(
            (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("6")),
            F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP"),
        ).otherwise(F.lit(None).cast("string"))
    ).over(_winSpec_4),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "_sel_tmp_7_0",
    F.max(
        F.when(
            (
                (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("7"))
                | ~F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP").isin(
                    ["1", "2", "3", "4", "5", "6", "7", "8"]
                )
            ),
            F.lit("7"),
        ).otherwise(F.lit(None).cast("string"))
    ).over(_winSpec_4),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "_sel_tmp_7_1",
    F.size(
        F.collect_set(F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP")).over(
            _winSpec_4
        )
    ),
)

# COMMAND ----------

df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "RACE_UNKOWN",
    F.when(
        (
            (F.col("_sel_tmp_7_1") == F.lit(1))
            & (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("3"))
        ),
        F.lit("7"),
    ).otherwise(F.col("_sel_tmp_7_0")),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.drop("_sel_tmp_7_0", "_sel_tmp_7_1")
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "RACE_HAWAIIN_PACIFIC_ISLANDER",
    F.max(
        F.when(
            (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("8")),
            F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP"),
        ).otherwise(F.lit(None).cast("string"))
    ).over(_winSpec_4),
)

# COMMAND ----------

# Derived ETHNIC_GROUP is computed LAST so it does not shadow the original
# `ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP` referenced by the RACE_* derivations above.
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "_sel_tmp_0_0",
    F.size(
        F.collect_set(F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP")).over(
            _winSpec_4
        )
    ),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.withColumn(
    "ETHNIC_GROUP",
    F.when(
        (
            (
                (F.col("_sel_tmp_0_0") > F.lit(1))
                | (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("3"))
            )
            | ~F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP").isin(
                ["1", "2", "3", "4", "5", "6", "7"]
            )
        ),
        F.lit("7"),
    ).otherwise(
        F.when(
            (F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP") == F.lit("8")),
            F.lit("4"),
        ).otherwise(F.col("ethnic_grp_max_effdt_cbm008.ETHNIC_GROUP"))
    ),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.drop("_sel_tmp_0_0")
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.select(
    F.col("ps_hcr_div_ethnic_i.EMPLID"),
    F.col("ETHNIC_GROUP"),
    F.col("ETHNIC_ORIGIN"),
    F.col("RACE_WHITE"),
    F.col("RACE_AFRICAN_AMERICAN"),
    F.col("RACE_ASIAN"),
    F.col("RACE_AMERICAN_INDIAN"),
    F.col("RACE_INTERNATIONAL"),
    F.col("RACE_UNKOWN"),
    F.col("RACE_HAWAIIN_PACIFIC_ISLANDER"),
)
df_calc_ethn_grp_cbm008 = df_calc_ethn_grp_cbm008.distinct()
log_view_count("CALC_ETHN_GRP_CBM008", df_calc_ethn_grp_cbm008)

# COMMAND ----------

# Step 63: GET_ETHNIC_INFO
# Create temp view: GET_ETHNIC_INFO_CBM008
df_get_ethnic_info_cbm008 = df_acad_org_combined.alias("ACAD_ORG_COMBINED")
df_get_ethnic_info_cbm008 = df_get_ethnic_info_cbm008.join(
    df_calc_ethn_grp_cbm008.alias("CALC_ETHN_GRP_CBM008"),
    (F.col("acad_org_combined.CIT_CHK_EMPLID") == F.col("calc_ethn_grp_cbm008.EMPLID")),
    "left",
)
df_get_ethnic_info_cbm008 = df_get_ethnic_info_cbm008.select(
    F.col("acad_org_combined.SSN"),
    F.col("acad_org_combined.CIT_CHK_EMPLID_PERS_NID"),
    F.col("acad_org_combined.FOUND_IN_NAMES"),
    F.col("acad_org_combined.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("acad_org_combined.CIT_CHK_EMPLID"),
    F.col("acad_org_combined.EMPL_RCD"),
    F.col("acad_org_combined.UTA_HRE_MAJAPPTSEQ"),
    F.col("acad_org_combined.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("acad_org_combined.APPT_BEGIN_DT"),
    F.col("acad_org_combined.APPT_END_DT"),
    F.col("acad_org_combined.CBM_TERM"),
    F.col("acad_org_combined.UTSHARE_FISCAL_YEAR"),
    F.col("acad_org_combined.ACCT_CD_ADDL"),
    F.col("acad_org_combined.DIST_PCT_ADDL"),
    F.col("acad_org_combined.PCT_TIME_A"),
    F.col("acad_org_combined.PCT_TIME_C"),
    F.col("acad_org_combined.PCT_TIME_D"),
    F.col("acad_org_combined.PCT_TIME_E"),
    F.col("acad_org_combined.SALARY_A"),
    F.col("acad_org_combined.SALARY_D"),
    F.col("acad_org_combined.SALARY_X"),
    F.col("acad_org_combined.SALARY_R"),
    F.col("acad_org_combined.SALARY_Z"),
    F.col("acad_org_combined.ADDL_PAY_ACCT_CD"),
    F.col("acad_org_combined.ADDL_PAY_OTH_PAY"),
    F.col("acad_org_combined.POSITION_NBR"),
    F.col("acad_org_combined.ADDL_CLASS_FLD"),
    F.col("acad_org_combined.ADDL_FUND_CODE"),
    F.col("acad_org_combined.OVLP_ALLOC_REDIS_ADDL"),
    F.col("acad_org_combined.SALARY_A_ADDL"),
    F.col("acad_org_combined.SALARY_D_ADDL"),
    F.col("acad_org_combined.SALARY_X_ADDL"),
    F.col("acad_org_combined.SALARY_R_ADDL"),
    F.col("acad_org_combined.SALARY_Z_ADDL"),
    F.col("acad_org_combined.ACAD_ORG"),
    F.col("acad_org_combined.UTA_TT_RANK"),
    F.col("acad_org_combined.UTA_TT_STATUS"),
    F.col("acad_org_combined.UTA_HRE_MAJORTITLE"),
    F.lit("").alias("UTA_HRA_TITLE_CD"),
    F.col("acad_org_combined.ACAD_ORG_UNITCD"),
    F.col("acad_org_combined.STRM"),
    F.col("acad_org_combined.RANK_CBM"),
    F.col("acad_org_combined.CRSE_ID"),
    F.col("acad_org_combined.CRSE_OFFER_NBR"),
    F.col("calc_ethn_grp_cbm008.ETHNIC_GROUP"),
    F.when(
        (
            F.col("calc_ethn_grp_cbm008.ETHNIC_ORIGIN").isNull()
            | (F.col("calc_ethn_grp_cbm008.ETHNIC_ORIGIN") == F.lit(""))
        ),
        F.lit("3"),
    )
    .otherwise(F.col("calc_ethn_grp_cbm008.ETHNIC_ORIGIN"))
    .alias("ETHNIC_ORIGIN"),
    F.col("calc_ethn_grp_cbm008.RACE_WHITE"),
    F.col("calc_ethn_grp_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("calc_ethn_grp_cbm008.RACE_ASIAN"),
    F.col("calc_ethn_grp_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("calc_ethn_grp_cbm008.RACE_INTERNATIONAL"),
    F.when(
        (
            F.col("calc_ethn_grp_cbm008.EMPLID").isNull()
            | (F.col("calc_ethn_grp_cbm008.EMPLID") == F.lit(""))
        ),
        F.lit("7"),
    )
    .otherwise(F.col("calc_ethn_grp_cbm008.RACE_UNKOWN"))
    .alias("RACE_UNKOWN"),
    F.col("calc_ethn_grp_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("acad_org_combined.TERM_END_DT"),
    F.col("acad_org_combined.CENSUS_DT"),
    F.col("acad_org_combined.UTA_HRE_BIRTH_DATE"),
    F.col("acad_org_combined.UTA_HRE_GENDER"),
    F.col("acad_org_combined.UTA_HRE_NAME_UL"),
    F.col("acad_org_combined.FACULTY_CLASSIF"),
    F.col("acad_org_combined.INSTRUCTOR_CLASSIF"),
    F.col("acad_org_combined.UTA_HRE_CNT_SVC_DT"),
    F.col("acad_org_combined.COMPLIANCE"),
    F.col("acad_org_combined.ACAD_YEAR"),
    F.col("acad_org_combined.UTA_HRE_STATUS"),
    F.col("acad_org_combined.SOURCE"),
    F.col("acad_org_combined.UTA_HRA_UNIT_CD"),
    F.col("acad_org_combined.TERM_BEGIN_DT"),
)
log_view_count("GET_ETHNIC_INFO_CBM008", df_get_ethnic_info_cbm008)

# COMMAND ----------

# Step 64: CITIZENSHIP_COUNTRY
# Create temp view: CITIZENSHIP_COUNTRY_CBM008
df_citizenship_country_cbm008 = read_table(
    f"{student}.{bronze}.PS_CITIZENSHIP"
).alias("PS_CITIZENSHIP")
df_citizenship_country_cbm008 = df_citizenship_country_cbm008.groupBy(
    "ps_citizenship.EMPLID"
).agg(
    F.max(
        F.when(
            (F.col("ps_citizenship.COUNTRY") == F.lit("XXX")), F.lit("XXX")
        ).otherwise(
            F.when(
                (F.col("ps_citizenship.COUNTRY") == F.lit("USA")),
                F.col("ps_citizenship.COUNTRY"),
            ).otherwise(F.lit(""))
        )
    ).alias("COUNTRY")
)
df_citizenship_country_cbm008 = df_citizenship_country_cbm008.distinct()
log_view_count("CITIZENSHIP_COUNTRY_CBM008", df_citizenship_country_cbm008)

# COMMAND ----------

# Step 65: CHECK_CITIZENSHIP
# Create temp view: CHECK_CITIZENSHIP_CBM008
df_check_citizenship_cbm008 = df_get_ethnic_info_cbm008.alias("GET_ETHNIC_INFO_CBM008")
df_check_citizenship_cbm008 = df_check_citizenship_cbm008.join(
    df_citizenship_country_cbm008.alias("CITIZENSHIP_COUNTRY_CBM008"),
    (
        F.col("get_ethnic_info_cbm008.CIT_CHK_EMPLID")
        == F.col("citizenship_country_cbm008.EMPLID")
    ),
    "left",
)
df_check_citizenship_cbm008 = df_check_citizenship_cbm008.select(
    F.col("get_ethnic_info_cbm008.SSN"),
    F.col("get_ethnic_info_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("get_ethnic_info_cbm008.FOUND_IN_NAMES"),
    F.col("get_ethnic_info_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("get_ethnic_info_cbm008.CIT_CHK_EMPLID"),
    F.col("get_ethnic_info_cbm008.EMPL_RCD"),
    F.col("get_ethnic_info_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("get_ethnic_info_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("get_ethnic_info_cbm008.APPT_BEGIN_DT"),
    F.col("get_ethnic_info_cbm008.APPT_END_DT"),
    F.col("get_ethnic_info_cbm008.CBM_TERM"),
    F.col("get_ethnic_info_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("get_ethnic_info_cbm008.ACCT_CD_ADDL"),
    F.col("get_ethnic_info_cbm008.DIST_PCT_ADDL"),
    F.col("get_ethnic_info_cbm008.PCT_TIME_A"),
    F.col("get_ethnic_info_cbm008.PCT_TIME_C"),
    F.col("get_ethnic_info_cbm008.PCT_TIME_D"),
    F.col("get_ethnic_info_cbm008.PCT_TIME_E"),
    F.col("get_ethnic_info_cbm008.SALARY_A"),
    F.col("get_ethnic_info_cbm008.SALARY_D"),
    F.col("get_ethnic_info_cbm008.SALARY_X"),
    F.col("get_ethnic_info_cbm008.SALARY_R"),
    F.col("get_ethnic_info_cbm008.SALARY_Z"),
    F.col("get_ethnic_info_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("get_ethnic_info_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("get_ethnic_info_cbm008.POSITION_NBR"),
    F.col("get_ethnic_info_cbm008.ADDL_CLASS_FLD"),
    F.col("get_ethnic_info_cbm008.ADDL_FUND_CODE"),
    F.col("get_ethnic_info_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("get_ethnic_info_cbm008.SALARY_A_ADDL"),
    F.col("get_ethnic_info_cbm008.SALARY_D_ADDL"),
    F.col("get_ethnic_info_cbm008.SALARY_X_ADDL"),
    F.col("get_ethnic_info_cbm008.SALARY_R_ADDL"),
    F.col("get_ethnic_info_cbm008.SALARY_Z_ADDL"),
    F.col("get_ethnic_info_cbm008.ACAD_ORG"),
    F.col("get_ethnic_info_cbm008.UTA_TT_RANK"),
    F.col("get_ethnic_info_cbm008.UTA_TT_STATUS"),
    F.col("get_ethnic_info_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("get_ethnic_info_cbm008.UTA_HRA_TITLE_CD"),
    F.col("get_ethnic_info_cbm008.ACAD_ORG_UNITCD"),
    F.col("get_ethnic_info_cbm008.STRM"),
    F.col("get_ethnic_info_cbm008.RANK_CBM"),
    F.col("get_ethnic_info_cbm008.CRSE_ID"),
    F.col("get_ethnic_info_cbm008.CRSE_OFFER_NBR"),
    F.col("get_ethnic_info_cbm008.ETHNIC_GROUP"),
    F.col("get_ethnic_info_cbm008.ETHNIC_ORIGIN"),
    F.when(
        (
            F.col("citizenship_country_cbm008.EMPLID").isNull()
            | (F.col("citizenship_country_cbm008.EMPLID") == F.lit(""))
        ),
        F.lit(""),
    )
    .otherwise(
        F.when(
            (F.col("citizenship_country_cbm008.COUNTRY") == F.lit("USA")),
            F.col("citizenship_country_cbm008.COUNTRY"),
        ).otherwise(F.lit("OTH"))
    )
    .alias("COUNTRY"),
    F.col("get_ethnic_info_cbm008.RACE_WHITE"),
    F.col("get_ethnic_info_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("get_ethnic_info_cbm008.RACE_ASIAN"),
    F.col("get_ethnic_info_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("get_ethnic_info_cbm008.RACE_INTERNATIONAL"),
    F.col("get_ethnic_info_cbm008.RACE_UNKOWN"),
    F.col("get_ethnic_info_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("get_ethnic_info_cbm008.TERM_END_DT"),
    F.col("get_ethnic_info_cbm008.CENSUS_DT"),
    F.col("get_ethnic_info_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("get_ethnic_info_cbm008.UTA_HRE_GENDER"),
    F.col("get_ethnic_info_cbm008.UTA_HRE_NAME_UL"),
    F.col("get_ethnic_info_cbm008.FACULTY_CLASSIF"),
    F.col("get_ethnic_info_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("get_ethnic_info_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("get_ethnic_info_cbm008.COMPLIANCE"),
    F.col("get_ethnic_info_cbm008.ACAD_YEAR"),
    F.col("get_ethnic_info_cbm008.UTA_HRE_STATUS"),
    F.col("get_ethnic_info_cbm008.SOURCE"),
    F.col("get_ethnic_info_cbm008.UTA_HRA_UNIT_CD"),
    F.col("get_ethnic_info_cbm008.TERM_BEGIN_DT"),
)
log_view_count("CHECK_CITIZENSHIP_CBM008", df_check_citizenship_cbm008)

# COMMAND ----------

# Step 66: VISA_PMT_MAX_EFFDT
# Create temp view: VISA_PMT_MAX_EFFDT_CBM008
df_visa_pmt_max_effdt_cbm008 = read_table(
    f"{student}.{bronze}.PS_VISA_PMT_DATA"
).alias("PS_VISA_PMT_DATA")
df_visa_pmt_max_effdt_cbm008 = df_visa_pmt_max_effdt_cbm008.filter(
    (F.col("ps_visa_pmt_data.EFFDT") <= F.current_timestamp())
)
df_visa_pmt_max_effdt_cbm008 = df_visa_pmt_max_effdt_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_visa_pmt_data.EFFDT")).over(
        Window.partitionBy("ps_visa_pmt_data.EMPLID")
    ),
)
df_visa_pmt_max_effdt_cbm008 = df_visa_pmt_max_effdt_cbm008.filter(
    (F.col("ps_visa_pmt_data.EFFDT") == F.col("_agg_tmp_0"))
)
df_visa_pmt_max_effdt_cbm008 = df_visa_pmt_max_effdt_cbm008.drop("_agg_tmp_0")
df_visa_pmt_max_effdt_cbm008 = df_visa_pmt_max_effdt_cbm008.select(
    F.col("ps_visa_pmt_data.EMPLID"),
    F.col("ps_visa_pmt_data.DEPENDENT_ID"),
    F.col("ps_visa_pmt_data.COUNTRY"),
    F.col("ps_visa_pmt_data.VISA_PERMIT_TYPE"),
    F.col("ps_visa_pmt_data.EFFDT"),
    F.col("ps_visa_pmt_data.VISA_WRKPMT_NBR"),
    F.col("ps_visa_pmt_data.VISA_WRKPMT_STATUS"),
    F.col("ps_visa_pmt_data.STATUS_DT"),
    F.col("ps_visa_pmt_data.DT_ISSUED"),
    F.col("ps_visa_pmt_data.PLACE_ISSUED"),
    F.col("ps_visa_pmt_data.DURATION_TIME"),
    F.col("ps_visa_pmt_data.DURATION_TYPE"),
    F.col("ps_visa_pmt_data.ENTRY_DT"),
    F.col("ps_visa_pmt_data.EXPIRATN_DT"),
    F.col("ps_visa_pmt_data.ISSUING_AUTHORITY"),
)
df_visa_pmt_max_effdt_cbm008 = df_visa_pmt_max_effdt_cbm008.distinct()
log_view_count("VISA_PMT_MAX_EFFDT_CBM008", df_visa_pmt_max_effdt_cbm008)

# COMMAND ----------

# Step 67: IDS_W_GOOD_PERMIT_TYPES
# Create temp view: IDS_W_GOOD_PERMIT_TYPES_CBM008
df_ids_w_good_permit_types_cbm008 = df_visa_pmt_max_effdt_cbm008.alias(
    "VISA_PMT_MAX_EFFDT_CBM008"
)
df_ids_w_good_permit_types_cbm008 = df_ids_w_good_permit_types_cbm008.filter(
    F.col("visa_pmt_max_effdt_cbm008.VISA_PERMIT_TYPE").isin(
        ["AR1", "ASY", "LPR", "PLP", "REF"]
    )
)
df_ids_w_good_permit_types_cbm008 = df_ids_w_good_permit_types_cbm008.select(
    F.col("visa_pmt_max_effdt_cbm008.EMPLID")
)
df_ids_w_good_permit_types_cbm008 = df_ids_w_good_permit_types_cbm008.distinct()
log_view_count("IDS_W_GOOD_PERMIT_TYPES_CBM008", df_ids_w_good_permit_types_cbm008)

# COMMAND ----------

# Step 68: CHECK_VISA_TYPE
# Create temp view: CHECK_VISA_TYPE_CBM008
df_check_visa_type_cbm008 = df_check_citizenship_cbm008.alias(
    "CHECK_CITIZENSHIP_CBM008"
)
df_check_visa_type_cbm008 = df_check_visa_type_cbm008.join(
    df_ids_w_good_permit_types_cbm008.alias("IDS_W_GOOD_PERMIT_TYPES_CBM008"),
    (
        F.col("check_citizenship_cbm008.CIT_CHK_EMPLID")
        == F.col("ids_w_good_permit_types_cbm008.EMPLID")
    ),
    "left",
)
df_check_visa_type_cbm008 = df_check_visa_type_cbm008.select(
    F.col("check_citizenship_cbm008.SSN"),
    F.col("check_citizenship_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("check_citizenship_cbm008.FOUND_IN_NAMES"),
    F.col("check_citizenship_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("check_citizenship_cbm008.CIT_CHK_EMPLID"),
    F.col("check_citizenship_cbm008.EMPL_RCD"),
    F.col("check_citizenship_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("check_citizenship_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("check_citizenship_cbm008.APPT_BEGIN_DT"),
    F.col("check_citizenship_cbm008.APPT_END_DT"),
    F.col("check_citizenship_cbm008.CBM_TERM"),
    F.col("check_citizenship_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("check_citizenship_cbm008.ACCT_CD_ADDL"),
    F.col("check_citizenship_cbm008.DIST_PCT_ADDL"),
    F.col("check_citizenship_cbm008.PCT_TIME_A"),
    F.col("check_citizenship_cbm008.PCT_TIME_C"),
    F.col("check_citizenship_cbm008.PCT_TIME_D"),
    F.col("check_citizenship_cbm008.PCT_TIME_E"),
    F.col("check_citizenship_cbm008.SALARY_A"),
    F.col("check_citizenship_cbm008.SALARY_D"),
    F.col("check_citizenship_cbm008.SALARY_X"),
    F.col("check_citizenship_cbm008.SALARY_R"),
    F.col("check_citizenship_cbm008.SALARY_Z"),
    F.col("check_citizenship_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("check_citizenship_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("check_citizenship_cbm008.POSITION_NBR"),
    F.col("check_citizenship_cbm008.ADDL_CLASS_FLD"),
    F.col("check_citizenship_cbm008.ADDL_FUND_CODE"),
    F.col("check_citizenship_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("check_citizenship_cbm008.SALARY_A_ADDL"),
    F.col("check_citizenship_cbm008.SALARY_D_ADDL"),
    F.col("check_citizenship_cbm008.SALARY_X_ADDL"),
    F.col("check_citizenship_cbm008.SALARY_R_ADDL"),
    F.col("check_citizenship_cbm008.SALARY_Z_ADDL"),
    F.col("check_citizenship_cbm008.ACAD_ORG"),
    F.col("check_citizenship_cbm008.UTA_TT_RANK"),
    F.col("check_citizenship_cbm008.UTA_TT_STATUS"),
    F.col("check_citizenship_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("check_citizenship_cbm008.UTA_HRA_TITLE_CD"),
    F.col("check_citizenship_cbm008.ACAD_ORG_UNITCD"),
    F.col("check_citizenship_cbm008.STRM"),
    F.col("check_citizenship_cbm008.RANK_CBM"),
    F.col("check_citizenship_cbm008.CRSE_ID"),
    F.col("check_citizenship_cbm008.CRSE_OFFER_NBR"),
    F.col("check_citizenship_cbm008.ETHNIC_GROUP"),
    F.col("check_citizenship_cbm008.ETHNIC_ORIGIN"),
    F.col("check_citizenship_cbm008.COUNTRY"),
    F.when(F.col("ids_w_good_permit_types_cbm008.EMPLID").isNotNull(), F.lit("Y"))
    .otherwise(F.lit("N"))
    .alias("PERMIT_TYPE_IN_LIST"),
    F.col("check_citizenship_cbm008.RACE_WHITE"),
    F.col("check_citizenship_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("check_citizenship_cbm008.RACE_ASIAN"),
    F.col("check_citizenship_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("check_citizenship_cbm008.RACE_INTERNATIONAL"),
    F.col("check_citizenship_cbm008.RACE_UNKOWN"),
    F.col("check_citizenship_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("check_citizenship_cbm008.TERM_END_DT"),
    F.col("check_citizenship_cbm008.CENSUS_DT"),
    F.col("check_citizenship_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("check_citizenship_cbm008.UTA_HRE_GENDER"),
    F.col("check_citizenship_cbm008.UTA_HRE_NAME_UL"),
    F.col("check_citizenship_cbm008.FACULTY_CLASSIF"),
    F.col("check_citizenship_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("check_citizenship_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("check_citizenship_cbm008.COMPLIANCE"),
    F.col("check_citizenship_cbm008.ACAD_YEAR"),
    F.col("check_citizenship_cbm008.UTA_HRE_STATUS"),
    F.col("check_citizenship_cbm008.SOURCE"),
    F.col("check_citizenship_cbm008.UTA_HRA_UNIT_CD"),
    F.col("check_citizenship_cbm008.TERM_BEGIN_DT"),
)
log_view_count("CHECK_VISA_TYPE_CBM008", df_check_visa_type_cbm008)

# COMMAND ----------

# Step 69: INTERNATIONAL_CALC
# Create temp view: INTERNATIONAL_CALC_CBM008
df_international_calc_cbm008 = df_check_visa_type_cbm008.alias("CHECK_VISA_TYPE_CBM008")
df_international_calc_cbm008 = df_international_calc_cbm008.select(
    F.col("check_visa_type_cbm008.SSN"),
    F.col("check_visa_type_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("check_visa_type_cbm008.FOUND_IN_NAMES"),
    F.col("check_visa_type_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("check_visa_type_cbm008.CIT_CHK_EMPLID"),
    F.col("check_visa_type_cbm008.EMPL_RCD"),
    F.col("check_visa_type_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("check_visa_type_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("check_visa_type_cbm008.APPT_BEGIN_DT"),
    F.col("check_visa_type_cbm008.APPT_END_DT"),
    F.col("check_visa_type_cbm008.CBM_TERM"),
    F.col("check_visa_type_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("check_visa_type_cbm008.ACCT_CD_ADDL"),
    F.col("check_visa_type_cbm008.DIST_PCT_ADDL"),
    F.col("check_visa_type_cbm008.PCT_TIME_A"),
    F.col("check_visa_type_cbm008.PCT_TIME_C"),
    F.col("check_visa_type_cbm008.PCT_TIME_D"),
    F.col("check_visa_type_cbm008.PCT_TIME_E"),
    F.col("check_visa_type_cbm008.SALARY_A"),
    F.col("check_visa_type_cbm008.SALARY_D"),
    F.col("check_visa_type_cbm008.SALARY_X"),
    F.col("check_visa_type_cbm008.SALARY_R"),
    F.col("check_visa_type_cbm008.SALARY_Z"),
    F.col("check_visa_type_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("check_visa_type_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("check_visa_type_cbm008.POSITION_NBR"),
    F.col("check_visa_type_cbm008.ADDL_CLASS_FLD"),
    F.col("check_visa_type_cbm008.ADDL_FUND_CODE"),
    F.col("check_visa_type_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("check_visa_type_cbm008.SALARY_A_ADDL"),
    F.col("check_visa_type_cbm008.SALARY_D_ADDL"),
    F.col("check_visa_type_cbm008.SALARY_X_ADDL"),
    F.col("check_visa_type_cbm008.SALARY_R_ADDL"),
    F.col("check_visa_type_cbm008.SALARY_Z_ADDL"),
    F.col("check_visa_type_cbm008.ACAD_ORG"),
    F.col("check_visa_type_cbm008.UTA_TT_RANK"),
    F.col("check_visa_type_cbm008.UTA_TT_STATUS"),
    F.col("check_visa_type_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("check_visa_type_cbm008.UTA_HRA_TITLE_CD"),
    F.col("check_visa_type_cbm008.ACAD_ORG_UNITCD"),
    F.col("check_visa_type_cbm008.STRM"),
    F.col("check_visa_type_cbm008.RANK_CBM"),
    F.col("check_visa_type_cbm008.CRSE_ID"),
    F.col("check_visa_type_cbm008.CRSE_OFFER_NBR"),
    F.when(
        (
            ~F.col("check_visa_type_cbm008.COUNTRY").isin(["", "USA"])
            & (F.col("check_visa_type_cbm008.PERMIT_TYPE_IN_LIST") == F.lit("N"))
        ),
        F.lit("6"),
    )
    .otherwise(F.col("check_visa_type_cbm008.ETHNIC_GROUP"))
    .alias("ETHNIC_GROUP"),
    F.col("check_visa_type_cbm008.ETHNIC_ORIGIN"),
    F.col("check_visa_type_cbm008.COUNTRY"),
    F.col("check_visa_type_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("check_visa_type_cbm008.RACE_WHITE"),
    F.col("check_visa_type_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("check_visa_type_cbm008.RACE_ASIAN"),
    F.col("check_visa_type_cbm008.RACE_AMERICAN_INDIAN"),
    F.when(
        (
            ~F.col("check_visa_type_cbm008.COUNTRY").isin(["", "USA"])
            & (F.col("check_visa_type_cbm008.PERMIT_TYPE_IN_LIST") == F.lit("N"))
        ),
        F.lit("6"),
    )
    .otherwise(F.col("check_visa_type_cbm008.RACE_INTERNATIONAL"))
    .alias("RACE_INTERNATIONAL"),
    F.when(
        (
            ~F.col("check_visa_type_cbm008.COUNTRY").isin(["", "USA"])
            & (F.col("check_visa_type_cbm008.PERMIT_TYPE_IN_LIST") == F.lit("N"))
        ),
        F.lit(None).cast("string"),
    )
    .otherwise(F.col("check_visa_type_cbm008.RACE_UNKOWN"))
    .alias("RACE_UNKOWN"),
    F.col("check_visa_type_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("check_visa_type_cbm008.TERM_END_DT"),
    F.col("check_visa_type_cbm008.CENSUS_DT"),
    F.col("check_visa_type_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("check_visa_type_cbm008.UTA_HRE_GENDER"),
    F.col("check_visa_type_cbm008.UTA_HRE_NAME_UL"),
    F.col("check_visa_type_cbm008.FACULTY_CLASSIF"),
    F.col("check_visa_type_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("check_visa_type_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("check_visa_type_cbm008.COMPLIANCE"),
    F.col("check_visa_type_cbm008.ACAD_YEAR"),
    F.col("check_visa_type_cbm008.UTA_HRE_STATUS"),
    F.col("check_visa_type_cbm008.SOURCE"),
    F.col("check_visa_type_cbm008.UTA_HRA_UNIT_CD"),
    F.col("check_visa_type_cbm008.TERM_BEGIN_DT"),
)
log_view_count("INTERNATIONAL_CALC_CBM008", df_international_calc_cbm008)

# COMMAND ----------

# Step 70: PERCENT_CALC
# Create temp view: PERCENT_CALC_CBM008
df_percent_calc_cbm008 = df_international_calc_cbm008.alias("INTERNATIONAL_CALC_CBM008")
df_percent_calc_cbm008 = df_percent_calc_cbm008.select(
    F.col("international_calc_cbm008.SSN"),
    F.col("international_calc_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("international_calc_cbm008.FOUND_IN_NAMES"),
    F.col("international_calc_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("international_calc_cbm008.CIT_CHK_EMPLID"),
    F.col("international_calc_cbm008.EMPL_RCD"),
    F.col("international_calc_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("international_calc_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("international_calc_cbm008.APPT_BEGIN_DT"),
    F.col("international_calc_cbm008.APPT_END_DT"),
    F.col("international_calc_cbm008.CBM_TERM"),
    F.col("international_calc_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("international_calc_cbm008.ACCT_CD_ADDL"),
    F.col("international_calc_cbm008.DIST_PCT_ADDL"),
    F.col("international_calc_cbm008.PCT_TIME_A"),
    F.col("international_calc_cbm008.PCT_TIME_C"),
    F.col("international_calc_cbm008.PCT_TIME_D"),
    F.col("international_calc_cbm008.PCT_TIME_E"),
    F.col("international_calc_cbm008.SALARY_A"),
    F.col("international_calc_cbm008.SALARY_D"),
    F.col("international_calc_cbm008.SALARY_X"),
    F.col("international_calc_cbm008.SALARY_R"),
    F.col("international_calc_cbm008.SALARY_Z"),
    F.col("international_calc_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("international_calc_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("international_calc_cbm008.POSITION_NBR"),
    F.col("international_calc_cbm008.ADDL_CLASS_FLD"),
    F.col("international_calc_cbm008.ADDL_FUND_CODE"),
    F.col("international_calc_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("international_calc_cbm008.SALARY_A_ADDL"),
    F.col("international_calc_cbm008.SALARY_D_ADDL"),
    F.col("international_calc_cbm008.SALARY_X_ADDL"),
    F.col("international_calc_cbm008.SALARY_R_ADDL"),
    F.col("international_calc_cbm008.SALARY_Z_ADDL"),
    F.col("international_calc_cbm008.ACAD_ORG"),
    F.col("international_calc_cbm008.UTA_TT_RANK"),
    F.col("international_calc_cbm008.UTA_TT_STATUS"),
    F.col("international_calc_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("international_calc_cbm008.UTA_HRA_TITLE_CD"),
    F.col("international_calc_cbm008.ACAD_ORG_UNITCD"),
    F.col("international_calc_cbm008.STRM"),
    F.col("international_calc_cbm008.RANK_CBM"),
    F.col("international_calc_cbm008.CRSE_ID"),
    F.col("international_calc_cbm008.CRSE_OFFER_NBR"),
    F.col("international_calc_cbm008.ETHNIC_GROUP"),
    F.col("international_calc_cbm008.ETHNIC_ORIGIN"),
    F.col("international_calc_cbm008.COUNTRY"),
    F.col("international_calc_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("international_calc_cbm008.ETHNIC_ORIGIN").alias("ETHINIC_ORIGIN"),
    F.col("international_calc_cbm008.RACE_WHITE"),
    F.col("international_calc_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("international_calc_cbm008.RACE_ASIAN"),
    F.col("international_calc_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("international_calc_cbm008.RACE_INTERNATIONAL"),
    F.col("international_calc_cbm008.RACE_UNKOWN"),
    F.col("international_calc_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    # SAS: IFC(PCT_TIME_A IS MISSING,'000', IFC(PCT_TIME_A>=100,'100', PUT(PCT_TIME_A,Z3.)))
    F.when(
        F.col("international_calc_cbm008.PCT_TIME_A").isNull(),
        F.lit("000"),
    )
    .otherwise(
        F.when(
            (F.col("international_calc_cbm008.PCT_TIME_A") >= F.lit(100)), F.lit("100")
        ).otherwise(
            F.lpad(
                F.col("international_calc_cbm008.PCT_TIME_A")
                .cast("INT")
                .cast("STRING"),
                3,
                "0",
            )
        )
    )
    .alias("PERCENT_APPOINMENT_01"),
    F.lit("000").alias("PERCENT_APPOINMENT_02"),
    F.when(
        F.col("international_calc_cbm008.PCT_TIME_C").isNull(),
        F.lit("000"),
    )
    .otherwise(
        F.when(
            (F.col("international_calc_cbm008.PCT_TIME_C") >= F.lit(100)), F.lit("100")
        ).otherwise(
            F.lpad(
                F.col("international_calc_cbm008.PCT_TIME_C")
                .cast("INT")
                .cast("STRING"),
                3,
                "0",
            )
        )
    )
    .alias("PERCENT_APPOINMENT_11"),
    F.when(
        F.col("international_calc_cbm008.PCT_TIME_D").isNull(),
        F.lit("000"),
    )
    .otherwise(
        F.when(
            (F.col("international_calc_cbm008.PCT_TIME_D") >= F.lit(100)), F.lit("100")
        ).otherwise(
            F.lpad(
                F.col("international_calc_cbm008.PCT_TIME_D")
                .cast("INT")
                .cast("STRING"),
                3,
                "0",
            )
        )
    )
    .alias("PERCENT_APPOINMENT_12"),
    F.when(
        F.col("international_calc_cbm008.PCT_TIME_E").isNull(),
        F.lit("000"),
    )
    .otherwise(
        F.when(
            (F.col("international_calc_cbm008.PCT_TIME_E") >= F.lit(100)), F.lit("100")
        ).otherwise(
            F.lpad(
                F.col("international_calc_cbm008.PCT_TIME_E")
                .cast("INT")
                .cast("STRING"),
                3,
                "0",
            )
        )
    )
    .alias("PERCENT_APPOINMENT_13"),
    F.col("international_calc_cbm008.TERM_END_DT"),
    F.col("international_calc_cbm008.CENSUS_DT"),
    F.col("international_calc_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("international_calc_cbm008.UTA_HRE_GENDER"),
    F.col("international_calc_cbm008.UTA_HRE_NAME_UL"),
    F.col("international_calc_cbm008.FACULTY_CLASSIF"),
    F.col("international_calc_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("international_calc_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("international_calc_cbm008.COMPLIANCE"),
    F.col("international_calc_cbm008.ACAD_YEAR"),
    F.col("international_calc_cbm008.UTA_HRE_STATUS"),
    F.col("international_calc_cbm008.SOURCE"),
    F.col("international_calc_cbm008.UTA_HRA_UNIT_CD"),
    F.col("international_calc_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

log_view_count("PERCENT_CALC_CBM008", df_percent_calc_cbm008)

# COMMAND ----------

# Step 71: AGG_SALARY
# Create temp view: AGG_SALARY_CBM008
df_agg_salary_cbm008 = df_percent_calc_cbm008.alias("PERCENT_CALC_CBM008")
df_agg_salary_cbm008 = df_agg_salary_cbm008.select(
    F.col("percent_calc_cbm008.SSN"),
    F.col("percent_calc_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("percent_calc_cbm008.FOUND_IN_NAMES"),
    F.col("percent_calc_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("percent_calc_cbm008.CIT_CHK_EMPLID"),
    F.col("percent_calc_cbm008.EMPL_RCD"),
    F.col("percent_calc_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("percent_calc_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("percent_calc_cbm008.APPT_BEGIN_DT"),
    F.col("percent_calc_cbm008.APPT_END_DT"),
    F.col("percent_calc_cbm008.CBM_TERM"),
    F.col("percent_calc_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("percent_calc_cbm008.ACCT_CD_ADDL"),
    F.col("percent_calc_cbm008.DIST_PCT_ADDL"),
    F.col("percent_calc_cbm008.PCT_TIME_A"),
    F.col("percent_calc_cbm008.PCT_TIME_C"),
    F.col("percent_calc_cbm008.PCT_TIME_D"),
    F.col("percent_calc_cbm008.PCT_TIME_E"),
    F.col("percent_calc_cbm008.SALARY_A"),
    F.col("percent_calc_cbm008.SALARY_D"),
    F.col("percent_calc_cbm008.SALARY_X"),
    F.col("percent_calc_cbm008.SALARY_R"),
    F.col("percent_calc_cbm008.SALARY_Z"),
    F.col("percent_calc_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("percent_calc_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("percent_calc_cbm008.POSITION_NBR"),
    F.col("percent_calc_cbm008.ADDL_CLASS_FLD"),
    F.col("percent_calc_cbm008.ADDL_FUND_CODE"),
    F.col("percent_calc_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("percent_calc_cbm008.SALARY_A_ADDL"),
    F.col("percent_calc_cbm008.SALARY_D_ADDL"),
    F.col("percent_calc_cbm008.SALARY_X_ADDL"),
    F.col("percent_calc_cbm008.SALARY_R_ADDL"),
    F.col("percent_calc_cbm008.SALARY_Z_ADDL"),
    F.col("percent_calc_cbm008.ACAD_ORG"),
    F.col("percent_calc_cbm008.UTA_TT_RANK"),
    F.col("percent_calc_cbm008.UTA_TT_STATUS"),
    F.col("percent_calc_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("percent_calc_cbm008.UTA_HRA_TITLE_CD"),
    F.col("percent_calc_cbm008.ACAD_ORG_UNITCD"),
    F.col("percent_calc_cbm008.STRM"),
    F.col("percent_calc_cbm008.RANK_CBM"),
    F.col("percent_calc_cbm008.CRSE_ID"),
    F.col("percent_calc_cbm008.CRSE_OFFER_NBR"),
    F.col("percent_calc_cbm008.ETHNIC_GROUP"),
    F.col("percent_calc_cbm008.ETHNIC_ORIGIN"),
    F.col("percent_calc_cbm008.COUNTRY"),
    F.col("percent_calc_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("percent_calc_cbm008.ETHINIC_ORIGIN"),
    F.col("percent_calc_cbm008.RACE_WHITE"),
    F.col("percent_calc_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("percent_calc_cbm008.RACE_ASIAN"),
    F.col("percent_calc_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("percent_calc_cbm008.RACE_INTERNATIONAL"),
    F.col("percent_calc_cbm008.RACE_UNKOWN"),
    F.col("percent_calc_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("percent_calc_cbm008.PERCENT_APPOINMENT_01"),
    F.col("percent_calc_cbm008.PERCENT_APPOINMENT_02"),
    F.col("percent_calc_cbm008.PERCENT_APPOINMENT_11"),
    F.col("percent_calc_cbm008.PERCENT_APPOINMENT_12"),
    F.col("percent_calc_cbm008.PERCENT_APPOINMENT_13"),
    (
        F.coalesce(F.col("percent_calc_cbm008.SALARY_A_ADDL"), F.lit(0))
        + F.coalesce(F.col("percent_calc_cbm008.SALARY_A"), F.lit(0))
    ).alias("SALARY_A_AGG"),
    (
        F.coalesce(F.col("percent_calc_cbm008.SALARY_D_ADDL"), F.lit(0))
        + F.coalesce(F.col("percent_calc_cbm008.SALARY_D"), F.lit(0))
    ).alias("SALARY_D_AGG"),
    (
        F.coalesce(F.col("percent_calc_cbm008.SALARY_X_ADDL"), F.lit(0))
        + F.coalesce(F.col("percent_calc_cbm008.SALARY_X"), F.lit(0))
    ).alias("SALARY_X_AGG"),
    (
        F.coalesce(F.col("percent_calc_cbm008.SALARY_R_ADDL"), F.lit(0))
        + F.coalesce(F.col("percent_calc_cbm008.SALARY_R"), F.lit(0))
    ).alias("SALARY_R_AGG"),
    (
        F.coalesce(F.col("percent_calc_cbm008.SALARY_Z_ADDL"), F.lit(0))
        + F.coalesce(F.col("percent_calc_cbm008.SALARY_Z"), F.lit(0))
    ).alias("SALARY_Z_AGG"),
    F.col("percent_calc_cbm008.TERM_END_DT"),
    F.col("percent_calc_cbm008.CENSUS_DT"),
    F.col("percent_calc_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("percent_calc_cbm008.UTA_HRE_GENDER"),
    F.col("percent_calc_cbm008.UTA_HRE_NAME_UL"),
    F.col("percent_calc_cbm008.FACULTY_CLASSIF"),
    F.col("percent_calc_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("percent_calc_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("percent_calc_cbm008.COMPLIANCE"),
    F.col("percent_calc_cbm008.ACAD_YEAR"),
    F.col("percent_calc_cbm008.UTA_HRE_STATUS"),
    F.col("percent_calc_cbm008.SOURCE"),
    F.col("percent_calc_cbm008.UTA_HRA_UNIT_CD"),
    F.col("percent_calc_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

log_view_count("AGG_SALARY_CBM008", df_agg_salary_cbm008)

# COMMAND ----------

# Step 72: SALARY_CALC
# Create temp view: SALARY_CALC_CBM008
df_salary_calc_cbm008 = df_agg_salary_cbm008.alias("AGG_SALARY_CBM008")
df_salary_calc_cbm008 = df_salary_calc_cbm008.select(
    F.col("agg_salary_cbm008.SSN"),
    F.col("agg_salary_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("agg_salary_cbm008.FOUND_IN_NAMES"),
    F.col("agg_salary_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("agg_salary_cbm008.CIT_CHK_EMPLID"),
    F.col("agg_salary_cbm008.EMPL_RCD"),
    F.col("agg_salary_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("agg_salary_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("agg_salary_cbm008.APPT_BEGIN_DT"),
    F.col("agg_salary_cbm008.APPT_END_DT"),
    F.col("agg_salary_cbm008.CBM_TERM"),
    F.col("agg_salary_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("agg_salary_cbm008.ACCT_CD_ADDL"),
    F.col("agg_salary_cbm008.DIST_PCT_ADDL"),
    F.col("agg_salary_cbm008.PCT_TIME_A"),
    F.col("agg_salary_cbm008.PCT_TIME_C"),
    F.col("agg_salary_cbm008.PCT_TIME_D"),
    F.col("agg_salary_cbm008.PCT_TIME_E"),
    F.col("agg_salary_cbm008.SALARY_A"),
    F.col("agg_salary_cbm008.SALARY_D"),
    F.col("agg_salary_cbm008.SALARY_X"),
    F.col("agg_salary_cbm008.SALARY_R"),
    F.col("agg_salary_cbm008.SALARY_Z"),
    F.col("agg_salary_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("agg_salary_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("agg_salary_cbm008.POSITION_NBR"),
    F.col("agg_salary_cbm008.ADDL_CLASS_FLD"),
    F.col("agg_salary_cbm008.ADDL_FUND_CODE"),
    F.col("agg_salary_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("agg_salary_cbm008.SALARY_A_ADDL"),
    F.col("agg_salary_cbm008.SALARY_D_ADDL"),
    F.col("agg_salary_cbm008.SALARY_X_ADDL"),
    F.col("agg_salary_cbm008.SALARY_R_ADDL"),
    F.col("agg_salary_cbm008.SALARY_Z_ADDL"),
    F.col("agg_salary_cbm008.ACAD_ORG"),
    F.col("agg_salary_cbm008.UTA_TT_RANK"),
    F.col("agg_salary_cbm008.UTA_TT_STATUS"),
    F.col("agg_salary_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("agg_salary_cbm008.UTA_HRA_TITLE_CD"),
    F.col("agg_salary_cbm008.ACAD_ORG_UNITCD"),
    F.col("agg_salary_cbm008.STRM"),
    F.col("agg_salary_cbm008.RANK_CBM"),
    F.col("agg_salary_cbm008.CRSE_ID"),
    F.col("agg_salary_cbm008.CRSE_OFFER_NBR"),
    F.col("agg_salary_cbm008.ETHNIC_GROUP"),
    F.col("agg_salary_cbm008.ETHNIC_ORIGIN"),
    F.col("agg_salary_cbm008.COUNTRY"),
    F.col("agg_salary_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("agg_salary_cbm008.ETHINIC_ORIGIN"),
    F.col("agg_salary_cbm008.RACE_WHITE"),
    F.col("agg_salary_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("agg_salary_cbm008.RACE_ASIAN"),
    F.col("agg_salary_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("agg_salary_cbm008.RACE_INTERNATIONAL"),
    F.col("agg_salary_cbm008.RACE_UNKOWN"),
    F.col("agg_salary_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("agg_salary_cbm008.PERCENT_APPOINMENT_01"),
    F.col("agg_salary_cbm008.PERCENT_APPOINMENT_02"),
    F.col("agg_salary_cbm008.PERCENT_APPOINMENT_11"),
    F.col("agg_salary_cbm008.PERCENT_APPOINMENT_12"),
    F.col("agg_salary_cbm008.PERCENT_APPOINMENT_13"),
    # SAS: PUT(INT(SALARY_A_AGG),Z6.) - returns "000000" for missing values
    F.lpad(
        F.coalesce(F.col("agg_salary_cbm008.SALARY_A_AGG"), F.lit(0))
        .cast("INT")
        .cast("STRING"),
        6,
        "0",
    ).alias("SALARY_STATE"),
    F.lpad(
        F.coalesce(F.col("agg_salary_cbm008.SALARY_D_AGG"), F.lit(0))
        .cast("INT")
        .cast("STRING"),
        6,
        "0",
    ).alias("SALARY_DESIGNATED"),
    F.lpad(
        F.coalesce(F.col("agg_salary_cbm008.SALARY_R_AGG"), F.lit(0))
        .cast("INT")
        .cast("STRING"),
        6,
        "0",
    ).alias("SALARY_RESTRICTED"),
    F.lpad(
        F.coalesce(F.col("agg_salary_cbm008.SALARY_X_AGG"), F.lit(0))
        .cast("INT")
        .cast("STRING"),
        6,
        "0",
    ).alias("SALARY_AUX"),
    F.lpad(
        F.coalesce(F.col("agg_salary_cbm008.SALARY_Z_AGG"), F.lit(0))
        .cast("INT")
        .cast("STRING"),
        6,
        "0",
    ).alias("SALARY_OVERLOAD"),
    F.lit("000").alias("FE_APPOINTMENT"),
    F.lit("000000").alias("FE_SALARY"),
    F.lit("0").alias("FLEX_ENTRY"),
    F.col("agg_salary_cbm008.TERM_END_DT"),
    F.col("agg_salary_cbm008.CENSUS_DT"),
    F.col("agg_salary_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("agg_salary_cbm008.UTA_HRE_GENDER"),
    F.col("agg_salary_cbm008.UTA_HRE_NAME_UL"),
    F.col("agg_salary_cbm008.FACULTY_CLASSIF"),
    F.col("agg_salary_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("agg_salary_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("agg_salary_cbm008.COMPLIANCE"),
    F.col("agg_salary_cbm008.ACAD_YEAR"),
    F.col("agg_salary_cbm008.UTA_HRE_STATUS"),
    F.col("agg_salary_cbm008.SOURCE"),
    F.col("agg_salary_cbm008.UTA_HRA_UNIT_CD"),
    F.col("agg_salary_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

log_view_count("SALARY_CALC_CBM008", df_salary_calc_cbm008)

# COMMAND ----------

# Step 73: FACULTY_COMPLIANCE
# Create temp view: FACULTY_COMPLIANCE
df_faculty_compliance = df_salary_calc_cbm008.alias("SALARY_CALC_CBM008")
df_faculty_compliance = df_faculty_compliance.select(
    F.col("salary_calc_cbm008.SSN"),
    F.col("salary_calc_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("salary_calc_cbm008.FOUND_IN_NAMES"),
    F.col("salary_calc_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("salary_calc_cbm008.CIT_CHK_EMPLID"),
    F.col("salary_calc_cbm008.EMPL_RCD"),
    F.col("salary_calc_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("salary_calc_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("salary_calc_cbm008.APPT_BEGIN_DT"),
    F.col("salary_calc_cbm008.APPT_END_DT"),
    F.col("salary_calc_cbm008.CBM_TERM"),
    F.col("salary_calc_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("salary_calc_cbm008.ACCT_CD_ADDL"),
    F.col("salary_calc_cbm008.DIST_PCT_ADDL"),
    F.col("salary_calc_cbm008.PCT_TIME_A"),
    F.col("salary_calc_cbm008.PCT_TIME_C"),
    F.col("salary_calc_cbm008.PCT_TIME_D"),
    F.col("salary_calc_cbm008.PCT_TIME_E"),
    F.col("salary_calc_cbm008.SALARY_A"),
    F.col("salary_calc_cbm008.SALARY_D"),
    F.col("salary_calc_cbm008.SALARY_X"),
    F.col("salary_calc_cbm008.SALARY_R"),
    F.col("salary_calc_cbm008.SALARY_Z"),
    F.col("salary_calc_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("salary_calc_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("salary_calc_cbm008.POSITION_NBR"),
    F.col("salary_calc_cbm008.ADDL_CLASS_FLD"),
    F.col("salary_calc_cbm008.ADDL_FUND_CODE"),
    F.col("salary_calc_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("salary_calc_cbm008.SALARY_A_ADDL"),
    F.col("salary_calc_cbm008.SALARY_D_ADDL"),
    F.col("salary_calc_cbm008.SALARY_X_ADDL"),
    F.col("salary_calc_cbm008.SALARY_R_ADDL"),
    F.col("salary_calc_cbm008.SALARY_Z_ADDL"),
    F.col("salary_calc_cbm008.ACAD_ORG"),
    F.col("salary_calc_cbm008.UTA_TT_RANK"),
    F.col("salary_calc_cbm008.UTA_TT_STATUS"),
    F.col("salary_calc_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("salary_calc_cbm008.UTA_HRA_TITLE_CD"),
    F.col("salary_calc_cbm008.ACAD_ORG_UNITCD"),
    F.col("salary_calc_cbm008.STRM"),
    F.col("salary_calc_cbm008.RANK_CBM"),
    F.col("salary_calc_cbm008.CRSE_ID"),
    F.col("salary_calc_cbm008.CRSE_OFFER_NBR"),
    F.col("salary_calc_cbm008.ETHNIC_GROUP"),
    F.col("salary_calc_cbm008.ETHNIC_ORIGIN"),
    F.col("salary_calc_cbm008.COUNTRY"),
    F.col("salary_calc_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("salary_calc_cbm008.ETHINIC_ORIGIN"),
    F.col("salary_calc_cbm008.RACE_WHITE"),
    F.col("salary_calc_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("salary_calc_cbm008.RACE_ASIAN"),
    F.col("salary_calc_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("salary_calc_cbm008.RACE_INTERNATIONAL"),
    F.col("salary_calc_cbm008.RACE_UNKOWN"),
    F.col("salary_calc_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("salary_calc_cbm008.PERCENT_APPOINMENT_01"),
    F.col("salary_calc_cbm008.PERCENT_APPOINMENT_02"),
    F.col("salary_calc_cbm008.PERCENT_APPOINMENT_11"),
    F.col("salary_calc_cbm008.PERCENT_APPOINMENT_12"),
    F.col("salary_calc_cbm008.PERCENT_APPOINMENT_13"),
    F.col("salary_calc_cbm008.SALARY_STATE"),
    F.col("salary_calc_cbm008.SALARY_DESIGNATED"),
    F.col("salary_calc_cbm008.SALARY_RESTRICTED"),
    F.col("salary_calc_cbm008.SALARY_AUX"),
    F.col("salary_calc_cbm008.SALARY_OVERLOAD"),
    F.col("salary_calc_cbm008.FE_APPOINTMENT"),
    F.col("salary_calc_cbm008.FE_SALARY"),
    F.col("salary_calc_cbm008.FLEX_ENTRY"),
    F.col("salary_calc_cbm008.COMPLIANCE"),
    F.col("salary_calc_cbm008.TERM_END_DT"),
    F.col("salary_calc_cbm008.CENSUS_DT"),
    F.col("salary_calc_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("salary_calc_cbm008.UTA_HRE_GENDER"),
    F.col("salary_calc_cbm008.UTA_HRE_NAME_UL"),
    F.col("salary_calc_cbm008.FACULTY_CLASSIF"),
    F.col("salary_calc_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("salary_calc_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("salary_calc_cbm008.ACAD_YEAR"),
    F.col("salary_calc_cbm008.UTA_HRE_STATUS"),
    F.col("salary_calc_cbm008.SOURCE"),
    F.col("salary_calc_cbm008.UTA_HRA_UNIT_CD"),
    F.col("salary_calc_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

# Checkpoint B: materialize df_faculty_compliance (Step 73 FACULTY_COMPLIANCE output) to break
# the upstream DAG (Steps 61-73) before the Step 74-87 chain. Splits the 15-19s/cell
# plan-analysis phase roughly in half.
# Temp table is dropped immediately after the Step 98 write completes.
_tmp_stageB_tbl = f"{analytics}.{staging}._tmp_cbm008_stageB_compliance"
write_df_to_table(
    df_faculty_compliance, _tmp_stageB_tbl, mode="overwrite", overwriteSchema="true"
)
df_faculty_compliance = read_table(_tmp_stageB_tbl).alias("FACULTY_COMPLIANCE")
log_msg(f"Checkpoint B materialized: {_tmp_stageB_tbl}")
log_view_count(
    "FACULTY_COMPLIANCE (Checkpoint B)", df_faculty_compliance, do_count=True
)

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Join)
# # Create temp view: HRA_ARCHIVE_SSN
df_hra_archive_ssn = read_table(f"{student}.{bronze}.PS_UTA_HRA_ARCHIVE").alias(
    "PS_UTA_HRA_ARCHIVE"
)
df_hra_archive_ssn = df_hra_archive_ssn.select(F.col("ps_uta_hra_archive.SSN"))
df_hra_archive_ssn = df_hra_archive_ssn.distinct()
log_view_count("HRA_ARCHIVE_SSN (PS_UTA_HRA_ARCHIVE SSNs)", df_hra_archive_ssn)

# COMMAND ----------

# Step 74: NEW_HIRE_CALC
# Create temp view: NEW_HIRE_CALC_CBM008
df_new_hire_calc_cbm008 = df_faculty_compliance.alias("FACULTY_COMPLIANCE")
df_new_hire_calc_cbm008 = df_new_hire_calc_cbm008.join(
    df_hra_archive_ssn.alias("HRA_ARCHIVE_SSN"),
    (F.col("faculty_compliance.SSN") == F.col("hra_archive_ssn.SSN")),
    "left",
)
df_new_hire_calc_cbm008 = df_new_hire_calc_cbm008.join(
    read_table(f"{student}.{bronze}.PS_UTA_HRA_TBL").alias("PS_UTA_HRA_TBL"),
    (
        (
            (
                (F.col("faculty_compliance.SSN") == F.col("ps_uta_hra_tbl.SSN"))
                & F.col("ps_uta_hra_tbl.UTA_HRA_JOB_GRPCD").isin(["F", "E", "I"])
            )
            & (
                F.col("faculty_compliance.APPT_BEGIN_DT")
                > F.col("ps_uta_hra_tbl.UTA_HRA_BEGIN_DT")
            )
        )
        & (
            (
                (
                    F.col("faculty_compliance.ACAD_YEAR")
                    > F.col("ps_uta_hra_tbl.UTA_HRA_FISCALYEAR")
                )
                & (F.col("ps_uta_hra_tbl.UTA_HRA_PCT_TIME") >= F.lit(1))
            )
            | (
                (
                    F.col("faculty_compliance.ACAD_YEAR")
                    == F.col("ps_uta_hra_tbl.UTA_HRA_FISCALYEAR")
                )
                & F.col("faculty_compliance.CBM_TERM").isin(["2", "5"])
            )
        )
    ),
    "left",
)
df_new_hire_calc_cbm008 = df_new_hire_calc_cbm008.select(
    F.col("faculty_compliance.SSN"),
    F.lit("").alias("UTA_HRA_POSITIONID"),
    F.col("faculty_compliance.ACAD_YEAR").alias("UTA_HRA_FISCALYEAR"),
    F.lit("").alias("ACCT_CD"),
    F.lit(None).alias("DIST_PCT"),
    F.lit("").alias("CHARTFIELD1"),
    F.lit("").alias("CLASS_FLD"),
    F.lit("").alias("FUND_CODE"),
    F.col("faculty_compliance.CIT_CHK_EMPLID_PERS_NID"),
    F.lit("").alias("CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("faculty_compliance.FOUND_IN_NAMES"),
    F.col("faculty_compliance.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("faculty_compliance.CIT_CHK_EMPLID"),
    F.col("faculty_compliance.EMPL_RCD"),
    F.col("faculty_compliance.UTA_HRE_MAJAPPTSEQ"),
    F.lit(None).alias("UTA_HRA_MO_SAL"),
    F.col("faculty_compliance.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("faculty_compliance.APPT_BEGIN_DT"),
    F.col("faculty_compliance.APPT_END_DT"),
    F.lit(None).alias("UTA_HRA_PCT_TIME"),
    F.lit("").alias("UTA_HRA_JOB_GRPCD"),
    F.col("faculty_compliance.CBM_TERM"),
    F.col("faculty_compliance.UTSHARE_FISCAL_YEAR"),
    F.col("faculty_compliance.ACCT_CD_ADDL"),
    F.col("faculty_compliance.DIST_PCT_ADDL"),
    F.lit("").alias("HRA_BEGIN_DT"),
    F.lit("").alias("HRA_END_DT"),
    F.lit(None).alias("OVERLAP_DAYS"),
    F.lit(None).alias("DAYS_IN_REPT"),
    F.col("faculty_compliance.PCT_TIME_A"),
    F.col("faculty_compliance.PCT_TIME_C"),
    F.col("faculty_compliance.PCT_TIME_D"),
    F.col("faculty_compliance.PCT_TIME_E"),
    F.col("faculty_compliance.SALARY_A"),
    F.col("faculty_compliance.SALARY_D"),
    F.col("faculty_compliance.SALARY_X"),
    F.col("faculty_compliance.SALARY_R"),
    F.col("faculty_compliance.SALARY_Z"),
    F.lit(None).alias("DAYS_IN_APPT"),
    F.col("faculty_compliance.ADDL_PAY_ACCT_CD"),
    F.col("faculty_compliance.ADDL_PAY_OTH_PAY"),
    F.col("faculty_compliance.POSITION_NBR"),
    F.col("faculty_compliance.ADDL_CLASS_FLD"),
    F.col("faculty_compliance.ADDL_FUND_CODE"),
    F.col("faculty_compliance.OVLP_ALLOC_REDIS_ADDL"),
    F.col("faculty_compliance.SALARY_A_ADDL"),
    F.col("faculty_compliance.SALARY_D_ADDL"),
    F.col("faculty_compliance.SALARY_X_ADDL"),
    F.col("faculty_compliance.SALARY_R_ADDL"),
    F.col("faculty_compliance.SALARY_Z_ADDL"),
    F.col("faculty_compliance.UTA_HRA_UNIT_CD"),
    F.col("faculty_compliance.ACAD_ORG"),
    F.col("faculty_compliance.UTA_TT_RANK"),
    F.col("faculty_compliance.UTA_TT_STATUS"),
    F.col("faculty_compliance.UTA_HRE_MAJORTITLE"),
    F.col("faculty_compliance.UTA_HRA_TITLE_CD"),
    F.col("faculty_compliance.ACAD_ORG_UNITCD"),
    F.col("faculty_compliance.STRM"),
    F.col("faculty_compliance.RANK_CBM"),
    F.col("faculty_compliance.CRSE_ID"),
    F.col("faculty_compliance.CRSE_OFFER_NBR"),
    F.col("faculty_compliance.ETHNIC_GROUP"),
    F.col("faculty_compliance.ETHNIC_ORIGIN"),
    F.col("faculty_compliance.COUNTRY"),
    F.col("faculty_compliance.PERMIT_TYPE_IN_LIST"),
    F.col("faculty_compliance.ETHINIC_ORIGIN"),
    F.col("faculty_compliance.RACE_WHITE"),
    F.col("faculty_compliance.RACE_AFRICAN_AMERICAN"),
    F.col("faculty_compliance.RACE_ASIAN"),
    F.col("faculty_compliance.RACE_AMERICAN_INDIAN"),
    F.col("faculty_compliance.RACE_INTERNATIONAL"),
    F.col("faculty_compliance.RACE_UNKOWN"),
    F.col("faculty_compliance.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("faculty_compliance.PERCENT_APPOINMENT_01"),
    F.col("faculty_compliance.PERCENT_APPOINMENT_02"),
    F.col("faculty_compliance.PERCENT_APPOINMENT_11"),
    F.col("faculty_compliance.PERCENT_APPOINMENT_12"),
    F.col("faculty_compliance.PERCENT_APPOINMENT_13"),
    F.col("faculty_compliance.SALARY_STATE"),
    F.col("faculty_compliance.SALARY_DESIGNATED"),
    F.col("faculty_compliance.SALARY_RESTRICTED"),
    F.col("faculty_compliance.SALARY_AUX"),
    F.col("faculty_compliance.SALARY_OVERLOAD"),
    F.col("faculty_compliance.FE_APPOINTMENT"),
    F.col("faculty_compliance.FE_SALARY"),
    F.col("faculty_compliance.FLEX_ENTRY"),
    F.col("faculty_compliance.COMPLIANCE"),
    F.lit("").alias("FACULTY_MEMBER"),
    F.when(
        (
            (
                (
                    (
                        (
                            (
                                F.coalesce(
                                    F.col("faculty_compliance.PCT_TIME_A"), F.lit(0)
                                )
                                + F.coalesce(
                                    F.col("faculty_compliance.PCT_TIME_C"), F.lit(0)
                                )
                            )
                            + F.coalesce(
                                F.col("faculty_compliance.PCT_TIME_D"), F.lit(0)
                            )
                        )
                        + F.coalesce(F.col("faculty_compliance.PCT_TIME_E"), F.lit(0))
                    )
                    >= F.lit(100)
                )
                & (
                    F.col("hra_archive_ssn.SSN").isNull()
                    | (F.col("hra_archive_ssn.SSN") == F.lit(""))
                )
            )
            & (
                F.col("ps_uta_hra_tbl.SSN").isNull()
                | (F.col("ps_uta_hra_tbl.SSN") == F.lit(""))
            )
        ),
        F.lit("3"),
    )
    .otherwise(F.lit("0"))
    .alias("NEW_HIRE"),
    F.col("faculty_compliance.TERM_END_DT"),
    F.col("faculty_compliance.CENSUS_DT"),
    F.col("faculty_compliance.UTA_HRE_BIRTH_DATE"),
    F.col("faculty_compliance.UTA_HRE_GENDER"),
    F.col("faculty_compliance.UTA_HRE_NAME_UL"),
    F.col("faculty_compliance.FACULTY_CLASSIF"),
    F.col("faculty_compliance.INSTRUCTOR_CLASSIF"),
    F.col("faculty_compliance.UTA_HRE_CNT_SVC_DT"),
    F.col("faculty_compliance.UTA_HRE_STATUS"),
    F.col("faculty_compliance.SOURCE"),
    F.col("faculty_compliance.TERM_BEGIN_DT"),
)

# COMMAND ----------

df_new_hire_calc_cbm008 = df_new_hire_calc_cbm008.distinct()
log_view_count("NEW_HIRE_CALC_CBM008", df_new_hire_calc_cbm008)

# COMMAND ----------

# Step 75: CALC_SEM_YEAR
# Create temp view: CALC_SEM_YEAR_CBM008
df_calc_sem_year_cbm008 = df_new_hire_calc_cbm008.alias("NEW_HIRE_CALC_CBM008")
df_calc_sem_year_cbm008 = df_calc_sem_year_cbm008.select(
    F.col("new_hire_calc_cbm008.SSN"),
    F.col("new_hire_calc_cbm008.UTA_HRA_POSITIONID"),
    F.col("new_hire_calc_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("new_hire_calc_cbm008.ACCT_CD"),
    F.col("new_hire_calc_cbm008.DIST_PCT"),
    F.col("new_hire_calc_cbm008.CHARTFIELD1"),
    F.col("new_hire_calc_cbm008.CLASS_FLD"),
    F.col("new_hire_calc_cbm008.FUND_CODE"),
    F.col("new_hire_calc_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("new_hire_calc_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("new_hire_calc_cbm008.FOUND_IN_NAMES"),
    F.col("new_hire_calc_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("new_hire_calc_cbm008.CIT_CHK_EMPLID"),
    F.col("new_hire_calc_cbm008.EMPL_RCD"),
    F.col("new_hire_calc_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("new_hire_calc_cbm008.UTA_HRA_MO_SAL"),
    F.col("new_hire_calc_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("new_hire_calc_cbm008.APPT_BEGIN_DT"),
    F.col("new_hire_calc_cbm008.APPT_END_DT"),
    F.col("new_hire_calc_cbm008.UTA_HRA_PCT_TIME"),
    F.col("new_hire_calc_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("new_hire_calc_cbm008.CBM_TERM"),
    F.col("new_hire_calc_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("new_hire_calc_cbm008.ACCT_CD_ADDL"),
    F.col("new_hire_calc_cbm008.DIST_PCT_ADDL"),
    F.col("new_hire_calc_cbm008.HRA_BEGIN_DT"),
    F.col("new_hire_calc_cbm008.HRA_END_DT"),
    F.col("new_hire_calc_cbm008.OVERLAP_DAYS"),
    F.col("new_hire_calc_cbm008.DAYS_IN_REPT"),
    F.col("new_hire_calc_cbm008.PCT_TIME_A"),
    F.col("new_hire_calc_cbm008.PCT_TIME_C"),
    F.col("new_hire_calc_cbm008.PCT_TIME_D"),
    F.col("new_hire_calc_cbm008.PCT_TIME_E"),
    F.col("new_hire_calc_cbm008.SALARY_A"),
    F.col("new_hire_calc_cbm008.SALARY_D"),
    F.col("new_hire_calc_cbm008.SALARY_X"),
    F.col("new_hire_calc_cbm008.SALARY_R"),
    F.col("new_hire_calc_cbm008.SALARY_Z"),
    F.col("new_hire_calc_cbm008.DAYS_IN_APPT"),
    F.col("new_hire_calc_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("new_hire_calc_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("new_hire_calc_cbm008.POSITION_NBR"),
    F.col("new_hire_calc_cbm008.ADDL_CLASS_FLD"),
    F.col("new_hire_calc_cbm008.ADDL_FUND_CODE"),
    F.col("new_hire_calc_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("new_hire_calc_cbm008.SALARY_A_ADDL"),
    F.col("new_hire_calc_cbm008.SALARY_D_ADDL"),
    F.col("new_hire_calc_cbm008.SALARY_X_ADDL"),
    F.col("new_hire_calc_cbm008.SALARY_R_ADDL"),
    F.col("new_hire_calc_cbm008.SALARY_Z_ADDL"),
    F.col("new_hire_calc_cbm008.UTA_HRA_UNIT_CD"),
    F.col("new_hire_calc_cbm008.ACAD_ORG"),
    F.col("new_hire_calc_cbm008.UTA_TT_RANK"),
    F.col("new_hire_calc_cbm008.UTA_TT_STATUS"),
    F.col("new_hire_calc_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("new_hire_calc_cbm008.UTA_HRA_TITLE_CD"),
    F.col("new_hire_calc_cbm008.ACAD_ORG_UNITCD"),
    F.col("new_hire_calc_cbm008.STRM"),
    F.col("new_hire_calc_cbm008.RANK_CBM"),
    F.col("new_hire_calc_cbm008.CRSE_ID"),
    F.col("new_hire_calc_cbm008.CRSE_OFFER_NBR"),
    F.col("new_hire_calc_cbm008.ETHNIC_GROUP"),
    F.col("new_hire_calc_cbm008.ETHNIC_ORIGIN"),
    F.col("new_hire_calc_cbm008.COUNTRY"),
    F.col("new_hire_calc_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("new_hire_calc_cbm008.ETHINIC_ORIGIN"),
    F.col("new_hire_calc_cbm008.RACE_WHITE"),
    F.col("new_hire_calc_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("new_hire_calc_cbm008.RACE_ASIAN"),
    F.col("new_hire_calc_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("new_hire_calc_cbm008.RACE_INTERNATIONAL"),
    F.col("new_hire_calc_cbm008.RACE_UNKOWN"),
    F.col("new_hire_calc_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("new_hire_calc_cbm008.PERCENT_APPOINMENT_01"),
    F.col("new_hire_calc_cbm008.PERCENT_APPOINMENT_02"),
    F.col("new_hire_calc_cbm008.PERCENT_APPOINMENT_11"),
    F.col("new_hire_calc_cbm008.PERCENT_APPOINMENT_12"),
    F.col("new_hire_calc_cbm008.PERCENT_APPOINMENT_13"),
    F.col("new_hire_calc_cbm008.SALARY_STATE"),
    F.col("new_hire_calc_cbm008.SALARY_DESIGNATED"),
    F.col("new_hire_calc_cbm008.SALARY_RESTRICTED"),
    F.col("new_hire_calc_cbm008.SALARY_AUX"),
    F.col("new_hire_calc_cbm008.SALARY_OVERLOAD"),
    F.col("new_hire_calc_cbm008.FE_APPOINTMENT"),
    F.col("new_hire_calc_cbm008.FE_SALARY"),
    F.col("new_hire_calc_cbm008.FLEX_ENTRY"),
    F.col("new_hire_calc_cbm008.COMPLIANCE"),
    F.col("new_hire_calc_cbm008.FACULTY_MEMBER"),
    F.col("new_hire_calc_cbm008.NEW_HIRE"),
    F.when((F.col("new_hire_calc_cbm008.CBM_TERM") == F.lit("8")), F.lit("1"))
    .otherwise(
        F.when(
            (F.col("new_hire_calc_cbm008.CBM_TERM") == F.lit("2")), F.lit("2")
        ).otherwise(
            F.when(
                (F.col("new_hire_calc_cbm008.CBM_TERM") == F.lit("5")), F.lit("3")
            ).otherwise(F.lit(""))
        )
    )
    .alias("SEMESTER"),
    F.expr("'20' || SUBSTRING(new_hire_calc_cbm008.STRM, 2, 2)").alias("YEAR"),
    (
        (
            F.col("new_hire_calc_cbm008.STRM").cast("BIGINT")
            - F.when(
                (F.substring(F.col("new_hire_calc_cbm008.STRM"), 4, 1) == F.lit("2")),
                F.lit(4),
            ).otherwise(F.lit(3))
        )
        - F.when(
            (F.col("new_hire_calc_cbm008.STRM") == F.lit("2002")), F.lit(1000)
        ).otherwise(F.lit(0))
    )
    .cast("STRING")
    .alias("STRM_PREV"),
    F.col("new_hire_calc_cbm008.TERM_END_DT"),
    F.col("new_hire_calc_cbm008.CENSUS_DT"),
    F.col("new_hire_calc_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("new_hire_calc_cbm008.UTA_HRE_GENDER"),
    F.col("new_hire_calc_cbm008.UTA_HRE_NAME_UL"),
    F.col("new_hire_calc_cbm008.FACULTY_CLASSIF"),
    F.col("new_hire_calc_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("new_hire_calc_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("new_hire_calc_cbm008.UTA_HRE_STATUS"),
    F.col("new_hire_calc_cbm008.SOURCE"),
    F.col("new_hire_calc_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

log_view_count("CALC_SEM_YEAR_CBM008", df_calc_sem_year_cbm008)

# COMMAND ----------

# Step 76: STRM_PREV_CALC
# Create temp view: STRM_PREV_CALC_CBM008
df_strm_prev_calc_cbm008 = df_calc_sem_year_cbm008.alias("CALC_SEM_YEAR_CBM008")
df_strm_prev_calc_cbm008 = df_strm_prev_calc_cbm008.join(
    df_uniq_strm_cbm008.alias("UNIQ_STRM_CBM008"),
    (F.col("calc_sem_year_cbm008.STRM_PREV") == F.col("uniq_strm_cbm008.STRM")),
    "left",
)
df_strm_prev_calc_cbm008 = df_strm_prev_calc_cbm008.select(
    F.col("calc_sem_year_cbm008.SSN"),
    F.col("calc_sem_year_cbm008.UTA_HRA_POSITIONID"),
    F.col("calc_sem_year_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("calc_sem_year_cbm008.ACCT_CD"),
    F.col("calc_sem_year_cbm008.DIST_PCT"),
    F.col("calc_sem_year_cbm008.CHARTFIELD1"),
    F.col("calc_sem_year_cbm008.CLASS_FLD"),
    F.col("calc_sem_year_cbm008.FUND_CODE"),
    F.col("calc_sem_year_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("calc_sem_year_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("calc_sem_year_cbm008.FOUND_IN_NAMES"),
    F.col("calc_sem_year_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("calc_sem_year_cbm008.CIT_CHK_EMPLID"),
    F.col("calc_sem_year_cbm008.EMPL_RCD"),
    F.col("calc_sem_year_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("calc_sem_year_cbm008.UTA_HRA_MO_SAL"),
    F.col("calc_sem_year_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("calc_sem_year_cbm008.APPT_BEGIN_DT"),
    F.col("calc_sem_year_cbm008.APPT_END_DT"),
    F.col("calc_sem_year_cbm008.UTA_HRA_PCT_TIME"),
    F.col("calc_sem_year_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("calc_sem_year_cbm008.CBM_TERM"),
    F.col("calc_sem_year_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("calc_sem_year_cbm008.ACCT_CD_ADDL"),
    F.col("calc_sem_year_cbm008.DIST_PCT_ADDL"),
    F.col("calc_sem_year_cbm008.HRA_BEGIN_DT"),
    F.col("calc_sem_year_cbm008.HRA_END_DT"),
    F.col("calc_sem_year_cbm008.OVERLAP_DAYS"),
    F.col("calc_sem_year_cbm008.DAYS_IN_REPT"),
    F.col("calc_sem_year_cbm008.PCT_TIME_A"),
    F.col("calc_sem_year_cbm008.PCT_TIME_C"),
    F.col("calc_sem_year_cbm008.PCT_TIME_D"),
    F.col("calc_sem_year_cbm008.PCT_TIME_E"),
    F.col("calc_sem_year_cbm008.SALARY_A"),
    F.col("calc_sem_year_cbm008.SALARY_D"),
    F.col("calc_sem_year_cbm008.SALARY_X"),
    F.col("calc_sem_year_cbm008.SALARY_R"),
    F.col("calc_sem_year_cbm008.SALARY_Z"),
    F.col("calc_sem_year_cbm008.DAYS_IN_APPT"),
    F.col("calc_sem_year_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("calc_sem_year_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("calc_sem_year_cbm008.POSITION_NBR"),
    F.col("calc_sem_year_cbm008.ADDL_CLASS_FLD"),
    F.col("calc_sem_year_cbm008.ADDL_FUND_CODE"),
    F.col("calc_sem_year_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("calc_sem_year_cbm008.SALARY_A_ADDL"),
    F.col("calc_sem_year_cbm008.SALARY_D_ADDL"),
    F.col("calc_sem_year_cbm008.SALARY_X_ADDL"),
    F.col("calc_sem_year_cbm008.SALARY_R_ADDL"),
    F.col("calc_sem_year_cbm008.SALARY_Z_ADDL"),
    F.col("calc_sem_year_cbm008.UTA_HRA_UNIT_CD"),
    F.col("calc_sem_year_cbm008.ACAD_ORG"),
    F.col("calc_sem_year_cbm008.UTA_TT_RANK"),
    F.col("calc_sem_year_cbm008.UTA_TT_STATUS"),
    F.col("calc_sem_year_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("calc_sem_year_cbm008.UTA_HRA_TITLE_CD"),
    F.col("calc_sem_year_cbm008.ACAD_ORG_UNITCD"),
    F.col("calc_sem_year_cbm008.STRM"),
    F.col("calc_sem_year_cbm008.RANK_CBM"),
    F.col("calc_sem_year_cbm008.CRSE_ID"),
    F.col("calc_sem_year_cbm008.CRSE_OFFER_NBR"),
    F.col("calc_sem_year_cbm008.ETHNIC_GROUP"),
    F.col("calc_sem_year_cbm008.ETHNIC_ORIGIN"),
    F.col("calc_sem_year_cbm008.COUNTRY"),
    F.col("calc_sem_year_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("calc_sem_year_cbm008.ETHINIC_ORIGIN"),
    F.col("calc_sem_year_cbm008.RACE_WHITE"),
    F.col("calc_sem_year_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("calc_sem_year_cbm008.RACE_ASIAN"),
    F.col("calc_sem_year_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("calc_sem_year_cbm008.RACE_INTERNATIONAL"),
    F.col("calc_sem_year_cbm008.RACE_UNKOWN"),
    F.col("calc_sem_year_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("calc_sem_year_cbm008.PERCENT_APPOINMENT_01"),
    F.col("calc_sem_year_cbm008.PERCENT_APPOINMENT_02"),
    F.col("calc_sem_year_cbm008.PERCENT_APPOINMENT_11"),
    F.col("calc_sem_year_cbm008.PERCENT_APPOINMENT_12"),
    F.col("calc_sem_year_cbm008.PERCENT_APPOINMENT_13"),
    F.col("calc_sem_year_cbm008.SALARY_STATE"),
    F.col("calc_sem_year_cbm008.SALARY_DESIGNATED"),
    F.col("calc_sem_year_cbm008.SALARY_RESTRICTED"),
    F.col("calc_sem_year_cbm008.SALARY_AUX"),
    F.col("calc_sem_year_cbm008.SALARY_OVERLOAD"),
    F.col("calc_sem_year_cbm008.FE_APPOINTMENT"),
    F.col("calc_sem_year_cbm008.FE_SALARY"),
    F.col("calc_sem_year_cbm008.FLEX_ENTRY"),
    F.col("calc_sem_year_cbm008.COMPLIANCE"),
    F.col("calc_sem_year_cbm008.FACULTY_MEMBER"),
    F.col("calc_sem_year_cbm008.NEW_HIRE"),
    F.col("calc_sem_year_cbm008.SEMESTER"),
    F.col("calc_sem_year_cbm008.YEAR"),
    F.col("calc_sem_year_cbm008.STRM_PREV"),
    F.col("calc_sem_year_cbm008.TERM_END_DT"),
    F.col("uniq_strm_cbm008.TERM_END_DT").alias("TERM_END_DT_PREV"),
    F.col("calc_sem_year_cbm008.CENSUS_DT"),
    F.col("calc_sem_year_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("calc_sem_year_cbm008.UTA_HRE_GENDER"),
    F.col("calc_sem_year_cbm008.UTA_HRE_NAME_UL"),
    F.col("calc_sem_year_cbm008.FACULTY_CLASSIF"),
    F.col("calc_sem_year_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("calc_sem_year_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("calc_sem_year_cbm008.UTA_HRE_STATUS"),
    F.col("calc_sem_year_cbm008.SOURCE"),
    F.col("calc_sem_year_cbm008.TERM_BEGIN_DT"),
)

# COMMAND ----------

log_view_count("STRM_PREV_CALC_CBM008", df_strm_prev_calc_cbm008)

# COMMAND ----------

# Step 77: INSTR_MIN_MTG_NBR
# Create temp view: INSTR_MIN_MTG_NBR_CBM008
df_instr_min_mtg_nbr_cbm008 = read_table(
    f"{student}.{bronze}.PS_CLASS_INSTR"
).alias("PS_CLASS_INSTR")
df_instr_min_mtg_nbr_cbm008 = df_instr_min_mtg_nbr_cbm008.withColumn(
    "_agg_tmp_0",
    F.min(F.col("ps_class_instr.CLASS_MTG_NBR")).over(
        Window.partitionBy(
            "ps_class_instr.STRM",
            "ps_class_instr.SESSION_CODE",
            "ps_class_instr.CRSE_OFFER_NBR",
            "ps_class_instr.CRSE_ID",
            "ps_class_instr.CLASS_SECTION",
        )
    ),
)
df_instr_min_mtg_nbr_cbm008 = df_instr_min_mtg_nbr_cbm008.filter(
    (F.col("ps_class_instr.CLASS_MTG_NBR") == F.col("_agg_tmp_0"))
)
df_instr_min_mtg_nbr_cbm008 = df_instr_min_mtg_nbr_cbm008.drop("_agg_tmp_0")
df_instr_min_mtg_nbr_cbm008 = df_instr_min_mtg_nbr_cbm008.select(
    F.col("ps_class_instr.ASSIGN_TYPE"),
    F.col("ps_class_instr.ASSIGNMENT_PCT"),
    F.col("ps_class_instr.AUTO_CALC_WRKLD"),
    F.col("ps_class_instr.CLASS_MTG_NBR"),
    F.col("ps_class_instr.CLASS_SECTION"),
    F.col("ps_class_instr.CONTACT_MINUTES"),
    F.col("ps_class_instr.CRSE_ID"),
    F.col("ps_class_instr.CRSE_OFFER_NBR"),
    F.col("ps_class_instr.EMPL_RCD"),
    F.col("ps_class_instr.EMPLID"),
    F.col("ps_class_instr.GRADE_RSTR_ACCESS"),
    F.col("ps_class_instr.INSTR_ASSIGN_SEQ"),
    F.col("ps_class_instr.INSTR_LOAD_FACTOR"),
    F.col("ps_class_instr.INSTR_ROLE"),
    F.col("ps_class_instr.SCHED_PRINT_INSTR"),
    F.col("ps_class_instr.SESSION_CODE"),
    F.col("ps_class_instr.STRM"),
    F.col("ps_class_instr.WEEK_WORKLOAD_HRS"),
)
log_view_count("INSTR_MIN_MTG_NBR_CBM008", df_instr_min_mtg_nbr_cbm008)

# COMMAND ----------

# Step 78: CLASS_WITH_INSTR
# Create temp view: CLASS_WITH_INSTR_CBM008
df_class_with_instr_cbm008 = df_instr_min_mtg_nbr_cbm008.alias(
    "INSTR_MIN_MTG_NBR_CBM008"
)
df_class_with_instr_cbm008 = df_class_with_instr_cbm008.join(
    read_table(f"{student}.{bronze}.PS_CLASS_TBL").alias("PS_CLASS_TBL"),
    (
        (
            (
                (
                    (
                        (
                            (F.col("ps_class_tbl.ENRL_TOT") > F.lit(0))
                            & ~F.col("instr_min_mtg_nbr_cbm008.ASSIGN_TYPE").isin(
                                ["EXC", "NON"]
                            )
                        )
                        & (
                            F.col("instr_min_mtg_nbr_cbm008.CRSE_ID")
                            == F.col("ps_class_tbl.CRSE_ID")
                        )
                    )
                    & (
                        F.col("instr_min_mtg_nbr_cbm008.CRSE_OFFER_NBR")
                        == F.col("ps_class_tbl.CRSE_OFFER_NBR")
                    )
                )
                & (F.col("instr_min_mtg_nbr_cbm008.STRM") == F.col("ps_class_tbl.STRM"))
            )
            & (
                F.col("instr_min_mtg_nbr_cbm008.SESSION_CODE")
                == F.col("ps_class_tbl.SESSION_CODE")
            )
        )
        & (
            F.col("instr_min_mtg_nbr_cbm008.CLASS_SECTION")
            == F.col("ps_class_tbl.CLASS_SECTION")
        )
    ),
    "left",
)
df_class_with_instr_cbm008 = df_class_with_instr_cbm008.withColumn(
    "_agg_tmp_0",
    F.max(F.col("ps_class_tbl.CLASS_NBR")).over(
        Window.partitionBy(
            "instr_min_mtg_nbr_cbm008.EMPLID", "instr_min_mtg_nbr_cbm008.STRM"
        )
    ),
)
df_class_with_instr_cbm008 = df_class_with_instr_cbm008.filter(
    (F.col("_agg_tmp_0").isNull() | F.col("ps_class_tbl.CLASS_NBR").isNotNull())
)
df_class_with_instr_cbm008 = df_class_with_instr_cbm008.drop("_agg_tmp_0")
df_class_with_instr_cbm008 = df_class_with_instr_cbm008.select(
    F.col("ps_class_tbl.SUBJECT"),
    F.col("ps_class_tbl.CATALOG_NBR"),
    F.col("ps_class_tbl.CLASS_NBR"),
    F.col("instr_min_mtg_nbr_cbm008.WEEK_WORKLOAD_HRS"),
    F.col("instr_min_mtg_nbr_cbm008.ASSIGN_TYPE"),
    F.col("instr_min_mtg_nbr_cbm008.INSTR_ROLE"),
    F.col("instr_min_mtg_nbr_cbm008.INSTR_LOAD_FACTOR"),
    F.col("ps_class_tbl.COMBINED_SECTION"),
    F.col("instr_min_mtg_nbr_cbm008.STRM"),
    F.col("instr_min_mtg_nbr_cbm008.SESSION_CODE"),
    F.col("ps_class_tbl.CRSE_ID"),
    F.col("ps_class_tbl.CRSE_OFFER_NBR"),
    F.col("ps_class_tbl.CLASS_SECTION"),
    F.col("ps_class_tbl.END_DT"),
    F.col("ps_class_tbl.START_DT"),
    F.col("instr_min_mtg_nbr_cbm008.EMPLID"),
    F.col("ps_class_tbl.ACAD_GROUP"),
    F.col("ps_class_tbl.ACAD_ORG"),
)
df_class_with_instr_cbm008 = df_class_with_instr_cbm008.distinct()
log_view_count("CLASS_WITH_INSTR_CBM008", df_class_with_instr_cbm008)

# COMMAND ----------

# Step 79: Distinct Combined Sections
# Create temp view: DISTINCT_COMBINED_SECTIONS
df_distinct_combined_sections = df_class_with_instr_cbm008.alias(
    "CLASS_WITH_INSTR_CBM008"
)
df_distinct_combined_sections = df_distinct_combined_sections.join(
    df_cbm008_termdimension_manual.alias("CBM008_TermDimension_Manual"),
    (
        (
            (
                (
                    F.col("class_with_instr_cbm008.STRM")
                    == F.col("cbm008_termdimension_manual.Current_Term")
                )
                & (
                    F.col("class_with_instr_cbm008.SESSION_CODE")
                    == F.when(
                        (
                            F.substring(F.col("class_with_instr_cbm008.STRM"), 4, 1)
                            == F.lit("5")
                        ),
                        F.lit("5W2"),
                    ).otherwise(F.lit("1"))
                )
            )
            | (
                (
                    (
                        F.col("class_with_instr_cbm008.STRM")
                        == F.col("cbm008_termdimension_manual.Current_Term")
                    )
                    & (
                        F.col("class_with_instr_cbm008.SESSION_CODE")
                        != F.when(
                            (
                                F.substring(F.col("class_with_instr_cbm008.STRM"), 4, 1)
                                == F.lit("5")
                            ),
                            F.lit("5W2"),
                        ).otherwise(F.lit("1"))
                    )
                )
                & (
                    F.col("class_with_instr_cbm008.END_DT")
                    <= F.col("cbm008_termdimension_manual.Current_Term_End_Date")
                )
            )
        )
        | (
            (
                (
                    F.col("class_with_instr_cbm008.STRM")
                    != F.col("cbm008_termdimension_manual.Current_Term")
                )
                & (
                    F.col("class_with_instr_cbm008.STRM").cast("BIGINT")
                    == F.when(
                        (
                            F.substring(
                                F.col("cbm008_termdimension_manual.Current_Term"),
                                4,
                                1,
                            )
                            == F.lit("2")
                        ),
                        (
                            F.col("cbm008_termdimension_manual.Current_Term").cast(
                                "BIGINT"
                            )
                            - F.lit(4)
                        ),
                    ).otherwise(
                        (
                            F.col("cbm008_termdimension_manual.Current_Term").cast(
                                "BIGINT"
                            )
                            - F.lit(3)
                        )
                    )
                )
            )
            & (
                F.col("class_with_instr_cbm008.END_DT")
                > F.col("cbm008_termdimension_manual.TERM_END_DT")
            )
            & (
                F.col("class_with_instr_cbm008.END_DT")
                <= F.col("cbm008_termdimension_manual.Current_Term_End_Date")
            )
        )
    ),
    "inner",
)
df_distinct_combined_sections = df_distinct_combined_sections.join(
    read_table(f"{student}.{bronze}.PS_SCTN_CMBND").alias("PS_SCTN_CMBND"),
    (
        (
            (F.col("class_with_instr_cbm008.STRM") == F.col("ps_sctn_cmbnd.STRM"))
            & (
                F.col("class_with_instr_cbm008.SESSION_CODE")
                == F.col("ps_sctn_cmbnd.SESSION_CODE")
            )
        )
        & (
            F.col("class_with_instr_cbm008.CLASS_NBR")
            == F.col("ps_sctn_cmbnd.CLASS_NBR")
        )
    ),
    "left",
)

# COMMAND ----------

df_distinct_combined_sections = df_distinct_combined_sections.filter(
    (
        F.col("class_with_instr_cbm008.CLASS_NBR").isNotNull()
        & (
            F.col("class_with_instr_cbm008.COMBINED_SECTION").isNotNull()
            & (F.col("class_with_instr_cbm008.COMBINED_SECTION") != F.lit(""))
        )
    )
)

# COMMAND ----------

df_distinct_combined_sections = df_distinct_combined_sections.select(
    F.col("class_with_instr_cbm008.SUBJECT"),
    F.col("class_with_instr_cbm008.CATALOG_NBR"),
    F.col("class_with_instr_cbm008.CLASS_NBR"),
    F.col("class_with_instr_cbm008.COMBINED_SECTION"),
    F.col("class_with_instr_cbm008.STRM"),
    F.col("class_with_instr_cbm008.SESSION_CODE"),
    F.col("class_with_instr_cbm008.CRSE_ID"),
    F.col("class_with_instr_cbm008.CRSE_OFFER_NBR"),
    F.col("class_with_instr_cbm008.CLASS_SECTION"),
    F.col("class_with_instr_cbm008.END_DT"),
    F.col("class_with_instr_cbm008.START_DT"),
    F.col("class_with_instr_cbm008.ACAD_GROUP"),
    F.col("class_with_instr_cbm008.ACAD_ORG"),
    F.col("cbm008_termdimension_manual.Current_Term").alias("IN_STRM"),
    F.col("ps_sctn_cmbnd.SCTN_COMBINED_ID"),
    F.col("ps_sctn_cmbnd.INSTITUTION"),
)
df_distinct_combined_sections = df_distinct_combined_sections.distinct()
# NOTE: After .select() above, the alias "ps_sctn_cmbnd" no longer applies and only
# SCTN_COMBINED_ID/INSTITUTION from that side survive. STRM and SESSION_CODE come from
# CLASS_WITH_INSTR_CBM008 and are equivalent under the join condition above.
df_distinct_combined_sections = df_distinct_combined_sections.orderBy(
    F.col("STRM").asc(),
    F.col("SESSION_CODE").asc(),
    F.col("SCTN_COMBINED_ID").asc(),
)

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: User Written)


# DATA step: alpha-encoded CB_CLASS_CD per IN_STRM / SCTN_COMBINED_ID grouping.
# SAS BY-group pattern: group_num resets to 0 at first.IN_STRM and increments
# at first.SCTN_COMBINED_ID, then is mapped to a 2-character alpha-numeric code.
# Replaced with dense_rank() (- 1 to get 0-based) partitioned by IN_STRM ordered
# by STRM, SESSION_CODE, SCTN_COMBINED_ID -- semantically identical to the SAS retain pattern.
# NOTE: alias "ps_sctn_cmbnd" is dropped by the preceding .select() so use bare names.
_cb_class_window = Window.partitionBy(F.col("IN_STRM")).orderBy(
    F.col("STRM"), F.col("SESSION_CODE"), F.col("SCTN_COMBINED_ID")
)
df_combined_class_encoded = df_distinct_combined_sections.withColumn(
    "group_num", F.dense_rank().over(_cb_class_window) - F.lit(1)
)
df_combined_class_encoded = df_combined_class_encoded.withColumn(
    "ALPHA", F.lit("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
)
df_combined_class_encoded = df_combined_class_encoded.withColumn(
    "A", (F.col("group_num") / F.lit(36)).cast("int") + F.lit(1)
)
df_combined_class_encoded = df_combined_class_encoded.withColumn(
    "B", (F.col("group_num") % F.lit(36)) + F.lit(1)
)
df_combined_class_encoded = df_combined_class_encoded.withColumn(
    "CB_CLASS_CD",
    F.concat(
        F.substring(F.col("ALPHA"), F.col("A"), 1),
        F.substring(F.col("ALPHA"), F.col("B"), 1),
    ),
)
df_combined_class_encoded = df_combined_class_encoded.drop(
    "ALPHA", "A", "B", "group_num"
)
log_view_count("COMBINED_CLASS_ENCODED (CB_CLASS_CD encode)", df_combined_class_encoded)


# COMMAND ----------

# Step 80: READ_4_CLASSES
# Create temp view: READ_4_CLASSES_CBM008
df_read_4_classes_cbm008 = df_strm_prev_calc_cbm008.alias("STRM_PREV_CALC_CBM008")
df_read_4_classes_cbm008 = df_read_4_classes_cbm008.join(
    df_class_with_instr_cbm008.alias("CLASS_WITH_INSTR_CBM008"),
    (
        (
            F.col("strm_prev_calc_cbm008.CIT_CHK_EMPLID")
            == F.col("class_with_instr_cbm008.EMPLID")
        )
        & (
            (
                (
                    (
                        F.col("strm_prev_calc_cbm008.STRM")
                        == F.col("class_with_instr_cbm008.STRM")
                    )
                    & (
                        F.col("class_with_instr_cbm008.SESSION_CODE")
                        == F.when(
                            (
                                F.substring(F.col("class_with_instr_cbm008.STRM"), 4, 1)
                                == F.lit("5")
                            ),
                            F.lit("5W2"),
                        ).otherwise(F.lit("1"))
                    )
                )
                | (
                    (
                        (
                            F.col("strm_prev_calc_cbm008.STRM")
                            == F.col("class_with_instr_cbm008.STRM")
                        )
                        & (
                            F.col("class_with_instr_cbm008.SESSION_CODE")
                            != F.when(
                                (
                                    F.substring(
                                        F.col("class_with_instr_cbm008.STRM"), 4, 1
                                    )
                                    == F.lit("5")
                                ),
                                F.lit("5W2"),
                            ).otherwise(F.lit("1"))
                        )
                    )
                    & (
                        F.col("strm_prev_calc_cbm008.TERM_END_DT").cast("DATE")
                        >= F.col("class_with_instr_cbm008.END_DT").cast("DATE")
                    )
                )
            )
            | (
                (
                    (
                        F.col("strm_prev_calc_cbm008.STRM_PREV")
                        == F.col("class_with_instr_cbm008.STRM")
                    )
                    & (
                        F.col("class_with_instr_cbm008.SESSION_CODE")
                        != F.when(
                            (
                                F.substring(F.col("class_with_instr_cbm008.STRM"), 4, 1)
                                == F.lit("5")
                            ),
                            F.lit("5W2"),
                        ).otherwise(F.lit("1"))
                    )
                )
                & (
                    F.col("strm_prev_calc_cbm008.TERM_END_DT_PREV").cast("DATE")
                    < F.col("class_with_instr_cbm008.END_DT").cast("DATE")
                )
            )
        )
    ),
    "left",
)
df_read_4_classes_cbm008 = df_read_4_classes_cbm008.filter(
    (
        F.col("class_with_instr_cbm008.CLASS_NBR").isNotNull()
        | (F.col("strm_prev_calc_cbm008.SOURCE") == F.lit("HRA"))
    )
)
df_read_4_classes_cbm008 = df_read_4_classes_cbm008.select(
    F.col("strm_prev_calc_cbm008.SSN"),
    F.col("strm_prev_calc_cbm008.UTA_HRA_POSITIONID"),
    F.col("strm_prev_calc_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("strm_prev_calc_cbm008.ACCT_CD"),
    F.col("strm_prev_calc_cbm008.DIST_PCT"),
    F.col("strm_prev_calc_cbm008.CHARTFIELD1"),
    F.col("strm_prev_calc_cbm008.CLASS_FLD"),
    F.col("strm_prev_calc_cbm008.FUND_CODE"),
    F.col("strm_prev_calc_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("strm_prev_calc_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("strm_prev_calc_cbm008.FOUND_IN_NAMES"),
    F.col("strm_prev_calc_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("strm_prev_calc_cbm008.CIT_CHK_EMPLID"),
    F.col("strm_prev_calc_cbm008.EMPL_RCD"),
    F.col("strm_prev_calc_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("strm_prev_calc_cbm008.UTA_HRA_MO_SAL"),
    F.col("strm_prev_calc_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("strm_prev_calc_cbm008.APPT_BEGIN_DT"),
    F.col("strm_prev_calc_cbm008.APPT_END_DT"),
    F.col("strm_prev_calc_cbm008.UTA_HRA_PCT_TIME"),
    F.col("strm_prev_calc_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("strm_prev_calc_cbm008.CBM_TERM"),
    F.col("strm_prev_calc_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("strm_prev_calc_cbm008.ACCT_CD_ADDL"),
    F.col("strm_prev_calc_cbm008.DIST_PCT_ADDL"),
    F.col("strm_prev_calc_cbm008.HRA_BEGIN_DT"),
    F.col("strm_prev_calc_cbm008.HRA_END_DT"),
    F.col("strm_prev_calc_cbm008.OVERLAP_DAYS"),
    F.col("strm_prev_calc_cbm008.DAYS_IN_REPT"),
    F.col("strm_prev_calc_cbm008.PCT_TIME_A"),
    F.col("strm_prev_calc_cbm008.PCT_TIME_C"),
    F.col("strm_prev_calc_cbm008.PCT_TIME_D"),
    F.col("strm_prev_calc_cbm008.PCT_TIME_E"),
    F.col("strm_prev_calc_cbm008.SALARY_A"),
    F.col("strm_prev_calc_cbm008.SALARY_D"),
    F.col("strm_prev_calc_cbm008.SALARY_X"),
    F.col("strm_prev_calc_cbm008.SALARY_R"),
    F.col("strm_prev_calc_cbm008.SALARY_Z"),
    F.col("strm_prev_calc_cbm008.DAYS_IN_APPT"),
    F.col("strm_prev_calc_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("strm_prev_calc_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("strm_prev_calc_cbm008.POSITION_NBR"),
    F.col("strm_prev_calc_cbm008.ADDL_CLASS_FLD"),
    F.col("strm_prev_calc_cbm008.ADDL_FUND_CODE"),
    F.col("strm_prev_calc_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("strm_prev_calc_cbm008.SALARY_A_ADDL"),
    F.col("strm_prev_calc_cbm008.SALARY_D_ADDL"),
    F.col("strm_prev_calc_cbm008.SALARY_X_ADDL"),
    F.col("strm_prev_calc_cbm008.SALARY_R_ADDL"),
    F.col("strm_prev_calc_cbm008.SALARY_Z_ADDL"),
    F.col("strm_prev_calc_cbm008.UTA_HRA_UNIT_CD"),
    F.col("strm_prev_calc_cbm008.ACAD_ORG"),
    F.col("strm_prev_calc_cbm008.UTA_TT_RANK"),
    F.col("strm_prev_calc_cbm008.UTA_TT_STATUS"),
    F.col("strm_prev_calc_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("strm_prev_calc_cbm008.UTA_HRA_TITLE_CD"),
    F.col("strm_prev_calc_cbm008.ACAD_ORG_UNITCD"),
    F.col("strm_prev_calc_cbm008.STRM").alias("IN_STRM"),
    F.col("strm_prev_calc_cbm008.RANK_CBM"),
    F.col("strm_prev_calc_cbm008.CRSE_ID"),
    F.col("strm_prev_calc_cbm008.CRSE_OFFER_NBR"),
    F.col("strm_prev_calc_cbm008.ETHNIC_GROUP"),
    F.col("strm_prev_calc_cbm008.ETHNIC_ORIGIN"),
    F.col("strm_prev_calc_cbm008.COUNTRY"),
    F.col("strm_prev_calc_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("strm_prev_calc_cbm008.ETHINIC_ORIGIN"),
    F.col("strm_prev_calc_cbm008.RACE_WHITE"),
    F.col("strm_prev_calc_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("strm_prev_calc_cbm008.RACE_ASIAN"),
    F.col("strm_prev_calc_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("strm_prev_calc_cbm008.RACE_INTERNATIONAL"),
    F.col("strm_prev_calc_cbm008.RACE_UNKOWN"),
    F.col("strm_prev_calc_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("strm_prev_calc_cbm008.PERCENT_APPOINMENT_01"),
    F.col("strm_prev_calc_cbm008.PERCENT_APPOINMENT_02"),
    F.col("strm_prev_calc_cbm008.PERCENT_APPOINMENT_11"),
    F.col("strm_prev_calc_cbm008.PERCENT_APPOINMENT_12"),
    F.col("strm_prev_calc_cbm008.PERCENT_APPOINMENT_13"),
    F.col("strm_prev_calc_cbm008.SALARY_STATE"),
    F.col("strm_prev_calc_cbm008.SALARY_DESIGNATED"),
    F.col("strm_prev_calc_cbm008.SALARY_RESTRICTED"),
    F.col("strm_prev_calc_cbm008.SALARY_AUX"),
    F.col("strm_prev_calc_cbm008.SALARY_OVERLOAD"),
    F.col("strm_prev_calc_cbm008.FE_APPOINTMENT"),
    F.col("strm_prev_calc_cbm008.FE_SALARY"),
    F.col("strm_prev_calc_cbm008.FLEX_ENTRY"),
    F.col("strm_prev_calc_cbm008.COMPLIANCE"),
    F.col("strm_prev_calc_cbm008.FACULTY_MEMBER"),
    F.col("strm_prev_calc_cbm008.NEW_HIRE"),
    F.col("strm_prev_calc_cbm008.SEMESTER"),
    F.col("strm_prev_calc_cbm008.YEAR"),
    F.col("strm_prev_calc_cbm008.STRM_PREV").alias("IN_STRM_PREV"),
    F.col("strm_prev_calc_cbm008.TERM_END_DT"),
    F.col("strm_prev_calc_cbm008.TERM_END_DT_PREV"),
    F.trim(F.col("class_with_instr_cbm008.SUBJECT")).alias("SUBJECT_PREFIX"),
    F.trim(F.col("class_with_instr_cbm008.CATALOG_NBR")).alias("COURSE_NUMBER"),
    F.when(
        (
            F.col("class_with_instr_cbm008.CLASS_NBR").isNull()
            | (F.col("class_with_instr_cbm008.CLASS_NBR") == F.lit(""))
        ),
        F.lit(""),
    )
    .otherwise(F.col("class_with_instr_cbm008.CLASS_NBR").cast("INT").cast("STRING"))
    .alias("SECTION_NBR"),
    # SAS: IFC(WEEK_WORKLOAD_HRS IS MISSING,'000', PUT(INT(WEEK_WORKLOAD_HRS*10),Z3.))
    F.when(
        F.col("class_with_instr_cbm008.WEEK_WORKLOAD_HRS").isNull(),
        F.lit("000"),
    )
    .otherwise(
        F.lpad(
            (F.col("class_with_instr_cbm008.WEEK_WORKLOAD_HRS") * F.lit(10))
            .cast("INT")
            .cast("STRING"),
            3,
            "0",
        )
    )
    .alias("TEACHING_LOAD_CREDIT"),
    F.col("class_with_instr_cbm008.CLASS_NBR"),
    F.col("class_with_instr_cbm008.STRM"),
    F.col("class_with_instr_cbm008.SESSION_CODE"),
    F.col("strm_prev_calc_cbm008.CENSUS_DT"),
    F.col("class_with_instr_cbm008.START_DT"),
    F.col("class_with_instr_cbm008.CRSE_ID").alias("CRSE_ID_READ_4"),
    F.col("class_with_instr_cbm008.CLASS_SECTION"),
    F.col("class_with_instr_cbm008.CRSE_OFFER_NBR").alias("CRSE_OFFER_NBR_READ_4"),
    F.col("strm_prev_calc_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("strm_prev_calc_cbm008.UTA_HRE_GENDER"),
    F.col("strm_prev_calc_cbm008.UTA_HRE_NAME_UL"),
    F.col("strm_prev_calc_cbm008.FACULTY_CLASSIF"),
    F.col("strm_prev_calc_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("strm_prev_calc_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("class_with_instr_cbm008.INSTR_LOAD_FACTOR"),
    F.col("strm_prev_calc_cbm008.UTA_HRE_STATUS"),
    F.col("strm_prev_calc_cbm008.SOURCE"),
    F.col("strm_prev_calc_cbm008.TERM_BEGIN_DT"),
    F.col("class_with_instr_cbm008.ACAD_GROUP").alias("COLLEGE"),
    F.col("class_with_instr_cbm008.ACAD_ORG").alias("DEPT"),
)

# COMMAND ----------

log_view_count("READ_4_CLASSES_CBM008", df_read_4_classes_cbm008)

# COMMAND ----------

# Step 81: LOOKUP_COMBINED_WRKLD
# Create temp view: LOOKUP_COMBINED_WRKLD_CBM008
df_lookup_combined_wrkld_cbm008 = df_read_4_classes_cbm008.alias(
    "READ_4_CLASSES_CBM008"
)
df_lookup_combined_wrkld_cbm008 = df_lookup_combined_wrkld_cbm008.join(
    df_combined_class_encoded.alias("COMBINED_CLASS_ENCODED"),
    (
        (
            (
                F.col("read_4_classes_cbm008.CLASS_NBR")
                == F.col("combined_class_encoded.CLASS_NBR")
            )
            & (
                F.col("read_4_classes_cbm008.SESSION_CODE")
                == F.col("combined_class_encoded.SESSION_CODE")
            )
        )
        & (F.col("read_4_classes_cbm008.STRM") == F.col("combined_class_encoded.STRM"))
    ),
    "left",
)
_winSpec_5 = Window.partitionBy(
    F.col("combined_class_encoded.STRM"),
    F.col("combined_class_encoded.SESSION_CODE"),
    F.col("combined_class_encoded.SCTN_COMBINED_ID"),
    F.col("read_4_classes_cbm008.SOURCE"),
)
df_lookup_combined_wrkld_cbm008 = df_lookup_combined_wrkld_cbm008.withColumn(
    "_sel_tmp_0_0",
    F.size(F.collect_set(F.col("combined_class_encoded.CLASS_NBR")).over(_winSpec_5)),
)
df_lookup_combined_wrkld_cbm008 = df_lookup_combined_wrkld_cbm008.withColumn(
    "TEACHING_LOAD_CREDIT",
    F.when(
        (
            F.col("combined_class_encoded.CLASS_NBR").isNull()
            | (F.col("combined_class_encoded.CLASS_NBR") == F.lit(""))
        ),
        F.col("read_4_classes_cbm008.TEACHING_LOAD_CREDIT"),
    ).otherwise(
        F.when(
            (
                F.col("combined_class_encoded.SCTN_COMBINED_ID").isNull()
                | (F.col("combined_class_encoded.SCTN_COMBINED_ID") == F.lit(""))
            ),
            F.lpad(
                (
                    F.col("read_4_classes_cbm008.TEACHING_LOAD_CREDIT").cast("BIGINT")
                    / F.col("_sel_tmp_0_0")
                ).cast("STRING"),
                3,
                "0",
            ),
        ).otherwise(F.col("read_4_classes_cbm008.TEACHING_LOAD_CREDIT"))
    ),
)
df_lookup_combined_wrkld_cbm008 = df_lookup_combined_wrkld_cbm008.drop("_sel_tmp_0_0")
df_lookup_combined_wrkld_cbm008 = df_lookup_combined_wrkld_cbm008.withColumn(
    "CLASS_IN_CMBND",
    F.size(F.collect_set(F.col("read_4_classes_cbm008.CLASS_NBR")).over(_winSpec_5)),
)
df_lookup_combined_wrkld_cbm008 = df_lookup_combined_wrkld_cbm008.select(
    F.col("read_4_classes_cbm008.SSN"),
    F.col("read_4_classes_cbm008.UTA_HRA_POSITIONID"),
    F.col("read_4_classes_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("read_4_classes_cbm008.ACCT_CD"),
    F.col("read_4_classes_cbm008.DIST_PCT"),
    F.col("read_4_classes_cbm008.CHARTFIELD1"),
    F.col("read_4_classes_cbm008.CLASS_FLD"),
    F.col("read_4_classes_cbm008.FUND_CODE"),
    F.col("read_4_classes_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("read_4_classes_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("read_4_classes_cbm008.FOUND_IN_NAMES"),
    F.col("read_4_classes_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("read_4_classes_cbm008.CIT_CHK_EMPLID"),
    F.col("read_4_classes_cbm008.EMPL_RCD"),
    F.col("read_4_classes_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("read_4_classes_cbm008.UTA_HRA_MO_SAL"),
    F.col("read_4_classes_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("read_4_classes_cbm008.APPT_BEGIN_DT"),
    F.col("read_4_classes_cbm008.APPT_END_DT"),
    F.col("read_4_classes_cbm008.UTA_HRA_PCT_TIME"),
    F.col("read_4_classes_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("read_4_classes_cbm008.CBM_TERM"),
    F.col("read_4_classes_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("read_4_classes_cbm008.ACCT_CD_ADDL"),
    F.col("read_4_classes_cbm008.DIST_PCT_ADDL"),
    F.col("read_4_classes_cbm008.HRA_BEGIN_DT"),
    F.col("read_4_classes_cbm008.HRA_END_DT"),
    F.col("read_4_classes_cbm008.OVERLAP_DAYS"),
    F.col("read_4_classes_cbm008.DAYS_IN_REPT"),
    F.col("read_4_classes_cbm008.PCT_TIME_A"),
    F.col("read_4_classes_cbm008.PCT_TIME_C"),
    F.col("read_4_classes_cbm008.PCT_TIME_D"),
    F.col("read_4_classes_cbm008.PCT_TIME_E"),
    F.col("read_4_classes_cbm008.SALARY_A"),
    F.col("read_4_classes_cbm008.SALARY_D"),
    F.col("read_4_classes_cbm008.SALARY_X"),
    F.col("read_4_classes_cbm008.SALARY_R"),
    F.col("read_4_classes_cbm008.SALARY_Z"),
    F.col("read_4_classes_cbm008.DAYS_IN_APPT"),
    F.col("read_4_classes_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("read_4_classes_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("read_4_classes_cbm008.POSITION_NBR"),
    F.col("read_4_classes_cbm008.ADDL_CLASS_FLD"),
    F.col("read_4_classes_cbm008.ADDL_FUND_CODE"),
    F.col("read_4_classes_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("read_4_classes_cbm008.SALARY_A_ADDL"),
    F.col("read_4_classes_cbm008.SALARY_D_ADDL"),
    F.col("read_4_classes_cbm008.SALARY_X_ADDL"),
    F.col("read_4_classes_cbm008.SALARY_R_ADDL"),
    F.col("read_4_classes_cbm008.SALARY_Z_ADDL"),
    F.col("read_4_classes_cbm008.UTA_HRA_UNIT_CD"),
    F.col("read_4_classes_cbm008.ACAD_ORG"),
    F.col("read_4_classes_cbm008.UTA_TT_RANK"),
    F.col("read_4_classes_cbm008.UTA_TT_STATUS"),
    F.col("read_4_classes_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("read_4_classes_cbm008.UTA_HRA_TITLE_CD"),
    F.col("read_4_classes_cbm008.ACAD_ORG_UNITCD"),
    F.col("read_4_classes_cbm008.IN_STRM"),
    F.col("read_4_classes_cbm008.RANK_CBM"),
    F.col("read_4_classes_cbm008.CRSE_ID"),
    F.col("read_4_classes_cbm008.CRSE_OFFER_NBR"),
    F.col("read_4_classes_cbm008.ETHNIC_GROUP"),
    F.col("read_4_classes_cbm008.ETHNIC_ORIGIN"),
    F.col("read_4_classes_cbm008.COUNTRY"),
    F.col("read_4_classes_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("read_4_classes_cbm008.ETHINIC_ORIGIN"),
    F.col("read_4_classes_cbm008.RACE_WHITE"),
    F.col("read_4_classes_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("read_4_classes_cbm008.RACE_ASIAN"),
    F.col("read_4_classes_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("read_4_classes_cbm008.RACE_INTERNATIONAL"),
    F.col("read_4_classes_cbm008.RACE_UNKOWN"),
    F.col("read_4_classes_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("read_4_classes_cbm008.PERCENT_APPOINMENT_01"),
    F.col("read_4_classes_cbm008.PERCENT_APPOINMENT_02"),
    F.col("read_4_classes_cbm008.PERCENT_APPOINMENT_11"),
    F.col("read_4_classes_cbm008.PERCENT_APPOINMENT_12"),
    F.col("read_4_classes_cbm008.PERCENT_APPOINMENT_13"),
    F.col("read_4_classes_cbm008.SALARY_STATE"),
    F.col("read_4_classes_cbm008.SALARY_DESIGNATED"),
    F.col("read_4_classes_cbm008.SALARY_RESTRICTED"),
    F.col("read_4_classes_cbm008.SALARY_AUX"),
    F.col("read_4_classes_cbm008.SALARY_OVERLOAD"),
    F.col("read_4_classes_cbm008.FE_APPOINTMENT"),
    F.col("read_4_classes_cbm008.FE_SALARY"),
    F.col("read_4_classes_cbm008.FLEX_ENTRY"),
    F.col("read_4_classes_cbm008.COMPLIANCE"),
    F.col("read_4_classes_cbm008.FACULTY_MEMBER"),
    F.col("read_4_classes_cbm008.NEW_HIRE"),
    F.col("read_4_classes_cbm008.SEMESTER"),
    F.col("read_4_classes_cbm008.YEAR"),
    F.col("read_4_classes_cbm008.IN_STRM_PREV"),
    F.col("read_4_classes_cbm008.TERM_END_DT"),
    F.col("read_4_classes_cbm008.TERM_END_DT_PREV"),
    F.col("read_4_classes_cbm008.SUBJECT_PREFIX"),
    F.col("read_4_classes_cbm008.COURSE_NUMBER"),
    F.col("read_4_classes_cbm008.SECTION_NBR"),
    F.col("TEACHING_LOAD_CREDIT"),
    F.col("read_4_classes_cbm008.CLASS_NBR"),
    F.col("read_4_classes_cbm008.STRM"),
    F.col("read_4_classes_cbm008.SESSION_CODE"),
    F.col("combined_class_encoded.SCTN_COMBINED_ID"),
    F.col("combined_class_encoded.CB_CLASS_CD"),
    F.col("CLASS_IN_CMBND"),
    F.col("read_4_classes_cbm008.CENSUS_DT"),
    F.col("read_4_classes_cbm008.START_DT"),
    F.col("read_4_classes_cbm008.CRSE_ID_READ_4"),
    F.col("read_4_classes_cbm008.CLASS_SECTION"),
    F.col("read_4_classes_cbm008.CRSE_OFFER_NBR_READ_4"),
    F.col("read_4_classes_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("read_4_classes_cbm008.UTA_HRE_GENDER"),
    F.col("read_4_classes_cbm008.UTA_HRE_NAME_UL"),
    F.col("read_4_classes_cbm008.FACULTY_CLASSIF"),
    F.col("read_4_classes_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("read_4_classes_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("read_4_classes_cbm008.INSTR_LOAD_FACTOR"),
    F.col("read_4_classes_cbm008.UTA_HRE_STATUS"),
    F.col("read_4_classes_cbm008.SOURCE"),
    F.col("read_4_classes_cbm008.TERM_BEGIN_DT"),
    F.col("read_4_classes_cbm008.COLLEGE"),
    F.col("read_4_classes_cbm008.DEPT"),
)

# COMMAND ----------

# Step 82: SCTN_COMBND_TEACH_LD_CRED
# Create temp view: SCTN_COMBND_TEACH_LD_CRED_CBM008
df_sctn_combnd_teach_ld_cred_cbm008 = df_lookup_combined_wrkld_cbm008.alias(
    "LOOKUP_COMBINED_WRKLD_CBM008"
)
df_sctn_combnd_teach_ld_cred_cbm008 = df_sctn_combnd_teach_ld_cred_cbm008.join(
    read_table(f"{student}.{bronze}.PS_INSTR_TERM_DTL").alias("PS_INSTR_TERM_DTL"),
    (
        (
            (
                (
                    (
                        (
                            F.col(
                                "lookup_combined_wrkld_cbm008.SCTN_COMBINED_ID"
                            ).isNotNull()
                            & (
                                F.col("lookup_combined_wrkld_cbm008.SCTN_COMBINED_ID")
                                != F.lit("")
                            )
                        )
                        & (
                            F.col("lookup_combined_wrkld_cbm008.STRM")
                            == F.col("ps_instr_term_dtl.STRM")
                        )
                    )
                    & (
                        F.col("lookup_combined_wrkld_cbm008.SCTN_COMBINED_ID")
                        == F.col("ps_instr_term_dtl.SCTN_COMBINED_ID")
                    )
                )
                & (
                    F.col("lookup_combined_wrkld_cbm008.SESSION_CODE")
                    == F.col("ps_instr_term_dtl.SESSION_CODE")
                )
            )
            & (
                F.col("lookup_combined_wrkld_cbm008.CIT_CHK_EMPLID")
                == F.col("ps_instr_term_dtl.EMPLID")
            )
        )
        & (F.col("ps_instr_term_dtl.WEEK_WORKLOAD_HRS") != F.lit(0))
    ),
    "left",
)
df_sctn_combnd_teach_ld_cred_cbm008 = df_sctn_combnd_teach_ld_cred_cbm008.select(
    F.col("lookup_combined_wrkld_cbm008.SSN"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRA_POSITIONID"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("lookup_combined_wrkld_cbm008.ACCT_CD"),
    F.col("lookup_combined_wrkld_cbm008.DIST_PCT"),
    F.col("lookup_combined_wrkld_cbm008.CHARTFIELD1"),
    F.col("lookup_combined_wrkld_cbm008.CLASS_FLD"),
    F.col("lookup_combined_wrkld_cbm008.FUND_CODE"),
    F.col("lookup_combined_wrkld_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("lookup_combined_wrkld_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("lookup_combined_wrkld_cbm008.FOUND_IN_NAMES"),
    F.col("lookup_combined_wrkld_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("lookup_combined_wrkld_cbm008.CIT_CHK_EMPLID"),
    F.col("lookup_combined_wrkld_cbm008.EMPL_RCD"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRA_MO_SAL"),
    F.col("lookup_combined_wrkld_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("lookup_combined_wrkld_cbm008.APPT_BEGIN_DT"),
    F.col("lookup_combined_wrkld_cbm008.APPT_END_DT"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRA_PCT_TIME"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("lookup_combined_wrkld_cbm008.CBM_TERM"),
    F.col("lookup_combined_wrkld_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("lookup_combined_wrkld_cbm008.ACCT_CD_ADDL"),
    F.col("lookup_combined_wrkld_cbm008.DIST_PCT_ADDL"),
    F.col("lookup_combined_wrkld_cbm008.HRA_BEGIN_DT"),
    F.col("lookup_combined_wrkld_cbm008.HRA_END_DT"),
    F.col("lookup_combined_wrkld_cbm008.OVERLAP_DAYS"),
    F.col("lookup_combined_wrkld_cbm008.DAYS_IN_REPT"),
    F.col("lookup_combined_wrkld_cbm008.PCT_TIME_A"),
    F.col("lookup_combined_wrkld_cbm008.PCT_TIME_C"),
    F.col("lookup_combined_wrkld_cbm008.PCT_TIME_D"),
    F.col("lookup_combined_wrkld_cbm008.PCT_TIME_E"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_A"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_D"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_X"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_R"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_Z"),
    F.col("lookup_combined_wrkld_cbm008.DAYS_IN_APPT"),
    F.col("lookup_combined_wrkld_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("lookup_combined_wrkld_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("lookup_combined_wrkld_cbm008.POSITION_NBR"),
    F.col("lookup_combined_wrkld_cbm008.ADDL_CLASS_FLD"),
    F.col("lookup_combined_wrkld_cbm008.ADDL_FUND_CODE"),
    F.col("lookup_combined_wrkld_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_A_ADDL"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_D_ADDL"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_X_ADDL"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_R_ADDL"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_Z_ADDL"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRA_UNIT_CD"),
    F.col("lookup_combined_wrkld_cbm008.ACAD_ORG"),
    F.col("lookup_combined_wrkld_cbm008.UTA_TT_RANK"),
    F.col("lookup_combined_wrkld_cbm008.UTA_TT_STATUS"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRA_TITLE_CD"),
    F.col("lookup_combined_wrkld_cbm008.ACAD_ORG_UNITCD"),
    F.col("lookup_combined_wrkld_cbm008.IN_STRM"),
    F.col("lookup_combined_wrkld_cbm008.RANK_CBM"),
    F.col("lookup_combined_wrkld_cbm008.CRSE_ID"),
    F.col("lookup_combined_wrkld_cbm008.CRSE_OFFER_NBR"),
    F.col("lookup_combined_wrkld_cbm008.ETHNIC_GROUP"),
    F.col("lookup_combined_wrkld_cbm008.ETHNIC_ORIGIN"),
    F.col("lookup_combined_wrkld_cbm008.COUNTRY"),
    F.col("lookup_combined_wrkld_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("lookup_combined_wrkld_cbm008.ETHINIC_ORIGIN"),
    F.col("lookup_combined_wrkld_cbm008.RACE_WHITE"),
    F.col("lookup_combined_wrkld_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("lookup_combined_wrkld_cbm008.RACE_ASIAN"),
    F.col("lookup_combined_wrkld_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("lookup_combined_wrkld_cbm008.RACE_INTERNATIONAL"),
    F.col("lookup_combined_wrkld_cbm008.RACE_UNKOWN"),
    F.col("lookup_combined_wrkld_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("lookup_combined_wrkld_cbm008.PERCENT_APPOINMENT_01"),
    F.col("lookup_combined_wrkld_cbm008.PERCENT_APPOINMENT_02"),
    F.col("lookup_combined_wrkld_cbm008.PERCENT_APPOINMENT_11"),
    F.col("lookup_combined_wrkld_cbm008.PERCENT_APPOINMENT_12"),
    F.col("lookup_combined_wrkld_cbm008.PERCENT_APPOINMENT_13"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_STATE"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_DESIGNATED"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_RESTRICTED"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_AUX"),
    F.col("lookup_combined_wrkld_cbm008.SALARY_OVERLOAD"),
    F.col("lookup_combined_wrkld_cbm008.FE_APPOINTMENT"),
    F.col("lookup_combined_wrkld_cbm008.FE_SALARY"),
    F.col("lookup_combined_wrkld_cbm008.FLEX_ENTRY"),
    F.col("lookup_combined_wrkld_cbm008.COMPLIANCE"),
    F.col("lookup_combined_wrkld_cbm008.FACULTY_MEMBER"),
    F.col("lookup_combined_wrkld_cbm008.NEW_HIRE"),
    F.col("lookup_combined_wrkld_cbm008.SEMESTER"),
    F.col("lookup_combined_wrkld_cbm008.YEAR"),
    F.col("lookup_combined_wrkld_cbm008.IN_STRM_PREV"),
    F.col("lookup_combined_wrkld_cbm008.TERM_END_DT"),
    F.col("lookup_combined_wrkld_cbm008.TERM_END_DT_PREV"),
    F.col("lookup_combined_wrkld_cbm008.SUBJECT_PREFIX"),
    F.col("lookup_combined_wrkld_cbm008.COURSE_NUMBER"),
    F.col("lookup_combined_wrkld_cbm008.SECTION_NBR"),
    F.col("lookup_combined_wrkld_cbm008.TEACHING_LOAD_CREDIT"),
    F.col("lookup_combined_wrkld_cbm008.CLASS_NBR"),
    F.col("lookup_combined_wrkld_cbm008.STRM"),
    F.col("lookup_combined_wrkld_cbm008.SESSION_CODE"),
    F.col("lookup_combined_wrkld_cbm008.SCTN_COMBINED_ID"),
    F.col("lookup_combined_wrkld_cbm008.CB_CLASS_CD"),
    F.col("lookup_combined_wrkld_cbm008.CLASS_IN_CMBND"),
    F.col("lookup_combined_wrkld_cbm008.CENSUS_DT"),
    F.col("lookup_combined_wrkld_cbm008.START_DT"),
    F.col("lookup_combined_wrkld_cbm008.CRSE_ID_READ_4"),
    F.col("lookup_combined_wrkld_cbm008.CLASS_SECTION"),
    F.col("lookup_combined_wrkld_cbm008.CRSE_OFFER_NBR_READ_4"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRE_GENDER"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRE_NAME_UL"),
    F.col("lookup_combined_wrkld_cbm008.FACULTY_CLASSIF"),
    F.col("lookup_combined_wrkld_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("lookup_combined_wrkld_cbm008.INSTR_LOAD_FACTOR"),
    F.when(
        (
            F.col("ps_instr_term_dtl.WEEK_WORKLOAD_HRS").isNull()
            | (F.col("ps_instr_term_dtl.WEEK_WORKLOAD_HRS") == F.lit(""))
        ),
        F.lit(0),
    )
    .otherwise(
        (
            F.when(
                F.col("ps_instr_term_dtl.WEEK_WORKLOAD_HRS") * F.lit(10) >= 0,
                F.floor(
                    (F.col("ps_instr_term_dtl.WEEK_WORKLOAD_HRS") * F.lit(10))
                    + F.lit(0.5)
                ),
            ).otherwise(
                F.ceil(
                    (F.col("ps_instr_term_dtl.WEEK_WORKLOAD_HRS") * F.lit(10))
                    - F.lit(0.5)
                )
            )
        )
    )
    .alias("WEEK_WORKLOAD_HRS"),
    F.col("lookup_combined_wrkld_cbm008.UTA_HRE_STATUS"),
    F.col("lookup_combined_wrkld_cbm008.SOURCE"),
    F.col("lookup_combined_wrkld_cbm008.TERM_BEGIN_DT"),
    F.col("lookup_combined_wrkld_cbm008.COLLEGE"),
    F.col("lookup_combined_wrkld_cbm008.DEPT"),
)

# COMMAND ----------

log_view_count("SCTN_COMBND_TEACH_LD_CRED_CBM008", df_sctn_combnd_teach_ld_cred_cbm008)

# COMMAND ----------

# Checkpoint C: materialize df_sctn_combnd_teach_ld_cred_cbm008 to break the upstream DAG
# (Steps 74-82) before the Step 83-87 chain.  Splits the long Checkpoint-B → Checkpoint-1
# span roughly in half.
# Temp table is dropped immediately after the Step 98 write completes.
_tmp_stageC_tbl = f"{analytics}.{staging}._tmp_cbm008_stageC_teach_ld"
write_df_to_table(
    df_sctn_combnd_teach_ld_cred_cbm008,
    _tmp_stageC_tbl,
    mode="overwrite",
    overwriteSchema="true",
)
df_sctn_combnd_teach_ld_cred_cbm008 = read_table(_tmp_stageC_tbl).alias(
    "SCTN_COMBND_TEACH_LD_CRED_CBM008"
)
log_msg(f"Checkpoint C materialized: {_tmp_stageC_tbl}")
log_view_count(
    "SCTN_COMBND_TEACH_LD_CRED_CBM008 (Checkpoint C)",
    df_sctn_combnd_teach_ld_cred_cbm008,
    do_count=True,
)

# COMMAND ----------

# Step 83: FLEX_ENTRY_CALC
# Create temp view: FLEX_ENTRY_CALC_CBM008
df_flex_entry_calc_cbm008 = df_sctn_combnd_teach_ld_cred_cbm008.alias(
    "SCTN_COMBND_TEACH_LD_CRED_CBM008"
)
df_flex_entry_calc_cbm008 = df_flex_entry_calc_cbm008.select(
    F.col("sctn_combnd_teach_ld_cred_cbm008.SSN"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRA_POSITIONID"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ACCT_CD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.DIST_PCT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CHARTFIELD1"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CLASS_FLD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.FUND_CODE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.FOUND_IN_NAMES"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CIT_CHK_EMPLID"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.EMPL_RCD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRA_MO_SAL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.APPT_BEGIN_DT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.APPT_END_DT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRA_PCT_TIME"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CBM_TERM"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ACCT_CD_ADDL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.DIST_PCT_ADDL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.HRA_BEGIN_DT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.HRA_END_DT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.OVERLAP_DAYS"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.DAYS_IN_REPT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PCT_TIME_A"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PCT_TIME_C"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PCT_TIME_D"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PCT_TIME_E"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_A"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_D"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_X"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_R"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_Z"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.DAYS_IN_APPT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.POSITION_NBR"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ADDL_CLASS_FLD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ADDL_FUND_CODE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_A_ADDL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_D_ADDL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_X_ADDL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_R_ADDL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_Z_ADDL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRA_UNIT_CD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ACAD_ORG"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_TT_RANK"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_TT_STATUS"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRA_TITLE_CD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ACAD_ORG_UNITCD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.IN_STRM"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.RANK_CBM"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CRSE_ID"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CRSE_OFFER_NBR"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ETHNIC_GROUP"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ETHNIC_ORIGIN"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.COUNTRY"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.ETHINIC_ORIGIN"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.RACE_WHITE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.RACE_ASIAN"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.RACE_INTERNATIONAL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.RACE_UNKOWN"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PERCENT_APPOINMENT_01"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PERCENT_APPOINMENT_02"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PERCENT_APPOINMENT_11"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PERCENT_APPOINMENT_12"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.PERCENT_APPOINMENT_13"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_STATE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_DESIGNATED"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_RESTRICTED"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_AUX"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SALARY_OVERLOAD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.FE_APPOINTMENT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.FE_SALARY"),
    F.when(
        F.col("sctn_combnd_teach_ld_cred_cbm008.STRM").isNotNull(),
        F.when(
            (
                (
                    F.col("sctn_combnd_teach_ld_cred_cbm008.STRM")
                    != F.col("sctn_combnd_teach_ld_cred_cbm008.IN_STRM")
                )
                & (
                    F.col("sctn_combnd_teach_ld_cred_cbm008.SESSION_CODE")
                    != F.when(
                        (
                            F.substring(
                                F.col("sctn_combnd_teach_ld_cred_cbm008.STRM"), 4, 1
                            )
                            == F.lit("5")
                        ),
                        F.lit("5W2"),
                    ).otherwise(F.lit("1"))
                )
            ),
            F.lit("6"),
        ).otherwise(
            F.when(
                (
                    (
                        (
                            F.col("sctn_combnd_teach_ld_cred_cbm008.IN_STRM")
                            == F.col("sctn_combnd_teach_ld_cred_cbm008.STRM")
                        )
                        & (
                            F.col("sctn_combnd_teach_ld_cred_cbm008.SESSION_CODE")
                            != F.when(
                                (
                                    F.substring(
                                        F.col("sctn_combnd_teach_ld_cred_cbm008.STRM"),
                                        4,
                                        1,
                                    )
                                    == F.lit("5")
                                ),
                                F.lit("5W2"),
                            ).otherwise(F.lit("1"))
                        )
                    )
                    & (
                        F.col("sctn_combnd_teach_ld_cred_cbm008.START_DT")
                        > F.col("sctn_combnd_teach_ld_cred_cbm008.CENSUS_DT")
                    )
                ),
                F.lit("1"),
            ).otherwise(F.lit("0"))
        ),
    )
    .otherwise(F.lit("0"))
    .alias("FLEX_ENTRY"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.COMPLIANCE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.FACULTY_MEMBER"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.NEW_HIRE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SEMESTER"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.YEAR"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.IN_STRM_PREV"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.TERM_END_DT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.TERM_END_DT_PREV"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SUBJECT_PREFIX"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.COURSE_NUMBER"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SECTION_NBR"),
    F.when(
        (F.col("sctn_combnd_teach_ld_cred_cbm008.WEEK_WORKLOAD_HRS") > F.lit(0)),
        F.lpad(
            F.col("sctn_combnd_teach_ld_cred_cbm008.WEEK_WORKLOAD_HRS")
            .cast("INT")
            .cast("STRING"),
            3,
            "0",
        ),
    )
    .otherwise(F.col("sctn_combnd_teach_ld_cred_cbm008.TEACHING_LOAD_CREDIT"))
    .alias("TEACHING_LOAD_CREDIT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CLASS_NBR"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.STRM"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SESSION_CODE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SCTN_COMBINED_ID"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CB_CLASS_CD"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CLASS_IN_CMBND"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CENSUS_DT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CRSE_ID_READ_4"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CLASS_SECTION"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.CRSE_OFFER_NBR_READ_4"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRE_GENDER"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRE_NAME_UL"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.FACULTY_CLASSIF"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.INSTR_LOAD_FACTOR"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.UTA_HRE_STATUS"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.SOURCE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.TERM_BEGIN_DT"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.COLLEGE"),
    F.col("sctn_combnd_teach_ld_cred_cbm008.DEPT"),
)

# COMMAND ----------

log_view_count("FLEX_ENTRY_CALC_CBM008", df_flex_entry_calc_cbm008)

# COMMAND ----------

# Step 84: CHECK_CB_EXCLUDE
# Create temp view: CHECK_CB_EXCLUDE_CBM008
df_check_cb_exclude_cbm008 = df_flex_entry_calc_cbm008.alias("FLEX_ENTRY_CALC_CBM008")
df_check_cb_exclude_cbm008 = df_check_cb_exclude_cbm008.join(
    read_table(f"{student}.{bronze}.PS_CLASS_ATTRIBUTE").alias(
        "PS_CLASS_ATTRIBUTE"
    ),
    (
        (
            (
                (
                    (
                        (
                            (F.col("ps_class_attribute.CRSE_ATTR") == F.lit("CB"))
                            & (
                                F.col("ps_class_attribute.CRSE_ATTR_VALUE")
                                == F.lit("EXCLUDE")
                            )
                        )
                        & (
                            F.col("flex_entry_calc_cbm008.CRSE_ID_READ_4")
                            == F.col("ps_class_attribute.CRSE_ID")
                        )
                    )
                    & (
                        F.col("flex_entry_calc_cbm008.CRSE_OFFER_NBR_READ_4")
                        == F.col("ps_class_attribute.CRSE_OFFER_NBR")
                    )
                )
                & (
                    F.col("flex_entry_calc_cbm008.STRM")
                    == F.col("ps_class_attribute.STRM")
                )
            )
            & (
                F.col("flex_entry_calc_cbm008.SESSION_CODE")
                == F.col("ps_class_attribute.SESSION_CODE")
            )
        )
        & (
            F.col("flex_entry_calc_cbm008.CLASS_SECTION")
            == F.col("ps_class_attribute.CLASS_SECTION")
        )
    ),
    "left",
)
df_check_cb_exclude_cbm008 = df_check_cb_exclude_cbm008.select(
    F.col("flex_entry_calc_cbm008.SSN"),
    F.col("flex_entry_calc_cbm008.UTA_HRA_POSITIONID"),
    F.col("flex_entry_calc_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("flex_entry_calc_cbm008.ACCT_CD"),
    F.col("flex_entry_calc_cbm008.DIST_PCT"),
    F.col("flex_entry_calc_cbm008.CHARTFIELD1"),
    F.col("flex_entry_calc_cbm008.CLASS_FLD"),
    F.col("flex_entry_calc_cbm008.FUND_CODE"),
    F.col("flex_entry_calc_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("flex_entry_calc_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("flex_entry_calc_cbm008.FOUND_IN_NAMES"),
    F.col("flex_entry_calc_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("flex_entry_calc_cbm008.CIT_CHK_EMPLID"),
    F.col("flex_entry_calc_cbm008.EMPL_RCD"),
    F.col("flex_entry_calc_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("flex_entry_calc_cbm008.UTA_HRA_MO_SAL"),
    F.col("flex_entry_calc_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("flex_entry_calc_cbm008.APPT_BEGIN_DT"),
    F.col("flex_entry_calc_cbm008.APPT_END_DT"),
    F.col("flex_entry_calc_cbm008.UTA_HRA_PCT_TIME"),
    F.col("flex_entry_calc_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("flex_entry_calc_cbm008.CBM_TERM"),
    F.col("flex_entry_calc_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("flex_entry_calc_cbm008.ACCT_CD_ADDL"),
    F.col("flex_entry_calc_cbm008.DIST_PCT_ADDL"),
    F.col("flex_entry_calc_cbm008.HRA_BEGIN_DT"),
    F.col("flex_entry_calc_cbm008.HRA_END_DT"),
    F.col("flex_entry_calc_cbm008.OVERLAP_DAYS"),
    F.col("flex_entry_calc_cbm008.DAYS_IN_REPT"),
    F.col("flex_entry_calc_cbm008.PCT_TIME_A"),
    F.col("flex_entry_calc_cbm008.PCT_TIME_C"),
    F.col("flex_entry_calc_cbm008.PCT_TIME_D"),
    F.col("flex_entry_calc_cbm008.PCT_TIME_E"),
    F.col("flex_entry_calc_cbm008.SALARY_A"),
    F.col("flex_entry_calc_cbm008.SALARY_D"),
    F.col("flex_entry_calc_cbm008.SALARY_X"),
    F.col("flex_entry_calc_cbm008.SALARY_R"),
    F.col("flex_entry_calc_cbm008.SALARY_Z"),
    F.col("flex_entry_calc_cbm008.DAYS_IN_APPT"),
    F.col("flex_entry_calc_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("flex_entry_calc_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("flex_entry_calc_cbm008.POSITION_NBR"),
    F.col("flex_entry_calc_cbm008.ADDL_CLASS_FLD"),
    F.col("flex_entry_calc_cbm008.ADDL_FUND_CODE"),
    F.col("flex_entry_calc_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("flex_entry_calc_cbm008.SALARY_A_ADDL"),
    F.col("flex_entry_calc_cbm008.SALARY_D_ADDL"),
    F.col("flex_entry_calc_cbm008.SALARY_X_ADDL"),
    F.col("flex_entry_calc_cbm008.SALARY_R_ADDL"),
    F.col("flex_entry_calc_cbm008.SALARY_Z_ADDL"),
    F.col("flex_entry_calc_cbm008.UTA_HRA_UNIT_CD"),
    F.col("flex_entry_calc_cbm008.ACAD_ORG"),
    F.col("flex_entry_calc_cbm008.UTA_TT_RANK"),
    F.col("flex_entry_calc_cbm008.UTA_TT_STATUS"),
    F.col("flex_entry_calc_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("flex_entry_calc_cbm008.UTA_HRA_TITLE_CD"),
    F.col("flex_entry_calc_cbm008.ACAD_ORG_UNITCD"),
    F.col("flex_entry_calc_cbm008.IN_STRM"),
    F.col("flex_entry_calc_cbm008.RANK_CBM"),
    F.col("flex_entry_calc_cbm008.CRSE_ID"),
    F.col("flex_entry_calc_cbm008.CRSE_OFFER_NBR"),
    F.col("flex_entry_calc_cbm008.ETHNIC_GROUP"),
    F.col("flex_entry_calc_cbm008.ETHNIC_ORIGIN"),
    F.col("flex_entry_calc_cbm008.COUNTRY"),
    F.col("flex_entry_calc_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("flex_entry_calc_cbm008.ETHINIC_ORIGIN"),
    F.col("flex_entry_calc_cbm008.RACE_WHITE"),
    F.col("flex_entry_calc_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("flex_entry_calc_cbm008.RACE_ASIAN"),
    F.col("flex_entry_calc_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("flex_entry_calc_cbm008.RACE_INTERNATIONAL"),
    F.col("flex_entry_calc_cbm008.RACE_UNKOWN"),
    F.col("flex_entry_calc_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("flex_entry_calc_cbm008.PERCENT_APPOINMENT_01"),
    F.col("flex_entry_calc_cbm008.PERCENT_APPOINMENT_02"),
    F.col("flex_entry_calc_cbm008.PERCENT_APPOINMENT_11"),
    F.col("flex_entry_calc_cbm008.PERCENT_APPOINMENT_12"),
    F.col("flex_entry_calc_cbm008.PERCENT_APPOINMENT_13"),
    F.col("flex_entry_calc_cbm008.SALARY_STATE"),
    F.col("flex_entry_calc_cbm008.SALARY_DESIGNATED"),
    F.col("flex_entry_calc_cbm008.SALARY_RESTRICTED"),
    F.col("flex_entry_calc_cbm008.SALARY_AUX"),
    F.col("flex_entry_calc_cbm008.SALARY_OVERLOAD"),
    F.col("flex_entry_calc_cbm008.FE_APPOINTMENT"),
    F.col("flex_entry_calc_cbm008.FE_SALARY"),
    F.col("flex_entry_calc_cbm008.FLEX_ENTRY"),
    F.col("flex_entry_calc_cbm008.COMPLIANCE"),
    F.col("flex_entry_calc_cbm008.FACULTY_MEMBER"),
    F.col("flex_entry_calc_cbm008.NEW_HIRE"),
    F.col("flex_entry_calc_cbm008.SEMESTER"),
    F.col("flex_entry_calc_cbm008.YEAR"),
    F.col("flex_entry_calc_cbm008.IN_STRM_PREV"),
    F.col("flex_entry_calc_cbm008.TERM_END_DT"),
    F.col("flex_entry_calc_cbm008.TERM_END_DT_PREV"),
    F.col("flex_entry_calc_cbm008.SUBJECT_PREFIX"),
    F.col("flex_entry_calc_cbm008.COURSE_NUMBER"),
    F.col("flex_entry_calc_cbm008.SECTION_NBR"),
    F.col("flex_entry_calc_cbm008.TEACHING_LOAD_CREDIT"),
    F.col("flex_entry_calc_cbm008.CLASS_NBR"),
    F.col("flex_entry_calc_cbm008.STRM"),
    F.col("flex_entry_calc_cbm008.SESSION_CODE"),
    F.col("flex_entry_calc_cbm008.SCTN_COMBINED_ID"),
    F.col("flex_entry_calc_cbm008.CB_CLASS_CD"),
    F.col("flex_entry_calc_cbm008.CLASS_IN_CMBND"),
    F.col("flex_entry_calc_cbm008.CENSUS_DT"),
    F.col("flex_entry_calc_cbm008.CRSE_ID_READ_4"),
    F.col("flex_entry_calc_cbm008.CLASS_SECTION"),
    F.col("flex_entry_calc_cbm008.CRSE_OFFER_NBR_READ_4"),
    F.when(
        (F.col("ps_class_attribute.CRSE_ATTR_VALUE") == F.lit("EXCLUDE")), F.lit("Y")
    )
    .otherwise(F.lit("N"))
    .alias("CB_EXCLUDE"),
    F.col("flex_entry_calc_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("flex_entry_calc_cbm008.UTA_HRE_GENDER"),
    F.col("flex_entry_calc_cbm008.UTA_HRE_NAME_UL"),
    F.col("flex_entry_calc_cbm008.FACULTY_CLASSIF"),
    F.col("flex_entry_calc_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("flex_entry_calc_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("flex_entry_calc_cbm008.INSTR_LOAD_FACTOR"),
    F.col("flex_entry_calc_cbm008.UTA_HRE_STATUS"),
    F.col("flex_entry_calc_cbm008.SOURCE"),
    F.col("flex_entry_calc_cbm008.TERM_BEGIN_DT"),
    F.col("flex_entry_calc_cbm008.COLLEGE"),
    F.col("flex_entry_calc_cbm008.DEPT"),
)

# COMMAND ----------

log_view_count("CHECK_CB_EXCLUDE_CBM008", df_check_cb_exclude_cbm008)

# COMMAND ----------

# Step 85: NON_DLRN_STDNTS
# Create temp view: NON_DLRN_STDNTS_CBM008
df_non_dlrn_stdnts_cbm008 = read_table(f"{student}.{bronze}.PS_STDNT_ENRL").alias(
    "PS_STDNT_ENRL"
)
df_non_dlrn_stdnts_cbm008 = df_non_dlrn_stdnts_cbm008.join(
    read_table(f"{analytics}.{silver}.fact_thecb_distance_learning").alias("ADW_CBM_DLRNORPT"),
    (
        (F.col("ps_stdnt_enrl.EMPLID") == F.col("adw_cbm_dlrnorpt.EMPLID"))
        & (F.col("ps_stdnt_enrl.STRM") == F.col("adw_cbm_dlrnorpt.Reporting_Term"))
    ),
    "left",
)
df_non_dlrn_stdnts_cbm008 = df_non_dlrn_stdnts_cbm008.filter(
    (
        (
            (F.col("ps_stdnt_enrl.STDNT_ENRL_STATUS") == F.lit("E"))
            & (
                (
                    F.col("ps_stdnt_enrl.ENRL_ACTN_RSN_LAST").isNull()
                    | (F.col("ps_stdnt_enrl.ENRL_ACTN_RSN_LAST") == F.lit(""))
                )
                | (F.col("ps_stdnt_enrl.ENRL_ACTN_RSN_LAST") != F.lit("CENS"))
            )
        )
        & (
            (F.col("ps_stdnt_enrl.CRSE_GRADE_OFF") != F.lit("AU"))
            | (F.col("ps_stdnt_enrl.GRADING_BASIS_ENRL") != F.lit("AUD"))
        )
    )
)
df_non_dlrn_stdnts_cbm008 = df_non_dlrn_stdnts_cbm008.groupBy(
    "ps_stdnt_enrl.CLASS_NBR", "ps_stdnt_enrl.STRM"
).agg(
    F.max(
        F.when(
            (
                F.col("adw_cbm_dlrnorpt.EMPLID").isNull()
                | (F.col("adw_cbm_dlrnorpt.EMPLID") == F.lit(""))
            ),
            F.lit("1"),
        ).otherwise(F.lit("0"))
    ).alias("ENROLLED_STDNTS")
)
df_non_dlrn_stdnts_cbm008 = df_non_dlrn_stdnts_cbm008.distinct()
log_view_count("NON_DLRN_STDNTS_CBM008", df_non_dlrn_stdnts_cbm008)

# COMMAND ----------

# Step 86: CLASSES_WITH_STDNTS
# Create temp view: CLASSES_WITH_STDNTS_CBM008
df_classes_with_stdnts_cbm008 = read_table(
    f"{student}.{bronze}.PS_CLASS_TBL"
).alias("PS_CLASS_TBL")
df_classes_with_stdnts_cbm008 = df_classes_with_stdnts_cbm008.join(
    df_non_dlrn_stdnts_cbm008.alias("NON_DLRN_STDNTS_CBM008"),
    (
        (F.col("ps_class_tbl.STRM") == F.col("non_dlrn_stdnts_cbm008.STRM"))
        & (F.col("ps_class_tbl.CLASS_NBR") == F.col("non_dlrn_stdnts_cbm008.CLASS_NBR"))
    ),
    "inner",
)
df_classes_with_stdnts_cbm008 = df_classes_with_stdnts_cbm008.filter(
    (F.col("non_dlrn_stdnts_cbm008.ENROLLED_STDNTS") == F.lit("1"))
)
df_classes_with_stdnts_cbm008 = df_classes_with_stdnts_cbm008.select(
    F.col("ps_class_tbl.STRM"), F.col("ps_class_tbl.CLASS_NBR")
)
log_view_count("CLASSES_WITH_STDNTS_CBM008", df_classes_with_stdnts_cbm008)

# COMMAND ----------

# Step 87: CHECK_STDNT_ENROLL
# Create temp view: CHECK_STDNT_ENROLL_CBM008
df_check_stdnt_enroll_cbm008 = df_check_cb_exclude_cbm008.alias(
    "CHECK_CB_EXCLUDE_CBM008"
)
df_check_stdnt_enroll_cbm008 = df_check_stdnt_enroll_cbm008.join(
    df_classes_with_stdnts_cbm008.alias("CLASSES_WITH_STDNTS_CBM008"),
    (
        (
            F.col("check_cb_exclude_cbm008.CLASS_NBR")
            == F.col("classes_with_stdnts_cbm008.CLASS_NBR")
        )
        & (
            F.col("check_cb_exclude_cbm008.STRM")
            == F.col("classes_with_stdnts_cbm008.STRM")
        )
    ),
    "left",
)
df_check_stdnt_enroll_cbm008 = df_check_stdnt_enroll_cbm008.select(
    F.col("check_cb_exclude_cbm008.SSN"),
    F.col("check_cb_exclude_cbm008.UTA_HRA_POSITIONID"),
    F.col("check_cb_exclude_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("check_cb_exclude_cbm008.ACCT_CD"),
    F.col("check_cb_exclude_cbm008.DIST_PCT"),
    F.col("check_cb_exclude_cbm008.CHARTFIELD1"),
    F.col("check_cb_exclude_cbm008.CLASS_FLD"),
    F.col("check_cb_exclude_cbm008.FUND_CODE"),
    F.col("check_cb_exclude_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("check_cb_exclude_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("check_cb_exclude_cbm008.FOUND_IN_NAMES"),
    F.col("check_cb_exclude_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("check_cb_exclude_cbm008.CIT_CHK_EMPLID"),
    F.col("check_cb_exclude_cbm008.EMPL_RCD"),
    F.col("check_cb_exclude_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("check_cb_exclude_cbm008.UTA_HRA_MO_SAL"),
    F.col("check_cb_exclude_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("check_cb_exclude_cbm008.APPT_BEGIN_DT"),
    F.col("check_cb_exclude_cbm008.APPT_END_DT"),
    F.col("check_cb_exclude_cbm008.UTA_HRA_PCT_TIME"),
    F.col("check_cb_exclude_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("check_cb_exclude_cbm008.CBM_TERM"),
    F.col("check_cb_exclude_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("check_cb_exclude_cbm008.ACCT_CD_ADDL"),
    F.col("check_cb_exclude_cbm008.DIST_PCT_ADDL"),
    F.col("check_cb_exclude_cbm008.HRA_BEGIN_DT"),
    F.col("check_cb_exclude_cbm008.HRA_END_DT"),
    F.col("check_cb_exclude_cbm008.OVERLAP_DAYS"),
    F.col("check_cb_exclude_cbm008.DAYS_IN_REPT"),
    F.col("check_cb_exclude_cbm008.PCT_TIME_A"),
    F.col("check_cb_exclude_cbm008.PCT_TIME_C"),
    F.col("check_cb_exclude_cbm008.PCT_TIME_D"),
    F.col("check_cb_exclude_cbm008.PCT_TIME_E"),
    F.col("check_cb_exclude_cbm008.SALARY_A"),
    F.col("check_cb_exclude_cbm008.SALARY_D"),
    F.col("check_cb_exclude_cbm008.SALARY_X"),
    F.col("check_cb_exclude_cbm008.SALARY_R"),
    F.col("check_cb_exclude_cbm008.SALARY_Z"),
    F.col("check_cb_exclude_cbm008.DAYS_IN_APPT"),
    F.col("check_cb_exclude_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("check_cb_exclude_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("check_cb_exclude_cbm008.POSITION_NBR"),
    F.col("check_cb_exclude_cbm008.ADDL_CLASS_FLD"),
    F.col("check_cb_exclude_cbm008.ADDL_FUND_CODE"),
    F.col("check_cb_exclude_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("check_cb_exclude_cbm008.SALARY_A_ADDL"),
    F.col("check_cb_exclude_cbm008.SALARY_D_ADDL"),
    F.col("check_cb_exclude_cbm008.SALARY_X_ADDL"),
    F.col("check_cb_exclude_cbm008.SALARY_R_ADDL"),
    F.col("check_cb_exclude_cbm008.SALARY_Z_ADDL"),
    F.col("check_cb_exclude_cbm008.UTA_HRA_UNIT_CD"),
    F.col("check_cb_exclude_cbm008.ACAD_ORG"),
    F.col("check_cb_exclude_cbm008.UTA_TT_RANK"),
    F.col("check_cb_exclude_cbm008.UTA_TT_STATUS"),
    F.col("check_cb_exclude_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("check_cb_exclude_cbm008.UTA_HRA_TITLE_CD"),
    F.col("check_cb_exclude_cbm008.ACAD_ORG_UNITCD"),
    F.col("check_cb_exclude_cbm008.IN_STRM"),
    F.col("check_cb_exclude_cbm008.RANK_CBM"),
    F.col("check_cb_exclude_cbm008.CRSE_ID"),
    F.col("check_cb_exclude_cbm008.CRSE_OFFER_NBR"),
    F.col("check_cb_exclude_cbm008.ETHNIC_GROUP"),
    F.col("check_cb_exclude_cbm008.ETHNIC_ORIGIN"),
    F.col("check_cb_exclude_cbm008.COUNTRY"),
    F.col("check_cb_exclude_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("check_cb_exclude_cbm008.ETHINIC_ORIGIN"),
    F.col("check_cb_exclude_cbm008.RACE_WHITE"),
    F.col("check_cb_exclude_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("check_cb_exclude_cbm008.RACE_ASIAN"),
    F.col("check_cb_exclude_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("check_cb_exclude_cbm008.RACE_INTERNATIONAL"),
    F.col("check_cb_exclude_cbm008.RACE_UNKOWN"),
    F.col("check_cb_exclude_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("check_cb_exclude_cbm008.PERCENT_APPOINMENT_01"),
    F.col("check_cb_exclude_cbm008.PERCENT_APPOINMENT_02"),
    F.col("check_cb_exclude_cbm008.PERCENT_APPOINMENT_11"),
    F.col("check_cb_exclude_cbm008.PERCENT_APPOINMENT_12"),
    F.col("check_cb_exclude_cbm008.PERCENT_APPOINMENT_13"),
    F.col("check_cb_exclude_cbm008.SALARY_STATE"),
    F.col("check_cb_exclude_cbm008.SALARY_DESIGNATED"),
    F.col("check_cb_exclude_cbm008.SALARY_RESTRICTED"),
    F.col("check_cb_exclude_cbm008.SALARY_AUX"),
    F.col("check_cb_exclude_cbm008.SALARY_OVERLOAD"),
    F.col("check_cb_exclude_cbm008.FE_APPOINTMENT"),
    F.col("check_cb_exclude_cbm008.FE_SALARY"),
    F.col("check_cb_exclude_cbm008.FLEX_ENTRY"),
    F.col("check_cb_exclude_cbm008.COMPLIANCE"),
    F.col("check_cb_exclude_cbm008.FACULTY_MEMBER"),
    F.col("check_cb_exclude_cbm008.NEW_HIRE"),
    F.col("check_cb_exclude_cbm008.SEMESTER"),
    F.col("check_cb_exclude_cbm008.YEAR"),
    F.col("check_cb_exclude_cbm008.IN_STRM_PREV"),
    F.col("check_cb_exclude_cbm008.TERM_END_DT"),
    F.col("check_cb_exclude_cbm008.TERM_END_DT_PREV"),
    F.col("check_cb_exclude_cbm008.SUBJECT_PREFIX"),
    F.col("check_cb_exclude_cbm008.COURSE_NUMBER"),
    F.col("check_cb_exclude_cbm008.SECTION_NBR"),
    F.col("check_cb_exclude_cbm008.TEACHING_LOAD_CREDIT"),
    F.col("check_cb_exclude_cbm008.CLASS_NBR"),
    F.col("check_cb_exclude_cbm008.STRM"),
    F.col("check_cb_exclude_cbm008.SESSION_CODE"),
    F.col("check_cb_exclude_cbm008.SCTN_COMBINED_ID"),
    F.col("check_cb_exclude_cbm008.CB_CLASS_CD"),
    F.col("check_cb_exclude_cbm008.CLASS_IN_CMBND"),
    F.col("check_cb_exclude_cbm008.CENSUS_DT"),
    F.col("check_cb_exclude_cbm008.CRSE_ID_READ_4"),
    F.col("check_cb_exclude_cbm008.CLASS_SECTION"),
    F.col("check_cb_exclude_cbm008.CRSE_OFFER_NBR_READ_4"),
    F.col("check_cb_exclude_cbm008.CB_EXCLUDE"),
    F.when(F.col("classes_with_stdnts_cbm008.CLASS_NBR").isNotNull(), F.lit("Y"))
    .otherwise(F.lit("N"))
    .alias("STDNTS_ENROLLED"),
    F.col("check_cb_exclude_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("check_cb_exclude_cbm008.UTA_HRE_GENDER"),
    F.col("check_cb_exclude_cbm008.UTA_HRE_NAME_UL"),
    F.col("check_cb_exclude_cbm008.FACULTY_CLASSIF"),
    F.col("check_cb_exclude_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("check_cb_exclude_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("check_cb_exclude_cbm008.INSTR_LOAD_FACTOR"),
    F.col("check_cb_exclude_cbm008.UTA_HRE_STATUS"),
    F.col("check_cb_exclude_cbm008.SOURCE"),
    F.col("check_cb_exclude_cbm008.TERM_BEGIN_DT"),
    F.col("check_cb_exclude_cbm008.COLLEGE"),
    F.col("check_cb_exclude_cbm008.DEPT"),
)

# COMMAND ----------

# Checkpoint 1: materialize df_check_stdnt_enroll_cbm008 to break the upstream DAG
# before the heavy Steps 88-92 join/format chain. Serverless-compatible (no AQE/localCheckpoint).
# Temp table is dropped immediately after the Step 98 write completes.
_tmp_stage87_tbl = f"{analytics}.{staging}._tmp_cbm008_stage87_check_stdnt_enroll"
write_df_to_table(
    df_check_stdnt_enroll_cbm008,
    _tmp_stage87_tbl,
    mode="overwrite",
    overwriteSchema="true",
)
df_check_stdnt_enroll_cbm008 = read_table(_tmp_stage87_tbl).alias(
    "CHECK_STDNT_ENROLL_CBM008"
)
log_msg(f"Checkpoint 1 materialized: {_tmp_stage87_tbl}")
log_view_count(
    "CHECK_STDNT_ENROLL_CBM008 (Checkpoint 1)",
    df_check_stdnt_enroll_cbm008,
    do_count=True,
)

# COMMAND ----------

# Step 88: FORMAT_HRE_NAME_UL
# Create temp view: FORMAT_HRE_NAME_UL_CBM008
df_format_hre_name_ul_cbm008 = df_check_stdnt_enroll_cbm008.alias(
    "CHECK_STDNT_ENROLL_CBM008"
)
df_format_hre_name_ul_cbm008 = df_format_hre_name_ul_cbm008.filter(
    (
        (
            (F.col("check_stdnt_enroll_cbm008.CB_EXCLUDE") == F.lit("N"))
            & (
                (
                    F.col("check_stdnt_enroll_cbm008.SECTION_NBR").isNull()
                    | (F.col("check_stdnt_enroll_cbm008.SECTION_NBR") == F.lit(""))
                )
                | (F.col("check_stdnt_enroll_cbm008.STDNTS_ENROLLED") != F.lit("N"))
            )
        )
        & (F.col("check_stdnt_enroll_cbm008.FLEX_ENTRY") != F.lit("6"))
    )
)
df_format_hre_name_ul_cbm008 = df_format_hre_name_ul_cbm008.select(
    F.col("check_stdnt_enroll_cbm008.SSN"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRA_POSITIONID"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("check_stdnt_enroll_cbm008.ACCT_CD"),
    F.col("check_stdnt_enroll_cbm008.DIST_PCT"),
    F.col("check_stdnt_enroll_cbm008.CHARTFIELD1"),
    F.col("check_stdnt_enroll_cbm008.CLASS_FLD"),
    F.col("check_stdnt_enroll_cbm008.FUND_CODE"),
    F.col("check_stdnt_enroll_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("check_stdnt_enroll_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("check_stdnt_enroll_cbm008.FOUND_IN_NAMES"),
    F.col("check_stdnt_enroll_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("check_stdnt_enroll_cbm008.CIT_CHK_EMPLID"),
    F.col("check_stdnt_enroll_cbm008.EMPL_RCD"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRA_MO_SAL"),
    F.col("check_stdnt_enroll_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("check_stdnt_enroll_cbm008.APPT_BEGIN_DT"),
    F.col("check_stdnt_enroll_cbm008.APPT_END_DT"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRA_PCT_TIME"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("check_stdnt_enroll_cbm008.CBM_TERM"),
    F.col("check_stdnt_enroll_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("check_stdnt_enroll_cbm008.ACCT_CD_ADDL"),
    F.col("check_stdnt_enroll_cbm008.DIST_PCT_ADDL"),
    F.col("check_stdnt_enroll_cbm008.HRA_BEGIN_DT"),
    F.col("check_stdnt_enroll_cbm008.HRA_END_DT"),
    F.col("check_stdnt_enroll_cbm008.OVERLAP_DAYS"),
    F.col("check_stdnt_enroll_cbm008.DAYS_IN_REPT"),
    F.col("check_stdnt_enroll_cbm008.PCT_TIME_A"),
    F.col("check_stdnt_enroll_cbm008.PCT_TIME_C"),
    F.col("check_stdnt_enroll_cbm008.PCT_TIME_D"),
    F.col("check_stdnt_enroll_cbm008.PCT_TIME_E"),
    F.col("check_stdnt_enroll_cbm008.SALARY_A"),
    F.col("check_stdnt_enroll_cbm008.SALARY_D"),
    F.col("check_stdnt_enroll_cbm008.SALARY_X"),
    F.col("check_stdnt_enroll_cbm008.SALARY_R"),
    F.col("check_stdnt_enroll_cbm008.SALARY_Z"),
    F.col("check_stdnt_enroll_cbm008.DAYS_IN_APPT"),
    F.col("check_stdnt_enroll_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("check_stdnt_enroll_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("check_stdnt_enroll_cbm008.POSITION_NBR"),
    F.col("check_stdnt_enroll_cbm008.ADDL_CLASS_FLD"),
    F.col("check_stdnt_enroll_cbm008.ADDL_FUND_CODE"),
    F.col("check_stdnt_enroll_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("check_stdnt_enroll_cbm008.SALARY_A_ADDL"),
    F.col("check_stdnt_enroll_cbm008.SALARY_D_ADDL"),
    F.col("check_stdnt_enroll_cbm008.SALARY_X_ADDL"),
    F.col("check_stdnt_enroll_cbm008.SALARY_R_ADDL"),
    F.col("check_stdnt_enroll_cbm008.SALARY_Z_ADDL"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRA_UNIT_CD"),
    F.col("check_stdnt_enroll_cbm008.ACAD_ORG"),
    F.col("check_stdnt_enroll_cbm008.UTA_TT_RANK"),
    F.col("check_stdnt_enroll_cbm008.UTA_TT_STATUS"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRA_TITLE_CD"),
    F.col("check_stdnt_enroll_cbm008.ACAD_ORG_UNITCD"),
    F.col("check_stdnt_enroll_cbm008.IN_STRM"),
    F.col("check_stdnt_enroll_cbm008.RANK_CBM"),
    F.col("check_stdnt_enroll_cbm008.CRSE_ID"),
    F.col("check_stdnt_enroll_cbm008.CRSE_OFFER_NBR"),
    F.col("check_stdnt_enroll_cbm008.ETHNIC_GROUP"),
    F.col("check_stdnt_enroll_cbm008.ETHNIC_ORIGIN"),
    F.col("check_stdnt_enroll_cbm008.COUNTRY"),
    F.col("check_stdnt_enroll_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("check_stdnt_enroll_cbm008.ETHINIC_ORIGIN"),
    F.col("check_stdnt_enroll_cbm008.RACE_WHITE"),
    F.col("check_stdnt_enroll_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("check_stdnt_enroll_cbm008.RACE_ASIAN"),
    F.col("check_stdnt_enroll_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("check_stdnt_enroll_cbm008.RACE_INTERNATIONAL"),
    F.col("check_stdnt_enroll_cbm008.RACE_UNKOWN"),
    F.col("check_stdnt_enroll_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_01"),
    F.col("check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_02"),
    F.col("check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_11"),
    F.col("check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_12"),
    F.col("check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_13"),
    F.col("check_stdnt_enroll_cbm008.SALARY_STATE"),
    F.col("check_stdnt_enroll_cbm008.SALARY_DESIGNATED"),
    F.col("check_stdnt_enroll_cbm008.SALARY_RESTRICTED"),
    F.col("check_stdnt_enroll_cbm008.SALARY_AUX"),
    F.col("check_stdnt_enroll_cbm008.SALARY_OVERLOAD"),
    F.col("check_stdnt_enroll_cbm008.FE_APPOINTMENT"),
    F.col("check_stdnt_enroll_cbm008.FE_SALARY"),
    F.col("check_stdnt_enroll_cbm008.FLEX_ENTRY"),
    F.col("check_stdnt_enroll_cbm008.COMPLIANCE"),
    F.col("check_stdnt_enroll_cbm008.FACULTY_MEMBER"),
    F.col("check_stdnt_enroll_cbm008.NEW_HIRE"),
    F.col("check_stdnt_enroll_cbm008.SEMESTER"),
    F.col("check_stdnt_enroll_cbm008.YEAR"),
    F.col("check_stdnt_enroll_cbm008.IN_STRM_PREV"),
    F.col("check_stdnt_enroll_cbm008.TERM_END_DT"),
    F.col("check_stdnt_enroll_cbm008.TERM_END_DT_PREV"),
    F.col("check_stdnt_enroll_cbm008.SUBJECT_PREFIX"),
    F.col("check_stdnt_enroll_cbm008.COURSE_NUMBER"),
    F.col("check_stdnt_enroll_cbm008.SECTION_NBR"),
    F.col("check_stdnt_enroll_cbm008.TEACHING_LOAD_CREDIT"),
    F.col("check_stdnt_enroll_cbm008.CLASS_NBR"),
    F.col("check_stdnt_enroll_cbm008.STRM"),
    F.col("check_stdnt_enroll_cbm008.SESSION_CODE"),
    F.col("check_stdnt_enroll_cbm008.SCTN_COMBINED_ID"),
    F.col("check_stdnt_enroll_cbm008.CB_CLASS_CD"),
    F.col("check_stdnt_enroll_cbm008.CLASS_IN_CMBND"),
    F.col("check_stdnt_enroll_cbm008.CENSUS_DT"),
    F.col("check_stdnt_enroll_cbm008.CRSE_ID_READ_4"),
    F.col("check_stdnt_enroll_cbm008.CLASS_SECTION"),
    F.col("check_stdnt_enroll_cbm008.CRSE_OFFER_NBR_READ_4"),
    F.col("check_stdnt_enroll_cbm008.CB_EXCLUDE"),
    F.col("check_stdnt_enroll_cbm008.STDNTS_ENROLLED"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRE_GENDER"),
    F.when(
        (
            F.substring(F.col("check_stdnt_enroll_cbm008.UTA_HRE_NAME_UL"), 1, 2)
            == F.lit("Mc")
        ),
        F.expr(
            "'Mc' || UPPER(SUBSTRING(check_stdnt_enroll_cbm008.UTA_HRE_NAME_UL, 3, 1)) || IF(LENGTH(check_stdnt_enroll_cbm008.UTA_HRE_NAME_UL) > 3, SUBSTRING(check_stdnt_enroll_cbm008.UTA_HRE_NAME_UL, 4, LENGTH(check_stdnt_enroll_cbm008.UTA_HRE_NAME_UL) - 3), '')"
        ),
    )
    .otherwise(F.col("check_stdnt_enroll_cbm008.UTA_HRE_NAME_UL"))
    .alias("UTA_HRE_NAME_UL"),
    F.when(
        (
            (
                F.col("check_stdnt_enroll_cbm008.FACULTY_CLASSIF").isNull()
                | (F.col("check_stdnt_enroll_cbm008.FACULTY_CLASSIF") == F.lit(""))
            )
            & (
                (F.col("check_stdnt_enroll_cbm008.SOURCE") == F.lit("INSTR"))
                | (
                    (
                        (F.col("check_stdnt_enroll_cbm008.SOURCE") == F.lit("HRA"))
                        & (
                            F.col("check_stdnt_enroll_cbm008.SECTION_NBR").isNotNull()
                            & (
                                F.col("check_stdnt_enroll_cbm008.SECTION_NBR")
                                != F.lit("")
                            )
                        )
                    )
                    & (
                        (
                            (
                                (
                                    (
                                        (
                                            F.coalesce(
                                                F.col(
                                                    "check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_01"
                                                ).cast("BIGINT"),
                                                F.lit(0),
                                            )
                                            + F.coalesce(
                                                F.col(
                                                    "check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_02"
                                                ).cast("BIGINT"),
                                                F.lit(0),
                                            )
                                        )
                                        + F.coalesce(
                                            F.col(
                                                "check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_11"
                                            ).cast("BIGINT"),
                                            F.lit(0),
                                        )
                                    )
                                    + F.coalesce(
                                        F.col(
                                            "check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_12"
                                        ).cast("BIGINT"),
                                        F.lit(0),
                                    )
                                )
                                + F.coalesce(
                                    F.col(
                                        "check_stdnt_enroll_cbm008.PERCENT_APPOINMENT_13"
                                    ).cast("BIGINT"),
                                    F.lit(0),
                                )
                            )
                            + F.coalesce(
                                F.col("check_stdnt_enroll_cbm008.FE_APPOINTMENT").cast(
                                    "BIGINT"
                                ),
                                F.lit(0),
                            )
                        )
                        > F.lit(0)
                    )
                )
            )
        ),
        F.lit("5"),
    )
    .otherwise(F.col("check_stdnt_enroll_cbm008.FACULTY_CLASSIF"))
    .alias("FACULTY_CLASSIF"),
    F.col("check_stdnt_enroll_cbm008.INSTRUCTOR_CLASSIF"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("check_stdnt_enroll_cbm008.INSTR_LOAD_FACTOR"),
    F.col("check_stdnt_enroll_cbm008.UTA_HRE_STATUS"),
    F.col("check_stdnt_enroll_cbm008.SOURCE"),
    F.col("check_stdnt_enroll_cbm008.TERM_BEGIN_DT"),
    F.col("check_stdnt_enroll_cbm008.COLLEGE"),
    F.col("check_stdnt_enroll_cbm008.DEPT"),
)

# COMMAND ----------

log_view_count("FORMAT_HRE_NAME_UL_CBM008", df_format_hre_name_ul_cbm008)

# COMMAND ----------

# DBTITLE 1,Untitled
# Step 89: FORMAT_CBM008
# Create temp view: FORMAT_CBM008
df_format_cbm008 = df_format_hre_name_ul_cbm008.alias("FORMAT_HRE_NAME_UL_CBM008")
df_format_cbm008 = df_format_cbm008.select(
    F.when(
        (
            F.substring(F.col("format_hre_name_ul_cbm008.SSN"), 1, 2).isin(["99", "XX"])
            | (
                F.col("format_hre_name_ul_cbm008.SSN").isNull()
                | (F.col("format_hre_name_ul_cbm008.SSN") == F.lit(""))
            )
        ),
        F.concat(
            F.lit("9"),
            F.substring(F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID"), 3, 8),
        ),
    )
    .otherwise(F.col("format_hre_name_ul_cbm008.SSN"))
    .alias("SSN"),
    F.col("format_hre_name_ul_cbm008.UTA_HRA_POSITIONID"),
    F.col("format_hre_name_ul_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("format_hre_name_ul_cbm008.ACCT_CD"),
    F.col("format_hre_name_ul_cbm008.DIST_PCT"),
    F.col("format_hre_name_ul_cbm008.CHARTFIELD1"),
    F.col("format_hre_name_ul_cbm008.CLASS_FLD"),
    F.col("format_hre_name_ul_cbm008.FUND_CODE"),
    F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID_PERS_NID"),
    F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID_HR_PS_EMP"),
    F.col("format_hre_name_ul_cbm008.FOUND_IN_NAMES"),
    F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID_EXT_SYS"),
    F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID"),
    F.col("format_hre_name_ul_cbm008.EMPL_RCD"),
    F.col("format_hre_name_ul_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("format_hre_name_ul_cbm008.UTA_HRA_MO_SAL"),
    F.col("format_hre_name_ul_cbm008.EFFDT_UTA_HR_ADDL_PAY"),
    F.col("format_hre_name_ul_cbm008.APPT_BEGIN_DT"),
    F.col("format_hre_name_ul_cbm008.APPT_END_DT"),
    F.col("format_hre_name_ul_cbm008.UTA_HRA_PCT_TIME"),
    F.col("format_hre_name_ul_cbm008.UTA_HRA_JOB_GRPCD"),
    F.col("format_hre_name_ul_cbm008.CBM_TERM"),
    F.col("format_hre_name_ul_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("format_hre_name_ul_cbm008.ACCT_CD_ADDL"),
    F.col("format_hre_name_ul_cbm008.DIST_PCT_ADDL"),
    F.col("format_hre_name_ul_cbm008.HRA_BEGIN_DT"),
    F.col("format_hre_name_ul_cbm008.HRA_END_DT"),
    F.col("format_hre_name_ul_cbm008.OVERLAP_DAYS"),
    F.col("format_hre_name_ul_cbm008.DAYS_IN_REPT"),
    F.col("format_hre_name_ul_cbm008.PCT_TIME_A"),
    F.col("format_hre_name_ul_cbm008.PCT_TIME_C"),
    F.col("format_hre_name_ul_cbm008.PCT_TIME_D"),
    F.col("format_hre_name_ul_cbm008.PCT_TIME_E"),
    F.col("format_hre_name_ul_cbm008.SALARY_A"),
    F.col("format_hre_name_ul_cbm008.SALARY_D"),
    F.col("format_hre_name_ul_cbm008.SALARY_X"),
    F.col("format_hre_name_ul_cbm008.SALARY_R"),
    F.col("format_hre_name_ul_cbm008.SALARY_Z"),
    F.col("format_hre_name_ul_cbm008.DAYS_IN_APPT"),
    F.col("format_hre_name_ul_cbm008.ADDL_PAY_ACCT_CD"),
    F.col("format_hre_name_ul_cbm008.ADDL_PAY_OTH_PAY"),
    F.col("format_hre_name_ul_cbm008.POSITION_NBR"),
    F.col("format_hre_name_ul_cbm008.ADDL_CLASS_FLD"),
    F.col("format_hre_name_ul_cbm008.ADDL_FUND_CODE"),
    F.col("format_hre_name_ul_cbm008.OVLP_ALLOC_REDIS_ADDL"),
    F.col("format_hre_name_ul_cbm008.SALARY_A_ADDL"),
    F.col("format_hre_name_ul_cbm008.SALARY_D_ADDL"),
    F.col("format_hre_name_ul_cbm008.SALARY_X_ADDL"),
    F.col("format_hre_name_ul_cbm008.SALARY_R_ADDL"),
    F.col("format_hre_name_ul_cbm008.SALARY_Z_ADDL"),
    F.col("format_hre_name_ul_cbm008.UTA_HRA_UNIT_CD"),
    F.col("format_hre_name_ul_cbm008.ACAD_ORG"),
    F.col("format_hre_name_ul_cbm008.UTA_TT_RANK"),
    F.col("format_hre_name_ul_cbm008.UTA_TT_STATUS"),
    F.col("format_hre_name_ul_cbm008.UTA_HRE_MAJORTITLE"),
    F.col("format_hre_name_ul_cbm008.UTA_HRA_TITLE_CD"),
    F.col("format_hre_name_ul_cbm008.ACAD_ORG_UNITCD"),
    F.col("format_hre_name_ul_cbm008.IN_STRM"),
    F.col("format_hre_name_ul_cbm008.RANK_CBM"),
    F.col("format_hre_name_ul_cbm008.CRSE_ID"),
    F.col("format_hre_name_ul_cbm008.CRSE_OFFER_NBR"),
    F.col("format_hre_name_ul_cbm008.ETHNIC_GROUP"),
    F.col("format_hre_name_ul_cbm008.ETHNIC_ORIGIN"),
    F.col("format_hre_name_ul_cbm008.COUNTRY"),
    F.col("format_hre_name_ul_cbm008.PERMIT_TYPE_IN_LIST"),
    F.col("format_hre_name_ul_cbm008.ETHINIC_ORIGIN"),
    F.col("format_hre_name_ul_cbm008.RACE_WHITE"),
    F.col("format_hre_name_ul_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("format_hre_name_ul_cbm008.RACE_ASIAN"),
    F.col("format_hre_name_ul_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("format_hre_name_ul_cbm008.RACE_INTERNATIONAL"),
    F.col("format_hre_name_ul_cbm008.RACE_UNKOWN"),
    F.col("format_hre_name_ul_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("format_hre_name_ul_cbm008.PERCENT_APPOINMENT_01"),
    F.col("format_hre_name_ul_cbm008.PERCENT_APPOINMENT_02"),
    F.col("format_hre_name_ul_cbm008.PERCENT_APPOINMENT_11"),
    F.col("format_hre_name_ul_cbm008.PERCENT_APPOINMENT_12"),
    F.col("format_hre_name_ul_cbm008.PERCENT_APPOINMENT_13"),
    F.col("format_hre_name_ul_cbm008.SALARY_STATE"),
    F.col("format_hre_name_ul_cbm008.SALARY_DESIGNATED"),
    F.col("format_hre_name_ul_cbm008.SALARY_RESTRICTED"),
    F.col("format_hre_name_ul_cbm008.SALARY_AUX"),
    F.col("format_hre_name_ul_cbm008.SALARY_OVERLOAD"),
    F.col("format_hre_name_ul_cbm008.FE_APPOINTMENT"),
    F.col("format_hre_name_ul_cbm008.FE_SALARY"),
    F.col("format_hre_name_ul_cbm008.FLEX_ENTRY"),
    F.col("format_hre_name_ul_cbm008.COMPLIANCE"),
    F.col("format_hre_name_ul_cbm008.FACULTY_MEMBER"),
    F.col("format_hre_name_ul_cbm008.NEW_HIRE"),
    F.col("format_hre_name_ul_cbm008.SEMESTER"),
    F.col("format_hre_name_ul_cbm008.YEAR"),
    F.col("format_hre_name_ul_cbm008.IN_STRM_PREV"),
    F.col("format_hre_name_ul_cbm008.TERM_END_DT"),
    F.col("format_hre_name_ul_cbm008.TERM_END_DT_PREV"),
    F.col("format_hre_name_ul_cbm008.SUBJECT_PREFIX"),
    F.col("format_hre_name_ul_cbm008.COURSE_NUMBER"),
    F.col("format_hre_name_ul_cbm008.SECTION_NBR"),
    F.col("format_hre_name_ul_cbm008.TEACHING_LOAD_CREDIT"),
    F.col("format_hre_name_ul_cbm008.CLASS_NBR"),
    F.col("format_hre_name_ul_cbm008.STRM"),
    F.col("format_hre_name_ul_cbm008.SESSION_CODE"),
    F.col("format_hre_name_ul_cbm008.SCTN_COMBINED_ID"),
    F.col("format_hre_name_ul_cbm008.CB_CLASS_CD"),
    F.col("format_hre_name_ul_cbm008.CLASS_IN_CMBND"),
    F.col("format_hre_name_ul_cbm008.CENSUS_DT"),
    F.col("format_hre_name_ul_cbm008.CRSE_ID_READ_4"),
    F.col("format_hre_name_ul_cbm008.CLASS_SECTION"),
    F.col("format_hre_name_ul_cbm008.CRSE_OFFER_NBR_READ_4"),
    F.col("format_hre_name_ul_cbm008.CB_EXCLUDE"),
    F.col("format_hre_name_ul_cbm008.STDNTS_ENROLLED"),
    F.col("format_hre_name_ul_cbm008.UTA_HRE_BIRTH_DATE"),
    F.col("format_hre_name_ul_cbm008.UTA_HRE_GENDER"),
    F.col("format_hre_name_ul_cbm008.UTA_HRE_NAME_UL"),
    F.expr("SPLIT(format_hre_name_ul_cbm008.UTA_HRE_NAME_UL, ',')[0]").alias(
        "LAST_NAME"
    ),
    F.when(
        # Case 1: Proper comma format (value exists after comma)
        F.col("UTA_HRE_NAME_UL").contains(",")
        & (
            F.length(F.trim(F.element_at(F.split(F.col("UTA_HRE_NAME_UL"), ","), -1)))
            > 0
        ),
        F.trim(F.element_at(F.split(F.col("UTA_HRE_NAME_UL"), ","), -1)),
    )
    .when(
        # Case 2: Trailing comma case
        F.col("format_hre_name_ul_cbm008.UTA_HRE_NAME_UL").endswith(",")
        & (
            F.size(
                F.expr(
                    """
                filter(
                    split(
                        trim(regexp_replace(format_hre_name_ul_cbm008.UTA_HRE_NAME_UL, ',+$', '')),
                        ' '
                    ),
                    x -> x != ''
                )
            """
                )
            )
            >= 3
        ),
        F.trim(
            F.regexp_replace(
                F.col("format_hre_name_ul_cbm008.UTA_HRE_NAME_UL"), ",+$", ""
            )
        ),
    )
    .otherwise(F.lit(None))
    .alias("FIRST_NAME"),
    F.when(
        F.col("UTA_HRE_NAME_UL").rlike(",.+")
        & (
            F.size(
                F.expr(
                    """
                filter(
                    split(
                        trim(
                            element_at(
                                split(regexp_replace(UTA_HRE_NAME_UL, ',+$', ''), ','),
                                -1
                            )
                        ),
                        ' '
                    ),
                    x -> x != ''
                )
            """
                )
            )
            >= 2
        ),
        F.substring(
            F.expr(
                """
            filter(
                split(
                    trim(
                        element_at(
                            split(regexp_replace(UTA_HRE_NAME_UL, ',+$', ''), ','),
                            -1
                        )
                    ),
                    ' '
                ),
                x -> x != ''
            )[1]
        """
            ),
            1,
            1,
        ),
    )
    .when(
        (~F.col("UTA_HRE_NAME_UL").rlike(",.+"))
        & (
            F.size(
                F.expr(
                    """
                filter(
                    split(
                        trim(UTA_HRE_NAME_UL),
                        ' '
                    ),
                    x -> x != ''
                )
            """
                )
            )
            >= 3
        ),
        F.substring(
            F.expr(
                """
            filter(
                split(
                    trim(UTA_HRE_NAME_UL),
                    ' '
                ),
                x -> x != ''
            )[1]
        """
            ),
            1,
            1,
        ),
    )
    .otherwise(F.lit(None))
    .alias("MIDDLE_INITIAL"),
    F.col("format_hre_name_ul_cbm008.FACULTY_CLASSIF"),
    F.col("format_hre_name_ul_cbm008.INSTRUCTOR_CLASSIF"),
    # SAS: IFC(CIT_CHK_EMPLID IS MISSING, FACULTY_CLASSIF, IFC(RANK_CBM='0', FACULTY_CLASSIF, STRIP(RANK_CBM)))
    F.when(
        F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID").isNull()
        | (F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID") == F.lit("")),
        F.col("format_hre_name_ul_cbm008.FACULTY_CLASSIF"),
    )
    .otherwise(
        F.when(
            F.col("format_hre_name_ul_cbm008.RANK_CBM") == "0",
            F.col("format_hre_name_ul_cbm008.FACULTY_CLASSIF"),
        ).otherwise(F.trim(F.col("format_hre_name_ul_cbm008.RANK_CBM")))
    )
    .alias("RANK"),
    F.when(
        (
            F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID").isNull()
            | (F.col("format_hre_name_ul_cbm008.CIT_CHK_EMPLID") == F.lit(""))
        ),
        F.lit("0"),
    )
    .otherwise(
        F.when(
            F.col("format_hre_name_ul_cbm008.UTA_TT_STATUS").isin(["NA", "ND", "NT"]),
            F.lit("0"),
        ).otherwise(
            F.when(
                (F.col("format_hre_name_ul_cbm008.UTA_TT_STATUS") == F.lit("T")),
                F.lit("1"),
            ).otherwise(
                F.when(
                    (F.col("format_hre_name_ul_cbm008.UTA_TT_STATUS") == F.lit("TT")),
                    F.lit("2"),
                ).otherwise(F.lit("0"))
            )
        )
    )
    .alias("TENURE"),
    F.col("format_hre_name_ul_cbm008.UTA_HRE_GENDER").alias("GENDER"),
    F.col("format_hre_name_ul_cbm008.ACAD_ORG_UNITCD").alias(
        "ADMINISTRATIVE_UNIT_CODE"
    ),
    F.substring(F.col("format_hre_name_ul_cbm008.UTA_HRE_BIRTH_DATE"), 1, 6).alias(
        "DATE_OF_BIRTH"
    ),
    F.col("format_hre_name_ul_cbm008.UTA_HRE_CNT_SVC_DT"),
    F.col("format_hre_name_ul_cbm008.INSTR_LOAD_FACTOR"),
    F.lit("8").alias("RECORD_CODE"),
    F.lit("003656").alias("INSTITUTION_CODE"),
    # SAS: IFC(INSTR_LOAD_FACTOR IS MISSING | SECTION_NBR IS MISSING, '000', PUT(INSTR_LOAD_FACTOR,Z3.))
    F.when(
        F.col("format_hre_name_ul_cbm008.INSTR_LOAD_FACTOR").isNull()
        | F.col("format_hre_name_ul_cbm008.SECTION_NBR").isNull()
        | (F.col("format_hre_name_ul_cbm008.SECTION_NBR") == F.lit("")),
        F.lit("000"),
    )
    .otherwise(
        F.lpad(
            F.col("format_hre_name_ul_cbm008.INSTR_LOAD_FACTOR")
            .cast("INT")
            .cast("STRING"),
            3,
            "0",
        )
    )
    .alias("RESPONSIBILITY_FACTOR"),
    F.when(
        (
            (F.col("format_hre_name_ul_cbm008.UTA_HRE_STATUS") == F.lit("R"))
            & (
                F.col("format_hre_name_ul_cbm008.SECTION_NBR").isNull()
                | (F.col("format_hre_name_ul_cbm008.SECTION_NBR") == F.lit(""))
            )
        ),
        F.lit("Y"),
    )
    .otherwise(F.lit("N"))
    .alias("GRA_FLAG"),
    F.col("format_hre_name_ul_cbm008.SOURCE"),
    F.col("format_hre_name_ul_cbm008.TERM_BEGIN_DT"),
    F.col("format_hre_name_ul_cbm008.COLLEGE"),
    F.col("format_hre_name_ul_cbm008.DEPT"),
)

# COMMAND ----------

# Step 90: CRSE_ID_CHECK
# Create temp view: CRSE_ID_CHECK
df_crse_id_check = df_format_cbm008.alias("FORMAT_CBM008")
df_crse_id_check = df_crse_id_check.join(
    read_table(f"{student}.{bronze}.PS_CLASS_INSTR").alias("PS_CLASS_INSTR"),
    (
        (
            (
                F.col("format_cbm008.RANK").isin(["5", "6"])
                & ~F.col("ps_class_instr.ASSIGN_TYPE").isin(["NON", "EXC"])
            )
            & (F.col("format_cbm008.CIT_CHK_EMPLID") == F.col("ps_class_instr.EMPLID"))
        )
        & (F.col("format_cbm008.IN_STRM") == F.col("ps_class_instr.STRM"))
    ),
    "left",
)
df_crse_id_check = df_crse_id_check.filter(
    (
        (
            F.col("format_cbm008.SUBJECT_PREFIX").isNotNull()
            & (F.col("format_cbm008.SUBJECT_PREFIX") != F.lit(""))
        )
        | (F.col("format_cbm008.RANK") != F.lit("5"))
    )
)
_winSpec_6 = Window.partitionBy(
    F.col("format_cbm008.CIT_CHK_EMPLID"), F.col("format_cbm008.IN_STRM")
)
df_crse_id_check = df_crse_id_check.withColumn(
    "CRSE_ID_FOUND",
    F.max(
        F.when(F.col("ps_class_instr.CRSE_ID").isNotNull(), F.lit("Y")).otherwise(
            F.lit("N")
        )
    ).over(_winSpec_6),
)
df_crse_id_check = df_crse_id_check.withColumn("UNUSED", F.lit(None).cast("string"))
df_crse_id_check = df_crse_id_check.withColumn(
    "UNIT_CD_APPT", F.substring(F.col("format_cbm008.UTA_HRA_UNIT_CD"), 1, 4)
)
df_crse_id_check = df_crse_id_check.select(
    F.col("format_cbm008.RECORD_CODE"),
    F.col("format_cbm008.INSTITUTION_CODE"),
    # SAS source (L25038): FORMAT_CBM008.SSN as FACULTY_IDENTIFACTION_NUMBER
    F.col("format_cbm008.SSN").alias("FACULTY_IDENTIFACTION_NUMBER"),
    F.col("format_cbm008.LAST_NAME"),
    F.col("format_cbm008.FIRST_NAME"),
    F.col("format_cbm008.MIDDLE_INITIAL"),
    F.col("format_cbm008.RANK"),
    F.col("format_cbm008.TENURE"),
    F.col("format_cbm008.GENDER"),
    F.col("format_cbm008.ADMINISTRATIVE_UNIT_CODE"),
    F.col("UNUSED"),
    F.col("format_cbm008.DATE_OF_BIRTH"),
    F.col("format_cbm008.PERCENT_APPOINMENT_01"),
    F.col("format_cbm008.PERCENT_APPOINMENT_02"),
    F.col("format_cbm008.PERCENT_APPOINMENT_11"),
    F.col("format_cbm008.PERCENT_APPOINMENT_12"),
    F.col("format_cbm008.PERCENT_APPOINMENT_13"),
    F.col("format_cbm008.SALARY_STATE"),
    F.col("format_cbm008.SALARY_DESIGNATED"),
    F.col("format_cbm008.SALARY_RESTRICTED"),
    F.col("format_cbm008.SALARY_AUX"),
    F.col("format_cbm008.SALARY_OVERLOAD"),
    F.col("format_cbm008.FE_APPOINTMENT"),
    F.col("format_cbm008.FE_SALARY"),
    F.col("format_cbm008.FLEX_ENTRY"),
    F.col("format_cbm008.COMPLIANCE"),
    F.col("format_cbm008.NEW_HIRE"),
    F.col("format_cbm008.SEMESTER"),
    F.col("format_cbm008.YEAR"),
    F.col("format_cbm008.ETHINIC_ORIGIN"),
    F.col("format_cbm008.RACE_WHITE"),
    F.col("format_cbm008.RACE_AFRICAN_AMERICAN"),
    F.col("format_cbm008.RACE_ASIAN"),
    F.col("format_cbm008.RACE_AMERICAN_INDIAN"),
    F.col("format_cbm008.RACE_INTERNATIONAL"),
    F.col("format_cbm008.RACE_UNKOWN"),
    F.col("format_cbm008.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("format_cbm008.SUBJECT_PREFIX"),
    F.col("format_cbm008.COURSE_NUMBER"),
    F.col("format_cbm008.SECTION_NBR"),
    F.col("format_cbm008.TEACHING_LOAD_CREDIT"),
    # SAS source: FORMAT_CBM008.CB_CLASS_CD as COMPOSITE_CLASSES
    F.col("format_cbm008.CB_CLASS_CD").alias("COMPOSITE_CLASSES"),
    F.col("format_cbm008.RESPONSIBILITY_FACTOR"),
    F.col("format_cbm008.CIT_CHK_EMPLID"),
    F.col("CRSE_ID_FOUND"),
    F.col("UNIT_CD_APPT"),
    F.col("format_cbm008.GRA_FLAG"),
    F.col("format_cbm008.IN_STRM"),
    F.col("format_cbm008.UTSHARE_FISCAL_YEAR"),
    F.col("format_cbm008.UTA_HRE_MAJAPPTSEQ"),
    F.col("format_cbm008.SOURCE"),
    F.col("format_cbm008.UTA_HRA_FISCALYEAR"),
    F.col("format_cbm008.TERM_BEGIN_DT"),
    F.col("format_cbm008.COLLEGE"),
    F.col("format_cbm008.DEPT"),
)

# COMMAND ----------

df_crse_id_check = df_crse_id_check.distinct()
log_view_count("CRSE_ID_CHECK (FORMAT_CBM008/CRSE_ID_CHECK)", df_crse_id_check)

# COMMAND ----------

# Step 91: UNIT_CD_APPT
# Create temp view: UNIT_CD_APPT
df_unit_cd_appt = df_crse_id_check.alias("CRSE_ID_CHECK")
df_unit_cd_appt = df_unit_cd_appt.join(
    read_table(f"{student}.{bronze}.PS_UTA_HRA_TBL").alias("PS_UTA_HRA_TBL"),
    (
        (
            (
                (
                    F.col("crse_id_check.RANK").isin(["5", "6"])
                    & (
                        F.col("crse_id_check.ADMINISTRATIVE_UNIT_CODE").isNull()
                        | (F.col("crse_id_check.ADMINISTRATIVE_UNIT_CODE") == F.lit(""))
                    )
                )
                & (
                    F.col("crse_id_check.FACULTY_IDENTIFACTION_NUMBER")
                    == F.col("ps_uta_hra_tbl.SSN")
                )
            )
            & (
                F.col("crse_id_check.UTA_HRA_FISCALYEAR")
                == F.col("ps_uta_hra_tbl.UTA_HRA_FISCALYEAR")
            )
        )
        & (
            F.col("crse_id_check.UTA_HRE_MAJAPPTSEQ").cast("BIGINT")
            == F.col("ps_uta_hra_tbl.UTA_HRA_APPT_SEQNR")
        )
    ),
    "left",
)
df_unit_cd_appt = df_unit_cd_appt.select(
    F.col("crse_id_check.RECORD_CODE"),
    F.col("crse_id_check.INSTITUTION_CODE"),
    F.col("crse_id_check.FACULTY_IDENTIFACTION_NUMBER"),
    F.col("crse_id_check.LAST_NAME"),
    F.col("crse_id_check.FIRST_NAME"),
    F.col("crse_id_check.MIDDLE_INITIAL"),
    F.col("crse_id_check.RANK"),
    F.col("crse_id_check.TENURE"),
    F.col("crse_id_check.GENDER"),
    F.col("crse_id_check.ADMINISTRATIVE_UNIT_CODE"),
    F.col("crse_id_check.UNUSED"),
    F.col("crse_id_check.DATE_OF_BIRTH"),
    F.col("crse_id_check.PERCENT_APPOINMENT_01"),
    F.col("crse_id_check.PERCENT_APPOINMENT_02"),
    F.col("crse_id_check.PERCENT_APPOINMENT_11"),
    F.col("crse_id_check.PERCENT_APPOINMENT_12"),
    F.col("crse_id_check.PERCENT_APPOINMENT_13"),
    F.col("crse_id_check.SALARY_STATE"),
    F.col("crse_id_check.SALARY_DESIGNATED"),
    F.col("crse_id_check.SALARY_RESTRICTED"),
    F.col("crse_id_check.SALARY_AUX"),
    F.col("crse_id_check.SALARY_OVERLOAD"),
    F.col("crse_id_check.FE_APPOINTMENT"),
    F.col("crse_id_check.FE_SALARY"),
    F.col("crse_id_check.FLEX_ENTRY"),
    F.col("crse_id_check.COMPLIANCE"),
    F.col("crse_id_check.NEW_HIRE"),
    F.col("crse_id_check.SEMESTER"),
    F.col("crse_id_check.YEAR"),
    F.col("crse_id_check.ETHINIC_ORIGIN"),
    F.col("crse_id_check.RACE_WHITE"),
    F.col("crse_id_check.RACE_AFRICAN_AMERICAN"),
    F.col("crse_id_check.RACE_ASIAN"),
    F.col("crse_id_check.RACE_AMERICAN_INDIAN"),
    F.col("crse_id_check.RACE_INTERNATIONAL"),
    F.col("crse_id_check.RACE_UNKOWN"),
    F.col("crse_id_check.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("crse_id_check.SUBJECT_PREFIX"),
    F.col("crse_id_check.COURSE_NUMBER"),
    F.col("crse_id_check.SECTION_NBR"),
    F.col("crse_id_check.TEACHING_LOAD_CREDIT"),
    F.col("crse_id_check.COMPOSITE_CLASSES"),
    F.col("crse_id_check.RESPONSIBILITY_FACTOR"),
    F.col("crse_id_check.CIT_CHK_EMPLID"),
    F.col("crse_id_check.CRSE_ID_FOUND"),
    F.when(
        F.col("ps_uta_hra_tbl.UTA_HRA_UNIT_CD").isNotNull(),
        F.substring(F.col("ps_uta_hra_tbl.UTA_HRA_UNIT_CD"), 1, 4),
    )
    .otherwise(F.col("crse_id_check.UNIT_CD_APPT"))
    .alias("UNIT_CD_APPT"),
    F.col("crse_id_check.GRA_FLAG"),
    F.col("crse_id_check.IN_STRM"),
    F.col("crse_id_check.SOURCE"),
    F.col("crse_id_check.TERM_BEGIN_DT"),
    F.col("crse_id_check.COLLEGE"),
    F.col("crse_id_check.DEPT"),
)
log_view_count("UNIT_CD_APPT (UNIT_CD_APPT)", df_unit_cd_appt)

# COMMAND ----------

# Step 92: ADMIN_UNIT_CD
# Create temp view: ADMIN_UNIT_CD
df_admin_unit_cd = df_unit_cd_appt.alias("UNIT_CD_APPT")
df_admin_unit_cd = df_admin_unit_cd.join(
    df_acad_org_max_effdt_cbm008.alias("ACAD_ORG_MAX_EFFDT_CBM008"),
    (
        F.when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("0216")), F.lit("HONR"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("0217")), F.lit("UAC"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("0218")), F.lit("URPA"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1100")), F.lit("LART"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1105")), F.lit("ENGL"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1110")), F.lit("ART"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1115")), F.lit("MUSI"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1120")), F.lit("MODL"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1125")), F.lit("POLS"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1130")), F.lit("HIST"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1135")), F.lit("PHIL"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1140")), F.lit("KINE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1145")), F.lit("ANTH"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1150")), F.lit("COMM"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1155")), F.lit("LING"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1160")), F.lit("WOMS"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1165")), F.lit("THEA"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1170")), F.lit("CRCJ"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1175")), F.lit("MILS"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1185")), F.lit("LART"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1200")), F.lit("SCIE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1205")), F.lit("BIOL"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1210")), F.lit("CHEM"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1215")), F.lit("GEOL"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1220")), F.lit("MATH"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1225")), F.lit("PHYS"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1230")), F.lit("PSYC"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1300")), F.lit("BUSA"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1305")), F.lit("ACCT"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1310")), F.lit("MARK"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1315")), F.lit("FINA"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1320")), F.lit("INSY"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1325")), F.lit("ECON"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1330")), F.lit("MANA"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1400")), F.lit("ENGR"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1405")), F.lit("CE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1410")), F.lit("MAE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1415")), F.lit("EE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1420")), F.lit("IE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1425")), F.lit("CSE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1430")), F.lit("BME"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1435")), F.lit("EE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1445")), F.lit("MSE"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1500")), F.lit("URPA"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1600")), F.lit("SOCW"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1600")), F.lit("SOCW"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1700")), F.lit("ARCH"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1800")), F.lit("NURS"))
        .when(
            (F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1905")),
            F.when(
                (F.col("unit_cd_appt.CIT_CHK_EMPLID") == F.lit("1419050501")),
                F.lit("LEAD"),
            ).otherwise(F.lit("EDCI")),
        )
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1910")), F.lit("EDCI"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("1915")), F.lit("LEAD"))
        .when((F.col("unit_cd_appt.UNIT_CD_APPT") == F.lit("2000")), F.lit("URPA"))
        .otherwise(F.lit(""))
        == F.col("acad_org_max_effdt_cbm008.ACAD_ORG")
    ),
    "left",
)
df_admin_unit_cd = df_admin_unit_cd.filter(
    (
        (
            F.col("unit_cd_appt.ADMINISTRATIVE_UNIT_CODE").isNotNull()
            & (F.col("unit_cd_appt.ADMINISTRATIVE_UNIT_CODE") != F.lit(""))
        )
        | (
            F.col("acad_org_max_effdt_cbm008.DESCRSHORT").isNotNull()
            & (F.col("acad_org_max_effdt_cbm008.DESCRSHORT") != F.lit(""))
        )
    )
)
df_admin_unit_cd = df_admin_unit_cd.select(
    F.col("unit_cd_appt.RECORD_CODE"),
    F.col("unit_cd_appt.INSTITUTION_CODE"),
    F.col("unit_cd_appt.FACULTY_IDENTIFACTION_NUMBER"),
    F.col("unit_cd_appt.LAST_NAME"),
    F.col("unit_cd_appt.FIRST_NAME"),
    F.col("unit_cd_appt.MIDDLE_INITIAL"),
    F.col("unit_cd_appt.RANK"),
    F.col("unit_cd_appt.TENURE"),
    F.col("unit_cd_appt.GENDER"),
    F.when(
        (
            F.col("unit_cd_appt.ADMINISTRATIVE_UNIT_CODE").isNull()
            | (F.col("unit_cd_appt.ADMINISTRATIVE_UNIT_CODE") == F.lit(""))
        ),
        F.trim(F.col("acad_org_max_effdt_cbm008.DESCRSHORT")),
    )
    .otherwise(F.col("unit_cd_appt.ADMINISTRATIVE_UNIT_CODE"))
    .alias("ADMINISTRATIVE_UNIT_CODE"),
    F.col("unit_cd_appt.UNUSED"),
    F.col("unit_cd_appt.DATE_OF_BIRTH"),
    F.col("unit_cd_appt.PERCENT_APPOINMENT_01"),
    F.col("unit_cd_appt.PERCENT_APPOINMENT_02"),
    F.col("unit_cd_appt.PERCENT_APPOINMENT_11"),
    F.col("unit_cd_appt.PERCENT_APPOINMENT_12"),
    F.col("unit_cd_appt.PERCENT_APPOINMENT_13"),
    F.col("unit_cd_appt.SALARY_STATE"),
    F.col("unit_cd_appt.SALARY_DESIGNATED"),
    F.col("unit_cd_appt.SALARY_RESTRICTED"),
    F.col("unit_cd_appt.SALARY_AUX"),
    F.col("unit_cd_appt.SALARY_OVERLOAD"),
    F.col("unit_cd_appt.FE_APPOINTMENT"),
    F.col("unit_cd_appt.FE_SALARY"),
    F.col("unit_cd_appt.FLEX_ENTRY"),
    F.col("unit_cd_appt.COMPLIANCE"),
    F.col("unit_cd_appt.NEW_HIRE"),
    F.col("unit_cd_appt.SEMESTER"),
    F.col("unit_cd_appt.YEAR"),
    F.col("unit_cd_appt.ETHINIC_ORIGIN"),
    F.col("unit_cd_appt.RACE_WHITE"),
    F.col("unit_cd_appt.RACE_AFRICAN_AMERICAN"),
    F.col("unit_cd_appt.RACE_ASIAN"),
    F.col("unit_cd_appt.RACE_AMERICAN_INDIAN"),
    F.col("unit_cd_appt.RACE_INTERNATIONAL"),
    F.col("unit_cd_appt.RACE_UNKOWN"),
    F.col("unit_cd_appt.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("unit_cd_appt.SUBJECT_PREFIX"),
    F.col("unit_cd_appt.COURSE_NUMBER"),
    F.col("unit_cd_appt.SECTION_NBR"),
    F.col("unit_cd_appt.TEACHING_LOAD_CREDIT"),
    F.col("unit_cd_appt.COMPOSITE_CLASSES"),
    F.col("unit_cd_appt.RESPONSIBILITY_FACTOR"),
    F.col("unit_cd_appt.CIT_CHK_EMPLID"),
    F.col("unit_cd_appt.CRSE_ID_FOUND"),
    F.col("unit_cd_appt.UNIT_CD_APPT"),
    F.col("unit_cd_appt.GRA_FLAG"),
    F.col("unit_cd_appt.IN_STRM"),
    F.col("unit_cd_appt.SOURCE"),
    F.col("unit_cd_appt.TERM_BEGIN_DT"),
    F.col("unit_cd_appt.COLLEGE"),
    F.col("unit_cd_appt.DEPT"),
)

# COMMAND ----------

log_view_count("ADMIN_UNIT_CD (ADMIN_UNIT_CD_JOIN)", df_admin_unit_cd)

# COMMAND ----------

# (omitted SAS DI metadata cell: Step: Join)
# Create temp view: CBM008_WORK_STAGED
df_cbm008_work_staged = df_admin_unit_cd.alias("ADMIN_UNIT_CD")
df_cbm008_work_staged = df_cbm008_work_staged.select(
    F.col("admin_unit_cd.RECORD_CODE"),
    F.col("admin_unit_cd.INSTITUTION_CODE"),
    F.col("admin_unit_cd.FACULTY_IDENTIFACTION_NUMBER"),
    F.col("admin_unit_cd.LAST_NAME"),
    F.col("admin_unit_cd.FIRST_NAME"),
    F.col("admin_unit_cd.MIDDLE_INITIAL"),
    F.col("admin_unit_cd.RANK"),
    F.col("admin_unit_cd.TENURE"),
    F.col("admin_unit_cd.GENDER"),
    F.col("admin_unit_cd.ADMINISTRATIVE_UNIT_CODE"),
    F.col("admin_unit_cd.UNUSED"),
    F.col("admin_unit_cd.DATE_OF_BIRTH"),
    F.col("admin_unit_cd.PERCENT_APPOINMENT_01"),
    F.col("admin_unit_cd.PERCENT_APPOINMENT_02"),
    F.col("admin_unit_cd.PERCENT_APPOINMENT_11"),
    F.col("admin_unit_cd.PERCENT_APPOINMENT_12"),
    F.col("admin_unit_cd.PERCENT_APPOINMENT_13"),
    F.col("admin_unit_cd.SALARY_STATE"),
    F.col("admin_unit_cd.SALARY_DESIGNATED"),
    F.col("admin_unit_cd.SALARY_RESTRICTED"),
    F.col("admin_unit_cd.SALARY_AUX"),
    F.col("admin_unit_cd.SALARY_OVERLOAD"),
    F.col("admin_unit_cd.FE_APPOINTMENT"),
    F.col("admin_unit_cd.FE_SALARY"),
    F.col("admin_unit_cd.FLEX_ENTRY"),
    F.col("admin_unit_cd.COMPLIANCE"),
    F.col("admin_unit_cd.NEW_HIRE"),
    F.col("admin_unit_cd.SEMESTER"),
    F.col("admin_unit_cd.YEAR"),
    F.col("admin_unit_cd.ETHINIC_ORIGIN"),
    F.col("admin_unit_cd.RACE_WHITE"),
    F.col("admin_unit_cd.RACE_AFRICAN_AMERICAN"),
    F.col("admin_unit_cd.RACE_ASIAN"),
    F.col("admin_unit_cd.RACE_AMERICAN_INDIAN"),
    F.col("admin_unit_cd.RACE_INTERNATIONAL"),
    F.col("admin_unit_cd.RACE_UNKOWN"),
    F.col("admin_unit_cd.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("admin_unit_cd.SUBJECT_PREFIX"),
    F.col("admin_unit_cd.COURSE_NUMBER"),
    F.col("admin_unit_cd.SECTION_NBR"),
    F.col("admin_unit_cd.TEACHING_LOAD_CREDIT"),
    F.col("admin_unit_cd.COMPOSITE_CLASSES"),
    F.col("admin_unit_cd.RESPONSIBILITY_FACTOR"),
    F.col("admin_unit_cd.CIT_CHK_EMPLID"),
    F.col("admin_unit_cd.GRA_FLAG"),
    F.col("admin_unit_cd.IN_STRM"),
    F.col("admin_unit_cd.SOURCE"),
    F.col("admin_unit_cd.TERM_BEGIN_DT"),
    F.col("admin_unit_cd.COLLEGE"),
    F.col("admin_unit_cd.DEPT"),
)
df_cbm008_work_staged = df_cbm008_work_staged.distinct()
log_view_count("CBM008_WORK_STAGED (ADMIN_UNIT_CD)", df_cbm008_work_staged)

# COMMAND ----------

# Checkpoint 2: materialize df_cbm008_work_staged to break the upstream DAG (Steps 87-92)
# before the remaining Steps 93-97 join chain and the Step 98 write.
# Temp table is dropped immediately after the Step 98 write completes.
_tmp_stage92_tbl = f"{analytics}.{staging}._tmp_cbm008_stage92_work"
write_df_to_table(
    df_cbm008_work_staged, _tmp_stage92_tbl, mode="overwrite", overwriteSchema="true"
)
df_cbm008_work_staged = read_table(_tmp_stage92_tbl).alias("CBM008_WORK_STAGED")
log_msg(f"Checkpoint 2 materialized: {_tmp_stage92_tbl}")
log_view_count(
    "CBM008_WORK_STAGED (Checkpoint 2)", df_cbm008_work_staged, do_count=True
)

# COMMAND ----------

# Step 93: DEPT_CUR_RECORDS
# Create temp view: DEPT_CURRENT
df_dept_current = read_table(f"{analytics}.{silver}.dim_thecb_department").alias(
    "adw_dept_dim"
)
df_dept_current = df_dept_current.filter(
    (
        (
            (F.col("adw_dept_dim.is_current") == F.lit(True))
            & (F.col("adw_dept_dim.COLLEGE_EFF_FLG") == F.lit("A"))
        )
        & (F.col("adw_dept_dim.DEPT_EFF_FLG") == F.lit("A"))
    )
)
df_dept_current = df_dept_current.withColumn(
    "_agg_tmp_0",
    F.max(F.col("adw_dept_dim.is_current")).over(
        Window.partitionBy("adw_dept_dim.DEPT_SHORT_DESCR")
    ),
)
df_dept_current = df_dept_current.filter(
    (F.col("adw_dept_dim.is_current") == F.col("_agg_tmp_0"))
)
df_dept_current = df_dept_current.drop("_agg_tmp_0")
df_dept_current = df_dept_current.select(
    F.col("adw_dept_dim.DEPT"),
    F.col("adw_dept_dim.COLLEGE"),
    F.col("adw_dept_dim.COLLEGE_DESCR"),
    F.col("adw_dept_dim.DEPT_DESCR"),
    F.col("adw_dept_dim.DEPT_SHORT_DESCR"),
    F.col("adw_dept_dim.DEPT_EFF_DT"),
    F.col("adw_dept_dim.COLLEGE_EFF_DT"),
)
df_dept_current = df_dept_current.distinct()
log_view_count("DEPT_CURRENT (DEPT_CUR_RECORDS)", df_dept_current)

# COMMAND ----------


# Create temp view: DEPT_MAX_EFFDT
df_dept_max_effdt = df_dept_current.alias("DEPT_CURRENT")
df_dept_max_effdt = df_dept_max_effdt.withColumn(
    "_agg_tmp_0",
    F.max(F.col("dept_current.DEPT_EFF_DT")).over(
        Window.partitionBy("dept_current.DEPT_SHORT_DESCR")
    ),
)
df_dept_max_effdt = df_dept_max_effdt.filter(
    (F.col("dept_current.DEPT_EFF_DT") == F.col("_agg_tmp_0"))
)
df_dept_max_effdt = df_dept_max_effdt.drop("_agg_tmp_0")
df_dept_max_effdt = df_dept_max_effdt.select(
    F.when(
        (
            (F.col("dept_current.DEPT") == F.lit("PAD"))
            & (F.col("dept_current.DEPT_SHORT_DESCR") == F.lit("2423"))
        ),
        F.lit("PAPL"),
    )
    .otherwise(F.col("dept_current.DEPT"))
    .alias("DEPT"),
    F.col("dept_current.DEPT_DESCR"),
    F.col("dept_current.DEPT_SHORT_DESCR"),
)
df_dept_max_effdt = df_dept_max_effdt.distinct()
log_view_count("DEPT_MAX_EFFDT (MAX_DEPT_EFFDT)", df_dept_max_effdt)

# COMMAND ----------

# Step 95: MAX_COL_EFFDT
# Create temp view: DEPT_MAX_COL_EFFDT
df_dept_max_col_effdt = df_dept_current.alias("DEPT_CURRENT")
df_dept_max_col_effdt = df_dept_max_col_effdt.withColumn(
    "_agg_tmp_0",
    F.max(F.col("dept_current.COLLEGE_EFF_DT")).over(
        Window.partitionBy("dept_current.DEPT_SHORT_DESCR")
    ),
)
df_dept_max_col_effdt = df_dept_max_col_effdt.filter(
    (F.col("dept_current.COLLEGE_EFF_DT") == F.col("_agg_tmp_0"))
)
df_dept_max_col_effdt = df_dept_max_col_effdt.drop("_agg_tmp_0")
df_dept_max_col_effdt = df_dept_max_col_effdt.select(
    F.col("dept_current.COLLEGE"),
    F.col("dept_current.COLLEGE_DESCR"),
    F.col("dept_current.DEPT_SHORT_DESCR"),
)
df_dept_max_col_effdt = df_dept_max_col_effdt.distinct()
log_view_count("DEPT_MAX_COL_EFFDT (MAX_COL_EFFDT)", df_dept_max_col_effdt)

# COMMAND ----------

# Step 96: ADDL_FIELDS
# Create temp view: ADDL_FIELDS
df_addl_fields = df_cbm008_work_staged.alias("CBM008_WORK_STAGED")
df_addl_fields = df_addl_fields.join(
    read_table(f"{analytics}.{silver}.dim_thecb_person").alias("ADW_PERSON_DIM"),
    (F.col("cbm008_work_staged.CIT_CHK_EMPLID") == F.col("adw_person_dim.EMPLID")),
    "inner",
)
df_addl_fields = df_addl_fields.join(
    df_dept_max_effdt.alias("DEPT_MAX_EFFDT"),
    (
        F.col("cbm008_work_staged.ADMINISTRATIVE_UNIT_CODE")
        == F.col("dept_max_effdt.DEPT_SHORT_DESCR")
    ),
    "left",
)
df_addl_fields = df_addl_fields.join(
    df_dept_max_col_effdt.alias("DEPT_MAX_COL_EFFDT"),
    (
        F.col("cbm008_work_staged.ADMINISTRATIVE_UNIT_CODE")
        == F.col("dept_max_col_effdt.DEPT_SHORT_DESCR")
    ),
    "left",
)
df_addl_fields = df_addl_fields.select(
    F.col("cbm008_work_staged.RECORD_CODE"),
    F.col("cbm008_work_staged.INSTITUTION_CODE"),
    F.col("cbm008_work_staged.FACULTY_IDENTIFACTION_NUMBER"),
    F.col("cbm008_work_staged.LAST_NAME"),
    F.col("cbm008_work_staged.FIRST_NAME"),
    F.col("cbm008_work_staged.MIDDLE_INITIAL"),
    F.col("cbm008_work_staged.RANK"),
    F.col("cbm008_work_staged.TENURE"),
    F.col("cbm008_work_staged.GENDER"),
    F.col("cbm008_work_staged.ADMINISTRATIVE_UNIT_CODE"),
    F.col("cbm008_work_staged.UNUSED"),
    F.col("cbm008_work_staged.DATE_OF_BIRTH"),
    F.col("cbm008_work_staged.PERCENT_APPOINMENT_01"),
    F.col("cbm008_work_staged.PERCENT_APPOINMENT_02"),
    F.col("cbm008_work_staged.PERCENT_APPOINMENT_11"),
    F.col("cbm008_work_staged.PERCENT_APPOINMENT_12"),
    F.col("cbm008_work_staged.PERCENT_APPOINMENT_13"),
    F.col("cbm008_work_staged.SALARY_STATE"),
    F.col("cbm008_work_staged.SALARY_DESIGNATED"),
    F.col("cbm008_work_staged.SALARY_RESTRICTED"),
    F.col("cbm008_work_staged.SALARY_AUX"),
    F.col("cbm008_work_staged.SALARY_OVERLOAD"),
    F.col("cbm008_work_staged.FE_APPOINTMENT"),
    F.col("cbm008_work_staged.FE_SALARY"),
    F.col("cbm008_work_staged.FLEX_ENTRY"),
    F.col("cbm008_work_staged.COMPLIANCE"),
    F.col("cbm008_work_staged.NEW_HIRE"),
    F.col("cbm008_work_staged.SEMESTER"),
    F.col("cbm008_work_staged.YEAR"),
    F.col("cbm008_work_staged.ETHINIC_ORIGIN"),
    F.col("cbm008_work_staged.RACE_WHITE"),
    F.col("cbm008_work_staged.RACE_AFRICAN_AMERICAN"),
    F.col("cbm008_work_staged.RACE_ASIAN"),
    F.col("cbm008_work_staged.RACE_AMERICAN_INDIAN"),
    F.col("cbm008_work_staged.RACE_INTERNATIONAL"),
    F.col("cbm008_work_staged.RACE_UNKOWN"),
    F.col("cbm008_work_staged.RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("cbm008_work_staged.SUBJECT_PREFIX"),
    F.col("cbm008_work_staged.COURSE_NUMBER"),
    F.col("cbm008_work_staged.SECTION_NBR"),
    F.col("cbm008_work_staged.TEACHING_LOAD_CREDIT"),
    F.col("cbm008_work_staged.COMPOSITE_CLASSES"),
    F.col("cbm008_work_staged.RESPONSIBILITY_FACTOR"),
    F.col("cbm008_work_staged.CIT_CHK_EMPLID"),
    F.col("cbm008_work_staged.GRA_FLAG"),
    F.col("cbm008_work_staged.IN_STRM"),
    F.col("cbm008_work_staged.SOURCE"),
    F.col("cbm008_work_staged.TERM_BEGIN_DT"),
    F.col("adw_person_dim.BIRTH_DT"),
    (
        (
            F.year(F.expr("TO_DATE(CAST(cbm008_work_staged.TERM_BEGIN_DT AS DATE))"))
            - F.year(F.expr("TO_DATE(CAST(adw_person_dim.BIRTH_DT AS DATE))"))
        )
        - F.when(
            (
                (
                    F.month(F.expr("TO_DATE(CAST(adw_person_dim.BIRTH_DT AS DATE))"))
                    > F.month(
                        F.expr(
                            "TO_DATE(CAST(cbm008_work_staged.TERM_BEGIN_DT AS DATE))"
                        )
                    )
                )
                | (
                    (
                        F.month(
                            F.expr("TO_DATE(CAST(adw_person_dim.BIRTH_DT AS DATE))")
                        )
                        == F.month(
                            F.expr(
                                "TO_DATE(CAST(cbm008_work_staged.TERM_BEGIN_DT AS DATE))"
                            )
                        )
                    )
                    & (
                        F.dayofmonth(
                            F.expr("TO_DATE(CAST(adw_person_dim.BIRTH_DT AS DATE))")
                        )
                        > F.dayofmonth(
                            F.expr(
                                "TO_DATE(CAST(cbm008_work_staged.TERM_BEGIN_DT AS DATE))"
                            )
                        )
                    )
                )
            ),
            F.lit(1),
        ).otherwise(F.lit(0))
    ).alias("AGE"),
    F.year(F.expr("TO_DATE(CAST(adw_person_dim.BIRTH_DT AS DATE))"))
    .cast("STRING")
    .alias("BIRTH_YEAR"),
    F.lpad(
        F.month(F.expr("TO_DATE(CAST(adw_person_dim.BIRTH_DT AS DATE))")).cast(
            "STRING"
        ),
        2,
        "0",
    ).alias("BIRTH_MONTH"),
    (
        (
            F.coalesce(
                F.col("cbm008_work_staged.PERCENT_APPOINMENT_01").cast("double"),
                F.lit(0),
            )
            + F.coalesce(
                F.col("cbm008_work_staged.PERCENT_APPOINMENT_02").cast("double"),
                F.lit(0),
            )
        )
        / F.lit(100)
    ).alias("TEACHING_FTE"),
    (
        (
            (
                (
                    (
                        F.coalesce(
                            F.col("cbm008_work_staged.PERCENT_APPOINMENT_01").cast(
                                "double"
                            ),
                            F.lit(0),
                        )
                        + F.coalesce(
                            F.col("cbm008_work_staged.PERCENT_APPOINMENT_02").cast(
                                "double"
                            ),
                            F.lit(0),
                        )
                    )
                    + F.coalesce(
                        F.col("cbm008_work_staged.PERCENT_APPOINMENT_11").cast(
                            "double"
                        ),
                        F.lit(0),
                    )
                )
                + F.coalesce(
                    F.col("cbm008_work_staged.PERCENT_APPOINMENT_12").cast("double"),
                    F.lit(0),
                )
            )
            + F.coalesce(
                F.col("cbm008_work_staged.PERCENT_APPOINMENT_13").cast("double"),
                F.lit(0),
            )
        )
        / F.lit(100)
    ).alias("TOTAL_FTE"),
    F.col("dept_max_col_effdt.COLLEGE"),
    F.col("dept_max_effdt.DEPT"),
    F.col("dept_max_col_effdt.COLLEGE_DESCR"),
    F.col("dept_max_effdt.DEPT_DESCR"),
    F.when(
        (F.col("cbm008_work_staged.TENURE") == F.lit("0")), F.lit("NON-TENURED FACULTY")
    )
    .otherwise(
        F.when(
            (F.col("cbm008_work_staged.TENURE") == F.lit("1")), F.lit("TENURED FACULTY")
        ).otherwise(
            F.when(
                (F.col("cbm008_work_staged.TENURE") == F.lit("2")),
                F.lit("ON TENURE TRACK FACULTY"),
            ).otherwise(F.lit("UNKNOWN"))
        )
    )
    .alias("TENURE_DESCR"),
    F.when(
        (F.col("cbm008_work_staged.FLEX_ENTRY") == F.lit("6")),
        (
            (
                F.col("cbm008_work_staged.IN_STRM").cast("BIGINT")
                - F.when(
                    (
                        F.substring(F.col("cbm008_work_staged.IN_STRM"), 4, 1)
                        == F.lit("2")
                    ),
                    F.lit(4),
                ).otherwise(F.lit(3))
            )
            - F.when(
                (F.col("cbm008_work_staged.IN_STRM") == F.lit("2002")), F.lit(1000)
            ).otherwise(F.lit(0))
        ).cast("STRING"),
    )
    .otherwise(F.col("cbm008_work_staged.IN_STRM"))
    .alias("UTA_TERM"),
    F.when(
        (F.col("cbm008_work_staged.RACE_INTERNATIONAL") == F.lit("6")),
        F.lit("INTERNATIONAL"),
    )
    .otherwise(
        F.when(
            (F.col("cbm008_work_staged.ETHINIC_ORIGIN") == F.lit("1")),
            F.lit("HISPANIC OR LATINO OF ANY RACE"),
        ).otherwise(
            F.when(
                (F.col("cbm008_work_staged.RACE_AFRICAN_AMERICAN") == F.lit("2")),
                F.lit("BLACK OF ANY RACE (NON-HISPANIC)"),
            ).otherwise(
                F.when(
                    (F.col("cbm008_work_staged.RACE_UNKOWN") == F.lit("7")),
                    F.lit("UNKNOWN OR NOT REPORTED"),
                ).otherwise(
                    F.when(
                        (
                            (
                                (
                                    (
                                        F.coalesce(
                                            F.when(
                                                (
                                                    F.col(
                                                        "cbm008_work_staged.RACE_ASIAN"
                                                    ).isNotNull()
                                                    & (
                                                        F.col(
                                                            "cbm008_work_staged.RACE_ASIAN"
                                                        )
                                                        != F.lit("")
                                                    )
                                                ),
                                                F.lit(1),
                                            ).otherwise(F.lit(0)),
                                            F.lit(0),
                                        )
                                        + F.coalesce(
                                            F.when(
                                                (
                                                    F.col(
                                                        "cbm008_work_staged.RACE_HAWAIIN_PACIFIC_ISLANDER"
                                                    ).isNotNull()
                                                    & (
                                                        F.col(
                                                            "cbm008_work_staged.RACE_HAWAIIN_PACIFIC_ISLANDER"
                                                        )
                                                        != F.lit("")
                                                    )
                                                ),
                                                F.lit(1),
                                            ).otherwise(F.lit(0)),
                                            F.lit(0),
                                        )
                                    )
                                    + F.coalesce(
                                        F.when(
                                            (
                                                F.col(
                                                    "cbm008_work_staged.RACE_AMERICAN_INDIAN"
                                                ).isNotNull()
                                                & (
                                                    F.col(
                                                        "cbm008_work_staged.RACE_AMERICAN_INDIAN"
                                                    )
                                                    != F.lit("")
                                                )
                                            ),
                                            F.lit(1),
                                        ).otherwise(F.lit(0)),
                                        F.lit(0),
                                    )
                                )
                                + F.coalesce(
                                    F.when(
                                        (
                                            F.col(
                                                "cbm008_work_staged.RACE_WHITE"
                                            ).isNotNull()
                                            & (
                                                F.col("cbm008_work_staged.RACE_WHITE")
                                                != F.lit("")
                                            )
                                        ),
                                        F.lit(1),
                                    ).otherwise(F.lit(0)),
                                    F.lit(0),
                                )
                            )
                            > F.lit(1)
                        ),
                        F.lit("MULTIRACIAL"),
                    ).otherwise(
                        F.when(
                            (F.col("cbm008_work_staged.RACE_ASIAN") == F.lit("4")),
                            F.lit("ASIAN ONLY"),
                        ).otherwise(
                            F.when(
                                (
                                    F.col("cbm008_work_staged.RACE_AMERICAN_INDIAN")
                                    == F.lit("5")
                                ),
                                F.lit("AMERICAN INDIAN ONLY"),
                            ).otherwise(
                                F.when(
                                    (
                                        F.col(
                                            "cbm008_work_staged.RACE_HAWAIIN_PACIFIC_ISLANDER"
                                        )
                                        == F.lit("8")
                                    ),
                                    F.lit("NATIVE HAWAIIAN ONLY"),
                                ).otherwise(
                                    F.when(
                                        (
                                            F.col("cbm008_work_staged.RACE_WHITE")
                                            == F.lit("1")
                                        ),
                                        F.lit("WHITE ONLY"),
                                    ).otherwise(F.lit("UNKNOWN OR NOT REPORTED"))
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    .alias("ETHNIC"),
    F.when((F.col("cbm008_work_staged.RANK") == F.lit("1")), F.lit("PROFESSOR"))
    .otherwise(
        F.when(
            (F.col("cbm008_work_staged.RANK") == F.lit("2")),
            F.lit("ASSOCIATE PROFESSOR"),
        ).otherwise(
            F.when(
                (F.col("cbm008_work_staged.RANK") == F.lit("3")),
                F.lit("ASSISTANT PROFESSOR"),
            ).otherwise(
                F.when(
                    (F.col("cbm008_work_staged.RANK") == F.lit("4")),
                    F.lit("INSTRUCTOR"),
                ).otherwise(
                    F.when(
                        (F.col("cbm008_work_staged.RANK") == F.lit("5")),
                        F.lit("OTHER FACULTY"),
                    ).otherwise(
                        F.when(
                            (F.col("cbm008_work_staged.RANK") == F.lit("6")),
                            F.lit("TEACHING ASSISTANT"),
                        ).otherwise(F.lit("UNKNOWN"))
                    )
                )
            )
        )
    )
    .alias("RANK_DESCR"),
)

# COMMAND ----------

df_addl_fields = df_addl_fields.distinct()
log_view_count("ADDL_FIELDS (ADDL_FIELDS)", df_addl_fields)

# COMMAND ----------

# Step 97: FULL_TIME_FLG
# Create temp view: FULL_TIME_FLG
df_full_time_flag = df_addl_fields.alias("ADDL_FIELDS")
df_full_time_flag = df_full_time_flag.select(
    F.col("addl_fields.RECORD_CODE").cast("string"),
    F.col("addl_fields.INSTITUTION_CODE").cast("string"),
    F.col("addl_fields.FACULTY_IDENTIFACTION_NUMBER")
    .cast("string")
    .alias("NATIONAL_ID"),
    F.col("addl_fields.LAST_NAME").cast("string"),
    F.col("addl_fields.FIRST_NAME").cast("string"),
    F.col("addl_fields.MIDDLE_INITIAL").cast("string"),
    F.when(
        (F.col("addl_fields.RANK") == "") | (F.col("addl_fields.RANK").isNull()),
        F.lit(None),
    )
    .otherwise(F.col("addl_fields.RANK"))
    .cast("string")
    .alias("RANK"),
    F.col("addl_fields.TENURE").cast("string"),
    F.col("addl_fields.GENDER").cast("string"),
    F.col("addl_fields.ADMINISTRATIVE_UNIT_CODE").cast("string"),
    F.col("addl_fields.UNUSED").cast("string"),
    F.col("addl_fields.DATE_OF_BIRTH").cast("string"),
    F.col("addl_fields.PERCENT_APPOINMENT_01").cast("string"),
    F.col("addl_fields.PERCENT_APPOINMENT_02").cast("string"),
    F.col("addl_fields.PERCENT_APPOINMENT_11").cast("string"),
    F.col("addl_fields.PERCENT_APPOINMENT_12").cast("string"),
    F.col("addl_fields.PERCENT_APPOINMENT_13").cast("string"),
    F.col("addl_fields.SALARY_STATE").cast("string"),
    F.col("addl_fields.SALARY_DESIGNATED").cast("string"),
    F.col("addl_fields.SALARY_RESTRICTED").cast("string"),
    F.col("addl_fields.SALARY_AUX").cast("string"),
    F.col("addl_fields.SALARY_OVERLOAD").cast("string"),
    F.col("addl_fields.FE_APPOINTMENT").cast("string"),
    F.col("addl_fields.FE_SALARY").cast("string"),
    F.col("addl_fields.FLEX_ENTRY").cast("string"),
    F.col("addl_fields.COMPLIANCE").cast("string"),
    F.col("addl_fields.NEW_HIRE").cast("string"),
    F.col("addl_fields.SEMESTER").cast("string"),
    F.col("addl_fields.YEAR").cast("string"),
    F.col("addl_fields.ETHINIC_ORIGIN").cast("string"),
    F.col("addl_fields.RACE_WHITE").cast("string"),
    F.col("addl_fields.RACE_AFRICAN_AMERICAN").cast("string"),
    F.col("addl_fields.RACE_ASIAN").cast("string"),
    F.col("addl_fields.RACE_AMERICAN_INDIAN").cast("string"),
    F.col("addl_fields.RACE_INTERNATIONAL").cast("string"),
    F.col("addl_fields.RACE_UNKOWN").cast("string"),
    F.col("addl_fields.RACE_HAWAIIN_PACIFIC_ISLANDER").cast("string"),
    F.col("addl_fields.SUBJECT_PREFIX").cast("string"),
    F.col("addl_fields.COURSE_NUMBER").cast("string"),
    F.col("addl_fields.SECTION_NBR").cast("string"),
    F.col("addl_fields.TEACHING_LOAD_CREDIT").cast("string"),
    F.col("addl_fields.COMPOSITE_CLASSES").cast("string"),
    F.col("addl_fields.RESPONSIBILITY_FACTOR").cast("string"),
    F.col("addl_fields.CIT_CHK_EMPLID").cast("string").alias("EMPLID"),
    F.col("addl_fields.GRA_FLAG").cast("string"),
    F.col("addl_fields.IN_STRM").cast("string").alias("STRM"),
    F.col("addl_fields.AGE").cast("bigint"),
    F.col("addl_fields.BIRTH_YEAR").cast("string"),
    F.col("addl_fields.BIRTH_MONTH").cast("string"),
    F.col("addl_fields.TEACHING_FTE").cast("decimal(38,2)"),
    F.col("addl_fields.TOTAL_FTE").cast("decimal(38,2)"),
    F.col("addl_fields.COLLEGE").cast("string"),
    F.col("addl_fields.DEPT").cast("string"),
    F.col("addl_fields.COLLEGE_DESCR").cast("string"),
    F.col("addl_fields.DEPT_DESCR").cast("string"),
    F.col("addl_fields.TENURE_DESCR").cast("string"),
    F.col("addl_fields.UTA_TERM").cast("string"),
    F.when(F.col("addl_fields.TOTAL_FTE") > 0.95, F.lit("Y"))
    .otherwise(F.lit("N"))
    .alias("FULL_TIME_FLG"),
    F.col("addl_fields.ETHNIC").cast("string").alias("ETHNIC_DESCR"),
    F.col("addl_fields.RANK_DESCR").cast("string"),
)
log_view_count(
    "FULL_TIME_FLG (FULL_TIME_FLG - Final Output)", df_full_time_flag, do_count=True
)

# COMMAND ----------

# Create temp view: FILTER_REPORTABLE_CBM008
df_cbm008_pre_filter = df_full_time_flag.alias("CBM008_PRE_FILTER")
df_cbm008_pre_filter = df_cbm008_pre_filter.filter(
    (
        (
            (
                (
                    (
                        (
                            (
                                (
                                    (
                                        F.coalesce(
                                            F.col(
                                                "CBM008_PRE_FILTER.PERCENT_APPOINMENT_01"
                                            ).cast("BIGINT"),
                                            F.lit(0),
                                        )
                                        + F.coalesce(
                                            F.col(
                                                "CBM008_PRE_FILTER.PERCENT_APPOINMENT_02"
                                            ).cast("BIGINT"),
                                            F.lit(0),
                                        )
                                    )
                                    + F.coalesce(
                                        F.col(
                                            "CBM008_PRE_FILTER.PERCENT_APPOINMENT_11"
                                        ).cast("BIGINT"),
                                        F.lit(0),
                                    )
                                )
                                + F.coalesce(
                                    F.col(
                                        "CBM008_PRE_FILTER.PERCENT_APPOINMENT_12"
                                    ).cast("BIGINT"),
                                    F.lit(0),
                                )
                            )
                            + F.coalesce(
                                F.col("CBM008_PRE_FILTER.PERCENT_APPOINMENT_13").cast(
                                    "BIGINT"
                                ),
                                F.lit(0),
                            )
                        )
                        + F.coalesce(
                            F.col("CBM008_PRE_FILTER.FE_APPOINTMENT").cast("BIGINT"),
                            F.lit(0),
                        )
                    )
                    > F.lit(0)
                )
                | (
                    (
                        (
                            (
                                (
                                    (
                                        F.coalesce(
                                            F.col(
                                                "CBM008_PRE_FILTER.SALARY_STATE"
                                            ).cast("BIGINT"),
                                            F.lit(0),
                                        )
                                        + F.coalesce(
                                            F.col(
                                                "CBM008_PRE_FILTER.SALARY_DESIGNATED"
                                            ).cast("BIGINT"),
                                            F.lit(0),
                                        )
                                    )
                                    + F.coalesce(
                                        F.col(
                                            "CBM008_PRE_FILTER.SALARY_RESTRICTED"
                                        ).cast("BIGINT"),
                                        F.lit(0),
                                    )
                                )
                                + F.coalesce(
                                    F.col("CBM008_PRE_FILTER.SALARY_AUX").cast(
                                        "BIGINT"
                                    ),
                                    F.lit(0),
                                )
                            )
                            + F.coalesce(
                                F.col("CBM008_PRE_FILTER.SALARY_OVERLOAD").cast(
                                    "BIGINT"
                                ),
                                F.lit(0),
                            )
                        )
                        + F.coalesce(
                            F.col("CBM008_PRE_FILTER.FE_SALARY").cast("BIGINT"),
                            F.lit(0),
                        )
                    )
                    > F.lit(0)
                )
            )
            | (
                F.col("CBM008_PRE_FILTER.SECTION_NBR").isNotNull()
                & (F.col("CBM008_PRE_FILTER.SECTION_NBR") != F.lit(""))
            )
        )
        | (F.col("CBM008_PRE_FILTER.RANK") != F.lit("6"))
    )
)

# COMMAND ----------

df_cbm008_pre_filter = df_cbm008_pre_filter.select(
    F.col("CBM008_PRE_FILTER.RECORD_CODE").cast("string").alias("RECORD_CODE"),
    F.col("CBM008_PRE_FILTER.INSTITUTION_CODE")
    .cast("string")
    .alias("INSTITUTION_CODE"),
    F.col("CBM008_PRE_FILTER.NATIONAL_ID").cast("string").alias("National_ID"),
    F.col("CBM008_PRE_FILTER.LAST_NAME").cast("string").alias("LAST_NAME"),
    F.col("CBM008_PRE_FILTER.FIRST_NAME").cast("string").alias("FIRST_NAME"),
    F.col("CBM008_PRE_FILTER.MIDDLE_INITIAL").cast("string").alias("MIDDLE_INITIAL"),
    F.col("CBM008_PRE_FILTER.RANK").cast("string").alias("RANK"),
    F.col("CBM008_PRE_FILTER.TENURE").cast("string").alias("TENURE"),
    F.col("CBM008_PRE_FILTER.GENDER").cast("string").alias("GENDER"),
    F.col("CBM008_PRE_FILTER.ADMINISTRATIVE_UNIT_CODE")
    .cast("string")
    .alias("ADMINISTRATIVE_UNIT_CODE"),
    F.col("CBM008_PRE_FILTER.UNUSED").cast("string").alias("UNUSED"),
    F.col("CBM008_PRE_FILTER.DATE_OF_BIRTH").cast("string").alias("DATE_OF_BIRTH"),
    F.col("CBM008_PRE_FILTER.PERCENT_APPOINMENT_01")
    .cast("string")
    .alias("PERCENT_APPOINMENT_01"),
    F.col("CBM008_PRE_FILTER.PERCENT_APPOINMENT_02")
    .cast("string")
    .alias("PERCENT_APPOINMENT_02"),
    F.col("CBM008_PRE_FILTER.PERCENT_APPOINMENT_11")
    .cast("string")
    .alias("PERCENT_APPOINMENT_11"),
    F.col("CBM008_PRE_FILTER.PERCENT_APPOINMENT_12")
    .cast("string")
    .alias("PERCENT_APPOINMENT_12"),
    F.col("CBM008_PRE_FILTER.PERCENT_APPOINMENT_13")
    .cast("string")
    .alias("PERCENT_APPOINMENT_13"),
    F.col("CBM008_PRE_FILTER.SALARY_STATE").cast("string").alias("SALARY_STATE"),
    F.col("CBM008_PRE_FILTER.SALARY_DESIGNATED")
    .cast("string")
    .alias("SALARY_DESIGNATED"),
    F.col("CBM008_PRE_FILTER.SALARY_RESTRICTED")
    .cast("string")
    .alias("SALARY_RESTRICTED"),
    F.col("CBM008_PRE_FILTER.SALARY_AUX").cast("string").alias("SALARY_AUX"),
    F.col("CBM008_PRE_FILTER.SALARY_OVERLOAD").cast("string").alias("SALARY_OVERLOAD"),
    F.col("CBM008_PRE_FILTER.FE_APPOINTMENT").cast("string").alias("FE_APPOINTMENT"),
    F.col("CBM008_PRE_FILTER.FE_SALARY").cast("string").alias("FE_SALARY"),
    F.col("CBM008_PRE_FILTER.FLEX_ENTRY").cast("string").alias("FLEX_ENTRY"),
    F.col("CBM008_PRE_FILTER.COMPLIANCE").cast("string").alias("COMPLIANCE"),
    F.col("CBM008_PRE_FILTER.NEW_HIRE").cast("string").alias("NEW_HIRE"),
    F.col("CBM008_PRE_FILTER.SEMESTER").cast("string").alias("SEMESTER"),
    F.col("CBM008_PRE_FILTER.YEAR").cast("string").alias("YEAR"),
    F.col("CBM008_PRE_FILTER.ETHINIC_ORIGIN").cast("string").alias("ETHINIC_ORIGIN"),
    F.col("CBM008_PRE_FILTER.RACE_WHITE").cast("string").alias("RACE_WHITE"),
    F.col("CBM008_PRE_FILTER.RACE_AFRICAN_AMERICAN")
    .cast("string")
    .alias("RACE_AFRICAN_AMERICAN"),
    F.col("CBM008_PRE_FILTER.RACE_ASIAN").cast("string").alias("RACE_ASIAN"),
    F.col("CBM008_PRE_FILTER.RACE_AMERICAN_INDIAN")
    .cast("string")
    .alias("RACE_AMERICAN_INDIAN"),
    F.col("CBM008_PRE_FILTER.RACE_INTERNATIONAL")
    .cast("string")
    .alias("RACE_INTERNATIONAL"),
    F.col("CBM008_PRE_FILTER.RACE_UNKOWN").cast("string").alias("RACE_UNKOWN"),
    F.col("CBM008_PRE_FILTER.RACE_HAWAIIN_PACIFIC_ISLANDER")
    .cast("string")
    .alias("RACE_HAWAIIN_PACIFIC_ISLANDER"),
    F.col("CBM008_PRE_FILTER.SUBJECT_PREFIX").cast("string").alias("SUBJECT_PREFIX"),
    F.col("CBM008_PRE_FILTER.COURSE_NUMBER").cast("string").alias("COURSE_NUMBER"),
    F.when(
        F.col("CBM008_PRE_FILTER.SECTION_NBR").isNull()
        | (F.col("CBM008_PRE_FILTER.SECTION_NBR") == ""),
        F.lit(None),
    )
    .otherwise(F.col("CBM008_PRE_FILTER.SECTION_NBR").cast("string"))
    .alias("SECTION_NBR"),
    F.col("CBM008_PRE_FILTER.TEACHING_LOAD_CREDIT")
    .cast("string")
    .alias("TEACHING_LOAD_CREDIT"),
    F.col("CBM008_PRE_FILTER.COMPOSITE_CLASSES")
    .cast("string")
    .alias("COMPOSITE_CLASSES"),
    F.col("CBM008_PRE_FILTER.RESPONSIBILITY_FACTOR")
    .cast("string")
    .alias("RESPONSIBILITY_FACTOR"),
    F.col("CBM008_PRE_FILTER.EMPLID").cast("string").alias("EMPLID"),
    F.col("CBM008_PRE_FILTER.GRA_FLAG").cast("string").alias("GRA_FLAG"),
    F.col("CBM008_PRE_FILTER.STRM").cast("string").alias("STRM"),
    F.col("CBM008_PRE_FILTER.AGE").cast("bigint").alias("AGE"),
    F.col("CBM008_PRE_FILTER.BIRTH_YEAR").cast("string").alias("BIRTH_YEAR"),
    F.col("CBM008_PRE_FILTER.BIRTH_MONTH").cast("string").alias("BIRTH_MONTH"),
    F.col("CBM008_PRE_FILTER.TEACHING_FTE").cast("decimal(38,2)").alias("TEACHING_FTE"),
    F.col("CBM008_PRE_FILTER.TOTAL_FTE").cast("decimal(38,2)").alias("TOTAL_FTE"),
    F.col("CBM008_PRE_FILTER.COLLEGE").cast("string").alias("COLLEGE"),
    F.col("CBM008_PRE_FILTER.DEPT").cast("string").alias("DEPT"),
    F.col("CBM008_PRE_FILTER.COLLEGE_DESCR").cast("string").alias("COLLEGE_DESCR"),
    F.col("CBM008_PRE_FILTER.DEPT_DESCR").cast("string").alias("DEPT_DESCR"),
    F.col("CBM008_PRE_FILTER.TENURE_DESCR").cast("string").alias("TENURE_DESCR"),
    F.col("CBM008_PRE_FILTER.UTA_TERM").cast("string").alias("UTA_TERM"),
    F.col("CBM008_PRE_FILTER.FULL_TIME_FLG").cast("string").alias("FULL_TIME_FLG"),
    F.col("CBM008_PRE_FILTER.ETHNIC_DESCR").cast("string").alias("ETHNIC_DESCR"),
    F.col("CBM008_PRE_FILTER.RANK_DESCR").cast("string").alias("RANK_DESCR"),
).distinct()

# COMMAND ----------

log_msg(f"NOTE: Loading data ...")

# Step 98: Write fact_thecb_cbm008_work
# Load Technique: Full Load (TRUNCATE + PROC APPEND in SAS)
write_df_to_table(
    df_cbm008_pre_filter,
    f"{analytics}.{staging}.fact_thecb_cbm008_work",
    mode="overwrite",
    overwriteSchema="true",
)
log_msg(
    f"fact_thecb_cbm008_work written - row count: {get_count(df_cbm008_pre_filter )}"
)

# Drop checkpoint temp tables now that the final write is complete
for _tmp_tbl in (
    _tmp_stageX_tbl,
    _tmp_stageA_tbl,
    _tmp_stageB_tbl,
    _tmp_stageC_tbl,
    _tmp_stage87_tbl,
    _tmp_stage92_tbl,
):
    try:
        drop_table(_tmp_tbl)
        log_msg(f"Dropped checkpoint temp table: {_tmp_tbl}")
    except Exception as _e:
        log_msg(f"WARN: could not drop {_tmp_tbl}: {_e}")

# COMMAND ----------

# TODO: Path needs to be finalized/updated
output_path = student_ext_output_path


# COMMAND ----------


df = df_user_input_strm_cbm008.orderBy("STRM")
for row in df.collect():

    CBM008OutputTerm = row.STRM
    # Helper: fixed-width character field (left-justified, space-padded, truncated to width)
    def fmt_char(col_name, width):
        return F.rpad(
            F.substring(
                F.coalesce(F.col(col_name).cast("string"), F.lit("")), 1, width
            ),
            width,
            " ",
        )

# COMMAND ----------

    # Read ADW_CBM008_WORK and filter by current_term
    # SAS WHERE logic: converts YEAR/SEMESTER to a 4-char term code and compares to &current_term.
    # Term derivation: century_digit || year_2digit || semester_mapped
    #   century_digit: '0' if YEAR<'2000', else first char of YEAR
    #   semester_mapped: '1'->'8', '3'->'5', else as-is
    adw_cbm008_work = read_table(f"{analytics}.{staging}.fact_thecb_cbm008_work").alias(
        "w"
    )

    df_source = adw_cbm008_work.withColumn(
        "_derived_term",
        F.concat(
            F.when(F.col("w.YEAR") < F.lit("2000"), F.lit("0")).otherwise(
                F.substring(F.col("w.YEAR"), 1, 1)
            ),
            F.substring(F.col("w.YEAR"), 3, 2),
            F.when(F.col("w.SEMESTER") == F.lit("1"), F.lit("8"))
            .when(F.col("w.SEMESTER") == F.lit("3"), F.lit("5"))
            .otherwise(F.col("w.SEMESTER")),
        ),
    ).filter(F.col("_derived_term") == F.lit(CBM008OutputTerm))

    # Select columns — set unmapped fields to empty per SAS logic
    df_prep = df_source.select(
        F.col("w.RECORD_CODE"),
        F.col("w.INSTITUTION_CODE"),
        F.col("w.National_ID"),
        F.substring(F.trim(F.col("w.LAST_NAME")), 1, 10).alias("LAST_NAME"),
        F.substring(F.trim(F.col("w.FIRST_NAME")), 1, 1).alias("FIRST_NAME"),
        F.col("w.MIDDLE_INITIAL"),
        F.col("w.RANK"),
        F.col("w.TENURE"),
        F.col("w.GENDER"),
        F.col("w.ADMINISTRATIVE_UNIT_CODE"),
        F.col("w.UNUSED"),
        F.col("w.DATE_OF_BIRTH"),
        F.col("w.PERCENT_APPOINMENT_01"),
        F.col("w.PERCENT_APPOINMENT_02"),
        F.col("w.PERCENT_APPOINMENT_11"),
        F.col("w.PERCENT_APPOINMENT_12"),
        F.col("w.PERCENT_APPOINMENT_13"),
        F.col("w.SALARY_STATE"),
        F.col("w.SALARY_DESIGNATED"),
        F.col("w.SALARY_RESTRICTED"),
        F.col("w.SALARY_AUX"),
        F.col("w.SALARY_OVERLOAD"),
        F.col("w.FE_APPOINTMENT"),
        F.col("w.FE_SALARY"),
        F.col("w.FLEX_ENTRY"),
        F.col("w.COMPLIANCE"),
        F.col("w.NEW_HIRE"),
        F.col("w.SEMESTER"),
        F.col("w.YEAR"),
        F.col("w.ETHINIC_ORIGIN"),
        F.col("w.RACE_WHITE"),
        F.col("w.RACE_AFRICAN_AMERICAN"),
        F.col("w.RACE_ASIAN"),
        F.col("w.RACE_AMERICAN_INDIAN"),
        F.col("w.RACE_INTERNATIONAL"),
        F.col("w.RACE_UNKOWN"),
        F.col("w.RACE_HAWAIIN_PACIFIC_ISLANDER"),
        F.col("w.SUBJECT_PREFIX"),
        F.col("w.COURSE_NUMBER"),
        F.col("w.SECTION_NBR"),
        F.col("w.TEACHING_LOAD_CREDIT"),
        F.col("w.COMPOSITE_CLASSES"),
        F.col("w.RESPONSIBILITY_FACTOR"),
    )

# COMMAND ----------

    # Build fixed-width line (141 chars) matching SAS PUT layout
    df_fixed_width = df_prep.withColumn(
        "fixed_width_line",
        F.concat(
            fmt_char("RECORD_CODE", 1),  # @1   RECORD_CODE $1.
            fmt_char("INSTITUTION_CODE", 6),  # @2   INSTITUTION_CODE $6.
            fmt_char("National_ID", 9),  # @8   National_ID $9.
            fmt_char("LAST_NAME", 10),  # @17  LAST_NAME $10.
            fmt_char("FIRST_NAME", 1),  # @27  FIRST_NAME $1.
            fmt_char("MIDDLE_INITIAL", 1),  # @28  MIDDLE_INITIAL $1.
            fmt_char("RANK", 1),  # @29  RANK $1.
            fmt_char("TENURE", 1),  # @30  TENURE $1.
            fmt_char("GENDER", 1),  # @31  GENDER $1.
            fmt_char(
                "ADMINISTRATIVE_UNIT_CODE", 4
            ),  # @32  ADMINISTRATIVE_UNIT_CODE $4.
            fmt_char("UNUSED", 1),  # @36  UNUSED $1.
            fmt_char("DATE_OF_BIRTH", 6),  # @37  DATE_OF_BIRTH $6.
            fmt_char("PERCENT_APPOINMENT_01", 3),  # @43  PERCENT_APPOINMENT_01 $3.
            fmt_char("PERCENT_APPOINMENT_02", 3),  # @46  PERCENT_APPOINMENT_02 $3.
            fmt_char("PERCENT_APPOINMENT_11", 3),  # @49  PERCENT_APPOINMENT_11 $3.
            fmt_char("PERCENT_APPOINMENT_12", 3),  # @52  PERCENT_APPOINMENT_12 $3.
            fmt_char("PERCENT_APPOINMENT_13", 3),  # @55  PERCENT_APPOINMENT_13 $3.
            fmt_char("SALARY_STATE", 6),  # @58  SALARY_STATE $6.
            fmt_char("SALARY_DESIGNATED", 6),  # @64  SALARY_DESIGNATED $6.
            fmt_char("SALARY_RESTRICTED", 6),  # @70  SALARY_RESTRICTED $6.
            fmt_char("SALARY_AUX", 6),  # @76  SALARY_AUX $6.
            fmt_char("SALARY_OVERLOAD", 6),  # @82  SALARY_OVERLOAD $6.
            fmt_char("FE_APPOINTMENT", 3),  # @88  FE_APPOINTMENT $3.
            fmt_char("FE_SALARY", 6),  # @91  FE_SALARY $6.
            fmt_char("FLEX_ENTRY", 1),  # @97  FLEX_ENTRY $1.
            fmt_char("COMPLIANCE", 1),  # @98  COMPLIANCE $1.
            fmt_char("NEW_HIRE", 1),  # @99  NEW_HIRE $1.
            fmt_char("SEMESTER", 1),  # @100 SEMESTER $1.
            fmt_char("YEAR", 4),  # @101 YEAR $4.
            fmt_char("ETHINIC_ORIGIN", 1),  # @105 ETHINIC_ORIGIN $1.
            fmt_char("RACE_WHITE", 1),  # @106 RACE_WHITE $1.
            fmt_char("RACE_AFRICAN_AMERICAN", 1),  # @107 RACE_AFRICAN_AMERICAN $1.
            fmt_char("RACE_ASIAN", 1),  # @108 RACE_ASIAN $1.
            fmt_char("RACE_AMERICAN_INDIAN", 1),  # @109 RACE_AMERICAN_INDIAN $1.
            fmt_char("RACE_INTERNATIONAL", 1),  # @110 RACE_INTERNATIONAL $1.
            fmt_char("RACE_UNKOWN", 1),  # @111 RACE_UNKOWN $1.
            fmt_char(
                "RACE_HAWAIIN_PACIFIC_ISLANDER", 1
            ),  # @112 RACE_HAWAIIN_PACIFIC_ISLANDER $1.
            fmt_char("SUBJECT_PREFIX", 7),  # @113 SUBJECT_PREFIX $7.
            fmt_char("COURSE_NUMBER", 7),  # @120 COURSE_NUMBER $7.
            fmt_char("SECTION_NBR", 7),  # @127 SECTION_NBR $7.
            fmt_char("TEACHING_LOAD_CREDIT", 3),  # @134 TEACHING_LOAD_CREDIT $3.
            fmt_char("COMPOSITE_CLASSES", 2),  # @137 COMPOSITE_CLASSES $2.
            fmt_char("RESPONSIBILITY_FACTOR", 3),  # @139 RESPONSIBILITY_FACTOR $3.
        ),
    )

    # Data lines DataFrame
    df_data_lines = df_fixed_width.select(F.col("fixed_width_line").alias("value"))

# COMMAND ----------

    # Write CBM008_{current_term}_{date}.txt — header + data + EOF
    # SAS writes header first (if _n_=1), then appends data (MOD), then appends EOF (MOD)

    # Get SEMESTER and YEAR from first record for header construction
    first_row = df_prep.select("SEMESTER", "YEAR").first()
    semester_val = first_row["SEMESTER"] or " "
    year_val = first_row["YEAR"] or "    "
    record_count = df_prep.count()

    # SAS date format: 23JUN2026 (SYSDATE9.)
    sysdate9 = datetime.now().strftime("%d%b%Y").upper()

    # Build header line: 'HY2K003656CBM008' + semester + year + 'C0141JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU'
    header_text = (
        f"HY2K003656CBM008"
        f"{semester_val[:1]}"
        f"{year_val[:4]}"
        f"C0141JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU"
    )
    header_line = header_text

    # Build EOF line: 'EOF1' + record count zero-padded to 5 digits (SAS: _N_ z5.)
    eof_line = f"EOF1{record_count:05d}"

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

    # Write to text file
    cbm_filename = f"CBM008_{CBM008OutputTerm}_{sysdate9}"
    (
        df_full_file.coalesce(1)
        .write.mode("overwrite")
        .text(f"{output_path}{cbm_filename}")
    )

    # Rename part file to final filename
    _part_files = dbutils.fs.ls(f"{output_path}{cbm_filename}")
    _part_file = [f.path for f in _part_files if f.name.startswith("part-")][0]
    dbutils.fs.cp(_part_file, f"{output_path}{cbm_filename}.txt")
    dbutils.fs.rm(f"{output_path}{cbm_filename}", recurse=True)

    print(f"Written: {output_path}{cbm_filename}.txt")

# COMMAND ----------

    print(
        f"CBM008 text file generation complete for CBM008OutputTerm={CBM008OutputTerm}"
    )


# COMMAND ----------

_job_end_time = datetime.now()
_job_elapsed = _job_end_time - _job_start_time
log_msg(
    f"Job completed: transform_analytics_fact_thecb_cbm008 | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} | Elapsed: {str(_job_elapsed)}",
    "info",
)
