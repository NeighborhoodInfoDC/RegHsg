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

/*Housing units*/
%macro COGunits(year);
data COGSvacant_&year.(where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255") and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
set Ipums.Acs_&year._vacant_dc Ipums.Acs_&year._vacant_md Ipums.Acs_&year._vacant_va ;
	%assign_jurisdiction; 
if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/

if ownershpd in (21, 22) then Tenure = 1; /*renter*/
if ownershpd in ( 12,13 ) then Tenure = 2; /*owner*/
run;

proc summary data= COGSvacant_&year.;
class Jurisdiction structuretype bedrooms Tenure;
var vacantunit_&year.;
output out= COGSvacantunits_&year. sum=;
run;

proc sort data= COGSvacant_&year.;
by Jurisdiction structuretype bedrooms Tenure;
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
output out=COGSareaunits_&year. sum=;
run;

proc sort data= COGSarea_&year.;
by Jurisdiction structuretype bedrooms Tenure;
run;

%mend COGunits; 

%COGunits(2010);
%COGunits(2017);

data COGSvacant_2000(where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255") and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
set Ipums.Acs_2000_vacant_dc Ipums.Acs_2000_vacant_md Ipums.Acs_2000_vacant_va ;
	%assign_jurisdiction; 
if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/

if ownershd in (21, 22) then Tenure = 1; /*renter*/
if ownershd in ( 12,13 ) then Tenure = 2; /*owner*/
run;

proc summary data= COGSvacant_2000;
class Jurisdiction structuretype bedrooms Tenure;
var vacantunit_2000;
output out= COGSvacantunits_2000 sum=;
run;

proc sort data= COGSvacant_2000;
by Jurisdiction structuretype bedrooms Tenure;
run;

data COGSarea_2000(where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255") and pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
set Ipums.Acs_2000_dc Ipums.Acs_2000_md Ipums.Acs_2000_va;

	%assign_jurisdiction; 

if UNITSSTR in (03, 04) then structuretype=1; /*single family*/
if UNITSSTR =05 then structuretype=2; /*duplex*/
if UNITSSTR in (06, 07) then structuretype=3; /*small multifamily*/
if UNITSSTR in (08, 09. 10)then structuretype=4; /*large multifamily*/
if ownershd in (21, 22) then Tenure = 1; /*renter*/
if ownershd in ( 12,13 ) then Tenure = 2; /*owner*/
unit_2000=1;
run;

proc summary data= COGSarea_2000;
class Jurisdiction structuretype bedrooms Tenure;
var unit_2000;
output out=COGSareaunits_2000 sum=;
run;

proc sort data= COGSarea_2000;
by Jurisdiction structuretype bedrooms Tenure;
run;

data COGSunits;
merge COGSareaunits_2000 COGSvacantunits_2000 COGSareaunits_2010 COGSvacantunits_2010 COGSareaunits_2017 COGSvacantunits_2017;
by Jurisdiction structuretype bedrooms Tenure;
vacancyrate2010= vacantunit_2010/(vacantunit_2010+ unit_2010);
vacancyrate2017= vacantunit_2017/(vacantunit_2017+ unit_2017);
vacancyrate2000= vacantunit_2000/(vacantunit_2000+ unit_2000);
run;

%macro renterburden(year);
data rentercostburden_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255") and pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;

	%assign_jurisdiction; 

	if gq in (1,2);
	if pernum = 1;

    if ownershpd in (21, 22) then do; /*renter*/
		if rentgrs*12>= HHINCOME*0.3 then rentburdened=1;
	    else if HHIncome~=. then rentburdened=0;
	end;

    if ownershpd in ( 12,13 ) then do; /*owner*/
		if owncost*12>= HHINCOME*0.3 then ownerburdened=1;
	    else if HHIncome~=. then ownerburdened=0;
	end;

	tothh_&year. = 1;
run;

proc sort data=rentercostburden_&year.;
by Jurisdiction;
run;

proc summary data = rentercostburden_&year. (where=(ownershp = 2));
	class Jurisdiction;
	var rentburdened tothh_&year.;
	weight hhwt;
	output out = rentburdened_2017 sum=;
run;

proc summary data = rentercostburden_&year.  (where=(ownershp = 1));
	class Jurisdiction;
	var ownerburdened tothh_&year.;
	weight hhwt;
	output out = ownerburdened_2017  sum=;
run;

%mend renterburden; 

%renterburden(2010);
%renterburden(2017);

/*building permit by building type*/

proc format;
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
run;

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
by year Jurisdiction ;
var units1_building units2_building units34_building units5p_building;
output out= permits_allyear sum=;
run;

proc export data = permits_allyear
   outfile="&_dcdata_default_path\RegHsg\Prog\permits_allyear.csv"
   dbms=csv
   replace;
run;


