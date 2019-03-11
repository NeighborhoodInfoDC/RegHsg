/**************************************************************************
 Program:  Housing market analysis.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su 
 Created:  2/22/19
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Produce numbers for housing market 2000-2017 for the COG region:
 DC (11001)
 Charles Couty(24017)
 Frederick County(24021)
 Montgomery County (24031)
 Prince George's County(24033)
 Arlington County (51013)
 Fairfax County (51059)
 Loudoun County (51107)
 Prince William County (51153)
 Alexandria City (51510)
 Fairfax City (51600)
 Falls Church City (51610)
 Manassas City (51683)
 Manassas Park City (51685)

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RegHsg)
%DCData_lib( Ipums)
%DCData_lib( Census);

/* List of Pumas for 2017 data */
%let pumanew = "1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302", "2401001", "2401002", 
			   "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", 
			   "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", 
			   "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255"  ;

/* List of Pumas for 2010 and 2000 data */
%let pumaold = "1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400300", "2401001", "2401002", "2401003",
			   "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106",
			   "2401107", "5100101", "5100100", "5100301", "5100302", "5100303", "5100304", "5100305", "5100600", "5100501",
			   "5100502", "5100200" ;

/* County codes for region */
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

/* Program specific formats */
proc format;

	value tenure
		1= "Renter"
		2= "Owner"
		;

	value Jurisdiction
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
		11="Total"
		;

	value structure
		1= "Single family"
		2= "Duplex"
		3= "Small multifamily"
		4= "Large multifamily"
		.n= "Other"
		 ;

	value bedroom_topcode
		1 = "1 bedroom"
		2 = "2 bedrooms"
		3 = "3 bedrooms"
		4 = "4+ bedrooms"
		;
run;


/**************************************************************************
Part 1: Compile housing units by characteristics from Ipums.
**************************************************************************/

%macro COGunits(year);

/* Calculate vacant untis for each year of Ipums */
data COGSvacant_&year.(where=(vacancy in (1,2)));

	%if &year. = 2017 %then %do;
	set Ipums.Acs_&year._vacant_dc Ipums.Acs_&year._vacant_md Ipums.Acs_&year._vacant_va ;
		%newpuma_jurisdiction; 
		if upuma in (&pumanew.);
	%end;
	%else %if &year. = 2010 %then %do;
	set Ipums.Acs_&year._vacant_dc Ipums.Acs_&year._vacant_md Ipums.Acs_&year._vacant_va ;
		%oldpuma_jurisdiction; 
		if upuma in (&pumaold.);
	%end; 
	%else %if &year. = 2000 %then %do;
	set Ipums.Ipums_2000_vacant_dc Ipums.Ipums_2000_vacant_md Ipums.Ipums_2000_vacant_va ;
		%oldpuma_jurisdiction; 
		if upuma in (&pumaold.);
	%end; 

	if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
	else if UNITSSTR =05 then structuretype=3; /*duplex now coded as small multifamily*/
	else if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
	else if UNITSSTR in (08, 09, 10)then structuretype=4; /*large multifamily*/

	if vacancy=1 then Tenure = 1; /*renter*/
	if vacancy=2 then Tenure = 2; /*owner*/

	if bedrooms >= 4 then bedrooms = 4; /* Top-code bedroom sizes at 4+ */

	vacantunit_&year.=1;

	format bedrooms bedroom_topcode. jurisdiction jurisdiction.;

run;

proc summary data= COGSvacant_&year.;
	class Jurisdiction structuretype bedrooms Tenure;
	var vacantunit_&year.;
	*ways 0 1;
	weight hhwt;
	output out= COGSvacantunits_&year. (where = (_type_ in (0,1,2,4,8,9,5))) sum=;
run;

proc sort data= COGSvacantunits_&year.;
	by Jurisdiction structuretype bedrooms Tenure _type_;
run;

/* Calculate total number of units for each year of Ipums */
data COGSarea_&year. (where=(pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
	%if &year. = 2017 %then %do;
	set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va; 
		%newpuma_jurisdiction; 
		if upuma in (&pumanew.);
	%end;
	%else %if &year. = 2010 %then %do;
	set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;
		%oldpuma_jurisdiction; 
		if upuma in (&pumaold.);
	%end; 
	%else %if &year. = 2000 %then %do;
	set Ipums.Ipums_2000_dc Ipums.Ipums_2000_md Ipums.Ipums_2000_va;
		%oldpuma_jurisdiction; 
		ownershpd = ownershd;
		if upuma in (&pumaold.);
	%end; 

	if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
	else if UNITSSTR in (05,06, 07) then structuretype=3; /*small multifamily*/
	else if UNITSSTR in (08, 09, 10)then structuretype=4; /*large multifamily*/


	if ownershpd in (21, 22) then Tenure = 1; /*renter*/
	else if ownershpd in ( 12,13 ) then Tenure = 2; /*owner*/

	if bedrooms >= 4 then bedrooms = 4; /* Top-code bedroom sizes at 4+ */

	occupiedunits_&year.=1;

	format bedrooms bedroom_topcode. jurisdiction jurisdiction.;

	run;


proc summary data= COGSarea_&year.;
	class Jurisdiction structuretype bedrooms Tenure;
	var occupiedunits_&year.;
	*ways 0 1;
	weight hhwt;
	output out=COGSareaunits_&year. (where = (_type_ in (0,1,2,4,8,9,5))) sum=;
run;

proc sort data= COGSareaunits_&year.;
	by Jurisdiction structuretype bedrooms Tenure _type_;
run;

%mend COGunits; 

%COGunits(2017);
%COGunits(2010);
%COGunits(2000);


/* Combine units and vacant units to calculate vacancy rate and export */
data COGSunits (drop = _freq_);
	merge COGSareaunits_2000 COGSvacantunits_2000 COGSareaunits_2010 COGSvacantunits_2010 COGSareaunits_2017 COGSvacantunits_2017;
	by Jurisdiction structuretype bedrooms Tenure _type_;

	vacancyrate2000= vacantunit_2000 / sum(of vacantunit_2000 occupiedunits_2000);
	vacancyrate2010= vacantunit_2010 / sum(of vacantunit_2010 occupiedunits_2010);
	vacancyrate2017= vacantunit_2017 / sum(of vacantunit_2017 occupiedunits_2017);

	format structuretype structure. Tenure tenure.;
	drop _type_;
run;

proc export data = COGSunits
   outfile="&_dcdata_default_path\RegHsg\Prog\Housing Characteristics.csv"
   dbms=csv
   replace;
run;


/**************************************************************************
Part 2: Compile housing cost burden information from IPums.
**************************************************************************/
	
/* Calculate cost burden for each year of Ipums */
%macro renterburden(year);
data rentercostburden_&year. (where=(pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));

	%if &year. = 2017 %then %do;
	set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va; 
		%newpuma_jurisdiction; 
		if upuma in (&pumanew.);
	%end;
	%else %if &year. = 2010 %then %do;
	set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;
		%oldpuma_jurisdiction; 
		if upuma in (&pumaold.);
	%end; 
	%else %if &year. = 2000 %then %do;
	merge Ipums_2000_dmwv (in=a) ipums_2000_suppl (in=b);
	by serial;
	if a and b;

		%oldpuma_jurisdiction; 
		ownershpd = ownershd;
		if upuma in (&pumaold.);
	%end; 

	if gq in (1,2);
	if pernum = 1;

    if ownershpd in (21, 22) then do; /*renter*/
		if rentgrs*12>= HHINCOME*0.3 then rentburdened_&year.=1;
	    else if HHIncome~=. then rentburdened_&year.=0;
		totrenter_&year. = 1;
	end;

    if ownershpd in ( 12,13 ) then do; /*owner*/
		if owncost*12>= HHINCOME*0.3 then ownerburdened_&year.=1;
	    else if HHIncome~=. then ownerburdened_&year.=0;
		totowner_&year. = 1;
	end;

	tothh_&year. = 1;

	%let LOUDOUN_RENT_WTADJ = (104583/145906);
	if Jurisdiction=8 then do;
		rentburdened_2010= rentburdened_2010*&LOUDOUN_RENT_WTADJ.;
		totowner_2010= totowner_2010*&LOUDOUN_RENT_WTADJ.;
		totrenter_2010= totrenter_2010*&LOUDOUN_RENT_WTADJ.;
		ownerburdened_2010= ownerburdened_2010*&LOUDOUN_RENT_WTADJ.;
	end;

run;

proc sort data=rentercostburden_&year.;
	by Jurisdiction;
run;

proc summary data = rentercostburden_&year. (where=(ownershpd in (21, 22)));
	class Jurisdiction;
	var rentburdened_&year. totrenter_&year.;
	weight hhwt;
	output out = rentburdened_&year. sum=;
run;

proc summary data = rentercostburden_&year.  (where=(ownershpd in (12, 13)));
	class Jurisdiction;
	var ownerburdened_&year. totowner_&year.;
	weight hhwt;
	output out = ownerburdened_&year.  sum=;
run;

%mend renterburden; 

%renterburden(2017);
%renterburden(2010);

/* Combine housing cost into a single file and export */
data allhousingburden;
	merge rentburdened_2010 ownerburdened_2010 rentburdened_2017 ownerburdened_2017 ;
	by Jurisdiction;
	format Jurisdiction Jurisdiction.;

	if _TYPE_=0 then Jurisdiction=11;
	format Jurisdiction Jurisdiction.;

	drop _type_ _freq_;
run;

proc export data = allhousingburden
   outfile="&_dcdata_default_path\RegHsg\Prog\Housing Cost Burden.csv"
   dbms=csv
   replace;
run;


/**************************************************************************
Part 3: Compile permit data from Census permits data.
**************************************************************************/

/* Read in Census permits data */
data permits (where= (ucounty in(&RHFregion.)));
	set Census.Cen_building_permits_dc_md_va_wv;
	keep year ucounty units1_building units2_building units34_building units5p_building Jurisdiction;

	%ucounty_jurisdiction;
	format Jurisdiction Jurisdiction. ;
run;

proc sort data=permits;
	by year Jurisdiction;
run;

/* Summarize permits by year and jurisdiction */
proc summary data=permits;
	class year Jurisdiction ;
	var units1_building units2_building units34_building units5p_building;
	output out= permits_allyear(drop= _FREQ_) sum=;
run;

data permits2;
	set permits_allyear (where=(_TYPE_ in (2,3)));
	if _TYPE_=2 then Jurisdiction=11;
	format Jurisdiction Jurisdiction.;
run;

proc sort data=permits2;
	by Jurisdiction year;
run;

/*Transpose permits for final output */
proc transpose data=permits2 out=permits_allyear_t ;
	by Jurisdiction;
	var units1_building units2_building units34_building units5p_building ;
	id year;
run;

proc export data = permits_allyear_t
   outfile="&_dcdata_default_path\RegHsg\Prog\Building Permits.csv"
   dbms=csv
   replace;
run;


/**************************************************************************
Part 4: Compile housing market information from Zillow data.
**************************************************************************/

/* Read in Zillow csv */
proc import datafile = 'L:\Libraries\RegHsg\Data\Housing-market-Zillow-data.csv'
	out = work.zillow
	dbms = CSV 
	replace;
run;

proc sort data=zillow;
	by year;
run;

/* Inflation adjust Zillow then transpose for final output */
data inflatadjustzillow;
	set zillow;

	%dollar_convert( Mediansaleprice, Mediansaleprice_a, year, 2016, series=CUUR0000SA0 )
	%dollar_convert( MedianSFRent, MedianSFRent_a, year, 2016, series=CUUR0000SA0 )
	%dollar_convert( MedianMFRent, MedianMFRent_a, year, 2016, series=CUUR0000SA0 )
	%dollar_convert( MedianCondoRent, MedianCondoRent_a, year, 2016, series=CUUR0000SA0 )
	%dollar_convert( MedianDuplexRent, MedianDuplexRent_a, year, 2016, series=CUUR0000SA0 )
run;

proc transpose data=inflatadjustzillow out=inflatadjustzillow_trans ;
	var Mediansaleprice_a MedianSFRent_a MedianMFRent_a MedianCondoRent_a MedianDuplexRent_a inventoryMetro;
	id year;
run;

/* Add row labels */
data inflatadjustzillow_labels;
	length label $50.;
	retain label _2008 _2009 _2010 _2011 _2012 _2013 _2014 _2015 _2016 _2017 _2018;
	set inflatadjustzillow_trans;

	if _NAME_ = "Mediansaleprice_a" then label = "Median sales price, 2016-dollars" ;
	if _NAME_ = "MedianSFRent_a" then label = "Median single-family monthly rent, 2016-dollars" ;
	if _NAME_ = "MedianMFRent_a" then label = "Median multi-family monthly rent, 2016-dollars" ;
	if _NAME_ = "MedianCondoRent_a" then label = "Median condo monthly rent, 2016-dollars" ;
	if _NAME_ = "MedianDuplexRent_a" then label = "Median duplex monthly rent, 2016-dollars" ;
	if _NAME_ = "inventoryMetro" then label = "Number of monthly home listings" ;

	label label = "Variable label"
		  _2008 = "2008"
		  _2009 = "2009"
		  _2010 = "2010"
		  _2011 = "2011"
		  _2012 = "2012"
		  _2013 = "2013"
		  _2014 = "2014"
		  _2015 = "2015"
		  _2016 = "2016"
		  _2017 = "2017"
		  _2018 = "2018"
		  ;

	drop _name_;

run;

proc export data = inflatadjustzillow_labels
	outfile="&_dcdata_default_path\RegHsg\Prog\Zillow Inventory and Price.csv"
	dbms=csv
	replace;
run;


/* End of program */
