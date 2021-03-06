/**************************************************************************
 Program:  Employment Trends.sas
 Library:  RegHsg
 Project:  Urban-Greater DC
 Author:   Rob Pitingolo
 Created:  2/25/19
 Version:  SAS 9.4
 Environment:  Local Windows session
 
 Description:  Calculate employment trends for the Washington MSA. 

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( BLS )
%DCData_lib( RegHsg )

/* Update parameters for data updates */
%let start_yr = 1990;
%let end_yr = 2017;

/* List of MSAs for comparison */
%let msalist = 	"C1206", 	/* Atlanta-Sandy Springs-Roswell */
				"C1446",	/* Boston-Cambridge-Nashua */
				"C1698",	/* Chicago-Naperville-Elgin */
				"C1910",	/* Dallas-Fort Worth-Arlington */
				"C1982",	/* Detroit-Warren-Dearborn */
				"C2642",	/* Houston-The Woodlands-Sugar Land */
				"C3110",	/* Los Angeles-Long Beach-Anaheim */
				"C3310",	/* Miami-Fort Lauderdale-West Palm Beach */
				"C3346",	/* Minneapolis-St. Paul-Bloomington */
				"C3562",	/* New York-Newark-Jersey City */
				"C3798",	/* Philadelphia-Camden-Wilmington */
				"C3806",	/* Phoenix-Mesa-Scottsdale */
				"C4186",	/* San Francisco-Oakland-Hayward */
				"C4266",	/* Seattle-Tacoma-Bellevue */
				"C4790" 	/* Washington-Arlington-Alexandria */
				;

%let RHFregion = "11001", /* Washington DC */
					"24017", /* Charles */
					"24021", /* Frederick */
					"24031", /* Montgomery */
					"24033", /* Prince George's */
					"51013", /* Arlington */
					"51059", /* Fairfax */
					"51107", /* Loudoun */
					"51153", /* Prince William */
					"51510", /* Alexandria */
					"51600", /* Fairfax City */
					"51610", /* Falls Church City */
					"51683", /* Manassas */
					"51685"  /* Manassas Park */
					;

proc format;
	value icode
		1 = "Construction"
		2 = "Other goods-producing"
		3 = "Professional and business services"
		4 = "Education and health services"
		5 = "Trade, transport, and utilities"
		6 = "Leisure and hospitality"
		7 = "Financial"
		8 = "Information services"
		9 = "Other services";
quit;

/* Macro to tanspose by year */
%macro byyear (var);
	if year = "&yr." then &var._&yr. = &var.;
%mend byyear;


/* Jobs for Washington MSA (not RHF-defined region) compared to other large MSAs, 1990 - 2017 */
data msajobs;
	set bls.bls_allgeos_country;

	/* LA MSA code changed in 2013 */
	if year in ("2013","2014","2015","2016","2017") then do;
		if Area_Code = "C3108" then Area = "Los Angeles-Long Beach-Santa Ana, CA MSA";
		if Area_Code = "C3108" then Area_Code = "C3110";
	end;

	if area_type = "MSA";
	if Area_Code in (&msalist.); *MSAs from list above ;
	if own = 0; * Total covered jobs *;

	%macro yearloop;
	%do yr = &start_yr. %to &end_yr.;
		%byyear (Annual_Average_Employment);
	%end;
	%mend yearloop;
	%yearloop;

run;

proc summary data = msajobs;
	class Area;
	var Annual_Average_Employment_: ;
	output out = msajobs_t sum=;
run;

data msajobs_byyear;
	set msajobs_t;
	drop _type_ _freq_;
	if area = " " then delete;
run;

proc export data = msajobs_byyear
	outfile = "&_dcdata_default_path.\reghsg\prog\msajobs_byyear.csv"
	dbms=csv
	replace;
run;



/* Jobs by private, federal gov't, local/state gov't, 1990 - 2017 */
proc format;
	value ownc
		0 = "Total Covered"
		1 = "Federal Government"
		2 = "State and Local Government"
		5 = "Private";
quit;

data sectorjobs;
	set bls.bls_county_was15;

	if ucounty in (&RHFregion.); *RHF Defined Region ;
	if naics = "10"; *Total, all industries ;

	%macro yearloop;
	%do yr = &start_yr. %to &end_yr.;
		%byyear (Annual_Average_Employment);
	%end;
	%mend yearloop;
	%yearloop;

	if own in (2,3) then own2 = 2;
		else own2 = own;

	format own2 ownc.;

run;

proc summary data = sectorjobs;
	class own2;
	var Annual_Average_Employment_: ;
	output out = sectorjobs_t sum=;
run;

data sectorjobs_byyear;
	set sectorjobs_t;
	drop _type_ _freq_;
	if own2 = " " then delete;
run;

proc export data = sectorjobs_byyear
	outfile = "&_dcdata_default_path.\reghsg\prog\sectorjobs_byyear.csv"
	dbms=csv
	replace;
run;


/* Private sector jobs by industry, 1990 - 2017 */
data industryjobs;
	set bls.bls_county_was15;

	if ucounty in (&RHFregion.); *RHF Defined Region ;
	if own = "5"; *Private ;

	%macro yearloop;
	%do yr = &start_yr. %to &end_yr.;
		%byyear (Annual_Average_Employment);
	%end;
	%mend yearloop;
	%yearloop;

	if naics = "1012" then icode = 1;
	else if naics in ("1011","1013") then icode = 2;
	else if naics in ("1024") then icode = 3;
	else if naics in ("1025") then icode = 4;
	else if naics in ("1021") then icode = 5;
	else if naics in ("1026") then icode = 6;
	else if naics in ("1023") then icode = 7;
	else if naics in ("1022") then icode = 8;
	else if naics in ("1027") then icode = 9; 
	else if naics in ("1029") then icode = 9; 

	format icode icode.;


run;

proc summary data = industryjobs;
	class naics;
	var Annual_Average_Employment_: ;
	output out = industryjobs_t sum=;
run;

data industryjobs_byyear;
	set industryjobs_t;
	drop _type_ _freq_;
	if naics = " " then delete;
run;

proc export data = industryjobs_byyear
	outfile = "&_dcdata_default_path.\reghsg\prog\industryjobs_byyear.csv"
	dbms=csv
	replace;
run;


/* Calculate the residual for "other" */
%let goodscodes = "1011","1012","1013";
%let servicecodes = "1021","1022","1023","1024","1025","1026","1027","1029";

proc summary data = Industryjobs_byyear (where = (naics in (&servicecodes.)));
	var Annual_Average_Employment_:;
	output out = services sum=;
run;

data service_net;
	set Industryjobs_byyear (where = (naics = "102"))
		services;

	%macro yearloop;
	%do yr = &start_yr. %to &end_yr.;
		lag_N_&yr. = lag1(Annual_Average_Employment_&yr.);
		Other_&yr. = lag_N_&yr. - Annual_Average_Employment_&yr. ;
		Annual_Average_Employment_&yr. = Other_&yr.;
	%end;
	%mend yearloop;
	%yearloop;

	if naics = " " then icode = 9;
	if icode ^= .;

	keep icode Annual_Average_Employment_:;

run;

proc summary data = Industryjobs_byyear (where = (naics in (&goodscodes.)));
	var Annual_Average_Employment_:;
	output out = goods sum=;
run;

data goods_net;
	set Industryjobs_byyear (where = (naics = "101"))
		goods;

	%macro yearloop;
	%do yr = &start_yr. %to &end_yr.;
		lag_N_&yr. = lag1(Annual_Average_Employment_&yr.);
		Other_&yr. = lag_N_&yr. - Annual_Average_Employment_&yr. ;
		Annual_Average_Employment_&yr. = Other_&yr.;
	%end;
	%mend yearloop;
	%yearloop;

	if naics = " " then icode = 2;
	if icode ^= .;

	keep icode Annual_Average_Employment_:;

run;

data industryjobs_net;
	set industryjobs service_net goods_net;
run;

proc summary data = industryjobs_net;
	class icode;
	var Annual_Average_Employment_: ;
	output out = industryjobs2_t sum=;
run;

data industryjobs2_byyear;
	set industryjobs2_t;
	drop _type_ _freq_;
	if icode = " " then delete;
run;

proc export data = industryjobs2_byyear
	outfile = "&_dcdata_default_path.\reghsg\prog\industryjobs2_byyear.csv"
	dbms=csv
	replace;
run;


/* End of program */
