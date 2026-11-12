/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Saturday, June 27, 2020     TIME: 1:01:36 PM
PROJECT: FactUtaStuClassDashboard
PROJECT PATH: U:\Global Reporting and Analytics\System Administrators\SAS\ETL Design\UTA Custom Jobs\UTA Core Fact Tables\FactUtaStuClassDashboard\FactUtaStuClassDashboard.egp
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
FILENAME EGSRX TEMP;
ODS tagsets.sasreport13(ID=EGSRX) FILE=EGSRX
    STYLE=Plateau
    STYLESHEET=(URL="file:///C:/Program%20Files/SASHome/SASEnterpriseGuide/7.1/Styles/Plateau.css")
    NOGTITLE
    NOGFOOTNOTE
    GPATH=&sasworklocation
    ENCODING=UTF8
    options(rolap="on")
;

/*   START OF NODE: Student Class Dashboard   */
%_eg_hidenotesandsource;

%LET _CLIENTTASKLABEL='Student Class Dashboard';
%LET _CLIENTPROCESSFLOWNAME='Data Sets';
%LET _CLIENTPROJECTPATH='U:\Global Reporting and Analytics\System Administrators\SAS\ETL Design\UTA Custom Jobs\UTA Core Fact Tables\FactUtaStuClassDashboard\FactUtaStuClassDashboard.egp';
%LET _CLIENTPROJECTPATHHOST='UA-127480';
%LET _CLIENTPROJECTNAME='FactUtaStuClassDashboard.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
%_eg_restorenotesandsource;

proc sql;

	create table work.StudentClassDashboard as

	select distinct
		dterm.AcademicYear || ' - ' || put(input(dterm.AcademicYear, 4.)+1,4.) as academicyear,
		dterm.TermType as termtype,
		termHistory.termsourcekey,
		termHistory.termdescription,
		termHistory.sessioncode,
		termHistory.academiccareer,
		termHistory.academicprogramsourcekey,
		termHistory.academicprogramdescription,
		termHistory.employeeid,
		termHistory.studentcareernumber,
		termHistory.campussourcekey,
		termHistory.classnumber,
		termHistory.courseid,
		termHistory.courseofferingnumber,
		deptCollege.collegesourcekey as coursecollegecode,
		deptCollege.collegedescription as coursecollege,
		termHistory.courseacademicorganizationcode as coursedepartmentcode,
		deptCollege.departmentdescription as coursedepartment,
		enrl.CollegeSourceKey as studentcollegecode,
		enrl.CollegeDescription as studentcollegedescription,
		enrl.DepartmentSourceKey as studentdepartmentcode,
		enrl.DepartmentDescription as studentdepartmentdescription,
		enrl.plansourcekey,
		enrl.plandescription,
		enrl.PlanSourceKey || ' - ' || enrl.PlanDescription as studentacademicplan,
		enrl.TuitionResidencyDescription,
		enrl.OverallResidencyDescription,
		termHistory.coursecareer,
		termHistory.coursesubject,
		termHistory.catalognumber,
		termHistory.sectionnumber,
		termHistory.courseinstructionmodesourcekey,
		termHistory.courseinstructionmodedescr,
		termHistory.apsectioninfo,
		termHistory.coursecomponent,
		termHistory.coursedescription,
		termHistory.currentcoursedescription,
		termHistory.coursecipcode,
		termHistory.courserepeatableforcredit,
		termHistory.classlocationsourcekey,
		termHistory.classlocationdescription,
		termHistory.enrollmentadddate,
		termHistory.classstartdate,
		termHistory.classenddate,
		termHistory.gradingbasis,
		termHistory.coursegrade,
		termHistory.failurereason,
		termHistory.coursehours,
		termHistory.coursegradepoints,
		termHistory.courserepeatcode,
		termHistory.courseunitsattempted,
		termHistory.courseunitscompleted,
		termHistory.termsch,
		termHistory.termschnowithdrawals,
		termHistory.censusdatesch,
		termHistory.termgpaattemptedsch,
		termHistory.termnongpaattemptedsch,
		termHistory.termgpacompletedsch,
		termHistory.termnongpacompletedsch,
		termHistory.termattemptedsch,
		termHistory.termcompletedsch,
		termHistory.termgradepoints,
		termHistory.hsdualcreditunitstransferred,
		termHistory.inresidencehsdualcredit,
		termHistory.totalgpaunitsattempted,
		termHistory.totalnongpaunitsattempted,
		termHistory.totalgpaunitscompleted,
		termHistory.totalnongpaunitscompleted,
		termHistory.totalattemptedsch,
		termHistory.totalcompletedsch,
		termHistory.totalgradepoints,
		termHistory.totaltransfercredit,
		termHistory.totaltestcredit,
		termHistory.totalothercredit,
		termHistory.totalcumulativecredit,
		termHistory.termgpa,
		termHistory.cumulativegpa,
		termHistory.gradepointdeficit,
		termHistory.academicloaddescription,
		termHistory.academiclevelsourcekey,
		termHistory.academicleveldescription,
		termHistory.academicstandingsourcekey,
		termHistory.academicstandingdescription,
		termHistory.studentinstructionmodedescr,
		termHistory.censusdateenrollcategorydescr,
		termHistory.firsttermofenrollmentsourcekey,
		termHistory.firsttermofenrollmentdescr,
		termHistory.expectedgradtermsourcekey,
		termHistory.expectedgradtermdescr,
		termHistory.priortermofenrollmentsourcekey,
		termHistory.priortermofenrollmentdescr,
		termHistory.stureportingretentionclassif,
		termHistory.studentreportingclassifdescr,
		termHistory.transferstudentflag,
		termHistory.admittermsourcekey,
		termHistory.admittermdescription,
		termHistory.admittypesourcekey,
		termHistory.admittypedescription,
		termHistory.applicationnumber,
		termHistory.lastschoolattendedorgid,
		termHistory.lastschoolattendedorgdescr,
		termHistory.dualcreditflag

	from utacstgt.factutastucourseandtermhistory termHistory
	inner join utacstgt.dimutadeptcollege deptCollege
		on termHistory.courseacademicorganizationcode = deptCollege.departmentsourcekey
	inner join utacstgt.factutaenrollment enrl
		on termHistory.EmployeeID = enrl.EmployeeID
		and termHistory.AcademicCareer = enrl.AcademicCareer
		and termHistory.TermSourceKey = enrl.TermSourceKey
	inner join utacstgt.DimUtaTerm dterm
		on termHistory.TermSourceKey = dterm.SourceKey

	where termHistory.termsourcekey >= &MinProcessingTerm

	;

quit;


%_eg_hidenotesandsource;

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;

%_eg_restorenotesandsource;


/*   START OF NODE: FactUtaStuClassDashboard_TRN   */
%_eg_hidenotesandsource;

%LET _CLIENTTASKLABEL='FactUtaStuClassDashboard_TRN';
%LET _CLIENTPROCESSFLOWNAME='Data Sets';
%LET _CLIENTPROJECTPATH='U:\Global Reporting and Analytics\System Administrators\SAS\ETL Design\UTA Custom Jobs\UTA Core Fact Tables\FactUtaStuClassDashboard\FactUtaStuClassDashboard.egp';
%LET _CLIENTPROJECTPATHHOST='UA-127480';
%LET _CLIENTPROJECTNAME='FactUtaStuClassDashboard.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
%_eg_restorenotesandsource;

proc lua;
submit;
	if not sas.exists("utacstrn.FactUtaStuClassDashboard_TRN") 
		then print("Transformation Table does not exist. Skipping drop.")
		else sas.submit [[
			proc sql; drop table utacstrn.FactUtaStuClassDashboard_TRN; quit;
		]]
	end
endsubmit;
run;

proc sql;

	create table utacstrn.FactUtaStuClassDashboard_TRN as

	select distinct
		classDash.academicyear,
		classDash.termtype,
		classDash.termsourcekey,
		classDash.termdescription,
		classDash.sessioncode,
		classDash.academiccareer,
		classDash.academicprogramsourcekey,
		classDash.academicprogramdescription,
		classDash.employeeid,
		classDash.studentcareernumber,
		classDash.campussourcekey,
		classDash.classnumber,
		classDash.courseid,
		classDash.courseofferingnumber,
		classDash.coursecollegecode,
		classDash.coursecollege,
		classDash.coursedepartmentcode,
		classDash.coursedepartment,
		classDash.studentcollegecode,
		classDash.studentcollegedescription,
		classDash.studentdepartmentcode,
		classDash.studentdepartmentdescription,
		classDash.plansourcekey,
		classDash.plandescription,
		classDash.studentacademicplan,
		classDash.tuitionresidencydescription,
		classDash.overallresidencydescription,
		classDash.coursecareer,
		classDash.coursesubject,
		classDash.catalognumber,
		classDash.sectionnumber,
		classDash.courseinstructionmodesourcekey,
		classDash.courseinstructionmodedescr,
		classDash.apsectioninfo,
		classDash.coursecomponent,
		classDash.coursedescription,
		classDash.currentcoursedescription,
		classDash.coursecipcode,
		classDash.courserepeatableforcredit,
		classDash.classlocationsourcekey,
		classDash.classlocationdescription,
		classDash.enrollmentadddate,
		classDash.classstartdate,
		classDash.classenddate,
		classDash.gradingbasis,
		classDash.coursegrade,
		classDash.failurereason,
		classDash.coursehours,
		classDash.coursegradepoints,
		classDash.courserepeatcode,
		classDash.courseunitsattempted,
		classDash.courseunitscompleted,
		classDash.termsch,
		classDash.termschnowithdrawals,
		classDash.censusdatesch,
		classDash.termgpaattemptedsch,
		classDash.termnongpaattemptedsch,
		classDash.termgpacompletedsch,
		classDash.termnongpacompletedsch,
		classDash.termattemptedsch,
		classDash.termcompletedsch,
		classDash.termgradepoints,
		classDash.hsdualcreditunitstransferred,
		classDash.inresidencehsdualcredit,
		classDash.totalgpaunitsattempted,
		classDash.totalnongpaunitsattempted,
		classDash.totalgpaunitscompleted,
		classDash.totalnongpaunitscompleted,
		classDash.totalattemptedsch,
		classDash.totalcompletedsch,
		classDash.totalgradepoints,
		classDash.totaltransfercredit,
		classDash.totaltestcredit,
		classDash.totalothercredit,
		classDash.totalcumulativecredit,
		classDash.termgpa,
		classDash.cumulativegpa,
		classDash.gradepointdeficit,
		classDash.academicloaddescription,
		classDash.academiclevelsourcekey,
		classDash.academicleveldescription,
		classDash.academicstandingsourcekey,
		classDash.academicstandingdescription,
		classDash.studentinstructionmodedescr,
		classDash.censusdateenrollcategorydescr,
		classDash.firsttermofenrollmentsourcekey,
		classDash.firsttermofenrollmentdescr,
		classDash.expectedgradtermsourcekey,
		classDash.expectedgradtermdescr,
		classDash.priortermofenrollmentsourcekey,
		classDash.priortermofenrollmentdescr,
		classDash.stureportingretentionclassif,
		classDash.studentreportingclassifdescr,
		classDash.transferstudentflag,
		classDash.admittermsourcekey,
		classDash.admittermdescription,
		classDash.admittypesourcekey,
		classDash.admittypedescription,
		classDash.applicationnumber,
		classDash.lastschoolattendedorgid,
		classDash.lastschoolattendedorgdescr,
		classDash.dualcreditflag

	from work.StudentClassDashboard classDash

	;

quit;

%_eg_hidenotesandsource;

GOPTIONS NOACCESSIBLE;
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
