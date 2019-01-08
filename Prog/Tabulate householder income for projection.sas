/**************************************************************************
 Program:  tabulate householder population for projection.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  1/8/19
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

	value agegroupnew
	.n= 'Not available'
	1='under 25 years old'
	2= '25-45 years old'
	3= '45-65 years old'
	4='65+ years old';
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

	value newinc
	1= "0-32,600 Dollars"
	2= "32,600-54,300 Dollars"
	3="54,300-86,880 Dollars"
	4="86,880-10,8600 Dollars"
	5="108,600-130,320 Dollars"
	6="130,320-217,200 Dollars"
	7="More than 217,200 Dollars";

run;

%macro householdinfo(year);


data Household_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
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


data Householddetail_&year.;
set Household_&year. (where=(relate=1));
keep race hispan age hhincome pernum relate gq Jurisdiction hhwt perwt year serial numprec race1 age0 agegroup incomecat totpop_&year.;

 %Hud_inc_RegHsg( hhinc=hhincome, hhsize=numprec )
  label
  hud_inc = 'HUD income category for household'; 

if 0=<HHINCOME<=32600 then incomecat=1;
else if 32600<HHINCOME<=54300 then incomecat=2;
else if 54300<HHINCOME<=86880 then incomecat=3;
else if 86880<HHINCOME<=108600 then incomecat=4;
else if 108600<HHINCOME<=130320 then incomecat=5;
else if 130320<HHINCOME<=217200 then incomecat=6;
else if HHINCOME>217200 then incomecat=7;

if hispan=0 then do;

 if race=1 then race1=1;
 else if race=2 then race1=2;
 else race1=4;
end;

if hispan in(1 2 3 4) then race1=3;

if 0<=age<25 then agegroup=1;
else if 25<=age<45 then agegroup=2;
else if 45<=age<65 then agegroup=3;
else if age>=65 then agegroup=4;

totpop_&year. = 1;
run;

proc freq data=Householddetail_&year.;
  tables race1 * agegroup  / list missing;
run;

proc sort data=Householddetail_&year.;
by Jurisdiction agegroup race1 relate incomecat;
run;

%mend householdinfo;

%householdinfo(2013);
%householdinfo(2014);
%householdinfo(2015);
%householdinfo(2016);
%householdinfo(2017);

data fiveyeartotal;
set Householddetail_2013 Householddetail_2014 Householddetail_2015 Householddetail_2016 Householddetail_2017;
totalpop=0.2;
run;
/*total COG*/
proc summary data=fiveyeartotal;
class agegroup race1 incomecat;
	var totalpop;
	weight hhwt;
	output out = Householderbreakdown(where=(_TYPE_=7)) sum=;
	format race1 racenew. agegroup agegroupnew. ;
run;

proc transpose data=Householderbreakdown out=distribution;
by agegroup race1;
id incomecat;
var totalpop;
run;

data distribution_2;
set distribution;
denom= _1+_2+_3 +_4 +_5 +_6 +_7 ;
incomecat1=_1/denom ;
incomecat2=_2/denom ;
incomecat3=_3/denom ;
incomecat4=_4/denom ;
incomecat5=_5/denom ;
incomecat6=_6/denom ;
incomecat7=_7/denom ;
run;

proc export data = distribution_2
   outfile="&_dcdata_default_path\RegHsg\Prog\Householdertab_total.csv"
   dbms=csv
   replace;
run;

/*by jurisdiction*/
proc summary data=fiveyeartotal;
class Jurisdiction agegroup race1 incomecat;
	var totalpop;
	weight perwt;
	output out = Householderbreakdown_COG(where=(_TYPE_=15)) sum=;
	format race1 racenew. agegroup agegroupnew.;
run;

proc transpose data=Householderbreakdown_COG out=COGdistribution;
by Jurisdiction agegroup race1 ;
id incomecat;
var totalpop;
run;
proc stdize data=COGdistribution out=COGdistribution_2 reponly missing=0;
   var _1 _2 _3 _4 _5 _6 _7;
run;
data COGdistribution_3;
set COGdistribution_2;
denom= _1+_2+_3 +_4 +_5 +_6 +_7 ;
incomecat1=_1/denom ;
incomecat2=_2/denom ;
incomecat3=_3/denom ;
incomecat4=_4/denom ;
incomecat5=_5/denom ;
incomecat6=_6/denom ;
incomecat7=_7/denom ;
run;
proc sort data= COGdistribution_3;
by Jurisdiction race1 agegroup;
run;

proc export data = COGdistribution_3
   outfile="&_dcdata_default_path\RegHsg\Prog\Householdertab_total_Jurisdiction.csv"
   dbms=csv
   replace;
run;

