/**************************************************************************
 Program:  Gentrification and displacement risk.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su 
 Created:  12/19/14
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Calculate risk of gentrification and displacement for the COGS region: methodology by https://www.portlandoregon.gov/bps/article/454027
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

change in characteristics that make resisting displacement more difficult(binary): % renters, %people of color, %college attainment, %lower income

change in characteristics that reflect gentrification (low median high): median home value relative to citywide median, appreciation rates for owner-occupoed units

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RegHsg)
%DCData_lib( Ipums)
%DCData_lib( ACS)
%DCData_lib( NCDB)

%let _years=2012_16;

** Calculate average ratio of gross rent to contract rent for occupied units **;
data demographics (where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
set ACS.Acs_2012_16_dc_sum_tr_tr10 ACS.Acs_2012_16_md_sum_tr_tr10 ACS.Acs_2012_16_va_sum_tr_tr10 ACS.Acs_2012_16_wv_sum_tr_tr10;
keep geo2010 county popwithrace_&_years. popalonew_&_years. numrenteroccupiedhu_&_years. numowneroccupiedhu_&_years. pop25andoverwcollege_&_years. pop25andoveryears_&_years. aggincome_&_years.;
county= substr(geo2010,1,5);
run;

data housing16;
set NCDB.Ncdb_sum_was15_tr10;
keep geo2010 



data Ratio;

  set COGSarea
    (keep= rent rentgrs pernum gq ownershpd
     where=(pernum=1 and gq in (1,2) and ownershpd in ( 22 )));
     
  Ratio_rentgrs_rent_12_16 = rentgrs / rent;
 
run;

proc means data=Ratio;
  var  Ratio_rentgrs_rent_12_16 rentgrs rent;
run;

%let Ratio_rentgrs_rent_12_16 = 1.1512114;         %** Value copied from Proc Means output **;

data Housing_needs_baseline;

  set COGSarea
        (keep=year serial pernum hhwt hhincome numprec bedrooms gq ownershp owncost ownershpd rentgrs valueh
         where=(pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
  
  %Hud_inc_RegHsg( hhinc=hhincome, hhsize=numprec )
  
  label
    hud_inc = 'HUD income category for household';

    if ownershp = 2 then do;
		if rentgrs*12>= HHINCOME*0.3 then rentburdened=1;
	    else if HHIncome~=. then rentburdened=0;
	end;

    if ownershp = 1 then do;
		if owncost*12>= HHINCOME*0.3 then ownerburdened=1;
	    else if HHIncome~=. then ownerburdened=0;
	end;

	tothh = 1;

run;

%File_info( data=Housing_needs_baseline, freqvars=hud_inc rentburdened ownerburdened )

proc freq data=Housing_needs_baseline;
  tables ownershpd * ownerburdened * rentburdened ( hud_inc ) / list missing;
  format ownershpd vacancy ;
run;

proc format;
  value hud_inc
   .n = 'Vacant'
    1 = '0-30% AMI'
    2 = '31-50%'
    3 = '51-80%'
    4 = '81-120%'
    5 = '120-200%'
    6 = 'More than 200%';
  value tenure
    1 = 'Renter units'
    2 = 'Owner units';
run;

proc summary data = Housing_needs_baseline (where=(ownershp = 2));
	class hud_inc;
	var rentburdened tothh;
	weight hhwt;
	output out = Housing_needs_baseline_renter sum=;
run;

proc summary data = Housing_needs_baseline (where=(ownershp = 1));
	class hud_inc;
	var ownerburdened tothh;
	weight hhwt;
	output out = Housing_needs_baseline_owner  sum=;
run;

proc export data = Housing_needs_baseline_renter
   outfile="&_dcdata_default_path\RegHsg\Prog\Renter_baseline.csv"
   dbms=csv
   replace;
run;

proc export data = Housing_needs_baseline_owner
   outfile="&_dcdata_default_path\RegHsg\Prog\Owner_baseline.csv"
   dbms=csv
   replace;
run;


