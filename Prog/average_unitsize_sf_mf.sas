/**************************************************************************
 Program:  average_unitsize_sf_mf.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  2/6/19
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  tabulate sf and mf average unit size for DC MSA
 codebook: https://www.census.gov/data-tools/demo/codebook/ahs/ahsdict.html?s_appName=ahsdict&s_searchvalue=INTSTATUS
 Modifications: 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RegHsg)

/*
%include "F:\HouseFin\AHS\code\pets\Apply AHS Formats_2017.sas";
%include "F:\HouseFin\AHS\code\pets\Apply AHS 2013 Formats.sas";
libname ahs "K:\Housefin3\Monthly\AHS";
*/

data test;
set RegHsg.ahs2017m;
keep OMB13CBSA;
run;

/*the metro file actually don't have DC, see table below, so had to use the national file*/
proc freq data=test;
tables OMB13CBSA;
run;

data DCMSA;
set RegHsg.ahs2017n( where = ((INTSTATUS = '1') and (OMB13CBSA= '47900')));
if BLD= '02' or BLD= '03' then sf=1;
if BLD in ('04', '05', '06', '07', '08', '09') then mf=1;
run;

data DCMSA_2;
set DCMSA;
if UNITSIZE="1" then area=250;
else if UNITSIZE="2" then area=625;
else if UNITSIZE="3" then area=875;
else if UNITSIZE="4" then area=1250;
else if UNITSIZE="5" then area=1750;
else if UNITSIZE="6" then area=2250;
else if UNITSIZE="7" then area=2750;
else if UNITSIZE="8" then area=3500;
else if UNITSIZE="9" then area=4000;
run;

proc tabulate data = DCMSA_2 missing;
  weight WEIGHT;
  class sf;
  var area;
  table sf,
        area*(N Mean Max);
run;

proc tabulate data = DCMSA_2 missing;
  weight WEIGHT;
  class mf;
  var area;
  table mf,
        area*(N Mean Max);
run;

