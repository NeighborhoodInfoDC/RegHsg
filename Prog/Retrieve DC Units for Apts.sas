/**************************************************************************
 Program:  Retrieve DC Units for Apts.sas
 Library:  RegHsg
 Project:  Urban-Greater DC
 Author:   Leah Hendey
 Created:  3/15/19
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Use DC MAR to retrieve the number of units for apartment buildings. 

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RegHsg )
%DCData_lib( MAR )
%DCData_lib( Realprop )


*summarize from unit level to address level;
proc sort data=mar.Address_points_2018_06 out=points;
by address_id;
proc summary data=points;
by address_id;
var active_res_occupancy_count active_res_unit_count;
output out=points_sum sum=;
run;
*summarize to count unit totals;
proc summary data=points_sum;
var active_res_occupancy_count active_res_unit_count;
output out=total sum=;
run; 

*merge with ssl - address crosswalk;
proc sort data=points_sum;
by address_id;
proc sort data=mar.address_ssl_xref out=xref;
by address_id;
data address_unit_xref;
merge xref (in=a) points_sum (in=b);
by address_id;

if a; 

run; 

*summarize by parcel;
proc sort data=address_unit_xref;
by ssl;
proc summary data=address_unit_xref;
by ssl;
var active_res_occupancy_count;
output out=parcel_unit sum=;
run;

*retrieve active apartment buildings from parcel base;
data apt_only;
	set realpr_r.parcel_base (where=(ui_proptype = '13' & in_last_ownerpt=1));

	run; 

*merge apartment building parcels with unit count;
proc sort data=apt_only;
by ssl;
proc sort data=parcel_unit;
by ssl;

data apt_only_units;
merge apt_only (in=a) parcel_unit (keep = ssl active_res_occupancy_count);
by ssl;

if a; 
rename active_res_occupancy_count=numberofunits;

keep ssl active_res_occupancy_count ui_proptype;

run; 
proc means data=apt_only_units;
var numberofunits;
run; 
*export to csv;

proc export data=apt_only_units 
outfile="&_dcdata_default_path\RegHsg\Prog\dc_apt_with_units..csv"
   dbms=csv
   replace;
   run;
