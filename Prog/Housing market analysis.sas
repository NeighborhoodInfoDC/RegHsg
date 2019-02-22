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

data COGSunits;
merge COGSareaunits_2010 COGSvacantunits_2010 COGSareaunits_2017 COGSvacantunits_2017;
by Jurisdiction structuretype bedrooms Tenure;
vacancyrate2010= vacantunit_2010/(vacantunit_2010+ unit_2010);
vacancyrate2017= vacantunit_2017/(vacantunit_2017+ unit_2017);
run;

