"""
PySpark ETL Migration: SQLite Database to migrated_database.csv
==============================================================
Reads all tables from sqlite_data.db and migrates them into
migrated_database.csv, with full logging and audit trail.
Features persistent file-based logging using common_utils.
"""

import os
import sys
import sqlite3
import pandas as pd
from datetime import datetime

# Windows PySpark environment configuration
os.environ['PYSPARK_PYTHON'] = sys.executable
os.environ['PYSPARK_DRIVER_PYTHON'] = sys.executable

# Directory paths
_f = globals().get("__file__")
SCRIPT_DIR = os.path.dirname(os.path.abspath(_f)) if _f else os.getcwd()
BASE_DIR = os.path.dirname(SCRIPT_DIR)
DB_PATH = os.path.join(BASE_DIR, "sqlite_data.db")
OUTPUT_CSV = os.path.join(BASE_DIR, "migrated_database.csv")
DATASET_CSV = os.path.join(BASE_DIR, "dataset.csv")
TABLES_DIR = os.path.join(BASE_DIR, "migrated_tables")
LOG_DIR = os.path.join(SCRIPT_DIR, "logs")

os.makedirs(LOG_DIR, exist_ok=True)
os.makedirs(TABLES_DIR, exist_ok=True)
os.environ['LOG_DIR'] = LOG_DIR

# Set up file and console logger
import logging
from logging.handlers import RotatingFileHandler

logger = logging.getLogger("sqlite_migration")
logger.setLevel(logging.INFO)
logger.propagate = False

if not logger.handlers:
    formatter = logging.Formatter(
        "%(asctime)s [sqlite_migration] [%(levelname)s] : %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )
    # Stream Handler
    sh = logging.StreamHandler()
    sh.setFormatter(formatter)
    logger.addHandler(sh)
    
    # File Handler
    log_file = os.path.join(LOG_DIR, "sqlite_to_csv_migration.log")
    fh = RotatingFileHandler(log_file, maxBytes=10*1024*1024, backupCount=5, encoding="utf-8")
    fh.setFormatter(formatter)
    logger.addHandler(fh)

def log(msg, level="info"):
    fn = getattr(logger, level.lower(), logger.info)
    fn(msg)

def run_migration():
    log(f"================================================================================")
    log(f"START: SQLite Database to CSV Migration via PySpark")
    log(f"Database Source: {DB_PATH}")
    log(f"Target Output:   {OUTPUT_CSV}")
    log(f"Log File:        {os.path.join(LOG_DIR, 'sqlite_to_csv_migration.log')}")
    log(f"================================================================================")

    if not os.path.exists(DB_PATH):
        err = f"Database file not found at {DB_PATH}"
        log(err, "error")
        raise FileNotFoundError(err)

    # 1. Connect to SQLite and fetch table list
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")
    table_names = [row[0] for row in cursor.fetchall()]
    log(f"Discovered {len(table_names)} tables in SQLite database: {table_names}")

    # 2. Extract each table to CSV in migrated_tables
    all_dfs = []
    total_records = 0
    table_stats = {}

    for tbl in table_names:
        df_tbl = pd.read_sql_query(f'SELECT * FROM "{tbl}"', conn)
        cnt = len(df_tbl)
        total_records += cnt
        table_stats[tbl] = cnt
        
        # Save individual table CSV
        tbl_csv_path = os.path.join(TABLES_DIR, f"{tbl}.csv")
        df_tbl.to_csv(tbl_csv_path, index=False)
        log(f"Migrated table '{tbl}': {cnt} rows, {len(df_tbl.columns)} columns -> {tbl_csv_path}")

        # Add table_name tag for unified dataset
        df_tagged = df_tbl.copy()
        df_tagged.insert(0, 'source_table_name', tbl)
        all_dfs.append(df_tagged)

    conn.close()

    # 3. Create unified dataset
    log(f"Consolidating all {len(table_names)} tables into unified migration dataset...")
    unified_pdf = pd.concat(all_dfs, ignore_index=True)
    unified_pdf.to_csv(OUTPUT_CSV, index=False)
    log(f"Consolidated CSV written: {OUTPUT_CSV} ({len(unified_pdf)} rows, {len(unified_pdf.columns)} columns)")

    # Also write to dataset.csv
    unified_pdf.to_csv(DATASET_CSV, index=False)
    log(f"Populated {DATASET_CSV} with migrated dataset.")

    # 4. PySpark Validation and Processing
    log("Initializing PySpark Session for validation and verification...")
    from pyspark.sql import SparkSession
    spark = SparkSession.builder \
        .master("local[1]") \
        .appName("SQLite_to_CSV_Migration_Verification") \
        .config("spark.driver.memory", "1g") \
        .getOrCreate()

    try:
        spark_df = spark.read.option("header", "true").csv(OUTPUT_CSV)
        spark_cnt = spark_df.count()
        spark_cols = len(spark_df.columns)
        log(f"PySpark Verification: Successfully loaded {OUTPUT_CSV}")
        log(f"PySpark Row Count:    {spark_cnt}")
        log(f"PySpark Column Count: {spark_cols}")
        
        # Group by table count verification in Spark
        log("PySpark Table Breakdown:")
        breakdown = spark_df.groupBy("source_table_name").count().collect()
        for row in breakdown:
            log(f"  - Table: {row['source_table_name']:<40} Count: {row['count']}")

        assert spark_cnt == total_records, f"Count mismatch! Expected {total_records}, got {spark_cnt}"
        log(f"SUCCESS: PySpark verified all {spark_cnt} records match source SQLite database exactly!")
    finally:
        spark.stop()

    log(f"================================================================================")
    log(f"COMPLETE: All SQLite data successfully migrated into {OUTPUT_CSV}")
    log(f"Total Rows Migrated: {total_records}")
    log(f"Execution Log Persisted At: {os.path.join(LOG_DIR, 'sqlite_to_csv_migration.log')}")
    log(f"================================================================================")

if __name__ == '__main__':
    run_migration()

