# Databricks notebook source
# /// script
# [tool.databricks.environment]
# environment_version = "5"
# ///
# MAGIC %run ./global_properties

# COMMAND ----------

"""
Common Utilities for SAS-to-PySpark Converted Code

Provides reusable helper functions used across all converted notebooks.
Import in each notebook:
    %run ./common_utils
"""

import os
import logging
from logging.handlers import RotatingFileHandler
import smtplib
try:
    from ai_data_auditor import auditor
except Exception:
    auditor = None
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from pyspark.sql import SparkSession, DataFrame
from pyspark.sql import functions as F
from pyspark.sql.functions import udf
from datetime import datetime, date
from pyspark.sql.types import IntegerType, DoubleType, StringType
from datetime import date
import calendar
import re
import boto3
import json

spark = SparkSession.builder.getOrCreate()


@udf(returnType=IntegerType())
def sas_yrdif_age(birth_dt, census_dt):
    """
    Exact replica of SAS INT(YRDIF(start, end, 'ACT/ACT'))
    Uses ISDA ACT/ACT convention: splits interval at Jan 1 boundaries
    and sums fractional years per actual days in each calendar year.
    """
    if birth_dt is None or census_dt is None:
        return None

    # Ensure date type
    if hasattr(birth_dt, "date"):
        birth_dt = birth_dt.date()
    if hasattr(census_dt, "date"):
        census_dt = census_dt.date()

    sy = birth_dt.year
    ey = census_dt.year

    # Guard against year overflow (PeopleSoft sentinel dates like 9999-12-31)
    if sy >= 9999 or ey >= 9999:
        return None

    # Helper: days in a given year (handles leap years)
    def days_in_year(y):
        return 366 if calendar.isleap(y) else 365

    if sy == ey:
        # Same year: simple fraction
        total = (census_dt - birth_dt).days / days_in_year(sy)
    else:
        # Fraction remaining in start year
        start_next_jan1 = date(sy + 1, 1, 1)
        frac_start = (start_next_jan1 - birth_dt).days / days_in_year(sy)

        # Full intermediate years
        full_years = ey - sy - 1

        # Fraction elapsed in end year
        end_jan1 = date(ey, 1, 1)
        frac_end = (census_dt - end_jan1).days / days_in_year(ey)

        total = frac_start + full_years + frac_end

    # SAS INT() truncates toward zero
    return int(total)


spark.udf.register("sas_yrdif_age", sas_yrdif_age)


@udf(returnType=DoubleType())
def sas_yrdif_age_dbl(birth_dt, census_dt):
    """
    Decimal (double) variant of sas_yrdif_age — returns full fractional years without INT() truncation.
    """
    if birth_dt is None or census_dt is None:
        return None

    # Ensure date type
    if hasattr(birth_dt, "date"):
        birth_dt = birth_dt.date()
    if hasattr(census_dt, "date"):
        census_dt = census_dt.date()

    sy = birth_dt.year
    ey = census_dt.year

    # Guard against year overflow (PeopleSoft sentinel dates like 9999-12-31)
    if sy >= 9999 or ey >= 9999:
        return None

    # Helper: days in a given year (handles leap years)
    def days_in_year(y):
        return 366 if calendar.isleap(y) else 365

    if sy == ey:
        # Same year: simple fraction
        total = (census_dt - birth_dt).days / days_in_year(sy)
    else:
        # Fraction remaining in start year
        start_next_jan1 = date(sy + 1, 1, 1)
        frac_start = (start_next_jan1 - birth_dt).days / days_in_year(sy)

        # Full intermediate years
        full_years = ey - sy - 1

        # Fraction elapsed in end year
        end_jan1 = date(ey, 1, 1)
        frac_end = (census_dt - end_jan1).days / days_in_year(ey)

        total = frac_start + full_years + frac_end

    return total


spark.udf.register("sas_yrdif_age_dbl", sas_yrdif_age_dbl)


# ---------------------------------------------------------------------------
#  Logger setup — automatically uses the calling notebook's name
# ---------------------------------------------------------------------------


def _get_notebook_name() -> str:
    """Return the name of the currently running (parent) notebook."""
    try:
        nb_path = (
            dbutils.notebook.entry_point.getDbutils()
            .notebook()
            .getContext()
            .notebookPath()
            .get()
        )
        return nb_path.split("/")[-1]
    except Exception:
        return "etl"


_notebook_name = _get_notebook_name()
logger = logging.getLogger(_notebook_name)
logger.propagate = False  # Prevent duplicate output from root logger

# ---------------------------------------------------------------------------
#  File handling functionality to hold and persist logs to disk
# ---------------------------------------------------------------------------
_f = globals().get("__file__")
_script_dir = os.path.dirname(os.path.abspath(_f)) if _f else os.getcwd()
_log_dir = os.environ.get(
    "LOG_DIR",
    "/tmp/sas_poc/logs" if os.path.exists("/tmp") else os.path.join(_script_dir, "logs")
)
try:
    os.makedirs(_log_dir, exist_ok=True)
except Exception:
    pass

_log_file = os.path.join(_log_dir, "migration_pipeline.log")

if not logger.handlers:
    _formatter = logging.Formatter(
        f"%(asctime)s [{_notebook_name}] [%(levelname)s] : %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    
    # 1. Console Stream Handler
    _stream_handler = logging.StreamHandler()
    _stream_handler.setFormatter(_formatter)
    logger.addHandler(_stream_handler)
    
    # 2. File Handler to hold and persist logs to disk (with rotation up to 10MB, 5 backups)
    try:
        _file_handler = RotatingFileHandler(
            _log_file,
            maxBytes=10 * 1024 * 1024,
            backupCount=5,
            encoding="utf-8"
        )
        _file_handler.setFormatter(_formatter)
        logger.addHandler(_file_handler)
    except Exception as _fe:
        try:
            _file_handler = logging.FileHandler(_log_file, encoding="utf-8")
            _file_handler.setFormatter(_formatter)
            logger.addHandler(_file_handler)
        except Exception:
            pass

    logger.setLevel(logging.INFO)


def get_log_file_path() -> str:
    """Return the absolute path to the active log file."""
    return _log_file


def log_msg(msg: str, level: str = "info") -> None:
    """Log a message at the specified level (info, warn, error, debug) and persist directly to log file."""
    level_fn = {
        "info": logger.info,
        "warn": logger.warning,
        "warning": logger.warning,
        "error": logger.error,
        "debug": logger.debug,
    }
    level_fn.get(level.lower(), logger.info)(msg)
    
    # Direct synchronous flush to migration_pipeline.log file
    try:
        t_stamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(_log_file, "a", encoding="utf-8") as _lf:
            _lf.write(f"[{t_stamp}] [{_notebook_name}] [{level.upper()}] : {msg}\n")
            _lf.flush()
    except Exception:
        pass


# ---------------------------------------------------------------------------
#  Core query execution
# ---------------------------------------------------------------------------


def execute_query(
    sql: str,
    temp_view_name: str = None,
    target_table: str = None,
    collect: bool = False,
    drop_first: bool = False,
    description: str = None,
) -> DataFrame:
    """Execute a SQL query with optional temp-view creation or table persistence.

    Parameters
    ----------
    sql : str
        The SQL query to execute.
    temp_view_name : str, optional
        If provided, the result is registered as a temp view with this name.
    target_table : str, optional
        If provided, the result is written as a managed table (overwrite mode).
    collect : bool, optional
        If True, return collected rows (list[Row]) instead of DataFrame.
    drop_first : bool, optional
        If True, drop the target table/view before creating it.
    description : str, optional
        A human-readable label printed for logging/debugging.

    Returns
    -------
    DataFrame or list[Row]
        The query result as a DataFrame, or collected rows if collect=True.
    """
    if description:
        log_msg(description)

    if drop_first:
        name = temp_view_name or target_table
        if name:
            drop_table(name)

    df = spark.sql(sql)

    if temp_view_name:
        df.createOrReplaceTempView(temp_view_name)

    if target_table:
        df.write.mode("overwrite").saveAsTable(target_table)

    if collect:
        return df.collect()

    return df


# ---------------------------------------------------------------------------
#  Table helpers
# ---------------------------------------------------------------------------

# COMMAND ----------

# DBTITLE 1,Cell 3
def read_table(table_name: str) -> DataFrame:
    """Read a table or temp view into a DataFrame.
    
    Supports native Databricks catalog tables (Unity Catalog and Hive Metastore),
    and automatically falls back to local SQLite database (sqlite_data.db) or 
    migrated_tables CSVs when running outside of Databricks.
    """
    try:
        return spark.table(table_name)
    except Exception:
        pass

    # Extract short table name (e.g. 'analytics_dev.silver.fact_student_class' -> 'fact_student_class')
    short_name = table_name.split(".")[-1].strip("`\" ")
    
    # Check across standard schemas in Unity Catalog and Hive Metastore
    candidate_schemas = [
        f"workspace.silver.{short_name}",
        f"workspace.staging.{short_name}",
        f"workspace.reference.{short_name}",
        f"workspace.maco.{short_name}",
        f"workspace.default.{short_name}",
        f"silver.{short_name}",
        f"staging.{short_name}",
        f"reference.{short_name}",
        f"maco.{short_name}",
        f"default.{short_name}",
        f"analytics_dev.silver.{short_name}",
        f"analytics_dev.staging.{short_name}",
        f"analytics_dev.reference.{short_name}",
        f"finance.maco.{short_name}",
        f"global_temp.{short_name}",
    ]
    for full_tbl in candidate_schemas:
        try:
            return spark.table(full_tbl)
        except Exception:
            pass

    # Check local SQLite database fallback
    base_dir = os.path.dirname(_script_dir)
    sqlite_db_path = os.path.join(base_dir, "sqlite_data.db")
    csv_table_path = os.path.join(base_dir, "migrated_tables", f"{short_name}.csv")

    if os.path.exists(csv_table_path):
        df = spark.read.option("header", "true").option("inferSchema", "true").csv(csv_table_path)
        df.createOrReplaceTempView(short_name)
        try:
            df.createOrReplaceTempView(table_name)
        except Exception:
            pass
        log_msg(f"read_table: Loaded '{table_name}' from CSV fallback ({csv_table_path})")
        return df

    if os.path.exists(sqlite_db_path):
        try:
            import sqlite3
            import pandas as pd
            conn = sqlite3.connect(sqlite_db_path)
            pdf = pd.read_sql_query(f'SELECT * FROM "{short_name}"', conn)
            conn.close()
            # Write temp CSV and read via Spark JVM reader
            temp_csv = os.path.join(base_dir, "migrated_tables", f"{short_name}.csv")
            os.makedirs(os.path.dirname(temp_csv), exist_ok=True)
            pdf.to_csv(temp_csv, index=False)
            df = spark.read.option("header", "true").option("inferSchema", "true").csv(temp_csv)
            df.createOrReplaceTempView(short_name)
            log_msg(f"read_table: Loaded '{table_name}' from SQLite fallback ({sqlite_db_path})")
            return df
        except Exception as e:
            log_msg(f"read_table: Failed loading from SQLite fallback: {e}", level="warn")

    return spark.table(table_name)


def write_df_to_table(
    df: DataFrame,
    table_name: str,
    mode: str = "overwrite",
    fmt: str = "delta",
    dedup_before_append: bool = False,
    primary_keys: list = None,
    **kwargs,
) -> None:
    """Write a DataFrame to a managed table.

    Parameters
    ----------
    df : DataFrame
        The DataFrame to persist.
    table_name : str
        Fully-qualified table name (catalog.schema.table).
    mode : str
        Write mode — "overwrite" (default), "append", "ignore", "error".
    fmt : str
        Output format — "delta" (default), "parquet", "csv", etc.
    dedup_before_append : bool, optional
        Only active when mode="append". If True, filters out rows that
        already exist in the target table before appending:
        - With primary_keys: left-anti join on the given key columns.
        - Without primary_keys: row-level dedup via DataFrame.subtract()
          (compares all columns; equivalent to EXCEPT ALL in SQL).
        Silently skipped if the target table does not yet exist.
    primary_keys : list[str], optional
        Column names that uniquely identify a row. Used only when
        dedup_before_append=True. If omitted, full-row comparison is used.
    **kwargs : dict
        Additional writer options passed to .options().
        Examples: overwriteSchema="true", mergeSchema="true",
                  compression="snappy", maxRecordsPerFile=100000,
                  partitionBy="col1,col2".

    Usage
    -----
    # Append with primary-key dedup (no duplicate TERM_SK rows)
    write_df_to_table(df, "catalog.schema.my_table",
                      mode="append", dedup_before_append=True,
                      primary_keys=["TERM_SK"])

    # Append with full-row dedup (no identical rows)
    write_df_to_table(df, "catalog.schema.my_table",
                      mode="append", dedup_before_append=True)
    """
    log_msg(
        f"write_df_to_table: START | table={table_name} | mode={mode} | format={fmt}"
    )
    if kwargs:
        log_msg(f"write_df_to_table: options={kwargs}")

    if dedup_before_append and mode == "append" and table_exists(table_name):
        existing = spark.table(table_name)
        df_before_dedup = df
        if primary_keys:
            # Keep only rows whose key combination is not already in the table
            df = df.join(
                existing.select(primary_keys), on=primary_keys, how="left_anti"
            )
            log_msg(
                f"dedup_before_append: filtered on keys {primary_keys} before appending to {table_name}"
            )
        else:
            # Full-row comparison: subtract rows already present (EXCEPT semantics)
            df = df.subtract(existing)
            log_msg(
                f"dedup_before_append: full-row subtract before appending to {table_name}"
            )

        # AI Data Audit: Record exact deduplication loss for root-cause analysis
        if auditor:
            try:
                auditor.audit_transformation_step(
                    df_before=df_before_dedup,
                    df_after=df,
                    step_name=f"dedup_before_append_{table_name.split('.')[-1]}",
                    transformation_type="DEDUP",
                    pipeline_name=_notebook_name,
                    key_cols=primary_keys,
                    drop_reason=f"Records already existed in target table {table_name}"
                )
            except Exception as _ae:
                log_msg(f"AI audit recording error: {_ae}", level="debug")

    try:
        writer = df.write.format(fmt).mode(mode)
        if kwargs:
            writer = writer.options(**kwargs)
        writer.saveAsTable(table_name)
    except Exception as e:
        log_msg(f"saveAsTable failed ({e}), writing to local CSV/table fallback...", level="warn")
        short_name = table_name.split(".")[-1].strip("`\" ")
        base_dir = os.path.dirname(_script_dir)
        csv_out = os.path.join(base_dir, "migrated_tables", f"{short_name}.csv")
        try:
            df.toPandas().to_csv(csv_out, index=False)
            log_msg(f"write_df_to_table: Successfully saved fallback to {csv_out}")
        except Exception as e2:
            log_msg(f"Fallback CSV write error: {e2}", level="error")

    log_msg(f"write_df_to_table: COMPLETE | table={table_name}")


# ---------------------------------------------------------------------------
#  AI Data Loss & Value Mutation Audit Helpers
# ---------------------------------------------------------------------------


def audit_step(
    df_before,
    df_after,
    step_name: str,
    transformation_type: str = "TRANSFORM",
    key_cols: list = None,
    drop_reason: str = None
) -> dict:
    """Audit row loss, filter exclusions, or join mismatches for AI root cause detection."""
    if auditor:
        return auditor.audit_transformation_step(
            df_before=df_before,
            df_after=df_after,
            step_name=step_name,
            transformation_type=transformation_type,
            pipeline_name=_notebook_name,
            key_cols=key_cols,
            drop_reason=drop_reason
        )
    return {}


def audit_value_drift(
    df_before,
    df_after,
    step_name: str,
    key_col: str = None,
    check_cols: list = None
) -> dict:
    """Audit value mutations, data drift, or null surges for AI root cause detection."""
    if auditor:
        return auditor.audit_value_mutation(
            df_before=df_before,
            df_after=df_after,
            step_name=step_name,
            pipeline_name=_notebook_name,
            key_col=key_col,
            check_cols=check_cols
        )
    return {}


def drop_table(name: str) -> None:
    """Drop a table or temp view if it exists (silent no-op if missing)."""
    try:
        spark.sql(f"DROP TABLE IF EXISTS {name}")
    except Exception:
        try:
            spark.catalog.dropTempView(name)
        except Exception:
            pass


def table_exists(name: str) -> bool:
    """Check whether a table or temp view exists."""
    try:
        df = spark.table(name)
        df.count()
        return True
    except Exception:
        return False


def get_count(table_or_df) -> int:
    """Return the row count of a table name (str) or DataFrame.

    Only computes the count when ``debug_mode`` (from global_properties) is True.
    When debug_mode is False, logs a message and returns 0 to avoid costly
    count operations in production runs.

    Parameters
    ----------
    table_or_df : str or DataFrame
        Table name or DataFrame to count.
    """
    if not debug_mode:
        log_msg(
            "get_count: debug mode is off — skipping count, returning 0", level="info"
        )
        return 0

    if isinstance(table_or_df, str):
        return spark.table(table_or_df).count()
    return table_or_df.count()


def get_current_term() -> int:
    # Global/local vars: CurrentTerm
    CurrentTerm = None


    df_termSetup = spark.table(f"{analytics}.{silver}.dim_term").alias("termSetup")
    df_sessionSetup = spark.table(f"{analytics}.{silver}.dim_session").alias("sessionSetup")
    df_termSetupNext = df_termSetup.alias("termSetupNext")
    df_sessionSetupNext = df_sessionSetup.alias("sessionSetupNext")

    df_current_term = (
        df_termSetup
        .join(
            df_sessionSetup,
            (F.col("termSetup.institution") == F.col("sessionSetup.institution"))
            & (F.col("termSetup.sourcekey") == F.col("sessionSetup.termsourcekey")),
            "inner"
        )
        .join(
            df_termSetupNext,
            F.col("termSetup.institution") == F.col("termSetupNext.institution"),
            "inner"
        )
        .join(
            df_sessionSetupNext,
            (F.col("termSetupNext.institution") == F.col("sessionSetupNext.institution"))
            & (F.col("termSetupNext.sourcekey") == F.col("sessionSetupNext.termsourcekey")),
            "inner"
        )
        .where(F.col("termSetup.institution") == F.lit("UTARL"))
        .where(
            F.col("sessionSetup.sourcekey") == F.when(
                F.substring(F.col("termSetup.sourcekey"), 4, 1).isin("2", "8"), F.lit("1")
            ).when(
                F.substring(F.col("termSetup.sourcekey"), 4, 1) == F.lit("5"), F.lit("14W")
            ).otherwise(F.lit(""))
        )
        .where(F.col("termSetupNext.SourceKey") == F.col("termSetup.nextanycategorytermsourcekey"))
        .where(
            F.col("sessionSetupNext.sourcekey") == F.when(
                F.substring(F.col("termSetupNext.sourcekey"), 4, 1).isin("2", "8"), F.lit("1")
            ).when(
                F.substring(F.col("termSetupNext.sourcekey"), 4, 1) == F.lit("5"), F.lit("14W")
            ).otherwise(F.lit(""))
        )
        .where(F.current_date() >= F.col("sessionSetup.SessionBeginDate"))
        .where(F.current_date() < F.col("sessionSetupNext.SessionBeginDate"))
        .select(
            F.concat_ws("",
                F.collect_set(F.col("termSetup.SourceKey"))
            ).alias("CurrentTerm")
        )
    )

    CurrentTerm = df_current_term.collect()[0]["CurrentTerm"]
    return int(CurrentTerm)


# ---------------------------------------------------------------------------
#  ETL / audit helpers
# ---------------------------------------------------------------------------

# COMMAND ----------

# DBTITLE 1,Cell 4
def log_etl_status(job_name: str, status: str, record_count: int = None) -> None:
    """Log a structured ETL status message."""
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    msg = f"{ts} | {job_name} | {status}"
    if record_count is not None:
        msg += f" | rows={record_count}"
    log_msg(msg)


def send_email(
    mail_body,
    to_email,
    subject,
    cc="",
    bcc="",
    attachment_file=None,
    from_email=None,
    is_html=False,
):
    

    boto3_session = boto3.Session(
        botocore_session=dbutils.credentials.getServiceCredentialsProvider(
            credentials_provider
        ),
        region_name=aws_region,
    )
    sm = boto3_session.client("secretsmanager")
    resp = sm.get_secret_value(SecretId=secret_id)
    secret_value = resp["SecretString"]
    secret_json = json.loads(secret_value)
    username = secret_json[smtp_username_key]
    password = secret_json[smtp_password_key]

    from_email = from_email or username

    # Override recipients for DEV/SIT runs
    if non_prod_run:
        log_msg(
            f"non prod run detected — overriding to_email from '{to_email}' to {non_prod_to_email}",
            level="info",
        )
        log_msg(
            "non prod run: cc and bcc cleared to prevent unintended delivery",
            level="info",
        )
        to_email = non_prod_to_email
        cc = ""
        bcc = ""

    def _normalize_addresses(addr):
        # Accept string or list, return de-duplicated, trimmed addresses
        if not addr:
            return []

        if isinstance(addr, list):
            raw_items = addr
        else:
            # Allow comma-separated string too
            raw_items = [a for chunk in str(addr).split(",") for a in [chunk]]

        seen, result = set(), []
        for item in raw_items:
            cleaned = str(item).strip()
            if cleaned and cleaned not in seen:
                seen.add(cleaned)
                result.append(cleaned)
        return result

    to_list = _normalize_addresses(to_email)
    cc_list = _normalize_addresses(cc)
    bcc_list = _normalize_addresses(bcc)

    # Envelope recipients must include To + Cc + Bcc
    envelope_recipients = list(dict.fromkeys(to_list + cc_list + bcc_list))

    if not envelope_recipients:
        raise ValueError("send_email: no recipients supplied in to_email, cc, or bcc")

    sender_email = from_email

    # Create multipart message and set headers
    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = ", ".join(to_list)
    if cc_list:
        message["Cc"] = ", ".join(cc_list)
    message["Subject"] = subject

    # Do not add Bcc header to avoid exposing Bcc recipients

    # Add body to email
    subtype = "html" if is_html else "plain"
    message.attach(MIMEText(mail_body, subtype))

    # Attach file only if provided
    if attachment_file:
        with open(attachment_file, "rb") as attachment:
            part = MIMEBase("application", "octet-stream")
            part.set_payload(attachment.read())
        encoders.encode_base64(part)
        part.add_header(
            "Content-Disposition",
            "attachment; filename=" + attachment_file.split("/")[-1],
        )
        message.attach(part)

    text = message.as_string()

    # Log in to server using secure context and send email
    try:
        smtp_obj = smtplib.SMTP(smtp_server, smtp_port)
        smtp_obj.ehlo()
        smtp_obj.starttls()
        smtp_obj.login(username, password)
        smtp_obj.sendmail(sender_email, envelope_recipients, text)
        smtp_obj.quit()
        log_msg("Sent Mail Successfully")
    except Exception as e:
        log_msg(str(e), level="error")
        raise Exception("Exception Occurred in sending mail : " + str(e))

# COMMAND ----------

@udf(returnType=StringType())
def title_case_after_punctuation(text):
    if text is None:
        return None

    text = text.lower()
    text = re.sub(r'(^|[\s\-/&.,;:(])([a-z])',
                  lambda m: m.group(1) + m.group(2).upper(),
                  text)
    return text

spark.udf.register("title_case_after_punctuation", title_case_after_punctuation)

# COMMAND ----------


# DDH_GetUGRDFunnelTerms transformation
def build_ddh_get_ugrd_funnel_terms() -> DataFrame:
    """
    PySpark DataFrame-API conversion of DDH UGRD Funnel Terms PROC SQL logic.
    Returns final output equivalent to utacsrpt.DDH_GetUGRDFunnelTerms.

    Source tables are read internally from `{temp_impetus}.{bronze}`.

    Usage:
        %run ../common/global_properties
        %run ../common/common_utils

        final_df = build_ddh_get_ugrd_funnel_terms()
    """

    # 0) Source extracts
    uta_adm_ugrd_funnel_df = read_table(f"{analytics}.{silver}.fact_admissions_undergraduate_funnel")
    ps_session_tbl_extract_df = read_table(f"{student}.{bronze}.ps_session_tbl")
    ps_term_tbl_extract_df = read_table(f"{student}.{bronze}.ps_term_tbl")
    dim_uta_term_df = read_table(f"{analytics}.{silver}.dim_term")

    # 1) UGRD funnel admit terms by snapshot date
    df_ugrd_funnel_snapdate_terms = uta_adm_ugrd_funnel_df.select(
        F.col("snapdate_ymd"),
        F.col("admit_term"),
        F.col("admit_term_descr"),
    ).distinct()

    # Distinct snapshot dates, used later to validate comparison snapshot dates
    df_snapdate_list = df_ugrd_funnel_snapdate_terms.select("snapdate_ymd").distinct()

    # 2) Census date, begin and end dates for UGRD terms
    # Main session is '1' for fall (%8) / spring (%2) and '5W2' for summer (%5)
    df_term_census_date = (
        ps_session_tbl_extract_df.alias("sess_tbl")
        .join(
            ps_term_tbl_extract_df.alias("term_tbl"),
            (
                (F.col("sess_tbl.strm") == F.col("term_tbl.strm"))
                & (F.col("sess_tbl.acad_career") == F.col("term_tbl.acad_career"))
            ),
            "left",
        )
        .filter(
            (F.col("sess_tbl.acad_career") == F.lit("UGRD"))
            & (
                (
                    (
                        F.col("sess_tbl.strm").endswith("2")
                        | F.col("sess_tbl.strm").endswith("8")
                    )
                    & (F.col("sess_tbl.session_code") == F.lit("1"))
                )
                | (
                    F.col("sess_tbl.strm").endswith("5")
                    & (F.col("sess_tbl.session_code") == F.lit("5W2"))
                )
            )
        )
        .select(
            F.col("sess_tbl.strm").alias("strm"),
            F.col("term_tbl.term_begin_dt").cast("date").alias("term_begin_dt"),
            F.col("term_tbl.term_end_dt").cast("date").alias("term_end_dt"),
            F.lpad(
                (F.col("sess_tbl.strm").cast("int") + F.lit(10)).cast("string"), 4, "0"
            ).alias("compare_next_term"),
            F.lpad(
                (F.col("sess_tbl.strm").cast("int") - F.lit(10)).cast("string"), 4, "0"
            ).alias("compare_previous_term"),
            F.date_format(F.col("sess_tbl.census_dt").cast("date"), "yyyyMMdd").alias(
                "census_date"
            ),
            # Change report term starts three days after census
            F.date_format(
                F.date_add(F.col("sess_tbl.census_dt").cast("date"), 3), "yyyyMMdd"
            ).alias("change_rpt_term_start_dt"),
        )
        .distinct()
    )

    # 3) Add census date and snapdate_term to the UGRD funnel admit terms by snapshot date
    df_ugrd_funnel_terms_census = (
        df_ugrd_funnel_snapdate_terms.alias("funnel_terms")
        .join(
            df_term_census_date.alias("term_dates"),
            (F.col("funnel_terms.admit_term") == F.col("term_dates.strm")),
            "inner",
        )
        .select(
            F.col("funnel_terms.snapdate_ymd"),
            F.col("funnel_terms.admit_term"),
            F.col("funnel_terms.admit_term_descr"),
            F.when(
                F.to_date(F.col("funnel_terms.snapdate_ymd"), "yyyyMMdd").between(
                    F.col("term_dates.term_begin_dt"), F.col("term_dates.term_end_dt")
                ),
                F.col("term_dates.strm"),
            ).alias("snapdate_term"),
            F.col("term_dates.census_date"),
            F.col("term_dates.change_rpt_term_start_dt"),
            F.col("term_dates.compare_next_term"),
            F.col("term_dates.compare_previous_term"),
        )
    )

    # 4) One snapdate_term / census date / change report start date per snapshot date,
    # taken from the admit term that contains the snapshot date
    df_snapdate_term_lookup = (
        df_ugrd_funnel_terms_census.filter(
            F.col("snapdate_term") == F.col("admit_term")
        )
        .groupBy("snapdate_ymd")
        .agg(
            F.max("snapdate_term").alias("lkp_snapdate_term"),
            F.max("census_date").alias("lkp_snapdate_term_census_dt"),
            F.max("change_rpt_term_start_dt").alias("lkp_change_rpt_term_start_dt"),
        )
        .select(
            F.col("snapdate_ymd").alias("lkp_snapdate_ymd"),
            F.col("lkp_snapdate_term"),
            F.col("lkp_snapdate_term_census_dt"),
            F.col("lkp_change_rpt_term_start_dt"),
        )
    )

    # Number of admit terms open on each snapshot date
    df_snapdate_admit_term_cnt = (
        df_ugrd_funnel_terms_census.groupBy("snapdate_ymd")
        .agg(F.count("admit_term").alias("cnt_snapdate_admit_term_cnt"))
        .select(
            F.col("snapdate_ymd").alias("cnt_snapdate_ymd"),
            F.col("cnt_snapdate_admit_term_cnt"),
        )
    )

    # 5) Add snapdate_term, snapdate_term_census_dt and Change_Rpt_term_Start_DT per snapshot date
    df_ugrd_funnel_snapdate_terms1 = (
        df_ugrd_funnel_terms_census.alias("funnel_census")
        .join(
            df_snapdate_term_lookup.alias("snap_lkp"),
            (F.col("funnel_census.snapdate_ymd") == F.col("snap_lkp.lkp_snapdate_ymd")),
            "left",
        )
        .join(
            df_snapdate_admit_term_cnt.alias("term_cnt"),
            (F.col("funnel_census.snapdate_ymd") == F.col("term_cnt.cnt_snapdate_ymd")),
            "left",
        )
        .select(
            F.col("funnel_census.snapdate_ymd"),
            F.col("funnel_census.admit_term"),
            F.col("funnel_census.admit_term_descr"),
            F.col("snap_lkp.lkp_snapdate_term").alias("snapdate_term"),
            F.col("term_cnt.cnt_snapdate_admit_term_cnt").alias(
                "snapdate_admit_term_cnt"
            ),
            F.col("snap_lkp.lkp_snapdate_term_census_dt").alias(
                "snapdate_term_census_dt"
            ),
            F.col("snap_lkp.lkp_change_rpt_term_start_dt").alias(
                "change_rpt_term_start_dt"
            ),
            F.col("funnel_census.compare_next_term"),
            F.col("funnel_census.compare_previous_term"),
        )
    )

    # Fallback for snapshot dates that fall between terms: the minimum admit term of that snapshot
    df_snapdate_min_admit_term = (
        df_ugrd_funnel_snapdate_terms1.groupBy("snapdate_ymd")
        .agg(F.min("admit_term").alias("min_admit_term"))
        .alias("min_term")
        .join(
            df_term_census_date.alias("term_dates"),
            (F.col("min_term.min_admit_term") == F.col("term_dates.strm")),
            "left",
        )
        .select(
            F.col("min_term.snapdate_ymd").alias("fb_snapdate_ymd"),
            F.col("min_term.min_admit_term").alias("fb_snapdate_term"),
            F.col("term_dates.census_date").alias("fb_snapdate_term_census_dt"),
            F.col("term_dates.change_rpt_term_start_dt").alias(
                "fb_change_rpt_term_start_dt"
            ),
        )
        .distinct()
    )

    # 6) Add min(admit_term) for the snapshot date as snapdate_term for in-between terms
    df_ugrd_funnel_snapdate_terms2 = (
        df_ugrd_funnel_snapdate_terms1.alias("funnel_snap")
        .join(
            df_snapdate_min_admit_term.alias("fallback"),
            (F.col("funnel_snap.snapdate_ymd") == F.col("fallback.fb_snapdate_ymd")),
            "left",
        )
        .select(
            F.col("funnel_snap.snapdate_ymd"),
            F.col("funnel_snap.admit_term"),
            F.col("funnel_snap.admit_term_descr"),
            F.coalesce(
                F.col("funnel_snap.snapdate_term"), F.col("fallback.fb_snapdate_term")
            ).alias("snapdate_term"),
            F.col("funnel_snap.snapdate_admit_term_cnt"),
            F.coalesce(
                F.col("funnel_snap.snapdate_term_census_dt"),
                F.col("fallback.fb_snapdate_term_census_dt"),
            ).alias("snapdate_term_census_dt"),
            F.coalesce(
                F.col("funnel_snap.change_rpt_term_start_dt"),
                F.col("fallback.fb_change_rpt_term_start_dt"),
            ).alias("change_rpt_term_start_dt"),
            F.col("funnel_snap.compare_next_term"),
            F.col("funnel_snap.compare_previous_term"),
        )
        .distinct()
    )

    # 7) Add report terms and the prior-year comparison snapshot date
    df_ugrd_funnel_report_terms = df_ugrd_funnel_snapdate_terms2.select(
        F.col("snapdate_ymd"),
        F.col("admit_term"),
        F.col("admit_term_descr"),
        F.col("snapdate_term"),
        F.col("snapdate_term_census_dt"),
        F.col("change_rpt_term_start_dt"),
        F.date_format(
            F.add_months(F.to_date(F.col("snapdate_ymd"), "yyyyMMdd"), -12), "yyyyMMdd"
        ).alias("comparison_snapdate"),
        F.col("compare_previous_term").alias("comparison_admit_term"),
        F.when(F.col("snapdate_admit_term_cnt") <= F.lit(3), F.col("admit_term"))
        # Before the report term change start date exclude the future term
        .when(
            (
                (F.col("snapdate_ymd") < F.col("change_rpt_term_start_dt"))
                & (F.col("snapdate_term") != F.col("compare_previous_term"))
                & (F.col("admit_term") >= F.col("snapdate_term"))
            ),
            F.col("admit_term"),
        )
        .when(
            (
                (F.col("snapdate_ymd") >= F.col("change_rpt_term_start_dt"))
                & (F.col("admit_term") != F.col("snapdate_term"))
                & (F.col("admit_term") >= F.col("snapdate_term"))
            ),
            F.col("admit_term"),
        )
        .otherwise(F.lit(None).cast("string"))
        .alias("report_term"),
    ).distinct()

    # 8) Check the comparison snapshot date up to 3 days back when it does not exist
    df_no_matching_comparison_date = (
        df_ugrd_funnel_report_terms.select("snapdate_ymd", "comparison_snapdate")
        .distinct()
        .alias("rpt_terms")
        .join(
            df_snapdate_list.alias("snap_list"),
            (F.col("rpt_terms.comparison_snapdate") == F.col("snap_list.snapdate_ymd")),
            "left_anti",
        )
    )

    for _offset in (1, 2, 3):
        df_no_matching_comparison_date = df_no_matching_comparison_date.join(
            df_snapdate_list.select(
                F.col("snapdate_ymd").alias(f"snapdate_minus{_offset}")
            ),
            (
                F.date_format(
                    F.date_sub(
                        F.to_date(F.col("comparison_snapdate"), "yyyyMMdd"), _offset
                    ),
                    "yyyyMMdd",
                )
                == F.col(f"snapdate_minus{_offset}")
            ),
            "left",
        )

    df_no_matching_comparison_date = df_no_matching_comparison_date.select(
        F.col("snapdate_ymd").alias("nm_snapdate_ymd"),
        F.col("comparison_snapdate").alias("nm_comparison_snapdate"),
        F.coalesce(
            F.col("snapdate_minus1"), F.col("snapdate_minus2"), F.col("snapdate_minus3")
        ).alias("nm_calc_comparison_snapdate"),
    ).distinct()

    # Comparison admit term description from the term dimension
    df_term_description = dim_uta_term_df.groupBy(
        F.col("sourcekey").alias("termsetup_sourcekey")
    ).agg(F.max(F.col("description")).alias("termsetup_description"))

    # 9) Add the calculated comparison snapshot date
    df_joined = (
        df_ugrd_funnel_report_terms.alias("rpt_terms")
        .join(
            df_no_matching_comparison_date.alias("no_match"),
            (F.col("rpt_terms.snapdate_ymd") == F.col("no_match.nm_snapdate_ymd")),
            "left",
        )
        .join(
            df_term_description.alias("termsetup"),
            (
                F.col("rpt_terms.comparison_admit_term")
                == F.col("termsetup.termsetup_sourcekey")
            ),
            "left",
        )
    )

    # Rows whose prior-year comparison snapshot could not be resolved within three days
    no_comparison = F.col("no_match.nm_snapdate_ymd").isNotNull() & F.col(
        "no_match.nm_calc_comparison_snapdate"
    ).isNull()

    final_df = df_joined.select(
        F.trim(F.col("rpt_terms.snapdate_ymd")).cast("string").alias("SNAPDATE_YMD"),
        F.trim(F.col("rpt_terms.snapdate_term")).cast("string").alias("SNAPDATE_TERM"),
        F.to_date(F.trim(F.col("rpt_terms.snapdate_term_census_dt")), "yyyyMMdd").alias(
            "SNAPDATE_TERM_CENSUS_DT"
        ),
        F.to_date(
            F.trim(F.col("rpt_terms.change_rpt_term_start_dt")), "yyyyMMdd"
        ).alias("CHANGE_RPT_TERM_START_DT"),
        F.trim(F.col("rpt_terms.report_term")).cast("string").alias("REPORT_TERM"),
        F.trim(F.col("rpt_terms.admit_term")).cast("string").alias("ADMIT_TERM"),
        F.trim(F.col("rpt_terms.admit_term_descr"))
        .cast("string")
        .alias("ADMIT_TERM_DESCR"),
        F.trim(
            F.when(
                F.col("no_match.nm_snapdate_ymd").isNull(),
                F.col("rpt_terms.comparison_snapdate"),
            ).otherwise(F.col("no_match.nm_calc_comparison_snapdate"))
        )
        .cast("string")
        .alias("COMPARISON_SNAPDATE"),
        F.trim(
            F.when(no_comparison, F.lit(None)).otherwise(
                F.col("rpt_terms.comparison_admit_term")
            )
        )
        .cast("string")
        .alias("COMPARISON_ADMIT_TERM"),
        F.trim(
            F.when(no_comparison, F.lit(None)).otherwise(
                F.col("termsetup.termsetup_description")
            )
        )
        .cast("string")
        .alias("COMPARISON_ADMIT_TERM_DESCR"),
    ).distinct()

    return final_df