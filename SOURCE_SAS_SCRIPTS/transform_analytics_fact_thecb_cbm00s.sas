/**************************************************************************** 
 * Job:             400_LOAD_CBM00S                       A5B29B8Q.BT0000S4 * 
 * Description:                                                             * 
 *                                                                          * 
 * Metadata Server: sasmetapaws8.ua.uta.edu                                 * 
 * Port:            8561                                                    * 
 * Location:        /UTA/ADW/400 Reports/CBM/Jobs                           * 
 *                                                                          * 
 * Server:          SASApp                                A5B29B8Q.AS000002 * 
 *                                                                          * 
 * Source Tables:   ADW_CBM_DLRNORPT -                    A5B29B8Q.BE00000F * 
 *                   CBMPRD.ADW_CBM_DLRNORPT                                * 
 *                  PS_SCTN_CMBND_Extract -               A5B29B8Q.BE00000D * 
 *                   ADWSTGPR.PS_SCTN_CMBND_Extract                         * 
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 * 
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          * 
 *                  PS_CLASS_ASSOC_Extract -              A5B29B8Q.BE00000A * 
 *                   ADWSTGPR.PS_CLASS_ASSOC_Extract                        * 
 *                  PS_UTA_CB_LOC_VW_Extract -            A5B29B8Q.BE00000B * 
 *                   ADWSTGPR.PS_UTA_CB_LOC_VW_Extract                      * 
 *                  PS_PERSON_SA_Extract -                A5B29B8Q.BE00000P * 
 *                   ADWSTGPR.PS_PERSON_SA_Extract                          * 
 *                  PS_SRVC_IND_DATA_Extract -            A5B29B8Q.BE00000Q * 
 *                   ADWSTGPR.PS_SRVC_IND_DATA_Extract                      * 
 *                  PS_PERS_NID_Extract -                 A5B29B8Q.BE00000R * 
 *                   ADWSTGPR.PS_PERS_NID_Extract                           * 
 *                  PS_EXTERNAL_SYSTEM_Extract -          A5B29B8Q.BE00000S * 
 *                   ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract                    * 
 *                  PS_ACAD_PLAN_Extract -                A5B29B8Q.BE00000G * 
 *                   ADWSTGPR.PS_ACAD_PLAN_Extract                          * 
 *                  PS_ACAD_PLAN_OWNER_Extract -          A5B29B8Q.BE00000I * 
 *                   ADWSTGPR.PS_ACAD_PLAN_OWNER_Extract                    * 
 *                  ADW_DEPT_DIM - ADWTGTPR.ADW_DEPT_DIM  A5B29B8Q.BE000011 * 
 *                  PS_ACAD_PLAN_TBL_Extract -            A5B29B8Q.BE00000H * 
 *                   ADWSTGPR.PS_ACAD_PLAN_TBL_Extract                      * 
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K * 
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     * 
 *                  PS_UTA_UNFUNDED_Extract -             A5B29B8Q.BE00000L * 
 *                   ADWSTGPR.PS_UTA_UNFUNDED_Extract                       * 
 *                  ADW_CBM_3PEATDEV -                    A5B29B8Q.BE00000M * 
 *                   CBMPRD.ADW_CBM_3PEATDEV                                * 
 *                  ADW_CBM_EXCESS_HOURS -                A5B29B8Q.BE00000N * 
 *                   CBMPRD.ADW_CBM_EXCESS_HOURS                            * 
 *                  PS_UTA_ACADPLAN_DTL_Extract -         A5B29B8Q.BE00000O * 
 *                   ADWSTGPR.PS_UTA_ACADPLAN_DTL_Extract                   * 
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 * 
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    * 
 *                  PS_CRSE_ATTR_VALUE_Extract -          A5B29B8Q.BE000006 * 
 *                   ADWSTGPR.PS_CRSE_ATTR_VALUE_Extract                    * 
 *                  PS_CRSE_ATTRIBUTES_Extract -          A5B29B8Q.BE000007 * 
 *                   ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract                    * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  PS_TRNS_TEST_DTL_Extract -            A5B29B8Q.BE00000X * 
 *                   ADWSTGPR.PS_TRNS_TEST_DTL_Extract                      * 
 *                  PS_TRNS_CRSE_DTL_Extract -            A5B29B8Q.BE00000Y * 
 *                   ADWSTGPR.PS_TRNS_CRSE_DTL_Extract                      * 
 *                  PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U * 
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      * 
 *                  PS_ADM_APPL_RCR_CA_Extract -          A5B29B8Q.BE00000V * 
 *                   ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract                    * 
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T * 
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      * 
 *                  PS_UTA_HEH_PLAN_TB_Extract -          A5B29B8Q.BE0001LC * 
 *                   ADWSTGPR.PS_UTA_HEH_PLAN_TB_Extract                    * 
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  PS_CRSE_CATALOG_Extract -             A5B29B8Q.BE000008 * 
 *                   ADWSTGPR.PS_CRSE_CATALOG_Extract                       * 
 *                  ADW_CBM00S_WORK -                     A5B29B8Q.BE00017F * 
 *                   ADWTGTPR.ADW_CBM00S_WORK                               * 
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K * 
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     * 
 *                  PS_EXT_COURSE_Extract -               A5B29B8Q.BE00000Z * 
 *                   ADWSTGPR.PS_EXT_COURSE_Extract                         * 
 *                  PS_TRNS_CRSE_DTL_Extract -            A5B29B8Q.BE00000Y * 
 *                   ADWSTGPR.PS_TRNS_CRSE_DTL_Extract                      * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J * 
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          * 
 *                  UTA_CB_FORMULA_FUNDING -              A5B29B8Q.BE0001E4 * 
 *                   CBMPRD.UTA_CB_FORMULA_FUNDING                          * 
 *                  ADW_DEPT_DIM - ADWTGTPR.ADW_DEPT_DIM  A5B29B8Q.BE000011 * 
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 * 
 *                  ADW_CBM00S_WORK -                     A5B29B8Q.BE00017F * 
 *                   ADWTGTPR.ADW_CBM00S_WORK                               * 
 *                  UTA_CB_CRSE_INVENTORY -               A5B29B8Q.BE0001E3 * 
 *                   CBMPRD.UTA_CB_CRSE_INVENTORY                           * 
 * Target Tables:   CBM00S_SNP - &CBM00SOutputFileLoc.    A5B29B8Q.BV00001A * 
 *                  ADW_CBM00S_WORK -                     A5B29B8Q.BE00017F * 
 *                   ADWTGTPR.ADW_CBM00S_WORK                               * 
 *                  ADW_CBM00S_SCH_WORK -                 A5B29B8Q.BE0001E2 * 
 *                   CBMPRD.ADW_CBM00S_SCH_WORK                             * 
 *                                                                          * 
 * Generated on:    Friday, March 6, 2026 9:28:53 AM CST                    * 
 * Generated by:    mynenit                                                 * 
 * Version:         SAS Data Integration Studio 4.905                       * 
 ****************************************************************************/ 

/* Generate the process id for job  */ 
%put Process ID: &SYSJOBID;

/* General macro variables  */ 
%let jobID = %quote(A5B29B8Q.BT0000S4);
%let etls_jobName = %nrquote(400_LOAD_CBM00S);
%let etls_userID = %nrquote(mynenit);

%global applName;
data _null_;
applName="SAS Data Integration Studio";
call symput('applName',%nrstr(applName));
run;
/* Performance Statistics require ARM_PROC sub-system   */ 
%macro etls_startPerformanceStats;
   %log4sas();
   %log4sas_logger(Perf.ARM, 'level=info');
   options armagent=log4sas armsubsys=(ARM_PROC);
   %global _armexec;
   %let _armexec = 1;
   %perfinit(applname="&applName");
   %global etls_recnt;
   %let etls_recnt=-1;
%mend;
%etls_startPerformanceStats;

%macro etls_setArmagent;
   %let armagentLength = %length(%sysfunc(getoption(armagent)));
   %if (&armagentLength eq 0) %then
      %do;
         %log4sas();
         %log4sas_logger(Perf.ARM, 'level=info');
         options armagent=log4sas armsubsys=(ARM_PROC);
      %end;
%mend etls_setArmagent;

%macro etls_setPerfInit;
   %if "&_perfinit" eq "0" %then 
      %do;
         %etls_setArmagent;
         %global _armexec;
         %let _armexec = 1;
         %perfinit(applname="&applName");
      %end;
%mend etls_setPerfInit; 

/* Setup to capture return codes  */ 
%global job_rc trans_rc sqlrc;
%let sysrc = 0;
%let job_rc = 0;
%let trans_rc = 0;
%let sqlrc = 0;
%let syscc = 0;
%global etls_stepStartTime; 
/* initialize syserr to 0 */ 
data _null_; run;

%macro rcSet(error); 
   %if (&error gt &trans_rc) %then 
      %let trans_rc = &error;
   %if (&error gt &job_rc) %then 
      %let job_rc = &error;
%mend rcSet; 

%macro rcSetDS(error); 
   if &error gt input(symget('trans_rc'),12.) then 
      call symput('trans_rc',trim(left(put(&error,12.))));
   if &error gt input(symget('job_rc'),12.) then 
      call symput('job_rc',trim(left(put(&error,12.))));
%mend rcSetDS; 

/* Create metadata macro variables */
%let IOMServer      = %nrquote(SASApp);
%let metaPort       = %nrquote(8561);
%let metaServer     = %nrquote(sasmetapaws8.ua.uta.edu);

/* Setup for capturing job status  */ 
%let etls_startTime = %sysfunc(datetime(),datetime.);
%let etls_recordsBefore = 0;
%let etls_recordsAfter = 0;
%let etls_lib = 0;
%let etls_table = 0;

%global etls_debug; 
%macro etls_setDebug; 
   %if %str(&etls_debug) ne 0 %then 
      OPTIONS MPRINT%str(;); 
%mend; 
%etls_setDebug; 

/*==========================================================================* 
 * Step:            Manual Run                            A5B29B8Q.BZ000A0U * 
 * Transform:       User Written                                            * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 * 
 * Target Table:    Term_Setup - work.Term_Setup          A5B29B8Q.BS0003BR * 
 *                                                                          * 
 * User Written:    SourceCode                                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A0U);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWTGTPR.ADW_TERM_DIM, DATA)) or 
         %sysfunc(exist(ADWTGTPR.ADW_TERM_DIM, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWTGTPR.ADW_TERM_DIM;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(ADWTGTPR.ADW_TERM_DIM); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|UserWritten), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%let _INPUT_count = 1;
%let _INPUT = ADWTGTPR.ADW_TERM_DIM;
%let _INPUT_connect =  DEFER=YES DBSERVER_MAX_BYTES=1 DBCLIENT_MAX_BYTES=1 ADJUST_BYTE_SEMANTIC_COLUMN_LENGTHS=YES DB_LENGTH_SEMANTICS_BYTE=YES DBSERVER_ENCODING_FIXED=YES DBCLIENT_ENCODING_FIXED=YES PATH=UTAAWSPD AUTHDOMAIN="ADWTGTPRD" 
;
%let _INPUT_engine = ORACLE;
%let _INPUT_memtype = DATA;
%let _INPUT_options = %nrquote();
%let _INPUT_alter = %nrquote();
%let _INPUT_path = %nrquote(/UTA/ADW/300 Load/Campus/Data/ADW_TERM_DIM%(Table%));
%let _INPUT_type = 1;
%let _INPUT_label = %nrquote();
%let _INPUT_filetype = PhysicalTable;

%let _INPUT1 = ADWTGTPR.ADW_TERM_DIM;
%let _INPUT1_connect =  DEFER=YES DBSERVER_MAX_BYTES=1 DBCLIENT_MAX_BYTES=1 ADJUST_BYTE_SEMANTIC_COLUMN_LENGTHS=YES DB_LENGTH_SEMANTICS_BYTE=YES DBSERVER_ENCODING_FIXED=YES DBCLIENT_ENCODING_FIXED=YES PATH=UTAAWSPD AUTHDOMAIN="ADWTGTPRD" 
;
%let _INPUT1_engine = ORACLE;
%let _INPUT1_memtype = DATA;
%let _INPUT1_options = %nrquote();
%let _INPUT1_alter = %nrquote();
%let _INPUT1_path = %nrquote(/UTA/ADW/300 Load/Campus/Data/ADW_TERM_DIM%(Table%));
%let _INPUT1_type = 1;
%let _INPUT1_label = %nrquote();
%let _INPUT1_filetype = PhysicalTable;

%let _OUTPUT_count = 1;
%let _OUTPUT = work.Term_Setup;
%let _OUTPUT_connect = ;
%let _OUTPUT_engine = ;
%let _OUTPUT_memtype = DATA;
%let _OUTPUT_options = %nrquote();
%let _OUTPUT_alter = %nrquote();
%let _OUTPUT_path = %nrquote(/Term_Setup_A5B29B8Q.BS0003BR%(WorkTable%));
%let _OUTPUT_type = 1;
%let _OUTPUT_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT_keep = STRM ACAD_CAREER TERM_BEGIN_DT TERM_END_DT CENSUS_DT Current_Term 
        Current_Term_End_Date;
%let _OUTPUT_col_count = 7;
%let _OUTPUT_col0_name = STRM;
%let _OUTPUT_col0_table = work.Term_Setup;
%let _OUTPUT_col0_length = 4;
%let _OUTPUT_col0_type = $;
%let _OUTPUT_col0_format = $4.;
%let _OUTPUT_col0_informat = $4.;
%let _OUTPUT_col0_label = %nrquote(STRM);
%let _OUTPUT_col0_exp = ;
%let _OUTPUT_col0_input_count = 0;
%let _OUTPUT_col1_name = ACAD_CAREER;
%let _OUTPUT_col1_table = work.Term_Setup;
%let _OUTPUT_col1_length = 4;
%let _OUTPUT_col1_type = $;
%let _OUTPUT_col1_format = $4.;
%let _OUTPUT_col1_informat = $4.;
%let _OUTPUT_col1_label = %nrquote(ACAD_CAREER);
%let _OUTPUT_col1_exp = ;
%let _OUTPUT_col1_input_count = 0;
%let _OUTPUT_col2_name = TERM_BEGIN_DT;
%let _OUTPUT_col2_table = work.Term_Setup;
%let _OUTPUT_col2_length = 8;
%let _OUTPUT_col2_type = ;
%let _OUTPUT_col2_format = DATETIME20.;
%let _OUTPUT_col2_informat = DATETIME20.;
%let _OUTPUT_col2_label = %nrquote(TERM_BEGIN_DT);
%let _OUTPUT_col2_exp = ;
%let _OUTPUT_col2_input_count = 0;
%let _OUTPUT_col3_name = TERM_END_DT;
%let _OUTPUT_col3_table = work.Term_Setup;
%let _OUTPUT_col3_length = 8;
%let _OUTPUT_col3_type = ;
%let _OUTPUT_col3_format = DATETIME20.;
%let _OUTPUT_col3_informat = DATETIME20.;
%let _OUTPUT_col3_label = %nrquote(TERM_END_DT);
%let _OUTPUT_col3_exp = ;
%let _OUTPUT_col3_input_count = 0;
%let _OUTPUT_col4_name = CENSUS_DT;
%let _OUTPUT_col4_table = work.Term_Setup;
%let _OUTPUT_col4_length = 8;
%let _OUTPUT_col4_type = ;
%let _OUTPUT_col4_format = DATETIME20.;
%let _OUTPUT_col4_informat = DATETIME20.;
%let _OUTPUT_col4_label = %nrquote(CENSUS_DT);
%let _OUTPUT_col4_exp = ;
%let _OUTPUT_col4_input_count = 0;
%let _OUTPUT_col5_name = Current_Term;
%let _OUTPUT_col5_table = work.Term_Setup;
%let _OUTPUT_col5_length = 8;
%let _OUTPUT_col5_type = $;
%let _OUTPUT_col5_format = $4.;
%let _OUTPUT_col5_informat = ;
%let _OUTPUT_col5_label = %nrquote(Current_Term);
%let _OUTPUT_col5_exp = ;
%let _OUTPUT_col5_input_count = 0;
%let _OUTPUT_col6_name = Current_Term_End_Date;
%let _OUTPUT_col6_table = work.Term_Setup;
%let _OUTPUT_col6_length = 8;
%let _OUTPUT_col6_type = ;
%let _OUTPUT_col6_format = Datetime20.;
%let _OUTPUT_col6_informat = DATETIME20.;
%let _OUTPUT_col6_label = %nrquote(Current_Term_End_Date);
%let _OUTPUT_col6_exp = ;
%let _OUTPUT_col6_input_count = 0;
%let _OUTPUT_filetype = WorkTable;

%let _OUTPUT1 = work.Term_Setup;
%let _OUTPUT1_connect = ;
%let _OUTPUT1_engine = ;
%let _OUTPUT1_memtype = DATA;
%let _OUTPUT1_options = %nrquote();
%let _OUTPUT1_alter = %nrquote();
%let _OUTPUT1_path = %nrquote(/Term_Setup_A5B29B8Q.BS0003BR%(WorkTable%));
%let _OUTPUT1_type = 1;
%let _OUTPUT1_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT1_keep = STRM ACAD_CAREER TERM_BEGIN_DT TERM_END_DT CENSUS_DT Current_Term 
        Current_Term_End_Date;
%let _OUTPUT1_col_count = 7;
%let _OUTPUT1_col0_name = STRM;
%let _OUTPUT1_col0_table = work.Term_Setup;
%let _OUTPUT1_col0_length = 4;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $4.;
%let _OUTPUT1_col0_informat = $4.;
%let _OUTPUT1_col0_label = %nrquote(STRM);
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input_count = 0;
%let _OUTPUT1_col1_name = ACAD_CAREER;
%let _OUTPUT1_col1_table = work.Term_Setup;
%let _OUTPUT1_col1_length = 4;
%let _OUTPUT1_col1_type = $;
%let _OUTPUT1_col1_format = $4.;
%let _OUTPUT1_col1_informat = $4.;
%let _OUTPUT1_col1_label = %nrquote(ACAD_CAREER);
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input_count = 0;
%let _OUTPUT1_col2_name = TERM_BEGIN_DT;
%let _OUTPUT1_col2_table = work.Term_Setup;
%let _OUTPUT1_col2_length = 8;
%let _OUTPUT1_col2_type = ;
%let _OUTPUT1_col2_format = DATETIME20.;
%let _OUTPUT1_col2_informat = DATETIME20.;
%let _OUTPUT1_col2_label = %nrquote(TERM_BEGIN_DT);
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input_count = 0;
%let _OUTPUT1_col3_name = TERM_END_DT;
%let _OUTPUT1_col3_table = work.Term_Setup;
%let _OUTPUT1_col3_length = 8;
%let _OUTPUT1_col3_type = ;
%let _OUTPUT1_col3_format = DATETIME20.;
%let _OUTPUT1_col3_informat = DATETIME20.;
%let _OUTPUT1_col3_label = %nrquote(TERM_END_DT);
%let _OUTPUT1_col3_exp = ;
%let _OUTPUT1_col3_input_count = 0;
%let _OUTPUT1_col4_name = CENSUS_DT;
%let _OUTPUT1_col4_table = work.Term_Setup;
%let _OUTPUT1_col4_length = 8;
%let _OUTPUT1_col4_type = ;
%let _OUTPUT1_col4_format = DATETIME20.;
%let _OUTPUT1_col4_informat = DATETIME20.;
%let _OUTPUT1_col4_label = %nrquote(CENSUS_DT);
%let _OUTPUT1_col4_exp = ;
%let _OUTPUT1_col4_input_count = 0;
%let _OUTPUT1_col5_name = Current_Term;
%let _OUTPUT1_col5_table = work.Term_Setup;
%let _OUTPUT1_col5_length = 8;
%let _OUTPUT1_col5_type = $;
%let _OUTPUT1_col5_format = $4.;
%let _OUTPUT1_col5_informat = ;
%let _OUTPUT1_col5_label = %nrquote(Current_Term);
%let _OUTPUT1_col5_exp = ;
%let _OUTPUT1_col5_input_count = 0;
%let _OUTPUT1_col6_name = Current_Term_End_Date;
%let _OUTPUT1_col6_table = work.Term_Setup;
%let _OUTPUT1_col6_length = 8;
%let _OUTPUT1_col6_type = ;
%let _OUTPUT1_col6_format = Datetime20.;
%let _OUTPUT1_col6_informat = DATETIME20.;
%let _OUTPUT1_col6_label = %nrquote(Current_Term_End_Date);
%let _OUTPUT1_col6_exp = ;
%let _OUTPUT1_col6_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/ 

/*%let current_term=2235;
%let prior_term=2232;*/
/*%let current_term=2238;
%let prior_term=2235;
%let current_term=2242;
%let prior_term=2238;*/
/*%let current_term=2245;
%let prior_term=2242;*/
/*%let current_term=2248;
%let prior_term=2245;
%let current_term=2255;
%let prior_term=2252;*/
%let current_term=2258;
%let prior_term=2255;
proc sql ;
create table work.CBM00S_Term as

select
ADW_TERM_DIM.STRM,
ADW_TERM_DIM.ACAD_CAREER,
ADW_TERM_DIM.TERM_BEGIN_DT,
ADW_TERM_DIM.TERM_END_DT,
ADW_TERM_DIM.TERM_SK,
ADW_TERM_DIM.CENSUS_DT,
ADW_TERM_DIM.STRM as Current_Term
from
ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
where
ADW_TERM_DIM.STRM ="&current_term"
and ADW_TERM_DIM.ACAD_CAREER = 'UGRD'

union all

select
ADW_TERM_DIM.STRM,
ADW_TERM_DIM.ACAD_CAREER,
ADW_TERM_DIM.TERM_BEGIN_DT,
ADW_TERM_DIM.TERM_END_DT,
ADW_TERM_DIM.TERM_SK,
ADW_TERM_DIM.CENSUS_DT,
case when substr(ADW_TERM_DIM.STRM,4,1)='8' then PUT(INPUT(ADW_TERM_DIM.STRM,BEST8.)+4,4.)
else  PUT(INPUT(ADW_TERM_DIM.STRM,BEST8.)+3,4.)
end  as Current_Term
from
ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
where
ADW_TERM_DIM.ACAD_CAREER = 'UGRD'
and ADW_TERM_DIM.STRM ="&prior_term"
and DATEPART(DATETIME()) > DATEPART(ADW_TERM_DIM.TERM_END_DT)
group by
ADW_TERM_DIM.ACAD_CAREER
having
ADW_TERM_DIM.STRM = MAX(ADW_TERM_DIM.STRM)
;


create table work.Term_Setup as
select
CBM00S_Term.STRM,
CBM00S_Term.TERM_BEGIN_DT,
CBM00S_Term.TERM_END_DT,
CBM00S_Term.TERM_SK,
CBM00S_Term.CENSUS_DT,
CBM00S_Term.Current_Term,
CBM00S_Term.ACAD_CAREER,
MAX(CBM00S_Term.TERM_END_DT) as Current_Term_End_Date
from
work.CBM00S_Term as CBM00S_Term
group by
CBM00S_Term.ACAD_CAREER
;
quit;

data _null_;
set work.Term_Setup end=lastobs;

 if not lastobs then do;
 	call symput('current_term',STRM);
  	call symput('current_term_begin_date', TERM_BEGIN_DT);
 	call symput('current_term_end_date', TERM_END_DT);
	call symput('current_term_sk', term_sk);
 	call symput('current_term_census_date', CENSUS_DT);
 end;
 else do;
 	call symput('prior_term',STRM);
	call symput('prior_term_begin_date', TERM_BEGIN_DT);
 	call symput('prior_term_end_date', TERM_END_DT);
 	call symput('prior_term_sk', term_sk);
 	call symput('prior_term_census_date', CENSUS_DT);
 end;

run;


/*---- End of User Written Code  ----*/ 

%rcSet(&syserr); 
%rcSet(&sqlrc); 
%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Manual Run **/

/*==========================================================================* 
 * Step:            Class Attribute Info                  A5B29B8Q.BZ000A0V * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 * 
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    * 
 *                  PS_CRSE_ATTR_VALUE_Extract -          A5B29B8Q.BE000006 * 
 *                   ADWSTGPR.PS_CRSE_ATTR_VALUE_Extract                    * 
 * Target Table:    CLASS_ATTRIBUTE -                     A5B29B8Q.BS0003BS * 
 *                   work.CBM00S_CLASS_ATTRIBUTE                            * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A0V);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_CLASS_ATTRIBUTE;
quit;

proc sql;
   create table work.CBM00S_CLASS_ATTRIBUTE as
   select
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_CLASS_ATTRIBUTE_Extract.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      PS_CLASS_ATTRIBUTE_Extract.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_CLASS_ATTRIBUTE_Extract.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      PS_CLASS_ATTRIBUTE_Extract.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      PS_CRSE_ATTR_VALUE_Extract.CRSE_ATTR as ATTRVALTBL_ATTR length = 8   
         label = 'ATTRVALTBL_ATTR',
      PS_CRSE_ATTR_VALUE_Extract.CRSE_ATTR_VALUE as ATTRVALTBL_ATTR_VALUE length = 10   
         format = $10.
         informat = $10.
         label = 'ATTRVALTBL_ATTR_VALUE'
   from
      ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract as PS_CLASS_ATTRIBUTE_Extract inner join 
      ADWSTGPR.PS_CRSE_ATTR_VALUE_Extract as PS_CRSE_ATTR_VALUE_Extract
         on
         (
            PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR = PS_CRSE_ATTR_VALUE_Extract.CRSE_ATTR
            and PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR_VALUE = PS_CRSE_ATTR_VALUE_Extract.CRSE_ATTR_VALUE
         )
   group by
      PS_CRSE_ATTR_VALUE_Extract.CRSE_ATTR,
      PS_CRSE_ATTR_VALUE_Extract.CRSE_ATTR_VALUE
   having
      PS_CRSE_ATTR_VALUE_Extract.EFFDT = MAX(PS_CRSE_ATTR_VALUE_Extract.EFFDT)
   order by
      CRSE_ID,
      CRSE_OFFER_NBR,
      STRM,
      SESSION_CODE,
      CLASS_SECTION
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Class Attribute Info **/

/*==========================================================================* 
 * Step:            User Written (Class Attributes)       A5B29B8Q.BZ000A0W * 
 * Transform:       User Written                                            * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CLASS_ATTRIBUTE -                     A5B29B8Q.BS0003BS * 
 *                   work.CBM00S_CLASS_ATTRIBUTE                            * 
 * Target Table:    User Written -                        A5B29B8Q.BS0003BT * 
 *                   work.CBM00S_CLASS_ATTRIBUTES                           * 
 *                                                                          * 
 * User Written:    SourceCode                                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A0W);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_CLASS_ATTRIBUTE, DATA)) or 
         %sysfunc(exist(work.CBM00S_CLASS_ATTRIBUTE, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_CLASS_ATTRIBUTE out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(work.CBM00S_CLASS_ATTRIBUTE); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|UserWritten), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%let _INPUT_count = 1;
%let _INPUT = work.CBM00S_CLASS_ATTRIBUTE;
%let _INPUT_connect = ;
%let _INPUT_engine = ;
%let _INPUT_memtype = DATA;
%let _INPUT_options = %nrquote();
%let _INPUT_alter = %nrquote();
%let _INPUT_path = %nrquote(/CLASS_ATTRIBUTE_A5B29B8Q.BS0003BS%(WorkTable%));
%let _INPUT_type = 1;
%let _INPUT_label = %nrquote();
%let _INPUT_filetype = WorkTable;

%let _INPUT1 = work.CBM00S_CLASS_ATTRIBUTE;
%let _INPUT1_connect = ;
%let _INPUT1_engine = ;
%let _INPUT1_memtype = DATA;
%let _INPUT1_options = %nrquote();
%let _INPUT1_alter = %nrquote();
%let _INPUT1_path = %nrquote(/CLASS_ATTRIBUTE_A5B29B8Q.BS0003BS%(WorkTable%));
%let _INPUT1_type = 1;
%let _INPUT1_label = %nrquote();
%let _INPUT1_filetype = WorkTable;

%let _OUTPUT_count = 1;
%let _OUTPUT = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT_connect = ;
%let _OUTPUT_engine = ;
%let _OUTPUT_memtype = DATA;
%let _OUTPUT_options = %nrquote();
%let _OUTPUT_alter = %nrquote();
%let _OUTPUT_path = %nrquote(/User Written_A5B29B8Q.BS0003BT%(WorkTable%));
%let _OUTPUT_type = 1;
%let _OUTPUT_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT_keep = CRSE_ID CRSE_OFFER_NBR STRM SESSION_CODE CLASS_SECTION ATTR_LIST 
        VAL_LIST;
%let _OUTPUT_col_count = 7;
%let _OUTPUT_col0_name = CRSE_ID;
%let _OUTPUT_col0_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT_col0_length = 6;
%let _OUTPUT_col0_type = $;
%let _OUTPUT_col0_format = $6.;
%let _OUTPUT_col0_informat = $6.;
%let _OUTPUT_col0_label = %nrquote(CRSE_ID);
%let _OUTPUT_col0_exp = ;
%let _OUTPUT_col0_input_count = 0;
%let _OUTPUT_col1_name = CRSE_OFFER_NBR;
%let _OUTPUT_col1_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT_col1_length = 8;
%let _OUTPUT_col1_type = ;
%let _OUTPUT_col1_format = ;
%let _OUTPUT_col1_informat = ;
%let _OUTPUT_col1_label = %nrquote(CRSE_OFFER_NBR);
%let _OUTPUT_col1_exp = ;
%let _OUTPUT_col1_input_count = 0;
%let _OUTPUT_col2_name = STRM;
%let _OUTPUT_col2_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT_col2_length = 4;
%let _OUTPUT_col2_type = $;
%let _OUTPUT_col2_format = $4.;
%let _OUTPUT_col2_informat = $4.;
%let _OUTPUT_col2_label = %nrquote(STRM);
%let _OUTPUT_col2_exp = ;
%let _OUTPUT_col2_input_count = 0;
%let _OUTPUT_col3_name = SESSION_CODE;
%let _OUTPUT_col3_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT_col3_length = 3;
%let _OUTPUT_col3_type = $;
%let _OUTPUT_col3_format = $3.;
%let _OUTPUT_col3_informat = $3.;
%let _OUTPUT_col3_label = %nrquote(SESSION_CODE);
%let _OUTPUT_col3_exp = ;
%let _OUTPUT_col3_input_count = 0;
%let _OUTPUT_col4_name = CLASS_SECTION;
%let _OUTPUT_col4_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT_col4_length = 4;
%let _OUTPUT_col4_type = $;
%let _OUTPUT_col4_format = $4.;
%let _OUTPUT_col4_informat = $4.;
%let _OUTPUT_col4_label = %nrquote(CLASS_SECTION);
%let _OUTPUT_col4_exp = ;
%let _OUTPUT_col4_input_count = 0;
%let _OUTPUT_col5_name = ATTR_LIST;
%let _OUTPUT_col5_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT_col5_length = 50;
%let _OUTPUT_col5_type = $;
%let _OUTPUT_col5_format = ;
%let _OUTPUT_col5_informat = ;
%let _OUTPUT_col5_label = %nrquote(ATTR_LIST);
%let _OUTPUT_col5_exp = ;
%let _OUTPUT_col5_input_count = 0;
%let _OUTPUT_col6_name = VAL_LIST;
%let _OUTPUT_col6_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT_col6_length = 100;
%let _OUTPUT_col6_type = $;
%let _OUTPUT_col6_format = ;
%let _OUTPUT_col6_informat = ;
%let _OUTPUT_col6_label = %nrquote(VAL_LIST);
%let _OUTPUT_col6_exp = ;
%let _OUTPUT_col6_input_count = 0;
%let _OUTPUT_filetype = WorkTable;

%let _OUTPUT1 = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT1_connect = ;
%let _OUTPUT1_engine = ;
%let _OUTPUT1_memtype = DATA;
%let _OUTPUT1_options = %nrquote();
%let _OUTPUT1_alter = %nrquote();
%let _OUTPUT1_path = %nrquote(/User Written_A5B29B8Q.BS0003BT%(WorkTable%));
%let _OUTPUT1_type = 1;
%let _OUTPUT1_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT1_keep = CRSE_ID CRSE_OFFER_NBR STRM SESSION_CODE CLASS_SECTION ATTR_LIST 
        VAL_LIST;
%let _OUTPUT1_col_count = 7;
%let _OUTPUT1_col0_name = CRSE_ID;
%let _OUTPUT1_col0_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT1_col0_length = 6;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $6.;
%let _OUTPUT1_col0_informat = $6.;
%let _OUTPUT1_col0_label = %nrquote(CRSE_ID);
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input_count = 0;
%let _OUTPUT1_col1_name = CRSE_OFFER_NBR;
%let _OUTPUT1_col1_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT1_col1_length = 8;
%let _OUTPUT1_col1_type = ;
%let _OUTPUT1_col1_format = ;
%let _OUTPUT1_col1_informat = ;
%let _OUTPUT1_col1_label = %nrquote(CRSE_OFFER_NBR);
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input_count = 0;
%let _OUTPUT1_col2_name = STRM;
%let _OUTPUT1_col2_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT1_col2_length = 4;
%let _OUTPUT1_col2_type = $;
%let _OUTPUT1_col2_format = $4.;
%let _OUTPUT1_col2_informat = $4.;
%let _OUTPUT1_col2_label = %nrquote(STRM);
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input_count = 0;
%let _OUTPUT1_col3_name = SESSION_CODE;
%let _OUTPUT1_col3_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT1_col3_length = 3;
%let _OUTPUT1_col3_type = $;
%let _OUTPUT1_col3_format = $3.;
%let _OUTPUT1_col3_informat = $3.;
%let _OUTPUT1_col3_label = %nrquote(SESSION_CODE);
%let _OUTPUT1_col3_exp = ;
%let _OUTPUT1_col3_input_count = 0;
%let _OUTPUT1_col4_name = CLASS_SECTION;
%let _OUTPUT1_col4_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT1_col4_length = 4;
%let _OUTPUT1_col4_type = $;
%let _OUTPUT1_col4_format = $4.;
%let _OUTPUT1_col4_informat = $4.;
%let _OUTPUT1_col4_label = %nrquote(CLASS_SECTION);
%let _OUTPUT1_col4_exp = ;
%let _OUTPUT1_col4_input_count = 0;
%let _OUTPUT1_col5_name = ATTR_LIST;
%let _OUTPUT1_col5_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT1_col5_length = 50;
%let _OUTPUT1_col5_type = $;
%let _OUTPUT1_col5_format = ;
%let _OUTPUT1_col5_informat = ;
%let _OUTPUT1_col5_label = %nrquote(ATTR_LIST);
%let _OUTPUT1_col5_exp = ;
%let _OUTPUT1_col5_input_count = 0;
%let _OUTPUT1_col6_name = VAL_LIST;
%let _OUTPUT1_col6_table = work.CBM00S_CLASS_ATTRIBUTES;
%let _OUTPUT1_col6_length = 100;
%let _OUTPUT1_col6_type = $;
%let _OUTPUT1_col6_format = ;
%let _OUTPUT1_col6_informat = ;
%let _OUTPUT1_col6_label = %nrquote(VAL_LIST);
%let _OUTPUT1_col6_exp = ;
%let _OUTPUT1_col6_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/ 

data work.CBM00S_CLASS_ATTRIBUTES;
	set work.CBM00S_CLASS_ATTRIBUTE;
	by CRSE_ID CRSE_OFFER_NBR STRM SESSION_CODE CLASS_SECTION;
	
	retain ATTR_LIST VAL_LIST;
	length ATTR_LIST VAL_LIST $100;
	if first.CLASS_SECTION then do;
		ATTR_LIST='';
		VAL_LIST='';
	end;
   first_section=first.class_section;
   last_section=last.class_section;
	ATTR_LIST=catx(',',trim(ATTR_LIST),ATTRVALTBL_ATTR);
	VAL_LIST=catx(',',trim(VAL_LIST),ATTRVALTBL_ATTR_VALUE);
	if last.CLASS_SECTION then output;
run;
/*---- End of User Written Code  ----*/ 

%rcSet(&syserr); 
%rcSet(&sqlrc); 
%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end User Written (Class Attributes) **/

/*==========================================================================* 
 * Step:            Max Eff Dated                         A5B29B8Q.BZ000A0X * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    PS_CRSE_ATTRIBUTES_Extract -          A5B29B8Q.BE000007 * 
 *                   ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract                    * 
 * Target Table:    CBM00S_CRSE_ATTRIBUTE -               A5B29B8Q.BS0003BU * 
 *                   work.CBM00S_CRSE_ATTRIBUTE                             * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A0X);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_CRSE_ATTRIBUTE;
quit;

proc sql;
   create table work.CBM00S_CRSE_ATTRIBUTE as
   select
      PS_CRSE_ATTRIBUTES_Extract.CRSE_ATTR length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_ATTR',
      PS_CRSE_ATTRIBUTES_Extract.CRSE_ATTR_VALUE length = 10   
         format = $10.
         informat = $10.
         label = 'CRSE_ATTR_VALUE',
      PS_CRSE_ATTRIBUTES_Extract.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_CRSE_ATTRIBUTES_Extract.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_CRSE_ATTRIBUTES_Extract.SCC_ROW_ADD_DTTM length = 8   
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      PS_CRSE_ATTRIBUTES_Extract.SCC_ROW_ADD_OPRID length = 30   
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      PS_CRSE_ATTRIBUTES_Extract.SCC_ROW_UPD_DTTM length = 8   
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      PS_CRSE_ATTRIBUTES_Extract.SCC_ROW_UPD_OPRID length = 30   
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      PS_CRSE_ATTRIBUTES_Extract.READ_DTM length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_CRSE_ATTRIBUTES_Extract.STAGE_UPDATE_ID length = 20   
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract as PS_CRSE_ATTRIBUTES_Extract
   where
      PS_CRSE_ATTRIBUTES_Extract.EFFDT <= &current_term_begin_date
   group by
      PS_CRSE_ATTRIBUTES_Extract.CRSE_ID
   having
      PS_CRSE_ATTRIBUTES_Extract.EFFDT = MAX(PS_CRSE_ATTRIBUTES_Extract.EFFDT)
      and PS_CRSE_ATTRIBUTES_Extract.EFFDT < datetime()
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Max Eff Dated **/

/*==========================================================================* 
 * Step:            User Written (Course Attributes)      A5B29B8Q.BZ000A0Y * 
 * Transform:       User Written                                            * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM00S_CRSE_ATTRIBUTE -               A5B29B8Q.BS0003BU * 
 *                   work.CBM00S_CRSE_ATTRIBUTE                             * 
 * Target Table:    User Written -                        A5B29B8Q.BS0003BV * 
 *                   work.CBM00S_COURSE_ATTRIBUTE                           * 
 *                                                                          * 
 * User Written:    SourceCode                                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A0Y);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_CRSE_ATTRIBUTE, DATA)) or 
         %sysfunc(exist(work.CBM00S_CRSE_ATTRIBUTE, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_CRSE_ATTRIBUTE out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(work.CBM00S_CRSE_ATTRIBUTE); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|UserWritten), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%let _INPUT_count = 1;
%let _INPUT = work.CBM00S_CRSE_ATTRIBUTE;
%let _INPUT_connect = ;
%let _INPUT_engine = ;
%let _INPUT_memtype = DATA;
%let _INPUT_options = %nrquote();
%let _INPUT_alter = %nrquote();
%let _INPUT_path = %nrquote(/CBM00S_CRSE_ATTRIBUTE_A5B29B8Q.BS0003BU%(WorkTable%));
%let _INPUT_type = 1;
%let _INPUT_label = %nrquote();
%let _INPUT_filetype = WorkTable;

%let _INPUT1 = work.CBM00S_CRSE_ATTRIBUTE;
%let _INPUT1_connect = ;
%let _INPUT1_engine = ;
%let _INPUT1_memtype = DATA;
%let _INPUT1_options = %nrquote();
%let _INPUT1_alter = %nrquote();
%let _INPUT1_path = %nrquote(/CBM00S_CRSE_ATTRIBUTE_A5B29B8Q.BS0003BU%(WorkTable%));
%let _INPUT1_type = 1;
%let _INPUT1_label = %nrquote();
%let _INPUT1_filetype = WorkTable;

%let _OUTPUT_count = 1;
%let _OUTPUT = work.CBM00S_COURSE_ATTRIBUTE;
%let _OUTPUT_connect = ;
%let _OUTPUT_engine = ;
%let _OUTPUT_memtype = DATA;
%let _OUTPUT_options = %nrquote();
%let _OUTPUT_alter = %nrquote();
%let _OUTPUT_path = %nrquote(/User Written_A5B29B8Q.BS0003BV%(WorkTable%));
%let _OUTPUT_type = 1;
%let _OUTPUT_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT_keep = CRSE_ID CRSE_ATTR_LIST CRSE_VAL_LIST;
%let _OUTPUT_col_count = 3;
%let _OUTPUT_col0_name = CRSE_ID;
%let _OUTPUT_col0_table = work.CBM00S_COURSE_ATTRIBUTE;
%let _OUTPUT_col0_length = 6;
%let _OUTPUT_col0_type = $;
%let _OUTPUT_col0_format = $6.;
%let _OUTPUT_col0_informat = $6.;
%let _OUTPUT_col0_label = %nrquote(CRSE_ID);
%let _OUTPUT_col0_exp = ;
%let _OUTPUT_col0_input_count = 0;
%let _OUTPUT_col1_name = CRSE_ATTR_LIST;
%let _OUTPUT_col1_table = work.CBM00S_COURSE_ATTRIBUTE;
%let _OUTPUT_col1_length = 50;
%let _OUTPUT_col1_type = $;
%let _OUTPUT_col1_format = ;
%let _OUTPUT_col1_informat = ;
%let _OUTPUT_col1_label = %nrquote(CRSE_ATTR_LIST);
%let _OUTPUT_col1_exp = ;
%let _OUTPUT_col1_input_count = 0;
%let _OUTPUT_col2_name = CRSE_VAL_LIST;
%let _OUTPUT_col2_table = work.CBM00S_COURSE_ATTRIBUTE;
%let _OUTPUT_col2_length = 50;
%let _OUTPUT_col2_type = $;
%let _OUTPUT_col2_format = ;
%let _OUTPUT_col2_informat = ;
%let _OUTPUT_col2_label = %nrquote(CRSE_VAL_LIST);
%let _OUTPUT_col2_exp = ;
%let _OUTPUT_col2_input_count = 0;
%let _OUTPUT_filetype = WorkTable;

%let _OUTPUT1 = work.CBM00S_COURSE_ATTRIBUTE;
%let _OUTPUT1_connect = ;
%let _OUTPUT1_engine = ;
%let _OUTPUT1_memtype = DATA;
%let _OUTPUT1_options = %nrquote();
%let _OUTPUT1_alter = %nrquote();
%let _OUTPUT1_path = %nrquote(/User Written_A5B29B8Q.BS0003BV%(WorkTable%));
%let _OUTPUT1_type = 1;
%let _OUTPUT1_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT1_keep = CRSE_ID CRSE_ATTR_LIST CRSE_VAL_LIST;
%let _OUTPUT1_col_count = 3;
%let _OUTPUT1_col0_name = CRSE_ID;
%let _OUTPUT1_col0_table = work.CBM00S_COURSE_ATTRIBUTE;
%let _OUTPUT1_col0_length = 6;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $6.;
%let _OUTPUT1_col0_informat = $6.;
%let _OUTPUT1_col0_label = %nrquote(CRSE_ID);
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input_count = 0;
%let _OUTPUT1_col1_name = CRSE_ATTR_LIST;
%let _OUTPUT1_col1_table = work.CBM00S_COURSE_ATTRIBUTE;
%let _OUTPUT1_col1_length = 50;
%let _OUTPUT1_col1_type = $;
%let _OUTPUT1_col1_format = ;
%let _OUTPUT1_col1_informat = ;
%let _OUTPUT1_col1_label = %nrquote(CRSE_ATTR_LIST);
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input_count = 0;
%let _OUTPUT1_col2_name = CRSE_VAL_LIST;
%let _OUTPUT1_col2_table = work.CBM00S_COURSE_ATTRIBUTE;
%let _OUTPUT1_col2_length = 50;
%let _OUTPUT1_col2_type = $;
%let _OUTPUT1_col2_format = ;
%let _OUTPUT1_col2_informat = ;
%let _OUTPUT1_col2_label = %nrquote(CRSE_VAL_LIST);
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/ 

data work.CBM00S_COURSE_ATTRIBUTE;
	set work.CBM00S_CRSE_ATTRIBUTE;
	by CRSE_ID;
	
	retain CRSE_ATTR_LIST CRSE_VAL_LIST;
	length CRSE_ATTR_LIST CRSE_VAL_LIST $100;
	if first.CRSE_ID then do;
		CRSE_ATTR_LIST='';
		CRSE_VAL_LIST='';
	end;

	CRSE_ATTR_LIST=catx(',',trim(CRSE_ATTR_LIST),CRSE_ATTR);
	CRSE_VAL_LIST=catx(',',trim(CRSE_VAL_LIST),CRSE_ATTR_VALUE);
	if last.CRSE_ID then output;
run;
/*---- End of User Written Code  ----*/ 

%rcSet(&syserr); 
%rcSet(&sqlrc); 
%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end User Written (Course Attributes) **/

/*==========================================================================* 
 * Step:            Max Eff Dated -Course Catalog         A5B29B8Q.BZ000A0Z * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    PS_CRSE_CATALOG_Extract -             A5B29B8Q.BE000008 * 
 *                   ADWSTGPR.PS_CRSE_CATALOG_Extract                       * 
 * Target Table:    CBM00S_CORE_COURSE -                  A5B29B8Q.BS0003BW * 
 *                   work.CBM00S_CORE_COURSE                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A0Z);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_CRSE_CATALOG_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_CRSE_CATALOG_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_CRSE_CATALOG_Extract;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(ADWSTGPR.PS_CRSE_CATALOG_Extract); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_CORE_COURSE;
quit;

proc sql;
   create view work.CBM00S_CORE_COURSE as
   select
      PS_CRSE_CATALOG_Extract.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_CRSE_CATALOG_Extract.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      PS_CRSE_CATALOG_Extract.CRSE_CONTACT_HRS length = 8   
         format = 8.2
         informat = 8.2
         label = 'CRSE_CONTACT_HRS',
      PS_CRSE_CATALOG_Extract.RQMNT_DESIGNTN length = 4   
         format = $4.
         informat = $4.
         label = 'RQMNT_DESIGNTN'
   from
      ADWSTGPR.PS_CRSE_CATALOG_Extract as PS_CRSE_CATALOG_Extract
   where
      PS_CRSE_CATALOG_Extract.EFFDT <= &current_term_begin_date
      and PS_CRSE_CATALOG_Extract.EFF_STATUS = 'A'
   group by
      PS_CRSE_CATALOG_Extract.CRSE_ID
   having
      PS_CRSE_CATALOG_Extract.EFFDT = MAX(PS_CRSE_CATALOG_Extract.EFFDT)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Max Eff Dated -Course Catalog **/

/*==========================================================================* 
 * Step:            Course_Info                           A5B29B8Q.BZ000A10 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   User Written -                        A5B29B8Q.BS0003BT * 
 *                   work.CBM00S_CLASS_ATTRIBUTES                           * 
 *                  User Written -                        A5B29B8Q.BS0003BV * 
 *                   work.CBM00S_COURSE_ATTRIBUTE                           * 
 *                  PS_SCTN_CMBND_Extract -               A5B29B8Q.BE00000D * 
 *                   ADWSTGPR.PS_SCTN_CMBND_Extract                         * 
 *                  CBM00S_CORE_COURSE -                  A5B29B8Q.BS0003BW * 
 *                   work.CBM00S_CORE_COURSE                                * 
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 * 
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          * 
 *                  PS_CLASS_ASSOC_Extract -              A5B29B8Q.BE00000A * 
 *                   ADWSTGPR.PS_CLASS_ASSOC_Extract                        * 
 *                  PS_UTA_CB_LOC_VW_Extract -            A5B29B8Q.BE00000B * 
 *                   ADWSTGPR.PS_UTA_CB_LOC_VW_Extract                      * 
 * Target Table:    CBM00S_Course_Info -                  A5B29B8Q.BS0003BX * 
 *                   work.CBM00S_Course_Info                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A10);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_CLASS_ATTRIBUTES, DATA)) or 
         %sysfunc(exist(work.CBM00S_CLASS_ATTRIBUTES, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_CLASS_ATTRIBUTES out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Course_Info;
quit;

proc sql;
   create table work.CBM00S_Course_Info as
   select
      PS_CLASS_TBL_Extract.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_CLASS_TBL_Extract.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      PS_CLASS_TBL_Extract.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      PS_CLASS_TBL_Extract.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      PS_CLASS_TBL_Extract.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      PS_CLASS_TBL_Extract.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      PS_CLASS_TBL_Extract.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      PS_CLASS_TBL_Extract.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      PS_CLASS_TBL_Extract.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      PS_SCTN_CMBND_Extract.SCTN_COMBINED_ID as COMBINED_SECTION_ID length = 4   
         format = $4.
         informat = $4.
         label = 'COMBINED_SECTION_ID',
      PS_CLASS_TBL_Extract.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_CLASS_TBL_Extract.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      PS_CLASS_TBL_Extract.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      PS_CLASS_TBL_Extract.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      PS_CLASS_TBL_Extract.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_CLASS_TBL_Extract.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      PS_CLASS_TBL_Extract.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      PS_CLASS_TBL_Extract.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      PS_CLASS_TBL_Extract.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      PS_CLASS_TBL_Extract.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      PS_CLASS_TBL_Extract.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_CLASS_TBL_Extract.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      PS_CLASS_ASSOC_Extract.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      PS_CLASS_ASSOC_Extract.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      PS_CLASS_ASSOC_Extract.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      IFC(PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOCATION_CD NOT IN ('0','6','9') &
      PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOCATION_CD NOT IS MISSING, 
      SUBSTR(PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOC_VALUE, LENGTH(PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOC_VALUE)-4,5),'') as OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      IFC(PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOCATION_CD IN ('0','6','9'),
      IFC(PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOC_VALUE IS MISSING,'',
      STRIP(PUT(INPUT(PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOC_VALUE,BEST8.),6.))),'') as EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      IFC(PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOCATION_CD='','0',PS_UTA_CB_LOC_VW_Extract.UTA_CB_LOCATION_CD) as UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_CLASS_ATTRIBUTES.ATTR_LIST as CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_CLASS_ATTRIBUTES.VAL_LIST as CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_COURSE_ATTRIBUTE.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_COURSE_ATTRIBUTE.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      case when FIND(UPCASE(CBM00S_CLASS_ATTRIBUTES.VAL_LIST),'EXCLUDE' )<>0 then 'Yes'
      else 'No' end as CB_Exclude length = 8   
         label = 'CB_Exclude',
      ifc( find(CBM00S_CLASS_ATTRIBUTES.ATTR_LIST, 'NCBO')>0 or find(CBM00S_CLASS_ATTRIBUTES.VAL_LIST , 'NCBOCO')>0, 'Y' ,'N') as NCBO length = 8   
         label = 'NCBO',
      case when CBM00S_CORE_COURSE.RQMNT_DESIGNTN in ('020','2092', '092', '040','060','070','080','098','4094','8098','010','1091','030','050','3093','5095') then 'Yes' 
      else  'No' end as Core_Course length = 8   
         label = 'Core_Course',
      case  
      when CBM00S_CORE_COURSE.RQMNT_DESIGNTN  in ('020','2092', '092') then 1 
      else 0  
      end as MathCore length = 8   
         label = 'MathCore',
      case 
      when CBM00S_CORE_COURSE.RQMNT_DESIGNTN in ('040','060','070','080','098','4094','8098') then 1
      else 0 
      end as ReadCore length = 8   
         label = 'ReadCore',
      case 
      when CBM00S_CORE_COURSE.RQMNT_DESIGNTN in ('010','1091') then 1
      else 0 
      end as WriteCore length = 8   
         label = 'WriteCore',
      ifc( find(UPCASE(CBM00S_CLASS_ATTRIBUTES.ATTR_LIST) ,'DLRN')>0 ,'Y' , 'N' ) as DLRN_Course length = 1   
         label = 'DLRN_Course',
      ifc( find(UPCASE(CBM00S_CLASS_ATTRIBUTES.ATTR_LIST) ,'HEH')>0 ,'Y' , 'N' ) as AP_Course length = 1   
         label = 'AP_Course'
   from
      ADWSTGPR.PS_CLASS_TBL_Extract as PS_CLASS_TBL_Extract left join 
      ADWSTGPR.PS_CLASS_ASSOC_Extract as PS_CLASS_ASSOC_Extract
         on
         (
            PS_CLASS_TBL_Extract.STRM = PS_CLASS_ASSOC_Extract.STRM
            and PS_CLASS_TBL_Extract.SESSION_CODE = PS_CLASS_ASSOC_Extract.SESSION_CODE
            and PS_CLASS_TBL_Extract.CRSE_ID = PS_CLASS_ASSOC_Extract.CRSE_ID
            and PS_CLASS_TBL_Extract.CRSE_OFFER_NBR = PS_CLASS_ASSOC_Extract.CRSE_OFFER_NBR
            and PS_CLASS_TBL_Extract.ASSOCIATED_CLASS = PS_CLASS_ASSOC_Extract.ASSOCIATED_CLASS
         ) left join 
      ADWSTGPR.PS_UTA_CB_LOC_VW_Extract as PS_UTA_CB_LOC_VW_Extract
         on
         (
            PS_CLASS_TBL_Extract.LOCATION = PS_UTA_CB_LOC_VW_Extract.LOCATION
         ) left join 
      work.CBM00S_CLASS_ATTRIBUTES as CBM00S_CLASS_ATTRIBUTES
         on
         (
            PS_CLASS_TBL_Extract.STRM = CBM00S_CLASS_ATTRIBUTES.STRM
            and PS_CLASS_TBL_Extract.CRSE_ID = CBM00S_CLASS_ATTRIBUTES.CRSE_ID
            and PS_CLASS_TBL_Extract.CRSE_OFFER_NBR = CBM00S_CLASS_ATTRIBUTES.CRSE_OFFER_NBR
            and PS_CLASS_TBL_Extract.SESSION_CODE = CBM00S_CLASS_ATTRIBUTES.SESSION_CODE
            and PS_CLASS_TBL_Extract.CLASS_SECTION = CBM00S_CLASS_ATTRIBUTES.CLASS_SECTION
         ) left join 
      ADWSTGPR.PS_SCTN_CMBND_Extract as PS_SCTN_CMBND_Extract
         on
         (
            PS_CLASS_TBL_Extract.STRM = PS_SCTN_CMBND_Extract.STRM
            and PS_CLASS_TBL_Extract.SESSION_CODE = PS_SCTN_CMBND_Extract.SESSION_CODE
            and PS_CLASS_TBL_Extract.CLASS_NBR = PS_SCTN_CMBND_Extract.CLASS_NBR
         ) left join 
      work.CBM00S_COURSE_ATTRIBUTE as CBM00S_COURSE_ATTRIBUTE
         on
         (
            PS_CLASS_TBL_Extract.CRSE_ID = CBM00S_COURSE_ATTRIBUTE.CRSE_ID
         ) left join 
      work.CBM00S_CORE_COURSE as CBM00S_CORE_COURSE
         on
         (
            CBM00S_COURSE_ATTRIBUTE.CRSE_ID = CBM00S_CORE_COURSE.CRSE_ID
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Course_Info **/

/*==========================================================================* 
 * Step:            Enrollment_Current_term               A5B29B8Q.BZ000A11 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  Term_Setup - work.Term_Setup          A5B29B8Q.BS0003BR * 
 * Target Table:    CBM00S_StudentEnrollment -            A5B29B8Q.BS0003BY * 
 *                   work.CBM00S_StudentEnrollment                          * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A11);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_STDNT_ENRL_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_STDNT_ENRL_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_STDNT_ENRL_Extract;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_StudentEnrollment;
quit;

proc sql;
   create table work.CBM00S_StudentEnrollment as
   select
      PS_STDNT_ENRL_Extract.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_STDNT_ENRL_Extract.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      PS_STDNT_ENRL_Extract.ASSOCIATED_CLASS length = 8   
         label = 'ASSOCIATED_CLASS',
      PS_STDNT_ENRL_Extract.ASSOCIATION_99 length = 1   
         format = $1.
         informat = $1.
         label = 'ASSOCIATION_99',
      PS_STDNT_ENRL_Extract.AUDIT_GRADE_BASIS length = 1   
         format = $1.
         informat = $1.
         label = 'AUDIT_GRADE_BASIS',
      PS_STDNT_ENRL_Extract.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      PS_STDNT_ENRL_Extract.CLASS_PRMSN_NBR length = 8   
         label = 'CLASS_PRMSN_NBR',
      PS_STDNT_ENRL_Extract.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      PS_STDNT_ENRL_Extract.CRSE_COUNT length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_COUNT',
      PS_STDNT_ENRL_Extract.CRSE_GRADE_INPUT length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_INPUT',
      PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      PS_STDNT_ENRL_Extract.DROP_CLASS_IF_ENRL length = 8   
         label = 'DROP_CLASS_IF_ENRL',
      PS_STDNT_ENRL_Extract.DYN_CLASS_NBR length = 8   
         label = 'DYN_CLASS_NBR',
      PS_STDNT_ENRL_Extract.EARN_CREDIT length = 1   
         format = $1.
         informat = $1.
         label = 'EARN_CREDIT',
      PS_STDNT_ENRL_Extract.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_STDNT_ENRL_Extract.ENRL_ACTION_LAST length = 2   
         format = $2.
         informat = $2.
         label = 'ENRL_ACTION_LAST',
      PS_STDNT_ENRL_Extract.ENRL_ACTN_PRC_LAST length = 2   
         format = $2.
         informat = $2.
         label = 'ENRL_ACTN_PRC_LAST',
      PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_ACTN_RSN_LAST',
      PS_STDNT_ENRL_Extract.ENRL_ADD_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      PS_STDNT_ENRL_Extract.ENRL_DROP_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_DROP_DT',
      PS_STDNT_ENRL_Extract.ENRL_REQ_SOURCE length = 2   
         format = $2.
         informat = $2.
         label = 'ENRL_REQ_SOURCE',
      PS_STDNT_ENRL_Extract.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      PS_STDNT_ENRL_Extract.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      PS_STDNT_ENRL_Extract.GRADE_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'GRADE_DT',
      PS_STDNT_ENRL_Extract.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      PS_STDNT_ENRL_Extract.GRADE_POINTS_FA length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS_FA',
      PS_STDNT_ENRL_Extract.GRADING_BASIS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'GRADING_BASIS_DT',
      PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL length = 3   
         format = $3.
         informat = $3.
         label = 'GRADING_BASIS_ENRL',
      PS_STDNT_ENRL_Extract.GRADING_SCHEME_ENR length = 3   
         format = $3.
         informat = $3.
         label = 'GRADING_SCHEME_ENR',
      PS_STDNT_ENRL_Extract.GRD_PTS_PER_UNIT length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRD_PTS_PER_UNIT',
      PS_STDNT_ENRL_Extract.INCLUDE_IN_GPA length = 1   
         format = $1.
         informat = $1.
         label = 'INCLUDE_IN_GPA',
      PS_STDNT_ENRL_Extract.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_STDNT_ENRL_Extract.INSTRUCTOR_ID length = 11   
         format = $11.
         informat = $11.
         label = 'INSTRUCTOR_ID',
      PS_STDNT_ENRL_Extract.LAST_DROP_DT_STMP length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_DROP_DT_STMP',
      PS_STDNT_ENRL_Extract.LAST_DROP_TM_STMP length = 8   
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LAST_DROP_TM_STMP',
      PS_STDNT_ENRL_Extract.LAST_ENRL_DT_STMP length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_ENRL_DT_STMP',
      PS_STDNT_ENRL_Extract.LAST_ENRL_TM_STMP length = 8   
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LAST_ENRL_TM_STMP',
      PS_STDNT_ENRL_Extract.LAST_UPD_DT_STMP length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_UPD_DT_STMP',
      PS_STDNT_ENRL_Extract.LAST_UPD_ENREQ_SRC length = 2   
         format = $2.
         informat = $2.
         label = 'LAST_UPD_ENREQ_SRC',
      PS_STDNT_ENRL_Extract.LAST_UPD_TM_STMP length = 8   
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LAST_UPD_TM_STMP',
      PS_STDNT_ENRL_Extract.MANDATORY_GRD_BAS length = 1   
         format = $1.
         informat = $1.
         label = 'MANDATORY_GRD_BAS',
      PS_STDNT_ENRL_Extract.NOTIFY_STDNT_CHNG length = 2   
         format = $2.
         informat = $2.
         label = 'NOTIFY_STDNT_CHNG',
      PS_STDNT_ENRL_Extract.OPRID length = 30   
         format = $30.
         informat = $30.
         label = 'OPRID',
      PS_STDNT_ENRL_Extract.OVRD_GRADING_BASIS length = 1   
         format = $1.
         informat = $1.
         label = 'OVRD_GRADING_BASIS',
      PS_STDNT_ENRL_Extract.RELATE_CLASS_NBR_1 length = 8   
         label = 'RELATE_CLASS_NBR_1',
      PS_STDNT_ENRL_Extract.RELATE_CLASS_NBR_2 length = 8   
         label = 'RELATE_CLASS_NBR_2',
      PS_STDNT_ENRL_Extract.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      PS_STDNT_ENRL_Extract.REPEAT_CODE length = 4   
         format = $4.
         informat = $4.
         label = 'REPEAT_CODE',
      PS_STDNT_ENRL_Extract.REPEAT_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'REPEAT_DT',
      PS_STDNT_ENRL_Extract.RQMNT_DESIGNTN length = 4   
         format = $4.
         informat = $4.
         label = 'RQMNT_DESIGNTN',
      PS_STDNT_ENRL_Extract.RQMNT_DESIGNTN_GRD length = 1   
         format = $1.
         informat = $1.
         label = 'RQMNT_DESIGNTN_GRD',
      PS_STDNT_ENRL_Extract.RQMNT_DESIGNTN_OPT length = 1   
         format = $1.
         informat = $1.
         label = 'RQMNT_DESIGNTN_OPT',
      PS_STDNT_ENRL_Extract.RSRV_CAP_NBR length = 8   
         label = 'RSRV_CAP_NBR',
      PS_STDNT_ENRL_Extract.SEL_GROUP length = 10   
         format = $10.
         informat = $10.
         label = 'SEL_GROUP',
      PS_STDNT_ENRL_Extract.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      PS_STDNT_ENRL_Extract.SESSN_ENRL_CNTL length = 3   
         format = $3.
         informat = $3.
         label = 'SESSN_ENRL_CNTL',
      PS_STDNT_ENRL_Extract.STATUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'STATUS_DT',
      PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS length = 2   
         format = $2.
         informat = $2.
         label = 'STDNT_ENRL_STATUS',
      PS_STDNT_ENRL_Extract.STDNT_POSITIN length = 8   
         label = 'STDNT_POSITIN',
      PS_STDNT_ENRL_Extract.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_STDNT_ENRL_Extract.TSCRPT_NOTE_EXISTS length = 1   
         format = $1.
         informat = $1.
         label = 'TSCRPT_NOTE_EXISTS',
      PS_STDNT_ENRL_Extract.TSCRPT_NOTE_ID length = 4   
         format = $4.
         informat = $4.
         label = 'TSCRPT_NOTE_ID',
      PS_STDNT_ENRL_Extract.UNITS_ATTEMPTED length = 1   
         format = $1.
         informat = $1.
         label = 'UNITS_ATTEMPTED',
      PS_STDNT_ENRL_Extract.UNT_BILLING length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_BILLING',
      PS_STDNT_ENRL_Extract.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      PS_STDNT_ENRL_Extract.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      PS_STDNT_ENRL_Extract.UNT_PRGRSS_FA length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS_FA',
      PS_STDNT_ENRL_Extract.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      PS_STDNT_ENRL_Extract.VALID_ATTEMPT length = 1   
         format = $1.
         informat = $1.
         label = 'VALID_ATTEMPT',
      PS_STDNT_ENRL_Extract.READ_DTM length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_STDNT_ENRL_Extract.STAGE_UPDATE_ID length = 20   
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID',
      Term_Setup.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      Term_Setup.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      Term_Setup.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      Term_Setup.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      Term_Setup.Current_Term_End_Date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_Date'
   from
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract inner join 
      work.Term_Setup as Term_Setup
         on
         (
            PS_STDNT_ENRL_Extract.STRM = Term_Setup.STRM
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Enrollment_Current_term **/

/*==========================================================================* 
 * Step:            Enrollment+Course                     A5B29B8Q.BZ000A12 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_Course_Info -                  A5B29B8Q.BS0003BX * 
 *                   work.CBM00S_Course_Info                                * 
 *                  CBM00S_StudentEnrollment -            A5B29B8Q.BS0003BY * 
 *                   work.CBM00S_StudentEnrollment                          * 
 * Target Table:    CBM00S_Enrollment -                   A5B29B8Q.BS0003BZ * 
 *                   work.CBM00S_Enrollment                                 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A12);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_Course_Info, DATA)) or 
         %sysfunc(exist(work.CBM00S_Course_Info, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_Course_Info out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Enrollment;
quit;

proc sql;
   create table work.CBM00S_Enrollment as
   select
      CBM00S_StudentEnrollment.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_StudentEnrollment.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_StudentEnrollment.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_StudentEnrollment.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_StudentEnrollment.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_StudentEnrollment.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_StudentEnrollment.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_Course_Info.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_Course_Info.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_Course_Info.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_Course_Info.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_StudentEnrollment.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_StudentEnrollment.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_StudentEnrollment.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_Course_Info.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_Course_Info.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_StudentEnrollment.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_StudentEnrollment.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_StudentEnrollment.Current_Term_End_Date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_Course_Info.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_Course_Info.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_Course_Info.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_StudentEnrollment.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_StudentEnrollment.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_Course_Info.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_Course_Info.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_Course_Info.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_Course_Info.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_Course_Info.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_Course_Info.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_Course_Info.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_Course_Info.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_Course_Info.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_Course_Info.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_Course_Info.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_Course_Info.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_Course_Info.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_Course_Info.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_Course_Info.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_Course_Info.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_StudentEnrollment.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_Course_Info.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_Course_Info.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_StudentEnrollment.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_Course_Info.NCBO length = 8   
         label = 'NCBO',
      CBM00S_StudentEnrollment.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_Course_Info.COMBINED_SECTION_ID length = 4   
         format = $4.
         informat = $4.
         label = 'COMBINED_SECTION_ID',
      CBM00S_Course_Info.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_Course_Info.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_StudentEnrollment.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_Course_Info.Core_Course length = 8   
         label = 'Core_Course',
      CBM00S_Course_Info.MathCore length = 8   
         label = 'MathCore',
      CBM00S_Course_Info.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_Course_Info.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_Course_Info.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_Course_Info.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_StudentEnrollment as CBM00S_StudentEnrollment inner join 
      work.CBM00S_Course_Info as CBM00S_Course_Info
         on
         (
            CBM00S_StudentEnrollment.STRM = CBM00S_Course_Info.STRM
            and CBM00S_StudentEnrollment.STRM = CBM00S_Course_Info.STRM
            and CBM00S_StudentEnrollment.SESSION_CODE = CBM00S_Course_Info.SESSION_CODE
            and CBM00S_StudentEnrollment.CLASS_NBR = CBM00S_Course_Info.CLASS_NBR
            and CBM00S_Course_Info.INSTITUTION = 'UTARL'
            and CBM00S_StudentEnrollment.STDNT_ENRL_STATUS = 'E'
            and (CBM00S_StudentEnrollment.ENRL_ACTN_RSN_LAST <> 'CENS'
            or CBM00S_StudentEnrollment.ENRL_ACTN_RSN_LAST IS MISSING )
            and CBM00S_Course_Info.CLASS_STAT IN ('A','S')
            and CBM00S_Course_Info.CLASS_TYPE IN ('E','N')
         )
   where
      CBM00S_Course_Info.ACAD_ORG <> 'TRAN'
      and CBM00S_StudentEnrollment.CRSE_GRADE_OFF <> 'AU'
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Enrollment+Course **/

/*==========================================================================* 
 * Step:            Removing Duplicate DLRN               A5B29B8Q.BZ000A13 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    ADW_CBM_DLRNORPT -                    A5B29B8Q.BE00000F * 
 *                   CBMPRD.ADW_CBM_DLRNORPT                                * 
 * Target Table:    CBM00S_DLRN_Unduplicated -            A5B29B8Q.BS0003C0 * 
 *                   work.CBM00S_DLRN_Unduplicated                          * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A13);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM_DLRNORPT, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM_DLRNORPT, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from CBMPRD.ADW_CBM_DLRNORPT;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(CBMPRD.ADW_CBM_DLRNORPT); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_DLRN_Unduplicated;
quit;

proc sql;
   create view work.CBM00S_DLRN_Unduplicated as
   select distinct
      ADW_CBM_DLRNORPT.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_CBM_DLRNORPT.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID'
   from
      CBMPRD.ADW_CBM_DLRNORPT as ADW_CBM_DLRNORPT
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Removing Duplicate DLRN **/

/*==========================================================================* 
 * Step:            DLRN column added                     A5B29B8Q.BZ000A14 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_Enrollment -                   A5B29B8Q.BS0003BZ * 
 *                   work.CBM00S_Enrollment                                 * 
 *                  CBM00S_DLRN_Unduplicated -            A5B29B8Q.BS0003C0 * 
 *                   work.CBM00S_DLRN_Unduplicated                          * 
 * Target Table:    CBM00S_DLRN - work.CBM00S_DLRN        A5B29B8Q.BS0003C1 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A14);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_Enrollment, DATA)) or 
         %sysfunc(exist(work.CBM00S_Enrollment, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_Enrollment out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_DLRN;
quit;

data _null_;
   put "NOTE: The following column(s) do not have a column mapping, so the"
        " value(s) will be set to missing: COMBINED_SECTION, Prior_Term";
run;

proc sql;
   create table work.CBM00S_DLRN as
   select distinct
      CBM00S_Enrollment.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_Enrollment.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_Enrollment.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_Enrollment.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_Enrollment.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_Enrollment.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_Enrollment.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_Enrollment.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_Enrollment.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_Enrollment.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_Enrollment.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_Enrollment.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_Enrollment.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_Enrollment.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_Enrollment.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_Enrollment.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      "" as COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_Enrollment.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_Enrollment.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_Enrollment.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_Enrollment.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_Enrollment.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_Enrollment.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_Enrollment.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_Enrollment.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_Enrollment.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_Enrollment.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      case 
         when CBM00S_DLRN_Unduplicated.EMPLID  IS NULL or   CBM00S_DLRN_Unduplicated.EMPLID =''
            then 'No'
      else 'Yes'
      end as DLRN_Student length = 8   
         label = 'Distance Learning Student',
      "" as Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_Enrollment.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_Enrollment.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_Enrollment.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_Enrollment.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_Enrollment.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_Enrollment.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_Enrollment.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_Enrollment.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_Enrollment.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_Enrollment.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_Enrollment.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_Enrollment.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_Enrollment.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_Enrollment.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_Enrollment.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_Enrollment.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_Enrollment.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_Enrollment.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_Enrollment.NCBO length = 8   
         label = 'NCBO',
      CBM00S_Enrollment.COMBINED_SECTION_ID length = 4   
         format = $4.
         informat = $4.
         label = 'COMBINED_SECTION_ID',
      CBM00S_Enrollment.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_Enrollment.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_Enrollment.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_Enrollment.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      /*case when (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and CBM00S_Enrollment.SESSION_CODE<>'DYN') 
      or (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and CBM00S_Enrollment.SESSION_CODE='DYN' and CBM00S_Enrollment.END_DT<=CBM00S_Enrollment.Current_Term_End_date)  
      or ( input(CBM00S_Enrollment.Current_Term,BEST8.) - INPUT(CBM00S_Enrollment.STRM,BEST8.) > 0 and CBM00S_Enrollment.SESSION_CODE='DYN' and CBM00S_Enrollment.END_DT 
      <=CBM00S_Enrollment.Current_Term_End_date and CBM00S_Enrollment.END_DT > CBM00S_Enrollment.TERM_END_DT ) 
      then 'Yes' 
      else 'No' 
      end*/
      
      case when (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and STRIP(CBM00S_Enrollment.SESSION_CODE)='1' and substr(CBM00S_Enrollment.STRM,4,1) in ('2','8')) 
      or (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and STRIP(CBM00S_Enrollment.SESSION_CODE)='5W2' and substr(CBM00S_Enrollment.STRM,4,1)='5')
      or (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and CBM00S_Enrollment.SESSION_CODE <> '1' and substr(CBM00S_Enrollment.STRM,4,1) in ('2','8') and CBM00S_Enrollment.END_DT<=CBM00S_Enrollment.Current_Term_End_date)  
      or (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and CBM00S_Enrollment.SESSION_CODE <> '5W2' and substr(CBM00S_Enrollment.STRM,4,1) ='5' and CBM00S_Enrollment.END_DT<=CBM00S_Enrollment.Current_Term_End_date)
      or ( input(CBM00S_Enrollment.Current_Term,BEST8.) - INPUT(CBM00S_Enrollment.STRM,BEST8.) > 0 and CBM00S_Enrollment.SESSION_CODE <> '5W2' and  substr(CBM00S_Enrollment.Current_Term,4,1)  in ('2','8')
      and CBM00S_Enrollment.END_DT <=CBM00S_Enrollment.Current_Term_End_date and CBM00S_Enrollment.END_DT > CBM00S_Enrollment.TERM_END_DT ) 
      or ( input(CBM00S_Enrollment.Current_Term,BEST8.) - INPUT(CBM00S_Enrollment.STRM,BEST8.) > 0 and CBM00S_Enrollment.SESSION_CODE <> '1' and substr(CBM00S_Enrollment.Current_Term,4,1) ='5' 
      and CBM00S_Enrollment.END_DT <=CBM00S_Enrollment.Current_Term_End_date and CBM00S_Enrollment.END_DT > CBM00S_Enrollment.TERM_END_DT ) 
      then 'Yes' 
      else 'No' 
      end as Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_Enrollment.Core_Course length = 8   
         label = 'Core_Course',
      case when (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and STRIP(CBM00S_Enrollment.SESSION_CODE)='1' and substr(CBM00S_Enrollment.STRM,4,1) in ('2','8') and CBM00S_Enrollment.END_DT <= CBM00S_Enrollment.TERM_END_DT) 
      or (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and STRIP(CBM00S_Enrollment.SESSION_CODE)='5W2' and substr(CBM00S_Enrollment.STRM,4,1)='5' and CBM00S_Enrollment.END_DT <= CBM00S_Enrollment.TERM_END_DT)
      or (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and CBM00S_Enrollment.SESSION_CODE <> '1' and substr(CBM00S_Enrollment.STRM,4,1) in ('2','8') and CBM00S_Enrollment.END_DT<=CBM00S_Enrollment.Current_Term_End_date)  
      or (CBM00S_Enrollment.STRM=CBM00S_Enrollment.Current_Term and CBM00S_Enrollment.SESSION_CODE <> '5W2' and substr(CBM00S_Enrollment.STRM,4,1) ='5' and CBM00S_Enrollment.END_DT<=CBM00S_Enrollment.Current_Term_End_date)
      or ( input(CBM00S_Enrollment.Current_Term,BEST8.) - INPUT(CBM00S_Enrollment.STRM,BEST8.) > 0 and CBM00S_Enrollment.SESSION_CODE <> '5W2' and  substr(CBM00S_Enrollment.Current_Term,4,1)  in ('2','8')
      and CBM00S_Enrollment.END_DT <=CBM00S_Enrollment.Current_Term_End_date and CBM00S_Enrollment.END_DT > CBM00S_Enrollment.TERM_END_DT ) 
      or ( input(CBM00S_Enrollment.Current_Term,BEST8.) - INPUT(CBM00S_Enrollment.STRM,BEST8.) > 0 and CBM00S_Enrollment.SESSION_CODE <> '1' and substr(CBM00S_Enrollment.Current_Term,4,1) ='5' 
      and CBM00S_Enrollment.END_DT <=CBM00S_Enrollment.Current_Term_End_date and CBM00S_Enrollment.END_DT > CBM00S_Enrollment.TERM_END_DT ) 
      then 'Yes' 
      else 'No' 
      end as Test length = 8   
         label = 'Test',
      CBM00S_Enrollment.MathCore length = 8   
         label = 'MathCore',
      CBM00S_Enrollment.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_Enrollment.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_Enrollment.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_Enrollment.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_Enrollment as CBM00S_Enrollment left join 
      work.CBM00S_DLRN_Unduplicated as CBM00S_DLRN_Unduplicated
         on
         (
            CBM00S_Enrollment.Current_Term = CBM00S_DLRN_Unduplicated.STRM
            and CBM00S_Enrollment.EMPLID = CBM00S_DLRN_Unduplicated.EMPLID
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end DLRN column added **/

/*==========================================================================* 
 * Step:            CB Reported Logic                     A5B29B8Q.BZ000A15 * 
 * Transform:       Join                                                    * 
 * Description:     CB_Reported_Student ='Yes' and                          * 
 *                   CB_Reported_Course='Yes' -> CB_Reported                * 
 *                                                                          * 
 * Source Table:    CBM00S_DLRN - work.CBM00S_DLRN        A5B29B8Q.BS0003C1 * 
 * Target Table:    CBM00S_CBReported -                   A5B29B8Q.BS0003C2 * 
 *                   work.CBM00S_CBReported                                 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A15);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_DLRN, DATA)) or 
         %sysfunc(exist(work.CBM00S_DLRN, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_DLRN out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(work.CBM00S_DLRN); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_CBReported;
quit;

proc sql;
   create table work.CBM00S_CBReported as
   select
      CBM00S_DLRN.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_DLRN.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_DLRN.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_DLRN.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_DLRN.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_DLRN.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_DLRN.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_DLRN.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_DLRN.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_DLRN.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_DLRN.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_DLRN.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_DLRN.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_DLRN.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_DLRN.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_DLRN.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_DLRN.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_DLRN.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_DLRN.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_DLRN.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_DLRN.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_DLRN.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_DLRN.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_DLRN.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_DLRN.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_DLRN.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_DLRN.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_DLRN.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_DLRN.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_DLRN.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_DLRN.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_DLRN.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_DLRN.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_DLRN.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_DLRN.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_DLRN.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_DLRN.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_DLRN.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_DLRN.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_DLRN.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_DLRN.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_DLRN.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_DLRN.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_DLRN.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_DLRN.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_DLRN.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_DLRN.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_DLRN.NCBO length = 8   
         label = 'NCBO',
      CBM00S_DLRN.COMBINED_SECTION_ID length = 4   
         format = $4.
         informat = $4.
         label = 'COMBINED_SECTION_ID',
      CBM00S_DLRN.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_DLRN.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_DLRN.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      case when CBM00S_DLRN.Current_Semester_Reportable ='Yes' and CBM00S_DLRN.DLRN_Student ='No' 
      and CBM00S_DLRN.CRSE_GRADE_OFF <>'AU'   then 'Y' 
      else 'N' 
      end as CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      case
      when CBM00S_DLRN.Current_Semester_Reportable ='Yes' and CBM00S_DLRN.CB_Exclude ='No'
      and CBM00S_DLRN.ACAD_GROUP <>'TRAN' and CBM00S_DLRN.SUBJECT not in ('ASA','EXCH')  then 'Y' 
      else 'N' end as CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_DLRN.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_DLRN.Core_Course length = 8   
         label = 'Core_Course',
      CBM00S_DLRN.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_DLRN.Test length = 8   
         label = 'Test',
      CBM00S_DLRN.MathCore length = 8   
         label = 'MathCore',
      CBM00S_DLRN.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_DLRN.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_DLRN.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_DLRN.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_DLRN as CBM00S_DLRN
   where
      Current_Semester_Reportable = 'Yes'
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end CB Reported Logic **/

/*==========================================================================* 
 * Step:            Combined Section Code Implementation  A5B29B8Q.BZ000A16 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM00S_CBReported -                   A5B29B8Q.BS0003C2 * 
 *                   work.CBM00S_CBReported                                 * 
 * Target Table:    CBM00S_COMBINED_SECTION -             A5B29B8Q.BS0003C3 * 
 *                   work.CBM00S_COMBINED_SECTION                           * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A16);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_CBReported, DATA)) or 
         %sysfunc(exist(work.CBM00S_CBReported, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_CBReported out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(work.CBM00S_CBReported); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_COMBINED_SECTION;
quit;

proc sql;
   create view work.CBM00S_COMBINED_SECTION as
   select distinct
      CBM00S_CBReported.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_CBReported.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_CBReported.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_CBReported.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_CBReported.COMBINED_SECTION_ID length = 4   
         format = $4.
         informat = $4.
         label = 'COMBINED_SECTION_ID',
      &current_term as Current_Term length = 8   
         label = 'Current_Term'
   from
      work.CBM00S_CBReported as CBM00S_CBReported
   where
      CBM00S_CBReported.COMBINED_SECTION_ID NOT IS MISSING 
   order by
      CBM00S_CBReported.STRM,
      CBM00S_CBReported.SESSION_CODE,
      CBM00S_CBReported.COMBINED_SECTION_ID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Combined Section Code Implementation **/

/*==========================================================================* 
 * Step:            User Written                          A5B29B8Q.BZ000A17 * 
 * Transform:       User Written                                            * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM00S_COMBINED_SECTION -             A5B29B8Q.BS0003C3 * 
 *                   work.CBM00S_COMBINED_SECTION                           * 
 * Target Table:    CBM00S_COMBINED_ID -                  A5B29B8Q.BS0003C4 * 
 *                   work.CBM00S_COMBINED_ID                                * 
 *                                                                          * 
 * User Written:    SourceCode                                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A17);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = -1;
%let SYSLAST = %nrquote(work.CBM00S_COMBINED_SECTION); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|UserWritten), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%let _INPUT_count = 1;
%let _INPUT = work.CBM00S_COMBINED_SECTION;
%let _INPUT_connect = ;
%let _INPUT_engine = ;
%let _INPUT_memtype = VIEW;
%let _INPUT_options = %nrquote();
%let _INPUT_alter = %nrquote();
%let _INPUT_path = %nrquote(/CBM00S_COMBINED_SECTION_A5B29B8Q.BS0003C3%(WorkTable%));
%let _INPUT_type = 1;
%let _INPUT_label = %nrquote();
%let _INPUT_filetype = WorkTable;

%let _INPUT1 = work.CBM00S_COMBINED_SECTION;
%let _INPUT1_connect = ;
%let _INPUT1_engine = ;
%let _INPUT1_memtype = VIEW;
%let _INPUT1_options = %nrquote();
%let _INPUT1_alter = %nrquote();
%let _INPUT1_path = %nrquote(/CBM00S_COMBINED_SECTION_A5B29B8Q.BS0003C3%(WorkTable%));
%let _INPUT1_type = 1;
%let _INPUT1_label = %nrquote();
%let _INPUT1_filetype = WorkTable;

%let _OUTPUT_count = 1;
%let _OUTPUT = work.CBM00S_COMBINED_ID;
%let _OUTPUT_connect = ;
%let _OUTPUT_engine = ;
%let _OUTPUT_memtype = DATA;
%let _OUTPUT_options = %nrquote();
%let _OUTPUT_alter = %nrquote();
%let _OUTPUT_path = %nrquote(/CBM00S_COMBINED_ID_A5B29B8Q.BS0003C4%(WorkTable%));
%let _OUTPUT_type = 1;
%let _OUTPUT_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT_keep = STRM CLASS_NBR SESSION_CODE COMBINED_SECTION_ID COMBINED_SECTION_CODE;
%let _OUTPUT_col_count = 5;
%let _OUTPUT_col0_name = STRM;
%let _OUTPUT_col0_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT_col0_length = 4;
%let _OUTPUT_col0_type = $;
%let _OUTPUT_col0_format = $4.;
%let _OUTPUT_col0_informat = $4.;
%let _OUTPUT_col0_label = %nrquote(STRM);
%let _OUTPUT_col0_exp = ;
%let _OUTPUT_col0_input_count = 0;
%let _OUTPUT_col1_name = CLASS_NBR;
%let _OUTPUT_col1_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT_col1_length = 8;
%let _OUTPUT_col1_type = ;
%let _OUTPUT_col1_format = ;
%let _OUTPUT_col1_informat = ;
%let _OUTPUT_col1_label = %nrquote(CLASS_NBR);
%let _OUTPUT_col1_exp = ;
%let _OUTPUT_col1_input_count = 0;
%let _OUTPUT_col2_name = SESSION_CODE;
%let _OUTPUT_col2_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT_col2_length = 3;
%let _OUTPUT_col2_type = $;
%let _OUTPUT_col2_format = $3.;
%let _OUTPUT_col2_informat = $3.;
%let _OUTPUT_col2_label = %nrquote(SESSION_CODE);
%let _OUTPUT_col2_exp = ;
%let _OUTPUT_col2_input_count = 0;
%let _OUTPUT_col3_name = COMBINED_SECTION_ID;
%let _OUTPUT_col3_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT_col3_length = 4;
%let _OUTPUT_col3_type = $;
%let _OUTPUT_col3_format = $4.;
%let _OUTPUT_col3_informat = $4.;
%let _OUTPUT_col3_label = %nrquote(COMBINED_SECTION_ID);
%let _OUTPUT_col3_exp = ;
%let _OUTPUT_col3_input_count = 0;
%let _OUTPUT_col4_name = COMBINED_SECTION_CODE;
%let _OUTPUT_col4_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT_col4_length = 8;
%let _OUTPUT_col4_type = $;
%let _OUTPUT_col4_format = ;
%let _OUTPUT_col4_informat = ;
%let _OUTPUT_col4_label = %nrquote(COMBINED_SECTION_CODE);
%let _OUTPUT_col4_exp = ;
%let _OUTPUT_col4_input_count = 0;
%let _OUTPUT_filetype = WorkTable;

%let _OUTPUT1 = work.CBM00S_COMBINED_ID;
%let _OUTPUT1_connect = ;
%let _OUTPUT1_engine = ;
%let _OUTPUT1_memtype = DATA;
%let _OUTPUT1_options = %nrquote();
%let _OUTPUT1_alter = %nrquote();
%let _OUTPUT1_path = %nrquote(/CBM00S_COMBINED_ID_A5B29B8Q.BS0003C4%(WorkTable%));
%let _OUTPUT1_type = 1;
%let _OUTPUT1_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT1_keep = STRM CLASS_NBR SESSION_CODE COMBINED_SECTION_ID COMBINED_SECTION_CODE;
%let _OUTPUT1_col_count = 5;
%let _OUTPUT1_col0_name = STRM;
%let _OUTPUT1_col0_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT1_col0_length = 4;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $4.;
%let _OUTPUT1_col0_informat = $4.;
%let _OUTPUT1_col0_label = %nrquote(STRM);
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input_count = 0;
%let _OUTPUT1_col1_name = CLASS_NBR;
%let _OUTPUT1_col1_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT1_col1_length = 8;
%let _OUTPUT1_col1_type = ;
%let _OUTPUT1_col1_format = ;
%let _OUTPUT1_col1_informat = ;
%let _OUTPUT1_col1_label = %nrquote(CLASS_NBR);
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input_count = 0;
%let _OUTPUT1_col2_name = SESSION_CODE;
%let _OUTPUT1_col2_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT1_col2_length = 3;
%let _OUTPUT1_col2_type = $;
%let _OUTPUT1_col2_format = $3.;
%let _OUTPUT1_col2_informat = $3.;
%let _OUTPUT1_col2_label = %nrquote(SESSION_CODE);
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input_count = 0;
%let _OUTPUT1_col3_name = COMBINED_SECTION_ID;
%let _OUTPUT1_col3_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT1_col3_length = 4;
%let _OUTPUT1_col3_type = $;
%let _OUTPUT1_col3_format = $4.;
%let _OUTPUT1_col3_informat = $4.;
%let _OUTPUT1_col3_label = %nrquote(COMBINED_SECTION_ID);
%let _OUTPUT1_col3_exp = ;
%let _OUTPUT1_col3_input_count = 0;
%let _OUTPUT1_col4_name = COMBINED_SECTION_CODE;
%let _OUTPUT1_col4_table = work.CBM00S_COMBINED_ID;
%let _OUTPUT1_col4_length = 8;
%let _OUTPUT1_col4_type = $;
%let _OUTPUT1_col4_format = ;
%let _OUTPUT1_col4_informat = ;
%let _OUTPUT1_col4_label = %nrquote(COMBINED_SECTION_CODE);
%let _OUTPUT1_col4_exp = ;
%let _OUTPUT1_col4_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/ 

data WORK.CBM00S_COMBINED_ID;
	set WORK.CBM00S_COMBINED_SECTION;
	by Current_Term STRM SESSION_CODE COMBINED_SECTION_ID;
	drop ALPHA A B group_num;
	retain group_num;
	LENGTH COMBINED_SECTION_CODE $ 2;
	if first.Current_Term then group_num = -1;
	if first.COMBINED_SECTION_ID then group_num = group_num + 1;
	ALPHA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
	A = INT(group_num/36+1);
	B = MOD(group_num,36)+1;
	COMBINED_SECTION_CODE = SUBSTR(ALPHA,A,1)||SUBSTR(ALPHA,B,1);
run;
/*---- End of User Written Code  ----*/ 

%rcSet(&syserr); 
%rcSet(&sqlrc); 
%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end User Written **/

/*==========================================================================* 
 * Step:            Adding Combined Section Code          A5B29B8Q.BZ000A18 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_CBReported -                   A5B29B8Q.BS0003C2 * 
 *                   work.CBM00S_CBReported                                 * 
 *                  CBM00S_COMBINED_ID -                  A5B29B8Q.BS0003C4 * 
 *                   work.CBM00S_COMBINED_ID                                * 
 * Target Table:    CBM00S_COMBINED_SECTION_CODE -        A5B29B8Q.BS0003C5 * 
 *                   work.CBM00S_COMBINED_SECTION_CODE                      * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A18);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_CBReported, DATA)) or 
         %sysfunc(exist(work.CBM00S_CBReported, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_CBReported out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_COMBINED_SECTION_CODE;
quit;

proc sql;
   create view work.CBM00S_COMBINED_SECTION_CODE as
   select
      CBM00S_CBReported.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_CBReported.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_CBReported.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_CBReported.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_CBReported.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_CBReported.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_CBReported.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_CBReported.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_CBReported.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_CBReported.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_CBReported.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_CBReported.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_CBReported.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_CBReported.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_CBReported.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_CBReported.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_CBReported.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_CBReported.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_CBReported.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_CBReported.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_CBReported.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_CBReported.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_CBReported.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_CBReported.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_CBReported.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_CBReported.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_CBReported.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_CBReported.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_CBReported.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_CBReported.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_CBReported.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_CBReported.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_CBReported.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_CBReported.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_CBReported.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_CBReported.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_CBReported.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_CBReported.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_CBReported.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_CBReported.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_CBReported.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_CBReported.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_CBReported.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_CBReported.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_CBReported.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_CBReported.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_CBReported.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_CBReported.NCBO length = 8   
         label = 'NCBO',
      CBM00S_CBReported.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_COMBINED_ID.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_CBReported.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_CBReported.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_CBReported.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_CBReported.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_CBReported.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_CBReported.Core_Course length = 8   
         label = 'Core_Course',
      CBM00S_CBReported.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_CBReported.Test length = 8   
         label = 'Test',
      CBM00S_CBReported.MathCore length = 8   
         label = 'MathCore',
      CBM00S_CBReported.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_CBReported.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_CBReported.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_CBReported.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_CBReported as CBM00S_CBReported left join 
      work.CBM00S_COMBINED_ID as CBM00S_COMBINED_ID
         on
         (
            CBM00S_CBReported.STRM = CBM00S_COMBINED_ID.STRM
            and CBM00S_CBReported.SESSION_CODE = CBM00S_COMBINED_ID.SESSION_CODE
            and CBM00S_CBReported.CLASS_NBR = CBM00S_COMBINED_ID.CLASS_NBR
            and CBM00S_CBReported.COMBINED_SECTION_ID = CBM00S_COMBINED_ID.COMBINED_SECTION_ID
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Adding Combined Section Code **/

/*==========================================================================* 
 * Step:            Total SCH grouping                    A5B29B8Q.BZ000A19 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM00S_COMBINED_SECTION_CODE -        A5B29B8Q.BS0003C5 * 
 *                   work.CBM00S_COMBINED_SECTION_CODE                      * 
 * Target Table:    CBM00S_CHECKTOTALSCH -                A5B29B8Q.BS0003C6 * 
 *                   work.CBM00S_CHECKTOTALSCH                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A19);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = -1;
%let SYSLAST = %nrquote(work.CBM00S_COMBINED_SECTION_CODE); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_CHECKTOTALSCH;
quit;

proc sql;
   create view work.CBM00S_CHECKTOTALSCH as
   select
      CBM00S_COMBINED_SECTION_CODE.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_COMBINED_SECTION_CODE.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_COMBINED_SECTION_CODE.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      SUM(CBM00S_COMBINED_SECTION_CODE.UNT_TAKEN ) as UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM'
   from
      work.CBM00S_COMBINED_SECTION_CODE as CBM00S_COMBINED_SECTION_CODE
   group by
      EMPLID,
      STRM,
      ACAD_PROG
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Total SCH grouping **/

/*==========================================================================* 
 * Step:            Identify Zero SCH Students            A5B29B8Q.BZ000A1A * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_CHECKTOTALSCH -                A5B29B8Q.BS0003C6 * 
 *                   work.CBM00S_CHECKTOTALSCH                              * 
 *                  CBM00S_COMBINED_SECTION_CODE -        A5B29B8Q.BS0003C5 * 
 *                   work.CBM00S_COMBINED_SECTION_CODE                      * 
 * Target Table:    CBM00S_ZeroSCH - work.CBM00S_ZeroSCH  A5B29B8Q.BS0003C7 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1A);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = -1;
/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_ZeroSCH;
quit;

proc sql;
   create table work.CBM00S_ZeroSCH as
   select distinct
      CBM00S_COMBINED_SECTION_CODE.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_COMBINED_SECTION_CODE.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_COMBINED_SECTION_CODE.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_COMBINED_SECTION_CODE.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_COMBINED_SECTION_CODE.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_COMBINED_SECTION_CODE.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_COMBINED_SECTION_CODE.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_COMBINED_SECTION_CODE.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_COMBINED_SECTION_CODE.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_COMBINED_SECTION_CODE.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_COMBINED_SECTION_CODE.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_COMBINED_SECTION_CODE.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_COMBINED_SECTION_CODE.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_COMBINED_SECTION_CODE.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_COMBINED_SECTION_CODE.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_COMBINED_SECTION_CODE.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_COMBINED_SECTION_CODE.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_COMBINED_SECTION_CODE.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_COMBINED_SECTION_CODE.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_COMBINED_SECTION_CODE.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_COMBINED_SECTION_CODE.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_COMBINED_SECTION_CODE.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_COMBINED_SECTION_CODE.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_COMBINED_SECTION_CODE.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_COMBINED_SECTION_CODE.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_COMBINED_SECTION_CODE.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_COMBINED_SECTION_CODE.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_COMBINED_SECTION_CODE.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_COMBINED_SECTION_CODE.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_COMBINED_SECTION_CODE.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_COMBINED_SECTION_CODE.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_COMBINED_SECTION_CODE.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_COMBINED_SECTION_CODE.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_COMBINED_SECTION_CODE.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_COMBINED_SECTION_CODE.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_COMBINED_SECTION_CODE.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_COMBINED_SECTION_CODE.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_CHECKTOTALSCH.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_COMBINED_SECTION_CODE.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_COMBINED_SECTION_CODE.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_COMBINED_SECTION_CODE.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_COMBINED_SECTION_CODE.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_COMBINED_SECTION_CODE.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_COMBINED_SECTION_CODE.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_COMBINED_SECTION_CODE.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_COMBINED_SECTION_CODE.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_COMBINED_SECTION_CODE.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_COMBINED_SECTION_CODE.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_COMBINED_SECTION_CODE.NCBO length = 8   
         label = 'NCBO',
      CBM00S_COMBINED_SECTION_CODE.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_COMBINED_SECTION_CODE.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_COMBINED_SECTION_CODE.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_COMBINED_SECTION_CODE.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_COMBINED_SECTION_CODE.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_COMBINED_SECTION_CODE.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_COMBINED_SECTION_CODE.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_COMBINED_SECTION_CODE.Core_Course length = 8   
         label = 'Core_Course',
      CBM00S_COMBINED_SECTION_CODE.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_COMBINED_SECTION_CODE.MathCore length = 8   
         label = 'MathCore',
      CBM00S_COMBINED_SECTION_CODE.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_COMBINED_SECTION_CODE.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_COMBINED_SECTION_CODE.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_COMBINED_SECTION_CODE.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_COMBINED_SECTION_CODE as CBM00S_COMBINED_SECTION_CODE left join 
      work.CBM00S_CHECKTOTALSCH as CBM00S_CHECKTOTALSCH
         on
         (
            CBM00S_COMBINED_SECTION_CODE.STRM = CBM00S_CHECKTOTALSCH.STRM
            and CBM00S_COMBINED_SECTION_CODE.EMPLID = CBM00S_CHECKTOTALSCH.EMPLID
            and CBM00S_COMBINED_SECTION_CODE.ACAD_PROG = CBM00S_CHECKTOTALSCH.ACAD_PROG
            and CBM00S_CHECKTOTALSCH.UNT_TAKEN_SEM >= 1
         )
   where
      CBM00S_CHECKTOTALSCH.UNT_TAKEN_SEM >= 1
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Identify Zero SCH Students **/

/*==========================================================================* 
 * Step:            Acad Plan Info                        A5B29B8Q.BZ000A1B * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_ZeroSCH - work.CBM00S_ZeroSCH  A5B29B8Q.BS0003C7 * 
 *                  PS_ACAD_PLAN_Extract -                A5B29B8Q.BE00000G * 
 *                   ADWSTGPR.PS_ACAD_PLAN_Extract                          * 
 *                  PS_ACAD_PLAN_OWNER_Extract -          A5B29B8Q.BE00000I * 
 *                   ADWSTGPR.PS_ACAD_PLAN_OWNER_Extract                    * 
 *                  ADW_DEPT_DIM - ADWTGTPR.ADW_DEPT_DIM  A5B29B8Q.BE000011 * 
 * Target Table:    CBM00S_max_acad_plan -                A5B29B8Q.BS0003C8 * 
 *                   work.CBM00S_max_acad_plan                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1B);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_ZeroSCH, DATA)) or 
         %sysfunc(exist(work.CBM00S_ZeroSCH, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_ZeroSCH out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_max_acad_plan;
quit;

proc sql;
   create table work.CBM00S_max_acad_plan as
   select distinct
      CBM00S_ZeroSCH.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_ZeroSCH.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_ZeroSCH.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_ZeroSCH.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_ZeroSCH.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_ZeroSCH.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_ZeroSCH.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_ZeroSCH.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_ZeroSCH.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_ZeroSCH.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_ZeroSCH.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_ZeroSCH.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_ZeroSCH.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_ZeroSCH.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_ZeroSCH.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_ZeroSCH.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_ZeroSCH.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_ZeroSCH.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_ZeroSCH.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_ZeroSCH.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_ZeroSCH.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_ZeroSCH.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_ZeroSCH.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_ZeroSCH.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_ZeroSCH.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_ZeroSCH.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_ZeroSCH.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_ZeroSCH.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_ZeroSCH.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_ZeroSCH.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_ZeroSCH.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_ZeroSCH.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_ZeroSCH.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_ZeroSCH.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_ZeroSCH.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_ZeroSCH.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_ZeroSCH.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_ZeroSCH.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_ZeroSCH.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_ZeroSCH.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_ZeroSCH.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_ZeroSCH.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_ZeroSCH.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_ZeroSCH.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_ZeroSCH.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      ACAD_PLAN_MIN_PLANSEQ.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      ACAD_PLAN_MIN_PLANSEQ.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      ACAD_PLAN_MIN_PLANSEQ.EFFSEQ length = 8   
         label = 'EFFSEQ',
      ACAD_PLAN_MIN_PLANSEQ.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      ACAD_PLAN_MIN_PLANSEQ.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_ZeroSCH.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_ZeroSCH.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_ZeroSCH.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_ZeroSCH.NCBO length = 8   
         label = 'NCBO',
      CBM00S_ZeroSCH.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_ZeroSCH.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_ZeroSCH.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_ZeroSCH.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_ZeroSCH.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_ZeroSCH.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_ZeroSCH.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_ZeroSCH.Core_Course length = 8   
         label = 'Core_Course',
      CBM00S_ZeroSCH.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_ZeroSCH.MathCore length = 8   
         label = 'MathCore',
      CBM00S_ZeroSCH.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_ZeroSCH.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_ZeroSCH.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_ZeroSCH.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_ZeroSCH as CBM00S_ZeroSCH left join 
      (
         select *
         from
            (
               select distinct
                  PS_ACAD_PLAN_Extract.EMPLID length = 11   
                     format = $11.
                     informat = $11.
                     label = 'EMPLID',
                  PS_ACAD_PLAN_Extract.ACAD_CAREER length = 4   
                     format = $4.
                     informat = $4.
                     label = 'ACAD_CAREER',
                  PS_ACAD_PLAN_Extract.STDNT_CAR_NBR length = 8   
                     label = 'STDNT_CAR_NBR',
                  PS_ACAD_PLAN_Extract.EFFDT length = 8   
                     format = DATETIME20.
                     informat = DATETIME20.
                     label = 'EFFDT',
                  PS_ACAD_PLAN_Extract.EFFSEQ length = 8   
                     label = 'EFFSEQ',
                  PS_ACAD_PLAN_Extract.ACAD_PLAN length = 10   
                     format = $10.
                     informat = $10.
                     label = 'ACAD_PLAN',
                  PS_ACAD_PLAN_Extract.DECLARE_DT length = 8   
                     format = DATETIME20.
                     informat = DATETIME20.
                     label = 'DECLARE_DT',
                  PS_ACAD_PLAN_Extract.PLAN_SEQUENCE length = 8   
                     label = 'PLAN_SEQUENCE',
                  PS_ACAD_PLAN_Extract.REQ_TERM length = 4   
                     format = $4.
                     informat = $4.
                     label = 'REQ_TERM',
                  PS_ACAD_PLAN_Extract.COMPLETION_TERM length = 4   
                     format = $4.
                     informat = $4.
                     label = 'COMPLETION_TERM',
                  PS_ACAD_PLAN_Extract.STDNT_DEGR length = 2   
                     format = $2.
                     informat = $2.
                     label = 'STDNT_DEGR',
                  PS_ACAD_PLAN_Extract.DEGR_CHKOUT_STAT length = 2   
                     format = $2.
                     informat = $2.
                     label = 'DEGR_CHKOUT_STAT',
                  PS_ACAD_PLAN_Extract.ADVIS_STATUS length = 4   
                     format = $4.
                     informat = $4.
                     label = 'ADVIS_STATUS',
                  PS_ACAD_PLAN_Extract.SSR_APT_INSTANCE length = 8   
                     label = 'SSR_APT_INSTANCE',
                  PS_ACAD_PLAN_Extract.SSR_YR_OF_PROG length = 4   
                     format = $4.
                     informat = $4.
                     label = 'SSR_YR_OF_PROG',
                  PS_ACAD_PLAN_Extract.SCC_ROW_ADD_OPRID length = 30   
                     format = $30.
                     informat = $30.
                     label = 'SCC_ROW_ADD_OPRID',
                  PS_ACAD_PLAN_Extract.SCC_ROW_ADD_DTTM length = 8   
                     format = DATETIME27.6
                     informat = DATETIME27.6
                     label = 'SCC_ROW_ADD_DTTM',
                  PS_ACAD_PLAN_Extract.SCC_ROW_UPD_OPRID length = 30   
                     format = $30.
                     informat = $30.
                     label = 'SCC_ROW_UPD_OPRID',
                  PS_ACAD_PLAN_Extract.SCC_ROW_UPD_DTTM length = 8   
                     format = DATETIME27.6
                     informat = DATETIME27.6
                     label = 'SCC_ROW_UPD_DTTM'
               from
                  ADWSTGPR.PS_ACAD_PLAN_Extract inner join 
                  ADWSTGPR.PS_ACAD_PLAN_OWNER_Extract as PS_ACAD_PLAN_OWNER_Extract
                     on
                     (
                        PS_ACAD_PLAN_Extract.ACAD_PLAN = PS_ACAD_PLAN_OWNER_Extract.ACAD_PLAN
                        and PS_ACAD_PLAN_Extract.EFFDT >= PS_ACAD_PLAN_OWNER_Extract.EFFDT
                     ) inner join 
                  ADWTGTPR.ADW_DEPT_DIM as ADW_DEPT_DIM
                     on
                     (
                        ADW_DEPT_DIM.CURRENT_ROW_ID = 1
                        and PS_ACAD_PLAN_OWNER_Extract.ACAD_ORG = ADW_DEPT_DIM.DEPT
                     )
               group by
                  PS_ACAD_PLAN_Extract.EMPLID,
                  PS_ACAD_PLAN_Extract.ACAD_CAREER,
                  PS_ACAD_PLAN_Extract.STDNT_CAR_NBR,
                  PS_ACAD_PLAN_Extract.EFFDT
               having
                  PS_ACAD_PLAN_Extract.EFFSEQ = MAX(PS_ACAD_PLAN_Extract.EFFSEQ)
            ) as ACAD_PLAN_MAX_EFFSEQ
         group by
            ACAD_PLAN_MAX_EFFSEQ.EMPLID,
            ACAD_PLAN_MAX_EFFSEQ.ACAD_CAREER,
            ACAD_PLAN_MAX_EFFSEQ.STDNT_CAR_NBR,
            ACAD_PLAN_MAX_EFFSEQ.EFFDT
         having
            ACAD_PLAN_MAX_EFFSEQ.PLAN_SEQUENCE = MIN(ACAD_PLAN_MAX_EFFSEQ.PLAN_SEQUENCE)
      ) as ACAD_PLAN_MIN_PLANSEQ
         on
         (
            CBM00S_ZeroSCH.EMPLID = ACAD_PLAN_MIN_PLANSEQ.EMPLID
            and CBM00S_ZeroSCH.ACAD_CAREER = ACAD_PLAN_MIN_PLANSEQ.ACAD_CAREER
            and CBM00S_ZeroSCH.Current_Term_End_date >= ACAD_PLAN_MIN_PLANSEQ.EFFDT
         )
   group by
      CBM00S_ZeroSCH.STRM,
      CBM00S_ZeroSCH.EMPLID,
      CBM00S_ZeroSCH.ACAD_CAREER,
      ACAD_PLAN_MIN_PLANSEQ.STDNT_CAR_NBR
   having
      ACAD_PLAN_MIN_PLANSEQ.EFFDT = MAX(ACAD_PLAN_MIN_PLANSEQ.EFFDT)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Acad Plan Info **/

/*==========================================================================* 
 * Step:            AcadPlan_tbl                          A5B29B8Q.BZ000A1C * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_max_acad_plan -                A5B29B8Q.BS0003C8 * 
 *                   work.CBM00S_max_acad_plan                              * 
 *                  PS_ACAD_PLAN_TBL_Extract -            A5B29B8Q.BE00000H * 
 *                   ADWSTGPR.PS_ACAD_PLAN_TBL_Extract                      * 
 * Target Table:    CBM00S_acad_plan -                    A5B29B8Q.BS0003C9 * 
 *                   work.CBM00S_acad_plan                                  * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1C);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_max_acad_plan, DATA)) or 
         %sysfunc(exist(work.CBM00S_max_acad_plan, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_max_acad_plan out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_acad_plan;
quit;

proc sql;
   create table work.CBM00S_acad_plan as
   select
      CBM00S_max_acad_plan.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_max_acad_plan.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_max_acad_plan.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_max_acad_plan.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_max_acad_plan.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_max_acad_plan.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_max_acad_plan.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_max_acad_plan.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_max_acad_plan.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_max_acad_plan.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_max_acad_plan.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_max_acad_plan.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_max_acad_plan.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_max_acad_plan.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_max_acad_plan.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_max_acad_plan.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_max_acad_plan.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_max_acad_plan.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_max_acad_plan.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_max_acad_plan.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_max_acad_plan.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_max_acad_plan.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_max_acad_plan.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_max_acad_plan.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_max_acad_plan.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_max_acad_plan.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_max_acad_plan.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_max_acad_plan.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_max_acad_plan.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_max_acad_plan.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_max_acad_plan.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_max_acad_plan.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_max_acad_plan.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_max_acad_plan.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_max_acad_plan.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_max_acad_plan.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_max_acad_plan.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_max_acad_plan.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_max_acad_plan.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_max_acad_plan.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_max_acad_plan.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_max_acad_plan.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_max_acad_plan.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_max_acad_plan.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_max_acad_plan.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_max_acad_plan.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_max_acad_plan.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_max_acad_plan.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_max_acad_plan.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_max_acad_plan.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      PS_ACAD_PLAN_TBL_Extract.EFFDT as PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      PS_ACAD_PLAN_TBL_Extract.ACAD_PROG as PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      PS_ACAD_PLAN_TBL_Extract.ACAD_PLAN_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_PLAN_TYPE',
      CBM00S_max_acad_plan.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_max_acad_plan.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_max_acad_plan.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_max_acad_plan.NCBO length = 8   
         label = 'NCBO',
      CBM00S_max_acad_plan.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_max_acad_plan.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_max_acad_plan.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_max_acad_plan.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_max_acad_plan.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_max_acad_plan.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_max_acad_plan.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_max_acad_plan.Core_Course length = 8   
         label = 'Core_Course',
      CBM00S_max_acad_plan.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_max_acad_plan.MathCore length = 8   
         label = 'MathCore',
      CBM00S_max_acad_plan.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_max_acad_plan.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_max_acad_plan.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_max_acad_plan.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_max_acad_plan as CBM00S_max_acad_plan inner join 
      ADWSTGPR.PS_ACAD_PLAN_TBL_Extract
         on
         (
            CBM00S_max_acad_plan.ACAD_PLAN = PS_ACAD_PLAN_TBL_Extract.ACAD_PLAN
            and CBM00S_max_acad_plan.Current_Term_End_date >= PS_ACAD_PLAN_TBL_Extract.EFFDT
         )
   group by
      CBM00S_max_acad_plan.ACAD_PLAN,
      CBM00S_max_acad_plan.TERM_END_DT
   having
      PS_ACAD_PLAN_TBL_Extract.EFFDT = MAX(PS_ACAD_PLAN_TBL_Extract.EFFDT)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end AcadPlan_tbl **/

/*==========================================================================* 
 * Step:            Max Acad Prog                         A5B29B8Q.BZ000A1D * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J * 
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          * 
 * Target Table:    Join - work.MaxAcadProg               A5B29B8Q.BS0003CA * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1D);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_ACAD_PROG_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_ACAD_PROG_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_ACAD_PROG_Extract;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(ADWSTGPR.PS_ACAD_PROG_Extract); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete MaxAcadProg;
quit;

proc sql;
   create view work.MaxAcadProg as
   select
      Max_Effdt_PlanSeq.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      Max_Effdt_PlanSeq.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      Max_Effdt_PlanSeq.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      Max_Effdt_PlanSeq.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      Max_Effdt_PlanSeq.EFFSEQ length = 8   
         label = 'EFFSEQ',
      Max_Effdt_PlanSeq.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      Max_Effdt_PlanSeq.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      Max_Effdt_PlanSeq.PROG_STATUS length = 4   
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      Max_Effdt_PlanSeq.PROG_ACTION length = 4   
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      Max_Effdt_PlanSeq.ACTION_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      Max_Effdt_PlanSeq.PROG_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      Max_Effdt_PlanSeq.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      Max_Effdt_PlanSeq.EXP_GRAD_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      Max_Effdt_PlanSeq.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      Max_Effdt_PlanSeq.ACAD_LOAD_APPR length = 1   
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      Max_Effdt_PlanSeq.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      Max_Effdt_PlanSeq.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      Max_Effdt_PlanSeq.COMPLETION_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'COMPLETION_TERM',
      Max_Effdt_PlanSeq.ACAD_PROG_DUAL length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      Max_Effdt_PlanSeq.JOINT_PROG_APPR length = 1   
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      Max_Effdt_PlanSeq.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      Max_Effdt_PlanSeq.APPL_PROG_NBR length = 8   
         label = 'APPL_PROG_NBR',
      Max_Effdt_PlanSeq.DATA_FROM_ADM_APPL length = 1   
         format = $1.
         informat = $1.
         label = 'DATA_FROM_ADM_APPL',
      Max_Effdt_PlanSeq.SSR_RS_CANDIT_NBR length = 12   
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      Max_Effdt_PlanSeq.SSR_APT_INSTANCE length = 8   
         label = 'SSR_APT_INSTANCE',
      Max_Effdt_PlanSeq.SSR_YR_OF_PROG length = 4   
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      Max_Effdt_PlanSeq.SSR_SHIFT length = 12   
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      Max_Effdt_PlanSeq.SSR_COHORT_ID length = 12   
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      Max_Effdt_PlanSeq.SCC_ROW_ADD_OPRID length = 30   
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      Max_Effdt_PlanSeq.SCC_ROW_ADD_DTTM length = 8   
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      Max_Effdt_PlanSeq.SCC_ROW_UPD_OPRID length = 30   
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      Max_Effdt_PlanSeq.SCC_ROW_UPD_DTTM length = 8   
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      Max_Effdt_PlanSeq.READ_DTM length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      Max_Effdt_PlanSeq.STAGE_UPDATE_ID length = 20   
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      (
         select *
         from
            ADWSTGPR.PS_ACAD_PROG_Extract
         group by
            PS_ACAD_PROG_Extract.EMPLID,
            PS_ACAD_PROG_Extract.ACAD_CAREER,
            PS_ACAD_PROG_Extract.STDNT_CAR_NBR,
            PS_ACAD_PROG_Extract.EFFDT
         having
            PS_ACAD_PROG_Extract.EFFSEQ = max(PS_ACAD_PROG_Extract.EFFSEQ)
      ) as Max_Effdt_PlanSeq
   group by
      Max_Effdt_PlanSeq.EMPLID,
      Max_Effdt_PlanSeq.ACAD_CAREER,
      Max_Effdt_PlanSeq.STDNT_CAR_NBR
   having
      Max_Effdt_PlanSeq.EFFDT = max(Max_Effdt_PlanSeq.EFFDT)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Max Acad Prog **/

/*==========================================================================* 
 * Step:            Plan Owner, Carterm                   A5B29B8Q.BZ000A1E * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_acad_plan -                    A5B29B8Q.BS0003C9 * 
 *                   work.CBM00S_acad_plan                                  * 
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K * 
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     * 
 *                  Join - work.MaxAcadProg               A5B29B8Q.BS0003CA * 
 * Target Table:    CBM00S_ACAD_PLAN_INFO -               A5B29B8Q.BS0003CB * 
 *                   work.CBM00S_ACAD_PLAN_INFO                             * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1E);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_acad_plan, DATA)) or 
         %sysfunc(exist(work.CBM00S_acad_plan, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_acad_plan out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_ACAD_PLAN_INFO;
quit;

data _null_;
   put "NOTE: The following column(s) do not have a column mapping, so the"
        " value(s) will be set to missing: ACAD_ORG";
run;

proc sql;
   create table work.CBM00S_ACAD_PLAN_INFO as
   select
      CBM00S_acad_plan.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_acad_plan.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_acad_plan.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_acad_plan.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_acad_plan.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_acad_plan.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_acad_plan.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_acad_plan.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_acad_plan.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_acad_plan.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_acad_plan.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_acad_plan.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_acad_plan.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_acad_plan.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_acad_plan.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_acad_plan.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_acad_plan.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_acad_plan.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_acad_plan.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_acad_plan.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_acad_plan.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_acad_plan.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_acad_plan.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_acad_plan.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_acad_plan.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_acad_plan.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_acad_plan.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_acad_plan.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_acad_plan.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_acad_plan.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_acad_plan.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_acad_plan.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_acad_plan.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_acad_plan.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_acad_plan.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_acad_plan.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_acad_plan.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_acad_plan.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_acad_plan.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_acad_plan.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      "" as ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_acad_plan.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_acad_plan.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_acad_plan.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_acad_plan.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_acad_plan.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_acad_plan.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_acad_plan.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_acad_plan.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_acad_plan.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_acad_plan.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_acad_plan.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_acad_plan.ACAD_PLAN_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_PLAN_TYPE',
      MaxAcadProg.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      MaxAcadProg.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      PS_STDNT_CAR_TERM_Extract.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      PS_STDNT_CAR_TERM_Extract.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_acad_plan.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      IFC(COUNT(distinct CBM00S_acad_plan.CLASS_NBR)>1,'Y','N') as ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_acad_plan.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_acad_plan.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_acad_plan.NCBO length = 8   
         label = 'NCBO',
      CBM00S_acad_plan.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_acad_plan.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_acad_plan.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_acad_plan.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_acad_plan.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_acad_plan.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_acad_plan.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_acad_plan.Core_Course length = 8   
         label = 'Core_Course',
      CBM00S_acad_plan.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_acad_plan.MathCore length = 8   
         label = 'MathCore',
      CBM00S_acad_plan.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_acad_plan.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_acad_plan.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_acad_plan.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_acad_plan as CBM00S_acad_plan inner join 
      work.MaxAcadProg as MaxAcadProg
         on
         (
            CBM00S_acad_plan.EMPLID = MaxAcadProg.EMPLID
            and CBM00S_acad_plan.ACAD_CAREER = MaxAcadProg.ACAD_CAREER
            and CBM00S_acad_plan.STDNT_CAR_NBR = MaxAcadProg.STDNT_CAR_NBR
         ) inner join 
      ADWSTGPR.PS_STDNT_CAR_TERM_Extract as PS_STDNT_CAR_TERM_Extract
         on
         (
            CBM00S_acad_plan.EMPLID = PS_STDNT_CAR_TERM_Extract.EMPLID
            and CBM00S_acad_plan.STRM = PS_STDNT_CAR_TERM_Extract.STRM
            and CBM00S_acad_plan.ACAD_CAREER = PS_STDNT_CAR_TERM_Extract.ACAD_CAREER
            and CBM00S_acad_plan.STDNT_CAR_NBR = PS_STDNT_CAR_TERM_Extract.STDNT_CAR_NBR
         )
   where
      PS_STDNT_CAR_TERM_Extract.ACAD_PROG_PRIMARY NOT IS MISSING 
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Plan Owner, Carterm **/

/*==========================================================================* 
 * Step:            Student class level for Flex          A5B29B8Q.BZ000A1F * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_ACAD_PLAN_INFO -               A5B29B8Q.BS0003CB * 
 *                   work.CBM00S_ACAD_PLAN_INFO                             * 
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K * 
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     * 
 * Target Table:    CBMS_FLEX_STUDENT_LEVEL -             A5B29B8Q.BS0003CC * 
 *                   work.CBMS_FLEX_STUDENT_LEVEL                           * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1F);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_ACAD_PLAN_INFO, DATA)) or 
         %sysfunc(exist(work.CBM00S_ACAD_PLAN_INFO, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_ACAD_PLAN_INFO out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBMS_FLEX_STUDENT_LEVEL;
quit;

proc sql;
   create view work.CBMS_FLEX_STUDENT_LEVEL as
   select
      CBM00S_ACAD_PLAN_INFO.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_ACAD_PLAN_INFO.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_ACAD_PLAN_INFO.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_ACAD_PLAN_INFO.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_ACAD_PLAN_INFO.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_ACAD_PLAN_INFO.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_ACAD_PLAN_INFO.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_ACAD_PLAN_INFO.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_ACAD_PLAN_INFO.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_ACAD_PLAN_INFO.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_ACAD_PLAN_INFO.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_ACAD_PLAN_INFO.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_ACAD_PLAN_INFO.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_ACAD_PLAN_INFO.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_ACAD_PLAN_INFO.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_ACAD_PLAN_INFO.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_ACAD_PLAN_INFO.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_ACAD_PLAN_INFO.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_ACAD_PLAN_INFO.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_ACAD_PLAN_INFO.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_ACAD_PLAN_INFO.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_ACAD_PLAN_INFO.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_ACAD_PLAN_INFO.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_ACAD_PLAN_INFO.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_ACAD_PLAN_INFO.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_ACAD_PLAN_INFO.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_ACAD_PLAN_INFO.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_ACAD_PLAN_INFO.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_ACAD_PLAN_INFO.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_ACAD_PLAN_INFO.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_ACAD_PLAN_INFO.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_ACAD_PLAN_INFO.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_ACAD_PLAN_INFO.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_ACAD_PLAN_INFO.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_ACAD_PLAN_INFO.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_ACAD_PLAN_INFO.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_ACAD_PLAN_INFO.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_ACAD_PLAN_INFO.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_ACAD_PLAN_INFO.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_ACAD_PLAN_INFO.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_ACAD_PLAN_INFO.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_ACAD_PLAN_INFO.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_ACAD_PLAN_INFO.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_ACAD_PLAN_INFO.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_ACAD_PLAN_INFO.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_ACAD_PLAN_INFO.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_ACAD_PLAN_INFO.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_ACAD_PLAN_INFO.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_ACAD_PLAN_INFO.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_ACAD_PLAN_INFO.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_ACAD_PLAN_INFO.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_ACAD_PLAN_INFO.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_ACAD_PLAN_INFO.ACAD_PLAN_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_PLAN_TYPE',
      CBM00S_ACAD_PLAN_INFO.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_ACAD_PLAN_INFO.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      case  
       when PS_STDNT_CAR_TERM_Extract.EMPLID is not missing then PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_BOT  
      else CBM00S_ACAD_PLAN_INFO.ACAD_LEVEL_BOT  
      end as ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      case  
       when PS_STDNT_CAR_TERM_Extract.EMPLID is not missing then PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_EOT  
      else CBM00S_ACAD_PLAN_INFO.ACAD_LEVEL_EOT  
      end as ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_ACAD_PLAN_INFO.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_ACAD_PLAN_INFO.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_ACAD_PLAN_INFO.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_ACAD_PLAN_INFO.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_ACAD_PLAN_INFO.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_ACAD_PLAN_INFO.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_ACAD_PLAN_INFO.NCBO length = 8   
         label = 'NCBO',
      CBM00S_ACAD_PLAN_INFO.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_ACAD_PLAN_INFO.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_ACAD_PLAN_INFO.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_ACAD_PLAN_INFO.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_ACAD_PLAN_INFO.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_ACAD_PLAN_INFO.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_ACAD_PLAN_INFO.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_ACAD_PLAN_INFO.Core_Course length = 8   
         label = 'Core_Course',
      CBM00S_ACAD_PLAN_INFO.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_ACAD_PLAN_INFO.MathCore length = 8   
         label = 'MathCore',
      CBM00S_ACAD_PLAN_INFO.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_ACAD_PLAN_INFO.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_ACAD_PLAN_INFO.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_ACAD_PLAN_INFO.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_ACAD_PLAN_INFO as CBM00S_ACAD_PLAN_INFO left join 
      ADWSTGPR.PS_STDNT_CAR_TERM_Extract as PS_STDNT_CAR_TERM_Extract
         on
         (
            CBM00S_ACAD_PLAN_INFO.STRM <> CBM00S_ACAD_PLAN_INFO.Current_Term
            and CBM00S_ACAD_PLAN_INFO.EMPLID = PS_STDNT_CAR_TERM_Extract.EMPLID
            and CBM00S_ACAD_PLAN_INFO.Current_Term = PS_STDNT_CAR_TERM_Extract.STRM
            and CBM00S_ACAD_PLAN_INFO.ACAD_CAREER = PS_STDNT_CAR_TERM_Extract.ACAD_CAREER
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Student class level for Flex **/

/*==========================================================================* 
 * Step:            Funded, Unfunded                      A5B29B8Q.BZ000A1G * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_UTA_UNFUNDED_Extract -             A5B29B8Q.BE00000L * 
 *                   ADWSTGPR.PS_UTA_UNFUNDED_Extract                       * 
 *                  CBMS_FLEX_STUDENT_LEVEL -             A5B29B8Q.BS0003CC * 
 *                   work.CBMS_FLEX_STUDENT_LEVEL                           * 
 *                  ADW_CBM_3PEATDEV -                    A5B29B8Q.BE00000M * 
 *                   CBMPRD.ADW_CBM_3PEATDEV                                * 
 *                  ADW_CBM_EXCESS_HOURS -                A5B29B8Q.BE00000N * 
 *                   CBMPRD.ADW_CBM_EXCESS_HOURS                            * 
 * Target Table:    CBM00S_with_funding -                 A5B29B8Q.BS0003CD * 
 *                   work.CBM00S_with_funding                               * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1G);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_UTA_UNFUNDED_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_UTA_UNFUNDED_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_UTA_UNFUNDED_Extract;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_with_funding;
quit;

proc sql;
   create table work.CBM00S_with_funding as
   select
      CBMS_FLEX_STUDENT_LEVEL.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBMS_FLEX_STUDENT_LEVEL.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBMS_FLEX_STUDENT_LEVEL.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBMS_FLEX_STUDENT_LEVEL.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBMS_FLEX_STUDENT_LEVEL.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBMS_FLEX_STUDENT_LEVEL.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBMS_FLEX_STUDENT_LEVEL.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBMS_FLEX_STUDENT_LEVEL.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBMS_FLEX_STUDENT_LEVEL.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBMS_FLEX_STUDENT_LEVEL.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBMS_FLEX_STUDENT_LEVEL.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBMS_FLEX_STUDENT_LEVEL.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBMS_FLEX_STUDENT_LEVEL.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBMS_FLEX_STUDENT_LEVEL.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBMS_FLEX_STUDENT_LEVEL.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBMS_FLEX_STUDENT_LEVEL.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBMS_FLEX_STUDENT_LEVEL.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBMS_FLEX_STUDENT_LEVEL.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBMS_FLEX_STUDENT_LEVEL.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBMS_FLEX_STUDENT_LEVEL.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBMS_FLEX_STUDENT_LEVEL.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBMS_FLEX_STUDENT_LEVEL.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBMS_FLEX_STUDENT_LEVEL.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBMS_FLEX_STUDENT_LEVEL.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBMS_FLEX_STUDENT_LEVEL.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBMS_FLEX_STUDENT_LEVEL.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBMS_FLEX_STUDENT_LEVEL.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBMS_FLEX_STUDENT_LEVEL.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBMS_FLEX_STUDENT_LEVEL.Prior_Term length = 8   
         label = 'Previous Term',
      CBMS_FLEX_STUDENT_LEVEL.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBMS_FLEX_STUDENT_LEVEL.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBMS_FLEX_STUDENT_LEVEL.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBMS_FLEX_STUDENT_LEVEL.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBMS_FLEX_STUDENT_LEVEL.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBMS_FLEX_STUDENT_LEVEL.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBMS_FLEX_STUDENT_LEVEL.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBMS_FLEX_STUDENT_LEVEL.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBMS_FLEX_STUDENT_LEVEL.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBMS_FLEX_STUDENT_LEVEL.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBMS_FLEX_STUDENT_LEVEL.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBMS_FLEX_STUDENT_LEVEL.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBMS_FLEX_STUDENT_LEVEL.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBMS_FLEX_STUDENT_LEVEL.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBMS_FLEX_STUDENT_LEVEL.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBMS_FLEX_STUDENT_LEVEL.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBMS_FLEX_STUDENT_LEVEL.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBMS_FLEX_STUDENT_LEVEL.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBMS_FLEX_STUDENT_LEVEL.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBMS_FLEX_STUDENT_LEVEL.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBMS_FLEX_STUDENT_LEVEL.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBMS_FLEX_STUDENT_LEVEL.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBMS_FLEX_STUDENT_LEVEL.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBMS_FLEX_STUDENT_LEVEL.ACAD_PLAN_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_PLAN_TYPE',
      CBMS_FLEX_STUDENT_LEVEL.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBMS_FLEX_STUDENT_LEVEL.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBMS_FLEX_STUDENT_LEVEL.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBMS_FLEX_STUDENT_LEVEL.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBMS_FLEX_STUDENT_LEVEL.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBMS_FLEX_STUDENT_LEVEL.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      PS_UTA_UNFUNDED_Extract.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      PS_UTA_UNFUNDED_Extract.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      ADW_CBM_EXCESS_HOURS.EMPLID as Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      ADW_CBM_3PEATDEV.CRSE_ID as THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE as THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      ADW_CBM_3PEATDEV.UNT_TAKEN as THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      IFC(ADW_CBM_EXCESS_HOURS.EMPLID NOT IS MISSING,'Yes','No') as EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      IFC(ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE='R' 
      and ADW_CBM_3PEATDEV.UNT_TAKEN >0 and ADW_CBM_3PEATDEV.UTA_CB_EXCL_FLAG ='N','Yes','No') as FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      IFC(ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE='D','Yes','No') as DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBMS_FLEX_STUDENT_LEVEL.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBMS_FLEX_STUDENT_LEVEL.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      IFC(CBMS_FLEX_STUDENT_LEVEL.ACAD_PROG IN ('UGNDS','SPEC') &  
      CBMS_FLEX_STUDENT_LEVEL.SUBJECT  IN ('EXSA','DNCE') &  
      CBMS_FLEX_STUDENT_LEVEL.REPEAT_CANDIDATE ='Y' &  
      CBMS_FLEX_STUDENT_LEVEL.ADDL_ENRL ='N','Y','N') as PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBMS_FLEX_STUDENT_LEVEL.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBMS_FLEX_STUDENT_LEVEL.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      IFC(FIND(UPCASE(CBMS_FLEX_STUDENT_LEVEL.CLASS_VAL_LIST ),'UNFN' )<>0 
      or FIND(UPCASE(CBMS_FLEX_STUDENT_LEVEL.CLASS_ATTR_LIST ),'UNFN' ),'Yes','No') as Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBMS_FLEX_STUDENT_LEVEL.Core_Course length = 8   
         label = 'CORE_COURSE',
      CBMS_FLEX_STUDENT_LEVEL.NCBO length = 8   
         label = 'NCBO',
      CBMS_FLEX_STUDENT_LEVEL.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBMS_FLEX_STUDENT_LEVEL.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBMS_FLEX_STUDENT_LEVEL.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBMS_FLEX_STUDENT_LEVEL.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBMS_FLEX_STUDENT_LEVEL.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBMS_FLEX_STUDENT_LEVEL.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBMS_FLEX_STUDENT_LEVEL.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBMS_FLEX_STUDENT_LEVEL.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBMS_FLEX_STUDENT_LEVEL.MathCore length = 8   
         label = 'MathCore',
      CBMS_FLEX_STUDENT_LEVEL.ReadCore length = 8   
         label = 'ReadCore',
      CBMS_FLEX_STUDENT_LEVEL.WriteCore length = 8   
         label = 'WriteCore',
      CBMS_FLEX_STUDENT_LEVEL.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBMS_FLEX_STUDENT_LEVEL.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBMS_FLEX_STUDENT_LEVEL as CBMS_FLEX_STUDENT_LEVEL left join 
      ADWSTGPR.PS_UTA_UNFUNDED_Extract
         on
         (
            CBMS_FLEX_STUDENT_LEVEL.STRM <= '2088'
            and CBMS_FLEX_STUDENT_LEVEL.STRM = PS_UTA_UNFUNDED_Extract.STRM
            and CBMS_FLEX_STUDENT_LEVEL.EMPLID = PS_UTA_UNFUNDED_Extract.EMPLID
            and CBMS_FLEX_STUDENT_LEVEL.ACAD_CAREER = PS_UTA_UNFUNDED_Extract.ACAD_CAREER
            and CBMS_FLEX_STUDENT_LEVEL.ACAD_PROG = PS_UTA_UNFUNDED_Extract.ACAD_PROG
            and CBMS_FLEX_STUDENT_LEVEL.INSTITUTION = PS_UTA_UNFUNDED_Extract.INSTITUTION
            and PS_UTA_UNFUNDED_Extract.UTA_UNFN_TYPE = 'X'
            and CBMS_FLEX_STUDENT_LEVEL.CRSE_ID = PS_UTA_UNFUNDED_Extract.CRSE_ID
            and PS_UTA_UNFUNDED_Extract.UTA_UNFN_TYPE = 'D'
            and PS_UTA_UNFUNDED_Extract.UTA_UNFN_TYPE = 'R'
            and PS_UTA_UNFUNDED_Extract.UTA_UNFN_UNITS > 0
         ) left join 
      CBMPRD.ADW_CBM_EXCESS_HOURS
         on
         (
            CBMS_FLEX_STUDENT_LEVEL.EMPLID = ADW_CBM_EXCESS_HOURS.EMPLID
            and CBMS_FLEX_STUDENT_LEVEL.Current_Term = ADW_CBM_EXCESS_HOURS.STRM
            and CBMS_FLEX_STUDENT_LEVEL.ACAD_CAREER = ADW_CBM_EXCESS_HOURS.ACAD_CAREER
         ) left join 
      CBMPRD.ADW_CBM_3PEATDEV
         on
         (
            CBMS_FLEX_STUDENT_LEVEL.Current_Term = ADW_CBM_3PEATDEV.STRM
            and CBMS_FLEX_STUDENT_LEVEL.EMPLID = ADW_CBM_3PEATDEV.EMPLID
            and CBMS_FLEX_STUDENT_LEVEL.ACAD_CAREER = ADW_CBM_3PEATDEV.ACAD_CAREER
            and CBMS_FLEX_STUDENT_LEVEL.INSTITUTION = ADW_CBM_3PEATDEV.INSTITUTION
            and CBMS_FLEX_STUDENT_LEVEL.CRSE_ID = ADW_CBM_3PEATDEV.CRSE_ID
            and ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE IN ('R','D')
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Funded, Unfunded **/

/*==========================================================================* 
 * Step:            12H Flag-Min Units Req                A5B29B8Q.BZ000A1H * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_with_funding -                 A5B29B8Q.BS0003CD * 
 *                   work.CBM00S_with_funding                               * 
 *                  PS_UTA_ACADPLAN_DTL_Extract -         A5B29B8Q.BE00000O * 
 *                   ADWSTGPR.PS_UTA_ACADPLAN_DTL_Extract                   * 
 * Target Table:    CBM00S_12H_Flag -                     A5B29B8Q.BS0003CE * 
 *                   work.CBM00S_12H_Flag                                   * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1H);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_with_funding, DATA)) or 
         %sysfunc(exist(work.CBM00S_with_funding, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_with_funding out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_12H_Flag;
quit;

proc sql;
   create table work.CBM00S_12H_Flag as
   select
      CBM00S_with_funding.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_with_funding.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_with_funding.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_with_funding.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_with_funding.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_with_funding.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_with_funding.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_with_funding.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_with_funding.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_with_funding.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_with_funding.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_with_funding.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_with_funding.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_with_funding.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_with_funding.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_with_funding.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_with_funding.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_with_funding.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_with_funding.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_with_funding.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_with_funding.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_with_funding.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_with_funding.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_with_funding.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_with_funding.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_with_funding.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_with_funding.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_with_funding.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_with_funding.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_with_funding.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_with_funding.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_with_funding.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_with_funding.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_with_funding.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_with_funding.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_with_funding.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_with_funding.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_with_funding.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_with_funding.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_with_funding.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_with_funding.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_with_funding.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_with_funding.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_with_funding.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_with_funding.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_with_funding.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_with_funding.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_with_funding.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_with_funding.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_with_funding.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_with_funding.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_with_funding.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_with_funding.ACAD_PLAN_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_PLAN_TYPE',
      CBM00S_with_funding.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_with_funding.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_with_funding.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_with_funding.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_with_funding.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_with_funding.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_with_funding.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_with_funding.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_with_funding.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_with_funding.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_with_funding.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_with_funding.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_with_funding.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_with_funding.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_with_funding.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_with_funding.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_with_funding.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_with_funding.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_with_funding.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_with_funding.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_with_funding.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      PS_UTA_ACADPLAN_DTL_Extract.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_with_funding.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_with_funding.NCBO length = 8   
         label = 'NCBO',
      CBM00S_with_funding.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_with_funding.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_with_funding.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_with_funding.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_with_funding.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_with_funding.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_with_funding.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_with_funding.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_with_funding.MathCore length = 8   
         label = 'MathCore',
      CBM00S_with_funding.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_with_funding.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_with_funding.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_with_funding.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_with_funding as CBM00S_with_funding left join 
      ADWSTGPR.PS_UTA_ACADPLAN_DTL_Extract as PS_UTA_ACADPLAN_DTL_Extract
         on
         (
            CBM00S_with_funding.ACAD_PLAN = PS_UTA_ACADPLAN_DTL_Extract.ACAD_PLAN
            and CBM00S_with_funding.ACAD_CAREER = PS_UTA_ACADPLAN_DTL_Extract.ACAD_CAREER
            and CBM00S_with_funding.TERM_BEGIN_DT >= PS_UTA_ACADPLAN_DTL_Extract.EFFDT
            and CBM00S_with_funding.INSTITUTION = PS_UTA_ACADPLAN_DTL_Extract.INSTITUTION
         )
   group by
      CBM00S_with_funding.INSTITUTION,
      CBM00S_with_funding.ACAD_CAREER,
      CBM00S_with_funding.ACAD_PLAN,
      CBM00S_with_funding.TERM_BEGIN_DT
   having
      MAX(PS_UTA_ACADPLAN_DTL_Extract.EFFDT) IS MISSING 
      or PS_UTA_ACADPLAN_DTL_Extract.EFFDT = MAX(PS_UTA_ACADPLAN_DTL_Extract.EFFDT)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end 12H Flag-Min Units Req **/

/*==========================================================================* 
 * Step:            Removing Duplicates                   A5B29B8Q.BZ000A1I * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM00S_12H_Flag -                     A5B29B8Q.BS0003CE * 
 *                   work.CBM00S_12H_Flag                                   * 
 * Target Table:    CBM00S_12H_Flag_Unduplicated -        A5B29B8Q.BS0003CF * 
 *                   work.CBM00S_12H_Flag_Unduplicated                      * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1I);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_12H_Flag, DATA)) or 
         %sysfunc(exist(work.CBM00S_12H_Flag, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_12H_Flag out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(work.CBM00S_12H_Flag); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_12H_Flag_Unduplicated;
quit;

proc sql;
   create table work.CBM00S_12H_Flag_Unduplicated as
   select distinct
      CBM00S_12H_Flag.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_12H_Flag.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_12H_Flag.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_12H_Flag.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_12H_Flag.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_12H_Flag.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_12H_Flag.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_12H_Flag.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_12H_Flag.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_12H_Flag.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_12H_Flag.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_12H_Flag.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_12H_Flag.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_12H_Flag.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_12H_Flag.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_12H_Flag.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_12H_Flag.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_12H_Flag.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_12H_Flag.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_12H_Flag.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_12H_Flag.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_12H_Flag.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_12H_Flag.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_12H_Flag.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_12H_Flag.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_12H_Flag.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_12H_Flag.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_12H_Flag.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_12H_Flag.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_12H_Flag.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_12H_Flag.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_12H_Flag.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_12H_Flag.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_12H_Flag.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_12H_Flag.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_12H_Flag.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_12H_Flag.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_12H_Flag.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_12H_Flag.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_12H_Flag.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_12H_Flag.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_12H_Flag.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_12H_Flag.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_12H_Flag.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_12H_Flag.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_12H_Flag.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_12H_Flag.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_12H_Flag.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_12H_Flag.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_12H_Flag.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_12H_Flag.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_12H_Flag.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_12H_Flag.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_12H_Flag.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_12H_Flag.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_12H_Flag.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_12H_Flag.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_12H_Flag.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_12H_Flag.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_12H_Flag.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_12H_Flag.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_12H_Flag.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_12H_Flag.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_12H_Flag.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_12H_Flag.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_12H_Flag.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_12H_Flag.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_12H_Flag.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_12H_Flag.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_12H_Flag.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_12H_Flag.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_12H_Flag.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_12H_Flag.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      IFN(MAX(CBM00S_12H_Flag.MIN_UNITS_REQD )>120, MAX(CBM00S_12H_Flag.MIN_UNITS_REQD ),IFN( CBM00S_12H_Flag.ACAD_CAREER ='UGRD', 120,.)) as MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_12H_Flag.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_12H_Flag.NCBO length = 8   
         label = 'NCBO',
      CBM00S_12H_Flag.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_12H_Flag.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_12H_Flag.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_12H_Flag.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_12H_Flag.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_12H_Flag.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_12H_Flag.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_12H_Flag.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_12H_Flag.MathCore length = 8   
         label = 'MathCore',
      CBM00S_12H_Flag.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_12H_Flag.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_12H_Flag.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_12H_Flag.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_12H_Flag as CBM00S_12H_Flag
   where
      STRIP( CBM00S_12H_Flag.ACAD_PROG_PRIMARY ) <> ''
   group by
      CBM00S_12H_Flag.EMPLID,
      CBM00S_12H_Flag.STRM,
      CBM00S_12H_Flag.CLASS_NBR
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Removing Duplicates **/

/*==========================================================================* 
 * Step:            Prior Core Course Enrollment          A5B29B8Q.BZ000A1J * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_12H_Flag_Unduplicated -        A5B29B8Q.BS0003CF * 
 *                   work.CBM00S_12H_Flag_Unduplicated                      * 
 *                  CBM00S_Course_Info -                  A5B29B8Q.BS0003BX * 
 *                   work.CBM00S_Course_Info                                * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 * Target Table:    CBM00S_Core_Crse_Enrl -               A5B29B8Q.BS0003CG * 
 *                   work.CBM00S_Core_Crse_Enrl                             * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1J);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_12H_Flag_Unduplicated, DATA)) or 
         %sysfunc(exist(work.CBM00S_12H_Flag_Unduplicated, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_12H_Flag_Unduplicated out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Core_Crse_Enrl;
quit;

proc sql;
   create table work.CBM00S_Core_Crse_Enrl as
   select distinct
      PS_STDNT_ENRL_Extract.STRM as Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_12H_Flag_Unduplicated.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_12H_Flag_Unduplicated.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_12H_Flag_Unduplicated.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_12H_Flag_Unduplicated.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID'
   from
      work.CBM00S_12H_Flag_Unduplicated as CBM00S_12H_Flag_Unduplicated, 
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract, 
      work.CBM00S_Course_Info as CBM00S_Course_Info
   where
      CBM00S_12H_Flag_Unduplicated.EMPLID = PS_STDNT_ENRL_Extract.EMPLID
      and CBM00S_12H_Flag_Unduplicated.ACAD_CAREER = PS_STDNT_ENRL_Extract.ACAD_CAREER
      and CBM00S_12H_Flag_Unduplicated.STRM > PS_STDNT_ENRL_Extract.STRM
      and PS_STDNT_ENRL_Extract.STRM = CBM00S_Course_Info.STRM
      and PS_STDNT_ENRL_Extract.SESSION_CODE = CBM00S_Course_Info.SESSION_CODE
      and PS_STDNT_ENRL_Extract.CLASS_NBR = CBM00S_Course_Info.CLASS_NBR
      and PS_STDNT_ENRL_Extract.ACAD_CAREER = 'UGRD'
      and CBM00S_Course_Info.Core_Course = 'Yes'
      and PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS = 'E'
      and PS_STDNT_ENRL_Extract.INSTITUTION = 'UTARL'
      and PS_STDNT_ENRL_Extract.UNT_TAKEN > 0
      and PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF IN ('A', 'B', 'C', 'D', 'P')
   group by
      CBM00S_12H_Flag_Unduplicated.EMPLID,
      CBM00S_12H_Flag_Unduplicated.ACAD_CAREER
   having
      PS_STDNT_ENRL_Extract.STRM = MIN(PS_STDNT_ENRL_Extract.STRM)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Prior Core Course Enrollment **/

/*==========================================================================* 
 * Step:            Prior Core Enrollment                 A5B29B8Q.BZ000A1K * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_12H_Flag_Unduplicated -        A5B29B8Q.BS0003CF * 
 *                   work.CBM00S_12H_Flag_Unduplicated                      * 
 *                  CBM00S_Core_Crse_Enrl -               A5B29B8Q.BS0003CG * 
 *                   work.CBM00S_Core_Crse_Enrl                             * 
 * Target Table:    CBM00S_Prior_Enrollment -             A5B29B8Q.BS0003CH * 
 *                   work.CBM00S_Prior_Enrollment                           * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1K);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_12H_Flag_Unduplicated, DATA)) or 
         %sysfunc(exist(work.CBM00S_12H_Flag_Unduplicated, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_12H_Flag_Unduplicated out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Prior_Enrollment;
quit;

proc sql;
   create table work.CBM00S_Prior_Enrollment as
   select
      CBM00S_12H_Flag_Unduplicated.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_12H_Flag_Unduplicated.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_12H_Flag_Unduplicated.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_12H_Flag_Unduplicated.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_12H_Flag_Unduplicated.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_12H_Flag_Unduplicated.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_12H_Flag_Unduplicated.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_12H_Flag_Unduplicated.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_12H_Flag_Unduplicated.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_12H_Flag_Unduplicated.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_12H_Flag_Unduplicated.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_12H_Flag_Unduplicated.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_12H_Flag_Unduplicated.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_12H_Flag_Unduplicated.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_12H_Flag_Unduplicated.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_12H_Flag_Unduplicated.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_12H_Flag_Unduplicated.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_12H_Flag_Unduplicated.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_12H_Flag_Unduplicated.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_12H_Flag_Unduplicated.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_12H_Flag_Unduplicated.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_12H_Flag_Unduplicated.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_12H_Flag_Unduplicated.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_12H_Flag_Unduplicated.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_12H_Flag_Unduplicated.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_12H_Flag_Unduplicated.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_12H_Flag_Unduplicated.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_12H_Flag_Unduplicated.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_12H_Flag_Unduplicated.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_12H_Flag_Unduplicated.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_12H_Flag_Unduplicated.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_12H_Flag_Unduplicated.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_12H_Flag_Unduplicated.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_12H_Flag_Unduplicated.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_12H_Flag_Unduplicated.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_12H_Flag_Unduplicated.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_12H_Flag_Unduplicated.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_12H_Flag_Unduplicated.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_12H_Flag_Unduplicated.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_12H_Flag_Unduplicated.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_12H_Flag_Unduplicated.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_12H_Flag_Unduplicated.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_12H_Flag_Unduplicated.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_12H_Flag_Unduplicated.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_12H_Flag_Unduplicated.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_12H_Flag_Unduplicated.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_12H_Flag_Unduplicated.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_12H_Flag_Unduplicated.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_12H_Flag_Unduplicated.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_12H_Flag_Unduplicated.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_12H_Flag_Unduplicated.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_12H_Flag_Unduplicated.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_12H_Flag_Unduplicated.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_12H_Flag_Unduplicated.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_12H_Flag_Unduplicated.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_12H_Flag_Unduplicated.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_12H_Flag_Unduplicated.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_12H_Flag_Unduplicated.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_12H_Flag_Unduplicated.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_12H_Flag_Unduplicated.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_12H_Flag_Unduplicated.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_12H_Flag_Unduplicated.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_12H_Flag_Unduplicated.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_12H_Flag_Unduplicated.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_12H_Flag_Unduplicated.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_12H_Flag_Unduplicated.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_12H_Flag_Unduplicated.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_12H_Flag_Unduplicated.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_12H_Flag_Unduplicated.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_12H_Flag_Unduplicated.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_12H_Flag_Unduplicated.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_12H_Flag_Unduplicated.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_12H_Flag_Unduplicated.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_12H_Flag_Unduplicated.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_12H_Flag_Unduplicated.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_Core_Crse_Enrl.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_12H_Flag_Unduplicated.NCBO length = 8   
         label = 'NCBO',
      CBM00S_12H_Flag_Unduplicated.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_12H_Flag_Unduplicated.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_12H_Flag_Unduplicated.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_12H_Flag_Unduplicated.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_12H_Flag_Unduplicated.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_12H_Flag_Unduplicated.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_12H_Flag_Unduplicated.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_12H_Flag_Unduplicated.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_12H_Flag_Unduplicated.MathCore length = 8   
         label = 'MathCore',
      CBM00S_12H_Flag_Unduplicated.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_12H_Flag_Unduplicated.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_12H_Flag_Unduplicated.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_12H_Flag_Unduplicated.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_12H_Flag_Unduplicated as CBM00S_12H_Flag_Unduplicated left join 
      work.CBM00S_Core_Crse_Enrl as CBM00S_Core_Crse_Enrl
         on
         (
            CBM00S_12H_Flag_Unduplicated.STRM = CBM00S_Core_Crse_Enrl.STRM
            and CBM00S_12H_Flag_Unduplicated.EMPLID = CBM00S_Core_Crse_Enrl.EMPLID
            and CBM00S_12H_Flag_Unduplicated.ACAD_CAREER = CBM00S_Core_Crse_Enrl.ACAD_CAREER
            and CBM00S_12H_Flag_Unduplicated.CRSE_ID = CBM00S_Core_Crse_Enrl.CRSE_ID
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Prior Core Enrollment **/

/*==========================================================================* 
 * Step:            Ferpa Flag                            A5B29B8Q.BZ000A1L * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_Prior_Enrollment -             A5B29B8Q.BS0003CH * 
 *                   work.CBM00S_Prior_Enrollment                           * 
 *                  PS_PERSON_SA_Extract -                A5B29B8Q.BE00000P * 
 *                   ADWSTGPR.PS_PERSON_SA_Extract                          * 
 *                  PS_SRVC_IND_DATA_Extract -            A5B29B8Q.BE00000Q * 
 *                   ADWSTGPR.PS_SRVC_IND_DATA_Extract                      * 
 * Target Table:    CBM00S_Ferpa - work.CBM00S_Ferpa      A5B29B8Q.BS0003CI * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1L);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_Prior_Enrollment, DATA)) or 
         %sysfunc(exist(work.CBM00S_Prior_Enrollment, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_Prior_Enrollment out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Ferpa;
quit;

proc sql;
   create table work.CBM00S_Ferpa as
   select
      CBM00S_Prior_Enrollment.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_Prior_Enrollment.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_Prior_Enrollment.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_Prior_Enrollment.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_Prior_Enrollment.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_Prior_Enrollment.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_Prior_Enrollment.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_Prior_Enrollment.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_Prior_Enrollment.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_Prior_Enrollment.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_Prior_Enrollment.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_Prior_Enrollment.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_Prior_Enrollment.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_Prior_Enrollment.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_Prior_Enrollment.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_Prior_Enrollment.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_Prior_Enrollment.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_Prior_Enrollment.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_Prior_Enrollment.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_Prior_Enrollment.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_Prior_Enrollment.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_Prior_Enrollment.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_Prior_Enrollment.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_Prior_Enrollment.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_Prior_Enrollment.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_Prior_Enrollment.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_Prior_Enrollment.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_Prior_Enrollment.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_Prior_Enrollment.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_Prior_Enrollment.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_Prior_Enrollment.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_Prior_Enrollment.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_Prior_Enrollment.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_Prior_Enrollment.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_Prior_Enrollment.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_Prior_Enrollment.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_Prior_Enrollment.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_Prior_Enrollment.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_Prior_Enrollment.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_Prior_Enrollment.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_Prior_Enrollment.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_Prior_Enrollment.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_Prior_Enrollment.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_Prior_Enrollment.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_Prior_Enrollment.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_Prior_Enrollment.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_Prior_Enrollment.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_Prior_Enrollment.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_Prior_Enrollment.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_Prior_Enrollment.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_Prior_Enrollment.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_Prior_Enrollment.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_Prior_Enrollment.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_Prior_Enrollment.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_Prior_Enrollment.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_Prior_Enrollment.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_Prior_Enrollment.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_Prior_Enrollment.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_Prior_Enrollment.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_Prior_Enrollment.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_Prior_Enrollment.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_Prior_Enrollment.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_Prior_Enrollment.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_Prior_Enrollment.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_Prior_Enrollment.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_Prior_Enrollment.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_Prior_Enrollment.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_Prior_Enrollment.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_Prior_Enrollment.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_Prior_Enrollment.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_Prior_Enrollment.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_Prior_Enrollment.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_Prior_Enrollment.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_Prior_Enrollment.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_Prior_Enrollment.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_Prior_Enrollment.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      PS_PERSON_SA_Extract.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      case when PS_SRVC_IND_DATA_Extract.EMPLID is not missing then 'Yes' 
      else 'No' end as GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBM00S_Prior_Enrollment.NCBO length = 8   
         label = 'NCBO',
      CBM00S_Prior_Enrollment.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_Prior_Enrollment.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_Prior_Enrollment.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_Prior_Enrollment.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_Prior_Enrollment.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_Prior_Enrollment.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_Prior_Enrollment.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_Prior_Enrollment.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_Prior_Enrollment.MathCore length = 8   
         label = 'MathCore',
      CBM00S_Prior_Enrollment.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_Prior_Enrollment.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_Prior_Enrollment.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_Prior_Enrollment.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_Prior_Enrollment as CBM00S_Prior_Enrollment left join 
      ADWSTGPR.PS_PERSON_SA_Extract as PS_PERSON_SA_Extract
         on
         (
            CBM00S_Prior_Enrollment.EMPLID = PS_PERSON_SA_Extract.EMPLID
         ) left join 
      ADWSTGPR.PS_SRVC_IND_DATA_Extract as PS_SRVC_IND_DATA_Extract
         on
         (
            CBM00S_Prior_Enrollment.EMPLID = PS_SRVC_IND_DATA_Extract.EMPLID
            and CBM00S_Prior_Enrollment.INSTITUTION = PS_SRVC_IND_DATA_Extract.INSTITUTION
            and PS_SRVC_IND_DATA_Extract.SRVC_IND_CD = 'GDR'
            and CBM00S_Prior_Enrollment.STRM >= PS_SRVC_IND_DATA_Extract.SRVC_IND_ACT_TERM
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Ferpa Flag **/

/*==========================================================================* 
 * Step:            SSN                                   A5B29B8Q.BZ000A1M * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_Ferpa - work.CBM00S_Ferpa      A5B29B8Q.BS0003CI * 
 *                  PS_PERS_NID_Extract -                 A5B29B8Q.BE00000R * 
 *                   ADWSTGPR.PS_PERS_NID_Extract                           * 
 *                  PS_EXTERNAL_SYSTEM_Extract -          A5B29B8Q.BE00000S * 
 *                   ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract                    * 
 * Target Table:    CBM00S_SSN - work.CBM00S_SSN          A5B29B8Q.BS0003CJ * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1M);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_Ferpa, DATA)) or 
         %sysfunc(exist(work.CBM00S_Ferpa, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_Ferpa out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_SSN;
quit;

proc sql;
   create table work.CBM00S_SSN as
   select distinct
      CBM00S_Ferpa.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      case
      when substr(PS_PERS_NID_Extract.NATIONAL_ID ,1,2) not  in ('XX','99') and  PS_PERS_NID_Extract.NATIONAL_ID <> ' ' 
      	and (PS_PERS_NID_Extract.NATIONAL_ID is not missing or PS_PERS_NID_Extract.NATIONAL_ID is not null) then PS_PERS_NID_Extract.NATIONAL_ID 
      when substr(External_System.EXTERNAL_SYSTEM_ID  ,1,2) not  in ('XX','99') and External_System.EXTERNAL_SYSTEM_ID <> ' '  
      	and ( External_System.EXTERNAL_SYSTEM_ID  is not missing or  External_System.EXTERNAL_SYSTEM_ID is not null) then External_System.EXTERNAL_SYSTEM_ID 
      else CAT('9',substr(CBM00S_Ferpa.EMPLID  ,3,8))  
      end as National_Id length = 9   
         label = 'National_Id',
      CBM00S_Ferpa.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_Ferpa.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_Ferpa.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_Ferpa.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_Ferpa.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_Ferpa.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_Ferpa.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_Ferpa.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_Ferpa.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_Ferpa.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_Ferpa.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_Ferpa.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_Ferpa.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_Ferpa.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_Ferpa.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_Ferpa.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_Ferpa.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_Ferpa.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_Ferpa.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_Ferpa.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_Ferpa.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_Ferpa.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_Ferpa.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_Ferpa.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_Ferpa.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_Ferpa.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_Ferpa.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_Ferpa.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_Ferpa.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_Ferpa.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_Ferpa.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_Ferpa.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_Ferpa.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_Ferpa.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_Ferpa.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_Ferpa.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_Ferpa.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_Ferpa.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_Ferpa.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_Ferpa.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_Ferpa.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_Ferpa.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_Ferpa.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_Ferpa.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_Ferpa.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_Ferpa.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_Ferpa.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_Ferpa.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_Ferpa.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_Ferpa.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_Ferpa.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_Ferpa.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_Ferpa.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_Ferpa.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_Ferpa.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_Ferpa.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_Ferpa.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_Ferpa.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_Ferpa.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_Ferpa.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_Ferpa.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_Ferpa.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_Ferpa.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_Ferpa.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_Ferpa.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_Ferpa.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_Ferpa.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_Ferpa.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_Ferpa.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_Ferpa.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_Ferpa.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_Ferpa.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_Ferpa.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_Ferpa.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_Ferpa.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_Ferpa.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      CBM00S_Ferpa.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBM00S_Ferpa.NCBO length = 8   
         label = 'NCBO',
      CBM00S_Ferpa.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_Ferpa.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_Ferpa.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_Ferpa.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_Ferpa.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_Ferpa.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_Ferpa.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_Ferpa.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_Ferpa.MathCore length = 8   
         label = 'MathCore',
      CBM00S_Ferpa.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_Ferpa.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_Ferpa.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_Ferpa.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_Ferpa as CBM00S_Ferpa left join 
      ADWSTGPR.PS_PERS_NID_Extract as PS_PERS_NID_Extract
         on
         (
            CBM00S_Ferpa.EMPLID = PS_PERS_NID_Extract.EMPLID
            and PS_PERS_NID_Extract.COUNTRY = 'USA'
            and PS_PERS_NID_Extract.NATIONAL_ID_TYPE = 'PR'
         ) left join 
      (
         select *
         from
            ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract
         group by
            PS_EXTERNAL_SYSTEM_Extract.EMPLID,
            PS_EXTERNAL_SYSTEM_Extract.EXTERNAL_SYSTEM
         having
            PS_EXTERNAL_SYSTEM_Extract.EFFDT = MAX(PS_EXTERNAL_SYSTEM_Extract.EFFDT)
      ) as External_System
         on
         (
            CBM00S_Ferpa.EMPLID = External_System.EMPLID
            and External_System.EXTERNAL_SYSTEM = 'CB'
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end SSN **/

/*==========================================================================* 
 * Step:            Admission Data                        A5B29B8Q.BZ000A1N * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_SSN - work.CBM00S_SSN          A5B29B8Q.BS0003CJ * 
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T * 
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      * 
 * Target Table:    CBM00S_Admissions -                   A5B29B8Q.BS0003CK * 
 *                   work.CBM00S_Admissions                                 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1N);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_SSN, DATA)) or 
         %sysfunc(exist(work.CBM00S_SSN, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_SSN out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Admissions;
quit;

proc sql;
   create table work.CBM00S_Admissions as
   select distinct
      CBM00S_SSN.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_SSN.National_Id length = 9   
         label = 'National_Id',
      CBM00S_SSN.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_SSN.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_SSN.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_SSN.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_SSN.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_SSN.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_SSN.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_SSN.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_SSN.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_SSN.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_SSN.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_SSN.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_SSN.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_SSN.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_SSN.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_SSN.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_SSN.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_SSN.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_SSN.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_SSN.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_SSN.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_SSN.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_SSN.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_SSN.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_SSN.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_SSN.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_SSN.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_SSN.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_SSN.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_SSN.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_SSN.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_SSN.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_SSN.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_SSN.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_SSN.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_SSN.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_SSN.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_SSN.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_SSN.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_SSN.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_SSN.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_SSN.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_SSN.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_SSN.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_SSN.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_SSN.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_SSN.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_SSN.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_SSN.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_SSN.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_SSN.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_SSN.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_SSN.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_SSN.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_SSN.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_SSN.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_SSN.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_SSN.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_SSN.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_SSN.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_SSN.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_SSN.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_SSN.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_SSN.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_SSN.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_SSN.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_SSN.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_SSN.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_SSN.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_SSN.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_SSN.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_SSN.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_SSN.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_SSN.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_SSN.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_SSN.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      CBM00S_SSN.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBM00S_SSN.NCBO length = 8   
         label = 'NCBO',
      CBM00S_SSN.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_SSN.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      MAX(ACAD_PROG_EFFDT.ADM_APPL_NBR ) as ADM_APPL_NBR length = 8   
         label = 'ADM_APPL_NBR',
      ACAD_PROG_EFFDT.APPL_PROG_NBR length = 8   
         label = 'APPL_PROG_NBR',
      ACAD_PROG_EFFDT.STDNT_CAR_NBR as ADM_STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      ACAD_PROG_EFFDT.ADMIT_TERM as ADM_ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADM_ADMIT_TERM',
      CBM00S_SSN.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_SSN.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_SSN.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_SSN.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_SSN.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_SSN.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_SSN.MathCore length = 8   
         label = 'MathCore',
      CBM00S_SSN.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_SSN.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_SSN.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_SSN.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_SSN as CBM00S_SSN left join 
      (
         select *
         from
            (
               select *
               from
                  ADWSTGPR.PS_ADM_APPL_PROG_Extract
               group by
                  PS_ADM_APPL_PROG_Extract.EMPLID,
                  PS_ADM_APPL_PROG_Extract.ACAD_CAREER,
                  PS_ADM_APPL_PROG_Extract.ADMIT_TERM,
                  PS_ADM_APPL_PROG_Extract.EFFDT
               having
                  PS_ADM_APPL_PROG_Extract.EFFSEQ = MAX(PS_ADM_APPL_PROG_Extract.EFFSEQ )
            ) as MAX_EFFSEQ
         group by
            MAX_EFFSEQ.EMPLID,
            MAX_EFFSEQ.ACAD_CAREER,
            MAX_EFFSEQ.ADMIT_TERM
         having
            MAX_EFFSEQ.EFFDT = MAX(MAX_EFFSEQ.EFFDT)
      ) as ACAD_PROG_EFFDT
         on
         (
            CBM00S_SSN.EMPLID = ACAD_PROG_EFFDT.EMPLID
            and CBM00S_SSN.ACAD_CAREER = ACAD_PROG_EFFDT.ACAD_CAREER
            and INPUT(CBM00S_SSN.STRM ,BEST8.) >= INPUT(ACAD_PROG_EFFDT.ADMIT_TERM  ,BEST8.)
         )
   group by
      CBM00S_SSN.EMPLID,
      CBM00S_SSN.ACAD_CAREER,
      CBM00S_SSN.SUBJECT,
      CBM00S_SSN.CATALOG_NBR,
      CBM00S_SSN.CLASS_NBR
   having
      ACAD_PROG_EFFDT.ADMIT_TERM = MAX(ACAD_PROG_EFFDT.ADMIT_TERM)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Admission Data **/

/*==========================================================================* 
 * Step:            EAP Flag                              A5B29B8Q.BZ000A1O * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U * 
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      * 
 *                  PS_ADM_APPL_RCR_CA_Extract -          A5B29B8Q.BE00000V * 
 *                   ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract                    * 
 *                  CBM00S_Admissions -                   A5B29B8Q.BS0003CK * 
 *                   work.CBM00S_Admissions                                 * 
 * Target Table:    CBM00S_EAP - work.CBM00S_EAP          A5B29B8Q.BS0003CL * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1O);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_ADM_APPL_DATA_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_ADM_APPL_DATA_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_ADM_APPL_DATA_Extract;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_EAP;
quit;

proc sql;
   create view work.CBM00S_EAP as
   select
      CBM00S_Admissions.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_Admissions.National_Id length = 9   
         label = 'National_Id',
      CBM00S_Admissions.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_Admissions.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_Admissions.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_Admissions.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_Admissions.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_Admissions.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_Admissions.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_Admissions.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_Admissions.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_Admissions.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_Admissions.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_Admissions.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_Admissions.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_Admissions.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_Admissions.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_Admissions.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_Admissions.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_Admissions.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_Admissions.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_Admissions.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_Admissions.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_Admissions.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_Admissions.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_Admissions.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_Admissions.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_Admissions.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_Admissions.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_Admissions.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_Admissions.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_Admissions.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_Admissions.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_Admissions.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_Admissions.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_Admissions.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_Admissions.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_Admissions.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_Admissions.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_Admissions.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_Admissions.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_Admissions.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_Admissions.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_Admissions.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_Admissions.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_Admissions.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_Admissions.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_Admissions.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_Admissions.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_Admissions.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_Admissions.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_Admissions.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_Admissions.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_Admissions.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_Admissions.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_Admissions.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_Admissions.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_Admissions.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_Admissions.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_Admissions.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_Admissions.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_Admissions.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_Admissions.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_Admissions.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_Admissions.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_Admissions.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_Admissions.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_Admissions.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_Admissions.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_Admissions.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_Admissions.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_Admissions.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_Admissions.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_Admissions.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_Admissions.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_Admissions.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_Admissions.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_Admissions.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      CBM00S_Admissions.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBM00S_Admissions.NCBO length = 8   
         label = 'NCBO',
      CBM00S_Admissions.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_Admissions.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_Admissions.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM00S_Admissions.ADM_ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADM_ADMIT_TERM',
      PS_ADM_APPL_DATA_Extract.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      PS_ADM_APPL_RCR_CA_Extract.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM00S_Admissions.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_Admissions.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_Admissions.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_Admissions.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_Admissions.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_Admissions.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_Admissions.MathCore length = 8   
         label = 'MathCore',
      CBM00S_Admissions.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_Admissions.WriteCore length = 8   
         label = 'WriteCore',
      CBM00S_Admissions.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_Admissions.AP_Course length = 1   
         label = 'AP_Course'
   from
      work.CBM00S_Admissions as CBM00S_Admissions left join 
      ADWSTGPR.PS_ADM_APPL_DATA_Extract as PS_ADM_APPL_DATA_Extract
         on
         (
            CBM00S_Admissions.EMPLID = PS_ADM_APPL_DATA_Extract.EMPLID
            and CBM00S_Admissions.ACAD_CAREER = PS_ADM_APPL_DATA_Extract.ACAD_CAREER
            and CBM00S_Admissions.ADM_STDNT_CAR_NBR = PS_ADM_APPL_DATA_Extract.STDNT_CAR_NBR
            and CBM00S_Admissions.ADM_APPL_NBR = PS_ADM_APPL_DATA_Extract.ADM_APPL_NBR
         ) left join 
      ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract as PS_ADM_APPL_RCR_CA_Extract
         on
         (
            CBM00S_Admissions.EMPLID = PS_ADM_APPL_RCR_CA_Extract.EMPLID
            and CBM00S_Admissions.ACAD_CAREER = PS_ADM_APPL_RCR_CA_Extract.ACAD_CAREER
            and CBM00S_Admissions.ADM_STDNT_CAR_NBR = PS_ADM_APPL_RCR_CA_Extract.STDNT_CAR_NBR
            and CBM00S_Admissions.ADM_APPL_NBR = PS_ADM_APPL_RCR_CA_Extract.ADM_APPL_NBR
            and CBM00S_Admissions.INSTITUTION = PS_ADM_APPL_RCR_CA_Extract.INSTITUTION
            and PS_ADM_APPL_RCR_CA_Extract.RECRUITMENT_CAT = 'AUEA'
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end EAP Flag **/

/*==========================================================================* 
 * Step:            AP and DLRN                           A5B29B8Q.BZ000A1P * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_EAP - work.CBM00S_EAP          A5B29B8Q.BS0003CL * 
 *                  PS_UTA_HEH_PLAN_TB_Extract -          A5B29B8Q.BE0001LC * 
 *                   ADWSTGPR.PS_UTA_HEH_PLAN_TB_Extract                    * 
 * Target Table:    CBM00S_AP - work.CBM00S_AP            A5B29B8Q.BS0003CM * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1P);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = -1;
/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_AP;
quit;

proc sql;
   create view work.CBM00S_AP as
   select
      CBM00S_EAP.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_EAP.National_Id length = 9   
         label = 'National_Id',
      CBM00S_EAP.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_EAP.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_EAP.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_EAP.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_EAP.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_EAP.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_EAP.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_EAP.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_EAP.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_EAP.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_EAP.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_EAP.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_EAP.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_EAP.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_EAP.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_EAP.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_EAP.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_EAP.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_EAP.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_EAP.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_EAP.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_EAP.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_EAP.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_EAP.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_EAP.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_EAP.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_EAP.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_EAP.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_EAP.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_EAP.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_EAP.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_EAP.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_EAP.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_EAP.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_EAP.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_EAP.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_EAP.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_EAP.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_EAP.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_EAP.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_EAP.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_EAP.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_EAP.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_EAP.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_EAP.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_EAP.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_EAP.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_EAP.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_EAP.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_EAP.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_EAP.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_EAP.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_EAP.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_EAP.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_EAP.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_EAP.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_EAP.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_EAP.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_EAP.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_EAP.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_EAP.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_EAP.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_EAP.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_EAP.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_EAP.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_EAP.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_EAP.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_EAP.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_EAP.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_EAP.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_EAP.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_EAP.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_EAP.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_EAP.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_EAP.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_EAP.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      CBM00S_EAP.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBM00S_EAP.NCBO length = 8   
         label = 'NCBO',
      CBM00S_EAP.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_EAP.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_EAP.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM00S_EAP.ADM_ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADM_ADMIT_TERM',
      CBM00S_EAP.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBM00S_EAP.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM00S_EAP.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_EAP.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      case when  PS_UTA_HEH_PLAN_TB_Extract.ACAD_PLAN is not missing then 'Yes' 
      else 'No' end as AP_Student length = 8   
         label = 'AP_Student',
      CBM00S_EAP.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_EAP.AP_Course length = 1   
         label = 'AP_Course',
      CBM00S_EAP.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_EAP.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_EAP.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_EAP.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_EAP.MathCore length = 8   
         label = 'MathCore',
      CBM00S_EAP.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_EAP.WriteCore length = 8   
         label = 'WriteCore'
   from
      work.CBM00S_EAP as CBM00S_EAP left join 
      ADWSTGPR.PS_UTA_HEH_PLAN_TB_Extract as PS_UTA_HEH_PLAN_TB_Extract
         on
         (
            CBM00S_EAP.ACAD_CAREER = PS_UTA_HEH_PLAN_TB_Extract.ACAD_CAREER
            and CBM00S_EAP.ACAD_PLAN = PS_UTA_HEH_PLAN_TB_Extract.ACAD_PLAN
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end AP and DLRN **/

/*==========================================================================* 
 * Step:            Prior College Class                   A5B29B8Q.BZ000A1Q * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_AP - work.CBM00S_AP            A5B29B8Q.BS0003CM * 
 *                  PS_TRNS_TEST_DTL_Extract -            A5B29B8Q.BE00000X * 
 *                   ADWSTGPR.PS_TRNS_TEST_DTL_Extract                      * 
 *                  PS_TRNS_CRSE_DTL_Extract -            A5B29B8Q.BE00000Y * 
 *                   ADWSTGPR.PS_TRNS_CRSE_DTL_Extract                      * 
 * Target Table:    CBM00S_Prior_College_Course -         A5B29B8Q.BS0003CN * 
 *                   work.CBM00S_Prior_College_Course                       * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1Q);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = -1;
/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Prior_College_Course;
quit;

proc sql;
   create table work.CBM00S_Prior_College_Course as
   select distinct
      CBM00S_AP.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_AP.National_Id length = 9   
         label = 'National_Id',
      CBM00S_AP.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_AP.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_AP.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_AP.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_AP.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_AP.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_AP.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_AP.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_AP.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_AP.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_AP.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_AP.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_AP.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_AP.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_AP.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_AP.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_AP.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_AP.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_AP.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_AP.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_AP.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_AP.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_AP.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_AP.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_AP.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_AP.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_AP.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_AP.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_AP.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_AP.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_AP.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_AP.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_AP.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_AP.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_AP.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_AP.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_AP.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_AP.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_AP.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_AP.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_AP.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_AP.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_AP.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_AP.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_AP.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_AP.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_AP.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_AP.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_AP.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_AP.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_AP.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_AP.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_AP.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_AP.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_AP.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_AP.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_AP.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_AP.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_AP.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_AP.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_AP.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_AP.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_AP.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_AP.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_AP.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_AP.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_AP.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_AP.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_AP.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_AP.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_AP.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_AP.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_AP.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_AP.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_AP.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_AP.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      CBM00S_AP.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBM00S_AP.NCBO length = 8   
         label = 'NCBO',
      CBM00S_AP.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_AP.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_AP.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM00S_AP.ADM_ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADM_ADMIT_TERM',
      CBM00S_AP.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBM00S_AP.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      MIN(PS_TRNS_TEST_DTL_Extract.ARTICULATION_TERM) as ARTICULATION_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ARTICULATION_TERM',
      CBM00S_AP.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_AP.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_AP.AP_Student length = 8   
         label = 'AP_Student',
      CBM00S_AP.AP_Course length = 1   
         label = 'AP_Course',
      CBM00S_AP.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_AP.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_AP.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_AP.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      case when PS_TRNS_CRSE_DTL_Extract.RQMNT_DESIGNTN is not missing then 'Yes'  
      else 'No' end as Prior_Crse_Transfer length = 8   
         label = 'Prior_Crse_Transfer',
      CBM00S_AP.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_AP.MathCore length = 8   
         label = 'MathCore',
      CBM00S_AP.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_AP.WriteCore length = 8   
         label = 'WriteCore'
   from
      work.CBM00S_AP as CBM00S_AP left join 
      ADWSTGPR.PS_TRNS_TEST_DTL_Extract as PS_TRNS_TEST_DTL_Extract
         on
         (
            CBM00S_AP.EMPLID = PS_TRNS_TEST_DTL_Extract.EMPLID
            and CBM00S_AP.ACAD_CAREER = PS_TRNS_TEST_DTL_Extract.ACAD_CAREER
            and PS_TRNS_TEST_DTL_Extract.TEST_ID IN ('AP', 'CLEP', 'IB')
            and PS_TRNS_TEST_DTL_Extract.RQMNT_DESIGNTN IN ('020','2092', '092', '040','060','070','080','098','4094','8098','010','1091' )
         ) left join 
      ADWSTGPR.PS_TRNS_CRSE_DTL_Extract as PS_TRNS_CRSE_DTL_Extract
         on
         (
            CBM00S_AP.EMPLID = PS_TRNS_CRSE_DTL_Extract.EMPLID
            and PS_TRNS_CRSE_DTL_Extract.ACAD_CAREER = 'UGRD'
            and PS_TRNS_CRSE_DTL_Extract.INSTITUTION = 'UTARL'
            and PS_TRNS_CRSE_DTL_Extract.RQMNT_DESIGNTN IN ('020','2092', '092', '040','060','070','080','098','4094','8098','010','1091' )
         )
   group by
      PS_TRNS_TEST_DTL_Extract.EMPLID,
      PS_TRNS_TEST_DTL_Extract.ACAD_CAREER
   having
      PS_TRNS_TEST_DTL_Extract.ARTICULATION_TERM = MIN(PS_TRNS_TEST_DTL_Extract.ARTICULATION_TERM)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Prior College Class **/

/*==========================================================================* 
 * Step:            PRE1998                               A5B29B8Q.BZ000A1R * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM00S_Prior_College_Course -         A5B29B8Q.BS0003CN * 
 *                   work.CBM00S_Prior_College_Course                       * 
 *                  PS_EXT_COURSE_Extract -               A5B29B8Q.BE00000Z * 
 *                   ADWSTGPR.PS_EXT_COURSE_Extract                         * 
 *                  PS_TRNS_CRSE_DTL_Extract -            A5B29B8Q.BE00000Y * 
 *                   ADWSTGPR.PS_TRNS_CRSE_DTL_Extract                      * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 * Target Table:    CBMS_PRE98 - work.CBMS_PRE98          A5B29B8Q.BS0003CO * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1R);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_Prior_College_Course, DATA)) or 
         %sysfunc(exist(work.CBM00S_Prior_College_Course, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_Prior_College_Course out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBMS_PRE98;
quit;

proc sql;
   create table work.CBMS_PRE98 as
   select distinct
      CBM00S_Prior_College_Course.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_Prior_College_Course.National_Id length = 9   
         label = 'National_Id',
      CBM00S_Prior_College_Course.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_Prior_College_Course.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM00S_Prior_College_Course.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM00S_Prior_College_Course.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM00S_Prior_College_Course.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM00S_Prior_College_Course.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM00S_Prior_College_Course.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM00S_Prior_College_Course.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_Prior_College_Course.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_Prior_College_Course.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_Prior_College_Course.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_Prior_College_Course.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM00S_Prior_College_Course.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM00S_Prior_College_Course.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM00S_Prior_College_Course.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_Prior_College_Course.COMBINED_SECTION length = 1   
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CBM00S_Prior_College_Course.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_Prior_College_Course.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_Prior_College_Course.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM00S_Prior_College_Course.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM00S_Prior_College_Course.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_Prior_College_Course.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM00S_Prior_College_Course.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM00S_Prior_College_Course.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_Prior_College_Course.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_Prior_College_Course.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_Prior_College_Course.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_Prior_College_Course.Prior_Term length = 8   
         label = 'Previous Term',
      CBM00S_Prior_College_Course.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_Prior_College_Course.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_Prior_College_Course.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM00S_Prior_College_Course.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_Prior_College_Course.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM00S_Prior_College_Course.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM00S_Prior_College_Course.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_Prior_College_Course.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_Prior_College_Course.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_Prior_College_Course.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM00S_Prior_College_Course.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_Prior_College_Course.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_Prior_College_Course.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_Prior_College_Course.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM00S_Prior_College_Course.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM00S_Prior_College_Course.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM00S_Prior_College_Course.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_Prior_College_Course.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM00S_Prior_College_Course.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM00S_Prior_College_Course.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_Prior_College_Course.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_Prior_College_Course.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM00S_Prior_College_Course.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM00S_Prior_College_Course.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_Prior_College_Course.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_Prior_College_Course.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_Prior_College_Course.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_Prior_College_Course.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM00S_Prior_College_Course.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_Prior_College_Course.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_Prior_College_Course.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_Prior_College_Course.Excess_Emplid length = 11   
         format = $11.
         informat = $11.
         label = 'Excess_Emplid',
      CBM00S_Prior_College_Course.THREEP_CRSE_ID length = 8   
         label = 'THREEP_CRSE_ID',
      CBM00S_Prior_College_Course.THREEP_UNFN_TYPE length = 8   
         label = 'THREEP_UNFN_TYPE',
      CBM00S_Prior_College_Course.THREEP_UNT_TAKEN length = 8   
         format = 7.2
         informat = 7.2
         label = 'THREEP_UNT_TAKEN',
      CBM00S_Prior_College_Course.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_Prior_College_Course.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_Prior_College_Course.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_Prior_College_Course.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM00S_Prior_College_Course.ADDL_ENRL length = 8   
         label = 'ADDL_ENRL',
      CBM00S_Prior_College_Course.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_Prior_College_Course.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_Prior_College_Course.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_Prior_College_Course.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_Prior_College_Course.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_Prior_College_Course.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_Prior_College_Course.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_Prior_College_Course.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      CBM00S_Prior_College_Course.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBM00S_Prior_College_Course.NCBO length = 8   
         label = 'NCBO',
      CBM00S_Prior_College_Course.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_Prior_College_Course.COMBINED_SECTION_CODE length = 8   
         label = 'COMBINED_SECTION_CODE',
      CBM00S_Prior_College_Course.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM00S_Prior_College_Course.ADM_ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADM_ADMIT_TERM',
      CBM00S_Prior_College_Course.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBM00S_Prior_College_Course.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM00S_Prior_College_Course.ARTICULATION_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ARTICULATION_TERM',
      CBM00S_Prior_College_Course.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_Prior_College_Course.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_Prior_College_Course.AP_Student length = 8   
         label = 'AP_Student',
      CBM00S_Prior_College_Course.AP_Course length = 1   
         label = 'AP_Course',
      CBM00S_Prior_College_Course.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_Prior_College_Course.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_Prior_College_Course.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_Prior_College_Course.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_Prior_College_Course.Prior_Crse_Transfer length = 8   
         label = 'Prior_Crse_Transfer',
      CBM00S_Prior_College_Course.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM00S_Prior_College_Course.MathCore length = 8   
         label = 'MathCore',
      CBM00S_Prior_College_Course.ReadCore length = 8   
         label = 'ReadCore',
      CBM00S_Prior_College_Course.WriteCore length = 8   
         label = 'WriteCore',
      IFC(PRE_0998_ENRL.EMPLID<>'' | PRE_0998_TRNS.EMPLID<>'' | PS_EXT_COURSE_PRE_0998.EMPLID<>'','Y','N') as PRE1998 length = 8   
         label = 'PRE1998'
   from
      work.CBM00S_Prior_College_Course as CBM00S_Prior_College_Course left join 
      (
         select *
         from
            ADWSTGPR.PS_STDNT_ENRL_Extract
         where
            PS_STDNT_ENRL_Extract.STRM < '0998'
            and PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS = 'E'
            and (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
            or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
      ) as PRE_0998_ENRL
         on
         (
            CBM00S_Prior_College_Course.ACAD_LEVEL_BOT IN ('10','20','30','40')
            and CBM00S_Prior_College_Course.EMPLID = PRE_0998_ENRL.EMPLID
         ) left join 
      (
         select *
         from
            ADWSTGPR.PS_TRNS_CRSE_DTL_Extract
         where
            PS_TRNS_CRSE_DTL_Extract.TERM_YEAR > 1900
            and (PS_TRNS_CRSE_DTL_Extract.TERM_YEAR < 1999
            or (PS_TRNS_CRSE_DTL_Extract.TERM_YEAR = 1999
            and PS_TRNS_CRSE_DTL_Extract.EXT_TERM NOT IN ('FALL','WINT')))
      ) as PRE_0998_TRNS
         on
         (
            PRE_0998_ENRL.EMPLID IS MISSING 
            and CBM00S_Prior_College_Course.EMPLID = PRE_0998_TRNS.EMPLID
         ) left join 
      (
         select *
         from
            ADWSTGPR.PS_EXT_COURSE_Extract
         where
            PS_EXT_COURSE_Extract.TERM_YEAR > 1900
            and (PS_EXT_COURSE_Extract.TERM_YEAR < 1999
            or (PS_EXT_COURSE_Extract.TERM_YEAR = 1999
            and PS_EXT_COURSE_Extract.EXT_TERM NOT IN ('FALL','WINT')))
      ) as PS_EXT_COURSE_PRE_0998
         on
         (
            PRE_0998_ENRL.EMPLID IS MISSING 
            and PRE_0998_TRNS.EMPLID IS MISSING 
            and CBM00S_Prior_College_Course.EMPLID = PS_EXT_COURSE_PRE_0998.EMPLID
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end PRE1998 **/

/*==========================================================================* 
 * Step:            Business Logic (Case Statements)      A5B29B8Q.BZ000A1S * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBMS_PRE98 - work.CBMS_PRE98          A5B29B8Q.BS0003CO * 
 * Target Table:    CBM00S_Business_Logic -               A5B29B8Q.BS0003CP * 
 *                   work.CBM00S_Business_Logic                             * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1S);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBMS_PRE98, DATA)) or 
         %sysfunc(exist(work.CBMS_PRE98, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBMS_PRE98 out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(work.CBMS_PRE98); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Business_Logic;
quit;

proc sql;
   create table work.CBM00S_Business_Logic as
   select
      'S' as Record_Code length = 1   
         format = $1.
         informat = $1.
         label = 'Record_Code',
      '003656' as College_Code length = 6   
         format = $6.
         informat = $6.
         label = 'College_Code',
      CBMS_PRE98.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      STRIP(CBMS_PRE98.EMPLID) as EMPLID length = 10   
         format = $10.
         informat = $10.
         label = 'EMPLID',
      CBMS_PRE98.National_Id length = 9   
         format = $9.
         informat = $9.
         label = 'National_Id',
      STRIP(CBMS_PRE98.SUBJECT) as SUBJECT length = 7   
         format = $7.
         informat = $7.
         label = 'SUBJECT',
      STRIP(PUT(INPUT(CBMS_PRE98.CATALOG_NBR,BEST8.),z4.)) as CATALOG_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CATALOG_NBR',
      STRIP(PUT(CBMS_PRE98.CLASS_NBR ,z5.)) as CLASS_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CLASS_NBR',
      case when FIND(UPCASE(CBMS_PRE98.CLASS_VAL_LIST ),'INDP')>0 then '5'  
      when FIND(UPCASE(CBMS_PRE98.CLASS_VAL_LIST ),'PRAC')>0 then '3'  
      when FIND(UPCASE(CBMS_PRE98.CLASS_VAL_LIST ),'PVTL')>0 then '6'  
      when CBMS_PRE98.SSR_COMPONENT = 'LEC' then '1'  
      when CBMS_PRE98.SSR_COMPONENT = 'LAB' then '2'  
      when CBMS_PRE98.SSR_COMPONENT = 'PRA' then '3'  
      when CBMS_PRE98.SSR_COMPONENT = 'SEM' then '4'  
      when CBMS_PRE98.SSR_COMPONENT = 'IND' then '5'  
      when CBMS_PRE98.SSR_COMPONENT = 'PRI' then '6'  
      when CBMS_PRE98.SSR_COMPONENT = 'THE' then '8'  
      when CBMS_PRE98.SSR_COMPONENT = 'DTN' then '9'  
      when CBMS_PRE98.SSR_COMPONENT = 'INV' then '0'  
      when CBMS_PRE98.SSR_COMPONENT = 'CLN' then 'C'  
      else '#'  
      end as Instruction_Type length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Type',
      case when CBMS_PRE98.ACAD_LEVEL_BOT ='10' then 'Freshman'  
      when CBMS_PRE98.ACAD_LEVEL_BOT ='20' then 'Sophomore'  
      when CBMS_PRE98.ACAD_LEVEL_BOT ='30' then 'Junior'  
      when CBMS_PRE98.ACAD_LEVEL_BOT ='40' then 'Senior'  
      when CBMS_PRE98.ACAD_LEVEL_BOT in ('50','60') then 'Post-Bacc'  
      when CBMS_PRE98.ACAD_PROG_PRIMARY in ('CERT','SPEC','MASTR') then 'Masters'  
      when substr(substr(CBMS_PRE98.ACAD_PLAN,1,6),length(substr(CBMS_PRE98.ACAD_PLAN,1,6))-1,-1)  = 'DB' and CBMS_PRE98.GDR_Indicator ='Yes' then 'Doctoral'  
      when substr(substr(CBMS_PRE98.ACAD_PLAN,1,6),length(substr(CBMS_PRE98.ACAD_PLAN,1,6))-1,-1)  = 'DB' and CBMS_PRE98.GDR_Indicator ='No' then 'Masters'  
      when CBMS_PRE98.ACAD_PROG_PRIMARY='DOCT' then 'Doctoral'  
      else ' '  
      end as Student_Classification_Desc length = 20   
         format = $20.
         informat = $20.
         label = 'Student_Classification_Desc',
      case when CBMS_PRE98.ACAD_LEVEL_BOT ='10' then '1'  
      when CBMS_PRE98.ACAD_LEVEL_BOT ='20' then '2'  
      when CBMS_PRE98.ACAD_LEVEL_BOT ='30' then '3'  
      when CBMS_PRE98.ACAD_LEVEL_BOT ='40' then '4'  
      when CBMS_PRE98.ACAD_LEVEL_BOT in ('50','60') then '5'  
      when CBMS_PRE98.ACAD_PROG_PRIMARY  in ('CERT','SPEC','MASTR') then '6'  
      when substr(substr(CBMS_PRE98.ACAD_PLAN,1,6),length(substr(CBMS_PRE98.ACAD_PLAN,1,6))-1,-1)  = 'DB'  and CBMS_PRE98.GDR_Indicator ='Yes' then '7'  
      when  substr(substr(CBMS_PRE98.ACAD_PLAN,1,6),length(substr(CBMS_PRE98.ACAD_PLAN,1,6))-1,-1)  = 'DB'  and CBMS_PRE98.GDR_Indicator ='No' then '6'  
      when CBMS_PRE98.ACAD_PROG_PRIMARY ='DOCT' then '7'  
      else ' '  
      end as Student_Classification length = 1   
         format = $1.
         informat = $1.
         label = 'Student_Classification',
      case when CBMS_PRE98.FERPA ='Y' then '2'  
      else '0'  
      end as Non_Disclosure length = 1   
         format = $1.
         informat = $1.
         label = 'Non_Disclosure',
      case when CBMS_PRE98.CLASS_TYPE ='N' or substr(CBMS_PRE98.CATALOG_NBR ,2,1)='0' then '0000'
      else cat('0',put(input(substr(CBMS_PRE98.CATALOG_NBR ,2,1),1.) *100,3.))
      end as SCH_Value length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_Value',
      /*case when CBMS_PRE98.FLAG_3PEAT ='Yes' or CBMS_PRE98.DVLP_FLAG ='Yes' or   
      CBMS_PRE98.EXC_FLAG  ='Yes' or CBMS_PRE98.Unfunded_Flag ='Yes' or CBMS_PRE98.CLASS_TYPE ='N' or substr(CBMS_PRE98.CATALOG_NBR ,2,1)='0' then '0000'   
      else cat('0',put(input(substr(CBMS_PRE98.CATALOG_NBR ,2,1),1.) *100,3.))  
      end
      */
      
      
      case 
      when CBMS_PRE98.FLAG_3PEAT ='Yes' or CBMS_PRE98.DVLP_FLAG ='Yes' or CBMS_PRE98.EXC_FLAG  ='Yes' or CBMS_PRE98.Unfunded_Flag ='Yes' or CBMS_PRE98.CLASS_TYPE ='N' 
      or substr(CBMS_PRE98.CATALOG_NBR ,2,1)='0' or CBMS_PRE98.CB_Reported_Student ='No' or CBMS_PRE98.CB_Reported_Course = 'No' then '0000'   
      else cat('0',put(input(substr(CBMS_PRE98.CATALOG_NBR ,2,1),1.) *100,3.))  
      end as SCH_State_Funded length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_State_Funded',
      /*
      case when (CBMS_PRE98.EXC_FLAG ='Yes' or CBMS_PRE98.FLAG_3PEAT ='Yes' or   
      CBMS_PRE98.DVLP_FLAG ='Yes' or CBMS_PRE98.Unfunded_Flag ='Yes' ) and CBMS_PRE98.CLASS_TYPE<>'N'  and substr(CBMS_PRE98.CATALOG_NBR ,2,1)<>'0' then cat('0',put(input(substr(CBMS_PRE98.CATALOG_NBR ,2,1),1.) *100,3.))  
      else '0000'   
      end
      */
      
      case 
      when (CBMS_PRE98.EXC_FLAG ='Yes' or CBMS_PRE98.FLAG_3PEAT ='Yes' or   
      CBMS_PRE98.DVLP_FLAG ='Yes' or CBMS_PRE98.Unfunded_Flag ='Yes' or CBMS_PRE98.CB_Reported_Student ='No' or CBMS_PRE98.CB_Reported_Course = 'No' ) 
      and CBMS_PRE98.CLASS_TYPE<>'N'  and substr(CBMS_PRE98.CATALOG_NBR ,2,1)<>'0' then cat('0',put(input(substr(CBMS_PRE98.CATALOG_NBR ,2,1),1.) *100,3.))  
      else '0000'   
      end as SCH_Not_State_Funded length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_Not_State_Funded',
      case when CBMS_PRE98.ACAD_LEVEL_BOT ='40' and CBMS_PRE98.MIN_UNITS_REQD-CBMS_PRE98.TOT_CUMULATIVE <=12   
      and CBMS_PRE98.DEGR_CHKOUT_STAT not in ('',' ','DN','WD') and CBMS_PRE98.UNT_TAKEN_SEM >0   and INPUT(SUBSTR(CBMS_PRE98.CATALOG_NBR ,1,1),BEST8.)>=5  
      then '1'   
      else '0'   
      end as Grad_12H length = 1   
         format = $1.
         informat = $1.
         label = 'Grad_12H',
      STRIP(CBMS_PRE98.UTA_CB_LOCATION_CD) as Location_Code length = 1   
         format = $1.
         informat = $1.
         label = 'Location_Code',
      IFC(STRIP(CBMS_PRE98.EXT_LOC_FICE)='','',STRIP(PUT(INPUT(CBMS_PRE98.EXT_LOC_FICE,BEST8.),z6.))) as Other_Higher_Ed_Site length = 6   
         format = $6.
         informat = $6.
         label = 'Other_Higher_Ed_Site',
      ifc(CBMS_PRE98.INSTRUCTION_MODE='02', '7', SUBSTR(CBMS_PRE98.INSTRUCTION_MODE ,2,1)) as Instruction_Mode length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Mode',
      IFC((CBMS_PRE98.FLAG_3PEAT ='Yes' or CBMS_PRE98.DVLP_FLAG  ='Yes' or 
      CBMS_PRE98.EXC_FLAG  ='Yes' or CBMS_PRE98.Unfunded_Flag ='Yes') and CBMS_PRE98.CLASS_TYPE <> 'N' and substr(CBMS_PRE98.CATALOG_NBR ,2,1)<>'0', 
      IFC(CBMS_PRE98.DVLP_FLAG ='Yes','1',   
      IFC( CBMS_PRE98.FLAG_3PEAT='Yes','2',   
      IFC( CBMS_PRE98.EXC_FLAG ='Yes' and CBMS_PRE98.ACAD_LEVEL_BOT  in ('10','20','30','40','50','60') and  CBMS_PRE98.ACAD_PROG in ('UGRD','UGRD2'),'3',
      IFC(CBMS_PRE98.Unfunded_Flag ='Yes' or CBMS_PRE98.PHYED_CNT_FLG ='Yes','4',   
      IFC( CBMS_PRE98.EXC_FLAG ='Yes' and
            ((substr(substr(CBMS_PRE98.ACAD_PLAN,1,6),length(substr(CBMS_PRE98.ACAD_PLAN,1,6))-1,-1)  = 'DB'  and CBMS_PRE98.GDR_Indicator ='Yes')
             or ( CBMS_PRE98.ACAD_PROG_PRIMARY ='DOCT' )) ,'8','0 '
      ))))),'0') as SCH_Not_Funded_Reason length = 1   
         format = $1.
         informat = $1.
         label = 'SCH_Not_Funded_Reason',
      case when CBMS_PRE98.ACAD_CAREER ='UGRD' and CBMS_PRE98.ADMIT_TYPE in ('1','5')  
      and CBMS_PRE98.ACAD_PROG ='UGNDS' and CBMS_PRE98.RECRUITMENT_CAT ='AUEA'  
      then '1'  
      else '0'  
      end as HighSchool_Credit length = 1   
         format = $1.
         informat = $1.
         label = 'HighSchool_Credit',
      IFC(CBMS_PRE98.NCBO ='Y', '9' ,  
            IFC( FIND(UPCASE(CBMS_PRE98.CLASS_ATTR_LIST),'DVLP')>0 and SUBSTR(CBMS_PRE98.CLASS_SECTION,1,1)<>'C', '1',  
            IFC( FIND(UPCASE(CBMS_PRE98.CLASS_ATTR_LIST),'DVLP')>0 and SUBSTR(CBMS_PRE98.CLASS_SECTION,1,1)='C', '8',  
            IFC( FIND(UPCASE(CBMS_PRE98.CLASS_ATTR_LIST),'DVLP')=0 and  SUBSTR(CBMS_PRE98.CLASS_SECTION,1,1)='C','B','0'  
      )))) as Developmental_Education length = 1   
         format = $1.
         informat = $1.
         label = 'Developmental_Education',
      IFC(CBMS_PRE98.Prior_Enrolled_Term is  missing,   
             IFC(CBMS_PRE98.ACAD_CAREER ='UGRD' and CBMS_PRE98.CRSE_GRADE_OFF in ('A','B','C','P')  
                     and CBMS_PRE98.CORE_COURSE ='Yes',   
      	IFC(CBMS_PRE98.MathCore =1 ,'1',  
      	         IFC(CBMS_PRE98.ReadCore =1 ,'2',  
      		IFC(CBMS_PRE98.WriteCore = 1,'3','0' ))),'0'),'0') as First_College_Level_Course length = 1   
         format = $1.
         informat = $1.
         label = 'First_College_Level_Course',
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='A','1',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='B','2',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='C','3',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='D','4',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='F','5',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF  IN ('I','Z'),'6',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF IN ('W','Q'),'7',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF IN ('P','R'),'8',
      IFC(CBMS_PRE98.SSR_COMPONENT = 'LAB' and CBMS_PRE98.CRSE_GRADE_OFF is missing, '8','X'
      ))))))))) as Course_Grade length = 1   
         format = $1.
         informat = $1.
         label = 'Course_Grade',
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='A','400',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='B','300',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='C','200',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='D','100',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF ='F','000',  
      IFC(CBMS_PRE98.CRSE_GRADE_OFF  IN ('I','Z','W','Q','P','R'),'',''  
      )))))) as Grade_Value length = 3   
         format = $3.
         informat = $3.
         label = 'Grade_Value',
      STRIP(CBMS_PRE98.COMBINED_SECTION_CODE) as Composite_Class_Code length = 2   
         format = $2.
         informat = $2.
         label = 'Composite_Class_Code',
      IFC(CBMS_PRE98.OFFSITE_LOC_CD<>'',STRIP(PUT(INPUT(CBMS_PRE98.OFFSITE_LOC_CD,BEST8.),z5.)),'') as Off_Campus_Location length = 5   
         format = $5.
         informat = $5.
         label = 'Off_Campus_Location',
      /*case when CBMS_PRE98.SESSION_CODE ='DYN' and CBMS_PRE98.END_DT <=CBMS_PRE98.Current_Term_End_date and CBMS_PRE98.START_DT >CBMS_PRE98.CENSUS_DT then '1'   
       when CBMS_PRE98.SESSION_CODE ='DYN' and CBMS_PRE98.END_DT>CBMS_PRE98.TERM_END_DT and CBMS_PRE98.END_DT <=CBMS_PRE98.Current_Term_End_date then '6'   
      else ' '   
      end*/
      
      case 
      when (CBMS_PRE98.Current_Term= CBMS_PRE98.STRM and CBMS_PRE98.SESSION_CODE <>'1' and CBMS_PRE98.END_DT <=CBMS_PRE98.Current_Term_End_date  
      	and CBMS_PRE98.START_DT >CBMS_PRE98.CENSUS_DT) then '1'    
      
      
      when input(CBMS_PRE98.Current_Term,BEST8.) - INPUT(CBMS_PRE98.STRM,BEST8.) > 0 and CBMS_PRE98.START_DT <=CBMS_PRE98.CENSUS_DT
      and CBMS_PRE98.END_DT>CBMS_PRE98.TERM_END_DT and CBMS_PRE98.END_DT<=CBMS_PRE98.Current_Term_End_date then '6'    
      
      when input(CBMS_PRE98.Current_Term,BEST8.) - INPUT(CBMS_PRE98.STRM,BEST8.) > 0 and CBMS_PRE98.START_DT > CBMS_PRE98.CENSUS_DT
      and CBMS_PRE98.END_DT>CBMS_PRE98.TERM_END_DT and CBMS_PRE98.END_DT<=CBMS_PRE98.Current_Term_End_date then '6'    
      else ' '    
      end as Flex_entry length = 1   
         format = $1.
         informat = $1.
         label = 'Flex_entry',
      case when CBMS_PRE98.CAMPUS <>'MAIN' and CBMS_PRE98.UTA_CB_LOCATION_CD in ('0','6','9') then '0'  
      when  CBMS_PRE98.CAMPUS <>'MAIN' and CBMS_PRE98.UTA_CB_LOCATION_CD ='1' then '1'  
      else '0'   
      end as Inter_Institution_Identifier length = 1   
         format = $1.
         informat = $1.
         label = 'Inter_Institution_Identifier',
      /*
      case when CBMS_PRE98.SESSION_CODE ='DYN' and CBMS_PRE98.END_DT>CBMS_PRE98.TERM_END_DT and CBMS_PRE98.END_DT <=CBMS_PRE98.Current_Term_End_date and SUBSTR(CBMS_PRE98.STRM,4,1)='8' then '2'   
      when CBMS_PRE98.SESSION_CODE ='DYN' and CBMS_PRE98.END_DT>CBMS_PRE98.TERM_END_DT and CBMS_PRE98.END_DT <=CBMS_PRE98.Current_Term_End_date and SUBSTR(CBMS_PRE98.STRM,4,1)='2' then '3'   
      when CBMS_PRE98.SESSION_CODE ='DYN' and CBMS_PRE98.END_DT>CBMS_PRE98.TERM_END_DT and CBMS_PRE98.END_DT <=CBMS_PRE98.Current_Term_End_date and SUBSTR(CBMS_PRE98.STRM,4,1)='5' then '1'   
      when  SUBSTR(CBMS_PRE98.STRM,4,1)='8' then '1'   
      when  SUBSTR(CBMS_PRE98.STRM,4,1)='2' then '2'   
      when  SUBSTR(CBMS_PRE98.STRM,4,1)='5' then '3'   
      else ' '   
      end
      */
      
      
      case 
      when  SUBSTR(CBMS_PRE98.Current_Term,4,1)='8' then '1'   
      when  SUBSTR(CBMS_PRE98.Current_Term,4,1)='2' then '2'   
      when  SUBSTR(CBMS_PRE98.Current_Term,4,1)='5' then '3'   
      else ' '   
      end as Semester length = 1   
         format = $1.
         informat = $1.
         label = 'Semester',
      case when CBMS_PRE98.SESSION_CODE ='DYN' and CBMS_PRE98.END_DT>CBMS_PRE98.TERM_END_DT
      and CBMS_PRE98.END_DT <=CBMS_PRE98.Current_Term_End_date and SUBSTR(CBMS_PRE98.STRM,4,1)='8' 
      then Put(input(cat('20',substr(CBMS_PRE98.STRM ,2,2)),4.)+1,4.)   
      else  cat('20',substr(CBMS_PRE98.STRM ,2,2)) 
      end as Year length = 4   
         format = $4.
         informat = $4.
         label = 'Year',
      PUT(DATEPART(CBMS_PRE98.START_DT) ,yymmddn8.) as START_DT length = 8   
         format = $8.
         informat = $8.
         label = 'START_DT',
      PUT(DATEPART(CBMS_PRE98.END_DT) ,yymmddn8.) as END_DT length = 8   
         format = $8.
         informat = $8.
         label = 'END_DT',
      CBMS_PRE98.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBMS_PRE98.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBMS_PRE98.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBMS_PRE98.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBMS_PRE98.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBMS_PRE98.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBMS_PRE98.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBMS_PRE98.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBMS_PRE98.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBMS_PRE98.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBMS_PRE98.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBMS_PRE98.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBMS_PRE98.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBMS_PRE98.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBMS_PRE98.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBMS_PRE98.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBMS_PRE98.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBMS_PRE98.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBMS_PRE98.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBMS_PRE98.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBMS_PRE98.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBMS_PRE98.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBMS_PRE98.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBMS_PRE98.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBMS_PRE98.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBMS_PRE98.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBMS_PRE98.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBMS_PRE98.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBMS_PRE98.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBMS_PRE98.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBMS_PRE98.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBMS_PRE98.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBMS_PRE98.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBMS_PRE98.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      CBMS_PRE98.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBMS_PRE98.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBMS_PRE98.ADM_ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADM_ADMIT_TERM',
      CBMS_PRE98.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBMS_PRE98.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBMS_PRE98.ARTICULATION_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ARTICULATION_TERM',
      CBMS_PRE98.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBMS_PRE98.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBMS_PRE98.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBMS_PRE98.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBMS_PRE98.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBMS_PRE98.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBMS_PRE98.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBMS_PRE98.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBMS_PRE98.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBMS_PRE98.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBMS_PRE98.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBMS_PRE98.AP_Student length = 8   
         label = 'AP_Student',
      CBMS_PRE98.AP_Course length = 1   
         label = 'AP_Course',
      CBMS_PRE98.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBMS_PRE98.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBMS_PRE98.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBMS_PRE98.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBMS_PRE98.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBMS_PRE98.Prior_Crse_Transfer length = 8   
         label = 'Prior_Crse_Transfer',
      SUBSTR(STRIP(CBMS_PRE98.Current_Term ),1,4) as Current_Term length = 4   
         format = $4.
         label = 'Current_Term',
      CBMS_PRE98.PRE1998 length = 8   
         label = 'PRE1998'
   from
      work.CBMS_PRE98 as CBMS_PRE98
   order by
      CBMS_PRE98.CATALOG_NBR,
      CBMS_PRE98.SUBJECT,
      CBMS_PRE98.CLASS_NBR,
      CBMS_PRE98.STRM
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Business Logic (Case Statements) **/

/*==========================================================================* 
 * Step:            Final Data Set                        A5B29B8Q.BZ000A1T * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM00S_Business_Logic -               A5B29B8Q.BS0003CP * 
 *                   work.CBM00S_Business_Logic                             * 
 * Target Table:    CBM00S_Final - work.CBM00S_Final      A5B29B8Q.BS0003CQ * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1T);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM00S_Business_Logic, DATA)) or 
         %sysfunc(exist(work.CBM00S_Business_Logic, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM00S_Business_Logic out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(work.CBM00S_Business_Logic); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_Final;
quit;

proc sql;
   create table work.CBM00S_Final as
   select
      CBM00S_Business_Logic.Record_Code length = 1   
         format = $1.
         informat = $1.
         label = 'Record_Code',
      CBM00S_Business_Logic.College_Code length = 6   
         format = $6.
         informat = $6.
         label = 'College_Code',
      CBM00S_Business_Logic.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM00S_Business_Logic.EMPLID length = 10   
         format = $10.
         informat = $10.
         label = 'EMPLID',
      CBM00S_Business_Logic.National_Id length = 9   
         format = $9.
         informat = $9.
         label = 'National_Id',
      CBM00S_Business_Logic.SUBJECT length = 7   
         format = $7.
         informat = $7.
         label = 'SUBJECT',
      CBM00S_Business_Logic.CATALOG_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CATALOG_NBR',
      CBM00S_Business_Logic.CLASS_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CLASS_NBR',
      CBM00S_Business_Logic.Instruction_Type length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Type',
      CBM00S_Business_Logic.Student_Classification_Desc length = 20   
         format = $20.
         informat = $20.
         label = 'Student_Classification_Desc',
      CBM00S_Business_Logic.Student_Classification length = 1   
         format = $1.
         informat = $1.
         label = 'Student_Classification',
      CBM00S_Business_Logic.Non_Disclosure length = 1   
         format = $1.
         informat = $1.
         label = 'Non_Disclosure',
      CBM00S_Business_Logic.SCH_Value length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_Value',
      CBM00S_Business_Logic.SCH_State_Funded length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_State_Funded',
      CBM00S_Business_Logic.SCH_Not_State_Funded length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_Not_State_Funded',
      CBM00S_Business_Logic.Grad_12H length = 1   
         format = $1.
         informat = $1.
         label = 'Grad_12H',
      CBM00S_Business_Logic.Location_Code length = 1   
         format = $1.
         informat = $1.
         label = 'Location_Code',
      CBM00S_Business_Logic.Other_Higher_Ed_Site length = 6   
         format = $6.
         informat = $6.
         label = 'Other_Higher_Ed_Site',
      CBM00S_Business_Logic.Instruction_Mode length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Mode',
      CBM00S_Business_Logic.SCH_Not_Funded_Reason length = 1   
         format = $1.
         informat = $1.
         label = 'SCH_Not_Funded_Reason',
      CBM00S_Business_Logic.HighSchool_Credit length = 1   
         format = $1.
         informat = $1.
         label = 'HighSchool_Credit',
      CBM00S_Business_Logic.Developmental_Education length = 1   
         format = $1.
         informat = $1.
         label = 'Developmental_Education',
      CBM00S_Business_Logic.First_College_Level_Course length = 1   
         format = $1.
         informat = $1.
         label = 'First_College_Level_Course',
      CBM00S_Business_Logic.Course_Grade length = 1   
         format = $1.
         informat = $1.
         label = 'Course_Grade',
      CBM00S_Business_Logic.Grade_Value length = 3   
         format = $3.
         informat = $3.
         label = 'Grade_Value',
      CBM00S_Business_Logic.Composite_Class_Code length = 2   
         format = $2.
         informat = $2.
         label = 'Composite_Class_Code',
      CBM00S_Business_Logic.Off_Campus_Location length = 5   
         format = $5.
         informat = $5.
         label = 'Off_Campus_Location',
      CBM00S_Business_Logic.Flex_entry length = 1   
         format = $1.
         informat = $1.
         label = 'Flex_entry',
      CBM00S_Business_Logic.Inter_Institution_Identifier length = 1   
         format = $1.
         informat = $1.
         label = 'Inter_Institution_Identifier',
      CBM00S_Business_Logic.Semester length = 1   
         format = $1.
         informat = $1.
         label = 'Semester',
      CBM00S_Business_Logic.Year length = 4   
         format = $4.
         informat = $4.
         label = 'Year',
      CBM00S_Business_Logic.START_DT length = 8   
         format = $8.
         informat = $8.
         label = 'START_DT',
      CBM00S_Business_Logic.END_DT length = 8   
         format = $8.
         informat = $8.
         label = 'END_DT',
      CBM00S_Business_Logic.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM00S_Business_Logic.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM00S_Business_Logic.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM00S_Business_Logic.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM00S_Business_Logic.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM00S_Business_Logic.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM00S_Business_Logic.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM00S_Business_Logic.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM00S_Business_Logic.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM00S_Business_Logic.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM00S_Business_Logic.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM00S_Business_Logic.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM00S_Business_Logic.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM00S_Business_Logic.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      CBM00S_Business_Logic.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM00S_Business_Logic.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM00S_Business_Logic.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM00S_Business_Logic.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM00S_Business_Logic.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM00S_Business_Logic.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM00S_Business_Logic.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM00S_Business_Logic.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM00S_Business_Logic.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM00S_Business_Logic.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM00S_Business_Logic.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM00S_Business_Logic.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM00S_Business_Logic.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      CBM00S_Business_Logic.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM00S_Business_Logic.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM00S_Business_Logic.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM00S_Business_Logic.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      CBM00S_Business_Logic.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      CBM00S_Business_Logic.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      CBM00S_Business_Logic.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      CBM00S_Business_Logic.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM00S_Business_Logic.ADM_APPL_NBR length = 8   
         label = 'ADM_APPL_NBR',
      CBM00S_Business_Logic.ADM_ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADM_ADMIT_TERM',
      CBM00S_Business_Logic.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBM00S_Business_Logic.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM00S_Business_Logic.ARTICULATION_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ARTICULATION_TERM',
      CBM00S_Business_Logic.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM00S_Business_Logic.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM00S_Business_Logic.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM00S_Business_Logic.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM00S_Business_Logic.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      CBM00S_Business_Logic.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      CBM00S_Business_Logic.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      CBM00S_Business_Logic.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      CBM00S_Business_Logic.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      CBM00S_Business_Logic.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      CBM00S_Business_Logic.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      CBM00S_Business_Logic.AP_Student length = 8   
         label = 'AP_Student',
      CBM00S_Business_Logic.AP_Course length = 1   
         label = 'AP_Course',
      CBM00S_Business_Logic.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      CBM00S_Business_Logic.DLRN_Course length = 1   
         label = 'DLRN_Course',
      CBM00S_Business_Logic.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      CBM00S_Business_Logic.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      CBM00S_Business_Logic.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      CBM00S_Business_Logic.Prior_Crse_Transfer length = 8   
         label = 'Prior_Crse_Transfer',
      CBM00S_Business_Logic.Current_Term length = 4   
         format = $4.
         label = 'Current_Term',
      CBM00S_Business_Logic.PRE1998 length = 8   
         label = 'PRE1998'
   from
      work.CBM00S_Business_Logic as CBM00S_Business_Logic
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Final Data Set **/

/*==========================================================================* 
 * Step:            Table Loader                          A5B29B8Q.BZ000A1U * 
 * Transform:       Table Loader (Version 2.1)                              * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM00S_Final - work.CBM00S_Final      A5B29B8Q.BS0003CQ * 
 * Target Table:    ADW_CBM00S_WORK -                     A5B29B8Q.BE00017F * 
 *                   ADWTGTPR.ADW_CBM00S_WORK                               * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1U);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let SYSLAST = %nrquote(work.CBM00S_Final); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|Loader), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

%global etls_tableExist;
%global etls_numIndex;
%global etls_lastTable;
%let etls_tableExist = -1; 
%let etls_numIndex = -1; 
%let etls_lastTable = &SYSLAST; 

/*---- Define load data macro  ----*/ 

/* --------------------------------------------------------------
   Load Technique Selection: Replace - Truncate
   Constraint and index action selections: 'ASIS','ASIS','ASIS','ASIS'
   Additional options selections... 
      Set unmapped to missing on updates: false 
   -------------------------------------------------------------- */
%macro etls_loader;

   %let etls_tableOptions = ;
   
   /*---- Map the columns  ----*/ 
   proc datasets lib = work nolist nowarn memtype = (data view);
      delete WTOBWUL;
   quit;
   
   %put %str(NOTE: Mapping columns ...);
   proc sql;
      create view work.WTOBWUL as
         select
            Record_Code,
            College_Code,
            STRM,
            EMPLID,
            National_Id,
            SUBJECT,
            CATALOG_NBR,
            CLASS_NBR,
            Instruction_Type,
            Student_Classification_Desc,
            Student_Classification,
            Non_Disclosure,
            SCH_Value,
            SCH_State_Funded,
            SCH_Not_State_Funded,
            Grad_12H,
            Location_Code,
            Other_Higher_Ed_Site,
            Instruction_Mode,
            SCH_Not_Funded_Reason,
            HighSchool_Credit,
            Developmental_Education,
            First_College_Level_Course,
            Course_Grade,
            Grade_Value,
            Composite_Class_Code,
            Off_Campus_Location,
            Flex_entry,
            Inter_Institution_Identifier,
            Semester,
            Year,
            START_DT,
            END_DT,
            CRSE_ID,
            CRSE_OFFER_NBR,
            CLASS_TYPE,
            ACAD_CAREER,
            ACAD_PROG,
            ACAD_GROUP,
            ACAD_ORG,
            CAMPUS,
            STDNT_CAR_NBR,
            ACAD_PLAN,
            ACAD_LEVEL_BOT,
            ACAD_LEVEL_EOT,
            DEGR_CHKOUT_STAT,
            MIN_UNITS_REQD,
            LOCATION,
            TERM_BEGIN_DT,
            TERM_END_DT,
            CENSUS_DT,
            CB_Exclude,
            ENRL_TOT,
            COMPONENT_PRIMARY,
            SESSION_CODE,
            Current_Term_End_date,
            CRSE_GRADE_OFF,
            UNT_PRGRSS,
            UNT_EARNED,
            UNT_TAKEN_SEM,
            UNT_TAKEN,
            REQ_TERM,
            TOT_CUMULATIVE,
            UTA_UNFN_TYPE,
            UTA_UNFN_UNITS,
            Prior_Enrolled_Term,
            FERPA,
            ADMIT_TERM,
            ADM_APPL_NBR   
               format = $8.
               informat = $8.,
            ADM_ADMIT_TERM,
            ADMIT_TYPE,
            RECRUITMENT_CAT,
            ARTICULATION_TERM,
            CRSE_ATTR_LIST,
            CRSE_VAL_LIST,
            CLASS_ATTR_LIST,
            CLASS_VAL_LIST,
            CORE_COURSE,
            GDR_Indicator,
            EXC_FLAG,
            DVLP_FLAG,
            FLAG_3PEAT,
            PHYED_CNT_FLG,
            Unfunded_Flag,
            AP_Student,
            AP_Course,
            DLRN_Student,
            DLRN_Course,
            CB_Reported_Student,
            CB_Reported_Course,
            Current_Semester_Reportable,
            Prior_Crse_Transfer,
            Current_Term   
               informat = $4.,
            PRE1998
      from &etls_lastTable
      ;
   quit;
   
   %let SYSLAST = work.WTOBWUL;
   
   %let etls_lastTable = &SYSLAST; 
   %let etls_tableOptions = ; 
   
   /* Determine if the target table exists  */ 
   %let etls_tableExist = %eval(%sysfunc(exist(ADWTGTPR.ADW_CBM00S_WORK, DATA)) or 
         %sysfunc(exist(ADWTGTPR.ADW_CBM00S_WORK, VIEW))); 
   
   /*---- Create a new table  ----*/ 
   %if (&etls_tableExist eq 0) %then 
   %do;  /* if table does not exist  */ 
   
      %put %str(NOTE: Creating table ...);
      
      data ADWTGTPR.ADW_CBM00S_WORK
              (dbnull = (
                         Record_Code = YES
                         College_Code = YES
                         STRM = NO
                         EMPLID = NO
                         National_Id = YES
                         SUBJECT = YES
                         CATALOG_NBR = YES
                         CLASS_NBR = YES
                         Instruction_Type = YES
                         Student_Classification_Desc = YES
                         Student_Classification = YES
                         Non_Disclosure = YES
                         SCH_Value = YES
                         SCH_State_Funded = YES
                         SCH_Not_State_Funded = YES
                         Grad_12H = YES
                         Location_Code = YES
                         Other_Higher_Ed_Site = YES
                         Instruction_Mode = YES
                         SCH_Not_Funded_Reason = YES
                         HighSchool_Credit = YES
                         Developmental_Education = YES
                         First_College_Level_Course = YES
                         Course_Grade = YES
                         Grade_Value = YES
                         Composite_Class_Code = YES
                         Off_Campus_Location = YES
                         Flex_entry = YES
                         Inter_Institution_Identifier = YES
                         Semester = YES
                         Year = YES
                         START_DT = YES
                         END_DT = YES
                         CRSE_ID = YES
                         CRSE_OFFER_NBR = YES
                         CLASS_TYPE = YES
                         ACAD_CAREER = YES
                         ACAD_PROG = YES
                         ACAD_GROUP = YES
                         ACAD_ORG = YES
                         CAMPUS = YES
                         STDNT_CAR_NBR = NO
                         ACAD_PLAN = YES
                         ACAD_LEVEL_BOT = YES
                         ACAD_LEVEL_EOT = YES
                         DEGR_CHKOUT_STAT = YES
                         MIN_UNITS_REQD = YES
                         LOCATION = YES
                         TERM_BEGIN_DT = YES
                         TERM_END_DT = YES
                         CENSUS_DT = YES
                         CB_Exclude = YES
                         ENRL_TOT = YES
                         COMPONENT_PRIMARY = YES
                         SESSION_CODE = YES
                         Current_Term_End_date = YES
                         CRSE_GRADE_OFF = YES
                         UNT_PRGRSS = YES
                         UNT_EARNED = YES
                         UNT_TAKEN_SEM = YES
                         UNT_TAKEN = YES
                         REQ_TERM = YES
                         TOT_CUMULATIVE = YES
                         UTA_UNFN_TYPE = YES
                         UTA_UNFN_UNITS = YES
                         Prior_Enrolled_Term = NO
                         FERPA = YES
                         ADMIT_TERM = YES
                         ADM_APPL_NBR = YES
                         ADM_ADMIT_TERM = YES
                         ADMIT_TYPE = YES
                         RECRUITMENT_CAT = YES
                         ARTICULATION_TERM = NO
                         CRSE_ATTR_LIST = YES
                         CRSE_VAL_LIST = YES
                         CLASS_ATTR_LIST = YES
                         CLASS_VAL_LIST = YES
                         CORE_COURSE = YES
                         GDR_Indicator = YES
                         EXC_FLAG = YES
                         DVLP_FLAG = YES
                         FLAG_3PEAT = YES
                         PHYED_CNT_FLG = YES
                         Unfunded_Flag = YES
                         AP_Student = YES
                         AP_Course = YES
                         DLRN_Student = YES
                         DLRN_Course = YES
                         CB_Reported_Student = YES
                         CB_Reported_Course = YES
                         Current_Semester_Reportable = YES
                         Prior_Crse_Transfer = YES
                         Current_Term = YES
                         PRE1998 = YES));
         attrib Record_Code length = $1
            format = $1.
            informat = $1.
            label = 'Record_Code'; 
         attrib College_Code length = $6
            format = $6.
            informat = $6.
            label = 'College_Code'; 
         attrib STRM length = $4
            format = $4.
            informat = $4.
            label = 'STRM'; 
         attrib EMPLID length = $10
            format = $10.
            informat = $10.
            label = 'EMPLID'; 
         attrib National_Id length = $9
            format = $9.
            informat = $9.
            label = 'National_Id'; 
         attrib SUBJECT length = $7
            format = $7.
            informat = $7.
            label = 'SUBJECT'; 
         attrib CATALOG_NBR length = $7
            format = $7.
            informat = $7.
            label = 'CATALOG_NBR'; 
         attrib CLASS_NBR length = $7
            format = $7.
            informat = $7.
            label = 'CLASS_NBR'; 
         attrib Instruction_Type length = $1
            format = $1.
            informat = $1.
            label = 'Instruction_Type'; 
         attrib Student_Classification_Desc length = $20
            format = $20.
            informat = $20.
            label = 'Student_Classification_Desc'; 
         attrib Student_Classification length = $1
            format = $1.
            informat = $1.
            label = 'Student_Classification'; 
         attrib Non_Disclosure length = $1
            format = $1.
            informat = $1.
            label = 'Non_Disclosure'; 
         attrib SCH_Value length = $4
            format = $4.
            informat = $4.
            label = 'SCH_Value'; 
         attrib SCH_State_Funded length = $4
            format = $4.
            informat = $4.
            label = 'SCH_State_Funded'; 
         attrib SCH_Not_State_Funded length = $4
            format = $4.
            informat = $4.
            label = 'SCH_Not_State_Funded'; 
         attrib Grad_12H length = $1
            format = $1.
            informat = $1.
            label = 'Grad_12H'; 
         attrib Location_Code length = $1
            format = $1.
            informat = $1.
            label = 'Location_Code'; 
         attrib Other_Higher_Ed_Site length = $6
            format = $6.
            informat = $6.
            label = 'Other_Higher_Ed_Site'; 
         attrib Instruction_Mode length = $1
            format = $1.
            informat = $1.
            label = 'Instruction_Mode'; 
         attrib SCH_Not_Funded_Reason length = $1
            format = $1.
            informat = $1.
            label = 'SCH_Not_Funded_Reason'; 
         attrib HighSchool_Credit length = $1
            format = $1.
            informat = $1.
            label = 'HighSchool_Credit'; 
         attrib Developmental_Education length = $1
            format = $1.
            informat = $1.
            label = 'Developmental_Education'; 
         attrib First_College_Level_Course length = $1
            format = $1.
            informat = $1.
            label = 'First_College_Level_Course'; 
         attrib Course_Grade length = $1
            format = $1.
            informat = $1.
            label = 'Course_Grade'; 
         attrib Grade_Value length = $3
            format = $3.
            informat = $3.
            label = 'Grade_Value'; 
         attrib Composite_Class_Code length = $2
            format = $2.
            informat = $2.
            label = 'Composite_Class_Code'; 
         attrib Off_Campus_Location length = $5
            format = $5.
            informat = $5.
            label = 'Off_Campus_Location'; 
         attrib Flex_entry length = $1
            format = $1.
            informat = $1.
            label = 'Flex_entry'; 
         attrib Inter_Institution_Identifier length = $1
            format = $1.
            informat = $1.
            label = 'Inter_Institution_Identifier'; 
         attrib Semester length = $1
            format = $1.
            informat = $1.
            label = 'Semester'; 
         attrib Year length = $4
            format = $4.
            informat = $4.
            label = 'Year'; 
         attrib START_DT length = $8
            format = $8.
            informat = $8.
            label = 'START_DT'; 
         attrib END_DT length = $8
            format = $8.
            informat = $8.
            label = 'END_DT'; 
         attrib CRSE_ID length = $6
            format = $6.
            informat = $6.
            label = 'CRSE_ID'; 
         attrib CRSE_OFFER_NBR length = 8
            label = 'CRSE_OFFER_NBR'; 
         attrib CLASS_TYPE length = $1
            format = $1.
            informat = $1.
            label = 'CLASS_TYPE'; 
         attrib ACAD_CAREER length = $4
            format = $4.
            informat = $4.
            label = 'ACAD_CAREER'; 
         attrib ACAD_PROG length = $5
            format = $5.
            informat = $5.
            label = 'ACAD_PROG'; 
         attrib ACAD_GROUP length = $5
            format = $5.
            informat = $5.
            label = 'ACAD_GROUP'; 
         attrib ACAD_ORG length = $10
            format = $10.
            informat = $10.
            label = 'ACAD_ORG'; 
         attrib CAMPUS length = $5
            format = $5.
            informat = $5.
            label = 'CAMPUS'; 
         attrib STDNT_CAR_NBR length = 8
            label = 'STDNT_CAR_NBR'; 
         attrib ACAD_PLAN length = $10
            format = $10.
            informat = $10.
            label = 'ACAD_PLAN'; 
         attrib ACAD_LEVEL_BOT length = $3
            format = $3.
            informat = $3.
            label = 'ACAD_LEVEL_BOT'; 
         attrib ACAD_LEVEL_EOT length = $3
            format = $3.
            informat = $3.
            label = 'ACAD_LEVEL_EOT'; 
         attrib DEGR_CHKOUT_STAT length = $2
            format = $2.
            informat = $2.
            label = 'DEGR_CHKOUT_STAT'; 
         attrib MIN_UNITS_REQD length = 8
            format = 8.2
            informat = 8.2
            label = 'MIN_UNITS_REQD'; 
         attrib LOCATION length = $10
            format = $10.
            informat = $10.
            label = 'LOCATION'; 
         attrib TERM_BEGIN_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'TERM_BEGIN_DT'; 
         attrib TERM_END_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'TERM_END_DT'; 
         attrib CENSUS_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'CENSUS_DT'; 
         attrib CB_Exclude length = $8
            label = 'CB_Exclude'; 
         attrib ENRL_TOT length = 8
            label = 'ENRL_TOT'; 
         attrib COMPONENT_PRIMARY length = $3
            format = $3.
            informat = $3.
            label = 'COMPONENT_PRIMARY'; 
         attrib SESSION_CODE length = $3
            format = $3.
            informat = $3.
            label = 'SESSION_CODE'; 
         attrib Current_Term_End_date length = 8
            format = Datetime20.
            informat = DATETIME20.
            label = 'Current_Term_End_date'; 
         attrib CRSE_GRADE_OFF length = $3
            format = $3.
            informat = $3.
            label = 'CRSE_GRADE_OFF'; 
         attrib UNT_PRGRSS length = 8
            format = 8.2
            informat = 8.2
            label = 'UNT_PRGRSS'; 
         attrib UNT_EARNED length = 8
            format = 8.2
            informat = 8.2
            label = 'UNT_EARNED'; 
         attrib UNT_TAKEN_SEM length = 8
            format = 8.2
            informat = 8.2
            label = 'UNT_TAKEN_SEM'; 
         attrib UNT_TAKEN length = 8
            format = 8.2
            informat = 8.2
            label = 'UNT_TAKEN'; 
         attrib REQ_TERM length = $4
            format = $4.
            informat = $4.
            label = 'REQ_TERM'; 
         attrib TOT_CUMULATIVE length = 8
            format = 11.3
            informat = 11.3
            label = 'TOT_CUMULATIVE'; 
         attrib UTA_UNFN_TYPE length = $1
            format = $1.
            informat = $1.
            label = 'UTA_UNFN_TYPE'; 
         attrib UTA_UNFN_UNITS length = 8
            label = 'UTA_UNFN_UNITS'; 
         attrib Prior_Enrolled_Term length = $4
            format = $4.
            informat = $4.
            label = 'Prior_Enrolled_Term'; 
         attrib FERPA length = $1
            format = $1.
            informat = $1.
            label = 'FERPA'; 
         attrib ADMIT_TERM length = $4
            format = $4.
            informat = $4.
            label = 'ADMIT_TERM'; 
         attrib ADM_APPL_NBR length = $8
            format = $8.
            informat = $8.
            label = 'ADM_APPL_NBR'; 
         attrib ADM_ADMIT_TERM length = $4
            format = $4.
            informat = $4.
            label = 'ADM_ADMIT_TERM'; 
         attrib ADMIT_TYPE length = $3
            format = $3.
            informat = $3.
            label = 'ADMIT_TYPE'; 
         attrib RECRUITMENT_CAT length = $4
            format = $4.
            informat = $4.
            label = 'RECRUITMENT_CAT'; 
         attrib ARTICULATION_TERM length = $4
            format = $4.
            informat = $4.
            label = 'ARTICULATION_TERM'; 
         attrib CRSE_ATTR_LIST length = $50
            label = 'CRSE_ATTR_LIST'; 
         attrib CRSE_VAL_LIST length = $50
            label = 'CRSE_VAL_LIST'; 
         attrib CLASS_ATTR_LIST length = $50
            label = 'CLASS_ATTR_LIST'; 
         attrib CLASS_VAL_LIST length = $100
            label = 'CLASS_VAL_LIST'; 
         attrib CORE_COURSE length = $8
            label = 'CORE_COURSE'; 
         attrib GDR_Indicator length = $8
            label = 'GDR_Indicator'; 
         attrib EXC_FLAG length = $8
            label = 'EXC_FLAG'; 
         attrib DVLP_FLAG length = $8
            label = 'DVLP_FLAG'; 
         attrib FLAG_3PEAT length = $8
            label = 'FLAG_3PEAT'; 
         attrib PHYED_CNT_FLG length = $8
            label = 'PHYED_CNT_FLG'; 
         attrib Unfunded_Flag length = $8
            label = 'Unfunded_Flag'; 
         attrib AP_Student length = $8
            label = 'AP_Student'; 
         attrib AP_Course length = $1
            label = 'AP_Course'; 
         attrib DLRN_Student length = $8
            label = 'Distance Learning Student'; 
         attrib DLRN_Course length = $1
            label = 'DLRN_Course'; 
         attrib CB_Reported_Student length = $1
            label = 'CB_Reported_Student'; 
         attrib CB_Reported_Course length = $1
            label = 'CB_Reported_Course'; 
         attrib Current_Semester_Reportable length = $8
            label = 'Current_Semester_Reportable'; 
         attrib Prior_Crse_Transfer length = $8
            label = 'Prior_Crse_Transfer'; 
         attrib Current_Term length = $4
            format = $4.
            informat = $4.
            label = 'Current_Term'; 
         attrib PRE1998 length = $8
            label = 'PRE1998'; 
         call missing(of _all_);
         stop;
      run;
      
      %rcSet(&syserr); 
      
   %end;  /* if table does not exist  */ 
   
   %else 
   %do;  /* table exists */ 
      /*---- Truncate a table  ----*/ 
      %put %str(NOTE: Truncating table ...);
      proc sql;
         connect to ORACLE
         ( 
             DEFER=YES DBSERVER_MAX_BYTES=1 DBCLIENT_MAX_BYTES=1 ADJUST_BYTE_SEMANTIC_COLUMN_LENGTHS=YES DB_LENGTH_SEMANTICS_BYTE=YES DBSERVER_ENCODING_FIXED=YES DBCLIENT_ENCODING_FIXED=YES PATH=UTAAWSPD AUTHDOMAIN="ADWTGTPRD" 
         ); 
         reset noprint; 
         
         execute 
         ( 
            truncate table ADWTGTPRD.ADW_CBM00S_WORK
         ) by ORACLE; 
         
         %rcSet(&sqlrc); 
         
         disconnect from ORACLE; 
      quit; 
      
      %rcSet(&sqlrc); 
      
   %end; /* table exists */ 
   
   /*---- Append  ----*/ 
   %put %str(NOTE: Appending data ...);
   
   proc append base = ADWTGTPR.ADW_CBM00S_WORK 
      data = &etls_lastTable (&etls_tableOptions)  force ; 
    run; 
   
   %rcSet(&syserr); 
   
   proc datasets lib = work nolist nowarn memtype = (data view);
      delete WTOBWUL;
   quit;
   
%mend etls_loader;
%etls_loader;

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWTGTPR.ADW_CBM00S_WORK, DATA)) or 
         %sysfunc(exist(ADWTGTPR.ADW_CBM00S_WORK, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWTGTPR.ADW_CBM00S_WORK;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Table Loader **/

/*==========================================================================* 
 * Step:            CB Reported                           A5B29B8Q.BZ000A1V * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    ADW_CBM00S_WORK -                     A5B29B8Q.BE00017F * 
 *                   ADWTGTPR.ADW_CBM00S_WORK                               * 
 * Target Table:    CBM00S_CBReported -                   A5B29B8Q.BS0003CR * 
 *                   work.CBM00S_CBReported                                 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1V);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWTGTPR.ADW_CBM00S_WORK, DATA)) or 
         %sysfunc(exist(ADWTGTPR.ADW_CBM00S_WORK, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWTGTPR.ADW_CBM00S_WORK;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(ADWTGTPR.ADW_CBM00S_WORK); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM00S_CBReported;
quit;

proc sql;
   create view work.CBM00S_CBReported as
   select
      ADW_CBM00S_WORK.Record_Code length = 1   
         format = $1.
         informat = $1.
         label = 'Record_Code',
      ADW_CBM00S_WORK.College_Code length = 6   
         format = $6.
         informat = $6.
         label = 'College_Code',
      ADW_CBM00S_WORK.National_Id length = 9   
         format = $9.
         informat = $9.
         label = 'National_Id',
      ADW_CBM00S_WORK.SUBJECT length = 7   
         format = $7.
         informat = $7.
         label = 'SUBJECT',
      ADW_CBM00S_WORK.CATALOG_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CATALOG_NBR',
      ADW_CBM00S_WORK.CLASS_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CLASS_NBR',
      ADW_CBM00S_WORK.Instruction_Type length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Type',
      ADW_CBM00S_WORK.Student_Classification length = 1   
         format = $1.
         informat = $1.
         label = 'Student_Classification',
      ADW_CBM00S_WORK.Non_Disclosure length = 1   
         format = $1.
         informat = $1.
         label = 'Non_Disclosure',
      ADW_CBM00S_WORK.SCH_Value length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_Value',
      ADW_CBM00S_WORK.SCH_State_Funded length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_State_Funded',
      ADW_CBM00S_WORK.SCH_Not_State_Funded length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_Not_State_Funded',
      ADW_CBM00S_WORK.Grad_12H length = 1   
         format = $1.
         informat = $1.
         label = 'Grad_12H',
      ADW_CBM00S_WORK.Location_Code length = 1   
         format = $1.
         informat = $1.
         label = 'Location_Code',
      ADW_CBM00S_WORK.Other_Higher_Ed_Site length = 6   
         format = $6.
         informat = $6.
         label = 'Other_Higher_Ed_Site',
      ADW_CBM00S_WORK.Instruction_Mode length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Mode',
      ADW_CBM00S_WORK.SCH_Not_Funded_Reason length = 1   
         format = $1.
         informat = $1.
         label = 'SCH_Not_Funded_Reason',
      ADW_CBM00S_WORK.HighSchool_Credit length = 1   
         format = $1.
         informat = $1.
         label = 'HighSchool_Credit',
      ADW_CBM00S_WORK.Developmental_Education length = 1   
         format = $1.
         informat = $1.
         label = 'Developmental_Education',
      ADW_CBM00S_WORK.First_College_Level_Course length = 1   
         format = $1.
         informat = $1.
         label = 'First_College_Level_Course',
      ADW_CBM00S_WORK.Course_Grade length = 1   
         format = $1.
         informat = $1.
         label = 'Course_Grade',
      ADW_CBM00S_WORK.Grade_Value length = 3   
         format = $3.
         informat = $3.
         label = 'Grade_Value',
      ADW_CBM00S_WORK.Composite_Class_Code length = 2   
         format = $2.
         informat = $2.
         label = 'Composite_Class_Code',
      ADW_CBM00S_WORK.Off_Campus_Location length = 5   
         format = $5.
         informat = $5.
         label = 'Off_Campus_Location',
      ADW_CBM00S_WORK.Flex_entry length = 1   
         format = $1.
         informat = $1.
         label = 'Flex_entry',
      ADW_CBM00S_WORK.Inter_Institution_Identifier length = 1   
         format = $1.
         informat = $1.
         label = 'Inter_Institution_Identifier',
      ADW_CBM00S_WORK.Semester length = 1   
         format = $1.
         informat = $1.
         label = 'Semester',
      ADW_CBM00S_WORK.Year length = 4   
         format = $4.
         informat = $4.
         label = 'Year',
      ADW_CBM00S_WORK.START_DT length = 8   
         format = $8.
         informat = $8.
         label = 'START_DT',
      ADW_CBM00S_WORK.END_DT length = 8   
         format = $8.
         informat = $8.
         label = 'END_DT'
   from
      ADWTGTPR.ADW_CBM00S_WORK as ADW_CBM00S_WORK
   where
      ADW_CBM00S_WORK.CB_Reported_Student = 'Y'
      and ADW_CBM00S_WORK.CB_Reported_Course = 'Y'
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end CB Reported **/

/*==========================================================================* 
 * Step:            File Writer                           A5B29B8Q.BZ000A1W * 
 * Transform:       File Writer                                             * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM00S_CBReported -                   A5B29B8Q.BS0003CR * 
 *                   work.CBM00S_CBReported                                 * 
 * Target Table:    CBM00S_SNP - &CBM00SOutputFileLoc.    A5B29B8Q.BV00001A * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1W);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

/* Parameter default value(s) for File Writer  */ 
%let CBM00SOutputTerm = ;

%let etls_recnt = -1;
%let SYSLAST = %nrquote(work.CBM00S_CBReported); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|FileWriter), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%let ETLS_SYSLAST = &SYSLAST;
/*---- Start of Pre-Process Code  ----*/ 

%let CBM00SOutputFileLoc =/sasdata/Data/CBM/CBM00S/CBM00S_&current_term._&sysdate9..txt;

data _null_; 
   set &SYSLAST; 
   file "&CBM00SOutputFileLoc." ;
   if _n_=1 then put 'HY2K003656CBM00S' @@ Semester $1. @@ Year $4. @@ 'C0099JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU';
run;
/*---- End of Pre-Process Code  ----*/ 

%rcSet(&syserr); 
%rcSet(&sqlrc); 

%let SYSLAST = &ETLS_SYSLAST;

data _null_; 
   set &SYSLAST; 
      attrib Record_Code length = $1
         format = $1.
         informat = $1.; 
      attrib College_Code length = $6
         format = $6.
         informat = $6.; 
      attrib National_Id length = $9
         format = $9.
         informat = $9.; 
      attrib SUBJECT length = $7
         format = $7.
         informat = $7.; 
      attrib CATALOG_NBR length = $7
         format = $7.
         informat = $7.; 
      attrib CLASS_NBR length = $7
         format = $7.
         informat = $7.; 
      attrib Instruction_Type length = $1
         format = $1.
         informat = $1.; 
      attrib Student_Classification length = $1
         format = $1.
         informat = $1.; 
      attrib Non_Disclosure length = $1
         format = $1.
         informat = $1.; 
      attrib SCH_Value length = $4
         format = $4.
         informat = $4.; 
      attrib SCH_State_Funded length = $4
         format = $4.
         informat = $4.; 
      attrib SCH_Not_State_Funded length = $4
         format = $4.
         informat = $4.; 
      attrib Grad_12H length = $1
         format = $1.
         informat = $1.; 
      attrib Location_Code length = $1
         format = $1.
         informat = $1.; 
      attrib Other_Higher_Ed_Site length = $6
         format = $6.
         informat = $6.; 
      attrib Instruction_Mode length = $1
         format = $1.
         informat = $1.; 
      attrib SCH_Not_Funded_Reason length = $1
         format = $1.
         informat = $1.; 
      attrib HighSchool_Credit length = $1
         format = $1.
         informat = $1.; 
      attrib Developmental_Education length = $1
         format = $1.
         informat = $1.; 
      attrib First_College_Level_Course length = $1
         format = $1.
         informat = $1.; 
      attrib Course_Grade length = $1
         format = $1.
         informat = $1.; 
      attrib Grade_Value length = $3
         format = $3.
         informat = $3.; 
      attrib Composite_Class_Code length = $2
         format = $2.
         informat = $2.; 
      attrib Off_Campus_Location length = $5
         format = $5.
         informat = $5.; 
      attrib Flex_entry length = $1
         format = $1.
         informat = $1.; 
      attrib Inter_Institution_Identifier length = $1
         format = $1.
         informat = $1.; 
      attrib Semester length = $1
         format = $1.
         informat = $1.; 
      attrib Year length = $4
         format = $4.
         informat = $4.; 
      attrib START_DT length = $8
         format = $8.
         informat = $8.; 
      attrib END_DT length = $8
         format = $8.
         informat = $8.; 
      file "&CBM00SOutputFileLoc." MOD;
      
         put 
             @ 1 Record_Code $1. 
             @ 2 College_Code $6. 
             @ 8 National_Id $9. 
             @ 17 SUBJECT $7. 
             @ 24 CATALOG_NBR $7. 
             @ 31 CLASS_NBR $7. 
             @ 38 Instruction_Type $1. 
             @ 39 Student_Classification $1. 
             @ 40 Non_Disclosure $1. 
             @ 41 SCH_Value $4. 
             @ 45 SCH_State_Funded $4. 
             @ 49 SCH_Not_State_Funded $4. 
             @ 53 Grad_12H $1. 
             @ 54 Location_Code $1. 
             @ 55 Other_Higher_Ed_Site $6. 
             @ 61 Instruction_Mode $1. 
             @ 62 SCH_Not_Funded_Reason $1. 
             @ 63 HighSchool_Credit $1. 
             @ 64 Developmental_Education $1. 
             @ 65 First_College_Level_Course $1. 
             @ 66 Course_Grade $1. 
             @ 67 Grade_Value $3. 
             @ 70 Composite_Class_Code $2. 
             @ 72 Off_Campus_Location $5. 
             @ 77 Flex_entry $1. 
             @ 78 Inter_Institution_Identifier $1. 
             @ 79 Semester $1. 
             @ 80 Year $4. 
             @ 84 START_DT $8. 
             @ 92 END_DT $8. 
         ;
   
run; 

%rcSet(&syserr); 

/*---- Start of Post-Process Code  ----*/ 

data _null_; 
   set &SYSLAST END=EOF; 
   file "&CBM00SOutputFileLoc." mod;
   if eof then put @1 'EOF1' @@ _N_ z6. @@;      
run;
/*---- End of Post-Process Code  ----*/ 

%rcSet(&syserr); 
%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end File Writer **/

/*==========================================================================* 
 * Step:            SCHBuckets                            A5B29B8Q.BZ000A1X * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   ADW_CBM00S_WORK -                     A5B29B8Q.BE00017F * 
 *                   ADWTGTPR.ADW_CBM00S_WORK                               * 
 *                  UTA_CB_CRSE_INVENTORY -               A5B29B8Q.BE0001E3 * 
 *                   CBMPRD.UTA_CB_CRSE_INVENTORY                           * 
 * Target Table:    SCHBuckets - work.SCHBuckets          A5B29B8Q.BS0003CS * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1X);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWTGTPR.ADW_CBM00S_WORK, DATA)) or 
         %sysfunc(exist(ADWTGTPR.ADW_CBM00S_WORK, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWTGTPR.ADW_CBM00S_WORK;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete SCHBuckets;
quit;

proc sql;
   create table work.SCHBuckets as
   select distinct
      ADW_CBM00S_WORK.Record_Code length = 1   
         format = $1.
         informat = $1.
         label = 'Record_Code',
      ADW_CBM00S_WORK.College_Code length = 6   
         format = $6.
         informat = $6.
         label = 'College_Code',
      ADW_CBM00S_WORK.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_CBM00S_WORK.EMPLID length = 10   
         format = $10.
         informat = $10.
         label = 'EMPLID',
      ADW_CBM00S_WORK.National_Id length = 9   
         format = $9.
         informat = $9.
         label = 'National_Id',
      ADW_CBM00S_WORK.SUBJECT length = 7   
         format = $7.
         informat = $7.
         label = 'SUBJECT',
      ADW_CBM00S_WORK.CATALOG_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CATALOG_NBR',
      ADW_CBM00S_WORK.CLASS_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CLASS_NBR',
      ADW_CBM00S_WORK.Instruction_Type length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Type',
      ADW_CBM00S_WORK.Student_Classification_Desc length = 20   
         format = $20.
         informat = $20.
         label = 'Student_Classification_Desc',
      ADW_CBM00S_WORK.Student_Classification length = 1   
         format = $1.
         informat = $1.
         label = 'Student_Classification',
      ADW_CBM00S_WORK.Non_Disclosure length = 1   
         format = $1.
         informat = $1.
         label = 'Non_Disclosure',
      ADW_CBM00S_WORK.SCH_Value length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_Value',
      ADW_CBM00S_WORK.SCH_State_Funded length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_State_Funded',
      ADW_CBM00S_WORK.SCH_Not_State_Funded length = 4   
         format = $4.
         informat = $4.
         label = 'SCH_Not_State_Funded',
      ADW_CBM00S_WORK.Grad_12H length = 1   
         format = $1.
         informat = $1.
         label = 'Grad_12H',
      ADW_CBM00S_WORK.Location_Code length = 1   
         format = $1.
         informat = $1.
         label = 'Location_Code',
      ADW_CBM00S_WORK.Other_Higher_Ed_Site length = 6   
         format = $6.
         informat = $6.
         label = 'Other_Higher_Ed_Site',
      ADW_CBM00S_WORK.Instruction_Mode length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Mode',
      ADW_CBM00S_WORK.SCH_Not_Funded_Reason length = 1   
         format = $1.
         informat = $1.
         label = 'SCH_Not_Funded_Reason',
      ADW_CBM00S_WORK.HighSchool_Credit length = 1   
         format = $1.
         informat = $1.
         label = 'HighSchool_Credit',
      ADW_CBM00S_WORK.Developmental_Education length = 1   
         format = $1.
         informat = $1.
         label = 'Developmental_Education',
      ADW_CBM00S_WORK.First_College_Level_Course length = 1   
         format = $1.
         informat = $1.
         label = 'First_College_Level_Course',
      ADW_CBM00S_WORK.Course_Grade length = 1   
         format = $1.
         informat = $1.
         label = 'Course_Grade',
      ADW_CBM00S_WORK.Grade_Value length = 3   
         format = $3.
         informat = $3.
         label = 'Grade_Value',
      ADW_CBM00S_WORK.Composite_Class_Code length = 2   
         format = $2.
         informat = $2.
         label = 'Composite_Class_Code',
      ADW_CBM00S_WORK.Off_Campus_Location length = 5   
         format = $5.
         informat = $5.
         label = 'Off_Campus_Location',
      ADW_CBM00S_WORK.Flex_entry length = 1   
         format = $1.
         informat = $1.
         label = 'Flex_entry',
      ADW_CBM00S_WORK.Inter_Institution_Identifier length = 1   
         format = $1.
         informat = $1.
         label = 'Inter_Institution_Identifier',
      ADW_CBM00S_WORK.Semester length = 1   
         format = $1.
         informat = $1.
         label = 'Semester',
      ADW_CBM00S_WORK.Year length = 4   
         format = $4.
         informat = $4.
         label = 'Year',
      ADW_CBM00S_WORK.START_DT length = 8   
         format = $8.
         informat = $8.
         label = 'START_DT',
      ADW_CBM00S_WORK.END_DT length = 8   
         format = $8.
         informat = $8.
         label = 'END_DT',
      ADW_CBM00S_WORK.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      ADW_CBM00S_WORK.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      ADW_CBM00S_WORK.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      ADW_CBM00S_WORK.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      ADW_CBM00S_WORK.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      ADW_CBM00S_WORK.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      ADW_CBM00S_WORK.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      ADW_CBM00S_WORK.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      ADW_CBM00S_WORK.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      ADW_CBM00S_WORK.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      ADW_CBM00S_WORK.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      ADW_CBM00S_WORK.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      ADW_CBM00S_WORK.MIN_UNITS_REQD length = 8   
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      ADW_CBM00S_WORK.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      ADW_CBM00S_WORK.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      ADW_CBM00S_WORK.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADW_CBM00S_WORK.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      ADW_CBM00S_WORK.CB_Exclude length = 8   
         label = 'CB_Exclude',
      ADW_CBM00S_WORK.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      ADW_CBM00S_WORK.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      ADW_CBM00S_WORK.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      ADW_CBM00S_WORK.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      ADW_CBM00S_WORK.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      ADW_CBM00S_WORK.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      ADW_CBM00S_WORK.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      ADW_CBM00S_WORK.UNT_TAKEN_SEM length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN_SEM',
      ADW_CBM00S_WORK.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      ADW_CBM00S_WORK.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      ADW_CBM00S_WORK.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      ADW_CBM00S_WORK.UTA_UNFN_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_UNFN_TYPE',
      ADW_CBM00S_WORK.UTA_UNFN_UNITS length = 8   
         label = 'UTA_UNFN_UNITS',
      ADW_CBM00S_WORK.Prior_Enrolled_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Prior_Enrolled_Term',
      ADW_CBM00S_WORK.FERPA length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA',
      ADW_CBM00S_WORK.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      ADW_CBM00S_WORK.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      ADW_CBM00S_WORK.ADM_ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADM_ADMIT_TERM',
      ADW_CBM00S_WORK.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      ADW_CBM00S_WORK.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      ADW_CBM00S_WORK.ARTICULATION_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ARTICULATION_TERM',
      ADW_CBM00S_WORK.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      ADW_CBM00S_WORK.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      ADW_CBM00S_WORK.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      ADW_CBM00S_WORK.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      ADW_CBM00S_WORK.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      ADW_CBM00S_WORK.GDR_Indicator length = 8   
         label = 'GDR_Indicator',
      ADW_CBM00S_WORK.EXC_FLAG length = 8   
         label = 'EXC_FLAG',
      ADW_CBM00S_WORK.DVLP_FLAG length = 8   
         label = 'DVLP_FLAG',
      ADW_CBM00S_WORK.FLAG_3PEAT length = 8   
         label = 'FLAG_3PEAT',
      ADW_CBM00S_WORK.PHYED_CNT_FLG length = 8   
         label = 'PHYED_CNT_FLG',
      ADW_CBM00S_WORK.Unfunded_Flag length = 8   
         label = 'Unfunded_Flag',
      ADW_CBM00S_WORK.AP_Student length = 8   
         label = 'AP_Student',
      ADW_CBM00S_WORK.AP_Course length = 1   
         label = 'AP_Course',
      ADW_CBM00S_WORK.DLRN_Course length = 1   
         label = 'DLRN_Course',
      ADW_CBM00S_WORK.DLRN_Student length = 8   
         label = 'Distance Learning Student',
      ADW_CBM00S_WORK.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      ADW_CBM00S_WORK.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      ADW_CBM00S_WORK.Current_Semester_Reportable length = 8   
         label = 'Current_Semester_Reportable',
      ADW_CBM00S_WORK.Prior_Crse_Transfer length = 8   
         label = 'Prior_Crse_Transfer',
      ADW_CBM00S_WORK.Current_Term length = 4   
         format = $4.
         informat = $4.
         label = 'Current_Term',
      UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE length = 10   
         format = $10.
         informat = $10.
         label = 'CIP_OR_FUND_CODE',
      UTA_CB_CRSE_INVENTORY.COURSE_SCH length = 40   
         format = $40.
         informat = $40.
         label = 'COURSE_SCH',
      UTA_CB_CRSE_INVENTORY.COURSE_LEVEL length = 40   
         format = $40.
         informat = $40.
         label = 'COURSE_LEVEL',
      UTA_CB_CRSE_INVENTORY.FUND_YEAR length = 9   
         format = $9.
         informat = $9.
         label = 'FUND_YEAR',
      UTA_CB_CRSE_INVENTORY.FORMULA_CODE length = 8   
         format = 4.
         informat = 4.
         label = 'FORMULA_CODE',
      IFN( ADW_CBM00S_WORK.CB_Reported_Student ='Y' & ADW_CBM00S_WORK.CB_Reported_Course ='Y' & ADW_CBM00S_WORK.EXC_FLAG='No' ,
              IFN((ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' |  ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |    
                     SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)='99' )  ,INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
              IFN((ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes'
                     | ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)='99'), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)
      ) as UNFUNDED_SCH_TOTAL length = 8   
         label = 'UNFUNDED_SCH_TOTAL',
      IFN( ADW_CBM00S_WORK.CB_Reported_Student ='Y' & ADW_CBM00S_WORK.CB_Reported_Course ='Y',
      
                    IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT = 'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes')
                            & (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('1','2') | ADW_CBM00S_WORK.Student_Classification IN ('1','2')) ,INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
                     IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT ='Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |
                              ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N' ) 
      	& ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing &  input(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL,8.) <=2)
      	| (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & INPUT(SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1),8.)<=2)),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)     
       ) as LOWER_LEVEL_EXCEED_STATE length = 8   
         label = 'LOWER_LEVEL_EXCEED_STATE',
      0 as LOWER_LEVEL_EXCEED_DEVELOP length = 8   
         label = 'LOWER_LEVEL_EXCEED_DEVELOP',
      IFN( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' 
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0, 
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)='99' &  
      (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('1','2') | ADW_CBM00S_WORK.Student_Classification IN ('1','2')), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)) as NOT_STATE_FUNDED_LOWER length = 8   
         label = 'NOT_STATE_FUNDED_LOWER',
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0,  
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)='99' &   
      ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4') &   ADW_CBM00S_WORK.Student_Classification NOT IN ('1','2'))  
       | (ADW_CBM00S_WORK.Student_Classification IN ('3','4','5') & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL NOT IN ('1','2') 
         & (ADW_CBM00S_WORK.Grad_12H ='0' | (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='Y')))), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)) as NOT_STATE_FUNDED_UPPER length = 8   
         label = 'NOT_STATE_FUNDED_UPPER',
      SUM(
      
      IFN( ADW_CBM00S_WORK.CB_Reported_Student ='Y' & ADW_CBM00S_WORK.CB_Reported_Course ='Y',
      
                    IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT = 'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes')
                            & (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('1','2') | ADW_CBM00S_WORK.Student_Classification IN ('1','2')) ,INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
                     IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT ='Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |
                              ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N' ) 
      	& ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing &  input(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL,8.) <=2)
      	| (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & INPUT(SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1),8.)<=2)),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)     
       ),
      
      IFN( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' 
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0, 
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)='99' &  
      (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('1','2') | ADW_CBM00S_WORK.Student_Classification IN ('1','2')), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
      
      ) as LOWER_LEVEL_UNFUNDED_TOTAL length = 8   
         label = 'LOWER_LEVEL_UNFUNDED_TOTAL',
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0,
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' & 
      (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('1','2') | ADW_CBM00S_WORK.Student_Classification IN ('1','2')), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)) as LOWER_LEVEL_FUNDED length = 8   
         label = 'LOWER_LEVEL_FUNDED',
      SUM(
      
      SUM(
      
      IFN( ADW_CBM00S_WORK.CB_Reported_Student ='Y' & ADW_CBM00S_WORK.CB_Reported_Course ='Y',
      
                    IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT = 'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes')
                            & (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('1','2') | ADW_CBM00S_WORK.Student_Classification IN ('1','2')) ,INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
                     IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT ='Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |
                              ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N' ) 
      	& ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing &  input(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL,8.) <=2)
      	| (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & INPUT(SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1),8.)<=2)),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)     
       ),
      
      IFN( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' 
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0, 
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)='99' &  
      (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('1','2') | ADW_CBM00S_WORK.Student_Classification IN ('1','2')), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
      
      ),
      
      
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0,
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' & 
      (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('1','2') | ADW_CBM00S_WORK.Student_Classification IN ('1','2')), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
      
      ) as LOWER_LEVEL_TOTAL length = 8   
         label = 'LOWER_LEVEL_TOTAL',
      IFN( ADW_CBM00S_WORK.CB_Reported_Student ='Y' & ADW_CBM00S_WORK.CB_Reported_Course ='Y',
      	IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT ='Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes')
      	      &((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4')  & ADW_CBM00S_WORK.Student_Classification NOT IN ('1','2')) | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('5','6')  & ADW_CBM00S_WORK.Student_Classification IN ('3','4')))
      	      &(ADW_CBM00S_WORK.Grad_12H ='0' | (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='Y')),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
      	IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |
      	       ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N' )
      	       & (((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4') )
      	            | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1) IN ('3','4')))),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)
      ) as UPPER_LEVEL_EXCEED_STATE length = 8   
         label = 'UPPER_LEVEL_EXCEED_STATE',
      0 as UPPER_LEVEL_EXCEED_DEVELOP length = 8   
         label = 'UPPER_LEVEL_EXCEED_DEVELOP',
      SUM(
       IFN( ADW_CBM00S_WORK.CB_Reported_Student ='Y' & ADW_CBM00S_WORK.CB_Reported_Course ='Y',
      	IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT ='Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes')
      	      &((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4')  & ADW_CBM00S_WORK.Student_Classification NOT IN ('1','2')) | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('5','6')  & ADW_CBM00S_WORK.Student_Classification IN ('3','4')))
      	      &(ADW_CBM00S_WORK.Grad_12H ='0' | (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='Y')),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
      	IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |
      	       ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N' )
      	       & (((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4') )
      	            | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1) IN ('3','4')))),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)
      ),
      
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0,  
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)='99' &   
      ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4') &   ADW_CBM00S_WORK.Student_Classification NOT IN ('1','2'))  
       | (ADW_CBM00S_WORK.Student_Classification IN ('3','4') & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL NOT IN ('1','2') 
         & (ADW_CBM00S_WORK.Grad_12H ='0' | (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='Y')))), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
         ) as UPPER_LEVEL_UNFUNDED_TOTAL length = 8   
         label = 'UPPER_LEVEL_UNFUNDED_TOTAL',
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' 
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0, 
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' &  
      ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4') &   ADW_CBM00S_WORK.Student_Classification NOT IN ('1','2')) 
       | (ADW_CBM00S_WORK.Student_Classification IN ('3','4') & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL NOT IN ('1','2')
         & (ADW_CBM00S_WORK.Grad_12H ='0'))), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)) as UPPER_LEVEL_FUNDED length = 8   
         label = 'UPPER_LEVEL_FUNDED',
      SUM(
       
      SUM(
       IFN( ADW_CBM00S_WORK.CB_Reported_Student ='Y' & ADW_CBM00S_WORK.CB_Reported_Course ='Y',
      	IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT ='Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes')
      	      &((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4')  & ADW_CBM00S_WORK.Student_Classification NOT IN ('1','2')) | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('5','6')  & ADW_CBM00S_WORK.Student_Classification IN ('3','4')))
      	      &(ADW_CBM00S_WORK.Grad_12H ='0' | (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='Y')),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
      	IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |
      	       ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N' )
      	       & (((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4') )
      	            | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1) IN ('3','4')))),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)
      ),
      
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0,  
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)='99' &   
      ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4') &   ADW_CBM00S_WORK.Student_Classification NOT IN ('1','2'))  
       | (ADW_CBM00S_WORK.Student_Classification IN ('3','4') & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL NOT IN ('1','2') 
         & (ADW_CBM00S_WORK.Grad_12H ='0' | (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='Y')))), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
         )
      ,
      
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' 
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0, 
      IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' &  
      ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('3','4') &   ADW_CBM00S_WORK.Student_Classification NOT IN ('1','2')) 
       | (ADW_CBM00S_WORK.Student_Classification IN ('3','4') & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL NOT IN ('1','2')
         & (ADW_CBM00S_WORK.Grad_12H ='0'))), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
      
      ) as UPPER_LEVEL_TOTAL length = 8   
         label = 'UPPER_LEVEL_TOTAL',
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='Y'  &  ADW_CBM00S_WORK.CB_Reported_Course ='Y' ,
      	IFN( (ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG ='Yes' | ADW_CBM00S_WORK.EXC_FLAG='Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes') &
      	        (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL ='5' |(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL = '6' & (ADW_CBM00S_WORK.Student_Classification IN ('5','6')| (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='N')))) ,INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
      	IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |
      	       ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N' )
      	       & (((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL = '5')
      	            | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1) = '5' ))
      		| (((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL = '6')
      	           	 | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1) = '6' )) 
      		& (ADW_CBM00S_WORK.Student_Classification IN ('5','6')| (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='N')))),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)
       ) as MASTER_LEVEL_UNFUNDED length = 8   
         label = 'MASTER_LEVEL_UNFUNDED',
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' 
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0, 
      	IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' &  
      	((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL ='5' &   ADW_CBM00S_WORK.Student_Classification IN ('5','6','7','8'))
      	 | (ADW_CBM00S_WORK.Student_Classification IN ('5','6') & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('6','7','8'))
      	 | ADW_CBM00S_WORK.Grad_12H ='1' ), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)) as MASTER_LEVEL_FUNDED length = 8   
         label = 'MASTER_LEVEL_FUNDED',
      SUM(
      
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='Y'  &  ADW_CBM00S_WORK.CB_Reported_Course ='Y' ,
      	IFN( (ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG ='Yes' | ADW_CBM00S_WORK.EXC_FLAG='Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes') &
      	        (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL ='5' |(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL = '6' & (ADW_CBM00S_WORK.Student_Classification IN ('5','6')| (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='N')))) ,INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
      	IFN(( ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' |
      	       ADW_CBM00S_WORK.CB_Reported_Student ='N' | ADW_CBM00S_WORK.CB_Reported_Course ='N' )
      	       & (((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL = '5')
      	            | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1) = '5' ))
      		| (((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL = '6')
      	           	 | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1) = '6' )) 
      		& (ADW_CBM00S_WORK.Student_Classification IN ('5','6')| (ADW_CBM00S_WORK.Grad_12H ='1' & ADW_CBM00S_WORK.PRE1998 ='N')))),INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)
       )
      
      
      ,
      
      IFN(ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.EXC_FLAG='Yes' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes' 
       |ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | ADW_CBM00S_WORK.PHYED_CNT_FLG =  'Yes'  | ADW_CBM00S_WORK.Unfunded_Flag =  'Yes' ,0, 
      	IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' &  
      	((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL ='5' &   ADW_CBM00S_WORK.Student_Classification IN ('5','6','7','8'))
      	 | (ADW_CBM00S_WORK.Student_Classification IN ('5','6') & UTA_CB_CRSE_INVENTORY.COURSE_LEVEL IN ('6','7','8'))
      	 | ADW_CBM00S_WORK.Grad_12H ='1' ), INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
      
      ) as MASTER_LEVEL_TOTAL length = 8   
         label = 'MASTER_LEVEL_TOTAL',
      IFN((ADW_CBM00S_WORK.CB_Reported_Student ='N'  |  ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  | ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes'  
      | ADW_CBM00S_WORK.PHYED_CNT_FLG = 'Yes' | ADW_CBM00S_WORK.EXC_FLAG='Yes'  |  ADW_CBM00S_WORK.Unfunded_Flag =  'Yes') 
       & ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & input(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL,8.) >5) 
      | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & INPUT(SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1),8.)>5)) & ADW_CBM00S_WORK.Student_Classification IN ('7','8') , INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0) as DOCTORAL_LEVEL_UNFUNDED length = 8   
         label = 'DOCTORAL_LEVEL_UNFUNDED',
      IFN((ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  | ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | 
       ADW_CBM00S_WORK.PHYED_CNT_FLG = 'Yes' | ADW_CBM00S_WORK.EXC_FLAG='Yes'  |  ADW_CBM00S_WORK.Unfunded_Flag =  'Yes'),0, 
      	IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' & input(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL,8.) > 5 
           	 &   ADW_CBM00S_WORK.Student_Classification IN ('7','8') , INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0)) as DOCTORAL_LEVEL_FUNDED length = 8   
         label = 'DOCTORAL_LEVEL_FUNDED',
      /*
      IFN((ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  | ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' |
       ADW_CBM00S_WORK.PHYED_CNT_FLG = 'Yes' | ADW_CBM00S_WORK.EXC_FLAG='Yes'  |  ADW_CBM00S_WORK.Unfunded_Flag =  'Yes'),0,
      	IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' & input(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL,8.) > 5
           	 &   ADW_CBM00S_WORK.Student_Classification IN ('7','8') , INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
      )*/
      
      SUM(
      IFN((ADW_CBM00S_WORK.CB_Reported_Student ='N'  |  ADW_CBM00S_WORK.CB_Reported_Course ='N'  | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  | ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes'  
      | ADW_CBM00S_WORK.PHYED_CNT_FLG = 'Yes' | ADW_CBM00S_WORK.EXC_FLAG='Yes'  |  ADW_CBM00S_WORK.Unfunded_Flag =  'Yes') 
       & ((UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is not missing & input(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL,8.) >5) 
      | (UTA_CB_CRSE_INVENTORY.COURSE_LEVEL is missing & INPUT(SUBSTR(ADW_CBM00S_WORK.CATALOG_NBR ,1,1),8.)>5)) & ADW_CBM00S_WORK.Student_Classification IN ('7','8') , INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0),
      
      IFN((ADW_CBM00S_WORK.CB_Reported_Student ='N'  | ADW_CBM00S_WORK.CB_Reported_Course ='N' | ADW_CBM00S_WORK.DVLP_FLAG = 'Yes'  | ADW_CBM00S_WORK.FLAG_3PEAT =  'Yes' | 
       ADW_CBM00S_WORK.PHYED_CNT_FLG = 'Yes' | ADW_CBM00S_WORK.EXC_FLAG='Yes'  |  ADW_CBM00S_WORK.Unfunded_Flag =  'Yes'),0, 
      	IFN(SUBSTR(UTA_CB_CRSE_INVENTORY.CIP_OR_FUND_CODE,9,2)<>'99' & input(UTA_CB_CRSE_INVENTORY.COURSE_LEVEL,8.) > 5 
           	 &   ADW_CBM00S_WORK.Student_Classification IN ('7','8') , INPUT(ADW_CBM00S_WORK.SCH_Value,BEST12.)/100 ,0))
      ) as DOCTORAL_LEVEL_TOTAL length = 8   
         label = 'DOCTORAL_LEVEL_TOTAL'
   from
      ADWTGTPR.ADW_CBM00S_WORK as ADW_CBM00S_WORK left join 
      CBMPRD.UTA_CB_CRSE_INVENTORY as UTA_CB_CRSE_INVENTORY
         on
         (
            ADW_CBM00S_WORK.SUBJECT = UTA_CB_CRSE_INVENTORY.SUBJECT_CODE
            and ADW_CBM00S_WORK.CATALOG_NBR = UTA_CB_CRSE_INVENTORY.CATALOG_NUMBER
            and ADW_CBM00S_WORK.STRM >= UTA_CB_CRSE_INVENTORY.INVENTORYSTARTTERM
            and ADW_CBM00S_WORK.STRM <= UTA_CB_CRSE_INVENTORY.INVENTORYENDTERM
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end SCHBuckets **/

/*==========================================================================* 
 * Step:            SCHSummary                            A5B29B8Q.BZ000A1Y * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   ADW_DEPT_DIM - ADWTGTPR.ADW_DEPT_DIM  A5B29B8Q.BE000011 * 
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 * 
 *                  SCHBuckets - work.SCHBuckets          A5B29B8Q.BS0003CS * 
 * Target Table:    SCHSummary - work.W1I4UYQN            A5B29B8Q.BS0003CT * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1Y);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWTGTPR.ADW_DEPT_DIM, DATA)) or 
         %sysfunc(exist(ADWTGTPR.ADW_DEPT_DIM, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWTGTPR.ADW_DEPT_DIM;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete W1I4UYQN;
quit;

proc sql;
   create table work.W1I4UYQN as
   select distinct
      SCHBuckets.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_TERM_DIM.DESCR as TermDescription length = 30   
         format = $30.
         informat = $30.
         label = 'TermDescription',
      SCHBuckets.SUBJECT length = 7   
         format = $7.
         informat = $7.
         label = 'SUBJECT',
      SCHBuckets.CATALOG_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CATALOG_NBR',
      SCHBuckets.CLASS_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CLASS_NBR',
      SCHBuckets.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      ADW_DEPT_DIM.COLLEGE_DESCR length = 30   
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      SCHBuckets.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      ADW_DEPT_DIM.DEPT_DESCR length = 30   
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      SCHBuckets.Instruction_Type length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Type',
      SCHBuckets.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      SCHBuckets.AP_Course length = 1   
         label = 'AP_Course',
      SCHBuckets.DLRN_Course length = 1   
         label = 'DLRN_Course',
      SCHBuckets.Flex_entry length = 1   
         format = $1.
         informat = $1.
         label = 'Flex_entry',
      SCHBuckets.CIP_OR_FUND_CODE length = 10   
         format = $10.
         informat = $10.
         label = 'CIP_OR_FUND_CODE',
      SCHBuckets.COURSE_SCH length = 40   
         format = $40.
         informat = $40.
         label = 'COURSE_SCH',
      SCHBuckets.COURSE_LEVEL length = 40   
         format = $40.
         informat = $40.
         label = 'COURSE_LEVEL',
      SCHBuckets.FUND_YEAR length = 9   
         format = $9.
         informat = $9.
         label = 'FUND_YEAR',
      SCHBuckets.FORMULA_CODE length = 8   
         format = 4.
         informat = 4.
         label = 'FORMULA_CODE',
      sum(SCHBuckets.UNFUNDED_SCH_TOTAL) as UNFUNDED_SCH_TOTAL length = 8   
         label = 'UNFUNDED_SCH_TOTAL',
      sum(SCHBuckets.LOWER_LEVEL_EXCEED_STATE) as LOWER_LEVEL_EXCEED_STATE length = 8   
         label = 'LOWER_LEVEL_EXCEED_STATE',
      sum(SCHBuckets.LOWER_LEVEL_EXCEED_DEVELOP) as LOWER_LEVEL_EXCEED_DEVELOP length = 8   
         label = 'LOWER_LEVEL_EXCEED_DEVELOP',
      sum(SCHBuckets.NOT_STATE_FUNDED_LOWER) as NOT_STATE_FUNDED_LOWER length = 8   
         label = 'NOT_STATE_FUNDED_LOWER',
      sum(SCHBuckets.NOT_STATE_FUNDED_UPPER) as NOT_STATE_FUNDED_UPPER length = 8   
         label = 'NOT_STATE_FUNDED_UPPER',
      sum(SCHBuckets.LOWER_LEVEL_UNFUNDED_TOTAL) as LOWER_LEVEL_UNFUNDED_TOTAL length = 8   
         label = 'LOWER_LEVEL_UNFUNDED_TOTAL',
      sum(SCHBuckets.LOWER_LEVEL_FUNDED) as LOWER_LEVEL_FUNDED length = 8   
         label = 'LOWER_LEVEL_FUNDED',
      sum(SCHBuckets.LOWER_LEVEL_TOTAL) as LOWER_LEVEL_TOTAL length = 8   
         label = 'LOWER_LEVEL_TOTAL',
      sum(SCHBuckets.UPPER_LEVEL_EXCEED_STATE) as UPPER_LEVEL_EXCEED_STATE length = 8   
         label = 'UPPER_LEVEL_EXCEED_STATE',
      sum(SCHBuckets.UPPER_LEVEL_EXCEED_DEVELOP) as UPPER_LEVEL_EXCEED_DEVELOP length = 8   
         label = 'UPPER_LEVEL_EXCEED_DEVELOP',
      sum(SCHBuckets.UPPER_LEVEL_UNFUNDED_TOTAL) as UPPER_LEVEL_UNFUNDED_TOTAL length = 8   
         label = 'UPPER_LEVEL_UNFUNDED_TOTAL',
      sum(SCHBuckets.UPPER_LEVEL_FUNDED) as UPPER_LEVEL_FUNDED length = 8   
         label = 'UPPER_LEVEL_FUNDED',
      sum(SCHBuckets.UPPER_LEVEL_TOTAL) as UPPER_LEVEL_TOTAL length = 8   
         label = 'UPPER_LEVEL_TOTAL',
      sum(SCHBuckets.MASTER_LEVEL_UNFUNDED) as MASTER_LEVEL_UNFUNDED length = 8   
         label = 'MASTER_LEVEL_UNFUNDED',
      sum(SCHBuckets.MASTER_LEVEL_FUNDED) as MASTER_LEVEL_FUNDED length = 8   
         label = 'MASTER_LEVEL_FUNDED',
      sum(SCHBuckets.MASTER_LEVEL_TOTAL) as MASTER_LEVEL_TOTAL length = 8   
         label = 'MASTER_LEVEL_TOTAL',
      sum(SCHBuckets.DOCTORAL_LEVEL_UNFUNDED) as DOCTORAL_LEVEL_UNFUNDED length = 8   
         label = 'DOCTORAL_LEVEL_UNFUNDED',
      sum(SCHBuckets.DOCTORAL_LEVEL_FUNDED) as DOCTORAL_LEVEL_FUNDED length = 8   
         label = 'DOCTORAL_LEVEL_FUNDED',
      sum(SCHBuckets.DOCTORAL_LEVEL_TOTAL) as DOCTORAL_LEVEL_TOTAL length = 8   
         label = 'DOCTORAL_LEVEL_TOTAL',
      COUNT(SCHBuckets.EMPLID) * INPUT(SCHBuckets.SCH_Value,best8.)/100 as Total_SCH length = 8   
         label = 'Total_SCH',
      COUNT(SCHBuckets.EMPLID) as Student_Count length = 8   
         label = 'Student_Count',
      SCHBuckets.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      SCHBuckets.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      &current_term_census_date as CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT'
   from
      work.SCHBuckets as SCHBuckets left join 
      ADWTGTPR.ADW_DEPT_DIM as ADW_DEPT_DIM
         on
         (
            SCHBuckets.ACAD_ORG = ADW_DEPT_DIM.DEPT
            and ADW_DEPT_DIM.CURRENT_ROW_ID = 1
         ) left join 
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            SCHBuckets.Current_Term = ADW_TERM_DIM.STRM
            and ADW_TERM_DIM.ACAD_CAREER = 'UGRD'
         )
   group by
      SCHBuckets.CB_Reported_Course,
      SCHBuckets.CB_Reported_Student,
      SCHBuckets.ACAD_ORG,
      SCHBuckets.ACAD_GROUP,
      SCHBuckets.Instruction_Type,
      SCHBuckets.CLASS_NBR,
      SCHBuckets.CATALOG_NBR,
      SCHBuckets.SUBJECT,
      SCHBuckets.STRM
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end SCHSummary **/

/*==========================================================================* 
 * Step:            FTSE                                  A5B29B8Q.BZ000A1Z * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    SCHSummary - work.W1I4UYQN            A5B29B8Q.BS0003CT * 
 * Target Table:    FTSE - work.W1I4UZKY                  A5B29B8Q.BS0003CU * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A1Z);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.W1I4UYQN, DATA)) or 
         %sysfunc(exist(work.W1I4UYQN, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.W1I4UYQN out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(work.W1I4UYQN); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete W1I4UZKY;
quit;

proc sql;
   create table work.W1I4UZKY as
   select
      W1I4UYQN.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      W1I4UYQN.TermDescription length = 30   
         format = $30.
         informat = $30.
         label = 'TermDescription',
      W1I4UYQN.SUBJECT length = 7   
         format = $7.
         informat = $7.
         label = 'SUBJECT',
      W1I4UYQN.CATALOG_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CATALOG_NBR',
      W1I4UYQN.CLASS_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CLASS_NBR',
      W1I4UYQN.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      W1I4UYQN.COLLEGE_DESCR length = 30   
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W1I4UYQN.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      W1I4UYQN.DEPT_DESCR length = 30   
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      W1I4UYQN.Instruction_Type length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Type',
      W1I4UYQN.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      W1I4UYQN.AP_Course length = 1   
         label = 'AP_Course',
      W1I4UYQN.DLRN_Course length = 1   
         label = 'DLRN_Course',
      W1I4UYQN.Flex_entry length = 1   
         format = $1.
         informat = $1.
         label = 'Flex_entry',
      W1I4UYQN.CIP_OR_FUND_CODE length = 10   
         format = $10.
         informat = $10.
         label = 'CIP_OR_FUND_CODE',
      W1I4UYQN.COURSE_SCH length = 40   
         format = $40.
         informat = $40.
         label = 'COURSE_SCH',
      W1I4UYQN.COURSE_LEVEL length = 40   
         format = $40.
         informat = $40.
         label = 'COURSE_LEVEL',
      W1I4UYQN.FUND_YEAR length = 9   
         format = $9.
         informat = $9.
         label = 'FUND_YEAR',
      W1I4UYQN.FORMULA_CODE length = 8   
         format = 4.
         informat = 4.
         label = 'FORMULA_CODE',
      W1I4UYQN.UNFUNDED_SCH_TOTAL length = 8   
         label = 'UNFUNDED_SCH_TOTAL',
      W1I4UYQN.LOWER_LEVEL_EXCEED_STATE length = 8   
         label = 'LOWER_LEVEL_EXCEED_STATE',
      W1I4UYQN.LOWER_LEVEL_EXCEED_DEVELOP length = 8   
         label = 'LOWER_LEVEL_EXCEED_DEVELOP',
      W1I4UYQN.NOT_STATE_FUNDED_LOWER length = 8   
         label = 'NOT_STATE_FUNDED_LOWER',
      W1I4UYQN.NOT_STATE_FUNDED_UPPER length = 8   
         label = 'NOT_STATE_FUNDED_UPPER',
      W1I4UYQN.LOWER_LEVEL_UNFUNDED_TOTAL length = 8   
         label = 'LOWER_LEVEL_UNFUNDED_TOTAL',
      W1I4UYQN.LOWER_LEVEL_FUNDED length = 8   
         label = 'LOWER_LEVEL_FUNDED',
      W1I4UYQN.LOWER_LEVEL_TOTAL length = 8   
         label = 'LOWER_LEVEL_TOTAL',
      W1I4UYQN.UPPER_LEVEL_EXCEED_STATE length = 8   
         label = 'UPPER_LEVEL_EXCEED_STATE',
      W1I4UYQN.UPPER_LEVEL_EXCEED_DEVELOP length = 8   
         label = 'UPPER_LEVEL_EXCEED_DEVELOP',
      W1I4UYQN.UPPER_LEVEL_UNFUNDED_TOTAL length = 8   
         label = 'UPPER_LEVEL_UNFUNDED_TOTAL',
      W1I4UYQN.UPPER_LEVEL_FUNDED length = 8   
         label = 'UPPER_LEVEL_FUNDED',
      W1I4UYQN.UPPER_LEVEL_TOTAL length = 8   
         label = 'UPPER_LEVEL_TOTAL',
      W1I4UYQN.MASTER_LEVEL_UNFUNDED length = 8   
         label = 'MASTER_LEVEL_UNFUNDED',
      W1I4UYQN.MASTER_LEVEL_FUNDED length = 8   
         label = 'MASTER_LEVEL_FUNDED',
      W1I4UYQN.MASTER_LEVEL_TOTAL length = 8   
         label = 'MASTER_LEVEL_TOTAL',
      W1I4UYQN.DOCTORAL_LEVEL_UNFUNDED length = 8   
         label = 'DOCTORAL_LEVEL_UNFUNDED',
      W1I4UYQN.DOCTORAL_LEVEL_FUNDED length = 8   
         label = 'DOCTORAL_LEVEL_FUNDED',
      W1I4UYQN.DOCTORAL_LEVEL_TOTAL length = 8   
         label = 'DOCTORAL_LEVEL_TOTAL',
      W1I4UYQN.Total_SCH length = 8   
         label = 'Total_SCH',
      W1I4UYQN.Student_Count length = 8   
         label = 'Student_Count',
      W1I4UYQN.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      W1I4UYQN.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      SUM(W1I4UYQN.LOWER_LEVEL_TOTAL,W1I4UYQN.UPPER_LEVEL_TOTAL) as UGRD_HRS length = 8   
         label = 'UGRD_HRS',
      IFN( W1I4UYQN.CB_Reported_Course='Y' & W1I4UYQN.CB_Reported_Student ='Y', 
      W1I4UYQN.LOWER_LEVEL_FUNDED /15, 
      W1I4UYQN.LOWER_LEVEL_UNFUNDED_TOTAL /15) as UGRD_LOWER_FTSE length = 8   
         label = 'UGRD_LOWER_FTSE',
      IFN( W1I4UYQN.CB_Reported_Course='Y' & W1I4UYQN.CB_Reported_Student ='Y', 
      W1I4UYQN.UPPER_LEVEL_FUNDED /15,W1I4UYQN.UPPER_LEVEL_UNFUNDED_TOTAL /15) as UGRD_UPPER_FTSE length = 8   
         label = 'UGRD_UPPER_FTSE',
      IFN( W1I4UYQN.CB_Reported_Course='Y' & W1I4UYQN.CB_Reported_Student ='Y', 
      SUM(W1I4UYQN.LOWER_LEVEL_FUNDED , W1I4UYQN.UPPER_LEVEL_FUNDED )/15, 
      SUM(W1I4UYQN.LOWER_LEVEL_UNFUNDED_TOTAL ,W1I4UYQN.UPPER_LEVEL_UNFUNDED_TOTAL )/15) as UGRD_FTSE length = 8   
         label = 'UGRD_FTSE',
      IFN( W1I4UYQN.CB_Reported_Course='Y' & W1I4UYQN.CB_Reported_Student ='Y', 
      W1I4UYQN.DOCTORAL_LEVEL_FUNDED/9, W1I4UYQN.DOCTORAL_LEVEL_UNFUNDED/9) as DOCTORAL_FTSE length = 8   
         label = 'DOCTORAL_FTSE',
      IFN( W1I4UYQN.CB_Reported_Course='Y' & W1I4UYQN.CB_Reported_Student ='Y', 
      W1I4UYQN.MASTER_LEVEL_FUNDED/12, W1I4UYQN.MASTER_LEVEL_UNFUNDED/12) as MASTER_FTSE length = 8   
         label = 'MASTER_FTSE',
      SUM(SUM(W1I4UYQN.LOWER_LEVEL_FUNDED ,  W1I4UYQN.UPPER_LEVEL_FUNDED)/15, 
      W1I4UYQN.MASTER_LEVEL_FUNDED  /12,  W1I4UYQN.DOCTORAL_LEVEL_FUNDED/9) as STATE_FUNDED_FTSE length = 8   
         label = 'STATE_FUNDED_FTSE',
      IFN(((W1I4UYQN.COURSE_LEVEL IS NOT MISSING & W1I4UYQN.COURSE_LEVEL IN ('1','2','3','4')) | (W1I4UYQN.COURSE_LEVEL IS MISSING & SUBSTR(W1I4UYQN.CATALOG_NBR,1,1) IN ('1','2','3','4'))), W1I4UYQN.UNFUNDED_SCH_TOTAL/15,   
      IFN(((W1I4UYQN.COURSE_LEVEL IS NOT MISSING & W1I4UYQN.COURSE_LEVEL ='5') | (W1I4UYQN.COURSE_LEVEL IS MISSING & SUBSTR(W1I4UYQN.CATALOG_NBR,1,1) ='5')), W1I4UYQN.UNFUNDED_SCH_TOTAL/12,   
      IFN(((W1I4UYQN.COURSE_LEVEL IS NOT MISSING & W1I4UYQN.COURSE_LEVEL ='6') | (W1I4UYQN.COURSE_LEVEL IS MISSING & SUBSTR(W1I4UYQN.CATALOG_NBR,1,1) ='6')),  W1I4UYQN.UNFUNDED_SCH_TOTAL/9,0))) as UNFUNDED_FTSE length = 8   
         label = 'UNFUNDED_FTSE',
      SUM( 
      SUM(W1I4UYQN.LOWER_LEVEL_FUNDED ,W1I4UYQN.UPPER_LEVEL_FUNDED)/15, 
      W1I4UYQN.MASTER_LEVEL_FUNDED/12, 
      W1I4UYQN.DOCTORAL_LEVEL_FUNDED/9, 
      IFN(((W1I4UYQN.COURSE_LEVEL IS NOT MISSING & W1I4UYQN.COURSE_LEVEL IN ('1','2','3','4')) | (W1I4UYQN.COURSE_LEVEL IS MISSING & SUBSTR(W1I4UYQN.CATALOG_NBR,1,1) IN ('1','2','3','4'))), W1I4UYQN.UNFUNDED_SCH_TOTAL/15,  
      IFN(((W1I4UYQN.COURSE_LEVEL IS NOT MISSING & W1I4UYQN.COURSE_LEVEL ='5') | (W1I4UYQN.COURSE_LEVEL IS MISSING & SUBSTR(W1I4UYQN.CATALOG_NBR,1,1) ='5')), W1I4UYQN.UNFUNDED_SCH_TOTAL/12,  
      IFN(((W1I4UYQN.COURSE_LEVEL IS NOT MISSING & W1I4UYQN.COURSE_LEVEL ='6') | (W1I4UYQN.COURSE_LEVEL IS MISSING & SUBSTR(W1I4UYQN.CATALOG_NBR,1,1) ='6')),  W1I4UYQN.UNFUNDED_SCH_TOTAL/9,0)))
      ) as TOTAL_FTSE length = 8   
         label = 'TOTAL_FTSE',
      W1I4UYQN.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT'
   from
      work.W1I4UYQN as W1I4UYQN
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end FTSE **/

/*==========================================================================* 
 * Step:            WSCH                                  A5B29B8Q.BZ000A20 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   FTSE - work.W1I4UZKY                  A5B29B8Q.BS0003CU * 
 *                  UTA_CB_FORMULA_FUNDING -              A5B29B8Q.BE0001E4 * 
 *                   CBMPRD.UTA_CB_FORMULA_FUNDING                          * 
 * Target Table:    WSCH - work.W1I4V0FB                  A5B29B8Q.BS0003CV * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A20);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.W1I4UZKY, DATA)) or 
         %sysfunc(exist(work.W1I4UZKY, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.W1I4UZKY out = work.etls_contents(keep = nobs) noprint; 
      run; 
      
      data _null_; 
         set work.etls_contents (obs = 1); 
         call symput("etls_recnt", left(put(nobs,32.))); 
      run;
      
      proc datasets lib = work nolist nowarn memtype = (data view);
         delete etls_contents;
      quit;
      
      /* Reset syntaxcheck option to previous setting  */ 
      options &etls_syntaxcheck; 
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete W1I4V0FB;
quit;

proc sql;
   create table work.W1I4V0FB as
   select
      W1I4UZKY.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      W1I4UZKY.TermDescription length = 30   
         format = $30.
         informat = $30.
         label = 'TermDescription',
      W1I4UZKY.SUBJECT length = 7   
         format = $7.
         informat = $7.
         label = 'SUBJECT',
      W1I4UZKY.CATALOG_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CATALOG_NBR',
      W1I4UZKY.CLASS_NBR length = 7   
         format = $7.
         informat = $7.
         label = 'CLASS_NBR',
      W1I4UZKY.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      W1I4UZKY.COLLEGE_DESCR length = 30   
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W1I4UZKY.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      W1I4UZKY.DEPT_DESCR length = 30   
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      W1I4UZKY.Instruction_Type length = 1   
         format = $1.
         informat = $1.
         label = 'Instruction_Type',
      W1I4UZKY.CORE_COURSE length = 8   
         label = 'CORE_COURSE',
      W1I4UZKY.AP_Course length = 1   
         label = 'AP_Course',
      W1I4UZKY.DLRN_Course length = 1   
         label = 'DLRN_Course',
      W1I4UZKY.Flex_entry length = 1   
         format = $1.
         informat = $1.
         label = 'Flex_entry',
      W1I4UZKY.CIP_OR_FUND_CODE length = 10   
         format = $10.
         informat = $10.
         label = 'CIP_OR_FUND_CODE',
      W1I4UZKY.COURSE_SCH length = 40   
         format = $40.
         informat = $40.
         label = 'COURSE_SCH',
      W1I4UZKY.COURSE_LEVEL length = 40   
         format = $40.
         informat = $40.
         label = 'COURSE_LEVEL',
      W1I4UZKY.FUND_YEAR length = 9   
         format = $9.
         informat = $9.
         label = 'FUND_YEAR',
      W1I4UZKY.FORMULA_CODE length = 8   
         format = 4.
         informat = 4.
         label = 'FORMULA_CODE',
      W1I4UZKY.UNFUNDED_SCH_TOTAL length = 8   
         label = 'UNFUNDED_SCH_TOTAL',
      W1I4UZKY.LOWER_LEVEL_EXCEED_STATE length = 8   
         label = 'LOWER_LEVEL_EXCEED_STATE',
      W1I4UZKY.LOWER_LEVEL_EXCEED_DEVELOP length = 8   
         label = 'LOWER_LEVEL_EXCEED_DEVELOP',
      W1I4UZKY.NOT_STATE_FUNDED_LOWER length = 8   
         label = 'NOT_STATE_FUNDED_LOWER',
      W1I4UZKY.NOT_STATE_FUNDED_UPPER length = 8   
         label = 'NOT_STATE_FUNDED_UPPER',
      W1I4UZKY.LOWER_LEVEL_UNFUNDED_TOTAL length = 8   
         label = 'LOWER_LEVEL_UNFUNDED_TOTAL',
      W1I4UZKY.LOWER_LEVEL_FUNDED length = 8   
         label = 'LOWER_LEVEL_FUNDED',
      W1I4UZKY.LOWER_LEVEL_TOTAL length = 8   
         label = 'LOWER_LEVEL_TOTAL',
      W1I4UZKY.UPPER_LEVEL_EXCEED_STATE length = 8   
         label = 'UPPER_LEVEL_EXCEED_STATE',
      W1I4UZKY.UPPER_LEVEL_EXCEED_DEVELOP length = 8   
         label = 'UPPER_LEVEL_EXCEED_DEVELOP',
      W1I4UZKY.UPPER_LEVEL_UNFUNDED_TOTAL length = 8   
         label = 'UPPER_LEVEL_UNFUNDED_TOTAL',
      W1I4UZKY.UPPER_LEVEL_FUNDED length = 8   
         label = 'UPPER_LEVEL_FUNDED',
      W1I4UZKY.UPPER_LEVEL_TOTAL length = 8   
         label = 'UPPER_LEVEL_TOTAL',
      W1I4UZKY.MASTER_LEVEL_UNFUNDED length = 8   
         label = 'MASTER_LEVEL_UNFUNDED',
      W1I4UZKY.MASTER_LEVEL_FUNDED length = 8   
         label = 'MASTER_LEVEL_FUNDED',
      W1I4UZKY.MASTER_LEVEL_TOTAL length = 8   
         label = 'MASTER_LEVEL_TOTAL',
      W1I4UZKY.DOCTORAL_LEVEL_UNFUNDED length = 8   
         label = 'DOCTORAL_LEVEL_UNFUNDED',
      W1I4UZKY.DOCTORAL_LEVEL_FUNDED length = 8   
         label = 'DOCTORAL_LEVEL_FUNDED',
      W1I4UZKY.DOCTORAL_LEVEL_TOTAL length = 8   
         label = 'DOCTORAL_LEVEL_TOTAL',
      W1I4UZKY.Total_SCH length = 8   
         label = 'Total_SCH',
      W1I4UZKY.Student_Count length = 8   
         label = 'Student_Count',
      W1I4UZKY.CB_Reported_Course length = 1   
         label = 'CB_Reported_Course',
      W1I4UZKY.CB_Reported_Student length = 1   
         label = 'CB_Reported_Student',
      W1I4UZKY.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W1I4UZKY.UGRD_HRS length = 8   
         label = 'UGRD_HRS',
      W1I4UZKY.UGRD_LOWER_FTSE length = 8   
         label = 'UGRD_LOWER_FTSE',
      W1I4UZKY.UGRD_UPPER_FTSE length = 8   
         label = 'UGRD_UPPER_FTSE',
      W1I4UZKY.UGRD_FTSE length = 8   
         label = 'UGRD_FTSE',
      W1I4UZKY.DOCTORAL_FTSE length = 8   
         label = 'DOCTORAL_FTSE',
      W1I4UZKY.MASTER_FTSE length = 8   
         label = 'MASTER_FTSE',
      W1I4UZKY.STATE_FUNDED_FTSE length = 8   
         label = 'STATE_FUNDED_FTSE',
      W1I4UZKY.UNFUNDED_FTSE length = 8   
         label = 'UNFUNDED_FTSE',
      W1I4UZKY.TOTAL_FTSE length = 8   
         label = 'TOTAL_FTSE',
      IFN(W1I4UZKY.CB_Reported_Course ='Y' & W1I4UZKY.CB_Reported_Student ='Y', W1I4UZKY.LOWER_LEVEL_FUNDED, W1I4UZKY.LOWER_LEVEL_UNFUNDED_TOTAL )  
       *  UTA_CB_FORMULA_FUNDING.LOWER_DIVISION as UGRD_LOWER_DIV_WT_HRS length = 8   
         label = 'UGRD_LOWER_DIV_WT_HRS',
      IFN(W1I4UZKY.CB_Reported_Course ='Y' & W1I4UZKY.CB_Reported_Student ='Y', W1I4UZKY.UPPER_LEVEL_FUNDED, W1I4UZKY.UPPER_LEVEL_UNFUNDED_TOTAL )  
      *  UTA_CB_FORMULA_FUNDING.UPPER_DIVISION as UGRD_UPPER_DIV_WT_HRS length = 8   
         label = 'UGRD_UPPER_DIV_WT_HRS',
      SUM(
      IFN(W1I4UZKY.CB_Reported_Course ='Y' & W1I4UZKY.CB_Reported_Student ='Y', W1I4UZKY.LOWER_LEVEL_FUNDED, W1I4UZKY.LOWER_LEVEL_UNFUNDED_TOTAL ) 
       *  UTA_CB_FORMULA_FUNDING.LOWER_DIVISION,
      IFN(W1I4UZKY.CB_Reported_Course ='Y' & W1I4UZKY.CB_Reported_Student ='Y', W1I4UZKY.UPPER_LEVEL_FUNDED, W1I4UZKY.UPPER_LEVEL_UNFUNDED_TOTAL ) 
      *  UTA_CB_FORMULA_FUNDING.UPPER_DIVISION
      ) as UGRD_WT_HRS length = 8   
         label = 'UGRD_WT_HRS',
      IFN(W1I4UZKY.CB_Reported_Course ='Y' & W1I4UZKY.CB_Reported_Student ='Y', W1I4UZKY.MASTER_LEVEL_FUNDED ,W1I4UZKY.MASTER_LEVEL_UNFUNDED  ) 
       *  UTA_CB_FORMULA_FUNDING.MASTERS as MASTER_WT_HRS length = 8   
         label = 'MASTER_WT_HRS',
      IFN(W1I4UZKY.CB_Reported_Course ='Y' & W1I4UZKY.CB_Reported_Student ='Y', W1I4UZKY.DOCTORAL_LEVEL_FUNDED, W1I4UZKY.DOCTORAL_LEVEL_UNFUNDED ) 
       *  UTA_CB_FORMULA_FUNDING.DOCTORAL as DOCTORAL_WT_HRS length = 8   
         label = 'DOCTORAL_WT_HRS',
      SUM((W1I4UZKY.LOWER_LEVEL_FUNDED *  
      UTA_CB_FORMULA_FUNDING.LOWER_DIVISION),  
      (W1I4UZKY.UPPER_LEVEL_FUNDED *  
      UTA_CB_FORMULA_FUNDING.UPPER_DIVISION),  
      (W1I4UZKY.MASTER_LEVEL_FUNDED *  
      UTA_CB_FORMULA_FUNDING.MASTERS),  
      (W1I4UZKY.DOCTORAL_LEVEL_FUNDED*  
      UTA_CB_FORMULA_FUNDING.DOCTORAL)) as STATE_FUNDED_WT_HRS length = 8   
         label = 'STATE_FUNDED_WT_HRS'
   from
      work.W1I4UZKY as W1I4UZKY left join 
      CBMPRD.UTA_CB_FORMULA_FUNDING as UTA_CB_FORMULA_FUNDING
         on
         (
            W1I4UZKY.FUND_YEAR = UTA_CB_FORMULA_FUNDING.FUND_YEAR
            and W1I4UZKY.FORMULA_CODE = UTA_CB_FORMULA_FUNDING.FORMULA_CODE
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end WSCH **/

/*==========================================================================* 
 * Step:            Table Loader                          A5B29B8Q.BZ000A21 * 
 * Transform:       Table Loader (Version 2.1)                              * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    WSCH - work.W1I4V0FB                  A5B29B8Q.BS0003CV * 
 * Target Table:    ADW_CBM00S_SCH_WORK -                 A5B29B8Q.BE0001E2 * 
 *                   CBMPRD.ADW_CBM00S_SCH_WORK                             * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000A21);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let SYSLAST = %nrquote(work.W1I4V0FB); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|Loader), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

%global etls_tableExist;
%global etls_numIndex;
%global etls_lastTable;
%let etls_tableExist = -1; 
%let etls_numIndex = -1; 
%let etls_lastTable = &SYSLAST; 

/*---- Define load data macro  ----*/ 

/* --------------------------------------------------------------
   Load Technique Selection: Replace - Truncate
   Constraint and index action selections: 'ASIS','ASIS','ASIS','ASIS'
   Additional options selections... 
      Set unmapped to missing on updates: false 
   -------------------------------------------------------------- */
%macro etls_loader;

   %let etls_tableOptions = ;
   
   /* Determine if the target table exists  */ 
   %let etls_tableExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM00S_SCH_WORK, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM00S_SCH_WORK, VIEW))); 
   
   /*---- Create a new table  ----*/ 
   %if (&etls_tableExist eq 0) %then 
   %do;  /* if table does not exist  */ 
   
      %put %str(NOTE: Creating table ...);
      
      data CBMPRD.ADW_CBM00S_SCH_WORK
              (dbnull = (
                         STRM = NO
                         TermDescription = YES
                         SUBJECT = YES
                         CATALOG_NBR = YES
                         CLASS_NBR = YES
                         ACAD_GROUP = YES
                         COLLEGE_DESCR = YES
                         ACAD_ORG = YES
                         DEPT_DESCR = YES
                         Instruction_Type = YES
                         CORE_COURSE = YES
                         AP_Course = YES
                         DLRN_Course = YES
                         Flex_entry = YES
                         CIP_OR_FUND_CODE = YES
                         COURSE_SCH = YES
                         COURSE_LEVEL = YES
                         FUND_YEAR = YES
                         FORMULA_CODE = YES
                         UNFUNDED_SCH_TOTAL = YES
                         LOWER_LEVEL_EXCEED_STATE = YES
                         LOWER_LEVEL_EXCEED_DEVELOP = YES
                         NOT_STATE_FUNDED_LOWER = YES
                         NOT_STATE_FUNDED_UPPER = YES
                         LOWER_LEVEL_UNFUNDED_TOTAL = YES
                         LOWER_LEVEL_FUNDED = YES
                         LOWER_LEVEL_TOTAL = YES
                         UPPER_LEVEL_EXCEED_STATE = YES
                         UPPER_LEVEL_EXCEED_DEVELOP = YES
                         UPPER_LEVEL_UNFUNDED_TOTAL = YES
                         UPPER_LEVEL_FUNDED = YES
                         UPPER_LEVEL_TOTAL = YES
                         MASTER_LEVEL_UNFUNDED = YES
                         MASTER_LEVEL_FUNDED = YES
                         MASTER_LEVEL_TOTAL = YES
                         DOCTORAL_LEVEL_UNFUNDED = YES
                         DOCTORAL_LEVEL_FUNDED = YES
                         DOCTORAL_LEVEL_TOTAL = YES
                         Total_SCH = YES
                         Student_Count = YES
                         CB_Reported_Course = YES
                         CB_Reported_Student = YES
                         CENSUS_DT = YES
                         UGRD_HRS = YES
                         UGRD_LOWER_FTSE = YES
                         UGRD_UPPER_FTSE = YES
                         UGRD_FTSE = YES
                         DOCTORAL_FTSE = YES
                         MASTER_FTSE = YES
                         STATE_FUNDED_FTSE = YES
                         UNFUNDED_FTSE = YES
                         TOTAL_FTSE = YES
                         UGRD_LOWER_DIV_WT_HRS = YES
                         UGRD_UPPER_DIV_WT_HRS = YES
                         UGRD_WT_HRS = YES
                         MASTER_WT_HRS = YES
                         DOCTORAL_WT_HRS = YES
                         STATE_FUNDED_WT_HRS = YES));
         attrib STRM length = $4
            format = $4.
            informat = $4.
            label = 'STRM'; 
         attrib TermDescription length = $30
            format = $30.
            informat = $30.
            label = 'TermDescription'; 
         attrib SUBJECT length = $7
            format = $7.
            informat = $7.
            label = 'SUBJECT'; 
         attrib CATALOG_NBR length = $7
            format = $7.
            informat = $7.
            label = 'CATALOG_NBR'; 
         attrib CLASS_NBR length = $7
            format = $7.
            informat = $7.
            label = 'CLASS_NBR'; 
         attrib ACAD_GROUP length = $5
            format = $5.
            informat = $5.
            label = 'ACAD_GROUP'; 
         attrib COLLEGE_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'COLLEGE_DESCR'; 
         attrib ACAD_ORG length = $10
            format = $10.
            informat = $10.
            label = 'ACAD_ORG'; 
         attrib DEPT_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'DEPT_DESCR'; 
         attrib Instruction_Type length = $1
            format = $1.
            informat = $1.
            label = 'Instruction_Type'; 
         attrib CORE_COURSE length = $8
            label = 'CORE_COURSE'; 
         attrib AP_Course length = $1
            label = 'AP_Course'; 
         attrib DLRN_Course length = $1
            label = 'DLRN_Course'; 
         attrib Flex_entry length = $1
            format = $1.
            informat = $1.
            label = 'Flex_entry'; 
         attrib CIP_OR_FUND_CODE length = $10
            format = $10.
            informat = $10.
            label = 'CIP_OR_FUND_CODE'; 
         attrib COURSE_SCH length = $40
            format = $40.
            informat = $40.
            label = 'COURSE_SCH'; 
         attrib COURSE_LEVEL length = $40
            format = $40.
            informat = $40.
            label = 'COURSE_LEVEL'; 
         attrib FUND_YEAR length = $9
            format = $9.
            informat = $9.
            label = 'FUND_YEAR'; 
         attrib FORMULA_CODE length = 8
            format = 4.
            informat = 4.
            label = 'FORMULA_CODE'; 
         attrib UNFUNDED_SCH_TOTAL length = 8
            label = 'UNFUNDED_SCH_TOTAL'; 
         attrib LOWER_LEVEL_EXCEED_STATE length = 8
            label = 'LOWER_LEVEL_EXCEED_STATE'; 
         attrib LOWER_LEVEL_EXCEED_DEVELOP length = 8
            label = 'LOWER_LEVEL_EXCEED_DEVELOP'; 
         attrib NOT_STATE_FUNDED_LOWER length = 8
            label = 'NOT_STATE_FUNDED_LOWER'; 
         attrib NOT_STATE_FUNDED_UPPER length = 8
            label = 'NOT_STATE_FUNDED_UPPER'; 
         attrib LOWER_LEVEL_UNFUNDED_TOTAL length = 8
            label = 'LOWER_LEVEL_UNFUNDED_TOTAL'; 
         attrib LOWER_LEVEL_FUNDED length = 8
            label = 'LOWER_LEVEL_FUNDED'; 
         attrib LOWER_LEVEL_TOTAL length = 8
            label = 'LOWER_LEVEL_TOTAL'; 
         attrib UPPER_LEVEL_EXCEED_STATE length = 8
            label = 'UPPER_LEVEL_EXCEED_STATE'; 
         attrib UPPER_LEVEL_EXCEED_DEVELOP length = 8
            label = 'UPPER_LEVEL_EXCEED_DEVELOP'; 
         attrib UPPER_LEVEL_UNFUNDED_TOTAL length = 8
            label = 'UPPER_LEVEL_UNFUNDED_TOTAL'; 
         attrib UPPER_LEVEL_FUNDED length = 8
            label = 'UPPER_LEVEL_FUNDED'; 
         attrib UPPER_LEVEL_TOTAL length = 8
            label = 'UPPER_LEVEL_TOTAL'; 
         attrib MASTER_LEVEL_UNFUNDED length = 8
            label = 'MASTER_LEVEL_UNFUNDED'; 
         attrib MASTER_LEVEL_FUNDED length = 8
            label = 'MASTER_LEVEL_FUNDED'; 
         attrib MASTER_LEVEL_TOTAL length = 8
            label = 'MASTER_LEVEL_TOTAL'; 
         attrib DOCTORAL_LEVEL_UNFUNDED length = 8
            label = 'DOCTORAL_LEVEL_UNFUNDED'; 
         attrib DOCTORAL_LEVEL_FUNDED length = 8
            label = 'DOCTORAL_LEVEL_FUNDED'; 
         attrib DOCTORAL_LEVEL_TOTAL length = 8
            label = 'DOCTORAL_LEVEL_TOTAL'; 
         attrib Total_SCH length = 8
            label = 'Total_SCH'; 
         attrib Student_Count length = 8
            label = 'Student_Count'; 
         attrib CB_Reported_Course length = $1
            label = 'CB_Reported_Course'; 
         attrib CB_Reported_Student length = $1
            label = 'CB_Reported_Student'; 
         attrib CENSUS_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'CENSUS_DT'; 
         attrib UGRD_HRS length = 8
            label = 'UGRD_HRS'; 
         attrib UGRD_LOWER_FTSE length = 8
            label = 'UGRD_LOWER_FTSE'; 
         attrib UGRD_UPPER_FTSE length = 8
            label = 'UGRD_UPPER_FTSE'; 
         attrib UGRD_FTSE length = 8
            label = 'UGRD_FTSE'; 
         attrib DOCTORAL_FTSE length = 8
            label = 'DOCTORAL_FTSE'; 
         attrib MASTER_FTSE length = 8
            label = 'MASTER_FTSE'; 
         attrib STATE_FUNDED_FTSE length = 8
            label = 'STATE_FUNDED_FTSE'; 
         attrib UNFUNDED_FTSE length = 8
            label = 'UNFUNDED_FTSE'; 
         attrib TOTAL_FTSE length = 8
            label = 'TOTAL_FTSE'; 
         attrib UGRD_LOWER_DIV_WT_HRS length = 8
            label = 'UGRD_LOWER_DIV_WT_HRS'; 
         attrib UGRD_UPPER_DIV_WT_HRS length = 8
            label = 'UGRD_UPPER_DIV_WT_HRS'; 
         attrib UGRD_WT_HRS length = 8
            label = 'UGRD_WT_HRS'; 
         attrib MASTER_WT_HRS length = 8
            label = 'MASTER_WT_HRS'; 
         attrib DOCTORAL_WT_HRS length = 8
            label = 'DOCTORAL_WT_HRS'; 
         attrib STATE_FUNDED_WT_HRS length = 8
            label = 'STATE_FUNDED_WT_HRS'; 
         call missing(of _all_);
         stop;
      run;
      
      %rcSet(&syserr); 
      
   %end;  /* if table does not exist  */ 
   
   %else 
   %do;  /* table exists */ 
      /*---- Truncate a table  ----*/ 
      %put %str(NOTE: Truncating table ...);
      proc sql;
         connect to ORACLE
         ( 
             DEFER=YES DBSERVER_MAX_BYTES=1 DBCLIENT_MAX_BYTES=1 ADJUST_BYTE_SEMANTIC_COLUMN_LENGTHS=YES DB_LENGTH_SEMANTICS_BYTE=YES DBSERVER_ENCODING_FIXED=YES DBCLIENT_ENCODING_FIXED=YES PATH=UTAAWSPD AUTHDOMAIN="CBMPRD" 
         ); 
         reset noprint; 
         
         execute 
         ( 
            truncate table CBMPRD.ADW_CBM00S_SCH_WORK
         ) by ORACLE; 
         
         %rcSet(&sqlrc); 
         
         disconnect from ORACLE; 
      quit; 
      
      %rcSet(&sqlrc); 
      
   %end; /* table exists */ 
   
   /*---- Append  ----*/ 
   %put %str(NOTE: Appending data ...);
   
   proc append base = CBMPRD.ADW_CBM00S_SCH_WORK 
      data = &etls_lastTable (&etls_tableOptions)  force ; 
    run; 
   
   %rcSet(&syserr); 
   
%mend etls_loader;
%etls_loader;

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM00S_SCH_WORK, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM00S_SCH_WORK, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from CBMPRD.ADW_CBM00S_SCH_WORK;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Table Loader **/

%let etls_endTime = %sysfunc(datetime(),datetime.);

/* Turn off performance statistics collection  */ 
data _null_;
   if "&_perfinit" eq "1" then 
      call execute('%perfend;');
      
run;
