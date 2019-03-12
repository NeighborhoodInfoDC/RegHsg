/**************************************************************************
 Program:  Subsidized_units_counts.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   W. Oliver
 Created:  02/7/19
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
download for whole metro area or states if easier. 
We would like to be able to understand where properties are located, 
how many units are subsidized (at what level if known), 
subsidy programs involved, and any expiration dates for the subsidies.

We want all jurisdictions in the COG region:

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
%DCData_lib( RegHsg )
** Year range for preservation targets **;
%let Startyr = 2015;
%let Endyr = 2999;  /** No upper year limit **/
*Create property and unit counts for individual programs**;

proc format;
	value COG
    1= "COG county"
    0="Non COG county";

run;
proc format;
	value ActiveUnits
    1= "Active subsidies"
    0="No active subsidies";
	run;
proc format;
	value ProgCat
	1= "Public housing"
	2= "Public housing and other subsidies"
	3= "Section 8 only"
	4= "Section 8 and HUD mortgage (FHA or S236) only"
	5= "Section 8 and other subsidy combinations"
	6= "LIHTC only"
	7= "LIHTC and other subsidies"
	8= "HOME only"
	9= "RHS only"
	10= "S202/811 only"
	11= "HUD insured mortgage only"
	12= "All other subsidy combinations";

run;
*** Create summary tables ***;

proc format;
  value yearrng
    2015-2020 = '2015 - 2020'
    2021-2025 = '2021 - 2025'
    2026-2030 = '2026 - 2030'
    2031-2035 = '2031 - 2035'
	2036-2040 = '2036 - 2040'
	2041-2045 = '2041 - 2045'
	2046-2050 = '2046 - 2050'
	2051-2055 = '2051 - 2055'
	2056-high = '2056 or higher';
run;
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


data Work.Allassistedunits;
	set RegHsg.Natlpres_activeandinc_prop;
	if CountyCode in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600", "51610", "51683", "51685") then COGregion =1;
  	else COGregion=0;
  	format COGregion COG. ;
	ucounty = CountyCode;
	%ucounty_jurisdiction;
	s8_all_assistedunits=min(sum(s8_1_AssistedUnits, s8_2_AssistedUnits,0),TotalUnits);
	s202_all_assistedunits=min(sum(s202_1_AssistedUnits, s202_2_AssistedUnits,0),TotalUnits);
	s236_all_assistedunits=min(sum(s236_1_AssistedUnits, s236_2_AssistedUnits,0),TotalUnits);
	FHA_all_assistedunits=min(sum(FHA_1_AssistedUnits, FHA_2_AssistedUnits,0),TotalUnits);
	LIHTC_all_assistedunits=min(sum(LIHTC_1_AssistedUnits,LIHTC_2_AssistedUnits,0),TotalUnits);
	rhs515_all_assistedunits=min(sum(RHS515_1_AssistedUnits,RHS515_2_AssistedUnits,0),TotalUnits);
	rhs538_all_assistedunits=min(sum(RHS538_1_AssistedUnits,RHS538_2_AssistedUnits,0),TotalUnits);
	HOME_all_assistedunits=min(sum(HOME_1_AssistedUnits, HOME_2_AssistedUnits,0),TotalUnits);
	PH_all_assistedunits=min(sum(PH_1_AssistedUnits, PH_2_AssistedUnits,0),TotalUnits);
	State_all_assistedunits=min(sum(State_1_AssistedUnits, State_2_AssistedUnits,0),TotalUnits);
	drop s8_1_AssistedUnits s8_2_AssistedUnits s202_1_assistedunits s202_2_assistedunits
	s236_1_AssistedUnits s236_2_AssistedUnits FHA_1_AssistedUnits FHA_2_AssistedUnits
	LIHTC_1_AssistedUnits LIHTC_2_AssistedUnits RHS515_1_AssistedUnits RHS515_2_AssistedUnits
	RHS538_1_AssistedUnits RHS538_2_AssistedUnits HOME_1_AssistedUnits HOME_2_AssistedUnits
	PH_1_AssistedUnits PH_2_AssistedUnits State_1_AssistedUnits State_2_AssistedUnits;

	if s8_all_assistedunits > 0 
	then s8_activeunits = 1;
	else s8_activeunits = 0;
	
	if s202_all_assistedunits > 0
	then s202_activeunits = 1;
	else s202_activeunits = 0;

	if s236_all_assistedunits > 0
	then s236_activeunits = 1;
	else s236_activeunits = 0;

	if FHA_all_assistedunits > 0
	then FHA_activeunits = 1;
	else FHA_activeunits = 0;

	if LIHTC_all_assistedunits > 0
	then LIHTC_activeunits = 1;
	else LIHTC_activeunits = 0;

	if rhs515_all_assistedunits > 0
	then rhs515_activeunits = 1;
	else rhs515_activeunits = 0;

	if rhs538_all_assistedunits > 0
	then rhs538_activeunits = 1;
	else rhs538_activeunits = 0;

	if HOME_all_assistedunits > 0
	then HOME_activeunits = 1;
	else HOME_activeunits = 0;

	if PH_all_assistedunits > 0
	then PH_activeunits = 1;
	else PH_activeunits = 0;

	if State_all_assistedunits > 0
	then State_activeunits = 1;
	else State_activeunits = 0;

	format State_activeunits PH_activeunits HOME_activeunits rhs538_activeunits rhs515_activeunits
	LIHTC_activeunits FHA_activeunits s236_activeunits s202_activeunits s8_activeunits ActiveUnits.;
run;

** Check assisted unit counts and flags **;

proc means data=Work.Allassistedunits n sum mean min max;
run;


data Work.SubsidyCategories;
	set Work.Allassistedunits;

	if PH_activeunits  and not( fha_activeunits or home_activeunits or 
	lihtc_activeunits or rhs515_activeunits or rhs538_activeunits or 
	s202_activeunits or s236_activeunits ) 
	then ProgCat = 1;

	else if PH_activeunits then ProgCat = 2;

	else if s8_activeunits and not( fha_activeunits or home_activeunits or 
	lihtc_activeunits or rhs515_activeunits or rhs538_activeunits or 
	s202_activeunits or s236_activeunits ) 
	then ProgCat = 3;

	else if s8_activeunits and ( fha_activeunits or s236_activeunits ) and 
	not( home_activeunits or lihtc_activeunits or rhs515_activeunits or 
	rhs538_activeunits or s202_activeunits ) 
	then ProgCat = 4;

	else if s8_activeunits then ProgCat = 5;

	else if lihtc_activeunits and not( fha_activeunits or home_activeunits or 
	rhs515_activeunits or rhs538_activeunits or s202_activeunits or 
	s236_activeunits ) 
	then ProgCat = 6;

	else if lihtc_activeunits then ProgCat = 7;

	else if home_activeunits and not ( fha_activeunits or s8_activeunits or 
	rhs515_activeunits or rhs538_activeunits or s202_activeunits or 
	s236_activeunits ) 
	then ProgCat = 8;

	
   	else if (rhs515_activeunits or rhs538_activeunits) and not (fha_activeunits or s8_activeunits or 
	home_activeunits or s202_activeunits or s236_activeunits ) 
	then ProgCat = 9;

	else if s202_activeunits and not( fha_activeunits or s8_activeunits or 
	rhs515_activeunits or rhs538_activeunits or home_activeunits or 
	s236_activeunits ) 
	then ProgCat=10;

	else if (fha_activeunits or s236_activeunits) and not (home_activeunits or lihtc_activeunits or rhs515_activeunits or 
	rhs538_activeunits or s202_activeunits or s8_activeunits)
	then ProgCat=11;

	else ProgCat =12;


	format ProgCat ProgCat.;

	run;

** Check project category coding **;

proc sort data=Work.SubsidyCategories;
  by ProgCat;
run;

proc freq data=Work.SubsidyCategories;
  by ProgCat;
  tables ph_activeunits * s8_activeunits * lihtc_activeunits * 
    home_activeunits * rhs515_activeunits * s202_activeunits * s236_activeunits * fha_activeunits 
    / list missing nocum nopercent;
  format 
    ProgCat ProgCat. 
    ph_activeunits s8_activeunits lihtc_activeunits home_activeunits 
    rhs515_activeunits s202_activeunits s236_activeunits fha_activeunits ;
run;


data Work.SubsidyExpirationDates;

  set Work.SubsidyCategories;

  min_assistedunits = max( s8_all_assistedunits, s202_all_assistedunits, s236_all_assistedunits,FHA_all_assistedunits,
	LIHTC_all_assistedunits,rhs515_all_assistedunits,rhs538_all_assistedunits,HOME_all_assistedunits ,PH_all_assistedunits,0);
	max_assistedunits = min( sum( s8_all_assistedunits, s202_all_assistedunits,s236_all_assistedunits,FHA_all_assistedunits,
	LIHTC_all_assistedunits,rhs515_all_assistedunits,rhs538_all_assistedunits,HOME_all_assistedunits ,PH_all_assistedunits,0 ), TotalUnits );
	mid_assistedunits = min( round( mean( min_assistedunits, max_assistedunits ), 1 ), max_assistedunits );

  if mid_assistedunits ~= max_assistedunits then moe_assistedunits = max_assistedunits - mid_assistedunits;

  earliest_expirationdate = min(S8_1_EndDate,LIHTC_1_EndDate,S8_2_EndDate,S202_1_EndDate,S202_2_EndDate,S236_1_EndDate,S236_2_EndDate,
	LIHTC_2_EndDate,RHS515_1_EndDate,RHS515_2_EndDate,RHS538_1_EndDate,RHS538_2_EndDate,HOME_1_EndDate,HOME_2_EndDate,
	FHA_1_EndDate,FHA_2_EndDate,PH_1_EndDate,PH_2_EndDate);

  latest_expirationdate = max(S8_1_EndDate,LIHTC_1_EndDate,S8_2_EndDate,S202_1_EndDate,S202_2_EndDate,S236_1_EndDate,S236_2_EndDate,
	LIHTC_2_EndDate,RHS515_1_EndDate,RHS515_2_EndDate,RHS538_1_EndDate,RHS538_2_EndDate,HOME_1_EndDate,HOME_2_EndDate,
	FHA_1_EndDate,FHA_2_EndDate,PH_1_EndDate,PH_2_EndDate);

	format latest_expirationdate MMDDYY10.;
	format earliest_expirationdate MMDDYY10.;

  if LIHTC_1_enddate > 0 then LIHTC_1_15date = intnx( 'year', LIHTC_1_enddate, -15, 'same' );
  if LIHTC_2_enddate > 0 then LIHTC_2_15date = intnx( 'year', LIHTC_2_enddate, -15, 'same' );

  format LIHTC_1_15date MMDDYY10.;
  format LIHTC_2_15date MMDDYY10.;

  if &Startyr <= year( S8_1_enddate ) <= &Endyr then s8_endyr = year( S8_1_enddate );
  if &Startyr <= year( S8_2_enddate ) <= &Endyr then s8_endyr = min( year( S8_2_enddate ), s8_endyr );

  if &Startyr <= year( S202_1_enddate ) <= &Endyr then s202_endyr = year( S202_1_enddate );
  if &Startyr <= year( S202_2_enddate ) <= &Endyr then s202_endyr = min( year( S202_2_enddate ), s202_endyr );

  if &Startyr <= year( S236_1_enddate ) <= &Endyr then s236_endyr = year( S236_1_enddate );
  if &Startyr <= year( S236_2_enddate ) <= &Endyr then s236_endyr = min( year( S236_2_enddate ), s236_endyr );

  if &Startyr <= year( FHA_1_enddate ) <= &Endyr then FHA_endyr = year( FHA_1_enddate );
  if &Startyr <= year( FHA_2_enddate ) <= &Endyr then FHA_endyr = min( year( FHA_2_enddate ), FHA_endyr );
  
  if &Startyr <= year( LIHTC_1_enddate ) <= &Endyr then LIHTC_endyr = year( LIHTC_1_enddate );
  if &Startyr <= year( LIHTC_2_enddate ) <= &Endyr then LIHTC_endyr = min( year( LIHTC_2_enddate ), LIHTC_endyr );
  if &Startyr <= year( LIHTC_1_15date ) <= &Endyr then LIHTC_15yr = year( LIHTC_1_15date );
  if &Startyr <= year( LIHTC_2_15date ) <= &Endyr then LIHTC_15yr = min( year( LIHTC_2_15date ), LIHTC_15yr );

  if &Startyr <= year( RHS515_1_enddate ) <= &Endyr then rhs515_endyr = year( rhs515_1_enddate );
  if &Startyr <= year( RHS515_2_enddate ) <= &Endyr then rhs515_endyr = min( year( rhs515_2_enddate ), rhs515_endyr );

  if &Startyr <= year( RHS538_1_enddate ) <= &Endyr then rhs538_endyr = year( rhs538_1_enddate );
  if &Startyr <= year( RHS538_2_enddate ) <= &Endyr then rhs538_endyr = min( year( rhs538_2_enddate ), rhs538_endyr );

  if &Startyr <= year( HOME_1_enddate ) <= &Endyr then HOME_endyr = year( HOME_1_enddate );
  if &Startyr <= year( HOME_2_enddate ) <= &Endyr then HOME_endyr = min( year( HOME_2_enddate ), HOME_endyr );

  if &Startyr <= year( PH_1_enddate ) <= &Endyr then PH_endyr = year( PH_1_enddate );
  if &Startyr <= year( PH_2_enddate ) <= &Endyr then PH_endyr = min( year( PH_2_enddate ), PH_endyr );

  earliest_expirationdate15 = min(s8_endyr,s202_endyr,s236_endyr,FHA_endyr,LIHTC_endyr,LIHTC_15yr,rhs515_endyr,rhs538_endyr,
	HOME_endyr,PH_endyr);

  latest_expirationdate15 = max(s8_endyr,s202_endyr,s236_endyr,FHA_endyr,LIHTC_endyr,LIHTC_15yr,rhs515_endyr,rhs538_endyr,
	HOME_endyr,PH_endyr);
 

label
  min_assistedunits = 'Minimum possible assisted units in project'
  max_assistedunits = 'Maximum possible assisted units in project'
  mid_assistedunits = 'Midpoint of project assisted unit estimate in project'
  moe_assistedunits = 'Margin of error for assisted unit estimate in project'
  earliest_expirationdate = 'Earliest expiration date for property'
  latest_expirationdate= 'Latest expiration date for property'
  earliest_expirationdate15= 'Earliest expiration date between 2015 and 2035 for property'
  latest_expirationdate15= 'Latest expiration date between 2015 and 2035 for property';


  run;

*Create construction dates for affordable housing;

data Work.ConstructionDates;
  set Work.SubsidyExpirationDates;
  format LatestConstructionDate MMDDYY10.;
if ProgCat in (1,2) then PHConstructionDate=LatestConstructionDate;
If 1930 <= year (PHConstructionDate) <= 1950 then timecount = '1930-1950';
else if 1951 <=  year (PHConstructionDate) <= 1970 then timecount='1951-1970';
else if 1971 <= year (PHConstructionDate) <= 1990 then timecount='1971-1990';
else if year (PHConstructionDate) >= 1991 then timecount = '1991-2019';
format PHConstructionDate MMDDYY10.;
run;


** Review results of assisted unit and expiration date calculations **;

proc sort data=Work.ConstructionDates;
  by ProgCat;
run;

proc means data=Work.ConstructionDates n mean min max;
  by ProgCat;
  var min_assistedunits max_assistedunits mid_assistedunits moe_assistedunits 
      earliest_expirationdate latest_expirationdate;
  format ProgCat ProgCat.;
run;

options missing=' ';

ods csvall  body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_unique.csv";

title3 "Project and assisted unit unique counts";

proc tabulate data=Work.ConstructionDates  format=comma10. noseps missing;
  where COGRegion=1;
  class ProgCat / preloadfmt order=data;
  var mid_assistedunits moe_assistedunits;
  table
    /** Rows **/
    all='Total' ProgCat=' ',
    /** Columns **/
    n='Projects'
    sum='Assisted Units' * ( mid_assistedunits='Est.'  moe_assistedunits='+/-' )
    ;
  format ProgCat ProgCat.;
run;

ods csvall close;

ods csvall  body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_jurisdiction.csv";

title3 "Projects and assisted units breakdown by jurisdiction";


proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(jurisdiction);
  class ProgCat / preloadfmt order=data;
  class jurisdiction;
  var mid_assistedunits moe_assistedunits;
  table
    /** Rows **/
    all='Total' ProgCat=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units By Jurisdiction' * (  all='Total' jurisdiction=' ' ) 
      * (  mid_assistedunits='Est.' moe_assistedunits='+/-' )
    ;
  format ProgCat ProgCat. jurisdiction jurisdiction.;
run;

ods csvall close;

ods csvall  body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_expire.csv";

title3 "Projects and assisted units with expiring subsidies";
footnote1 "LIHTC expiration includes 15-year compliance and 30-year subsidy end dates.";

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(earliest_expirationdate15);
  class ProgCat / preloadfmt order=data;
  class earliest_expirationdate15;
  var mid_assistedunits moe_assistedunits;
  table
    /** Rows **/
    all='Total' ProgCat=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units By Subsidy Expiration Year' * (  all='Total' earliest_expirationdate15=' ' ) 
      * (  mid_assistedunits='Est.' moe_assistedunits='+/-' )
    ;
  format ProgCat ProgCat. earliest_expirationdate15 yearrng.;
run;

ods csvall close;

/*Section 8*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_s8.csv";

title3 "Section 8 projects and assisted units with expiring subsidies";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(s8_endyr);
  class s8_endyr;
  var s8_all_assistedunits;
  table 
    /** Rows **/
    all='Total' s8_endyr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * s8_all_assistedunits=' ' 
    ;
  format s8_endyr yearrng.;
run;

ods csvall close;

/*S202*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_s202.csv";

title3 "Section 202 projects and assisted units with expiring subsidies";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(s202_endyr);
  class s202_endyr;
  var s202_all_assistedunits;
  table 
    /** Rows **/
    all='Total' s202_endyr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * s202_all_assistedunits=' ' 
    ;
  format s202_endyr yearrng.;
run;

ods csvall close;

/*S236*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_s236.csv";

title3 "Section 236 projects and assisted units with expiring subsidies";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(s236_endyr);
  class s236_endyr;
  var s236_all_assistedunits;
  table 
    /** Rows **/
    all='Total' s236_endyr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * s236_all_assistedunits=' ' 
    ;
  format s236_endyr yearrng.;
run;

ods csvall close;

/*FHA*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_FHA.csv";

title3 "FHA projects and assisted units with expiring subsidies";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(FHA_endyr);
  class FHA_endyr;
  var FHA_all_assistedunits;
  table 
    /** Rows **/
    all='Total' FHA_endyr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * FHA_all_assistedunits=' ' 
    ;
  format FHA_endyr yearrng.;
run;

ods csvall close;

/*LIHTC*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_LIHTC.csv";

title3 "LIHTC projects and assisted units with expiring subsidies";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(LIHTC_endyr);
  class LIHTC_endyr;
  var LIHTC_all_assistedunits;
  table 
    /** Rows **/
    all='Total' LIHTC_endyr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * LIHTC_all_assistedunits=' ' 
    ;
  format LIHTC_endyr yearrng.;
run;

ods csvall close;

/*LIHTC-15year*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_LIHTC15yr.csv";

title3 "LIHTC projects and assisted units with expiring subsidies, 15 year dates";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(LIHTC_15yr);
  class LIHTC_15yr;
  var LIHTC_all_assistedunits;
  table 
    /** Rows **/
    all='Total' LIHTC_15yr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * LIHTC_all_assistedunits=' ' 
    ;
  format LIHTC_15yr yearrng.;
run;

ods csvall close;

/*RHS515*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_rhs515.csv";

title3 "RHS 515 projects and assisted units with expiring subsidies";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(RHS515_endyr);
  class RHS515_endyr;
  var RHS515_all_assistedunits;
  table 
    /** Rows **/
    all='Total' RHS515_endyr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * RHS515_all_assistedunits=' ' 
    ;
  format RHS515_endyr yearrng.;
run;

ods csvall close;

/*RHS538*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_rhs538.csv";

title3 "RHS 538 projects and assisted units with expiring subsidies";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(RHS538_endyr);
  class RHS538_endyr;
  var RHS538_all_assistedunits;
  table 
    /** Rows **/
    all='Total' RHS538_endyr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * RHS538_all_assistedunits=' ' 
    ;
  format RHS538_endyr yearrng.;
run;

ods csvall close;

/*HOME*/
ods csvall body="&_dcdata_default_path\RegHsg\Prog\Subsidized_unit_counts_HOME.csv";

title3 "HOME projects and assisted units with expiring subsidies";
footnote1;

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(HOME_endyr);
  class HOME_endyr;
  var HOME_all_assistedunits;
  table 
    /** Rows **/
    all='Total' HOME_endyr=' ',
    /** Columns **/
    n='Projects'    
    sum='Assisted Units' * HOME_all_assistedunits=' ' 
    ;
  format HOME_endyr yearrng.;
run;

ods csvall close;

/*Public Housing*/
ods csvall  body="&_dcdata_default_path\RegHsg\Prog\PH_unit_counts.csv";

title3 "Public housing projects and assisted units with latest construction dates";

proc tabulate data=Work.ConstructionDates format=comma10. noseps missing;
  where COGRegion=1 and not missing(PHConstructionDate);
  class ProgCat / preloadfmt order=data;
  class timecount;
  var mid_assistedunits moe_assistedunits;
  table
    /** Rows **/
    all='Total' ProgCat=' ',
    /** Columns **/
    n='Projects'    
    sum='Public housing latest construction dates' * ( all= 'Total' timecount=' ' ) 
      * (  mid_assistedunits='Est.' moe_assistedunits='+/-' )
    ;
  format ProgCat ProgCat. ;
run;

ods csvall close;
