/*---- Start of User Written Code  ----*/

/*2218*/
%Let term = '2248';
%Let prev_year='2238';
%Let summerterm = '2245';
%Let fromDate = '01-AUG-2024:00:00:00'dt;
%Let toDate = '15-OCT-2024:00:00:00'dt;
%let year='2024';


/*2188
%Let term = '2188';
%Let prev_year='2178';
%Let summerterm = '2185';
%Let fromDate = '01-AUG-2018:00:00:00'dt;
%Let toDate = '15-OCT-2018:00:00:00'dt;
*/

/*2182
%Let fromDate = '01-JAN-2018:00:00:00'dt;
%Let toDate = '31-MAR-2018:00:00:00'dt;
*/
/*2178
%Let fromDate = '01-AUG-2017:00:00:00'dt;
%Let toDate = '15-OCT-2017:00:00:00'dt;
*/
/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000C2C *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_DIVERS_ETHNIC_Extract -            A5B29B8Q.BE00003A *
 *                   ADWSTGPR.PS_DIVERS_ETHNIC_Extract                      *
 * Target Table:    Join - work.WGOILE9H                  A5B29B8Q.BS0004CV *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2C);

%let SYSLAST = %nrquote(ADWSTGPR.PS_DIVERS_ETHNIC_Extract);

proc sql;
   create table work.WGOILE9H as
   select distinct
      PS_DIVERS_ETHNIC_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      IFC(MAX(IFN(PS_DIVERS_ETHNIC_Extract.ETHNIC_GRP_CD='HISPA', 1, 0, 0))=1, 'HISPA', MAX(PS_DIVERS_ETHNIC_Extract.ETHNIC_GRP_CD), '') as ETHNIC_GRP_CD length = 8
         format = $8.
         informat = $8.
         label = 'ETHNIC_GRP_CD',
      PS_DIVERS_ETHNIC_Extract.SETID length = 5
         format = $5.
         informat = $5.
         label = 'SETID',
      COUNT(PS_DIVERS_ETHNIC_Extract.ETHNIC_GRP_CD) as ENTRY_COUNT length = 8
         label = 'ENTRY_COUNT'
   from
      ADWSTGPR.PS_DIVERS_ETHNIC_Extract as PS_DIVERS_ETHNIC_Extract
   group by
      PS_DIVERS_ETHNIC_Extract.EMPLID
   ;
quit;

/*==========================================================================*
 * Step:            ETHNICITY                             A5B29B8Q.BZ000C2D *
 * Transform:       Join                                                    *
 * Description:     same as CBM001                                          *
 *                                                                          *
 * Source Tables:   Join - work.WGOILE9H                  A5B29B8Q.BS0004CV *
 *                  ADW_ETHNICITY_DIM -                   A5B29B8Q.BE0000RR *
 *                   ADWTGTDV.ADW_ETHNICITY_DIM                             *
 * Target Table:    Join - work.WGOILF3S                  A5B29B8Q.BS0004CW *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2D);

proc sql;
   create table work.WGOILF3S as
   select
      WGOILE9H.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WGOILE9H.ETHNIC_GRP_CD length = 8
         format = $8.
         informat = $8.
         label = 'ETHNIC_GRP_CD',
      WGOILE9H.SETID length = 5
         format = $5.
         informat = $5.
         label = 'SETID',
      WGOILE9H.ENTRY_COUNT length = 8
         label = 'ENTRY_COUNT',
      IFC(ADW_ETHNICITY_DIM.ETHNICGROUPCODE = '3', 'HISPANIC',
      	IFC(WGOILE9H.ENTRY_COUNT > 1, 'MULTIPLE', WGOILE9H.ETHNIC_GRP_CD, ''),
      '') as ETHN_GRP length = 11
         format = $11.
         informat = $11.
         label = 'ETHN_GRP'
   from
      work.WGOILE9H as WGOILE9H left join
      ADWTGTDV.ADW_ETHNICITY_DIM as ADW_ETHNICITY_DIM
         on
         (
            WGOILE9H.ETHNIC_GRP_CD = ADW_ETHNICITY_DIM.ETHNIC_GRP_CD
            and WGOILE9H.SETID = ADW_ETHNICITY_DIM.SETID
            and ADW_ETHNICITY_DIM.CURRENT_ROW_IND = 1
         )
   ;
quit;

/*==========================================================================*
 * Step:            max(effdt)                            A5B29B8Q.BZ000C2E *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J *
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          *
 * Target Table:    Join - work.WD2GW1BY                  A5B29B8Q.BS0004CX *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2E);

%let SYSLAST = %nrquote(ADWSTGPR.PS_ACAD_PROG_Extract);

proc sql;
   create view work.WD2GW1BY as
   select distinct
      PS_ACAD_PROG_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ACAD_PROG_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_ACAD_PROG_Extract.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      PS_ACAD_PROG_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ACAD_PROG_Extract.EFFSEQ length = 8
         label = 'EFFSEQ',
      PS_ACAD_PROG_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_ACAD_PROG_Extract.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      PS_ACAD_PROG_Extract.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      PS_ACAD_PROG_Extract.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      PS_ACAD_PROG_Extract.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      PS_ACAD_PROG_Extract.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      PS_ACAD_PROG_Extract.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      PS_ACAD_PROG_Extract.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      PS_ACAD_PROG_Extract.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      PS_ACAD_PROG_Extract.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      PS_ACAD_PROG_Extract.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      PS_ACAD_PROG_Extract.DEGR_CHKOUT_STAT length = 2
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      PS_ACAD_PROG_Extract.COMPLETION_TERM length = 4
         format = $4.
         informat = $4.
         label = 'COMPLETION_TERM',
      PS_ACAD_PROG_Extract.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      PS_ACAD_PROG_Extract.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      PS_ACAD_PROG_Extract.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      PS_ACAD_PROG_Extract.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      PS_ACAD_PROG_Extract.DATA_FROM_ADM_APPL length = 1
         format = $1.
         informat = $1.
         label = 'DATA_FROM_ADM_APPL',
      PS_ACAD_PROG_Extract.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      PS_ACAD_PROG_Extract.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      PS_ACAD_PROG_Extract.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      PS_ACAD_PROG_Extract.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      PS_ACAD_PROG_Extract.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      PS_ACAD_PROG_Extract.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      PS_ACAD_PROG_Extract.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      PS_ACAD_PROG_Extract.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      PS_ACAD_PROG_Extract.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      PS_ACAD_PROG_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ACAD_PROG_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_ACAD_PROG_Extract as PS_ACAD_PROG_Extract
   where
      PS_ACAD_PROG_Extract.EFFDT <= &todate.
   group by
      PS_ACAD_PROG_Extract.EMPLID,
      PS_ACAD_PROG_Extract.ACAD_CAREER,
      PS_ACAD_PROG_Extract.STDNT_CAR_NBR
   having
      PS_ACAD_PROG_Extract.EFFDT = max(PS_ACAD_PROG_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            max(effseq)                           A5B29B8Q.BZ000C2F *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WD2GW1BY                  A5B29B8Q.BS0004CX *
 * Target Table:    Ps_Acad_Prog_Extract -                A5B29B8Q.BS0004CY *
 *                   work.Ps_Acad_Prog_Extract                              *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2F);

%let SYSLAST = %nrquote(work.WD2GW1BY);

proc sql;
   create table work.Ps_Acad_Prog_Extract as
   select distinct
      WD2GW1BY.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WD2GW1BY.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WD2GW1BY.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      WD2GW1BY.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      WD2GW1BY.EFFSEQ length = 8
         label = 'EFFSEQ',
      WD2GW1BY.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      WD2GW1BY.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      WD2GW1BY.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      WD2GW1BY.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      WD2GW1BY.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      WD2GW1BY.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      WD2GW1BY.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WD2GW1BY.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      WD2GW1BY.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      WD2GW1BY.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      WD2GW1BY.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      WD2GW1BY.DEGR_CHKOUT_STAT length = 2
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      WD2GW1BY.COMPLETION_TERM length = 4
         format = $4.
         informat = $4.
         label = 'COMPLETION_TERM',
      WD2GW1BY.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      WD2GW1BY.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      WD2GW1BY.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      WD2GW1BY.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      WD2GW1BY.DATA_FROM_ADM_APPL length = 1
         format = $1.
         informat = $1.
         label = 'DATA_FROM_ADM_APPL',
      WD2GW1BY.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      WD2GW1BY.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      WD2GW1BY.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      WD2GW1BY.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      WD2GW1BY.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      WD2GW1BY.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      WD2GW1BY.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      WD2GW1BY.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      WD2GW1BY.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      WD2GW1BY.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      WD2GW1BY.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      work.WD2GW1BY as WD2GW1BY
   group by
      WD2GW1BY.EFFDT,
      WD2GW1BY.STDNT_CAR_NBR,
      WD2GW1BY.ACAD_CAREER,
      WD2GW1BY.EMPLID
   having
      WD2GW1BY.EFFSEQ = max(WD2GW1BY.EFFSEQ)
   ;
quit;

/*==========================================================================*
 * Step:            max(effdt)                            A5B29B8Q.BZ000C2G *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    ADW_APPL_DETAIL_FACT -                A5B29B8Q.BE0000S7 *
 *                   ADWTGTPR.ADW_APPL_DETAIL_FACT                          *
 * Target Table:    Join - work.WEC2WE5P                  A5B29B8Q.BS0004CZ *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2G);

%let SYSLAST = %nrquote(ADWTGTPR.ADW_APPL_DETAIL_FACT);

proc sql;
   create table work.WEC2WE5P as
   select
      ADW_APPL_DETAIL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_APPL_DETAIL_FACT.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      ADW_APPL_DETAIL_FACT.ADM_APPL_NBR length = 8
         label = 'ADM_APPL_NBR',
      ADW_APPL_DETAIL_FACT.FIN_AID_INTEREST length = 1
         format = $1.
         informat = $1.
         label = 'FIN_AID_INTEREST',
      ADW_APPL_DETAIL_FACT.HOUSING_INTEREST length = 1
         format = $1.
         informat = $1.
         label = 'HOUSING_INTEREST',
      ADW_APPL_DETAIL_FACT.APPL_FEE_STATUS length = 3
         format = $3.
         informat = $3.
         label = 'APPL_FEE_STATUS',
      ADW_APPL_DETAIL_FACT.APPL_FEE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'APPL_FEE_DT',
      ADW_APPL_DETAIL_FACT.ADM_CREATION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_CREATION_DT',
      ADW_APPL_DETAIL_FACT.ADM_UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_UPDATED_DT',
      ADW_APPL_DETAIL_FACT.ADM_APPL_COMPLETE length = 1
         format = $1.
         informat = $1.
         label = 'ADM_APPL_COMPLETE',
      max(ADW_APPL_DETAIL_FACT.ADM_APPL_DT) as ADM_APPL_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_APPL_DT',
      ADW_APPL_DETAIL_FACT.ADM_APPL_CMPLT_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_APPL_CMPLT_DT',
      ADW_APPL_DETAIL_FACT.GRADUATION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'GRADUATION_DT',
      ADW_APPL_DETAIL_FACT.PRIOR_APPL length = 1
         format = $1.
         informat = $1.
         label = 'PRIOR_APPL',
      ADW_APPL_DETAIL_FACT.APPL_FEE_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'APPL_FEE_TYPE',
      ADW_APPL_DETAIL_FACT.ADM_APPL_METHOD length = 3
         format = $3.
         informat = $3.
         label = 'ADM_APPL_METHOD',
      ADW_APPL_DETAIL_FACT.ACADEMIC_LEVEL length = 3
         format = $3.
         informat = $3.
         label = 'ACADEMIC_LEVEL',
      ADW_APPL_DETAIL_FACT.STUDENT_CAR_NBR length = 8
         label = 'STUDENT_CAR_NBR',
      ADW_APPL_DETAIL_FACT.REGION length = 10
         format = $10.
         informat = $10.
         label = 'REGION',
      ADW_APPL_DETAIL_FACT.REGION_FROM length = 1
         format = $1.
         informat = $1.
         label = 'REGION_FROM',
      ADW_APPL_DETAIL_FACT.RECRUITER_ID length = 11
         format = $11.
         informat = $11.
         label = 'RECRUITER_ID',
      ADW_APPL_DETAIL_FACT.LAST_SCH_ATTEND length = 11
         format = $11.
         informat = $11.
         label = 'LAST_SCH_ATTEND',
      ADW_APPL_DETAIL_FACT.EXT_ADM_APPL_NBR length = 15
         format = $15.
         informat = $15.
         label = 'EXT_ADM_APPL_NBR',
      ADW_APPL_DETAIL_FACT.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      ADW_APPL_DETAIL_FACT.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      ADW_APPL_DETAIL_FACT.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      ADW_APPL_DETAIL_FACT.EXT_ORG_SK length = 8
         label = 'EXT_ORG_SK',
      ADW_APPL_DETAIL_FACT.PROG_ACTION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'PROG_ACTION_DESCR',
      ADW_APPL_DETAIL_FACT.PROG_REASON_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'PROG_REASON_DESCR',
      ADW_APPL_DETAIL_FACT.PROG_STATUS_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'PROG_STATUS_DESCR',
      ADW_APPL_DETAIL_FACT.ACAD_PROGRAM_SK length = 8
         label = 'ACAD_PROGRAM_SK',
      ADW_APPL_DETAIL_FACT.ACAD_PLAN_SK length = 8
         label = 'ACAD_PLAN_SK',
      ADW_APPL_DETAIL_FACT.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      ADW_APPL_DETAIL_FACT.DEPT_SK length = 8
         label = 'DEPT_SK',
      ADW_APPL_DETAIL_FACT.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_APPL_DETAIL_FACT.ADMIT_TYPE_SK length = 8
         label = 'ADMIT_TYPE_SK',
      ADW_APPL_DETAIL_FACT.YLD_APPL length = 8
         label = 'YLD_APPL',
      ADW_APPL_DETAIL_FACT.YLD_ADMIT length = 8
         label = 'YLD_ADMIT',
      ADW_APPL_DETAIL_FACT.YLD_MATRICULATED length = 8
         label = 'YLD_MATRICULATED',
      ADW_APPL_DETAIL_FACT.YLD_WITHDRAWN length = 8
         label = 'YLD_WITHDRAWN',
      ADW_APPL_DETAIL_FACT.YLD_WITHDRAWN_BEFORE_DECSN length = 8
         label = 'YLD_WITHDRAWN_BEFORE_DECSN',
      ADW_APPL_DETAIL_FACT.YLD_WITHDRAWN_AFTER_DECSN length = 8
         label = 'YLD_WITHDRAWN_AFTER_DECSN',
      ADW_APPL_DETAIL_FACT.YLD_DENIED length = 8
         label = 'YLD_DENIED',
      ADW_APPL_DETAIL_FACT.YLD_ENROLLED length = 8
         label = 'YLD_ENROLLED',
      ADW_APPL_DETAIL_FACT.LAST_SCH_TRNSFR_HRS length = 8
         label = 'LAST_SCH_TRNSFR_HRS',
      ADW_APPL_DETAIL_FACT.LAST_SCH_TRNSFR_GRADE_PNTS length = 8
         label = 'LAST_SCH_TRNSFR_GRADE_PNTS',
      ADW_APPL_DETAIL_FACT.LAST_SCH_TRNSFR_GPA length = 8
         label = 'LAST_SCH_TRNSFR_GPA',
      ADW_APPL_DETAIL_FACT.LAST_SCH_CUM_TRNSFR_HRS length = 8
         label = 'LAST_SCH_CUM_TRNSFR_HRS',
      ADW_APPL_DETAIL_FACT.LAST_SCH_CUM_TRNSFR_GRADE_PNTS length = 8
         label = 'LAST_SCH_CUM_TRNSFR_GRADE_PNTS',
      ADW_APPL_DETAIL_FACT.LAST_SCH_CUML_TRNSFR_GPA length = 8
         label = 'LAST_SCH_CUML_TRNSFR_GPA',
      ADW_APPL_DETAIL_FACT.LAST_SCH_HS_PCNTL length = 8
         label = 'LAST_SCH_HS_PCNTL',
      ADW_APPL_DETAIL_FACT.UGRAD_GPA_FOR_GRADUATES length = 8
         label = 'UGRAD_GPA_FOR_GRADUATES',
      ADW_APPL_DETAIL_FACT.SAT_MATH_SCORE length = 8
         label = 'SAT_MATH_SCORE',
      ADW_APPL_DETAIL_FACT.SAT_VERBAL_SCORE length = 8
         label = 'SAT_VERBAL_SCORE',
      ADW_APPL_DETAIL_FACT.SAT_TOTAL_SCORE length = 8
         label = 'SAT_TOTAL_SCORE',
      ADW_APPL_DETAIL_FACT.ACT_COMPOSITE_SCORE length = 8
         label = 'ACT_COMPOSITE_SCORE',
      ADW_APPL_DETAIL_FACT.GRE_VERBAL_RSNG_SCORE length = 8
         label = 'GRE_VERBAL_RSNG_SCORE',
      ADW_APPL_DETAIL_FACT.GRE_VERBAL_RSNG_SCORE_PCNTL length = 8
         label = 'GRE_VERBAL_RSNG_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GRE_QUANT_RSNG_SCORE length = 8
         label = 'GRE_QUANT_RSNG_SCORE',
      ADW_APPL_DETAIL_FACT.GRE_QUANT_RSNG_SCORE_PCNTL length = 8
         label = 'GRE_QUANT_RSNG_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GRE_WRITING_RSNG_SCORE length = 8
         label = 'GRE_WRITING_RSNG_SCORE',
      ADW_APPL_DETAIL_FACT.GRE_ANALY_WRITING_SCORE_PCNTL length = 8
         label = 'GRE_ANALY_WRITING_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GRE_VERBAL_REVISED_SCORE length = 8
         label = 'GRE_VERBAL_REVISED_SCORE',
      ADW_APPL_DETAIL_FACT.GRE_VERBAL_REVISED_SCORE_PCNTL length = 8
         label = 'GRE_VERBAL_REVISED_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GRE_QUANT_REVISED_SCORE length = 8
         label = 'GRE_QUANT_REVISED_SCORE',
      ADW_APPL_DETAIL_FACT.GRE_QUANT_REVISED_SCORE_PCNTL length = 8
         label = 'GRE_QUANT_REVISED_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GMAT_QUANT_RSNG_SCORE length = 8
         label = 'GMAT_QUANT_RSNG_SCORE',
      ADW_APPL_DETAIL_FACT.GMAT_QNTATVE_RSNG_SCORE_PCNTL length = 8
         label = 'GMAT_QNTATVE_RSNG_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GMAT_VERBAL_RSNG_SCORE length = 8
         label = 'GMAT_VERBAL_RSNG_SCORE',
      ADW_APPL_DETAIL_FACT.GMAT_VERBAL_RSNG_SCORE_PCNTL length = 8
         label = 'GMAT_VERBAL_RSNG_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GMAT_INTGD_RSNG_SCORE length = 8
         label = 'GMAT_INTGD_RSNG_SCORE',
      ADW_APPL_DETAIL_FACT.GMAT_INTGD_RSNG_SCORE_PCNTL length = 8
         label = 'GMAT_INTGD_RSNG_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GMAT_ANALY_SCORE length = 8
         label = 'GMAT_ANALY_SCORE',
      ADW_APPL_DETAIL_FACT.GMAT_ANALY_SCORE_PCNTL length = 8
         label = 'GMAT_ANALY_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.GMAT_TOTAL_SCORE length = 8
         label = 'GMAT_TOTAL_SCORE',
      ADW_APPL_DETAIL_FACT.GMAT_TOTAL_SCORE_PCNTL length = 8
         label = 'GMAT_TOTAL_SCORE_PCNTL',
      ADW_APPL_DETAIL_FACT.UPDATE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATE_DT',
      ADW_APPL_DETAIL_FACT.UPDATE_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATE_USER',
      ADW_APPL_DETAIL_FACT.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      ADW_APPL_DETAIL_FACT.TOEFL_COMP_BASED_SCORE length = 8
         label = 'TOEFL_COMP_BASED_SCORE',
      ADW_APPL_DETAIL_FACT.TOEFL_IBT_LISTENING_SCORE length = 8
         label = 'TOEFL_IBT_LISTENING_SCORE',
      ADW_APPL_DETAIL_FACT.TOEFL_IBT_READING_SCORE length = 8
         label = 'TOEFL_IBT_READING_SCORE',
      ADW_APPL_DETAIL_FACT.TOEFL_IBT_SPEAKING_SCORE length = 8
         label = 'TOEFL_IBT_SPEAKING_SCORE',
      ADW_APPL_DETAIL_FACT.TOEFL_IBT_WRITING_SCORE length = 8
         label = 'TOEFL_IBT_WRITING_SCORE',
      ADW_APPL_DETAIL_FACT.IELTS_OVERALL_SCORE length = 8
         label = 'IELTS_OVERALL_SCORE',
      ADW_APPL_DETAIL_FACT.IELTS_SPEAKING_SCORE length = 8
         label = 'IELTS_SPEAKING_SCORE'
   from
      ADWTGTPR.ADW_APPL_DETAIL_FACT as ADW_APPL_DETAIL_FACT
   where
      ADW_APPL_DETAIL_FACT.ADM_APPL_DT <= &todate.
   group by
      ADW_APPL_DETAIL_FACT.EMPLID,
      ADW_APPL_DETAIL_FACT.ACAD_CAREER_SK
   having
      ADW_APPL_DETAIL_FACT.ADM_APPL_DT = max(ADW_APPL_DETAIL_FACT.ADM_APPL_DT)
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000C2H *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    ADW_COURSE_OFFER_DIM -                A5B29B8Q.BE0000RO *
 *                   ADWTGTPR.ADW_COURSE_OFFER_DIM                          *
 * Target Table:    Join - work.W415A91P                  A5B29B8Q.BS0004D0 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2H);

%let SYSLAST = %nrquote(ADWTGTPR.ADW_COURSE_OFFER_DIM);

proc sql;
   create table work.W415A91P as
   select
      ADW_COURSE_OFFER_DIM.COURSE_OFFER_SK length = 8
         label = 'COURSE_OFFER_SK',
      ADW_COURSE_OFFER_DIM.COURSE_IDENTIFIER length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      ADW_COURSE_OFFER_DIM.COURSE_OFFER_NBR length = 8
         label = 'COURSE_OFFER_NBR',
      ADW_COURSE_OFFER_DIM.ACAD_GRP length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_GRP',
      ADW_COURSE_OFFER_DIM.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      ADW_COURSE_OFFER_DIM.ACAD_CAREER length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_CAREER',
      ADW_COURSE_OFFER_DIM.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      ADW_COURSE_OFFER_DIM.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      ADW_COURSE_OFFER_DIM.COURSE_APPROVED_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'COURSE_APPROVED_FLAG',
      ADW_COURSE_OFFER_DIM.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      ADW_COURSE_OFFER_DIM.SPLIT_OWNER_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'SPLIT_OWNER_FLAG',
      ADW_COURSE_OFFER_DIM.SCHEDULED_TERM_ROLL length = 1
         format = $1.
         informat = $1.
         label = 'SCHEDULED_TERM_ROLL',
      ADW_COURSE_OFFER_DIM.CIP_CD length = 13
         format = $13.
         informat = $13.
         label = 'CIP_CD',
      ADW_COURSE_OFFER_DIM.SCHEDULED_COURSE length = 1
         format = $1.
         informat = $1.
         label = 'SCHEDULED_COURSE',
      ADW_COURSE_OFFER_DIM.DYNAMIC_CLASS_DATA length = 10
         format = $10.
         informat = $10.
         label = 'DYNAMIC_CLASS_DATA',
      ADW_COURSE_OFFER_DIM.OEE_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'OEE_FLAG',
      ADW_COURSE_OFFER_DIM.EFF_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFF_DT',
      ADW_COURSE_OFFER_DIM.CURRENT_ROW_IND length = 8
         label = 'CURRENT_ROW_IND',
      ADW_COURSE_OFFER_DIM.UPDATE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATE_DT',
      ADW_COURSE_OFFER_DIM.UPDATE_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATE_USER',
      ADW_COURSE_OFFER_DIM.ACAD_ORG length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_ORG'
   from
      ADWTGTPR.ADW_COURSE_OFFER_DIM as ADW_COURSE_OFFER_DIM
   where
      ADW_COURSE_OFFER_DIM.EFF_DT <= &todate.
   group by
      ADW_COURSE_OFFER_DIM.COURSE_IDENTIFIER
   having
      ADW_COURSE_OFFER_DIM.EFF_DT = max(ADW_COURSE_OFFER_DIM.EFF_DT)
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000C2I *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 * Target Table:    Join - work.WFK7EXMA                  A5B29B8Q.BS0004D1 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2I);

proc sql;
   create table work.WFK7EXMA as
   select distinct
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
         )
   where
      ADW_STUDENT_TERM_ENRL_FACT.FIRST_TERM_CAREER_ENRL_FLG = 'Y'
   group by
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID,
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK
   having
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = min(ADW_STUDENT_TERM_ENRL_FACT.TERM_SK)
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000C2J *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_DEPT_DIM - ADWTGTPR.ADW_DEPT_DIM  A5B29B8Q.BE000011 *
 *                  ADW_ACAD_PLAN_DIM -                   A5B29B8Q.BE0000RF *
 *                   ADWTGTPR.ADW_ACAD_PLAN_DIM                             *
 *                  PS_RESIDENCY_OFF_Extract -            A5B29B8Q.BE000059 *
 *                   ADWSTGPR.PS_RESIDENCY_OFF_Extract                      *
 *                  Ps_Acad_Prog_Extract -                A5B29B8Q.BS0004CY *
 *                   work.Ps_Acad_Prog_Extract                              *
 *                  Join - work.WEC2WE5P                  A5B29B8Q.BS0004CZ *
 *                  Join - work.W415A91P                  A5B29B8Q.BS0004D0 *
 *                  Join - work.WFK7EXMA                  A5B29B8Q.BS0004D1 *
 *                  Join - work.WGOILF3S                  A5B29B8Q.BS0004CW *
 *                  ADW_STUDENT_CLASS_ENRL_FACT -         A5B29B8Q.BE0000MN *
 *                   ADWTGTPR.ADW_STUDENT_CLASS_ENRL_FACT                   *
 *                  ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  ADW_ITEM_CD_VAL -                     A5B29B8Q.BE0000RU *
 *                   ADWTGTPR.ADW_ITEM_CD_VAL                               *
 *                  ADW_PERSON_DIM -                      A5B29B8Q.BE0000RV *
 *                   ADWTGTPR.ADW_PERSON_DIM                                *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  ADW_INSTRN_MODE_DIM -                 A5B29B8Q.BE0000SN *
 *                   ADWTGTDV.ADW_INSTRN_MODE_DIM                           *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_RESIDENCY_DIM -                   A5B29B8Q.BE0000RW *
 *                   ADWTGTPR.ADW_RESIDENCY_DIM                             *
 *                  PS_EXT_ACAD_SUM_Extract -             A5B29B8Q.BE00003I *
 *                   ADWSTGPR.PS_EXT_ACAD_SUM_Extract                       *
 *                  ADW_CIP_DIM - ADWTGTPR.ADW_CIP_DIM    A5B29B8Q.BE0000RL *
 * Target Table:    Join - work.WD25TW3Z                  A5B29B8Q.BS0004D2 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2J);

proc sql;
   create table work.WD25TW3Z as
   select distinct
      "" as MIN_ONE_ONLINE_COURSE_FLG length = 8,
      ADW_STUDENT_CLASS_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      -1
      /*
      case
      when adm_appl_det_max.GRADUATION_DT=. then .
         when (intck('MONTH' , datepart(adm_appl_det_max.GRADUATION_DT ), datepart(ADW_STUDENT_CLASS_ENRL_FACT.ENRL_ADD_DT),'C') <= 12 and (adm_appl_det_max.GRADUATION_DT ^=.)) then 1
      else 0
      end
      */ as ENROLLED_WITHIN_12_MONTHS length = 8,
      case when
      trim(ADW_STUDENT_TERM_ENRL_FACT.COHORT_ENTRY) in ('New Undergraduate Telecampus','New Undergraduate Transient','Continuing Student') then 'Other'
      when ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM  in ( 'UGNDS', 'CERT', 'UGRD2','SPEC')  then 'Other'
      else ADW_STUDENT_TERM_ENRL_FACT.COHORT_ENTRY
      end as COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) ) as Age length = 8,
      case
      	when ((input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) )) <18 ) then 'Under 18'
      	when ( 18<= (input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) )) <=19 ) then '18-19'
      	when ( 20<= (input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) )) <=21 ) then '20-21'
      	when ( 22<=(input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) ))<=24 ) then '22-24'
      	when ( 25<= (input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) )) <=29 ) then '25-29'
      	when ( 30<= (input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) )) <=34 ) then '30-34'
      	when ( 35<= (input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) )) <=39 ) then '35-39'
      	when ( 40<= (input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) )) <=49 ) then '40-49'
      	when ( 50<=(input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) )) <=64 ) then '50-64'
      	when ( 65<=(input(&year., 4.)- year(datepart(ADW_PERSON_DIM.BIRTH_DT) ))  ) then '65 and over'
      	else 'Age unknown/unreported'
      end as AGE_GROUP length = 20,
      ADW_ACAD_CAREER_DIM.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      ADW_DEPT_DIM.DEPT as MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      ADW_DEPT_DIM_Major2.DEPT as MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      ADW_DEPT_DIM_Minor.DEPT as MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      datetime() as SNAPSHOT_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.,
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_LVL_LOAD_EOT as ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      ADW_ITEM_CD_VAL.DESCR as ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      ADW_PERSON_DIM.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      ADW_PERSON_DIM.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      ADW_PERSON_DIM.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      ADW_PERSON_DIM.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      catx(' ',ADW_PERSON_DIM.HOME_ADDR_1 ,ADW_PERSON_DIM.HOME_ADDR_2 ,ADW_PERSON_DIM.HOME_ADDR_3 ,ADW_PERSON_DIM.HOME_ADDR_4 ) as ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      ADW_PERSON_DIM.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      ADW_PERSON_DIM.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      ADW_PERSON_DIM.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      ADW_PERSON_DIM.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      ADW_PERSON_DIM.HOME_ADDR_GEOCODE length = 20
         format = $20.
         informat = $20.
         label = 'HOME_ADDR_GEOCODE',
      ADW_PERSON_DIM.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      case
           when trim(ADW_ACAD_PLAN_DIM.ACAD_PLAN) = 'EMBAMBNT' then 'NSPEC'
           when strip(PS_RESIDENCY_OFF_Extract.RESIDENCY)   =  '4' then 'FORGN'
           when WGOILF3S.ETHN_GRP is null then 'NSPEC'
           else WGOILF3S.ETHN_GRP
       end as ETHN_GRP length = 8,
      WGOILF3S.ETHN_GRP as Student_Ethnicity length = 11
         format = $11.
         informat = $11.,
      ADW_ACAD_PLAN_DIM.ACAD_PLAN as MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      ADW_ACAD_PLAN_DIM.CIP_CD as MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      case
      when ADW_STUDENT_TERM_ENRL_FACT.MAJOR2_DEPT_SK = -1 then ''
      else ADW_ACAD_PLAN_DIM_Major2.ACAD_PLAN
      end as MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      case
      when ADW_STUDENT_TERM_ENRL_FACT.MAJOR2_DEPT_SK = -1 then ''
      else ADW_ACAD_PLAN_DIM_Major2.CIP_CD
      end as MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      ADW_ACAD_PLAN_DIM_Minor2.ACAD_PLAN as MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      ADW_ACAD_PLAN_DIM_Minor2.CIP_CD as MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      ADW_STUDENT_CLASS_ENRL_FACT.CRSE_ID as COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      W415A91P.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      W415A91P.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      ADW_CLASS_SCHEDULE_FACT.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      ADW_CLASS_SCHEDULE_FACT.START_DT as CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      ADW_CLASS_SCHEDULE_FACT.END_DT as CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      ADW_CLASS_SCHEDULE_FACT.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      ADW_INSTRN_MODE_DIM.DESCR as INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      ADW_STUDENT_CLASS_ENRL_FACT.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      ADW_STUDENT_CLASS_ENRL_FACT.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      Ps_Acad_Prog_Extract.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      PS_RESIDENCY_OFF_Extract.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'RESIDENCY',
      ADW_STUDENT_CLASS_ENRL_FACT.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WFK7EXMA.STRM as INIT_TERM length = 8,
      ADW_TERM_DIM.DESCR as TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      ADW_TERM_DIM.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      ADW_CIP_DIM.DESCR254 as CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      ADW_ACAD_PROGRAM_DIM.DESCR as ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      ADW_ACAD_CAREER_DIM.DESCR as ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
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
      ADW_RESIDENCY_DIM.DESCR as TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      ADW_PERSON_DIM.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      PS_RESIDENCY_OFF_Extract.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      ADW_RESIDENCY_DIM_overall.DESCR as RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      ADWTGTPR.ADW_STUDENT_CLASS_ENRL_FACT as ADW_STUDENT_CLASS_ENRL_FACT inner join
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.EMPLID = ADW_STUDENT_TERM_ENRL_FACT.EMPLID
            and ADW_STUDENT_CLASS_ENRL_FACT.TERM_SK = ADW_STUDENT_TERM_ENRL_FACT.TERM_SK
            and ADW_STUDENT_CLASS_ENRL_FACT.ACAD_CAREER_SK = ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK
         ) inner join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) inner join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM_e
         on
         (
            ADW_TERM_DIM.STRM = ADW_TERM_DIM_e.STRM
            and ADW_STUDENT_CLASS_ENRL_FACT.COURSE_CAREER = ADW_TERM_DIM_e.ACAD_CAREER
         ) left join
      ADWTGTPR.ADW_CLASS_SCHEDULE_FACT as ADW_CLASS_SCHEDULE_FACT
         on
         (
            ADW_TERM_DIM_e.TERM_SK = ADW_CLASS_SCHEDULE_FACT.TERM_SK
            and ADW_STUDENT_CLASS_ENRL_FACT.CLASS_NBR = ADW_CLASS_SCHEDULE_FACT.CLASS_NBR
         ) left join
      ADWTGTPR.ADW_DEPT_DIM as ADW_DEPT_DIM
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.MAJOR_DEPT_SK = ADW_DEPT_DIM.DEPT_SK
         ) left join
      ADWTGTPR.ADW_DEPT_DIM as ADW_DEPT_DIM_Major2
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.MAJOR2_DEPT_SK = ADW_DEPT_DIM_Major2.DEPT_SK
         ) left join
      ADWTGTPR.ADW_DEPT_DIM as ADW_DEPT_DIM_Minor
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.MINOR_DEPT_SK = ADW_DEPT_DIM_Minor.DEPT_SK
         ) left join
      ADWTGTPR.ADW_ACAD_PROGRAM_DIM as ADW_ACAD_PROGRAM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY = ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_PLAN_DIM as ADW_ACAD_PLAN_DIM
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.MAJOR_ACAD_PLAN_SK = ADW_ACAD_PLAN_DIM.ACAD_PLAN_SK
         ) left join
      ADWTGTPR.ADW_ITEM_CD_VAL as ADW_ITEM_CD_VAL
         on
         (
            ADW_ITEM_CD_VAL.FIELD_NAME = 'ACADEMIC_LEVEL'
            and ADW_ITEM_CD_VAL.FIELD_VAL = ADW_STUDENT_CLASS_ENRL_FACT.ACAD_LEVEL_EOT
         ) inner join
      ADWTGTPR.ADW_PERSON_DIM as ADW_PERSON_DIM
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.EMPLID = ADW_PERSON_DIM.EMPLID
         ) left join
      ADWTGTPR.ADW_ACAD_PLAN_DIM as ADW_ACAD_PLAN_DIM_Major2
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.MAJOR2_ACAD_PLAN_SK = ADW_ACAD_PLAN_DIM_Major2.ACAD_PLAN_SK
         ) left join
      ADWTGTPR.ADW_ACAD_PLAN_DIM as ADW_ACAD_PLAN_DIM_Minor2
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.MINOR_ACAD_PLAN_SK = ADW_ACAD_PLAN_DIM_Minor2.ACAD_PLAN_SK
         ) left join
      ADWSTGPR.PS_CLASS_TBL_Extract as PS_CLASS_TBL_Extract
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.CRSE_ID = PS_CLASS_TBL_Extract.CRSE_ID
            and ADW_STUDENT_CLASS_ENRL_FACT.CLASS_NBR = PS_CLASS_TBL_Extract.CLASS_NBR
            and ADW_STUDENT_CLASS_ENRL_FACT.CLASS_SECTION = PS_CLASS_TBL_Extract.CLASS_SECTION
         ) left join
      work.W415A91P as W415A91P
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.CRSE_ID = W415A91P.COURSE_IDENTIFIER
            and PS_CLASS_TBL_Extract.CRSE_OFFER_NBR = W415A91P.COURSE_OFFER_NBR
         ) left join
      ADWTGTDV.ADW_INSTRN_MODE_DIM as ADW_INSTRN_MODE_DIM
         on
         (
            ADW_CLASS_SCHEDULE_FACT.INSTRUCTION_MODE = ADW_INSTRN_MODE_DIM.INSTRN_MODE
            and ADW_INSTRN_MODE_DIM.CURRENT_ROW_IND = 1
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWSTGPR.PS_RESIDENCY_OFF_Extract as PS_RESIDENCY_OFF_Extract
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.EMPLID = PS_RESIDENCY_OFF_Extract.EMPLID
            and PS_RESIDENCY_OFF_Extract.ACAD_CAREER = ADW_ACAD_CAREER_DIM.ACAD_CAREER
            and PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM <= ADW_TERM_DIM.STRM
         ) left join
      ADWTGTPR.ADW_RESIDENCY_DIM as ADW_RESIDENCY_DIM
         on
         (
            PS_RESIDENCY_OFF_Extract.TUITION_RES = ADW_RESIDENCY_DIM.RESIDENCY_CD
         ) left join
      work.Ps_Acad_Prog_Extract as Ps_Acad_Prog_Extract
         on
         (
            Ps_Acad_Prog_Extract.EMPLID = ADW_STUDENT_CLASS_ENRL_FACT.EMPLID
            and Ps_Acad_Prog_Extract.ACAD_CAREER = ADW_ACAD_CAREER_DIM.ACAD_CAREER
            and Ps_Acad_Prog_Extract.STDNT_CAR_NBR = ADW_STUDENT_TERM_ENRL_FACT.STUDENT_CAREER_NBR
         ) left join
      ADWSTGPR.PS_EXT_ACAD_SUM_Extract as PS_EXT_ACAD_SUM_Extract
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.EMPLID = PS_EXT_ACAD_SUM_Extract.EMPLID
            and PS_EXT_ACAD_SUM_Extract.EXT_SUMM_TYPE = 'COLL'
         ) left join
      work.WEC2WE5P as adm_appl_det_max
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.EMPLID = adm_appl_det_max.EMPLID
            and ADW_STUDENT_CLASS_ENRL_FACT.ACAD_CAREER_SK = adm_appl_det_max.ACAD_CAREER_SK
         ) left join
      ADWTGTPR.ADW_CIP_DIM as ADW_CIP_DIM
         on
         (
            ADW_CIP_DIM.CIP_CD = ADW_ACAD_PLAN_DIM.CIP_CD
         ) left join
      work.WFK7EXMA as WFK7EXMA
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.EMPLID = WFK7EXMA.EMPLID
            and ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK = WFK7EXMA.ACAD_CAREER_SK
         ) left join
      work.WGOILF3S as WGOILF3S
         on
         (
            ADW_PERSON_DIM.EMPLID = WGOILF3S.EMPLID
         ) left join
      ADWTGTPR.ADW_RESIDENCY_DIM as ADW_RESIDENCY_DIM_overall
         on
         (
            PS_RESIDENCY_OFF_Extract.RESIDENCY = ADW_RESIDENCY_DIM_overall.RESIDENCY_CD
            and ADW_RESIDENCY_DIM_overall.CURRENT_ROW_ID = 1
         )
   where
      ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_FLG = 'Y'
      and ((
	  (ADW_TERM_DIM.STRM = &term.
      and ADW_CLASS_SCHEDULE_FACT.START_DT >= &fromdate.
      and ADW_CLASS_SCHEDULE_FACT.START_DT <= &todate.)
	  
      or 
	  (ADW_TERM_DIM.STRM = &summerterm.
      and trim(ADW_STUDENT_TERM_ENRL_FACT.COHORT_ENTRY) <> 'Continuing Student'
      and ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM NOT IN ( 'UGNDS', 'CERT', 'UGRD2','SPEC'))
	  )
	  
      and ADW_CIP_DIM.CURRENT_ROW_IND = 'Y'
      and ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM IN ('MASTR', 'UGRD', 'UGNDS', 'CERT', 'UGRD2', 'SPEC', 'DOCT')

      /* ('UGNDS','SPEC','CERT') */
      and PS_CLASS_TBL_Extract.ACAD_ORG <> 'TRAN'
   group by
      ADW_STUDENT_CLASS_ENRL_FACT.EMPLID,
      ADW_TERM_DIM.STRM,
      ADW_ACAD_CAREER_DIM.ACAD_CAREER
   having
      PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM = MAX(PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM)
   ;
quit;

/*==========================================================================*
 * Step:            home                                  A5B29B8Q.BZ000C2K *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ADDRESSES_Extract -                A5B29B8Q.BE00001W *
 *                   ADWSTGPR.PS_ADDRESSES_Extract                          *
 * Target Table:    Join - work.WNDIISW8                  A5B29B8Q.BS0004D3 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2K);

%let SYSLAST = %nrquote(ADWSTGPR.PS_ADDRESSES_Extract);

proc sql;
   create table work.WNDIISW8 as
   select
      PS_ADDRESSES_Extract.ADDR_FIELD1 length = 2
         format = $2.
         informat = $2.
         label = 'ADDR_FIELD1',
      PS_ADDRESSES_Extract.ADDR_FIELD2 length = 4
         format = $4.
         informat = $4.
         label = 'ADDR_FIELD2',
      PS_ADDRESSES_Extract.ADDR_FIELD3 length = 4
         format = $4.
         informat = $4.
         label = 'ADDR_FIELD3',
      PS_ADDRESSES_Extract.ADDRESS_TYPE length = 4
         format = $4.
         informat = $4.
         label = 'ADDRESS_TYPE',
      PS_ADDRESSES_Extract.ADDRESS1 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      PS_ADDRESSES_Extract.ADDRESS2 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS2',
      PS_ADDRESSES_Extract.ADDRESS3 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS3',
      PS_ADDRESSES_Extract.ADDRESS4 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS4',
      PS_ADDRESSES_Extract.CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      PS_ADDRESSES_Extract.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      PS_ADDRESSES_Extract.COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      PS_ADDRESSES_Extract.EFF_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EFF_STATUS',
      PS_ADDRESSES_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ADDRESSES_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ADDRESSES_Extract.GEO_CODE length = 11
         format = $11.
         informat = $11.
         label = 'GEO_CODE',
      PS_ADDRESSES_Extract.POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      PS_ADDRESSES_Extract.REG_REGION length = 5
         format = $5.
         informat = $5.
         label = 'REG_REGION',
      PS_ADDRESSES_Extract.STATE length = 6
         format = $6.
         informat = $6.
         label = 'STATE'
   from
      ADWSTGPR.PS_ADDRESSES_Extract as PS_ADDRESSES_Extract
   where
      PS_ADDRESSES_Extract.ADDRESS_TYPE = 'HOME'
      and PS_ADDRESSES_Extract.EFFDT <= &todate.
   group by
      PS_ADDRESSES_Extract.EMPLID,
      PS_ADDRESSES_Extract.ADDRESS_TYPE
   having
      PS_ADDRESSES_Extract.EFFDT = max(PS_ADDRESSES_Extract.EFFDT)
      and PS_ADDRESSES_Extract.EFF_STATUS = 'A'
   ;
quit;

/*==========================================================================*
 * Step:            sevf                                  A5B29B8Q.BZ000C2L *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ADDRESSES_Extract -                A5B29B8Q.BE00001W *
 *                   ADWSTGPR.PS_ADDRESSES_Extract                          *
 * Target Table:    Join - work.WNEBITAV                  A5B29B8Q.BS0004D4 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2L);

%let SYSLAST = %nrquote(ADWSTGPR.PS_ADDRESSES_Extract);

proc sql;
   create table work.WNEBITAV as
   select
      PS_ADDRESSES_Extract.ADDR_FIELD1 length = 2
         format = $2.
         informat = $2.
         label = 'ADDR_FIELD1',
      PS_ADDRESSES_Extract.ADDR_FIELD2 length = 4
         format = $4.
         informat = $4.
         label = 'ADDR_FIELD2',
      PS_ADDRESSES_Extract.ADDR_FIELD3 length = 4
         format = $4.
         informat = $4.
         label = 'ADDR_FIELD3',
      PS_ADDRESSES_Extract.ADDRESS_TYPE length = 4
         format = $4.
         informat = $4.
         label = 'ADDRESS_TYPE',
      PS_ADDRESSES_Extract.ADDRESS1 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      PS_ADDRESSES_Extract.ADDRESS1_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1_AC',
      PS_ADDRESSES_Extract.ADDRESS2 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS2',
      PS_ADDRESSES_Extract.ADDRESS2_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS2_AC',
      PS_ADDRESSES_Extract.ADDRESS3 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS3',
      PS_ADDRESSES_Extract.ADDRESS3_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS3_AC',
      PS_ADDRESSES_Extract.ADDRESS4 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS4',
      PS_ADDRESSES_Extract.CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      PS_ADDRESSES_Extract.CITY_AC length = 30
         format = $30.
         informat = $30.
         label = 'CITY_AC',
      PS_ADDRESSES_Extract.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      PS_ADDRESSES_Extract.COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      PS_ADDRESSES_Extract.EFF_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EFF_STATUS',
      PS_ADDRESSES_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ADDRESSES_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ADDRESSES_Extract.GEO_CODE length = 11
         format = $11.
         informat = $11.
         label = 'GEO_CODE',
      PS_ADDRESSES_Extract.HOUSE_TYPE length = 2
         format = $2.
         informat = $2.
         label = 'HOUSE_TYPE',
      PS_ADDRESSES_Extract.IN_CITY_LIMIT length = 1
         format = $1.
         informat = $1.
         label = 'IN_CITY_LIMIT',
      PS_ADDRESSES_Extract.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      PS_ADDRESSES_Extract.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      PS_ADDRESSES_Extract.NUM1 length = 6
         format = $6.
         informat = $6.
         label = 'NUM1',
      PS_ADDRESSES_Extract.NUM2 length = 6
         format = $6.
         informat = $6.
         label = 'NUM2',
      PS_ADDRESSES_Extract.POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      PS_ADDRESSES_Extract.REG_REGION length = 5
         format = $5.
         informat = $5.
         label = 'REG_REGION',
      PS_ADDRESSES_Extract.STATE length = 6
         format = $6.
         informat = $6.
         label = 'STATE',
      PS_ADDRESSES_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ADDRESSES_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_ADDRESSES_Extract as PS_ADDRESSES_Extract
   where
      PS_ADDRESSES_Extract.ADDRESS_TYPE = 'SEVF'
      and PS_ADDRESSES_Extract.EFFDT <= &todate.
   group by
      PS_ADDRESSES_Extract.EMPLID,
      PS_ADDRESSES_Extract.ADDRESS_TYPE
   having
      PS_ADDRESSES_Extract.EFFDT = max(PS_ADDRESSES_Extract.EFFDT)
      and PS_ADDRESSES_Extract.EFF_STATUS = 'A'
   ;
quit;

/*==========================================================================*
 * Step:            perm                                  A5B29B8Q.BZ000C2M *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ADDRESSES_Extract -                A5B29B8Q.BE00001W *
 *                   ADWSTGPR.PS_ADDRESSES_Extract                          *
 * Target Table:    Join - work.WNGZ3F4E                  A5B29B8Q.BS0004D5 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2M);

%let SYSLAST = %nrquote(ADWSTGPR.PS_ADDRESSES_Extract);

proc sql;
   create view work.WNGZ3F4E as
   select
      PS_ADDRESSES_Extract.ADDR_FIELD1 length = 2
         format = $2.
         informat = $2.
         label = 'ADDR_FIELD1',
      PS_ADDRESSES_Extract.ADDR_FIELD2 length = 4
         format = $4.
         informat = $4.
         label = 'ADDR_FIELD2',
      PS_ADDRESSES_Extract.ADDR_FIELD3 length = 4
         format = $4.
         informat = $4.
         label = 'ADDR_FIELD3',
      PS_ADDRESSES_Extract.ADDRESS_TYPE length = 4
         format = $4.
         informat = $4.
         label = 'ADDRESS_TYPE',
      PS_ADDRESSES_Extract.ADDRESS1 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      PS_ADDRESSES_Extract.ADDRESS1_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1_AC',
      PS_ADDRESSES_Extract.ADDRESS2 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS2',
      PS_ADDRESSES_Extract.ADDRESS2_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS2_AC',
      PS_ADDRESSES_Extract.ADDRESS3 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS3',
      PS_ADDRESSES_Extract.ADDRESS3_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS3_AC',
      PS_ADDRESSES_Extract.ADDRESS4 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS4',
      PS_ADDRESSES_Extract.CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      PS_ADDRESSES_Extract.CITY_AC length = 30
         format = $30.
         informat = $30.
         label = 'CITY_AC',
      PS_ADDRESSES_Extract.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      PS_ADDRESSES_Extract.COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      PS_ADDRESSES_Extract.EFF_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EFF_STATUS',
      PS_ADDRESSES_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ADDRESSES_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ADDRESSES_Extract.GEO_CODE length = 11
         format = $11.
         informat = $11.
         label = 'GEO_CODE',
      PS_ADDRESSES_Extract.HOUSE_TYPE length = 2
         format = $2.
         informat = $2.
         label = 'HOUSE_TYPE',
      PS_ADDRESSES_Extract.IN_CITY_LIMIT length = 1
         format = $1.
         informat = $1.
         label = 'IN_CITY_LIMIT',
      PS_ADDRESSES_Extract.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      PS_ADDRESSES_Extract.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      PS_ADDRESSES_Extract.NUM1 length = 6
         format = $6.
         informat = $6.
         label = 'NUM1',
      PS_ADDRESSES_Extract.NUM2 length = 6
         format = $6.
         informat = $6.
         label = 'NUM2',
      PS_ADDRESSES_Extract.POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      PS_ADDRESSES_Extract.REG_REGION length = 5
         format = $5.
         informat = $5.
         label = 'REG_REGION',
      PS_ADDRESSES_Extract.STATE length = 6
         format = $6.
         informat = $6.
         label = 'STATE',
      PS_ADDRESSES_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ADDRESSES_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_ADDRESSES_Extract as PS_ADDRESSES_Extract
   where
      PS_ADDRESSES_Extract.ADDRESS_TYPE = 'PERM'
      and PS_ADDRESSES_Extract.EFFDT <= &todate.
   group by
      PS_ADDRESSES_Extract.ADDRESS_TYPE,
      PS_ADDRESSES_Extract.EMPLID
   having
      PS_ADDRESSES_Extract.EFFDT = max(PS_ADDRESSES_Extract.EFFDT)
      and PS_ADDRESSES_Extract.EFF_STATUS = 'A'
   ;
quit;

/*==========================================================================*
 * Step:            filter for Visa's IPEDS Address       A5B29B8Q.BZ000C2N *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_VISA_PMT_DATA_Extract -            A5B29B8Q.BE00008N *
 *                   ADWSTGPR.PS_VISA_PMT_DATA_Extract                      *
 * Target Table:    Join - work.W66IKNDU                  A5B29B8Q.BS0004D6 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2N);

%let SYSLAST = %nrquote(ADWSTGPR.PS_VISA_PMT_DATA_Extract);

proc sql;
   create table work.W66IKNDU as
   select
      PS_VISA_PMT_DATA_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_VISA_PMT_DATA_Extract.VISA_PERMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'VISA_PERMIT_TYPE',
      PS_VISA_PMT_DATA_Extract.EFFDT length = 8
         format = DATETIME22.3
         informat = DATETIME22.3
         label = 'EFFDT'
   from
      ADWSTGPR.PS_VISA_PMT_DATA_Extract as PS_VISA_PMT_DATA_Extract
   where
      PS_VISA_PMT_DATA_Extract.EFFDT <= &todate.
      and PS_VISA_PMT_DATA_Extract.VISA_PERMIT_TYPE <> 'AR1'
   group by
      PS_VISA_PMT_DATA_Extract.EMPLID
   having
      PS_VISA_PMT_DATA_Extract.EFFDT = max(PS_VISA_PMT_DATA_Extract.EFFDT)
      and PS_VISA_PMT_DATA_Extract.VISA_PERMIT_TYPE IN ('NV', 'ASY', 'LPR', 'REF', 'TPS','PLP')
   ;
quit;

/*==========================================================================*
 * Step:            IPEDS State                           A5B29B8Q.BZ000C2O *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WD25TW3Z                  A5B29B8Q.BS0004D2 *
 *                  PS_ADDRESSES_Extract -                A5B29B8Q.BE00001W *
 *                   ADWSTGPR.PS_ADDRESSES_Extract                          *
 *                  Join - work.WNDIISW8                  A5B29B8Q.BS0004D3 *
 *                  Join - work.WNEBITAV                  A5B29B8Q.BS0004D4 *
 *                  Join - work.WNGZ3F4E                  A5B29B8Q.BS0004D5 *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  Join - work.W66IKNDU                  A5B29B8Q.BS0004D6 *
 * Target Table:    Join - work.W4HEB7W0                  A5B29B8Q.BS0004D7 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2O);

proc sql;
   create table work.W4HEB7W0 as
   select
      WD25TW3Z.MIN_ONE_ONLINE_COURSE_FLG length = 8,
      WD25TW3Z.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WD25TW3Z.ENROLLED_WITHIN_12_MONTHS length = 8,
      WD25TW3Z.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      WD25TW3Z.Age length = 8,
      WD25TW3Z.AGE_GROUP length = 20,
      WD25TW3Z.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WD25TW3Z.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      WD25TW3Z.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WD25TW3Z.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WD25TW3Z.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WD25TW3Z.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WD25TW3Z.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      WD25TW3Z.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WD25TW3Z.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      WD25TW3Z.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      WD25TW3Z.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      WD25TW3Z.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      strip(catx(' ',WNDIISW8.ADDRESS1 ,WNDIISW8.ADDRESS2 ,WNDIISW8.ADDRESS3 ,WNDIISW8.ADDRESS4  )) as ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      WNDIISW8.CITY as HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      WNDIISW8.STATE as HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      WNDIISW8.POSTAL as HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      WNDIISW8.COUNTRY as HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      WNDIISW8.GEO_CODE as HOME_ADDR_GEOCODE length = 20
         format = $20.
         informat = $20.
         label = 'HOME_ADDR_GEOCODE',
      WD25TW3Z.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      WD25TW3Z.ETHN_GRP length = 8,
      WD25TW3Z.Student_Ethnicity length = 11
         format = $11.
         informat = $11.,
      WD25TW3Z.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WD25TW3Z.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WD25TW3Z.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WD25TW3Z.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WD25TW3Z.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WD25TW3Z.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WD25TW3Z.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      WD25TW3Z.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      WD25TW3Z.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      WD25TW3Z.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      WD25TW3Z.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      WD25TW3Z.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      WD25TW3Z.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      WD25TW3Z.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WD25TW3Z.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      WD25TW3Z.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      WD25TW3Z.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      WD25TW3Z.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WD25TW3Z.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WD25TW3Z.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WD25TW3Z.SNAPSHOT_DT length = 8,
      WD25TW3Z.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WD25TW3Z.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      case
      	when WD25TW3Z.RESIDENCY = '4' and W66IKNDU.EMPLID is missing and WNEBITAV.ADDRESS_TYPE ='SEVF' then WNEBITAV.STATE
      	when WD25TW3Z.RESIDENCY = '4' and  W66IKNDU.EMPLID is missing and WNGZ3F4E.ADDRESS_TYPE ='PERM' then WNGZ3F4E.STATE
      	else WNDIISW8.STATE
      end as IPEDS_STATE length = 6,
      case
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNEBITAV.ADDRESS_TYPE ='SEVF' then stfips(WNEBITAV.STATE)
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNGZ3F4E.ADDRESS_TYPE ='PERM' then stfips(WNGZ3F4E.STATE )
      	else stfips(WNDIISW8.STATE)
      end as IPEDS_FIPS_CD length = 8,
      WD25TW3Z.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      WD25TW3Z.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WD25TW3Z.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WD25TW3Z.INIT_TERM length = 8,
      WD25TW3Z.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WD25TW3Z.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      WD25TW3Z.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      WD25TW3Z.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      WD25TW3Z.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      case
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNEBITAV.ADDRESS_TYPE ='SEVF' then WNEBITAV.CITY
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNGZ3F4E.ADDRESS_TYPE ='PERM' then WNGZ3F4E.CITY
      	else WNDIISW8.CITY
      end as IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      case
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNEBITAV.ADDRESS_TYPE ='SEVF' then WNEBITAV.COUNTY
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNGZ3F4E.ADDRESS_TYPE ='PERM' then WNGZ3F4E.COUNTY
      	else WNDIISW8.COUNTY
      end

      /* old code that would trim the first numbers
      case
      	when WD25TW3Z.RESIDENCY = '4'  and WNEBITAV.ADDRESS_TYPE ='SEVF' then
      		case
      		when verify(WNEBITAV.COUNTY,'0123456789')=4 then substr(WNEBITAV.COUNTY ,1,3)
      		else ''
      		end
      	when WD25TW3Z.RESIDENCY = '4'  and WNEBITAV.ADDRESS_TYPE ='PERM' then
      		case
      		when verify(WNGZ3F4E.COUNTY,'0123456789')=4 then substr(WNGZ3F4E.COUNTY ,1,3)
      		else ''
      		end

      	else
      		case
      		when verify(WNDIISW8.COUNTY ,'0123456789')=4 then substr(WNDIISW8.COUNTY  ,1,3)
      		else ''
      		end
      end

      */ as IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      case
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNEBITAV.ADDRESS_TYPE ='SEVF' then WNEBITAV.POSTAL
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNGZ3F4E.ADDRESS_TYPE ='PERM' then WNGZ3F4E.POSTAL
      	else WNDIISW8.POSTAL
      end as IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WNDIISW8.COUNTY as HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      case
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNEBITAV.ADDRESS_TYPE ='SEVF' then strip(catx(' ',WNEBITAV.ADDRESS1, WNEBITAV.ADDRESS2 ,WNEBITAV.ADDRESS3, WNEBITAV.ADDRESS4   ))
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNGZ3F4E.ADDRESS_TYPE ='PERM' then strip(catx(' ',WNGZ3F4E.ADDRESS1 ,WNGZ3F4E.ADDRESS2 ,WNGZ3F4E.ADDRESS3 ,WNGZ3F4E.ADDRESS4 ))
      	else strip(catx(' ',WNDIISW8.ADDRESS1 ,WNDIISW8.ADDRESS2 ,WNDIISW8.ADDRESS3 ,WNDIISW8.ADDRESS4 ))
      end as IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      case
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNEBITAV.ADDRESS_TYPE ='SEVF' then WNEBITAV.COUNTRY
      	when WD25TW3Z.RESIDENCY = '4'  and W66IKNDU.EMPLID is missing and WNGZ3F4E.ADDRESS_TYPE ='PERM' then WNGZ3F4E.COUNTRY
      	else WNDIISW8.COUNTRY
      end as IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WD25TW3Z.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      case
      	when WD25TW3Z.RESIDENCY = '4' and W66IKNDU.EMPLID is missing and WNEBITAV.ADDRESS_TYPE ='SEVF' then WNEBITAV.COUNTY
      	when WD25TW3Z.RESIDENCY = '4' and W66IKNDU.EMPLID is missing and WNGZ3F4E.ADDRESS_TYPE ='PERM' then WNGZ3F4E.COUNTY
      	else WNDIISW8.COUNTY
      end as IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WD25TW3Z.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR',
      ADW_TERM_DIM.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      ADW_TERM_DIM.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      ADW_TERM_DIM.SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SHORT_DESCR',
      ADW_TERM_DIM.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      ADW_TERM_DIM.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADW_TERM_DIM.SESSION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'SESSION_DESCR',
      ADW_TERM_DIM.SESSION_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SESSION_SHORT_DESCR',
      ADW_TERM_DIM.WEEKS_OF_INSTRN length = 8
         label = 'WEEKS_OF_INSTRN',
      ADW_TERM_DIM.TERM_CATEGORY_CD length = 1
         format = $1.
         informat = $1.
         label = 'TERM_CATEGORY_CD',
      ADW_TERM_DIM.TERM_CATEGORY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TERM_CATEGORY_DESCR',
      ADW_TERM_DIM.TERM_CATEGORY_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'TERM_CATEGORY_SHORT_DESCR',
      ADW_TERM_DIM.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      ADW_TERM_DIM.SIXTY_PERCENT_DT length = 20
         format = $20.
         informat = $20.
         label = 'SIXTY_PERCENT_DT',
      ADW_TERM_DIM.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_TERM_DIM.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      ADW_TERM_DIM.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      ADW_TERM_DIM.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      WNEBITAV.ADDR_FIELD1 length = 2
         format = $2.
         informat = $2.
         label = 'ADDR_FIELD1',
      WNEBITAV.ADDR_FIELD2 length = 4
         format = $4.
         informat = $4.
         label = 'ADDR_FIELD2',
      WNEBITAV.ADDR_FIELD3 length = 4
         format = $4.
         informat = $4.
         label = 'ADDR_FIELD3',
      WNEBITAV.ADDRESS_TYPE length = 4
         format = $4.
         informat = $4.
         label = 'ADDRESS_TYPE',
      WNEBITAV.ADDRESS1 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      WNEBITAV.ADDRESS1_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1_AC',
      WNEBITAV.ADDRESS2 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS2',
      WNEBITAV.ADDRESS2_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS2_AC',
      WNEBITAV.ADDRESS3 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS3',
      WNEBITAV.ADDRESS3_AC length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS3_AC',
      WNEBITAV.ADDRESS4 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS4',
      WNEBITAV.CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      WNEBITAV.CITY_AC length = 30
         format = $30.
         informat = $30.
         label = 'CITY_AC',
      WNEBITAV.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WNEBITAV.COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WNEBITAV.EFF_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EFF_STATUS',
      WNEBITAV.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      WNEBITAV.GEO_CODE length = 11
         format = $11.
         informat = $11.
         label = 'GEO_CODE',
      WNEBITAV.HOUSE_TYPE length = 2
         format = $2.
         informat = $2.
         label = 'HOUSE_TYPE',
      WNEBITAV.IN_CITY_LIMIT length = 1
         format = $1.
         informat = $1.
         label = 'IN_CITY_LIMIT',
      WNEBITAV.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      WNEBITAV.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      WNEBITAV.NUM1 length = 6
         format = $6.
         informat = $6.
         label = 'NUM1',
      WNEBITAV.NUM2 length = 6
         format = $6.
         informat = $6.
         label = 'NUM2',
      WNEBITAV.POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WNEBITAV.REG_REGION length = 5
         format = $5.
         informat = $5.
         label = 'REG_REGION',
      WNEBITAV.STATE length = 6
         format = $6.
         informat = $6.
         label = 'STATE',
      WNEBITAV.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      WNEBITAV.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID',
      W66IKNDU.VISA_PERMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'VISA_PERMIT_TYPE'
   from
      work.WD25TW3Z as WD25TW3Z left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            WD25TW3Z.STRM = ADW_TERM_DIM.STRM
            and WD25TW3Z.ACAD_CAREER = ADW_TERM_DIM.ACAD_CAREER
         ) left join
      work.WNEBITAV as WNEBITAV
         on
         (
            WD25TW3Z.EMPLID = WNEBITAV.EMPLID
            and WNEBITAV.EFFDT <= &todate.
            and WNEBITAV.ADDRESS_TYPE = 'SEVF'
         ) left join
      work.WNDIISW8 as WNDIISW8
         on
         (
            WD25TW3Z.EMPLID = WNDIISW8.EMPLID
         ) left join
      work.WNGZ3F4E as WNGZ3F4E
         on
         (
            WD25TW3Z.EMPLID = WNGZ3F4E.EMPLID
         ) left join
      work.W66IKNDU as W66IKNDU
         on
         (
            WD25TW3Z.EMPLID = W66IKNDU.EMPLID
         )
   where
      WNEBITAV.EFFDT <= &todate.
   group by
      WD25TW3Z.EMPLID,
      ADW_TERM_DIM.TERM_BEGIN_DT
   having
      (MAX(WNEBITAV.EFFDT) IS MISSING
      or WNEBITAV.EFFDT = MAX(WNEBITAV.EFFDT))
   ;
quit;

/*==========================================================================*
 * Step:            total count                           A5B29B8Q.BZ000C2P *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W4HEB7W0                  A5B29B8Q.BS0004D7 *
 * Target Table:    Join - work.WDZ5482R                  A5B29B8Q.BS0004D8 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2P);

%let SYSLAST = %nrquote(work.W4HEB7W0);

proc sql;
   create table work.WDZ5482R as
   select
      W4HEB7W0.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W4HEB7W0.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W4HEB7W0.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      count(*) as Count_total length = 8
   from
      work.W4HEB7W0 as W4HEB7W0
   group by
      W4HEB7W0.STRM,
      W4HEB7W0.ACAD_CAREER,
      W4HEB7W0.EMPLID
   ;
quit;

/*==========================================================================*
 * Step:            count of mode=02                      A5B29B8Q.BZ000C2Q *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W4HEB7W0                  A5B29B8Q.BS0004D7 *
 * Target Table:    Join - work.WDXMUVK5                  A5B29B8Q.BS0004D9 *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2Q);

%let SYSLAST = %nrquote(work.W4HEB7W0);

proc sql;
   create table work.WDXMUVK5 as
   select distinct
      W4HEB7W0.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W4HEB7W0.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W4HEB7W0.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      count(*) as Count_02 length = 8
   from
      work.W4HEB7W0 as W4HEB7W0
   where
      W4HEB7W0.INSTRUCTION_MODE = '02'
   group by
      W4HEB7W0.STRM,
      W4HEB7W0.ACAD_CAREER,
      W4HEB7W0.EMPLID
   ;
quit;

/*==========================================================================*
 * Step:            filter for Visa's                     A5B29B8Q.BZ000C2R *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_VISA_PMT_DATA_Extract -            A5B29B8Q.BE00008N *
 *                   ADWSTGPR.PS_VISA_PMT_DATA_Extract                      *
 * Target Table:    Join - work.WEDHK2MV                  A5B29B8Q.BS0004DA *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2R);

%let SYSLAST = %nrquote(ADWSTGPR.PS_VISA_PMT_DATA_Extract);

proc sql;
   create table work.WEDHK2MV as
   select
      PS_VISA_PMT_DATA_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_VISA_PMT_DATA_Extract.VISA_PERMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'VISA_PERMIT_TYPE',
      PS_VISA_PMT_DATA_Extract.EFFDT length = 8
         format = DATETIME22.3
         informat = DATETIME22.3
         label = 'EFFDT'
   from
      ADWSTGPR.PS_VISA_PMT_DATA_Extract as PS_VISA_PMT_DATA_Extract
   where
      PS_VISA_PMT_DATA_Extract.EFFDT <= &todate.
      and PS_VISA_PMT_DATA_Extract.VISA_PERMIT_TYPE <> 'AR1'
   group by
      PS_VISA_PMT_DATA_Extract.EMPLID
   having
      PS_VISA_PMT_DATA_Extract.EFFDT = max(PS_VISA_PMT_DATA_Extract.EFFDT)
      and PS_VISA_PMT_DATA_Extract.VISA_PERMIT_TYPE IN ('NV', 'ASY', 'LPR', 'REF', 'TPS','PLP')
   ;
quit;

/*==========================================================================*
 * Step:            distance education                    A5B29B8Q.BZ000C2S *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WDXMUVK5                  A5B29B8Q.BS0004D9 *
 *                  Join - work.WDZ5482R                  A5B29B8Q.BS0004D8 *
 *                  Join - work.W4HEB7W0                  A5B29B8Q.BS0004D7 *
 * Target Table:    Join - work.WDVM6KQZ                  A5B29B8Q.BS0004DB *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2S);

proc sql;
   create table work.WDVM6KQZ as
   select
      case
      	when (coalesce(WDXMUVK5.Count_02,0) >0)  then  'Y'
      else 'N'
      end as MIN_ONE_ONLINE_COURSE_FLG length = 1,
      W4HEB7W0.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W4HEB7W0.ENROLLED_WITHIN_12_MONTHS length = 8,
      W4HEB7W0.AGE_GROUP length = 20,
      W4HEB7W0.IPEDS_STATE length = 6,
      W4HEB7W0.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W4HEB7W0.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      W4HEB7W0.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W4HEB7W0.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W4HEB7W0.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W4HEB7W0.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W4HEB7W0.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      W4HEB7W0.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W4HEB7W0.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W4HEB7W0.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W4HEB7W0.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      W4HEB7W0.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      W4HEB7W0.Age length = 8,
      W4HEB7W0.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      W4HEB7W0.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      W4HEB7W0.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      W4HEB7W0.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      W4HEB7W0.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      W4HEB7W0.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      W4HEB7W0.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      W4HEB7W0.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_COUNTY',
      W4HEB7W0.ETHN_GRP length = 8,
      W4HEB7W0.Student_Ethnicity length = 11
         format = $11.
         informat = $11.,
      W4HEB7W0.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W4HEB7W0.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W4HEB7W0.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W4HEB7W0.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W4HEB7W0.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W4HEB7W0.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W4HEB7W0.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      W4HEB7W0.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      W4HEB7W0.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      W4HEB7W0.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      W4HEB7W0.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      W4HEB7W0.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      W4HEB7W0.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W4HEB7W0.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W4HEB7W0.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      W4HEB7W0.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      W4HEB7W0.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      W4HEB7W0.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W4HEB7W0.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      IFC(UPCASE(W4HEB7W0.ACAD_CAREER ) = 'GRAD',
      IFC(Sum(W4HEB7W0.UNIT_TAKEN )  >= 9, 'F', 'P', ''),
      IFC(UPCASE(W4HEB7W0.ACAD_CAREER ) = 'UGRD',
      IFC(Sum(W4HEB7W0.UNIT_TAKEN ) >= 12, 'F', 'P', ''),'',''),'') as IPEDS_FULL_PART_TIME_FLG length = 1,
      Sum(W4HEB7W0.UNIT_TAKEN) as IPEDS_SCH length = 8,
      case
      	when ((coalesce(WDXMUVK5.Count_02,0) = WDZ5482R.Count_total) and ((coalesce(WDXMUVK5.Count_02,0) ^=0))) then  'Enrolled exclusively in distance education'
      	when min(W4HEB7W0.INSTRUCTION_MODE )='02' and max(W4HEB7W0.INSTRUCTION_MODE )='02' then 'Enrolled exclusively in distance education'
      	when min(W4HEB7W0.INSTRUCTION_MODE )='01' and max(W4HEB7W0.INSTRUCTION_MODE )='01' then 'Not enrolled in any online course'
      	when ((coalesce(WDXMUVK5.Count_02,0) ^= WDZ5482R.Count_total) and ((coalesce(WDXMUVK5.Count_02,0) ^=0))) then 'Enrolled in some but not all distance education courses'
      else 'Not enrolled in any online course'
      end as IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      W4HEB7W0.IPEDS_FIPS_CD length = 8,
      W4HEB7W0.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      W4HEB7W0.SNAPSHOT_DT length = 8,
      W4HEB7W0.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W4HEB7W0.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W4HEB7W0.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      W4HEB7W0.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W4HEB7W0.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W4HEB7W0.INIT_TERM length = 8,
      W4HEB7W0.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W4HEB7W0.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W4HEB7W0.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W4HEB7W0.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      W4HEB7W0.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      W4HEB7W0.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      W4HEB7W0.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      W4HEB7W0.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      W4HEB7W0.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      W4HEB7W0.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      W4HEB7W0.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      W4HEB7W0.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      W4HEB7W0.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.W4HEB7W0 as W4HEB7W0 left join
      work.WDXMUVK5 as WDXMUVK5
         on
         (
            W4HEB7W0.EMPLID = WDXMUVK5.EMPLID
            and W4HEB7W0.ACAD_CAREER = WDXMUVK5.ACAD_CAREER
            and W4HEB7W0.STRM = WDXMUVK5.STRM
         ) left join
      work.WDZ5482R as WDZ5482R
         on
         (
            W4HEB7W0.EMPLID = WDZ5482R.EMPLID
            and W4HEB7W0.ACAD_CAREER = WDZ5482R.ACAD_CAREER
            and W4HEB7W0.STRM = WDZ5482R.STRM
         )
   group by
      W4HEB7W0.STRM,
      W4HEB7W0.ACAD_CAREER,
      W4HEB7W0.EMPLID
   ;
quit;

/*==========================================================================*
 * Step:            ipeds_visa                            A5B29B8Q.BZ000C2T *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WDVM6KQZ                  A5B29B8Q.BS0004DB *
 *                  Join - work.WEDHK2MV                  A5B29B8Q.BS0004DA *
 * Target Table:    Join - work.WE20S8ON                  A5B29B8Q.BS0004DC *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2T);

proc sql;
   create table work.WE20S8ON as
   select
      WDVM6KQZ.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      WDVM6KQZ.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WDVM6KQZ.ENROLLED_WITHIN_12_MONTHS length = 8,
      WDVM6KQZ.AGE_GROUP length = 20,
      WDVM6KQZ.IPEDS_STATE length = 6,
      WDVM6KQZ.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WDVM6KQZ.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      WDVM6KQZ.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDVM6KQZ.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDVM6KQZ.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDVM6KQZ.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WDVM6KQZ.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      WDVM6KQZ.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDVM6KQZ.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      WDVM6KQZ.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      WDVM6KQZ.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      WDVM6KQZ.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      WDVM6KQZ.Age length = 8,
      WDVM6KQZ.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      WDVM6KQZ.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      WDVM6KQZ.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      WDVM6KQZ.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      WDVM6KQZ.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      WDVM6KQZ.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      WDVM6KQZ.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      WDVM6KQZ.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      WDVM6KQZ.ETHN_GRP length = 8,
      WDVM6KQZ.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDVM6KQZ.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDVM6KQZ.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDVM6KQZ.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDVM6KQZ.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDVM6KQZ.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDVM6KQZ.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      WDVM6KQZ.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      WDVM6KQZ.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      WDVM6KQZ.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      WDVM6KQZ.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      WDVM6KQZ.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      WDVM6KQZ.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      WDVM6KQZ.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDVM6KQZ.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      WDVM6KQZ.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      WDVM6KQZ.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      WDVM6KQZ.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WDVM6KQZ.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WDVM6KQZ.IPEDS_FULL_PART_TIME_FLG length = 1,
      WDVM6KQZ.IPEDS_SCH length = 8,
      WDVM6KQZ.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      WDVM6KQZ.IPEDS_FIPS_CD length = 8,
      WDVM6KQZ.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WDVM6KQZ.SNAPSHOT_DT length = 8,
      case
      	when ((strip(WDVM6KQZ.ETHN_GRP ) ='FORGN') and ( strip(WEDHK2MV.VISA_PERMIT_TYPE) IN ('NV', 'ASY', 'LPR', 'REF', 'TPS','PLP') ) ) and WDVM6KQZ.Student_Ethnicity  is not missing then WDVM6KQZ.Student_Ethnicity
      	when ((strip(WDVM6KQZ.ETHN_GRP ) ='FORGN') and ( strip(WEDHK2MV.VISA_PERMIT_TYPE) IN ('NV', 'ASY', 'LPR', 'REF', 'TPS','PLP') ) )  and WDVM6KQZ.Student_Ethnicity  is missing then 'NSPEC'
      	else strip(WDVM6KQZ.ETHN_GRP )
      end as IPEDS_ETHNICITY length = 8,
      WDVM6KQZ.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDVM6KQZ.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WDVM6KQZ.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      WDVM6KQZ.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDVM6KQZ.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDVM6KQZ.INIT_TERM length = 8,
      WDVM6KQZ.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDVM6KQZ.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      WDVM6KQZ.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      WDVM6KQZ.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      WDVM6KQZ.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      WDVM6KQZ.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      WDVM6KQZ.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WDVM6KQZ.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      WDVM6KQZ.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WDVM6KQZ.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      WDVM6KQZ.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WDVM6KQZ.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WDVM6KQZ.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR',
      WEDHK2MV.VISA_PERMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'VISA_PERMIT_TYPE',
      WDVM6KQZ.Student_Ethnicity length = 11
         format = $11.
         informat = $11.
   from
      work.WDVM6KQZ as WDVM6KQZ left join
      work.WEDHK2MV as WEDHK2MV
         on
         (
            WDVM6KQZ.EMPLID = WEDHK2MV.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            max(effdt) PRI                        A5B29B8Q.BZ000C2U *
 * Transform:       Join                                                    *
 * Description:     PS_NAMES_Extract.EFFDT <=                               *
 *                   &todate.PS_NAMES_Extract.NAME_TYPE = 'PRI'             *
 *                                                                          *
 * Source Table:    PS_NAMES_Extract -                    A5B29B8Q.BE00004K *
 *                   ADWSTGPR.PS_NAMES_Extract                              *
 * Target Table:    Join - work.W1JWT24S                  A5B29B8Q.BS0004DD *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2U);

%let SYSLAST = %nrquote(ADWSTGPR.PS_NAMES_Extract);

proc sql;
   create table work.W1JWT24S as
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
      PS_NAMES_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_NAMES_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_NAMES_Extract as PS_NAMES_Extract
   where
      PS_NAMES_Extract.EFFDT <= &todate.
      and PS_NAMES_Extract.NAME_TYPE = 'PRI'
   group by
      PS_NAMES_Extract.EMPLID
   having
      PS_NAMES_Extract.EFFDT = max(PS_NAMES_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            names                                 A5B29B8Q.BZ000C2V *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WE20S8ON                  A5B29B8Q.BS0004DC *
 *                  Join - work.W1JWT24S                  A5B29B8Q.BS0004DD *
 * Target Table:    Join - work.W1JXC4PI                  A5B29B8Q.BS0004DE *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2V);

proc sql;
   create table work.W1JXC4PI as
   select distinct
      WE20S8ON.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      WE20S8ON.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WE20S8ON.ENROLLED_WITHIN_12_MONTHS length = 8,
      WE20S8ON.AGE_GROUP length = 20,
      WE20S8ON.IPEDS_STATE length = 6,
      WE20S8ON.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WE20S8ON.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      WE20S8ON.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WE20S8ON.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WE20S8ON.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WE20S8ON.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WE20S8ON.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      WE20S8ON.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      tranwrd(W1JWT24S.FIRST_NAME, '?','n') as FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      tranwrd(W1JWT24S.LAST_NAME, '?','n') as LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      tranwrd(W1JWT24S.MIDDLE_NAME, '?','n') as MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      WE20S8ON.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      WE20S8ON.Age length = 8,
      WE20S8ON.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      WE20S8ON.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      WE20S8ON.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      WE20S8ON.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      WE20S8ON.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      WE20S8ON.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      WE20S8ON.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      WE20S8ON.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      WE20S8ON.ETHN_GRP length = 8,
      WE20S8ON.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WE20S8ON.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WE20S8ON.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WE20S8ON.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WE20S8ON.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WE20S8ON.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WE20S8ON.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      WE20S8ON.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      WE20S8ON.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      WE20S8ON.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      WE20S8ON.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      WE20S8ON.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      WE20S8ON.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      WE20S8ON.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WE20S8ON.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      WE20S8ON.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      WE20S8ON.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      WE20S8ON.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WE20S8ON.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WE20S8ON.IPEDS_FULL_PART_TIME_FLG length = 1,
      WE20S8ON.IPEDS_SCH length = 8,
      WE20S8ON.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      WE20S8ON.IPEDS_FIPS_CD length = 8,
      WE20S8ON.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WE20S8ON.SNAPSHOT_DT length = 8,
      WE20S8ON.IPEDS_ETHNICITY length = 8,
      WE20S8ON.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WE20S8ON.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WE20S8ON.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      WE20S8ON.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WE20S8ON.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WE20S8ON.INIT_TERM length = 8,
      WE20S8ON.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WE20S8ON.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      WE20S8ON.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      WE20S8ON.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      WE20S8ON.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      WE20S8ON.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      WE20S8ON.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WE20S8ON.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      WE20S8ON.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WE20S8ON.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      WE20S8ON.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WE20S8ON.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WE20S8ON.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.WE20S8ON as WE20S8ON inner join
      work.W1JWT24S as W1JWT24S
         on
         (
            WE20S8ON.EMPLID = W1JWT24S.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            max(degree dt)                        A5B29B8Q.BZ000C2W *
 * Transform:       Join                                                    *
 * Description:     For high school                                         *
 *                                                                          *
 * Source Table:    PS_EXT_DEGREE_Extract -               A5B29B8Q.BE00003J *
 *                   ADWSTGPR.PS_EXT_DEGREE_Extract                         *
 * Target Table:    Join - work.W4RA21MV                  A5B29B8Q.BS0004DF *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2W);

%let SYSLAST = %nrquote(ADWSTGPR.PS_EXT_DEGREE_Extract);

proc sql;
   create view work.W4RA21MV as
   select distinct
      PS_EXT_DEGREE_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      max(PS_EXT_DEGREE_Extract.DEGREE_DT) as DEGREE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEGREE_DT'
   from
      ADWSTGPR.PS_EXT_DEGREE_Extract as PS_EXT_DEGREE_Extract
   where
      (PS_EXT_DEGREE_Extract.EXT_CAREER = 'HS'
      or PS_EXT_DEGREE_Extract.DESCR LIKE '%High School%'
      or PS_EXT_DEGREE_Extract.DESCR LIKE 'HS%'
      or PS_EXT_DEGREE_Extract.DEGREE IN ('DR',
      'DA',
      'DD',
      'DFE',
      'DFN',
      'DIBO',
      'DIBT',
      'DLA',
      'DN',
      'DO',
      'DR',
      'DX'
      ))
      and PS_EXT_DEGREE_Extract.DEGREE_STATUS = 'C'
      and PS_EXT_DEGREE_Extract.LS_DATA_SOURCE = 'SCH'
   group by
      PS_EXT_DEGREE_Extract.EMPLID
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000C2X *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W1JXC4PI                  A5B29B8Q.BS0004DE *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  Join - work.W4RA21MV                  A5B29B8Q.BS0004DF *
 * Target Table:    Join - work.W3IG2WQL                  A5B29B8Q.BS0004DG *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2X);

proc sql;
   create view work.W3IG2WQL as
   select distinct
      W1JXC4PI.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      W1JXC4PI.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      CASE
      WHEN missing(W4RA21MV.DEGREE_DT)  THEN .
      WHEN missing(ADW_TERM_DIM.TERM_BEGIN_DT )  THEN .
      WHEN (YRDIF(DATEPART(W4RA21MV.DEGREE_DT) , DATEPART(ADW_TERM_DIM.TERM_BEGIN_DT) ,'ACT/ACT'))  >1 THEN 0

       ELSE 1 END as ENROLLED_WITHIN_12_MONTHS length = 8,
      W1JXC4PI.AGE_GROUP length = 20,
      W1JXC4PI.IPEDS_STATE length = 6,
      W1JXC4PI.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W1JXC4PI.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      W1JXC4PI.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W1JXC4PI.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W1JXC4PI.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W1JXC4PI.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W1JXC4PI.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      W1JXC4PI.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W1JXC4PI.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W1JXC4PI.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W1JXC4PI.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      W1JXC4PI.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      W1JXC4PI.Age length = 8,
      W1JXC4PI.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      W1JXC4PI.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      W1JXC4PI.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      W1JXC4PI.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      W1JXC4PI.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      W1JXC4PI.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      W1JXC4PI.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      W1JXC4PI.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      W1JXC4PI.ETHN_GRP length = 8,
      W1JXC4PI.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W1JXC4PI.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W1JXC4PI.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W1JXC4PI.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W1JXC4PI.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W1JXC4PI.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W1JXC4PI.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      W1JXC4PI.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      W1JXC4PI.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      W1JXC4PI.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      W1JXC4PI.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      W1JXC4PI.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      W1JXC4PI.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W1JXC4PI.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W1JXC4PI.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      W1JXC4PI.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      W1JXC4PI.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      W1JXC4PI.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W1JXC4PI.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      W1JXC4PI.IPEDS_FULL_PART_TIME_FLG length = 1,
      W1JXC4PI.IPEDS_SCH length = 8,
      W1JXC4PI.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      W1JXC4PI.IPEDS_FIPS_CD length = 8,
      W1JXC4PI.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      W1JXC4PI.SNAPSHOT_DT length = 8,
      W1JXC4PI.IPEDS_ETHNICITY length = 8,
      W1JXC4PI.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W1JXC4PI.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W1JXC4PI.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      W1JXC4PI.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W1JXC4PI.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W1JXC4PI.INIT_TERM length = 8,
      W1JXC4PI.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W1JXC4PI.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W1JXC4PI.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W1JXC4PI.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      W1JXC4PI.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      W1JXC4PI.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      W1JXC4PI.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      W1JXC4PI.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      W1JXC4PI.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      ADW_TERM_DIM.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      ADW_TERM_DIM.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      ADW_TERM_DIM.SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SHORT_DESCR',
      ADW_TERM_DIM.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      ADW_TERM_DIM.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADW_TERM_DIM.SESSION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'SESSION_DESCR',
      ADW_TERM_DIM.SESSION_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SESSION_SHORT_DESCR',
      ADW_TERM_DIM.WEEKS_OF_INSTRN length = 8
         label = 'WEEKS_OF_INSTRN',
      ADW_TERM_DIM.TERM_CATEGORY_CD length = 1
         format = $1.
         informat = $1.
         label = 'TERM_CATEGORY_CD',
      ADW_TERM_DIM.TERM_CATEGORY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TERM_CATEGORY_DESCR',
      ADW_TERM_DIM.TERM_CATEGORY_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'TERM_CATEGORY_SHORT_DESCR',
      ADW_TERM_DIM.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      ADW_TERM_DIM.SIXTY_PERCENT_DT length = 20
         format = $20.
         informat = $20.
         label = 'SIXTY_PERCENT_DT',
      ADW_TERM_DIM.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      ADW_TERM_DIM.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      ADW_TERM_DIM.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_TERM_DIM.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W4RA21MV.DEGREE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEGREE_DT',
      W1JXC4PI.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      W1JXC4PI.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      W1JXC4PI.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      W1JXC4PI.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.W1JXC4PI as W1JXC4PI inner join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            W1JXC4PI.ACAD_CAREER = ADW_TERM_DIM.ACAD_CAREER
            and W1JXC4PI.STRM = ADW_TERM_DIM.STRM
         ) left join
      work.W4RA21MV as W4RA21MV
         on
         (
            W1JXC4PI.EMPLID = W4RA21MV.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            check for prior ipeds entry           A5B29B8Q.BZ000C2Y *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    UTA_IPEDS_DATA_2017_Extract -         A5B29B8Q.BE000090 *
 *                   ADWSTGPR.UTA_IPEDS_DATA_2017_Extract                   *
 * Target Table:    Join - work.WLTFGYV8                  A5B29B8Q.BS0004DH *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2Y);

%let SYSLAST = %nrquote(ADWSTGPR.UTA_IPEDS_DATA_2017_Extract);

proc sql;
   create table work.WLTFGYV8 as
   select
      UTA_IPEDS_DATA_2017_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      UTA_IPEDS_DATA_2017_Extract.ACAD_LEVEL_BOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT_CD',
      UTA_IPEDS_DATA_2017_Extract.ACAD_LEVEL_BOT_DESC length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_LEVEL_BOT_DESC',
      UTA_IPEDS_DATA_2017_Extract.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      UTA_IPEDS_DATA_2017_Extract.ACT_COMPOSITE length = 8
         label = 'ACT_COMPOSITE',
      UTA_IPEDS_DATA_2017_Extract.ACT_ENGLISH length = 8
         label = 'ACT_ENGLISH',
      UTA_IPEDS_DATA_2017_Extract.ACT_MATH length = 8
         label = 'ACT_MATH',
      UTA_IPEDS_DATA_2017_Extract.ACT_WRITING length = 8
         label = 'ACT_WRITING',
      UTA_IPEDS_DATA_2017_Extract.ADDRESS1 length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      UTA_IPEDS_DATA_2017_Extract.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      UTA_IPEDS_DATA_2017_Extract.ADMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      UTA_IPEDS_DATA_2017_Extract.ADMIT_TYPE_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'ADMIT_TYPE_DESCR',
      UTA_IPEDS_DATA_2017_Extract.ANALYTICAL_PERCENTILE length = 8
         label = 'ANALYTICAL_PERCENTILE',
      UTA_IPEDS_DATA_2017_Extract.ANALYTICAL_SCORE length = 8
         label = 'ANALYTICAL_SCORE',
      UTA_IPEDS_DATA_2017_Extract.ANALYWRITING_PERCENTILE length = 8
         label = 'ANALYWRITING_PERCENTILE',
      UTA_IPEDS_DATA_2017_Extract.ANALYWRITING_SCORE length = 8
         label = 'ANALYWRITING_SCORE',
      UTA_IPEDS_DATA_2017_Extract.BIRTH_DATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DATE',
      UTA_IPEDS_DATA_2017_Extract.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      UTA_IPEDS_DATA_2017_Extract.CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      UTA_IPEDS_DATA_2017_Extract.CLASS_LOCATION_CD length = 10
         format = $10.
         informat = $10.
         label = 'CLASS_LOCATION_CD',
      UTA_IPEDS_DATA_2017_Extract.CLASS_NBR length = 8
         format = 20.
         informat = 20.
         label = 'CLASS_NBR',
      UTA_IPEDS_DATA_2017_Extract.CLASS_START_DATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CLASS_START_DATE',
      UTA_IPEDS_DATA_2017_Extract.COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      UTA_IPEDS_DATA_2017_Extract.COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      UTA_IPEDS_DATA_2017_Extract.COURSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'COURSE_ID',
      UTA_IPEDS_DATA_2017_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      UTA_IPEDS_DATA_2017_Extract.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      UTA_IPEDS_DATA_2017_Extract.ETHNIC_GRP_CD length = 8
         format = $8.
         informat = $8.
         label = 'ETHNIC_GRP_CD',
      UTA_IPEDS_DATA_2017_Extract.EXTS_EXT_GPA length = 8
         label = 'EXTS_EXT_GPA',
      UTA_IPEDS_DATA_2017_Extract.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      UTA_IPEDS_DATA_2017_Extract.GENDER length = 1
         format = $1.
         informat = $1.
         label = 'GENDER',
      UTA_IPEDS_DATA_2017_Extract.GMAT_PERCENTILE length = 8
         label = 'GMAT_PERCENTILE',
      UTA_IPEDS_DATA_2017_Extract.GMAT_TOTAL length = 8
         label = 'GMAT_TOTAL',
      UTA_IPEDS_DATA_2017_Extract.INIT_STRM length = 4
         format = $4.
         informat = $4.
         label = 'INIT_STRM',
      UTA_IPEDS_DATA_2017_Extract.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      UTA_IPEDS_DATA_2017_Extract.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'INSTRUCTION_MODE_DESCR',
      UTA_IPEDS_DATA_2017_Extract.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      UTA_IPEDS_DATA_2017_Extract.MAJOR1_CIP_CODE length = 13
         format = $13.
         informat = $13.
         label = 'MAJOR1_CIP_CODE',
      UTA_IPEDS_DATA_2017_Extract.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'MAJOR1_DEPT',
      UTA_IPEDS_DATA_2017_Extract.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'MAJOR1_PLAN',
      UTA_IPEDS_DATA_2017_Extract.MAJOR2_CIP_CODE length = 13
         format = $13.
         informat = $13.
         label = 'MAJOR2_CIP_CODE',
      UTA_IPEDS_DATA_2017_Extract.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'MAJOR2_DEPT',
      UTA_IPEDS_DATA_2017_Extract.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'MAJOR2_PLAN',
      UTA_IPEDS_DATA_2017_Extract.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      UTA_IPEDS_DATA_2017_Extract.MINOR1_CIP_CODE length = 13
         format = $13.
         informat = $13.
         label = 'MINOR1_CIP_CODE',
      UTA_IPEDS_DATA_2017_Extract.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'MINOR1_DEPT',
      UTA_IPEDS_DATA_2017_Extract.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'MINOR1_PLAN',
      UTA_IPEDS_DATA_2017_Extract.MINOR2_CIP_CODE length = 13
         format = $13.
         informat = $13.
         label = 'MINOR2_CIP_CODE',
      UTA_IPEDS_DATA_2017_Extract.MINOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'MINOR2_DEPT',
      UTA_IPEDS_DATA_2017_Extract.MINOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'MINOR2_PLAN',
      UTA_IPEDS_DATA_2017_Extract.OLD_GRE_IND length = 1
         format = $1.
         informat = $1.
         label = 'OLD_GRE_IND',
      UTA_IPEDS_DATA_2017_Extract.POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      UTA_IPEDS_DATA_2017_Extract.QUANTITATIVE_PERCENTILE length = 8
         label = 'QUANTITATIVE_PERCENTILE',
      UTA_IPEDS_DATA_2017_Extract.QUANTITATIVE_SCORE length = 8
         label = 'QUANTITATIVE_SCORE',
      UTA_IPEDS_DATA_2017_Extract.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'RESIDENCY',
      UTA_IPEDS_DATA_2017_Extract.SAT_CRITICAL_READING length = 8
         label = 'SAT_CRITICAL_READING',
      UTA_IPEDS_DATA_2017_Extract.SAT_ESSAY length = 8
         label = 'SAT_ESSAY',
      UTA_IPEDS_DATA_2017_Extract.SAT_MATH length = 8
         label = 'SAT_MATH',
      UTA_IPEDS_DATA_2017_Extract.SAT_WRITING length = 8
         label = 'SAT_WRITING',
      UTA_IPEDS_DATA_2017_Extract.SCH length = 8
         label = 'SCH',
      UTA_IPEDS_DATA_2017_Extract.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      UTA_IPEDS_DATA_2017_Extract.SNAPSHOTDATE length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SNAPSHOTDATE',
      UTA_IPEDS_DATA_2017_Extract.STATE length = 6
         format = $6.
         informat = $6.
         label = 'STATE',
      UTA_IPEDS_DATA_2017_Extract.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      UTA_IPEDS_DATA_2017_Extract.SUBJECT_CD length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT_CD',
      UTA_IPEDS_DATA_2017_Extract.VERBAL_PERCENTILE length = 8
         label = 'VERBAL_PERCENTILE',
      UTA_IPEDS_DATA_2017_Extract.VERBAL_SCORE length = 8
         label = 'VERBAL_SCORE',
      UTA_IPEDS_DATA_2017_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      UTA_IPEDS_DATA_2017_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.UTA_IPEDS_DATA_2017_Extract as UTA_IPEDS_DATA_2017_Extract
   where
      datepart(UTA_IPEDS_DATA_2017_Extract.SNAPSHOTDATE) = '14dec2017'd
   ;
quit;

/*==========================================================================*
 * Step:            append                                A5B29B8Q.BZ000C2Z *
 * Transform:       Append                                                  *
 * Description:     adds 2017 data with newer sas data                      *
 *                                                                          *
 * Source Tables:   Join - work.WLTFGYV8                  A5B29B8Q.BS0004DH *
 *                  IPEDS_Fall_Enrl_Hist -                A5B29B8Q.BE00019M *
 *                   IPEDSPRD.IPEDS_Fall_Enrl_Hist                          *
 * Target Table:    Append - work.W6V77OWA                A5B29B8Q.BS0004DI *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C2Z);


%let dbxrc = %eval(%sysfunc(exist(work.WLTFGYV8, DATA)) or
      %sysfunc(exist(work.WLTFGYV8, VIEW)));

proc sql;
   create view work.W2BEN5TI as
      select
         EMPLID,
         ACAD_CAREER,
         MAJOR1_DEPT,
         MAJOR2_DEPT,
         MINOR1_DEPT,
         STRM,
         FIRST_NAME,
         LAST_NAME,
         MIDDLE_NAME,
         GENDER length = 11
            format = $11.
            informat = $11.,
         MAJOR1_PLAN,
         MAJOR2_PLAN,
         MINOR1_PLAN,
         COURSE_ID length = 20
            format = $20.
            informat = $20.,
         CATALOG_NBR,
         INSTRUCTION_MODE,
         INSTRUCTION_MODE_DESCR,
         ENRL_ADD_DT,
         ADMIT_TERM,
         RESIDENCY,
         CLASS_NBR
   from work.WLTFGYV8
   ;
quit;

%let SYSLAST = work.W2BEN5TI;

%let dbxrc = %eval(%sysfunc(exist(IPEDSPRD.IPEDS_Fall_Enrl_Hist, DATA)) or
      %sysfunc(exist(IPEDSPRD.IPEDS_Fall_Enrl_Hist, VIEW)));

proc sql;
   create view work.W2BEN5TO as
      select
         MIN_ONE_ONLINE_COURSE_FLG,
         EMPLID,
         ENROLLED_WITHIN_12_MONTHS,
         AGE_GROUP,
         IPEDS_STATE,
         ACAD_CAREER,
         ACAD_PROGRAM,
         MAJOR1_DEPT,
         MAJOR2_DEPT,
         MINOR1_DEPT,
         STRM,
         ACAD_LEVEL_EOT_CD,
         ACAD_LEVEL_EOT_DESCR,
         FIRST_NAME,
         LAST_NAME,
         MIDDLE_NAME,
         BIRTH_DT,
         AGE,
         COHORT_TYPE,
         GENDER,
         HOME_ADDR,
         HOME_ADDR_CITY,
         HOME_ADDR_STATE,
         HOME_ADDR_POSTAL,
         HOME_ADDR_COUNTRY,
         HOME_ADDR_COUNTY,
         ETHN_GRP,
         MAJOR1_PLAN,
         MAJOR1_CIP_CD,
         MAJOR2_PLAN,
         MAJOR2_CIP_CD,
         MINOR1_PLAN,
         MINOR1_CIP_CD,
         COURSE_ID,
         CATALOG_NBR,
         SUBJECT,
         INSTRUCTION_MODE,
         CLASS_START_DT,
         CLASS_END_DT,
         CLASS_SECTION,
         INSTRUCTION_MODE_DESCR,
         ENRL_ADD_DT,
         SESSION_CD,
         UNIT_TAKEN,
         ADMIT_TERM,
         RESIDENCY,
         IPEDS_FULL_PART_TIME_FLG,
         IPEDS_SCH,
         IPEDS_DISTANCE_EDU_STATUS,
         IPEDS_FIPS_CD,
         CLASS_NBR,
         INIT_TERM,
         IPEDS_ETHNICITY,
         TERM_DESCR,
         ACAD_YEAR,
         CIP_CD_DESCR,
         SNAPSHOT_DT,
         ACAD_PROGRAM_DESCR,
         ACAD_CAREER_DESCR,
         DEPT,
         COLLEGE,
         COLLEGE_DESCR,
         DEPT_DESCR,
         RESIDENCY_DESCR,
         IPEDS_CITY,
         IPEDS_COUNTY,
         IPEDS_POSTAL,
         STUDENTRETENTIONCATEGORY,
         RETENTION_FLG,
         IPEDS_ADDR,
         IPEDS_COUNTRY,
         TUITION_RES,
         IPEDS_ETHNICITY_DESCR,
         ETHN_GRP_DESCR,
         TUITION_RESIDENCY_DESCR,
         OVERALL_RESIDENCY,
         Overall_Residency_Descr
   from IPEDSPRD.IPEDS_Fall_Enrl_Hist
   ;
quit;

%let SYSLAST = work.W2BEN5TO;

data work.W6V77OWA;
   set work.W2BEN5TI
       work.W2BEN5TO;
   keep MIN_ONE_ONLINE_COURSE_FLG EMPLID ENROLLED_WITHIN_12_MONTHS AGE_GROUP
    IPEDS_STATE ACAD_CAREER ACAD_PROGRAM MAJOR1_DEPT MAJOR2_DEPT MINOR1_DEPT STRM
    ACAD_LEVEL_EOT_CD ACAD_LEVEL_EOT_DESCR FIRST_NAME LAST_NAME MIDDLE_NAME
    BIRTH_DT AGE COHORT_TYPE GENDER HOME_ADDR HOME_ADDR_CITY HOME_ADDR_STATE
    HOME_ADDR_POSTAL HOME_ADDR_COUNTRY HOME_ADDR_COUNTY ETHN_GRP MAJOR1_PLAN
    MAJOR1_CIP_CD MAJOR2_PLAN MAJOR2_CIP_CD MINOR1_PLAN MINOR1_CIP_CD COURSE_ID
    CATALOG_NBR SUBJECT INSTRUCTION_MODE CLASS_START_DT CLASS_END_DT
    CLASS_SECTION INSTRUCTION_MODE_DESCR ENRL_ADD_DT SESSION_CD UNIT_TAKEN
    ADMIT_TERM RESIDENCY IPEDS_FULL_PART_TIME_FLG IPEDS_SCH
    IPEDS_DISTANCE_EDU_STATUS IPEDS_FIPS_CD CLASS_NBR INIT_TERM IPEDS_ETHNICITY
    TERM_DESCR ACAD_YEAR CIP_CD_DESCR SNAPSHOT_DT ACAD_PROGRAM_DESCR
    ACAD_CAREER_DESCR DEPT COLLEGE COLLEGE_DESCR DEPT_DESCR RESIDENCY_DESCR
    IPEDS_CITY IPEDS_COUNTY IPEDS_POSTAL STUDENTRETENTIONCATEGORY RETENTION_FLG
    IPEDS_ADDR IPEDS_COUNTRY TUITION_RES IPEDS_ETHNICITY_DESCR ETHN_GRP_DESCR
    TUITION_RESIDENCY_DESCR OVERALL_RESIDENCY Overall_Residency_Descr;
run;

/*==========================================================================*
 * Step:            check previous year                   A5B29B8Q.BZ000C30 *
 * Transform:       Join                                                    *
 * Description:     sets flag                                               *
 *                                                                          *
 * Source Tables:   Join - work.W3IG2WQL                  A5B29B8Q.BS0004DG *
 *                  Append - work.W6V77OWA                A5B29B8Q.BS0004DI *
 * Target Table:    Join - work.WDGEZOTS                  A5B29B8Q.BS0004DJ *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C30);

proc sql;
   create table work.WDGEZOTS as
   select distinct
      W3IG2WQL.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      W3IG2WQL.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W3IG2WQL.ENROLLED_WITHIN_12_MONTHS length = 8,
      W3IG2WQL.AGE_GROUP length = 20,
      W3IG2WQL.IPEDS_STATE length = 6,
      W3IG2WQL.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W3IG2WQL.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      W3IG2WQL.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W3IG2WQL.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W3IG2WQL.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W3IG2WQL.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W3IG2WQL.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      W3IG2WQL.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W3IG2WQL.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      W3IG2WQL.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      W3IG2WQL.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      W3IG2WQL.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      W3IG2WQL.Age length = 8,
      W3IG2WQL.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      W3IG2WQL.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      W3IG2WQL.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      W3IG2WQL.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      W3IG2WQL.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      W3IG2WQL.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      W3IG2WQL.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      W3IG2WQL.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      W3IG2WQL.ETHN_GRP length = 8,
      W3IG2WQL.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W3IG2WQL.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W3IG2WQL.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W3IG2WQL.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W3IG2WQL.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W3IG2WQL.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      W3IG2WQL.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      W3IG2WQL.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      W3IG2WQL.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      W3IG2WQL.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      W3IG2WQL.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      W3IG2WQL.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      W3IG2WQL.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      W3IG2WQL.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W3IG2WQL.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      W3IG2WQL.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      W3IG2WQL.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      W3IG2WQL.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W3IG2WQL.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      W3IG2WQL.IPEDS_FULL_PART_TIME_FLG length = 1,
      W3IG2WQL.IPEDS_SCH length = 8,
      W3IG2WQL.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      W3IG2WQL.IPEDS_FIPS_CD length = 8,
      W3IG2WQL.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      W3IG2WQL.SNAPSHOT_DT length = 8,
      W3IG2WQL.IPEDS_ETHNICITY length = 8,
      W3IG2WQL.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W3IG2WQL.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      W3IG2WQL.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      W3IG2WQL.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W3IG2WQL.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W3IG2WQL.INIT_TERM length = 8,
      W3IG2WQL.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      W3IG2WQL.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      W3IG2WQL.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      W3IG2WQL.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      W3IG2WQL.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      W3IG2WQL.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      W3IG2WQL.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      W3IG2WQL.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      W3IG2WQL.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      W3IG2WQL.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      W3IG2WQL.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W3IG2WQL.SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SHORT_DESCR',
      W3IG2WQL.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      W3IG2WQL.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      W3IG2WQL.SESSION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'SESSION_DESCR',
      W3IG2WQL.SESSION_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SESSION_SHORT_DESCR',
      W3IG2WQL.WEEKS_OF_INSTRN length = 8
         label = 'WEEKS_OF_INSTRN',
      W3IG2WQL.TERM_CATEGORY_CD length = 1
         format = $1.
         informat = $1.
         label = 'TERM_CATEGORY_CD',
      W3IG2WQL.TERM_CATEGORY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TERM_CATEGORY_DESCR',
      W3IG2WQL.TERM_CATEGORY_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'TERM_CATEGORY_SHORT_DESCR',
      W3IG2WQL.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      W3IG2WQL.SIXTY_PERCENT_DT length = 20
         format = $20.
         informat = $20.
         label = 'SIXTY_PERCENT_DT',
      W3IG2WQL.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      W3IG2WQL.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      W3IG2WQL.TERM_SK length = 8
         label = 'TERM_SK',
      W3IG2WQL.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      W3IG2WQL.DEGREE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEGREE_DT',
      case
      	when W6V77OWA.EMPLID is NOT null then 1
      	else 0
      end as RETENTION_FLG length = 8,
      W3IG2WQL.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      W3IG2WQL.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      W3IG2WQL.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      W3IG2WQL.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.W3IG2WQL as W3IG2WQL left join
      work.W6V77OWA as W6V77OWA
         on
         (
            W3IG2WQL.EMPLID = W6V77OWA.EMPLID
            and W3IG2WQL.STRM = &term.
            and W6V77OWA.STRM = &prev_year.
         )
   ;
quit;

/*==========================================================================*
 * Step:            summer_start                          A5B29B8Q.BZ000C31 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WDGEZOTS                  A5B29B8Q.BS0004DJ *
 * Target Table:    summer_start - work.summer_start      A5B29B8Q.BS0004DK *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C31);

%let SYSLAST = %nrquote(work.WDGEZOTS);

proc sql;
   create view work.summer_start as
   select
      WDGEZOTS.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      WDGEZOTS.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WDGEZOTS.ENROLLED_WITHIN_12_MONTHS length = 8,
      WDGEZOTS.AGE_GROUP length = 20,
      WDGEZOTS.IPEDS_STATE length = 6,
      WDGEZOTS.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WDGEZOTS.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      WDGEZOTS.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WDGEZOTS.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      WDGEZOTS.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      WDGEZOTS.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      WDGEZOTS.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      WDGEZOTS.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      WDGEZOTS.Age length = 8,
      WDGEZOTS.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      WDGEZOTS.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      WDGEZOTS.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      WDGEZOTS.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      WDGEZOTS.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      WDGEZOTS.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      WDGEZOTS.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      WDGEZOTS.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      WDGEZOTS.ETHN_GRP length = 8,
      WDGEZOTS.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      WDGEZOTS.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      WDGEZOTS.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      WDGEZOTS.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      WDGEZOTS.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      WDGEZOTS.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      WDGEZOTS.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      WDGEZOTS.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      WDGEZOTS.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      WDGEZOTS.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      WDGEZOTS.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WDGEZOTS.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WDGEZOTS.IPEDS_FULL_PART_TIME_FLG length = 1,
      WDGEZOTS.IPEDS_SCH length = 8,
      WDGEZOTS.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      WDGEZOTS.IPEDS_FIPS_CD length = 8,
      WDGEZOTS.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WDGEZOTS.SNAPSHOT_DT length = 8,
      WDGEZOTS.IPEDS_ETHNICITY length = 8,
      WDGEZOTS.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WDGEZOTS.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      WDGEZOTS.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.INIT_TERM length = 8,
      WDGEZOTS.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      WDGEZOTS.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      WDGEZOTS.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      WDGEZOTS.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      WDGEZOTS.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      WDGEZOTS.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WDGEZOTS.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      WDGEZOTS.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WDGEZOTS.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      WDGEZOTS.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SHORT_DESCR',
      WDGEZOTS.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      WDGEZOTS.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WDGEZOTS.SESSION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'SESSION_DESCR',
      WDGEZOTS.SESSION_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SESSION_SHORT_DESCR',
      WDGEZOTS.WEEKS_OF_INSTRN length = 8
         label = 'WEEKS_OF_INSTRN',
      WDGEZOTS.TERM_CATEGORY_CD length = 1
         format = $1.
         informat = $1.
         label = 'TERM_CATEGORY_CD',
      WDGEZOTS.TERM_CATEGORY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TERM_CATEGORY_DESCR',
      WDGEZOTS.TERM_CATEGORY_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'TERM_CATEGORY_SHORT_DESCR',
      WDGEZOTS.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      WDGEZOTS.SIXTY_PERCENT_DT length = 20
         format = $20.
         informat = $20.
         label = 'SIXTY_PERCENT_DT',
      WDGEZOTS.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      WDGEZOTS.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      WDGEZOTS.TERM_SK length = 8
         label = 'TERM_SK',
      WDGEZOTS.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WDGEZOTS.DEGREE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEGREE_DT',
      WDGEZOTS.RETENTION_FLG length = 8,
      WDGEZOTS.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      WDGEZOTS.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WDGEZOTS.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WDGEZOTS.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.WDGEZOTS as WDGEZOTS
   ;
quit;

/*==========================================================================*
 * Step:            cohort updates                        A5B29B8Q.BZ000C32 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WDGEZOTS                  A5B29B8Q.BS0004DJ *
 *                  summer_start - work.summer_start      A5B29B8Q.BS0004DK *
 * Target Table:    Join - work.WFTW7A1C                  A5B29B8Q.BS0004DL *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C32);

proc sql;
   create table work.WFTW7A1C as
   select distinct
      WDGEZOTS.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WDGEZOTS.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      case
      	when WDGEZOTS.EMPLID is not null and summer_start.EMPLID is not null then summer_start.COHORT_ENTRY
      	else WDGEZOTS.COHORT_ENTRY
      end as Adjusted_Cohort length = 50
   from
      work.WDGEZOTS as WDGEZOTS inner join
      work.summer_start as summer_start
         on
         (
            WDGEZOTS.STRM = &term.
            and summer_start.STRM = &summerterm.
            and WDGEZOTS.EMPLID = summer_start.EMPLID
            and WDGEZOTS.ACAD_CAREER = summer_start.ACAD_CAREER
         )
   ;
quit;

/*==========================================================================*
 * Step:            clone where strm=2188                 A5B29B8Q.BZ000C33 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WDGEZOTS                  A5B29B8Q.BS0004DJ *
 * Target Table:    Join - work.WFWT6RY9                  A5B29B8Q.BS0004DM *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C33);

%let SYSLAST = %nrquote(work.WDGEZOTS);

proc sql;
   create view work.WFWT6RY9 as
   select
      WDGEZOTS.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      WDGEZOTS.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WDGEZOTS.ENROLLED_WITHIN_12_MONTHS length = 8,
      WDGEZOTS.AGE_GROUP length = 20,
      WDGEZOTS.IPEDS_STATE length = 6,
      WDGEZOTS.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WDGEZOTS.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      WDGEZOTS.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WDGEZOTS.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      WDGEZOTS.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      WDGEZOTS.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      WDGEZOTS.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      WDGEZOTS.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      WDGEZOTS.Age length = 8,
      WDGEZOTS.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      WDGEZOTS.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      WDGEZOTS.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      WDGEZOTS.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      WDGEZOTS.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      WDGEZOTS.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      WDGEZOTS.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      WDGEZOTS.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      WDGEZOTS.ETHN_GRP length = 8,
      WDGEZOTS.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      WDGEZOTS.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      WDGEZOTS.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      WDGEZOTS.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      WDGEZOTS.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      WDGEZOTS.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      WDGEZOTS.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      WDGEZOTS.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      WDGEZOTS.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      WDGEZOTS.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      WDGEZOTS.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WDGEZOTS.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WDGEZOTS.IPEDS_FULL_PART_TIME_FLG length = 1,
      WDGEZOTS.IPEDS_SCH length = 8,
      WDGEZOTS.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      WDGEZOTS.IPEDS_FIPS_CD length = 8,
      WDGEZOTS.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WDGEZOTS.SNAPSHOT_DT length = 8,
      WDGEZOTS.IPEDS_ETHNICITY length = 8,
      WDGEZOTS.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WDGEZOTS.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      WDGEZOTS.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.INIT_TERM length = 8,
      WDGEZOTS.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      WDGEZOTS.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      WDGEZOTS.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      WDGEZOTS.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      WDGEZOTS.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      WDGEZOTS.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WDGEZOTS.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      WDGEZOTS.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WDGEZOTS.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      WDGEZOTS.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SHORT_DESCR',
      WDGEZOTS.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      WDGEZOTS.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WDGEZOTS.SESSION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'SESSION_DESCR',
      WDGEZOTS.SESSION_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SESSION_SHORT_DESCR',
      WDGEZOTS.WEEKS_OF_INSTRN length = 8
         label = 'WEEKS_OF_INSTRN',
      WDGEZOTS.TERM_CATEGORY_CD length = 1
         format = $1.
         informat = $1.
         label = 'TERM_CATEGORY_CD',
      WDGEZOTS.TERM_CATEGORY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TERM_CATEGORY_DESCR',
      WDGEZOTS.TERM_CATEGORY_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'TERM_CATEGORY_SHORT_DESCR',
      WDGEZOTS.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      WDGEZOTS.SIXTY_PERCENT_DT length = 20
         format = $20.
         informat = $20.
         label = 'SIXTY_PERCENT_DT',
      WDGEZOTS.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      WDGEZOTS.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      WDGEZOTS.TERM_SK length = 8
         label = 'TERM_SK',
      WDGEZOTS.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WDGEZOTS.DEGREE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEGREE_DT',
      WDGEZOTS.RETENTION_FLG length = 8,
      WDGEZOTS.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      WDGEZOTS.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WDGEZOTS.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WDGEZOTS.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.WDGEZOTS as WDGEZOTS
   where
      WDGEZOTS.STRM = &term.
   ;
quit;

/*==========================================================================*
 * Step:            students to drop                      A5B29B8Q.BZ000C34 *
 * Transform:       Set Operators                                           *
 * Description:     summer term                                             *
 *                                                                          *
 * Source Tables:   Join - work.WDGEZOTS                  A5B29B8Q.BS0004DJ *
 *                  Join - work.WFWT6RY9                  A5B29B8Q.BS0004DM *
 * Target Table:    Set Operators - work.WFV6HE5E         A5B29B8Q.BS0004DN *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C34);

proc sql;
   create table work.WFV6HE5E as
   /* Returns unique rows from the first query result that are not in the  */
   /*  second.                                                             */
   select distinct
      WDGEZOTS.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID'
   from
      work.WDGEZOTS
   where
      WDGEZOTS.STRM = &summerterm.
   except all
   select distinct
      WFWT6RY9.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID'
   from
      work.WFWT6RY9
   ;
quit;

%macro etls_completeTarget();
   /*---- Create the integrity constraints for a table  ----*/
   %put %str(NOTE: Creating integrity constraints ...);
   proc datasets library=work nolist;
      modify WFV6HE5E;
         ic create not null (EMPLID);
   quit;


%mend etls_completeTarget;
%etls_completeTarget;

/*==========================================================================*
 * Step:            filter out the summer only students   A5B29B8Q.BZ000C35 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WDGEZOTS                  A5B29B8Q.BS0004DJ *
 *                  Set Operators - work.WFV6HE5E         A5B29B8Q.BS0004DN *
 * Target Table:    Join - work.WFWUBPUN                  A5B29B8Q.BS0004DO *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C35);

proc sql;
   create table work.WFWUBPUN as
   select
      WDGEZOTS.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      WDGEZOTS.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WDGEZOTS.ENROLLED_WITHIN_12_MONTHS length = 8,
      WDGEZOTS.AGE_GROUP length = 20,
      WDGEZOTS.IPEDS_STATE length = 6,
      WDGEZOTS.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WDGEZOTS.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      WDGEZOTS.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WDGEZOTS.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      WDGEZOTS.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      WDGEZOTS.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      WDGEZOTS.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      WDGEZOTS.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      WDGEZOTS.Age length = 8,
      WDGEZOTS.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      WDGEZOTS.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      WDGEZOTS.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      WDGEZOTS.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      WDGEZOTS.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      WDGEZOTS.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      WDGEZOTS.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      WDGEZOTS.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      WDGEZOTS.ETHN_GRP length = 8,
      WDGEZOTS.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WDGEZOTS.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WDGEZOTS.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      WDGEZOTS.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      WDGEZOTS.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      WDGEZOTS.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      WDGEZOTS.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      WDGEZOTS.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      WDGEZOTS.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      WDGEZOTS.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      WDGEZOTS.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      WDGEZOTS.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      WDGEZOTS.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WDGEZOTS.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WDGEZOTS.IPEDS_FULL_PART_TIME_FLG length = 1,
      WDGEZOTS.IPEDS_SCH length = 8,
      WDGEZOTS.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      WDGEZOTS.IPEDS_FIPS_CD length = 8,
      WDGEZOTS.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WDGEZOTS.SNAPSHOT_DT length = 8,
      WDGEZOTS.IPEDS_ETHNICITY length = 8,
      WDGEZOTS.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WDGEZOTS.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      WDGEZOTS.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.INIT_TERM length = 8,
      WDGEZOTS.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WDGEZOTS.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      WDGEZOTS.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      WDGEZOTS.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      WDGEZOTS.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      WDGEZOTS.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      WDGEZOTS.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WDGEZOTS.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      WDGEZOTS.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WDGEZOTS.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      WDGEZOTS.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WDGEZOTS.SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SHORT_DESCR',
      WDGEZOTS.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      WDGEZOTS.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WDGEZOTS.SESSION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'SESSION_DESCR',
      WDGEZOTS.SESSION_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SESSION_SHORT_DESCR',
      WDGEZOTS.WEEKS_OF_INSTRN length = 8
         label = 'WEEKS_OF_INSTRN',
      WDGEZOTS.TERM_CATEGORY_CD length = 1
         format = $1.
         informat = $1.
         label = 'TERM_CATEGORY_CD',
      WDGEZOTS.TERM_CATEGORY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TERM_CATEGORY_DESCR',
      WDGEZOTS.TERM_CATEGORY_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'TERM_CATEGORY_SHORT_DESCR',
      WDGEZOTS.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      WDGEZOTS.SIXTY_PERCENT_DT length = 20
         format = $20.
         informat = $20.
         label = 'SIXTY_PERCENT_DT',
      WDGEZOTS.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      WDGEZOTS.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      WDGEZOTS.TERM_SK length = 8
         label = 'TERM_SK',
      WDGEZOTS.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WDGEZOTS.DEGREE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEGREE_DT',
      WDGEZOTS.RETENTION_FLG length = 8,
      WDGEZOTS.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      WDGEZOTS.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WDGEZOTS.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WDGEZOTS.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.WDGEZOTS as WDGEZOTS
   where
      WDGEZOTS.EMPLID NOT IN (
         select distinct
            WFV6HE5E.EMPLID length = 11
               format = $11.
               informat = $11.
               label = 'EMPLID'
         from
            work.WFV6HE5E as WFV6HE5E
         where
            WFV6HE5E.EMPLID = WDGEZOTS.EMPLID
      )
   ;
quit;

/*==========================================================================*
 * Step:            filter for only &term.                A5B29B8Q.BZ000C36 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.WFWUBPUN                  A5B29B8Q.BS0004DO *
 *                  Join - work.WFTW7A1C                  A5B29B8Q.BS0004DL *
 * Target Table:    Join - work.WFWWWEFU                  A5B29B8Q.BS0004DP *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C36);

proc sql;
   create table work.WFWWWEFU as
   select
      WFWUBPUN.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      WFWUBPUN.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WFWUBPUN.ENROLLED_WITHIN_12_MONTHS length = 8,
      WFWUBPUN.AGE_GROUP length = 20,
      WFWUBPUN.IPEDS_STATE length = 6,
      WFWUBPUN.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WFWUBPUN.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      WFWUBPUN.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WFWUBPUN.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WFWUBPUN.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WFWUBPUN.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WFWUBPUN.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      WFWUBPUN.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWUBPUN.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      WFWUBPUN.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      WFWUBPUN.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      WFWUBPUN.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      WFWUBPUN.Age length = 8,
      coalesce(WFTW7A1C.Adjusted_Cohort, WFWUBPUN.COHORT_ENTRY) as COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      WFWUBPUN.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      WFWUBPUN.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      WFWUBPUN.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      WFWUBPUN.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      WFWUBPUN.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      WFWUBPUN.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      WFWUBPUN.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      WFWUBPUN.ETHN_GRP length = 8,
      WFWUBPUN.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WFWUBPUN.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WFWUBPUN.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WFWUBPUN.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WFWUBPUN.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WFWUBPUN.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WFWUBPUN.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      WFWUBPUN.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      WFWUBPUN.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      WFWUBPUN.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      WFWUBPUN.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      WFWUBPUN.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      WFWUBPUN.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      WFWUBPUN.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWUBPUN.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      WFWUBPUN.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      WFWUBPUN.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      WFWUBPUN.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WFWUBPUN.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WFWUBPUN.IPEDS_FULL_PART_TIME_FLG length = 1,
      WFWUBPUN.IPEDS_SCH length = 8,
      WFWUBPUN.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      WFWUBPUN.IPEDS_FIPS_CD length = 8,
      WFWUBPUN.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WFWUBPUN.SNAPSHOT_DT length = 8,
      WFWUBPUN.IPEDS_ETHNICITY length = 8,
      WFWUBPUN.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWUBPUN.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WFWUBPUN.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      WFWUBPUN.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWUBPUN.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWUBPUN.INIT_TERM length = 8,
      WFWUBPUN.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WFWUBPUN.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      WFWUBPUN.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      WFWUBPUN.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      WFWUBPUN.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      WFWUBPUN.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      WFWUBPUN.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WFWUBPUN.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      WFWUBPUN.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WFWUBPUN.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      WFWUBPUN.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWUBPUN.SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SHORT_DESCR',
      WFWUBPUN.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      WFWUBPUN.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WFWUBPUN.SESSION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'SESSION_DESCR',
      WFWUBPUN.SESSION_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SESSION_SHORT_DESCR',
      WFWUBPUN.WEEKS_OF_INSTRN length = 8
         label = 'WEEKS_OF_INSTRN',
      WFWUBPUN.TERM_CATEGORY_CD length = 1
         format = $1.
         informat = $1.
         label = 'TERM_CATEGORY_CD',
      WFWUBPUN.TERM_CATEGORY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TERM_CATEGORY_DESCR',
      WFWUBPUN.TERM_CATEGORY_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'TERM_CATEGORY_SHORT_DESCR',
      WFWUBPUN.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      WFWUBPUN.SIXTY_PERCENT_DT length = 20
         format = $20.
         informat = $20.
         label = 'SIXTY_PERCENT_DT',
      WFWUBPUN.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      WFWUBPUN.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      WFWUBPUN.TERM_SK length = 8
         label = 'TERM_SK',
      WFWUBPUN.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WFWUBPUN.DEGREE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEGREE_DT',
      WFWUBPUN.RETENTION_FLG length = 8,
      WFWUBPUN.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      WFWUBPUN.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WFWUBPUN.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WFWUBPUN.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.WFWUBPUN as WFWUBPUN left join
      work.WFTW7A1C as WFTW7A1C
         on
         (
            WFWUBPUN.EMPLID = WFTW7A1C.EMPLID
         )
   having
      WFWUBPUN.STRM = &term.
   ;
quit;

/*==========================================================================*
 * Step:            new retention cohort logic            A5B29B8Q.BZ000C37 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 * Target Table:    Join - work.WLSLIK8M                  A5B29B8Q.BS0004DQ *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C37);

proc sql;
   create table work.WLSLIK8M as
   select
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_ACAD_CAREER_DIM.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY'
   from
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT inner join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) inner join
      ADWTGTPR.ADW_ACAD_PROGRAM_DIM as ADW_ACAD_PROGRAM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY = ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         )
   where
      ADW_STUDENT_TERM_ENRL_FACT.STUDENT_ENRL_FLG = 'Y'
   group by
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID,
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK,
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY
   having
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = min(ADW_STUDENT_TERM_ENRL_FACT.TERM_SK)
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000C38 *
 * Transform:       Join                                                    *
 * Description:     ethnic descriptions                                     *
 *                                                                          *
 * Source Tables:   Join - work.WFWWWEFU                  A5B29B8Q.BS0004DP *
 *                  Join - work.WLSLIK8M                  A5B29B8Q.BS0004DQ *
 * Target Table:    Join - work.WLSLD3OG                  A5B29B8Q.BS0004DR *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C38);

proc sql;
   create table work.WLSLD3OG as
   select
      WFWWWEFU.MIN_ONE_ONLINE_COURSE_FLG length = 1,
      WFWWWEFU.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WFWWWEFU.ENROLLED_WITHIN_12_MONTHS length = 8,
      WFWWWEFU.AGE_GROUP length = 20,
      WFWWWEFU.IPEDS_STATE length = 6,
      WFWWWEFU.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WFWWWEFU.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      WFWWWEFU.MAJOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WFWWWEFU.MAJOR2_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WFWWWEFU.MINOR1_DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WFWWWEFU.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WFWWWEFU.ACAD_LEVEL_EOT_CD length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      WFWWWEFU.ACAD_LEVEL_EOT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWWWEFU.FIRST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'FIRST_NAME',
      WFWWWEFU.LAST_NAME length = 30
         format = $30.
         informat = $30.
         label = 'LAST_NAME',
      WFWWWEFU.MIDDLE_NAME length = 30
         format = $30.
         informat = $30.
         label = 'MIDDLE_NAME',
      WFWWWEFU.BIRTH_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BIRTH_DT',
      WFWWWEFU.Age length = 8,
      WFWWWEFU.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      WFWWWEFU.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      WFWWWEFU.ADDRESS length = 55
         format = $55.
         informat = $55.
         label = 'HOME_ADDR_1',
      WFWWWEFU.HOME_ADDR_CITY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_CITY',
      WFWWWEFU.HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      WFWWWEFU.HOME_ADDR_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'HOME_ADDR_POSTAL',
      WFWWWEFU.HOME_ADDR_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'HOME_ADDR_COUNTRY',
      WFWWWEFU.HOME_ADDR_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'HOME_ADDR_GEOCODE',
      WFWWWEFU.ETHN_GRP length = 8,
      WFWWWEFU.MAJOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WFWWWEFU.MAJOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WFWWWEFU.MAJOR2_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WFWWWEFU.MAJOR2_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WFWWWEFU.MINOR1_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      WFWWWEFU.MINOR1_CIP_CD length = 130
         format = $130.
         informat = $130.
         label = 'CIP_CD',
      WFWWWEFU.COURSE_ID length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_IDENTIFIER',
      WFWWWEFU.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      WFWWWEFU.SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SUBJECT',
      WFWWWEFU.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      WFWWWEFU.CLASS_START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      WFWWWEFU.CLASS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      WFWWWEFU.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      WFWWWEFU.INSTRUCTION_MODE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWWWEFU.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      WFWWWEFU.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      WFWWWEFU.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      WFWWWEFU.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      WFWWWEFU.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      WFWWWEFU.IPEDS_FULL_PART_TIME_FLG length = 1,
      WFWWWEFU.IPEDS_SCH length = 8,
      WFWWWEFU.IPEDS_DISTANCE_EDUCATION_STATUS length = 100,
      WFWWWEFU.IPEDS_FIPS_CD length = 8,
      WFWWWEFU.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      WFWWWEFU.SNAPSHOT_DT length = 8,
      WFWWWEFU.IPEDS_ETHNICITY length = 8,
      WFWWWEFU.TERM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWWWEFU.ACAD_YEAR length = 8
         label = 'ACAD_YEAR',
      WFWWWEFU.CIP_CD_DESCR length = 254
         format = $254.
         informat = $254.
         label = 'DESCR',
      WFWWWEFU.ACAD_PROGRAM_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWWWEFU.ACAD_CAREER_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWWWEFU.INIT_TERM length = 8,
      WFWWWEFU.DEPT length = 10
         format = $10.
         informat = $10.
         label = 'DEPT',
      WFWWWEFU.COLLEGE length = 5
         format = $5.
         informat = $5.
         label = 'COLLEGE',
      WFWWWEFU.COLLEGE_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'COLLEGE_DESCR',
      WFWWWEFU.DEPT_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DEPT_DESCR',
      WFWWWEFU.TUITION_RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TUITION_RESIDENCY_DESCR',
      WFWWWEFU.IPEDS_CITY length = 30
         format = $30.
         informat = $30.
         label = 'CITY',
      WFWWWEFU.IPEDS_COUNTY length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WFWWWEFU.IPEDS_COUNTY_CODE length = 3
         format = $3.
         informat = $3.,
      WFWWWEFU.IPEDS_POSTAL length = 12
         format = $12.
         informat = $12.
         label = 'POSTAL',
      WFWWWEFU.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      WFWWWEFU.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      WFWWWEFU.SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SHORT_DESCR',
      WFWWWEFU.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      WFWWWEFU.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      WFWWWEFU.SESSION_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'SESSION_DESCR',
      WFWWWEFU.SESSION_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'SESSION_SHORT_DESCR',
      WFWWWEFU.WEEKS_OF_INSTRN length = 8
         label = 'WEEKS_OF_INSTRN',
      WFWWWEFU.TERM_CATEGORY_CD length = 1
         format = $1.
         informat = $1.
         label = 'TERM_CATEGORY_CD',
      WFWWWEFU.TERM_CATEGORY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'TERM_CATEGORY_DESCR',
      WFWWWEFU.TERM_CATEGORY_SHORT_DESCR length = 10
         format = $10.
         informat = $10.
         label = 'TERM_CATEGORY_SHORT_DESCR',
      WFWWWEFU.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      WFWWWEFU.SIXTY_PERCENT_DT length = 20
         format = $20.
         informat = $20.
         label = 'SIXTY_PERCENT_DT',
      WFWWWEFU.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      WFWWWEFU.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      WFWWWEFU.TERM_SK length = 8
         label = 'TERM_SK',
      WFWWWEFU.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      WFWWWEFU.DEGREE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DEGREE_DT',
      WFWWWEFU.RETENTION_FLG length = 8,
      WFWWWEFU.IPEDS_ADDR length = 55
         format = $55.
         informat = $55.
         label = 'ADDRESS1',
      WFWWWEFU.IPEDS_COUNTRY length = 3
         format = $3.
         informat = $3.
         label = 'COUNTRY',
      WFWWWEFU.TUITION_RES length = 5
         format = $5.
         informat = $5.
         label = 'TUITION_RES',
      case when ( WFWWWEFU.STRM =  coalescec(WLSLIK8M.STRM ,' ')) or (WLSLIK8M.STRM = ifc(substr(WFWWWEFU.STRM,4,1 )='8',   cats(substr(WFWWWEFU.STRM,1,3 ),'5')   ,'')) then  'New'

      else  'Continuing'
      end as STUDENTRETENTIONCATEGORY length = 20,
      ifc(substr(WFWWWEFU.STRM,4,1 )='8',   cats(substr(WFWWWEFU.STRM,1,3 ),'5')   ,'') as strm2 length = 8,
      case
      	when WFWWWEFU.IPEDS_ETHNICITY ='ASIAN' then 'Asian'
      	when WFWWWEFU.IPEDS_ETHNICITY ='HISPANIC' then 'Hispanic or Latino'
      	when WFWWWEFU.IPEDS_ETHNICITY ='WHITE' then 'White'
      	when WFWWWEFU.IPEDS_ETHNICITY ='MULTIPLE' then 'Multiple'
      	when WFWWWEFU.IPEDS_ETHNICITY ='NSPEC' then 'Race/ethnicity unknown'
      	when WFWWWEFU.IPEDS_ETHNICITY ='BLACK' then 'Black or African American'
      	when WFWWWEFU.IPEDS_ETHNICITY ='FORGN' then 'U.S. Nonresident'
      	when WFWWWEFU.IPEDS_ETHNICITY ='AMIND' then 'American Indian or Alaska Native'
      	when WFWWWEFU.IPEDS_ETHNICITY ='PACIF' then 'Native Hawaiian or Other Pacific Islander'
      else ''
      end as IPEDS_ETHNICITY_DESCR length = 50,
      case
      	when WFWWWEFU.ETHN_GRP ='ASIAN' then 'Asian'
      	when WFWWWEFU.ETHN_GRP ='HISPANIC' then 'Hispanic or Latino'
      	when WFWWWEFU.ETHN_GRP ='WHITE' then 'White'
      	when WFWWWEFU.ETHN_GRP ='MULTIPLE' then 'Multiple'
      	when WFWWWEFU.ETHN_GRP ='NSPEC' then 'Race/ethnicity unknown'
      	when WFWWWEFU.ETHN_GRP ='BLACK' then 'Black or African American'
      	when WFWWWEFU.ETHN_GRP ='FORGN' then 'U.S. Nonresident'
      	when WFWWWEFU.ETHN_GRP ='AMIND' then 'American Indian or Alaska Native'
      	when WFWWWEFU.ETHN_GRP ='PACIF' then 'Native Hawaiian or Other Pacific Islander'
      else ''
      end as ETHN_GRP_DESCR length = 50,
      WFWWWEFU.RESIDENCY_DESCR length = 30
         format = $30.
         informat = $30.
         label = 'RESIDENCY_DESCR'
   from
      work.WFWWWEFU as WFWWWEFU left join
      work.WLSLIK8M as WLSLIK8M
         on
         (
            WFWWWEFU.EMPLID = WLSLIK8M.EMPLID
            and WFWWWEFU.ACAD_CAREER = WLSLIK8M.ACAD_CAREER
            and WFWWWEFU.ACAD_PROGRAM = WLSLIK8M.ACAD_PROGRAM
         )
   ;
quit;

/*==========================================================================*
 * Step:            Table Loader                          A5B29B8Q.BZ000C39 *
 * Transform:       Table Loader (Version 2.1)                              *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WLSLD3OG                  A5B29B8Q.BS0004DR *
 * Target Table:    IPEDS_Fall_Enrl_Work -                A5B29B8Q.BE00019L *
 *                   IPEDSPRD.IPEDS_Fall_Enrl_Work                          *
 *==========================================================================*/

%let transformID = %quote(A5B29B8Q.BZ000C39);

%let SYSLAST = %nrquote(work.WLSLD3OG);

/* --------------------------------------------------------------
   Load Technique Selection: Replace - Truncate
   Constraint and index action selections: 'ASIS','ASIS','ASIS','ASIS'
   Additional options selections...
      Set unmapped to missing on updates: false
   -------------------------------------------------------------- */
%macro etls_loader;


   proc sql;
      create view work.W2BEN5YU as
         select
            MIN_ONE_ONLINE_COURSE_FLG
               format = $1.
               informat = $1.,
            EMPLID,
            ENROLLED_WITHIN_12_MONTHS,
            AGE_GROUP
               format = $20.
               informat = $20.,
            IPEDS_STATE
               format = $6.
               informat = $6.,
            ACAD_CAREER,
            ACAD_PROGRAM,
            MAJOR1_DEPT,
            MAJOR2_DEPT,
            MINOR1_DEPT,
            STRM,
            ACAD_LEVEL_EOT_CD,
            ACAD_LEVEL_EOT_DESCR,
            FIRST_NAME,
            LAST_NAME,
            MIDDLE_NAME,
            BIRTH_DT,
            AGE,
            COHORT_ENTRY as COHORT_TYPE,
            GENDER,
            ADDRESS as HOME_ADDR,
            HOME_ADDR_CITY,
            HOME_ADDR_STATE,
            HOME_ADDR_POSTAL,
            HOME_ADDR_COUNTRY,
            HOME_ADDR_COUNTY,
            ETHN_GRP
               format = $8.
               informat = $8.,
            MAJOR1_PLAN,
            MAJOR1_CIP_CD,
            MAJOR2_PLAN,
            MAJOR2_CIP_CD,
            MINOR1_PLAN,
            MINOR1_CIP_CD,
            COURSE_ID,
            CATALOG_NBR,
            SUBJECT,
            INSTRUCTION_MODE,
            CLASS_START_DT,
            CLASS_END_DT,
            CLASS_SECTION,
            INSTRUCTION_MODE_DESCR,
            ENRL_ADD_DT,
            SESSION_CD,
            UNIT_TAKEN,
            ADMIT_TERM,
            RESIDENCY,
            IPEDS_FULL_PART_TIME_FLG
               format = $1.
               informat = $1.,
            IPEDS_SCH,
            IPEDS_DISTANCE_EDUCATION_STATUS as IPEDS_DISTANCE_EDU_STATUS
               format = $100.
               informat = $100.,
            IPEDS_FIPS_CD,
            CLASS_NBR,
            INIT_TERM
               format = $8.
               informat = $8.,
            IPEDS_ETHNICITY
               format = $8.
               informat = $8.,
            TERM_DESCR,
            ACAD_YEAR,
            CIP_CD_DESCR,
            SNAPSHOT_DT
               format = DATETIME20.
               informat = DATETIME20.,
            ACAD_PROGRAM_DESCR,
            ACAD_CAREER_DESCR,
            DEPT,
            COLLEGE,
            COLLEGE_DESCR,
            DEPT_DESCR,
            IPEDS_CITY,
            IPEDS_COUNTY,
            IPEDS_POSTAL,
            STUDENTRETENTIONCATEGORY
               format = $20.
               informat = $20.,
            RETENTION_FLG,
            IPEDS_ADDR,
            IPEDS_COUNTRY,
            TUITION_RES,
            IPEDS_ETHNICITY_DESCR
               format = $50.
               informat = $50.,
            ETHN_GRP_DESCR
               format = $50.
               informat = $50.,
            TUITION_RESIDENCY_DESCR,
            RESIDENCY_DESCR,
            (datetime()) as LOAD_DT length = 8
      from &etls_lastTable
      ;
   quit;

   %let SYSLAST = work.W2BEN5YU;


   /* Determine if the target table exists  */
         %sysfunc(exist(IPEDSPRD.IPEDS_Fall_Enrl_Work, VIEW)));

   /*---- Create a new table  ----*/
   %if (&etls_tableExist eq 0) %then
   %do;  /* if table does not exist  */

      %put %str(NOTE: Creating table ...);

      data IPEDSPRD.IPEDS_Fall_Enrl_Work
              (dbnull = (
                         MIN_ONE_ONLINE_COURSE_FLG = YES
                         EMPLID = NO
                         ENROLLED_WITHIN_12_MONTHS = YES
                         AGE_GROUP = YES
                         IPEDS_STATE = YES
                         ACAD_CAREER = YES
                         ACAD_PROGRAM = YES
                         MAJOR1_DEPT = YES
                         MAJOR2_DEPT = YES
                         MINOR1_DEPT = YES
                         STRM = YES
                         ACAD_LEVEL_EOT_CD = YES
                         ACAD_LEVEL_EOT_DESCR = YES
                         FIRST_NAME = YES
                         LAST_NAME = YES
                         MIDDLE_NAME = YES
                         BIRTH_DT = YES
                         AGE = YES
                         COHORT_TYPE = YES
                         GENDER = YES
                         HOME_ADDR = YES
                         HOME_ADDR_CITY = YES
                         HOME_ADDR_STATE = YES
                         HOME_ADDR_POSTAL = YES
                         HOME_ADDR_COUNTRY = YES
                         HOME_ADDR_COUNTY = YES
                         ETHN_GRP = YES
                         MAJOR1_PLAN = YES
                         MAJOR1_CIP_CD = YES
                         MAJOR2_PLAN = YES
                         MAJOR2_CIP_CD = YES
                         MINOR1_PLAN = YES
                         MINOR1_CIP_CD = YES
                         COURSE_ID = YES
                         CATALOG_NBR = YES
                         SUBJECT = YES
                         INSTRUCTION_MODE = YES
                         CLASS_START_DT = YES
                         CLASS_END_DT = YES
                         CLASS_SECTION = YES
                         INSTRUCTION_MODE_DESCR = YES
                         ENRL_ADD_DT = YES
                         SESSION_CD = YES
                         UNIT_TAKEN = YES
                         ADMIT_TERM = YES
                         RESIDENCY = YES
                         IPEDS_FULL_PART_TIME_FLG = YES
                         IPEDS_SCH = YES
                         IPEDS_DISTANCE_EDU_STATUS = YES
                         IPEDS_FIPS_CD = YES
                         CLASS_NBR = NO
                         INIT_TERM = YES
                         IPEDS_ETHNICITY = YES
                         TERM_DESCR = YES
                         ACAD_YEAR = YES
                         CIP_CD_DESCR = YES
                         SNAPSHOT_DT = YES
                         ACAD_PROGRAM_DESCR = YES
                         ACAD_CAREER_DESCR = YES
                         DEPT = YES
                         COLLEGE = YES
                         COLLEGE_DESCR = YES
                         DEPT_DESCR = YES
                         IPEDS_CITY = YES
                         IPEDS_COUNTY = YES
                         IPEDS_POSTAL = YES
                         STUDENTRETENTIONCATEGORY = YES
                         RETENTION_FLG = YES
                         IPEDS_ADDR = YES
                         IPEDS_COUNTRY = YES
                         TUITION_RES = YES
                         IPEDS_ETHNICITY_DESCR = YES
                         ETHN_GRP_DESCR = YES
                         TUITION_RESIDENCY_DESCR = YES
                         RESIDENCY_DESCR = YES
                         LOAD_DT = YES));
         attrib MIN_ONE_ONLINE_COURSE_FLG length = $1
            format = $1.
            informat = $1.
            label = 'MIN_ONE_ONLINE_COURSE_FLG';
         attrib EMPLID length = $11
            format = $11.
            informat = $11.
            label = 'EMPLID';
         attrib ENROLLED_WITHIN_12_MONTHS length = 8
            label = 'ENROLLED_WITHIN_12_MONTHS';
         attrib AGE_GROUP length = $20
            format = $20.
            informat = $20.
            label = 'AGE_GROUP';
         attrib IPEDS_STATE length = $6
            format = $6.
            informat = $6.
            label = 'IPEDS_STATE';
         attrib ACAD_CAREER length = $4
            format = $4.
            informat = $4.
            label = 'ACAD_CAREER';
         attrib ACAD_PROGRAM length = $5
            format = $5.
            informat = $5.
            label = 'ACAD_PROGRAM';
         attrib MAJOR1_DEPT length = $10
            format = $10.
            informat = $10.
            label = 'MAJOR1_DEPT';
         attrib MAJOR2_DEPT length = $10
            format = $10.
            informat = $10.
            label = 'MAJOR2_DEPT';
         attrib MINOR1_DEPT length = $10
            format = $10.
            informat = $10.
            label = 'MINOR1_DEPT';
         attrib STRM length = $4
            format = $4.
            informat = $4.
            label = 'STRM';
         attrib ACAD_LEVEL_EOT_CD length = $3
            format = $3.
            informat = $3.
            label = 'ACAD_LEVEL_EOT_CD';
         attrib ACAD_LEVEL_EOT_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'ACAD_LEVEL_EOT_DESCR';
         attrib FIRST_NAME length = $30
            format = $30.
            informat = $30.
            label = 'FIRST_NAME';
         attrib LAST_NAME length = $30
            format = $30.
            informat = $30.
            label = 'LAST_NAME';
         attrib MIDDLE_NAME length = $30
            format = $30.
            informat = $30.
            label = 'MIDDLE_NAME';
         attrib BIRTH_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'BIRTH_DT';
         attrib AGE length = 8
            label = 'AGE';
         attrib COHORT_TYPE length = $50
            format = $50.
            informat = $50.
            label = 'COHORT_TYPE';
         attrib GENDER length = $11
            format = $11.
            informat = $11.
            label = 'GENDER';
         attrib HOME_ADDR length = $55
            format = $55.
            informat = $55.
            label = 'HOME_ADDR';
         attrib HOME_ADDR_CITY length = $30
            format = $30.
            informat = $30.
            label = 'HOME_ADDR_CITY';
         attrib HOME_ADDR_STATE length = $6
            format = $6.
            informat = $6.
            label = 'HOME_ADDR_STATE';
         attrib HOME_ADDR_POSTAL length = $12
            format = $12.
            informat = $12.
            label = 'HOME_ADDR_POSTAL';
         attrib HOME_ADDR_COUNTRY length = $3
            format = $3.
            informat = $3.
            label = 'HOME_ADDR_COUNTRY';
         attrib HOME_ADDR_COUNTY length = $30
            format = $30.
            informat = $30.
            label = 'HOME_ADDR_COUNTY';
         attrib ETHN_GRP length = $8
            format = $8.
            informat = $8.
            label = 'ETHN_GRP';
         attrib MAJOR1_PLAN length = $10
            format = $10.
            informat = $10.
            label = 'MAJOR1_PLAN';
         attrib MAJOR1_CIP_CD length = $130
            format = $130.
            informat = $130.
            label = 'MAJOR1_CIP_CD';
         attrib MAJOR2_PLAN length = $10
            format = $10.
            informat = $10.
            label = 'MAJOR2_PLAN';
         attrib MAJOR2_CIP_CD length = $130
            format = $130.
            informat = $130.
            label = 'MAJOR2_CIP_CD';
         attrib MINOR1_PLAN length = $10
            format = $10.
            informat = $10.
            label = 'MINOR1_PLAN';
         attrib MINOR1_CIP_CD length = $130
            format = $130.
            informat = $130.
            label = 'MINOR1_CIP_CD';
         attrib COURSE_ID length = $20
            format = $20.
            informat = $20.
            label = 'COURSE_ID';
         attrib CATALOG_NBR length = $10
            format = $10.
            informat = $10.
            label = 'CATALOG_NBR';
         attrib SUBJECT length = $8
            format = $8.
            informat = $8.
            label = 'SUBJECT';
         attrib INSTRUCTION_MODE length = $2
            format = $2.
            informat = $2.
            label = 'INSTRUCTION_MODE';
         attrib CLASS_START_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'CLASS_START_DT';
         attrib CLASS_END_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'CLASS_END_DT';
         attrib CLASS_SECTION length = $4
            format = $4.
            informat = $4.
            label = 'CLASS_SECTION';
         attrib INSTRUCTION_MODE_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'INSTRUCTION_MODE_DESCR';
         attrib ENRL_ADD_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'ENRL_ADD_DT';
         attrib SESSION_CD length = $20
            format = $20.
            informat = $20.
            label = 'SESSION_CD';
         attrib UNIT_TAKEN length = 8
            label = 'UNIT_TAKEN';
         attrib ADMIT_TERM length = $4
            format = $4.
            informat = $4.
            label = 'ADMIT_TERM';
         attrib RESIDENCY length = $5
            format = $5.
            informat = $5.
            label = 'RESIDENCY';
         attrib IPEDS_FULL_PART_TIME_FLG length = $1
            format = $1.
            informat = $1.
            label = 'IPEDS_FULL_PART_TIME_FLG';
         attrib IPEDS_SCH length = 8
            label = 'IPEDS_SCH';
         attrib IPEDS_DISTANCE_EDU_STATUS length = $100
            format = $100.
            informat = $100.
            label = 'IPEDS_DISTANCE_EDU_STATUS';
         attrib IPEDS_FIPS_CD length = 8
            label = 'IPEDS_FIPS_CD';
         attrib CLASS_NBR length = 8
            label = 'CLASS_NBR';
         attrib INIT_TERM length = $8
            format = $8.
            informat = $8.
            label = 'INIT_TERM';
         attrib IPEDS_ETHNICITY length = $8
            format = $8.
            informat = $8.
            label = 'IPEDS_ETHNICITY';
         attrib TERM_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'TERM_DESCR';
         attrib ACAD_YEAR length = 8
            label = 'ACAD_YEAR';
         attrib CIP_CD_DESCR length = $254
            format = $254.
            informat = $254.
            label = 'CIP_CD_DESCR';
         attrib SNAPSHOT_DT length = 8
            format = DATETIME20.
            informat = DATETIME20.
            label = 'SNAPSHOT_DT';
         attrib ACAD_PROGRAM_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'ACAD_PROGRAM_DESCR';
         attrib ACAD_CAREER_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'ACAD_CAREER_DESCR';
         attrib DEPT length = $10
            format = $10.
            informat = $10.
            label = 'DEPT';
         attrib COLLEGE length = $5
            format = $5.
            informat = $5.
            label = 'COLLEGE';
         attrib COLLEGE_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'COLLEGE_DESCR';
         attrib DEPT_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'DEPT_DESCR';
         attrib IPEDS_CITY length = $30
            format = $30.
            informat = $30.
            label = 'IPEDS_CITY';
         attrib IPEDS_COUNTY length = $30
            format = $30.
            informat = $30.
            label = 'IPEDS_COUNTY';
         attrib IPEDS_POSTAL length = $12
            format = $12.
            informat = $12.
            label = 'IPEDS_POSTAL';
         attrib STUDENTRETENTIONCATEGORY length = $20
            format = $20.
            informat = $20.
            label = 'STUDENTRETENTIONCATEGORY';
         attrib RETENTION_FLG length = 8
            label = 'RETENTION_FLG';
         attrib IPEDS_ADDR length = $55
            format = $55.
            informat = $55.
            label = 'IPEDS_ADDR';
         attrib IPEDS_COUNTRY length = $3
            format = $3.
            informat = $3.
            label = 'IPEDS_COUNTRY';
         attrib TUITION_RES length = $5
            format = $5.
            informat = $5.
            label = 'TUITION_RES';
         attrib IPEDS_ETHNICITY_DESCR length = $50
            format = $50.
            informat = $50.
            label = 'IPEDS_ETHNICITY_DESCR';
         attrib ETHN_GRP_DESCR length = $50
            format = $50.
            informat = $50.
            label = 'ETHN_GRP_DESCR';
         attrib TUITION_RESIDENCY_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'TUITION_RESIDENCY_DESCR';
         attrib RESIDENCY_DESCR length = $30
            format = $30.
            informat = $30.
            label = 'RESIDENCY_DESCR';
         attrib LOAD_DT length = 8;
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
             DEFER=YES DBSERVER_MAX_BYTES=1 DBCLIENT_MAX_BYTES=1 ADJUST_BYTE_SEMANTIC_COLUMN_LENGTHS=NO ADJUST_NCHAR_COLUMN_LENGTHS=YES PATH=UTAAWSPD AUTHDOMAIN="IPEDSPRD"
         );
         reset noprint;

         execute
         (
            truncate table IPEDSPRD.IPEDS_FALL_ENRL_WORK
         ) by ORACLE;

         %rcSet(&sqlrc);

         disconnect from ORACLE;
      quit;


   %end; /* table exists */

   /*---- Append  ----*/
   %put %str(NOTE: Appending data ...);

   proc append base = IPEDSPRD.IPEDS_Fall_Enrl_Work
      data = &etls_lastTable (&etls_tableOptions)  force ;
    run;


   %mend etls_loader;
%etls_loader;
