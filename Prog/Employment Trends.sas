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


/* Macro to tanspose by year */
%macro byyear (var);
	if year = "&yr." then &var._&yr. = &var.;
%mend byyear;


/* Jobs for Washington MSA (not RHF-defined region) compared to other large MSAs, 1990 - 2017 */
data msajobs;
	set bls.bls_allgeos_country;

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
	class area;
	var Annual_Average_Employment_: ;
	output out = msajobs_t sum=;
run;

data msajobs_byyear;
	set msajobs_t;
	drop _type_ _freq_;
	if area = " " then area = "Total";
run;


/* Jobs by private, federal gov't, local/state gov't, 1990 - 2017 */
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

run;

proc summary data = sectorjobs;
	class own;
	var Annual_Average_Employment_: ;
	output out = sectorjobs_t sum=;
run;

data sectorjobs_byyear;
	set sectorjobs_t;
	drop _type_ _freq_;
	if own = " " then delete;
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




/* End of program */
