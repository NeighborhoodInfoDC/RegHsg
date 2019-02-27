/**************************************************************************
 Program:  Housing market analysis.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su 
 Created:  2/22/19
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Produce numbers for housing market 2000-2017 for the COGS region:
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

proc format;

  value tenure
  1= "Renter household"
  2= "Owner household"
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
run;
/*Housing units*/
%macro COGunits(year);
data COGSvacant_&year.(where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255") and vacancy in (1,2)));
set Ipums.Acs_&year._vacant_dc Ipums.Acs_&year._vacant_md Ipums.Acs_&year._vacant_va ;
	%assign_jurisdiction; 
if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/

if vacancy=1 then Tenure = 1; /*renter*/
if vacancy=2 then Tenure = 2; /*owner*/

vacantunit_&year.=1;
run;

proc summary data= COGSvacant_&year.;
class Jurisdiction structuretype bedrooms Tenure;
var vacantunit_&year.;
weight hhwt;
output out= COGSvacantunits_&year. sum=;
run;

proc sort data= COGSvacantunits_&year.;
by Jurisdiction structuretype bedrooms Tenure _TYPE_;
run;

data COGSarea_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255") and pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;

	%assign_jurisdiction; 

if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/
if ownershpd in (21, 22) then Tenure = 1; /*renter*/
if ownershpd in ( 12,13 ) then Tenure = 2; /*owner*/
unit_&year.=1;
run;

proc summary data= COGSarea_&year.;
class Jurisdiction structuretype bedrooms Tenure;
var unit_&year.;
weight hhwt;
output out=COGSareaunits_&year. sum=;
run;

proc sort data= COGSareaunits_&year.;
by Jurisdiction structuretype bedrooms Tenure _TYPE_;
run;

%mend COGunits; 

%COGunits(2017);


data COGSvacant_2010(where=(upuma in ("1100101",
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
"5100200") and vacancy in (1,2)));
set Ipums.Acs_2010_vacant_dc Ipums.Acs_2010_vacant_md Ipums.Acs_2010_vacant_va ;

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

if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/
if vacancy=1 then Tenure = 1; /*renter*/
if vacancy=2 then Tenure = 2; /*owner*/

vacantunit_2010=1;
run;

proc summary data= COGSvacant_2010;
class Jurisdiction structuretype bedrooms Tenure;
var vacantunit_2010;
weight hhwt;
output out= COGSvacantunits_2010 sum=;
run;

proc sort data= COGSvacantunits_2010;
by Jurisdiction structuretype bedrooms Tenure _TYPE_;
run;

data COGSarea_2010 (where=(upuma in ("1100101",
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
"5100200") and pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
set Ipums.Acs_2010_dc Ipums.Acs_2010_md Ipums.Acs_2010_va;

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

if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/
if ownershpd in (21, 22) then Tenure = 1; /*renter*/
if ownershpd in ( 12,13 ) then Tenure = 2; /*owner*/
unit_2010=1;
run;

proc summary data= COGSarea_2010;
class Jurisdiction structuretype bedrooms Tenure;
var unit_2010;
weight hhwt;
output out=COGSareaunits_2010 sum=;
run;

proc sort data= COGSareaunits_2010;
by Jurisdiction structuretype bedrooms Tenure _TYPE_;
run;

data COGSvacant_2000(where=(upuma in ("1100101",
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
"5100200") and vacancy in (1,2)));
set Ipums.Ipums_2000_vacant_dc Ipums.Ipums_2000_vacant_md Ipums.Ipums_2000_vacant_va ;

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

if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/

if vacancy =1 then Tenure = 1; /*renter*/
if vacancy =2 then Tenure = 2; /*owner*/

format Jurisdiction Jurisdiction.;

vacantunit_2000=1;
run;

proc summary data= COGSvacant_2000;
class Jurisdiction structuretype bedrooms Tenure;
var vacantunit_2000;
weight hhwt;
output out= COGSvacantunits_2000 sum=;
run;

proc sort data= COGSvacantunits_2000;
by Jurisdiction structuretype bedrooms Tenure _TYPE_;
run;

data COGSarea_2000(where=(upuma in ("1100101",
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
"5100200" )and pernum=1 and gq in (1,2) and ownershd in ( 12,13,21,22 )));
set Ipums.Ipums_2000_dc Ipums.Ipums_2000_md Ipums.Ipums_2000_va;

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

if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/

if ownershd in (21, 22) then Tenure = 1; /*renter*/
if ownershd in ( 12,13 ) then Tenure = 2; /*owner*/

unit_2000=1;
format Jurisdiction Jurisdiction.;

run;

proc summary data= COGSarea_2000;
class Jurisdiction structuretype bedrooms Tenure;
var unit_2000;
weight hhwt;
output out=COGSareaunits_2000 sum=;
run;

proc sort data= COGSareaunits_2000;
by Jurisdiction structuretype bedrooms Tenure _TYPE_;
run;

/*don't have to reweight Loudoun vacancy rate because it is a rate*/
data COGSunits;
merge COGSareaunits_2000 COGSvacantunits_2000 COGSareaunits_2010 COGSvacantunits_2010 COGSareaunits_2017 COGSvacantunits_2017;
by Jurisdiction structuretype bedrooms Tenure _TYPE_;
vacancyrate2010= vacantunit_2010/(vacantunit_2010+ unit_2010);
vacancyrate2017= vacantunit_2017/(vacantunit_2017+ unit_2017);
vacancyrate2000= vacantunit_2000/(vacantunit_2000+ unit_2000);
format structuretype structure. Tenure tenure.;
run;

proc export data = COGSunits
   outfile="&_dcdata_default_path\RegHsg\Prog\Housing and dwelling characteristics.csv"
   dbms=csv
   replace;
run;

%macro renterburden(year);
data rentercostburden_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255") and pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
set Ipums.ACS_&year._dc Ipums.ACS_&year._md Ipums.ACS_&year._va;

	%assign_jurisdiction; 

	if gq in (1,2);
	if pernum = 1;

    if ownershpd in (21, 22) then do; /*renter*/
		if rentgrs*12>= HHINCOME*0.3 then rentburdened_&year.=1;
	    else if HHIncome~=. then rentburdened_&year.=0;
	end;

    if ownershpd in ( 12,13 ) then do; /*owner*/
		if owncost*12>= HHINCOME*0.3 then ownerburdened_&year.=1;
	    else if HHIncome~=. then ownerburdened_&year.=0;
	end;

	tothh_&year. = 1;
run;

proc sort data=rentercostburden_&year.;
by Jurisdiction;
run;

proc summary data = rentercostburden_&year. (where=(ownershpd in (21, 22)));
	class Jurisdiction;
	var rentburdened_&year. tothh_&year.;
	weight hhwt;
	output out = rentburdened_&year. sum=;
run;

proc summary data = rentercostburden_&year.  (where=(ownershpd in (12, 13)));
	class Jurisdiction;
	var ownerburdened_&year. tothh_&year.;
	weight hhwt;
	output out = ownerburdened_&year.  sum=;
run;

%mend renterburden; 

%renterburden(2017);

data rentercostburden_2010 (where=(upuma in ("1100101",
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
"5100200" ) and pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
set Ipums.ACS_2010_dc Ipums.ACS_2010_md Ipums.ACS_2010_va;

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

	if gq in (1,2);
	if pernum = 1;

    if ownershpd in (21, 22) then do; /*renter*/
		if rentgrs*12>= HHINCOME*0.3 then rentburdened_2010=1;
	    else if HHIncome~=. then rentburdened_2010=0;
	end;

    if ownershpd in ( 12,13 ) then do; /*owner*/
		if owncost*12>= HHINCOME*0.3 then ownerburdened_2010=1;
	    else if HHIncome~=. then ownerburdened_2010=0;
	end;

	tothh_2010 = 1;
run;

proc sort data=rentercostburden_2010;
by Jurisdiction;
run;

proc summary data = rentercostburden_2010 (where=(ownershpd in (21, 22)));
	class Jurisdiction;
	var rentburdened_2010 tothh_2010;
	weight hhwt;
	output out = rentburdened_2010 sum=;
run;

proc summary data = rentercostburden_2010  (where=(ownershpd in (12, 13)));
	class Jurisdiction;
	var ownerburdened_2010 tothh_2010;
	weight hhwt;
	output out = ownerburdened_2010  sum=;
run;

data rentercostburden_2000 (where=(upuma in ("1100101",
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
"5100200" ) and pernum=1 and gq in (1,2) and ownershd in ( 12,13,21,22 )));
set Ipums.Ipums_2000_dc Ipums.Ipums_2000_md Ipums.Ipums_2000_va;

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

	if gq in (1,2);
	if pernum = 1;

	tothh_2000 = 1;

run;

proc sort data = rentercostburden_2000; by serial; run;

libname rawnew "L:\Libraries\IPUMS\Raw\usa_00027.sas7bdat\";


data usa_00027;
set rawnew.usa_00027;
if pernum=1;
run;

proc sort data = usa_00027; by serial; run;

data rentercostburden_2000_new;
	merge rentercostburden_2000(in=a) usa_00027 (in=b) ;
	by serial;
	if a and b;

if owncost=99999 then owncost=.;

	if ownershd in (21, 22) then do; /*renter*/
		if rentgrs*12>= HHINCOME*0.3 then rentburdened_2000=1;
	    else if HHIncome~=. then rentburdened_2000=0;
	end;

    if ownershd in ( 12,13 ) then do; /*owner*/
		if owncost*12>= HHINCOME*0.3 then ownerburdened_2000=1;
	    else if HHIncome~=. then ownerburdened_2000=0;
	end;
run;

proc sort data=rentercostburden_2000_new;
by Jurisdiction;
run;

proc summary data = rentercostburden_2000_new (where=(ownershd in (21, 22)));
	class Jurisdiction;
	var rentburdened_2000 tothh_2000;
	weight hhwt;
	output out = rentburdened_2000 sum=;
run;

proc summary data = rentercostburden_2000_new  (where=(ownershd in (12, 13)));
	class Jurisdiction;
	var ownerburdened_2000 tothh_2000;
	weight hhwt;
	output out = ownerburdened_2000 sum=;
run;

/*use HH count from NCDB and PUMA to weight the Loudoun number:

NCDB: hh00 59921
      hh10 104583
IPUMS hh00 97263
      hh10 145906
*/

data allhousingburden;
merge rentburdened_2010 ownerburdened_2010 rentburdened_2017 ownerburdened_2017 rentburdened_2000 ownerburdened_2000;
by Jurisdiction;
format Jurisdiction Jurisdiction.;
if Jurisdiction=8 then rentburdened_2010= rentburdened_2010*(104583/145906);
if Jurisdiction=8 then tothh_2010= tothh_2010*(104583/145906);
if Jurisdiction=8 then ownerburdened_2010= ownerburdened_2010*(104583/145906);
if Jurisdiction=8 then rentburdened_2000= rentburdened_2000*(59921/97263);
if Jurisdiction=8 then ownerburdened_2000= ownerburdened_2000*(59921/97263);
if Jurisdiction=8 then tothh_2000= tothh_2000*(59921/97263);
run;

data allhousingburden;
set allhousingburden;
if _TYPE_=0 then Jurisdiction=11;
format Jurisdiction Jurisdiction.;
Run;

proc export data = allhousingburden
   outfile="&_dcdata_default_path\RegHsg\Prog\all_housing_burden.csv"
   dbms=csv
   replace;
run;

/*building permit by building type*/

data permits (where= (ucounty in("11001", "24017","24021","24031","24033","51013","51059","51107","51153","51510","51600","51610","51683","51685" )));
set Census.Cen_building_permits_dc_md_va_wv;
keep year ucounty units1_building units2_building units34_building units5p_building Jurisdiction;
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
format Jurisdiction Jurisdiction. ;
run;

proc sort data=permits;
by year Jurisdiction;
run;

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

proc transpose data=permits2 out=permits_allyear_trans ;
by Jurisdiction;
var units1_building units2_building units34_building units5p_building ;
id year;
run;

proc export data = permits_allyear_trans
   outfile="&_dcdata_default_path\RegHsg\Prog\permits_allyear.csv"
   dbms=csv
   replace;
run;


