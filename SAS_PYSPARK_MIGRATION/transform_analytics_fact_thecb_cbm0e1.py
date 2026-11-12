# Databricks notebook source
# /// script
# [tool.databricks.environment]
# environment_version = "5"
# ///
# MAGIC %md
# MAGIC # 400_LOAD_CBM0E1 --> transform_analytics_fact_thecb_cbm0e1 - THECB CBM0E1 Student Enrollment Report
# MAGIC
# MAGIC ## Purpose
# MAGIC Generates the THECB CBM0E1 fixed-width (163-char) student enrollment file — one record per enrolled
# MAGIC student per reporting term. Assembles data from PeopleSoft Campus Solutions, applies THECB business
# MAGIC rules, and outputs a positional flat file with Header + Detail + EOF trailer records.
# MAGIC
# MAGIC ## Processing Steps
# MAGIC 1. Build class-level enrollment info (CB-exclude, DLRN, FLEX flags)
# MAGIC 2. Aggregate to student-term list with FLEX term adjustments
# MAGIC 3. Determine CLASS level (1-8), CIP, RESTRICTED, NDS per student
# MAGIC 4. Resolve requirement terms and call child notebooks (UGLIMIT, UGDEGR, SCH, TRANCOL)
# MAGIC 5. Derive IDD flag, residence/county codes, doctoral funding, ethnicity/race, CAP, tuition status
# MAGIC 6. Assemble final student record, resolve CLASS conflicts, derive SIN, generate fixed-width output
# MAGIC
# MAGIC ## Key Business Rules
# MAGIC - **FLEX**: Classes ending after term or starting after census shift to next reporting term
# MAGIC - **SIN**: SSN → CB External ID → synthetic '9' + EMPLID fallback
# MAGIC - **CB_REPORTED='N'**: Distance-learning-only students excluded from file output
# MAGIC - **CLASS conflicts**: Highest CLASS value wins per student/term
# MAGIC
# MAGIC ## Output
# MAGIC - **Table**: `{analytics}.{staging}.fact_thecb_cbm0e1_enrollment_work`
# MAGIC - **File**: `CBM0E1_{term}_{DDMONYYYY}.txt` (Header + 163-char detail records + EOF)
# MAGIC
# MAGIC ## Child Notebooks
# MAGIC UGLIMIT, UGDEGR, SCH, TRANCOL
# MAGIC

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

# Import required PySpark functions and types
from pyspark.sql import functions as F
from pyspark.sql.types import *
from pyspark.sql import Window
from datetime import datetime

# COMMAND ----------

# Define input parameters as widgets
dbutils.widgets.text("term", "2262", "Term")
dbutils.widgets.text("prev_term", "2258", "Previous Term")
dbutils.widgets.text("two_year_prev_term", "2242", "Two Year Previous Term")
dbutils.widgets.text("term_end_dt", "12MAY2026:00:00:00", "Term End Date")
dbutils.widgets.text("term_sk_filter", "411", "Term SK Filter")

# Get parameter values from widgets
term = dbutils.widgets.get("term")
prev_term = dbutils.widgets.get("prev_term")
two_year_prev_term = dbutils.widgets.get("two_year_prev_term")
term_end_dt = dbutils.widgets.get("term_end_dt")
term_sk_filter = dbutils.widgets.get("term_sk_filter")

term_end_dt = datetime.strptime(term_end_dt, "%d%b%Y:%H:%M:%S").strftime(
    "%Y-%m-%d %H:%M:%S"
)


# Build parameter dictionary to pass to child notebooks
params = {
    "term": str(term),
    "prev_term": str(prev_term),
    "two_year_prev_term": str(two_year_prev_term),
    "term_end_dt": str(term_end_dt),
    "term_sk_filter": str(term_sk_filter),
}
print(term_end_dt)

# COMMAND ----------

# Load session table and filter by session code and term using DataFrame API
session_data = read_table(f"{student}.{bronze}.ps_session_tbl").alias("session_data")

df_session_info = (
    session_data.filter(
        (
            (F.col("session_data.SESSION_CODE") == "1")
            & (F.substring(F.col("session_data.STRM"), 4, 1).isin("2", "8"))
        )
        | (
            (F.col("session_data.SESSION_CODE") == "5W2")
            & (F.substring(F.col("session_data.STRM"), 4, 1) == "5")
        )
    )
    .select(
        F.col("session_data.INSTITUTION"),
        F.col("session_data.ACAD_CAREER"),
        F.col("session_data.STRM"),
        F.col("session_data.SESSION_CODE"),
        F.col("session_data.SESS_BEGIN_DT"),
        F.col("session_data.SESS_END_DT"),
        F.col("session_data.ENROLL_OPEN_DT"),
        F.col("session_data.SESSN_ENRL_CNTL"),
        F.col("session_data.SESSN_APPT_CNTL"),
        F.col("session_data.FIRST_ENRL_DT"),
        F.col("session_data.LAST_ENRL_DT"),
        F.col("session_data.LAST_WAIT_DT"),
        F.col("session_data.HOLIDAY_SCHEDULE"),
        F.col("session_data.WEEKS_OF_INSTRUCT"),
        F.col("session_data.CENSUS_DT"),
        F.col("session_data.USE_DYN_CLASS_DATE"),
        F.col("session_data.SIXTY_PCT_DT"),
        F.col("session_data.FACILITY_ASSIGNMNT"),
        F.col("session_data.SSR_ENR_APT_APPROV"),
        F.col("session_data.SSR_VAL_APT_APPROV"),
        F.col("session_data.SSR_SSPLNRDISP_BDT"),
        F.col("session_data.SSR_SSPLNRDISP_EDT"),
        #F.col("session_data.READ_DTM"),
        #F.col("session_data.STG_UPDATE_ID"),
    )
    .orderBy("session_data.STRM")
)

# COMMAND ----------

# Add previous term census date and STRM using window functions
window_spec = Window.orderBy("STRM")

df_session_with_prev = df_session_info.withColumn(
    "PREV_CENSUS_DT", F.lag("CENSUS_DT").over(window_spec)
).withColumn("PREV_STRM", F.lag("STRM").over(window_spec))

# COMMAND ----------

# Identify classes with CB attribute marked as EXCLUDE
class_attr = read_table(f"{student}.{bronze}.ps_CLASS_ATTRIBUTE").alias("class_attr")
class_sched = read_table(f"{analytics}.{staging}.fact_thecb_class_schedule").alias(
    "class_sched"
)
term_dim = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term")
course_offer = read_table(f"{analytics}.{silver}.dim_thecb_course_offer").alias(
    "course_offer"
)

df_cb_exclude = (
    class_attr.join(
        class_sched,
        (F.col("class_attr.SESSION_CODE") == F.col("class_sched.SESSION_CODE"))
        & (F.col("class_attr.CLASS_SECTION") == F.col("class_sched.CLASS_SECTION")),
        "inner",
    )
    .join(
        term_dim,
        (F.col("term.TERM_SK") == F.col("class_sched.TERM_SK"))
        & (F.col("class_attr.STRM") == F.col("term.STRM")),
        "inner",
    )
    .join(
        course_offer,
        (F.col("course_offer.COURSE_OFFER_SK") == F.col("class_sched.COURSE_OFFER_SK"))
        & (F.col("class_attr.CRSE_ID") == F.col("course_offer.COURSE_IDENTIFIER"))
        & (
            F.col("class_attr.CRSE_OFFER_NBR") == F.col("course_offer.COURSE_OFFER_NBR")
        ),
        "inner",
    )
    .filter(
        (F.col("class_attr.CRSE_ATTR") == "CB")
        & (F.col("class_attr.CRSE_ATTR_VALUE") == "EXCLUDE")
        & (F.col("class_attr.STRM") > "2018")
    )
    .select(
        F.col("class_attr.CRSE_ATTR_VALUE"),
        F.col("class_attr.CRSE_ATTR"),
        F.col("class_sched.CLASS_NBR"),
        F.col("term.TERM_SK"),
        F.col("class_attr.SESSION_CODE"),
        F.col("term.STRM"),
    )
    .distinct()
)

# COMMAND ----------

# Identify distance learning classes with DLRN attribute
distance_learn = read_table(f"{student}.{bronze}.ps_CLASS_ATTRIBUTE").alias(
    "distance_learn"
)

df_distance_learning = (
    distance_learn.filter(
        (F.col("distance_learn.CRSE_ATTR") == "DLRN")
        & (
            F.col("distance_learn.CRSE_ATTR_VALUE").isin(
                "DEPT(OUT)", "CDE-T(OUT)", "CDE-(OUT)"
            )
        )
    )
    .select(
        F.col("distance_learn.CRSE_ID"),
        F.col("distance_learn.CRSE_OFFER_NBR"),
        F.col("distance_learn.STRM"),
        F.col("distance_learn.SESSION_CODE"),
        F.col("distance_learn.CLASS_SECTION"),
        F.col("distance_learn.CRSE_ATTR"),
    )
    .distinct()
)


# COMMAND ----------


# Build main DataFrame with all joins and transformations
enrl_fact = read_table(f"{analytics}.{staging}.fact_thecb_student_term_course_enrollment").alias(
    "f"
)
term_tbl = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("t")
career = read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias("career")
dlrn_report = read_table(f"{analytics}.{silver}.fact_thecb_distance_learning").alias(
    "dl"
)

# Join all tables
df_class_info = (
    enrl_fact.join(term_tbl, F.col("f.TERM_SK") == F.col("t.TERM_SK"), "left")
    .join(career, F.col("f.ACAD_CAREER_SK") == F.col("career.ACAD_CAREER_SK"), "left")
    .join(
        df_cb_exclude.alias("cb_exclude"),
        (F.col("f.CLASS_NBR") == F.col("cb_exclude.CLASS_NBR"))
        & (F.col("f.SESSION_CD") == F.col("cb_exclude.SESSION_CODE"))
        & (F.col("t.STRM") == F.col("cb_exclude.STRM")),
        "left",
    )
    .join(
        df_session_with_prev.alias("w"),
        (F.col("f.INSTITUTION") == F.col("w.INSTITUTION"))
        & (F.col("career.ACAD_CAREER") == F.col("w.ACAD_CAREER"))
        & (F.col("t.STRM") == F.col("w.STRM")),
        "inner",
    )
    .join(
        df_distance_learning.alias("ws"),
        (F.col("w.STRM") == F.col("ws.STRM"))
        & (F.col("f.CRSE_ID") == F.col("ws.CRSE_ID"))
        & (F.col("f.SESSION_CD") == F.col("ws.SESSION_CODE"))
        & (F.col("f.CLASS_SECTION") == F.col("ws.CLASS_SECTION"))
        & (F.col("f.CRSE_OFFER_NBR") == F.col("ws.CRSE_OFFER_NBR")),
        "left",
    )
    .join(
        dlrn_report,
        (F.col("f.EMPLID") == F.col("dl.EMPLID")) & (F.col("dl.STRM") == F.lit(term)),
        "left",
    )
    .filter(
        (
            # SAS semantic: missing CRSE_ATTR_VALUE (<> 'EXCLUDE') = TRUE when no LEFT JOIN match.
            # Use isNull on the join key to correctly pass all non-excluded classes.
            F.col("cb_exclude.CLASS_NBR").isNull()
            | F.col("dl.EMPLID").isNotNull()
        )
        & (F.col("f.STUDENT_ENRL_CD") == "E")
        & (F.coalesce(F.col("f.LAST_ENRL_ACTION_RSN"), F.lit("FILLER")) != "CENS")
        & (F.col("f.TERM_SK") > 375)
    )
)

# Select and cast columns for final output
df_final = df_class_info.select(
    F.col("f.EMPLID").cast("string").alias("EMPLID"),
    F.col("f.INSTITUTION").cast("string").alias("INSTITUTION"),
    F.col("f.ACAD_CAREER_SK").cast("bigint").alias("ACAD_CAREER_SK"),
    F.col("f.CLASS_NBR").cast("bigint").alias("CLASS_NBR"),
    F.col("f.TERM_SK").cast("bigint").alias("TERM_SK"),
    F.col("f.ACAD_CAL_SK").cast("bigint").alias("ACAD_CAL_SK"),
    F.col("f.ACAD_PROGRAM_SK").cast("bigint").alias("ACAD_PROGRAM_SK"),
    F.col("f.MAJOR_ACAD_PLAN_SK").cast("bigint").alias("MAJOR_ACAD_PLAN_SK"),
    F.col("f.MAJOR_DEPT_SK").cast("bigint").alias("MAJOR_DEPT_SK"),
    F.col("f.COURSE_CAREER").cast("string").alias("COURSE_CAREER"),
    F.col("f.SESSION_CD").cast("string").alias("SESSION_CD"),
    F.col("f.SESSION_ENRL_CONTROL").cast("string").alias("SESSION_ENRL_CONTROL"),
    F.col("f.STUDENT_ENRL_CD").cast("string").alias("STUDENT_ENRL_CD"),
    F.col("f.STUDENT_ENRL_FLG_RSN_CD").cast("string").alias("STUDENT_ENRL_FLG_RSN_CD"),
    F.col("f.LAST_ENRL_ACTION_CD").cast("string").alias("LAST_ENRL_ACTION_CD"),
    F.col("f.LAST_ENRL_ACTION_RSN").cast("string").alias("LAST_ENRL_ACTION_RSN"),
    F.col("f.LAST_ENRL_ACTION_PROCESS_CD")
    .cast("string")
    .alias("LAST_ENRL_ACTION_PROCESS_CD"),
    F.col("f.ENRL_ADD_DT").alias("ENRL_ADD_DT"),
    F.col("f.ENRL_DROP_DT").alias("ENRL_DROP_DT"),
    F.col("f.UNIT_TAKEN").cast("bigint").alias("UNIT_TAKEN"),
    F.col("f.UNIT_PRGRS").cast("bigint").alias("UNIT_PRGRS"),
    F.col("f.UNIT_PRGRS_FA").cast("bigint").alias("UNIT_PRGRS_FA"),
    F.col("f.UNIT_BILLING").cast("bigint").alias("UNIT_BILLING"),
    F.col("f.COURSE_COUNT").cast("bigint").alias("COURSE_COUNT"),
    F.col("f.GRADING_BASIS_ENRL_CD").cast("string").alias("GRADING_BASIS_ENRL_CD"),
    F.col("f.GRADING_BASIS_DT").alias("GRADING_BASIS_DT"),
    F.col("f.UNIT_EARNED").cast("bigint").alias("UNIT_EARNED"),
    F.col("f.DYNAMIC_CLASS_NBR").cast("bigint").alias("DYNAMIC_CLASS_NBR"),
    F.col("f.GRADE_DT").alias("GRADE_DT"),
    F.col("f.UNITS_ATTEMPTD").cast("string").alias("UNITS_ATTEMPTD"),
    F.col("f.GRADE_PTS").cast("bigint").alias("GRADE_PTS"),
    F.col("f.GRADE_PTS_FA").cast("bigint").alias("GRADE_PTS_FA"),
    F.col("f.GRADE_PTS_PER_UNIT").cast("decimal(38,10)").alias("GRADE_PTS_PER_UNIT"),
    F.col("f.INSTRUCTOR_ID").cast("string").alias("INSTRUCTOR_ID"),
    F.col("f.COURSE_GRADE_OFF").cast("string").alias("COURSE_GRADE_OFF"),
    F.col("f.PASSING_GRADE_FLG").cast("string").alias("PASSING_GRADE_FLG"),
    F.col("f.PASSING_GRADE_RZ_FLG").cast("string").alias("PASSING_GRADE_RZ_FLG"),
    F.col("f.STUDENT_ENRL_FLG").cast("string").alias("STUDENT_ENRL_FLG"),
    F.col("f.INSTRUCTOR_NAME").cast("string").alias("INSTRUCTOR_NAME"),
    F.col("f.ACAD_LEVEL_EOT").cast("string").alias("ACAD_LEVEL_EOT"),
    F.col("f.UGRD_SCH_LOWER").cast("bigint").alias("UGRD_SCH_LOWER"),
    F.col("f.UGRD_SCH_UPPER").cast("bigint").alias("UGRD_SCH_UPPER"),
    F.col("f.MASTER_SCH").cast("bigint").alias("MASTER_SCH"),
    F.col("f.DOCT_SCH").cast("bigint").alias("DOCT_SCH"),
    F.col("f.DOCT_PROFESSIONAL_SCH").cast("bigint").alias("DOCT_PROFESSIONAL_SCH"),
    F.col("f.SPEC_SCH").cast("bigint").alias("SPEC_SCH"),
    F.col("f.CERT_SCH").cast("bigint").alias("CERT_SCH"),
    F.col("f.END_DT").alias("END_DT"),
    F.col("f.START_DT").alias("START_DT"),
    F.col("f.MAJOR2_ACAD_PLAN_SK").cast("bigint").alias("MAJOR2_ACAD_PLAN_SK"),
    F.col("f.MINOR_ACAD_PLAN_SK").cast("bigint").alias("MINOR_ACAD_PLAN_SK"),
    F.col("f.ACAD_LEVEL_BOT").cast("string").alias("ACAD_LEVEL_BOT"),
    F.col("f.ACAD_LEVEL_PROJ").cast("string").alias("ACAD_LEVEL_PROJECTED"),
    F.col("f.MAJOR2_DEPT_SK").cast("bigint").alias("MAJOR2_DEPT_SK"),
    F.col("f.MINOR_DEPT_SK").cast("bigint").alias("MINOR_DEPT_SK"),
    F.when(
        (F.col("f.STUDENT_ENRL_CD") == "E")
        & (
            (
                (F.col("f.SESSION_CD") != "1")
                & F.substring(F.col("w.STRM"), 4, 1).isin("2", "8")
            )
            | (
                (F.col("f.SESSION_CD") != "5W2")
                & (F.substring(F.col("w.STRM"), 4, 1) == "5")
            )
        )
        & (F.col("f.END_DT") > F.col("t.TERM_END_DT")),
        F.lit("6"),
    )
    .when(
        (F.col("f.STUDENT_ENRL_CD") == "E")
        & (
            (
                (F.col("f.SESSION_CD") != "1")
                & F.substring(F.col("w.STRM"), 4, 1).isin("2", "8")
            )
            | (
                (F.col("f.SESSION_CD") != "5W2")
                & (F.substring(F.col("w.STRM"), 4, 1) == "5")
            )
        )
        & (F.col("f.START_DT") > F.col("w.CENSUS_DT")),
        F.lit("1"),
    )
    .otherwise(F.lit(None))
    .alias("FLEX"),
    F.col("t.STRM").cast("string").alias("STRM"),
    F.col("ws.CRSE_ATTR").cast("string").alias("CRSE_ATTR"),
    F.when(F.col("dl.SUBJECT").isNull(), F.lit(0))
    .otherwise(F.lit(1))
    .cast("bigint")
    .alias("DLRN"),
    F.col("f.CRSE_ID").cast("string").alias("CRSE_ID"),
    F.col("f.ACAD_PROG_PRIMARY").cast("string").alias("ACAD_PROG_PRIMARY"),
    F.col("t.CENSUS_DT").cast("date").alias("CENSUS_DT"),
    F.lit(None).cast("string").alias("SESSION_CODE"),
    F.col("f.CRSE_OFFER_NBR").cast("bigint").alias("CRSE_OFFER_NBR"),
).distinct()

# COMMAND ----------

# Write to target table using utility function (overwrite after truncate)
write_df_to_table(
    df_final, f"{analytics}.{staging}.fact_thecb_cbm0c1_class_info", "overwrite"
)

# COMMAND ----------


# Load source tables
class_info = read_table(f"{analytics}.{staging}.fact_thecb_cbm0c1_class_info").alias(
    "class_info"
)
term_dim = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term")

# Window specification for MAX distance learning indicator
window_spec = Window.partitionBy("class_info.EMPLID", "class_info.TERM_SK")

# Join tables and calculate DLRN with window function
df_with_dlrn = (
    class_info.join(
        term_dim, F.col("class_info.TERM_SK") == F.col("term.TERM_SK"), "left"
    )
    .filter(
        (F.col("term.ACAD_YEAR") >= 2001)
        & (F.col("class_info.TERM_SK") > F.lit(term_sk_filter).cast("bigint"))
    )
    .withColumn("max_dlrn", F.max(F.col("class_info.DLRN")).over(window_spec))
)

# Calculate FLEX_STRM with complex term adjustment logic
df_with_flex_strm = df_with_dlrn.withColumn(
    "FLEX_STRM_CALC",
    F.when(
        F.coalesce(F.trim(F.col("class_info.FLEX")), F.lit("")) == "6",
        F.when(
            F.expr("SUBSTR(term.STRM, 4, 1)") == "8",
            F.concat(
                F.expr("SUBSTR(term.STRM, 1, 1)"),
                (F.expr("CAST(SUBSTR(term.STRM, 2, 2) AS INT)") + 1).cast("string"),
                F.lit("2"),
            ),
        )
        .when(
            F.expr("SUBSTR(term.STRM, 4, 1)") == "2",
            F.concat(F.expr("SUBSTR(term.STRM, 1, 3)"), F.lit("5")),
        )
        .when(
            F.expr("SUBSTR(term.STRM, 4, 1)") == "5",
            F.concat(F.expr("SUBSTR(term.STRM, 1, 3)"), F.lit("8")),
        ),
    ).otherwise(F.col("term.STRM")),
)

# Select final columns with casts and SESSION_CD classification
df_final = df_with_flex_strm.select(
    F.col("class_info.EMPLID").cast("string").alias("EMPLID"),
    F.col("class_info.INSTITUTION").cast("string").alias("INSTITUTION"),
    F.col("class_info.ACAD_CAREER_SK").cast("decimal(38,10)").alias("ACAD_CAREER_SK"),
    F.col("class_info.TERM_SK").cast("BIGINT").alias("TERM_SK"),
    F.col("class_info.FLEX").cast("string").alias("FLEX"),
    # Classify session as dynamic (DYN) or standard (NOTDYN)
    F.when(F.col("class_info.SESSION_CD") == "DYN", "DYN")
    .otherwise("NOTDYN")
    .cast("string")
    .alias("SESSION_CD"),
    F.col("class_info.STRM").cast("string").alias("STRM"),
    # Maximum distance learning indicator per student and term
    F.col("max_dlrn").cast("BIGINT").alias("DLRN"),
    # FLEX term: for FLEX students, adjust term based on semester code
    F.col("FLEX_STRM_CALC").cast("string").alias("FLEX_STRM"),
).distinct()
# Write to target table using utility function (overwrite after truncate)
write_df_to_table(
    df_final, f"{analytics}.{staging}.fact_thecb_cbm0c1_student_list", "overwrite"
)

try:
    print("Running notebook: UGLIMIT")
    # dbutils.notebook.run is not supported on serverless compute
    result = dbutils.notebook.run("transform_analytics_fact_thecb_undergraduate_limit", 0, params)
    print("Completed: UGLIMIT")

except Exception as e:
    print(f"Error in UGLIMIT: {str(e)}")
    raise

print(
    f"Processing fact_thecb_cbm0c1_classification_info for term={term}, prev_term={prev_term}, two_year_prev_term={two_year_prev_term}, term_end_dt={term_end_dt}, term_sk_filter={term_sk_filter}"
)

# COMMAND ----------

# Load students with GDR service indicator for graduate classification
service_ind = read_table(f"{student}.{bronze}.ps_SRVC_IND_DATA").alias("service_ind")

df_gdr_service_ind = (
    service_ind.filter(
        (F.col("service_ind.SRVC_IND_ACT_TERM") <= term)
        & (F.col("service_ind.SRVC_IND_CD") == "GDR")
    )
    .select(F.col("service_ind.EMPLID"), F.col("service_ind.SRVC_IND_CD"))
    .distinct()
)

# COMMAND ----------


# Build main DataFrame with all joins and transformations
enrl_fact = read_table(f"{analytics}.{staging}.fact_thecb_irp_enrollment").alias(
    "enrl_fact"
)
career = read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias("career")
acad_prog = read_table(f"{analytics}.{silver}.dim_thecb_academic_program").alias(
    "acad_prog"
)
acad_plan = read_table(f"{analytics}.{silver}.dim_thecb_academic_plan").alias("acad_plan")
term_dim = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term")
active_prog = read_table(f"{student}.{bronze}.ps_ACAD_PROG").alias("active_prog")
cip_dim = read_table(f"{analytics}.{silver}.dim_thecb_cip_code").alias("cip_dim")

# Window specification for MAX aggregation
window_spec = Window.partitionBy("enrl_fact.TERM_SK", "enrl_fact.EMPLID")

# Join all tables and add window function
df_student_term_enrl = (
    enrl_fact.join(
        df_gdr_service_ind.alias("gdr_ind"),
        F.coalesce(F.col("enrl_fact.EMPLID"), F.lit(""))
        == F.coalesce(F.col("gdr_ind.EMPLID"), F.lit("")),
        "left",
    )
    .join(
        career,
        F.col("enrl_fact.ACAD_CAREER_SK") == F.col("career.ACAD_CAREER_SK"),
        "left",
    )
    .join(
        acad_prog,
        F.col("enrl_fact.ACAD_PROGRAM_PRIMARY") == F.col("acad_prog.ACAD_PROGRAM_SK"),
        "left",
    )
    .join(
        acad_plan,
        F.col("enrl_fact.MAJOR_ACAD_PLAN_SK") == F.col("acad_plan.ACAD_PLAN_SK"),
        "left",
    )
    .join(term_dim, F.col("enrl_fact.TERM_SK") == F.col("term.TERM_SK"), "left")
    .join(
        active_prog,
        (
            F.coalesce(F.col("enrl_fact.EMPLID"), F.lit(""))
            == F.coalesce(F.col("active_prog.EMPLID"), F.lit(""))
        )
        & (F.coalesce(F.col("active_prog.PROG_STATUS"), F.lit("")) == "AC")
        & (
            F.coalesce(F.col("active_prog.ACAD_PROG"), F.lit(""))
            != F.coalesce(F.col("acad_prog.ACAD_PROGRAM"), F.lit(""))
        ),
        "left",
    )
    .join(
        cip_dim,
        (
            F.coalesce(F.col("acad_plan.CIP_CD"), F.lit(""))
            == F.coalesce(F.col("cip_dim.CIP_CD"), F.lit(""))
        )
        & (F.coalesce(F.col("cip_dim.is_current"), F.lit(False)) == True),
        "left",
    )
    .withColumn("max_gdr_emplid", F.max(F.col("gdr_ind.EMPLID")).over(window_spec))
)

# Filter based on GDR matching
df_filtered = df_student_term_enrl.filter(
    F.coalesce(F.col("gdr_ind.EMPLID"), F.lit(""))
    == F.coalesce(F.col("max_gdr_emplid"), F.lit(""))
)

# Select and transform columns with CASE WHEN logic
df_final = df_filtered.select(
    F.col("enrl_fact.EMPLID").cast("string").alias("EMPLID"),
    F.col("enrl_fact.TERM_SK").cast("BIGINT").alias("TERM_SK"),
    F.col("enrl_fact.ACAD_PROGRAM_PRIMARY")
    .cast("BIGINT")
    .alias("ACAD_PROGRAM_PRIMARY"),
    F.col("acad_prog.ACAD_PROGRAM").cast("string").alias("ACAD_PROGRAM"),
    F.col("acad_plan.ACAD_PLAN").cast("string").alias("ACAD_PLAN"),
    F.col("career.ACAD_CAREER").cast("string").alias("ACAD_CAREER"),
    F.col("enrl_fact.ACAD_LVL_LOAD_BOT").cast("string").alias("ACAD_LVL_LOAD_BOT"),
    F.lit(None).cast("string").alias("SRVC_IND_CD"),
    F.lit(None).cast("string").alias("SRVC_IND_ACT_TERM"),
    F.lit(None).cast("timestamp").alias("SRVC_IND_DTTM"),
    F.col("enrl_fact.INSTITUTION").cast("string").alias("INSTITUTION"),
    # CLASS calculation
    F.when(F.col("enrl_fact.ACAD_LVL_LOAD_BOT") == "10", "1")
    .when(F.col("enrl_fact.ACAD_LVL_LOAD_BOT") == "20", "2")
    .when(F.col("enrl_fact.ACAD_LVL_LOAD_BOT") == "30", "3")
    .when(F.col("enrl_fact.ACAD_LVL_LOAD_BOT") == "40", "4")
    .when(F.col("enrl_fact.ACAD_LVL_LOAD_BOT").isin("50", "60"), "5")
    .when(
        (F.col("acad_prog.ACAD_PROGRAM") == "DOCT")
        & (
            F.coalesce(F.expr("RIGHT(SUBSTR(acad_plan.ACAD_PLAN, 1, 6), 2)"), F.lit(""))
            == "DB"
        )
        & (F.coalesce(F.col("gdr_ind.SRVC_IND_CD"), F.lit("")) == "GDR"),
        "7",
    )
    .when(F.col("acad_prog.ACAD_PROGRAM").isin("MASTR", "CERT", "SPEC"), "6")
    .when(F.col("acad_plan.ACAD_PLAN") == "DNP_NP_AP", "8")
    .when(
        (F.col("acad_prog.ACAD_PROGRAM") == "DOCT")
        & (
            F.coalesce(F.expr("RIGHT(SUBSTR(acad_plan.ACAD_PLAN, 1, 6), 2)"), F.lit(""))
            == "DB"
        ),
        "6",
    )
    .when(
        (F.col("acad_prog.ACAD_PROGRAM") == "DOCT")
        & (
            F.coalesce(F.expr("RIGHT(SUBSTR(acad_plan.ACAD_PLAN, 1, 6), 2)"), F.lit(""))
            != "DB"
        ),
        "7",
    )
    .otherwise("")
    .cast("string")
    .alias("CLASS"),
    # CIP_CD calculation
    F.when(
        (F.expr("SUBSTR(REPLACE(cip_dim.CIP_ALTERNATIVE_CD, '.', ''), 1, 8)").isNull())
        | (
            F.trim(F.expr("SUBSTR(REPLACE(cip_dim.CIP_ALTERNATIVE_CD, '.', ''), 1, 8)"))
            == ""
        ),
        F.lit(None),
    )
    .otherwise(
        F.expr("SUBSTR(REPLACE(cip_dim.CIP_ALTERNATIVE_CD, '.', ''), 1, 8)").cast(
            "string"
        )
    )
    .alias("CIP_CD"),
    # RESTRICTED calculation
    F.when(
        (F.expr("SUBSTR(acad_plan.ACAD_PLAN, 7, 3)") == "TCH")
        | (
            F.expr("SUBSTR(acad_plan.ACAD_PLAN, 1, 4)").isin(
                "CHST", "CHBL", "IAED", "ISED", "EDUC"
            )
        ),
        "01",
    )
    .when(
        F.col("acad_plan.ACAD_PLAN").isin(
            "EDTEETNTAL", "EDTEETNTEC", "EDTEETNTML", "EDTEETNTSD"
        ),
        "02",
    )
    .when(
        F.col("acad_plan.ACAD_PLAN").isin(
            "EDTECTAL", "EDTECTEC", "EDTECTML", "EDTECTSD"
        ),
        "04",
    )
    .when(F.col("acad_plan.SHORT_DESCR") == "RN-TO-BSN", "10")
    .when(F.col("acad_plan.SHORT_DESCR") == "BSN", "12")
    .when(F.expr("SUBSTR(acad_plan.ACAD_PLAN, 1, 4)") == "MEDT", "23")
    .when(F.col("acad_plan.ACAD_PLAN") == "DNP_NP_AP", "56")
    .otherwise(F.lit(None))
    .cast("string")
    .alias("RESTRICTED"),
    # NDS calculation
    F.when(
        F.col("active_prog.PROG_STATUS").isNull()
        & F.col("acad_prog.ACAD_PROGRAM").isin("UGNDS", "SPEC"),
        F.lit("1"),
    )
    .otherwise(F.lit("0"))
    .cast("string")
    .alias("NDS"),
    F.col("acad_plan.CIP_CD").cast("string").alias("CIP_CD_UNEDITED"),
    F.col("enrl_fact.STUDENT_CAREER_NBR").cast("BIGINT").alias("STUDENT_CAREER_NBR"),
    F.col("term.TERM_BEGIN_DT").cast("timestamp").alias("TERM_BEGIN_DT"),
    F.col("term.STRM").cast("string").alias("STRM"),
).distinct()

# COMMAND ----------

# Write to target table using utility function (overwrite after truncate)
write_df_to_table(
    df_final,
    f"{analytics}.{staging}.fact_thecb_cbm0c1_classification_info",
    "overwrite",
)


print(
    f"Processing fact_thecb_requirement_term for term={term}, prev_term={prev_term}, two_year_prev_term={two_year_prev_term}, term_end_dt={term_end_dt}, term_sk_filter={term_sk_filter}"
)


pape = read_table(f"{student}.{bronze}.ps_ACAD_PLAN").alias("PAPE")
papte = read_table(f"{student}.{bronze}.ps_ACAD_PLAN_TBL").alias("PAPTE")
ccinfo = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0c1_classification_info"
).alias("CCInfo")
atd = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("ATD")


# Reduces the effdt academic plan records to the single row with the highest effective date per student/career/career number.

df_acad_plan_max_efffdt = pape.filter(
    F.coalesce(
        F.date_format(F.col("PAPE.EFFDT"), "yyyy-MM-dd HH:mm:ss"),
        F.to_timestamp(F.lit("1900-01-01 00:00:00"), "yyyy-MM-dd HH:mm:ss"),
    )
    <= F.coalesce(
        F.to_timestamp(F.lit(term_end_dt), "yyyy-MM-dd HH:mm:ss"),
        F.to_timestamp(F.lit("1900-01-01 00:00:00"), "yyyy-MM-dd HH:mm:ss"),
    )
)

df_acad_plan_max_efffdt = df_acad_plan_max_efffdt.withColumn(
    "MAX_EFFDT",
    F.max(
        F.coalesce(
            F.date_format(F.col("PAPE.EFFDT"), "yyyy-MM-dd HH:mm:ss"),
            F.to_timestamp(F.lit("1900-01-01 00:00:00"), "yyyy-MM-dd HH:mm:ss"),
        )
    ).over(Window.partitionBy("PAPE.EMPLID", "PAPE.ACAD_CAREER", "PAPE.STDNT_CAR_NBR")),
)

df_acad_plan_max_efffdt = df_acad_plan_max_efffdt.filter(
    F.coalesce(
        F.date_format(F.col("PAPE.EFFDT"), "yyyy-MM-dd HH:mm:ss"),
        F.to_timestamp(F.lit("1900-01-01 00:00:00"), "yyyy-MM-dd HH:mm:ss"),
    )
    == F.col("MAX_EFFDT")
).drop("MAX_EFFDT")

df_acad_plan_max_efffdt = df_acad_plan_max_efffdt.select(
    F.col("PAPE.EMPLID"),
    F.col("PAPE.ACAD_CAREER"),
    F.col("PAPE.STDNT_CAR_NBR"),
    F.col("PAPE.EFFDT"),
    F.col("PAPE.EFFSEQ"),
    F.col("PAPE.ACAD_PLAN"),
    F.col("PAPE.DECLARE_DT"),
    F.col("PAPE.PLAN_SEQUENCE"),
    F.col("PAPE.REQ_TERM"),
    F.col("PAPE.COMPLETION_TERM"),
    F.col("PAPE.STDNT_DEGR"),
    F.col("PAPE.DEGR_CHKOUT_STAT"),
    F.col("PAPE.ADVIS_STATUS"),
    F.col("PAPE.SSR_APT_INSTANCE"),
    F.col("PAPE.SSR_YR_OF_PROG"),
    F.col("PAPE.SCC_ROW_ADD_OPRID"),
    F.col("PAPE.SCC_ROW_ADD_DTTM"),
    F.col("PAPE.SCC_ROW_UPD_OPRID"),
    F.col("PAPE.SCC_ROW_UPD_DTTM"),
    #F.col("PAPE.READ_DTM"),
    #F.col("PAPE.STAGE_UPDATE_ID"),
)


# Further reduces the max-effdt academic plan records to the single row with the highest effective sequence number per student/career/career number.

df_acad_plan_max_effseq = df_acad_plan_max_efffdt.alias("APME")

df_acad_plan_max_effseq = df_acad_plan_max_effseq.withColumn(
    "MAX_EFFSEQ",
    F.max(F.coalesce(F.col("APME.EFFSEQ").cast("int"), F.lit(-1))).over(
        Window.partitionBy("APME.ACAD_CAREER", "APME.EMPLID", "APME.STDNT_CAR_NBR")
    ),
)

df_acad_plan_max_effseq = df_acad_plan_max_effseq.filter(
    F.coalesce(F.col("APME.EFFSEQ").cast("int"), F.lit(-1)) == F.col("MAX_EFFSEQ")
).drop("MAX_EFFSEQ")

df_acad_plan_max_effseq = df_acad_plan_max_effseq.select(
    F.col("APME.EMPLID"),
    F.col("APME.ACAD_CAREER"),
    F.col("APME.STDNT_CAR_NBR"),
    F.col("APME.EFFDT"),
    F.col("APME.EFFSEQ"),
    F.col("APME.ACAD_PLAN"),
    F.col("APME.DECLARE_DT"),
    F.col("APME.PLAN_SEQUENCE"),
    F.col("APME.REQ_TERM"),
    F.col("APME.COMPLETION_TERM"),
    F.col("APME.STDNT_DEGR"),
    F.col("APME.DEGR_CHKOUT_STAT"),
    F.col("APME.ADVIS_STATUS"),
    F.col("APME.SSR_APT_INSTANCE"),
    F.col("APME.SSR_YR_OF_PROG"),
    F.col("APME.SCC_ROW_ADD_OPRID"),
    F.col("APME.SCC_ROW_ADD_DTTM"),
    F.col("APME.SCC_ROW_UPD_OPRID"),
    F.col("APME.SCC_ROW_UPD_DTTM"),
    #F.col("APME.READ_DTM"),
    #F.col("APME.STAGE_UPDATE_ID"),
)


# Reads the academic plan reference table (PS_ACAD_PLAN_TBL) and retains only the most recent effective date per academic plan on or before the term end date.

# COMMAND ----------

df_acad_plan_tbl_max_effdt = papte.filter(
    F.coalesce(
        F.date_format(F.col("PAPTE.EFFDT"), "yyyy-MM-dd HH:mm:ss"),
        F.to_timestamp(F.lit("1900-01-01 00:00:00"), "yyyy-MM-dd HH:mm:ss"),
    )
    <= F.coalesce(
        F.to_timestamp(F.lit(term_end_dt), "yyyy-MM-dd HH:mm:ss"),
        F.to_timestamp(F.lit("1900-01-01 00:00:00"), "yyyy-MM-dd HH:mm:ss"),
    )
)

# COMMAND ----------

df_acad_plan_tbl_max_effdt = df_acad_plan_tbl_max_effdt.withColumn(
    "MAX_EFFDT",
    F.max(
        F.coalesce(
            F.date_format(F.col("PAPTE.EFFDT"), "yyyy-MM-dd HH:mm:ss"),
            F.to_timestamp(F.lit("1900-01-01 00:00:00"), "yyyy-MM-dd HH:mm:ss"),
        )
    ).over(Window.partitionBy("PAPTE.ACAD_PLAN")),
)

df_acad_plan_tbl_max_effdt = df_acad_plan_tbl_max_effdt.filter(
    F.coalesce(
        F.date_format(F.col("PAPTE.EFFDT"), "yyyy-MM-dd HH:mm:ss"),
        F.to_timestamp(F.lit("1900-01-01 00:00:00"), "yyyy-MM-dd HH:mm:ss"),
    )
    == F.col("MAX_EFFDT")
).drop("MAX_EFFDT")

df_acad_plan_tbl_max_effdt = df_acad_plan_tbl_max_effdt.select(
    F.col("PAPTE.INSTITUTION"),
    F.col("PAPTE.EFF_STATUS"),
    F.col("PAPTE.DESCR"),
    F.col("PAPTE.DESCRSHORT"),
    F.col("PAPTE.PLN_REQTRM_DFLT"),
    F.col("PAPTE.DIPLOMA_DESCR"),
    F.col("PAPTE.DIPLOMA_PRINT_FL"),
    F.col("PAPTE.DIPLOMA_INDENT"),
    F.col("PAPTE.TRNSCR_DESCR"),
    F.col("PAPTE.TRNSCR_PRINT_FL"),
    F.col("PAPTE.TRNSCR_INDENT"),
    F.col("PAPTE.FIRST_TERM_VALID"),
    F.col("PAPTE.HEGIS_CODE"),
    F.col("PAPTE.ACAD_CAREER"),
    F.col("PAPTE.TRANSCRIPT_LEVEL"),
    F.col("PAPTE.STUDY_FIELD"),
    F.col("PAPTE.EVALUATE_PLAN"),
    F.col("PAPTE.SSR_LAST_PRS_DT"),
    F.col("PAPTE.SSR_LAST_ADM_TERM"),
    F.col("PAPTE.SAA_WHIF_DISP_ADVR"),
    F.col("PAPTE.SAA_WHIF_DISP_PREM"),
    F.col("PAPTE.SAA_WHIF_DISP_STD"),
    F.col("PAPTE.SSR_NSC_CRD_LVL"),
    F.col("PAPTE.SSR_PROG_LEN_TYPE"),
    F.col("PAPTE.SSR_PROG_LENGTH"),
    F.col("PAPTE.SFA_SPEC_PROG_FLG"),
    F.col("PAPTE.SSR_NSC_INCL_PLAN"),
    #F.col("PAPTE.READ_DTM"),
    #F.col("PAPTE.STAGE_UPDATE_ID"),
    F.col("PAPTE.ACAD_PLAN"),
    F.col("PAPTE.EFFDT"),
    F.col("PAPTE.ACAD_PLAN_TYPE"),
    F.col("PAPTE.ACAD_PROG"),
    F.col("PAPTE.DEGREE"),
    F.col("PAPTE.CIP_CODE"),
    F.col("PAPTE.DESCRLONG"),
)


# Joins student academic plans with the plan reference table (excluding minors), then selects the row with the minimum plan sequence (primary plan) per student/career.

apmes = df_acad_plan_max_effseq.alias("APMES")
acptmed = df_acad_plan_tbl_max_effdt.alias("ACPTMED")

df_acad_plan_join = apmes.join(
    acptmed,
    on=(
        (
            F.coalesce(F.trim(F.col("APMES.ACAD_PLAN")), F.lit(""))
            == F.coalesce(F.trim(F.col("ACPTMED.ACAD_PLAN")), F.lit(""))
        )
        & (
            F.coalesce(F.trim(F.col("ACPTMED.ACAD_PLAN_TYPE")), F.lit(""))
            != F.lit("MIN")
        )
    ),
    how="inner",
)

df_acad_plan_join = df_acad_plan_join.withColumn(
    "MIN_PLAN_SEQUENCE",
    F.min(F.coalesce(F.col("APMES.PLAN_SEQUENCE").cast("bigint"), F.lit(-1))).over(
        Window.partitionBy("APMES.EMPLID", "APMES.ACAD_CAREER", "APMES.STDNT_CAR_NBR")
    ),
)

df_acad_plan_join = df_acad_plan_join.filter(
    F.coalesce(F.col("APMES.PLAN_SEQUENCE").cast("bigint"), F.lit(-1))
    == F.col("MIN_PLAN_SEQUENCE")
).drop("MIN_PLAN_SEQUENCE")

df_acad_plan_join = df_acad_plan_join.select(
    F.col("APMES.EMPLID"),
    F.col("APMES.ACAD_CAREER"),
    F.col("APMES.STDNT_CAR_NBR"),
    F.col("APMES.EFFDT"),
    F.col("APMES.EFFSEQ"),
    F.col("APMES.ACAD_PLAN"),
    F.col("APMES.DECLARE_DT"),
    F.col("APMES.PLAN_SEQUENCE"),
    F.col("APMES.REQ_TERM"),
    F.col("APMES.COMPLETION_TERM"),
    F.col("APMES.STDNT_DEGR"),
    F.col("APMES.DEGR_CHKOUT_STAT"),
    F.col("APMES.ADVIS_STATUS"),
    F.col("APMES.SSR_APT_INSTANCE"),
    F.col("APMES.SSR_YR_OF_PROG"),
    F.col("APMES.SCC_ROW_ADD_OPRID"),
    F.col("APMES.SCC_ROW_ADD_DTTM"),
    F.col("APMES.SCC_ROW_UPD_OPRID"),
    F.col("APMES.SCC_ROW_UPD_DTTM"),
    #F.col("APMES.READ_DTM"),
    #F.col("APMES.STAGE_UPDATE_ID"),
)


# Joins CBM1 classification info with the student's primary academic plan and term dimension to resolve the requirement term, then writes the final CBM1_REQ_TERM table.

# COMMAND ----------

apj = df_acad_plan_join.alias("APJ")

df_cbm1_req_term = ccinfo.join(
    apj,
    on=(
        (
            F.coalesce(F.col("CCInfo.EMPLID").cast("BIGINT"), F.lit(-1))
            == F.coalesce(F.col("APJ.EMPLID").cast("BIGINT"), F.lit(-1))
        )
        & (
            F.coalesce(F.col("CCInfo.STUDENT_CAREER_NBR").cast("BIGINT"), F.lit(-1))
            == F.coalesce(F.col("APJ.STDNT_CAR_NBR").cast("BIGINT"), F.lit(-1))
        )
        & (
            F.coalesce(F.trim(F.col("CCInfo.ACAD_CAREER")), F.lit(""))
            == F.coalesce(F.trim(F.col("APJ.ACAD_CAREER")), F.lit(""))
        )
    ),
    how="left",
).join(
    atd,
    on=(
        (
            F.coalesce(F.trim(F.col("CCInfo.ACAD_CAREER")), F.lit(""))
            == F.coalesce(F.trim(F.col("ATD.ACAD_CAREER")), F.lit(""))
        )
        & (
            F.coalesce(F.trim(F.col("APJ.REQ_TERM").cast("string")), F.lit(""))
            == F.coalesce(F.trim(F.col("ATD.STRM").cast("string")), F.lit(""))
        )
    ),
    how="left",
)

# COMMAND ----------


df_cbm1_req_term = (
    ccinfo.join(
        apj,
        on=(
            (
                F.coalesce(F.col("CCInfo.EMPLID").cast("BIGINT"), F.lit(-1))
                == F.coalesce(F.col("APJ.EMPLID").cast("BIGINT"), F.lit(-1))
            )
            & (
                F.coalesce(F.col("CCInfo.STUDENT_CAREER_NBR").cast("BIGINT"), F.lit(-1))
                == F.coalesce(F.col("APJ.STDNT_CAR_NBR").cast("BIGINT"), F.lit(-1))
            )
            & (
                F.coalesce(F.trim(F.col("CCInfo.ACAD_CAREER")), F.lit(""))
                == F.coalesce(F.trim(F.col("APJ.ACAD_CAREER")), F.lit(""))
            )
        ),
        how="left",
    )
    .join(
        atd,
        on=(
            (
                F.coalesce(F.trim(F.col("CCInfo.ACAD_CAREER")), F.lit(""))
                == F.coalesce(F.trim(F.col("ATD.ACAD_CAREER")), F.lit(""))
            )
            & (
                F.coalesce(F.trim(F.col("APJ.REQ_TERM").cast("string")), F.lit(""))
                == F.coalesce(F.trim(F.col("ATD.STRM").cast("string")), F.lit(""))
            )
        ),
        how="left",
    )
    .select(
        F.col("CCInfo.EMPLID").cast("string").alias("EMPLID"),
        F.col("CCInfo.TERM_SK").cast("bigint").alias("TERM_SK"),
        F.col("CCInfo.ACAD_PROGRAM_PRIMARY")
        .cast("bigint")
        .alias("ACAD_PROGRAM_PRIMARY"),
        F.col("CCInfo.ACAD_PROGRAM").cast("string").alias("ACAD_PROGRAM"),
        F.col("APJ.ACAD_PLAN").cast("string").alias("ACAD_PLAN"),
        F.col("CCInfo.ACAD_CAREER").cast("string").alias("ACAD_CAREER"),
        F.col("CCInfo.ACAD_LVL_LOAD_BOT").cast("string").alias("ACAD_LVL_LOAD_BOT"),
        F.col("CCInfo.SRVC_IND_CD").cast("string").alias("SRVC_IND_CD"),
        F.col("CCInfo.SRVC_IND_ACT_TERM").cast("string").alias("SRVC_IND_ACT_TERM"),
        F.when(
            F.col("CCInfo.SRVC_IND_DTTM").isNull()
            | F.col("CCInfo.SRVC_IND_DTTM").cast("string").isin(""),
            F.lit(None).cast("timestamp"),
        )
        .otherwise(F.col("CCInfo.SRVC_IND_DTTM").cast("timestamp"))
        .alias("SRVC_IND_DTTM"),
        F.col("CCInfo.INSTITUTION").cast("string").alias("INSTITUTION"),
        F.col("CCInfo.CLASS").cast("string").alias("CLASS"),
        F.col("CCInfo.CIP_CD").cast("string").alias("CIP_CD"),
        F.col("CCInfo.RESTRICTED").cast("string").alias("RESTRICTED"),
        F.col("CCInfo.NDS").cast("string").alias("NDS"),
        F.col("CCInfo.CIP_CD_UNEDITED").cast("string").alias("CIP_CD_UNEDITED"),
        F.col("CCInfo.STUDENT_CAREER_NBR").cast("bigint").alias("STUDENT_CAREER_NBR"),
        F.when(F.col("CCInfo.TERM_BEGIN_DT").cast("string").isin('9999-12-31', '9999-12-31 00:00:00'), F.lit(None)).otherwise(F.col("CCInfo.TERM_BEGIN_DT").cast("timestamp")).alias("TERM_BEGIN_DT"),
        F.col("CCInfo.STRM").cast("string").alias("STRM"),
        F.lit(None).cast("string").alias("ACAD_SUB_PLAN"),
        F.when(F.col("APJ.EFFDT").cast("string").isin('9999-12-31', '9999-12-31 00:00:00'), F.lit(None)).otherwise(F.col("APJ.EFFDT").cast("timestamp")).alias("EFFDT"),
        F.col("APJ.EFFSEQ").cast("bigint").alias("EFFSEQ"),
        F.col("ATD.TERM_BEGIN_DT").cast("timestamp").alias("Req_Term_Begin_Dt"),
        F.col("APJ.REQ_TERM").cast("string").alias("REQ_TERM"),
    )
)
write_df_to_table(
    df_cbm1_req_term,
    f"{analytics}.{staging}.fact_thecb_requirement_term",
    mode="overwrite",
)

# COMMAND ----------


# Define the ordered list of dependent notebooks to execute for each term
notebooks = ["transform_analytics_fact_thecb_undergraduate_degree_requirements", "transform_analytics_fact_thecb_cbm0c1_sch", "transform_analytics_fact_thecb_transfer_or_ftic"]

# Execute each notebook sequentially (one by one) to respect dependencies
# Each notebook must complete before the next one starts
for notebook in notebooks:
    try:
        print(f"  Running notebook: {notebook}")
        dbutils.notebook.run(notebook, 0, params)
        print(f"  Completed: {notebook}")
    except Exception as e:
        print(f"  Error in {notebook}: {str(e)}")
        raise

# COMMAND ----------

# =============================================================================
# SECTION 2: IDD ENROLLMENT FLAG
# =============================================================================
# Business Logic: Identify students enrolled in Intellectual and Developmental
# Disabilities (IDD) programs. A student is flagged IDD='2' if they have an active
# OSD status ('A') with diagnosis code '28' and item code 'DIA11'.
# Output: idd_enrollment_flag (one row per student/term/session)
cbm1_student_list = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0c1_student_list"
).alias("student_list")
osd_diagnosis = read_table(f"{student}.{bronze}.ps_UTA_OSD_STDDIAG").alias("osd_diag")
osd_student = read_table(f"{student}.{bronze}.ps_UTA_OSD_STDNT").alias("osd_stdnt")

# Left join to OSD diagnosis (code 28 / DIA11) and active OSD student status
idd_enrollment_flag = (
    cbm1_student_list.join(
        osd_diagnosis,
        (F.col("student_list.EMPLID") == F.col("osd_diag.EMPLID"))
        & (F.col("osd_diag.UTA_DIAGNOSIS") == F.lit("28"))
        & (F.col("osd_diag.UTA_ITEM_CD") == F.lit("DIA11")),
        "left",
    )
    .join(
        osd_student,
        (F.col("student_list.EMPLID") == F.col("osd_stdnt.EMPLID"))
        & (F.col("osd_stdnt.UTA_OSD_STATUS") == F.lit("A")),
        "left",
    )
    .select(
        F.col("student_list.EMPLID"),
        F.col("student_list.INSTITUTION"),
        F.col("student_list.ACAD_CAREER_SK"),
        F.col("student_list.TERM_SK"),
        F.col("student_list.FLEX"),
        F.col("student_list.SESSION_CD"),
        F.col("student_list.STRM"),
        # IDD flag: '2' if diagnosis 28/DIA11 with active OSD status, else '0'
        F.when(
            (F.col("osd_diag.UTA_DIAGNOSIS") == F.lit("28"))
            & (F.col("osd_diag.UTA_ITEM_CD") == F.lit("DIA11"))
            & (F.col("osd_stdnt.UTA_OSD_STATUS") == F.lit("A")),
            F.lit("2"),
        )
        .otherwise(F.lit("0"))
        .alias("IDD_Enrolled_IDD_Pgm"),
    )
)
# Checkpoint 1: Persist IDD flag to staging table for lineage cut and downstream join performance
_tmp_stage1_tbl = f"{analytics}.{staging}.tmp_idd_enrollment_400_LOAD_CBM0E1"
write_df_to_table(
    idd_enrollment_flag, _tmp_stage1_tbl, mode="overwrite", overwriteSchema="true"
)
idd_enrollment_flag = read_table(_tmp_stage1_tbl).alias("idd")
log_msg(
    f"Checkpoint 1 materialized: {_tmp_stage1_tbl} — row count: {get_count(idd_enrollment_flag)}"
)

# COMMAND ----------

# =============================================================================
# SECTION 3: SEVF ADDRESS — SERVICE VERIFICATION ADDRESSES
# =============================================================================
# Business Logic: Retrieve the most recent active SEVF (Service Verification)
# address per student/city. SEVF addresses override standard HOME addresses
# for residency determination when a student has foreign ties.
# Window: MAX(EFFDT) partitioned by EMPLID + CITY to get latest record.
ps_addresses_raw = read_table(f"{student}.{bronze}.ps_ADDRESSES").alias("addr")

# Window to find the latest effective date per student/city for SEVF addresses
sevf_latest_effdt_window = Window.partitionBy(F.col("addr.EMPLID"), F.col("addr.CITY"))

sevf_addresses = (
    ps_addresses_raw
    # Filter: only SEVF address type with active status
    .filter(
        (F.col("addr.ADDRESS_TYPE") == F.lit("SEVF"))
        & (F.col("addr.EFF_STATUS") == F.lit("A"))
    )
    # Add max effective date per student/city partition
    .withColumn("_max_effdt", F.max(F.col("addr.EFFDT")).over(sevf_latest_effdt_window))
    # Keep only the row with the latest effective date
    .filter(
        F.coalesce(F.col("addr.EFFDT"), F.current_date())
        == F.coalesce(F.col("_max_effdt"), F.current_date())
    )
    .drop("_max_effdt")
    .select(
        F.col("addr.ADDR_FIELD1"),
        F.col("addr.ADDRESS_TYPE"),
        F.col("addr.ADDRESS1"),
        F.col("addr.ADDRESS2"),
        F.col("addr.ADDRESS3"),
        F.col("addr.ADDRESS4"),
        F.col("addr.CITY"),
        F.col("addr.COUNTRY"),
        F.col("addr.COUNTY"),
        F.col("addr.EFF_STATUS"),
        F.col("addr.EFFDT"),
        F.col("addr.EMPLID"),
        F.col("addr.POSTAL"),
        F.col("addr.STATE"),
    )
    .distinct()
)

log_msg(f"SEVF addresses row count: {get_count(sevf_addresses)}")

# COMMAND ----------

# =============================================================================
# SECTION 4: RESIDENCE DETERMINATION
# =============================================================================
# Business Logic: Determine each student's STATE, COUNTRY, UTA_RESIDENCE_CD, and
# COUNTY_CD for THECB reporting. Uses a priority chain:
#   1. Self-reported residency (PS_RESIDENCY_SELF)
#   2. Official residency determination (PS_RESIDENCY_OFF)
#   3. HOME address (PS_ADDRESSES)
# If SEVF country is foreign but primary country is USA, the SEVF country overrides.
# Joins to PS_UTA_CC_CB_STATE and PS_UTA_CC_CB_CNTRY for THECB code translation.
# Window functions find the MAX effective date per partition to get latest records.

# Load student list with FLEX-adjusted TERM_SK for term dimension lookup
student_list_with_flex_sk = (
    read_table(f"{analytics}.{staging}.fact_thecb_cbm0c1_student_list")
    .alias("sl")
    .withColumn(
        "new_term_sk",
        F.when(
            F.coalesce(F.col("sl.FLEX"), F.lit("")) > F.lit("0"),
            F.col("sl.TERM_SK").cast("int") + F.lit(2),
        ).otherwise(F.col("sl.TERM_SK")),
    )
)
# Reference dimension tables
adw_term_dim_res = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_dim")
adw_career_dim_res = read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias(
    "car_dim"
)

# Residency source tables
ps_residency_self = read_table(f"{student}.{bronze}.ps_RESIDENCY_SELF").alias(
    "res_self"
)
ps_residency_off = read_table(f"{student}.{bronze}.ps_RESIDENCY_OFF").alias("res_off")
ps_addr_home = read_table(f"{student}.{bronze}.ps_ADDRESSES").alias("addr_home")
# THECB code translation tables
ps_cc_state = read_table(f"{student}.{bronze}.ps_UTA_CC_CB_STATE").alias("cc_state")
ps_cc_cntry = read_table(f"{student}.{bronze}.ps_UTA_CC_CB_CNTRY").alias("cc_cntry")
ps_tx_cnty = read_table(f"{student}.{bronze}.ps_UTA_TX_CNTY_TBL").select(
    F.col("COUNTY"),
    F.col("COUNTY").substr(1, 3).alias("COUNTY_CD"),
    F.col("COUNTY").substr(4, 100).alias("COUNTY_NAME")
).alias("tx_cnty")

# Windows to find latest record per student/career/term/flex partition
residence_partition_cols = [
    F.col("sl.ACAD_CAREER_SK"),
    F.col("sl.TERM_SK"),
    F.col("sl.FLEX"),
    F.col("sl.EMPLID"),
]
self_report_window = Window.partitionBy(*residence_partition_cols)
residency_off_window = Window.partitionBy(*residence_partition_cols)
home_addr_window = Window.partitionBy(*residence_partition_cols)

# Build enriched student record with all residency sources joined
student_residency_enriched = (
    student_list_with_flex_sk.alias("sl")
    # Join term dimension using FLEX-adjusted TERM_SK and INSTITUTION
    .join(
        adw_term_dim_res,
        (F.col("sl.new_term_sk") == F.col("term_dim.TERM_SK"))
        & (F.col("sl.INSTITUTION") == F.col("term_dim.INSTITUTION")),
        "left",
    )
    # Join academic career dimension for ACAD_CAREER value
    .join(
        adw_career_dim_res,
        F.col("sl.ACAD_CAREER_SK") == F.col("car_dim.ACAD_CAREER_SK"),
        "left",
    )
    # Join self-reported residency (must be reported before term end)
    .join(
        ps_residency_self,
        (F.col("sl.EMPLID") == F.col("res_self.EMPLID"))
        & (
            F.to_date(F.col("res_self.SELF_REPORT_DT"))
            <= F.to_date(F.col("term_dim.TERM_END_DT"))
        ),
        "left",
    )
    # Join official residency (matching career, effective term <= current term)
    .join(
        ps_residency_off,
        (F.col("sl.EMPLID") == F.col("res_off.EMPLID"))
        & (F.col("car_dim.ACAD_CAREER") == F.col("res_off.ACAD_CAREER"))
        & (F.col("res_off.EFFECTIVE_TERM") <= F.col("term_dim.STRM")),
        "left",
    )
    # Join SEVF address (matching city from residency_off, effective before term end)
    .join(
        sevf_addresses.alias("sevf"),
        (F.col("sl.EMPLID") == F.col("sevf.EMPLID"))
        & (F.to_date(F.col("sevf.EFFDT")) <= F.to_date(F.col("term_dim.TERM_END_DT")))
        & (F.col("res_off.CITY").eqNullSafe(F.col("sevf.CITY"))),
        "left",
    )
    # Join HOME address (active, effective before term end)
    .join(
        ps_addr_home,
        (F.col("sl.EMPLID") == F.col("addr_home.EMPLID"))
        & (F.col("addr_home.ADDRESS_TYPE") == F.lit("HOME"))
        & (
            F.to_date(F.col("addr_home.EFFDT"))
            <= F.to_date(F.col("term_dim.TERM_END_DT"))
        )
        & (F.col("addr_home.EFF_STATUS") == F.lit("A")),
        "left",
    )
    # Pre-compute join key for PS_UTA_CC_CB_STATE:
    # If primary country = USA but SEVF country is foreign → blank state (foreign override)
    # Otherwise → use COALESCE priority: self-reported, official, home address state
    .withColumn(
        "_state_join_key",
        F.when(
            (
                F.coalesce(
                    F.col("res_self.COUNTRY"),
                    F.col("res_off.COUNTRY"),
                    F.col("addr_home.COUNTRY"),
                    F.lit(""),
                )
                == F.lit("USA")
            )
            & (~F.trim(F.coalesce(F.col("sevf.COUNTRY"), F.lit(""))).isin("USA", "")),
            F.lit(""),
        ).otherwise(
            F.coalesce(
                F.col("res_self.STATE"),
                F.col("res_off.STATE"),
                F.col("addr_home.STATE"),
                F.lit(""),
            )
        ),
    )
    # Pre-compute join key for PS_UTA_CC_CB_CNTRY:
    # If primary country = USA but SEVF country is foreign → use SEVF country
    # Otherwise → use COALESCE priority chain for country
    .withColumn(
        "_country_join_key",
        F.when(
            (
                F.coalesce(
                    F.col("res_self.COUNTRY"),
                    F.col("res_off.COUNTRY"),
                    F.col("addr_home.COUNTRY"),
                    F.lit(""),
                )
                == F.lit("USA")
            )
            & (~F.trim(F.coalesce(F.col("sevf.COUNTRY"), F.lit(""))).isin("USA", "")),
            F.col("sevf.COUNTRY"),
        ).otherwise(
            F.coalesce(
                F.col("res_self.COUNTRY"),
                F.col("res_off.COUNTRY"),
                F.col("addr_home.COUNTRY"),
                F.lit(""),
            )
        ),
    )
    # Pre-compute county name key for PS_UTA_TX_CNTY_TBL:
    # If county starts with digits (e.g., "123Harris"), strip numeric prefix
    .withColumn(
        "_county_name_key",
        F.when(
            F.col("addr_home.COUNTY").substr(1, 3).rlike("[0-9]"),
            F.upper(F.col("addr_home.COUNTY").substr(4, 100)),
        ).otherwise(F.upper(F.col("addr_home.COUNTY"))),
    )
    # Join THECB state code lookup (active records only)
    .join(
        ps_cc_state.filter(F.col("cc_state.EFF_STATUS") == F.lit("A")),
        F.col("_state_join_key") == F.col("cc_state.STATE"),
        "left",
    )
    # Join THECB country code lookup (active records only)
    .join(
        ps_cc_cntry.filter(F.col("cc_cntry.EFF_STATUS") == F.lit("A")),
        F.col("_country_join_key") == F.col("cc_cntry.COUNTRY"),
        "left",
    )
    # Join Texas county code table for in-state county resolution
    .join(ps_tx_cnty, F.col("_county_name_key") == F.col("tx_cnty.COUNTY_NAME"), "left")
    # Window aggregates: find latest self_report_dt, effective_term, and address effdt
    .withColumn(
        "max_self_report_dt",
        F.max(F.col("res_self.SELF_REPORT_DT")).over(self_report_window),
    )
    .withColumn(
        "max_effective_term",
        F.max(F.col("res_off.EFFECTIVE_TERM")).over(residency_off_window),
    )
    .withColumn("max_effdt", F.max(F.col("addr_home.EFFDT")).over(home_addr_window))
)

# COMMAND ----------

# Filter to keep only the latest residency records per partition,
# then derive final STATE, COUNTRY, UTA_RESIDENCE_CD, COUNTY_CD
residence_detail = (
    student_residency_enriched.filter(
        (
            F.coalesce(F.col("res_self.SELF_REPORT_DT"), F.current_date())
            == F.coalesce(F.col("max_self_report_dt"), F.current_date())
        )
        & (
            F.coalesce(F.col("res_off.EFFECTIVE_TERM"), F.lit(""))
            == F.coalesce(F.col("max_effective_term"), F.lit(""))
        )
        & (
            F.coalesce(F.col("addr_home.EFFDT"), F.current_date())
            == F.coalesce(F.col("max_effdt"), F.current_date())
        )
    )
    .select(
        F.col("sl.EMPLID"),
        # TERM_SK: adjust for FLEX='1' students (shift by +2)
        F.when(
            F.coalesce(F.col("sl.FLEX"), F.lit("")) == F.lit("1"),
            (F.col("sl.TERM_SK").cast("int") + F.lit(2)).cast("long"),
        )
        .otherwise(F.col("sl.TERM_SK"))
        .alias("TERM_SK"),
        F.col("sl.ACAD_CAREER_SK"),
        # STATE: blank if foreign SEVF override applies, else priority chain
        F.when(
            (
                F.coalesce(
                    F.col("res_self.COUNTRY"),
                    F.col("res_off.COUNTRY"),
                    F.col("addr_home.COUNTRY"),
                    F.lit(""),
                )
                == F.lit("USA")
            )
            & (~F.trim(F.coalesce(F.col("sevf.COUNTRY"), F.lit(""))).isin("USA", "")),
            F.lit(""),
        )
        .otherwise(
            F.coalesce(
                F.col("res_self.STATE"),
                F.col("res_off.STATE"),
                F.col("addr_home.STATE"),
                F.lit(""),
            )
        )
        .alias("STATE"),
        # COUNTRY: SEVF country if foreign override, else priority chain
        F.when(
            (
                F.coalesce(
                    F.col("res_self.COUNTRY"),
                    F.col("res_off.COUNTRY"),
                    F.col("addr_home.COUNTRY"),
                    F.lit(""),
                )
                == F.lit("USA")
            )
            & (~F.trim(F.coalesce(F.col("sevf.COUNTRY"), F.lit(""))).isin("USA", "")),
            F.coalesce(F.col("sevf.COUNTRY"), F.lit("")),
        )
        .otherwise(
            F.coalesce(
                F.col("res_self.COUNTRY"),
                F.col("res_off.COUNTRY"),
                F.col("addr_home.COUNTRY"),
                F.lit(""),
            )
        )
        .alias("COUNTRY"),
        F.col("res_off.RESIDENCY"),
        F.col("addr_home.STATE").alias("ADDR_STATE"),
        # UTA_RESIDENCE_CD: THECB residence code derivation
        # Foreign → country code; TX resident → county prefix; other US state → state code
        F.when(
            F.upper(F.col("res_self.COUNTRY")) != F.lit("USA"),
            F.col("cc_cntry.UTA_CC_THECB_CD"),
        )
        .when(
            (F.col("res_self.COUNTRY") == F.lit("USA"))
            & (~F.coalesce(F.trim(F.col("sevf.COUNTRY")), F.lit("")).isin("")),
            F.col("cc_cntry.UTA_CC_THECB_CD"),
        )
        .when(
            (F.col("res_self.COUNTRY") == F.lit("USA"))
            & (F.upper(F.trim(F.col("res_self.STATE"))) == F.lit("TX")),
            F.col("res_self.COUNTY").substr(1, 3),
        )
        .when(
            (F.col("res_self.COUNTRY") == F.lit("USA"))
            & (F.upper(F.trim(F.col("res_self.STATE"))) != F.lit("TX")),
            F.col("cc_state.UTA_CC_THECB_CD"),
        )
        .otherwise(F.lit(""))
        .alias("UTA_RESIDENCE_CD"),
        # COUNTY_CD: THECB county code using cascading priority
        # Foreign/SEVF foreign → country code
        # USA non-TX → state code
        # USA TX with self/official county → first 3 chars of county
        # USA TX fallback → PS_UTA_TX_CNTY_TBL county_cd
        F.when(
            (
                F.coalesce(
                    F.col("res_self.COUNTRY"),
                    F.col("res_off.COUNTRY"),
                    F.col("addr_home.COUNTRY"),
                    F.lit(""),
                )
                != F.lit("USA")
            )
            | (
                (
                    F.coalesce(
                        F.col("res_self.COUNTRY"),
                        F.col("res_off.COUNTRY"),
                        F.col("addr_home.COUNTRY"),
                        F.lit(""),
                    )
                    == F.lit("USA")
                )
                & (
                    ~F.trim(F.coalesce(F.col("sevf.COUNTRY"), F.lit(""))).isin(
                        "USA", ""
                    )
                )
            ),
            F.col("cc_cntry.UTA_CC_THECB_CD"),
        )
        .when(
            (
                F.coalesce(
                    F.col("res_self.COUNTRY"),
                    F.col("res_off.COUNTRY"),
                    F.col("addr_home.COUNTRY"),
                    F.lit(""),
                )
                == F.lit("USA")
            )
            & (
                F.coalesce(
                    F.col("res_self.STATE"),
                    F.col("res_off.STATE"),
                    F.col("addr_home.STATE"),
                    F.lit(""),
                )
                != F.lit("TX")
            ),
            F.col("cc_state.UTA_CC_THECB_CD"),
        )
        .when(
            (
                F.coalesce(
                    F.col("res_self.COUNTRY"),
                    F.col("res_off.COUNTRY"),
                    F.col("addr_home.COUNTRY"),
                    F.lit(""),
                )
                == F.lit("USA")
            )
            & (
                F.coalesce(F.col("res_self.STATE"), F.col("res_off.STATE"), F.lit(""))
                == F.lit("TX")
            )
            & (
                F.coalesce(
                    F.col("res_self.COUNTY").substr(1, 3),
                    F.col("res_off.COUNTY").substr(1, 3),
                    F.lit(""),
                )
                != F.lit("")
            ),
            F.coalesce(
                F.col("res_self.COUNTY").substr(1, 3),
                F.col("res_off.COUNTY").substr(1, 3),
            ),
        )
        .when(
            (
                F.coalesce(
                    F.col("res_self.COUNTRY"),
                    F.col("res_off.COUNTRY"),
                    F.col("addr_home.COUNTRY"),
                    F.lit(""),
                )
                == F.lit("USA")
            )
            & (
                F.coalesce(
                    F.col("res_self.STATE"),
                    F.col("res_off.STATE"),
                    F.col("addr_home.STATE"),
                    F.lit(""),
                )
                == F.lit("TX")
            ),
            F.col("tx_cnty.COUNTY_CD"),
        )
        .otherwise(F.lit(""))
        .alias("COUNTY_CD"),
        F.col("addr_home.COUNTY").alias("COUNTY_PSADDRESS"),
        F.col("addr_home.EFFDT").alias("EFFDT_PSADDRESS"),
        F.col("res_off.COUNTY").alias("COUNTY_OFF"),
        F.col("addr_home.COUNTY").substr(4, 100).alias("COUNTY_SUBSTRPSADDRESS"),
        F.col("tx_cnty.COUNTY_CD").alias("extract_cd"),
        F.col("sl.FLEX"),
        F.col("sl.TERM_SK").alias("TERM_SK_UNMODIFIED"),
        F.col("res_self.SELF_REPORT_DT"),
        F.col("res_off.EFFECTIVE_TERM"),
        F.col("addr_home.EFFDT").alias("EFFDT"),
        F.col("res_off.ADMISSION_EXCPT"),
    )
    .distinct()
)

# COMMAND ----------

# Checkpoint 2: Persist residence detail — reused 3x downstream (residence_subset, student_assembly, cbm0e1_detail)
_tmp_stage2_tbl = f"{analytics}.{staging}.tmp_residence_detail_400_LOAD_CBM0E1"
write_df_to_table(
    residence_detail, _tmp_stage2_tbl, mode="overwrite", overwriteSchema="true"
)
residence_detail = read_table(_tmp_stage2_tbl).alias("res_detail")
log_msg(
    f"Checkpoint 2 materialized: {_tmp_stage2_tbl} — row count: {get_count(residence_detail)}"
)

# COMMAND ----------

# Residence subset — columns needed for the FLEX-adjusted term join in final assembly
# This subset uses the unmodified TERM_SK for direct joins (W12707R8L equivalent)
residence_subset = (
    residence_detail.alias("wjse")
    .select(
        F.col("wjse.EMPLID"),
        F.col("wjse.TERM_SK"),
        F.col("wjse.ACAD_CAREER_SK"),
        F.col("wjse.STATE"),
        F.col("wjse.COUNTRY"),
        F.col("wjse.RESIDENCY"),
        F.col("wjse.ADDR_STATE"),
        F.col("wjse.UTA_RESIDENCE_CD"),
        F.col("wjse.COUNTY_CD"),
        F.col("wjse.COUNTY_PSADDRESS"),
        F.col("wjse.EFFDT_PSADDRESS"),
        F.col("wjse.COUNTY_OFF"),
        F.col("wjse.COUNTY_SUBSTRPSADDRESS"),
        F.col("wjse.extract_cd"),
    )
    .distinct()
)

log_msg(f"Residence subset row count: {get_count(residence_subset)}")

# COMMAND ----------

# =============================================================================
# SECTION 5: DOCTORAL FUNDING CODE (DOCFNDCD)
# =============================================================================
# Business Logic: For doctoral-level students (CLASS='7'), determine the doctoral
# funding code from the CIP (Classification of Instructional Programs) data.
# Only courses with catalog numbers starting with 6/7, or 5-level courses with
# CLVL attribute value '6', qualify. The DOCFNDCD is extracted from positions 12-13
# of CIP_ALTERNATIVE_CD. Uses ROW_NUMBER to get the latest CRSE_ATTR effective date
# per class, then aggregates UNIT_TAKEN (SCH) by DOCFNDCD.
# Final dedup keeps one DOCFNDCD per EMPLID/TERM_SK/FLEX (minimum CLASS_NBR wins).
cbm1_class_info = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0c1_class_info"
).alias("class_info")
cbm1_classification = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0c1_classification_info"
).alias("classif")
adw_term_dim_doc = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_doc")
adw_class_schedule = read_table(
    f"{analytics}.{staging}.fact_thecb_class_schedule"
).alias("cls_sched")
adw_course_offer = read_table(f"{analytics}.{silver}.dim_thecb_course_offer").alias(
    "crs_offer"
)
adw_cip_dim = read_table(f"{analytics}.{silver}.dim_thecb_cip_code").alias("cip_dim")
ps_course_attributes = read_table(f"{student}.{bronze}.ps_CRSE_ATTRIBUTES").alias(
    "crse_attr"
)

# Window: pick the latest CRSE_ATTR effective date per student/term/class/flex
attr_row_number_window = Window.partitionBy(
    F.col("class_info.EMPLID"),
    F.col("class_info.TERM_SK"),
    F.col("class_info.CLASS_NBR"),
    F.col("class_info.FLEX"),
).orderBy(F.col("crse_attr.EFFDT").desc())

# Build doctoral class records with CIP-derived funding code
doctoral_class_raw = (
    cbm1_class_info.join(
        adw_term_dim_doc,
        F.col("class_info.TERM_SK") == F.col("term_doc.TERM_SK"),
        "left",
    )
    .join(
        adw_class_schedule,
        (F.col("class_info.CLASS_NBR") == F.col("cls_sched.CLASS_NBR"))
        & (F.col("class_info.TERM_SK") == F.col("cls_sched.TERM_SK")),
        "left",
    )
    .join(
        adw_course_offer,
        F.col("cls_sched.COURSE_OFFER_SK") == F.col("crs_offer.COURSE_OFFER_SK"),
        "left",
    )
    # Join course attributes: only CLVL='6' records effective before term end
    .join(
        ps_course_attributes,
        (F.col("crs_offer.COURSE_IDENTIFIER") == F.col("crse_attr.CRSE_ID"))
        & (F.col("crse_attr.CRSE_ATTR") == F.lit("CLVL"))
        & (F.col("crse_attr.CRSE_ATTR_VALUE") == F.lit("6"))
        & (F.col("crse_attr.EFFDT") <= F.col("term_doc.TERM_END_DT")),
        "left",
    )
    # Join classification to filter doctoral students (CLASS='7')
    .join(
        cbm1_classification,
        (F.col("class_info.EMPLID") == F.col("classif.EMPLID"))
        & (F.col("class_info.TERM_SK") == F.col("classif.TERM_SK")),
        "left",
    )
    # Join CIP dimension for CIP_ALTERNATIVE_CD (current row only)
    .join(
        adw_cip_dim.filter(F.col("cip_dim.is_current") == F.lit(True)),
        F.col("crs_offer.CIP_CD") == F.col("cip_dim.CIP_CD"),
        "left",
    )
    # Filter: doctoral students, qualifying catalog numbers, current CIP, post-term 378
    .filter(
        (F.col("classif.CLASS") == F.lit("7"))
        & (
            F.col("cls_sched.CATALOG_NBR").substr(1, 1).isin("6", "7")
            | (
                (F.col("cls_sched.CATALOG_NBR").substr(1, 1) == F.lit("5"))
                & (F.col("crse_attr.CRSE_ATTR") == F.lit("CLVL"))
                & (F.col("crse_attr.CRSE_ATTR_VALUE") == F.lit("6"))
            )
        )
        & (F.col("cip_dim.is_current") == F.lit(True))
        & (F.col("class_info.TERM_SK") > F.lit(378))
    )
    # Keep only the latest CRSE_ATTR record per class
    .withColumn("attr_rn", F.row_number().over(attr_row_number_window))
    .filter(F.col("attr_rn") == F.lit(1))
    # Extract doctoral funding code from CIP_ALTERNATIVE_CD positions 12-13
    .withColumn("DOCFNDCD", F.col("cip_dim.CIP_ALTERNATIVE_CD").substr(12, 2))
)

# Aggregate: sum UNIT_TAKEN per EMPLID/TERM_SK/FLEX/DOCFNDCD, dedup by min CLASS_NBR
doc_unit_agg_window = Window.partitionBy(
    F.col("class_info.EMPLID"),
    F.col("class_info.TERM_SK"),
    F.col("class_info.FLEX"),
    F.col("DOCFNDCD"),
)

# COMMAND ----------

doctoral_with_aggregates = doctoral_class_raw.withColumn(
    "UNIT_DOC", F.sum(F.col("class_info.UNIT_TAKEN")).over(doc_unit_agg_window)
).withColumn(
    "min_class_nbr_doc", F.min(F.col("class_info.CLASS_NBR")).over(doc_unit_agg_window)
)

# Keep one row per DOCFNDCD partition (where CLASS_NBR = min in partition)
doctoral_deduped = (
    doctoral_with_aggregates.filter(
        F.coalesce(F.col("class_info.CLASS_NBR"), F.lit(""))
        == F.coalesce(F.col("min_class_nbr_doc"), F.lit(""))
    )
    .select(
        F.col("class_info.EMPLID"),
        F.col("class_info.TERM_SK"),
        F.col("class_info.FLEX"),
        F.col("DOCFNDCD"),
        F.col("UNIT_DOC"),
        F.col("class_info.CLASS_NBR"),
    )
    .distinct()
)

# COMMAND ----------

# Final dedup: one DOCFNDCD per EMPLID/TERM_SK/FLEX (min CLASS_NBR wins across DOCFNDCDs)
doctoral_final_window = Window.partitionBy(
    F.col("EMPLID"), F.col("TERM_SK"), F.col("FLEX")
)

doctoral_funding_code_filter = doctoral_deduped.filter(
    ~F.col("DOCFNDCD").isin(["18", "13", "12", "08", "19"])
)

doctoral_funding_code = (
    doctoral_funding_code_filter.withColumn(
        "_min_class_nbr", F.min(F.col("CLASS_NBR")).over(doctoral_final_window)
    )
    .filter(
        F.coalesce(F.col("CLASS_NBR"), F.lit(""))
        == F.coalesce(F.col("_min_class_nbr"), F.lit(""))
    )
    .drop("_min_class_nbr")
    .distinct()
)
# Checkpoint 3: Persist doctoral funding code — complex multi-table join with ROW_NUMBER
_tmp_stage3_tbl = f"{analytics}.{staging}.tmp_doctoral_funding_code_400_LOAD_CBM0E1"
write_df_to_table(
    doctoral_funding_code, _tmp_stage3_tbl, mode="overwrite", overwriteSchema="true"
)
doctoral_funding_code = read_table(_tmp_stage3_tbl).alias("dfc")
log_msg(
    f"Checkpoint 3 materialized: {_tmp_stage3_tbl} — row count: {get_count(doctoral_funding_code)}"
)

# COMMAND ----------

# =============================================================================
# SECTION 6: ETHNIC GROUP AND RACE CODES
# =============================================================================
# Business Logic: Map each student's ethnicity/race for THECB reporting.
# Uses PS_HCR_ETHNIC_GRP_I (latest effective date per code/setid) joined to
# PS_HCR_DIV_ETHNIC_I (student diversity records). Maps ETHNIC_GROUP to:
#   '3' (Hispanic) → ETHNIC_GRP='1'
#   All others → ETHNIC_GRP='3' (non-Hispanic)
# Individual race flags: WHITE(1), BLACK(2), ASIAN(4), AM_IND(5), UNKNOWN(7), NAT_HAWN(8)
# Final aggregation: one row per EMPLID with MIN ethnic group and MAX of each race flag.
ps_ethnic_grp = read_table(f"{student}.{bronze}.ps_hcr_ethnic_grp_i").alias("eg")

# Window: latest effective date per ETHNIC_GRP_CD / SETID
ethnic_grp_effdt_window = Window.partitionBy(
    F.col("eg.ETHNIC_GRP_CD"), F.col("eg.SETID")
)

# Get latest ethnic group reference record
ethnic_group_latest = (
    ps_ethnic_grp.withColumn(
        "_max_effdt", F.max(F.col("eg.EFFDT")).over(ethnic_grp_effdt_window)
    )
    .filter(
        F.coalesce(F.col("eg.EFFDT"), F.current_date())
        == F.coalesce(F.col("_max_effdt"), F.current_date())
    )
    .drop("_max_effdt")
    .select(
        F.col("eg.EFFDT"),
        F.col("eg.ETHNIC_GRP_CD"),
        F.col("eg.ETHNIC_GROUP"),
        F.col("eg.SETID"),
    )
    .distinct()
)

log_msg(f"Ethnic group latest row count: {get_count(ethnic_group_latest)}")

# COMMAND ----------

# Map ethnic/race codes per student (raw: one row per EMPLID/diversity record)
student_list_ethnic = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0c1_student_list"
).alias("sl_ethn")
ps_div_ethnic = read_table(f"{student}.{bronze}.ps_hcr_div_ethnic_i").alias("div_eth")

ethnic_race_per_record = (
    student_list_ethnic.join(
        ps_div_ethnic, F.col("sl_ethn.EMPLID") == F.col("div_eth.EMPLID"), "left"
    )
    .join(
        ethnic_group_latest.alias("egt"),
        F.coalesce(F.col("div_eth.ETHNIC_GRP_CD"), F.lit(""))
        == F.coalesce(F.col("egt.ETHNIC_GRP_CD"), F.lit("")),
        "left",
    )
    .select(
        F.col("sl_ethn.EMPLID"),
        # ETHNIC_GRP: '1' if Hispanic (group=3), else '3' (non-Hispanic)
        F.when(F.col("egt.ETHNIC_GROUP") == F.lit("3"), F.lit("1"))
        .otherwise(F.lit("3"))
        .alias("ETHNIC_GRP"),
        # Individual race flags (null if not matching)
        F.when(F.col("egt.ETHNIC_GROUP") == F.lit("1"), F.lit("1"))
        .otherwise(F.lit(None).cast("string"))
        .alias("RACE_WHITE"),
        F.when(F.col("egt.ETHNIC_GROUP") == F.lit("2"), F.lit("2"))
        .otherwise(F.lit(None).cast("string"))
        .alias("RACE_BLACK"),
        F.when(F.col("egt.ETHNIC_GROUP") == F.lit("4"), F.lit("4"))
        .otherwise(F.lit(None).cast("string"))
        .alias("RACE_ASIAN"),
        F.when(F.col("egt.ETHNIC_GROUP") == F.lit("5"), F.lit("5"))
        .otherwise(F.lit(None).cast("string"))
        .alias("RACE_AmIndAlsknNatv"),
        # RACE_UNKNOWN: '7' for group 7 or any unrecognized group code
        F.when(
            (F.col("egt.ETHNIC_GROUP") == F.lit("7"))
            | (~F.col("egt.ETHNIC_GROUP").isin("1", "2", "3", "4", "5", "7", "8")),
            F.lit("7"),
        )
        .otherwise(F.lit(" "))
        .alias("RACE_UnknwnNotRptd"),
        F.when(F.col("egt.ETHNIC_GROUP") == F.lit("8"), F.lit("8"))
        .otherwise(F.lit(None).cast("string"))
        .alias("RACE_NatHawnOPI"),
    )
    .distinct()
)

log_msg(f"Ethnic race per record row count: {get_count(ethnic_race_per_record)}")

# COMMAND ----------

# Aggregate ethnic/race per student — one row per EMPLID
# MIN gives priority to '1' (Hispanic) over '3' (non-Hispanic) for ETHNIC_GRP
# MAX picks up any race flag present across all diversity records
ethnic_race_aggregated = (
    ethnic_race_per_record.alias("er")
    .filter(
        F.col("er.RACE_WHITE").isNotNull()
        | F.col("er.ETHNIC_GRP").isNotNull()
        | F.col("er.RACE_BLACK").isNotNull()
        | F.col("er.RACE_ASIAN").isNotNull()
        | F.col("er.RACE_AmIndAlsknNatv").isNotNull()
        | F.col("er.RACE_UnknwnNotRptd").isNotNull()
        | F.col("er.RACE_NatHawnOPI").isNotNull()
    )
    .groupBy("EMPLID")
    .agg(
        F.min("ETHNIC_GRP").alias("ETHNIC_GRP"),
        F.max("RACE_WHITE").alias("RACE_WHITE"),
        F.max("RACE_BLACK").alias("RACE_BLACK"),
        F.max("RACE_ASIAN").alias("RACE_ASIAN"),
        F.max("RACE_AmIndAlsknNatv").alias("RACE_AmIndAlsknNatv"),
        F.max("RACE_UnknwnNotRptd").alias("RACE_UnknwnNotRptd"),
        F.max("RACE_NatHawnOPI").alias("RACE_NatHawnOPI"),
    )
)
# Checkpoint 4: Persist ethnic/race aggregation — used in student assembly
_tmp_stage4_tbl = f"{analytics}.{staging}.tmp_ethnic_race_aggregated_400_LOAD_CBM0E1"
write_df_to_table(
    ethnic_race_aggregated, _tmp_stage4_tbl, mode="overwrite", overwriteSchema="true"
)
ethnic_race_aggregated = read_table(_tmp_stage4_tbl).alias("era")
log_msg(
    f"Checkpoint 4 materialized: {_tmp_stage4_tbl} — row count: {get_count(ethnic_race_aggregated)}"
)

# COMMAND ----------

# =============================================================================
# SECTION 7: CAP INDICATOR (UCAP/UCOO PROGRAM HISTORY)
# =============================================================================
# Business Logic: Determine the CAP (Competitive Academic Progress) indicator.
# CAP=6 when a student has a UCAP admission but NO subsequent UCOO (plan change
# to cooperative education) within the same academic year window.
# mod_strm routes Fall/Spring terms back to the prior Summer for window boundary.
# Lower bound varies: Summer→same term, Fall→next Summer, Spring→prior Summer.
# UCOO program history — UGRD PLNC UCOO records
ps_acad_prog_ucoo = read_table(f"{student}.{bronze}.ps_ACAD_PROG").alias("ap_ucoo")

ucoo_program_history = (
    ps_acad_prog_ucoo.filter(
        (F.col("ap_ucoo.ACAD_CAREER") == F.lit("UGRD"))
        & (F.col("ap_ucoo.PROG_ACTION") == F.lit("PLNC"))
        & (F.col("ap_ucoo.PROG_REASON") == F.lit("UCOO"))
    )
    .select(
        F.col("ap_ucoo.EMPLID"),
        F.col("ap_ucoo.ACAD_CAREER"),
        F.col("ap_ucoo.STDNT_CAR_NBR"),
        F.col("ap_ucoo.EFFDT"),
        F.col("ap_ucoo.EFFSEQ"),
        F.col("ap_ucoo.INSTITUTION"),
        F.col("ap_ucoo.ACAD_PROG"),
        F.col("ap_ucoo.PROG_STATUS"),
        F.col("ap_ucoo.PROG_ACTION"),
        F.col("ap_ucoo.ACTION_DT"),
        F.col("ap_ucoo.PROG_REASON"),
        F.col("ap_ucoo.ADMIT_TERM"),
        F.col("ap_ucoo.EXP_GRAD_TERM"),
        F.col("ap_ucoo.REQ_TERM"),
        F.col("ap_ucoo.ACAD_LOAD_APPR"),
        F.col("ap_ucoo.CAMPUS"),
        F.col("ap_ucoo.DEGR_CHKOUT_STAT"),
        F.col("ap_ucoo.COMPLETION_TERM"),
        F.col("ap_ucoo.ACAD_PROG_DUAL"),
        F.col("ap_ucoo.JOINT_PROG_APPR"),
        F.col("ap_ucoo.ADM_APPL_NBR"),
        F.col("ap_ucoo.APPL_PROG_NBR"),
        F.col("ap_ucoo.DATA_FROM_ADM_APPL"),
        F.col("ap_ucoo.SSR_RS_CANDIT_NBR"),
        F.col("ap_ucoo.SSR_APT_INSTANCE"),
        F.col("ap_ucoo.SSR_YR_OF_PROG"),
        F.col("ap_ucoo.SSR_SHIFT"),
        F.col("ap_ucoo.SSR_COHORT_ID"),
        F.col("ap_ucoo.SCC_ROW_ADD_OPRID"),
        F.col("ap_ucoo.SCC_ROW_ADD_DTTM"),
        F.col("ap_ucoo.SCC_ROW_UPD_OPRID"),
        F.col("ap_ucoo.SCC_ROW_UPD_DTTM"),
        #F.col("ap_ucoo.READ_DTM"),
        #F.col("ap_ucoo.STAGE_UPDATE_ID"),
    )
    .distinct()
)

log_msg(f"UCOO program history row count: {get_count(ucoo_program_history)}")

# COMMAND ----------

# CAP indicator calculation
adw_ste_fact = read_table(f"{analytics}.{staging}.fact_thecb_irp_enrollment").alias(
    "ste"
)
adw_term_cap = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_cap")
ps_acad_prog_cap = read_table(f"{student}.{bronze}.ps_ACAD_PROG").alias("ap_cap")

# mod_strm: maps current term to its academic year's Summer term
# Summer stays as-is; Fall and Spring route back to prior Summer
mod_strm_expr = (
    F.when(F.col("term_cap.STRM").substr(4, 1) == F.lit("5"), F.col("term_cap.STRM"))
    .when(
        F.col("term_cap.STRM").substr(4, 1).isin("8", "2"),
        F.concat(
            F.lit("2"),
            (F.col("term_cap.STRM").substr(2, 2).cast("int") - F.lit(1)).cast("string"),
            F.lit("5"),
        ),
    )
    .otherwise(F.lit(""))
)

# Lower bound of ADMIT_TERM window (academic year boundary):
# Summer → same STRM; Fall → current year's Summer; Spring → prior year's Summer

lower_admit_bound_expr_1 = (
    F.when(F.col("term_cap.STRM").substr(4, 1) == F.lit("8"), F.col("term_cap.STRM"))
    .when(
        F.col("term_cap.STRM").substr(4, 1) == F.lit("2"),
        F.concat(
            F.lit("2"),
            (F.col("term_cap.STRM").substr(2, 2).cast("int") - F.lit(1)).cast("string"),
            F.lit("8"),
        ),
    )
    .otherwise(F.lit(""))
)

lower_admit_bound_expr = (
    F.when(F.col("term_cap.STRM").substr(4, 1) == F.lit("5"), F.col("term_cap.STRM"))
    .when(
        F.col("term_cap.STRM").substr(4, 1) == F.lit("8"),
        F.concat(
            F.lit("2"),
            F.col("term_cap.STRM").substr(2, 2).cast("int").cast("string"),
            F.lit("5"),
        ),
    )
    .when(
        F.col("term_cap.STRM").substr(4, 1) == F.lit("2"),
        F.concat(
            F.lit("2"),
            (F.col("term_cap.STRM").substr(2, 2).cast("int") - F.lit(1)).cast("string"),
            F.lit("5"),
        ),
    )
    .otherwise(F.lit(""))
)

# Base: student enrollment joined to term dimension with computed boundaries
cap_base = (
    adw_ste_fact.join(
        adw_term_cap, F.col("ste.TERM_SK") == F.col("term_cap.TERM_SK"), "left"
    )
    .withColumn("mod_strm", mod_strm_expr)
    .withColumn("_lower_admit1", lower_admit_bound_expr_1)
    .withColumn("_lower_admit", lower_admit_bound_expr)
)

# UCAP admissions (UGRD career, ADMT action, UCAP reason)
ucap_admissions = ps_acad_prog_cap.filter(
    (F.col("ap_cap.ACAD_CAREER") == F.lit("UGRD"))
    & (F.col("ap_cap.PROG_ACTION") == F.lit("ADMT"))
    & (F.col("ap_cap.PROG_REASON") == F.lit("UCAP"))
).alias("ap_ucap")

# Join UCAP and UCOO to determine CAP indicator
# CAP=6 when UCAP admission exists but no UCOO plan change in same window
cap_indicator = (
    cap_base.join(
        ucap_admissions,
        (F.col("ste.EMPLID") == F.col("ap_ucap.EMPLID"))
        & (
            F.coalesce(F.col("ap_ucap.ADMIT_TERM"), F.lit("")) == F.col("_lower_admit1")
        ),
        "left",
    )
    .join(
        ucoo_program_history.alias("ap_ucoo2"),
        (F.col("ste.EMPLID") == F.col("ap_ucoo2.EMPLID"))
        & (
            F.coalesce(F.col("ap_ucoo2.ADMIT_TERM"), F.lit("")) == F.col("_lower_admit")
        ),
        "left",
    )
    .select(
        F.col("ste.EMPLID"),
        F.col("ste.ACAD_CAREER_SK"),
        F.col("ste.TERM_SK"),
        F.col("ap_ucap.ACAD_CAREER"),
        F.col("ap_ucap.PROG_ACTION"),
        F.col("ap_ucap.PROG_REASON"),
        F.col("ap_ucap.ADMIT_TERM"),
        # CAP=6: UCAP admitted as UGRD with no subsequent UCOO plan change
        F.when(
            (F.col("ap_ucap.PROG_REASON") == F.lit("UCAP"))
            & (F.col("term_cap.STRM").substr(4, 1) != F.lit("5"))
            & (F.col("term_cap.ACAD_CAREER") == F.lit("UGRD"))
            & (F.coalesce(F.col("ap_ucoo2.PROG_REASON"), F.lit("")) != F.lit("UCOO")),
            F.lit(6),
        )
        .otherwise(F.lit(None).cast("int"))
        .alias("CAP"),
        F.col("term_cap.STRM"),
        F.col("mod_strm"),
    )
    .distinct()
)

# COMMAND ----------

# Checkpoint 5: Persist CAP indicator — complex 3-way join with term boundary logic
_tmp_stage5_tbl = f"{analytics}.{staging}.tmp_cap_indicator_400_LOAD_CBM0E1"
write_df_to_table(
    cap_indicator, _tmp_stage5_tbl, mode="overwrite", overwriteSchema="true"
)
cap_indicator = read_table(_tmp_stage5_tbl).alias("cap")
log_msg(
    f"Checkpoint 5 materialized: {_tmp_stage5_tbl} — row count: {get_count(cap_indicator)}"
)

# COMMAND ----------

# =============================================================================
# SECTION 8:
# =============================================================================
# Create temp view: WTCA9MFQ
df_wtca9mfq = read_table(f"{analytics}.{staging}.fact_thecb_irp_enrollment").alias(
    "ADW_STUDENT_TERM_ENRL_FACT"
)
df_wtca9mfq = df_wtca9mfq.join(
    read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias(
        "ADW_ACAD_CAREER_DIM"
    ),
    (
        F.col("adw_student_term_enrl_fact.ACAD_CAREER_SK")
        == F.col("adw_acad_career_dim.ACAD_CAREER_SK")
    ),
    "left",
)
df_wtca9mfq = df_wtca9mfq.join(
    read_table(f"{analytics}.{silver}.dim_thecb_term").alias("ADW_TERM_DIM"),
    (F.col("adw_student_term_enrl_fact.TERM_SK") == F.col("adw_term_dim.TERM_SK")),
    "left",
)
df_wtca9mfq = df_wtca9mfq.join(
    read_table(f"{student}.{bronze}.ps_ITEM_SF").alias("PS_ITEM_SF"),
    (
        (
            (
                (
                    (
                        (
                            F.col("adw_student_term_enrl_fact.EMPLID")
                            == F.col("ps_item_sf.EMPLID")
                        )
                        & (F.col("adw_term_dim.STRM") == F.col("ps_item_sf.ITEM_TERM"))
                    )
                    & (
                        F.col("adw_acad_career_dim.ACAD_CAREER")
                        == F.col("ps_item_sf.BILLING_CAREER")
                    )
                )
                & (F.col("ps_item_sf.SA_ID_TYPE") == F.lit("P"))
            )
            & (F.col("ps_item_sf.BUSINESS_UNIT") == F.lit("UTARL"))
        )
        & (F.col("ps_item_sf.ITEM_TYPE_CD") == F.lit("W"))
    ),
    "left",
)
df_wtca9mfq = df_wtca9mfq.withColumn(
    "waiver",
    F.when(F.col("ps_item_sf.WAIVER_CODE").like("3%"), F.lit("3"))
    .when(F.col("ps_item_sf.WAIVER_CODE").like("E100%"), F.lit("E100"))
    .when(F.col("ps_item_sf.WAIVER_CODE").like("E%"), F.lit("E"))
    .otherwise(F.lit("")),
)
_winSpec_13 = Window.partitionBy(
    F.col("adw_student_term_enrl_fact.EMPLID"),
    F.col("ps_item_sf.ITEM_TERM"),
    F.col("waiver"),
)
df_wtca9mfq = df_wtca9mfq.withColumn(
    "_sel_tmp_0_0", F.sum(F.col("ps_item_sf.ITEM_AMT")).over(_winSpec_13)
)
df_wtca9mfq = df_wtca9mfq.withColumn(
    "AMT_3",
    F.when(F.col("ps_item_sf.WAIVER_CODE").like("3%"), F.col("_sel_tmp_0_0")).otherwise(
        F.lit(0)
    ),
)
df_wtca9mfq = df_wtca9mfq.drop("_sel_tmp_0_0")
df_wtca9mfq = df_wtca9mfq.withColumn(
    "_sel_tmp_1_0", F.sum(F.col("ps_item_sf.ITEM_AMT")).over(_winSpec_13)
)
df_wtca9mfq = df_wtca9mfq.withColumn(
    "AMT_F",
    F.when(
        F.col("ps_item_sf.WAIVER_CODE").like("E100%"), F.col("_sel_tmp_1_0")
    ).otherwise(F.lit(0)),
)
df_wtca9mfq = df_wtca9mfq.drop("_sel_tmp_1_0")
df_wtca9mfq = df_wtca9mfq.withColumn(
    "_sel_tmp_2_0", F.sum(F.col("ps_item_sf.ITEM_AMT")).over(_winSpec_13)
)
df_wtca9mfq = df_wtca9mfq.withColumn(
    "AMT_E",
    F.when(F.col("ps_item_sf.WAIVER_CODE").like("E%"), F.col("_sel_tmp_2_0")).otherwise(
        F.lit(0)
    ),
)
df_wtca9mfq = df_wtca9mfq.drop("_sel_tmp_2_0")
df_wtca9mfq = df_wtca9mfq.withColumn(
    "waiver_count", F.count(F.lit(1)).over(_winSpec_13)
)
df_wtca9mfq = df_wtca9mfq.withColumn(
    "waiver_number",
    F.when(F.col("ps_item_sf.WAIVER_CODE").like("3%"), F.lit(3))
    .when(F.col("ps_item_sf.WAIVER_CODE").like("E100%"), F.lit(2))
    .when(F.col("ps_item_sf.WAIVER_CODE").like("E%"), F.lit(1))
    .otherwise(F.lit(0)),)

# COMMAND ----------

df_wtca9mfq = df_wtca9mfq.withColumn(
    "waiver_3",
    F.when(
        F.substring(F.col("ps_item_sf.WAIVER_CODE"), 1, 4).isin(
            ["3HAZ", "3MOR", "3HZD"]
        ),
        F.lit(1),
    ).otherwise(F.lit(0)),
)
df_wtca9mfq = df_wtca9mfq.withColumn(
    "waiver_e",
    F.when(
        F.substring(F.col("ps_item_sf.WAIVER_CODE"), 1, 4).isin(["EMST"]), F.lit(1)
    ).otherwise(F.lit(0)),
)
df_wtca9mfq = df_wtca9mfq.withColumn("WAIVER_CODE", F.lit(""))
df_wtca9mfq = df_wtca9mfq.select(
    F.col("adw_student_term_enrl_fact.EMPLID"),
    F.col("adw_acad_career_dim.ACAD_CAREER"),
    F.col("adw_term_dim.STRM"),
    F.col("adw_term_dim.TERM_SK"),
    F.col("ps_item_sf.BUSINESS_UNIT"),
    F.col("ps_item_sf.SA_ID_TYPE"),
    F.col("WAIVER_CODE"),
    F.col("AMT_3"),
    F.col("AMT_F"),
    F.col("AMT_E"),
    F.col("waiver"),
    F.col("waiver_count"),
    F.col("waiver_number"),
    F.col("waiver_3"),
    F.col("waiver_e"),
)
waiver_amounts = df_wtca9mfq.distinct()


log_msg(f"Waiver amounts row count: {get_count(waiver_amounts)}")

# COMMAND ----------

# Waiver aggregation — filter non-zero amounts, add max waiver flags per student-term
waiver_student_term_window = Window.partitionBy(F.col("EMPLID"), F.col("TERM_SK"))

waiver_aggregated = (
    waiver_amounts
    # Only keep records where at least one waiver amount is non-zero
    .filter(
        (F.col("AMT_3") != F.lit(0))
        | (F.col("AMT_F") != F.lit(0))
        | (F.col("AMT_E") != F.lit(0))
    )
    # Recount across all waiver types per student-term
    .withColumn("waiver_count", F.count(F.lit(1)).over(waiver_student_term_window))
    # Propagate max Hazlewood and employee waiver flags across student-term
    .withColumn(
        "max_waiver_3", F.max(F.col("waiver_3")).over(waiver_student_term_window)
    )
    .withColumn(
        "max_waiver_e", F.max(F.col("waiver_e")).over(waiver_student_term_window)
    )
    .select(
        F.col("EMPLID"),
        F.col("ACAD_CAREER"),
        F.col("STRM"),
        F.col("TERM_SK"),
        F.col("BUSINESS_UNIT"),
        F.col("SA_ID_TYPE"),
        F.col("WAIVER_CODE"),
        F.col("AMT_3"),
        F.col("AMT_F"),
        F.col("AMT_E"),
        F.col("waiver"),
        F.col("waiver_count"),
        F.col("waiver_number"),
        F.col("max_waiver_3").alias("waiver_3"),
        F.col("max_waiver_e").alias("waiver_e"),
    )
    .distinct()
)

log_msg(f"Waiver aggregated row count: {get_count(waiver_aggregated)}")

# COMMAND ----------

# Best waiver per student-term — highest-priority waiver wins (by waiver_number)
# When multiple waiver types exist, keep only the highest-priority one
best_waiver_window = Window.partitionBy(
    F.col("EMPLID"), F.col("TERM_SK"), F.col("STRM")
)

best_waiver_per_student = (
    waiver_aggregated.withColumn(
        "max_waiver_number", F.max(F.col("waiver_number")).over(best_waiver_window)
    )
    # Keep single-waiver records or the highest-priority when multiple exist
    .filter(
        (F.col("waiver_count") == F.lit(1))
        | (
            (F.col("waiver_count") > F.lit(1))
            & (
                F.coalesce(F.col("waiver_number").cast("string"), F.lit(""))
                == F.coalesce(F.col("max_waiver_number").cast("string"), F.lit(""))
            )
        )
    )
    .select(
        F.col("EMPLID"),
        F.col("ACAD_CAREER"),
        F.col("STRM"),
        F.col("TERM_SK"),
        F.col("BUSINESS_UNIT"),
        F.col("SA_ID_TYPE"),
        F.col("WAIVER_CODE"),
        F.col("AMT_3"),
        F.col("AMT_F"),
        F.col("AMT_E"),
        # Flag_WAV: indicates active waiver type based on negative amount (credit)
        # '3' = Hazlewood waiver active; 'E' = exempt waiver active
        F.when(
            (F.col("waiver").startswith("3")) & (F.col("AMT_3") < F.lit(0)), F.lit("3")
        )
        .when(
            (F.col("waiver").startswith("E100")) & (F.col("AMT_F") < F.lit(0)),
            F.lit("E"),
        )
        .when(
            (F.col("waiver").startswith("E")) & (F.col("AMT_E") < F.lit(0)), F.lit("E")
        )
        .otherwise(F.lit(""))
        .alias("Flag_WAV"),
        F.col("waiver_3"),
        F.col("waiver_e"),
    )
    .distinct()
)

log_msg(f"Best waiver per student row count: {get_count(best_waiver_per_student)}")

# COMMAND ----------

# =============================================================================
# SECTION 9: TUITION STATUS AND TUITION EXEMPT FLAG
# =============================================================================
# Business Logic: Derive TUITION_STATUS from official residency + waiver flags:
#   Resident (RESIDENCY='1'): '1' (in-state), or '3' if Hazlewood waiver active
#   Non-resident: 'F' (fee exempt), 'E' (exempt), 'A'/'C' (ADMISSION_EXCPT codes),
#                 'N' (disaster), or '2' (out-of-state)
# TUITION_EXEMPT: '01' = Hazlewood exempt (resident), '21' = employee exempt (non-resident)
student_list_tuition = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0c1_student_list"
).alias("sl_tuit")
adw_career_tuition = read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias(
    "car_tuit"
)
ps_res_off_tuition = read_table(f"{student}.{bronze}.ps_RESIDENCY_OFF").alias(
    "roff_tuit"
)
adw_residency_dim = read_table(f"{analytics}.{silver}.dim_thecb_residency").alias(
    "res_dim"
)

# Window: find latest EFFECTIVE_TERM per student-term for residency determination
tuition_eff_term_window = Window.partitionBy(
    F.col("sl_tuit.EMPLID"), F.col("sl_tuit.TERM_SK")
)

tuition_status_raw = (
    student_list_tuition.join(
        adw_career_tuition,
        F.col("sl_tuit.ACAD_CAREER_SK") == F.col("car_tuit.ACAD_CAREER_SK"),
        "inner",
    )
    .join(
        best_waiver_per_student.alias("bw"),
        (F.col("sl_tuit.TERM_SK") == F.col("bw.TERM_SK"))
        & (F.col("sl_tuit.EMPLID") == F.col("bw.EMPLID")),
        "left",
    )
    .join(
        ps_res_off_tuition,
        (F.col("sl_tuit.EMPLID") == F.col("roff_tuit.EMPLID"))
        & (F.col("car_tuit.ACAD_CAREER") == F.col("roff_tuit.ACAD_CAREER")),
        "left",
    )
    # Inner join to residency dim ensures only valid residency codes are used
    .join(
        adw_residency_dim,
        (F.col("roff_tuit.EFFECTIVE_TERM") <= F.col("sl_tuit.STRM"))
        & (F.col("roff_tuit.RESIDENCY") == F.col("res_dim.RESIDENCY_CD")),
        "inner",
    )
    .withColumn(
        "max_eff_term_tuit",
        F.max(F.col("roff_tuit.EFFECTIVE_TERM")).over(tuition_eff_term_window),
    )
)

# Keep only latest residency determination, derive TUITION_STATUS
tuition_status = (
    tuition_status_raw.filter(
        F.coalesce(F.col("roff_tuit.EFFECTIVE_TERM"), F.lit(""))
        == F.coalesce(F.col("max_eff_term_tuit"), F.lit(""))
    )
    .select(
        F.col("sl_tuit.EMPLID"),
        F.col("car_tuit.ACAD_CAREER"),
        F.col("sl_tuit.STRM"),
        F.col("roff_tuit.EFFECTIVE_TERM"),
        F.col("sl_tuit.TERM_SK"),
        F.col("bw.WAIVER_CODE"),
        F.col("bw.Flag_WAV"),
        F.col("roff_tuit.ADMISSION_EXCPT"),
        F.col("roff_tuit.RESIDENCY"),
        # TUITION_STATUS derivation
        F.when(
            F.col("roff_tuit.RESIDENCY") == F.lit("1"),
            F.when(F.col("bw.Flag_WAV") == F.lit("3"), F.lit("3")).otherwise(
                F.lit("1")
            ),
        )
        .otherwise(
            F.when(
                F.coalesce(F.col("roff_tuit.RESIDENCY"), F.lit("")) != F.lit("1"),
                F.when(F.col("bw.Flag_WAV") == F.lit("F"), F.lit("F"))
                .when(F.col("bw.Flag_WAV") == F.lit("E"), F.lit("E"))
                .when(
                    F.col("roff_tuit.ADMISSION_EXCPT").isin("1403A", "1528A"),
                    F.lit("A"),
                )
                .when(
                    F.col("roff_tuit.ADMISSION_EXCPT").isin("1403C", "1528C"),
                    F.lit("C"),
                )
                .when(F.col("roff_tuit.ADMISSION_EXCPT") == F.lit("DISAS"), F.lit("N"))
                .otherwise(F.lit("2")),
            ).otherwise(F.lit(None).cast("string")),
        )
        .alias("TUITION_STATUS"),
        F.col("bw.waiver_3"),
        F.col("bw.waiver_e"),
    )
    .distinct()
)

# COMMAND ----------

# Tuition exempt flag derivation
# '01' = Hazlewood (resident + TUITION_STATUS='3' + Hazlewood waiver detected)
# '21' = Employee exempt (non-resident + TUITION_STATUS='E' + employee waiver detected)
tuition_exempt_window = Window.partitionBy(
    F.col("EMPLID"), F.col("TERM_SK"), F.col("ACAD_CAREER"), F.col("ADMISSION_EXCPT")
)

tuition_exempt_expr = (
    F.when(
        (F.col("RESIDENCY") == F.lit("1"))
        & (F.col("TUITION_STATUS") == F.lit("3"))
        & (F.col("waiver_3") == F.lit(1)),
        F.lit("01"),
    )
    .when(
        (F.col("RESIDENCY") != F.lit("1"))
        & (F.col("TUITION_STATUS") == F.lit("E"))
        & (F.col("waiver_e") == F.lit(1)),
        F.lit("21"),
    )
    .otherwise(F.lit(None).cast("string"))
)

# COMMAND ----------

tuition_exempt = (
    tuition_status.withColumn("tuit_exempt_raw", tuition_exempt_expr)
    .withColumn(
        "max_tuit_exempt",
        F.max(
            F.when(
                (F.col("RESIDENCY") == F.lit("1"))
                & (F.col("TUITION_STATUS") == F.lit("3"))
                & (F.col("waiver_3") == F.lit(1)),
                F.lit("01"),
            )
            .when(
                (F.col("RESIDENCY") != F.lit("1"))
                & (F.col("TUITION_STATUS") == F.lit("E"))
                & (F.col("waiver_e") == F.lit(1)),
                F.lit("21"),
            )
            .otherwise(F.lit(""))
        ).over(tuition_exempt_window),
    )
    # Keep row matching the max exempt code within the partition
    .filter(
        F.coalesce(F.col("tuit_exempt_raw"), F.lit(""))
        == F.coalesce(F.col("max_tuit_exempt"), F.lit(""))
    )
    .select(
        F.col("EMPLID"),
        F.col("ACAD_CAREER"),
        F.col("TERM_SK"),
        F.col("ADMISSION_EXCPT"),
        F.col("RESIDENCY"),
        F.col("TUITION_STATUS"),
        F.col("tuit_exempt_raw").alias("TUITION_EXEMPT"),
    )
    .distinct()
)
# Checkpoint 6: Persist tuition exempt — reused in student_assembly AND cbm0e1_detail
_tmp_stage6_tbl = f"{analytics}.{staging}.tmp_tuition_exempt_400_LOAD_CBM0E1"
write_df_to_table(
    tuition_exempt, _tmp_stage6_tbl, mode="overwrite", overwriteSchema="true"
)
tuition_exempt = read_table(_tmp_stage6_tbl).alias("te")
log_msg(
    f"Checkpoint 6 materialized: {_tmp_stage6_tbl} — row count: {get_count(tuition_exempt)}"
)

# COMMAND ----------

# =============================================================================
# SECTION 10: MAIN STUDENT ASSEMBLY (WIB9I7X0)
# =============================================================================
# Business Logic: Join all intermediate results into a comprehensive student record.
# Combines: student list, academic career, term, classification, FERPA, transfer college,
# CAP, SCH (semester credit hours), tuition, residency, UG limit/degree, ethnicity,
# doctoral funding, IDD flag, and person demographics.
# Filters: student must have SCH > 0 and academic year >= 2001.
student_list_main = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0c1_student_list"
).alias("sl_main")
adw_career_main = read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias(
    "car_main"
)
adw_term_main = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_main")
classification_main = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0c1_classification_info"
).alias("classif_main")
ps_person_sa = read_table(f"{student}.{bronze}.ps_PERSON_SA").alias("person_sa")
transfer_college = read_table(
    f"{analytics}.{staging}.fact_thecb_transfer_or_ftic"
).alias("trancol")
cbm1_sch = read_table(f"{analytics}.{staging}.fact_thecb_cbm0c1_sch").alias("sch")
cbm1_uglimit = read_table(
    f"{analytics}.{staging}.fact_thecb_undergraduate_limit"
).alias("uglimit")
cbm1_ugdegr = read_table(
    f"{analytics}.{staging}.fact_thecb_undergraduate_degree"
).alias("ugdegr")
adw_person_dim = read_table(f"{analytics}.{silver}.dim_thecb_person").alias(
    "person_dim"
)

# Compute FLEX-adjusted TERM_SK for term dimension lookup
student_list_flex_adjusted = student_list_main.withColumn(
    "new_term_sk2",
    F.when(
        F.trim(F.coalesce(F.col("sl_main.FLEX"), F.lit(""))) > F.lit("0"),
        F.col("sl_main.TERM_SK").cast("int") + F.lit(2),
    ).otherwise(F.col("sl_main.TERM_SK")),
)


# SCHCSF calculation: net SCH after non-formula deductions, capped by GR_SCH
# Formula: (SCH_ON + SCH_OFF) - (SCHCNSF + SCHDNSF + SCHDSF)
# If negative → 0; if positive and GR_SCH covers it → subtract GR_SCH
def compute_schcsf():
    total_sch = F.coalesce(F.col("sch.SCH_ON"), F.lit(0)) + F.coalesce(
        F.col("sch.SCH_OFF"), F.lit(0)
    )
    non_formula = (
        F.coalesce(F.col("sch.SCHCNSF"), F.lit(0))
        + F.coalesce(F.col("sch.SCHDNSF"), F.lit(0))
        + F.coalesce(F.col("sch.SCHDSF"), F.lit(0))
        + F.lit(0)
    )
    net = total_sch - non_formula
    return (
        F.when(net < F.lit(0), F.lit(0))
        .when(
            (net > F.lit(0)) & (F.col("sch.GR_SCH") > F.lit(0)),
            F.when(net == F.col("sch.GR_SCH"), F.lit(0))
            .when(
                net > F.col("sch.GR_SCH"),
                net - F.coalesce(F.col("sch.GR_SCH"), F.lit(0)),
            )
            .otherwise(F.lit(0)),
        )
        .otherwise(net)
    )


# GR_SCH calculation: graduate SCH capped by net remaining after non-formula deductions
def compute_gr_sch():
    total_sch = F.coalesce(F.col("sch.SCH_ON"), F.lit(0)) + F.coalesce(
        F.col("sch.SCH_OFF"), F.lit(0)
    )
    non_formula = (
        F.coalesce(F.col("sch.SCHCNSF"), F.lit(0))
        + F.coalesce(F.col("sch.SCHDNSF"), F.lit(0))
        + F.coalesce(F.col("sch.SCHDSF"), F.lit(0))
    )
    net = total_sch - non_formula
    return (
        F.when(
            (net > F.lit(0)) & (F.col("sch.GR_SCH") > F.lit(0)),
            F.when(
                (net < F.col("sch.GR_SCH")) & (net > F.lit(0)),
                net,
            ).otherwise(F.col("sch.GR_SCH")),
        )
        .when(
            (F.col("sch.GR_SCH") > F.lit(0)) & (F.col("sch.SCHCNSF") > F.lit(0)),
            F.lit(0),
        )
        .otherwise(F.col("sch.GR_SCH"))
    )


# Assemble the full student record via multi-table join
student_assembly = (
    student_list_flex_adjusted.alias("slm")
    # Academic career dimension (ACAD_CAREER value)
    .join(
        adw_career_main,
        F.coalesce(F.col("slm.ACAD_CAREER_SK"), F.lit(-1))
        == F.coalesce(F.col("car_main.ACAD_CAREER_SK"), F.lit(-1)),
        "left",
    )
    # Term dimension (STRM, ACAD_YEAR, TERM_END_DT)
    .join(
        adw_term_main,
        F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
        == F.coalesce(F.col("term_main.TERM_SK"), F.lit(-1)),
        "left",
    )
    # Classification info (CLASS level, CIP, NDS, RESTRICTED)
    .join(
        classification_main,
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("classif_main.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("classif_main.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    # FERPA indicator (disclosure restriction)
    .join(
        ps_person_sa,
        F.coalesce(F.col("slm.EMPLID"), F.lit(""))
        == F.coalesce(F.col("person_sa.EMPLID"), F.lit("")),
        "left",
    )
    # Transfer college (TRANCOL code and HS_CODE)
    .join(
        transfer_college,
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("trancol.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("trancol.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("term_main.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    # CAP indicator (competitive academic progress)
    .join(
        cap_indicator.alias("cap"),
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("cap.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("cap.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    # Semester credit hours (on-campus, off-campus, non-formula deductions)
    .join(
        cbm1_sch,
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("sch.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("sch.TERM_SK"), F.lit(-1))
        )
        & (
            F.coalesce(F.col("slm.FLEX"), F.lit(""))
            == F.coalesce(F.col("sch.FLEX"), F.lit(""))
        ),
        "left",
    )
    # Tuition exempt status
    .join(
        tuition_exempt.alias("te"),
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("te.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("te.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    # Residence detail (FLEX-adjusted TERM_SK join for COUNTY_CD)
    .join(
        residence_detail.alias("res_d"),
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("res_d.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.ACAD_CAREER_SK"), F.lit(-1))
            == F.coalesce(F.col("res_d.ACAD_CAREER_SK"), F.lit(-1))
        )
        & (
            F.coalesce(F.col("slm.new_term_sk2"), F.lit(-1))
            == F.coalesce(F.col("res_d.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    # UG semester hour limit
    .join(
        cbm1_uglimit,
        F.coalesce(F.col("slm.EMPLID"), F.lit(""))
        == F.coalesce(F.col("uglimit.EMPLID"), F.lit("")),
        "left",
    )
    # Ethnic/race aggregated codes
    .join(
        ethnic_race_aggregated.alias("era"),
        F.coalesce(F.col("slm.EMPLID"), F.lit(""))
        == F.coalesce(F.col("era.EMPLID"), F.lit("")),
        "left",
    )
    # UG degree info
    .join(
        cbm1_ugdegr,
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("ugdegr.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("ugdegr.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    # Doctoral funding code
    .join(
        doctoral_funding_code.alias("dfc"),
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("dfc.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("dfc.TERM_SK"), F.lit(-1))
        )
        & (
            F.coalesce(F.col("dfc.FLEX"), F.lit(""))
            == F.coalesce(F.col("slm.FLEX"), F.lit(""))
        ),
        "left",
    )
    # Residence subset (unmodified TERM_SK join for FLEX students)
    .join(
        residence_subset.alias("res_s"),
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("res_s.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.ACAD_CAREER_SK"), F.lit(-1))
            == F.coalesce(F.col("res_s.ACAD_CAREER_SK"), F.lit(-1))
        )
        & (
            F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("res_s.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    # IDD enrollment flag
    .join(
        idd_enrollment_flag.alias("idd"),
        (
            F.coalesce(F.col("slm.EMPLID"), F.lit(""))
            == F.coalesce(F.col("idd.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("slm.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("idd.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    # Person dimension (name, gender, DOB)
    .join(
        adw_person_dim,
        F.coalesce(F.col("slm.EMPLID"), F.lit(""))
        == F.coalesce(F.col("person_dim.EMPLID"), F.lit("")),
        "left",
    )
    # Filter: must have SCH > 0 and academic year >= 2001
    .filter(
        (
            (F.coalesce(F.col("sch.SCH_ON"), F.lit(0)) > F.lit(0))
            | (F.coalesce(F.col("sch.SCH_OFF"), F.lit(0)) > F.lit(0))
        )
        & (F.coalesce(F.col("term_main.ACAD_YEAR"), F.lit(0)) >= F.lit(2001))
    )
    .select(
        F.lit("1").alias("RECCODE"),
        F.lit("003656").alias("FICE"),
        F.col("slm.EMPLID"),
        F.col("person_dim.GENDER"),
        F.col("classif_main.CLASS"),
        # DOB: formatted as YYYYMMDD
        F.concat(
            F.year(F.col("person_dim.BIRTH_DT")).cast("string"),
            F.lpad(F.month(F.col("person_dim.BIRTH_DT")).cast("string"), 2, "0"),
            F.lpad(F.dayofmonth(F.col("person_dim.BIRTH_DT")).cast("string"), 2, "0"),
        ).alias("DOB"),
        F.col("te.TUITION_STATUS").alias("TUITRES"),
        # RESID: FLEX students use residence_subset COUNTY_CD with fallback to residence_detail
        F.when(
            F.trim(F.coalesce(F.col("slm.FLEX"), F.lit(""))) > F.lit("0"),
            F.coalesce(F.col("res_s.COUNTY_CD"), F.col("res_d.COUNTY_CD")),
        )
        .otherwise(F.col("res_d.COUNTY_CD"))
        .alias("RESID"),
        F.col("trancol.TRANCOL"),
        F.col("sch.SCH_ON").alias("SCHON"),
        F.col("sch.SCH_OFF").alias("SCHOFF"),
        F.col("dfc.UNIT_DOC").alias("DOCFUND"),
        # TERM_SK: FLEX-adjusted for reporting
        F.when(
            F.coalesce(F.trim(F.col("slm.FLEX")), F.lit("X")) == F.lit("6"),
            (F.col("slm.TERM_SK").cast("int") + F.lit(2)).cast("long"),
        )
        .otherwise(F.col("slm.TERM_SK"))
        .alias("TERM_SK"),
        F.lit("0000").alias("INTERSCH"),
        F.col("slm.TERM_SK").alias("TERM_SK_ORIG"),
        # FLEX: doctoral FLEX > 1 → report as '3'
        F.when(
            (F.col("classif_main.CLASS") == F.lit("7"))
            & (F.coalesce(F.col("slm.FLEX"), F.lit("")) > F.lit("1")),
            F.lit("3"),
        )
        .otherwise(F.col("slm.FLEX"))
        .alias("FLEX"),
        F.col("cap.CAP").alias("REMOTE"),
        F.col("classif_main.CIP_CD").alias("CIP"),
        F.col("dfc.DOCFNDCD"),
        F.col("te.TUITION_EXEMPT").alias("TUITEXT"),
        F.col("sch.SCHCNSF"),
        F.col("sch.SCHDNSF"),
        F.lit("0000").alias("SCHINSF"),
        compute_schcsf().alias("SCHCSF"),
        F.col("sch.SCHDSF"),
        F.col("ugdegr.UGDEGR"),
        # UGLIMIT: '5' override, else only for undergrad classes 1-4
        F.when(F.col("uglimit.UG_LIMIT") == F.lit("5"), F.lit("5"))
        .when(
            F.col("classif_main.CLASS").isin("1", "2", "3", "4"),
            F.col("uglimit.UG_LIMIT"),
        )
        .otherwise(F.lit("0"))
        .alias("UGLIMIT"),
        F.col("person_dim.LAST_NAME").alias("LAST"),
        F.col("person_dim.FIRST_NAME").alias("FIRST"),
        # MINIT: first character of middle name (null if blank)
        F.when(
            F.trim(F.col("person_dim.MIDDLE_NAME").substr(1, 1)) == F.lit(""),
            F.lit(None).cast("string"),
        )
        .otherwise(F.col("person_dim.MIDDLE_NAME").substr(1, 1))
        .alias("MINIT"),
        F.col("sch.SCHDC"),
        F.col("classif_main.RESTRICTED").alias("TEACHED"),
        F.col("classif_main.NDS"),
        # ND: FERPA non-disclosure indicator ('2' if restricted, else '0')
        F.when(F.col("person_sa.FERPA") == F.lit("Y"), F.lit("2"))
        .otherwise(F.lit("0"))
        .alias("ND"),
        compute_gr_sch().alias("GR_SCH"),
        # HS_CODE: null for graduate students
        F.when(
            F.col("car_main.ACAD_CAREER") == F.lit("GRAD"), F.lit(None).cast("string")
        )
        .otherwise(F.col("trancol.HS_CODE"))
        .alias("HS_CODE"),
        F.lit(None).cast("string").alias("PEIMS_ID"),
        F.col("era.ETHNIC_GRP").alias("ETHNIC"),
        F.col("era.RACE_WHITE"),
        F.col("era.RACE_BLACK"),
        F.col("era.RACE_ASIAN"),
        F.col("era.RACE_AmIndAlsknNatv").alias("RACE_NATIVE_AMERICAN"),
        # RACE_INTERNATIONAL: '6' if residency='4' (international) and not ADMISSION_EXCPT 'A'
        F.when(
            (F.coalesce(F.col("te.RESIDENCY"), F.lit("")) == F.lit("4"))
            & (F.coalesce(F.col("te.TUITION_STATUS"), F.lit("")) != F.lit("A")),
            F.lit("6"),
        )
        .otherwise(F.lit(None).cast("string"))
        .alias("RACE_INTERNATIONAL"),
        # RACE_UNKNOWN: '7' if non-Hispanic/Hispanic with no race flags and not international
        F.when(
            F.coalesce(F.col("era.ETHNIC_GRP"), F.lit("")).isin("1", "3")
            & (F.coalesce(F.col("era.RACE_WHITE"), F.lit(" ")) == F.lit(" "))
            & (F.coalesce(F.col("era.RACE_BLACK"), F.lit(" ")) == F.lit(" "))
            & (F.coalesce(F.col("era.RACE_ASIAN"), F.lit(" ")) == F.lit(" "))
            & (F.coalesce(F.col("era.RACE_AmIndAlsknNatv"), F.lit(" ")) == F.lit(" "))
            & (F.coalesce(F.col("era.RACE_NatHawnOPI"), F.lit(" ")) == F.lit(" "))
            & (
                (F.coalesce(F.col("te.RESIDENCY"), F.lit("")) != F.lit("4"))
                | (F.coalesce(F.col("te.TUITION_STATUS"), F.lit("")) == F.lit("A"))
            ),
            F.lit("7"),
        )
        .otherwise(F.lit(None).cast("string"))
        .alias("RACE_UNKNOWN"),
        F.col("era.RACE_NatHawnOPI").alias("RACE_NATIVE_HAWAIIAN"),
        # STRM_Flex: for FLEX students, shift to next reporting term
        # Fall→Spring+1, Spring→Summer, Summer→Fall
        F.col("term_main.STRM").alias("STRM_Flex"),
        F.col("term_main.STRM"),
        F.col("res_d.RESIDENCY"),
        F.col("te.TUITION_STATUS"),
        F.col("car_main.ACAD_CAREER"),
        F.col("trancol.has_class"),
        F.col("trancol.has_flex"),
        F.col("idd.IDD_Enrolled_IDD_Pgm").alias("IDD"),
        F.lit("0").alias("IDD_PROG"),
        # CB_REPORTED: 'N' if distance-learning-only, else 'Y'
        F.when(F.col("slm.DLRN") == F.lit(1), F.lit("N"))
        .otherwise(F.lit("Y"))
        .alias("CB_REPORTED"),
        F.col("classif_main.ACAD_PLAN"),
    )
    .distinct()
)

# COMMAND ----------

# Checkpoint 7: Persist student assembly — massive multi-table join, cuts lineage before detail step
_tmp_stage7_tbl = f"{analytics}.{staging}.tmp_student_assembly_400_LOAD_CBM0E1"
write_df_to_table(
    student_assembly, _tmp_stage7_tbl, mode="overwrite", overwriteSchema="true"
)
student_assembly = read_table(_tmp_stage7_tbl).alias("sa")
log_msg(
    f"Checkpoint 7 materialized: {_tmp_stage7_tbl} — row count: {get_count(student_assembly)}"
)

# COMMAND ----------

# =============================================================================
# SECTION 11: SEMESTER/YEAR DERIVATION AND TUITRES BACKFILL (W134AITPP)
# =============================================================================
# Business Logic: Add SEMESTER ('1'=Fall, '2'=Spring, '3'=Summer) and YEAR.
# Backfill TUITRES from residency_off when the tuition_exempt join produced no match.
# Apply term filter (current reporting term only) and dedup by MIN CAR_STRM.
adw_term_detail = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("in_term")
cbm1_ugdegr_detail = read_table(
    f"{analytics}.{staging}.fact_thecb_undergraduate_degree"
).alias("ug_det")
transfer_col_det = read_table(
    f"{analytics}.{staging}.fact_thecb_transfer_or_ftic"
).alias("tran_det")
ps_stdnt_car_term = read_table(f"{student}.{bronze}.ps_STDNT_CAR_TERM").alias(
    "ps_stdnt_car"
)

# Window for CAR_STRM dedup (placeholder: MIN of empty string is always empty)
car_strm_dedup_window = Window.partitionBy(
    F.col("sa.STRM_Flex"), F.col("sa.EMPLID"), F.col("sa.FLEX")
)

cbm0e1_detail = (
    student_assembly.alias("sa")
    .join(
        adw_term_detail,
        F.coalesce(F.col("sa.TERM_SK"), F.lit(-1))
        == F.coalesce(F.col("in_term.TERM_SK"), F.lit(-1)),
        "left",
    )
    .join(
        cbm1_ugdegr_detail.alias("ug_det"),
        (
            F.coalesce(F.col("sa.TERM_SK_ORIG"), F.lit(-1))
            == F.coalesce(F.col("ug_det.TERM_SK"), F.lit(-1))
        )
        & (
            F.coalesce(F.col("sa.EMPLID"), F.lit(""))
            == F.coalesce(F.col("ug_det.EMPLID"), F.lit(""))
        ),
        "left",
    )
    .join(
        ps_stdnt_car_term.alias("ps_stdnt_car"),
        (
            F.coalesce(F.col("sa.EMPLID"), F.lit(""))
            == F.coalesce(F.col("ps_stdnt_car.EMPLID"), F.lit(""))
        )
        & (
            (F.col("ps_stdnt_car.STRM") == F.col("sa.STRM_Flex"))
            | (F.col("ps_stdnt_car.STRM") == F.col("sa.STRM"))
        ),
        "left",
    )
    .join(
        transfer_col_det.alias("tran_det"),
        (
            F.coalesce(F.col("sa.EMPLID"), F.lit(""))
            == F.coalesce(F.col("tran_det.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("in_term.STRM"), F.lit(""))
            == F.coalesce(F.col("tran_det.STRM"), F.lit(""))
        ),
        "left",
    )
    .join(
        tuition_exempt.alias("te2"),
        (
            F.coalesce(F.col("sa.EMPLID"), F.lit(""))
            == F.coalesce(F.col("te2.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("sa.TERM_SK_ORIG"), F.lit(-1))
            == F.coalesce(F.col("te2.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    .join(
        residence_detail.alias("res_d2"),
        (
            F.coalesce(F.col("sa.EMPLID"), F.lit(""))
            == F.coalesce(F.col("res_d2.EMPLID"), F.lit(""))
        )
        & (
            F.coalesce(F.col("sa.TERM_SK"), F.lit(-1))
            == F.coalesce(F.col("res_d2.TERM_SK"), F.lit(-1))
        ),
        "left",
    )
    .withColumn(
        "min_car_strm", F.min(F.col("ps_stdnt_car.STRM")).over(car_strm_dedup_window)
    )
    .select(
        F.col("sa.RECCODE"),
        F.col("sa.FICE"),
        F.col("sa.EMPLID"),
        F.col("sa.GENDER"),
        F.col("sa.CLASS"),
        F.col("sa.DOB"),
        # TUITRES backfill: when tuition_exempt didn't match, derive from residency_off
        F.when(
            (F.coalesce(F.col("sa.TUITRES"), F.lit("")) == F.lit(""))
            & (F.coalesce(F.col("res_d2.RESIDENCY"), F.lit("")) == F.lit("1")),
            F.lit("1"),
        )
        .when(
            (F.coalesce(F.col("sa.TUITRES"), F.lit("")) == F.lit(""))
            & (F.coalesce(F.col("res_d2.RESIDENCY"), F.lit("")) != F.lit("1"))
            & F.col("res_d2.ADMISSION_EXCPT").isin("1403A", "1528A"),
            F.lit("A"),
        )
        .when(
            (F.coalesce(F.col("sa.TUITRES"), F.lit("")) == F.lit(""))
            & (F.coalesce(F.col("res_d2.RESIDENCY"), F.lit("")) != F.lit("1"))
            & F.col("res_d2.ADMISSION_EXCPT").isin("1403C", "1528C"),
            F.lit("C"),
        )
        .when(
            (F.coalesce(F.col("sa.TUITRES"), F.lit("")) == F.lit(""))
            & (F.coalesce(F.col("res_d2.RESIDENCY"), F.lit("")) != F.lit("1"))
            & (F.col("res_d2.ADMISSION_EXCPT") == F.lit("DISAS")),
            F.lit("N"),
        )
        .when(
            (F.coalesce(F.col("sa.TUITRES"), F.lit("")) == F.lit(""))
            & (F.coalesce(F.col("res_d2.RESIDENCY"), F.lit("")) != F.lit("1")),
            F.lit("2"),
        )
        .otherwise(F.col("sa.TUITRES"))
        .alias("TUITRES"),
        F.col("sa.RESID"),
        F.col("tran_det.TRANCOL"),
        F.col("sa.SCHON"),
        F.col("sa.SCHOFF"),
        F.col("sa.DOCFUND"),
        # SEMESTER: derived from STRM digit 4 ('8'→Fall=1, '2'→Spring=2, '5'→Summer=3)
        F.when(F.col("in_term.STRM").substr(4, 1) == F.lit("8"), F.lit("1"))
        .when(F.col("in_term.STRM").substr(4, 1) == F.lit("2"), F.lit("2"))
        .when(F.col("in_term.STRM").substr(4, 1) == F.lit("5"), F.lit("3"))
        .otherwise(F.lit(" "))
        .alias("SEMESTER"),
        # YEAR: '20' + digits 2-3 of STRM
        F.concat(F.lit("20"), F.col("in_term.STRM").substr(2, 2)).alias("YEAR"),
        F.col("sa.INTERSCH"),
        F.col("sa.FLEX"),
        F.col("sa.REMOTE"),
        F.col("sa.CIP"),
        F.col("sa.DOCFNDCD"),
        F.col("te2.TUITION_EXEMPT").alias("TUITEXT"),
        F.col("sa.SCHCNSF"),
        F.col("sa.SCHDNSF"),
        F.col("sa.SCHINSF"),
        F.col("sa.SCHCSF"),
        F.col("sa.SCHDSF"),
        F.col("sa.UGDEGR"),
        F.col("sa.UGLIMIT"),
        F.col("sa.LAST"),
        F.col("sa.FIRST"),
        F.col("sa.MINIT"),
        F.col("sa.SCHDC"),
        F.col("sa.TEACHED"),
        F.col("sa.NDS"),
        F.col("sa.ND"),
        F.col("sa.GR_SCH"),
        F.col("sa.HS_CODE"),
        F.col("sa.PEIMS_ID"),
        F.col("sa.ETHNIC"),
        F.col("sa.RACE_WHITE"),
        F.col("sa.RACE_BLACK"),
        F.col("sa.RACE_ASIAN"),
        F.col("sa.RACE_NATIVE_AMERICAN"),
        F.col("sa.RACE_INTERNATIONAL"),
        F.col("sa.RACE_UNKNOWN"),
        F.col("sa.RACE_NATIVE_HAWAIIAN"),
        F.col("in_term.STRM"),
        F.col("sa.STRM_Flex"),
        F.col("sa.STRM").alias("strm_mapped"),
        F.col("sa.TERM_SK"),
        F.col("ps_stdnt_car.STRM").alias("CAR_STRM"),
        F.col("sa.has_class"),
        F.col("sa.has_flex"),
        # Derived ACAD_CAREER for term dimension join in next step
        F.when(F.col("sa.CLASS") > F.lit("4"), F.lit("GRAD"))
        .otherwise(F.lit("UGRD"))
        .alias("acad_career"),
        F.col("sa.ACAD_PLAN"),
        F.col("ug_det.ACAD_SUB_PLAN").cast("string").alias("ACAD_SUB_PLAN"),
        F.col("sa.IDD"),
        F.col("sa.IDD_PROG"),
        F.col("sa.CB_REPORTED"),
        # F.col("min_car_strm"),
    )
    .distinct()
    # Dedup: keep rows matching the min CAR_STRM (always empty → no-op)
    .filter(
        F.coalesce(F.col("CAR_STRM"), F.lit(""))
        == F.coalesce(F.col("min_car_strm"), F.lit(""))
    )
    .drop("min_car_strm")
    # Critical filter: restrict to current reporting term only
    .filter(F.coalesce(F.col("STRM"), F.lit("")) == F.lit(term))
)

# COMMAND ----------

# Checkpoint 8: Persist CBM0e1 detail — semester/year/TUITRES resolved, ready for final class dedup
_tmp_stage8_tbl = f"{analytics}.{staging}.cbm0e1_detail"
write_df_to_table(
    cbm0e1_detail, _tmp_stage8_tbl, mode="overwrite", overwriteSchema="true"
)
cbm0e1_detail = read_table(_tmp_stage8_tbl).alias("cd")
log_msg(
    f"Checkpoint 8 materialized: {_tmp_stage8_tbl} — row count: {get_count(cbm0e1_detail)}"
)

# COMMAND ----------

# =============================================================================
# SECTION 12: FINAL CLASS RESOLUTION (W12JIN0DN)
# =============================================================================
# Business Logic: When a student has multiple CLASS levels within the same
# STRM/FLEX combination, keep only the highest CLASS value (e.g., '7' > '4').
# Also joins to ADW_TERM_DIM and CBM1_UGDEGR for the mapped term.
adw_term_final = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("term_fin")
cbm1_ugd_final = read_table(
    f"{analytics}.{staging}.fact_thecb_undergraduate_degree"
).alias("ug_fin")

# Window: MAX CLASS per student/STRM/FLEX
class_resolution_window = Window.partitionBy(
    F.col("cd.EMPLID"), F.col("cd.STRM"), F.col("cd.FLEX")
)

cbm0e1_final = (
    cbm0e1_detail.alias("cd")
    # Join term dimension using strm_mapped and derived acad_career
    .join(
        adw_term_final,
        (F.col("cd.strm_mapped") == F.col("term_fin.STRM"))
        & (F.col("cd.acad_career") == F.col("term_fin.ACAD_CAREER")),
        "left",
    )
    # Keep only the highest CLASS per student/STRM/FLEX
    .withColumn("max_class", F.max(F.col("cd.CLASS")).over(class_resolution_window))
    .filter(
        F.coalesce(F.col("cd.CLASS"), F.lit(""))
        == F.coalesce(F.col("max_class"), F.lit(""))
    )
    .select(
        F.col("cd.RECCODE"),
        F.col("cd.FICE"),
        F.col("cd.EMPLID"),
        F.col("cd.GENDER"),
        F.col("cd.CLASS"),
        F.col("cd.DOB"),
        F.col("cd.TUITRES"),
        F.col("cd.RESID"),
        F.col("cd.TRANCOL"),
        F.col("cd.SCHON"),
        F.col("cd.SCHOFF"),
        F.col("cd.DOCFUND"),
        F.col("cd.SEMESTER"),
        F.col("cd.YEAR"),
        F.col("cd.INTERSCH"),
        F.col("cd.FLEX"),
        F.col("cd.REMOTE"),
        F.col("cd.CIP"),
        F.col("cd.DOCFNDCD"),
        F.col("cd.TUITEXT"),
        F.col("cd.SCHCNSF"),
        F.col("cd.SCHDNSF"),
        F.col("cd.SCHINSF"),
        F.col("cd.SCHCSF"),
        F.col("cd.SCHDSF"),
        F.col("cd.UGDEGR"),
        F.col("cd.UGLIMIT"),
        F.col("cd.LAST"),
        F.col("cd.FIRST"),
        F.col("cd.MINIT"),
        F.col("cd.SCHDC"),
        F.col("cd.TEACHED"),
        F.col("cd.NDS"),
        F.col("cd.ND"),
        F.col("cd.GR_SCH"),
        F.col("cd.HS_CODE"),
        F.col("cd.PEIMS_ID"),
        F.col("cd.ETHNIC"),
        F.col("cd.RACE_WHITE"),
        F.col("cd.RACE_BLACK"),
        F.col("cd.RACE_ASIAN"),
        F.col("cd.RACE_NATIVE_AMERICAN"),
        F.col("cd.RACE_INTERNATIONAL"),
        F.col("cd.RACE_UNKNOWN"),
        F.col("cd.RACE_NATIVE_HAWAIIAN"),
        F.col("cd.STRM"),
        F.col("cd.STRM_Flex"),
        F.col("cd.strm_mapped"),
        F.col("cd.TERM_SK"),
        F.lit("").alias("CAR_STRM"),
        F.col("term_fin.TERM_SK").alias("term_sk_map"),
        F.col("cd.ACAD_PLAN"),
        F.col("cd.ACAD_SUB_PLAN"),
        F.col("cd.IDD"),
        F.col("cd.IDD_PROG"),
        F.col("cd.CB_REPORTED"),
    )
    .distinct()
)

log_msg(f"CBM0e1 final (class resolved) row count: {get_count(cbm0e1_final)}")

# COMMAND ----------

# =============================================================================
# SECTION 13: EXTERNAL SYSTEM CB ID
# =============================================================================
# Business Logic: Retrieve the latest CB (Coordinating Board) external system ID
# for each student. Used as fallback SIN when no valid SSN exists.
ps_external_system = read_table(f"{student}.{bronze}.ps_EXTERNAL_SYSTEM").alias("ext")

# Window: latest effective date per external system + EMPLID
ext_sys_effdt_window = Window.partitionBy(
    F.col("ext.EXTERNAL_SYSTEM"), F.col("ext.EMPLID")
)

cb_external_id = (
    ps_external_system.filter(F.col("ext.EXTERNAL_SYSTEM") == F.lit("CB"))
    .withColumn("_max_effdt", F.max(F.col("ext.EFFDT")).over(ext_sys_effdt_window))
    .filter(
        F.coalesce(F.col("ext.EFFDT"), F.current_date())
        == F.coalesce(F.col("_max_effdt"), F.current_date())
    )
    .drop("_max_effdt")
    .select(
        F.col("ext.EMPLID"),
        F.col("ext.EXTERNAL_SYSTEM"),
        F.col("ext.EFFDT"),
        F.col("ext.EXTERNAL_SYSTEM_ID"),
        #F.col("ext.READ_DTM"),
        #F.col("ext.STAGE_UPDATE_ID"),
    )
    .distinct()
)

log_msg(f"CB external ID row count: {get_count(cb_external_id)}")

# COMMAND ----------

# =============================================================================
# SECTION 14: BUILD ADW_CBM0e1_WORK — SIN DERIVATION + FINAL RECORD
# =============================================================================
# Business Logic: Derive the SIN (Student Identification Number) using priority:
#   1. SSN (NATIONAL_ID) if valid (not '99xx' or 'XXxx' prefix)
#   2. CB external system ID if valid
#   3. Fallback: '9' + EMPLID[3:] (synthetic ID)
# Cast numeric columns to appropriate types for ADW_CBM0e1_WORK schema.
ps_pers_nid = read_table(f"{student}.{bronze}.ps_PERS_NID").alias("nid")

cbm0e1_work = (
    cbm0e1_final.alias("fin")
    # Join SSN (USA, PR type only)
    .join(
        ps_pers_nid.filter(
            (F.col("nid.COUNTRY") == F.lit("USA"))
            & (F.col("nid.NATIONAL_ID_TYPE") == F.lit("PR"))
        ),
        F.col("fin.EMPLID") == F.col("nid.EMPLID"),
        "left",
    )
    # Join CB external system ID
    .join(
        cb_external_id.alias("cb_ext"),
        F.col("fin.EMPLID") == F.col("cb_ext.EMPLID"),
        "left",
    )
    .select(
        F.col("fin.RECCODE").cast("string").alias("RECCODE"),
        F.col("fin.FICE").cast("string").alias("FICE"),
        F.col("fin.EMPLID").cast("string").alias("EMPLID"),
        F.col("fin.GENDER").cast("string").alias("GENDER"),
        F.col("fin.CLASS").cast("string").alias("CLASS"),
        F.col("fin.DOB").cast("string").alias("DOB"),
        F.col("fin.TUITRES").cast("string").alias("TUITRES"),
        F.col("fin.RESID").cast("string").alias("RESID"),
        F.col("fin.TRANCOL").cast("string").alias("TRANCOL"),
        F.coalesce(F.col("fin.SCHON"), F.lit(0)).cast("bigint").alias("SCHON"),
        F.coalesce(F.col("fin.SCHOFF"), F.lit(0)).cast("bigint").alias("SCHOFF"),
        F.coalesce(F.col("fin.DOCFUND"), F.lit(0)).cast("bigint").alias("DOCFUND"),
        F.col("fin.SEMESTER").cast("string").alias("SEMESTER"),
        F.col("fin.YEAR").cast("string").alias("YEAR"),
        F.col("fin.INTERSCH").cast("string").alias("INTERSCH"),
        F.col("fin.FLEX").cast("string").alias("FLEX"),
        F.col("fin.REMOTE").cast("bigint").alias("REMOTE"),
        F.col("fin.CIP").cast("string").alias("CIP"),
        F.when(
            (F.col("fin.DOCFNDCD").isNull() | (F.trim(F.col("fin.DOCFNDCD")) == ""))
            & (F.col("fin.CLASS") == "7"),
            F.lit("00"),
        )
        .otherwise(F.col("fin.DOCFNDCD"))
        .cast("string")
        .alias("DOCFNCD"),
        F.col("fin.TUITEXT").cast("string").alias("TUITEXT"),
        F.coalesce(F.col("fin.SCHCNSF"), F.lit(0)).cast("bigint").alias("SCHCNSF"),
        F.coalesce(F.col("fin.SCHDNSF"), F.lit(0)).cast("bigint").alias("SCHDNSF"),
        F.col("fin.SCHINSF").cast("string").alias("SCHINSF"),
        F.coalesce(F.col("fin.SCHCSF"), F.lit(0)).cast("bigint").alias("SCHCSF"),
        F.coalesce(F.col("fin.SCHDSF"), F.lit(0)).cast("bigint").alias("SCHDSF"),
        F.coalesce(F.col("fin.UGDEGR"), F.lit(0)).cast("bigint").alias("UGDEGR"),
        F.col("fin.UGLIMIT").cast("string").alias("UGLIMIT"),
        F.substring(F.col("fin.LAST"), 1, 20).cast("string").alias("LAST"),
        F.rtrim(F.substring(F.col("fin.FIRST"), 1, 10)).cast("string").alias("FIRST"),
        F.col("fin.MINIT").cast("string").alias("MINIT"),
        F.coalesce(F.col("fin.SCHDC"), F.lit(0)).cast("bigint").alias("SCHDC"),
        F.col("fin.TEACHED").cast("string").alias("TEACHED"),
        F.col("fin.NDS").cast("string").alias("NDS"),
        F.col("fin.ND").cast("string").alias("ND"),
        F.coalesce(F.col("fin.GR_SCH"), F.lit(0)).cast("decimal(9,0)").alias("GR_SCH"),
        F.col("fin.HS_CODE").cast("string").alias("HS_CODE"),
        F.col("fin.PEIMS_ID").cast("string").alias("PEIMS_ID"),
        F.col("fin.ETHNIC").cast("string").alias("ETHNIC"),
        F.col("fin.RACE_WHITE").cast("string").alias("RACE_WHITE"),
        F.col("fin.RACE_BLACK").cast("string").alias("RACE_BLACK"),
        F.col("fin.RACE_ASIAN").cast("string").alias("RACE_ASIAN"),
        F.col("fin.RACE_NATIVE_AMERICAN").cast("string").alias("RACE_NATIVE_AMERICAN"),
        F.col("fin.RACE_INTERNATIONAL").cast("string").alias("RACE_INTERNATIONAL"),
        F.col("fin.RACE_UNKNOWN").cast("string").alias("RACE_UNKNOWN"),
        F.col("fin.RACE_NATIVE_HAWAIIAN").cast("string").alias("RACE_NATIVE_HAWAIIAN"),
        F.col("fin.STRM").cast("string").alias("STRM"),
        F.when(
            F.col("nid.NATIONAL_ID").isNotNull()
            & (F.trim(F.col("nid.NATIONAL_ID")) != "")
            & (F.col("nid.NATIONAL_ID").substr(1, 2) != "99")
            & (F.upper(F.col("nid.NATIONAL_ID").substr(1, 2)) != "XX"),
            F.col("nid.NATIONAL_ID"),
        )
        .when(
            F.col("cb_ext.EXTERNAL_SYSTEM_ID").isNotNull()
            & (F.trim(F.col("cb_ext.EXTERNAL_SYSTEM_ID")) != "")
            & (F.col("cb_ext.EXTERNAL_SYSTEM_ID").substr(1, 2) != "99")
            & (F.upper(F.col("cb_ext.EXTERNAL_SYSTEM_ID").substr(1, 2)) != "XX"),
            F.col("cb_ext.EXTERNAL_SYSTEM_ID"),
        )
        .otherwise(F.concat(F.lit("9"), F.col("fin.EMPLID").substr(3, 8)))
        .cast("string")
        .alias("SIN"),
        F.col("fin.ACAD_PLAN").cast("string").alias("ACAD_PLAN"),
        F.col("fin.ACAD_SUB_PLAN").cast("string").alias("ACAD_SUB_PLAN"),
        F.col("fin.IDD").cast("string").alias("IDD"),
        F.col("fin.IDD_PROG").cast("string").alias("IDD_PROG"),
        F.col("fin.CB_REPORTED").cast("string").alias("CB_REPORTED"),
    )
    .distinct()
)

# COMMAND ----------

log_msg(f"CBM0e1 work row count: {get_count(cbm0e1_work)}")

# COMMAND ----------

# =============================================================================
# SECTION 15: WRITE TO TARGET TABLES
# =============================================================================
# Write fact_thecb_cbm0e1_enrollment_work (full overwrite — replaces TRUNCATE + INSERT pattern)
write_df_to_table(
    cbm0e1_work,
    f"{analytics}.{staging}.fact_thecb_cbm0e1_enrollment_work",
    mode="overwrite",
    overwriteSchema="true",
)

log_msg(f"fact_thecb_cbm0e1_enrollment_work written ({get_count(cbm0e1_work)} rows)")

# COMMAND ----------

# TODO: Path needs to be finalized/updated
output_path = student_ext_output_path

# COMMAND ----------


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

# Read fact_thecb_cbm0e1_enrollment_work and filter by term and CB_REPORTED
adw_cbm0E1_work = read_table(
    f"{analytics}.{staging}.fact_thecb_cbm0e1_enrollment_work"
).alias("w")

df_source = adw_cbm0E1_work.filter(
    (F.col("w.STRM") == F.lit(term)) & (F.col("w.CB_REPORTED") == F.lit("Y"))
)

# Select columns — set unmapped fields to empty/zero per SAS logic
df_prep = df_source.select(
    F.col("w.RECCODE"),
    F.col("w.FICE"),
    F.col("w.EMPLID"),
    F.col("w.GENDER"),
    F.col("w.CLASS"),
    F.col("w.DOB"),
    F.col("w.TUITRES"),
    F.col("w.RESID"),
    F.col("w.TRANCOL"),
    F.lit(None).cast("double").alias("SCHON"),
    F.lit(0).cast("double").alias("SCHOFF"),
    F.lit(None).cast("double").alias("DOCFUND"),
    F.col("w.SEMESTER"),
    F.col("w.YEAR"),
    F.lit("").alias("INTERSCH"),
    F.col("w.FLEX"),
    F.col("w.REMOTE"),
    F.col("w.CIP"),
    F.lit("").alias("DOCFNCD"),
    F.col("w.TUITEXT"),
    F.lit(None).cast("double").alias("SCHCNSF"),
    F.lit(None).cast("double").alias("SCHDNSF"),
    F.lit("").alias("SCHINSF"),
    F.lit(None).cast("double").alias("SCHCSF"),
    F.lit(None).cast("double").alias("SCHDSF"),
    F.col("w.UGDEGR"),
    F.col("w.UGLIMIT"),
    F.col("w.LAST"),
    F.col("w.FIRST"),
    F.col("w.MINIT"),
    F.lit(None).cast("double").alias("SCHDC"),
    F.col("w.TEACHED"),
    F.col("w.NDS"),
    F.col("w.ND"),
    F.lit(None).cast("double").alias("GR_SCH"),
    F.col("w.HS_CODE"),
    F.col("w.PEIMS_ID"),
    F.col("w.ETHNIC"),
    F.col("w.RACE_WHITE"),
    F.col("w.RACE_BLACK"),
    F.col("w.RACE_ASIAN"),
    F.col("w.RACE_NATIVE_AMERICAN"),
    F.col("w.RACE_INTERNATIONAL"),
    F.col("w.RACE_UNKNOWN"),
    F.col("w.RACE_NATIVE_HAWAIIAN"),
    F.col("w.STRM"),
    F.col("w.SIN"),
    F.col("w.IDD"),
    F.col("w.IDD_PROG"),
    F.concat(
        F.lit("HY2K003656CBM0E11"),
        F.year(F.current_timestamp()).cast("string"),
        F.lit(
            "C0140                                                                                                  "
        ),
    ).alias("HEADER"),
)

df_final = df_prep.select(
    F.col("RECCODE"),
    F.col("FICE"),
    F.substring(F.col("SIN"), 1, 9).alias("SIN"),
    F.substring(F.col("GENDER"), 1, 1).alias("GENDER"),
    F.col("CLASS"),
    F.col("DOB"),
    F.col("TUITRES"),
    F.col("RESID"),
    F.substring(F.col("TRANCOL"), 1, 6).alias("TRANCOL"),
    F.lit("").alias("SCHON"),
    F.lpad(F.col("SCHOFF").cast("int").cast("string"), 4, "0").alias("SCHOFF"),
    F.lit("").alias("DOCFUND"),
    F.col("SEMESTER"),
    F.col("YEAR"),
    F.lit("").alias("INTERSCH"),
    F.substring(F.col("FLEX"), 1, 1).alias("FLEX"),
    F.when(F.col("REMOTE").isNull(), F.lit(" "))
    .otherwise(F.col("REMOTE").cast("string"))
    .alias("REMOTE"),
    F.col("CIP"),
    F.lit("").alias("DOCFNCD"),
    F.col("TUITEXT"),
    F.lit("").alias("SCHCNSF"),
    F.lit("").alias("SCHDNSF"),
    F.lit("").alias("SCHINSF"),
    F.lit("").alias("SCHCSF"),
    F.lit("").alias("SCHDSF"),
    F.lpad(F.col("UGDEGR").cast("int").cast("string"), 3, "0").alias("UGDEGR"),
    F.substring(F.col("UGLIMIT"), 1, 1).alias("UGLIMIT"),
    F.substring(F.col("LAST"), 1, 20).alias("LAST"),
    F.substring(F.col("FIRST"), 1, 10).alias("FIRST"),
    F.col("MINIT"),
    F.lit("").alias("SCHDC"),
    F.col("TEACHED"),
    F.col("NDS"),
    F.col("ND"),
    F.lit("").alias("GR_SCH"),
    F.col("HS_CODE"),
    F.col("PEIMS_ID"),
    F.col("ETHNIC"),
    F.col("RACE_WHITE"),
    F.col("RACE_BLACK"),
    F.col("RACE_ASIAN"),
    F.col("RACE_NATIVE_AMERICAN"),
    F.col("RACE_INTERNATIONAL"),
    F.col("RACE_UNKNOWN"),
    F.col("RACE_NATIVE_HAWAIIAN"),
    F.col("IDD"),
    F.col("IDD_PROG"),
)

# COMMAND ----------

# Build fixed-width line (163 chars) matching SAS PUT layout
# @pos FIELD format → positional fixed-width output
df_fixed_width = df_final.withColumn(
    "fixed_width_line",
    F.concat(
        fmt_char("RECCODE", 1),
        fmt_char("FICE", 6),
        fmt_char("SIN", 9),
        fmt_char("GENDER", 1),
        fmt_char("CLASS", 1),
        fmt_char("DOB", 8),
        fmt_char("TUITRES", 1),
        fmt_char("RESID", 3),
        fmt_char("TRANCOL", 6),
        fmt_char("SCHON", 4),
        fmt_zero_fill("SCHOFF", 4),
        fmt_char("DOCFUND", 4),
        fmt_char("SEMESTER", 1),
        fmt_char("YEAR", 4),
        fmt_char("INTERSCH", 4),
        fmt_char("FLEX", 1),
        F.when(F.col("REMOTE").isNull(), F.lit(" ")).otherwise(
            F.substring(F.col("REMOTE").cast("string"), 1, 1)
        ),
        fmt_char("CIP", 8),
        fmt_char("DOCFNCD", 2),
        fmt_char("TUITEXT", 2),
        fmt_char("SCHCNSF", 4),
        fmt_char("SCHDNSF", 4),
        fmt_char("SCHINSF", 4),
        fmt_char("SCHCSF", 4),
        fmt_char("SCHDSF", 4),
        fmt_zero_fill("UGDEGR", 3),
        fmt_char("UGLIMIT", 1),
        fmt_char("LAST", 20),
        fmt_char("FIRST", 10),
        fmt_char("MINIT", 1),
        fmt_char("SCHDC", 4),
        fmt_char("TEACHED", 2),
        fmt_char("NDS", 1),
        fmt_char("ND", 1),
        fmt_char("GR_SCH", 4),
        fmt_char("HS_CODE", 6),
        fmt_char("PEIMS_ID", 9),
        fmt_char("ETHNIC", 1),
        fmt_char("RACE_WHITE", 1),
        fmt_char("RACE_BLACK", 1),
        fmt_char("RACE_ASIAN", 1),
        fmt_char("RACE_NATIVE_AMERICAN", 1),
        fmt_char("RACE_INTERNATIONAL", 1),
        fmt_char("RACE_UNKNOWN", 1),
        fmt_char("RACE_NATIVE_HAWAIIAN", 1),
        fmt_char("IDD", 1),
        fmt_char("IDD_PROG", 1),
    ),
)

# Data lines DataFrame
df_data_lines = df_fixed_width.select(F.col("fixed_width_line").alias("value"))


# COMMAND ----------


# FILE 1: Write CBM0E1_{term}_{date}.txt — header + data + EOF
# Get SEMESTER and YEAR from first record for header construction
first_row = df_final.select("SEMESTER", "YEAR").first()
semester_val = first_row["SEMESTER"] or " "
year_val = first_row["YEAR"] or "    "
record_count = df_final.count()

# SAS date format: 23JUN2026 (SYSDATE9.)
sysdate9 = datetime.now().strftime("%d%b%Y").upper()

# Build header line (same width as data records)
header_text = (
    f"HY2K003656CBM0E1"
    f"{semester_val[:1]}"
    f"{year_val[:4]}"
    f"C0140JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU"
)
header_line = header_text.ljust(163)

# Build EOF line
eof_text = f"EOF1{record_count}"
eof_line = eof_text.ljust(len(eof_text))

# Create header and EOF DataFrames with sort keys
header_df = spark.createDataFrame([(header_line, 0)], ["value", "_sort_key"])
eof_df = spark.createDataFrame([(eof_line, 2)], ["value", "_sort_key"])
data_df = df_data_lines.withColumn("_sort_key", F.lit(1))

# Union: header (0) + data (1) + EOF (2), ordered by sort key
df_full_file = (
    header_df.unionAll(data_df).unionAll(eof_df).orderBy("_sort_key").select("value")
)

# Write to text file
cbm_filename = f"CBM0E1_{term}_{sysdate9}"
(df_full_file.coalesce(1).write.mode("overwrite").text(f"{output_path}{cbm_filename}"))

# Rename part file to final filename
_part_files = dbutils.fs.ls(f"{output_path}{cbm_filename}")
_part_file = [f.path for f in _part_files if f.name.startswith("part-")][0]
dbutils.fs.cp(_part_file, f"{output_path}{cbm_filename}.txt")
dbutils.fs.rm(f"{output_path}{cbm_filename}", recurse=True)

print(f"Written: {output_path}{cbm_filename}.txt")

# COMMAND ----------

print(f"CBM0e1 text file generation complete for term={term}")


# COMMAND ----------

# =============================================================================
# CLEANUP: Drop all intermediate staging checkpoint tables
# =============================================================================
for _tmp_tbl in (
    _tmp_stage1_tbl,
    _tmp_stage2_tbl,
    _tmp_stage3_tbl,
    _tmp_stage4_tbl,
    _tmp_stage5_tbl,
    _tmp_stage6_tbl,
    _tmp_stage7_tbl,
    _tmp_stage8_tbl,
):
    try:
        drop_table(_tmp_tbl)
        log_msg(f"Dropped checkpoint temp table: {_tmp_tbl}")
    except Exception as _e:
        log_msg(f"WARN: could not drop {_tmp_tbl}: {_e}")


print(f"Processing fact_thecb_cbm0e1_enrollment_work")
