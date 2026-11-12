/**************************************************************************** 
 * Job:             400_LOAD_CBM002                       A5B29B8Q.BT0000RE * 
 * Description:                                                             * 
 *                                                                          * 
 * Metadata Server: sasmetapaws8.ua.uta.edu                                 * 
 * Port:            8561                                                    * 
 * Location:        /UTA/ADW/400 Reports/CBM/Jobs                           * 
 *                                                                          * 
 * Server:          SASApp                                A5B29B8Q.AS000002 * 
 *                                                                          * 
 * Source Tables:   PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 * 
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          * 
 *                  PS_CLASS_ASSOC_Extract -              A5B29B8Q.BE00000A * 
 *                   ADWSTGPR.PS_CLASS_ASSOC_Extract                        * 
 *                  PS_UTA_CB_LOC_VW_Extract -            A5B29B8Q.BE00000B * 
 *                   ADWSTGPR.PS_UTA_CB_LOC_VW_Extract                      * 
 *                  PS_UTZ_PT100_DTL_Extract -            A5B29B8Q.BE00000C * 
 *                   ADWSTGPR.PS_UTZ_PT100_DTL_Extract                      * 
 *                  PS_SCTN_CMBND_Extract -               A5B29B8Q.BE00000D * 
 *                   ADWSTGPR.PS_SCTN_CMBND_Extract                         * 
 *                  PS_ACAD_PLAN_Extract -                A5B29B8Q.BE00000G * 
 *                   ADWSTGPR.PS_ACAD_PLAN_Extract                          * 
 *                  PS_ACAD_PLAN_TBL_Extract -            A5B29B8Q.BE00000H * 
 *                   ADWSTGPR.PS_ACAD_PLAN_TBL_Extract                      * 
 *                  PS_ACAD_PLAN_OWNER_Extract -          A5B29B8Q.BE00000I * 
 *                   ADWSTGPR.PS_ACAD_PLAN_OWNER_Extract                    * 
 *                  PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J * 
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          * 
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K * 
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     * 
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 * 
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    * 
 *                  PS_CRSE_ATTR_VALUE_Extract -          A5B29B8Q.BE000006 * 
 *                   ADWSTGPR.PS_CRSE_ATTR_VALUE_Extract                    * 
 *                  PS_CRSE_ATTRIBUTES_Extract -          A5B29B8Q.BE000007 * 
 *                   ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract                    * 
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  PS_CRSE_CATALOG_Extract -             A5B29B8Q.BE000008 * 
 *                   ADWSTGPR.PS_CRSE_CATALOG_Extract                       * 
 *                  PS_HCR_DIV_ETHNIC_I_Extract -         A5B29B8Q.BE00003T * 
 *                   ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract                   * 
 *                  PS_HCR_ETHNIC_GRP_I_Extract -         A5B29B8Q.BE00003U * 
 *                   ADWSTGPR.PS_HCR_ETHNIC_GRP_I_Extract                   * 
 *                  PS_PERSON_SA_Extract -                A5B29B8Q.BE00000P * 
 *                   ADWSTGPR.PS_PERSON_SA_Extract                          * 
 *                  PS_PERS_DATA_EFFDT_Extract -          A5B29B8Q.BE00004R * 
 *                   ADWSTGPR.PS_PERS_DATA_EFFDT_Extract                    * 
 *                  PS_PERSON_Extract -                   A5B29B8Q.BE00004V * 
 *                   ADWSTGPR.PS_PERSON_Extract                             * 
 *                  PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U * 
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      * 
 *                  PS_ADM_APPL_RCR_CA_Extract -          A5B29B8Q.BE00000V * 
 *                   ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract                    * 
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T * 
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      * 
 *                  PS_PERS_NID_Extract -                 A5B29B8Q.BE00000R * 
 *                   ADWSTGPR.PS_PERS_NID_Extract                           * 
 *                  PS_EXTERNAL_SYSTEM_Extract -          A5B29B8Q.BE00000S * 
 *                   ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract                    * 
 *                  PS_RESIDENCY_OFF_Extract -            A5B29B8Q.BE000059 * 
 *                   ADWSTGPR.PS_RESIDENCY_OFF_Extract                      * 
 *                  PS_STDNT_TEST_COMP_Extract -          A5B29B8Q.BE00006J * 
 *                   ADWSTGPR.PS_STDNT_TEST_COMP_Extract                    * 
 *                  PS_UTA_TSI_SECTION_Extract -          A5B29B8Q.BE000083 * 
 *                   ADWSTGPR.PS_UTA_TSI_SECTION_Extract                    * 
 *                  PS_UTA_TSI_STA_EXM_Extract -          A5B29B8Q.BE000084 * 
 *                   ADWSTGPR.PS_UTA_TSI_STA_EXM_Extract                    * 
 *                  PS_UTA_TSI_STA_EXM_Extract -          A5B29B8Q.BE000084 * 
 *                   ADWSTGPR.PS_UTA_TSI_STA_EXM_Extract                    * 
 *                  PS_UTA_TSI_TRM_EXM_Extract -          A5B29B8Q.BE000085 * 
 *                   ADWSTGPR.PS_UTA_TSI_TRM_EXM_Extract                    * 
 *                  PS_TRNS_TEST_DTL_Extract -            A5B29B8Q.BE00000X * 
 *                   ADWSTGPR.PS_TRNS_TEST_DTL_Extract                      * 
 *                  PS_TRNS_CRSE_DTL_Extract -            A5B29B8Q.BE00000Y * 
 *                   ADWSTGPR.PS_TRNS_CRSE_DTL_Extract                      * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  ADW_CBM002_WORK -                     A5B29B8Q.BE000172 * 
 *                   CBMPRD.ADW_CBM002_WORK                                 * 
 *                  ADW_CBM002_CENSUS -                   A5B29B8Q.BE000171 * 
 *                   CBMPRD.ADW_CBM002_CENSUS                               * 
 * Target Tables:   ADW_CBM002_CENSUS -                   A5B29B8Q.BE000171 * 
 *                   CBMPRD.ADW_CBM002_CENSUS                               * 
 *                  ADW_CBM002_WORK -                     A5B29B8Q.BE000172 * 
 *                   CBMPRD.ADW_CBM002_WORK                                 * 
 *                  ADW_CBM002_CENSUS -                   A5B29B8Q.BE000171 * 
 *                   CBMPRD.ADW_CBM002_CENSUS                               * 
 *                                                                          * 
 * Generated on:    Friday, March 6, 2026 9:17:32 AM CST                    * 
 * Generated by:    mynenit                                                 * 
 * Version:         SAS Data Integration Studio 4.905                       * 
 ****************************************************************************/ 

/* Generate the process id for job  */ 
%put Process ID: &SYSJOBID;

/* General macro variables  */ 
%let jobID = %quote(A5B29B8Q.BT0000RE);
%let etls_jobName = %nrquote(400_LOAD_CBM002);
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
 * Step:            Manual Run                            A5B29B8Q.BZ000BSV * 
 * Transform:       User Written                                            * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 * 
 * Target Table:    Term_Setup - work.Term_Setup          A5B29B8Q.BS000466 * 
 *                                                                          * 
 * User Written:    SourceCode                                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BSV);
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
%let _OUTPUT_path = %nrquote(/Term_Setup_A5B29B8Q.BS000466%(WorkTable%));
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
%let _OUTPUT1_path = %nrquote(/Term_Setup_A5B29B8Q.BS000466%(WorkTable%));
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

%let current_term=2258;
%let prior_term=2255;
%let future_term=2262;
%let snapshot_type= 'End of Term';

/* 
%let current_term=2262;
%let prior_term=2258;
%let future_term=2265;
%let snapshot_type='Census';

%let current_term=2258;
%let prior_term=2255;
%let future_term=2262;
%let snapshot_type= 'End of Term';


%let current_term=2248;
%let prior_term=2245;
%let future_term = 2252;
%let snapshot_type =  'Census''End of Term';/*

/*%let current_term=2198;*/
/*%let prior_term=2195;*/

/*%let current_term=2205;
%let prior_term=2202;*/

/* Two values for snapshottype 
1) Census
2) End of Term
*/

/*%let current_term=2212;
%let prior_term=2208;
%let future_term = 2215;*/
/*%let current_term=2218;*/
/*%let prior_term=2215;*/
/*%let future_term = 2222;*/
/*%let snapshot_type = 'End of Term';*/

proc sql ;
create table work.Merge_Terms as

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
Merge_Terms.STRM,
Merge_Terms.TERM_BEGIN_DT,
Merge_Terms.TERM_END_DT,
Merge_Terms.TERM_SK,
Merge_Terms.CENSUS_DT,
Merge_Terms.Current_Term,
Merge_Terms.ACAD_CAREER,
MAX(Merge_Terms.TERM_END_DT) as Current_Term_End_Date
from
work.Merge_Terms 
group by
Merge_Terms.ACAD_CAREER
;
quit;

proc sql;
select
distinct 
ADW_TERM_DIM.CENSUS_DT into: future_census
from
ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
where
ADW_TERM_DIM.STRM ="&future_term"
and ADW_TERM_DIM.ACAD_CAREER = 'UGRD'
;
quit;


data _null_;
set work.Term_Setup end=lastobs;

 if not lastobs then do;
  	call symput('current_term_begin_date', TERM_BEGIN_DT);
 	call symput('current_term_end_date', TERM_END_DT);
	call symput('current_term_sk', term_sk);
 	call symput('current_term_census_date', CENSUS_DT);
 end;
 else do;
	call symputx('prior_term_begin_date', TERM_BEGIN_DT);
 	call symputx('prior_term_end_date', TERM_END_DT);
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
 * Step:            Class Attribute Info                  A5B29B8Q.BZ000BSW * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 * 
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    * 
 *                  PS_CRSE_ATTR_VALUE_Extract -          A5B29B8Q.BE000006 * 
 *                   ADWSTGPR.PS_CRSE_ATTR_VALUE_Extract                    * 
 * Target Table:    CLASS_ATTRIBUTE -                     A5B29B8Q.BS000467 * 
 *                   work.CBM002_CLASS_ATTRIBUTE                            * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BSW);
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
   delete CBM002_CLASS_ATTRIBUTE;
quit;

proc sql;
   create table work.CBM002_CLASS_ATTRIBUTE as
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
 * Step:            User Written (Class Attributes)       A5B29B8Q.BZ000BSX * 
 * Transform:       User Written                                            * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CLASS_ATTRIBUTE -                     A5B29B8Q.BS000467 * 
 *                   work.CBM002_CLASS_ATTRIBUTE                            * 
 * Target Table:    User Written -                        A5B29B8Q.BS000468 * 
 *                   work.CBM002_CLASS_ATTRIBUTES                           * 
 *                                                                          * 
 * User Written:    SourceCode                                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BSX);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_CLASS_ATTRIBUTE, DATA)) or 
         %sysfunc(exist(work.CBM002_CLASS_ATTRIBUTE, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_CLASS_ATTRIBUTE out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.CBM002_CLASS_ATTRIBUTE); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|UserWritten), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%let _INPUT_count = 1;
%let _INPUT = work.CBM002_CLASS_ATTRIBUTE;
%let _INPUT_connect = ;
%let _INPUT_engine = ;
%let _INPUT_memtype = DATA;
%let _INPUT_options = %nrquote();
%let _INPUT_alter = %nrquote();
%let _INPUT_path = %nrquote(/CLASS_ATTRIBUTE_A5B29B8Q.BS000467%(WorkTable%));
%let _INPUT_type = 1;
%let _INPUT_label = %nrquote();
%let _INPUT_filetype = WorkTable;

%let _INPUT1 = work.CBM002_CLASS_ATTRIBUTE;
%let _INPUT1_connect = ;
%let _INPUT1_engine = ;
%let _INPUT1_memtype = DATA;
%let _INPUT1_options = %nrquote();
%let _INPUT1_alter = %nrquote();
%let _INPUT1_path = %nrquote(/CLASS_ATTRIBUTE_A5B29B8Q.BS000467%(WorkTable%));
%let _INPUT1_type = 1;
%let _INPUT1_label = %nrquote();
%let _INPUT1_filetype = WorkTable;

%let _OUTPUT_count = 1;
%let _OUTPUT = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT_connect = ;
%let _OUTPUT_engine = ;
%let _OUTPUT_memtype = DATA;
%let _OUTPUT_options = %nrquote();
%let _OUTPUT_alter = %nrquote();
%let _OUTPUT_path = %nrquote(/User Written_A5B29B8Q.BS000468%(WorkTable%));
%let _OUTPUT_type = 1;
%let _OUTPUT_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT_keep = CRSE_ID CRSE_OFFER_NBR STRM SESSION_CODE CLASS_SECTION ATTR_LIST 
        VAL_LIST;
%let _OUTPUT_col_count = 7;
%let _OUTPUT_col0_name = CRSE_ID;
%let _OUTPUT_col0_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT_col0_length = 6;
%let _OUTPUT_col0_type = $;
%let _OUTPUT_col0_format = $6.;
%let _OUTPUT_col0_informat = $6.;
%let _OUTPUT_col0_label = %nrquote(CRSE_ID);
%let _OUTPUT_col0_exp = ;
%let _OUTPUT_col0_input_count = 0;
%let _OUTPUT_col1_name = CRSE_OFFER_NBR;
%let _OUTPUT_col1_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT_col1_length = 8;
%let _OUTPUT_col1_type = ;
%let _OUTPUT_col1_format = ;
%let _OUTPUT_col1_informat = ;
%let _OUTPUT_col1_label = %nrquote(CRSE_OFFER_NBR);
%let _OUTPUT_col1_exp = ;
%let _OUTPUT_col1_input_count = 0;
%let _OUTPUT_col2_name = STRM;
%let _OUTPUT_col2_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT_col2_length = 4;
%let _OUTPUT_col2_type = $;
%let _OUTPUT_col2_format = $4.;
%let _OUTPUT_col2_informat = $4.;
%let _OUTPUT_col2_label = %nrquote(STRM);
%let _OUTPUT_col2_exp = ;
%let _OUTPUT_col2_input_count = 0;
%let _OUTPUT_col3_name = SESSION_CODE;
%let _OUTPUT_col3_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT_col3_length = 3;
%let _OUTPUT_col3_type = $;
%let _OUTPUT_col3_format = $3.;
%let _OUTPUT_col3_informat = $3.;
%let _OUTPUT_col3_label = %nrquote(SESSION_CODE);
%let _OUTPUT_col3_exp = ;
%let _OUTPUT_col3_input_count = 0;
%let _OUTPUT_col4_name = CLASS_SECTION;
%let _OUTPUT_col4_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT_col4_length = 4;
%let _OUTPUT_col4_type = $;
%let _OUTPUT_col4_format = $4.;
%let _OUTPUT_col4_informat = $4.;
%let _OUTPUT_col4_label = %nrquote(CLASS_SECTION);
%let _OUTPUT_col4_exp = ;
%let _OUTPUT_col4_input_count = 0;
%let _OUTPUT_col5_name = ATTR_LIST;
%let _OUTPUT_col5_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT_col5_length = 50;
%let _OUTPUT_col5_type = $;
%let _OUTPUT_col5_format = ;
%let _OUTPUT_col5_informat = ;
%let _OUTPUT_col5_label = %nrquote(ATTR_LIST);
%let _OUTPUT_col5_exp = ;
%let _OUTPUT_col5_input_count = 0;
%let _OUTPUT_col6_name = VAL_LIST;
%let _OUTPUT_col6_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT_col6_length = 100;
%let _OUTPUT_col6_type = $;
%let _OUTPUT_col6_format = ;
%let _OUTPUT_col6_informat = ;
%let _OUTPUT_col6_label = %nrquote(VAL_LIST);
%let _OUTPUT_col6_exp = ;
%let _OUTPUT_col6_input_count = 0;
%let _OUTPUT_filetype = WorkTable;

%let _OUTPUT1 = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT1_connect = ;
%let _OUTPUT1_engine = ;
%let _OUTPUT1_memtype = DATA;
%let _OUTPUT1_options = %nrquote();
%let _OUTPUT1_alter = %nrquote();
%let _OUTPUT1_path = %nrquote(/User Written_A5B29B8Q.BS000468%(WorkTable%));
%let _OUTPUT1_type = 1;
%let _OUTPUT1_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT1_keep = CRSE_ID CRSE_OFFER_NBR STRM SESSION_CODE CLASS_SECTION ATTR_LIST 
        VAL_LIST;
%let _OUTPUT1_col_count = 7;
%let _OUTPUT1_col0_name = CRSE_ID;
%let _OUTPUT1_col0_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT1_col0_length = 6;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $6.;
%let _OUTPUT1_col0_informat = $6.;
%let _OUTPUT1_col0_label = %nrquote(CRSE_ID);
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input_count = 0;
%let _OUTPUT1_col1_name = CRSE_OFFER_NBR;
%let _OUTPUT1_col1_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT1_col1_length = 8;
%let _OUTPUT1_col1_type = ;
%let _OUTPUT1_col1_format = ;
%let _OUTPUT1_col1_informat = ;
%let _OUTPUT1_col1_label = %nrquote(CRSE_OFFER_NBR);
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input_count = 0;
%let _OUTPUT1_col2_name = STRM;
%let _OUTPUT1_col2_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT1_col2_length = 4;
%let _OUTPUT1_col2_type = $;
%let _OUTPUT1_col2_format = $4.;
%let _OUTPUT1_col2_informat = $4.;
%let _OUTPUT1_col2_label = %nrquote(STRM);
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input_count = 0;
%let _OUTPUT1_col3_name = SESSION_CODE;
%let _OUTPUT1_col3_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT1_col3_length = 3;
%let _OUTPUT1_col3_type = $;
%let _OUTPUT1_col3_format = $3.;
%let _OUTPUT1_col3_informat = $3.;
%let _OUTPUT1_col3_label = %nrquote(SESSION_CODE);
%let _OUTPUT1_col3_exp = ;
%let _OUTPUT1_col3_input_count = 0;
%let _OUTPUT1_col4_name = CLASS_SECTION;
%let _OUTPUT1_col4_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT1_col4_length = 4;
%let _OUTPUT1_col4_type = $;
%let _OUTPUT1_col4_format = $4.;
%let _OUTPUT1_col4_informat = $4.;
%let _OUTPUT1_col4_label = %nrquote(CLASS_SECTION);
%let _OUTPUT1_col4_exp = ;
%let _OUTPUT1_col4_input_count = 0;
%let _OUTPUT1_col5_name = ATTR_LIST;
%let _OUTPUT1_col5_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT1_col5_length = 50;
%let _OUTPUT1_col5_type = $;
%let _OUTPUT1_col5_format = ;
%let _OUTPUT1_col5_informat = ;
%let _OUTPUT1_col5_label = %nrquote(ATTR_LIST);
%let _OUTPUT1_col5_exp = ;
%let _OUTPUT1_col5_input_count = 0;
%let _OUTPUT1_col6_name = VAL_LIST;
%let _OUTPUT1_col6_table = work.CBM002_CLASS_ATTRIBUTES;
%let _OUTPUT1_col6_length = 100;
%let _OUTPUT1_col6_type = $;
%let _OUTPUT1_col6_format = ;
%let _OUTPUT1_col6_informat = ;
%let _OUTPUT1_col6_label = %nrquote(VAL_LIST);
%let _OUTPUT1_col6_exp = ;
%let _OUTPUT1_col6_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/ 

data work.CBM002_CLASS_ATTRIBUTES;
	set work.CBM002_CLASS_ATTRIBUTE;
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
 * Step:            Max Eff Dated                         A5B29B8Q.BZ000BSY * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    PS_CRSE_ATTRIBUTES_Extract -          A5B29B8Q.BE000007 * 
 *                   ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract                    * 
 * Target Table:    CBM002_CRSE_ATTRIBUTE -               A5B29B8Q.BS000469 * 
 *                   work.CBM002_CRSE_ATTRIBUTE                             * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BSY);
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
   delete CBM002_CRSE_ATTRIBUTE;
quit;

proc sql;
   create table work.CBM002_CRSE_ATTRIBUTE as
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
      PS_CRSE_ATTRIBUTES_Extract.CRSE_ID,
      PS_CRSE_ATTRIBUTES_Extract.CRSE_ATTR
   having
      PS_CRSE_ATTRIBUTES_Extract.EFFDT = MAX(PS_CRSE_ATTRIBUTES_Extract.EFFDT)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Max Eff Dated **/

/*==========================================================================* 
 * Step:            User Written (Course Attributes)      A5B29B8Q.BZ000BSZ * 
 * Transform:       User Written                                            * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_CRSE_ATTRIBUTE -               A5B29B8Q.BS000469 * 
 *                   work.CBM002_CRSE_ATTRIBUTE                             * 
 * Target Table:    User Written -                        A5B29B8Q.BS00046A * 
 *                   work.CBM002_COURSE_ATTRIBUTE                           * 
 *                                                                          * 
 * User Written:    SourceCode                                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BSZ);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_CRSE_ATTRIBUTE, DATA)) or 
         %sysfunc(exist(work.CBM002_CRSE_ATTRIBUTE, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_CRSE_ATTRIBUTE out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.CBM002_CRSE_ATTRIBUTE); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|UserWritten), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%let _INPUT_count = 1;
%let _INPUT = work.CBM002_CRSE_ATTRIBUTE;
%let _INPUT_connect = ;
%let _INPUT_engine = ;
%let _INPUT_memtype = DATA;
%let _INPUT_options = %nrquote();
%let _INPUT_alter = %nrquote();
%let _INPUT_path = %nrquote(/CBM002_CRSE_ATTRIBUTE_A5B29B8Q.BS000469%(WorkTable%));
%let _INPUT_type = 1;
%let _INPUT_label = %nrquote();
%let _INPUT_filetype = WorkTable;

%let _INPUT1 = work.CBM002_CRSE_ATTRIBUTE;
%let _INPUT1_connect = ;
%let _INPUT1_engine = ;
%let _INPUT1_memtype = DATA;
%let _INPUT1_options = %nrquote();
%let _INPUT1_alter = %nrquote();
%let _INPUT1_path = %nrquote(/CBM002_CRSE_ATTRIBUTE_A5B29B8Q.BS000469%(WorkTable%));
%let _INPUT1_type = 1;
%let _INPUT1_label = %nrquote();
%let _INPUT1_filetype = WorkTable;

%let _OUTPUT_count = 1;
%let _OUTPUT = work.CBM002_COURSE_ATTRIBUTE;
%let _OUTPUT_connect = ;
%let _OUTPUT_engine = ;
%let _OUTPUT_memtype = DATA;
%let _OUTPUT_options = %nrquote();
%let _OUTPUT_alter = %nrquote();
%let _OUTPUT_path = %nrquote(/User Written_A5B29B8Q.BS00046A%(WorkTable%));
%let _OUTPUT_type = 1;
%let _OUTPUT_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT_keep = CRSE_ID CRSE_ATTR_LIST CRSE_VAL_LIST;
%let _OUTPUT_col_count = 3;
%let _OUTPUT_col0_name = CRSE_ID;
%let _OUTPUT_col0_table = work.CBM002_COURSE_ATTRIBUTE;
%let _OUTPUT_col0_length = 6;
%let _OUTPUT_col0_type = $;
%let _OUTPUT_col0_format = $6.;
%let _OUTPUT_col0_informat = $6.;
%let _OUTPUT_col0_label = %nrquote(CRSE_ID);
%let _OUTPUT_col0_exp = ;
%let _OUTPUT_col0_input_count = 0;
%let _OUTPUT_col1_name = CRSE_ATTR_LIST;
%let _OUTPUT_col1_table = work.CBM002_COURSE_ATTRIBUTE;
%let _OUTPUT_col1_length = 50;
%let _OUTPUT_col1_type = $;
%let _OUTPUT_col1_format = ;
%let _OUTPUT_col1_informat = ;
%let _OUTPUT_col1_label = %nrquote(CRSE_ATTR_LIST);
%let _OUTPUT_col1_exp = ;
%let _OUTPUT_col1_input_count = 0;
%let _OUTPUT_col2_name = CRSE_VAL_LIST;
%let _OUTPUT_col2_table = work.CBM002_COURSE_ATTRIBUTE;
%let _OUTPUT_col2_length = 50;
%let _OUTPUT_col2_type = $;
%let _OUTPUT_col2_format = ;
%let _OUTPUT_col2_informat = ;
%let _OUTPUT_col2_label = %nrquote(CRSE_VAL_LIST);
%let _OUTPUT_col2_exp = ;
%let _OUTPUT_col2_input_count = 0;
%let _OUTPUT_filetype = WorkTable;

%let _OUTPUT1 = work.CBM002_COURSE_ATTRIBUTE;
%let _OUTPUT1_connect = ;
%let _OUTPUT1_engine = ;
%let _OUTPUT1_memtype = DATA;
%let _OUTPUT1_options = %nrquote();
%let _OUTPUT1_alter = %nrquote();
%let _OUTPUT1_path = %nrquote(/User Written_A5B29B8Q.BS00046A%(WorkTable%));
%let _OUTPUT1_type = 1;
%let _OUTPUT1_label = %nrquote();
/* List of target columns to keep  */ 
%let _OUTPUT1_keep = CRSE_ID CRSE_ATTR_LIST CRSE_VAL_LIST;
%let _OUTPUT1_col_count = 3;
%let _OUTPUT1_col0_name = CRSE_ID;
%let _OUTPUT1_col0_table = work.CBM002_COURSE_ATTRIBUTE;
%let _OUTPUT1_col0_length = 6;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $6.;
%let _OUTPUT1_col0_informat = $6.;
%let _OUTPUT1_col0_label = %nrquote(CRSE_ID);
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input_count = 0;
%let _OUTPUT1_col1_name = CRSE_ATTR_LIST;
%let _OUTPUT1_col1_table = work.CBM002_COURSE_ATTRIBUTE;
%let _OUTPUT1_col1_length = 50;
%let _OUTPUT1_col1_type = $;
%let _OUTPUT1_col1_format = ;
%let _OUTPUT1_col1_informat = ;
%let _OUTPUT1_col1_label = %nrquote(CRSE_ATTR_LIST);
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input_count = 0;
%let _OUTPUT1_col2_name = CRSE_VAL_LIST;
%let _OUTPUT1_col2_table = work.CBM002_COURSE_ATTRIBUTE;
%let _OUTPUT1_col2_length = 50;
%let _OUTPUT1_col2_type = $;
%let _OUTPUT1_col2_format = ;
%let _OUTPUT1_col2_informat = ;
%let _OUTPUT1_col2_label = %nrquote(CRSE_VAL_LIST);
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/ 

data work.CBM002_COURSE_ATTRIBUTE;
	set work.CBM002_CRSE_ATTRIBUTE;
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
 * Step:            Max Eff Dated -Course Catalog         A5B29B8Q.BZ000BT0 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    PS_CRSE_CATALOG_Extract -             A5B29B8Q.BE000008 * 
 *                   ADWSTGPR.PS_CRSE_CATALOG_Extract                       * 
 * Target Table:    CBM002_CORE_COURSE -                  A5B29B8Q.BS00046B * 
 *                   work.CBM002_CORE_COURSE                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT0);
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
   delete CBM002_CORE_COURSE;
quit;

proc sql;
   create view work.CBM002_CORE_COURSE as
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
 * Step:            Course_Info                           A5B29B8Q.BZ000BT1 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   User Written -                        A5B29B8Q.BS000468 * 
 *                   work.CBM002_CLASS_ATTRIBUTES                           * 
 *                  User Written -                        A5B29B8Q.BS00046A * 
 *                   work.CBM002_COURSE_ATTRIBUTE                           * 
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 * 
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          * 
 *                  PS_CLASS_ASSOC_Extract -              A5B29B8Q.BE00000A * 
 *                   ADWSTGPR.PS_CLASS_ASSOC_Extract                        * 
 *                  PS_UTA_CB_LOC_VW_Extract -            A5B29B8Q.BE00000B * 
 *                   ADWSTGPR.PS_UTA_CB_LOC_VW_Extract                      * 
 *                  PS_UTZ_PT100_DTL_Extract -            A5B29B8Q.BE00000C * 
 *                   ADWSTGPR.PS_UTZ_PT100_DTL_Extract                      * 
 *                  PS_SCTN_CMBND_Extract -               A5B29B8Q.BE00000D * 
 *                   ADWSTGPR.PS_SCTN_CMBND_Extract                         * 
 *                  CBM002_CORE_COURSE -                  A5B29B8Q.BS00046B * 
 *                   work.CBM002_CORE_COURSE                                * 
 * Target Table:    CBM002_Course_Info -                  A5B29B8Q.BS00046C * 
 *                   work.CBM002_Course_Info                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT1);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_CLASS_ATTRIBUTES, DATA)) or 
         %sysfunc(exist(work.CBM002_CLASS_ATTRIBUTES, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_CLASS_ATTRIBUTES out = work.etls_contents(keep = nobs) noprint; 
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
   delete CBM002_Course_Info;
quit;

proc sql;
   create table work.CBM002_Course_Info as
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
      CBM002_CLASS_ATTRIBUTES.ATTR_LIST as CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM002_CLASS_ATTRIBUTES.VAL_LIST as CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM002_COURSE_ATTRIBUTE.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM002_COURSE_ATTRIBUTE.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      case when FIND(UPCASE(CBM002_CLASS_ATTRIBUTES.VAL_LIST),'EXCLUDE' )<>0 then 'Yes'
      else 'No' end as CB_Exclude length = 8   
         label = 'CB_Exclude',
      case when PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_RESULT IS NOT MISSING then 'Yes' 
      else 'No' 
      end as NCBO length = 8   
         label = 'NCBO',
      case  
      when CBM002_CORE_COURSE.RQMNT_DESIGNTN in ('020','2092', '092') then 1 
      else 0  
      end as MathCore length = 8   
         label = 'MathCore',
      case 
      when CBM002_CORE_COURSE.RQMNT_DESIGNTN in ('040','060','070','080','098','4094','8098') then 1
      else 0 
      end as ReadCore length = 8   
         label = 'ReadCore',
      case 
      when CBM002_CORE_COURSE.RQMNT_DESIGNTN in ('010','1091') then 1
      else 0 
      end as WriteCore length = 8   
         label = 'WriteCore'
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
      work.CBM002_CLASS_ATTRIBUTES as CBM002_CLASS_ATTRIBUTES
         on
         (
            PS_CLASS_TBL_Extract.STRM = CBM002_CLASS_ATTRIBUTES.STRM
            and PS_CLASS_TBL_Extract.CRSE_ID = CBM002_CLASS_ATTRIBUTES.CRSE_ID
            and PS_CLASS_TBL_Extract.CRSE_OFFER_NBR = CBM002_CLASS_ATTRIBUTES.CRSE_OFFER_NBR
            and PS_CLASS_TBL_Extract.SESSION_CODE = CBM002_CLASS_ATTRIBUTES.SESSION_CODE
            and PS_CLASS_TBL_Extract.CLASS_SECTION = CBM002_CLASS_ATTRIBUTES.CLASS_SECTION
         ) left join 
      ADWSTGPR.PS_UTZ_PT100_DTL_Extract as PS_UTZ_PT100_DTL_Extract
         on
         (
            PS_CLASS_TBL_Extract.CATALOG_NBR = PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_RESULT
            and PS_CLASS_TBL_Extract.SUBJECT = PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_RESULT
            and SUBSTR(CBM002_CLASS_ATTRIBUTES.CLASS_SECTION,1) = 'C'
            and PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_ID = 'UTA_R0202'
            and PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_VALUE = 'NCBO'
            and PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_VALUE = 'ARL'
         ) left join 
      ADWSTGPR.PS_SCTN_CMBND_Extract as PS_SCTN_CMBND_Extract
         on
         (
            PS_CLASS_TBL_Extract.STRM = PS_SCTN_CMBND_Extract.STRM
            and PS_CLASS_TBL_Extract.SESSION_CODE = PS_SCTN_CMBND_Extract.SESSION_CODE
            and PS_CLASS_TBL_Extract.CLASS_NBR = PS_SCTN_CMBND_Extract.CLASS_NBR
         ) left join 
      work.CBM002_COURSE_ATTRIBUTE as CBM002_COURSE_ATTRIBUTE
         on
         (
            PS_CLASS_TBL_Extract.CRSE_ID = CBM002_COURSE_ATTRIBUTE.CRSE_ID
         ) left join 
      work.CBM002_CORE_COURSE as CBM002_CORE_COURSE
         on
         (
            CBM002_COURSE_ATTRIBUTE.CRSE_ID = CBM002_CORE_COURSE.CRSE_ID
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
 * Step:            Enrollment_Current_term               A5B29B8Q.BZ000BT2 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  Term_Setup - work.Term_Setup          A5B29B8Q.BS000466 * 
 * Target Table:    CBM002_StudentEnrollment -            A5B29B8Q.BS00046D * 
 *                   work.CBM002_StudentEnrollment                          * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT2);
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
   delete CBM002_StudentEnrollment;
quit;

proc sql;
   create table work.CBM002_StudentEnrollment as
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
            and PS_STDNT_ENRL_Extract.INSTITUTION = 'UTARL'
            and PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS = 'E'
            and (PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST <> 'CENS'
            or PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST IS MISSING )
            and PS_STDNT_ENRL_Extract.ACAD_CAREER = 'UGRD'
            and PS_STDNT_ENRL_Extract.UNT_TAKEN > 0
         )
   where
      (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
      or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Enrollment_Current_term **/

/*==========================================================================* 
 * Step:            Prior Core Course Enrollment          A5B29B8Q.BZ000BT3 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_StudentEnrollment -            A5B29B8Q.BS00046D * 
 *                   work.CBM002_StudentEnrollment                          * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 *                  CBM002_Course_Info -                  A5B29B8Q.BS00046C * 
 *                   work.CBM002_Course_Info                                * 
 * Target Table:    PriorCoreCourseEnrollment -           A5B29B8Q.BS00046E * 
 *                   work.PriorCoreCourseEnrollment                         * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT3);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_StudentEnrollment, DATA)) or 
         %sysfunc(exist(work.CBM002_StudentEnrollment, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_StudentEnrollment out = work.etls_contents(keep = nobs) noprint; 
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
   delete PriorCoreCourseEnrollment;
quit;

proc sql;
   create table work.PriorCoreCourseEnrollment as
   select distinct
      CBM002_StudentEnrollment.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_StudentEnrollment.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      MAX( 
      case 
      	when CBM002_Course_Info.MathCore = 1 
      	and PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF in ('A', 'B', 'C') 
      	or (PS_STDNT_ENRL_Extract.STRM in ('2202', '2205','2208' )
      	and PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF = 'P')
      then 1  
      else 0  
      end) as MathCoreCoursePriorEnrolled length = 8   
         label = 'MathCoreCoursePriorEnrolled',
      MAX(
      case
      	when CBM002_Course_Info.ReadCore = 1
      	and PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF in ('A', 'B', 'C') 
      	or (PS_STDNT_ENRL_Extract.STRM in ('2202', '2205','2208' )
      	and PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF = 'P')
      then 1  
      else 0 
      end) as ReadCoreCoursePriorEnrolled length = 8   
         label = 'ReadCoreCoursePriorEnrolled',
      MAX( 
      case 
      	when CBM002_Course_Info.WriteCore = 1
      	and PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF in ('A', 'B', 'C') 
      	or (PS_STDNT_ENRL_Extract.STRM in ('2202', '2205','2208' )
      	and PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF = 'P')
      then 1  
      else 0  
      end) as WriteCoreCoursePriorEnrolled length = 8   
         label = 'WriteCoreCoursePriorEnrolled'
   from
      work.CBM002_StudentEnrollment as CBM002_StudentEnrollment left join 
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract
         on
         (
            CBM002_StudentEnrollment.EMPLID = PS_STDNT_ENRL_Extract.EMPLID
            and CBM002_StudentEnrollment.ACAD_CAREER = PS_STDNT_ENRL_Extract.ACAD_CAREER
            and PS_STDNT_ENRL_Extract.STRM < "&current_term"
            and PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS = 'E'
            and PS_STDNT_ENRL_Extract.UNT_TAKEN > 0
         ) inner join 
      work.CBM002_Course_Info as CBM002_Course_Info
         on
         (
            PS_STDNT_ENRL_Extract.STRM = CBM002_Course_Info.STRM
            and PS_STDNT_ENRL_Extract.SESSION_CODE = CBM002_Course_Info.SESSION_CODE
            and PS_STDNT_ENRL_Extract.CLASS_NBR = CBM002_Course_Info.CLASS_NBR
         )
   where
      PS_STDNT_ENRL_Extract.STRM <= "&prior_term"
      and CBM002_Course_Info.END_DT <= &prior_term_end_date.
      and (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
      or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
   group by
      CBM002_StudentEnrollment.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Prior Core Course Enrollment **/

/*==========================================================================* 
 * Step:            Prior Enrolled                        A5B29B8Q.BZ000BT4 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_StudentEnrollment -            A5B29B8Q.BS00046D * 
 *                   work.CBM002_StudentEnrollment                          * 
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E * 
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         * 
 * Target Table:    PriorEnrolled - work.PriorEnrolled    A5B29B8Q.BS00046F * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT4);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_StudentEnrollment, DATA)) or 
         %sysfunc(exist(work.CBM002_StudentEnrollment, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_StudentEnrollment out = work.etls_contents(keep = nobs) noprint; 
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
   delete PriorEnrolled;
quit;

proc sql;
   create table work.PriorEnrolled as
   select distinct
      CBM002_StudentEnrollment.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_StudentEnrollment.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      case  
      when PS_STDNT_ENRL_Extract.EMPLID is not missing then 'Y'  
      else 'N' 
      end as PriorEnrolled length = 1   
         label = 'PriorEnrolled'
   from
      work.CBM002_StudentEnrollment as CBM002_StudentEnrollment left join 
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract
         on
         (
            CBM002_StudentEnrollment.EMPLID = PS_STDNT_ENRL_Extract.EMPLID
            and PS_STDNT_ENRL_Extract.STRM < "&current_term"
         )
   where
      (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
      or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Prior Enrolled **/

/*==========================================================================* 
 * Step:            Enrollment+Course                     A5B29B8Q.BZ000BT5 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_Course_Info -                  A5B29B8Q.BS00046C * 
 *                   work.CBM002_Course_Info                                * 
 *                  CBM002_StudentEnrollment -            A5B29B8Q.BS00046D * 
 *                   work.CBM002_StudentEnrollment                          * 
 *                  PriorCoreCourseEnrollment -           A5B29B8Q.BS00046E * 
 *                   work.PriorCoreCourseEnrollment                         * 
 *                  PriorEnrolled - work.PriorEnrolled    A5B29B8Q.BS00046F * 
 * Target Table:    CBM002_Enrollment -                   A5B29B8Q.BS00046G * 
 *                   work.CBM002_Enrollment                                 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT5);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_Course_Info, DATA)) or 
         %sysfunc(exist(work.CBM002_Course_Info, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_Course_Info out = work.etls_contents(keep = nobs) noprint; 
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
   delete CBM002_Enrollment;
quit;

data _null_;
   put "NOTE: The following column(s) do not have a column mapping, so the"
        " value(s) will be set to missing: Core_Course";
run;

proc sql;
   create table work.CBM002_Enrollment as
   select
      CBM002_StudentEnrollment.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_StudentEnrollment.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_StudentEnrollment.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_StudentEnrollment.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_StudentEnrollment.ENRL_STATUS_REASON length = 4   
         format = $4.
         informat = $4.
         label = 'ENRL_STATUS_REASON',
      CBM002_StudentEnrollment.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_StudentEnrollment.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_Course_Info.SESSION_CODE length = 3   
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CBM002_Course_Info.SUBJECT length = 8   
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CBM002_Course_Info.CLASS_NBR length = 8   
         label = 'CLASS_NBR',
      CBM002_Course_Info.CATALOG_NBR length = 10   
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CBM002_StudentEnrollment.UNT_EARNED length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_EARNED',
      CBM002_StudentEnrollment.UNT_PRGRSS length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_PRGRSS',
      CBM002_StudentEnrollment.UNT_TAKEN length = 8   
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      CBM002_Course_Info.START_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CBM002_Course_Info.END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CBM002_StudentEnrollment.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_StudentEnrollment.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_StudentEnrollment.Current_Term_End_Date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_Course_Info.CLASS_SECTION length = 4   
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CBM002_Course_Info.CLASS_STAT length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      CBM002_Course_Info.CLASS_TYPE length = 1   
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      CBM002_StudentEnrollment.GRADE_CATEGORY length = 4   
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      CBM002_StudentEnrollment.GRADE_POINTS length = 8   
         format = 12.3
         informat = 12.3
         label = 'GRADE_POINTS',
      CBM002_Course_Info.CRSE_ID length = 6   
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CBM002_Course_Info.CRSE_OFFER_NBR length = 8   
         label = 'CRSE_OFFER_NBR',
      CBM002_Course_Info.INSTRUCTION_MODE length = 2   
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      CBM002_Course_Info.LOCATION length = 10   
         format = $10.
         informat = $10.
         label = 'LOCATION',
      CBM002_Course_Info.ENRL_TOT length = 8   
         label = 'ENRL_TOT',
      CBM002_Course_Info.SSR_COMPONENT length = 3   
         format = $3.
         informat = $3.
         label = 'SSR_COMPONENT',
      CBM002_Course_Info.COMPONENT_PRIMARY length = 3   
         format = $3.
         informat = $3.
         label = 'COMPONENT_PRIMARY',
      CBM002_Course_Info.CRSE_CONTACT_HRS length = 8   
         format = 7.2
         informat = 7.2
         label = 'CRSE_CONTACT_HRS',
      CBM002_Course_Info.UNITS_MAXIMUM length = 8   
         format = 7.2
         informat = 7.2
         label = 'UNITS_MAXIMUM',
      CBM002_Course_Info.ACAD_GROUP length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CBM002_Course_Info.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_Course_Info.CAMPUS length = 5   
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      CBM002_Course_Info.OFFSITE_LOC_CD length = 8   
         label = 'OFFSITE_LOC_CD',
      CBM002_Course_Info.EXT_LOC_FICE length = 8   
         label = 'EXT_LOC_FICE',
      CBM002_Course_Info.UTA_CB_LOCATION_CD length = 8   
         label = 'UTA_CB_LOCATION_CD',
      CBM002_Course_Info.CB_Exclude length = 8   
         label = 'CB_Exclude',
      CBM002_StudentEnrollment.REPEAT_CANDIDATE length = 1   
         format = $1.
         informat = $1.
         label = 'REPEAT_CANDIDATE',
      CBM002_Course_Info.CLASS_ATTR_LIST length = 50   
         label = 'CLASS_ATTR_LIST',
      CBM002_Course_Info.CLASS_VAL_LIST length = 100   
         label = 'CLASS_VAL_LIST',
      CBM002_StudentEnrollment.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_Course_Info.NCBO length = 8   
         label = 'NCBO',
      CBM002_StudentEnrollment.CRSE_GRADE_OFF length = 3   
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      CBM002_Course_Info.COMBINED_SECTION_ID length = 4   
         format = $4.
         informat = $4.
         label = 'COMBINED_SECTION_ID',
      CBM002_Course_Info.CRSE_ATTR_LIST length = 50   
         label = 'CRSE_ATTR_LIST',
      CBM002_Course_Info.CRSE_VAL_LIST length = 50   
         label = 'CRSE_VAL_LIST',
      CBM002_StudentEnrollment.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      "" as Core_Course length = 8   
         label = 'Core_Course',
      case when (CBM002_StudentEnrollment.STRM=CBM002_StudentEnrollment.Current_Term and STRIP(CBM002_StudentEnrollment.SESSION_CODE)='1' and substr(CBM002_StudentEnrollment.STRM,4,1) in ('2','8'))  
      or (CBM002_StudentEnrollment.STRM=CBM002_StudentEnrollment.Current_Term and STRIP(CBM002_StudentEnrollment.SESSION_CODE)='5W2' and substr(CBM002_StudentEnrollment.STRM,4,1)='5') 
      or (CBM002_StudentEnrollment.STRM=CBM002_StudentEnrollment.Current_Term and CBM002_StudentEnrollment.SESSION_CODE <> '1' and substr(CBM002_StudentEnrollment.STRM,4,1) in ('2','8') and CBM002_Course_Info.END_DT<=CBM002_StudentEnrollment.Current_Term_End_Date)   
      or (CBM002_StudentEnrollment.STRM=CBM002_StudentEnrollment.Current_Term and CBM002_StudentEnrollment.SESSION_CODE <> '5W2' and substr(CBM002_StudentEnrollment.STRM,4,1) ='5' and CBM002_Course_Info.END_DT<=CBM002_StudentEnrollment.Current_Term_End_Date) 
      or ( input(CBM002_StudentEnrollment.Current_Term,BEST8.) - INPUT(CBM002_StudentEnrollment.STRM,BEST8.) > 0 and CBM002_StudentEnrollment.SESSION_CODE <> '5W2' and  substr(CBM002_StudentEnrollment.Current_Term,4,1)  in ('2','8') 
      and CBM002_Course_Info.END_DT <=CBM002_StudentEnrollment.Current_Term_End_Date and CBM002_Course_Info.END_DT > CBM002_StudentEnrollment.TERM_END_DT )  
      or ( input(CBM002_StudentEnrollment.Current_Term,BEST8.) - INPUT(CBM002_StudentEnrollment.STRM,BEST8.) > 0 and CBM002_StudentEnrollment.SESSION_CODE <> '1' and substr(CBM002_StudentEnrollment.Current_Term,4,1) ='5'  
      and CBM002_Course_Info.END_DT <=CBM002_StudentEnrollment.Current_Term_End_Date and CBM002_Course_Info.END_DT > CBM002_StudentEnrollment.TERM_END_DT )  
      then 'Yes'  
      else 'No'  
      end as Current_Term_Reportable length = 8,
      case 
      when CBM002_Course_Info.MathCore =1 
      and CBM002_StudentEnrollment.CRSE_GRADE_OFF in ('A', 'B', 'C') 
      or (CBM002_StudentEnrollment.STRM in ('2202', '2205','2208' )
      and CBM002_StudentEnrollment.CRSE_GRADE_OFF = 'P')
      then 1
      else 0 end as MathCoreCourseEnrolled length = 3   
         label = 'MathCoreCourseEnrolled',
      case  
      when CBM002_Course_Info.ReadCore = 1
      and CBM002_StudentEnrollment.CRSE_GRADE_OFF in ('A', 'B', 'C')
      or (CBM002_StudentEnrollment.STRM in ('2202', '2205','2208' )
      and CBM002_StudentEnrollment.CRSE_GRADE_OFF = 'P')
      then 1
      else 0 end as ReadCoreCourseEnrolled length = 3   
         label = 'ReadCoreCourseEnrolled',
      case 
      when CBM002_Course_Info.WriteCore = 1
      and CBM002_StudentEnrollment.CRSE_GRADE_OFF in ('A', 'B', 'C')
      or (CBM002_StudentEnrollment.STRM in ('2202', '2205','2208' )
      and CBM002_StudentEnrollment.CRSE_GRADE_OFF = 'P')
      then 1
      else 0 end as WriteCoreCourseEnrolled length = 3   
         label = 'WriteCoreCourseEnrolled',
      case 
      when PriorCoreCourseEnrollment.MathCoreCoursePriorEnrolled =1 then 'Y' 
      else 'N' 
      end as MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      case 
      when PriorCoreCourseEnrollment.ReadCoreCoursePriorEnrolled  =1 then 'Y' 
      else 'N' 
      end as ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      case 
      when PriorCoreCourseEnrollment.WriteCoreCoursePriorEnrolled  =1 then 'Y' 
      else 'N' 
      end as WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      PriorEnrolled.PriorEnrolled length = 1   
         label = 'PriorEnrolled'
   from
      work.CBM002_StudentEnrollment as CBM002_StudentEnrollment inner join 
      work.CBM002_Course_Info as CBM002_Course_Info
         on
         (
            CBM002_StudentEnrollment.STRM = CBM002_Course_Info.STRM
            and CBM002_StudentEnrollment.SESSION_CODE = CBM002_Course_Info.SESSION_CODE
            and CBM002_StudentEnrollment.CLASS_NBR = CBM002_Course_Info.CLASS_NBR
            and CBM002_Course_Info.INSTITUTION = 'UTARL'
            and CBM002_StudentEnrollment.STDNT_ENRL_STATUS = 'E'
            and CBM002_StudentEnrollment.UNT_TAKEN > 0
            and (CBM002_StudentEnrollment.ENRL_ACTN_RSN_LAST <> 'CENS'
            or CBM002_StudentEnrollment.ENRL_ACTN_RSN_LAST IS MISSING )
            and CBM002_Course_Info.CLASS_STAT IN ('A','S')
            and CBM002_Course_Info.CLASS_TYPE IN ('E','N')
            and CBM002_StudentEnrollment.ACAD_CAREER = 'UGRD'
         ) left join 
      work.PriorCoreCourseEnrollment as PriorCoreCourseEnrollment
         on
         (
            CBM002_StudentEnrollment.EMPLID = PriorCoreCourseEnrollment.EMPLID
            and CBM002_StudentEnrollment.ACAD_CAREER = PriorCoreCourseEnrollment.ACAD_CAREER
         ) left join 
      work.PriorEnrolled as PriorEnrolled
         on
         (
            CBM002_StudentEnrollment.EMPLID = PriorEnrolled.EMPLID
            and CBM002_StudentEnrollment.ACAD_CAREER = PriorEnrolled.ACAD_CAREER
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Enrollment+Course **/

/*==========================================================================* 
 * Step:            CB Reported Logic                     A5B29B8Q.BZ000BT6 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_Enrollment -                   A5B29B8Q.BS00046G * 
 *                   work.CBM002_Enrollment                                 * 
 * Target Table:    CBM002_Cohort - work.CBM002_Cohort    A5B29B8Q.BS00046H * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT6);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_Enrollment, DATA)) or 
         %sysfunc(exist(work.CBM002_Enrollment, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_Enrollment out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.CBM002_Enrollment); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM002_Cohort;
quit;

proc sql;
   create table work.CBM002_Cohort as
   select distinct
      CBM002_Enrollment.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_Enrollment.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_Enrollment.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_Enrollment.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_Enrollment.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_Enrollment.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_Enrollment.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_Enrollment.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_Enrollment.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_Enrollment.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      case  
      	when MAX(CBM002_Enrollment.MathCoreCourseEnrolled)=1 then 'Y' 
      else 'N' 
      end as MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      case  
      	when  MAX(CBM002_Enrollment.ReadCoreCourseEnrolled)=1 then 'Y' 
      else 'N' 
      end as ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      case  
      	when  MAX(CBM002_Enrollment.WriteCoreCourseEnrolled)=1 then 'Y' 
      else 'N' 
      end as WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_Enrollment.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_Enrollment.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_Enrollment.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_Enrollment.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      case    
      
      when input(CBM002_Enrollment.Current_Term,BEST8.) - INPUT(CBM002_Enrollment.STRM,BEST8.) > 0 and CBM002_Enrollment.START_DT <=CBM002_Enrollment.CENSUS_DT  
      and CBM002_Enrollment.END_DT>CBM002_Enrollment.TERM_END_DT and CBM002_Enrollment.END_DT<=CBM002_Enrollment.Current_Term_End_date then '6'      
        
      when input(CBM002_Enrollment.Current_Term,BEST8.) - INPUT(CBM002_Enrollment.STRM,BEST8.) > 0 and CBM002_Enrollment.START_DT > CBM002_Enrollment.CENSUS_DT  
      and CBM002_Enrollment.END_DT>CBM002_Enrollment.TERM_END_DT and CBM002_Enrollment.END_DT<=CBM002_Enrollment.Current_Term_End_date then '6'      
      else ' '      
      end as Flex length = 1   
         label = 'Flex',
      /*case   
      	when CBM002_Enrollment.SESSION_CODE ='DYN' and CBM002_Enrollment.END_DT>CBM002_Enrollment.TERM_END_DT  
      	and CBM002_Enrollment.END_DT <=CBM002_Enrollment.Current_Term_End_date   
      	and SUBSTR(CBM002_Enrollment.STRM,4,1)='8'   
      	then Put(input(cat('20',substr(CBM002_Enrollment.STRM ,2,2)),4.)+1,4.)     
      else  cat('20',substr(CBM002_Enrollment.STRM ,2,2))   
      end
      */
      
      cats('20',substr(CBM002_Enrollment.Current_Term ,2,2)) as Year length = 4   
         label = 'Year'
   from
      work.CBM002_Enrollment as CBM002_Enrollment
   where
      CBM002_Enrollment.Current_Term_Reportable = 'Yes'
   group by
      CBM002_Enrollment.Current_Term,
      CBM002_Enrollment.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end CB Reported Logic **/

/*==========================================================================* 
 * Step:            Acad Plan Info                        A5B29B8Q.BZ000BT7 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_ACAD_PLAN_Extract -                A5B29B8Q.BE00000G * 
 *                   ADWSTGPR.PS_ACAD_PLAN_Extract                          * 
 *                  CBM002_Cohort - work.CBM002_Cohort    A5B29B8Q.BS00046H * 
 * Target Table:    CBM002_max_acad_plan -                A5B29B8Q.BS00046I * 
 *                   work.CBM002_max_acad_plan                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT7);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_ACAD_PLAN_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_ACAD_PLAN_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_ACAD_PLAN_Extract;
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
   delete CBM002_max_acad_plan;
quit;

proc sql;
   create table work.CBM002_max_acad_plan as
   select distinct
      CBM002_Cohort.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_Cohort.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_Cohort.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_Cohort.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_Cohort.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_Cohort.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_Cohort.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_Cohort.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_Cohort.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
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
      CBM002_Cohort.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_Cohort.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_Cohort.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_Cohort.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_Cohort.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_Cohort.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_Cohort.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_Cohort.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_Cohort.Flex length = 1   
         label = 'Flex',
      CBM002_Cohort.Year length = 4   
         label = 'Year'
   from
      work.CBM002_Cohort as CBM002_Cohort left join 
      (
         select *
         from
            (
               select *
               from
                  ADWSTGPR.PS_ACAD_PLAN_Extract
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
            CBM002_Cohort.EMPLID = ACAD_PLAN_MIN_PLANSEQ.EMPLID
            and CBM002_Cohort.ACAD_CAREER = ACAD_PLAN_MIN_PLANSEQ.ACAD_CAREER
            and CBM002_Cohort.Current_Term_End_date >= ACAD_PLAN_MIN_PLANSEQ.EFFDT
         )
   group by
      CBM002_Cohort.STRM,
      CBM002_Cohort.EMPLID,
      CBM002_Cohort.ACAD_CAREER,
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
 * Step:            AcadPlan_tbl                          A5B29B8Q.BZ000BT8 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_max_acad_plan -                A5B29B8Q.BS00046I * 
 *                   work.CBM002_max_acad_plan                              * 
 *                  PS_ACAD_PLAN_TBL_Extract -            A5B29B8Q.BE00000H * 
 *                   ADWSTGPR.PS_ACAD_PLAN_TBL_Extract                      * 
 * Target Table:    CBM002_acad_plan -                    A5B29B8Q.BS00046J * 
 *                   work.CBM002_acad_plan                                  * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT8);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_max_acad_plan, DATA)) or 
         %sysfunc(exist(work.CBM002_max_acad_plan, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_max_acad_plan out = work.etls_contents(keep = nobs) noprint; 
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
   delete CBM002_acad_plan;
quit;

proc sql;
   create table work.CBM002_acad_plan as
   select
      CBM002_max_acad_plan.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_max_acad_plan.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_max_acad_plan.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_max_acad_plan.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_max_acad_plan.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_max_acad_plan.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_max_acad_plan.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_max_acad_plan.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_max_acad_plan.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_max_acad_plan.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_max_acad_plan.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_max_acad_plan.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_max_acad_plan.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_max_acad_plan.REQ_TERM length = 4   
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
      CBM002_max_acad_plan.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_max_acad_plan.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_max_acad_plan.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_max_acad_plan.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_max_acad_plan.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_max_acad_plan.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_max_acad_plan.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_max_acad_plan.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_max_acad_plan.Flex length = 1   
         label = 'Flex',
      CBM002_max_acad_plan.Year length = 4   
         label = 'Year'
   from
      work.CBM002_max_acad_plan as CBM002_max_acad_plan inner join 
      ADWSTGPR.PS_ACAD_PLAN_TBL_Extract
         on
         (
            CBM002_max_acad_plan.ACAD_PLAN = PS_ACAD_PLAN_TBL_Extract.ACAD_PLAN
            and CBM002_max_acad_plan.Current_Term_End_date >= PS_ACAD_PLAN_TBL_Extract.EFFDT
         )
   group by
      CBM002_max_acad_plan.ACAD_PLAN,
      CBM002_max_acad_plan.TERM_END_DT
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
 * Step:            Plan Owner, Carterm                   A5B29B8Q.BZ000BT9 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_acad_plan -                    A5B29B8Q.BS00046J * 
 *                   work.CBM002_acad_plan                                  * 
 *                  PS_ACAD_PLAN_OWNER_Extract -          A5B29B8Q.BE00000I * 
 *                   ADWSTGPR.PS_ACAD_PLAN_OWNER_Extract                    * 
 *                  PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J * 
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          * 
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K * 
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     * 
 * Target Table:    CBM002_ACAD_PLAN_INFO -               A5B29B8Q.BS00046K * 
 *                   work.CBM002_ACAD_PLAN_INFO                             * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BT9);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_acad_plan, DATA)) or 
         %sysfunc(exist(work.CBM002_acad_plan, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_acad_plan out = work.etls_contents(keep = nobs) noprint; 
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
   delete CBM002_ACAD_PLAN_INFO;
quit;

proc sql;
   create table work.CBM002_ACAD_PLAN_INFO as
   select
      CBM002_acad_plan.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_acad_plan.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_acad_plan.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_acad_plan.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_acad_plan.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_acad_plan.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_acad_plan.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_acad_plan.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      PS_ACAD_PLAN_OWNER_Extract.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_acad_plan.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      PS_ACAD_PLAN_OWNER_Extract.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_acad_plan.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_acad_plan.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_acad_plan.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_acad_plan.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_acad_plan.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM002_acad_plan.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM002_acad_plan.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM002_acad_plan.ACAD_PLAN_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_PLAN_TYPE',
      PS_ACAD_PROG_Extract.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      PS_ACAD_PROG_Extract.DEGR_CHKOUT_STAT length = 2   
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
      CBM002_acad_plan.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_acad_plan.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_acad_plan.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_acad_plan.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_acad_plan.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_acad_plan.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_acad_plan.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_acad_plan.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_acad_plan.Flex length = 1   
         label = 'Flex',
      CBM002_acad_plan.Year length = 4   
         label = 'Year'
   from
      work.CBM002_acad_plan as CBM002_acad_plan inner join 
      ADWSTGPR.PS_ACAD_PLAN_OWNER_Extract
         on
         (
            CBM002_acad_plan.ACAD_PLAN = PS_ACAD_PLAN_OWNER_Extract.ACAD_PLAN
            and CBM002_acad_plan.PLAN_TBL_EFFDT = PS_ACAD_PLAN_OWNER_Extract.EFFDT
         ) inner join 
      ADWSTGPR.PS_ACAD_PROG_Extract
         on
         (
            CBM002_acad_plan.EMPLID = PS_ACAD_PROG_Extract.EMPLID
            and CBM002_acad_plan.ACAD_CAREER = PS_ACAD_PROG_Extract.ACAD_CAREER
            and CBM002_acad_plan.STDNT_CAR_NBR = PS_ACAD_PROG_Extract.STDNT_CAR_NBR
            and CBM002_acad_plan.EFFDT = PS_ACAD_PROG_Extract.EFFDT
            and CBM002_acad_plan.EFFSEQ = PS_ACAD_PROG_Extract.EFFSEQ
            and PS_ACAD_PROG_Extract.INSTITUTION = PS_ACAD_PLAN_OWNER_Extract.INSTITUTION
         ) inner join 
      ADWSTGPR.PS_STDNT_CAR_TERM_Extract as PS_STDNT_CAR_TERM_Extract
         on
         (
            CBM002_acad_plan.EMPLID = PS_STDNT_CAR_TERM_Extract.EMPLID
            and CBM002_acad_plan.STRM = PS_STDNT_CAR_TERM_Extract.STRM
            and CBM002_acad_plan.ACAD_CAREER = PS_STDNT_CAR_TERM_Extract.ACAD_CAREER
            and CBM002_acad_plan.STDNT_CAR_NBR = PS_STDNT_CAR_TERM_Extract.STDNT_CAR_NBR
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Plan Owner, Carterm **/

/*==========================================================================* 
 * Step:            SSN                                   A5B29B8Q.BZ000BTA * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_PERS_NID_Extract -                 A5B29B8Q.BE00000R * 
 *                   ADWSTGPR.PS_PERS_NID_Extract                           * 
 *                  PS_EXTERNAL_SYSTEM_Extract -          A5B29B8Q.BE00000S * 
 *                   ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract                    * 
 *                  CBM002_ACAD_PLAN_INFO -               A5B29B8Q.BS00046K * 
 *                   work.CBM002_ACAD_PLAN_INFO                             * 
 * Target Table:    CBM002_SSN - work.CBM002_SSN          A5B29B8Q.BS00046L * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTA);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_PERS_NID_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_PERS_NID_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_PERS_NID_Extract;
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
   delete CBM002_SSN;
quit;

proc sql;
   create table work.CBM002_SSN as
   select distinct
      CBM002_ACAD_PLAN_INFO.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      case
      when substr(PS_PERS_NID_Extract.NATIONAL_ID ,1,2) not  in ('XX','99') and  PS_PERS_NID_Extract.NATIONAL_ID <> ' ' 
      	and (PS_PERS_NID_Extract.NATIONAL_ID is not missing or PS_PERS_NID_Extract.NATIONAL_ID is not null) then PS_PERS_NID_Extract.NATIONAL_ID 
      when substr(External_System.EXTERNAL_SYSTEM_ID  ,1,2) not  in ('XX','99') and External_System.EXTERNAL_SYSTEM_ID <> ' '  
      	and ( External_System.EXTERNAL_SYSTEM_ID  is not missing or  External_System.EXTERNAL_SYSTEM_ID is not null) then External_System.EXTERNAL_SYSTEM_ID 
      else CAT('9',substr(CBM002_ACAD_PLAN_INFO.EMPLID  ,3,8))  
      end as National_Id length = 9   
         label = 'National_Id',
      CBM002_ACAD_PLAN_INFO.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_ACAD_PLAN_INFO.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_ACAD_PLAN_INFO.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_ACAD_PLAN_INFO.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_ACAD_PLAN_INFO.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_ACAD_PLAN_INFO.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_ACAD_PLAN_INFO.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_ACAD_PLAN_INFO.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_ACAD_PLAN_INFO.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_ACAD_PLAN_INFO.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_ACAD_PLAN_INFO.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_ACAD_PLAN_INFO.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_ACAD_PLAN_INFO.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_ACAD_PLAN_INFO.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM002_ACAD_PLAN_INFO.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM002_ACAD_PLAN_INFO.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM002_ACAD_PLAN_INFO.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM002_ACAD_PLAN_INFO.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM002_ACAD_PLAN_INFO.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM002_ACAD_PLAN_INFO.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM002_ACAD_PLAN_INFO.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM002_ACAD_PLAN_INFO.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM002_ACAD_PLAN_INFO.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_ACAD_PLAN_INFO.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_ACAD_PLAN_INFO.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_ACAD_PLAN_INFO.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_ACAD_PLAN_INFO.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_ACAD_PLAN_INFO.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_ACAD_PLAN_INFO.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_ACAD_PLAN_INFO.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_ACAD_PLAN_INFO.Flex length = 1   
         label = 'Flex',
      CBM002_ACAD_PLAN_INFO.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_ACAD_PLAN_INFO.Year length = 4   
         label = 'Year'
   from
      work.CBM002_ACAD_PLAN_INFO as CBM002_ACAD_PLAN_INFO left join 
      ADWSTGPR.PS_PERS_NID_Extract as PS_PERS_NID_Extract
         on
         (
            CBM002_ACAD_PLAN_INFO.EMPLID = PS_PERS_NID_Extract.EMPLID
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
            CBM002_ACAD_PLAN_INFO.EMPLID = External_System.EMPLID
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
 * Step:            Admission Data                        A5B29B8Q.BZ000BTB * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T * 
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      * 
 *                  CBM002_SSN - work.CBM002_SSN          A5B29B8Q.BS00046L * 
 * Target Table:    CBM002_Admissions -                   A5B29B8Q.BS00046M * 
 *                   work.CBM002_Admissions                                 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTB);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_ADM_APPL_PROG_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_ADM_APPL_PROG_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_ADM_APPL_PROG_Extract;
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
   delete CBM002_Admissions;
quit;

proc sql;
   create table work.CBM002_Admissions as
   select distinct
      CBM002_SSN.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_SSN.National_Id length = 9   
         label = 'National_Id',
      CBM002_SSN.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_SSN.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_SSN.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_SSN.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_SSN.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_SSN.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_SSN.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_SSN.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_SSN.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_SSN.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_SSN.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_SSN.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_SSN.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_SSN.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM002_SSN.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM002_SSN.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM002_SSN.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM002_SSN.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM002_SSN.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM002_SSN.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM002_SSN.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM002_SSN.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      MAX(ACAD_PROG_EFFDT.ADM_APPL_NBR ) as ADM_APPL_NBR length = 8   
         label = 'ADM_APPL_NBR',
      ACAD_PROG_EFFDT.APPL_PROG_NBR length = 8   
         label = 'APPL_PROG_NBR',
      ACAD_PROG_EFFDT.STDNT_CAR_NBR as ADM_STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      ACAD_PROG_EFFDT.ADMIT_TERM as ADM_ADMIT_TERM length = 8   
         label = 'ADMIT_TERM',
      CBM002_SSN.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_SSN.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_SSN.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_SSN.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_SSN.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_SSN.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_SSN.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_SSN.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_SSN.Flex length = 1   
         label = 'Flex',
      CBM002_SSN.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_SSN.Year length = 4   
         label = 'Year'
   from
      work.CBM002_SSN as CBM002_SSN left join 
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
            CBM002_SSN.EMPLID = ACAD_PROG_EFFDT.EMPLID
            and CBM002_SSN.ACAD_CAREER = ACAD_PROG_EFFDT.ACAD_CAREER
            and INPUT(CBM002_SSN.STRM ,BEST8.) >= INPUT(ACAD_PROG_EFFDT.ADMIT_TERM  ,BEST8.)
         )
   group by
      CBM002_SSN.EMPLID,
      CBM002_SSN.ACAD_CAREER
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
 * Step:            EAP Flag                              A5B29B8Q.BZ000BTC * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U * 
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      * 
 *                  PS_ADM_APPL_RCR_CA_Extract -          A5B29B8Q.BE00000V * 
 *                   ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract                    * 
 *                  CBM002_Admissions -                   A5B29B8Q.BS00046M * 
 *                   work.CBM002_Admissions                                 * 
 * Target Table:    CBM002_EAP - work.CBM002_EAP          A5B29B8Q.BS00046N * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTC);
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
   delete CBM002_EAP;
quit;

proc sql;
   create view work.CBM002_EAP as
   select distinct
      CBM002_Admissions.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_Admissions.National_Id length = 9   
         label = 'National_Id',
      CBM002_Admissions.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_Admissions.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_Admissions.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_Admissions.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_Admissions.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_Admissions.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_Admissions.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_Admissions.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_Admissions.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_Admissions.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_Admissions.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_Admissions.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_Admissions.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_Admissions.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM002_Admissions.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM002_Admissions.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM002_Admissions.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM002_Admissions.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM002_Admissions.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM002_Admissions.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM002_Admissions.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM002_Admissions.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM002_Admissions.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM002_Admissions.ADM_ADMIT_TERM length = 8   
         label = 'ADMIT_TERM',
      PS_ADM_APPL_DATA_Extract.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      PS_ADM_APPL_RCR_CA_Extract.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM002_Admissions.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_Admissions.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_Admissions.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_Admissions.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_Admissions.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_Admissions.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_Admissions.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      case 
      when CBM002_Admissions.ACAD_CAREER = 'UGRD' and PS_ADM_APPL_DATA_Extract.ADMIT_TYPE in ('1',  '5') and CBM002_Admissions.ACAD_PROG = 'UGNDS' and PS_ADM_APPL_RCR_CA_Extract.RECRUITMENT_CAT = 'AUEA' then 'Y' 
      else 'N'  
      end as EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_Admissions.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_Admissions.Flex length = 1   
         label = 'Flex',
      CBM002_Admissions.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_Admissions.Year length = 4   
         label = 'Year'
   from
      work.CBM002_Admissions as CBM002_Admissions left join 
      ADWSTGPR.PS_ADM_APPL_DATA_Extract as PS_ADM_APPL_DATA_Extract
         on
         (
            CBM002_Admissions.EMPLID = PS_ADM_APPL_DATA_Extract.EMPLID
            and CBM002_Admissions.ACAD_CAREER = PS_ADM_APPL_DATA_Extract.ACAD_CAREER
            and CBM002_Admissions.ADM_STDNT_CAR_NBR = PS_ADM_APPL_DATA_Extract.STDNT_CAR_NBR
            and CBM002_Admissions.ADM_APPL_NBR = PS_ADM_APPL_DATA_Extract.ADM_APPL_NBR
         ) left join 
      ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract as PS_ADM_APPL_RCR_CA_Extract
         on
         (
            CBM002_Admissions.EMPLID = PS_ADM_APPL_RCR_CA_Extract.EMPLID
            and CBM002_Admissions.ACAD_CAREER = PS_ADM_APPL_RCR_CA_Extract.ACAD_CAREER
            and CBM002_Admissions.ADM_STDNT_CAR_NBR = PS_ADM_APPL_RCR_CA_Extract.STDNT_CAR_NBR
            and CBM002_Admissions.ADM_APPL_NBR = PS_ADM_APPL_RCR_CA_Extract.ADM_APPL_NBR
            and CBM002_Admissions.INSTITUTION = PS_ADM_APPL_RCR_CA_Extract.INSTITUTION
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
 * Step:            ETHNIC_INFO                           A5B29B8Q.BZ000BTD * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_HCR_DIV_ETHNIC_I_Extract -         A5B29B8Q.BE00003T * 
 *                   ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract                   * 
 *                  PS_HCR_ETHNIC_GRP_I_Extract -         A5B29B8Q.BE00003U * 
 *                   ADWSTGPR.PS_HCR_ETHNIC_GRP_I_Extract                   * 
 * Target Table:    ETHNIC_INFO_CBM002 - work.WXRIPRCO    A5B29B8Q.BS00046O * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTD);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract;
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
   delete WXRIPRCO;
quit;

proc sql;
   create table work.WXRIPRCO as
   select distinct
      PS_HCR_DIV_ETHNIC_I_Extract.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      MAX(IFC(ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP='1','1','')) as Race_White length = 1   
         format = $1.
         informat = $1.
         label = 'Race_White',
      MAX(IFC(ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP='2','2','')) as Race_Black length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Black',
      MAX(IFC(ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP='4','4','')) as Race_Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Asian',
      MAX(IFC(ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP='5','5','')) as Race_AmIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'Race_AmIndAlsknNatv',
      MAX(IFC(ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP='7' or ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP is missing ,'7','')) as Race_UnknwnNotRptd length = 1   
         format = $1.
         informat = $1.
         label = 'Race_UnknwnNotRptd',
      MAX(IFC(ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP='8','8','')) as Race_NatHawnOPI length = 1   
         format = $1.
         informat = $1.
         label = 'Race_NatHawnOPI',
      MIN(IFC(ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP='3','1','3')) 
      
      /*CASE 
      WHEN max(ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP) = '3'  | ETHN_GRP_MAX_EFFDT.ETHNIC_GRP_CD ='HISPA'  THEN  '1'
      ELSE '3'
      END*/ as ETHNIC_ORIGIN length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      PUT(COUNT(distinct ETHN_GRP_MAX_EFFDT.ETHNIC_GROUP),1.) as ETHNIC_COUNT length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_COUNT'
   from
      ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract as PS_HCR_DIV_ETHNIC_I_Extract inner join 
      (
         select distinct
            PS_HCR_ETHNIC_GRP_I_Extract.DESCR50 length = 50   
               format = $50.
               informat = $50.
               label = 'DESCR50',
            PS_HCR_ETHNIC_GRP_I_Extract.DESCRSHORT length = 10   
               format = $10.
               informat = $10.
               label = 'DESCRSHORT',
            PS_HCR_ETHNIC_GRP_I_Extract.EFF_STATUS length = 1   
               format = $1.
               informat = $1.
               label = 'EFF_STATUS',
            PS_HCR_ETHNIC_GRP_I_Extract.EFFDT length = 8   
               format = DATETIME20.
               informat = DATETIME20.
               label = 'EFFDT',
            PS_HCR_ETHNIC_GRP_I_Extract.ETHNIC_CATEGORY length = 1   
               format = $1.
               informat = $1.
               label = 'ETHNIC_CATEGORY',
            PS_HCR_ETHNIC_GRP_I_Extract.ETHNIC_GROUP length = 1   
               format = $1.
               informat = $1.
               label = 'ETHNIC_GROUP',
            PS_HCR_ETHNIC_GRP_I_Extract.ETHNIC_GRP_CD length = 8   
               format = $8.
               informat = $8.
               label = 'ETHNIC_GRP_CD',
            PS_HCR_ETHNIC_GRP_I_Extract.SETID length = 5   
               format = $5.
               informat = $5.
               label = 'SETID'
         from
            ADWSTGPR.PS_HCR_ETHNIC_GRP_I_Extract as PS_HCR_ETHNIC_GRP_I_Extract
         where
            PS_HCR_ETHNIC_GRP_I_Extract.EFF_STATUS = 'A'
            and PS_HCR_ETHNIC_GRP_I_Extract.EFFDT <= DATETIME()
            and PS_HCR_ETHNIC_GRP_I_Extract.SETID = 'USA'
         group by
            PS_HCR_ETHNIC_GRP_I_Extract.ETHNIC_GRP_CD
         having
            PS_HCR_ETHNIC_GRP_I_Extract.EFFDT = MAX(PS_HCR_ETHNIC_GRP_I_Extract.EFFDT)
      ) as ETHN_GRP_MAX_EFFDT
         on
         (
            PS_HCR_DIV_ETHNIC_I_Extract.ETHNIC_GRP_CD = ETHN_GRP_MAX_EFFDT.ETHNIC_GRP_CD
         )
   group by
      PS_HCR_DIV_ETHNIC_I_Extract.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end ETHNIC_INFO **/

/*==========================================================================* 
 * Step:            EMPLID_DATA                           A5B29B8Q.BZ000BTE * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_PERSON_SA_Extract -                A5B29B8Q.BE00000P * 
 *                   ADWSTGPR.PS_PERSON_SA_Extract                          * 
 *                  PS_PERS_DATA_EFFDT_Extract -          A5B29B8Q.BE00004R * 
 *                   ADWSTGPR.PS_PERS_DATA_EFFDT_Extract                    * 
 *                  PS_PERSON_Extract -                   A5B29B8Q.BE00004V * 
 *                   ADWSTGPR.PS_PERSON_Extract                             * 
 * Target Table:    EMPLID_DATA_CBM002 - work.WXRIPPO0    A5B29B8Q.BS00046P * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTE);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_PERSON_SA_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_PERSON_SA_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_PERSON_SA_Extract;
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
   delete WXRIPPO0;
quit;

proc sql;
   create table work.WXRIPPO0 as
   select
      COALESCE(PS_PERSON_SA_Extract.EMPLID,EMPLID_GENDER_MAX_EFFDT.EMPLID, 
      PS_PERSON_Extract.EMPLID) as EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      IFC(PS_PERSON_SA_Extract.FERPA='Y','2','0') as FERPA_FLAG length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA_FLAG',
      EMPLID_GENDER_MAX_EFFDT.GENDER length = 1   
         format = $1.
         informat = $1.
         label = 'GENDER',
      IFC(PS_PERSON_Extract.BIRTHDATE<>.,
      PUT(DATEPART(PS_PERSON_Extract.BIRTHDATE),YYMMDDN8.),'') as BIRTHDATE length = 8   
         format = $8.
         informat = $8.
         label = 'BIRTHDATE'
   from
      ADWSTGPR.PS_PERSON_SA_Extract as PS_PERSON_SA_Extract full join 
      (
         select distinct
            PS_PERS_DATA_EFFDT_Extract.EMPLID length = 11   
               format = $11.
               informat = $11.
               label = 'EMPLID',
            IFC(PS_PERS_DATA_EFFDT_Extract.SEX NOT IN ('M','F'),'U',PS_PERS_DATA_EFFDT_Extract.SEX) as GENDER length = 1   
               format = $1.
               informat = $1.
               label = 'GENDER'
         from
            ADWSTGPR.PS_PERS_DATA_EFFDT_Extract as PS_PERS_DATA_EFFDT_Extract
         where
            PS_PERS_DATA_EFFDT_Extract.EFFDT <= DATETIME()
         group by
            PS_PERS_DATA_EFFDT_Extract.EMPLID
         having
            PS_PERS_DATA_EFFDT_Extract.EFFDT = MAX(PS_PERS_DATA_EFFDT_Extract.EFFDT)
      ) as EMPLID_GENDER_MAX_EFFDT
         on
         (
            PS_PERSON_SA_Extract.EMPLID = EMPLID_GENDER_MAX_EFFDT.EMPLID
         ) full join 
      ADWSTGPR.PS_PERSON_Extract as PS_PERSON_Extract
         on
         (
            PS_PERSON_SA_Extract.EMPLID = PS_PERSON_Extract.EMPLID
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end EMPLID_DATA **/

/*==========================================================================* 
 * Step:            Student Info                          A5B29B8Q.BZ000BTF * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_EAP - work.CBM002_EAP          A5B29B8Q.BS00046N * 
 *                  ETHNIC_INFO_CBM002 - work.WXRIPRCO    A5B29B8Q.BS00046O * 
 *                  EMPLID_DATA_CBM002 - work.WXRIPPO0    A5B29B8Q.BS00046P * 
 * Target Table:    CBM002_StudentInfo -                  A5B29B8Q.BS00046Q * 
 *                   work.CBM002_StudentInfo                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTF);
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
   delete CBM002_StudentInfo;
quit;

proc sql;
   create table work.CBM002_StudentInfo as
   select distinct
      CBM002_EAP.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_EAP.National_Id length = 9   
         label = 'National_Id',
      CBM002_EAP.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_EAP.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_EAP.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_EAP.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_EAP.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_EAP.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_EAP.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_EAP.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_EAP.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_EAP.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_EAP.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_EAP.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_EAP.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_EAP.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM002_EAP.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM002_EAP.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM002_EAP.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM002_EAP.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM002_EAP.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM002_EAP.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM002_EAP.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM002_EAP.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM002_EAP.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM002_EAP.ADM_ADMIT_TERM length = 8   
         label = 'ADMIT_TERM',
      CBM002_EAP.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBM002_EAP.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM002_EAP.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      WXRIPRCO.Race_White length = 1   
         format = $1.
         informat = $1.
         label = 'Race_White',
      WXRIPRCO.Race_Black length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Black',
      WXRIPRCO.Race_Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Asian',
      WXRIPRCO.Race_AmIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'Race_AmIndAlsknNatv',
      WXRIPRCO.Race_UnknwnNotRptd length = 1   
         format = $1.
         informat = $1.
         label = 'Race_UnknwnNotRptd',
      WXRIPRCO.Race_NatHawnOPI length = 1   
         format = $1.
         informat = $1.
         label = 'Race_NatHawnOPI',
      case  
      when WXRIPRCO.EMPLID is missing then '3' 
      else WXRIPRCO.ETHNIC_ORIGIN  
      end as ETHNIC_ORIGIN length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      WXRIPRCO.ETHNIC_COUNT length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_COUNT',
      WXRIPPO0.FERPA_FLAG length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA_FLAG',
      WXRIPPO0.GENDER length = 1   
         format = $1.
         informat = $1.
         label = 'GENDER',
      WXRIPPO0.BIRTHDATE length = 8   
         format = $8.
         informat = $8.
         label = 'BIRTHDATE',
      CBM002_EAP.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_EAP.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_EAP.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_EAP.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_EAP.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_EAP.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_EAP.EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_EAP.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_EAP.Flex length = 1   
         label = 'Flex',
      CBM002_EAP.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_EAP.Year length = 4   
         label = 'Year'
   from
      work.CBM002_EAP as CBM002_EAP left join 
      work.WXRIPRCO as WXRIPRCO
         on
         (
            CBM002_EAP.EMPLID = WXRIPRCO.EMPLID
         ) left join 
      work.WXRIPPO0 as WXRIPPO0
         on
         (
            CBM002_EAP.EMPLID = WXRIPPO0.EMPLID
         )
   group by
      CBM002_EAP.EMPLID
   having
      CBM002_EAP.STRM = max(CBM002_EAP.STRM)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Student Info **/

/*==========================================================================* 
 * Step:            International Students                A5B29B8Q.BZ000BTG * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_StudentInfo -                  A5B29B8Q.BS00046Q * 
 *                   work.CBM002_StudentInfo                                * 
 *                  PS_RESIDENCY_OFF_Extract -            A5B29B8Q.BE000059 * 
 *                   ADWSTGPR.PS_RESIDENCY_OFF_Extract                      * 
 * Target Table:    CBM002_International -                A5B29B8Q.BS00046R * 
 *                   work.CBM002_International                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTG);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_StudentInfo, DATA)) or 
         %sysfunc(exist(work.CBM002_StudentInfo, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_StudentInfo out = work.etls_contents(keep = nobs) noprint; 
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
   delete CBM002_International;
quit;

proc sql;
   create table work.CBM002_International as
   select distinct
      CBM002_StudentInfo.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_StudentInfo.National_Id length = 9   
         label = 'National_Id',
      CBM002_StudentInfo.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_StudentInfo.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_StudentInfo.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_StudentInfo.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_StudentInfo.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_StudentInfo.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_StudentInfo.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_StudentInfo.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_StudentInfo.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_StudentInfo.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_StudentInfo.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_StudentInfo.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_StudentInfo.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_StudentInfo.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM002_StudentInfo.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM002_StudentInfo.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM002_StudentInfo.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM002_StudentInfo.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM002_StudentInfo.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM002_StudentInfo.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM002_StudentInfo.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM002_StudentInfo.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM002_StudentInfo.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM002_StudentInfo.ADM_ADMIT_TERM length = 8   
         label = 'ADMIT_TERM',
      CBM002_StudentInfo.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBM002_StudentInfo.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM002_StudentInfo.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_StudentInfo.Race_White length = 1   
         format = $1.
         informat = $1.
         label = 'Race_White',
      CBM002_StudentInfo.Race_Black length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Black',
      CBM002_StudentInfo.Race_Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Asian',
      CBM002_StudentInfo.Race_AmIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'Race_AmIndAlsknNatv',
      CBM002_StudentInfo.Race_UnknwnNotRptd length = 1   
         format = $1.
         informat = $1.
         label = 'Race_UnknwnNotRptd',
      CBM002_StudentInfo.Race_NatHawnOPI length = 1   
         format = $1.
         informat = $1.
         label = 'Race_NatHawnOPI',
      CBM002_StudentInfo.ETHNIC_ORIGIN length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CBM002_StudentInfo.ETHNIC_COUNT length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_COUNT',
      CBM002_StudentInfo.FERPA_FLAG length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA_FLAG',
      CBM002_StudentInfo.GENDER length = 1   
         format = $1.
         informat = $1.
         label = 'GENDER',
      CBM002_StudentInfo.BIRTHDATE length = 8   
         format = $8.
         informat = $8.
         label = 'BIRTHDATE',
      PS_RESIDENCY_OFF_Extract.TUITION_EXCPT length = 5   
         format = $5.
         informat = $5.
         label = 'TUITION_EXCPT',
      PS_RESIDENCY_OFF_Extract.TUITION_RES length = 5   
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      CASE  
      WHEN  PS_RESIDENCY_OFF_Extract.TUITION_RES ='1'  and PS_RESIDENCY_OFF_Extract.TUITION_EXCPT in ('1403A', '1528A') and   PS_RESIDENCY_OFF_Extract.RESIDENCY ='4'  THEN '' 
      WHEN  PS_RESIDENCY_OFF_Extract.RESIDENCY ='4'    THEN '6'  
      ELSE ''  
      END as International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      CBM002_StudentInfo.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_StudentInfo.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_StudentInfo.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_StudentInfo.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_StudentInfo.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_StudentInfo.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_StudentInfo.EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_StudentInfo.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_StudentInfo.Flex length = 1   
         label = 'Flex',
      CBM002_StudentInfo.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_StudentInfo.Year length = 4   
         label = 'Year'
   from
      work.CBM002_StudentInfo as CBM002_StudentInfo left join 
      ADWSTGPR.PS_RESIDENCY_OFF_Extract as PS_RESIDENCY_OFF_Extract
         on
         (
            CBM002_StudentInfo.EMPLID = PS_RESIDENCY_OFF_Extract.EMPLID
            and CBM002_StudentInfo.ACAD_CAREER = PS_RESIDENCY_OFF_Extract.ACAD_CAREER
            and CBM002_StudentInfo.STRM >= PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM
         )
   group by
      CBM002_StudentInfo.EMPLID,
      CBM002_StudentInfo.ACAD_CAREER,
      CBM002_StudentInfo.STRM
   having
      PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM = MAX(PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM)
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end International Students **/

/*==========================================================================* 
 * Step:            Distinct Students                     A5B29B8Q.BZ000BTH * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_International -                A5B29B8Q.BS00046R * 
 *                   work.CBM002_International                              * 
 * Target Table:    DistinctStudents -                    A5B29B8Q.BS00046S * 
 *                   work.DistinctStudents                                  * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTH);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_International, DATA)) or 
         %sysfunc(exist(work.CBM002_International, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_International out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.CBM002_International); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete DistinctStudents;
quit;

proc sql;
   create table work.DistinctStudents as
   select distinct
      CBM002_International.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_International.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_International.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT'
   from
      work.CBM002_International as CBM002_International
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Distinct Students **/

/*==========================================================================* 
 * Step:            Test Scores                           A5B29B8Q.BZ000BTI * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   PS_STDNT_TEST_COMP_Extract -          A5B29B8Q.BE00006J * 
 *                   ADWSTGPR.PS_STDNT_TEST_COMP_Extract                    * 
 *                  DistinctStudents -                    A5B29B8Q.BS00046S * 
 *                   work.DistinctStudents                                  * 
 * Target Table:    CBM002_Test_Scores -                  A5B29B8Q.BS00046T * 
 *                   work.CBM002_Test_Scores                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTI);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(ADWSTGPR.PS_STDNT_TEST_COMP_Extract, DATA)) or 
         %sysfunc(exist(ADWSTGPR.PS_STDNT_TEST_COMP_Extract, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from ADWSTGPR.PS_STDNT_TEST_COMP_Extract;
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
   delete CBM002_Test_Scores;
quit;

proc sql;
   create table work.CBM002_Test_Scores as
   select distinct
      DistinctStudents.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      DistinctStudents.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      case when DistinctStudents.CENSUS_DT >= MAX(PS_STDNT_TEST_COMP_Extract.TEST_DT) then 'Y' else 'N' end as TestBeforeCensus length = 1   
         format = $1.
         informat = $1.
         label = 'TestBeforeCensus',
      PS_STDNT_TEST_COMP_Extract.SCORE length = 8   
         format = 9.2
         informat = 9.2
         label = 'SCORE',
      PS_STDNT_TEST_COMP_Extract.TEST_ID length = 11   
         format = $11.
         informat = $11.
         label = 'TEST_ID',
      PS_STDNT_TEST_COMP_Extract.TEST_COMPONENT length = 5   
         format = $5.
         informat = $5.
         label = 'TEST_COMPONENT',
      MAX(PS_STDNT_TEST_COMP_Extract.TEST_DT) as TEST_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TEST_DT'
   from
      work.DistinctStudents as DistinctStudents left join 
      ADWSTGPR.PS_STDNT_TEST_COMP_Extract as PS_STDNT_TEST_COMP_Extract
         on
         (
            DistinctStudents.EMPLID = PS_STDNT_TEST_COMP_Extract.EMPLID
            and PS_STDNT_TEST_COMP_Extract.TEST_ID in  ('ACT',
            'SAT I',
            'TAKS',
             'THEA',
            'COMPASS',
            'ASSET',
            'ACCUPLACER',
            'STANFORD',
            'MAPS',
            'TSIA',
            'TSIA2')
         )
   where
      PS_STDNT_TEST_COMP_Extract.TEST_COMPONENT NOT IS MISSING 
   group by
      DistinctStudents.STRM,
      DistinctStudents.EMPLID,
      TEST_ID,
      TEST_COMPONENT
   having
      PS_STDNT_TEST_COMP_Extract.SCORE = MAX(PS_STDNT_TEST_COMP_Extract.SCORE)
   order by
      DistinctStudents.STRM,
      DistinctStudents.EMPLID,
      PS_STDNT_TEST_COMP_Extract.TEST_ID,
      TestBeforeCensus,
      PS_STDNT_TEST_COMP_Extract.TEST_COMPONENT,
      PS_STDNT_TEST_COMP_Extract.SCORE
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Test Scores **/

/*==========================================================================* 
 * Step:            Max Test Scores                       A5B29B8Q.BZ000BTJ * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_Test_Scores -                  A5B29B8Q.BS00046T * 
 *                   work.CBM002_Test_Scores                                * 
 * Target Table:    MAX_TEST_SCORES -                     A5B29B8Q.BS00046U * 
 *                   work.MAX_TEST_SCORES                                   * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTJ);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_Test_Scores, DATA)) or 
         %sysfunc(exist(work.CBM002_Test_Scores, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_Test_Scores out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.CBM002_Test_Scores); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete MAX_TEST_SCORES;
quit;

proc sql;
   create table work.MAX_TEST_SCORES as
   select
      CBM002_Test_Scores.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_Test_Scores.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      MAX( 
      case  when CBM002_Test_Scores.TEST_ID  ='ACT'  and CBM002_Test_Scores.TEST_COMPONENT = 'MATH' 
      	and CBM002_Test_Scores.TEST_DT >='01FEB2023:00:00:00'dt then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as Math_ACT length = 8   
         label = 'Math_ACT',
      MAX(  
      case  when CBM002_Test_Scores.TEST_ID  ='ACT'  and CBM002_Test_Scores.TEST_COMPONENT = 'READ'  
       and CBM002_Test_Scores.TEST_DT >='01FEB2023:00:00:00'dt then CBM002_Test_Scores.SCORE   
      else 0 end  
      ) as Read_ACT length = 8   
         label = 'Read_ACT',
      MAX(   
      case  when CBM002_Test_Scores.TEST_ID  ='ACT'  and CBM002_Test_Scores.TEST_COMPONENT = 'ENGL'   
       and CBM002_Test_Scores.TEST_DT >='01FEB2023:00:00:00'dt then CBM002_Test_Scores.SCORE    
      else 0 end   
      ) as Write_ACT length = 8   
         label = 'Write_ACT',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID = 'TAKS' and CBM002_Test_Scores.TEST_COMPONENT ='MATH'  then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as Math_Taks length = 8   
         label = 'Math_Taks',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID = 'TAKS' and CBM002_Test_Scores.TEST_COMPONENT ='EGLA'  then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as Read_Taks length = 8   
         label = 'Read_Taks',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID = 'TAKS' and CBM002_Test_Scores.TEST_COMPONENT ='EGLA'  then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as Write_Taks length = 8   
         label = 'Write_Taks',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID = 'SAT I'  and CBM002_Test_Scores.TEST_COMPONENT ='MATHS' then CBM002_Test_Scores.SCORE 
      else 0 end 
      ) as MATH_SAT length = 8   
         label = 'MATH_SAT',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID = 'SAT I'  and CBM002_Test_Scores.TEST_COMPONENT ='EBRWS' then CBM002_Test_Scores.SCORE 
      else 0 end 
      ) as VERBAL_SAT length = 8   
         label = 'VERBAL_SAT',
      MAX(
      case when CBM002_Test_Scores.TEST_ID = 'SAT I'  and CBM002_Test_Scores.TEST_COMPONENT ='TOT02' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as Total_SAT length = 8   
         label = 'Total_SAT',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID = 'SAT I'  and CBM002_Test_Scores.TEST_COMPONENT ='MATH' then CBM002_Test_Scores.SCORE 
      else 0 end 
      ) as MATH_SAT_Old length = 8   
         label = 'MATH_SAT_Old',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID = 'SAT I'  and CBM002_Test_Scores.TEST_COMPONENT ='VERB' then CBM002_Test_Scores.SCORE 
      else 0 end 
      ) as VERBAL_SAT_Old length = 8   
         label = 'VERBAL_SAT_Old',
      MAX(
      case when CBM002_Test_Scores.TEST_ID = 'SAT I'  and CBM002_Test_Scores.TEST_COMPONENT ='SATT2' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as Total_SAT_Old length = 8   
         label = 'Total_SAT_Old',
      MAX( 
      case  when CBM002_Test_Scores.TEST_ID ='ACT'  and CBM002_Test_Scores.TEST_COMPONENT = 'TSIC'
       and CBM002_Test_Scores.TEST_DT >='01FEB2023:00:00:00'dt  then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as English_Composite_ACT length = 8   
         label = 'English_Composite_ACT',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'THEA' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATH' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as MATH_THEA length = 8   
         label = 'MATH_THEA',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'THEA' and  CBM002_Test_Scores.TEST_COMPONENT = 'READ' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as READ_THEA length = 8   
         label = 'READ_THEA',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'THEA' and  CBM002_Test_Scores.TEST_COMPONENT = 'WR' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as WRITE_THEA length = 8   
         label = 'WRITE_THEA',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'COMPASS' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATH' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as MATH_COMPASS length = 8   
         label = 'MATH_COMPASS',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'COMPASS' and  CBM002_Test_Scores.TEST_COMPONENT = 'READ' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as READ_COMPASS length = 8   
         label = 'READ_COMPASS',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'COMPASS' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRS' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITE_COMPASS length = 8   
         label = 'WRITE_COMPASS',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'ASSET' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATH' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as MATH_ASSET length = 8   
         label = 'MATH_ASSET',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'ASSET' and  CBM002_Test_Scores.TEST_COMPONENT = 'READ' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as READ_ASSET length = 8   
         label = 'READ_ASSET',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'ASSET' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRS' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITE_ASSET length = 8   
         label = 'WRITE_ASSET',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'ACCUPLACER' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATH' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as MATH_ACCUPLACER length = 8   
         label = 'MATH_ACCUPLACER',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'ACCUPLACER' and  CBM002_Test_Scores.TEST_COMPONENT = 'READ' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as READ_ACCUPLACER length = 8   
         label = 'READ_ACCUPLACER',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'ACCUPLACER' and  CBM002_Test_Scores.TEST_COMPONENT = 'SS' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as WRITE_ACCUPLACER length = 8   
         label = 'WRITE_ACCUPLACER',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'STANFORD' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATH' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as MATH_STANFORD length = 8   
         label = 'MATH_STANFORD',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'STANFORD' and  CBM002_Test_Scores.TEST_COMPONENT = 'READ' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as READ_STANFORD length = 8   
         label = 'READ_STANFORD',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'STANFORD' and  CBM002_Test_Scores.TEST_COMPONENT = 'STUD' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITE_STANFORD length = 8   
         label = 'WRITE_STANFORD',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'MAPS' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATH' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as MATH_MAPS length = 8   
         label = 'MATH_MAPS',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'MAPS' and  CBM002_Test_Scores.TEST_COMPONENT = 'READ' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as READ_MAPS length = 8   
         label = 'READ_MAPS',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'MAPS' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRO' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITE_MAPS length = 8   
         label = 'WRITE_MAPS',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'COMPASS' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRE' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITEESSAY_COMPASS length = 8   
         label = 'WRITEESSAY_COMPASS',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'ASSET' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRE' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITEESSAY_ASSET length = 8   
         label = 'WRITEESSAY_ASSET',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'ACCUPLACER' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRE' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITEESSAY_ACCUPLACER length = 8   
         label = 'WRITEESSAY_ACCUPLACER',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'STANFORD' and  CBM002_Test_Scores.TEST_COMPONENT = 'EGLA' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITEESSAY_STANFORD length = 8   
         label = 'WRITEESSAY_STANFORD',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'MAPS' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRE' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITEESSAY_MAPS length = 8   
         label = 'WRITEESSAY_MAPS',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'TSIA' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATH' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as MATH_TSIA length = 8   
         label = 'MATH_TSIA',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'TSIA' and  CBM002_Test_Scores.TEST_COMPONENT = 'READ' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as READ_TSIA length = 8   
         label = 'READ_TSIA',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'TSIA' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRMC' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as WRITE_TSIA length = 8   
         label = 'WRITE_TSIA',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'TSIA2' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATH' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as MATH_TSIA2 length = 8   
         label = 'MATH_TSIA2',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'TSIA2' and  CBM002_Test_Scores.TEST_COMPONENT = 'ELAR' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as READ_TSIA2 length = 8   
         label = 'READ_TSIA2',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'TSIA2' and  CBM002_Test_Scores.TEST_COMPONENT = 'ELAR' then CBM002_Test_Scores.SCORE
      else 0 end
      ) as WRITE_TSIA2 length = 8   
         label = 'WRITE_TSIA2',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'TSIA' and  CBM002_Test_Scores.TEST_COMPONENT = 'WRE' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITEESSAY_TSIA length = 8   
         label = 'WRITEESSAY_TSIA',
      MAX(
      case when CBM002_Test_Scores.TEST_ID =  'TSIA2' and  CBM002_Test_Scores.TEST_COMPONENT = 'ELARE' then CBM002_Test_Scores.SCORE 
      else 0 end
      ) as WRITEESSAY_TSIA2 length = 8   
         label = 'WRITEESSAY_TSIA2',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID =  'TSIA2' and  CBM002_Test_Scores.TEST_COMPONENT = 'MATHD' then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as MATH_TSIA2_Diagnostic length = 8   
         label = 'MATH_TSIA2_Diagnostic',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID =  'TSIA2' and  CBM002_Test_Scores.TEST_COMPONENT = 'ELARD' then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as READ_TSIA2_Diagnostic length = 8   
         label = 'READ_TSIA2_Diagnostic',
      MAX( 
      case when CBM002_Test_Scores.TEST_ID =  'TSIA2' and  CBM002_Test_Scores.TEST_COMPONENT = 'ELARD' then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as WRITE_TSIA2_Diagnostic length = 8   
         label = 'WRITE_TSIA2_Diagnostic',
      MAX( 
      case  when CBM002_Test_Scores.TEST_ID  ='ACT'  and CBM002_Test_Scores.TEST_COMPONENT = 'MATH'
       and CBM002_Test_Scores.TEST_DT < '01FEB2023:00:00:00'dt then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as Math_ACT_Old length = 8   
         label = 'Math_ACT_Old',
      MAX(  
      case  when CBM002_Test_Scores.TEST_ID  ='ACT'  and CBM002_Test_Scores.TEST_COMPONENT = 'ENGL'
       and CBM002_Test_Scores.TEST_DT <'01FEB2023:00:00:00'dt  then CBM002_Test_Scores.SCORE   
      else 0 end  
      ) as Verbal_ACT_Old length = 8   
         label = 'Verbal_ACT_Old',
      MAX( 
      case  when CBM002_Test_Scores.TEST_ID ='ACT'  and CBM002_Test_Scores.TEST_COMPONENT = 'COMP'
       and CBM002_Test_Scores.TEST_DT < '01FEB2023:00:00:00'dt  then CBM002_Test_Scores.SCORE  
      else 0 end 
      ) as Total_ACT_Old length = 8   
         label = 'Total_ACT_Old'
   from
      work.CBM002_Test_Scores as CBM002_Test_Scores
   group by
      CBM002_Test_Scores.STRM,
      CBM002_Test_Scores.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Max Test Scores **/

/*==========================================================================* 
 * Step:            Calculated Test Scores                A5B29B8Q.BZ000BTK * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    MAX_TEST_SCORES -                     A5B29B8Q.BS00046U * 
 *                   work.MAX_TEST_SCORES                                   * 
 * Target Table:    CBM002_CalculatedScores -             A5B29B8Q.BS00046V * 
 *                   work.CBM002_CalculatedScores                           * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTK);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.MAX_TEST_SCORES, DATA)) or 
         %sysfunc(exist(work.MAX_TEST_SCORES, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.MAX_TEST_SCORES out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.MAX_TEST_SCORES); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM002_CalculatedScores;
quit;

proc sql;
   create table work.CBM002_CalculatedScores as
   select
      MAX_TEST_SCORES.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      MAX_TEST_SCORES.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ifn(MAX_TEST_SCORES.Math_ACT  >=22 , MAX_TEST_SCORES.Math_ACT, 0) as Math_ACT length = 8   
         label = 'Math_ACT',
      case   
      when MAX_TEST_SCORES.English_Composite_ACT >= 40 and MAX_TEST_SCORES.Read_ACT  >0 then  MAX_TEST_SCORES.Read_ACT  
      else 0 end as Read_ACT length = 8   
         label = 'Read_ACT',
      case    
      when MAX_TEST_SCORES.English_Composite_ACT >= 40 and MAX_TEST_SCORES.Write_ACT  >0 then  MAX_TEST_SCORES.Write_ACT  
      else 0 end as Write_ACT length = 8   
         label = 'Write_ACT',
      MAX_TEST_SCORES.Math_Taks length = 8   
         label = 'Math_Taks',
      MAX_TEST_SCORES.Read_Taks length = 8   
         label = 'Read_Taks',
      MAX_TEST_SCORES.Write_Taks length = 8   
         label = 'Write_Taks',
      case 
      when ( MAX_TEST_SCORES.MATH_SAT >=530 or MAX_TEST_SCORES.VERBAL_SAT  >=480) and MAX_TEST_SCORES.MATH_SAT >=0 then MAX_TEST_SCORES.MATH_SAT   
      else 0 end as MATH_SAT length = 8   
         label = 'MATH_SAT',
      case 
      when ( MAX_TEST_SCORES.MATH_SAT >=530 or MAX_TEST_SCORES.VERBAL_SAT  >=480) and MAX_TEST_SCORES.VERBAL_SAT  >=0 then MAX_TEST_SCORES.VERBAL_SAT  
      else 0 end as VERBAL_SAT length = 8   
         label = 'VERBAL_SAT',
      ifn (MAX_TEST_SCORES.Total_SAT > 0, MAX_TEST_SCORES.Total_SAT , SUM(MAX_TEST_SCORES.MATH_SAT  ,MAX_TEST_SCORES.VERBAL_SAT  )) as Total_SAT length = 8   
         label = 'Total_SAT',
      case  when MAX_TEST_SCORES.English_Composite_ACT  >= 40  then MAX_TEST_SCORES.English_Composite_ACT  
      else 0 end as English_Composite_ACT length = 8   
         label = 'English_Composite_ACT',
      MAX_TEST_SCORES.MATH_THEA length = 8   
         label = 'MATH_THEA',
      MAX_TEST_SCORES.READ_THEA length = 8   
         label = 'READ_THEA',
      MAX_TEST_SCORES.WRITE_THEA length = 8   
         label = 'WRITE_THEA',
      MAX_TEST_SCORES.MATH_COMPASS length = 8   
         label = 'MATH_COMPASS',
      MAX_TEST_SCORES.READ_COMPASS length = 8   
         label = 'READ_COMPASS',
      MAX_TEST_SCORES.WRITE_COMPASS length = 8   
         label = 'WRITE_COMPASS',
      MAX_TEST_SCORES.MATH_ASSET length = 8   
         label = 'MATH_ASSET',
      MAX_TEST_SCORES.READ_ASSET length = 8   
         label = 'READ_ASSET',
      MAX_TEST_SCORES.WRITE_ASSET length = 8   
         label = 'WRITE_ASSET',
      MAX_TEST_SCORES.MATH_ACCUPLACER length = 8   
         label = 'MATH_ACCUPLACER',
      MAX_TEST_SCORES.READ_ACCUPLACER length = 8   
         label = 'READ_ACCUPLACER',
      MAX_TEST_SCORES.WRITE_ACCUPLACER length = 8   
         label = 'WRITE_ACCUPLACER',
      MAX_TEST_SCORES.MATH_STANFORD length = 8   
         label = 'MATH_STANFORD',
      MAX_TEST_SCORES.READ_STANFORD length = 8   
         label = 'READ_STANFORD',
      MAX_TEST_SCORES.WRITE_STANFORD length = 8   
         label = 'WRITE_STANFORD',
      MAX_TEST_SCORES.MATH_MAPS length = 8   
         label = 'MATH_MAPS',
      MAX_TEST_SCORES.READ_MAPS length = 8   
         label = 'READ_MAPS',
      MAX_TEST_SCORES.WRITE_MAPS length = 8   
         label = 'WRITE_MAPS',
      MAX_TEST_SCORES.WRITEESSAY_COMPASS length = 8   
         label = 'WRITEESSAY_COMPASS',
      MAX_TEST_SCORES.WRITEESSAY_ACCUPLACER length = 8   
         label = 'WRITEESSAY_ACCUPLACER',
      MAX_TEST_SCORES.WRITEESSAY_ASSET length = 8   
         label = 'WRITEESSAY_ASSET',
      MAX_TEST_SCORES.WRITEESSAY_STANFORD length = 8   
         label = 'WRITEESSAY_STANFORD',
      MAX_TEST_SCORES.WRITEESSAY_MAPS length = 8   
         label = 'WRITEESSAY_MAPS',
      MAX_TEST_SCORES.MATH_TSIA length = 8   
         label = 'MATH_TSIA',
      MAX_TEST_SCORES.READ_TSIA length = 8   
         label = 'READ_TSIA',
      MAX_TEST_SCORES.WRITE_TSIA length = 8   
         label = 'WRITE_TSIA',
      MAX_TEST_SCORES.MATH_TSIA2 length = 8   
         label = 'MATH_TSIA2',
      MAX_TEST_SCORES.READ_TSIA2 length = 8   
         label = 'READ_TSIA2',
      MAX_TEST_SCORES.WRITE_TSIA2 length = 8   
         label = 'WRITE_TSIA2',
      MAX_TEST_SCORES.WRITEESSAY_TSIA length = 8   
         label = 'WRITEESSAY_TSIA',
      MAX_TEST_SCORES.WRITEESSAY_TSIA2 length = 8   
         label = 'WRITEESSAY_TSIA2',
      case  
      when SUM(MAX_TEST_SCORES.MATH_SAT_Old ,MAX_TEST_SCORES.VERBAL_SAT_Old )>=1070 then MAX_TEST_SCORES.MATH_SAT_Old 
      else 0 
      end as MATH_SAT_Old length = 8   
         label = 'MATH_SAT_Old',
      case  
      when SUM(MAX_TEST_SCORES.MATH_SAT_Old ,MAX_TEST_SCORES.VERBAL_SAT_Old )>=1070 then MAX_TEST_SCORES.VERBAL_SAT_Old 
      else 0 end as VERBAL_SAT_Old length = 8   
         label = 'VERBAL_SAT_Old',
      ifn (MAX_TEST_SCORES.Total_SAT_Old  >  SUM(MAX_TEST_SCORES.MATH_SAT_Old ,MAX_TEST_SCORES.VERBAL_SAT_Old ),
      	 MAX_TEST_SCORES.Total_SAT_Old  , SUM(MAX_TEST_SCORES.MATH_SAT_Old ,MAX_TEST_SCORES.VERBAL_SAT_Old )) as Total_SAT_Old length = 8   
         label = 'Total_SAT_Old',
      MAX_TEST_SCORES.MATH_TSIA2_Diagnostic length = 8   
         label = 'MATH_TSIA2_Diagnostic',
      MAX_TEST_SCORES.READ_TSIA2_Diagnostic length = 8   
         label = 'READ_TSIA2_Diagnostic',
      MAX_TEST_SCORES.WRITE_TSIA2_Diagnostic length = 8   
         label = 'WRITE_TSIA2_Diagnostic',
      case   
      when MAX_TEST_SCORES.Total_ACT_Old >= 23 and MAX_TEST_SCORES.Math_ACT_Old  >=19 then MAX_TEST_SCORES.Math_ACT_Old   
      else 0 end as Math_ACT_Old length = 8   
         label = 'Math_ACT_Old',
      case   
      when MAX_TEST_SCORES.Total_ACT_Old >= 23 and MAX_TEST_SCORES.Verbal_ACT_Old  >=19 then  MAX_TEST_SCORES.Verbal_ACT_Old  
      else 0 end as Verbal_ACT_Old length = 8   
         label = 'Read_ACT_Old',
      case  when MAX_TEST_SCORES.Total_ACT_Old  >= 23  then MAX_TEST_SCORES.Total_ACT_Old 
      else 0 end as Total_ACT_Old length = 8   
         label = 'Total_ACT_Old'
   from
      work.MAX_TEST_SCORES as MAX_TEST_SCORES
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Calculated Test Scores **/

/*==========================================================================* 
 * Step:            SAT/ACT/TAKS TestScores Final         A5B29B8Q.BZ000BTL * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_International -                A5B29B8Q.BS00046R * 
 *                   work.CBM002_International                              * 
 *                  CBM002_CalculatedScores -             A5B29B8Q.BS00046V * 
 *                   work.CBM002_CalculatedScores                           * 
 * Target Table:    TestScores_Final -                    A5B29B8Q.BS00046W * 
 *                   work.TestScores_Final                                  * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTL);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_International, DATA)) or 
         %sysfunc(exist(work.CBM002_International, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_International out = work.etls_contents(keep = nobs) noprint; 
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
   delete TestScores_Final;
quit;

proc sql;
   create table work.TestScores_Final as
   select distinct
      CBM002_International.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_International.National_Id length = 9   
         label = 'National_Id',
      CBM002_International.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_International.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_International.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_International.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_International.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_International.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_International.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_International.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_International.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_International.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_International.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_International.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_International.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_International.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_International.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM002_International.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM002_International.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM002_International.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM002_International.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM002_International.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM002_International.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM002_International.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM002_International.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM002_International.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM002_International.ADM_ADMIT_TERM length = 8   
         label = 'ADMIT_TERM',
      CBM002_International.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBM002_International.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM002_International.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_International.Race_White length = 1   
         format = $1.
         informat = $1.
         label = 'Race_White',
      CBM002_International.Race_Black length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Black',
      CBM002_International.Race_Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Asian',
      CBM002_International.Race_AmIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'Race_AmIndAlsknNatv',
      case  
               when  CBM002_International.International is not missing then '' 
               when  CBM002_International.ETHNIC_ORIGIN in ('1', '3')   
      	and CBM002_International.Race_White is missing   
      	and CBM002_International.Race_Black is missing  
      	and CBM002_International.Race_Asian  is missing  
      	and CBM002_International.Race_AmIndAlsknNatv  is missing  
      	and  CBM002_International.International is missing 
      	and CBM002_International.Race_NatHawnOPI  is missing then '7'  
      else CBM002_International.Race_UnknwnNotRptd end as Race_UnknwnNotRptd length = 1   
         format = $1.
         informat = $1.
         label = 'Race_UnknwnNotRptd',
      CBM002_International.Race_NatHawnOPI length = 1   
         format = $1.
         informat = $1.
         label = 'Race_NatHawnOPI',
      CBM002_International.ETHNIC_ORIGIN length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CBM002_International.ETHNIC_COUNT length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_COUNT',
      CBM002_International.FERPA_FLAG length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA_FLAG',
      CBM002_International.GENDER length = 1   
         format = $1.
         informat = $1.
         label = 'GENDER',
      CBM002_International.BIRTHDATE length = 8   
         format = $8.
         informat = $8.
         label = 'BIRTHDATE',
      CBM002_International.TUITION_EXCPT length = 5   
         format = $5.
         informat = $5.
         label = 'TUITION_EXCPT',
      CBM002_International.TUITION_RES length = 5   
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      CBM002_International.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      CBM002_CalculatedScores.Math_ACT length = 8   
         label = 'Math_ACT',
      CBM002_CalculatedScores.Math_Taks length = 8   
         label = 'Math_Taks',
      CBM002_CalculatedScores.MATH_SAT length = 8   
         label = 'MATH_SAT',
      CBM002_CalculatedScores.VERBAL_SAT length = 8   
         label = 'VERBAL_SAT',
      CBM002_CalculatedScores.Total_SAT length = 8   
         label = 'Total_SAT',
      CBM002_CalculatedScores.English_Composite_ACT length = 8   
         label = 'English_Composite_ACT',
      CBM002_CalculatedScores.MATH_THEA length = 8   
         label = 'MATH_THEA',
      CBM002_CalculatedScores.READ_THEA length = 8   
         label = 'READ_THEA',
      CBM002_CalculatedScores.WRITE_THEA length = 8   
         label = 'WRITE_THEA',
      CBM002_CalculatedScores.MATH_COMPASS length = 8   
         label = 'MATH_COMPASS',
      CBM002_CalculatedScores.READ_COMPASS length = 8   
         label = 'READ_COMPASS',
      CBM002_CalculatedScores.WRITE_COMPASS length = 8   
         label = 'WRITE_COMPASS',
      CBM002_CalculatedScores.MATH_ASSET length = 8   
         label = 'MATH_ASSET',
      CBM002_CalculatedScores.READ_ASSET length = 8   
         label = 'READ_ASSET',
      CBM002_CalculatedScores.WRITE_ASSET length = 8   
         label = 'WRITE_ASSET',
      CBM002_CalculatedScores.MATH_ACCUPLACER length = 8   
         label = 'MATH_ACCUPLACER',
      CBM002_CalculatedScores.READ_ACCUPLACER length = 8   
         label = 'READ_ACCUPLACER',
      CBM002_CalculatedScores.WRITE_ACCUPLACER length = 8   
         label = 'WRITE_ACCUPLACER',
      CBM002_CalculatedScores.MATH_STANFORD length = 8   
         label = 'MATH_STANFORD',
      CBM002_CalculatedScores.READ_STANFORD length = 8   
         label = 'READ_STANFORD',
      CBM002_CalculatedScores.WRITE_STANFORD length = 8   
         label = 'WRITE_STANFORD',
      CBM002_CalculatedScores.MATH_MAPS length = 8   
         label = 'MATH_MAPS',
      CBM002_CalculatedScores.READ_MAPS length = 8   
         label = 'READ_MAPS',
      CBM002_CalculatedScores.WRITE_MAPS length = 8   
         label = 'WRITE_MAPS',
      CBM002_International.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_International.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_International.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_International.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_International.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_International.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_International.EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_CalculatedScores.Read_ACT length = 8   
         label = 'Read_ACT',
      CBM002_CalculatedScores.Write_ACT length = 8   
         label = 'Write_ACT',
      CBM002_CalculatedScores.Read_Taks length = 8   
         label = 'Read_Taks',
      CBM002_CalculatedScores.Write_Taks length = 8   
         label = 'Write_Taks',
      CBM002_CalculatedScores.WRITEESSAY_COMPASS length = 8   
         label = 'WRITEESSAY_COMPASS',
      CBM002_CalculatedScores.WRITEESSAY_ACCUPLACER length = 8   
         label = 'WRITEESSAY_ACCUPLACER',
      CBM002_CalculatedScores.WRITEESSAY_ASSET length = 8   
         label = 'WRITEESSAY_ASSET',
      CBM002_CalculatedScores.WRITEESSAY_STANFORD length = 8   
         label = 'WRITEESSAY_STANFORD',
      CBM002_CalculatedScores.WRITEESSAY_MAPS length = 8   
         label = 'WRITEESSAY_MAPS',
      CBM002_International.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      CBM002_International.Flex length = 1   
         label = 'Flex',
      CBM002_International.Year length = 4   
         label = 'Year',
      CBM002_CalculatedScores.MATH_TSIA length = 8   
         label = 'MATH_TSIA',
      CBM002_CalculatedScores.READ_TSIA length = 8   
         label = 'READ_TSIA',
      CBM002_CalculatedScores.WRITE_TSIA length = 8   
         label = 'WRITE_TSIA',
      CBM002_CalculatedScores.MATH_TSIA2 length = 8   
         label = 'MATH_TSIA2',
      CBM002_CalculatedScores.READ_TSIA2 length = 8   
         label = 'READ_TSIA2',
      CBM002_CalculatedScores.WRITE_TSIA2 length = 8   
         label = 'WRITE_TSIA2',
      CBM002_CalculatedScores.WRITEESSAY_TSIA length = 8   
         label = 'WRITEESSAY_TSIA',
      CBM002_CalculatedScores.WRITEESSAY_TSIA2 length = 8   
         label = 'WRITEESSAY_TSIA2',
      CBM002_CalculatedScores.MATH_SAT_Old length = 8   
         label = 'MATH_SAT_Old',
      CBM002_CalculatedScores.VERBAL_SAT_Old length = 8   
         label = 'VERBAL_SAT_Old',
      CBM002_CalculatedScores.Total_SAT_Old length = 8   
         label = 'Total_SAT_Old',
      CBM002_CalculatedScores.MATH_TSIA2_Diagnostic length = 8   
         label = 'MATH_TSIA2_Diagnostic',
      CBM002_CalculatedScores.READ_TSIA2_Diagnostic length = 8   
         label = 'READ_TSIA2_Diagnostic',
      CBM002_CalculatedScores.WRITE_TSIA2_Diagnostic length = 8   
         label = 'WRITE_TSIA2_Diagnostic',
      CBM002_CalculatedScores.Math_ACT_Old length = 8   
         label = 'Math_ACT_Old',
      CBM002_CalculatedScores.Verbal_ACT_Old length = 8   
         label = 'Read_ACT_Old',
      CBM002_CalculatedScores.Total_ACT_Old length = 8   
         label = 'Total_ACT_Old'
   from
      work.CBM002_International as CBM002_International left join 
      work.CBM002_CalculatedScores as CBM002_CalculatedScores
         on
         (
            CBM002_International.EMPLID = CBM002_CalculatedScores.EMPLID
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end SAT/ACT/TAKS TestScores Final **/

/*==========================================================================* 
 * Step:            TSI Source Table                      A5B29B8Q.BZ000BTM * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   DistinctStudents -                    A5B29B8Q.BS00046S * 
 *                   work.DistinctStudents                                  * 
 *                  PS_UTA_TSI_SECTION_Extract -          A5B29B8Q.BE000083 * 
 *                   ADWSTGPR.PS_UTA_TSI_SECTION_Extract                    * 
 * Target Table:    TSI_Source - work.TSI_Source          A5B29B8Q.BS00046X * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTM);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.DistinctStudents, DATA)) or 
         %sysfunc(exist(work.DistinctStudents, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.DistinctStudents out = work.etls_contents(keep = nobs) noprint; 
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
   delete TSI_Source;
quit;

proc sql;
   create table work.TSI_Source as
   select
      DistinctStudents.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      DistinctStudents.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      DistinctStudents.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      PS_UTA_TSI_SECTION_Extract.DATE_TAKEN length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DATE_TAKEN',
      PS_UTA_TSI_SECTION_Extract.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_UTA_TSI_SECTION_Extract.UTA_TEST_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TEST_DT',
      PS_UTA_TSI_SECTION_Extract.UTA_TSI_AREA length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_AREA',
      PS_UTA_TSI_SECTION_Extract.UTA_TSI_METHOD length = 4   
         format = $4.
         informat = $4.
         label = 'UTA_TSI_METHOD',
      PS_UTA_TSI_SECTION_Extract.UTA_TSI_SCORE length = 8   
         format = 8.2
         informat = 8.2
         label = 'UTA_TSI_SCORE',
      PS_UTA_TSI_SECTION_Extract.UTA_TSI_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_STATUS'
   from
      work.DistinctStudents as DistinctStudents left join 
      ADWSTGPR.PS_UTA_TSI_SECTION_Extract as PS_UTA_TSI_SECTION_Extract
         on
         (
            DistinctStudents.EMPLID = PS_UTA_TSI_SECTION_Extract.EMPLID
         )
   where
      PS_UTA_TSI_SECTION_Extract.UTA_TSI_AREA NOT IS MISSING 
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end TSI Source Table **/

/*==========================================================================* 
 * Step:            Max TSI Section C/Asmt-TPlac          A5B29B8Q.BZ000BTN * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    TSI_Source - work.TSI_Source          A5B29B8Q.BS00046X * 
 * Target Table:    TSI_Section_C - work.TSI_Section_C    A5B29B8Q.BS00046Y * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTN);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.TSI_Source, DATA)) or 
         %sysfunc(exist(work.TSI_Source, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.TSI_Source out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.TSI_Source); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete TSI_Section_C;
quit;

proc sql;
   create table work.TSI_Section_C as
   select distinct
      TSI_Source.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      TSI_Source.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      TSI_Source.UTA_TSI_AREA length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_AREA',
      TSI_Source.UTA_TSI_METHOD length = 4   
         format = $4.
         informat = $4.
         label = 'UTA_TSI_METHOD',
      MAX(TSI_Source.UTA_TSI_SCORE) as UTA_TSI_SCORE length = 8   
         format = 8.2
         informat = 8.2
         label = 'UTA_TSI_SCORE',
      cats(
      case strip(TSI_Source.UTA_TSI_AREA)
      	when 'R' then 'READ_TSI_'
      	when 'M' then 'MATH_TSI_'
      	when 'W' then 'WRITE_TSI_' end 
      ,strip(TSI_Source.UTA_TSI_METHOD)
      ,'METHOD') as TSI_AREA_METHOD length = 20   
         label = 'TSI_AREA_METHOD'
   from
      work.TSI_Source as TSI_Source
   where
      TSI_Source.UTA_TSI_STATUS = 'C'
      and TSI_Source.UTA_TSI_METHOD IN ('ACT', 'SAT', 'TAKS', 'CORB','THEA', 'TASP', 'COMP', 'ASST', 'ACCU', 'STAN', 'MAPS','TXCB','TSIA','TSI2')
   group by
      TSI_Source.STRM,
      TSI_Source.EMPLID,
      TSI_Source.UTA_TSI_AREA,
      TSI_Source.UTA_TSI_METHOD
   having
      TSI_Source.EFFDT = MAX(TSI_Source.EFFDT)
      and TSI_Source.EFFDT <= TSI_Source.CENSUS_DT
   order by
      TSI_Source.STRM,
      TSI_Source.EMPLID,
      TSI_Source.UTA_TSI_METHOD,
      TSI_Source.UTA_TSI_AREA
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Max TSI Section C/Asmt-TPlac **/

/*==========================================================================* 
 * Step:            MAX TSI Status (Other Method)         A5B29B8Q.BZ000BTO * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    TSI_Source - work.TSI_Source          A5B29B8Q.BS00046X * 
 * Target Table:    TSI_Other_Method -                    A5B29B8Q.BS00046Z * 
 *                   work.TSI_Other_Method                                  * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTO);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.TSI_Source, DATA)) or 
         %sysfunc(exist(work.TSI_Source, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.TSI_Source out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.TSI_Source); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete TSI_Other_Method;
quit;

proc sql;
   create table work.TSI_Other_Method as
   select
      TSI_Source.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      TSI_Source.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      TSI_Source.UTA_TSI_AREA length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_AREA',
      TSI_Source.UTA_TSI_METHOD length = 4   
         format = $4.
         informat = $4.
         label = 'UTA_TSI_METHOD',
      TSI_Source.UTA_TSI_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_STATUS'
   from
      work.TSI_Source as TSI_Source
   where
      TSI_Source.UTA_TSI_METHOD = 'OTHR'
      and TSI_Source.DATE_TAKEN <= TSI_Source.CENSUS_DT
      and TSI_Source.DATE_TAKEN is not missing 
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end MAX TSI Status (Other Method) **/

/*==========================================================================* 
 * Step:            Max TSI Comp                          A5B29B8Q.BZ000BTP * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    TSI_Source - work.TSI_Source          A5B29B8Q.BS00046X * 
 * Target Table:    Max_TSI_Comp - work.Max_TSI_Comp      A5B29B8Q.BS000470 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTP);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.TSI_Source, DATA)) or 
         %sysfunc(exist(work.TSI_Source, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.TSI_Source out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.TSI_Source); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete Max_TSI_Comp;
quit;

proc sql;
   create table work.Max_TSI_Comp as
   select distinct
      TSI_Source.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      TSI_Source.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      TSI_Source.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      TSI_Source.DATE_TAKEN length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DATE_TAKEN',
      TSI_Source.UTA_TSI_AREA length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_AREA',
      TSI_Source.UTA_TSI_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_STATUS',
      case
      	when TSI_Source.CENSUS_DT = input("&current_term_census_date", BEST12.) then "&future_census"dt
      	when TSI_Source.CENSUS_DT <> input("&current_term_census_date", BEST12.) then input("&current_term_census_date", BEST12.)
      end as Future_Census length = 8   
         format = DATETIME20.
         informat = DATETIME20.
   from
      work.TSI_Source as TSI_Source
   where
      TSI_Source.UTA_TSI_STATUS = 'C'
   group by
      TSI_Source.STRM,
      TSI_Source.EMPLID,
      TSI_Source.UTA_TSI_AREA,
      TSI_Source.UTA_TSI_STATUS
   having
      TSI_Source.DATE_TAKEN = MAX(TSI_Source.DATE_TAKEN)
      and TSI_Source.DATE_TAKEN <= DATETIME()
   order by
      TSI_Source.STRM,
      TSI_Source.EMPLID,
      TSI_Source.UTA_TSI_AREA,
      TSI_Source.UTA_TSI_STATUS
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Max TSI Comp **/

/*==========================================================================* 
 * Step:            MAX TSI Sta Sec                       A5B29B8Q.BZ000BTQ * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   TSI_Source - work.TSI_Source          A5B29B8Q.BS00046X * 
 *                  PS_UTA_TSI_STA_EXM_Extract -          A5B29B8Q.BE000084 * 
 *                   ADWSTGPR.PS_UTA_TSI_STA_EXM_Extract                    * 
 * Target Table:    MAX_TSI_Sta_Sec -                     A5B29B8Q.BS000471 * 
 *                   work.MAX_TSI_Sta_Sec                                   * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTQ);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.TSI_Source, DATA)) or 
         %sysfunc(exist(work.TSI_Source, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.TSI_Source out = work.etls_contents(keep = nobs) noprint; 
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
   delete MAX_TSI_Sta_Sec;
quit;

proc sql;
   create table work.MAX_TSI_Sta_Sec as
   select
      TSI_Source.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_UTA_TSI_STA_EXM_Extract.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      TSI_Source.UTA_TSI_AREA length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_AREA',
      PS_UTA_TSI_STA_EXM_Extract.STATUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'STATUS_DT'
   from
      ADWSTGPR.PS_UTA_TSI_STA_EXM_Extract as PS_UTA_TSI_STA_EXM_Extract inner join 
      work.TSI_Source as TSI_Source
         on
         (
            PS_UTA_TSI_STA_EXM_Extract.EMPLID = TSI_Source.EMPLID
         )
   where
      PS_UTA_TSI_STA_EXM_Extract.UTA_TSI_OVERALL <> 'C'
      and TSI_Source.UTA_TSI_STATUS = 'C'
   group by
      TSI_Source.STRM,
      TSI_Source.EMPLID,
      TSI_Source.UTA_TSI_AREA,
      TSI_Source.UTA_TSI_STATUS
   having
      TSI_Source.DATE_TAKEN = MAX(TSI_Source.DATE_TAKEN)
      and TSI_Source.DATE_TAKEN <= TSI_Source.CENSUS_DT
      and TSI_Source.DATE_TAKEN is not missing 
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end MAX TSI Sta Sec **/

/*==========================================================================* 
 * Step:            TSI STA SEC                           A5B29B8Q.BZ000BTR * 
 * Transform:       Join                                                    * 
 * Description:     Check for previously reported                           * 
 *                                                                          * 
 * Source Table:    MAX_TSI_Sta_Sec -                     A5B29B8Q.BS000471 * 
 *                   work.MAX_TSI_Sta_Sec                                   * 
 * Target Table:    TSI_STA_SEC_FINAL - work.TSI_STA_SEC  A5B29B8Q.BS000472 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTR);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.MAX_TSI_Sta_Sec, DATA)) or 
         %sysfunc(exist(work.MAX_TSI_Sta_Sec, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.MAX_TSI_Sta_Sec out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.MAX_TSI_Sta_Sec); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete TSI_STA_SEC;
quit;

proc sql;
   create table work.TSI_STA_SEC as
   select
      MAX_TSI_Sta_Sec.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      MAX_TSI_Sta_Sec.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      MAX( 
      case when MAX_TSI_Sta_Sec.UTA_TSI_AREA ='M' then 1 else 0 end 
      ) as MATH_TSI_PRIOR_REPORTED length = 8   
         label = 'MATH_TSI_PRIOR_REPORTED',
      MAX( 
      case when MAX_TSI_Sta_Sec.UTA_TSI_AREA ='R' then 1 else 0 end 
      ) as READ_TSI_PRIOR_REPORTED length = 8   
         label = 'READ_TSI_PRIOR_REPORTED',
      MAX( 
      case when MAX_TSI_Sta_Sec.UTA_TSI_AREA ='W' then 1 else 0 end 
      ) as WRITE_TSI_PRIOR_REPORTED length = 8   
         label = 'WRITE_TSI_PRIOR_REPORTED'
   from
      work.MAX_TSI_Sta_Sec as MAX_TSI_Sta_Sec
   group by
      MAX_TSI_Sta_Sec.STRM,
      MAX_TSI_Sta_Sec.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end TSI STA SEC **/

/*==========================================================================* 
 * Step:            TSI Section C / TPLAC  Final          A5B29B8Q.BZ000BTS * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    TSI_Section_C - work.TSI_Section_C    A5B29B8Q.BS00046Y * 
 * Target Table:    TSI_Section_C_Final -                 A5B29B8Q.BS000473 * 
 *                   work.TSI_Section_C_Final                               * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTS);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.TSI_Section_C, DATA)) or 
         %sysfunc(exist(work.TSI_Section_C, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.TSI_Section_C out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.TSI_Section_C); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete TSI_Section_C_Final;
quit;

proc sql;
   create table work.TSI_Section_C_Final as
   select distinct
      TSI_Section_C.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      TSI_Section_C.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD = 'ACT' and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_ACTMETHOD length = 8   
         label = 'Math_TSI_ACTMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD  = 'ACT' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1 
      else 0 
      end 
      ) as Read_TSI_ACTMETHOD length = 8   
         label = 'Read_TSI_ACTMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD  = 'ACT' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1 
      else 0 
      end 
      ) as Write_TSI_ACTMETHOD length = 8   
         label = 'Write_TSI_ACTMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD = 'SAT'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_SATMETHOD length = 8   
         label = 'Math_TSI_SATMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD = 'SAT' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1 
      else 0 
      end 
      ) as Read_TSI_SATMETHOD length = 8   
         label = 'Read_TSI_SATMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD = 'SAT' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1 
      else 0 
      end 
      ) as Write_TSI_SATMETHOD length = 8   
         label = 'Write_TSI_SATMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD = 'TAKS' and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_TAKSMETHOD length = 8   
         label = 'Math_TSI_TAKSMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD  = 'TAKS'  and TSI_Section_C.UTA_TSI_AREA = 'R' then 1 
      else 0 
      end 
      ) as Read_TSI_TAKSMETHOD length = 8   
         label = 'Read_TSI_TAKSMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD  = 'TAKS'  and TSI_Section_C.UTA_TSI_AREA = 'W' then 1 
      else 0 
      end 
      ) as Write_TSI_TAKSMETHOD length = 8   
         label = 'Write_TSI_TAKSMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD =  'CORB' and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_CORBMETHOD length = 8   
         label = 'Math_TSI_CORBMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD  =  'CORB'  and TSI_Section_C.UTA_TSI_AREA = 'R' then 1 
      else 0 
      end 
      ) as Read_TSI_CORBMETHOD length = 8   
         label = 'Read_TSI_CORBMETHOD',
      MAX( 
      case  
      	when TSI_Section_C.UTA_TSI_METHOD  =  'CORB'  and TSI_Section_C.UTA_TSI_AREA = 'W' then 1 
      else 0 
      end 
      ) as Write_TSI_CORBMETHOD length = 8   
         label = 'Write_TSI_CORBMETHOD',
      MAX(  
      case   
      when TSI_Section_C.UTA_TSI_METHOD =  'THEA'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1  
      else 0  
      end  
      ) as Math_TSI_THEAMETHOD length = 8   
         label = 'Math_TSI_THEAMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD  =  'THEA' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1
      else 0
      end
      ) as Read_TSI_THEAMETHOD length = 8   
         label = 'Read_TSI_THEAMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =   'THEA' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_THEAMETHOD length = 8   
         label = 'Write_TSI_THEAMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =  'TASP'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_TASPMETHOD length = 8   
         label = 'Math_TSI_TASPMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD  =  'TASP' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1 
      else 0 
      end 
      ) as Read_TSI_TASPMETHOD length = 8   
         label = 'Read_TSI_TASPMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =   'TASP' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_TASPMETHOD length = 8   
         label = 'Write_TSI_TASPMETHOD',
      MAX(
      case  
      when TSI_Section_C.UTA_TSI_METHOD =  'COMP'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_COMPMETHOD length = 8   
         label = 'Math_TSI_COMPMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD  =  'COMP' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1
      else 0
      end
      ) as Read_TSI_COMPMETHOD length = 8   
         label = 'Read_TSI_COMPMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =   'COMP' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_COMPMETHOD length = 8   
         label = 'Write_TSI_COMPMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =  'ASST'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_ASSTMETHOD length = 8   
         label = 'Math_TSI_ASSTMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD  =  'ASST' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1
      else 0
      end
      ) as Read_TSI_ASSTMETHOD length = 8   
         label = 'Read_TSI_ASSTMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =   'ASST' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_ASSTMETHOD length = 8   
         label = 'Write_TSI_ASSTMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =  'ACCU'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_ACCUMETHOD length = 8   
         label = 'Math_TSI_ACCUMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD  =  'ACCU' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1
      else 0
      end
      ) as Read_TSI_ACCUMETHOD length = 8   
         label = 'Read_TSI_ACCUMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =   'ACCU' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_ACCUMETHOD length = 8   
         label = 'Write_TSI_ACCUMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =  'STAN'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_STANMETHOD length = 8   
         label = 'Math_TSI_STANMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD  =  'STAN' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1
      else 0
      end
      ) as Read_TSI_STANMETHOD length = 8   
         label = 'Read_TSI_STANMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =   'STAN' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_STANMETHOD length = 8   
         label = 'Write_TSI_STANMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD = ' MAPS'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_MAPSMETHOD length = 8   
         label = 'Math_TSI_MAPSMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD  =  'MAPS' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1
      else 0
      end
      ) as Read_TSI_MAPSMETHOD length = 8   
         label = 'Read_TSI_MAPSMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =  'MAPS' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_MAPSMETHOD length = 8   
         label = 'Write_TSI_MAPSMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =  'TSIA'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_TSIAMETHOD length = 8   
         label = 'Math_TSI_TSIAMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD  =  'TSIA' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1
      else 0
      end
      ) as Read_TSI_TSIAMETHOD length = 8   
         label = 'Read_TSI_TSIAMETHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =   'TSIA' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_TSIAMETHOD length = 8   
         label = 'Write_TSI_TSIAMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =   'TCXB' and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_TXCBMETHOD length = 8   
         label = 'Math_TSI_TXCBMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =   'TCXB' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1 
      else 0 
      end 
      ) as Read_TSI_TXCBMETHOD length = 8   
         label = 'Read_TSI_TXCBMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =   'TCXB' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1 
      else 0 
      end 
      ) as Write_TSI_TXCBMETHOD length = 8   
         label = 'Write_TSI_TXCBMETHOD',
      MAX( 
      case  
      when TSI_Section_C.UTA_TSI_METHOD =  'TSI2'  and TSI_Section_C.UTA_TSI_AREA = 'M' then 1 
      else 0 
      end 
      ) as Math_TSI_TSIA2METHOD length = 8   
         label = 'Math_TSI_TSIA2METHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD  =  'TSI2' and TSI_Section_C.UTA_TSI_AREA = 'R' then 1
      else 0
      end
      ) as Read_TSI_TSIA2METHOD length = 8   
         label = 'Read_TSI_TSIA2METHOD',
      MAX(
      case 
      when TSI_Section_C.UTA_TSI_METHOD =   'TSI2' and TSI_Section_C.UTA_TSI_AREA = 'W' then 1
      else 0
      end
      ) as Write_TSI_TSIA2METHOD length = 8   
         label = 'Write_TSI_TSIA2METHOD'
   from
      work.TSI_Section_C as TSI_Section_C
   group by
      TSI_Section_C.STRM,
      TSI_Section_C.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end TSI Section C / TPLAC  Final **/

/*==========================================================================* 
 * Step:            TSI Sec Comp Final                    A5B29B8Q.BZ000BTT * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    Max_TSI_Comp - work.Max_TSI_Comp      A5B29B8Q.BS000470 * 
 * Target Table:    TSI_SEC_COMP_FINAL -                  A5B29B8Q.BS000474 * 
 *                   work.TSI_SEC_COMP_FINAL                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTT);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.Max_TSI_Comp, DATA)) or 
         %sysfunc(exist(work.Max_TSI_Comp, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.Max_TSI_Comp out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.Max_TSI_Comp); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete TSI_SEC_COMP_FINAL;
quit;

proc sql;
   create table work.TSI_SEC_COMP_FINAL as
   select distinct
      Max_TSI_Comp.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      Max_TSI_Comp.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      MAX( 
      case when (Max_TSI_Comp.DATE_TAKEN  > Max_TSI_Comp.CENSUS_DT and Max_TSI_Comp.DATE_TAKEN < Max_TSI_Comp.Future_Census ) 
              and Max_TSI_Comp.UTA_TSI_AREA ='M' then 1  
      else 0  
      end  
      ) as MathTSIPassedAfterCensus length = 8   
         label = 'MathTSIPassedAfterCensus',
      MAX(
      case when (Max_TSI_Comp.DATE_TAKEN  > Max_TSI_Comp.CENSUS_DT and Max_TSI_Comp.DATE_TAKEN < Max_TSI_Comp.Future_Census )
              and Max_TSI_Comp.UTA_TSI_AREA ='R' then 1 
      else 0 
      end 
      ) as ReadTSIPassedAfterCensus length = 8   
         label = 'ReadTSIPassedAfterCensus',
      MAX(
      case when (Max_TSI_Comp.DATE_TAKEN  > Max_TSI_Comp.CENSUS_DT and Max_TSI_Comp.DATE_TAKEN < Max_TSI_Comp.Future_Census )
              and Max_TSI_Comp.UTA_TSI_AREA ='W' then 1 
      else 0 
      end 
      ) as WriteTSIPassedAfterCensus length = 8   
         label = 'WriteTSIPassedAfterCensus'
   from
      work.Max_TSI_Comp as Max_TSI_Comp
   group by
      Max_TSI_Comp.STRM,
      Max_TSI_Comp.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end TSI Sec Comp Final **/

/*==========================================================================* 
 * Step:            TSI Status( Other Method) Final       A5B29B8Q.BZ000BTU * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    TSI_Other_Method -                    A5B29B8Q.BS00046Z * 
 *                   work.TSI_Other_Method                                  * 
 * Target Table:    TSI_Status_Final -                    A5B29B8Q.BS000475 * 
 *                   work.TSI_Status_Final                                  * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTU);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.TSI_Other_Method, DATA)) or 
         %sysfunc(exist(work.TSI_Other_Method, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.TSI_Other_Method out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.TSI_Other_Method); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete TSI_Status_Final;
quit;

proc sql;
   create table work.TSI_Status_Final as
   select distinct
      TSI_Other_Method.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      TSI_Other_Method.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      MAX( 
      case 
      	when TSI_Other_Method.UTA_TSI_AREA ='M' and TSI_Other_Method.UTA_TSI_STATUS = 'C'  then 1 
      else 0 
      end 
      ) as MATH_TSI_STATUS length = 8   
         label = 'MATH_TSI_STATUS',
      MAX( 
      case 
      	when TSI_Other_Method.UTA_TSI_AREA ='R' and TSI_Other_Method.UTA_TSI_STATUS = 'C'  then 1 
      else 0 
      end 
      ) as READ_TSI_STATUS length = 8   
         label = 'READ_TSI_STATUS',
      MAX( 
      case 
      	when TSI_Other_Method.UTA_TSI_AREA = 'W' and TSI_Other_Method.UTA_TSI_STATUS = 'C'  then 1 
      else 0 
      end 
      ) as WRITE_TSI_STATUS length = 8   
         label = 'WRITE_TSI_STATUS'
   from
      work.TSI_Other_Method as TSI_Other_Method
   group by
      TSI_Other_Method.STRM,
      TSI_Other_Method.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end TSI Status( Other Method) Final **/

/*==========================================================================* 
 * Step:            TSI Final                             A5B29B8Q.BZ000BTV * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   TestScores_Final -                    A5B29B8Q.BS00046W * 
 *                   work.TestScores_Final                                  * 
 *                  PS_UTA_TSI_STA_EXM_Extract -          A5B29B8Q.BE000084 * 
 *                   ADWSTGPR.PS_UTA_TSI_STA_EXM_Extract                    * 
 *                  TSI_SEC_COMP_FINAL -                  A5B29B8Q.BS000474 * 
 *                   work.TSI_SEC_COMP_FINAL                                * 
 *                  TSI_Status_Final -                    A5B29B8Q.BS000475 * 
 *                   work.TSI_Status_Final                                  * 
 *                  PS_UTA_TSI_TRM_EXM_Extract -          A5B29B8Q.BE000085 * 
 *                   ADWSTGPR.PS_UTA_TSI_TRM_EXM_Extract                    * 
 *                  TSI_STA_SEC_FINAL - work.TSI_STA_SEC  A5B29B8Q.BS000472 * 
 *                  TSI_Section_C_Final -                 A5B29B8Q.BS000473 * 
 *                   work.TSI_Section_C_Final                               * 
 * Target Table:    CBM002_TSI - work.CBM002_TSI          A5B29B8Q.BS000476 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTV);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.TestScores_Final, DATA)) or 
         %sysfunc(exist(work.TestScores_Final, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.TestScores_Final out = work.etls_contents(keep = nobs) noprint; 
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
   delete CBM002_TSI;
quit;

proc sql;
   create table work.CBM002_TSI as
   select distinct
      TestScores_Final.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      TestScores_Final.National_Id length = 9   
         label = 'National_Id',
      TestScores_Final.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      TestScores_Final.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      TestScores_Final.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      TestScores_Final.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      TestScores_Final.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      TestScores_Final.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      TestScores_Final.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      TestScores_Final.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      TestScores_Final.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      TestScores_Final.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      TestScores_Final.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      TestScores_Final.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      TestScores_Final.EFFSEQ length = 8   
         label = 'EFFSEQ',
      TestScores_Final.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      TestScores_Final.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      TestScores_Final.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      TestScores_Final.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      TestScores_Final.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      TestScores_Final.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      TestScores_Final.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      TestScores_Final.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      TestScores_Final.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      TestScores_Final.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      TestScores_Final.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      TestScores_Final.ADM_ADMIT_TERM length = 8   
         label = 'ADMIT_TERM',
      TestScores_Final.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      TestScores_Final.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      TestScores_Final.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      TestScores_Final.Race_White length = 1   
         format = $1.
         informat = $1.
         label = 'Race_White',
      TestScores_Final.Race_Black length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Black',
      TestScores_Final.Race_Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Asian',
      TestScores_Final.Race_AmIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'Race_AmIndAlsknNatv',
      TestScores_Final.Race_UnknwnNotRptd length = 1   
         format = $1.
         informat = $1.
         label = 'Race_UnknwnNotRptd',
      TestScores_Final.Race_NatHawnOPI length = 1   
         format = $1.
         informat = $1.
         label = 'Race_NatHawnOPI',
      TestScores_Final.ETHNIC_ORIGIN length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      TestScores_Final.ETHNIC_COUNT length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_COUNT',
      TestScores_Final.FERPA_FLAG length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA_FLAG',
      TestScores_Final.GENDER length = 1   
         format = $1.
         informat = $1.
         label = 'GENDER',
      TestScores_Final.BIRTHDATE length = 8   
         format = $8.
         informat = $8.
         label = 'BIRTHDATE',
      TestScores_Final.TUITION_EXCPT length = 5   
         format = $5.
         informat = $5.
         label = 'TUITION_EXCPT',
      TestScores_Final.TUITION_RES length = 5   
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      TestScores_Final.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      dhms(datepart(PS_UTA_TSI_STA_EXM_Extract.STATUS_DT),0,0,0) as STATUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'STATUS_DT',
      PS_UTA_TSI_STA_EXM_Extract.UTA_MATH_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_MATH_STATUS',
      PS_UTA_TSI_STA_EXM_Extract.UTA_READ_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_READ_STATUS',
      PS_UTA_TSI_STA_EXM_Extract.UTA_TSI_EXMPT_TYP length = 4   
         format = $4.
         informat = $4.
         label = 'UTA_TSI_EXMPT_TYP',
      PS_UTA_TSI_STA_EXM_Extract.UTA_TSI_OVERALL length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_OVERALL',
      PS_UTA_TSI_STA_EXM_Extract.UTA_WRITE_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_WRITE_STATUS',
      ifn( TestScores_Final.PriorEnrolled = 'N' ,0,
      	ifn ( PS_UTA_TSI_STA_EXM_Extract2.EMPLID  is not missing, 1,
      	 	ifn(TSI_STA_SEC.MATH_TSI_PRIOR_REPORTED = 1, 1, 0))) as MATH_TSI_PRIOR_REPORTED length = 8   
         label = 'MATH_TSI_PRIOR_REPORTED',
      ifn( TestScores_Final.PriorEnrolled = 'N' ,0,
      	ifn ( PS_UTA_TSI_STA_EXM_Extract2.EMPLID  is not missing, 1,
      	 ifn(TSI_STA_SEC.READ_TSI_PRIOR_REPORTED = 1, 1, 0))) as READ_TSI_PRIOR_REPORTED length = 8   
         label = 'READ_TSI_PRIOR_REPORTED',
      ifn( TestScores_Final.PriorEnrolled = 'N' ,0,
      	ifn ( PS_UTA_TSI_STA_EXM_Extract2.EMPLID  is not missing, 1,
      	 ifn(TSI_STA_SEC.WRITE_TSI_PRIOR_REPORTED = 1, 1, 0))) as WRITE_TSI_PRIOR_REPORTED length = 8   
         label = 'WRITE_TSI_PRIOR_REPORTED',
      Max_TSI_TermExmp.UTA_TSI_TERM_EXMP length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_TERM_EXMP',
      IFN(TSI_SEC_COMP_FINAL.MathTSIPassedAfterCensus =1 or
               ((PS_UTA_TSI_STA_EXM_Extract.UTA_MATH_STATUS ='Y' or PS_UTA_TSI_STA_EXM_Extract.UTA_TSI_OVERALL ='C') and PS_UTA_TSI_STA_EXM_Extract.STATUS_DT >TestScores_Final.CENSUS_DT ),1,0) as MathTSIEndOfTerm length = 8   
         label = 'MathTSIEndOfTerm',
      IFN(TSI_SEC_COMP_FINAL.ReadTSIPassedAfterCensus =1 or 
               ((PS_UTA_TSI_STA_EXM_Extract.UTA_READ_STATUS ='Y' or PS_UTA_TSI_STA_EXM_Extract.UTA_TSI_OVERALL ='C') and PS_UTA_TSI_STA_EXM_Extract.STATUS_DT >TestScores_Final.CENSUS_DT ),1,0) as ReadTSIEndOfTerm length = 8   
         label = 'ReadTSIEndOfTerm',
      IFN(TSI_SEC_COMP_FINAL.WriteTSIPassedAfterCensus =1 or 
               ((PS_UTA_TSI_STA_EXM_Extract.UTA_WRITE_STATUS ='Y' or PS_UTA_TSI_STA_EXM_Extract.UTA_TSI_OVERALL ='C') and PS_UTA_TSI_STA_EXM_Extract.STATUS_DT >TestScores_Final.CENSUS_DT ),1,0) as WriteTSIEndOfTerm length = 8   
         label = 'WriteTSIEndOfTerm',
      TSI_Status_Final.MATH_TSI_STATUS length = 8   
         label = 'MATH_TSI_STATUS',
      TSI_Status_Final.READ_TSI_STATUS length = 8   
         label = 'READ_TSI_STATUS',
      TSI_Status_Final.WRITE_TSI_STATUS length = 8   
         label = 'WRITE_TSI_STATUS',
      TSI_Section_C_Final.Math_TSI_ACTMETHOD length = 8   
         label = 'Math_TSI_ACTMETHOD',
      TSI_Section_C_Final.Read_TSI_ACTMETHOD length = 8   
         label = 'Read_TSI_ACTMETHOD',
      TSI_Section_C_Final.Write_TSI_ACTMETHOD length = 8   
         label = 'Write_TSI_ACTMETHOD',
      TSI_Section_C_Final.Math_TSI_SATMETHOD length = 8   
         label = 'Math_TSI_SATMETHOD',
      TSI_Section_C_Final.Read_TSI_SATMETHOD length = 8   
         label = 'Read_TSI_SATMETHOD',
      TSI_Section_C_Final.Write_TSI_SATMETHOD length = 8   
         label = 'Write_TSI_SATMETHOD',
      TSI_Section_C_Final.Math_TSI_TAKSMETHOD length = 8   
         label = 'Math_TSI_TAKSMETHOD',
      TSI_Section_C_Final.Read_TSI_TAKSMETHOD length = 8   
         label = 'Read_TSI_TAKSMETHOD',
      TSI_Section_C_Final.Write_TSI_TAKSMETHOD length = 8   
         label = 'Write_TSI_TAKSMETHOD',
      TSI_Section_C_Final.Math_TSI_CORBMETHOD length = 8   
         label = 'Math_TSI_CORBMETHOD',
      TSI_Section_C_Final.Read_TSI_CORBMETHOD length = 8   
         label = 'Read_TSI_CORBMETHOD',
      TSI_Section_C_Final.Write_TSI_CORBMETHOD length = 8   
         label = 'Write_TSI_CORBMETHOD',
      TSI_Section_C_Final.Math_TSI_THEAMETHOD length = 8   
         label = 'Math_TSI_THEAMETHOD',
      TSI_Section_C_Final.Read_TSI_THEAMETHOD length = 8   
         label = 'Read_TSI_THEAMETHOD',
      TSI_Section_C_Final.Write_TSI_THEAMETHOD length = 8   
         label = 'Write_TSI_THEAMETHOD',
      TSI_Section_C_Final.Math_TSI_TASPMETHOD length = 8   
         label = 'Math_TSI_TASPMETHOD',
      TSI_Section_C_Final.Read_TSI_TASPMETHOD length = 8   
         label = 'Read_TSI_TASPMETHOD',
      TSI_Section_C_Final.Write_TSI_TASPMETHOD length = 8   
         label = 'Write_TSI_TASPMETHOD',
      TSI_Section_C_Final.Math_TSI_COMPMETHOD length = 8   
         label = 'Math_TSI_COMPMETHOD',
      TSI_Section_C_Final.Read_TSI_COMPMETHOD length = 8   
         label = 'Read_TSI_COMPMETHOD',
      TSI_Section_C_Final.Write_TSI_COMPMETHOD length = 8   
         label = 'Write_TSI_COMPMETHOD',
      TSI_Section_C_Final.Math_TSI_ASSTMETHOD length = 8   
         label = 'Math_TSI_ASSTMETHOD',
      TSI_Section_C_Final.Read_TSI_ASSTMETHOD length = 8   
         label = 'Read_TSI_ASSTMETHOD',
      TSI_Section_C_Final.Write_TSI_ASSTMETHOD length = 8   
         label = 'Write_TSI_ASSTMETHOD',
      TSI_Section_C_Final.Math_TSI_ACCUMETHOD length = 8   
         label = 'Math_TSI_ACCUMETHOD',
      TSI_Section_C_Final.Read_TSI_ACCUMETHOD length = 8   
         label = 'Read_TSI_ACCUMETHOD',
      TSI_Section_C_Final.Write_TSI_ACCUMETHOD length = 8   
         label = 'Write_TSI_ACCUMETHOD',
      TSI_Section_C_Final.Math_TSI_STANMETHOD length = 8   
         label = 'Math_TSI_STANMETHOD',
      TSI_Section_C_Final.Read_TSI_STANMETHOD length = 8   
         label = 'Read_TSI_STANMETHOD',
      TSI_Section_C_Final.Write_TSI_STANMETHOD length = 8   
         label = 'Write_TSI_STANMETHOD',
      TSI_Section_C_Final.Math_TSI_MAPSMETHOD length = 8   
         label = 'Math_TSI_MAPSMETHOD',
      TSI_Section_C_Final.Read_TSI_MAPSMETHOD length = 8   
         label = 'Read_TSI_MAPSMETHOD',
      TSI_Section_C_Final.Write_TSI_MAPSMETHOD length = 8   
         label = 'Write_TSI_MAPSMETHOD',
      TSI_Section_C_Final.Math_TSI_TSIAMETHOD length = 8   
         label = 'Math_TSI_TSIAMETHOD',
      TSI_Section_C_Final.Read_TSI_TSIAMETHOD length = 8   
         label = 'Read_TSI_TSIAMETHOD',
      TSI_Section_C_Final.Write_TSI_TSIAMETHOD length = 8   
         label = 'Write_TSI_TSIAMETHOD',
      TSI_Section_C_Final.Math_TSI_TXCBMETHOD length = 8   
         label = 'Math_TSI_TXCBMETHOD',
      TSI_Section_C_Final.Read_TSI_TXCBMETHOD length = 8   
         label = 'Read_TSI_TXCBMETHOD',
      TSI_Section_C_Final.Write_TSI_TXCBMETHOD length = 8   
         label = 'Write_TSI_TXCBMETHOD',
      case  
      	when TestScores_Final.EAPStudent ='Y' then '2'
      else '0' 
      end as TSI_Oblig_Waived length = 1   
         label = 'TSI_Oblig_Waived',
      TestScores_Final.Math_ACT length = 8   
         label = 'Math_ACT',
      TestScores_Final.Read_ACT length = 8   
         label = 'Read_ACT',
      TestScores_Final.Write_ACT length = 8   
         label = 'Write_ACT',
      TestScores_Final.Math_Taks length = 8   
         label = 'Math_Taks',
      TestScores_Final.MATH_SAT length = 8   
         label = 'MATH_SAT',
      TestScores_Final.VERBAL_SAT length = 8   
         label = 'VERBAL_SAT',
      TestScores_Final.Total_SAT length = 8   
         label = 'Total_SAT',
      TestScores_Final.English_Composite_ACT length = 8   
         label = 'English_Composite_ACT',
      TestScores_Final.MATH_THEA length = 8   
         label = 'MATH_THEA',
      TestScores_Final.READ_THEA length = 8   
         label = 'READ_THEA',
      TestScores_Final.WRITE_THEA length = 8   
         label = 'WRITE_THEA',
      TestScores_Final.MATH_COMPASS length = 8   
         label = 'MATH_COMPASS',
      TestScores_Final.READ_COMPASS length = 8   
         label = 'READ_COMPASS',
      TestScores_Final.WRITE_COMPASS length = 8   
         label = 'WRITE_COMPASS',
      TestScores_Final.MATH_ASSET length = 8   
         label = 'MATH_ASSET',
      TestScores_Final.READ_ASSET length = 8   
         label = 'READ_ASSET',
      TestScores_Final.WRITE_ASSET length = 8   
         label = 'WRITE_ASSET',
      TestScores_Final.MATH_ACCUPLACER length = 8   
         label = 'MATH_ACCUPLACER',
      TestScores_Final.READ_ACCUPLACER length = 8   
         label = 'READ_ACCUPLACER',
      TestScores_Final.WRITE_ACCUPLACER length = 8   
         label = 'WRITE_ACCUPLACER',
      TestScores_Final.MATH_STANFORD length = 8   
         label = 'MATH_STANFORD',
      TestScores_Final.READ_STANFORD length = 8   
         label = 'READ_STANFORD',
      TestScores_Final.WRITE_STANFORD length = 8   
         label = 'WRITE_STANFORD',
      TestScores_Final.MATH_MAPS length = 8   
         label = 'MATH_MAPS',
      TestScores_Final.READ_MAPS length = 8   
         label = 'READ_MAPS',
      TestScores_Final.WRITE_MAPS length = 8   
         label = 'WRITE_MAPS',
      TestScores_Final.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      TestScores_Final.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      TestScores_Final.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      TestScores_Final.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      TestScores_Final.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      TestScores_Final.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      TestScores_Final.EAPStudent length = 1   
         label = 'EAPStudent',
      TestScores_Final.Read_Taks length = 8   
         label = 'Read_Taks',
      TestScores_Final.Write_Taks length = 8   
         label = 'Write_Taks',
      TestScores_Final.WRITEESSAY_COMPASS length = 8   
         label = 'WRITEESSAY_COMPASS',
      TestScores_Final.WRITEESSAY_ACCUPLACER length = 8   
         label = 'WRITEESSAY_ACCUPLACER',
      TestScores_Final.WRITEESSAY_ASSET length = 8   
         label = 'WRITEESSAY_ASSET',
      TestScores_Final.WRITEESSAY_STANFORD length = 8   
         label = 'WRITEESSAY_STANFORD',
      TestScores_Final.WRITEESSAY_MAPS length = 8   
         label = 'WRITEESSAY_MAPS',
      TestScores_Final.PriorEnrolled length = 1   
         label = 'PriorEnrolled',
      TestScores_Final.Flex length = 1   
         label = 'Flex',
      TestScores_Final.Year length = 4   
         label = 'Year',
      TSI_Section_C_Final.Math_TSI_TSIA2METHOD length = 8   
         label = 'Math_TSI_TSIA2METHOD',
      TSI_Section_C_Final.Read_TSI_TSIA2METHOD length = 8   
         label = 'Read_TSI_TSIA2METHOD',
      TSI_Section_C_Final.Write_TSI_TSIA2METHOD length = 8   
         label = 'Write_TSI_TSIA2METHOD',
      TestScores_Final.MATH_TSIA length = 8   
         label = 'MATH_TSIA',
      TestScores_Final.READ_TSIA length = 8   
         label = 'READ_TSIA',
      TestScores_Final.WRITE_TSIA length = 8   
         label = 'WRITE_TSIA',
      TestScores_Final.MATH_TSIA2 length = 8   
         label = 'MATH_TSIA2',
      TestScores_Final.READ_TSIA2 length = 8   
         label = 'READ_TSIA2',
      TestScores_Final.WRITE_TSIA2 length = 8   
         label = 'WRITE_TSIA2',
      TestScores_Final.WRITEESSAY_TSIA length = 8   
         label = 'WRITEESSAY_TSIA',
      TestScores_Final.WRITEESSAY_TSIA2 length = 8   
         label = 'WRITEESSAY_TSIA2',
      TestScores_Final.MATH_SAT_Old length = 8   
         label = 'MATH_SAT_Old',
      TestScores_Final.VERBAL_SAT_Old length = 8   
         label = 'VERBAL_SAT_Old',
      TestScores_Final.Total_SAT_Old length = 8   
         label = 'Total_SAT_Old',
      TestScores_Final.MATH_TSIA2_Diagnostic length = 8   
         label = 'MATH_TSIA2_Diagnostic',
      TestScores_Final.READ_TSIA2_Diagnostic length = 8   
         label = 'READ_TSIA2_Diagnostic',
      TestScores_Final.WRITE_TSIA2_Diagnostic length = 8   
         label = 'WRITE_TSIA2_Diagnostic',
      TestScores_Final.Math_ACT_Old length = 8   
         label = 'Math_ACT_Old',
      TestScores_Final.Verbal_ACT_Old length = 8   
         label = 'Read_ACT_Old',
      TestScores_Final.Total_ACT_Old length = 8   
         label = 'Total_ACT_Old'
   from
      work.TestScores_Final as TestScores_Final left join 
      ADWSTGPR.PS_UTA_TSI_STA_EXM_Extract as PS_UTA_TSI_STA_EXM_Extract
         on
         (
            TestScores_Final.EMPLID = PS_UTA_TSI_STA_EXM_Extract.EMPLID
         ) left join 
      ADWSTGPR.PS_UTA_TSI_STA_EXM_Extract as PS_UTA_TSI_STA_EXM_Extract2
         on
         (
            TestScores_Final.EMPLID = PS_UTA_TSI_STA_EXM_Extract2.EMPLID
            and PS_UTA_TSI_STA_EXM_Extract2.UTA_TSI_OVERALL = 'C'
            and PS_UTA_TSI_STA_EXM_Extract2.STATUS_DT <= TestScores_Final.CENSUS_DT
         ) left join 
      (
         select distinct *
         from
            ADWSTGPR.PS_UTA_TSI_TRM_EXM_Extract
         group by
            PS_UTA_TSI_TRM_EXM_Extract.EMPLID,
            PS_UTA_TSI_TRM_EXM_Extract.STRM
         having
            PS_UTA_TSI_TRM_EXM_Extract.EFFDT = MAX(PS_UTA_TSI_TRM_EXM_Extract.EFFDT)
            and PS_UTA_TSI_TRM_EXM_Extract.EFFDT <= DATETIME()
      ) as Max_TSI_TermExmp
         on
         (
            TestScores_Final.EMPLID = Max_TSI_TermExmp.EMPLID
            and TestScores_Final.STRM = Max_TSI_TermExmp.STRM
         ) left join 
      work.TSI_Section_C_Final as TSI_Section_C_Final
         on
         (
            TestScores_Final.EMPLID = TSI_Section_C_Final.EMPLID
            and TestScores_Final.STRM = TSI_Section_C_Final.STRM
         ) left join 
      work.TSI_SEC_COMP_FINAL as TSI_SEC_COMP_FINAL
         on
         (
            TestScores_Final.EMPLID = TSI_SEC_COMP_FINAL.EMPLID
            and TestScores_Final.STRM = TSI_SEC_COMP_FINAL.STRM
         ) left join 
      work.TSI_Status_Final as TSI_Status_Final
         on
         (
            TestScores_Final.EMPLID = TSI_Status_Final.EMPLID
            and TestScores_Final.STRM = TSI_Status_Final.STRM
         ) left join 
      work.TSI_STA_SEC as TSI_STA_SEC
         on
         (
            TestScores_Final.EMPLID = TSI_STA_SEC.EMPLID
            and TestScores_Final.STRM = TSI_STA_SEC.STRM
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end TSI Final **/

/*==========================================================================* 
 * Step:            Transfer Course & Test Detail         A5B29B8Q.BZ000BTW * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   CBM002_TSI - work.CBM002_TSI          A5B29B8Q.BS000476 * 
 *                  PS_TRNS_TEST_DTL_Extract -            A5B29B8Q.BE00000X * 
 *                   ADWSTGPR.PS_TRNS_TEST_DTL_Extract                      * 
 *                  PS_TRNS_CRSE_DTL_Extract -            A5B29B8Q.BE00000Y * 
 *                   ADWSTGPR.PS_TRNS_CRSE_DTL_Extract                      * 
 * Target Table:    CBM002_Transfer_Course -              A5B29B8Q.BS000477 * 
 *                   work.CBM002_Transfer_Course                            * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTW);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_TSI, DATA)) or 
         %sysfunc(exist(work.CBM002_TSI, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_TSI out = work.etls_contents(keep = nobs) noprint; 
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
   delete CBM002_Transfer_Course;
quit;

proc sql;
   create table work.CBM002_Transfer_Course as
   select distinct
      CBM002_TSI.ACAD_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      CBM002_TSI.National_Id length = 9   
         label = 'National_Id',
      CBM002_TSI.ACAD_PROG length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      CBM002_TSI.CRSE_CAREER length = 4   
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      CBM002_TSI.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_TSI.INSTITUTION length = 5   
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      CBM002_TSI.STRM length = 4   
         format = $4.
         informat = $4.
         label = 'STRM',
      CBM002_TSI.TERM_BEGIN_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CBM002_TSI.TERM_END_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CBM002_TSI.CENSUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CBM002_TSI.Current_Term_End_date length = 8   
         format = Datetime20.
         informat = DATETIME20.
         label = 'Current_Term_End_date',
      CBM002_TSI.ACAD_ORG length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM002_TSI.STDNT_CAR_NBR length = 8   
         label = 'STDNT_CAR_NBR',
      CBM002_TSI.EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      CBM002_TSI.EFFSEQ length = 8   
         label = 'EFFSEQ',
      CBM002_TSI.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_TSI.REQ_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      CBM002_TSI.PLAN_TBL_EFFDT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'PLAN_TBL_EFFDT',
      CBM002_TSI.PLAN_TBL_ACAD_PROG length = 8   
         label = 'PLAN_TBL_ACAD_PROG',
      CBM002_TSI.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM002_TSI.DEGR_CHKOUT_STAT length = 2   
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      CBM002_TSI.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM002_TSI.ACAD_LEVEL_EOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      CBM002_TSI.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM002_TSI.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM002_TSI.ADM_APPL_NBR length = 8   
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      CBM002_TSI.ADM_ADMIT_TERM length = 8   
         label = 'ADMIT_TERM',
      CBM002_TSI.ADMIT_TYPE length = 3   
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      CBM002_TSI.RECRUITMENT_CAT length = 4   
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      CBM002_TSI.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_TSI.Race_White length = 1   
         format = $1.
         informat = $1.
         label = 'Race_White',
      CBM002_TSI.Race_Black length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Black',
      CBM002_TSI.Race_Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Race_Asian',
      CBM002_TSI.Race_AmIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'Race_AmIndAlsknNatv',
      CBM002_TSI.Race_UnknwnNotRptd length = 1   
         format = $1.
         informat = $1.
         label = 'Race_UnknwnNotRptd',
      CBM002_TSI.Race_NatHawnOPI length = 1   
         format = $1.
         informat = $1.
         label = 'Race_NatHawnOPI',
      CBM002_TSI.ETHNIC_ORIGIN length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CBM002_TSI.ETHNIC_COUNT length = 1   
         format = $1.
         informat = $1.
         label = 'ETHNIC_COUNT',
      CBM002_TSI.FERPA_FLAG length = 1   
         format = $1.
         informat = $1.
         label = 'FERPA_FLAG',
      CBM002_TSI.GENDER length = 1   
         format = $1.
         informat = $1.
         label = 'GENDER',
      CBM002_TSI.BIRTHDATE length = 8   
         format = $8.
         informat = $8.
         label = 'BIRTHDATE',
      CBM002_TSI.TUITION_EXCPT length = 5   
         format = $5.
         informat = $5.
         label = 'TUITION_EXCPT',
      CBM002_TSI.TUITION_RES length = 5   
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      CBM002_TSI.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      CBM002_TSI.STATUS_DT length = 8   
         format = DATETIME20.
         informat = DATETIME20.
         label = 'STATUS_DT',
      CBM002_TSI.UTA_MATH_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_MATH_STATUS',
      CBM002_TSI.UTA_READ_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_READ_STATUS',
      CBM002_TSI.UTA_TSI_EXMPT_TYP length = 4   
         format = $4.
         informat = $4.
         label = 'UTA_TSI_EXMPT_TYP',
      CBM002_TSI.UTA_TSI_OVERALL length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_OVERALL',
      CBM002_TSI.UTA_WRITE_STATUS length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_WRITE_STATUS',
      CBM002_TSI.UTA_TSI_TERM_EXMP length = 1   
         format = $1.
         informat = $1.
         label = 'UTA_TSI_TERM_EXMP',
      CBM002_TSI.MathTSIEndOfTerm length = 8   
         label = 'MathTSIEndOfTerm',
      CBM002_TSI.ReadTSIEndOfTerm length = 8   
         label = 'ReadTSIEndOfTerm',
      CBM002_TSI.WriteTSIEndOfTerm length = 8   
         label = 'WriteTSIEndOfTerm',
      CBM002_TSI.MATH_TSI_STATUS length = 8   
         label = 'MATH_TSI_STATUS',
      CBM002_TSI.READ_TSI_STATUS length = 8   
         label = 'READ_TSI_STATUS',
      CBM002_TSI.WRITE_TSI_STATUS length = 8   
         label = 'WRITE_TSI_STATUS',
      MIN( 
      case when Min_Articulation_Term.RQMNT_DESIGNTN in ('020','2092', '092') then Min_Articulation_Term.ARTICULATION_TERM  
      end 
       ) as Math_ArticulationTerm length = 4   
         label = 'Math_ArticulationTerm',
      MIN( 
      case when Min_Articulation_Term.RQMNT_DESIGNTN in ('040','060','070','080','098','4094','8098') then Min_Articulation_Term.ARTICULATION_TERM  
      end 
       ) as Read_ArticulationTerm length = 4   
         label = 'Read_ArticulationTerm',
      MIN( 
      case when Min_Articulation_Term.RQMNT_DESIGNTN in ('010','1091') then Min_Articulation_Term.ARTICULATION_TERM  
      end 
       ) as Write_ArticulationTerm length = 4   
         label = 'Write_ArticulationTerm',
      MAX(
      case when PS_TRNS_CRSE_DTL_Extract.RQMNT_DESIGNTN in ('020','2092', '092')  and PS_TRNS_CRSE_DTL_Extract.EMPLID is not null then 1
      else 0
      end
       ) as Math_Transfer_Course length = 8   
         label = 'Math_Transfer_Course',
      MAX(
      case when PS_TRNS_CRSE_DTL_Extract.RQMNT_DESIGNTN  in ('040', '060', '070', '080', '090', '098', '4094', '8098' ) and PS_TRNS_CRSE_DTL_Extract.EMPLID is not null then 1
      else 0
      end
       ) as Read_Transfer_Course length = 8   
         label = 'Read_Transfer_Course',
      MAX(
      case when PS_TRNS_CRSE_DTL_Extract.RQMNT_DESIGNTN in ('010','1091') and PS_TRNS_CRSE_DTL_Extract.EMPLID is not null then 1
      else 0
      end
       ) as Write_Transfer_Course length = 8   
         label = 'Write_Transfer_Course',
      CBM002_TSI.TSI_Oblig_Waived length = 1   
         label = 'TSI_Oblig_Waived',
      CBM002_TSI.MATH_TSI_PRIOR_REPORTED length = 8   
         label = 'MATH_TSI_PRIOR_REPORTED',
      CBM002_TSI.READ_TSI_PRIOR_REPORTED length = 8   
         label = 'READ_TSI_PRIOR_REPORTED',
      CBM002_TSI.WRITE_TSI_PRIOR_REPORTED length = 8   
         label = 'WRITE_TSI_PRIOR_REPORTED',
      CBM002_TSI.Math_TSI_ACTMETHOD length = 8   
         label = 'Math_TSI_ACTMETHOD',
      CBM002_TSI.Read_TSI_ACTMETHOD length = 8   
         label = 'Read_TSI_ACTMETHOD',
      CBM002_TSI.Write_TSI_ACTMETHOD length = 8   
         label = 'Write_TSI_ACTMETHOD',
      CBM002_TSI.Math_TSI_SATMETHOD length = 8   
         label = 'Math_TSI_SATMETHOD',
      CBM002_TSI.Read_TSI_SATMETHOD length = 8   
         label = 'Read_TSI_SATMETHOD',
      CBM002_TSI.Write_TSI_SATMETHOD length = 8   
         label = 'Write_TSI_SATMETHOD',
      CBM002_TSI.Math_TSI_TAKSMETHOD length = 8   
         label = 'Math_TSI_TAKSMETHOD',
      CBM002_TSI.Read_TSI_TAKSMETHOD length = 8   
         label = 'Read_TSI_TAKSMETHOD',
      CBM002_TSI.Write_TSI_TAKSMETHOD length = 8   
         label = 'Write_TSI_TAKSMETHOD',
      CBM002_TSI.Math_TSI_CORBMETHOD length = 8   
         label = 'Math_TSI_CORBMETHOD',
      CBM002_TSI.Read_TSI_CORBMETHOD length = 8   
         label = 'Read_TSI_CORBMETHOD',
      CBM002_TSI.Write_TSI_CORBMETHOD length = 8   
         label = 'Write_TSI_CORBMETHOD',
      CBM002_TSI.Math_TSI_THEAMETHOD length = 8   
         label = 'Math_TSI_THEAMETHOD',
      CBM002_TSI.Read_TSI_THEAMETHOD length = 8   
         label = 'Read_TSI_THEAMETHOD',
      CBM002_TSI.Write_TSI_THEAMETHOD length = 8   
         label = 'Write_TSI_THEAMETHOD',
      CBM002_TSI.Math_TSI_TASPMETHOD length = 8   
         label = 'Math_TSI_TASPMETHOD',
      CBM002_TSI.Read_TSI_TASPMETHOD length = 8   
         label = 'Read_TSI_TASPMETHOD',
      CBM002_TSI.Write_TSI_TASPMETHOD length = 8   
         label = 'Write_TSI_TASPMETHOD',
      CBM002_TSI.Math_TSI_COMPMETHOD length = 8   
         label = 'Math_TSI_COMPMETHOD',
      CBM002_TSI.Read_TSI_COMPMETHOD length = 8   
         label = 'Read_TSI_COMPMETHOD',
      CBM002_TSI.Write_TSI_COMPMETHOD length = 8   
         label = 'Write_TSI_COMPMETHOD',
      CBM002_TSI.Math_TSI_ASSTMETHOD length = 8   
         label = 'Math_TSI_ASSTMETHOD',
      CBM002_TSI.Read_TSI_ASSTMETHOD length = 8   
         label = 'Read_TSI_ASSTMETHOD',
      CBM002_TSI.Write_TSI_ASSTMETHOD length = 8   
         label = 'Write_TSI_ASSTMETHOD',
      CBM002_TSI.Math_TSI_ACCUMETHOD length = 8   
         label = 'Math_TSI_ACCUMETHOD',
      CBM002_TSI.Read_TSI_ACCUMETHOD length = 8   
         label = 'Read_TSI_ACCUMETHOD',
      CBM002_TSI.Write_TSI_ACCUMETHOD length = 8   
         label = 'Write_TSI_ACCUMETHOD',
      CBM002_TSI.Math_TSI_STANMETHOD length = 8   
         label = 'Math_TSI_STANMETHOD',
      CBM002_TSI.Read_TSI_STANMETHOD length = 8   
         label = 'Read_TSI_STANMETHOD',
      CBM002_TSI.Write_TSI_STANMETHOD length = 8   
         label = 'Write_TSI_STANMETHOD',
      CBM002_TSI.Math_TSI_MAPSMETHOD length = 8   
         label = 'Math_TSI_MAPSMETHOD',
      CBM002_TSI.Read_TSI_MAPSMETHOD length = 8   
         label = 'Read_TSI_MAPSMETHOD',
      CBM002_TSI.Write_TSI_MAPSMETHOD length = 8   
         label = 'Write_TSI_MAPSMETHOD',
      CBM002_TSI.Math_TSI_TSIAMETHOD length = 8   
         label = 'Math_TSI_TSIAMETHOD',
      CBM002_TSI.Read_TSI_TSIAMETHOD length = 8   
         label = 'Read_TSI_TSIAMETHOD',
      CBM002_TSI.Write_TSI_TSIAMETHOD length = 8   
         label = 'Write_TSI_TSIAMETHOD',
      CBM002_TSI.Math_ACT length = 8   
         label = 'Math_ACT',
      CBM002_TSI.Read_ACT length = 8   
         label = 'Read_ACT',
      CBM002_TSI.Write_ACT length = 8   
         label = 'Write_ACT',
      CBM002_TSI.Math_Taks length = 8   
         label = 'Math_Taks',
      CBM002_TSI.MATH_SAT length = 8   
         label = 'MATH_SAT',
      CBM002_TSI.VERBAL_SAT length = 8   
         label = 'VERBAL_SAT',
      CBM002_TSI.Total_SAT length = 8   
         label = 'Total_SAT',
      CBM002_TSI.English_Composite_ACT length = 8   
         label = 'English_Composite_ACT',
      CBM002_TSI.MATH_THEA length = 8   
         label = 'MATH_THEA',
      CBM002_TSI.READ_THEA length = 8   
         label = 'READ_THEA',
      CBM002_TSI.WRITE_THEA length = 8   
         label = 'WRITE_THEA',
      CBM002_TSI.MATH_COMPASS length = 8   
         label = 'MATH_COMPASS',
      CBM002_TSI.READ_COMPASS length = 8   
         label = 'READ_COMPASS',
      CBM002_TSI.WRITE_COMPASS length = 8   
         label = 'WRITE_COMPASS',
      CBM002_TSI.MATH_ASSET length = 8   
         label = 'MATH_ASSET',
      CBM002_TSI.READ_ASSET length = 8   
         label = 'READ_ASSET',
      CBM002_TSI.WRITE_ASSET length = 8   
         label = 'WRITE_ASSET',
      CBM002_TSI.MATH_ACCUPLACER length = 8   
         label = 'MATH_ACCUPLACER',
      CBM002_TSI.READ_ACCUPLACER length = 8   
         label = 'READ_ACCUPLACER',
      CBM002_TSI.WRITE_ACCUPLACER length = 8   
         label = 'WRITE_ACCUPLACER',
      CBM002_TSI.MATH_STANFORD length = 8   
         label = 'MATH_STANFORD',
      CBM002_TSI.READ_STANFORD length = 8   
         label = 'READ_STANFORD',
      CBM002_TSI.WRITE_STANFORD length = 8   
         label = 'WRITE_STANFORD',
      CBM002_TSI.MATH_MAPS length = 8   
         label = 'MATH_MAPS',
      CBM002_TSI.READ_MAPS length = 8   
         label = 'READ_MAPS',
      CBM002_TSI.WRITE_MAPS length = 8   
         label = 'WRITE_MAPS',
      IFC( CBM002_TSI.TSI_Oblig_Waived = '2', '6', 
                IFC(CBM002_TSI.TSI_Oblig_Waived in ('4','5' ,'6'), '0', 
                          IFC(CBM002_TSI.MATH_TSI_PRIOR_REPORTED = 1 ,  '0', 
      	IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'ACT' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT and CBM002_TSI.Math_ACT >0, 'J', 
      	      IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'ACT'   and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , '2', 
                                             IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'SAT' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT and CBM002_TSI.MATH_SAT >0   , 'C', 
      		IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'SAT' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT and CBM002_TSI.MATH_SAT =0 and CBM002_TSI.MATH_SAT_Old >0 , '3', 
      		   IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'TAKS' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , '4', 
      		          IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'UNDS' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , '7', 
      		                   IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'MAD' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , 'D', 
      	                                                    IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'MIL' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , 'E', 
      		                                     IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'AD' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , 'F',
      			                      IFC(CBM002_TSI.EAPStudent ='Y' and (CBM002_TSI.UTA_READ_STATUS ='Y' or CBM002_TSI.UTA_WRITE_STATUS ='Y'), 'G',
      				       IFC(CBM002_TSI.Math_TSI_TXCBMETHOD =1, 'B',
      				          IFC(CBM002_TSI.Math_TSI_ACTMETHOD =1  and CBM002_TSI.Math_ACT >0, 'J', 
      				                IFC(CBM002_TSI.Math_TSI_ACTMETHOD =1, '2',
      			                                                 IFC(CBM002_TSI.Math_TSI_SATMETHOD  =1, 'C',
      					           IFC(CBM002_TSI.Math_TSI_TAKSMETHOD = 1, '4',
      					                    IFC(CBM002_TSI.Math_TSI_CORBMETHOD = 1, '5', '1' ))))))))))))))))))) as MathTSIWaived length = 1   
         label = 'MathTSIWaived',
      IFC( CBM002_TSI.TSI_Oblig_Waived = '2', '6', 
                IFC(CBM002_TSI.TSI_Oblig_Waived in ('4','5' ,'6'), '0', 
                          IFC(CBM002_TSI.READ_TSI_PRIOR_REPORTED = 1,  '0', 
      	IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C'  and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'ACT' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT and CBM002_TSI.Read_ACT >0, 'J', 
      	      IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'ACT'   and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , '2', 
                                             IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'SAT' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT  and CBM002_TSI.VERBAL_SAT >0 , 'C', 
      		 IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'SAT' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT  and CBM002_TSI.VERBAL_SAT =0 and CBM002_TSI.VERBAL_SAT_Old >0, '3', 
      		 IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'TAKS' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , '4', 
      		          IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'UNDS' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , '7', 
      		                   IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'MAD' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , 'D', 
      	                                                    IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'MIL' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , 'E', 
      		                                     IFC(CBM002_TSI.UTA_TSI_OVERALL = 'C' and CBM002_TSI.UTA_TSI_EXMPT_TYP = 'AD' and CBM002_TSI.STATUS_DT <=CBM002_TSI.CENSUS_DT , 'F',
      			                      IFC(CBM002_TSI.EAPStudent ='Y' and (CBM002_TSI.UTA_MATH_STATUS ='Y' or CBM002_TSI.UTA_WRITE_STATUS ='Y'), 'G',
      				    IFC(CBM002_TSI.Read_TSI_TXCBMETHOD =1, 'B',
      			                               IFC(CBM002_TSI.Read_TSI_ACTMETHOD =1 and CBM002_TSI.Read_ACT >0, 'J', 
      				             IFC(CBM002_TSI.Read_TSI_ACTMETHOD =1, '2',
      			                                              IFC(CBM002_TSI.Read_TSI_SATMETHOD  =1, 'C',
      					       IFC(CBM002_TSI.Read_TSI_TAKSMETHOD = 1, '4',
      					                  IFC(CBM002_TSI.Read_TSI_CORBMETHOD = 1, '5', '1' ))))))))))))))))))) as ReadTSIWaived length = 1   
         label = 'ReadTSIWaived',
      CBM002_TSI.MathCoreCourseEnrolled length = 1   
         label = 'MathCoreCourseEnrolled',
      CBM002_TSI.ReadCoreCourseEnrolled length = 1   
         label = 'ReadCoreCourseEnrolled',
      CBM002_TSI.WriteCoreCourseEnrolled length = 1   
         label = 'WriteCoreCourseEnrolled',
      CBM002_TSI.MathCoreCoursePriorEnrolled length = 1   
         label = 'MathCoreCoursePriorEnrolled',
      CBM002_TSI.ReadCoreCoursePriorEnrolled length = 1   
         label = 'ReadCoreCoursePriorEnrolled',
      CBM002_TSI.WriteCoreCoursePriorEnrolled length = 1   
         label = 'WriteCoreCoursePriorEnrolled',
      CBM002_TSI.EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_TSI.Read_Taks length = 8   
         label = 'Read_Taks',
      CBM002_TSI.Write_Taks length = 8   
         label = 'Write_Taks',
      CBM002_TSI.WRITEESSAY_COMPASS length = 8   
         label = 'WRITEESSAY_COMPASS',
      CBM002_TSI.WRITEESSAY_ACCUPLACER length = 8   
         label = 'WRITEESSAY_ACCUPLACER',
      CBM002_TSI.WRITEESSAY_ASSET length = 8   
         label = 'WRITEESSAY_ASSET',
      CBM002_TSI.WRITEESSAY_STANFORD length = 8   
         label = 'WRITEESSAY_STANFORD',
      CBM002_TSI.WRITEESSAY_MAPS length = 8   
         label = 'WRITEESSAY_MAPS',
      CBM002_TSI.Flex length = 1   
         label = 'Flex',
      CBM002_TSI.Year length = 4   
         label = 'Year',
      CBM002_TSI.Math_TSI_TXCBMETHOD length = 8   
         label = 'Math_TSI_TXCBMETHOD',
      CBM002_TSI.Read_TSI_TXCBMETHOD length = 8   
         label = 'Read_TSI_TXCBMETHOD',
      CBM002_TSI.Write_TSI_TXCBMETHOD length = 8   
         label = 'Write_TSI_TXCBMETHOD',
      CBM002_TSI.Math_TSI_TSIA2METHOD length = 8   
         label = 'Math_TSI_TSIA2METHOD',
      CBM002_TSI.Read_TSI_TSIA2METHOD length = 8   
         label = 'Read_TSI_TSIA2METHOD',
      CBM002_TSI.Write_TSI_TSIA2METHOD length = 8   
         label = 'Write_TSI_TSIA2METHOD',
      CBM002_TSI.MATH_TSIA length = 8   
         label = 'MATH_TSIA',
      CBM002_TSI.READ_TSIA length = 8   
         label = 'READ_TSIA',
      CBM002_TSI.WRITE_TSIA length = 8   
         label = 'WRITE_TSIA',
      CBM002_TSI.MATH_TSIA2 length = 8   
         label = 'MATH_TSIA2',
      CBM002_TSI.READ_TSIA2 length = 8   
         label = 'READ_TSIA2',
      CBM002_TSI.WRITE_TSIA2 length = 8   
         label = 'WRITE_TSIA2',
      CBM002_TSI.WRITEESSAY_TSIA length = 8   
         label = 'WRITEESSAY_TSIA',
      CBM002_TSI.WRITEESSAY_TSIA2 length = 8   
         label = 'WRITEESSAY_TSIA2',
      CBM002_TSI.MATH_SAT_Old length = 8   
         label = 'MATH_SAT_Old',
      CBM002_TSI.VERBAL_SAT_Old length = 8   
         label = 'VERBAL_SAT_Old',
      CBM002_TSI.Total_SAT_Old length = 8   
         label = 'Total_SAT_Old',
      CBM002_TSI.MATH_TSIA2_Diagnostic length = 8   
         label = 'MATH_TSIA2_Diagnostic',
      CBM002_TSI.READ_TSIA2_Diagnostic length = 8   
         label = 'READ_TSIA2_Diagnostic',
      CBM002_TSI.WRITE_TSIA2_Diagnostic length = 8   
         label = 'WRITE_TSIA2_Diagnostic',
      CBM002_TSI.Math_ACT_Old length = 8   
         label = 'Math_ACT_Old',
      CBM002_TSI.Verbal_ACT_Old length = 8   
         label = 'Read_ACT_Old',
      CBM002_TSI.Total_ACT_Old length = 8   
         label = 'Total_ACT_Old'
   from
      work.CBM002_TSI as CBM002_TSI left join 
      (
         select distinct *
         from
            ADWSTGPR.PS_TRNS_TEST_DTL_Extract
         where
            PS_TRNS_TEST_DTL_Extract.ACAD_CAREER = 'UGRD'
            and PS_TRNS_TEST_DTL_Extract.TEST_ID in ('AP', 'CLEP', 'IB')
            and PS_TRNS_TEST_DTL_Extract.EARN_CREDIT = 'Y'
            and PS_TRNS_TEST_DTL_Extract.RQMNT_DESIGNTN in ('010' ,'020', '040', '060', '070', '080', '090', '2092', '1091', '092','098','4094','8098'  )
         group by
            PS_TRNS_TEST_DTL_Extract.EMPLID,
            PS_TRNS_TEST_DTL_Extract.TEST_ID,
            PS_TRNS_TEST_DTL_Extract.RQMNT_DESIGNTN
         having
            PS_TRNS_TEST_DTL_Extract.ARTICULATION_TERM = MIN(PS_TRNS_TEST_DTL_Extract.ARTICULATION_TERM)
      ) as Min_Articulation_Term
         on
         (
            CBM002_TSI.EMPLID = Min_Articulation_Term.EMPLID
            and CBM002_TSI.ACAD_CAREER = Min_Articulation_Term.ACAD_CAREER
         ) left join 
      ADWSTGPR.PS_TRNS_CRSE_DTL_Extract as PS_TRNS_CRSE_DTL_Extract
         on
         (
            CBM002_TSI.EMPLID = PS_TRNS_CRSE_DTL_Extract.EMPLID
            and CBM002_TSI.ACAD_CAREER = 'UGRD'
            and CBM002_TSI.INSTITUTION = 'UTARL'
            and PS_TRNS_CRSE_DTL_Extract.RQMNT_DESIGNTN in ('010' ,'020', '040', '060', '070', '080', '090')
            and PS_TRNS_CRSE_DTL_Extract.EARN_CREDIT = 'Y'
         )
   group by
      CBM002_TSI.EMPLID
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Transfer Course & Test Detail **/

/*==========================================================================* 
 * Step:            Report Logic-1                        A5B29B8Q.BZ000BTX * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_Transfer_Course -              A5B29B8Q.BS000477 * 
 *                   work.CBM002_Transfer_Course                            * 
 * Target Table:    CBM002_ReportLogic -                  A5B29B8Q.BS000478 * 
 *                   work.CBM002_ReportLogic                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTX);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_Transfer_Course, DATA)) or 
         %sysfunc(exist(work.CBM002_Transfer_Course, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_Transfer_Course out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.CBM002_Transfer_Course); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM002_ReportLogic;
quit;

data _null_;
   put "NOTE: The following column(s) do not have a column mapping, so the"
        " value(s) will be set to missing: MathTSIABEDiagnosticScore,"
        " ReadTSIABEDiagnosticScore,    WriteTSIABEDiagnosticScore";
run;

proc sql;
   create table work.CBM002_ReportLogic as
   select distinct
      '2' as RecordCode length = 1   
         label = 'RecordCode',
      '003656' as FiceCode length = 6   
         label = 'FiceCode',
      CBM002_Transfer_Course.National_Id length = 9   
         label = 'National_Id',
      case 
      when  SUBSTR(CBM002_Transfer_Course.Current_Term,4,1)='8' then '1'   
      when  SUBSTR(CBM002_Transfer_Course.Current_Term,4,1)='2' then '2'   
      when  SUBSTR(CBM002_Transfer_Course.Current_Term,4,1)='5' then '3'   
      else ' '   
      end as Semester length = 1   
         label = 'Semester',
      CBM002_Transfer_Course.Year length = 4   
         label = 'Year',
      CBM002_Transfer_Course.FERPA_FLAG as Ferpa length = 1   
         format = $1.
         informat = $1.
         label = 'Ferpa',
      CBM002_Transfer_Course.GENDER length = 1   
         format = $1.
         informat = $1.
         label = 'Gender',
      CBM002_Transfer_Course.BIRTHDATE length = 8   
         format = $8.
         informat = $8.
         label = 'BirthDate',
      CBM002_Transfer_Course.TSI_Oblig_Waived as TSIWaiverExemption length = 1   
         label = 'TSIWaiverExemption',
      CBM002_Transfer_Course.ETHNIC_ORIGIN length = 1   
         format = $1.
         informat = $1.
         label = 'Ethnic_Origin',
      CBM002_Transfer_Course.Race_White as White length = 1   
         format = $1.
         informat = $1.
         label = 'White',
      CBM002_Transfer_Course.Race_Black as Black length = 1   
         format = $1.
         informat = $1.
         label = 'Black',
      CBM002_Transfer_Course.Race_Asian as Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Asian',
      CBM002_Transfer_Course.Race_AmIndAlsknNatv as AmericanIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'AmericanIndAlsknNatv',
      CBM002_Transfer_Course.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      CBM002_Transfer_Course.Race_UnknwnNotRptd as UnknownNotReported length = 1   
         format = $1.
         informat = $1.
         label = 'UnknownNotReported',
      CBM002_Transfer_Course.Race_NatHawnOPI as NativeHawnOthPacificIslander length = 1   
         format = $1.
         informat = $1.
         label = 'NativeHawnOthPacificIslander',
      CBM002_Transfer_Course.Flex length = 1   
         label = 'Flex',
      IFC( 
      CBM002_Transfer_Course.TSI_Oblig_Waived in ('1', '2', '3') , '0', 
      	 IFC( CBM002_Transfer_Course.MATH_TSI_STATUS  = 1 , '2', 
      		IFC (CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP <> 'NONE' or CBM002_Transfer_Course.UTA_MATH_STATUS = 'Y' , '1', '0'))) as TSIMathExemptedByCensus length = 1   
         label = 'TSIMathExemptedByCensus',
      CBM002_Transfer_Course.MathTSIWaived as TSIMathWaiverExempted length = 1   
         label = 'TSIMathWaiverExempted',
      IFC( CBM002_Transfer_Course.MathTSIWaived = 'J', put(CBM002_Transfer_Course.Math_ACT , z3.), 
      	IFC(CBM002_Transfer_Course.MathTSIWaived = '2', put(CBM002_Transfer_Course.Math_ACT_Old , z3.), 
      		IFC(CBM002_Transfer_Course.MathTSIWaived = 'C', put(CBM002_Transfer_Course.MATH_SAT , z3.),
      			IFC(CBM002_Transfer_Course.MathTSIWaived = '3', put(CBM002_Transfer_Course.MATH_SAT_Old  , z3.), '000')))) as MathScore_ACT_SAT length = 3   
         label = 'MathScore_ACT_SAT',
      IFC( 
      CBM002_Transfer_Course.MathTSIWaived = '2', put(CBM002_Transfer_Course.Total_ACT_Old  , z4.), 	
      	IFC(CBM002_Transfer_Course.MathTSIWaived = '3', put(CBM002_Transfer_Course.Total_SAT_Old   , z4.), '0000')) as MathCompScore_ACT_SAT length = 4   
         label = 'MathCompScore_ACT_SAT',
      IFC(
      CBM002_Transfer_Course.MathTSIWaived = '4', put(CBM002_Transfer_Course.Math_Taks   , z4.), '0000') as MathScore_TAKS length = 4   
         label = 'MathScore_TAKS',
      IFC( 
      CBM002_Transfer_Course.MathTSIWaived <> '1', '0', 
             IFC(CBM002_Transfer_Course.Math_TSI_THEAMETHOD =1 or CBM002_Transfer_Course.Math_TSI_TASPMETHOD =1,'1', 
      	 IFC(CBM002_Transfer_Course.Math_TSI_COMPMETHOD  =1,'2', 
      	           IFC(CBM002_Transfer_Course.Math_TSI_ASSTMETHOD =1,'3', 
      		IFC(CBM002_Transfer_Course.Math_TSI_ACCUMETHOD   =1,'4', 
      		         IFC(CBM002_Transfer_Course.Math_TSI_STANMETHOD   =1,'5', 
      			IFC(CBM002_Transfer_Course.Math_TSI_MAPSMETHOD  =1,'6', 
      			         IFC(CBM002_Transfer_Course.Math_TSI_TSIA2METHOD =1, '9', 
      			                  IFC(CBM002_Transfer_Course.Math_TSI_TSIAMETHOD   =1,'8','7'))))))))) as TSIMathAtPlacement length = 1   
         label = 'TSIMathAtPlacement',
      IFC( 
      CBM002_Transfer_Course.Math_Transfer_Course =1, '2', 
                 IFC( CBM002_Transfer_Course.MathCoreCoursePriorEnrolled ='Y', '1', 
      	IFC( CBM002_Transfer_Course.Math_ArticulationTerm is not missing and CBM002_Transfer_Course.Math_ArticulationTerm < "&current_term", '1', 
      	          IFC(CBM002_Transfer_Course.Math_ArticulationTerm = "&current_term" , '3', 
      		IFC( CBM002_Transfer_Course.EAPStudent = 'Y' and CBM002_Transfer_Course.MathCoreCourseEnrolled = 'Y', '3', 
      			IFC( CBM002_Transfer_Course.EAPStudent = 'N' and CBM002_Transfer_Course.MathCoreCourseEnrolled = 'Y' , '4', '0')))))) as MathFirstLevelCollegeCourse length = 1   
         label = 'MathFirstLevelCollegeCourse',
      IFC( 
      CBM002_Transfer_Course.TSI_Oblig_Waived in ('1', '2', '3') , '0', 
      	 IFC( CBM002_Transfer_Course.READ_TSI_STATUS  = 1 , '2', 
      		IFC (CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP <> 'NONE' or CBM002_Transfer_Course.UTA_READ_STATUS = 'Y' , '1', '0'))) as TSIReadExemptedByCensus length = 1   
         label = 'TSIReadExemptedByCensus',
      IFC( 
      CBM002_Transfer_Course.TSI_Oblig_Waived in ('1', '2', '3') , '0', 
      	 IFC( CBM002_Transfer_Course.WRITE_TSI_STATUS  = 1 , '2', 
      		IFC (CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP <> 'NONE' or CBM002_Transfer_Course.UTA_WRITE_STATUS = 'Y' , '1', '0'))) as TSIWriteExemptedByCensus length = 1   
         label = 'TSIWriteExemptedByCensus',
      CBM002_Transfer_Course.ReadTSIWaived length = 1   
         label = 'ReadTSIWaived',
      IFC( CBM002_Transfer_Course.TSI_Oblig_Waived = '2', '6',   
                IFC(CBM002_Transfer_Course.TSI_Oblig_Waived in ('4','5' ,'6'), '0',   
                          IFC(CBM002_Transfer_Course.WRITE_TSI_PRIOR_REPORTED = 1,  '0',   
      	IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'ACT' 
      		and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT  and CBM002_Transfer_Course.Write_ACT > 0 , 'J', 
      	      IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'ACT'   and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT , '2',   
                                             IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'SAT' 
      				and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT and CBM002_Transfer_Course.VERBAL_SAT>0   , 'C',
                                                IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'SAT' 
      			and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT and  CBM002_Transfer_Course.VERBAL_SAT=0  and CBM002_Transfer_Course.VERBAL_SAT_Old >0 , '3',
      		 IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'TAKS' and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT , '4',   
      		          IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'UNDS' and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT , '7',   
      		                   IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'MAD' and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT , 'D',   
      	                                                    IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'MIL' and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT , 'E',   
      		                                     IFC(CBM002_Transfer_Course.UTA_TSI_OVERALL = 'C' and CBM002_Transfer_Course.UTA_TSI_EXMPT_TYP = 'AD' and CBM002_Transfer_Course.STATUS_DT <=CBM002_Transfer_Course.CENSUS_DT , 'F',  
      			                      IFC(CBM002_Transfer_Course.EAPStudent ='Y' and (CBM002_Transfer_Course.UTA_WRITE_STATUS ='Y' or CBM002_Transfer_Course.UTA_WRITE_STATUS ='Y'), 'G',  
      				       IFC( CBM002_Transfer_Course.Write_TSI_TXCBMETHOD =1, 'B', 
      				            IFC(CBM002_Transfer_Course.Write_TSI_ACTMETHOD=1 and CBM002_Transfer_Course.Write_ACT > 0 , 'J',
      				              IFC(CBM002_Transfer_Course.Write_TSI_ACTMETHOD=1 and CBM002_Transfer_Course.ReadTSIWaived in ('1','2') , '2',  
      			                                             IFC(CBM002_Transfer_Course.Write_TSI_SATMETHOD  =1 and CBM002_Transfer_Course.ReadTSIWaived in ('1','C') , 'C',  
      					       IFC(CBM002_Transfer_Course.Write_TSI_TAKSMETHOD = 1 and CBM002_Transfer_Course.ReadTSIWaived  in ('1','4') , '4',  
      					                 IFC(CBM002_Transfer_Course.Write_TSI_CORBMETHOD = 1 and CBM002_Transfer_Course.ReadTSIWaived in ('1','5') , '5', '1' ))))))))))))))))))) as WriteTSIWaived length = 1   
         label = 'WriteTSIWaived',
      IFC( CBM002_Transfer_Course.ReadTSIWaived = 'J', put(CBM002_Transfer_Course.Read_ACT , z3.), 
      	IFC(CBM002_Transfer_Course.ReadTSIWaived = '2', put(CBM002_Transfer_Course.Verbal_ACT_Old , z3.), 
      		IFC(CBM002_Transfer_Course.ReadTSIWaived = 'C', put(CBM002_Transfer_Course.VERBAL_SAT , z3.),
      			IFC(CBM002_Transfer_Course.ReadTSIWaived = '3', put(CBM002_Transfer_Course.VERBAL_SAT_Old  , z3.), '000')))) as ReadScore_ACT_SAT length = 3   
         label = 'ReadScore_ACT_SAT',
      IFC( 
      CBM002_Transfer_Course.ReadTSIWaived = '2', put(CBM002_Transfer_Course.Total_ACT_Old  , z4.), 
      	IFC(CBM002_Transfer_Course.ReadTSIWaived = '3', put(CBM002_Transfer_Course.Total_SAT_Old , z4.), '0000')) as ReadCompScore_ACT_SAT length = 4   
         label = 'ReadCompScore_ACT_SAT',
      IFC(
      CBM002_Transfer_Course.ReadTSIWaived = '4', put(CBM002_Transfer_Course.Read_Taks   , z4.), '0000') as ReadScore_TAKS length = 4   
         label = 'ReadScore_TAKS',
      IFC( 
      CBM002_Transfer_Course.ReadTSIWaived <> '1', '0', 
             IFC(CBM002_Transfer_Course.Read_TSI_THEAMETHOD =1 or CBM002_Transfer_Course.Read_TSI_TASPMETHOD =1,'1', 
      	 IFC(CBM002_Transfer_Course.Read_TSI_COMPMETHOD  =1,'2', 
      	           IFC(CBM002_Transfer_Course.Read_TSI_ASSTMETHOD =1,'3', 
      		IFC(CBM002_Transfer_Course.Read_TSI_ACCUMETHOD   =1,'4', 
      		         IFC(CBM002_Transfer_Course.Read_TSI_STANMETHOD   =1,'5', 
      			IFC(CBM002_Transfer_Course.Read_TSI_MAPSMETHOD  =1,'6', 
      			           IFC(CBM002_Transfer_Course.Read_TSI_TSIA2METHOD =1, '9',
      			                      IFC(CBM002_Transfer_Course.Read_TSI_TSIAMETHOD   =1,'8','7'))))))))) as TSIReadAtPlacement length = 1   
         label = 'TSIReadAtPlacement',
      IFC( 
      CBM002_Transfer_Course.Read_Transfer_Course =1, '2', 
                 IFC( CBM002_Transfer_Course.ReadCoreCoursePriorEnrolled ='Y', '1', 
      	IFC( CBM002_Transfer_Course.Read_ArticulationTerm is not missing and CBM002_Transfer_Course.Read_ArticulationTerm < "&current_term", '1', 
      	          IFC(CBM002_Transfer_Course.Read_ArticulationTerm = "&current_term" , '3', 
      		IFC( CBM002_Transfer_Course.EAPStudent = 'Y' and CBM002_Transfer_Course.ReadCoreCourseEnrolled = 'Y', '3', 
      			IFC( CBM002_Transfer_Course.EAPStudent = 'N' and CBM002_Transfer_Course.ReadCoreCourseEnrolled = 'Y', '4', '0')))))) as ReadFirstLevelCollegeCourse length = 1   
         label = 'ReadFirstLevelCollegeCourse',
      IFC( 
      CBM002_Transfer_Course.Write_Transfer_Course =1, '2', 
                 IFC( CBM002_Transfer_Course.WriteCoreCoursePriorEnrolled ='Y', '1', 
      	IFC( CBM002_Transfer_Course.Write_ArticulationTerm is not missing and CBM002_Transfer_Course.Write_ArticulationTerm < "&current_term", '1', 
      	          IFC(CBM002_Transfer_Course.Write_ArticulationTerm = "&current_term" , '3', 
      		IFC( CBM002_Transfer_Course.EAPStudent = 'Y' and CBM002_Transfer_Course.WriteCoreCourseEnrolled = 'Y', '3', 
      			IFC( CBM002_Transfer_Course.EAPStudent = 'N' and CBM002_Transfer_Course.WriteCoreCourseEnrolled = 'Y', '4', '0')))))) as WriteFirstLevelCollegeCourse length = 1   
         label = 'WriteFirstLevelCollegeCourse',
      "" as MathTSIABEDiagnosticScore length = 1   
         label = 'MathTSIABEDiagnosticScore',
      "" as ReadTSIABEDiagnosticScore length = 1   
         label = 'ReadTSIABEDiagnosticScore',
      "" as WriteTSIABEDiagnosticScore length = 1   
         label = 'WriteTSIABEDiagnosticScore',
      '0' as AlternateMathMethod length = 1   
         label = 'AlternateMathMethod',
      '0' as AlternateReadMethod length = 1   
         label = 'AlternateReadMethod',
      '0' as AlternateWriteMethod length = 1   
         label = 'AlternateWriteMethod',
      CBM002_Transfer_Course.MATH_THEA length = 8   
         label = 'MATH_THEA',
      CBM002_Transfer_Course.READ_THEA length = 8   
         label = 'READ_THEA',
      CBM002_Transfer_Course.WRITE_THEA length = 8   
         label = 'WRITE_THEA',
      CBM002_Transfer_Course.MATH_COMPASS length = 8   
         label = 'MATH_COMPASS',
      CBM002_Transfer_Course.READ_COMPASS length = 8   
         label = 'READ_COMPASS',
      CBM002_Transfer_Course.WRITE_COMPASS length = 8   
         label = 'WRITE_COMPASS',
      CBM002_Transfer_Course.MATH_ASSET length = 8   
         label = 'MATH_ASSET',
      CBM002_Transfer_Course.READ_ASSET length = 8   
         label = 'READ_ASSET',
      CBM002_Transfer_Course.WRITE_ASSET length = 8   
         label = 'WRITE_ASSET',
      CBM002_Transfer_Course.MATH_ACCUPLACER length = 8   
         label = 'MATH_ACCUPLACER',
      CBM002_Transfer_Course.READ_ACCUPLACER length = 8   
         label = 'READ_ACCUPLACER',
      CBM002_Transfer_Course.WRITE_ACCUPLACER length = 8   
         label = 'WRITE_ACCUPLACER',
      CBM002_Transfer_Course.MATH_STANFORD length = 8   
         label = 'MATH_STANFORD',
      CBM002_Transfer_Course.READ_STANFORD length = 8   
         label = 'READ_STANFORD',
      CBM002_Transfer_Course.WRITE_STANFORD length = 8   
         label = 'WRITE_STANFORD',
      CBM002_Transfer_Course.MATH_MAPS length = 8   
         label = 'MATH_MAPS',
      CBM002_Transfer_Course.READ_MAPS length = 8   
         label = 'READ_MAPS',
      CBM002_Transfer_Course.WRITE_MAPS length = 8   
         label = 'WRITE_MAPS',
      CBM002_Transfer_Course.MathTSIEndOfTerm length = 8   
         label = 'MathTSIEndOfTerm',
      CBM002_Transfer_Course.ReadTSIEndOfTerm length = 8   
         label = 'ReadTSIEndOfTerm',
      CBM002_Transfer_Course.WriteTSIEndOfTerm length = 8   
         label = 'WriteTSIEndOfTerm',
      CBM002_Transfer_Course.TSI_Oblig_Waived length = 1   
         label = 'TSI_Oblig_Waived',
      CBM002_Transfer_Course.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_Transfer_Course.Current_Term length = 8   
         format = $4.
         label = 'Current_Term',
      CBM002_Transfer_Course.WRITEESSAY_COMPASS length = 8   
         label = 'WRITEESSAY_COMPASS',
      CBM002_Transfer_Course.WRITEESSAY_ACCUPLACER length = 8   
         label = 'WRITEESSAY_ACCUPLACER',
      CBM002_Transfer_Course.WRITEESSAY_ASSET length = 8   
         label = 'WRITEESSAY_ASSET',
      CBM002_Transfer_Course.WRITEESSAY_STANFORD length = 8   
         label = 'WRITEESSAY_STANFORD',
      CBM002_Transfer_Course.WRITEESSAY_MAPS length = 8   
         label = 'WRITEESSAY_MAPS',
      CBM002_Transfer_Course.Write_TSI_ACCUMETHOD length = 8   
         label = 'Write_TSI_ACCUMETHOD',
      CBM002_Transfer_Course.Write_TSI_ACTMETHOD length = 8   
         label = 'Write_TSI_ACTMETHOD',
      CBM002_Transfer_Course.Write_TSI_ASSTMETHOD length = 8   
         label = 'Write_TSI_ASSTMETHOD',
      CBM002_Transfer_Course.Write_TSI_COMPMETHOD length = 8   
         label = 'Write_TSI_COMPMETHOD',
      CBM002_Transfer_Course.Write_TSI_CORBMETHOD length = 8   
         label = 'Write_TSI_CORBMETHOD',
      CBM002_Transfer_Course.Write_TSI_MAPSMETHOD length = 8   
         label = 'Write_TSI_MAPSMETHOD',
      CBM002_Transfer_Course.Write_TSI_SATMETHOD length = 8   
         label = 'Write_TSI_SATMETHOD',
      CBM002_Transfer_Course.Write_TSI_STANMETHOD length = 8   
         label = 'Write_TSI_STANMETHOD',
      CBM002_Transfer_Course.Write_TSI_TAKSMETHOD length = 8   
         label = 'Write_TSI_TAKSMETHOD',
      CBM002_Transfer_Course.Write_TSI_TASPMETHOD length = 8   
         label = 'Write_TSI_TASPMETHOD',
      CBM002_Transfer_Course.Write_TSI_THEAMETHOD length = 8   
         label = 'Write_TSI_THEAMETHOD',
      CBM002_Transfer_Course.Write_TSI_TSIAMETHOD length = 8   
         label = 'Write_TSI_TSIAMETHOD',
      CBM002_Transfer_Course.ACAD_PLAN length = 10   
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      CBM002_Transfer_Course.ADMIT_TERM length = 4   
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CBM002_Transfer_Course.ACAD_LEVEL_BOT length = 3   
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      CBM002_Transfer_Course.ACAD_PROG_PRIMARY length = 5   
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      CBM002_Transfer_Course.TOT_CUMULATIVE length = 8   
         format = 11.3
         informat = 11.3
         label = 'TOT_CUMULATIVE',
      CBM002_Transfer_Course.EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_Transfer_Course.Math_TSI_TXCBMETHOD length = 8   
         label = 'Math_TSI_TXCBMETHOD',
      CBM002_Transfer_Course.Read_TSI_TXCBMETHOD length = 8   
         label = 'Read_TSI_TXCBMETHOD',
      CBM002_Transfer_Course.Write_TSI_TXCBMETHOD length = 8   
         label = 'Write_TSI_TXCBMETHOD',
      CBM002_Transfer_Course.MATH_TSIA length = 8   
         label = 'MATH_TSIA',
      CBM002_Transfer_Course.READ_TSIA length = 8   
         label = 'READ_TSIA',
      CBM002_Transfer_Course.WRITE_TSIA length = 8   
         label = 'WRITE_TSIA',
      CBM002_Transfer_Course.MATH_TSIA2 length = 8   
         label = 'MATH_TSIA2',
      CBM002_Transfer_Course.READ_TSIA2 length = 8   
         label = 'READ_TSIA2',
      CBM002_Transfer_Course.WRITE_TSIA2 length = 8   
         label = 'WRITE_TSIA2',
      CBM002_Transfer_Course.WRITEESSAY_TSIA length = 8   
         label = 'WRITEESSAY_TSIA',
      CBM002_Transfer_Course.WRITEESSAY_TSIA2 length = 8   
         label = 'WRITEESSAY_TSIA2',
      CBM002_Transfer_Course.English_Composite_ACT length = 8   
         label = 'English_Composite_ACT',
      CBM002_Transfer_Course.Total_SAT length = 8   
         label = 'Total_SAT',
      CBM002_Transfer_Course.Read_ACT length = 8   
         label = 'Read_ACT',
      CBM002_Transfer_Course.Write_ACT length = 8   
         label = 'Write_ACT',
      CBM002_Transfer_Course.VERBAL_SAT length = 8   
         label = 'VERBAL_SAT',
      CBM002_Transfer_Course.Write_Taks length = 8   
         label = 'Write_Taks',
      CBM002_Transfer_Course.Write_TSI_TSIA2METHOD length = 8   
         label = 'Write_TSI_TSIA2METHOD',
      CBM002_Transfer_Course.MATH_SAT_Old length = 8   
         label = 'MATH_SAT_Old',
      CBM002_Transfer_Course.VERBAL_SAT_Old length = 8   
         label = 'VERBAL_SAT_Old',
      CBM002_Transfer_Course.Total_SAT_Old length = 8   
         label = 'Total_SAT_Old',
      CBM002_Transfer_Course.MATH_TSIA2_Diagnostic length = 8   
         label = 'MATH_TSIA2_Diagnostic',
      CBM002_Transfer_Course.READ_TSIA2_Diagnostic length = 8   
         label = 'READ_TSIA2_Diagnostic',
      CBM002_Transfer_Course.WRITE_TSIA2_Diagnostic length = 8   
         label = 'WRITE_TSIA2_Diagnostic',
      CBM002_Transfer_Course.Math_ACT_Old length = 8   
         label = 'Math_ACT_Old',
      CBM002_Transfer_Course.Verbal_ACT_Old length = 8   
         label = 'Read_ACT_Old',
      CBM002_Transfer_Course.Total_ACT_Old length = 8   
         label = 'Total_ACT_Old'
   from
      work.CBM002_Transfer_Course as CBM002_Transfer_Course
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Report Logic-1 **/

/*==========================================================================* 
 * Step:            Report Logic-2                        A5B29B8Q.BZ000BTY * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_ReportLogic -                  A5B29B8Q.BS000478 * 
 *                   work.CBM002_ReportLogic                                * 
 * Target Table:    CBM002_ReportingLogic2 -              A5B29B8Q.BS000479 * 
 *                   work.CBM002_ReportingLogic2                            * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTY);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_ReportLogic, DATA)) or 
         %sysfunc(exist(work.CBM002_ReportLogic, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_ReportLogic out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.CBM002_ReportLogic); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM002_ReportingLogic2;
quit;

data _null_;
   put "NOTE: The following column(s) do not have a column mapping, so the"
        " value(s) will be set to missing: MathTSIEndOfReportPeriod,"
        " ReadTSIEndOfReportPeriod,    WriteTSIEndOfReportPeriod";
run;

proc sql;
   create table work.CBM002_ReportingLogic2 as
   select
      CBM002_ReportLogic.RecordCode length = 1   
         label = 'RecordCode',
      trim(CBM002_ReportLogic.Current_Term) as ReportingTerm length = 4   
         format = $4.
         label = 'ReportingTerm',
      CBM002_ReportLogic.FiceCode length = 6   
         label = 'FiceCode',
      CBM002_ReportLogic.National_Id length = 9   
         label = 'National_Id',
      CBM002_ReportLogic.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_ReportLogic.Semester length = 1   
         label = 'Semester',
      CBM002_ReportLogic.Year length = 4   
         label = 'Year',
      CBM002_ReportLogic.Ferpa length = 1   
         format = $1.
         informat = $1.
         label = 'Ferpa',
      CBM002_ReportLogic.Gender length = 1   
         format = $1.
         informat = $1.
         label = 'Gender',
      CBM002_ReportLogic.BirthDate length = 8   
         format = $8.
         informat = $8.
         label = 'BirthDate',
      CBM002_ReportLogic.TSIWaiverExemption length = 1   
         label = 'TSIWaiverExemption',
      CBM002_ReportLogic.Ethnic_Origin length = 1   
         format = $1.
         informat = $1.
         label = 'Ethnic_Origin',
      CBM002_ReportLogic.White length = 1   
         format = $1.
         informat = $1.
         label = 'White',
      CBM002_ReportLogic.Black length = 1   
         format = $1.
         informat = $1.
         label = 'Black',
      CBM002_ReportLogic.Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Asian',
      CBM002_ReportLogic.AmericanIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'AmericanIndAlsknNatv',
      CBM002_ReportLogic.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      CBM002_ReportLogic.UnknownNotReported length = 1   
         format = $1.
         informat = $1.
         label = 'UnknownNotReported',
      CBM002_ReportLogic.NativeHawnOthPacificIslander length = 1   
         format = $1.
         informat = $1.
         label = 'NativeHawnOthPacificIslander',
      CBM002_ReportLogic.Flex length = 1   
         label = 'Flex',
      CBM002_ReportLogic.TSIMathExemptedByCensus length = 1   
         label = 'TSIMathExemptedByCensus',
      CBM002_ReportLogic.TSIMathWaiverExempted length = 1   
         label = 'TSIMathWaiverExempted',
      CBM002_ReportLogic.MathScore_ACT_SAT length = 3   
         label = 'MathScore_ACT_SAT',
      CBM002_ReportLogic.MathCompScore_ACT_SAT length = 4   
         label = 'MathCompScore_ACT_SAT',
      CBM002_ReportLogic.MathScore_TAKS length = 4   
         label = 'MathScore_TAKS',
      CBM002_ReportLogic.TSIMathAtPlacement length = 1   
         label = 'TSIMathAtPlacement',
      case  
      	when CBM002_ReportLogic.TSIMathAtPlacement = '0' then '000' 
      	when CBM002_ReportLogic.TSIMathAtPlacement = '1' then put(CBM002_ReportLogic.MATH_THEA, z3.) 
      	when CBM002_ReportLogic.TSIMathAtPlacement = '2' then put(CBM002_ReportLogic.MATH_COMPASS , z3.) 
      	when CBM002_ReportLogic.TSIMathAtPlacement = '3' then put(CBM002_ReportLogic.MATH_ASSET, z3.)  
      	when CBM002_ReportLogic.TSIMathAtPlacement = '4' then put(CBM002_ReportLogic.MATH_ACCUPLACER , z3.) 
      	when CBM002_ReportLogic.TSIMathAtPlacement = '5' then put(CBM002_ReportLogic.MATH_STANFORD , z3.) 
      	when CBM002_ReportLogic.TSIMathAtPlacement = '6' then put(CBM002_ReportLogic.MATH_MAPS , z3.) 
      	when CBM002_ReportLogic.TSIMathAtPlacement = '7' then '000' 
      	when CBM002_ReportLogic.TSIMathAtPlacement = '8' then put(CBM002_ReportLogic.MATH_TSIA , z3.) 
      	when CBM002_ReportLogic.TSIMathAtPlacement = '9' then put(CBM002_ReportLogic.MATH_TSIA2, z3.) 
      end as TSIMathAssesmentScore length = 3   
         label = 'TSIMathAssesmentScore',
      CBM002_ReportLogic.AlternateMathMethod length = 1   
         label = 'AlternateMathMethod',
      "" as MathTSIEndOfReportPeriod length = 1   
         label = 'MathTSIEndOfReportPeriod',
      CBM002_ReportLogic.MathFirstLevelCollegeCourse length = 1   
         label = 'MathFirstLevelCollegeCourse',
      CBM002_ReportLogic.TSIReadExemptedByCensus length = 1   
         label = 'TSIReadExemptedByCensus',
      CBM002_ReportLogic.ReadTSIWaived as TSIReadWaiverExempted length = 1   
         label = 'TSIReadWaiverExempted',
      CBM002_ReportLogic.ReadScore_ACT_SAT length = 3   
         label = 'ReadScore_ACT_SAT',
      CBM002_ReportLogic.ReadCompScore_ACT_SAT length = 4   
         label = 'ReadCompScore_ACT_SAT',
      CBM002_ReportLogic.ReadScore_TAKS length = 4   
         label = 'ReadScore_TAKS',
      CBM002_ReportLogic.TSIReadAtPlacement length = 1   
         label = 'TSIReadAtPlacement',
      case  
      	when CBM002_ReportLogic.TSIReadAtPlacement = '0' then '000' 
      	when CBM002_ReportLogic.TSIReadAtPlacement = '1' then put(CBM002_ReportLogic.READ_THEA, z3.) 
      	when CBM002_ReportLogic.TSIReadAtPlacement = '2' then put(CBM002_ReportLogic.READ_COMPASS , z3.) 
      	when CBM002_ReportLogic.TSIReadAtPlacement = '3' then put(CBM002_ReportLogic.READ_ASSET, z3.)  
      	when CBM002_ReportLogic.TSIReadAtPlacement = '4' then put(CBM002_ReportLogic.READ_ACCUPLACER , z3.) 
      	when CBM002_ReportLogic.TSIReadAtPlacement = '5' then put(CBM002_ReportLogic.READ_STANFORD , z3.) 
      	when CBM002_ReportLogic.TSIReadAtPlacement = '6' then put(CBM002_ReportLogic.READ_MAPS , z3.) 
      	when CBM002_ReportLogic.TSIReadAtPlacement = '7' then '000' 
      	when CBM002_ReportLogic.TSIReadAtPlacement = '8' then put(CBM002_ReportLogic.READ_TSIA , z3.) 
      	when CBM002_ReportLogic.TSIReadAtPlacement = '9' then put(CBM002_ReportLogic.READ_TSIA2, z3.) 
      end as TSIReadAssesmentScore length = 3   
         label = 'TSIReadAssesmentScore',
      CBM002_ReportLogic.AlternateReadMethod length = 1   
         label = 'AlternateReadMethod',
      "" as ReadTSIEndOfReportPeriod length = 1   
         label = 'ReadTSIEndOfReportPeriod',
      CBM002_ReportLogic.ReadFirstLevelCollegeCourse length = 1   
         label = 'ReadFirstLevelCollegeCourse',
      CBM002_ReportLogic.TSIWriteExemptedByCensus length = 1   
         label = 'TSIWriteExemptedByCensus',
      CBM002_ReportLogic.WriteTSIWaived as TSIWriteWaiverExempted length = 1   
         label = 'TSIWriteWaiverExempted',
      IFC(  CBM002_ReportLogic.WriteTSIWaived = 'J', put(CBM002_ReportLogic.Write_ACT , z3.),
      	IFC(CBM002_ReportLogic.WriteTSIWaived = '2', put(CBM002_ReportLogic.Verbal_ACT_Old , z3.),  
      		IFC(CBM002_ReportLogic.WriteTSIWaived = 'C', put(CBM002_ReportLogic.VERBAL_SAT , z3.),
      			IFC(CBM002_ReportLogic.WriteTSIWaived = '3', put(CBM002_ReportLogic.VERBAL_SAT_Old  , z3.), '000')))) as WriteScore_ACT_SAT length = 3   
         label = 'WriteScore_ACT_SAT',
      IFC(  
      CBM002_ReportLogic.WriteTSIWaived = '2', put(CBM002_ReportLogic.Total_ACT_Old  , z4.),  
      	IFC(CBM002_ReportLogic.WriteTSIWaived = '3', put( CBM002_ReportLogic.Total_SAT_Old,  z4.), '0000')) as WriteCompScore_ACT_SAT length = 4   
         label = 'WriteCompScore_ACT_SAT',
      IFC(CBM002_ReportLogic.WriteTSIWaived = '4', put(CBM002_ReportLogic.Write_Taks   , z4.), '0000') as WriteScore_TAKS length = 4   
         label = 'WriteScore_TAKS',
      IFC(  
      CBM002_ReportLogic.WriteTSIWaived <> '1', '0',  
             IFC(CBM002_ReportLogic.Write_TSI_THEAMETHOD =1 or CBM002_ReportLogic.Write_TSI_TASPMETHOD =1,'1',  
      	 IFC(CBM002_ReportLogic.Write_TSI_COMPMETHOD  =1,'2',  
      	           IFC(CBM002_ReportLogic.Write_TSI_ASSTMETHOD =1,'3',  
      		IFC(CBM002_ReportLogic.Write_TSI_ACCUMETHOD   =1,'4',  
      		         IFC(CBM002_ReportLogic.Write_TSI_STANMETHOD   =1,'5',  
      			IFC(CBM002_ReportLogic.Write_TSI_MAPSMETHOD  =1,'6',  
      			            IFC(CBM002_ReportLogic.Write_TSI_TSIA2METHOD = 1, '9', 
      			                         IFC(CBM002_ReportLogic.Write_TSI_TSIAMETHOD   =1,'8','7'))))))))) as TSIWriteAtPlacement length = 1   
         label = 'TSIWriteAtPlacement',
      CBM002_ReportLogic.AlternateWriteMethod length = 1   
         label = 'AlternateWriteMethod',
      "" as WriteTSIEndOfReportPeriod length = 1   
         label = 'WriteTSIEndOfReportPeriod',
      CBM002_ReportLogic.WriteFirstLevelCollegeCourse length = 1   
         label = 'WriteFirstLevelCollegeCourse',
      CBM002_ReportLogic.MathTSIABEDiagnosticScore length = 1   
         label = 'MathTSIABEDiagnosticScore',
      CBM002_ReportLogic.ReadTSIABEDiagnosticScore length = 1   
         label = 'ReadTSIABEDiagnosticScore',
      CBM002_ReportLogic.WriteTSIABEDiagnosticScore length = 1   
         label = 'WriteTSIABEDiagnosticScore',
      CBM002_ReportLogic.ACAD_PLAN as AcademicPlan length = 10   
         format = $10.
         informat = $10.
         label = 'AcademicPlan',
      CBM002_ReportLogic.ADMIT_TERM as AdmitTerm length = 4   
         format = $4.
         informat = $4.
         label = 'AdmitTerm',
      CBM002_ReportLogic.ACAD_LEVEL_BOT as AcademicLevelBOT length = 3   
         format = $3.
         informat = $3.
         label = 'AcademicLevelBOT',
      CBM002_ReportLogic.ACAD_PROG_PRIMARY as AcademicProgram length = 5   
         format = $5.
         informat = $5.
         label = 'AcademicProgram',
      CBM002_ReportLogic.TOT_CUMULATIVE as TotalCumulativeHours length = 8   
         format = 11.3
         informat = 11.3
         label = 'TotalCumulativeHours',
      CBM002_ReportLogic.EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_ReportLogic.Write_ACT length = 8   
         label = 'Write_ACT',
      CBM002_ReportLogic.WRITEESSAY_COMPASS length = 8   
         label = 'WRITEESSAY_COMPASS',
      CBM002_ReportLogic.WRITEESSAY_ACCUPLACER length = 8   
         label = 'WRITEESSAY_ACCUPLACER',
      CBM002_ReportLogic.WRITEESSAY_ASSET length = 8   
         label = 'WRITEESSAY_ASSET',
      CBM002_ReportLogic.WRITEESSAY_STANFORD length = 8   
         label = 'WRITEESSAY_STANFORD',
      CBM002_ReportLogic.WRITEESSAY_MAPS length = 8   
         label = 'WRITEESSAY_MAPS',
      CBM002_ReportLogic.WRITEESSAY_TSIA length = 8   
         label = 'WRITEESSAY_TSIA',
      CBM002_ReportLogic.WRITEESSAY_TSIA2 length = 8   
         label = 'WRITEESSAY_TSIA2',
      CBM002_ReportLogic.WRITE_ACCUPLACER length = 8   
         label = 'WRITE_ACCUPLACER',
      CBM002_ReportLogic.WRITE_ASSET length = 8   
         label = 'WRITE_ASSET',
      CBM002_ReportLogic.WRITE_COMPASS length = 8   
         label = 'WRITE_COMPASS',
      CBM002_ReportLogic.WRITE_MAPS length = 8   
         label = 'WRITE_MAPS',
      CBM002_ReportLogic.WRITE_STANFORD length = 8   
         label = 'WRITE_STANFORD',
      CBM002_ReportLogic.WRITE_THEA length = 8   
         label = 'WRITE_THEA',
      CBM002_ReportLogic.WRITE_TSIA length = 8   
         label = 'WRITE_TSIA',
      CBM002_ReportLogic.WRITE_TSIA2 length = 8   
         label = 'WRITE_TSIA2',
      CBM002_ReportLogic.MathTSIEndOfTerm length = 8   
         label = 'MathTSIEndOfTerm',
      CBM002_ReportLogic.ReadTSIEndOfTerm length = 8   
         label = 'ReadTSIEndOfTerm',
      CBM002_ReportLogic.WriteTSIEndOfTerm length = 8   
         label = 'WriteTSIEndOfTerm',
      CBM002_ReportLogic.MATH_TSIA2_Diagnostic length = 8   
         label = 'MATH_TSIA2_Diagnostic',
      CBM002_ReportLogic.READ_TSIA2_Diagnostic length = 8   
         label = 'READ_TSIA2_Diagnostic',
      CBM002_ReportLogic.WRITE_TSIA2_Diagnostic length = 8   
         label = 'WRITE_TSIA2_Diagnostic'
   from
      work.CBM002_ReportLogic as CBM002_ReportLogic
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Report Logic-2 **/

/*==========================================================================* 
 * Step:            CBM002 Final Data                     A5B29B8Q.BZ000BTZ * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_ReportingLogic2 -              A5B29B8Q.BS000479 * 
 *                   work.CBM002_ReportingLogic2                            * 
 * Target Table:    CBM002_Final - work.CBM002_Final      A5B29B8Q.BS00047A * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BTZ);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.CBM002_ReportingLogic2, DATA)) or 
         %sysfunc(exist(work.CBM002_ReportingLogic2, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.CBM002_ReportingLogic2 out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.CBM002_ReportingLogic2); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete CBM002_Final;
quit;

proc sql;
   create table work.CBM002_Final as
   select
      CBM002_ReportingLogic2.RecordCode length = 1   
         label = 'RecordCode',
      CBM002_ReportingLogic2.ReportingTerm length = 4   
         format = $4.
         label = 'ReportingTerm',
      CBM002_ReportingLogic2.FiceCode length = 6   
         label = 'FiceCode',
      CBM002_ReportingLogic2.National_Id length = 9   
         label = 'National_Id',
      CBM002_ReportingLogic2.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_ReportingLogic2.Semester length = 1   
         label = 'Semester',
      CBM002_ReportingLogic2.Year length = 4   
         label = 'Year',
      CBM002_ReportingLogic2.Ferpa length = 1   
         format = $1.
         informat = $1.
         label = 'Ferpa',
      CBM002_ReportingLogic2.Gender length = 1   
         format = $1.
         informat = $1.
         label = 'Gender',
      CBM002_ReportingLogic2.BirthDate length = 8   
         format = $8.
         informat = $8.
         label = 'BirthDate',
      CBM002_ReportingLogic2.TSIWaiverExemption length = 1   
         label = 'TSIWaiverExemption',
      CBM002_ReportingLogic2.Ethnic_Origin length = 1   
         format = $1.
         informat = $1.
         label = 'Ethnic_Origin',
      CBM002_ReportingLogic2.White length = 1   
         format = $1.
         informat = $1.
         label = 'White',
      CBM002_ReportingLogic2.Black length = 1   
         format = $1.
         informat = $1.
         label = 'Black',
      CBM002_ReportingLogic2.Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Asian',
      CBM002_ReportingLogic2.AmericanIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'AmericanIndAlsknNatv',
      CBM002_ReportingLogic2.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      CBM002_ReportingLogic2.UnknownNotReported length = 1   
         format = $1.
         informat = $1.
         label = 'UnknownNotReported',
      CBM002_ReportingLogic2.NativeHawnOthPacificIslander length = 1   
         format = $1.
         informat = $1.
         label = 'NativeHawnOthPacificIslander',
      CBM002_ReportingLogic2.Flex length = 1   
         label = 'Flex',
      CBM002_ReportingLogic2.TSIMathExemptedByCensus length = 1   
         label = 'TSIMathExemptedByCensus',
      CBM002_ReportingLogic2.TSIMathWaiverExempted length = 1   
         label = 'TSIMathWaiverExempted',
      CBM002_ReportingLogic2.MathScore_ACT_SAT length = 3   
         label = 'MathScore_ACT_SAT',
      CBM002_ReportingLogic2.MathCompScore_ACT_SAT length = 4   
         label = 'MathCompScore_ACT_SAT',
      CBM002_ReportingLogic2.MathScore_TAKS length = 4   
         label = 'MathScore_TAKS',
      CBM002_ReportingLogic2.TSIMathAtPlacement length = 1   
         label = 'TSIMathAtPlacement',
      CBM002_ReportingLogic2.TSIMathAssesmentScore length = 3   
         label = 'TSIMathAssesmentScore',
      CBM002_ReportingLogic2.AlternateMathMethod length = 1   
         label = 'AlternateMathMethod',
      CBM002_ReportingLogic2.MathTSIEndOfReportPeriod length = 1   
         label = 'MathTSIEndOfReportPeriod',
      CBM002_ReportingLogic2.MathFirstLevelCollegeCourse length = 1   
         label = 'MathFirstLevelCollegeCourse',
      CBM002_ReportingLogic2.TSIReadExemptedByCensus length = 1   
         label = 'TSIReadExemptedByCensus',
      CBM002_ReportingLogic2.TSIReadWaiverExempted length = 1   
         label = 'TSIReadWaiverExempted',
      CBM002_ReportingLogic2.ReadScore_ACT_SAT length = 3   
         label = 'ReadScore_ACT_SAT',
      CBM002_ReportingLogic2.ReadCompScore_ACT_SAT length = 4   
         label = 'ReadCompScore_ACT_SAT',
      CBM002_ReportingLogic2.ReadScore_TAKS length = 4   
         label = 'ReadScore_TAKS',
      CBM002_ReportingLogic2.TSIReadAtPlacement length = 1   
         label = 'TSIReadAtPlacement',
      CBM002_ReportingLogic2.TSIReadAssesmentScore length = 3   
         label = 'TSIReadAssesmentScore',
      CBM002_ReportingLogic2.AlternateReadMethod length = 1   
         label = 'AlternateReadMethod',
      CBM002_ReportingLogic2.ReadTSIEndOfReportPeriod length = 1   
         label = 'ReadTSIEndOfReportPeriod',
      CBM002_ReportingLogic2.ReadFirstLevelCollegeCourse length = 1   
         label = 'ReadFirstLevelCollegeCourse',
      CBM002_ReportingLogic2.TSIWriteExemptedByCensus length = 1   
         label = 'TSIWriteExemptedByCensus',
      CBM002_ReportingLogic2.TSIWriteWaiverExempted length = 1   
         label = 'TSIWriteWaiverExempted',
      CBM002_ReportingLogic2.WriteScore_ACT_SAT length = 3   
         label = 'WriteScore_ACT_SAT',
      CBM002_ReportingLogic2.WriteCompScore_ACT_SAT length = 4   
         label = 'WriteCompScore_ACT_SAT',
      CBM002_ReportingLogic2.WriteScore_TAKS length = 4   
         label = 'WriteScore_TAKS',
      CBM002_ReportingLogic2.TSIWriteAtPlacement length = 1   
         label = 'TSIWriteAtPlacement',
      case   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '0' then '000'  
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '1' then put(CBM002_ReportingLogic2.WRITE_THEA, z3.)  
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '2' then put(CBM002_ReportingLogic2.WRITE_COMPASS , z3.)  
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '3' then put(CBM002_ReportingLogic2.WRITE_ASSET, z3.)   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '4' then put(CBM002_ReportingLogic2.WRITE_ACCUPLACER , z3.)  
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '5' then put(CBM002_ReportingLogic2.WRITE_STANFORD , z3.)  
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '6' then put(CBM002_ReportingLogic2.WRITE_MAPS , z3.)  
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '7' then '000'  
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '8' then put(CBM002_ReportingLogic2.WRITE_TSIA  , z3.)  
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '9' then put(CBM002_ReportingLogic2.WRITE_TSIA2 , z3.)  
      end as TSIWriteAssesmentScore length = 3   
         label = 'TSIWriteAssesmentScore',
      case    
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement in ( '0', '1') then '0'   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '2' then put(CBM002_ReportingLogic2.WRITEESSAY_COMPASS , z1.)   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '3' then put(CBM002_ReportingLogic2.WRITEESSAY_ASSET, z1.)    
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '4' then put(CBM002_ReportingLogic2.WRITEESSAY_ACCUPLACER , z1.)   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '5' then put(CBM002_ReportingLogic2.WRITEESSAY_STANFORD , z1.)   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '6' then put(CBM002_ReportingLogic2.WRITEESSAY_MAPS , z1.)   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '7' then '0'   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '8' then put(CBM002_ReportingLogic2.WRITEESSAY_TSIA , z1.)   
      	when CBM002_ReportingLogic2.TSIWriteAtPlacement = '9' then put(CBM002_ReportingLogic2.WRITEESSAY_TSIA2  , z1.)   
      end as WriteEssayScore length = 1   
         label = 'WriteEssayScore',
      CBM002_ReportingLogic2.AlternateWriteMethod length = 1   
         label = 'AlternateWriteMethod',
      CBM002_ReportingLogic2.WriteTSIEndOfReportPeriod length = 1   
         label = 'WriteTSIEndOfReportPeriod',
      CBM002_ReportingLogic2.WriteFirstLevelCollegeCourse length = 1   
         label = 'WriteFirstLevelCollegeCourse',
      case 
      when CBM002_ReportingLogic2.TSIMathAtPlacement = '7' then '0'
      when CBM002_ReportingLogic2.MATH_TSIA2_Diagnostic  =1 then '1'
      when CBM002_ReportingLogic2.MATH_TSIA2_Diagnostic  =2 then '2'
      when CBM002_ReportingLogic2.MATH_TSIA2_Diagnostic  =3 then '3'
      when CBM002_ReportingLogic2.MATH_TSIA2_Diagnostic  =4 then '4'
      when CBM002_ReportingLogic2.MATH_TSIA2_Diagnostic  =5 then '5'
      when CBM002_ReportingLogic2.MATH_TSIA2_Diagnostic  =6 then '6'
      else  '0'
      end as MathTSIABEDiagnosticScore length = 1   
         label = 'MathTSIABEDiagnosticScore',
      case 
      when CBM002_ReportingLogic2.TSIReadAtPlacement = '7' then '0'
      when CBM002_ReportingLogic2.READ_TSIA2_Diagnostic  =1 then '1'
      when CBM002_ReportingLogic2.READ_TSIA2_Diagnostic  =2 then '2'
      when CBM002_ReportingLogic2.READ_TSIA2_Diagnostic  =3 then '3'
      when CBM002_ReportingLogic2.READ_TSIA2_Diagnostic  =4 then '4'
      when CBM002_ReportingLogic2.READ_TSIA2_Diagnostic  =5 then '5'
      when CBM002_ReportingLogic2.READ_TSIA2_Diagnostic  =6 then '6'
      else  '0'
      end as ReadTSIABEDiagnosticScore length = 1   
         label = 'ReadTSIABEDiagnosticScore',
      case 
      when CBM002_ReportingLogic2.TSIWriteAtPlacement = '7' then '0'
      when CBM002_ReportingLogic2.WRITE_TSIA2_Diagnostic  =1 then '1'
      when CBM002_ReportingLogic2.WRITE_TSIA2_Diagnostic  =2 then '2'
      when CBM002_ReportingLogic2.WRITE_TSIA2_Diagnostic  =3 then '3'
      when CBM002_ReportingLogic2.WRITE_TSIA2_Diagnostic  =4 then '4'
      when CBM002_ReportingLogic2.WRITE_TSIA2_Diagnostic  =5 then '5'
      when CBM002_ReportingLogic2.WRITE_TSIA2_Diagnostic  =6 then '6'
      else  '0'
      end as WriteTSIABEDiagnosticScore length = 1   
         label = 'WriteTSIABEDiagnosticScore',
      CBM002_ReportingLogic2.AcademicPlan length = 10   
         format = $10.
         informat = $10.
         label = 'AcademicPlan',
      CBM002_ReportingLogic2.AdmitTerm length = 4   
         format = $4.
         informat = $4.
         label = 'AdmitTerm',
      CBM002_ReportingLogic2.AcademicLevelBOT length = 3   
         format = $3.
         informat = $3.
         label = 'AcademicLevelBOT',
      CBM002_ReportingLogic2.AcademicProgram length = 5   
         format = $5.
         informat = $5.
         label = 'AcademicProgram',
      CBM002_ReportingLogic2.TotalCumulativeHours length = 8   
         format = 11.3
         informat = 11.3
         label = 'TotalCumulativeHours',
      CBM002_ReportingLogic2.EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_ReportingLogic2.MathTSIEndOfTerm length = 8   
         label = 'MathTSIEndOfTerm',
      CBM002_ReportingLogic2.ReadTSIEndOfTerm length = 8   
         label = 'ReadTSIEndOfTerm',
      CBM002_ReportingLogic2.WriteTSIEndOfTerm length = 8   
         label = 'WriteTSIEndOfTerm'
   from
      work.CBM002_ReportingLogic2 as CBM002_ReportingLogic2
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end CBM002 Final Data **/

/*==========================================================================* 
 * Step:            Conditional Start                     A5B29B8Q.BZ000BU0 * 
 * Transform:       Conditional Start                                       * 
 * Description:                                                             * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BU0);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%macro etls_conditionW1BNSK0T9;
   %local etls_conditionTrue;
   %let etls_conditionTrue = %eval(&snapshot_type = 'Census');
   %if (&etls_conditionTrue=0) %then
   %do;
      %put ETLS_DIAG: Condition flow did NOT execute, condition was &snapshot_type = 'Census';
      %goto exitetls_conditionW1BNSK0T9;
   %end;
   %else
   %do;
      %put ETLS_DIAG: Condition flow did execute, condition was &snapshot_type = 'Census';
   %end;
/*==========================================================================* 
 * Step:            Delete                                A5B29B8Q.BZ000BU1 * 
 * Transform:       Delete                                                  * 
 * Description:                                                             * 
 *                                                                          * 
 * Target Table:    ADW_CBM002_CENSUS -                   A5B29B8Q.BE000171 * 
 *                   CBMPRD.ADW_CBM002_CENSUS                               * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BU1);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SqlDelete), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

%macro etls_sql_delete;

   /* Determine if the table exists  */ 
   %let etls_tableExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM002_CENSUS, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM002_CENSUS, VIEW))); 
   
   /*---- Create a new table  ----*/ 
   %if (&etls_tableExist eq 0) %then 
   %do;  /* if table does not exist  */ 
   
      %put %str(NOTE: Creating table ...);
      
      data CBMPRD.ADW_CBM002_CENSUS
              (dbnull = (
                         RecordCode = YES
                         ReportingTerm = YES
                         FiceCode = YES
                         National_Id = YES
                         EMPLID = NO
                         Semester = YES
                         Year = YES
                         Ferpa = YES
                         Gender = YES
                         BirthDate = YES
                         TSIWaiverExemption = YES
                         Ethnic_Origin = YES
                         White = YES
                         Black = YES
                         Asian = YES
                         AmericanIndAlsknNatv = YES
                         International = YES
                         UnknownNotReported = YES
                         NativeHawnOthPacificIslander = YES
                         Flex = YES
                         TSIMathExemptedByCensus = YES
                         TSIMathWaiverExempted = YES
                         MathScore_ACT_SAT = YES
                         MathCompScore_ACT_SAT = YES
                         MathScore_TAKS = YES
                         TSIMathAtPlacement = YES
                         TSIMathAssesmentScore = YES
                         AlternateMathMethod = YES
                         MathTSIEndOfReportPeriod = YES
                         MathFirstLevelCollegeCourse = YES
                         TSIReadExemptedByCensus = YES
                         TSIReadWaiverExempted = YES
                         ReadScore_ACT_SAT = YES
                         ReadCompScore_ACT_SAT = YES
                         ReadScore_TAKS = YES
                         TSIReadAtPlacement = YES
                         TSIReadAssesmentScore = YES
                         AlternateReadMethod = YES
                         ReadTSIEndOfReportPeriod = YES
                         ReadFirstLevelCollegeCourse = YES
                         TSIWriteExemptedByCensus = YES
                         TSIWriteWaiverExempted = YES
                         WriteScore_ACT_SAT = YES
                         WriteCompScore_ACT_SAT = YES
                         WriteScore_TAKS = YES
                         TSIWriteAtPlacement = YES
                         TSIWriteAssesmentScore = YES
                         WriteEssayScore = YES
                         AlternateWriteMethod = YES
                         WriteTSIEndOfReportPeriod = YES
                         WriteFirstLevelCollegeCourse = YES
                         MathTSIABEDiagnosticScore = YES
                         ReadTSIABEDiagnosticScore = YES
                         WriteTSIABEDiagnosticScore = YES
                         AcademicPlan = YES
                         AdmitTerm = YES
                         AcademicLevelBOT = YES
                         AcademicProgram = YES
                         TotalCumulativeHours = YES
                         EAPStudent = YES
                         Read_DTM = YES
                         Stage_Update_ID = YES));
         attrib RecordCode length = $1
            label = 'RecordCode'; 
         attrib ReportingTerm length = $4
            format = $4.
            label = 'ReportingTerm'; 
         attrib FiceCode length = $6
            label = 'FiceCode'; 
         attrib National_Id length = $9
            label = 'National_Id'; 
         attrib EMPLID length = $11
            format = $11.
            informat = $11.
            label = 'EMPLID'; 
         attrib Semester length = $1
            label = 'Semester'; 
         attrib Year length = $4
            label = 'Year'; 
         attrib Ferpa length = $1
            format = $1.
            informat = $1.
            label = 'Ferpa'; 
         attrib Gender length = $1
            format = $1.
            informat = $1.
            label = 'Gender'; 
         attrib BirthDate length = $8
            format = $8.
            informat = $8.
            label = 'BirthDate'; 
         attrib TSIWaiverExemption length = $1
            label = 'TSIWaiverExemption'; 
         attrib Ethnic_Origin length = $1
            format = $1.
            informat = $1.
            label = 'Ethnic_Origin'; 
         attrib White length = $1
            format = $1.
            informat = $1.
            label = 'White'; 
         attrib Black length = $1
            format = $1.
            informat = $1.
            label = 'Black'; 
         attrib Asian length = $1
            format = $1.
            informat = $1.
            label = 'Asian'; 
         attrib AmericanIndAlsknNatv length = $1
            format = $1.
            informat = $1.
            label = 'AmericanIndAlsknNatv'; 
         attrib International length = $1
            format = $1.
            informat = $1.
            label = 'International'; 
         attrib UnknownNotReported length = $1
            format = $1.
            informat = $1.
            label = 'UnknownNotReported'; 
         attrib NativeHawnOthPacificIslander length = $1
            format = $1.
            informat = $1.
            label = 'NativeHawnOthPacificIslander'; 
         attrib Flex length = $1
            label = 'Flex'; 
         attrib TSIMathExemptedByCensus length = $1
            label = 'TSIMathExemptedByCensus'; 
         attrib TSIMathWaiverExempted length = $1
            label = 'TSIMathWaiverExempted'; 
         attrib MathScore_ACT_SAT length = $3
            label = 'MathScore_ACT_SAT'; 
         attrib MathCompScore_ACT_SAT length = $4
            label = 'MathCompScore_ACT_SAT'; 
         attrib MathScore_TAKS length = $4
            label = 'MathScore_TAKS'; 
         attrib TSIMathAtPlacement length = $1
            label = 'TSIMathAtPlacement'; 
         attrib TSIMathAssesmentScore length = $3
            label = 'TSIMathAssesmentScore'; 
         attrib AlternateMathMethod length = $1
            label = 'AlternateMathMethod'; 
         attrib MathTSIEndOfReportPeriod length = $1
            label = 'MathTSIEndOfReportPeriod'; 
         attrib MathFirstLevelCollegeCourse length = $1
            label = 'MathFirstLevelCollegeCourse'; 
         attrib TSIReadExemptedByCensus length = $1
            label = 'TSIReadExemptedByCensus'; 
         attrib TSIReadWaiverExempted length = $1
            label = 'TSIReadWaiverExempted'; 
         attrib ReadScore_ACT_SAT length = $3
            label = 'ReadScore_ACT_SAT'; 
         attrib ReadCompScore_ACT_SAT length = $4
            label = 'ReadCompScore_ACT_SAT'; 
         attrib ReadScore_TAKS length = $4
            label = 'ReadScore_TAKS'; 
         attrib TSIReadAtPlacement length = $1
            label = 'TSIReadAtPlacement'; 
         attrib TSIReadAssesmentScore length = $3
            label = 'TSIReadAssesmentScore'; 
         attrib AlternateReadMethod length = $1
            label = 'AlternateReadMethod'; 
         attrib ReadTSIEndOfReportPeriod length = $1
            label = 'ReadTSIEndOfReportPeriod'; 
         attrib ReadFirstLevelCollegeCourse length = $1
            label = 'ReadFirstLevelCollegeCourse'; 
         attrib TSIWriteExemptedByCensus length = $1
            label = 'TSIWriteExemptedByCensus'; 
         attrib TSIWriteWaiverExempted length = $1
            label = 'TSIWriteWaiverExempted'; 
         attrib WriteScore_ACT_SAT length = $3
            label = 'WriteScore_ACT_SAT'; 
         attrib WriteCompScore_ACT_SAT length = $4
            label = 'WriteCompScore_ACT_SAT'; 
         attrib WriteScore_TAKS length = $4
            label = 'WriteScore_TAKS'; 
         attrib TSIWriteAtPlacement length = $1
            label = 'TSIWriteAtPlacement'; 
         attrib TSIWriteAssesmentScore length = $3
            label = 'TSIWriteAssesmentScore'; 
         attrib WriteEssayScore length = $1
            label = 'WriteEssayScore'; 
         attrib AlternateWriteMethod length = $1
            label = 'AlternateWriteMethod'; 
         attrib WriteTSIEndOfReportPeriod length = $1
            label = 'WriteTSIEndOfReportPeriod'; 
         attrib WriteFirstLevelCollegeCourse length = $1
            label = 'WriteFirstLevelCollegeCourse'; 
         attrib MathTSIABEDiagnosticScore length = $1
            label = 'MathTSIABEDiagnosticScore'; 
         attrib ReadTSIABEDiagnosticScore length = $1
            label = 'ReadTSIABEDiagnosticScore'; 
         attrib WriteTSIABEDiagnosticScore length = $1
            label = 'WriteTSIABEDiagnosticScore'; 
         attrib AcademicPlan length = $10
            format = $10.
            informat = $10.
            label = 'AcademicPlan'; 
         attrib AdmitTerm length = $4
            format = $4.
            informat = $4.
            label = 'AdmitTerm'; 
         attrib AcademicLevelBOT length = $3
            format = $3.
            informat = $3.
            label = 'AcademicLevelBOT'; 
         attrib AcademicProgram length = $5
            format = $5.
            informat = $5.
            label = 'AcademicProgram'; 
         attrib TotalCumulativeHours length = 8
            format = 11.3
            informat = 11.3
            label = 'TotalCumulativeHours'; 
         attrib EAPStudent length = $1
            label = 'EAPStudent'; 
         attrib Read_DTM length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'Read_DTM'; 
         attrib Stage_Update_ID length = $20
            format = $20.
            label = 'Stage_Update_ID'; 
         call missing(of _all_);
         stop;
      run;
      
      %rcSet(&syserr); 
      
   %end;  /* if table does not exist  */ 
   
   /*---- Delete the target table  ----*/ 
   proc sql;
      connect to ORACLE
      ( 
          DEFER=YES DBSERVER_MAX_BYTES=1 DBCLIENT_MAX_BYTES=1 ADJUST_BYTE_SEMANTIC_COLUMN_LENGTHS=YES DB_LENGTH_SEMANTICS_BYTE=YES DBSERVER_ENCODING_FIXED=YES DBCLIENT_ENCODING_FIXED=YES PATH=UTAAWSPD AUTHDOMAIN="CBMPRD" 
      ); 
      execute 
      ( 
         delete from CBMPRD.ADW_CBM002_CENSUS
         where
            ADW_CBM002_CENSUS.ReportingTerm = &current_term.
      ) by ORACLE; 
      
      %rcSet(&sqlrc); 
      
      disconnect from ORACLE; 
   quit;
   
   %rcSet(&syscc); 
   
%mend etls_sql_delete;

/* execute etls_sql_delete  */ 
%etls_sql_delete

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Delete **/

/*==========================================================================* 
 * Step:            Table Loader                          A5B29B8Q.BZ000BU2 * 
 * Transform:       Table Loader (Version 2.1)                              * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_Final - work.CBM002_Final      A5B29B8Q.BS00047A * 
 * Target Table:    ADW_CBM002_CENSUS -                   A5B29B8Q.BE000171 * 
 *                   CBMPRD.ADW_CBM002_CENSUS                               * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BU2);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let SYSLAST = %nrquote(work.CBM002_Final); 

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
   Load Technique Selection: AppendToExisting - AppendProc
   Constraint and index action selections: 'ASIS','ASIS','ASIS','ASIS'
   Additional options selections... 
      Set unmapped to missing on updates: false 
   -------------------------------------------------------------- */
%macro etls_loader;

   %let etls_tableOptions = ;
   
   /*---- Set the Load Time column  ----*/ 
   %let etls_jobLoadTime = &SYSDATE9.:&SYSTIME;
   %let etls_loadTime = &etls_jobLoadTime; 
   data _null_;
      _loadtime = input("&etls_LoadTime",DATETIME20.);
      put "NOTE: The load time is: " _loadtime nldatm.;
   run;
   
   proc datasets lib = work nolist nowarn memtype = (data view);
      delete WTK9WBA;
   quit;
   
   data work.WTK9WBA / view=work.WTK9WBA;
      set &SYSLAST (&etls_tableOptions);
      Read_DTM = "&etls_LoadTime"dt;
   run;
   
   %rcSet(&syserr); 
   
   %let SYSLAST = work.WTK9WBA;
   %let etls_lastTable = &SYSLAST; 
   
   /*---- Map the columns  ----*/ 
   proc datasets lib = work nolist nowarn memtype = (data view);
      delete WTK9WBB;
   quit;
   
   %put %str(NOTE: Mapping columns ...);
   proc sql;
      create view work.WTK9WBB as
         select
            RecordCode,
            ReportingTerm,
            FiceCode,
            National_Id,
            EMPLID,
            Semester,
            Year,
            Ferpa,
            Gender,
            BirthDate,
            TSIWaiverExemption,
            Ethnic_Origin,
            White,
            Black,
            Asian,
            AmericanIndAlsknNatv,
            International,
            UnknownNotReported,
            NativeHawnOthPacificIslander,
            Flex,
            TSIMathExemptedByCensus,
            TSIMathWaiverExempted,
            MathScore_ACT_SAT,
            MathCompScore_ACT_SAT,
            MathScore_TAKS,
            TSIMathAtPlacement,
            TSIMathAssesmentScore,
            AlternateMathMethod,
            MathTSIEndOfReportPeriod,
            MathFirstLevelCollegeCourse,
            TSIReadExemptedByCensus,
            TSIReadWaiverExempted,
            ReadScore_ACT_SAT,
            ReadCompScore_ACT_SAT,
            ReadScore_TAKS,
            TSIReadAtPlacement,
            TSIReadAssesmentScore,
            AlternateReadMethod,
            ReadTSIEndOfReportPeriod,
            ReadFirstLevelCollegeCourse,
            TSIWriteExemptedByCensus,
            TSIWriteWaiverExempted,
            WriteScore_ACT_SAT,
            WriteCompScore_ACT_SAT,
            WriteScore_TAKS,
            TSIWriteAtPlacement,
            TSIWriteAssesmentScore,
            WriteEssayScore,
            AlternateWriteMethod,
            WriteTSIEndOfReportPeriod,
            WriteFirstLevelCollegeCourse,
            MathTSIABEDiagnosticScore,
            ReadTSIABEDiagnosticScore,
            WriteTSIABEDiagnosticScore,
            AcademicPlan,
            AdmitTerm,
            AcademicLevelBOT,
            AcademicProgram,
            TotalCumulativeHours,
            EAPStudent,
            Read_DTM,
            ("&SYSUSERID") as Stage_Update_ID length = 20
               format = $20.
      from &etls_lastTable
      ;
   quit;
   
   %let SYSLAST = work.WTK9WBB;
   
   %let etls_lastTable = &SYSLAST; 
   %let etls_tableOptions = ; 
   
   /* Determine if the target table exists  */ 
   %let etls_tableExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM002_CENSUS, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM002_CENSUS, VIEW))); 
   
   /*---- Create a new table  ----*/ 
   %if (&etls_tableExist eq 0) %then 
   %do;  /* if table does not exist  */ 
   
      %put %str(NOTE: Creating table ...);
      
      data CBMPRD.ADW_CBM002_CENSUS
              (dbnull = (
                         RecordCode = YES
                         ReportingTerm = YES
                         FiceCode = YES
                         National_Id = YES
                         EMPLID = NO
                         Semester = YES
                         Year = YES
                         Ferpa = YES
                         Gender = YES
                         BirthDate = YES
                         TSIWaiverExemption = YES
                         Ethnic_Origin = YES
                         White = YES
                         Black = YES
                         Asian = YES
                         AmericanIndAlsknNatv = YES
                         International = YES
                         UnknownNotReported = YES
                         NativeHawnOthPacificIslander = YES
                         Flex = YES
                         TSIMathExemptedByCensus = YES
                         TSIMathWaiverExempted = YES
                         MathScore_ACT_SAT = YES
                         MathCompScore_ACT_SAT = YES
                         MathScore_TAKS = YES
                         TSIMathAtPlacement = YES
                         TSIMathAssesmentScore = YES
                         AlternateMathMethod = YES
                         MathTSIEndOfReportPeriod = YES
                         MathFirstLevelCollegeCourse = YES
                         TSIReadExemptedByCensus = YES
                         TSIReadWaiverExempted = YES
                         ReadScore_ACT_SAT = YES
                         ReadCompScore_ACT_SAT = YES
                         ReadScore_TAKS = YES
                         TSIReadAtPlacement = YES
                         TSIReadAssesmentScore = YES
                         AlternateReadMethod = YES
                         ReadTSIEndOfReportPeriod = YES
                         ReadFirstLevelCollegeCourse = YES
                         TSIWriteExemptedByCensus = YES
                         TSIWriteWaiverExempted = YES
                         WriteScore_ACT_SAT = YES
                         WriteCompScore_ACT_SAT = YES
                         WriteScore_TAKS = YES
                         TSIWriteAtPlacement = YES
                         TSIWriteAssesmentScore = YES
                         WriteEssayScore = YES
                         AlternateWriteMethod = YES
                         WriteTSIEndOfReportPeriod = YES
                         WriteFirstLevelCollegeCourse = YES
                         MathTSIABEDiagnosticScore = YES
                         ReadTSIABEDiagnosticScore = YES
                         WriteTSIABEDiagnosticScore = YES
                         AcademicPlan = YES
                         AdmitTerm = YES
                         AcademicLevelBOT = YES
                         AcademicProgram = YES
                         TotalCumulativeHours = YES
                         EAPStudent = YES
                         Read_DTM = YES
                         Stage_Update_ID = YES));
         attrib RecordCode length = $1
            label = 'RecordCode'; 
         attrib ReportingTerm length = $4
            format = $4.
            label = 'ReportingTerm'; 
         attrib FiceCode length = $6
            label = 'FiceCode'; 
         attrib National_Id length = $9
            label = 'National_Id'; 
         attrib EMPLID length = $11
            format = $11.
            informat = $11.
            label = 'EMPLID'; 
         attrib Semester length = $1
            label = 'Semester'; 
         attrib Year length = $4
            label = 'Year'; 
         attrib Ferpa length = $1
            format = $1.
            informat = $1.
            label = 'Ferpa'; 
         attrib Gender length = $1
            format = $1.
            informat = $1.
            label = 'Gender'; 
         attrib BirthDate length = $8
            format = $8.
            informat = $8.
            label = 'BirthDate'; 
         attrib TSIWaiverExemption length = $1
            label = 'TSIWaiverExemption'; 
         attrib Ethnic_Origin length = $1
            format = $1.
            informat = $1.
            label = 'Ethnic_Origin'; 
         attrib White length = $1
            format = $1.
            informat = $1.
            label = 'White'; 
         attrib Black length = $1
            format = $1.
            informat = $1.
            label = 'Black'; 
         attrib Asian length = $1
            format = $1.
            informat = $1.
            label = 'Asian'; 
         attrib AmericanIndAlsknNatv length = $1
            format = $1.
            informat = $1.
            label = 'AmericanIndAlsknNatv'; 
         attrib International length = $1
            format = $1.
            informat = $1.
            label = 'International'; 
         attrib UnknownNotReported length = $1
            format = $1.
            informat = $1.
            label = 'UnknownNotReported'; 
         attrib NativeHawnOthPacificIslander length = $1
            format = $1.
            informat = $1.
            label = 'NativeHawnOthPacificIslander'; 
         attrib Flex length = $1
            label = 'Flex'; 
         attrib TSIMathExemptedByCensus length = $1
            label = 'TSIMathExemptedByCensus'; 
         attrib TSIMathWaiverExempted length = $1
            label = 'TSIMathWaiverExempted'; 
         attrib MathScore_ACT_SAT length = $3
            label = 'MathScore_ACT_SAT'; 
         attrib MathCompScore_ACT_SAT length = $4
            label = 'MathCompScore_ACT_SAT'; 
         attrib MathScore_TAKS length = $4
            label = 'MathScore_TAKS'; 
         attrib TSIMathAtPlacement length = $1
            label = 'TSIMathAtPlacement'; 
         attrib TSIMathAssesmentScore length = $3
            label = 'TSIMathAssesmentScore'; 
         attrib AlternateMathMethod length = $1
            label = 'AlternateMathMethod'; 
         attrib MathTSIEndOfReportPeriod length = $1
            label = 'MathTSIEndOfReportPeriod'; 
         attrib MathFirstLevelCollegeCourse length = $1
            label = 'MathFirstLevelCollegeCourse'; 
         attrib TSIReadExemptedByCensus length = $1
            label = 'TSIReadExemptedByCensus'; 
         attrib TSIReadWaiverExempted length = $1
            label = 'TSIReadWaiverExempted'; 
         attrib ReadScore_ACT_SAT length = $3
            label = 'ReadScore_ACT_SAT'; 
         attrib ReadCompScore_ACT_SAT length = $4
            label = 'ReadCompScore_ACT_SAT'; 
         attrib ReadScore_TAKS length = $4
            label = 'ReadScore_TAKS'; 
         attrib TSIReadAtPlacement length = $1
            label = 'TSIReadAtPlacement'; 
         attrib TSIReadAssesmentScore length = $3
            label = 'TSIReadAssesmentScore'; 
         attrib AlternateReadMethod length = $1
            label = 'AlternateReadMethod'; 
         attrib ReadTSIEndOfReportPeriod length = $1
            label = 'ReadTSIEndOfReportPeriod'; 
         attrib ReadFirstLevelCollegeCourse length = $1
            label = 'ReadFirstLevelCollegeCourse'; 
         attrib TSIWriteExemptedByCensus length = $1
            label = 'TSIWriteExemptedByCensus'; 
         attrib TSIWriteWaiverExempted length = $1
            label = 'TSIWriteWaiverExempted'; 
         attrib WriteScore_ACT_SAT length = $3
            label = 'WriteScore_ACT_SAT'; 
         attrib WriteCompScore_ACT_SAT length = $4
            label = 'WriteCompScore_ACT_SAT'; 
         attrib WriteScore_TAKS length = $4
            label = 'WriteScore_TAKS'; 
         attrib TSIWriteAtPlacement length = $1
            label = 'TSIWriteAtPlacement'; 
         attrib TSIWriteAssesmentScore length = $3
            label = 'TSIWriteAssesmentScore'; 
         attrib WriteEssayScore length = $1
            label = 'WriteEssayScore'; 
         attrib AlternateWriteMethod length = $1
            label = 'AlternateWriteMethod'; 
         attrib WriteTSIEndOfReportPeriod length = $1
            label = 'WriteTSIEndOfReportPeriod'; 
         attrib WriteFirstLevelCollegeCourse length = $1
            label = 'WriteFirstLevelCollegeCourse'; 
         attrib MathTSIABEDiagnosticScore length = $1
            label = 'MathTSIABEDiagnosticScore'; 
         attrib ReadTSIABEDiagnosticScore length = $1
            label = 'ReadTSIABEDiagnosticScore'; 
         attrib WriteTSIABEDiagnosticScore length = $1
            label = 'WriteTSIABEDiagnosticScore'; 
         attrib AcademicPlan length = $10
            format = $10.
            informat = $10.
            label = 'AcademicPlan'; 
         attrib AdmitTerm length = $4
            format = $4.
            informat = $4.
            label = 'AdmitTerm'; 
         attrib AcademicLevelBOT length = $3
            format = $3.
            informat = $3.
            label = 'AcademicLevelBOT'; 
         attrib AcademicProgram length = $5
            format = $5.
            informat = $5.
            label = 'AcademicProgram'; 
         attrib TotalCumulativeHours length = 8
            format = 11.3
            informat = 11.3
            label = 'TotalCumulativeHours'; 
         attrib EAPStudent length = $1
            label = 'EAPStudent'; 
         attrib Read_DTM length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'Read_DTM'; 
         attrib Stage_Update_ID length = $20
            format = $20.
            label = 'Stage_Update_ID'; 
         call missing(of _all_);
         stop;
      run;
      
      %rcSet(&syserr); 
      
   %end;  /* if table does not exist  */ 
   
   /*---- Append  ----*/ 
   %put %str(NOTE: Appending data ...);
   
   proc append base = CBMPRD.ADW_CBM002_CENSUS 
      data = &etls_lastTable (&etls_tableOptions)  force ; 
    run; 
   
   %rcSet(&syserr); 
   
   proc datasets lib = work nolist nowarn memtype = (data view);
      delete WTK9WBB;
   quit;
   
%mend etls_loader;
%etls_loader;

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM002_CENSUS, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM002_CENSUS, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from CBMPRD.ADW_CBM002_CENSUS;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Table Loader **/

%exitetls_conditionW1BNSK0T9:
%mend etls_conditionW1BNSK0T9;

%etls_conditionW1BNSK0T9;


/** Step end Conditional Start **/

/*==========================================================================* 
 * Step:            Replacing Census Day Data             A5B29B8Q.BZ000BU4 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Tables:   ADW_CBM002_CENSUS -                   A5B29B8Q.BE000171 * 
 *                   CBMPRD.ADW_CBM002_CENSUS                               * 
 *                  CBM002_Final - work.CBM002_Final      A5B29B8Q.BS00047A * 
 * Target Table:    CBM002_Census_info -                  A5B29B8Q.BS00047B * 
 *                   work.CBM002_Census_info                                * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BU4);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM002_CENSUS, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM002_CENSUS, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from CBMPRD.ADW_CBM002_CENSUS;
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
   delete CBM002_Census_info;
quit;

proc sql;
   create view work.CBM002_Census_info as
   select
      CBM002_Final.RecordCode length = 1   
         label = 'RecordCode',
      CBM002_Final.ReportingTerm length = 4   
         format = $4.
         label = 'ReportingTerm',
      CBM002_Final.FiceCode length = 6   
         label = 'FiceCode',
      CBM002_Final.National_Id length = 9   
         label = 'National_Id',
      CBM002_Final.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_Final.Semester length = 1   
         label = 'Semester',
      CBM002_Final.Year length = 4   
         label = 'Year',
      CBM002_Final.Ferpa length = 1   
         format = $1.
         informat = $1.
         label = 'Ferpa',
      CBM002_Final.Gender length = 1   
         format = $1.
         informat = $1.
         label = 'Gender',
      CBM002_Final.BirthDate length = 8   
         format = $8.
         informat = $8.
         label = 'BirthDate',
      CBM002_Final.TSIWaiverExemption length = 1   
         label = 'TSIWaiverExemption',
      CBM002_Final.Ethnic_Origin length = 1   
         format = $1.
         informat = $1.
         label = 'Ethnic_Origin',
      CBM002_Final.White length = 1   
         format = $1.
         informat = $1.
         label = 'White',
      CBM002_Final.Black length = 1   
         format = $1.
         informat = $1.
         label = 'Black',
      CBM002_Final.Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Asian',
      CBM002_Final.AmericanIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'AmericanIndAlsknNatv',
      CBM002_Final.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      CBM002_Final.UnknownNotReported length = 1   
         format = $1.
         informat = $1.
         label = 'UnknownNotReported',
      CBM002_Final.NativeHawnOthPacificIslander length = 1   
         format = $1.
         informat = $1.
         label = 'NativeHawnOthPacificIslander',
      CBM002_Final.Flex length = 1   
         label = 'Flex',
      case 
      when ADW_CBM002_CENSUS.TSIMathExemptedByCensus is missing then CBM002_Final.TSIMathExemptedByCensus 
      else ADW_CBM002_CENSUS.TSIMathExemptedByCensus 
      end as TSIMathExemptedByCensus length = 1   
         label = 'TSIMathExemptedByCensus',
      CBM002_Final.TSIMathWaiverExempted length = 1   
         label = 'TSIMathWaiverExempted',
      CBM002_Final.MathScore_ACT_SAT length = 3   
         label = 'MathScore_ACT_SAT',
      CBM002_Final.MathCompScore_ACT_SAT length = 4   
         label = 'MathCompScore_ACT_SAT',
      CBM002_Final.MathScore_TAKS length = 4   
         label = 'MathScore_TAKS',
      CBM002_Final.TSIMathAtPlacement length = 1   
         label = 'TSIMathAtPlacement',
      CBM002_Final.TSIMathAssesmentScore length = 3   
         label = 'TSIMathAssesmentScore',
      CBM002_Final.AlternateMathMethod length = 1   
         label = 'AlternateMathMethod',
      CBM002_Final.MathTSIEndOfReportPeriod length = 1   
         label = 'MathTSIEndOfReportPeriod',
      CBM002_Final.MathFirstLevelCollegeCourse length = 1   
         label = 'MathFirstLevelCollegeCourse',
      case 
      when ADW_CBM002_CENSUS.TSIReadExemptedByCensus is missing then CBM002_Final.TSIReadExemptedByCensus
      else ADW_CBM002_CENSUS.TSIReadExemptedByCensus 
      end as TSIReadExemptedByCensus length = 1   
         label = 'TSIReadExemptedByCensus',
      CBM002_Final.TSIReadWaiverExempted length = 1   
         label = 'TSIReadWaiverExempted',
      CBM002_Final.ReadScore_ACT_SAT length = 3   
         label = 'ReadScore_ACT_SAT',
      CBM002_Final.ReadCompScore_ACT_SAT length = 4   
         label = 'ReadCompScore_ACT_SAT',
      CBM002_Final.ReadScore_TAKS length = 4   
         label = 'ReadScore_TAKS',
      CBM002_Final.TSIReadAtPlacement length = 1   
         label = 'TSIReadAtPlacement',
      CBM002_Final.TSIReadAssesmentScore length = 3   
         label = 'TSIReadAssesmentScore',
      CBM002_Final.AlternateReadMethod length = 1   
         label = 'AlternateReadMethod',
      CBM002_Final.ReadTSIEndOfReportPeriod length = 1   
         label = 'ReadTSIEndOfReportPeriod',
      CBM002_Final.ReadFirstLevelCollegeCourse length = 1   
         label = 'ReadFirstLevelCollegeCourse',
      case 
      when ADW_CBM002_CENSUS.TSIWriteExemptedByCensus is missing then CBM002_Final.TSIWriteExemptedByCensus
      else ADW_CBM002_CENSUS.TSIWriteExemptedByCensus 
      end as TSIWriteExemptedByCensus length = 1   
         label = 'TSIWriteExemptedByCensus',
      CBM002_Final.TSIWriteWaiverExempted length = 1   
         label = 'TSIWriteWaiverExempted',
      CBM002_Final.WriteScore_ACT_SAT length = 3   
         label = 'WriteScore_ACT_SAT',
      CBM002_Final.WriteCompScore_ACT_SAT length = 4   
         label = 'WriteCompScore_ACT_SAT',
      CBM002_Final.WriteScore_TAKS length = 4   
         label = 'WriteScore_TAKS',
      CBM002_Final.TSIWriteAtPlacement length = 1   
         label = 'TSIWriteAtPlacement',
      CBM002_Final.TSIWriteAssesmentScore length = 3   
         label = 'TSIWriteAssesmentScore',
      CBM002_Final.WriteEssayScore length = 1   
         label = 'WriteEssayScore',
      CBM002_Final.AlternateWriteMethod length = 1   
         label = 'AlternateWriteMethod',
      CBM002_Final.WriteTSIEndOfReportPeriod length = 1   
         label = 'WriteTSIEndOfReportPeriod',
      CBM002_Final.WriteFirstLevelCollegeCourse length = 1   
         label = 'WriteFirstLevelCollegeCourse',
      CBM002_Final.MathTSIABEDiagnosticScore length = 1   
         label = 'MathTSIABEDiagnosticScore',
      CBM002_Final.ReadTSIABEDiagnosticScore length = 1   
         label = 'ReadTSIABEDiagnosticScore',
      CBM002_Final.WriteTSIABEDiagnosticScore length = 1   
         label = 'WriteTSIABEDiagnosticScore',
      CBM002_Final.AcademicPlan length = 10   
         format = $10.
         informat = $10.
         label = 'AcademicPlan',
      CBM002_Final.AdmitTerm length = 4   
         format = $4.
         informat = $4.
         label = 'AdmitTerm',
      CBM002_Final.AcademicLevelBOT length = 3   
         format = $3.
         informat = $3.
         label = 'AcademicLevelBOT',
      CBM002_Final.AcademicProgram length = 5   
         format = $5.
         informat = $5.
         label = 'AcademicProgram',
      CBM002_Final.TotalCumulativeHours length = 8   
         format = 11.3
         informat = 11.3
         label = 'TotalCumulativeHours',
      CBM002_Final.EAPStudent length = 1   
         label = 'EAPStudent',
      CBM002_Final.MathTSIEndOfTerm length = 8   
         label = 'MathTSIEndOfTerm',
      CBM002_Final.ReadTSIEndOfTerm length = 8   
         label = 'ReadTSIEndOfTerm',
      CBM002_Final.WriteTSIEndOfTerm length = 8   
         label = 'WriteTSIEndOfTerm'
   from
      work.CBM002_Final as CBM002_Final left join 
      CBMPRD.ADW_CBM002_CENSUS as ADW_CBM002_CENSUS
         on
         (
            CBM002_Final.EMPLID = ADW_CBM002_CENSUS.EMPLID
            and CBM002_Final.Semester = ADW_CBM002_CENSUS.Semester
            and CBM002_Final.Year = ADW_CBM002_CENSUS.Year
         )
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Replacing Census Day Data **/

/*==========================================================================* 
 * Step:            Report Logic-End of term              A5B29B8Q.BZ000BU5 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_Census_info -                  A5B29B8Q.BS00047B * 
 *                   work.CBM002_Census_info                                * 
 * Target Table:    CBM002_ReportingLogic2 -              A5B29B8Q.BS00047C * 
 *                   work.W211BBCCU                                         * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BU5);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = -1;
%let SYSLAST = %nrquote(work.CBM002_Census_info); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete W211BBCCU;
quit;

proc sql;
   create table work.W211BBCCU as
   select
      CBM002_Census_info.RecordCode length = 1   
         label = 'RecordCode',
      CBM002_Census_info.ReportingTerm length = 4   
         format = $4.
         label = 'ReportingTerm',
      CBM002_Census_info.FiceCode length = 6   
         label = 'FiceCode',
      CBM002_Census_info.National_Id length = 9   
         label = 'National_Id',
      CBM002_Census_info.EMPLID length = 11   
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CBM002_Census_info.Semester length = 1   
         label = 'Semester',
      CBM002_Census_info.Year length = 4   
         label = 'Year',
      CBM002_Census_info.Ferpa length = 1   
         format = $1.
         informat = $1.
         label = 'Ferpa',
      CBM002_Census_info.Gender length = 1   
         format = $1.
         informat = $1.
         label = 'Gender',
      CBM002_Census_info.BirthDate length = 8   
         format = $8.
         informat = $8.
         label = 'BirthDate',
      CBM002_Census_info.TSIWaiverExemption length = 1   
         label = 'TSIWaiverExemption',
      CBM002_Census_info.Ethnic_Origin length = 1   
         format = $1.
         informat = $1.
         label = 'Ethnic_Origin',
      CBM002_Census_info.White length = 1   
         format = $1.
         informat = $1.
         label = 'White',
      CBM002_Census_info.Black length = 1   
         format = $1.
         informat = $1.
         label = 'Black',
      CBM002_Census_info.Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Asian',
      CBM002_Census_info.AmericanIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'AmericanIndAlsknNatv',
      CBM002_Census_info.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      CBM002_Census_info.UnknownNotReported length = 1   
         format = $1.
         informat = $1.
         label = 'UnknownNotReported',
      CBM002_Census_info.NativeHawnOthPacificIslander length = 1   
         format = $1.
         informat = $1.
         label = 'NativeHawnOthPacificIslander',
      CBM002_Census_info.Flex length = 1   
         label = 'Flex',
      CBM002_Census_info.TSIMathExemptedByCensus length = 1   
         label = 'TSIMathExemptedByCensus',
      CBM002_Census_info.TSIMathWaiverExempted length = 1   
         label = 'TSIMathWaiverExempted',
      CBM002_Census_info.MathScore_ACT_SAT length = 3   
         label = 'MathScore_ACT_SAT',
      CBM002_Census_info.MathCompScore_ACT_SAT length = 4   
         label = 'MathCompScore_ACT_SAT',
      CBM002_Census_info.MathScore_TAKS length = 4   
         label = 'MathScore_TAKS',
      CBM002_Census_info.TSIMathAtPlacement length = 1   
         label = 'TSIMathAtPlacement',
      CBM002_Census_info.TSIMathAssesmentScore length = 3   
         label = 'TSIMathAssesmentScore',
      CBM002_Census_info.AlternateMathMethod length = 1   
         label = 'AlternateMathMethod',
      IFC( 
      CBM002_Census_info.TSIWaiverExemption in ('1', '2', '3'), '0', 
      	IFC(CBM002_Census_info.TSIMathExemptedByCensus in ('1', '2'), '2', 
      		IFC(CBM002_Census_info.MathTSIEndOfTerm =1, '1', '0'))) as MathTSIEndOfReportPeriod length = 1   
         label = 'MathTSIEndOfReportPeriod',
      CBM002_Census_info.MathFirstLevelCollegeCourse length = 1   
         label = 'MathFirstLevelCollegeCourse',
      CBM002_Census_info.TSIReadExemptedByCensus length = 1   
         label = 'TSIReadExemptedByCensus',
      CBM002_Census_info.TSIReadWaiverExempted length = 1   
         label = 'TSIReadWaiverExempted',
      CBM002_Census_info.ReadScore_ACT_SAT length = 3   
         label = 'ReadScore_ACT_SAT',
      CBM002_Census_info.ReadCompScore_ACT_SAT length = 4   
         label = 'ReadCompScore_ACT_SAT',
      CBM002_Census_info.ReadScore_TAKS length = 4   
         label = 'ReadScore_TAKS',
      CBM002_Census_info.TSIReadAtPlacement length = 1   
         label = 'TSIReadAtPlacement',
      CBM002_Census_info.TSIReadAssesmentScore length = 3   
         label = 'TSIReadAssesmentScore',
      CBM002_Census_info.AlternateReadMethod length = 1   
         label = 'AlternateReadMethod',
      IFC( 
      CBM002_Census_info.TSIWaiverExemption in ('1', '2', '3'), '0', 
      	IFC(CBM002_Census_info.TSIReadExemptedByCensus in ('1', '2'), '2', 
      		IFC(CBM002_Census_info.ReadTSIEndOfTerm =1, '1', '0'))) as ReadTSIEndOfReportPeriod length = 1   
         label = 'ReadTSIEndOfReportPeriod',
      CBM002_Census_info.ReadFirstLevelCollegeCourse length = 1   
         label = 'ReadFirstLevelCollegeCourse',
      CBM002_Census_info.TSIWriteExemptedByCensus length = 1   
         label = 'TSIWriteExemptedByCensus',
      CBM002_Census_info.TSIWriteWaiverExempted length = 1   
         label = 'TSIWriteWaiverExempted',
      CBM002_Census_info.WriteScore_ACT_SAT length = 3   
         label = 'WriteScore_ACT_SAT',
      CBM002_Census_info.WriteCompScore_ACT_SAT length = 4   
         label = 'WriteCompScore_ACT_SAT',
      CBM002_Census_info.WriteScore_TAKS length = 4   
         label = 'WriteScore_TAKS',
      CBM002_Census_info.TSIWriteAtPlacement length = 1   
         label = 'TSIWriteAtPlacement',
      CBM002_Census_info.TSIWriteAssesmentScore length = 3   
         label = 'TSIWriteAssesmentScore',
      CBM002_Census_info.WriteEssayScore length = 1   
         label = 'WriteEssayScore',
      CBM002_Census_info.AlternateWriteMethod length = 1   
         label = 'AlternateWriteMethod',
      IFC( 
      CBM002_Census_info.TSIWaiverExemption in ('1', '2', '3'), '0', 
      	IFC(CBM002_Census_info.TSIWriteExemptedByCensus in ('1', '2'), '2', 
      		IFC(CBM002_Census_info.WriteTSIEndOfTerm =1, '1', '0'))) as WriteTSIEndOfReportPeriod length = 1   
         label = 'WriteTSIEndOfReportPeriod',
      CBM002_Census_info.WriteFirstLevelCollegeCourse length = 1   
         label = 'WriteFirstLevelCollegeCourse',
      CBM002_Census_info.MathTSIABEDiagnosticScore length = 1   
         label = 'MathTSIABEDiagnosticScore',
      CBM002_Census_info.ReadTSIABEDiagnosticScore length = 1   
         label = 'ReadTSIABEDiagnosticScore',
      CBM002_Census_info.WriteTSIABEDiagnosticScore length = 1   
         label = 'WriteTSIABEDiagnosticScore',
      CBM002_Census_info.AcademicPlan length = 10   
         format = $10.
         informat = $10.
         label = 'AcademicPlan',
      CBM002_Census_info.AdmitTerm length = 4   
         format = $4.
         informat = $4.
         label = 'AdmitTerm',
      CBM002_Census_info.AcademicLevelBOT length = 3   
         format = $3.
         informat = $3.
         label = 'AcademicLevelBOT',
      CBM002_Census_info.AcademicProgram length = 5   
         format = $5.
         informat = $5.
         label = 'AcademicProgram',
      CBM002_Census_info.TotalCumulativeHours length = 8   
         format = 11.3
         informat = 11.3
         label = 'TotalCumulativeHours',
      CBM002_Census_info.EAPStudent length = 1   
         label = 'EAPStudent'
   from
      work.CBM002_Census_info as CBM002_Census_info
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Report Logic-End of term **/

/*==========================================================================* 
 * Step:            Table Loader                          A5B29B8Q.BZ000BU6 * 
 * Transform:       Table Loader (Version 2.1)                              * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_ReportingLogic2 -              A5B29B8Q.BS00047C * 
 *                   work.W211BBCCU                                         * 
 * Target Table:    ADW_CBM002_WORK -                     A5B29B8Q.BE000172 * 
 *                   CBMPRD.ADW_CBM002_WORK                                 * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BU6);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let SYSLAST = %nrquote(work.W211BBCCU); 

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
   
   /*---- Set the Load Time column  ----*/ 
   %let etls_jobLoadTime = &SYSDATE9.:&SYSTIME;
   %let etls_loadTime = &etls_jobLoadTime; 
   data _null_;
      _loadtime = input("&etls_LoadTime",DATETIME20.);
      put "NOTE: The load time is: " _loadtime nldatm.;
   run;
   
   proc datasets lib = work nolist nowarn memtype = (data view);
      delete WTK9WDN;
   quit;
   
   data work.WTK9WDN / view=work.WTK9WDN;
      set &SYSLAST (&etls_tableOptions);
      READ_DTM = "&etls_LoadTime"dt;
   run;
   
   %rcSet(&syserr); 
   
   %let SYSLAST = work.WTK9WDN;
   %let etls_lastTable = &SYSLAST; 
   
   /*---- Map the columns  ----*/ 
   proc datasets lib = work nolist nowarn memtype = (data view);
      delete WTK9WDO;
   quit;
   
   %put %str(NOTE: Mapping columns ...);
   proc sql;
      create view work.WTK9WDO as
         select
            RecordCode,
            ReportingTerm,
            FiceCode,
            National_Id,
            EMPLID,
            Semester,
            Year,
            Ferpa,
            Gender,
            BirthDate,
            TSIWaiverExemption,
            Ethnic_Origin,
            White,
            Black,
            Asian,
            AmericanIndAlsknNatv,
            International,
            UnknownNotReported,
            NativeHawnOthPacificIslander,
            Flex,
            TSIMathExemptedByCensus,
            TSIMathWaiverExempted,
            MathScore_ACT_SAT,
            MathCompScore_ACT_SAT,
            MathScore_TAKS,
            TSIMathAtPlacement,
            TSIMathAssesmentScore,
            AlternateMathMethod,
            MathTSIEndOfReportPeriod,
            MathFirstLevelCollegeCourse,
            TSIReadExemptedByCensus,
            TSIReadWaiverExempted,
            ReadScore_ACT_SAT,
            ReadCompScore_ACT_SAT,
            ReadScore_TAKS,
            TSIReadAtPlacement,
            TSIReadAssesmentScore,
            AlternateReadMethod,
            ReadTSIEndOfReportPeriod,
            ReadFirstLevelCollegeCourse,
            TSIWriteExemptedByCensus,
            TSIWriteWaiverExempted,
            WriteScore_ACT_SAT,
            WriteCompScore_ACT_SAT,
            WriteScore_TAKS,
            TSIWriteAtPlacement,
            TSIWriteAssesmentScore,
            WriteEssayScore,
            AlternateWriteMethod,
            WriteTSIEndOfReportPeriod,
            WriteFirstLevelCollegeCourse,
            MathTSIABEDiagnosticScore,
            ReadTSIABEDiagnosticScore,
            WriteTSIABEDiagnosticScore,
            AcademicPlan,
            AdmitTerm,
            AcademicLevelBOT,
            AcademicProgram,
            TotalCumulativeHours,
            EAPStudent,
            READ_DTM,
            ("&SYSUSERID") as STAGE_UPDATE_ID length = 20
               format = $20.
               informat = $20.
      from &etls_lastTable
      ;
   quit;
   
   %let SYSLAST = work.WTK9WDO;
   
   %let etls_lastTable = &SYSLAST; 
   %let etls_tableOptions = ; 
   
   /* Determine if the target table exists  */ 
   %let etls_tableExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM002_WORK, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM002_WORK, VIEW))); 
   
   /*---- Create a new table  ----*/ 
   %if (&etls_tableExist eq 0) %then 
   %do;  /* if table does not exist  */ 
   
      %put %str(NOTE: Creating table ...);
      
      data CBMPRD.ADW_CBM002_WORK
              (dbnull = (
                         RecordCode = YES
                         ReportingTerm = YES
                         FiceCode = YES
                         National_Id = YES
                         EMPLID = NO
                         Semester = YES
                         Year = YES
                         Ferpa = YES
                         Gender = YES
                         BirthDate = YES
                         TSIWaiverExemption = YES
                         Ethnic_Origin = YES
                         White = YES
                         Black = YES
                         Asian = YES
                         AmericanIndAlsknNatv = YES
                         International = YES
                         UnknownNotReported = YES
                         NativeHawnOthPacificIslander = YES
                         Flex = YES
                         TSIMathExemptedByCensus = YES
                         TSIMathWaiverExempted = YES
                         MathScore_ACT_SAT = YES
                         MathCompScore_ACT_SAT = YES
                         MathScore_TAKS = YES
                         TSIMathAtPlacement = YES
                         TSIMathAssesmentScore = YES
                         AlternateMathMethod = YES
                         MathTSIEndOfReportPeriod = YES
                         MathFirstLevelCollegeCourse = YES
                         TSIReadExemptedByCensus = YES
                         TSIReadWaiverExempted = YES
                         ReadScore_ACT_SAT = YES
                         ReadCompScore_ACT_SAT = YES
                         ReadScore_TAKS = YES
                         TSIReadAtPlacement = YES
                         TSIReadAssesmentScore = YES
                         AlternateReadMethod = YES
                         ReadTSIEndOfReportPeriod = YES
                         ReadFirstLevelCollegeCourse = YES
                         TSIWriteExemptedByCensus = YES
                         TSIWriteWaiverExempted = YES
                         WriteScore_ACT_SAT = YES
                         WriteCompScore_ACT_SAT = YES
                         WriteScore_TAKS = YES
                         TSIWriteAtPlacement = YES
                         TSIWriteAssesmentScore = YES
                         WriteEssayScore = YES
                         AlternateWriteMethod = YES
                         WriteTSIEndOfReportPeriod = YES
                         WriteFirstLevelCollegeCourse = YES
                         MathTSIABEDiagnosticScore = YES
                         ReadTSIABEDiagnosticScore = YES
                         WriteTSIABEDiagnosticScore = YES
                         AcademicPlan = YES
                         AdmitTerm = YES
                         AcademicLevelBOT = YES
                         AcademicProgram = YES
                         TotalCumulativeHours = YES
                         EAPStudent = YES
                         READ_DTM = YES
                         STAGE_UPDATE_ID = YES));
         attrib RecordCode length = $1
            label = 'RecordCode'; 
         attrib ReportingTerm length = $4
            format = $4.
            label = 'ReportingTerm'; 
         attrib FiceCode length = $6
            label = 'FiceCode'; 
         attrib National_Id length = $9
            label = 'National_Id'; 
         attrib EMPLID length = $11
            format = $11.
            informat = $11.
            label = 'EMPLID'; 
         attrib Semester length = $1
            label = 'Semester'; 
         attrib Year length = $4
            label = 'Year'; 
         attrib Ferpa length = $1
            format = $1.
            informat = $1.
            label = 'Ferpa'; 
         attrib Gender length = $1
            format = $1.
            informat = $1.
            label = 'Gender'; 
         attrib BirthDate length = $8
            format = $8.
            informat = $8.
            label = 'BirthDate'; 
         attrib TSIWaiverExemption length = $1
            label = 'TSIWaiverExemption'; 
         attrib Ethnic_Origin length = $1
            format = $1.
            informat = $1.
            label = 'Ethnic_Origin'; 
         attrib White length = $1
            format = $1.
            informat = $1.
            label = 'White'; 
         attrib Black length = $1
            format = $1.
            informat = $1.
            label = 'Black'; 
         attrib Asian length = $1
            format = $1.
            informat = $1.
            label = 'Asian'; 
         attrib AmericanIndAlsknNatv length = $1
            format = $1.
            informat = $1.
            label = 'AmericanIndAlsknNatv'; 
         attrib International length = $1
            format = $1.
            informat = $1.
            label = 'International'; 
         attrib UnknownNotReported length = $1
            format = $1.
            informat = $1.
            label = 'UnknownNotReported'; 
         attrib NativeHawnOthPacificIslander length = $1
            format = $1.
            informat = $1.
            label = 'NativeHawnOthPacificIslander'; 
         attrib Flex length = $1
            label = 'Flex'; 
         attrib TSIMathExemptedByCensus length = $1
            label = 'TSIMathExemptedByCensus'; 
         attrib TSIMathWaiverExempted length = $1
            label = 'TSIMathWaiverExempted'; 
         attrib MathScore_ACT_SAT length = $3
            label = 'MathScore_ACT_SAT'; 
         attrib MathCompScore_ACT_SAT length = $4
            label = 'MathCompScore_ACT_SAT'; 
         attrib MathScore_TAKS length = $4
            label = 'MathScore_TAKS'; 
         attrib TSIMathAtPlacement length = $1
            label = 'TSIMathAtPlacement'; 
         attrib TSIMathAssesmentScore length = $3
            label = 'TSIMathAssesmentScore'; 
         attrib AlternateMathMethod length = $1
            label = 'AlternateMathMethod'; 
         attrib MathTSIEndOfReportPeriod length = $1
            label = 'MathTSIEndOfReportPeriod'; 
         attrib MathFirstLevelCollegeCourse length = $1
            label = 'MathFirstLevelCollegeCourse'; 
         attrib TSIReadExemptedByCensus length = $1
            label = 'TSIReadExemptedByCensus'; 
         attrib TSIReadWaiverExempted length = $1
            label = 'TSIReadWaiverExempted'; 
         attrib ReadScore_ACT_SAT length = $3
            label = 'ReadScore_ACT_SAT'; 
         attrib ReadCompScore_ACT_SAT length = $4
            label = 'ReadCompScore_ACT_SAT'; 
         attrib ReadScore_TAKS length = $4
            label = 'ReadScore_TAKS'; 
         attrib TSIReadAtPlacement length = $1
            label = 'TSIReadAtPlacement'; 
         attrib TSIReadAssesmentScore length = $3
            label = 'TSIReadAssesmentScore'; 
         attrib AlternateReadMethod length = $1
            label = 'AlternateReadMethod'; 
         attrib ReadTSIEndOfReportPeriod length = $1
            label = 'ReadTSIEndOfReportPeriod'; 
         attrib ReadFirstLevelCollegeCourse length = $1
            label = 'ReadFirstLevelCollegeCourse'; 
         attrib TSIWriteExemptedByCensus length = $1
            label = 'TSIWriteExemptedByCensus'; 
         attrib TSIWriteWaiverExempted length = $1
            label = 'TSIWriteWaiverExempted'; 
         attrib WriteScore_ACT_SAT length = $3
            label = 'WriteScore_ACT_SAT'; 
         attrib WriteCompScore_ACT_SAT length = $4
            label = 'WriteCompScore_ACT_SAT'; 
         attrib WriteScore_TAKS length = $4
            label = 'WriteScore_TAKS'; 
         attrib TSIWriteAtPlacement length = $1
            label = 'TSIWriteAtPlacement'; 
         attrib TSIWriteAssesmentScore length = $3
            label = 'TSIWriteAssesmentScore'; 
         attrib WriteEssayScore length = $1
            label = 'WriteEssayScore'; 
         attrib AlternateWriteMethod length = $1
            label = 'AlternateWriteMethod'; 
         attrib WriteTSIEndOfReportPeriod length = $1
            label = 'WriteTSIEndOfReportPeriod'; 
         attrib WriteFirstLevelCollegeCourse length = $1
            label = 'WriteFirstLevelCollegeCourse'; 
         attrib MathTSIABEDiagnosticScore length = $1
            label = 'MathTSIABEDiagnosticScore'; 
         attrib ReadTSIABEDiagnosticScore length = $1
            label = 'ReadTSIABEDiagnosticScore'; 
         attrib WriteTSIABEDiagnosticScore length = $1
            label = 'WriteTSIABEDiagnosticScore'; 
         attrib AcademicPlan length = $10
            format = $10.
            informat = $10.
            label = 'AcademicPlan'; 
         attrib AdmitTerm length = $4
            format = $4.
            informat = $4.
            label = 'AdmitTerm'; 
         attrib AcademicLevelBOT length = $3
            format = $3.
            informat = $3.
            label = 'AcademicLevelBOT'; 
         attrib AcademicProgram length = $5
            format = $5.
            informat = $5.
            label = 'AcademicProgram'; 
         attrib TotalCumulativeHours length = 8
            format = 11.3
            informat = 11.3
            label = 'TotalCumulativeHours'; 
         attrib EAPStudent length = $1
            label = 'EAPStudent'; 
         attrib READ_DTM length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'READ_DTM'; 
         attrib STAGE_UPDATE_ID length = $20
            format = $20.
            informat = $20.
            label = 'STAGE_UPDATE_ID'; 
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
            truncate table CBMPRD.ADW_CBM002_WORK
         ) by ORACLE; 
         
         %rcSet(&sqlrc); 
         
         disconnect from ORACLE; 
      quit; 
      
      %rcSet(&sqlrc); 
      
   %end; /* table exists */ 
   
   /*---- Append  ----*/ 
   %put %str(NOTE: Appending data ...);
   
   proc append base = CBMPRD.ADW_CBM002_WORK 
      data = &etls_lastTable (&etls_tableOptions)  force ; 
    run; 
   
   %rcSet(&syserr); 
   
   proc datasets lib = work nolist nowarn memtype = (data view);
      delete WTK9WDO;
   quit;
   
%mend etls_loader;
%etls_loader;

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM002_WORK, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM002_WORK, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from CBMPRD.ADW_CBM002_WORK;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Table Loader **/

/*==========================================================================* 
 * Step:            CB Reported                           A5B29B8Q.BZ000BU7 * 
 * Transform:       Join                                                    * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    ADW_CBM002_WORK -                     A5B29B8Q.BE000172 * 
 *                   CBMPRD.ADW_CBM002_WORK                                 * 
 * Target Table:    CBM002_CBReported - work.W197I3SO4    A5B29B8Q.BS00047D * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BU7);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recnt = 0;
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(CBMPRD.ADW_CBM002_WORK, DATA)) or 
         %sysfunc(exist(CBMPRD.ADW_CBM002_WORK, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      proc sql noprint;
         select count(*) into :etls_recnt from CBMPRD.ADW_CBM002_WORK;
      quit;
   %end;
%mend etls_recordCheck;
%etls_recordCheck;

%let SYSLAST = %nrquote(CBMPRD.ADW_CBM002_WORK); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|SQLJoin), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%global etls_sql_pushDown;
%let etls_sql_pushDown = -1;
option DBIDIRECTEXEC;

proc datasets lib = work nolist nowarn memtype = (data view);
   delete W197I3SO4;
quit;

data _null_;
   put "NOTE: The following column(s) do not have a column mapping, so the"
        " value(s) will be set to missing: Unused, Unused2";
run;

proc sql;
   create table work.W197I3SO4 as
   select distinct
      ADW_CBM002_WORK.RecordCode length = 1   
         label = 'RecordCode',
      ADW_CBM002_WORK.FiceCode length = 6   
         label = 'FiceCode',
      ADW_CBM002_WORK.National_Id length = 9   
         label = 'National_Id',
      ADW_CBM002_WORK.Semester length = 1   
         label = 'Semester',
      ADW_CBM002_WORK.Year length = 4   
         label = 'Year',
      ADW_CBM002_WORK.Ferpa length = 1   
         format = $1.
         informat = $1.
         label = 'Ferpa',
      ADW_CBM002_WORK.Gender length = 1   
         format = $1.
         informat = $1.
         label = 'Gender',
      "" as Unused length = 1,
      ADW_CBM002_WORK.BirthDate length = 8   
         format = $8.
         informat = $8.
         label = 'BirthDate',
      ADW_CBM002_WORK.TSIWaiverExemption length = 1   
         label = 'TSIWaiverExemption',
      ADW_CBM002_WORK.Ethnic_Origin length = 1   
         format = $1.
         informat = $1.
         label = 'Ethnic_Origin',
      ADW_CBM002_WORK.White length = 1   
         format = $1.
         informat = $1.
         label = 'White',
      ADW_CBM002_WORK.Black length = 1   
         format = $1.
         informat = $1.
         label = 'Black',
      ADW_CBM002_WORK.Asian length = 1   
         format = $1.
         informat = $1.
         label = 'Asian',
      ADW_CBM002_WORK.AmericanIndAlsknNatv length = 1   
         format = $1.
         informat = $1.
         label = 'AmericanIndAlsknNatv',
      ADW_CBM002_WORK.International length = 1   
         format = $1.
         informat = $1.
         label = 'International',
      ADW_CBM002_WORK.UnknownNotReported length = 1   
         format = $1.
         informat = $1.
         label = 'UnknownNotReported',
      ADW_CBM002_WORK.NativeHawnOthPacificIslander length = 1   
         format = $1.
         informat = $1.
         label = 'NativeHawnOthPacificIslander',
      ADW_CBM002_WORK.Flex length = 1   
         label = 'Flex',
      "" as Unused2 length = 2,
      ADW_CBM002_WORK.TSIMathExemptedByCensus length = 1   
         label = 'TSIMathExemptedByCensus',
      ADW_CBM002_WORK.TSIMathWaiverExempted length = 1   
         label = 'TSIMathWaiverExempted',
      ADW_CBM002_WORK.MathScore_ACT_SAT length = 3   
         label = 'MathScore_ACT_SAT',
      ADW_CBM002_WORK.MathCompScore_ACT_SAT length = 4   
         label = 'MathCompScore_ACT_SAT',
      ADW_CBM002_WORK.MathScore_TAKS length = 4   
         label = 'MathScore_TAKS',
      ADW_CBM002_WORK.TSIMathAtPlacement length = 1   
         label = 'TSIMathAtPlacement',
      ADW_CBM002_WORK.TSIMathAssesmentScore length = 3   
         label = 'TSIMathAssesmentScore',
      ADW_CBM002_WORK.AlternateMathMethod length = 1   
         label = 'AlternateMathMethod',
      ADW_CBM002_WORK.MathTSIEndOfReportPeriod length = 1   
         label = 'MathTSIEndOfReportPeriod',
      ADW_CBM002_WORK.MathFirstLevelCollegeCourse length = 1   
         label = 'MathFirstLevelCollegeCourse',
      ADW_CBM002_WORK.TSIReadExemptedByCensus length = 1   
         label = 'TSIReadExemptedByCensus',
      ADW_CBM002_WORK.TSIReadWaiverExempted length = 1   
         label = 'TSIReadWaiverExempted',
      ADW_CBM002_WORK.ReadScore_ACT_SAT length = 3   
         label = 'ReadScore_ACT_SAT',
      ADW_CBM002_WORK.ReadCompScore_ACT_SAT length = 4   
         label = 'ReadCompScore_ACT_SAT',
      ADW_CBM002_WORK.ReadScore_TAKS length = 4   
         label = 'ReadScore_TAKS',
      ADW_CBM002_WORK.TSIReadAtPlacement length = 1   
         label = 'TSIReadAtPlacement',
      ADW_CBM002_WORK.TSIReadAssesmentScore length = 3   
         label = 'TSIReadAssesmentScore',
      ADW_CBM002_WORK.AlternateReadMethod length = 1   
         label = 'AlternateReadMethod',
      ADW_CBM002_WORK.ReadTSIEndOfReportPeriod length = 1   
         label = 'ReadTSIEndOfReportPeriod',
      ADW_CBM002_WORK.ReadFirstLevelCollegeCourse length = 1   
         label = 'ReadFirstLevelCollegeCourse',
      ADW_CBM002_WORK.TSIWriteExemptedByCensus length = 1   
         label = 'TSIWriteExemptedByCensus',
      ADW_CBM002_WORK.TSIWriteWaiverExempted length = 1   
         label = 'TSIWriteWaiverExempted',
      ADW_CBM002_WORK.WriteScore_ACT_SAT length = 3   
         label = 'WriteScore_ACT_SAT',
      ADW_CBM002_WORK.WriteCompScore_ACT_SAT length = 4   
         label = 'WriteCompScore_ACT_SAT',
      ADW_CBM002_WORK.WriteScore_TAKS length = 4   
         label = 'WriteScore_TAKS',
      ADW_CBM002_WORK.TSIWriteAtPlacement length = 1   
         label = 'TSIWriteAtPlacement',
      ADW_CBM002_WORK.TSIWriteAssesmentScore length = 3   
         label = 'TSIWriteAssesmentScore',
      ADW_CBM002_WORK.WriteEssayScore length = 1   
         label = 'WriteEssayScore',
      ADW_CBM002_WORK.AlternateWriteMethod length = 1   
         label = 'AlternateWriteMethod',
      ADW_CBM002_WORK.WriteTSIEndOfReportPeriod length = 1   
         label = 'WriteTSIEndOfReportPeriod',
      ADW_CBM002_WORK.WriteFirstLevelCollegeCourse length = 1   
         label = 'WriteFirstLevelCollegeCourse',
      ADW_CBM002_WORK.MathTSIABEDiagnosticScore length = 1   
         label = 'MathTSIABEDiagnosticScore',
      ADW_CBM002_WORK.ReadTSIABEDiagnosticScore length = 1   
         label = 'ReadTSIABEDiagnosticScore',
      ADW_CBM002_WORK.WriteTSIABEDiagnosticScore length = 1   
         label = 'WriteTSIABEDiagnosticScore'
   from
      CBMPRD.ADW_CBM002_WORK as ADW_CBM002_WORK
   ;
quit;

%global etls_sql_pushDown;
%let etls_sql_pushDown = &sys_sql_ip_all;

%rcSet(&sqlrc); 

%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end CB Reported **/

/*==========================================================================* 
 * Step:            Write to Text file                    A5B29B8Q.BZ000BU8 * 
 * Transform:       User Written                                            * 
 * Description:                                                             * 
 *                                                                          * 
 * Source Table:    CBM002_CBReported - work.W197I3SO4    A5B29B8Q.BS00047D * 
 * Target Table:    User Written - work.W199YDJTG         A5B29B8Q.BS00047E * 
 *                                                                          * 
 * User Written:    SourceCode                                              * 
 *==========================================================================*/ 

%let transformID = %quote(A5B29B8Q.BZ000BU8);
%let trans_rc = 0;
%let etls_stepStartTime = %sysfunc(datetime(), datetime20.); 

%let etls_recCheckExist = 0; 
%let etls_recnt = 0; 
%macro etls_recordCheck; 
   %let etls_recCheckExist = %eval(%sysfunc(exist(work.W197I3SO4, DATA)) or 
         %sysfunc(exist(work.W197I3SO4, VIEW))); 
   
   %if (&etls_recCheckExist) %then
   %do;
      %local etls_syntaxcheck; 
      %let etls_syntaxcheck = %sysfunc(getoption(syntaxcheck)); 
      /* Turn off syntaxcheck option to perform following steps  */ 
      options nosyntaxcheck;
      
      proc contents data = work.W197I3SO4 out = work.etls_contents(keep = nobs) noprint; 
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

%let SYSLAST = %nrquote(work.W197I3SO4); 

/* Runtime statistics macros  */ 
%etls_setPerfInit;
%perfstrt(txnname=%BQUOTE(_DISARM|&transformID|&syshostname|UserWritten), metrNam6=_DISROWCNT, metrDef6=Count32)   ;

%let _INPUT_count = 1;
%let _INPUT = work.W197I3SO4;
%let _INPUT_connect = ;
%let _INPUT_engine = ;
%let _INPUT_memtype = DATA;
%let _INPUT_options = %nrquote();
%let _INPUT_alter = %nrquote();
%let _INPUT_path = %nrquote(/CBM002_CBReported_A5B29B8Q.BS00047D%(WorkTable%));
%let _INPUT_type = 1;
%let _INPUT_label = %nrquote();
%let _INPUT_filetype = WorkTable;

%let _INPUT1 = work.W197I3SO4;
%let _INPUT1_connect = ;
%let _INPUT1_engine = ;
%let _INPUT1_memtype = DATA;
%let _INPUT1_options = %nrquote();
%let _INPUT1_alter = %nrquote();
%let _INPUT1_path = %nrquote(/CBM002_CBReported_A5B29B8Q.BS00047D%(WorkTable%));
%let _INPUT1_type = 1;
%let _INPUT1_label = %nrquote();
%let _INPUT1_filetype = WorkTable;

%let _OUTPUT_count = 1;
%let _OUTPUT = work.W199YDJTG;
%let _OUTPUT_connect = ;
%let _OUTPUT_engine = ;
%let _OUTPUT_memtype = DATA;
%let _OUTPUT_options = %nrquote();
%let _OUTPUT_alter = %nrquote();
%let _OUTPUT_path = %nrquote(/User Written_A5B29B8Q.BS00047E%(WorkTable%));
%let _OUTPUT_type = 1;
%let _OUTPUT_label = %nrquote();
%let _OUTPUT_col_count = 0;
%let _OUTPUT_filetype = WorkTable;

%let _OUTPUT1 = work.W199YDJTG;
%let _OUTPUT1_connect = ;
%let _OUTPUT1_engine = ;
%let _OUTPUT1_memtype = DATA;
%let _OUTPUT1_options = %nrquote();
%let _OUTPUT1_alter = %nrquote();
%let _OUTPUT1_path = %nrquote(/User Written_A5B29B8Q.BS00047E%(WorkTable%));
%let _OUTPUT1_type = 1;
%let _OUTPUT1_label = %nrquote();
%let _OUTPUT1_col_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/ 

%let CBM002OutputFileLoc =/sasdata/Data/CBM/CBM002/CBM002_&current_term._&sysdate9..txt;

DATA _NULL_;
FILE "&CBM002OutputFileLoc.";
SET &_input. END=EOF;
if _n_ = 1 then do;
	put 'HY2K003656CBM002' @@ ;
	put Semester $1. @@;
	put year $4. @@;
	put 'C0105JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU' ;
end;

PUT
@1  RecordCode $1.
@2  FiceCode $6.
@8  National_Id $9.
@17  Semester $1.
@18  Year $4.
@22  Ferpa $1.
@23  Gender $1.
@24  Unused $1.
@25  BirthDate $8.
@33  TSIWaiverExemption $1.
@34  Ethnic_Origin $1.
@35  White $1.
@36  Black $1.
@37  Asian $1.
@38  AmericanIndAlsknNatv $1.
@39  International $1.
@40  UnknownNotReported $1.
@41  NativeHawnOthPacificIslander $1.
@42  Flex $1.
@43  Unused2 $2.
@45  TSIMathExemptedByCensus $1.
@46  TSIMathWaiverExempted $1.
@47  MathScore_ACT_SAT $3.
@50  MathCompScore_ACT_SAT $4.
@54  MathScore_TAKS $4.
@58  TSIMathAtPlacement $1.
@59  TSIMathAssesmentScore $3.
@62  AlternateMathMethod $1.
@63  MathTSIEndOfReportPeriod $1.
@64  MathFirstLevelCollegeCourse $1.
@65  TSIReadExemptedByCensus $1.
@66  TSIReadWaiverExempted $1.
@67  ReadScore_ACT_SAT $3.
@70  ReadCompScore_ACT_SAT $4.
@74  ReadScore_TAKS $4.
@78  TSIReadAtPlacement $1.
@79  TSIReadAssesmentScore $3.
@82  AlternateReadMethod $1.
@83  ReadTSIEndOfReportPeriod $1.
@84  ReadFirstLevelCollegeCourse $1.
@85  TSIWriteExemptedByCensus $1.
@86  TSIWriteWaiverExempted $1.
@87  WriteScore_ACT_SAT $3.
@90  WriteCompScore_ACT_SAT $4.
@94  WriteScore_TAKS $4.
@98  TSIWriteAtPlacement $1.
@99  TSIWriteAssesmentScore $3.
@102  WriteEssayScore $1.
@103  AlternateWriteMethod $1.
@104  WriteTSIEndOfReportPeriod $1.
@105  WriteFirstLevelCollegeCourse $1.
@106  MathTSIABEDiagnosticScore $1.
@107  ReadTSIABEDiagnosticScore $1.
@108  WriteTSIABEDiagnosticScore $1.


;

if eof then do;
put @1 'EOF1' @@
 _N_ z5. @@
 ;

end;

RUN;
	



/*---- End of User Written Code  ----*/ 

%rcSet(&syserr); 
%rcSet(&sqlrc); 
%perfstop(metrVal6=%sysfunc(max(&etls_recnt,-1)));
%let etls_recnt=-1;



/** Step end Write to Text file **/

%let etls_endTime = %sysfunc(datetime(),datetime.);

/* Turn off performance statistics collection  */ 
data _null_;
   if "&_perfinit" eq "1" then 
      call execute('%perfend;');
      
run;
