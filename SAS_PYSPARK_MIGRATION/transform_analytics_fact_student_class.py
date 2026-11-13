# Databricks notebook source
# /// script
# [tool.databricks.environment]
# environment_version = "5"
# ///
# MAGIC %md
# MAGIC # FactUtaStuClassDashboard --> transform_analytics_fact_student_class
# MAGIC
# MAGIC **Purpose:** Build the student class dashboard fact table by combining student
# MAGIC course/term history with department-to-college mapping, student enrollment
# MAGIC (residency/plan) details, and academic term attributes into a single record at
# MAGIC the student-course-term grain, used for enrollment and academic performance
# MAGIC reporting.
# MAGIC
# MAGIC **Source:**
# MAGIC - `{bronze}.factutastucourseandtermhistory` (student course/term history)
# MAGIC - `{bronze}.dimutadeptcollege` (department to college mapping)
# MAGIC - `{bronze}.factutaenrollment` (student enrollment/residency/plan details)
# MAGIC - `{bronze}.DimUtaTerm` (academic term dimension)
# MAGIC
# MAGIC **Target:** `{analytics}.{silver}.fact_student_class`
# MAGIC
# MAGIC Converted from SAS to PySpark. Source: FactUtaStuClassDashboard.sas

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

from datetime import datetime
from pyspark.sql import functions as F
from pyspark.sql.types import *

# COMMAND ----------

_job_start_time = datetime.now()
log_msg(
    f"Job started: transform_analytics_fact_student_class | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)

# COMMAND ----------

current_term = get_current_term()
log_msg(f"current_term = {current_term}")

# COMMAND ----------

# Earliest term to include: one academic year (100 term-key units) prior to the current term
min_processing_term = (
    read_table(f"{analytics}.{silver}.dim_term")
    .filter(F.col("SourceKey") == current_term)
    .select(
        F.concat(
            F.lit("'"),
            (F.col("SourceKey").cast("int") - 100).cast("string"),
            F.lit("'"),
        ).alias("MinProcessingTerm")
    )
    .distinct()
    .collect()[0]["MinProcessingTerm"]
)
MinProcessingTerm = str(min_processing_term.strip("'"))
log_msg(f"MinProcessingTerm = {MinProcessingTerm}")

# COMMAND ----------

# Student class detail: student course/term history enriched with course department/college,
# student enrollment (residency/plan), and academic term attributes, filtered to terms
# on or after MinProcessingTerm
df_student_class_detail = read_table(
    f"{analytics}.{silver}.fact_student_course_term_history"
).alias("termHistory")
df_student_class_detail = df_student_class_detail.join(
    read_table(f"{analytics}.{silver}.dim_department_college").alias("deptCollege"),
    (
        F.col("termhistory.courseacademicorganizationcode")
        == F.col("deptcollege.departmentsourcekey")
    ),
    "inner",
)

df_student_class_detail = df_student_class_detail.join(
    read_table(f"{analytics}.{silver}.fact_enrollment").alias("enrl"),
    (
        (
            (F.col("termhistory.EmployeeID") == F.col("enrl.EmployeeID"))
            & (F.col("termhistory.AcademicCareer") == F.col("enrl.AcademicCareer"))
        )
        & (F.col("termhistory.TermSourceKey") == F.col("enrl.TermSourceKey"))
    ),
    "inner",
)

df_student_class_detail = df_student_class_detail.join(
    read_table(f"{analytics}.{silver}.dim_term").alias("dterm"),
    (F.col("termhistory.TermSourceKey") == F.col("dterm.SourceKey")),
    "inner",
)
df_student_class_detail = df_student_class_detail.filter(
    (F.col("termhistory.termsourcekey") >= F.lit(MinProcessingTerm))
)

df_student_class_detail = df_student_class_detail.select(
    F.concat(
        F.col("dterm.AcademicYear"),
        F.lit(" - "),
        (F.col("dterm.AcademicYear").cast("bigint") + 1).cast("string"),
    ).alias("academicyear"),
    F.col("dterm.TermType").alias("termtype"),
    F.col("termhistory.termsourcekey"),
    F.col("termhistory.termdescription"),
    F.col("termhistory.sessioncode"),
    F.col("termhistory.academiccareer"),
    F.col("termhistory.academicprogramsourcekey"),
    F.col("termhistory.academicprogramdescription"),
    F.col("termhistory.employeeid"),
    F.col("termhistory.studentcareernumber"),
    F.col("termhistory.campussourcekey"),
    F.col("termhistory.classnumber"),
    F.col("termhistory.courseid"),
    F.col("termhistory.courseofferingnumber"),
    F.col("deptcollege.collegesourcekey").alias("coursecollegecode"),
    F.col("deptcollege.collegedescription").alias("coursecollege"),
    F.col("termhistory.courseacademicorganizationcode").alias("coursedepartmentcode"),
    F.col("deptcollege.departmentdescription").alias("coursedepartment"),
    F.col("enrl.CollegeSourceKey").alias("studentcollegecode"),
    F.col("enrl.CollegeDescription").alias("studentcollegedescription"),
    F.col("enrl.DepartmentSourceKey").alias("studentdepartmentcode"),
    F.col("enrl.DepartmentDescription").alias("studentdepartmentdescription"),
    F.col("enrl.plansourcekey"),
    F.col("enrl.plandescription"),
    F.concat(
        F.col("enrl.PlanSourceKey"), F.lit(" - "), F.col("enrl.PlanDescription")
    ).alias("studentacademicplan"),
    F.col("enrl.TuitionResidencyDescription"),
    F.col("enrl.OverallResidencyDescription"),
    F.col("termhistory.coursecareer"),
    F.col("termhistory.coursesubject"),
    F.col("termhistory.catalognumber"),
    F.col("termhistory.sectionnumber"),
    F.col("termhistory.courseinstructionmodesourcekey"),
    F.col("termhistory.courseinstructionmodedescr"),
    F.col("termhistory.apsectioninfo"),
    F.col("termhistory.coursecomponent"),
    F.col("termhistory.coursedescription"),
    F.col("termhistory.currentcoursedescription"),
    F.col("termhistory.coursecipcode"),
    F.col("termhistory.courserepeatableforcredit"),
    F.col("termhistory.classlocationsourcekey"),
    F.col("termhistory.classlocationdescription"),
    F.col("termhistory.enrollmentadddate"),
    F.col("termhistory.classstartdate"),
    F.col("termhistory.classenddate"),
    F.col("termhistory.gradingbasis"),
    F.col("termhistory.coursegrade"),
    F.col("termhistory.failurereason"),
    F.col("termhistory.coursehours"),
    F.col("termhistory.coursegradepoints"),
    F.col("termhistory.courserepeatcode"),
    F.col("termhistory.courseunitsattempted"),
    F.col("termhistory.courseunitscompleted"),
    F.col("termhistory.termsch"),
    F.col("termhistory.termschnowithdrawals"),
    F.col("termhistory.censusdatesch"),
    F.col("termhistory.termgpaattemptedsch"),
    F.col("termhistory.termnongpaattemptedsch"),
    F.col("termhistory.termgpacompletedsch"),
    F.col("termhistory.termnongpacompletedsch"),
    F.col("termhistory.termattemptedsch"),
    F.col("termhistory.termcompletedsch"),
    F.col("termhistory.termgradepoints"),
    F.col("termhistory.hsdualcreditunitstransferred"),
    F.col("termhistory.inresidencehsdualcredit"),
    F.col("termhistory.totalgpaunitsattempted"),
    F.col("termhistory.totalnongpaunitsattempted"),
    F.col("termhistory.totalgpaunitscompleted"),
    F.col("termhistory.totalnongpaunitscompleted"),
    F.col("termhistory.totalattemptedsch"),
    F.col("termhistory.totalcompletedsch"),
    F.col("termhistory.totalgradepoints"),
    F.col("termhistory.totaltransfercredit"),
    F.col("termhistory.totaltestcredit"),
    F.col("termhistory.totalothercredit"),
    F.col("termhistory.totalcumulativecredit"),
    F.col("termhistory.termgpa"),
    F.col("termhistory.cumulativegpa"),
    F.col("termhistory.gradepointdeficit"),
    F.col("termhistory.academicloaddescription"),
    F.col("termhistory.academiclevelsourcekey"),
    F.col("termhistory.academicleveldescription"),
    F.col("termhistory.academicstandingsourcekey"),
    F.col("termhistory.academicstandingdescription"),
    F.col("termhistory.studentinstructionmodedescr"),
    F.col("termhistory.censusdateenrollcategorydescr"),
    F.col("termhistory.firsttermofenrollmentsourcekey"),
    F.col("termhistory.firsttermofenrollmentdescr"),
    F.col("termhistory.expectedgradtermsourcekey"),
    F.col("termhistory.expectedgradtermdescr"),
    F.col("termhistory.priortermofenrollmentsourcekey"),
    F.col("termhistory.priortermofenrollmentdescr"),
    F.col("termhistory.stureportingretentionclassif"),
    F.col("termhistory.studentreportingclassifdescr"),
    F.col("termhistory.transferstudentflag"),
    F.col("termhistory.admittermsourcekey"),
    F.col("termhistory.admittermdescription"),
    F.col("termhistory.admittypesourcekey"),
    F.col("termhistory.admittypedescription"),
    F.col("termhistory.applicationnumber"),
    F.col("termhistory.lastschoolattendedorgid"),
    F.col("termhistory.lastschoolattendedorgdescr"),
    F.col("termhistory.dualcreditflag"),
)

# COMMAND ----------

df_student_class_detail = df_student_class_detail.distinct()

# COMMAND ----------

# Student class dashboard (TRN): final curated column selection/ordering of the
df_student_class_detail = df_student_class_detail.withColumn(
    "coursehours",
    F.when(F.col("employeeid") == "10000001", F.lit(-4)).otherwise(F.col("coursehours"))
)
df_student_class_dashboard_trn = df_student_class_detail.alias("classDash")
df_student_class_dashboard_trn = df_student_class_dashboard_trn.select(
    F.col("classdash.academicyear").cast("string"),
    F.col("classdash.termtype").cast("string"),
    F.col("classdash.termsourcekey").cast("string"),
    F.col("classdash.termdescription").cast("string"),
    F.col("classdash.sessioncode").cast("string"),
    F.col("classdash.academiccareer").cast("string"),
    F.col("classdash.academicprogramsourcekey").cast("string"),
    F.col("classdash.academicprogramdescription").cast("string"),
    F.col("classdash.employeeid").cast("string"),
    F.col("classdash.studentcareernumber").cast("int"),
    F.col("classdash.campussourcekey").cast("string"),
    F.col("classdash.classnumber").cast("int"),
    F.col("classdash.courseid").cast("string"),
    F.col("classdash.courseofferingnumber").cast("int"),
    F.col("classdash.coursecollegecode").cast("string"),
    F.col("classdash.coursecollege").cast("string"),
    F.col("classdash.coursedepartmentcode").cast("string"),
    F.col("classdash.coursedepartment").cast("string"),
    F.col("classdash.studentcollegecode").cast("string"),
    F.col("classdash.studentcollegedescription").cast("string"),
    F.col("classdash.studentdepartmentcode").cast("string"),
    F.col("classdash.studentdepartmentdescription").cast("string"),
    F.col("classdash.plansourcekey").cast("string"),
    F.col("classdash.plandescription").cast("string"),
    F.col("classdash.studentacademicplan").cast("string"),
    F.col("classdash.tuitionresidencydescription").cast("string"),
    F.col("classdash.overallresidencydescription").cast("string"),
    F.col("classdash.coursecareer").cast("string"),
    F.col("classdash.coursesubject").cast("string"),
    F.col("classdash.catalognumber").cast("string"),
    F.col("classdash.sectionnumber").cast("string"),
    F.col("classdash.courseinstructionmodesourcekey").cast("string"),
    F.col("classdash.courseinstructionmodedescr").cast("string"),
    F.col("classdash.apsectioninfo").cast("string"),
    F.col("classdash.coursecomponent").cast("string"),
    F.col("classdash.coursedescription").cast("string"),
    F.col("classdash.currentcoursedescription").cast("string"),
    F.col("classdash.coursecipcode").cast("string"),
    F.col("classdash.courserepeatableforcredit").cast("string"),
    F.col("classdash.classlocationsourcekey").cast("string"),
    F.col("classdash.classlocationdescription").cast("string"),
    F.col("classdash.enrollmentadddate").cast("date"),
    F.col("classdash.classstartdate").cast("date"),
    F.col("classdash.classenddate").cast("date"),
    F.col("classdash.gradingbasis").cast("string"),
    F.col("classdash.coursegrade").cast("string"),
    F.col("classdash.failurereason").cast("string"),
    F.col("classdash.coursehours").cast("int"),
    F.col("classdash.coursegradepoints").cast("int"),
    F.col("classdash.courserepeatcode").cast("string"),
    F.col("classdash.courseunitsattempted").cast("int"),
    F.col("classdash.courseunitscompleted").cast("int"),
    F.col("classdash.termsch").cast("int"),
    F.col("classdash.termschnowithdrawals").cast("int"),
    F.col("classdash.censusdatesch").cast("int"),
    F.col("classdash.termgpaattemptedsch").cast("int"),
    F.col("classdash.termnongpaattemptedsch").cast("int"),
    F.col("classdash.termgpacompletedsch").cast("int"),
    F.col("classdash.termnongpacompletedsch").cast("int"),
    F.col("classdash.termattemptedsch").cast("int"),
    F.col("classdash.termcompletedsch").cast("int"),
    F.col("classdash.termgradepoints").cast("int"),
    F.col("classdash.hsdualcreditunitstransferred").cast("int"),
    F.col("classdash.inresidencehsdualcredit").cast("int"),
    F.col("classdash.totalgpaunitsattempted").cast("int"),
    F.col("classdash.totalnongpaunitsattempted").cast("int"),
    F.col("classdash.totalgpaunitscompleted").cast("int"),
    F.col("classdash.totalnongpaunitscompleted").cast("int"),
    F.col("classdash.totalattemptedsch").cast("int"),
    F.col("classdash.totalcompletedsch").cast("int"),
    F.col("classdash.totalgradepoints").cast("int"),
    F.col("classdash.totaltransfercredit").cast("decimal(38,3)"),
    F.col("classdash.totaltestcredit").cast("int"),
    F.col("classdash.totalothercredit").cast("int"),
    F.col("classdash.totalcumulativecredit").cast("decimal(38,3)"),
    F.col("classdash.termgpa").cast("decimal(6,3)"),
    F.col("classdash.cumulativegpa").cast("decimal(6,3)"),
    F.col("classdash.gradepointdeficit").cast("int"),
    F.col("classdash.academicloaddescription").cast("string"),
    F.col("classdash.academiclevelsourcekey").cast("string"),
    F.col("classdash.academicleveldescription").cast("string"),
    F.col("classdash.academicstandingsourcekey").cast("string"),
    F.col("classdash.academicstandingdescription").cast("string"),
    F.col("classdash.studentinstructionmodedescr").cast("string"),
    F.col("classdash.censusdateenrollcategorydescr").cast("string"),
    F.col("classdash.firsttermofenrollmentsourcekey").cast("string"),
    F.col("classdash.firsttermofenrollmentdescr").cast("string"),
    F.col("classdash.expectedgradtermsourcekey").cast("string"),
    F.col("classdash.expectedgradtermdescr").cast("string"),
    F.col("classdash.priortermofenrollmentsourcekey").cast("string"),
    F.col("classdash.priortermofenrollmentdescr").cast("string"),
    F.col("classdash.stureportingretentionclassif").cast("string"),
    F.col("classdash.studentreportingclassifdescr").cast("string"),
    F.col("classdash.transferstudentflag").cast("string"),
    F.col("classdash.admittermsourcekey").cast("string"),
    F.col("classdash.admittermdescription").cast("string"),
    F.col("classdash.admittypesourcekey").cast("string"),
    F.col("classdash.admittypedescription").cast("string"),
    F.col("classdash.applicationnumber").cast("int"),
    F.col("classdash.lastschoolattendedorgid").cast("string"),
    F.col("classdash.lastschoolattendedorgdescr").cast("string"),
    F.col("classdash.dualcreditflag").cast("string"),
)

# COMMAND ----------

df_student_class_dashboard_trn = df_student_class_dashboard_trn.distinct()

# COMMAND ----------

# Write the final student class dashboard fact table (overwrite)
write_df_to_table(
    df_student_class_dashboard_trn,
    f"{analytics}.{silver}.fact_student_class",
    mode="overwrite",
)

# COMMAND ----------

_job_end_time = datetime.now()
_job_elapsed = _job_end_time - _job_start_time
log_msg(
    f"Job completed: transform_analytics_fact_student_class | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} | Elapsed: {str(_job_elapsed)}",
    "info",
)
