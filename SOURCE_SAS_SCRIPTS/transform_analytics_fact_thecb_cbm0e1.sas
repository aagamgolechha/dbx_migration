/* Parameter default value(s) for 400_LOAD_CBM0E1  */
%let term = ;
%let prev_term = ;
%let term_end_dt = ;
%let two_year_prev_term = ;
%let term_sk_filter = ;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BN6 *
 * Transform:       Join                                                    *
 * Description:     Extract Session_CD = 1 & 5W2                            *
 *                                                                          *
 * Source Table:    PS_SESSION_TBL_Extract -              A5B29B8Q.BE00005Q *
 *                   ADWSTGPR.PS_SESSION_TBL_Extract                        *
 * Target Table:    Join - work.WYYD5YLE                  A5B29B8Q.BS000411 *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_SESSION_TBL_Extract);


proc sql;
   create table work.WYYD5YLE as
   select
      PS_SESSION_TBL_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_SESSION_TBL_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_SESSION_TBL_Extract.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_SESSION_TBL_Extract.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      PS_SESSION_TBL_Extract.SESS_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SESS_BEGIN_DT',
      PS_SESSION_TBL_Extract.SESS_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SESS_END_DT',
      PS_SESSION_TBL_Extract.ENROLL_OPEN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENROLL_OPEN_DT',
      PS_SESSION_TBL_Extract.SESSN_ENRL_CNTL length = 3
         format = $3.
         informat = $3.
         label = 'SESSN_ENRL_CNTL',
      PS_SESSION_TBL_Extract.SESSN_APPT_CNTL length = 3
         format = $3.
         informat = $3.
         label = 'SESSN_APPT_CNTL',
      PS_SESSION_TBL_Extract.FIRST_ENRL_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'FIRST_ENRL_DT',
      PS_SESSION_TBL_Extract.LAST_ENRL_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_ENRL_DT',
      PS_SESSION_TBL_Extract.LAST_WAIT_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'LAST_WAIT_DT',
      PS_SESSION_TBL_Extract.HOLIDAY_SCHEDULE length = 6
         format = $6.
         informat = $6.
         label = 'HOLIDAY_SCHEDULE',
      PS_SESSION_TBL_Extract.WEEKS_OF_INSTRUCT length = 8
         label = 'WEEKS_OF_INSTRUCT',
      PS_SESSION_TBL_Extract.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      PS_SESSION_TBL_Extract.USE_DYN_CLASS_DATE length = 1
         format = $1.
         informat = $1.
         label = 'USE_DYN_CLASS_DATE',
      PS_SESSION_TBL_Extract.SIXTY_PCT_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SIXTY_PCT_DT',
      PS_SESSION_TBL_Extract.FACILITY_ASSIGNMNT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'FACILITY_ASSIGNMNT',
      PS_SESSION_TBL_Extract.SSR_ENR_APT_APPROV length = 1
         format = $1.
         informat = $1.
         label = 'SSR_ENR_APT_APPROV',
      PS_SESSION_TBL_Extract.SSR_VAL_APT_APPROV length = 1
         format = $1.
         informat = $1.
         label = 'SSR_VAL_APT_APPROV',
      PS_SESSION_TBL_Extract.SSR_SSPLNRDISP_BDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SSR_SSPLNRDISP_BDT',
      PS_SESSION_TBL_Extract.SSR_SSPLNRDISP_EDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SSR_SSPLNRDISP_EDT',
      PS_SESSION_TBL_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_SESSION_TBL_Extract.STG_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STG_UPDATE_ID'
   from
      ADWSTGPR.PS_SESSION_TBL_Extract as PS_SESSION_TBL_Extract
   where
      ((PS_SESSION_TBL_Extract.SESSION_CODE = '1'
      and substr(PS_SESSION_TBL_Extract.STRM,4,1) IN ('2','8'))
      or (PS_SESSION_TBL_Extract.SESSION_CODE = '5W2'
      and substr(PS_SESSION_TBL_Extract.STRM,4,1) = '5'))
   order by
      PS_SESSION_TBL_Extract.STRM
   ;
quit;

/*==========================================================================*
 * Step:            User Written STRM MACROS              A5B29B8Q.BZ000BN7 *
 * Transform:       User Written                                            *
 * Description:     Get Previous Census Date & STRM & Macro setup           *
 *                                                                          *
 * Source Table:    Join - work.WYYD5YLE                  A5B29B8Q.BS000411 *
 * Target Table:    User Written - work.WYYEB9MI          A5B29B8Q.BS000412 *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.WYYD5YLE);


%let _INPUT1_filetype = WorkTable;

%let _OUTPUT = work.WYYEB9MI;
        ENROLL_OPEN_DT SESSN_ENRL_CNTL SESSN_APPT_CNTL FIRST_ENRL_DT
        LAST_ENRL_DT LAST_WAIT_DT HOLIDAY_SCHEDULE WEEKS_OF_INSTRUCT CENSUS_DT
        USE_DYN_CLASS_DATE SIXTY_PCT_DT FACILITY_ASSIGNMNT SSR_ENR_APT_APPROV
        SSR_VAL_APT_APPROV SSR_SSPLNRDISP_BDT SSR_SSPLNRDISP_EDT READ_DTM
        STG_UPDATE_ID PREV_CENSUS_DT PREV_STRM;

        ENROLL_OPEN_DT SESSN_ENRL_CNTL SESSN_APPT_CNTL FIRST_ENRL_DT
        LAST_ENRL_DT LAST_WAIT_DT HOLIDAY_SCHEDULE WEEKS_OF_INSTRUCT CENSUS_DT
        USE_DYN_CLASS_DATE SIXTY_PCT_DT FACILITY_ASSIGNMNT SSR_ENR_APT_APPROV
        SSR_VAL_APT_APPROV SSR_SSPLNRDISP_BDT SSR_SSPLNRDISP_EDT READ_DTM
        STG_UPDATE_ID PREV_CENSUS_DT PREV_STRM;
%let _OUTPUT1_col_count = 26;
%let _OUTPUT1_col0_name = INSTITUTION;
%let _OUTPUT1_col0_table = work.WYYEB9MI;
%let _OUTPUT1_col0_length = 5;
%let _OUTPUT1_col0_type = $;
%let _OUTPUT1_col0_format = $5.;
%let _OUTPUT1_col0_informat = $5.;
%let _OUTPUT1_col0_label = %nrquote(INSTITUTION);
%let _OUTPUT1_col0_input0 = INSTITUTION;
%let _OUTPUT1_col0_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col0_exp = ;
%let _OUTPUT1_col0_input = INSTITUTION;
%let _OUTPUT1_col0_input_count = 1;
%let _OUTPUT1_col1_name = ACAD_CAREER;
%let _OUTPUT1_col1_table = work.WYYEB9MI;
%let _OUTPUT1_col1_length = 4;
%let _OUTPUT1_col1_type = $;
%let _OUTPUT1_col1_format = $4.;
%let _OUTPUT1_col1_informat = $4.;
%let _OUTPUT1_col1_label = %nrquote(ACAD_CAREER);
%let _OUTPUT1_col1_input0 = ACAD_CAREER;
%let _OUTPUT1_col1_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col1_exp = ;
%let _OUTPUT1_col1_input = ACAD_CAREER;
%let _OUTPUT1_col1_input_count = 1;
%let _OUTPUT1_col2_name = STRM;
%let _OUTPUT1_col2_table = work.WYYEB9MI;
%let _OUTPUT1_col2_length = 4;
%let _OUTPUT1_col2_type = $;
%let _OUTPUT1_col2_format = $4.;
%let _OUTPUT1_col2_informat = $4.;
%let _OUTPUT1_col2_label = %nrquote(STRM);
%let _OUTPUT1_col2_input0 = STRM;
%let _OUTPUT1_col2_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col2_exp = ;
%let _OUTPUT1_col2_input = STRM;
%let _OUTPUT1_col2_input_count = 1;
%let _OUTPUT1_col3_name = SESSION_CODE;
%let _OUTPUT1_col3_table = work.WYYEB9MI;
%let _OUTPUT1_col3_length = 3;
%let _OUTPUT1_col3_type = $;
%let _OUTPUT1_col3_format = $3.;
%let _OUTPUT1_col3_informat = $3.;
%let _OUTPUT1_col3_label = %nrquote(SESSION_CODE);
%let _OUTPUT1_col3_input0 = SESSION_CODE;
%let _OUTPUT1_col3_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col3_exp = ;
%let _OUTPUT1_col3_input = SESSION_CODE;
%let _OUTPUT1_col3_input_count = 1;
%let _OUTPUT1_col4_name = SESS_BEGIN_DT;
%let _OUTPUT1_col4_table = work.WYYEB9MI;
%let _OUTPUT1_col4_length = 8;
%let _OUTPUT1_col4_type = ;
%let _OUTPUT1_col4_format = DATETIME20.;
%let _OUTPUT1_col4_informat = DATETIME20.;
%let _OUTPUT1_col4_label = %nrquote(SESS_BEGIN_DT);
%let _OUTPUT1_col4_input0 = SESS_BEGIN_DT;
%let _OUTPUT1_col4_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col4_exp = ;
%let _OUTPUT1_col4_input = SESS_BEGIN_DT;
%let _OUTPUT1_col4_input_count = 1;
%let _OUTPUT1_col5_name = SESS_END_DT;
%let _OUTPUT1_col5_table = work.WYYEB9MI;
%let _OUTPUT1_col5_length = 8;
%let _OUTPUT1_col5_type = ;
%let _OUTPUT1_col5_format = DATETIME20.;
%let _OUTPUT1_col5_informat = DATETIME20.;
%let _OUTPUT1_col5_label = %nrquote(SESS_END_DT);
%let _OUTPUT1_col5_input0 = SESS_END_DT;
%let _OUTPUT1_col5_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col5_exp = ;
%let _OUTPUT1_col5_input = SESS_END_DT;
%let _OUTPUT1_col5_input_count = 1;
%let _OUTPUT1_col6_name = ENROLL_OPEN_DT;
%let _OUTPUT1_col6_table = work.WYYEB9MI;
%let _OUTPUT1_col6_length = 8;
%let _OUTPUT1_col6_type = ;
%let _OUTPUT1_col6_format = DATETIME20.;
%let _OUTPUT1_col6_informat = DATETIME20.;
%let _OUTPUT1_col6_label = %nrquote(ENROLL_OPEN_DT);
%let _OUTPUT1_col6_input0 = ENROLL_OPEN_DT;
%let _OUTPUT1_col6_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col6_exp = ;
%let _OUTPUT1_col6_input = ENROLL_OPEN_DT;
%let _OUTPUT1_col6_input_count = 1;
%let _OUTPUT1_col7_name = SESSN_ENRL_CNTL;
%let _OUTPUT1_col7_table = work.WYYEB9MI;
%let _OUTPUT1_col7_length = 3;
%let _OUTPUT1_col7_type = $;
%let _OUTPUT1_col7_format = $3.;
%let _OUTPUT1_col7_informat = $3.;
%let _OUTPUT1_col7_label = %nrquote(SESSN_ENRL_CNTL);
%let _OUTPUT1_col7_input0 = SESSN_ENRL_CNTL;
%let _OUTPUT1_col7_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col7_exp = ;
%let _OUTPUT1_col7_input = SESSN_ENRL_CNTL;
%let _OUTPUT1_col7_input_count = 1;
%let _OUTPUT1_col8_name = SESSN_APPT_CNTL;
%let _OUTPUT1_col8_table = work.WYYEB9MI;
%let _OUTPUT1_col8_length = 3;
%let _OUTPUT1_col8_type = $;
%let _OUTPUT1_col8_format = $3.;
%let _OUTPUT1_col8_informat = $3.;
%let _OUTPUT1_col8_label = %nrquote(SESSN_APPT_CNTL);
%let _OUTPUT1_col8_input0 = SESSN_APPT_CNTL;
%let _OUTPUT1_col8_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col8_exp = ;
%let _OUTPUT1_col8_input = SESSN_APPT_CNTL;
%let _OUTPUT1_col8_input_count = 1;
%let _OUTPUT1_col9_name = FIRST_ENRL_DT;
%let _OUTPUT1_col9_table = work.WYYEB9MI;
%let _OUTPUT1_col9_length = 8;
%let _OUTPUT1_col9_type = ;
%let _OUTPUT1_col9_format = DATETIME20.;
%let _OUTPUT1_col9_informat = DATETIME20.;
%let _OUTPUT1_col9_label = %nrquote(FIRST_ENRL_DT);
%let _OUTPUT1_col9_input0 = FIRST_ENRL_DT;
%let _OUTPUT1_col9_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col9_exp = ;
%let _OUTPUT1_col9_input = FIRST_ENRL_DT;
%let _OUTPUT1_col9_input_count = 1;
%let _OUTPUT1_col10_name = LAST_ENRL_DT;
%let _OUTPUT1_col10_table = work.WYYEB9MI;
%let _OUTPUT1_col10_length = 8;
%let _OUTPUT1_col10_type = ;
%let _OUTPUT1_col10_format = DATETIME20.;
%let _OUTPUT1_col10_informat = DATETIME20.;
%let _OUTPUT1_col10_label = %nrquote(LAST_ENRL_DT);
%let _OUTPUT1_col10_input0 = LAST_ENRL_DT;
%let _OUTPUT1_col10_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col10_exp = ;
%let _OUTPUT1_col10_input = LAST_ENRL_DT;
%let _OUTPUT1_col10_input_count = 1;
%let _OUTPUT1_col11_name = LAST_WAIT_DT;
%let _OUTPUT1_col11_table = work.WYYEB9MI;
%let _OUTPUT1_col11_length = 8;
%let _OUTPUT1_col11_type = ;
%let _OUTPUT1_col11_format = DATETIME20.;
%let _OUTPUT1_col11_informat = DATETIME20.;
%let _OUTPUT1_col11_label = %nrquote(LAST_WAIT_DT);
%let _OUTPUT1_col11_input0 = LAST_WAIT_DT;
%let _OUTPUT1_col11_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col11_exp = ;
%let _OUTPUT1_col11_input = LAST_WAIT_DT;
%let _OUTPUT1_col11_input_count = 1;
%let _OUTPUT1_col12_name = HOLIDAY_SCHEDULE;
%let _OUTPUT1_col12_table = work.WYYEB9MI;
%let _OUTPUT1_col12_length = 6;
%let _OUTPUT1_col12_type = $;
%let _OUTPUT1_col12_format = $6.;
%let _OUTPUT1_col12_informat = $6.;
%let _OUTPUT1_col12_label = %nrquote(HOLIDAY_SCHEDULE);
%let _OUTPUT1_col12_input0 = HOLIDAY_SCHEDULE;
%let _OUTPUT1_col12_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col12_exp = ;
%let _OUTPUT1_col12_input = HOLIDAY_SCHEDULE;
%let _OUTPUT1_col12_input_count = 1;
%let _OUTPUT1_col13_name = WEEKS_OF_INSTRUCT;
%let _OUTPUT1_col13_table = work.WYYEB9MI;
%let _OUTPUT1_col13_length = 8;
%let _OUTPUT1_col13_type = ;
%let _OUTPUT1_col13_format = ;
%let _OUTPUT1_col13_informat = ;
%let _OUTPUT1_col13_label = %nrquote(WEEKS_OF_INSTRUCT);
%let _OUTPUT1_col13_input0 = WEEKS_OF_INSTRUCT;
%let _OUTPUT1_col13_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col13_exp = ;
%let _OUTPUT1_col13_input = WEEKS_OF_INSTRUCT;
%let _OUTPUT1_col13_input_count = 1;
%let _OUTPUT1_col14_name = CENSUS_DT;
%let _OUTPUT1_col14_table = work.WYYEB9MI;
%let _OUTPUT1_col14_length = 8;
%let _OUTPUT1_col14_type = ;
%let _OUTPUT1_col14_format = DATETIME20.;
%let _OUTPUT1_col14_informat = DATETIME20.;
%let _OUTPUT1_col14_label = %nrquote(CENSUS_DT);
%let _OUTPUT1_col14_input0 = CENSUS_DT;
%let _OUTPUT1_col14_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col14_exp = ;
%let _OUTPUT1_col14_input = CENSUS_DT;
%let _OUTPUT1_col14_input_count = 1;
%let _OUTPUT1_col15_name = USE_DYN_CLASS_DATE;
%let _OUTPUT1_col15_table = work.WYYEB9MI;
%let _OUTPUT1_col15_length = 1;
%let _OUTPUT1_col15_type = $;
%let _OUTPUT1_col15_format = $1.;
%let _OUTPUT1_col15_informat = $1.;
%let _OUTPUT1_col15_label = %nrquote(USE_DYN_CLASS_DATE);
%let _OUTPUT1_col15_input0 = USE_DYN_CLASS_DATE;
%let _OUTPUT1_col15_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col15_exp = ;
%let _OUTPUT1_col15_input = USE_DYN_CLASS_DATE;
%let _OUTPUT1_col15_input_count = 1;
%let _OUTPUT1_col16_name = SIXTY_PCT_DT;
%let _OUTPUT1_col16_table = work.WYYEB9MI;
%let _OUTPUT1_col16_length = 8;
%let _OUTPUT1_col16_type = ;
%let _OUTPUT1_col16_format = DATETIME20.;
%let _OUTPUT1_col16_informat = DATETIME20.;
%let _OUTPUT1_col16_label = %nrquote(SIXTY_PCT_DT);
%let _OUTPUT1_col16_input0 = SIXTY_PCT_DT;
%let _OUTPUT1_col16_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col16_exp = ;
%let _OUTPUT1_col16_input = SIXTY_PCT_DT;
%let _OUTPUT1_col16_input_count = 1;
%let _OUTPUT1_col17_name = FACILITY_ASSIGNMNT;
%let _OUTPUT1_col17_table = work.WYYEB9MI;
%let _OUTPUT1_col17_length = 8;
%let _OUTPUT1_col17_type = ;
%let _OUTPUT1_col17_format = DATETIME20.;
%let _OUTPUT1_col17_informat = DATETIME20.;
%let _OUTPUT1_col17_label = %nrquote(FACILITY_ASSIGNMNT);
%let _OUTPUT1_col17_input0 = FACILITY_ASSIGNMNT;
%let _OUTPUT1_col17_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col17_exp = ;
%let _OUTPUT1_col17_input = FACILITY_ASSIGNMNT;
%let _OUTPUT1_col17_input_count = 1;
%let _OUTPUT1_col18_name = SSR_ENR_APT_APPROV;
%let _OUTPUT1_col18_table = work.WYYEB9MI;
%let _OUTPUT1_col18_length = 1;
%let _OUTPUT1_col18_type = $;
%let _OUTPUT1_col18_format = $1.;
%let _OUTPUT1_col18_informat = $1.;
%let _OUTPUT1_col18_label = %nrquote(SSR_ENR_APT_APPROV);
%let _OUTPUT1_col18_input0 = SSR_ENR_APT_APPROV;
%let _OUTPUT1_col18_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col18_exp = ;
%let _OUTPUT1_col18_input = SSR_ENR_APT_APPROV;
%let _OUTPUT1_col18_input_count = 1;
%let _OUTPUT1_col19_name = SSR_VAL_APT_APPROV;
%let _OUTPUT1_col19_table = work.WYYEB9MI;
%let _OUTPUT1_col19_length = 1;
%let _OUTPUT1_col19_type = $;
%let _OUTPUT1_col19_format = $1.;
%let _OUTPUT1_col19_informat = $1.;
%let _OUTPUT1_col19_label = %nrquote(SSR_VAL_APT_APPROV);
%let _OUTPUT1_col19_input0 = SSR_VAL_APT_APPROV;
%let _OUTPUT1_col19_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col19_exp = ;
%let _OUTPUT1_col19_input = SSR_VAL_APT_APPROV;
%let _OUTPUT1_col19_input_count = 1;
%let _OUTPUT1_col20_name = SSR_SSPLNRDISP_BDT;
%let _OUTPUT1_col20_table = work.WYYEB9MI;
%let _OUTPUT1_col20_length = 8;
%let _OUTPUT1_col20_type = ;
%let _OUTPUT1_col20_format = DATETIME20.;
%let _OUTPUT1_col20_informat = DATETIME20.;
%let _OUTPUT1_col20_label = %nrquote(SSR_SSPLNRDISP_BDT);
%let _OUTPUT1_col20_input0 = SSR_SSPLNRDISP_BDT;
%let _OUTPUT1_col20_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col20_exp = ;
%let _OUTPUT1_col20_input = SSR_SSPLNRDISP_BDT;
%let _OUTPUT1_col20_input_count = 1;
%let _OUTPUT1_col21_name = SSR_SSPLNRDISP_EDT;
%let _OUTPUT1_col21_table = work.WYYEB9MI;
%let _OUTPUT1_col21_length = 8;
%let _OUTPUT1_col21_type = ;
%let _OUTPUT1_col21_format = DATETIME20.;
%let _OUTPUT1_col21_informat = DATETIME20.;
%let _OUTPUT1_col21_label = %nrquote(SSR_SSPLNRDISP_EDT);
%let _OUTPUT1_col21_input0 = SSR_SSPLNRDISP_EDT;
%let _OUTPUT1_col21_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col21_exp = ;
%let _OUTPUT1_col21_input = SSR_SSPLNRDISP_EDT;
%let _OUTPUT1_col21_input_count = 1;
%let _OUTPUT1_col22_name = READ_DTM;
%let _OUTPUT1_col22_table = work.WYYEB9MI;
%let _OUTPUT1_col22_length = 8;
%let _OUTPUT1_col22_type = ;
%let _OUTPUT1_col22_format = DATETIME20.;
%let _OUTPUT1_col22_informat = DATETIME20.;
%let _OUTPUT1_col22_label = %nrquote(READ_DTM);
%let _OUTPUT1_col22_input0 = READ_DTM;
%let _OUTPUT1_col22_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col22_exp = ;
%let _OUTPUT1_col22_input = READ_DTM;
%let _OUTPUT1_col22_input_count = 1;
%let _OUTPUT1_col23_name = STG_UPDATE_ID;
%let _OUTPUT1_col23_table = work.WYYEB9MI;
%let _OUTPUT1_col23_length = 20;
%let _OUTPUT1_col23_type = $;
%let _OUTPUT1_col23_format = $20.;
%let _OUTPUT1_col23_informat = $20.;
%let _OUTPUT1_col23_label = %nrquote(STG_UPDATE_ID);
%let _OUTPUT1_col23_input0 = STG_UPDATE_ID;
%let _OUTPUT1_col23_input0_table = work.WYYD5YLE;
%let _OUTPUT1_col23_exp = ;
%let _OUTPUT1_col23_input = STG_UPDATE_ID;
%let _OUTPUT1_col23_input_count = 1;
%let _OUTPUT1_col24_name = PREV_CENSUS_DT;
%let _OUTPUT1_col24_table = work.WYYEB9MI;
%let _OUTPUT1_col24_length = 8;
%let _OUTPUT1_col24_type = ;
%let _OUTPUT1_col24_format = DATETIME20.;
%let _OUTPUT1_col24_informat = DATETIME20.;
%let _OUTPUT1_col24_label = %nrquote(PREV_CENSUS_DT);
%let _OUTPUT1_col24_exp = ;
%let _OUTPUT1_col24_input_count = 0;
%let _OUTPUT1_col25_name = PREV_STRM;
%let _OUTPUT1_col25_table = work.WYYEB9MI;
%let _OUTPUT1_col25_length = 4;
%let _OUTPUT1_col25_type = $;
%let _OUTPUT1_col25_format = $4.;
%let _OUTPUT1_col25_informat = $4.;
%let _OUTPUT1_col25_label = %nrquote(PREV_STRM);
%let _OUTPUT1_col25_exp = ;
%let _OUTPUT1_col25_input_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/

%let term_end_dt ='12MAY2026:00:00:00'dt;
%let term=2262;
%let prev_term=2258;
%let two_year_prev_term=2242;
%let term_sk_filter=411;


/*%let term_end_dt ='18DEC2025:00:00:00'dt;
%let term=2258;
%let prev_term=2255;
%let two_year_prev_term=2238;
%let term_sk_filter=409;
%let term_end_dt ='18AUG2025:00:00:00'dt;
%let term=2255;
%let prev_term=2252;
%let two_year_prev_term=2235;
%let term_sk_filter=407;

%let term_end_dt ='12MAY2025:00:00:00'dt;
%let term=2252;
%let prev_term=2248;
%let two_year_prev_term=2232;
%let term_sk_filter=405;*/
/*%let term_end_dt ='18AUG2020:00:00:00'dt;
%let term=2205;
%let prev_term=2202;
%let two_year_prev_term=2185;
%let term_sk_filter=379;
*/
/*%let term_end_dt ='15MAY2020:00:00:00'dt;
%let term=2202;
%let prev_term=2198;
%let two_year_prev_term=2182;
%let term_sk_filter=377;*/
/*
%let term_end_dt ='11DEC2019:00:00:00'dt;
%let term=2198;
%let prev_term=2195;
%let two_year_prev_term=2178;
%let term_sk_filter=375;
*/
/*
%let term_end_dt ='13AUG2019:00:00:00'dt;
%let term=2195;
%let prev_term=2192;
%let two_year_prev_term=2175;
%let term_sk_filter=373;
*/


data
&_OUTPUT;
  set &SYSLAST;
  length PREV_CENSUS_DT 8 PREV_STRM $4.;
	format PREV_CENSUS_DT DATETIME20. PREV_STRM $4.;
  PREV_CENSUS_DT = lag(census_dt);
	PREV_STRM = lag(STRM);
run;

/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BN8 *
 * Transform:       Join                                                    *
 * Description:     CB Exclude Classes                                      *
 *                                                                          *
 * Source Tables:   PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_COURSE_OFFER_DIM -                A5B29B8Q.BE0000RO *
 *                   ADWTGTPR.ADW_COURSE_OFFER_DIM                          *
 *                  ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 * Target Table:    Join - work.W11AMZC8Z                 A5B29B8Q.BS000413 *
 *==========================================================================*/

proc sql;
   create view work.W11AMZC8Z as
   select distinct
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR_VALUE length = 10
         format = $10.
         informat = $10.
         label = 'CRSE_ATTR_VALUE',
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR length = 4
         format = $4.
         informat = $4.
         label = 'CRSE_ATTR',
      ADW_CLASS_SCHEDULE_FACT.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      ADW_TERM_DIM.TERM_SK length = 8
         label = 'TERM_SK',
      PS_CLASS_ATTRIBUTE_Extract.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract as PS_CLASS_ATTRIBUTE_Extract,
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM,
      ADWTGTPR.ADW_COURSE_OFFER_DIM as ADW_COURSE_OFFER_DIM,
      ADWTGTPR.ADW_CLASS_SCHEDULE_FACT as ADW_CLASS_SCHEDULE_FACT
   where
      ADW_TERM_DIM.TERM_SK = ADW_CLASS_SCHEDULE_FACT.TERM_SK
      and ADW_COURSE_OFFER_DIM.COURSE_OFFER_SK = ADW_CLASS_SCHEDULE_FACT.COURSE_OFFER_SK
      and (PS_CLASS_ATTRIBUTE_Extract.CRSE_ID = ADW_COURSE_OFFER_DIM.COURSE_IDENTIFIER
      and PS_CLASS_ATTRIBUTE_Extract.CRSE_OFFER_NBR = ADW_COURSE_OFFER_DIM.COURSE_OFFER_NBR
      and PS_CLASS_ATTRIBUTE_Extract.STRM = ADW_TERM_DIM.STRM
      and PS_CLASS_ATTRIBUTE_Extract.SESSION_CODE = ADW_CLASS_SCHEDULE_FACT.SESSION_CODE
      and PS_CLASS_ATTRIBUTE_Extract.CLASS_SECTION = ADW_CLASS_SCHEDULE_FACT.CLASS_SECTION
      and PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR = 'CB'
      and PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR_VALUE = 'EXCLUDE')
      and PS_CLASS_ATTRIBUTE_Extract.STRM > '2018'
   ;
quit;

/*==========================================================================*
 * Step:            DLRN crse attribute                   A5B29B8Q.BZ000BN9 *
 * Transform:       Join                                                    *
 * Description:     trumped by dlrn table                                   *
 *                                                                          *
 * Source Table:    PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 * Target Table:    Join - work.WS83HA67                  A5B29B8Q.BS000414 *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract);


proc sql;
   create view work.WS83HA67 as
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
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR length = 4
         format = $4.
         informat = $4.
         label = 'CRSE_ATTR'
   from
      ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract as PS_CLASS_ATTRIBUTE_Extract
   where
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR = 'DLRN'
      and PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR_VALUE IN ('DEPT(OUT)','CDE-T(OUT)','CDE-(OUT)')
   group by
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ID,
      PS_CLASS_ATTRIBUTE_Extract.CRSE_OFFER_NBR,
      PS_CLASS_ATTRIBUTE_Extract.STRM,
      PS_CLASS_ATTRIBUTE_Extract.SESSION_CODE,
      PS_CLASS_ATTRIBUTE_Extract.CLASS_SECTION
   ;
quit;

/*==========================================================================*
 * Step:            Master Table                          A5B29B8Q.BZ000BNA *
 * Transform:       Join                                                    *
 * Description:     Class Level Details + DLRN                              *
 *                                                                          *
 * Source Tables:   User Written - work.WYYEB9MI          A5B29B8Q.BS000412 *
 *                  Join - work.W11AMZC8Z                 A5B29B8Q.BS000413 *
 *                  Join - work.WRR69C1R                  A5B29B8Q.BS000415 *
 *                  NONAME - work.W2CKLMDL                A5B29B8Q.BS000420 *
 *                  Join - work.WS6MUTBD                  A5B29B8Q.BS000416 *
 *                  Join - work.WS83HA67                  A5B29B8Q.BS000414 *
 *                  ADW_STUDENT_CLASS_ENRL_FACT -         A5B29B8Q.BE0000MN *
 *                   ADWTGTPR.ADW_STUDENT_CLASS_ENRL_FACT                   *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_CBM_DLRNORPT -                    A5B29B8Q.BE00000F *
 *                   CBMPRD.ADW_CBM_DLRNORPT                                *
 * Target Table:    CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *==========================================================================*/

proc sql;
   create table ADWTGTPR.CBM1_CLASS_INFO as
   select distinct
      ADW_STUDENT_CLASS_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_STUDENT_CLASS_ENRL_FACT.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      ADW_STUDENT_CLASS_ENRL_FACT.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      ADW_STUDENT_CLASS_ENRL_FACT.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.ACAD_CAL_SK length = 8
         label = 'ACAD_CAL_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.ACAD_PROGRAM_SK length = 8
         label = 'ACAD_PROGRAM_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.MAJOR_ACAD_PLAN_SK length = 8
         label = 'MAJOR_ACAD_PLAN_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.MAJOR_DEPT_SK length = 8
         label = 'MAJOR_DEPT_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.COURSE_CAREER length = 20
         format = $20.
         informat = $20.
         label = 'COURSE_CAREER',
      ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      ADW_STUDENT_CLASS_ENRL_FACT.SESSION_ENRL_CONTROL length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_ENRL_CONTROL',
      ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD length = 20
         format = $20.
         informat = $20.
         label = 'STUDENT_ENRL_CD',
      ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_FLG_RSN_CD length = 20
         format = $20.
         informat = $20.
         label = 'STUDENT_ENRL_FLG_RSN_CD',
      ADW_STUDENT_CLASS_ENRL_FACT.LAST_ENRL_ACTION_CD length = 20
         format = $20.
         informat = $20.
         label = 'LAST_ENRL_ACTION_CD',
      ADW_STUDENT_CLASS_ENRL_FACT.LAST_ENRL_ACTION_RSN length = 20
         format = $20.
         informat = $20.
         label = 'LAST_ENRL_ACTION_RSN',
      ADW_STUDENT_CLASS_ENRL_FACT.LAST_ENRL_ACTION_PROCESS_CD length = 20
         format = $20.
         informat = $20.
         label = 'LAST_ENRL_ACTION_PROCESS_CD',
      ADW_STUDENT_CLASS_ENRL_FACT.ENRL_ADD_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_ADD_DT',
      ADW_STUDENT_CLASS_ENRL_FACT.ENRL_DROP_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ENRL_DROP_DT',
      ADW_STUDENT_CLASS_ENRL_FACT.UNIT_TAKEN length = 8
         label = 'UNIT_TAKEN',
      ADW_STUDENT_CLASS_ENRL_FACT.UNIT_PRGRS length = 8
         label = 'UNIT_PRGRS',
      ADW_STUDENT_CLASS_ENRL_FACT.UNIT_PRGRS_FA length = 8
         label = 'UNIT_PRGRS_FA',
      ADW_STUDENT_CLASS_ENRL_FACT.UNIT_BILLING length = 8
         label = 'UNIT_BILLING',
      ADW_STUDENT_CLASS_ENRL_FACT.COURSE_COUNT length = 8
         label = 'COURSE_COUNT',
      ADW_STUDENT_CLASS_ENRL_FACT.GRADING_BASIS_ENRL_CD length = 20
         format = $20.
         informat = $20.
         label = 'GRADING_BASIS_ENRL_CD',
      ADW_STUDENT_CLASS_ENRL_FACT.GRADING_BASIS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'GRADING_BASIS_DT',
      ADW_STUDENT_CLASS_ENRL_FACT.UNIT_EARNED length = 8
         label = 'UNIT_EARNED',
      ADW_STUDENT_CLASS_ENRL_FACT.DYNAMIC_CLASS_NBR length = 8
         label = 'DYNAMIC_CLASS_NBR',
      ADW_STUDENT_CLASS_ENRL_FACT.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      ADW_STUDENT_CLASS_ENRL_FACT.UPDATED_USER length = 20
         format = $20.
         informat = $20.
         label = 'UPDATED_USER',
      ADW_STUDENT_CLASS_ENRL_FACT.GRADE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'GRADE_DT',
      ADW_STUDENT_CLASS_ENRL_FACT.UNITS_ATTEMPTD length = 1
         format = $1.
         informat = $1.
         label = 'UNITS_ATTEMPTD',
      ADW_STUDENT_CLASS_ENRL_FACT.GRADE_PTS length = 8
         label = 'GRADE_PTS',
      ADW_STUDENT_CLASS_ENRL_FACT.GRADE_PTS_FA length = 8
         label = 'GRADE_PTS_FA',
      ADW_STUDENT_CLASS_ENRL_FACT.GRADE_PTS_PER_UNIT length = 8
         label = 'GRADE_PTS_PER_UNIT',
      ADW_STUDENT_CLASS_ENRL_FACT.INSTRUCTOR_ID length = 13
         format = $13.
         informat = $13.
         label = 'INSTRUCTOR_ID',
      ADW_STUDENT_CLASS_ENRL_FACT.COURSE_GRADE_OFF length = 3
         format = $3.
         informat = $3.
         label = 'COURSE_GRADE_OFF',
      ADW_STUDENT_CLASS_ENRL_FACT.PASSING_GRADE_FLG length = 1
         format = $1.
         informat = $1.
         label = 'PASSING_GRADE_FLG',
      ADW_STUDENT_CLASS_ENRL_FACT.PASSING_GRADE_RZ_FLG length = 1
         format = $1.
         informat = $1.
         label = 'PASSING_GRADE_RZ_FLG',
      ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_FLG length = 1
         format = $1.
         informat = $1.
         label = 'STUDENT_ENRL_FLG',
      ADW_STUDENT_CLASS_ENRL_FACT.INSTRUCTOR_NAME length = 90
         format = $90.
         informat = $90.
         label = 'INSTRUCTOR_NAME',
      ADW_STUDENT_CLASS_ENRL_FACT.ACAD_LEVEL_EOT length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_EOT',
      ADW_STUDENT_CLASS_ENRL_FACT.UGRD_SCH_LOWER length = 8
         label = 'UGRD_SCH_LOWER',
      ADW_STUDENT_CLASS_ENRL_FACT.UGRD_SCH_UPPER length = 8
         label = 'UGRD_SCH_UPPER',
      ADW_STUDENT_CLASS_ENRL_FACT.MASTER_SCH length = 8
         label = 'MASTER_SCH',
      ADW_STUDENT_CLASS_ENRL_FACT.DOCT_SCH length = 8
         label = 'DOCT_SCH',
      ADW_STUDENT_CLASS_ENRL_FACT.DOCT_PROFESSIONAL_SCH length = 8
         label = 'DOCT_PROFESSIONAL_SCH',
      ADW_STUDENT_CLASS_ENRL_FACT.SPEC_SCH length = 8
         label = 'SPEC_SCH',
      ADW_STUDENT_CLASS_ENRL_FACT.CERT_SCH length = 8
         label = 'CERT_SCH',
      ADW_STUDENT_CLASS_ENRL_FACT.END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      ADW_STUDENT_CLASS_ENRL_FACT.START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      ADW_STUDENT_CLASS_ENRL_FACT.MAJOR2_ACAD_PLAN_SK length = 8
         label = 'MAJOR2_ACAD_PLAN_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.MINOR_ACAD_PLAN_SK length = 8
         label = 'MINOR_ACAD_PLAN_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.ACAD_LEVEL_BOT length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_BOT',
      ADW_STUDENT_CLASS_ENRL_FACT.ACAD_LEVEL_PROJECTED length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LEVEL_PROJECTED',
      ADW_STUDENT_CLASS_ENRL_FACT.MAJOR2_DEPT_SK length = 8
         label = 'MAJOR2_DEPT_SK',
      ADW_STUDENT_CLASS_ENRL_FACT.MINOR_DEPT_SK length = 8
         label = 'MINOR_DEPT_SK',
      case
         when
      (ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD='E'   &
       (  ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD   ^= '1'  & substr(WYYEB9MI.STRM ,4,1) IN ('2','8')  |   ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD   ^= '5W2' & substr(WYYEB9MI.STRM ,4,1) = '5' )
        & ADW_STUDENT_CLASS_ENRL_FACT.END_DT >ADW_TERM_DIM.TERM_END_DT )
            then '6'
      when
      (ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD='E'   &
       (  ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD   ^= '1'  & substr(WYYEB9MI.STRM ,4,1) IN ('2','8')  |   ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD   ^= '5W2' & substr(WYYEB9MI.STRM ,4,1) = '5' )
       & ADW_STUDENT_CLASS_ENRL_FACT.START_DT  > WYYEB9MI.CENSUS_DT )
            then '1'

      else ' '
      end




      /*


      case
         when
      (ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD='E'   &   ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD = 'DYN' & ADW_STUDENT_CLASS_ENRL_FACT.START_DT  > WYYEB9MI.CENSUS_DT  & ADW_STUDENT_CLASS_ENRL_FACT.END_DT >ADW_TERM_DIM.TERM_END_DT )
            then '6'
      when
      (ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD='E'   &
       (  ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD   ^= '1'  & substr(WYYEB9MI.STRM ,4,1) IN ('2','8')  |   ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD   ^= '5W2' & substr(WYYEB9MI.STRM ,4,1) = '5' )
       & ADW_STUDENT_CLASS_ENRL_FACT.START_DT  > WYYEB9MI.CENSUS_DT )
            then '1'

      else ' '
      end

      */ as FLEX length = 1
         label = 'FLEX',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WS83HA67.CRSE_ATTR length = 4
         format = $4.
         informat = $4.
         label = 'CRSE_ATTR',
      ifn(ADW_CBM_DLRNORPT.SUBJECT is missing or ADW_CBM_DLRNORPT.SUBJECT is null,0,1) as DLRN length = 8,
      ADW_STUDENT_CLASS_ENRL_FACT.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      ADW_STUDENT_CLASS_ENRL_FACT.ACAD_PROG_PRIMARY length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY',
      ADW_TERM_DIM.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      "" as SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      ADW_STUDENT_CLASS_ENRL_FACT.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR'
   from
      ADWTGTPR.ADW_STUDENT_CLASS_ENRL_FACT as ADW_STUDENT_CLASS_ENRL_FACT left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      work.W11AMZC8Z as W11AMZC8Z
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.CLASS_NBR = W11AMZC8Z.CLASS_NBR
            and ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD = W11AMZC8Z.SESSION_CODE
            and ADW_TERM_DIM.STRM = W11AMZC8Z.STRM
         ) inner join
      work.WYYEB9MI as WYYEB9MI
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.INSTITUTION = WYYEB9MI.INSTITUTION
            and ADW_ACAD_CAREER_DIM.ACAD_CAREER = WYYEB9MI.ACAD_CAREER
            and ADW_TERM_DIM.STRM = WYYEB9MI.STRM
         ) left join
      work.WS83HA67 as WS83HA67
         on
         (
            WYYEB9MI.STRM = WS83HA67.STRM
            and ADW_STUDENT_CLASS_ENRL_FACT.CRSE_ID = WS83HA67.CRSE_ID
            and ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD = WS83HA67.SESSION_CODE
            and ADW_STUDENT_CLASS_ENRL_FACT.CLASS_SECTION = WS83HA67.CLASS_SECTION
            and ADW_STUDENT_CLASS_ENRL_FACT.CRSE_OFFER_NBR = WS83HA67.CRSE_OFFER_NBR
         ) left join
      CBMPRD.ADW_CBM_DLRNORPT as ADW_CBM_DLRNORPT
         on
         (
            ADW_STUDENT_CLASS_ENRL_FACT.EMPLID = ADW_CBM_DLRNORPT.EMPLID
            and ADW_CBM_DLRNORPT.STRM = "&term."
         )
   where
      (W11AMZC8Z.CRSE_ATTR_VALUE <> 'EXCLUDE'
      or ADW_CBM_DLRNORPT.EMPLID IS NOT NULL )
      and ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD = 'E'
      and COALESCEC(ADW_STUDENT_CLASS_ENRL_FACT.LAST_ENRL_ACTION_RSN,'FILLER') <> 'CENS'
      and ADW_STUDENT_CLASS_ENRL_FACT.TERM_SK > 375
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNG *
 * Transform:       Join                                                    *
 * Description:     Master Single Row                                       *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 * Target Table:    CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *==========================================================================*/

proc sql;
   create table ADWTGTPR.CBM1_STUDENT_LIST as
   select distinct
      class_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      class_info.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      class_info.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      class_info.TERM_SK length = 8
         label = 'TERM_SK',
      class_info.FLEX length = 1
         label = 'FLEX',
      case when class_info.SESSION_CD='DYN' then 'DYN'
      else 'NOTDYN'
      end as SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      class_info.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      max(class_info.DLRN) as DLRN length = 8,
      case
         when coalesce(trim(class_info.FLEX),' ') ='6' then
            case
      	when substr(ADW_TERM_DIM.STRM,4,1)='8' then catx('',substr(ADW_TERM_DIM.STRM,1,1),input(substr(ADW_TERM_DIM.STRM,2,2),2.)+1 ,'2')
      	when substr(ADW_TERM_DIM.STRM,4,1)='2' then catx('',substr(ADW_TERM_DIM.STRM,1,3),'5')
      	when substr(ADW_TERM_DIM.STRM,4,1)='5' then catx('',substr(ADW_TERM_DIM.STRM,1,3),'8')
      end


      else ADW_TERM_DIM.STRM
      end

      /* ADW_TERM_DIM.STRM   */ as FLEX_STRM length = 8
   from
      ADWTGTPR.CBM1_CLASS_INFO as class_info left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            class_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         )
   where
      ADW_TERM_DIM.ACAD_YEAR >= 2001
      and class_info.TERM_SK > &term_sk_filter.
   group by
      class_info.EMPLID,
      class_info.TERM_SK
   ;
quit;

/*==========================================================================*
 * Step:            Check OSD                             A5B29B8Q.BZ000BNH *
 * Transform:       Join                                                    *
 * Description:     40 / 40A                                                *
 *                                                                          *
 * Source Tables:   PS_UTA_OSD_STDDIAG_Extract -          A5B29B8Q.BE00007N *
 *                   ADWSTGPR.PS_UTA_OSD_STDDIAG_Extract                    *
 *                  PS_UTA_OSD_STDNT_Extract -            A5B29B8Q.BE00007O *
 *                   ADWSTGPR.PS_UTA_OSD_STDNT_Extract                      *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W9JYBSOK                  A5B29B8Q.BS00041C *
 *==========================================================================*/

proc sql;
   create table work.W9JYBSOK as
   select
      Student_term_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      Student_term_info.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      Student_term_info.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      Student_term_info.TERM_SK length = 8
         label = 'TERM_SK',
      Student_term_info.FLEX length = 1
         label = 'FLEX',
      Student_term_info.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      Student_term_info.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      case when PS_UTA_OSD_STDDIAG_Extract.UTA_DIAGNOSIS = '28' and PS_UTA_OSD_STDDIAG_Extract.UTA_ITEM_CD = 'DIA11' and PS_UTA_OSD_STDNT_Extract.UTA_OSD_STATUS ='A' then '2'
      else '0'
      end as IDD_Enrolled_IDD_Pgm length = 1
   from
      ADWTGTPR.CBM1_STUDENT_LIST as Student_term_info left join
      ADWSTGPR.PS_UTA_OSD_STDDIAG_Extract as PS_UTA_OSD_STDDIAG_Extract
         on
         (
            Student_term_info.EMPLID = PS_UTA_OSD_STDDIAG_Extract.EMPLID
            and PS_UTA_OSD_STDDIAG_Extract.UTA_DIAGNOSIS = '28'
            and PS_UTA_OSD_STDDIAG_Extract.UTA_ITEM_CD = 'DIA11'
         ) left join
      ADWSTGPR.PS_UTA_OSD_STDNT_Extract as PS_UTA_OSD_STDNT_Extract
         on
         (
            Student_term_info.EMPLID = PS_UTA_OSD_STDNT_Extract.EMPLID
            and PS_UTA_OSD_STDNT_Extract.UTA_OSD_STATUS = 'A'
         )
   ;
quit;

/****************************************************************************
 * Job:             UGLIMIT                               A5B29B8Q.BT0000QR *
 * Description:                                                             *
 *                                                                          *
 * Metadata Server: sasmetapaws8.ua.uta.edu                                 *
 * Port:            8561                                                    *
 * Location:        /UTA/ADW/400 Reports/CBM/Jobs/CBM1 CBME1 Sub Jobs       *
 *                                                                          *
 * Server:          SASApp                                A5B29B8Q.AS000002 *
 *                                                                          *
 * Source Tables:   CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K *
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  PS_EXT_COURSE_Extract -               A5B29B8Q.BE00000Z *
 *                   ADWSTGPR.PS_EXT_COURSE_Extract                         *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  PS_TRNS_CRSE_DTL_Extract -            A5B29B8Q.BE00000Y *
 *                   ADWSTGPR.PS_TRNS_CRSE_DTL_Extract                      *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  ADW_STUDENT_CLASS_ENRL_5YR_MV -       A5B29B8Q.BE0000SR *
 *                  ADWTGTPR.ADW_STUDENT_CLASS_ENRL_5YR                     *
 *                  _MV                                                     *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    CBM1_UGLIMIT - ADWTGTPR.CBM1_UGLIMIT  A5B29B8Q.BE00018M *
 *                                                                          *
 * Generated on:    Thursday, May 7, 2026 1:54:27 PM CDT                    *
 * Generated by:    mynenit                                                 *
 * Version:         SAS Data Integration Studio 4.905                       *
 ****************************************************************************/

%global etls_debug;
%macro etls_setDebug;
   %if %str(&etls_debug) ne 0 %then
      OPTIONS MPRINT%str(;);
%mend;
%etls_setDebug;

/*==========================================================================*
 * Step:            Macros                                A5B29B8Q.BZ0005E9 *
 * Transform:       User Written                                            *
 * Description:     Uncomment or populate here for manual testing           *
 *                                                                          *
 * Target Table:    User Written - work.W23ZUAVZ          A5B29B8Q.BS0002B6 *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*/


%let _OUTPUT = work.W23ZUAVZ;

%let _OUTPUT1_col_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/

/*
%let term_end_dt ='13AUG2019:00:00:00'dt;
%let term=2195;
%let prev_term=2192;
%let two_year_prev_term=2175;
%let term_sk_filter=373;
*/
/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            ext_crse min(year)                    A5B29B8Q.BZ0005EA *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_EXT_COURSE_Extract -               A5B29B8Q.BE00000Z *
 *                   ADWSTGPR.PS_EXT_COURSE_Extract                         *
 * Target Table:    Join - work.W2409578                  A5B29B8Q.BS0001LE *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_EXT_COURSE_Extract);


proc sql;
   create view work.W2409578 as
   select
      PS_EXT_COURSE_Extract.BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'BEGIN_DT',
      PS_EXT_COURSE_Extract.CAN_TRNS_TYPE length = 2
         format = $2.
         informat = $2.
         label = 'CAN_TRNS_TYPE',
      PS_EXT_COURSE_Extract.COURSE_LEVEL length = 2
         format = $2.
         informat = $2.
         label = 'COURSE_LEVEL',
      PS_EXT_COURSE_Extract.CRSE_GRADE_INPUT length = 3
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_INPUT',
      PS_EXT_COURSE_Extract.CRSE_GRADE_OFF length = 3
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      PS_EXT_COURSE_Extract.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      PS_EXT_COURSE_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_EXT_COURSE_Extract.END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      PS_EXT_COURSE_Extract.EXT_ACAD_LEVEL length = 4
         format = $4.
         informat = $4.
         label = 'EXT_ACAD_LEVEL',
      PS_EXT_COURSE_Extract.EXT_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'EXT_CAREER',
      PS_EXT_COURSE_Extract.EXT_COURSE_NBR length = 8
         label = 'EXT_COURSE_NBR',
      PS_EXT_COURSE_Extract.EXT_CRSE_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'EXT_CRSE_TYPE',
      PS_EXT_COURSE_Extract.EXT_DATA_NBR length = 8
         label = 'EXT_DATA_NBR',
      PS_EXT_COURSE_Extract.EXT_ORG_ID length = 11
         format = $11.
         informat = $11.
         label = 'EXT_ORG_ID',
      PS_EXT_COURSE_Extract.EXT_SUBJECT_AREA length = 4
         format = $4.
         informat = $4.
         label = 'EXT_SUBJECT_AREA',
      PS_EXT_COURSE_Extract.EXT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXT_TERM',
      PS_EXT_COURSE_Extract.EXT_TERM_TYPE length = 4
         format = $4.
         informat = $4.
         label = 'EXT_TERM_TYPE',
      PS_EXT_COURSE_Extract.GRADING_BASIS length = 3
         format = $3.
         informat = $3.
         label = 'GRADING_BASIS',
      PS_EXT_COURSE_Extract.GRADING_SCHEME length = 3
         format = $3.
         informat = $3.
         label = 'GRADING_SCHEME',
      PS_EXT_COURSE_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_EXT_COURSE_Extract.LASTUPDDTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'LASTUPDDTTM',
      PS_EXT_COURSE_Extract.LASTUPDOPRID length = 30
         format = $30.
         informat = $30.
         label = 'LASTUPDOPRID',
      PS_EXT_COURSE_Extract.LS_DATA_SOURCE length = 3
         format = $3.
         informat = $3.
         label = 'LS_DATA_SOURCE',
      PS_EXT_COURSE_Extract.SCHOOL_CRSE_NBR length = 10
         format = $10.
         informat = $10.
         label = 'SCHOOL_CRSE_NBR',
      PS_EXT_COURSE_Extract.SCHOOL_SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SCHOOL_SUBJECT',
      PS_EXT_COURSE_Extract.TERM_YEAR length = 8
         label = 'TERM_YEAR',
      PS_EXT_COURSE_Extract.TRANS_CREDIT_FLAG length = 1
         format = $1.
         informat = $1.
         label = 'TRANS_CREDIT_FLAG',
      PS_EXT_COURSE_Extract.UNT_TAKEN length = 8
         format = 8.2
         informat = 8.2
         label = 'UNT_TAKEN',
      PS_EXT_COURSE_Extract.UNT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'UNT_TYPE',
      PS_EXT_COURSE_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_EXT_COURSE_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID',
      case
      when PS_EXT_COURSE_Extract.EXT_TERM= 'SPR' then 2
      when PS_EXT_COURSE_Extract.EXT_TERM =  'SUMR' then 3
      when PS_EXT_COURSE_Extract.EXT_TERM= 'FALL' then 8
      when PS_EXT_COURSE_Extract.EXT_TERM= 'WINT' then 9
      else .
      end as term_num length = 8
   from
      ADWSTGPR.PS_EXT_COURSE_Extract as PS_EXT_COURSE_Extract
   where
      PS_EXT_COURSE_Extract.TERM_YEAR > 1900
   group by
      PS_EXT_COURSE_Extract.EMPLID
   having
      PS_EXT_COURSE_Extract.TERM_YEAR = min(PS_EXT_COURSE_Extract.TERM_YEAR)
   ;
quit;

/*==========================================================================*
 * Step:            ext_crse min(seq)                     A5B29B8Q.BZ0005EB *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W2409578                  A5B29B8Q.BS0001LE *
 * Target Table:    Join - work.W24097Q9                  A5B29B8Q.BS0001LF *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W2409578);


proc sql;
   create view work.W24097Q9 as
   select distinct
      W2409578.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W2409578.EXT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXT_TERM',
      W2409578.TERM_YEAR length = 8
         label = 'TERM_YEAR',
      case
      when W2409578.EXT_TERM ='SPR' then    catx('',substr(put(W2409578.TERM_YEAR,4.) ,1,1),substr(put(W2409578.TERM_YEAR,4.) ,3,2),'2')
      when W2409578.EXT_TERM ='SUMR' then catx('',substr(put(W2409578.TERM_YEAR,4.) ,1,1),substr(put(W2409578.TERM_YEAR,4.) ,3,2),'3')
      when W2409578.EXT_TERM ='FALL' then   catx('',substr(put(W2409578.TERM_YEAR,4.) ,1,1),substr(put(W2409578.TERM_YEAR,4.) ,3,2),'8')
      when W2409578.EXT_TERM ='WINT' then  catx('',substr(put(W2409578.TERM_YEAR,4.) ,1,1),substr(put(W2409578.TERM_YEAR,4.) ,3,2),'9')
      else catx('',substr(put(W2409578.TERM_YEAR,4.) ,1,1),substr(put(W2409578.TERM_YEAR,4.) ,3,2),'0')
      end as trns_STRM length = 4
   from
      work.W2409578 as W2409578
   group by
      W2409578.EMPLID
   having
      W2409578.term_num = min(W2409578.term_num)
   ;
quit;

/*==========================================================================*
 * Step:            trns_crse min(year)                   A5B29B8Q.BZ0005EC *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_TRNS_CRSE_DTL_Extract -            A5B29B8Q.BE00000Y *
 *                   ADWSTGPR.PS_TRNS_CRSE_DTL_Extract                      *
 * Target Table:    Join - work.W240961K                  A5B29B8Q.BS0001LG *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_TRNS_CRSE_DTL_Extract);


proc sql;
   create view work.W240961K as
   select
      PS_TRNS_CRSE_DTL_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_TRNS_CRSE_DTL_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_TRNS_CRSE_DTL_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_TRNS_CRSE_DTL_Extract.MODEL_NBR length = 8
         label = 'MODEL_NBR',
      PS_TRNS_CRSE_DTL_Extract.ARTICULATION_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ARTICULATION_TERM',
      PS_TRNS_CRSE_DTL_Extract.TRNSFR_EQVLNCY_GRP length = 8
         label = 'TRNSFR_EQVLNCY_GRP',
      PS_TRNS_CRSE_DTL_Extract.TRNSFR_EQVLNCY_SEQ length = 8
         label = 'TRNSFR_EQVLNCY_SEQ',
      PS_TRNS_CRSE_DTL_Extract.TRNSFR_STAT length = 1
         format = $1.
         informat = $1.
         label = 'TRNSFR_STAT',
      PS_TRNS_CRSE_DTL_Extract.TRNSFR_SRC_ID length = 11
         format = $11.
         informat = $11.
         label = 'TRNSFR_SRC_ID',
      PS_TRNS_CRSE_DTL_Extract.TRNSFR_EQVLNCY length = 6
         format = $6.
         informat = $6.
         label = 'TRNSFR_EQVLNCY',
      PS_TRNS_CRSE_DTL_Extract.TRNSFR_EQVLNCY_CMP length = 4
         format = $4.
         informat = $4.
         label = 'TRNSFR_EQVLNCY_CMP',
      PS_TRNS_CRSE_DTL_Extract.EXT_COURSE_NBR length = 8
         label = 'EXT_COURSE_NBR',
      PS_TRNS_CRSE_DTL_Extract.SRC_TERM length = 4
         format = $4.
         informat = $4.
         label = 'SRC_TERM',
      PS_TRNS_CRSE_DTL_Extract.SRC_CLASS_NBR length = 8
         label = 'SRC_CLASS_NBR',
      PS_TRNS_CRSE_DTL_Extract.TERM_YEAR length = 8
         label = 'TERM_YEAR',
      PS_TRNS_CRSE_DTL_Extract.EXT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXT_TERM',
      PS_TRNS_CRSE_DTL_Extract.SCHOOL_SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SCHOOL_SUBJECT',
      PS_TRNS_CRSE_DTL_Extract.SCHOOL_CRSE_NBR length = 10
         format = $10.
         informat = $10.
         label = 'SCHOOL_CRSE_NBR',
      PS_TRNS_CRSE_DTL_Extract.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      PS_TRNS_CRSE_DTL_Extract.SSR_UNT_TAKEN_EXT length = 8
         format = 7.2
         informat = 7.2
         label = 'SSR_UNT_TAKEN_EXT',
      PS_TRNS_CRSE_DTL_Extract.UNT_TAKEN length = 8
         format = 7.2
         informat = 7.2
         label = 'UNT_TAKEN',
      PS_TRNS_CRSE_DTL_Extract.CRSE_GRADE_INPUT length = 3
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_INPUT',
      PS_TRNS_CRSE_DTL_Extract.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      PS_TRNS_CRSE_DTL_Extract.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      PS_TRNS_CRSE_DTL_Extract.GRADING_SCHEME length = 3
         format = $3.
         informat = $3.
         label = 'GRADING_SCHEME',
      PS_TRNS_CRSE_DTL_Extract.GRADING_BASIS length = 3
         format = $3.
         informat = $3.
         label = 'GRADING_BASIS',
      PS_TRNS_CRSE_DTL_Extract.UNT_TRNSFR length = 8
         format = 10.3
         informat = 10.3
         label = 'UNT_TRNSFR',
      PS_TRNS_CRSE_DTL_Extract.CRSE_GRADE_OFF length = 3
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      PS_TRNS_CRSE_DTL_Extract.GRD_PTS_PER_UNIT length = 8
         format = 11.3
         informat = 11.3
         label = 'GRD_PTS_PER_UNIT',
      PS_TRNS_CRSE_DTL_Extract.EARN_CREDIT length = 1
         format = $1.
         informat = $1.
         label = 'EARN_CREDIT',
      PS_TRNS_CRSE_DTL_Extract.INCLUDE_IN_GPA length = 1
         format = $1.
         informat = $1.
         label = 'INCLUDE_IN_GPA',
      PS_TRNS_CRSE_DTL_Extract.UNITS_ATTEMPTED length = 1
         format = $1.
         informat = $1.
         label = 'UNITS_ATTEMPTED',
      PS_TRNS_CRSE_DTL_Extract.REPEAT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'REPEAT_CODE',
      PS_TRNS_CRSE_DTL_Extract.RQMNT_DESIGNTN length = 4
         format = $4.
         informat = $4.
         label = 'RQMNT_DESIGNTN',
      PS_TRNS_CRSE_DTL_Extract.FREEZE_REC_FL length = 1
         format = $1.
         informat = $1.
         label = 'FREEZE_REC_FL',
      PS_TRNS_CRSE_DTL_Extract.INPUT_CHG_FL length = 1
         format = $1.
         informat = $1.
         label = 'INPUT_CHG_FL',
      PS_TRNS_CRSE_DTL_Extract.REJECT_REASON length = 2
         format = $2.
         informat = $2.
         label = 'REJECT_REASON',
      PS_TRNS_CRSE_DTL_Extract.OVRD_TRCR_FL length = 1
         format = $1.
         informat = $1.
         label = 'OVRD_TRCR_FL',
      PS_TRNS_CRSE_DTL_Extract.OVRD_RSN length = 50
         format = $50.
         informat = $50.
         label = 'OVRD_RSN',
      PS_TRNS_CRSE_DTL_Extract.COURSE_LEVEL length = 2
         format = $2.
         informat = $2.
         label = 'COURSE_LEVEL',
      PS_TRNS_CRSE_DTL_Extract.VALID_ATTEMPT length = 1
         format = $1.
         informat = $1.
         label = 'VALID_ATTEMPT',
      PS_TRNS_CRSE_DTL_Extract.GRADE_CATEGORY length = 4
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      PS_TRNS_CRSE_DTL_Extract.COMP_SUBJECT_AREA length = 16
         format = $16.
         informat = $16.
         label = 'COMP_SUBJECT_AREA',
      PS_TRNS_CRSE_DTL_Extract.SSR_FAWI_INCL length = 1
         format = $1.
         informat = $1.
         label = 'SSR_FAWI_INCL',
      "" as COMMENTS length = 1024
         format = $1024.
         informat = $1024.
         label = 'COMMENTS',
      PS_TRNS_CRSE_DTL_Extract.READ_DTM length = 8
         format = datetime20.
         informat = datetime20.
         label = 'READ_DTM',
      PS_TRNS_CRSE_DTL_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID',
      case
      when PS_TRNS_CRSE_DTL_Extract.EXT_TERM='SPR' then 2
      when PS_TRNS_CRSE_DTL_Extract.EXT_TERM='SUMR' then 3
      when PS_TRNS_CRSE_DTL_Extract.EXT_TERM= 'FALL' then 8
      when PS_TRNS_CRSE_DTL_Extract.EXT_TERM= 'WINT' then 9
      else .
      end as num_term_crse length = 8
   from
      ADWSTGPR.PS_TRNS_CRSE_DTL_Extract as PS_TRNS_CRSE_DTL_Extract
   where
      PS_TRNS_CRSE_DTL_Extract.TERM_YEAR > 1900
   group by
      PS_TRNS_CRSE_DTL_Extract.EMPLID
   having
      PS_TRNS_CRSE_DTL_Extract.TERM_YEAR = min(PS_TRNS_CRSE_DTL_Extract.TERM_YEAR)
   ;
quit;

/*==========================================================================*
 * Step:            trns_crse min(seq)                    A5B29B8Q.BZ0005ED *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W240961K                  A5B29B8Q.BS0001LG *
 * Target Table:    Join - work.W24096VW                  A5B29B8Q.BS0001LH *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W240961K);


proc sql;
   create view work.W24096VW as
   select
      W240961K.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W240961K.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W240961K.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      W240961K.MODEL_NBR length = 8
         label = 'MODEL_NBR',
      W240961K.ARTICULATION_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ARTICULATION_TERM',
      W240961K.TRNSFR_EQVLNCY_GRP length = 8
         label = 'TRNSFR_EQVLNCY_GRP',
      W240961K.TRNSFR_EQVLNCY_SEQ length = 8
         label = 'TRNSFR_EQVLNCY_SEQ',
      W240961K.TRNSFR_STAT length = 1
         format = $1.
         informat = $1.
         label = 'TRNSFR_STAT',
      W240961K.TRNSFR_SRC_ID length = 11
         format = $11.
         informat = $11.
         label = 'TRNSFR_SRC_ID',
      W240961K.TRNSFR_EQVLNCY length = 6
         format = $6.
         informat = $6.
         label = 'TRNSFR_EQVLNCY',
      W240961K.TRNSFR_EQVLNCY_CMP length = 4
         format = $4.
         informat = $4.
         label = 'TRNSFR_EQVLNCY_CMP',
      W240961K.EXT_COURSE_NBR length = 8
         label = 'EXT_COURSE_NBR',
      W240961K.SRC_TERM length = 4
         format = $4.
         informat = $4.
         label = 'SRC_TERM',
      W240961K.SRC_CLASS_NBR length = 8
         label = 'SRC_CLASS_NBR',
      W240961K.TERM_YEAR length = 8
         label = 'TERM_YEAR',
      W240961K.EXT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXT_TERM',
      W240961K.SCHOOL_SUBJECT length = 8
         format = $8.
         informat = $8.
         label = 'SCHOOL_SUBJECT',
      W240961K.SCHOOL_CRSE_NBR length = 10
         format = $10.
         informat = $10.
         label = 'SCHOOL_CRSE_NBR',
      W240961K.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      W240961K.SSR_UNT_TAKEN_EXT length = 8
         format = 7.2
         informat = 7.2
         label = 'SSR_UNT_TAKEN_EXT',
      W240961K.UNT_TAKEN length = 8
         format = 7.2
         informat = 7.2
         label = 'UNT_TAKEN',
      W240961K.CRSE_GRADE_INPUT length = 3
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_INPUT',
      W240961K.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W240961K.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W240961K.GRADING_SCHEME length = 3
         format = $3.
         informat = $3.
         label = 'GRADING_SCHEME',
      W240961K.GRADING_BASIS length = 3
         format = $3.
         informat = $3.
         label = 'GRADING_BASIS',
      W240961K.UNT_TRNSFR length = 8
         format = 10.3
         informat = 10.3
         label = 'UNT_TRNSFR',
      W240961K.CRSE_GRADE_OFF length = 3
         format = $3.
         informat = $3.
         label = 'CRSE_GRADE_OFF',
      W240961K.GRD_PTS_PER_UNIT length = 8
         format = 11.3
         informat = 11.3
         label = 'GRD_PTS_PER_UNIT',
      W240961K.EARN_CREDIT length = 1
         format = $1.
         informat = $1.
         label = 'EARN_CREDIT',
      W240961K.INCLUDE_IN_GPA length = 1
         format = $1.
         informat = $1.
         label = 'INCLUDE_IN_GPA',
      W240961K.UNITS_ATTEMPTED length = 1
         format = $1.
         informat = $1.
         label = 'UNITS_ATTEMPTED',
      W240961K.REPEAT_CODE length = 4
         format = $4.
         informat = $4.
         label = 'REPEAT_CODE',
      W240961K.RQMNT_DESIGNTN length = 4
         format = $4.
         informat = $4.
         label = 'RQMNT_DESIGNTN',
      W240961K.FREEZE_REC_FL length = 1
         format = $1.
         informat = $1.
         label = 'FREEZE_REC_FL',
      W240961K.INPUT_CHG_FL length = 1
         format = $1.
         informat = $1.
         label = 'INPUT_CHG_FL',
      W240961K.REJECT_REASON length = 2
         format = $2.
         informat = $2.
         label = 'REJECT_REASON',
      W240961K.OVRD_TRCR_FL length = 1
         format = $1.
         informat = $1.
         label = 'OVRD_TRCR_FL',
      W240961K.OVRD_RSN length = 50
         format = $50.
         informat = $50.
         label = 'OVRD_RSN',
      W240961K.COURSE_LEVEL length = 2
         format = $2.
         informat = $2.
         label = 'COURSE_LEVEL',
      W240961K.VALID_ATTEMPT length = 1
         format = $1.
         informat = $1.
         label = 'VALID_ATTEMPT',
      W240961K.GRADE_CATEGORY length = 4
         format = $4.
         informat = $4.
         label = 'GRADE_CATEGORY',
      W240961K.COMP_SUBJECT_AREA length = 16
         format = $16.
         informat = $16.
         label = 'COMP_SUBJECT_AREA',
      W240961K.SSR_FAWI_INCL length = 1
         format = $1.
         informat = $1.
         label = 'SSR_FAWI_INCL',
      W240961K.COMMENTS length = 1024
         format = $1024.
         informat = $1024.
         label = 'COMMENTS',
      W240961K.READ_DTM length = 8
         format = datetime20.
         informat = datetime20.
         label = 'READ_DTM',
      W240961K.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID',
      W240961K.num_term_crse length = 8
   from
      work.W240961K as W240961K
   group by
      W240961K.EMPLID
   having
      W240961K.num_term_crse = min(W240961K.num_term_crse)
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005EE *
 * Transform:       Join                                                    *
 * Description:     TRANSF 0998                                             *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  Join - work.W24097Q9                  A5B29B8Q.BS0001LF *
 *                  Join - work.W24096VW                  A5B29B8Q.BS0001LH *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W24098KK                  A5B29B8Q.BS0001LI *
 *==========================================================================*/

proc sql;
   create view work.W24098KK as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      case
         when W24096VW.EXT_TERM = 'SPR'
            then catt(substr(put(W24096VW.TERM_YEAR,4.) ,1,1),substr(put(W24096VW.TERM_YEAR,4.) ,3,2),'2')
         when W24096VW.EXT_TERM = 'SUMR'
            then catt(substr(put(W24096VW.TERM_YEAR,4.) ,1,1),substr(put(W24096VW.TERM_YEAR,4.) ,3,2),'3')
         when W24096VW.EXT_TERM = 'FALL'
            then catt(substr(put(W24096VW.TERM_YEAR,4.) ,1,1),substr(put(W24096VW.TERM_YEAR,4.) ,3,2),'8')
         when W24096VW.EXT_TERM = 'WINT'
            then catt(substr(put(W24096VW.TERM_YEAR,4.) ,1,1),substr(put(W24096VW.TERM_YEAR,4.) ,3,2),'9')
      else ' '
      end as TRANS_STRM length = 4
         label = 'TRANS_STRM',
      W24097Q9.trns_STRM length = 4
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            student_list.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      work.W24096VW as W24096VW
         on
         (
            student_list.EMPLID = W24096VW.EMPLID
            and ADW_TERM_DIM.INSTITUTION = W24096VW.INSTITUTION
         ) left join
      work.W24097Q9 as W24097Q9
         on
         (
            student_list.EMPLID = W24097Q9.EMPLID
         )
   where
      W24096VW.TERM_YEAR > 1900
      or W24097Q9.TERM_YEAR > 1900
   group by
      student_list.EMPLID
   having
      W24096VW.TERM_YEAR = min(W24096VW.TERM_YEAR )
   ;
quit;

/*==========================================================================*
 * Step:            not missing transfer strm             A5B29B8Q.BZ0005EF *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W24098KK                  A5B29B8Q.BS0001LI *
 * Target Table:    Join - work.W24099EW                  A5B29B8Q.BS0001LJ *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W24098KK);


proc sql;
   create view work.W24099EW as
   select
      W24098KK.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W24098KK.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      W24098KK.TRANS_STRM length = 4
         label = 'TRANS_STRM',
      W24098KK.trns_STRM length = 4,
      put(min(input(coalescec(W24098KK.TRANS_STRM,'9999'),4.),input(coalescec(W24098KK.trns_STRM,'9999'),4.)),4.) as transfr_strm length = 4
   from
      work.W24098KK as W24098KK
   where
      W24098KK.TRANS_STRM NOT IS MISSING
      or W24098KK.trns_STRM NOT IS MISSING
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005EG *
 * Transform:       Join                                                    *
 * Description:     Flag for TRANSF 0998                                    *
 *                                                                          *
 * Source Table:    Join - work.W24099EW                  A5B29B8Q.BS0001LJ *
 * Target Table:    Join - work.W24092O9                  A5B29B8Q.BS0001LK *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W24099EW);


proc sql;
   create view work.W24092O9 as
   select distinct
      W24099EW.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W24099EW.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      case
         when substr(W24099EW.transfr_strm ,1,1)='1'
            then catt('0',substr(W24099EW.transfr_strm ,2,3))
      else W24099EW.transfr_strm
      end as TRANS_STRM length = 4
         label = 'TRANS_STRM',
      case
         when W24099EW.transfr_strm < '1998'
            then 'Y'
      else ' '
      end as PRE_0998 length = 8
         label = 'PRE_0998'
   from
      work.W24099EW as W24099EW
   ;
quit;

/*==========================================================================*
 * Step:            get units taken                       A5B29B8Q.BZ0005EH *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K *
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    units_taken_for_uglimit -             A5B29B8Q.BS0001LL *
 *                   work.W2409058                                          *
 *==========================================================================*/

proc sql;
   create view work.W2409058 as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      student_list.FLEX length = 1
         label = 'FLEX',
      student_list.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      sum(PS_STDNT_CAR_TERM_Extract.UNT_PASSD_PRGRSS) as Units_taken length = 8
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list inner join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            student_list.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWSTGPR.PS_STDNT_CAR_TERM_Extract as PS_STDNT_CAR_TERM_Extract
         on
         (
            student_list.EMPLID = PS_STDNT_CAR_TERM_Extract.EMPLID
            and ADW_ACAD_CAREER_DIM.ACAD_CAREER = PS_STDNT_CAR_TERM_Extract.ACAD_CAREER
         )
   group by
      student_list.EMPLID,
      student_list.ACAD_CAREER_SK,
      student_list.TERM_SK,
      student_list.FLEX
   ;
quit;

/*==========================================================================*
 * Step:            get STRM min                          A5B29B8Q.BZ0005EI *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W2408ZAY                  A5B29B8Q.BS0001LM *
 *==========================================================================*/

proc sql;
   create view work.W2408ZAY as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      student_list.FLEX length = 1
         label = 'FLEX',
      student_list.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      min(PS_STDNT_ENRL_Extract.STRM) as STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list inner join
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract
         on
         (
            student_list.EMPLID = PS_STDNT_ENRL_Extract.EMPLID
         ) inner join
      ADWSTGPR.PS_CLASS_TBL_Extract as PS_CLASS_TBL_Extract
         on
         (
            PS_CLASS_TBL_Extract.CLASS_NBR = PS_STDNT_ENRL_Extract.CLASS_NBR
            and PS_CLASS_TBL_Extract.STRM = PS_STDNT_ENRL_Extract.STRM
            and PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS = 'E'
            and (PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST <> 'CENS'
            or PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST IS NULL )
         ) inner join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            PS_CLASS_TBL_Extract.ACAD_CAREER = ADW_TERM_DIM.ACAD_CAREER
            and ADW_TERM_DIM.STRM = PS_STDNT_ENRL_Extract.STRM
         )
   where
      PS_STDNT_ENRL_Extract.STRM <= "&term."
      and (PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST <> 'CENS'
      or PS_STDNT_ENRL_Extract.ENRL_ACTN_RSN_LAST IS NULL )
      and PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS = 'E'
      and not ((PS_CLASS_TBL_Extract.STRM = "&term."
      and PS_CLASS_TBL_Extract.END_DT <= ADW_TERM_DIM.CENSUS_DT
      and PS_CLASS_TBL_Extract.SESSION_CODE = 'DYN')
      or (PS_STDNT_ENRL_Extract.STRM = "&prev_term."
      and PS_CLASS_TBL_Extract.SESSION_CODE = 'DYN'
      and PS_CLASS_TBL_Extract.END_DT > ADW_TERM_DIM.CENSUS_DT)
      or (PS_CLASS_TBL_Extract.SESSION_CODE IN ('1','5W1','5W2','11W','ISS','ISW','14W')
      and PS_STDNT_ENRL_Extract.STRM = "&term."))
      and (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
      or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
   group by
      student_list.EMPLID,
      student_list.TERM_SK,
      student_list.FLEX
   ;
quit;

/*==========================================================================*
 * Step:            check 2yr prev courses                A5B29B8Q.BZ0005EJ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_STUDENT_CLASS_ENRL_5YR_MV -       A5B29B8Q.BE0000SR *
 *                  ADWTGTPR.ADW_STUDENT_CLASS_ENRL_5YR                     *
 *                  _MV                                                     *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W2408YGK                  A5B29B8Q.BS0001LN *
 *==========================================================================*/

proc sql;
   create table work.W2408YGK as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      student_list.FLEX length = 1
         label = 'FLEX',
      student_list.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      max(ADW_STUDENT_CLASS_ENRL_5YR_MV.CLASS_NBR) as CLASS_NBR length = 8
         label = 'CLASS_NBR'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      ADWTGTPR.ADW_STUDENT_CLASS_ENRL_5YR_MV as ADW_STUDENT_CLASS_ENRL_5YR_MV
         on
         (
            student_list.EMPLID = ADW_STUDENT_CLASS_ENRL_5YR_MV.EMPLID
         )
   where
      ADW_STUDENT_CLASS_ENRL_5YR_MV.STRM <= "&term."
      and ADW_STUDENT_CLASS_ENRL_5YR_MV.STRM >= "&two_year_prev_term."
      and ADW_STUDENT_CLASS_ENRL_5YR_MV.STUDENT_ENRL_FLG = 'Y'
      and coalescec(ADW_STUDENT_CLASS_ENRL_5YR_MV.LAST_ENRL_ACTION_RSN,' ') <> 'CENS'
      and not (ADW_STUDENT_CLASS_ENRL_5YR_MV.STRM = "&term."
      and ADW_STUDENT_CLASS_ENRL_5YR_MV.CLASS_END_DT <= ADW_STUDENT_CLASS_ENRL_5YR_MV.CENSUS_DT
      and ADW_STUDENT_CLASS_ENRL_5YR_MV.SESSION_CD = 'DYN')
      and not (ADW_STUDENT_CLASS_ENRL_5YR_MV.STRM = "&prev_term."
      and ADW_STUDENT_CLASS_ENRL_5YR_MV.SESSION_CD = 'DYN'
      and ADW_STUDENT_CLASS_ENRL_5YR_MV.CLASS_END_DT > ADW_STUDENT_CLASS_ENRL_5YR_MV.CENSUS_DT)
      and not (ADW_STUDENT_CLASS_ENRL_5YR_MV.SESSION_CD IN ('1','5W1','5W2','11W','ISS','ISW','14W')
      and ADW_STUDENT_CLASS_ENRL_5YR_MV.STRM = "&term.")
   group by
      student_list.FLEX,
      student_list.TERM_SK,
      student_list.EMPLID
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005EK *
 * Transform:       Join                                                    *
 * Description:     Pre 1998                                                *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W24091TW                  A5B29B8Q.BS0001LO *
 *==========================================================================*/

proc sql;
   create view work.W24091TW as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      PS_STDNT_ENRL_Extract.STRM as MIN_STRM length = 4
         label = 'MIN_STRM',
      case
         when PS_STDNT_ENRL_Extract.STRM < '0998'
            then 'Y'
      else ' '
      end as PRE_0998 length = 1
         label = 'PRE_0998'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            student_list.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract
         on
         (
            student_list.EMPLID = PS_STDNT_ENRL_Extract.EMPLID
         )
   where
      PS_STDNT_ENRL_Extract.STDNT_ENRL_STATUS = 'E'
      and (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
      or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
   group by
      student_list.EMPLID
   having
      PS_STDNT_ENRL_Extract.STRM = min(PS_STDNT_ENRL_Extract.STRM )
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005EL *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W2408YGK                  A5B29B8Q.BS0001LN *
 *                  Join - work.W2408ZAY                  A5B29B8Q.BS0001LM *
 *                  units_taken_for_uglimit -             A5B29B8Q.BS0001LL *
 *                   work.W2409058                                          *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W24090ZK                  A5B29B8Q.BS0001LP *
 *==========================================================================*/

proc sql;
   create view work.W24090ZK as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      student_list.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      student_list.FLEX length = 1
         label = 'FLEX',
      student_list.SESSION_CD length = 20
         format = $20.
         informat = $20.
         label = 'SESSION_CD',
      student_list.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      case
      	when ((W2408YGK.CLASS_NBR is missing or W2408YGK.CLASS_NBR is null) and (W2408ZAY.STRM is not missing or W2408ZAY.STRM is not null) and (W2409058.Units_taken >=50)) then 5

      else .
      end as two_year_flag length = 8,
      W2408YGK.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      W2409058.Units_taken length = 8,
      W2408ZAY.STRM as min_strm length = 4
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      work.W2408YGK as W2408YGK
         on
         (
            student_list.EMPLID = W2408YGK.EMPLID
         ) left join
      work.W2408ZAY as W2408ZAY
         on
         (
            student_list.EMPLID = W2408ZAY.EMPLID
         ) left join
      work.W2409058 as W2409058
         on
         (
            student_list.EMPLID = W2409058.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005EM *
 * Transform:       Join                                                    *
 * Description:     UG_Limit                                                *
 *                                                                          *
 * Source Tables:   Join - work.W24091TW                  A5B29B8Q.BS0001LO *
 *                  Join - work.W24092O9                  A5B29B8Q.BS0001LK *
 *                  Join - work.W24090ZK                  A5B29B8Q.BS0001LP *
 * Target Table:    Join - work.W24093IL                  A5B29B8Q.BS0001LQ *
 *==========================================================================*/

proc sql;
   create table work.W24093IL as
   select distinct
      W24091TW.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W24091TW.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      case
      when  W24090ZK.two_year_flag =5 then '5'
         when coalescec(W24091TW.PRE_0998,' ') = 'Y' | coalescec(W24092O9.PRE_0998 ,' ')='Y'     then '0'
         when not ( coalescec(W24091TW.PRE_0998,' ') = 'Y' | coalescec(W24092O9.PRE_0998 ,' ')='Y') then case

         		when ((W24092O9.TRANS_STRM <W24091TW.MIN_STRM  & W24092O9.TRANS_STRM  ^= ' ') | W24092O9.TRANS_STRM =W24091TW.MIN_STRM )
         			then case when W24092O9.TRANS_STRM >='2068' then '2'
            						else '1'
            						end
            		else case when	W24091TW.MIN_STRM >='2068' then '2'
            						else '1'
            						end
      end
      when  W24090ZK.two_year_flag =5 then '5'
      else ''
      end

      /*
      case

         when coalescec(W24091TW.PRE_0998,' ') = 'Y' | coalescec(W24092O9.PRE_0998 ,' ')='Y'     then '0'
      when W24090ZK.two_year_flag =5 then '5'
         else case

         		when ((W24092O9.TRANS_STRM <W24091TW.MIN_STRM  & W24092O9.TRANS_STRM  ^= ' ') | W24092O9.TRANS_STRM =W24091TW.MIN_STRM )
         			then case when W24092O9.TRANS_STRM >='2068' then '2'
            						else '1'
            						end
            		else case when	W24091TW.MIN_STRM >='2068' then '2'
            						else '1'
            						end
      end

      end
      */ as UG_LIMIT length = 1
         label = 'UG_LIMIT'
   from
      work.W24091TW as W24091TW left join
      work.W24092O9 as W24092O9
         on
         (
            W24091TW.EMPLID = W24092O9.EMPLID
         ) left join
      work.W24090ZK as W24090ZK
         on
         (
            W24091TW.EMPLID = W24090ZK.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            uglimit remove some dupes             A5B29B8Q.BZ0005EN *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W24093IL                  A5B29B8Q.BS0001LQ *
 * Target Table:    Join - work.W24094CX                  A5B29B8Q.BS0001LR *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W24093IL);


proc sql;
   create table work.W24094CX as
   select
      W24093IL.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W24093IL.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      W24093IL.UG_LIMIT length = 1
         label = 'UG_LIMIT'
   from
      work.W24093IL as W24093IL
   group by
      W24093IL.EMPLID
   having
      W24093IL.UG_LIMIT = min(W24093IL.UG_LIMIT )
   ;
quit;

/*==========================================================================*
 * Step:            Table Loader                          A5B29B8Q.BZ0005EO *
 * Transform:       Table Loader (Version 2.1)                              *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W24094CX                  A5B29B8Q.BS0001LR *
 * Target Table:    CBM1_UGLIMIT - ADWTGTPR.CBM1_UGLIMIT  A5B29B8Q.BE00018M *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W24094CX);

/* --------------------------------------------------------------
   Load Technique Selection: Replace - Truncate
   Constraint and index action selections: 'ASIS','ASIS','ASIS','ASIS'
   Additional options selections...
      Set unmapped to missing on updates: false
   -------------------------------------------------------------- */
%macro etls_loader;


   /* Determine if the target table exists  */
         %sysfunc(exist(ADWTGTPR.CBM1_UGLIMIT, VIEW)));

   /*---- Create a new table  ----*/
   %if (&etls_tableExist eq 0) %then
   %do;  /* if table does not exist  */

      %put %str(NOTE: Creating table ...);

      data ADWTGTPR.CBM1_UGLIMIT
              (dbnull = (
                         EMPLID = NO
                         ACAD_CAREER_SK = NO
                         UG_LIMIT = YES));
         attrib EMPLID length = $11
            format = $11.
            informat = $11.
            label = 'EMPLID';
         attrib ACAD_CAREER_SK length = 8
            label = 'ACAD_CAREER_SK';
         attrib UG_LIMIT length = $1
            label = 'UG_LIMIT';
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
            truncate table ADWTGTPRD.CBM1_UGLIMIT
         ) by ORACLE;

         %rcSet(&sqlrc);

         disconnect from ORACLE;
      quit;


   %end; /* table exists */

   /*---- Append  ----*/
   %put %str(NOTE: Appending data ...);

   proc append base = ADWTGTPR.CBM1_UGLIMIT
      data = &etls_lastTable (&etls_tableOptions)  force ;
    run;


%mend etls_loader;
%etls_loader;

/**  Job end UGLIMIT **/

/* Reset jobid and name */

/*==========================================================================*
 * Step:            Check lifetime GDR                    A5B29B8Q.BZ000BNJ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_SRVC_IND_DATA_Extract -            A5B29B8Q.BE00000Q *
 *                   ADWSTGPR.PS_SRVC_IND_DATA_Extract                      *
 * Target Table:    Join - work.W6WYTF6N                  A5B29B8Q.BS00041D *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_SRVC_IND_DATA_Extract);


proc sql;
   create view work.W6WYTF6N as
   select distinct
      PS_SRVC_IND_DATA_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_SRVC_IND_DATA_Extract.SRVC_IND_CD length = 3
         format = $3.
         informat = $3.
         label = 'SRVC_IND_CD'
   from
      ADWSTGPR.PS_SRVC_IND_DATA_Extract as PS_SRVC_IND_DATA_Extract
   where
      PS_SRVC_IND_DATA_Extract.SRVC_IND_ACT_TERM <= "&term."
      and PS_SRVC_IND_DATA_Extract.SRVC_IND_CD = 'GDR'
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNK *
 * Transform:       Join                                                    *
 * Description:     ClassificationMajor area of concentrationRestricted     *
 *                   ProgramNDS                                             *
 *                                                                          *
 * Source Tables:   ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  ADW_ACAD_PLAN_DIM -                   A5B29B8Q.BE0000RF *
 *                   ADWTGTPR.ADW_ACAD_PLAN_DIM                             *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J *
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          *
 *                  ADW_CIP_DIM - ADWTGTPR.ADW_CIP_DIM    A5B29B8Q.BE0000RL *
 *                  Join - work.W6WYTF6N                  A5B29B8Q.BS00041D *
 * Target Table:    CBM1_CLASSIFICATION_INFO -            A5B29B8Q.BE00018H *
 *                   ADWTGTPR.CBM1_CLASSIFICATION_INFO                      *
 *==========================================================================*/

proc sql;
   create table ADWTGTPR.CBM1_CLASSIFICATION_INFO as
   select distinct
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      ADW_ACAD_PLAN_DIM.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      ADW_ACAD_CAREER_DIM.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_LVL_LOAD_BOT length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LVL_LOAD_BOT',
      "" as SRVC_IND_CD length = 3
         format = $3.
         informat = $3.
         label = 'SRVC_IND_CD',
      "" as SRVC_IND_ACT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'SRVC_IND_ACT_TERM',
      . as SRVC_IND_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SRVC_IND_DTTM',
      ADW_STUDENT_TERM_ENRL_FACT.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      case
         when ADW_STUDENT_TERM_ENRL_FACT.ACAD_LVL_LOAD_BOT   = '10'
            then '1'
         when  ADW_STUDENT_TERM_ENRL_FACT.ACAD_LVL_LOAD_BOT  = '20'
            then '2'
         when  ADW_STUDENT_TERM_ENRL_FACT.ACAD_LVL_LOAD_BOT  = '30'
            then '3'
         when  ADW_STUDENT_TERM_ENRL_FACT.ACAD_LVL_LOAD_BOT  = '40'
            then '4'
         when  ADW_STUDENT_TERM_ENRL_FACT.ACAD_LVL_LOAD_BOT  = '50'  |
       ADW_STUDENT_TERM_ENRL_FACT.ACAD_LVL_LOAD_BOT  = '60'
            then '5'
         when ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM  in ('DOCT')  & substr(substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,6),length(substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,6))-1,-1)  = 'DB'  &  W6WYTF6N.SRVC_IND_CD = 'GDR'
            then '7'
         when ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM  in ('MASTR','CERT','SPEC')
            then '6'
         when ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM  in ('DOCT')  &
      substr(substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,6),length(substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,6))-1,-1)  = 'DB'
            then '6'
         when ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM  in ('DOCT')  &
      substr(substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,6),length(substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,6))-1,-1)   ^=  'DB'
            then '7'
      else ''
      end as CLASS length = 1
         label = 'CLASS',
      substr(compress(ADW_CIP_DIM.CIP_ALTERNATIVE_CD  , '.'),1,8)

      /*
      case
         when length(compress(ADW_ACAD_PLAN_DIM.CIP_CD , '.'))=6
            then catt(compress(ADW_ACAD_PLAN_DIM.CIP_CD , '.'), '00')
         when length(compress(ADW_ACAD_PLAN_DIM.CIP_CD , '.'))=7
            then catt(compress(ADW_ACAD_PLAN_DIM.CIP_CD , '.'), '0')
      else compress(ADW_ACAD_PLAN_DIM.CIP_CD , '.')
      end
      */ as CIP_CD length = 8
         format = $8.
         informat = $8.
         label = 'CIP_CD',
      case
         when substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,7,3) = 'TCH'  |
      substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,4) = 'CHST'  |
      substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,4) = 'CHBL'  |
      substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,4) = 'IAED'  |
      substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,4) = 'ISED'  |
      substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1,4) = 'EDUC'
            then '01'
         when ADW_ACAD_PLAN_DIM.ACAD_PLAN  = 'EDTEETNTAL'  |
      ADW_ACAD_PLAN_DIM.ACAD_PLAN = 'EDTEETNTEC' |
      ADW_ACAD_PLAN_DIM.ACAD_PLAN = 'EDTEETNTML' |
      ADW_ACAD_PLAN_DIM.ACAD_PLAN = 'EDTEETNTSD'
            then '02'
         when ADW_ACAD_PLAN_DIM.ACAD_PLAN  = 'EDTECTAL'  |
      ADW_ACAD_PLAN_DIM.ACAD_PLAN = 'EDTECTEC'  |
      ADW_ACAD_PLAN_DIM.ACAD_PLAN = 'EDTECTML'  |
       ADW_ACAD_PLAN_DIM.ACAD_PLAN = 'EDTECTSD'
            then '04'
         when ADW_ACAD_PLAN_DIM.SHORT_DESCR = 'RN-TO-BSN'
            then '10'
         when ADW_ACAD_PLAN_DIM.SHORT_DESCR = 'BSN'
            then '12'
         when substr(ADW_ACAD_PLAN_DIM.ACAD_PLAN,1 ,4 )  = 'MEDT'
            then '23'
      else ''
      end as RESTRICTED length = 2
         label = 'RESTRICTED',
      case
         when PS_ACAD_PROG_Extract.PROG_STATUS is null  &  (ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM = 'UGNDS'  |  ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM = 'SPEC')
            then '1'
      else '0'
      end as NDS length = 1
         label = 'NDS',
      ADW_ACAD_PLAN_DIM.CIP_CD as CIP_CD_Unedited length = 130
         format = $130.
         informat = $130.,
      ADW_STUDENT_TERM_ENRL_FACT.STUDENT_CAREER_NBR length = 8
         label = 'STUDENT_CAREER_NBR',
      ADW_TERM_DIM.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT left join
      work.W6WYTF6N as W6WYTF6N
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.EMPLID = W6WYTF6N.EMPLID
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWTGTPR.ADW_ACAD_PROGRAM_DIM as ADW_ACAD_PROGRAM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY = ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_PLAN_DIM as ADW_ACAD_PLAN_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.MAJOR_ACAD_PLAN_SK = ADW_ACAD_PLAN_DIM.ACAD_PLAN_SK
         ) left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWSTGPR.PS_ACAD_PROG_Extract as PS_ACAD_PROG_Extract
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.EMPLID = PS_ACAD_PROG_Extract.EMPLID
            and PS_ACAD_PROG_Extract.PROG_STATUS = 'AC'
            and PS_ACAD_PROG_Extract.ACAD_PROG <> ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM
         ) left join
      ADWTGTPR.ADW_CIP_DIM as ADW_CIP_DIM
         on
         (
            ADW_ACAD_PLAN_DIM.CIP_CD = ADW_CIP_DIM.CIP_CD
            and ADW_CIP_DIM.CURRENT_ROW_IND = 'Y'
         )
   group by
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK,
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID
   having
      W6WYTF6N.EMPLID = max(W6WYTF6N.EMPLID  )
   ;
quit;

/****************************************************************************
 * Job:             UGDEGR                                A5B29B8Q.BT0000QS *
 * Description:     used to populate the cbm1 ugdegr and req_term tables    *
 *                                                                          *
 * Metadata Server: sasmetapaws8.ua.uta.edu                                 *
 * Port:            8561                                                    *
 * Location:        /UTA/ADW/400 Reports/CBM/Jobs/CBM1 CBME1 Sub Jobs       *
 *                                                                          *
 * Server:          SASApp                                A5B29B8Q.AS000002 *
 *                                                                          *
 * Source Tables:   PS_UTA_ACADPLAN_DTL_Extract -         A5B29B8Q.BE00000O *
 *                   ADWSTGPR.PS_UTA_ACADPLAN_DTL_Extract                   *
 *                  CBM1_REQ_TERM -                       A5B29B8Q.BE00018I *
 *                   ADWTGTPR.CBM1_REQ_TERM                                 *
 *                  PS_ACAD_PLAN_Extract -                A5B29B8Q.BE00000G *
 *                   ADWSTGPR.PS_ACAD_PLAN_Extract                          *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  CBM1_CLASSIFICATION_INFO -            A5B29B8Q.BE00018H *
 *                   ADWTGTPR.CBM1_CLASSIFICATION_INFO                      *
 *                  PS_ACAD_PLAN_TBL_Extract -            A5B29B8Q.BE00000H *
 *                   ADWSTGPR.PS_ACAD_PLAN_TBL_Extract                      *
 * Target Tables:   CBM1_UGDEGR - ADWTGTPR.CBM1_UGDEGR    A5B29B8Q.BE00018L *
 *                  CBM1_REQ_TERM -                       A5B29B8Q.BE00018I *
 *                   ADWTGTPR.CBM1_REQ_TERM                                 *
 *                                                                          *
 * Generated on:    Thursday, May 7, 2026 1:54:27 PM CDT                    *
 * Generated by:    mynenit                                                 *
 * Version:         SAS Data Integration Studio 4.905                       *
 ****************************************************************************/

%global etls_debug;
%macro etls_setDebug;
   %if %str(&etls_debug) ne 0 %then
      OPTIONS MPRINT%str(;);
%mend;
%etls_setDebug;

/*==========================================================================*
 * Step:            Macros                                A5B29B8Q.BZ0005E0 *
 * Transform:       User Written                                            *
 * Description:     Uncomment or populate here for manual testing           *
 *                                                                          *
 * Target Table:    User Written - work.W23VF6L3          A5B29B8Q.BS0002B5 *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*/


%let _OUTPUT = work.W23VF6L3;

%let _OUTPUT1_col_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/

/*
%let term_end_dt ='13AUG2019:00:00:00'dt;
%let term=2195;
%let prev_term=2192;
%let two_year_prev_term=2175;
%let term_sk_filter=373;
*/
/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            Acad_plan maxeffdt                    A5B29B8Q.BZ0005E1 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ACAD_PLAN_Extract -                A5B29B8Q.BE00000G *
 *                   ADWSTGPR.PS_ACAD_PLAN_Extract                          *
 * Target Table:    Join - work.W23V7YGZ                  A5B29B8Q.BS0001L8 *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_ACAD_PLAN_Extract);


proc sql;
   create view work.W23V7YGZ as
   select
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
         label = 'SCC_ROW_UPD_DTTM',
      PS_ACAD_PLAN_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ACAD_PLAN_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_ACAD_PLAN_Extract as PS_ACAD_PLAN_Extract
   where
      PS_ACAD_PLAN_Extract.EFFDT <= &term_end_dt.
   group by
      PS_ACAD_PLAN_Extract.EMPLID,
      PS_ACAD_PLAN_Extract.ACAD_CAREER,
      PS_ACAD_PLAN_Extract.STDNT_CAR_NBR
   having
      PS_ACAD_PLAN_Extract.EFFDT = max(PS_ACAD_PLAN_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            Acad_plan max(effseq)                 A5B29B8Q.BZ0005E2 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W23V7YGZ                  A5B29B8Q.BS0001L8 *
 * Target Table:    Join - work.W23V7ZBA                  A5B29B8Q.BS0001L9 *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W23V7YGZ);


proc sql;
   create view work.W23V7ZBA as
   select
      W23V7YGZ.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W23V7YGZ.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W23V7YGZ.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      W23V7YGZ.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W23V7YGZ.EFFSEQ length = 8
         label = 'EFFSEQ',
      W23V7YGZ.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W23V7YGZ.DECLARE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DECLARE_DT',
      W23V7YGZ.PLAN_SEQUENCE length = 8
         label = 'PLAN_SEQUENCE',
      W23V7YGZ.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W23V7YGZ.COMPLETION_TERM length = 4
         format = $4.
         informat = $4.
         label = 'COMPLETION_TERM',
      W23V7YGZ.STDNT_DEGR length = 2
         format = $2.
         informat = $2.
         label = 'STDNT_DEGR',
      W23V7YGZ.DEGR_CHKOUT_STAT length = 2
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      W23V7YGZ.ADVIS_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'ADVIS_STATUS',
      W23V7YGZ.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      W23V7YGZ.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      W23V7YGZ.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      W23V7YGZ.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      W23V7YGZ.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      W23V7YGZ.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      W23V7YGZ.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      W23V7YGZ.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      work.W23V7YGZ as W23V7YGZ
   group by
      W23V7YGZ.ACAD_CAREER,
      W23V7YGZ.EMPLID,
      W23V7YGZ.STDNT_CAR_NBR
   having
      W23V7YGZ.EFFSEQ = max(W23V7YGZ.EFFSEQ)
   ;
quit;

/*==========================================================================*
 * Step:            acad_plan_tbl max(effdt)              A5B29B8Q.BZ0005E3 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ACAD_PLAN_TBL_Extract -            A5B29B8Q.BE00000H *
 *                   ADWSTGPR.PS_ACAD_PLAN_TBL_Extract                      *
 * Target Table:    Join - work.W23V805O                  A5B29B8Q.BS0001LA *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_ACAD_PLAN_TBL_Extract);


proc sql;
   create view work.W23V805O as
   select
      PS_ACAD_PLAN_TBL_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_ACAD_PLAN_TBL_Extract.EFF_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'EFF_STATUS',
      PS_ACAD_PLAN_TBL_Extract.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      PS_ACAD_PLAN_TBL_Extract.DESCRSHORT length = 10
         format = $10.
         informat = $10.
         label = 'DESCRSHORT',
      PS_ACAD_PLAN_TBL_Extract.PLN_REQTRM_DFLT length = 1
         format = $1.
         informat = $1.
         label = 'PLN_REQTRM_DFLT',
      PS_ACAD_PLAN_TBL_Extract.DIPLOMA_DESCR length = 100
         format = $100.
         informat = $100.
         label = 'DIPLOMA_DESCR',
      PS_ACAD_PLAN_TBL_Extract.DIPLOMA_PRINT_FL length = 1
         format = $1.
         informat = $1.
         label = 'DIPLOMA_PRINT_FL',
      PS_ACAD_PLAN_TBL_Extract.DIPLOMA_INDENT length = 8
         label = 'DIPLOMA_INDENT',
      PS_ACAD_PLAN_TBL_Extract.TRNSCR_DESCR length = 100
         format = $100.
         informat = $100.
         label = 'TRNSCR_DESCR',
      PS_ACAD_PLAN_TBL_Extract.TRNSCR_PRINT_FL length = 1
         format = $1.
         informat = $1.
         label = 'TRNSCR_PRINT_FL',
      PS_ACAD_PLAN_TBL_Extract.TRNSCR_INDENT length = 8
         label = 'TRNSCR_INDENT',
      PS_ACAD_PLAN_TBL_Extract.FIRST_TERM_VALID length = 4
         format = $4.
         informat = $4.
         label = 'FIRST_TERM_VALID',
      PS_ACAD_PLAN_TBL_Extract.HEGIS_CODE length = 8
         format = $8.
         informat = $8.
         label = 'HEGIS_CODE',
      PS_ACAD_PLAN_TBL_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_ACAD_PLAN_TBL_Extract.TRANSCRIPT_LEVEL length = 2
         format = $2.
         informat = $2.
         label = 'TRANSCRIPT_LEVEL',
      PS_ACAD_PLAN_TBL_Extract.STUDY_FIELD length = 10
         format = $10.
         informat = $10.
         label = 'STUDY_FIELD',
      PS_ACAD_PLAN_TBL_Extract.EVALUATE_PLAN length = 1
         format = $1.
         informat = $1.
         label = 'EVALUATE_PLAN',
      PS_ACAD_PLAN_TBL_Extract.SSR_LAST_PRS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SSR_LAST_PRS_DT',
      PS_ACAD_PLAN_TBL_Extract.SSR_LAST_ADM_TERM length = 4
         format = $4.
         informat = $4.
         label = 'SSR_LAST_ADM_TERM',
      PS_ACAD_PLAN_TBL_Extract.SAA_WHIF_DISP_ADVR length = 1
         format = $1.
         informat = $1.
         label = 'SAA_WHIF_DISP_ADVR',
      PS_ACAD_PLAN_TBL_Extract.SAA_WHIF_DISP_PREM length = 1
         format = $1.
         informat = $1.
         label = 'SAA_WHIF_DISP_PREM',
      PS_ACAD_PLAN_TBL_Extract.SAA_WHIF_DISP_STD length = 1
         format = $1.
         informat = $1.
         label = 'SAA_WHIF_DISP_STD',
      PS_ACAD_PLAN_TBL_Extract.SSR_NSC_CRD_LVL length = 1
         format = $1.
         informat = $1.
         label = 'SSR_NSC_CRD_LVL',
      PS_ACAD_PLAN_TBL_Extract.SSR_PROG_LEN_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'SSR_PROG_LEN_TYPE',
      PS_ACAD_PLAN_TBL_Extract.SSR_PROG_LENGTH length = 8
         format = 9.3
         informat = 9.3
         label = 'SSR_PROG_LENGTH',
      PS_ACAD_PLAN_TBL_Extract.SFA_SPEC_PROG_FLG length = 1
         format = $1.
         informat = $1.
         label = 'SFA_SPEC_PROG_FLG',
      PS_ACAD_PLAN_TBL_Extract.SSR_NSC_INCL_PLAN length = 1
         format = $1.
         informat = $1.
         label = 'SSR_NSC_INCL_PLAN',
      PS_ACAD_PLAN_TBL_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ACAD_PLAN_TBL_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID',
      PS_ACAD_PLAN_TBL_Extract.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      PS_ACAD_PLAN_TBL_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ACAD_PLAN_TBL_Extract.ACAD_PLAN_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_PLAN_TYPE',
      PS_ACAD_PLAN_TBL_Extract.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      PS_ACAD_PLAN_TBL_Extract.DEGREE length = 8
         format = $8.
         informat = $8.
         label = 'DEGREE',
      PS_ACAD_PLAN_TBL_Extract.CIP_CODE length = 13
         format = $13.
         informat = $13.
         label = 'CIP_CODE',
      PS_ACAD_PLAN_TBL_Extract.DESCRLONG length = 1024
         format = $1024.
         informat = $1024.
         label = 'DESCRLONG'
   from
      ADWSTGPR.PS_ACAD_PLAN_TBL_Extract as PS_ACAD_PLAN_TBL_Extract
   where
      PS_ACAD_PLAN_TBL_Extract.EFFDT <= &term_end_dt.
   group by
      PS_ACAD_PLAN_TBL_Extract.ACAD_PLAN
   having
      PS_ACAD_PLAN_TBL_Extract.EFFDT = max(PS_ACAD_PLAN_TBL_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            acad_plan max(sequence)               A5B29B8Q.BZ0005E4 *
 * Transform:       Join                                                    *
 * Description:     joined with acad_plan_tbl to filter out MINORS          *
 *                                                                          *
 * Source Tables:   Join - work.W23V7ZBA                  A5B29B8Q.BS0001L9 *
 *                  Join - work.W23V805O                  A5B29B8Q.BS0001LA *
 * Target Table:    Join - work.W23V80ZZ                  A5B29B8Q.BS0001LB *
 *==========================================================================*/

proc sql;
   create view work.W23V80ZZ as
   select
      W23V7ZBA.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W23V7ZBA.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W23V7ZBA.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      W23V7ZBA.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W23V7ZBA.EFFSEQ length = 8
         label = 'EFFSEQ',
      W23V7ZBA.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W23V7ZBA.DECLARE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'DECLARE_DT',
      W23V7ZBA.PLAN_SEQUENCE length = 8
         label = 'PLAN_SEQUENCE',
      W23V7ZBA.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W23V7ZBA.COMPLETION_TERM length = 4
         format = $4.
         informat = $4.
         label = 'COMPLETION_TERM',
      W23V7ZBA.STDNT_DEGR length = 2
         format = $2.
         informat = $2.
         label = 'STDNT_DEGR',
      W23V7ZBA.DEGR_CHKOUT_STAT length = 2
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      W23V7ZBA.ADVIS_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'ADVIS_STATUS',
      W23V7ZBA.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      W23V7ZBA.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      W23V7ZBA.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      W23V7ZBA.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      W23V7ZBA.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      W23V7ZBA.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      W23V7ZBA.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      W23V7ZBA.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      work.W23V7ZBA as W23V7ZBA,
      work.W23V805O as W23V805O
   where
      W23V7ZBA.ACAD_PLAN = W23V805O.ACAD_PLAN
      and W23V805O.ACAD_PLAN_TYPE <> 'MIN'
   group by
      W23V7ZBA.EMPLID,
      W23V7ZBA.ACAD_CAREER,
      W23V7ZBA.STDNT_CAR_NBR
   having
      W23V7ZBA.PLAN_SEQUENCE = min(W23V7ZBA.PLAN_SEQUENCE)
   ;
quit;

/*==========================================================================*
 * Step:            get req_term for effdt filter         A5B29B8Q.BZ0005E5 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  Join - work.W23V80ZZ                  A5B29B8Q.BS0001LB *
 *                  CBM1_CLASSIFICATION_INFO -            A5B29B8Q.BE00018H *
 *                   ADWTGTPR.CBM1_CLASSIFICATION_INFO                      *
 * Target Table:    CBM1_REQ_TERM -                       A5B29B8Q.BE00018I *
 *                   ADWTGTPR.CBM1_REQ_TERM                                 *
 *==========================================================================*/

proc sql;
   create table ADWTGTPR.CBM1_REQ_TERM as
   select
      classification_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      classification_info.TERM_SK length = 8
         label = 'TERM_SK',
      classification_info.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      classification_info.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      W23V80ZZ.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      classification_info.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      classification_info.ACAD_LVL_LOAD_BOT length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LVL_LOAD_BOT',
      classification_info.SRVC_IND_CD length = 3
         format = $3.
         informat = $3.
         label = 'SRVC_IND_CD',
      classification_info.SRVC_IND_ACT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'SRVC_IND_ACT_TERM',
      classification_info.SRVC_IND_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SRVC_IND_DTTM',
      classification_info.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      classification_info.CLASS length = 1
         label = 'CLASS',
      classification_info.CIP_CD length = 8
         format = $8.
         informat = $8.
         label = 'CIP_CD',
      classification_info.RESTRICTED length = 2
         label = 'RESTRICTED',
      classification_info.NDS length = 1
         label = 'NDS',
      classification_info.CIP_CD_Unedited length = 130
         format = $130.
         informat = $130.,
      classification_info.STUDENT_CAREER_NBR length = 8
         label = 'STUDENT_CAREER_NBR',
      classification_info.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      classification_info.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      "" as ACAD_SUB_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_SUB_PLAN',
      W23V80ZZ.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W23V80ZZ.EFFSEQ length = 8
         label = 'EFFSEQ',
      ADW_TERM_DIM.TERM_BEGIN_DT as Req_Term_Begin_Dt length = 8
         format = DATETIME20.
         informat = DATETIME20.,
      W23V80ZZ.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM'
   from
      ADWTGTPR.CBM1_CLASSIFICATION_INFO as classification_info left join
      work.W23V80ZZ as W23V80ZZ
         on
         (
            classification_info.EMPLID = W23V80ZZ.EMPLID
            and classification_info.STUDENT_CAREER_NBR = W23V80ZZ.STDNT_CAR_NBR
            and classification_info.ACAD_CAREER = W23V80ZZ.ACAD_CAREER
         ) left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            classification_info.ACAD_CAREER = ADW_TERM_DIM.ACAD_CAREER
            and W23V80ZZ.REQ_TERM = ADW_TERM_DIM.STRM
         )
   ;
quit;

/*==========================================================================*
 * Step:            apply reqterm filter                  A5B29B8Q.BZ0005E6 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_UTA_ACADPLAN_DTL_Extract -         A5B29B8Q.BE00000O *
 *                   ADWSTGPR.PS_UTA_ACADPLAN_DTL_Extract                   *
 *                  CBM1_REQ_TERM -                       A5B29B8Q.BE00018I *
 *                   ADWTGTPR.CBM1_REQ_TERM                                 *
 * Target Table:    Join - work.W23V7XMN                  A5B29B8Q.BS0001LC *
 *==========================================================================*/

proc sql;
   create view work.W23V7XMN as
   select
      W4THE81T.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W4THE81T.TERM_SK length = 8
         label = 'TERM_SK',
      W4THE81T.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      W4THE81T.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      W4THE81T.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W4THE81T.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W4THE81T.ACAD_LVL_LOAD_BOT length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LVL_LOAD_BOT',
      W4THE81T.SRVC_IND_CD length = 3
         format = $3.
         informat = $3.
         label = 'SRVC_IND_CD',
      W4THE81T.SRVC_IND_ACT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'SRVC_IND_ACT_TERM',
      W4THE81T.SRVC_IND_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SRVC_IND_DTTM',
      W4THE81T.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      W4THE81T.CLASS length = 1
         label = 'CLASS',
      W4THE81T.CIP_CD length = 8
         format = $8.
         informat = $8.
         label = 'CIP_CD',
      W4THE81T.RESTRICTED length = 2
         label = 'RESTRICTED',
      W4THE81T.NDS length = 1
         label = 'NDS',
      W4THE81T.CIP_CD_Unedited length = 130
         format = $130.
         informat = $130.,
      W4THE81T.STUDENT_CAREER_NBR length = 8
         label = 'STUDENT_CAREER_NBR',
      W4THE81T.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      W4THE81T.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W4THE81T.ACAD_SUB_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_SUB_PLAN',
      W4THE81T.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W4THE81T.EFFSEQ length = 8
         label = 'EFFSEQ',
      W4THE81T.Req_Term_Begin_Dt length = 8
         format = DATETIME20.
         informat = DATETIME20.,
      W4THE81T.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      PS_UTA_ACADPLAN_DTL_Extract.MIN_UNITS_REQD length = 8
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      PS_UTA_ACADPLAN_DTL_Extract.EFFDT as acad_plan_effdt length = 8
         format = DATETIME20.
         informat = DATETIME20.
   from
      ADWTGTPR.CBM1_REQ_TERM as W4THE81T left join
      ADWSTGPR.PS_UTA_ACADPLAN_DTL_Extract as PS_UTA_ACADPLAN_DTL_Extract
         on
         (
            W4THE81T.ACAD_PLAN = PS_UTA_ACADPLAN_DTL_Extract.ACAD_PLAN
            and W4THE81T.ACAD_CAREER = PS_UTA_ACADPLAN_DTL_Extract.ACAD_CAREER
            and PS_UTA_ACADPLAN_DTL_Extract.EFFDT <= W4THE81T.Req_Term_Begin_Dt
         )
   group by
      W4THE81T.EMPLID,
      W4THE81T.TERM_SK,
      W4THE81T.ACAD_PLAN,
      W4THE81T.ACAD_CAREER,
      W4THE81T.STUDENT_CAREER_NBR
   having
      PS_UTA_ACADPLAN_DTL_Extract.EFFDT = max(PS_UTA_ACADPLAN_DTL_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005E7 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W23V7XMN                  A5B29B8Q.BS0001LC *
 * Target Table:    Join - work.W23V7WSA                  A5B29B8Q.BS0001LD *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W23V7XMN);


proc sql;
   create view work.W23V7WSA as
   select
      W23V7XMN.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W23V7XMN.TERM_SK length = 8
         label = 'TERM_SK',
      W23V7XMN.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      W23V7XMN.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      W23V7XMN.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W23V7XMN.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W23V7XMN.ACAD_LVL_LOAD_BOT length = 3
         format = $3.
         informat = $3.
         label = 'ACAD_LVL_LOAD_BOT',
      W23V7XMN.SRVC_IND_CD length = 3
         format = $3.
         informat = $3.
         label = 'SRVC_IND_CD',
      W23V7XMN.SRVC_IND_ACT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'SRVC_IND_ACT_TERM',
      W23V7XMN.SRVC_IND_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SRVC_IND_DTTM',
      W23V7XMN.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      W23V7XMN.CLASS length = 1
         label = 'CLASS',
      W23V7XMN.CIP_CD length = 8
         format = $8.
         informat = $8.
         label = 'CIP_CD',
      W23V7XMN.RESTRICTED length = 2
         label = 'RESTRICTED',
      W23V7XMN.NDS length = 1
         label = 'NDS',
      W23V7XMN.CIP_CD_Unedited length = 130
         format = $130.
         informat = $130.,
      W23V7XMN.STUDENT_CAREER_NBR length = 8
         label = 'STUDENT_CAREER_NBR',
      W23V7XMN.TERM_BEGIN_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_BEGIN_DT',
      W23V7XMN.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W23V7XMN.ACAD_SUB_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_SUB_PLAN',
      W23V7XMN.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W23V7XMN.EFFSEQ length = 8
         label = 'EFFSEQ',
      W23V7XMN.Req_Term_Begin_Dt length = 8
         format = DATETIME20.
         informat = DATETIME20.,
      W23V7XMN.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      max(W23V7XMN.MIN_UNITS_REQD) as MIN_UNITS_REQD length = 8
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      W23V7XMN.acad_plan_effdt length = 8
         format = DATETIME20.
         informat = DATETIME20.
   from
      work.W23V7XMN as W23V7XMN
   group by
      W23V7XMN.EMPLID,
      W23V7XMN.TERM_SK,
      W23V7XMN.ACAD_PLAN
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005E8 *
 * Transform:       Join                                                    *
 * Description:     UGDEGR                                                  *
 *                                                                          *
 * Source Table:    Join - work.W23V7WSA                  A5B29B8Q.BS0001LD *
 * Target Table:    CBM1_UGDEGR - ADWTGTPR.CBM1_UGDEGR    A5B29B8Q.BE00018L *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W23V7WSA);


proc sql;
   create table ADWTGTPR.CBM1_UGDEGR as
   select distinct
      W23V7WSA.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W23V7WSA.TERM_SK length = 8
         label = 'TERM_SK',
      W23V7WSA.CLASS length = 1
         label = 'CLASS',
      case
         when (( W23V7WSA.CLASS = '3'  |   W23V7WSA.CLASS = '4'  )  &  (W23V7WSA.ACAD_PROGRAM  ^=  'UGNDS' ))   then coalesce(W23V7WSA.MIN_UNITS_REQD,120)
         when ( W23V7WSA.CLASS = '3'  |   W23V7WSA.CLASS = '4'  )   then 120
      else 000
      end

      /*Zach's code below

      case
         when W23V7WSA.CLASS = '3'  |
       W23V7WSA.CLASS = '4'
            then 120
         when W23V7WSA.ACAD_PROGRAM  ^=  'UGNDS'
            then WWK1385P.subplan_input.W23V7WSA.MIN_UNITS_REQD
      else 000
      end

      */ as UGDEGR length = 8
         label = 'UGDEGR',
      W23V7WSA.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      case
         when (( W23V7WSA.CLASS = '3'  |   W23V7WSA.CLASS = '4'  )  &  (W23V7WSA.ACAD_PROGRAM  ^=  'UGNDS' ))   then coalesce(W23V7WSA.MIN_UNITS_REQD,120)
         when ( W23V7WSA.CLASS = '3'  |   W23V7WSA.CLASS = '4'  )   then 120
      else 000
      end

      /*Zach's code below

      case
         when W23V7WSA.CLASS = '3'  |
       W23V7WSA.CLASS = '4'
            then 120
         when W23V7WSA.ACAD_PROGRAM  ^=  'UGNDS'
            then WWK1385P.subplan_input.W23V7WSA.MIN_UNITS_REQD
      else 000
      end

      */ as MIN_UNITS_REQD length = 8
         format = 8.2
         informat = 8.2
         label = 'MIN_UNITS_REQD',
      W23V7WSA.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W23V7WSA.ACAD_SUB_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_SUB_PLAN'
   from
      work.W23V7WSA as W23V7WSA
   group by
      W23V7WSA.INSTITUTION,
      W23V7WSA.ACAD_CAREER,
      W23V7WSA.TERM_SK,
      W23V7WSA.EMPLID
   having
      W23V7WSA.EFFSEQ = max(W23V7WSA.EFFSEQ)
   ;
quit;

/**  Job end UGDEGR **/

/* Reset jobid and name */

/*==========================================================================*
 * Step:            Foreign Sevis                         A5B29B8Q.BZ000BNM *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ADDRESSES_Extract -                A5B29B8Q.BE00001W *
 *                   ADWSTGPR.PS_ADDRESSES_Extract                          *
 * Target Table:    PS_ADDRESSES_SEVF -                   A5B29B8Q.BS00041E *
 *                   work.PS_ADDRESSES_SEVF                                 *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_ADDRESSES_Extract);


proc sql;
   create table work.PS_ADDRESSES_SEVF as
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
         label = 'STATE'
   from
      ADWSTGPR.PS_ADDRESSES_Extract as PS_ADDRESSES_Extract
   where
      PS_ADDRESSES_Extract.ADDRESS_TYPE = 'SEVF'
      and PS_ADDRESSES_Extract.EFF_STATUS = 'A'
   group by
      PS_ADDRESSES_Extract.EMPLID,
      PS_ADDRESSES_Extract.CITY
   having
      PS_ADDRESSES_Extract.EFFDT = max(PS_ADDRESSES_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNN *
 * Transform:       Join                                                    *
 * Description:     Residence                                               *
 *                                                                          *
 * Source Tables:   PS_ADDRESSES_Extract -                A5B29B8Q.BE00001W *
 *                   ADWSTGPR.PS_ADDRESSES_Extract                          *
 *                  PS_UTA_CC_CB_STATE_Extract -          A5B29B8Q.BE000075 *
 *                   ADWSTGPR.PS_UTA_CC_CB_STATE                            *
 *                  PS_UTA_CC_CB_CNTRY_Extract -          A5B29B8Q.BE000074 *
 *                   ADWSTGPR.PS_UTA_CC_CB_CNTRY                            *
 *                  PS_UTA_TX_CNTY_TBL_Extract -          A5B29B8Q.BE00008G *
 *                   ADWSTGPR.PS_UTA_TX_CNTY_TBL_Extract                    *
 *                  PS_ADDRESSES_SEVF -                   A5B29B8Q.BS00041E *
 *                   work.PS_ADDRESSES_SEVF                                 *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  PS_RESIDENCY_SELF_Extract -           A5B29B8Q.BE00005A *
 *                   ADWSTGPR.PS_RESIDENCY_SELF_Extract                     *
 *                  PS_RESIDENCY_OFF_Extract -            A5B29B8Q.BE000059 *
 *                   ADWSTGPR.PS_RESIDENCY_OFF_Extract                      *
 * Target Table:    Join - work.WJSE6S1R                  A5B29B8Q.BS00041F *
 *==========================================================================*/

proc sql;
   create table work.WJSE6S1R as
   select distinct
      Student_term_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      case when Student_term_info.FLEX ='1' then Student_term_info.TERM_SK +2 else Student_term_info.TERM_SK end as TERM_SK length = 8
         label = 'TERM_SK',
      Student_term_info.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      ifc(coalescec( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY  ,  '')='USA' and trim(PS_ADDRESSES_SEVF.COUNTRY) not in ('USA' ,''), '',
      coalesce( PS_RESIDENCY_SELF_Extract.STATE , PS_RESIDENCY_OFF_Extract.STATE , PS_ADDRESSES_Extract.STATE  ,  '')) as STATE length = 2
         format = $2.
         informat = $2.
         label = 'STATE',
      ifc(coalesce( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY  ,  '')='USA' and trim(PS_ADDRESSES_SEVF.COUNTRY) not in ('USA' ,''),
      PS_ADDRESSES_SEVF.COUNTRY, coalesce( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY  ,  '')) as COUNTRY length = 8
         label = 'COUNTRY',
      PS_RESIDENCY_OFF_Extract.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'RESIDENCY',
      PS_ADDRESSES_Extract.STATE as ADDR_STATE length = 8
         label = 'ADDR_STATE',
      case
      	when upper(PS_RESIDENCY_SELF_Extract.COUNTRY) ^='USA' or (PS_RESIDENCY_SELF_Extract.COUNTRY='USA' and PS_ADDRESSES_SEVF.COUNTRY is not missing)
      	then PS_UTA_CC_CB_CNTRY.UTA_CC_THECB_CD
          when upper(PS_RESIDENCY_SELF_Extract.COUNTRY) ='USA'  & upper(strip(PS_RESIDENCY_SELF_Extract.STATE)) ='TX'
          then substr(left(PS_RESIDENCY_SELF_Extract.COUNTY) , 1,3)
          when upper(PS_RESIDENCY_SELF_Extract.COUNTRY) ='USA'  & upper(strip(PS_RESIDENCY_SELF_Extract.COUNTY)) ^='TX'
            then PS_UTA_CC_CB_STATE.UTA_CC_THECB_CD
      else ''
      end as UTA_RESIDENCE_CD length = 3
         format = $3.
         informat = $3.,
      case

      	when coalescec( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY  ,  '') ^='USA'
      	or  (coalescec( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY  ,  '') ='USA'
      	and trim(PS_ADDRESSES_SEVF.COUNTRY) not in ('USA' ,'')) then PS_UTA_CC_CB_CNTRY.UTA_CC_THECB_CD

      	when coalescec( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY ,  '') ='USA' &
      		coalescec(PS_RESIDENCY_SELF_Extract.STATE ,PS_RESIDENCY_OFF_Extract.STATE,PS_ADDRESSES_Extract.STATE  , '') ^='TX' then  PS_UTA_CC_CB_STATE.UTA_CC_THECB_CD

      	when coalesce( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY ,PS_ADDRESSES_Extract.COUNTRY ,  '') ='USA'
      	& coalescec(PS_RESIDENCY_SELF_Extract.STATE ,PS_RESIDENCY_OFF_Extract.STATE , '') ='TX'
      	&  (coalescec( substr(PS_RESIDENCY_SELF_Extract.COUNTY , 1,3) , substr(PS_RESIDENCY_OFF_Extract.COUNTY , 1,3),'') ^='')
      	then  coalescec( substr(PS_RESIDENCY_SELF_Extract.COUNTY , 1,3) , substr(PS_RESIDENCY_OFF_Extract.COUNTY , 1,3))

      	when coalesce( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY ,PS_ADDRESSES_Extract.COUNTRY ,  '') ='USA'
      	& coalescec(PS_RESIDENCY_SELF_Extract.STATE ,PS_RESIDENCY_OFF_Extract.STATE,PS_ADDRESSES_Extract.STATE , '') ='TX'
      	then PS_UTA_TX_CNTY_TBL_Extract.COUNTY_CD

      	else ''
      end as COUNTY_CD length = 3,
      PS_ADDRESSES_Extract.COUNTY as COUNTY_PSADDRESS length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      PS_ADDRESSES_Extract.EFFDT as EFFDT_PSADDRESS length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_RESIDENCY_OFF_Extract.COUNTY as COUNTY_OFF length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      substr(PS_ADDRESSES_Extract.COUNTY,4) as COUNTY_SUBSTRPSADDRESS length = 8,
      PS_UTA_TX_CNTY_TBL_Extract.COUNTY_CD as extract_cd length = 8,
      Student_term_info.FLEX length = 1
         label = 'FLEX',
      PS_RESIDENCY_OFF_Extract.ADMISSION_EXCPT length = 5
         format = $5.
         informat = $5.
         label = 'ADMISSION_EXCPT',
      Student_term_info.TERM_SK as Term_sk_unmodified length = 8,
      PS_RESIDENCY_SELF_Extract.SELF_REPORT_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SELF_REPORT_DT',
      PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EFFECTIVE_TERM',
      PS_ADDRESSES_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as Student_term_info left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            case when Student_term_info.FLEX >'0' then Student_term_info.TERM_SK+2
            else Student_term_info.TERM_SK
            end = ADW_TERM_DIM.TERM_SK
            and Student_term_info.INSTITUTION = ADW_TERM_DIM.INSTITUTION
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            Student_term_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWSTGPR.PS_RESIDENCY_SELF_Extract as PS_RESIDENCY_SELF_Extract
         on
         (
            Student_term_info.EMPLID = PS_RESIDENCY_SELF_Extract.EMPLID
            and datepart(PS_RESIDENCY_SELF_Extract.SELF_REPORT_DT) <= datepart(ADW_TERM_DIM.TERM_END_DT)
         ) left join
      ADWSTGPR.PS_RESIDENCY_OFF_Extract as PS_RESIDENCY_OFF_Extract
         on
         (
            Student_term_info.EMPLID = PS_RESIDENCY_OFF_Extract.EMPLID
            and ADW_ACAD_CAREER_DIM.ACAD_CAREER = PS_RESIDENCY_OFF_Extract.ACAD_CAREER
            and PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM <= ADW_TERM_DIM.STRM
         ) left join
      ADWSTGPR.PS_ADDRESSES_Extract as PS_ADDRESSES_Extract
         on
         (
            Student_term_info.EMPLID = PS_ADDRESSES_Extract.EMPLID
            and PS_ADDRESSES_Extract.ADDRESS_TYPE = 'HOME'
            and datepart(PS_ADDRESSES_Extract.EFFDT) <= datepart(ADW_TERM_DIM.TERM_END_DT)
            and PS_ADDRESSES_Extract.EFF_STATUS = 'A'
         ) left join
      work.PS_ADDRESSES_SEVF as PS_ADDRESSES_SEVF
         on
         (
            Student_term_info.EMPLID = PS_ADDRESSES_SEVF.EMPLID
            and datepart(PS_ADDRESSES_SEVF.EFFDT) <= datepart(ADW_TERM_DIM.TERM_END_DT)
            and PS_RESIDENCY_OFF_Extract.CITY = PS_ADDRESSES_SEVF.CITY
         ) left join
      ADWSTGPR.PS_UTA_CC_CB_STATE as PS_UTA_CC_CB_STATE
         on
         (
            ifc(coalescec( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY  ,  '')='USA' and trim(PS_ADDRESSES_SEVF.COUNTRY) not in ('USA' ,''), '',
            coalesce( PS_RESIDENCY_SELF_Extract.STATE , PS_RESIDENCY_OFF_Extract.STATE , PS_ADDRESSES_Extract.STATE  ,  '')) = PS_UTA_CC_CB_STATE.STATE
            and PS_UTA_CC_CB_STATE.EFF_STATUS = 'A'
         ) left join
      ADWSTGPR.PS_UTA_CC_CB_CNTRY as PS_UTA_CC_CB_CNTRY
         on
         (
            ifc(coalesce( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY  ,  '')='USA' and trim(PS_ADDRESSES_SEVF.COUNTRY) not in ('USA' ,''),
            PS_ADDRESSES_SEVF.COUNTRY, coalesce( PS_RESIDENCY_SELF_Extract.COUNTRY , PS_RESIDENCY_OFF_Extract.COUNTRY , PS_ADDRESSES_Extract.COUNTRY  ,  '')) = PS_UTA_CC_CB_CNTRY.COUNTRY
            and PS_UTA_CC_CB_CNTRY.EFF_STATUS = 'A'
         ) left join
      ADWSTGPR.PS_UTA_TX_CNTY_TBL_Extract as PS_UTA_TX_CNTY_TBL_Extract
         on
         (
            case when anydigit(substr(PS_ADDRESSES_Extract.COUNTY,1,3))=0 then  upper(PS_ADDRESSES_Extract.COUNTY)
            else upper(substr(PS_ADDRESSES_Extract.COUNTY,4))
            end = PS_UTA_TX_CNTY_TBL_Extract.COUNTY_NAME
         )
   group by
      Student_term_info.ACAD_CAREER_SK,
      Student_term_info.TERM_SK,
      Student_term_info.FLEX,
      Student_term_info.EMPLID
   having
      PS_RESIDENCY_SELF_Extract.SELF_REPORT_DT = max(PS_RESIDENCY_SELF_Extract.SELF_REPORT_DT )
      and PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM = max(PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM )
      and PS_ADDRESSES_Extract.EFFDT = max(PS_ADDRESSES_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            legacy                                A5B29B8Q.BZ000BNO *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WJSE6S1R                  A5B29B8Q.BS00041F *
 * Target Table:    Join - work.W12707R8L                 A5B29B8Q.BS00041G *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.WJSE6S1R);


proc sql;
   create table work.W12707R8L as
   select
      WJSE6S1R.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WJSE6S1R.TERM_SK length = 8
         label = 'TERM_SK',
      WJSE6S1R.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      WJSE6S1R.STATE length = 2
         format = $2.
         informat = $2.
         label = 'STATE',
      WJSE6S1R.COUNTRY length = 8
         label = 'COUNTRY',
      WJSE6S1R.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'RESIDENCY',
      "" as HOME_ADDR_STATE length = 6
         format = $6.
         informat = $6.
         label = 'HOME_ADDR_STATE',
      "" as PHYS_PRESENCE_STATE length = 6
         format = $6.
         informat = $6.
         label = 'PHYS_PRESENCE_STATE',
      WJSE6S1R.ADDR_STATE length = 8
         label = 'ADDR_STATE',
      WJSE6S1R.UTA_RESIDENCE_CD length = 3
         format = $3.
         informat = $3.,
      WJSE6S1R.COUNTY_CD length = 3,
      WJSE6S1R.COUNTY_PSADDRESS length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WJSE6S1R.EFFDT_PSADDRESS length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      WJSE6S1R.COUNTY_OFF length = 30
         format = $30.
         informat = $30.
         label = 'COUNTY',
      WJSE6S1R.COUNTY_SUBSTRPSADDRESS length = 8,
      WJSE6S1R.extract_cd length = 8
   from
      work.WJSE6S1R as WJSE6S1R
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNP *
 * Transform:       Join                                                    *
 * Description:     DOCFUNDDOCFUNDCD                                        *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 *                  ADW_COURSE_OFFER_DIM -                A5B29B8Q.BE0000RO *
 *                   ADWTGTPR.ADW_COURSE_OFFER_DIM                          *
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 *                  ADW_ACAD_PLAN_DIM -                   A5B29B8Q.BE0000RF *
 *                   ADWTGTPR.ADW_ACAD_PLAN_DIM                             *
 *                  ADW_CIP_DIM - ADWTGTPR.ADW_CIP_DIM    A5B29B8Q.BE0000RL *
 *                  PS_CRSE_ATTRIBUTES_Extract -          A5B29B8Q.BE000007 *
 *                   ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract                    *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  CBM1_CLASSIFICATION_INFO -            A5B29B8Q.BE00018H *
 *                   ADWTGTPR.CBM1_CLASSIFICATION_INFO                      *
 * Target Table:    Join - work.WKLO654V                  A5B29B8Q.BS00041H *
 *==========================================================================*/

proc sql;
   create table work.WKLO654V as
   select distinct
      class_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      class_info.TERM_SK length = 8
         label = 'TERM_SK',
      class_info.FLEX length = 1
         label = 'FLEX',
      substr(ADW_CIP_DIM.CIP_ALTERNATIVE_CD  , 12, 2) as DOCFNDCD length = 2
         label = 'DOCFNDCD',
      sum(class_info.UNIT_TAKEN ) as UNIT_DOC length = 4
         label = 'UNIT_DOC',
      ADW_CLASS_SCHEDULE_FACT.CLASS_NBR length = 8
         label = 'CLASS_NBR'
   from
      ADWTGTPR.CBM1_CLASS_INFO as class_info left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            class_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_CLASS_SCHEDULE_FACT as ADW_CLASS_SCHEDULE_FACT
         on
         (
            class_info.CLASS_NBR = ADW_CLASS_SCHEDULE_FACT.CLASS_NBR
            and class_info.TERM_SK = ADW_CLASS_SCHEDULE_FACT.TERM_SK
         ) left join
      ADWTGTPR.ADW_COURSE_OFFER_DIM as ADW_COURSE_OFFER_DIM
         on
         (
            ADW_CLASS_SCHEDULE_FACT.COURSE_OFFER_SK = ADW_COURSE_OFFER_DIM.COURSE_OFFER_SK
         ) left join
      ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract as PS_CRSE_ATTR_main
         on
         (
            ADW_COURSE_OFFER_DIM.COURSE_IDENTIFIER = PS_CRSE_ATTR_main.CRSE_ID
            and PS_CRSE_ATTR_main.CRSE_ATTR = 'CLVL'
            and PS_CRSE_ATTR_main.CRSE_ATTR_VALUE = '6'
            and PS_CRSE_ATTR_main.EFFDT = (
               select distinct
                  max(crse_attr_effdt_max.EFFDT) as EFFDT length = 8
                     format = DATETIME20.
                     informat = DATETIME20.
                     label = 'EFFDT'
               from
                  ADWSTGPR.PS_CRSE_ATTRIBUTES_Extract as crse_attr_effdt_max
               where
                  crse_attr_effdt_max.CRSE_ID = PS_CRSE_ATTR_main.CRSE_ID
                  and crse_attr_effdt_max.CRSE_ATTR = 'CLVL'
                  and crse_attr_effdt_max.CRSE_ATTR_VALUE = '6'
                  and crse_attr_effdt_max.EFFDT <= ADW_TERM_DIM.TERM_END_DT
               group by
                  crse_attr_effdt_max.CRSE_ID
            )
         ) left join
      ADWTGTPR.CBM1_CLASSIFICATION_INFO as classification_info
         on
         (
            class_info.EMPLID = classification_info.EMPLID
            and class_info.TERM_SK = classification_info.TERM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_PLAN_DIM as ADW_ACAD_PLAN_DIM
         on
         (
            class_info.MAJOR_ACAD_PLAN_SK = ADW_ACAD_PLAN_DIM.ACAD_PLAN_SK
         ) left join
      ADWTGTPR.ADW_CIP_DIM as ADW_CIP_DIM
         on
         (
            ADW_CIP_DIM.CIP_CD = ADW_COURSE_OFFER_DIM.CIP_CD
            and ADW_CIP_DIM.CURRENT_ROW_IND = 'Y'
         )
   where
      classification_info.CLASS = '7'
      and ((substr(ADW_CLASS_SCHEDULE_FACT.CATALOG_NBR, 1,1) IN ('6','7'))
      or (substr(ADW_CLASS_SCHEDULE_FACT.CATALOG_NBR, 1,1) = '5'
      and PS_CRSE_ATTR_main.CRSE_ATTR = 'CLVL'
      and PS_CRSE_ATTR_main.CRSE_ATTR_VALUE = '6'))
      and ADW_CIP_DIM.CURRENT_ROW_IND = 'Y'
      and class_info.TERM_SK > 378
   group by
      class_info.EMPLID,
      class_info.TERM_SK,
      class_info.FLEX,
      DOCFNDCD
   having
      ADW_CLASS_SCHEDULE_FACT.CLASS_NBR = min(ADW_CLASS_SCHEDULE_FACT.CLASS_NBR)
   ;
quit;

/*==========================================================================*
 * Step:            min(class_nbr)                        A5B29B8Q.BZ000BNQ *
 * Transform:       Join                                                    *
 * Description:     to match uta logic                                      *
 *                                                                          *
 * Source Table:    Join - work.WKLO654V                  A5B29B8Q.BS00041H *
 * Target Table:    Join - work.W4E0W3NI                  A5B29B8Q.BS00041I *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.WKLO654V);


proc sql;
   create view work.W4E0W3NI as
   select
      WKLO654V.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WKLO654V.TERM_SK length = 8
         label = 'TERM_SK',
      WKLO654V.FLEX length = 1
         label = 'FLEX',
      WKLO654V.DOCFNDCD length = 2
         label = 'DOCFNDCD',
      WKLO654V.UNIT_DOC length = 4
         label = 'UNIT_DOC',
      WKLO654V.CLASS_NBR length = 8
         label = 'CLASS_NBR'
   from
      work.WKLO654V as WKLO654V
   where
      WKLO654V.DOCFNDCD NOT IN ('18','13','12','08','19')
      /* added on 4/30 because of error code triggering */
   group by
      WKLO654V.EMPLID,
      WKLO654V.TERM_SK,
      WKLO654V.FLEX
   having
      WKLO654V.CLASS_NBR = min(WKLO654V.CLASS_NBR)
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNR *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J *
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          *
 * Target Table:    Join - work.W10LQ2A6X                 A5B29B8Q.BS00041J *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_ACAD_PROG_Extract);


proc sql;
   create view work.W10LQ2A6X as
   select
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
      PS_ACAD_PROG_Extract.ACAD_CAREER = 'UGRD'
      and PS_ACAD_PROG_Extract.PROG_ACTION = 'PLNC'
      and PS_ACAD_PROG_Extract.PROG_REASON = 'UCOO'
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNS *
 * Transform:       Join                                                    *
 * Description:     Cap                                                     *
 *                                                                          *
 * Source Tables:   ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J *
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          *
 *                  Join - work.W10LQ2A6X                 A5B29B8Q.BS00041J *
 * Target Table:    Join - work.WQMGJ1R8                  A5B29B8Q.BS00041K *
 *==========================================================================*/

proc sql;
   create table work.WQMGJ1R8 as
   select
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK length = 8
         label = 'TERM_SK',
      PS_ACAD_PROG_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_ACAD_PROG_Extract.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      PS_ACAD_PROG_Extract.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      PS_ACAD_PROG_Extract.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      case
         when PS_ACAD_PROG_Extract.PROG_REASON ='UCAP'  &
                   substr(ADW_TERM_DIM.STRM,4,1) ^= '5' &
                   ADW_TERM_DIM.ACAD_CAREER ='UGRD' &
                   PS_ACAD_PROG_Extract_2.PROG_REASON ^= 'UCOO' then 6

      else .
      end

      /*
      case
         when substr(ADW_TERM_DIM.ACAD_CAREER,4,1) = '8'
            then 6
      else .
      end
      */ as CAP length = 8
         label = 'CAP',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      case
      when substr(ADW_TERM_DIM.STRM,4,1)='5' then ADW_TERM_DIM.STRM
      when substr(ADW_TERM_DIM.STRM,4,1)='8' then compress(catx('','2' ,put( input(substr(ADW_TERM_DIM.STRM,2,2),4.)-1,2.),'5'))
      when substr(ADW_TERM_DIM.STRM,4,1)='2' then compress(catx('','2' ,put( input(substr(ADW_TERM_DIM.STRM,2,2),4.)-1,2.),'5'))
      else ''
      end as mod_strm length = 8
   from
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWSTGPR.PS_ACAD_PROG_Extract as PS_ACAD_PROG_Extract
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.EMPLID = PS_ACAD_PROG_Extract.EMPLID
            and PS_ACAD_PROG_Extract.ADMIT_TERM = case
            when substr(ADW_TERM_DIM.STRM,4,1)='8' then ADW_TERM_DIM.STRM
            when substr(ADW_TERM_DIM.STRM,4,1)='2' then cats('2' ,put( input(substr(ADW_TERM_DIM.STRM,2,2),4.)-1,2.),'8')
            else ''
            end
            and PS_ACAD_PROG_Extract.ACAD_CAREER = 'UGRD'
            and PS_ACAD_PROG_Extract.PROG_ACTION = 'ADMT'
            and PS_ACAD_PROG_Extract.PROG_REASON = 'UCAP'
         ) left join
      work.W10LQ2A6X as PS_ACAD_PROG_Extract_2
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.EMPLID = PS_ACAD_PROG_Extract_2.EMPLID
            and PS_ACAD_PROG_Extract_2.ADMIT_TERM = case
            when substr(ADW_TERM_DIM.STRM,4,1) = '5' then ADW_TERM_DIM.STRM
            when substr(ADW_TERM_DIM.STRM,4,1) = '8' then  cats('2' ,put( input(substr(ADW_TERM_DIM.STRM,2,2),4.),2.),'5')
            when substr(ADW_TERM_DIM.STRM,4,1) = '2' then  cats('2' ,put( input(substr(ADW_TERM_DIM.STRM,2,2),4.)-1,2.),'5')
            else ''
            end
            and PS_ACAD_PROG_Extract_2.ACAD_CAREER = 'UGRD'
            and PS_ACAD_PROG_Extract_2.PROG_ACTION = 'PLNC'
            and PS_ACAD_PROG_Extract_2.PROG_REASON = 'UCOO'
         )
   ;
quit;

/****************************************************************************
 * Job:             SCH                                   A5B29B8Q.BT0000QU *
 * Description:                                                             *
 *                                                                          *
 * Metadata Server: sasmetapaws8.ua.uta.edu                                 *
 * Port:            8561                                                    *
 * Location:        /UTA/ADW/400 Reports/CBM/Jobs/CBM1 CBME1 Sub Jobs       *
 *                                                                          *
 * Server:          SASApp                                A5B29B8Q.AS000002 *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 *                  ADW_COURSE_OFFER_DIM -                A5B29B8Q.BE0000RO *
 *                   ADWTGTPR.ADW_COURSE_OFFER_DIM                          *
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J *
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          *
 *                  CBM1_REQ_TERM -                       A5B29B8Q.BE00018I *
 *                   ADWTGTPR.CBM1_REQ_TERM                                 *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K *
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  CBM1_CLASSIFICATION_INFO -            A5B29B8Q.BE00018H *
 *                   ADWTGTPR.CBM1_CLASSIFICATION_INFO                      *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  CBM1_UGDEGR - ADWTGTPR.CBM1_UGDEGR    A5B29B8Q.BE00018L *
 *                  ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  ADW_CBM_3PEATDEV -                    A5B29B8Q.BE00000M *
 *                   CBMPRD.ADW_CBM_3PEATDEV                                *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 *                  ADW_COURSE_OFFER_DIM -                A5B29B8Q.BE0000RO *
 *                   ADWTGTPR.ADW_COURSE_OFFER_DIM                          *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  ADW_CBM_EXCESS_HOURS -                A5B29B8Q.BE00000N *
 *                   CBMPRD.ADW_CBM_EXCESS_HOURS                            *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U *
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      *
 *                  PS_ADM_APPL_RCR_CA_Extract -          A5B29B8Q.BE00000V *
 *                   ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract                    *
 *                  ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    CBM1_SCH - ADWTGTPR.CBM1_SCH          A5B29B8Q.BE00018J *
 *                                                                          *
 * Generated on:    Thursday, May 7, 2026 1:54:27 PM CDT                    *
 * Generated by:    mynenit                                                 *
 * Version:         SAS Data Integration Studio 4.905                       *
 ****************************************************************************/

%global etls_debug;
%macro etls_setDebug;
   %if %str(&etls_debug) ne 0 %then
      OPTIONS MPRINT%str(;);
%mend;
%etls_setDebug;

/*==========================================================================*
 * Step:            Macros                                A5B29B8Q.BZ0005CY *
 * Transform:       User Written                                            *
 * Description:     Uncomment or populate here for manual testing           *
 *                                                                          *
 * Target Table:    User Written - work.W1SNOE43          A5B29B8Q.BS0002B3 *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*/


%let _OUTPUT = work.W1SNOE43;

%let _OUTPUT1_col_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/

/*
%let term_end_dt ='13AUG2019:00:00:00'dt;
%let term=2195;
%let prev_term=2192;
%let two_year_prev_term=2175;
%let term_sk_filter=373;
*/
/*
%let term_end_dt ='11DEC2019:00:00:00'dt;

%let term=2198;
%let prev_term=2195;
%let two_year_prev_term=2178;
%let term_sk_filter=375;*/
/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            unfn                                  A5B29B8Q.BZ0005CZ *
 * Transform:       Join                                                    *
 * Description:     UNFN                                                    *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 * Target Table:    Join - work.W1SDP5OH                  A5B29B8Q.BS0001KA *
 *==========================================================================*/

proc sql;
   create table work.W1SDP5OH as
   select distinct
      class_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      class_info.TERM_SK length = 8
         label = 'TERM_SK',
      class_info.FLEX length = 1
         label = 'FLEX',
      sum(class_info.UNIT_TAKEN ) as UNFN length = 8
         label = 'UNFN'
   from
      ADWTGTPR.CBM1_CLASS_INFO as class_info left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            class_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            class_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWSTGPR.PS_CLASS_TBL_Extract as PS_CLASS_TBL_Extract
         on
         (
            class_info.CLASS_NBR = PS_CLASS_TBL_Extract.CLASS_NBR
            and ADW_TERM_DIM.STRM = PS_CLASS_TBL_Extract.STRM
            and PS_CLASS_TBL_Extract.CLASS_STAT = 'A'
         ) left join
      ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract as PS_CLASS_ATTRIBUTE_Extract
         on
         (
            class_info.CRSE_ID = PS_CLASS_ATTRIBUTE_Extract.CRSE_ID
            and ADW_TERM_DIM.STRM = PS_CLASS_ATTRIBUTE_Extract.STRM
            and PS_CLASS_TBL_Extract.CLASS_SECTION = PS_CLASS_ATTRIBUTE_Extract.CLASS_SECTION
            and PS_CLASS_ATTRIBUTE_Extract.SESSION_CODE = class_info.SESSION_CD
         )
   where
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR = 'UNFN'
      and class_info.STUDENT_ENRL_CD = 'E'
   group by
      class_info.EMPLID,
      class_info.TERM_SK,
      class_info.FLEX
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005D0 *
 * Transform:       Join                                                    *
 * Description:     PHYED                                                   *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 *                  ADW_COURSE_OFFER_DIM -                A5B29B8Q.BE0000RO *
 *                   ADWTGTPR.ADW_COURSE_OFFER_DIM                          *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 * Target Table:    Join - work.W1SDPGMS                  A5B29B8Q.BS0001KB *
 *==========================================================================*/

proc sql;
   create table work.W1SDPGMS as
   select distinct
      class_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      class_info.TERM_SK length = 8
         label = 'TERM_SK',
      class_info.FLEX length = 1
         label = 'FLEX',
      case
         when (ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM = 'UGNDS'  |  ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM = 'SPEC')  &
       (ADW_COURSE_OFFER_DIM.SUBJECT = 'EXSA'  |  ADW_COURSE_OFFER_DIM.SUBJECT = 'DNCE')
      & PS_STDNT_ENRL_Extract.REPEAT_CANDIDATE = 'Y'
            then sum(class_info.UNIT_TAKEN )
      else .
      end as PHYED length = 8
         label = 'PHYED'
   from
      ADWTGTPR.CBM1_CLASS_INFO as class_info left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            class_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            class_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWTGTPR.ADW_CLASS_SCHEDULE_FACT as ADW_CLASS_SCHEDULE_FACT
         on
         (
            class_info.CLASS_NBR = ADW_CLASS_SCHEDULE_FACT.CLASS_NBR
            and class_info.TERM_SK = ADW_CLASS_SCHEDULE_FACT.TERM_SK
         ) left join
      ADWTGTPR.ADW_COURSE_OFFER_DIM as ADW_COURSE_OFFER_DIM
         on
         (
            ADW_CLASS_SCHEDULE_FACT.COURSE_OFFER_SK = ADW_COURSE_OFFER_DIM.COURSE_OFFER_SK
         ) left join
      ADWTGTPR.ADW_ACAD_PROGRAM_DIM as ADW_ACAD_PROGRAM_DIM
         on
         (
            class_info.ACAD_PROGRAM_SK = ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM_SK
         ) left join
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract
         on
         (
            class_info.EMPLID = PS_STDNT_ENRL_Extract.EMPLID
            and class_info.INSTITUTION = PS_STDNT_ENRL_Extract.INSTITUTION
            and class_info.CLASS_NBR = PS_STDNT_ENRL_Extract.CLASS_NBR
            and ADW_TERM_DIM.STRM = PS_STDNT_ENRL_Extract.STRM
            and (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
            or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
         )
   where
      class_info.STUDENT_ENRL_CD = 'E'
   group by
      class_info.EMPLID,
      class_info.TERM_SK,
      class_info.FLEX
   ;
quit;

/*==========================================================================*
 * Step:            SCHON SCHOFF                          A5B29B8Q.BZ0005D1 *
 * Transform:       Join                                                    *
 * Description:     SCHON + SCHOFF                                          *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 * Target Table:    Join - work.W1SDP7D5                  A5B29B8Q.BS0001KC *
 *==========================================================================*/

proc sql;
   create table work.W1SDP7D5 as
   select distinct
      class_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      class_info.TERM_SK length = 8
         label = 'TERM_SK',
      class_info.FLEX length = 1
         label = 'FLEX',
      case
         when PS_CLASS_TBL_Extract.CAMPUS  ^= 'OFF-C'
            then sum(class_info.UNIT_TAKEN )
      else .
      end as SCH_ON length = 8
         label = 'SCH_ON',
      case
         when PS_CLASS_TBL_Extract.CAMPUS = 'OFF-C'
            then sum(class_info.UNIT_TAKEN )
      else .
      end as SCH_OFF length = 8
         label = 'SCH_OFF',
      "" as ADDR_STATE length = 8
         label = 'ADDR_STATE',
      "" as PHYS_PRESENCE_STATE length = 6
         format = $6.
         informat = $6.
         label = 'PHYS_PRESENCE_STATE',
      "" as STATE length = 2
         format = $2.
         informat = $2.
         label = 'STATE',
      PS_CLASS_TBL_Extract.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      case
         when PS_CLASS_TBL_Extract.CAMPUS = 'OFF-C' then 'OFF-C'
      else 'ON-C'
      end as campus_on_off length = 5
   from
      ADWTGTPR.CBM1_CLASS_INFO as class_info left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            class_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWSTGPR.PS_CLASS_TBL_Extract as PS_CLASS_TBL_Extract
         on
         (
            class_info.CLASS_NBR = PS_CLASS_TBL_Extract.CLASS_NBR
            and ADW_TERM_DIM.STRM = PS_CLASS_TBL_Extract.STRM
            and PS_CLASS_TBL_Extract.CLASS_STAT = 'A'
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            class_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         )
   where
      class_info.STUDENT_ENRL_CD = 'E'
   group by
      class_info.EMPLID,
      ADW_TERM_DIM.STRM,
      class_info.FLEX,
      campus_on_off
   ;
quit;

/*==========================================================================*
 * Step:            acad_prog join                        A5B29B8Q.BZ0005D2 *
 * Transform:       Join                                                    *
 * Description:     uses acad_plan join already created before              *
 *                                                                          *
 * Source Tables:   PS_ACAD_PROG_Extract -                A5B29B8Q.BE00000J *
 *                   ADWSTGPR.PS_ACAD_PROG_Extract                          *
 *                  CBM1_REQ_TERM -                       A5B29B8Q.BE00018I *
 *                   ADWTGTPR.CBM1_REQ_TERM                                 *
 * Target Table:    Join - work.W1SDPFSF                  A5B29B8Q.BS0001KD *
 *==========================================================================*/

proc sql;
   create table work.W1SDPFSF as
   select
      W4THE81T.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W4THE81T.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W4THE81T.STUDENT_CAREER_NBR as STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      W4THE81T.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W4THE81T.EFFSEQ length = 8
         label = 'EFFSEQ',
      W4THE81T.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W4THE81T.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      PS_ACAD_PROG_Extract.DEGR_CHKOUT_STAT length = 2
         format = $2.
         informat = $2.
         label = 'DEGR_CHKOUT_STAT',
      PS_ACAD_PROG_Extract.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      W4THE81T.TERM_SK length = 8
         label = 'TERM_SK',
      W4THE81T.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM',
      W4THE81T.CLASS length = 1
         label = 'CLASS',
      W4THE81T.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      ADWTGTPR.CBM1_REQ_TERM as W4THE81T,
      ADWSTGPR.PS_ACAD_PROG_Extract as PS_ACAD_PROG_Extract
   where
      W4THE81T.EMPLID = PS_ACAD_PROG_Extract.EMPLID
      and W4THE81T.EFFDT = PS_ACAD_PROG_Extract.EFFDT
      and W4THE81T.EFFSEQ = PS_ACAD_PROG_Extract.EFFSEQ
      and W4THE81T.ACAD_CAREER = PS_ACAD_PROG_Extract.ACAD_CAREER
   ;
quit;

/*==========================================================================*
 * Step:            12H                                   A5B29B8Q.BZ0005D3 *
 * Transform:       Join                                                    *
 * Description:     12H                                                     *
 *                                                                          *
 * Source Tables:   PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K *
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  Join - work.W1SDPFSF                  A5B29B8Q.BS0001KD *
 *                  CBM1_CLASSIFICATION_INFO -            A5B29B8Q.BE00018H *
 *                   ADWTGTPR.CBM1_CLASSIFICATION_INFO                      *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  CBM1_UGDEGR - ADWTGTPR.CBM1_UGDEGR    A5B29B8Q.BE00018L *
 * Target Table:    Join - work.W1SDP87H                  A5B29B8Q.BS0001KE *
 *==========================================================================*/

proc sql;
   create table work.W1SDP87H as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      student_list.FLEX length = 1
         label = 'FLEX',
      'Y' as Hflag length = 1
         label = 'Hflag'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            student_list.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWSTGPR.PS_STDNT_CAR_TERM_Extract as PS_STDNT_CAR_TERM_Extract
         on
         (
            student_list.EMPLID = PS_STDNT_CAR_TERM_Extract.EMPLID
            and ADW_TERM_DIM.STRM = PS_STDNT_CAR_TERM_Extract.STRM
         ) left join
      work.W1SDPFSF as W1SDPFSF
         on
         (
            student_list.EMPLID = W1SDPFSF.EMPLID
         ) left join
      ADWTGTPR.CBM1_CLASSIFICATION_INFO as classification_info
         on
         (
            student_list.EMPLID = classification_info.EMPLID
            and student_list.TERM_SK = classification_info.TERM_SK
         ) left join
      ADWTGTPR.CBM1_UGDEGR as WVSSLDO9
         on
         (
            student_list.EMPLID = WVSSLDO9.EMPLID
            and student_list.TERM_SK = WVSSLDO9.TERM_SK
         )
   where
      classification_info.CLASS = '4'
      and (WVSSLDO9.UGDEGR -PS_STDNT_CAR_TERM_Extract.TOT_CUMULATIVE ) <= 12
      and strip(coalescec(W1SDPFSF.DEGR_CHKOUT_STAT,' ')) NOT IN ('DN', 'WD',' ','')
   ;
quit;

/*==========================================================================*
 * Step:            SCHEDULE_FACT + STRM                  A5B29B8Q.BZ0005D4 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 * Target Table:    Join - work.W1SDP91T                  A5B29B8Q.BS0001KF *
 *==========================================================================*/

proc sql;
   create table work.W1SDP91T as
   select distinct
      ADW_CLASS_SCHEDULE_FACT.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      ADW_CLASS_SCHEDULE_FACT.SUBJECT_SK length = 8
         label = 'SUBJECT_SK',
      ADW_CLASS_SCHEDULE_FACT.CAMPUS_SK length = 8
         label = 'CAMPUS_SK',
      ADW_CLASS_SCHEDULE_FACT.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_CLASS_SCHEDULE_FACT.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      ADW_CLASS_SCHEDULE_FACT.DEPT_SK length = 8
         label = 'DEPT_SK',
      ADW_CLASS_SCHEDULE_FACT.COURSE_OFFER_SK length = 8
         label = 'COURSE_OFFER_SK',
      ADW_CLASS_SCHEDULE_FACT.MONDAY length = 1
         format = $1.
         informat = $1.
         label = 'MONDAY',
      ADW_CLASS_SCHEDULE_FACT.TUESDAY length = 1
         format = $1.
         informat = $1.
         label = 'TUESDAY',
      ADW_CLASS_SCHEDULE_FACT.WEDNESDAY length = 1
         format = $1.
         informat = $1.
         label = 'WEDNESDAY',
      ADW_CLASS_SCHEDULE_FACT.THURSDAY length = 1
         format = $1.
         informat = $1.
         label = 'THURSDAY',
      ADW_CLASS_SCHEDULE_FACT.FRIDAY length = 1
         format = $1.
         informat = $1.
         label = 'FRIDAY',
      ADW_CLASS_SCHEDULE_FACT.SATURDAY length = 1
         format = $1.
         informat = $1.
         label = 'SATURDAY',
      ADW_CLASS_SCHEDULE_FACT.SUNDAY length = 1
         format = $1.
         informat = $1.
         label = 'SUNDAY',
      ADW_CLASS_SCHEDULE_FACT.CATALOG_NBR length = 10
         format = $10.
         informat = $10.
         label = 'CATALOG_NBR',
      ADW_CLASS_SCHEDULE_FACT.DESCR length = 30
         format = $30.
         informat = $30.
         label = 'DESCR',
      ADW_CLASS_SCHEDULE_FACT.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      ADW_CLASS_SCHEDULE_FACT.ENRL_STAT length = 1
         format = $1.
         informat = $1.
         label = 'ENRL_STAT',
      ADW_CLASS_SCHEDULE_FACT.CLASS_STAT length = 1
         format = $1.
         informat = $1.
         label = 'CLASS_STAT',
      ADW_CLASS_SCHEDULE_FACT.CLASS_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'CLASS_TYPE',
      ADW_CLASS_SCHEDULE_FACT.ENRL_CAP length = 8
         label = 'ENRL_CAP',
      ADW_CLASS_SCHEDULE_FACT.WAIT_CAP length = 8
         label = 'WAIT_CAP',
      ADW_CLASS_SCHEDULE_FACT.MIN_ENRL length = 8
         label = 'MIN_ENRL',
      ADW_CLASS_SCHEDULE_FACT.ENRL_TOT length = 8
         label = 'ENRL_TOT',
      ADW_CLASS_SCHEDULE_FACT.WAIT_TOT length = 8
         label = 'WAIT_TOT',
      ADW_CLASS_SCHEDULE_FACT.INSTRUCTION_MODE length = 2
         format = $2.
         informat = $2.
         label = 'INSTRUCTION_MODE',
      ADW_CLASS_SCHEDULE_FACT.ROOM_CAP_REQUEST length = 8
         label = 'ROOM_CAP_REQUEST',
      ADW_CLASS_SCHEDULE_FACT.START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      ADW_CLASS_SCHEDULE_FACT.END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'END_DT',
      ADW_CLASS_SCHEDULE_FACT.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      ADW_CLASS_SCHEDULE_FACT.FACILITY_SK length = 8
         label = 'FACILITY_SK',
      ADW_CLASS_SCHEDULE_FACT.UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'UPDATED_DT',
      ADW_CLASS_SCHEDULE_FACT.UPDATED_USER length = 50
         format = $50.
         informat = $50.
         label = 'UPDATED_USER',
      ADW_CLASS_SCHEDULE_FACT.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      ADWTGTPR.ADW_CLASS_SCHEDULE_FACT as ADW_CLASS_SCHEDULE_FACT,
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
   where
      ADW_CLASS_SCHEDULE_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
   ;
quit;

/*==========================================================================*
 * Step:            DVLP and UNFN flag                    A5B29B8Q.BZ0005D5 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 * Target Table:    Join - work.W1SDPHH5                  A5B29B8Q.BS0001KG *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract);


proc sql;
   create view work.W1SDPHH5 as
   select distinct
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
      case when PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR ='UNFN' then 1 else 0 end as UNFN length = 8,
      case when PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR ='DVLP' then 1 else 0 end as DVLP length = 8
   from
      ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract as PS_CLASS_ATTRIBUTE_Extract
   where
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR IN ('DVLP','UNFN')
   group by
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ID,
      PS_CLASS_ATTRIBUTE_Extract.CLASS_SECTION
   ;
quit;

/*==========================================================================*
 * Step:            MERGE FLAGS                           A5B29B8Q.BZ0005D6 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W1SDPHH5                  A5B29B8Q.BS0001KG *
 * Target Table:    Join - work.W1SDP9W3                  A5B29B8Q.BS0001KH *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W1SDPHH5);


proc sql;
   create view work.W1SDP9W3 as
   select distinct
      W1SDPHH5.CRSE_ID length = 6
         format = $6.
         informat = $6.
         label = 'CRSE_ID',
      W1SDPHH5.CRSE_OFFER_NBR length = 8
         label = 'CRSE_OFFER_NBR',
      W1SDPHH5.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W1SDPHH5.SESSION_CODE length = 3
         format = $3.
         informat = $3.
         label = 'SESSION_CODE',
      W1SDPHH5.CLASS_SECTION length = 4
         format = $4.
         informat = $4.
         label = 'CLASS_SECTION',
      max(W1SDPHH5.UNFN) as UNFN length = 8,
      max(W1SDPHH5.DVLP) as DVLP length = 8
   from
      work.W1SDPHH5 as W1SDPHH5
   ;
quit;

/*==========================================================================*
 * Step:            GR_SCH                                A5B29B8Q.BZ0005D7 *
 * Transform:       Join                                                    *
 * Description:     GR_SCH                                                  *
 *                                                                          *
 * Source Tables:   Join - work.W1SDP87H                  A5B29B8Q.BS0001KE *
 *                  Join - work.W1SDP91T                  A5B29B8Q.BS0001KF *
 *                  Join - work.W1SDP9W3                  A5B29B8Q.BS0001KH *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 * Target Table:    Join - work.W1SDPAQH                  A5B29B8Q.BS0001KI *
 *==========================================================================*/

proc sql;
   create table work.W1SDPAQH as
   select distinct
      class_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      class_info.TERM_SK length = 8
         label = 'TERM_SK',
      class_info.FLEX length = 1
         label = 'FLEX',
      sum(class_info.UNIT_TAKEN ) as GR_SCH length = 8
         label = 'GR_SCH'
   from
      ADWTGTPR.CBM1_CLASS_INFO as class_info left join
      work.W1SDP87H as W1SDP87H
         on
         (
            class_info.EMPLID = W1SDP87H.EMPLID
            and class_info.TERM_SK = W1SDP87H.TERM_SK
            and class_info.FLEX = W1SDP87H.FLEX
         ) left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            class_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            class_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      work.W1SDP91T as W1SDP91T
         on
         (
            W1SDP91T.CLASS_NBR = class_info.CLASS_NBR
            and W1SDP91T.STRM = ADW_TERM_DIM.STRM
         ) left join
      work.W1SDP9W3 as W1SDP9W3
         on
         (
            ADW_TERM_DIM.STRM = W1SDP9W3.STRM
            and class_info.CRSE_ID = W1SDP9W3.CRSE_ID
            and W1SDP9W3.CLASS_SECTION = W1SDP91T.CLASS_SECTION
            and class_info.CRSE_OFFER_NBR = W1SDP9W3.CRSE_OFFER_NBR
            and W1SDP91T.SESSION_CODE = W1SDP9W3.SESSION_CODE
         )
   where
      W1SDP87H.Hflag = 'Y'
      and W1SDP91T.CATALOG_NBR >= '5000'
      and (coalesce(W1SDP9W3.UNFN,0) <> 1
      or W1SDP9W3.UNFN IS NULL )
      and (coalesce(W1SDP9W3.DVLP,0) <> 1
      or W1SDP9W3.DVLP IS NULL )
   group by
      class_info.EMPLID,
      class_info.TERM_SK,
      class_info.FLEX
   ;
quit;

/*==========================================================================*
 * Step:            3peat                                 A5B29B8Q.BZ0005D8 *
 * Transform:       Join                                                    *
 * Description:     Three Peat                                              *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  ADW_CBM_3PEATDEV -                    A5B29B8Q.BE00000M *
 *                   CBMPRD.ADW_CBM_3PEATDEV                                *
 * Target Table:    Join - work.W1SDPCF4                  A5B29B8Q.BS0001KJ *
 *==========================================================================*/

proc sql;
   create table work.W1SDPCF4 as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      student_list.FLEX length = 1
         label = 'FLEX',
      sum(ADW_CBM_3PEATDEV.UNT_TAKEN ) as THREEPEAT length = 8
         label = 'THREEPEAT',
      class_info.FLEX as flex2 length = 1,
      ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'UTA_CB_UNFN_TYPE'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            student_list.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            student_list.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      CBMPRD.ADW_CBM_3PEATDEV as ADW_CBM_3PEATDEV
         on
         (
            student_list.EMPLID = ADW_CBM_3PEATDEV.EMPLID
            and student_list.FLEX_STRM = ADW_CBM_3PEATDEV.STRM
         ) inner join
      ADWTGTPR.CBM1_CLASS_INFO as class_info
         on
         (
            student_list.EMPLID = class_info.EMPLID
            and class_info.CRSE_ID = ADW_CBM_3PEATDEV.CRSE_ID
            and ADW_TERM_DIM.STRM = class_info.STRM
            and ADW_ACAD_CAREER_DIM.ACAD_CAREER = ADW_CBM_3PEATDEV.ACAD_CAREER
            and class_info.FLEX = student_list.FLEX
            and class_info.UNIT_TAKEN > 0
         )
   where
      ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE IN ('R','D')
   group by
      student_list.EMPLID,
      student_list.TERM_SK,
      student_list.FLEX,
      ADW_CBM_3PEATDEV.UTA_CB_UNFN_TYPE
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005D9 *
 * Transform:       Join                                                    *
 * Description:     EXCESSIVE HOURS                                         *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 *                  ADW_CBM_EXCESS_HOURS -                A5B29B8Q.BE00000N *
 *                   CBMPRD.ADW_CBM_EXCESS_HOURS                            *
 * Target Table:    Join - work.W1SDPD9H                  A5B29B8Q.BS0001KK *
 *==========================================================================*/

proc sql;
   create table work.W1SDPD9H as
   select distinct
      class_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      class_info.TERM_SK length = 8
         label = 'TERM_SK',
      class_info.FLEX length = 1
         label = 'FLEX',
      sum(class_info.UNIT_TAKEN ) as EXCESS_HOURS length = 8
         label = 'EXCESS_HOURS',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      ADWTGTPR.CBM1_CLASS_INFO as class_info left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            class_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            class_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ),
      CBMPRD.ADW_CBM_EXCESS_HOURS as ADW_CBM_EXCESS_HOURS
   where
      class_info.EMPLID = ADW_CBM_EXCESS_HOURS.EMPLID
      and "&term." = ADW_CBM_EXCESS_HOURS.STRM
      and class_info.STUDENT_ENRL_CD = 'E'
      and ADW_ACAD_CAREER_DIM.INSTITUTION = ADW_CBM_EXCESS_HOURS.INSTITUTION
   group by
      class_info.EMPLID,
      class_info.TERM_SK,
      class_info.FLEX
   ;
quit;

/*==========================================================================*
 * Step:            SCHCNSF + Flex                        A5B29B8Q.BZ0005DA *
 * Transform:       Join                                                    *
 * Description:     SCHCNSF_NEG used to mimic line 4600                     *
 *                                                                          *
 * Source Tables:   Join - work.W1SDPCF4                  A5B29B8Q.BS0001KJ *
 *                  Join - work.W1SDP5OH                  A5B29B8Q.BS0001KA *
 *                  Join - work.W1SDPGMS                  A5B29B8Q.BS0001KB *
 *                  Join - work.W1SDPD9H                  A5B29B8Q.BS0001KK *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W1SDPE3S                  A5B29B8Q.BS0001KL *
 *==========================================================================*/

proc sql;
   create table work.W1SDPE3S as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      student_list.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      student_list.FLEX_STRM length = 8,
      student_list.FLEX length = 1
         label = 'FLEX',
      case when W1SDPD9H.EXCESS_HOURS > 0 then case
                                                                                              when W1SDPD9H.EXCESS_HOURS < W1SDPCF4.THREEPEAT then sum(W1SDPCF4.THREEPEAT,0 )
      	 	 	                else sum(W1SDPD9H.EXCESS_HOURS,0  )
                           			               end
      else
      sum(W1SDPCF4.THREEPEAT  , W1SDP5OH.UNFN   ,W1SDPGMS.PHYED,W1SDPD9H.EXCESS_HOURS   )
      end as SCHCNSF length = 8
         label = 'SCHCNSF',
      case when coalescec(student_list.FLEX,' ') ^= '1' then
      	case when W1SDPD9H.EXCESS_HOURS > 0 then case
      	                                                                                        when W1SDPD9H.EXCESS_HOURS < W1SDPCF4.THREEPEAT then sum(W1SDPCF4.THREEPEAT,0 )
      		 	 	                else sum(W1SDPD9H.EXCESS_HOURS,0  )
      	                     			               end
      	else
      	sum(W1SDPCF4.THREEPEAT  , W1SDP5OH.UNFN   ,W1SDPGMS.PHYED,W1SDPD9H.EXCESS_HOURS   )
      	end
      when coalescec(student_list.FLEX,' ') = '1' then
      	case when W1SDPD9H.EXCESS_HOURS > 0 then case
      	                                                                                        when W1SDPD9H.EXCESS_HOURS < W1SDPCF4.THREEPEAT then (-1 * sum(W1SDPCF4.THREEPEAT,0 ))
      		 	 	                else -1 * (sum(W1SDPD9H.EXCESS_HOURS,0  ))
      	                     			               end
      	else
      	-1 * (sum(W1SDPCF4.THREEPEAT  , W1SDP5OH.UNFN   ,W1SDPGMS.PHYED,W1SDPD9H.EXCESS_HOURS   ))
      	end
      end as SCHCNSF_NEG length = 8
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      work.W1SDPCF4 as W1SDPCF4
         on
         (
            student_list.EMPLID = W1SDPCF4.EMPLID
            and student_list.TERM_SK = W1SDPCF4.TERM_SK
            and student_list.FLEX = W1SDPCF4.FLEX
            and W1SDPCF4.UTA_CB_UNFN_TYPE = 'R'
         ) left join
      work.W1SDP5OH as W1SDP5OH
         on
         (
            student_list.EMPLID = W1SDP5OH.EMPLID
            and student_list.TERM_SK = W1SDP5OH.TERM_SK
            and student_list.FLEX = W1SDP5OH.FLEX
         ) left join
      work.W1SDPGMS as W1SDPGMS
         on
         (
            student_list.EMPLID = W1SDPGMS.EMPLID
            and student_list.TERM_SK = W1SDPGMS.TERM_SK
            and student_list.FLEX = W1SDPGMS.FLEX
         ) left join
      work.W1SDPD9H as W1SDPD9H
         on
         (
            student_list.EMPLID = W1SDPD9H.EMPLID
            and student_list.TERM_SK = W1SDPD9H.TERM_SK
            and student_list.FLEX = W1SDPD9H.FLEX
         )
   where
      sum(W1SDPCF4.THREEPEAT , W1SDP5OH.UNFN  ,W1SDPGMS.PHYED,W1SDPD9H.EXCESS_HOURS  ) IS NOT NULL
   ;
quit;

/*==========================================================================*
 * Step:            max(ADMIT TERM)                       A5B29B8Q.BZ0005DB *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W1SDPIBG                  A5B29B8Q.BS0001KM *
 *==========================================================================*/

proc sql;
   create table work.W1SDPIBG as
   select
      PS_ADM_APPL_PROG_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_ADM_APPL_PROG_Extract.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      PS_ADM_APPL_PROG_Extract.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      PS_ADM_APPL_PROG_Extract.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      PS_ADM_APPL_PROG_Extract.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      PS_ADM_APPL_PROG_Extract.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      PS_ADM_APPL_PROG_Extract.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      PS_ADM_APPL_PROG_Extract.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      PS_ADM_APPL_PROG_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ADM_APPL_PROG_Extract.EFFSEQ length = 8
         label = 'EFFSEQ',
      PS_ADM_APPL_PROG_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ADM_APPL_PROG_Extract.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      PS_ADM_APPL_PROG_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_ADM_APPL_PROG_Extract.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      PS_ADM_APPL_PROG_Extract.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      PS_ADM_APPL_PROG_Extract.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      PS_ADM_APPL_PROG_Extract.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      PS_ADM_APPL_PROG_Extract.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      PS_ADM_APPL_PROG_Extract.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      PS_ADM_APPL_PROG_Extract.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      PS_ADM_APPL_PROG_Extract.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      PS_ADM_APPL_PROG_Extract.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      PS_ADM_APPL_PROG_Extract.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      PS_ADM_APPL_PROG_Extract.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      PS_ADM_APPL_PROG_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ADM_APPL_PROG_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            student_list.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWSTGPR.PS_ADM_APPL_PROG_Extract as PS_ADM_APPL_PROG_Extract
         on
         (
            student_list.EMPLID = PS_ADM_APPL_PROG_Extract.EMPLID
         )
   where
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM <= ADW_TERM_DIM.STRM
   group by
      student_list.EMPLID
   having
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM = max(PS_ADM_APPL_PROG_Extract.ADMIT_TERM)
   ;
quit;

/*==========================================================================*
 * Step:            max(effdt)                            A5B29B8Q.BZ0005DC *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W1SDPIBG                  A5B29B8Q.BS0001KM *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 * Target Table:    Join - work.W1SDPJ5S                  A5B29B8Q.BS0001KN *
 *==========================================================================*/

proc sql;
   create table work.W1SDPJ5S as
   select
      W1SDPIBG.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W1SDPIBG.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      W1SDPIBG.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      W1SDPIBG.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      W1SDPIBG.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      W1SDPIBG.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      W1SDPIBG.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W1SDPIBG.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      W1SDPIBG.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      W1SDPIBG.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W1SDPIBG.EFFSEQ length = 8
         label = 'EFFSEQ',
      W1SDPIBG.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W1SDPIBG.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      W1SDPIBG.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      W1SDPIBG.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      W1SDPIBG.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      W1SDPIBG.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      W1SDPIBG.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      W1SDPIBG.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W1SDPIBG.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      W1SDPIBG.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      W1SDPIBG.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      W1SDPIBG.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      W1SDPIBG.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      W1SDPIBG.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      W1SDPIBG.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      W1SDPIBG.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      W1SDPIBG.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      W1SDPIBG.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      W1SDPIBG.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      W1SDPIBG.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      work.W1SDPIBG as W1SDPIBG left join
      ADWSTGPR.PS_ADM_APPL_PROG_Extract as PS_ADM_APPL_PROG_Extract
         on
         (
            W1SDPIBG.EMPLID = PS_ADM_APPL_PROG_Extract.EMPLID
            and W1SDPIBG.ADMIT_TERM = PS_ADM_APPL_PROG_Extract.ADMIT_TERM
         )
   where
      PS_ADM_APPL_PROG_Extract.EFFDT <= datetime()
   group by
      W1SDPIBG.EMPLID,
      W1SDPIBG.ADMIT_TERM
   having
      W1SDPIBG.EFFDT = max(W1SDPIBG.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            max(effseq)                           A5B29B8Q.BZ0005DD *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W1SDPJ5S                  A5B29B8Q.BS0001KN *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 * Target Table:    Join - work.W1SDPK03                  A5B29B8Q.BS0001KO *
 *==========================================================================*/

proc sql;
   create table work.W1SDPK03 as
   select distinct
      W1SDPJ5S.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W1SDPJ5S.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      W1SDPJ5S.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      W1SDPJ5S.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      W1SDPJ5S.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      W1SDPJ5S.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      W1SDPJ5S.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W1SDPJ5S.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      W1SDPJ5S.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      W1SDPJ5S.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W1SDPJ5S.EFFSEQ length = 8
         label = 'EFFSEQ',
      W1SDPJ5S.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W1SDPJ5S.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      W1SDPJ5S.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      W1SDPJ5S.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      W1SDPJ5S.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      W1SDPJ5S.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      W1SDPJ5S.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      W1SDPJ5S.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W1SDPJ5S.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      W1SDPJ5S.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      W1SDPJ5S.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      W1SDPJ5S.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      W1SDPJ5S.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      W1SDPJ5S.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      W1SDPJ5S.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      W1SDPJ5S.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      W1SDPJ5S.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      W1SDPJ5S.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      W1SDPJ5S.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      W1SDPJ5S.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      work.W1SDPJ5S as W1SDPJ5S left join
      ADWSTGPR.PS_ADM_APPL_PROG_Extract as PS_ADM_APPL_PROG_Extract
         on
         (
            W1SDPJ5S.EMPLID = PS_ADM_APPL_PROG_Extract.EMPLID
            and W1SDPJ5S.ADMIT_TERM = PS_ADM_APPL_PROG_Extract.ADMIT_TERM
            and W1SDPJ5S.EFFDT = PS_ADM_APPL_PROG_Extract.EFFDT
         )
   group by
      W1SDPJ5S.EMPLID,
      W1SDPJ5S.ADMIT_TERM,
      W1SDPJ5S.EFFDT
   having
      W1SDPJ5S.EFFSEQ = max(W1SDPJ5S.EFFSEQ)
   ;
quit;

/*==========================================================================*
 * Step:            SCHDC                                 A5B29B8Q.BZ0005DE *
 * Transform:       Join                                                    *
 * Description:     SCHDC - Dual Credit                                     *
 *                                                                          *
 * Source Tables:   PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U *
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      *
 *                  PS_ADM_APPL_RCR_CA_Extract -          A5B29B8Q.BE00000V *
 *                   ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract                    *
 *                  ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  Join - work.W1SDPJ5S                  A5B29B8Q.BS0001KN *
 *                  Join - work.W1SDPK03                  A5B29B8Q.BS0001KO *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W1SDPBKS                  A5B29B8Q.BS0001KP *
 *==========================================================================*/

proc sql;
   create table work.W1SDPBKS as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_STUDENT_TERM_ENRL_FACT.UNIT_TAKEN as SCHDC length = 8
         label = 'SCHDC',
      student_list.FLEX length = 1
         label = 'FLEX',
      1 as SCHDC_FLAG length = 8,
      PS_ADM_APPL_DATA_Extract.ADMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      PS_ADM_APPL_RCR_CA_Extract.RECRUITMENT_CAT length = 4
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT',
      "" as ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT
         on
         (
            student_list.EMPLID = ADW_STUDENT_TERM_ENRL_FACT.EMPLID
            and student_list.ACAD_CAREER_SK = ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK
            and student_list.TERM_SK = ADW_STUDENT_TERM_ENRL_FACT.TERM_SK
         ) left join
      work.W1SDPK03 as W1SDPK03
         on
         (
            student_list.EMPLID = W1SDPK03.EMPLID
         ) left join
      ADWSTGPR.PS_ADM_APPL_DATA_Extract as PS_ADM_APPL_DATA_Extract
         on
         (
            W1SDPK03.EMPLID = PS_ADM_APPL_DATA_Extract.EMPLID
            and W1SDPK03.ACAD_CAREER = PS_ADM_APPL_DATA_Extract.ACAD_CAREER
            and W1SDPK03.STDNT_CAR_NBR = PS_ADM_APPL_DATA_Extract.STDNT_CAR_NBR
            and W1SDPK03.ADM_APPL_NBR = PS_ADM_APPL_DATA_Extract.ADM_APPL_NBR
         ) left join
      ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract as PS_ADM_APPL_RCR_CA_Extract
         on
         (
            W1SDPK03.EMPLID = PS_ADM_APPL_RCR_CA_Extract.EMPLID
            and W1SDPK03.ACAD_CAREER = PS_ADM_APPL_RCR_CA_Extract.ACAD_CAREER
            and W1SDPK03.STDNT_CAR_NBR = PS_ADM_APPL_RCR_CA_Extract.STDNT_CAR_NBR
            and W1SDPK03.ADM_APPL_NBR = PS_ADM_APPL_RCR_CA_Extract.ADM_APPL_NBR
         )
   where
      W1SDPK03.ADMIT_TERM <= "&term."
   having
      (W1SDPK03.ACAD_CAREER = 'UGRD'
      and (PS_ADM_APPL_DATA_Extract.ADMIT_TYPE = '1'
      or PS_ADM_APPL_DATA_Extract.ADMIT_TYPE = '5')
      and W1SDPK03.ACAD_PROG = 'UGNDS'
      and PS_ADM_APPL_RCR_CA_Extract.RECRUITMENT_CAT = 'AUEA')
   ;
quit;

/*==========================================================================*
 * Step:            SCHDSF + Flex                         A5B29B8Q.BZ0005DF *
 * Transform:       Join                                                    *
 * Description:     DVLP                                                    *
 *                                                                          *
 * Source Tables:   ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_CLASS_SCHEDULE_FACT -             A5B29B8Q.BE0000RM *
 *                   ADWTGTPR.ADW_CLASS_SCHEDULE_FACT                       *
 *                  ADW_COURSE_OFFER_DIM -                A5B29B8Q.BE0000RO *
 *                   ADWTGTPR.ADW_COURSE_OFFER_DIM                          *
 *                  PS_CLASS_ATTRIBUTE_Extract -          A5B29B8Q.BE000005 *
 *                   ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract                    *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_CLASS_INFO -                     A5B29B8Q.BE00018G *
 *                   ADWTGTPR.CBM1_CLASS_INFO                               *
 * Target Table:    Join - work.W1SDP6IS                  A5B29B8Q.BS0001KQ *
 *==========================================================================*/

proc sql;
   create table work.W1SDP6IS as
   select distinct
      class_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_TERM_DIM.TERM_SK length = 8
         label = 'TERM_SK',
      class_info.FLEX length = 1
         label = 'FLEX',
      sum(class_info.UNIT_TAKEN ) as SCHDSF length = 8
         label = 'SCHDSF'
   from
      ADWTGTPR.CBM1_CLASS_INFO as class_info left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            class_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_CLASS_SCHEDULE_FACT as ADW_CLASS_SCHEDULE_FACT
         on
         (
            class_info.TERM_SK = ADW_CLASS_SCHEDULE_FACT.TERM_SK
            and class_info.CLASS_NBR = ADW_CLASS_SCHEDULE_FACT.CLASS_NBR
         ) left join
      ADWTGTPR.ADW_COURSE_OFFER_DIM as ADW_COURSE_OFFER_DIM
         on
         (
            ADW_CLASS_SCHEDULE_FACT.COURSE_OFFER_SK = ADW_COURSE_OFFER_DIM.COURSE_OFFER_SK
         ) left join
      ADWSTGPR.PS_CLASS_ATTRIBUTE_Extract as PS_CLASS_ATTRIBUTE_Extract
         on
         (
            ADW_COURSE_OFFER_DIM.COURSE_IDENTIFIER = PS_CLASS_ATTRIBUTE_Extract.CRSE_ID
            and ADW_TERM_DIM.STRM = PS_CLASS_ATTRIBUTE_Extract.STRM
            and ADW_CLASS_SCHEDULE_FACT.CLASS_SECTION = PS_CLASS_ATTRIBUTE_Extract.CLASS_SECTION
            and class_info.SESSION_CD = PS_CLASS_ATTRIBUTE_Extract.SESSION_CODE
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            class_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         )
   where
      PS_CLASS_ATTRIBUTE_Extract.CRSE_ATTR = 'DVLP'
      and class_info.STUDENT_ENRL_CD = 'E'
   group by
      class_info.EMPLID,
      ADW_TERM_DIM.TERM_SK,
      class_info.FLEX
   ;
quit;

/*==========================================================================*
 * Step:            Combine SCH Fields                    A5B29B8Q.BZ0005DG *
 * Transform:       Join                                                    *
 * Description:     Combine SCH Fields                                      *
 *                                                                          *
 * Source Tables:   Join - work.W1SDP7D5                  A5B29B8Q.BS0001KC *
 *                  Join - work.W1SDP6IS                  A5B29B8Q.BS0001KQ *
 *                  Join - work.W1SDPAQH                  A5B29B8Q.BS0001KI *
 *                  Join - work.W1SDPBKS                  A5B29B8Q.BS0001KP *
 *                  Join - work.W1SDPCF4                  A5B29B8Q.BS0001KJ *
 *                  Join - work.W1SDPD9H                  A5B29B8Q.BS0001KK *
 *                  Join - work.W1SDPE3S                  A5B29B8Q.BS0001KL *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    CBM1_SCH - ADWTGTPR.CBM1_SCH          A5B29B8Q.BE00018J *
 *==========================================================================*/

proc sql;
   create table ADWTGTPR.CBM1_SCH as
   select distinct
      student_list.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      student_list.TERM_SK length = 8
         label = 'TERM_SK',
      student_list.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      student_list.FLEX length = 1
         label = 'FLEX',
      MAX(W1SDP7D5.SCH_ON) as SCH_ON length = 8
         label = 'SCH_ON',
      MAX(W1SDP7D5.SCH_OFF ) as SCH_OFF length = 8
         label = 'SCH_OFF',
      case
      	when  coalesce(W1SDP6IS.SCHDSF,0) >0 and coalesce(W1SDPD9H.EXCESS_HOURS ,0)>0 then 0
         when coalesce(W1SDP6IS.SCHDSF,0) <= 18 and  coalesce(W1SDPCF4.THREEPEAT ,0) <= 0
            then W1SDP6IS.SCHDSF
      else .
      end as SCHDSF length = 8
         label = 'SCHDSF',
      case
         when  coalesce(W1SDPCF4.THREEPEAT ,0) > 0
            then W1SDP6IS.SCHDSF
      else .
      end as SCHDNSF length = 8
         label = 'SCHDNSF',
      W1SDPE3S.SCHCNSF length = 8
         label = 'SCHCNSF',
      W1SDPAQH.GR_SCH length = 8
         label = 'GR_SCH',
      W1SDPBKS.SCHDC length = 8
         label = 'SCHDC',
      W1SDPBKS.SCHDC_FLAG length = 8
   from
      ADWTGTPR.CBM1_STUDENT_LIST as student_list left join
      work.W1SDP7D5 as W1SDP7D5
         on
         (
            student_list.EMPLID = W1SDP7D5.EMPLID
            and student_list.TERM_SK = W1SDP7D5.TERM_SK
            and student_list.FLEX = W1SDP7D5.FLEX
         ) left join
      work.W1SDP6IS as W1SDP6IS
         on
         (
            student_list.EMPLID = W1SDP6IS.EMPLID
            and student_list.TERM_SK = W1SDP6IS.TERM_SK
            and student_list.FLEX = W1SDP6IS.FLEX
         ) left join
      work.W1SDPE3S as W1SDPE3S
         on
         (
            student_list.EMPLID = W1SDPE3S.EMPLID
            and student_list.TERM_SK = W1SDPE3S.TERM_SK
            and student_list.FLEX = W1SDPE3S.FLEX
         ) left join
      work.W1SDPAQH as W1SDPAQH
         on
         (
            student_list.EMPLID = W1SDPAQH.EMPLID
            and student_list.TERM_SK = W1SDPAQH.TERM_SK
            and student_list.FLEX = W1SDPAQH.FLEX
         ) left join
      work.W1SDPBKS as W1SDPBKS
         on
         (
            student_list.EMPLID = W1SDPBKS.EMPLID
            and student_list.TERM_SK = W1SDPBKS.TERM_SK
            and student_list.FLEX = W1SDPBKS.FLEX
         ) left join
      work.W1SDPCF4 as W1SDPCF4
         on
         (
            student_list.EMPLID = W1SDPCF4.EMPLID
            and W1SDPCF4.TERM_SK = student_list.TERM_SK
            and W1SDPCF4.FLEX = student_list.FLEX
            and W1SDPCF4.UTA_CB_UNFN_TYPE = 'D'
         ) left join
      work.W1SDPD9H as W1SDPD9H
         on
         (
            student_list.EMPLID = W1SDPD9H.EMPLID
            and W1SDPD9H.STRM = student_list.STRM
            and student_list.FLEX = W1SDPD9H.FLEX
         )
   group by
      student_list.EMPLID,
      student_list.ACAD_CAREER_SK,
      student_list.TERM_SK,
      student_list.FLEX
   ;
quit;

/**  Job end SCH **/

/* Reset jobid and name */

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNU *
 * Transform:       Join                                                    *
 * Description:     ITEM_AMT for FLAG_WAV                                   *
 *                                                                          *
 * Source Tables:   PS_ITEM_SF_Extract -                  A5B29B8Q.BE00004B *
 *                   ADWSTGPR.PS_ITEM_SF_Extract                            *
 *                  ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 * Target Table:    Join - work.WTCA9MFQ                  A5B29B8Q.BS00041L *
 *==========================================================================*/

proc sql;
   create table work.WTCA9MFQ as
   select distinct
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_ACAD_CAREER_DIM.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_TERM_DIM.TERM_SK length = 8
         label = 'TERM_SK',
      PS_ITEM_SF_Extract.BUSINESS_UNIT length = 5
         format = $5.
         informat = $5.
         label = 'BUSINESS_UNIT',
      PS_ITEM_SF_Extract.SA_ID_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'SA_ID_TYPE',
      "" as WAIVER_CODE length = 6
         format = $6.
         informat = $6.
         label = 'WAIVER_CODE',
      case
         when PS_ITEM_SF_Extract.WAIVER_CODE like '3%'
            then sum(PS_ITEM_SF_Extract.ITEM_AMT )
      else 0
      end as AMT_3 length = 8
         label = 'AMT_3',
      case
         when PS_ITEM_SF_Extract.WAIVER_CODE like 'E100%'
            then sum(PS_ITEM_SF_Extract.ITEM_AMT )
      else 0
      end as AMT_F length = 8
         label = 'AMT_F',
      case
         when PS_ITEM_SF_Extract.WAIVER_CODE like 'E%'
            then sum(PS_ITEM_SF_Extract.ITEM_AMT )
      else 0
      end as AMT_E length = 8
         label = 'AMT_E',
      case
         when PS_ITEM_SF_Extract.WAIVER_CODE like '3%' then '3'
         when PS_ITEM_SF_Extract.WAIVER_CODE like 'E100%' then 'E100'
         when PS_ITEM_SF_Extract.WAIVER_CODE like 'E%' then 'E'
      else ''
      end as waiver length = 8,
      count(*) as waiver_count length = 8,
      case
         when PS_ITEM_SF_Extract.WAIVER_CODE like '3%' then 3
         when PS_ITEM_SF_Extract.WAIVER_CODE like 'E100%' then 2
         when PS_ITEM_SF_Extract.WAIVER_CODE like 'E%' then 1
      else 0
      end as waiver_number length = 8,
      case
         when substr(PS_ITEM_SF_Extract.WAIVER_CODE ,1,4) in ('3HAZ','3MOR','3HZD') then 1
      else 0
      end as waiver_3 length = 8,
      case
         when substr(PS_ITEM_SF_Extract.WAIVER_CODE ,1,4) in ('EMST') then 1
      else 0
      end as waiver_e length = 8
   from
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWSTGPR.PS_ITEM_SF_Extract as PS_ITEM_SF_Extract
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.EMPLID = PS_ITEM_SF_Extract.EMPLID
            and ADW_TERM_DIM.STRM = PS_ITEM_SF_Extract.ITEM_TERM
            and ADW_ACAD_CAREER_DIM.ACAD_CAREER = PS_ITEM_SF_Extract.BILLING_CAREER
            and PS_ITEM_SF_Extract.SA_ID_TYPE = 'P'
            and PS_ITEM_SF_Extract.BUSINESS_UNIT = 'UTARL'
            and PS_ITEM_SF_Extract.ITEM_TYPE_CD = 'W'
         )
   group by
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID,
      PS_ITEM_SF_Extract.ITEM_TERM,
      waiver
   ;
quit;

/*==========================================================================*
 * Step:            gets count so extras can be removed   A5B29B8Q.BZ000BNV *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WTCA9MFQ                  A5B29B8Q.BS00041L *
 * Target Table:    Join - work.WPU1F4JF                  A5B29B8Q.BS00041M *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.WTCA9MFQ);


proc sql;
   create table work.WPU1F4JF as
   select distinct
      WTCA9MFQ.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WTCA9MFQ.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WTCA9MFQ.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WTCA9MFQ.TERM_SK length = 8
         label = 'TERM_SK',
      WTCA9MFQ.BUSINESS_UNIT length = 5
         format = $5.
         informat = $5.
         label = 'BUSINESS_UNIT',
      WTCA9MFQ.SA_ID_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'SA_ID_TYPE',
      WTCA9MFQ.WAIVER_CODE length = 6
         format = $6.
         informat = $6.
         label = 'WAIVER_CODE',
      WTCA9MFQ.AMT_3 length = 8
         label = 'AMT_3',
      WTCA9MFQ.AMT_F length = 8
         label = 'AMT_F',
      WTCA9MFQ.AMT_E length = 8
         label = 'AMT_E',
      WTCA9MFQ.waiver length = 8,
      count(*) as waiver_count length = 8,
      WTCA9MFQ.waiver_number length = 8,
      max(WTCA9MFQ.waiver_3) as waiver_3 length = 8,
      max(WTCA9MFQ.waiver_e) as waiver_e length = 8
   from
      work.WTCA9MFQ as WTCA9MFQ
   where
      WTCA9MFQ.AMT_3 <> 0
      or WTCA9MFQ.AMT_F <> 0
      or WTCA9MFQ.AMT_E <> 0
   group by
      WTCA9MFQ.EMPLID,
      WTCA9MFQ.TERM_SK
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNW *
 * Transform:       Join                                                    *
 * Description:     FLAG_WAV for Tuition Status                             *
 *                                                                          *
 * Source Table:    Join - work.WPU1F4JF                  A5B29B8Q.BS00041M *
 * Target Table:    Join - work.WTEH69WT                  A5B29B8Q.BS00041N *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.WPU1F4JF);


proc sql;
   create table work.WTEH69WT as
   select distinct
      WPU1F4JF.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WPU1F4JF.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WPU1F4JF.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WPU1F4JF.TERM_SK length = 8
         label = 'TERM_SK',
      WPU1F4JF.BUSINESS_UNIT length = 5
         format = $5.
         informat = $5.
         label = 'BUSINESS_UNIT',
      WPU1F4JF.SA_ID_TYPE length = 1
         format = $1.
         informat = $1.
         label = 'SA_ID_TYPE',
      WPU1F4JF.WAIVER_CODE length = 6
         format = $6.
         informat = $6.
         label = 'WAIVER_CODE',
      WPU1F4JF.AMT_3 length = 8
         label = 'AMT_3',
      WPU1F4JF.AMT_F length = 8
         label = 'AMT_F',
      WPU1F4JF.AMT_E length = 8
         label = 'AMT_E',
      case
         when WPU1F4JF.waiver like '3%'  & WPU1F4JF.AMT_3 < 0
            then '3'
         when WPU1F4JF.waiver like 'E100%'  & WPU1F4JF.AMT_F < 0
            then 'E'
         when WPU1F4JF.waiver like 'E%'  & WPU1F4JF.AMT_E < 0
            then 'E'
      else ''
      end as Flag_WAV length = 8
         label = 'Flag_WAV',
      WPU1F4JF.waiver_3 length = 8,
      WPU1F4JF.waiver_e length = 8
   from
      work.WPU1F4JF as WPU1F4JF
   group by
      WPU1F4JF.EMPLID,
      WPU1F4JF.TERM_SK,
      WPU1F4JF.STRM
   having
      WPU1F4JF.waiver_count = 1
      or (WPU1F4JF.waiver_count > 1
      and WPU1F4JF.waiver_number = max(WPU1F4JF.waiver_number))
   ;
quit;

/*==========================================================================*
 * Step:            Tuition_status                        A5B29B8Q.BZ000BNX *
 * Transform:       Join                                                    *
 * Description:     Tuition Status                                          *
 *                                                                          *
 * Source Tables:   Join - work.WTEH69WT                  A5B29B8Q.BS00041N *
 *                  PS_RESIDENCY_OFF_Extract -            A5B29B8Q.BE000059 *
 *                   ADWSTGPR.PS_RESIDENCY_OFF_Extract                      *
 *                  ADW_RESIDENCY_DIM -                   A5B29B8Q.BE0000RW *
 *                   ADWTGTPR.ADW_RESIDENCY_DIM                             *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.WTFF23DL                  A5B29B8Q.BS00041O *
 *==========================================================================*/

proc sql;
   create table work.WTFF23DL as
   select distinct
      Student_term_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_ACAD_CAREER_DIM.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      Student_term_info.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EFFECTIVE_TERM',
      Student_term_info.TERM_SK length = 8
         label = 'TERM_SK',
      WTEH69WT.WAIVER_CODE length = 6
         format = $6.
         informat = $6.
         label = 'WAIVER_CODE',
      WTEH69WT.Flag_WAV length = 8
         label = 'Flag_WAV',
      PS_RESIDENCY_OFF_Extract.ADMISSION_EXCPT length = 5
         format = $5.
         informat = $5.
         label = 'ADMISSION_EXCPT',
      PS_RESIDENCY_OFF_Extract.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'RESIDENCY',
      case when PS_RESIDENCY_OFF_Extract.RESIDENCY = '1' then
      	case when WTEH69WT.Flag_WAV = '3' then '3'
      	else '1'
      	end
      else case when PS_RESIDENCY_OFF_Extract.RESIDENCY  ^= '1' then
      	case when WTEH69WT.Flag_WAV = 'F' then 'F'
      	when WTEH69WT.Flag_WAV = 'E' then 'E'
      	when PS_RESIDENCY_OFF_Extract.ADMISSION_EXCPT = '1403A'  | PS_RESIDENCY_OFF_Extract.ADMISSION_EXCPT = '1528A' then 'A'
      	when PS_RESIDENCY_OFF_Extract.ADMISSION_EXCPT = '1403C' |
      PS_RESIDENCY_OFF_Extract.ADMISSION_EXCPT = '1528C' then 'C'
      	when PS_RESIDENCY_OFF_Extract.ADMISSION_EXCPT = 'DISAS' then 'N'
      	else '2'
      	end
      else ''
      end

      end as TUITION_STATUS length = 1
         label = 'TUITION STATUS',
      WTEH69WT.waiver_3 length = 8,
      WTEH69WT.waiver_e length = 8
   from
      ADWTGTPR.CBM1_STUDENT_LIST as Student_term_info inner join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            Student_term_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      work.WTEH69WT as WTEH69WT
         on
         (
            Student_term_info.TERM_SK = WTEH69WT.TERM_SK
            and Student_term_info.EMPLID = WTEH69WT.EMPLID
         ) left join
      ADWSTGPR.PS_RESIDENCY_OFF_Extract as PS_RESIDENCY_OFF_Extract
         on
         (
            Student_term_info.EMPLID = PS_RESIDENCY_OFF_Extract.EMPLID
            and ADW_ACAD_CAREER_DIM.ACAD_CAREER = PS_RESIDENCY_OFF_Extract.ACAD_CAREER
         ) inner join
      ADWTGTPR.ADW_RESIDENCY_DIM as ADW_RESIDENCY_DIM
         on
         (
            PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM <= Student_term_info.STRM
            and PS_RESIDENCY_OFF_Extract.RESIDENCY = ADW_RESIDENCY_DIM.RESIDENCY_CD
         )
   group by
      Student_term_info.TERM_SK,
      Student_term_info.EMPLID
   having
      PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM = max(PS_RESIDENCY_OFF_Extract.EFFECTIVE_TERM )
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BNY *
 * Transform:       Join                                                    *
 * Description:     Tuition Exempt                                          *
 *                                                                          *
 * Source Table:    Join - work.WTFF23DL                  A5B29B8Q.BS00041O *
 * Target Table:    tuition_status_exemption -            A5B29B8Q.BS00041P *
 *                   work.WTG7ZRE1                                          *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.WTFF23DL);


proc sql;
   create table work.WTG7ZRE1 as
   select distinct
      WTFF23DL.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WTFF23DL.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      WTFF23DL.TERM_SK length = 8
         label = 'TERM_SK',
      WTFF23DL.ADMISSION_EXCPT length = 5
         format = $5.
         informat = $5.
         label = 'ADMISSION_EXCPT',
      WTFF23DL.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'RESIDENCY',
      WTFF23DL.TUITION_STATUS length = 1
         label = 'TUITION STATUS',
      case
         when WTFF23DL.RESIDENCY  = '1'  & WTFF23DL.TUITION_STATUS = '3'  &  (WTFF23DL.waiver_3 = 1 )
            then '01'
         when WTFF23DL.RESIDENCY  ^=  '1'  & WTFF23DL.TUITION_STATUS = 'E'  & WTFF23DL.WAIVER_e = 1
            then '21'
      else ''
      end as TUITION_EXEMPT length = 2
         label = 'TUITION_EXEMPT'
   from
      work.WTFF23DL as WTFF23DL
   group by
      WTFF23DL.EMPLID,
      WTFF23DL.TERM_SK,
      WTFF23DL.ACAD_CAREER,
      WTFF23DL.ADMISSION_EXCPT
   having
      TUITION_EXEMPT = max(TUITION_EXEMPT)
   ;
quit;

/*==========================================================================*
 * Step:            ethnic group code                     A5B29B8Q.BZ000BNZ *
 * Transform:       Join                                                    *
 * Description:     max effdt                                               *
 *                                                                          *
 * Source Table:    PS_HCR_ETHNIC_GRP_I_Extract -         A5B29B8Q.BE00003U *
 *                   ADWSTGPR.PS_HCR_ETHNIC_GRP_I_Extract                   *
 * Target Table:    Join - work.W13ODVMIT                 A5B29B8Q.BS00041Q *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_HCR_ETHNIC_GRP_I_Extract);


proc sql;
   create table work.W13ODVMIT as
   select distinct
      PS_HCR_ETHNIC_GRP_I_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_HCR_ETHNIC_GRP_I_Extract.ETHNIC_GRP_CD length = 8
         format = $8.
         informat = $8.
         label = 'ETHNIC_GRP_CD',
      PS_HCR_ETHNIC_GRP_I_Extract.ETHNIC_GROUP length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC_GROUP',
      PS_HCR_ETHNIC_GRP_I_Extract.SETID length = 5
         format = $5.
         informat = $5.
         label = 'SETID'
   from
      ADWSTGPR.PS_HCR_ETHNIC_GRP_I_Extract as PS_HCR_ETHNIC_GRP_I_Extract
   group by
      PS_HCR_ETHNIC_GRP_I_Extract.ETHNIC_GRP_CD,
      PS_HCR_ETHNIC_GRP_I_Extract.SETID
   having
      PS_HCR_ETHNIC_GRP_I_Extract.EFFDT = max(PS_HCR_ETHNIC_GRP_I_Extract.EFFDT )
   ;
quit;

/*==========================================================================*
 * Step:            ethnic group                          A5B29B8Q.BZ000BO0 *
 * Transform:       Join                                                    *
 * Description:     Ethnic Group                                            *
 *                                                                          *
 * Source Tables:   PS_HCR_DIV_ETHNIC_I_Extract -         A5B29B8Q.BE00003T *
 *                   ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract                   *
 *                  Join - work.W13ODVMIT                 A5B29B8Q.BS00041Q *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 * Target Table:    Join - work.W131JIOPG                 A5B29B8Q.BS00041R *
 *==========================================================================*/

proc sql;
   create table work.W131JIOPG as
   select distinct
      Student_term_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      case
         when W13ODVMIT.ETHNIC_GROUP ='3'
            then '1'
      else '3'
      end
      /*
      case
         when W13ODVMIT.ETHNIC_GROUP ^= ' '
            then W13ODVMIT.ETHNIC_GROUP
      else '7'
      end
      */ as ETHNIC_GRP length = 1
         label = 'ETHNIC_GRP',
      case
         when W13ODVMIT.ETHNIC_GROUP = '1'
            then '1'
      else ' '
      end

      /*
      case
         when W13ODVMIT.ETHNIC_GROUP = '1'  | W13ODVMIT.ETHNIC_GROUP = '3'
            then '1'
      else ' '
      end
      */ as RACE_WHITE length = 1
         label = 'RACE_WHITE',
      case
         when W13ODVMIT.ETHNIC_GROUP = '2'
            then '2'
      else ' '
      end as RACE_BLACK length = 1
         label = 'RACE_BLACK',
      case
         when W13ODVMIT.ETHNIC_GROUP = '4'
            then '4'
      else ' '
      end as RACE_ASIAN length = 1
         label = 'RACE_ASIAN',
      case
         when W13ODVMIT.ETHNIC_GROUP = '5'
            then '5'
      else ' '
      end as RACE_AmIndAlsknNatv length = 1
         label = 'RACE_AmIndAlsknNatv',
      case
         when W13ODVMIT.ETHNIC_GROUP = '7'
            then '7'
      when W13ODVMIT.ETHNIC_GROUP not in ('1','2','3','4','5','7','8') then '7'
      else ' '
      end as RACE_UnknwnNotRptd length = 1
         label = 'RACE_UnknwnNotRptd',
      case
         when W13ODVMIT.ETHNIC_GROUP = '8'
            then '8'
      else ' '
      end as RACE_NatHawnOPI length = 1
         label = 'RACE_NatHawnOPI'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as Student_term_info left join
      ADWSTGPR.PS_HCR_DIV_ETHNIC_I_Extract as PS_HCR_DIV_ETHNIC_I_Extract
         on
         (
            Student_term_info.EMPLID = PS_HCR_DIV_ETHNIC_I_Extract.EMPLID
         ) left join
      work.W13ODVMIT as W13ODVMIT
         on
         (
            PS_HCR_DIV_ETHNIC_I_Extract.ETHNIC_GRP_CD = W13ODVMIT.ETHNIC_GRP_CD
         )
   ;
quit;

/*==========================================================================*
 * Step:            group ethnic group                    A5B29B8Q.BZ000BO1 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W131JIOPG                 A5B29B8Q.BS00041R *
 * Target Table:    Join - work.W13MPJAUK                 A5B29B8Q.BS00041S *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W131JIOPG);


proc sql;
   create table work.W13MPJAUK as
   select
      W131JIOPG.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      min(W131JIOPG.ETHNIC_GRP ) as ETHNIC_GRP length = 1
         label = 'ETHNIC_GRP',
      max(W131JIOPG.RACE_WHITE) as RACE_WHITE length = 1
         label = 'RACE_WHITE',
      max(W131JIOPG.RACE_BLACK) as RACE_BLACK length = 1
         label = 'RACE_BLACK',
      max(W131JIOPG.RACE_ASIAN) as RACE_ASIAN length = 1
         label = 'RACE_ASIAN',
      max(W131JIOPG.RACE_AmIndAlsknNatv) as RACE_AmIndAlsknNatv length = 1
         label = 'RACE_AmIndAlsknNatv',
      max(W131JIOPG.RACE_UnknwnNotRptd) as RACE_UnknwnNotRptd length = 1
         label = 'RACE_UnknwnNotRptd',
      max(W131JIOPG.RACE_NatHawnOPI) as RACE_NatHawnOPI length = 1
         label = 'RACE_NatHawnOPI'
   from
      work.W131JIOPG as W131JIOPG
   where
      (W131JIOPG.RACE_WHITE IS NOT NULL
      or W131JIOPG.ETHNIC_GRP IS NOT NULL
      or W131JIOPG.RACE_BLACK IS NOT NULL
      or W131JIOPG.RACE_ASIAN IS NOT NULL
      or W131JIOPG.RACE_AmIndAlsknNatv IS NOT NULL
      or W131JIOPG.RACE_UnknwnNotRptd IS NOT NULL
      or W131JIOPG.RACE_NatHawnOPI IS NOT NULL )
   group by
      W131JIOPG.EMPLID
   ;
quit;

/****************************************************************************
 * Job:             TRANCOL                               A5B29B8Q.BT0000QT *
 * Description:                                                             *
 *                                                                          *
 * Metadata Server: sasmetapaws8.ua.uta.edu                                 *
 * Port:            8561                                                    *
 * Location:        /UTA/ADW/400 Reports/CBM/Jobs/CBM1 CBME1 Sub Jobs       *
 *                                                                          *
 * Server:          SASApp                                A5B29B8Q.AS000002 *
 *                                                                          *
 * Source Tables:   ADW_EXT_ORG_DIM -                     A5B29B8Q.BE0000RS *
 *                   ADWTGTPR.ADW_EXT_ORG_DIM                               *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  PS_SRVC_IND_DATA_Extract -            A5B29B8Q.BE00000Q *
 *                   ADWSTGPR.PS_SRVC_IND_DATA_Extract                      *
 *                  ADW_ACAD_PLAN_DIM -                   A5B29B8Q.BE0000RF *
 *                   ADWTGTPR.ADW_ACAD_PLAN_DIM                             *
 *                  ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K *
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     *
 *                  PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U *
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_EXT_ORG_TBL_ADM_Extract -          A5B29B8Q.BE00003K *
 *                   ADWSTGPR.PS_EXT_ORG_TBL_ADM_Extract                    *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 *                  PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U *
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      *
 *                  PS_ADM_APPL_RCR_CA_Extract -          A5B29B8Q.BE00000V *
 *                   ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract                    *
 *                  ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_STUDENT_CLASS_ENRL_FACT -         A5B29B8Q.BE0000MN *
 *                   ADWTGTPR.ADW_STUDENT_CLASS_ENRL_FACT                   *
 *                  ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_ACAD_PLAN_DIM -                   A5B29B8Q.BE0000RF *
 *                   ADWTGTPR.ADW_ACAD_PLAN_DIM                             *
 *                  PS_SRVC_IND_DATA_Extract -            A5B29B8Q.BE00000Q *
 *                   ADWSTGPR.PS_SRVC_IND_DATA_Extract                      *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  PS_UTA_HEH_PLAN_TB_Extract -          A5B29B8Q.BE0001LC *
 *                   ADWSTGPR.PS_UTA_HEH_PLAN_TB_Extract                    *
 * Target Table:    TRANCOL - ADWTGTPR.TRANCOL            A5B29B8Q.BE00018N *
 *                                                                          *
 * Generated on:    Thursday, May 7, 2026 1:54:27 PM CDT                    *
 * Generated by:    mynenit                                                 *
 * Version:         SAS Data Integration Studio 4.905                       *
 ****************************************************************************/

%global etls_debug;
%macro etls_setDebug;
   %if %str(&etls_debug) ne 0 %then
      OPTIONS MPRINT%str(;);
%mend;
%etls_setDebug;

/*==========================================================================*
 * Step:            Macros                                A5B29B8Q.BZ0005DH *
 * Transform:       User Written                                            *
 * Description:     Uncomment or populate here for manual testing           *
 *                                                                          *
 * Target Table:    User Written - work.W3709902          A5B29B8Q.BS0002B4 *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*/


%let _OUTPUT = work.W3709902;

%let _OUTPUT1_col_count = 0;
%let _OUTPUT1_filetype = WorkTable;

/*---- Start of User Written Code  ----*/

/*
%let term_end_dt ='13AUG2019:00:00:00'dt;
%let term=2195;
%let prev_term=2192;
%let two_year_prev_term=2175;
%let term_sk_filter=373;
*/
/*---- End of User Written Code  ----*/

/*==========================================================================*
 * Step:            Ugrd-Trnsf-1stCollege                 A5B29B8Q.BZ0005DI *
 * Transform:       Join                                                    *
 * Description:     class join                                              *
 *                                                                          *
 * Source Tables:   PS_STDNT_ENRL_Extract -               A5B29B8Q.BE00000E *
 *                   ADWSTGPR.PS_STDNT_ENRL_Extract                         *
 *                  PS_CLASS_TBL_Extract -                A5B29B8Q.BE000009 *
 *                   ADWSTGPR.PS_CLASS_TBL_Extract                          *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K *
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     *
 * Target Table:    Join - work.W2SNYESV                  A5B29B8Q.BS0001KR *
 *==========================================================================*/

proc sql;
   create table work.W2SNYESV as
   select
      PS_STDNT_ENRL_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      case
      when PS_STDNT_CAR_TERM_Extract.ACAD_PROG_PRIMARY = 'UGRD2' then 'UGRD'
      else PS_STDNT_CAR_TERM_Extract.ACAD_PROG_PRIMARY
      end as ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      PS_STDNT_ENRL_Extract.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      PS_STDNT_ENRL_Extract.CRSE_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'CRSE_CAREER',
      PS_STDNT_ENRL_Extract.CRSE_COUNT length = 8
         format = 7.2
         informat = 7.2
         label = 'CRSE_COUNT',
      PS_STDNT_ENRL_Extract.DROP_CLASS_IF_ENRL length = 8
         label = 'DROP_CLASS_IF_ENRL',
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
      PS_STDNT_ENRL_Extract.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      PS_CLASS_TBL_Extract.START_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'START_DT',
      ADW_TERM_DIM.CENSUS_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CENSUS_DT',
      PS_STDNT_CAR_TERM_Extract.ACAD_PROG_PRIMARY length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_PRIMARY'
   from
      ADWSTGPR.PS_STDNT_ENRL_Extract as PS_STDNT_ENRL_Extract inner join
      ADWSTGPR.PS_CLASS_TBL_Extract as PS_CLASS_TBL_Extract
         on
         (
            PS_STDNT_ENRL_Extract.STRM = PS_CLASS_TBL_Extract.STRM
            and PS_STDNT_ENRL_Extract.SESSION_CODE = PS_CLASS_TBL_Extract.SESSION_CODE
            and PS_STDNT_ENRL_Extract.CLASS_NBR = PS_CLASS_TBL_Extract.CLASS_NBR
         ) inner join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            PS_STDNT_ENRL_Extract.ACAD_CAREER = ADW_TERM_DIM.ACAD_CAREER
            and "&prev_term." = ADW_TERM_DIM.STRM
         ) left join
      ADWSTGPR.PS_STDNT_CAR_TERM_Extract as PS_STDNT_CAR_TERM_Extract
         on
         (
            PS_STDNT_ENRL_Extract.STRM = PS_STDNT_CAR_TERM_Extract.STRM
            and PS_STDNT_ENRL_Extract.EMPLID = PS_STDNT_CAR_TERM_Extract.EMPLID
         )
   where
      (PS_STDNT_ENRL_Extract.CRSE_GRADE_OFF <> 'AU'
      or PS_STDNT_ENRL_Extract.GRADING_BASIS_ENRL <> 'AUD')
   ;
quit;

/*==========================================================================*
 * Step:            check prev classes and HEH            A5B29B8Q.BZ0005DJ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_SRVC_IND_DATA_Extract -            A5B29B8Q.BE00000Q *
 *                   ADWSTGPR.PS_SRVC_IND_DATA_Extract                      *
 *                  ADW_ACAD_PLAN_DIM -                   A5B29B8Q.BE0000RF *
 *                   ADWTGTPR.ADW_ACAD_PLAN_DIM                             *
 *                  ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  Join - work.W2SNYESV                  A5B29B8Q.BS0001KR *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 * Target Table:    Join - work.PRE_CLASS_HEH_Test        A5B29B8Q.BS0001KS *
 *==========================================================================*
 *                                                                          *
 * Nothing will be generated for this process because the "Exclude          *
 *  transformation from run" option is selected.                            *
 *                                                                          *
 *                                                                          *
 * Warnings:                                                                *
 * An expression contains missing tokens. Fix the expression.               *
 *==========================================================================*/

/*==========================================================================*
 * Step:            check prev classes and HEH_Test       A5B29B8Q.BZ0005DK *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_ACAD_PLAN_DIM -                   A5B29B8Q.BE0000RF *
 *                   ADWTGTPR.ADW_ACAD_PLAN_DIM                             *
 *                  PS_SRVC_IND_DATA_Extract -            A5B29B8Q.BE00000Q *
 *                   ADWSTGPR.PS_SRVC_IND_DATA_Extract                      *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  Join - work.W2SNYESV                  A5B29B8Q.BS0001KR *
 *                  PS_UTA_HEH_PLAN_TB_Extract -          A5B29B8Q.BE0001LC *
 *                   ADWSTGPR.PS_UTA_HEH_PLAN_TB_Extract                    *
 * Target Table:    Join - work.PRE_CLASS_HEH             A5B29B8Q.BS0001KT *
 *==========================================================================*/

proc sql;
   create table work.PRE_CLASS_HEH as
   select distinct
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK length = 8
         label = 'TERM_SK',
      case when PS_SRVC_IND_DATA_Extract.EMPLID is not null or  PS_SRVC_IND_DATA_Extract.EMPLID is not missing then 1
      else 0
      end as GDR length = 8,
      case when PS_UTA_HEH_PLAN_TB_Extract.ACAD_PLAN is not null or PS_UTA_HEH_PLAN_TB_Extract.ACAD_PLAN is not missing then 1
      else 0
      end as HEH length = 8,
      max(W2SNYESV.CLASS_NBR) as PREV_CLASS length = 8,
      ADW_ACAD_CAREER_DIM.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      ADW_STUDENT_TERM_ENRL_FACT.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      ADW_TERM_DIM.TERM_END_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'TERM_END_DT',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROGRAM'
   from
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT inner join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWTGTPR.ADW_ACAD_PLAN_DIM as ADW_ACAD_PLAN_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.MAJOR_ACAD_PLAN_SK = ADW_ACAD_PLAN_DIM.ACAD_PLAN_SK
            and ADW_TERM_DIM.INSTITUTION = ADW_ACAD_PLAN_DIM.INSTITUTION
         ) left join
      ADWSTGPR.PS_SRVC_IND_DATA_Extract as PS_SRVC_IND_DATA_Extract
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.EMPLID = PS_SRVC_IND_DATA_Extract.EMPLID
            and PS_SRVC_IND_DATA_Extract.SRVC_IND_CD = 'GDR'
            and PS_SRVC_IND_DATA_Extract.SRVC_IND_ACT_TERM = ADW_TERM_DIM.STRM
         ) left join
      ADWSTGPR.PS_UTA_HEH_PLAN_TB_Extract as PS_UTA_HEH_PLAN_TB_Extract
         on
         (
            ADW_ACAD_PLAN_DIM.ACAD_PLAN = PS_UTA_HEH_PLAN_TB_Extract.ACAD_PLAN
            and PS_UTA_HEH_PLAN_TB_Extract.ACAD_CAREER = ADW_ACAD_CAREER_DIM.ACAD_CAREER
         ) left join
      ADWTGTPR.ADW_ACAD_PROGRAM_DIM as ADW_ACAD_PROGRAM_DIM
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY = ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM_SK
         ) left join
      work.W2SNYESV as W2SNYESV
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.EMPLID = W2SNYESV.EMPLID
            and ADW_ACAD_CAREER_DIM.ACAD_CAREER = W2SNYESV.ACAD_CAREER
            and case
                  when ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM = 'UGRD2' then 'UGRD'
                  else ADW_ACAD_PROGRAM_DIM.ACAD_PROGRAM
                  end = W2SNYESV.ACAD_PROG
            and ADW_TERM_DIM.STRM > W2SNYESV.STRM
            and W2SNYESV.STDNT_ENRL_STATUS = 'E'
            and (W2SNYESV.ENRL_ACTN_RSN_LAST <> 'CENS'
            or W2SNYESV.ENRL_ACTN_RSN_LAST IS NULL )
            and W2SNYESV.START_DT <= W2SNYESV.CENSUS_DT
         )
   group by
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID,
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK
   ;
quit;

/*==========================================================================*
 * Step:            max(effdt) adm_appl_prog              A5B29B8Q.BZ0005DL *
 * Transform:       Join                                                    *
 * Description:     GRAD                                                    *
 *                                                                          *
 * Source Table:    PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 * Target Table:    Join - work.W2SNYLJJ                  A5B29B8Q.BS0001KU *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_ADM_APPL_PROG_Extract);


proc sql;
   create table work.W2SNYLJJ as
   select
      PS_ADM_APPL_PROG_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_ADM_APPL_PROG_Extract.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      PS_ADM_APPL_PROG_Extract.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      PS_ADM_APPL_PROG_Extract.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      PS_ADM_APPL_PROG_Extract.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      PS_ADM_APPL_PROG_Extract.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      PS_ADM_APPL_PROG_Extract.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      PS_ADM_APPL_PROG_Extract.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      PS_ADM_APPL_PROG_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ADM_APPL_PROG_Extract.EFFSEQ length = 8
         label = 'EFFSEQ',
      PS_ADM_APPL_PROG_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ADM_APPL_PROG_Extract.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      PS_ADM_APPL_PROG_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_ADM_APPL_PROG_Extract.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      PS_ADM_APPL_PROG_Extract.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      PS_ADM_APPL_PROG_Extract.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      PS_ADM_APPL_PROG_Extract.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      PS_ADM_APPL_PROG_Extract.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      PS_ADM_APPL_PROG_Extract.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      PS_ADM_APPL_PROG_Extract.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      PS_ADM_APPL_PROG_Extract.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      PS_ADM_APPL_PROG_Extract.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      PS_ADM_APPL_PROG_Extract.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      PS_ADM_APPL_PROG_Extract.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      PS_ADM_APPL_PROG_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ADM_APPL_PROG_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_ADM_APPL_PROG_Extract as PS_ADM_APPL_PROG_Extract
   where
      PS_ADM_APPL_PROG_Extract.ACAD_CAREER = 'GRAD'
   group by
      PS_ADM_APPL_PROG_Extract.ACAD_CAREER,
      PS_ADM_APPL_PROG_Extract.EMPLID,
      PS_ADM_APPL_PROG_Extract.PROG_STATUS,
      PS_ADM_APPL_PROG_Extract.ACAD_PROG
   having
      PS_ADM_APPL_PROG_Extract.EFFDT = max(PS_ADM_APPL_PROG_Extract.EFFDT)
      and PS_ADM_APPL_PROG_Extract.PROG_STATUS = 'AC'
   ;
quit;

/*==========================================================================*
 * Step:            ADM_APPL_PROG MAX ADMIT_TERM          A5B29B8Q.BZ0005DM *
 * Transform:       Join                                                    *
 * Description:     for eap check in trancol                                *
 *                                                                          *
 * Source Table:    PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 * Target Table:    Join - work.W2SNYJUV                  A5B29B8Q.BS0001KV *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_ADM_APPL_PROG_Extract);


proc sql;
   create table work.W2SNYJUV as
   select
      PS_ADM_APPL_PROG_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_ADM_APPL_PROG_Extract.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      PS_ADM_APPL_PROG_Extract.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      PS_ADM_APPL_PROG_Extract.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      PS_ADM_APPL_PROG_Extract.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      PS_ADM_APPL_PROG_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ADM_APPL_PROG_Extract.EFFSEQ length = 8
         label = 'EFFSEQ',
      PS_ADM_APPL_PROG_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ADM_APPL_PROG_Extract.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      PS_ADM_APPL_PROG_Extract.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      PS_ADM_APPL_PROG_Extract.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      PS_ADM_APPL_PROG_Extract.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      PS_ADM_APPL_PROG_Extract.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      PS_ADM_APPL_PROG_Extract.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR'
   from
      ADWSTGPR.PS_ADM_APPL_PROG_Extract as PS_ADM_APPL_PROG_Extract
   group by
      PS_ADM_APPL_PROG_Extract.EMPLID
   having
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM = max(PS_ADM_APPL_PROG_Extract.ADMIT_TERM)
   ;
quit;

/*==========================================================================*
 * Step:            ADM_APPL_PROG MAX EFFDT               A5B29B8Q.BZ0005DN *
 * Transform:       Join                                                    *
 * Description:     for eap check in trancol                                *
 *                                                                          *
 * Source Table:    Join - work.W2SNYJUV                  A5B29B8Q.BS0001KV *
 * Target Table:    Join - work.W2SNYKP6                  A5B29B8Q.BS0001KW *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W2SNYJUV);


proc sql;
   create table work.W2SNYKP6 as
   select
      W2SNYJUV.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W2SNYJUV.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      W2SNYJUV.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      W2SNYJUV.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      W2SNYJUV.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W2SNYJUV.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      W2SNYJUV.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W2SNYJUV.EFFSEQ length = 8
         label = 'EFFSEQ',
      W2SNYJUV.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W2SNYJUV.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      W2SNYJUV.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      W2SNYJUV.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      W2SNYJUV.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      W2SNYJUV.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W2SNYJUV.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR'
   from
      work.W2SNYJUV as W2SNYJUV
   where
      W2SNYJUV.EFFDT <= datetime()
   group by
      W2SNYJUV.EMPLID,
      W2SNYJUV.ADMIT_TERM
   having
      W2SNYJUV.EFFDT = max(W2SNYJUV.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            ADM_APPL_PROG MAX effseq              A5B29B8Q.BZ0005DO *
 * Transform:       Join                                                    *
 * Description:     for eap check in trancol                                *
 *                                                                          *
 * Source Table:    Join - work.W2SNYKP6                  A5B29B8Q.BS0001KW *
 * Target Table:    Join - work.W2SNYO2L                  A5B29B8Q.BS0001KX *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W2SNYKP6);


proc sql;
   create table work.W2SNYO2L as
   select
      W2SNYKP6.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W2SNYKP6.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      W2SNYKP6.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      W2SNYKP6.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      W2SNYKP6.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W2SNYKP6.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      W2SNYKP6.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W2SNYKP6.EFFSEQ length = 8
         label = 'EFFSEQ',
      W2SNYKP6.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W2SNYKP6.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      W2SNYKP6.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      W2SNYKP6.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      W2SNYKP6.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      W2SNYKP6.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W2SNYKP6.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR'
   from
      work.W2SNYKP6 as W2SNYKP6
   group by
      W2SNYKP6.EMPLID,
      W2SNYKP6.EFFDT
   having
      W2SNYKP6.EFFSEQ = max(W2SNYKP6.EFFSEQ)
   ;
quit;

/*==========================================================================*
 * Step:            max(effterm) adm_appl_prog            A5B29B8Q.BZ0005DP *
 * Transform:       Join                                                    *
 * Description:     UGRD                                                    *
 *                                                                          *
 * Source Table:    PS_ADM_APPL_PROG_Extract -            A5B29B8Q.BE00000T *
 *                   ADWSTGPR.PS_ADM_APPL_PROG_Extract                      *
 * Target Table:    Join - work.W2SNYN86                  A5B29B8Q.BS0001KY *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_ADM_APPL_PROG_Extract);


proc sql;
   create table work.W2SNYN86 as
   select
      PS_ADM_APPL_PROG_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_ADM_APPL_PROG_Extract.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      PS_ADM_APPL_PROG_Extract.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      PS_ADM_APPL_PROG_Extract.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      PS_ADM_APPL_PROG_Extract.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      PS_ADM_APPL_PROG_Extract.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      PS_ADM_APPL_PROG_Extract.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      PS_ADM_APPL_PROG_Extract.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      PS_ADM_APPL_PROG_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_ADM_APPL_PROG_Extract.EFFSEQ length = 8
         label = 'EFFSEQ',
      PS_ADM_APPL_PROG_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ADM_APPL_PROG_Extract.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      PS_ADM_APPL_PROG_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_ADM_APPL_PROG_Extract.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      PS_ADM_APPL_PROG_Extract.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      PS_ADM_APPL_PROG_Extract.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      PS_ADM_APPL_PROG_Extract.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      PS_ADM_APPL_PROG_Extract.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      PS_ADM_APPL_PROG_Extract.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      PS_ADM_APPL_PROG_Extract.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      PS_ADM_APPL_PROG_Extract.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      PS_ADM_APPL_PROG_Extract.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      PS_ADM_APPL_PROG_Extract.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      PS_ADM_APPL_PROG_Extract.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      PS_ADM_APPL_PROG_Extract.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      PS_ADM_APPL_PROG_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ADM_APPL_PROG_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_ADM_APPL_PROG_Extract as PS_ADM_APPL_PROG_Extract
   where
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM <= "&term."
      and PS_ADM_APPL_PROG_Extract.ACAD_CAREER = 'UGRD'
   group by
      PS_ADM_APPL_PROG_Extract.ACAD_CAREER,
      PS_ADM_APPL_PROG_Extract.EMPLID,
      PS_ADM_APPL_PROG_Extract.PROG_STATUS
   having
      PS_ADM_APPL_PROG_Extract.ADMIT_TERM = max(PS_ADM_APPL_PROG_Extract.ADMIT_TERM)
      and PS_ADM_APPL_PROG_Extract.PROG_STATUS = 'AC'
   ;
quit;

/*==========================================================================*
 * Step:            CHECK FOR EAP                         A5B29B8Q.BZ0005DQ *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W2SNYO2L                  A5B29B8Q.BS0001KX *
 *                  PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U *
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      *
 *                  PS_ADM_APPL_RCR_CA_Extract -          A5B29B8Q.BE00000V *
 *                   ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract                    *
 * Target Table:    Join - work.EAP                       A5B29B8Q.BS0001KZ *
 *==========================================================================*/

proc sql;
   create view work.EAP as
   select distinct
      W2SNYO2L.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W2SNYO2L.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      W2SNYO2L.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      W2SNYO2L.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      W2SNYO2L.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W2SNYO2L.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      W2SNYO2L.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W2SNYO2L.EFFSEQ length = 8
         label = 'EFFSEQ',
      W2SNYO2L.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W2SNYO2L.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      W2SNYO2L.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      W2SNYO2L.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      W2SNYO2L.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      W2SNYO2L.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W2SNYO2L.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      B.ADMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      D.RECRUITMENT_CAT length = 4
         format = $4.
         informat = $4.
         label = 'RECRUITMENT_CAT'
   from
      work.W2SNYO2L as W2SNYO2L inner join
      ADWSTGPR.PS_ADM_APPL_DATA_Extract as B
         on
         (
            W2SNYO2L.ACAD_CAREER = B.ACAD_CAREER
            and W2SNYO2L.EMPLID = B.EMPLID
            and W2SNYO2L.STDNT_CAR_NBR = B.STDNT_CAR_NBR
            and W2SNYO2L.ADM_APPL_NBR = B.ADM_APPL_NBR
         ) inner join
      ADWSTGPR.PS_ADM_APPL_RCR_CA_Extract as D
         on
         (
            W2SNYO2L.ACAD_CAREER = D.ACAD_CAREER
            and W2SNYO2L.EMPLID = D.EMPLID
            and W2SNYO2L.STDNT_CAR_NBR = D.STDNT_CAR_NBR
            and W2SNYO2L.ADM_APPL_NBR = D.ADM_APPL_NBR
         )
   having
      W2SNYO2L.ACAD_CAREER = 'UGRD'
      and B.ADMIT_TYPE IN ('1','5')
      and W2SNYO2L.ACAD_PROG = 'UGNDS'
      and D.RECRUITMENT_CAT = 'AUEA'
   ;
quit;

/*==========================================================================*
 * Step:            Combine GRAD and UGRD appl search     A5B29B8Q.BZ0005DR *
 * Transform:       Set Operators                                           *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W2SNYLJJ                  A5B29B8Q.BS0001KU *
 *                  Join - work.W2SNYN86                  A5B29B8Q.BS0001KY *
 * Target Table:    Set Operators - work.W2SNYFN7         A5B29B8Q.BS0001L0 *
 *==========================================================================*/

proc sql;
   create table work.W2SNYFN7 as
   /* Returns all unique rows from the two query results.  */
   select
      W2SNYLJJ.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W2SNYLJJ.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      W2SNYLJJ.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      W2SNYLJJ.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      W2SNYLJJ.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      W2SNYLJJ.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      W2SNYLJJ.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W2SNYLJJ.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      W2SNYLJJ.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      W2SNYLJJ.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W2SNYLJJ.EFFSEQ length = 8
         label = 'EFFSEQ',
      W2SNYLJJ.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W2SNYLJJ.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      W2SNYLJJ.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      W2SNYLJJ.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      W2SNYLJJ.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      W2SNYLJJ.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      W2SNYLJJ.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      W2SNYLJJ.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W2SNYLJJ.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      W2SNYLJJ.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      W2SNYLJJ.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      W2SNYLJJ.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      W2SNYLJJ.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      W2SNYLJJ.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      W2SNYLJJ.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      W2SNYLJJ.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      W2SNYLJJ.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      W2SNYLJJ.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      W2SNYLJJ.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      W2SNYLJJ.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      work.W2SNYLJJ as W2SNYLJJ
   union all
   select
      W2SNYN86.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      W2SNYN86.ACAD_LOAD_APPR length = 1
         format = $1.
         informat = $1.
         label = 'ACAD_LOAD_APPR',
      W2SNYN86.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG',
      W2SNYN86.ACAD_PROG_DUAL length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG_DUAL',
      W2SNYN86.ACTION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ACTION_DT',
      W2SNYN86.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      W2SNYN86.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      W2SNYN86.APPL_PROG_NBR length = 8
         label = 'APPL_PROG_NBR',
      W2SNYN86.CAMPUS length = 5
         format = $5.
         informat = $5.
         label = 'CAMPUS',
      W2SNYN86.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W2SNYN86.EFFSEQ length = 8
         label = 'EFFSEQ',
      W2SNYN86.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W2SNYN86.EXP_GRAD_TERM length = 4
         format = $4.
         informat = $4.
         label = 'EXP_GRAD_TERM',
      W2SNYN86.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      W2SNYN86.JOINT_PROG_APPR length = 1
         format = $1.
         informat = $1.
         label = 'JOINT_PROG_APPR',
      W2SNYN86.PROG_ACTION length = 4
         format = $4.
         informat = $4.
         label = 'PROG_ACTION',
      W2SNYN86.PROG_REASON length = 4
         format = $4.
         informat = $4.
         label = 'PROG_REASON',
      W2SNYN86.PROG_STATUS length = 4
         format = $4.
         informat = $4.
         label = 'PROG_STATUS',
      W2SNYN86.REQ_TERM length = 4
         format = $4.
         informat = $4.
         label = 'REQ_TERM',
      W2SNYN86.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      W2SNYN86.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      W2SNYN86.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      W2SNYN86.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      W2SNYN86.SSR_APT_INSTANCE length = 8
         label = 'SSR_APT_INSTANCE',
      W2SNYN86.SSR_COHORT_ID length = 12
         format = $12.
         informat = $12.
         label = 'SSR_COHORT_ID',
      W2SNYN86.SSR_RS_CANDIT_NBR length = 12
         format = $12.
         informat = $12.
         label = 'SSR_RS_CANDIT_NBR',
      W2SNYN86.SSR_SHIFT length = 12
         format = $12.
         informat = $12.
         label = 'SSR_SHIFT',
      W2SNYN86.SSR_YR_OF_PROG length = 4
         format = $4.
         informat = $4.
         label = 'SSR_YR_OF_PROG',
      W2SNYN86.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      W2SNYN86.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      W2SNYN86.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      work.W2SNYN86 as W2SNYN86
   ;
quit;

/*==========================================================================*
 * Step:            Join on appl_nbr                      A5B29B8Q.BZ0005DS *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   PS_ADM_APPL_DATA_Extract -            A5B29B8Q.BE00000U *
 *                   ADWSTGPR.PS_ADM_APPL_DATA_Extract                      *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  Set Operators - work.W2SNYFN7         A5B29B8Q.BS0001L0 *
 * Target Table:    Join - work.APPLN_INFO                A5B29B8Q.BS0001L1 *
 *==========================================================================*/

proc sql;
   create table work.APPLN_INFO as
   select
      PS_ADM_APPL_DATA_Extract.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      PS_ADM_APPL_DATA_Extract.ACADEMIC_LEVEL length = 3
         format = $3.
         informat = $3.
         label = 'ACADEMIC_LEVEL',
      PS_ADM_APPL_DATA_Extract.ADM_APPL_CMPLT_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_APPL_CMPLT_DT',
      PS_ADM_APPL_DATA_Extract.ADM_APPL_COMPLETE length = 1
         format = $1.
         informat = $1.
         label = 'ADM_APPL_COMPLETE',
      PS_ADM_APPL_DATA_Extract.ADM_APPL_CTR length = 4
         format = $4.
         informat = $4.
         label = 'ADM_APPL_CTR',
      PS_ADM_APPL_DATA_Extract.ADM_APPL_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_APPL_DT',
      PS_ADM_APPL_DATA_Extract.ADM_APPL_METHOD length = 3
         format = $3.
         informat = $3.
         label = 'ADM_APPL_METHOD',
      PS_ADM_APPL_DATA_Extract.ADM_APPL_NBR length = 8
         format = $8.
         informat = $8.
         label = 'ADM_APPL_NBR',
      PS_ADM_APPL_DATA_Extract.ADM_CREATION_BY length = 30
         format = $30.
         informat = $30.
         label = 'ADM_CREATION_BY',
      PS_ADM_APPL_DATA_Extract.ADM_CREATION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_CREATION_DT',
      PS_ADM_APPL_DATA_Extract.ADM_UPDATED_BY length = 30
         format = $30.
         informat = $30.
         label = 'ADM_UPDATED_BY',
      PS_ADM_APPL_DATA_Extract.ADM_UPDATED_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_UPDATED_DT',
      PS_ADM_APPL_DATA_Extract.ADMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      PS_ADM_APPL_DATA_Extract.APP_FEE_CALC_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'APP_FEE_CALC_DTTM',
      PS_ADM_APPL_DATA_Extract.APP_FEE_STATUS length = 1
         format = $1.
         informat = $1.
         label = 'APP_FEE_STATUS',
      PS_ADM_APPL_DATA_Extract.APPL_FEE_AMT length = 8
         format = 19.2
         informat = 19.2
         label = 'APPL_FEE_AMT',
      PS_ADM_APPL_DATA_Extract.APPL_FEE_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'APPL_FEE_DT',
      PS_ADM_APPL_DATA_Extract.APPL_FEE_PAID length = 8
         format = 19.2
         informat = 19.2
         label = 'APPL_FEE_PAID',
      PS_ADM_APPL_DATA_Extract.APPL_FEE_STATUS length = 3
         format = $3.
         informat = $3.
         label = 'APPL_FEE_STATUS',
      PS_ADM_APPL_DATA_Extract.APPL_FEE_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'APPL_FEE_TYPE',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_AUTHCD length = 6
         format = $6.
         informat = $6.
         label = 'CREDIT_CARD_AUTHCD',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_DECLND length = 1
         format = $1.
         informat = $1.
         label = 'CREDIT_CARD_DECLND',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_ERRMSG length = 30
         format = $30.
         informat = $30.
         label = 'CREDIT_CARD_ERRMSG',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_EXP_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'CREDIT_CARD_EXP_DT',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_HOLDER length = 30
         format = $30.
         informat = $30.
         label = 'CREDIT_CARD_HOLDER',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_ISSUER length = 20
         format = $20.
         informat = $20.
         label = 'CREDIT_CARD_ISSUER',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_NBR length = 44
         format = $44.
         informat = $44.
         label = 'CREDIT_CARD_NBR',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_STATUS length = 2
         format = $2.
         informat = $2.
         label = 'CREDIT_CARD_STATUS',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_TYPE length = 2
         format = $2.
         informat = $2.
         label = 'CREDIT_CARD_TYPE',
      PS_ADM_APPL_DATA_Extract.CREDIT_CARD_VDAUTH length = 6
         format = $6.
         informat = $6.
         label = 'CREDIT_CARD_VDAUTH',
      PS_ADM_APPL_DATA_Extract.CUR_RT_TYPE length = 5
         format = $5.
         informat = $5.
         label = 'CUR_RT_TYPE',
      PS_ADM_APPL_DATA_Extract.CURRENCY_CD length = 3
         format = $3.
         informat = $3.
         label = 'CURRENCY_CD',
      PS_ADM_APPL_DATA_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_ADM_APPL_DATA_Extract.EXT_ADM_APPL_NBR length = 15
         format = $15.
         informat = $15.
         label = 'EXT_ADM_APPL_NBR',
      PS_ADM_APPL_DATA_Extract.FIN_AID_INTEREST length = 1
         format = $1.
         informat = $1.
         label = 'FIN_AID_INTEREST',
      PS_ADM_APPL_DATA_Extract.GRADUATION_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'GRADUATION_DT',
      PS_ADM_APPL_DATA_Extract.HOUSING_INTEREST length = 1
         format = $1.
         informat = $1.
         label = 'HOUSING_INTEREST',
      PS_ADM_APPL_DATA_Extract.INSTITUTION length = 5
         format = $5.
         informat = $5.
         label = 'INSTITUTION',
      PS_ADM_APPL_DATA_Extract.LAST_SCH_ATTEND length = 11
         format = $11.
         informat = $11.
         label = 'LAST_SCH_ATTEND',
      PS_ADM_APPL_DATA_Extract.NOTIFICATION_PLAN length = 4
         format = $4.
         informat = $4.
         label = 'NOTIFICATION_PLAN',
      PS_ADM_APPL_DATA_Extract.ORIGNL_APPL_FEE_PD length = 8
         format = 19.2
         informat = 19.2
         label = 'ORIGNL_APPL_FEE_PD',
      PS_ADM_APPL_DATA_Extract.ORIGNL_CURRENCY_CD length = 3
         format = $3.
         informat = $3.
         label = 'ORIGNL_CURRENCY_CD',
      PS_ADM_APPL_DATA_Extract.OVERRIDE_DEPOSIT length = 1
         format = $1.
         informat = $1.
         label = 'OVERRIDE_DEPOSIT',
      PS_ADM_APPL_DATA_Extract.PRIOR_APPL length = 1
         format = $1.
         informat = $1.
         label = 'PRIOR_APPL',
      PS_ADM_APPL_DATA_Extract.RATE_DIV length = 8
         format = 18.8
         informat = 18.8
         label = 'RATE_DIV',
      PS_ADM_APPL_DATA_Extract.RATE_MULT length = 8
         format = 18.8
         informat = 18.8
         label = 'RATE_MULT',
      PS_ADM_APPL_DATA_Extract.RECRUITER_ID length = 11
         format = $11.
         informat = $11.
         label = 'RECRUITER_ID',
      PS_ADM_APPL_DATA_Extract.REGION length = 10
         format = $10.
         informat = $10.
         label = 'REGION',
      PS_ADM_APPL_DATA_Extract.REGION_FROM length = 1
         format = $1.
         informat = $1.
         label = 'REGION_FROM',
      PS_ADM_APPL_DATA_Extract.SAD_CONVICTION length = 1
         format = $1.
         informat = $1.
         label = 'SAD_CONVICTION',
      PS_ADM_APPL_DATA_Extract.SAD_ELEC_SIGN length = 1
         format = $1.
         informat = $1.
         label = 'SAD_ELEC_SIGN',
      PS_ADM_APPL_DATA_Extract.SAD_ERLY_GRAD length = 1
         format = $1.
         informat = $1.
         label = 'SAD_ERLY_GRAD',
      PS_ADM_APPL_DATA_Extract.SAD_NOTIN_SCH length = 1
         format = $1.
         informat = $1.
         label = 'SAD_NOTIN_SCH',
      PS_ADM_APPL_DATA_Extract.SAD_PREV_ATD length = 1
         format = $1.
         informat = $1.
         label = 'SAD_PREV_ATD',
      PS_ADM_APPL_DATA_Extract.SAD_PREV_EDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SAD_PREV_EDT',
      PS_ADM_APPL_DATA_Extract.SAD_PREV_FDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'SAD_PREV_FDT',
      PS_ADM_APPL_DATA_Extract.SAD_WAIVER_BASIS length = 6
         format = $6.
         informat = $6.
         label = 'SAD_WAIVER_BASIS',
      PS_ADM_APPL_DATA_Extract.SCC_ROW_ADD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_ADD_DTTM',
      PS_ADM_APPL_DATA_Extract.SCC_ROW_ADD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_ADD_OPRID',
      PS_ADM_APPL_DATA_Extract.SCC_ROW_UPD_DTTM length = 8
         format = DATETIME27.6
         informat = DATETIME27.6
         label = 'SCC_ROW_UPD_DTTM',
      PS_ADM_APPL_DATA_Extract.SCC_ROW_UPD_OPRID length = 30
         format = $30.
         informat = $30.
         label = 'SCC_ROW_UPD_OPRID',
      PS_ADM_APPL_DATA_Extract.SSF_GL_SENT_AMT length = 8
         format = 21.3
         informat = 21.3
         label = 'SSF_GL_SENT_AMT',
      PS_ADM_APPL_DATA_Extract.SSF_IHC_PB length = 1
         format = $1.
         informat = $1.
         label = 'SSF_IHC_PB',
      PS_ADM_APPL_DATA_Extract.STDNT_CAR_NBR length = 8
         label = 'STDNT_CAR_NBR',
      PS_ADM_APPL_DATA_Extract.TENDER_CATEGORY length = 3
         format = $3.
         informat = $3.
         label = 'TENDER_CATEGORY',
      PS_ADM_APPL_DATA_Extract.WAIVE_AMT length = 8
         format = 19.2
         informat = 19.2
         label = 'WAIVE_AMT',
      PS_ADM_APPL_DATA_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_ADM_APPL_DATA_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID',
      W2SNYFN7.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      ADW_TERM_DIM.TERM_SK length = 8
         label = 'TERM_SK',
      W2SNYFN7.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W2SNYFN7.EFFSEQ length = 8
         label = 'EFFSEQ',
      W2SNYFN7.ACAD_PROG length = 5
         format = $5.
         informat = $5.
         label = 'ACAD_PROG'
   from
      ADWSTGPR.PS_ADM_APPL_DATA_Extract as PS_ADM_APPL_DATA_Extract inner join
      work.W2SNYFN7 as W2SNYFN7
         on
         (
            PS_ADM_APPL_DATA_Extract.ACAD_CAREER = W2SNYFN7.ACAD_CAREER
            and PS_ADM_APPL_DATA_Extract.EMPLID = W2SNYFN7.EMPLID
            and PS_ADM_APPL_DATA_Extract.STDNT_CAR_NBR = W2SNYFN7.STDNT_CAR_NBR
            and PS_ADM_APPL_DATA_Extract.ADM_APPL_NBR = W2SNYFN7.ADM_APPL_NBR
         ) inner join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            W2SNYFN7.ACAD_CAREER = ADW_TERM_DIM.ACAD_CAREER
            and W2SNYFN7.ADMIT_TERM = ADW_TERM_DIM.STRM
         )
   ;
quit;

/*==========================================================================*
 * Step:            true class count                      A5B29B8Q.BZ0005DT *
 * Transform:       Join                                                    *
 * Description:     join to get count                                       *
 *                                                                          *
 * Source Tables:   ADW_STUDENT_TERM_ENRL_FACT -          A5B29B8Q.BE0000S0 *
 *                   ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT                    *
 *                  ADW_STUDENT_CLASS_ENRL_FACT -         A5B29B8Q.BE0000MN *
 *                   ADWTGTPR.ADW_STUDENT_CLASS_ENRL_FACT                   *
 * Target Table:    Join - work.W2SNYMDU                  A5B29B8Q.BS0001L2 *
 *==========================================================================*/

proc sql;
   create view work.W2SNYMDU as
   select
      ADW_STUDENT_TERM_ENRL_FACT.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      ADW_STUDENT_TERM_ENRL_FACT.TERM_SK length = 8
         label = 'TERM_SK',
      ADW_STUDENT_TERM_ENRL_FACT.STUDENT_CAREER_NBR length = 8
         label = 'STUDENT_CAREER_NBR',
      ADW_STUDENT_TERM_ENRL_FACT.MAJOR_DEPT_SK length = 8
         label = 'MAJOR_DEPT_SK',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAL_SK length = 8
         label = 'ACAD_CAL_SK',
      ADW_STUDENT_TERM_ENRL_FACT.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      ADW_STUDENT_TERM_ENRL_FACT.RESIDENCY_SK length = 8
         label = 'RESIDENCY_SK',
      case
         when
      (ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD='E'   &   ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD ='DYN' & ADW_STUDENT_CLASS_ENRL_FACT.START_DT  > ADW_STUDENT_CLASS_ENRL_FACT.CENSUS_DT )
            then 0
      else 1
      end as has_class length = 8,
      case
         when
      (ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD='E'   &   ADW_STUDENT_CLASS_ENRL_FACT.SESSION_CD ='DYN' & ADW_STUDENT_CLASS_ENRL_FACT.START_DT  > ADW_STUDENT_CLASS_ENRL_FACT.CENSUS_DT )
            then 1
      else 0
      end as has_flex length = 8,
      ADW_STUDENT_CLASS_ENRL_FACT.CLASS_NBR length = 8
         label = 'CLASS_NBR',
      ADW_STUDENT_TERM_ENRL_FACT.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      ADW_STUDENT_TERM_ENRL_FACT.COHORT_ENTRY_DB length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY_DB'
   from
      ADWTGTPR.ADW_STUDENT_TERM_ENRL_FACT as ADW_STUDENT_TERM_ENRL_FACT inner join
      ADWTGTPR.ADW_STUDENT_CLASS_ENRL_FACT as ADW_STUDENT_CLASS_ENRL_FACT
         on
         (
            ADW_STUDENT_TERM_ENRL_FACT.EMPLID = ADW_STUDENT_CLASS_ENRL_FACT.EMPLID
            and ADW_STUDENT_TERM_ENRL_FACT.ACAD_CAREER_SK = ADW_STUDENT_CLASS_ENRL_FACT.ACAD_CAREER_SK
            and ADW_STUDENT_TERM_ENRL_FACT.TERM_SK = ADW_STUDENT_CLASS_ENRL_FACT.TERM_SK
            and ADW_STUDENT_TERM_ENRL_FACT.INSTITUTION = ADW_STUDENT_CLASS_ENRL_FACT.INSTITUTION
         )
   where
      ADW_STUDENT_CLASS_ENRL_FACT.STUDENT_ENRL_CD = 'E'
   ;
quit;

/*==========================================================================*
 * Step:            sum of class count                    A5B29B8Q.BZ0005DU *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W2SNYMDU                  A5B29B8Q.BS0001L2 *
 * Target Table:    Join - work.CLASS_COUNT               A5B29B8Q.BS0001L3 *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W2SNYMDU);


proc sql;
   create table work.CLASS_COUNT as
   select distinct
      W2SNYMDU.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W2SNYMDU.ACAD_CAREER_SK length = 8
         label = 'ACAD_CAREER_SK',
      W2SNYMDU.TERM_SK length = 8
         label = 'TERM_SK',
      W2SNYMDU.STUDENT_CAREER_NBR length = 8
         label = 'STUDENT_CAREER_NBR',
      W2SNYMDU.MAJOR_DEPT_SK length = 8
         label = 'MAJOR_DEPT_SK',
      W2SNYMDU.ACAD_CAL_SK length = 8
         label = 'ACAD_CAL_SK',
      W2SNYMDU.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      W2SNYMDU.RESIDENCY_SK length = 8
         label = 'RESIDENCY_SK',
      sum(W2SNYMDU.has_class) as has_class length = 8,
      sum(W2SNYMDU.has_flex) as has_flex length = 8,
      W2SNYMDU.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      W2SNYMDU.COHORT_ENTRY_DB length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY_DB'
   from
      work.W2SNYMDU as W2SNYMDU
   group by
      W2SNYMDU.EMPLID,
      W2SNYMDU.ACAD_CAREER_SK,
      W2SNYMDU.TERM_SK
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005DV *
 * Transform:       Join                                                    *
 * Description:     TRANCOL                                                 *
 *                                                                          *
 * Source Tables:   Join - work.CLASS_COUNT               A5B29B8Q.BS0001L3 *
 *                  Join - work.APPLN_INFO                A5B29B8Q.BS0001L1 *
 *                  ADW_EXT_ORG_DIM -                     A5B29B8Q.BE0000RS *
 *                   ADWTGTPR.ADW_EXT_ORG_DIM                               *
 *                  ADW_ACAD_PROGRAM_DIM -                A5B29B8Q.BE0000RG *
 *                   ADWTGTPR.ADW_ACAD_PROGRAM_DIM                          *
 *                  Join - work.PRE_CLASS_HEH             A5B29B8Q.BS0001KT *
 * Target Table:    Join - work.W2SNYDYJ                  A5B29B8Q.BS0001L4 *
 *==========================================================================*/

proc sql;
   create table work.W2SNYDYJ as
   select distinct
      EXT_ORG_DIM.EXT_ORG_ID length = 11
         format = $11.
         informat = $11.
         label = 'EXT_ORG_ID',
      APPLN_INFO.LAST_SCH_ATTEND length = 11
         format = $11.
         informat = $11.
         label = 'LAST_SCH_ATTEND',
      EXT_ORG_DIM.LS_SCHOOL_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'LS_SCHOOL_TYPE',
      EXT_ORG_DIM.FICE_CD length = 6
         format = $6.
         informat = $6.
         label = 'FICE_CD',
      PRE_CLASS_HEH.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      APPLN_INFO.ADM_APPL_CMPLT_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_APPL_CMPLT_DT',
      PRE_CLASS_HEH.TERM_SK length = 8
         label = 'TERM_SK',
      CLASS_COUNT.has_class length = 8,
      CLASS_COUNT.has_flex length = 8,
      EXT_ORG_DIM.EFF_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFF_DT',
      max(EXT_ORG_DIM.EFF_DT) as max_eff length = 8
         format = DATETIME20.
         informat = DATETIME20.,
      case when PRE_CLASS_HEH.ACAD_CAREER ='GRAD' then case when PRE_CLASS_HEH.GDR =0 then case
      		            when PRE_CLASS_HEH.HEH =1 then
      				case when PRE_CLASS_HEH.PREV_CLASS = . then
       					case when APPLN_INFO.ADMIT_TYPE in ('G1','G4','G6' ) then '000001'
      						when APPLN_INFO.ADMIT_TYPE in ('G2') then case when EXT_ORG_DIM.FICE_CD is missing then '999999' else EXT_ORG_DIM.FICE_CD end
      						else ''
      					end
      				           else ''
      				end
      			else  case when APPLN_INFO.ADMIT_TYPE in ('G1','G4','G6' ) then '000001'
      				 when APPLN_INFO.ADMIT_TYPE in ('G2') then case when EXT_ORG_DIM.FICE_CD is missing then '999999' else EXT_ORG_DIM.FICE_CD end
      				 else ''
      			         end
      		              end
      else '000001'
      end
      else
      case when PRE_CLASS_HEH.PREV_CLASS is missing then case
      						when APPLN_INFO.ADMIT_TYPE in ('1') then '000001'
      						when APPLN_INFO.ADMIT_TYPE in ('2') then case when EXT_ORG_DIM.FICE_CD is missing then '999999' else EXT_ORG_DIM.FICE_CD end

      						else ''

      					              end
      else ''
      end
      end as TRANCOL length = 8,
      APPLN_INFO.ADM_APPL_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_APPL_DT',
      APPLN_INFO.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      APPLN_INFO.EFFSEQ length = 8
         label = 'EFFSEQ',
      APPLN_INFO.ADMIT_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'ADMIT_TYPE',
      APPLN_INFO.TERM_SK as adm_term_sk length = 8,
      PRE_CLASS_HEH.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      APPLN_INFO.ADMIT_TERM length = 4
         format = $4.
         informat = $4.
         label = 'ADMIT_TERM',
      CLASS_COUNT.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      PRE_CLASS_HEH.COHORT_ENTRY length = 50
         format = $50.
         informat = $50.
         label = 'COHORT_ENTRY',
      PRE_CLASS_HEH.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER'
   from
      work.PRE_CLASS_HEH as PRE_CLASS_HEH left join
      work.CLASS_COUNT as CLASS_COUNT
         on
         (
            PRE_CLASS_HEH.EMPLID = CLASS_COUNT.EMPLID
            and PRE_CLASS_HEH.TERM_SK = CLASS_COUNT.TERM_SK
            and PRE_CLASS_HEH.ACAD_CAREER_SK = CLASS_COUNT.ACAD_CAREER_SK
         ) left join
      work.APPLN_INFO as APPLN_INFO
         on
         (
            PRE_CLASS_HEH.EMPLID = APPLN_INFO.EMPLID
            and APPLN_INFO.ACAD_CAREER = PRE_CLASS_HEH.ACAD_CAREER
            and APPLN_INFO.ACAD_PROG = PRE_CLASS_HEH.ACAD_PROGRAM
            and ((APPLN_INFO.ADMIT_TERM = PRE_CLASS_HEH.STRM
            and PRE_CLASS_HEH.ACAD_CAREER = 'GRAD')
            and PRE_CLASS_HEH.HEH = 0
            and PRE_CLASS_HEH.GDR = 0
            or (APPLN_INFO.ADMIT_TERM <= PRE_CLASS_HEH.STRM
            and PRE_CLASS_HEH.HEH = 1
            and PRE_CLASS_HEH.PREV_CLASS IS MISSING
            and PRE_CLASS_HEH.GDR = 0
            and PRE_CLASS_HEH.ACAD_CAREER = 'GRAD')
            or (PRE_CLASS_HEH.ACAD_CAREER = 'UGRD'
            and APPLN_INFO.ADMIT_TERM <= PRE_CLASS_HEH.STRM))
         ) left join
      ADWTGTPR.ADW_EXT_ORG_DIM as EXT_ORG_DIM
         on
         (
            trim(EXT_ORG_DIM.EXT_ORG_ID) = trim(APPLN_INFO.LAST_SCH_ATTEND)
            and EXT_ORG_DIM.CURRENT_ROW_IND = 1
         )
   group by
      PRE_CLASS_HEH.TERM_SK,
      PRE_CLASS_HEH.EMPLID,
      APPLN_INFO.EMPLID,
      APPLN_INFO.ACAD_CAREER
   having
      APPLN_INFO.EFFDT = max(APPLN_INFO.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            max(effseq) for application           A5B29B8Q.BZ0005DW *
 * Transform:       Join                                                    *
 * Description:     and ugnds check (removed)                               *
 *                                                                          *
 * Source Table:    Join - work.W2SNYDYJ                  A5B29B8Q.BS0001L4 *
 * Target Table:    Join - work.W2SNYI67                  A5B29B8Q.BS0001L5 *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W2SNYDYJ);


proc sql;
   create table work.W2SNYI67 as
   select
      W2SNYDYJ.EXT_ORG_ID length = 11
         format = $11.
         informat = $11.
         label = 'EXT_ORG_ID',
      W2SNYDYJ.LAST_SCH_ATTEND length = 11
         format = $11.
         informat = $11.
         label = 'LAST_SCH_ATTEND',
      W2SNYDYJ.LS_SCHOOL_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'LS_SCHOOL_TYPE',
      W2SNYDYJ.FICE_CD length = 6
         format = $6.
         informat = $6.
         label = 'FICE_CD',
      W2SNYDYJ.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      case
      when strip(W2SNYDYJ.ADMIT_TYPE) in ('G2') then W2SNYDYJ.TRANCOL
      when ((W2SNYDYJ.ACAD_PROGRAM_PRIMARY = 5) and strip(W2SNYDYJ.ADMIT_TYPE) ^='2') then ''
      when (W2SNYDYJ.ACAD_PROGRAM_PRIMARY in (1,4)) then ''
      when (W2SNYDYJ.ACAD_PROGRAM_PRIMARY in (7)  and strip(W2SNYDYJ.ADMIT_TYPE) ='1') then ''
      else W2SNYDYJ.TRANCOL
      end

      /* from cbm0e1
      case
      when strip(W2SNYDYJ.ADMIT_TYPE) in ('G2') then W2SNYDYJ.TRANCOL
      when (W2SNYDYJ.ACAD_PROGRAM_PRIMARY = 5)  then ''
      else W2SNYDYJ.TRANCOL
      end
      */
      /* new changes
      case
      when strip(W2SNYDYJ.ADMIT_TYPE) in ('G2') then W2SNYDYJ.TRANCOL
      when ((W2SNYDYJ.ACAD_PROGRAM_PRIMARY = 5) and strip(W2SNYDYJ.ADMIT_TYPE) ^='2') then ''
      when (W2SNYDYJ.ACAD_PROGRAM_PRIMARY =1) then ''
      else W2SNYDYJ.TRANCOL
      end
      */ as TRANCOL length = 6
         format = $6.
         informat = $6.
         label = 'TRANCOL',
      W2SNYDYJ.ADM_APPL_CMPLT_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_APPL_CMPLT_DT',
      W2SNYDYJ.TERM_SK length = 8
         label = 'TERM_SK',
      W2SNYDYJ.has_class length = 8,
      W2SNYDYJ.has_flex length = 8,
      W2SNYDYJ.EFF_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFF_DT',
      W2SNYDYJ.max_eff length = 8
         format = DATETIME20.
         informat = DATETIME20.,
      W2SNYDYJ.ADM_APPL_DT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'ADM_APPL_DT',
      W2SNYDYJ.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      W2SNYDYJ.EFFSEQ length = 8
         label = 'EFFSEQ',
      W2SNYDYJ.ACAD_PROGRAM_PRIMARY length = 8
         label = 'ACAD_PROGRAM_PRIMARY',
      W2SNYDYJ.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      W2SNYDYJ.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER'
   from
      work.W2SNYDYJ as W2SNYDYJ
   group by
      W2SNYDYJ.EMPLID,
      W2SNYDYJ.TERM_SK
   having
      W2SNYDYJ.EFFSEQ = max(W2SNYDYJ.EFFSEQ)
   ;
quit;

/*==========================================================================*
 * Step:            min(trancol) legacy?                  A5B29B8Q.BZ0005DX *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Tables:   Join - work.W2SNYI67                  A5B29B8Q.BS0001L5 *
 *                  Join - work.EAP                       A5B29B8Q.BS0001KZ *
 * Target Table:    Join - work.W2SNYGHJ                  A5B29B8Q.BS0001L6 *
 *==========================================================================*/

proc sql;
   create table work.W2SNYGHJ as
   select
      W2SNYI67.EXT_ORG_ID length = 11
         format = $11.
         informat = $11.
         label = 'EXT_ORG_ID',
      W2SNYI67.LAST_SCH_ATTEND length = 11
         format = $11.
         informat = $11.
         label = 'LAST_SCH_ATTEND',
      W2SNYI67.LS_SCHOOL_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'LS_SCHOOL_TYPE',
      W2SNYI67.FICE_CD length = 6
         format = $6.
         informat = $6.
         label = 'FICE_CD',
      W2SNYI67.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      case when coalesce(EAP.EMPLID ,' ')  = ' ' then W2SNYI67.TRANCOL
      else ' '
      end as TRANCOL length = 6
         format = $6.
         informat = $6.
         label = 'TRANCOL',
      YEAR(datepart(W2SNYI67.EFFDT )) as YEAR length = 8
         label = 'YEAR',
      W2SNYI67.TERM_SK length = 8
         label = 'TERM_SK',
      W2SNYI67.has_class length = 8,
      W2SNYI67.has_flex length = 8,
      W2SNYI67.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      work.W2SNYI67 as W2SNYI67 left join
      work.EAP as EAP
         on
         (
            W2SNYI67.EMPLID = EAP.EMPLID
            and W2SNYI67.ACAD_CAREER = EAP.ACAD_CAREER
         )
   group by
      W2SNYI67.TERM_SK,
      W2SNYI67.EMPLID
   having
      W2SNYI67.TRANCOL = min(W2SNYI67.TRANCOL )
   ;
quit;

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ0005DY *
 * Transform:       Join                                                    *
 * Description:     High School Code                                        *
 *                                                                          *
 * Source Tables:   PS_EXT_ORG_TBL_ADM_Extract -          A5B29B8Q.BE00003K *
 *                   ADWSTGPR.PS_EXT_ORG_TBL_ADM_Extract                    *
 *                  Join - work.W2SNYGHJ                  A5B29B8Q.BS0001L6 *
 * Target Table:    Join - work.W2SNYHBV                  A5B29B8Q.BS0001L7 *
 *==========================================================================*/

proc sql;
   create table work.W2SNYHBV as
   select distinct
      W2SNYGHJ.EXT_ORG_ID length = 11
         format = $11.
         informat = $11.
         label = 'EXT_ORG_ID',
      W2SNYGHJ.LAST_SCH_ATTEND length = 11
         format = $11.
         informat = $11.
         label = 'LAST_SCH_ATTEND',
      W2SNYGHJ.LS_SCHOOL_TYPE length = 3
         format = $3.
         informat = $3.
         label = 'LS_SCHOOL_TYPE',
      W2SNYGHJ.FICE_CD length = 6
         format = $6.
         informat = $6.
         label = 'FICE_CD',
      W2SNYGHJ.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      substr(W2SNYGHJ.TRANCOL,1,6) as TRANCOL length = 6
         format = $6.
         informat = $6.
         label = 'TRANCOL',
      case
         when  W2SNYGHJ.TRANCOL = '000001'  then
      	case when  PS_EXT_ORG_TBL_ADM_Extract.EXT_ORG_ID = '1037781' then '999999'
       	when ((PS_EXT_ORG_TBL_ADM_Extract.ATP_CD  = '888866')  |
      (PS_EXT_ORG_TBL_ADM_Extract.ATP_CD = '888877') |
       (PS_EXT_ORG_TBL_ADM_Extract.ATP_CD = '888899')  |
      (PS_EXT_ORG_TBL_ADM_Extract.ATP_CD = '889988') |
      (PS_EXT_ORG_TBL_ADM_Extract.ATP_CD = '889990') )  then PS_EXT_ORG_TBL_ADM_Extract.ATP_CD
        	when SUBSTR(PS_EXT_ORG_TBL_ADM_Extract.ATP_CD , 1, 2) = '44' then PS_EXT_ORG_TBL_ADM_Extract.ATP_CD
         	when SUBSTR(PS_EXT_ORG_TBL_ADM_Extract.ATP_CD , 1, 2) ^=  '44' then
      		case when ((PS_EXT_ORG_TBL_ADM_Extract.ATP_CD  >= '010000') & (PS_EXT_ORG_TBL_ADM_Extract.ATP_CD <= '559999')) then '888899'
      		else '999999'
      		end
      	end
      else ' '
      end as HS_CODE length = 6
         label = 'HS_CODE',
      W2SNYGHJ.TERM_SK length = 8
         label = 'TERM_SK',
      W2SNYGHJ.has_class length = 8,
      W2SNYGHJ.has_flex length = 8,
      W2SNYGHJ.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM'
   from
      work.W2SNYGHJ as W2SNYGHJ left join
      ADWSTGPR.PS_EXT_ORG_TBL_ADM_Extract as PS_EXT_ORG_TBL_ADM_Extract
         on
         (
            W2SNYGHJ.EXT_ORG_ID = PS_EXT_ORG_TBL_ADM_Extract.EXT_ORG_ID
         )
   group by
      W2SNYGHJ.EMPLID,
      W2SNYGHJ.TERM_SK
   having
      PS_EXT_ORG_TBL_ADM_Extract.EFFDT = max(PS_EXT_ORG_TBL_ADM_Extract.EFFDT )
   ;
quit;

/*==========================================================================*
 * Step:            Table Loader                          A5B29B8Q.BZ0005DZ *
 * Transform:       Table Loader (Version 2.1)                              *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.W2SNYHBV                  A5B29B8Q.BS0001L7 *
 * Target Table:    TRANCOL - ADWTGTPR.TRANCOL            A5B29B8Q.BE00018N *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W2SNYHBV);

/* --------------------------------------------------------------
   Load Technique Selection: Replace - Truncate
   Constraint and index action selections: 'ASIS','ASIS','ASIS','ASIS'
   Additional options selections...
      Set unmapped to missing on updates: false
   -------------------------------------------------------------- */
%macro etls_loader;


   /* Determine if the target table exists  */
         %sysfunc(exist(ADWTGTPR.TRANCOL, VIEW)));

   /*---- Create a new table  ----*/
   %if (&etls_tableExist eq 0) %then
   %do;  /* if table does not exist  */

      %put %str(NOTE: Creating table ...);

      data ADWTGTPR.TRANCOL
              (dbnull = (
                         EXT_ORG_ID = YES
                         LAST_SCH_ATTEND = YES
                         LS_SCHOOL_TYPE = YES
                         FICE_CD = YES
                         EMPLID = NO
                         TRANCOL = YES
                         HS_CODE = YES
                         TERM_SK = NO
                         has_class = YES
                         has_flex = YES
                         STRM = YES));
         attrib EXT_ORG_ID length = $11
            format = $11.
            informat = $11.
            label = 'EXT_ORG_ID';
         attrib LAST_SCH_ATTEND length = $11
            format = $11.
            informat = $11.
            label = 'LAST_SCH_ATTEND';
         attrib LS_SCHOOL_TYPE length = $3
            format = $3.
            informat = $3.
            label = 'LS_SCHOOL_TYPE';
         attrib FICE_CD length = $6
            format = $6.
            informat = $6.
            label = 'FICE_CD';
         attrib EMPLID length = $11
            format = $11.
            informat = $11.
            label = 'EMPLID';
         attrib TRANCOL length = $6
            format = $6.
            informat = $6.
            label = 'TRANCOL';
         attrib HS_CODE length = $6
            label = 'HS_CODE';
         attrib TERM_SK length = 8
            label = 'TERM_SK';
         attrib has_class length = 8;
         attrib has_flex length = 8;
         attrib STRM length = $4
            format = $4.
            informat = $4.
            label = 'STRM';
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
            truncate table ADWTGTPRD.TRANCOL
         ) by ORACLE;

         %rcSet(&sqlrc);

         disconnect from ORACLE;
      quit;


   %end; /* table exists */

   /*---- Append  ----*/
   %put %str(NOTE: Appending data ...);

   proc append base = ADWTGTPR.TRANCOL
      data = &etls_lastTable (&etls_tableOptions)  force ;
    run;


%mend etls_loader;
%etls_loader;

/**  Job end TRANCOL **/

/* Reset jobid and name */

/*==========================================================================*
 * Step:            Join                                  A5B29B8Q.BZ000BO3 *
 * Transform:       Join                                                    *
 * Description:     Combine Fields                                          *
 *                                                                          *
 * Source Tables:   Join - work.WQMGJ1R8                  A5B29B8Q.BS00041K *
 *                  tuition_status_exemption -            A5B29B8Q.BS00041P *
 *                   work.WTG7ZRE1                                          *
 *                  Join - work.WJSE6S1R                  A5B29B8Q.BS00041F *
 *                  Join - work.W13MPJAUK                 A5B29B8Q.BS00041S *
 *                  Join - work.W12707R8L                 A5B29B8Q.BS00041G *
 *                  Join - work.W4E0W3NI                  A5B29B8Q.BS00041I *
 *                  ADW_ACAD_CAREER_DIM -                 A5B29B8Q.BE0000RE *
 *                   ADWTGTPR.ADW_ACAD_CAREER_DIM                           *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  ADW_PERSON_DIM -                      A5B29B8Q.BE0000RV *
 *                   ADWTGTPR.ADW_PERSON_DIM                                *
 *                  PS_PERSON_SA_Extract -                A5B29B8Q.BE00000P *
 *                   ADWSTGPR.PS_PERSON_SA_Extract                          *
 *                  Join - work.W9JYBSOK                  A5B29B8Q.BS00041C *
 *                  CBM1_SCH - ADWTGTPR.CBM1_SCH          A5B29B8Q.BE00018J *
 *                  CBM1_UGLIMIT - ADWTGTPR.CBM1_UGLIMIT  A5B29B8Q.BE00018M *
 *                  TRANCOL - ADWTGTPR.TRANCOL            A5B29B8Q.BE00018N *
 *                  CBM1_UGDEGR - ADWTGTPR.CBM1_UGDEGR    A5B29B8Q.BE00018L *
 *                  CBM1_STUDENT_LIST -                   A5B29B8Q.BE00018K *
 *                   ADWTGTPR.CBM1_STUDENT_LIST                             *
 *                  CBM1_CLASSIFICATION_INFO -            A5B29B8Q.BE00018H *
 *                   ADWTGTPR.CBM1_CLASSIFICATION_INFO                      *
 * Target Table:    Join - work.WIB9I7X0                  A5B29B8Q.BS00041T *
 *==========================================================================*/

proc sql;
   create table work.WIB9I7X0 as
   select distinct
      '1' as RECCODE length = 1
         format = $1.
         informat = $1.
         label = 'RECCODE',
      '003656' as FICE length = 6
         format = $6.
         informat = $6.
         label = 'FICE',
      Student_term_info.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_PERSON_DIM.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      classification_info.CLASS length = 1
         label = 'CLASS',
      catt(year(datepart(ADW_PERSON_DIM.BIRTH_DT)), put(month(datepart(ADW_PERSON_DIM.BIRTH_DT)),z2.),
      put(day(datepart(ADW_PERSON_DIM.BIRTH_DT)),z2.)) as DOB length = 8
         format = $8.
         label = 'DOB',
      WTG7ZRE1.TUITION_STATUS as TUITRES length = 1
         format = $1.
         informat = $1.
         label = 'TUITRES',
      case
         when trim(Student_term_info.FLEX) >'0' then

      coalescec(W12707R8L.COUNTY_CD ,WJSE6S1R.COUNTY_CD )
      else WJSE6S1R.COUNTY_CD
      end as RESID length = 3
         label = 'RESID',
      TRANCOL.TRANCOL as TRANCOL length = 8
         label = 'TRANCOL',
      CBM1_SCH.SCH_ON as SCHON length = 8
         label = 'SCHON',
      CBM1_SCH.SCH_OFF as SCHOFF length = 8
         label = 'SCHOFF',
      W4E0W3NI.UNIT_DOC as DOCFUND length = 8
         label = 'DOCFUND',
      case
         when coalescec(trim(Student_term_info.FLEX),'X') = '6'
            then Student_term_info.TERM_SK +2
      else Student_term_info.TERM_SK
      end as TERM_SK length = 8
         label = 'TERM_SK',
      '0000' as INTERSCH length = 4
         label = 'INTERSCH',
      Student_term_info.TERM_SK as TERM_SK_ORIG length = 8,
      case
         when classification_info.CLASS ='7' & Student_term_info.FLEX > '1'
            then '3'
      else Student_term_info.FLEX
      end as FLEX length = 4
         format = $4.
         informat = $4.
         label = 'FLEX',
      WQMGJ1R8.CAP as REMOTE length = 8
         label = 'REMOTE',
      classification_info.CIP_CD as CIP length = 8
         format = $8.
         informat = $8.
         label = 'CIP',
      W4E0W3NI.DOCFNDCD as DOCFNCD length = 2
         label = 'DOCFNCD',
      WTG7ZRE1.TUITION_EXEMPT as TUITEXT length = 2
         label = 'TUITEXT',
      CBM1_SCH.SCHCNSF length = 8
         label = 'SCHCNSF',
      CBM1_SCH.SCHDNSF length = 8
         label = 'SCHDNSF',
      '0000' as SCHINSF length = 4
         label = 'SCHINSF',
      case
      	when sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0) < 0 then 0
      	when sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0) >0 and CBM1_SCH.GR_SCH >0 then
      		case
      			when sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0) = CBM1_SCH.GR_SCH then 0
      			when sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0) > CBM1_SCH.GR_SCH then
      sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,CBM1_SCH.GR_SCH)
      			else 0
      			end
      else sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0)
      end

      /*
      case
      	when sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0) < 0 then 0
      	when sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0) >0 and W1339X0WI.CBM1_SCH.GR_SCH >0 then
      		case
      			when sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0) = W1339X0WI.CBM1_SCH.GR_SCH then 0
      			when sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0) > W1339X0WI.CBM1_SCH.GR_SCH then
      sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,W1339X0WI.CBM1_SCH.GR_SCH)
      			else 0
      			end
      else sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0)
      end
      */ as SCHCSF length = 8
         label = 'SCHCSF',
      CBM1_SCH.SCHDSF length = 8
         label = 'SCHDSF',
      UGDEGR.UGDEGR length = 8
         label = 'UGDEGR',
      case
      when CBM1_UGLIMIT.UG_LIMIT ='5' then '5'
         when classification_info.CLASS ='1'  | classification_info.CLASS= '2' | classification_info.CLASS ='3'  | classification_info.CLASS ='4'
            then CBM1_UGLIMIT.UG_LIMIT
      else '0'
      end as UGLIMIT length = 8
         label = 'UGLIMIT',
      ADW_PERSON_DIM.LAST_NAME as LAST length = 30
         format = $30.
         informat = $30.
         label = 'LAST',
      ADW_PERSON_DIM.FIRST_NAME as FIRST length = 30
         format = $30.
         informat = $30.
         label = 'FIRST',
      substr(ADW_PERSON_DIM.MIDDLE_NAME,1,1) as MINIT length = 1
         format = $1.
         informat = $1.
         label = 'MINIT',
      CBM1_SCH.SCHDC length = 8
         label = 'SCHDC',
      classification_info.RESTRICTED as TEACHED length = 2
         format = $2.
         informat = $2.
         label = 'TEACHED',
      classification_info.NDS length = 1
         format = $1.
         informat = $1.
         label = 'NDS',
      case
         when PS_PERSON_SA_Extract.FERPA = 'Y'
            then '2'
      else '0'
      end as ND length = 1
         format = $1.
         informat = $1.
         label = 'ND',
      case
      	when sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0) >0 and CBM1_SCH.GR_SCH >0 then
      		case
      			when (sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0) < CBM1_SCH.GR_SCH)
      			and (sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0)  > 0)
      			then sum(CBM1_SCH.SCH_ON ,CBM1_SCH.SCH_OFF ) - sum(CBM1_SCH.SCHCNSF ,CBM1_SCH.SCHDNSF ,CBM1_SCH.SCHDSF  ,0)
      			else CBM1_SCH.GR_SCH
      			end
      	when CBM1_SCH.GR_SCH>0 and CBM1_SCH.SCHCNSF >0 then 0
      else CBM1_SCH.GR_SCH
      end

      /*
      case
      	when sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0) >0 and W1339X0WI.CBM1_SCH.GR_SCH >0 then
      		case
      			when (sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0) < W1339X0WI.CBM1_SCH.GR_SCH)
      			and (sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0)  > 0)
      			then sum(W1339X0WI.CBM1_SCH.SCH_ON ,W1339X0WI.CBM1_SCH.SCH_OFF ) - sum(W1339X0WI.CBM1_SCH.SCHCNSF ,W1339X0WI.CBM1_SCH.SCHDNSF ,W1339X0WI.CBM1_SCH.SCHDSF  ,0)
      			else W1339X0WI.CBM1_SCH.GR_SCH
      			end
      	when W1339X0WI.CBM1_SCH.GR_SCH>0 and W1339X0WI.CBM1_SCH.SCHCNSF >0 then 0
      else W1339X0WI.CBM1_SCH.GR_SCH
      end

      */ as GR_SCH length = 8
         format = 5.
         informat = 5.
         label = 'GR_SCH',
      case
         when ADW_ACAD_CAREER_DIM.ACAD_CAREER = 'GRAD'
            then ' '
      else TRANCOL.HS_CODE
      end as HS_CODE length = 6
         format = $6.
         informat = $6.
         label = 'HS_CODE',
      '         ' as PEIMS_ID length = 9
         format = $9.
         informat = $9.
         label = 'PEIMS_ID',
      W13MPJAUK.ETHNIC_GRP as ETHNIC length = 1
         label = 'ETHNIC',
      W13MPJAUK.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W13MPJAUK.RACE_BLACK length = 1
         format = $1.
         informat = $1.
         label = 'RACE_BLACK',
      W13MPJAUK.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W13MPJAUK.RACE_AmIndAlsknNatv as RACE_NATIVE_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_AMERICAN',
      case when WTG7ZRE1.RESIDENCY = '4' and WTG7ZRE1.TUITION_STATUS ^= 'A' then '6' else ' ' end as RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      case
      when W13MPJAUK.ETHNIC_GRP in ('1','3') & W13MPJAUK.RACE_WHITE =' ' & W13MPJAUK.RACE_BLACK =' ' & W13MPJAUK.RACE_ASIAN =' ' &
      W13MPJAUK.RACE_AmIndAlsknNatv =' ' & W13MPJAUK.RACE_NatHawnOPI =' ' &  (WTG7ZRE1.RESIDENCY ^= '4' or WTG7ZRE1.TUITION_STATUS = 'A') then '7'
      else ' '
      end as RACE_UNKNOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKNOWN',
      W13MPJAUK.RACE_NatHawnOPI as RACE_NATIVE_HAWAIIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_HAWAIIAN',
      ADW_TERM_DIM.STRM as STRM_Flex length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_TERM_DIM.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WJSE6S1R.RESIDENCY length = 5
         format = $5.
         informat = $5.
         label = 'RESIDENCY',
      WTG7ZRE1.TUITION_STATUS length = 1
         label = 'TUITION STATUS',
      ADW_ACAD_CAREER_DIM.ACAD_CAREER length = 4
         format = $4.
         informat = $4.
         label = 'ACAD_CAREER',
      TRANCOL.has_class length = 8,
      TRANCOL.has_flex length = 8,
      W9JYBSOK.IDD_Enrolled_IDD_Pgm as IDD length = 1,
      '0' as IDD_PROG length = 1,
      case when Student_term_info.DLRN = 1 then 'N'

      else 'Y'
      end as CB_REPORTED length = 8,
      classification_info.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN'
   from
      ADWTGTPR.CBM1_STUDENT_LIST as Student_term_info left join
      ADWTGTPR.ADW_ACAD_CAREER_DIM as ADW_ACAD_CAREER_DIM
         on
         (
            Student_term_info.ACAD_CAREER_SK = ADW_ACAD_CAREER_DIM.ACAD_CAREER_SK
         ) left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            Student_term_info.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      ADWTGTPR.ADW_PERSON_DIM as ADW_PERSON_DIM
         on
         (
            Student_term_info.EMPLID = ADW_PERSON_DIM.EMPLID
         ) left join
      ADWTGTPR.CBM1_CLASSIFICATION_INFO as classification_info
         on
         (
            Student_term_info.EMPLID = classification_info.EMPLID
            and Student_term_info.TERM_SK = classification_info.TERM_SK
         ) left join
      ADWSTGPR.PS_PERSON_SA_Extract as PS_PERSON_SA_Extract
         on
         (
            Student_term_info.EMPLID = PS_PERSON_SA_Extract.EMPLID
         ) left join
      ADWTGTPR.TRANCOL as TRANCOL
         on
         (
            Student_term_info.EMPLID = TRANCOL.EMPLID
            and TRANCOL.TERM_SK = ADW_TERM_DIM.TERM_SK
         ) left join
      work.WQMGJ1R8 as WQMGJ1R8
         on
         (
            Student_term_info.EMPLID = WQMGJ1R8.EMPLID
            and Student_term_info.TERM_SK = WQMGJ1R8.TERM_SK
         ) left join
      ADWTGTPR.CBM1_SCH as CBM1_SCH
         on
         (
            Student_term_info.EMPLID = CBM1_SCH.EMPLID
            and Student_term_info.TERM_SK = CBM1_SCH.TERM_SK
            and Student_term_info.FLEX = CBM1_SCH.FLEX
         ) left join
      work.WTG7ZRE1 as WTG7ZRE1
         on
         (
            Student_term_info.EMPLID = WTG7ZRE1.EMPLID
            and Student_term_info.TERM_SK = WTG7ZRE1.TERM_SK
         ) left join
      work.WJSE6S1R as WJSE6S1R
         on
         (
            Student_term_info.EMPLID = WJSE6S1R.EMPLID
            and Student_term_info.ACAD_CAREER_SK = WJSE6S1R.ACAD_CAREER_SK
            and case
               when trim(Student_term_info.FLEX) >'0'
                  then Student_term_info.TERM_SK +2
            else Student_term_info.TERM_SK
            end = WJSE6S1R.TERM_SK
         ) left join
      ADWTGTPR.CBM1_UGLIMIT as CBM1_UGLIMIT
         on
         (
            Student_term_info.EMPLID = CBM1_UGLIMIT.EMPLID
         ) left join
      work.W13MPJAUK as W13MPJAUK
         on
         (
            Student_term_info.EMPLID = W13MPJAUK.EMPLID
         ) left join
      ADWTGTPR.CBM1_UGDEGR as UGDEGR
         on
         (
            Student_term_info.EMPLID = UGDEGR.EMPLID
            and Student_term_info.TERM_SK = UGDEGR.TERM_SK
         ) left join
      work.W4E0W3NI as W4E0W3NI
         on
         (
            Student_term_info.EMPLID = W4E0W3NI.EMPLID
            and Student_term_info.TERM_SK = W4E0W3NI.TERM_SK
            and W4E0W3NI.FLEX = Student_term_info.FLEX
         ) left join
      work.W12707R8L as W12707R8L
         on
         (
            Student_term_info.EMPLID = W12707R8L.EMPLID
            and Student_term_info.ACAD_CAREER_SK = W12707R8L.ACAD_CAREER_SK
            and Student_term_info.TERM_SK = W12707R8L.TERM_SK
         ) left join
      work.W9JYBSOK as W9JYBSOK
         on
         (
            Student_term_info.EMPLID = W9JYBSOK.EMPLID
            and Student_term_info.TERM_SK = W9JYBSOK.TERM_SK
         )
   where
      (CBM1_SCH.SCH_ON IS NOT NULL
      or CBM1_SCH.SCH_OFF IS NOT NULL )
      and (CBM1_SCH.SCH_ON > 0
      or CBM1_SCH.SCH_OFF > 0)
      and ADW_TERM_DIM.ACAD_YEAR >= 2001
   ;
quit;

/*==========================================================================*
 * Step:            Combine flex fields                   A5B29B8Q.BZ000BO4 *
 * Transform:       Join                                                    *
 * Description:     Adjust Semester + Year + tuitres                        *
 *                                                                          *
 * Source Tables:   Join - work.WIB9I7X0                  A5B29B8Q.BS00041T *
 *                  tuition_status_exemption -            A5B29B8Q.BS00041P *
 *                   work.WTG7ZRE1                                          *
 *                  Join - work.WJSE6S1R                  A5B29B8Q.BS00041F *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 *                  PS_STDNT_CAR_TERM_Extract -           A5B29B8Q.BE00000K *
 *                   ADWSTGPR.PS_STDNT_CAR_TERM_Extract                     *
 *                  TRANCOL - ADWTGTPR.TRANCOL            A5B29B8Q.BE00018N *
 *                  CBM1_UGDEGR - ADWTGTPR.CBM1_UGDEGR    A5B29B8Q.BE00018L *
 * Target Table:    Join - work.W134AITPP                 A5B29B8Q.BS00041U *
 *==========================================================================*/

proc sql;
   create table work.W134AITPP as
   select distinct
      WIB9I7X0.RECCODE length = 1
         format = $1.
         informat = $1.
         label = 'RECCODE',
      WIB9I7X0.FICE length = 6
         format = $6.
         informat = $6.
         label = 'FICE',
      WIB9I7X0.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      WIB9I7X0.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      WIB9I7X0.CLASS
      /*
      case when WIB9I7X0.FLEX ='1'  then



      case
      when PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_BOT='10' then '1'
      when PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_BOT='20' then '2'
      when PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_BOT='30' then '3'
      when PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_BOT='40' then '4'
      when PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_BOT='50' then '5'
      when PS_STDNT_CAR_TERM_Extract.ACAD_LEVEL_BOT='60' then '5'
      else  case
                      when PS_STDNT_CAR_TERM_Extract.ACAD_PROG_PRIMARY ='CERT' then '6'
                      when PS_STDNT_CAR_TERM_Extract.ACAD_PROG_PRIMARY ='MASTR' then '6'
                      when PS_STDNT_CAR_TERM_Extract.ACAD_PROG_PRIMARY ='SPEC' then '6'
      else WIB9I7X0.CLASS
      end

      end



      else WIB9I7X0.CLASS
      end

      */ as CLASS length = 1
         label = 'CLASS',
      WIB9I7X0.DOB length = 8
         format = $8.
         label = 'DOB',
      case when (WIB9I7X0.TUITION_STATUS is null or WIB9I7X0.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ='1' then '1'

      when (WIB9I7X0.TUITION_STATUS is null or WIB9I7X0.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ^='1' and WJSE6S1R.ADMISSION_EXCPT  in ('1403A','1528A') then 'A'
      when (WIB9I7X0.TUITION_STATUS is null or WIB9I7X0.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ^='1' and WJSE6S1R.ADMISSION_EXCPT  in ('1403C','1528C') then 'C'
      when (WIB9I7X0.TUITION_STATUS is null or WIB9I7X0.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ^='1' and WJSE6S1R.ADMISSION_EXCPT  = 'DISAS' then 'N'
      when (WIB9I7X0.TUITION_STATUS is null or WIB9I7X0.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ^='1'  then '2'

      else WIB9I7X0.TUITION_STATUS
      end


      /*case when (WTG7ZRE1.TUITION_STATUS is null or WTG7ZRE1.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ='1' then '1'

      when (WTG7ZRE1.TUITION_STATUS is null or WTG7ZRE1.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ^='1' and WJSE6S1R.ADMISSION_EXCPT  in ('1403A','1528A') then 'A'
      when (WTG7ZRE1.TUITION_STATUS is null or WTG7ZRE1.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ^='1' and WJSE6S1R.ADMISSION_EXCPT  in ('1403C','1528C') then 'C'
      when (WTG7ZRE1.TUITION_STATUS is null or WTG7ZRE1.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ^='1' and WJSE6S1R.ADMISSION_EXCPT  = 'DISAS' then 'N'
      when (WTG7ZRE1.TUITION_STATUS is null or WTG7ZRE1.TUITION_STATUS is missing)  and WJSE6S1R.RESIDENCY ^='1'  then '2'

      else WTG7ZRE1.TUITION_STATUS
      end
      */
      /*
      coalesce(WTG7ZRE1.TUITION_STATUS ,WIB9I7X0.TUITRES)
      */ as TUITRES length = 1
         format = $1.
         informat = $1.
         label = 'TUITRES',
      WIB9I7X0.RESID length = 3
         label = 'RESID',
      trancol.TRANCOL as TRANCOL length = 8
         label = 'TRANCOL',
      WIB9I7X0.SCHON length = 8
         label = 'SCHON',
      WIB9I7X0.SCHOFF length = 8
         label = 'SCHOFF',
      WIB9I7X0.DOCFUND length = 8
         label = 'DOCFUND',
      case
         when substr(input_term.STRM,4,1)='8'
            then '1'
         when substr(input_term.STRM,4,1)='2'
            then '2'
         when substr(input_term.STRM,4,1)='5'
            then '3'
      else ' '
      end as SEMESTER length = 1
         label = 'SEMESTER',
      catt('20',substr(input_term.STRM ,2,2)) as YEAR length = 4
         label = 'YEAR',
      WIB9I7X0.INTERSCH length = 4
         label = 'INTERSCH',
      WIB9I7X0.FLEX length = 4
         format = $4.
         informat = $4.
         label = 'FLEX',
      WIB9I7X0.REMOTE length = 8
         label = 'REMOTE',
      WIB9I7X0.CIP length = 8
         format = $8.
         informat = $8.
         label = 'CIP',
      WIB9I7X0.DOCFNCD length = 2
         label = 'DOCFNCD',
      WTG7ZRE1.TUITION_EXEMPT as TUITEXT length = 2
         label = 'TUITEXT',
      WIB9I7X0.SCHCNSF length = 8
         label = 'SCHCNSF',
      WIB9I7X0.SCHDNSF length = 8
         label = 'SCHDNSF',
      WIB9I7X0.SCHINSF length = 4
         label = 'SCHINSF',
      WIB9I7X0.SCHCSF length = 8
         label = 'SCHCSF',
      WIB9I7X0.SCHDSF length = 8
         label = 'SCHDSF',
      WIB9I7X0.UGDEGR length = 8
         label = 'UGDEGR',
      WIB9I7X0.UGLIMIT length = 8
         label = 'UGLIMIT',
      WIB9I7X0.LAST length = 30
         format = $30.
         informat = $30.
         label = 'LAST',
      WIB9I7X0.FIRST length = 30
         format = $30.
         informat = $30.
         label = 'FIRST',
      WIB9I7X0.MINIT length = 1
         format = $1.
         informat = $1.
         label = 'MINIT',
      WIB9I7X0.SCHDC length = 8
         label = 'SCHDC',
      WIB9I7X0.TEACHED length = 2
         format = $2.
         informat = $2.
         label = 'TEACHED',
      WIB9I7X0.NDS length = 1
         format = $1.
         informat = $1.
         label = 'NDS',
      WIB9I7X0.ND length = 1
         format = $1.
         informat = $1.
         label = 'ND',
      WIB9I7X0.GR_SCH length = 8
         format = 5.
         informat = 5.
         label = 'GR_SCH',
      WIB9I7X0.HS_CODE length = 6
         format = $6.
         informat = $6.
         label = 'HS_CODE',
      WIB9I7X0.PEIMS_ID length = 9
         format = $9.
         informat = $9.
         label = 'PEIMS_ID',
      WIB9I7X0.ETHNIC length = 1
         label = 'ETHNIC',
      WIB9I7X0.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      WIB9I7X0.RACE_BLACK length = 1
         format = $1.
         informat = $1.
         label = 'RACE_BLACK',
      WIB9I7X0.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      WIB9I7X0.RACE_NATIVE_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_AMERICAN',
      WIB9I7X0.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      WIB9I7X0.RACE_UNKNOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKNOWN',
      WIB9I7X0.RACE_NATIVE_HAWAIIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_HAWAIIAN',
      input_term.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WIB9I7X0.STRM_Flex length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      WIB9I7X0.STRM as strm_mapped length = 4,
      WIB9I7X0.TERM_SK length = 8
         label = 'TERM_SK',
      PS_STDNT_CAR_TERM_Extract.STRM as CAR_STRM length = 4,
      WIB9I7X0.has_class length = 8,
      WIB9I7X0.has_flex length = 8,
      case when WIB9I7X0.CLASS>'4' then 'GRAD' else 'UGRD' end as acad_career length = 8,
      WIB9I7X0.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      UGDEGR.ACAD_SUB_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_SUB_PLAN',
      WIB9I7X0.IDD length = 1,
      WIB9I7X0.IDD_PROG length = 1,
      WIB9I7X0.CB_REPORTED length = 8
   from
      work.WIB9I7X0 as WIB9I7X0 left join
      ADWTGTPR.ADW_TERM_DIM as input_term
         on
         (
            WIB9I7X0.TERM_SK = input_term.TERM_SK
         ) left join
      ADWTGTPR.CBM1_UGDEGR as UGDEGR
         on
         (
            WIB9I7X0.TERM_SK_ORIG = UGDEGR.TERM_SK
            and WIB9I7X0.EMPLID = UGDEGR.EMPLID
         ) left join
      ADWSTGPR.PS_STDNT_CAR_TERM_Extract as PS_STDNT_CAR_TERM_Extract
         on
         (
            WIB9I7X0.EMPLID = PS_STDNT_CAR_TERM_Extract.EMPLID
            and (PS_STDNT_CAR_TERM_Extract.STRM = WIB9I7X0.STRM_Flex
            or PS_STDNT_CAR_TERM_Extract.STRM = WIB9I7X0.STRM)
         ) left join
      ADWTGTPR.TRANCOL as trancol
         on
         (
            WIB9I7X0.EMPLID = trancol.EMPLID
            and input_term.STRM = trancol.STRM
         ) left join
      work.WTG7ZRE1 as WTG7ZRE1
         on
         (
            WIB9I7X0.EMPLID = WTG7ZRE1.EMPLID
            and WIB9I7X0.TERM_SK_ORIG = WTG7ZRE1.TERM_SK
         ) left join
      work.WJSE6S1R as WJSE6S1R
         on
         (
            WIB9I7X0.EMPLID = WJSE6S1R.EMPLID
            and WIB9I7X0.TERM_SK = WJSE6S1R.TERM_SK
         )
   where
      input_term.STRM = "&term."
      /*
      ('2192')
      */
   group by
      WIB9I7X0.STRM_Flex,
      WIB9I7X0.EMPLID,
      WIB9I7X0.FLEX
   having
      CAR_STRM = min(CAR_STRM)
   ;
quit;

/*==========================================================================*
 * Step:            remove duplicate CLASS                A5B29B8Q.BZ000BO5 *
 * Transform:       Join                                                    *
 * Description:     created for students who have multiple                  *
 *                   classifications, usually due to flex                   *
 *                                                                          *
 * Source Tables:   Join - work.W134AITPP                 A5B29B8Q.BS00041U *
 *                  ADW_TERM_DIM - ADWTGTPR.ADW_TERM_DIM  A5B29B8Q.BE000004 *
 * Target Table:    Join - work.W12JIN0DN                 A5B29B8Q.BS00041V *
 *==========================================================================*/

proc sql;
   create table work.W12JIN0DN as
   select distinct
      input.RECCODE length = 1
         format = $1.
         informat = $1.
         label = 'RECCODE',
      input.FICE length = 6
         format = $6.
         informat = $6.
         label = 'FICE',
      input.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      input.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      input.CLASS length = 1
         label = 'CLASS',
      input.DOB length = 8
         format = $8.
         label = 'DOB',
      input.TUITRES length = 1
         format = $1.
         informat = $1.
         label = 'TUITRES',
      input.RESID length = 3
         label = 'RESID',
      input.TRANCOL length = 8
         label = 'TRANCOL',
      input.SCHON length = 8
         label = 'SCHON',
      input.SCHOFF length = 8
         label = 'SCHOFF',
      input.DOCFUND length = 8
         label = 'DOCFUND',
      input.SEMESTER length = 1
         label = 'SEMESTER',
      input.YEAR length = 4
         label = 'YEAR',
      input.INTERSCH length = 4
         label = 'INTERSCH',
      input.FLEX length = 4
         format = $4.
         informat = $4.
         label = 'FLEX',
      input.REMOTE length = 8
         label = 'REMOTE',
      input.CIP length = 8
         format = $8.
         informat = $8.
         label = 'CIP',
      input.DOCFNCD length = 2
         label = 'DOCFNCD',
      input.TUITEXT length = 2
         label = 'TUITEXT',
      input.SCHCNSF length = 8
         label = 'SCHCNSF',
      input.SCHDNSF length = 8
         label = 'SCHDNSF',
      input.SCHINSF length = 4
         label = 'SCHINSF',
      input.SCHCSF length = 8
         label = 'SCHCSF',
      input.SCHDSF length = 8
         label = 'SCHDSF',
      input.UGDEGR length = 8
         label = 'UGDEGR',
      input.UGLIMIT length = 8
         label = 'UGLIMIT',
      input.LAST length = 30
         format = $30.
         informat = $30.
         label = 'LAST',
      input.FIRST length = 30
         format = $30.
         informat = $30.
         label = 'FIRST',
      input.MINIT length = 1
         format = $1.
         informat = $1.
         label = 'MINIT',
      input.SCHDC length = 8
         label = 'SCHDC',
      input.TEACHED length = 2
         format = $2.
         informat = $2.
         label = 'TEACHED',
      input.NDS length = 1
         format = $1.
         informat = $1.
         label = 'NDS',
      input.ND length = 1
         format = $1.
         informat = $1.
         label = 'ND',
      input.GR_SCH length = 8
         format = 5.
         informat = 5.
         label = 'GR_SCH',
      input.HS_CODE length = 6
         format = $6.
         informat = $6.
         label = 'HS_CODE',
      input.PEIMS_ID length = 9
         format = $9.
         informat = $9.
         label = 'PEIMS_ID',
      input.ETHNIC length = 1
         label = 'ETHNIC',
      input.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      input.RACE_BLACK length = 1
         format = $1.
         informat = $1.
         label = 'RACE_BLACK',
      input.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      input.RACE_NATIVE_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_AMERICAN',
      input.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      input.RACE_UNKNOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKNOWN',
      input.RACE_NATIVE_HAWAIIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_HAWAIIAN',
      input.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      input.STRM_Flex length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      input.strm_mapped length = 4,
      input.TERM_SK length = 8
         label = 'TERM_SK',
      input.CAR_STRM length = 4,
      ADW_TERM_DIM.TERM_SK as term_sk_map length = 8,
      input.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      input.ACAD_SUB_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_SUB_PLAN',
      input.IDD length = 1,
      input.IDD_PROG length = 1,
      input.CB_REPORTED length = 8
   from
      work.W134AITPP as input left join
      ADWTGTPR.ADW_TERM_DIM as ADW_TERM_DIM
         on
         (
            input.strm_mapped = ADW_TERM_DIM.STRM
            and case when input.CLASS > '4' then 'GRAD' else 'UGRD' end = ADW_TERM_DIM.ACAD_CAREER
         )
   group by
      input.EMPLID,
      input.STRM,
      input.FLEX
   having
      input.CLASS = max(input.CLASS)
   ;
quit;

/*==========================================================================*
 * Step:            SIN Prep                              A5B29B8Q.BZ000BO6 *
 * Transform:       Join                                                    *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    PS_EXTERNAL_SYSTEM_Extract -          A5B29B8Q.BE00000S *
 *                   ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract                    *
 * Target Table:    Join - work.WXTP746F                  A5B29B8Q.BS00041W *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract);


proc sql;
   create table work.WXTP746F as
   select
      PS_EXTERNAL_SYSTEM_Extract.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      PS_EXTERNAL_SYSTEM_Extract.EXTERNAL_SYSTEM length = 3
         format = $3.
         informat = $3.
         label = 'EXTERNAL_SYSTEM',
      PS_EXTERNAL_SYSTEM_Extract.EFFDT length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'EFFDT',
      PS_EXTERNAL_SYSTEM_Extract.EXTERNAL_SYSTEM_ID length = 20
         format = $20.
         informat = $20.
         label = 'EXTERNAL_SYSTEM_ID',
      PS_EXTERNAL_SYSTEM_Extract.READ_DTM length = 8
         format = DATETIME20.
         informat = DATETIME20.
         label = 'READ_DTM',
      PS_EXTERNAL_SYSTEM_Extract.STAGE_UPDATE_ID length = 20
         format = $20.
         informat = $20.
         label = 'STAGE_UPDATE_ID'
   from
      ADWSTGPR.PS_EXTERNAL_SYSTEM_Extract as PS_EXTERNAL_SYSTEM_Extract
   where
      PS_EXTERNAL_SYSTEM_Extract.EXTERNAL_SYSTEM = 'CB'
   group by
      PS_EXTERNAL_SYSTEM_Extract.EXTERNAL_SYSTEM,
      PS_EXTERNAL_SYSTEM_Extract.EMPLID
   having
      PS_EXTERNAL_SYSTEM_Extract.EFFDT = max(PS_EXTERNAL_SYSTEM_Extract.EFFDT)
   ;
quit;

/*==========================================================================*
 * Step:            Join + SIN                            A5B29B8Q.BZ000BO7 *
 * Transform:       Join                                                    *
 * Description:     Final, replace missing values with 0                    *
 *                                                                          *
 * Source Tables:   Join - work.WXTP746F                  A5B29B8Q.BS00041W *
 *                  PS_PERS_NID_Extract -                 A5B29B8Q.BE00000R *
 *                   ADWSTGPR.PS_PERS_NID_Extract                           *
 *                  Join - work.W12JIN0DN                 A5B29B8Q.BS00041V *
 * Target Table:    Join + SIN - work.W2AVOD09            A5B29B8Q.BS00041X *
 *==========================================================================*/

proc sql;
   create view work.W2AVOD09 as
   select distinct
      W12JIN0DN.RECCODE length = 1
         format = $1.
         informat = $1.
         label = 'RECCODE',
      W12JIN0DN.FICE length = 6
         format = $6.
         informat = $6.
         label = 'FICE',
      W12JIN0DN.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      W12JIN0DN.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      W12JIN0DN.CLASS length = 1
         format = $1.
         informat = $1.
         label = 'CLASS',
      W12JIN0DN.DOB length = 8
         format = $8.
         informat = $8.
         label = 'DOB',
      W12JIN0DN.TUITRES length = 1
         format = $1.
         informat = $1.
         label = 'TUITRES',
      W12JIN0DN.RESID length = 3
         format = $3.
         informat = $3.
         label = 'RESID',
      W12JIN0DN.TRANCOL length = 8
         format = $8.
         informat = $8.
         label = 'TRANCOL',
      case
         when W12JIN0DN.SCHON =.
            then 0
      else W12JIN0DN.SCHON
      end as SCHON length = 8
         label = 'SCHON',
      case
         when W12JIN0DN.SCHOFF =.
            then 0
      else W12JIN0DN.SCHOFF
      end as SCHOFF length = 8
         label = 'SCHOFF',
      case
         when W12JIN0DN.DOCFUND  =.
            then 0
      else W12JIN0DN.DOCFUND
      end as DOCFUND length = 8
         label = 'DOCFUND',
      W12JIN0DN.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      W12JIN0DN.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      W12JIN0DN.INTERSCH length = 4
         format = $4.
         informat = $4.
         label = 'INTERSCH',
      W12JIN0DN.FLEX length = 4
         format = $4.
         informat = $4.
         label = 'FLEX',
      W12JIN0DN.REMOTE length = 8
         label = 'REMOTE',
      W12JIN0DN.CIP length = 8
         format = $8.
         informat = $8.
         label = 'CIP',
      case when (W12JIN0DN.DOCFNCD  is null or W12JIN0DN.DOCFNCD is missing) and W12JIN0DN.CLASS = '7' then '00'
      else W12JIN0DN.DOCFNCD
      end
      /*
      case
      when W12JIN0DN.DOCFNCD eq ' .' then ''
      when W12JIN0DN.DOCFNCD eq '.' then ''
      when W12JIN0DN.DOCFNCD eq '. ' then ''
      when trim(W12JIN0DN.DOCFNCD) eq '.' then ''
      else put(input(W12JIN0DN.DOCFNCD ,best2.),z2.)
      end
      */ as DOCFNCD length = 2
         format = $2.
         informat = $2.
         label = 'DOCFNCD',
      W12JIN0DN.TUITEXT length = 2
         format = $2.
         informat = $2.
         label = 'TUITEXT',
      case
         when W12JIN0DN.SCHCNSF  =.
            then 0
      else W12JIN0DN.SCHCNSF
      end as SCHCNSF length = 8
         label = 'SCHCNSF',
      case
         when W12JIN0DN.SCHDNSF  =.
            then 0
      else W12JIN0DN.SCHDNSF
      end as SCHDNSF length = 8
         label = 'SCHDNSF',
      W12JIN0DN.SCHINSF length = 4
         format = $4.
         informat = $4.
         label = 'SCHINSF',
      case
         when W12JIN0DN.SCHCSF  =.
            then 0
      else W12JIN0DN.SCHCSF
      end as SCHCSF length = 8
         label = 'SCHCSF',
      case
         when W12JIN0DN.SCHDSF  =.
            then 0
      else W12JIN0DN.SCHDSF
      end as SCHDSF length = 8
         label = 'SCHDSF',
      case
         when W12JIN0DN.UGDEGR  =.
            then 0
      else W12JIN0DN.UGDEGR
      end as UGDEGR length = 8
         label = 'UGDEGR',
      W12JIN0DN.UGLIMIT length = 8
         format = $8.
         informat = $8.
         label = 'UGLIMIT',
      substr(W12JIN0DN.LAST,1,20) as LAST length = 20
         format = $20.
         informat = $20.
         label = 'LAST',
      substr(W12JIN0DN.FIRST,1,10) as FIRST length = 10
         format = $10.
         informat = $10.
         label = 'FIRST',
      W12JIN0DN.MINIT length = 1
         format = $1.
         informat = $1.
         label = 'MINIT',
      case
         when W12JIN0DN.SCHDC  =.
            then 0
      else W12JIN0DN.SCHDC
      end as SCHDC length = 8
         label = 'SCHDC',
      W12JIN0DN.TEACHED length = 2
         format = $2.
         informat = $2.
         label = 'TEACHED',
      W12JIN0DN.NDS length = 1
         format = $1.
         informat = $1.
         label = 'NDS',
      W12JIN0DN.ND length = 1
         format = $1.
         informat = $1.
         label = 'ND',
      case
         when W12JIN0DN.GR_SCH  =.
            then 0
      else W12JIN0DN.GR_SCH
      end as GR_SCH length = 8
         format = 9.
         informat = 9.
         label = 'GR_SCH',
      W12JIN0DN.HS_CODE length = 6
         format = $6.
         informat = $6.
         label = 'HS_CODE',
      W12JIN0DN.PEIMS_ID length = 9
         format = $9.
         informat = $9.
         label = 'PEIMS_ID',
      W12JIN0DN.ETHNIC length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC',
      W12JIN0DN.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      W12JIN0DN.RACE_BLACK length = 1
         format = $1.
         informat = $1.
         label = 'RACE_BLACK',
      W12JIN0DN.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      W12JIN0DN.RACE_NATIVE_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_AMERICAN',
      W12JIN0DN.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      W12JIN0DN.RACE_UNKNOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKNOWN',
      W12JIN0DN.RACE_NATIVE_HAWAIIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_HAWAIIAN',
      W12JIN0DN.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      case
      when (PS_PERS_NID_Extract.NATIONAL_ID ^= ' ' &  substr(PS_PERS_NID_Extract.NATIONAL_ID,1,2) ^='99'
       & upcase(substr(PS_PERS_NID_Extract.NATIONAL_ID,1,2)) ^='XX') & (PS_PERS_NID_Extract.NATIONAL_ID is not null or PS_PERS_NID_Extract.NATIONAL_ID is not missing) then PS_PERS_NID_Extract.NATIONAL_ID
      when  (WXTP746F.EXTERNAL_SYSTEM_ID  ^= ' ' &  substr(WXTP746F.EXTERNAL_SYSTEM_ID ,1,2) ^='99'
       &  upcase(substr(WXTP746F.EXTERNAL_SYSTEM_ID ,1,2)) ^='XX') & (WXTP746F.EXTERNAL_SYSTEM_ID  is not null or WXTP746F.EXTERNAL_SYSTEM_ID  is not missing) then WXTP746F.EXTERNAL_SYSTEM_ID
      else catx('','9',substr(W12JIN0DN.EMPLID ,3,8))
      end as SIN length = 9
         format = $9.
         informat = $9.
         label = 'SIN',
      W12JIN0DN.ACAD_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_PLAN',
      W12JIN0DN.ACAD_SUB_PLAN length = 10
         format = $10.
         informat = $10.
         label = 'ACAD_SUB_PLAN',
      W12JIN0DN.IDD length = 1
         format = $1.
         informat = $1.
         label = 'IDD',
      W12JIN0DN.IDD_PROG length = 1
         format = $1.
         informat = $1.
         label = 'IDD_PROG',
      W12JIN0DN.CB_REPORTED length = 8
   from
      work.W12JIN0DN as W12JIN0DN left join
      ADWSTGPR.PS_PERS_NID_Extract as PS_PERS_NID_Extract
         on
         (
            W12JIN0DN.EMPLID = PS_PERS_NID_Extract.EMPLID
            and PS_PERS_NID_Extract.COUNTRY = 'USA'
            and PS_PERS_NID_Extract.NATIONAL_ID_TYPE = 'PR'
         ) left join
      work.WXTP746F as WXTP746F
         on
         (
            PS_PERS_NID_Extract.EMPLID = WXTP746F.EMPLID
         )
   ;
quit;

/*==========================================================================*
 * Step:            Table Loader                          A5B29B8Q.BZ000BO8 *
 * Transform:       Table Loader (Version 2.1)                              *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join + SIN - work.W2AVOD09            A5B29B8Q.BS00041X *
 * Target Table:    ADW_CBM0E1_WORK -                     A5B29B8Q.BE00017M *
 *                   ADWTGTPR.ADW_CBM0E1_WORK                               *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.W2AVOD09);

/* --------------------------------------------------------------
   Load Technique Selection: Replace - Truncate
   Constraint and index action selections: 'ASIS','ASIS','ASIS','ASIS'
   Additional options selections...
      Set unmapped to missing on updates: false
   -------------------------------------------------------------- */
%macro etls_loader;


   /* Determine if the target table exists  */
         %sysfunc(exist(ADWTGTPR.ADW_CBM0E1_WORK, VIEW)));

   /*---- Create a new table  ----*/
   %if (&etls_tableExist eq 0) %then
   %do;  /* if table does not exist  */

      %put %str(NOTE: Creating table ...);

      data ADWTGTPR.ADW_CBM0E1_WORK
              (dbnull = (
                         RECCODE = YES
                         FICE = YES
                         EMPLID = YES
                         GENDER = YES
                         CLASS = YES
                         DOB = YES
                         TUITRES = YES
                         RESID = YES
                         TRANCOL = YES
                         SCHON = YES
                         SCHOFF = YES
                         DOCFUND = YES
                         SEMESTER = YES
                         YEAR = YES
                         INTERSCH = YES
                         FLEX = YES
                         REMOTE = YES
                         CIP = YES
                         DOCFNCD = YES
                         TUITEXT = YES
                         SCHCNSF = YES
                         SCHDNSF = YES
                         SCHINSF = YES
                         SCHCSF = YES
                         SCHDSF = YES
                         UGDEGR = YES
                         UGLIMIT = YES
                         LAST = YES
                         FIRST = YES
                         MINIT = YES
                         SCHDC = YES
                         TEACHED = YES
                         NDS = YES
                         ND = YES
                         GR_SCH = YES
                         HS_CODE = YES
                         PEIMS_ID = YES
                         ETHNIC = YES
                         RACE_WHITE = YES
                         RACE_BLACK = YES
                         RACE_ASIAN = YES
                         RACE_NATIVE_AMERICAN = YES
                         RACE_INTERNATIONAL = YES
                         RACE_UNKNOWN = YES
                         RACE_NATIVE_HAWAIIAN = YES
                         STRM = YES
                         SIN = YES
                         ACAD_PLAN = YES
                         ACAD_SUB_PLAN = YES
                         IDD = YES
                         IDD_PROG = YES
                         CB_REPORTED = YES));
         attrib RECCODE length = $1
            format = $1.
            informat = $1.
            label = 'RECCODE';
         attrib FICE length = $6
            format = $6.
            informat = $6.
            label = 'FICE';
         attrib EMPLID length = $11
            format = $11.
            informat = $11.
            label = 'EMPLID';
         attrib GENDER length = $11
            format = $11.
            informat = $11.
            label = 'GENDER';
         attrib CLASS length = $1
            format = $1.
            informat = $1.
            label = 'CLASS';
         attrib DOB length = $8
            format = $8.
            informat = $8.
            label = 'DOB';
         attrib TUITRES length = $1
            format = $1.
            informat = $1.
            label = 'TUITRES';
         attrib RESID length = $3
            format = $3.
            informat = $3.
            label = 'RESID';
         attrib TRANCOL length = $8
            format = $8.
            informat = $8.
            label = 'TRANCOL';
         attrib SCHON length = 8
            label = 'SCHON';
         attrib SCHOFF length = 8
            label = 'SCHOFF';
         attrib DOCFUND length = 8
            label = 'DOCFUND';
         attrib SEMESTER length = $1
            format = $1.
            informat = $1.
            label = 'SEMESTER';
         attrib YEAR length = $4
            format = $4.
            informat = $4.
            label = 'YEAR';
         attrib INTERSCH length = $4
            format = $4.
            informat = $4.
            label = 'INTERSCH';
         attrib FLEX length = $4
            format = $4.
            informat = $4.
            label = 'FLEX';
         attrib REMOTE length = 8
            label = 'REMOTE';
         attrib CIP length = $8
            format = $8.
            informat = $8.
            label = 'CIP';
         attrib DOCFNCD length = $2
            format = $2.
            informat = $2.
            label = 'DOCFNCD';
         attrib TUITEXT length = $2
            format = $2.
            informat = $2.
            label = 'TUITEXT';
         attrib SCHCNSF length = 8
            label = 'SCHCNSF';
         attrib SCHDNSF length = 8
            label = 'SCHDNSF';
         attrib SCHINSF length = $4
            format = $4.
            informat = $4.
            label = 'SCHINSF';
         attrib SCHCSF length = 8
            label = 'SCHCSF';
         attrib SCHDSF length = 8
            label = 'SCHDSF';
         attrib UGDEGR length = 8
            label = 'UGDEGR';
         attrib UGLIMIT length = $8
            format = $8.
            informat = $8.
            label = 'UGLIMIT';
         attrib LAST length = $20
            format = $20.
            informat = $20.
            label = 'LAST';
         attrib FIRST length = $10
            format = $10.
            informat = $10.
            label = 'FIRST';
         attrib MINIT length = $1
            format = $1.
            informat = $1.
            label = 'MINIT';
         attrib SCHDC length = 8
            label = 'SCHDC';
         attrib TEACHED length = $2
            format = $2.
            informat = $2.
            label = 'TEACHED';
         attrib NDS length = $1
            format = $1.
            informat = $1.
            label = 'NDS';
         attrib ND length = $1
            format = $1.
            informat = $1.
            label = 'ND';
         attrib GR_SCH length = 8
            format = 9.
            informat = 9.
            label = 'GR_SCH';
         attrib HS_CODE length = $6
            format = $6.
            informat = $6.
            label = 'HS_CODE';
         attrib PEIMS_ID length = $9
            format = $9.
            informat = $9.
            label = 'PEIMS_ID';
         attrib ETHNIC length = $1
            format = $1.
            informat = $1.
            label = 'ETHNIC';
         attrib RACE_WHITE length = $1
            format = $1.
            informat = $1.
            label = 'RACE_WHITE';
         attrib RACE_BLACK length = $1
            format = $1.
            informat = $1.
            label = 'RACE_BLACK';
         attrib RACE_ASIAN length = $1
            format = $1.
            informat = $1.
            label = 'RACE_ASIAN';
         attrib RACE_NATIVE_AMERICAN length = $1
            format = $1.
            informat = $1.
            label = 'RACE_NATIVE_AMERICAN';
         attrib RACE_INTERNATIONAL length = $1
            format = $1.
            informat = $1.
            label = 'RACE_INTERNATIONAL';
         attrib RACE_UNKNOWN length = $1
            format = $1.
            informat = $1.
            label = 'RACE_UNKNOWN';
         attrib RACE_NATIVE_HAWAIIAN length = $1
            format = $1.
            informat = $1.
            label = 'RACE_NATIVE_HAWAIIAN';
         attrib STRM length = $4
            format = $4.
            informat = $4.
            label = 'STRM';
         attrib SIN length = $9
            format = $9.
            informat = $9.
            label = 'SIN';
         attrib ACAD_PLAN length = $10
            format = $10.
            informat = $10.
            label = 'ACAD_PLAN';
         attrib ACAD_SUB_PLAN length = $10
            format = $10.
            informat = $10.
            label = 'ACAD_SUB_PLAN';
         attrib IDD length = $1
            format = $1.
            informat = $1.
            label = 'IDD';
         attrib IDD_PROG length = $1
            format = $1.
            informat = $1.
            label = 'IDD_PROG';
         attrib CB_REPORTED length = $8;
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
            truncate table ADWTGTPRD.ADW_CBM0E1_WORK
         ) by ORACLE;

         %rcSet(&sqlrc);

         disconnect from ORACLE;
      quit;


   %end; /* table exists */

   /*---- Append  ----*/
   %put %str(NOTE: Appending data ...);

   proc append base = ADWTGTPR.ADW_CBM0E1_WORK
      data = &etls_lastTable (&etls_tableOptions)  force ;
    run;


%mend etls_loader;
%etls_loader;

/*==========================================================================*
 * Step:            Prep for textfile output              A5B29B8Q.BZ000BO9 *
 * Transform:       Join                                                    *
 * Description:     USES NODE 2 MACRO                                       *
 *                                                                          *
 * Source Table:    ADW_CBM0E1_WORK -                     A5B29B8Q.BE00017M *
 *                   ADWTGTPR.ADW_CBM0E1_WORK                               *
 * Target Table:    Join - work.WXT6H1HV                  A5B29B8Q.BS00041Y *
 *==========================================================================*/


%let SYSLAST = %nrquote(ADWTGTPR.ADW_CBM0E1_WORK);


proc sql;
   create table work.WXT6H1HV as
   select
      ADW_CBM0E1_WORK.RECCODE length = 1
         format = $1.
         informat = $1.
         label = 'RECCODE',
      ADW_CBM0E1_WORK.FICE length = 6
         format = $6.
         informat = $6.
         label = 'FICE',
      ADW_CBM0E1_WORK.EMPLID length = 11
         format = $11.
         informat = $11.
         label = 'EMPLID',
      ADW_CBM0E1_WORK.GENDER length = 11
         format = $11.
         informat = $11.
         label = 'GENDER',
      ADW_CBM0E1_WORK.CLASS length = 1
         format = $1.
         informat = $1.
         label = 'CLASS',
      ADW_CBM0E1_WORK.DOB length = 8
         format = $8.
         informat = $8.
         label = 'DOB',
      ADW_CBM0E1_WORK.TUITRES length = 1
         format = $1.
         informat = $1.
         label = 'TUITRES',
      ADW_CBM0E1_WORK.RESID length = 3
         format = $3.
         informat = $3.
         label = 'RESID',
      ADW_CBM0E1_WORK.TRANCOL length = 8
         format = $8.
         informat = $8.
         label = 'TRANCOL',
      . as SCHON length = 8
         label = 'SCHON',
      0 as SCHOFF length = 8
         label = 'SCHOFF',
      . as DOCFUND length = 8
         label = 'DOCFUND',
      ADW_CBM0E1_WORK.SEMESTER length = 1
         format = $1.
         informat = $1.
         label = 'SEMESTER',
      ADW_CBM0E1_WORK.YEAR length = 4
         format = $4.
         informat = $4.
         label = 'YEAR',
      "" as INTERSCH length = 4
         format = $4.
         informat = $4.
         label = 'INTERSCH',
      ADW_CBM0E1_WORK.FLEX length = 4
         format = $4.
         informat = $4.
         label = 'FLEX',
      ADW_CBM0E1_WORK.REMOTE length = 8
         label = 'REMOTE',
      ADW_CBM0E1_WORK.CIP length = 8
         format = $8.
         informat = $8.
         label = 'CIP',
      "" as DOCFNCD length = 2
         format = $2.
         informat = $2.
         label = 'DOCFNCD',
      ADW_CBM0E1_WORK.TUITEXT length = 2
         format = $2.
         informat = $2.
         label = 'TUITEXT',
      . as SCHCNSF length = 8
         label = 'SCHCNSF',
      . as SCHDNSF length = 8
         label = 'SCHDNSF',
      "" as SCHINSF length = 4
         format = $4.
         informat = $4.
         label = 'SCHINSF',
      . as SCHCSF length = 8
         label = 'SCHCSF',
      . as SCHDSF length = 8
         label = 'SCHDSF',
      ADW_CBM0E1_WORK.UGDEGR length = 8
         label = 'UGDEGR',
      ADW_CBM0E1_WORK.UGLIMIT length = 8
         format = $8.
         informat = $8.
         label = 'UGLIMIT',
      ADW_CBM0E1_WORK.LAST length = 30
         format = $30.
         informat = $30.
         label = 'LAST',
      ADW_CBM0E1_WORK.FIRST length = 30
         format = $30.
         informat = $30.
         label = 'FIRST',
      ADW_CBM0E1_WORK.MINIT length = 1
         format = $1.
         informat = $1.
         label = 'MINIT',
      . as SCHDC length = 8
         label = 'SCHDC',
      ADW_CBM0E1_WORK.TEACHED length = 2
         format = $2.
         informat = $2.
         label = 'TEACHED',
      ADW_CBM0E1_WORK.NDS length = 1
         format = $1.
         informat = $1.
         label = 'NDS',
      ADW_CBM0E1_WORK.ND length = 1
         format = $1.
         informat = $1.
         label = 'ND',
      . as GR_SCH length = 8
         format = 7.
         informat = 7.
         label = 'GR_SCH',
      ADW_CBM0E1_WORK.HS_CODE length = 6
         format = $6.
         informat = $6.
         label = 'HS_CODE',
      ADW_CBM0E1_WORK.PEIMS_ID length = 9
         format = $9.
         informat = $9.
         label = 'PEIMS_ID',
      ADW_CBM0E1_WORK.ETHNIC length = 1
         format = $1.
         informat = $1.
         label = 'ETHNIC',
      ADW_CBM0E1_WORK.RACE_WHITE length = 1
         format = $1.
         informat = $1.
         label = 'RACE_WHITE',
      ADW_CBM0E1_WORK.RACE_BLACK length = 1
         format = $1.
         informat = $1.
         label = 'RACE_BLACK',
      ADW_CBM0E1_WORK.RACE_ASIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_ASIAN',
      ADW_CBM0E1_WORK.RACE_NATIVE_AMERICAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_AMERICAN',
      ADW_CBM0E1_WORK.RACE_INTERNATIONAL length = 1
         format = $1.
         informat = $1.
         label = 'RACE_INTERNATIONAL',
      ADW_CBM0E1_WORK.RACE_UNKNOWN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_UNKNOWN',
      ADW_CBM0E1_WORK.RACE_NATIVE_HAWAIIAN length = 1
         format = $1.
         informat = $1.
         label = 'RACE_NATIVE_HAWAIIAN',
      ADW_CBM0E1_WORK.STRM length = 4
         format = $4.
         informat = $4.
         label = 'STRM',
      ADW_CBM0E1_WORK.SIN length = 20,
      ADW_CBM0E1_WORK.IDD length = 1,
      ADW_CBM0E1_WORK.IDD_PROG length = 1,
      catx('', 'HY2K003656CBM0E11' , year(datetime()) ,
       'C0140                                                                                                  ') as header length = 300
         format = $163.
   from
      ADWTGTPR.ADW_CBM0E1_WORK as ADW_CBM0E1_WORK
   where
      ADW_CBM0E1_WORK.STRM = "&term."
      and ADW_CBM0E1_WORK.CB_REPORTED = 'Y'
   ;
quit;

/*==========================================================================*
 * Step:            File Writer                           A5B29B8Q.BZ000BOA *
 * Transform:       File Writer                                             *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WXT6H1HV                  A5B29B8Q.BS00041Y *
 * Target Table:    CBM0E1_WORK - &CBM0E1OutputFileLoc.   A5B29B8Q.BV00001E *
 *==========================================================================*/


%let SYSLAST = %nrquote(work.WXT6H1HV);

%let ETLS_SYSLAST = &SYSLAST;

%let CBM0E1OutputFileLoc =/sasdata/Data/CBM/CBM0E1/CBM0E1_&term._&sysdate9..txt;

data _null_;
   set &SYSLAST;
   file "&CBM0E1OutputFileLoc." ;
if _n_ = 1 then do;
put 'HY2K003656CBM0E1' @@ ;
put semester $1. @@ ;
put year $4. @@;
put 'C0140JoannaDemurat CBM-MAIL@LISTSERV.UTA.EDU                                                                                                  ' ;
end;
run;


%let SYSLAST = &ETLS_SYSLAST;

proc sql;
   create view work.W2CKPBSK as
      select
         RECCODE,
         FICE,
         (substr(SIN,1,9)) as SIN length = 9
            format = $9.
            informat = $9.
            label = 'SIN',
         (substr(GENDER,1,1)) as GENDER length = 1
            format = $11.
            informat = $11.
            label = 'GENDER',
         CLASS,
         DOB,
         TUITRES,
         RESID,
         (substr(TRANCOL,1,6)) as TRANCOL length = 6
            format = $8.
            informat = $8.
            label = 'TRANCOL',
         "" as SCHON length = 4
            label = 'SCHON',
         (put(SCHOFF,z4.)) as SCHOFF length = 4
            label = 'SCHOFF',
         "" as DOCFUND length = 4
            label = 'DOCFUND',
         SEMESTER,
         YEAR,
         "" as INTERSCH length = 4
            format = $4.
            informat = $4.
            label = 'INTERSCH',
         (substr(FLEX,1,1)) as FLEX length = 1
            format = $4.
            informat = $4.
            label = 'FLEX',
         (case when REMOTE = . then ' ' else put(REMOTE,1.) end) as REMOTE length = 1
            label = 'REMOTE',
         CIP,
         "" as DOCFNCD length = 2
            format = $2.
            informat = $2.
            label = 'DOCFNCD',
         TUITEXT,
         "" as SCHCNSF length = 4
            label = 'SCHCNSF',
         "" as SCHDNSF length = 4
            label = 'SCHDNSF',
         "" as SCHINSF length = 4
            format = $4.
            informat = $4.
            label = 'SCHINSF',
         "" as SCHCSF length = 4
            label = 'SCHCSF',
         "" as SCHDSF length = 4
            label = 'SCHDSF',
         (put(UGDEGR,z3.)) as UGDEGR length = 3
            label = 'UGDEGR',
         (substr(UGLIMIT,1,1)) as UGLIMIT length = 1
            format = $8.
            informat = $8.
            label = 'UGLIMIT',
         (substr(LAST,1,20)) as LAST length = 20
            format = $30.
            informat = $30.
            label = 'LAST',
         (substr(FIRST,1,10)) as FIRST length = 10
            format = $30.
            informat = $30.
            label = 'FIRST',
         MINIT,
         "" as SCHDC length = 4
            label = 'SCHDC',
         TEACHED,
         NDS,
         ND,
         "" as GR_SCH length = 4
            format = 8.
            informat = 8.
            label = 'GR_SCH',
         HS_CODE,
         PEIMS_ID,
         ETHNIC,
         RACE_WHITE,
         RACE_BLACK,
         RACE_ASIAN,
         RACE_NATIVE_AMERICAN,
         RACE_INTERNATIONAL,
         RACE_UNKNOWN,
         RACE_NATIVE_HAWAIIAN,
         IDD,
         IDD_PROG
   from &SYSLAST
   ;
quit;

%let SYSLAST = work.W2CKPBSK;

data _null_;
   set &SYSLAST;
      attrib RECCODE length = $1
         format = $1.
         informat = $1.;
      attrib FICE length = $6
         format = $6.
         informat = $6.;
      attrib SIN length = $9
         format = $9.
         informat = $9.;
      attrib GENDER length = $1
         format = $11.
         informat = $11.;
      attrib CLASS length = $1
         format = $1.
         informat = $1.;
      attrib DOB length = $8
         format = $8.
         informat = $8.;
      attrib TUITRES length = $1
         format = $1.
         informat = $1.;
      attrib RESID length = $3
         format = $3.
         informat = $3.;
      attrib TRANCOL length = $6
         format = $8.
         informat = $8.;
      attrib SCHON length = $4;
      attrib SCHOFF length = $4;
      attrib DOCFUND length = $4;
      attrib SEMESTER length = $1
         format = $1.
         informat = $1.;
      attrib YEAR length = $4
         format = $4.
         informat = $4.;
      attrib INTERSCH length = $4
         format = $4.
         informat = $4.;
      attrib FLEX length = $1
         format = $4.
         informat = $4.;
      attrib REMOTE length = $1;
      attrib CIP length = $8
         format = $8.
         informat = $8.;
      attrib DOCFNCD length = $2
         format = $2.
         informat = $2.;
      attrib TUITEXT length = $2
         format = $2.
         informat = $2.;
      attrib SCHCNSF length = $4;
      attrib SCHDNSF length = $4;
      attrib SCHINSF length = $4
         format = $4.
         informat = $4.;
      attrib SCHCSF length = $4;
      attrib SCHDSF length = $4;
      attrib UGDEGR length = $3;
      attrib UGLIMIT length = $1
         format = $8.
         informat = $8.;
      attrib LAST length = $20
         format = $30.
         informat = $30.;
      attrib FIRST length = $10
         format = $30.
         informat = $30.;
      attrib MINIT length = $1
         format = $1.
         informat = $1.;
      attrib SCHDC length = $4;
      attrib TEACHED length = $2
         format = $2.
         informat = $2.;
      attrib NDS length = $1
         format = $1.
         informat = $1.;
      attrib ND length = $1
         format = $1.
         informat = $1.;
      attrib GR_SCH length = $4
         format = 8.
         informat = 8.;
      attrib HS_CODE length = $6
         format = $6.
         informat = $6.;
      attrib PEIMS_ID length = $9
         format = $9.
         informat = $9.;
      attrib ETHNIC length = $1
         format = $1.
         informat = $1.;
      attrib RACE_WHITE length = $1
         format = $1.
         informat = $1.;
      attrib RACE_BLACK length = $1
         format = $1.
         informat = $1.;
      attrib RACE_ASIAN length = $1
         format = $1.
         informat = $1.;
      attrib RACE_NATIVE_AMERICAN length = $1
         format = $1.
         informat = $1.;
      attrib RACE_INTERNATIONAL length = $1
         format = $1.
         informat = $1.;
      attrib RACE_UNKNOWN length = $1
         format = $1.
         informat = $1.;
      attrib RACE_NATIVE_HAWAIIAN length = $1
         format = $1.
         informat = $1.;
      attrib IDD length = $1;
      attrib IDD_PROG length = $1;
      file "&CBM0E1OutputFileLoc." MOD;

         put
             @ 1 RECCODE $1.
             @ 2 FICE $6.
             @ 8 SIN $9.
             @ 17 GENDER $11.
             @ 18 CLASS $1.
             @ 19 DOB $8.
             @ 27 TUITRES $1.
             @ 28 RESID $3.
             @ 31 TRANCOL $8.
             @ 37 SCHON
             @ 41 SCHOFF
             @ 45 DOCFUND
             @ 49 SEMESTER $1.
             @ 50 YEAR $4.
             @ 54 INTERSCH $4.
             @ 58 FLEX $4.
             @ 59 REMOTE
             @ 60 CIP $8.
             @ 68 DOCFNCD $2.
             @ 70 TUITEXT $2.
             @ 72 SCHCNSF
             @ 76 SCHDNSF
             @ 80 SCHINSF $4.
             @ 84 SCHCSF
             @ 88 SCHDSF
             @ 92 UGDEGR
             @ 95 UGLIMIT $8.
             @ 96 LAST $30.
             @ 116 FIRST $30.
             @ 126 MINIT $1.
             @ 127 SCHDC
             @ 131 TEACHED $2.
             @ 133 NDS $1.
             @ 134 ND $1.
             @ 135 GR_SCH 8.
             @ 139 HS_CODE $6.
             @ 145 PEIMS_ID $9.
             @ 154 ETHNIC $1.
             @ 155 RACE_WHITE $1.
             @ 156 RACE_BLACK $1.
             @ 157 RACE_ASIAN $1.
             @ 158 RACE_NATIVE_AMERICAN $1.
             @ 159 RACE_INTERNATIONAL $1.
             @ 160 RACE_UNKNOWN $1.
             @ 161 RACE_NATIVE_HAWAIIAN $1.
             @ 162 IDD
             @ 163 IDD_PROG
         ;

run;

data _null_;
   set &SYSLAST END=EOF;
   file "&CBM0E1OutputFileLoc." mod;
   if eof then put @1 'EOF1' @@ _N_ @@;
run;

/*==========================================================================*
 * Step:            User Written                          A5B29B8Q.BZ000BOB *
 * Transform:       User Written                                            *
 * Description:                                                             *
 *                                                                          *
 * Source Table:    Join - work.WXT6H1HV                  A5B29B8Q.BS00041Y *
 * Target Table:    User Written - work.WABESZ5L          A5B29B8Q.BS00041Z *
 *                                                                          *
 * User Written:    SourceCode                                              *
 *==========================================================================*
 *                                                                          *
 * Nothing will be generated for this process because the "Exclude          *
 *  transformation from run" option is selected.                            *
 *                                                                          *
 *==========================================================================*/
