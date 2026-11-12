/*==========================================================================*
 * Step:            Enter the input terms for report      A5B29B8Q.BZ0005NB *
 * Transform:       User Written                                            *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 * Target Table:    User Written -                        A5B29B8Q.BS0001S8 *
 *                   work.CBM008_TermDimension_Manual                       *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NB);

%let SYSLAST = %nrquote(ADWTGTPR.ADW_TERM_DIM);


%let _INPUT = ADWTGTPR.ADW_TERM_DIM;

%let _INPUT1_filetype = PhysicalTable;

%let _OUTPUT = work.CBM008_TermDimension_Manual;
        Current_Term_End_Date;

        Current_Term_End_Date;
%let _OUTPUT1_col_count = 7;
%let _OUTPUT1_col0_name = STRM;
%let _OUTPUT1_col0_table = work.CBM008_TermDimension_Manual;
%let _OUTPUT1_col0_length = 4;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $4.;
%let _OUTPUT1_col0_informat = $4.;
%let _OUTPUT1_col0_label = %nrquote(STRM);
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input_count = 0;
%let _OUTPUT1_col1_name = ACAD_CAREER;
%let _OUTPUT1_col1_table = work.CBM008_TermDimension_Manual;
%let _OUTPUT1_col1_length = 4;
%let _OUTPUT1_col1_type = $;
%let _OUTPUT1_col1_format = $4.;
%let _OUTPUT1_col1_informat = $4.;
%let _OUTPUT1_col1_label = %nrquote(ACAD_CAREER);
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input_count = 0;
%let _OUTPUT1_col2_name = TERM_BEGIN_DT;
%let _OUTPUT1_col2_table = work.CBM008_TermDimension_Manual;
%let _OUTPUT1_col2_length = 8;
%let _OUTPUT1_col2_type = ;
%let _OUTPUT1_col2_format = DATETIME20.;
%let _OUTPUT1_col2_informat = DATETIME20.;
%let _OUTPUT1_col2_label = %nrquote(TERM_BEGIN_DT);
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input_count = 0;
%let _OUTPUT1_col3_name = TERM_END_DT;
%let _OUTPUT1_col3_table = work.CBM008_TermDimension_Manual;
%let _OUTPUT1_col3_length = 8;
%let _OUTPUT1_col3_type = ;
%let _OUTPUT1_col3_format = DATETIME20.;
%let _OUTPUT1_col3_informat = DATETIME20.;
%let _OUTPUT1_col3_label = %nrquote(TERM_END_DT);
%let _OUTPUT1_col3_exp = ;
%let _OUTPUT1_col3_input_count = 0;
%let _OUTPUT1_col4_name = CENSUS_DT;
%let _OUTPUT1_col4_table = work.CBM008_TermDimension_Manual;
%let _OUTPUT1_col4_length = 8;
%let _OUTPUT1_col4_type = ;
%let _OUTPUT1_col4_format = DATETIME20.;
%let _OUTPUT1_col4_informat = DATETIME20.;
%let _OUTPUT1_col4_label = %nrquote(CENSUS_DT);
%let _OUTPUT1_col4_exp = ;
%let _OUTPUT1_col4_input_count = 0;
%let _OUTPUT1_col5_name = Current_Term;
%let _OUTPUT1_col5_table = work.CBM008_TermDimension_Manual;
%let _OUTPUT1_col5_length = 8;
%let _OUTPUT1_col5_type = $;
%let _OUTPUT1_col5_format = $4.;
%let _OUTPUT1_col5_informat = ;
%let _OUTPUT1_col5_label = %nrquote(Current_Term);
%let _OUTPUT1_col5_exp = ;
%let _OUTPUT1_col5_input_count = 0;
%let _OUTPUT1_col6_name = Current_Term_End_Date;
%let _OUTPUT1_col6_table = work.CBM008_TermDimension_Manual;
%let _OUTPUT1_col6_length = 8;
%let _OUTPUT1_col6_type = ;
%let _OUTPUT1_col6_format = Datetime20.;
%let _OUTPUT1_col6_informat = DATETIME20.;
%let _OUTPUT1_col6_label = %nrquote(Current_Term_End_Date);
%let _OUTPUT1_col6_exp = ;
%let _OUTPUT1_col6_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/

/*%let current_term=2198;
%let prior_term=2195;*/
/*%let current_term=2202;
%let prior_term=2198;*/
/*%let current_term=2205;
%let prior_term=2202;*/
/*%let current_term=2228;
%let prior_term=2225;*/
/*%let current_term=2232;
%let prior_term=2228;*/
/*%let current_term=2238;
%let prior_term=2235;*/
/*%let current_term=2242;
%let prior_term=2238;*/
/*%let current_term=2245;
%let prior_term=2242;*/
/*%let current_term=2248;
%let prior_term=2245;
%let current_term=2255;
%let prior_term=2252;
%let current_term=2258;
%let prior_term=2255;*/

%let current_term=2262;
%let prior_term=2258;

proc sql ;
create table work.CBM008_Term as

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


create table work.CBM008_TermDimension_Manual as
select
CBM008_Term.STRM,
CBM008_Term.TERM_BEGIN_DT,
CBM008_Term.TERM_END_DT,
CBM008_Term.TERM_SK,
CBM008_Term.CENSUS_DT,
CBM008_Term.Current_Term,
CBM008_Term.ACAD_CAREER,
MAX(CBM008_Term.TERM_END_DT) as Current_Term_End_Date
from
work.CBM008_Term as CBM008_Term
group by
CBM008_Term.ACAD_CAREER
;
quit;
/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            UNIQ_STRM                             A5B29B8Q.BZ0005NC *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 * Target Table:    UNIQ_STRM_CBM008 -                    A5B29B8Q.BS0001S9 *
 *                   work.UNIQ_STRM_CBM008                                  *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NC);

%let SYSLAST = %nrquote(ADWTGTPR.ADW_TERM_DIM);

proc sql;
   create view work.UNIQ_STRM_CBM008 as
   select distinct
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_TERM_DIM.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      ADW_TERM_DIM.ACAD_YEAR+1

      /*case
      when substr(ADW_TERM_DIM.STRM ,4,1) in ('2','5') then ADW_TERM_DIM.ACAD_YEAR +1
      when substr(ADW_TERM_DIM.STRM ,4,1)='8' then ADW_TERM_DIM.ACAD_YEAR
      else -99
      end*/ as UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      SUBSTR(ADW_TERM_DIM.STRM,4,1) as CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      ADW_TERM_DIM.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADW_TERM_DIM.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      ADW_TERM_DIM.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
   ;
quit;

/*==========================================================================*
 * Step:            USER_INPUT_STRM                       A5B29B8Q.BZ0005ND *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    UNIQ_STRM_CBM008 -                    A5B29B8Q.BS0001S9 *
 *                   work.UNIQ_STRM_CBM008                                  *
 * Target Table:    USER_INPUT_STRM_CBM008 -              A5B29B8Q.BS0001SA *
 *                   work.USER_INPUT_STRM_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005ND);

%let SYSLAST = %nrquote(work.UNIQ_STRM_CBM008);

proc sql;
   create view work.USER_INPUT_STRM_CBM008 as
   select
      UNIQ_STRM_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      UNIQ_STRM_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      UNIQ_STRM_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      UNIQ_STRM_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      case UNIQ_STRM_CBM008.CBM_TERM
         when '2'
            then PUT(UNIQ_STRM_CBM008.UTSHARE_FISCAL_YEAR,4.)||'0116'
         when '5'
            then PUT(UNIQ_STRM_CBM008.UTSHARE_FISCAL_YEAR,4.)||'0601'
         when '8'
            then PUT(UNIQ_STRM_CBM008.ACAD_YEAR,4.)||'0901'
      else ''
      end as APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      case UNIQ_STRM_CBM008.CBM_TERM
         when '2'
            then PUT(UNIQ_STRM_CBM008.UTSHARE_FISCAL_YEAR,4.)||'0531'
         when '5'
            then PUT(UNIQ_STRM_CBM008.UTSHARE_FISCAL_YEAR,4.)||'0831'
         when '8'
            then PUT(UNIQ_STRM_CBM008.ACAD_YEAR+1,4.)||'0115'
      else ''
      end as APPT_END_DT length = 8
         label = 'APPT_END_DT',
      UNIQ_STRM_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      UNIQ_STRM_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      PUT(INPUT(UNIQ_STRM_CBM008.STRM,BEST8.)-
      IFN(SUBSTR(UNIQ_STRM_CBM008.STRM,4,1)='2',4,3)-
      IFN(UNIQ_STRM_CBM008.STRM='2002',1000,0),4.) as STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      UNIQ_STRM_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.UNIQ_STRM_CBM008 as UNIQ_STRM_CBM008
   where
      UNIQ_STRM_CBM008.STRM = "&current_term"
   ;
quit;

/*==========================================================================*
 * Step:            READ_CLASS_ISNTR_TBL                  A5B29B8Q.BZ0005NE *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   USER_INPUT_STRM_CBM008 -              A5B29B8Q.BS0001SA *
 *                   work.USER_INPUT_STRM_CBM008                            *
 *                  PS_CLASS_INSTR_Extract -              A5B29B8Q.BE00002S *
 *                   ADWSTGPR.PS_CLASS_INSTR_Extract                        *
 * Target Table:    READ_CLASS_ISNTR_TBL_CBM008 -         A5B29B8Q.BS0001SB *
 *                   work.W6KESQEL                                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NE);

proc sql;
   create table work.W6KESQEL as
   select distinct
      PS_CLASS_INSTR_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_CLASS_INSTR_Extract.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      USER_INPUT_STRM_CBM008.STRM as IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      USER_INPUT_STRM_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      USER_INPUT_STRM_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      USER_INPUT_STRM_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      USER_INPUT_STRM_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      USER_INPUT_STRM_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      USER_INPUT_STRM_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      USER_INPUT_STRM_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      USER_INPUT_STRM_CBM008.STRM_PREV as IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      USER_INPUT_STRM_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      ADWSTGPR.PS_CLASS_INSTR_Extract as PS_CLASS_INSTR_Extract inner join
      work.USER_INPUT_STRM_CBM008 as USER_INPUT_STRM_CBM008
         on
         (
            PS_CLASS_INSTR_Extract.STRM = USER_INPUT_STRM_CBM008.STRM
            or (PS_CLASS_INSTR_Extract.STRM = USER_INPUT_STRM_CBM008.STRM_PREV
            and PS_CLASS_INSTR_Extract.SESSION_CODE = IFC(SUBSTR(PS_CLASS_INSTR_Extract.STRM,4,1)='5','5W2','1'))
         )
   where
      PS_CLASS_INSTR_Extract.EMPLID NOT IS MISSING
      and PS_CLASS_INSTR_Extract.ASSIGN_TYPE NOT IN ('EXC','NON')
   ;
quit;

/*==========================================================================*
 * Step:            HRA_FISCAL_YEAR                       A5B29B8Q.BZ0005NF *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_UTA_HRA_TBL_Extract -              A5B29B8Q.BE00007I *
 *                   ADWSTGPR.PS_UTA_HRA_TBL_Extract                        *
 *                  USER_INPUT_STRM_CBM008 -              A5B29B8Q.BS0001SA *
 *                   work.USER_INPUT_STRM_CBM008                            *
 * Target Table:    HRA_FISCAL_YEAR_CBM008 -              A5B29B8Q.BS0001SC *
 *                   work.HRA_FISCAL_YEAR_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NF);

proc sql;
   create table work.HRA_FISCAL_YEAR_CBM008 as
   select
      PS_UTA_HRA_TBL_Extract.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      PS_UTA_HRA_TBL_Extract.UTA_HRA_FISCALYEAR length = 8
         label = 'UTA_HRA_FISCALYEAR',
      USER_INPUT_STRM_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      USER_INPUT_STRM_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      USER_INPUT_STRM_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      PS_UTA_HRA_TBL_Extract.UTA_HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRA_BEGIN_DT',
      PS_UTA_HRA_TBL_Extract.UTA_HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRA_END_DT',
      PS_UTA_HRA_TBL_Extract.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      USER_INPUT_STRM_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      PS_UTA_HRA_TBL_Extract.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      USER_INPUT_STRM_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      USER_INPUT_STRM_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      USER_INPUT_STRM_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      PS_UTA_HRA_TBL_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      USER_INPUT_STRM_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      ADWSTGPR.PS_UTA_HRA_TBL_Extract as PS_UTA_HRA_TBL_Extract inner join
      work.USER_INPUT_STRM_CBM008 as USER_INPUT_STRM_CBM008
         on
         (
            PS_UTA_HRA_TBL_Extract.UTA_HRA_FISCALYEAR = USER_INPUT_STRM_CBM008.ACAD_YEAR
         )
   where
      PS_UTA_HRA_TBL_Extract.UTA_HRA_END_DT <> '00000000'
      and PS_UTA_HRA_TBL_Extract.UTA_HRA_TITLE_CD < '0115'
   ;
quit;

/*==========================================================================*
 * Step:            HRE_UNIQ_SSN                          A5B29B8Q.BZ0005NG *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_UTA_HRE_TBL_Extract -              A5B29B8Q.BE00007J *
 *                   ADWSTGPR.PS_UTA_HRE_TBL_Extract                        *
 * Target Table:    HRE_UNIQ_SSN_CBM008 -                 A5B29B8Q.BS0001SD *
 *                   work.HRE_UNIQ_SSN_CBM008                               *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NG);

%let SYSLAST = %nrquote(ADWSTGPR.PS_UTA_HRE_TBL_Extract);

proc sql;
   create table work.HRE_UNIQ_SSN_CBM008 as
   select distinct
      PS_UTA_HRE_TBL_Extract.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN'
   from
      ADWSTGPR.PS_UTA_HRE_TBL_Extract as PS_UTA_HRE_TBL_Extract
   ;
quit;

/*==========================================================================*
 * Step:            CHECK_ID_CHANGE                       A5B29B8Q.BZ0005NH *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_UTA_HRE_TBL_Extract -              A5B29B8Q.BE00007J *
 *                   ADWSTGPR.PS_UTA_HRE_TBL_Extract                        *
 *                  HRE_UNIQ_SSN_CBM008 -                 A5B29B8Q.BS0001SD *
 *                   work.HRE_UNIQ_SSN_CBM008                               *
 * Target Table:    CHECK_ID_CHANGE_CBM008 -              A5B29B8Q.BS0001SE *
 *                   work.CHECK_ID_CHANGE_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NH);

proc sql;
   create table work.CHECK_ID_CHANGE_CBM008 as
   select
      PS_UTA_HRE_TBL_Extract.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      PS_UTA_HRE_TBL_Extract.UTA_HR_SOURCE length = 10
         format = $10.
         informat = $10.
         label = 'UTA_HR_SOURCE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_NAME length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_NAME_FML length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_FML',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_PRIOR_SSN length = 9
         format = $9.
         informat = $9.
         label = 'UTA_HRE_PRIOR_SSN',
      PS_UTA_HRE_TBL_Extract.STREET1 length = 30
         format = $30.
         informat = $30.
         label = 'STREET1',
      PS_UTA_HRE_TBL_Extract.STREET2 length = 30
         format = $30.
         informat = $30.
         label = 'STREET2',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CITY length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_CITY',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_STATE length = 2
         format = $2.
         informat = $2.
         label = 'UTA_HRE_STATE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_ZIPCODE length = 11
         format = $11.
         informat = $11.
         label = 'UTA_HRE_ZIPCODE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_HOME_PHONE length = 10
         format = $10.
         informat = $10.
         label = 'UTA_HRE_HOME_PHONE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CAMPUS_BOX length = 5
         format = $5.
         informat = $5.
         label = 'UTA_HRE_CAMPUS_BOX',
      PS_UTA_HRE_TBL_Extract.DEPTNAME length = 30
         format = $30.
         informat = $30.
         label = 'DEPTNAME',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CAMPUSBLDG length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_CAMPUSBLDG',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CAMPUS_RM length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRE_CAMPUS_RM',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CAMPUS_PH length = 10
         format = $10.
         informat = $10.
         label = 'UTA_HRE_CAMPUS_PH',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_EMAIL length = 50
         format = $50.
         informat = $50.
         label = 'UTA_HRE_EMAIL',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_UT_EID length = 15
         format = $15.
         informat = $15.
         label = 'UTA_HRE_UT_EID',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CAMPUS_FAX length = 10
         format = $10.
         informat = $10.
         label = 'UTA_HRE_CAMPUS_FAX',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_ADDR_SW length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_ADDR_SW',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_TELE_SW length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_TELE_SW',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_ETHNIC_CD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_ETHNIC_CD',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_USCIT length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_USCIT',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_EDUC_LEVEL length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_EDUC_LEVEL',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_TENURE length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_TENURE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_LONGEVITY length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_LONGEVITY',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_LONG_SVCMO length = 8
         label = 'UTA_HRE_LONG_SVCMO',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CNTSVC_MOS length = 8
         label = 'UTA_HRE_CNTSVC_MOS',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_ST_SVCMO length = 8
         label = 'UTA_HRE_ST_SVCMO',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_TERM_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_TERM_DATE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_PCTTIMETOT length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRE_PCTTIMETOT',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_PCT_IND length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_PCT_IND',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_BRP_STAT length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_BRP_STAT',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_BRP_AMT length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRE_BRP_AMT',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_IMM_EXP_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_IMM_EXP_DT',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_BRP_RATE length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRE_BRP_RATE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_RET_CD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_RET_CD',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_PREVMAJTTL length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_PREVMAJTTL',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_COMPSTSVCM length = 8
         label = 'UTA_HRE_COMPSTSVCM',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_OCOMPSVCMO length = 8
         label = 'UTA_HRE_OCOMPSVCMO',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_OAGCYSVCMO length = 8
         label = 'UTA_HRE_OAGCYSVCMO',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_ASOFDATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_ASOFDATE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_NAME_UPD length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_NAME_UPD',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_HMADDRUPD length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_HMADDRUPD',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CAMPADRUPD length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CAMPADRUPD',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CEMAIL_UPD length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CEMAIL_UPD',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_ETH_UPD length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_ETH_UPD',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'UTA_HRE_EMPLID',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_STREET1_UL length = 30
         format = $30.
         informat = $30.
         label = 'UTA_HRE_STREET1_UL',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_STREET2_UL length = 30
         format = $30.
         informat = $30.
         label = 'UTA_HRE_STREET2_UL',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CITY_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_CITY_UL',
      PS_UTA_HRE_TBL_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      IFC(HRE_UNIQ_SSN_CBM008.SSN NOT IS MISSING,'Y','N') as FOUND_NEWID length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_NEWID'
   from
      ADWSTGPR.PS_UTA_HRE_TBL_Extract as PS_UTA_HRE_TBL_Extract left join
      work.HRE_UNIQ_SSN_CBM008 as HRE_UNIQ_SSN_CBM008
         on
         (
            PS_UTA_HRE_TBL_Extract.UTA_HRE_PRIOR_SSN = HRE_UNIQ_SSN_CBM008.SSN
         )
   ;
quit;

/*==========================================================================*
 * Step:            PROCESS_HRE_FILE                      A5B29B8Q.BZ0005NI *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    CHECK_ID_CHANGE_CBM008 -              A5B29B8Q.BS0001SE *
 *                   work.CHECK_ID_CHANGE_CBM008                            *
 * Target Table:    PROCESS_HRE_FILE_CBM008 -             A5B29B8Q.BS0001SF *
 *                   work.PROCESS_HRE_FILE_CBM008                           *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NI);

%let SYSLAST = %nrquote(work.CHECK_ID_CHANGE_CBM008);

proc sql;
   create table work.PROCESS_HRE_FILE_CBM008 as
   select
      CHECK_ID_CHANGE_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      CHECK_ID_CHANGE_CBM008.UTA_HRE_PRIOR_SSN length = 9
         format = $9.
         informat = $9.
         label = 'UTA_HRE_PRIOR_SSN',
      CHECK_ID_CHANGE_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      CHECK_ID_CHANGE_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      CHECK_ID_CHANGE_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      CHECK_ID_CHANGE_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      CHECK_ID_CHANGE_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      CHECK_ID_CHANGE_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      CHECK_ID_CHANGE_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS'
   from
      work.CHECK_ID_CHANGE_CBM008 as CHECK_ID_CHANGE_CBM008
   where
      CHECK_ID_CHANGE_CBM008.UTA_HRE_NAME NOT IS MISSING
      and CHECK_ID_CHANGE_CBM008.UTA_HRE_CNT_SVC_DT NOT IS MISSING
      and CHECK_ID_CHANGE_CBM008.UTA_HRE_STATUS IN ('8','R','A')
      and CHECK_ID_CHANGE_CBM008.FOUND_NEWID = 'N'
      and (CHECK_ID_CHANGE_CBM008.UTA_HRE_NAME_UL NOT CONTAINS '*'
      or UPCASE(CHECK_ID_CHANGE_CBM008.UTA_HRE_NAME_UL) NOT CONTAINS 'DO NOT')
   ;
quit;

/*==========================================================================*
 * Step:            READ_HRA_TITLE_CD                     A5B29B8Q.BZ0005NJ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PROCESS_HRE_FILE_CBM008 -             A5B29B8Q.BS0001SF *
 *                   work.PROCESS_HRE_FILE_CBM008                           *
 *                  HRA_FISCAL_YEAR_CBM008 -              A5B29B8Q.BS0001SC *
 *                   work.HRA_FISCAL_YEAR_CBM008                            *
 * Target Table:    READ_HRA_TITLE_CD_CBM008 -            A5B29B8Q.BS0001SG *
 *                   work.READ_HRA_TITLE_CD_CBM008                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NJ);

proc sql;
   create table work.READ_HRA_TITLE_CD_CBM008 as
   select distinct
      PROCESS_HRE_FILE_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      PROCESS_HRE_FILE_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      PROCESS_HRE_FILE_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      PROCESS_HRE_FILE_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      PROCESS_HRE_FILE_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      PROCESS_HRE_FILE_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      PROCESS_HRE_FILE_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      PROCESS_HRE_FILE_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      HRA_FISCAL_YEAR_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'UTA_HRA_FISCALYEAR',
      HRA_FISCAL_YEAR_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      HRA_FISCAL_YEAR_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      HRA_FISCAL_YEAR_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      HRA_FISCAL_YEAR_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      HRA_FISCAL_YEAR_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      HRA_FISCAL_YEAR_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      HRA_FISCAL_YEAR_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      HRA_FISCAL_YEAR_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      HRA_FISCAL_YEAR_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      HRA_FISCAL_YEAR_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      HRA_FISCAL_YEAR_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.PROCESS_HRE_FILE_CBM008 as PROCESS_HRE_FILE_CBM008 inner join
      work.HRA_FISCAL_YEAR_CBM008 as HRA_FISCAL_YEAR_CBM008
         on
         (
            PROCESS_HRE_FILE_CBM008.SSN = HRA_FISCAL_YEAR_CBM008.SSN
         )
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005NK *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_HRA_TITLE_CD_CBM008 -            A5B29B8Q.BS0001SG *
 *                   work.READ_HRA_TITLE_CD_CBM008                          *
 *                  PS_UTA_CB8_SAL_FTE_Extract -          A5B29B8Q.BE00006Z *
 *                   ADWSTGPR.PS_UTA_CB8_SAL_FTE_Extract                    *
 * Target Table:    Join - work.WD9EAXJT                  A5B29B8Q.BS0001SH *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NK);

proc sql;
   create view work.WD9EAXJT as
   select
      READ_HRA_TITLE_CD_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_HRA_TITLE_CD_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_HRA_TITLE_CD_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      READ_HRA_TITLE_CD_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_HRA_TITLE_CD_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_HRA_TITLE_CD_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_HRA_TITLE_CD_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_HRA_TITLE_CD_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_HRA_TITLE_CD_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'UTA_HRA_FISCALYEAR',
      READ_HRA_TITLE_CD_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_HRA_TITLE_CD_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_HRA_TITLE_CD_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_HRA_TITLE_CD_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      READ_HRA_TITLE_CD_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_HRA_TITLE_CD_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_HRA_TITLE_CD_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_HRA_TITLE_CD_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      READ_HRA_TITLE_CD_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      READ_HRA_TITLE_CD_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      PS_UTA_CB8_SAL_FTE_Extract.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      PS_UTA_CB8_SAL_FTE_Extract.DEPTID length = 10
         format = $10.
         informat = $10.
         label = 'DEPTID',
      PS_UTA_CB8_SAL_FTE_Extract.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      PS_UTA_CB8_SAL_FTE_Extract.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      IFC(PS_UTA_CB8_SAL_FTE_Extract.EMPLID NOT IS MISSING,'Y','N') as FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      READ_HRA_TITLE_CD_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.READ_HRA_TITLE_CD_CBM008 as READ_HRA_TITLE_CD_CBM008 left join
      ADWSTGPR.PS_UTA_CB8_SAL_FTE_Extract as PS_UTA_CB8_SAL_FTE_Extract
         on
         (
            READ_HRA_TITLE_CD_CBM008.EMPLID = PS_UTA_CB8_SAL_FTE_Extract.EMPLID
            and READ_HRA_TITLE_CD_CBM008.STRM = PS_UTA_CB8_SAL_FTE_Extract.STRM
         )
   where
      PS_UTA_CB8_SAL_FTE_Extract.EMPLID not is missing
   ;
quit;

/*==========================================================================*
 * Step:            READ_PERS_NID_INSTR                   A5B29B8Q.BZ0005NL *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_PERS_NID_Extract -                 A5B29B8Q.BE00000R *
 *                   ADWSTGPR.PS_PERS_NID_Extract                           *
 *                  READ_CLASS_ISNTR_TBL_CBM008 -         A5B29B8Q.BS0001SB *
 *                   work.W6KESQEL                                          *
 * Target Table:    READ_PERS_NID_INSTR_CBM008 -          A5B29B8Q.BS0001SI *
 *                   work.W6KESOPX                                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NL);

proc sql;
   create table work.W6KESOPX as
   select
      W6KESQEL.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESQEL.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESQEL.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESQEL.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESQEL.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESQEL.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESQEL.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESQEL.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESQEL.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESQEL.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESQEL.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESQEL.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      PS_PERS_NID_Extract.NATIONAL_ID as HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID'
   from
      work.W6KESQEL as W6KESQEL left join
      ADWSTGPR.PS_PERS_NID_Extract as PS_PERS_NID_Extract
         on
         (
            PS_PERS_NID_Extract.NATIONAL_ID_TYPE = 'PR'
            and PS_PERS_NID_Extract.COUNTRY = 'USA'
            and W6KESQEL.EMPLID = PS_PERS_NID_Extract.EMPLID
            and PS_PERS_NID_Extract.NATIONAL_ID NOT IN ('999999999','999-99-9999','XXXXXXXXX','XXX-XX-XXXX')
         )
   ;
quit;

/*==========================================================================*
 * Step:            UNIQ_NATL_ID_MAX_ASOF                 A5B29B8Q.BZ0005NM *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_UTA_HR_PS_EMP_Extract -            A5B29B8Q.BE00007G *
 *                   ADWSTGPR.PS_UTA_HR_PS_EMP_Extract                      *
 * Target Table:    UNIQ_NATL_ID_MAX_ASOF_CBM008 -        A5B29B8Q.BS0001SJ *
 *                   work.W6KESPK9                                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NM);

%let SYSLAST = %nrquote(ADWSTGPR.PS_UTA_HR_PS_EMP_Extract);

proc sql;
   create view work.W6KESPK9 as
   select distinct
      PS_UTA_HR_PS_EMP_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_UTA_HR_PS_EMP_Extract.NATIONAL_ID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID'
   from
      ADWSTGPR.PS_UTA_HR_PS_EMP_Extract as PS_UTA_HR_PS_EMP_Extract
   group by
      PS_UTA_HR_PS_EMP_Extract.EMPLID
   having
      PS_UTA_HR_PS_EMP_Extract.UTA_HR_ASOFDATE = MAX(PS_UTA_HR_PS_EMP_Extract.UTA_HR_ASOFDATE)
   ;
quit;

/*==========================================================================*
 * Step:            READ_EXT_SYS_HRS_INSTR                A5B29B8Q.BZ0005NN *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_PERS_NID_INSTR_CBM008 -          A5B29B8Q.BS0001SI *
 *                   work.W6KESOPX                                          *
 *                  UNIQ_NATL_ID_MAX_ASOF_CBM008 -        A5B29B8Q.BS0001SJ *
 *                   work.W6KESPK9                                          *
 * Target Table:    READ_EXT_SYS_HRS_INSTR_CBM008 -       A5B29B8Q.BS0001SK *
 *                   work.W6KESM6X                                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NN);

proc sql;
   create table work.W6KESM6X as
   select
      W6KESOPX.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESOPX.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESOPX.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESOPX.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESOPX.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESOPX.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESOPX.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESOPX.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESOPX.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESOPX.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESOPX.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESOPX.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESPK9.NATIONAL_ID as HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      IFC(W6KESPK9.NATIONAL_ID NOT IS MISSING,
      STRIP(W6KESPK9.NATIONAL_ID),
      STRIP(W6KESOPX.HRS_ID_NID)) as HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESOPX.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESOPX as W6KESOPX left join
      work.W6KESPK9 as W6KESPK9
         on
         (
            W6KESOPX.HRS_ID_NID IS MISSING
            and W6KESOPX.EMPLID = W6KESPK9.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            GET_A_CRSE_ID_INSTR                   A5B29B8Q.BZ0005NO *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_EXT_SYS_HRS_INSTR_CBM008 -       A5B29B8Q.BS0001SK *
 *                   work.W6KESM6X                                          *
 *                  PS_CLASS_INSTR_Extract -              A5B29B8Q.BE00002S *
 *                   ADWSTGPR.PS_CLASS_INSTR_Extract                        *
 * Target Table:    GET_A_CRSE_ID_INSTR_CBM008 -          A5B29B8Q.BS0001SL *
 *                   work.W6KESITM                                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NO);

proc sql;
   create table work.W6KESITM as
   select
      W6KESM6X.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESM6X.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      "" as FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESM6X.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESM6X.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESM6X.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESM6X.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESM6X.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESM6X.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESM6X.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESM6X.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESM6X.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESM6X.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESM6X.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESM6X.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      PS_CLASS_INSTR_Extract.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      PS_CLASS_INSTR_Extract.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      PS_CLASS_INSTR_Extract.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      PS_CLASS_INSTR_Extract.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      PS_CLASS_INSTR_Extract.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      PS_CLASS_INSTR_Extract.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      PS_CLASS_INSTR_Extract.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_CLASS_INSTR_Extract.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      PS_CLASS_INSTR_Extract.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      PS_CLASS_INSTR_Extract.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      PS_CLASS_INSTR_Extract.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      PS_CLASS_INSTR_Extract.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      PS_CLASS_INSTR_Extract.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      PS_CLASS_INSTR_Extract.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      PS_CLASS_INSTR_Extract.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      PS_CLASS_INSTR_Extract.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      W6KESM6X.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESM6X as W6KESM6X left join
      ADWSTGPR.PS_CLASS_INSTR_Extract as PS_CLASS_INSTR_Extract
         on
         (
            PS_CLASS_INSTR_Extract.ASSIGN_TYPE NOT IN ('EXC','NON')
            and W6KESM6X.EMPLID = PS_CLASS_INSTR_Extract.EMPLID
            and (W6KESM6X.IN_STRM = PS_CLASS_INSTR_Extract.STRM
            or PUT(INPUT(W6KESM6X.IN_STRM,BEST8.)-
            IFN(SUBSTR(W6KESM6X.IN_STRM,4,1)='2',4,3)-
            IFN(W6KESM6X.IN_STRM='2002',1000,0),4.) = PS_CLASS_INSTR_Extract.STRM)
         )
   group by
      W6KESM6X.EMPLID,
      W6KESM6X.IN_STRM
   having
      PS_CLASS_INSTR_Extract.STRM = MAX(PS_CLASS_INSTR_Extract.STRM)
   ;
quit;

/*==========================================================================*
 * Step:            MISSING_HRS_ID                        A5B29B8Q.BZ0005NP *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    GET_A_CRSE_ID_INSTR_CBM008 -          A5B29B8Q.BS0001SL *
 *                   work.W6KESITM                                          *
 * Target Table:    MISSING_HRS_ID_CBM008 - work.W6KESJNX A5B29B8Q.BS0001SM *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NP);

%let SYSLAST = %nrquote(work.W6KESITM);

proc sql;
   create view work.W6KESJNX as
   select
      W6KESITM.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESITM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESITM.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESITM.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESITM.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESITM.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESITM.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESITM.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESITM.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESITM.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESITM.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESITM.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESITM.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESITM.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESITM.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESITM.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6KESITM.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6KESITM.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6KESITM.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6KESITM.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6KESITM.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6KESITM.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6KESITM.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6KESITM.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6KESITM.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6KESITM.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6KESITM.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6KESITM.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6KESITM.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6KESITM.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6KESITM.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      W6KESITM.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESITM as W6KESITM
   where
      W6KESITM.HRS_ID IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            FOUND_HRS_ID                          A5B29B8Q.BZ0005NQ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    GET_A_CRSE_ID_INSTR_CBM008 -          A5B29B8Q.BS0001SL *
 *                   work.W6KESITM                                          *
 * Target Table:    FOUND_HRS_ID_CBM008 - work.W6KESN19   A5B29B8Q.BS0001SN *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NQ);

%let SYSLAST = %nrquote(work.W6KESITM);

proc sql;
   create view work.W6KESN19 as
   select
      W6KESITM.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESITM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESITM.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESITM.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESITM.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESITM.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESITM.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESITM.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESITM.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESITM.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESITM.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESITM.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESITM.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESITM.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESITM.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESITM.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6KESITM.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6KESITM.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6KESITM.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6KESITM.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6KESITM.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6KESITM.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6KESITM.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6KESITM.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6KESITM.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6KESITM.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6KESITM.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6KESITM.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6KESITM.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6KESITM.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6KESITM.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      W6KESITM.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESITM as W6KESITM
   where
      W6KESITM.HRS_ID NOT IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            READ_HRE_2                            A5B29B8Q.BZ0005NR *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   FOUND_HRS_ID_CBM008 - work.W6KESN19   A5B29B8Q.BS0001SN *
 *                  PS_UTA_HRE_TBL_Extract -              A5B29B8Q.BE00007J *
 *                   ADWSTGPR.PS_UTA_HRE_TBL_Extract                        *
 * Target Table:    READ_HRE_2_CBM008 - work.W6KESNVL     A5B29B8Q.BS0001SO *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NR);

proc sql;
   create table work.W6KESNVL as
   select
      W6KESN19.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESN19.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESN19.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESN19.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESN19.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESN19.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESN19.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESN19.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESN19.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESN19.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESN19.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESN19.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESN19.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESN19.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESN19.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESN19.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6KESN19.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6KESN19.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6KESN19.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6KESN19.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6KESN19.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6KESN19.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6KESN19.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6KESN19.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6KESN19.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6KESN19.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6KESN19.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6KESN19.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6KESN19.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6KESN19.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6KESN19.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      '1' as FACULTY_COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_COMPLIANCE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_NAME length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME',
      PS_UTA_HRE_TBL_Extract.SSN as HRE_SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      '1' as COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      PS_UTA_HRE_TBL_Extract.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      W6KESN19.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESN19 as W6KESN19 left join
      ADWSTGPR.PS_UTA_HRE_TBL_Extract as PS_UTA_HRE_TBL_Extract
         on
         (
            W6KESN19.HRS_ID = PS_UTA_HRE_TBL_Extract.SSN
         )
   where
      PS_UTA_HRE_TBL_Extract.UTA_HRE_NAME_UL NOT CONTAINS '*'
      or UPCASE(PS_UTA_HRE_TBL_Extract.UTA_HRE_NAME_UL) NOT CONTAINS 'DO NOT'
   ;
quit;

/*==========================================================================*
 * Step:            DECODE_TITLE_CODE_INSTR               A5B29B8Q.BZ0005NS *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    READ_HRE_2_CBM008 - work.W6KESNVL     A5B29B8Q.BS0001SO *
 * Target Table:    DECODE_TITLE_CODE_INSTR_CBM008 -      A5B29B8Q.BS0001SP *
 *                   work.W6KESH4X                                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NS);

%let SYSLAST = %nrquote(work.W6KESNVL);

proc sql;
   create table work.W6KESH4X as
   select
      W6KESNVL.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESNVL.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESNVL.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESNVL.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESNVL.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESNVL.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESNVL.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESNVL.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESNVL.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESNVL.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESNVL.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESNVL.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESNVL.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESNVL.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESNVL.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESNVL.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6KESNVL.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6KESNVL.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6KESNVL.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6KESNVL.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6KESNVL.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6KESNVL.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6KESNVL.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6KESNVL.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6KESNVL.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6KESNVL.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6KESNVL.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6KESNVL.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6KESNVL.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6KESNVL.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6KESNVL.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      W6KESNVL.FACULTY_COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_COMPLIANCE',
      W6KESNVL.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0006','0007','0008','0009','0010'),'PROF',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE='0000','EMRT',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN ('0011','0013',
      '0014','0015','0021','0024','0025','0034','0035','0044','0045','0047','0056','0029'),
      'ADJ',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN ('0012','0022','0032'),
      'VPRF',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0016','0017','0018','0019','0020'),'ASSC',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0027','0028','0030','0031'),'ASST',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0040','0041'),'INST',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0049','0050','0051'),'LECT',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE='0096','UNDF',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE>'0062' &
      W6KESNVL.UTA_HRE_MAJORTITLE<'0096','TA','')))))))))) as INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0006','0007','0008','0009','0010'),'1',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0000','0011','0013',
      '0014','0015','0021','0024','0025','0034','0035','0044','0045','0047','0056','0029',
      '0012','0022','0032','0049','0050','0051','0096'),'5',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0016','0017','0018','0019','0020'),'2',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0027','0028','0030','0031'),'3',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE IN
      ('0040','0041'),'4',
      IFC(W6KESNVL.UTA_HRE_MAJORTITLE>'0062' &
      W6KESNVL.UTA_HRE_MAJORTITLE<'0096','6','')))))) as FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      W6KESNVL.HRE_SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      W6KESNVL.UTA_HRE_NAME length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME',
      W6KESNVL.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      W6KESNVL.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      W6KESNVL.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      W6KESNVL.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      W6KESNVL.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      W6KESNVL.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6KESNVL.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      W6KESNVL.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESNVL as W6KESNVL
   ;
quit;

/*==========================================================================*
 * Step:            MISSING_HRE_SSN                       A5B29B8Q.BZ0005NT *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    DECODE_TITLE_CODE_INSTR_CBM008 -      A5B29B8Q.BS0001SP *
 *                   work.W6KESH4X                                          *
 * Target Table:    MISSING_HRE_SSN_CBM008 -              A5B29B8Q.BS0001SQ *
 *                   work.W6KESHZ9                                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NT);

%let SYSLAST = %nrquote(work.W6KESH4X);

proc sql;
   create view work.W6KESHZ9 as
   select
      W6KESH4X.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESH4X.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESH4X.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESH4X.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESH4X.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESH4X.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESH4X.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESH4X.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESH4X.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESH4X.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESH4X.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESH4X.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESH4X.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESH4X.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESH4X.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESH4X.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6KESH4X.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6KESH4X.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6KESH4X.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6KESH4X.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6KESH4X.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6KESH4X.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6KESH4X.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6KESH4X.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6KESH4X.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6KESH4X.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6KESH4X.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6KESH4X.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6KESH4X.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6KESH4X.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6KESH4X.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      W6KESH4X.FACULTY_COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_COMPLIANCE',
      W6KESH4X.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6KESH4X.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESH4X as W6KESH4X
   where
      W6KESH4X.HRE_SSN IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            Set Operators                         A5B29B8Q.BZ0005NU *
 * Transform:       Set Operators                                           *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   MISSING_HRS_ID_CBM008 - work.W6KESJNX A5B29B8Q.BS0001SM *
 *                  MISSING_HRE_SSN_CBM008 -              A5B29B8Q.BS0001SQ *
 *                   work.W6KESHZ9                                          *
 * Target Table:    Set Operators - work.W6UNQ4OB         A5B29B8Q.BS0001SR *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NU);

proc sql;
   create table work.W6UNQ4OB as
   /* Returns all unique rows from the two query results.  */
   select
      W6KESJNX.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESJNX.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESJNX.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESJNX.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESJNX.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESJNX.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESJNX.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESJNX.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESJNX.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESJNX.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESJNX.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESJNX.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESJNX.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESJNX.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESJNX.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESJNX.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6KESJNX.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6KESJNX.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6KESJNX.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6KESJNX.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6KESJNX.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6KESJNX.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6KESJNX.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6KESJNX.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6KESJNX.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6KESJNX.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6KESJNX.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6KESJNX.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6KESJNX.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6KESJNX.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6KESJNX.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      '9'||SUBSTR(W6KESJNX.EMPLID,3,8) as OUT_SSN length = 9
         format = $9.
         informat = $9.
         label = 'OUT_SSN',
      "" as COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6KESJNX.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESJNX
   union all
   select
      W6KESHZ9.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6KESHZ9.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESHZ9.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESHZ9.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESHZ9.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESHZ9.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESHZ9.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESHZ9.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESHZ9.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESHZ9.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESHZ9.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESHZ9.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESHZ9.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESHZ9.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESHZ9.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESHZ9.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6KESHZ9.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6KESHZ9.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6KESHZ9.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6KESHZ9.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6KESHZ9.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6KESHZ9.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6KESHZ9.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6KESHZ9.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6KESHZ9.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6KESHZ9.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6KESHZ9.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6KESHZ9.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6KESHZ9.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6KESHZ9.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6KESHZ9.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      W6KESHZ9.HRS_ID as OUT_SSN length = 9
         format = $9.
         informat = $9.
         label = 'OUT_SSN',
      W6KESHZ9.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6KESHZ9.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESHZ9
   ;
quit;

/*==========================================================================*
 * Step:            NAMES_MAX_EFFDT                       A5B29B8Q.BZ0005NV *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_NAMES_Extract -                    A5B29B8Q.BE00004K *
 *                   ADWSTGPR.PS_NAMES_Extract                              *
 * Target Table:    NAMES_MAX_EFFDT_CBM008 -              A5B29B8Q.BS0001SS *
 *                   work.NAMES_MAX_EFFDT_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NV);

%let SYSLAST = %nrquote(ADWSTGPR.PS_NAMES_Extract);

proc sql;
   create view work.NAMES_MAX_EFFDT_CBM008 as
   select
      PS_NAMES_Extract.COUNTRY_NM_FORMAT length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY_NM_FORMAT',
      PS_NAMES_Extract.EFF_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EFF_STATUS',
      PS_NAMES_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_NAMES_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_NAMES_Extract.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      PS_NAMES_Extract.FIRST_NAME_SRCH length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME_SRCH',
      PS_NAMES_Extract.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      PS_NAMES_Extract.LAST_NAME_PREF_NLD length = 1
         format = $1.
         informat = $1.
         label = 'LAST_NAME_PREF_NLD',
      PS_NAMES_Extract.LAST_NAME_SRCH length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME_SRCH',
      PS_NAMES_Extract.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      PS_NAMES_Extract.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      PS_NAMES_Extract.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      PS_NAMES_Extract.NAME length = 50
         format = $50.
         informat = $50.
         label = 'NAME',
      PS_NAMES_Extract.NAME_AC length = 50
         format = $50.
         informat = $50.
         label = 'NAME_AC',
      PS_NAMES_Extract.NAME_DISPLAY length = 50
         format = $50.
         informat = $50.
         label = 'NAME_DISPLAY',
      PS_NAMES_Extract.NAME_DISPLAY_SRCH length = 50
         format = $50.
         informat = $50.
         label = 'NAME_DISPLAY_SRCH',
      PS_NAMES_Extract.NAME_FORMAL length = 60
         format = $60.
         informat = $60.
         label = 'NAME_FORMAL',
      PS_NAMES_Extract.NAME_INITIALS length = 6
         format = $6.
         informat = $6.
         label = 'NAME_INITIALS',
      PS_NAMES_Extract.NAME_PREFIX length = 4
         format = $4.
         informat = $4.
         label = 'NAME_PREFIX',
      PS_NAMES_Extract.NAME_ROYAL_PREFIX length = 15
         format = $15.
         informat = $15.
         label = 'NAME_ROYAL_PREFIX',
      PS_NAMES_Extract.NAME_ROYAL_SUFFIX length = 15
         format = $15.
         informat = $15.
         label = 'NAME_ROYAL_SUFFIX',
      PS_NAMES_Extract.NAME_SUFFIX length = 15
         format = $15.
         informat = $15.
         label = 'NAME_SUFFIX',
      PS_NAMES_Extract.NAME_TITLE length = 30
         format = $30.
         informat = $30.
         label = 'NAME_TITLE',
      PS_NAMES_Extract.NAME_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'NAME_TYPE',
      PS_NAMES_Extract.PARTNER_LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'PARTNER_LAST_NAME',
      PS_NAMES_Extract.PARTNER_ROY_PREFIX length = 15
         format = $15.
         informat = $15.
         label = 'PARTNER_ROY_PREFIX',
      PS_NAMES_Extract.PREF_FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'PREF_FIRST_NAME',
      PS_NAMES_Extract.SECOND_LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'SECOND_LAST_NAME',
      PS_NAMES_Extract.SECOND_LAST_SRCH length = 30
         format = $30.
         informat = $30.
         label = 'SECOND_LAST_SRCH',
      IFN(PS_NAMES_Extract.NAME_TYPE='HRS',1,
      IFN(PS_NAMES_Extract.NAME_TYPE='PRI',2,3)) as ORDER length = 8
         label = 'ORDER'
   from
      ADWSTGPR.PS_NAMES_Extract as PS_NAMES_Extract
   where
      PS_NAMES_Extract.EFF_STATUS = 'A'
      and PS_NAMES_Extract.EFFDT <= DATETIME()
      and PS_NAMES_Extract.NAME_TYPE IN ('HRS','PRI','PRF')
   group by
      PS_NAMES_Extract.EMPLID,
      PS_NAMES_Extract.NAME_TYPE
   having
      PS_NAMES_Extract.EFFDT = MAX(PS_NAMES_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            NAMES_HRS_PRI_PRF                     A5B29B8Q.BZ0005NW *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    NAMES_MAX_EFFDT_CBM008 -              A5B29B8Q.BS0001SS *
 *                   work.NAMES_MAX_EFFDT_CBM008                            *
 * Target Table:    NAMES_HRS_PRI_PRF_CBM008 -            A5B29B8Q.BS0001ST *
 *                   work.NAMES_HRS_PRI_PRF_CBM008                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NW);

%let SYSLAST = %nrquote(work.NAMES_MAX_EFFDT_CBM008);

proc sql;
   create view work.NAMES_HRS_PRI_PRF_CBM008 as
   select
      NAMES_MAX_EFFDT_CBM008.COUNTRY_NM_FORMAT length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY_NM_FORMAT',
      NAMES_MAX_EFFDT_CBM008.EFF_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EFF_STATUS',
      NAMES_MAX_EFFDT_CBM008.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      NAMES_MAX_EFFDT_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      NAMES_MAX_EFFDT_CBM008.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      NAMES_MAX_EFFDT_CBM008.FIRST_NAME_SRCH length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME_SRCH',
      NAMES_MAX_EFFDT_CBM008.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      NAMES_MAX_EFFDT_CBM008.LAST_NAME_PREF_NLD length = 1
         format = $1.
         informat = $1.
         label = 'LAST_NAME_PREF_NLD',
      NAMES_MAX_EFFDT_CBM008.LAST_NAME_SRCH length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME_SRCH',
      NAMES_MAX_EFFDT_CBM008.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      NAMES_MAX_EFFDT_CBM008.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      NAMES_MAX_EFFDT_CBM008.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      NAMES_MAX_EFFDT_CBM008.NAME length = 50
         format = $50.
         informat = $50.
         label = 'NAME',
      NAMES_MAX_EFFDT_CBM008.NAME_AC length = 50
         format = $50.
         informat = $50.
         label = 'NAME_AC',
      NAMES_MAX_EFFDT_CBM008.NAME_DISPLAY length = 50
         format = $50.
         informat = $50.
         label = 'NAME_DISPLAY',
      NAMES_MAX_EFFDT_CBM008.NAME_DISPLAY_SRCH length = 50
         format = $50.
         informat = $50.
         label = 'NAME_DISPLAY_SRCH',
      NAMES_MAX_EFFDT_CBM008.NAME_FORMAL length = 60
         format = $60.
         informat = $60.
         label = 'NAME_FORMAL',
      NAMES_MAX_EFFDT_CBM008.NAME_INITIALS length = 6
         format = $6.
         informat = $6.
         label = 'NAME_INITIALS',
      NAMES_MAX_EFFDT_CBM008.NAME_PREFIX length = 4
         format = $4.
         informat = $4.
         label = 'NAME_PREFIX',
      NAMES_MAX_EFFDT_CBM008.NAME_ROYAL_PREFIX length = 15
         format = $15.
         informat = $15.
         label = 'NAME_ROYAL_PREFIX',
      NAMES_MAX_EFFDT_CBM008.NAME_ROYAL_SUFFIX length = 15
         format = $15.
         informat = $15.
         label = 'NAME_ROYAL_SUFFIX',
      NAMES_MAX_EFFDT_CBM008.NAME_SUFFIX length = 15
         format = $15.
         informat = $15.
         label = 'NAME_SUFFIX',
      NAMES_MAX_EFFDT_CBM008.NAME_TITLE length = 30
         format = $30.
         informat = $30.
         label = 'NAME_TITLE',
      NAMES_MAX_EFFDT_CBM008.NAME_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'NAME_TYPE',
      NAMES_MAX_EFFDT_CBM008.PARTNER_LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'PARTNER_LAST_NAME',
      NAMES_MAX_EFFDT_CBM008.PARTNER_ROY_PREFIX length = 15
         format = $15.
         informat = $15.
         label = 'PARTNER_ROY_PREFIX',
      NAMES_MAX_EFFDT_CBM008.PREF_FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'PREF_FIRST_NAME',
      NAMES_MAX_EFFDT_CBM008.SECOND_LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'SECOND_LAST_NAME',
      NAMES_MAX_EFFDT_CBM008.SECOND_LAST_SRCH length = 30
         format = $30.
         informat = $30.
         label = 'SECOND_LAST_SRCH'
   from
      work.NAMES_MAX_EFFDT_CBM008 as NAMES_MAX_EFFDT_CBM008
   group by
      NAMES_MAX_EFFDT_CBM008.EMPLID
   having
      NAMES_MAX_EFFDT_CBM008.ORDER = MIN(NAMES_MAX_EFFDT_CBM008.ORDER)
   ;
quit;

/*==========================================================================*
 * Step:            GET_NAMES                             A5B29B8Q.BZ0005NX *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Set Operators - work.W6UNQ4OB         A5B29B8Q.BS0001SR *
 *                  NAMES_HRS_PRI_PRF_CBM008 -            A5B29B8Q.BS0001ST *
 *                   work.NAMES_HRS_PRI_PRF_CBM008                          *
 * Target Table:    GET_NAMES_CBM008 -                    A5B29B8Q.BS0001SU *
 *                   work.GET_NAMES_CBM008                                  *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NX);

proc sql;
   create table work.GET_NAMES_CBM008 as
   select
      W6UNQ4OB.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W6UNQ4OB.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6UNQ4OB.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6UNQ4OB.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6UNQ4OB.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6UNQ4OB.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6UNQ4OB.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6UNQ4OB.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6UNQ4OB.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6UNQ4OB.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6UNQ4OB.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6UNQ4OB.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6UNQ4OB.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6UNQ4OB.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6UNQ4OB.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6UNQ4OB.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6UNQ4OB.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6UNQ4OB.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6UNQ4OB.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6UNQ4OB.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6UNQ4OB.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6UNQ4OB.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6UNQ4OB.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6UNQ4OB.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6UNQ4OB.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6UNQ4OB.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6UNQ4OB.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6UNQ4OB.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6UNQ4OB.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6UNQ4OB.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6UNQ4OB.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      W6UNQ4OB.OUT_SSN length = 9
         format = $9.
         informat = $9.
         label = 'OUT_SSN',
      NAMES_HRS_PRI_PRF_CBM008.NAME length = 50
         format = $50.
         informat = $50.
         label = 'NAME',
      NAMES_HRS_PRI_PRF_CBM008.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      NAMES_HRS_PRI_PRF_CBM008.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      NAMES_HRS_PRI_PRF_CBM008.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      W6UNQ4OB.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6UNQ4OB.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6UNQ4OB as W6UNQ4OB left join
      work.NAMES_HRS_PRI_PRF_CBM008 as NAMES_HRS_PRI_PRF_CBM008
         on
         (
            W6UNQ4OB.EMPLID = NAMES_HRS_PRI_PRF_CBM008.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            GET_DOB                               A5B29B8Q.BZ0005NY *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   GET_NAMES_CBM008 -                    A5B29B8Q.BS0001SU *
 *                   work.GET_NAMES_CBM008                                  *
 *                  PS_PERSON_Extract -                   A5B29B8Q.BE00004V *
 *                   ADWSTGPR.PS_PERSON_Extract                             *
 * Target Table:    GET_DOB_CBM008 - work.GET_DOB_CBM008  A5B29B8Q.BS0001SV *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NY);

proc sql;
   create table work.GET_DOB_CBM008 as
   select
      GET_NAMES_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      GET_NAMES_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      GET_NAMES_CBM008.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      GET_NAMES_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      GET_NAMES_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      GET_NAMES_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      GET_NAMES_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      GET_NAMES_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      GET_NAMES_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      GET_NAMES_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      GET_NAMES_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      GET_NAMES_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      GET_NAMES_CBM008.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      GET_NAMES_CBM008.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      GET_NAMES_CBM008.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      GET_NAMES_CBM008.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      GET_NAMES_CBM008.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      GET_NAMES_CBM008.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      GET_NAMES_CBM008.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      GET_NAMES_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      GET_NAMES_CBM008.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      GET_NAMES_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      GET_NAMES_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      GET_NAMES_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      GET_NAMES_CBM008.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      GET_NAMES_CBM008.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      GET_NAMES_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      GET_NAMES_CBM008.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      GET_NAMES_CBM008.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      GET_NAMES_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      GET_NAMES_CBM008.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      GET_NAMES_CBM008.OUT_SSN length = 9
         format = $9.
         informat = $9.
         label = 'OUT_SSN',
      GET_NAMES_CBM008.NAME length = 50
         format = $50.
         informat = $50.
         label = 'NAME',
      GET_NAMES_CBM008.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      GET_NAMES_CBM008.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      GET_NAMES_CBM008.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      PS_PERSON_Extract.BIRTHDATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTHDATE',
      GET_NAMES_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      GET_NAMES_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.GET_NAMES_CBM008 as GET_NAMES_CBM008 left join
      ADWSTGPR.PS_PERSON_Extract as PS_PERSON_Extract
         on
         (
            GET_NAMES_CBM008.EMPLID = PS_PERSON_Extract.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            PERS_DATA_MAX_EFFDT                   A5B29B8Q.BZ0005NZ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_PERS_DATA_EFFDT_Extract -          A5B29B8Q.BE00004R *
 *                   ADWSTGPR.PS_PERS_DATA_EFFDT_Extract                    *
 * Target Table:    PERS_DATA_MAX_EFFDT_CBM008 -          A5B29B8Q.BS0001SW *
 *                   work.PERS_DATA_MAX_EFFDT_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005NZ);

%let SYSLAST = %nrquote(ADWSTGPR.PS_PERS_DATA_EFFDT_Extract);

proc sql;
   create table work.PERS_DATA_MAX_EFFDT_CBM008 as
   select
      PS_PERS_DATA_EFFDT_Extract.ALTER_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'ALTER_EMPLID',
      PS_PERS_DATA_EFFDT_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_PERS_DATA_EFFDT_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_PERS_DATA_EFFDT_Extract.FT_STUDENT length = 1
         format = $1.
         informat = $1.
         label = 'FT_STUDENT',
      PS_PERS_DATA_EFFDT_Extract.HIGHEST_EDUC_LVL length = 2
         format = $2.
         informat = $2.
         label = 'HIGHEST_EDUC_LVL',
      PS_PERS_DATA_EFFDT_Extract.LANG_CD length = 3
         format = $3.
         informat = $3.
         label = 'LANG_CD',
      PS_PERS_DATA_EFFDT_Extract.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      PS_PERS_DATA_EFFDT_Extract.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      PS_PERS_DATA_EFFDT_Extract.MAR_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'MAR_STATUS',
      PS_PERS_DATA_EFFDT_Extract.MAR_STATUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'MAR_STATUS_DT',
      PS_PERS_DATA_EFFDT_Extract.SEX length = 1
         format = $1.
         informat = $1.
         label = 'SEX'
   from
      ADWSTGPR.PS_PERS_DATA_EFFDT_Extract as PS_PERS_DATA_EFFDT_Extract
   where
      PS_PERS_DATA_EFFDT_Extract.EFFDT <= DATETIME()
   group by
      PS_PERS_DATA_EFFDT_Extract.EMPLID
   having
      PS_PERS_DATA_EFFDT_Extract.EFFDT = MAX(PS_PERS_DATA_EFFDT_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            GET_GENDER                            A5B29B8Q.BZ0005O0 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   GET_DOB_CBM008 - work.GET_DOB_CBM008  A5B29B8Q.BS0001SV *
 *                  PERS_DATA_MAX_EFFDT_CBM008 -          A5B29B8Q.BS0001SW *
 *                   work.PERS_DATA_MAX_EFFDT_CBM008                        *
 * Target Table:    GET_GENDER_CBM008 -                   A5B29B8Q.BS0001SX *
 *                   work.GET_GENDER_CBM008                                 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O0);

proc sql;
   create table work.GET_GENDER_CBM008 as
   select
      GET_DOB_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      GET_DOB_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      GET_DOB_CBM008.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      GET_DOB_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      GET_DOB_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      GET_DOB_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      GET_DOB_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      GET_DOB_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      GET_DOB_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      GET_DOB_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      GET_DOB_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      GET_DOB_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      GET_DOB_CBM008.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      GET_DOB_CBM008.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      GET_DOB_CBM008.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      GET_DOB_CBM008.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      GET_DOB_CBM008.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      GET_DOB_CBM008.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      GET_DOB_CBM008.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      GET_DOB_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      GET_DOB_CBM008.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      GET_DOB_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      GET_DOB_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      GET_DOB_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      GET_DOB_CBM008.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      GET_DOB_CBM008.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      GET_DOB_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      GET_DOB_CBM008.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      GET_DOB_CBM008.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      GET_DOB_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      GET_DOB_CBM008.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      GET_DOB_CBM008.OUT_SSN length = 9
         format = $9.
         informat = $9.
         label = 'OUT_SSN',
      GET_DOB_CBM008.NAME length = 50
         format = $50.
         informat = $50.
         label = 'NAME',
      GET_DOB_CBM008.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      GET_DOB_CBM008.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      GET_DOB_CBM008.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      GET_DOB_CBM008.BIRTHDATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTHDATE',
      IFC(UPCASE(PERS_DATA_MAX_EFFDT_CBM008.SEX) IN ('M','F'),
      UPCASE(PERS_DATA_MAX_EFFDT_CBM008.SEX),'U') as GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      GET_DOB_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      GET_DOB_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.GET_DOB_CBM008 as GET_DOB_CBM008 left join
      work.PERS_DATA_MAX_EFFDT_CBM008 as PERS_DATA_MAX_EFFDT_CBM008
         on
         (
            GET_DOB_CBM008.EMPLID = PERS_DATA_MAX_EFFDT_CBM008.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            FOUND_HRE_SSN                         A5B29B8Q.BZ0005O1 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    DECODE_TITLE_CODE_INSTR_CBM008 -      A5B29B8Q.BS0001SP *
 *                   work.W6KESH4X                                          *
 * Target Table:    FOUND_HRE_SSN_CBM008 - work.W6KESKIA  A5B29B8Q.BS0001SY *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O1);

%let SYSLAST = %nrquote(work.W6KESH4X);

proc sql;
   create view work.W6KESKIA as
   select
      W6KESH4X.EMPLID as CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W6KESH4X.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6KESH4X.FOUND_IN_EMPLID_TBL length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_EMPLID_TBL',
      W6KESH4X.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESH4X.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESH4X.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESH4X.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESH4X.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESH4X.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESH4X.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESH4X.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESH4X.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM_PREV',
      W6KESH4X.HRS_ID_NID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESH4X.HRS_ID_PS_EMP length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      W6KESH4X.HRS_ID length = 9
         format = $9.
         informat = $9.
         label = 'HRS_ID',
      W6KESH4X.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      W6KESH4X.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      W6KESH4X.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      W6KESH4X.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      W6KESH4X.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W6KESH4X.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      W6KESH4X.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W6KESH4X.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W6KESH4X.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W6KESH4X.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      W6KESH4X.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      W6KESH4X.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      W6KESH4X.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      W6KESH4X.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      W6KESH4X.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W6KESH4X.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      W6KESH4X.FACULTY_COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_COMPLIANCE',
      W6KESH4X.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      W6KESH4X.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      IFC(W6KESH4X.FACULTY_CLASSIF IS MISSING,'','5') as FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      W6KESH4X.HRE_SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      W6KESH4X.UTA_HRE_NAME as FACULTY_NAME length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME',
      W6KESH4X.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      W6KESH4X.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      W6KESH4X.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      W6KESH4X.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      W6KESH4X.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      W6KESH4X.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6KESH4X.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      W6KESH4X.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESH4X as W6KESH4X
   where
      W6KESH4X.HRE_SSN NOT IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            READ_HRA_TITLE_INSTR                  A5B29B8Q.BZ0005O2 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   FOUND_HRE_SSN_CBM008 - work.W6KESKIA  A5B29B8Q.BS0001SY *
 *                  PS_UTA_CB8_SAL_FTE_Extract -          A5B29B8Q.BE00006Z *
 *                   ADWSTGPR.PS_UTA_CB8_SAL_FTE_Extract                    *
 * Target Table:    READ_HRA_TITLE_INSTR_CBM008 -         A5B29B8Q.BS0001SZ *
 *                   work.W6KESLCM                                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O2);

proc sql;
   create table work.W6KESLCM as
   select distinct
      W6KESKIA.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESKIA.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESKIA.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESKIA.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESKIA.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESKIA.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESKIA.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESKIA.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESKIA.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      W6KESKIA.HRE_SSN as SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      W6KESKIA.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      W6KESKIA.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      W6KESKIA.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      W6KESKIA.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      W6KESKIA.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      PS_UTA_CB8_SAL_FTE_Extract.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      PS_UTA_CB8_SAL_FTE_Extract.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      PS_UTA_CB8_SAL_FTE_Extract.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      W6KESKIA.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6KESKIA.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      W6KESKIA.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESKIA as W6KESKIA left join
      ADWSTGPR.PS_UTA_CB8_SAL_FTE_Extract as PS_UTA_CB8_SAL_FTE_Extract
         on
         (
            W6KESKIA.CIT_CHK_EMPLID = PS_UTA_CB8_SAL_FTE_Extract.EMPLID
            and W6KESKIA.IN_STRM = PS_UTA_CB8_SAL_FTE_Extract.STRM
         )
   ;
quit;

/*==========================================================================*
 * Step:            Set Operators                         A5B29B8Q.BZ0005O3 *
 * Transform:       Set Operators                                           *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_HRA_TITLE_INSTR_CBM008 -         A5B29B8Q.BS0001SZ *
 *                   work.W6KESLCM                                          *
 *                  Join - work.WD9EAXJT                  A5B29B8Q.BS0001SH *
 * Target Table:    Set Operators - work.WD9JHX7H         A5B29B8Q.BS0001T0 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O3);

proc sql;
   create table work.WD9JHX7H as
   /* Returns all unique rows from the two query results.  */
   select
      W6KESLCM.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      W6KESLCM.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W6KESLCM.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W6KESLCM.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W6KESLCM.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W6KESLCM.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W6KESLCM.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W6KESLCM.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W6KESLCM.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      W6KESLCM.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      W6KESLCM.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      W6KESLCM.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      W6KESLCM.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      W6KESLCM.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      W6KESLCM.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      W6KESLCM.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      W6KESLCM.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      W6KESLCM.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      W6KESLCM.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6KESLCM.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      "INSTR" as SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W6KESLCM.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W6KESLCM
   union
   select
      WD9EAXJT.STRM as IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      WD9EAXJT.UTA_HRA_FISCALYEAR as ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WD9EAXJT.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      WD9EAXJT.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      WD9EAXJT.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      WD9EAXJT.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      WD9EAXJT.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WD9EAXJT.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WD9EAXJT.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      WD9EAXJT.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      WD9EAXJT.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      WD9EAXJT.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      WD9EAXJT.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      WD9EAXJT.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      WD9EAXJT.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      WD9EAXJT.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      WD9EAXJT.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      WD9EAXJT.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      IFC(WD9EAXJT.FACULTY_MEMBER='Y','1','0') as COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      WD9EAXJT.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      "HRA" as SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      WD9EAXJT.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.WD9EAXJT
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005O4 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Set Operators - work.WD9JHX7H         A5B29B8Q.BS0001T0 *
 * Target Table:    Join - work.WY3AQG8                   A5B29B8Q.BS0001T1 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O4);

%let SYSLAST = %nrquote(work.WD9JHX7H);

proc sql;
   create table work.WY3AQG8 as
   select distinct
      WD9JHX7H.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'IN_STRM',
      WD9JHX7H.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WD9JHX7H.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      WD9JHX7H.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      WD9JHX7H.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      WD9JHX7H.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      WD9JHX7H.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WD9JHX7H.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WD9JHX7H.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      WD9JHX7H.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      WD9JHX7H.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      WD9JHX7H.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      WD9JHX7H.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      WD9JHX7H.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      WD9JHX7H.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      WD9JHX7H.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      WD9JHX7H.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      WD9JHX7H.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      MAX(WD9JHX7H.COMPLIANCE) as COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      WD9JHX7H.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      MIN(WD9JHX7H.SOURCE) as SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      WD9JHX7H.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.WD9JHX7H as WD9JHX7H
   group by
      WD9JHX7H.IN_STRM,
      WD9JHX7H.SSN,
      WD9JHX7H.POSITION_NBR,
      WD9JHX7H.COMPRATE
   ;
quit;

/*==========================================================================*
 * Step:            UTA_DEPTBDGT_ER_MAX_EFFSEQ            A5B29B8Q.BZ0005O5 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_UTA_DEPTBDGT_ER_Extract -          A5B29B8Q.BE000076 *
 *                   ADWSTGPR.PS_UTA_DEPTBDGT_ER_Extract                    *
 * Target Table:    DEPTBDGT_ER_MAX_EFFSEQ_CBM008 -       A5B29B8Q.BS0001T2 *
 *                   work.DEPTBDGT_ER_MAX_EFFSEQ_CBM008                     *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O5);

%let SYSLAST = %nrquote(ADWSTGPR.PS_UTA_DEPTBDGT_ER_Extract);

proc sql;
   create table work.DEPTBDGT_ER_MAX_EFFSEQ_CBM008 as
   select distinct
      PS_UTA_DEPTBDGT_ER_Extract.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      PS_UTA_DEPTBDGT_ER_Extract.BUDGET_AMT length = 8
         format = 20.3
         informat = 20.3
         label = 'BUDGET_AMT',
      PS_UTA_DEPTBDGT_ER_Extract.BUDGET_SEQ length = 8
         label = 'BUDGET_SEQ',
      PS_UTA_DEPTBDGT_ER_Extract.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      PS_UTA_DEPTBDGT_ER_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_UTA_DEPTBDGT_ER_Extract.EFFSEQ length = 8
         label = 'EFFSEQ',
      PS_UTA_DEPTBDGT_ER_Extract.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      PS_UTA_DEPTBDGT_ER_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_UTA_DEPTBDGT_ER_Extract.ERNCD length = 3
         format = $3.
         informat = $3.
         label = 'ERNCD',
      PS_UTA_DEPTBDGT_ER_Extract.FISCAL_YEAR length = 8
         label = 'FISCAL_YEAR',
      PS_UTA_DEPTBDGT_ER_Extract.FUNDING_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'FUNDING_END_DT',
      PS_UTA_DEPTBDGT_ER_Extract.GL_PAY_TYPE length = 6
         format = $6.
         informat = $6.
         label = 'GL_PAY_TYPE',
      PS_UTA_DEPTBDGT_ER_Extract.HP_EXCESS length = 1
         format = $1.
         informat = $1.
         label = 'HP_EXCESS',
      PS_UTA_DEPTBDGT_ER_Extract.HP_FRINGE_GROUP length = 5
         format = $5.
         informat = $5.
         label = 'HP_FRINGE_GROUP',
      PS_UTA_DEPTBDGT_ER_Extract.HP_REDIRECT_ACCT length = 25
         format = $25.
         informat = $25.
         label = 'HP_REDIRECT_ACCT',
      PS_UTA_DEPTBDGT_ER_Extract.HP_USED_DISTRIBUTN length = 1
         format = $1.
         informat = $1.
         label = 'HP_USED_DISTRIBUTN',
      PS_UTA_DEPTBDGT_ER_Extract.JOBCODE length = 6
         format = $6.
         informat = $6.
         label = 'JOBCODE',
      PS_UTA_DEPTBDGT_ER_Extract.PERCENT_EFFORT length = 8
         format = 7.2
         informat = 7.2
         label = 'PERCENT_EFFORT',
      PS_UTA_DEPTBDGT_ER_Extract.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      PS_UTA_DEPTBDGT_ER_Extract.POSITION_POOL_ID length = 3
         format = $3.
         informat = $3.
         label = 'POSITION_POOL_ID',
      PS_UTA_DEPTBDGT_ER_Extract.SETID length = 5
         format = $5.
         informat = $5.
         label = 'SETID',
      PS_UTA_DEPTBDGT_ER_Extract.SETID_JOBCODE length = 5
         format = $5.
         informat = $5.
         label = 'SETID_JOBCODE'
   from
      ADWSTGPR.PS_UTA_DEPTBDGT_ER_Extract as PS_UTA_DEPTBDGT_ER_Extract
   where
      PS_UTA_DEPTBDGT_ER_Extract.SETID = 'UTARL'
      and STRIP(PS_UTA_DEPTBDGT_ER_Extract.ERNCD) = ''
      and PS_UTA_DEPTBDGT_ER_Extract.HP_USED_DISTRIBUTN = 'Y'
   group by
      PS_UTA_DEPTBDGT_ER_Extract.SETID,
      PS_UTA_DEPTBDGT_ER_Extract.POSITION_NBR,
      PS_UTA_DEPTBDGT_ER_Extract.FISCAL_YEAR,
      PS_UTA_DEPTBDGT_ER_Extract.EFFDT
   having
      PS_UTA_DEPTBDGT_ER_Extract.EFFSEQ = MAX(PS_UTA_DEPTBDGT_ER_Extract.EFFSEQ)
   ;
quit;

/*==========================================================================*
 * Step:            READ_4_ACCT_CD                        A5B29B8Q.BZ0005O6 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   DEPTBDGT_ER_MAX_EFFSEQ_CBM008 -       A5B29B8Q.BS0001T2 *
 *                   work.DEPTBDGT_ER_MAX_EFFSEQ_CBM008                     *
 *                  Join - work.WY3AQG8                   A5B29B8Q.BS0001T1 *
 * Target Table:    READ_4_ACCT_CD_CBM008 -               A5B29B8Q.BS0001T3 *
 *                   work.READ_4_ACCT_CD_CBM008                             *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O6);

proc sql;
   create view work.READ_4_ACCT_CD_CBM008 as
   select distinct
      WY3AQG8.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      DEPTBDGT_ER_MAX_EFFSEQ_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      DEPTBDGT_ER_MAX_EFFSEQ_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      WY3AQG8.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      WY3AQG8.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      WY3AQG8.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      WY3AQG8.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      WY3AQG8.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      WY3AQG8.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      WY3AQG8.IN_STRM as STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WY3AQG8.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WY3AQG8.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WY3AQG8.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      WY3AQG8.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      WY3AQG8.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      WY3AQG8.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      WY3AQG8.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      WY3AQG8.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      WY3AQG8.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      WY3AQG8.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      WY3AQG8.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WY3AQG8.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      WY3AQG8.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      WY3AQG8.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.WY3AQG8 as WY3AQG8 left join
      work.DEPTBDGT_ER_MAX_EFFSEQ_CBM008 as DEPTBDGT_ER_MAX_EFFSEQ_CBM008
         on
         (
            WY3AQG8.POSITION_NBR = DEPTBDGT_ER_MAX_EFFSEQ_CBM008.POSITION_NBR
            and WY3AQG8.UTSHARE_FISCAL_YEAR = DEPTBDGT_ER_MAX_EFFSEQ_CBM008.FISCAL_YEAR
            and DEPTBDGT_ER_MAX_EFFSEQ_CBM008.EFFDT <= DHMS(INPUT(WY3AQG8.APPT_END_DT,YYMMDD8.),0,0,0)
         )
   group by
      WY3AQG8.POSITION_NBR,
      WY3AQG8.UTSHARE_FISCAL_YEAR
   having
      MAX(DEPTBDGT_ER_MAX_EFFSEQ_CBM008.EFFDT) IS MISSING
      or DEPTBDGT_ER_MAX_EFFSEQ_CBM008.EFFDT = MAX(DEPTBDGT_ER_MAX_EFFSEQ_CBM008.EFFDT)
   order by
      SSN,
      COMPRATE,
      UTSHARE_FISCAL_YEAR,
      POSITION_NBR,
      DIST_PCT desc
   ;
quit;

/*==========================================================================*
 * Step:            User Written                          A5B29B8Q.BZ0005O7 *
 * Transform:       User Written                                            *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    READ_4_ACCT_CD_CBM008 -               A5B29B8Q.BS0001T3 *
 *                   work.READ_4_ACCT_CD_CBM008                             *
 * Target Table:    User Written - work.WM2C94J           A5B29B8Q.BS0001T4 *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O7);

%let SYSLAST = %nrquote(work.READ_4_ACCT_CD_CBM008);


%let _INPUT = work.READ_4_ACCT_CD_CBM008;

%let _INPUT1_filetype = WorkTable;

%let _OUTPUT = work.WM2C94J;
        CBM_TERM UTSHARE_FISCAL_YEAR UTA_HRE_MAJORTITLE STRM TERM_END_DT
        CENSUS_DT UTA_HRE_BIRTH_DATE UTA_HRE_GENDER UTA_HRE_NAME_UL
        UTA_HRE_CNT_SVC_DT COMPRATE POSITION_NBR STD_HOURS COMPLIANCE
        ACAD_YEAR UTA_HRE_STATUS SOURCE TERM_BEGIN_DT;

        CBM_TERM UTSHARE_FISCAL_YEAR UTA_HRE_MAJORTITLE STRM TERM_END_DT
        CENSUS_DT UTA_HRE_BIRTH_DATE UTA_HRE_GENDER UTA_HRE_NAME_UL
        UTA_HRE_CNT_SVC_DT COMPRATE POSITION_NBR STD_HOURS COMPLIANCE
        ACAD_YEAR UTA_HRE_STATUS SOURCE TERM_BEGIN_DT;
%let _OUTPUT1_col_count = 24;
%let _OUTPUT1_col0_name = SSN;
%let _OUTPUT1_col0_table = work.WM2C94J;
%let _OUTPUT1_col0_length = 9;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $9.;
%let _OUTPUT1_col0_informat = $9.;
%let _OUTPUT1_col0_label = %nrquote(SSN);
%let _OUTPUT1_col0_input0 = SSN;
%let _OUTPUT1_col0_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input = SSN;
%let _OUTPUT1_col0_input_count = 1;
%let _OUTPUT1_col1_name = ACCT_CD;
%let _OUTPUT1_col1_table = work.WM2C94J;
%let _OUTPUT1_col1_length = 25;
%let _OUTPUT1_col1_type = $;
%let _OUTPUT1_col1_format = $25.;
%let _OUTPUT1_col1_informat = $25.;
%let _OUTPUT1_col1_label = %nrquote(ACCT_CD);
%let _OUTPUT1_col1_input0 = ACCT_CD;
%let _OUTPUT1_col1_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input = ACCT_CD;
%let _OUTPUT1_col1_input_count = 1;
%let _OUTPUT1_col2_name = DIST_PCT;
%let _OUTPUT1_col2_table = work.WM2C94J;
%let _OUTPUT1_col2_length = 8;
%let _OUTPUT1_col2_type = ;
%let _OUTPUT1_col2_format = 8.3;
%let _OUTPUT1_col2_informat = 8.3;
%let _OUTPUT1_col2_label = %nrquote(DIST_PCT);
%let _OUTPUT1_col2_input0 = DIST_PCT;
%let _OUTPUT1_col2_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input = DIST_PCT;
%let _OUTPUT1_col2_input_count = 1;
%let _OUTPUT1_col3_name = UTA_HRE_MAJAPPTSEQ;
%let _OUTPUT1_col3_table = work.WM2C94J;
%let _OUTPUT1_col3_length = 3;
%let _OUTPUT1_col3_type = $;
%let _OUTPUT1_col3_format = $3.;
%let _OUTPUT1_col3_informat = $3.;
%let _OUTPUT1_col3_label = %nrquote(UTA_HRE_MAJAPPTSEQ);
%let _OUTPUT1_col3_input0 = UTA_HRE_MAJAPPTSEQ;
%let _OUTPUT1_col3_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col3_exp = ;
%let _OUTPUT1_col3_input = UTA_HRE_MAJAPPTSEQ;
%let _OUTPUT1_col3_input_count = 1;
%let _OUTPUT1_col4_name = APPT_BEGIN_DT;
%let _OUTPUT1_col4_table = work.WM2C94J;
%let _OUTPUT1_col4_length = 8;
%let _OUTPUT1_col4_type = $;
%let _OUTPUT1_col4_format = ;
%let _OUTPUT1_col4_informat = ;
%let _OUTPUT1_col4_label = %nrquote(APPT_BEGIN_DT);
%let _OUTPUT1_col4_input0 = APPT_BEGIN_DT;
%let _OUTPUT1_col4_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col4_exp = ;
%let _OUTPUT1_col4_input = APPT_BEGIN_DT;
%let _OUTPUT1_col4_input_count = 1;
%let _OUTPUT1_col5_name = APPT_END_DT;
%let _OUTPUT1_col5_table = work.WM2C94J;
%let _OUTPUT1_col5_length = 8;
%let _OUTPUT1_col5_type = $;
%let _OUTPUT1_col5_format = ;
%let _OUTPUT1_col5_informat = ;
%let _OUTPUT1_col5_label = %nrquote(APPT_END_DT);
%let _OUTPUT1_col5_input0 = APPT_END_DT;
%let _OUTPUT1_col5_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col5_exp = ;
%let _OUTPUT1_col5_input = APPT_END_DT;
%let _OUTPUT1_col5_input_count = 1;
%let _OUTPUT1_col6_name = CBM_TERM;
%let _OUTPUT1_col6_table = work.WM2C94J;
%let _OUTPUT1_col6_length = 1;
%let _OUTPUT1_col6_type = $;
%let _OUTPUT1_col6_format = $1.;
%let _OUTPUT1_col6_informat = $1.;
%let _OUTPUT1_col6_label = %nrquote(CBM_TERM);
%let _OUTPUT1_col6_input0 = CBM_TERM;
%let _OUTPUT1_col6_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col6_exp = ;
%let _OUTPUT1_col6_input = CBM_TERM;
%let _OUTPUT1_col6_input_count = 1;
%let _OUTPUT1_col7_name = UTSHARE_FISCAL_YEAR;
%let _OUTPUT1_col7_table = work.WM2C94J;
%let _OUTPUT1_col7_length = 8;
%let _OUTPUT1_col7_type = ;
%let _OUTPUT1_col7_format = ;
%let _OUTPUT1_col7_informat = ;
%let _OUTPUT1_col7_label = %nrquote(UTSHARE_FISCAL_YEAR);
%let _OUTPUT1_col7_input0 = UTSHARE_FISCAL_YEAR;
%let _OUTPUT1_col7_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col7_exp = ;
%let _OUTPUT1_col7_input = UTSHARE_FISCAL_YEAR;
%let _OUTPUT1_col7_input_count = 1;
%let _OUTPUT1_col8_name = UTA_HRE_MAJORTITLE;
%let _OUTPUT1_col8_table = work.WM2C94J;
%let _OUTPUT1_col8_length = 4;
%let _OUTPUT1_col8_type = $;
%let _OUTPUT1_col8_format = $4.;
%let _OUTPUT1_col8_informat = $4.;
%let _OUTPUT1_col8_label = %nrquote(UTA_HRE_MAJORTITLE);
%let _OUTPUT1_col8_input0 = UTA_HRE_MAJORTITLE;
%let _OUTPUT1_col8_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col8_exp = ;
%let _OUTPUT1_col8_input = UTA_HRE_MAJORTITLE;
%let _OUTPUT1_col8_input_count = 1;
%let _OUTPUT1_col9_name = STRM;
%let _OUTPUT1_col9_table = work.WM2C94J;
%let _OUTPUT1_col9_length = 4;
%let _OUTPUT1_col9_type = $;
%let _OUTPUT1_col9_format = $4.;
%let _OUTPUT1_col9_informat = $4.;
%let _OUTPUT1_col9_label = %nrquote(STRM);
%let _OUTPUT1_col9_input0 = STRM;
%let _OUTPUT1_col9_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col9_exp = ;
%let _OUTPUT1_col9_input = STRM;
%let _OUTPUT1_col9_input_count = 1;
%let _OUTPUT1_col10_name = TERM_END_DT;
%let _OUTPUT1_col10_table = work.WM2C94J;
%let _OUTPUT1_col10_length = 8;
%let _OUTPUT1_col10_type = ;
%let _OUTPUT1_col10_format = DATETIME20.;
%let _OUTPUT1_col10_informat = DATETIME20.;
%let _OUTPUT1_col10_label = %nrquote(TERM_END_DT);
%let _OUTPUT1_col10_input0 = TERM_END_DT;
%let _OUTPUT1_col10_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col10_exp = ;
%let _OUTPUT1_col10_input = TERM_END_DT;
%let _OUTPUT1_col10_input_count = 1;
%let _OUTPUT1_col11_name = CENSUS_DT;
%let _OUTPUT1_col11_table = work.WM2C94J;
%let _OUTPUT1_col11_length = 8;
%let _OUTPUT1_col11_type = ;
%let _OUTPUT1_col11_format = DATETIME20.;
%let _OUTPUT1_col11_informat = DATETIME20.;
%let _OUTPUT1_col11_label = %nrquote(CENSUS_DT);
%let _OUTPUT1_col11_input0 = CENSUS_DT;
%let _OUTPUT1_col11_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col11_exp = ;
%let _OUTPUT1_col11_input = CENSUS_DT;
%let _OUTPUT1_col11_input_count = 1;
%let _OUTPUT1_col12_name = UTA_HRE_BIRTH_DATE;
%let _OUTPUT1_col12_table = work.WM2C94J;
%let _OUTPUT1_col12_length = 8;
%let _OUTPUT1_col12_type = $;
%let _OUTPUT1_col12_format = $8.;
%let _OUTPUT1_col12_informat = $8.;
%let _OUTPUT1_col12_label = %nrquote(UTA_HRE_BIRTH_DATE);
%let _OUTPUT1_col12_input0 = UTA_HRE_BIRTH_DATE;
%let _OUTPUT1_col12_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col12_exp = ;
%let _OUTPUT1_col12_input = UTA_HRE_BIRTH_DATE;
%let _OUTPUT1_col12_input_count = 1;
%let _OUTPUT1_col13_name = UTA_HRE_GENDER;
%let _OUTPUT1_col13_table = work.WM2C94J;
%let _OUTPUT1_col13_length = 1;
%let _OUTPUT1_col13_type = $;
%let _OUTPUT1_col13_format = $1.;
%let _OUTPUT1_col13_informat = $1.;
%let _OUTPUT1_col13_label = %nrquote(UTA_HRE_GENDER);
%let _OUTPUT1_col13_input0 = UTA_HRE_GENDER;
%let _OUTPUT1_col13_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col13_exp = ;
%let _OUTPUT1_col13_input = UTA_HRE_GENDER;
%let _OUTPUT1_col13_input_count = 1;
%let _OUTPUT1_col14_name = UTA_HRE_NAME_UL;
%let _OUTPUT1_col14_table = work.WM2C94J;
%let _OUTPUT1_col14_length = 25;
%let _OUTPUT1_col14_type = $;
%let _OUTPUT1_col14_format = $25.;
%let _OUTPUT1_col14_informat = $25.;
%let _OUTPUT1_col14_label = %nrquote(UTA_HRE_NAME_UL);
%let _OUTPUT1_col14_input0 = UTA_HRE_NAME_UL;
%let _OUTPUT1_col14_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col14_exp = ;
%let _OUTPUT1_col14_input = UTA_HRE_NAME_UL;
%let _OUTPUT1_col14_input_count = 1;
%let _OUTPUT1_col15_name = UTA_HRE_CNT_SVC_DT;
%let _OUTPUT1_col15_table = work.WM2C94J;
%let _OUTPUT1_col15_length = 8;
%let _OUTPUT1_col15_type = $;
%let _OUTPUT1_col15_format = $8.;
%let _OUTPUT1_col15_informat = $8.;
%let _OUTPUT1_col15_label = %nrquote(UTA_HRE_CNT_SVC_DT);
%let _OUTPUT1_col15_input0 = UTA_HRE_CNT_SVC_DT;
%let _OUTPUT1_col15_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col15_exp = ;
%let _OUTPUT1_col15_input = UTA_HRE_CNT_SVC_DT;
%let _OUTPUT1_col15_input_count = 1;
%let _OUTPUT1_col16_name = COMPRATE;
%let _OUTPUT1_col16_table = work.WM2C94J;
%let _OUTPUT1_col16_length = 8;
%let _OUTPUT1_col16_type = ;
%let _OUTPUT1_col16_format = 20.6;
%let _OUTPUT1_col16_informat = 20.6;
%let _OUTPUT1_col16_label = %nrquote(COMPRATE);
%let _OUTPUT1_col16_input0 = COMPRATE;
%let _OUTPUT1_col16_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col16_exp = ;
%let _OUTPUT1_col16_input = COMPRATE;
%let _OUTPUT1_col16_input_count = 1;
%let _OUTPUT1_col17_name = POSITION_NBR;
%let _OUTPUT1_col17_table = work.WM2C94J;
%let _OUTPUT1_col17_length = 8;
%let _OUTPUT1_col17_type = $;
%let _OUTPUT1_col17_format = $8.;
%let _OUTPUT1_col17_informat = $8.;
%let _OUTPUT1_col17_label = %nrquote(POSITION_NBR);
%let _OUTPUT1_col17_input0 = POSITION_NBR;
%let _OUTPUT1_col17_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col17_exp = ;
%let _OUTPUT1_col17_input = POSITION_NBR;
%let _OUTPUT1_col17_input_count = 1;
%let _OUTPUT1_col18_name = STD_HOURS;
%let _OUTPUT1_col18_table = work.WM2C94J;
%let _OUTPUT1_col18_length = 8;
%let _OUTPUT1_col18_type = ;
%let _OUTPUT1_col18_format = 8.2;
%let _OUTPUT1_col18_informat = 8.2;
%let _OUTPUT1_col18_label = %nrquote(STD_HOURS);
%let _OUTPUT1_col18_input0 = STD_HOURS;
%let _OUTPUT1_col18_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col18_exp = ;
%let _OUTPUT1_col18_input = STD_HOURS;
%let _OUTPUT1_col18_input_count = 1;
%let _OUTPUT1_col19_name = COMPLIANCE;
%let _OUTPUT1_col19_table = work.WM2C94J;
%let _OUTPUT1_col19_length = 1;
%let _OUTPUT1_col19_type = $;
%let _OUTPUT1_col19_format = $1.;
%let _OUTPUT1_col19_informat = $1.;
%let _OUTPUT1_col19_label = %nrquote(COMPLIANCE);
%let _OUTPUT1_col19_input0 = COMPLIANCE;
%let _OUTPUT1_col19_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col19_exp = ;
%let _OUTPUT1_col19_input = COMPLIANCE;
%let _OUTPUT1_col19_input_count = 1;
%let _OUTPUT1_col20_name = ACAD_YEAR;
%let _OUTPUT1_col20_table = work.WM2C94J;
%let _OUTPUT1_col20_length = 8;
%let _OUTPUT1_col20_type = ;
%let _OUTPUT1_col20_format = ;
%let _OUTPUT1_col20_informat = ;
%let _OUTPUT1_col20_label = %nrquote(ACAD_YEAR);
%let _OUTPUT1_col20_input0 = ACAD_YEAR;
%let _OUTPUT1_col20_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col20_exp = ;
%let _OUTPUT1_col20_input = ACAD_YEAR;
%let _OUTPUT1_col20_input_count = 1;
%let _OUTPUT1_col21_name = UTA_HRE_STATUS;
%let _OUTPUT1_col21_table = work.WM2C94J;
%let _OUTPUT1_col21_length = 1;
%let _OUTPUT1_col21_type = $;
%let _OUTPUT1_col21_format = $1.;
%let _OUTPUT1_col21_informat = $1.;
%let _OUTPUT1_col21_label = %nrquote(UTA_HRE_STATUS);
%let _OUTPUT1_col21_input0 = UTA_HRE_STATUS;
%let _OUTPUT1_col21_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col21_exp = ;
%let _OUTPUT1_col21_input = UTA_HRE_STATUS;
%let _OUTPUT1_col21_input_count = 1;
%let _OUTPUT1_col22_name = SOURCE;
%let _OUTPUT1_col22_table = work.WM2C94J;
%let _OUTPUT1_col22_length = 5;
%let _OUTPUT1_col22_type = $;
%let _OUTPUT1_col22_format = $5.;
%let _OUTPUT1_col22_informat = $5.;
%let _OUTPUT1_col22_label = %nrquote(SOURCE);
%let _OUTPUT1_col22_input0 = SOURCE;
%let _OUTPUT1_col22_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col22_exp = ;
%let _OUTPUT1_col22_input = SOURCE;
%let _OUTPUT1_col22_input_count = 1;
%let _OUTPUT1_col23_name = TERM_BEGIN_DT;
%let _OUTPUT1_col23_table = work.WM2C94J;
%let _OUTPUT1_col23_length = 8;
%let _OUTPUT1_col23_type = ;
%let _OUTPUT1_col23_format = DATETIME20.;
%let _OUTPUT1_col23_informat = DATETIME20.;
%let _OUTPUT1_col23_label = %nrquote(TERM_BEGIN_DT);
%let _OUTPUT1_col23_input0 = TERM_BEGIN_DT;
%let _OUTPUT1_col23_input0_table = work.READ_4_ACCT_CD_CBM008;
%let _OUTPUT1_col23_exp = ;
%let _OUTPUT1_col23_input = TERM_BEGIN_DT;
%let _OUTPUT1_col23_input_count = 1;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/

data &_OUTPUT.;
	set &_INPUT.;
	by SSN COMPRATE UTSHARE_FISCAL_YEAR POSITION_NBR descending DIST_PCT;
	retain TOT_DIST_PCT;
	if first.POSITION_NBR then TOT_DIST_PCT=0;
	if TOT_DIST_PCT < 100 then output;
	TOT_DIST_PCT = SUM(DIST_PCT,TOT_DIST_PCT);
run;
/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            READ_4_FUND_CD_FUNCTION               A5B29B8Q.BZ0005O8 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_UTA_HR_ACCTCDCA_Extract -          A5B29B8Q.BE00007C *
 *                   ADWSTGPR.PS_UTA_HR_ACCTCDCA_Extract                    *
 *                  User Written - work.WM2C94J           A5B29B8Q.BS0001T4 *
 * Target Table:    READ_4_FUND_CD_FUNCTION_CBM008 -      A5B29B8Q.BS0001T5 *
 *                   work.READ_4_FUND_CD_FUNCTION_CBM008                    *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O8);

proc sql;
   create table work.READ_4_FUND_CD_FUNCTION_CBM008 as
   select
      WM2C94J.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      WM2C94J.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      WM2C94J.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      PS_UTA_HR_ACCTCDCA_Extract.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      PS_UTA_HR_ACCTCDCA_Extract.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      PS_UTA_HR_ACCTCDCA_Extract.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      WM2C94J.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      WM2C94J.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      WM2C94J.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      WM2C94J.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      WM2C94J.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      WM2C94J.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      WM2C94J.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WM2C94J.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WM2C94J.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WM2C94J.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      WM2C94J.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      WM2C94J.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      WM2C94J.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      WM2C94J.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      WM2C94J.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      WM2C94J.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      INPUT(PS_UTA_HR_ACCTCDCA_Extract.CLASS_FLD,BEST8.) as CLASS_FLD_NBR length = 8
         label = 'CLASS_FLD_NBR',
      WM2C94J.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      WM2C94J.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WM2C94J.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      WM2C94J.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      WM2C94J.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.WM2C94J as WM2C94J left join
      ADWSTGPR.PS_UTA_HR_ACCTCDCA_Extract as PS_UTA_HR_ACCTCDCA_Extract
         on
         (
            WM2C94J.ACCT_CD = PS_UTA_HR_ACCTCDCA_Extract.ACCT_CD
         )
   ;
quit;

/*==========================================================================*
 * Step:            LOOKUP_EMPLID                         A5B29B8Q.BZ0005O9 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_4_FUND_CD_FUNCTION_CBM008 -      A5B29B8Q.BS0001T5 *
 *                   work.READ_4_FUND_CD_FUNCTION_CBM008                    *
 *                  PS_PERS_NID_Extract -                 A5B29B8Q.BE00000R *
 *                   ADWSTGPR.PS_PERS_NID_Extract                           *
 * Target Table:    Join - work.WL7HXOR                   A5B29B8Q.BS0001T6 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005O9);

proc sql;
   create table work.WL7HXOR as
   select
      READ_4_FUND_CD_FUNCTION_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_4_FUND_CD_FUNCTION_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      READ_4_FUND_CD_FUNCTION_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      READ_4_FUND_CD_FUNCTION_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      READ_4_FUND_CD_FUNCTION_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      READ_4_FUND_CD_FUNCTION_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      PS_PERS_NID_Extract.EMPLID as CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_FUND_CD_FUNCTION_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_4_FUND_CD_FUNCTION_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_4_FUND_CD_FUNCTION_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_4_FUND_CD_FUNCTION_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_4_FUND_CD_FUNCTION_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      READ_4_FUND_CD_FUNCTION_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      READ_4_FUND_CD_FUNCTION_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_4_FUND_CD_FUNCTION_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_4_FUND_CD_FUNCTION_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_4_FUND_CD_FUNCTION_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_4_FUND_CD_FUNCTION_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_4_FUND_CD_FUNCTION_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_4_FUND_CD_FUNCTION_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_4_FUND_CD_FUNCTION_CBM008.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      READ_4_FUND_CD_FUNCTION_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_4_FUND_CD_FUNCTION_CBM008.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      READ_4_FUND_CD_FUNCTION_CBM008.CLASS_FLD_NBR length = 8
         label = 'CLASS_FLD_NBR',
      READ_4_FUND_CD_FUNCTION_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      READ_4_FUND_CD_FUNCTION_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      READ_4_FUND_CD_FUNCTION_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_4_FUND_CD_FUNCTION_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      READ_4_FUND_CD_FUNCTION_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.READ_4_FUND_CD_FUNCTION_CBM008 as READ_4_FUND_CD_FUNCTION_CBM008 left join
      ADWSTGPR.PS_PERS_NID_Extract as PS_PERS_NID_Extract
         on
         (
            READ_4_FUND_CD_FUNCTION_CBM008.SSN = PS_PERS_NID_Extract.NATIONAL_ID
         )
   ;
quit;

/*==========================================================================*
 * Step:            NAMES_MAX_EFFDT                       A5B29B8Q.BZ0005OA *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_NAMES_Extract -                    A5B29B8Q.BE00004K *
 *                   ADWSTGPR.PS_NAMES_Extract                              *
 * Target Table:    NAMES_MAX_EFFDT_CBM008 -              A5B29B8Q.BS0001T7 *
 *                   work.NAMES_MAX_EFFDT_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OA);

%let SYSLAST = %nrquote(ADWSTGPR.PS_NAMES_Extract);

proc sql;
   create view work.NAMES_MAX_EFFDT_CBM008 as
   select
      PS_NAMES_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID'
   from
      ADWSTGPR.PS_NAMES_Extract as PS_NAMES_Extract
   where
      PS_NAMES_Extract.NAME_TYPE = 'PRI'
      and UPCASE(PS_NAMES_Extract.NAME) NOT CONTAINS ('DO NOT USE')
      and PS_NAMES_Extract.EFFDT <= DATETIME()
   group by
      PS_NAMES_Extract.EMPLID
   having
      PS_NAMES_Extract.EFFDT = MAX(PS_NAMES_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            EMPLID_IN_NAMES_CHECK                 A5B29B8Q.BZ0005OB *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_UTA_HR_PS_EMP_Extract -            A5B29B8Q.BE00007G *
 *                   ADWSTGPR.PS_UTA_HR_PS_EMP_Extract                      *
 *                  NAMES_MAX_EFFDT_CBM008 -              A5B29B8Q.BS0001T7 *
 *                   work.NAMES_MAX_EFFDT_CBM008                            *
 * Target Table:    EMPLID_IN_NAMES_CHECK_CBM008 -        A5B29B8Q.BS0001T8 *
 *                   work.EMPLID_IN_NAMES_CHECK_CBM008                      *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OB);

proc sql;
   create table work.EMPLID_IN_NAMES_CHECK_CBM008 as
   select distinct
      PS_UTA_HR_PS_EMP_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_UTA_HR_PS_EMP_Extract.NATIONAL_ID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      IFC(NAMES_MAX_EFFDT_CBM008.EMPLID IS MISSING,'N','Y') as FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      PS_UTA_HR_PS_EMP_Extract.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT'
   from
      ADWSTGPR.PS_UTA_HR_PS_EMP_Extract as PS_UTA_HR_PS_EMP_Extract left join
      work.NAMES_MAX_EFFDT_CBM008 as NAMES_MAX_EFFDT_CBM008
         on
         (
            PS_UTA_HR_PS_EMP_Extract.EMPLID = NAMES_MAX_EFFDT_CBM008.EMPLID
         )
   group by
      PS_UTA_HR_PS_EMP_Extract.NATIONAL_ID
   having
      PS_UTA_HR_PS_EMP_Extract.UTA_HR_ASOFDATE = MAX(PS_UTA_HR_PS_EMP_Extract.UTA_HR_ASOFDATE)
   ;
quit;

/*==========================================================================*
 * Step:            HR_PS_EMP_MAX_ACTION_ASOFDT           A5B29B8Q.BZ0005OC *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    EMPLID_IN_NAMES_CHECK_CBM008 -        A5B29B8Q.BS0001T8 *
 *                   work.EMPLID_IN_NAMES_CHECK_CBM008                      *
 * Target Table:    EMP_MAX_ACTION_ASOFDT_CBM008 -        A5B29B8Q.BS0001T9 *
 *                   work.EMP_MAX_ACTION_ASOFDT_CBM008                      *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OC);

%let SYSLAST = %nrquote(work.EMPLID_IN_NAMES_CHECK_CBM008);

proc sql;
   create table work.EMP_MAX_ACTION_ASOFDT_CBM008 as
   select
      EMPLID_IN_NAMES_CHECK_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      EMPLID_IN_NAMES_CHECK_CBM008.NATIONAL_ID length = 20
         format = $20.
         informat = $20.
         label = 'NATIONAL_ID',
      EMPLID_IN_NAMES_CHECK_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES'
   from
      work.EMPLID_IN_NAMES_CHECK_CBM008 as EMPLID_IN_NAMES_CHECK_CBM008
   group by
      EMPLID_IN_NAMES_CHECK_CBM008.NATIONAL_ID
   having
      EMPLID_IN_NAMES_CHECK_CBM008.ACTION_DT = MAX(EMPLID_IN_NAMES_CHECK_CBM008.ACTION_DT)
   ;
quit;

/*==========================================================================*
 * Step:            LOOKUP_EMPLID_EXTERNAL_SYS            A5B29B8Q.BZ0005OD *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WL7HXOR                   A5B29B8Q.BS0001T6 *
 *                  EMP_MAX_ACTION_ASOFDT_CBM008 -        A5B29B8Q.BS0001T9 *
 *                   work.EMP_MAX_ACTION_ASOFDT_CBM008                      *
 * Target Table:    Join - work.WL8BA1J                   A5B29B8Q.BS0001TA *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OD);

proc sql;
   create table work.WL8BA1J as
   select
      WL7HXOR.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      WL7HXOR.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      WL7HXOR.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      WL7HXOR.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      WL7HXOR.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      WL7HXOR.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      WL7HXOR.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      EMP_MAX_ACTION_ASOFDT_CBM008.EMPLID as CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      EMP_MAX_ACTION_ASOFDT_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      WL7HXOR.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      WL7HXOR.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      WL7HXOR.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      WL7HXOR.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      WL7HXOR.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      WL7HXOR.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      WL7HXOR.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WL7HXOR.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WL7HXOR.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WL7HXOR.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      WL7HXOR.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      WL7HXOR.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      WL7HXOR.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      WL7HXOR.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      WL7HXOR.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      WL7HXOR.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      WL7HXOR.CLASS_FLD_NBR length = 8
         label = 'CLASS_FLD_NBR',
      WL7HXOR.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      WL7HXOR.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WL7HXOR.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      WL7HXOR.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      WL7HXOR.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.WL7HXOR as WL7HXOR left join
      work.EMP_MAX_ACTION_ASOFDT_CBM008 as EMP_MAX_ACTION_ASOFDT_CBM008
         on
         (
            WL7HXOR.CIT_CHK_EMPLID_PERS_NID IS MISSING
            and WL7HXOR.SSN = EMP_MAX_ACTION_ASOFDT_CBM008.NATIONAL_ID
         )
   ;
quit;

/*==========================================================================*
 * Step:            LOOKUP_EMPLID_EXTERNAL_SYS_CB         A5B29B8Q.BZ0005OE *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WL8BA1J                   A5B29B8Q.BS0001TA *
 *                  PS_EXTERNAL_SYSTEM_Extract -          A5B29B8Q.BE00000S *
 *                   ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract                    *
 * Target Table:    Join - work.WXZ8O3F                   A5B29B8Q.BS0001TB *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OE);

proc sql;
   create table work.WXZ8O3F as
   select distinct
      WL8BA1J.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      WL8BA1J.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      WL8BA1J.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      WL8BA1J.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      WL8BA1J.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      WL8BA1J.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      WL8BA1J.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      WL8BA1J.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      WL8BA1J.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      PS_EXTERNAL_SYSTEM_Extract.EMPLID as CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      IFC(PS_EXTERNAL_SYSTEM_Extract.EMPLID NOT IS MISSING,PS_EXTERNAL_SYSTEM_Extract.EMPLID,
      IFC(WL8BA1J.CIT_CHK_EMPLID_HR_PS_EMP NOT IS MISSING,WL8BA1J.CIT_CHK_EMPLID_HR_PS_EMP,
      WL8BA1J.CIT_CHK_EMPLID_PERS_NID)) as CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      WL8BA1J.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      WL8BA1J.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      WL8BA1J.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      WL8BA1J.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      WL8BA1J.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      WL8BA1J.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      WL8BA1J.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WL8BA1J.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WL8BA1J.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WL8BA1J.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      WL8BA1J.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      WL8BA1J.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      WL8BA1J.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      WL8BA1J.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      WL8BA1J.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      WL8BA1J.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      WL8BA1J.CLASS_FLD_NBR length = 8
         label = 'CLASS_FLD_NBR',
      WL8BA1J.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      WL8BA1J.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WL8BA1J.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      WL8BA1J.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      WL8BA1J.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.WL8BA1J as WL8BA1J left join
      ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract as PS_EXTERNAL_SYSTEM_Extract
         on
         (
            WL8BA1J.CIT_CHK_EMPLID_PERS_NID IS MISSING
            and WL8BA1J.CIT_CHK_EMPLID_HR_PS_EMP IS MISSING
            and WL8BA1J.SSN = PS_EXTERNAL_SYSTEM_Extract.EXTERNAL_SYSTEM_ID
            and PS_EXTERNAL_SYSTEM_Extract.EXTERNAL_SYSTEM = 'CB_ID'
         )
   ;
quit;

/*==========================================================================*
 * Step:            HRA_BEGIN_AND_END_DT                  A5B29B8Q.BZ0005OF *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WXZ8O3F                   A5B29B8Q.BS0001TB *
 * Target Table:    HRA_BEGIN_AND_END_DT_CBM008 -         A5B29B8Q.BS0001TC *
 *                   work.HRA_BEGIN_AND_END_DT_CBM008                       *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OF);

%let SYSLAST = %nrquote(work.WXZ8O3F);

proc sql;
   create table work.HRA_BEGIN_AND_END_DT_CBM008 as
   select
      WXZ8O3F.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      WXZ8O3F.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      WXZ8O3F.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      WXZ8O3F.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      WXZ8O3F.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      WXZ8O3F.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      WXZ8O3F.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      WXZ8O3F.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      WXZ8O3F.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      WXZ8O3F.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      WXZ8O3F.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      WXZ8O3F.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      WXZ8O3F.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      WXZ8O3F.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      WXZ8O3F.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      WXZ8O3F.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      WXZ8O3F.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      WXZ8O3F.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WXZ8O3F.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WXZ8O3F.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WXZ8O3F.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      WXZ8O3F.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      WXZ8O3F.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      WXZ8O3F.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      WXZ8O3F.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      WXZ8O3F.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      WXZ8O3F.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      WXZ8O3F.CLASS_FLD_NBR length = 8
         label = 'CLASS_FLD_NBR',
      WXZ8O3F.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      WXZ8O3F.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WXZ8O3F.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      WXZ8O3F.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      WXZ8O3F.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.WXZ8O3F as WXZ8O3F
   ;
quit;

/*==========================================================================*
 * Step:            DAYS_IN_APPT                          A5B29B8Q.BZ0005OG *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    HRA_BEGIN_AND_END_DT_CBM008 -         A5B29B8Q.BS0001TC *
 *                   work.HRA_BEGIN_AND_END_DT_CBM008                       *
 * Target Table:    DAYS_IN_APPT_CBM008 -                 A5B29B8Q.BS0001TD *
 *                   work.DAYS_IN_APPT_CBM008                               *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OG);

%let SYSLAST = %nrquote(work.HRA_BEGIN_AND_END_DT_CBM008);

proc sql;
   create table work.DAYS_IN_APPT_CBM008 as
   select
      HRA_BEGIN_AND_END_DT_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      HRA_BEGIN_AND_END_DT_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      HRA_BEGIN_AND_END_DT_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      HRA_BEGIN_AND_END_DT_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      HRA_BEGIN_AND_END_DT_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      HRA_BEGIN_AND_END_DT_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      HRA_BEGIN_AND_END_DT_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      HRA_BEGIN_AND_END_DT_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      HRA_BEGIN_AND_END_DT_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      HRA_BEGIN_AND_END_DT_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      HRA_BEGIN_AND_END_DT_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      HRA_BEGIN_AND_END_DT_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      HRA_BEGIN_AND_END_DT_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      HRA_BEGIN_AND_END_DT_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      HRA_BEGIN_AND_END_DT_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      HRA_BEGIN_AND_END_DT_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      HRA_BEGIN_AND_END_DT_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      HRA_BEGIN_AND_END_DT_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      HRA_BEGIN_AND_END_DT_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      HRA_BEGIN_AND_END_DT_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      HRA_BEGIN_AND_END_DT_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      HRA_BEGIN_AND_END_DT_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      HRA_BEGIN_AND_END_DT_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      HRA_BEGIN_AND_END_DT_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      HRA_BEGIN_AND_END_DT_CBM008.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      HRA_BEGIN_AND_END_DT_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      HRA_BEGIN_AND_END_DT_CBM008.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      HRA_BEGIN_AND_END_DT_CBM008.CLASS_FLD_NBR length = 8
         label = 'CLASS_FLD_NBR',
      HRA_BEGIN_AND_END_DT_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      HRA_BEGIN_AND_END_DT_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      HRA_BEGIN_AND_END_DT_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      HRA_BEGIN_AND_END_DT_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      HRA_BEGIN_AND_END_DT_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.HRA_BEGIN_AND_END_DT_CBM008 as HRA_BEGIN_AND_END_DT_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            OVLP_REDIS                            A5B29B8Q.BZ0005OH *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    DAYS_IN_APPT_CBM008 -                 A5B29B8Q.BS0001TD *
 *                   work.DAYS_IN_APPT_CBM008                               *
 * Target Table:    OVLP_REDIS_CBM008 -                   A5B29B8Q.BS0001TE *
 *                   work.OVLP_REDIS_CBM008                                 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OH);

%let SYSLAST = %nrquote(work.DAYS_IN_APPT_CBM008);

proc sql;
   create table work.OVLP_REDIS_CBM008 as
   select
      DAYS_IN_APPT_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      DAYS_IN_APPT_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      DAYS_IN_APPT_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      DAYS_IN_APPT_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      DAYS_IN_APPT_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      DAYS_IN_APPT_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      DAYS_IN_APPT_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      DAYS_IN_APPT_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      DAYS_IN_APPT_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      DAYS_IN_APPT_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      DAYS_IN_APPT_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      DAYS_IN_APPT_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      DAYS_IN_APPT_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      DAYS_IN_APPT_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      (DAYS_IN_APPT_CBM008.STD_HOURS/40)*
      DAYS_IN_APPT_CBM008.DIST_PCT as OVLP_PERCENT_TIME_REDIS length = 8
         label = 'OVLP_PERCENT_TIME_REDIS',
      IFN(DAYS_IN_APPT_CBM008.DIST_PCT IS MISSING |
      DAYS_IN_APPT_CBM008.COMPRATE IS MISSING,0,
      (DAYS_IN_APPT_CBM008.COMPRATE*
      DAYS_IN_APPT_CBM008.DIST_PCT)/100) as OVLP_ALLOC_REDIS length = 8
         label = 'OVLP_ALLOC_REDIS',
      DAYS_IN_APPT_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      DAYS_IN_APPT_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      DAYS_IN_APPT_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      DAYS_IN_APPT_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      DAYS_IN_APPT_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      DAYS_IN_APPT_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      DAYS_IN_APPT_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      DAYS_IN_APPT_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      DAYS_IN_APPT_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      DAYS_IN_APPT_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      DAYS_IN_APPT_CBM008.CLASS_FLD_NBR length = 8
         label = 'CLASS_FLD_NBR',
      DAYS_IN_APPT_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      DAYS_IN_APPT_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      DAYS_IN_APPT_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      DAYS_IN_APPT_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      DAYS_IN_APPT_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.DAYS_IN_APPT_CBM008 as DAYS_IN_APPT_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            SALARY_AND_PCT_TIME                   A5B29B8Q.BZ0005OI *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    OVLP_REDIS_CBM008 -                   A5B29B8Q.BS0001TE *
 *                   work.OVLP_REDIS_CBM008                                 *
 * Target Table:    SALARY_AND_PCT_TIME_CBM008 -          A5B29B8Q.BS0001TF *
 *                   work.SALARY_AND_PCT_TIME_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OI);

%let SYSLAST = %nrquote(work.OVLP_REDIS_CBM008);

proc sql;
   create table work.SALARY_AND_PCT_TIME_CBM008 as
   select distinct
      OVLP_REDIS_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      OVLP_REDIS_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      OVLP_REDIS_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      OVLP_REDIS_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      OVLP_REDIS_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      OVLP_REDIS_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      OVLP_REDIS_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      OVLP_REDIS_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      INT(SUM(IFN(OVLP_REDIS_CBM008.CLASS_FLD_NBR>=100 &
      OVLP_REDIS_CBM008.CLASS_FLD_NBR<=199,
      OVLP_REDIS_CBM008.OVLP_PERCENT_TIME_REDIS,0))) as PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      INT(SUM(IFN(OVLP_REDIS_CBM008.CLASS_FLD_NBR>=400 &
      OVLP_REDIS_CBM008.CLASS_FLD_NBR<=499,
      OVLP_REDIS_CBM008.OVLP_PERCENT_TIME_REDIS,0))) as PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      INT(SUM(IFN(OVLP_REDIS_CBM008.CLASS_FLD_NBR>=200 &
      OVLP_REDIS_CBM008.CLASS_FLD_NBR<=203,
      OVLP_REDIS_CBM008.OVLP_PERCENT_TIME_REDIS,0))) as PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      INT(SUM(IFN((OVLP_REDIS_CBM008.CLASS_FLD_NBR>=300 &
      OVLP_REDIS_CBM008.CLASS_FLD_NBR<=399) |
      (OVLP_REDIS_CBM008.CLASS_FLD_NBR>=500 &
      OVLP_REDIS_CBM008.CLASS_FLD_NBR<=899) |
      OVLP_REDIS_CBM008.CLASS_FLD_NBR=997 |
      OVLP_REDIS_CBM008.CLASS_FLD_NBR>=999,
      OVLP_REDIS_CBM008.OVLP_PERCENT_TIME_REDIS,0))) as PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      INT(SUM(IFN(SUBSTR(OVLP_REDIS_CBM008.FUND_CODE,1,2)='21',
      OVLP_REDIS_CBM008.OVLP_ALLOC_REDIS,0))) as SALARY_A length = 8
         label = 'SALARY_A',
      INT(SUM(IFN(SUBSTR(OVLP_REDIS_CBM008.FUND_CODE,1,2) IN ('31','32'),
      OVLP_REDIS_CBM008.OVLP_ALLOC_REDIS,0))) as SALARY_D length = 8
         label = 'SALARY_D',
      INT(SUM(IFN(SUBSTR(OVLP_REDIS_CBM008.FUND_CODE,1,1)='4',
      OVLP_REDIS_CBM008.OVLP_ALLOC_REDIS,0))) as SALARY_X length = 8
         label = 'SALARY_X',
      INT(SUM(IFN(OVLP_REDIS_CBM008.FUND_CODE IN ('5100','5200','5300','5400','5500','5600'),
      OVLP_REDIS_CBM008.OVLP_ALLOC_REDIS,0))) as SALARY_R length = 8
         label = 'SALARY_R',
      INT(SUM(IFN(OVLP_REDIS_CBM008.FUND_CODE NOT IN ('5100','5200','5300','5400','5500','5600') &
      SUBSTR(OVLP_REDIS_CBM008.FUND_CODE,1,1)<>'4' &
      SUBSTR(OVLP_REDIS_CBM008.FUND_CODE,1,2) NOT IN ('21','31','32'),
      OVLP_REDIS_CBM008.OVLP_ALLOC_REDIS,0))) as SALARY_Z length = 8
         label = 'SALARY_Z',
      OVLP_REDIS_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      OVLP_REDIS_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      OVLP_REDIS_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      OVLP_REDIS_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      OVLP_REDIS_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      OVLP_REDIS_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      OVLP_REDIS_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      OVLP_REDIS_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      OVLP_REDIS_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      OVLP_REDIS_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      OVLP_REDIS_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      OVLP_REDIS_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      OVLP_REDIS_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      OVLP_REDIS_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      OVLP_REDIS_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.OVLP_REDIS_CBM008 as OVLP_REDIS_CBM008
   group by
      OVLP_REDIS_CBM008.SSN,
      OVLP_REDIS_CBM008.STRM
   ;
quit;

/*==========================================================================*
 * Step:            READ_4_ADDL_PAY                       A5B29B8Q.BZ0005OJ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_UTA_HR_ADDL_PAY_Extract -          A5B29B8Q.BE00007D *
 *                   ADWSTGPR.PS_UTA_HR_ADDL_PAY_Extract                    *
 *                  SALARY_AND_PCT_TIME_CBM008 -          A5B29B8Q.BS0001TF *
 *                   work.SALARY_AND_PCT_TIME_CBM008                        *
 * Target Table:    READ_4_ADDL_PAY_CBM008 -              A5B29B8Q.BS0001TG *
 *                   work.READ_4_ADDL_PAY_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OJ);

proc sql;
   create table work.READ_4_ADDL_PAY_CBM008 as
   select
      SALARY_AND_PCT_TIME_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      SALARY_AND_PCT_TIME_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      SALARY_AND_PCT_TIME_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      SALARY_AND_PCT_TIME_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      SALARY_AND_PCT_TIME_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      SALARY_AND_PCT_TIME_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      SALARY_AND_PCT_TIME_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      SALARY_AND_PCT_TIME_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      SALARY_AND_PCT_TIME_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      SALARY_AND_PCT_TIME_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      SALARY_AND_PCT_TIME_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      SALARY_AND_PCT_TIME_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      SALARY_AND_PCT_TIME_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      SALARY_AND_PCT_TIME_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      SALARY_AND_PCT_TIME_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      SALARY_AND_PCT_TIME_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      SALARY_AND_PCT_TIME_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      SALARY_AND_PCT_TIME_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      PS_UTA_HR_ADDL_PAY_Extract.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      PS_UTA_HR_ADDL_PAY_Extract.EFFDT as EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      PS_UTA_HR_ADDL_PAY_Extract.ACCT_CD as ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      PS_UTA_HR_ADDL_PAY_Extract.OTH_PAY as ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      SALARY_AND_PCT_TIME_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      SALARY_AND_PCT_TIME_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      SALARY_AND_PCT_TIME_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      SALARY_AND_PCT_TIME_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      SALARY_AND_PCT_TIME_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      SALARY_AND_PCT_TIME_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      SALARY_AND_PCT_TIME_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      SALARY_AND_PCT_TIME_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      SALARY_AND_PCT_TIME_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      SALARY_AND_PCT_TIME_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      SALARY_AND_PCT_TIME_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      SALARY_AND_PCT_TIME_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      SALARY_AND_PCT_TIME_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      SALARY_AND_PCT_TIME_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.SALARY_AND_PCT_TIME_CBM008 as SALARY_AND_PCT_TIME_CBM008 left join
      ADWSTGPR.PS_UTA_HR_ADDL_PAY_Extract as PS_UTA_HR_ADDL_PAY_Extract
         on
         (
            SALARY_AND_PCT_TIME_CBM008.CIT_CHK_EMPLID = PS_UTA_HR_ADDL_PAY_Extract.EMPLID
            and DATEPART(PS_UTA_HR_ADDL_PAY_Extract.EFFDT) >= INPUT(SALARY_AND_PCT_TIME_CBM008.APPT_BEGIN_DT,YYMMDD8.)
            and DATEPART(PS_UTA_HR_ADDL_PAY_Extract.EFFDT) <= INPUT(SALARY_AND_PCT_TIME_CBM008.APPT_END_DT,YYMMDD8.)
         )
   where
      SALARY_AND_PCT_TIME_CBM008.CIT_CHK_EMPLID NOT IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            JOB_MAX_EFFDT                         A5B29B8Q.BZ0005OK *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_JOB_Extract -                      A5B29B8Q.BE00004E *
 *                   ADWSTGPR.PS_JOB_Extract                                *
 * Target Table:    JOB_MAX_EFFDT_CBM008 -                A5B29B8Q.BS0001TH *
 *                   work.JOB_MAX_EFFDT_CBM008                              *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OK);

%let SYSLAST = %nrquote(ADWSTGPR.PS_JOB_Extract);

proc sql;
   create view work.JOB_MAX_EFFDT_CBM008 as
   select
      PS_JOB_Extract.ABSENCE_SYSTEM_CD length = 3
         format = $3.
         informat = $3.
         label = 'ABSENCE_SYSTEM_CD',
      PS_JOB_Extract.ACCDNT_CD_FRA length = 1
         format = $1.
         informat = $1.
         label = 'ACCDNT_CD_FRA',
      PS_JOB_Extract.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      PS_JOB_Extract.ACTION length = 3
         format = $3.
         informat = $3.
         label = 'ACTION',
      PS_JOB_Extract.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      PS_JOB_Extract.ACTION_REASON length = 3
         format = $3.
         informat = $3.
         label = 'ACTION_REASON',
      PS_JOB_Extract.ADDS_TO_FTE_ACTUAL length = 1
         format = $1.
         informat = $1.
         label = 'ADDS_TO_FTE_ACTUAL',
      PS_JOB_Extract.ANNL_BENEF_BASE_RT length = 8
         format = 20.3
         informat = 20.3
         label = 'ANNL_BENEF_BASE_RT',
      PS_JOB_Extract.ANNUAL_RT length = 8
         format = 20.3
         informat = 20.3
         label = 'ANNUAL_RT',
      PS_JOB_Extract.APPT_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'APPT_TYPE',
      PS_JOB_Extract.ASGN_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ASGN_END_DT',
      PS_JOB_Extract.ASGN_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ASGN_START_DT',
      PS_JOB_Extract.AUTO_END_FLG length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_END_FLG',
      PS_JOB_Extract.BARG_UNIT length = 4
         format = $4.
         informat = $4.
         label = 'BARG_UNIT',
      PS_JOB_Extract.BAS_ACTION length = 3
         format = $3.
         informat = $3.
         label = 'BAS_ACTION',
      PS_JOB_Extract.BAS_GROUP_ID length = 3
         format = $3.
         informat = $3.
         label = 'BAS_GROUP_ID',
      PS_JOB_Extract.BEN_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'BEN_STATUS',
      PS_JOB_Extract.BENEFIT_SYSTEM length = 2
         format = $2.
         informat = $2.
         label = 'BENEFIT_SYSTEM',
      PS_JOB_Extract.BORDER_WALKER length = 1
         format = $1.
         informat = $1.
         label = 'BORDER_WALKER',
      PS_JOB_Extract.BUSINESS_UNIT length = 5
         format = $5.
         informat = $5.
         label = 'BUSINESS_UNIT',
      PS_JOB_Extract.CHANGE_AMT length = 8
         format = 20.6
         informat = 20.6
         label = 'CHANGE_AMT',
      PS_JOB_Extract.CHANGE_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'CHANGE_PCT',
      PS_JOB_Extract.CLASS_INDC length = 1
         format = $1.
         informat = $1.
         label = 'CLASS_INDC',
      PS_JOB_Extract.COBRA_ACTION length = 3
         format = $3.
         informat = $3.
         label = 'COBRA_ACTION',
      PS_JOB_Extract.COMP_FREQUENCY length = 5
         format = $5.
         informat = $5.
         label = 'COMP_FREQUENCY',
      PS_JOB_Extract.COMPANY length = 3
         format = $3.
         informat = $3.
         label = 'COMPANY',
      PS_JOB_Extract.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      PS_JOB_Extract.CONTRACT_NUM length = 25
         format = $25.
         informat = $25.
         label = 'CONTRACT_NUM',
      PS_JOB_Extract.CTG_RATE length = 8
         label = 'CTG_RATE',
      PS_JOB_Extract.CUR_RT_TYPE length = 5
         format = $5.
         informat = $5.
         label = 'CUR_RT_TYPE',
      PS_JOB_Extract.CURRENCY_CD length = 3
         format = $3.
         informat = $3.
         label = 'CURRENCY_CD',
      PS_JOB_Extract.CURRENCY_CD1 length = 3
         format = $3.
         informat = $3.
         label = 'CURRENCY_CD1',
      PS_JOB_Extract.DAILY_RT length = 8
         format = 20.3
         informat = 20.3
         label = 'DAILY_RT',
      PS_JOB_Extract.DEPT_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEPT_ENTRY_DT',
      PS_JOB_Extract.DEPTID length = 10
         format = $10.
         informat = $10.
         label = 'DEPTID',
      PS_JOB_Extract.DIRECTLY_TIPPED length = 1
         format = $1.
         informat = $1.
         label = 'DIRECTLY_TIPPED',
      PS_JOB_Extract.EARNS_DIST_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'EARNS_DIST_TYPE',
      PS_JOB_Extract.EEO_CLASS length = 1
         format = $1.
         informat = $1.
         label = 'EEO_CLASS',
      PS_JOB_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_JOB_Extract.EFFSEQ length = 8
         label = 'EFFSEQ',
      PS_JOB_Extract.ELIG_CONFIG1 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG1',
      PS_JOB_Extract.ELIG_CONFIG2 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG2',
      PS_JOB_Extract.ELIG_CONFIG3 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG3',
      PS_JOB_Extract.ELIG_CONFIG4 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG4',
      PS_JOB_Extract.ELIG_CONFIG5 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG5',
      PS_JOB_Extract.ELIG_CONFIG6 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG6',
      PS_JOB_Extract.ELIG_CONFIG7 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG7',
      PS_JOB_Extract.ELIG_CONFIG8 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG8',
      PS_JOB_Extract.ELIG_CONFIG9 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG9',
      PS_JOB_Extract.EMPL_CLASS length = 3
         format = $3.
         informat = $3.
         label = 'EMPL_CLASS',
      PS_JOB_Extract.EMPL_CTG length = 6
         format = $6.
         informat = $6.
         label = 'EMPL_CTG',
      PS_JOB_Extract.EMPL_CTG_L1 length = 6
         format = $6.
         informat = $6.
         label = 'EMPL_CTG_L1',
      PS_JOB_Extract.EMPL_CTG_L2 length = 6
         format = $6.
         informat = $6.
         label = 'EMPL_CTG_L2',
      PS_JOB_Extract.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      PS_JOB_Extract.EMPL_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EMPL_STATUS',
      PS_JOB_Extract.EMPL_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'EMPL_TYPE',
      PS_JOB_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_JOB_Extract.ENCUMB_OVERRIDE length = 1
         format = $1.
         informat = $1.
         label = 'ENCUMB_OVERRIDE',
      PS_JOB_Extract.ENTRY_DATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENTRY_DATE',
      PS_JOB_Extract.ESTABID length = 12
         format = $12.
         informat = $12.
         label = 'ESTABID',
      PS_JOB_Extract.EXEMPT_HOURS_MONTH length = 8
         label = 'EXEMPT_HOURS_MONTH',
      PS_JOB_Extract.EXEMPT_JOB_LBR length = 1
         format = $1.
         informat = $1.
         label = 'EXEMPT_JOB_LBR',
      PS_JOB_Extract.EXPECTED_END_DATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EXPECTED_END_DATE',
      PS_JOB_Extract.EXPECTED_RETURN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EXPECTED_RETURN_DT',
      PS_JOB_Extract.FICA_STATUS_EE length = 1
         format = $1.
         informat = $1.
         label = 'FICA_STATUS_EE',
      PS_JOB_Extract.FLSA_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'FLSA_STATUS',
      PS_JOB_Extract.FORCE_PUBLISH length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'FORCE_PUBLISH',
      PS_JOB_Extract.FTE length = 8
         format = 9.6
         informat = 9.6
         label = 'FTE',
      PS_JOB_Extract.FULL_PART_TIME length = 1
         format = $1.
         informat = $1.
         label = 'FULL_PART_TIME',
      PS_JOB_Extract.FUNCTION_CD length = 2
         format = $2.
         informat = $2.
         label = 'FUNCTION_CD',
      PS_JOB_Extract.GL_PAY_TYPE length = 6
         format = $6.
         informat = $6.
         label = 'GL_PAY_TYPE',
      PS_JOB_Extract.GP_ASOF_DT_EXG_RT length = 1
         format = $1.
         informat = $1.
         label = 'GP_ASOF_DT_EXG_RT',
      PS_JOB_Extract.GP_DFLT_CURRTTYP length = 1
         format = $1.
         informat = $1.
         label = 'GP_DFLT_CURRTTYP',
      PS_JOB_Extract.GP_DFLT_ELIG_GRP length = 1
         format = $1.
         informat = $1.
         label = 'GP_DFLT_ELIG_GRP',
      PS_JOB_Extract.GP_DFLT_EXRTDT length = 1
         format = $1.
         informat = $1.
         label = 'GP_DFLT_EXRTDT',
      PS_JOB_Extract.GP_ELIG_GRP length = 10
         format = $10.
         informat = $10.
         label = 'GP_ELIG_GRP',
      PS_JOB_Extract.GP_PAYGROUP length = 10
         format = $10.
         informat = $10.
         label = 'GP_PAYGROUP',
      PS_JOB_Extract.GRADE length = 3
         format = $3.
         informat = $3.
         label = 'GRADE',
      PS_JOB_Extract.GRADE_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'GRADE_ENTRY_DT',
      PS_JOB_Extract.HIRE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'HIRE_DT',
      PS_JOB_Extract.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      PS_JOB_Extract.HOURLY_RT length = 8
         format = 20.6
         informat = 20.6
         label = 'HOURLY_RT',
      PS_JOB_Extract.HOURLY_RT_FRA length = 3
         format = $3.
         informat = $3.
         label = 'HOURLY_RT_FRA',
      PS_JOB_Extract.HR_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'HR_STATUS',
      PS_JOB_Extract.INTERCTR_WRKS_CNCL length = 1
         format = $1.
         informat = $1.
         label = 'INTERCTR_WRKS_CNCL',
      PS_JOB_Extract.JOB_DATA_SRC_CD length = 3
         format = $3.
         informat = $3.
         label = 'JOB_DATA_SRC_CD',
      PS_JOB_Extract.JOB_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'JOB_ENTRY_DT',
      PS_JOB_Extract.JOB_INDICATOR length = 1
         format = $1.
         informat = $1.
         label = 'JOB_INDICATOR',
      PS_JOB_Extract.JOBCODE length = 6
         format = $6.
         informat = $6.
         label = 'JOBCODE',
      PS_JOB_Extract.LABOR_AGREEMENT length = 6
         format = $6.
         informat = $6.
         label = 'LABOR_AGREEMENT',
      PS_JOB_Extract.LABOR_FACILITY_ID length = 10
         format = $10.
         informat = $10.
         label = 'LABOR_FACILITY_ID',
      PS_JOB_Extract.LABOR_TYPE_GER length = 1
         format = $1.
         informat = $1.
         label = 'LABOR_TYPE_GER',
      PS_JOB_Extract.LAST_DATE_WORKED length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_DATE_WORKED',
      PS_JOB_Extract.LAST_HIRE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_HIRE_DT',
      PS_JOB_Extract.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      PS_JOB_Extract.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      PS_JOB_Extract.LAYOFF_EXEMPT_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'LAYOFF_EXEMPT_FLAG',
      PS_JOB_Extract.LAYOFF_EXEMPT_RSN length = 11
         format = $11.
         informat = $11.
         label = 'LAYOFF_EXEMPT_RSN',
      PS_JOB_Extract.LBR_FAC_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LBR_FAC_ENTRY_DT',
      PS_JOB_Extract.LDW_OVR length = 1
         format = $1.
         informat = $1.
         label = 'LDW_OVR',
      PS_JOB_Extract.LOCATION length = 10
         format = $10.
         informat = $10.
         label = 'LOCATION',
      PS_JOB_Extract.LST_ASGN_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LST_ASGN_START_DT',
      PS_JOB_Extract.LUMP_SUM_PAY length = 1
         format = $1.
         informat = $1.
         label = 'LUMP_SUM_PAY',
      PS_JOB_Extract.MAIN_APPT_NUM_JPN length = 8
         label = 'MAIN_APPT_NUM_JPN',
      PS_JOB_Extract.MATRICULA_NBR length = 8
         label = 'MATRICULA_NBR',
      PS_JOB_Extract.MONTHLY_RT length = 8
         format = 20.3
         informat = 20.3
         label = 'MONTHLY_RT',
      PS_JOB_Extract.OFFICER_CD length = 1
         format = $1.
         informat = $1.
         label = 'OFFICER_CD',
      PS_JOB_Extract.PAID_FTE length = 8
         format = 9.6
         informat = 9.6
         label = 'PAID_FTE',
      PS_JOB_Extract.PAID_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'PAID_HOURS',
      PS_JOB_Extract.PAID_HRS_FREQUENCY length = 5
         format = $5.
         informat = $5.
         label = 'PAID_HRS_FREQUENCY',
      PS_JOB_Extract.PAY_SYSTEM_FLG length = 2
         format = $2.
         informat = $2.
         label = 'PAY_SYSTEM_FLG',
      PS_JOB_Extract.PAY_UNION_FEE length = 1
         format = $1.
         informat = $1.
         label = 'PAY_UNION_FEE',
      PS_JOB_Extract.PAYGROUP length = 3
         format = $3.
         informat = $3.
         label = 'PAYGROUP',
      PS_JOB_Extract.PER_ORG length = 3
         format = $3.
         informat = $3.
         label = 'PER_ORG',
      PS_JOB_Extract.PERFORM_GROUP_GER length = 2
         format = $2.
         informat = $2.
         label = 'PERFORM_GROUP_GER',
      PS_JOB_Extract.POI_TYPE length = 5
         format = $5.
         informat = $5.
         label = 'POI_TYPE',
      PS_JOB_Extract.POSITION_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'POSITION_ENTRY_DT',
      PS_JOB_Extract.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      PS_JOB_Extract.POSITION_OVERRIDE length = 1
         format = $1.
         informat = $1.
         label = 'POSITION_OVERRIDE',
      PS_JOB_Extract.POSN_CHANGE_RECORD length = 1
         format = $1.
         informat = $1.
         label = 'POSN_CHANGE_RECORD',
      PS_JOB_Extract.PRORATE_CNT_AMT length = 1
         format = $1.
         informat = $1.
         label = 'PRORATE_CNT_AMT',
      PS_JOB_Extract.REG_REGION length = 5
         format = $5.
         informat = $5.
         label = 'REG_REGION',
      PS_JOB_Extract.REG_TEMP length = 1
         format = $1.
         informat = $1.
         label = 'REG_TEMP',
      PS_JOB_Extract.REPORTS_TO length = 8
         format = $8.
         informat = $8.
         label = 'REPORTS_TO',
      PS_JOB_Extract.SAL_ADMIN_PLAN length = 4
         format = $4.
         informat = $4.
         label = 'SAL_ADMIN_PLAN',
      PS_JOB_Extract.SETID_DEPT length = 5
         format = $5.
         informat = $5.
         label = 'SETID_DEPT',
      PS_JOB_Extract.SETID_EMPL_CLASS length = 5
         format = $5.
         informat = $5.
         label = 'SETID_EMPL_CLASS',
      PS_JOB_Extract.SETID_JOBCODE length = 5
         format = $5.
         informat = $5.
         label = 'SETID_JOBCODE',
      PS_JOB_Extract.SETID_LBR_AGRMNT length = 5
         format = $5.
         informat = $5.
         label = 'SETID_LBR_AGRMNT',
      PS_JOB_Extract.SETID_LOCATION length = 5
         format = $5.
         informat = $5.
         label = 'SETID_LOCATION',
      PS_JOB_Extract.SETID_SALARY length = 5
         format = $5.
         informat = $5.
         label = 'SETID_SALARY',
      PS_JOB_Extract.SETID_SUPV_LVL length = 5
         format = $5.
         informat = $5.
         label = 'SETID_SUPV_LVL',
      PS_JOB_Extract.SHIFT length = 1
         format = $1.
         informat = $1.
         label = 'SHIFT',
      PS_JOB_Extract.SHIFT_FACTOR length = 8
         format = 6.3
         informat = 6.3
         label = 'SHIFT_FACTOR',
      PS_JOB_Extract.SHIFT_RT length = 8
         format = 20.6
         informat = 20.6
         label = 'SHIFT_RT',
      PS_JOB_Extract.SOC_SEC_RISK_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SOC_SEC_RISK_CODE',
      PS_JOB_Extract.SPK_COMM_ID_GER length = 9
         format = $9.
         informat = $9.
         label = 'SPK_COMM_ID_GER',
      PS_JOB_Extract.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      PS_JOB_Extract.STD_HRS_FREQUENCY length = 5
         format = $5.
         informat = $5.
         label = 'STD_HRS_FREQUENCY',
      PS_JOB_Extract.STEP length = 8
         label = 'STEP',
      PS_JOB_Extract.STEP_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'STEP_ENTRY_DT',
      PS_JOB_Extract.SUPERVISOR_ID length = 11
         format = $11.
         informat = $11.
         label = 'SUPERVISOR_ID',
      PS_JOB_Extract.SUPV_LVL_ID length = 8
         format = $8.
         informat = $8.
         label = 'SUPV_LVL_ID',
      PS_JOB_Extract.TARIFF_AREA_GER length = 3
         format = $3.
         informat = $3.
         label = 'TARIFF_AREA_GER',
      PS_JOB_Extract.TARIFF_GER length = 2
         format = $2.
         informat = $2.
         label = 'TARIFF_GER',
      PS_JOB_Extract.TAX_LOCATION_CD length = 10
         format = $10.
         informat = $10.
         label = 'TAX_LOCATION_CD',
      PS_JOB_Extract.TERMINATION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERMINATION_DT',
      PS_JOB_Extract.UNION_CD length = 3
         format = $3.
         informat = $3.
         label = 'UNION_CD',
      PS_JOB_Extract.UNION_FEE_AMOUNT length = 8
         format = 10.2
         informat = 10.2
         label = 'UNION_FEE_AMOUNT',
      PS_JOB_Extract.UNION_FEE_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UNION_FEE_END_DT',
      PS_JOB_Extract.UNION_FEE_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UNION_FEE_START_DT',
      PS_JOB_Extract.UNION_FULL_PART length = 1
         format = $1.
         informat = $1.
         label = 'UNION_FULL_PART',
      PS_JOB_Extract.UNION_POS length = 1
         format = $1.
         informat = $1.
         label = 'UNION_POS',
      PS_JOB_Extract.UNION_SENIORITY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UNION_SENIORITY_DT',
      PS_JOB_Extract.VALUE_1_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_1_FRA',
      PS_JOB_Extract.VALUE_2_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_2_FRA',
      PS_JOB_Extract.VALUE_3_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_3_FRA',
      PS_JOB_Extract.VALUE_4_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_4_FRA',
      PS_JOB_Extract.VALUE_5_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_5_FRA',
      PS_JOB_Extract.WORK_DAY_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'WORK_DAY_HOURS',
      PS_JOB_Extract.WPP_STOP_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'WPP_STOP_FLAG',
      PS_JOB_Extract.WRKS_CNCL_FUNCTION length = 1
         format = $1.
         informat = $1.
         label = 'WRKS_CNCL_FUNCTION',
      PS_JOB_Extract.WRKS_CNCL_ROLE_CHE length = 30
         format = $30.
         informat = $30.
         label = 'WRKS_CNCL_ROLE_CHE'
   from
      ADWSTGPR.PS_JOB_Extract as PS_JOB_Extract
   where
      PS_JOB_Extract.COMPANY = 'ARL'
      and PS_JOB_Extract.EFFDT <= DATETIME()
   group by
      PS_JOB_Extract.EMPLID,
      PS_JOB_Extract.EMPL_RCD
   having
      PS_JOB_Extract.EFFDT = MAX(PS_JOB_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            JOB_MAX_EFFSEQ                        A5B29B8Q.BZ0005OL *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    JOB_MAX_EFFDT_CBM008 -                A5B29B8Q.BS0001TH *
 *                   work.JOB_MAX_EFFDT_CBM008                              *
 * Target Table:    JOB_MAX_EFFSEQ_CBM008 -               A5B29B8Q.BS0001TI *
 *                   work.JOB_MAX_EFFSEQ_CBM008                             *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OL);

%let SYSLAST = %nrquote(work.JOB_MAX_EFFDT_CBM008);

proc sql;
   create view work.JOB_MAX_EFFSEQ_CBM008 as
   select
      JOB_MAX_EFFDT_CBM008.ABSENCE_SYSTEM_CD length = 3
         format = $3.
         informat = $3.
         label = 'ABSENCE_SYSTEM_CD',
      JOB_MAX_EFFDT_CBM008.ACCDNT_CD_FRA length = 1
         format = $1.
         informat = $1.
         label = 'ACCDNT_CD_FRA',
      JOB_MAX_EFFDT_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      JOB_MAX_EFFDT_CBM008.ACTION length = 3
         format = $3.
         informat = $3.
         label = 'ACTION',
      JOB_MAX_EFFDT_CBM008.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      JOB_MAX_EFFDT_CBM008.ACTION_REASON length = 3
         format = $3.
         informat = $3.
         label = 'ACTION_REASON',
      JOB_MAX_EFFDT_CBM008.ADDS_TO_FTE_ACTUAL length = 1
         format = $1.
         informat = $1.
         label = 'ADDS_TO_FTE_ACTUAL',
      JOB_MAX_EFFDT_CBM008.ANNL_BENEF_BASE_RT length = 8
         format = 20.3
         informat = 20.3
         label = 'ANNL_BENEF_BASE_RT',
      JOB_MAX_EFFDT_CBM008.ANNUAL_RT length = 8
         format = 20.3
         informat = 20.3
         label = 'ANNUAL_RT',
      JOB_MAX_EFFDT_CBM008.APPT_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'APPT_TYPE',
      JOB_MAX_EFFDT_CBM008.ASGN_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ASGN_END_DT',
      JOB_MAX_EFFDT_CBM008.ASGN_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ASGN_START_DT',
      JOB_MAX_EFFDT_CBM008.AUTO_END_FLG length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_END_FLG',
      JOB_MAX_EFFDT_CBM008.BARG_UNIT length = 4
         format = $4.
         informat = $4.
         label = 'BARG_UNIT',
      JOB_MAX_EFFDT_CBM008.BAS_ACTION length = 3
         format = $3.
         informat = $3.
         label = 'BAS_ACTION',
      JOB_MAX_EFFDT_CBM008.BAS_GROUP_ID length = 3
         format = $3.
         informat = $3.
         label = 'BAS_GROUP_ID',
      JOB_MAX_EFFDT_CBM008.BEN_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'BEN_STATUS',
      JOB_MAX_EFFDT_CBM008.BENEFIT_SYSTEM length = 2
         format = $2.
         informat = $2.
         label = 'BENEFIT_SYSTEM',
      JOB_MAX_EFFDT_CBM008.BORDER_WALKER length = 1
         format = $1.
         informat = $1.
         label = 'BORDER_WALKER',
      JOB_MAX_EFFDT_CBM008.BUSINESS_UNIT length = 5
         format = $5.
         informat = $5.
         label = 'BUSINESS_UNIT',
      JOB_MAX_EFFDT_CBM008.CHANGE_AMT length = 8
         format = 20.6
         informat = 20.6
         label = 'CHANGE_AMT',
      JOB_MAX_EFFDT_CBM008.CHANGE_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'CHANGE_PCT',
      JOB_MAX_EFFDT_CBM008.CLASS_INDC length = 1
         format = $1.
         informat = $1.
         label = 'CLASS_INDC',
      JOB_MAX_EFFDT_CBM008.COBRA_ACTION length = 3
         format = $3.
         informat = $3.
         label = 'COBRA_ACTION',
      JOB_MAX_EFFDT_CBM008.COMP_FREQUENCY length = 5
         format = $5.
         informat = $5.
         label = 'COMP_FREQUENCY',
      JOB_MAX_EFFDT_CBM008.COMPANY length = 3
         format = $3.
         informat = $3.
         label = 'COMPANY',
      JOB_MAX_EFFDT_CBM008.COMPRATE length = 8
         format = 20.6
         informat = 20.6
         label = 'COMPRATE',
      JOB_MAX_EFFDT_CBM008.CONTRACT_NUM length = 25
         format = $25.
         informat = $25.
         label = 'CONTRACT_NUM',
      JOB_MAX_EFFDT_CBM008.CTG_RATE length = 8
         label = 'CTG_RATE',
      JOB_MAX_EFFDT_CBM008.CUR_RT_TYPE length = 5
         format = $5.
         informat = $5.
         label = 'CUR_RT_TYPE',
      JOB_MAX_EFFDT_CBM008.CURRENCY_CD length = 3
         format = $3.
         informat = $3.
         label = 'CURRENCY_CD',
      JOB_MAX_EFFDT_CBM008.CURRENCY_CD1 length = 3
         format = $3.
         informat = $3.
         label = 'CURRENCY_CD1',
      JOB_MAX_EFFDT_CBM008.DAILY_RT length = 8
         format = 20.3
         informat = 20.3
         label = 'DAILY_RT',
      JOB_MAX_EFFDT_CBM008.DEPT_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEPT_ENTRY_DT',
      JOB_MAX_EFFDT_CBM008.DEPTID length = 10
         format = $10.
         informat = $10.
         label = 'DEPTID',
      JOB_MAX_EFFDT_CBM008.DIRECTLY_TIPPED length = 1
         format = $1.
         informat = $1.
         label = 'DIRECTLY_TIPPED',
      JOB_MAX_EFFDT_CBM008.EARNS_DIST_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'EARNS_DIST_TYPE',
      JOB_MAX_EFFDT_CBM008.EEO_CLASS length = 1
         format = $1.
         informat = $1.
         label = 'EEO_CLASS',
      JOB_MAX_EFFDT_CBM008.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      JOB_MAX_EFFDT_CBM008.EFFSEQ length = 8
         label = 'EFFSEQ',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG1 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG1',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG2 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG2',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG3 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG3',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG4 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG4',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG5 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG5',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG6 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG6',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG7 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG7',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG8 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG8',
      JOB_MAX_EFFDT_CBM008.ELIG_CONFIG9 length = 10
         format = $10.
         informat = $10.
         label = 'ELIG_CONFIG9',
      JOB_MAX_EFFDT_CBM008.EMPL_CLASS length = 3
         format = $3.
         informat = $3.
         label = 'EMPL_CLASS',
      JOB_MAX_EFFDT_CBM008.EMPL_CTG length = 6
         format = $6.
         informat = $6.
         label = 'EMPL_CTG',
      JOB_MAX_EFFDT_CBM008.EMPL_CTG_L1 length = 6
         format = $6.
         informat = $6.
         label = 'EMPL_CTG_L1',
      JOB_MAX_EFFDT_CBM008.EMPL_CTG_L2 length = 6
         format = $6.
         informat = $6.
         label = 'EMPL_CTG_L2',
      JOB_MAX_EFFDT_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      JOB_MAX_EFFDT_CBM008.EMPL_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EMPL_STATUS',
      JOB_MAX_EFFDT_CBM008.EMPL_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'EMPL_TYPE',
      JOB_MAX_EFFDT_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      JOB_MAX_EFFDT_CBM008.ENCUMB_OVERRIDE length = 1
         format = $1.
         informat = $1.
         label = 'ENCUMB_OVERRIDE',
      JOB_MAX_EFFDT_CBM008.ENTRY_DATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENTRY_DATE',
      JOB_MAX_EFFDT_CBM008.ESTABID length = 12
         format = $12.
         informat = $12.
         label = 'ESTABID',
      JOB_MAX_EFFDT_CBM008.EXEMPT_HOURS_MONTH length = 8
         label = 'EXEMPT_HOURS_MONTH',
      JOB_MAX_EFFDT_CBM008.EXEMPT_JOB_LBR length = 1
         format = $1.
         informat = $1.
         label = 'EXEMPT_JOB_LBR',
      JOB_MAX_EFFDT_CBM008.EXPECTED_END_DATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EXPECTED_END_DATE',
      JOB_MAX_EFFDT_CBM008.EXPECTED_RETURN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EXPECTED_RETURN_DT',
      JOB_MAX_EFFDT_CBM008.FICA_STATUS_EE length = 1
         format = $1.
         informat = $1.
         label = 'FICA_STATUS_EE',
      JOB_MAX_EFFDT_CBM008.FLSA_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'FLSA_STATUS',
      JOB_MAX_EFFDT_CBM008.FORCE_PUBLISH length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'FORCE_PUBLISH',
      JOB_MAX_EFFDT_CBM008.FTE length = 8
         format = 9.6
         informat = 9.6
         label = 'FTE',
      JOB_MAX_EFFDT_CBM008.FULL_PART_TIME length = 1
         format = $1.
         informat = $1.
         label = 'FULL_PART_TIME',
      JOB_MAX_EFFDT_CBM008.FUNCTION_CD length = 2
         format = $2.
         informat = $2.
         label = 'FUNCTION_CD',
      JOB_MAX_EFFDT_CBM008.GL_PAY_TYPE length = 6
         format = $6.
         informat = $6.
         label = 'GL_PAY_TYPE',
      JOB_MAX_EFFDT_CBM008.GP_ASOF_DT_EXG_RT length = 1
         format = $1.
         informat = $1.
         label = 'GP_ASOF_DT_EXG_RT',
      JOB_MAX_EFFDT_CBM008.GP_DFLT_CURRTTYP length = 1
         format = $1.
         informat = $1.
         label = 'GP_DFLT_CURRTTYP',
      JOB_MAX_EFFDT_CBM008.GP_DFLT_ELIG_GRP length = 1
         format = $1.
         informat = $1.
         label = 'GP_DFLT_ELIG_GRP',
      JOB_MAX_EFFDT_CBM008.GP_DFLT_EXRTDT length = 1
         format = $1.
         informat = $1.
         label = 'GP_DFLT_EXRTDT',
      JOB_MAX_EFFDT_CBM008.GP_ELIG_GRP length = 10
         format = $10.
         informat = $10.
         label = 'GP_ELIG_GRP',
      JOB_MAX_EFFDT_CBM008.GP_PAYGROUP length = 10
         format = $10.
         informat = $10.
         label = 'GP_PAYGROUP',
      JOB_MAX_EFFDT_CBM008.GRADE length = 3
         format = $3.
         informat = $3.
         label = 'GRADE',
      JOB_MAX_EFFDT_CBM008.GRADE_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'GRADE_ENTRY_DT',
      JOB_MAX_EFFDT_CBM008.HIRE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'HIRE_DT',
      JOB_MAX_EFFDT_CBM008.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      JOB_MAX_EFFDT_CBM008.HOURLY_RT length = 8
         format = 20.6
         informat = 20.6
         label = 'HOURLY_RT',
      JOB_MAX_EFFDT_CBM008.HOURLY_RT_FRA length = 3
         format = $3.
         informat = $3.
         label = 'HOURLY_RT_FRA',
      JOB_MAX_EFFDT_CBM008.HR_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'HR_STATUS',
      JOB_MAX_EFFDT_CBM008.INTERCTR_WRKS_CNCL length = 1
         format = $1.
         informat = $1.
         label = 'INTERCTR_WRKS_CNCL',
      JOB_MAX_EFFDT_CBM008.JOB_DATA_SRC_CD length = 3
         format = $3.
         informat = $3.
         label = 'JOB_DATA_SRC_CD',
      JOB_MAX_EFFDT_CBM008.JOB_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'JOB_ENTRY_DT',
      JOB_MAX_EFFDT_CBM008.JOB_INDICATOR length = 1
         format = $1.
         informat = $1.
         label = 'JOB_INDICATOR',
      JOB_MAX_EFFDT_CBM008.JOBCODE length = 6
         format = $6.
         informat = $6.
         label = 'JOBCODE',
      JOB_MAX_EFFDT_CBM008.LABOR_AGREEMENT length = 6
         format = $6.
         informat = $6.
         label = 'LABOR_AGREEMENT',
      JOB_MAX_EFFDT_CBM008.LABOR_FACILITY_ID length = 10
         format = $10.
         informat = $10.
         label = 'LABOR_FACILITY_ID',
      JOB_MAX_EFFDT_CBM008.LABOR_TYPE_GER length = 1
         format = $1.
         informat = $1.
         label = 'LABOR_TYPE_GER',
      JOB_MAX_EFFDT_CBM008.LAST_DATE_WORKED length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_DATE_WORKED',
      JOB_MAX_EFFDT_CBM008.LAST_HIRE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_HIRE_DT',
      JOB_MAX_EFFDT_CBM008.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      JOB_MAX_EFFDT_CBM008.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      JOB_MAX_EFFDT_CBM008.LAYOFF_EXEMPT_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'LAYOFF_EXEMPT_FLAG',
      JOB_MAX_EFFDT_CBM008.LAYOFF_EXEMPT_RSN length = 11
         format = $11.
         informat = $11.
         label = 'LAYOFF_EXEMPT_RSN',
      JOB_MAX_EFFDT_CBM008.LBR_FAC_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LBR_FAC_ENTRY_DT',
      JOB_MAX_EFFDT_CBM008.LDW_OVR length = 1
         format = $1.
         informat = $1.
         label = 'LDW_OVR',
      JOB_MAX_EFFDT_CBM008.LOCATION length = 10
         format = $10.
         informat = $10.
         label = 'LOCATION',
      JOB_MAX_EFFDT_CBM008.LST_ASGN_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LST_ASGN_START_DT',
      JOB_MAX_EFFDT_CBM008.LUMP_SUM_PAY length = 1
         format = $1.
         informat = $1.
         label = 'LUMP_SUM_PAY',
      JOB_MAX_EFFDT_CBM008.MAIN_APPT_NUM_JPN length = 8
         label = 'MAIN_APPT_NUM_JPN',
      JOB_MAX_EFFDT_CBM008.MATRICULA_NBR length = 8
         label = 'MATRICULA_NBR',
      JOB_MAX_EFFDT_CBM008.MONTHLY_RT length = 8
         format = 20.3
         informat = 20.3
         label = 'MONTHLY_RT',
      JOB_MAX_EFFDT_CBM008.OFFICER_CD length = 1
         format = $1.
         informat = $1.
         label = 'OFFICER_CD',
      JOB_MAX_EFFDT_CBM008.PAID_FTE length = 8
         format = 9.6
         informat = 9.6
         label = 'PAID_FTE',
      JOB_MAX_EFFDT_CBM008.PAID_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'PAID_HOURS',
      JOB_MAX_EFFDT_CBM008.PAID_HRS_FREQUENCY length = 5
         format = $5.
         informat = $5.
         label = 'PAID_HRS_FREQUENCY',
      JOB_MAX_EFFDT_CBM008.PAY_SYSTEM_FLG length = 2
         format = $2.
         informat = $2.
         label = 'PAY_SYSTEM_FLG',
      JOB_MAX_EFFDT_CBM008.PAY_UNION_FEE length = 1
         format = $1.
         informat = $1.
         label = 'PAY_UNION_FEE',
      JOB_MAX_EFFDT_CBM008.PAYGROUP length = 3
         format = $3.
         informat = $3.
         label = 'PAYGROUP',
      JOB_MAX_EFFDT_CBM008.PER_ORG length = 3
         format = $3.
         informat = $3.
         label = 'PER_ORG',
      JOB_MAX_EFFDT_CBM008.PERFORM_GROUP_GER length = 2
         format = $2.
         informat = $2.
         label = 'PERFORM_GROUP_GER',
      JOB_MAX_EFFDT_CBM008.POI_TYPE length = 5
         format = $5.
         informat = $5.
         label = 'POI_TYPE',
      JOB_MAX_EFFDT_CBM008.POSITION_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'POSITION_ENTRY_DT',
      JOB_MAX_EFFDT_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      JOB_MAX_EFFDT_CBM008.POSITION_OVERRIDE length = 1
         format = $1.
         informat = $1.
         label = 'POSITION_OVERRIDE',
      JOB_MAX_EFFDT_CBM008.POSN_CHANGE_RECORD length = 1
         format = $1.
         informat = $1.
         label = 'POSN_CHANGE_RECORD',
      JOB_MAX_EFFDT_CBM008.PRORATE_CNT_AMT length = 1
         format = $1.
         informat = $1.
         label = 'PRORATE_CNT_AMT',
      JOB_MAX_EFFDT_CBM008.REG_REGION length = 5
         format = $5.
         informat = $5.
         label = 'REG_REGION',
      JOB_MAX_EFFDT_CBM008.REG_TEMP length = 1
         format = $1.
         informat = $1.
         label = 'REG_TEMP',
      JOB_MAX_EFFDT_CBM008.REPORTS_TO length = 8
         format = $8.
         informat = $8.
         label = 'REPORTS_TO',
      JOB_MAX_EFFDT_CBM008.SAL_ADMIN_PLAN length = 4
         format = $4.
         informat = $4.
         label = 'SAL_ADMIN_PLAN',
      JOB_MAX_EFFDT_CBM008.SETID_DEPT length = 5
         format = $5.
         informat = $5.
         label = 'SETID_DEPT',
      JOB_MAX_EFFDT_CBM008.SETID_EMPL_CLASS length = 5
         format = $5.
         informat = $5.
         label = 'SETID_EMPL_CLASS',
      JOB_MAX_EFFDT_CBM008.SETID_JOBCODE length = 5
         format = $5.
         informat = $5.
         label = 'SETID_JOBCODE',
      JOB_MAX_EFFDT_CBM008.SETID_LBR_AGRMNT length = 5
         format = $5.
         informat = $5.
         label = 'SETID_LBR_AGRMNT',
      JOB_MAX_EFFDT_CBM008.SETID_LOCATION length = 5
         format = $5.
         informat = $5.
         label = 'SETID_LOCATION',
      JOB_MAX_EFFDT_CBM008.SETID_SALARY length = 5
         format = $5.
         informat = $5.
         label = 'SETID_SALARY',
      JOB_MAX_EFFDT_CBM008.SETID_SUPV_LVL length = 5
         format = $5.
         informat = $5.
         label = 'SETID_SUPV_LVL',
      JOB_MAX_EFFDT_CBM008.SHIFT length = 1
         format = $1.
         informat = $1.
         label = 'SHIFT',
      JOB_MAX_EFFDT_CBM008.SHIFT_FACTOR length = 8
         format = 6.3
         informat = 6.3
         label = 'SHIFT_FACTOR',
      JOB_MAX_EFFDT_CBM008.SHIFT_RT length = 8
         format = 20.6
         informat = 20.6
         label = 'SHIFT_RT',
      JOB_MAX_EFFDT_CBM008.SOC_SEC_RISK_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SOC_SEC_RISK_CODE',
      JOB_MAX_EFFDT_CBM008.SPK_COMM_ID_GER length = 9
         format = $9.
         informat = $9.
         label = 'SPK_COMM_ID_GER',
      JOB_MAX_EFFDT_CBM008.STD_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'STD_HOURS',
      JOB_MAX_EFFDT_CBM008.STD_HRS_FREQUENCY length = 5
         format = $5.
         informat = $5.
         label = 'STD_HRS_FREQUENCY',
      JOB_MAX_EFFDT_CBM008.STEP length = 8
         label = 'STEP',
      JOB_MAX_EFFDT_CBM008.STEP_ENTRY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'STEP_ENTRY_DT',
      JOB_MAX_EFFDT_CBM008.SUPERVISOR_ID length = 11
         format = $11.
         informat = $11.
         label = 'SUPERVISOR_ID',
      JOB_MAX_EFFDT_CBM008.SUPV_LVL_ID length = 8
         format = $8.
         informat = $8.
         label = 'SUPV_LVL_ID',
      JOB_MAX_EFFDT_CBM008.TARIFF_AREA_GER length = 3
         format = $3.
         informat = $3.
         label = 'TARIFF_AREA_GER',
      JOB_MAX_EFFDT_CBM008.TARIFF_GER length = 2
         format = $2.
         informat = $2.
         label = 'TARIFF_GER',
      JOB_MAX_EFFDT_CBM008.TAX_LOCATION_CD length = 10
         format = $10.
         informat = $10.
         label = 'TAX_LOCATION_CD',
      JOB_MAX_EFFDT_CBM008.TERMINATION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERMINATION_DT',
      JOB_MAX_EFFDT_CBM008.UNION_CD length = 3
         format = $3.
         informat = $3.
         label = 'UNION_CD',
      JOB_MAX_EFFDT_CBM008.UNION_FEE_AMOUNT length = 8
         format = 10.2
         informat = 10.2
         label = 'UNION_FEE_AMOUNT',
      JOB_MAX_EFFDT_CBM008.UNION_FEE_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UNION_FEE_END_DT',
      JOB_MAX_EFFDT_CBM008.UNION_FEE_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UNION_FEE_START_DT',
      JOB_MAX_EFFDT_CBM008.UNION_FULL_PART length = 1
         format = $1.
         informat = $1.
         label = 'UNION_FULL_PART',
      JOB_MAX_EFFDT_CBM008.UNION_POS length = 1
         format = $1.
         informat = $1.
         label = 'UNION_POS',
      JOB_MAX_EFFDT_CBM008.UNION_SENIORITY_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UNION_SENIORITY_DT',
      JOB_MAX_EFFDT_CBM008.VALUE_1_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_1_FRA',
      JOB_MAX_EFFDT_CBM008.VALUE_2_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_2_FRA',
      JOB_MAX_EFFDT_CBM008.VALUE_3_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_3_FRA',
      JOB_MAX_EFFDT_CBM008.VALUE_4_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_4_FRA',
      JOB_MAX_EFFDT_CBM008.VALUE_5_FRA length = 5
         format = $5.
         informat = $5.
         label = 'VALUE_5_FRA',
      JOB_MAX_EFFDT_CBM008.WORK_DAY_HOURS length = 8
         format = 8.2
         informat = 8.2
         label = 'WORK_DAY_HOURS',
      JOB_MAX_EFFDT_CBM008.WPP_STOP_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'WPP_STOP_FLAG',
      JOB_MAX_EFFDT_CBM008.WRKS_CNCL_FUNCTION length = 1
         format = $1.
         informat = $1.
         label = 'WRKS_CNCL_FUNCTION',
      JOB_MAX_EFFDT_CBM008.WRKS_CNCL_ROLE_CHE length = 30
         format = $30.
         informat = $30.
         label = 'WRKS_CNCL_ROLE_CHE'
   from
      work.JOB_MAX_EFFDT_CBM008 as JOB_MAX_EFFDT_CBM008
   group by
      JOB_MAX_EFFDT_CBM008.EMPLID,
      JOB_MAX_EFFDT_CBM008.EMPL_RCD
   having
      JOB_MAX_EFFDT_CBM008.EFFSEQ = MAX(JOB_MAX_EFFDT_CBM008.EFFSEQ)
   ;
quit;

/*==========================================================================*
 * Step:            READ_4_JOB_ACCT_CD                    A5B29B8Q.BZ0005OM *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_4_ADDL_PAY_CBM008 -              A5B29B8Q.BS0001TG *
 *                   work.READ_4_ADDL_PAY_CBM008                            *
 *                  JOB_MAX_EFFSEQ_CBM008 -               A5B29B8Q.BS0001TI *
 *                   work.JOB_MAX_EFFSEQ_CBM008                             *
 * Target Table:    READ_4_JOB_ACCT_CD_CBM008 -           A5B29B8Q.BS0001TJ *
 *                   work.READ_4_JOB_ACCT_CD_CBM008                         *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OM);

proc sql;
   create table work.READ_4_JOB_ACCT_CD_CBM008 as
   select
      READ_4_ADDL_PAY_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_4_ADDL_PAY_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_ADDL_PAY_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      READ_4_ADDL_PAY_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      READ_4_ADDL_PAY_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_4_ADDL_PAY_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_4_ADDL_PAY_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_4_ADDL_PAY_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      READ_4_ADDL_PAY_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      READ_4_ADDL_PAY_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      READ_4_ADDL_PAY_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      READ_4_ADDL_PAY_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      READ_4_ADDL_PAY_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      READ_4_ADDL_PAY_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      READ_4_ADDL_PAY_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      READ_4_ADDL_PAY_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      READ_4_ADDL_PAY_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_4_ADDL_PAY_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      READ_4_ADDL_PAY_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      READ_4_ADDL_PAY_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      READ_4_ADDL_PAY_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      JOB_MAX_EFFSEQ_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_4_ADDL_PAY_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      READ_4_ADDL_PAY_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_4_ADDL_PAY_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_4_ADDL_PAY_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_4_ADDL_PAY_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      READ_4_ADDL_PAY_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_4_ADDL_PAY_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      READ_4_ADDL_PAY_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.READ_4_ADDL_PAY_CBM008 as READ_4_ADDL_PAY_CBM008 left join
      work.JOB_MAX_EFFSEQ_CBM008 as JOB_MAX_EFFSEQ_CBM008
         on
         (
            READ_4_ADDL_PAY_CBM008.CIT_CHK_EMPLID = JOB_MAX_EFFSEQ_CBM008.EMPLID
            and READ_4_ADDL_PAY_CBM008.EMPL_RCD = JOB_MAX_EFFSEQ_CBM008.EMPL_RCD
         )
   where
      READ_4_ADDL_PAY_CBM008.ADDL_PAY_ACCT_CD IS MISSING
      or STRIP(READ_4_ADDL_PAY_CBM008.ADDL_PAY_ACCT_CD) = ''
   ;
quit;

/*==========================================================================*
 * Step:            ADDL_READ_4_ACCT_CD                   A5B29B8Q.BZ0005ON *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_4_JOB_ACCT_CD_CBM008 -           A5B29B8Q.BS0001TJ *
 *                   work.READ_4_JOB_ACCT_CD_CBM008                         *
 *                  DEPTBDGT_ER_MAX_EFFSEQ_CBM008 -       A5B29B8Q.BS0001T2 *
 *                   work.DEPTBDGT_ER_MAX_EFFSEQ_CBM008                     *
 * Target Table:    ADDL_READ_4_ACCT_CD_CBM008 -          A5B29B8Q.BS0001TK *
 *                   work.ADDL_READ_4_ACCT_CD_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005ON);

proc sql;
   create view work.ADDL_READ_4_ACCT_CD_CBM008 as
   select
      READ_4_JOB_ACCT_CD_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_4_JOB_ACCT_CD_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_JOB_ACCT_CD_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      READ_4_JOB_ACCT_CD_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      READ_4_JOB_ACCT_CD_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_JOB_ACCT_CD_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_4_JOB_ACCT_CD_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_4_JOB_ACCT_CD_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_4_JOB_ACCT_CD_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      READ_4_JOB_ACCT_CD_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      READ_4_JOB_ACCT_CD_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      READ_4_JOB_ACCT_CD_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      READ_4_JOB_ACCT_CD_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      READ_4_JOB_ACCT_CD_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      READ_4_JOB_ACCT_CD_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      READ_4_JOB_ACCT_CD_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      READ_4_JOB_ACCT_CD_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      READ_4_JOB_ACCT_CD_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_4_JOB_ACCT_CD_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      READ_4_JOB_ACCT_CD_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      READ_4_JOB_ACCT_CD_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      READ_4_JOB_ACCT_CD_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      READ_4_JOB_ACCT_CD_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_4_JOB_ACCT_CD_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      DEPTBDGT_ER_MAX_EFFSEQ_CBM008.ACCT_CD as ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      DEPTBDGT_ER_MAX_EFFSEQ_CBM008.DIST_PCT as DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      READ_4_JOB_ACCT_CD_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      READ_4_JOB_ACCT_CD_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_4_JOB_ACCT_CD_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_4_JOB_ACCT_CD_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_4_JOB_ACCT_CD_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_4_JOB_ACCT_CD_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_4_JOB_ACCT_CD_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_4_JOB_ACCT_CD_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_4_JOB_ACCT_CD_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      READ_4_JOB_ACCT_CD_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      READ_4_JOB_ACCT_CD_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_4_JOB_ACCT_CD_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      READ_4_JOB_ACCT_CD_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.READ_4_JOB_ACCT_CD_CBM008 as READ_4_JOB_ACCT_CD_CBM008 left join
      work.DEPTBDGT_ER_MAX_EFFSEQ_CBM008 as DEPTBDGT_ER_MAX_EFFSEQ_CBM008
         on
         (
            READ_4_JOB_ACCT_CD_CBM008.POSITION_NBR = DEPTBDGT_ER_MAX_EFFSEQ_CBM008.POSITION_NBR
            and READ_4_JOB_ACCT_CD_CBM008.UTSHARE_FISCAL_YEAR = DEPTBDGT_ER_MAX_EFFSEQ_CBM008.FISCAL_YEAR
            and DEPTBDGT_ER_MAX_EFFSEQ_CBM008.EFFDT <= DHMS(INPUT(READ_4_JOB_ACCT_CD_CBM008.APPT_END_DT,YYMMDD8.),0,0,0)
         )
   group by
      READ_4_JOB_ACCT_CD_CBM008.POSITION_NBR,
      READ_4_JOB_ACCT_CD_CBM008.UTSHARE_FISCAL_YEAR
   having
      MAX(DEPTBDGT_ER_MAX_EFFSEQ_CBM008.EFFDT) IS MISSING
      or DEPTBDGT_ER_MAX_EFFSEQ_CBM008.EFFDT = MAX(DEPTBDGT_ER_MAX_EFFSEQ_CBM008.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            Set Operators                         A5B29B8Q.BZ0005OO *
 * Transform:       Set Operators                                           *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADDL_READ_4_ACCT_CD_CBM008 -          A5B29B8Q.BS0001TK *
 *                   work.ADDL_READ_4_ACCT_CD_CBM008                        *
 *                  READ_4_ADDL_PAY_CBM008 -              A5B29B8Q.BS0001TG *
 *                   work.READ_4_ADDL_PAY_CBM008                            *
 * Target Table:    Set Operators - work.W3A9IVYS         A5B29B8Q.BS0001TL *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OO);

proc sql;
   create table work.W3A9IVYS as
   /* Returns all unique rows from the two query results.  */
   select
      ADDL_READ_4_ACCT_CD_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      ADDL_READ_4_ACCT_CD_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      ADDL_READ_4_ACCT_CD_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      ADDL_READ_4_ACCT_CD_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      ADDL_READ_4_ACCT_CD_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      ADDL_READ_4_ACCT_CD_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      ADDL_READ_4_ACCT_CD_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      ADDL_READ_4_ACCT_CD_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      ADDL_READ_4_ACCT_CD_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      ADDL_READ_4_ACCT_CD_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      ADDL_READ_4_ACCT_CD_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      ADDL_READ_4_ACCT_CD_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      ADDL_READ_4_ACCT_CD_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      ADDL_READ_4_ACCT_CD_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      ADDL_READ_4_ACCT_CD_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      ADDL_READ_4_ACCT_CD_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      ADDL_READ_4_ACCT_CD_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      ADDL_READ_4_ACCT_CD_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      ADDL_READ_4_ACCT_CD_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      ADDL_READ_4_ACCT_CD_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      ADDL_READ_4_ACCT_CD_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      ADDL_READ_4_ACCT_CD_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      ADDL_READ_4_ACCT_CD_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      ADDL_READ_4_ACCT_CD_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      ADDL_READ_4_ACCT_CD_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      ADDL_READ_4_ACCT_CD_CBM008.DIST_PCT_ADDL/100 as DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      ADDL_READ_4_ACCT_CD_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      ADDL_READ_4_ACCT_CD_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADDL_READ_4_ACCT_CD_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADDL_READ_4_ACCT_CD_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      ADDL_READ_4_ACCT_CD_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      ADDL_READ_4_ACCT_CD_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      ADDL_READ_4_ACCT_CD_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      ADDL_READ_4_ACCT_CD_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      ADDL_READ_4_ACCT_CD_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      ADDL_READ_4_ACCT_CD_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      ADDL_READ_4_ACCT_CD_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      ADDL_READ_4_ACCT_CD_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      ADDL_READ_4_ACCT_CD_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.ADDL_READ_4_ACCT_CD_CBM008
   union all
   select
      READ_4_ADDL_PAY_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_4_ADDL_PAY_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_ADDL_PAY_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      READ_4_ADDL_PAY_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      READ_4_ADDL_PAY_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_4_ADDL_PAY_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_4_ADDL_PAY_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_4_ADDL_PAY_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      READ_4_ADDL_PAY_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      READ_4_ADDL_PAY_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      READ_4_ADDL_PAY_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      READ_4_ADDL_PAY_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      READ_4_ADDL_PAY_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      READ_4_ADDL_PAY_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      READ_4_ADDL_PAY_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      READ_4_ADDL_PAY_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      READ_4_ADDL_PAY_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_4_ADDL_PAY_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      READ_4_ADDL_PAY_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      READ_4_ADDL_PAY_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      READ_4_ADDL_PAY_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      "" as POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_4_ADDL_PAY_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      READ_4_ADDL_PAY_CBM008.ADDL_PAY_ACCT_CD as ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      1 as DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      READ_4_ADDL_PAY_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_4_ADDL_PAY_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_4_ADDL_PAY_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_4_ADDL_PAY_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      READ_4_ADDL_PAY_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      READ_4_ADDL_PAY_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_4_ADDL_PAY_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      READ_4_ADDL_PAY_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.READ_4_ADDL_PAY_CBM008
   where
      READ_4_ADDL_PAY_CBM008.ADDL_PAY_ACCT_CD NOT IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            ADDL_READ_4_FUND_CD_FUNCTION          A5B29B8Q.BZ0005OP *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Set Operators - work.W3A9IVYS         A5B29B8Q.BS0001TL *
 *                  PS_UTA_HR_ACCTCDCA_Extract -          A5B29B8Q.BE00007C *
 *                   ADWSTGPR.PS_UTA_HR_ACCTCDCA_Extract                    *
 * Target Table:    ADDL_READ_4_FUND_CD_CBM008 -          A5B29B8Q.BS0001TM *
 *                   work.ADDL_READ_4_FUND_CD_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OP);

proc sql;
   create table work.ADDL_READ_4_FUND_CD_CBM008 as
   select
      W3A9IVYS.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      W3A9IVYS.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W3A9IVYS.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      W3A9IVYS.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      W3A9IVYS.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W3A9IVYS.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W3A9IVYS.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      W3A9IVYS.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      W3A9IVYS.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W3A9IVYS.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W3A9IVYS.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W3A9IVYS.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W3A9IVYS.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      W3A9IVYS.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      W3A9IVYS.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      W3A9IVYS.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      W3A9IVYS.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      W3A9IVYS.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      W3A9IVYS.SALARY_A length = 8
         label = 'SALARY_A',
      W3A9IVYS.SALARY_D length = 8
         label = 'SALARY_D',
      W3A9IVYS.SALARY_X length = 8
         label = 'SALARY_X',
      W3A9IVYS.SALARY_R length = 8
         label = 'SALARY_R',
      W3A9IVYS.SALARY_Z length = 8
         label = 'SALARY_Z',
      W3A9IVYS.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      W3A9IVYS.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      W3A9IVYS.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      PS_UTA_HR_ACCTCDCA_Extract.CLASS_FLD as CLASS_FLD_ADDL length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD_ADDL',
      PS_UTA_HR_ACCTCDCA_Extract.FUND_CODE as FUND_CODE_ADDL length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE_ADDL',
      W3A9IVYS.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      W3A9IVYS.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W3A9IVYS.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W3A9IVYS.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W3A9IVYS.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      W3A9IVYS.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      W3A9IVYS.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      W3A9IVYS.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      W3A9IVYS.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W3A9IVYS.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W3A9IVYS.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      W3A9IVYS.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W3A9IVYS.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W3A9IVYS as W3A9IVYS left join
      ADWSTGPR.PS_UTA_HR_ACCTCDCA_Extract as PS_UTA_HR_ACCTCDCA_Extract
         on
         (
            W3A9IVYS.ACCT_CD_ADDL NOT IS MISSING
            and W3A9IVYS.ACCT_CD_ADDL = PS_UTA_HR_ACCTCDCA_Extract.ACCT_CD
         )
   ;
quit;

/*==========================================================================*
 * Step:            ADDL_OVLP_ALLOC_REDIS                 A5B29B8Q.BZ0005OQ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    ADDL_READ_4_FUND_CD_CBM008 -          A5B29B8Q.BS0001TM *
 *                   work.ADDL_READ_4_FUND_CD_CBM008                        *
 * Target Table:    ADDL_OVLP_ALLOC_REDIS_CBM008 -        A5B29B8Q.BS0001TN *
 *                   work.ADDL_OVLP_ALLOC_REDIS_CBM008                      *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OQ);

%let SYSLAST = %nrquote(work.ADDL_READ_4_FUND_CD_CBM008);

proc sql;
   create view work.ADDL_OVLP_ALLOC_REDIS_CBM008 as
   select
      ADDL_READ_4_FUND_CD_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      ADDL_READ_4_FUND_CD_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      ADDL_READ_4_FUND_CD_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      ADDL_READ_4_FUND_CD_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      ADDL_READ_4_FUND_CD_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      ADDL_READ_4_FUND_CD_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      ADDL_READ_4_FUND_CD_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      ADDL_READ_4_FUND_CD_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      ADDL_READ_4_FUND_CD_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      ADDL_READ_4_FUND_CD_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      ADDL_READ_4_FUND_CD_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      ADDL_READ_4_FUND_CD_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      ADDL_READ_4_FUND_CD_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      ADDL_READ_4_FUND_CD_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      ADDL_READ_4_FUND_CD_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      ADDL_READ_4_FUND_CD_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      ADDL_READ_4_FUND_CD_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      ADDL_READ_4_FUND_CD_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      ADDL_READ_4_FUND_CD_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      ADDL_READ_4_FUND_CD_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      ADDL_READ_4_FUND_CD_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      ADDL_READ_4_FUND_CD_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      ADDL_READ_4_FUND_CD_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      ADDL_READ_4_FUND_CD_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      ADDL_READ_4_FUND_CD_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      ADDL_READ_4_FUND_CD_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      ADDL_READ_4_FUND_CD_CBM008.CLASS_FLD_ADDL length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD_ADDL',
      ADDL_READ_4_FUND_CD_CBM008.FUND_CODE_ADDL length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE_ADDL',
      INT(ADDL_READ_4_FUND_CD_CBM008.ADDL_PAY_OTH_PAY*
      ADDL_READ_4_FUND_CD_CBM008.DIST_PCT_ADDL) as OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      ADDL_READ_4_FUND_CD_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      ADDL_READ_4_FUND_CD_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADDL_READ_4_FUND_CD_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADDL_READ_4_FUND_CD_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      ADDL_READ_4_FUND_CD_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      ADDL_READ_4_FUND_CD_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      ADDL_READ_4_FUND_CD_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      ADDL_READ_4_FUND_CD_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      ADDL_READ_4_FUND_CD_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      ADDL_READ_4_FUND_CD_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      ADDL_READ_4_FUND_CD_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      ADDL_READ_4_FUND_CD_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      ADDL_READ_4_FUND_CD_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.ADDL_READ_4_FUND_CD_CBM008 as ADDL_READ_4_FUND_CD_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            ADDL_SALARY                           A5B29B8Q.BZ0005OR *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    ADDL_OVLP_ALLOC_REDIS_CBM008 -        A5B29B8Q.BS0001TN *
 *                   work.ADDL_OVLP_ALLOC_REDIS_CBM008                      *
 * Target Table:    ADDL_SALARY_CBM008 -                  A5B29B8Q.BS0001TO *
 *                   work.ADDL_SALARY_CBM008                                *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OR);

%let SYSLAST = %nrquote(work.ADDL_OVLP_ALLOC_REDIS_CBM008);

proc sql;
   create table work.ADDL_SALARY_CBM008 as
   select
      ADDL_OVLP_ALLOC_REDIS_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      ADDL_OVLP_ALLOC_REDIS_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      ADDL_OVLP_ALLOC_REDIS_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      ADDL_OVLP_ALLOC_REDIS_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      ADDL_OVLP_ALLOC_REDIS_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      ADDL_OVLP_ALLOC_REDIS_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      ADDL_OVLP_ALLOC_REDIS_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      ADDL_OVLP_ALLOC_REDIS_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      ADDL_OVLP_ALLOC_REDIS_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      ADDL_OVLP_ALLOC_REDIS_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      ADDL_OVLP_ALLOC_REDIS_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      ADDL_OVLP_ALLOC_REDIS_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      ADDL_OVLP_ALLOC_REDIS_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      ADDL_OVLP_ALLOC_REDIS_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      ADDL_OVLP_ALLOC_REDIS_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      ADDL_OVLP_ALLOC_REDIS_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      ADDL_OVLP_ALLOC_REDIS_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      ADDL_OVLP_ALLOC_REDIS_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      ADDL_OVLP_ALLOC_REDIS_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      ADDL_OVLP_ALLOC_REDIS_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      ADDL_OVLP_ALLOC_REDIS_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      ADDL_OVLP_ALLOC_REDIS_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      ADDL_OVLP_ALLOC_REDIS_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      ADDL_OVLP_ALLOC_REDIS_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      ADDL_OVLP_ALLOC_REDIS_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      ADDL_OVLP_ALLOC_REDIS_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      ADDL_OVLP_ALLOC_REDIS_CBM008.CLASS_FLD_ADDL as ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL as ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      ADDL_OVLP_ALLOC_REDIS_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      INT(SUM(IFN(SUBSTR(ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL,1,2)='21',
      ADDL_OVLP_ALLOC_REDIS_CBM008.OVLP_ALLOC_REDIS_ADDL,0))) as SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      INT(SUM(IFN(SUBSTR(ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL,1,2) IN ('31','32'),
      ADDL_OVLP_ALLOC_REDIS_CBM008.OVLP_ALLOC_REDIS_ADDL,0))) as SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      INT(SUM(IFN(SUBSTR(ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL,1,1)='4',
      ADDL_OVLP_ALLOC_REDIS_CBM008.OVLP_ALLOC_REDIS_ADDL,0))) as SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      INT(SUM(IFN(ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL IN ('5100','5200','5300','5400','5500','5600'),
      ADDL_OVLP_ALLOC_REDIS_CBM008.OVLP_ALLOC_REDIS_ADDL,0))) as SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      INT(SUM(IFN(ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL NOT IN ('5100','5200','5300','5400','5500','5600') &
      SUBSTR(ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL,1,1)<>'4' &
      SUBSTR(ADDL_OVLP_ALLOC_REDIS_CBM008.FUND_CODE_ADDL,1,2) NOT IN ('21','31','32'),
      ADDL_OVLP_ALLOC_REDIS_CBM008.OVLP_ALLOC_REDIS_ADDL,0))) as SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      ADDL_OVLP_ALLOC_REDIS_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      ADDL_OVLP_ALLOC_REDIS_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADDL_OVLP_ALLOC_REDIS_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADDL_OVLP_ALLOC_REDIS_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      ADDL_OVLP_ALLOC_REDIS_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      ADDL_OVLP_ALLOC_REDIS_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      ADDL_OVLP_ALLOC_REDIS_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      ADDL_OVLP_ALLOC_REDIS_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      ADDL_OVLP_ALLOC_REDIS_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      ADDL_OVLP_ALLOC_REDIS_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      ADDL_OVLP_ALLOC_REDIS_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      ADDL_OVLP_ALLOC_REDIS_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      ADDL_OVLP_ALLOC_REDIS_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.ADDL_OVLP_ALLOC_REDIS_CBM008 as ADDL_OVLP_ALLOC_REDIS_CBM008
   group by
      ADDL_OVLP_ALLOC_REDIS_CBM008.SSN,
      ADDL_OVLP_ALLOC_REDIS_CBM008.STRM
   ;
quit;

/*==========================================================================*
 * Step:            FACULTY_MEMBER                        A5B29B8Q.BZ0005OS *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    ADDL_SALARY_CBM008 -                  A5B29B8Q.BS0001TO *
 *                   work.ADDL_SALARY_CBM008                                *
 * Target Table:    FACULTY_MEMBER_CBM008 -               A5B29B8Q.BS0001TP *
 *                   work.FACULTY_MEMBER_CBM008                             *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OS);

%let SYSLAST = %nrquote(work.ADDL_SALARY_CBM008);

proc sql;
   create view work.FACULTY_MEMBER_CBM008 as
   select
      ADDL_SALARY_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      ADDL_SALARY_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      ADDL_SALARY_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      ADDL_SALARY_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      ADDL_SALARY_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      ADDL_SALARY_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      ADDL_SALARY_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      ADDL_SALARY_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      ADDL_SALARY_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      ADDL_SALARY_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      ADDL_SALARY_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      ADDL_SALARY_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      ADDL_SALARY_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      ADDL_SALARY_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      ADDL_SALARY_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      ADDL_SALARY_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      ADDL_SALARY_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      ADDL_SALARY_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      ADDL_SALARY_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      ADDL_SALARY_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      ADDL_SALARY_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      ADDL_SALARY_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      ADDL_SALARY_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      ADDL_SALARY_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      ADDL_SALARY_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      ADDL_SALARY_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      ADDL_SALARY_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      ADDL_SALARY_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      ADDL_SALARY_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      ADDL_SALARY_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      ADDL_SALARY_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      ADDL_SALARY_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      ADDL_SALARY_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      ADDL_SALARY_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      ADDL_SALARY_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      ADDL_SALARY_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADDL_SALARY_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADDL_SALARY_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      ADDL_SALARY_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      ADDL_SALARY_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      ADDL_SALARY_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      ADDL_SALARY_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      ADDL_SALARY_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      ADDL_SALARY_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      ADDL_SALARY_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      ADDL_SALARY_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      ADDL_SALARY_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.ADDL_SALARY_CBM008 as ADDL_SALARY_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            DECODE_TITLE_CODE_1                   A5B29B8Q.BZ0005OT *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    FACULTY_MEMBER_CBM008 -               A5B29B8Q.BS0001TP *
 *                   work.FACULTY_MEMBER_CBM008                             *
 * Target Table:    DECODE_TITLE_CODE_1_CBM008 -          A5B29B8Q.BS0001TQ *
 *                   work.DECODE_TITLE_CODE_1_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OT);

%let SYSLAST = %nrquote(work.FACULTY_MEMBER_CBM008);

proc sql;
   create table work.DECODE_TITLE_CODE_1_CBM008 as
   select
      FACULTY_MEMBER_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      FACULTY_MEMBER_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      FACULTY_MEMBER_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      FACULTY_MEMBER_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      FACULTY_MEMBER_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      FACULTY_MEMBER_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      FACULTY_MEMBER_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      FACULTY_MEMBER_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      FACULTY_MEMBER_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      FACULTY_MEMBER_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      FACULTY_MEMBER_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      FACULTY_MEMBER_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      FACULTY_MEMBER_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      FACULTY_MEMBER_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      FACULTY_MEMBER_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      FACULTY_MEMBER_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      FACULTY_MEMBER_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      FACULTY_MEMBER_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      FACULTY_MEMBER_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      FACULTY_MEMBER_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      FACULTY_MEMBER_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      FACULTY_MEMBER_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      FACULTY_MEMBER_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      FACULTY_MEMBER_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      FACULTY_MEMBER_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      FACULTY_MEMBER_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      FACULTY_MEMBER_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      FACULTY_MEMBER_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      FACULTY_MEMBER_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      FACULTY_MEMBER_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      FACULTY_MEMBER_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      FACULTY_MEMBER_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      FACULTY_MEMBER_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      FACULTY_MEMBER_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0006','0007','0008','0009','0010'),'PROF',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE='0000','EMRT',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN ('0011','0013',
      '0014','0015','0021','0024','0025','0034','0035','0044','0045','0047','0056','0029'),
      'ADJ',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN ('0012','0022','0032'),
      'VPRF',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0016','0017','0018','0019','0020'),'ASSC',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0027','0028','0030','0031'),'ASST',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0040','0041'),'INST',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0049','0050','0051'),'LECT',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE='0096','UNDF',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE>'0062','TA','')))))))))) as INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0006','0007','0008','0009','0010'),'1',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0000','0011','0013',
      '0014','0015','0021','0024','0025','0034','0035','0044','0045','0047','0056','0029',
      '0012','0022','0032','0049','0050','0051','0096'),'5',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0016','0017','0018','0019','0020'),'2',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0027','0028','0030','0031'),'3',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE IN
      ('0040','0041'),'4',
      IFC(FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE>'0062','6','')))))) as FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      FACULTY_MEMBER_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      FACULTY_MEMBER_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      FACULTY_MEMBER_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      FACULTY_MEMBER_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      FACULTY_MEMBER_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      FACULTY_MEMBER_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      FACULTY_MEMBER_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      FACULTY_MEMBER_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      FACULTY_MEMBER_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      FACULTY_MEMBER_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      FACULTY_MEMBER_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      FACULTY_MEMBER_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      FACULTY_MEMBER_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.FACULTY_MEMBER_CBM008 as FACULTY_MEMBER_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            READ_HRA_MAJOR_APPT                   A5B29B8Q.BZ0005OU *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_UTA_HRA_TBL_Extract -              A5B29B8Q.BE00007I *
 *                   ADWSTGPR.PS_UTA_HRA_TBL_Extract                        *
 *                  DECODE_TITLE_CODE_1_CBM008 -          A5B29B8Q.BS0001TQ *
 *                   work.DECODE_TITLE_CODE_1_CBM008                        *
 * Target Table:    READ_HRA_MAJOR_APPT_CBM008 -          A5B29B8Q.BS0001TR *
 *                   work.READ_HRA_MAJOR_APPT_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OU);

proc sql;
   create table work.READ_HRA_MAJOR_APPT_CBM008 as
   select
      DECODE_TITLE_CODE_1_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      DECODE_TITLE_CODE_1_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      DECODE_TITLE_CODE_1_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      DECODE_TITLE_CODE_1_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      DECODE_TITLE_CODE_1_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      DECODE_TITLE_CODE_1_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      DECODE_TITLE_CODE_1_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      DECODE_TITLE_CODE_1_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      DECODE_TITLE_CODE_1_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      DECODE_TITLE_CODE_1_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      DECODE_TITLE_CODE_1_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      DECODE_TITLE_CODE_1_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      DECODE_TITLE_CODE_1_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      DECODE_TITLE_CODE_1_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      DECODE_TITLE_CODE_1_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      DECODE_TITLE_CODE_1_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      DECODE_TITLE_CODE_1_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      DECODE_TITLE_CODE_1_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      DECODE_TITLE_CODE_1_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      DECODE_TITLE_CODE_1_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      DECODE_TITLE_CODE_1_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      DECODE_TITLE_CODE_1_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      DECODE_TITLE_CODE_1_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      DECODE_TITLE_CODE_1_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      DECODE_TITLE_CODE_1_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      DECODE_TITLE_CODE_1_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      DECODE_TITLE_CODE_1_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      DECODE_TITLE_CODE_1_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      DECODE_TITLE_CODE_1_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      DECODE_TITLE_CODE_1_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      DECODE_TITLE_CODE_1_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      DECODE_TITLE_CODE_1_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      DECODE_TITLE_CODE_1_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      DECODE_TITLE_CODE_1_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      SUBSTR(STRIP(PS_UTA_HRA_TBL_Extract.UTA_HRA_UNIT_CD),1,4) as UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      DECODE_TITLE_CODE_1_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      DECODE_TITLE_CODE_1_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      DECODE_TITLE_CODE_1_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      DECODE_TITLE_CODE_1_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      DECODE_TITLE_CODE_1_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      DECODE_TITLE_CODE_1_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      DECODE_TITLE_CODE_1_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      DECODE_TITLE_CODE_1_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      DECODE_TITLE_CODE_1_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      DECODE_TITLE_CODE_1_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      DECODE_TITLE_CODE_1_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      DECODE_TITLE_CODE_1_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      PS_UTA_HRA_TBL_Extract.UTA_HRA_ACCT_10 length = 10
         format = $10.
         informat = $10.
         label = 'UTA_HRA_ACCT_10',
      PS_UTA_HRA_TBL_Extract.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRA_POSITIONID',
      PS_UTA_HRA_TBL_Extract.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      DECODE_TITLE_CODE_1_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      DECODE_TITLE_CODE_1_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      DECODE_TITLE_CODE_1_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.DECODE_TITLE_CODE_1_CBM008 as DECODE_TITLE_CODE_1_CBM008 left join
      ADWSTGPR.PS_UTA_HRA_TBL_Extract as PS_UTA_HRA_TBL_Extract
         on
         (
            DECODE_TITLE_CODE_1_CBM008.SSN = PS_UTA_HRA_TBL_Extract.SSN
            and DECODE_TITLE_CODE_1_CBM008.ACAD_YEAR = PS_UTA_HRA_TBL_Extract.UTA_HRA_FISCALYEAR
            and INPUT(DECODE_TITLE_CODE_1_CBM008.UTA_HRE_MAJAPPTSEQ,BEST8.) = PS_UTA_HRA_TBL_Extract.UTA_HRA_APPT_SEQNR
         )
   ;
quit;

/*==========================================================================*
 * Step:            DECODE_TITLE_CODE_2                   A5B29B8Q.BZ0005OV *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    READ_HRA_MAJOR_APPT_CBM008 -          A5B29B8Q.BS0001TR *
 *                   work.READ_HRA_MAJOR_APPT_CBM008                        *
 * Target Table:    DECODE_TITLE_CODE_2_CBM008 -          A5B29B8Q.BS0001TS *
 *                   work.DECODE_TITLE_CODE_2_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OV);

%let SYSLAST = %nrquote(work.READ_HRA_MAJOR_APPT_CBM008);

proc sql;
   create table work.DECODE_TITLE_CODE_2_CBM008 as
   select
      READ_HRA_MAJOR_APPT_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_HRA_MAJOR_APPT_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_HRA_MAJOR_APPT_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      READ_HRA_MAJOR_APPT_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      READ_HRA_MAJOR_APPT_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_HRA_MAJOR_APPT_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_HRA_MAJOR_APPT_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      READ_HRA_MAJOR_APPT_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_HRA_MAJOR_APPT_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_HRA_MAJOR_APPT_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_HRA_MAJOR_APPT_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      READ_HRA_MAJOR_APPT_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      READ_HRA_MAJOR_APPT_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      READ_HRA_MAJOR_APPT_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      READ_HRA_MAJOR_APPT_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      READ_HRA_MAJOR_APPT_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      READ_HRA_MAJOR_APPT_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      READ_HRA_MAJOR_APPT_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      READ_HRA_MAJOR_APPT_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      READ_HRA_MAJOR_APPT_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_HRA_MAJOR_APPT_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      READ_HRA_MAJOR_APPT_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      READ_HRA_MAJOR_APPT_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      READ_HRA_MAJOR_APPT_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      IFC(READ_HRA_MAJOR_APPT_CBM008.INSTRUCTOR_CLASSIF='',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0006','0007','0008','0009','0010'),'PROF',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD='0000','EMRT',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN ('0011','0013',
      '0014','0015','0021','0024','0025','0034','0035','0044','0045','0047','0056','0029'),
      'ADJ',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN ('0012','0022','0032'),
      'VPRF',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0016','0017','0018','0019','0020'),'ASSC',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0027','0028','0030','0031'),'ASST',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0040','0041'),'INST',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0049','0050','0051'),'LECT',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD='0096','UNDF',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD>'0062' &
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD<'0096','TA','')))))))))),
      READ_HRA_MAJOR_APPT_CBM008.INSTRUCTOR_CLASSIF) as INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      IFC(READ_HRA_MAJOR_APPT_CBM008.FACULTY_CLASSIF='' &
      READ_HRA_MAJOR_APPT_CBM008.SOURCE='INSTR',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0006','0007','0008','0009','0010'),'1',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0000','0011','0013',
      '0014','0015','0021','0024','0025','0034','0035','0044','0045','0047','0056','0029',
      '0012','0022','0032','0049','0050','0051','0096'),'5',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0016','0017','0018','0019','0020'),'2',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0027','0028','0030','0031'),'3',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD IN
      ('0040','0041'),'4',
      IFC(READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD>'0062' &
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_TITLE_CD<'0096','6','')))))),
      READ_HRA_MAJOR_APPT_CBM008.FACULTY_CLASSIF) as FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      READ_HRA_MAJOR_APPT_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_HRA_MAJOR_APPT_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_HRA_MAJOR_APPT_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_HRA_MAJOR_APPT_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      READ_HRA_MAJOR_APPT_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_ACCT_10 length = 10
         format = $10.
         informat = $10.
         label = 'UTA_HRA_ACCT_10',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRA_POSITIONID',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_HRA_MAJOR_APPT_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      READ_HRA_MAJOR_APPT_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      READ_HRA_MAJOR_APPT_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.READ_HRA_MAJOR_APPT_CBM008 as READ_HRA_MAJOR_APPT_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            Set Operators                         A5B29B8Q.BZ0005OW *
 * Transform:       Set Operators                                           *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   DECODE_TITLE_CODE_2_CBM008 -          A5B29B8Q.BS0001TS *
 *                   work.DECODE_TITLE_CODE_2_CBM008                        *
 *                  GET_GENDER_CBM008 -                   A5B29B8Q.BS0001SX *
 *                   work.GET_GENDER_CBM008                                 *
 * Target Table:    Set Operators - work.W10B49ED         A5B29B8Q.BS0001TT *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OW);

proc sql;
   create view work.W10B49ED as
   /* Returns all unique rows from the two query results.  */
   select
      DECODE_TITLE_CODE_2_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      DECODE_TITLE_CODE_2_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      DECODE_TITLE_CODE_2_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      DECODE_TITLE_CODE_2_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      DECODE_TITLE_CODE_2_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      DECODE_TITLE_CODE_2_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      DECODE_TITLE_CODE_2_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      DECODE_TITLE_CODE_2_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      DECODE_TITLE_CODE_2_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      DECODE_TITLE_CODE_2_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      DECODE_TITLE_CODE_2_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      DECODE_TITLE_CODE_2_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      DECODE_TITLE_CODE_2_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      DECODE_TITLE_CODE_2_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      DECODE_TITLE_CODE_2_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      DECODE_TITLE_CODE_2_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      DECODE_TITLE_CODE_2_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      DECODE_TITLE_CODE_2_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      DECODE_TITLE_CODE_2_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      DECODE_TITLE_CODE_2_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      DECODE_TITLE_CODE_2_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      DECODE_TITLE_CODE_2_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      DECODE_TITLE_CODE_2_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      DECODE_TITLE_CODE_2_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      DECODE_TITLE_CODE_2_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      DECODE_TITLE_CODE_2_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      DECODE_TITLE_CODE_2_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      DECODE_TITLE_CODE_2_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      DECODE_TITLE_CODE_2_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      DECODE_TITLE_CODE_2_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      DECODE_TITLE_CODE_2_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      DECODE_TITLE_CODE_2_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      DECODE_TITLE_CODE_2_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      DECODE_TITLE_CODE_2_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      DECODE_TITLE_CODE_2_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      DECODE_TITLE_CODE_2_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      DECODE_TITLE_CODE_2_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      DECODE_TITLE_CODE_2_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      DECODE_TITLE_CODE_2_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      DECODE_TITLE_CODE_2_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRA_ACCT_10 length = 10
         format = $10.
         informat = $10.
         label = 'UTA_HRA_ACCT_10',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRA_POSITIONID',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      DECODE_TITLE_CODE_2_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      DECODE_TITLE_CODE_2_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      DECODE_TITLE_CODE_2_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.DECODE_TITLE_CODE_2_CBM008
   union all
   select
      GET_GENDER_CBM008.HRS_ID as SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      "" as CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      "" as FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      "" as CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      GET_GENDER_CBM008.EMPLID as CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      GET_GENDER_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      "" as UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      . as EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      GET_GENDER_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      GET_GENDER_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      GET_GENDER_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      GET_GENDER_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      "" as ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      . as DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      0 as PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      0 as PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      0 as PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      0 as PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      0 as SALARY_A length = 8
         label = 'SALARY_A',
      0 as SALARY_D length = 8
         label = 'SALARY_D',
      0 as SALARY_X length = 8
         label = 'SALARY_X',
      0 as SALARY_R length = 8
         label = 'SALARY_R',
      0 as SALARY_Z length = 8
         label = 'SALARY_Z',
      "" as ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      . as ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      "" as POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      "" as ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      "" as ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      . as OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      0 as SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      0 as SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      0 as SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      0 as SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      0 as SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      "" as INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      "" as FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      "" as UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      GET_GENDER_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      GET_GENDER_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      GET_GENDER_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      PUT(DATEPART(GET_GENDER_CBM008.BIRTHDATE),YYMMDDn8.) as UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      GET_GENDER_CBM008.GENDER as UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      STRIP(GET_GENDER_CBM008.NAME) as UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      "" as UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      GET_GENDER_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      GET_GENDER_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      "" as UTA_HRA_ACCT_10 length = 10
         format = $10.
         informat = $10.
         label = 'UTA_HRA_ACCT_10',
      "" as UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRA_POSITIONID',
      "" as UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      "" as SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      "" as UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      GET_GENDER_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.GET_GENDER_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            UTA_TENURE_MAX_ORG_UPD_DT             A5B29B8Q.BZ0005OX *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_UTA_TT_TENURE_Extract -            A5B29B8Q.BE00008F *
 *                   ADWSTGPR.PS_UTA_TT_TENURE_Extract                      *
 * Target Table:    UTA_TENURE_MAX_ORG_UPD_DT_CBM008 -    A5B29B8Q.BS0001TU *
 *                  work.UTA_TENURE_MAX_ORG_UPD_DT_CBM0                     *
 *                  08                                                      *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OX);

%let SYSLAST = %nrquote(ADWSTGPR.PS_UTA_TT_TENURE_Extract);

proc sql;
   create table work.UTA_TENURE_MAX_ORG_UPD_DT_CBM008 as
   select
      PS_UTA_TT_TENURE_Extract.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      PS_UTA_TT_TENURE_Extract.DESCRSHORT length = 10
         format = $10.
         informat = $10.
         label = 'DESCRSHORT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_BASE_DATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_BASE_DATE',
      PS_UTA_TT_TENURE_Extract.UTA_TT_CREATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_CREATED_DT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_CURR_LEAVE length = 1
         format = $1.
         informat = $1.
         label = 'UTA_TT_CURR_LEAVE',
      PS_UTA_TT_TENURE_Extract.UTA_TT_DECISION length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_DECISION',
      PS_UTA_TT_TENURE_Extract.UTA_TT_DEP_RSN length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_DEP_RSN',
      PS_UTA_TT_TENURE_Extract.UTA_TT_DEPARTUREDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_DEPARTUREDT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'UTA_TT_EMPLID',
      PS_UTA_TT_TENURE_Extract.UTA_TT_EXPTENUREDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_EXPTENUREDT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_FOLLOWUPREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_FOLLOWUPREV',
      PS_UTA_TT_TENURE_Extract.UTA_TT_FOLWUPRVDEC length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_FOLWUPRVDEC',
      PS_UTA_TT_TENURE_Extract.UTA_TT_HIRE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_HIRE_DT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_LAST_UPDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_LAST_UPDT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_LST_PROM_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_LST_PROM_DT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_MIS_ADJ_REA length = 127
         format = $127.
         informat = $127.
         label = 'UTA_TT_MIS_ADJ_REA',
      PS_UTA_TT_TENURE_Extract.UTA_TT_MISC_ADJ length = 8
         label = 'UTA_TT_MISC_ADJ',
      PS_UTA_TT_TENURE_Extract.UTA_TT_NXT_TEN_REV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_NXT_TEN_REV',
      PS_UTA_TT_TENURE_Extract.UTA_TT_PRIOREARNYR length = 8
         label = 'UTA_TT_PRIOREARNYR',
      PS_UTA_TT_TENURE_Extract.UTA_TT_PRIORLEAVYR length = 8
         label = 'UTA_TT_PRIORLEAVYR',
      PS_UTA_TT_TENURE_Extract.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      PS_UTA_TT_TENURE_Extract.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      PS_UTA_TT_TENURE_Extract.UTA_TT_TEN_EXT_YRS length = 8
         label = 'UTA_TT_TEN_EXT_YRS',
      PS_UTA_TT_TENURE_Extract.UTA_TT_TENURE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_TENURE_DT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_TENURE_REV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_TENURE_REV',
      PS_UTA_TT_TENURE_Extract.UTA_TT_TERM length = 1
         format = $1.
         informat = $1.
         label = 'UTA_TT_TERM',
      PS_UTA_TT_TENURE_Extract.UTA_TT_THRD_YR_REV length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_THRD_YR_REV',
      PS_UTA_TT_TENURE_Extract.UTA_TT_THRDYRREVDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UTA_TT_THRDYRREVDT',
      PS_UTA_TT_TENURE_Extract.UTA_TT_YRS_TENURE length = 8
         label = 'UTA_TT_YRS_TENURE'
   from
      ADWSTGPR.PS_UTA_TT_TENURE_Extract as PS_UTA_TT_TENURE_Extract
   group by
      PS_UTA_TT_TENURE_Extract.UTA_TT_EMPLID
   having
      PS_UTA_TT_TENURE_Extract.ACAD_ORG = MAX(PS_UTA_TT_TENURE_Extract.ACAD_ORG)
      and PS_UTA_TT_TENURE_Extract.UTA_TT_LAST_UPDT = MAX(PS_UTA_TT_TENURE_Extract.UTA_TT_LAST_UPDT)
   ;
quit;

/*==========================================================================*
 * Step:            POSITION_DATA_MAX_EFFDT               A5B29B8Q.BZ0005OY *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_POSITION_DATA_Extract -            A5B29B8Q.BE00004X *
 *                   ADWSTGPR.PS_POSITION_DATA_Extract                      *
 * Target Table:    POSITION_DATA_MAX_EFFDT_CBM008 -      A5B29B8Q.BS0001TV *
 *                   work.POSITION_DATA_MAX_EFFDT_CBM008                    *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OY);

%let SYSLAST = %nrquote(ADWSTGPR.PS_POSITION_DATA_Extract);

proc sql;
   create table work.POSITION_DATA_MAX_EFFDT_CBM008 as
   select
      PS_POSITION_DATA_Extract.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      PS_POSITION_DATA_Extract.DEPTID length = 10
         format = $10.
         informat = $10.
         label = 'DEPTID'
   from
      ADWSTGPR.PS_POSITION_DATA_Extract as PS_POSITION_DATA_Extract
   where
      PS_POSITION_DATA_Extract.EFFDT <= DATETIME()
   group by
      PS_POSITION_DATA_Extract.POSITION_NBR
   having
      PS_POSITION_DATA_Extract.EFFDT = MAX(PS_POSITION_DATA_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            READ_TENURE_RECORD                    A5B29B8Q.BZ0005OZ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   UTA_TENURE_MAX_ORG_UPD_DT_CBM008 -    A5B29B8Q.BS0001TU *
 *                  work.UTA_TENURE_MAX_ORG_UPD_DT_CBM0                     *
 *                  08                                                      *
 *                  POSITION_DATA_MAX_EFFDT_CBM008 -      A5B29B8Q.BS0001TV *
 *                   work.POSITION_DATA_MAX_EFFDT_CBM008                    *
 *                  PS_UTZ_PT100_DTL_Extract -            A5B29B8Q.BE00000C *
 *                   ADWSTGPR.PS_UTZ_PT100_DTL_Extract                      *
 *                  Set Operators - work.W10B49ED         A5B29B8Q.BS0001TT *
 * Target Table:    READ_TENURE_RECORD_CBM008 -           A5B29B8Q.BS0001TW *
 *                   work.READ_TENURE_RECORD_CBM008                         *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005OZ);

proc sql;
   create table work.READ_TENURE_RECORD_CBM008 as
   select
      W10B49ED.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      W10B49ED.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W10B49ED.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      W10B49ED.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      W10B49ED.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W10B49ED.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W10B49ED.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      W10B49ED.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      W10B49ED.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W10B49ED.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W10B49ED.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W10B49ED.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W10B49ED.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      W10B49ED.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      W10B49ED.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      W10B49ED.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      W10B49ED.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      W10B49ED.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      W10B49ED.SALARY_A length = 8
         label = 'SALARY_A',
      W10B49ED.SALARY_D length = 8
         label = 'SALARY_D',
      W10B49ED.SALARY_X length = 8
         label = 'SALARY_X',
      W10B49ED.SALARY_R length = 8
         label = 'SALARY_R',
      W10B49ED.SALARY_Z length = 8
         label = 'SALARY_Z',
      W10B49ED.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      W10B49ED.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      W10B49ED.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      W10B49ED.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      W10B49ED.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      W10B49ED.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      W10B49ED.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      W10B49ED.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      W10B49ED.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      W10B49ED.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      W10B49ED.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      IFC(UTA_TENURE_MAX_ORG_UPD_DT_CBM008.ACAD_ORG IS MISSING,
      PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_SUBVALUE,UTA_TENURE_MAX_ORG_UPD_DT_CBM008.ACAD_ORG) as ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      UTA_TENURE_MAX_ORG_UPD_DT_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      UTA_TENURE_MAX_ORG_UPD_DT_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      W10B49ED.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      W10B49ED.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      case UTA_TENURE_MAX_ORG_UPD_DT_CBM008.UTA_TT_RANK
         when '10'
            then '1'
         when '20'
            then '2'
         when '30'
            then '3'
         when '40'
            then '5'
         when '50'
            then '6'
         when '60'
            then '4'
      else '0'
      end as RANK_CBM length = 8
         label = 'RANK_CBM',
      W10B49ED.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W10B49ED.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W10B49ED.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      W10B49ED.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      W10B49ED.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      W10B49ED.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      W10B49ED.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      W10B49ED.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      W10B49ED.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W10B49ED.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W10B49ED.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      W10B49ED.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W10B49ED.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      W10B49ED.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W10B49ED as W10B49ED left join
      work.UTA_TENURE_MAX_ORG_UPD_DT_CBM008 as UTA_TENURE_MAX_ORG_UPD_DT_CBM008
         on
         (
            W10B49ED.CIT_CHK_EMPLID NOT IS MISSING
            and W10B49ED.CIT_CHK_EMPLID = UTA_TENURE_MAX_ORG_UPD_DT_CBM008.UTA_TT_EMPLID
         ) left join
      work.POSITION_DATA_MAX_EFFDT_CBM008 as POSITION_DATA_MAX_EFFDT_CBM008
         on
         (
            W10B49ED.UTA_HRA_POSITIONID = POSITION_DATA_MAX_EFFDT_CBM008.POSITION_NBR
         ) left join
      ADWSTGPR.PS_UTZ_PT100_DTL_Extract as PS_UTZ_PT100_DTL_Extract
         on
         (
            PS_UTZ_PT100_DTL_Extract.UTZ_PROG_ID = 'UTAS0036'
            and PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_ID = 'DEPTID_ACADORG'
            and POSITION_DATA_MAX_EFFDT_CBM008.DEPTID = PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_VALUE
            and (PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_RESULT IS MISSING
            or (PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_RESULT = 'EQUAL'
            and W10B49ED.UTA_HRA_ACCT_10 = PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_SUBRSLT)
            or (PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_RESULT = 'NOT EQUAL'
            and W10B49ED.UTA_HRA_ACCT_10 <> PS_UTZ_PT100_DTL_Extract.UTZ_SETUP_SUBRSLT))
         )
   ;
quit;

/*==========================================================================*
 * Step:            ACAD_ORG_MAX_EFFDT                    A5B29B8Q.BZ0005P0 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ACAD_ORG_TBL_Extract -             A5B29B8Q.BE00001P *
 *                   ADWSTGPR.PS_ACAD_ORG_TBL_Extract                       *
 * Target Table:    ACAD_ORG_MAX_EFFDT_CBM008 -           A5B29B8Q.BS0001TX *
 *                   work.ACAD_ORG_MAX_EFFDT_CBM008                         *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P0);

%let SYSLAST = %nrquote(ADWSTGPR.PS_ACAD_ORG_TBL_Extract);

proc sql;
   create table work.ACAD_ORG_MAX_EFFDT_CBM008 as
   select
      PS_ACAD_ORG_TBL_Extract.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      PS_ACAD_ORG_TBL_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ACAD_ORG_TBL_Extract.EFF_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EFF_STATUS',
      PS_ACAD_ORG_TBL_Extract.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      PS_ACAD_ORG_TBL_Extract.DESCRSHORT length = 10
         format = $10.
         informat = $10.
         label = 'DESCRSHORT',
      PS_ACAD_ORG_TBL_Extract.DESCRFORMAL length = 50
         format = $50.
         informat = $50.
         label = 'DESCRFORMAL',
      PS_ACAD_ORG_TBL_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_ACAD_ORG_TBL_Extract.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      PS_ACAD_ORG_TBL_Extract.MANAGER_ID length = 11
         format = $11.
         informat = $11.
         label = 'MANAGER_ID',
      PS_ACAD_ORG_TBL_Extract.INSTR_EDIT length = 1
         format = $1.
         informat = $1.
         label = 'INSTR_EDIT',
      PS_ACAD_ORG_TBL_Extract.CAMPUS_EDIT length = 1
         format = $1.
         informat = $1.
         label = 'CAMPUS_EDIT',
      PS_ACAD_ORG_TBL_Extract.SUBJECT_EDIT length = 1
         format = $1.
         informat = $1.
         label = 'SUBJECT_EDIT',
      PS_ACAD_ORG_TBL_Extract.COURSE_EDIT length = 1
         format = $1.
         informat = $1.
         label = 'COURSE_EDIT'
   from
      ADWSTGPR.PS_ACAD_ORG_TBL_Extract as PS_ACAD_ORG_TBL_Extract
   where
      PS_ACAD_ORG_TBL_Extract.EFFDT <= DATETIME()
      and PS_ACAD_ORG_TBL_Extract.EFF_STATUS = 'A'
   group by
      PS_ACAD_ORG_TBL_Extract.ACAD_ORG
   having
      PS_ACAD_ORG_TBL_Extract.EFFDT = MAX(PS_ACAD_ORG_TBL_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            VALIDATE_ORG                          A5B29B8Q.BZ0005P1 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_TENURE_RECORD_CBM008 -           A5B29B8Q.BS0001TW *
 *                   work.READ_TENURE_RECORD_CBM008                         *
 *                  ACAD_ORG_MAX_EFFDT_CBM008 -           A5B29B8Q.BS0001TX *
 *                   work.ACAD_ORG_MAX_EFFDT_CBM008                         *
 * Target Table:    VALIDATE_ORG_CBM008 -                 A5B29B8Q.BS0001TY *
 *                   work.VALIDATE_ORG_CBM008                               *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P1);

proc sql;
   create table work.VALIDATE_ORG_CBM008 as
   select
      READ_TENURE_RECORD_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_TENURE_RECORD_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_TENURE_RECORD_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      READ_TENURE_RECORD_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      READ_TENURE_RECORD_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_TENURE_RECORD_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      READ_TENURE_RECORD_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_TENURE_RECORD_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      READ_TENURE_RECORD_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_TENURE_RECORD_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_TENURE_RECORD_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_TENURE_RECORD_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      READ_TENURE_RECORD_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      READ_TENURE_RECORD_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      READ_TENURE_RECORD_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      READ_TENURE_RECORD_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      READ_TENURE_RECORD_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      READ_TENURE_RECORD_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      READ_TENURE_RECORD_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      READ_TENURE_RECORD_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      READ_TENURE_RECORD_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      READ_TENURE_RECORD_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      READ_TENURE_RECORD_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      READ_TENURE_RECORD_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      READ_TENURE_RECORD_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      READ_TENURE_RECORD_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_TENURE_RECORD_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      READ_TENURE_RECORD_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      READ_TENURE_RECORD_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      READ_TENURE_RECORD_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      READ_TENURE_RECORD_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      READ_TENURE_RECORD_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      READ_TENURE_RECORD_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      READ_TENURE_RECORD_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      READ_TENURE_RECORD_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      READ_TENURE_RECORD_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      READ_TENURE_RECORD_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      READ_TENURE_RECORD_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      IFC(LENGTH(STRIP(ACAD_ORG_MAX_EFFDT_CBM008.DESCRSHORT))>4,
      '',STRIP(ACAD_ORG_MAX_EFFDT_CBM008.DESCRSHORT)) as ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      READ_TENURE_RECORD_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_TENURE_RECORD_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      READ_TENURE_RECORD_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_TENURE_RECORD_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_TENURE_RECORD_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_TENURE_RECORD_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_TENURE_RECORD_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_TENURE_RECORD_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      READ_TENURE_RECORD_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      READ_TENURE_RECORD_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_TENURE_RECORD_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      READ_TENURE_RECORD_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      READ_TENURE_RECORD_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_TENURE_RECORD_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      READ_TENURE_RECORD_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      READ_TENURE_RECORD_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.READ_TENURE_RECORD_CBM008 as READ_TENURE_RECORD_CBM008 left join
      work.ACAD_ORG_MAX_EFFDT_CBM008 as ACAD_ORG_MAX_EFFDT_CBM008
         on
         (
            READ_TENURE_RECORD_CBM008.ACAD_ORG NOT IS MISSING
            and READ_TENURE_RECORD_CBM008.ACAD_ORG = ACAD_ORG_MAX_EFFDT_CBM008.ACAD_ORG
         )
   ;
quit;

/*==========================================================================*
 * Step:            FOUND_ACAD_ORG_UNITCD                 A5B29B8Q.BZ0005P2 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    VALIDATE_ORG_CBM008 -                 A5B29B8Q.BS0001TY *
 *                   work.VALIDATE_ORG_CBM008                               *
 * Target Table:    FOUND_ACAD_ORG_UNITCD_CBM008 -        A5B29B8Q.BS0001TZ *
 *                   work.FOUND_ACAD_ORG_UNITCD_CBM008                      *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P2);

%let SYSLAST = %nrquote(work.VALIDATE_ORG_CBM008);

proc sql;
   create table work.FOUND_ACAD_ORG_UNITCD_CBM008 as
   select
      VALIDATE_ORG_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      VALIDATE_ORG_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      VALIDATE_ORG_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      VALIDATE_ORG_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      VALIDATE_ORG_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      VALIDATE_ORG_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      VALIDATE_ORG_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      VALIDATE_ORG_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      VALIDATE_ORG_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      VALIDATE_ORG_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      VALIDATE_ORG_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      VALIDATE_ORG_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      VALIDATE_ORG_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      VALIDATE_ORG_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      VALIDATE_ORG_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      VALIDATE_ORG_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      VALIDATE_ORG_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      VALIDATE_ORG_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      VALIDATE_ORG_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      VALIDATE_ORG_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      VALIDATE_ORG_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      VALIDATE_ORG_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      VALIDATE_ORG_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      VALIDATE_ORG_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      VALIDATE_ORG_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      VALIDATE_ORG_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      VALIDATE_ORG_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      VALIDATE_ORG_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      VALIDATE_ORG_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      VALIDATE_ORG_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      VALIDATE_ORG_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      VALIDATE_ORG_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      VALIDATE_ORG_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      VALIDATE_ORG_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      VALIDATE_ORG_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      VALIDATE_ORG_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      VALIDATE_ORG_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      VALIDATE_ORG_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      VALIDATE_ORG_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      VALIDATE_ORG_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      VALIDATE_ORG_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      VALIDATE_ORG_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      VALIDATE_ORG_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      VALIDATE_ORG_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      VALIDATE_ORG_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      VALIDATE_ORG_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      VALIDATE_ORG_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      VALIDATE_ORG_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      VALIDATE_ORG_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      VALIDATE_ORG_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      VALIDATE_ORG_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      VALIDATE_ORG_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      VALIDATE_ORG_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      VALIDATE_ORG_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      VALIDATE_ORG_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.VALIDATE_ORG_CBM008 as VALIDATE_ORG_CBM008
   where
      not (VALIDATE_ORG_CBM008.ACAD_ORG_UNITCD = ''
      and VALIDATE_ORG_CBM008.RANK_CBM IN ('5','6'))
   ;
quit;

/*==========================================================================*
 * Step:            MISSING_ACAD_ORG_UNITCD               A5B29B8Q.BZ0005P3 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    VALIDATE_ORG_CBM008 -                 A5B29B8Q.BS0001TY *
 *                   work.VALIDATE_ORG_CBM008                               *
 * Target Table:    MISSING_ACAD_ORG_UNITCD_CBM008 -      A5B29B8Q.BS0001U0 *
 *                   work.MISSING_ACAD_ORG_UNITCD_CBM008                    *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P3);

%let SYSLAST = %nrquote(work.VALIDATE_ORG_CBM008);

proc sql;
   create table work.MISSING_ACAD_ORG_UNITCD_CBM008 as
   select
      VALIDATE_ORG_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      VALIDATE_ORG_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      VALIDATE_ORG_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      VALIDATE_ORG_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      VALIDATE_ORG_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      VALIDATE_ORG_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      VALIDATE_ORG_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      VALIDATE_ORG_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      VALIDATE_ORG_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      VALIDATE_ORG_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      VALIDATE_ORG_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      VALIDATE_ORG_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      VALIDATE_ORG_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      VALIDATE_ORG_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      VALIDATE_ORG_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      VALIDATE_ORG_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      VALIDATE_ORG_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      VALIDATE_ORG_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      VALIDATE_ORG_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      VALIDATE_ORG_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      VALIDATE_ORG_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      VALIDATE_ORG_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      VALIDATE_ORG_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      VALIDATE_ORG_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      VALIDATE_ORG_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      VALIDATE_ORG_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      VALIDATE_ORG_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      VALIDATE_ORG_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      VALIDATE_ORG_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      VALIDATE_ORG_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      VALIDATE_ORG_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      VALIDATE_ORG_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      VALIDATE_ORG_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      VALIDATE_ORG_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      VALIDATE_ORG_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      VALIDATE_ORG_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      VALIDATE_ORG_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      VALIDATE_ORG_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      VALIDATE_ORG_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      VALIDATE_ORG_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      VALIDATE_ORG_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      VALIDATE_ORG_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      VALIDATE_ORG_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      VALIDATE_ORG_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      VALIDATE_ORG_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      VALIDATE_ORG_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      VALIDATE_ORG_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      VALIDATE_ORG_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      VALIDATE_ORG_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      VALIDATE_ORG_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      VALIDATE_ORG_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      VALIDATE_ORG_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      VALIDATE_ORG_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      VALIDATE_ORG_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      VALIDATE_ORG_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.VALIDATE_ORG_CBM008 as VALIDATE_ORG_CBM008
   where
      VALIDATE_ORG_CBM008.ACAD_ORG_UNITCD = ''
      and VALIDATE_ORG_CBM008.RANK_CBM IN ('5','6')
   ;
quit;

/*==========================================================================*
 * Step:            GET_A_CRSEID                          A5B29B8Q.BZ0005P4 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_CLASS_INSTR_Extract -              A5B29B8Q.BE00002S *
 *                   ADWSTGPR.PS_CLASS_INSTR_Extract                        *
 *                  MISSING_ACAD_ORG_UNITCD_CBM008 -      A5B29B8Q.BS0001U0 *
 *                   work.MISSING_ACAD_ORG_UNITCD_CBM008                    *
 * Target Table:    GET_A_CRSEID_CBM008 -                 A5B29B8Q.BS0001U1 *
 *                   work.GET_A_CRSEID_CBM008                               *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P4);

proc sql;
   create table work.GET_A_CRSEID_CBM008 as
   select
      MISSING_ACAD_ORG_UNITCD_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      MISSING_ACAD_ORG_UNITCD_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      MISSING_ACAD_ORG_UNITCD_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      MISSING_ACAD_ORG_UNITCD_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      MISSING_ACAD_ORG_UNITCD_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      MISSING_ACAD_ORG_UNITCD_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      MISSING_ACAD_ORG_UNITCD_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      MISSING_ACAD_ORG_UNITCD_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      MISSING_ACAD_ORG_UNITCD_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      MISSING_ACAD_ORG_UNITCD_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      MISSING_ACAD_ORG_UNITCD_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      MISSING_ACAD_ORG_UNITCD_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      MISSING_ACAD_ORG_UNITCD_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      MISSING_ACAD_ORG_UNITCD_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      MISSING_ACAD_ORG_UNITCD_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      MISSING_ACAD_ORG_UNITCD_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      MISSING_ACAD_ORG_UNITCD_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      MISSING_ACAD_ORG_UNITCD_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      MISSING_ACAD_ORG_UNITCD_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      MISSING_ACAD_ORG_UNITCD_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      MISSING_ACAD_ORG_UNITCD_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      MISSING_ACAD_ORG_UNITCD_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      MISSING_ACAD_ORG_UNITCD_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      MISSING_ACAD_ORG_UNITCD_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      MISSING_ACAD_ORG_UNITCD_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      MISSING_ACAD_ORG_UNITCD_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      MISSING_ACAD_ORG_UNITCD_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      PS_CLASS_INSTR_Extract.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_CLASS_INSTR_Extract.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      MISSING_ACAD_ORG_UNITCD_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      MISSING_ACAD_ORG_UNITCD_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      MISSING_ACAD_ORG_UNITCD_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      MISSING_ACAD_ORG_UNITCD_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      MISSING_ACAD_ORG_UNITCD_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      MISSING_ACAD_ORG_UNITCD_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      MISSING_ACAD_ORG_UNITCD_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      MISSING_ACAD_ORG_UNITCD_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      MISSING_ACAD_ORG_UNITCD_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.MISSING_ACAD_ORG_UNITCD_CBM008 as MISSING_ACAD_ORG_UNITCD_CBM008 left join
      ADWSTGPR.PS_CLASS_INSTR_Extract as PS_CLASS_INSTR_Extract
         on
         (
            PS_CLASS_INSTR_Extract.ASSIGN_TYPE NOT IN ('EXC','NON')
            and MISSING_ACAD_ORG_UNITCD_CBM008.CIT_CHK_EMPLID = PS_CLASS_INSTR_Extract.EMPLID
            and MISSING_ACAD_ORG_UNITCD_CBM008.STRM = PS_CLASS_INSTR_Extract.STRM
         )
   ;
quit;

/*==========================================================================*
 * Step:            READ_4_PRIMARY_APPT                   A5B29B8Q.BZ0005P5 *
 * Transform:       Join                                                    *
 * Description:     ***TO BE COMPLETED***                                   *
 *                                                                          *
 * Source Table:    GET_A_CRSEID_CBM008 -                 A5B29B8Q.BS0001U1 *
 *                   work.GET_A_CRSEID_CBM008                               *
 * Target Table:    READ_4_PRIMARY_APPT_CBM008 -          A5B29B8Q.BS0001U2 *
 *                   work.READ_4_PRIMARY_APPT_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P5);

%let SYSLAST = %nrquote(work.GET_A_CRSEID_CBM008);

proc sql;
   create table work.READ_4_PRIMARY_APPT_CBM008 as
   select
      GET_A_CRSEID_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      GET_A_CRSEID_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      GET_A_CRSEID_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      GET_A_CRSEID_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      GET_A_CRSEID_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      GET_A_CRSEID_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      GET_A_CRSEID_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      GET_A_CRSEID_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      GET_A_CRSEID_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      GET_A_CRSEID_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      GET_A_CRSEID_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      GET_A_CRSEID_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      GET_A_CRSEID_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      GET_A_CRSEID_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      GET_A_CRSEID_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      GET_A_CRSEID_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      GET_A_CRSEID_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      GET_A_CRSEID_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      GET_A_CRSEID_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      GET_A_CRSEID_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      GET_A_CRSEID_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      GET_A_CRSEID_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      GET_A_CRSEID_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      GET_A_CRSEID_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      GET_A_CRSEID_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      GET_A_CRSEID_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      GET_A_CRSEID_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      GET_A_CRSEID_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      GET_A_CRSEID_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      GET_A_CRSEID_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      GET_A_CRSEID_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      GET_A_CRSEID_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      GET_A_CRSEID_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      GET_A_CRSEID_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      GET_A_CRSEID_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      GET_A_CRSEID_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      GET_A_CRSEID_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      GET_A_CRSEID_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      GET_A_CRSEID_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      GET_A_CRSEID_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      GET_A_CRSEID_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      GET_A_CRSEID_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      GET_A_CRSEID_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      GET_A_CRSEID_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      GET_A_CRSEID_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      GET_A_CRSEID_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      GET_A_CRSEID_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      GET_A_CRSEID_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      GET_A_CRSEID_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      GET_A_CRSEID_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      GET_A_CRSEID_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      GET_A_CRSEID_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      GET_A_CRSEID_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      GET_A_CRSEID_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      GET_A_CRSEID_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      GET_A_CRSEID_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      GET_A_CRSEID_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.GET_A_CRSEID_CBM008 as GET_A_CRSEID_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            Set Operators                         A5B29B8Q.BZ0005P6 *
 * Transform:       Set Operators                                           *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   FOUND_ACAD_ORG_UNITCD_CBM008 -        A5B29B8Q.BS0001TZ *
 *                   work.FOUND_ACAD_ORG_UNITCD_CBM008                      *
 *                  READ_4_PRIMARY_APPT_CBM008 -          A5B29B8Q.BS0001U2 *
 *                   work.READ_4_PRIMARY_APPT_CBM008                        *
 * Target Table:    Set Operators - work.W3EFKKTZ         A5B29B8Q.BS0001U3 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P6);

proc sql;
   create table work.W3EFKKTZ as
   /* Returns all unique rows from the two query results.  */
   select
      FOUND_ACAD_ORG_UNITCD_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      FOUND_ACAD_ORG_UNITCD_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      FOUND_ACAD_ORG_UNITCD_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      FOUND_ACAD_ORG_UNITCD_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      FOUND_ACAD_ORG_UNITCD_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      FOUND_ACAD_ORG_UNITCD_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      FOUND_ACAD_ORG_UNITCD_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      FOUND_ACAD_ORG_UNITCD_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      FOUND_ACAD_ORG_UNITCD_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      FOUND_ACAD_ORG_UNITCD_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      FOUND_ACAD_ORG_UNITCD_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      FOUND_ACAD_ORG_UNITCD_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      FOUND_ACAD_ORG_UNITCD_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      FOUND_ACAD_ORG_UNITCD_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      FOUND_ACAD_ORG_UNITCD_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      FOUND_ACAD_ORG_UNITCD_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      FOUND_ACAD_ORG_UNITCD_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      FOUND_ACAD_ORG_UNITCD_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      FOUND_ACAD_ORG_UNITCD_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      FOUND_ACAD_ORG_UNITCD_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      FOUND_ACAD_ORG_UNITCD_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      FOUND_ACAD_ORG_UNITCD_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      FOUND_ACAD_ORG_UNITCD_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      FOUND_ACAD_ORG_UNITCD_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      FOUND_ACAD_ORG_UNITCD_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      FOUND_ACAD_ORG_UNITCD_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      FOUND_ACAD_ORG_UNITCD_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      "" as CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      . as CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      FOUND_ACAD_ORG_UNITCD_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      FOUND_ACAD_ORG_UNITCD_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      FOUND_ACAD_ORG_UNITCD_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      FOUND_ACAD_ORG_UNITCD_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      FOUND_ACAD_ORG_UNITCD_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      FOUND_ACAD_ORG_UNITCD_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      FOUND_ACAD_ORG_UNITCD_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      FOUND_ACAD_ORG_UNITCD_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      FOUND_ACAD_ORG_UNITCD_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.FOUND_ACAD_ORG_UNITCD_CBM008
   union all
   select
      READ_4_PRIMARY_APPT_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_4_PRIMARY_APPT_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_PRIMARY_APPT_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      READ_4_PRIMARY_APPT_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      READ_4_PRIMARY_APPT_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_PRIMARY_APPT_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      READ_4_PRIMARY_APPT_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_4_PRIMARY_APPT_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      READ_4_PRIMARY_APPT_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_4_PRIMARY_APPT_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_4_PRIMARY_APPT_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_4_PRIMARY_APPT_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      READ_4_PRIMARY_APPT_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      READ_4_PRIMARY_APPT_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      READ_4_PRIMARY_APPT_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      READ_4_PRIMARY_APPT_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      READ_4_PRIMARY_APPT_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      READ_4_PRIMARY_APPT_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      READ_4_PRIMARY_APPT_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      READ_4_PRIMARY_APPT_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      READ_4_PRIMARY_APPT_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      READ_4_PRIMARY_APPT_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      READ_4_PRIMARY_APPT_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      READ_4_PRIMARY_APPT_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      READ_4_PRIMARY_APPT_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      READ_4_PRIMARY_APPT_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_4_PRIMARY_APPT_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      READ_4_PRIMARY_APPT_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      READ_4_PRIMARY_APPT_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      READ_4_PRIMARY_APPT_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      READ_4_PRIMARY_APPT_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      READ_4_PRIMARY_APPT_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      READ_4_PRIMARY_APPT_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      READ_4_PRIMARY_APPT_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      READ_4_PRIMARY_APPT_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      READ_4_PRIMARY_APPT_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      READ_4_PRIMARY_APPT_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      READ_4_PRIMARY_APPT_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      READ_4_PRIMARY_APPT_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      READ_4_PRIMARY_APPT_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_4_PRIMARY_APPT_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      READ_4_PRIMARY_APPT_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      READ_4_PRIMARY_APPT_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      READ_4_PRIMARY_APPT_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_4_PRIMARY_APPT_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_4_PRIMARY_APPT_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_4_PRIMARY_APPT_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_4_PRIMARY_APPT_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_4_PRIMARY_APPT_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      READ_4_PRIMARY_APPT_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      READ_4_PRIMARY_APPT_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_4_PRIMARY_APPT_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      READ_4_PRIMARY_APPT_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      READ_4_PRIMARY_APPT_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_4_PRIMARY_APPT_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      READ_4_PRIMARY_APPT_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      READ_4_PRIMARY_APPT_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.READ_4_PRIMARY_APPT_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            ETHNIC_GRP_MAX_EFFDT                  A5B29B8Q.BZ0005P7 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_HCR_ETHNIC_GRP_I_Extract -         A5B29B8Q.BE00003U *
 *                   ADWSTGPR.PS_HCR_ETHNIC_GRP_I_Extract                   *
 * Target Table:    ETHNIC_GRP_MAX_EFFDT_CBM008 -         A5B29B8Q.BS0001U4 *
 *                   work.ETHNIC_GRP_MAX_EFFDT_CBM008                       *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P7);

%let SYSLAST = %nrquote(ADWSTGPR.PS_HCR_ETHNIC_GRP_I_Extract);

proc sql;
   create table work.ETHNIC_GRP_MAX_EFFDT_CBM008 as
   select
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
      PS_HCR_ETHNIC_GRP_I_Extract.EFFDT <= DATETIME()
   group by
      PS_HCR_ETHNIC_GRP_I_Extract.SETID,
      PS_HCR_ETHNIC_GRP_I_Extract.ETHNIC_GRP_CD
   having
      PS_HCR_ETHNIC_GRP_I_Extract.EFFDT = MAX(PS_HCR_ETHNIC_GRP_I_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            CALC_ETHN_GRP                         A5B29B8Q.BZ0005P8 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_HCR_DIV_ETHNIC_I_Extract -         A5B29B8Q.BE00003T *
 *                   ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract                   *
 *                  ETHNIC_GRP_MAX_EFFDT_CBM008 -         A5B29B8Q.BS0001U4 *
 *                   work.ETHNIC_GRP_MAX_EFFDT_CBM008                       *
 * Target Table:    CALC_ETHN_GRP_CBM008 -                A5B29B8Q.BS0001U5 *
 *                   work.CALC_ETHN_GRP_CBM008                              *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P8);

proc sql;
   create table work.CALC_ETHN_GRP_CBM008 as
   select distinct
      PS_HCR_DIV_ETHNIC_I_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      IFC(COUNT(distinct ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP)>1 |
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='3' |
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP NOT IN ('1','2','3','4','5','6','7'),'7',
      IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='8','4',
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP)) as ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      MIN(IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='3','1','3')) as ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      MAX(IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='1',
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP,'')) as RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      MAX(IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='2',
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP,'')) as RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      MAX(IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='4',
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP,'')) as RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      MAX(IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='5',
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP,'')) as RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      MAX(IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='6',
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP,'')) as RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      IFC(COUNT(distinct ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP)=1 &
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='3','7',
      MAX(IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='7' |
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP NOT IN ('1','2','3','4','5','6','7','8'),'7',''))) as RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      MAX(IFC(ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP='8',
      ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GROUP,'')) as RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER'
   from
      ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract as PS_HCR_DIV_ETHNIC_I_Extract inner join
      work.ETHNIC_GRP_MAX_EFFDT_CBM008 as ETHNIC_GRP_MAX_EFFDT_CBM008
         on
         (
            PS_HCR_DIV_ETHNIC_I_Extract.ETHNIC_GRP_CD = ETHNIC_GRP_MAX_EFFDT_CBM008.ETHNIC_GRP_CD
         )
   where
      PS_HCR_DIV_ETHNIC_I_Extract.REG_REGION = 'USA'
      and ETHNIC_GRP_MAX_EFFDT_CBM008.SETID = 'USA'
   group by
      PS_HCR_DIV_ETHNIC_I_Extract.EMPLID
   ;
quit;

/*==========================================================================*
 * Step:            GET_ETHNIC_INFO                       A5B29B8Q.BZ0005P9 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Set Operators - work.W3EFKKTZ         A5B29B8Q.BS0001U3 *
 *                  CALC_ETHN_GRP_CBM008 -                A5B29B8Q.BS0001U5 *
 *                   work.CALC_ETHN_GRP_CBM008                              *
 * Target Table:    GET_ETHNIC_INFO_CBM008 -              A5B29B8Q.BS0001U6 *
 *                   work.GET_ETHNIC_INFO_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005P9);

proc sql;
   create table work.GET_ETHNIC_INFO_CBM008 as
   select
      W3EFKKTZ.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      W3EFKKTZ.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W3EFKKTZ.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      W3EFKKTZ.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      W3EFKKTZ.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W3EFKKTZ.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W3EFKKTZ.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      W3EFKKTZ.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      W3EFKKTZ.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W3EFKKTZ.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      W3EFKKTZ.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W3EFKKTZ.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W3EFKKTZ.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      W3EFKKTZ.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      W3EFKKTZ.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      W3EFKKTZ.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      W3EFKKTZ.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      W3EFKKTZ.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      W3EFKKTZ.SALARY_A length = 8
         label = 'SALARY_A',
      W3EFKKTZ.SALARY_D length = 8
         label = 'SALARY_D',
      W3EFKKTZ.SALARY_X length = 8
         label = 'SALARY_X',
      W3EFKKTZ.SALARY_R length = 8
         label = 'SALARY_R',
      W3EFKKTZ.SALARY_Z length = 8
         label = 'SALARY_Z',
      W3EFKKTZ.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      W3EFKKTZ.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      W3EFKKTZ.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      W3EFKKTZ.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      W3EFKKTZ.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      W3EFKKTZ.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      W3EFKKTZ.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      W3EFKKTZ.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      W3EFKKTZ.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      W3EFKKTZ.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      W3EFKKTZ.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      W3EFKKTZ.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      W3EFKKTZ.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      W3EFKKTZ.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      W3EFKKTZ.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      "" as UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      W3EFKKTZ.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      W3EFKKTZ.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W3EFKKTZ.RANK_CBM length = 8
         label = 'RANK_CBM',
      W3EFKKTZ.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W3EFKKTZ.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      CALC_ETHN_GRP_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      IFC(CALC_ETHN_GRP_CBM008.ETHNIC_ORIGIN IS MISSING,'3',
      CALC_ETHN_GRP_CBM008.ETHNIC_ORIGIN) as ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CALC_ETHN_GRP_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      CALC_ETHN_GRP_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      CALC_ETHN_GRP_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      CALC_ETHN_GRP_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      CALC_ETHN_GRP_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      IFC(CALC_ETHN_GRP_CBM008.EMPLID IS MISSING,'7',
      CALC_ETHN_GRP_CBM008.RACE_UNKOWN) as RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      CALC_ETHN_GRP_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      W3EFKKTZ.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W3EFKKTZ.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W3EFKKTZ.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      W3EFKKTZ.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      W3EFKKTZ.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      W3EFKKTZ.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      W3EFKKTZ.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      W3EFKKTZ.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      W3EFKKTZ.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W3EFKKTZ.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W3EFKKTZ.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      W3EFKKTZ.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W3EFKKTZ.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      W3EFKKTZ.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W3EFKKTZ as W3EFKKTZ left join
      work.CALC_ETHN_GRP_CBM008 as CALC_ETHN_GRP_CBM008
         on
         (
            W3EFKKTZ.CIT_CHK_EMPLID = CALC_ETHN_GRP_CBM008.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            CITIZENSHIP_COUNTRY                   A5B29B8Q.BZ0005PA *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_CITIZENSHIP_Extract -              A5B29B8Q.BE00002R *
 *                   ADWSTGPR.PS_CITIZENSHIP_Extract                        *
 * Target Table:    CITIZENSHIP_COUNTRY_CBM008 -          A5B29B8Q.BS0001U7 *
 *                   work.CITIZENSHIP_COUNTRY_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PA);

%let SYSLAST = %nrquote(ADWSTGPR.PS_CITIZENSHIP_Extract);

proc sql;
   create table work.CITIZENSHIP_COUNTRY_CBM008 as
   select distinct
      MAX(IFC(PS_CITIZENSHIP_Extract.COUNTRY='XXX','XXX',
      IFC(PS_CITIZENSHIP_Extract.COUNTRY='USA',
      PS_CITIZENSHIP_Extract.COUNTRY,''))) as COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      PS_CITIZENSHIP_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID'
   from
      ADWSTGPR.PS_CITIZENSHIP_Extract as PS_CITIZENSHIP_Extract
   group by
      PS_CITIZENSHIP_Extract.EMPLID
   ;
quit;

/*==========================================================================*
 * Step:            CHECK_CITIZENSHIP                     A5B29B8Q.BZ0005PB *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   GET_ETHNIC_INFO_CBM008 -              A5B29B8Q.BS0001U6 *
 *                   work.GET_ETHNIC_INFO_CBM008                            *
 *                  CITIZENSHIP_COUNTRY_CBM008 -          A5B29B8Q.BS0001U7 *
 *                   work.CITIZENSHIP_COUNTRY_CBM008                        *
 * Target Table:    CHECK_CITIZENSHIP_CBM008 -            A5B29B8Q.BS0001U8 *
 *                   work.CHECK_CITIZENSHIP_CBM008                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PB);

proc sql;
   create table work.CHECK_CITIZENSHIP_CBM008 as
   select
      GET_ETHNIC_INFO_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      GET_ETHNIC_INFO_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      GET_ETHNIC_INFO_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      GET_ETHNIC_INFO_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      GET_ETHNIC_INFO_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      GET_ETHNIC_INFO_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      GET_ETHNIC_INFO_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      GET_ETHNIC_INFO_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      GET_ETHNIC_INFO_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      GET_ETHNIC_INFO_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      GET_ETHNIC_INFO_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      GET_ETHNIC_INFO_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      GET_ETHNIC_INFO_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      GET_ETHNIC_INFO_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      GET_ETHNIC_INFO_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      GET_ETHNIC_INFO_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      GET_ETHNIC_INFO_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      GET_ETHNIC_INFO_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      GET_ETHNIC_INFO_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      GET_ETHNIC_INFO_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      GET_ETHNIC_INFO_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      GET_ETHNIC_INFO_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      GET_ETHNIC_INFO_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      GET_ETHNIC_INFO_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      GET_ETHNIC_INFO_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      GET_ETHNIC_INFO_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      GET_ETHNIC_INFO_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      GET_ETHNIC_INFO_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      GET_ETHNIC_INFO_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      GET_ETHNIC_INFO_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      GET_ETHNIC_INFO_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      GET_ETHNIC_INFO_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      GET_ETHNIC_INFO_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      GET_ETHNIC_INFO_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      GET_ETHNIC_INFO_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      GET_ETHNIC_INFO_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      GET_ETHNIC_INFO_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      GET_ETHNIC_INFO_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      GET_ETHNIC_INFO_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      GET_ETHNIC_INFO_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      GET_ETHNIC_INFO_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      GET_ETHNIC_INFO_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      GET_ETHNIC_INFO_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      GET_ETHNIC_INFO_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      GET_ETHNIC_INFO_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      GET_ETHNIC_INFO_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      IFC(CITIZENSHIP_COUNTRY_CBM008.EMPLID IS MISSING,'',
      IFC(CITIZENSHIP_COUNTRY_CBM008.COUNTRY='USA',
      CITIZENSHIP_COUNTRY_CBM008.COUNTRY,'OTH')) as COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      GET_ETHNIC_INFO_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      GET_ETHNIC_INFO_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      GET_ETHNIC_INFO_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      GET_ETHNIC_INFO_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      GET_ETHNIC_INFO_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      GET_ETHNIC_INFO_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      GET_ETHNIC_INFO_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      GET_ETHNIC_INFO_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      GET_ETHNIC_INFO_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      GET_ETHNIC_INFO_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      GET_ETHNIC_INFO_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      GET_ETHNIC_INFO_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      GET_ETHNIC_INFO_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      GET_ETHNIC_INFO_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      GET_ETHNIC_INFO_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      GET_ETHNIC_INFO_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      GET_ETHNIC_INFO_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      GET_ETHNIC_INFO_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      GET_ETHNIC_INFO_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      GET_ETHNIC_INFO_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      GET_ETHNIC_INFO_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.GET_ETHNIC_INFO_CBM008 as GET_ETHNIC_INFO_CBM008 left join
      work.CITIZENSHIP_COUNTRY_CBM008 as CITIZENSHIP_COUNTRY_CBM008
         on
         (
            GET_ETHNIC_INFO_CBM008.CIT_CHK_EMPLID = CITIZENSHIP_COUNTRY_CBM008.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            VISA_PMT_MAX_EFFDT                    A5B29B8Q.BZ0005PC *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_VISA_PMT_DATA_Extract -            A5B29B8Q.BE00008N *
 *                   ADWSTGPR.PS_VISA_PMT_DATA_Extract                      *
 * Target Table:    VISA_PMT_MAX_EFFDT_CBM008 -           A5B29B8Q.BS0001U9 *
 *                   work.VISA_PMT_MAX_EFFDT_CBM008                         *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PC);

%let SYSLAST = %nrquote(ADWSTGPR.PS_VISA_PMT_DATA_Extract);

proc sql;
   create table work.VISA_PMT_MAX_EFFDT_CBM008 as
   select distinct
      PS_VISA_PMT_DATA_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_VISA_PMT_DATA_Extract.DEPENDENT_ID length = 2
         format = $2.
         informat = $2.
         label = 'DEPENDENT_ID',
      PS_VISA_PMT_DATA_Extract.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      PS_VISA_PMT_DATA_Extract.VISA_PERMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'VISA_PERMIT_TYPE',
      PS_VISA_PMT_DATA_Extract.EFFDT length = 8
         format = DATETIME24.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_VISA_PMT_DATA_Extract.VISA_WRKPMT_NBR length = 15
         format = $15.
         informat = $15.
         label = 'VISA_WRKPMT_NBR',
      PS_VISA_PMT_DATA_Extract.VISA_WRKPMT_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'VISA_WRKPMT_STATUS',
      PS_VISA_PMT_DATA_Extract.STATUS_DT length = 8
         format = DATETIME24.
         informat = DATETIME20.
         label = 'STATUS_DT',
      PS_VISA_PMT_DATA_Extract.DT_ISSUED length = 8
         format = DATETIME24.
         informat = DATETIME20.
         label = 'DT_ISSUED',
      PS_VISA_PMT_DATA_Extract.PLACE_ISSUED length = 30
         format = $30.
         informat = $30.
         label = 'PLACE_ISSUED',
      PS_VISA_PMT_DATA_Extract.DURATION_TIME length = 8
         format = DOLLAR8.2
         informat = DOLLAR8.2
         label = 'DURATION_TIME',
      PS_VISA_PMT_DATA_Extract.DURATION_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'DURATION_TYPE',
      PS_VISA_PMT_DATA_Extract.ENTRY_DT length = 8
         format = DATETIME24.
         informat = DATETIME20.
         label = 'ENTRY_DT',
      PS_VISA_PMT_DATA_Extract.EXPIRATN_DT length = 8
         format = DATETIME24.
         informat = DATETIME20.
         label = 'EXPIRATN_DT',
      PS_VISA_PMT_DATA_Extract.ISSUING_AUTHORITY length = 50
         format = $50.
         informat = $50.
         label = 'ISSUING_AUTHORITY'
   from
      ADWSTGPR.PS_VISA_PMT_DATA_Extract as PS_VISA_PMT_DATA_Extract
   where
      PS_VISA_PMT_DATA_Extract.EFFDT <= DATETIME()
   group by
      PS_VISA_PMT_DATA_Extract.EMPLID
   having
      PS_VISA_PMT_DATA_Extract.EFFDT = MAX(PS_VISA_PMT_DATA_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            IDS_W_GOOD_PERMIT_TYPES               A5B29B8Q.BZ0005PD *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    VISA_PMT_MAX_EFFDT_CBM008 -           A5B29B8Q.BS0001U9 *
 *                   work.VISA_PMT_MAX_EFFDT_CBM008                         *
 * Target Table:    IDS_W_GOOD_PERMIT_TYPES_CBM008 -      A5B29B8Q.BS0001UA *
 *                   work.IDS_W_GOOD_PERMIT_TYPES_CBM008                    *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PD);

%let SYSLAST = %nrquote(work.VISA_PMT_MAX_EFFDT_CBM008);

proc sql;
   create table work.IDS_W_GOOD_PERMIT_TYPES_CBM008 as
   select distinct
      VISA_PMT_MAX_EFFDT_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID'
   from
      work.VISA_PMT_MAX_EFFDT_CBM008 as VISA_PMT_MAX_EFFDT_CBM008
   where
      VISA_PMT_MAX_EFFDT_CBM008.VISA_PERMIT_TYPE IN ('AR1','ASY','LPR','PLP','REF')
   ;
quit;

/*==========================================================================*
 * Step:            CHECK_VISA_TYPE                       A5B29B8Q.BZ0005PE *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   CHECK_CITIZENSHIP_CBM008 -            A5B29B8Q.BS0001U8 *
 *                   work.CHECK_CITIZENSHIP_CBM008                          *
 *                  IDS_W_GOOD_PERMIT_TYPES_CBM008 -      A5B29B8Q.BS0001UA *
 *                   work.IDS_W_GOOD_PERMIT_TYPES_CBM008                    *
 * Target Table:    CHECK_VISA_TYPE_CBM008 -              A5B29B8Q.BS0001UB *
 *                   work.CHECK_VISA_TYPE_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PE);

proc sql;
   create table work.CHECK_VISA_TYPE_CBM008 as
   select
      CHECK_CITIZENSHIP_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      CHECK_CITIZENSHIP_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CHECK_CITIZENSHIP_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      CHECK_CITIZENSHIP_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      CHECK_CITIZENSHIP_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CHECK_CITIZENSHIP_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      CHECK_CITIZENSHIP_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      CHECK_CITIZENSHIP_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      CHECK_CITIZENSHIP_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      CHECK_CITIZENSHIP_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      CHECK_CITIZENSHIP_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      CHECK_CITIZENSHIP_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      CHECK_CITIZENSHIP_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      CHECK_CITIZENSHIP_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      CHECK_CITIZENSHIP_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      CHECK_CITIZENSHIP_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      CHECK_CITIZENSHIP_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      CHECK_CITIZENSHIP_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      CHECK_CITIZENSHIP_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      CHECK_CITIZENSHIP_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      CHECK_CITIZENSHIP_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      CHECK_CITIZENSHIP_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      CHECK_CITIZENSHIP_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      CHECK_CITIZENSHIP_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      CHECK_CITIZENSHIP_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      CHECK_CITIZENSHIP_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      CHECK_CITIZENSHIP_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      CHECK_CITIZENSHIP_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      CHECK_CITIZENSHIP_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      CHECK_CITIZENSHIP_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      CHECK_CITIZENSHIP_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      CHECK_CITIZENSHIP_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      CHECK_CITIZENSHIP_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      CHECK_CITIZENSHIP_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      CHECK_CITIZENSHIP_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CHECK_CITIZENSHIP_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      CHECK_CITIZENSHIP_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      CHECK_CITIZENSHIP_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      CHECK_CITIZENSHIP_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      CHECK_CITIZENSHIP_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      CHECK_CITIZENSHIP_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CHECK_CITIZENSHIP_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      CHECK_CITIZENSHIP_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CHECK_CITIZENSHIP_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      CHECK_CITIZENSHIP_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      CHECK_CITIZENSHIP_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CHECK_CITIZENSHIP_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      IFC(IDS_W_GOOD_PERMIT_TYPES_CBM008.EMPLID NOT IS MISSING,'Y','N') as PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      CHECK_CITIZENSHIP_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      CHECK_CITIZENSHIP_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      CHECK_CITIZENSHIP_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      CHECK_CITIZENSHIP_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      CHECK_CITIZENSHIP_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      CHECK_CITIZENSHIP_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      CHECK_CITIZENSHIP_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      CHECK_CITIZENSHIP_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CHECK_CITIZENSHIP_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CHECK_CITIZENSHIP_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      CHECK_CITIZENSHIP_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      CHECK_CITIZENSHIP_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      CHECK_CITIZENSHIP_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      CHECK_CITIZENSHIP_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      CHECK_CITIZENSHIP_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      CHECK_CITIZENSHIP_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      CHECK_CITIZENSHIP_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      CHECK_CITIZENSHIP_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      CHECK_CITIZENSHIP_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      CHECK_CITIZENSHIP_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      CHECK_CITIZENSHIP_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.CHECK_CITIZENSHIP_CBM008 as CHECK_CITIZENSHIP_CBM008 left join
      work.IDS_W_GOOD_PERMIT_TYPES_CBM008 as IDS_W_GOOD_PERMIT_TYPES_CBM008
         on
         (
            CHECK_CITIZENSHIP_CBM008.CIT_CHK_EMPLID = IDS_W_GOOD_PERMIT_TYPES_CBM008.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            INTERNATIONAL_CALC                    A5B29B8Q.BZ0005PF *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    CHECK_VISA_TYPE_CBM008 -              A5B29B8Q.BS0001UB *
 *                   work.CHECK_VISA_TYPE_CBM008                            *
 * Target Table:    INTERNATIONAL_CALC_CBM008 -           A5B29B8Q.BS0001UC *
 *                   work.INTERNATIONAL_CALC_CBM008                         *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PF);

%let SYSLAST = %nrquote(work.CHECK_VISA_TYPE_CBM008);

proc sql;
   create table work.INTERNATIONAL_CALC_CBM008 as
   select
      CHECK_VISA_TYPE_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      CHECK_VISA_TYPE_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CHECK_VISA_TYPE_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      CHECK_VISA_TYPE_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      CHECK_VISA_TYPE_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CHECK_VISA_TYPE_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      CHECK_VISA_TYPE_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      CHECK_VISA_TYPE_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      CHECK_VISA_TYPE_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      CHECK_VISA_TYPE_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      CHECK_VISA_TYPE_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      CHECK_VISA_TYPE_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      CHECK_VISA_TYPE_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      CHECK_VISA_TYPE_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      CHECK_VISA_TYPE_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      CHECK_VISA_TYPE_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      CHECK_VISA_TYPE_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      CHECK_VISA_TYPE_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      CHECK_VISA_TYPE_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      CHECK_VISA_TYPE_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      CHECK_VISA_TYPE_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      CHECK_VISA_TYPE_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      CHECK_VISA_TYPE_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      CHECK_VISA_TYPE_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      CHECK_VISA_TYPE_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      CHECK_VISA_TYPE_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      CHECK_VISA_TYPE_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      CHECK_VISA_TYPE_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      CHECK_VISA_TYPE_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      CHECK_VISA_TYPE_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      CHECK_VISA_TYPE_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      CHECK_VISA_TYPE_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      CHECK_VISA_TYPE_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      CHECK_VISA_TYPE_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      CHECK_VISA_TYPE_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CHECK_VISA_TYPE_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      CHECK_VISA_TYPE_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      CHECK_VISA_TYPE_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      CHECK_VISA_TYPE_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      CHECK_VISA_TYPE_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      CHECK_VISA_TYPE_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CHECK_VISA_TYPE_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      CHECK_VISA_TYPE_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CHECK_VISA_TYPE_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      IFC(CHECK_VISA_TYPE_CBM008.COUNTRY NOT IN ('','USA') &
      CHECK_VISA_TYPE_CBM008.PERMIT_TYPE_IN_LIST='N',
      '6',CHECK_VISA_TYPE_CBM008.ETHNIC_GROUP) as ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      CHECK_VISA_TYPE_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CHECK_VISA_TYPE_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      CHECK_VISA_TYPE_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      CHECK_VISA_TYPE_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      CHECK_VISA_TYPE_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      CHECK_VISA_TYPE_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      CHECK_VISA_TYPE_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      IFC(CHECK_VISA_TYPE_CBM008.COUNTRY NOT IN ('','USA') &
      CHECK_VISA_TYPE_CBM008.PERMIT_TYPE_IN_LIST='N',
      '6',CHECK_VISA_TYPE_CBM008.RACE_INTERNATIONAL) as RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      IFC(CHECK_VISA_TYPE_CBM008.COUNTRY NOT IN ('','USA') &
      CHECK_VISA_TYPE_CBM008.PERMIT_TYPE_IN_LIST='N',
      '',CHECK_VISA_TYPE_CBM008.RACE_UNKOWN) as RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      CHECK_VISA_TYPE_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      CHECK_VISA_TYPE_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CHECK_VISA_TYPE_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CHECK_VISA_TYPE_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      CHECK_VISA_TYPE_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      CHECK_VISA_TYPE_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      CHECK_VISA_TYPE_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      CHECK_VISA_TYPE_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      CHECK_VISA_TYPE_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      CHECK_VISA_TYPE_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      CHECK_VISA_TYPE_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      CHECK_VISA_TYPE_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      CHECK_VISA_TYPE_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      CHECK_VISA_TYPE_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      CHECK_VISA_TYPE_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.CHECK_VISA_TYPE_CBM008 as CHECK_VISA_TYPE_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            PERCENT_CALC                          A5B29B8Q.BZ0005PG *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    INTERNATIONAL_CALC_CBM008 -           A5B29B8Q.BS0001UC *
 *                   work.INTERNATIONAL_CALC_CBM008                         *
 * Target Table:    PERCENT_CALC_CBM008 -                 A5B29B8Q.BS0001UD *
 *                   work.PERCENT_CALC_CBM008                               *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PG);

%let SYSLAST = %nrquote(work.INTERNATIONAL_CALC_CBM008);

proc sql;
   create table work.PERCENT_CALC_CBM008 as
   select
      INTERNATIONAL_CALC_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      INTERNATIONAL_CALC_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      INTERNATIONAL_CALC_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      INTERNATIONAL_CALC_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      INTERNATIONAL_CALC_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      INTERNATIONAL_CALC_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      INTERNATIONAL_CALC_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      INTERNATIONAL_CALC_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      INTERNATIONAL_CALC_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      INTERNATIONAL_CALC_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      INTERNATIONAL_CALC_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      INTERNATIONAL_CALC_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      INTERNATIONAL_CALC_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      INTERNATIONAL_CALC_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      INTERNATIONAL_CALC_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      INTERNATIONAL_CALC_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      INTERNATIONAL_CALC_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      INTERNATIONAL_CALC_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      INTERNATIONAL_CALC_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      INTERNATIONAL_CALC_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      INTERNATIONAL_CALC_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      INTERNATIONAL_CALC_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      INTERNATIONAL_CALC_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      INTERNATIONAL_CALC_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      INTERNATIONAL_CALC_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      INTERNATIONAL_CALC_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      INTERNATIONAL_CALC_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      INTERNATIONAL_CALC_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      INTERNATIONAL_CALC_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      INTERNATIONAL_CALC_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      INTERNATIONAL_CALC_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      INTERNATIONAL_CALC_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      INTERNATIONAL_CALC_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      INTERNATIONAL_CALC_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      INTERNATIONAL_CALC_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      INTERNATIONAL_CALC_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      INTERNATIONAL_CALC_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      INTERNATIONAL_CALC_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      INTERNATIONAL_CALC_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      INTERNATIONAL_CALC_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      INTERNATIONAL_CALC_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      INTERNATIONAL_CALC_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      INTERNATIONAL_CALC_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      INTERNATIONAL_CALC_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      INTERNATIONAL_CALC_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      INTERNATIONAL_CALC_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      INTERNATIONAL_CALC_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      INTERNATIONAL_CALC_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      INTERNATIONAL_CALC_CBM008.ETHNIC_ORIGIN as ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      INTERNATIONAL_CALC_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      INTERNATIONAL_CALC_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      INTERNATIONAL_CALC_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      INTERNATIONAL_CALC_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      INTERNATIONAL_CALC_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      INTERNATIONAL_CALC_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      INTERNATIONAL_CALC_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      IFC(INTERNATIONAL_CALC_CBM008.PCT_TIME_A IS MISSING,'000',
      IFC(INTERNATIONAL_CALC_CBM008.PCT_TIME_A>=100,'100',
      PUT(INTERNATIONAL_CALC_CBM008.PCT_TIME_A,Z3.))) as PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      '000' as PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      IFC(INTERNATIONAL_CALC_CBM008.PCT_TIME_C IS MISSING,'000',
      IFC(INTERNATIONAL_CALC_CBM008.PCT_TIME_C>=100,'100',
      PUT(INTERNATIONAL_CALC_CBM008.PCT_TIME_C,Z3.))) as PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      IFC(INTERNATIONAL_CALC_CBM008.PCT_TIME_D IS MISSING,'000',
      IFC(INTERNATIONAL_CALC_CBM008.PCT_TIME_D>=100,'100',
      PUT(INTERNATIONAL_CALC_CBM008.PCT_TIME_D,Z3.))) as PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      IFC(INTERNATIONAL_CALC_CBM008.PCT_TIME_E IS MISSING,'000',
      IFC(INTERNATIONAL_CALC_CBM008.PCT_TIME_E>=100,'100',
      PUT(INTERNATIONAL_CALC_CBM008.PCT_TIME_E,Z3.))) as PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      INTERNATIONAL_CALC_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      INTERNATIONAL_CALC_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      INTERNATIONAL_CALC_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      INTERNATIONAL_CALC_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      INTERNATIONAL_CALC_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      INTERNATIONAL_CALC_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      INTERNATIONAL_CALC_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      INTERNATIONAL_CALC_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      INTERNATIONAL_CALC_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      INTERNATIONAL_CALC_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      INTERNATIONAL_CALC_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      INTERNATIONAL_CALC_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      INTERNATIONAL_CALC_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      INTERNATIONAL_CALC_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.INTERNATIONAL_CALC_CBM008 as INTERNATIONAL_CALC_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            AGG_SALARY                            A5B29B8Q.BZ0005PH *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PERCENT_CALC_CBM008 -                 A5B29B8Q.BS0001UD *
 *                   work.PERCENT_CALC_CBM008                               *
 * Target Table:    AGG_SALARY_CBM008 -                   A5B29B8Q.BS0001UE *
 *                   work.AGG_SALARY_CBM008                                 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PH);

%let SYSLAST = %nrquote(work.PERCENT_CALC_CBM008);

proc sql;
   create table work.AGG_SALARY_CBM008 as
   select
      PERCENT_CALC_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      PERCENT_CALC_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      PERCENT_CALC_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      PERCENT_CALC_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      PERCENT_CALC_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      PERCENT_CALC_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      PERCENT_CALC_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      PERCENT_CALC_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      PERCENT_CALC_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      PERCENT_CALC_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      PERCENT_CALC_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      PERCENT_CALC_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      PERCENT_CALC_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      PERCENT_CALC_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      PERCENT_CALC_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      PERCENT_CALC_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      PERCENT_CALC_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      PERCENT_CALC_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      PERCENT_CALC_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      PERCENT_CALC_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      PERCENT_CALC_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      PERCENT_CALC_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      PERCENT_CALC_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      PERCENT_CALC_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      PERCENT_CALC_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      PERCENT_CALC_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      PERCENT_CALC_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      PERCENT_CALC_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      PERCENT_CALC_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      PERCENT_CALC_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      PERCENT_CALC_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      PERCENT_CALC_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      PERCENT_CALC_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      PERCENT_CALC_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      PERCENT_CALC_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      PERCENT_CALC_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      PERCENT_CALC_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      PERCENT_CALC_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      PERCENT_CALC_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      PERCENT_CALC_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      PERCENT_CALC_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      PERCENT_CALC_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      PERCENT_CALC_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PERCENT_CALC_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      PERCENT_CALC_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      PERCENT_CALC_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      PERCENT_CALC_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      PERCENT_CALC_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      PERCENT_CALC_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      PERCENT_CALC_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      PERCENT_CALC_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      PERCENT_CALC_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      PERCENT_CALC_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      PERCENT_CALC_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      PERCENT_CALC_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      PERCENT_CALC_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      PERCENT_CALC_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      PERCENT_CALC_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      PERCENT_CALC_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      PERCENT_CALC_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      PERCENT_CALC_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      SUM(PERCENT_CALC_CBM008.SALARY_A_ADDL,
      PERCENT_CALC_CBM008.SALARY_A) as SALARY_A_AGG length = 8
         label = 'SALARY_A_AGG',
      SUM(PERCENT_CALC_CBM008.SALARY_D_ADDL,
      PERCENT_CALC_CBM008.SALARY_D) as SALARY_D_AGG length = 8
         label = 'SALARY_D_AGG',
      SUM(PERCENT_CALC_CBM008.SALARY_X_ADDL,
      PERCENT_CALC_CBM008.SALARY_X) as SALARY_X_AGG length = 8
         label = 'SALARY_X_AGG',
      SUM(PERCENT_CALC_CBM008.SALARY_R_ADDL,
      PERCENT_CALC_CBM008.SALARY_R) as SALARY_R_AGG length = 8
         label = 'SALARY_R_AGG',
      SUM(PERCENT_CALC_CBM008.SALARY_Z_ADDL,
      PERCENT_CALC_CBM008.SALARY_Z) as SALARY_Z_AGG length = 8
         label = 'SALARY_Z_AGG',
      PERCENT_CALC_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      PERCENT_CALC_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      PERCENT_CALC_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      PERCENT_CALC_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      PERCENT_CALC_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      PERCENT_CALC_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      PERCENT_CALC_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      PERCENT_CALC_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      PERCENT_CALC_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      PERCENT_CALC_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      PERCENT_CALC_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      PERCENT_CALC_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      PERCENT_CALC_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      PERCENT_CALC_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.PERCENT_CALC_CBM008 as PERCENT_CALC_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            SALARY_CALC                           A5B29B8Q.BZ0005PI *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    AGG_SALARY_CBM008 -                   A5B29B8Q.BS0001UE *
 *                   work.AGG_SALARY_CBM008                                 *
 * Target Table:    SALARY_CALC_CBM008 -                  A5B29B8Q.BS0001UF *
 *                   work.SALARY_CALC_CBM008                                *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PI);

%let SYSLAST = %nrquote(work.AGG_SALARY_CBM008);

proc sql;
   create table work.SALARY_CALC_CBM008 as
   select
      AGG_SALARY_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      AGG_SALARY_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      AGG_SALARY_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      AGG_SALARY_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      AGG_SALARY_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      AGG_SALARY_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      AGG_SALARY_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      AGG_SALARY_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      AGG_SALARY_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      AGG_SALARY_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      AGG_SALARY_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      AGG_SALARY_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      AGG_SALARY_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      AGG_SALARY_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      AGG_SALARY_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      AGG_SALARY_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      AGG_SALARY_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      AGG_SALARY_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      AGG_SALARY_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      AGG_SALARY_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      AGG_SALARY_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      AGG_SALARY_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      AGG_SALARY_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      AGG_SALARY_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      AGG_SALARY_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      AGG_SALARY_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      AGG_SALARY_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      AGG_SALARY_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      AGG_SALARY_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      AGG_SALARY_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      AGG_SALARY_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      AGG_SALARY_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      AGG_SALARY_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      AGG_SALARY_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      AGG_SALARY_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      AGG_SALARY_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      AGG_SALARY_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      AGG_SALARY_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      AGG_SALARY_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      AGG_SALARY_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      AGG_SALARY_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      AGG_SALARY_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      AGG_SALARY_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      AGG_SALARY_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      AGG_SALARY_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      AGG_SALARY_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      AGG_SALARY_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      AGG_SALARY_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      AGG_SALARY_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      AGG_SALARY_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      AGG_SALARY_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      AGG_SALARY_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      AGG_SALARY_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      AGG_SALARY_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      AGG_SALARY_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      AGG_SALARY_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      AGG_SALARY_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      AGG_SALARY_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      AGG_SALARY_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      AGG_SALARY_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      AGG_SALARY_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      PUT(INT(AGG_SALARY_CBM008.SALARY_A_AGG),Z6.) as SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      PUT(INT(AGG_SALARY_CBM008.SALARY_D_AGG),Z6.) as SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      PUT(INT(AGG_SALARY_CBM008.SALARY_R_AGG),Z6.) as SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      PUT(INT(AGG_SALARY_CBM008.SALARY_X_AGG),Z6.) as SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      PUT(INT(AGG_SALARY_CBM008.SALARY_Z_AGG),Z6.) as SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      '000' as FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      '000000' as FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      '0' as FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      AGG_SALARY_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      AGG_SALARY_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      AGG_SALARY_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      AGG_SALARY_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      AGG_SALARY_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      AGG_SALARY_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      AGG_SALARY_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      AGG_SALARY_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      AGG_SALARY_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      AGG_SALARY_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      AGG_SALARY_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      AGG_SALARY_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      AGG_SALARY_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      AGG_SALARY_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.AGG_SALARY_CBM008 as AGG_SALARY_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            FACULTY_COMPLIANCE                    A5B29B8Q.BZ0005PJ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    SALARY_CALC_CBM008 -                  A5B29B8Q.BS0001UF *
 *                   work.SALARY_CALC_CBM008                                *
 * Target Table:    Join - work.W3QVHZ1T                  A5B29B8Q.BS0001UG *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PJ);

%let SYSLAST = %nrquote(work.SALARY_CALC_CBM008);

proc sql;
   create view work.W3QVHZ1T as
   select
      SALARY_CALC_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      SALARY_CALC_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      SALARY_CALC_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      SALARY_CALC_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      SALARY_CALC_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      SALARY_CALC_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      SALARY_CALC_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      SALARY_CALC_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      SALARY_CALC_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      SALARY_CALC_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      SALARY_CALC_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      SALARY_CALC_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      SALARY_CALC_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      SALARY_CALC_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      SALARY_CALC_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      SALARY_CALC_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      SALARY_CALC_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      SALARY_CALC_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      SALARY_CALC_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      SALARY_CALC_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      SALARY_CALC_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      SALARY_CALC_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      SALARY_CALC_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      SALARY_CALC_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      SALARY_CALC_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      SALARY_CALC_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      SALARY_CALC_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      SALARY_CALC_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      SALARY_CALC_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      SALARY_CALC_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      SALARY_CALC_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      SALARY_CALC_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      SALARY_CALC_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      SALARY_CALC_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      SALARY_CALC_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      SALARY_CALC_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      SALARY_CALC_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      SALARY_CALC_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      SALARY_CALC_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      SALARY_CALC_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      SALARY_CALC_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      SALARY_CALC_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      SALARY_CALC_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      SALARY_CALC_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      SALARY_CALC_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      SALARY_CALC_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      SALARY_CALC_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      SALARY_CALC_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      SALARY_CALC_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      SALARY_CALC_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      SALARY_CALC_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      SALARY_CALC_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      SALARY_CALC_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      SALARY_CALC_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      SALARY_CALC_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      SALARY_CALC_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      SALARY_CALC_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      SALARY_CALC_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      SALARY_CALC_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      SALARY_CALC_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      SALARY_CALC_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      SALARY_CALC_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      SALARY_CALC_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      SALARY_CALC_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      SALARY_CALC_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      SALARY_CALC_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      SALARY_CALC_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      SALARY_CALC_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      SALARY_CALC_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      SALARY_CALC_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      SALARY_CALC_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      SALARY_CALC_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      SALARY_CALC_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      SALARY_CALC_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      SALARY_CALC_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      SALARY_CALC_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      SALARY_CALC_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      SALARY_CALC_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      SALARY_CALC_CBM008.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      SALARY_CALC_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      SALARY_CALC_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      SALARY_CALC_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      SALARY_CALC_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.SALARY_CALC_CBM008 as SALARY_CALC_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005PK *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_UTA_HRA_ARCHIVE_Extract -          A5B29B8Q.BE00007H *
 *                   ADWSTGPR.PS_UTA_HRA_ARCHIVE_Extract                    *
 * Target Table:    Join - work.W3R0AYO7                  A5B29B8Q.BS0001UH *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PK);

%let SYSLAST = %nrquote(ADWSTGPR.PS_UTA_HRA_ARCHIVE_Extract);

proc sql;
   create table work.W3R0AYO7 as
   select distinct
      PS_UTA_HRA_ARCHIVE_Extract.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN'
   from
      ADWSTGPR.PS_UTA_HRA_ARCHIVE_Extract as PS_UTA_HRA_ARCHIVE_Extract
   ;
quit;

/*==========================================================================*
 * Step:            NEW_HIRE_CALC                         A5B29B8Q.BZ0005PL *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W3QVHZ1T                  A5B29B8Q.BS0001UG *
 *                  Join - work.W3R0AYO7                  A5B29B8Q.BS0001UH *
 *                  PS_UTA_HRA_TBL_Extract -              A5B29B8Q.BE00007I *
 *                   ADWSTGPR.PS_UTA_HRA_TBL_Extract                        *
 * Target Table:    NEW_HIRE_CALC_CBM008 -                A5B29B8Q.BS0001UI *
 *                   work.NEW_HIRE_CALC_CBM008                              *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PL);

proc sql;
   create table work.NEW_HIRE_CALC_CBM008 as
   select distinct
      W3QVHZ1T.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      "" as UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      W3QVHZ1T.ACAD_YEAR as UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      "" as ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      . as DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      "" as CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      "" as CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      "" as FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      W3QVHZ1T.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      "" as CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      W3QVHZ1T.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      W3QVHZ1T.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      W3QVHZ1T.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W3QVHZ1T.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      W3QVHZ1T.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      . as UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      W3QVHZ1T.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      W3QVHZ1T.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      W3QVHZ1T.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      . as UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      "" as UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      W3QVHZ1T.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      W3QVHZ1T.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      W3QVHZ1T.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      W3QVHZ1T.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      "" as HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      "" as HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      . as OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      . as DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      W3QVHZ1T.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      W3QVHZ1T.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      W3QVHZ1T.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      W3QVHZ1T.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      W3QVHZ1T.SALARY_A length = 8
         label = 'SALARY_A',
      W3QVHZ1T.SALARY_D length = 8
         label = 'SALARY_D',
      W3QVHZ1T.SALARY_X length = 8
         label = 'SALARY_X',
      W3QVHZ1T.SALARY_R length = 8
         label = 'SALARY_R',
      W3QVHZ1T.SALARY_Z length = 8
         label = 'SALARY_Z',
      . as DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      W3QVHZ1T.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      W3QVHZ1T.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      W3QVHZ1T.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      W3QVHZ1T.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      W3QVHZ1T.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      W3QVHZ1T.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      W3QVHZ1T.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      W3QVHZ1T.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      W3QVHZ1T.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      W3QVHZ1T.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      W3QVHZ1T.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      W3QVHZ1T.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      W3QVHZ1T.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      W3QVHZ1T.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      W3QVHZ1T.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      W3QVHZ1T.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      W3QVHZ1T.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      W3QVHZ1T.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      W3QVHZ1T.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W3QVHZ1T.RANK_CBM length = 8
         label = 'RANK_CBM',
      W3QVHZ1T.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W3QVHZ1T.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W3QVHZ1T.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      W3QVHZ1T.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      W3QVHZ1T.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      W3QVHZ1T.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      W3QVHZ1T.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      W3QVHZ1T.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W3QVHZ1T.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      W3QVHZ1T.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W3QVHZ1T.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      W3QVHZ1T.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      W3QVHZ1T.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      W3QVHZ1T.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      W3QVHZ1T.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      W3QVHZ1T.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      W3QVHZ1T.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      W3QVHZ1T.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      W3QVHZ1T.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      W3QVHZ1T.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      W3QVHZ1T.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      W3QVHZ1T.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      W3QVHZ1T.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      W3QVHZ1T.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      W3QVHZ1T.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      W3QVHZ1T.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      W3QVHZ1T.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      W3QVHZ1T.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      "" as FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      IFC(SUM(W3QVHZ1T.PCT_TIME_A,
      W3QVHZ1T.PCT_TIME_C,
      W3QVHZ1T.PCT_TIME_D,
      W3QVHZ1T.PCT_TIME_E) >=100 &
      W3R0AYO7.SSN IS MISSING &
      PS_UTA_HRA_TBL_Extract.SSN IS MISSING,'3','0') as NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      W3QVHZ1T.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W3QVHZ1T.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W3QVHZ1T.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      W3QVHZ1T.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      W3QVHZ1T.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      W3QVHZ1T.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      W3QVHZ1T.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      W3QVHZ1T.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      W3QVHZ1T.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      W3QVHZ1T.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W3QVHZ1T.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.W3QVHZ1T as W3QVHZ1T left join
      work.W3R0AYO7 as W3R0AYO7
         on
         (
            W3QVHZ1T.SSN = W3R0AYO7.SSN
         ) left join
      ADWSTGPR.PS_UTA_HRA_TBL_Extract as PS_UTA_HRA_TBL_Extract
         on
         (
            W3QVHZ1T.SSN = PS_UTA_HRA_TBL_Extract.SSN
            and PS_UTA_HRA_TBL_Extract.UTA_HRA_JOB_GRPCD IN ('F','E','I')
            and W3QVHZ1T.APPT_BEGIN_DT > PS_UTA_HRA_TBL_Extract.UTA_HRA_BEGIN_DT
            and ((W3QVHZ1T.ACAD_YEAR > PS_UTA_HRA_TBL_Extract.UTA_HRA_FISCALYEAR
            and PS_UTA_HRA_TBL_Extract.UTA_HRA_PCT_TIME >= 1)
            or (W3QVHZ1T.ACAD_YEAR = PS_UTA_HRA_TBL_Extract.UTA_HRA_FISCALYEAR
            and W3QVHZ1T.CBM_TERM IN ('2','5')))
         )
   ;
quit;

/*==========================================================================*
 * Step:            CALC_SEM_YEAR                         A5B29B8Q.BZ0005PM *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    NEW_HIRE_CALC_CBM008 -                A5B29B8Q.BS0001UI *
 *                   work.NEW_HIRE_CALC_CBM008                              *
 * Target Table:    CALC_SEM_YEAR_CBM008 -                A5B29B8Q.BS0001UJ *
 *                   work.CALC_SEM_YEAR_CBM008                              *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PM);

%let SYSLAST = %nrquote(work.NEW_HIRE_CALC_CBM008);

proc sql;
   create table work.CALC_SEM_YEAR_CBM008 as
   select
      NEW_HIRE_CALC_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      NEW_HIRE_CALC_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      NEW_HIRE_CALC_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      NEW_HIRE_CALC_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      NEW_HIRE_CALC_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      NEW_HIRE_CALC_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      NEW_HIRE_CALC_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      NEW_HIRE_CALC_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      NEW_HIRE_CALC_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      NEW_HIRE_CALC_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      NEW_HIRE_CALC_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      NEW_HIRE_CALC_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      NEW_HIRE_CALC_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      NEW_HIRE_CALC_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      NEW_HIRE_CALC_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      NEW_HIRE_CALC_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      NEW_HIRE_CALC_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      NEW_HIRE_CALC_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      NEW_HIRE_CALC_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      NEW_HIRE_CALC_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      NEW_HIRE_CALC_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      NEW_HIRE_CALC_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      NEW_HIRE_CALC_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      NEW_HIRE_CALC_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      NEW_HIRE_CALC_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      NEW_HIRE_CALC_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      NEW_HIRE_CALC_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      NEW_HIRE_CALC_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      NEW_HIRE_CALC_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      NEW_HIRE_CALC_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      NEW_HIRE_CALC_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      NEW_HIRE_CALC_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      NEW_HIRE_CALC_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      NEW_HIRE_CALC_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      NEW_HIRE_CALC_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      NEW_HIRE_CALC_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      NEW_HIRE_CALC_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      NEW_HIRE_CALC_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      NEW_HIRE_CALC_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      NEW_HIRE_CALC_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      NEW_HIRE_CALC_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      NEW_HIRE_CALC_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      NEW_HIRE_CALC_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      NEW_HIRE_CALC_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      NEW_HIRE_CALC_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      NEW_HIRE_CALC_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      NEW_HIRE_CALC_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      NEW_HIRE_CALC_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      NEW_HIRE_CALC_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      NEW_HIRE_CALC_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      NEW_HIRE_CALC_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      NEW_HIRE_CALC_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      NEW_HIRE_CALC_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      NEW_HIRE_CALC_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      NEW_HIRE_CALC_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      NEW_HIRE_CALC_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      NEW_HIRE_CALC_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      NEW_HIRE_CALC_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      NEW_HIRE_CALC_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      NEW_HIRE_CALC_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      NEW_HIRE_CALC_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      NEW_HIRE_CALC_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      NEW_HIRE_CALC_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      NEW_HIRE_CALC_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      NEW_HIRE_CALC_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      NEW_HIRE_CALC_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      NEW_HIRE_CALC_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      NEW_HIRE_CALC_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      NEW_HIRE_CALC_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      NEW_HIRE_CALC_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      NEW_HIRE_CALC_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      NEW_HIRE_CALC_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      NEW_HIRE_CALC_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      NEW_HIRE_CALC_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      NEW_HIRE_CALC_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      NEW_HIRE_CALC_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      NEW_HIRE_CALC_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      NEW_HIRE_CALC_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      NEW_HIRE_CALC_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      NEW_HIRE_CALC_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      NEW_HIRE_CALC_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      NEW_HIRE_CALC_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      NEW_HIRE_CALC_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      NEW_HIRE_CALC_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      NEW_HIRE_CALC_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      NEW_HIRE_CALC_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      NEW_HIRE_CALC_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      NEW_HIRE_CALC_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      NEW_HIRE_CALC_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      IFC(NEW_HIRE_CALC_CBM008.CBM_TERM='8','1',
      IFC(NEW_HIRE_CALC_CBM008.CBM_TERM='2','2',
      IFC(NEW_HIRE_CALC_CBM008.CBM_TERM='5','3',''))) as SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      '20' || SUBSTR(NEW_HIRE_CALC_CBM008.STRM,2,2) as YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      PUT(INPUT(NEW_HIRE_CALC_CBM008.STRM,BEST8.)-
      IFN(SUBSTR(NEW_HIRE_CALC_CBM008.STRM,4,1)='2',4,3)-
      IFN(NEW_HIRE_CALC_CBM008.STRM='2002',1000,0),4.) as STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      NEW_HIRE_CALC_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      NEW_HIRE_CALC_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      NEW_HIRE_CALC_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      NEW_HIRE_CALC_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      NEW_HIRE_CALC_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      NEW_HIRE_CALC_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      NEW_HIRE_CALC_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      NEW_HIRE_CALC_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      NEW_HIRE_CALC_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      NEW_HIRE_CALC_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      NEW_HIRE_CALC_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.NEW_HIRE_CALC_CBM008 as NEW_HIRE_CALC_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            STRM_PREV_CALC                        A5B29B8Q.BZ0005PN *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   CALC_SEM_YEAR_CBM008 -                A5B29B8Q.BS0001UJ *
 *                   work.CALC_SEM_YEAR_CBM008                              *
 *                  UNIQ_STRM_CBM008 -                    A5B29B8Q.BS0001S9 *
 *                   work.UNIQ_STRM_CBM008                                  *
 * Target Table:    STRM_PREV_CALC_CBM008 -               A5B29B8Q.BS0001UK *
 *                   work.STRM_PREV_CALC_CBM008                             *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PN);

proc sql;
   create view work.STRM_PREV_CALC_CBM008 as
   select
      CALC_SEM_YEAR_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      CALC_SEM_YEAR_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      CALC_SEM_YEAR_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      CALC_SEM_YEAR_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      CALC_SEM_YEAR_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      CALC_SEM_YEAR_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      CALC_SEM_YEAR_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      CALC_SEM_YEAR_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      CALC_SEM_YEAR_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CALC_SEM_YEAR_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      CALC_SEM_YEAR_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      CALC_SEM_YEAR_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      CALC_SEM_YEAR_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CALC_SEM_YEAR_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      CALC_SEM_YEAR_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      CALC_SEM_YEAR_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      CALC_SEM_YEAR_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      CALC_SEM_YEAR_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      CALC_SEM_YEAR_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      CALC_SEM_YEAR_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      CALC_SEM_YEAR_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      CALC_SEM_YEAR_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      CALC_SEM_YEAR_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      CALC_SEM_YEAR_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      CALC_SEM_YEAR_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      CALC_SEM_YEAR_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      CALC_SEM_YEAR_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      CALC_SEM_YEAR_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      CALC_SEM_YEAR_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      CALC_SEM_YEAR_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      CALC_SEM_YEAR_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      CALC_SEM_YEAR_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      CALC_SEM_YEAR_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      CALC_SEM_YEAR_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      CALC_SEM_YEAR_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      CALC_SEM_YEAR_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      CALC_SEM_YEAR_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      CALC_SEM_YEAR_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      CALC_SEM_YEAR_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      CALC_SEM_YEAR_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      CALC_SEM_YEAR_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      CALC_SEM_YEAR_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      CALC_SEM_YEAR_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      CALC_SEM_YEAR_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      CALC_SEM_YEAR_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      CALC_SEM_YEAR_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      CALC_SEM_YEAR_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      CALC_SEM_YEAR_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      CALC_SEM_YEAR_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      CALC_SEM_YEAR_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      CALC_SEM_YEAR_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      CALC_SEM_YEAR_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CALC_SEM_YEAR_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      CALC_SEM_YEAR_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      CALC_SEM_YEAR_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      CALC_SEM_YEAR_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      CALC_SEM_YEAR_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      CALC_SEM_YEAR_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CALC_SEM_YEAR_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      CALC_SEM_YEAR_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CALC_SEM_YEAR_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      CALC_SEM_YEAR_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      CALC_SEM_YEAR_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CALC_SEM_YEAR_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      CALC_SEM_YEAR_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      CALC_SEM_YEAR_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      CALC_SEM_YEAR_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      CALC_SEM_YEAR_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      CALC_SEM_YEAR_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      CALC_SEM_YEAR_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      CALC_SEM_YEAR_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      CALC_SEM_YEAR_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      CALC_SEM_YEAR_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      CALC_SEM_YEAR_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      CALC_SEM_YEAR_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      CALC_SEM_YEAR_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      CALC_SEM_YEAR_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      CALC_SEM_YEAR_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      CALC_SEM_YEAR_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      CALC_SEM_YEAR_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      CALC_SEM_YEAR_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      CALC_SEM_YEAR_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      CALC_SEM_YEAR_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      CALC_SEM_YEAR_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      CALC_SEM_YEAR_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      CALC_SEM_YEAR_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      CALC_SEM_YEAR_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      CALC_SEM_YEAR_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      CALC_SEM_YEAR_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      CALC_SEM_YEAR_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      CALC_SEM_YEAR_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      CALC_SEM_YEAR_CBM008.STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      CALC_SEM_YEAR_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      UNIQ_STRM_CBM008.TERM_END_DT as TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      CALC_SEM_YEAR_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CALC_SEM_YEAR_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      CALC_SEM_YEAR_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      CALC_SEM_YEAR_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      CALC_SEM_YEAR_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      CALC_SEM_YEAR_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      CALC_SEM_YEAR_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      CALC_SEM_YEAR_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      CALC_SEM_YEAR_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      CALC_SEM_YEAR_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT'
   from
      work.CALC_SEM_YEAR_CBM008 as CALC_SEM_YEAR_CBM008 left join
      work.UNIQ_STRM_CBM008 as UNIQ_STRM_CBM008
         on
         (
            CALC_SEM_YEAR_CBM008.STRM_PREV = UNIQ_STRM_CBM008.STRM
         )
   ;
quit;

/*==========================================================================*
 * Step:            INSTR_MIN_MTG_NBR                     A5B29B8Q.BZ0005PO *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_CLASS_INSTR_Extract -              A5B29B8Q.BE00002S *
 *                   ADWSTGPR.PS_CLASS_INSTR_Extract                        *
 * Target Table:    INSTR_MIN_MTG_NBR_CBM008 -            A5B29B8Q.BS0001UL *
 *                   work.INSTR_MIN_MTG_NBR_CBM008                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PO);

%let SYSLAST = %nrquote(ADWSTGPR.PS_CLASS_INSTR_Extract);

proc sql;
   create view work.INSTR_MIN_MTG_NBR_CBM008 as
   select
      PS_CLASS_INSTR_Extract.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      PS_CLASS_INSTR_Extract.ASSIGNMENT_PCT length = 8
         format = 7.2
         informat = 7.2
         label = 'ASSIGNMENT_PCT',
      PS_CLASS_INSTR_Extract.AUTO_CALC_WRKLD length = 1
         format = $1.
         informat = $1.
         label = 'AUTO_CALC_WRKLD',
      PS_CLASS_INSTR_Extract.CLASS_MTG_NBR length = 8
         label = 'CLASS_MTG_NBR',
      PS_CLASS_INSTR_Extract.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      PS_CLASS_INSTR_Extract.CONTACT_MINUTES length = 8
         label = 'CONTACT_MINUTES',
      PS_CLASS_INSTR_Extract.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_CLASS_INSTR_Extract.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      PS_CLASS_INSTR_Extract.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      PS_CLASS_INSTR_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_CLASS_INSTR_Extract.GRADE_RSTR_ACCESS length = 1
         format = $1.
         informat = $1.
         label = 'GRADE_RSTR_ACCESS',
      PS_CLASS_INSTR_Extract.INSTR_ASSIGN_SEQ length = 8
         label = 'INSTR_ASSIGN_SEQ',
      PS_CLASS_INSTR_Extract.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      PS_CLASS_INSTR_Extract.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      PS_CLASS_INSTR_Extract.SCHED_PRINT_INSTR length = 1
         format = $1.
         informat = $1.
         label = 'SCHED_PRINT_INSTR',
      PS_CLASS_INSTR_Extract.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      PS_CLASS_INSTR_Extract.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_CLASS_INSTR_Extract.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS'
   from
      ADWSTGPR.PS_CLASS_INSTR_Extract as PS_CLASS_INSTR_Extract
   group by
      PS_CLASS_INSTR_Extract.STRM,
      PS_CLASS_INSTR_Extract.SESSION_CODE,
      PS_CLASS_INSTR_Extract.CRSE_OFFER_NBR,
      PS_CLASS_INSTR_Extract.CRSE_ID,
      PS_CLASS_INSTR_Extract.CLASS_SECTION
   having
      PS_CLASS_INSTR_Extract.CLASS_MTG_NBR = MIN(PS_CLASS_INSTR_Extract.CLASS_MTG_NBR)
   ;
quit;

/*==========================================================================*
 * Step:            CLASS_WITH_INSTR                      A5B29B8Q.BZ0005PP *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   INSTR_MIN_MTG_NBR_CBM008 -            A5B29B8Q.BS0001UL *
 *                   work.INSTR_MIN_MTG_NBR_CBM008                          *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 * Target Table:    CLASS_WITH_INSTR_CBM008 -             A5B29B8Q.BS0001UM *
 *                   work.CLASS_WITH_INSTR_CBM008                           *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PP);

proc sql;
   create table work.CLASS_WITH_INSTR_CBM008 as
   select distinct
      PS_CLASS_TBL_Extract.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      PS_CLASS_TBL_Extract.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      PS_CLASS_TBL_Extract.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      INSTR_MIN_MTG_NBR_CBM008.WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      INSTR_MIN_MTG_NBR_CBM008.ASSIGN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ASSIGN_TYPE',
      INSTR_MIN_MTG_NBR_CBM008.INSTR_ROLE length = 4
         format = $4.
         informat = $4.
         label = 'INSTR_ROLE',
      INSTR_MIN_MTG_NBR_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      PS_CLASS_TBL_Extract.COMBINED_SECTION length = 1
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      INSTR_MIN_MTG_NBR_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      INSTR_MIN_MTG_NBR_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      PS_CLASS_TBL_Extract.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_CLASS_TBL_Extract.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      PS_CLASS_TBL_Extract.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      PS_CLASS_TBL_Extract.END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      PS_CLASS_TBL_Extract.START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      INSTR_MIN_MTG_NBR_CBM008.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_CLASS_TBL_Extract.ACAD_GROUP length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      PS_CLASS_TBL_Extract.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG'
   from
      work.INSTR_MIN_MTG_NBR_CBM008 as INSTR_MIN_MTG_NBR_CBM008 left join
      ADWSTGPR.PS_CLASS_TBL_Extract as PS_CLASS_TBL_Extract
         on
         (
            PS_CLASS_TBL_Extract.ENRL_TOT > 0
            and INSTR_MIN_MTG_NBR_CBM008.ASSIGN_TYPE NOT IN ('EXC','NON')
            and INSTR_MIN_MTG_NBR_CBM008.CRSE_ID = PS_CLASS_TBL_Extract.CRSE_ID
            and INSTR_MIN_MTG_NBR_CBM008.CRSE_OFFER_NBR = PS_CLASS_TBL_Extract.CRSE_OFFER_NBR
            and INSTR_MIN_MTG_NBR_CBM008.STRM = PS_CLASS_TBL_Extract.STRM
            and INSTR_MIN_MTG_NBR_CBM008.SESSION_CODE = PS_CLASS_TBL_Extract.SESSION_CODE
            and INSTR_MIN_MTG_NBR_CBM008.CLASS_SECTION = PS_CLASS_TBL_Extract.CLASS_SECTION
         )
   group by
      INSTR_MIN_MTG_NBR_CBM008.EMPLID,
      INSTR_MIN_MTG_NBR_CBM008.STRM
   having
      MAX(PS_CLASS_TBL_Extract.CLASS_NBR) IS MISSING
      or PS_CLASS_TBL_Extract.CLASS_NBR NOT IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            Distinct Combined Sections            A5B29B8Q.BZ0005PQ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   CLASS_WITH_INSTR_CBM008 -             A5B29B8Q.BS0001UM *
 *                   work.CLASS_WITH_INSTR_CBM008                           *
 *                  User Written -                        A5B29B8Q.BS0001S8 *
 *                   work.CBM008_TermDimension_Manual                       *
 *                  PS_SCTN_CMBND_Extract -               A5B29B8Q.BE00000D *
 *                   ADWSTGPR.PS_SCTN_CMBND_Extract                         *
 * Target Table:    Join - work.W1SDJ1ASJ                 A5B29B8Q.BS0001UN *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PQ);

proc sql;
   create table work.W1SDJ1ASJ as
   select distinct
      CLASS_WITH_INSTR_CBM008.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      CLASS_WITH_INSTR_CBM008.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      CLASS_WITH_INSTR_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      CLASS_WITH_INSTR_CBM008.COMBINED_SECTION length = 1
         format = $1.
         informat = $1.
         label = 'COMBINED_SECTION',
      CLASS_WITH_INSTR_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CLASS_WITH_INSTR_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CLASS_WITH_INSTR_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CLASS_WITH_INSTR_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      CLASS_WITH_INSTR_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CLASS_WITH_INSTR_CBM008.END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      CLASS_WITH_INSTR_CBM008.START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CLASS_WITH_INSTR_CBM008.ACAD_GROUP length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_GROUP',
      CLASS_WITH_INSTR_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CBM008_TermDimension_Manual.Current_Term as IN_STRM length = 8
         label = 'IN_STRM',
      PS_SCTN_CMBND_Extract.SCTN_COMBINED_ID length = 4
         format = $4.
         informat = $4.
         label = 'SCTN_COMBINED_ID',
      PS_SCTN_CMBND_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION'
   from
      work.CLASS_WITH_INSTR_CBM008 as CLASS_WITH_INSTR_CBM008 inner join
      work.CBM008_TermDimension_Manual as CBM008_TermDimension_Manual
         on
         (
            (CLASS_WITH_INSTR_CBM008.STRM = CBM008_TermDimension_Manual.Current_Term
            and CLASS_WITH_INSTR_CBM008.SESSION_CODE = IFC(SUBSTR(CLASS_WITH_INSTR_CBM008.STRM,4,1)='5','5W2','1'))
            or (CLASS_WITH_INSTR_CBM008.STRM = CBM008_TermDimension_Manual.Current_Term
            and CLASS_WITH_INSTR_CBM008.SESSION_CODE <> IFC(SUBSTR(CLASS_WITH_INSTR_CBM008.STRM,4,1)='5','5W2','1')
            and CLASS_WITH_INSTR_CBM008.END_DT <= CBM008_TermDimension_Manual.Current_Term_End_Date)
            or (CLASS_WITH_INSTR_CBM008.STRM <> CBM008_TermDimension_Manual.Current_Term
            and input(CLASS_WITH_INSTR_CBM008.STRM ,BEST8.) = case
            	when substr(CBM008_TermDimension_Manual.Current_Term ,4,1)='2' then input(CBM008_TermDimension_Manual.Current_Term,BEST8.)-4
            	else  input(CBM008_TermDimension_Manual.Current_Term ,BEST8.)-3
            end
            and CLASS_WITH_INSTR_CBM008.END_DT > CBM008_TermDimension_Manual.TERM_END_DT
            and CLASS_WITH_INSTR_CBM008.END_DT <= CBM008_TermDimension_Manual.Current_Term_End_Date)
         ) left join
      ADWSTGPR.PS_SCTN_CMBND_Extract as PS_SCTN_CMBND_Extract
         on
         (
            CLASS_WITH_INSTR_CBM008.STRM = PS_SCTN_CMBND_Extract.STRM
            and CLASS_WITH_INSTR_CBM008.SESSION_CODE = PS_SCTN_CMBND_Extract.SESSION_CODE
            and CLASS_WITH_INSTR_CBM008.CLASS_NBR = PS_SCTN_CMBND_Extract.CLASS_NBR
         )
   where
      CLASS_WITH_INSTR_CBM008.CLASS_NBR NOT IS MISSING
      and CLASS_WITH_INSTR_CBM008.COMBINED_SECTION NOT IS MISSING
   order by
      PS_SCTN_CMBND_Extract.STRM,
      PS_SCTN_CMBND_Extract.SESSION_CODE,
      PS_SCTN_CMBND_Extract.SCTN_COMBINED_ID
   ;
quit;

/*==========================================================================*
 * Step:            User Written                          A5B29B8Q.BZ0005PR *
 * Transform:       User Written                                            *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W1SDJ1ASJ                 A5B29B8Q.BS0001UN *
 * Target Table:    User Written - work.W1SFHEFK2         A5B29B8Q.BS0001UO *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PR);

%let SYSLAST = %nrquote(work.W1SDJ1ASJ);


%let _INPUT = work.W1SDJ1ASJ;

%let _INPUT1_filetype = WorkTable;

%let _OUTPUT = work.W1SFHEFK2;
        CB_CLASS_CD;

        CB_CLASS_CD;
%let _OUTPUT1_col_count = 7;
%let _OUTPUT1_col0_name = CLASS_NBR;
%let _OUTPUT1_col0_table = work.W1SFHEFK2;
%let _OUTPUT1_col0_length = 8;
%let _OUTPUT1_col0_type = ;
%let _OUTPUT1_col0_format = ;
%let _OUTPUT1_col0_informat = ;
%let _OUTPUT1_col0_label = %nrquote(CLASS_NBR);
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input_count = 0;
%let _OUTPUT1_col1_name = INSTITUTION;
%let _OUTPUT1_col1_table = work.W1SFHEFK2;
%let _OUTPUT1_col1_length = 5;
%let _OUTPUT1_col1_type = $;
%let _OUTPUT1_col1_format = $5.;
%let _OUTPUT1_col1_informat = $5.;
%let _OUTPUT1_col1_label = %nrquote(INSTITUTION);
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input_count = 0;
%let _OUTPUT1_col2_name = SCTN_COMBINED_ID;
%let _OUTPUT1_col2_table = work.W1SFHEFK2;
%let _OUTPUT1_col2_length = 4;
%let _OUTPUT1_col2_type = $;
%let _OUTPUT1_col2_format = $4.;
%let _OUTPUT1_col2_informat = $4.;
%let _OUTPUT1_col2_label = %nrquote(SCTN_COMBINED_ID);
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input_count = 0;
%let _OUTPUT1_col3_name = SESSION_CODE;
%let _OUTPUT1_col3_table = work.W1SFHEFK2;
%let _OUTPUT1_col3_length = 3;
%let _OUTPUT1_col3_type = $;
%let _OUTPUT1_col3_format = $3.;
%let _OUTPUT1_col3_informat = $3.;
%let _OUTPUT1_col3_label = %nrquote(SESSION_CODE);
%let _OUTPUT1_col3_exp = ;
%let _OUTPUT1_col3_input_count = 0;
%let _OUTPUT1_col4_name = STRM;
%let _OUTPUT1_col4_table = work.W1SFHEFK2;
%let _OUTPUT1_col4_length = 4;
%let _OUTPUT1_col4_type = $;
%let _OUTPUT1_col4_format = $4.;
%let _OUTPUT1_col4_informat = $4.;
%let _OUTPUT1_col4_label = %nrquote(STRM);
%let _OUTPUT1_col4_exp = ;
%let _OUTPUT1_col4_input_count = 0;
%let _OUTPUT1_col5_name = IN_STRM;
%let _OUTPUT1_col5_table = work.W1SFHEFK2;
%let _OUTPUT1_col5_length = 4;
%let _OUTPUT1_col5_type = $;
%let _OUTPUT1_col5_format = $4.;
%let _OUTPUT1_col5_informat = $4.;
%let _OUTPUT1_col5_label = %nrquote(IN_STRM);
%let _OUTPUT1_col5_exp = ;
%let _OUTPUT1_col5_input_count = 0;
%let _OUTPUT1_col6_name = CB_CLASS_CD;
%let _OUTPUT1_col6_table = work.W1SFHEFK2;
%let _OUTPUT1_col6_length = 2;
%let _OUTPUT1_col6_type = $;
%let _OUTPUT1_col6_format = $2.;
%let _OUTPUT1_col6_informat = $2.;
%let _OUTPUT1_col6_label = %nrquote(CB_CLASS_CD);
%let _OUTPUT1_col6_exp = ;
%let _OUTPUT1_col6_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/

data &_OUTPUT.;
	set &_INPUT.;
	by IN_STRM STRM SESSION_CODE SCTN_COMBINED_ID;
	drop ALPHA A B group_num;
	retain group_num;
	LENGTH CB_CLASS_CD $ 2;
	if first.IN_STRM then group_num = -1;
	if first.SCTN_COMBINED_ID then group_num = group_num + 1;
	ALPHA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
	A = INT(group_num/36+1);
	B = MOD(group_num,36)+1;
	CB_CLASS_CD = SUBSTR(ALPHA,A,1)||SUBSTR(ALPHA,B,1);
run;
/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            READ_4_CLASSES                        A5B29B8Q.BZ0005PS *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   STRM_PREV_CALC_CBM008 -               A5B29B8Q.BS0001UK *
 *                   work.STRM_PREV_CALC_CBM008                             *
 *                  CLASS_WITH_INSTR_CBM008 -             A5B29B8Q.BS0001UM *
 *                   work.CLASS_WITH_INSTR_CBM008                           *
 * Target Table:    READ_4_CLASSES_CBM008 -               A5B29B8Q.BS0001UP *
 *                   work.READ_4_CLASSES_CBM008                             *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PS);

proc sql;
   create table work.READ_4_CLASSES_CBM008 as
   select
      STRM_PREV_CALC_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      STRM_PREV_CALC_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      STRM_PREV_CALC_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      STRM_PREV_CALC_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      STRM_PREV_CALC_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      STRM_PREV_CALC_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      STRM_PREV_CALC_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      STRM_PREV_CALC_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      STRM_PREV_CALC_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      STRM_PREV_CALC_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      STRM_PREV_CALC_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      STRM_PREV_CALC_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      STRM_PREV_CALC_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      STRM_PREV_CALC_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      STRM_PREV_CALC_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      STRM_PREV_CALC_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      STRM_PREV_CALC_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      STRM_PREV_CALC_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      STRM_PREV_CALC_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      STRM_PREV_CALC_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      STRM_PREV_CALC_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      STRM_PREV_CALC_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      STRM_PREV_CALC_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      STRM_PREV_CALC_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      STRM_PREV_CALC_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      STRM_PREV_CALC_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      STRM_PREV_CALC_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      STRM_PREV_CALC_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      STRM_PREV_CALC_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      STRM_PREV_CALC_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      STRM_PREV_CALC_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      STRM_PREV_CALC_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      STRM_PREV_CALC_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      STRM_PREV_CALC_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      STRM_PREV_CALC_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      STRM_PREV_CALC_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      STRM_PREV_CALC_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      STRM_PREV_CALC_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      STRM_PREV_CALC_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      STRM_PREV_CALC_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      STRM_PREV_CALC_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      STRM_PREV_CALC_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      STRM_PREV_CALC_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      STRM_PREV_CALC_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      STRM_PREV_CALC_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      STRM_PREV_CALC_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      STRM_PREV_CALC_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      STRM_PREV_CALC_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      STRM_PREV_CALC_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      STRM_PREV_CALC_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      STRM_PREV_CALC_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      STRM_PREV_CALC_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      STRM_PREV_CALC_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      STRM_PREV_CALC_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      STRM_PREV_CALC_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      STRM_PREV_CALC_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      STRM_PREV_CALC_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      STRM_PREV_CALC_CBM008.STRM as IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      STRM_PREV_CALC_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      STRM_PREV_CALC_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      STRM_PREV_CALC_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      STRM_PREV_CALC_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      STRM_PREV_CALC_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      STRM_PREV_CALC_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      STRM_PREV_CALC_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      STRM_PREV_CALC_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      STRM_PREV_CALC_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      STRM_PREV_CALC_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      STRM_PREV_CALC_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      STRM_PREV_CALC_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      STRM_PREV_CALC_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      STRM_PREV_CALC_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      STRM_PREV_CALC_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      STRM_PREV_CALC_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      STRM_PREV_CALC_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      STRM_PREV_CALC_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      STRM_PREV_CALC_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      STRM_PREV_CALC_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      STRM_PREV_CALC_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      STRM_PREV_CALC_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      STRM_PREV_CALC_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      STRM_PREV_CALC_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      STRM_PREV_CALC_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      STRM_PREV_CALC_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      STRM_PREV_CALC_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      STRM_PREV_CALC_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      STRM_PREV_CALC_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      STRM_PREV_CALC_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      STRM_PREV_CALC_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      STRM_PREV_CALC_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      STRM_PREV_CALC_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      STRM_PREV_CALC_CBM008.STRM_PREV as IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      STRM_PREV_CALC_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      STRM_PREV_CALC_CBM008.TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      STRIP(CLASS_WITH_INSTR_CBM008.SUBJECT) as SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      STRIP(CLASS_WITH_INSTR_CBM008.CATALOG_NBR) as COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      IFC(CLASS_WITH_INSTR_CBM008.CLASS_NBR IS MISSING,'',
      PUT(CLASS_WITH_INSTR_CBM008.CLASS_NBR,5.)) as SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      IFC(CLASS_WITH_INSTR_CBM008.WEEK_WORKLOAD_HRS IS MISSING,'000',
      PUT(INT(CLASS_WITH_INSTR_CBM008.WEEK_WORKLOAD_HRS*10),Z3.)) as TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      CLASS_WITH_INSTR_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      CLASS_WITH_INSTR_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CLASS_WITH_INSTR_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      STRM_PREV_CALC_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CLASS_WITH_INSTR_CBM008.START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      CLASS_WITH_INSTR_CBM008.CRSE_ID as CRSE_ID_READ_4 length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID_READ_4',
      CLASS_WITH_INSTR_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CLASS_WITH_INSTR_CBM008.CRSE_OFFER_NBR as CRSE_OFFER_NBR_READ_4 length = 8
         label = 'CRSE_OFFER_NBR_READ_4',
      STRM_PREV_CALC_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      STRM_PREV_CALC_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      STRM_PREV_CALC_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      STRM_PREV_CALC_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      STRM_PREV_CALC_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      STRM_PREV_CALC_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      CLASS_WITH_INSTR_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      STRM_PREV_CALC_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      STRM_PREV_CALC_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      STRM_PREV_CALC_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CLASS_WITH_INSTR_CBM008.ACAD_GROUP as COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      CLASS_WITH_INSTR_CBM008.ACAD_ORG as DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.STRM_PREV_CALC_CBM008 as STRM_PREV_CALC_CBM008 left join
      work.CLASS_WITH_INSTR_CBM008 as CLASS_WITH_INSTR_CBM008
         on
         (
            STRM_PREV_CALC_CBM008.CIT_CHK_EMPLID = CLASS_WITH_INSTR_CBM008.EMPLID
            and ((STRM_PREV_CALC_CBM008.STRM = CLASS_WITH_INSTR_CBM008.STRM
            and CLASS_WITH_INSTR_CBM008.SESSION_CODE = IFC(SUBSTR(CLASS_WITH_INSTR_CBM008.STRM,4,1)='5','5W2','1'))
            or (STRM_PREV_CALC_CBM008.STRM = CLASS_WITH_INSTR_CBM008.STRM
            and CLASS_WITH_INSTR_CBM008.SESSION_CODE <> IFC(SUBSTR(CLASS_WITH_INSTR_CBM008.STRM,4,1)='5','5W2','1')
            and DATEPART(STRM_PREV_CALC_CBM008.TERM_END_DT) >= DATEPART(CLASS_WITH_INSTR_CBM008.END_DT))
            or (STRM_PREV_CALC_CBM008.STRM_PREV = CLASS_WITH_INSTR_CBM008.STRM
            and CLASS_WITH_INSTR_CBM008.SESSION_CODE <> IFC(SUBSTR(CLASS_WITH_INSTR_CBM008.STRM,4,1)='5','5W2','1')
            and DATEPART(STRM_PREV_CALC_CBM008.TERM_END_DT_PREV) < DATEPART(CLASS_WITH_INSTR_CBM008.END_DT)))
         )
   where
      CLASS_WITH_INSTR_CBM008.CLASS_NBR NOT IS MISSING
      or STRM_PREV_CALC_CBM008.SOURCE = 'HRA'
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005PT *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_SCTN_CMBND_Extract -               A5B29B8Q.BE00000D *
 *                   ADWSTGPR.PS_SCTN_CMBND_Extract                         *
 *                  READ_4_CLASSES_CBM008 -               A5B29B8Q.BS0001UP *
 *                   work.READ_4_CLASSES_CBM008                             *
 * Target Table:    Join - work.WM7XIL0                   A5B29B8Q.BS0001UQ *
 *==========================================================================*
 *                                                                          *
 * Nothing will be generated for this process because the "Exclude          *
 *  transformation from run" option is selected.                            *
 *                                                                          *
 *==========================================================================*/

/*==========================================================================*
 * Step:            User Written                          A5B29B8Q.BZ0005PU *
 * Transform:       User Written                                            *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WM7XIL0                   A5B29B8Q.BS0001UQ *
 * Target Table:    User Written - work.WM8XW6X           A5B29B8Q.BS0001UR *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*
 *                                                                          *
 * Nothing will be generated for this process because the "Exclude          *
 *  transformation from run" option is selected.                            *
 *                                                                          *
 *==========================================================================*/

/*==========================================================================*
 * Step:            LOOKUP_COMBINED_WRKLD                 A5B29B8Q.BZ0005PV *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   READ_4_CLASSES_CBM008 -               A5B29B8Q.BS0001UP *
 *                   work.READ_4_CLASSES_CBM008                             *
 *                  CHECK_ENROLLMENT_CBM008 -             A5B29B8Q.BS0001UT *
 *                   work.CHECK_ENROLLMENT_CBM008                           *
 *                  User Written - work.W1SFHEFK2         A5B29B8Q.BS0001UO *
 * Target Table:    LOOKUP_COMBINED_WRKLD_CBM008 -        A5B29B8Q.BS0001US *
 *                   work.LOOKUP_COMBINED_WRKLD_CBM008                      *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PV);

proc sql;
   create table work.LOOKUP_COMBINED_WRKLD_CBM008 as
   select
      READ_4_CLASSES_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      READ_4_CLASSES_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_4_CLASSES_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      READ_4_CLASSES_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      READ_4_CLASSES_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      READ_4_CLASSES_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      READ_4_CLASSES_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      READ_4_CLASSES_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      READ_4_CLASSES_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_CLASSES_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      READ_4_CLASSES_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      READ_4_CLASSES_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      READ_4_CLASSES_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      READ_4_CLASSES_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      READ_4_CLASSES_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      READ_4_CLASSES_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      READ_4_CLASSES_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      READ_4_CLASSES_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      READ_4_CLASSES_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      READ_4_CLASSES_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      READ_4_CLASSES_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      READ_4_CLASSES_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      READ_4_CLASSES_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      READ_4_CLASSES_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      READ_4_CLASSES_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      READ_4_CLASSES_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      READ_4_CLASSES_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      READ_4_CLASSES_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      READ_4_CLASSES_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      READ_4_CLASSES_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      READ_4_CLASSES_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      READ_4_CLASSES_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      READ_4_CLASSES_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      READ_4_CLASSES_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      READ_4_CLASSES_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      READ_4_CLASSES_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      READ_4_CLASSES_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      READ_4_CLASSES_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      READ_4_CLASSES_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      READ_4_CLASSES_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      READ_4_CLASSES_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      READ_4_CLASSES_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      READ_4_CLASSES_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      READ_4_CLASSES_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      READ_4_CLASSES_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      READ_4_CLASSES_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      READ_4_CLASSES_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      READ_4_CLASSES_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      READ_4_CLASSES_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      READ_4_CLASSES_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      READ_4_CLASSES_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      READ_4_CLASSES_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      READ_4_CLASSES_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      READ_4_CLASSES_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      READ_4_CLASSES_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      READ_4_CLASSES_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      READ_4_CLASSES_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      READ_4_CLASSES_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_4_CLASSES_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      READ_4_CLASSES_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      READ_4_CLASSES_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      READ_4_CLASSES_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      READ_4_CLASSES_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      READ_4_CLASSES_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      READ_4_CLASSES_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      READ_4_CLASSES_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      READ_4_CLASSES_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      READ_4_CLASSES_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      READ_4_CLASSES_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      READ_4_CLASSES_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      READ_4_CLASSES_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      READ_4_CLASSES_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      READ_4_CLASSES_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      READ_4_CLASSES_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      READ_4_CLASSES_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      READ_4_CLASSES_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      READ_4_CLASSES_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      READ_4_CLASSES_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      READ_4_CLASSES_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      READ_4_CLASSES_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      READ_4_CLASSES_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      READ_4_CLASSES_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      READ_4_CLASSES_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      READ_4_CLASSES_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      READ_4_CLASSES_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      READ_4_CLASSES_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      READ_4_CLASSES_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      READ_4_CLASSES_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      READ_4_CLASSES_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      READ_4_CLASSES_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      READ_4_CLASSES_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      READ_4_CLASSES_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      READ_4_CLASSES_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      READ_4_CLASSES_CBM008.TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      READ_4_CLASSES_CBM008.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      READ_4_CLASSES_CBM008.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      READ_4_CLASSES_CBM008.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      /*
      IFC(W1SFHEFK2.CLASS_NBR IS MISSING,
      READ_4_CLASSES_CBM008.TEACHING_LOAD_CREDIT,
      PUT(INPUT(READ_4_CLASSES_CBM008.TEACHING_LOAD_CREDIT,BEST8.)/
      COUNT(distinct W1SFHEFK2.CLASS_NBR),Z3.))
      */
      IFC(W1SFHEFK2.CLASS_NBR IS MISSING, READ_4_CLASSES_CBM008.TEACHING_LOAD_CREDIT,
      IFC( W1SFHEFK2.SCTN_COMBINED_ID is missing, PUT(INPUT(READ_4_CLASSES_CBM008.TEACHING_LOAD_CREDIT,BEST8.)/ COUNT(distinct W1SFHEFK2.CLASS_NBR),Z3.),READ_4_CLASSES_CBM008.TEACHING_LOAD_CREDIT)) as TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      READ_4_CLASSES_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      READ_4_CLASSES_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      READ_4_CLASSES_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W1SFHEFK2.SCTN_COMBINED_ID length = 4
         format = $4.
         informat = $4.
         label = 'SCTN_COMBINED_ID',
      W1SFHEFK2.CB_CLASS_CD length = 2
         format = $2.
         informat = $2.
         label = 'CB_CLASS_CD',
      COUNT(distinct READ_4_CLASSES_CBM008.CLASS_NBR) as CLASS_IN_CMBND length = 8
         label = 'CLASS_IN_CMBND',
      READ_4_CLASSES_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      READ_4_CLASSES_CBM008.START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      READ_4_CLASSES_CBM008.CRSE_ID_READ_4 length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID_READ_4',
      READ_4_CLASSES_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      READ_4_CLASSES_CBM008.CRSE_OFFER_NBR_READ_4 length = 8
         label = 'CRSE_OFFER_NBR_READ_4',
      READ_4_CLASSES_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      READ_4_CLASSES_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      READ_4_CLASSES_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      READ_4_CLASSES_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      READ_4_CLASSES_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      READ_4_CLASSES_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      READ_4_CLASSES_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      READ_4_CLASSES_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      READ_4_CLASSES_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      READ_4_CLASSES_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      READ_4_CLASSES_CBM008.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      READ_4_CLASSES_CBM008.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.READ_4_CLASSES_CBM008 as READ_4_CLASSES_CBM008 left join
      work.W1SFHEFK2 as W1SFHEFK2
         on
         (
            READ_4_CLASSES_CBM008.CLASS_NBR = W1SFHEFK2.CLASS_NBR
            and READ_4_CLASSES_CBM008.SESSION_CODE = W1SFHEFK2.SESSION_CODE
            and READ_4_CLASSES_CBM008.STRM = W1SFHEFK2.STRM
         )
   group by
      W1SFHEFK2.STRM,
      W1SFHEFK2.SESSION_CODE,
      W1SFHEFK2.SCTN_COMBINED_ID,
      READ_4_CLASSES_CBM008.SOURCE
   ;
quit;

/*==========================================================================*
 * Step:            SCTN_COMBND_TEACH_LD_CRED             A5B29B8Q.BZ0005PW *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   LOOKUP_COMBINED_WRKLD_CBM008 -        A5B29B8Q.BS0001US *
 *                   work.LOOKUP_COMBINED_WRKLD_CBM008                      *
 *                  PS_INSTR_TERM_DTL_Extract -           A5B29B8Q.BE000041 *
 *                   ADWSTGPR.PS_INSTR_TERM_DTL_Extract                     *
 * Target Table:    SCTN_COMBND_TEACH_LD_CRED_CBM008 -    A5B29B8Q.BS0001UU *
 *                  work.SCTN_COMBND_TEACH_LD_CRED_CBM0                     *
 *                  08                                                      *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PW);

proc sql;
   create table work.SCTN_COMBND_TEACH_LD_CRED_CBM008 as
   select
      LOOKUP_COMBINED_WRKLD_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      LOOKUP_COMBINED_WRKLD_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      LOOKUP_COMBINED_WRKLD_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      LOOKUP_COMBINED_WRKLD_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      LOOKUP_COMBINED_WRKLD_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      LOOKUP_COMBINED_WRKLD_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      LOOKUP_COMBINED_WRKLD_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      LOOKUP_COMBINED_WRKLD_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      LOOKUP_COMBINED_WRKLD_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      LOOKUP_COMBINED_WRKLD_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      LOOKUP_COMBINED_WRKLD_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      LOOKUP_COMBINED_WRKLD_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      LOOKUP_COMBINED_WRKLD_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      LOOKUP_COMBINED_WRKLD_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      LOOKUP_COMBINED_WRKLD_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      LOOKUP_COMBINED_WRKLD_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      LOOKUP_COMBINED_WRKLD_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      LOOKUP_COMBINED_WRKLD_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      LOOKUP_COMBINED_WRKLD_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      LOOKUP_COMBINED_WRKLD_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      LOOKUP_COMBINED_WRKLD_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      LOOKUP_COMBINED_WRKLD_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      LOOKUP_COMBINED_WRKLD_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      LOOKUP_COMBINED_WRKLD_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      LOOKUP_COMBINED_WRKLD_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      LOOKUP_COMBINED_WRKLD_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      LOOKUP_COMBINED_WRKLD_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      LOOKUP_COMBINED_WRKLD_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      LOOKUP_COMBINED_WRKLD_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      LOOKUP_COMBINED_WRKLD_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      LOOKUP_COMBINED_WRKLD_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      LOOKUP_COMBINED_WRKLD_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      LOOKUP_COMBINED_WRKLD_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      LOOKUP_COMBINED_WRKLD_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      LOOKUP_COMBINED_WRKLD_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      LOOKUP_COMBINED_WRKLD_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      LOOKUP_COMBINED_WRKLD_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      LOOKUP_COMBINED_WRKLD_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      LOOKUP_COMBINED_WRKLD_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      LOOKUP_COMBINED_WRKLD_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      LOOKUP_COMBINED_WRKLD_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      LOOKUP_COMBINED_WRKLD_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      LOOKUP_COMBINED_WRKLD_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      LOOKUP_COMBINED_WRKLD_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      LOOKUP_COMBINED_WRKLD_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      LOOKUP_COMBINED_WRKLD_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      LOOKUP_COMBINED_WRKLD_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      LOOKUP_COMBINED_WRKLD_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      LOOKUP_COMBINED_WRKLD_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      LOOKUP_COMBINED_WRKLD_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      LOOKUP_COMBINED_WRKLD_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      LOOKUP_COMBINED_WRKLD_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      LOOKUP_COMBINED_WRKLD_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      LOOKUP_COMBINED_WRKLD_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      LOOKUP_COMBINED_WRKLD_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      LOOKUP_COMBINED_WRKLD_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      LOOKUP_COMBINED_WRKLD_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      LOOKUP_COMBINED_WRKLD_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      LOOKUP_COMBINED_WRKLD_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      LOOKUP_COMBINED_WRKLD_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      LOOKUP_COMBINED_WRKLD_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      LOOKUP_COMBINED_WRKLD_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      LOOKUP_COMBINED_WRKLD_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      LOOKUP_COMBINED_WRKLD_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      LOOKUP_COMBINED_WRKLD_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      LOOKUP_COMBINED_WRKLD_CBM008.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      LOOKUP_COMBINED_WRKLD_CBM008.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      LOOKUP_COMBINED_WRKLD_CBM008.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      LOOKUP_COMBINED_WRKLD_CBM008.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      LOOKUP_COMBINED_WRKLD_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      LOOKUP_COMBINED_WRKLD_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      LOOKUP_COMBINED_WRKLD_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      LOOKUP_COMBINED_WRKLD_CBM008.SCTN_COMBINED_ID length = 4
         format = $4.
         informat = $4.
         label = 'SCTN_COMBINED_ID',
      LOOKUP_COMBINED_WRKLD_CBM008.CB_CLASS_CD length = 2
         format = $2.
         informat = $2.
         label = 'CB_CLASS_CD',
      LOOKUP_COMBINED_WRKLD_CBM008.CLASS_IN_CMBND length = 8
         label = 'CLASS_IN_CMBND',
      LOOKUP_COMBINED_WRKLD_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.CRSE_ID_READ_4 length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID_READ_4',
      LOOKUP_COMBINED_WRKLD_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      LOOKUP_COMBINED_WRKLD_CBM008.CRSE_OFFER_NBR_READ_4 length = 8
         label = 'CRSE_OFFER_NBR_READ_4',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      LOOKUP_COMBINED_WRKLD_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      LOOKUP_COMBINED_WRKLD_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      /*IFN(PS_INSTR_TERM_DTL_Extract.WEEK_WORKLOAD_HRS IS MISSING,0,
      ROUND(ROUND(PS_INSTR_TERM_DTL_Extract.WEEK_WORKLOAD_HRS*10,1)
      /LOOKUP_COMBINED_WRKLD_CBM008.CLASS_IN_CMBND),1)
      */



      IFN(PS_INSTR_TERM_DTL_Extract.WEEK_WORKLOAD_HRS IS MISSING,0,
      ROUND(PS_INSTR_TERM_DTL_Extract.WEEK_WORKLOAD_HRS*10,1)) as WEEK_WORKLOAD_HRS length = 8
         format = 7.2
         informat = 7.2
         label = 'WEEK_WORKLOAD_HRS',
      LOOKUP_COMBINED_WRKLD_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      LOOKUP_COMBINED_WRKLD_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      LOOKUP_COMBINED_WRKLD_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      LOOKUP_COMBINED_WRKLD_CBM008.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      LOOKUP_COMBINED_WRKLD_CBM008.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.LOOKUP_COMBINED_WRKLD_CBM008 as LOOKUP_COMBINED_WRKLD_CBM008 left join
      ADWSTGPR.PS_INSTR_TERM_DTL_Extract as PS_INSTR_TERM_DTL_Extract
         on
         (
            LOOKUP_COMBINED_WRKLD_CBM008.SCTN_COMBINED_ID NOT IS MISSING
            and LOOKUP_COMBINED_WRKLD_CBM008.STRM = PS_INSTR_TERM_DTL_Extract.STRM
            and LOOKUP_COMBINED_WRKLD_CBM008.SCTN_COMBINED_ID = PS_INSTR_TERM_DTL_Extract.SCTN_COMBINED_ID
            and LOOKUP_COMBINED_WRKLD_CBM008.SESSION_CODE = PS_INSTR_TERM_DTL_Extract.SESSION_CODE
            and LOOKUP_COMBINED_WRKLD_CBM008.CIT_CHK_EMPLID = PS_INSTR_TERM_DTL_Extract.EMPLID
            and PS_INSTR_TERM_DTL_Extract.WEEK_WORKLOAD_HRS <> 0
         )
   ;
quit;

/*==========================================================================*
 * Step:            FLEX_ENTRY_CALC                       A5B29B8Q.BZ0005PX *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    SCTN_COMBND_TEACH_LD_CRED_CBM008 -    A5B29B8Q.BS0001UU *
 *                  work.SCTN_COMBND_TEACH_LD_CRED_CBM0                     *
 *                  08                                                      *
 * Target Table:    FLEX_ENTRY_CALC_CBM008 -              A5B29B8Q.BS0001UV *
 *                   work.FLEX_ENTRY_CALC_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PX);

%let SYSLAST = %nrquote(work.SCTN_COMBND_TEACH_LD_CRED_CBM008);

proc sql;
   create table work.FLEX_ENTRY_CALC_CBM008 as
   select
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      IFC(SCTN_COMBND_TEACH_LD_CRED_CBM008.STRM NOT IS MISSING,
      IFC(SCTN_COMBND_TEACH_LD_CRED_CBM008.STRM<>SCTN_COMBND_TEACH_LD_CRED_CBM008.IN_STRM &
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SESSION_CODE<>
      IFC(SUBSTR(SCTN_COMBND_TEACH_LD_CRED_CBM008.STRM,4,1)='5','5W2','1'),'6',
      IFC(SCTN_COMBND_TEACH_LD_CRED_CBM008.IN_STRM=SCTN_COMBND_TEACH_LD_CRED_CBM008.STRM &
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SESSION_CODE<>
      IFC(SUBSTR(SCTN_COMBND_TEACH_LD_CRED_CBM008.STRM,4,1)='5','5W2','1') &
      SCTN_COMBND_TEACH_LD_CRED_CBM008.START_DT>SCTN_COMBND_TEACH_LD_CRED_CBM008.CENSUS_DT,'1',
      '0')),'0') as FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      IFC(SCTN_COMBND_TEACH_LD_CRED_CBM008.WEEK_WORKLOAD_HRS > 0,
      PUT(SCTN_COMBND_TEACH_LD_CRED_CBM008.WEEK_WORKLOAD_HRS,Z3.),
      SCTN_COMBND_TEACH_LD_CRED_CBM008.TEACHING_LOAD_CREDIT) as TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SCTN_COMBINED_ID length = 4
         format = $4.
         informat = $4.
         label = 'SCTN_COMBINED_ID',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CB_CLASS_CD length = 2
         format = $2.
         informat = $2.
         label = 'CB_CLASS_CD',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CLASS_IN_CMBND length = 8
         label = 'CLASS_IN_CMBND',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CRSE_ID_READ_4 length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID_READ_4',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.CRSE_OFFER_NBR_READ_4 length = 8
         label = 'CRSE_OFFER_NBR_READ_4',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      SCTN_COMBND_TEACH_LD_CRED_CBM008.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.SCTN_COMBND_TEACH_LD_CRED_CBM008 as SCTN_COMBND_TEACH_LD_CRED_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            CHECK_CB_EXCLUDE                      A5B29B8Q.BZ0005PY *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   FLEX_ENTRY_CALC_CBM008 -              A5B29B8Q.BS0001UV *
 *                   work.FLEX_ENTRY_CALC_CBM008                            *
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 * Target Table:    CHECK_CB_EXCLUDE_CBM008 -             A5B29B8Q.BS0001UW *
 *                   work.CHECK_CB_EXCLUDE_CBM008                           *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PY);

proc sql;
   create table work.CHECK_CB_EXCLUDE_CBM008 as
   select
      FLEX_ENTRY_CALC_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      FLEX_ENTRY_CALC_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      FLEX_ENTRY_CALC_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      FLEX_ENTRY_CALC_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      FLEX_ENTRY_CALC_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      FLEX_ENTRY_CALC_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      FLEX_ENTRY_CALC_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      FLEX_ENTRY_CALC_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      FLEX_ENTRY_CALC_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      FLEX_ENTRY_CALC_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      FLEX_ENTRY_CALC_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      FLEX_ENTRY_CALC_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      FLEX_ENTRY_CALC_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      FLEX_ENTRY_CALC_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      FLEX_ENTRY_CALC_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      FLEX_ENTRY_CALC_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      FLEX_ENTRY_CALC_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      FLEX_ENTRY_CALC_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      FLEX_ENTRY_CALC_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      FLEX_ENTRY_CALC_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      FLEX_ENTRY_CALC_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      FLEX_ENTRY_CALC_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      FLEX_ENTRY_CALC_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      FLEX_ENTRY_CALC_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      FLEX_ENTRY_CALC_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      FLEX_ENTRY_CALC_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      FLEX_ENTRY_CALC_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      FLEX_ENTRY_CALC_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      FLEX_ENTRY_CALC_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      FLEX_ENTRY_CALC_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      FLEX_ENTRY_CALC_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      FLEX_ENTRY_CALC_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      FLEX_ENTRY_CALC_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      FLEX_ENTRY_CALC_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      FLEX_ENTRY_CALC_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      FLEX_ENTRY_CALC_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      FLEX_ENTRY_CALC_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      FLEX_ENTRY_CALC_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      FLEX_ENTRY_CALC_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      FLEX_ENTRY_CALC_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      FLEX_ENTRY_CALC_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      FLEX_ENTRY_CALC_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      FLEX_ENTRY_CALC_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      FLEX_ENTRY_CALC_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      FLEX_ENTRY_CALC_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      FLEX_ENTRY_CALC_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      FLEX_ENTRY_CALC_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      FLEX_ENTRY_CALC_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      FLEX_ENTRY_CALC_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      FLEX_ENTRY_CALC_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      FLEX_ENTRY_CALC_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      FLEX_ENTRY_CALC_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      FLEX_ENTRY_CALC_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      FLEX_ENTRY_CALC_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      FLEX_ENTRY_CALC_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      FLEX_ENTRY_CALC_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      FLEX_ENTRY_CALC_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      FLEX_ENTRY_CALC_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      FLEX_ENTRY_CALC_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      FLEX_ENTRY_CALC_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      FLEX_ENTRY_CALC_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      FLEX_ENTRY_CALC_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      FLEX_ENTRY_CALC_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      FLEX_ENTRY_CALC_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      FLEX_ENTRY_CALC_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      FLEX_ENTRY_CALC_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      FLEX_ENTRY_CALC_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      FLEX_ENTRY_CALC_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      FLEX_ENTRY_CALC_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      FLEX_ENTRY_CALC_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      FLEX_ENTRY_CALC_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      FLEX_ENTRY_CALC_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      FLEX_ENTRY_CALC_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      FLEX_ENTRY_CALC_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      FLEX_ENTRY_CALC_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      FLEX_ENTRY_CALC_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      FLEX_ENTRY_CALC_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      FLEX_ENTRY_CALC_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      FLEX_ENTRY_CALC_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      FLEX_ENTRY_CALC_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      FLEX_ENTRY_CALC_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      FLEX_ENTRY_CALC_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      FLEX_ENTRY_CALC_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      FLEX_ENTRY_CALC_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      FLEX_ENTRY_CALC_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      FLEX_ENTRY_CALC_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      FLEX_ENTRY_CALC_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      FLEX_ENTRY_CALC_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      FLEX_ENTRY_CALC_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      FLEX_ENTRY_CALC_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      FLEX_ENTRY_CALC_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      FLEX_ENTRY_CALC_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      FLEX_ENTRY_CALC_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      FLEX_ENTRY_CALC_CBM008.TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      FLEX_ENTRY_CALC_CBM008.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      FLEX_ENTRY_CALC_CBM008.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      FLEX_ENTRY_CALC_CBM008.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      FLEX_ENTRY_CALC_CBM008.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      FLEX_ENTRY_CALC_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      FLEX_ENTRY_CALC_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      FLEX_ENTRY_CALC_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      FLEX_ENTRY_CALC_CBM008.SCTN_COMBINED_ID length = 4
         format = $4.
         informat = $4.
         label = 'SCTN_COMBINED_ID',
      FLEX_ENTRY_CALC_CBM008.CB_CLASS_CD length = 2
         format = $2.
         informat = $2.
         label = 'CB_CLASS_CD',
      FLEX_ENTRY_CALC_CBM008.CLASS_IN_CMBND length = 8
         label = 'CLASS_IN_CMBND',
      FLEX_ENTRY_CALC_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      FLEX_ENTRY_CALC_CBM008.CRSE_ID_READ_4 length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID_READ_4',
      FLEX_ENTRY_CALC_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      FLEX_ENTRY_CALC_CBM008.CRSE_OFFER_NBR_READ_4 length = 8
         label = 'CRSE_OFFER_NBR_READ_4',
      IFC(PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR_VALUE='EXCLUDE','Y','N') as CB_EXCLUDE length = 1
         format = $1.
         informat = $1.
         label = 'CB_EXCLUDE',
      FLEX_ENTRY_CALC_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      FLEX_ENTRY_CALC_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      FLEX_ENTRY_CALC_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      FLEX_ENTRY_CALC_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      FLEX_ENTRY_CALC_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      FLEX_ENTRY_CALC_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      FLEX_ENTRY_CALC_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      FLEX_ENTRY_CALC_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      FLEX_ENTRY_CALC_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      FLEX_ENTRY_CALC_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      FLEX_ENTRY_CALC_CBM008.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      FLEX_ENTRY_CALC_CBM008.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.FLEX_ENTRY_CALC_CBM008 as FLEX_ENTRY_CALC_CBM008 left join
      ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract as PS_CLASS_ATTRIBUTE_Extract
         on
         (
            PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR = 'CB'
            and PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR_VALUE = 'EXCLUDE'
            and FLEX_ENTRY_CALC_CBM008.CRSE_ID_READ_4 = PS_CLASS_ATTRIBUTE_Extract.CRSE_ID
            and FLEX_ENTRY_CALC_CBM008.CRSE_OFFER_NBR_READ_4 = PS_CLASS_ATTRIBUTE_Extract.CRSE_OFFER_NBR
            and FLEX_ENTRY_CALC_CBM008.STRM = PS_CLASS_ATTRIBUTE_Extract.STRM
            and FLEX_ENTRY_CALC_CBM008.SESSION_CODE = PS_CLASS_ATTRIBUTE_Extract.SESSION_CODE
            and FLEX_ENTRY_CALC_CBM008.CLASS_SECTION = PS_CLASS_ATTRIBUTE_Extract.CLASS_SECTION
         )
   ;
quit;

/*==========================================================================*
 * Step:            NON_DLRN_STDNTS                       A5B29B8Q.BZ0005PZ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  ADW_CBM_DLRNORPT -                    A5B29B8Q.BE00000F *
 *                   CBMPRD.ADW_CBM_DLRNORPT                                *
 * Target Table:    NON_DLRN_STDNTS_CBM008 -              A5B29B8Q.BS0001UX *
 *                   work.NON_DLRN_STDNTS_CBM008                            *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005PZ);

proc sql;
   create table work.NON_DLRN_STDNTS_CBM008 as
   select distinct
      PS_STDNT_ENRL_Extract.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      PS_STDNT_ENRL_Extract.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      MAX(IFC(ADW_CBM_DLRNORPT.EMPLID IS MISSING,'1','0')) as ENROLLED_STDNTS length = 1
         format = $1.
         informat = $1.
         label = 'ENROLLED_STDNTS'
   from
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract left join
      CBMPRD.ADW_CBM_DLRNORPT as ADW_CBM_DLRNORPT
         on
         (
            PS_STDNT_ENRL_Extract.EMPLID = ADW_CBM_DLRNORPT.EMPLID
            and PS_STDNT_ENRL_Extract.STRM = ADW_CBM_DLRNORPT.Reporting_Term
         )
   where
      PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS = 'E'
      and (PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST IS MISSING
      or PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST <> 'CENS')
      and (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
      or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
   group by
      PS_STDNT_ENRL_Extract.CLASS_NBR,
      PS_STDNT_ENRL_Extract.STRM
   ;
quit;

/*==========================================================================*
 * Step:            CLASSES_WITH_STDNTS                   A5B29B8Q.BZ0005Q0 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   NON_DLRN_STDNTS_CBM008 -              A5B29B8Q.BS0001UX *
 *                   work.NON_DLRN_STDNTS_CBM008                            *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 * Target Table:    CLASSES_WITH_STDNTS_CBM008 -          A5B29B8Q.BS0001UY *
 *                   work.CLASSES_WITH_STDNTS_CBM008                        *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q0);

proc sql;
   create table work.CLASSES_WITH_STDNTS_CBM008 as
   select
      PS_CLASS_TBL_Extract.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_CLASS_TBL_Extract.CLASS_NBR length = 8
         label = 'CLASS_NBR'
   from
      ADWSTGPR.PS_CLASS_TBL_Extract as PS_CLASS_TBL_Extract inner join
      work.NON_DLRN_STDNTS_CBM008 as NON_DLRN_STDNTS_CBM008
         on
         (
            PS_CLASS_TBL_Extract.STRM = NON_DLRN_STDNTS_CBM008.STRM
            and PS_CLASS_TBL_Extract.CLASS_NBR = NON_DLRN_STDNTS_CBM008.CLASS_NBR
         )
   where
      NON_DLRN_STDNTS_CBM008.ENROLLED_STDNTS = '1'
   ;
quit;

/*==========================================================================*
 * Step:            CHECK_STDNT_ENROLL                    A5B29B8Q.BZ0005Q1 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   CHECK_CB_EXCLUDE_CBM008 -             A5B29B8Q.BS0001UW *
 *                   work.CHECK_CB_EXCLUDE_CBM008                           *
 *                  CLASSES_WITH_STDNTS_CBM008 -          A5B29B8Q.BS0001UY *
 *                   work.CLASSES_WITH_STDNTS_CBM008                        *
 * Target Table:    CHECK_STDNT_ENROLL_CBM008 -           A5B29B8Q.BS0001UZ *
 *                   work.CHECK_STDNT_ENROLL_CBM008                         *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q1);

proc sql;
   create table work.CHECK_STDNT_ENROLL_CBM008 as
   select
      CHECK_CB_EXCLUDE_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      CHECK_CB_EXCLUDE_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      CHECK_CB_EXCLUDE_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      CHECK_CB_EXCLUDE_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      CHECK_CB_EXCLUDE_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      CHECK_CB_EXCLUDE_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      CHECK_CB_EXCLUDE_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CHECK_CB_EXCLUDE_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      CHECK_CB_EXCLUDE_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      CHECK_CB_EXCLUDE_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      CHECK_CB_EXCLUDE_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CHECK_CB_EXCLUDE_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      CHECK_CB_EXCLUDE_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      CHECK_CB_EXCLUDE_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      CHECK_CB_EXCLUDE_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      CHECK_CB_EXCLUDE_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      CHECK_CB_EXCLUDE_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      CHECK_CB_EXCLUDE_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      CHECK_CB_EXCLUDE_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      CHECK_CB_EXCLUDE_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      CHECK_CB_EXCLUDE_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      CHECK_CB_EXCLUDE_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      CHECK_CB_EXCLUDE_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      CHECK_CB_EXCLUDE_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      CHECK_CB_EXCLUDE_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      CHECK_CB_EXCLUDE_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      CHECK_CB_EXCLUDE_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      CHECK_CB_EXCLUDE_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      CHECK_CB_EXCLUDE_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      CHECK_CB_EXCLUDE_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      CHECK_CB_EXCLUDE_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      CHECK_CB_EXCLUDE_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      CHECK_CB_EXCLUDE_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      CHECK_CB_EXCLUDE_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      CHECK_CB_EXCLUDE_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      CHECK_CB_EXCLUDE_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      CHECK_CB_EXCLUDE_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      CHECK_CB_EXCLUDE_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      CHECK_CB_EXCLUDE_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      CHECK_CB_EXCLUDE_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      CHECK_CB_EXCLUDE_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      CHECK_CB_EXCLUDE_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      CHECK_CB_EXCLUDE_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      CHECK_CB_EXCLUDE_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      CHECK_CB_EXCLUDE_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CHECK_CB_EXCLUDE_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      CHECK_CB_EXCLUDE_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      CHECK_CB_EXCLUDE_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      CHECK_CB_EXCLUDE_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CHECK_CB_EXCLUDE_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      CHECK_CB_EXCLUDE_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CHECK_CB_EXCLUDE_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      CHECK_CB_EXCLUDE_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      CHECK_CB_EXCLUDE_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CHECK_CB_EXCLUDE_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      CHECK_CB_EXCLUDE_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      CHECK_CB_EXCLUDE_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      CHECK_CB_EXCLUDE_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      CHECK_CB_EXCLUDE_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      CHECK_CB_EXCLUDE_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      CHECK_CB_EXCLUDE_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      CHECK_CB_EXCLUDE_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      CHECK_CB_EXCLUDE_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      CHECK_CB_EXCLUDE_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      CHECK_CB_EXCLUDE_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      CHECK_CB_EXCLUDE_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      CHECK_CB_EXCLUDE_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      CHECK_CB_EXCLUDE_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      CHECK_CB_EXCLUDE_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      CHECK_CB_EXCLUDE_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      CHECK_CB_EXCLUDE_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      CHECK_CB_EXCLUDE_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      CHECK_CB_EXCLUDE_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      CHECK_CB_EXCLUDE_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      CHECK_CB_EXCLUDE_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      CHECK_CB_EXCLUDE_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      CHECK_CB_EXCLUDE_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      CHECK_CB_EXCLUDE_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      CHECK_CB_EXCLUDE_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      CHECK_CB_EXCLUDE_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      CHECK_CB_EXCLUDE_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      CHECK_CB_EXCLUDE_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      CHECK_CB_EXCLUDE_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      CHECK_CB_EXCLUDE_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CHECK_CB_EXCLUDE_CBM008.TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      CHECK_CB_EXCLUDE_CBM008.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      CHECK_CB_EXCLUDE_CBM008.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      CHECK_CB_EXCLUDE_CBM008.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      CHECK_CB_EXCLUDE_CBM008.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      CHECK_CB_EXCLUDE_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      CHECK_CB_EXCLUDE_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CHECK_CB_EXCLUDE_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CHECK_CB_EXCLUDE_CBM008.SCTN_COMBINED_ID length = 4
         format = $4.
         informat = $4.
         label = 'SCTN_COMBINED_ID',
      CHECK_CB_EXCLUDE_CBM008.CB_CLASS_CD length = 2
         format = $2.
         informat = $2.
         label = 'CB_CLASS_CD',
      CHECK_CB_EXCLUDE_CBM008.CLASS_IN_CMBND length = 8
         label = 'CLASS_IN_CMBND',
      CHECK_CB_EXCLUDE_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CHECK_CB_EXCLUDE_CBM008.CRSE_ID_READ_4 length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID_READ_4',
      CHECK_CB_EXCLUDE_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CHECK_CB_EXCLUDE_CBM008.CRSE_OFFER_NBR_READ_4 length = 8
         label = 'CRSE_OFFER_NBR_READ_4',
      CHECK_CB_EXCLUDE_CBM008.CB_EXCLUDE length = 1
         format = $1.
         informat = $1.
         label = 'CB_EXCLUDE',
      IFC(CLASSES_WITH_STDNTS_CBM008.CLASS_NBR NOT IS MISSING,'Y','N') as STDNTS_ENROLLED length = 1
         format = $1.
         informat = $1.
         label = 'STDNTS_ENROLLED',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      CHECK_CB_EXCLUDE_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      CHECK_CB_EXCLUDE_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      CHECK_CB_EXCLUDE_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      CHECK_CB_EXCLUDE_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      CHECK_CB_EXCLUDE_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      CHECK_CB_EXCLUDE_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CHECK_CB_EXCLUDE_CBM008.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      CHECK_CB_EXCLUDE_CBM008.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.CHECK_CB_EXCLUDE_CBM008 as CHECK_CB_EXCLUDE_CBM008 left join
      work.CLASSES_WITH_STDNTS_CBM008 as CLASSES_WITH_STDNTS_CBM008
         on
         (
            CHECK_CB_EXCLUDE_CBM008.CLASS_NBR = CLASSES_WITH_STDNTS_CBM008.CLASS_NBR
            and CHECK_CB_EXCLUDE_CBM008.STRM = CLASSES_WITH_STDNTS_CBM008.STRM
         )
   ;
quit;

/*==========================================================================*
 * Step:            FORMAT_HRE_NAME_UL                    A5B29B8Q.BZ0005Q2 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    CHECK_STDNT_ENROLL_CBM008 -           A5B29B8Q.BS0001UZ *
 *                   work.CHECK_STDNT_ENROLL_CBM008                         *
 * Target Table:    FORMAT_HRE_NAME_UL_CBM008 -           A5B29B8Q.BS0001V0 *
 *                   work.FORMAT_HRE_NAME_UL_CBM008                         *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q2);

%let SYSLAST = %nrquote(work.CHECK_STDNT_ENROLL_CBM008);

proc sql;
   create table work.FORMAT_HRE_NAME_UL_CBM008 as
   select
      CHECK_STDNT_ENROLL_CBM008.SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      CHECK_STDNT_ENROLL_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      CHECK_STDNT_ENROLL_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      CHECK_STDNT_ENROLL_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      CHECK_STDNT_ENROLL_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      CHECK_STDNT_ENROLL_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      CHECK_STDNT_ENROLL_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CHECK_STDNT_ENROLL_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      CHECK_STDNT_ENROLL_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      CHECK_STDNT_ENROLL_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      CHECK_STDNT_ENROLL_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      CHECK_STDNT_ENROLL_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      CHECK_STDNT_ENROLL_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      CHECK_STDNT_ENROLL_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      CHECK_STDNT_ENROLL_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      CHECK_STDNT_ENROLL_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      CHECK_STDNT_ENROLL_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      CHECK_STDNT_ENROLL_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      CHECK_STDNT_ENROLL_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      CHECK_STDNT_ENROLL_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      CHECK_STDNT_ENROLL_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      CHECK_STDNT_ENROLL_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      CHECK_STDNT_ENROLL_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      CHECK_STDNT_ENROLL_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      CHECK_STDNT_ENROLL_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      CHECK_STDNT_ENROLL_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      CHECK_STDNT_ENROLL_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      CHECK_STDNT_ENROLL_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      CHECK_STDNT_ENROLL_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      CHECK_STDNT_ENROLL_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      CHECK_STDNT_ENROLL_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      CHECK_STDNT_ENROLL_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      CHECK_STDNT_ENROLL_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      CHECK_STDNT_ENROLL_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      CHECK_STDNT_ENROLL_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      CHECK_STDNT_ENROLL_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      CHECK_STDNT_ENROLL_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      CHECK_STDNT_ENROLL_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      CHECK_STDNT_ENROLL_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      CHECK_STDNT_ENROLL_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      CHECK_STDNT_ENROLL_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      CHECK_STDNT_ENROLL_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      CHECK_STDNT_ENROLL_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      CHECK_STDNT_ENROLL_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      CHECK_STDNT_ENROLL_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      CHECK_STDNT_ENROLL_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      CHECK_STDNT_ENROLL_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      CHECK_STDNT_ENROLL_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      CHECK_STDNT_ENROLL_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CHECK_STDNT_ENROLL_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      CHECK_STDNT_ENROLL_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      CHECK_STDNT_ENROLL_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      CHECK_STDNT_ENROLL_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      CHECK_STDNT_ENROLL_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      CHECK_STDNT_ENROLL_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      CHECK_STDNT_ENROLL_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      CHECK_STDNT_ENROLL_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      CHECK_STDNT_ENROLL_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      CHECK_STDNT_ENROLL_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      CHECK_STDNT_ENROLL_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      CHECK_STDNT_ENROLL_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      CHECK_STDNT_ENROLL_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      CHECK_STDNT_ENROLL_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      CHECK_STDNT_ENROLL_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      CHECK_STDNT_ENROLL_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      CHECK_STDNT_ENROLL_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      CHECK_STDNT_ENROLL_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      CHECK_STDNT_ENROLL_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      CHECK_STDNT_ENROLL_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      CHECK_STDNT_ENROLL_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      CHECK_STDNT_ENROLL_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      CHECK_STDNT_ENROLL_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      CHECK_STDNT_ENROLL_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      CHECK_STDNT_ENROLL_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      CHECK_STDNT_ENROLL_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      CHECK_STDNT_ENROLL_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      CHECK_STDNT_ENROLL_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      CHECK_STDNT_ENROLL_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      CHECK_STDNT_ENROLL_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      CHECK_STDNT_ENROLL_CBM008.TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      CHECK_STDNT_ENROLL_CBM008.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      CHECK_STDNT_ENROLL_CBM008.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      CHECK_STDNT_ENROLL_CBM008.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      CHECK_STDNT_ENROLL_CBM008.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      CHECK_STDNT_ENROLL_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      CHECK_STDNT_ENROLL_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      CHECK_STDNT_ENROLL_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      CHECK_STDNT_ENROLL_CBM008.SCTN_COMBINED_ID length = 4
         format = $4.
         informat = $4.
         label = 'SCTN_COMBINED_ID',
      CHECK_STDNT_ENROLL_CBM008.CB_CLASS_CD length = 2
         format = $2.
         informat = $2.
         label = 'CB_CLASS_CD',
      CHECK_STDNT_ENROLL_CBM008.CLASS_IN_CMBND length = 8
         label = 'CLASS_IN_CMBND',
      CHECK_STDNT_ENROLL_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      CHECK_STDNT_ENROLL_CBM008.CRSE_ID_READ_4 length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID_READ_4',
      CHECK_STDNT_ENROLL_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      CHECK_STDNT_ENROLL_CBM008.CRSE_OFFER_NBR_READ_4 length = 8
         label = 'CRSE_OFFER_NBR_READ_4',
      CHECK_STDNT_ENROLL_CBM008.CB_EXCLUDE length = 1
         format = $1.
         informat = $1.
         label = 'CB_EXCLUDE',
      CHECK_STDNT_ENROLL_CBM008.STDNTS_ENROLLED length = 1
         format = $1.
         informat = $1.
         label = 'STDNTS_ENROLLED',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      IFC(SUBSTR(CHECK_STDNT_ENROLL_CBM008.UTA_HRE_NAME_UL,1,2)='Mc',
      'Mc'||UPCASE(SUBSTR(CHECK_STDNT_ENROLL_CBM008.UTA_HRE_NAME_UL,3,1)) ||
      IFC(LENGTH(CHECK_STDNT_ENROLL_CBM008.UTA_HRE_NAME_UL)>3,
      SUBSTR(CHECK_STDNT_ENROLL_CBM008.UTA_HRE_NAME_UL,4,
      LENGTH(CHECK_STDNT_ENROLL_CBM008.UTA_HRE_NAME_UL)-3),''),
      CHECK_STDNT_ENROLL_CBM008.UTA_HRE_NAME_UL) as UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      IFC(CHECK_STDNT_ENROLL_CBM008.FACULTY_CLASSIF IS MISSING &
      (CHECK_STDNT_ENROLL_CBM008.SOURCE='INSTR' |
      (CHECK_STDNT_ENROLL_CBM008.SOURCE='HRA' & CHECK_STDNT_ENROLL_CBM008.SECTION_NBR is not missing & SUM(INPUT(CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_01, BEST12.),
      INPUT(CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_02, BEST12.),INPUT(CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_11, BEST12.),INPUT(CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_12, BEST12.),INPUT(CHECK_STDNT_ENROLL_CBM008.PERCENT_APPOINMENT_13, BEST12.),INPUT(CHECK_STDNT_ENROLL_CBM008.FE_APPOINTMENT, BEST12.))>0)),'5',
      CHECK_STDNT_ENROLL_CBM008.FACULTY_CLASSIF) as FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      CHECK_STDNT_ENROLL_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      CHECK_STDNT_ENROLL_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      CHECK_STDNT_ENROLL_CBM008.UTA_HRE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_STATUS',
      CHECK_STDNT_ENROLL_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      CHECK_STDNT_ENROLL_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      CHECK_STDNT_ENROLL_CBM008.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      CHECK_STDNT_ENROLL_CBM008.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.CHECK_STDNT_ENROLL_CBM008 as CHECK_STDNT_ENROLL_CBM008
   where
      CHECK_STDNT_ENROLL_CBM008.CB_EXCLUDE = 'N'
      and (CHECK_STDNT_ENROLL_CBM008.SECTION_NBR IS MISSING
      or CHECK_STDNT_ENROLL_CBM008.STDNTS_ENROLLED <> 'N')
      and CHECK_STDNT_ENROLL_CBM008.FLEX_ENTRY <> '6'
   ;
quit;

/*==========================================================================*
 * Step:            FORMAT_CBM008                         A5B29B8Q.BZ0005Q3 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    FORMAT_HRE_NAME_UL_CBM008 -           A5B29B8Q.BS0001V0 *
 *                   work.FORMAT_HRE_NAME_UL_CBM008                         *
 * Target Table:    FORMAT_CBM008 - work.FORMAT_CBM008    A5B29B8Q.BS0001V1 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q3);

%let SYSLAST = %nrquote(work.FORMAT_HRE_NAME_UL_CBM008);

proc sql;
   create table work.FORMAT_CBM008 as
   select
      IFC(SUBSTR(FORMAT_HRE_NAME_UL_CBM008.SSN,1,2) IN ('99','XX') | FORMAT_HRE_NAME_UL_CBM008.SSN IS MISSING,
      cats('9',substr(FORMAT_HRE_NAME_UL_CBM008.CIT_CHK_EMPLID,3,8)),FORMAT_HRE_NAME_UL_CBM008.SSN) as SSN length = 9
         format = $9.
         informat = $9.
         label = 'SSN',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRA_POSITIONID length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      FORMAT_HRE_NAME_UL_CBM008.ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD',
      FORMAT_HRE_NAME_UL_CBM008.DIST_PCT length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT',
      FORMAT_HRE_NAME_UL_CBM008.CHARTFIELD1 length = 10
         format = $10.
         informat = $10.
         label = 'CHARTFIELD1',
      FORMAT_HRE_NAME_UL_CBM008.CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'CLASS_FLD',
      FORMAT_HRE_NAME_UL_CBM008.FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'FUND_CODE',
      FORMAT_HRE_NAME_UL_CBM008.CIT_CHK_EMPLID_PERS_NID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      FORMAT_HRE_NAME_UL_CBM008.CIT_CHK_EMPLID_HR_PS_EMP length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_HR_PS_EMP',
      FORMAT_HRE_NAME_UL_CBM008.FOUND_IN_NAMES length = 1
         format = $1.
         informat = $1.
         label = 'FOUND_IN_NAMES',
      FORMAT_HRE_NAME_UL_CBM008.CIT_CHK_EMPLID_EXT_SYS length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID_EXT_SYS',
      FORMAT_HRE_NAME_UL_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      FORMAT_HRE_NAME_UL_CBM008.EMPL_RCD length = 8
         label = 'EMPL_RCD',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRA_MO_SAL length = 8
         format = 11.2
         informat = 11.2
         label = 'UTA_HRA_MO_SAL',
      FORMAT_HRE_NAME_UL_CBM008.EFFDT_UTA_HR_ADDL_PAY length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT_UTA_HR_ADDL_PAY',
      FORMAT_HRE_NAME_UL_CBM008.APPT_BEGIN_DT length = 8
         label = 'APPT_BEGIN_DT',
      FORMAT_HRE_NAME_UL_CBM008.APPT_END_DT length = 8
         label = 'APPT_END_DT',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRA_PCT_TIME length = 8
         format = 7.4
         informat = 7.4
         label = 'UTA_HRA_PCT_TIME',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRA_JOB_GRPCD length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRA_JOB_GRPCD',
      FORMAT_HRE_NAME_UL_CBM008.CBM_TERM length = 1
         format = $1.
         informat = $1.
         label = 'CBM_TERM',
      FORMAT_HRE_NAME_UL_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      FORMAT_HRE_NAME_UL_CBM008.ACCT_CD_ADDL length = 25
         format = $25.
         informat = $25.
         label = 'ACCT_CD_ADDL',
      FORMAT_HRE_NAME_UL_CBM008.DIST_PCT_ADDL length = 8
         format = 8.3
         informat = 8.3
         label = 'DIST_PCT_ADDL',
      FORMAT_HRE_NAME_UL_CBM008.HRA_BEGIN_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_BEGIN_DT',
      FORMAT_HRE_NAME_UL_CBM008.HRA_END_DT length = 8
         format = $8.
         informat = $8.
         label = 'HRA_END_DT',
      FORMAT_HRE_NAME_UL_CBM008.OVERLAP_DAYS length = 8
         label = 'OVERLAP_DAYS',
      FORMAT_HRE_NAME_UL_CBM008.DAYS_IN_REPT length = 8
         label = 'DAYS_IN_REPT',
      FORMAT_HRE_NAME_UL_CBM008.PCT_TIME_A length = 8
         label = 'PCT_TIME_A',
      FORMAT_HRE_NAME_UL_CBM008.PCT_TIME_C length = 8
         label = 'PCT_TIME_C',
      FORMAT_HRE_NAME_UL_CBM008.PCT_TIME_D length = 8
         label = 'PCT_TIME_D',
      FORMAT_HRE_NAME_UL_CBM008.PCT_TIME_E length = 8
         label = 'PCT_TIME_E',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_A length = 8
         label = 'SALARY_A',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_D length = 8
         label = 'SALARY_D',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_X length = 8
         label = 'SALARY_X',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_R length = 8
         label = 'SALARY_R',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_Z length = 8
         label = 'SALARY_Z',
      FORMAT_HRE_NAME_UL_CBM008.DAYS_IN_APPT length = 8
         label = 'DAYS_IN_APPT',
      FORMAT_HRE_NAME_UL_CBM008.ADDL_PAY_ACCT_CD length = 25
         format = $25.
         informat = $25.
         label = 'ADDL_PAY_ACCT_CD',
      FORMAT_HRE_NAME_UL_CBM008.ADDL_PAY_OTH_PAY length = 8
         format = 12.2
         informat = 12.2
         label = 'ADDL_PAY_OTH_PAY',
      FORMAT_HRE_NAME_UL_CBM008.POSITION_NBR length = 8
         format = $8.
         informat = $8.
         label = 'POSITION_NBR',
      FORMAT_HRE_NAME_UL_CBM008.ADDL_CLASS_FLD length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_CLASS_FLD',
      FORMAT_HRE_NAME_UL_CBM008.ADDL_FUND_CODE length = 5
         format = $5.
         informat = $5.
         label = 'ADDL_FUND_CODE',
      FORMAT_HRE_NAME_UL_CBM008.OVLP_ALLOC_REDIS_ADDL length = 8
         label = 'OVLP_ALLOC_REDIS_ADDL',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_A_ADDL length = 8
         label = 'SALARY_A_ADDL',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_D_ADDL length = 8
         label = 'SALARY_D_ADDL',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_X_ADDL length = 8
         label = 'SALARY_X_ADDL',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_R_ADDL length = 8
         label = 'SALARY_R_ADDL',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_Z_ADDL length = 8
         label = 'SALARY_Z_ADDL',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRA_UNIT_CD length = 7
         format = $7.
         informat = $7.
         label = 'UTA_HRA_UNIT_CD',
      FORMAT_HRE_NAME_UL_CBM008.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG',
      FORMAT_HRE_NAME_UL_CBM008.UTA_TT_RANK length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_RANK',
      FORMAT_HRE_NAME_UL_CBM008.UTA_TT_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'UTA_TT_STATUS',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_MAJORTITLE length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRE_MAJORTITLE',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRA_TITLE_CD length = 4
         format = $4.
         informat = $4.
         label = 'UTA_HRA_TITLE_CD',
      FORMAT_HRE_NAME_UL_CBM008.ACAD_ORG_UNITCD length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_ORG_UNITCD',
      FORMAT_HRE_NAME_UL_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      FORMAT_HRE_NAME_UL_CBM008.RANK_CBM length = 8
         label = 'RANK_CBM',
      FORMAT_HRE_NAME_UL_CBM008.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      FORMAT_HRE_NAME_UL_CBM008.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      FORMAT_HRE_NAME_UL_CBM008.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      FORMAT_HRE_NAME_UL_CBM008.ETHNIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_ORIGIN',
      FORMAT_HRE_NAME_UL_CBM008.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      FORMAT_HRE_NAME_UL_CBM008.PERMIT_TYPE_IN_LIST length = 1
         format = $1.
         informat = $1.
         label = 'PERMIT_TYPE_IN_LIST',
      FORMAT_HRE_NAME_UL_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      FORMAT_HRE_NAME_UL_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      FORMAT_HRE_NAME_UL_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      FORMAT_HRE_NAME_UL_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      FORMAT_HRE_NAME_UL_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      FORMAT_HRE_NAME_UL_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      FORMAT_HRE_NAME_UL_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      FORMAT_HRE_NAME_UL_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      FORMAT_HRE_NAME_UL_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      FORMAT_HRE_NAME_UL_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      FORMAT_HRE_NAME_UL_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      FORMAT_HRE_NAME_UL_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      FORMAT_HRE_NAME_UL_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      FORMAT_HRE_NAME_UL_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      FORMAT_HRE_NAME_UL_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      FORMAT_HRE_NAME_UL_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      FORMAT_HRE_NAME_UL_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      FORMAT_HRE_NAME_UL_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      FORMAT_HRE_NAME_UL_CBM008.FACULTY_MEMBER length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_MEMBER',
      FORMAT_HRE_NAME_UL_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      FORMAT_HRE_NAME_UL_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      FORMAT_HRE_NAME_UL_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      FORMAT_HRE_NAME_UL_CBM008.IN_STRM_PREV length = 4
         format = $4.
         informat = $4.
         label = 'STRM_PREV',
      FORMAT_HRE_NAME_UL_CBM008.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      FORMAT_HRE_NAME_UL_CBM008.TERM_END_DT_PREV length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT_PREV',
      FORMAT_HRE_NAME_UL_CBM008.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      FORMAT_HRE_NAME_UL_CBM008.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      FORMAT_HRE_NAME_UL_CBM008.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      FORMAT_HRE_NAME_UL_CBM008.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      FORMAT_HRE_NAME_UL_CBM008.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      FORMAT_HRE_NAME_UL_CBM008.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      FORMAT_HRE_NAME_UL_CBM008.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      FORMAT_HRE_NAME_UL_CBM008.SCTN_COMBINED_ID length = 4
         format = $4.
         informat = $4.
         label = 'SCTN_COMBINED_ID',
      FORMAT_HRE_NAME_UL_CBM008.CB_CLASS_CD length = 2
         format = $2.
         informat = $2.
         label = 'CB_CLASS_CD',
      FORMAT_HRE_NAME_UL_CBM008.CLASS_IN_CMBND length = 8
         label = 'CLASS_IN_CMBND',
      FORMAT_HRE_NAME_UL_CBM008.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      FORMAT_HRE_NAME_UL_CBM008.CRSE_ID_READ_4 length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID_READ_4',
      FORMAT_HRE_NAME_UL_CBM008.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      FORMAT_HRE_NAME_UL_CBM008.CRSE_OFFER_NBR_READ_4 length = 8
         label = 'CRSE_OFFER_NBR_READ_4',
      FORMAT_HRE_NAME_UL_CBM008.CB_EXCLUDE length = 1
         format = $1.
         informat = $1.
         label = 'CB_EXCLUDE',
      FORMAT_HRE_NAME_UL_CBM008.STDNTS_ENROLLED length = 1
         format = $1.
         informat = $1.
         label = 'STDNTS_ENROLLED',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_BIRTH_DATE length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_BIRTH_DATE',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_GENDER length = 1
         format = $1.
         informat = $1.
         label = 'UTA_HRE_GENDER',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_NAME_UL length = 25
         format = $25.
         informat = $25.
         label = 'UTA_HRE_NAME_UL',
      SCAN(FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_NAME_UL,1,',') as LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      STRIP(SCAN(FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_NAME_UL,-1,',')) as FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      SUBSTR(SCAN(STRIP(SCAN(FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_NAME_UL,-1,',')),2,' '),1,1) as MIDDLE_INITIAL length = 1
         format = $1.
         informat = $1.
         label = 'MIDDLE_INITIAL',
      FORMAT_HRE_NAME_UL_CBM008.FACULTY_CLASSIF length = 1
         format = $1.
         informat = $1.
         label = 'FACULTY_CLASSIF',
      FORMAT_HRE_NAME_UL_CBM008.INSTRUCTOR_CLASSIF length = 4
         format = $4.
         informat = $4.
         label = 'INSTRUCTOR_CLASSIF',
      IFC(FORMAT_HRE_NAME_UL_CBM008.CIT_CHK_EMPLID IS MISSING,
      FORMAT_HRE_NAME_UL_CBM008.FACULTY_CLASSIF,
      IFC(FORMAT_HRE_NAME_UL_CBM008.RANK_CBM='0',
      FORMAT_HRE_NAME_UL_CBM008.FACULTY_CLASSIF,
      STRIP(FORMAT_HRE_NAME_UL_CBM008.RANK_CBM))) as RANK length = 1
         format = $1.
         informat = $1.
         label = 'RANK',
      IFC(FORMAT_HRE_NAME_UL_CBM008.CIT_CHK_EMPLID IS MISSING,'0',
      IFC(FORMAT_HRE_NAME_UL_CBM008.UTA_TT_STATUS IN ('NA','ND','NT'),'0',
      IFC(FORMAT_HRE_NAME_UL_CBM008.UTA_TT_STATUS='T','1',
      IFC(FORMAT_HRE_NAME_UL_CBM008.UTA_TT_STATUS='TT','2','0')))) as TENURE length = 1
         format = $1.
         informat = $1.
         label = 'TENURE',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_GENDER as GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      FORMAT_HRE_NAME_UL_CBM008.ACAD_ORG_UNITCD as ADMINISTRATIVE_UNIT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'ADMINISTRATIVE_UNIT_CODE',
      SUBSTR(FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_BIRTH_DATE,1,6) as DATE_OF_BIRTH length = 6
         format = $6.
         informat = $6.
         label = 'DATE_OF_BIRTH',
      FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_CNT_SVC_DT length = 8
         format = $8.
         informat = $8.
         label = 'UTA_HRE_CNT_SVC_DT',
      FORMAT_HRE_NAME_UL_CBM008.INSTR_LOAD_FACTOR length = 8
         format = 12.4
         informat = 12.4
         label = 'INSTR_LOAD_FACTOR',
      '8' as RECORD_CODE length = 1
         format = $1.
         informat = $1.
         label = 'RECORD_CODE',
      '003656' as INSTITUTION_CODE length = 6
         format = $6.
         informat = $6.
         label = 'INSTITUTION_CODE',
      IFC(FORMAT_HRE_NAME_UL_CBM008.INSTR_LOAD_FACTOR IS MISSING |
      FORMAT_HRE_NAME_UL_CBM008.SECTION_NBR IS MISSING,'000',
      PUT(FORMAT_HRE_NAME_UL_CBM008.INSTR_LOAD_FACTOR,Z3.)) as RESPONSIBILITY_FACTOR length = 3
         format = $3.
         informat = $3.
         label = 'RESPONSIBILITY_FACTOR',
      IFC(FORMAT_HRE_NAME_UL_CBM008.UTA_HRE_STATUS='R' &
      FORMAT_HRE_NAME_UL_CBM008.SECTION_NBR IS MISSING,'Y','N') as GRA_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'GRA_FLAG',
      FORMAT_HRE_NAME_UL_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      FORMAT_HRE_NAME_UL_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      FORMAT_HRE_NAME_UL_CBM008.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      FORMAT_HRE_NAME_UL_CBM008.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.FORMAT_HRE_NAME_UL_CBM008 as FORMAT_HRE_NAME_UL_CBM008
   ;
quit;

/*==========================================================================*
 * Step:            CRSE_ID_CHECK                         A5B29B8Q.BZ0005Q4 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   FORMAT_CBM008 - work.FORMAT_CBM008    A5B29B8Q.BS0001V1 *
 *                  PS_CLASS_INSTR_Extract -              A5B29B8Q.BE00002S *
 *                   ADWSTGPR.PS_CLASS_INSTR_Extract                        *
 * Target Table:    Join - work.W8UHB38L                  A5B29B8Q.BS0001V2 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q4);

proc sql;
   create table work.W8UHB38L as
   select distinct
      FORMAT_CBM008.RECORD_CODE length = 1
         format = $1.
         informat = $1.
         label = 'RECORD_CODE',
      FORMAT_CBM008.INSTITUTION_CODE length = 6
         format = $6.
         informat = $6.
         label = 'INSTITUTION_CODE',
      FORMAT_CBM008.SSN as FACULTY_IDENTIFACTION_NUMBER length = 9
         format = $9.
         informat = $9.
         label = 'FACULTY_IDENTIFACTION_NUMBER',
      FORMAT_CBM008.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      FORMAT_CBM008.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      FORMAT_CBM008.MIDDLE_INITIAL length = 1
         format = $1.
         informat = $1.
         label = 'MIDDLE_INITIAL',
      FORMAT_CBM008.RANK length = 1
         format = $1.
         informat = $1.
         label = 'RANK',
      FORMAT_CBM008.TENURE length = 1
         format = $1.
         informat = $1.
         label = 'TENURE',
      FORMAT_CBM008.GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      FORMAT_CBM008.ADMINISTRATIVE_UNIT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'ADMINISTRATIVE_UNIT_CODE',
      "" as UNUSED length = 1
         format = $1.
         informat = $1.
         label = 'UNUSED',
      FORMAT_CBM008.DATE_OF_BIRTH length = 6
         format = $6.
         informat = $6.
         label = 'DATE_OF_BIRTH',
      FORMAT_CBM008.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      FORMAT_CBM008.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      FORMAT_CBM008.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      FORMAT_CBM008.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      FORMAT_CBM008.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      FORMAT_CBM008.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      FORMAT_CBM008.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      FORMAT_CBM008.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      FORMAT_CBM008.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      FORMAT_CBM008.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      FORMAT_CBM008.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      FORMAT_CBM008.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      FORMAT_CBM008.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      FORMAT_CBM008.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      FORMAT_CBM008.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      FORMAT_CBM008.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      FORMAT_CBM008.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      FORMAT_CBM008.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      FORMAT_CBM008.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      FORMAT_CBM008.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      FORMAT_CBM008.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      FORMAT_CBM008.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      FORMAT_CBM008.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      FORMAT_CBM008.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      FORMAT_CBM008.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      FORMAT_CBM008.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      FORMAT_CBM008.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      FORMAT_CBM008.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      FORMAT_CBM008.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      FORMAT_CBM008.CB_CLASS_CD as COMPOSITE_CLASSES length = 2
         format = $2.
         informat = $2.
         label = 'COMPOSITE_CLASSES',
      FORMAT_CBM008.RESPONSIBILITY_FACTOR length = 3
         format = $3.
         informat = $3.
         label = 'RESPONSIBILITY_FACTOR',
      FORMAT_CBM008.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      MAX(IFC(PS_CLASS_INSTR_Extract.CRSE_ID NOT IS MISSING,'Y','N')) as CRSE_ID_FOUND length = 1
         format = $1.
         informat = $1.
         label = 'CRSE_ID_FOUND',
      SUBSTR(FORMAT_CBM008.UTA_HRA_UNIT_CD,1,4) as UNIT_CD_APPT length = 4
         format = $4.
         informat = $4.
         label = 'UNIT_CD_APPT',
      FORMAT_CBM008.GRA_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'GRA_FLAG',
      FORMAT_CBM008.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      FORMAT_CBM008.UTSHARE_FISCAL_YEAR length = 8
         label = 'UTSHARE_FISCAL_YEAR',
      FORMAT_CBM008.UTA_HRE_MAJAPPTSEQ length = 3
         format = $3.
         informat = $3.
         label = 'UTA_HRE_MAJAPPTSEQ',
      FORMAT_CBM008.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      FORMAT_CBM008.UTA_HRA_FISCALYEAR length = 8
         label = 'FISCAL_YEAR',
      FORMAT_CBM008.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      FORMAT_CBM008.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      FORMAT_CBM008.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.FORMAT_CBM008 as FORMAT_CBM008 left join
      ADWSTGPR.PS_CLASS_INSTR_Extract as PS_CLASS_INSTR_Extract
         on
         (
            FORMAT_CBM008.RANK IN ('5','6')
            and PS_CLASS_INSTR_Extract.ASSIGN_TYPE NOT IN ('NON','EXC')
            and FORMAT_CBM008.CIT_CHK_EMPLID = PS_CLASS_INSTR_Extract.EMPLID
            and FORMAT_CBM008.IN_STRM = PS_CLASS_INSTR_Extract.STRM
         )
   where
      FORMAT_CBM008.SUBJECT_PREFIX NOT IS MISSING
      or FORMAT_CBM008.RANK <> '5'
   group by
      FORMAT_CBM008.CIT_CHK_EMPLID,
      FORMAT_CBM008.IN_STRM
   ;
quit;

/*==========================================================================*
 * Step:            UNIT_CD_APPT                          A5B29B8Q.BZ0005Q5 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W8UHB38L                  A5B29B8Q.BS0001V2 *
 *                  PS_UTA_HRA_TBL_Extract -              A5B29B8Q.BE00007I *
 *                   ADWSTGPR.PS_UTA_HRA_TBL_Extract                        *
 * Target Table:    Join - work.W1SIASDZ                  A5B29B8Q.BS0001V3 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q5);

proc sql;
   create view work.W1SIASDZ as
   select
      W8UHB38L.RECORD_CODE length = 1
         format = $1.
         informat = $1.
         label = 'RECORD_CODE',
      W8UHB38L.INSTITUTION_CODE length = 6
         format = $6.
         informat = $6.
         label = 'INSTITUTION_CODE',
      W8UHB38L.FACULTY_IDENTIFACTION_NUMBER length = 9
         format = $9.
         informat = $9.
         label = 'FACULTY_IDENTIFACTION_NUMBER',
      W8UHB38L.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W8UHB38L.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W8UHB38L.MIDDLE_INITIAL length = 1
         format = $1.
         informat = $1.
         label = 'MIDDLE_INITIAL',
      W8UHB38L.RANK length = 1
         format = $1.
         informat = $1.
         label = 'RANK',
      W8UHB38L.TENURE length = 1
         format = $1.
         informat = $1.
         label = 'TENURE',
      W8UHB38L.GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      W8UHB38L.ADMINISTRATIVE_UNIT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'ADMINISTRATIVE_UNIT_CODE',
      W8UHB38L.UNUSED length = 1
         format = $1.
         informat = $1.
         label = 'UNUSED',
      W8UHB38L.DATE_OF_BIRTH length = 6
         format = $6.
         informat = $6.
         label = 'DATE_OF_BIRTH',
      W8UHB38L.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      W8UHB38L.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      W8UHB38L.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      W8UHB38L.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      W8UHB38L.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      W8UHB38L.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      W8UHB38L.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      W8UHB38L.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      W8UHB38L.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      W8UHB38L.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      W8UHB38L.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      W8UHB38L.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      W8UHB38L.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      W8UHB38L.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W8UHB38L.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      W8UHB38L.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      W8UHB38L.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      W8UHB38L.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      W8UHB38L.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W8UHB38L.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      W8UHB38L.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W8UHB38L.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      W8UHB38L.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      W8UHB38L.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      W8UHB38L.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      W8UHB38L.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      W8UHB38L.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      W8UHB38L.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      W8UHB38L.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      W8UHB38L.COMPOSITE_CLASSES length = 2
         format = $2.
         informat = $2.
         label = 'COMPOSITE_CLASSES',
      W8UHB38L.RESPONSIBILITY_FACTOR length = 3
         format = $3.
         informat = $3.
         label = 'RESPONSIBILITY_FACTOR',
      W8UHB38L.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W8UHB38L.CRSE_ID_FOUND length = 1
         format = $1.
         informat = $1.
         label = 'CRSE_ID_FOUND',
      IFC(PS_UTA_HRA_TBL_Extract.UTA_HRA_UNIT_CD NOT IS MISSING,
      SUBSTR(PS_UTA_HRA_TBL_Extract.UTA_HRA_UNIT_CD,1,4),
      W8UHB38L.UNIT_CD_APPT) as UNIT_CD_APPT length = 4
         format = $4.
         informat = $4.
         label = 'UNIT_CD_APPT',
      W8UHB38L.GRA_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'GRA_FLAG',
      W8UHB38L.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W8UHB38L.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W8UHB38L.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      W8UHB38L.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W8UHB38L.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.W8UHB38L as W8UHB38L left join
      ADWSTGPR.PS_UTA_HRA_TBL_Extract as PS_UTA_HRA_TBL_Extract
         on
         (
            W8UHB38L.RANK IN ('5','6')
            and W8UHB38L.ADMINISTRATIVE_UNIT_CODE IS MISSING
            and W8UHB38L.FACULTY_IDENTIFACTION_NUMBER = PS_UTA_HRA_TBL_Extract.SSN
            and W8UHB38L.UTA_HRA_FISCALYEAR = PS_UTA_HRA_TBL_Extract.UTA_HRA_FISCALYEAR
            and INPUT(W8UHB38L.UTA_HRE_MAJAPPTSEQ,BEST8.) = PS_UTA_HRA_TBL_Extract.UTA_HRA_APPT_SEQNR
         )
   ;
quit;

/*==========================================================================*
 * Step:            ADMIN_UNIT_CD                         A5B29B8Q.BZ0005Q6 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ACAD_ORG_MAX_EFFDT_CBM008 -           A5B29B8Q.BS0001TX *
 *                   work.ACAD_ORG_MAX_EFFDT_CBM008                         *
 *                  Join - work.W1SIASDZ                  A5B29B8Q.BS0001V3 *
 * Target Table:    Join - work.W8UP5FE0                  A5B29B8Q.BS0001V4 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q6);

proc sql;
   create table work.W8UP5FE0 as
   select
      W1SIASDZ.RECORD_CODE length = 1
         format = $1.
         informat = $1.
         label = 'RECORD_CODE',
      W1SIASDZ.INSTITUTION_CODE length = 6
         format = $6.
         informat = $6.
         label = 'INSTITUTION_CODE',
      W1SIASDZ.FACULTY_IDENTIFACTION_NUMBER length = 9
         format = $9.
         informat = $9.
         label = 'FACULTY_IDENTIFACTION_NUMBER',
      W1SIASDZ.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W1SIASDZ.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W1SIASDZ.MIDDLE_INITIAL length = 1
         format = $1.
         informat = $1.
         label = 'MIDDLE_INITIAL',
      W1SIASDZ.RANK length = 1
         format = $1.
         informat = $1.
         label = 'RANK',
      W1SIASDZ.TENURE length = 1
         format = $1.
         informat = $1.
         label = 'TENURE',
      W1SIASDZ.GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      IFC(W1SIASDZ.ADMINISTRATIVE_UNIT_CODE IS MISSING,
      STRIP(ACAD_ORG_MAX_EFFDT_CBM008.DESCRSHORT),
      W1SIASDZ.ADMINISTRATIVE_UNIT_CODE) as ADMINISTRATIVE_UNIT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'ADMINISTRATIVE_UNIT_CODE',
      W1SIASDZ.UNUSED length = 1
         format = $1.
         informat = $1.
         label = 'UNUSED',
      W1SIASDZ.DATE_OF_BIRTH length = 6
         format = $6.
         informat = $6.
         label = 'DATE_OF_BIRTH',
      W1SIASDZ.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      W1SIASDZ.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      W1SIASDZ.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      W1SIASDZ.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      W1SIASDZ.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      W1SIASDZ.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      W1SIASDZ.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      W1SIASDZ.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      W1SIASDZ.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      W1SIASDZ.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      W1SIASDZ.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      W1SIASDZ.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      W1SIASDZ.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      W1SIASDZ.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W1SIASDZ.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      W1SIASDZ.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      W1SIASDZ.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      W1SIASDZ.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      W1SIASDZ.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W1SIASDZ.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      W1SIASDZ.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W1SIASDZ.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      W1SIASDZ.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      W1SIASDZ.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      W1SIASDZ.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      W1SIASDZ.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      W1SIASDZ.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      W1SIASDZ.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      W1SIASDZ.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      W1SIASDZ.COMPOSITE_CLASSES length = 2
         format = $2.
         informat = $2.
         label = 'COMPOSITE_CLASSES',
      W1SIASDZ.RESPONSIBILITY_FACTOR length = 3
         format = $3.
         informat = $3.
         label = 'RESPONSIBILITY_FACTOR',
      W1SIASDZ.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W1SIASDZ.CRSE_ID_FOUND length = 1
         format = $1.
         informat = $1.
         label = 'CRSE_ID_FOUND',
      W1SIASDZ.UNIT_CD_APPT length = 4
         format = $4.
         informat = $4.
         label = 'UNIT_CD_APPT',
      W1SIASDZ.GRA_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'GRA_FLAG',
      W1SIASDZ.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W1SIASDZ.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W1SIASDZ.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      W1SIASDZ.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W1SIASDZ.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.W1SIASDZ as W1SIASDZ left join
      work.ACAD_ORG_MAX_EFFDT_CBM008 as ACAD_ORG_MAX_EFFDT_CBM008
         on
         (
            case W1SIASDZ.UNIT_CD_APPT
               when '0216'
                  then 'HONR'
               when '0217'
                  then 'UAC'
               when '0218'
                  then 'URPA'
               when '1100'
                  then 'LART'
               when '1105'
                  then 'ENGL'
               when '1110'
                  then 'ART'
               when '1115'
                  then 'MUSI'
               when '1120'
                  then 'MODL'
               when '1125'
                  then 'POLS'
               when '1130'
                  then 'HIST'
               when '1135'
                  then 'PHIL'
               when '1140'
                  then 'KINE'
               when '1145'
                  then 'ANTH'
               when '1150'
                  then 'COMM'
               when '1155'
                  then 'LING'
               when '1160'
                  then 'WOMS'
               when '1165'
                  then 'THEA'
               when '1170'
                  then 'CRCJ'
               when '1175'
                  then 'MILS'
               when '1185'
                  then 'LART'
               when '1200'
                  then 'SCIE'
               when '1205'
                  then 'BIOL'
               when '1210'
                  then 'CHEM'
               when '1215'
                  then 'GEOL'
               when '1220'
                  then 'MATH'
               when '1225'
                  then 'PHYS'
               when '1230'
                  then 'PSYC'
               when '1300'
                  then 'BUSA'
               when '1305'
                  then 'ACCT'
               when '1310'
                  then 'MARK'
               when '1315'
                  then 'FINA'
               when '1320'
                  then 'INSY'
               when '1325'
                  then 'ECON'
               when '1330'
                  then 'MANA'
               when '1400'
                  then 'ENGR'
               when '1405'
                  then 'CE'
               when '1410'
                  then 'MAE'
               when '1415'
                  then 'EE'
               when '1420'
                  then 'IE'
               when '1425'
                  then 'CSE'
               when '1430'
                  then 'BME'
               when '1435'
                  then 'EE'
               when '1445'
                  then 'MSE'
               when '1500'
                  then 'URPA'
               when '1600'
                  then 'SOCW'
               when '1600'
                  then 'SOCW'
               when '1700'
                  then 'ARCH'
               when '1800'
                  then 'NURS'
               when '1905'
                  then IFC(W1SIASDZ.CIT_CHK_EMPLID='1419050501',
            'LEAD','EDCI')
               when '1910'
                  then 'EDCI'
               when '1915'
                  then 'LEAD'
               when '2000'
                  then 'URPA'
            else ''
            end
            = ACAD_ORG_MAX_EFFDT_CBM008.ACAD_ORG
         )
   where
      W1SIASDZ.ADMINISTRATIVE_UNIT_CODE NOT IS MISSING
      or ACAD_ORG_MAX_EFFDT_CBM008.DESCRSHORT NOT IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005Q7 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W8UP5FE0                  A5B29B8Q.BS0001V4 *
 * Target Table:    Join - work.W6LBJJMD                  A5B29B8Q.BS0001V5 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q7);

%let SYSLAST = %nrquote(work.W8UP5FE0);

proc sql;
   create view work.W6LBJJMD as
   select distinct
      W8UP5FE0.RECORD_CODE length = 1
         format = $1.
         informat = $1.
         label = 'RECORD_CODE',
      W8UP5FE0.INSTITUTION_CODE length = 6
         format = $6.
         informat = $6.
         label = 'INSTITUTION_CODE',
      W8UP5FE0.FACULTY_IDENTIFACTION_NUMBER length = 9
         format = $9.
         informat = $9.
         label = 'FACULTY_IDENTIFACTION_NUMBER',
      W8UP5FE0.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W8UP5FE0.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W8UP5FE0.MIDDLE_INITIAL length = 1
         format = $1.
         informat = $1.
         label = 'MIDDLE_INITIAL',
      W8UP5FE0.RANK length = 1
         format = $1.
         informat = $1.
         label = 'RANK',
      W8UP5FE0.TENURE length = 1
         format = $1.
         informat = $1.
         label = 'TENURE',
      W8UP5FE0.GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      W8UP5FE0.ADMINISTRATIVE_UNIT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'ADMINISTRATIVE_UNIT_CODE',
      W8UP5FE0.UNUSED length = 1
         format = $1.
         informat = $1.
         label = 'UNUSED',
      W8UP5FE0.DATE_OF_BIRTH length = 6
         format = $6.
         informat = $6.
         label = 'DATE_OF_BIRTH',
      W8UP5FE0.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      W8UP5FE0.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      W8UP5FE0.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      W8UP5FE0.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      W8UP5FE0.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      W8UP5FE0.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      W8UP5FE0.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      W8UP5FE0.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      W8UP5FE0.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      W8UP5FE0.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      W8UP5FE0.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      W8UP5FE0.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      W8UP5FE0.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      W8UP5FE0.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W8UP5FE0.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      W8UP5FE0.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      W8UP5FE0.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      W8UP5FE0.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      W8UP5FE0.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W8UP5FE0.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      W8UP5FE0.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W8UP5FE0.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      W8UP5FE0.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      W8UP5FE0.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      W8UP5FE0.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      W8UP5FE0.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      W8UP5FE0.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      W8UP5FE0.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      W8UP5FE0.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      W8UP5FE0.COMPOSITE_CLASSES length = 2
         format = $2.
         informat = $2.
         label = 'COMPOSITE_CLASSES',
      W8UP5FE0.RESPONSIBILITY_FACTOR length = 3
         format = $3.
         informat = $3.
         label = 'RESPONSIBILITY_FACTOR',
      W8UP5FE0.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W8UP5FE0.GRA_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'GRA_FLAG',
      W8UP5FE0.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W8UP5FE0.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W8UP5FE0.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      W8UP5FE0.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W8UP5FE0.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT'
   from
      work.W8UP5FE0 as W8UP5FE0
   ;
quit;

/*==========================================================================*
 * Step:            DEPT_CUR_RECORDS                      A5B29B8Q.BZ0005Q8 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    ADW_DEPT_DIM - ADWTGTPR.ADW_DEPT_DIM  A5B29B8Q.BE000011 *
 * Target Table:    Join - work.W3DAZGQS                  A5B29B8Q.BS0001V6 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q8);

%let SYSLAST = %nrquote(ADWTGTPR.ADW_DEPT_DIM);

proc sql;
   create table work.W3DAZGQS as
   select distinct
      ADW_DEPT_DIM.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      ADW_DEPT_DIM.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      ADW_DEPT_DIM.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      ADW_DEPT_DIM.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      ADW_DEPT_DIM.DEPT_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'DEPT_SHORT_DESCR',
      ADW_DEPT_DIM.DEPT_EFF_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEPT_EFF_DT',
      ADW_DEPT_DIM.COLLEGE_EFF_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'COLLEGE_EFF_DT'
   from
      ADWTGTPR.ADW_DEPT_DIM as ADW_DEPT_DIM
   where
      ADW_DEPT_DIM.CURRENT_ROW_ID = 1
      and ADW_DEPT_DIM.COLLEGE_EFF_FLG = 'A'
      and ADW_DEPT_DIM.DEPT_EFF_FLG = 'A'
   group by
      ADW_DEPT_DIM.DEPT_SHORT_DESCR
   having
      ADW_DEPT_DIM.CURRENT_ROW_ID = MAX(ADW_DEPT_DIM.CURRENT_ROW_ID)
   ;
quit;

/*==========================================================================*
 * Step:            MAX_DEPT_EFFDT                        A5B29B8Q.BZ0005Q9 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W3DAZGQS                  A5B29B8Q.BS0001V6 *
 * Target Table:    Join - work.W43B9EC1                  A5B29B8Q.BS0001V7 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005Q9);

%let SYSLAST = %nrquote(work.W3DAZGQS);

proc sql;
   create table work.W43B9EC1 as
   select distinct
      case when W3DAZGQS.DEPT ='PAD' and W3DAZGQS.DEPT_SHORT_DESCR ='2423'  then 'PAPL'
      else W3DAZGQS.DEPT end as DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W3DAZGQS.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      W3DAZGQS.DEPT_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'DEPT_SHORT_DESCR'
   from
      work.W3DAZGQS as W3DAZGQS
   group by
      W3DAZGQS.DEPT_SHORT_DESCR
   having
      W3DAZGQS.DEPT_EFF_DT = MAX(W3DAZGQS.DEPT_EFF_DT)
   ;
quit;

/*==========================================================================*
 * Step:            MAX_COL_EFFDT                         A5B29B8Q.BZ0005QA *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W3DAZGQS                  A5B29B8Q.BS0001V6 *
 * Target Table:    Join - work.W43AR1E8                  A5B29B8Q.BS0001V8 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005QA);

%let SYSLAST = %nrquote(work.W3DAZGQS);

proc sql;
   create table work.W43AR1E8 as
   select distinct
      W3DAZGQS.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W3DAZGQS.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W3DAZGQS.DEPT_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'DEPT_SHORT_DESCR'
   from
      work.W3DAZGQS as W3DAZGQS
   group by
      W3DAZGQS.DEPT_SHORT_DESCR
   having
      W3DAZGQS.COLLEGE_EFF_DT = MAX(W3DAZGQS.COLLEGE_EFF_DT)
   ;
quit;

/*==========================================================================*
 * Step:            ADDL_FIELDS                           A5B29B8Q.BZ0005QB *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W43B9EC1                  A5B29B8Q.BS0001V7 *
 *                  Join - work.W43AR1E8                  A5B29B8Q.BS0001V8 *
 *                  Join - work.W6LBJJMD                  A5B29B8Q.BS0001V5 *
 *                  ADW_PERSON_DIM -                      A5B29B8Q.BE0000RV *
 *                   ADWTGTPR.ADW_PERSON_DIM                                *
 * Target Table:    Join - work.W1SP4T72                  A5B29B8Q.BS0001V9 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005QB);

proc sql;
   create table work.W1SP4T72 as
   select distinct
      W6LBJJMD.RECORD_CODE length = 1
         format = $1.
         informat = $1.
         label = 'RECORD_CODE',
      W6LBJJMD.INSTITUTION_CODE length = 6
         format = $6.
         informat = $6.
         label = 'INSTITUTION_CODE',
      W6LBJJMD.FACULTY_IDENTIFACTION_NUMBER length = 9
         format = $9.
         informat = $9.
         label = 'FACULTY_IDENTIFACTION_NUMBER',
      W6LBJJMD.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W6LBJJMD.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W6LBJJMD.MIDDLE_INITIAL length = 1
         format = $1.
         informat = $1.
         label = 'MIDDLE_INITIAL',
      W6LBJJMD.RANK length = 1
         format = $1.
         informat = $1.
         label = 'RANK',
      W6LBJJMD.TENURE length = 1
         format = $1.
         informat = $1.
         label = 'TENURE',
      W6LBJJMD.GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      W6LBJJMD.ADMINISTRATIVE_UNIT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'ADMINISTRATIVE_UNIT_CODE',
      W6LBJJMD.UNUSED length = 1
         format = $1.
         informat = $1.
         label = 'UNUSED',
      W6LBJJMD.DATE_OF_BIRTH length = 6
         format = $6.
         informat = $6.
         label = 'DATE_OF_BIRTH',
      W6LBJJMD.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      W6LBJJMD.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      W6LBJJMD.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      W6LBJJMD.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      W6LBJJMD.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      W6LBJJMD.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      W6LBJJMD.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      W6LBJJMD.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      W6LBJJMD.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      W6LBJJMD.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      W6LBJJMD.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      W6LBJJMD.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      W6LBJJMD.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      W6LBJJMD.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W6LBJJMD.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      W6LBJJMD.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      W6LBJJMD.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      W6LBJJMD.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      W6LBJJMD.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W6LBJJMD.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      W6LBJJMD.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W6LBJJMD.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      W6LBJJMD.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      W6LBJJMD.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      W6LBJJMD.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      W6LBJJMD.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      W6LBJJMD.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      W6LBJJMD.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      W6LBJJMD.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      W6LBJJMD.COMPOSITE_CLASSES length = 2
         format = $2.
         informat = $2.
         label = 'COMPOSITE_CLASSES',
      W6LBJJMD.RESPONSIBILITY_FACTOR length = 3
         format = $3.
         informat = $3.
         label = 'RESPONSIBILITY_FACTOR',
      W6LBJJMD.CIT_CHK_EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'CIT_CHK_EMPLID',
      W6LBJJMD.GRA_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'GRA_FLAG',
      W6LBJJMD.IN_STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W6LBJJMD.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W6LBJJMD.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      ADW_PERSON_DIM.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      YEAR(DATEPART(W6LBJJMD.TERM_BEGIN_DT))-
      YEAR(DATEPART(ADW_PERSON_DIM.BIRTH_DT))-
      IFN(MONTH(DATEPART(ADW_PERSON_DIM.BIRTH_DT))>
      MONTH(DATEPART(W6LBJJMD.TERM_BEGIN_DT)) |
      (MONTH(DATEPART(ADW_PERSON_DIM.BIRTH_DT))=
      MONTH(DATEPART(W6LBJJMD.TERM_BEGIN_DT)) &
      DAY(DATEPART(ADW_PERSON_DIM.BIRTH_DT))>
      DAY(DATEPART(W6LBJJMD.TERM_BEGIN_DT))),1,0) as AGE length = 8
         label = 'AGE',
      PUT(YEAR(DATEPART(ADW_PERSON_DIM.BIRTH_DT)),4.) as BIRTH_YEAR length = 4
         format = $4.
         informat = $4.
         label = 'BIRTH_YEAR',
      PUT(MONTH(DATEPART(ADW_PERSON_DIM.BIRTH_DT)),Z2.) as BIRTH_MONTH length = 2
         format = $2.
         informat = $2.
         label = 'BIRTH_MONTH',
      SUM(INPUT(W6LBJJMD.PERCENT_APPOINMENT_01,BEST8.),
      INPUT(W6LBJJMD.PERCENT_APPOINMENT_02,BEST8.))/100 as TEACHING_FTE length = 8
         label = 'TEACHING_FTE',
      SUM(INPUT(W6LBJJMD.PERCENT_APPOINMENT_01,BEST8.),
      INPUT(W6LBJJMD.PERCENT_APPOINMENT_02,BEST8.),
      INPUT(W6LBJJMD.PERCENT_APPOINMENT_11,BEST8.),
      INPUT(W6LBJJMD.PERCENT_APPOINMENT_12,BEST8.),
      INPUT(W6LBJJMD.PERCENT_APPOINMENT_13,BEST8.))/100 as TOTAL_FTE length = 8
         label = 'TOTAL_FTE',
      W43AR1E8.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W43B9EC1.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W43AR1E8.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W43B9EC1.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      IFC(W6LBJJMD.TENURE='0',
      'NON-TENURED FACULTY',
      IFC(W6LBJJMD.TENURE='1',
      'TENURED FACULTY',
      IFC(W6LBJJMD.TENURE='2',
      'ON TENURE TRACK FACULTY',
      'UNKNOWN'))) as TENURE_DESCR length = 25
         format = $25.
         informat = $25.
         label = 'TENURE_DESCR',
      IFC(W6LBJJMD.FLEX_ENTRY='6',
      PUT(INPUT(W6LBJJMD.IN_STRM,BEST8.)-
      IFN(SUBSTR(W6LBJJMD.IN_STRM,4,1)='2',4,3)-
      IFN(W6LBJJMD.IN_STRM='2002',1000,0),4.),
      W6LBJJMD.IN_STRM) as UTA_TERM length = 4
         format = $4.
         informat = $4.
         label = 'UTA_TERM',
      IFC(W6LBJJMD.RACE_INTERNATIONAL='6',
      'INTERNATIONAL',
      IFC(W6LBJJMD.ETHINIC_ORIGIN='1',
      'HISPANIC OR LATINO OF ANY RACE',
      IFC(W6LBJJMD.RACE_AFRICAN_AMERICAN='2',
      'BLACK OF ANY RACE (NON-HISPANIC)',
      IFC(W6LBJJMD.RACE_UNKOWN='7',
      'UNKNOWN OR NOT REPORTED',
      IFC(SUM(
      IFN(W6LBJJMD.RACE_ASIAN NOT IS MISSING,1,0),
      IFN(W6LBJJMD.RACE_HAWAIIN_PACIFIC_ISLANDER NOT IS MISSING,1,0),
      IFN(W6LBJJMD.RACE_AMERICAN_INDIAN NOT IS MISSING,1,0),
      IFN(W6LBJJMD.RACE_WHITE NOT IS MISSING,1,0))>1,
      'MULTIRACIAL',
      IFC(W6LBJJMD.RACE_ASIAN='4','ASIAN ONLY',
      IFC(W6LBJJMD.RACE_AMERICAN_INDIAN='5',
      'AMERICAN INDIAN ONLY',
      IFC(W6LBJJMD.RACE_HAWAIIN_PACIFIC_ISLANDER='8',
      'NATIVE HAWAIIAN ONLY',
      IFC(W6LBJJMD.RACE_WHITE='1','WHITE ONLY',
      'UNKNOWN OR NOT REPORTED'))))))))) as ETHNIC length = 35
         format = $35.
         informat = $35.
         label = 'ETHNIC',
      IFC(W6LBJJMD.RANK='1','PROFESSOR',
      IFC(W6LBJJMD.RANK='2','ASSOCIATE PROFESSOR',
      IFC(W6LBJJMD.RANK='3','ASSISTANT PROFESSOR',
      IFC(W6LBJJMD.RANK='4','INSTRUCTOR',
      IFC(W6LBJJMD.RANK='5','OTHER FACULTY',
      IFC(W6LBJJMD.RANK='6','TEACHING ASSISTANT',
      'UNKNOWN')))))) as RANK_DESCR length = 20
         format = $20.
         informat = $20.
         label = 'RANK_DESCR'
   from
      work.W6LBJJMD as W6LBJJMD inner join
      ADWTGTPR.ADW_PERSON_DIM as ADW_PERSON_DIM
         on
         (
            W6LBJJMD.CIT_CHK_EMPLID = ADW_PERSON_DIM.EMPLID
         ) left join
      work.W43B9EC1 as W43B9EC1
         on
         (
            W6LBJJMD.ADMINISTRATIVE_UNIT_CODE = W43B9EC1.DEPT_SHORT_DESCR
         ) left join
      work.W43AR1E8 as W43AR1E8
         on
         (
            W6LBJJMD.ADMINISTRATIVE_UNIT_CODE = W43AR1E8.DEPT_SHORT_DESCR
         )
   ;
quit;

/*==========================================================================*
 * Step:            FULL_TIME_FLG                         A5B29B8Q.BZ0005QC *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W1SP4T72                  A5B29B8Q.BS0001V9 *
 * Target Table:    Join - work.W42EXO0T                  A5B29B8Q.BS0001VA *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005QC);

%let SYSLAST = %nrquote(work.W1SP4T72);

proc sql;
   create table work.W42EXO0T as
   select
      W1SP4T72.RECORD_CODE length = 1
         format = $1.
         informat = $1.
         label = 'RECORD_CODE',
      W1SP4T72.INSTITUTION_CODE length = 6
         format = $6.
         informat = $6.
         label = 'INSTITUTION_CODE',
      W1SP4T72.FACULTY_IDENTIFACTION_NUMBER length = 9
         format = $9.
         informat = $9.
         label = 'FACULTY_IDENTIFACTION_NUMBER',
      W1SP4T72.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W1SP4T72.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W1SP4T72.MIDDLE_INITIAL length = 1
         format = $1.
         informat = $1.
         label = 'MIDDLE_INITIAL',
      W1SP4T72.RANK length = 1
         format = $1.
         informat = $1.
         label = 'RANK',
      W1SP4T72.TENURE length = 1
         format = $1.
         informat = $1.
         label = 'TENURE',
      W1SP4T72.GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      W1SP4T72.ADMINISTRATIVE_UNIT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'ADMINISTRATIVE_UNIT_CODE',
      W1SP4T72.UNUSED length = 1
         format = $1.
         informat = $1.
         label = 'UNUSED',
      W1SP4T72.DATE_OF_BIRTH length = 6
         format = $6.
         informat = $6.
         label = 'DATE_OF_BIRTH',
      W1SP4T72.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      W1SP4T72.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      W1SP4T72.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      W1SP4T72.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      W1SP4T72.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      W1SP4T72.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      W1SP4T72.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      W1SP4T72.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      W1SP4T72.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      W1SP4T72.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      W1SP4T72.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      W1SP4T72.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      W1SP4T72.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      W1SP4T72.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W1SP4T72.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      W1SP4T72.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      W1SP4T72.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      W1SP4T72.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      W1SP4T72.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W1SP4T72.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      W1SP4T72.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W1SP4T72.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      W1SP4T72.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      W1SP4T72.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      W1SP4T72.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      W1SP4T72.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      W1SP4T72.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      W1SP4T72.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      W1SP4T72.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      W1SP4T72.COMPOSITE_CLASSES length = 2
         format = $2.
         informat = $2.
         label = 'COMPOSITE_CLASSES',
      W1SP4T72.RESPONSIBILITY_FACTOR length = 3
         format = $3.
         informat = $3.
         label = 'RESPONSIBILITY_FACTOR',
      W1SP4T72.CIT_CHK_EMPLID as EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W1SP4T72.GRA_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'GRA_FLAG',
      W1SP4T72.IN_STRM as STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W1SP4T72.SOURCE length = 5
         format = $5.
         informat = $5.
         label = 'SOURCE',
      W1SP4T72.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      W1SP4T72.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      W1SP4T72.AGE length = 8
         label = 'AGE',
      W1SP4T72.BIRTH_YEAR length = 4
         format = $4.
         informat = $4.
         label = 'BIRTH_YEAR',
      W1SP4T72.BIRTH_MONTH length = 2
         format = $2.
         informat = $2.
         label = 'BIRTH_MONTH',
      W1SP4T72.TEACHING_FTE length = 8
         label = 'TEACHING_FTE',
      W1SP4T72.TOTAL_FTE length = 8
         label = 'TOTAL_FTE',
      W1SP4T72.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W1SP4T72.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W1SP4T72.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W1SP4T72.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      W1SP4T72.TENURE_DESCR length = 25
         format = $25.
         informat = $25.
         label = 'TENURE_DESCR',
      W1SP4T72.UTA_TERM length = 4
         format = $4.
         informat = $4.
         label = 'UTA_TERM',
      IFC(W1SP4T72.TOTAL_FTE>.95,'Y','N') as FULL_TIME_FLG length = 1
         format = $1.
         informat = $1.
         label = 'FULL_TIME_FLG',
      W1SP4T72.ETHNIC as ETHNIC_DESCR length = 35
         format = $35.
         informat = $35.
         label = 'ETHNIC_DESCR',
      W1SP4T72.RANK_DESCR length = 20
         format = $20.
         informat = $20.
         label = 'RANK_DESCR'
   from
      work.W1SP4T72 as W1SP4T72
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005QD *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W42EXO0T                  A5B29B8Q.BS0001VA *
 * Target Table:    Join - work.WAA1I0P                   A5B29B8Q.BS0001VB *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005QD);

%let SYSLAST = %nrquote(work.W42EXO0T);

proc sql;
   create table work.WAA1I0P as
   select distinct
      W42EXO0T.RECORD_CODE length = 1
         format = $1.
         informat = $1.
         label = 'RECORD_CODE',
      W42EXO0T.INSTITUTION_CODE length = 6
         format = $6.
         informat = $6.
         label = 'INSTITUTION_CODE',
      W42EXO0T.FACULTY_IDENTIFACTION_NUMBER as National_ID length = 9
         format = $9.
         informat = $9.
         label = 'National_ID',
      W42EXO0T.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W42EXO0T.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W42EXO0T.MIDDLE_INITIAL length = 1
         format = $1.
         informat = $1.
         label = 'MIDDLE_INITIAL',
      W42EXO0T.RANK length = 1
         format = $1.
         informat = $1.
         label = 'RANK',
      W42EXO0T.TENURE length = 1
         format = $1.
         informat = $1.
         label = 'TENURE',
      W42EXO0T.GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      W42EXO0T.ADMINISTRATIVE_UNIT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'ADMINISTRATIVE_UNIT_CODE',
      W42EXO0T.UNUSED length = 1
         format = $1.
         informat = $1.
         label = 'UNUSED',
      W42EXO0T.DATE_OF_BIRTH length = 6
         format = $6.
         informat = $6.
         label = 'DATE_OF_BIRTH',
      W42EXO0T.PERCENT_APPOINMENT_01 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_01',
      W42EXO0T.PERCENT_APPOINMENT_02 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_02',
      W42EXO0T.PERCENT_APPOINMENT_11 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_11',
      W42EXO0T.PERCENT_APPOINMENT_12 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_12',
      W42EXO0T.PERCENT_APPOINMENT_13 length = 3
         format = $3.
         informat = $3.
         label = 'PERCENT_APPOINMENT_13',
      W42EXO0T.SALARY_STATE length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_STATE',
      W42EXO0T.SALARY_DESIGNATED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_DESIGNATED',
      W42EXO0T.SALARY_RESTRICTED length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_RESTRICTED',
      W42EXO0T.SALARY_AUX length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_AUX',
      W42EXO0T.SALARY_OVERLOAD length = 6
         format = $6.
         informat = $6.
         label = 'SALARY_OVERLOAD',
      W42EXO0T.FE_APPOINTMENT length = 3
         format = $3.
         informat = $3.
         label = 'FE_APPOINTMENT',
      W42EXO0T.FE_SALARY length = 6
         format = $6.
         informat = $6.
         label = 'FE_SALARY',
      W42EXO0T.FLEX_ENTRY length = 1
         format = $1.
         informat = $1.
         label = 'FLEX_ENTRY',
      W42EXO0T.COMPLIANCE length = 1
         format = $1.
         informat = $1.
         label = 'COMPLIANCE',
      W42EXO0T.NEW_HIRE length = 1
         format = $1.
         informat = $1.
         label = 'NEW_HIRE',
      W42EXO0T.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      W42EXO0T.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      W42EXO0T.ETHINIC_ORIGIN length = 1
         format = $1.
         informat = $1.
         label = 'ETHINIC_ORIGIN',
      W42EXO0T.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W42EXO0T.RACE_AFRICAN_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AFRICAN_AMERICAN',
      W42EXO0T.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W42EXO0T.RACE_AMERICAN_INDIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_AMERICAN_INDIAN',
      W42EXO0T.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      W42EXO0T.RACE_UNKOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKOWN',
      W42EXO0T.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
         format = $1.
         informat = $1.
         label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
      W42EXO0T.SUBJECT_PREFIX length = 7
         format = $7.
         informat = $7.
         label = 'SUBJECT_PREFIX',
      W42EXO0T.COURSE_NUMBER length = 7
         format = $7.
         informat = $7.
         label = 'COURSE_NUMBER',
      W42EXO0T.SECTION_NBR length = 7
         format = $7.
         informat = $7.
         label = 'SECTION_NBR',
      W42EXO0T.TEACHING_LOAD_CREDIT length = 3
         format = $3.
         informat = $3.
         label = 'TEACHING_LOAD_CREDIT',
      W42EXO0T.COMPOSITE_CLASSES length = 2
         format = $2.
         informat = $2.
         label = 'COMPOSITE_CLASSES',
      W42EXO0T.RESPONSIBILITY_FACTOR length = 3
         format = $3.
         informat = $3.
         label = 'RESPONSIBILITY_FACTOR',
      W42EXO0T.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W42EXO0T.GRA_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'GRA_FLAG',
      W42EXO0T.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W42EXO0T.AGE length = 8
         label = 'AGE',
      W42EXO0T.BIRTH_YEAR length = 4
         format = $4.
         informat = $4.
         label = 'BIRTH_YEAR',
      W42EXO0T.BIRTH_MONTH length = 2
         format = $2.
         informat = $2.
         label = 'BIRTH_MONTH',
      W42EXO0T.TEACHING_FTE length = 8
         label = 'TEACHING_FTE',
      W42EXO0T.TOTAL_FTE length = 8
         label = 'TOTAL_FTE',
      W42EXO0T.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W42EXO0T.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W42EXO0T.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W42EXO0T.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      W42EXO0T.TENURE_DESCR length = 25
         format = $25.
         informat = $25.
         label = 'TENURE_DESCR',
      W42EXO0T.UTA_TERM length = 4
         format = $4.
         informat = $4.
         label = 'UTA_TERM',
      W42EXO0T.FULL_TIME_FLG length = 1
         format = $1.
         informat = $1.
         label = 'FULL_TIME_FLG',
      W42EXO0T.ETHNIC_DESCR length = 35
         format = $35.
         informat = $35.
         label = 'ETHNIC_DESCR',
      W42EXO0T.RANK_DESCR length = 20
         format = $20.
         informat = $20.
         label = 'RANK_DESCR'
   from
      work.W42EXO0T as W42EXO0T
   where
      (SUM(INPUT(W42EXO0T.PERCENT_APPOINMENT_01, BEST12.),
      INPUT(W42EXO0T.PERCENT_APPOINMENT_02, BEST12.),
      INPUT(W42EXO0T.PERCENT_APPOINMENT_11, BEST12.),
      INPUT(W42EXO0T.PERCENT_APPOINMENT_12, BEST12.),
      INPUT(W42EXO0T.PERCENT_APPOINMENT_13, BEST12.),
      INPUT(W42EXO0T.FE_APPOINTMENT, BEST12.)
      ) > 0
      or SUM(INPUT(W42EXO0T.SALARY_STATE, BEST12.),
      INPUT(W42EXO0T.SALARY_DESIGNATED, BEST12.),
      INPUT(W42EXO0T.SALARY_RESTRICTED, BEST12.),
      INPUT(W42EXO0T.SALARY_AUX, BEST12.),
      INPUT(W42EXO0T.SALARY_OVERLOAD, BEST12.),
      INPUT(W42EXO0T.FE_SALARY, BEST12.)
      ) > 0
      or W42EXO0T.SECTION_NBR is not missing
      or W42EXO0T.RANK <> '6')
   ;
quit;

/*==========================================================================*
 * Step:            Table Loader                          A5B29B8Q.BZ0005QE *
 * Transform:       Table Loader (Version 2.1)                              *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WAA1I0P                   A5B29B8Q.BS0001VB *
 * Target Table:    ADW_CBM008_WORK -                     A5B29B8Q.BE000176 *
 *                   ADWTGTPR.ADW_CBM008_WORK                               *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005QE);

%let SYSLAST = %nrquote(work.WAA1I0P);

/* --------------------------------------------------------------
   Load Technique Selection: Replace - Truncate
   Constraint and index action selections: 'ASIS','ASIS','ASIS','ASIS'
   Additional options selections...
      Set unmapped to missing on updates: false
   -------------------------------------------------------------- */
%macro etls_loader;


   /* Determine if the target table exists  */
         %sysfunc(exist(ADWTGTPR.ADW_CBM008_WORK, VIEW)));

   /*---- Create a new table  ----*/
   %if (&etls_tableExist eq 0) %then
   %do;  /* if table does not exist  */

      %put %str(NOTE: Creating table ...);

      data ADWTGTPR.ADW_CBM008_WORK
              (dbnull = (
                         RECORD_CODE = YES
                         INSTITUTION_CODE = YES
                         National_ID = YES
                         LAST_NAME = YES
                         FIRST_NAME = YES
                         MIDDLE_INITIAL = YES
                         RANK = YES
                         TENURE = YES
                         GENDER = YES
                         ADMINISTRATIVE_UNIT_CODE = YES
                         UNUSED = YES
                         DATE_OF_BIRTH = YES
                         PERCENT_APPOINMENT_01 = YES
                         PERCENT_APPOINMENT_02 = YES
                         PERCENT_APPOINMENT_11 = YES
                         PERCENT_APPOINMENT_12 = YES
                         PERCENT_APPOINMENT_13 = YES
                         SALARY_STATE = YES
                         SALARY_DESIGNATED = YES
                         SALARY_RESTRICTED = YES
                         SALARY_AUX = YES
                         SALARY_OVERLOAD = YES
                         FE_APPOINTMENT = YES
                         FE_SALARY = YES
                         FLEX_ENTRY = YES
                         COMPLIANCE = YES
                         NEW_HIRE = YES
                         SEMESTER = YES
                         YEAR = YES
                         ETHINIC_ORIGIN = YES
                         RACE_WHITE = YES
                         RACE_AFRICAN_AMERICAN = YES
                         RACE_ASIAN = YES
                         RACE_AMERICAN_INDIAN = YES
                         RACE_INTERNATIONAL = YES
                         RACE_UNKOWN = YES
                         RACE_HAWAIIN_PACIFIC_ISLANDER = YES
                         SUBJECT_PREFIX = YES
                         COURSE_NUMBER = YES
                         SECTION_NBR = YES
                         TEACHING_LOAD_CREDIT = YES
                         COMPOSITE_CLASSES = YES
                         RESPONSIBILITY_FACTOR = YES
                         EMPLID = YES
                         GRA_FLAG = YES
                         STRM = YES
                         AGE = YES
                         BIRTH_YEAR = YES
                         BIRTH_MONTH = YES
                         TEACHING_FTE = YES
                         TOTAL_FTE = YES
                         COLLEGE = YES
                         DEPT = YES
                         COLLEGE_DESCR = YES
                         DEPT_DESCR = YES
                         TENURE_DESCR = YES
                         UTA_TERM = YES
                         FULL_TIME_FLG = YES
                         ETHNIC_DESCR = YES
                         RANK_DESCR = YES));
         attrib RECORD_CODE length = $1
            format = $1.
            informat = $1.
            label = 'RECORD_CODE';
         attrib INSTITUTION_CODE length = $6
            format = $6.
            informat = $6.
            label = 'INSTITUTION_CODE';
         attrib National_ID length = $9
            format = $9.
            informat = $9.
            label = 'National_ID';
         attrib LAST_NAME length = $30
            format = $30.
            informat = $30.
            label = 'LAST_NAME';
         attrib FIRST_NAME length = $30
            format = $30.
            informat = $30.
            label = 'FIRST_NAME';
         attrib MIDDLE_INITIAL length = $1
            format = $1.
            informat = $1.
            label = 'MIDDLE_INITIAL';
         attrib RANK length = $1
            format = $1.
            informat = $1.
            label = 'RANK';
         attrib TENURE length = $1
            format = $1.
            informat = $1.
            label = 'TENURE';
         attrib GENDER length = $1
            format = $1.
            informat = $1.
            label = 'GENDER';
         attrib ADMINISTRATIVE_UNIT_CODE length = $4
            format = $4.
            informat = $4.
            label = 'ADMINISTRATIVE_UNIT_CODE';
         attrib UNUSED length = $1
            format = $1.
            informat = $1.
            label = 'UNUSED';
         attrib DATE_OF_BIRTH length = $6
            format = $6.
            informat = $6.
            label = 'DATE_OF_BIRTH';
         attrib PERCENT_APPOINMENT_01 length = $3
            format = $3.
            informat = $3.
            label = 'PERCENT_APPOINMENT_01';
         attrib PERCENT_APPOINMENT_02 length = $3
            format = $3.
            informat = $3.
            label = 'PERCENT_APPOINMENT_02';
         attrib PERCENT_APPOINMENT_11 length = $3
            format = $3.
            informat = $3.
            label = 'PERCENT_APPOINMENT_11';
         attrib PERCENT_APPOINMENT_12 length = $3
            format = $3.
            informat = $3.
            label = 'PERCENT_APPOINMENT_12';
         attrib PERCENT_APPOINMENT_13 length = $3
            format = $3.
            informat = $3.
            label = 'PERCENT_APPOINMENT_13';
         attrib SALARY_STATE length = $6
            format = $6.
            informat = $6.
            label = 'SALARY_STATE';
         attrib SALARY_DESIGNATED length = $6
            format = $6.
            informat = $6.
            label = 'SALARY_DESIGNATED';
         attrib SALARY_RESTRICTED length = $6
            format = $6.
            informat = $6.
            label = 'SALARY_RESTRICTED';
         attrib SALARY_AUX length = $6
            format = $6.
            informat = $6.
            label = 'SALARY_AUX';
         attrib SALARY_OVERLOAD length = $6
            format = $6.
            informat = $6.
            label = 'SALARY_OVERLOAD';
         attrib FE_APPOINTMENT length = $3
            format = $3.
            informat = $3.
            label = 'FE_APPOINTMENT';
         attrib FE_SALARY length = $6
            format = $6.
            informat = $6.
            label = 'FE_SALARY';
         attrib FLEX_ENTRY length = $1
            format = $1.
            informat = $1.
            label = 'FLEX_ENTRY';
         attrib COMPLIANCE length = $1
            format = $1.
            informat = $1.
            label = 'COMPLIANCE';
         attrib NEW_HIRE length = $1
            format = $1.
            informat = $1.
            label = 'NEW_HIRE';
         attrib SEMESTER length = $1
            format = $1.
            informat = $1.
            label = 'SEMESTER';
         attrib YEAR length = $4
            format = $4.
            informat = $4.
            label = 'YEAR';
         attrib ETHINIC_ORIGIN length = $1
            format = $1.
            informat = $1.
            label = 'ETHINIC_ORIGIN';
         attrib RACE_WHITE length = $1
            format = $1.
            informat = $1.
            label = 'RACE_WHITE';
         attrib RACE_AFRICAN_AMERICAN length = $1
            format = $1.
            informat = $1.
            label = 'RACE_AFRICAN_AMERICAN';
         attrib RACE_ASIAN length = $1
            format = $1.
            informat = $1.
            label = 'RACE_ASIAN';
         attrib RACE_AMERICAN_INDIAN length = $1
            format = $1.
            informat = $1.
            label = 'RACE_AMERICAN_INDIAN';
         attrib RACE_INTERNATIONAL length = $1
            format = $1.
            informat = $1.
            label = 'RACE_INTERNATIONAL';
         attrib RACE_UNKOWN length = $1
            format = $1.
            informat = $1.
            label = 'RACE_UNKOWN';
         attrib RACE_HAWAIIN_PACIFIC_ISLANDER length = $1
            format = $1.
            informat = $1.
            label = 'RACE_HAWAIIN_PACIFIC_ISLANDER';
         attrib SUBJECT_PREFIX length = $7
            format = $7.
            informat = $7.
            label = 'SUBJECT_PREFIX';
         attrib COURSE_NUMBER length = $7
            format = $7.
            informat = $7.
            label = 'COURSE_NUMBER';
         attrib SECTION_NBR length = $7
            format = $7.
            informat = $7.
            label = 'SECTION_NBR';
         attrib TEACHING_LOAD_CREDIT length = $3
            format = $3.
            informat = $3.
            label = 'TEACHING_LOAD_CREDIT';
         attrib COMPOSITE_CLASSES length = $2
            format = $2.
            informat = $2.
            label = 'COMPOSITE_CLASSES';
         attrib RESPONSIBILITY_FACTOR length = $3
            format = $3.
            informat = $3.
            label = 'RESPONSIBILITY_FACTOR';
         attrib EMPLID length = $11
            format = $11.
            informat = $11.
            label = 'EMPLID';
         attrib GRA_FLAG length = $1
            format = $1.
            informat = $1.
            label = 'GRA_FLAG';
         attrib STRM length = $4
            format = $4.
            informat = $4.
            label = 'STRM';
         attrib AGE length = 8
            label = 'AGE';
         attrib BIRTH_YEAR length = $4
            format = $4.
            informat = $4.
            label = 'BIRTH_YEAR';
         attrib BIRTH_MONTH length = $2
            format = $2.
            informat = $2.
            label = 'BIRTH_MONTH';
         attrib TEACHING_FTE length = 8
            label = 'TEACHING_FTE';
         attrib TOTAL_FTE length = 8
            label = 'TOTAL_FTE';
         attrib COLLEGE length = $5
            format = $5.
            informat = $5.
            label = 'COLLEGE';
         attrib DEPT length = $10
            format = $10.
            informat = $10.
            label = 'DEPT';
         attrib COLLEGE_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'COLLEGE_DESCR';
         attrib DEPT_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'DEPT_DESCR';
         attrib TENURE_DESCR length = $25
            format = $25.
            informat = $25.
            label = 'TENURE_DESCR';
         attrib UTA_TERM length = $4
            format = $4.
            informat = $4.
            label = 'UTA_TERM';
         attrib FULL_TIME_FLG length = $1
            format = $1.
            informat = $1.
            label = 'FULL_TIME_FLG';
         attrib ETHNIC_DESCR length = $35
            format = $35.
            informat = $35.
            label = 'ETHNIC_DESCR';
         attrib RANK_DESCR length = $20
            format = $20.
            informat = $20.
            label = 'RANK_DESCR';
         call missing(of _all_);
         stop;
      run;


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
            truncate table ADWTGTPRD.ADW_CBM008_WORK
         ) by ORACLE;

         %rcSet(&sqlrc);

         disconnect from ORACLE;
      quit;


   %end; /* table exists */

   /*---- Append  ----*/
   %put %str(NOTE: Appending data ...);

   proc append base = ADWTGTPR.ADW_CBM008_WORK
      data = &etls_lastTable (&etls_tableOptions)  force ;
    run;


%mend etls_loader;
%etls_loader;

/*==========================================================================*
 * Step:            Loop                                  A5B29B8Q.BZ0005QF *
 * Transform:       Loop                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    USER_INPUT_STRM_CBM008 -              A5B29B8Q.BS0001SA *
 *                   work.USER_INPUT_STRM_CBM008                            *
 * Target Table:    Loop - work.W1C82E7I                  A5B29B8Q.BS0001VC *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005QF);

%let SYSLAST = %nrquote(work.USER_INPUT_STRM_CBM008);

%macro etls_loopW2CG3AYC;
   %local etls_filePrefix;
   %let etls_filePrefix = ;

   %macro etls_processToLoopW2CG3AYM(parameterTable=, row=, handleName=rmt);
      %local etls_parmvars;
      %etls_getParameterNames(parameterTable=&parameterTable,
         parameterVariableMacro=etls_parmvars,
         startingColumnNumber=1);
      %local &etls_parmvars;
      %etls_getParameters(parameterTable=&parameterTable, row=&row,
         startingColumnNumber=1);
      %let etls_previousFilePrefix = &etls_filePrefix;
      %local etls_filePrefix;
      %let etls_filePrefix = &etls_previousFilePrefix.&handleName;
      %macro etls_jobW2CG3AYW;

         /*==========================================================================*
          * Step:            Join                                  A5B29B8Q.BZ0005QG *
          * Transform:       Join                                                    *
          * Description:                                                             *
          *                                                                          *
          * Source Table:    ADW_CBM008_WORK -                     A5B29B8Q.BE000176 *
          *                   ADWTGTPR.ADW_CBM008_WORK                               *
          * Target Table:    Join - work.W1BSOVXN                  A5B29B8Q.BS0001VD *
          *==========================================================================*/

         %let transformID = %quote(A5B29B8Q.BZ0005QG);

         %let SYSLAST = %nrquote(ADWTGTPR.ADW_CBM008_WORK);



         proc sql;
            create table work.W1BSOVXN as
            select
               ADW_CBM008_WORK.RECORD_CODE length = 1
                  format = $1.
                  informat = $1.
                  label = 'RECORD_CODE',
               ADW_CBM008_WORK.INSTITUTION_CODE length = 6
                  format = $6.
                  informat = $6.
                  label = 'INSTITUTION_CODE',
               ADW_CBM008_WORK.National_ID length = 9
                  format = $9.
                  informat = $9.
                  label = 'National_ID',
               SUBSTR(STRIP(ADW_CBM008_WORK.LAST_NAME),1,10) as LAST_NAME length = 10
                  format = $10.
                  informat = $10.
                  label = 'LAST_NAME',
               SUBSTR(STRIP(ADW_CBM008_WORK.FIRST_NAME),1,1) as FIRST_NAME length = 1
                  format = $1.
                  informat = $1.
                  label = 'FIRST_NAME',
               ADW_CBM008_WORK.MIDDLE_INITIAL length = 1
                  format = $1.
                  informat = $1.
                  label = 'MIDDLE_INITIAL',
               ADW_CBM008_WORK.RANK length = 1
                  format = $1.
                  informat = $1.
                  label = 'RANK',
               ADW_CBM008_WORK.TENURE length = 1
                  format = $1.
                  informat = $1.
                  label = 'TENURE',
               ADW_CBM008_WORK.GENDER length = 1
                  format = $1.
                  informat = $1.
                  label = 'GENDER',
               ADW_CBM008_WORK.ADMINISTRATIVE_UNIT_CODE length = 4
                  format = $4.
                  informat = $4.
                  label = 'ADMINISTRATIVE_UNIT_CODE',
               ADW_CBM008_WORK.UNUSED length = 1
                  format = $1.
                  informat = $1.
                  label = 'UNUSED',
               ADW_CBM008_WORK.DATE_OF_BIRTH length = 6
                  format = $6.
                  informat = $6.
                  label = 'DATE_OF_BIRTH',
               ADW_CBM008_WORK.PERCENT_APPOINMENT_01 length = 3
                  format = $3.
                  informat = $3.
                  label = 'PERCENT_APPOINMENT_01',
               ADW_CBM008_WORK.PERCENT_APPOINMENT_02 length = 3
                  format = $3.
                  informat = $3.
                  label = 'PERCENT_APPOINMENT_02',
               ADW_CBM008_WORK.PERCENT_APPOINMENT_11 length = 3
                  format = $3.
                  informat = $3.
                  label = 'PERCENT_APPOINMENT_11',
               ADW_CBM008_WORK.PERCENT_APPOINMENT_12 length = 3
                  format = $3.
                  informat = $3.
                  label = 'PERCENT_APPOINMENT_12',
               ADW_CBM008_WORK.PERCENT_APPOINMENT_13 length = 3
                  format = $3.
                  informat = $3.
                  label = 'PERCENT_APPOINMENT_13',
               ADW_CBM008_WORK.SALARY_STATE length = 6
                  format = $6.
                  informat = $6.
                  label = 'SALARY_STATE',
               ADW_CBM008_WORK.SALARY_DESIGNATED length = 6
                  format = $6.
                  informat = $6.
                  label = 'SALARY_DESIGNATED',
               ADW_CBM008_WORK.SALARY_RESTRICTED length = 6
                  format = $6.
                  informat = $6.
                  label = 'SALARY_RESTRICTED',
               ADW_CBM008_WORK.SALARY_AUX length = 6
                  format = $6.
                  informat = $6.
                  label = 'SALARY_AUX',
               ADW_CBM008_WORK.SALARY_OVERLOAD length = 6
                  format = $6.
                  informat = $6.
                  label = 'SALARY_OVERLOAD',
               ADW_CBM008_WORK.FE_APPOINTMENT length = 3
                  format = $3.
                  informat = $3.
                  label = 'FE_APPOINTMENT',
               ADW_CBM008_WORK.FE_SALARY length = 6
                  format = $6.
                  informat = $6.
                  label = 'FE_SALARY',
               ADW_CBM008_WORK.FLEX_ENTRY length = 1
                  format = $1.
                  informat = $1.
                  label = 'FLEX_ENTRY',
               ADW_CBM008_WORK.COMPLIANCE length = 1
                  format = $1.
                  informat = $1.
                  label = 'COMPLIANCE',
               ADW_CBM008_WORK.NEW_HIRE length = 1
                  format = $1.
                  informat = $1.
                  label = 'NEW_HIRE',
               ADW_CBM008_WORK.SEMESTER length = 1
                  format = $1.
                  informat = $1.
                  label = 'SEMESTER',
               ADW_CBM008_WORK.YEAR length = 4
                  format = $4.
                  informat = $4.
                  label = 'YEAR',
               ADW_CBM008_WORK.ETHINIC_ORIGIN length = 1
                  format = $1.
                  informat = $1.
                  label = 'ETHINIC_ORIGIN',
               ADW_CBM008_WORK.RACE_WHITE length = 1
                  format = $1.
                  informat = $1.
                  label = 'RACE_WHITE',
               ADW_CBM008_WORK.RACE_AFRICAN_AMERICAN length = 1
                  format = $1.
                  informat = $1.
                  label = 'RACE_AFRICAN_AMERICAN',
               ADW_CBM008_WORK.RACE_ASIAN length = 1
                  format = $1.
                  informat = $1.
                  label = 'RACE_ASIAN',
               ADW_CBM008_WORK.RACE_AMERICAN_INDIAN length = 1
                  format = $1.
                  informat = $1.
                  label = 'RACE_AMERICAN_INDIAN',
               ADW_CBM008_WORK.RACE_INTERNATIONAL length = 1
                  format = $1.
                  informat = $1.
                  label = 'RACE_INTERNATIONAL',
               ADW_CBM008_WORK.RACE_UNKOWN length = 1
                  format = $1.
                  informat = $1.
                  label = 'RACE_UNKOWN',
               ADW_CBM008_WORK.RACE_HAWAIIN_PACIFIC_ISLANDER length = 1
                  format = $1.
                  informat = $1.
                  label = 'RACE_HAWAIIN_PACIFIC_ISLANDER',
               ADW_CBM008_WORK.SUBJECT_PREFIX length = 7
                  format = $7.
                  informat = $7.
                  label = 'SUBJECT_PREFIX',
               ADW_CBM008_WORK.COURSE_NUMBER length = 7
                  format = $7.
                  informat = $7.
                  label = 'COURSE_NUMBER',
               ADW_CBM008_WORK.SECTION_NBR length = 7
                  format = $7.
                  informat = $7.
                  label = 'SECTION_NBR',
               ADW_CBM008_WORK.TEACHING_LOAD_CREDIT length = 3
                  format = $3.
                  informat = $3.
                  label = 'TEACHING_LOAD_CREDIT',
               ADW_CBM008_WORK.COMPOSITE_CLASSES length = 2
                  format = $2.
                  informat = $2.
                  label = 'COMPOSITE_CLASSES',
               ADW_CBM008_WORK.RESPONSIBILITY_FACTOR length = 3
                  format = $3.
                  informat = $3.
                  label = 'RESPONSIBILITY_FACTOR'
            from
               ADWTGTPR.ADW_CBM008_WORK as ADW_CBM008_WORK
            where
               IFC(ADW_CBM008_WORK.YEAR<'2000','0',
               SUBSTR(ADW_CBM008_WORK.YEAR,1,1)) ||
               SUBSTR(ADW_CBM008_WORK.YEAR,3,2) ||
               IFC(ADW_CBM008_WORK.SEMESTER='1','8',
               IFC(ADW_CBM008_WORK.SEMESTER='3','5',
               ADW_CBM008_WORK.SEMESTER)) = "&CBM008OutputTerm."
            ;
         quit;







         /*==========================================================================*
          * Step:            File Writer                           A5B29B8Q.BZ0005QH *
          * Transform:       File Writer                                             *
          * Description:                                                             *
          *                                                                          *
          * Source Table:    Join - work.W1BSOVXN                  A5B29B8Q.BS0001VD *
          * Target Table:    ADW_CBM008_WORK -                     A5B29B8Q.BV000016 *
          *                   &CBM008OutputFileLoc.                                  *
          *==========================================================================*/

         %let transformID = %quote(A5B29B8Q.BZ0005QH);

         %let SYSLAST = %nrquote(work.W1BSOVXN);


         %let ETLS_SYSLAST = &SYSLAST;

         %let CBM008OutputFileLoc =/sasdata/Data/CBM/CBM008/CBM008_&CBM008OutputTerm._&sysdate9..txt;
         data _null_;
            set &SYSLAST;
            file "&CBM008OutputFileLoc." ;
            if _n_=1 then put 'HY2K003656CBM008' @@ semester $1. @@ year $4. @@ 'C0141JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU';
         run;


         %let SYSLAST = &ETLS_SYSLAST;

         data _null_;
            set &SYSLAST;
               attrib RECORD_CODE length = $1
                  format = $1.
                  informat = $1.;
               attrib INSTITUTION_CODE length = $6
                  format = $6.
                  informat = $6.;
               attrib National_ID length = $9
                  format = $9.
                  informat = $9.;
               attrib LAST_NAME length = $10
                  format = $10.
                  informat = $10.;
               attrib FIRST_NAME length = $1
                  format = $1.
                  informat = $1.;
               attrib MIDDLE_INITIAL length = $1
                  format = $1.
                  informat = $1.;
               attrib RANK length = $1
                  format = $1.
                  informat = $1.;
               attrib TENURE length = $1
                  format = $1.
                  informat = $1.;
               attrib GENDER length = $1
                  format = $1.
                  informat = $1.;
               attrib ADMINISTRATIVE_UNIT_CODE length = $4
                  format = $4.
                  informat = $4.;
               attrib UNUSED length = $1
                  format = $1.
                  informat = $1.;
               attrib DATE_OF_BIRTH length = $6
                  format = $6.
                  informat = $6.;
               attrib PERCENT_APPOINMENT_01 length = $3
                  format = $3.
                  informat = $3.;
               attrib PERCENT_APPOINMENT_02 length = $3
                  format = $3.
                  informat = $3.;
               attrib PERCENT_APPOINMENT_11 length = $3
                  format = $3.
                  informat = $3.;
               attrib PERCENT_APPOINMENT_12 length = $3
                  format = $3.
                  informat = $3.;
               attrib PERCENT_APPOINMENT_13 length = $3
                  format = $3.
                  informat = $3.;
               attrib SALARY_STATE length = $6
                  format = $6.
                  informat = $6.;
               attrib SALARY_DESIGNATED length = $6
                  format = $6.
                  informat = $6.;
               attrib SALARY_RESTRICTED length = $6
                  format = $6.
                  informat = $6.;
               attrib SALARY_AUX length = $6
                  format = $6.
                  informat = $6.;
               attrib SALARY_OVERLOAD length = $6
                  format = $6.
                  informat = $6.;
               attrib FE_APPOINTMENT length = $3
                  format = $3.
                  informat = $3.;
               attrib FE_SALARY length = $6
                  format = $6.
                  informat = $6.;
               attrib FLEX_ENTRY length = $1
                  format = $1.
                  informat = $1.;
               attrib COMPLIANCE length = $1
                  format = $1.
                  informat = $1.;
               attrib NEW_HIRE length = $1
                  format = $1.
                  informat = $1.;
               attrib SEMESTER length = $1
                  format = $1.
                  informat = $1.;
               attrib YEAR length = $4
                  format = $4.
                  informat = $4.;
               attrib ETHINIC_ORIGIN length = $1
                  format = $1.
                  informat = $1.;
               attrib RACE_WHITE length = $1
                  format = $1.
                  informat = $1.;
               attrib RACE_AFRICAN_AMERICAN length = $1
                  format = $1.
                  informat = $1.;
               attrib RACE_ASIAN length = $1
                  format = $1.
                  informat = $1.;
               attrib RACE_AMERICAN_INDIAN length = $1
                  format = $1.
                  informat = $1.;
               attrib RACE_INTERNATIONAL length = $1
                  format = $1.
                  informat = $1.;
               attrib RACE_UNKOWN length = $1
                  format = $1.
                  informat = $1.;
               attrib RACE_HAWAIIN_PACIFIC_ISLANDER length = $1
                  format = $1.
                  informat = $1.;
               attrib SUBJECT_PREFIX length = $7
                  format = $7.
                  informat = $7.;
               attrib COURSE_NUMBER length = $7
                  format = $7.
                  informat = $7.;
               attrib SECTION_NBR length = $7
                  format = $7.
                  informat = $7.;
               attrib TEACHING_LOAD_CREDIT length = $3
                  format = $3.
                  informat = $3.;
               attrib COMPOSITE_CLASSES length = $2
                  format = $2.
                  informat = $2.;
               attrib RESPONSIBILITY_FACTOR length = $3
                  format = $3.
                  informat = $3.;
               file "&CBM008OutputFileLoc." MOD;

                  put
                      @ 1 RECORD_CODE $1.
                      @ 2 INSTITUTION_CODE $6.
                      @ 8 National_ID $9.
                      @ 17 LAST_NAME $10.
                      @ 27 FIRST_NAME $1.
                      @ 28 MIDDLE_INITIAL $1.
                      @ 29 RANK $1.
                      @ 30 TENURE $1.
                      @ 31 GENDER $1.
                      @ 32 ADMINISTRATIVE_UNIT_CODE $4.
                      @ 36 UNUSED $1.
                      @ 37 DATE_OF_BIRTH $6.
                      @ 43 PERCENT_APPOINMENT_01 $3.
                      @ 46 PERCENT_APPOINMENT_02 $3.
                      @ 49 PERCENT_APPOINMENT_11 $3.
                      @ 52 PERCENT_APPOINMENT_12 $3.
                      @ 55 PERCENT_APPOINMENT_13 $3.
                      @ 58 SALARY_STATE $6.
                      @ 64 SALARY_DESIGNATED $6.
                      @ 70 SALARY_RESTRICTED $6.
                      @ 76 SALARY_AUX $6.
                      @ 82 SALARY_OVERLOAD $6.
                      @ 88 FE_APPOINTMENT $3.
                      @ 91 FE_SALARY $6.
                      @ 97 FLEX_ENTRY $1.
                      @ 98 COMPLIANCE $1.
                      @ 99 NEW_HIRE $1.
                      @ 100 SEMESTER $1.
                      @ 101 YEAR $4.
                      @ 105 ETHINIC_ORIGIN $1.
                      @ 106 RACE_WHITE $1.
                      @ 107 RACE_AFRICAN_AMERICAN $1.
                      @ 108 RACE_ASIAN $1.
                      @ 109 RACE_AMERICAN_INDIAN $1.
                      @ 110 RACE_INTERNATIONAL $1.
                      @ 111 RACE_UNKOWN $1.
                      @ 112 RACE_HAWAIIN_PACIFIC_ISLANDER $1.
                      @ 113 SUBJECT_PREFIX $7.
                      @ 120 COURSE_NUMBER $7.
                      @ 127 SECTION_NBR $7.
                      @ 134 TEACHING_LOAD_CREDIT $3.
                      @ 137 COMPOSITE_CLASSES $2.
                      @ 139 RESPONSIBILITY_FACTOR $3.
                  ;

         run;



         data _null_;
            set &SYSLAST END=EOF;
            file "&CBM008OutputFileLoc." mod;
            if eof then put @1 'EOF1' @@ _N_ z5. @@;
         run;






      %mend etls_jobW2CG3AYW;

      %etls_jobW2CG3AYW;

      %let handleName = %etls_getHandle(statusTable=&etls_statusTable,
         handleVariable=etls_handleName, row=&&&etls_controlName);

      %let job_rc&handleName. = &job_rc;

      %etls_freeHandle(statusTable=&etls_statusTable, statusVariable=etls_status,
         handleVariable=etls_handleName, handleName="&handleName",
         startTimeVariable=etls_startTime, endTimeVariable=etls_endTime, signoff=0,
         returnCodeVariable=etls_jobRC, returnCodeMacroVariable=job_rc&handleName., setMainJobRc=1);

   %mend etls_processToLoopW2CG3AYM;

   %local etls_controlTable etls_statusTable etls_controlName
      etls_processesRunning etls_maxProcesses etls_parameterTable
      etls_additionalSignonOptions etls_signonRetries;
   %let etls_controlName = L37_;
   %let etls_statusTable = work.W1C82E7I;
   %let etls_parameterTable = work.W2CG3AZ8;
   %let &etls_controlName = 0;
   %let etls_controlTable = work.USER_INPUT_STRM_CBM008;

   %put %str(NOTE: Creating status table...);
   data &etls_statusTable
      (keep = etls_handleName etls_machineId etls_startTime etls_endTime etls_status
              etls_jobRC
      );
      attrib etls_handleName length = $32
         label = 'Name of handle to remote session';
      attrib etls_machineId length = $32
         label = 'Name of machine executing the task';
      attrib etls_startTime length = 8
         format = nldatmap.
         label = 'Start time of task';
      attrib etls_endTime length = 8
         format = nldatmap.
         label = 'End time of task';
      attrib etls_status length = $32
         label = 'Current status of task';
      attrib etls_jobRC length = 8
         label = 'Return code of task';
      set &etls_controlTable;
   run;


   %put %str(NOTE: Creating parameter table...);
   proc sql;
      create table &etls_parameterTable as
         select STRM as CBM008OutputTerm
         from &etls_controlTable;
   quit;


   /* Get the number of times to iterate from the number of rows in the source  */
   /*  table                                                                    */
   proc sql noprint;
      select count(*) into :&etls_controlName._max from &etls_statusTable;
      %let &etls_controlName._max = &&&etls_controlName._max;
   quit;


   %let etls_maxProcesses = 1;

   %if (&etls_maxProcesses > 0) %then
   %do;
      %do %until (&&&etls_controlName ge &&&etls_controlName._max);

         %let etls_lastLoopPtr = &&&etls_controlName;

         %let etls_processesRunning = 0;

         %do %while(&etls_processesRunning lt &&&etls_controlName._max
            and &etls_processesRunning lt &etls_maxProcesses
            and &&&etls_controlName lt &&&etls_controlName._max);

            %let &etls_controlName = %eval(&&&etls_controlName+1);

            %let job_rcLast=&job_rc;

            %etls_createHandle(statusTable=&etls_statusTable,
                               statusVariable=etls_status,
                               handleVariable=etls_handleName,
                               handlePrefix=&etls_controlName,
                               statusSetting="Running",
                               row=&&&etls_controlName,
                               machineVariable=etls_machineId,
                               startTimeVariable=etls_startTime,
                               signon=0,
                               useGrid=0);

         %let etls_processesRunning = 1;
         %etls_processToLoopW2CG3AYM(parameterTable=&etls_parameterTable, row=&&&etls_controlName,
            handleName=%etls_getHandle(statusTable=&etls_statusTable,
            handleVariable=etls_handleName, row=&&&etls_controlName));

         /* Reset main Job_RC and Trans_RC to max return code of all iterations */
         %let job_rcThisIter=&job_rc;
         %let job_rc=&job_rcLast;
         %let trans_rc=&job_rcLast;
      %end;

   %end;

%end;

%mend etls_loopW2CG3AYC;

%etls_loopW2CG3AYC;

/*==========================================================================*
 * Step:            Loop End                              A5B29B8Q.BZ0005QI *
 * Transform:       Loop End                                                *
 * Description:                                                             *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ0005QI);

/* Statistics macros for loop transformation  */
