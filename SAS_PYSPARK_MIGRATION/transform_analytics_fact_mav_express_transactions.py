# Databricks notebook source
# MAGIC %md
# MAGIC # FactUtaMavExpressTransLedger --> transform_analytics_fact_mav_express_transactions
# MAGIC
# MAGIC **Purpose:**
# MAGIC Builds the Fact table for UTA MAV Express Transaction Ledger data by extracting,
# MAGIC transforming, and loading activity transaction ledger records enriched with
# MAGIC person and location details.
# MAGIC
# MAGIC **Target Table:**
# MAGIC - `analytics.silver.fact_mav_express_transactions` — Fact table for MAV Express transactions
# MAGIC
# MAGIC **Process Overview:**
# MAGIC 1. Load historical transaction ledger data (Full mode only)
# MAGIC 2. Load current transaction ledger data (date-filtered based on processing mode)
# MAGIC 3. Combine historical and current datasets (Full) or use current only (Incremental)
# MAGIC 4. Write combined result to the target fact table
# MAGIC
# MAGIC Converted from SAS to PySpark.
# MAGIC Source: FactUtaMavExpressTransLedger.sas

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

from datetime import datetime
from pyspark.sql import functions as F
from delta.tables import DeltaTable
from pyspark.sql.types import *

# COMMAND ----------

_job_start_time = datetime.now()
log_msg(
    f"Job started: transform_analytics_fact_mav_express_transactions | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)

# COMMAND ----------

# Create widgets with default runtime parameters for academic_year,terms.
dbutils.widgets.text("ProcessingOption", "Incremental", "Processing Option")
ProcessingOption = dbutils.widgets.get("ProcessingOption")

# COMMAND ----------


# --- Historical Data Loading ---
def create_historical_data(ProcessingOption):
    """
    Loads and transforms historical activity transaction ledger data.

    In 'Full' mode: reads the historical ledger, enriches it with person and
    location details, and produces a standardized historical transactions DataFrame.
    In 'Incremental' mode: skips historical data loading entirely.
    """
    global df_hist_trans_ledger

    if ProcessingOption == "Full":
        # Historical ledger base table — all past activity transactions
        df_hist_trans_ledger = read_table(
            f"{campus_access}.{bronze}.csgold_acttranledgerhist"
        ).alias("ledger")

        # Enrich with person/patron details (left join to retain unmatched ledger rows)
        df_hist_trans_ledger = df_hist_trans_ledger.join(
            read_table(f"{campus_access}.{bronze}.csgold_person").alias("person"),
            (F.col("ledger.patronid") == F.col("person.id_pers")),
            "left",
        )

        # Enrich with location descriptions (inner join — only valid locations)
        df_hist_trans_ledger = df_hist_trans_ledger.join(
            read_table(f"{campus_access}.{bronze}.csgold_locationdescription").alias(
                "location"
            ),
            (F.col("ledger.location") == F.col("location.location")),
            "inner",
        )

        # SAS: WHERE trandate <= datetime() AND patronid IS NOT NULL
        df_hist_trans_ledger = df_hist_trans_ledger.filter(
            (F.col("ledger.patronid").isNotNull())
            & (F.col("ledger.trandate") <= F.current_timestamp())
            & (~F.col("ledger.trandate").isin('9999-12-31', '9999-12-31 00:00:00'))
        )

        # Select and rename columns to the standardized fact schema
        df_hist_trans_ledger = df_hist_trans_ledger.select(
            F.col("ledger.trandate"),
            F.col("ledger.location").alias("locationsourcekey"),
            F.col("location.longdes").alias("locationdescription"),
            F.col("location.shortdes").alias("locationshortdescr"),
            F.col("ledger.patronid"),
            F.col("person.val_univ_id").alias("employeeid"),
            F.col("ledger.transidseq_generation"),
            F.col("ledger.transid"),
            F.col("ledger.accounttype"),
            F.lit(0).alias("ApprValueOfTran"),
            F.col("ledger.completionstatus"),
            F.col("ledger.reasonmsg"),
            F.col("ledger.reasontype"),
            F.col("ledger.trantype").alias("transtype"),
            F.col("ledger.currentprimarykey"),
            F.col("ledger.postdate"),
        )

        # Order by transaction date and location for consistent output
        df_hist_trans_ledger = df_hist_trans_ledger.orderBy(
            F.col("trandate").asc(), F.col("locationsourcekey").asc()
        )

        log_msg(
            f"Processing Option is {ProcessingOption} and historical data has been generated."
        )
    if ProcessingOption == "Incremental":
        log_msg(
            f"Processing Option is {ProcessingOption} and historical data will not be generated."
        )
        return


create_historical_data(ProcessingOption=f"{ProcessingOption}")

# COMMAND ----------


def create_current_data(ProcessingOption):
    """
    Loads and transforms current (recent) activity transaction ledger data.

    In 'Full' mode: retrieves transactions newer than the max historical date
    up to the current timestamp.
    In 'Incremental' mode: retrieves only the last day's transactions.
    """
    global df_current_trans_ledger

    if ProcessingOption == "Full":
        # MinProcessingDateTime: max trandate from hist DataFrame (bad future dates excluded by location INNER JOIN)
        MinProcessingDateTime = (
            df_hist_trans_ledger
            # Optional: exclude future-dated records — already handled by location INNER JOIN.
            # .filter(F.col("trandate") < F.current_timestamp())
            .agg(F.max("trandate").alias("max_trandate")).collect()[0]["max_trandate"]
        )
        MinProcessingDateTime = (
            str(MinProcessingDateTime) if MinProcessingDateTime is not None else None
        )

        # Current ledger base table — active (non-archived) transactions
        df_current_trans_ledger = read_table(
            f"{campus_access}.{bronze}.csgold_acttranledger"
        ).alias("ledger")

        # Enrich with person/patron details (left join to retain unmatched ledger rows)
        df_current_trans_ledger = df_current_trans_ledger.join(
            read_table(f"{campus_access}.{bronze}.csgold_person").alias("person"),
            (F.col("ledger.patronid") == F.col("person.id_pers")),
            "left",
        )

        # Enrich with location descriptions (inner join — only valid locations)
        df_current_trans_ledger = df_current_trans_ledger.join(
            read_table(f"{campus_access}.{bronze}.csgold_locationdescription").alias(
                "location"
            ),
            (F.col("ledger.location") == F.col("location.location")),
            "inner",
        )

        # SAS: WHERE trandate <= datetime() AND patronid IS NOT NULL
        df_current_trans_ledger = df_current_trans_ledger.filter(
            (F.col("ledger.trandate") <= F.current_timestamp())
            & F.col("ledger.patronid").isNotNull()
            & (~F.col("ledger.trandate").isin('9999-12-31', '9999-12-31 00:00:00'))
        )

        # Select and rename columns to the standardized fact schema
        df_current_trans_ledger = df_current_trans_ledger.select(
            F.col("ledger.trandate"),
            F.col("ledger.location").alias("locationsourcekey"),
            F.col("location.longdes").alias("locationdescription"),
            F.col("location.shortdes").alias("locationshortdescr"),
            F.col("ledger.patronid"),
            F.col("person.val_univ_id").alias("employeeid"),
            F.col("ledger.transidseq_generation"),
            F.col("ledger.transid"),
            F.col("ledger.accounttype"),
            F.lit(0).alias("ApprValueOfTran"),
            F.col("ledger.completionstatus"),
            F.col("ledger.reasonmsg"),
            F.col("ledger.reasontype"),
            F.col("ledger.trantype").alias("transtype"),
            F.col("ledger.currentprimarykey"),
            F.col("ledger.postdate"),
        )

        # Order by transaction date and location for consistent output
        df_current_trans_ledger = df_current_trans_ledger.orderBy(
            F.col("trandate").asc(), F.col("locationsourcekey").asc()
        )

        log_msg(
            f"Processing Option is {ProcessingOption} and historical data will be appended to current data."
        )

    if ProcessingOption == "Incremental":
        # Current ledger base table — active (non-archived) transactions
        df_current_trans_ledger = read_table(
            f"{campus_access}.{bronze}.csgold_acttranledger"
        ).alias("ledger")

        # Enrich with person/patron details (left join to retain unmatched ledger rows)
        df_current_trans_ledger = df_current_trans_ledger.join(
            read_table(f"{campus_access}.{bronze}.csgold_person").alias("person"),
            (F.col("ledger.patronid") == F.col("person.id_pers")),
            "left",
        )

        # Enrich with location descriptions (inner join — only valid locations)
        df_current_trans_ledger = df_current_trans_ledger.join(
            read_table(f"{campus_access}.{bronze}.csgold_locationdescription").alias(
                "location"
            ),
            (F.col("ledger.location") == F.col("location.location")),
            "inner",
        )

        # SAS: WHERE trandate > dhms(intnx('day',datepart(datetime()),-1),0,0,0) AND trandate <= datetime()
        df_current_trans_ledger = df_current_trans_ledger.filter(
            (F.col("ledger.trandate") > F.to_timestamp(F.date_sub(F.current_date(), 1)))
            & (F.col("ledger.trandate") <= F.current_timestamp())
            & F.col("ledger.patronid").isNotNull()
            & (~F.col("ledger.trandate").isin('9999-12-31', '9999-12-31 00:00:00'))
        )

        # Select and rename columns to the standardized fact schema
        df_current_trans_ledger = df_current_trans_ledger.select(
            F.col("ledger.trandate"),
            F.col("ledger.location").alias("locationsourcekey"),
            F.col("location.longdes").alias("locationdescription"),
            F.col("location.shortdes").alias("locationshortdescr"),
            F.col("ledger.patronid"),
            F.col("person.val_univ_id").alias("employeeid"),
            F.col("ledger.transidseq_generation"),
            F.col("ledger.transid"),
            F.col("ledger.accounttype"),
            F.lit(0).alias("ApprValueOfTran"),
            F.col("ledger.completionstatus"),
            F.col("ledger.reasonmsg"),
            F.col("ledger.reasontype"),
            F.col("ledger.trantype").alias("transtype"),
            F.col("ledger.currentprimarykey"),
            F.col("ledger.postdate"),
        )

        # Order by transaction date and location for consistent output
        df_current_trans_ledger = df_current_trans_ledger.orderBy(
            F.col("trandate").asc(), F.col("locationsourcekey").asc()
        )

        log_msg(
            f"Processing Option is {ProcessingOption} and only one day of current data will generated."
        )
        return

# COMMAND ----------

create_current_data(ProcessingOption=f"{ProcessingOption}")

# COMMAND ----------


def combine_datasets(ProcessingOption):
    """
    Combines historical and current transaction ledger DataFrames into a single unified dataset.

    In 'Full' mode: unions historical and current transactions.
    In 'Incremental' mode: uses only the current (last day) transactions.
    """
    global df_combined_trans_ledger

    if ProcessingOption == "Full":
        # Historical portion — standardized columns from the historical ledger
        df_combined_hist_portion = df_hist_trans_ledger.alias("ledger")
        df_combined_hist_portion = df_combined_hist_portion.select(
            F.col("ledger.trandate"),
            F.col("ledger.locationsourcekey"),
            F.col("ledger.locationdescription"),
            F.col("ledger.locationshortdescr"),
            F.col("ledger.patronid"),
            F.col("ledger.employeeid"),
            F.col("ledger.transidseq_generation"),
            F.col("ledger.transid"),
            F.col("ledger.accounttype"),
            F.col("ledger.apprvalueoftran"),
            F.col("ledger.completionstatus"),
            F.col("ledger.reasonmsg"),
            F.col("ledger.reasontype"),
            F.col("ledger.transtype"),
            F.col("ledger.currentprimarykey"),
            F.col("ledger.postdate"),
        )

        # Current portion — standardized columns from the current ledger
        df_combined_current_portion = df_current_trans_ledger.alias("ledger")
        df_combined_current_portion = df_combined_current_portion.select(
            F.col("ledger.trandate"),
            F.col("ledger.locationsourcekey"),
            F.col("ledger.locationdescription"),
            F.col("ledger.locationshortdescr"),
            F.col("ledger.patronid"),
            F.col("ledger.employeeid"),
            F.col("ledger.transidseq_generation"),
            F.col("ledger.transid"),
            F.col("ledger.accounttype"),
            F.col("ledger.apprvalueoftran"),
            F.col("ledger.completionstatus"),
            F.col("ledger.reasonmsg"),
            F.col("ledger.reasontype"),
            F.col("ledger.transtype"),
            F.col("ledger.currentprimarykey"),
            F.col("ledger.postdate"),
        )

        # Union historical and current datasets into one combined fact DataFrame
        df_combined_trans_ledger = df_combined_hist_portion.union(
            df_combined_current_portion
        )

        # Order by transaction date and location for consistent output
        df_combined_trans_ledger = df_combined_trans_ledger.orderBy(
            F.col("trandate").asc(), F.col("locationsourcekey").asc()
        )

    if ProcessingOption == "Incremental":
        # In Incremental mode, the combined dataset is just the current day's data
        df_combined_trans_ledger = df_current_trans_ledger.alias("ledger")
        df_combined_trans_ledger = df_combined_trans_ledger.select(
            F.col("ledger.trandate"),
            F.col("ledger.locationsourcekey"),
            F.col("ledger.locationdescription"),
            F.col("ledger.locationshortdescr"),
            F.col("ledger.patronid"),
            F.col("ledger.employeeid"),
            F.col("ledger.transidseq_generation"),
            F.col("ledger.transid"),
            F.col("ledger.accounttype"),
            F.col("ledger.apprvalueoftran"),
            F.col("ledger.completionstatus"),
            F.col("ledger.reasonmsg"),
            F.col("ledger.reasontype"),
            F.col("ledger.transtype"),
            F.col("ledger.currentprimarykey"),
            F.col("ledger.postdate"),
        )

        # Order by transaction date and location for consistent output
        df_combined_trans_ledger = df_combined_trans_ledger.orderBy(
            F.col("trandate").asc(), F.col("locationsourcekey").asc()
        )


combine_datasets(ProcessingOption=f"{ProcessingOption}")

# COMMAND ----------

# Casting as per target table structure
final_casted_result_dataframe = df_combined_trans_ledger.select(
    F.col("trandate").cast("TIMESTAMP").alias("trandate"),
    F.col("locationsourcekey").cast("DECIMAL(11,0)").alias("locationsourcekey"),
    F.substring(F.col("locationdescription").cast("STRING"), 1, 100).alias(
        "locationdescription"
    ),
    F.substring(F.col("locationshortdescr").cast("STRING"), 1, 8).alias(
        "locationshortdescr"
    ),
    F.col("patronid").cast("DECIMAL(11,0)").alias("patronid"),
    F.substring(F.col("employeeid").cast("STRING"), 1, 64).alias("employeeid"),
    F.col("transidseq_generation").cast("DECIMAL(11,0)").alias("transidseq_generation"),
    F.col("transid").cast("DECIMAL(11,0)").alias("transid"),
    F.col("accounttype").cast("DECIMAL(11,0)").alias("accounttype"),
    F.col("apprvalueoftran").cast("BIGINT").alias("apprvalueoftran"),
    F.substring(F.col("completionstatus").cast("STRING"), 1, 1).alias(
        "completionstatus"
    ),
    F.substring(F.col("reasonmsg").cast("STRING"), 1, 255).alias("reasonmsg"),
    F.col("reasontype").cast("DECIMAL(11,0)").alias("reasontype"),
    F.col("transtype").cast("DECIMAL(11,0)").alias("transtype"),
    F.substring(F.col("currentprimarykey").cast("STRING"), 1, 64).alias(
        "currentprimarykey"
    ),
    F.col("postdate").cast("TIMESTAMP").alias("postdate"),
)

# COMMAND ----------

# Write the final combined transaction ledger DataFrame to the target fact table
target_table = DeltaTable.forName(spark, f"{analytics}.{silver}.fact_mav_express_transactions")
if(ProcessingOption == "Incremental"):
    target_table.alias("target") \
    .merge(final_casted_result_dataframe.alias("source"), "target.trandate = source.trandate") \
    .whenMatchedDelete() \
    .execute()
elif(ProcessingOption == "Full"):
    target_table.delete()

write_df_to_table(
    final_casted_result_dataframe,
    f"{analytics}.{silver}.fact_mav_express_transactions",
    mode="append"
)

log_msg(f"Successfully overwrite data into {target_table}")

# COMMAND ----------

# --- Job Completion ---
_job_end_time = datetime.now()
_job_elapsed = _job_end_time - _job_start_time
log_msg(
    f"Job completed: transform_analytics_fact_mav_express_transactions | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} | Elapsed: {str(_job_elapsed)}",
    "info",
)
