# Databricks notebook source
# MAGIC %md
# MAGIC # 200_TRN_ADW_UTA_HOLIDAY_SCHEDULE --> transform_analytics_dim_uta_holiday_schedule
# MAGIC Converted from SAS to PySpark
# MAGIC
# MAGIC **Source**: 200_TRN_ADW_UTA_HOLIDAY_SCHEDULE.sas
# MAGIC
# MAGIC **source file**: Volumes/utadw/stg/stg/UTA Holiday Schedule.csv
# MAGIC
# MAGIC **target table**: analytics_dev.reference.dim_uta_holiday_schedule

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

from pyspark.sql import functions as F
from pyspark.sql.types import *
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
from pyspark.sql.types import StructType, StructField, StringType

# COMMAND ----------

"""
Processes UTA Holiday Schedule CSV file and writes enriched academic holiday data to a target table.
Steps:
1. Defines schema for the holiday schedule file.
2. Reads the CSV file into a DataFrame.
3. Converts the HOLIDAY column to timestamp and trims HOLIDAYDESCRIPTION.
4. Derives AcademicYear based on the HOLIDAY date.
5. Constructs academic terms for each holiday.
6. Enriches the DataFrame with user and timestamp metadata.
7. Writes the final DataFrame to the specified table.
"""

holiday_schedule_schema = StructType(
    [
        StructField("HOLIDAY", StringType(), True),
        StructField("HOLIDAYDESCRIPTION", StringType(), True),
    ]
)
holiday_schedule_df = (
    spark.read.option("header", "true")
    .option("sep", ",")
    .option("mode", "PERMISSIVE")
    .schema(holiday_schedule_schema)
    .csv(uta_holiday_schedule_file)
)
holiday_schedule_df = holiday_schedule_df.withColumn(
    "HOLIDAY", F.to_timestamp("HOLIDAY", "ddMMMyyyy:HH:mm:ss")
)

holiday_schedule_df = holiday_schedule_df.withColumn(
    "HOLIDAYDESCRIPTION", F.trim(F.col("HOLIDAYDESCRIPTION"))
)
academic_calendar_df = holiday_schedule_df.select(
    F.when(
        (F.month(F.col("HOLIDAY")) >= 9) & (F.month(F.col("HOLIDAY")) <= 12),
        F.concat(
            F.year(F.col("HOLIDAY")).cast("string"),
            F.lit("-"),
            (F.year(F.col("HOLIDAY")) + 1).cast("string"),
        ),
    )
    .otherwise(
        F.concat(
            (F.year(F.col("HOLIDAY")) - 1).cast("string"),
            F.lit("-"),
            F.year(F.col("HOLIDAY")).cast("string"),
        )
    )
    .alias("AcademicYear"),
    F.col("HOLIDAY"),
    F.col("HOLIDAYDESCRIPTION"),
)
academic_terms_df = academic_calendar_df.select(
    F.col("AcademicYear"),
    F.concat(
        (
            (
                F.substring("AcademicYear", 1, 2).cast("int") * 100
                + F.substring("AcademicYear", 3, 2).cast("int") * 10
                + 8
            )
        ).cast("string"),
        F.lit(","),
        (
            (
                F.substring("AcademicYear", 1, 2).cast("int") * 100
                + F.substring("AcademicYear", 3, 2).cast("int") * 10
                + 12
            )
        ).cast("string"),
        F.lit(","),
        (
            (
                F.substring("AcademicYear", 1, 2).cast("int") * 100
                + F.substring("AcademicYear", 3, 2).cast("int") * 10
                + 15
            )
        ).cast("string"),
    ).alias("Terms"),
    F.col("HOLIDAY"),
    F.col("HOLIDAYDESCRIPTION"),
)

academic_terms_enriched_df = academic_terms_df.select(
    F.col("AcademicYear"),
    F.col("Terms"),
    F.col("HOLIDAY"),
    F.col("HOLIDAYDESCRIPTION"),
)
write_df_to_table(
    academic_terms_enriched_df,
    f"{analytics}.{reference}.dim_uta_holiday_schedule",
    mode="append",
    schemaOverwrite="true",
    dedup_before_append=True,
)