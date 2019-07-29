/**************************************************************************
 Program:  Natural affordable rental stock.sas
 Library:  RegHsg
 Project:  Urban-Greater DC 
 Author:   Yipeng Su
 Created:  2/8/2019
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Estimate sort-of natural affordable for rental stock from 2013-17
 ACS IPUMS data for the COGS region:
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


1. for COG and jurisdicion: number of 4+ rental under 1200(rentgrs) that are less than 30, 30-60, more than 60 years old
2. for COG and jurisdicion: * number of 1-4 unit rental properties under $1200 month. less than 30, 30-60 years old and more than 60 years old and total.  

UNITSSTR: 1-4 units: 03,04, 05, 06  4+ units: 07, 08, 09, 10
BUILTYR: less than 30: 1-5 30-60: 6-8 60+: 9

 Modifications: 04-03-19 LH Added COG-adjustments to weights. Changes affordable break to $1300 to match "low" cost band
							Corrected inflation adjustment to less shelter series.
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RegHsg )
%DCData_lib( Ipums )

%let date=04032019; 


proc format;

  value hud_inc
   .n = 'Vacant'
    1 = '0-30% AMI'
    2 = '31-50%'
    3 = '51-80%'
    4 = '81-120%'
    5 = '120-200%'
    6 = 'More than 200%'
	;

  value tenure
    1 = 'Renter units'
    2 = 'Owner units'
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
  	;

  value rcost
	  1= "$0 to $749"
	  2= "$750 to $1,199"
	  3= "$1,200 to $1,499"
	  4= "$1,500 to $1,999"
	  5= "$2,000 to $2,499"
	  6= "More than $2,500"
  ;

  value ocost
	  1= "$0 to $1,199"
	  2= "$1,200 to $1,799"
	  3= "$1,800 to $2,499"
	  4= "$2,500 to $3,199"
	  5= "$3,200 to $4,199"
	  6= "More than $4,200"
  ;

  value acost
	  1= "$0 to $799"
	  2= "$800 to $1,299"
	  3= "$1,300 to $1,799"
	  4= "$1,800 to $2,499"
	  5= "$2,500 to $3,499"
	  6= "More than $3,500"
  ;
	
  value inc_cat

    1 = '0-30% AMI'
    2 = '31-50%'
    3 = '51-80%'
    4 = '81-120%'
	5 = '81-120%'
    6 = '120-200%'
    7 = 'More than 200%'
	8 = 'Vacant'
	;

  value struc
  . = 'other unit type'
  1= '1-4 units in structure'
  2= '4+ units in structure' ;

  value buildingyear

  1=  '0-30 years old'
  2= '30-60 years old'
  3= '60+ years old'
  ;

  value afford

  1= 'natural affordable (rent < $1,200)'
  0= 'not natural affordable';

run;

%macro single_year(year);

	** Calculate average ratio of gross rent to contract rent for occupied units **;
	data COGSvacant_&year.(where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
		set Ipums.Acs_&year._vacant_dc Ipums.Acs_&year._vacant_md Ipums.Acs_&year._vacant_va ;

	%assign_jurisdiction; 

	run;

	data COGSarea_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
		set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;

	%assign_jurisdiction; 

	run;


	 %**create ratio for rent to rentgrs to adjust rents on vacant units**;
	 data Ratio_&year.;

		  set COGSarea_&year.
		    (keep= rent rentgrs pernum gq ownershpd Jurisdiction
		     where=(pernum=1 and gq in (1,2) and ownershpd in ( 22 )));
		     
		  Ratio_rentgrs_rent_&year. = rentgrs / rent;
		 
		run;

		proc means data=Ratio_&year.;
		  var  Ratio_rentgrs_rent_&year. rentgrs rent;
		  output out=Ratio_&year (keep=Ratio_rentgrs_rent_&year.) mean=;
		run;

data Occupied_affordable_&year.;

  set COGSarea_&year.
        (keep=year serial pernum hhwt hhincome numprec bedrooms gq ownershp owncost ownershpd rentgrs valueh Jurisdiction BUILTYR2 UNITSSTR 
		 where=(pernum=1 and gq in (1,2) and ownershpd in (12,13,21,22 )));

  %dollar_convert( rentgrs,rentgrs_a, &year., 2016, series=CUUR0000SA0L2 )

	if rentgrs in ( 9999999, .n , . ) then affordable=.;
		else do; 
		    if rentgrs_a<1300 then affordable=1;
			else if rentgrs_a>=1300 then affordable=0;
			
		end;

	  label affordable = 'Natural affordable rental unit';

if BUILTYR2 in ( 00, 9999999, .n , . ) then structureyear=.;
		else do; 
		    if BUILTYR2  in (07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22) then structureyear=1;
			else if BUILTYR2  in (04, 05, 06) then structureyear=2;
            else if BUILTYR2 in (01, 02, 03)  then structureyear=3;
		end;

if UNITSSTR in ( 00, 01, 02, 9999999, .n , . ) then unitcount=.;
		else do; 
		    if UNITSSTR in (03, 04, 05, 06) then unitcount=1;
			else if UNITSSTR in (07, 08, 09, 10) then unitcount=2;
		end;

	total=1;


			label structureyear = 'Age of structure'
		 		  unitcount='Units in structure'
				;
	
format affordable afford. structureyear buildingyear.  unitcount struc. Jurisdiction Jurisdiction.; 
run;

data Vacant_affordable_&year.;

  set COGSvacant_&year.(keep=year serial hhwt bedrooms gq vacancy rent valueh Jurisdiction BUILTYR2 UNITSSTR where=(vacancy in (1, 3) & rent ~=.n));
  if _n_ = 1 then set Ratio_&year.;
  retain Totalvacant 1;
	
  ** Impute gross rent for vacant units **;
	  		rentgrs = rent*Ratio_rentgrs_rent_&year.;

			  %dollar_convert( rentgrs, rentgrs_a, &year., 2016, series=CUUR0000SA0L2 )
			

	if rent in ( 9999999, .n , . ) then affordable_vacant=.;
		else do; 
		    if rentgrs_a<1300 then affordable_vacant=1;
			else if rentgrs_a>=1300 then affordable_vacant=0;

		end;

	  label affordable_vacant = 'Natural affordable vacant rental unit';
	
if BUILTYR2 in ( 00, 9999999, .n , . ) then structureyear=.;
		else do; 
		    if BUILTYR2  in (07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22) then structureyear=1;
			else if BUILTYR2  in (04, 05, 06) then structureyear=2;
            else if BUILTYR2 in (01, 02, 03)  then structureyear=3;
		end;

if UNITSSTR in ( 00, 01, 02, 9999999, .n , . ) then unitcount=.;
		else do; 
		    if UNITSSTR in (03, 04, 05, 06) then unitcount=1;
			else if UNITSSTR in (07, 08, 09, 10) then unitcount=2;
		end;

			label structureyear = 'Age of structure'
		 		  unitcount='Units in structure'
				;

				total_vacant=1;

	format affordable_vacant afford. structureyear buildingyear.  unitcount struc. Jurisdiction Jurisdiction.; 
	run;

%mend single_year; 

%single_year(2013);
%single_year(2014);
%single_year(2015); 
%single_year(2016);
%single_year(2017);
/*merge single year data and reweight

revised to match Steven's files in https://urbanorg.app.box.com/file/402454379812 (after changing 2 HH = GQ=5 in 2013
 to non head of HH)
*/


data fiveyeartotal;
	set Occupied_affordable_2013 Occupied_affordable_2014 Occupied_affordable_2015 Occupied_affordable_2016 Occupied_affordable_2017;

hhwt_5=hhwt*.2; 

run; 

proc sort data=fiveyeartotal;
by jurisdiction;
proc summary data=fiveyeartotal;
by jurisdiction;
var hhwt_5;
output out=region_sum sum=ACS_13_17;
run; 
data calculate_calibration;
 set region_sum;

/*L:\Libraries\Region\Raw\Final_Round_9.1_Summary_Tables_101018.xlsx*/
COG_2015=.;
if jurisdiction=1 then COG_2015=297112; *DC;
else if jurisdiction=2 then COG_2015=53659; *charles; 
else if jurisdiction=3 then COG_2015=89462; *frederick; 
else if jurisdiction=4 then COG_2015=374850; *montgomery;
else if jurisdiction=5 then COG_2015=321143; *prince georges;
else if jurisdiction=6 then COG_2015=103761; *arlington; 
else if jurisdiction=7 then COG_2015=418360; *fairfax, fairfax city, fallschurch; 
else if jurisdiction=8 then COG_2015=121106; *loudoun; 
else if jurisdiction=9 then COG_2015=161073; *pw, manassas, manassas park; 
else if jurisdiction=10 then COG_2015=71191; *alexandria;

calibration=(COG_2015/ACS_13_17);
run;


data fiveyeartotal_c;
merge fiveyeartotal calculate_calibration;
by jurisdiction;

hhwt_COG=.; 

hhwt_COG=hhwt_5*calibration; 

label hhwt_COG="Household Weight Calibrated to COG Estimates for Households"
	  calibration="Ratio of COG 2015 estimate to ACS 2013-17 for Jurisdiction";

run; 

proc tabulate data=fiveyeartotal_c format=comma12. noseps missing;
  class jurisdiction;
  var hhwt_5 hhwt_cog;
  table
    all='Total' jurisdiction=' ',
    sum='Sum of HHWTs' * ( hhwt_5='Original 5-year' hhwt_cog='Adjusted to COG totals' )
  / box='Occupied housing units';
  format jurisdiction jurisdiction.;
run;

/*need data just for rental*/ 
data fiveyeartotal_renters;
	set fiveyeartotal_c (where =(ownershpd in (21,22 )));

run;
data fiveyeartotal_vacant;
	set Vacant_affordable_2013 Vacant_affordable_2014 Vacant_affordable_2015 Vacant_affordable_2016 Vacant_affordable_2017;

hhwt_5=hhwt*.2; 

run; 
proc sort data=fiveyeartotal_vacant;
by jurisdiction;
data fiveyeartotal_vacant_c;
merge fiveyeartotal_vacant  calculate_calibration;
by jurisdiction;

hhwt_COG=.; 

hhwt_COG=hhwt_5*calibration; 

label hhwt_COG="Household Weight Calibrated to COG Estimates for Households"
	  calibration="Ratio of COG 2015 estimate to ACS 2013-17 for Jurisdiction";

run; 

proc tabulate data=fiveyeartotal_vacant_c format=comma12. noseps missing;
  class jurisdiction;
  var hhwt_5 hhwt_cog;
  table
    all='Total' jurisdiction=' ',
    sum='Sum of HHWTs' * ( hhwt_5='Original 5-year' hhwt_cog='Adjusted to COG totals' )
  / box='Vacant (nonseasonal) housing units';
  format jurisdiction jurisdiction.;
run;


/*produce tables on naturally affordable*/

proc sort data=fiveyeartotal_renters;
by Jurisdiction structureyear unitcount;run;

proc summary data=fiveyeartotal_renters ;
by Jurisdiction structureyear unitcount;
var affordable total ;
weight hhwt_cog;
output out = region_occupied_afford  (drop=_TYPE_ _FREQ_) sum= affordable_occ total_occ;
run;

proc sort data=fiveyeartotal_vacant_c;
by Jurisdiction structureyear unitcount;run;

proc summary data=fiveyeartotal_vacant_c;
by Jurisdiction structureyear unitcount;
var affordable_vacant total_vacant;
weight hhwt_cog;
output out = region_vacant_afford (drop=_TYPE_ _FREQ_) sum=;
run;

data naturalaffordablestock ;
merge region_occupied_afford  region_vacant_afford;
by Jurisdiction structureyear unitcount;
format affordable_vacant affordable_occ;
if affordable_vacant=. then affordable_vacant=0;
if total_vacant=. then total_vacant=0;
totalaffordable= affordable_vacant+ affordable_occ;
Totalunits= total_occ+total_vacant;
pctafford= totalaffordable/Totalunits;
run;

proc export data=naturalaffordablestock
 	outfile="&_dcdata_default_path\RegHsg\Prog\natural_affordable_stock_Jur_&date..csv"
   dbms=csv
   replace;
   run;

/*for COG region*/
   
proc sort data=fiveyeartotal_renters;
by structureyear unitcount;run;

proc summary data=fiveyeartotal_renters;
by structureyear unitcount;
var affordable total ;
weight hhwt_cog;
output out = region_occupied_afford_COG  (drop=_TYPE_ _FREQ_) sum=affordable_occ total_occ ;
run;

proc sort data=fiveyeartotal_vacant_c;
by structureyear unitcount;run;

proc summary data=fiveyeartotal_vacant_c ;
by structureyear unitcount;
var affordable_vacant total_vacant;
weight hhwt_cog;
output out = region_vacant_afford_COG (drop=_TYPE_ _FREQ_) sum=;
run;

data naturalaffordablestock_COG ;
merge region_occupied_afford_COG  region_vacant_afford_COG;
by structureyear unitcount;
format affordable_vacant affordable_occ;
totalaffordable= affordable_vacant+ affordable_occ;
Totalunits= total_occ+total_vacant;
pctafford= totalaffordable/Totalunits;
run;

proc export data=naturalaffordablestock_COG
 	outfile="&_dcdata_default_path\RegHsg\Prog\natural_affordable_stock_COG_&date..csv"
   dbms=csv
   replace;
   run;

