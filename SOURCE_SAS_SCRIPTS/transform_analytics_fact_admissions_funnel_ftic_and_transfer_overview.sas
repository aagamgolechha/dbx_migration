/* ============================================================ */
/* Stored Process : Admission UGRD Funnel Overview - FTIC and Transfer */
/* ============================================================ */

*  Begin EG generated code (do not edit this line); 
* 
*  Stored process registered by 
*  Enterprise Guide Stored Process Manager V8.3 
* 
*  ==================================================================== 
*  Stored process name: Admission UGRD Funnel Overview - FTIC and Transfer 
*  ==================================================================== 
* 
*  Stored process prompt dictionary: 
*  ____________________________________ 
*  CURRENTDATETOCHECK 
*       Type: Text 
*      Label: Select a Snapshot Date: 
*       Attr: Visible, Required 
*  ____________________________________ 
*  OUTPUTTYPE 
*       Type: Text 
*      Label: Output Type 
*       Attr: Visible, Required 
*    Default: Excel 
*  ____________________________________ 
*; 
 
 
*ProcessBody; 
 
%global CURRENTDATETOCHECK 
        OUTPUTTYPE; 
 
*  End EG generated code (do not edit this line); 
 
 
%let TestOut = &OutputType;
%macro OutputChoice(OutputSelection=); 

	%if %trim(&OutputSelection) =Excel %then %do; 
		%global _odsdest _odsstyle _odsstylesheet;

		%let _odsdest=excel;
/*		%let _odsstyle=sasweb;*/
		%let _odsstylesheet=;

  		data _null_;
		  rc = stpsrv_header('Content-type','application/vnd.ms-excel;');
		  rc = stpsrv_header('Content-disposition',"attachment; filename=Admission UGRD Funnel Overview FTIC TRN_%sysfunc(today(),yymmdd10).xlsx");
		run;
		%end; 
%mend OutputChoice;
%OutputChoice(OutputSelection=&TestOut)

%stpbegin;

%if %trim(&OutputType) =Excel %then %do; 
	ods EXCEL options(sheet_name="UGRD"
				  sheet_interval='none'
                  embedded_titles='yes');
%end;

/* --- Start of code for "Get Snapshot Dates Macro". --- */
/*%check if snapdate provided exists in UGRD funnel table.  
  If it exists then return value in macro variable snapdatefound
  else check back up to maxdaysback (20 days) and return found value
*/
%macro CheckSnapDate (Snapdate=);
	%let numobs = 0;
	%let i = 0;
	%let maxdaysback = 20;

	%let tempsnapdate = &Snapdate;

	%do %while (&numobs = 0 and &i LE &maxdaysback);

		proc sql noprint;
			select distinct snapdate_ymd
				into :snapdate_ymd
/*			from utacstgt.uta_adm_ugrd_funnel ugfunnel*/
			from	UTACSRPT.DDH_GETUGRDFUNNELTERMS ugfunnel
			where snapdate_ymd = "&tempsnapdate";
			%let numobs = &sqlobs;
 		quit;
		%let i = %eval(&i + 1) ;
		%let tempsnapdate = %sysfunc(intnx
										(day,             /* unit of time interval */
  									 	 %sysfunc(inputn(&Snapdate,yymmdd8.)), /* function to get current date */
  									 	 %eval(0-&i)               /* number of intervals, negative goes to the past */
								   		), yymmddn8.  /* Tell %SYSFUNC how to format the result */
 								 	 );

	%end;

	%if &numobs > 0 %then %do;
		%let snapdatefound = &snapdate_ymd;
		%end;
	%else %do;
		%let snapdatefound =;
		%end;
%mend;

/*get current snapdate, comparison snapdate one year ago 
	and comparison snapdate two years ago. Return the values in 
	macro varibles CurrentSnapshotDate, ComparisonSnapshotDate1, ComparisonSnapshotDate2
*/

%macro GetSnapDates (datetocheck=);
/*get current snapdate_yymmdd */
%let snapdatefound=;
%let checkCurrentSnapdate=&datetocheck;
%CheckSnapDate (Snapdate=&checkCurrentSnapdate.);
%let CurrentSnapshotDate = &snapdatefound;
%let snapdatefound=;

/*get comparison snapdate_yymmdd - one year ago */
%let CheckcompareSnapdate1=%sysfunc(intnx(year,%sysfunc(inputn(&CurrentSnapshotDate,yymmdd8.)),-1,same),yymmddn8.);
%CheckSnapDate (Snapdate=&CheckcompareSnapdate1.);
%let ComparisonSnapshotDate1 = &snapdatefound;
%let snapdatefound=;

/*get comparison snapdate_yymmdd - two years ago */
%let CheckcompareSnapdate2=%sysfunc(intnx(year,%sysfunc(inputn(&CurrentSnapshotDate,yymmdd8.)),-2,same),yymmddn8.);
%CheckSnapDate (Snapdate=&CheckcompareSnapdate2.);
%let ComparisonSnapshotDate2 = &snapdatefound;
%let snapdatefound=;

%mend;


/* --- End of code for "Get Snapshot Dates Macro". --- */

/* --- Start of code for "Get Report Terms Macro". --- */
%macro getReportTerms (snapdate=);
proc sql noprint;
  select distinct report_term
    into :FunnelTerm1-
  from UTACSRPT.DDH_GETUGRDFUNNELTERMS
  where snapdate_ymd="&snapdate."
 	and strip(report_term) is not null
	order by 1 asc;
quit;

proc sql noprint;
  select count(distinct report_term)  
  	into :TermCount
	from UTACSRPT.DDH_GETUGRDFUNNELTERMS
  where snapdate_ymd="&snapdate."
	and strip(report_term) is not null;
quit;

%do i = 1 %to &TermCount;
	%let FunnelTerm&i = &&FunnelTerm&i;
%end;
%mend;


/* --- End of code for "Get Report Terms Macro". --- */

/* --- Start of code for "Get Calendar Year Macro". --- */
%macro getCalendarYears (TermType=);
proc sql noprint;
  select distinct Calendar_year
    into :Calendar_Year1-
  from work.FunnelReport
  where term_type=&TermType.
	order by 1 asc;
quit;

proc sql noprint;
  select count(distinct Calendar_year)  
  	into :Year_Count
	  from work.FunnelReport
  where term_type=&TermType.
;
quit;

%do j = 1 %to &Year_Count;
	%let CalendarYear&j = &&Calendar_Year&j;
%end;

%let YearCount = &year_count;

%mend;


/* --- End of code for "Get Calendar Year Macro". --- */

/* --- Start of code for "Set Session Variables". --- */
/* Set includes for utility macros. */
/*%include '/sasdata/Data/SASCode/Jobs/UTACustomJobs/LibMacro.sas';*/
/*%include '/sasdata/Data/SASCode/Jobs/UTACustomJobs/UtilityMacros/MacroNoteOptions.sas';*/

/* Set current term, comparision term, and related snapshot date variables. */

options symbolgen mlogic mprint ;

%GLOBAl resultcount;

/*set output choice -- uncomment for stored processes*/
/*%let TestOut = &OutputType;*/
/*%OutputChoice(OutputSelection=&TestOut);*/
/*%put &=TestOut;*/

%let FunnelTerm1 =;
%let FunnelTerm2 =;
%let FunnelTerm3 =;

%let CurrentSnapshotDate =;
%let ComparisonSnapshotDate1 =;
%let ComparisonSnapshotDate2 =;

/*%let CurrentDateToCheck = %sysfunc(today(),yymmddn8.);*/

/*%let CurrentDateToCheck = 20210712;*/

%GetSnapDates(datetocheck=&CurrentDateToCheck);

%put &=CurrentSnapshotDate;
%put &=ComparisonSnapshotDate1;
%put &=ComparisonSnapshotDate2;

%getReportTerms (snapdate=&CurrentSnapshotDate);

%put &=FunnelTerm1;
%put &=FunnelTerm2;
%put &=FunnelTerm3;

options nosymbolgen nomlogic nomprint;
/* --- End of code for "Set Session Variables". --- */

/* --- Start of code for "Funnel Overview Detail Data". --- */
proc sql;

	create table work.FunnelDetailData as

	/* UGRD Funnel Detail */
	select distinct
		ugfunnel.snapdate_ymd,
		ugfunnel.emplid,
		ugfunnel.application_nbr,
		'UGRD' as acad_career,
		ugfunnel.admit_type,
		ugfunnel.admit_type_descr,
		ugfunnel.admit_term,
		ugfunnel.admit_term_descr,
		
		substr(ugfunnel.admit_term_descr, 6, length(ugfunnel.admit_term_descr) - 5) || ' ' || substr(ugfunnel.admit_term_descr, 1, 4) as admit_term_formal_descr,
		substr(ugfunnel.admit_term_descr, 1, 4) as calendar_year,
		substr(ugfunnel.admit_term_descr, 6, length(ugfunnel.admit_term_descr) - 5) as term_type,
		case
			when (strip(ugfunnel.admit_type) = '1'
			and ugfunnel.auap = 'N'
			and ugfunnel.auea = 'N')
			then 'a. First Time in College (FTIC)'
			when (strip(ugfunnel.admit_type) = '2'
			and ugfunnel.auap = 'N'
/*			AUET is looking for AUUX recruitment category*/
			and ugfunnel.auet = 'N'
			and not (ugfunnel.aubs = 'Y' and ugfunnel.ubsg = 'Y'))
		/*	and ugfunnel.aubs ^= 'Y'
			and ugfunnel.ubsg ^= 'Y') */
			then 'b. Transfer'
			else ''
		end as student_type,
		ugfunnel.program_status,
		case
			when ugfunnel.program_status in ('AC','AD','PM')
			then 'Y'
			else 'N'
		end as admit_flag,
		ugfunnel.matr_flag,
		ugfunnel.enroll_flag,
		1 as applicant_count

	from utacstgt.uta_adm_ugrd_funnel ugfunnel

	/* First funnel term and comparison filter. */
	where ((ugfunnel.admit_term = "&FunnelTerm1."
		and ugfunnel.snapdate_ymd = "&CurrentSnapshotDate.")
		or (ugfunnel.admit_term = put(&FunnelTerm1. - 10, 4.)
		and ugfunnel.snapdate_ymd = "&ComparisonSnapshotDate1.")
		or (ugfunnel.admit_term = put(&FunnelTerm1. - 20, 4.)
		and ugfunnel.snapdate_ymd = "&ComparisonSnapshotDate2.")
		/* Second funnel term and comparison filter. */
		or (ugfunnel.admit_term = "&FunnelTerm2."
		and ugfunnel.snapdate_ymd = "&CurrentSnapshotDate.")
		or (ugfunnel.admit_term = put(&FunnelTerm2 - 10, 4.)
		and ugfunnel.snapdate_ymd = "&ComparisonSnapshotDate1.")
		or (ugfunnel.admit_term = put(&FunnelTerm2 - 20, 4.)
		and ugfunnel.snapdate_ymd = "&ComparisonSnapshotDate2.")
		/* Third funnel term and comparison filter. */
		or (ugfunnel.admit_term = "&FunnelTerm3."
		and ugfunnel.snapdate_ymd = "&CurrentSnapshotDate.")
		or (ugfunnel.admit_term = put(&FunnelTerm3 - 10, 4.)
		and ugfunnel.snapdate_ymd = "&ComparisonSnapshotDate1.")
		or (ugfunnel.admit_term = put(&FunnelTerm3 - 20, 4.)
		and ugfunnel.snapdate_ymd = "&ComparisonSnapshotDate2.")
		)
		/* Eliminate Test ID's */
		and strip(ugfunnel.emplid) not like 'UTATEST%'

		/* Application flag must be Y for all records. */
		and ugfunnel.appl_flag = 'Y'
		/* Remove AO applicants. */
		and ugfunnel.auap = 'N'

		/* FTIC Filters */
		and ((strip(ugfunnel.admit_type) = '1'
		and ugfunnel.auea = 'N')
		/* Transfer Filters */
		or (strip(ugfunnel.admit_type) = '2'
		and ugfunnel.auet = 'N'
		and not (ugfunnel.aubs = 'Y' and ugfunnel.ubsg = 'Y')))
		/*and ugfunnel.aubs ^= 'Y'
		and ugfunnel.ubsg ^= 'Y'))*/
		order by
			6 asc,
			3 desc,
			9 asc

		;

quit;

/*proc export data=work.FunnelDetailData*/
/*outfile='/sasdata/UniversityAnalytics/DropBox/EnrollmentManagement/James/FunnelDetailData.xlsx'*/
/*dbms=xlsx replace;*/
/*run;*/


/* --- End of code for "Funnel Overview Detail Data". --- */

/* --- Start of code for "Funnel Overview Report Prep". --- */
proc sql;

	create table work.FunnelReport as

	/* Applied */
	select distinct
		funnel.snapdate_ymd
			label = "Snapshot Date",
		funnel.emplid
			label = "Student ID",
		funnel.application_nbr
		    label = "Application Number",
		funnel.acad_career
			label = "Academic Career",
		funnel.admit_type
			label = "Admit Type Code",
		funnel.admit_type_descr
			label = "Admit Type",
		funnel.admit_term
			label = "Admit Term Code",
		funnel.admit_term_descr
			label = "Admit Term",
		funnel.admit_term_formal_descr
			label = "Admit Term",
		funnel.calendar_year
			label = "Calendar Year",
		funnel.term_type
			label = "Term Type",
		funnel.student_type
			label = "Student Type",
		funnel.program_status
			label = "Program Status",
		funnel.admit_flag
			label = "Admit Flag",
		funnel.matr_flag
			label = "Matriculation Flag",
		funnel.enroll_flag
			label = "Enrollment Flag",
		'a. Applications' as application_status
			label = "Application Status",
		funnel.applicant_count
			label = "Student Count"

	from work.FunnelDetailData funnel

	union all

	/* Admitted */
	select distinct
		funnel.snapdate_ymd
			label = "Snapshot Date",
		funnel.emplid
			label = "Student ID",
		funnel.application_nbr
		    label = "Application Number",
		funnel.acad_career
			label = "Academic Career",
		funnel.admit_type
			label = "Admit Type Code",
		funnel.admit_type_descr
			label = "Admit Type",
		funnel.admit_term
			label = "Admit Term Code",
		funnel.admit_term_descr
			label = "Admit Term",
		funnel.admit_term_formal_descr
			label = "Admit Term",
		funnel.calendar_year
			label = "Calendar Year",
		funnel.term_type
			label = "Term Type",
		funnel.student_type
			label = "Student Type",
		funnel.program_status
			label = "Program Status",
		funnel.admit_flag
			label = "Admit Flag",
		funnel.matr_flag
			label = "Matriculation Flag",
		funnel.enroll_flag
			label = "Enrollment Flag",
		'b. Admits' as application_status
			label = "Application Status",
		funnel.applicant_count
			label = "Student Count"

	from work.FunnelDetailData funnel

	/* Admit filters. */
	where funnel.admit_flag = 'Y'

	union all

	/* Matriculated */
	select distinct
		funnel.snapdate_ymd
			label = "Snapshot Date",
		funnel.emplid
			label = "Student ID",
		funnel.application_nbr
		    label = "Application Number",
		funnel.acad_career
			label = "Academic Career",
		funnel.admit_type
			label = "Admit Type Code",
		funnel.admit_type_descr
			label = "Admit Type",
		funnel.admit_term
			label = "Admit Term Code",
		funnel.admit_term_descr
			label = "Admit Term",
		funnel.admit_term_formal_descr
			label = "Admit Term",
		funnel.calendar_year
			label = "Calendar Year",
		funnel.term_type
			label = "Term Type",
		funnel.student_type
			label = "Student Type",
		funnel.program_status
			label = "Program Status",
		funnel.admit_flag
			label = "Admit Flag",
		funnel.matr_flag
			label = "Matriculation Flag",
		funnel.enroll_flag
			label = "Enrollment Flag",
		'c. Accepted Admission' as application_status
			label = "Application Status",
		funnel.applicant_count
			label = "Student Count"

	from work.FunnelDetailData funnel

	/* Matriculation filters. */
	where funnel.admit_flag = 'Y'
	and funnel.matr_flag = 'Y'

	union all

	/* Enrolled */
	select distinct
		funnel.snapdate_ymd
			label = "Snapshot Date",
		funnel.emplid
			label = "Student ID",
		funnel.application_nbr
		    label = "Application Number",
		funnel.acad_career
			label = "Academic Career",
		funnel.admit_type
			label = "Admit Type Code",
		funnel.admit_type_descr
			label = "Admit Type",
		funnel.admit_term
			label = "Admit Term Code",
		funnel.admit_term_descr
			label = "Admit Term",
		funnel.admit_term_formal_descr
			label = "Admit Term",
		funnel.calendar_year
			label = "Calendar Year",
		funnel.term_type
			label = "Term Type",
		funnel.student_type
			label = "Student Type",
		funnel.program_status
			label = "Program Status",
		funnel.admit_flag
			label = "Admit Flag",
		funnel.matr_flag
			label = "Matriculation Flag",
		funnel.enroll_flag
			label = "Enrollment Flag",
		'd. Registered' as application_status
			label = "Application Status",
		funnel.applicant_count
			label = "Student Count"

	from work.FunnelDetailData funnel

	/* Enrollment filter. */
	where funnel.enroll_flag = 'Y'

	order by
		6, 9, 14 asc

	;

quit;

proc sql;
  create table work.FunnelReportSummary as
    select calendar_year,
		term_type,
		student_type,
		application_status,
		count(emplid) as applicant_count
	from work.FunnelReport
	group by calendar_year,
		term_type,
		student_type,
		application_status
  ;
  %let resultcount=&sqlobs; 
quit;


/* --- End of code for "Funnel Overview Report Prep". --- */

/* --- Start of code for "Report Formats". --- */
/* Create custom report formats. */

proc format;                           
   picture mypct (round) low-high='009.99%';   
run; 

proc format;
	value negfmt
	low-<0 = 'red'
	other = 'black';
run;
/* --- End of code for "Report Formats". --- */

/* --- Start of code for "Macro Admissions Funnel Summary Overview Report". --- */
/*%SetMacroNoteOptions(NoteOptions='On');*/

%macro WeeklyFunnelOverview(TermType=);

options missing=0;

title1 "Daily Admissions Overview 3 Years Comparison for %sysfunc(dequote(&TermType)) Terms";
title2 justify=center
	height=9pt
	"Current Snapshot date: &CurrentSnapshotDate";
footnote1
	justify=center
	height=9pt

"Report run date: %sysfunc(today(), yymmdd10).";

/*footnote2
	justify=center
	height=9pt

"Data source: Unfiltered Global application funnel and enrollment data.  No considerations for IPEDS or THECB reporting requirements.  Data is as of report run date."; */

proc report data=work.FunnelReportSummary out=work.Test
split='*';

	where term_type = &TermType;

	columns

		student_type
			(
				application_status,
				(
					calendar_year,
					applicant_count
					ChangeN1
					ChangePct1
					ChangeN2
					ChangePct2

				)
			);

	define student_type / group ;
	define application_status / across "";
	define calendar_year / across "";
	define applicant_count / analysis "";
	define ChangeN1 / computed style=[foreground=negfmt.] "# +/- (&Calendaryear2.-&calendaryear1.)";
	define ChangePct1 / computed style=[foreground=negfmt.] "% +/- (&Calendaryear2.-&calendaryear1.)" format=percentn12.2;
	define ChangeN2 / computed style=[foreground=negfmt.] "# +/- (&Calendaryear3.-&calendaryear2.)";
	define ChangePct2 / computed style=[foreground=negfmt.] "% +/- (&Calendaryear3.-&calendaryear2.)" format=percentn12.2;

compute ChangeN1;
	    if (missing(_c2_)) then _c2_=0; 
	    if (missing(_c3_)) then _c3_=0;
        if (missing(_c4_)) then _c4_=0;
		if (missing(_c5_)) then _c5_=0;
		if (missing(_c6_)) then _c6_=0;
		if (missing(_c7_)) then _c7_=0;
		if (missing(_c8_)) then _c8_=0;
		if (missing(_c9_)) then _c9_=0;
		if (missing(_c10_)) then _c10_=0;
		if (missing(_c11_)) then _c11_=0;
		if (missing(_c12_)) then _c12_=0;
		if (missing(_c13_)) then _c13_=0;
		if (missing(_c14_)) then _c14_=0;
		if (missing(_c15_)) then _c15_=0;
	    if (missing(_c16_)) then _c16_=0;
		if (missing(_c17_)) then _c17_=0;
		if (missing(_c18_)) then _c18_=0; 
	    if (missing(_c19_)) then _c19_=0;
        if (missing(_c20_)) then _c20_=0;
		if (missing(_c21_)) then _c21_=0;
		if (missing(_c22_)) then _c22_=0;
		if (missing(_c23_)) then _c23_=0;
		if (missing(_c24_)) then _c24_=0;
		if (missing(_c25_)) then _c25_=0;
		if (missing(_c26_)) then _c26_=0;
		if (missing(_c27_)) then _c27_=0;
		
		/* Applied */
		_c5_ = (_c3_ - _c2_);

		/* Admitted */
		_c12_ = (_c10_ - _c9_);

		/* Accepted Admission */
		_c19_ = (_c17_ - _c16_);

		/* Registered*/
		_c26_ = (_c24_ - _c23_);

	endcomp;

	/* Compute percentage change between years. */
	compute ChangePct1;

	/* Applied */
	if ((_c2_ = 0
		or missing(_c2_))
		and (_c3_ = 0
		or missing(_c3_)))
		then _c6_ = 0;
	else if ((_c2_ = 0
		or missing(_c2_))
		and (_c3_ > _c2_
		or _c3_ > 0))
		then _c6_ = 1;
	else if ((_c3_ = 0
		or missing(_c3_))
		and (_c2_ > _c3_
		or _c2_ > 0))
		then _c6_ = -1;
	else _c6_ = (_c3_ - _c2_) / _c2_;

	/* Admitted */
	if ((_c9_ = 0
		or missing(_c9_))
		and (_c10_ = 0
		or missing(_c10_)))
		then _c13_ = 0;
	else if ((_c9_ = 0
		or missing(_c9_))
		and (_c10_ > _c9_
		or _c10_ > 0))
		then _c13_ = 1;
	else if ((_c9_ = 0
		or missing(_c9_))
		and (_c9_ > _c10_
		or _c9_ > 0))
		then _c13_ = -1;
	else _c13_ = (_c10_ - _c9_) / _c9_;

	/* Accepted Admission */
	if ((_c16_ = 0
		or missing(_c16_))
		and (_c17_ = 0
		or missing(_c17_)))
		then _c20_ = 0;
	else if ((_c16_ = 0
		or missing(_c16_))
		and (_c17_ > _c16_
		or _c17_ > 0))
		then _c20_ = 1;
	else if ((_c17_ = 0
		or missing(_c17_))
		and (_c16_ > _c17_
		or _c16_ > 0))
		then _c20_ = -1;
	else _c20_ = (_c17_ - _c16_) / _c16_;

	/* Registered*/
	if ((_c23_ = 0
		or missing(_c23_))
		and (_c24_ = 0
		or missing(_c24_)))
		then _c27_ = 0;
	else if ((_c23_ = 0
		or missing(_c23_))
		and (_c24_ > _c23_
		or _c24_ > 0))
		then _c27_ = 1;
	else if ((_c24_ = 0
		or missing(_c24_))
		and (_c23_ > _c24_
		or _c23_ > 0))
		then _c27_ = -1;
	else _c27_ = (_c24_ - _c23_) / _c23_;

	endcomp;

	compute ChangeN2; 
	    if (missing(_c2_)) then _c2_=0; 
	    if (missing(_c3_)) then _c3_=0;
        if (missing(_c4_)) then _c4_=0;
		if (missing(_c5_)) then _c5_=0;
		if (missing(_c6_)) then _c6_=0;
		if (missing(_c7_)) then _c7_=0;
		if (missing(_c8_)) then _c8_=0;
		if (missing(_c9_)) then _c9_=0;
		if (missing(_c10_)) then _c10_=0;
		if (missing(_c11_)) then _c11_=0;
		if (missing(_c12_)) then _c12_=0;
		if (missing(_c13_)) then _c13_=0;
		if (missing(_c14_)) then _c14_=0;
		if (missing(_c15_)) then _c15_=0;
	    if (missing(_c16_)) then _c16_=0;
		if (missing(_c17_)) then _c17_=0;
		if (missing(_c18_)) then _c18_=0; 
	    if (missing(_c19_)) then _c19_=0;
        if (missing(_c20_)) then _c20_=0;
		if (missing(_c21_)) then _c21_=0;
		if (missing(_c22_)) then _c22_=0;
		if (missing(_c23_)) then _c23_=0;
		if (missing(_c24_)) then _c24_=0;
		if (missing(_c25_)) then _c25_=0;
		if (missing(_c26_)) then _c26_=0;
		if (missing(_c27_)) then _c27_=0;
		
		/* Applied */
		_c7_ = (_c4_ - _c3_);

		/* Admitted */
		_c14_ = (_c11_ - _c10_);

		/* Accepted Admission */
		_c21_ = (_c18_ - _c17_);

		/* Registered*/
		_c28_ = (_c25_ - _c24_);

	endcomp;

	/* Compute percentage change between years. */
	compute ChangePct2;

	/* Applied c2=c3 c3=c4 c6=c8*/
	if ((_c3_ = 0
		or missing(_c3_))
		and (_c4_ = 0
		or missing(_c4_)))
		then _c8_ = 0;
	else if ((_c3_ = 0
		or missing(_c3_))
		and (_c4_ > _c3_
		or _c4_ > 0))
		then _c8_ = 1;
	else if ((_c4_ = 0
		or missing(_c4_))
		and (_c3_ > _c4_
		or _c3_ > 0))
		then _c8_ = -1;
	else _c8_ = (_c4_ - _c3_) / _c3_;

	/* Admitted c9=c10 c10=c11 c13=c15*/
	if ((_c10_ = 0
		or missing(_c10_))
		and (_c11_ = 0
		or missing(_c11_)))
		then _c15_ = 0;
	else if ((_c10_ = 0
		or missing(_c10_))
		and (_c11_ > _c10_
		or _c11_ > 0))
		then _c15_ = 1;
	else if ((_c10_ = 0
		or missing(_c10_))
		and (_c10_ > _c11_
		or _c10_ > 0))
		then _c15_ = -1;
	else _c15_ = (_c11_ - _c10_) / _c10_;

	/* Accepted Admission c16=c17 c17=c18 c20=c22*/
	if ((_c17_ = 0
		or missing(_c17_))
		and (_c18_ = 0
		or missing(_c18_)))
		then _c22_ = 0;
	else if ((_c17_ = 0
		or missing(_c17_))
		and (_c18_ > _c17_
		or _c18_ > 0))
		then _c22_ = 1;
	else if ((_c18_ = 0
		or missing(_c18_))
		and (_c17_ > _c18_
		or _c17_ > 0))
		then _c22_ = -1;
	else _c22_ = (_c18_ - _c17_) / _c17_;

	/* Registered c23=c24 c24=c25 c27=c29*/ 
	if ((_c24_ = 0
		or missing(_c24_))
		and (_c25_ = 0
		or missing(_c25_)))
		then _c29_ = 0;
	else if ((_c24_ = 0
		or missing(_c24_))
		and (_c25_ > _c24_
		or _c25_ > 0))
		then _c29_ = 1;
	else if ((_c25_ = 0
		or missing(_c25_))
		and (_c24_ > _c25_
		or _c24_ > 0))
		then _c29_ = -1;
	else _c29_ = (_c25_ - _c24_) / _c24_;

	endcomp;

run;

title;
footnote;

%mend WeeklyFunnelOverview;

/*%SetMacroNoteOptions(NoteOptions='Off');*/
/* --- End of code for "Macro Admissions Funnel Summary Overview Report". --- */

/* --- Start of code for "Macro Report Driver". --- */


/*%SetMacroNoteOptions(NoteOptions='On');*/

%macro GetFunnelOverviewReports(FunnelTerm1=, FunnelTerm2=, FunnelTerm3=);

	proc sql noprint;

		select distinct
			'''' || termSetup.SourceKey || '''',
			'''' || termSetup.Description || '''',
			'''' || termSetup.TermType || ''''

		into :TermCode1-, :Description1-, :TermType1-
		from utacstgt.DimUtaTerm termSetup
		where termSetup.SourceKey in ("&FunnelTerm1.", "&FunnelTerm2.", "&FunnelTerm3.")

		order by
		 	1 asc;

		quit;

		proc sql noprint;

			select
				count(distinct termSetup.SourceKey)

				into :TermCount separated by ''

			from utacstgt.DimUtaTerm termSetup
			where termSetup.SourceKey in ("&FunnelTerm1.", "&FunnelTerm2.", "&FunnelTerm3.")
			;
	quit;

	%put &=resultcount;
%if %sysevalf(&resultcount)>0 %then %do;


options nosymbolgen nomlogic nomprint;

	%do i = 1 %to &TermCount;

		/*get calendar years in macro varibles */
		options symbolgen mlogic mprint ;
		%let CALENDARYEAR1=;
		%let CALENDARYEAR2=;
		%let CALENDARYEAR3=;
		%let YearCount=;

		%getCalendarYears (TermType=&&TermType&i);

		%put &=CALENDARYEAR1;
		%put &=CALENDARYEAR2;
		%put &=CALENDARYEAR3;
		%put &=YearCount;

		%if %sysevalf(&YearCount)=3 %then %do;
			%WeeklyFunnelOverview(TermType=&&TermType&i);
			%end;
		%else %do;
			data work.yearcount3;
				length Note $250.;
				Note = "For the selected snapshot date &CurrentSnapshotDate, three years data for comparison is NOT available. Please select a more recent snapshot date";
			proc print data=work.yearcount3 noobs;
			run;
		%end;

	%end;
%end;
%else %do;
	data work.empty;
		length Note $250.;
		Note = 'For the selected values, no data is available. The dataset is empty';
	proc print data=work.empty noobs;
	run;
%end;

%mend GetFunnelOverviewReports;


/*%SetMacroNoteOptions(NoteOptions='Off');*/


/* --- End of code for "Macro Report Driver". --- */

/* --- Start of code for "Run Overview Reports". --- */
/*%SetMacroNoteOptions(NoteOptions='On');*/
options symbolgen mlogic mprint ;


%GetFunnelOverviewReports
	(
		FunnelTerm1 = &FunnelTerm1, 
		FunnelTerm2 = &FunnelTerm2,
		FunnelTerm3 = &FunnelTerm3
	);

/*	%SetMacroNoteOptions(NoteOptions='Off');  */


options nosymbolgen nomlogic nomprint;

ods EXCEL close; 

%stpend;



/* --- End of code for "Run Overview Reports". --- */ 
 
*  Begin EG generated code (do not edit this line); 
;*';*";*/;quit; 
 
*  End EG generated code (do not edit this line);
