/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Monday, June 9, 2025     TIME: 7:43:32 AM
PROJECT: UTA_ADM_DIM_FUNNEL_WEEKS
PROJECT PATH: U:\Global Reporting and Analytics\System Administrators\SAS\ETL Design\UTA Custom Jobs\UTA Admissions Funnels\Enterprise Guide Projects\UTA_ADM_DIM_FUNNEL_WEEKS.egp
---------------------------------------- */

/* Library assignment for SASApp.UTACSTRN */
;

%macro _eg_hidenotesandsource;
	%global _egnotes;
	%global _egsource;
	
	%let _egnotes=%sysfunc(getoption(notes));
	options nonotes;
	%let _egsource=%sysfunc(getoption(source));
	options nosource;
%mend _eg_hidenotesandsource;


%macro _eg_restorenotesandsource;
	%global _egnotes;
	%global _egsource;
	
	options &_egnotes;
	options &_egsource;
%mend _eg_restorenotesandsource;


/* ---------------------------------- */
/* MACRO: enterpriseguide             */
/* PURPOSE: define a macro variable   */
/*   that contains the file system    */
/*   path of the WORK library on the  */
/*   server.  Note that different     */
/*   logic is needed depending on the */
/*   server type.                     */
/* ---------------------------------- */
%macro enterpriseguide;
%global sasworklocation;
%local tempdsn unique_dsn path;

%if &sysscp=OS %then %do; /* MVS Server */
	%if %sysfunc(getoption(filesystem))=MVS %then %do;
        /* By default, physical file name will be considered a classic MVS data set. */
	    /* Construct dsn that will be unique for each concurrent session under a particular account: */
		filename egtemp '&egtemp' disp=(new,delete); /* create a temporary data set */
 		%let tempdsn=%sysfunc(pathname(egtemp)); /* get dsn */
		filename egtemp clear; /* get rid of data set - we only wanted its name */
		%let unique_dsn=".EGTEMP.%substr(&tempdsn, 1, 16).PDSE"; 
		filename egtmpdir &unique_dsn
			disp=(new,delete,delete) space=(cyl,(5,5,50))
			dsorg=po dsntype=library recfm=vb
			lrecl=8000 blksize=8004 ;
		options fileext=ignore ;
	%end; 
 	%else %do; 
        /* 
		By default, physical file name will be considered an HFS 
		(hierarchical file system) file. 
		*/
		%if "%sysfunc(getoption(filetempdir))"="" %then %do;
			filename egtmpdir '/tmp';
		%end;
		%else %do;
			filename egtmpdir "%sysfunc(getoption(filetempdir))";
		%end;
	%end; 
	%let path=%sysfunc(pathname(egtmpdir));
    %let sasworklocation=%sysfunc(quote(&path));  
%end; /* MVS Server */
%else %do;
	%let sasworklocation = "%sysfunc(getoption(work))/";
%end;
%if &sysscp=VMS_AXP %then %do; /* Alpha VMS server */
	%let sasworklocation = "%sysfunc(getoption(work))";                         
%end;
%if &sysscp=CMS %then %do; 
	%let path = %sysfunc(getoption(work));                         
	%let sasworklocation = "%substr(&path, %index(&path,%str( )))";
%end;
%mend enterpriseguide;

%enterpriseguide


/* Conditionally delete set of tables or views, if they exists          */
/* If the member does not exist, then no action is performed   */
%macro _eg_conditional_dropds /parmbuff;
	
   	%local num;
   	%local stepneeded;
   	%local stepstarted;
   	%local dsname;
	%local name;

   	%let num=1;
	/* flags to determine whether a PROC SQL step is needed */
	/* or even started yet                                  */
	%let stepneeded=0;
	%let stepstarted=0;
   	%let dsname= %qscan(&syspbuff,&num,',()');
	%do %while(&dsname ne);	
		%let name = %sysfunc(left(&dsname));
		%if %qsysfunc(exist(&name)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;

			%end;
				drop table &name;
		%end;

		%if %sysfunc(exist(&name,view)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;
			%end;
				drop view &name;
		%end;
		%let num=%eval(&num+1);
      	%let dsname=%qscan(&syspbuff,&num,',()');
	%end;
	%if &stepstarted %then %do;
		quit;
	%end;
%mend _eg_conditional_dropds;


/* save the current settings of XPIXELS and YPIXELS */
/* so that they can be restored later               */
%macro _sas_pushchartsize(new_xsize, new_ysize);
	%global _savedxpixels _savedypixels;
	options nonotes;
	proc sql noprint;
	select setting into :_savedxpixels
	from sashelp.vgopt
	where optname eq "XPIXELS";
	select setting into :_savedypixels
	from sashelp.vgopt
	where optname eq "YPIXELS";
	quit;
	options notes;
	GOPTIONS XPIXELS=&new_xsize YPIXELS=&new_ysize;
%mend _sas_pushchartsize;

/* restore the previous values for XPIXELS and YPIXELS */
%macro _sas_popchartsize;
	%if %symexist(_savedxpixels) %then %do;
		GOPTIONS XPIXELS=&_savedxpixels YPIXELS=&_savedypixels;
		%symdel _savedxpixels / nowarn;
		%symdel _savedypixels / nowarn;
	%end;
%mend _sas_popchartsize;


ODS PROCTITLE;
OPTIONS DEV=PNG;
GOPTIONS XPIXELS=0 YPIXELS=0;
%macro HTML5AccessibleGraphSupported;
    %if %_SAS_VERCOMP_FV(9,4,4, 0,0,0) >= 0 %then ACCESSIBLE_GRAPH;
%mend;
FILENAME EGSRX TEMP;
ODS tagsets.sasreport13(ID=EGSRX) FILE=EGSRX
    STYLE=Plateau
    NOGTITLE
    NOGFOOTNOTE
    GPATH=&sasworklocation
    ENCODING=UTF8
    options(rolap="on")
;

/*   START OF NODE: Term and Census Date Data   */
%_eg_hidenotesandsource;

%LET _CLIENTTASKLABEL='Term and Census Date Data';
%LET _CLIENTPROCESSFLOWNAME='Data Sets';
%LET _CLIENTPROJECTPATH='U:\Global Reporting and Analytics\System Administrators\SAS\ETL Design\UTA Custom Jobs\UTA Admissions Funnels\Enterprise Guide Projects\UTA_ADM_DIM_FUNNEL_WEEKS.egp';
%LET _CLIENTPROJECTPATHHOST='UA-140645';
%LET _CLIENTPROJECTNAME='UTA_ADM_DIM_FUNNEL_WEEKS.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

%_eg_restorenotesandsource;

proc sql;

	create table work.TermAndCensusDateDataPrep as

	select distinct
		termSetup.sourcekey as termsourcekey,
		termSetup.description as termdescription,
		sessionSetup.censusdate as censusdate,
		dhms(intnx('week', datepart(termSetup.censusdate), 1, 'b'), 0, 0, 0) as cyclestartdate format=datetime20.,
		termSetupNext.sourcekey as nexttermsourcekey,
		termSetupNext.description as nexttermdescription,
		sessionSetupNext.censusdate as nexttermcensusdate,
		intck('week', datepart(sessionSetup.censusdate), datepart(sessionSetupNext.censusdate)) as weeksbetween

	from utacstgt.dimutaterm termSetup
	inner join utacstgt.dimutasession sessionSetup
		on termSetup.sourcekey = sessionSetup.termSourceKey
	inner join utacstgt.dimutaterm termSetupNext
		on termSetupNext.sourcekey = case
																			when substr(termSetup.sourcekey, 4, 1) in ('2','5')
																			then put(input(termSetup.sourcekey, 4.) + 3, 4.)
																			when substr(termSetup.sourcekey, 4, 1) = '8'
																			then put(input(termSetup.sourcekey, 4.) + 4, 4.)
																			else ''
																		end
	inner join utacstgt.dimutasession sessionSetupNext
		on termSetupNext.sourcekey = sessionSetupNext.termSourceKey

	where termSetup.sourcekey >= &MinimumTerm
	and sessionSetup.sourcekey = case
																		when substr(termSetup.sourcekey, 4, 1) in ('2','8')
																		then '1'
																		when substr(termSetup.sourcekey, 4, 1) = '5'
																		then '11W'
																		else ''
																	end
	and sessionSetupNext.sourcekey = case
																				when substr(termSetupNext.sourcekey, 4, 1) in ('2','8')
																				then '1'
																				when substr(termSetupNext.sourcekey, 4, 1) = '5'
																				then '11W'
																				else ''
																			end
	and not missing(sessionSetup.censusdate)
	and not missing(sessionSetupNext.censusdate)

	order by
		termSetup.sourcekey asc

	;

quit;


proc sql;

	create table work.TermAndCensusDateDataPrep2 as

	select distinct
		termSetup.nexttermsourcekey as cycletermsourcekey,
		termSetup.nexttermdescription as cycletermdescription,
		substr(termSetup.nexttermdescription, 1, 4) as calendaryear,
		termSetup.termsourcekey as censustermsourcekey,
		termSetup.termdescription as censustermdescription,
		termSetup.censusdate as censustermcensusdate,
		termSetup.nexttermsourcekey as termsourcekey1,
		termSetup.nexttermdescription as termdescription1,
		case
			when substr(termSetup.nexttermsourcekey, 4, 1) in ('2','5')
			then put(input(termSetup.nexttermsourcekey, 4.) + 3, 4.)
			when substr(termSetup.nexttermsourcekey, 4, 1) = '8'
			then put(input(termSetup.nexttermsourcekey, 4.) + 4, 4.)
			else ''
		end as termsourcekey2,
		case
			when substr(termSetup.nexttermsourcekey, 4, 1) = '2'
			then put(input(termSetup.nexttermsourcekey, 4.) + 6, 4.)
			when substr(termSetup.nexttermsourcekey, 4, 1) = '5'
			then put(input(termSetup.nexttermsourcekey, 4.) + 7, 4.)
			when substr(termSetup.nexttermsourcekey, 4, 1) = '8'
			then put(input(termSetup.nexttermsourcekey, 4.) + 7, 4.)
			else ''
		end as termsourcekey3,

		termSetup.cyclestartdate,
		termSetup.nexttermcensusdate as cycleenddate,
		termSetup.weeksbetween

	from work.TermAndCensusDateDataPrep termSetup

	where put(datepart(termSetup.cyclestartdate), year.) ^= '1900'

	;

quit;

proc sql;

	create table work.TermAndCensusDateData as

	select distinct
		termSetup.cycletermsourcekey,
		termSetup.cycletermdescription,
		termSetup.calendaryear,
		termSetup.censustermsourcekey,
		termSetup.censustermdescription,
		termSetup.censustermcensusdate,
		termSetup.termsourcekey1,
		termSetup.termdescription1,
		termSetup.termsourcekey2,
		termSetup2.description as termdescription2,
		termSetup.termsourcekey3,
		termSetup3.description as termdescription3,
		termSetup.cyclestartdate,
		termSetup.cycleenddate,
		termSetup.weeksbetween

	from work.TermAndCensusDateDataPrep2 termSetup
	inner join utacstgt.dimutaterm termSetup2
		on termSetup.termsourcekey2 = termSetup2.sourcekey
	inner join utacstgt.dimutaterm termSetup3
		on termSetup.termsourcekey3 = termSetup3.sourcekey


	order by
		termSetup.cycletermsourcekey asc

	;

quit;

proc delete data=work.TermAndCensusDateDataPrep
work.TermAndCensusDateDataPrep2;

run;

%_eg_hidenotesandsource;

%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;

%_eg_restorenotesandsource;


/*   START OF NODE: Funnel Weeks Data   */
%_eg_hidenotesandsource;

%LET _CLIENTTASKLABEL='Funnel Weeks Data';
%LET _CLIENTPROCESSFLOWNAME='Data Sets';
%LET _CLIENTPROJECTPATH='U:\Global Reporting and Analytics\System Administrators\SAS\ETL Design\UTA Custom Jobs\UTA Admissions Funnels\Enterprise Guide Projects\UTA_ADM_DIM_FUNNEL_WEEKS.egp';
%LET _CLIENTPROJECTPATHHOST='UA-140645';
%LET _CLIENTPROJECTNAME='UTA_ADM_DIM_FUNNEL_WEEKS.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

%_eg_restorenotesandsource;

data work.FunnelWeeksData;

	set work.TermAndCensusDateData;

	processingdate = cyclestartdate;
	daynumber = 1;

	do i=1 to weeksbetween;

		weeknumber = i;
		

		if processingdate >= cyclestartdate
			and processingdate <= cycleenddate
			then do;

				do d=1 to 7;

					snapshotdate = processingdate;
					snapshotdayofweek = strip(put(weekday(datepart(processingdate) + 1), downame9.));
					

					if processingdate >= cyclestartdate
						and processingdate <= cycleenddate
						then do;

							output;
							processingdate = dhms(datepart(processingdate) + 1, 0, 0, 0);
							daynumber = daynumber + 1;
							
						end;

				end;

			end;

	end;

	format snapshotdate datetime20.;

	keep
		cycletermsourcekey
		cycletermdescription
		calendaryear
		censustermsourcekey
		censustermdescription
		censustermcensusdate
		termsourcekey1
		termdescription1
		termsourcekey2
		termdescription2
		termsourcekey3
		termdescription3
		cyclestartdate
		cycleenddate
		weeknumber
		snapshotdate
		snapshotdayofweek
		daynumber
	;

run;

proc sort data=work.FunnelWeeksData;

	by
		cycletermsourcekey
		weeknumber
		snapshotdate
	;

run;

%_eg_hidenotesandsource;

%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;

%_eg_restorenotesandsource;


/*   START OF NODE: UTA_ADM_DIM_FUNNEL_WEEKS   */
%_eg_hidenotesandsource;

%LET _CLIENTTASKLABEL='UTA_ADM_DIM_FUNNEL_WEEKS';
%LET _CLIENTPROCESSFLOWNAME='Data Sets';
%LET _CLIENTPROJECTPATH='U:\Global Reporting and Analytics\System Administrators\SAS\ETL Design\UTA Custom Jobs\UTA Admissions Funnels\Enterprise Guide Projects\UTA_ADM_DIM_FUNNEL_WEEKS.egp';
%LET _CLIENTPROJECTPATHHOST='UA-140645';
%LET _CLIENTPROJECTNAME='UTA_ADM_DIM_FUNNEL_WEEKS.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

%_eg_restorenotesandsource;

proc lua;
submit;
if not sas.exists("utacstrn.uta_adm_dim_fun_wk_trn") 
	then print("Transformation Table does not exist. Skipping drop.")
	else sas.submit([[
		proc sql;
			drop table utacstrn.uta_adm_dim_fun_wk_trn;
		quit;
	]])
end
endsubmit;
run;

data utacstrn.uta_adm_dim_fun_wk_trn;

	set work.FunnelWeeksData;

run;

%_eg_hidenotesandsource;

%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;

%_eg_restorenotesandsource;

;*';*";*/;quit;run;
ODS _ALL_ CLOSE;
