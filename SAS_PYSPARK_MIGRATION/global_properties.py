# Databricks notebook source
# DBTITLE 1,sys.path setup — enable utilities imports
import sys

# ---------------------------------------------------------------------------
#  Resolve src/ root and add to sys.path
#  Enables: from utilities import read_utils, write_utils
#  Works for any notebook depth under src/notebooks/ (via %run or direct run)
# ---------------------------------------------------------------------------
try:
    _nb_path = dbutils.notebook.entry_point.getDbutils().notebook().getContext().notebookPath().get()
    _parts = _nb_path.split('/')
    try:
        _src_idx = _parts.index('src')
        _src_root = '/Workspace/' + '/'.join(_parts[1:_src_idx + 1])
        if _src_root not in sys.path:
            sys.path.insert(0, _src_root)
    except ValueError:
        pass  # 'src' not in path — skip silently
except Exception:
    pass  # running outside Databricks notebook environment

# COMMAND ----------

"""
Global Properties for SAS-to-PySpark Converted Code

Auto-generated from schema.template.
All converted notebooks import this via:
    %run ../common/global_properties
"""

# ---------------------------------------------------------------------------
#  Env configuration
# ---------------------------------------------------------------------------
try:
    workspace_url = spark.conf.get("spark.databricks.workspaceUrl", "dbc-366ede42-4d33.cloud.databricks.com")
except Exception:
    workspace_url = "dbc-366ede42-4d33.cloud.databricks.com"

workspace_name = workspace_url.split(".")[0]

env_map = {
    "dbc-897f6f87-e68e": "dev",
    "dbc-407d4fbd-acca": "test",
    "dbc-18e194b9-72b8": "prod",
    "dbc-366ede42-4d33": "dev",  # User's Databricks workspace
}
env = env_map.get(workspace_name, "dev")

# ---------------------------------------------------------------------------
#  Debug Mode
# ---------------------------------------------------------------------------
debug_mode = True

# ---------------------------------------------------------------------------
#  Email Config
# ---------------------------------------------------------------------------
smtp_server       = "smtp.office365.com"
smtp_port         = 587
# Change to AWS secret usage
credentials_provider = "aws_secret_manager_read"
aws_region = "us-east-1"
secret_id = "prod/other/sasemail"
smtp_username_key = "username"
smtp_password_key = "password"
#smtp_from_email   = dbutils.secrets.get(scope=smtp_secret_scope, key=smtp_username_key)

# ---------------------------------------------------------------------------
#  non_prod_run Run Override — automatically False in Prod, True otherwise.
# ---------------------------------------------------------------------------
non_prod_run       = (env != "prod")
non_prod_to_email  = ["anupam.tyagi@uta.edu", "prudhvi.javvaji@uta.edu" , "pawan.dubliya@uta.edu","sasadmin@uta.edu"]


# COMMAND ----------

# ---------------------------------------------------------------------------
#  Session configuration
# ---------------------------------------------------------------------------
try:
    spark.conf.set("spark.sql.session.timeZone", "UTC")
    spark.conf.set("spark.sql.ansi.enabled", False)
except Exception:
    pass

# ---------------------------------------------------------------------------
#  Catalog configuration
# ---------------------------------------------------------------------------
student = f"student_{env}"
housing = f"housing_{env}"
hr = f"hr_{env}"
finance = f"finance_{env}"
research = f"research_{env}"
it = f"it_{env}"
analytics = f"analytics_{env}"
shared = f"shared_{env}"
campus_access = f"campus_access_{env}"
library = f"library_{env}"
analytics_schema = "analytics"

# ---------------------------------------------------------------------------
#  Schema configuration
# ---------------------------------------------------------------------------
audit = "audit"
bronze = "bronze"
gold = "gold"
reference = "reference"
sandbox = "sandbox"
security = "security"
silver = "silver"
staging = "staging"
archive = "archive"

# COMMAND ----------

# ---------------------------------------------------------------------------
#  Base Paths for input files
# ---------------------------------------------------------------------------
stg_volume_path = "/Volumes/utadw/stg/stg/"
student_ext_source_path = f'/Volumes/{student}/{reference}/external_sources/'
student_ext_output_path = f'/Volumes/{student}/{reference}/external_outputs/'

# we can use below variables for testing purpose
utadw = "utadw"
stg = "stg"
trn = "trn"
tgt = "tgt"
stghr = "stghr"
temp_impetus = "temp_impetus"
stgarchive = "stgarchive"


# ---------------------------------------------------------------------------
#  input file paths
# ---------------------------------------------------------------------------
acgm_courses_source_file = f"{student_ext_source_path}ACGM.csv"
Formula_Funding_file = f"{student_ext_source_path}Formula Funding.csv"
uta_holiday_schedule_file = f"{student_ext_source_path}UTA Holiday Schedule.csv"
CourseInventory_file = f"{student_ext_source_path}CourseInventory.csv"

# COMMAND ----------

# Complete STFIPS map — 50 states + DC + territories + freely associated states
STFIPS_MAP = {
    # 50 States
    "AL": "01", "AK": "02", "AZ": "04", "AR": "05", "CA": "06",
    "CO": "08", "CT": "09", "DE": "10", "FL": "12", "GA": "13",
    "HI": "15", "ID": "16", "IL": "17", "IN": "18", "IA": "19",
    "KS": "20", "KY": "21", "LA": "22", "ME": "23", "MD": "24",
    "MA": "25", "MI": "26", "MN": "27", "MS": "28", "MO": "29",
    "MT": "30", "NE": "31", "NV": "32", "NH": "33", "NJ": "34",
    "NM": "35", "NY": "36", "NC": "37", "ND": "38", "OH": "39",
    "OK": "40", "OR": "41", "PA": "42", "RI": "44", "SC": "45",
    "SD": "46", "TN": "47", "TX": "48", "UT": "49", "VT": "50",
    "VA": "51", "WA": "53", "WV": "54", "WI": "55", "WY": "56",
    # DC
    "DC": "11",
    # US Territories
    "AS": "60",  # American Samoa
    "GU": "66",  # Guam
    "MP": "69",  # Northern Mariana Islands
    "PR": "72",  # Puerto Rico
    "VI": "78",  # US Virgin Islands
    # Freely Associated States (not in SAS STFIPS but included for completeness)
    "FM": "64",  # Micronesia
    "MH": "68",  # Marshall Islands
    "PW": "70",  # Palau
    # Full state names (uppercase for case-insensitive match)
    "ALABAMA": "01",
    "ALASKA": "02",
    "ARIZONA": "04",
    "ARKANSAS": "05",
    "CALIFORNIA": "06",
    "COLORADO": "08",
    "CONNECTICUT": "09",
    "DELAWARE": "10",
    "FLORIDA": "12",
    "GEORGIA": "13",
    "HAWAII": "15",
    "IDAHO": "16",
    "ILLINOIS": "17",
    "INDIANA": "18",
    "IOWA": "19",
    "KANSAS": "20",
    "KENTUCKY": "21",
    "LOUISIANA": "22",
    "MAINE": "23",
    "MARYLAND": "24",
    "MASSACHUSETTS": "25",
    "MICHIGAN": "26",
    "MINNESOTA": "27",
    "MISSISSIPPI": "28",
    "MISSOURI": "29",
    "MONTANA": "30",
    "NEBRASKA": "31",
    "NEVADA": "32",
    "NEW HAMPSHIRE": "33",
    "NEW JERSEY": "34",
    "NEW MEXICO": "35",
    "NEW YORK": "36",
    "NORTH CAROLINA": "37",
    "NORTH DAKOTA": "38",
    "OHIO": "39",
    "OKLAHOMA": "40",
    "OREGON": "41",
    "PENNSYLVANIA": "42",
    "RHODE ISLAND": "44",
    "SOUTH CAROLINA": "45",
    "SOUTH DAKOTA": "46",
    "TENNESSEE": "47",
    "TEXAS": "48",
    "UTAH": "49",
    "VERMONT": "50",
    "VIRGINIA": "51",
    "WASHINGTON": "53",
    "WEST VIRGINIA": "54",
    "WISCONSIN": "55",
    "WYOMING": "56",
    # DC
    "DISTRICT OF COLUMBIA": "11",
    # US Territories
    "AMERICAN SAMOA": "60",
    "GUAM": "66",
    "NORTHERN MARIANA ISLANDS": "69",
    "PUERTO RICO": "72",
    "VIRGIN ISLANDS": "78",
    # Freely Associated States
    "MICRONESIA": "64",
    "MARSHALL ISLANDS": "68",
    "PALAU": "70"
}

# COMMAND ----------

try:
    import os, sys
    # Consider moving this block to a common function for reuse across notebooks.
    _notebook_path = dbutils.notebook.entry_point.getDbutils().notebook().getContext().notebookPath().get()
    _src_dir = os.path.normpath(f"/Workspace{os.path.dirname(_notebook_path)}/../../../")
    sys.path.insert(0, _src_dir)

    # Clear cached module to pick up renamed class
    sys.modules.pop('utilities.write_utils', None)
    sys.modules.pop('utilities.read_utils', None)
    sys.modules.pop('utilities', None)

    from utilities.write_utils import WriteUtils
    from utilities.read_utils import ReadUtils
except Exception:
    pass