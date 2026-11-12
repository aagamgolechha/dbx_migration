/************************************************************************************************************************/
/*		FileName: VAT Control.sas                                                                                       
/*		Author: Justin Ashby                                                                                            
/*      Creation Date:                                                                                                  
/*      Description: Promotion Forecast                                                                            
/*                                                                                                                      
/*      Revisions:                                                                                                      
/*		Date         Author  Description                                                                                                                                                 
/*      1/09/2009   Ashby   Replaces the Special Allowance Forecast
/*      5/20/2009   Wilfred  Capped RPV to use Volume Percents when lowest level is not GM and Calc RPV is greater than Vol Per RPV
/*      3/25/2010   Wilfred  Moved vol percents oracle read from database to file in build directory
/*      9/29/2010   Ashby  Added logic to weight the rates differently by strong/weak alc type
/*		10/28/2010  Ashby  For 2011 added logic for Manual RPV (ManualRPVCap macro) & Promo Percents (PromoPercents macro)
/*		1/27/2011   TRE Added above comment to identify what changed in this version
/*		2/3/2012	TRE Changed the write out of the QD Tier Weights to no longer go to Justins directory
/*		2/23/2012	TRE Added overwrite of zeroFcst for new promos - search on date
/*	    10/18/2012	TRE Changed Excel files to be 2007 - was blowing limit on number of rows
/*		10/24/2012	TRE Removed the delete of tierWeights_Out and QDs_NotWghtd
/*		12/4/2012	TRE Added NEWFILE = Yes to the first write out of QD Tier Weights
/*		10/28/2013  TRE Added logic to combine 24oz pkgs with 25oz pkgs to make a new proxy for 25oz pkgs
/************************************************************************************************************************/

/*
	- Temporary wslr read-in added - search for tabledir 
		Manually add missing wslr to \\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Rev Planning\Active\Tables\TOTAL\WslrSASManual.xlsb
*/

%** 10/28/2013 - the following will merge 24oz and 25oz pkgs to create new 25oz records to get better RPV proxy **;
*%include '\\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Database\Active\SAS\Scheduled Tasks\Promo Fcst\Combine RPV Proxy.sas';

*Blaz - New proxy file logic;
*%include '\\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Rev Planning\Active\Josh\RPV Proxy.sas';

/*Need to make variable for proxy year evaluate automatically -- refer to SAS load outfile */

/*
data _null_;
call symputx('yr', put(intnx('month',today(),-1,'B'),year2.));
run;
*/

data Rvsd_PriorYrProxy;
	set "\\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Database\Active\SAS\Promotion\PYE\Data_Files\Build_Files\&priorYrProxy..sas7bdat";
run;



%** Promotion Forecast JLA 1-9-09 **;
%** Replaces the Special Allowance Forecast **;

%** Weights for the day adjustment logic **;
%**%let rpvDayWght = .65; %** RPV per day weight --  **;
%**%let calDayWght = .35; %** Calendar per day weight **;

%LET ZERORPV  = 'N'; * 'Y'=ALLOW ZERO RPV  'N'=USE HIGHER PROXY FOR ZEROS=Everything will get a proxy *;
%** when set to N will zero out the volume in months that a WBL did not promote **;
%** will not allow a WBL M to get a 0 RPV proxy **;

%* RPV PROXY ORDER =========================================================;
%LET RPV1  = WBLM ;       %* Wholesaler Level *   ;
%LET RPV2  = WBL6 ;       
%LET RPV3  = WFLM ;     
%LET RPV4  = WFL6 ;       

%LET RPV5  = MBLM ;       %* State/MCA Level *   ;
%LET RPV6  = MBL6 ;       
%LET RPV7  = MFLM ;  
%LET RPV8  = MFL6 ;  

%LET RPV9  = DBLM ;       %* State/Sales Area Level (D = Sales Director)*   ;      
%LET RPV10 = DBL6 ;       
%LET RPV11 = DFLM ;  
%LET RPV12 = DFL6 ;  

%LET RPV13 = SBLM ;       %* State Level *   ;  
%LET RPV14 = SBL6 ;       
%LET RPV15 = SFLM ;   
%LET RPV16 = SFL6 ; 
%LET RPV17 = SFT6 ;       %* Alternate Pkg Level *; 
%LET RPV18 = STL6 ;       %* Alternate Family Level *; 
%LET RPV19 = STT6 ;       %* Alternate Family & Pkg Level *; 
%LET RPV20 = SALM ;      
%LET RPV21 = SAL6 ;     

%LET RPV22 = ABL6 ;       %* Total US Level *    ;
%LET RPV23 = AFL6 ;       
%LET RPV24 = AAA6 ;       
%LET PROXIES=24   ;       %* SET TO THE TOTAL NUMBER OF PROXIES ABOVE;

%macro runfixlines;
   %if &readSnap ^= PlanB_PREV %then %do;
      &fixlines;
   %end;
%mend runfixlines;

%** this macro will setup the RPV proxies sort, summary, and merge statements **;
%MACRO MAKEBY;
  %DO I=1 %TO &PROXIES+0 ;
   %GLOBAL RPV&I.A RPV&I.B RPV&I.C SORT&I. MERGE&I
           BY&I.A BY&I.B BY&I.C TIME&I ;
   %** Geo level parameters **;
   %IF %SUBSTR(&&RPV&I..1,1,1)=W %THEN %LET BY&I.A=%STR(WSLR);
   %IF %SUBSTR(&&RPV&I..1,1,1)=M %THEN %LET BY&I.A=%STR(STATE MCA);
   %IF %SUBSTR(&&RPV&I..1,1,1)=D %THEN %LET BY&I.A=%STR(STATE wslrsdir);
   %IF %SUBSTR(&&RPV&I..1,1,1)=S %THEN %LET BY&I.A=%STR(STATE);
   %IF %SUBSTR(&&RPV&I..1,1,1)=A %THEN %LET BY&I.A=%STR( );
   %** Brand level parameters **;
   %IF %SUBSTR(&&RPV&I..1,2,1)=B %THEN %LET BY&I.B=%STR(BND);
   %IF %SUBSTR(&&RPV&I..1,2,1)=F %THEN %LET BY&I.B=%STR(shortfam);
   %IF %SUBSTR(&&RPV&I..1,2,1)=A %THEN %LET BY&I.B=%STR( );
   %IF %SUBSTR(&&RPV&I..1,2,1)=T %THEN %LET BY&I.B=%STR(altfam);
   %** Package level parameters **;
   %IF %SUBSTR(&&RPV&I..1,3,1)=L %THEN %LET BY&I.C=%STR(LINE);
   %IF %SUBSTR(&&RPV&I..1,3,1)=A %THEN %LET BY&I.C=%STR( );
   %IF %SUBSTR(&&RPV&I..1,3,1)=T %THEN %LET BY&I.C=%STR(altline);
   %** Time frame parameters **;
   %IF %SUBSTR(&&RPV&I..1,4,1)=Y %THEN %LET TIME&I=YEAR-TO-DATE;
   %IF %SUBSTR(&&RPV&I..1,4,1)=P %THEN %LET TIME&I=PREV YEAR-END;
   %IF %SUBSTR(&&RPV&I..1,4,1)=M %THEN %LET TIME&I=MONTH (PREV YEAR);
   %IF %SUBSTR(&&RPV&I..1,4,1)=3 %THEN %LET TIME&I=3 MONTH MOVING AVG;
   %IF %SUBSTR(&&RPV&I..1,4,1)=6 %THEN %LET TIME&I=6 MONTH MOVING AVG;
   %IF %SUBSTR(&&RPV&I..1,4,1)=9 %THEN %LET TIME&I=9 MONTH MOVING AVG;
   %IF %SUBSTR(&&RPV&I..1,4,1)=2 %THEN %LET TIME&I=12 MONTH MOVING AVG;
   %LET BY&I. = BY &&BY&I.A &&BY&I.B &&BY&I.C ;
   %LET MERGE&I =%STR(PROC SORT DATA=RPV ;
                   BY &&BY&I.A &&BY&I.B &&BY&I.C ;
                   DATA RPV (KEEP = WSLR MCA STATE wslrsdir BND shortfam altfam altline LINE RPV1-RPV12 PROXY_USED1-PROXY_USED12 
									days1-days12);
                      MERGE RPV (IN=A) VOL&I (IN=B);
                      BY &&BY&I.A &&BY&I.B &&BY&I.C ;
                      IF RPV1  = . THEN RPV1  = PROXY1;
                      IF RPV2  = . THEN RPV2  = PROXY2;
                      IF RPV3  = . THEN RPV3  = PROXY3;
                      IF RPV4  = . THEN RPV4  = PROXY4;
                      IF RPV5  = . THEN RPV5  = PROXY5;
                      IF RPV6  = . THEN RPV6  = PROXY6;
                      IF RPV7  = . THEN RPV7  = PROXY7;
                      IF RPV8  = . THEN RPV8  = PROXY8;
                      IF RPV9  = . THEN RPV9  = PROXY9;
                      IF RPV10 = . THEN RPV10 = PROXY10;
                      IF RPV11 = . THEN RPV11 = PROXY11;
					  IF RPV12 = . THEN RPV12 = PROXY12; 
					  IF days1  = . THEN days1  = dayProxy1;
                      IF days2  = . THEN days2  = dayProxy2;
                      IF days3  = . THEN days3  = dayProxy3;
                      IF days4  = . THEN days4  = dayProxy4;
                      IF days5  = . THEN days5  = dayProxy5;
                      IF days6  = . THEN days6  = dayProxy6;
                      IF days7  = . THEN days7  = dayProxy7;
                      IF days8  = . THEN days8  = dayProxy8;
                      IF days9  = . THEN days9  = dayProxy9;
                      IF days10 = . THEN days10 = dayProxy10;
                      IF days11 = . THEN days11 = dayProxy11;
					  IF days12 = . THEN days12 = dayProxy12; 
					  IF PROXY_USED1 = . THEN PROXY_USED1 = TRACKPROXY1;
					  IF PROXY_USED2 = . THEN PROXY_USED2 = TRACKPROXY2;
					  IF PROXY_USED3 = . THEN PROXY_USED3 = TRACKPROXY3;
					  IF PROXY_USED4 = . THEN PROXY_USED4 = TRACKPROXY4;
					  IF PROXY_USED5 = . THEN PROXY_USED5 = TRACKPROXY5;
					  IF PROXY_USED6 = . THEN PROXY_USED6 = TRACKPROXY6;
					  IF PROXY_USED7 = . THEN PROXY_USED7 = TRACKPROXY7;
					  IF PROXY_USED8 = . THEN PROXY_USED8 = TRACKPROXY8;
					  IF PROXY_USED9 = . THEN PROXY_USED9 = TRACKPROXY9;
				   	  IF PROXY_USED10 = . THEN PROXY_USED10 = TRACKPROXY10;
				      IF PROXY_USED11 = . THEN PROXY_USED11 = TRACKPROXY11;
					  IF PROXY_USED12 = . THEN PROXY_USED12 = TRACKPROXY12; );
   %** Total US / All Brands / All Packages **;
   %IF %SUBSTR(&&RPV&I..1,1,3)=AAA %THEN %LET
       MERGE&I =%STR( DATA VOL&I;
                      SET VOL&I;
                      X=1;
                      DATA RPV;
                      SET RPV;
                      X=1;
                      PROC SORT DATA=VOL&I ; BY X;
                      PROC SORT DATA=RPV;    BY X;
                      DATA RPV (KEEP = WSLR MCA STATE wslrsdir BND shortfam altfam altline LINE RPV1-RPV12 PROXY_USED1-PROXY_USED12
								days1-days12);
                        MERGE RPV (IN=A) VOL&I (IN=B);
                        BY X;
                        IF RPV1  = . THEN RPV1  = PROXY1;
                        IF RPV2  = . THEN RPV2  = PROXY2;
                        IF RPV3  = . THEN RPV3  = PROXY3;
                        IF RPV4  = . THEN RPV4  = PROXY4;
                        IF RPV5  = . THEN RPV5  = PROXY5;
                        IF RPV6  = . THEN RPV6  = PROXY6;
                        IF RPV7  = . THEN RPV7  = PROXY7;
                        IF RPV8  = . THEN RPV8  = PROXY8;
                        IF RPV9  = . THEN RPV9  = PROXY9;
                        IF RPV10 = . THEN RPV10 = PROXY10;
                        IF RPV11 = . THEN RPV11 = PROXY11;
                        IF RPV12 = . THEN RPV12 = PROXY12; 	
						IF days1  = . THEN days1  = dayProxy1;
                      	IF days2  = . THEN days2  = dayProxy2;
                      	IF days3  = . THEN days3  = dayProxy3;
                      	IF days4  = . THEN days4  = dayProxy4;
                      	IF days5  = . THEN days5  = dayProxy5;
                      	IF days6  = . THEN days6  = dayProxy6;
                      	IF days7  = . THEN days7  = dayProxy7;
                      	IF days8  = . THEN days8  = dayProxy8;
                      	IF days9  = . THEN days9  = dayProxy9;
                        IF days10 = . THEN days10 = dayProxy10;
                        IF days11 = . THEN days11 = dayProxy11;
					    IF days12 = . THEN days12 = dayProxy12; 
					  	IF PROXY_USED1 = . THEN PROXY_USED1 = TRACKPROXY1;
					  	IF PROXY_USED2 = . THEN PROXY_USED2 = TRACKPROXY2;
					  	IF PROXY_USED3 = . THEN PROXY_USED3 = TRACKPROXY3;
					  	IF PROXY_USED4 = . THEN PROXY_USED4 = TRACKPROXY4;
					  	IF PROXY_USED5 = . THEN PROXY_USED5 = TRACKPROXY5;
					  	IF PROXY_USED6 = . THEN PROXY_USED6 = TRACKPROXY6;
					  	IF PROXY_USED7 = . THEN PROXY_USED7 = TRACKPROXY7;
					  	IF PROXY_USED8 = . THEN PROXY_USED8 = TRACKPROXY8;
					  	IF PROXY_USED9 = . THEN PROXY_USED9 = TRACKPROXY9;
				   	  	IF PROXY_USED10 = . THEN PROXY_USED10 = TRACKPROXY10;
				      	IF PROXY_USED11 = . THEN PROXY_USED11 = TRACKPROXY11;
					  	IF PROXY_USED12 = . THEN PROXY_USED12 = TRACKPROXY12; );
   %IF %SUBSTR(&&RPV&I..1,1,3)=AAA
       %THEN %LET SORT&I.=
             %STR(PROC SUMMARY DATA=VOL0;
                    VAR VOL1-VOL&NEWCLOSE
                        actGPV1-actGPV&NEWCLOSE dayWght1-dayWght&NEWCLOSE;
                        OUTPUT OUT=VOL&I. (drop= _type_ _freq_) SUM=;);  %** Total US / All Brands / All Pkgs Summary **;
       %ELSE %LET SORT&I.=
             %STR(PROC SORT DATA=VOL0;
                    BY &&BY&I.A &&BY&I.B &&BY&I.C ;
                  PROC SUMMARY DATA=VOL0;
                    BY &&BY&I.A &&BY&I.B &&BY&I.C ;
                    VAR VOL1-VOL&NEWCLOSE
                        actGPV1-actGPV&NEWCLOSE dayWght1-dayWght&NEWCLOSE;
                        OUTPUT OUT=VOL&I. (drop= _type_ _freq_) SUM=;);   %** Sort and Summary for proxy combinations **;
   %END;
%MEND MAKEBY;
%MAKEBY;

%** read in the modified special allowance snapshot **;
	%macro readSnapSpec;
	 	%if &readSnap = PlanB_BNAAP %then %do;
  			set snaps.Modsnapbnaap&snapYear.;
		%end;
		%else %if &readSnap = PlanB_UNAPP %then %do;
  			set snaps.Modsnapunapp&snapYear.;
		%end;
		%else %if &readSnap = PlanB_PREV %then %do;
  			set snaps.Modsnapprev&snapYear.;
		%end;
		%else %if &readSnap = PlanB %then %do;
			set snaps.special_snap&snapYear.;	
		%end;
		%else %if &readSnap = VolPer %then %do;
			set snaps.PlanB&snapYear.;	
		%end;
		%else %if &readSnap = VolPer_BNAAP %then %do;
			set snaps.special_snapVolumePercentsBNAAP&snapYear.;	
		%end;
		%else %if &readSnap = Pcr_UNAPP %then %do;
  			set snaps.ModsnapPcrunapp&snapYear.;
		%end;
	%mend readSnapSpec;

	%MACRO Days;
		%DO I=1 %TO 12;
	         M=PUT(&I,Z2.);
	         SELECT(M);
	           WHEN('01') DAYS=31;
	           WHEN('02') DAYS=28;
	           WHEN('03') DAYS=31;
	           WHEN('04') DAYS=30;
	           WHEN('05') DAYS=31;
	           WHEN('06') DAYS=30;
	           WHEN('07') DAYS=31;
	           WHEN('08') DAYS=31;
	           WHEN('09') DAYS=30;
	           WHEN('10') DAYS=31;
	           WHEN('11') DAYS=30;
	           WHEN('12') DAYS=31;
	           OTHERWISE;
	         END;
			 Days&I = 0; %** Init To Zero **;
	         MON1 = INPUT("&YEAR"||M||'01',YYMMDD8.);
			 %** Same Month **;
	         IF MONTH(FROMDATE)=&I AND MONTH(THRUDATE)=&I THEN
	            Days&I = THRUDATE - FROMDATE + 1 ;
			 %** Start Month **;
	         ELSE IF MONTH(FROMDATE)=&I THEN
	            Days&I = DAYS-(FROMDATE-MON1);
			 %** End Month **;
	         ELSE IF MONTH(THRUDATE)=&I THEN
	            Days&I = THRUDATE - MON1 + 1 ;
			 %** Crosses Entire Month -- Month b/w Start and End **;
	         ELSE IF MONTH(FROMDATE)<&I AND MONTH(THRUDATE)>&I THEN
	            Days&I = DAYS;
	         ELSE Days&I = 0 ;
		%End;
	%Mend Days;

data forecastData (bufno=64);
	%readSnapSpec;
	%** rename the variables on the snapshot to be actDol and actGpv **;
	rename paid1-paid12 = actdol1-actdol12;
	rename gpv1-gpv12 = actgpv1-actgpv12;
	*&xalliance; %** remove any alliance brand dollars and calendars **;
	%runfixlines;
	%** for forecasting purposes, make the trans pack promotions a level 3 if they are coded as general market **;
	%** in states where channel pricing is illegal but the trans pack is sold, the trans pack promo will be coded **;
	%** as a general market promotion, even though it will just be sold to airlines/trains/etc... JLA 7/16/08**;
	if grp = 568 and rtl_level = '1' then do;
		rtl_level = '3';
	end;
	%Days;
	keep wslr bnd line grp rtl_level civmil alc_ind fromdate thrudate sug_disc max_rate qd_group on_off_prem status 
			becv state paid1-paid12 gpv1-gpv12 qdLow qdHigh prom_type aappaid1-aappaid12 aapgpv1-aapgpv12 
			promosPaid1-promosPaid12 days1-days12;
run;

%** calculate percents to use for the rates if the AB-IT promo percents are not available **;
data rateWeights rateWeightsGM (bufno=64);
	set forecastData;
	array maxRates{12} maxRates1-maxRates12;
	array maxDisc{12} maxDisc1-maxDisc12;
	array promoDays{12} promoDays1-promoDays12;
	*array GMpromoDays{12} GMpromoDays1-GMpromoDays12;
	array Days{12} Days1-Days12;
	%** if disc is missing then assume 50/50 split **;
	if sug_disc = 0 then sug_disc = max_rate * 2;
	do i = 1 to 12;
		%** If the promo is in the month... **;
		if month(fromdate) <= i <= month(thrudate) then do;
			maxRates{i} =  max_rate;
			maxDisc{i} 	=  sug_disc;
			promoDays{i} = Days{i}; %** give each rec the number of days it touches in each month **;
		end;
	end;
	%*maxRates{month(fromdate)} = max_rate; 
	%*maxDisc{month(fromdate)} = sug_disc; 
	%*promoDays{month(fromdate)} = (thrudate-fromdate)+1;
	promoFlag = 1;
	%** Determine if a promo is GM and should be kept for GM calculations **;
	%** must be at least 7 days long in order to be considered GM **; 
	%** check the total GM promo days in the month as well - If both the specific promo and the total months GM days **;
	%** are less than 7 then dont consider the promo GM - if the total month is > than 7 but the specific promo **;
	%** isnt, then the specific promo will be kept **;
	*if promoDays{month(fromdate)} < 7 and GMpromoDays{month(fromdate)} < 7 then promoFlag = 2;
	if rtl_level ne 1 then promoFlag = 2; %** rtl_level = 1 is GM **;
	%** keep all GM promos, regardless of On/Off specificity **;
	%*if on_off_prem ne 'B' then promoFlag = 2; %** must be for both on and off premise **;
	if civmil ne 'B' then promoFlag = 2; %** must be for both Civilian and Military accounts **;
	%** keep all GM promos, regardless of alcohol specificity **;
	%** if alc_ind ne 'A' then promoFlag = 2; %** must apply to all alcohol strengths **;
	if promoFlag = 2 then output rateWeights;
		else output rateWeightsGM; %** will contain GM promos only **;
	keep wslr bnd line grp maxRates1-maxRates12 promoDays1-promoDays12 rtl_level qd_group 
			civmil on_off_prem alc_ind qdLow qdHigh prom_type maxDisc1-maxDisc12; 
run;

proc sort data = rateWeights;
	by wslr bnd line rtl_level qd_group;
	run;
proc sort data = rateWeightsGM;
	by wslr bnd line rtl_level qd_group;
	run;

%** get the average rate within each each tier and group of QDs in that tier **;
%** this step will collapse the QDs in each tier **;
%** taking the average of the days at this level will result giving each grp of QDs the number of days it is on **;
%** all of the QDs within a qd_group will have the same number of days so the average will just give the number **;
%** of days for that qd_group.  For all other promos, they will have a unique qd_group identifier so there will be **;
%** nothing to average for either the maxRate or the promoDays **;
proc summary data = rateWeights; %** first, roll up to the WBL level for non GM promos **;
	by wslr bnd line rtl_level qd_group; %** lose grp code level detail at this point **;
	var maxRates1-maxRates12 promoDays1-promoDays12 maxDisc1-maxDisc12;
	id civmil on_off_prem alc_ind; %** these will be the same for each qd_group **;
	output out = rateWeights(drop = _type_ _freq_) mean=;

proc sort data = rateWeightsGM;
	by wslr bnd line rtl_level qd_group qdLow qdHigh; %** sort by low and high before making the lowHigh var **;
run;
%** before taking the avg QD rate, attempt to match up the QD with the Qd Tier Weights **;
data rateWeightsGM (bufno=64);
	set rateWeightsGM;
	format lowHigh $10.;
	%** concat the qdLow and qdHigh flags to create a single qd flag variable for each record **;
	%** the var is created AFTER the data is sorted by wslr bnd line mnth qdLow qdHigh **;
	lowHigh = trim(left(qdLow)) || "-" || trim(left(qdHigh));
run;
data rateWeightsGM_QD (bufno=64);
	set rateWeightsGM;
	keep wslr bnd line qd_group lowHigh prom_type;
run;
%** keep one record for each tier in the group **;
proc sort data = rateWeightsGM_QD nodupkey;
	by wslr bnd line qd_group lowHigh;
run;
data trackQDsWeighted;
	set rateWeightsGM_QD;
	if prom_type = 'QD';
run;

%** create the QD_LowHigh grouping for each group of QDs **;
proc sort data = rateWeightsGM_QD;
	by wslr bnd line qd_group lowHigh; %** low high will be a text based sort **;
run;
%** make each WBL have the tiers that are tied to it monthly, in a column format **;
proc transpose data = rateWeightsGM_QD out=rateWeightsGM_QDList (drop= _name_);
	by wslr bnd line qd_group;
	var lowHigh;
run;

%** create a dataset that has information about the variables in the rateWeightsGM_QDList dataset **;
proc contents data = rateWeightsGM_QDList out=rateWeightsGM_QDListContents noprint;
run;
%** get the number of columns by using the contents dataset **;
proc sql noprint; 
	select count(*)
		into :numCols 
		from work.rateWeightsGM_QDListContents;
	quit;

%let numCols = %eval(&numCols-4);  %** subtract 4 b/c of the wslr bnd line qd_group columns **;
%put "&numCols.";

data rateWeightsGM_QDList;
	set rateWeightsGM_QDList;
	format QD_LowHigh $250.;
	%macro makeTierList;
		%do i = 1 %to &numCols;
			%if &i = 1 %then %do;
				QD_LowHigh =  trim(col&i.) || ",";
			%end;
			%else %if &i = &numCols %then %do;
				if lengthn(col&i.) > 0  then do;
					QD_LowHigh = trim(QD_LowHigh) || trim(col&i.) || ",";
				end;
			%end;
			%else %do;
				if lengthn(col&i.) > 0 then do;
					QD_LowHigh = trim(QD_LowHigh) || trim(col&i.) || ",";
				end;
			%end;
		%end;
		%*** trim off the last , ***;
		QD_LowHigh = substr(QD_LowHigh,1,lengthn(QD_LowHigh)-1);
	%mend makeTierList; %makeTierList;
	keep wslr bnd line qd_group QD_LowHigh;
run;

%** merge in the list of QDs back with all of the tiers;
proc sort data = rateWeightsGM_QDList;
	by wslr bnd line qd_group;
	run;
proc sort data = rateWeightsGM_QD;
	by wslr bnd line qd_group;
	run;

data rateWeightsGM_QD (bufno=64);
	merge rateWeightsGM_QD (in=a) rateWeightsGM_QDList (in=b);
	by wslr bnd line qd_group;
	if a and b;
run;

%** bring in the tier weights @ the WBL level **;
data tierWeights;
	set build.tierWeightsWBL;
	keep wslr bnd line lowHigh QD_LowHigh tierWght;
	run;

proc sort data = tierWeights;
	by wslr bnd line lowHigh QD_LowHigh;
	run;
proc sort data = rateWeightsGM_QD;
	by wslr bnd line lowHigh QD_LowHigh;
	run;

options missing = .; %** ensure that missing values are treated as . **;
data rateWeightsGM_QD;
	merge rateWeightsGM_QD(in=a) tierWeights (in=b);
	by wslr bnd line lowHigh QD_LowHigh;
	if a; %** keep the promos if they are in the GM_QD data **;
	%** tier weights in only GM QD data **;
run;

%** try to merge in the family level rate weights **;
data tierWeightsFam;
	set build.tierWeightsWFL;
	rename tierWght = famTierWght;
	keep wslr family line lowHigh QD_LowHigh tierWght;

data rateWeightsGM_QD (bufno=64);
	set rateWeightsGM_QD;
	%makefamsmart;
	keep wslr bnd line lowHigh QD_LowHigh family prom_type qd_group tierWght; 

proc sort data =rateWeightsGM_QD;
	by wslr family line lowHigh QD_LowHigh;
	run;
proc sort data =tierWeightsFam;
	by wslr family line lowHigh QD_LowHigh;
	run;

data rateWeightsGM_QD (bufno=64);
	merge rateWeightsGM_QD(in=a) tierWeightsFam (in=b);
	by wslr family line lowHigh QD_LowHigh;
	if a; %** keep the promos if they are in the GM_QD data **;
	%** tier weights in only GM QD data **;
run;

%** try to merge in the state level rate weights **;
data tierWeightsState;
	set build.tierWeightsSFL;
	rename tierWght = stateTierWght;
	keep state family line lowHigh QD_LowHigh tierWght;

* Temporary wslr read-in added on 10/12/23;
	%let exceldir = \\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Rev Planning\Active\Tables\TOTAL\;  
	%let excel_fl = WslrSASManual.xlsb;  
	%let resname = "&exceldir.&excel_fl.";
	proc import out = wslrInfoTemp
		datafile = &resname
	   	dbms=excel replace;
		getnames = yes;
	run;
	data wslrInfoTemp;
		set wslrInfoTemp;
		if reg not in (90);
	run;
	proc sort data = wslrInfoTemp;
		by wslr;

data wslrInfo;
*  set tableDir.wslr;
  set wslrInfoTemp;
  keep wslr state;

proc sort data = wslrInfo nodupkey;
	by wslr;

proc sort data = rateWeightsGM_QD;
	by wslr;

data rateWeightsGM_QD (bufno=64);
	merge rateWeightsGM_QD (in=a) wslrInfo (in=b);
	by wslr;
	if a;
run;

proc sort data =rateWeightsGM_QD;
	by state family line lowHigh QD_LowHigh;
proc sort data =tierWeightsState;
	by state family line lowHigh QD_LowHigh;

data rateWeightsGM_QD (bufno=32);
	merge rateWeightsGM_QD(in=a) tierWeightsState (in=b);
	by state family line lowHigh QD_LowHigh;
	if a; %** keep the promos if they are in the GM_QD data **;
	%** tier weights in only GM QD data **;
run;

proc sort data = rateWeightsGM_QD;
	by wslr bnd line lowHigh QD_LowHigh;

data rateWeightsGM_QD;
	set rateWeightsGM_QD;
	format tierUsed $3.;
	if tierWght ~= . then tierUsed = 'WBL'; %** keep track of which weight was used **;
	if tierWght = . then do;
		tierWght = famTierWght; %** attempt to use the WFL weight if no WBL weight is found **;
		tierUsed = 'WFL';
	end;
	if tierWght = . then do;
		tierWght = stateTierWght;  %** attempt to use the SFL weight if no WFL weight is found **;
		tierUsed = 'SFL';
	end;
	if tierWght = . then delete; %** delete the records that were not found in tierWeights **;
	drop family famTierWght stateTierWght state;

%** ensure that the wghts sum up to 100% for each QD group **;
proc sort data = rateWeightsGM_QD;
	by wslr bnd line qd_group;
proc summary data = rateWeightsGM_QD;
	by wslr bnd line qd_group;
	var tierWght;
	output out = tierWghtChk (drop= _type_ _freq_) sum=tierWghtTotal;
run;

%** add in the total wght to the detail records **;
data rateWeightsGM_QD;
	merge rateWeightsGM_QD (in=a) tierWghtChk(in=b);
	by wslr bnd line qd_group;
	if a and b;

%** delete any records that have an incorrect wght **;
data rateWeightsGM_QD;
	set rateWeightsGM_QD;
	if round(tierWghtTotal) ~= 1 then delete;
	drop tierWghtTotal;
run;

%** merge in the weight info with the main data set **;
proc sort data = rateWeightsGM_QD;
	by wslr bnd line qd_group lowHigh;
proc sort data = rateWeightsGM;
	by wslr bnd line qd_group lowHigh;

%** rateWeightsGM has every promotion -- rateWeightsGM_QD has the QDs with the weight information **;
data rateWeightsGM (bufno=32);
	merge rateWeightsGM (in=a) rateWeightsGM_QD (in=b);
	by wslr bnd line qd_group lowHigh;
	if a;
run;

data rateWeightsGM rateWeightsGM_QD (bufno=32);
	set rateWeightsGM;
	if tierWght = . then output rateWeightsGM; %** if tierWght = . then the QD could not be weighted **;
	 else output rateWeightsGM_QD;
run;

%** weight the rates if possible **;
data rateWeightsGM_QD (bufno=32);
	set rateWeightsGM_QD;
	array maxRates{12} maxRates1-maxRates12;
	array maxDisc{12} maxDisc1-maxDisc12;
	do i = 1 to 12;
		if tierWght ~= . then do;
			if maxRates{i} = . then maxRates{i} = 0;
			if maxDisc{i} = . then maxDisc{i} = 0;
			maxRates{i} = maxRates{i} * tierWght;
			maxDisc{i} = maxDisc{i} * tierWght;
		end;
	end;
drop i;
run;

%** sum the weighted rates **;
proc sort data = rateWeightsGM;
	by wslr bnd line rtl_level qd_group;
	run;
proc sort data = rateWeightsGM_QD;
	by wslr bnd line rtl_level qd_group;
	run;

data tierWeights_Export; %** save a copy of the tier weights to be exported to excel **;
	set rateWeightsGM_QD;
	run;

proc sort data = tierWeights_Export nodupkey;
	by wslr bnd line qd_group lowHigh QD_LowHigh;
	run;

%** sum the weighted rates but take the average of the days **;
proc summary data = rateWeightsGM_QD;
	by wslr bnd line rtl_level qd_group; 
	var maxRates1-maxRates12 promoDays1-promoDays12 maxDisc1-maxDisc12;
	id civmil on_off_prem alc_ind; %** these will be the same for each qd_group **;
	output out = rateWeightsGM_QD(drop = _type_ _freq_) 
		sum(maxRates1-maxRates12 maxDisc1-maxDisc12)= mean(promoDays1-promoDays12)=;
run;

%** make a report of the % of GM QDs that are using tier weights **;
proc sort data = trackQDsWeighted;
	by wslr bnd line qd_group;

%** get the count/frequency of the occurance of each qd_group **;
proc summary data = trackQDsWeighted;
	by wslr bnd line qd_group;
	output out = trackQDsWeighted (drop= _type_);
run;

%** trackQDsWeighted contains all of the QDs **;
data trackQDsWeighted;	
	set trackQDsWeighted;
	rename _freq_ = tierCount;
	keep wslr bnd line qd_group _freq_;

%** tierWeights_Export contains only the QDs that were weighted via the tier weights  **;
data tierWeights_Export;
	set tierWeights_Export;
	keep wslr bnd line lowHigh QD_LowHigh tierUsed tierWght;

%** preform nodupkey b/c QDs with the same structure can repeat throughout the year.  Each grouping would have **;
%** a seperate qd_group number but they would all be using the same weights **;
proc sort data = tierWeights_Export nodupkey;
	by wslr bnd line lowHigh QD_LowHigh;
run;

data tierWeights_Export;
	set tierWeights_Export;
	*&xalliance;
	%makefamsmart;

%** add in the descriptive info **;
proc import
	out= linecode_raw
	datafile= "\\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Rev Planning\Active\Tables\RMTables.xlsb"
	dbms=excelcs replace;
	sheet="Linecode Table";		
run;

proc sql;
	create table packageInfo as
		select
			_ as line,
			_1 as linedesc
		from linecode_raw
		where
			_3 is not null
		order by _
	;
quit;


/*data packageInfo;
	set tableDir.packages;
	keep line linedesc;
*/
proc sort data = tierWeights_Export;
	by line;

/*
proc sort data = packageInfo nodupkey;
	by line;
*/
data tierWeights_Export;
	merge tierWeights_Export (in=a) packageInfo (in=b);
	by line;
	if a;


proc sort data = tierWeights_Export;
	by wslr;

%** read in the wslr table **;


data wslrInfo;
*	set tableDir.wslr;
	set wslrInfoTemp;
	keep wslr state reg wslrsdir wslrcity;

	


proc sort data = wslrInfo nodupkey;
	by wslr;

data tierWeights_Export;
	merge tierWeights_Export (in=a) wslrInfo (in=b);
	by wslr;
	if a;
run;

%** reorder the columns **;
proc sql;
	create table tierWeights_Out as 
	select reg, state, wslrsdir, wslr, wslrcity, family, bnd, line, linedesc, QD_lowHigh, lowHigh, tierWght, tierUsed
	from tierWeights_Export
	order by reg, state, wslrsdir, wslr, famord, bnd, line, QD_lowHigh, lowHigh;
quit;

%** write out an excel report containing the QDs DID get weighted **;
%** 2/3/2012 changed OUTFILE directory from Staff\JAshby\RMR 11\ **;
%** 10/18/2012 changed from xls to xlsx;
%** 12/4/2012 - added NEWFILE=Yes **;
proc export data = tierWeights_Out
  OUTFILE="\\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Rev Planning\Active\Promo Detail\QD Level Report\&year. QD Tier Weight.xlsx"
  DBMS=EXCEL REPLACE;
  NEWFILE = Yes;
run;

%** make a report of the QDs that did not get weighted **;
data qdNotWeighted (bufno=32);
	set rateWeightsGM (where =(prom_type = 'QD'));
	%*if prom_type = 'QD';
run;

%** if a  2 tier qd is 12 months long, there will be 24 recs at this point - nodup will give just 2 rows **;
proc sort data = qdNotWeighted nodupkey; 
	by wslr bnd line qd_group lowHigh;
%** get the count/frequency of the occurance of each qd_group **;
proc summary data = qdNotWeighted;
	by wslr bnd line qd_group;
	output out = qdNotWeightedTierCnt (drop= _type_);

data qdNotWeightedTierCnt;
	set qdNotWeightedTierCnt;
	if _freq_ > 1;

data qdNotWeighted;
	merge qdNotWeighted (in=a) qdNotWeightedTierCnt (in=b);
	by wslr bnd line qd_group;
	if a and b; %** keep QDs with at least two tiers **;

proc sort data = qdNotWeighted nodupkey;
	by wslr bnd line qd_group qdlow qdhigh; 

data qdNotWeighted;
	set qdNotWeighted;
	%makefamsmart;

%** reorder the columns **;
proc sql;
	create table QDs_NotWghtd as 
	select b.reg, b.state, b.wslrsdir, a.wslr, b.wslrcity, a.family, a.bnd, a.line, c.linedesc, a.qdLow, a.QdHigh
	from qdNotWeighted a, wslrInfo b, packageInfo c
	where a.wslr = b.wslr and a.line = c.line
	order by b.reg, b.state, b.wslrsdir, a.wslr, a.famord, a.bnd, a.line, a.qd_group, a.qdLow, a.QdHigh;
quit;

%** write out an excel report containing the QDs that did not get weighted **;
%** 2/3/2012 changed OUTFILE directory from Staff\JAshby\RMR 11\ **;
%** 10/18/2012 changed from xls to xlsx;
proc export data = QDs_NotWghtd 
  OUTFILE="\\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Rev Planning\Active\Promo Detail\QD Level Report\&year. QD Tier Weight.xlsx"
  DBMS=EXCEL REPLACE;  
run;

%** get the number of rows in the track QD dataset  **;
proc sql noprint;  %** trackQDsWeighted contains all of the QDs **;
	select count(*)
		into :trackQDsWeightedCntOneTier 
		from work.trackQDsWeighted
		where tierCount = 1; %** one tier QDs **;
	quit;
proc sql noprint;  
	select count(*)
		into :trackQDsWeightedCntMultTier 
		from work.trackQDsWeighted
		where tierCount > 1; %** two or more tier QDs **;
	quit;
proc sql noprint;  %** trackQDsWeighted contains all of the QDs **;
	select count(*)
		into :trackQDsWeightedCnt 
		from work.trackQDsWeighted; %** cnt of all QDs **;
	quit;
proc sql noprint;   %** rateWeightsGM_QD contains the QDs that got weighted **;
	select count(*)
		into :rateWeightsGM_QDCnt 
		from work.rateWeightsGM_QD;
	quit;

%put &trackQDsWeightedCnt;
%put &trackQDsWeightedCntOneTier;
%put &trackQDsWeightedCntMultTier;
%put &rateWeightsGM_QDCnt;

title1 'GM QDs using GM Tier Weights'; title2; title3; title4; run;
data _null_;
	file print;
	trackCnt = &trackQDsWeightedCnt.;
	oneTierCnt = &trackQDsWeightedCntOneTier.;
	twoTierCnt = &trackQDsWeightedCntMultTier.;
	usedCnt = &rateWeightsGM_QDCnt.;
	perUsed = usedCnt / trackCnt;
	oneTierPer = oneTierCnt / trackCnt; %** one tier as a percent of total QDs **;
	twoTierPer = twoTierCnt / trackCnt; %** two or more tier as percent of total **;
	twoTierPerUsed = usedCnt / twoTierCnt;
	put @1 '   ';
	put @1 '   ';
	put @1 'Number of Total GM QD Groups:                                     ' trackCnt comma14.;
	put @1 '   ';
	put @1 '-------------------------------------------------------------------------------- ';
	put @1 '   ';
	put @1 'Number of One Tier GM QD Groups:                                  ' oneTierCnt comma14.;
	put @1 'Percent of One Tier GM QD Groups out of total QDs:                ' oneTierPer percent14.1;
	put @1 '   ';
	put @1 '-------------------------------------------------------------------------------- ';
	put @1 '   ';
	put @1 'Number of GM QD Groups with two or more tiers:                    ' twoTierCnt comma14.;
	put @1 'Percent of GM QDs with two or more tiers out of total QDs:        ' twoTierPer percent14.1;
	put @1 '   ';
	put @1 'Percent of GM QDs with two or more tiers using Tier Weight Logic: ' twoTierPerUsed percent14.1;
	put @1 '   ';
	put @1 '-------------------------------------------------------------------------------- ';
	put @1 '   ';
	put @1 'Number of GM QDs using Tier Weight Logic:                         ' usedCnt comma14.;
	put @1 'Percent of Total GM QDs using Tier Weight Logic:                  ' perUsed percent14.1;
	put @1 '   ';
	put @1 '-------------------------------------------------------------------------------- ';

run;
title1;

%** take the average of everything else that is GM but did not use a tier weight **;
%** including qd_group in the by will average the tiers in QDs that did not get weighted **;
proc summary data = rateWeightsGM;
	by wslr bnd line rtl_level qd_group; 
	var maxRates1-maxRates12 promoDays1-promoDays12 maxDisc1-maxDisc12;
	id civmil on_off_prem alc_ind; %** these will be the same for each qd_group **;
	output out = rateWeightsGM(drop = _type_ _freq_) mean=;

data rateWeightsGM (bufno=32);
	set rateWeightsGM rateWeightsGM_QD; %** set the weighted QDs and all other GM promos together **;

proc sort data = rateWeightsGM;
	by wslr bnd line rtl_level qd_group;
run;

%** day weight each promo -- at this point QDs are collapsed and weighted were possible **;
data rateWeights;	
	set rateWeights;
	array maxRates{12} maxRates1-maxRates12;
	array maxDisc{12} maxDisc1-maxDisc12;
	array promoDays{12} promoDays1-promoDays12;
	do i = 1 to 12;
		if maxRates{i} = . then maxRates{i} = 0;
		if maxDisc{i} = . then maxDisc{i} = 0;
		if promoDays{i} = . then promoDays{i} = 0;
		maxRates{i} = maxRates{i} * promoDays{i}; %** day weight the rates **;
		maxDisc{i} = maxDisc{i} * promoDays{i}; %** day weight the rates **;
	end;
	drop i;
Run;

	%**MZ-3-23-2009 caculate day weight factors to increase weighting for high/low promotions**;
%macro ratefact;
	%** This program identifies High/Low promo patterns **;	
	Data HighLow;
		%readSnapSpec;
		%**only apply logic to general market, both premise, all alcohol, not qd promos**;
		%**trying to identify rate splits that will drive retail bridge buying**;
		if rtl_level = '1';
		if civmil = 'B';
		if on_off_prem = 'B';
		%** 10-26-2010 JLA convert to work w/i alc indicator **;
		%* if alc_ind = 'A';
		if prom_type ^= "QD";
		%**exclude transpack as we set thos to rtl_level 3**;
		if grp ^= 568;
		Keep Wslr Bnd Line FromDate ThruDate max_rate alc_ind;
	run;

	Proc sort data = HighLow;
		by Wslr Bnd Line FromDate ThruDate;

	Data HighLow;
		set HighLow;
		array rate{12} rate1-rate12;
		do i = 1 to 12;
			if month(fromdate) <= i <= month(thrudate) then do;
				rate{i} = max_rate;
			end;
		end;
	run;

	%** Count the distinct number of rates in each month/alc_ind **;
	%** capture the min and max rate **;
	proc sql noprint;
		create table HighLowCount as 
		select wslr, bnd, line, alc_ind, count(distinct rate1) as Count1, count(distinct rate2) as Count2, 
				count(distinct rate3) as Count3, count(distinct rate4) as Count4, count(distinct rate5) as Count5, 
				count(distinct rate6) as Count6, count(distinct rate7) as Count7, count(distinct rate8) as Count8,
				count(distinct rate9) as Count9, count(distinct rate10) as Count10, 
				count(distinct rate11) as Count11, count(distinct rate11) as Count12, max(rate1) as max1, max(rate2) as max2,
				max(rate3) as max3, max(rate4) as max4, max(rate5) as max5, max(rate6) as max6, max(rate7) as max7, max(rate8) as max8,
				max(rate9) as max9, max (rate10) as max10, max(rate11) as max11, max(rate12) as max12, min(rate1) as min1, min(rate2) as min2,
				min(rate3) as min3, min(rate4) as min4, min(rate5) as min5, min(rate6) as min6, min(rate7) as min7, min(rate8) as min8,
				min(rate9) as min9, min (rate10) as min10, min(rate11) as min11, min(rate12) as min12
		from HighLow
		group By wslr, bnd, line, alc_ind
		order by wslr, bnd, line, alc_ind;
	quit;

	%** Only keep High/Low records **;
	Data HighLowCount;
		set HighLowCount;
		array hlCnt{12} hlCnt1-hlCnt12;
		array count{12} count1-count12;
		array maxr{12} max1-max12;
		array minr{12} min1-min12;
		array factor{12} factor1-factor12;

		do i = 1 to 12;
			hlCnt{i} = 0;
			%** If more than one rate in the month keep the record **;
			if count{i} > 1 then do;
				hlCnt{i} = 1;
			end;
			if minr{i}>0 then do;
				%** set factor to % change in min vs max **;
				%** study of history shows that as the rate difference increases, bridge buying maginitude increases **;
				factor{i} = maxr{i}/minr{i};
				%** JLA 9/24/2010 - increase the factor by 25% **;
				factor{i} = factor{i} * (1.25);
				%** limit factor to 5 based on history**;
				if factor{i}>5 then do;
					factor{i}=5;
				end;
			end;
			else do; 
				factor{i} = 1;
			end;
		end;
		
		if sum (of hlCnt1-hlCnt12) >= 2; %** at least 2 months have more than one rate **; 
		drop i hlCnt1-hlCnt12;
	run;
%mend ratefact;
%ratefact;


proc sort data = HighLowCount;
	by wslr bnd line alc_ind;


proc sort data = rateWeightsGM;
	by wslr bnd line alc_ind;

	%** merge in new highlow factors**;
data rateWeightsGM;	
	merge rateWeightsGM (in=a) HighLowCount;
	by wslr bnd line alc_ind;
	if a;
Run;

data rateWeightsGM;	
	set rateWeightsGM;
	array maxRates{12} maxRates1-maxRates12;
	array promoDays{12} promoDays1-promoDays12;
	array highr{12} max1-max12;
	array factor{12} factor1-factor12;
	%** merge in new highlow factors**;
		%** if rtl_level = '1' and civmil = 'B' and on_off_prem = 'B' and alc_ind = 'A' then do;
		%** JLA 10/26/2010 - Removing Alc Ind as the data has now been calcd at the W/B/L Alc Ind Level **;
		if rtl_level = '1' and civmil = 'B' and on_off_prem = 'B' then do;
			do i = 1 to 12;
				if maxRates(i) = highr{i} then do;
					promoDays{i}=promoDays{i}*factor{i};
				end;
			end;
		end;
Run;
**MZ3-23-2009 End of high low promo logc;

%** JLA 9/29/2010 Adjust for differences in Strong/Weak Alc Types **;
Data AlcCnts;
	Set rateWeightsGM;
	Array BothCnt{12} BothCnt1-BothCnt12;
	Array StrongCnt{12} StrongCnt1-StrongCnt12;
	Array WeakCnt{12} WeakCnt1-WeakCnt12;
	array maxRates{12} maxRates1-maxRates12;
	do i = 1 to 12;
		BothCnt{i} = 0; StrongCnt{i} = 0; WeakCnt{i} = 0;
		if maxRates{i} ^= . then do;
			if alc_ind = 'A' Then BothCnt{i} = 1;
			if alc_ind = 'S' Then StrongCnt{i} = 1;
			if alc_ind = 'W' Then WeakCnt{i} = 1;
		end;
	end;
Run;

Proc Sort Data = AlcCnts;
	By Wslr Bnd Line;

%** Sum the count of promotions by alc type in each month **;
Proc Summary Data = AlcCnts;
	By Wslr Bnd Line;
	Var BothCnt1-BothCnt12 StrongCnt1-StrongCnt12 WeakCnt1-WeakCnt12;
	Output Out = AlcCnts (drop= _type_ _freq_) Sum=;
Run;

%** Add State and Family To rateWeightsGM **;
/*
Proc Sort Data = tabledir.wslr (keep = wslr state) out=WslrSt nodupkey;
	By Wslr;
*/
Proc Sort Data = wslrInfoTemp (keep = wslr state) out=WslrSt nodupkey;
	By Wslr;

data wslrSt;
	set WslrSt;
	wslr2 = input(wslr, 8.);
	drop wslr;
	rename wslr2=Wslr;
run;

Proc sort Data = WslrSt;
	by wslr;
run;
Data rateWeightsGM;
	Merge rateWeightsGM (in=a) WslrSt (in=b);
	By Wslr;
	If a;
Run;

Data rateWeightsGM;
	Set rateWeightsGM;
	%Makefamsmart;

%** Add the Alc Cnts back to rateWeightsGM **;
Data rateWeightsGM;
	Merge rateWeightsGM (in=a) AlcCnts (in=b);
	By Wslr Bnd Line;
	If a and b;
Run;

%** Bring in the GPV weighted Alc Types **;
Proc Sort Data = rateWeightsGM;
	By State Family Line;

Proc Sort Data = Build.AlcWeight Out=AlcWeight;
	By State Family Line;
Proc Sort Data = Build.AlcStFamWeight Out=AlcWeightStFam;
	By State Family;

Data rateWeightsGM;
	Merge rateWeightsGM (in=a) AlcWeight (in=b);
	By State Family Line;
	If a;
Run;

Data rateWeightsGM;
	Merge rateWeightsGM (in=a) AlcWeightStFam (in=b);
	By State Family;
	If a;
Run;

%** Adjust the days for different alc types if possible **;
Data rateWeightsGM;
	Set rateWeightsGM;
	Array BothCnt{12} BothCnt1-BothCnt12;
	Array StrongCnt{12} StrongCnt1-StrongCnt12;
	Array WeakCnt{12} WeakCnt1-WeakCnt12; 
	array promoDays{12} promoDays1-promoDays12;
	%** Attempt to use the State/Family weighting if the State/Family/Pkg not available **;
	If StrongWgt = . Then Do;
		StrongWgt = FamStrongWgt;
		WeakWgt = FamWeakWgt;
	End;
	%** Set vars to 0 if no weights were found **;
	If StrongWgt = . Then Do;
		StrongWgt = 0;
		WeakWgt = 0;
	End;
	%** Calculate how much larger or smaller the strong alc type is vs. the weak **;
	StrongFactor = 1;
	If StrongWgt > 0 And WeakWgt > 0 Then Do;
		StrongFactor = StrongWgt / WeakWgt;
	End;
	If civmil = 'B' And on_off_prem = 'B' Then Do; %** both civ/mil and on/off prem **;
		Do i = 1 to 12;
			%** No All Alc records in the month and both S and W records in the month **;
			If BothCnt{i} = 0 And StrongCnt{i} > 0 And WeakCnt{i} > 0 Then Do;
				If alc_ind = 'S' Then Do;
					promoDays{i} = promoDays{i} * StrongFactor;
				End;
			End;
		End;
	End;
Run;

data rateWeightsGM;	
	set rateWeightsGM;
	array maxRates{12} maxRates1-maxRates12;
	array maxDisc{12} maxDisc1-maxDisc12;
	array promoDays{12} promoDays1-promoDays12;
	do i = 1 to 12;
		if maxRates{i} = . then maxRates{i} = 0;
		if maxDisc{i} = . then maxDisc{i} = 0;
		if promoDays{i} = . then promoDays{i} = 0;
		maxRates{i} = maxRates{i} * promoDays{i}; %** day weight the rates **;
		maxDisc{i} = maxDisc{i} * promoDays{i}; %** day weight the rates **;
	end;
	drop i;
run;

%** get the total number of promoted days at each level **;
proc sort data = rateWeights;
	by wslr bnd line rtl_level;
proc sort data = rateWeightsGM;
	by wslr bnd line rtl_level;

proc summary data = rateWeights;
	by wslr bnd line rtl_level;
	var promoDays1-promoDays12;
	output out = rateWeightsDays (drop = _type_ _freq_) sum=;
proc summary data = rateWeightsGM;
	by wslr bnd line rtl_level;
	var promoDays1-promoDays12;
	output out = rateWeightsGMDays (drop = _type_ _freq_) sum=;

data rateWeights;
	set rateWeights; %** drop the days from the wslr bnd line rtl_level qd_group and merge in the wbl rtl_level days **;
	drop promoDays1-promoDays12;
data rateWeightsGM;
	set rateWeightsGM;
	drop promoDays1-promoDays12;
run;

proc sort data = rateWeights;
	by wslr bnd line rtl_level;
proc sort data = rateWeightsDays;
	by wslr bnd line rtl_level;
%** Add the total days in the month at each retail level back to the detail recs **;
proc sort data = rateWeightsGM;
	by wslr bnd line rtl_level;
proc sort data = rateWeightsGMDays;
	by wslr bnd line rtl_level;

data rateWeights;
	merge rateWeights (in=a) rateWeightsDays (in=b);
	by wslr bnd line rtl_level;
	if a and b;

data rateWeightsGM (bufno=32);
	merge rateWeightsGM (in=a) rateWeightsGMDays (in=b);
	by wslr bnd line rtl_level;
	if a and b;
run;

%** calculate the day weighted max rates **;
data rateWeights;	
	set rateWeights;
	array maxRates{12} maxRates1-maxRates12;
	array maxDisc{12} maxDisc1-maxDisc12;
	array promoDays{12} promoDays1-promoDays12;
	do i = 1 to 12;
		if promoDays{i} > 0 then do;
			maxRates{i} = maxRates{i} / promoDays{i}; %** day weight the rates **;
			maxDisc{i} = maxDisc{i} / promoDays{i}; %** day weight the rates **;
		end;
		else do;
			maxRates{i} = 0;
			maxDisc{i} = 0;
		end;
	end;
	drop i;
data rateWeightsGM;	
	set rateWeightsGM;
	array maxRates{12} maxRates1-maxRates12;
	array maxDisc{12} maxDisc1-maxDisc12;
	array promoDays{12} promoDays1-promoDays12;
	do i = 1 to 12;
		if promoDays{i} > 0 then do;
			maxRates{i} = maxRates{i} / promoDays{i}; %** day weight the rates **;
			maxDisc{i} = maxDisc{i} / promoDays{i}; %** day weight the rates **;
		end;
		else do;
			maxRates{i} = 0;
			maxDisc{i} = 0;
		end;
	end;
	drop i;
run;

%** calculate the rate by summing up the weights **;
proc sort data = rateWeights;
	by wslr bnd line rtl_level;
proc sort data = rateWeightsGM;
	by wslr bnd line rtl_level;

proc summary data = rateWeights;
	by wslr bnd line rtl_level;
	var maxRates1-maxRates12 maxDisc1-maxDisc12;
	output out = rateWeights (drop= _type_ _freq_) sum=;
proc summary data = rateWeightsGM;
	by wslr bnd line rtl_level;
	var maxRates1-maxRates12 maxDisc1-maxDisc12;
	output out = rateWeightsGM (drop= _type_ _freq_) sum=;
run;

%** rateWeights is levels 2 - 5 and rateWeightsGM is level 1 only -- set the 2 datasets together **;
data rateWeights (bufno=32);
	set rateWeights rateWeightsGM;

proc sort data = rateWeights;
	by wslr bnd line rtl_level;
run;

%** bring in the pryamid weights **;
data pyramidWeights;
	set build.pyramidWeights;
	if rtl_level = 1 then gm_vol = adjGpv; %** save a variable for the GM % of GPV **;

%** add in the state, then sum up the GM gpv in the state **;
data wslrInfo;
*	set tableDir.wslr;
	set wslrInfoTemp;
	keep wslr state;

proc sort data = wslrInfo nodupkey;
	by wslr;
proc sort data = pyramidWeights;
	by wslr;

data pyramidWeights;
	merge pyramidWeights (in=a) wslrInfo (in=b);
	by wslr;
	if a;

proc sort data = pyramidWeights;
	by state;

proc summary data = pyramidWeights;
	by state;
	var gm_vol adjGpv;
	output out = pyramidWeightsSTGM (drop= _type_ _freq_) sum=;

data pyramidWeightsSTGM;
	set pyramidWeightsSTGM;
	state_GM_per = gm_vol / adjGPV; %** save a variable for the State level GM % of GPV **;
	keep state state_GM_per;
run;

proc sort data = pyramidWeights;
	by wslr bnd line;

proc summary data = pyramidWeights;
	by wslr bnd line;
	var adjGpv;
	output out = pyramidWeightsTot (drop = _type_ _freq_) sum= tot_adjGpv;

data pyramidWeights;
	merge pyramidWeights (in=a) pyramidWeightsTot (in=b);
	by wslr bnd line;
	if a and b;

data pyramidWeights;
	set pyramidWeights;
	%** calculate the percent of total each tier makes up of the WBL **;
	level_percent = adjGpv / tot_adjGPV;	
	keep wslr bnd line rtl_level level_percent adjGpv;
run;

%** sum up the weights to the WFL **;
data pyramidWeightsWFL;
	set pyramidWeights;
	%makefamsmart;

proc sort data = pyramidWeightsWFL;
	by wslr family line rtl_level ;

proc summary data = pyramidWeightsWFL;
	by wslr family line rtl_level;
	var adjGpv;
	output out = pyramidWeightsWFL (drop = _type_ _freq_) sum=;
%** get the total WFL gpv **;
proc summary data = pyramidWeightsWFL;
	by wslr family line;
	var adjGpv; 
	output out = tpyramidWeightsWFL (drop = _type_ _freq_) sum=tot_adjGpv;

data pyramidWeightsWFL;
	merge pyramidWeightsWFL (in=a) tpyramidWeightsWFL (in=b);
	by wslr family line;
	if a and b;

data pyramidWeightsWFL;
	set pyramidWeightsWFL;
	%** calculate the percent of total each tier makes up of the WFL **;
	wfl_adjGpv = adjGpv;
	wfl_level_percent = adjGpv / tot_adjGPV;	
	keep wslr family line rtl_level wfl_level_percent wfl_adjGpv;
run;

%** sum up the weights to the SFL **;
proc sort data = wslrInfo nodupkey;
	by wslr;
proc sort data = pyramidWeightsWFL;
	by wslr;

data pyramidWeightsSFL;
	merge pyramidWeightsWFL (in=a) wslrInfo (in=b);
	by wslr;
	if a;
	rename wfl_adjGpv = adjGpv;

proc sort data = pyramidWeightsSFL;
	by state family line rtl_level;
proc summary data = pyramidWeightsSFL; 
	by state family line rtl_level;
	var adjGpv;
	output out = pyramidWeightsSFL (drop = _type_ _freq_) sum=;
%** get the total SFL gpv **;
proc summary data = pyramidWeightsSFL;
	by state family line;
	var adjGpv; 
	output out = tpyramidWeightsSFL (drop = _type_ _freq_) sum=tot_adjGpv;

data pyramidWeightsSFL;
	merge pyramidWeightsSFL (in=a) tpyramidWeightsSFL (in=b);
	by state family line;
	if a and b;

data pyramidWeightsSFL;
	set pyramidWeightsSFL;
	%** calculate the percent of total each tier makes up of the SFL **;
	sfl_adjGpv = adjGpv;
	sfl_level_percent = adjGpv / tot_adjGPV;	
	keep state family line rtl_level sfl_level_percent sfl_adjGpv;
run;

proc sort data = pyramidWeightsWFL;
	by wslr family line rtl_level;
proc sort data = pyramidWeights;
	by wslr bnd line rtl_level;

%** if you find a weight, there may still be missing tiers, however you have to use the first weight that occurs **;
data rateWeights;
	merge rateWeights (in=a) pyramidWeights (in=b);
	by wslr bnd line rtl_level;
	if a;
run;

%** make sure a weight was added **;
%** ex... weights have a rtl_lvl of 2 and starting next year it switches to 1, 3, 5 - since there is not a level 2 **;
%** teirs 1, 3 and 5 wont have any wieghts **;
proc sort data = rateWeights;
	by wslr bnd line;

data rateCheck;
	set rateWeights;
	if adjGpv = . then adjGpv = 0;
	keep wslr bnd line adjGpv;

proc summary data = rateCheck;
	by wslr bnd line;
	var adjGpv;
	output out = rateCheck (drop= _type_ _freq_) sum=;
run;

%** if the sum of the adjGpv is 0, then try and use a higher level pryamid weight **;
data rateCheck;
	set rateCheck;
	if adjGpv = 0;
	keep wslr bnd line;
run;

data pyramidWeightsFound;
	set pyramidWeights;
	wghtLevel = 'WBL';
	keep wslr bnd line wghtLevel;

proc sort data = pyramidWeightsFound nodupkey;
	by wslr bnd line;
run;

data pyramidWeightsFound;
	merge pyramidWeightsFound (in=a) rateCheck (in=b);
	by wslr bnd line;
	if a and not b; %** if the total adjGpv was 0 then delete the obs **;
run;

data rateWeights;
	merge rateWeights (in=a) pyramidWeightsFound (in=b);
	by wslr bnd line;
	if a; %** keep an idication that these were weighted with the WBL data **;

data rateWeights;
	set rateWeights;
	%makefamsmart;
	keep wslr family bnd line rtl_level maxRates1-maxRates12 maxDisc1-maxDisc12 adjGpv level_percent wghtLevel;
run;

proc sort data = rateWeights;
	by wslr family line rtl_level;
proc sort data = pyramidWeightsWFL;
	by wslr family line rtl_level;

%** try and match on family **;
data rateWeights;
	merge rateWeights (in=a) pyramidWeightsWFL (in=b);
	by wslr family line rtl_level;
	if a;
run;

data rateWeights;
	set rateWeights;
	%** use the WFL if possible **;
	%** have no weight, but the WFL has weights to use **;
	if wghtLevel in ('','   ') and adjGpv = . and wfl_adjGpv ~= . then do;
		adjGpv = wfl_adjGpv;
		level_percent = wfl_level_percent;
		wghtLevel = 'WFL';
	end;
	drop wfl_level_percent wfl_adjGpv;
run;

data rateCheck;
	set rateWeights;
	if adjGpv = . then adjGpv = 0;
	keep wslr bnd line adjGpv;

proc sort data = rateCheck;
	by wslr bnd line;

proc summary data = rateCheck;
	by wslr bnd line;
	var adjGpv;
	output out = rateCheck (drop= _type_ _freq_) sum=;
run;

%** if the sum of the adjGpv is 0, then try and use a higher level pryamid weight **;
data rateCheck;
	set rateCheck;
	if adjGpv = 0;
	keep wslr bnd line;
run;

data pyramidWeightsFoundWFL;
	set rateWeights;
	if wghtLevel = 'WFL';
	keep wslr bnd line;

proc sort data = pyramidWeightsFoundWFL nodupkey;
	by wslr bnd line;
proc sort data = rateWeights;
	by wslr bnd line;

data pyramidWeightsFoundWFL;
	merge pyramidWeightsFoundWFL (in=a) rateCheck (in=b);
	by wslr bnd line;
	if a and not b; %** if the total adjGpv was 0 then delete the obs **;
run;

data rateWeights;
	merge rateWeights (in=a) pyramidWeightsFoundWFL (in=b);
	by wslr bnd line;
	%** make sure each brand in the family has the indicator that it used the WFL weights **;
	if a and b then wghtLevel = 'WFL'; %** keep an idication that these were weighted with the WFL data **;
	if a; 
run;

%** add state to rateWeights **;
proc sort data = rateWeights;
	by wslr;

data rateWeights;
	merge rateWeights (in=a) wslrInfo (in=b);
	by wslr;
	if a;

%** merge in the state **;
proc sort data = rateWeights;
	by state family line rtl_level;
proc sort data = pyramidWeightsSFL;
	by state family line rtl_level;

%** try and match on family **;
data rateWeights;
	merge rateWeights (in=a) pyramidWeightsSFL (in=b);
	by state family line rtl_level;
	if a;
run;

data rateWeights;
	set rateWeights;
	%** use the SFL if possible **;
	%** have no weight, but the SFL has weights to use **;
	if wghtLevel in ('','   ') and adjGpv = . and sfl_adjGpv ~= . then do;
		adjGpv = sfl_adjGpv;
		level_percent = sfl_level_percent;
		wghtLevel = 'SFL';
	end;
	drop sfl_level_percent sfl_adjGpv;
run;

data rateCheck;
	set rateWeights;
	if adjGpv = . then adjGpv = 0;
	keep wslr bnd line adjGpv;

proc sort data = rateCheck;
	by wslr bnd line;

proc summary data = rateCheck;
	by wslr bnd line;
	var adjGpv;
	output out = rateCheck (drop= _type_ _freq_) sum=;
run;

%** if the sum of the adjGpv is 0, then try and use a higher level pryamid weight **;
data rateCheck;
	set rateCheck;
	if adjGpv = 0;
	keep wslr bnd line;
run;

data pyramidWeightsFoundSFL;
	set rateWeights;
	if wghtLevel = 'SFL';
	keep wslr bnd line;

proc sort data = pyramidWeightsFoundSFL nodupkey;
	by wslr bnd line;
proc sort data = rateWeights;
	by wslr bnd line;

data pyramidWeightsFoundSFL;
	merge pyramidWeightsFoundSFL (in=a) rateCheck (in=b);
	by wslr bnd line;
	if a and not b; %** if the total adjGpv was 0 then delete the obs **;
run;

data rateWeights;
	merge rateWeights (in=a) pyramidWeightsFoundSFL (in=b);
	by wslr bnd line;
	%** make sure each brand in the family has the indicator that it used the SFL weights **;
	if a and b then wghtLevel = 'SFL'; %** keep an idication that these were weighted with the SFL data **;
	if a; 
run;

%** merge in the state level GM % of GPV **;
proc sort data = rateWeights;
	by state;
proc sort data = pyramidWeightsSTGM;
	by state;

data rateWeights;
	merge rateWeights (in=a) pyramidWeightsSTGM (in=b);
	by state;
	if a;
run;

%** for any WBL combos that have just one tier, assign a wieght of 1 if it is missing **;
%** the weight would be missing if nothing has been paid for the tier **;
data rateWeights;
	set rateWeights;
	pyramidTierCnt = 1;
	%** in case the state had no previous GM volume, assign it to be 95% **;
	if state_GM_per = . then state_GM_per = .95;
	%** if the GM percent is 95% or greater, reset it to 95% so that the lower tiers will be weighted with **;
	%** at least a 5% weight **;
	if state_GM_per > .95 then state_GM_per = .95;

proc sort data = rateWeights;
	by wslr bnd line;
proc summary data = rateWeights;
	by wslr bnd line;
	var pyramidTierCnt adjGpv; %** sum up the number of tiers represented in the calendar and gpv from payments **;
	output out = rateWeightsTierCnt (drop= _type_ _freq_) sum= pyramidTierCnt tot_adjGpv;

data rateWeights;
	set rateWeights;
	drop pyramidTierCnt;

data rateWeights;
	merge rateWeights (in=a) rateWeightsTierCnt (in=b);
	by wslr bnd line;
	if a and b;
run;

data rateWeights;
	set rateWeights;
	%** no gpv was found, but there is only one tier in the pyramid all year long **;
	if adjGpv = . and pyramidTierCnt = 1 then do;
		adjGpv = 99999;
		tot_adjGpv = 99999;
		level_percent = 1;
		wghtLevel = '999';
	end;
	%** no GPV was found, and there is more than one tier -- give each an equal weight **;
	if adjGpv = . and pyramidTierCnt > 1 and wghtLevel in ('','   ') then do;
		adjGpv = 99999;
		tot_adjGpv = 99999;
		level_percent = 1 / pyramidTierCnt;
		wghtLevel = 'AVG';
	end;
run;

%** find the level 2 - 5 average level_percent **;
data rateWeights2thru5;
	set rateWeights;
	if rtl_level ~= 1;
	if level_percent ~= .; %** only keep records were the percent was calculated **;

proc sort data = rateWeights2thru5;
	by wslr bnd line;
proc summary data = rateWeights2thru5;
	by wslr bnd line;
	var level_percent; %** take the average level percent of levels 2-5 for each WBL **;
	output out = rateWeights2thru5 (drop= _type_ _freq_) mean=level_percent2thru5;

data rateWeights;
	merge rateWeights (in=a) rateWeights2thru5 (in=b);
	by wslr bnd line;
	if a; %** not every WBL will have levels 2 - 5, so they will not exist in rateWeights2thru5 **;
run;

%** put the weights into monthly buckets **;
%** different months might have different level promotions **;
data rateWeights;
	set rateWeights;
	array pyramidWght{12} pyramidWght1-pyramidWght12;
	array maxRates{12} maxRates1-maxRates12;
	do i = 1 to 12;
		pyramidWght{i} = 0;
		if maxRates{i} ~= 0 then pyramidWght{i} = level_percent;
	end;
	drop i;

proc sort data = rateWeights;
	by wslr bnd line;
run;

%** determine how to weight the levels **;
data rateWeights (bufno=32);
	set rateWeights;
	array pyramidWght{12} pyramidWght1-pyramidWght12;
	array addLevelOne{12} addLevelOne1-addLevelOne12;
	array addLowerLevel{12} addLowerLevel1-addLowerLevel12;
	if tot_adjGPV ~= . then do; %** if tot_adjGpv is not missing then at least one level had gpv **;
		do i = 1 to 12;
			%** adding a level 2 - 5 promo **;
			if rtl_level ~= 1 and pyramidWght{i} = . then do;
				if level_percent2thru5 ~= . then do;
					pyramidWght{i} = level_percent2thru5;
				end;
				else do;
					%** if there is no level 2 thru 5 history, add in 5% **;
					pyramidWght{i} = .05; 
					addLowerLevel{i} = 1; %** keep track of adding a lower level when there has never been a lower lvl **;
				end;
			end;		
			%** adding a level 1 **;
			if rtl_level = 1 and pyramidWght{i} = . then do;
				pyramidWght{i} = state_GM_per; %** set the weight equal to the state Level GM percent **;
				addLevelOne{i} = 1; %** keep track of adding GM when there has never been GM **;
			end;
		end;	
	end;
	drop i;
run;

proc sort data = rateWeights;	
	by wslr bnd line;

%** sum up all the percents in each month **;
%** the number can be above 100%, and when adding tiers that dont exist, will usually be above 100% **;
proc summary data = rateWeights;
	by wslr bnd line;
	var pyramidWght1-pyramidWght12 addLevelOne1-addLevelOne12 addLowerLevel1-addLowerLevel12;
	output out = rateWeightsTot (drop= _type_ _freq_) sum=tot_pyramidWght1-tot_pyramidWght12 
													  addLevelOne1-addLevelOne12 addLowerLevel1-addLowerLevel12;
run;

data rateWeights;
	set rateWeights;
	drop addLevelOne1-addLevelOne12 addLowerLevel1-addLowerLevel12;

data rateWeights;
	merge rateWeights (in=a) rateWeightsTot (in=b);
	by wslr bnd line;
	if a and b;
run;

%** reclac the weights to be a percentage of the total percentages in the month **;
data rateWeights;
	set rateWeights;
	array pyramidWght{12} pyramidWght1-pyramidWght12;
	array adjPyramidWght{12} adjPyramidWght1-adjPyramidWght12;
	array tot_pyramidWght{12} tot_pyramidWght1-tot_pyramidWght12;
	array addLevelOne{12} addLevelOne1-addLevelOne12;
	do i = 1 to 12;
		if tot_pyramidWght{i} > 0 then adjPyramidWght{i} = pyramidWght{i} / tot_pyramidWght{i};
	end;
	drop i; 
run;

%** find the level 2 - 5 Adjust percents **;
data adjRateWeights2thru5;
	set rateWeights;
	if rtl_level ~= 1;
	
proc sort data = adjRateWeights2thru5;
	by wslr bnd line;
proc summary data = adjRateWeights2thru5;
	by wslr bnd line;
	var adjPyramidWght1-adjPyramidWght12; %** take the SUM of levels 2-5 for each WBL **;
	output out = adjRateWeights2thru5 (drop= _type_ _freq_) sum=adjWghtTwoThruFive1-adjWghtTwoThruFive12;

%** give each WBL record the total adjusted percents for levels 2 thru 5 **;
data rateWeights;
	merge rateWeights (in=a) adjRateWeights2thru5 (in=b);
	by wslr bnd line;
	if a; %** not every WBL will have levels 2 - 5, so they will not exist in adjRateWeights2thru5 **;
run;

%** give each record a flag to indicate if the WBL has any GM or not **;
data hasGM;
	set rateWeights;
	array hasGM{12} hasGM1-hasGM12;
	array pyramidWght{12} pyramidWght1-pyramidWght12;
	do i = 1 to 12;
		hasGM{i} = 0;
		if rtl_level = 1 and pyramidWght{i} not in (.,0) then hasGM{i} = 1;
	end;
	drop i;
run;

proc summary data = hasGM;
	by wslr bnd line;
	var hasGM1-hasGM12;
	output out = hasGM (drop = _type_ _freq_) sum=;

%** merge in the flag to indicated if the WBL month has any GM promos **;
data rateWeights;
	merge rateWeights (in=a) hasGM (in=b);
	by wslr bnd line;
	if a and b;
run;

%** add a flag that counts the number of pyramid tiers in a month **;
data pyramidTierCnt;
	set rateWeights (drop= pyramidTierCnt);
	array maxRates{12} maxRates1-maxRates12;
	array pyramidTierCnt{12} pyramidTierCnt1-pyramidTierCnt12;
	do i = 1 to 12;
		pyramidTierCnt{i} = 0;
		if maxRates{i} > 0 then pyramidTierCnt{i} = 1;
	end;
	drop i;

proc sort data = pyramidTierCnt;
	by wslr bnd line;
proc summary data = pyramidTierCnt;
	by wslr bnd line;
	var pyramidTierCnt1-pyramidTierCnt12;
	output out = pyramidTierCnt (drop= _type_ _freq_) sum=;

proc sort data = rateWeights;
	by wslr bnd line;

data rateWeights;
	set rateWeights;
	drop pyramidTierCnt;
	
data rateWeights;
	merge rateWeights (in=a) pyramidTierCnt (in=b);
	by wslr bnd line;
	if a and b;
run;

data rateWeights (bufno=32);
	set rateWeights;
	array pyramidWght{12} pyramidWght1-pyramidWght12;
	array adjPyramidWght{12} adjPyramidWght1-adjPyramidWght12;
	array tot_pyramidWght{12} tot_pyramidWght1-tot_pyramidWght12;
	array addLevelOne{12} addLevelOne1-addLevelOne12;
	array addLowerLevel{12} addLowerLevel1-addLowerLevel12;
	array adjWghtTwoThruFive{12} adjWghtTwoThruFive1-adjWghtTwoThruFive12;
	array nonGmPercent{12} nonGmPercent1-nonGmPercent12;
	array levelPerTwoThruFive{12} levelPerTwoThruFive1-levelPerTwoThruFive12;
	array maxRates{12} maxRates1-maxRates12;
	array hasGM{12} hasGM1-hasGM12;
	array pyramidTierCnt{12} pyramidTierCnt1-pyramidTierCnt12;
	do i = 1 to 12;
		%** determine if the promo that was added was a level 1, if so force level 1 back to 95% **;
		%** and there is something below it **;
		if addLevelOne{i} >= 1 and rtl_level = 1 and pyramidTierCnt{i} > 1 then do;
			%** ensure that the level 1 that was added gets the State GM percent **;
			%** only add if there was already a weight **;
			if pyramidWght{i} not in (.,0) then adjPyramidWght{i} = state_GM_per; 
		end;
		else if addLevelOne{i} >= 1 and rtl_level ~= 1 and pyramidTierCnt{i} > 1 then do;
			%** level 1 was added but this record is not the GM record **;
			%** and there is something below level 1 **;
			%** proportionatly give back the percentage to the non level one promos **;
			%** if you are adding a level 1 promo, then the weight for level 1 would be the state_GM_per **;
			nonGmPercent{i} = 1 - state_GM_per; %** calculate the amount to be allocated to non GM promos **;
			%** only add if there was already a weight **;
			if pyramidWght{i} not in (.,0) then do;
				%** calculate each 2 - 5 levels percent of the total level 2 - 5 gpv **;
				levelPerTwoThruFive{i} = adjPyramidWght{i} / adjWghtTwoThruFive{i};
				%** recalc each levels new adjusted percent **;
				%** the math is the specific levels percent of 2 - 5 gpv * the non GM percent to add back in to get to 100% *;
				adjPyramidWght{i} = levelPerTwoThruFive{i} * nonGmPercent{i};
			end;
		end;
		%** level 1 is the only promo in the month, set it to 100% **;
		else if addLevelOne{i} >= 1 and rtl_level = 1 and pyramidTierCnt{i} = 1 then do;
			adjPyramidWght{i} = 1;
		end;
		%** similar logic to the above step -- may be able to compress into one if/else if statement **;
		%** a lower level was added, but the only thing you had in history was GM, addLowerLevel will be >= 1 **;
		if addLowerLevel{i} >= 1 and rtl_level = 1 then do; %** for the GM tier, force it back to the state_GM_per **;
			%** only add if there was already a weight **;
			if pyramidWght{i} not in (.,0) then adjPyramidWght{i} = state_GM_per; 
		end;
		else if addLowerLevel{i} >= 1 and rtl_level ~= 1 then do;
			if hasGM{i} >= 1 then do; %** the WBL month must have GM promos to adjust the 2-5 promos **;
				nonGmPercent{i} = 1 - state_GM_per; %** calculate the amount to be allocated to non GM promos **;
				if pyramidWght{i} not in (.,0) then do;
					%** calculate each 2 - 5 levels percent of the total level 2 - 5 gpv **;
					levelPerTwoThruFive{i} = adjPyramidWght{i} / adjWghtTwoThruFive{i};
					%** recalc each levels new adjusted percent **;
					%** at this point, any 2 -5 levels will have the same weight **;
					%** the math is the specific levels percent of 2 - 5 gpv * the non GM percent to add back in to get to 100% *;
					adjPyramidWght{i} = levelPerTwoThruFive{i} * nonGmPercent{i};
				end;
			end;
		end;
		%** if the weights are using the AVG then attempt to use the GM percent if available **;
		if wghtLevel = 'AVG' then do;
			%** item has GM, and something below it and you are on the GM row **;
			if rtl_level = 1 and hasGM{i} >= 1  and pyramidTierCnt{i} > 1 then do;
				if pyramidWght{i} not in (.,0) then adjPyramidWght{i} = state_GM_per; 
			end;
			%** item has GM, and something below it, and you are on a 2-5 row **;
			else if rtl_level ~= 1 and hasGM{i} >= 1 and pyramidTierCnt{i} > 1 then do; 
				nonGmPercent{i} = 1 - state_GM_per; %** calculate the amount to be allocated to non GM promos **;
				%** evenly distribute the remaining percent across the 2-5 tiers **;
				%** if there is a level 1 and a level 3, pyramidTierCnt will = 2, by  -1 you are putting the full **;
				%** nonGmPercent in level 3 --- if there is a level 1, 3, and 5, pyramidTierCnt will = 3, by - 1 **;
				%** you are putting an equal amount in levels 3 and 5 -- nonGmPercent / 2 **;
				adjPyramidWght{i} = nonGmPercent{i} / (pyramidTierCnt{i} - 1);
			end;
			%** item has GM only and you are on the GM row **;
			if rtl_level = 1 and hasGM{i} >= 1 and pyramidTierCnt{i} = 1 then do;
				%** make GM 100% if is it the only tier **;
				adjPyramidWght{i} = 1; 
			end;
		end;
		if maxRates{i} = 0 then adjPyramidWght{i} = 0;
	end;
	keep wslr bnd line rtl_level wghtLevel maxRates1-maxRates12 adjPyramidWght1-adjPyramidWght12 state_GM_per 
		 adjGpv maxDisc1-maxDisc12;
run;

%** create a report to make sure all the percents sum up to 1 at the WBL line level **;
proc sort data = rateWeights;
	by wslr bnd line;

proc summary data = rateWeights;
	by wslr bnd line;
	var adjPyramidWght1-adjPyramidWght12;
	output out = rateWeightsCheck (drop= _type_ _freq_) sum=;

proc print data = rateWeightsCheck;
	where (round(adjPyramidWght1,.001) > 1 or round(adjPyramidWght2,.001) > 1 or round(adjPyramidWght3,.001) > 1 or round(adjPyramidWght4,.001) > 1 or
			round(adjPyramidWght5,.001) > 1 or round(adjPyramidWght6,.001) > 1 or round(adjPyramidWght7,.001) > 1 or round(adjPyramidWght8,.001) > 1 or
			 round(adjPyramidWght9,.001) > 1 or round(adjPyramidWght10,.001) > 1 or round(adjPyramidWght11,.001) > 1 or round(adjPyramidWght12,.001) > 1);
run;


title 'Rate weights that dont sum to 100% at the WBL M level';
proc print data = rateWeightsCheck;
	where (round(adjPyramidWght1,.001) not in (1,0) or round(adjPyramidWght2,.001) not in (1,0)  or round(adjPyramidWght3,.001) not in (1,0)  or round(adjPyramidWght4,.001) not in (1,0)  or
			round(adjPyramidWght5,.001) not in (1,0)  or round(adjPyramidWght6,.001) not in (1,0) or round(adjPyramidWght7,.001) not in (1,0)  or round(adjPyramidWght8,.001) not in (1,0)  or
			 round(adjPyramidWght9,.001) not in (1,0)  or round(adjPyramidWght10,.001) not in (1,0)  or round(adjPyramidWght11,.001) not in (1,0)  or round(adjPyramidWght12,.001) not in (1,0) );
	format adjPyramidWght1-adjPyramidWght12 percent6.;
	var wslr bnd line adjPyramidWght1-adjPyramidWght12;
run;
title; run;

%** save a copy of the weights in the build directory **;
data build.rateWeights&readsnap._&year.;
	set rateWeights;
run;

%** write out an excel report containing the weights **;
%* proc export data = build.rateWeights
  OUTFILE="\\one.ofc.loc\dfsusa\SharedData\STL01\Sales\Sales Ops\Rev Mgmt\Planning_Analysis\Rev Planning\Active\Staff\JAshby\RMR 11\&year. Rate Weights.xls"
  DBMS=EXCEL2000 
  REPLACE;  
run;

%** weight the rates by level using the percents calcd from above **;
data rateWeights;
	set rateWeights;
	array maxRates{12} maxRates1-maxRates12;
	array maxDisc{12} maxDisc1-maxDisc12;
	array adjPyramidWght{12} adjPyramidWght1-adjPyramidWght12;
	do i = 1 to 12;
		maxRates{i} = maxRates{i} * adjPyramidWght{i};
		maxDisc{i} = maxDisc{i} * adjPyramidWght{i};
	end;
	drop i state_GM_per adjGpv;

proc summary data = rateWeights;
	by wslr bnd line;
	var maxRates1-maxRates12 maxDisc1-maxDisc12;
	output out = rateWeights (drop= _type_ _freq_) sum=;
run;

%*data holdFcst;
%*	set forecastData;

%*data forecastData;
%*	set holdFcst;

%** delete the datasets used to calc the rate weights **;
%** 10/24/2012 removed QDs_NotWghtd and tierWeights_out from delete **;
proc datasets library=work nolist;
	delete Pyramidtiercnt Pyramidweights Pyramidweightsfound Pyramidweightsfoundsfl Pyramidweightsfoundwfl Pyramidweightssfl
		   Pyramidweightsstgm Pyramidweightstot Pyramidweightswfl Qdnotweighted Qdnotweightedtiercnt 
		   Ratecheck Rateweights2thru5 Rateweightsdays Rateweightsgm Rateweightsgmdays Rateweightsgm_qd Rateweightsgm_qdlist
		   Rateweightsgm_qdlistcontents Rateweightstiercnt Rateweightstot Hasgm Daysgm Adjrateweights2thru5 Tierweights
		   Tierweightsfam Tierweightsstate Tierweights_export Tierwghtchk Tpyramidweightssfl
		   Tpyramidweightswfl Trackqdsweighted; 
quit;

%** get the tier cnt of QDs and divide the days of each QD by the tier count so that when summed, the days wont **;
%** be double counted... i.e. a 2 Tier QD on for 20 days will sum to 20 not 40 b/c each record will have **;
%** 10 days (20/2) on it **  ;
proc sort data = forecastData;
	by wslr bnd line qd_group;
run;

proc summary data = forecastData;
	by wslr bnd line qd_group;
	output out = qdTierCnt (drop = _type_);
run;

%** Give each rec the number of tiers **;
data forecastData (bufno=64);
	merge forecastData (in=a) qdTierCnt (in=b);
	by wslr bnd line qd_group;
	if a and b;
run;

%** merge in the rates with the forecast data (calendar) information **;
%** sum up to the WBL and then merge in the weighted max weights **;
data forecastData (bufno=32);
	set forecastData;
	%** calculate what the dollars would be if everythig was sold at the max rate **;
	array maxdol{12} maxdol1-maxdol12;
	array discDol{12} discDol1-discDol12;
	array discMax{12} discMax1-discMax12;
	array days{12} days1-days12;
	array promosOffered{12} promosOffered1-promosOffered12;
	array promosPaid{12} promosPaid1-promosPaid12;
	array actdol{12} actdol1-actdol12;
	array actgpv{12} actgpv1-actgpv12;
	if becv = . then becv = .07258065;
	do i = 1 to 12;
		%** make sure there are no missing values **;
		if actgpv{i} = . then actgpv{i} = 0;
		if actdol{i} = . then actdol{i} = 0;
		%** calculate what the promo expense would have been if all of the gpv was sold at the max rate **;
		%** convert gpv to cases - then mulptiply by the per case max rate **;
		maxdol{i} = round(actgpv{i} / becv) * max_rate;
		%** AAP only pays on the whole dollar **;
		maxdol{i} = round(maxdol{i}); %** round to be consistent with AAP rounding and payments **;
		%** if the paid dollars are greater than the calculated max, use the paid as the max **;
		%** this can happen b/c of our 3 decmial rounding on the gpv. **;
		if actdol{i} > maxdol{i} then maxdol{i} = actdol{i};
		%** calc the discounts **;
		if sug_disc = 0 then sug_disc = max_rate * 2;
		split = max_rate / sug_disc;
		discDol{i} = actdol{i} / split;
		discMax{i} = maxdol{i} / split;
		promosOffered{i} = 0; 
		if _freq_ > 0 then do; %** _freq_ is the tier count **;
			%** _Freq_ will be 1 if the item is a Case One or a One tier QD **;
			%** If there are days in the month the count the promo as being offered **;
			%** QD Example:  a 3 tier QD for a WBL would have a promo offered count of 3 **;
			if days{i} > 0 then do;
				%** keep a record of the number of promotions offered in each month **;
				promosOffered{i} = 1; %** Capture promos offered before the days are changed to only be GM **;
			end;
			%** dont keep days for cancelled promos -- typicallys the days that were cancellced get picked up by **;
			%** another promo **;
			if status = 'C' then do;
				days{i} = 0; 
			end;
			%** only keep general market days **;
			if rtl_level NE '1' then do;
				days{i} = 0; 
			end;
			days{i} = days{i} / _freq_; %** divide by the number of tiers in the qd group **;
		end;
	end;
	drop _freq_ i;
run;

proc sort data = forecastData;
	by wslr bnd line;

proc summary data = forecastData;
	by wslr bnd line;
	var actdol1-actdol12 actgpv1-actgpv12 days1-days12 promosOffered1-promosOffered12 
			maxdol1-maxdol12 promosPaid1-promosPaid12 discDol1-discDol12 discMax1-discMax12 
			aappaid1-aappaid12 aapgpv1-aapgpv12;
	id becv state;
	output out = forecastData (drop= _type_ _freq_) sum=;
run;

proc sort data = rateWeights;
	by wslr bnd line;

data forecastData (bufno=32); %** bring in the rate weight **;
	merge forecastData (in=a) rateWeights (in=b);
	by wslr bnd line;
	if a and b;
run;

%** reset the promoted days if they are > than the number of days in the month **;
%** Could happen if a wslr was changed via fix lines or if the dates were changed via the date logic in the adj snap **;
data forecastData;	
	set forecastData;
	if days1 > 31 then days1 = 31;	if days2 > 28 then days2 = 28; if days3 > 31 then days3 = 31;
	if days4 > 30 then days4 = 30;	if days5 > 31 then days5 = 31; if days6 > 30 then days6 = 30;
	if days7 > 31 then days7 = 31;	if days8 > 31 then days8 = 31; if days9 > 30 then days9 = 30;
	if days10 > 31 then days10 = 31;  if days11 > 30 then days11 = 30; if days12 > 31 then days12 = 31;
	rename maxRates1-maxRates12 = wgtdRate1-wgtdRate12;
run;

%** read in the Volume - save a copy of the volume file in sas memory so that it is only read once **;
data volumeHold (bufno=32);
	set volDir.&volumeFile.;
	IF DOMEST='Y';

%** positions 1-12 will represent the prior year and 13-24 the current year **;
data vol0 (bufno=32);
	set volumeHold;
	&FIXLINES;
  	%macro makeSTR;
    	%do I=1 %to 12;
			%** if the current month is Dec and we want to Fcst the next year, this step will ensure that Jan-Dec **;
			%** for the prior year will have volume:  ACT+OTL.  Actual Volume for the next year will not exist at **;
			%** this point.  Current year actual volume is needed in the moving average RPV proxy calculations  **;
			%** the calcs will not occur until at least one month is closed, which is why we dont need to read in **;
			%** current yr volume if no month is closed **;
        	IF &I GT &PRVSTRM THEN VOL&I = &PRVSTR_2._&I ; %** Prior Year Outlook **;
            	              ELSE VOL&I = &PRVSTR_1._&I ; %** Prior Year Actuals **;
			%if &newclose > 12 %then %do; %** read in current year if at least one month is closed **;
			  %let j = %EVAL(12+&I);
        		VOL&j = &CURSTR._&I ; %** current year actuals **;
			%end;
			IF VOL&I = . then VOL&I = 0;
		%end;
	%mend makeSTR; %makeSTR;
	keep wslr bnd line VOL1-VOL&NEWCLOSE; 
	%** only keep volume thru the most recent closed month **;

%** make sure the volume is at the WBL M level **;
proc sort data = vol0;
	by wslr bnd line;

proc summary data = vol0;
	by wslr bnd line;
	var vol1-vol&newClose;
	output out = vol0 (drop= _type_ _freq_) sum=;
run;

data vol_taken;  * save for use in the not taken logic;
  set vol0;
run;

%**  ---------------------------------------------------------------------------------------------------------------- **;
%**  create the OH Mulligan Data Fill Records **;
%**  get the average days and rate for the State Brand Line **;
%macro OhMull;
	%if &FcstOhMull = Y %then %do;
		data ohMull;
			set forecastData (where = (state = 34));
			array days{12} days1-days12;
			%** 2008 same as 2007 Brands and packages: **;
			if (bnd in ('BUD','BDL','BWS','IDB','IDL') and line = 77) or
				 (bnd in ('BUD','BDL','BWS','IDB','IDL') and line = 40) or
				 (bnd in ('MIC','MCL','MUL','MUA') and line = 67) or
				 (bnd in ('BSH','BHL','IBH') and line = 40) or
				 (bnd in ('BSH','BHL','IBH') and line = 67) or
				 (bnd in ('ABN','NTI','NTY') and line = 40) or
				 (bnd in ('ONA','OAM') and line = 4);
			do i = 1 to 12;
				%** if a WBL had no days, make that record have missing days so the 0 days wont impact the state avg **;
				if days{i} = 0 then days{i} = .;
			end;
			drop i;
		run;

		proc sort data = ohMull;
			by state bnd line;

		%** get the avg days and sum the dollars and gpv **;
		proc summary data = ohMull;
			by state bnd line;
			var days1-days12 actdol1-actdol12 actgpv1-actgpv12;
			id becv;
			output out = ohMull (drop= _type_ _freq_) 
				mean(days1-days12)= 
				sum(actdol1-actdol12 actgpv1-actgpv12)=;
		run;

		data ohMull;
			set ohMull;
			array days{12} days1-days12; 
			do i = 1 to 12;
				if days{i} = . then days{i} = 0;
			end;
			%** only calc for closed fobr months **;
			if &closfobr > 0 then do;
				state_avgday = sum(of days1-days&closfobr) / &closfobr; %** calculated the average number of days **;
				if sum(of actgpv1-actgpv&closfobr) > 0 then
					state_avgrate = sum(of actdol1-actdol&closfobr) / (sum(of actgpv1-actgpv&closfobr) / becv);
				else state_avgrate = 0;
			end;
			%** only keep recs with a good rate and day avg **;
			if state_avgrate = 0 or state_avgday = 0 then delete;
			keep state bnd line state_avgday state_avgrate;
		run;

		proc sort data = forecastData;
			by state bnd line;

		data forecastData;
			merge forecastData (in=a) ohMull (in=b);
			by state bnd line;
			if a;
		run;

		data forecastData;
			set forecastData;
			array days{12} days1-days12;
			array promos{12} promosOffered1-promosOffered12;
			array mrate{12} wgtdRate1-wgtdRate12;
			%** Ohio and least one closed FOBR month **;
			if state = 34 and &closfobr > 0 then do;
				%** 2008 same as 2007 Brands and packages: **;
				if (bnd in ('BUD','BDL','BWS','IDB','IDL') and line = 77) or
					 (bnd in ('BUD','BDL','BWS','IDB','IDL') and line = 40) or
					 (bnd in ('MIC','MCL','MUL','MUA') and line = 67) or
					 (bnd in ('BSH','BHL','IBH') and line = 40) or
					 (bnd in ('BSH','BHL','IBH') and line = 67) or
					 (bnd in ('ABN','NTI','NTY') and line = 40) or
					 (bnd in ('ONA','OAM') and line = 4) then do;
					 	avgday = sum(of days1-days&closfobr) / &closfobr; %** calculated the average number of days **;
						if sum(of actgpv1-actgpv&closfobr) > 0 then
							avgrate = sum(of actdol1-actdol&closfobr) / (sum(of actgpv1-actgpv&closfobr) / becv);
						  else avgrate = 0;
						%** use the state avg for missing data **;
						if avgday = 0 or avgrate = 0 then do;
							avgday = state_avgday;
							avgrate = state_avgrate;
						end;
						do i = &fobrmon to 12;
							%** if there are no days, add in the average to fill the calendar **;
							if days{i} in (.,0) then do;
								promos{i} = 1;
								days{i} = avgday;
								mrate{i} = avgrate;
							end;
						end; %** end fobrmon to 12 **;
				end; %** end of brand/pkg then do; 
			end; %** end Ohio and closeFOBR > 0 **;
			drop avgrate avgday i state_avgday state_avgrate state becv;
		run;
	%end;
%mend OhMull;
%OhMull;
%**  End of OH Mulligan add logic **;
%**  ---------------------------------------------------------------------------------------------------------------- **;

%** takes about an hour to get to this step... **;

%macro actualGPV; %** will be used to build rpv proxies **;
	
	%if &closeMon = 0 %then %do; 
		%** forecasting the entire year - no months closed **;
		data currActuals;
			set forecastData;
			&FIXLINES; 
			keep wslr bnd line;

		proc sort data = currActuals nodupkey;
			by wslr bnd line;

	%end;
	%else %do;
		%** only keep actual gpv from all of last year and up thru the most recent closed month **;
		data currActuals (keep=wslr bnd line actgpv13-actgpv&newClose days13-days&newclose);
			set forecastData;
			&FIXLINES;
			rename actgpv1-actgpv12 = actgpv13-actgpv24;
			rename days1-days12 = days13-days24;


		proc sort data = currActuals;
			by wslr bnd line;

		proc summary data = currActuals;
			by wslr bnd line;
			var actgpv13-actgpv&newClose days13-days&newclose;;
			output out = currActuals (drop= _type_ _freq_) sum=;

		*** fix lines could result in records being summed together, make sure that the days are not > than the days in month;
		data currActuals;
			set currActuals;
			if days13 > 31 then days13 = 31; if days14 > 28 then days14 = 28; if days15 > 31 then days15 = 31;
			if days16 > 30 then days16 = 30; if days17 > 31 then days17 = 31; if days18 > 30 then days18 = 30;
			if days19 > 31 then days19 = 31; if days20 > 31 then days20 = 31; if days21 > 30 then days21 = 30;
			if days22 > 31 then days22 = 31; if days23 > 30 then days23 = 30; if days24 > 31 then days24 = 31;
			keep wslr bnd line actgpv13-actgpv&newClose days13-days&newclose;
		
	%end;

run;
%mend actualGPV; %actualGPV;

DATA VOL0;
  MERGE VOL0 (IN=A) currActuals (IN=B);
  BY WSLR BND LINE;
  %MACRO allowZeroRPV;
    %IF &ZERORPV='N' %THEN %LET ZERO=%STR( IF B; ) ; %** only keep volume that has promotions **;
	%** this step will either resolve to IF B; %** or will reslove to a blank comment *; 
    %ELSE %LET ZERO = %STR( *; ) ;	%** keep all of the volume **;
    &ZERO;
  %MEND allowZeroRPV; %allowZeroRPV;

%** read in the wslr table **;
data wslrInfo;
*	set tableDir.wslr;
	set wslrInfoTemp;
	keep wslr state mca wslrsdir;

proc sort data = wslrInfo nodupkey;
	by wslr;

%** merge in the wslr info with the volume **;
data vol0;
	merge vol0 (in=a) wslrInfo (in=b);
	by wslr;
	if a;

%** add in the shortfam **;
data vol0;
	set vol0;
	%makefamsmart;
	drop famord bndord family famnum vat_shortfam vat_family vat_famord
			core_bnd ab_prod_bnd inbev_bnd rpt_fam_num rpt_family IMPRPT_FAMILY IMPRPT_FAM_NUM;
run;

%*  READ IN THE PREVIOUS FINAL PYE FILE MERGE WITH THE VOLUME *;
%** 10/28/2013 - the following will merge 24oz and 25oz pkgs to create new 25oz records to get better RPV proxy **;

/*
Commented out CombineRPVProxy macro, not being used
*/
*%CombineRPVProxy;
*%CombineVolForProxy;

data prevYear (bufno=32);
	set Rvsd_PriorYrProxy; %** 10/28/2013 - changed from build.&priorYrProxy;
	&fixlines; 
	%** rename the variables on the proxy file to be actGpv **;
	rename gpv1-gpv12 = actgpv1-actgpv12;

proc sort data = prevYear;
	by wslr bnd line;

proc summary data = prevYear;
	by wslr bnd line;
	var actgpv1-actgpv12 days1-days12;
	output out = prevYear (drop= _type_ _freq_) sum=;
run;


%** fix lines could result in records being summed together, make sure that the days are not > than the days in month;
data PREVYEAR;
	set PREVYEAR;
	if days1 > 31 then days1 = 31;	if days2 > 28 then days2 = 28; if days3 > 31 then days3 = 31;
	if days4 > 30 then days4 = 30;	if days5 > 31 then days5 = 31; if days6 > 30 then days6 = 30;
	if days7 > 31 then days7 = 31;	if days8 > 31 then days8 = 31; if days9 > 30 then days9 = 30;
	if days10 > 31 then days10 = 31;  if days11 > 30 then days11 = 30; if days12 > 31 then days12 = 31;


proc sort data=vol0;
	by wslr bnd line;

%** at this point vol0 has the current years gpv -- and prevYear has last years **;
DATA VOL0;
  MERGE VOL0 (IN=A) PREVYEAR (IN=B);
  BY WSLR BND LINE;
  IF A; %** keep the WBL if there is volume **;

data vol0;
  set vol0;
  array vol{&newClose} vol1-vol&newClose;
  array actgpv{&newClose} actgpv1-actgpv&newClose;
  %** change missing values to 0 **;
  do i = 1 to &newClose;
		if vol{i} = . then vol{i} = 0;
		if actgpv{i} = . then actgpv{i} = 0;
  end;
  %* ZERO OUT STRS IN THOSE MONTHS WHICH HAD NO PROMOTIONAL GPV IN THE PREVIOUS YEAR TO *;
  %* GET A TIGHTER (higher) RPV PROXY FOR THE CURRENT YEAR *;
  if &ZERORPV = 'N' then do;
  		do i = 1 to &newClose;
			if actgpv{i} = 0 then vol{i} = 0; %** RBS ? **; 
		end;
  end;
  drop i;

  %** CHECK VOL 12 HERE ! **;

data vol0;
	set vol0;
	%** keep track of the promo days at each level **;
	array days{&newClose} days1-days&newClose;
	array actgpv{&newClose} actgpv1-actgpv&newClose;
	array dayWght{&newClose} dayWght1-dayWght&newClose;
	do i = 1 to &newClose;
		if days{i} = . then days{i} = 0;
		%** gpv weight the promo days in each month **;
		dayWght{i} = days{i} * actgpv{i};
	end;
	drop i;
	altfam = shortfam;
	altline = line;
	%* moved this logic into a separte job that gets included **;
	%*IF BND = 'BLL' then altfam = 'Budweiser Brands';
	%*if line = 153 then altline = 122;
* Neutered 6/18/25;
	%*altFamPkg;
run;

%** this macro will sum up the volume and gpv at the different proxy levels **;
%** it will create datasets for each proxy - each data set will contain volume and gpv at the summary level **;
%** of that particular proxy.  Months 1 - the NewClose are kept at this point.  The next step will figure out **;
%** the timing for each proxy step **;
%MACRO MAKESORT;
   %DO I=1 %TO &PROXIES+0 ;
       &&SORT&I
   %END;
   run;
%MEND MAKESORT; %MAKESORT;

%** include the timing to calculate the rpv proxy **;
%MACRO MAKERPV;
  %DO I=1 %TO &PROXIES +0 ;
    %*  ASSIGN A VALUE FOR THE FIRST MONTH TO USE FOR MOVING AVERAGES;
    %IF %SUBSTR(&&RPV&I..,4,1)=3 %THEN %LET OPEN=%EVAL(-2+&NEWCLOSE);
    %IF %SUBSTR(&&RPV&I..,4,1)=6 %THEN %LET OPEN=%EVAL(-5+&NEWCLOSE);
    %IF %SUBSTR(&&RPV&I..,4,1)=9 %THEN %LET OPEN=%EVAL(-8+&NEWCLOSE);
    %IF %SUBSTR(&&RPV&I..,4,1)=2 %THEN %LET OPEN=%EVAL(-11+&NEWCLOSE);
      DATA VOL&I (DROP=VOL1-VOL12 actGPV1-actGPV12 dayWght1-dayWght12 J);
       SET VOL&I;
       ARRAY VOL {12} VOL1-VOL12;
       ARRAY actGPV {12} actGPV1-actGPV12;
       ARRAY RPV {12} PROXY1-PROXY12;
	   array dayWght{12} dayWght1-dayWght12;
	   array dayProxy{12} dayProxy1-dayProxy12;
	   ARRAY TRACKPROXY{12} TRACKPROXY1-TRACKPROXY12;
       DO J=1 TO 12;
          %*  TIME=M   USE MONTHLY RPV FROM PREVIOUS YEAR ;
          %IF %SUBSTR(&&RPV&I..,4,1)=M %THEN %LET RPVCALC=%STR(
              IF VOL{J} GT 0 THEN RPV{J} = actGPV{J} / VOL{J};
				if actgpv{j} > 0 then dayProxy{j} = dayWght{j} / actgpv{j}; );
          %*  TIME=P   USE PREVIOUS CALENDAR YEAR (FULL YEAR) RPV;
          %IF %SUBSTR(&&RPV&I..,4,1)=P %THEN %LET RPVCALC=%STR(
              IF SUM(OF VOL1-VOL12) GT 0 THEN
                 RPV{J} = SUM(OF actGPV1-actGPV12) /
                          SUM(OF VOL1-VOL12);
			  if SUM(OF actgpv1-actgpv12) > 0 then dayProxy{j} = 
						sum ( of dayWght1-dayWght12) / SUM(OF actGPV1-actGPV12); );
          %*  TIME=Y   USE YTD (Full Yr Last Year + Current YTD) RPV FOR OUTLOOK MONTHS ONLY;
          %IF %SUBSTR(&&RPV&I..,4,1)=Y %THEN %LET RPVCALC=%STR(
              IF SUM(OF VOL1-VOL&NEWCLOSE) GT 0 THEN
                 RPV{J} = SUM(OF actGPV1-actGPV&NEWCLOSE) /
                          SUM(OF VOL1-VOL&NEWCLOSE);
			  if SUM(OF actgpv1-actgpv&NEWCLOSE) > 0 then dayProxy{j} = 
					sum ( of dayWght1-dayWght&NEWCLOSE) / SUM(OF actGPV1-actGPV&NEWCLOSE); );
          %*  TIME=3   USE THREE MONTH MOVING AVG ENDING IN CLOSEMON;
          %IF %SUBSTR(&&RPV&I..,4,1)=3 %THEN %LET RPVCALC=%STR(
              IF SUM(OF VOL&OPEN-VOL&NEWCLOSE) GT 0
                 THEN RPV{J} =
                  SUM(OF actGPV&OPEN-actGPV&NEWCLOSE) /
                  SUM(OF VOL&OPEN-VOL&NEWCLOSE);			  
				if SUM(OF actgpv&OPEN-actgpv&NEWCLOSE) > 0 then dayProxy{j} = 
					sum ( of dayWght&OPEN-dayWght&NEWCLOSE) / SUM(OF actGPV&OPEN-actGPV&NEWCLOSE); );
          %*  TIME=6   USE SIX MONTH MOVING AVG ENDING IN CLOSEMON;
          %IF %SUBSTR(&&RPV&I..,4,1)=6 %THEN %LET RPVCALC=%STR(
              IF SUM(OF VOL&OPEN-VOL&NEWCLOSE) GT 0
                 THEN RPV{J} =
                  SUM(OF actGPV&OPEN-actGPV&NEWCLOSE) /
                  SUM(OF VOL&OPEN-VOL&NEWCLOSE);
			  if SUM(OF actgpv&OPEN-actgpv&NEWCLOSE) > 0 then dayProxy{j} = 
					sum ( of dayWght&OPEN-dayWght&NEWCLOSE) / SUM(OF actGPV&OPEN-actGPV&NEWCLOSE); );
          %*  TIME=9   USE NINE MONTH MOVING AVG ENDING IN CLOSEMON;
          %IF %SUBSTR(&&RPV&I..,4,1)=9 %THEN %LET RPVCALC=%STR(
              IF SUM(OF VOL&OPEN-VOL&NEWCLOSE) GT 0
                 THEN RPV{J} =
                  SUM(OF actGPV&OPEN-actGPV&NEWCLOSE) /
                  SUM(OF VOL&OPEN-VOL&NEWCLOSE);
    		  if SUM(OF actgpv&OPEN-actgpv&NEWCLOSE) > 0 then dayProxy{j} = 
				  sum ( of dayWght&OPEN-dayWght&NEWCLOSE) / SUM(OF actGPV&OPEN-actGPV&NEWCLOSE); );
          %*  TIME=2   USE TWELVE MONTH MOVING AVG ENDING IN CLOSEMON;
          %IF %SUBSTR(&&RPV&I..,4,1)=2 %THEN %LET RPVCALC=%STR(
              IF SUM(OF VOL&OPEN-VOL&NEWCLOSE) GT 0
                 THEN RPV{J} =
                  SUM(OF actGPV&OPEN-actGPV&NEWCLOSE) /
                  SUM(OF VOL&OPEN-VOL&NEWCLOSE);
			  if SUM(OF actgpv&OPEN-actgpv&NEWCLOSE) > 0 then dayProxy{j} = 
					sum ( of dayWght&OPEN-dayWght&NEWCLOSE) / SUM(OF actGPV&OPEN-actGPV&NEWCLOSE); );
          &RPVCALC
          %IF &ZERORPV='Y'
              %THEN %LET ZEROOUT=%STR(*;);
          %ELSE %LET ZEROOUT=%STR(IF RPV{J}=0 THEN RPV{J}=.;);
          &ZEROOUT ;
		  %** keep track of which proxy is used **;
		  IF RPV{J} = . THEN TRACKPROXY{J} = .;
		  	ELSE TRACKPROXY{J} = &I; 
       END;
  %END;
  run;
%MEND MAKERPV;
%MAKERPV;

%** the RPV data set will contain the wslr bnd line codes for which to assign a proxy to **;
DATA RPV (KEEP=WSLR MCA STATE wslrsdir BND shortfam LINE altfam altline);
  SET VOL0;
run;

%** RPV will be merged with VOL1 thru VOL{# of proxies} -- each month will be assigned a proxy **;
%MACRO MERGEALL;
   %DO I=1 %TO &PROXIES;
       &&MERGE&I;
   %END;
   run;
%MEND MERGEALL;
%MERGEALL;

%** keep the WBL6 month cut to look for new trends in the RPV **;
data RPVTREND;
	set VOL2;
	%** b/c this is a 6 month average proxy vars 1-12 all have the same value **;
	%** keep proxy1, but it will have the same value as 2-12 **;
	rename proxy1 = sixMonthProxy;
	rename dayProxy1 = sixMonthDays;
	if dayProxy1  = . or proxy1 = . then delete;
	keep wslr bnd line proxy1 dayProxy1;
run;

%** delete all of the datasets that were created / needed during the the rpv proxy creation **;
%MACRO deleteDatasets;
   %DO I=1 %TO &PROXIES;
       proc datasets library=work nolist;
			delete vol&i; quit;
   %END;
   run;
%MEND deleteDatasets;
%deleteDatasets;

proc sort data = rpv;
	by wslr bnd line;
run;

%** write out data sets that track which RPVs were used **;
DATA build.Rpv_Proxy&year. (LABEL='FCST RPV PROXIES') work.specRpvProxiesUsed;
	set rpv;

data rpv;
	set rpv;
	rename rpv1-rpv12 = rpvProxy1-rpvProxy12;
	rename days1-days12 = dayProxy1-dayProxy12;
	keep wslr bnd line rpv1-rpv12 days1-days12 proxy_used1-proxy_used12;
run;

%** calculate the RPV forecast **;
%*proc sort data = rpv;
%*	by wslr bnd line;
proc sort data = forecastData;
	by wslr bnd line;

%** FIND OUT IF TEMP HAS ANY RECORDS IN IT ! **;
data forecastData temp;
	merge forecastData (in=a) rpv (in=b);
	by wslr bnd line;
	if a and b then output forecastData;
	if a and not b then output temp;
run;

%** Merge in the RPV Trend to Adjust the proxy for new changes in RPV **;
proc sort data = RPVTREND;
	by wslr bnd line;

data forecastData;
	merge forecastData (in=a) RPVTREND (in=b);
	by wslr bnd line;
	if a;
run;

%** JLA 8/29/08 Adjust the proxy for new changes in RPV **;
data forecastData;
	set forecastData;
	array days{12} days1-days12;
	array proxy_used{12} proxy_used1-proxy_used12;
	array rpvProxy{12} rpvProxy1-rpvProxy12;
	array dayProxy{12} dayProxy1-dayProxy12;
	array changeProxy{12} changeProxy1-changeProxy12;
	%** get the average number of promo days during the year **;
	avgDays = 0; avgDayCnt = 0;
	do i = 1 to 12;
		%** keep 0 days out of the calc so they dont bring down the avg **;
		if days{i} > 0 then do;
			avgDays = avgDays + days{i};
			avgDayCnt = avgDayCnt + 1;
		end;
		changeProxy{i} = 0;
	end;
	%** calc the average number promo days **;
	if avgDayCnt > 0 then avgDays = round(avgDays / avgDayCnt,0.001);
	if sixMonthProxy = . then sixMonthProxy = 0;
	if sixMonthDays = . then sixMonthDays = 0;
	do i = 1 to 12;
	    if days{i} > 0 then do;
			%** compare the avg days to the days in the month, if the difference is less than or equal to 4 **;
			%** the month can be considered to not be seasonal do to changes in the days **;
			if abs(days{i} - avgDays) <= 4 then do;
				%** check the proxy that was used, if it was the WBLM then continue **;
				if proxy_used{i} = 1 then do;
					if sixMonthProxy > 0 and sixMonthDays > 0 then do;
						%** if the rpv variance is 25% or more then use the 6 month proxy **;
						if abs(sixMonthProxy - rpvProxy{i}) >= .25 then do;
							rpvProxy{i} = sixMonthProxy;
							dayProxy{i} = sixMonthDays;
							changeProxy{i} = 1;
						end; %** end >= .25 **;
					end; %** end 6 months > 0 **;
				end; %** end proxy used **;
			end; %** end abs(days{i})... ;
		end; %** end days{i} > 0 **;
	end; %** end i loop **;
	%** drop the vars needed only in this step **;
	drop i avgDays avgDayCnt proxy_used1-proxy_used12 sixMonthProxy sixMonthDays;
run;

%** add state code to the data **;
/*proc sort data = tabledir.wslr (keep = wslr statcode wslrsdir) out=wslrInfo nodupkey;
	by wslr;
*/
proc sort data = wslrInfoTemp (keep = wslr statcode wslrsdir) out=wslrInfo nodupkey;
	by wslr;

proc sort data = wslrInfo;
	by wslr;
run;
data forecastData;
	merge forecastData (in=a) wslrInfo (in=b);
	by wslr;
	if a;
run;

%** keep a record of the items with changed rpv proxies **;
data changeProxy;
	set forecastData;
	if sum (of changeProxy1-changeProxy12) > 0;

data build.RpvChangedTo6Month&Year.;
	set changeProxy;
run;

%** JLA 9/24/2010 - Start of Changed RPV Forecasting Logic **;
Proc Sort data = ForecastData;
	By Line;

Proc Sort Data = Tabledir.Packages (keep=line pkgdft) Out=PkgDft Nodupkey;
	By Line;
Run;

Data ForecastData;
	Merge ForecastData (in=a) PkgDft (in=b);
	By Line;
	If a;
Run;

Data ForecastData;
	Set ForecastData;
	%** Ensure PkgDft is never missing - assume package beer if it is **;
	If PkgDft In ('',' ') Then PkgDft = 'P';
Run;

%** Bring in the RPV Day weighting file -- using regression analysis (RPV = Promo Days), this file contains how much **;
%** RPV is impacted for each promo day that is added/subtracted **;
Proc Sort Data = Build.Rpv_day_weights Out = RPV_Day (Keep = State Wslrsdir Pkgdft Rpv_Per_Day);
	By State Wslrsdir Pkgdft;
Run;

Proc Sort Data = ForecastData;
	By State Wslrsdir Pkgdft;

Data ForecastData;
	Merge ForecastData (in=a) RPV_Day (in=b);
	By State Wslrsdir Pkgdft;
	If a;
Run;

%** JLA 9/24/2010 - Changed RPV Forecasting Logic **;
Data ForecastData;
	Set ForecastData;
	array rpvProxy{12} rpvProxy1-rpvProxy12; %** proxy rpv - represents the prior year **;
	array dayProxy{12} dayProxy1-dayProxy12; %** days that made the rpv proxies **;
	array days{12} days1-days12; %** forecast year planned days **;
	array DayChg{12} DayChg1-DayChg12; %** Change in Days **;
	array Rpv{12} Rpv1-Rpv12; %** forecasted RPV - result of day adjustment **;
	array RpvAdj{12} RpvAdj1-RpvAdj12; %** adjustment to make to RPV **;
	array daysInMonth{12} daysInMonth1-daysInMonth12; %** number of calendar days in each month **;
	array rpvDiff{12} rpvDiff1-rpvDiff12;
	%** If RPV Per Day is missing for any reason, assume it to be 1/30 or 3.33% per day**;
	If Rpv_Per_Day = . Then Rpv_Per_Day = 1/30;
	%** load up an array with the calendar days in each month **;
	daysInMonth1 = 31;	daysInMonth2 = 28; daysInMonth3 = 31;
	daysInMonth4 = 30;	daysInMonth5 = 31; daysInMonth6 = 30;
	daysInMonth7 = 31;	daysInMonth8 = 31; daysInMonth9 = 30;
	daysInMonth10 = 31; daysInMonth11 = 30; daysInMonth12 = 31;
	Do i = 1 to 12;
		DayChg{i} = 0;
		RpvAdj{i} = 0;
		rpv{i} = 0;
		%** This RPV/Day will be used in the calc b/c the value may be overwritten **;
		RpvDay = Rpv_Per_Day; %** Reset each time **;
		%** must have planned days this year and days last year **;
		%** if a wbl was entirely non GM in 2006, dayProxy for that month will be 0 **;
		If days{i} > 0 and  dayProxy{i} > 0 Then Do;
			DayChg{i} = Days{i} - DayProxy{i}; %** Calc the Change In Days **;
			%** Take the Min of the RPV Per Day and the RPV Proxy / Days -- if the Proxy was small over a small num of **;
			%** days then the RPV Proxy / Days is usually smaller than the regression based RPV Per Day **;
			%** Ex... 5% on 5 days = 1% while the Regression based RPV Per Day might be higher **;
			%** using the min of the 2 provides a more conservative estimate **;
			RpvDay = Min (Of RpvDay, RpvProxy{i}/DayProxy{i});
			DayChg{i} = Round(DayChg{i}); %** Round the day change to no decimls **;
			If DayChg{i} > 0 Then Do; %** If days are added, assume each additional day is worth the cal rpv/day **;
				If DayChg{i} <= 3 Then Do; %** 1 - 3 Days added apply 25% saftey **;
					RpvAdj{i} = DayChg{i} * 0.25 * 1/daysInMonth{i};  
				End;
				Else If DayChg{i} <= 5 Then Do; %** 4 - 5 Days added apply 75% saftey **;
					RpvAdj{i} = DayChg{i} * 0.75 * 1/daysInMonth{i};  
				End;
				Else Do; %** 6 or more Days added apply no saftey **;
					RpvAdj{i} = DayChg{i} * 1/daysInMonth{i};  
				End;
			End;
			Else If DayChg{i} <= -4 Then Do; %** At least 4 Days Removed **;
				If DayChg{i} = -4 Or DayChg{i} = -5 Then Do;
					RpvAdj{i}  = DayChg{i} * 0.25 * RpvDay; %**  4 - 5 Days removed apply 25% saftey **;
				End;
				Else If DayChg{i} <= -6 And DayChg{i} >= -25 Then Do;
					RpvAdj{i}  = DayChg{i} * 0.80 * RpvDay; %**  b/w 6 amd 25 Days removed apply 80% saftey **;
				End;
				Else Do; %** 26 or more days removed **;
					RpvAdj{i}  = DayChg{i} * RpvDay; %**  apply no saftey, use slope of RpvDay only **;
				End;
			End;
			%** Adjust the Proxy For Changes In Days And Forecast New RPV **;
			Rpv{i} = RpvProxy{i} + RpvAdj{i};
		End;
		Else Do;	
			%** no day adjustment can occur if the planned days are 0.  Planned days will be zero if there are no **;
			%** promos in the month or if the promotions are entirely non GM **;
			Rpv{i} = rpvProxy{i};
		End;
		%** Make sure the RPV is capped at 100% **;
		if rpv{i} > 1 then rpv{i} = 1;
		rpvDiff{i} = rpv{i} - rpvProxy{i};
	End; %** end do i = 1 to 12 **;
	Drop i Wslrsdir PkgDft;
Run;

%** JLA 12/23/2008 **;
%macro MilitaryPromos; %** This step will adjust the rpv for months that are 100% military only **;

	data MilPromos;
		%readSnapSpec; 
		*&xalliance; %** remove any alliance brand dollars and calendars **;
		%if &readSnap ^= PlanB_PREV %then %do;
	       &fixlines;
	    %end;
		%Days;
		Keep wslr bnd line civmil days1-days12;
	run;

	data MilPromos;
		set MilPromos;
		array PromoCount{12} PromoCount1-PromoCount12;
		array MilCount{12} MilCount1-MilCount12;
		array days{12} days1-days12;
		do i = 1 to 12;
			PromoCount{i} = 0;
			MilCount{i} = 0;
			if days{i} > 0 then do;
				PromoCount{i} = 1;
			end;
			if civmil = 'M' and days{i} > 0 then do;
				MilCount{i} = 1;
			end;
		end;
		keep wslr bnd line PromoCount1-PromoCount12 MilCount1-MilCount12;
	run;

	proc sort data = MilPromos;
		by wslr bnd line;
	
	%** dont need to worry about counting QDs as a single promo b/c the purpose of this step is to see if all **;
	%** the promos in the month are military only **;
	proc summary data = MilPromos;
		by wslr bnd line;
		var PromoCount1-PromoCount12 MilCount1-MilCount12;
		output out = MilPromos (Drop= _type_ _freq_) sum=;
	run;

	%** only keep recs with military promos **;
	data MilPromos;
		set MilPromos;
		if sum (of MilCount1-MilCount12) > 0;
	run;

	%** Bring in the Channel Vol Military % Of Volume **;
	%** for promotions that are 100% Military make the RPV proxy the percent of Military **;
	%** volume from the Channel Volume Model;
	data militaryVol;
		set chanVol.channelVol12Mnth;
		%** if the volume is not military make it civilian **;
		if segment NE 'MILITARY' then segment = 'CIVILIAN';
		keep wslr family line segment bbls;

	data militaryVol;
		set militaryVol;
		format wslrNum 5.;
		wslrNum = wslr+0;
		lineNum = line+0;
		keep wslrNum family lineNum segment bbls;

	data militaryVol;
		set militaryVol;
		rename wslrNum = wslr;
        rename lineNum = line;
	run;

	data militaryVol;
		set militaryVol;
		&fixlines;
		keep wslr family line segment bbls;

	proc sort data = militaryVol;
		by wslr family line segment;

	proc summary data = militaryVol;
		by wslr family line segment;
		var bbls;
		output out = militaryVol (drop= _type_ _freq_) sum=;
	run;

	data militaryVol;	
		set militaryVol;
		milVol = 0; civVol = 0;
		if segment = 'MILITARY' then milVol = bbls;
			else civVol = bbls;
		totalVol = bbls;
		if bbls < 0 then delete;
		drop bbls;

	proc sort data = militaryVol;
		by wslr family line;

	proc summary data = militaryVol;
		by wslr family line;
		var milVol civVol totalVol;
		output out = militaryVol (drop= _type_ _freq_) sum=;
	run;

	%** calculate the percent of volume that military makes up **;
	%** this will be used as the proxy for military only promotions **;
	data militaryVol;
		set militaryVol;
		format wslrNum 5.;
		MilPer = coalesce(milVol / totalVol,0);
		/*if milVol = 0 then delete; */
		wslrNum = wslr+0;
		keep wslrNum family line MilPer;
	run;

	data militaryVol;
		set militaryVol;
		rename wslrNum = wslr;
	run;

	%** Merge the Family Level Mil Percent back with the Bnd Level records **;
	data MilPromos;
		set MilPromos;
		%makefamsmart;
		keep wslr family bnd line PromoCount1-PromoCount12 MilCount1-MilCount12;

	proc sort data = MilPromos;
		by wslr family line;
	proc sort data = militaryVol;
		by wslr family line;
	run;

	data MilPromos; %** merge counts with percent of vol **;
		merge MilPromos (in=a) militaryVol (in=b);
		by wslr family line;
		if a; %** must have promos and volume **; /*BAE2*/
		drop family; 
	run;

	%** merge the Mil data back with the main forecast data **;
	proc sort data = forecastData;
		by wslr bnd line;

	proc sort data = MilPromos;
		by wslr bnd line;
	run;

	data forecastData;
		merge forecastData (in=a) MilPromos (in=b);
		by wslr bnd line;
		if a; %** keep all the recs from fcst data **;
	run;

	%** Adjust the RPV if the month in 100% Military **;
	data forecastData;
		set forecastData;
		array rpv{12} rpv1-rpv12; %** calculated rpv from the steps above **;
		array PromoCount{12} PromoCount1-PromoCount12;
		array MilCount{12} MilCount1-MilCount12;
		AdjForMil = 'N';
		do i = 1 to 12;
			%** will be missing if there was no military activity **;
			if PromoCount{i} = . then PromoCount{i} = 0;
			if MilCount{i} = . then MilCount{i} = 0;
			if PromoCount{i} > 0 and MilCount{i} > 0 then do;
				if MilCount{i} = PromoCount{i} then do; %** all promos as military promos **;
					if MilPer >= 0 then do; /*BAE3*/
						rpv{i} = MilPer;
						AdjForMil = 'Y';
					end;
				end;
			end; %** end counts > 0 **;
		end; %** end 1 to 12 **;
		drop i PromoCount1-PromoCount12 MilCount1-MilCount12 MilPer;
	run;

	%** keep a record of the promos where the RPV was changed **;
	data build.RpvChangedForMil&year.;
		set forecastData (where = (AdjForMil = 'Y'));
	run;
	
%mend MilitaryPromos;
%MilitaryPromos;

%Macro PromoPercents;
	%if &PromoPer = Y %then %do;
		%** Use volume Percent RPV if lowest retail level is not GM and Calc RPV is greater than Vol Per RPV**;
		data chkRPVs;
			set build.&PromoPerFl.;
			array rpvPercents{12} PERC_TOTL_QTY_M1-PERC_TOTL_QTY_M12; %** percents used to weight the rates **;
			format wslr 5. grp 3.;
			wslr = WSLR_NUMBER+0;
			grp = PRICE_GROUP_CD+0;
			do i = 1 to 12;
				if rpvPercents{i} = . then rpvPercents{i} = 0;
			end;
			drop WSLR_NUMBER PRICE_GROUP_CD  PERC_PROMO_QTY_M1-PERC_PROMO_QTY_M12 PERC_GEO_GRP_M1-PERC_GEO_GRP_M12 i;
		run;

		data pkgInfo;
			set tableDir.packages;
			keep grp line;

		proc sort data = pkgInfo nodupkey;
			by grp;

		proc sort data = chkRPVs;
			by grp;

		data chkRPVs;
			merge chkRPVs (in=a) pkgInfo (in=b);
			by grp;
			if a;

		proc sort data = chkRPVs;
			by wslr bnd line;

		proc summary data = chkRPVs;
			by wslr bnd line;
			var PERC_TOTL_QTY_M1-PERC_TOTL_QTY_M12;
			output out = chkRPVs (drop= _type_ _freq_) sum=;
		run;

		%** Use RPV at the Volume Percents level if lowest level is not GM **;
		data MinRateLvl;
			set build.rateWeights&year.;
			array Lvl{12} Lvl1-Lvl12;
			array maxRates{12} maxRates1-maxRates12;
			do i = 1 to 12;
				%** dont init rtl level to zero - b/c 0 would then be the min **;
				if maxRates{i} ^= 0 then do;
					Lvl{i} = rtl_level;
				end;
			end;
		run;

		proc sort data = MinRateLvl;
			by wslr bnd line;

		proc summary data = MinRateLvl;
			by wslr bnd line;
			output out = MinRateLvl (drop= _type_ _freq_) min(Lvl1-Lvl12)= max(state_GM_per)=;
		run;

		proc sort data = forecastData;
			by wslr bnd line;

		data forecastData;
			merge forecastData (in=a) MinRateLvl (in=b) chkRPVs (in=c);
			by wslr bnd line;
			if a;
		run;

		data forecastData;
			set forecastData;
			array rpv{12} rpv1-rpv12; %** calculated rpv from the steps above **;
			array Lvl{12} Lvl1-Lvl12;
			array vpRPV{12} PERC_TOTL_QTY_M1-PERC_TOTL_QTY_M12;
			if AdjForMil = 'N' then do; %** dont adj if the item already changed for military only **;
				do i = 1 to 12;
					if Lvl{i} = . then Lvl{i} = 0;
					if vpRPV{i} = . then vpRPV{i} = 0;
					if Lvl{i} > 1 then do; %** lowest level is not general market **;
						%** 9/23/2010 JLA - Added check to make sure vpRPV is > 0, some items getting zero RPVs  **;
						%** if the IT file said no volume was impacted -- to be conservative keep RPV fcst **;
						if rpv{i} > vpRPV{i} And vpRPV{i} > 0 then do; 
							rpv{i} = vpRPV{i}; %** If the RPV forecast is > than volume Per RPV then cap it at the VP RPV**;
						end;
					end;
				end;
			end;
			drop i Lvl1-Lvl12 PERC_TOTL_QTY_M1-PERC_TOTL_QTY_M12;
		run;
	%end;
%Mend PromoPercents;
%PromoPercents;

%** JLA 10/28/2010 Added to read in manual RPV Caps from Excel **;
%Macro ManualRpvCap;
	%if &ManRpv = Y %then %do;
		%** Read in the RPV caps **;
		PROC IMPORT OUT  = RpvCap
            DATAFILE = &RpvFl.
            DBMS     = EXCEL2000 REPLACE;
            RANGE    = 'CapData';
            GETNAMES = Yes;
		run;

		Data RpvCap;
			Set RpvCap;
			If AdjCap = . Then Delete;
			If AdjCap = 0 Then Delete;
			Keep Wslr Bnd Line AdjCap;
		run;

		proc sort data = forecastData;
			by wslr bnd line;
		proc sort data = RpvCap;
			by wslr bnd line;

		Data forecastData;
			Merge forecastData (in=a) RpvCap (in=b);
			By Wslr Bnd Line;
			If a;
		Run;

		Data forecastData;
			Set forecastData;
			Array Days{12} Days1-Days12;
			Array PromosOffered{12} PromosOffered1-PromosOffered12;
			Array Rpv{12} Rpv1-Rpv12;
			If AdjCap = . Then AdjCap = 0;
			If AdjCap > 0 Then Do; %** If there is a cap from Excel loop thru the records **;
				Do i = 1 to 12;
					If Days{i} = 0 And PromosOffered{i} > 0 Then Do; %** Promos but no GM promos **;
						If AdjCap < Rpv{i} Then Do; %** If cap is less than current RPV fcst then replace rpv **;
							Rpv{i} = AdjCap;
						End;
					End;
				End;
			End;
			Drop i AdjCap;
		Run;
	
		%** 11/29/10  add MN logic - cap regardless of proxy level **;
		PROC IMPORT OUT  = AllCap
            DATAFILE = &RpvFl.
            DBMS     = EXCEL2000 REPLACE;
            RANGE    = 'AllCap';
            GETNAMES = Yes;
		run;

		Data AllCap;
			Set AllCap;
			If AdjCap = . Then AdjCap = 0;
			Keep Wslr Bnd Line AdjCap;
		run;

		proc sort data = AllCap;
			by wslr bnd line;

		Data forecastData;
			Merge forecastData (in=a) AllCap (in=b);
			By Wslr Bnd Line;
			If a;
		Run;

		Data forecastData;
			Set forecastData;
			Array Days{12} Days1-Days12;
			Array PromosOffered{12} PromosOffered1-PromosOffered12;
			Array Rpv{12} Rpv1-Rpv12;
			If AdjCap ^= . Then Do; %** If there is a cap from Excel loop thru the records **;
				Do i = 1 to 12;
					%*If Days{i} = 0 And PromosOffered{i} > 0 Then Do; %** Promos but no GM promos **;
						If AdjCap < Rpv{i} Then Do; %** If cap is less than current RPV fcst then replace rpv **;
							Rpv{i} = AdjCap;
						End;
					%*End;
				End;
			End;
			Drop i AdjCap;
		Run;
	
	%end;
%Mend ManualRpvCap;
%ManualRpvCap;

%** calculate the max rate utilization **;
proc sort data = forecastData;
	by wslr bnd line;

%** this step is similar to the actual gpv step that was used to build the rpv proxies **;
%** this step will get any actual gpv/dollars/etc... that have been paid in the fcst year **;
%** only keep actual gpv from all of last year and up thru the most recent closed month **;
data currYearActuals;
	set forecastData;
	rename maxDol1-maxDol12 = maxDol13-maxDol24;
	rename actdol1-actdol12 = actdol13-actdol24;
	rename actgpv1-actgpv12 = actgpv13-actgpv24;
	rename promosOffered1-promosOffered12 = promosOffered13-promosOffered24;
	rename promosPaid1-promosPaid12 = promosPaid13-promosPaid24;
	keep wslr bnd line maxDol1-maxDol12 actdol1-actdol12 actgpv1-actgpv12 promosOffered1-promosOffered12
			promosPaid1-promosPaid12;
run;

proc sort data = currYearActuals;
	by wslr bnd line;

proc summary data = currYearActuals; %** make sure the file is at the wbl M level **;
	by wslr bnd line;
	var maxDol13-maxDol24 actdol13-actdol24 actgpv13-actgpv24 
			promosOffered13-promosOffered24 promosPaid13-promosPaid24;
	output out = currYearActuals (drop= _type_ _freq_) sum=;
run;

%** read in the historical proxy file **; 
data maxRateDollars;
	set Rvsd_PriorYrProxy; %** 10/28/2013 - replaced--> build.&priorYrProxy;
	%makefamsmart;
	&fixlines;
	%** rename the variables on the proxy file to be actDol and actGpv **;
	rename paid1-paid12 = actdol1-actdol12;
	rename gpv1-gpv12 = actgpv1-actgpv12;
	keep wslr shortfam bnd line maxDol1-maxDol12 gpv1-gpv12 paid1-paid12 promosOffered1-promosOffered12
		  promosPaid1-promosPaid12;	
run;

proc sort data = maxRateDollars;
	by wslr bnd line;

proc summary data = maxRateDollars;
	by wslr bnd line;
	var maxDol1-maxDol12 actgpv1-actgpv12 actdol1-actdol12 promosOffered1-promosOffered12 promosPaid1-promosPaid12;
	id shortfam;
	output out = maxRateDollars (drop= _type_ _freq_) sum=;

%** merge in the current year actual dollars, gpv, etc.. with last years dollars **;
proc sort data = currYearActuals;
	by wslr bnd line;

%** for actual dollars/gpv/etc... 1-12 = last year ** 13-24 = current year **;
data maxRateDollars;
	merge maxRateDollars (in=a) currYearActuals (in=b);
	by wslr bnd line;
	if a or b;

%** re-run make fam smart - if the WBL only existed in the maxRateDollars, the shortfam would be missing **;
%** b/c shortfam is not added to the currYearActuals dataset, It does exist on maxRateDollars **;
data maxRateDollars;
	set maxRateDollars;
	%makefamsmart;
	drop famord bndord family famnum vat_shortfam vat_family vat_famord
			core_bnd ab_prod_bnd inbev_bnd rpt_fam_num rpt_family IMPRPT_FAMILY IMPRPT_FAM_NUM;
run;

proc sort data = maxRateDollars;
	by wslr shortfam bnd line;

proc summary data = maxRateDollars; %** make sure the file is at the wbl M level **;
	by wslr shortfam bnd line;
	var maxDol1-maxDol24 actdol1-actdol24 actgpv1-actgpv24 
			promosOffered1-promosOffered24 promosPaid1-promosPaid24;
	output out = maxRateDollars (drop= _type_ _freq_) sum=;
run;

%** change any missing values to 0 **;
data maxRateDollars;
	set maxRateDollars;
	array actgpv{24} actgpv1-actgpv24;
	array actdol{24} actdol1-actdol24;
	array maxdol{24} maxDol1-maxDol24;
	array promosOffered{24} promosOffered1-promosOffered24;
	array promosPaid{24} promosPaid1-promosPaid24;
	do i = 1 to 24;
		if actgpv{i} = . then actgpv{i} = 0;
		if actdol{i} = . then actdol{i} = 0;
		if maxdol{i} = . then maxdol{i} = 0;
		if promosOffered{i} = . then promosOffered{i} = 0;
		if promosPaid{i} = . then promosPaid{i} = 0;
	end;
	drop i;
run;

%** drop all of the variables from the forecast dataset **;
%** they are currently 1-12, the 1-24 versions will be merged back in so that last years info is on the **;
%** forecastData dataset **;
data forecastData; 
	set forecastData;
	drop maxDol1-maxDol12 actdol1-actdol12 actgpv1-actgpv12 
			promosOffered1-promosOffered12 promosPaid1-promosPaid12;

proc sort data = forecastData;
	by wslr bnd line;
proc sort data = maxRateDollars;
	by wslr bnd line;

%** merge back in the variables **;
data forecastData;  %** give forecast data the 1-24 variables **;
	merge forecastData (in=a) maxRateDollars (in=b);
	by wslr bnd line;
	if a;
run;

%** re-run make fam smart - if the WBL only existed in the forecastData, the shortfam would be missing **;
%** b/c shortfam is not added to the forecastData dataset, It does exist on maxRateDollars **;
data forecastData;
	set forecastData;
	%makefamsmart;
	drop famord bndord family famnum vat_shortfam vat_family vat_famord
			core_bnd ab_prod_bnd inbev_bnd rpt_fam_num rpt_family IMPRPT_FAMILY IMPRPT_FAM_NUM;
run;

%** save a dataset that has the current years actual gpv, dollars, and promotion count + the proxy year actuals **;
%** the combined dataset will be used later in the program to determine promos offered but not taken **;
data combined;
	set maxRateDollars;
	drop shortfam;

%** read in the the package data to get the becv **;
data packageInfo;
	set tableDir.packages;
	keep line becv;

proc sort data = packageInfo nodupkey;
	by line;

proc sort data = maxRateDollars;
	by line;

data maxRateDollars;
	merge maxRateDollars (in=a) packageInfo (in=b);
	by line;
	if a;
run; 


%** JLA 9/24/2010 - Take the average of the 3 largest values over the last 6 months **;
data maxRateDollars;
	set maxRateDollars;
	array actdol{24} actdol1-actdol24;
	array maxDol{24} maxDol1-maxDol24;
	array RateUtil{24} RateUtil1-RateUtil24;
	array MaxSix{6} MaxSix1-MaxSix6;
	array LastSix{6} LastSix1-LastSix6;
	do i = 1 to 24;
		if actdol{i} = . then actdol{i} = 0;
		if maxdol{i} = . then maxdol{i} = 0;
		RateUtil{i} = 0;
		%** Calc Rate Utilization **;
		If maxdol{i} > 0 Then Do;
			RateUtil{i} = actdol{i} / maxdol{i};
		End;
	end;
	%** Get the last 6 Rate Utilizations **;
	CntVar = 1;
	%let x = %eval(&newclose.-5);
	do i = &x to &newclose.;
		LastSix{CntVar} = RateUtil{i};
		CntVar = CntVar+1;
	end;
	%** Re-order the rates so that MaxSix1 is the largest value from the last 6 months, MaxSiz2 is the 2nd, etc... **;
	do i=1 to 6;
    	MaxSix(i) = largest(i, of LastSix1-LastSix6);  
		%** Set 0 values to missing so they wont be included in the average **;
		If MaxSix(i) = 0 Then MaxSix(i) = .;
  	end;
	bndRateUtil = 0;
	%** Get the average of the 3 largest max rates over the last 6 months **;
	bndRateUtil = Mean ( of MaxSix1-MaxSix3);
	If bndRateUtil = . Then bndRateUtil = 0; %** Value will be . if no avg was calcd **;
	%** make sure the util % is never > than 100% **;
	if bndRateUtil > 1 then bndRateUtil = 1;
	drop i CntVar MaxSix1-MaxSix6 LastSix1-LastSix6;
run;
	
%** save a copy of the numbers used to calc the bnd level rate utilization **;
data /*build.bndLevelRateUtil*/ work.bndLevelRateUtil;
	set maxRateDollars;
	keep wslr bnd line bndRateUtil;

data maxRateDollars;
	set maxRateDollars;
	keep wslr bnd shortfam line actdol1-actdol24 maxDol1-maxDol24 bndRateUtil;
run;

%** add in the family level dollars, gpv, and max dollars **;
proc sort data = maxRateDollars;
	by wslr shortfam line;

proc summary data = maxRateDollars;
	by wslr shortfam line;
	var maxDol1-maxDol24 actdol1-actdol24;
	output out = maxRateDollarsFam (drop = _type_ _freq_) sum=;
run;

data maxRateDollarsFam;
	set maxRateDollarsFam;
	array actdol{24} actdol1-actdol24;
	array maxDol{24} maxDol1-maxDol24;
	array RateUtil{24} RateUtil1-RateUtil24;
	array MaxSix{6} MaxSix1-MaxSix6;
	array LastSix{6} LastSix1-LastSix6;
	do i = 1 to 24;
		if actdol{i} = . then actdol{i} = 0;
		if maxdol{i} = . then maxdol{i} = 0;
		RateUtil{i} = 0;
		%** Calc Rate Utilization **;
		If maxdol{i} > 0 Then Do;
			RateUtil{i} = actdol{i} / maxdol{i};
		End;
	end;
	%** Get the last 6 Rate Utilizations **;
	CntVar = 1;
	%let x = %eval(&newclose.-5);
	do i = &x to &newclose.;
		LastSix{CntVar} = RateUtil{i};
		CntVar = CntVar+1;
	end;
	%** Re-order the rates so that MaxSix1 is the largest value from the last 6 months, MaxSiz2 is the 2nd, etc... **;
	do i=1 to 6;
    	MaxSix(i) = largest(i, of LastSix1-LastSix6);  
		%** Set 0 values to missing so they wont be included in the average **;
		If MaxSix(i) = 0 Then MaxSix(i) = .;
  	end;
	famRateUtil = 0;
	%** Get the average of the 3 largest max rates over the last 6 months **;
	famRateUtil = Mean ( of MaxSix1-MaxSix3);
	If famRateUtil = . Then famRateUtil = 0; %** Value will be . if no avg was calcd **;
	%** make sure the util % is never > than 100% **;
	if famRateUtil > 1 then famRateUtil = 1;
	drop i CntVar MaxSix1-MaxSix6 LastSix1-LastSix6;
run;

%** save a copy of the numbers used to calc the fam level rate utilization **;
data /*build.famLevelRateUtil*/ work.famLevelRateUtil;
	set maxRateDollarsFam;
	keep wslr shortfam line famRateUtil;

data maxRateDollarsFam;
	set maxRateDollarsFam;
	keep wslr shortfam line famRateUtil;
run;

%** merge the family and brand level rate utilization together **;
data rateUtil;
	merge maxRateDollars (in=a) maxRateDollarsFam (in=b);
	by wslr shortfam line;
	if a;
Run;

data rateUtil;
	set rateUtil (keep = wslr bnd shortfam line bndRateUtil famRateUtil);
	%** use the family level rate utilization in the bnd level is missing **;
	utilUsed = ' ';
	fcstRateUtil = bndRateUtil;
	utilUsed = 'B'; %** set a flag to indicate the bnd level was used **;
	if fcstRateUtil = 0 then do;
		fcstRateUtil = famRateUtil;
		utilUsed = 'F'; %** set a flag to indicate the family level was used **;
	end;
	%** assume 100% rate util if there is no bnd or family historical rate util **;
	if bndRateUtil = 0 and famRateUtil = 0 then do; 
		fcstRateUtil = 1;
		utilUsed = ' '; %** set a flag to indicate a rate util proxy was not found **;
	end;
	%** Make sure rate util is not over 100 **;
	if fcstRateUtil > 1 then fcstRateUtil = 1;
	keep wslr bnd line fcstRateUtil utilUsed;
run;

proc sort data = rateUtil;
	by wslr bnd line;
proc sort data = forecastData;
	by wslr bnd line;

data forecastData (bufno=32);
	merge forecastData (in=a) rateUtil (in=b);
	by wslr bnd line;
	if a;

%** read in the wslr table **;
data wslrInfo;
*	set tableDir.wslr;
	set wslrInfoTemp;
	keep wslr state;

proc sort data = wslrInfo nodupkey;
	by wslr;

data rateUtil;
	merge rateUtil (in=a) wslrInfo (in=b);
	by wslr;
	if a;

data build.RateUtil&year.; %** save a copy of the rate util that was used **;
	set rateUtil; run; 

%** calculate the rate forecast **;
data forecastData;
	set forecastData;
	array wgtdRate{12} wgtdRate1-wgtdRate12;
	array rate{12} rate1-rate12;
	if fcstRateUtil = . then fcstRateUtil = 1; %** make sure there is a rate util fcst **;
	%** apply the rate util proxy to the wgthd Max Rate **;
	do i = 1 to 12;
		if wgtdRate{i} = . then wgtdRate{i} = 0;
		rate{i} = wgtdRate{i} * fcstRateUtil;
	end;
	drop i;
run;

proc sort data=combined;
  by wslr bnd line;
run;

data notTaken;
  merge combined(in=a) vol_taken(in=b keep=wslr bnd line vol1-vol&newclose.);
  by wslr bnd line;
  if a;
run;

%** determine if a forecast should be made based on offered and not taken promos **;
data notTaken (bufno=32);
	set notTaken;
	array promosOffered{24} promosOffered1-promosOffered24;
	array actdol{24} actdol1-actdol24; %** actual dollars paid **;
	array zeroFcst{12} zeroFcst1-zeroFcst12; %** 1/0 flag to keep the fcst or not based on offered but not taken **;
	array vol{&newclose.} vol1-vol&newclose.;

	do i = 1 to &newclose.;
		if vol{i} = . then vol{i} = 0;
	end;
	%** make sure there are no missing values **;
	do i = 1 to 24;
		if promosOffered{i} = . then promosOffered{i} = 0;
		if actdol{i} = . then actdol{i} = 0;
	end;
	do i = 1 to 12;
		zeroFcst{i} = 1; %** set all the flags to 1, meaning keep the fcst **;
	end;
	%*** Scenarios Covered by offered and not taken Logic: **;
	%*** Assume closed month is 12 for 2006 and we are fcsting 2007 **;
	%*** 1)  Offered and Taken at least one month out of the past 6:  All of 2007 is kept **;
	%*** 2)  Offered and NOT Taken looking at the past 6 months as a whole:  Any month that was offered and taken **;
	%***     in that same month in 2006 will be kept in 2007,  If a month was offered but not taken in that same **;
	%***     month in 2006, that month will not be kept in 2007.  If the month was not offered in that same month in **;
	%***	 2006, the month will be kept in 2007  **;
	%*** 3)  Not Offered at least one month out of the past 6:  Check each month in 2006 to see if it was offered in **;
	%***     that same month.  If that month was offered and not taken, then that month in 2007 will not be kept.  If **;
	%***     the month was not offered in that same month in 2006, the month will be kept in 2007. **;
   	%** determine if a forecast should be made based on offered and not taken promos **;
	%** offered but not taken in the past six months **;

	%let x = %eval(&newclose.-5);
	%let y = %eval(&newclose.+1);

	if sum( of promosOffered&x - promosOffered&newclose.) > 0 and
		sum( of actdol&x - actdol&newclose.) > 0 then do;
		%** if offered and taken in the past six, then dont do anything -- keep the fcst **;
	end;
	%** JLA 12/23/08 - added b/c new promos in 2009 that never existed in 2008 were getting zeroed out **;
	else if sum( of promosOffered&x - promosOffered&newclose.) = 0 and 
				sum( of promosOffered&y - promosOffered24) > 0 then do;
		%** brand new promotion, not offered in the last 6 months but is offered now **;
		%** this step will cause a warning when newclose = 12 b/c promosOffered25 doesnt exist **;
	end;
	else if sum( of vol&x - vol&newclose.) = 0 then do;
	    %** if offered in calendar but no strs / volume then do not zero out **;
	end;
	else do;  %** otherwise check each month in the prior year to see what should be kept **;
		%** determine which months to zero out - if the wbl had promo dollars in specific month in the prior  **;
		%** year, only keep the fcst for that month **;
		do i = 1 to 12; %** 1 - 12 = the prior year **;
			%** check the actual dollars thru the end of the year to ensure there arent any payments **;
			%** if there are payments, then dont zero out the forecast.  Could happen when you have a new product **;
			%** intro in June, the promo isnt used in June but the wslr starts using in July.  If the newclose var equals **;
			%** June but there are already payments or bn aap precalcs in July  then we would want to keep **;
			%** the forecast rather than zero it out  **;
			if sum ( of actdol&newclose. - actdol24) = 0 then do;
				zeroFcst{i} = 0;
			end;
			%** if the month in the prior yr was paid then keep the month in the fcst in the new year **;
			if actdol{i} > 0 and promosOffered{i} > 0 then zeroFcst{i} = 1; 
			%** 2/23/2012 TRE - if no promos were offered in the previous year and some are this year ;
			%** need to allow forecasting so override - applies to knew promos in jan ;
			if promosOffered{i} = 0 and promosOffered{i + 12} > 0 then zeroFcst{i} = 1;
		end;
	end;
	keep wslr bnd line zeroFcst1-zeroFcst12;
run; 

data build.nottaken_&year.;  %* write out to file;
  set nottaken;
run;



proc sort data = notTaken;
	by wslr bnd line;
proc sort data = forecastData;
	by wslr bnd line;

%** determine if a forecast should be made based on offered and not taken promos **;
data forecastData (bufno=64);
	merge forecastData (in=a) notTaken (in=b);
	by wslr bnd line;
	if a;

data forecastData;
	set forecastData;
	%** remove last years dollars, gpv, etc from the file **;
	drop actdol1-actdol12 actgpv1-actgpv12 promosOffered1-promosOffered12 promosPaid1-promosPaid12 
			maxdol1-maxdol12;

data forecastData;
	set forecastData;
	%** rename the 13-24 variables to be 1-12 **;
	rename actdol13-actdol24 = actdol1-actdol12;
	rename actgpv13-actgpv24 = actgpv1-actgpv12;
	rename maxdol13-maxdol24 = maxdol1-maxdol12;
	rename promosOffered13-promosOffered24 = promosOffered1-promosOffered12;
	rename promosPaid13-promosPaid24 = promosPaid1-promosPaid12;
run;

data forecastData;
	set forecastData;
	array zeroFcst{12} zeroFcst1-zeroFcst12;
	array rpv{12} rpv1-rpv12;
	array rate{12} rate1-rate12;
	array promosOffered{12} promosOffered1-promosOffered12;
	do i = 1 to 12;
	 	%** if the zeroFcst flag is missing, set it to 1 so that the fcst will be kept **;
		if zeroFcst{i} = . then zeroFcst{i} = 1;
		if promosOffered{i} = . then promosOffered{i} = 0;
		%** zeroFcst will be a 1 or 0 **;
		rpv{i} = rpv{i} * zeroFcst{i};
		rate{i} = rate{i} * zeroFcst{i};
		%** zero out the fcst if AB is not offering any promotions in a given month **;
		if promosOffered{i} = 0 then do;
			rpv{i} = 0; 
			rate{i} = 0;
		end;
	end;
	drop i;
run;



%*  Manually force rates and rpvs based on input file;
%macro forceraterpv;
  %if %upcase(&force_rate_rpv)=Y %then %do;

libname rangefl EXCEL &force_rate_file.
        VER=2007;

data raterpv_raw;
  set rangefl.raterpv;  * assumes defined range name raterpv, and that all values are correct;
run;

libname rangefl clear; * release spreadsheet;

data raterpv;
  set raterpv_raw;
  if wslr NOT in (.,99999);
run;

proc sort data=raterpv;
  by wslr bnd line;
run;

proc sort data=forecastData;
  by wslr bnd line;
run;

data forecastData;
  merge forecastData(in=a) raterpv(in=b);

  array rpv{12} rpv1-rpv12;
  array rate{12} rate1-rate12;
  array frpv{12} fixrpv1-fixrpv12;
  array frate{12} fixrate1-fixrate12;

  by wslr bnd line;
  if a;
  if b then do;
    do i=1 to 12;
      rpv{i} = frpv{i};
      rate{i} = frate{i};
    end;
  end;
  drop i fixrpv1-fixrpv12 fixrate1-fixrate12;
run;


  %end;
%mend forceraterpv;
%forceraterpv; run;




%** read in the Fcst year volume **;
data fcstVolume (bufno=64);
	set volumeHold;
	&fixlines;
	%macro makeSTR;
    %do i=1 %to 12;
        if &i gt &strmon  THEN vol&I  = &OTLSTR._&I ;
                            ELSE vol&I  = &CURSTR._&I ;
		IF VOL&I = . then VOL&I = 0;
    %end;
	%mend makeSTR; %makeSTR;
	keep wslr bnd line vol1-vol12;

%** make sure the volume is at the WBL M level **;
proc sort data = fcstVolume;
	by wslr bnd line;

proc summary data = fcstVolume;
	by wslr bnd line;
	var vol1-vol12;
	output out = fcstVolume (drop= _type_ _freq_) sum=;

proc sort data = forecastData;
	by wslr bnd line;

data fcstOutput (bufno=64);
	merge forecastData (in=a) fcstVolume (in=b);
	by wslr bnd line;
	if a;

data fcstOutput;
	set fcstOutput;
	keep wslr bnd line vol1-vol12 rpv1-rpv12 rate1-rate12 actdol1-actdol12 actgpv1-actgpv12 promosOffered1-promosOffered12
			promosPaid1-promosPaid12 days1-days12 maxdol1-maxdol12 wgtdRate1-wgtdRate12 discDol1-discDol12 
			discMax1-discMax12 aappaid1-aappaid12 aapgpv1-aapgpv12 maxDisc1-maxDisc12;
run;
	
proc sort data = packageInfo;
	by line;

proc sort data = fcstOutput;
	by line;

data fcstOutput;
	merge fcstOutput (in=a) packageInfo (in=b);
	by line;
	if a;
run;

%** add state code to the data **;
/*
proc sort data = tabledir.wslr (keep = wslr statcode) out=wslrInfo nodupkey;
	by wslr;
*/
proc sort data = wslrInfoTemp (keep = wslr statcode) out=wslrInfo nodupkey;
	by wslr;

proc sort data = fcstOutput;
	by wslr bnd line;

data fcstOutput;
	merge fcstOutput (in=a) wslrInfo (in=b);
	by wslr;
	if a;
run;

data fcstOutput;
	set fcstOutput;
	array gpv{12} gpv1-gpv12;
	array orig_gpv{12} orig_gpv1-orig_gpv12; %** used in FOBR gpv <= 102% of total STRs **;
	array rpv{12} rpv1-rpv12;
	array rate{12} rate1-rate12;
	array vol{12} vol1-vol12;
	array dol{12} dol1-dol12;
	array actdol{12} actdol1-actdol12;
	array actgpv{12} actgpv1-actgpv12;
	array promosPaid{12} promosPaid1-promosPaid12;
	array promosOffered{12} promosOffered1-promosOffered12;
	array maxdol{12} maxdol1-maxdol12;
	array wgtdRate{12} wgtdRate1-wgtdRate12; %** weighted max rates **;
	array maxDisc{12} maxDisc1-maxDisc12; %** weighted discount **;
	array discDol{12} discDol1-discDol12; %** discount dollars passed on to retail - excludes wslr exceeding ab **;
	array discMax{12} discMax1-discMax12; %** max discount dollars ab would have recognized **;
	array aappaid{12} aappaid1-aappaid12;
	array aapgpv{12} aapgpv1-aapgpv12;
	if becv = . then becv = .07258065;
	%** calculate the gpv and dollars **;
	do i = 1 to 12;
		if vol{i} = . then vol{i} = 0;
		gpv{i} = vol{i} * rpv{i};
		dol{i} = rate{i} * (gpv{i} / becv);
		%** if a month has had all of the promotions paid, then set the dol and gpv equal to the actuals **;
		if promosPaid{i} >= promosOffered{i} then do;
			dol{i} = actdol{i};
			gpv{i} = actgpv{i};
		end;
		%** if the actual dollars are greater than the forecasted dollars, keep the actual dollars and gpv **;
		if actdol{i} > dol{i} or actgpv{i} > gpv{i} then do;
			dol{i} = actdol{i};
			gpv{i} = actgpv{i};
		end;
		%** save a copy of the gpv for use in the fobr gpv <= 102% of total STRs **;
		orig_gpv{i} = gpv{i};
	end;
/*	%** Force the fcst GPV in FOBR states to be no more than 102% of the fcst months STRs **;
	if statcode in ('CT','ID','OH','KS','KY','WV','MI') and (&FOBRMON. < 13) then do;
		if (sum( of orig_gpv&FOBRMON. - orig_gpv12) > (1.02 * sum( of vol&FOBRMON. - vol12)) and sum( of orig_gpv&FOBRMON. - orig_gpv12)) > 0 then do;
			do i = &FOBRMON. to 12;
				if promosPaid{i} < promosOffered{i} then do;
					%** recalc the gpv as 102% of the strs, but keep the monthly spread the same **;
					gpv{i} = (orig_gpv{i} / sum( of orig_gpv&FOBRMON. - orig_gpv12)) * (1.02 * sum( of vol&FOBRMON. - vol12));
					dol{i} = rate{i} * (gpv{i} / becv);
				end;
				%** if the actual dollars are greater than the forecasted dollars, keep the actual dollars and gpv **;
				if actdol{i} > dol{i} or actgpv{i} > gpv{i} then do;
					dol{i} = actdol{i};
					gpv{i} = actgpv{i};
				end;
			end;
		end;
	end;
FOBRRPV */
	%** set the dol and gpv equal to actual thru the closed month **;
	if statcode in ('CT','ID','OH','KS','KY','WV','MI') then do;
		do i = 1 to &closfobr.;	
			dol{i} = actdol{i};
			gpv{i} = actgpv{i};
		end;
	end;
	else do;
		do i = 1 to &closemon.;	
			dol{i} = actdol{i};
			gpv{i} = actgpv{i};
		end;
	end;

	%** calculate the future and actual max dollars **;
	%** added 11-28-2007 JLA **;
	do i = 1 to 12;
		%** if month is closed or 100% paid then the maxdols used will be the ones calculated at the lowest level... **;
		%** at each promoid, take the gpv paid on that promo times the max rate for the promo **;
		%** month is open, and is NOT 100% paid calc a weighted avg maxdols **;
		if i > &closemon. and promosPaid{i} < promosOffered{i} and statcode not in ('CT','ID','OH','KS','KY','WV','MI') then do;
			maxdol{i} = round((gpv{i} / becv) * wgtdRate{i},0.0001); %** cacluate the max dollars **;
			%** if the pye dollars happen to be more than the max then reset the max dollars **;
			%** this typically happens when the month is highly paid **;
			if dol{i} > maxdol{i} then maxdol{i} = dol{i};
			%** assume 50/50 if max disc is missing **;
			if maxDisc{i} = 0 then maxDisc{i} = wgtdRate{i} * 2;
			split = wgtdRate{i} / maxDisc{i};
			discMax{i} = round(maxdol{i} / split,0.0001); %** cacluate the max discount dollars **;
			discDol{i} = round(dol{i} / split,0.0001); %** cacluate the effective discount dollars **;
		end;
		if i > &closfobr. and promosPaid{i} < promosOffered{i} and statcode in ('CT','ID','OH','KS','KY','WV','MI') then do;
			maxdol{i} = round((gpv{i} / becv) * wgtdRate{i},0.0001); %** cacluate the max dollars **;
			%** if the pye dollars happen to be more than the max then reset the max dollars **;
			%** this typically happens when the month is highly paid **;
			if dol{i} > maxdol{i} then maxdol{i} = dol{i};
			%** assume 50/50 if max disc is missing **;
			if maxDisc{i} = 0 then do;
				split = .5;
			end;
			else do;
				split = wgtdRate{i} / maxDisc{i};
			end;
			discMax{i} = round(maxdol{i} / split,0.0001); %** cacluate the max discount dollars **;
			discDol{i} = round(dol{i} / split,0.0001); %** cacluate the effective discount dollars **;
		end;
	end;
	%** ensure there are no missing values in the output **;
	do i = 1 to 12;
		if gpv{i} = . then gpv{i} = 0; if actgpv{i} = . then actgpv{i} = 0;
		if dol{i} = . then dol{i} = 0; if actdol{i} = . then actdol{i} = 0;
		if maxdol{i} = . then maxdol{i} = 0; if discMax{i} = . then discMax{i} = 0; if discDol{i} = . then discDol{i} = 0;
		if promosPaid{i} = . then promosPaid{i} = 0; if promosOffered{i} = . then promosOffered{i} = 0;
		if aappaid{i} = . then aappaid{i} = 0; if aapgpv{i} = . then aapgpv{i} = 0;
	end;
	%** dont keep records that do not have a fcst **;
	%** JLA 12/23/08 Also keep the records were AB offered a promo but the wslr did not use it **;
	%** causing invalid results when using a base fcst as a proxy for the next year when a promo was offered in the **;
	%** prior year but never taken **;
	if sum ( of gpv1-gpv12 dol1-dol12 aappaid1-aappaid12 aapgpv1-aapgpv12 promosOffered1-promosOffered12) ~= 0;
	keep wslr bnd line actdol1-actdol12 dol1-dol12 actgpv1-actgpv12 gpv1-gpv12 
			promosOffered1-promosOffered12 promosPaid1-promosPaid12 days1-days12 maxdol1-maxdol12 
			discDol1-discDol12 discMax1-discMax12 aappaid1-aappaid12 aapgpv1-aapgpv12;
run;

proc sort data = fcstOutput;
	by wslr bnd line;
run;

data fcstOutput;
	set fcstOutput;
	%** rename the vars to be the same as the existing special file **;
	rename dol1-dol12 = pyedol1-pyedol12;
	rename gpv1-gpv12 = pyegpv1-pyegpv12;
	alwtype = 'N';

DATA pye.&specbase;
	set fcstOutput;
	%*FcstType = 'B'; %** V = Vol % B = Plan B **;
run;	
/*
%** delete the datasets no longer needed **;
proc datasets library=work nolist;
	delete Bndlevelrateutil Combined Curractuals Curryearactuals Famlevelrateutil Forecastdata Maxratedollars Fcstvolume
			Maxratedollarsfam Nottaken Ohmull Prevyear Qdtiercnt Rateutil Rateweights Rateweightscheck Rpv Rpvtrend
			Specrpvproxiesused temp vol0; 
quit;
*/
