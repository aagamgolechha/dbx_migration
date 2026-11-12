# Databricks notebook source
# DBTITLE 1,Job Documentation
# MAGIC %md
# MAGIC # 200_TRN_UTA_ADM_DIM_FUNNEL_WEEKS --> transform_analytics_dim_admissions_funnel_weekly
# MAGIC
# MAGIC Converted from SAS to PySpark Source: 200_TRN_UTA_ADM_DIM_FUNNEL_WEEKS.sas
# MAGIC
# MAGIC ## Job Responsibility
# MAGIC
# MAGIC This job is responsible for building the **Admissions Funnel Weeks Dimension** ( `dim_admissions_funnel_weekly` ) table in the **analytics staging layer** of the data warehouse. It generates one row per calendar day for every admission cycle, enabling week-by-week funnel tracking across academic terms.
# MAGIC
# MAGIC | Attribute | Detail |
# MAGIC |---|---|
# MAGIC | Source | `bronze.dimutaterm`, `bronze.dimutasession` |
# MAGIC | Target | `analytics_dev.staging.dim_admissions_funnel_weekly` |
# MAGIC | Load Strategy | Full refresh (overwrite) — rebuilds the entire admissions funnel weeks dimension each run |
# MAGIC | Parameters | `MinimumTerm` (default: `2068`) — only terms with `sourcekey >= MinimumTerm` are processed |
# MAGIC | SAS Origin | Converted from `200_TRN_UTA_ADM_DIM_FUNNEL_WEEKS.sas` |
# MAGIC
# MAGIC ## Key Steps
# MAGIC
# MAGIC 1. Builds `TermAndCensusDateDataPrep` by joining `dimutaterm` (current term) to `dimutasession` (current census session), then to `dimutaterm` again (next term) and `dimutasession` (next census session). Applies term-sequence offset rules (+3 for Spring/Summer terms, +4 for Fall terms) to identify the correct next term. Computes `cyclestartdate` (the Sunday immediately following the current census date) and `weeksbetween` (number of full weeks between the two census Sundays).
# MAGIC 2. Builds `TermAndCensusDateDataPrep2` by reshaping to a cycle-term perspective: promotes the next term as the cycle driver, derives `termsourcekey2` (one term ahead using +3/+4 offset) and `termsourcekey3` (two terms ahead using +6/+7 offset), and filters out rows where `cyclestartdate` year equals 1900 — a SAS sentinel value indicating a missing or invalid date.
# MAGIC 3. Builds `TermAndCensusDateData` by joining `dimutaterm` twice more to resolve the human-readable `termdescription2` and `termdescription3` for the two look-ahead terms.
# MAGIC 4. Expands each admission cycle into one row per calendar day from `cyclestartdate` through `cycleenddate`: uses `sequence(1, weeksbetween × 7)` to generate all day numbers, computes `snapshotdate` via `date_add(cyclestartdate, daynumber − 1)`, derives `weeknumber` as `CEIL(daynumber / 7)`, and assigns `snapshotdayofweek` using `date_format(snapshotdate, 'EEEE')`. Rows outside the cycle window are filtered out.
# MAGIC 5. Casts `WEEKNUMBER` and `DAYNUMBER` to `BIGINT` to align with the Oracle target schema, then overwrites `analytics_dev.staging.dim_admissions_funnel_weekly` with the final dataset.

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

"""Import required libraries for date handling, Spark SQL functions, window operations, and schema types."""

from datetime import datetime
from pyspark.sql import functions as F
from pyspark.sql.window import Window
from pyspark.sql.types import *

# COMMAND ----------

"""Initialize job timer and log message"""

_job_start_time = datetime.now()
log_msg(
    f"Job started: transform_analytics_dim_admissions_funnel_weekly | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)

dbutils.widgets.text("MinimumTerm", "2068", "MinimumTerm")
MinimumTerm = int(dbutils.widgets.get("MinimumTerm"))

# COMMAND ----------

# DBTITLE 1,Cell 6
"""Build TermAndCensusDateDataPrep: join dimutaterm and dimutasession tables, compute cyclestartdate
(next Sunday after the census date) and weeksbetween for each current-term / next-term pair."""

df_termandcensusdatedataprep = read_table(f"{analytics}.{silver}.dim_term").alias(
    "termSetup"
)
df_termandcensusdatedataprep = df_termandcensusdatedataprep.join(
    read_table(f"{analytics}.{silver}.dim_session").alias("sessionSetup"),
    (F.col("termsetup.sourcekey") == F.col("sessionsetup.termSourceKey")),
    "inner",
)
df_termandcensusdatedataprep = df_termandcensusdatedataprep.join(
    read_table(f"{analytics}.{silver}.dim_term").alias("termSetupNext"),
    (
        F.col("termsetupnext.sourcekey")
        == F.when(
            F.substring(F.col("termsetup.sourcekey"), 4, 1).isin(["2", "5"]),
            (F.col("termsetup.sourcekey").cast("BIGINT") + F.lit(3)).cast("STRING"),
        )
        .when(
            (F.substring(F.col("termsetup.sourcekey"), 4, 1) == F.lit("8")),
            (F.col("termsetup.sourcekey").cast("BIGINT") + F.lit(4)).cast("STRING"),
        )
        .otherwise(F.lit(None))
    ),
    "inner",
)
df_termandcensusdatedataprep = df_termandcensusdatedataprep.join(
    read_table(f"{analytics}.{silver}.dim_session").alias("sessionSetupNext"),
    (F.col("termsetupnext.sourcekey") == F.col("sessionsetupnext.termSourceKey")),
    "inner",
)
df_termandcensusdatedataprep = df_termandcensusdatedataprep.filter(
    (
        (
            (
                (
                    (F.col("termsetup.sourcekey") >= F.lit(MinimumTerm))
                    & (
                        F.col("sessionsetup.sourcekey")
                        == F.when(
                            F.substring(F.col("termsetup.sourcekey"), 4, 1).isin(
                                ["2", "8"]
                            ),
                            F.lit("1"),
                        )
                        .when(
                            (
                                F.substring(F.col("termsetup.sourcekey"), 4, 1)
                                == F.lit("5")
                            ),
                            F.lit("11W"),
                        )
                        .otherwise(F.lit(None))
                    )
                )
                & (
                    F.col("sessionsetupnext.sourcekey")
                    == F.when(
                        F.substring(F.col("termsetupnext.sourcekey"), 4, 1).isin(
                            ["2", "8"]
                        ),
                        F.lit("1"),
                    )
                    .when(
                        (
                            F.substring(F.col("termsetupnext.sourcekey"), 4, 1)
                            == F.lit("5")
                        ),
                        F.lit("11W"),
                    )
                    .otherwise(F.lit(None))
                )
            )
            & F.col("sessionsetup.censusdate").isNotNull()
        )
        & F.col("sessionsetupnext.censusdate").isNotNull()
    )
)

_sunday_on_or_before_curr_session = F.date_sub(
    F.to_date(F.col("sessionSetup.censusdate")),
    F.dayofweek(F.to_date(F.col("sessionSetup.censusdate"))) - F.lit(1),
)
_sunday_on_or_before_next_session = F.date_sub(
    F.to_date(F.col("sessionSetupNext.censusdate")),
    F.dayofweek(F.to_date(F.col("sessionSetupNext.censusdate"))) - F.lit(1),
)
df_termandcensusdatedataprep = df_termandcensusdatedataprep.select(
    F.col("termSetup.sourcekey").alias("termsourcekey"),
    F.col("termSetup.description").alias("termdescription"),
    F.col("sessionSetup.censusdate").alias("censusdate"),
    F.to_timestamp(F.next_day(F.to_date(F.col("termSetup.censusdate")), "Sun")).alias(
        "cyclestartdate"
    ),
    F.col("termSetupNext.sourcekey").alias("nexttermsourcekey"),
    F.col("termSetupNext.description").alias("nexttermdescription"),
    F.col("sessionSetupNext.censusdate").alias("nexttermcensusdate"),
    (
        F.datediff(_sunday_on_or_before_next_session, _sunday_on_or_before_curr_session)
        / F.lit(7)
    )
    .cast("int")
    .alias("weeksbetween"),
)
df_termandcensusdatedataprep = df_termandcensusdatedataprep.distinct()
df_termandcensusdatedataprep = df_termandcensusdatedataprep.orderBy(
    F.col("termsourcekey").asc()
)

# COMMAND ----------

# DBTITLE 1,Cell 7
"""Build TermAndCensusDateDataPrep2: reshape to a cycle-term perspective, derive termsourcekey2 and
termsourcekey3 by applying the term-sequence offset rules, and exclude rows where cyclestartdate fell
in year 1900 (a sentinel for missing / invalid dates)."""

df_termandcensusdatedataprep2 = df_termandcensusdatedataprep.alias("termSetup")
df_termandcensusdatedataprep2 = df_termandcensusdatedataprep2.filter(
    F.year(F.col("termSetup.cyclestartdate")) != F.lit(1900)
)
df_termandcensusdatedataprep2 = df_termandcensusdatedataprep2.select(
    F.col("termsetup.nexttermsourcekey").alias("cycletermsourcekey"),
    F.col("termsetup.nexttermdescription").alias("cycletermdescription"),
    F.substring(F.col("termsetup.nexttermdescription"), 1, 4).alias("calendaryear"),
    F.col("termsetup.termsourcekey").alias("censustermsourcekey"),
    F.col("termsetup.termdescription").alias("censustermdescription"),
    F.col("termsetup.censusdate").alias("censustermcensusdate"),
    F.col("termsetup.nexttermsourcekey").alias("termsourcekey1"),
    F.col("termsetup.nexttermdescription").alias("termdescription1"),
    F.when(
        F.substring(F.col("termsetup.nexttermsourcekey"), 4, 1).isin(["2", "5"]),
        (F.col("termsetup.nexttermsourcekey").cast("BIGINT") + F.lit(3)).cast("STRING"),
    )
    .when(
        (F.substring(F.col("termsetup.nexttermsourcekey"), 4, 1) == F.lit("8")),
        (F.col("termsetup.nexttermsourcekey").cast("BIGINT") + F.lit(4)).cast("STRING"),
    )
    .otherwise(F.lit(None))
    .alias("termsourcekey2"),
    F.when(
        (F.substring(F.col("termsetup.nexttermsourcekey"), 4, 1) == F.lit("2")),
        (F.col("termsetup.nexttermsourcekey").cast("BIGINT") + F.lit(6)).cast("STRING"),
    )
    .when(
        (F.substring(F.col("termsetup.nexttermsourcekey"), 4, 1) == F.lit("5")),
        (F.col("termsetup.nexttermsourcekey").cast("BIGINT") + F.lit(7)).cast("STRING"),
    )
    .when(
        (F.substring(F.col("termsetup.nexttermsourcekey"), 4, 1) == F.lit("8")),
        (F.col("termsetup.nexttermsourcekey").cast("BIGINT") + F.lit(7)).cast("STRING"),
    )
    .otherwise(F.lit(None))
    .alias("termsourcekey3"),
    F.col("termsetup.cyclestartdate"),
    F.col("termsetup.nexttermcensusdate").alias("cycleenddate"),
    F.col("termsetup.weeksbetween"),
)
df_termandcensusdatedataprep2 = df_termandcensusdatedataprep2.distinct()

# COMMAND ----------

# DBTITLE 1,Create temp view: TermAndCensusDateData
"""Build TermAndCensusDateData and FunnelWeeksData: join in term descriptions for termsourcekey2 / 3,
then expand each admission cycle into one row per calendar day from cyclestartdate through cycleenddate,
assigning weeknumber, snapshotdate, snapshotdayofweek, and daynumber per day."""

df_termandcensusdatedata = df_termandcensusdatedataprep2.alias("termSetup")
df_termandcensusdatedata = df_termandcensusdatedata.join(
    read_table(f"{analytics}.{silver}.dim_term").alias("termSetup2"),
    (F.col("termsetup.termsourcekey2") == F.col("termsetup2.sourcekey")),
    "inner",
)
df_termandcensusdatedata = df_termandcensusdatedata.join(
    read_table(f"{analytics}.{silver}.dim_term").alias("termSetup3"),
    (F.col("termsetup.termsourcekey3") == F.col("termsetup3.sourcekey")),
    "inner",
)
df_termandcensusdatedata = df_termandcensusdatedata.select(
    F.col("termsetup.cycletermsourcekey"),
    F.col("termsetup.cycletermdescription"),
    F.col("termsetup.calendaryear"),
    F.col("termsetup.censustermsourcekey"),
    F.col("termsetup.censustermdescription"),
    F.col("termsetup.censustermcensusdate"),
    F.col("termsetup.termsourcekey1"),
    F.col("termsetup.termdescription1"),
    F.col("termsetup.termsourcekey2"),
    F.col("termsetup2.description").alias("termdescription2"),
    F.col("termsetup.termsourcekey3"),
    F.col("termsetup3.description").alias("termdescription3"),
    F.col("termsetup.cyclestartdate"),
    F.col("termsetup.cycleenddate"),
    F.col("termsetup.weeksbetween"),
)
df_termandcensusdatedata = df_termandcensusdatedata.distinct()
df_termandcensusdatedata = df_termandcensusdatedata.orderBy(
    F.col("cycletermsourcekey").asc()
)

df_FunnelWeeksData = (
    df_termandcensusdatedata.withColumn(
        "daynumber",
        F.explode(
            F.when(
                F.col("weeksbetween") >= F.lit(1),
                F.expr("sequence(1, CAST(F.coalesce(weeksbetween, 0) AS INT) * 7)"),
            )
        ),
    )
    .withColumn(
        "snapshotdate",
        F.expr(
            "CAST(date_add(CAST(cyclestartdate AS DATE), CAST(daynumber - 1 AS INT)) AS TIMESTAMP)"
        ),
    )
    .withColumn(
        "weeknumber",
        F.expr("CAST(CEIL(daynumber / 7.0) AS INT)"),
    )
    .withColumn(
        "snapshotdayofweek",
        F.date_format(F.col("snapshotdate"), "EEEE"),
    )
    .filter(
        (F.col("snapshotdate") >= F.col("cyclestartdate"))
        & (F.col("snapshotdate") <= F.col("cycleenddate"))
    )
    .select(
        F.substring(F.col("cycletermsourcekey").cast("string"), 1, 4).alias(
            "cycletermsourcekey"
        ),
        F.substring(F.col("cycletermdescription").cast("string"), 1, 30).alias(
            "cycletermdescription"
        ),
        F.substring(F.col("calendaryear").cast("string"), 1, 30).alias("calendaryear"),
        F.substring(F.col("censustermsourcekey").cast("string"), 1, 4).alias(
            "censustermsourcekey"
        ),
        F.substring(F.col("censustermdescription").cast("string"), 1, 30).alias(
            "censustermdescription"
        ),
        F.col("censustermcensusdate").cast("timestamp").alias("censustermcensusdate"),
        F.substring(F.col("termsourcekey1").cast("string"), 1, 4).alias(
            "termsourcekey1"
        ),
        F.substring(F.col("termdescription1").cast("string"), 1, 30).alias(
            "termdescription1"
        ),
        F.substring(F.col("termsourcekey2").cast("string"), 1, 4).alias(
            "termsourcekey2"
        ),
        F.substring(F.col("termdescription2").cast("string"), 1, 30).alias(
            "termdescription2"
        ),
        F.substring(F.col("termsourcekey3").cast("string"), 1, 4).alias(
            "termsourcekey3"
        ),
        F.substring(F.col("termdescription3").cast("string"), 1, 30).alias(
            "termdescription3"
        ),
        F.col("cyclestartdate").cast("timestamp").alias("cyclestartdate"),
        F.col("cycleenddate").cast("timestamp").alias("cycleenddate"),
        F.col("weeknumber").cast("bigint").alias("weeknumber"),
        F.col("snapshotdate").cast("timestamp").alias("snapshotdate"),
        F.substring(F.col("snapshotdayofweek").cast("string"), 1, 9).alias(
            "snapshotdayofweek"
        ),
        F.col("daynumber").cast("bigint").alias("daynumber"),
    )
)

df_FunnelWeeksData = df_FunnelWeeksData.orderBy(
    F.col("cycletermsourcekey").asc(),
    F.col("weeknumber").asc(),
    F.col("snapshotdate").asc(),
)

# COMMAND ----------

# DBTITLE 1,Cell 9
"""Write output: cast WEEKNUMBER and DAYNUMBER to BIGINT, then overwrite the target Delta table
analytics_dev.staging.dim_admissions_funnel_weekly with the final funnel weeks dataset."""

df_uta_adm_dim_fun_wk_trn = df_FunnelWeeksData
_num_cols_uta_adm_dim_fun_wk_trn = {"DAYNUMBER", "WEEKNUMBER"}
df_uta_adm_dim_fun_wk_trn = df_uta_adm_dim_fun_wk_trn.select(
    *[
        F.col(c).cast("bigint").alias(c)
        if c.upper() in _num_cols_uta_adm_dim_fun_wk_trn
        else F.col(c)
        for c in df_uta_adm_dim_fun_wk_trn.columns
    ]
)
write_df_to_table(
    df_uta_adm_dim_fun_wk_trn, f"{analytics}.{staging}.dim_admissions_funnel_weekly"
)

# COMMAND ----------

# DBTITLE 1,Cell 10
"""Log job completion: record end timestamp and print total elapsed duration for the pipeline run."""

_job_end_time = datetime.now()
_job_elapsed = _job_end_time - _job_start_time
log_msg(
    f"Job completed: transform_analytics_dim_admissions_funnel_weekly | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} | Elapsed: {str(_job_elapsed)}",
    "info",
)
