/**************************************************************************
 Program:  Crosscheck wtih DC parcel base data.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  1/30/19
 Version:  SAS 9.4
 Environment:  Windows with SAS/Connect
 
 Description: use parcel ID to cross check black knight data with DC parcel base data property category
 Modifications: 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( realprop );

data falsevacantres (where=(SSL in ("0016    0071", "0016    0073", "0024    0879", "0029    0811", "0042    0820")));
set realprop.Parcel_base;
run;

data usenotspecified (where=(SSL in ("0672    0859", "0737    7000", "0737    7001", "0737    7002", "0737    7003")));
set realprop.Parcel_base;
run;

data improvedwithcommericalpermit (where=(SSL in ("0632    0835", "0701    7003", "2526    0197", "2535    7003", "2535    7005")));
set realprop.Parcel_base;
run;

data unimproved (where=(SSL in ("BD0001000899", "BD00 0100 0901", "BD00 0162 0077", "BD00 0185 0041", "BD00 0186 0039")));
set realprop.Parcel_base;
run;


data condogarage (where=(SSL in ("0014    2195", "0014    2196", "0014    2201", "0014    2206", "0014    2207")));
set realprop.Parcel_base;
run;

data mixeduse (where=(SSL in ("0028    0873", "0038    0833", "0093    0132", "0093    0147", "0096    0074")));
set realprop.Parcel_base;
run;
