/**************************************************************************
 Program:  Calculate population by age and raceethnicity.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  1/1/19
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Produce detailed popualtion by age group, race ethnicity and jurisciation from 2008-2017
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

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RegHsg)
%DCData_lib( Ipums)

proc format;
  value race
   .n = 'Not available'
    1 = 'White'
    2 = 'Black'
    3 = "All Other ";
  value hispan
     .n = 'Not available'
    0 = 'Not Hispanic'
    1 = 'Hispanic';
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

	value Jurisdiction
    1= "District of Columbia"
	2= "Charles County"
	3= "Frederick County "
	4="Montgomery County"
	5="Prince George's County"
	6="Arlington County"
	7="Fairfax, Fairfax City, and Falls Church"
	8="Loudoun County"
	9="Prince William, Manassas, and Manassas Park"
    10="City of Alexandria";
run;

%macro popbyrace(year);


data COGS_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;

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
run;


data Race_&year.;

set COGS_&year.;
keep race hispan age hhincome pernum gq Jurisdiction hhwt perwt year serial numprec race1 age0 totpop_&year.;

 %Hud_inc_RegHsg( hhinc=hhincome, hhsize=numprec )
  label
  hud_inc = 'HUD income category for household'; 

  /*
if race= 1 then race0=1; 
else if race=2 then race0=2;
else race0=3;

if hispan=0 then hispan0=0;
else hispan0=1;
*/
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

proc summary data = Race_&year. ;
	class Jurisdiction age0 race1;
	var totpop_&year.;
	weight perwt;
	output out = agegroup_race_&year. (where=(_TYPE_=7)) sum=;
	format race1 racenew. age0 agegroup. Jurisdiction Jurisdiction.;
run;

proc sort data=agegroup_race_&year.;
by Jurisdiction age0 race1;
run;

%mend popbyrace;


%popbyrace(2012);
%popbyrace(2013);
%popbyrace(2014);
%popbyrace(2015);
%popbyrace(2016);
%popbyrace(2017);

%macro popbyraceold(year);


data COGS_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400300", "2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107","5100100", "5100301", "5100302", "5100303", "5100304", "5100305", "5100600", "5100501", "5100502", "5100100", "5100200" )));
set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;

  if upuma in ("1100101", "1100102", "1100103", "1100104", "1100105") then Jurisdiction =1;
  if upuma in ("2401600") then Jurisdiction =2;
  if upuma in ("2400300") then Jurisdiction =3;
  if upuma in ("2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007") then Jurisdiction =4;
  if upuma in ("2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107") then Jurisdiction =5;
  if upuma in ("5100100") then Jurisdiction =6;
  if upuma in ("5100301", "5100302", "5100303", "5100304", "5100305") then Jurisdiction =7;
  if upuma in ("5100600") then Jurisdiction =8;
  if upuma in ("5100501", "5100502") then Jurisdiction =9; 
  if upuma in ("5100200") then Jurisdiction =10; 
run;


data Race_&year.;

set COGS_&year.;
keep race hispan age hhincome pernum gq Jurisdiction hhwt perwt year serial numprec race1 age0 totpop_&year.;

 %Hud_inc_RegHsg( hhinc=hhincome, hhsize=numprec )
  label
  hud_inc = 'HUD income category for household'; 

  /*
if race= 1 then race0=1; 
else if race=2 then race0=2;
else race0=3;

if hispan=0 then hispan0=0;
else hispan0=1;
*/
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

proc summary data = Race_&year. ;
	class Jurisdiction age0 race1;
	var totpop_&year.;
	weight perwt;
	output out = agegroup_race_&year. (where=(_TYPE_=7)) sum=;
	format race1 racenew. age0 agegroup. Jurisdiction Jurisdiction.;
run;

proc sort data=agegroup_race_&year.;
by Jurisdiction age0 race1;
run;

%mend popbyraceold;
%popbyraceold(2008);
%popbyraceold(2009);
%popbyraceold(2010);
%popbyraceold(2011);

data pop_race_ethnicity;
merge agegroup_race_2008 agegroup_race_2009 agegroup_race_2010 agegroup_race_2011 agegroup_race_2012 agegroup_race_2013 agegroup_race_2014 agegroup_race_2015 agegroup_race_2016 agegroup_race_2017;
by Jurisdiction age0 race1;
keep Jurisdiction age0 race1 totpop_2008 totpop_2009 totpop_2010 totpop_2011 totpop_2012 totpop_2013 totpop_2014 totpop_2015 totpop_2016 totpop_2017;
run;
data pop_race_ethnicity;
set pop_race_ethnicity;
if Jurisdiction=8 then totpop_2008=.n;
if Jurisdiction=8 then totpop_2009=.n;
if Jurisdiction=8 then totpop_2010=.n;
if Jurisdiction=8 then totpop_2011=.n;
run; 

proc sort data=pop_race_ethnicity;
by Jurisdiction race1 age0;
run;

proc export data = pop_race_ethnicity
   outfile="&_dcdata_default_path\RegHsg\Prog\pop_race_ethnicity_jurisdiction_0817.csv"
   dbms=csv
   replace;
run;

proc summary data=pop_race_ethnicity;
class Jurisdiction age0;
var totpop_2008 totpop_2009 totpop_2010 totpop_2011 totpop_2012 totpop_2013 totpop_2014 totpop_2015 totpop_2016 totpop_2017;
output out = totalpop sum=;
run;

proc export data = totalpop
   outfile="&_dcdata_default_path\RegHsg\Prog\pop_race_ethnicity_total_0817.csv"
   dbms=csv
   replace;
run;
