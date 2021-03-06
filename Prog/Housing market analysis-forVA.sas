/**************************************************************************
 Program:  Housing market analysis-forVA.sas
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

 Modifications: LH 08/19/2020 output structure type by jurisdiction for issue #112. 
				https://github.com/NeighborhoodInfoDC/RegHsg/issues
				Removed other output from Housing market analysis.sas
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
		1 = "No bedrooms"
		2 = "1 bedroom"
		3 = "2 bedrooms"
		4 = "3 bedrooms"
		5 = "4+ bedrooms"
		;

  value acost_rec
	  0 -< 800 = "$0 to $799"
	  800 -< 1300 = "$800 to $1,299"
	  1300 -< 1800 = "$1,300 to $1,799"
	  1800 -< 2500 = "$1,800 to $2,499"
	  2500 -< 3500 = "$2,500 to $3,499"
	  3500 - high = "$3,500 or more"
  ;
	
  value year_f 
    0 = '2000';

run;


/**************************************************************************
Part 1: Compile housing units by characteristics from Ipums.
**************************************************************************/

%macro COGunits(year);

title2 "-- &year --";

%local cost_year;

  %if &year = 2000 %then %let cost_year = %eval( &year - 1 );
	%else %let cost_year = &year;

/* Calculate data for occupied units for each year of Ipums */
data COGSarea_&year. (where=(pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
	%if &year. >= 2012 %then %do;
	set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va; 
		%newpuma_jurisdiction; 
	%end;
	%else %if &year. = 2010 %then %do;
	set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;
		%oldpuma_jurisdiction; 
	%end; 
	%else %if &year. = 2000 %then %do;
	set Ipums.Ipums_2000_dc Ipums.Ipums_2000_md Ipums.Ipums_2000_va;
		%oldpuma_jurisdiction; 
		ownershpd = ownershd;
	%end; 
	
	if jurisdiction in ( 1:10 );
	
	%Ipums_wt_adjust()

	if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
	else if UNITSSTR in (05,06, 07) then structuretype=3; /*small multifamily*/
	else if UNITSSTR in (08, 09, 10)then structuretype=4; /*large multifamily*/


	if ownershpd in (21, 22) then Tenure = 1; /*renter*/
	else if ownershpd in ( 12,13 ) then Tenure = 2; /*owner*/

	if bedrooms >= 5 then bedrooms = 5; /* Top-code bedroom sizes at 4+ */
	
	** Housing costs **;
	
	 *adjust housing costs for inflation; 
	 
	  %dollar_convert( rentgrs, rentgrs_a, &cost_year., 2016, series=CUUR0000SA0L2 )
	  %dollar_convert( valueh, valueh_a, &cost_year., 2016, series=CUUR0000SA0L2 )

    * For owner costs, use first-time homebuyer mortgage payment and other monthly costs *;
	  
	    **** 
	    Calculate monthly payment for first-time homebuyers. 
	    Using 3.69% as the effective mortgage rate for DC in 2016, 
	    calculate monthly P & I payment using monthly mortgage rate and compounded interest calculation
	    ******; 
	    
	    loan = .9 * valueh_a;
	    month_mortgage= (3.69 / 12) / 100; 
	    monthly_PI = loan * month_mortgage * ((1+month_mortgage)**360)/(((1+month_mortgage)**360)-1);

	    ****
	    Calculate PMI and taxes/insurance to add to Monthly_PI to find total monthly payment
	    ******;
	    
	    PMI = (.007 * loan ) / 12; **typical annual PMI is .007 of loan amount;
	    tax_ins = .25 * monthly_PI; **taxes assumed to be 25% of monthly PI; 
	    total_month = monthly_PI + PMI + tax_ins; **Sum of monthly payment components;

	  if Tenure = 1 then housing_cost_a = rentgrs_a;
	  else if Tenure = 2 then housing_cost_a = total_month;

	occupiedunits_&year.=1;

	format bedrooms bedroom_topcode. jurisdiction jurisdiction.;

  keep
    year serial hhwt pernum gq ownershpd 
    rent rentgrs rentgrs_a valueh valueh_a total_month housing_cost_a
    Jurisdiction structuretype bedrooms Tenure occupiedunits_&year.;

	run;

  title3 "Occupied units";
  proc means data=COGSarea_&year.;
    var rentgrs rentgrs_a valueh valueh_a total_month housing_cost_a;
  run;
  title3;


proc summary data= COGSarea_&year.;
	class Jurisdiction structuretype bedrooms Tenure;
	var occupiedunits_&year.;
	weight hhwt;
	output out=COGSareaunits_&year. (where = (_type_ in (0,1,2,4,8,9,5,12))) sum=;
run;

proc sort data= COGSareaunits_&year.;
	by Tenure Jurisdiction structuretype bedrooms _type_;
run;

 %**create ratio for rent to rentgrs to adjust rents on vacant units**;
	 data Ratio;

		  set COGSarea_&year.
		    (keep= rent rentgrs pernum gq ownershpd Jurisdiction
		     where=(pernum=1 and gq in (1,2) and ownershpd in ( 22 )));
		     
		  Ratio_rentgrs_rent_&year. = rentgrs / rent;
		 
		run;

		proc means data=Ratio;
		  var  Ratio_rentgrs_rent_&year. rentgrs rent;
      output out=Ratio_rentgrs_rent_&year. (drop=_type_ _freq_) mean(Ratio_rentgrs_rent_&year.)=;
		run;

/* Calculate data for vacant units for each year of Ipums */
data COGSvacant_&year.(where=(Tenure in (1,2)));

	%if &year. >= 2012 %then %do;
	set Ipums.Acs_&year._vacant_dc Ipums.Acs_&year._vacant_md Ipums.Acs_&year._vacant_va ;
		%newpuma_jurisdiction; 
	%end;
	%else %if &year. = 2010 %then %do;
	set Ipums.Acs_&year._vacant_dc Ipums.Acs_&year._vacant_md Ipums.Acs_&year._vacant_va ;
		%oldpuma_jurisdiction; 
	%end; 
	%else %if &year. = 2000 %then %do;
	set Ipums.Ipums_2000_vacant_dc Ipums.Ipums_2000_vacant_md Ipums.Ipums_2000_vacant_va ;
		%oldpuma_jurisdiction; 
	%end; 
	
	if jurisdiction in ( 1:10 );
	
	%Ipums_wt_adjust()

  if _n_ = 1 then set Ratio_rentgrs_rent_&year.;

	if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
	else if UNITSSTR =05 then structuretype=3; /*duplex now coded as small multifamily*/
	else if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
	else if UNITSSTR in (08, 09, 10)then structuretype=4; /*large multifamily*/

    *reassign vacant but rented or sold based on whether rent or value is available; 	
	if vacancy=1 then Tenure = 1; /*renter*/
	else if vacancy=2 then Tenure = 2; /*owner*/
  else if vacancy=3 and not( missing( rent ) ) then Tenure = 1; 
  else if vacancy=3 and not( missing( valueh ) ) then Tenure = 2; 

	if bedrooms >= 5 then bedrooms = 5; /* Top-code bedroom sizes at 4+ */
	
	** Housing costs **;
	    
    ****** Rental units ******;
	 if Tenure = 1 then do;
	    
	    	** Impute gross rent for vacant units **;
	  		rentgrs = rent * Ratio_rentgrs_rent_&year.;

	  %dollar_convert( rentgrs, rentgrs_a, &cost_year., 2016, series=CUUR0000SA0L2 )

    end;
			
	  else if Tenure = 2 then do;

	    ****** Owner units ******;
	    
	    **** 
	    Calculate  monthly payment for first-time homebuyers. 
	    Using 3.69% as the effective mortgage rate for DC in 2016, 
	    calculate monthly P & I payment using monthly mortgage rate and compounded interest calculation
	    ******; 
	  %dollar_convert( valueh, valueh_a, &cost_year., 2016, series=CUUR0000SA0L2 )
	    loan = .9 * valueh_a;
	    month_mortgage= (3.69 / 12) / 100; 
	    monthly_PI = loan * month_mortgage * ((1+month_mortgage)**360)/(((1+month_mortgage)**360)-1);

	    ****
	    Calculate PMI and taxes/insurance to add to Monthly_PI to find total monthly payment
	    ******;
	    
	    PMI = (.007 * loan ) / 12; **typical annual PMI is .007 of loan amount;
	    tax_ins = .25 * monthly_PI; **taxes assumed to be 25% of monthly PI; 
	    total_month = monthly_PI + PMI + tax_ins; **Sum of monthly payment components;
		
	  end;

	  if Tenure = 1 then housing_cost_a = rentgrs_a;
	  else if Tenure = 2 then housing_cost_a = total_month;

  vacantunit_&year.=1;

	format bedrooms bedroom_topcode. jurisdiction jurisdiction.;

  keep 
    year serial hhwt 
    rent rentgrs rentgrs_a valueh valueh_a total_month housing_cost_a
    Jurisdiction structuretype bedrooms Tenure vacantunit_&year.;

run;

  title3 "Vacant units";
  proc means data=COGSvacant_&year.;
    var rent rentgrs rentgrs_a valueh valueh_a total_month housing_cost_a;
  run;
  title3;

proc summary data= COGSvacant_&year.;
	class Jurisdiction structuretype bedrooms Tenure;
	var vacantunit_&year.;
	weight hhwt;
	output out= COGSvacantunits_&year. (where = (_type_ in (0,1,2,4,8,9,5,12))) sum=;
run;

proc sort data= COGSvacantunits_&year.;
	by Tenure Jurisdiction structuretype bedrooms _type_;
run;

title2;

%mend COGunits; 

%COGunits(2017);
%COGunits(2010);
%COGunits(2000);


/* Combine units and vacant units to calculate vacancy rate and export */
data COGSunits (drop = _freq_);
	merge COGSareaunits_2000 COGSvacantunits_2000 COGSareaunits_2010 COGSvacantunits_2010 COGSareaunits_2017 COGSvacantunits_2017;
	by Tenure Jurisdiction structuretype bedrooms _type_;

	vacancyrate2000= vacantunit_2000 / sum(of vacantunit_2000 occupiedunits_2000);
	vacancyrate2010= vacantunit_2010 / sum(of vacantunit_2010 occupiedunits_2010);
	vacancyrate2017= vacantunit_2017 / sum(of vacantunit_2017 occupiedunits_2017);

	format structuretype structure. Tenure tenure.;
	drop _type_;
run;

proc export data = COGSunits
   outfile="&_dcdata_default_path\RegHsg\Prog\Housing Characteristics_08192020.csv"
   dbms=csv
   replace;
run;

