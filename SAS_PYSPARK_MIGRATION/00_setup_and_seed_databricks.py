# Databricks notebook source
# /// script
# [tool.databricks.environment]
# environment_version = "6"
# ///
# MAGIC %md
# MAGIC # 00 - Setup and Seed Databricks Tables (from SQLite POC)
# MAGIC
# MAGIC **Purpose**: Creates all 12 target tables defined in `DDL.txt` plus `mock_data` on Databricks Delta Lake, and seeds them with 3,200 records from `sqlite_data.db`.
# MAGIC
# MAGIC Supports both **Unity Catalog** (`analytics_dev.silver.fact_student_class`) and **Hive Metastore** (`silver.fact_student_class`).

# COMMAND ----------

import os
import sys
import random
from datetime import datetime, timedelta

# Cross-platform directory resolver: safe for Databricks notebooks and local Python
_f = globals().get("__file__")
_cur_dir = os.path.dirname(os.path.abspath(_f)) if _f else os.getcwd()
if _cur_dir not in sys.path:
    sys.path.insert(0, _cur_dir)

# Ensure spark session exists
try:
    spark
except NameError:
    from pyspark.sql import SparkSession
    spark = SparkSession.builder.appName("Databricks_Setup_Seed").getOrCreate()

# Robust logger function that writes to console and persists to migration_pipeline.log
_log_dir = "/tmp/sas_poc/logs" if os.path.exists("/tmp") else os.path.join(_cur_dir, "logs")
try:
    os.makedirs(_log_dir, exist_ok=True)
except Exception:
    pass
_log_file = os.path.join(_log_dir, "migration_pipeline.log")

def log_msg(msg: str, level: str = "info"):
    line = f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] [00_setup_and_seed] [{level.upper()}] : {msg}"
    print(line)
    try:
        with open(_log_file, "a", encoding="utf-8") as f:
            f.write(line + "\n")
            f.flush()
    except Exception:
        pass

log_msg("Starting Databricks Database Setup and Seeding...")

# COMMAND ----------

# DBTITLE 1,Step 1: Detect Environment and Create Schemas
# Detect if Delta Lake is available (native on Databricks, falls back to parquet locally)
# Note: spark._jvm is unavailable on Spark Connect (Standard/Serverless compute), where
# Delta is native, so only run the JVM lookup on classic Spark sessions.
table_format = "delta"
if "connect" not in type(spark).__module__.lower():
    try:
        spark._jvm.org.apache.spark.sql.execution.datasources.DataSource.lookupDataSource("delta", spark._jsparkSession.sessionState().conf())
    except Exception:
        log_msg("Delta Lake source not found in this environment; using 'parquet' for local simulation.", level="warn")
        table_format = "parquet"
else:
    log_msg("Spark Connect session detected: Delta is native on Databricks; table_format stays 'delta'.")

# Detect active catalog and database
current_cat = None
try:
    current_cat = spark.sql("SELECT current_catalog()").collect()[0][0]
except Exception:
    pass

current_db = "default"
try:
    current_db = spark.sql("SELECT current_database()").collect()[0][0]
except Exception:
    pass

log_msg(f"Active Catalog: '{current_cat}', Active Database: '{current_db}'")

# Detect if custom catalogs can be created (Unity Catalog admin privileges)
is_custom_catalog = False
try:
    spark.sql("CREATE CATALOG IF NOT EXISTS analytics_dev")
    spark.sql("CREATE SCHEMA IF NOT EXISTS analytics_dev.silver")
    spark.sql("CREATE SCHEMA IF NOT EXISTS analytics_dev.staging")
    spark.sql("CREATE SCHEMA IF NOT EXISTS analytics_dev.reference")
    spark.sql("CREATE CATALOG IF NOT EXISTS finance")
    spark.sql("CREATE SCHEMA IF NOT EXISTS finance.maco")
    is_custom_catalog = True
    log_msg("Unity Catalog with custom catalogs ('analytics_dev', 'finance') verified.")
except Exception as e:
    log_msg(f"Custom catalog creation not available ({e}). Checking local schemas...", level="info")

# Test if custom schemas can be created in current catalog
can_create_schemas = False
if not is_custom_catalog:
    schemas_to_test = ["silver", "staging", "reference", "maco"]
    created_count = 0
    for s in schemas_to_test:
        try:
            spark.sql(f"CREATE SCHEMA IF NOT EXISTS {s}")
            created_count += 1
        except Exception:
            pass
    if created_count == len(schemas_to_test):
        can_create_schemas = True
        log_msg("Schemas ('silver', 'staging', 'reference', 'maco') created successfully.")
    else:
        log_msg(f"Schema creation restricted. Tables will be safely created in active schema '{current_db}'.", level="warn")

# Resolve target schema names
if is_custom_catalog:
    analytics_silver = "analytics_dev.silver"
    analytics_staging = "analytics_dev.staging"
    analytics_reference = "analytics_dev.reference"
    finance_maco = "finance.maco"
elif can_create_schemas:
    analytics_silver = "silver"
    analytics_staging = "staging"
    analytics_reference = "reference"
    finance_maco = "maco"
else:
    analytics_silver = current_db
    analytics_staging = current_db
    analytics_reference = current_db
    finance_maco = current_db

# Schema mapping dictionary
TABLE_SCHEMA_MAP = {
    "fact_student_class": analytics_silver,
    "dim_admissions_funnel_weekly": analytics_staging,
    "dim_uta_holiday_schedule": analytics_reference,
    "fact_mav_express_transactions": analytics_silver,
    "fact_thecb_cbm002_work": analytics_staging,
    "fact_thecb_cbm002_census": analytics_staging,
    "fact_thecb_cbm008_work": analytics_staging,
    "fact_thecb_cbm0e1_enrollment_work": analytics_staging,
    "fact_thecb_cbm00s_sch_work": analytics_staging,
    "fact_ipeds_twelve_month_enrollment_work": analytics_staging,
    "fact_ipeds_fall_enrollment_work": analytics_staging,
    "specbase_dly": finance_maco,
    "mock_data": current_db,
}

# COMMAND ----------

# DBTITLE 1,Step 2: Apply DDL for All Tables
TABLES_DDL = {
    "fact_student_class": """
    CREATE TABLE IF NOT EXISTS {analytics_silver}.fact_student_class (
      academicyear STRING,
      termtype STRING,
      termsourcekey STRING,
      termdescription STRING,
      sessioncode STRING,
      academiccareer STRING,
      academicprogramsourcekey STRING,
      academicprogramdescription STRING,
      employeeid STRING,
      studentcareernumber INT,
      campussourcekey STRING,
      classnumber INT,
      courseid STRING,
      courseofferingnumber INT,
      coursecollegecode STRING,
      coursecollege STRING,
      coursedepartmentcode STRING,
      coursedepartment STRING,
      studentcollegecode STRING,
      studentcollegedescription STRING,
      studentdepartmentcode STRING,
      studentdepartmentdescription STRING,
      plansourcekey STRING,
      plandescription STRING,
      studentacademicplan STRING,
      tuitionresidencydescription STRING,
      overallresidencydescription STRING,
      coursecareer STRING,
      coursesubject STRING,
      catalognumber STRING,
      sectionnumber STRING,
      courseinstructionmodesourcekey STRING,
      courseinstructionmodedescr STRING,
      apsectioninfo STRING,
      coursecomponent STRING,
      coursedescription STRING,
      currentcoursedescription STRING,
      coursecipcode STRING,
      courserepeatableforcredit STRING,
      classlocationsourcekey STRING,
      classlocationdescription STRING,
      enrollmentadddate DATE,
      classstartdate DATE,
      classenddate DATE,
      gradingbasis STRING,
      coursegrade STRING,
      failurereason STRING,
      coursehours INT,
      coursegradepoints INT,
      courserepeatcode STRING,
      courseunitsattempted INT,
      courseunitscompleted INT,
      termsch INT,
      termschnowithdrawals INT,
      censusdatesch INT,
      termgpaattemptedsch INT,
      termnongpaattemptedsch INT,
      termgpacompletedsch INT,
      termnongpacompletedsch INT,
      termattemptedsch INT,
      termcompletedsch INT,
      termgradepoints INT,
      hsdualcreditunitstransferred INT,
      inresidencehsdualcredit INT,
      totalgpaunitsattempted INT,
      totalnongpaunitsattempted INT,
      totalgpaunitscompleted INT,
      totalnongpaunitscompleted INT,
      totalattemptedsch INT,
      totalcompletedsch INT,
      totalgradepoints INT,
      totaltransfercredit DECIMAL(38,3),
      totaltestcredit INT,
      totalothercredit INT,
      totalcumulativecredit DECIMAL(38,3),
      termgpa DECIMAL(6,3),
      cumulativegpa DECIMAL(6,3),
      gradepointdeficit INT,
      academicloaddescription STRING,
      academiclevelsourcekey STRING,
      academicleveldescription STRING,
      academicstandingsourcekey STRING,
      academicstandingdescription STRING,
      studentinstructionmodedescr STRING,
      censusdateenrollcategorydescr STRING,
      firsttermofenrollmentsourcekey STRING,
      firsttermofenrollmentdescr STRING,
      expectedgradtermsourcekey STRING,
      expectedgradtermdescr STRING,
      priortermofenrollmentsourcekey STRING,
      priortermofenrollmentdescr STRING,
      stureportingretentionclassif STRING,
      studentreportingclassifdescr STRING,
      transferstudentflag STRING,
      admittermsourcekey STRING,
      admittermdescription STRING,
      admittypesourcekey STRING,
      admittypedescription STRING,
      applicationnumber INT,
      lastschoolattendedorgid STRING,
      lastschoolattendedorgdescr STRING,
      dualcreditflag STRING
    ) USING {table_format}
    """,
    "dim_admissions_funnel_weekly": """
    CREATE TABLE IF NOT EXISTS {analytics_staging}.dim_admissions_funnel_weekly (
      cycletermsourcekey STRING,
      cycletermdescription STRING,
      calendaryear STRING,
      censustermsourcekey STRING,
      censustermdescription STRING,
      censustermcensusdate TIMESTAMP,
      termsourcekey1 STRING,
      termdescription1 STRING,
      termsourcekey2 STRING,
      termdescription2 STRING,
      termsourcekey3 STRING,
      termdescription3 STRING,
      cyclestartdate TIMESTAMP,
      cycleenddate TIMESTAMP,
      weeknumber BIGINT,
      snapshotdate TIMESTAMP,
      snapshotdayofweek STRING,
      daynumber BIGINT
    ) USING {table_format}
    """,
    "dim_uta_holiday_schedule": """
    CREATE TABLE IF NOT EXISTS {analytics_reference}.dim_uta_holiday_schedule (
      AcademicYear VARCHAR(9),
      Terms VARCHAR(14),
      HOLIDAY TIMESTAMP,
      HOLIDAYDESCRIPTION VARCHAR(30)
    ) USING {table_format}
    """,
    "fact_mav_express_transactions": """
    CREATE TABLE IF NOT EXISTS {analytics_silver}.fact_mav_express_transactions (
      trandate TIMESTAMP,
      locationsourcekey DECIMAL(11,0),
      locationdescription STRING,
      locationshortdescr STRING,
      patronid DECIMAL(11,0),
      employeeid STRING,
      transidseq_generation DECIMAL(11,0),
      transid DECIMAL(11,0),
      accounttype DECIMAL(11,0),
      apprvalueoftran BIGINT,
      completionstatus STRING,
      reasonmsg STRING,
      reasontype DECIMAL(11,0),
      transtype DECIMAL(11,0),
      currentprimarykey STRING,
      postdate TIMESTAMP
    ) USING {table_format}
    """,
    "fact_thecb_cbm002_work": """
    CREATE TABLE IF NOT EXISTS {analytics_staging}.fact_thecb_cbm002_work (
      RecordCode STRING,
      ReportingTerm STRING,
      FiceCode STRING,
      National_Id STRING,
      EMPLID STRING,
      Semester STRING,
      Year STRING,
      Ferpa STRING,
      Gender STRING,
      BirthDate STRING,
      TSIWaiverExemption STRING,
      Ethnic_Origin STRING,
      White STRING,
      Black STRING,
      Asian STRING,
      AmericanIndAlsknNatv STRING,
      International STRING,
      UnknownNotReported STRING,
      NativeHawnOthPacificIslander STRING,
      Flex STRING,
      TSIMathExemptedByCensus STRING,
      TSIMathWaiverExempted STRING,
      MathScore_ACT_SAT STRING,
      MathCompScore_ACT_SAT STRING,
      MathScore_TAKS STRING,
      TSIMathAtPlacement STRING,
      TSIMathAssesmentScore STRING,
      AlternateMathMethod STRING,
      MathTSIEndOfReportPeriod STRING,
      MathFirstLevelCollegeCourse STRING,
      TSIReadExemptedByCensus STRING,
      TSIReadWaiverExempted STRING,
      ReadScore_ACT_SAT STRING,
      ReadCompScore_ACT_SAT STRING,
      ReadScore_TAKS STRING,
      TSIReadAtPlacement STRING,
      TSIReadAssesmentScore STRING,
      AlternateReadMethod STRING,
      ReadTSIEndOfReportPeriod STRING,
      ReadFirstLevelCollegeCourse STRING,
      TSIWriteExemptedByCensus STRING,
      TSIWriteWaiverExempted STRING,
      WriteScore_ACT_SAT STRING,
      WriteCompScore_ACT_SAT STRING,
      WriteScore_TAKS STRING,
      TSIWriteAtPlacement STRING,
      TSIWriteAssesmentScore STRING,
      WriteEssayScore STRING,
      AlternateWriteMethod STRING,
      WriteTSIEndOfReportPeriod STRING,
      WriteFirstLevelCollegeCourse STRING,
      MathTSIABEDiagnosticScore STRING,
      ReadTSIABEDiagnosticScore STRING,
      WriteTSIABEDiagnosticScore STRING,
      AcademicPlan STRING,
      AdmitTerm STRING,
      AcademicLevelBOT STRING,
      AcademicProgram STRING,
      TotalCumulativeHours DECIMAL(10,3),
      EAPStudent STRING
    ) USING {table_format}
    """,
    "fact_thecb_cbm002_census": """
    CREATE TABLE IF NOT EXISTS {analytics_staging}.fact_thecb_cbm002_census (
      RecordCode STRING,
      ReportingTerm STRING,
      FiceCode STRING,
      National_Id STRING,
      EMPLID STRING,
      Semester STRING,
      Year STRING,
      Ferpa STRING,
      Gender STRING,
      BirthDate STRING,
      TSIWaiverExemption STRING,
      Ethnic_Origin STRING,
      White STRING,
      Black STRING,
      Asian STRING,
      AmericanIndAlsknNatv STRING,
      International STRING,
      UnknownNotReported STRING,
      NativeHawnOthPacificIslander STRING,
      Flex STRING,
      TSIMathExemptedByCensus STRING,
      TSIMathWaiverExempted STRING,
      MathScore_ACT_SAT STRING,
      MathCompScore_ACT_SAT STRING,
      MathScore_TAKS STRING,
      TSIMathAtPlacement STRING,
      TSIMathAssesmentScore STRING,
      AlternateMathMethod STRING,
      MathTSIEndOfReportPeriod STRING,
      MathFirstLevelCollegeCourse STRING,
      TSIReadExemptedByCensus STRING,
      TSIReadWaiverExempted STRING,
      ReadScore_ACT_SAT STRING,
      ReadCompScore_ACT_SAT STRING,
      ReadScore_TAKS STRING,
      TSIReadAtPlacement STRING,
      TSIReadAssesmentScore STRING,
      AlternateReadMethod STRING,
      ReadTSIEndOfReportPeriod STRING,
      ReadFirstLevelCollegeCourse STRING,
      TSIWriteExemptedByCensus STRING,
      TSIWriteWaiverExempted STRING,
      WriteScore_ACT_SAT STRING,
      WriteCompScore_ACT_SAT STRING,
      WriteScore_TAKS STRING,
      TSIWriteAtPlacement STRING,
      TSIWriteAssesmentScore STRING,
      WriteEssayScore STRING,
      AlternateWriteMethod STRING,
      WriteTSIEndOfReportPeriod STRING,
      WriteFirstLevelCollegeCourse STRING,
      MathTSIABEDiagnosticScore STRING,
      ReadTSIABEDiagnosticScore STRING,
      WriteTSIABEDiagnosticScore STRING,
      AcademicPlan STRING,
      AdmitTerm STRING,
      AcademicLevelBOT STRING,
      AcademicProgram STRING,
      TotalCumulativeHours DECIMAL(10,3),
      EAPStudent STRING
    ) USING {table_format}
    """,
    "fact_thecb_cbm008_work": """
    CREATE TABLE IF NOT EXISTS {analytics_staging}.fact_thecb_cbm008_work (
      RECORD_CODE STRING,
      INSTITUTION_CODE STRING,
      National_ID STRING,
      LAST_NAME STRING,
      FIRST_NAME STRING,
      MIDDLE_INITIAL STRING,
      RANK STRING,
      TENURE STRING,
      GENDER STRING,
      ADMINISTRATIVE_UNIT_CODE STRING,
      UNUSED STRING,
      DATE_OF_BIRTH STRING,
      PERCENT_APPOINMENT_01 STRING,
      PERCENT_APPOINMENT_02 STRING,
      PERCENT_APPOINMENT_11 STRING,
      PERCENT_APPOINMENT_12 STRING,
      PERCENT_APPOINMENT_13 STRING,
      SALARY_STATE STRING,
      SALARY_DESIGNATED STRING,
      SALARY_RESTRICTED STRING,
      SALARY_AUX STRING,
      SALARY_OVERLOAD STRING,
      FE_APPOINTMENT STRING,
      FE_SALARY STRING,
      FLEX_ENTRY STRING,
      COMPLIANCE STRING,
      NEW_HIRE STRING,
      SEMESTER STRING,
      YEAR STRING,
      ETHINIC_ORIGIN STRING,
      RACE_WHITE STRING,
      RACE_AFRICAN_AMERICAN STRING,
      RACE_ASIAN STRING,
      RACE_AMERICAN_INDIAN STRING,
      RACE_INTERNATIONAL STRING,
      RACE_UNKOWN STRING,
      RACE_HAWAIIN_PACIFIC_ISLANDER STRING,
      SUBJECT_PREFIX STRING,
      COURSE_NUMBER STRING,
      SECTION_NBR STRING,
      TEACHING_LOAD_CREDIT STRING,
      COMPOSITE_CLASSES STRING,
      RESPONSIBILITY_FACTOR STRING,
      EMPLID STRING,
      GRA_FLAG STRING,
      STRM STRING,
      AGE BIGINT,
      BIRTH_YEAR STRING,
      BIRTH_MONTH STRING,
      TEACHING_FTE DECIMAL(38,2),
      TOTAL_FTE DECIMAL(38,2),
      COLLEGE STRING,
      DEPT STRING,
      COLLEGE_DESCR STRING,
      DEPT_DESCR STRING,
      TENURE_DESCR STRING,
      UTA_TERM STRING,
      FULL_TIME_FLG STRING,
      ETHNIC_DESCR STRING,
      RANK_DESCR STRING
    ) USING {table_format}
    """,
    "fact_thecb_cbm0e1_enrollment_work": """
    CREATE TABLE IF NOT EXISTS {analytics_staging}.fact_thecb_cbm0e1_enrollment_work (
      RECCODE STRING,
      FICE STRING,
      EMPLID STRING,
      GENDER STRING,
      CLASS STRING,
      DOB STRING,
      TUITRES STRING,
      RESID STRING,
      TRANCOL STRING,
      SCHON BIGINT,
      SCHOFF BIGINT,
      DOCFUND BIGINT,
      SEMESTER STRING,
      YEAR STRING,
      INTERSCH STRING,
      FLEX STRING,
      REMOTE BIGINT,
      CIP STRING,
      DOCFNCD STRING,
      TUITEXT STRING,
      SCHCNSF BIGINT,
      SCHDNSF BIGINT,
      SCHINSF STRING,
      SCHCSF BIGINT,
      SCHDSF BIGINT,
      UGDEGR BIGINT,
      UGLIMIT STRING,
      LAST STRING,
      FIRST STRING,
      MINIT STRING,
      SCHDC BIGINT,
      TEACHED STRING,
      NDS STRING,
      ND STRING,
      GR_SCH DECIMAL(9,0),
      HS_CODE STRING,
      PEIMS_ID STRING,
      ETHNIC STRING,
      RACE_WHITE STRING,
      RACE_BLACK STRING,
      RACE_ASIAN STRING,
      RACE_NATIVE_AMERICAN STRING,
      RACE_INTERNATIONAL STRING,
      RACE_UNKNOWN STRING,
      RACE_NATIVE_HAWAIIAN STRING,
      STRM STRING,
      SIN STRING,
      ACAD_PLAN STRING,
      ACAD_SUB_PLAN STRING,
      IDD STRING,
      IDD_PROG STRING,
      CB_REPORTED STRING
    ) USING {table_format}
    """,
    "fact_thecb_cbm00s_sch_work": """
    CREATE TABLE IF NOT EXISTS {analytics_staging}.fact_thecb_cbm00s_sch_work (
      STRM STRING,
      TermDescription STRING,
      SUBJECT STRING,
      CATALOG_NBR STRING,
      CLASS_NBR STRING,
      ACAD_GROUP STRING,
      COLLEGE_DESCR STRING,
      ACAD_ORG STRING,
      DEPT_DESCR STRING,
      Instruction_Type STRING,
      CORE_COURSE STRING,
      AP_Course STRING,
      DLRN_Course STRING,
      Flex_entry STRING,
      CIP_OR_FUND_CODE STRING,
      COURSE_SCH STRING,
      COURSE_LEVEL STRING,
      FUND_YEAR STRING,
      CB_Reported_Course STRING,
      CB_Reported_Student STRING,
      FORMULA_CODE DECIMAL(4,0),
      UNFUNDED_SCH_TOTAL BIGINT,
      LOWER_LEVEL_EXCEED_STATE BIGINT,
      LOWER_LEVEL_EXCEED_DEVELOP BIGINT,
      NOT_STATE_FUNDED_LOWER BIGINT,
      NOT_STATE_FUNDED_UPPER BIGINT,
      LOWER_LEVEL_UNFUNDED_TOTAL BIGINT,
      LOWER_LEVEL_FUNDED BIGINT,
      LOWER_LEVEL_TOTAL BIGINT,
      UPPER_LEVEL_EXCEED_STATE BIGINT,
      UPPER_LEVEL_EXCEED_DEVELOP BIGINT,
      UPPER_LEVEL_UNFUNDED_TOTAL BIGINT,
      UPPER_LEVEL_FUNDED BIGINT,
      UPPER_LEVEL_TOTAL BIGINT,
      MASTER_LEVEL_UNFUNDED BIGINT,
      MASTER_LEVEL_FUNDED BIGINT,
      MASTER_LEVEL_TOTAL BIGINT,
      DOCTORAL_LEVEL_UNFUNDED BIGINT,
      DOCTORAL_LEVEL_FUNDED BIGINT,
      DOCTORAL_LEVEL_TOTAL BIGINT,
      Total_SCH BIGINT,
      Student_Count BIGINT,
      UGRD_HRS BIGINT,
      CENSUS_DT DATE,
      UGRD_LOWER_FTSE DECIMAL(38,10),
      UGRD_UPPER_FTSE DECIMAL(38,10),
      UGRD_FTSE DECIMAL(38,10),
      DOCTORAL_FTSE DECIMAL(38,10),
      MASTER_FTSE DECIMAL(38,10),
      STATE_FUNDED_FTSE DECIMAL(38,10),
      UNFUNDED_FTSE DECIMAL(38,10),
      TOTAL_FTSE DECIMAL(38,10),
      UGRD_LOWER_DIV_WT_HRS DECIMAL(38,2),
      UGRD_UPPER_DIV_WT_HRS DECIMAL(38,2),
      UGRD_WT_HRS DECIMAL(38,2),
      MASTER_WT_HRS DECIMAL(38,2),
      DOCTORAL_WT_HRS DECIMAL(38,2),
      STATE_FUNDED_WT_HRS DECIMAL(38,2)
    ) USING {table_format}
    """,
    "fact_ipeds_twelve_month_enrollment_work": """
    CREATE TABLE IF NOT EXISTS {analytics_staging}.fact_ipeds_twelve_month_enrollment_work (
      MIN_ONE_ONLINE_COURSE_FLG STRING,
      EMPLID STRING,
      ENROLLED_WITHIN_12_MONTHS DECIMAL(38,10),
      AGE_GROUP STRING,
      IPEDS_STATE STRING,
      ACAD_CAREER STRING,
      ACAD_PROGRAM STRING,
      MAJOR1_DEPT STRING,
      MAJOR2_DEPT STRING,
      MINOR1_DEPT STRING,
      STRM STRING,
      ACAD_LEVEL_EOT_CD STRING,
      ACAD_LEVEL_EOT_DESCR STRING,
      FIRST_NAME STRING,
      LAST_NAME STRING,
      MIDDLE_NAME STRING,
      BIRTH_DT TIMESTAMP,
      AGE DECIMAL(38,10),
      COHORT_TYPE STRING,
      GENDER STRING,
      HOME_ADDR STRING,
      HOME_ADDR_CITY STRING,
      HOME_ADDR_STATE STRING,
      HOME_ADDR_POSTAL STRING,
      HOME_ADDR_COUNTRY STRING,
      HOME_ADDR_COUNTY STRING,
      ETHN_GRP STRING,
      MAJOR1_PLAN STRING,
      MAJOR1_CIP_CD STRING,
      MAJOR2_PLAN STRING,
      MAJOR2_CIP_CD STRING,
      MINOR1_PLAN STRING,
      MINOR1_CIP_CD STRING,
      COURSE_ID STRING,
      CATALOG_NBR STRING,
      SUBJECT STRING,
      INSTRUCTION_MODE STRING,
      CLASS_START_DT TIMESTAMP,
      CLASS_END_DT TIMESTAMP,
      CLASS_SECTION STRING,
      INSTRUCTION_MODE_DESCR STRING,
      ENRL_ADD_DT TIMESTAMP,
      SESSION_CD STRING,
      UNIT_TAKEN DECIMAL(38,10),
      ADMIT_TERM STRING,
      RESIDENCY STRING,
      IPEDS_FULL_PART_TIME_FLG STRING,
      IPEDS_SCH DECIMAL(38,10),
      IPEDS_DISTANCE_EDU_STATUS STRING,
      IPEDS_FIPS_CD DECIMAL(38,10),
      CLASS_NBR DECIMAL(38,10),
      INIT_TERM STRING,
      IPEDS_ETHNICITY STRING,
      TERM_DESCR STRING,
      ACAD_YEAR DECIMAL(38,10),
      CIP_CD_DESCR STRING,
      SNAPSHOT_DT TIMESTAMP,
      ACAD_PROGRAM_DESCR STRING,
      ACAD_CAREER_DESCR STRING,
      DEPT STRING,
      COLLEGE STRING,
      COLLEGE_DESCR STRING,
      DEPT_DESCR STRING,
      TUITION_RESIDENCY_DESCR STRING,
      IPEDS_CITY STRING,
      IPEDS_COUNTY STRING,
      IPEDS_POSTAL STRING,
      STUDENTRETENTIONCATEGORY STRING,
      RETENTION_FLG DECIMAL(38,10),
      IPEDS_ADDR STRING,
      IPEDS_COUNTRY STRING,
      TUITION_RES STRING,
      IPEDS_ETHNICITY_DESCR STRING,
      ETHN_GRP_DESCR STRING,
      ZERO_CREDIT_FLG DECIMAL(38,10),
      RESIDENCY_DESCR STRING,
      DateLoaded TIMESTAMP,
      Reporting_Year STRING
    ) USING {table_format}
    """,
    "fact_ipeds_fall_enrollment_work": """
    CREATE TABLE IF NOT EXISTS {analytics_staging}.fact_ipeds_fall_enrollment_work (
      MIN_ONE_ONLINE_COURSE_FLG STRING,
      EMPLID STRING,
      ENROLLED_WITHIN_12_MONTHS BIGINT,
      AGE_GROUP STRING,
      IPEDS_STATE STRING,
      ACAD_CAREER STRING,
      ACAD_PROGRAM STRING,
      MAJOR1_DEPT STRING,
      MAJOR2_DEPT STRING,
      MINOR1_DEPT STRING,
      STRM STRING,
      ACAD_LEVEL_EOT_CD STRING,
      ACAD_LEVEL_EOT_DESCR STRING,
      FIRST_NAME STRING,
      LAST_NAME STRING,
      MIDDLE_NAME STRING,
      BIRTH_DT TIMESTAMP,
      AGE BIGINT,
      COHORT_TYPE STRING,
      GENDER STRING,
      HOME_ADDR STRING,
      HOME_ADDR_CITY STRING,
      HOME_ADDR_STATE STRING,
      HOME_ADDR_POSTAL STRING,
      HOME_ADDR_COUNTRY STRING,
      HOME_ADDR_COUNTY STRING,
      ETHN_GRP STRING,
      MAJOR1_PLAN STRING,
      MAJOR1_CIP_CD STRING,
      MAJOR2_PLAN STRING,
      MAJOR2_CIP_CD STRING,
      MINOR1_PLAN STRING,
      MINOR1_CIP_CD STRING,
      COURSE_ID STRING,
      CATALOG_NBR STRING,
      SUBJECT STRING,
      INSTRUCTION_MODE STRING,
      CLASS_START_DT TIMESTAMP,
      CLASS_END_DT TIMESTAMP,
      CLASS_SECTION STRING,
      INSTRUCTION_MODE_DESCR STRING,
      ENRL_ADD_DT TIMESTAMP,
      SESSION_CD STRING,
      UNIT_TAKEN BIGINT,
      ADMIT_TERM STRING,
      RESIDENCY STRING,
      IPEDS_FULL_PART_TIME_FLG STRING,
      IPEDS_SCH BIGINT,
      IPEDS_DISTANCE_EDU_STATUS STRING,
      IPEDS_FIPS_CD BIGINT,
      CLASS_NBR BIGINT,
      INIT_TERM STRING,
      IPEDS_ETHNICITY STRING,
      TERM_DESCR STRING,
      ACAD_YEAR BIGINT,
      CIP_CD_DESCR STRING,
      SNAPSHOT_DT TIMESTAMP,
      ACAD_PROGRAM_DESCR STRING,
      ACAD_CAREER_DESCR STRING,
      DEPT STRING,
      COLLEGE STRING,
      COLLEGE_DESCR STRING,
      DEPT_DESCR STRING,
      IPEDS_CITY STRING,
      IPEDS_COUNTY STRING,
      IPEDS_POSTAL STRING,
      STUDENTRETENTIONCATEGORY STRING,
      RETENTION_FLG BIGINT,
      IPEDS_ADDR STRING,
      IPEDS_COUNTRY STRING,
      TUITION_RES STRING,
      IPEDS_ETHNICITY_DESCR STRING,
      ETHN_GRP_DESCR STRING,
      TUITION_RESIDENCY_DESCR STRING,
      RESIDENCY_DESCR STRING,
      LOAD_DT TIMESTAMP
    ) USING {table_format}
    """,
    "specbase_dly": """
    CREATE TABLE IF NOT EXISTS {finance_maco}.specbase_dly (
      wslr_nbr STRING,
      brnd_cd STRING,
      mkt_ln_cd STRING,
      alw_typ_flg STRING,
      act_alw_dol_amt_1 DECIMAL(38,10),
      act_alw_dol_amt_2 DECIMAL(38,10),
      act_alw_dol_amt_3 DECIMAL(38,10),
      act_alw_dol_amt_4 DECIMAL(38,10),
      act_alw_dol_amt_5 DECIMAL(38,10),
      act_alw_dol_amt_6 DECIMAL(38,10),
      act_alw_dol_amt_7 DECIMAL(38,10),
      act_alw_dol_amt_8 DECIMAL(38,10),
      act_alw_dol_amt_9 DECIMAL(38,10),
      act_alw_dol_amt_10 DECIMAL(38,10),
      act_alw_dol_amt_11 DECIMAL(38,10),
      act_alw_dol_amt_12 DECIMAL(38,10),
      act_grss_prmtd_vol_1 DECIMAL(38,10),
      act_grss_prmtd_vol_2 DECIMAL(38,10),
      act_grss_prmtd_vol_3 DECIMAL(38,10),
      act_grss_prmtd_vol_4 DECIMAL(38,10),
      act_grss_prmtd_vol_5 DECIMAL(38,10),
      act_grss_prmtd_vol_6 DECIMAL(38,10),
      act_grss_prmtd_vol_7 DECIMAL(38,10),
      act_grss_prmtd_vol_8 DECIMAL(38,10),
      act_grss_prmtd_vol_9 DECIMAL(38,10),
      act_grss_prmtd_vol_10 DECIMAL(38,10),
      act_grss_prmtd_vol_11 DECIMAL(38,10),
      act_grss_prmtd_vol_12 DECIMAL(38,10),
      pye_alw_dol_amt_1 DECIMAL(38,10),
      pye_alw_dol_amt_2 DECIMAL(38,10),
      pye_alw_dol_amt_3 DECIMAL(38,10),
      pye_alw_dol_amt_4 DECIMAL(38,10),
      pye_alw_dol_amt_5 DECIMAL(38,10),
      pye_alw_dol_amt_6 DECIMAL(38,10),
      pye_alw_dol_amt_7 DECIMAL(38,10),
      pye_alw_dol_amt_8 DECIMAL(38,10),
      pye_alw_dol_amt_9 DECIMAL(38,10),
      pye_alw_dol_amt_10 DECIMAL(38,10),
      pye_alw_dol_amt_11 DECIMAL(38,10),
      pye_alw_dol_amt_12 DECIMAL(38,10),
      pye_grss_prmtd_vol_1 DECIMAL(38,10),
      pye_grss_prmtd_vol_2 DECIMAL(38,10),
      pye_grss_prmtd_vol_3 DECIMAL(38,10),
      pye_grss_prmtd_vol_4 DECIMAL(38,10),
      pye_grss_prmtd_vol_5 DECIMAL(38,10),
      pye_grss_prmtd_vol_6 DECIMAL(38,10),
      pye_grss_prmtd_vol_7 DECIMAL(38,10),
      pye_grss_prmtd_vol_8 DECIMAL(38,10),
      pye_grss_prmtd_vol_9 DECIMAL(38,10),
      pye_grss_prmtd_vol_10 DECIMAL(38,10),
      pye_grss_prmtd_vol_11 DECIMAL(38,10),
      pye_grss_prmtd_vol_12 DECIMAL(38,10),
      max_dol_offered_1 DECIMAL(38,10),
      max_dol_offered_2 DECIMAL(38,10),
      max_dol_offered_3 DECIMAL(38,10),
      max_dol_offered_4 DECIMAL(38,10),
      max_dol_offered_5 DECIMAL(38,10),
      max_dol_offered_6 DECIMAL(38,10),
      max_dol_offered_7 DECIMAL(38,10),
      max_dol_offered_8 DECIMAL(38,10),
      max_dol_offered_9 DECIMAL(38,10),
      max_dol_offered_10 DECIMAL(38,10),
      max_dol_offered_11 DECIMAL(38,10),
      max_dol_offered_12 DECIMAL(38,10),
      nbr_promo_days_1 DECIMAL(10,4),
      nbr_promo_days_2 DECIMAL(10,4),
      nbr_promo_days_3 DECIMAL(10,4),
      nbr_promo_days_4 DECIMAL(10,4),
      nbr_promo_days_5 DECIMAL(10,4),
      nbr_promo_days_6 DECIMAL(10,4),
      nbr_promo_days_7 DECIMAL(10,4),
      nbr_promo_days_8 DECIMAL(10,4),
      nbr_promo_days_9 DECIMAL(10,4),
      nbr_promo_days_10 DECIMAL(10,4),
      nbr_promo_days_11 DECIMAL(10,4),
      nbr_promo_days_12 DECIMAL(10,4),
      nbr_promos_offered_1 BIGINT,
      nbr_promos_offered_2 BIGINT,
      nbr_promos_offered_3 BIGINT,
      nbr_promos_offered_4 BIGINT,
      nbr_promos_offered_5 BIGINT,
      nbr_promos_offered_6 BIGINT,
      nbr_promos_offered_7 BIGINT,
      nbr_promos_offered_8 BIGINT,
      nbr_promos_offered_9 BIGINT,
      nbr_promos_offered_10 BIGINT,
      nbr_promos_offered_11 BIGINT,
      nbr_promos_offered_12 BIGINT,
      nbr_promos_paid_1 BIGINT,
      nbr_promos_paid_2 BIGINT,
      nbr_promos_paid_3 BIGINT,
      nbr_promos_paid_4 BIGINT,
      nbr_promos_paid_5 BIGINT,
      nbr_promos_paid_6 BIGINT,
      nbr_promos_paid_7 BIGINT,
      nbr_promos_paid_8 BIGINT,
      nbr_promos_paid_9 BIGINT,
      nbr_promos_paid_10 BIGINT,
      nbr_promos_paid_11 BIGINT,
      nbr_promos_paid_12 BIGINT,
      aap_paid_amt_1 DECIMAL(38,10),
      aap_paid_amt_2 DECIMAL(38,10),
      aap_paid_amt_3 DECIMAL(38,10),
      aap_paid_amt_4 DECIMAL(38,10),
      aap_paid_amt_5 DECIMAL(38,10),
      aap_paid_amt_6 DECIMAL(38,10),
      aap_paid_amt_7 DECIMAL(38,10),
      aap_paid_amt_8 DECIMAL(38,10),
      aap_paid_amt_9 DECIMAL(38,10),
      aap_paid_amt_10 DECIMAL(38,10),
      aap_paid_amt_11 DECIMAL(38,10),
      aap_paid_amt_12 DECIMAL(38,10),
      aap_grss_prmtd_vol_1 DECIMAL(38,10),
      aap_grss_prmtd_vol_2 DECIMAL(38,10),
      aap_grss_prmtd_vol_3 DECIMAL(38,10),
      aap_grss_prmtd_vol_4 DECIMAL(38,10),
      aap_grss_prmtd_vol_5 DECIMAL(38,10),
      aap_grss_prmtd_vol_6 DECIMAL(38,10),
      aap_grss_prmtd_vol_7 DECIMAL(38,10),
      aap_grss_prmtd_vol_8 DECIMAL(38,10),
      aap_grss_prmtd_vol_9 DECIMAL(38,10),
      aap_grss_prmtd_vol_10 DECIMAL(38,10),
      aap_grss_prmtd_vol_11 DECIMAL(38,10),
      aap_grss_prmtd_vol_12 DECIMAL(38,10),
      dscnt_dol_amt_utilized_1 DECIMAL(38,10),
      dscnt_dol_amt_utilized_2 DECIMAL(38,10),
      dscnt_dol_amt_utilized_3 DECIMAL(38,10),
      dscnt_dol_amt_utilized_4 DECIMAL(38,10),
      dscnt_dol_amt_utilized_5 DECIMAL(38,10),
      dscnt_dol_amt_utilized_6 DECIMAL(38,10),
      dscnt_dol_amt_utilized_7 DECIMAL(38,10),
      dscnt_dol_amt_utilized_8 DECIMAL(38,10),
      dscnt_dol_amt_utilized_9 DECIMAL(38,10),
      dscnt_dol_amt_utilized_10 DECIMAL(38,10),
      dscnt_dol_amt_utilized_11 DECIMAL(38,10),
      dscnt_dol_amt_utilized_12 DECIMAL(38,10),
      dscnt_max_amt_1 DECIMAL(38,10),
      dscnt_max_amt_2 DECIMAL(38,10),
      dscnt_max_amt_3 DECIMAL(38,10),
      dscnt_max_amt_4 DECIMAL(38,10),
      dscnt_max_amt_5 DECIMAL(38,10),
      dscnt_max_amt_6 DECIMAL(38,10),
      dscnt_max_amt_7 DECIMAL(38,10),
      dscnt_max_amt_8 DECIMAL(38,10),
      dscnt_max_amt_9 DECIMAL(38,10),
      dscnt_max_amt_10 DECIMAL(38,10),
      dscnt_max_amt_11 DECIMAL(38,10),
      dscnt_max_amt_12 DECIMAL(38,10),
      snap_yr INT,
      bgt_le_dly_flg STRING,
      __created_tsp TIMESTAMP
    ) USING {table_format}
    """,
    "mock_data": """
    CREATE TABLE IF NOT EXISTS mock_data (
      id INT,
      first_name STRING,
      last_name STRING,
      email STRING,
      gender STRING,
      ip_address STRING,
      source_file STRING
    ) USING {table_format}
    """
}

for t_name, ddl in TABLES_DDL.items():
    formatted_ddl = ddl.format(
        analytics_silver=analytics_silver,
        analytics_staging=analytics_staging,
        analytics_reference=analytics_reference,
        finance_maco=finance_maco,
        table_format=table_format
    )
    try:
        spark.sql(formatted_ddl)
        log_msg(f"DDL applied successfully for {t_name}")
    except Exception as e:
        log_msg(f"Could not apply DDL with schema prefix for {t_name}: {e}. Retrying in active schema '{current_db}'...", level="warn")
        try:
            fallback_ddl = ddl.format(
                analytics_silver=current_db,
                analytics_staging=current_db,
                analytics_reference=current_db,
                finance_maco=current_db,
                table_format=table_format
            )
            spark.sql(fallback_ddl)
            TABLE_SCHEMA_MAP[t_name] = current_db
            log_msg(f"DDL applied successfully for {t_name} in active schema '{current_db}'")
        except Exception as e2:
            log_msg(f"Error applying DDL for {t_name}: {e2}", level="error")

# COMMAND ----------

# DBTITLE 1,Step 3: Seed Data from seed_data or SQLite tables
import pandas as pd

possible_seed_paths = [
    "/dbfs/FileStore/migration_input_data",
    "/Workspace/Repos/migration_input_data",
    "./migration_input_data",
    "../migration_input_data",
    os.path.join(_cur_dir, "migration_input_data"),
    os.path.join(os.path.dirname(_cur_dir), "migration_input_data"),
    "/dbfs/FileStore/seed_data",
    "/Workspace/Repos/seed_data",
    "./seed_data",
    "../seed_data",
    "../../seed_data",
    os.path.join(_cur_dir, "seed_data"),
    os.path.join(os.path.dirname(_cur_dir), "seed_data"),
    os.path.join(os.path.dirname(_cur_dir), "migrated_tables")
]

seed_dir = None
for p in possible_seed_paths:
    if os.path.exists(p) and any(f.endswith(".csv") for f in os.listdir(p)):
        seed_dir = p
        break

if seed_dir:
    log_msg(f"Loading seed data from {seed_dir} into {table_format} tables...")
    for f in os.listdir(seed_dir):
        if f.endswith(".csv"):
            t_base = f.replace(".csv", "")
            csv_path = os.path.join(seed_dir, f)
            target_schema = TABLE_SCHEMA_MAP.get(t_base, "default")
            target_table = f"{target_schema}.{t_base}" if target_schema != "default" else t_base
            try:
                sdf = spark.read.option("header", "true").option("inferSchema", "true").csv(
                    f"file:///{csv_path}".replace("\\", "/") if not csv_path.startswith("/dbfs") else csv_path.replace("/dbfs", "dbfs:")
                )
                sdf.write.format(table_format).mode("overwrite").saveAsTable(target_table)
                log_msg(f"Seeded {sdf.count()} rows into {target_table}")
            except Exception as e:
                log_msg(f"Failed seeding {t_base} into {target_table}: {e}", level="warn")
else:
    log_msg("Seed CSV directory not found on filesystem. Generating deterministic in-cluster seed records for all tables...")
    random.seed(42)
    
    # 1. Seed mock_data (2,000 rows)
    mock_rows = []
    for i in range(1, 2001):
        mock_rows.append((
            i,
            f"FirstName_{i}",
            f"LastName_{i}",
            f"user_{i}@example.com",
            "Male" if i % 2 == 0 else "Female",
            f"192.168.1.{i % 255}",
            "MOCK_DATA.csv" if i <= 1000 else "MOCK_DATA (1).csv"
        ))
    # Explicit DDL schema: 'id' must stay INT to match the table (createDataFrame infers Python ints as BIGINT,
    # which Delta cannot merge with the existing INT column on overwrite)
    mock_df = spark.createDataFrame(mock_rows, "id INT, first_name STRING, last_name STRING, email STRING, gender STRING, ip_address STRING, source_file STRING")
    mock_df.write.format(table_format).mode("overwrite").saveAsTable("mock_data")
    log_msg(f"Seeded {mock_df.count()} rows into mock_data")
    
    # 2. Seed all 12 DDL tables (100 realistic rows each)
    def generate_seed_val(col_name, col_type, idx):
        name_lower = col_name.lower()
        t_lower = col_type.lower()
        if any(k in name_lower for k in ['employeeid', 'patronid', 'studentidentificationcode', 'studentcareernumber']):
            return str(10000000 + idx) if 'string' in t_lower else (10000000 + idx)
        if 'applicationnumber' in name_lower or 'transid' in name_lower:
            return str(20000000 + idx) if 'string' in t_lower else (20000000 + idx)
        if 'courseid' in name_lower:
            return f"CRS{1000 + (idx % 200)}"
        if 'classnumber' in name_lower:
            return 50000 + (idx % 500)
        if 'ficecode' in name_lower:
            return "003656"
        if 'recordcode' in name_lower:
            return "2" if "002" in name_lower else ("8" if "008" in name_lower else "1")
        if any(k in name_lower for k in ['reportingterm', 'termsourcekey', 'term_sk']):
            return ['2248', '2252', '2255', '2238'][idx % 4]
        if 'termdescription' in name_lower or 'termdescr' in name_lower:
            return ['Fall 2024', 'Spring 2025', 'Summer 2025', 'Fall 2023'][idx % 4]
        if any(k in name_lower for k in ['academicyear', 'calendaryear', 'academic_year']):
            return ['2023-2024', '2024-2025', '2022-2023'][idx % 3]
        if 'academiccareer' in name_lower or 'coursecareer' in name_lower:
            return 'UGRD' if idx % 4 != 0 else 'GRAD'
        if 'sessioncode' in name_lower:
            return '1' if idx % 3 != 0 else '5W2'
        if 'campus' in name_lower:
            return 'MAIN'
        if any(k in name_lower for k in ['collegecode', 'coursecollegecode', 'studentcollegecode']):
            return ['ENGR', 'BUSN', 'SCIE', 'LART', 'NURS'][idx % 5]
        if 'college' in name_lower:
            return ['College of Engineering', 'College of Business', 'College of Science', 'College of Liberal Arts'][idx % 4]
        if any(k in name_lower for k in ['departmentcode', 'coursedepartmentcode', 'studentdepartmentcode']):
            return ['CSE', 'MAE', 'EE', 'MATH', 'PHYS', 'MGMT', 'ACCT'][idx % 7]
        if 'department' in name_lower:
            return 'Computer Science & Engineering' if idx % 2 == 0 else 'Mechanical Aerospace Eng'
        if 'subject' in name_lower or 'coursesubject' in name_lower:
            return ['CSE', 'MAE', 'MATH', 'PHYS', 'ENGL', 'HIST'][idx % 6]
        if 'catalognumber' in name_lower:
            return ['1310', '1320', '2315', '3310', '4308', '5301'][idx % 6]
        if 'sectionnumber' in name_lower:
            return f"00{(idx % 9) + 1}"
        if 'residency' in name_lower:
            return 'Resident' if idx % 4 != 0 else 'Non-Resident'
        if 'grade' in name_lower and 'points' not in name_lower:
            return ['A', 'B', 'C', 'B+', 'A-', 'P'][idx % 6]
        if 'gpa' in name_lower:
            return round(2.8 + (idx % 12) * 0.1, 3)
        if any(k in name_lower for k in ['credit', 'hours', 'sch']):
            return 3 if idx % 4 != 0 else 4 if ('int' in t_lower or 'bigint' in t_lower) else (3.0 if idx % 4 != 0 else 4.0)
        if 'gradepoints' in name_lower:
            return (idx % 4 + 1) * 3
        if 'flag' in name_lower:
            return 'Y' if idx % 3 != 0 else 'N'
        if 'holidaydescription' in name_lower:
            return ['Labor Day', 'Thanksgiving Holiday', 'Winter Break', 'Martin Luther King Jr. Day', 'Memorial Day', 'Independence Day'][idx % 6]
        if any(k in name_lower for k in ['date', 'time', 'timestamp', 'snapdate', 'postdate', 'trandate', 'created_tsp']):
            dt = datetime(2024, 8, 20) + timedelta(days=idx % 90, hours=(idx % 24))
            if 'date' in t_lower and 'time' not in t_lower and 'timestamp' not in t_lower:
                return dt.date()
            return dt.strftime('%Y-%m-%d %H:%M:%S')
        if any(k in name_lower for k in ['amt', 'amount', 'vol', 'dol', 'salary', 'offered', 'paid', 'utilized']):
            if 'int' in t_lower or 'bigint' in t_lower:
                return 100 + (idx * 37 % 9900)
            return float(round(500.0 + (idx * 137.5 % 24500.0), 2))
        if any(k in name_lower for k in ['weeknumber', 'daynumber', 'snap_yr']):
            return (idx % 52) + 1 if 'week' in name_lower else ((idx % 365) + 1 if 'day' in name_lower else 2024 + (idx % 2))
        if 'status' in name_lower:
            return 'COMPLETED' if idx % 5 != 0 else 'PENDING'
        if 'reason' in name_lower:
            return 'Approved'
        if 'rank' in name_lower:
            return ['Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer'][idx % 4]
        if 'first_name' in name_lower or name_lower == 'firstname':
            return f"FirstName_{idx}"
        if 'last_name' in name_lower or name_lower == 'lastname':
            return f"LastName_{idx}"
        if 'gender' in name_lower:
            g = 'Male' if idx % 2 == 0 else 'Female'
            return g[:1] if 'cbm' in name_lower or 'thecb' in name_lower else g
        if 'email' in name_lower:
            return f"user_{idx}@example.com"
        if 'int' in t_lower or 'bigint' in t_lower or 'smallint' in t_lower:
            return idx + 1
        if 'float' in t_lower or 'double' in t_lower or 'decimal' in t_lower:
            return float(round((idx % 100) + 0.5, 2))
        if 'boolean' in t_lower:
            return (idx % 2 == 0)
        if 'date' in t_lower:
            return (datetime(2024, 1, 1) + timedelta(days=idx % 365)).date()
        if 'timestamp' in t_lower:
            return datetime(2024, 1, 1) + timedelta(days=idx % 365, hours=idx % 24)
        return f"{col_name}_{idx + 1}"

    for t_name in TABLES_DDL:
        if t_name == "mock_data":
            continue
        target_schema = TABLE_SCHEMA_MAP.get(t_name, "default")
        target_table = f"{target_schema}.{t_name}" if target_schema != "default" else t_name
        try:
            tbl_schema = spark.table(target_table).schema
            table_rows = []
            for i in range(100):
                row_dict = {}
                for f in tbl_schema.fields:
                    row_dict[f.name] = generate_seed_val(f.name, f.dataType.simpleString(), i)
                table_rows.append(row_dict)
            table_df = spark.createDataFrame(table_rows, schema=tbl_schema)
            table_df.write.format(table_format).mode("overwrite").saveAsTable(target_table)
            log_msg(f"Seeded {table_df.count()} synthetic rows into {target_table}")
        except Exception as e:
            log_msg(f"Error seeding synthetic data for {target_table}: {e}", level="warn")

log_msg("Databricks Database Setup and Seeding COMPLETE!")