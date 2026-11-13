# Databricks notebook source
# MAGIC %md
# MAGIC # IPEDS_FALL_ENRL --> transform_analytics_fact_ipeds_fall_enrollment_work
# MAGIC Converted from SAS to PySpark
# MAGIC Source: IPEDS_FALL_ENRL.sas

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

# Import required libraries for datetime handling, PySpark SQL functions, data types, and window operations.
from datetime import datetime
from pyspark.sql import functions as F
from pyspark.sql.types import *
from pyspark.sql import Window

# COMMAND ----------

# Record the job start time and log the job initiation message with a timestamp.
_job_start_time = datetime.now()
log_msg(
    f"Job started: 400_LOAD_EXCESS_HOURS | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)

# COMMAND ----------

# Define input parameters as widgets to receive values from main script
dbutils.widgets.text("term", "2258", "Term")
dbutils.widgets.text("prev_year", "2248", "Previous Year")
dbutils.widgets.text("summerterm", "2255", "Summer Term")
dbutils.widgets.text("fromdate", "2025-08-01 00:00:00", "From Date")
dbutils.widgets.text("todate", "2025-10-15 00:00:00", "To Date")
dbutils.widgets.text("year", "2025", "Year")

# Get parameter values from widgets
term = int(dbutils.widgets.get("term"))
prev_year = int(dbutils.widgets.get("prev_year"))
summerterm = int(dbutils.widgets.get("summerterm"))
fromdate = datetime.strptime(str(dbutils.widgets.get("fromdate")), "%Y-%m-%d %H:%M:%S")
todate = datetime.strptime(str(dbutils.widgets.get("todate")), "%Y-%m-%d %H:%M:%S")
year = int(dbutils.widgets.get("year"))

# COMMAND ----------

# Reads all required source and dimension tables (enrollment, schedule, admissions, residency, etc.) into aliased DataFrames.

aacd = read_table(f"{analytics}.{silver}.dim_thecb_academic_career").alias("AACD")
aa_pland = read_table(f"{analytics}.{silver}.dim_thecb_academic_plan").alias("AA_PlanD")
aadf = read_table(f"{analytics}.{staging}.fact_thecb_application_detail").alias("AADF")
aapd = read_table(f"{analytics}.{silver}.dim_thecb_academic_program").alias("AAPD")
acd = read_table(f"{analytics}.{silver}.dim_thecb_cip_code").alias("ACD")
acod = read_table(f"{analytics}.{silver}.dim_thecb_course_offer").alias("ACOD")
acsf = read_table(f"{analytics}.{staging}.fact_thecb_class_schedule").alias("ACSF")
add = read_table(f"{analytics}.{silver}.dim_thecb_department").alias("ADD")
aed = read_table(f"{analytics}.{silver}.dim_thecb_ethnicity").alias("AED")
aicv = read_table(f"{analytics}.{silver}.dim_thecb_item_code_value").alias("AICV")
aimd = read_table(f"{analytics}.{silver}.dim_thecb_instruction_mode").alias("AIMD")
apd = read_table(f"{analytics}.{silver}.dim_thecb_person").alias("APD")
ard = read_table(f"{analytics}.{silver}.dim_thecb_residency").alias("ARD")
ascef = read_table(f"{analytics}.{staging}.fact_thecb_student_term_course_enrollment").alias(
    "ASCEF"
)
astef = read_table(f"{analytics}.{staging}.fact_thecb_irp_enrollment").alias("ASTEF")
atd = read_table(f"{analytics}.{silver}.dim_thecb_term").alias("ATD")
ife_hist = read_table(f"{analytics}.{archive}.ipeds_fall_enrl_hist").alias("IFE_Hist")
pae = read_table(f"{student}.{bronze}.PS_ADDRESSES").alias("PAE")
pape = read_table(f"{student}.{bronze}.PS_ACAD_PROG").alias("PAPE")
pct = read_table(f"{student}.{bronze}.PS_CLASS_TBL").alias("PCT")
pdee = read_table(f"{student}.{bronze}.PS_DIVERS_ETHNIC").alias("PDEE")
peas = read_table(f"{student}.{bronze}.PS_EXT_ACAD_SUM").alias("PEAS")
ped = read_table(f"{student}.{bronze}.PS_EXT_DEGREE").alias("PED")
pn = read_table(f"{student}.{bronze}.PS_NAMES").alias("PN")
pro = read_table(f"{student}.{bronze}.PS_RESIDENCY_OFF").alias("PRO")
pvpde = read_table(f"{student}.{bronze}.PS_VISA_PMT_DATA").alias("PVPDE")

# COMMAND ----------

# Step: Join
# Create df: ethnic_grp_cd

# Define a window partitioned by EMPLID to compute per-student aggregations.
winSpec_0 = Window.partitionBy(F.col("PDEE.EMPLID"))
# Compute the maximum ethnic group code per student using the window spec.
df_ethnic_grp_cd = pdee.withColumn(
    "MAX_ETHNIC_GRP_CD", F.max(F.col("PDEE.ETHNIC_GRP_CD")).over(winSpec_0)
)

# Flag whether any ethnic group code for the student is 'HISPA' (Hispanic) using a window-level max.
df_ethnic_grp_cd = df_ethnic_grp_cd.withColumn(
    "SEL_MAX_ETHNIC_GRP_CD",
    F.max(
        F.coalesce(
            F.when((F.col("PDEE.ETHNIC_GRP_CD") == F.lit("HISPA")), F.lit(1)).otherwise(
                F.lit(0)
            ),
            F.lit(0),
        )
    ).over(winSpec_0),
)

# Derive the final ethnic group code: assign 'HISPA' if the Hispanic flag is set, otherwise use the max code.
df_ethnic_grp_cd = df_ethnic_grp_cd.withColumn(
    "NEW_ETHNIC_GRP_CD",
    F.coalesce(
        F.when((F.col("SEL_MAX_ETHNIC_GRP_CD") == F.lit(1)), F.lit("HISPA")).otherwise(
            F.col("MAX_ETHNIC_GRP_CD")
        ),
        F.lit(""),
    ),
)

# Drop the intermediate helper columns used for the ethnic group derivation.
df_ethnic_grp_cd = df_ethnic_grp_cd.drop("MAX_ETHNIC_GRP_CD", "SEL_MAX_ETHNIC_GRP_CD")

# Count the number of ethnic group entries per student to detect multiple ethnicities.
df_ethnic_grp_cd = df_ethnic_grp_cd.withColumn(
    "ENTRY_COUNT", F.count(F.col("PDEE.ETHNIC_GRP_CD")).over(winSpec_0)
)

# Select the required columns and deduplicate to produce one row per student-setid combination.
df_ethnic_grp_cd = df_ethnic_grp_cd.select(
    F.col("PDEE.EMPLID"),
    F.col("NEW_ETHNIC_GRP_CD").alias("ETHNIC_GRP_CD"),
    F.col("PDEE.SETID"),
    F.col("ENTRY_COUNT"),
).distinct()


# COMMAND ----------

# Step: ETHNICITY
# Create df: ethnicity_join

# Alias the ethnic group DataFrame for use in a join.
egc = df_ethnic_grp_cd.alias("EGC")

# Join the ethnic group data with the ethnicity dimension table to get the ethnicity group code.
df_ethnicity_join = egc.join(
    aed,
    on=(
        (F.col("EGC.ETHNIC_GRP_CD") == F.col("AED.ETHNIC_GRP_CD"))
        & (F.col("EGC.SETID") == F.col("AED.SETID"))
        & (F.col("AED.is_current") == F.lit(True))
    ),
    how="left",
)

# Select and reshape the ethnicity data: classify students as HISPANIC, MULTIPLE, or their specific ethnic code.
df_ethnicity_join = df_ethnicity_join.select(
    F.col("EGC.EMPLID"),
    F.col("EGC.ETHNIC_GRP_CD"),
    F.col("EGC.SETID"),
    F.col("EGC.ENTRY_COUNT"),
    F.coalesce(
        F.when(
            (F.col("AED.ETHNICGROUPCODE") == F.lit("3")), F.lit("HISPANIC")
        ).otherwise(
            F.coalesce(
                F.when(
                    (F.col("EGC.ENTRY_COUNT") > F.lit(1)), F.lit("MULTIPLE")
                ).otherwise(F.col("EGC.ETHNIC_GRP_CD")),
                F.lit(""),
            )
        ),
        F.lit(""),
    ).alias("ETHN_GRP"),
)


# COMMAND ----------

# Step: max(effdt)
# Create df: ps_acad_prog_max_effdt

# Filter academic program records where EFFDT is on or before the todate cutoff.
df_ps_acad_prog_max_effdt = pape.filter(
    F.coalesce(F.col("PAPE.EFFDT"), F.to_timestamp(F.lit("1900-01-01"))) <= F.lit(todate)
)
df_ps_acad_prog_max_effdt = df_ps_acad_prog_max_effdt.withColumn(
    "MAX_EFFDT",
    F.max(F.col("PAPE.EFFDT")).over(Window.partitionBy("PAPE.EMPLID", "PAPE.ACAD_CAREER", "PAPE.STDNT_CAR_NBR"))
).filter(F.col("PAPE.EFFDT") == F.col("MAX_EFFDT")).drop("MAX_EFFDT")

# Compute the maximum EFFDT per student, career, and career number using a window function.
df_ps_acad_prog_max_effdt = df_ps_acad_prog_max_effdt.withColumn(
    "MAX_EFFDT",
    F.max(
        F.date_format(
            F.coalesce(F.col("PAPE.EFFDT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(Window.partitionBy("PAPE.EMPLID", "PAPE.ACAD_CAREER", "PAPE.STDNT_CAR_NBR")),
)

# Retain only the rows matching the maximum EFFDT and drop the helper column.
df_ps_acad_prog_max_effdt = df_ps_acad_prog_max_effdt.filter(
    F.date_format(
        F.coalesce(F.col("PAPE.EFFDT"), F.lit("1900-01-01 00:00:00")),
        "yyyy-MM-dd HH:mm:ss",
    )
    == F.col("MAX_EFFDT")
).drop("MAX_EFFDT")

# Project all required academic program columns and deduplicate the result.
df_ps_acad_prog_max_effdt = df_ps_acad_prog_max_effdt.select(
    F.col("PAPE.EMPLID"),
    F.col("PAPE.ACAD_CAREER"),
    F.col("PAPE.STDNT_CAR_NBR"),
    F.col("PAPE.EFFDT"),
    F.col("PAPE.EFFSEQ"),
    F.col("PAPE.INSTITUTION"),
    F.col("PAPE.ACAD_PROG"),
    F.col("PAPE.PROG_STATUS"),
    F.col("PAPE.PROG_ACTION"),
    F.col("PAPE.ACTION_DT"),
    F.col("PAPE.PROG_REASON"),
    F.col("PAPE.ADMIT_TERM"),
    F.col("PAPE.EXP_GRAD_TERM"),
    F.col("PAPE.REQ_TERM"),
    F.col("PAPE.ACAD_LOAD_APPR"),
    F.col("PAPE.CAMPUS"),
    F.col("PAPE.DEGR_CHKOUT_STAT"),
    F.col("PAPE.COMPLETION_TERM"),
    F.col("PAPE.ACAD_PROG_DUAL"),
    F.col("PAPE.JOINT_PROG_APPR"),
    F.col("PAPE.ADM_APPL_NBR"),
    F.col("PAPE.APPL_PROG_NBR"),
    F.col("PAPE.DATA_FROM_ADM_APPL"),
    F.col("PAPE.SSR_RS_CANDIT_NBR"),
    F.col("PAPE.SSR_APT_INSTANCE"),
    F.col("PAPE.SSR_YR_OF_PROG"),
    F.col("PAPE.SSR_SHIFT"),
    F.col("PAPE.SSR_COHORT_ID"),
    F.col("PAPE.SCC_ROW_ADD_OPRID"),
    F.col("PAPE.SCC_ROW_ADD_DTTM"),
    F.col("PAPE.SCC_ROW_UPD_OPRID"),
    F.col("PAPE.SCC_ROW_UPD_DTTM"),
    # F.col("PAPE.READ_DTM"),
    # F.col("PAPE.STAGE_UPDATE_ID"),
).distinct()


# COMMAND ----------

# MAX(EFFSEQ)
# Create df: Ps_Acad_Prog

# Alias the max-EFFDT dataset for further processing.
df_ps_acad_prog = df_ps_acad_prog_max_effdt.alias("PAPMED")

# Compute the maximum effective sequence number per EFFDT, career number, career, and student.
df_ps_acad_prog = df_ps_acad_prog.withColumn(
    "MAX_EFFSEQ",
    F.max(F.col("PAPMED.EFFSEQ").cast("bigint")).over(
        Window.partitionBy(
            "PAPMED.EFFDT",
            "PAPMED.STDNT_CAR_NBR",
            "PAPMED.ACAD_CAREER",
            "PAPMED.EMPLID",
        )
    ),
)

# Keep only the rows with the maximum EFFSEQ and remove the helper column.
df_ps_acad_prog = df_ps_acad_prog.filter(
    F.col("PAPMED.EFFSEQ").cast("bigint") == F.col("MAX_EFFSEQ")
).drop("MAX_EFFSEQ")

# Select all required academic program columns and deduplicate to get one row per student-career.
df_ps_acad_prog = df_ps_acad_prog.select(
    F.col("PAPMED.EMPLID"),
    F.col("PAPMED.ACAD_CAREER"),
    F.col("PAPMED.STDNT_CAR_NBR"),
    F.col("PAPMED.EFFDT"),
    F.col("PAPMED.EFFSEQ"),
    F.col("PAPMED.INSTITUTION"),
    F.col("PAPMED.ACAD_PROG"),
    F.col("PAPMED.PROG_STATUS"),
    F.col("PAPMED.PROG_ACTION"),
    F.col("PAPMED.ACTION_DT"),
    F.col("PAPMED.PROG_REASON"),
    F.col("PAPMED.ADMIT_TERM"),
    F.col("PAPMED.EXP_GRAD_TERM"),
    F.col("PAPMED.REQ_TERM"),
    F.col("PAPMED.ACAD_LOAD_APPR"),
    F.col("PAPMED.CAMPUS"),
    F.col("PAPMED.DEGR_CHKOUT_STAT"),
    F.col("PAPMED.COMPLETION_TERM"),
    F.col("PAPMED.ACAD_PROG_DUAL"),
    F.col("PAPMED.JOINT_PROG_APPR"),
    F.col("PAPMED.ADM_APPL_NBR"),
    F.col("PAPMED.APPL_PROG_NBR"),
    F.col("PAPMED.DATA_FROM_ADM_APPL"),
    F.col("PAPMED.SSR_RS_CANDIT_NBR"),
    F.col("PAPMED.SSR_APT_INSTANCE"),
    F.col("PAPMED.SSR_YR_OF_PROG"),
    F.col("PAPMED.SSR_SHIFT"),
    F.col("PAPMED.SSR_COHORT_ID"),
    F.col("PAPMED.SCC_ROW_ADD_OPRID"),
    F.col("PAPMED.SCC_ROW_ADD_DTTM"),
    F.col("PAPMED.SCC_ROW_UPD_OPRID"),
    F.col("PAPMED.SCC_ROW_UPD_DTTM"),
    # F.col("PAPMED.READ_DTM"),
    # F.col("PAPMED.STAGE_UPDATE_ID"),
).distinct()


# COMMAND ----------

# Create df: max_adm_appl_dt_filt

# Filter admission detail records where the application date is on or before the todate cutoff.
df_max_adm_appl_dt_filt = aadf.filter(
    F.date_format(
        F.coalesce(F.col("AADF.ADM_APPL_DT"), F.lit("1900-01-01 00:00:00")),
        "yyyy-MM-dd HH:mm:ss",
    )
    <= F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss")
)

# Define a window partitioned by EMPLID and academic career surrogate key for application date aggregation.
winSpec_1 = Window.partitionBy(F.col("AADF.EMPLID"), F.col("AADF.ACAD_CAREER_SK"))
# Compute the maximum application date per student and career.
df_max_adm_appl_dt_filt = df_max_adm_appl_dt_filt.withColumn(
    "MAX_ADM_APPL_DT",
    F.max(
        F.date_format(
            F.coalesce(F.col("AADF.ADM_APPL_DT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(winSpec_1),
)

# Retain only rows where the application date equals the maximum and remove the helper column.
df_max_adm_appl_dt_filt = df_max_adm_appl_dt_filt.filter(
    F.date_format(
        F.coalesce(F.col("AADF.ADM_APPL_DT"), F.lit("1900-01-01 00:00:00")),
        "yyyy-MM-dd HH:mm:ss",
    )
    == F.col("MAX_ADM_APPL_DT")
).drop("MAX_ADM_APPL_DT")

# Add a formatted ADM_APPL_DT column using the same window aggregation.
df_max_adm_appl_dt_filt = df_max_adm_appl_dt_filt.withColumn(
    "ADM_APPL_DT",
    F.max(
        F.date_format(
            F.coalesce(F.col("AADF.ADM_APPL_DT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(winSpec_1),
)

# Project all required admission detail columns into the final DataFrame.
df_max_adm_appl_dt_filt = df_max_adm_appl_dt_filt.select(
    F.col("AADF.EMPLID"),
    F.col("AADF.INSTITUTION"),
    F.col("AADF.ADM_APPL_NBR"),
    F.col("AADF.FIN_AID_INTEREST"),
    F.col("AADF.HOUSING_INTEREST"),
    F.col("AADF.APPL_FEE_STATUS"),
    F.col("AADF.APPL_FEE_DT"),
    F.col("AADF.ADM_CREATION_DT"),
    F.col("AADF.ADM_UPDATED_DT"),
    F.col("AADF.ADM_APPL_COMPLETE"),
    F.col("ADM_APPL_DT"),
    F.col("AADF.ADM_APPL_CMPLT_DT"),
    F.col("AADF.GRADUATION_DT"),
    F.col("AADF.PRIOR_APPL"),
    F.col("AADF.APPL_FEE_TYPE"),
    F.col("AADF.ADM_APPL_METHOD"),
    F.col("AADF.ACADEMIC_LEVEL"),
    F.col("AADF.STUDENT_CAR_NBR"),
    F.col("AADF.REGION"),
    F.col("AADF.REGION_FROM"),
    F.col("AADF.RECRUITER_ID"),
    F.col("AADF.LAST_SCH_ATTEND"),
    F.col("AADF.EXT_ADM_APPL_NBR"),
    F.col("AADF.PROG_ACTION"),
    F.col("AADF.PROG_REASON"),
    F.col("AADF.PROG_STATUS"),
    F.col("AADF.EXT_ORG_SK"),
    F.col("AADF.PROG_ACTION_DESCR"),
    F.col("AADF.PROG_REASON_DESCR"),
    F.col("AADF.PROG_STATUS_DESCR"),
    F.col("AADF.ACAD_PROGRAM_SK"),
    F.col("AADF.ACAD_PLAN_SK"),
    F.col("AADF.ACAD_CAREER_SK"),
    F.col("AADF.DEPT_SK"),
    F.col("AADF.TERM_SK"),
    F.col("AADF.ADMIT_TYPE_SK"),
    F.col("AADF.YLD_APPL"),
    F.col("AADF.YLD_ADMIT"),
    F.col("AADF.YLD_MATRICULATED"),
    F.col("AADF.YLD_WITHDRAWN"),
    F.col("AADF.YLD_WITHDRAWN_BEFORE_DECSN"),
    F.col("AADF.YLD_WITHDRAWN_AFTER_DECSN"),
    F.col("AADF.YLD_DENIED"),
    F.col("AADF.YLD_ENROLLED"),
    F.col("AADF.LAST_SCH_TRNSFR_HRS"),
    F.col("AADF.LAST_SCH_TRNSFR_GRADE_PNTS"),
    F.col("AADF.LAST_SCH_TRNSFR_GPA"),
    F.col("AADF.LAST_SCH_CUM_TRNSFR_HRS"),
    F.col("AADF.LAST_SCH_CUM_TRNSFR_GRADE_PNTS"),
    F.col("AADF.LAST_SCH_CUML_TRNSFR_GPA"),
    F.col("AADF.LAST_SCH_HS_PCNTL"),
    F.col("AADF.UGRAD_GPA_FOR_GRADUATES"),
    F.col("AADF.SAT_MATH_SCORE"),
    F.col("AADF.SAT_VERBAL_SCORE"),
    F.col("AADF.SAT_TOTAL_SCORE"),
    F.col("AADF.ACT_COMPOSITE_SCORE"),
    F.col("AADF.GRE_VERBAL_RSNG_SCORE"),
    F.col("AADF.GRE_VERBAL_RSNG_SCORE_PCNTL"),
    F.col("AADF.GRE_QUANT_RSNG_SCORE"),
    F.col("AADF.GRE_QUANT_RSNG_SCORE_PCNTL"),
    F.col("AADF.GRE_WRITING_RSNG_SCORE"),
    F.col("AADF.GRE_ANALY_WRITING_SCORE_PCNTL"),
    F.col("AADF.GRE_VERBAL_REVISED_SCORE"),
    F.col("AADF.GRE_VERBAL_REVISED_SCORE_PCNTL"),
    F.col("AADF.GRE_QUANT_REVISED_SCORE"),
    F.col("AADF.GRE_QUANT_REVISED_SCORE_PCNTL"),
    F.col("AADF.GMAT_QUANT_RSNG_SCORE"),
    F.col("AADF.GMAT_QNTATVE_RSNG_SCORE_PCNTL"),
    F.col("AADF.GMAT_VERBAL_RSNG_SCORE"),
    F.col("AADF.GMAT_VERBAL_RSNG_SCORE_PCNTL"),
    F.col("AADF.GMAT_INTGD_RSNG_SCORE"),
    F.col("AADF.GMAT_INTGD_RSNG_SCORE_PCNTL"),
    F.col("AADF.GMAT_ANALY_SCORE"),
    F.col("AADF.GMAT_ANALY_SCORE_PCNTL"),
    F.col("AADF.GMAT_TOTAL_SCORE"),
    F.col("AADF.GMAT_TOTAL_SCORE_PCNTL"),
    #F.col("AADF.UPDATE_DT"),
    #F.col("AADF.UPDATE_USER"),
    F.col("AADF.ACTION_DT"),
    F.col("AADF.TOEFL_COMP_BASED_SCORE"),
    F.col("AADF.TOEFL_IBT_LISTENING_SCORE"),
    F.col("AADF.TOEFL_IBT_READING_SCORE"),
    F.col("AADF.TOEFL_IBT_SPEAKING_SCORE"),
    F.col("AADF.TOEFL_IBT_WRITING_SCORE"),
    F.col("AADF.IELTS_OVERALL_SCORE"),
    F.col("AADF.IELTS_SPEAKING_SCORE"),
)


# COMMAND ----------

# Persist the filtered admission data to a staging checkpoint table to avoid recomputation downstream.
_tmp_stageX_tbl = f"{analytics}.{staging}.max_adm_appl_dt_filt"
write_df_to_table(
    df_max_adm_appl_dt_filt, _tmp_stageX_tbl, mode="overwrite", overwriteSchema="true"
)
df_max_adm_appl_dt_filt = read_table(_tmp_stageX_tbl)
log_msg(f"Checkpoint X materialized: {_tmp_stageX_tbl}")

# COMMAND ----------

# Step: Join
# Create df: acod_max_eff_dt

# Filter course offering dimension records where the effective date is on or before todate.
df_acod_max_eff_dt = acod.filter(
    F.date_format(
        F.coalesce(F.col("ACOD.EFF_DT"), F.lit("1900-01-01 00:00:00")),
        "yyyy-MM-dd HH:mm:ss",
    )
    <= F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss")
)

# Compute the maximum effective date per course identifier using a window function.
df_acod_max_eff_dt = df_acod_max_eff_dt.withColumn(
    "MAX_EFF_DT",
    F.max(
        F.date_format(
            F.coalesce(F.col("ACOD.EFF_DT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(Window.partitionBy("ACOD.COURSE_IDENTIFIER")),
)

# Retain only the most recent effective date row per course and remove the helper column.
df_acod_max_eff_dt = df_acod_max_eff_dt.filter(
    F.date_format(
        F.coalesce(F.col("ACOD.EFF_DT"), F.lit("1900-01-01 00:00:00")),
        "yyyy-MM-dd HH:mm:ss",
    )
    == F.col("MAX_EFF_DT")
).drop("MAX_EFF_DT")

# Project the required course offering columns into the final DataFrame.
df_acod_max_eff_dt = df_acod_max_eff_dt.select(
    F.col("ACOD.COURSE_OFFER_SK"),
    F.col("ACOD.COURSE_IDENTIFIER"),
    F.col("ACOD.COURSE_OFFER_NBR"),
    F.col("ACOD.ACAD_GRP"),
    F.col("ACOD.INSTITUTION"),
    F.col("ACOD.ACAD_CAREER"),
    F.col("ACOD.CATALOG_NBR"),
    F.col("ACOD.SUBJECT"),
    F.col("ACOD.COURSE_APPROVED_FLAG"),
    F.col("ACOD.CAMPUS"),
    F.col("ACOD.SPLIT_OWNER_FLAG"),
    F.col("ACOD.SCHEDULED_TERM_ROLL"),
    F.col("ACOD.CIP_CD"),
    F.col("ACOD.SCHEDULED_COURSE"),
    F.col("ACOD.DYNAMIC_CLASS_DATA"),
    F.col("ACOD.OEE_FLAG"),
    F.col("ACOD.EFF_DT"),
    F.col("ACOD.is_current"),
    #F.col("ACOD.UPDATE_DT"),
    #F.col("ACOD.UPDATE_USER"),
    F.col("ACOD.ACAD_ORG"),
)


# COMMAND ----------

# Step: Join
# Create df: min_term_sk

# Join the student term enrollment fact with the term dimension to get term metadata.
df_min_term_sk = astef.join(
    atd,
    on=(
        F.coalesce(F.col("ASTEF.TERM_SK").cast("bigint"), F.lit(-1))
        == F.coalesce(F.col("ATD.TERM_SK").cast("bigint"), F.lit(-1))
    ),
    how="left",
)

# Retain only rows flagged as the student's first term career enrollment.
df_min_term_sk = df_min_term_sk.filter(
    F.col("ASTEF.FIRST_TERM_CARRER_ENRL_FLG") == F.lit("Y")
)

# Compute the earliest (minimum) term surrogate key per student and career using a window function.
df_min_term_sk = df_min_term_sk.withColumn(
    "MIN_TERM_SK",
    F.min(F.coalesce(F.col("ASTEF.TERM_SK").cast("bigint"), F.lit(-1))).over(
        Window.partitionBy("ASTEF.EMPLID", "ASTEF.ACAD_CAREER_SK")
    ),
)

# Retain only the row with the minimum term SK and remove the helper column.
df_min_term_sk = df_min_term_sk.filter(
    F.coalesce(F.col("ASTEF.TERM_SK").cast("bigint"), F.lit(-1)) == F.col("MIN_TERM_SK")
).drop("MIN_TERM_SK")

# Project required columns and deduplicate to produce one initial-term row per student-career.
df_min_term_sk = df_min_term_sk.select(
    F.col("ASTEF.EMPLID"),
    F.col("ASTEF.ACAD_CAREER_SK"),
    F.col("ASTEF.ACAD_PROGRAM_PRIMARY"),
    F.col("ASTEF.TERM_SK"),
    F.col("ATD.STRM"),
).distinct()


# COMMAND ----------

# Step: Join
# Create df: maj_join

# Create aliases for all dimension DataFrames used in the main multi-table join.
atd_e = atd.alias("ATD_E")
add_major2 = add.alias("ADD_Major2")
add_minor = add.alias("ADD_Minor")
aa_pland_major2 = aa_pland.alias("AA_PlanD_Major2")
aa_pland_minor2 = aa_pland.alias("AA_PlanD_Minor2")
amed = df_acod_max_eff_dt.alias("AMED")
pap = df_ps_acad_prog.alias("PAP")
maadf = df_max_adm_appl_dt_filt.alias("MAADF")
mts = df_min_term_sk.alias("MTS")
ej = df_ethnicity_join.alias("EJ")
ard_overall = ard.alias("ARD_Overall")

# Perform the main multi-way join combining class enrollment, term, schedule, department, program,
# plan, academic level, person, residency, admissions, CIP, initial term, ethnicity, and address data.
df_maj_join = (
    ascef.join(
        astef,
        on=(
            (F.col("ASCEF.EMPLID") == F.col("ASTEF.EMPLID"))
            & (
                F.col("ASCEF.TERM_SK").cast("bigint")
                == F.col("ASTEF.TERM_SK").cast("bigint")
            )
            & (
                F.col("ASCEF.ACAD_CAREER_SK").cast("bigint")
                == F.col("ASTEF.ACAD_CAREER_SK").cast("bigint")
            )
        ),
        how="inner",
    )
    .join(
        atd,
        on=(
            F.col("ASCEF.TERM_SK").cast("bigint") == F.col("ATD.TERM_SK").cast("bigint")
        ),
        how="inner",
    )
    .join(
        atd_e,
        on=(
            (F.col("ATD.STRM") == F.col("ATD_E.STRM"))
            & (F.col("ATD_E.ACAD_CAREER") == F.col("ASCEF.COURSE_CAREER"))
        ),
        how="inner",
    )
    .join(
        acsf,
        on=(
            (
                F.col("ATD_E.TERM_SK").cast("bigint")
                == F.col("ACSF.TERM_SK").cast("bigint")
            )
            & (
                F.col("ASCEF.CLASS_NBR").cast("bigint")
                == F.col("ACSF.CLASS_NBR").cast("bigint")
            )
        ),
        how="left",
    )
    .join(
        add,
        on=(
            F.col("ASCEF.MAJOR_DEPT_SK").cast("bigint")
            == F.col("ADD.DEPT_SK").cast("bigint")
        ),
        how="left",
    )
    .join(
        add_major2,
        on=(
            F.col("ASCEF.MAJOR2_DEPT_SK").cast("bigint")
            == F.col("ADD_Major2.DEPT_SK").cast("bigint")
        ),
        how="left",
    )
    .join(
        add_minor,
        on=(
            F.col("ASCEF.MINOR_DEPT_SK").cast("bigint")
            == F.col("ADD_Minor.DEPT_SK").cast("bigint")
        ),
        how="left",
    )
    .join(
        aapd,
        on=(
            F.col("ASTEF.ACAD_PROGRAM_PRIMARY").cast("bigint")
            == F.col("AAPD.ACAD_PROGRAM_SK").cast("bigint")
        ),
        how="left",
    )
    .join(
        aa_pland,
        on=(
            F.col("ASCEF.MAJOR_ACAD_PLAN_SK").cast("bigint")
            == F.col("AA_PlanD.ACAD_PLAN_SK").cast("bigint")
        ),
        how="left",
    )
    .join(
        aicv,
        on=(
            (F.col("AICV.FIELD_NAME") == F.lit("ACADEMIC_LEVEL"))
            & (
                F.coalesce(F.col("AICV.FIELD_VAL"), F.lit(""))
                == F.coalesce(F.col("ASCEF.ACAD_LEVEL_EOT"), F.lit(""))
            )
        ),
        how="left",
    )
    .join(apd, on=(F.col("ASCEF.EMPLID") == F.col("APD.EMPLID")), how="inner")
    .join(
        aa_pland_major2,
        on=(
            F.col("ASCEF.MAJOR2_ACAD_PLAN_SK").cast("bigint")
            == F.col("AA_PlanD_Major2.ACAD_PLAN_SK").cast("bigint")
        ),
        how="left",
    )
    .join(
        aa_pland_minor2,
        on=(
            F.col("ASCEF.MINOR_ACAD_PLAN_SK").cast("bigint")
            == F.col("AA_PlanD_Minor2.ACAD_PLAN_SK").cast("bigint")
        ),
        how="left",
    )
    .join(
        pct,
        on=(
            (
                F.coalesce(F.col("ASCEF.CRSE_ID"), F.lit(""))
                == F.coalesce(F.col("PCT.CRSE_ID"), F.lit(""))
            )
            & (
                F.col("ASCEF.CLASS_NBR").cast("bigint")
                == F.col("PCT.CLASS_NBR").cast("bigint")
            )
            & (
                F.coalesce(F.col("ASCEF.CLASS_SECTION"), F.lit(""))
                == F.coalesce(F.col("PCT.CLASS_SECTION"), F.lit(""))
            )
        ),
        how="left",
    )
    .join(
        amed,
        on=(
            (
                F.coalesce(F.col("ASCEF.CRSE_ID"), F.lit(""))
                == F.coalesce(F.col("AMED.COURSE_IDENTIFIER"), F.lit(""))
            )
            & (
                F.col("PCT.CRSE_OFFER_NBR").cast("bigint")
                == F.col("AMED.COURSE_OFFER_NBR").cast("bigint")
            )
        ),
        how="left",
    )
    .join(
        aimd,
        on=(
            (F.col("ACSF.INSTRUCTION_MODE") == F.col("AIMD.INSTRN_MODE"))
            & (F.col("AIMD.is_current") == F.lit(True))
        ),
        how="left",
    )
    .join(
        aacd,
        on=(F.col("ASCEF.ACAD_CAREER_SK") == F.col("AACD.ACAD_CAREER_SK")),
        how="left",
    )
    .join(
        pro,
        on=(
            (F.col("ASCEF.EMPLID") == F.col("PRO.EMPLID"))
            & (F.col("PRO.ACAD_CAREER") == F.col("AACD.ACAD_CAREER"))
            & (F.col("PRO.EFFECTIVE_TERM") <= F.col("ATD.STRM"))
        ),
        how="left",
    )
    .join(
        ard,
        on=(
            F.coalesce(F.col("PRO.TUITION_RES"), F.lit(""))
            == F.coalesce(F.col("ARD.RESIDENCY_CD"), F.lit(""))
        ),
        how="left",
    )
    .join(
        pap,
        on=(
            (F.col("PAP.EMPLID") == F.col("ASCEF.EMPLID"))
            & (F.col("PAP.ACAD_CAREER") == F.col("AACD.ACAD_CAREER"))
            & (
                F.col("PAP.STDNT_CAR_NBR").cast("bigint")
                == F.col("ASTEF.STUDENT_CAREER_NBR").cast("bigint")
            )
        ),
        how="left",
    )
    .join(
        peas,
        on=(
            (F.col("ASCEF.EMPLID") == F.col("PEAS.EMPLID"))
            & (F.col("PEAS.EXT_SUMM_TYPE") == F.lit("COLL"))
        ),
        how="left",
    )
    .join(
        maadf,
        on=(
            (F.col("ASCEF.EMPLID") == F.col("MAADF.EMPLID"))
            & (
                F.col("ASCEF.ACAD_CAREER_SK").cast("bigint")
                == F.col("MAADF.ACAD_CAREER_SK").cast("bigint")
            )
        ),
        how="left",
    )
    .join(
        acd,
        on=(
            F.coalesce(F.col("ACD.CIP_CD"), F.lit(""))
            == F.coalesce(F.col("AA_PlanD.CIP_CD"), F.lit(""))
        ),
        how="left",
    )
    .join(
        mts,
        on=(
            (F.col("ASCEF.EMPLID") == F.col("MTS.EMPLID"))
            & (
                F.col("ASTEF.ACAD_CAREER_SK").cast("bigint")
                == F.col("MTS.ACAD_CAREER_SK").cast("bigint")
            )
        ),
        how="left",
    )
    .join(
        ej,
        on=(
            F.coalesce(F.col("APD.EMPLID"), F.lit(""))
            == F.coalesce(F.col("EJ.EMPLID"), F.lit(""))
        ),
        how="left",
    )
    .join(
        ard_overall,
        on=(
            (
                F.coalesce(F.col("PRO.RESIDENCY"), F.lit(""))
                == F.coalesce(F.col("ARD_Overall.RESIDENCY_CD"), F.lit(""))
            )
            & (F.col("ARD_Overall.is_current") == F.lit(True))
        ),
        how="left",
    )
)

# COMMAND ----------

# Apply enrollment eligibility filters: active enrollment flag, term/date range conditions,
# valid CIP, allowed academic programs, and exclusion of transfer-only course sections.

df_maj_join = df_maj_join.filter(
    (F.col("ASCEF.STUDENT_ENRL_FLG") == F.lit("Y"))
    & (
        (
            (F.col("ATD.STRM") == F.lit(term))
            & (
                F.date_format(
                    F.coalesce(F.col("ACSF.START_DT"), F.lit("1900-01-01 00:00:00")),
                    "yyyy-MM-dd HH:mm:ss",
                )
                >= F.date_format(F.lit(fromdate), "yyyy-MM-dd HH:mm:ss")
            )
            & (
                F.date_format(
                    F.coalesce(F.col("ACSF.START_DT"), F.lit("1900-01-01 00:00:00")),
                    "yyyy-MM-dd HH:mm:ss",
                )
                <= F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss")
            )
        )
        | (
            (F.col("ATD.STRM") == F.lit(summerterm))
            & (F.trim(F.col("ASTEF.COHORT_ENTRY")) != F.lit("Continuing Student"))
            & (~(F.col("AAPD.ACAD_PROGRAM").isin(["UGNDS", "CERT", "UGRD2", "SPEC"])))
        )
    )
    & (F.coalesce(F.col("ACD.is_current"), F.lit(None)) == F.lit(True))
    & (
        F.col("AAPD.ACAD_PROGRAM").isin(
            ["MASTR", "UGRD", "UGNDS", "CERT", "UGRD2", "SPEC", "DOCT"]
        )
    )
    & (F.coalesce(F.col("PCT.ACAD_ORG"), F.lit("")) != F.lit("TRAN"))
)

# Compute the maximum PRO.EFFECTIVE_TERM per student, term, and career to get the most current residency row.
df_maj_join = df_maj_join.withColumn(
    "MAX_EFFECTIVE_TERM",
    F.max(F.col("PRO.EFFECTIVE_TERM")).over(
        Window.partitionBy("ASCEF.EMPLID", "ATD.STRM", "AACD.ACAD_CAREER")
    ),
)

# Keep only rows where PRO.EFFECTIVE_TERM is the maximum and drop the helper column.
df_maj_join = df_maj_join.filter(
    F.col("PRO.EFFECTIVE_TERM") == F.col("MAX_EFFECTIVE_TERM")
).drop("MAX_EFFECTIVE_TERM")

# Compute the student's age as the difference between the reporting year and birth year.
year_diff = F.lit(year).cast("BIGINT") - F.year(F.col("APD.BIRTH_DT").cast("date"))
# Derive IPEDS age group category and determine the normalized ethnicity group (FORGN/NSPEC override).
df_maj_join = df_maj_join.withColumn(
    "AGE_GROUP",
    F.when((year_diff < F.lit(18)), F.lit("Under 18"))
    .when(((year_diff >= F.lit(18)) & (year_diff <= F.lit(19))), F.lit("18-19"))
    .when(((year_diff >= F.lit(20)) & (year_diff <= F.lit(21))), F.lit("20-21"))
    .when(((year_diff >= F.lit(22)) & (year_diff <= F.lit(24))), F.lit("22-24"))
    .when(((year_diff >= F.lit(25)) & (year_diff <= F.lit(29))), F.lit("25-29"))
    .when(((year_diff >= F.lit(30)) & (year_diff <= F.lit(34))), F.lit("30-34"))
    .when(((year_diff >= F.lit(35)) & (year_diff <= F.lit(39))), F.lit("35-39"))
    .when(((year_diff >= F.lit(40)) & (year_diff <= F.lit(49))), F.lit("40-49"))
    .when(((year_diff >= F.lit(50)) & (year_diff <= F.lit(64))), F.lit("50-64"))
    .when((year_diff >= F.lit(65)), F.lit("65 and over"))
    .otherwise(F.lit("Age unknown/unreported")),
).withColumn(
    "NEW_ETHN_GRP",
    F.when(
        (
            F.trim(F.coalesce(F.col("AA_PlanD.ACAD_PLAN"), F.lit("")))
            == F.lit("EMBAMBNT")
        ),
        F.lit("NSPEC"),
    )
    .when(
        (F.trim(F.coalesce(F.col("PRO.RESIDENCY"), F.lit(""))) == F.lit("4")),
        F.lit("FORGN"),
    )
    .when(
        (F.col("EJ.ETHN_GRP").isNull() | (F.col("EJ.ETHN_GRP") == F.lit(""))),
        F.lit("NSPEC"),
    )
    .otherwise(F.coalesce(F.col("EJ.ETHN_GRP"), F.lit(""))),
)


# COMMAND ----------

# Select all required output columns from the joined dataset into a flat projection.
df_maj_join = df_maj_join.select(
    F.lit("").alias("MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("ASCEF.EMPLID"),
    F.lit(-1).alias("ENROLLED_WITHIN_12_MONTHS"),
    F.when(
        F.trim(F.col("ASTEF.COHORT_ENTRY")).isin(
            "New Undergraduate Telecampus",
            "New Undergraduate Transient",
            "Continuing Student",
        ),
        F.lit("Other"),
    )
    .when(
        F.col("AAPD.ACAD_PROGRAM").isin(["UGNDS", "CERT", "UGRD2", "SPEC"]),
        F.lit("Other"),
    )
    .otherwise(F.col("ASTEF.COHORT_ENTRY"))
    .alias("COHORT_ENTRY"),
    (year_diff).alias("Age"),
    F.col("AGE_GROUP"),
    F.col("AACD.ACAD_CAREER"),
    F.col("AAPD.ACAD_PROGRAM"),
    F.col("ADD.DEPT").alias("MAJOR1_DEPT"),
    F.col("ADD_Major2.DEPT").alias("MAJOR2_DEPT"),
    F.col("ADD_Minor.DEPT").alias("MINOR1_DEPT"),
    F.date_format(F.current_timestamp(), "yyyy-MM-dd HH:mm:ss").alias("SNAPSHOT_DT"),
    F.col("ATD.STRM"),
    F.col("ASTEF.ACAD_LVL_LOAD_EOT").alias("ACAD_LEVEL_EOT_CD"),
    F.col("AICV.DESCR").alias("ACAD_LEVEL_EOT_DESCR"),
    F.col("APD.FIRST_NAME"),
    F.col("APD.MIDDLE_NAME"),
    F.col("APD.BIRTH_DT"),
    F.col("APD.GENDER"),
    F.concat_ws(
        F.lit(" "),
        F.trim(F.col("APD.HOME_ADDR_1")),
        F.trim(F.col("APD.HOME_ADDR_2")),
        F.trim(F.col("APD.HOME_ADDR_3")),
        F.trim(F.col("APD.HOME_ADDR_4")),
    ).alias("ADDRESS"),
    F.col("APD.HOME_ADDR_CITY"),
    F.col("APD.HOME_ADDR_STATE"),
    F.col("APD.HOME_ADDR_POSTAL"),
    F.col("APD.HOME_ADDR_COUNTRY"),
    F.col("APD.HOME_ADDR_GEOCODE"),
    F.col("APD.LAST_NAME"),
    F.col("NEW_ETHN_GRP").alias("ETHN_GRP"),
    F.col("EJ.ETHN_GRP").alias("Student_Ethnicity"),
    F.col("AA_PlanD.ACAD_PLAN").alias("MAJOR1_PLAN"),
    F.col("AA_PlanD.CIP_CD").alias("MAJOR1_CIP_CD"),
    F.when((F.col("ASTEF.MAJOR2_DEPT_SK") == (F.lit(-1))), F.lit(None))
    .otherwise(F.col("AA_PlanD_Major2.ACAD_PLAN"))
    .alias("MAJOR2_PLAN"),
    F.when((F.col("ASTEF.MAJOR2_DEPT_SK") == (F.lit(-1))), F.lit(None))
    .otherwise(F.col("AA_PlanD_Major2.CIP_CD"))
    .alias("MAJOR2_CIP_CD"),
    F.col("AA_PlanD_Minor2.ACAD_PLAN").alias("MINOR1_PLAN"),
    F.col("AA_PlanD_Minor2.CIP_CD").alias("MINOR1_CIP_CD"),
    F.col("ASCEF.CRSE_ID").alias("COURSE_ID"),
    F.col("AMED.CATALOG_NBR"),
    F.col("AMED.SUBJECT"),
    F.col("ACSF.INSTRUCTION_MODE"),
    F.col("ACSF.START_DT").alias("CLASS_START_DT"),
    F.col("ACSF.END_DT").alias("CLASS_END_DT"),
    F.col("ACSF.CLASS_SECTION"),
    F.col("AIMD.DESCR").alias("INSTRUCTION_MODE_DESCR"),
    F.col("ASCEF.ENRL_ADD_DT"),
    F.col("ASCEF.SESSION_CD"),
    F.col("ASCEF.UNIT_TAKEN"),
    F.col("PAP.ADMIT_TERM"),
    F.col("PRO.RESIDENCY"),
    F.col("ASCEF.CLASS_NBR"),
    F.col("MTS.STRM").alias("INIT_TERM"),
    F.col("ATD.DESCR").alias("TERM_DESCR"),
    F.col("ATD.ACAD_YEAR"),
    F.col("ACD.DESCR254").alias("CIP_CD_DESCR"),
    F.col("AAPD.DESCR").alias("ACAD_PROGRAM_DESCR"),
    F.col("AACD.DESCR").alias("ACAD_CAREER_DESCR"),
    F.col("ADD.DEPT"),
    F.col("ADD.COLLEGE"),
    F.col("ADD.COLLEGE_DESCR"),
    F.col("ADD.DEPT_DESCR"),
    F.col("ARD.DESCR").alias("TUITION_RESIDENCY_DESCR"),
    F.col("APD.HOME_ADDR_COUNTY"),
    F.col("PRO.TUITION_RES"),
    F.col("ARD_Overall.DESCR").alias("RESIDENCY_DESCR"),
).distinct()


# COMMAND ----------

# Persist the major join result to a staging checkpoint table for downstream reuse.
_tmp_stageA_tbl = f"{analytics}.{staging}.major_join"
write_df_to_table(
    df_maj_join, _tmp_stageA_tbl, mode="overwrite", overwriteSchema="true"
)
df_maj_join = read_table(_tmp_stageA_tbl)
log_msg(f"Checkpoint A materialized: {_tmp_stageA_tbl}")

# COMMAND ----------

# Create df: ps_addr_type_home

# Filter home address records of type 'HOME' with an EFFDT on or before todate.
df_ps_addr_type_home = pae.filter(
    (F.col("PAE.ADDRESS_TYPE") == F.lit("HOME"))
    & (
        (
            F.date_format(
                F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        <= (F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss"))
    )
)

# Compute the maximum EFFDT per student and address type to find the most current address.
df_ps_addr_type_home = df_ps_addr_type_home.withColumn(
    "MAX_EFFDT",
    F.max(
        F.date_format(
            F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(Window.partitionBy("PAE.EMPLID", "PAE.ADDRESS_TYPE")),
)

# Keep only the active (EFF_STATUS='A') row matching the maximum EFFDT and drop the helper column.
df_ps_addr_type_home = df_ps_addr_type_home.filter(
    (
        (
            F.date_format(
                F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        == F.col("MAX_EFFDT")
    )
    & (F.col("PAE.EFF_STATUS") == F.lit("A"))
).drop("MAX_EFFDT")

# Project required home address columns into the result.
df_ps_addr_type_home = df_ps_addr_type_home.select(
    F.col("PAE.ADDR_FIELD1"),
    F.col("PAE.ADDR_FIELD2"),
    F.col("PAE.ADDR_FIELD3"),
    F.col("PAE.ADDRESS_TYPE"),
    F.col("PAE.ADDRESS1"),
    F.col("PAE.ADDRESS2"),
    F.col("PAE.ADDRESS3"),
    F.col("PAE.ADDRESS4"),
    F.col("PAE.CITY"),
    F.col("PAE.COUNTRY"),
    F.col("PAE.COUNTY"),
    F.col("PAE.EFF_STATUS"),
    F.col("PAE.EFFDT"),
    F.col("PAE.EMPLID"),
    F.col("PAE.GEO_CODE"),
    F.col("PAE.POSTAL"),
    F.col("PAE.REG_REGION"),
    F.col("PAE.STATE"),
)


# COMMAND ----------

# Create df: ps_addr_type_sevf

# Filter foreign/SEVF address records with EFFDT on or before todate.
df_ps_addr_type_sevf = pae.filter(
    (F.col("PAE.ADDRESS_TYPE") == F.lit("SEVF"))
    & (
        (
            F.date_format(
                F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        <= (F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss"))
    )
)

# Compute the maximum EFFDT per student and SEVF address type.
df_ps_addr_type_sevf = df_ps_addr_type_sevf.withColumn(
    "MAX_EFFDT",
    F.max(
        F.date_format(
            F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(Window.partitionBy("PAE.EMPLID", "PAE.ADDRESS_TYPE")),
)

# Retain only the active row matching the maximum EFFDT and drop the helper column.
df_ps_addr_type_sevf = df_ps_addr_type_sevf.filter(
    (
        (
            F.date_format(
                F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        == F.col("MAX_EFFDT")
    )
    & (F.col("PAE.EFF_STATUS") == F.lit("A"))
).drop("MAX_EFFDT")

# Project all SEVF address columns into the result.
df_ps_addr_type_sevf = df_ps_addr_type_sevf.select(
    F.col("PAE.ADDR_FIELD1"),
    F.col("PAE.ADDR_FIELD2"),
    F.col("PAE.ADDR_FIELD3"),
    F.col("PAE.ADDRESS_TYPE"),
    F.col("PAE.ADDRESS1"),
    F.col("PAE.ADDRESS1_AC"),
    F.col("PAE.ADDRESS2"),
    F.col("PAE.ADDRESS2_AC"),
    F.col("PAE.ADDRESS3"),
    F.col("PAE.ADDRESS3_AC"),
    F.col("PAE.ADDRESS4"),
    F.col("PAE.CITY"),
    F.col("PAE.CITY_AC"),
    F.col("PAE.COUNTRY"),
    F.col("PAE.COUNTY"),
    F.col("PAE.EFF_STATUS"),
    F.col("PAE.EFFDT"),
    F.col("PAE.EMPLID"),
    F.col("PAE.GEO_CODE"),
    F.col("PAE.HOUSE_TYPE"),
    F.col("PAE.IN_CITY_LIMIT"),
    F.col("PAE.LASTUPDDTTM"),
    F.col("PAE.LASTUPDOPRID"),
    F.col("PAE.NUM1"),
    F.col("PAE.NUM2"),
    F.col("PAE.POSTAL"),
    F.col("PAE.REG_REGION"),
    F.col("PAE.STATE"),
    # F.col("PAE.READ_DTM"),
    # F.col("PAE.STAGE_UPDATE_ID")
)


# COMMAND ----------

# Create df: ps_addr_type_perm

# Filter permanent address records with EFFDT on or before todate.
df_ps_addr_type_perm = pae.filter(
    (F.col("PAE.ADDRESS_TYPE") == F.lit("PERM"))
    & (
        (
            F.date_format(
                F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        <= (F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss"))
    )
)

# Compute the maximum EFFDT per student and PERM address type.
df_ps_addr_type_perm = df_ps_addr_type_perm.withColumn(
    "MAX_EFF",
    F.max(
        F.date_format(
            F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(Window.partitionBy("PAE.ADDRESS_TYPE", "PAE.EMPLID")),
)

# Retain only the active PERM address row matching the maximum EFFDT and drop the helper column.
df_ps_addr_type_perm = df_ps_addr_type_perm.filter(
    (
        (
            F.date_format(
                F.coalesce(F.col("PAE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        == F.col("MAX_EFF")
    )
    & (F.col("PAE.EFF_STATUS") == F.lit("A"))
).drop("MAX_EFF")

# Project all required permanent address columns into the result.
df_ps_addr_type_perm = df_ps_addr_type_perm.select(
    F.col("PAE.ADDR_FIELD1"),
    F.col("PAE.ADDR_FIELD2"),
    F.col("PAE.ADDR_FIELD3"),
    F.col("PAE.ADDRESS_TYPE"),
    F.col("PAE.ADDRESS1"),
    F.col("PAE.ADDRESS1_AC"),
    F.col("PAE.ADDRESS2"),
    F.col("PAE.ADDRESS2_AC"),
    F.col("PAE.ADDRESS3"),
    F.col("PAE.ADDRESS3_AC"),
    F.col("PAE.ADDRESS4"),
    F.col("PAE.CITY"),
    F.col("PAE.CITY_AC"),
    F.col("PAE.COUNTRY"),
    F.col("PAE.COUNTY"),
    F.col("PAE.EFF_STATUS"),
    F.col("PAE.EFFDT"),
    F.col("PAE.EMPLID"),
    F.col("PAE.GEO_CODE"),
    F.col("PAE.HOUSE_TYPE"),
    F.col("PAE.IN_CITY_LIMIT"),
    F.col("PAE.LASTUPDDTTM"),
    F.col("PAE.LASTUPDOPRID"),
    F.col("PAE.NUM1"),
    F.col("PAE.NUM2"),
    F.col("PAE.POSTAL"),
    F.col("PAE.REG_REGION"),
    F.col("PAE.STATE"),
    # F.col("PAE.READ_DTM"),
    # F.col("PAE.STAGE_UPDATE_ID"),
)


# COMMAND ----------

# Create df: ps_visa_permit_type

# Filter visa/permit records with EFFDT on or before todate, excluding 'AR1' permit type.
df_ps_visa_permit_type = pvpde.filter(
    (
        (
            F.date_format(
                F.coalesce(F.col("PVPDE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        <= F.lit(todate)
    )
    & (F.col("PVPDE.VISA_PERMIT_TYPE") != F.lit("AR1"))
)

# Compute the most recent EFFDT per student across all visa records.
df_ps_visa_permit_type = df_ps_visa_permit_type.withColumn(
    "MAX_EFFDT",
    F.max(
        F.date_format(
            F.coalesce(F.col("PVPDE.EFFDT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(Window.partitionBy("PVPDE.EMPLID")),
)

# Keep only the most recent row and restrict to specific non-immigrant/special status visa types.
df_ps_visa_permit_type = df_ps_visa_permit_type.filter(
    (
        (
            F.date_format(
                F.coalesce(F.col("PVPDE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        == F.col("MAX_EFFDT")
    )
    & (F.col("PVPDE.VISA_PERMIT_TYPE").isin(["NV", "ASY", "LPR", "REF", "TPS", "PLP"]))
).drop("MAX_EFFDT")

# Select EMPLID, visa/permit type, and effective date columns.
df_ps_visa_permit_type = df_ps_visa_permit_type.select(
    F.col("PVPDE.EMPLID"), F.col("PVPDE.VISA_PERMIT_TYPE"), F.col("PVPDE.EFFDT")
)


# COMMAND ----------

# Build the state-to-FIPS mapping list from the STFIPS_MAP dictionary for use in a PySpark map column.
_map_pairs = []

for k, v in STFIPS_MAP.items():
    _map_pairs += [F.lit(k), F.lit(v)]

# Create a PySpark map column from the key-value pairs for FIPS code lookup.
stfips_map_col = F.create_map(*_map_pairs)

# Define a helper function that looks up the FIPS code for a given state abbreviation column.
def stfips(col):
    return stfips_map_col[F.upper(F.trim(col))]


# COMMAND ----------

# Step: IPEDS State
# Create df: ipeds_state

# Create aliases for the main join and address DataFrames used in the IPEDS state derivation.
mj = df_maj_join.alias("MJ")
pats = df_ps_addr_type_sevf.alias("PATS")
path = df_ps_addr_type_home.alias("PATH")
patp = df_ps_addr_type_perm.alias("PATP")
pvpt = df_ps_visa_permit_type.alias("PVPT")

# Join the main enrollment dataset with term, SEVF, HOME, PERM addresses, and visa data to enrich address info.
df_ipeds_state = (
    mj.join(
        atd,
        on=(
            (F.col("MJ.STRM") == F.col("ATD.STRM"))
            & (F.col("MJ.ACAD_CAREER") == F.col("ATD.ACAD_CAREER"))
        ),
        how="left",
    )
    .join(
        pats,
        on=(
            (F.col("MJ.EMPLID") == F.col("PATS.EMPLID"))
            & (
                F.date_format(
                    F.coalesce(F.col("PATS.EFFDT"), F.lit("1900-01-01 00:00:00")),
                    "yyyy-MM-dd HH:mm:ss",
                )
                <= F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss")
            )
            & (F.col("PATS.ADDRESS_TYPE") == F.lit("SEVF"))
        ),
        how="left",
    )
    .join(path, on=(F.col("MJ.EMPLID") == F.col("PATH.EMPLID")), how="left")
    .join(patp, on=(F.col("MJ.EMPLID") == F.col("PATP.EMPLID")), how="left")
    .join(pvpt, on=(F.col("MJ.EMPLID") == F.col("PVPT.EMPLID")), how="left")
)

# Remove any address rows whose EFFDT exceeds the todate cutoff.
df_ipeds_state = df_ipeds_state.filter(
    F.date_format(
        F.coalesce(F.col("PATS.EFFDT"), F.lit("1900-01-01 00:00:00")),
        "yyyy-MM-dd HH:mm:ss",
    )
    <= F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss")
)

# Compute the latest SEVF address EFFDT per student and term begin date.
df_ipeds_state = df_ipeds_state.withColumn(
    "MAX_EFFDT",
    F.max(F.date_format(F.col("PATS.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("MJ.EMPLID", "ATD.TERM_BEGIN_DT")
    ),
)

# Retain only rows where the SEVF EFFDT equals the maximum (or where no SEVF address exists) and drop helper.
df_ipeds_state = df_ipeds_state.filter(
    (F.col("MAX_EFFDT").isNull())
    | (F.date_format(F.col("PATS.EFFDT"), "yyyy-MM-dd HH:mm:ss") == F.col("MAX_EFFDT"))
).drop("MAX_EFFDT")

# Define three address-selection conditions:
# cond1: foreign residency without a recognized visa type,
# cond2: student has a SEVF (foreign) address,
# cond3: student has a PERM (permanent) address.
cond1 = (F.col("MJ.RESIDENCY") == F.lit("4")) & (F.col("PVPT.EMPLID").isNull())
cond2 = F.col("PATS.ADDRESS_TYPE") == F.lit("SEVF")
cond3 = F.col("PATP.ADDRESS_TYPE") == F.lit("PERM")

# Derive IPEDS address fields (state, FIPS code, city, county, postal, full address, country)
# by selecting the appropriate address source (SEVF → PERM → HOME) based on residency and visa conditions.
df_ipeds_state = (
    df_ipeds_state.withColumn(
        "NEW_ADDRESS",
        F.trim(
            F.concat_ws(
                F.lit(" "),
                F.trim(F.col("PATH.ADDRESS1")),
                F.trim(F.col("PATH.ADDRESS2")),
                F.trim(F.col("PATH.ADDRESS3")),
                F.trim(F.col("PATH.ADDRESS4")),
            )
        ),
    )
    .withColumn(
        "IPEDS_STATE",
        F.when((cond1 & cond2), F.col("PATS.STATE"))
        .when((cond1 & cond3), F.col("PATP.STATE"))
        .otherwise(F.col("PATH.STATE")),
    )
    .withColumn(
        "IPEDS_FIPS_CD",
        F.when((cond1 & cond2), stfips(F.col("PATS.STATE")))
        .when((cond1 & cond3), stfips(F.col("PATP.STATE")))
        .otherwise(stfips(F.col("PATH.STATE"))),
    )
    .withColumn(
        "IPEDS_CITY",
        F.when((cond1 & cond2), F.col("PATS.CITY"))
        .when((cond1 & cond3), F.col("PATP.CITY"))
        .otherwise(F.col("PATH.CITY")),
    )
    .withColumn(
        "IPEDS_COUNTY_CODE",
        F.when((cond1 & cond2), F.col("PATS.COUNTY"))
        .when((cond1 & cond3), F.col("PATP.COUNTY"))
        .otherwise(F.col("PATH.COUNTY")),
    )
    .withColumn(
        "IPEDS_POSTAL",
        F.when((cond1 & cond2), F.col("PATS.POSTAL"))
        .when((cond1 & cond3), F.col("PATP.POSTAL"))
        .otherwise(F.col("PATH.POSTAL")),
    )
    .withColumn(
        "IPEDS_ADDR",
        F.when(
            (cond1 & cond2),
            F.trim(
                F.concat_ws(
                    F.lit(" "),
                    F.trim(F.col("PATS.ADDRESS1")),
                    F.trim(F.col("PATS.ADDRESS2")),
                    F.trim(F.col("PATS.ADDRESS3")),
                    F.trim(F.col("PATS.ADDRESS4")),
                )
            ),
        )
        .when(
            (cond1 & cond3),
            F.trim(
                F.concat_ws(
                    F.lit(" "),
                    F.trim(F.col("PATP.ADDRESS1")),
                    F.trim(F.col("PATP.ADDRESS2")),
                    F.trim(F.col("PATP.ADDRESS3")),
                    F.trim(F.col("PATP.ADDRESS4")),
                )
            ),
        )
        .otherwise(
            F.trim(
                F.concat_ws(
                    F.lit(" "),
                    F.trim(F.col("PATH.ADDRESS1")),
                    F.trim(F.col("PATH.ADDRESS2")),
                    F.trim(F.col("PATH.ADDRESS3")),
                    F.trim(F.col("PATH.ADDRESS4")),
                )
            )
        ),
    )
    .withColumn(
        "IPEDS_COUNTRY",
        F.when((cond1 & cond2), F.col("PATS.COUNTRY"))
        .when((cond1 & cond3), F.col("PATP.COUNTRY"))
        .otherwise(F.col("PATH.COUNTRY")),
    )
    .withColumn(
        "IPEDS_COUNTY",
        F.when((cond1 & cond2), F.col("PATS.COUNTY"))
        .when((cond1 & cond3), F.col("PATP.COUNTY"))
        .otherwise(F.col("PATH.COUNTY")),
    )
)

# COMMAND ----------

# Project all required enrollment and address columns into the IPEDS state result DataFrame.
df_ipeds_state = df_ipeds_state.select(
    F.col("MJ.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("MJ.EMPLID"),
    F.col("MJ.ENROLLED_WITHIN_12_MONTHS"),
    F.col("MJ.COHORT_ENTRY"),
    F.col("MJ.Age"),
    F.col("MJ.AGE_GROUP"),
    F.col("MJ.ACAD_CAREER"),
    F.col("MJ.ACAD_PROGRAM"),
    F.col("MJ.MAJOR1_DEPT"),
    F.col("MJ.MAJOR2_DEPT"),
    F.col("MJ.MINOR1_DEPT"),
    F.col("MJ.STRM"),
    F.col("MJ.ACAD_LEVEL_EOT_CD"),
    F.col("MJ.ACAD_LEVEL_EOT_DESCR"),
    F.col("MJ.FIRST_NAME"),
    F.col("MJ.MIDDLE_NAME"),
    F.col("MJ.BIRTH_DT"),
    F.col("MJ.GENDER"),
    F.col("NEW_ADDRESS").alias("ADDRESS"),
    F.col("PATH.CITY").alias("HOME_ADDR_CITY"),
    F.col("PATH.STATE").alias("HOME_ADDR_STATE"),
    F.col("PATH.POSTAL").alias("HOME_ADDR_POSTAL"),
    F.col("PATH.COUNTRY").alias("HOME_ADDR_COUNTRY"),
    F.col("PATH.GEO_CODE").alias("HOME_ADDR_GEOCODE"),
    F.col("MJ.LAST_NAME"),
    F.col("MJ.ETHN_GRP"),
    F.col("MJ.Student_Ethnicity"),
    F.col("MJ.MAJOR1_PLAN"),
    F.col("MJ.MAJOR1_CIP_CD"),
    F.col("MJ.MAJOR2_PLAN"),
    F.col("MJ.MAJOR2_CIP_CD"),
    F.col("MJ.MINOR1_PLAN"),
    F.col("MJ.MINOR1_CIP_CD"),
    F.col("MJ.COURSE_ID"),
    F.col("MJ.CATALOG_NBR"),
    F.col("MJ.SUBJECT"),
    F.col("MJ.INSTRUCTION_MODE"),
    F.col("MJ.CLASS_START_DT"),
    F.col("MJ.CLASS_END_DT"),
    F.col("MJ.CLASS_SECTION"),
    F.col("MJ.INSTRUCTION_MODE_DESCR"),
    F.col("MJ.ENRL_ADD_DT"),
    F.col("MJ.SESSION_CD"),
    F.col("MJ.UNIT_TAKEN"),
    F.col("MJ.ADMIT_TERM"),
    F.col("MJ.RESIDENCY"),
    F.col("MJ.CLASS_NBR"),
    F.col("MJ.SNAPSHOT_DT"),
    F.col("MJ.TERM_DESCR"),
    F.col("MJ.ACAD_YEAR"),
    F.col("IPEDS_STATE"),
    F.col("IPEDS_FIPS_CD"),
    F.col("MJ.CIP_CD_DESCR"),
    F.col("MJ.ACAD_PROGRAM_DESCR"),
    F.col("MJ.ACAD_CAREER_DESCR"),
    F.col("MJ.INIT_TERM"),
    F.col("MJ.DEPT"),
    F.col("MJ.COLLEGE"),
    F.col("MJ.COLLEGE_DESCR"),
    F.col("MJ.DEPT_DESCR"),
    F.col("MJ.TUITION_RESIDENCY_DESCR"),
    F.col("IPEDS_CITY"),
    F.col("IPEDS_COUNTY_CODE"),
    F.col("IPEDS_POSTAL"),
    F.col("PATH.COUNTY").alias("HOME_ADDR_COUNTY"),
    F.col("IPEDS_ADDR"),
    F.col("IPEDS_COUNTRY"),
    F.col("MJ.TUITION_RES"),
    F.col("IPEDS_COUNTY"),
    F.col("MJ.RESIDENCY_DESCR"),
    F.col("ATD.INSTITUTION"),
    F.col("ATD.DESCR"),
    F.col("ATD.SHORT_DESCR"),
    F.col("ATD.TERM_BEGIN_DT"),
    F.col("ATD.TERM_END_DT"),
    F.col("ATD.SESSION_DESCR"),
    F.col("ATD.SESSION_SHORT_DESCR"),
    F.col("ATD.WEEKS_OF_INSTRN"),
    F.col("ATD.TERM_CATEGORY_CD"),
    F.col("ATD.TERM_CATEGORY_DESCR"),
    F.col("ATD.TERM_CATEGORY_SHORT_DESCR"),
    F.col("ATD.HOLIDAY_SCHEDULE"),
    F.col("ATD.SIXTY_PERCENT_DT"),
    F.col("ATD.TERM_SK"),
    F.col("ATD.CENSUS_DT"),
    # F.col("ATD.UPDATED_DT"),
    # F.col("ATD.UPDATED_USER"),
    F.col("PATS.ADDR_FIELD1"),
    F.col("PATS.ADDR_FIELD2"),
    F.col("PATS.ADDR_FIELD3"),
    F.col("PATS.ADDRESS_TYPE"),
    F.col("PATS.ADDRESS1"),
    F.col("PATS.ADDRESS1_AC"),
    F.col("PATS.ADDRESS2"),
    F.col("PATS.ADDRESS2_AC"),
    F.col("PATS.ADDRESS3"),
    F.col("PATS.ADDRESS3_AC"),
    F.col("PATS.ADDRESS4"),
    F.col("PATS.CITY"),
    F.col("PATS.CITY_AC"),
    F.col("PATS.COUNTRY"),
    F.col("PATS.COUNTY"),
    F.col("PATS.EFF_STATUS"),
    F.col("PATS.EFFDT"),
    F.col("PATS.GEO_CODE"),
    F.col("PATS.HOUSE_TYPE"),
    F.col("PATS.IN_CITY_LIMIT"),
    F.col("PATS.LASTUPDDTTM"),
    F.col("PATS.LASTUPDOPRID"),
    F.col("PATS.NUM1"),
    F.col("PATS.NUM2"),
    F.col("PATS.POSTAL"),
    F.col("PATS.REG_REGION"),
    F.col("PATS.STATE"),
    # F.col("PATS.READ_DTM"),
    # F.col("PATS.STAGE_UPDATE_ID"),
    F.col("PVPT.VISA_PERMIT_TYPE"),
)

# COMMAND ----------

# Persist the IPEDS state result to a staging checkpoint table.
_tmp_stageB_tbl = f"{analytics}.{staging}.ipeds_state"
write_df_to_table(
    df_ipeds_state, _tmp_stageB_tbl, mode="overwrite", overwriteSchema="true"
)
df_ipeds_state = read_table(_tmp_stageB_tbl)
log_msg(f"Checkpoint B materialized: {_tmp_stageB_tbl}")

# COMMAND ----------

# Create df: ipd_state_total_count

# Alias the IPEDS state DataFrame for subsequent aggregations.
ipd_state = df_ipeds_state.alias("IpdState")

# Count the total number of courses enrolled per student, career, and term.
df_ipd_state_total_count = ipd_state.groupBy(
    "IpdState.STRM", "IpdState.ACAD_CAREER", "IpdState.EMPLID"
).agg(F.count(F.lit(1)).alias("Count_total"))

# Select the career, student, term, and total course count columns.
df_ipd_state_total_count = df_ipd_state_total_count.select(
    F.col("IpdState.ACAD_CAREER"),
    F.col("IpdState.EMPLID"),
    F.col("IpdState.STRM"),
    F.col("Count_total"),
)


# COMMAND ----------

# Create df: ipd_state_count_02

# Filter enrollments where the instruction mode is '02' (online/distance education).
df_ipd_state_count_02 = ipd_state.filter(
    F.col("IpdState.INSTRUCTION_MODE") == F.lit("02")
)

# Count the number of online (mode '02') courses per student, career, and term.
df_ipd_state_count_02 = df_ipd_state_count_02.groupBy(
    "IpdState.STRM", "IpdState.ACAD_CAREER", "IpdState.EMPLID"
).agg(F.count(F.lit(1)).alias("Count_02"))

# Select and deduplicate the online course count columns.
df_ipd_state_count_02 = df_ipd_state_count_02.select(
    F.col("IpdState.ACAD_CAREER"),
    F.col("IpdState.EMPLID"),
    F.col("IpdState.STRM"),
    F.col("Count_02"),
).distinct()


# COMMAND ----------

# Create df: ps_visa_permit_type_max_effdt

# Filter visa/permit records with EFFDT on or before todate, excluding 'AR1' permit type.
df_ps_visa_permit_type_max_effdt = pvpde.filter(
    (
        (
            F.date_format(
                F.coalesce(F.col("PVPDE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        <= F.lit(todate)
    )
    & (F.col("PVPDE.VISA_PERMIT_TYPE") != F.lit("AR1"))
)

# Compute the latest visa EFFDT per student.
df_ps_visa_permit_type_max_effdt = df_ps_visa_permit_type_max_effdt.withColumn(
    "MAX_EFFDT",
    F.max(
        F.date_format(
            F.coalesce(F.col("PVPDE.EFFDT"), F.lit("1900-01-01 00:00:00")),
            "yyyy-MM-dd HH:mm:ss",
        )
    ).over(Window.partitionBy("PVPDE.EMPLID")),
)

# Keep only rows matching the latest EFFDT and restricted to specific visa types, then drop helper column.
df_ps_visa_permit_type_max_effdt = df_ps_visa_permit_type_max_effdt.filter(
    (
        (
            F.date_format(
                F.coalesce(F.col("PVPDE.EFFDT"), F.lit("1900-01-01 00:00:00")),
                "yyyy-MM-dd HH:mm:ss",
            )
        )
        == F.col("MAX_EFFDT")
    )
    & (F.col("PVPDE.VISA_PERMIT_TYPE").isin(["NV", "ASY", "LPR", "REF", "TPS", "PLP"]))
).drop("MAX_EFFDT")

# Select EMPLID, visa/permit type, and effective date columns.
df_ps_visa_permit_type_max_effdt = df_ps_visa_permit_type_max_effdt.select(
    F.col("PVPDE.EMPLID"), F.col("PVPDE.VISA_PERMIT_TYPE"), F.col("PVPDE.EFFDT")
)


# COMMAND ----------

# Step: distance education
# Create df: dist_edu

# Alias the count DataFrames for joining into the distance education computation.
cnt_02 = df_ipd_state_count_02.alias("CNT_02")
cnt_total = df_ipd_state_total_count.alias("CNT_Total")

# Join IPEDS state data with the online course count and total course count DataFrames.
df_dist_edu = ipd_state.join(
    cnt_02,
    on=(
        (F.col("IpdState.EMPLID") == F.col("CNT_02.EMPLID"))
        & (F.col("IpdState.ACAD_CAREER") == F.col("CNT_02.ACAD_CAREER"))
        & (F.col("IpdState.STRM") == F.col("CNT_02.STRM"))
    ),
    how="left",
).join(
    cnt_total,
    (
        (F.col("IpdState.EMPLID") == F.col("CNT_Total.EMPLID"))
        & (F.col("IpdState.ACAD_CAREER") == F.col("CNT_Total.ACAD_CAREER"))
        & (F.col("IpdState.STRM") == F.col("CNT_Total.STRM"))
    ),
    how="left",
)

# Define a window to aggregate credit hours per student, career, and term.
_winSpec_2 = Window.partitionBy(
    F.col("IpdState.STRM"), F.col("IpdState.ACAD_CAREER"), F.col("IpdState.EMPLID")
)

# Compute the total credit hours (SCH) taken per student, career, and term.
df_dist_edu = df_dist_edu.withColumn(
    "SUM_UNIT_TAKEN",
    F.sum(F.col("IpdState.UNIT_TAKEN").cast("bigint")).over(_winSpec_2),
)
# Derive online enrollment flag, full/part-time IPEDS flag based on credit threshold (9 GRAD / 12 UGRD),
# and total SCH per student-career-term.
df_dist_edu = (
    df_dist_edu.withColumn(
        "MIN_ONE_ONLINE_COURSE_FLG",
        F.when(
            (F.coalesce(F.col("CNT_02.Count_02"), F.lit(0)) > F.lit(0)), F.lit("Y")
        ).otherwise(F.lit("N")),
    )
    .withColumn(
        "IPEDS_FULL_PART_TIME_FLG",
        F.coalesce(
            F.when(
                (F.upper(F.col("IpdState.ACAD_CAREER")) == F.lit("GRAD")),
                F.coalesce(
                    F.when((F.col("SUM_UNIT_TAKEN") >= F.lit(9)), F.lit("F")).otherwise(
                        F.lit("P")
                    ),
                    F.lit(""),
                ),
            ).otherwise(
                F.coalesce(
                    F.when(
                        (F.upper(F.col("IpdState.ACAD_CAREER")) == F.lit("UGRD")),
                        F.coalesce(
                            F.when(
                                (F.col("SUM_UNIT_TAKEN") >= F.lit(12)), F.lit("F")
                            ).otherwise(F.lit("P")),
                            F.lit(""),
                        ),
                    ).otherwise(F.lit("")),
                    F.lit(""),
                )
            ),
            F.lit(""),
        ),
    )
    .withColumn(
        "IPEDS_SCH", F.sum(F.col("IpdState.UNIT_TAKEN").cast("bigint")).over(_winSpec_2)
    )
)

# Compute the minimum and maximum instruction modes per student-career-term for distance education status logic.
df_dist_edu = df_dist_edu.withColumn(
    "MIN_INSTRUCTION_MODE", F.min(F.col("IpdState.INSTRUCTION_MODE")).over(_winSpec_2)
)
df_dist_edu = df_dist_edu.withColumn(
    "MAX_INSTRUCTION_MODE", F.max(F.col("IpdState.INSTRUCTION_MODE")).over(_winSpec_2)
)

# Classify each student's IPEDS distance education status:
# exclusively online, some online, or not online based on mode counts.
df_dist_edu = df_dist_edu.withColumn(
    "IPEDS_DISTANCE_EDUCATION_STATUS",
    F.when(
        (
            (
                F.coalesce(F.col("CNT_02.Count_02"), F.lit(0))
                == F.col("CNT_Total.Count_total")
            )
            & (F.coalesce(F.col("CNT_02.Count_02"), F.lit(0)) != F.lit(0))
        ),
        F.lit("Enrolled exclusively in distance education"),
    )
    .when(
        (
            (F.col("MIN_INSTRUCTION_MODE") == F.lit("02"))
            & (F.col("MAX_INSTRUCTION_MODE") == F.lit("02"))
        ),
        F.lit("Enrolled exclusively in distance education"),
    )
    .when(
        (
            (F.col("MIN_INSTRUCTION_MODE") == F.lit("01"))
            & (F.col("MAX_INSTRUCTION_MODE") == F.lit("01"))
        ),
        F.lit("Not enrolled in any online course"),
    )
    .when(
        (
            (
                F.coalesce(F.col("CNT_02.Count_02"), F.lit(0))
                != F.col("CNT_Total.Count_total")
            )
            & (F.coalesce(F.col("CNT_02.Count_02"), F.lit(0)) != F.lit(0))
        ),
        F.lit("Enrolled in some but not all distance education courses"),
    )
    .otherwise(F.lit("Not enrolled in any online course")),
)

# COMMAND ----------

# Remove the intermediate instruction mode and SCH helper columns.
df_dist_edu = df_dist_edu.drop(
    "MIN_INSTRUCTION_MODE", "MAX_INSTRUCTION_MODE", "SUM_UNIT_TAKEN"
)

# Project the required distance education output columns.
df_dist_edu = df_dist_edu.select(
    F.col("MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("IpdState.EMPLID"),
    F.col("IpdState.ENROLLED_WITHIN_12_MONTHS"),
    F.col("IpdState.AGE_GROUP"),
    F.col("IpdState.IPEDS_STATE"),
    F.col("IpdState.ACAD_CAREER"),
    F.col("IpdState.ACAD_PROGRAM"),
    F.col("IpdState.MAJOR1_DEPT"),
    F.col("IpdState.MAJOR2_DEPT"),
    F.col("IpdState.MINOR1_DEPT"),
    F.col("IpdState.STRM"),
    F.col("IpdState.ACAD_LEVEL_EOT_CD"),
    F.col("IpdState.ACAD_LEVEL_EOT_DESCR"),
    F.col("IpdState.FIRST_NAME"),
    F.col("IpdState.LAST_NAME"),
    F.col("IpdState.MIDDLE_NAME"),
    F.col("IpdState.BIRTH_DT"),
    F.col("IpdState.Age"),
    F.col("IpdState.COHORT_ENTRY"),
    F.col("IpdState.GENDER"),
    F.col("IpdState.ADDRESS"),
    F.col("IpdState.HOME_ADDR_CITY"),
    F.col("IpdState.HOME_ADDR_STATE"),
    F.col("IpdState.HOME_ADDR_POSTAL"),
    F.col("IpdState.HOME_ADDR_COUNTRY"),
    F.col("IpdState.HOME_ADDR_COUNTY"),
    F.col("IpdState.ETHN_GRP"),
    F.col("IpdState.Student_Ethnicity"),
    F.col("IpdState.MAJOR1_PLAN"),
    F.col("IpdState.MAJOR1_CIP_CD"),
    F.col("IpdState.MAJOR2_PLAN"),
    F.col("IpdState.MAJOR2_CIP_CD"),
    F.col("IpdState.MINOR1_PLAN"),
    F.col("IpdState.MINOR1_CIP_CD"),
    F.col("IpdState.COURSE_ID"),
    F.col("IpdState.CATALOG_NBR"),
    F.col("IpdState.SUBJECT"),
    F.col("IpdState.INSTRUCTION_MODE"),
    F.col("IpdState.CLASS_START_DT"),
    F.col("IpdState.CLASS_END_DT"),
    F.col("IpdState.CLASS_SECTION"),
    F.col("IpdState.INSTRUCTION_MODE_DESCR"),
    F.col("IpdState.ENRL_ADD_DT"),
    F.col("IpdState.SESSION_CD"),
    F.col("IpdState.UNIT_TAKEN"),
    F.col("IpdState.ADMIT_TERM"),
    F.col("IpdState.RESIDENCY"),
    F.col("IPEDS_FULL_PART_TIME_FLG"),
    F.col("IPEDS_SCH"),
    F.col("IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("IpdState.IPEDS_FIPS_CD"),
    F.col("IpdState.CLASS_NBR"),
    F.col("IpdState.SNAPSHOT_DT"),
    F.col("IpdState.TERM_DESCR"),
    F.col("IpdState.ACAD_YEAR"),
    F.col("IpdState.CIP_CD_DESCR"),
    F.col("IpdState.ACAD_PROGRAM_DESCR"),
    F.col("IpdState.ACAD_CAREER_DESCR"),
    F.col("IpdState.INIT_TERM"),
    F.col("IpdState.DEPT"),
    F.col("IpdState.COLLEGE"),
    F.col("IpdState.COLLEGE_DESCR"),
    F.col("IpdState.DEPT_DESCR"),
    F.col("IpdState.TUITION_RESIDENCY_DESCR"),
    F.col("IpdState.IPEDS_CITY"),
    F.col("IpdState.IPEDS_COUNTY"),
    F.col("IpdState.IPEDS_COUNTY_CODE"),
    F.col("IpdState.IPEDS_POSTAL"),
    F.col("IpdState.IPEDS_ADDR"),
    F.col("IpdState.IPEDS_COUNTRY"),
    F.col("IpdState.TUITION_RES"),
    F.col("IpdState.RESIDENCY_DESCR"),
)

# COMMAND ----------

# Step: ipeds_visa
# Create df: ipeds_visa

# Alias the DataFrames for the visa join.
dist_edu = df_dist_edu.alias("DistEdu")
pvpt_maxeffdt = df_ps_visa_permit_type_max_effdt.alias("PVPT_MaxEffDt")

# Left-join distance education data with the most recent visa data to overlay visa type per student.
df_ipeds_visa = dist_edu.join(
    pvpt_maxeffdt,
    on=(F.col("DistEdu.EMPLID") == F.col("PVPT_MaxEffDt.EMPLID")),
    how="left",
)

# Select all columns and derive IPEDS_ETHNICITY: re-classify foreign students with recognized visa
# types using their actual ethnicity rather than 'FORGN'.
df_ipeds_visa = df_ipeds_visa.select(
    F.col("DistEdu.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("DistEdu.EMPLID"),
    F.col("DistEdu.ENROLLED_WITHIN_12_MONTHS"),
    F.col("DistEdu.AGE_GROUP"),
    F.col("DistEdu.IPEDS_STATE"),
    F.col("DistEdu.ACAD_CAREER"),
    F.col("DistEdu.ACAD_PROGRAM"),
    F.col("DistEdu.MAJOR1_DEPT"),
    F.col("DistEdu.MAJOR2_DEPT"),
    F.col("DistEdu.MINOR1_DEPT"),
    F.col("DistEdu.STRM"),
    F.col("DistEdu.ACAD_LEVEL_EOT_CD"),
    F.col("DistEdu.ACAD_LEVEL_EOT_DESCR"),
    F.col("DistEdu.FIRST_NAME"),
    F.col("DistEdu.LAST_NAME"),
    F.col("DistEdu.MIDDLE_NAME"),
    F.col("DistEdu.BIRTH_DT"),
    F.col("DistEdu.Age"),
    F.col("DistEdu.COHORT_ENTRY"),
    F.col("DistEdu.GENDER"),
    F.col("DistEdu.ADDRESS"),
    F.col("DistEdu.HOME_ADDR_CITY"),
    F.col("DistEdu.HOME_ADDR_STATE"),
    F.col("DistEdu.HOME_ADDR_POSTAL"),
    F.col("DistEdu.HOME_ADDR_COUNTRY"),
    F.col("DistEdu.HOME_ADDR_COUNTY"),
    F.col("DistEdu.ETHN_GRP"),
    F.col("DistEdu.MAJOR1_PLAN"),
    F.col("DistEdu.MAJOR1_CIP_CD"),
    F.col("DistEdu.MAJOR2_PLAN"),
    F.col("DistEdu.MAJOR2_CIP_CD"),
    F.col("DistEdu.MINOR1_PLAN"),
    F.col("DistEdu.MINOR1_CIP_CD"),
    F.col("DistEdu.COURSE_ID"),
    F.col("DistEdu.CATALOG_NBR"),
    F.col("DistEdu.SUBJECT"),
    F.col("DistEdu.INSTRUCTION_MODE"),
    F.col("DistEdu.CLASS_START_DT"),
    F.col("DistEdu.CLASS_END_DT"),
    F.col("DistEdu.CLASS_SECTION"),
    F.col("DistEdu.INSTRUCTION_MODE_DESCR"),
    F.col("DistEdu.ENRL_ADD_DT"),
    F.col("DistEdu.SESSION_CD"),
    F.col("DistEdu.UNIT_TAKEN"),
    F.col("DistEdu.ADMIT_TERM"),
    F.col("DistEdu.RESIDENCY"),
    F.col("DistEdu.IPEDS_FULL_PART_TIME_FLG"),
    F.col("DistEdu.IPEDS_SCH"),
    F.col("DistEdu.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("DistEdu.IPEDS_FIPS_CD"),
    F.col("DistEdu.CLASS_NBR"),
    F.col("DistEdu.SNAPSHOT_DT"),
    F.when(
        (
            (F.trim(F.col("DistEdu.ETHN_GRP")) == F.lit("FORGN"))
            & (
                F.trim(F.col("PVPT_MaxEffDt.VISA_PERMIT_TYPE")).isin(
                    ["NV", "ASY", "LPR", "REF", "TPS", "PLP"]
                )
            )
            & (
                F.col("DistEdu.Student_Ethnicity").isNotNull()
                & (F.col("DistEdu.Student_Ethnicity") != F.lit(""))
            )
        ),
        F.col("DistEdu.Student_Ethnicity"),
    )
    .when(
        (
            (F.trim(F.col("DistEdu.ETHN_GRP")) == F.lit("FORGN"))
            & (
                F.trim(F.col("PVPT_MaxEffDt.VISA_PERMIT_TYPE")).isin(
                    ["NV", "ASY", "LPR", "REF", "TPS", "PLP"]
                )
            )
            & (
                F.col("DistEdu.Student_Ethnicity").isNull()
                | (F.col("DistEdu.Student_Ethnicity") == F.lit(""))
            )
        ),
        F.lit("NSPEC"),
    )
    .otherwise(F.trim(F.col("DistEdu.ETHN_GRP")))
    .alias("IPEDS_ETHNICITY"),
    F.col("DistEdu.TERM_DESCR"),
    F.col("DistEdu.ACAD_YEAR"),
    F.col("DistEdu.CIP_CD_DESCR"),
    F.col("DistEdu.ACAD_PROGRAM_DESCR"),
    F.col("DistEdu.ACAD_CAREER_DESCR"),
    F.col("DistEdu.INIT_TERM"),
    F.col("DistEdu.DEPT"),
    F.col("DistEdu.COLLEGE"),
    F.col("DistEdu.COLLEGE_DESCR"),
    F.col("DistEdu.DEPT_DESCR"),
    F.col("DistEdu.TUITION_RESIDENCY_DESCR"),
    F.col("DistEdu.IPEDS_CITY"),
    F.col("DistEdu.IPEDS_COUNTY"),
    F.col("DistEdu.IPEDS_COUNTY_CODE"),
    F.col("DistEdu.IPEDS_POSTAL"),
    F.col("DistEdu.IPEDS_ADDR"),
    F.col("DistEdu.IPEDS_COUNTRY"),
    F.col("DistEdu.TUITION_RES"),
    F.col("DistEdu.RESIDENCY_DESCR"),
    F.col("PVPT_MaxEffDt.VISA_PERMIT_TYPE"),
    F.col("DistEdu.Student_Ethnicity"),
)


# COMMAND ----------

# Create df: ps_names

# Filter name records of type 'PRI' (primary) with EFFDT on or before todate.
df_ps_names = pn.filter(
    (
        F.date_format(F.col("PN.EFFDT"), "yyyy-MM-dd HH:mm:ss")
        <= F.date_format(F.lit(todate), "yyyy-MM-dd HH:mm:ss")
    )
    & (F.col("PN.NAME_TYPE") == F.lit("PRI"))
)
# Compute the most recent EFFDT per student for the primary name record.
df_ps_names = df_ps_names.withColumn(
    "MAX_EFFDT",
    F.max(F.date_format(F.col("PN.EFFDT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("PN.EMPLID")
    ),
)

# Retain only the row matching the maximum EFFDT and drop the helper column.
df_ps_names = df_ps_names.filter(
    (F.date_format(F.col("PN.EFFDT"), "yyyy-MM-dd HH:mm:ss") == F.col("MAX_EFFDT"))
).drop("MAX_EFFDT")

# Project all required name columns into the result.
df_ps_names = df_ps_names.select(
    F.col("PN.COUNTRY_NM_FORMAT"),
    F.col("PN.EFF_STATUS"),
    F.col("PN.EFFDT"),
    F.col("PN.EMPLID"),
    F.col("PN.FIRST_NAME"),
    F.col("PN.FIRST_NAME_SRCH"),
    F.col("PN.LAST_NAME"),
    F.col("PN.LAST_NAME_PREF_NLD"),
    F.col("PN.LAST_NAME_SRCH"),
    F.col("PN.LASTUPDDTTM"),
    F.col("PN.LASTUPDOPRID"),
    F.col("PN.MIDDLE_NAME"),
    F.col("PN.NAME"),
    F.col("PN.NAME_AC"),
    F.col("PN.NAME_DISPLAY"),
    F.col("PN.NAME_DISPLAY_SRCH"),
    F.col("PN.NAME_FORMAL"),
    F.col("PN.NAME_INITIALS"),
    F.col("PN.NAME_PREFIX"),
    F.col("PN.NAME_ROYAL_PREFIX"),
    F.col("PN.NAME_ROYAL_SUFFIX"),
    F.col("PN.NAME_SUFFIX"),
    F.col("PN.NAME_TITLE"),
    F.col("PN.NAME_TYPE"),
    F.col("PN.PARTNER_LAST_NAME"),
    F.col("PN.PARTNER_ROY_PREFIX"),
    F.col("PN.PREF_FIRST_NAME"),
    F.col("PN.SECOND_LAST_NAME"),
    F.col("PN.SECOND_LAST_SRCH"),
    # F.col("PN.READ_DTM"),
    # F.col("PN.STAGE_UPDATE_ID"),
)


# COMMAND ----------

# Step: names
# Create df: names

# Alias the visa and names DataFrames for joining.
ipeds_visa = df_ipeds_visa.alias("IpedsVisa")
ps_names = df_ps_names.alias("PS_Names")

# Inner-join IPEDS visa data with the student name data to attach the most recent primary name.
df_names = ipeds_visa.join(
    ps_names, on=(F.col("IpedsVisa.EMPLID") == F.col("PS_Names.EMPLID")), how="inner"
)

# Select all output columns and replace '?' characters in name fields with 'n'.
df_names = df_names.select(
    F.col("IpedsVisa.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("IpedsVisa.EMPLID"),
    F.col("IpedsVisa.ENROLLED_WITHIN_12_MONTHS"),
    F.col("IpedsVisa.AGE_GROUP"),
    F.col("IpedsVisa.IPEDS_STATE"),
    F.col("IpedsVisa.ACAD_CAREER"),
    F.col("IpedsVisa.ACAD_PROGRAM"),
    F.col("IpedsVisa.MAJOR1_DEPT"),
    F.col("IpedsVisa.MAJOR2_DEPT"),
    F.col("IpedsVisa.MINOR1_DEPT"),
    F.col("IpedsVisa.STRM"),
    F.col("IpedsVisa.ACAD_LEVEL_EOT_CD"),
    F.col("IpedsVisa.ACAD_LEVEL_EOT_DESCR"),
    F.regexp_replace(F.col("PS_Names.FIRST_NAME"), F.lit("\\?"), F.lit("n")).alias(
        "FIRST_NAME"
    ),
    F.regexp_replace(F.col("PS_Names.LAST_NAME"), F.lit("\\?"), F.lit("n")).alias(
        "LAST_NAME"
    ),
    F.regexp_replace(F.col("PS_Names.MIDDLE_NAME"), F.lit("\\?"), F.lit("n")).alias(
        "MIDDLE_NAME"
    ),
    F.col("IpedsVisa.BIRTH_DT"),
    F.col("IpedsVisa.Age"),
    F.col("IpedsVisa.COHORT_ENTRY"),
    F.col("IpedsVisa.GENDER"),
    F.col("IpedsVisa.ADDRESS"),
    F.col("IpedsVisa.HOME_ADDR_CITY"),
    F.col("IpedsVisa.HOME_ADDR_STATE"),
    F.col("IpedsVisa.HOME_ADDR_POSTAL"),
    F.col("IpedsVisa.HOME_ADDR_COUNTRY"),
    F.col("IpedsVisa.HOME_ADDR_COUNTY"),
    F.col("IpedsVisa.ETHN_GRP"),
    F.col("IpedsVisa.MAJOR1_PLAN"),
    F.col("IpedsVisa.MAJOR1_CIP_CD"),
    F.col("IpedsVisa.MAJOR2_PLAN"),
    F.col("IpedsVisa.MAJOR2_CIP_CD"),
    F.col("IpedsVisa.MINOR1_PLAN"),
    F.col("IpedsVisa.MINOR1_CIP_CD"),
    F.col("IpedsVisa.COURSE_ID"),
    F.col("IpedsVisa.CATALOG_NBR"),
    F.col("IpedsVisa.SUBJECT"),
    F.col("IpedsVisa.INSTRUCTION_MODE"),
    F.col("IpedsVisa.CLASS_START_DT"),
    F.col("IpedsVisa.CLASS_END_DT"),
    F.col("IpedsVisa.CLASS_SECTION"),
    F.col("IpedsVisa.INSTRUCTION_MODE_DESCR"),
    F.col("IpedsVisa.ENRL_ADD_DT"),
    F.col("IpedsVisa.SESSION_CD"),
    F.col("IpedsVisa.UNIT_TAKEN"),
    F.col("IpedsVisa.ADMIT_TERM"),
    F.col("IpedsVisa.RESIDENCY"),
    F.col("IpedsVisa.IPEDS_FULL_PART_TIME_FLG"),
    F.col("IpedsVisa.IPEDS_SCH"),
    F.col("IpedsVisa.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("IpedsVisa.IPEDS_FIPS_CD"),
    F.col("IpedsVisa.CLASS_NBR"),
    F.col("IpedsVisa.SNAPSHOT_DT"),
    F.col("IpedsVisa.IPEDS_ETHNICITY"),
    F.col("IpedsVisa.TERM_DESCR"),
    F.col("IpedsVisa.ACAD_YEAR"),
    F.col("IpedsVisa.CIP_CD_DESCR"),
    F.col("IpedsVisa.ACAD_PROGRAM_DESCR"),
    F.col("IpedsVisa.ACAD_CAREER_DESCR"),
    F.col("IpedsVisa.INIT_TERM"),
    F.col("IpedsVisa.DEPT"),
    F.col("IpedsVisa.COLLEGE"),
    F.col("IpedsVisa.COLLEGE_DESCR"),
    F.col("IpedsVisa.DEPT_DESCR"),
    F.col("IpedsVisa.TUITION_RESIDENCY_DESCR"),
    F.col("IpedsVisa.IPEDS_CITY"),
    F.col("IpedsVisa.IPEDS_COUNTY"),
    F.col("IpedsVisa.IPEDS_COUNTY_CODE"),
    F.col("IpedsVisa.IPEDS_POSTAL"),
    F.col("IpedsVisa.IPEDS_ADDR"),
    F.col("IpedsVisa.IPEDS_COUNTRY"),
    F.col("IpedsVisa.TUITION_RES"),
    F.col("IpedsVisa.RESIDENCY_DESCR"),
).distinct()


# COMMAND ----------

# Persist the names-enriched dataset to a staging checkpoint table.
_tmp_stageC_tbl = f"{analytics}.{staging}.names"
write_df_to_table(df_names, _tmp_stageC_tbl, mode="overwrite", overwriteSchema="true")
df_names = read_table(_tmp_stageC_tbl)
log_msg(f"Checkpoint C materialized: {_tmp_stageC_tbl}")

# COMMAND ----------

# Create df: ps_ext_degree_agg

# Filter external degree records to include only high school diplomas and doctoral degrees
# that have been completed and are sourced from school records.
df_ps_ext_degree_agg = ped.filter(
    (
        (F.coalesce(F.col("PED.EXT_CAREER"), F.lit("")) == F.lit("HS"))
        | (F.col("PED.DESCR").like("%High School%"))
        | (F.col("PED.DESCR").like("HS%"))
        | (
            F.coalesce(F.col("PED.DEGREE"), F.lit("")).isin(
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
    )
    & (F.col("PED.DEGREE_STATUS") == F.lit("C"))
    & (F.coalesce(F.col("PED.LS_DATA_SOURCE"), F.lit("")) == F.lit("SCH"))
)

# Compute the latest degree date per student across matching degree records.
df_ps_ext_degree_agg = df_ps_ext_degree_agg.withColumn(
    "DEGREE_DT",
    F.max(F.date_format(F.col("PED.DEGREE_DT"), "yyyy-MM-dd HH:mm:ss")).over(
        Window.partitionBy("PED.EMPLID")
    ),
)

# Select EMPLID and the latest degree date, then deduplicate.
df_ps_ext_degree_agg = df_ps_ext_degree_agg.select(
    F.col("PED.EMPLID"), F.col("DEGREE_DT")
).distinct()


# COMMAND ----------

# Step: Join
# Create df: name_degree_join

# Alias the names and degree DataFrames for joining.
n = df_names.alias("N")
pedagg = df_ps_ext_degree_agg.alias("PEDAgg")

# Join the names dataset with the term dimension and left-join with the degree data.
df_name_degree_join = n.join(
    atd,
    on=(
        (F.col("N.ACAD_CAREER") == F.col("ATD.ACAD_CAREER"))
        & (F.col("N.STRM") == F.col("ATD.STRM"))
    ),
    how="inner",
).join(pedagg, on=(F.col("N.EMPLID") == F.col("PEDAgg.EMPLID")), how="left")

# Derive the ENROLLED_WITHIN_12_MONTHS flag: 1 if the student earned a degree within
# 12 months before the term start, 0 otherwise, NULL if either date is missing.
df_name_degree_join = df_name_degree_join.withColumn(
    "ENROLLED_WITHIN_12_MONTHS",
    F.when(F.col("PEDAgg.DEGREE_DT").isNull(), F.lit(None))
    .when(F.col("ATD.TERM_BEGIN_DT").isNull(), F.lit(None))
    .when(
        (
            sas_yrdif_age_dbl(
                F.to_date(F.col("PEDAgg.DEGREE_DT")),
                F.to_date(F.col("ATD.TERM_BEGIN_DT")),
            )
            > F.lit(1)
        ),
        F.lit(0),
    )
    .otherwise(F.lit(1)),
)

# Project all required columns and deduplicate the name-degree joined dataset.
df_name_degree_join = df_name_degree_join.select(
    F.col("N.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("N.EMPLID"),
    F.col("ENROLLED_WITHIN_12_MONTHS"),
    F.col("N.AGE_GROUP"),
    F.col("N.IPEDS_STATE"),
    F.col("N.ACAD_CAREER"),
    F.col("N.ACAD_PROGRAM"),
    F.col("N.MAJOR1_DEPT"),
    F.col("N.MAJOR2_DEPT"),
    F.col("N.MINOR1_DEPT"),
    F.col("N.STRM"),
    F.col("N.ACAD_LEVEL_EOT_CD"),
    F.col("N.ACAD_LEVEL_EOT_DESCR"),
    F.col("N.FIRST_NAME"),
    F.col("N.LAST_NAME"),
    F.col("N.MIDDLE_NAME"),
    F.col("N.BIRTH_DT"),
    F.col("N.Age"),
    F.col("N.COHORT_ENTRY"),
    F.col("N.GENDER"),
    F.col("N.ADDRESS"),
    F.col("N.HOME_ADDR_CITY"),
    F.col("N.HOME_ADDR_STATE"),
    F.col("N.HOME_ADDR_POSTAL"),
    F.col("N.HOME_ADDR_COUNTRY"),
    F.col("N.HOME_ADDR_COUNTY"),
    F.col("N.ETHN_GRP"),
    F.col("N.MAJOR1_PLAN"),
    F.col("N.MAJOR1_CIP_CD"),
    F.col("N.MAJOR2_PLAN"),
    F.col("N.MAJOR2_CIP_CD"),
    F.col("N.MINOR1_PLAN"),
    F.col("N.MINOR1_CIP_CD"),
    F.col("N.COURSE_ID"),
    F.col("N.CATALOG_NBR"),
    F.col("N.SUBJECT"),
    F.col("N.INSTRUCTION_MODE"),
    F.col("N.CLASS_START_DT"),
    F.col("N.CLASS_END_DT"),
    F.col("N.CLASS_SECTION"),
    F.col("N.INSTRUCTION_MODE_DESCR"),
    F.col("N.ENRL_ADD_DT"),
    F.col("N.SESSION_CD"),
    F.col("N.UNIT_TAKEN"),
    F.col("N.ADMIT_TERM"),
    F.col("N.RESIDENCY"),
    F.col("N.IPEDS_FULL_PART_TIME_FLG"),
    F.col("N.IPEDS_SCH"),
    F.col("N.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("N.IPEDS_FIPS_CD"),
    F.col("N.CLASS_NBR"),
    F.col("N.SNAPSHOT_DT"),
    F.col("N.IPEDS_ETHNICITY"),
    F.col("N.TERM_DESCR"),
    F.col("N.ACAD_YEAR"),
    F.col("N.CIP_CD_DESCR"),
    F.col("N.ACAD_PROGRAM_DESCR"),
    F.col("N.ACAD_CAREER_DESCR"),
    F.col("N.INIT_TERM"),
    F.col("N.DEPT"),
    F.col("N.COLLEGE"),
    F.col("N.COLLEGE_DESCR"),
    F.col("N.DEPT_DESCR"),
    F.col("N.TUITION_RESIDENCY_DESCR"),
    F.col("N.IPEDS_CITY"),
    F.col("N.IPEDS_COUNTY"),
    F.col("N.IPEDS_COUNTY_CODE"),
    F.col("N.IPEDS_POSTAL"),
    F.col("ATD.INSTITUTION"),
    F.col("ATD.DESCR"),
    F.col("ATD.SHORT_DESCR"),
    F.col("ATD.TERM_BEGIN_DT"),
    F.col("ATD.TERM_END_DT"),
    F.col("ATD.SESSION_DESCR"),
    F.col("ATD.SESSION_SHORT_DESCR"),
    F.col("ATD.WEEKS_OF_INSTRN"),
    F.col("ATD.TERM_CATEGORY_CD"),
    F.col("ATD.TERM_CATEGORY_DESCR"),
    F.col("ATD.TERM_CATEGORY_SHORT_DESCR"),
    F.col("ATD.HOLIDAY_SCHEDULE"),
    F.col("ATD.SIXTY_PERCENT_DT"),
    # F.col("ATD.UPDATED_DT"),
    # F.col("ATD.UPDATED_USER"),
    F.col("ATD.TERM_SK"),
    F.col("ATD.CENSUS_DT"),
    F.col("PEDAgg.DEGREE_DT"),
    F.col("N.IPEDS_ADDR"),
    F.col("N.IPEDS_COUNTRY"),
    F.col("N.TUITION_RES"),
    F.col("N.RESIDENCY_DESCR"),
).distinct()


# COMMAND ----------

# Create df: ife_hist_data

# Select all required columns from the IPEDS fall enrollment historical table.
df_ife_hist_data = ife_hist.select(
    F.col("IFE_Hist.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("IFE_Hist.EMPLID"),
    F.col("IFE_Hist.ENROLLED_WITHIN_12_MONTHS"),
    F.col("IFE_Hist.AGE_GROUP"),
    F.col("IFE_Hist.IPEDS_STATE"),
    F.col("IFE_Hist.ACAD_CAREER"),
    F.col("IFE_Hist.ACAD_PROGRAM"),
    F.col("IFE_Hist.MAJOR1_DEPT"),
    F.col("IFE_Hist.MAJOR2_DEPT"),
    F.col("IFE_Hist.MINOR1_DEPT"),
    F.col("IFE_Hist.STRM"),
    F.col("IFE_Hist.ACAD_LEVEL_EOT_CD"),
    F.col("IFE_Hist.ACAD_LEVEL_EOT_DESCR"),
    F.col("IFE_Hist.FIRST_NAME"),
    F.col("IFE_Hist.LAST_NAME"),
    F.col("IFE_Hist.MIDDLE_NAME"),
    F.col("IFE_Hist.BIRTH_DT"),
    F.col("IFE_Hist.AGE"),
    F.col("IFE_Hist.COHORT_TYPE"),
    F.col("IFE_Hist.GENDER"),
    F.col("IFE_Hist.HOME_ADDR"),
    F.col("IFE_Hist.HOME_ADDR_CITY"),
    F.col("IFE_Hist.HOME_ADDR_STATE"),
    F.col("IFE_Hist.HOME_ADDR_POSTAL"),
    F.col("IFE_Hist.HOME_ADDR_COUNTRY"),
    F.col("IFE_Hist.HOME_ADDR_COUNTY"),
    F.col("IFE_Hist.ETHN_GRP"),
    F.col("IFE_Hist.MAJOR1_PLAN"),
    F.col("IFE_Hist.MAJOR1_CIP_CD"),
    F.col("IFE_Hist.MAJOR2_PLAN"),
    F.col("IFE_Hist.MAJOR2_CIP_CD"),
    F.col("IFE_Hist.MINOR1_PLAN"),
    F.col("IFE_Hist.MINOR1_CIP_CD"),
    F.col("IFE_Hist.COURSE_ID"),
    F.col("IFE_Hist.CATALOG_NBR"),
    F.col("IFE_Hist.SUBJECT"),
    F.col("IFE_Hist.INSTRUCTION_MODE"),
    F.col("IFE_Hist.CLASS_START_DT"),
    F.col("IFE_Hist.CLASS_END_DT"),
    F.col("IFE_Hist.CLASS_SECTION"),
    F.col("IFE_Hist.INSTRUCTION_MODE_DESCR"),
    F.col("IFE_Hist.ENRL_ADD_DT"),
    F.col("IFE_Hist.SESSION_CD"),
    F.col("IFE_Hist.UNIT_TAKEN"),
    F.col("IFE_Hist.ADMIT_TERM"),
    F.col("IFE_Hist.RESIDENCY"),
    F.col("IFE_Hist.IPEDS_FULL_PART_TIME_FLG"),
    F.col("IFE_Hist.IPEDS_SCH"),
    F.col("IFE_Hist.IPEDS_DISTANCE_EDU_STATUS"),
    F.col("IFE_Hist.IPEDS_FIPS_CD"),
    F.col("IFE_Hist.CLASS_NBR"),
    F.col("IFE_Hist.INIT_TERM"),
    F.col("IFE_Hist.IPEDS_ETHNICITY"),
    F.col("IFE_Hist.TERM_DESCR"),
    F.col("IFE_Hist.ACAD_YEAR"),
    F.col("IFE_Hist.CIP_CD_DESCR"),
    F.col("IFE_Hist.SNAPSHOT_DT"),
    F.col("IFE_Hist.ACAD_PROGRAM_DESCR"),
    F.col("IFE_Hist.ACAD_CAREER_DESCR"),
    F.col("IFE_Hist.DEPT"),
    F.col("IFE_Hist.COLLEGE"),
    F.col("IFE_Hist.COLLEGE_DESCR"),
    F.col("IFE_Hist.DEPT_DESCR"),
    F.col("IFE_Hist.RESIDENCY_DESCR"),
    F.col("IFE_Hist.IPEDS_CITY"),
    F.col("IFE_Hist.IPEDS_COUNTY"),
    F.col("IFE_Hist.IPEDS_POSTAL"),
    F.col("IFE_Hist.STUDENTRETENTIONCATEGORY"),
    F.col("IFE_Hist.RETENTION_FLG"),
    F.col("IFE_Hist.IPEDS_ADDR"),
    F.col("IFE_Hist.IPEDS_COUNTRY"),
    F.col("IFE_Hist.TUITION_RES"),
    F.col("IFE_Hist.IPEDS_ETHNICITY_DESCR"),
    F.col("IFE_Hist.ETHN_GRP_DESCR"),
    F.col("IFE_Hist.TUITION_RESIDENCY_DESCR"),
    F.col("IFE_Hist.OVERALL_RESIDENCY"),
    F.col("IFE_Hist.Overall_Residency_Descr"),
)


# COMMAND ----------

# Create df: uid_union_ife_hist
# Union the 2017 snapshot data with all historical IPEDS enrollment data, allowing missing columns.

df_uid_union_ife_hist = df_ife_hist_data.select(
    F.col("MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("EMPLID"),
    F.col("ENROLLED_WITHIN_12_MONTHS"),
    F.col("AGE_GROUP"),
    F.col("IPEDS_STATE"),
    F.col("ACAD_CAREER"),
    F.col("ACAD_PROGRAM"),
    F.col("MAJOR1_DEPT"),
    F.col("MAJOR2_DEPT"),
    F.col("MINOR1_DEPT"),
    F.col("STRM"),
    F.col("ACAD_LEVEL_EOT_CD"),
    F.col("ACAD_LEVEL_EOT_DESCR"),
    F.col("FIRST_NAME"),
    F.col("LAST_NAME"),
    F.col("MIDDLE_NAME"),
    F.col("BIRTH_DT"),
    F.col("AGE"),
    F.col("COHORT_TYPE"),
    F.col("GENDER"),
    F.col("HOME_ADDR"),
    F.col("HOME_ADDR_CITY"),
    F.col("HOME_ADDR_STATE"),
    F.col("HOME_ADDR_POSTAL"),
    F.col("HOME_ADDR_COUNTRY"),
    F.col("HOME_ADDR_COUNTY"),
    F.col("ETHN_GRP"),
    F.col("MAJOR1_PLAN"),
    F.col("MAJOR1_CIP_CD"),
    F.col("MAJOR2_PLAN"),
    F.col("MAJOR2_CIP_CD"),
    F.col("MINOR1_PLAN"),
    F.col("MINOR1_CIP_CD"),
    F.col("COURSE_ID"),
    F.col("CATALOG_NBR"),
    F.col("SUBJECT"),
    F.col("INSTRUCTION_MODE"),
    F.col("CLASS_START_DT"),
    F.col("CLASS_END_DT"),
    F.col("CLASS_SECTION"),
    F.col("INSTRUCTION_MODE_DESCR"),
    F.col("ENRL_ADD_DT"),
    F.col("SESSION_CD"),
    F.col("UNIT_TAKEN"),
    F.col("ADMIT_TERM"),
    F.col("RESIDENCY"),
    F.col("IPEDS_FULL_PART_TIME_FLG"),
    F.col("IPEDS_SCH"),
    F.col("IPEDS_DISTANCE_EDU_STATUS"),
    F.col("IPEDS_FIPS_CD"),
    F.col("CLASS_NBR"),
    F.col("INIT_TERM"),
    F.col("IPEDS_ETHNICITY"),
    F.col("TERM_DESCR"),
    F.col("ACAD_YEAR"),
    F.col("CIP_CD_DESCR"),
    F.col("SNAPSHOT_DT"),
    F.col("ACAD_PROGRAM_DESCR"),
    F.col("ACAD_CAREER_DESCR"),
    F.col("DEPT"),
    F.col("COLLEGE"),
    F.col("COLLEGE_DESCR"),
    F.col("DEPT_DESCR"),
    F.col("RESIDENCY_DESCR"),
    F.col("IPEDS_CITY"),
    F.col("IPEDS_COUNTY"),
    F.col("IPEDS_POSTAL"),
    F.col("STUDENTRETENTIONCATEGORY"),
    F.col("RETENTION_FLG"),
    F.col("IPEDS_ADDR"),
    F.col("IPEDS_COUNTRY"),
    F.col("TUITION_RES"),
    F.col("IPEDS_ETHNICITY_DESCR"),
    F.col("ETHN_GRP_DESCR"),
    F.col("TUITION_RESIDENCY_DESCR"),
    F.col("OVERALL_RESIDENCY"),
    F.col("Overall_Residency_Descr"),
)


# COMMAND ----------

# Step: check previous year
# sets flag
# Create df: ndj_uuih_join

# Alias the current-term and historical datasets for the retention flag join.
ndj = df_name_degree_join.alias("NDJ")
uuih = df_uid_union_ife_hist.alias("UUIH")

# Left-join current-year enrollment with the previous year's data to derive the RETENTION_FLG.
df_ndj_uuih_join = ndj.join(
    uuih,
    on=(
        (F.col("NDJ.EMPLID") == F.col("UUIH.EMPLID"))
        & (F.col("NDJ.STRM") == F.lit(term))
        & (F.col("UUIH.STRM") == F.lit(prev_year))
    ),
    how="left",
)

# Project all required columns and derive RETENTION_FLG as 1 if the student was enrolled last year, else 0.
df_ndj_uuih_join = df_ndj_uuih_join.select(
    F.col("NDJ.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("NDJ.EMPLID"),
    F.col("NDJ.ENROLLED_WITHIN_12_MONTHS"),
    F.col("NDJ.AGE_GROUP"),
    F.col("NDJ.IPEDS_STATE"),
    F.col("NDJ.ACAD_CAREER"),
    F.col("NDJ.ACAD_PROGRAM"),
    F.col("NDJ.MAJOR1_DEPT"),
    F.col("NDJ.MAJOR2_DEPT"),
    F.col("NDJ.MINOR1_DEPT"),
    F.col("NDJ.STRM"),
    F.col("NDJ.ACAD_LEVEL_EOT_CD"),
    F.col("NDJ.ACAD_LEVEL_EOT_DESCR"),
    F.col("NDJ.FIRST_NAME"),
    F.col("NDJ.LAST_NAME"),
    F.col("NDJ.MIDDLE_NAME"),
    F.col("NDJ.BIRTH_DT"),
    F.col("NDJ.Age"),
    F.col("NDJ.COHORT_ENTRY"),
    F.col("NDJ.GENDER"),
    F.col("NDJ.ADDRESS"),
    F.col("NDJ.HOME_ADDR_CITY"),
    F.col("NDJ.HOME_ADDR_STATE"),
    F.col("NDJ.HOME_ADDR_POSTAL"),
    F.col("NDJ.HOME_ADDR_COUNTRY"),
    F.col("NDJ.HOME_ADDR_COUNTY"),
    F.col("NDJ.ETHN_GRP"),
    F.col("NDJ.MAJOR1_PLAN"),
    F.col("NDJ.MAJOR1_CIP_CD"),
    F.col("NDJ.MAJOR2_PLAN"),
    F.col("NDJ.MAJOR2_CIP_CD"),
    F.col("NDJ.MINOR1_PLAN"),
    F.col("NDJ.MINOR1_CIP_CD"),
    F.col("NDJ.COURSE_ID"),
    F.col("NDJ.CATALOG_NBR"),
    F.col("NDJ.SUBJECT"),
    F.col("NDJ.INSTRUCTION_MODE"),
    F.col("NDJ.CLASS_START_DT"),
    F.col("NDJ.CLASS_END_DT"),
    F.col("NDJ.CLASS_SECTION"),
    F.col("NDJ.INSTRUCTION_MODE_DESCR"),
    F.col("NDJ.ENRL_ADD_DT"),
    F.col("NDJ.SESSION_CD"),
    F.col("NDJ.UNIT_TAKEN"),
    F.col("NDJ.ADMIT_TERM"),
    F.col("NDJ.RESIDENCY"),
    F.col("NDJ.IPEDS_FULL_PART_TIME_FLG"),
    F.col("NDJ.IPEDS_SCH"),
    F.col("NDJ.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("NDJ.IPEDS_FIPS_CD"),
    F.col("NDJ.CLASS_NBR"),
    F.col("NDJ.SNAPSHOT_DT"),
    F.col("NDJ.IPEDS_ETHNICITY"),
    F.col("NDJ.TERM_DESCR"),
    F.col("NDJ.ACAD_YEAR"),
    F.col("NDJ.CIP_CD_DESCR"),
    F.col("NDJ.ACAD_PROGRAM_DESCR"),
    F.col("NDJ.ACAD_CAREER_DESCR"),
    F.col("NDJ.INIT_TERM"),
    F.col("NDJ.DEPT"),
    F.col("NDJ.COLLEGE"),
    F.col("NDJ.COLLEGE_DESCR"),
    F.col("NDJ.DEPT_DESCR"),
    F.col("NDJ.TUITION_RESIDENCY_DESCR"),
    F.col("NDJ.IPEDS_CITY"),
    F.col("NDJ.IPEDS_COUNTY"),
    F.col("NDJ.IPEDS_COUNTY_CODE"),
    F.col("NDJ.IPEDS_POSTAL"),
    F.col("NDJ.INSTITUTION"),
    F.col("NDJ.DESCR"),
    F.col("NDJ.SHORT_DESCR"),
    F.col("NDJ.TERM_BEGIN_DT"),
    F.col("NDJ.TERM_END_DT"),
    F.col("NDJ.SESSION_DESCR"),
    F.col("NDJ.SESSION_SHORT_DESCR"),
    F.col("NDJ.WEEKS_OF_INSTRN"),
    F.col("NDJ.TERM_CATEGORY_CD"),
    F.col("NDJ.TERM_CATEGORY_DESCR"),
    F.col("NDJ.TERM_CATEGORY_SHORT_DESCR"),
    F.col("NDJ.HOLIDAY_SCHEDULE"),
    F.col("NDJ.SIXTY_PERCENT_DT"),
    # F.col("NDJ.UPDATED_DT"),
    # F.col("NDJ.UPDATED_USER"),
    F.col("NDJ.TERM_SK"),
    F.col("NDJ.CENSUS_DT"),
    F.col("NDJ.DEGREE_DT"),
    F.when(F.col("UUIH.EMPLID").isNotNull(), F.lit(1))
    .otherwise(F.lit(0))
    .alias("RETENTION_FLG"),
    F.col("NDJ.IPEDS_ADDR"),
    F.col("NDJ.IPEDS_COUNTRY"),
    F.col("NDJ.TUITION_RES"),
    F.col("NDJ.RESIDENCY_DESCR"),
).distinct()


# COMMAND ----------

# Persist the retention-flagged dataset to a staging checkpoint table.
_tmp_stageD_tbl = f"{analytics}.{staging}.ndj_uuih_join"
write_df_to_table(
    df_ndj_uuih_join, _tmp_stageD_tbl, mode="overwrite", overwriteSchema="true"
)
df_ndj_uuih_join = read_table(_tmp_stageD_tbl)
log_msg(f"Checkpoint D materialized: {_tmp_stageD_tbl}")

# COMMAND ----------

# Create df: summer_start

# Alias the NDJ/UUIH join result for use in the summer start selection.
nuj = df_ndj_uuih_join.alias("NUJ")

# Select all columns to create the summer start snapshot (includes summer term records).
df_summer_start = nuj.select(
    F.col("NUJ.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("NUJ.EMPLID"),
    F.col("NUJ.ENROLLED_WITHIN_12_MONTHS"),
    F.col("NUJ.AGE_GROUP"),
    F.col("NUJ.IPEDS_STATE"),
    F.col("NUJ.ACAD_CAREER"),
    F.col("NUJ.ACAD_PROGRAM"),
    F.col("NUJ.MAJOR1_DEPT"),
    F.col("NUJ.MAJOR2_DEPT"),
    F.col("NUJ.MINOR1_DEPT"),
    F.col("NUJ.STRM"),
    F.col("NUJ.ACAD_LEVEL_EOT_CD"),
    F.col("NUJ.ACAD_LEVEL_EOT_DESCR"),
    F.col("NUJ.FIRST_NAME"),
    F.col("NUJ.LAST_NAME"),
    F.col("NUJ.MIDDLE_NAME"),
    F.col("NUJ.BIRTH_DT"),
    F.col("NUJ.Age"),
    F.col("NUJ.COHORT_ENTRY"),
    F.col("NUJ.GENDER"),
    F.col("NUJ.ADDRESS"),
    F.col("NUJ.HOME_ADDR_CITY"),
    F.col("NUJ.HOME_ADDR_STATE"),
    F.col("NUJ.HOME_ADDR_POSTAL"),
    F.col("NUJ.HOME_ADDR_COUNTRY"),
    F.col("NUJ.HOME_ADDR_COUNTY"),
    F.col("NUJ.ETHN_GRP"),
    F.col("NUJ.MAJOR1_PLAN"),
    F.col("NUJ.MAJOR1_CIP_CD"),
    F.col("NUJ.MAJOR2_PLAN"),
    F.col("NUJ.MAJOR2_CIP_CD"),
    F.col("NUJ.MINOR1_PLAN"),
    F.col("NUJ.MINOR1_CIP_CD"),
    F.col("NUJ.COURSE_ID"),
    F.col("NUJ.CATALOG_NBR"),
    F.col("NUJ.SUBJECT"),
    F.col("NUJ.INSTRUCTION_MODE"),
    F.col("NUJ.CLASS_START_DT"),
    F.col("NUJ.CLASS_END_DT"),
    F.col("NUJ.CLASS_SECTION"),
    F.col("NUJ.INSTRUCTION_MODE_DESCR"),
    F.col("NUJ.ENRL_ADD_DT"),
    F.col("NUJ.SESSION_CD"),
    F.col("NUJ.UNIT_TAKEN"),
    F.col("NUJ.ADMIT_TERM"),
    F.col("NUJ.RESIDENCY"),
    F.col("NUJ.IPEDS_FULL_PART_TIME_FLG"),
    F.col("NUJ.IPEDS_SCH"),
    F.col("NUJ.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("NUJ.IPEDS_FIPS_CD"),
    F.col("NUJ.CLASS_NBR"),
    F.col("NUJ.SNAPSHOT_DT"),
    F.col("NUJ.IPEDS_ETHNICITY"),
    F.col("NUJ.TERM_DESCR"),
    F.col("NUJ.ACAD_YEAR"),
    F.col("NUJ.CIP_CD_DESCR"),
    F.col("NUJ.ACAD_PROGRAM_DESCR"),
    F.col("NUJ.ACAD_CAREER_DESCR"),
    F.col("NUJ.INIT_TERM"),
    F.col("NUJ.DEPT"),
    F.col("NUJ.COLLEGE"),
    F.col("NUJ.COLLEGE_DESCR"),
    F.col("NUJ.DEPT_DESCR"),
    F.col("NUJ.TUITION_RESIDENCY_DESCR"),
    F.col("NUJ.IPEDS_CITY"),
    F.col("NUJ.IPEDS_COUNTY"),
    F.col("NUJ.IPEDS_COUNTY_CODE"),
    F.col("NUJ.IPEDS_POSTAL"),
    F.col("NUJ.INSTITUTION"),
    F.col("NUJ.DESCR"),
    F.col("NUJ.SHORT_DESCR"),
    F.col("NUJ.TERM_BEGIN_DT"),
    F.col("NUJ.TERM_END_DT"),
    F.col("NUJ.SESSION_DESCR"),
    F.col("NUJ.SESSION_SHORT_DESCR"),
    F.col("NUJ.WEEKS_OF_INSTRN"),
    F.col("NUJ.TERM_CATEGORY_CD"),
    F.col("NUJ.TERM_CATEGORY_DESCR"),
    F.col("NUJ.TERM_CATEGORY_SHORT_DESCR"),
    F.col("NUJ.HOLIDAY_SCHEDULE"),
    F.col("NUJ.SIXTY_PERCENT_DT"),
    # F.col("NUJ.UPDATED_DT"),
    # F.col("NUJ.UPDATED_USER"),
    F.col("NUJ.TERM_SK"),
    F.col("NUJ.CENSUS_DT"),
    F.col("NUJ.DEGREE_DT"),
    F.col("NUJ.RETENTION_FLG"),
    F.col("NUJ.IPEDS_ADDR"),
    F.col("NUJ.IPEDS_COUNTRY"),
    F.col("NUJ.TUITION_RES"),
    F.col("NUJ.RESIDENCY_DESCR"),
)


# COMMAND ----------

# Step: cohort updates
# Create df: nuj_summerstart_join

# Alias the summer start DataFrame for the cohort correction join.
summerstart = df_summer_start.alias("SummerStart")

# Inner-join current-term enrollments with summer start records to find students whose cohort should
# be adjusted to reflect their summer entry status.
df_nuj_summerstart_join = nuj.join(
    summerstart,
    on=(
        (F.col("NUJ.STRM") == F.lit(term))
        & (F.col("SummerStart.STRM") == F.lit(summerterm))
        & (F.col("NUJ.EMPLID") == F.col("SummerStart.EMPLID"))
        & (F.col("NUJ.ACAD_CAREER") == F.col("SummerStart.ACAD_CAREER"))
    ),
    how="inner",
)

# Select EMPLID, term, and the adjusted cohort (from summer start if available, else original cohort).
df_nuj_summerstart_join = df_nuj_summerstart_join.select(
    F.col("NUJ.EMPLID"),
    F.col("NUJ.STRM"),
    F.when(
        (F.col("NUJ.EMPLID").isNotNull() & F.col("SummerStart.EMPLID").isNotNull()),
        F.col("SummerStart.COHORT_ENTRY"),
    )
    .otherwise(F.col("NUJ.COHORT_ENTRY"))
    .alias("Adjusted_Cohort"),
).distinct()


# COMMAND ----------

# Create df: nuj_strm_term

# Filter the combined dataset to only retain records for the current fall term.
df_nuj_strm_term = nuj.filter(F.col("NUJ.STRM") == F.lit(term))

# Select all required columns from the fall-term-only dataset.
df_nuj_strm_term = df_nuj_strm_term.select(
    F.col("NUJ.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("NUJ.EMPLID"),
    F.col("NUJ.ENROLLED_WITHIN_12_MONTHS"),
    F.col("NUJ.AGE_GROUP"),
    F.col("NUJ.IPEDS_STATE"),
    F.col("NUJ.ACAD_CAREER"),
    F.col("NUJ.ACAD_PROGRAM"),
    F.col("NUJ.MAJOR1_DEPT"),
    F.col("NUJ.MAJOR2_DEPT"),
    F.col("NUJ.MINOR1_DEPT"),
    F.col("NUJ.STRM"),
    F.col("NUJ.ACAD_LEVEL_EOT_CD"),
    F.col("NUJ.ACAD_LEVEL_EOT_DESCR"),
    F.col("NUJ.FIRST_NAME"),
    F.col("NUJ.LAST_NAME"),
    F.col("NUJ.MIDDLE_NAME"),
    F.col("NUJ.BIRTH_DT"),
    F.col("NUJ.Age"),
    F.col("NUJ.COHORT_ENTRY"),
    F.col("NUJ.GENDER"),
    F.col("NUJ.ADDRESS"),
    F.col("NUJ.HOME_ADDR_CITY"),
    F.col("NUJ.HOME_ADDR_STATE"),
    F.col("NUJ.HOME_ADDR_POSTAL"),
    F.col("NUJ.HOME_ADDR_COUNTRY"),
    F.col("NUJ.HOME_ADDR_COUNTY"),
    F.col("NUJ.ETHN_GRP"),
    F.col("NUJ.MAJOR1_PLAN"),
    F.col("NUJ.MAJOR1_CIP_CD"),
    F.col("NUJ.MAJOR2_PLAN"),
    F.col("NUJ.MAJOR2_CIP_CD"),
    F.col("NUJ.MINOR1_PLAN"),
    F.col("NUJ.MINOR1_CIP_CD"),
    F.col("NUJ.COURSE_ID"),
    F.col("NUJ.CATALOG_NBR"),
    F.col("NUJ.SUBJECT"),
    F.col("NUJ.INSTRUCTION_MODE"),
    F.col("NUJ.CLASS_START_DT"),
    F.col("NUJ.CLASS_END_DT"),
    F.col("NUJ.CLASS_SECTION"),
    F.col("NUJ.INSTRUCTION_MODE_DESCR"),
    F.col("NUJ.ENRL_ADD_DT"),
    F.col("NUJ.SESSION_CD"),
    F.col("NUJ.UNIT_TAKEN"),
    F.col("NUJ.ADMIT_TERM"),
    F.col("NUJ.RESIDENCY"),
    F.col("NUJ.IPEDS_FULL_PART_TIME_FLG"),
    F.col("NUJ.IPEDS_SCH"),
    F.col("NUJ.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("NUJ.IPEDS_FIPS_CD"),
    F.col("NUJ.CLASS_NBR"),
    F.col("NUJ.SNAPSHOT_DT"),
    F.col("NUJ.IPEDS_ETHNICITY"),
    F.col("NUJ.TERM_DESCR"),
    F.col("NUJ.ACAD_YEAR"),
    F.col("NUJ.CIP_CD_DESCR"),
    F.col("NUJ.ACAD_PROGRAM_DESCR"),
    F.col("NUJ.ACAD_CAREER_DESCR"),
    F.col("NUJ.INIT_TERM"),
    F.col("NUJ.DEPT"),
    F.col("NUJ.COLLEGE"),
    F.col("NUJ.COLLEGE_DESCR"),
    F.col("NUJ.DEPT_DESCR"),
    F.col("NUJ.TUITION_RESIDENCY_DESCR"),
    F.col("NUJ.IPEDS_CITY"),
    F.col("NUJ.IPEDS_COUNTY"),
    F.col("NUJ.IPEDS_COUNTY_CODE"),
    F.col("NUJ.IPEDS_POSTAL"),
    F.col("NUJ.INSTITUTION"),
    F.col("NUJ.DESCR"),
    F.col("NUJ.SHORT_DESCR"),
    F.col("NUJ.TERM_BEGIN_DT"),
    F.col("NUJ.TERM_END_DT"),
    F.col("NUJ.SESSION_DESCR"),
    F.col("NUJ.SESSION_SHORT_DESCR"),
    F.col("NUJ.WEEKS_OF_INSTRN"),
    F.col("NUJ.TERM_CATEGORY_CD"),
    F.col("NUJ.TERM_CATEGORY_DESCR"),
    F.col("NUJ.TERM_CATEGORY_SHORT_DESCR"),
    F.col("NUJ.HOLIDAY_SCHEDULE"),
    F.col("NUJ.SIXTY_PERCENT_DT"),
    # F.col("NUJ.UPDATED_DT"),
    # F.col("NUJ.UPDATED_USER"),
    F.col("NUJ.TERM_SK"),
    F.col("NUJ.CENSUS_DT"),
    F.col("NUJ.DEGREE_DT"),
    F.col("NUJ.RETENTION_FLG"),
    F.col("NUJ.IPEDS_ADDR"),
    F.col("NUJ.IPEDS_COUNTRY"),
    F.col("NUJ.TUITION_RES"),
    F.col("NUJ.RESIDENCY_DESCR"),
)

# COMMAND ----------

# Step: students to drop
# summer term

# nuj_strm_summmerterm
# Get distinct students enrolled only in the summer term.
df_nuj_strm_summmerterm = nuj.filter(F.col("STRM") == F.lit(summerterm))
df_nuj_strm_summmerterm = df_nuj_strm_summmerterm.select(F.col("EMPLID")).distinct()

# nuj_strm_distEmp
# Get distinct students enrolled in the current fall term.
df_nuj_strm_distEmp = df_nuj_strm_term.select(F.col("EMPLID")).distinct()

# summer_term
# Identify students who appear only in summer term and NOT in the fall term (summer-only students).
df_summer_term = df_nuj_strm_summmerterm.subtract(df_nuj_strm_distEmp)


# COMMAND ----------

# Step: filter out the summer only students
# Create df: nuj_emplid_filt

# Alias the summer-only student set for joining.
st = df_summer_term.alias("ST")

# extract distinct emplid
# Inner-join with NUJ to retrieve all rows for summer-only students.
df_st_nuj_join = st.join(nuj, on=F.col("ST.EMPLID") == F.col("NUJ.EMPLID"), how="inner")
# Collect the distinct summer-only EMPLIDs as a Python list for use in a filter.
dist_emplid = df_st_nuj_join.select("ST.EMPLID").distinct().collect()
empl_id = []
# Convert collected rows to a plain list of EMPLID values.
empl_id = [row["EMPLID"] for row in dist_emplid]

# emplid filter
# Exclude the identified summer-only students from the full dataset.
df_nuj_emplid_filt = nuj.filter(~(F.col("EMPLID").isin(empl_id)))

# Select all required columns from the filtered dataset.
df_nuj_emplid_filt = df_nuj_emplid_filt.select(
    F.col("NUJ.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("NUJ.EMPLID"),
    F.col("NUJ.ENROLLED_WITHIN_12_MONTHS"),
    F.col("NUJ.AGE_GROUP"),
    F.col("NUJ.IPEDS_STATE"),
    F.col("NUJ.ACAD_CAREER"),
    F.col("NUJ.ACAD_PROGRAM"),
    F.col("NUJ.MAJOR1_DEPT"),
    F.col("NUJ.MAJOR2_DEPT"),
    F.col("NUJ.MINOR1_DEPT"),
    F.col("NUJ.STRM"),
    F.col("NUJ.ACAD_LEVEL_EOT_CD"),
    F.col("NUJ.ACAD_LEVEL_EOT_DESCR"),
    F.col("NUJ.FIRST_NAME"),
    F.col("NUJ.LAST_NAME"),
    F.col("NUJ.MIDDLE_NAME"),
    F.col("NUJ.BIRTH_DT"),
    F.col("NUJ.Age"),
    F.col("NUJ.COHORT_ENTRY"),
    F.col("NUJ.GENDER"),
    F.col("NUJ.ADDRESS"),
    F.col("NUJ.HOME_ADDR_CITY"),
    F.col("NUJ.HOME_ADDR_STATE"),
    F.col("NUJ.HOME_ADDR_POSTAL"),
    F.col("NUJ.HOME_ADDR_COUNTRY"),
    F.col("NUJ.HOME_ADDR_COUNTY"),
    F.col("NUJ.ETHN_GRP"),
    F.col("NUJ.MAJOR1_PLAN"),
    F.col("NUJ.MAJOR1_CIP_CD"),
    F.col("NUJ.MAJOR2_PLAN"),
    F.col("NUJ.MAJOR2_CIP_CD"),
    F.col("NUJ.MINOR1_PLAN"),
    F.col("NUJ.MINOR1_CIP_CD"),
    F.col("NUJ.COURSE_ID"),
    F.col("NUJ.CATALOG_NBR"),
    F.col("NUJ.SUBJECT"),
    F.col("NUJ.INSTRUCTION_MODE"),
    F.col("NUJ.CLASS_START_DT"),
    F.col("NUJ.CLASS_END_DT"),
    F.col("NUJ.CLASS_SECTION"),
    F.col("NUJ.INSTRUCTION_MODE_DESCR"),
    F.col("NUJ.ENRL_ADD_DT"),
    F.col("NUJ.SESSION_CD"),
    F.col("NUJ.UNIT_TAKEN"),
    F.col("NUJ.ADMIT_TERM"),
    F.col("NUJ.RESIDENCY"),
    F.col("NUJ.IPEDS_FULL_PART_TIME_FLG"),
    F.col("NUJ.IPEDS_SCH"),
    F.col("NUJ.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("NUJ.IPEDS_FIPS_CD"),
    F.col("NUJ.CLASS_NBR"),
    F.col("NUJ.SNAPSHOT_DT"),
    F.col("NUJ.IPEDS_ETHNICITY"),
    F.col("NUJ.TERM_DESCR"),
    F.col("NUJ.ACAD_YEAR"),
    F.col("NUJ.CIP_CD_DESCR"),
    F.col("NUJ.ACAD_PROGRAM_DESCR"),
    F.col("NUJ.ACAD_CAREER_DESCR"),
    F.col("NUJ.INIT_TERM"),
    F.col("NUJ.DEPT"),
    F.col("NUJ.COLLEGE"),
    F.col("NUJ.COLLEGE_DESCR"),
    F.col("NUJ.DEPT_DESCR"),
    F.col("NUJ.TUITION_RESIDENCY_DESCR"),
    F.col("NUJ.IPEDS_CITY"),
    F.col("NUJ.IPEDS_COUNTY"),
    F.col("NUJ.IPEDS_COUNTY_CODE"),
    F.col("NUJ.IPEDS_POSTAL"),
    F.col("NUJ.INSTITUTION"),
    F.col("NUJ.DESCR"),
    F.col("NUJ.SHORT_DESCR"),
    F.col("NUJ.TERM_BEGIN_DT"),
    F.col("NUJ.TERM_END_DT"),
    F.col("NUJ.SESSION_DESCR"),
    F.col("NUJ.SESSION_SHORT_DESCR"),
    F.col("NUJ.WEEKS_OF_INSTRN"),
    F.col("NUJ.TERM_CATEGORY_CD"),
    F.col("NUJ.TERM_CATEGORY_DESCR"),
    F.col("NUJ.TERM_CATEGORY_SHORT_DESCR"),
    F.col("NUJ.HOLIDAY_SCHEDULE"),
    F.col("NUJ.SIXTY_PERCENT_DT"),
    # F.col("NUJ.UPDATED_DT"),
    # F.col("NUJ.UPDATED_USER"),
    F.col("NUJ.TERM_SK"),
    F.col("NUJ.CENSUS_DT"),
    F.col("NUJ.DEGREE_DT"),
    F.col("NUJ.RETENTION_FLG"),
    F.col("NUJ.IPEDS_ADDR"),
    F.col("NUJ.IPEDS_COUNTRY"),
    F.col("NUJ.TUITION_RES"),
    F.col("NUJ.RESIDENCY_DESCR"),
)


# COMMAND ----------

# Step: filter for only &term.
# Create df: nuj_empl_summ_join

# Alias the filtered enrollment and summer start cohort DataFrames.
nuj_empfilt = df_nuj_emplid_filt.alias("NUJ_EmpFilt")
nuj_summstart = df_nuj_summerstart_join.alias("NUJ_SummStart")

# Left-join the filtered enrollment with summer cohort adjustments on EMPLID.
df_nuj_empl_summ_join = nuj_empfilt.join(
    nuj_summstart,
    on=(F.col("NUJ_EmpFilt.EMPLID") == F.col("NUJ_SummStart.EMPLID")),
    how="left",
)

# Retain only records for the current fall term.
df_nuj_empl_summ_join = df_nuj_empl_summ_join.filter(
    F.col("NUJ_EmpFilt.STRM") == F.lit(term)
)

# Project all required columns; apply the adjusted cohort (summer entry) where available.
df_nuj_empl_summ_join = df_nuj_empl_summ_join.select(
    F.col("NUJ_EmpFilt.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("NUJ_EmpFilt.EMPLID"),
    F.col("NUJ_EmpFilt.ENROLLED_WITHIN_12_MONTHS"),
    F.col("NUJ_EmpFilt.AGE_GROUP"),
    F.col("NUJ_EmpFilt.IPEDS_STATE"),
    F.col("NUJ_EmpFilt.ACAD_CAREER"),
    F.col("NUJ_EmpFilt.ACAD_PROGRAM"),
    F.col("NUJ_EmpFilt.MAJOR1_DEPT"),
    F.col("NUJ_EmpFilt.MAJOR2_DEPT"),
    F.col("NUJ_EmpFilt.MINOR1_DEPT"),
    F.col("NUJ_EmpFilt.STRM"),
    F.col("NUJ_EmpFilt.ACAD_LEVEL_EOT_CD"),
    F.col("NUJ_EmpFilt.ACAD_LEVEL_EOT_DESCR"),
    F.col("NUJ_EmpFilt.FIRST_NAME"),
    F.col("NUJ_EmpFilt.LAST_NAME"),
    F.col("NUJ_EmpFilt.MIDDLE_NAME"),
    F.col("NUJ_EmpFilt.BIRTH_DT"),
    F.col("NUJ_EmpFilt.Age"),
    F.coalesce(
        F.col("NUJ_SummStart.Adjusted_Cohort"), F.col("NUJ_EmpFilt.COHORT_ENTRY")
    ).alias("COHORT_ENTRY"),
    F.col("NUJ_EmpFilt.GENDER"),
    F.col("NUJ_EmpFilt.ADDRESS"),
    F.col("NUJ_EmpFilt.HOME_ADDR_CITY"),
    F.col("NUJ_EmpFilt.HOME_ADDR_STATE"),
    F.col("NUJ_EmpFilt.HOME_ADDR_POSTAL"),
    F.col("NUJ_EmpFilt.HOME_ADDR_COUNTRY"),
    F.col("NUJ_EmpFilt.HOME_ADDR_COUNTY"),
    F.col("NUJ_EmpFilt.ETHN_GRP"),
    F.col("NUJ_EmpFilt.MAJOR1_PLAN"),
    F.col("NUJ_EmpFilt.MAJOR1_CIP_CD"),
    F.col("NUJ_EmpFilt.MAJOR2_PLAN"),
    F.col("NUJ_EmpFilt.MAJOR2_CIP_CD"),
    F.col("NUJ_EmpFilt.MINOR1_PLAN"),
    F.col("NUJ_EmpFilt.MINOR1_CIP_CD"),
    F.col("NUJ_EmpFilt.COURSE_ID"),
    F.col("NUJ_EmpFilt.CATALOG_NBR"),
    F.col("NUJ_EmpFilt.SUBJECT"),
    F.col("NUJ_EmpFilt.INSTRUCTION_MODE"),
    F.col("NUJ_EmpFilt.CLASS_START_DT"),
    F.col("NUJ_EmpFilt.CLASS_END_DT"),
    F.col("NUJ_EmpFilt.CLASS_SECTION"),
    F.col("NUJ_EmpFilt.INSTRUCTION_MODE_DESCR"),
    F.col("NUJ_EmpFilt.ENRL_ADD_DT"),
    F.col("NUJ_EmpFilt.SESSION_CD"),
    F.col("NUJ_EmpFilt.UNIT_TAKEN"),
    F.col("NUJ_EmpFilt.ADMIT_TERM"),
    F.col("NUJ_EmpFilt.RESIDENCY"),
    F.col("NUJ_EmpFilt.IPEDS_FULL_PART_TIME_FLG"),
    F.col("NUJ_EmpFilt.IPEDS_SCH"),
    F.col("NUJ_EmpFilt.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("NUJ_EmpFilt.IPEDS_FIPS_CD"),
    F.col("NUJ_EmpFilt.CLASS_NBR"),
    F.col("NUJ_EmpFilt.SNAPSHOT_DT"),
    F.col("NUJ_EmpFilt.IPEDS_ETHNICITY"),
    F.col("NUJ_EmpFilt.TERM_DESCR"),
    F.col("NUJ_EmpFilt.ACAD_YEAR"),
    F.col("NUJ_EmpFilt.CIP_CD_DESCR"),
    F.col("NUJ_EmpFilt.ACAD_PROGRAM_DESCR"),
    F.col("NUJ_EmpFilt.ACAD_CAREER_DESCR"),
    F.col("NUJ_EmpFilt.INIT_TERM"),
    F.col("NUJ_EmpFilt.DEPT"),
    F.col("NUJ_EmpFilt.COLLEGE"),
    F.col("NUJ_EmpFilt.COLLEGE_DESCR"),
    F.col("NUJ_EmpFilt.DEPT_DESCR"),
    F.col("NUJ_EmpFilt.TUITION_RESIDENCY_DESCR"),
    F.col("NUJ_EmpFilt.IPEDS_CITY"),
    F.col("NUJ_EmpFilt.IPEDS_COUNTY"),
    F.col("NUJ_EmpFilt.IPEDS_COUNTY_CODE"),
    F.col("NUJ_EmpFilt.IPEDS_POSTAL"),
    F.col("NUJ_EmpFilt.INSTITUTION"),
    F.col("NUJ_EmpFilt.DESCR"),
    F.col("NUJ_EmpFilt.SHORT_DESCR"),
    F.col("NUJ_EmpFilt.TERM_BEGIN_DT"),
    F.col("NUJ_EmpFilt.TERM_END_DT"),
    F.col("NUJ_EmpFilt.SESSION_DESCR"),
    F.col("NUJ_EmpFilt.SESSION_SHORT_DESCR"),
    F.col("NUJ_EmpFilt.WEEKS_OF_INSTRN"),
    F.col("NUJ_EmpFilt.TERM_CATEGORY_CD"),
    F.col("NUJ_EmpFilt.TERM_CATEGORY_DESCR"),
    F.col("NUJ_EmpFilt.TERM_CATEGORY_SHORT_DESCR"),
    F.col("NUJ_EmpFilt.HOLIDAY_SCHEDULE"),
    F.col("NUJ_EmpFilt.SIXTY_PERCENT_DT"),
    # F.col("NUJ_EmpFilt.UPDATED_DT"),
    # F.col("NUJ_EmpFilt.UPDATED_USER"),
    F.col("NUJ_EmpFilt.TERM_SK"),
    F.col("NUJ_EmpFilt.CENSUS_DT"),
    F.col("NUJ_EmpFilt.DEGREE_DT"),
    F.col("NUJ_EmpFilt.RETENTION_FLG"),
    F.col("NUJ_EmpFilt.IPEDS_ADDR"),
    F.col("NUJ_EmpFilt.IPEDS_COUNTRY"),
    F.col("NUJ_EmpFilt.TUITION_RES"),
    F.col("NUJ_EmpFilt.RESIDENCY_DESCR"),
)


# COMMAND ----------

# Step: new retention cohort logic
# Create df: new_retention

# Join the student term enrollment fact with term, academic program, and career dimensions
# to build the new retention cohort base dataset.
df_new_retention = (
    astef.join(
        atd,
        on=(
            F.col("ASTEF.TERM_SK").cast("bigint") == F.col("ATD.TERM_SK").cast("bigint")
        ),
        how="inner",
    )
    .join(
        aapd,
        on=(
            F.col("ASTEF.ACAD_PROGRAM_PRIMARY").cast("bigint")
            == F.col("AAPD.ACAD_PROGRAM_SK").cast("bigint")
        ),
        how="inner",
    )
    .join(
        aacd,
        on=(
            F.col("ASTEF.ACAD_CAREER_SK").cast("bigint")
            == F.col("AACD.ACAD_CAREER_SK").cast("bigint")
        ),
        how="left",
    )
)

# Retain only actively enrolled students.
df_new_retention = df_new_retention.filter(
    F.col("ASTEF.STUDENT_ENRL_FLG") == F.lit("Y")
)

# Compute the earliest term surrogate key per student, career, and program for first-time enrollment.
df_new_retention = df_new_retention.withColumn(
    "MIN_TERM_SK",
    F.min(F.col("ASTEF.TERM_SK").cast("bigint")).over(
        Window.partitionBy(
            "ASTEF.EMPLID", "ASTEF.ACAD_CAREER_SK", "ASTEF.ACAD_PROGRAM_PRIMARY"
        )
    ),
)

# Keep only the first-term row per student-career-program and drop the helper column.
df_new_retention = df_new_retention.filter(
    F.col("ASTEF.TERM_SK").cast("bigint") == F.col("MIN_TERM_SK")
).drop("MIN_TERM_SK")

# Select the key columns needed for the retention cohort lookup.
df_new_retention = df_new_retention.select(
    F.col("ASTEF.EMPLID"),
    F.col("AACD.ACAD_CAREER"),
    F.col("AAPD.ACAD_PROGRAM"),
    F.col("ATD.STRM"),
    F.col("ASTEF.ACAD_PROGRAM_PRIMARY"),
)


# COMMAND ----------

# Step: Join
# ethnic descriptions
# Create df: ethnic_desc

# Alias the filtered enrollment and retention DataFrames.
nesj = df_nuj_empl_summ_join.alias("NESJ")
# Get distinct student-career-program-term combinations from the retention cohort.
nr = (
    df_new_retention.select("EMPLID", "ACAD_CAREER", "ACAD_PROGRAM", "STRM")
    .distinct()
    .alias("NR")
)

# Left-join current enrollment with the retention cohort to classify students as New or Continuing.
df_ethnic_desc = nesj.join(
    nr,
    on=(
        (F.col("NESJ.EMPLID") == F.col("NR.EMPLID"))
        & (F.col("NESJ.ACAD_CAREER") == F.col("NR.ACAD_CAREER"))
        & (F.col("NESJ.ACAD_PROGRAM") == F.col("NR.ACAD_PROGRAM"))
    ),
    how="left",
)

# Project all output columns and derive: STUDENTRETENTIONCATEGORY, IPEDS_ETHNICITY_DESCR, and ETHN_GRP_DESCR.
df_ethnic_desc = df_ethnic_desc.select(
    F.col("NESJ.MIN_ONE_ONLINE_COURSE_FLG"),
    F.col("NESJ.EMPLID"),
    F.col("NESJ.ENROLLED_WITHIN_12_MONTHS"),
    F.col("NESJ.AGE_GROUP"),
    F.col("NESJ.IPEDS_STATE"),
    F.col("NESJ.ACAD_CAREER"),
    F.col("NESJ.ACAD_PROGRAM"),
    F.col("NESJ.MAJOR1_DEPT"),
    F.col("NESJ.MAJOR2_DEPT"),
    F.col("NESJ.MINOR1_DEPT"),
    F.col("NESJ.STRM"),
    F.col("NESJ.ACAD_LEVEL_EOT_CD"),
    F.col("NESJ.ACAD_LEVEL_EOT_DESCR"),
    F.col("NESJ.FIRST_NAME"),
    F.col("NESJ.LAST_NAME"),
    F.col("NESJ.MIDDLE_NAME"),
    F.col("NESJ.BIRTH_DT"),
    F.col("NESJ.Age"),
    F.col("NESJ.COHORT_ENTRY"),
    F.col("NESJ.GENDER"),
    F.col("NESJ.ADDRESS"),
    F.col("NESJ.HOME_ADDR_CITY"),
    F.col("NESJ.HOME_ADDR_STATE"),
    F.col("NESJ.HOME_ADDR_POSTAL"),
    F.col("NESJ.HOME_ADDR_COUNTRY"),
    F.col("NESJ.HOME_ADDR_COUNTY"),
    F.col("NESJ.ETHN_GRP"),
    F.col("NESJ.MAJOR1_PLAN"),
    F.col("NESJ.MAJOR1_CIP_CD"),
    F.col("NESJ.MAJOR2_PLAN"),
    F.col("NESJ.MAJOR2_CIP_CD"),
    F.col("NESJ.MINOR1_PLAN"),
    F.col("NESJ.MINOR1_CIP_CD"),
    F.col("NESJ.COURSE_ID"),
    F.col("NESJ.CATALOG_NBR"),
    F.col("NESJ.SUBJECT"),
    F.col("NESJ.INSTRUCTION_MODE"),
    F.col("NESJ.CLASS_START_DT"),
    F.col("NESJ.CLASS_END_DT"),
    F.col("NESJ.CLASS_SECTION"),
    F.col("NESJ.INSTRUCTION_MODE_DESCR"),
    F.col("NESJ.ENRL_ADD_DT"),
    F.col("NESJ.SESSION_CD"),
    F.col("NESJ.UNIT_TAKEN"),
    F.col("NESJ.ADMIT_TERM"),
    F.col("NESJ.RESIDENCY"),
    F.col("NESJ.IPEDS_FULL_PART_TIME_FLG"),
    F.col("NESJ.IPEDS_SCH"),
    F.col("NESJ.IPEDS_DISTANCE_EDUCATION_STATUS"),
    F.col("NESJ.IPEDS_FIPS_CD"),
    F.col("NESJ.CLASS_NBR"),
    F.col("NESJ.SNAPSHOT_DT"),
    F.col("NESJ.IPEDS_ETHNICITY"),
    F.col("NESJ.TERM_DESCR"),
    F.col("NESJ.ACAD_YEAR"),
    F.col("NESJ.CIP_CD_DESCR"),
    F.col("NESJ.ACAD_PROGRAM_DESCR"),
    F.col("NESJ.ACAD_CAREER_DESCR"),
    F.col("NESJ.INIT_TERM"),
    F.col("NESJ.DEPT"),
    F.col("NESJ.COLLEGE"),
    F.col("NESJ.COLLEGE_DESCR"),
    F.col("NESJ.DEPT_DESCR"),
    F.col("NESJ.TUITION_RESIDENCY_DESCR"),
    F.col("NESJ.IPEDS_CITY"),
    F.col("NESJ.IPEDS_COUNTY"),
    F.col("NESJ.IPEDS_COUNTY_CODE"),
    F.col("NESJ.IPEDS_POSTAL"),
    F.col("NESJ.INSTITUTION"),
    F.col("NESJ.DESCR"),
    F.col("NESJ.SHORT_DESCR"),
    F.col("NESJ.TERM_BEGIN_DT"),
    F.col("NESJ.TERM_END_DT"),
    F.col("NESJ.SESSION_DESCR"),
    F.col("NESJ.SESSION_SHORT_DESCR"),
    F.col("NESJ.WEEKS_OF_INSTRN"),
    F.col("NESJ.TERM_CATEGORY_CD"),
    F.col("NESJ.TERM_CATEGORY_DESCR"),
    F.col("NESJ.TERM_CATEGORY_SHORT_DESCR"),
    F.col("NESJ.HOLIDAY_SCHEDULE"),
    F.col("NESJ.SIXTY_PERCENT_DT"),
    # F.col("NESJ.UPDATED_DT"),
    # F.col("NESJ.UPDATED_USER"),
    F.col("NESJ.TERM_SK"),
    F.col("NESJ.CENSUS_DT"),
    F.col("NESJ.DEGREE_DT"),
    F.col("NESJ.RETENTION_FLG"),
    F.col("NESJ.IPEDS_ADDR"),
    F.col("NESJ.IPEDS_COUNTRY"),
    F.col("NESJ.TUITION_RES"),
    F.when(
        (
            (F.col("NESJ.STRM") == F.coalesce(F.col("NR.STRM"), F.lit("")))
            | (
                F.col("NR.STRM")
                == F.when(
                    (F.substring(F.col("NESJ.STRM"), 4, 1) == F.lit("8")),
                    F.concat(F.substring(F.col("NESJ.STRM"), 1, 3), F.lit("5")),
                ).otherwise(F.lit(""))
            )
        ),
        F.lit("New"),
    )
    .otherwise(F.lit("Continuing"))
    .alias("STUDENTRETENTIONCATEGORY"),
    F.when(
        (F.substring(F.col("NESJ.STRM"), 4, 1) == F.lit("8")),
        F.concat(F.substring(F.col("NESJ.STRM"), 1, 3), F.lit("5")),
    )
    .otherwise(F.lit(""))
    .alias("strm2"),
    F.when((F.col("NESJ.IPEDS_ETHNICITY") == F.lit("ASIAN")), F.lit("Asian"))
    .when(
        (F.col("NESJ.IPEDS_ETHNICITY") == F.lit("HISPANIC")),
        F.lit("Hispanic or Latino"),
    )
    .when((F.col("NESJ.IPEDS_ETHNICITY") == F.lit("WHITE")), F.lit("White"))
    .when((F.col("NESJ.IPEDS_ETHNICITY") == F.lit("MULTIPLE")), F.lit("Multiple"))
    .when(
        (F.col("NESJ.IPEDS_ETHNICITY") == F.lit("NSPEC")),
        F.lit("Race/ethnicity unknown"),
    )
    .when(
        (F.col("NESJ.IPEDS_ETHNICITY") == F.lit("BLACK")),
        F.lit("Black or African American"),
    )
    .when((F.col("NESJ.IPEDS_ETHNICITY") == F.lit("FORGN")), F.lit("U.S. Nonresident"))
    .when(
        (F.col("NESJ.IPEDS_ETHNICITY") == F.lit("AMIND")),
        F.lit("American Indian or Alaska Native"),
    )
    .when(
        (F.col("NESJ.IPEDS_ETHNICITY") == F.lit("PACIF")),
        F.lit("Native Hawaiian or Other Pacific Islander"),
    )
    .otherwise(F.lit(""))
    .alias("IPEDS_ETHNICITY_DESCR"),
    F.when((F.col("NESJ.ETHN_GRP") == F.lit("ASIAN")), F.lit("Asian"))
    .when((F.col("NESJ.ETHN_GRP") == F.lit("HISPANIC")), F.lit("Hispanic or Latino"))
    .when((F.col("NESJ.ETHN_GRP") == F.lit("WHITE")), F.lit("White"))
    .when((F.col("NESJ.ETHN_GRP") == F.lit("MULTIPLE")), F.lit("Multiple"))
    .when((F.col("NESJ.ETHN_GRP") == F.lit("NSPEC")), F.lit("Race/ethnicity unknown"))
    .when(
        (F.col("NESJ.ETHN_GRP") == F.lit("BLACK")), F.lit("Black or African American")
    )
    .when((F.col("NESJ.ETHN_GRP") == F.lit("FORGN")), F.lit("U.S. Nonresident"))
    .when(
        (F.col("NESJ.ETHN_GRP") == F.lit("AMIND")),
        F.lit("American Indian or Alaska Native"),
    )
    .when(
        (F.col("NESJ.ETHN_GRP") == F.lit("PACIF")),
        F.lit("Native Hawaiian or Other Pacific Islander"),
    )
    .otherwise(F.lit(""))
    .alias("ETHN_GRP_DESCR"),
    F.col("NESJ.RESIDENCY_DESCR"),
)


# COMMAND ----------

# Cast all columns to their target schema types and rename columns to match the final table definition.
# Create df: map_cols

df_map_cols = df_ethnic_desc.select(
    F.trim(F.substring(F.col("MIN_ONE_ONLINE_COURSE_FLG").cast("string"), 1, 1)).alias("MIN_ONE_ONLINE_COURSE_FLG"),
    F.trim(F.substring(F.col("EMPLID").cast("string"), 1, 11)).alias("EMPLID"),
    F.col("ENROLLED_WITHIN_12_MONTHS").cast("bigint").alias("ENROLLED_WITHIN_12_MONTHS"),
    F.trim(F.substring(F.col("AGE_GROUP").cast("string"), 1, 20)).alias("AGE_GROUP"),
    F.trim(F.substring(F.col("IPEDS_STATE").cast("string"), 1, 6)).alias("IPEDS_STATE"),
    F.trim(F.substring(F.col("ACAD_CAREER").cast("string"), 1, 4)).alias("ACAD_CAREER"),
    F.trim(F.substring(F.col("ACAD_PROGRAM").cast("string"), 1, 5)).alias("ACAD_PROGRAM"),
    F.trim(F.substring(F.col("MAJOR1_DEPT").cast("string"), 1, 10)).alias("MAJOR1_DEPT"),
    F.trim(F.substring(F.col("MAJOR2_DEPT").cast("string"), 1, 10)).alias("MAJOR2_DEPT"),
    F.trim(F.substring(F.col("MINOR1_DEPT").cast("string"), 1, 10)).alias("MINOR1_DEPT"),
    F.trim(F.substring(F.col("STRM").cast("string"), 1, 4)).alias("STRM"),
    F.trim(F.substring(F.col("ACAD_LEVEL_EOT_CD").cast("string"), 1, 3)).alias("ACAD_LEVEL_EOT_CD"),
    F.trim(F.substring(F.col("ACAD_LEVEL_EOT_DESCR").cast("string"), 1, 30)).alias("ACAD_LEVEL_EOT_DESCR"),
    F.substring(F.col("FIRST_NAME").cast("string"), 1, 30).alias("FIRST_NAME"),
    F.substring(F.col("LAST_NAME").cast("string"), 1, 30).alias("LAST_NAME"),
    F.when(
        (F.col("MIDDLE_NAME").isNull() | (F.trim(F.col("MIDDLE_NAME")) == F.lit(""))),
        F.lit(None),
    )
    .otherwise(F.substring(F.col("MIDDLE_NAME").cast("string"), 1, 30))
    .alias("MIDDLE_NAME"),
    F.col("BIRTH_DT").cast("timestamp").alias("BIRTH_DT"),
    F.col("AGE").cast("bigint").alias("AGE"),
    F.trim(F.substring(F.col("COHORT_ENTRY").cast("string"), 1, 50)).alias("COHORT_TYPE"),
    F.trim(F.substring(F.col("GENDER").cast("string"), 1, 11)).alias("GENDER"),
    F.trim(
        F.substring(
            F.when(
                (F.col("ADDRESS").isNull() | (F.col("ADDRESS") == F.lit(""))),
                F.lit(None),
            ).otherwise(F.col("ADDRESS").cast("string")),
            1,
            55,
        )
    ).alias("HOME_ADDR"),
    F.trim(F.substring(F.col("HOME_ADDR_CITY").cast("string"), 1, 30)).alias("HOME_ADDR_CITY"),
    F.trim(F.substring(F.col("HOME_ADDR_STATE").cast("string"), 1, 6)).alias("HOME_ADDR_STATE"),
    F.trim(F.substring(F.col("HOME_ADDR_POSTAL").cast("string"), 1, 12)).alias("HOME_ADDR_POSTAL"),
    F.trim(F.substring(F.col("HOME_ADDR_COUNTRY").cast("string"), 1, 3)).alias("HOME_ADDR_COUNTRY"),
    F.trim(F.substring(F.col("HOME_ADDR_COUNTY").cast("string"), 1, 30)).alias("HOME_ADDR_COUNTY"),
    F.trim(F.substring(F.col("ETHN_GRP").cast("string"), 1, 8)).alias("ETHN_GRP"),
    F.trim(F.substring(F.col("MAJOR1_PLAN").cast("string"), 1, 10)).alias("MAJOR1_PLAN"),
    F.trim(F.substring(F.col("MAJOR1_CIP_CD").cast("string"), 1, 130)).alias("MAJOR1_CIP_CD"),
    F.trim(F.substring(F.col("MAJOR2_PLAN").cast("string"), 1, 10)).alias("MAJOR2_PLAN"),
    F.trim(F.substring(F.col("MAJOR2_CIP_CD").cast("string"), 1, 130)).alias("MAJOR2_CIP_CD"),
    F.trim(F.substring(F.col("MINOR1_PLAN").cast("string"), 1, 10)).alias("MINOR1_PLAN"),
    F.trim(F.substring(F.col("MINOR1_CIP_CD").cast("string"), 1, 130)).alias("MINOR1_CIP_CD"),
    F.trim(F.substring(F.col("COURSE_ID").cast("string"), 1, 20)).alias("COURSE_ID"),
    F.trim(F.substring(F.col("CATALOG_NBR").cast("string"), 1, 10)).alias("CATALOG_NBR"),
    F.trim(F.substring(F.col("SUBJECT").cast("string"), 1, 8)).alias("SUBJECT"),
    F.trim(F.substring(F.col("INSTRUCTION_MODE").cast("string"), 1, 2)).alias("INSTRUCTION_MODE"),
    F.col("CLASS_START_DT").cast("timestamp").alias("CLASS_START_DT"),
    F.col("CLASS_END_DT").cast("timestamp").alias("CLASS_END_DT"),
    F.trim(F.substring(F.col("CLASS_SECTION").cast("string"), 1, 4)).alias("CLASS_SECTION"),
    F.trim(F.substring(F.col("INSTRUCTION_MODE_DESCR").cast("string"), 1, 30)).alias("INSTRUCTION_MODE_DESCR"),
    F.col("ENRL_ADD_DT").cast("timestamp").alias("ENRL_ADD_DT"),
    F.trim(F.substring(F.col("SESSION_CD").cast("string"), 1, 20)).alias("SESSION_CD"),
    F.col("UNIT_TAKEN").cast("bigint").alias("UNIT_TAKEN"),
    F.trim(F.substring(F.col("ADMIT_TERM").cast("string"), 1, 4)).alias("ADMIT_TERM"),
    F.trim(F.substring(F.col("RESIDENCY").cast("string"), 1, 5)).alias("RESIDENCY"),
    F.trim(F.substring(F.col("IPEDS_FULL_PART_TIME_FLG").cast("string"), 1, 1)).alias("IPEDS_FULL_PART_TIME_FLG"),
    F.col("IPEDS_SCH").cast("bigint").alias("IPEDS_SCH"),
    F.trim(F.substring(F.col("IPEDS_DISTANCE_EDUCATION_STATUS").cast("string"), 1, 100)).alias("IPEDS_DISTANCE_EDU_STATUS"),
    F.col("IPEDS_FIPS_CD").cast("bigint").alias("IPEDS_FIPS_CD"),
    F.col("CLASS_NBR").cast("bigint").alias("CLASS_NBR"),
    F.trim(F.substring(F.col("INIT_TERM").cast("string"), 1, 8)).alias("INIT_TERM"),
    F.trim(F.substring(F.col("IPEDS_ETHNICITY").cast("string"), 1, 8)).alias("IPEDS_ETHNICITY"),
    F.trim(F.substring(F.col("TERM_DESCR").cast("string"), 1, 30)).alias("TERM_DESCR"),
    F.col("ACAD_YEAR").cast("bigint").alias("ACAD_YEAR"),
    F.trim(F.substring(F.col("CIP_CD_DESCR").cast("string"), 1, 254)).alias("CIP_CD_DESCR"),
    F.col("SNAPSHOT_DT").cast("timestamp").alias("SNAPSHOT_DT"),
    F.trim(F.substring(F.col("ACAD_PROGRAM_DESCR").cast("string"), 1, 30)).alias("ACAD_PROGRAM_DESCR"),
    F.trim(F.substring(F.col("ACAD_CAREER_DESCR").cast("string"), 1, 30)).alias("ACAD_CAREER_DESCR"),
    F.trim(F.substring(F.col("DEPT").cast("string"), 1, 10)).alias("DEPT"),
    F.trim(F.substring(F.col("COLLEGE").cast("string"), 1, 5)).alias("COLLEGE"),
    F.trim(F.substring(F.col("COLLEGE_DESCR").cast("string"), 1, 30)).alias("COLLEGE_DESCR"),
    F.trim(F.substring(F.col("DEPT_DESCR").cast("string"), 1, 30)).alias("DEPT_DESCR"),
    F.trim(F.substring(F.col("IPEDS_CITY").cast("string"), 1, 30)).alias("IPEDS_CITY"),
    F.trim(F.substring(F.col("IPEDS_COUNTY").cast("string"), 1, 30)).alias("IPEDS_COUNTY"),
    F.trim(F.substring(F.col("IPEDS_POSTAL").cast("string"), 1, 12)).alias("IPEDS_POSTAL"),
    F.trim(F.substring(F.col("STUDENTRETENTIONCATEGORY").cast("string"), 1, 20)).alias("STUDENTRETENTIONCATEGORY"),
    F.col("RETENTION_FLG").cast("bigint").alias("RETENTION_FLG"),
    F.when(
        (F.col("IPEDS_ADDR").isNull() | (F.trim(F.col("IPEDS_ADDR")) == F.lit(""))),
        F.lit(None),
    )
    .otherwise(F.trim(F.substring(F.col("IPEDS_ADDR").cast("string"), 1, 55)))
    .alias("IPEDS_ADDR"),
    F.trim(F.substring(F.col("IPEDS_COUNTRY").cast("string"), 1, 3)).alias("IPEDS_COUNTRY"),
    F.trim(F.substring(F.col("TUITION_RES").cast("string"), 1, 5)).alias("TUITION_RES"),
    F.trim(F.substring(F.col("IPEDS_ETHNICITY_DESCR").cast("string"), 1, 50)).alias("IPEDS_ETHNICITY_DESCR"),
    F.trim(F.substring(F.col("ETHN_GRP_DESCR").cast("string"), 1, 50)).alias("ETHN_GRP_DESCR"),
    F.trim(F.substring(F.col("TUITION_RESIDENCY_DESCR").cast("string"), 1, 30)).alias("TUITION_RESIDENCY_DESCR"),
    F.trim(F.substring(F.col("RESIDENCY_DESCR").cast("string"), 1, 30)).alias("RESIDENCY_DESCR"),
    (F.unix_timestamp(F.current_timestamp()).cast("double") + F.lit(315619200))
    .cast("timestamp")
    .alias("LOAD_DT"),
)

# COMMAND ----------

# Truncate and Append to a staging table 'fact_ipeds_fall_enrollment_work'

# Define the target staging table name and write the final DataFrame to it in overwrite mode.
_tgt_tbl = f"{analytics}.{staging}.fact_ipeds_fall_enrollment_work"
write_df_to_table(df_map_cols, _tgt_tbl, mode="overwrite", overwriteSchema="true")

log_msg(f"Data Appended to Target Table: {_tgt_tbl}")

# COMMAND ----------

# Cleanup: drops all intermediate staging checkpoint tables created during execution to free up storage.

for _tmp_tbl in (
    _tmp_stageX_tbl,
    _tmp_stageA_tbl,
    _tmp_stageB_tbl,
    _tmp_stageC_tbl,
    _tmp_stageD_tbl,
):
    try:
        drop_table(_tmp_tbl)
        log_msg(f"Dropped checkpoint temp table: {_tmp_tbl}")
    except Exception as _e:
        log_msg(f"WARN: could not drop {_tmp_tbl}: {_e}")

# COMMAND ----------

# Record the job end time, compute elapsed duration, and log the job completion message.
_job_end_time = datetime.now()
_job_elapsed = _job_end_time - _job_start_time
log_msg(
    f"Job completed: transform_analytics_fact_ipeds_fall_enrollment_work | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} | Elapsed: {str(_job_elapsed)}",
    "info",
)
