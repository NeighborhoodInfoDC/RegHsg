/**************************************************************************
 Program:  Demographic trends.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng
 Created:  2/15/19
 Version:  SAS 9.4
 Environment:  Windows with SAS/Connect
 
 Description:  Use NCDB and ACS data to compile demographic change data for RHF project

COGS region:
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
%DCData_lib( NCDB )
%DCData_lib( ACS )
%DCData_lib( RegHsg )
%DCData_lib( Census );
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
 value racenew
   .n = 'Not available'
    1 = 'White non-Hispanic'
    2 = 'Black non-Hispanic'
    3 = "Hispanic "
	4 = "All other non-Hispanic ";
  value agegroup
     .n = 'Not available'
    1= "0-5 years old"
	2= "5-9 years old"
	3= "10-14 years old "
	4="15-19 years old"
	5="20-24 years old "
	6="25-29 years old"
	7="30-34 years old"
	8="35-39 years old"
	9="40-44 years old"
    10="45-49 years old"
    11= "50-54 years old"
    12= "55-59 years old"
    13= "60-64 years old"
    14= "65-69 years old"
    15= "70-74 years old"
    16= "75-79 years old" 
    17 = "80-84 years old"
    18= "85+ years old";

  value hispan
     .n = 'Not available'
    0 = 'Not Hispanic'
    1 = 'Hispanic';

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
	
  /*format collapses 80-100% and 100-120% of AMI*/
  value inc_cat

    1 = '$32,600 and below'
    2 = '$32,600-$54,300'
    3 = '$54,300-$70,150'
    4 = '$70,150-$130,320'
	5 = '$70,150-$130,320'
    6 = '$130,320-$217,200'
    7 = 'More than $217,200'
	8 = 'Vacant'
	;
  	  
run;

** Define libraries **;


/* Path to raw data csv files and names */

%let filepath = L:\Libraries\Census\Raw\Census population estimates\;
%let infile = co-est2017-alldata.csv;

/* Revisions */
%let revisions = New file;

filename fimport "&filepath.&infile." lrecl=32767;

data Cen_population_estimates ;

	infile FIMPORT delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;

	informat state best32. ;
	informat county best32.;
	informat POPESTIMATE2017 best32.;
	informat POPESTIMATE2016 best32.;
	informat POPESTIMATE2015 best32.;
	informat POPESTIMATE2014 best32.;
	informat POPESTIMATE2013 best32.;
	informat POPESTIMATE2012 best32.;
	informat POPESTIMATE2011 best32.;
	informat POPESTIMATE2010 best32.;
	informat CENSUS2010POP  best32.;
	informat BIRTHS2010  best32.;
	informat BIRTHS2011  best32.;
	informat BIRTHS2012  best32.;
	informat BIRTHS2013  best32.;
	informat BIRTHS2014  best32.;
	informat BIRTHS2015  best32.;
	informat BIRTHS2016  best32.;
	informat BIRTHS2017  best32.;
	informat DEATHS2010  best32.;
	informat DEATHS2011  best32.;
	informat DEATHS2012  best32.;
	informat DEATHS2013  best32.;
	informat DEATHS2014  best32.;
	informat DEATHS2015  best32.;
	informat DEATHS2016  best32.;
	informat DEATHS2017  best32.;
	informat NATURALINCS2010  best32.;
	informat NATURALINCS2011  best32.;
	informat NATURALINCS2012  best32.;
	informat NATURALINCS2013  best32.;
	informat NATURALINCS2014  best32.;
	informat NATURALINCS2015  best32.;
	informat NATURALINCS2016  best32.;
	informat NATURALINCS2017  best32.;
	informat INTERNATIONALMIGS2010  best32.;
	informat INTERNATIONALMIGS2011  best32.;
	informat INTERNATIONALMIGS2012  best32.;
	informat INTERNATIONALMIGS2013  best32.;
	informat INTERNATIONALMIGS2014  best32.;
	informat INTERNATIONALMIGS2015  best32.;
	informat INTERNATIONALMIGS2016  best32.;
	informat INTERNATIONALMIGS2017  best32.;
	informat DOMESTICMIGS2010  best32.;
	informat DOMESTICMIGS2011  best32.;
	informat DOMESTICMIGS2012  best32.;
	informat DOMESTICMIGS2013  best32.;
	informat DOMESTICMIGS2014  best32.;
	informat DOMESTICMIGS2015  best32.;
	informat DOMESTICMIGS2016  best32.;
	informat DOMESTICMIGS2017  best32.;

	input 	

	state
	county
	POPESTIMATE2017 
	POPESTIMATE2016 
	POPESTIMATE2015 
	POPESTIMATE2014 
	POPESTIMATE2013 
	POPESTIMATE2012 
    POPESTIMATE2011 
	POPESTIMATE2010 
    CENSUS2010POP
    BIRTHS2017 
	BIRTHS2016 
	BIRTHS2015 
	BIRTHS2014 
	BIRTHS2013 
	BIRTHS2012 
    BIRTHS2011 
	BIRTHS2010 
	DEATHS2017 
	DEATHS2016 
	DEATHS2015 
	DEATHS2014 
	DEATHS2013 
	DEATHS2012 
    DEATHS2011 
	DEATHS2010 
	NATURALINCS2017 
	NATURALINCS2016 
	NATURALINCS2015 
	NATURALINCS2014 
	NATURALINCS2013 
	NATURALINCS2012 
    NATURALINCS2011 
	NATURALINCS2010 
	INTERNATIONALMIGSS2017 
	INTERNATIONALMIGSS2016 
	INTERNATIONALMIGSS2015 
	INTERNATIONALMIGSS2014 
	INTERNATIONALMIGSS2013 
	INTERNATIONALMIGSS2012 
    INTERNATIONALMIGSS2011 
	INTERNATIONALMIGSS2010 
	DOMESTICMIGSS2017 
	DOMESTICMIGSS2016 
	DOMESTICMIGSS2015 
	DOMESTICMIGSS2014 
	DOMESTICMIGSS2013 
	DOMESTICMIGSS2012 
    DOMESTICMIGSS2011 
	DOMESTICMIGSS2010 


	;

	ucounty = put(county,z5.);
	state = put(state,z2.);

	drop county state ;

    if county in ("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685");


run;



data population (where= (ucounty in("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685" )));
set NCDB.Ncdb_master_update;
keep ucounty Jurisdiction trctpop7 trctpop8 trctpop9 trctpop0 trctpop1 numhhs7 numhhs8 numhhs9 numhhs0 numhhs1;

  if ucounty in ("11001") then Jurisdiction =1;
  if ucounty  in ("24017") then Jurisdiction =2;
  if ucounty  in ("24021") then Jurisdiction =3;
  if ucounty  in ("24031") then Jurisdiction =4;
  if ucounty  in ("24033") then Jurisdiction =5;
  if ucounty  in ("51013") then Jurisdiction =6;
  if ucounty  in ("51059", "51600", "51610") then Jurisdiction =7;
  if ucounty  in ("51107") then Jurisdiction =8;
  if ucounty  in ("51153", "51683", "51685") then Jurisdiction =9; 
  if ucounty  in ("51510") then Jurisdiction =10; 

run;

proc sort data=population;
by ucounty;
run;

data pop17;
set Cen_population_estimates (where= (ucounty in("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685" )));
keep ucounty Jurisdiction POPESTIMATE2017;
  if ucounty in ("11001") then Jurisdiction =1;
  if ucounty  in ("24017") then Jurisdiction =2;
  if ucounty  in ("24021") then Jurisdiction =3;
  if ucounty  in ("24031") then Jurisdiction =4;
  if ucounty  in ("24033") then Jurisdiction =5;
  if ucounty  in ("51013") then Jurisdiction =6;
  if ucounty  in ("51059", "51600", "51610") then Jurisdiction =7;
  if ucounty  in ("51107") then Jurisdiction =8;
  if ucounty  in ("51153", "51683", "51685") then Jurisdiction =9; 
  if ucounty  in ("51510") then Jurisdiction =10; 
run;

proc sort data=hh17;
by county;
run;

data populationtrend;
merge population hh17;
by ucounty;
format Jurisdiction Jurisdiction. ;
run;

proc sort data = populationtrend;
by Jurisdiction;
run;

proc summary data= populationtrend;
	class Jurisdiction;
	var trctpop7 trctpop8 trctpop9 trctpop0 trctpop1 POPESTIMATE2017;
	output out= populationbyjur sum=;
run;

data COGSvacant_2017(where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255") and pernum=1 and gq in (1,2) and ownershpd in ( 21,22 ));

set Ipums.Acs_2017_vacant_dc Ipums.Acs_2017_vacant_md Ipums.Acs_2017_vacant_va ;
%assign_jurisdiction; 
totalvacant=1;

run;

data COGSarea_2017 (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
		set Ipums.Acs_2017_dc Ipums.Acs_2017_md Ipums.Acs_2017_va;
	%assign_jurisdiction; 
totalunits=1;
	run;

proc data vacancyrate;
merge COGSvacant_2017 COGSarea_2017;
by upuma;
run;

proc summary data=vacancyrate;
class Jurisdiction;
var totalunits totalvacant;
output out= vacancy2017 sum=;
run;




%macro popbyrace(year);
data persons_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002","2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107","5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305","5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244","5151245", "5151246", "5151255")))  ;
set Ipums_&year._dc Ipums_&year._va Ipums_&year._md;
keep race hispan age pernum gq Jurisdiction hhwt perwt year serial numprec race1 age0 totpop_&year. CITIZEN;

  if upuma in ("1100101", "1100102", "1100103", "1100104", "1100105") then Jurisdiction =1;
  if upuma in ("2401600") then Jurisdiction =2;
  if upuma in ("2400301", "2400302") then Jurisdiction =3;
  if upuma in ("2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007") then Jurisdiction =4;
  if upuma in ("2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107") then Jurisdiction =5;
  if upuma in ("5101301", "5101302") then Jurisdiction =6;
  if upuma in ("5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309") then Jurisdiction =7;
  if upuma in ("5110701", "5110702" , "5110703") then Jurisdiction =8;
  if upuma in ("5151244", "5151245", "5151246") then Jurisdiction =9; 
  if upuma in ("5151255") then Jurisdiction =10; 

if hispan=0 then do;

 if race=1 then race1=1;
 else if race=2 then race1=2;
 else race1=4;
end;

if hispan in(1 2 3 4) then race1=3;

if 0<=age<5 then age0=1;
else if 5<=age<10 then age0=2;
else if 10<=age<15 then age0=3;
else if 15<=age<20 then age0=4;
else if 20<=age<25 then age0=5;
else if 25<=age<30 then age0=6;
else if 30<=age<35 then age0=7;
else if 35<=age<40 then age0=8;
else if 40<=age<45 then age0=9;
else if 45<=age<50 then age0=10;
else if 50<=age<55 then age0=11;
else if 55<=age<60 then age0=12;
else if 60<=age<65 then age0=13;
else if 65<=age<70 then age0=14;
else if 70<=age<75 then age0=15;
else if 75<=age<80 then age0=16;
else if 80<=age<85 then age0=17;
else if age>=85 then age0=18;

totpop_&year. = 1;
run;

proc freq data=Race_&year.;
  tables race1 * age0  / list missing;
run;

proc summary data = persons_&year. ;
	class Jurisdiction age0 race1 citizen;
	var totpop_&year.;
	weight perwt;
	output out = agegroup_race_immigration_&year.  sum=;
	format race1 racenew. age0 agegroup. Jurisdiction Jurisdiction.;
run;

proc sort data=agegroup_race_immigration_&year.;
by Jurisdiction age0 race1 citizen;
run;

%mend popbyrace;

%popbyrace(2010);
%popbyrace(2017);






/* Combine all data into a single file */

data table_city_stack;
	set table1980_city table1990_city table2000_city Table2006_10_city Table2012_16_city Table_ch_city 
		Table2006_10_rent_city Table2012_16_rent_city table2006_10_fam_city table2012_16_fam_city;
	SortNo + 1;
run;

data table_ward2012_stack;
	set table1980_ward2012 table1990_ward2012 table2000_ward2012 Table2006_10_ward2012 Table2012_16_ward2012 Table_ch_ward2012 
		Table2006_10_rent_ward2012 Table2012_16_rent_ward2012 table2006_10_fam_ward2012 table2012_16_fam_ward2012;
	SortNo + 1;
run;

proc sort data = table_city_stack; by SortNo; run;
proc sort data = table_ward2012_stack; by SortNo; run;

data table_all_final;
	merge table_city_stack table_ward2012_stack;
	by SortNo;
	drop SortNo;
run;


/* Export final file */

proc export data = table_all_final
   outfile="&_dcdata_default_path.\DMPED\Prog\table1a_raw.csv"
   dbms=csv
   replace;
run;



/* End of program */
