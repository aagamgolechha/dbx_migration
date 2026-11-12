# Databricks notebook source
# /// script
# [tool.databricks.environment]
# environment_version = "5"
# dependencies = [
#   "openpyxl",
# ]
# ///
# MAGIC %md
# MAGIC # Admission_UGRD_Funnel_Overview_-_FTIC_and_Transfer --> transform_analytics_fact_admissions_funnel_ftic_and_transfer_overview
# MAGIC PySpark conversion from SAS to Databricks
# MAGIC
# MAGIC **Script**: Admission_UGRD_Funnel_Overview_-_FTIC_and_Transfer.sas
# MAGIC
# MAGIC **Source tables**: UTACSRPT.DDH_GETUGRDFUNNELTERMS
# MAGIC utacstgt.uta_adm_ugrd_funnel
# MAGIC utacstgt.DimUtaTerm
# MAGIC
# MAGIC **Output Files**: HTML - Admission UGRD Funnel Overview - FTIC and Transfer.htm
# MAGIC Admission UGRD Funnel Overview FTIC TRN_%sysfunc(today(),yymmdd10).xlsx

# COMMAND ----------

# MAGIC %run ./global_properties

# COMMAND ----------

# MAGIC %run ./common_utils

# COMMAND ----------

# %pip install openpyxl  # disabled by generator — handled via job environment dependencies

# COMMAND ----------

from datetime import datetime, timedelta
import os
import re
import tempfile
import shutil
from html import escape
from pyspark.sql import functions as F
from openpyxl import Workbook
from openpyxl.styles import Alignment, Font, PatternFill, Border, Side
from openpyxl.utils import get_column_letter

# COMMAND ----------

_job_start_time = datetime.now()
log_msg(
    f"Job started: transform_analytics_fact_admissions_funnel_ftic_and_transfer_overview | {_job_start_time.strftime('%Y-%m-%d %H:%M:%S')}",
    "info",
)

# COMMAND ----------

terms_table = build_ddh_get_ugrd_funnel_terms()

funnel_table = f"{analytics}.{silver}.fact_admissions_undergraduate_funnel"

dim_term_table = f"{analytics}.{silver}.dim_term"

# Databricks Widgets
dbutils.widgets.text("Snapdate", "20260813")
dbutils.widgets.dropdown("OUTPUT_TYPE", "Excel", ["Excel", "Html"])

# Read parameter values
Snapdate = dbutils.widgets.get("Snapdate")
CURRENT_DATE_TO_CHECK = Snapdate
OUTPUT_TYPE = dbutils.widgets.get("OUTPUT_TYPE")

# Output file location
preferred_dir = student_ext_output_path

# COMMAND ----------

# Returns the most recent valid snapshot date available within the last 20 days.
def check_snap_date(snapdate):
    numobs = 0
    maxdaysback = 20
    snapdatefound = ""

    base_dt = datetime.strptime(snapdate, "%Y%m%d")

    i = 0
    while numobs == 0 and i <= maxdaysback:
        temp_dt = base_dt - timedelta(days=i)
        tempsnapdate = temp_dt.strftime("%Y%m%d")

        match_df = (
            terms_table
            .where(F.col("snapdate_ymd") == F.lit(tempsnapdate))
            .select("snapdate_ymd")
            .distinct()
        )
        rows = match_df.limit(1).collect()
        numobs = 1 if rows else 0

        if numobs > 0:
            snapdatefound = str(rows[0]["snapdate_ymd"])
            break

        i += 1

    return snapdatefound

# COMMAND ----------

# Determines the current valid snapshot date and finds matching comparison snapshot dates for the prior two years.
def get_snap_dates(datetocheck):
    current_snapshot_date = check_snap_date(datetocheck)

    comparison_snapshot_date1 = ""
    comparison_snapshot_date2 = ""

    if current_snapshot_date:
        current_dt = datetime.strptime(current_snapshot_date, "%Y%m%d")
        compare1 = current_dt.replace(year=current_dt.year - 1).strftime("%Y%m%d")
        compare2 = current_dt.replace(year=current_dt.year - 2).strftime("%Y%m%d")

        comparison_snapshot_date1 = check_snap_date(compare1)
        comparison_snapshot_date2 = check_snap_date(compare2)

    return current_snapshot_date, comparison_snapshot_date1, comparison_snapshot_date2

# COMMAND ----------

# Retrieves all distinct report terms for the specified snapshot date in ascending order.
def get_report_terms(snapdate):
    terms = (
        terms_table
        .where(
            (F.col("snapdate_ymd") == F.lit(snapdate))
            & F.col("report_term").isNotNull()
            & (F.trim(F.col("report_term")) != "")
        )
        .select(F.col("report_term").cast("string").alias("report_term"))
        .distinct()
        .orderBy(F.col("report_term").asc())
        .collect()
    )

    funnel_terms = [r["report_term"] for r in terms]
    return funnel_terms

# COMMAND ----------

# Retrieves distinct calendar years for the specified term type in ascending order.
def get_calendar_years(funnel_report_df, term_type):
    years = (
        funnel_report_df.where(F.trim(F.col("term_type")) == F.lit(term_type))
        .select("calendar_year")
        .distinct()
        .orderBy(F.col("calendar_year").asc())
        .collect()
    )
    return [str(r["calendar_year"]) for r in years]

# COMMAND ----------


# Retrieves snapshot dates and report terms required for funnel report generation.
CurrentSnapshotDate, ComparisonSnapshotDate1, ComparisonSnapshotDate2 = get_snap_dates(CURRENT_DATE_TO_CHECK)

FunnelTerms = get_report_terms(CurrentSnapshotDate) if CurrentSnapshotDate else []
FunnelTerm1 = FunnelTerms[0] if len(FunnelTerms) >= 1 else ""
FunnelTerm2 = FunnelTerms[1] if len(FunnelTerms) >= 2 else ""
FunnelTerm3 = FunnelTerms[2] if len(FunnelTerms) >= 3 else ""

log_msg(f"CurrentSnapshotDate={CurrentSnapshotDate}", "info")
log_msg(f"ComparisonSnapshotDate1={ComparisonSnapshotDate1}", "info")
log_msg(f"ComparisonSnapshotDate2={ComparisonSnapshotDate2}", "info")
log_msg(f"FunnelTerm1={FunnelTerm1}", "info")
log_msg(f"FunnelTerm2={FunnelTerm2}", "info")
log_msg(f"FunnelTerm3={FunnelTerm3}", "info")

def term_offsets(term_code):
    term_num = int(term_code)
    return str(term_num - 10), str(term_num - 20)

# COMMAND ----------

# Calculates equivalent admit terms for the prior one-year and two-year comparison periods.
def build_funnel_detail_data():
    df = read_table(funnel_table).alias("ugfunnel")

    term_filters = []
    for term in [FunnelTerm1, FunnelTerm2, FunnelTerm3]:
        if (
            term
            and CurrentSnapshotDate
            and ComparisonSnapshotDate1
            and ComparisonSnapshotDate2
        ):
            term_m1, term_m2 = term_offsets(term)
            term_filters.append(
                (
                    (F.col("ugfunnel.admit_term") == F.lit(term))
                    & (F.col("ugfunnel.snapdate_ymd") == F.lit(CurrentSnapshotDate))
                )
            )
            term_filters.append(
                (
                    (F.col("ugfunnel.admit_term") == F.lit(term_m1))
                    & (F.col("ugfunnel.snapdate_ymd") == F.lit(ComparisonSnapshotDate1))
                )
            )
            term_filters.append(
                (
                    (F.col("ugfunnel.admit_term") == F.lit(term_m2))
                    & (F.col("ugfunnel.snapdate_ymd") == F.lit(ComparisonSnapshotDate2))
                )
            )

    if term_filters:
        combined_term_filter = term_filters[0]
        for cond in term_filters[1:]:
            combined_term_filter = combined_term_filter | cond
    else:
        combined_term_filter = F.lit(False)

    filtered = df.where(combined_term_filter).where(
        (~F.trim(F.col("ugfunnel.emplid")).like("UTATEST%"))
        & (F.col("ugfunnel.appl_flag") == F.lit("Y"))
        & (F.col("ugfunnel.auap") == F.lit("N"))
        & (
            (
                (F.trim(F.col("ugfunnel.admit_type")) == F.lit("1"))
                & (F.col("ugfunnel.auea") == F.lit("N"))
            )
            | (
                (F.trim(F.col("ugfunnel.admit_type")) == F.lit("2"))
                & (F.col("ugfunnel.auet") == F.lit("N"))
                & (
                    ~(
                        (F.col("ugfunnel.aubs") == F.lit("Y"))
                        & (F.col("ugfunnel.ubsg") == F.lit("Y"))
                    )
                )
            )
        )
    )

    detail = (
        filtered.select(
            F.col("ugfunnel.snapdate_ymd"),
            F.col("ugfunnel.emplid"),
            F.col("ugfunnel.application_nbr"),
            F.lit("UGRD").alias("acad_career"),
            F.col("ugfunnel.admit_type"),
            F.col("ugfunnel.admit_type_descr"),
            F.col("ugfunnel.admit_term"),
            F.col("ugfunnel.admit_term_descr"),
            F.concat(
                F.substring(F.col("ugfunnel.admit_term_descr"), 6, 100),
                F.lit(" "),
                F.substring(F.col("ugfunnel.admit_term_descr"), 1, 4),
            ).alias("admit_term_formal_descr"),
            F.substring(F.col("ugfunnel.admit_term_descr"), 1, 4).alias(
                "calendar_year"
            ),
            F.substring(F.col("ugfunnel.admit_term_descr"), 6, 100).alias("term_type"),
            F.when(
                (F.trim(F.col("ugfunnel.admit_type")) == F.lit("1"))
                & (F.col("ugfunnel.auap") == F.lit("N"))
                & (F.col("ugfunnel.auea") == F.lit("N")),
                F.lit("a. First Time in College (FTIC)"),
            )
            .when(
                (F.trim(F.col("ugfunnel.admit_type")) == F.lit("2"))
                & (F.col("ugfunnel.auap") == F.lit("N"))
                & (F.col("ugfunnel.auet") == F.lit("N"))
                & (
                    ~(
                        (F.col("ugfunnel.aubs") == F.lit("Y"))
                        & (F.col("ugfunnel.ubsg") == F.lit("Y"))
                    )
                ),
                F.lit("b. Transfer"),
            )
            .otherwise(F.lit(""))
            .alias("student_type"),
            F.col("ugfunnel.program_status"),
            F.when(
                F.trim(F.col("ugfunnel.program_status")).isin("AC", "AD", "PM"),
                F.lit("Y"),
            )
            .otherwise(F.lit("N"))
            .alias("admit_flag"),
            F.col("ugfunnel.matr_flag"),
            F.col("ugfunnel.enroll_flag"),
            F.lit(1).alias("applicant_count"),
        )
        .distinct()
        .orderBy(
            F.col("admit_type_descr").asc(),
            F.col("application_nbr").desc(),
            F.col("admit_term_formal_descr").asc(),
        )
    )
    return detail

FunnelDetailData = build_funnel_detail_data()

# COMMAND ----------

# Transforms detailed funnel data into report-ready application status categories for funnel analysis.
def build_funnel_report(funnel_detail_df):
    base_cols = [
        "snapdate_ymd",
        "emplid",
        "application_nbr",
        "acad_career",
        "admit_type",
        "admit_type_descr",
        "admit_term",
        "admit_term_descr",
        "admit_term_formal_descr",
        "calendar_year",
        "term_type",
        "student_type",
        "program_status",
        "admit_flag",
        "matr_flag",
        "enroll_flag",
        "applicant_count",
    ]

    applied = funnel_detail_df.select(
        *base_cols, F.lit("a. Applications").alias("application_status")
    ).distinct()
    admitted = (
        funnel_detail_df.where(F.col("admit_flag") == F.lit("Y"))
        .select(*base_cols, F.lit("b. Admits").alias("application_status"))
        .distinct()
    )
    matriculated = (
        funnel_detail_df.where(
            (F.col("admit_flag") == F.lit("Y")) & (F.col("matr_flag") == F.lit("Y"))
        )
        .select(*base_cols, F.lit("c. Accepted Admission").alias("application_status"))
        .distinct()
    )
    enrolled = (
        funnel_detail_df.where(F.col("enroll_flag") == F.lit("Y"))
        .select(*base_cols, F.lit("d. Registered").alias("application_status"))
        .distinct()
    )

    report = (
        applied.unionByName(admitted)
        .unionByName(matriculated)
        .unionByName(enrolled)
        .orderBy(
            F.col("admit_type_descr").asc(),
            F.col("admit_term_formal_descr").asc(),
            F.col("admit_flag").asc(),
        )
    )

    return report

# COMMAND ----------

# Aggregates funnel report data into summary counts by calendar year, term type, student type, and application status.
def build_funnel_report_summary(funnel_report_df):
    summary = funnel_report_df.groupBy(
        "calendar_year", "term_type", "student_type", "application_status"
    ).agg(F.count(F.col("emplid")).alias("applicant_count"))

    return summary


# Generates the detailed funnel report, creates the summary dataset, and captures the record count for validation.
FunnelReport = build_funnel_report(FunnelDetailData)
FunnelReportSummary = build_funnel_report_summary(FunnelReport)
resultcount = FunnelReportSummary.count()

# COMMAND ----------

# Computes year-over-year percentage change and handling for zero and missing values.
def pct_change(previous_value_col, current_value_col):
    return (
        F.when(
            ((previous_value_col == F.lit(0)) | previous_value_col.isNull())
            & ((current_value_col == F.lit(0)) | current_value_col.isNull()),
            F.lit(0.0),
        )
        .when(
            ((previous_value_col == F.lit(0)) | previous_value_col.isNull())
            & (
                (current_value_col > previous_value_col)
                | (current_value_col > F.lit(0))
            ),
            F.lit(1.0),
        )
        .when(
            ((current_value_col == F.lit(0)) | current_value_col.isNull())
            & (
                (previous_value_col > current_value_col)
                | (previous_value_col > F.lit(0))
            ),
            F.lit(-1.0),
        )
        .otherwise((current_value_col - previous_value_col) / previous_value_col)
    )

# COMMAND ----------

# Creates the weekly admissions funnel overview report with three-year trend and variance analysis for a given term type.
def weekly_funnel_overview(funnel_report_summary_df, term_type):
    term_df = funnel_report_summary_df.where(
        F.trim(F.col("term_type")) == F.lit(term_type)
    )

    years = get_calendar_years(FunnelReport, term_type)
    if len(years) != 3:
        note_df = spark.createDataFrame(
            [
                (
                    f"For the selected snapshot date {CurrentSnapshotDate}, three years data for comparison is NOT available. Please select a more recent snapshot date",
                )
            ],
            ["Note"],
        )
        return note_df

    y1, y2, y3 = years[0], years[1], years[2]

    pivoted = (
        term_df.groupBy("student_type", "application_status")
        .pivot("calendar_year", [y1, y2, y3])
        .agg(F.sum("applicant_count"))
        .fillna(0)
    )

    with_changes = (
        pivoted.withColumn(y1, F.col(y1).cast("double"))
        .withColumn(y2, F.col(y2).cast("double"))
        .withColumn(y3, F.col(y3).cast("double"))
        .withColumn("ChangeN1", F.col(y2) - F.col(y1))
        .withColumn("ChangePct1", pct_change(F.col(y1), F.col(y2)))
        .withColumn("ChangeN2", F.col(y3) - F.col(y2))
        .withColumn("ChangePct2", pct_change(F.col(y2), F.col(y3)))
        .select(
            "student_type",
            "application_status",
            F.col(y1).cast("long").alias(y1),
            F.col(y2).cast("long").alias(y2),
            F.col(y3).cast("long").alias(y3),
            F.col("ChangeN1").cast("long").alias("ChangeN1"),
            F.col("ChangePct1"),
            F.col("ChangeN2").cast("long").alias("ChangeN2"),
            F.col("ChangePct2"),
        )
        .orderBy(F.col("student_type").asc(), F.col("application_status").asc())
    )

    return with_changes

# COMMAND ----------

# Generates term-specific funnel overview reports and supporting utility functions for report formatting.
def get_funnel_overview_reports(funnel_term1, funnel_term2, funnel_term3):
    term_list = [x for x in [funnel_term1, funnel_term2, funnel_term3] if x]

    terms_df = (
        read_table(dim_term_table)
        .where(F.col("SourceKey").isin(term_list))
        .select("SourceKey", "Description", "TermType")
        .distinct()
        .orderBy(F.col("SourceKey").asc())
    )

    term_rows = terms_df.collect()

    if resultcount > 0:
        outputs = {}
        for row in term_rows:
            term_type = row["TermType"]
            report_df = weekly_funnel_overview(FunnelReportSummary, term_type)
            outputs[term_type] = report_df
        return outputs

    empty_df = spark.createDataFrame(
        [("For the selected values, no data is available. The dataset is empty",)],
        ["Note"],
    )

    return {"empty": empty_df}


# Creates funnel overview reports for all available report terms.
report_outputs = get_funnel_overview_reports(FunnelTerm1, FunnelTerm2, FunnelTerm3)

# Defines the display order for application status categories in the report.
STATUS_ORDER = [
    "a. Applications",
    "b. Admits",
    "c. Accepted Admission",
    "d. Registered",
]


# Safely converts a value to an integer, returning zero for null values.
def safe_int(value):
    if value is None:
        return 0
    return int(value)


# Formats a decimal value as a percentage string with two decimal places.
def format_pct(value):
    if value is None:
        return "0.00%"
    return f"{float(value) * 100:.2f}%"


# Removes leading and trailing single or double quotes from a string value.
def strip_quotes(value):
    return str(value).strip().strip('"').strip("'")

# COMMAND ----------

# Converts funnel overview report data into a standardized section structure grouped by term type, status, and student category.
def extract_term_sections(outputs):
    sections = []

    for term_type, output_df in outputs.items():
        columns = output_df.columns
        if "Note" in columns:
            rows = output_df.collect()
            note_text = rows[0]["Note"] if rows else ""
            sections.append(
                {
                    "term_type": strip_quotes(term_type),
                    "is_note": True,
                    "note": note_text,
                    "years": [],
                    "statuses": [],
                    "rows": [],
                }
            )
            continue

        years = [c for c in columns if re.fullmatch(r"\d{4}", str(c))]
        years = sorted(years)

        collected = output_df.collect()
        row_map = {}
        student_order = []
        for row in collected:
            student_type = row["student_type"]
            app_status = row["application_status"]
            if student_type not in row_map:
                row_map[student_type] = {}
                student_order.append(student_type)
            row_map[student_type][app_status] = {
                years[0]: safe_int(row[years[0]]) if len(years) > 0 else 0,
                years[1]: safe_int(row[years[1]]) if len(years) > 1 else 0,
                years[2]: safe_int(row[years[2]]) if len(years) > 2 else 0,
                "ChangeN1": safe_int(row["ChangeN1"]),
                "ChangePct1": (
                    float(row["ChangePct1"]) if row["ChangePct1"] is not None else 0.0
                ),
                "ChangeN2": safe_int(row["ChangeN2"]),
                "ChangePct2": (
                    float(row["ChangePct2"]) if row["ChangePct2"] is not None else 0.0
                ),
            }

        statuses_present = []
        for status in STATUS_ORDER:
            if any(status in row_map[student] for student in row_map):
                statuses_present.append(status)

        section_rows = []
        for student_type in student_order:
            out_row = {"student_type": student_type, "status_values": {}}
            for status in statuses_present:
                values = row_map[student_type].get(
                    status,
                    {
                        years[0]: 0,
                        years[1]: 0,
                        years[2]: 0,
                        "ChangeN1": 0,
                        "ChangePct1": 0.0,
                        "ChangeN2": 0,
                        "ChangePct2": 0.0,
                    },
                )
                out_row["status_values"][status] = values
            section_rows.append(out_row)

        sections.append(
            {
                "term_type": strip_quotes(term_type),
                "is_note": False,
                "note": "",
                "years": years,
                "statuses": statuses_present,
                "rows": section_rows,
            }
        )

    return sections

# COMMAND ----------

# Variable used in the create_excel_report function
wrk_book = Workbook()
wrk_sheet = wrk_book.active
wrk_sheet.title = "UGRD"
wrk_sheet.sheet_view.showGridLines = False
thin = Side(border_style="thin", color="C1C1C1")
data_border = Border(left=thin, right=thin, top=thin, bottom=thin)
title_fill = PatternFill(fill_type="solid", fgColor="FFFAFBFE")
header_fill = PatternFill(fill_type="solid", fgColor="FFEDF2F9")
white_fill = PatternFill(fill_type="solid", fgColor="FFFFFFFF")
title_font = Font(name="Albany AMT", size=11, bold=True, color="FF112277")
subtitle_font = Font(name="Albany AMT", size=9, bold=True, color="FF112277")
header_font = Font(name="Albany AMT", size=9.5, bold=True, color="FF112277")
header_font_black = Font(name="Albany AMT", size=9.5, bold=True, color="FF000000")
data_font = Font(name="Albany AMT", size=9.5, color="FF000000")
data_font_red = Font(name="Albany AMT", size=9.5, color="FFFF0000")

base_widths = [
    31.71,
    7.71,
    7.71,
    7.71,
    18.71,
    19.71,
    18.71,
    19.71,
    7.71,
    7.71,
    7.71,
    18.71,
    19.71,
    18.71,
    19.71,
    5.71,
    5.71,
    5.71,
    14.71,
    14.71,
    14.71,
    14.71,
    5.71,
    5.71,
    5.71,
    14.71,
    14.71,
    14.71,
    14.71,
]

# COMMAND ----------

# Creates the final admissions funnel Excel report formatting, layout, and three-year comparison results.
def create_excel_report(sections, snapshot_date, run_date_iso, output_path):

    def cell_alignment(horizontal, value=""):
        wrap = isinstance(value, str) and "\n" in value
        return Alignment(horizontal=horizontal, wrap_text=wrap)

    max_col_count = 1
    for section in sections:
        if section.get("is_note"):
            continue
        max_col_count = max(max_col_count, 1 + (7 * len(section["statuses"])))

    for c in range(1, max_col_count + 1):
        wrk_sheet.column_dimensions[get_column_letter(c)].width = base_widths[c - 1]

    row_idx = 1

    for section in sections:
        if section["is_note"]:
            note_text = section["note"]
            wrk_sheet.cell(row=row_idx, column=1, value=note_text)
            wrk_sheet.cell(row=row_idx, column=1).font = subtitle_font
            wrk_sheet.cell(row=row_idx, column=1).alignment = cell_alignment(
                "left", note_text
            )
            row_idx += 2
            continue

        statuses = section["statuses"]
        years = section["years"]
        col_count = 1 + (7 * len(statuses))

        title_text = f"Daily Admissions Overview 3 Years Comparison for {section['term_type']} Terms"
        wrk_sheet.merge_cells(
            start_row=row_idx, start_column=1, end_row=row_idx, end_column=max_col_count
        )
        wrk_sheet.cell(row=row_idx, column=1, value=title_text)
        wrk_sheet.cell(row=row_idx, column=1).font = title_font
        wrk_sheet.cell(row=row_idx, column=1).alignment = cell_alignment(
            "center", title_text
        )
        wrk_sheet.cell(row=row_idx, column=1).fill = title_fill
        wrk_sheet.row_dimensions[row_idx].height = 16
        row_idx += 1

        subtitle_text = f"Current Snapshot date: {snapshot_date}"
        wrk_sheet.merge_cells(
            start_row=row_idx, start_column=1, end_row=row_idx, end_column=max_col_count
        )
        wrk_sheet.cell(row=row_idx, column=1, value=subtitle_text)
        wrk_sheet.cell(row=row_idx, column=1).font = subtitle_font
        wrk_sheet.cell(row=row_idx, column=1).alignment = cell_alignment(
            "center", subtitle_text
        )
        wrk_sheet.cell(row=row_idx, column=1).fill = title_fill
        wrk_sheet.row_dimensions[row_idx].height = 13

        wrk_sheet.row_dimensions[row_idx + 1].height = 12
        row_idx += 2

        header1 = row_idx
        header2 = row_idx + 1
        header3 = row_idx + 2

        wrk_sheet.row_dimensions[header1].height = 14
        wrk_sheet.row_dimensions[header2].height = 14
        wrk_sheet.row_dimensions[header3].height = 29

        student_type_label = "Student\nType"
        wrk_sheet.cell(row=header1, column=1, value="")
        wrk_sheet.cell(row=header2, column=1, value="")
        wrk_sheet.cell(row=header3, column=1, value=student_type_label)

        for hdr_row in (header1, header2, header3):
            cell = wrk_sheet.cell(row=hdr_row, column=1)
            cell.font = header_font
            cell.alignment = cell_alignment("center", cell.value)
            cell.fill = header_fill
            cell.border = data_border

        current_col = 2
        for status in statuses:
            wrk_sheet.merge_cells(
                start_row=header1,
                start_column=current_col,
                end_row=header1,
                end_column=current_col + 6,
            )
            wrk_sheet.cell(row=header1, column=current_col, value=status)

            wrk_sheet.cell(row=header2, column=current_col, value=int(years[0]))
            wrk_sheet.cell(row=header2, column=current_col + 1, value=int(years[1]))
            wrk_sheet.cell(row=header2, column=current_col + 2, value=int(years[2]))
            wrk_sheet.merge_cells(
                start_row=header2,
                start_column=current_col + 3,
                end_row=header2,
                end_column=current_col + 6,
            )

            wrk_sheet.merge_cells(
                start_row=header3,
                start_column=current_col,
                end_row=header3,
                end_column=current_col + 2,
            )
            wrk_sheet.cell(row=header3, column=current_col, value="")
            change_label_cols = {
                current_col + 3: f"# +/-\n({years[1]}-{years[0]})",
                current_col + 4: f"% +/-\n({years[1]}-{years[0]})",
                current_col + 5: f"# +/-\n({years[2]}-{years[1]})",
                current_col + 6: f"% +/-\n({years[2]}-{years[1]})",
            }
            for col, label in change_label_cols.items():
                wrk_sheet.cell(row=header3, column=col, value=label)

            for hdr_row in (header1, header2, header3):
                for hdr_col in range(current_col, current_col + 7):
                    cell = wrk_sheet.cell(row=hdr_row, column=hdr_col)
                    is_change_label = (
                        hdr_row == header3 and hdr_col in change_label_cols
                    )
                    cell.font = header_font_black if is_change_label else header_font
                    cell.alignment = cell_alignment("center", cell.value)
                    cell.fill = header_fill
                    cell.border = data_border

            current_col += 7

        row_idx += 3

        for data_row in section["rows"]:
            wrk_sheet.row_dimensions[row_idx].height = (
                43 if "First Time in College" in data_row["student_type"] else 14
            )
            c = 1
            label_value = data_row["student_type"]
            wrk_sheet.cell(row=row_idx, column=c, value=label_value)
            wrk_sheet.cell(row=row_idx, column=c).font = data_font
            wrk_sheet.cell(row=row_idx, column=c).alignment = cell_alignment(
                "left", label_value
            )
            wrk_sheet.cell(row=row_idx, column=c).fill = white_fill
            wrk_sheet.cell(row=row_idx, column=c).border = data_border

            c += 1
            for status in statuses:
                values = data_row["status_values"][status]
                numeric_values = [
                    values[years[0]],
                    values[years[1]],
                    values[years[2]],
                    values["ChangeN1"],
                    values["ChangePct1"],
                    values["ChangeN2"],
                    values["ChangePct2"],
                ]

                for idx, value in enumerate(numeric_values):
                    target_cell = wrk_sheet.cell(row=row_idx, column=c + idx)
                    is_pct = idx in (4, 6)
                    is_negative = value < 0
                    target_cell.value = float(value) if is_pct else value
                    target_cell.font = data_font_red if is_negative else data_font
                    target_cell.alignment = cell_alignment("right")
                    target_cell.fill = white_fill
                    target_cell.border = data_border
                    target_cell.number_format = "0.00%" if is_pct else "########0"

                c += 7

            row_idx += 1

        # Single blank spacer row between this section's data and the next title.
        wrk_sheet.row_dimensions[row_idx].height = 12
        row_idx += 1

    wrk_sheet.page_margins.left = 0.05
    wrk_sheet.page_margins.right = 0.05
    wrk_sheet.page_margins.top = 0.5
    wrk_sheet.page_margins.bottom = 0.5
    wrk_sheet.page_setup.fitToWidth = 1
    wrk_sheet.page_setup.fitToHeight = 1

    wrk_sheet.oddFooter.center.text = f"Report run date: {run_date_iso}."

    wrk_book.save(output_path)

# COMMAND ----------

# Determines the HTML text color style based on value type and whether the value is negative.
def cell_style_for_value(value, is_pct=False):
    if value < 0:
        return (
            ' style="color: #ff0000"'
            if is_pct
            else ' style="color: #ff0000; white-space: nowrap"'
        )
    return ' style="color: #000000"'

# COMMAND ----------

# Contains the CSS stylesheet used to apply style formatting to the HTML report output.
css_block = """
.body.c > table, .body.c > pre, .body.c div > table,
.body.c div > pre, .body.c > table, .body.c > pre,
.body.j > table, .body.j > pre, .body.j div > table,
.body.j div > pre, .body.j > table, .body.j > pre,
.body.c p.note, .body.c p.warning, .body.c p.error, .body.c p.fatal,
.body.j p.note, .body.j p.warning, .body.j p.error, .body.j p.fatal,
.body.c > table.layoutcontainer, .body.j > table.layoutcontainer { margin-left: auto; margin-right: auto }
.layoutregion.l table, .layoutregion.l pre, .layoutregion.l p.note,
.layoutregion.l p.warning, .layoutregion.l p.error, .layoutregion.l p.fatal { margin-left: 0 }
.layoutregion.c table, .layoutregion.c pre, .layoutregion.c p.note,
.layoutregion.c p.warning, .layoutregion.c p.error, .layoutregion.c p.fatal { margin-left: auto; margin-right: auto }
.layoutregion.r table, .layoutregion.r pre, .layoutregion.r p.note,
.layoutregion.r table, .layoutregion.r pre, .layoutregion.r p.note,
.layoutregion.r p.warning, .layoutregion.r p.error, .layoutregion.r p.fatal { margin-right: 0 }
article, aside, details, figcaption, figure, footer, header, hgroup, nav, section { display: block }
html{ font-size: 100% }
.body { margin: 1em; font-size: 13px; line-height: 1.231 }
sup { position: relative; vertical-align: baseline; bottom: 0.25em; font-size: 0.8em }
sub { position: relative; vertical-align: baseline; top: 0.25em; font-size: 0.8em }
ul, ol { margin: 1em 0; padding: 0 0 0 40px }
dd { margin: 0 0 0 40px }
nav ul, nav ol { list-style: none; list-style-image: none; margin: 0; padding: 0 }
img { border: 0; vertical-align: middle }
svg:not(:root) { overflow: hidden }
figure { margin: 0 }
table { border-collapse: collapse; border-spacing: 0 }
.layoutcontainer { border-collapse: separate; border-spacing: 0 }
p { margin-top: 0; text-align: left }
h1.heading1 { text-align: left }
h2.heading2 { text-align: left }
h3.heading3 { text-align: left }
h4.heading4 { text-align: left }
h5.heading5 { text-align: left }
h6.heading6 { text-align: left }
span { text-align: left }
table { margin-bottom: 1em }
td, th { text-align: left; padding: 3px 6px; vertical-align: top }
td[class$="fixed"], th[class$="fixed"] { white-space: pre }
section, article { padding-top: 1px; padding-bottom: 8px }
hr.pagebreak { height: 0px; border: 0; border-bottom: 1px solid #c0c0c0; margin: 1em 0 }
.stacked-value { text-align: left; display: block }
.stacked-cell > .stacked-value, td.data > td.data, th.data > td.data, th.data > th.data, td.data > th.data, th.header > th.header { border: 0 }
.stacked-cell > div.data { border-width: 0 }
.systitleandfootercontainer { white-space: nowrap; margin-bottom: 1em }
.systitleandfootercontainer > p { margin: 0 }
.systitleandfootercontainer > p > span { display: inline-block; width: 100%; white-space: normal }
.batch { display: table }
.toc { display: none }
.proc_note_group, .proc_title_group { margin-bottom: 1em }
p.proctitle { margin: 0 }
p.note, p.warning, p.error, p.fatal { display: table }
.notebanner, .warnbanner, .errorbanner, .fatalbanner,
.notecontent, .warncontent, .errorcontent, .fatalcontent { display: table-cell; padding: 0.5em }
.notebanner, .warnbanner, .errorbanner, .fatalbanner { padding-right: 0 }
.body > div > ol li { text-align: left }
.beforecaption > h4 { margin-top: 0; margin-bottom: 0 }
.c { text-align: center }
.r { text-align: right }
.l { text-align: left }
.j { text-align: justify }
.d { text-align: right }
.b { vertical-align: bottom }
.m { vertical-align: middle }
.t { vertical-align: top }
.accessiblecaption {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
a:active { color: #800080 }
.aftercaption {
    background-color: #fafbfe;
    border-spacing: 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
    padding-top: 4pt;
}
.batch > colgroup {
    border-left: 1px solid #c1c1c1;
    border-right: 1px solid #c1c1c1;
}
.batch > tbody, .batch > thead, .batch > tfoot {
    border-top: 1px solid #c1c1c1;
    border-bottom: 1px solid #c1c1c1;
}
.batch { border: hidden; }
.batch {
    background-color: #fafbfe;
    border: 1px solid #c1c1c1;
    border-collapse: separate;
    border-spacing: 1px;
    color: #000000;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    padding: 7px;
    }
.beforecaption {
    background-color: #fafbfe;
    border-spacing: 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.body {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    margin-left: 8px;
    margin-right: 8px;
}
.bodydate {
    background-color: #fafbfe;
    border-spacing: 0;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    text-align: right;
    vertical-align: top;
    width: 100%;
}
.bycontentfolder {
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: none;
    margin-left: 6pt;
}
.byline {
    background-color: #fafbfe;
    border-spacing: 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.bylinecontainer > col, .bylinecontainer > colgroup > col, .bylinecontainer > colgroup, .bylinecontainer > tr, .bylinecontainer > * > tr, .bylinecontainer > thead, .bylinecontainer > tbody, .bylinecontainer > tfoot { border: none; }
.bylinecontainer {
    background-color: #fafbfe;
    border: none;
    border-spacing: 1px;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    width: 100%;
}
.caption {
    background-color: #fafbfe;
    border-spacing: 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.cell, .container {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.contentfolder, .contentitem {
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: none;
    margin-left: 6pt;
}
.contentproclabel, .contentprocname {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.contents {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: decimal;
    margin-left: 8px;
    margin-right: 8px;
}
.contentsdate {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    width: 100%;
}
.contenttitle {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: italic;
    font-weight: bold;
}
.continued {
    background-color: #fafbfe;
    border-spacing: 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
    width: 100%;
}
.data, .dataemphasis {
    background-color: #ffffff;
    border-color: #c1c1c1;
    border-style: solid;
    border-width: 0 1px 1px 0;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.dataemphasisfixed {
    background-color: #ffffff;
    border-color: #c1c1c1;
    border-style: solid;
    border-width: 0 1px 1px 0;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.dataempty {
    background-color: #ffffff;
    border-color: #c1c1c1;
    border-style: solid;
    border-width: 0 1px 1px 0;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.datafixed {
    background-color: #ffffff;
    border-color: #c1c1c1;
    border-style: solid;
    border-width: 0 1px 1px 0;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.datastrong {
    background-color: #ffffff;
    border-color: #c1c1c1;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.datastrongfixed {
    background-color: #ffffff;
    border-color: #c1c1c1;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #000000;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.date {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    width: 100%;
}
.document {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.errorbanner {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.errorcontent {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.errorcontentfixed {
    background-color: #fafbfe;
    color: #112277;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.extendedpage {
    background-color: #fafbfe;
    border-style: solid;
    border-width: 1pt;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
    text-align: center;
}
.fatalbanner {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.fatalcontent {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.fatalcontentfixed {
    background-color: #fafbfe;
    color: #112277;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.folderaction {
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: none;
    margin-left: 6pt;
}
.footer {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.footeremphasis {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.footeremphasisfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.footerempty {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.footerfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.footerstrong {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.footerstrongfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.frame {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.graph > colgroup {
    border-left: 1px solid #c1c1c1;
    border-right: 1px solid #c1c1c1;
}
.graph > tbody, .graph > thead, .graph > tfoot {
    border-top: 1px solid #c1c1c1;
    border-bottom: 1px solid #c1c1c1;
}
.graph { border: hidden; }
.graph {
    background-color: #fafbfe;
    border: 1px solid #c1c1c1;
    border-collapse: separate;
    border-spacing: 1px;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    }
.header {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.headeremphasis {
    background-color: #d8dbd3;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.headeremphasisfixed {
    background-color: #d8dbd3;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #000000;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.headerempty {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.headerfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.headersandfooters {
    background-color: #edf2f9;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.headerstrong {
    background-color: #d8dbd3;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.headerstrongfixed {
    background-color: #d8dbd3;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #000000;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.heading1, .heading2, .heading3, .heading4, .heading5, .heading6 { font-family: Arial, Helvetica, sans-serif }
.index {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.indexaction, .indexitem {
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: none;
    margin-left: 6pt;
}
.indexprocname {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.indextitle {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: italic;
    font-weight: bold;
}
.layoutcontainer, .layoutregion {
    border-width: 0;
    border-spacing: 30px;
}
.linecontent {
    background-color: #fafbfe;
    border-color: #c1c1c1;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
a:link { color: #0000ff }
.list {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: disc;
}
.list10 {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: square;
}
.list2 {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: circle;
}
.list3, .list4, .list5, .list6, .list7, .list8, .list9 {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: square;
}
.listitem {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: disc;
}
.listitem10 {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: square;
}
.listitem2 {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: circle;
}
.listitem3, .listitem4, .listitem5, .listitem6, .listitem7, .listitem8, .listitem9 {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: square;
}
.note {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.notebanner {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.notecontent {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.notecontentfixed {
    background-color: #fafbfe;
    color: #112277;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.output > colgroup {
    border-left: 1px solid #c1c1c1;
    border-right: 1px solid #c1c1c1;
}
.output > tbody, .output > thead, .output > tfoot {
    border-top: 1px solid #c1c1c1;
    border-bottom: 1px solid #c1c1c1;
}
.output { border: hidden; }
.output {
    background-color: #fafbfe;
    border: 1px solid #c1c1c1;
    border-collapse: separate;
    border-spacing: 1px;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    }
.pageno {
    background-color: #fafbfe;
    border-spacing: 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
    text-align: right;
    vertical-align: top;
}
.pages {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: decimal;
    margin-left: 8px;
    margin-right: 8px;
}
.pagesdate {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    width: 100%;
}
.pagesitem {
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    list-style-type: none;
    margin-left: 6pt;
}
.pagesproclabel, .pagesprocname {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.pagestitle {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: italic;
    font-weight: bold;
}
.paragraph {
    background-color: #fafbfe;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.parskip > col, .parskip > colgroup > col, .parskip > colgroup, .parskip > tr, .parskip > * > tr, .parskip > thead, .parskip > tbody, .parskip > tfoot { border: none; }
.parskip {
    border: none;
    border-spacing: 0;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
    }
.prepage {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    text-align: left;
}
.proctitle {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.proctitlefixed {
    background-color: #fafbfe;
    color: #112277;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.rowfooter {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.rowfooteremphasis {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.rowfooteremphasisfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.rowfooterempty {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.rowfooterfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.rowfooterstrong {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.rowfooterstrongfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.rowheader {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.rowheaderemphasis {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.rowheaderemphasisfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: italic;
    font-weight: normal;
}
.rowheaderempty {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.rowheaderfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.rowheaderstrong {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.rowheaderstrongfixed {
    background-color: #edf2f9;
    border-color: #b0b7bb;
    border-style: solid;
    border-width: 0 1px 1px 0;
    color: #112277;
    font-family: 'Courier New', Courier, monospace;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.systemfooter, .systemfooter10, .systemfooter2, .systemfooter3, .systemfooter4, .systemfooter5, .systemfooter6, .systemfooter7, .systemfooter8, .systemfooter9 {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.systemtitle, .systemtitle10, .systemtitle2, .systemtitle3, .systemtitle4, .systemtitle5, .systemtitle6, .systemtitle7, .systemtitle8, .systemtitle9 {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: small;
    font-style: normal;
    font-weight: bold;
}
.systitleandfootercontainer > col, .systitleandfootercontainer > colgroup > col, .systitleandfootercontainer > colgroup, .systitleandfootercontainer > tr, .systitleandfootercontainer > * > tr, .systitleandfootercontainer > thead, .systitleandfootercontainer > tbody, .systitleandfootercontainer > tfoot { border: none; }
.systitleandfootercontainer {
    background-color: #fafbfe;
    border: none;
    border-spacing: 1px;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    width: 100%;
}
.table > col, .table > colgroup > col {
    border-left: 1px solid #c1c1c1;
    border-right: 0 solid #c1c1c1;
}
.table > tr, .table > * > tr {
    border-top: 1px solid #c1c1c1;
    border-bottom: 0 solid #c1c1c1;
}
.table { border: hidden; }
.table {
    border-color: #c1c1c1;
    border-style: solid;
    border-width: 1px 0 0 1px;
    border-collapse: collapse;
    border-spacing: 0;
    }
.titleandnotecontainer > col, .titleandnotecontainer > colgroup > col, .titleandnotecontainer > colgroup, .titleandnotecontainer > tr, .titleandnotecontainer > * > tr, .titleandnotecontainer > thead, .titleandnotecontainer > tbody, .titleandnotecontainer > tfoot { border: none; }
.titleandnotecontainer {
    background-color: #fafbfe;
    border: none;
    border-spacing: 1px;
    color: #000000;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
    width: 100%;
}
.titlesandfooters {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.usertext {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
a:visited { color: #800080 }
.warnbanner {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: bold;
}
.warncontent {
    background-color: #fafbfe;
    color: #112277;
    font-family: Arial, 'Albany AMT', Helvetica, Helv;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
.warncontentfixed {
    background-color: #fafbfe;
    color: #112277;
    font-family: 'Courier New', Courier;
    font-size: x-small;
    font-style: normal;
    font-weight: normal;
}
"""

# COMMAND ----------

# Variables used in create_html_report function
html_parts = []
html_parts.append("<!DOCTYPE html>")
html_parts.append(
    '<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">'
)
html_parts.append("<head>")
html_parts.append('<meta charset="utf-8"/>')
html_parts.append('<meta content="Databricks" name="generator"/>')
html_parts.append("<title>Databricks Output</title>")
html_parts.append("<style>")
html_parts.append(css_block)
html_parts.append("</style>")
html_parts.append("</head>")
html_parts.append('<body class="c body">')

# COMMAND ----------

# Creates the final HTML admissions funnel report by rendering formatted report sections and three-year comparison results.
def create_html_report(sections, snapshot_date, run_date_iso, output_path):
    for idx, section in enumerate(sections):
        if idx > 0:
            html_parts.append('<div style="padding-bottom: 8px; padding-top: 1px">')
            html_parts.append('<hr class="pagebreak"/>')

        html_parts.append('<div style="padding-bottom: 8px; padding-top: 1px">')

        if section["is_note"]:
            html_parts.append(
                '<div class="systitleandfootercontainer" style="border-spacing: 1px">'
            )
            html_parts.append(
                f"<p><span class=\"c systemtitle\">{escape(section['note'])}</span></p>"
            )
            html_parts.append("</div>")
            html_parts.append("</div>")
            continue

        statuses = section["statuses"]
        years = section["years"]
        col_count = 1 + (7 * len(statuses))

        html_parts.append(
            f'<div id="IDX{idx if idx > 0 else ""}" class="systitleandfootercontainer" style="border-spacing: 1px">'
        )
        html_parts.append(
            f"<p><span class=\"c systemtitle\">Daily Admissions Overview 3 Years Comparison for {escape(section['term_type'])} Terms</span> </p>"
        )
        html_parts.append(
            f'<p><span class="c systemtitle2" style="font-size: 9pt">Current Snapshot date: {escape(snapshot_date)}</span> </p>'
        )
        html_parts.append("</div>")

        html_parts.append('<div style="padding-bottom: 8px; padding-top: 1px">')
        html_parts.append('<div style="padding-bottom: 8px; padding-top: 1px">')
        html_parts.append(
            '<table class="table" style="border-spacing: 0" aria-label="Detailed and/or summarized report">'
        )
        html_parts.append(
            '<caption aria-label="Detailed and/or summarized report"></caption>'
        )
        html_parts.append("<colgroup>" + ("<col/>" * col_count) + "</colgroup>")
        html_parts.append("<thead>")

        html_parts.append("<tr>")
        html_parts.append('<th class="c header" scope="col">&#160;</th>')
        for status in statuses:
            html_parts.append(
                f'<th class="c header" colspan="7" scope="colgroup">{escape(status)}</th>'
            )
        html_parts.append("</tr>")

        html_parts.append("<tr>")
        html_parts.append('<th class="c header" scope="col">&#160;</th>')
        for _status in statuses:
            html_parts.append(
                f'<th class="c header" scope="col">{escape(years[0])}</th>'
            )
            html_parts.append(
                f'<th class="c header" scope="col">{escape(years[1])}</th>'
            )
            html_parts.append(
                f'<th class="c header" scope="col">{escape(years[2])}</th>'
            )
            html_parts.append(
                '<th class="c header" colspan="4" scope="colgroup">&#160;</th>'
            )
        html_parts.append("</tr>")

        html_parts.append("<tr>")
        html_parts.append('<th class="c header" scope="col">Student Type</th>')
        for _status in statuses:
            html_parts.append(
                '<th class="c header" colspan="3" scope="colgroup">&#160;</th>'
            )
            html_parts.append(
                f'<th class="c header" style="color: #000000" scope="col"># +/- ({escape(years[1])}-{escape(years[0])})</th>'
            )
            html_parts.append(
                f'<th class="c header" style="color: #000000" scope="col">% +/- ({escape(years[1])}-{escape(years[0])})</th>'
            )
            html_parts.append(
                f'<th class="c header" style="color: #000000" scope="col"># +/- ({escape(years[2])}-{escape(years[1])})</th>'
            )
            html_parts.append(
                f'<th class="c header" style="color: #000000" scope="col">% +/- ({escape(years[2])}-{escape(years[1])})</th>'
            )
        html_parts.append("</tr>")

        html_parts.append("</thead>")
        html_parts.append("<tbody>")

        for data_row in section["rows"]:
            html_parts.append("<tr>")
            html_parts.append(
                f'<td class="data">{escape(data_row["student_type"])}</td>'
            )
            for status in statuses:
                values = data_row["status_values"][status]
                html_parts.append(f'<td class="r data">{values[years[0]]}</td>')
                html_parts.append(f'<td class="r data">{values[years[1]]}</td>')
                html_parts.append(f'<td class="r data">{values[years[2]]}</td>')
                html_parts.append(
                    f'<td class="r data"{cell_style_for_value(values["ChangeN1"], is_pct=False)}>{values["ChangeN1"]}</td>'
                )
                html_parts.append(
                    f'<td class="r data"{cell_style_for_value(values["ChangePct1"], is_pct=True)}>{format_pct(values["ChangePct1"])}</td>'
                )
                html_parts.append(
                    f'<td class="r data"{cell_style_for_value(values["ChangeN2"], is_pct=False)}>{values["ChangeN2"]}</td>'
                )
                html_parts.append(
                    f'<td class="r data"{cell_style_for_value(values["ChangePct2"], is_pct=True)}>{format_pct(values["ChangePct2"])}</td>'
                )
            html_parts.append("</tr>")

        html_parts.append("</tbody>")
        html_parts.append("</table>")
        html_parts.append("</div>")
        html_parts.append("</div>")
        html_parts.append(
            '<div class="systitleandfootercontainer" style="border-spacing: 1px">'
        )
        html_parts.append(
            f'<p><span class="c systemfooter" style="font-size: 9pt">Report run date: {run_date_iso}.</span> </p>'
        )
        html_parts.append("</div>")
        html_parts.append("</div>")

    html_parts.append("</body>")
    html_parts.append("</html>")

    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(html_parts))

# COMMAND ----------

# Creates the final formatted report based on the selected output type and saves it to the configured output location.
def generate_formatted_reports(outputs, snapshot_date):
    today_iso = datetime.today().strftime("%Y-%m-%d")
    if snapshot_date and len(str(snapshot_date)) == 8:
        run_date_iso = f"{snapshot_date[0:4]}-{snapshot_date[4:6]}-{snapshot_date[6:8]}"
    else:
        run_date_iso = today_iso

    os.makedirs(preferred_dir, exist_ok=True)
    sections = extract_term_sections(outputs)

    if OUTPUT_TYPE.upper() == "EXCEL":
        excel_name = f"Admission UGRD Funnel Overview FTIC TRN_{today_iso}.xlsx"
        excel_path = os.path.join(preferred_dir, excel_name)
        with tempfile.TemporaryDirectory() as staging_dir:
            staged_excel_path = os.path.join(staging_dir, excel_name)
            create_excel_report(
                sections, snapshot_date, run_date_iso, staged_excel_path
            )
            shutil.copyfile(staged_excel_path, excel_path)
        log_msg(f"Formatted Excel output generated: {excel_path}", "info")
        return {"excel": excel_path}
    elif OUTPUT_TYPE.upper() == "HTML":
        html_name = f"HTML - Admission UGRD Funnel Overview - FTIC and Transfer.htm"
        html_path = os.path.join(preferred_dir, html_name)
        create_html_report(sections, snapshot_date, run_date_iso, html_path)
        log_msg(f"Formatted HTML output generated: {html_path}", "info")
        return {"html": html_path}
    else:
        raise ValueError(f"Unsupported OUTPUT_TYPE: {OUTPUT_TYPE}")

# COMMAND ----------

# Generates the final report outputs and logs the successfully prepared report types.
generate_formatted_reports(
    report_outputs, CurrentSnapshotDate if CurrentSnapshotDate else ""
)
for output_name, output_df in report_outputs.items():
    log_msg(f"Prepared report output: {output_name}", "info")

# COMMAND ----------

_job_end_time = datetime.now()
_job_elapsed = _job_end_time - _job_start_time
log_msg(
    f"Job completed: transform_analytics_fact_admissions_funnel_ftic_and_transfer_overview | End: {_job_end_time.strftime('%Y-%m-%d %H:%M:%S')} | Elapsed: {str(_job_elapsed)}",
    "info",
)