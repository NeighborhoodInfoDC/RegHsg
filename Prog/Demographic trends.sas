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
%DCData_lib( Census )
%DCData_lib( Ipums );
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

informat SUMLEV best32.;
informat REGION best32.;
informat DIVISION best32.;
informat STATE $2.;
informat COUNTY $3.;
informat STNAME $30.;
informat CTYNAME $30.;
informat CENSUS2010POP best32.;
informat ESTIMATESBASE2010 best32.;
informat POPESTIMATE2010 best32.;
informat POPESTIMATE2011 best32.;
informat POPESTIMATE2012 best32.;
informat POPESTIMATE2013 best32.;
informat POPESTIMATE2014 best32.;
informat POPESTIMATE2015 best32.;
informat POPESTIMATE2016 best32.;
informat POPESTIMATE2017 best32.;
informat NPOPCHG_2010 best32.;
informat NPOPCHG_2011 best32.;
informat NPOPCHG_2012 best32.;
informat NPOPCHG_2013 best32.;
informat NPOPCHG_2014 best32.;
informat NPOPCHG_2015 best32.;
informat NPOPCHG_2016 best32.;
informat NPOPCHG_2017 best32.;
informat BIRTHS2010 best32.;
informat BIRTHS2011 best32.;
informat BIRTHS2012 best32.;
informat BIRTHS2013 best32.;
informat BIRTHS2014 best32.;
informat BIRTHS2015 best32.;
informat BIRTHS2016 best32.;
informat BIRTHS2017 best32.;
informat DEATHS2010 best32.;
informat DEATHS2011 best32.;
informat DEATHS2012 best32.;
informat DEATHS2013 best32.;
informat DEATHS2014 best32.;
informat DEATHS2015 best32.;
informat DEATHS2016 best32.;
informat DEATHS2017 best32.;
informat NATURALINC2010 best32.;
informat NATURALINC2011 best32.;
informat NATURALINC2012 best32.;
informat NATURALINC2013 best32.;
informat NATURALINC2014 best32.;
informat NATURALINC2015 best32.;
informat NATURALINC2016 best32.;
informat NATURALINC2017 best32.;
informat INTERNATIONALMIG2010 best32.;
informat INTERNATIONALMIG2011 best32.;
informat INTERNATIONALMIG2012 best32.;
informat INTERNATIONALMIG2013 best32.;
informat INTERNATIONALMIG2014 best32.;
informat INTERNATIONALMIG2015 best32.;
informat INTERNATIONALMIG2016 best32.;
informat INTERNATIONALMIG2017 best32.;
informat DOMESTICMIG2010 best32.;
informat DOMESTICMIG2011 best32.;
informat DOMESTICMIG2012 best32.;
informat DOMESTICMIG2013 best32.;
informat DOMESTICMIG2014 best32.;
informat DOMESTICMIG2015 best32.;
informat DOMESTICMIG2016 best32.;
informat DOMESTICMIG2017 best32.;
informat NETMIG2010 best32.;
informat NETMIG2011 best32.;
informat NETMIG2012 best32.;
informat NETMIG2013 best32.;
informat NETMIG2014 best32.;
informat NETMIG2015 best32.;
informat NETMIG2016 best32.;
informat NETMIG2017 best32.;
informat RESIDUAL2010 best32.;
informat RESIDUAL2011 best32.;
informat RESIDUAL2012 best32.;
informat RESIDUAL2013 best32.;
informat RESIDUAL2014 best32.;
informat RESIDUAL2015 best32.;
informat RESIDUAL2016 best32.;
informat RESIDUAL2017 best32.;
informat GQESTIMATESBASE2010 best32.;
informat GQESTIMATES2010 best32.;
informat GQESTIMATES2011 best32.;
informat GQESTIMATES2012 best32.;
informat GQESTIMATES2013 best32.;
informat GQESTIMATES2014 best32.;
informat GQESTIMATES2015 best32.;
informat GQESTIMATES2016 best32.;
informat GQESTIMATES2017 best32.;
informat RBIRTH2011 best32.;
informat RBIRTH2012 best32.;
informat RBIRTH2013 best32.;
informat RBIRTH2014 best32.;
informat RBIRTH2015 best32.;
informat RBIRTH2016 best32.;
informat RBIRTH2017 best32.;
informat RDEATH2011 best32.;
informat RDEATH2012 best32.;
informat RDEATH2013 best32.;
informat RDEATH2014 best32.;
informat RDEATH2015 best32.;
informat RDEATH2016 best32.;
informat RDEATH2017 best32.;
informat RNATURALINC2011 best32.;
informat RNATURALINC2012 best32.;
informat RNATURALINC2013 best32.;
informat RNATURALINC2014 best32.;
informat RNATURALINC2015 best32.;
informat RNATURALINC2016 best32.;
informat RNATURALINC2017 best32.;
informat RINTERNATIONALMIG2011 best32.;
informat RINTERNATIONALMIG2012 best32.;
informat RINTERNATIONALMIG2013 best32.;
informat RINTERNATIONALMIG2014 best32.;
informat RINTERNATIONALMIG2015 best32.;
informat RINTERNATIONALMIG2016 best32.;
informat RINTERNATIONALMIG2017 best32.;
informat RDOMESTICMIG2011 best32.;
informat RDOMESTICMIG2012 best32.;
informat RDOMESTICMIG2013 best32.;
informat RDOMESTICMIG2014 best32.;
informat RDOMESTICMIG2015 best32.;
informat RDOMESTICMIG2016 best32.;
informat RDOMESTICMIG2017 best32.;
informat RNETMIG2011 best32.;
informat RNETMIG2012 best32.;
informat RNETMIG2013 best32.;
informat RNETMIG2014 best32.;
informat RNETMIG2015 best32.;
informat RNETMIG2016 best32.;
informat RNETMIG2017 best32.;


	input 	

		SUMLEV
		REGION
		DIVISION
		STATE
		COUNTY
		STNAME
		CTYNAME
		CENSUS2010POP
		ESTIMATESBASE2010
		POPESTIMATE2010
		POPESTIMATE2011
		POPESTIMATE2012
		POPESTIMATE2013
		POPESTIMATE2014
		POPESTIMATE2015
		POPESTIMATE2016
		POPESTIMATE2017
		NPOPCHG_2010
		NPOPCHG_2011
		NPOPCHG_2012
		NPOPCHG_2013
		NPOPCHG_2014
		NPOPCHG_2015
		NPOPCHG_2016
		NPOPCHG_2017
		BIRTHS2010
		BIRTHS2011
		BIRTHS2012
		BIRTHS2013
		BIRTHS2014
		BIRTHS2015
		BIRTHS2016
		BIRTHS2017
		DEATHS2010
		DEATHS2011
		DEATHS2012
		DEATHS2013
		DEATHS2014
		DEATHS2015
		DEATHS2016
		DEATHS2017
		NATURALINC2010
		NATURALINC2011
		NATURALINC2012
		NATURALINC2013
		NATURALINC2014
		NATURALINC2015
		NATURALINC2016
		NATURALINC2017
		INTERNATIONALMIG2010
		INTERNATIONALMIG2011
		INTERNATIONALMIG2012
		INTERNATIONALMIG2013
		INTERNATIONALMIG2014
		INTERNATIONALMIG2015
		INTERNATIONALMIG2016
		INTERNATIONALMIG2017
		DOMESTICMIG2010
		DOMESTICMIG2011
		DOMESTICMIG2012
		DOMESTICMIG2013
		DOMESTICMIG2014
		DOMESTICMIG2015
		DOMESTICMIG2016
		DOMESTICMIG2017
		NETMIG2010
		NETMIG2011
		NETMIG2012
		NETMIG2013
		NETMIG2014
		NETMIG2015
		NETMIG2016
		NETMIG2017
		RESIDUAL2010
		RESIDUAL2011
		RESIDUAL2012
		RESIDUAL2013
		RESIDUAL2014
		RESIDUAL2015
		RESIDUAL2016
		RESIDUAL2017
		GQESTIMATESBASE2010
		GQESTIMATES2010
		GQESTIMATES2011
		GQESTIMATES2012
		GQESTIMATES2013
		GQESTIMATES2014
		GQESTIMATES2015
		GQESTIMATES2016
		GQESTIMATES2017
		RBIRTH2011
		RBIRTH2012
		RBIRTH2013
		RBIRTH2014
		RBIRTH2015
		RBIRTH2016
		RBIRTH2017
		RDEATH2011
		RDEATH2012
		RDEATH2013
		RDEATH2014
		RDEATH2015
		RDEATH2016
		RDEATH2017
		RNATURALINC2011
		RNATURALINC2012
		RNATURALINC2013
		RNATURALINC2014
		RNATURALINC2015
		RNATURALINC2016
		RNATURALINC2017
		RINTERNATIONALMIG2011
		RINTERNATIONALMIG2012
		RINTERNATIONALMIG2013
		RINTERNATIONALMIG2014
		RINTERNATIONALMIG2015
		RINTERNATIONALMIG2016
		RINTERNATIONALMIG2017
		RDOMESTICMIG2011
		RDOMESTICMIG2012
		RDOMESTICMIG2013
		RDOMESTICMIG2014
		RDOMESTICMIG2015
		RDOMESTICMIG2016
		RDOMESTICMIG2017
		RNETMIG2011
		RNETMIG2012
		RNETMIG2013
		RNETMIG2014
		RNETMIG2015
		RNETMIG2016
		RNETMIG2017

	;

	county2 = put(COUNTY,z3.);
	state2 = put(STATE,z2.);
	ucounty=  state2|| county2;

	drop SUMLEV REGION DIVISION STNAME CTYNAME;

	 if ucounty in ("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685");
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
proc summary data=population;
by ucounty;
var trctpop7 trctpop8 trctpop9 trctpop0 trctpop1 numhhs7 numhhs8 numhhs9 numhhs0 numhhs1;
output out= NCDBpopulation sum=;
run;

proc sort data=NCDBpopulation;
by ucounty;
run;

data pop17;
set Cen_population_estimates;
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

proc sort data=pop17;
by ucounty;
run;

data populationtrend;
merge NCDBpopulation pop17;
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

proc export data = populationbyjur
   outfile="&_dcdata_default_path\RegHsg\Prog\populationbyjur.csv"
   dbms=csv
   replace;
run;


/*component of population change*/
data changecomponent;
set Cen_population_estimates;
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
keep ucounty Jurisdiction RNATURALINC: RINTERNATIONALMIG: RDOMESTICMIG: RNETMIG:;
run;

%macro popbyrace(year);
data persons_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002","2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107","5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305","5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244","5151245", "5151246", "5151255")))  ;
set Ipums.ACS_&year._dc Ipums.ACS_&year._va Ipums.ACS_&year._md;
keep upuma race hispan age pernum gq Jurisdiction hhwt perwt year serial numprec race1 age0 totpop_&year. foreignborn;

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

if citizen = 3 then foreignborn=1;
if citizen in (0 1 2) then foreignborn=2;

totpop_&year. = 1;
run;

proc summary data = persons_&year. ;
	class Jurisdiction age0 race1 foreignborn;
	var totpop_&year.;
	weight perwt;
	output out = agegroup_race_immigration_&year.(where=(_TYPE_=15))  sum=;
	format race1 racenew. age0 agegroup. Jurisdiction Jurisdiction. ;
run;

proc sort data=agegroup_race_immigration_&year.(drop= _FREQ_ _TYPE_);
by Jurisdiction age0 race1 foreignborn;
run;

%mend popbyrace;

%popbyrace(2010);
%popbyrace(2017);

data persons_2000(where=(upuma in ("1100101",
"1100102",
"1100103",
"1100104",
"1100105",
"2401600",
"2400300",
"2401001",
"2401002",
"2401003",
"2401004",
"2401005",
"2401006",
"2401007",
"2401101",
"2401102",
"2401103",
"2401104",
"2401105",
"2401106",
"2401107",
"5100101",
"5100100",
"5100301",
"5100302",
"5100303",
"5100304",
"5100305",
"5100600",
"5100501",
"5100502",
"5100200"
)));
set ipums.Ipums_2000_dc ipums.Ipums_2000_md ipums.Ipums_2000_va ;
keep upuma racgen00 hispand age pernum gq Jurisdiction hhwt perwt year serial numprec race1 age0 totpop_00 foreignborn;

  if upuma in ("1100101", "1100102", "1100103", "1100104", "1100105") then Jurisdiction =1;
  if upuma in ("2401600") then Jurisdiction =2;
  if upuma in ("2400300") then Jurisdiction =3;
  if upuma in ("2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007") then Jurisdiction =4;
  if upuma in ("2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107") then Jurisdiction =5;
  if upuma in ("5101301", "5101302") then Jurisdiction =6;
  if upuma in ("5100301", "5100302", "5100303", "5100304", "5100305", "5100303", "5100301") then Jurisdiction =7;
  if upuma in ("5100600") then Jurisdiction =8;
  if upuma in ("5100501", "5100502", "5100501") then Jurisdiction =9; 
  if upuma in ("5100100", "5100200") then Jurisdiction =10; 

if hispand=0 then do;

 if racgen00=1 then race1=1;
 else if racgen00=2 then race1=2;
 else race1=4;
end;

else race1=3;

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

if citizen = 3 then foreignborn=1;
if citizen in (0 1 2) then foreignborn=2;

totpop_00 = 1;
run;

proc summary data = persons_2000 ;
	class Jurisdiction age0 race1 foreignborn;
	var totpop_00;
	weight perwt;
	output out = agegroup_race_immigration_00(where=(_TYPE_=15))  sum=;
	format race1 racenew. age0 agegroup. Jurisdiction Jurisdiction. ;
run;

proc sort data=agegroup_race_immigration_00 (drop= _FREQ_ _TYPE_);
by Jurisdiction age0 race1 foreignborn;
run;

data popbreakdown;
merge agegroup_race_immigration_00 agegroup_race_immigration_2010 agegroup_race_immigration_2017;
by Jurisdiction age0 race1 foreignborn;
run;

proc export data = popbreakdown
   outfile="&_dcdata_default_path\RegHsg\Prog\popbreakdown.csv"
   dbms=csv
   replace;
run;

/*household number*/

data households (where= (ucounty in("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685" )));
set NCDB.Ncdb_master_update;
keep ucounty Jurisdiction numhhs7 numhhs8 numhhs9 numhhs0 numhhs1;

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

proc sort data=households;
by ucounty;
run;

data COGSarea_2017 (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255"
                    ) and pernum =1 and gq in (1,2)));
set Ipums.Acs_2017_dc Ipums.Acs_2017_md Ipums.Acs_2017_va;
keep upuma Jurisdiction hhwt totalunits pernum gq;
	%assign_jurisdiction; 
totalunits=1;
	run;

proc sort data=COGSarea_2017;
by upuma;
run;
proc summary data=COGSarea_2017;
by upuma;
var totalunits;
weight hhwt;
output out = COGSarea_2017_sum sum=;
run;

proc sort data=COGSarea_2017_sum;
by upuma;
run;

data COGSvacant_2017 (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255" )));
set Ipums.Acs_2017_vacant_dc Ipums.Acs_2017_vacant_md Ipums.Acs_2017_vacant_va;

	%assign_jurisdiction; 
if vacancy in (1,2,3) then vacunit = 1; else vacunit = 0;
run;

data COGvacant2017;
set COGSvacant_2017(keep=upuma hhwt VACANCY Jurisdiction vacunit where=(vacancy in (1,2,3)));
run;

proc sort data= COGvacant2017;
by upuma;
run;

proc summary data=COGvacant2017;
by upuma;
var vacunit;
weight hhwt;
output out = COGvacant2017_sum sum=;
run;

proc sort data=COGvacant2017_sum;
by upuma;
run;

data vacantunits;
merge COGvacant2017_sum COGSarea_2017_sum;
by upuma;
	%assign_jurisdiction; 
run;


proc summary data= vacantunits;
	class Jurisdiction;
	var totalunits vacunit;
	output out = vacancyrate  sum=;
	format Jurisdiction Jurisdiction. ;
	run;

data vacancyrate2;  
set vacancyrate;
keep Jurisdiction vacrate;
vacrate= vacunit/totalunits;
run;

proc sort data=COGSarea_2017 ;
by Jurisdiction;
run;

data hh_housing;
merge COGSarea_2017 vacancyrate2;
by Jurisdiction;
run;

data hhestimates17 (drop= _TYPE_ _FREQ_);
set hh_housing;
hhestimate17= totalunits*(1-vacrate);
run;
proc sort data=hhestimates17;
by Jurisdiction;
run;

proc sort data=households;
by Jurisdiction;
run;

proc summary data=hhestimates17;
	class Jurisdiction ;
	var hhestimate17;
	weight hhwt;
	output out = HH17 (where=(_TYPE_=1))sum=;
	format Jurisdiction Jurisdiction. ;
run;

proc summary data=households;
	class Jurisdiction ;
	var numhhs7 numhhs8 numhhs9 numhhs0 numhhs1;
	output out = NCDBhouseholds (where=(_TYPE_=1))  sum=;
	format Jurisdiction Jurisdiction. ;
run;

data NCDBhouseholds;
set NCDBhouseholds(drop= _TYPE_ _FREQ_);
run;

data HH17;
set HH17(drop= _TYPE_ _FREQ_);
run;

data totalhouseholdtrend;
merge NCDBhouseholds HH17;
by Jurisdiction;
run;

proc export data = totalhouseholdtrend
   outfile="&_dcdata_default_path\RegHsg\Prog\totalhouseholdtrend.csv"
   dbms=csv
   replace;
run;


/*hh by size, type and income*/
%macro hhnonrelate(year);
data hhrelate_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002","2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107","5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305","5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244","5151245", "5151246", "5151255")))  ;;
set Ipums.ACS_&year._dc(where=(gq in (1,2))) Ipums.ACS_&year._va(where=(gq in (1,2))) Ipums.ACS_&year._md(where=(gq in (1,2)));
keep upuma pernum gq hhwt perwt year serial numprec relate related notnonrelate;
if relate in (11,12,13) then notnonrelate=0;
else if relate in (1,2,3,4,5,6,7,8,9,10) then notnonrelate=1;
run;

proc summary data=hhrelate_&year.;
  class serial;
  var notnonrelate;
  output out =aaa_&year. sum= ;
run;

data nonrelatehh_&year. ;
set aaa_&year.;
if notnonrelate>=1 then nonrelatehh=0;
else if notnonrelate=0 then nonrelatehh=1;
else nonrelatehh=.;
run;

%mend hhnonrelate;
%hhnonrelate(2010);
%hhnonrelate(2017);

data hhrelate_2000(where=(upuma in ("1100101",
"1100102",
"1100103",
"1100104",
"1100105",
"2401600",
"2400300",
"2401001",
"2401002",
"2401003",
"2401004",
"2401005",
"2401006",
"2401007",
"2401101",
"2401102",
"2401103",
"2401104",
"2401105",
"2401106",
"2401107",
"5100101",
"5100100",
"5100301",
"5100302",
"5100303",
"5100304",
"5100305",
"5100600",
"5100501",
"5100502",
"5100200"
)));;
set Ipums.Ipums_2000_dc(where=(gq in (1,2))) Ipums.Ipums_2000_va(where=(gq in (1,2))) Ipums.Ipums_2000_md(where=(gq in (1,2)));
keep pernum gq upuma hhwt perwt year serial numprec related notnonrelate;
if related in (1113, 1115, 1241, 1260, 1270, 1301) then notnonrelate=0;
else if related in (201, 301, 302, 303, 401, 501, 601, 701, 801, 901, 1001, 1011, 1021, 1031, 1041, 1242) then notnonrelate=1;
run;

proc summary DATA=hhrelate_2000;
  class serial;
  var notnonrelate;
  output out =aaa_2000 sum= ;
run;

data nonrelatehh_2000 ;
set aaa_2000;
if notnonrelate>=1 then nonrelatehh=0;
else if notnonrelate=0 then nonrelatehh=1;
else nonrelatehh=.;
run;


%macro popbyrace(year);
data hhtype_1_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002","2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107","5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305","5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244","5151245", "5151246", "5151255")))  ;
set Ipums.ACS_&year._dc(where=(pernum=1 and gq in (1,2))) Ipums.ACS_&year._va(where=(pernum=1 and gq in (1,2))) Ipums.ACS_&year._md(where=(pernum=1 and gq in (1,2)));
keep pernum gq upuma Jurisdiction hhwt perwt year serial numprec HHINCOME HHTYPE relate hud_inc;

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

	  if hhincome ~=.n or hhincome ~=9999999 then do; 
		 %dollar_convert( hhincome, hhincome_a, &year., 2017, series=CUUR0000SA0 )
	   end; 
  
	*create HUD_inc - uses 2016 limits but has categories for 120-200% and 200%+ AMI; 

		%Hud_inc_RegHsg( hhinc=hhincome_a, hhsize=numprec )
run;

data hhtype_&year.;
merge hhtype_1_&year. nonrelatehh_&year. ;
by serial;
if hhtype in (4,5,6,7) then do;  /*non family*/
	if numprec=1 then HHcat=1 ; /*single*/
end;

if hhtype in (1,2,3) then do; /*family household*/
    if hhtype=1 & numprec=2 then HHcat=2 ; /*couple without kid*/
	else HHcar=3; /*other family*/
end;

if nonrelatehh=1 then HHcat=3; /* non relate households*/

if hhtype in (0, 9) then HHcat=.;

else HHcat=4;

retain HHnumber_&year.=1;

run; 

%mend popbyrace;

%popbyrace(2010);
%popbyrace(2017);


data hhtype_1_2000 (where=(upuma in ("1100101",
"1100102",
"1100103",
"1100104",
"1100105",
"2401600",
"2400300",
"2401001",
"2401002",
"2401003",
"2401004",
"2401005",
"2401006",
"2401007",
"2401101",
"2401102",
"2401103",
"2401104",
"2401105",
"2401106",
"2401107",
"5100101",
"5100100",
"5100301",
"5100302",
"5100303",
"5100304",
"5100305",
"5100600",
"5100501",
"5100502",
"5100200"
)));
set Ipums.Ipums_2000_dc(where=(pernum=1 and gq in (1,2))) Ipums.Ipums_2000_va(where=(pernum=1 and gq in (1,2))) Ipums.Ipums_2000_md(where=(pernum=1 and gq in (1,2)));
keep pernum upuma gq Jurisdiction hhwt perwt year serial numprec HHINCOME HHTYPE hud_inc;

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

	  if hhincome ~=.n or hhincome ~=9999999 then do; 
		 %dollar_convert( hhincome, hhincome_a, 2000, 2017, series=CUUR0000SA0 )
	   end; 
  
	*create HUD_inc - uses 2016 limits but has categories for 120-200% and 200%+ AMI; 

		%Hud_inc_RegHsg( hhinc=hhincome_a, hhsize=numprec )
run;
%macro summarizehh(year);
data hhtype_2000;
merge hhtype_1_2000 nonrelatehh_2000 ;
by serial;
if hhtype in (4,5,6,7) then do;  /*non family*/
	if numprec=1 then HHcat=1 ; /*single*/
end;

if hhtype in (1,2,3) then do; /*family household*/
    if hhtype=1 & numprec=2 then HHcat=2 ; /*couple without kid*/
	else HHcar=3; /*other family*/
end;

if nonrelatehh=1 then HHcat=3; /* non relate households*/

if hhtype in (0, 9) then HHcat=.;

else HHcat=4;

HHnumber_2000 =1;

run; 


proc summary data = hhtype_&year. ;
	class Jurisdiction numprec hud_inc nonrelatehh;
	var HHnumber_&year.;
	weight perwt;
	output out = HH_size_inc_type_&year.  sum=;
	format Jurisdiction Jurisdiction. hud_inc inc_cat. ;
run;

proc sort data=agegroup_race_immigration_&year.;
by Jurisdiction;
run;

%mend summarizehh;

%summarizehh(2000);
%summarizehh(2010);
%summarizehh(2017);


