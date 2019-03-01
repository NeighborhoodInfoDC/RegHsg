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

 value racenew
   .n = 'Not available'
    1 = 'White non-Hispanic'
    2 = 'Black non-Hispanic'
    3 = "Hispanic "
	4 = "All other non-Hispanic "
	5= "Asian non-Hispanic";

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

  /* Derived household categories*/
  value hhcat
    1 = "Person living alone"
    2 = "Couple living alone"
    3 = "Family with children"
    4 = "2+ unrelated adults only"
    5 = "Other households";

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
	11= "Total"
  	;

  value foreignborn
  1= "Foreign born"
  0= "Not Foreign born"
  .n= "Missing"
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

/*Summarize number of persons in household for testing*/
value numprec3p
  1 = '1'
  2 = '2'
  3-high = '3+';

/*Summarize number of persons in household for tables*/
value numprectab 
  1 = '1'
  2 = '2'
  3 = '3'
  4 = '4'
  5 = '5'
  6-high = '6+';
  	  
run;

/**************************************************************************
Read in census population data
**************************************************************************/

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

	ucounty=  state|| county;

	drop SUMLEV REGION DIVISION STNAME CTYNAME;

	 if ucounty in ("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685");
run;

/**************************************************************************
Compile population trend data
**************************************************************************/

data population (where= (ucounty in("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685" )));
set NCDB.Ncdb_master_update;
keep ucounty Jurisdiction trctpop9 trctpop0 trctpop1 numhhs9 numhhs0 numhhs1;

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
var trctpop9 trctpop0 trctpop1 numhhs9 numhhs0 numhhs1;
output out= NCDBpopulation sum=;
run;

proc sort data=NCDBpopulation;
by ucounty;
run;

libname rawnhgis "L:\Libraries\RegHsg\Raw\NHGIS";

data pop_70;
set rawnhgis.nhgis0014_ts_nominal_1970_county;
keep ucounty TotPop TotHH Jurisdiction;
rename Totpop= Totpop70;
rename TotHH= TotHH70;
label Totpop="Total populations in 1970";
label TotHH="Total households in 1970";

if ucounty = "11001" then TotHH = 262538;

if ucounty in ("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685");
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

proc sort data=pop_70;
by ucounty;
run;

data pop_80;
set rawnhgis.nhgis0014_ts_nominal_1980_county;
keep ucounty TotPop TotHH Jurisdiction;
rename Totpop= Totpop80;
rename TotHH= TotHH80;
label Totpop="Total populations in 1980";
label TotHH="Total households in 1980";
if ucounty in ("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685");
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

proc sort data=pop_80;
by ucounty;
run;

data pop78;
merge pop_80 pop_70;
by ucounty;
if ucounty = "51683" then Totpop70 = 9164;
if ucounty = "51683" then TotHH70 = 2705;
if ucounty = "51685" then Totpop70 = 6844;
if ucounty = "51685" then TotHH70 = 1514;
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
merge pop78(drop=TotHH70 TotHH80) NCDBpopulation pop17;
by ucounty;
format Jurisdiction Jurisdiction. ;
COG=1;
run;

proc sort data = populationtrend;
by Jurisdiction;
run;

proc summary data= populationtrend;
	class Jurisdiction;
	var totpop70 totpop80 trctpop9 trctpop0 trctpop1 POPESTIMATE2017;
	output out= populationbyjur sum=;
run;

data populationbyjur2 ;
set populationbyjur;
if _TYPE_= 0 then Jurisdiction=11 ;
label TRCTPOP9 ="Total population in 1990";
label TRCTPOP0 ="Total population in 2000";
label TRCTPOP1= "Total population in 2010";
label POPESTIMATE2017= "Total population in 2017";
format Jurisdiction Jurisdiction.;
run;

proc export data = populationbyjur2(drop= _TYPE_ _FREQ_)
   outfile="&_dcdata_default_path\RegHsg\Prog\populationbyjur.csv"
   label dbms=csv
   replace;
run;

/**************************************************************************
Use census population estimate for component of population change
**************************************************************************/

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

keep ucounty Jurisdiction NATURALINC: INTERNATIONALMIG: DOMESTICMIG: NETMIG:;
run;

proc means noprint data=changecomponent;
output out=dem_change_sum sum=;
run;

data changecomponent_total (drop= _TYPE_ _FREQ_);
set changecomponent dem_change_sum(in=in2);
if in2 then Jurisdiction=11;
format Jurisdiction Jurisdiction.;
run;

proc export data = changecomponent
   outfile="&_dcdata_default_path\RegHsg\Prog\changecomponent.csv"
   label dbms=csv
   replace;
run;

/**************************************************************************
Compile population break down by race, age and foreign born status
**************************************************************************/

%macro popbyrace(year);
data persons_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002","2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107","5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305","5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244","5151245", "5151246", "5151255")))  ;
set Ipums.ACS_&year._dc Ipums.ACS_&year._va Ipums.ACS_&year._md;
keep upuma race hispan age pernum gq Jurisdiction hhwt perwt year serial numprec race1 age0 totpop_&year. BPL foreignborn COG;

	%assign_jurisdiction; 

if hispan=0 then do;

 if race=1 then race1=1;
 else if race=2 then race1=2;
 else if race in (4,5,6) then race1= 5;
 else race1=4;
end;

if hispan in(1, 2, 3, 4) then race1=3;

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

if BPL in (150:950) then foreignborn=1;
else if BPL=999 then foreignborn=.n;
else foreignborn=0;

totpop_&year. = 1;
COG=1;
run;

proc summary data = persons_&year. ;
	class Jurisdiction age0 race1 foreignborn;
	var totpop_&year.;
	weight perwt;
	output out = agegroup_race_immigration_&year. sum=;
	format race1 racenew. age0 agegroup. Jurisdiction Jurisdiction. foreignborn foreignborn.;
run;

proc sort data=agegroup_race_immigration_&year.(drop= _FREQ_ );
by Jurisdiction age0 race1 foreignborn _TYPE_;
run;

%mend popbyrace;

%popbyrace(2017);

data persons_2010 (where= (Jurisdiction in (1:10))) ;
set Ipums.ACS_2010_dc Ipums.ACS_2010_va Ipums.ACS_2010_md;
keep upuma race hispan age pernum gq Jurisdiction hhwt perwt year serial numprec race1 age0 totpop_2010 BPL foreignborn COG;
  if upuma in ("1100101", "1100102", "1100103", "1100104", "1100105") then Jurisdiction =1;
  if upuma in ("2401600") then Jurisdiction =2;
  if upuma in ("2400300") then Jurisdiction =3;
  if upuma in ("2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007") then Jurisdiction =4;
  if upuma in ("2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107") then Jurisdiction =5;
  if upuma in ("5100100") then Jurisdiction =6;
  if upuma in ("5100301", "5100302", "5100303", "5100304", "5100305", "5100303", "5100301") then Jurisdiction =7;
  if upuma in ("5100600") then Jurisdiction =8;
  if upuma in ("5100501", "5100502", "5100501") then Jurisdiction =9; 
  if upuma in ("5100200") then Jurisdiction =10; 

if hispan=0 then do;

 if race=1 then race1=1;
 else if race=2 then race1=2;
 else if race in (4,5,6) then race1= 5;
 else race1=4;
end;

if hispan in(1, 2, 3, 4) then race1=3;

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

if BPL in (150:950) then foreignborn=1;
else if BPL=999 then foreignborn=.n;
else foreignborn=0;

totpop_2010 = 1;
COG=1;
run;

proc summary data = persons_2010 ;
	class Jurisdiction age0 race1 foreignborn;
	var totpop_2010;
	weight perwt;
	output out = agegroup_race_immigration_2010 sum=;
	format race1 racenew. age0 agegroup. Jurisdiction Jurisdiction. foreignborn foreignborn.;
run;

proc sort data=agegroup_race_immigration_2010(drop= _FREQ_ );
by Jurisdiction age0 race1 foreignborn _TYPE_;
run;

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
keep upuma racgen00 hispand age pernum gq Jurisdiction hhwt perwt year serial numprec race1 age0 totpop_00 bpld foreignborn;

  if upuma in ("1100101", "1100102", "1100103", "1100104", "1100105") then Jurisdiction =1;
  if upuma in ("2401600") then Jurisdiction =2;
  if upuma in ("2400300") then Jurisdiction =3;
  if upuma in ("2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007") then Jurisdiction =4;
  if upuma in ("2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107") then Jurisdiction =5;
  if upuma in ("5100100") then Jurisdiction =6;
  if upuma in ("5100301", "5100302", "5100303", "5100304", "5100305", "5100303", "5100301") then Jurisdiction =7;
  if upuma in ("5100600") then Jurisdiction =8;
  if upuma in ("5100501", "5100502", "5100501") then Jurisdiction =9; 
  if upuma in ("5100200") then Jurisdiction =10; 

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

if bpld in (15000:95000) then foreignborn=1;
else if bpld=99900 then foreignborn=.n;
else foreignborn=0;

totpop_00 = 1;
run;

proc freq data= persons_2000;
tables bpld;
run;

proc summary data = persons_2000 ;
	class Jurisdiction age0 race1 foreignborn;
	var totpop_00;
	weight perwt;
	output out = agegroup_race_immigration_00  sum=;
	format race1 racenew. age0 agegroup. Jurisdiction Jurisdiction. foreignborn foreignborn. ;
run;

proc sort data=agegroup_race_immigration_00 (drop= _FREQ_ );
by Jurisdiction age0 race1 foreignborn _TYPE_;
run;

/*from NCDB pop10: 312311, pop00: 169599 for Loudon. From Ipums: pop00: 268888, pop10: 432211 use the ratio to adjust ipums*/
data popbreakdown;
merge agegroup_race_immigration_00 agegroup_race_immigration_2010 agegroup_race_immigration_2017;
by Jurisdiction age0 race1 foreignborn _TYPE_;
if Jurisdiction=8 then totpop_00=totpop_00*(169599/268888); 
if Jurisdiction=8 then totpop_2010=totpop_2010*(312311/432211);
run;

proc export data = popbreakdown
   outfile="&_dcdata_default_path\RegHsg\Prog\popbreakdown.csv"
   dbms=csv
   replace;
run;

/**************************************************************************
Compile household trend 
**************************************************************************/

/*household number*/

data households (where= (ucounty in("11001","24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685" )));
set NCDB.Ncdb_master_update;
keep ucounty Jurisdiction numhhs9 numhhs0 numhhs1;

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
/* calculate vacancy rate in 2017 and estimate hh counts based on housing units*/
data units_2017 (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255"
                    ) and pernum =1 and gq in (1,2)));
set Ipums.Acs_2017_dc Ipums.Acs_2017_md Ipums.Acs_2017_va;
keep upuma Jurisdiction hhwt totalunits pernum gq;
	%assign_jurisdiction; 
totalunits=1;
	run;

proc sort data=units_2017;
by upuma;
run;
proc summary data=units_2017;
by upuma;
var totalunits;
weight hhwt;
output out = COGSarea_2017_sum sum=;
run;

data vacant_2017 (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255" )));
set Ipums.Acs_2017_vacant_dc Ipums.Acs_2017_vacant_md Ipums.Acs_2017_vacant_va;

	%assign_jurisdiction; 
if vacancy in (1,2,3) then vacunit = 1;
run;

data COGvacant2017;
set vacant_2017(keep=upuma hhwt VACANCY Jurisdiction vacunit where=(vacancy in (1,2,3)));
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

proc sort data=units_2017;
by Jurisdiction;
run;

data hh_housing;
merge units_2017 vacancyrate2;
by Jurisdiction;
run;

data hhestimates17;
set hh_housing;
hhestimate17= totalunits*(1-vacrate);
run;
/*end of estimating 2017 hh counts*/

proc summary data=hhestimates17;
	class Jurisdiction ;
	var hhestimate17;
	weight hhwt;
	output out = HH17 sum=;
	format Jurisdiction Jurisdiction. ;
run;

proc sort data=hhestimates17;
by Jurisdiction;
run;

data HH17;
set HH17;
if _TYPE_=0 then Jurisdiction=11;
run;
proc sort data=population;
by Jurisdiction;
run;
proc summary data=population;
	class Jurisdiction ;
	var numhhs9 numhhs0 numhhs1;
	output out = NCDBhouseholds(drop= _FREQ_)  sum=;
	format Jurisdiction Jurisdiction. ;
run;

proc summary data= pop78;
class Jurisdiction ;
var tothh70 tothh80;
output out= households78 sum=;
format Jurisdiction Jurisdiction. ;
run;
data households78;
set households78;
if _TYPE_=0 then Jurisdiction=11;;
run;

data NCDBhouseholds;
set NCDBhouseholds;
if _TYPE_=0 then Jurisdiction=11;
run;

proc sort data=HH17;
by Jurisdiction;
run;

proc sort data=households78;
by Jurisdiction;
run;

proc sort data=NCDBhouseholds;
by Jurisdiction;
run;

data totalhouseholdtrend (drop= _TYPE_ _FREQ_);
merge households78 NCDBhouseholds HH17;
by Jurisdiction;
label NUMHHS9= "Total households in 1990";
label NUMHHS0= "Total households in 2000";
label NUMHHS1= "Total households in 2010";
label hhestimate17 = "Total households in 2017";
run;

proc export data = totalhouseholdtrend
   outfile="&_dcdata_default_path\RegHsg\Prog\totalhouseholdtrend.csv"
   dbms=csv
   replace;
run;

/**************************************************************************
Compile hh counts by size, family type and income
**************************************************************************/

/*hh by size, type and income*/

%macro hhnonrelate(year);

%local filepre;

%if &year = 2000 %then %let filepre = Ipums;
%else %let filepre = ACS;

data hhrelate_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002","2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107","5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305","5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244","5151245", "5151246", "5151255"))) ;
set Ipums.&filepre._&year._dc Ipums.&filepre._&year._va Ipums.&filepre._&year._md;
where gq in ( 1, 2 );
keep upuma pernum gq hhwt perwt year serial age numprec related notrelatedper relatedper 
     spouse unmarriedpartner children totnumpop;

notrelatedper = 0;
relatedper = 0;
spouse = 0;
unmarriedpartner = 0;
children = 0;

/** Count numbers of related and not related persons in HH **/
if 1100 <= related <= 1260 then notrelatedper=1;
else if 201 <= related <= 1061 then relatedper=1;

/** Spouse present **/
if related = 201 then spouse = 1;

/** Unmarried partners **/
if related = 1114 then unmarriedpartner = 1;

/** Children **/
if 0 <= age < 18 then children = 1;

totnumpop=1;

run;

proc summary data=hhrelate_&year. nway;
  class serial;
  var relatedper notrelatedper spouse unmarriedpartner children totnumpop;
  output out =aaa_&year. (drop=_type_ _freq_) sum= ;
run;

%mend hhnonrelate;

%macro hhtype_1(year);

%local filepre;

%if &year = 2000 %then %let filepre = Ipums;
%else %let filepre = ACS;

data hhtype_1_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002","2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107","5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305","5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244","5151245", "5151246", "5151255"))) ;
set Ipums.&filepre._&year._dc Ipums.&filepre._&year._va Ipums.&filepre._&year._md;
where pernum=1 and gq in (1,2);
keep pernum gq upuma Jurisdiction hhwt perwt year serial numprec HHINCOME HHTYPE relate incomecat;


	%assign_jurisdiction; 

	  if hhincome ~=.n or hhincome ~=9999999 then do; 
		 %dollar_convert( hhincome, hhincome_a, &year., 2016, series=CUUR0000SA0 )
	   end; 
  
		if hhincome_a in ( 9999999, .n , . ) then incomecat=.;
			else do; 
			    if hhincome_a<=32600 then incomecat=1;
				else if 32600<hhincome_a<=54300 then incomecat=2;
				else if 54300<hhincome_a<=70150 then incomecat=3;
				else if 70150<hhincome_a<=108600 then incomecat=4;
				else if 108600<hhincome_a<=130320 then incomecat=5;
				else if 130320<hhincome_a<=217200 then incomecat=6;
				else if 217200 < hhincome_a then incomecat=7;
			end;

		  label incomecat='Income Categories based on 2016 HUD Limit for Family of 4';

run;

proc sort data= hhtype_1_&year.;
by serial;
run;

data hhtype_&year.;

merge hhtype_1_&year. aaa_&year. ;
by serial;

	if numprec=1 then HHcat=1 ; /*singleton*/
  else if numprec=2 and ( spouse=1 or unmarriedpartner=1 ) then HHcat=2; /*(married/unmarried)couple alone*/
  else if relatedper > 0 and children > 0 then HHcat=3; /* family with children */
	else if relatedper=0 and children=0 then HHcat=4; /* non related adult households*/ 
  else HHcat=5; /*other households*/

HHnumber_&year.=1;

run; 

title2 "Check HH types &year";

proc freq data=hhtype_&year;
  weight hhwt;
  tables hhcat;
  tables hhcat * numprec / list missing nocum;
  format hhcat hhcat. numprec numprec3p.;
run;

title2; 

%mend hhtype_1;

/** 2017 **/
%hhnonrelate(2017);
%hhtype_1(2017);

/** 2010 **/
%hhnonrelate(2010);
%hhtype_1(2010);

/** 2000 **/
%hhnonrelate(2000);
%hhtype_1(2000);


%macro summarizehh(year);

proc summary data = hhtype_&year. ;
	class Jurisdiction numprec incomecat HHcat;
  ways 0 1;
	var HHnumber_&year.;
	weight hhwt;
	output out = HH_size_inc_type_&year.  sum=;
	format Jurisdiction Jurisdiction. incomecat inc_cat. HHcat hhcat. numprec numprectab.;
run;

proc sort data=HH_size_inc_type_&year.;
by _type_ Jurisdiction numprec incomecat HHcat;
run;

%mend summarizehh;

%summarizehh(2000);
%summarizehh(2010);
%summarizehh(2017);

/*have to adjust the Loudon number for 2000 and 2010 because it took a portion of a PUMA, according to NCDB Loudon hh in 2000 is 59921, hh in 2010 is 104583, the PUMA containing LOUdon has 97263 in 2000, 145906 in 2010*/
data Loudon (where=(ucounty= "51107"));
set NCDBpopulation;
run;

data hhbytypeallyears;
merge HH_size_inc_type_2000 HH_size_inc_type_2010 HH_size_inc_type_2017;
by _type_ Jurisdiction numprec incomecat HHcat;
if Jurisdiction= 8 then HHnumber_2000=HHnumber_2000*(59921/97263);
if Jurisdiction= 8 then HHnumber_2010=HHnumber_2010*(104583/145906);
run;

proc export data = hhbytypeallyears
   outfile="&_dcdata_default_path\RegHsg\Prog\hhbytypeallyears.csv"
   dbms=csv
   replace;
run;


