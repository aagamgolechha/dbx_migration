# Databricks notebook source
# MAGIC %md
# MAGIC # IPEDS 12-Month 
# MAGIC **Description:** Builds the IPEDS 12-Month Enrollment report data mart by transforming
# MAGIC student enrollment data from PeopleSoft source tables. This notebook implements comprehensive
# MAGIC business rules for ethnicity classification, residency determination, distance education
# MAGIC status, full/part-time classification, and student retention tracking.
# MAGIC
# MAGIC **Source:** Converted from SAS source file `IPEDS_12Month.sas`
# MAGIC
# MAGIC **Target Table:** `analytics.staging.fact_ipeds_twelve_month_enrollment_work`
# MAGIC (replaces legacy SAS target `IPEDSPRD.IPEDS_12MONTH_WORK`)
# MAGIC

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

from pyspark.sql import functions as F
from pyspark.sql.types import DecimalType, TimestampType
from pyspark.sql.window import Window
from itertools import chain

# COMMAND ----------

def _materialize_checkpoint(df, checkpoint_table_name, alias_name):
    """Persist an intermediate DataFrame to a staging table and reload it for downstream joins."""
    write_df_to_table(
        df,
        checkpoint_table_name,
        mode="overwrite",
        overwriteSchema="true",
    )
    log_msg(f"Checkpoint materialized: {checkpoint_table_name}", "info")
    return read_table(checkpoint_table_name).alias(alias_name)


# COMMAND ----------

# =============================================================================
# Job Start
# =============================================================================

_job_start_time = datetime.now()
log_msg(
    f"Job started: transform_analytics_fact_ipeds_twelve_month_enrollment_work | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)

# COMMAND ----------


## Define widgets
# Create widgets with default Annual reporting parameters 
dbutils.widgets.text("term", "2258", "Term")
dbutils.widgets.text("prev_year", "2248", "Previous Year")
dbutils.widgets.text("summerterm", "2255", "Summer Term")
dbutils.widgets.text("fromDate", "2025-07-01", "From Date")
dbutils.widgets.text("toDate", "2026-06-30", "To Date")
dbutils.widgets.text("year", "2025", "Year")

# Get values
term = dbutils.widgets.get("term")
prev_year = dbutils.widgets.get("prev_year")
summerterm = dbutils.widgets.get("summerterm")
fromDate = dbutils.widgets.get("fromDate")
toDate = dbutils.widgets.get("toDate")
year = dbutils.widgets.get("year")


# COMMAND ----------

# =============================================================================
# STEP 1 — Ethnicity Grouping
# Logic  : For each EMPLID, determine the dominant ethnicity code.
#          - If any row has HISPA, the student is Hispanic (HISPA takes priority).
#          - Otherwise, take the MAX ethnicity code across all rows.
#          - Count total distinct ethnicity entries per student (used for MULTIPLE detection).
# =============================================================================

# Window over each student — used for all per-EMPLID aggregations in this step
_win_by_emplid = Window.partitionBy("ps_divers_ethnic.EMPLID")
df_ethnicity_raw = (
    read_table(f"{student}.{bronze}.ps_divers_ethnic")
    .alias("ps_divers_ethnic")
    # Compute whether any record for this student is 'HISPA' (1 if yes, 0 if not)
    .withColumn(
        "_is_hispa_flag",
        F.max(
            F.when(
                F.col("ps_divers_ethnic.ETHNIC_GRP_CD") == F.lit("HISPA"), F.lit(1)
            ).otherwise(F.lit(0))
        ).over(_win_by_emplid),
    )
    .withColumn(
        "_max_ethnic_cd",
        F.max(F.col("ps_divers_ethnic.ETHNIC_GRP_CD")).over(_win_by_emplid),
    )
    # Count distinct ethnicity entries per student — identifies multi-racial students
    .withColumn(
        "ENTRY_COUNT",
        F.count(F.col("ps_divers_ethnic.ETHNIC_GRP_CD")).over(_win_by_emplid),
    )
    # Determine the resolved ethnic code: HISPA if any record is HISPA, otherwise MAX code
    .withColumn(
        "ETHNIC_GRP_CD",
        F.when(F.col("_is_hispa_flag") == F.lit(1), F.lit("HISPA")).otherwise(
            F.col("_max_ethnic_cd")
        ),
    )
    .select(
        F.col("ps_divers_ethnic.EMPLID"),
        F.col("ETHNIC_GRP_CD"),
        F.col("ps_divers_ethnic.SETID"),
        F.col("ENTRY_COUNT"),
    )
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 2 — Ethnicity Classification (ETHN_GRP)
# Logic  : Map raw ethnic code to IPEDS ethnicity group:
#          - Code 3 in dim → HISPANIC
#          - More than 1 ethnicity entry → MULTIPLE
#          - Otherwise → use the raw ethnic code itself
# =============================================================================
df_ethnicity_classified = (
    df_ethnicity_raw.alias("eth_raw")
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_ethnicity").alias("eth_dim"),
        (
            (F.col("eth_raw.ETHNIC_GRP_CD") == F.col("eth_dim.ETHNIC_GRP_CD"))
            & (F.col("eth_raw.SETID") == F.col("eth_dim.SETID"))
            & (F.col("eth_dim.is_current") == F.lit(True))
        ),
        "left",
    )
    .select(
        F.col("eth_raw.EMPLID"),
        F.col("eth_raw.ETHNIC_GRP_CD"),
        F.col("eth_raw.SETID"),
        F.col("eth_raw.ENTRY_COUNT"),
        F.when(F.col("eth_dim.ETHNICGROUPCODE") == F.lit("3"), F.lit("HISPANIC"))
        .when(F.col("eth_raw.ENTRY_COUNT") > F.lit(1), F.lit("MULTIPLE"))
        .otherwise(F.col("eth_raw.ETHNIC_GRP_CD"))
        .alias("ETHN_GRP"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 3 — Academic Program History: Latest Effective Date
# Logic  : For each student/career/career-number combination, keep only the
#          record(s) with the most recent EFFDT that is on or before toDate.
#          This is the first of two deduplication passes (EFFDT then EFFSEQ).
# =============================================================================

_win_by_emplid_career_carnum = Window.partitionBy(
    "ps_acad_prog.EMPLID", "ps_acad_prog.ACAD_CAREER", "ps_acad_prog.STDNT_CAR_NBR"
)
df_acad_prog_max_effdt = (
    read_table(f"{student}.{bronze}.ps_acad_prog")
    .alias("ps_acad_prog")
    .filter(F.col("ps_acad_prog.EFFDT") <= F.lit(toDate).cast("timestamp"))
    .withColumn(
        "_max_effdt",
        F.max(F.col("ps_acad_prog.EFFDT")).over(_win_by_emplid_career_carnum),
    )
    # Keep only the rows matching the latest EFFDT
    .filter(F.col("ps_acad_prog.EFFDT") == F.col("_max_effdt"))
    .drop("_max_effdt")
    .select(
        F.col("ps_acad_prog.EMPLID"),
        F.col("ps_acad_prog.ACAD_CAREER"),
        F.col("ps_acad_prog.STDNT_CAR_NBR"),
        F.col("ps_acad_prog.EFFDT"),
        F.col("ps_acad_prog.EFFSEQ"),
        F.col("ps_acad_prog.INSTITUTION"),
        F.col("ps_acad_prog.ACAD_PROG"),
        F.col("ps_acad_prog.PROG_STATUS"),
        F.col("ps_acad_prog.PROG_ACTION"),
        F.col("ps_acad_prog.ACTION_DT"),
        F.col("ps_acad_prog.PROG_REASON"),
        F.col("ps_acad_prog.ADMIT_TERM"),
        F.col("ps_acad_prog.EXP_GRAD_TERM"),
        F.col("ps_acad_prog.REQ_TERM"),
        F.col("ps_acad_prog.ACAD_LOAD_APPR"),
        F.col("ps_acad_prog.CAMPUS"),
        F.col("ps_acad_prog.DEGR_CHKOUT_STAT"),
        F.col("ps_acad_prog.COMPLETION_TERM"),
        F.col("ps_acad_prog.ACAD_PROG_DUAL"),
        F.col("ps_acad_prog.JOINT_PROG_APPR"),
        F.col("ps_acad_prog.ADM_APPL_NBR"),
        F.col("ps_acad_prog.APPL_PROG_NBR"),
        F.col("ps_acad_prog.DATA_FROM_ADM_APPL"),
        F.col("ps_acad_prog.SSR_RS_CANDIT_NBR"),
        F.col("ps_acad_prog.SSR_APT_INSTANCE"),
        F.col("ps_acad_prog.SSR_YR_OF_PROG"),
        F.col("ps_acad_prog.SSR_SHIFT"),
        F.col("ps_acad_prog.SSR_COHORT_ID"),
        F.col("ps_acad_prog.SCC_ROW_ADD_OPRID"),
        F.col("ps_acad_prog.SCC_ROW_ADD_DTTM"),
        F.col("ps_acad_prog.SCC_ROW_UPD_OPRID"),
        F.col("ps_acad_prog.SCC_ROW_UPD_DTTM"),
    )
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 4 — Academic Program History: Latest Effective Sequence
# Logic  : For each student/career/career-number/EFFDT, keep only the row
#          with the highest EFFSEQ (handles same-day correction records).
# =============================================================================

_win_by_emplid_career_carnum_effdt = Window.partitionBy(
    "aprog.EMPLID", "aprog.ACAD_CAREER", "aprog.STDNT_CAR_NBR", "aprog.EFFDT"
)

df_acad_prog_latest = (
    df_acad_prog_max_effdt.alias("aprog")
    # Compute maximum sequence number within each student/career/date group
    .withColumn(
        "_max_effseq",
        F.max(F.col("aprog.EFFSEQ")).over(_win_by_emplid_career_carnum_effdt),
    )
    # Keep only the row with the highest EFFSEQ for each group
    .filter(F.col("aprog.EFFSEQ") == F.col("_max_effseq"))
    .drop("_max_effseq")
    .select(
        F.col("aprog.EMPLID"),
        F.col("aprog.ACAD_CAREER"),
        F.col("aprog.STDNT_CAR_NBR"),
        F.col("aprog.EFFDT"),
        F.col("aprog.EFFSEQ"),
        F.col("aprog.INSTITUTION"),
        F.col("aprog.ACAD_PROG"),
        F.col("aprog.PROG_STATUS"),
        F.col("aprog.PROG_ACTION"),
        F.col("aprog.ACTION_DT"),
        F.col("aprog.PROG_REASON"),
        F.col("aprog.ADMIT_TERM"),
        F.col("aprog.EXP_GRAD_TERM"),
        F.col("aprog.REQ_TERM"),
        F.col("aprog.ACAD_LOAD_APPR"),
        F.col("aprog.CAMPUS"),
        F.col("aprog.DEGR_CHKOUT_STAT"),
        F.col("aprog.COMPLETION_TERM"),
        F.col("aprog.ACAD_PROG_DUAL"),
        F.col("aprog.JOINT_PROG_APPR"),
        F.col("aprog.ADM_APPL_NBR"),
        F.col("aprog.APPL_PROG_NBR"),
        F.col("aprog.DATA_FROM_ADM_APPL"),
        F.col("aprog.SSR_RS_CANDIT_NBR"),
        F.col("aprog.SSR_APT_INSTANCE"),
        F.col("aprog.SSR_YR_OF_PROG"),
        F.col("aprog.SSR_SHIFT"),
        F.col("aprog.SSR_COHORT_ID"),
        F.col("aprog.SCC_ROW_ADD_OPRID"),
        F.col("aprog.SCC_ROW_ADD_DTTM"),
        F.col("aprog.SCC_ROW_UPD_OPRID"),
        F.col("aprog.SCC_ROW_UPD_DTTM"),
    )
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 5 — Application Detail: Latest Application per Student/Career
# Logic  : For each student/academic-career combination, keep only the record
#          with the most recent application date (ADM_APPL_DT) on or before toDate.
# =============================================================================

_win_by_emplid_career_sk = Window.partitionBy("appl.EMPLID", "appl.ACAD_CAREER_SK")
df_latest_appl_detail = (
    read_table(f"{analytics}.{staging}.fact_thecb_application_detail")
    .alias("appl")
    .filter(F.col("appl.ADM_APPL_DT") <= F.lit(toDate).cast("timestamp"))
    # Compute the latest application date within each student/career group
    .withColumn(
        "_max_appl_dt", F.max(F.col("appl.ADM_APPL_DT")).over(_win_by_emplid_career_sk)
    )
    # Keep only the row(s) with the most recent application date
    .filter(F.col("appl.ADM_APPL_DT") == F.col("_max_appl_dt"))
    .drop("_max_appl_dt")
    .select(
        F.col("appl.EMPLID"),
        F.col("appl.INSTITUTION"),
        F.col("appl.ADM_APPL_NBR"),
        F.col("appl.FIN_AID_INTEREST"),
        F.col("appl.HOUSING_INTEREST"),
        F.col("appl.APPL_FEE_STATUS"),
        F.col("appl.APPL_FEE_DT"),
        F.col("appl.ADM_CREATION_DT"),
        F.col("appl.ADM_UPDATED_DT"),
        F.col("appl.ADM_APPL_COMPLETE"),
        F.col("appl.ADM_APPL_DT"),
        F.col("appl.ADM_APPL_CMPLT_DT"),
        F.col("appl.GRADUATION_DT"),
        F.col("appl.PRIOR_APPL"),
        F.col("appl.APPL_FEE_TYPE"),
        F.col("appl.ADM_APPL_METHOD"),
        F.col("appl.ACADEMIC_LEVEL"),
        F.col("appl.STUDENT_CAR_NBR"),
        F.col("appl.REGION"),
        F.col("appl.REGION_FROM"),
        F.col("appl.RECRUITER_ID"),
        F.col("appl.LAST_SCH_ATTEND"),
        F.col("appl.EXT_ADM_APPL_NBR"),
        F.col("appl.PROG_ACTION"),
        F.col("appl.PROG_REASON"),
        F.col("appl.PROG_STATUS"),
        F.col("appl.EXT_ORG_SK"),
        F.col("appl.PROG_ACTION_DESCR"),
        F.col("appl.PROG_REASON_DESCR"),
        F.col("appl.PROG_STATUS_DESCR"),
        F.col("appl.ACAD_PROGRAM_SK"),
        F.col("appl.ACAD_PLAN_SK"),
        F.col("appl.ACAD_CAREER_SK"),
        F.col("appl.DEPT_SK"),
        F.col("appl.TERM_SK"),
        F.col("appl.ADMIT_TYPE_SK"),
        F.col("appl.YLD_APPL"),
        F.col("appl.YLD_ADMIT"),
        F.col("appl.YLD_MATRICULATED"),
        F.col("appl.YLD_WITHDRAWN"),
        F.col("appl.YLD_WITHDRAWN_BEFORE_DECSN"),
        F.col("appl.YLD_WITHDRAWN_AFTER_DECSN"),
        F.col("appl.YLD_DENIED"),
        F.col("appl.YLD_ENROLLED"),
        F.col("appl.LAST_SCH_TRNSFR_HRS"),
        F.col("appl.LAST_SCH_TRNSFR_GRADE_PNTS"),
        F.col("appl.LAST_SCH_TRNSFR_GPA"),
        F.col("appl.LAST_SCH_CUM_TRNSFR_HRS"),
        F.col("appl.LAST_SCH_CUM_TRNSFR_GRADE_PNTS"),
        F.col("appl.LAST_SCH_CUML_TRNSFR_GPA"),
        F.col("appl.LAST_SCH_HS_PCNTL"),
        F.col("appl.UGRAD_GPA_FOR_GRADUATES"),
        F.col("appl.SAT_MATH_SCORE"),
        F.col("appl.SAT_VERBAL_SCORE"),
        F.col("appl.SAT_TOTAL_SCORE"),
        F.col("appl.ACT_COMPOSITE_SCORE"),
        F.col("appl.GRE_VERBAL_RSNG_SCORE"),
        F.col("appl.GRE_VERBAL_RSNG_SCORE_PCNTL"),
        F.col("appl.GRE_QUANT_RSNG_SCORE"),
        F.col("appl.GRE_QUANT_RSNG_SCORE_PCNTL"),
        F.col("appl.GRE_WRITING_RSNG_SCORE"),
        F.col("appl.GRE_ANALY_WRITING_SCORE_PCNTL"),
        F.col("appl.GRE_VERBAL_REVISED_SCORE"),
        F.col("appl.GRE_VERBAL_REVISED_SCORE_PCNTL"),
        F.col("appl.GRE_QUANT_REVISED_SCORE"),
        F.col("appl.GRE_QUANT_REVISED_SCORE_PCNTL"),
        F.col("appl.GMAT_QUANT_RSNG_SCORE"),
        F.col("appl.GMAT_QNTATVE_RSNG_SCORE_PCNTL"),
        F.col("appl.GMAT_VERBAL_RSNG_SCORE"),
        F.col("appl.GMAT_VERBAL_RSNG_SCORE_PCNTL"),
        F.col("appl.GMAT_INTGD_RSNG_SCORE"),
        F.col("appl.GMAT_INTGD_RSNG_SCORE_PCNTL"),
        F.col("appl.GMAT_ANALY_SCORE"),
        F.col("appl.GMAT_ANALY_SCORE_PCNTL"),
        F.col("appl.GMAT_TOTAL_SCORE"),
        F.col("appl.GMAT_TOTAL_SCORE_PCNTL"),
        #F.col("appl.UPDATE_DT"),
        #F.col("appl.UPDATE_USER"),
        F.col("appl.ACTION_DT"),
        F.col("appl.TOEFL_COMP_BASED_SCORE"),
        F.col("appl.TOEFL_IBT_LISTENING_SCORE"),
        F.col("appl.TOEFL_IBT_READING_SCORE"),
        F.col("appl.TOEFL_IBT_SPEAKING_SCORE"),
        F.col("appl.TOEFL_IBT_WRITING_SCORE"),
        F.col("appl.IELTS_OVERALL_SCORE"),
        F.col("appl.IELTS_SPEAKING_SCORE"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 6 — Course Offering: Latest Effective Row per Course
# Logic  : For each COURSE_IDENTIFIER, keep the row with the maximum EFF_DT
#          that is on or before toDate. Used later to resolve catalog number,
#          subject code, and CIP from the enrollment join.
# =============================================================================

_win_by_course_identifier = Window.partitionBy("co.COURSE_IDENTIFIER")
df_course_offer_latest = (
    read_table(f"{analytics}.{silver}.dim_thecb_course_offer")
    .alias("co")
    # Restrict to course offer records effective on or before reporting end date
    .filter(F.col("co.EFF_DT") <= F.lit(toDate).cast("timestamp"))
    # Find the most recent effective date per course
    .withColumn(
        "_max_eff_dt", F.max(F.col("co.EFF_DT")).over(_win_by_course_identifier)
    )
    # Keep only the latest effective row for each course identifier
    .filter(F.col("co.EFF_DT") == F.col("_max_eff_dt"))
    .drop("_max_eff_dt")
    .select(
        F.col("co.COURSE_OFFER_SK"),
        F.col("co.COURSE_IDENTIFIER"),
        F.col("co.COURSE_OFFER_NBR"),
        F.col("co.ACAD_GRP"),
        F.col("co.INSTITUTION"),
        F.col("co.ACAD_CAREER"),
        F.col("co.CATALOG_NBR"),
        F.col("co.SUBJECT"),
        F.col("co.COURSE_APPROVED_FLAG"),
        F.col("co.CAMPUS"),
        F.col("co.SPLIT_OWNER_FLAG"),
        F.col("co.SCHEDULED_TERM_ROLL"),
        F.col("co.CIP_CD"),
        F.col("co.SCHEDULED_COURSE"),
        F.col("co.DYNAMIC_CLASS_DATA"),
        F.col("co.OEE_FLAG"),
        F.col("co.EFF_DT"),
        F.col("co.is_current"),
        #F.col("co.UPDATE_DT"),
        #F.col("co.UPDATE_USER"),
        F.col("co.ACAD_ORG"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 7 — First Term Career Enrollment
# Logic  : For each student/career, identify the very first term they were
#          enrolled (FIRST_TERM_CARRER_ENRL_FLG = 'Y'), using the minimum
#          TERM_SK. This drives the INIT_TERM (initial enrolment term) field.
# =============================================================================

_win_by_emplid_career = Window.partitionBy("stef.EMPLID", "stef.ACAD_CAREER_SK")
df_first_career_term = (
    read_table(f"{analytics}.{staging}.fact_thecb_irp_enrollment")
    .alias("stef")
    # Join to term dimension to get the STRM code for display/reporting
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_dim"),
        F.col("stef.TERM_SK") == F.col("term_dim.TERM_SK"),
        "left",
    )
    # Only look at terms where FIRST_TERM_CARRER_ENRL_FLG = 'Y'
    .filter(F.col("stef.FIRST_TERM_CARRER_ENRL_FLG") == F.lit("Y"))
    # Find the minimum term_sk for each student/career (i.e., the first enrolled term)
    .withColumn(
        "_min_term_sk", F.min(F.col("stef.TERM_SK")).over(_win_by_emplid_career)
    )
    # Keep only the row corresponding to the first enrolled term
    .filter(F.col("stef.TERM_SK") == F.col("_min_term_sk"))
    .drop("_min_term_sk")
    .select(
        F.col("stef.EMPLID"),
        F.col("stef.ACAD_CAREER_SK"),
        F.col("stef.ACAD_PROGRAM_PRIMARY"),
        F.col("stef.TERM_SK"),
        F.col("term_dim.STRM"),  
    )
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 8 — Main Enrollment Join
# Logic  : Join class-level enrollment with term, schedule, department, program,
#          person, residency, academic program, CIP, and other dimension tables.
#          Apply filters for active enrollment, date range, valid programs, and
#          non-transit courses. Resolve the effective residency record using the
#          max EFFECTIVE_TERM per student/term/career (OR NULL for no residency).
#
#          Key computed fields:
#          - Age / AGE_GROUP from birth date vs. reporting year
#          - COHORT_ENTRY (remapped to "Other" for certain values/programs)
#          - ETHN_GRP (from classified ethnicity DataFrame)
#          - ADMIT_TERM (from df_acad_prog_latest)
# =============================================================================

# Reporting year as integer — used for age calculation
_reporting_year = int(year)

# Window for resolving the most effective residency record per student/term/career
_win_residency_max = Window.partitionBy(
    "scef.EMPLID", "term_dim.STRM", "career_dim.ACAD_CAREER"
)

# COMMAND ----------


df_enrollment_base = (
    read_table(f"{analytics}.{staging}.fact_thecb_student_term_course_enrollment")
    .alias("scef")
    # ── INNER JOINs (records must exist in all of these) ──────────────────────
    # Term-level enrollment: same student, same term, same career
    .join(
        read_table(f"{analytics}.{staging}.fact_thecb_irp_enrollment").alias(
            "stef"
        ),
        (
            (F.col("scef.EMPLID") == F.col("stef.EMPLID"))
            & (F.col("scef.TERM_SK") == F.col("stef.TERM_SK"))
            & (F.col("scef.ACAD_CAREER_SK") == F.col("stef.ACAD_CAREER_SK"))
        ),
        "inner",
    )
    # Main term dimension (for STRM, term description, academic year)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_dim"),
        F.col("scef.TERM_SK") == F.col("term_dim.TERM_SK"),
        "inner",
    )
    # Course-career term mapping: resolve the term_sk for the course's own career
    # (a class may be offered under a different career than the student's career)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_term").alias("course_term_dim"),
        (
            (F.col("term_dim.STRM") == F.col("course_term_dim.STRM"))
            & (F.col("scef.COURSE_CAREER") == F.col("course_term_dim.ACAD_CAREER"))
        ),
        "inner",
    )
    # Person demographic information (birth date, name, address, gender)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_person").alias("person_dim"),
        on=F.col("scef.EMPLID") == F.col("person_dim.EMPLID"),
        how="inner",
    )
)


# COMMAND ----------


# ── LEFT JOINs (optional enrichment) ──────────────────────────────────────
df_enrollment_enriched = (
    df_enrollment_base
    # Class schedule: instruction mode, start/end dates, section info
    .join(
        read_table(f"{analytics}.{staging}.fact_thecb_class_schedule").alias("sched"),
        (
            (F.col("course_term_dim.TERM_SK") == F.col("sched.TERM_SK"))
            & (F.col("scef.CLASS_NBR") == F.col("sched.CLASS_NBR"))
        ),
        "left",
    )
    # Major 1 department dimension
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_department").alias("major1_dept"),
        F.col("scef.MAJOR_DEPT_SK") == F.col("major1_dept.DEPT_SK"),
        "left",
    )
    # Major 2 department dimension
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_department").alias("major2_dept"),
        F.col("scef.MAJOR2_DEPT_SK") == F.col("major2_dept.DEPT_SK"),
        "left",
    )
    # Minor 1 department dimension
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_department").alias("minor1_dept"),
        F.col("scef.MINOR_DEPT_SK") == F.col("minor1_dept.DEPT_SK"),
        "left",
    )
    # Academic program dimension (degree level: UGRD, MASTR, DOCT, etc.)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_academic_program").alias("prog_dim"),
        F.col("stef.ACAD_PROGRAM_PRIMARY") == F.col("prog_dim.ACAD_PROGRAM_SK"),
        "left",
    )
    # Major 1 academic plan dimension (CIP code, plan code)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_academic_plan").alias("major1_plan"),
        F.col("scef.MAJOR_ACAD_PLAN_SK") == F.col("major1_plan.ACAD_PLAN_SK"),
        "left",
    )
    # Academic level description (e.g., Freshman, Sophomore) from item code table
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_item_code_value").alias("acad_lvl_desc"),
        (
            (F.col("acad_lvl_desc.FIELD_NAME") == F.lit("ACADEMIC_LEVEL"))
            & (F.col("acad_lvl_desc.FIELD_VAL") == F.col("scef.ACAD_LEVEL_EOT"))
        ),
        "left",
    )
    # Major 2 academic plan dimension
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_academic_plan").alias("major2_plan"),
        F.col("scef.MAJOR2_ACAD_PLAN_SK") == F.col("major2_plan.ACAD_PLAN_SK"),
        "left",
    )
    # Minor 1 academic plan dimension
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_academic_plan").alias("minor1_plan"),
        F.col("scef.MINOR_ACAD_PLAN_SK") == F.col("minor1_plan.ACAD_PLAN_SK"),
        "left",
    )
    # Class table used to get CRSE_OFFER_NBR for linking to course offer
    .join(
        read_table(f"{student}.{bronze}.ps_class_tbl").alias("class_tbl"),
        (
            (F.col("scef.CRSE_ID") == F.col("class_tbl.CRSE_ID"))
            & (F.col("scef.CLASS_NBR") == F.col("class_tbl.CLASS_NBR"))
            & (F.col("scef.CLASS_SECTION") == F.col("class_tbl.CLASS_SECTION"))
        ),
        "left",
    )
    # Course offer (pre-computed): catalog number, subject, ACAD_ORG
    .join(
        df_course_offer_latest.alias("course_offer"),
        (
            (F.col("scef.CRSE_ID") == F.col("course_offer.COURSE_IDENTIFIER"))
            & (
                F.col("class_tbl.CRSE_OFFER_NBR")
                == F.col("course_offer.COURSE_OFFER_NBR")
            )
        ),
        "left",
    )
    # Instruction mode description (Online, In-Person, Hybrid, etc.)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_instruction_mode").alias(
            "instrn_mode"
        ),
        (
            (F.col("sched.INSTRUCTION_MODE") == F.col("instrn_mode.INSTRN_MODE"))
            & (F.col("instrn_mode.is_current") == F.lit(True))
        ),
        "left",
    )
    # Academic career dimension (UGRD, GRAD, etc.)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias("career_dim"),
        F.col("scef.ACAD_CAREER_SK") == F.col("career_dim.ACAD_CAREER_SK"),
        "left",
    )
    # Residency: student's tuition residency classification per career
    .join(
        read_table(f"{student}.{bronze}.ps_residency_off").alias("resid"),
        (
            (F.col("scef.EMPLID") == F.col("resid.EMPLID"))
            & (F.col("resid.ACAD_CAREER") == F.col("career_dim.ACAD_CAREER"))
        ),
        "left",
    )
    # Residency dimension: description for TUITION_RES code
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_residency").alias(
            "tuition_res_dim"
        ),
        F.col("resid.TUITION_RES") == F.col("tuition_res_dim.RESIDENCY_CD"),
        "left",
    )
    # Academic program record: latest admit term for the student's career/program
    .join(
        df_acad_prog_latest.alias("acad_prog"),
        (
            (F.col("acad_prog.EMPLID") == F.col("scef.EMPLID"))
            & (F.col("acad_prog.ACAD_CAREER") == F.col("career_dim.ACAD_CAREER"))
            & (F.col("acad_prog.STDNT_CAR_NBR") == F.col("stef.STUDENT_CAREER_NBR"))
        ),
        "left",
    )
    # External academic summary: transfer credit summary (EXT_SUMM_TYPE = 'COLL')
    .join(
        read_table(f"{student}.{bronze}.ps_ext_acad_sum").alias("ext_acad"),
        (
            (F.col("scef.EMPLID") == F.col("ext_acad.EMPLID"))
            & (F.col("ext_acad.EXT_SUMM_TYPE") == F.lit("COLL"))
        ),
        "left",
    )
    # Latest application detail (pre-computed) for the student's career
    .join(
        df_latest_appl_detail.alias("appl_det"),
        (
            (F.col("scef.EMPLID") == F.col("appl_det.EMPLID"))
            & (F.col("scef.ACAD_CAREER_SK") == F.col("appl_det.ACAD_CAREER_SK"))
        ),
        "left",
    )
    # CIP code dimension for the student's major 1 plan
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_cip_code").alias("cip_dim"),
        F.col("cip_dim.CIP_CD") == F.col("major1_plan.CIP_CD"),
        "left",
    )
    # First career enrollment term (pre-computed INIT_TERM)
    .join(
        df_first_career_term.alias("first_term"),
        (
            (F.col("scef.EMPLID") == F.col("first_term.EMPLID"))
            & (F.col("stef.ACAD_CAREER_SK") == F.col("first_term.ACAD_CAREER_SK"))
        ),
        "left",
    )
    # Classified ethnicity (pre-computed ETHN_GRP)
    .join(
        df_ethnicity_classified.alias("eth_cls"),
        on=F.col("person_dim.EMPLID") == F.col("eth_cls.EMPLID"),
        how="left",
    )
    # Overall residency description (using RESIDENCY not TUITION_RES)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_residency").alias(
            "overall_resid_dim"
        ),
        (
            (F.col("resid.RESIDENCY") == F.col("overall_resid_dim.RESIDENCY_CD"))
            & (F.col("overall_resid_dim.is_current") == F.lit(True))
        ),
        "left",
    )
)


# COMMAND ----------


# ── ROW FILTERS ────────────────────────────────────────────────────────────
df_enrollment_filtered = (
    df_enrollment_enriched.filter(
        (F.col("scef.STUDENT_ENRL_FLG") == F.lit("Y"))
        & (F.col("sched.START_DT") >= F.lit(fromDate).cast("timestamp"))
        & (F.col("sched.START_DT") <= F.lit(toDate).cast("timestamp"))
        & (F.col("cip_dim.is_current") == F.lit(True))
        & F.col("prog_dim.ACAD_PROGRAM").isin(
            ["MASTR", "UGRD", "UGNDS", "CERT", "UGRD2", "SPEC", "DOCT"]
        )
        & (F.col("class_tbl.ACAD_ORG") != F.lit("TRAN"))
    )
)

# COMMAND ----------


# ── MAX EFFECTIVE_TERM WINDOW ──────────────────────────────────────────────
# Compute the latest residency effective term per student/term/career.
# This will be used to filter to the single most applicable residency record.
df_enrollment_resolved = (
    df_enrollment_filtered.withColumn(
        "_max_effective_term",
        F.max(F.col("resid.EFFECTIVE_TERM")).over(_win_residency_max),
    )
    # Keep only the residency row that matches the max effective term, OR if no
    # residency records exist for this student (NULL max), keep the row anyway.
    .filter(
        (F.col("resid.EFFECTIVE_TERM") == F.col("_max_effective_term"))
        | F.col("_max_effective_term").isNull()
    )
    .drop("_max_effective_term")
)


# COMMAND ----------


# ── COLUMN SELECTION AND COMPUTED FIELDS ──────────────────────────────────
df_enrollment_detail = (
    df_enrollment_resolved.select(
        F.lit("").alias("MIN_ONE_ONLINE_COURSE_FLG"),  # Populated downstream
        F.col("scef.EMPLID"),
        F.lit(-1).alias("ENROLLED_WITHIN_12_MONTHS"),  # Populated downstream
        # Cohort entry: certain cohort types are remapped to "Other"
        F.when(
            F.trim(F.col("stef.COHORT_ENTRY")).isin(
                [
                    "New Undergraduate Telecampus",
                    "New Undergraduate Transient",
                    "Continuing Student",
                ]
            ),
            F.lit("Other"),
        )
        .when(
            F.col("prog_dim.ACAD_PROGRAM").isin(["UGNDS", "CERT", "UGRD2", "SPEC"]),
            F.lit("Other"),
        )
        .otherwise(F.col("stef.COHORT_ENTRY"))
        .alias("COHORT_ENTRY"),
        # Age = reporting year minus birth year
        (
            F.lit(_reporting_year).cast("int")
            - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
        ).alias("Age"),
        # Age group bands matching IPEDS requirements
        F.when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            )
            < 18,
            F.lit("Under 18"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            ).between(18, 19),
            F.lit("18-19"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            ).between(20, 21),
            F.lit("20-21"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            ).between(22, 24),
            F.lit("22-24"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            ).between(25, 29),
            F.lit("25-29"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            ).between(30, 34),
            F.lit("30-34"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            ).between(35, 39),
            F.lit("35-39"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            ).between(40, 49),
            F.lit("40-49"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            ).between(50, 64),
            F.lit("50-64"),
        )
        .when(
            (
                F.lit(_reporting_year).cast("int")
                - F.year(F.col("person_dim.BIRTH_DT").cast("date"))
            )
            >= 65,
            F.lit("65 and over"),
        )
        .otherwise(F.lit("Age unknown/unreported"))
        .alias("AGE_GROUP"),
        F.col("career_dim.ACAD_CAREER"),
        F.col("prog_dim.ACAD_PROGRAM"),
        F.col("major1_dept.DEPT").alias("MAJOR1_DEPT"),
        F.col("major2_dept.DEPT").alias("MAJOR2_DEPT"),
        F.col("minor1_dept.DEPT").alias("MINOR1_DEPT"),
        F.current_timestamp().alias("SNAPSHOT_DT"),
        F.col("term_dim.STRM"),
        F.col("stef.ACAD_LVL_LOAD_EOT").alias("ACAD_LEVEL_EOT_CD"),
        F.col("acad_lvl_desc.DESCR").alias("ACAD_LEVEL_EOT_DESCR"),
        F.col("person_dim.FIRST_NAME"),
        F.col("person_dim.MIDDLE_NAME"),
        F.col("person_dim.BIRTH_DT"),
        F.col("person_dim.GENDER"),
        # Concatenate home address parts (NULL-safe)
        F.concat_ws(
            " ",
            F.col("person_dim.HOME_ADDR_1"),
            F.col("person_dim.HOME_ADDR_2"),
            F.col("person_dim.HOME_ADDR_3"),
            F.col("person_dim.HOME_ADDR_4"),
        ).alias("ADDRESS"),
        F.col("person_dim.HOME_ADDR_CITY"),
        F.col("person_dim.HOME_ADDR_STATE"),
        F.col("person_dim.HOME_ADDR_POSTAL"),
        F.col("person_dim.HOME_ADDR_COUNTRY"),
        F.col("person_dim.HOME_ADDR_GEOCODE"),
        F.col("person_dim.LAST_NAME"),
        # ETHN_GRP: ethnicity classification with IPEDS overrides
        F.when(
            F.trim(F.col("major1_plan.ACAD_PLAN")) == F.lit("EMBAMBNT"), F.lit("NSPEC")
        )
        .when(F.trim(F.col("resid.RESIDENCY")) == F.lit("4"), F.lit("FORGN"))
        .when(F.col("eth_cls.ETHN_GRP").isNull(), F.lit("NSPEC"))
        .otherwise(F.col("eth_cls.ETHN_GRP"))
        .alias("ETHN_GRP"),
        F.col("eth_cls.ETHN_GRP").alias("Student_Ethnicity"),
        F.col("major1_plan.ACAD_PLAN").alias("MAJOR1_PLAN"),
        F.col("major1_plan.CIP_CD").alias("MAJOR1_CIP_CD"),
        # Major 2 fields: return NULL if no second major (MAJOR2_DEPT_SK = -1)
        F.when(F.col("stef.MAJOR2_DEPT_SK") == F.lit(-1), F.lit(None))
        .otherwise(F.col("major2_plan.ACAD_PLAN"))
        .alias("MAJOR2_PLAN"),
        F.when(F.col("stef.MAJOR2_DEPT_SK") == F.lit(-1), F.lit(None))
        .otherwise(F.col("major2_plan.CIP_CD"))
        .alias("MAJOR2_CIP_CD"),
        F.col("minor1_plan.ACAD_PLAN").alias("MINOR1_PLAN"),
        F.col("minor1_plan.CIP_CD").alias("MINOR1_CIP_CD"),
        F.col("scef.CRSE_ID").alias("COURSE_ID"),
        F.col("course_offer.CATALOG_NBR"),
        F.col("course_offer.SUBJECT"),
        F.col("sched.INSTRUCTION_MODE"),
        F.col("sched.START_DT").alias("CLASS_START_DT"),
        F.col("sched.END_DT").alias("CLASS_END_DT"),
        F.col("sched.CLASS_SECTION"),
        F.col("instrn_mode.DESCR").alias("INSTRUCTION_MODE_DESCR"),
        F.col("scef.ENRL_ADD_DT"),
        F.col("scef.SESSION_CD"),
        F.col("scef.UNIT_TAKEN"),
        F.col("acad_prog.ADMIT_TERM"),
        F.col("resid.RESIDENCY"),
        F.col("scef.CLASS_NBR"),
        F.col("first_term.STRM").alias("INIT_TERM"),
        F.col("term_dim.DESCR").alias("TERM_DESCR"),
        F.col("term_dim.ACAD_YEAR"),
        F.col("cip_dim.DESCR254").alias("CIP_CD_DESCR"),
        F.col("prog_dim.DESCR").alias("ACAD_PROGRAM_DESCR"),
        F.col("career_dim.DESCR").alias("ACAD_CAREER_DESCR"),
        F.col("major1_dept.DEPT"),
        F.col("major1_dept.COLLEGE"),
        F.col("major1_dept.COLLEGE_DESCR"),
        F.col("major1_dept.DEPT_DESCR"),
        F.col("tuition_res_dim.DESCR").alias("TUITION_RESIDENCY_DESCR"),
        F.col("person_dim.HOME_ADDR_COUNTY"),
        F.col("resid.TUITION_RES"),
        F.col("overall_resid_dim.DESCR").alias("RESIDENCY_DESCR"),
    )
    .distinct()
)


# COMMAND ----------

#checkpoints
_tmp_stage_detail = f"{analytics}.{staging}.tmp_stage_detail"
df_enrollment_detail = _materialize_checkpoint(df_enrollment_detail, _tmp_stage_detail, "EDD")

# COMMAND ----------

# =============================================================================
# STEP 9 — HOME Address: Latest Active Record per Student
# Logic  : For each EMPLID, keep the most recent HOME address record whose
#          effective date is on or before toDate and status is Active ('A').
# =============================================================================

_win_by_emplid_addr_type = Window.partitionBy("addr.EMPLID", "addr.ADDRESS_TYPE")
df_home_address = (
    read_table(f"{student}.{bronze}.ps_addresses")
    .alias("addr")
    .filter(
        (F.col("addr.ADDRESS_TYPE") == F.lit("HOME"))
        & (F.col("addr.EFFDT") <= F.lit(toDate).cast("timestamp"))
    )
    # Find the latest effective date per student/address_type
    .withColumn("_max_effdt", F.max(F.col("addr.EFFDT")).over(_win_by_emplid_addr_type))
    # Keep only the latest active record
    .filter(
        (F.col("addr.EFFDT") == F.col("_max_effdt"))
        & (F.col("addr.EFF_STATUS") == F.lit("A"))
    )
    .drop("_max_effdt")
    .select(
        F.col("addr.EMPLID"),
        F.col("addr.ADDRESS_TYPE"),
        F.col("addr.ADDRESS1"),
        F.col("addr.ADDRESS2"),
        F.col("addr.ADDRESS3"),
        F.col("addr.ADDRESS4"),
        F.col("addr.CITY"),
        F.col("addr.STATE"),
        F.col("addr.POSTAL"),
        F.col("addr.COUNTRY"),
        F.col("addr.COUNTY"),
        F.col("addr.GEO_CODE"),
        F.col("addr.EFF_STATUS"),
        F.col("addr.EFFDT"),
        F.col("addr.ADDR_FIELD1"),
        F.col("addr.ADDR_FIELD2"),
        F.col("addr.ADDR_FIELD3"),
        F.col("addr.REG_REGION"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 10 — SEVF Address: Latest Active Service Address per Student
# Logic  : For foreign students (RESIDENCY = '4') without a qualifying visa,
#          IPEDS uses the SEVF (service/foreign) address for state reporting.
#          Get the most recent active SEVF record on or before toDate.
# =============================================================================
df_sevf_address = (
    read_table(f"{student}.{bronze}.ps_addresses")
    .alias("addr")
    .filter(
        (F.col("addr.ADDRESS_TYPE") == F.lit("SEVF"))
        & (F.col("addr.EFFDT") <= F.lit(toDate).cast("timestamp"))
    )
    .withColumn("_max_effdt", F.max(F.col("addr.EFFDT")).over(_win_by_emplid_addr_type))
    .filter(
        (F.col("addr.EFFDT") == F.col("_max_effdt"))
        & (F.col("addr.EFF_STATUS") == F.lit("A"))
    )
    .drop("_max_effdt")
    .select(
        F.col("addr.EMPLID"),
        F.col("addr.ADDRESS_TYPE"),
        F.col("addr.ADDRESS1"),
        F.col("addr.ADDRESS2"),
        F.col("addr.ADDRESS3"),
        F.col("addr.ADDRESS4"),
        F.col("addr.CITY"),
        F.col("addr.STATE"),
        F.col("addr.POSTAL"),
        F.col("addr.COUNTRY"),
        F.col("addr.COUNTY"),
        F.col("addr.GEO_CODE"),
        F.col("addr.EFF_STATUS"),
        F.col("addr.EFFDT"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 11 — PERM Address: Latest Active Permanent Address per Student
# Logic  : Fallback address for foreign students (RESIDENCY = '4') without
#          a qualifying visa and without a SEVF address. IPEDS uses the PERM
#          (permanent) address for state determination.
# =============================================================================
df_perm_address = (
    read_table(f"{student}.{bronze}.ps_addresses")
    .alias("addr")
    .filter(
        (F.col("addr.ADDRESS_TYPE") == F.lit("PERM"))
        & (F.col("addr.EFFDT") <= F.lit(toDate).cast("timestamp"))
    )
    .withColumn("_max_effdt", F.max(F.col("addr.EFFDT")).over(_win_by_emplid_addr_type))
    .filter(
        (F.col("addr.EFFDT") == F.col("_max_effdt"))
        & (F.col("addr.EFF_STATUS") == F.lit("A"))
    )
    .drop("_max_effdt")
    .select(
        F.col("addr.EMPLID"),
        F.col("addr.ADDRESS_TYPE"),
        F.col("addr.ADDRESS1"),
        F.col("addr.ADDRESS2"),
        F.col("addr.ADDRESS3"),
        F.col("addr.ADDRESS4"),
        F.col("addr.CITY"),
        F.col("addr.STATE"),
        F.col("addr.POSTAL"),
        F.col("addr.COUNTRY"),
        F.col("addr.COUNTY"),
        F.col("addr.GEO_CODE"),
        F.col("addr.EFF_STATUS"),
        F.col("addr.EFFDT"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 12 — Visa Filter 1: Qualifying Visas for IPEDS State Logic
# Logic  : A foreign student (RESIDENCY = '4') who holds one of the qualifying
#          visa types is treated as a domestic student for IPEDS state reporting
#          (i.e., use HOME address instead of SEVF/PERM).
#          Qualifying types: NV, ASY, LPR, REF, TPS, PLP (excludes AR1).
#          Keep the most recent visa record per student.
# =============================================================================

_win_by_emplid_visa = Window.partitionBy("visa.EMPLID")

df_qualifying_visa_state = (
    read_table(f"{student}.{bronze}.ps_visa_pmt_data")
    .alias("visa")
    # Exclude AR1 (alien registration) and only look at records up to toDate
    .filter(
        (F.col("visa.EFFDT") <= F.lit(toDate).cast("timestamp"))
        & (F.col("visa.VISA_PERMIT_TYPE") != F.lit("AR1"))
    )
    # Find the most recent visa record per student
    .withColumn("_max_effdt", F.max(F.col("visa.EFFDT")).over(_win_by_emplid_visa))
    # Keep most recent record only if it is a qualifying visa type
    .filter(
        (F.col("visa.EFFDT") == F.col("_max_effdt"))
        & F.col("visa.VISA_PERMIT_TYPE").isin(["NV", "ASY", "LPR", "REF", "TPS", "PLP"])
    )
    .drop("_max_effdt")
    .select(
        F.col("visa.EMPLID"),
        F.col("visa.VISA_PERMIT_TYPE"),
        F.col("visa.EFFDT"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 13 — IPEDS State and Address Resolution
# =============================================================================

def _null_safe_addr_concat(prefix: str) -> F.Column:
    """Build a trimmed, NULL-safe address string from ADDRESS1-4 fields."""
    return F.rtrim(
        F.substring(
            F.trim(
                F.concat_ws(
                    " ",
                    F.when(
                        F.trim(F.col(f"{prefix}.ADDRESS1")) != "",
                        F.trim(F.col(f"{prefix}.ADDRESS1")),
                    ),
                    F.when(
                        F.trim(F.col(f"{prefix}.ADDRESS2")) != "",
                        F.trim(F.col(f"{prefix}.ADDRESS2")),
                    ),
                    F.when(
                        F.trim(F.col(f"{prefix}.ADDRESS3")) != "",
                        F.trim(F.col(f"{prefix}.ADDRESS3")),
                    ),
                    F.when(
                        F.trim(F.col(f"{prefix}.ADDRESS4")) != "",
                        F.trim(F.col(f"{prefix}.ADDRESS4")),
                    ),
                )
            ),
            1,
            55,
        )
    )


# Condition: foreign student with NO qualifying visa → use SEVF/PERM for IPEDS address
_is_foreign_no_visa = (F.col("enrl.RESIDENCY") == F.lit("4")) & F.col(
    "visa_state.EMPLID"
).isNull()


# COMMAND ----------

df_ipeds_state_address = (
    df_enrollment_detail.alias("enrl")
    # Join to term dim for state/career-based lookups (used for IPEDS_STATE logic)
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_state"),
        (
            (F.col("enrl.STRM") == F.col("term_state.STRM"))
            & (F.col("enrl.ACAD_CAREER") == F.col("term_state.ACAD_CAREER"))
        ),
        "left",
    )
    # Join SEVF address — latest active record per student
    .join(
        df_sevf_address.alias("sevf_addr"),
        F.col("enrl.EMPLID") == F.col("sevf_addr.EMPLID"),
        "left",
    )
    # Join HOME address — latest active record per student
    .join(
        df_home_address.alias("home_addr"),
        F.col("enrl.EMPLID") == F.col("home_addr.EMPLID"),
        "left",
    )
    # Join PERM address — fallback for foreign students
    .join(
        df_perm_address.alias("perm_addr"),
        F.col("enrl.EMPLID") == F.col("perm_addr.EMPLID"),
        "left",
    )
    # Join visa (state logic) — presence indicates student should use HOME address
    .join(
        df_qualifying_visa_state.alias("visa_state"),
        F.col("enrl.EMPLID") == F.col("visa_state.EMPLID"),
        "left",
    ).select(
        # Pass-through enrollment fields
        F.col("enrl.MIN_ONE_ONLINE_COURSE_FLG"),
        F.col("enrl.EMPLID"),
        F.col("enrl.ENROLLED_WITHIN_12_MONTHS"),
        F.col("enrl.COHORT_ENTRY"),
        F.col("enrl.Age"),
        F.col("enrl.AGE_GROUP"),
        F.col("enrl.ACAD_CAREER"),
        F.col("enrl.ACAD_PROGRAM"),
        F.col("enrl.MAJOR1_DEPT"),
        F.col("enrl.MAJOR2_DEPT"),
        F.col("enrl.MINOR1_DEPT"),
        F.col("enrl.STRM"),
        F.col("enrl.ACAD_LEVEL_EOT_CD"),
        F.col("enrl.ACAD_LEVEL_EOT_DESCR"),
        F.col("enrl.FIRST_NAME"),
        F.col("enrl.MIDDLE_NAME"),
        F.col("enrl.BIRTH_DT"),
        F.col("enrl.GENDER"),
        F.when(
            _null_safe_addr_concat("home_addr") != F.lit(""),
            _null_safe_addr_concat("home_addr"),
        )
        .otherwise(F.lit(None))
        .alias("ADDRESS"),
        F.col("home_addr.CITY").alias("HOME_ADDR_CITY"),
        F.col("home_addr.STATE").alias("HOME_ADDR_STATE"),
        F.col("home_addr.POSTAL").alias("HOME_ADDR_POSTAL"),
        F.col("home_addr.COUNTRY").alias("HOME_ADDR_COUNTRY"),
        F.col("home_addr.GEO_CODE").alias("HOME_ADDR_GEOCODE"),
        F.col("home_addr.COUNTY").alias("HOME_ADDR_COUNTY"),
        F.col("enrl.LAST_NAME"),
        F.col("enrl.ETHN_GRP"),
        F.col("enrl.MAJOR1_PLAN"),
        F.col("enrl.MAJOR1_CIP_CD"),
        F.col("enrl.MAJOR2_PLAN"),
        F.col("enrl.MAJOR2_CIP_CD"),
        F.col("enrl.MINOR1_PLAN"),
        F.col("enrl.MINOR1_CIP_CD"),
        F.col("enrl.COURSE_ID"),
        F.col("enrl.CATALOG_NBR"),
        F.col("enrl.SUBJECT"),
        F.col("enrl.INSTRUCTION_MODE"),
        F.col("enrl.CLASS_START_DT"),
        F.col("enrl.CLASS_END_DT"),
        F.col("enrl.CLASS_SECTION"),
        F.col("enrl.INSTRUCTION_MODE_DESCR"),
        F.col("enrl.ENRL_ADD_DT"),
        F.col("enrl.SESSION_CD"),
        F.col("enrl.UNIT_TAKEN"),
        F.col("enrl.ADMIT_TERM"),
        F.col("enrl.RESIDENCY"),
        F.col("enrl.CLASS_NBR"),
        F.col("enrl.SNAPSHOT_DT"),
        F.col("enrl.TERM_DESCR"),
        F.col("enrl.ACAD_YEAR"),
        F.when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("SEVF")),
            F.col("sevf_addr.STATE"),
        )
        .when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("PERM")),
            F.col("perm_addr.STATE"),
        )
        .otherwise(F.col("home_addr.STATE"))
        .alias("IPEDS_STATE"),
        # IPEDS_FIPS_CD: NULL placeholder — computed in next step via stfips_map
        F.lit(None).cast("integer").alias("IPEDS_FIPS_CD"),
        F.col("enrl.CIP_CD_DESCR"),
        F.col("enrl.ACAD_PROGRAM_DESCR"),
        F.col("enrl.ACAD_CAREER_DESCR"),
        F.col("enrl.INIT_TERM"),
        F.col("enrl.DEPT"),
        F.col("enrl.COLLEGE"),
        F.col("enrl.COLLEGE_DESCR"),
        F.col("enrl.DEPT_DESCR"),
        F.col("enrl.TUITION_RESIDENCY_DESCR"),
        F.when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("SEVF")),
            F.col("sevf_addr.CITY"),
        )
        .when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("PERM")),
            F.col("perm_addr.CITY"),
        )
        .otherwise(F.col("home_addr.CITY"))
        .alias("IPEDS_CITY"),
        F.when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("SEVF")),
            F.col("sevf_addr.COUNTY"),
        )
        .when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("PERM")),
            F.col("perm_addr.COUNTY"),
        )
        .otherwise(F.col("home_addr.COUNTY"))
        .alias("IPEDS_COUNTY"),
        F.when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("SEVF")),
            F.col("sevf_addr.COUNTY"),
        )
        .when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("PERM")),
            F.col("perm_addr.COUNTY"),
        )
        .otherwise(F.col("home_addr.COUNTY"))
        .alias("IPEDS_COUNTY_CODE"),
        F.when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("SEVF")),
            F.col("sevf_addr.POSTAL"),
        )
        .when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("PERM")),
            F.col("perm_addr.POSTAL"),
        )
        .otherwise(F.col("home_addr.POSTAL"))
        .alias("IPEDS_POSTAL"),
        F.when(
            F.when(
                _is_foreign_no_visa
                & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("SEVF")),
                _null_safe_addr_concat("sevf_addr"),
            )
            .when(
                _is_foreign_no_visa
                & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("PERM")),
                _null_safe_addr_concat("perm_addr"),
            )
            .otherwise(_null_safe_addr_concat("home_addr"))
            != F.lit(""),
            F.when(
                _is_foreign_no_visa
                & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("SEVF")),
                _null_safe_addr_concat("sevf_addr"),
            )
            .when(
                _is_foreign_no_visa
                & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("PERM")),
                _null_safe_addr_concat("perm_addr"),
            )
            .otherwise(_null_safe_addr_concat("home_addr")),
        )
        .otherwise(F.lit(None))
        .alias("IPEDS_ADDR"),
        F.when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("SEVF")),
            F.col("sevf_addr.COUNTRY"),
        )
        .when(
            _is_foreign_no_visa & (F.col("sevf_addr.ADDRESS_TYPE") == F.lit("PERM")),
            F.col("perm_addr.COUNTRY"),
        )
        .otherwise(F.col("home_addr.COUNTRY"))
        .alias("IPEDS_COUNTRY"),
        F.col("enrl.TUITION_RES"),
        F.col("enrl.Student_Ethnicity"),
        F.col("enrl.RESIDENCY_DESCR"),
    )
)

# COMMAND ----------

#checkpoint
_tmp_stage_final = f"{analytics}.{staging}.tmp_stage_final"
df_ipeds_state_address = _materialize_checkpoint(df_ipeds_state_address, _tmp_stage_final, "ISA")

# COMMAND ----------

# =============================================================================
# STEP 14 — IPEDS_FIPS_CD: State Abbreviation → FIPS Code Lookup
# Logic  : Replaces the NULL placeholder from Step 13 with the actual FIPS
#          code using a map lookup (equivalent to SAS stfips() function).
# =============================================================================

stfips_map = {
    "AL": 1,
    "AK": 2,
    "AZ": 4,
    "AR": 5,
    "CA": 6,
    "CO": 8,
    "CT": 9,
    "DE": 10,
    "FL": 12,
    "GA": 13,
    "HI": 15,
    "ID": 16,
    "IL": 17,
    "IN": 18,
    "IA": 19,
    "KS": 20,
    "KY": 21,
    "LA": 22,
    "ME": 23,
    "MD": 24,
    "MA": 25,
    "MI": 26,
    "MN": 27,
    "MS": 28,
    "MO": 29,
    "MT": 30,
    "NE": 31,
    "NV": 32,
    "NH": 33,
    "NJ": 34,
    "NM": 35,
    "NY": 36,
    "NC": 37,
    "ND": 38,
    "OH": 39,
    "OK": 40,
    "OR": 41,
    "PA": 42,
    "RI": 44,
    "SC": 45,
    "SD": 46,
    "TN": 47,
    "TX": 48,
    "UT": 49,
    "VT": 50,
    "VA": 51,
    "WA": 53,
    "WV": 54,
    "WI": 55,
    "WY": 56,
    "DC": 11,
    "PR": 72,
    "GU": 66,
    "VI": 78,
    "AS": 60,
    "MP": 69,
    "MH": 68,
    "FM": 64,
    "PW": 70,
}

_stfips_col = F.create_map([F.lit(x) for x in chain(*stfips_map.items())])

# Overwrite the NULL placeholder with the actual FIPS code
df_ipeds_state_address = df_ipeds_state_address.withColumn(
    "IPEDS_FIPS_CD",
    _stfips_col[F.col("IPEDS_STATE")].cast(DecimalType(38, 10)),
)

# COMMAND ----------

# =============================================================================
# STEP 15A — Count Total Class Records per Student/Term/Career
# Logic  : Aggregation used downstream to determine whether all of a student's
#          classes are online (Count_total = Count_02 → exclusively online).
# =============================================================================

df_course_count_total = df_ipeds_state_address.groupBy(
    "STRM", "ACAD_CAREER", "EMPLID"
).agg(F.count(F.lit(1)).alias("Count_total"))

# COMMAND ----------

# =============================================================================
# STEP 15B — Count Online (Mode '02') Class Records per Student/Term/Career
# Logic  : Count of instruction mode '02' (fully online) classes per student.
#          Combined with Count_total to classify distance education status.
# =============================================================================

df_online_course_count = (
    df_ipeds_state_address.filter(F.col("INSTRUCTION_MODE") == F.lit("02"))
    .groupBy("STRM", "ACAD_CAREER", "EMPLID")
    .agg(F.count(F.lit(1)).alias("Count_02"))
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 16 — Visa Filter 2: Qualifying Visas for IPEDS Ethnicity Override
# Logic  : Same filter logic as Step 12 (state) — separate copy used only for
#          the ethnicity adjustment step, keeping concerns independent.
#          A foreign student with a qualifying visa uses their own ethnic
#          classification rather than the 'FORGN' code.
# =============================================================================

df_qualifying_visa_ethnicity = (
    read_table(f"{student}.{bronze}.ps_visa_pmt_data")
    .alias("visa")
    .filter(
        (F.col("visa.EFFDT") <= F.lit(toDate).cast("timestamp"))
        & (F.col("visa.VISA_PERMIT_TYPE") != F.lit("AR1"))
    )
    .withColumn(
        "_max_effdt", F.max(F.col("visa.EFFDT")).over(Window.partitionBy("visa.EMPLID"))
    )
    .filter(
        (F.col("visa.EFFDT") == F.col("_max_effdt"))
        & F.col("visa.VISA_PERMIT_TYPE").isin(["NV", "ASY", "LPR", "REF", "TPS", "PLP"])
    )
    .drop("_max_effdt")
    .select(
        F.col("visa.EMPLID"),
        F.col("visa.VISA_PERMIT_TYPE"),
        F.col("visa.EFFDT"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 17 — Distance Education Status + Full/Part-Time Classification
# =============================================================================
_win_stu_term_career = Window.partitionBy("isa.STRM", "isa.ACAD_CAREER", "isa.EMPLID")

df_distance_and_load = (
    df_ipeds_state_address.alias("isa")
    # Join online count (may be NULL if student has no online courses)
    .join(
        df_online_course_count.alias("online_cnt"),
        (
            (F.col("isa.EMPLID") == F.col("online_cnt.EMPLID"))
            & (F.col("isa.ACAD_CAREER") == F.col("online_cnt.ACAD_CAREER"))
            & (F.col("isa.STRM") == F.col("online_cnt.STRM"))
        ),
        "left",
    )
    # Join total course count
    .join(
        df_course_count_total.alias("total_cnt"),
        (
            (F.col("isa.EMPLID") == F.col("total_cnt.EMPLID"))
            & (F.col("isa.ACAD_CAREER") == F.col("total_cnt.ACAD_CAREER"))
            & (F.col("isa.STRM") == F.col("total_cnt.STRM"))
        ),
        "left",
    )
    # Pre-compute SUM of credits for FT/PT and SCH fields
    .withColumn("_total_sch", F.sum("isa.UNIT_TAKEN").over(_win_stu_term_career))
    # MIN/MAX instruction mode across all courses — used for exclusive/none detection
    .withColumn(
        "_min_instr_mode", F.min("isa.INSTRUCTION_MODE").over(_win_stu_term_career)
    )
    .withColumn(
        "_max_instr_mode", F.max("isa.INSTRUCTION_MODE").over(_win_stu_term_career)
    )
    .select(
        # Online flag: Y if at least one course is online
        F.when(F.coalesce(F.col("online_cnt.Count_02"), F.lit(0)) > 0, F.lit("Y"))
        .otherwise(F.lit("N"))
        .alias("MIN_ONE_ONLINE_COURSE_FLG"),
        F.col("isa.EMPLID"),
        F.col("isa.ENROLLED_WITHIN_12_MONTHS"),
        F.col("isa.AGE_GROUP"),
        F.col("isa.IPEDS_STATE"),
        F.col("isa.ACAD_CAREER"),
        F.col("isa.ACAD_PROGRAM"),
        F.col("isa.MAJOR1_DEPT"),
        F.col("isa.MAJOR2_DEPT"),
        F.col("isa.MINOR1_DEPT"),
        F.col("isa.STRM"),
        F.col("isa.ACAD_LEVEL_EOT_CD"),
        F.col("isa.ACAD_LEVEL_EOT_DESCR"),
        F.col("isa.FIRST_NAME"),
        F.col("isa.LAST_NAME"),
        F.col("isa.MIDDLE_NAME"),
        F.col("isa.BIRTH_DT"),
        F.col("isa.Age"),
        F.col("isa.COHORT_ENTRY"),
        F.col("isa.GENDER"),
        F.col("isa.ADDRESS"),
        F.col("isa.HOME_ADDR_CITY"),
        F.col("isa.HOME_ADDR_STATE"),
        F.col("isa.HOME_ADDR_POSTAL"),
        F.col("isa.HOME_ADDR_COUNTRY"),
        F.col("isa.HOME_ADDR_COUNTY"),
        F.col("isa.ETHN_GRP"),
        F.col("isa.MAJOR1_PLAN"),
        F.col("isa.MAJOR1_CIP_CD"),
        F.col("isa.MAJOR2_PLAN"),
        F.col("isa.MAJOR2_CIP_CD"),
        F.col("isa.MINOR1_PLAN"),
        F.col("isa.MINOR1_CIP_CD"),
        F.col("isa.COURSE_ID"),
        F.col("isa.CATALOG_NBR"),
        F.col("isa.SUBJECT"),
        F.col("isa.INSTRUCTION_MODE"),
        F.col("isa.CLASS_START_DT"),
        F.col("isa.CLASS_END_DT"),
        F.col("isa.CLASS_SECTION"),
        F.col("isa.INSTRUCTION_MODE_DESCR"),
        F.col("isa.ENRL_ADD_DT"),
        F.col("isa.SESSION_CD"),
        F.col("isa.UNIT_TAKEN"),
        F.col("isa.ADMIT_TERM"),
        F.col("isa.RESIDENCY"),
        F.when(
            F.upper(F.col("isa.ACAD_CAREER")) == F.lit("GRAD"),
            F.when(F.col("_total_sch") >= 9, F.lit("F")).otherwise(F.lit("P")),
        )
        .when(
            F.upper(F.col("isa.ACAD_CAREER")) == F.lit("UGRD"),
            F.when(F.col("_total_sch") >= 12, F.lit("F")).otherwise(F.lit("P")),
        )
        .otherwise(F.lit(""))
        .alias("IPEDS_FULL_PART_TIME_FLG"),
        F.col("_total_sch").alias("IPEDS_SCH"),
        F.when(
            (
                F.coalesce(F.col("online_cnt.Count_02"), F.lit(0))
                == F.col("total_cnt.Count_total")
            )
            & (F.coalesce(F.col("online_cnt.Count_02"), F.lit(0)) != 0),
            F.lit("Enrolled exclusively in distance education"),
        )
        .when(
            (F.col("_min_instr_mode") == F.lit("02"))
            & (F.col("_max_instr_mode") == F.lit("02")),
            F.lit("Enrolled exclusively in distance education"),
        )
        .when(
            (F.col("_min_instr_mode") == F.lit("01"))
            & (F.col("_max_instr_mode") == F.lit("01")),
            F.lit("Not enrolled in any online course"),
        )
        .when(
            (
                F.coalesce(F.col("online_cnt.Count_02"), F.lit(0))
                != F.col("total_cnt.Count_total")
            )
            & (F.coalesce(F.col("online_cnt.Count_02"), F.lit(0)) != 0),
            F.lit("Enrolled in some but not all distance education courses"),
        )
        .otherwise(F.lit("Not enrolled in any online course"))
        .alias("IPEDS_DISTANCE_EDUCATION_STATUS"),
        F.col("isa.IPEDS_FIPS_CD"),
        F.col("isa.CLASS_NBR"),
        F.col("isa.SNAPSHOT_DT"),
        F.col("isa.TERM_DESCR"),
        F.col("isa.ACAD_YEAR"),
        F.col("isa.CIP_CD_DESCR"),
        F.col("isa.ACAD_PROGRAM_DESCR"),
        F.col("isa.ACAD_CAREER_DESCR"),
        F.col("isa.INIT_TERM"),
        F.col("isa.DEPT"),
        F.col("isa.COLLEGE"),
        F.col("isa.COLLEGE_DESCR"),
        F.col("isa.DEPT_DESCR"),
        F.col("isa.TUITION_RESIDENCY_DESCR"),
        F.col("isa.IPEDS_CITY"),
        F.col("isa.IPEDS_COUNTY"),
        F.col("isa.IPEDS_COUNTY_CODE"),
        F.col("isa.IPEDS_POSTAL"),
        F.col("isa.IPEDS_ADDR"),
        F.col("isa.IPEDS_COUNTRY"),
        F.col("isa.TUITION_RES"),
        F.col("isa.Student_Ethnicity"),
        F.col("isa.RESIDENCY_DESCR"),
    )
)

# COMMAND ----------

#checkpoint
_tmp_stage_work = f"{analytics}.{staging}.tmp_stage_work"
df_distance_and_load = _materialize_checkpoint(df_distance_and_load, _tmp_stage_work, "DAL")

# COMMAND ----------

# =============================================================================
# STEP 18 — IPEDS Ethnicity Override for Visa Holders
# Logic  : Foreign students (ETHN_GRP = 'FORGN') who hold a qualifying visa
#          are reclassified using their own ethnic code (Student_Ethnicity)
#          rather than the 'FORGN' category, reflecting their self-identified
#          race/ethnicity for IPEDS purposes.
#          If Student_Ethnicity is NULL for such students, use 'NSPEC'.
# =============================================================================

df_ipeds_ethnicity = (
    df_distance_and_load.alias("dal")
    .join(
        df_qualifying_visa_ethnicity.alias("visa_eth"),
        F.col("dal.EMPLID") == F.col("visa_eth.EMPLID"),
        "left",
    )
    .select(
        F.col("dal.MIN_ONE_ONLINE_COURSE_FLG"),
        F.col("dal.EMPLID"),
        F.col("dal.ENROLLED_WITHIN_12_MONTHS"),
        F.col("dal.AGE_GROUP"),
        F.col("dal.IPEDS_STATE"),
        F.col("dal.ACAD_CAREER"),
        F.col("dal.ACAD_PROGRAM"),
        F.col("dal.MAJOR1_DEPT"),
        F.col("dal.MAJOR2_DEPT"),
        F.col("dal.MINOR1_DEPT"),
        F.col("dal.STRM"),
        F.col("dal.ACAD_LEVEL_EOT_CD"),
        F.col("dal.ACAD_LEVEL_EOT_DESCR"),
        F.col("dal.FIRST_NAME"),
        F.col("dal.LAST_NAME"),
        F.col("dal.MIDDLE_NAME"),
        F.col("dal.BIRTH_DT"),
        F.col("dal.Age"),
        F.col("dal.COHORT_ENTRY"),
        F.col("dal.GENDER"),
        F.col("dal.ADDRESS"),
        F.col("dal.HOME_ADDR_CITY"),
        F.col("dal.HOME_ADDR_STATE"),
        F.col("dal.HOME_ADDR_POSTAL"),
        F.col("dal.HOME_ADDR_COUNTRY"),
        F.col("dal.HOME_ADDR_COUNTY"),
        F.col("dal.ETHN_GRP"),
        F.col("dal.Student_Ethnicity"),
        F.col("dal.MAJOR1_PLAN"),
        F.col("dal.MAJOR1_CIP_CD"),
        F.col("dal.MAJOR2_PLAN"),
        F.col("dal.MAJOR2_CIP_CD"),
        F.col("dal.MINOR1_PLAN"),
        F.col("dal.MINOR1_CIP_CD"),
        F.col("dal.COURSE_ID"),
        F.col("dal.CATALOG_NBR"),
        F.col("dal.SUBJECT"),
        F.col("dal.INSTRUCTION_MODE"),
        F.col("dal.CLASS_START_DT"),
        F.col("dal.CLASS_END_DT"),
        F.col("dal.CLASS_SECTION"),
        F.col("dal.INSTRUCTION_MODE_DESCR"),
        F.col("dal.ENRL_ADD_DT"),
        F.col("dal.SESSION_CD"),
        F.col("dal.UNIT_TAKEN"),
        F.col("dal.ADMIT_TERM"),
        F.col("dal.RESIDENCY"),
        F.col("dal.IPEDS_FULL_PART_TIME_FLG"),
        F.col("dal.IPEDS_SCH"),
        F.col("dal.IPEDS_DISTANCE_EDUCATION_STATUS"),
        F.col("dal.IPEDS_FIPS_CD"),
        F.col("dal.CLASS_NBR"),
        F.col("dal.SNAPSHOT_DT"),
        F.col("dal.TERM_DESCR"),
        F.col("dal.ACAD_YEAR"),
        F.col("dal.CIP_CD_DESCR"),
        F.col("dal.ACAD_PROGRAM_DESCR"),
        F.col("dal.ACAD_CAREER_DESCR"),
        F.col("dal.INIT_TERM"),
        F.col("dal.DEPT"),
        F.col("dal.COLLEGE"),
        F.col("dal.COLLEGE_DESCR"),
        F.col("dal.DEPT_DESCR"),
        F.col("dal.TUITION_RESIDENCY_DESCR"),
        F.col("dal.IPEDS_CITY"),
        F.col("dal.IPEDS_COUNTY"),
        F.col("dal.IPEDS_COUNTY_CODE"),
        F.col("dal.IPEDS_POSTAL"),
        F.col("dal.IPEDS_ADDR"),
        F.col("dal.IPEDS_COUNTRY"),
        F.col("dal.TUITION_RES"),
        F.col("dal.RESIDENCY_DESCR"),
        # IPEDS ethnicity override: foreign + qualifying visa → use student's own code
        F.when(
            (F.trim(F.col("dal.ETHN_GRP")) == F.lit("FORGN"))
            & F.trim(F.col("visa_eth.VISA_PERMIT_TYPE")).isin(
                ["NV", "ASY", "LPR", "REF", "TPS", "PLP"]
            )
            & F.col("dal.Student_Ethnicity").isNotNull(),
            F.col("dal.Student_Ethnicity"),
        )
        .when(
            (F.trim(F.col("dal.ETHN_GRP")) == F.lit("FORGN"))
            & F.trim(F.col("visa_eth.VISA_PERMIT_TYPE")).isin(
                ["NV", "ASY", "LPR", "REF", "TPS", "PLP"]
            )
            & F.col("dal.Student_Ethnicity").isNull(),
            F.lit("NSPEC"),
        )
        .otherwise(F.trim(F.col("dal.ETHN_GRP")))
        .alias("IPEDS_ETHNICITY"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 19 — Names: Latest Primary Name per Student
# Logic  : Get the most recent PRI (Primary) name record per student with an
#          effective date on or before toDate. This provides the IPEDS-reportable
#          name fields with '?' characters replaced by 'n' (SAS tranwrd logic).
# =============================================================================
df_primary_names = (
    read_table(f"{student}.{bronze}.ps_names")
    .alias("nm")
    # Only look at Primary name type records within the reporting window
    .filter(
        (F.col("nm.EFFDT") <= F.lit(toDate).cast("timestamp"))
        & (F.col("nm.NAME_TYPE") == F.lit("PRI"))
    )
    # Latest name record per student
    .withColumn(
        "_max_effdt", F.max(F.col("nm.EFFDT")).over(Window.partitionBy("nm.EMPLID"))
    )
    .filter(F.col("nm.EFFDT") == F.col("_max_effdt"))
    .drop("_max_effdt")
    .select(
        F.col("nm.EMPLID"),
        F.col("nm.EFFDT"),
        F.col("nm.EFF_STATUS"),
        F.col("nm.NAME_TYPE"),
        F.col("nm.FIRST_NAME"),
        F.col("nm.FIRST_NAME_SRCH"),
        F.col("nm.LAST_NAME"),
        F.col("nm.LAST_NAME_PREF_NLD"),
        F.col("nm.LAST_NAME_SRCH"),
        F.col("nm.LASTUPDDTTM"),
        F.col("nm.LASTUPDOPRID"),
        F.col("nm.MIDDLE_NAME"),
        F.col("nm.NAME"),
        F.col("nm.NAME_AC"),
        F.col("nm.NAME_DISPLAY"),
        F.col("nm.NAME_DISPLAY_SRCH"),
        F.col("nm.NAME_FORMAL"),
        F.col("nm.NAME_INITIALS"),
        F.col("nm.NAME_PREFIX"),
        F.col("nm.NAME_ROYAL_PREFIX"),
        F.col("nm.NAME_ROYAL_SUFFIX"),
        F.col("nm.NAME_SUFFIX"),
        F.col("nm.NAME_TITLE"),
        F.col("nm.PARTNER_LAST_NAME"),
        F.col("nm.PARTNER_ROY_PREFIX"),
        F.col("nm.PREF_FIRST_NAME"),
        F.col("nm.SECOND_LAST_NAME"),
        F.col("nm.SECOND_LAST_SRCH"),
        F.col("nm.COUNTRY_NM_FORMAT"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 20 — Join Names to Enrollment Result
# Logic  : INNER JOIN — only retain students who have a primary name record.
# =============================================================================

df_with_names = (
    df_ipeds_ethnicity.alias("eth")
    # Inner join: must have a primary name record
    .join(
        df_primary_names.alias("pn"),
        F.col("eth.EMPLID") == F.col("pn.EMPLID"),
        "inner",
    )
    .select(
        F.col("eth.MIN_ONE_ONLINE_COURSE_FLG"),
        F.col("eth.EMPLID"),
        F.col("eth.ENROLLED_WITHIN_12_MONTHS"),
        F.col("eth.AGE_GROUP"),
        F.col("eth.IPEDS_STATE"),
        F.col("eth.ACAD_CAREER"),
        F.col("eth.ACAD_PROGRAM"),
        F.col("eth.MAJOR1_DEPT"),
        F.col("eth.MAJOR2_DEPT"),
        F.col("eth.MINOR1_DEPT"),
        F.col("eth.STRM"),
        F.col("eth.ACAD_LEVEL_EOT_CD"),
        F.col("eth.ACAD_LEVEL_EOT_DESCR"),
        F.translate(F.col("pn.FIRST_NAME"), "?", "n").alias("FIRST_NAME"),
        F.translate(F.col("pn.LAST_NAME"), "?", "n").alias("LAST_NAME"),
        F.translate(F.col("pn.MIDDLE_NAME"), "?", "n").alias("MIDDLE_NAME"),
        F.col("eth.BIRTH_DT"),
        F.col("eth.Age"),
        F.col("eth.COHORT_ENTRY"),
        F.col("eth.GENDER"),
        F.col("eth.ADDRESS"),
        F.col("eth.HOME_ADDR_CITY"),
        F.col("eth.HOME_ADDR_STATE"),
        F.col("eth.HOME_ADDR_POSTAL"),
        F.col("eth.HOME_ADDR_COUNTRY"),
        F.col("eth.HOME_ADDR_COUNTY"),
        F.col("eth.ETHN_GRP"),
        F.col("eth.MAJOR1_PLAN"),
        F.col("eth.MAJOR1_CIP_CD"),
        F.col("eth.MAJOR2_PLAN"),
        F.col("eth.MAJOR2_CIP_CD"),
        F.col("eth.MINOR1_PLAN"),
        F.col("eth.MINOR1_CIP_CD"),
        F.col("eth.COURSE_ID"),
        F.col("eth.CATALOG_NBR"),
        F.col("eth.SUBJECT"),
        F.col("eth.INSTRUCTION_MODE"),
        F.col("eth.CLASS_START_DT"),
        F.col("eth.CLASS_END_DT"),
        F.col("eth.CLASS_SECTION"),
        F.col("eth.INSTRUCTION_MODE_DESCR"),
        F.col("eth.ENRL_ADD_DT"),
        F.col("eth.SESSION_CD"),
        F.col("eth.UNIT_TAKEN"),
        F.col("eth.ADMIT_TERM"),
        F.col("eth.RESIDENCY"),
        F.col("eth.IPEDS_FULL_PART_TIME_FLG"),
        F.col("eth.IPEDS_SCH"),
        F.col("eth.IPEDS_DISTANCE_EDUCATION_STATUS"),
        F.col("eth.IPEDS_FIPS_CD"),
        F.col("eth.CLASS_NBR"),
        F.col("eth.SNAPSHOT_DT"),
        F.col("eth.IPEDS_ETHNICITY"),
        F.col("eth.TERM_DESCR"),
        F.col("eth.ACAD_YEAR"),
        F.col("eth.CIP_CD_DESCR"),
        F.col("eth.ACAD_PROGRAM_DESCR"),
        F.col("eth.ACAD_CAREER_DESCR"),
        F.col("eth.INIT_TERM"),
        F.col("eth.DEPT"),
        F.col("eth.COLLEGE"),
        F.col("eth.COLLEGE_DESCR"),
        F.col("eth.DEPT_DESCR"),
        F.col("eth.TUITION_RESIDENCY_DESCR"),
        F.col("eth.IPEDS_CITY"),
        F.col("eth.IPEDS_COUNTY"),
        F.col("eth.IPEDS_COUNTY_CODE"),
        F.col("eth.IPEDS_POSTAL"),
        F.col("eth.IPEDS_ADDR"),
        F.col("eth.IPEDS_COUNTRY"),
        F.col("eth.TUITION_RES"),
        F.col("eth.RESIDENCY_DESCR"),
    )
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 21 — High School Graduation Date (External Degree)
# Logic  : Find the latest high-school-level degree completion date per student.
#          Includes records where the career is 'HS', the description contains
#          'High School' or starts with 'HS', or the degree code is a
#          high-school-equivalent degree. Used for ENROLLED_WITHIN_12_MONTHS.
# =============================================================================
df_hs_graduation = (
    read_table(f"{student}.{bronze}.ps_ext_degree")
    .alias("ext_deg")
    # Filter: HS-level degree records that are complete and sourced from a school
    .filter(
        (
            (F.col("ext_deg.EXT_CAREER") == F.lit("HS"))
            | F.col("ext_deg.DESCR").like("%High School%")
            | F.col("ext_deg.DESCR").like("HS%")
            | F.col("ext_deg.DEGREE").isin(
                [
                    "DR",
                    "DA",
                    "DD",
                    "DFE",
                    "DFN",
                    "DIBO",
                    "DIBT",
                    "DLA",
                    "DN",
                    "DO",
                    "DR",
                    "DX",
                ]
            )
        )
        & (F.col("ext_deg.DEGREE_STATUS") == F.lit("C"))
        & (F.col("ext_deg.LS_DATA_SOURCE") == F.lit("SCH"))
    )
    # Latest HS graduation date per student
    .groupBy(F.col("ext_deg.EMPLID"))
    .agg(F.max(F.col("ext_deg.DEGREE_DT")).alias("DEGREE_DT"))
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 22 — Enrolled Within 12 Months of HS Graduation
# Logic  : Determine if a student enrolled within 12 months of their HS
#          graduation. Uses the DATEDIFF between HS graduation and term start:
#          - NULL DEGREE_DT or NULL TERM_BEGIN_DT → NULL (unknown)
#          - > 1 year (365.25 days) between graduation and term start → 0 (No)
#          - ≤ 1 year → 1 (Yes)
#          Also enriches with full term dimension fields for downstream use.
# =============================================================================
df_enrolled_within_12mo = (
    df_with_names.alias("enrl_wn")
    # Inner join to term dimension to get TERM_BEGIN_DT for the 12-month calculation
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_full"),
        (
            (F.col("enrl_wn.ACAD_CAREER") == F.col("term_full.ACAD_CAREER"))
            & (F.col("enrl_wn.STRM") == F.col("term_full.STRM"))
        ),
        "inner",
    )
    # Left join HS graduation — students without an HS record get NULL
    .join(
        df_hs_graduation.alias("hs_grad"),
        F.col("enrl_wn.EMPLID") == F.col("hs_grad.EMPLID"),
        "left",
    )
    .select(
        F.col("enrl_wn.MIN_ONE_ONLINE_COURSE_FLG"),
        F.col("enrl_wn.EMPLID"),
        # Enrolled within 12 months calculation
        F.when(F.col("hs_grad.DEGREE_DT").isNull(), F.lit(None).cast("integer"))
        .when(F.col("term_full.TERM_BEGIN_DT").isNull(), F.lit(None).cast("integer"))
        .when(
            (
                F.datediff(
                    F.col("term_full.TERM_BEGIN_DT").cast("date"),
                    F.col("hs_grad.DEGREE_DT").cast("date"),
                )
                / F.lit(365.25)
            )
            > F.lit(1.0),
            F.lit(0),
        )
        .otherwise(F.lit(1))
        .alias("ENROLLED_WITHIN_12_MONTHS"),
        F.col("enrl_wn.AGE_GROUP"),
        F.col("enrl_wn.IPEDS_STATE"),
        F.col("enrl_wn.ACAD_CAREER"),
        F.col("enrl_wn.ACAD_PROGRAM"),
        F.col("enrl_wn.MAJOR1_DEPT"),
        F.col("enrl_wn.MAJOR2_DEPT"),
        F.col("enrl_wn.MINOR1_DEPT"),
        F.col("enrl_wn.STRM"),
        F.col("enrl_wn.ACAD_LEVEL_EOT_CD"),
        F.col("enrl_wn.ACAD_LEVEL_EOT_DESCR"),
        F.col("enrl_wn.FIRST_NAME"),
        F.col("enrl_wn.LAST_NAME"),
        F.col("enrl_wn.MIDDLE_NAME"),
        F.col("enrl_wn.BIRTH_DT"),
        F.col("enrl_wn.Age"),
        F.col("enrl_wn.COHORT_ENTRY"),
        F.col("enrl_wn.GENDER"),
        F.col("enrl_wn.ADDRESS"),
        F.col("enrl_wn.HOME_ADDR_CITY"),
        F.col("enrl_wn.HOME_ADDR_STATE"),
        F.col("enrl_wn.HOME_ADDR_POSTAL"),
        F.col("enrl_wn.HOME_ADDR_COUNTRY"),
        F.col("enrl_wn.HOME_ADDR_COUNTY"),
        F.col("enrl_wn.ETHN_GRP"),
        F.col("enrl_wn.MAJOR1_PLAN"),
        F.col("enrl_wn.MAJOR1_CIP_CD"),
        F.col("enrl_wn.MAJOR2_PLAN"),
        F.col("enrl_wn.MAJOR2_CIP_CD"),
        F.col("enrl_wn.MINOR1_PLAN"),
        F.col("enrl_wn.MINOR1_CIP_CD"),
        F.col("enrl_wn.COURSE_ID"),
        F.col("enrl_wn.CATALOG_NBR"),
        F.col("enrl_wn.SUBJECT"),
        F.col("enrl_wn.INSTRUCTION_MODE"),
        F.col("enrl_wn.CLASS_START_DT"),
        F.col("enrl_wn.CLASS_END_DT"),
        F.col("enrl_wn.CLASS_SECTION"),
        F.col("enrl_wn.INSTRUCTION_MODE_DESCR"),
        F.col("enrl_wn.ENRL_ADD_DT"),
        F.col("enrl_wn.SESSION_CD"),
        F.col("enrl_wn.UNIT_TAKEN"),
        F.col("enrl_wn.ADMIT_TERM"),
        F.col("enrl_wn.RESIDENCY"),
        F.col("enrl_wn.IPEDS_FULL_PART_TIME_FLG"),
        F.col("enrl_wn.IPEDS_SCH"),
        F.col("enrl_wn.IPEDS_DISTANCE_EDUCATION_STATUS"),
        F.col("enrl_wn.IPEDS_FIPS_CD"),
        F.col("enrl_wn.CLASS_NBR"),
        F.col("enrl_wn.SNAPSHOT_DT"),
        F.col("enrl_wn.IPEDS_ETHNICITY"),
        F.col("enrl_wn.TERM_DESCR"),
        F.col("enrl_wn.ACAD_YEAR"),
        F.col("enrl_wn.CIP_CD_DESCR"),
        F.col("enrl_wn.ACAD_PROGRAM_DESCR"),
        F.col("enrl_wn.ACAD_CAREER_DESCR"),
        F.col("enrl_wn.INIT_TERM"),
        F.col("enrl_wn.DEPT"),
        F.col("enrl_wn.COLLEGE"),
        F.col("enrl_wn.COLLEGE_DESCR"),
        F.col("enrl_wn.DEPT_DESCR"),
        F.col("enrl_wn.TUITION_RESIDENCY_DESCR"),
        F.col("enrl_wn.IPEDS_CITY"),
        F.col("enrl_wn.IPEDS_COUNTY"),
        F.col("enrl_wn.IPEDS_COUNTY_CODE"),
        F.col("enrl_wn.IPEDS_POSTAL"),
        # Include full term fields for downstream term dimension enrichment
        F.col("term_full.INSTITUTION"),
        F.col("term_full.DESCR"),
        F.col("term_full.SHORT_DESCR"),
        F.col("term_full.TERM_BEGIN_DT"),
        F.col("term_full.TERM_END_DT"),
        F.col("term_full.SESSION_DESCR"),
        F.col("term_full.SESSION_SHORT_DESCR"),
        F.col("term_full.WEEKS_OF_INSTRN"),
        F.col("term_full.TERM_CATEGORY_CD"),
        F.col("term_full.TERM_CATEGORY_DESCR"),
        F.col("term_full.TERM_CATEGORY_SHORT_DESCR"),
        F.col("term_full.HOLIDAY_SCHEDULE"),
        F.col("term_full.SIXTY_PERCENT_DT"),
        # F.col("term_full.UPDATED_DT"),
        # F.col("term_full.UPDATED_USER"),
        F.col("term_full.TERM_SK"),
        F.col("term_full.CENSUS_DT"),
        F.col("hs_grad.DEGREE_DT"),
        F.col("enrl_wn.IPEDS_ADDR"),
        F.col("enrl_wn.IPEDS_COUNTRY"),
        F.col("enrl_wn.TUITION_RES"),
        F.col("enrl_wn.RESIDENCY_DESCR"),
    )
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 23 — Historical Enrollment Data for Retention Comparison
# Logic  : Union of:
#   (1) 2017 December snapshot — for long-range retention comparisons
#   (2) IPEDS fall enrollment history — prior year fall enrollment data
#   Only the columns needed for the RETENTION_FLG join (EMPLID + STRM).
# =============================================================================

# Define the common set of columns for the union
_hist_cols = [
    "EMPLID",
    "ACAD_CAREER",
    "MAJOR1_DEPT",
    "MAJOR2_DEPT",
    "MINOR1_DEPT",
    "STRM",
    "FIRST_NAME",
    "LAST_NAME",
    "MIDDLE_NAME",
    "GENDER",
    "MAJOR1_PLAN",
    "MAJOR2_PLAN",
    "MINOR1_PLAN",
    "COURSE_ID",
    "CATALOG_NBR",
    "INSTRUCTION_MODE",
    "INSTRUCTION_MODE_DESCR",
    "ENRL_ADD_DT",
    "ADMIT_TERM",
    "RESIDENCY",
    "CLASS_NBR",
]

# 2017 December 14 snapshot
df_historical_2017 = (
    read_table(f"{analytics}.{archive}.uta_ipeds_data_2017")
    .alias("hist2017")
    .filter(
        F.col("hist2017.SNAPSHOTDATE").cast("date") == F.lit("2017-12-14").cast("date")
    )
    .select([F.col(f"hist2017.{c}") for c in _hist_cols])
)

# Fall enrollment history (prior year data)
df_historical_fall_enrl = (
    read_table(f"{analytics}.{archive}.ipeds_fall_enrl_hist")
    .alias("fall_hist")
    .select([F.col(f"fall_hist.{c}") for c in _hist_cols])
)

# Union both historical datasets — used to check if student was enrolled in prev_year
df_historical_enrollment = df_historical_2017.union(df_historical_fall_enrl)

# COMMAND ----------

# =============================================================================
# STEP 24 — Retention Flag
# Logic  : A student receives RETENTION_FLG = 1 if they appear in the historical
#          enrollment data for the previous year (STRM = prev_year) AND the
#          current record is for the reporting term (STRM = term).
#          This is a LEFT JOIN — students not in prior year get RETENTION_FLG = 0.
# =============================================================================

df_with_retention_flag = (
    df_enrolled_within_12mo.alias("curr")
    # Left join: match current-term students against prior-year enrollment history
    .join(
        df_historical_enrollment.alias("hist"),
        (
            (F.col("curr.EMPLID") == F.col("hist.EMPLID"))
            & (F.col("curr.STRM") == F.lit(term))
            & ( 
                F.col("hist.STRM") == F.lit(prev_year)
            )  
        ),
        "left",
    )
    .select(
        F.col("curr.MIN_ONE_ONLINE_COURSE_FLG"),
        F.col("curr.EMPLID"),
        F.col("curr.ENROLLED_WITHIN_12_MONTHS"),
        F.col("curr.AGE_GROUP"),
        F.col("curr.IPEDS_STATE"),
        F.col("curr.ACAD_CAREER"),
        F.col("curr.ACAD_PROGRAM"),
        F.col("curr.MAJOR1_DEPT"),
        F.col("curr.MAJOR2_DEPT"),
        F.col("curr.MINOR1_DEPT"),
        F.col("curr.STRM"),
        F.col("curr.ACAD_LEVEL_EOT_CD"),
        F.col("curr.ACAD_LEVEL_EOT_DESCR"),
        F.col("curr.FIRST_NAME"),
        F.col("curr.LAST_NAME"),
        F.col("curr.MIDDLE_NAME"),
        F.col("curr.BIRTH_DT"),
        F.col("curr.Age"),
        F.col("curr.COHORT_ENTRY"),
        F.col("curr.GENDER"),
        F.col("curr.ADDRESS"),
        F.col("curr.HOME_ADDR_CITY"),
        F.col("curr.HOME_ADDR_STATE"),
        F.col("curr.HOME_ADDR_POSTAL"),
        F.col("curr.HOME_ADDR_COUNTRY"),
        F.col("curr.HOME_ADDR_COUNTY"),
        F.col("curr.ETHN_GRP"),
        F.col("curr.MAJOR1_PLAN"),
        F.col("curr.MAJOR1_CIP_CD"),
        F.col("curr.MAJOR2_PLAN"),
        F.col("curr.MAJOR2_CIP_CD"),
        F.col("curr.MINOR1_PLAN"),
        F.col("curr.MINOR1_CIP_CD"),
        F.col("curr.COURSE_ID"),
        F.col("curr.CATALOG_NBR"),
        F.col("curr.SUBJECT"),
        F.col("curr.INSTRUCTION_MODE"),
        F.col("curr.CLASS_START_DT"),
        F.col("curr.CLASS_END_DT"),
        F.col("curr.CLASS_SECTION"),
        F.col("curr.INSTRUCTION_MODE_DESCR"),
        F.col("curr.ENRL_ADD_DT"),
        F.col("curr.SESSION_CD"),
        F.col("curr.UNIT_TAKEN"),
        F.col("curr.ADMIT_TERM"),
        F.col("curr.RESIDENCY"),
        F.col("curr.IPEDS_FULL_PART_TIME_FLG"),
        F.col("curr.IPEDS_SCH"),
        F.col("curr.IPEDS_DISTANCE_EDUCATION_STATUS"),
        F.col("curr.IPEDS_FIPS_CD"),
        F.col("curr.CLASS_NBR"),
        F.col("curr.SNAPSHOT_DT"),
        F.col("curr.IPEDS_ETHNICITY"),
        F.col("curr.TERM_DESCR"),
        F.col("curr.ACAD_YEAR"),
        F.col("curr.CIP_CD_DESCR"),
        F.col("curr.ACAD_PROGRAM_DESCR"),
        F.col("curr.ACAD_CAREER_DESCR"),
        F.col("curr.INIT_TERM"),
        F.col("curr.DEPT"),
        F.col("curr.COLLEGE"),
        F.col("curr.COLLEGE_DESCR"),
        F.col("curr.DEPT_DESCR"),
        F.col("curr.TUITION_RESIDENCY_DESCR"),
        F.col("curr.IPEDS_CITY"),
        F.col("curr.IPEDS_COUNTY"),
        F.col("curr.IPEDS_COUNTY_CODE"),
        F.col("curr.IPEDS_POSTAL"),
        F.col("curr.INSTITUTION"),
        F.col("curr.DESCR"),
        F.col("curr.SHORT_DESCR"),
        F.col("curr.TERM_BEGIN_DT"),
        F.col("curr.TERM_END_DT"),
        F.col("curr.SESSION_DESCR"),
        F.col("curr.SESSION_SHORT_DESCR"),
        F.col("curr.WEEKS_OF_INSTRN"),
        F.col("curr.TERM_CATEGORY_CD"),
        F.col("curr.TERM_CATEGORY_DESCR"),
        F.col("curr.TERM_CATEGORY_SHORT_DESCR"),
        F.col("curr.HOLIDAY_SCHEDULE"),
        F.col("curr.SIXTY_PERCENT_DT"),
        # F.col("curr.UPDATED_DT"),
        # F.col("curr.UPDATED_USER"),
        F.col("curr.TERM_SK"),
        F.col("curr.CENSUS_DT"),
        F.col("curr.DEGREE_DT"),
        # Retention flag: 1 if student was enrolled in prior year, 0 otherwise
        F.when(F.col("hist.EMPLID").isNotNull(), F.lit(1))
        .otherwise(F.lit(0))
        .alias("RETENTION_FLG"),
        F.col("curr.IPEDS_ADDR"),
        F.col("curr.IPEDS_COUNTRY"),
        F.col("curr.TUITION_RES"),
        F.col("curr.RESIDENCY_DESCR"),
    )
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 25 — Summer Cohort Adjustment
# Logic  : If a student appears in both the current term (STRM = term) AND in
#          the summer term (STRM = summerterm) with the same career, use the
#          summer cohort entry value as the adjusted cohort for the fall term.
#          This ensures summer starters are correctly classified.
# =============================================================================

df_summer_cohort_adjustment = (
    df_with_retention_flag.alias("fall_term")
    # Self-join: match fall-term students against their own summer-term records
    .join(
        df_with_retention_flag.alias("summer_term"),
        on=(
            (F.col("fall_term.STRM") == F.lit(term))
            & (F.col("summer_term.STRM") == F.lit(summerterm))  # current fall term
            & (F.col("fall_term.EMPLID") == F.col("summer_term.EMPLID"))  # summer term
            & (F.col("fall_term.ACAD_CAREER") == F.col("summer_term.ACAD_CAREER"))
        ),
        how="inner",
    )
    # Keep only EMPLID, STRM, and the summer cohort entry as the adjusted value
    .select(
        F.col("fall_term.EMPLID"),
        F.col("fall_term.STRM"),
        F.col("summer_term.COHORT_ENTRY").alias("Adjusted_Cohort"),
    ).distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 26 — Apply Adjusted Summer Cohort
# Logic  : Use the summer cohort value if available; otherwise, keep the
#          original COHORT_ENTRY. 
# =============================================================================

df_adjusted_cohort = (
    df_with_retention_flag.alias("ret")
    # Left join: only fall-term students may have an adjustment
    .join(
        df_summer_cohort_adjustment.alias("sum_adj"),
        F.col("ret.EMPLID") == F.col("sum_adj.EMPLID"),
        "left",
    ).select(
        F.col("ret.MIN_ONE_ONLINE_COURSE_FLG"),
        F.col("ret.EMPLID"),
        F.col("ret.ENROLLED_WITHIN_12_MONTHS"),
        F.col("ret.AGE_GROUP"),
        F.col("ret.IPEDS_STATE"),
        F.col("ret.ACAD_CAREER"),
        F.col("ret.ACAD_PROGRAM"),
        F.col("ret.MAJOR1_DEPT"),
        F.col("ret.MAJOR2_DEPT"),
        F.col("ret.MINOR1_DEPT"),
        F.col("ret.STRM"),
        F.col("ret.ACAD_LEVEL_EOT_CD"),
        F.col("ret.ACAD_LEVEL_EOT_DESCR"),
        F.col("ret.FIRST_NAME"),
        F.col("ret.LAST_NAME"),
        F.col("ret.MIDDLE_NAME"),
        F.col("ret.BIRTH_DT"),
        F.col("ret.Age"),
        F.coalesce(F.col("sum_adj.Adjusted_Cohort"), F.col("ret.COHORT_ENTRY")).alias(
            "COHORT_ENTRY"
        ),
        F.col("ret.GENDER"),
        F.col("ret.ADDRESS"),
        F.col("ret.HOME_ADDR_CITY"),
        F.col("ret.HOME_ADDR_STATE"),
        F.col("ret.HOME_ADDR_POSTAL"),
        F.col("ret.HOME_ADDR_COUNTRY"),
        F.col("ret.HOME_ADDR_COUNTY"),
        F.col("ret.ETHN_GRP"),
        F.col("ret.MAJOR1_PLAN"),
        F.col("ret.MAJOR1_CIP_CD"),
        F.col("ret.MAJOR2_PLAN"),
        F.col("ret.MAJOR2_CIP_CD"),
        F.col("ret.MINOR1_PLAN"),
        F.col("ret.MINOR1_CIP_CD"),
        F.col("ret.COURSE_ID"),
        F.col("ret.CATALOG_NBR"),
        F.col("ret.SUBJECT"),
        F.col("ret.INSTRUCTION_MODE"),
        F.col("ret.CLASS_START_DT"),
        F.col("ret.CLASS_END_DT"),
        F.col("ret.CLASS_SECTION"),
        F.col("ret.INSTRUCTION_MODE_DESCR"),
        F.col("ret.ENRL_ADD_DT"),
        F.col("ret.SESSION_CD"),
        F.col("ret.UNIT_TAKEN"),
        F.col("ret.ADMIT_TERM"),
        F.col("ret.RESIDENCY"),
        F.col("ret.IPEDS_FULL_PART_TIME_FLG"),
        F.col("ret.IPEDS_SCH"),
        F.col("ret.IPEDS_DISTANCE_EDUCATION_STATUS"),
        F.col("ret.IPEDS_FIPS_CD"),
        F.col("ret.CLASS_NBR"),
        F.col("ret.SNAPSHOT_DT"),
        F.col("ret.IPEDS_ETHNICITY"),
        F.col("ret.TERM_DESCR"),
        F.col("ret.ACAD_YEAR"),
        F.col("ret.CIP_CD_DESCR"),
        F.col("ret.ACAD_PROGRAM_DESCR"),
        F.col("ret.ACAD_CAREER_DESCR"),
        F.col("ret.INIT_TERM"),
        F.col("ret.DEPT"),
        F.col("ret.COLLEGE"),
        F.col("ret.COLLEGE_DESCR"),
        F.col("ret.DEPT_DESCR"),
        F.col("ret.TUITION_RESIDENCY_DESCR"),
        F.col("ret.IPEDS_CITY"),
        F.col("ret.IPEDS_COUNTY"),
        F.col("ret.IPEDS_COUNTY_CODE"),
        F.col("ret.IPEDS_POSTAL"),
        F.col("ret.INSTITUTION"),
        F.col("ret.DESCR"),
        F.col("ret.SHORT_DESCR"),
        F.col("ret.TERM_BEGIN_DT"),
        F.col("ret.TERM_END_DT"),
        F.col("ret.SESSION_DESCR"),
        F.col("ret.SESSION_SHORT_DESCR"),
        F.col("ret.WEEKS_OF_INSTRN"),
        F.col("ret.TERM_CATEGORY_CD"),
        F.col("ret.TERM_CATEGORY_DESCR"),
        F.col("ret.TERM_CATEGORY_SHORT_DESCR"),
        F.col("ret.HOLIDAY_SCHEDULE"),
        F.col("ret.SIXTY_PERCENT_DT"),
        # F.col("ret.UPDATED_DT"),
        # F.col("ret.UPDATED_USER"),
        F.col("ret.TERM_SK"),
        F.col("ret.CENSUS_DT"),
        F.col("ret.DEGREE_DT"),
        F.col("ret.RETENTION_FLG"),
        F.col("ret.IPEDS_ADDR"),
        F.col("ret.IPEDS_COUNTRY"),
        F.col("ret.TUITION_RES"),
        F.lit(None).cast("string").alias("RESIDENCY_DESCR"),  
    )
)

# COMMAND ----------

# =============================================================================
# STEP 27 — First Enrolled Term per Student/Career/Program
# Logic  : For each student/career/program combination, find the term in which
#          they first enrolled (minimum TERM_SK where STUDENT_ENRL_FLG = 'Y').
#          Used to determine if a student is 'New' or 'Continuing' for the
#          STUDENTRETENTIONCATEGORY field.
# =============================================================================

_win_by_stu_career_prog = Window.partitionBy(
    "fet.EMPLID", "fet.ACAD_CAREER_SK", "fet.ACAD_PROGRAM_PRIMARY"
)

df_first_enrolled_term = (
    read_table(f"{analytics}.{staging}.fact_thecb_irp_enrollment")
    .alias("fet")
    # Term dimension for STRM code
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_term").alias("td"),
        F.col("fet.TERM_SK") == F.col("td.TERM_SK"),
        "inner",
    )
    # Academic program dimension for ACAD_PROGRAM code
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_academic_program").alias("pd"),
        F.col("fet.ACAD_PROGRAM_PRIMARY") == F.col("pd.ACAD_PROGRAM_SK"),
        "inner",
    )
    # Academic career dimension
    .join(
        read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias("cd"),
        F.col("fet.ACAD_CAREER_SK") == F.col("cd.ACAD_CAREER_SK"),
        "left",
    )
    # Only enrolled terms
    .filter(F.col("fet.STUDENT_ENRL_FLG") == F.lit("Y"))
    # Find minimum term (first enrolled term) per student/career/program
    .withColumn(
        "_min_term_sk", F.min(F.col("fet.TERM_SK")).over(_win_by_stu_career_prog)
    )
    .filter(F.col("fet.TERM_SK") == F.col("_min_term_sk"))
    .drop("_min_term_sk")
    .select(
        F.col("fet.EMPLID"),
        F.col("cd.ACAD_CAREER"),
        F.col("pd.ACAD_PROGRAM"),
        F.col("td.STRM"),
        F.col("fet.ACAD_PROGRAM_PRIMARY"),
    )
    .distinct()
)

# COMMAND ----------

# =============================================================================
# STEP 28 — Final Output: Student Retention Category + Ethnicity Descriptions
# Logic  :
#   STUDENTRETENTIONCATEGORY:
#     'New'        — current STRM matches student's first enrolled STRM, OR
#                    student's first STRM was the corresponding summer term
#     'Continuing' — all other cases
# =============================================================================

df_final_enriched = (
    df_adjusted_cohort.alias("adj")
    # Left join first-enrolled term for New/Continuing classification
    .join(
        df_first_enrolled_term.alias("fet"),
        (
            (F.col("adj.EMPLID") == F.col("fet.EMPLID"))
            & (F.col("adj.ACAD_CAREER") == F.col("fet.ACAD_CAREER"))
            & (F.col("adj.ACAD_PROGRAM") == F.col("fet.ACAD_PROGRAM"))
        ),
        "left",
    ).select(
        F.col("adj.MIN_ONE_ONLINE_COURSE_FLG"),
        F.col("adj.EMPLID"),
        F.col("adj.ENROLLED_WITHIN_12_MONTHS"),
        F.col("adj.AGE_GROUP"),
        F.col("adj.IPEDS_STATE"),
        F.col("adj.ACAD_CAREER"),
        F.col("adj.ACAD_PROGRAM"),
        F.col("adj.MAJOR1_DEPT"),
        F.col("adj.MAJOR2_DEPT"),
        F.col("adj.MINOR1_DEPT"),
        F.col("adj.STRM"),
        F.col("adj.ACAD_LEVEL_EOT_CD"),
        F.col("adj.ACAD_LEVEL_EOT_DESCR"),
        F.col("adj.FIRST_NAME"),
        F.col("adj.LAST_NAME"),
        F.col("adj.MIDDLE_NAME"),
        F.col("adj.BIRTH_DT"),
        F.col("adj.Age"),
        F.col("adj.COHORT_ENTRY"),
        F.col("adj.GENDER"),
        F.col("adj.ADDRESS"),
        F.col("adj.HOME_ADDR_CITY"),
        F.col("adj.HOME_ADDR_STATE"),
        F.col("adj.HOME_ADDR_POSTAL"),
        F.col("adj.HOME_ADDR_COUNTRY"),
        F.col("adj.HOME_ADDR_COUNTY"),
        F.col("adj.ETHN_GRP"),
        F.col("adj.MAJOR1_PLAN"),
        F.col("adj.MAJOR1_CIP_CD"),
        F.col("adj.MAJOR2_PLAN"),
        F.col("adj.MAJOR2_CIP_CD"),
        F.col("adj.MINOR1_PLAN"),
        F.col("adj.MINOR1_CIP_CD"),
        F.col("adj.COURSE_ID"),
        F.col("adj.CATALOG_NBR"),
        F.col("adj.SUBJECT"),
        F.col("adj.INSTRUCTION_MODE"),
        F.col("adj.CLASS_START_DT"),
        F.col("adj.CLASS_END_DT"),
        F.col("adj.CLASS_SECTION"),
        F.col("adj.INSTRUCTION_MODE_DESCR"),
        F.col("adj.ENRL_ADD_DT"),
        F.col("adj.SESSION_CD"),
        F.col("adj.UNIT_TAKEN"),
        F.col("adj.ADMIT_TERM"),
        F.col("adj.RESIDENCY"),
        F.col("adj.IPEDS_FULL_PART_TIME_FLG"),
        F.col("adj.IPEDS_SCH"),
        F.col("adj.IPEDS_DISTANCE_EDUCATION_STATUS"),
        F.col("adj.IPEDS_FIPS_CD"),
        F.col("adj.CLASS_NBR"),
        F.col("adj.SNAPSHOT_DT"),
        F.col("adj.IPEDS_ETHNICITY"),
        F.col("adj.TERM_DESCR"),
        F.col("adj.ACAD_YEAR"),
        F.col("adj.CIP_CD_DESCR"),
        F.col("adj.ACAD_PROGRAM_DESCR"),
        F.col("adj.ACAD_CAREER_DESCR"),
        F.col("adj.INIT_TERM"),
        F.col("adj.DEPT"),
        F.col("adj.COLLEGE"),
        F.col("adj.COLLEGE_DESCR"),
        F.col("adj.DEPT_DESCR"),
        F.col("adj.TUITION_RESIDENCY_DESCR"),
        F.col("adj.IPEDS_CITY"),
        F.col("adj.IPEDS_COUNTY"),
        F.col("adj.IPEDS_COUNTY_CODE"),
        F.col("adj.IPEDS_POSTAL"),
        F.col("adj.INSTITUTION"),
        F.col("adj.DESCR"),
        F.col("adj.SHORT_DESCR"),
        F.col("adj.TERM_BEGIN_DT"),
        F.col("adj.TERM_END_DT"),
        F.col("adj.SESSION_DESCR"),
        F.col("adj.SESSION_SHORT_DESCR"),
        F.col("adj.WEEKS_OF_INSTRN"),
        F.col("adj.TERM_CATEGORY_CD"),
        F.col("adj.TERM_CATEGORY_DESCR"),
        F.col("adj.TERM_CATEGORY_SHORT_DESCR"),
        F.col("adj.HOLIDAY_SCHEDULE"),
        F.col("adj.SIXTY_PERCENT_DT"),
        # F.col("adj.UPDATED_DT"),
        # F.col("adj.UPDATED_USER"),
        F.col("adj.TERM_SK"),
        F.col("adj.CENSUS_DT"),
        F.col("adj.DEGREE_DT"),
        F.col("adj.RETENTION_FLG"),
        F.col("adj.IPEDS_ADDR"),
        F.col("adj.IPEDS_COUNTRY"),
        F.col("adj.TUITION_RES"),
        F.when(
            (F.col("adj.STRM") == F.coalesce(F.col("fet.STRM"), F.lit(" ")))
            | (
                F.col("fet.STRM")
                == F.when(
                    F.substring(F.col("adj.STRM"), 4, 1) == F.lit("8"),
                    F.concat(F.substring(F.col("adj.STRM"), 1, 3), F.lit("5")),
                ).otherwise(F.lit(""))
            ),
            F.lit("New"),
        )
        .otherwise(F.lit("Continuing"))
        .alias("STUDENTRETENTIONCATEGORY"),
        F.when(
            F.substring(F.col("adj.STRM"), 4, 1) == F.lit("8"),
            F.concat(F.substring(F.col("adj.STRM"), 1, 3), F.lit("5")),
        )
        .otherwise(F.lit(""))
        .alias("strm2"),
        # IPEDS ethnicity description 
        F.when(F.col("adj.IPEDS_ETHNICITY") == F.lit("ASIAN"), F.lit("Asian"))
        .when(
            F.col("adj.IPEDS_ETHNICITY") == F.lit("HISPANIC"),
            F.lit("Hispanic or Latino"),
        )
        .when(F.col("adj.IPEDS_ETHNICITY") == F.lit("WHITE"), F.lit("White"))
        .when(F.col("adj.IPEDS_ETHNICITY") == F.lit("MULTIPLE"), F.lit("Multiple"))
        .when(
            F.col("adj.IPEDS_ETHNICITY") == F.lit("NSPEC"),
            F.lit("Race/ethnicity unknown"),
        )
        .when(
            F.col("adj.IPEDS_ETHNICITY") == F.lit("BLACK"),
            F.lit("Black or African American"),
        )
        .when(F.col("adj.IPEDS_ETHNICITY") == F.lit("FORGN"), F.lit("U.S. Nonresident"))
        .when(
            F.col("adj.IPEDS_ETHNICITY") == F.lit("AMIND"),
            F.lit("American Indian or Alaska Native"),
        )
        .when(
            F.col("adj.IPEDS_ETHNICITY") == F.lit("PACIF"),
            F.lit("Native Hawaiian or Other Pacific Islander"),
        )
        .otherwise(F.lit(""))
        .alias("IPEDS_ETHNICITY_DESCR"),
        # Overall ethnicity group description
        F.when(F.col("adj.ETHN_GRP") == F.lit("ASIAN"), F.lit("Asian"))
        .when(F.col("adj.ETHN_GRP") == F.lit("HISPANIC"), F.lit("Hispanic or Latino"))
        .when(F.col("adj.ETHN_GRP") == F.lit("WHITE"), F.lit("White"))
        .when(F.col("adj.ETHN_GRP") == F.lit("MULTIPLE"), F.lit("Multiple"))
        .when(F.col("adj.ETHN_GRP") == F.lit("NSPEC"), F.lit("Race/ethnicity unknown"))
        .when(
            F.col("adj.ETHN_GRP") == F.lit("BLACK"), F.lit("Black or African American")
        )
        .when(F.col("adj.ETHN_GRP") == F.lit("FORGN"), F.lit("U.S. Nonresident"))
        .when(
            F.col("adj.ETHN_GRP") == F.lit("AMIND"),
            F.lit("American Indian or Alaska Native"),
        )
        .when(
            F.col("adj.ETHN_GRP") == F.lit("PACIF"),
            F.lit("Native Hawaiian or Other Pacific Islander"),
        )
        .otherwise(F.lit(""))
        .alias("ETHN_GRP_DESCR"),
        # Zero-credit flag: 1 if the student is enrolled in a zero-credit class
        F.when(F.col("adj.UNIT_TAKEN") == F.lit(0), F.lit(1))
        .otherwise(F.lit(0))
        .alias("ZERO_CREDIT_FLG"),
        F.col("adj.RESIDENCY_DESCR"),
    )
)

# COMMAND ----------

# =============================================================================
# STEP 29 — Final Column Mapping with Type Casts
# Logic  : Apply all column-level type casts, length constraints, and
#          column renames to match the target table schema exactly.
#          HOME_ADDR and IPEDS_ADDR: empty string → NULL per IPEDS requirements.
#          Reporting_Year: computed from CLASS_START_DT (fiscal year logic).
# =============================================================================

df_final_output = df_final_enriched.select(
    # Identity and enrollment metadata
    F.substring(F.col("MIN_ONE_ONLINE_COURSE_FLG"), 1, 1)
    .cast("string")
    .alias("MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("EMPLID").cast("string").alias("EMPLID"),
    F.col("ENROLLED_WITHIN_12_MONTHS")
    .cast(DecimalType(38, 10))
    .alias("ENROLLED_WITHIN_12_MONTHS"),
    F.substring(F.col("AGE_GROUP"), 1, 20).cast("string").alias("AGE_GROUP"),
    F.substring(F.col("IPEDS_STATE"), 1, 6).cast("string").alias("IPEDS_STATE"),
    F.substring(F.col("ACAD_CAREER"), 1, 4).cast("string").alias("ACAD_CAREER"),
    F.substring(F.col("ACAD_PROGRAM"), 1, 5).cast("string").alias("ACAD_PROGRAM"),
    F.substring(F.col("MAJOR1_DEPT"), 1, 10).cast("string").alias("MAJOR1_DEPT"),
    F.substring(F.col("MAJOR2_DEPT"), 1, 10).cast("string").alias("MAJOR2_DEPT"),
    F.substring(F.col("MINOR1_DEPT"), 1, 10).cast("string").alias("MINOR1_DEPT"),
    F.substring(F.col("STRM"), 1, 4).cast("string").alias("STRM"),
    F.substring(F.col("ACAD_LEVEL_EOT_CD"), 1, 3)
    .cast("string")
    .alias("ACAD_LEVEL_EOT_CD"),
    F.substring(F.col("ACAD_LEVEL_EOT_DESCR"), 1, 30)
    .cast("string")
    .alias("ACAD_LEVEL_EOT_DESCR"),
    # Name fields
    F.substring(F.col("FIRST_NAME"), 1, 30).cast("string").alias("FIRST_NAME"),
    F.substring(F.col("LAST_NAME"), 1, 30).cast("string").alias("LAST_NAME"),
    F.substring(F.col("MIDDLE_NAME"), 1, 30).cast("string").alias("MIDDLE_NAME"),
    F.col("BIRTH_DT").cast(TimestampType()).alias("BIRTH_DT"),
    F.col("Age").cast(DecimalType(38, 10)).alias("AGE"),
    F.substring(F.col("COHORT_ENTRY"), 1, 50).cast("string").alias("COHORT_TYPE"),
    F.substring(F.col("GENDER"), 1, 11).cast("string").alias("GENDER"),
    # HOME_ADDR: trim and cap at 55 chars; empty or NULL
    F.when(
        F.col("ADDRESS").isNull() | (F.col("ADDRESS") == F.lit("")),
        F.lit(None).cast("string"),
    )
    .otherwise(F.trim(F.substring(F.col("ADDRESS"), 1, 55)))
    .alias("HOME_ADDR"),
    # Address fields
    F.substring(F.col("HOME_ADDR_CITY"), 1, 30).cast("string").alias("HOME_ADDR_CITY"),
    F.substring(F.col("HOME_ADDR_STATE"), 1, 6).cast("string").alias("HOME_ADDR_STATE"),
    F.substring(F.col("HOME_ADDR_POSTAL"), 1, 12)
    .cast("string")
    .alias("HOME_ADDR_POSTAL"),
    F.substring(F.col("HOME_ADDR_COUNTRY"), 1, 3)
    .cast("string")
    .alias("HOME_ADDR_COUNTRY"),
    F.substring(F.col("HOME_ADDR_COUNTY"), 1, 30)
    .cast("string")
    .alias("HOME_ADDR_COUNTY"),
    F.substring(F.col("ETHN_GRP"), 1, 8).cast("string").alias("ETHN_GRP"),
    # Academic plan fields
    F.substring(F.col("MAJOR1_PLAN"), 1, 10).cast("string").alias("MAJOR1_PLAN"),
    F.substring(F.col("MAJOR1_CIP_CD"), 1, 130).cast("string").alias("MAJOR1_CIP_CD"),
    F.substring(F.col("MAJOR2_PLAN"), 1, 10).cast("string").alias("MAJOR2_PLAN"),
    F.substring(F.col("MAJOR2_CIP_CD"), 1, 130).cast("string").alias("MAJOR2_CIP_CD"),
    F.substring(F.col("MINOR1_PLAN"), 1, 10).cast("string").alias("MINOR1_PLAN"),
    F.substring(F.col("MINOR1_CIP_CD"), 1, 130).cast("string").alias("MINOR1_CIP_CD"),
    # Course and enrollment fields
    F.substring(F.col("COURSE_ID"), 1, 20).cast("string").alias("COURSE_ID"),
    F.substring(F.col("CATALOG_NBR"), 1, 10).cast("string").alias("CATALOG_NBR"),
    F.substring(F.col("SUBJECT"), 1, 8).cast("string").alias("SUBJECT"),
    F.substring(F.col("INSTRUCTION_MODE"), 1, 2)
    .cast("string")
    .alias("INSTRUCTION_MODE"),
    F.col("CLASS_START_DT").cast(TimestampType()).alias("CLASS_START_DT"),
    F.col("CLASS_END_DT").cast(TimestampType()).alias("CLASS_END_DT"),
    F.substring(F.col("CLASS_SECTION"), 1, 4).cast("string").alias("CLASS_SECTION"),
    F.substring(F.col("INSTRUCTION_MODE_DESCR"), 1, 30)
    .cast("string")
    .alias("INSTRUCTION_MODE_DESCR"),
    F.col("ENRL_ADD_DT").cast(TimestampType()).alias("ENRL_ADD_DT"),
    F.substring(F.col("SESSION_CD"), 1, 20).cast("string").alias("SESSION_CD"),
    F.col("UNIT_TAKEN").cast(DecimalType(38, 10)).alias("UNIT_TAKEN"),
    F.substring(F.col("ADMIT_TERM"), 1, 4).cast("string").alias("ADMIT_TERM"),
    F.substring(F.col("RESIDENCY"), 1, 5).cast("string").alias("RESIDENCY"),
    # IPEDS computed fields
    F.substring(F.col("IPEDS_FULL_PART_TIME_FLG"), 1, 1)
    .cast("string")
    .alias("IPEDS_FULL_PART_TIME_FLG"),
    F.col("IPEDS_SCH").cast(DecimalType(38, 10)).alias("IPEDS_SCH"),
    F.substring(F.col("IPEDS_DISTANCE_EDUCATION_STATUS"), 1, 100)
    .cast("string")
    .alias("IPEDS_DISTANCE_EDU_STATUS"),
    F.col("IPEDS_FIPS_CD").cast(DecimalType(38, 10)).alias("IPEDS_FIPS_CD"),
    F.col("CLASS_NBR").cast(DecimalType(38, 10)).alias("CLASS_NBR"),
    F.substring(F.col("INIT_TERM"), 1, 8).cast("string").alias("INIT_TERM"),
    F.substring(F.col("IPEDS_ETHNICITY"), 1, 8).cast("string").alias("IPEDS_ETHNICITY"),
    F.substring(F.col("TERM_DESCR"), 1, 30).cast("string").alias("TERM_DESCR"),
    F.col("ACAD_YEAR").cast(DecimalType(38, 10)).alias("ACAD_YEAR"),
    F.substring(F.col("CIP_CD_DESCR"), 1, 254).cast("string").alias("CIP_CD_DESCR"),
    F.col("SNAPSHOT_DT").cast(TimestampType()).alias("SNAPSHOT_DT"),
    F.substring(F.col("ACAD_PROGRAM_DESCR"), 1, 30)
    .cast("string")
    .alias("ACAD_PROGRAM_DESCR"),
    F.substring(F.col("ACAD_CAREER_DESCR"), 1, 30)
    .cast("string")
    .alias("ACAD_CAREER_DESCR"),
    F.substring(F.col("DEPT"), 1, 10).cast("string").alias("DEPT"),
    F.substring(F.col("COLLEGE"), 1, 5).cast("string").alias("COLLEGE"),
    F.substring(F.col("COLLEGE_DESCR"), 1, 30).cast("string").alias("COLLEGE_DESCR"),
    F.substring(F.col("DEPT_DESCR"), 1, 30).cast("string").alias("DEPT_DESCR"),
    F.substring(F.col("TUITION_RESIDENCY_DESCR"), 1, 30)
    .cast("string")
    .alias("TUITION_RESIDENCY_DESCR"),
    # IPEDS geography fields
    F.substring(F.col("IPEDS_CITY"), 1, 30).cast("string").alias("IPEDS_CITY"),
    F.substring(F.col("IPEDS_COUNTY"), 1, 30).cast("string").alias("IPEDS_COUNTY"),
    F.substring(F.col("IPEDS_POSTAL"), 1, 12).cast("string").alias("IPEDS_POSTAL"),
    # Retention fields
    F.substring(F.col("STUDENTRETENTIONCATEGORY"), 1, 20)
    .cast("string")
    .alias("STUDENTRETENTIONCATEGORY"),
    F.col("RETENTION_FLG").cast(DecimalType(38, 10)).alias("RETENTION_FLG"),
    # IPEDS_ADDR: empty or NULL → NULL; otherwise trim to 55 chars
    F.when(
        F.col("IPEDS_ADDR").isNull() | (F.col("IPEDS_ADDR") == F.lit("")),
        F.lit(None).cast("string"),
    )
    .otherwise(F.substring(F.col("IPEDS_ADDR"), 1, 55))
    .alias("IPEDS_ADDR"),
    F.substring(F.col("IPEDS_COUNTRY"), 1, 3).cast("string").alias("IPEDS_COUNTRY"),
    F.substring(F.col("TUITION_RES"), 1, 5).cast("string").alias("TUITION_RES"),
    F.substring(F.col("IPEDS_ETHNICITY_DESCR"), 1, 50)
    .cast("string")
    .alias("IPEDS_ETHNICITY_DESCR"),
    F.substring(F.col("ETHN_GRP_DESCR"), 1, 50).cast("string").alias("ETHN_GRP_DESCR"),
    F.col("ZERO_CREDIT_FLG").cast(DecimalType(38, 10)).alias("ZERO_CREDIT_FLG"),
    F.substring(F.col("RESIDENCY_DESCR"), 1, 30)
    .cast("string")
    .alias("RESIDENCY_DESCR"),
    # Audit fields
    F.current_timestamp().cast(TimestampType()).alias("DateLoaded"),
    # Reporting year: Jul–Dec = current/next year; Jan–Jun = prev/current year
    F.when(
        F.month(F.col("CLASS_START_DT").cast("date")) <= 6,
        F.concat(
            F.year(F.col("CLASS_START_DT").cast("date")).cast("string"),
            F.lit("-"),
            (F.year(F.col("CLASS_START_DT").cast("date")) + 1).cast("string"),
        ),
    )
    .otherwise(
        F.concat(
            (F.year(F.col("CLASS_START_DT").cast("date")) + 1).cast("string"),
            F.lit("-"),
            (F.year(F.col("CLASS_START_DT").cast("date")) + 2).cast("string"),
        )
    )
    .cast("string")
    .alias("Reporting_Year"),
)

# COMMAND ----------

# =============================================================================
# Write final output to the target Delta table (overwrite / truncate-and-load)
# =============================================================================
TARGET_TABLE = f"{analytics}.{staging}.fact_ipeds_twelve_month_enrollment_work"

write_df_to_table(df_final_output, TARGET_TABLE, mode="overwrite")
log_msg(f"NOTE: Data loaded into {TARGET_TABLE} successfully.", "info")

# COMMAND ----------

# Cleanup: drops all intermediate staging checkpoint tables created during execution to free up storage.
for _tmp_tbl in (
    _tmp_stage_detail,
    _tmp_stage_final,
    _tmp_stage_work,
):
    try:
        drop_table(_tmp_tbl)
        log_msg(f"Dropped checkpoint temp table: {_tmp_tbl}")
    except Exception as _e:
        log_msg(f"WARN: could not drop {_tmp_tbl}: {_e}")


# COMMAND ----------

# =============================================================================
# Job End
# =============================================================================

_job_end_time = datetime.now()
log_msg(
    f"Job completed: transform_analytics_fact_ipeds_twelve_month_enrollment_work | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} "
    f"| Duration: {str(_job_end_time - _job_start_time)}",
    "info",
)
