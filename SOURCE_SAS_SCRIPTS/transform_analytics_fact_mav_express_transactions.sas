/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Friday, July 10, 2026     TIME: 9:17:26 AM
PROJECT: FactUtaMavExpressTransLedger
PROJECT PATH: U:\Global Reporting and Analytics\System Administrators\SAS\ETL Design\UTA Custom Jobs\UTA Core Fact Tables\FactUtaMavExpressTransLedger\FactUtaMavExpressTransLedger.egp
---------------------------------------- */

/* Library assignment for SASApp.UTACSTRN */
;

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
    STYLE=HTMLBlue
    NOGTITLE
    NOGFOOTNOTE
    GPATH=&sasworklocation
    ENCODING=UTF8
    options(rolap="on")
;

/*   START OF NODE: Historical Data   */

%macro CreateHistoricalData(ProcessingOption=);

%if &ProcessingOption = Full
	%then %do;

		proc sql;

			create table work.ActivityTransHistLedgerData as

			select  
				ledger.trandate,
				ledger.location as locationsourcekey,
				location.longdes as locationdescription,
				location.shortdes as locationshortdescr,
				ledger.patronid,
				person.val_univ_id as employeeid,
				ledger.transidseq_generation,
				ledger.transid,
				ledger.accounttype,
				0 as ApprValueOfTran,
				ledger.completionstatus,
				ledger.reasonmsg,   
				ledger.reasontype,
				ledger.trantype as transtype,
				ledger.currentprimarykey,
				ledger.postdate

			from utacsstg.csg_acttranledgerhist_extract ledger
			left join utacsstg.csg_person_extract person
				on ledger.patronid = person.id_pers
			inner join utacsstg.csg_locationdescription_extract location
				on ledger.location = location.location

			where ledger.patronid is not null
				and ledger.trandate <= datetime()
			

			order by
				ledger.trandate,
				ledger.location asc

			 ;

		quit;

		%put Processing Option is &ProcessingOption and historical data has been generated.;

	%end;

	%if &ProcessingOption = Incremental
		%then %do;

			%put Processing Option is &ProcessingOption and historical data will not be generated.;

			%return;

		%end;

%mend CreateHistoricalData;

%CreateHistoricalData(ProcessingOption = &ProcessingOption);

%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Current Data   */

%macro CreateCurrentData(ProcessingOption=);

%if &ProcessingOption = Full
	%then %do;

		proc sql noprint;

			select distinct
				max(ledgerHist.trandate)

			into :MinProcessingDateTime

			from work.ActivityTransHistLedgerData ledgerHist

			;

		quit;

		proc sql;

			create table work.ActivityTransLedgerData as

			select  
				ledger.trandate,
				ledger.location as locationsourcekey,
				location.longdes as locationdescription,
				location.shortdes as locationshortdescr,
				ledger.patronid,
				person.val_univ_id as employeeid,
				ledger.transidseq_generation,
				ledger.transid,
				ledger.accounttype,
				0 as ApprValueOfTran,
				ledger.completionstatus,
				ledger.reasonmsg,   
				ledger.reasontype,
				ledger.trantype as transtype,
				ledger.currentprimarykey,
				ledger.postdate

			from utacsstg.csg_acttranledger_extract ledger
			left join utacsstg.csg_person_extract person
				on ledger.patronid = person.id_pers
			inner join utacsstg.csg_locationdescription_extract location
				on ledger.location = location.location

			where ledger.trandate <= datetime()
/*			(ledger.trandate > &MinProcessingDateTime*/
/*			and ledger.trandate < dhms(datepart(datetime()), 0, 0, 0))*/
			and ledger.patronid is not null
			

			order by
				ledger.trandate,
				ledger.location asc

			 ;

		quit;

		%put Processing Option is &ProcessingOption and historical data will be appended to current data.;

	%end;

	%if &ProcessingOption = Incremental
		%then %do;

			proc sql;

			create table work.ActivityTransLedgerData as

			select  
				ledger.trandate,
				ledger.location as locationsourcekey,
				location.longdes as locationdescription,
				location.shortdes as locationshortdescr,
				ledger.patronid,
				person.val_univ_id as employeeid,
				ledger.transidseq_generation,
				ledger.transid,
				ledger.accounttype,
				0 as ApprValueOfTran,
				ledger.completionstatus,
				ledger.reasonmsg,   
				ledger.reasontype,
				ledger.trantype as transtype,
				ledger.currentprimarykey,
				ledger.postdate

			from utacsstg.csg_acttranledger_extract ledger
			left join utacsstg.csg_person_extract person
				on ledger.patronid = person.id_pers
			inner join utacsstg.csg_locationdescription_extract location
				on ledger.location = location.location

			where (ledger.trandate > dhms(intnx('day', datepart(datetime()), -1), 0, 0, 0))
			and ledger.trandate <= datetime()
			and ledger.patronid is not null
			

			order by
				ledger.trandate,
				ledger.location asc

			 ;

		quit;

			%put Processing Option is &ProcessingOption and only one day of current data will generated.;

			%return;

		%end;

%mend CreateCurrentData;

%CreateCurrentData(ProcessingOption = &ProcessingOption);

%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Combine Data Sets   */

%macro CombineDataSets(ProcessingOption=);

%if &ProcessingOption = Full
	%then %do;

		proc sql;

			create table work.CombinedDataSets as

			select  
				ledger.trandate,
				ledger.locationsourcekey,
				ledger.locationdescription,
				ledger.locationshortdescr,
				ledger.patronid,
				ledger.employeeid,
				ledger.transidseq_generation,
				ledger.transid,
				ledger.accounttype,
				ledger.apprvalueoftran,
				ledger.completionstatus,
				ledger.reasonmsg,   
				ledger.reasontype,
				ledger.transtype,
				ledger.currentprimarykey,
				ledger.postdate

			from work.ActivityTransHistLedgerData ledger

			union all

			select  
				ledger.trandate,
				ledger.locationsourcekey,
				ledger.locationdescription,
				ledger.locationshortdescr,
				ledger.patronid,
				ledger.employeeid,
				ledger.transidseq_generation,
				ledger.transid,
				ledger.accounttype,
				ledger.apprvalueoftran,
				ledger.completionstatus,
				ledger.reasonmsg,   
				ledger.reasontype,
				ledger.transtype,
				ledger.currentprimarykey,
				ledger.postdate

			from work.ActivityTransLedgerData ledger

			 ;

		quit;

		proc sort data=work.CombinedDataSets;
			
			by
				trandate
				locationsourcekey

			;

		run;


	%end;


	%if &ProcessingOption = Incremental
	%then %do;

		proc sql;

			create table work.CombinedDataSets as

			select  
				ledger.trandate,
				ledger.locationsourcekey,
				ledger.locationdescription,
				ledger.locationshortdescr,
				ledger.patronid,
				ledger.employeeid,
				ledger.transidseq_generation,
				ledger.transid,
				ledger.accounttype,
				ledger.apprvalueoftran,
				ledger.completionstatus,
				ledger.reasonmsg,   
				ledger.reasontype,
				ledger.transtype,
				ledger.currentprimarykey,
				ledger.postdate

			from work.ActivityTransLedgerData ledger

			 ;

		quit;

		proc sort data=work.CombinedDataSets;
			
			by
				trandate
				locationsourcekey

			;

		run;


	%end;

%mend CombineDataSets;

%CombineDataSets(ProcessingOption=&ProcessingOption);

%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;


/*   START OF NODE: Create Table   */

%TransformationTablePrep(TableName=utacstrn.factutamavexptrans_trn);

data utacstrn.factutamavexptrans_trn;

	set work.CombinedDataSets;

run;

%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;

;*';*";*/;quit;run;
ODS _ALL_ CLOSE;
