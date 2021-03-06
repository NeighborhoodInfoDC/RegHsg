/**************************************************************************
 Program:  Ipums Employment Trends.sas
 Library:  RegHsg
 Project:  Urban-Greater DC
 Author:   Rob Pitingolo
 Created:  2/26/19
 Version:  SAS 9.4
 Environment:  Local Windows session
 
 Description:  Calculate employment trends from iPums data. 

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ipums )
%DCData_lib( RegHsg )

%let RegPumas = "1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", 
				"2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", 
				"2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", 
				"5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255" ;

%let Reg2000Pumas = "1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400300", "2401001", "2401002", "2401003",
					"2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106",
					"2401107", "5100101", "5100100", "5100301", "5100302", "5100303", "5100304", "5100305", "5100600", "5100501",
					"5100502", "5100200" ;


proc format;
	value wagecat
		1 = "Low wage"
		2 = "Middle wage"
		3 = "High wage"
		. = "Total";
	value empstat_new
		1 = "Civilian employed (at work or have a job)"
		2 = "In military (at work or have a job)"
		3 = "Student"
		4 = "Unemployed"
		5 = "Other / not in labor force"
		. = "Total";
	value Jurisdiction
		0= "Total"
   	 	1= "DC"
		2= "Charles County"
		3= "Frederick County "
		4="Montgomery County"
		5="Prince Georges "
		6="Arlington"
		7="Fairfax, Fairfax city and Falls Church"
		8="Loudoun"
		9="Prince William, Manassas and Manassas Park"
    	10="Alexandria"
		. ="All jurisdictinos";
run;

%macro ipumsyear(year);

title2 "-- &year --";

/* Load Ipums for region, flag full-time year-round workers */
data RegEmp_&year.;

	%if &year. = 2017 %then %do;
	set ipums.Acs_&year._dc ipums.Acs_&year._md ipums.Acs_&year._va ipums.Acs_&year._wv;
	if upuma in (&RegPumas.);
	%newpuma_jurisdiction;
	%end;
	%else %if &year. = 2010 %then %do;
	set ipums.Acs_&year._dc ipums.Acs_&year._md ipums.Acs_&year._va ipums.Acs_&year._wv;
	if upuma in (&Reg2000Pumas.);
	%oldpuma_jurisdiction;
	%end; 
	%else %if &year. = 2000 %then %do;
	set ipums.ipums_&year._dc ipums.ipums_&year._md ipums.ipums_&year._va ipums.ipums_&year._wv;
	if upuma in (&Reg2000Pumas.);
	%oldpuma_jurisdiction;
	%end; 

      %Ipums_wt_adjust()

	/* Flag 35+ hours worked as full time */
	if uhrswork >= 35 then fulltime=1;

	/* Flag 50-52 weeks per year as year-round */
	if wkswork2 = 6  then yearround=1;

	/* Recode breakdown of adults */
	if age >= 18 then do;
		if gradeatt ^= 0 then empstat_new = 3;
		else if empstatd in (10,12) then empstat_new = 1;
		else if empstatd in (14) then empstat_new = 2;
		else if empstatd in (20) then empstat_new = 4;
		else if empstatd in (0,30) then empstat_new = 5;
	end;

run;

proc freq data = RegEmp_&year.; tables empstatd ; run;


/* Caclulate median salary for full-time year-round workers */
proc means data = RegEmp_&year. (where = (fulltime=1 and yearround=1)) noprint;
	var incwage;
	weight perwt;
	output out = medianwage_&year. median=;
run;


/* Put median salary into macro variable */
proc sql;
	select incwage
	into :mediansalary separated by " "
	from medianwage_&year.;
quit;


/* Add median salary to data */
data RegWage_&year.;
	set RegEmp_&year.;

	if fulltime = 1 and yearround = 1 then do;
		ftworker = 1;
    medianwage = &mediansalary.;

	end;


	keep year serial pernum incwage medianwage jurisdiction fulltime yearround ftworker empstatd empstat_new trantime perwt hhwt;

	format empstat_new empstat_new. jurisdiction jurisdiction.;

run;

title2;

%mend ipumsyear;
%ipumsyear (2017);
%ipumsyear (2010);
%ipumsyear (2000);


/* Stack years, create colums for year data */
data allyears;
	set RegWage_2017 RegWage_2010 RegWage_2000;

  if ftworker then do;
    if incwage > ((4/3) * medianwage) then wagecat = 3;  /** High wage **/
		else if incwage < ((2/3) * medianwage) then wagecat = 1;  /** Low wage **/
		else wagecat = 2;  /** Middle wage **/
  end;

	if year = 0 then do;
		empstatd_2000 = empstat_new;
		ftworker_2000 = ftworker;
		worker_2000 = 1;
    %dollar_convert( incwage, incwage_d2018, 1999, 2018 ) 
    wagecat_2000 = wagecat;
		if empstat_new in (1,2) then trantime_2000 = trantime;
	end;

	else if year = 2010 then do;
		empstatd_2010 = empstat_new;
		ftworker_2010 = ftworker;
		worker_2010 = 1;
    %dollar_convert( incwage, incwage_d2018, 2010, 2018 )
    wagecat_2010 = wagecat;
		if empstat_new in (1,2) then trantime_2010 = trantime;
	end;

	else if year = 2017 then do;
		empstatd_2017 = empstat_new;
		ftworker_2017 = ftworker;
		worker_2017 = 1;
    %dollar_convert( incwage, incwage_d2018, 2017, 2018 )
    wagecat_2017 = wagecat;
		if empstat_new in (1,2) then trantime_2017 = trantime;
	end;

	format wagecat wagecat.;

run;

proc format;
  value year_f 
    0 = '2000';
run;

proc tabulate data=allyears format=comma10.0 noseps missing;
  where ftworker;
  class year wagecat;
  var ftworker incwage incwage_d2018;
  weight perwt;
  table 
    /** Pages **/
    year=' ',
    /** Rows **/
    all='Total' wagecat=' ',
    /** Columns **/
    ftworker='Workers' * sum=' '
    incwage='Annual earnings (nominal)' * ( mean min max )
    incwage_d2018='Annual earnings ($ 2018)' * ( mean min max )
    / condense;
  format year year_f.;
run;



/* Adults by employment status by year */
proc summary data = allyears;
	class empstat_new;
	var worker_: wagecat_:;
	output out = workers_byyear (drop=_type_ _freq_) sum=;
	weight perwt; 
run;

proc export data = workers_byyear
	outfile = "&_dcdata_default_path.\reghsg\prog\workers_byyear.csv"
	dbms=csv
	replace;
run;


/* Civilian full-time, year-round employed workers by wage (low, middle, high) by year */
proc summary data = allyears;
	class wagecat;
	var ftworker_:;
	output out = wage_byyear (drop=_type_ _freq_) sum=;
	weight perwt; 
run;

proc export data = wage_byyear
	outfile = "&_dcdata_default_path.\reghsg\prog\wage_byyear.csv"
	dbms=csv
	replace;
run;


/* Workers average commuting time by jurisdiction */
proc summary data = allyears;
	class jurisdiction;
	var trantime_:;
	output out = trantime_t mean=;
	weight perwt;
run;

data trantime_byyear;
	set trantime_t;
	drop _type_ _freq_;
run;

proc export data = trantime_byyear
	outfile = "&_dcdata_default_path.\reghsg\prog\trantime_byyear.csv"
	dbms=csv
	replace;
run;



/* End of program */
