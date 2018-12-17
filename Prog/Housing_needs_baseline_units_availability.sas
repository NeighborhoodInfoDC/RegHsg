/**************************************************************************
 Program:  Housing_needs_baseline_units_availability.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su adapted from P. Tatian 
 Created:  12/09/18
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Produce numbers for housing needs analysis from 2016
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


** Calculate average ratio of gross rent to contract rent for occupied units **;
data COGSvacant(where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
set Ipums.Acs_2012_16_vacant_dc Ipums.Acs_2012_16_vacant_md Ipums.Acs_2012_16_vacant_va ;

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

data COGSarea (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
set Ipums.Acs_2012_16_dc Ipums.Acs_2012_16_md Ipums.Acs_2012_16_va;

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
proc contents data=COGSarea;
run;

data Ratio;

  set COGSarea
    (keep=rent rentgrs pernum gq ownershpd Jurisdiction
     where=(pernum=1 and gq in (1,2) and ownershpd in ( 22 )));
     
  Ratio_rentgrs_rent_12_16 = rentgrs / rent;
 
run;

proc means data=Ratio;
  var  Ratio_rentgrs_rent_12_16 rentgrs rent;
run;

%let Ratio_rentgrs_rent_12_16 = 1.1512114;         %** Value copied from Proc Means output **;

data Housing_needs_baseline_avail;

  set COGSarea
        (keep=year serial pernum hhwt hhincome numprec bedrooms gq ownershp ownershpd rentgrs valueh Jurisdiction
         where=(pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));

  if ownershpd in (21, 22) then do;
    
    ****** Rental units ******;
    
    Tenure = 1;

    Max_income = ( rentgrs * 12 ) / 0.30;
    
  end;
  else if ownershpd in ( 12,13 ) then do;

    ****** Owner units ******;
    
    Tenure = 2;

    **** 
    Calculate max income for first-time homebuyers. 
    Using 3.69% as the effective mortgage rate for DC in 2016, 
    calculate monthly P & I payment using monthly mortgage rate and compounded interest calculation
    ******; 
    
    loan = .9 * valueh;
    month_mortgage= (3.79 / 12) / 100; 
    monthly_PI = loan * month_mortgage * ((1+month_mortgage)**360)/(((1+month_mortgage)**360)-1);

    ****
    Calculate PMI and taxes/insurance to add to Monthly_PI to find total monthly payment
    ******;
    
    PMI = (.007 * loan ) / 12; **typical annual PMI is .007 of loan amount;
    tax_ins = .25 * monthly_PI; **taxes assumed to be 25% of monthly PI; 
    total_month = monthly_PI + PMI + tax_ins; **Sum of monthly payment components;

    ** Calculate annual_income necessary to finance house **;
    Max_income = 12 * total_month / .28;

  end;


  if hhincome > Max_income then do;

  availability= 0;
  end;

  else if hhincome <= Max_income then do;

  availability=1;
  end;
  
  ** Determine maximum HH size based on bedrooms **;
  
  select ( bedrooms );
    when ( 1 )       /** Efficiency **/
      Max_hh_size = 1;
    when ( 2 )       /** 1 bedroom **/
      Max_hh_size = 2;
    when ( 3 )       /** 2 bedroom **/
      Max_hh_size = 3;
    when ( 4 )       /** 3 bedroom **/
      Max_hh_size = 4;
    when ( 5 )       /** 4 bedroom **/
      Max_hh_size = 5;
    when ( 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )       /** 5+ bedroom **/
      Max_hh_size = 7;
    otherwise
      do; 
        %err_put( msg="Invalid bedroom size: " serial= bedrooms= ) 
      end;
  end;
  
  %Hud_inc_RegHsg( hhinc=Max_income, hhsize=Max_hh_size )
  
  label
    Hud_inc = 'HUD income category for unit';

	total=1;

run;

%File_info( data=Housing_needs_baseline_avail, freqvars=Hud_inc Tenure )

proc freq data=Housing_needs_baseline_avail;
  tables tenure * ownershpd * availability *( hud_inc ) / list missing;
  format ownershpd vacancy ;
run;

proc format;
  value hudinc
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

  value availability
  1= 'Available'
  0= 'Not availabile';

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
    10="Alexandria";
run;

ods tagsets.excelxp file="D:\Libraries\RegHsg\Prog\Housing_needs_baseline_units_avail.xls" style=Minimal options(sheet_interval='Page' );

proc tabulate data=Housing_needs_baseline_avail format=comma12.0 noseps missing;
  class hud_inc Tenure Jurisdiction;
  var Total availability;
  weight hhwt;
  table 
    /** Pages **/
    all='All units' Tenure=' ',
    /** Rows **/
    all='Total' hud_inc=' ',
    /** Columns **/
    sum='Units' * (all='Total' hud_inc='Unit affordability') * Total=' '
    / box='HH income'
  ;
  format Hud_inc hudinc. tenure tenure.;
run;


ods tagsets.excelxp close;


proc summary data = Housing_needs_baseline_avail;
	class hud_inc Tenure availability Jurisdiction;
	var Total ;
	weight hhwt;
	output out = Housing_needs_baseline_units  sum=;
run;

proc export data = Housing_needs_baseline_units 
   outfile="&_dcdata_default_path\RegHsg\Prog\Units_affordability_avail.csv"
   dbms=csv
   replace;
run;


/*calculate vacant units*/
data Housing_needs_baseline_vacant;

  set COGSvacant(keep=year serial hhwt bedrooms gq vacancy rent valueh Jurisdiction where=(vacancy in (1,2)));

  retain Total 1;
    
    ****** Rental units ******;
 if  vacancy = 1 then do;
    Tenure = 1;
    
    		** Impute gross rent for vacant units **;
  		rentgrs = rent*&Ratio_rentgrs_rent_12_16;
  		Max_income = ( rentgrs * 12 ) / 0.30;
    
  end;


  else if vacancy = 2 then do;

    ****** Owner units ******;
    
    Tenure = 2;

    **** 
    Calculate max income for first-time homebuyers. 
    Using 3.69% as the effective mortgage rate for DC in 2016, 
    calculate monthly P & I payment using monthly mortgage rate and compounded interest calculation
    ******; 
    
    loan = .9 * valueh;
    month_mortgage= (3.79 / 12) / 100; 
    monthly_PI = loan * month_mortgage * ((1+month_mortgage)**360)/(((1+month_mortgage)**360)-1);

    ****
    Calculate PMI and taxes/insurance to add to Monthly_PI to find total monthly payment
    ******;
    
    PMI = (.007 * loan ) / 12; **typical annual PMI is .007 of loan amount;
    tax_ins = .25 * monthly_PI; **taxes assumed to be 25% of monthly PI; 
    total_month = monthly_PI + PMI + tax_ins; **Sum of monthly payment components;

    ** Calculate annual_income necessary to finance house **;
    Max_income = 12 * total_month / .28;

  end;
  
  ** Determine maximum HH size based on bedrooms **;
  
  select ( bedrooms );
    when ( 1 )       /** Efficiency **/
      Max_hh_size = 1;
    when ( 2 )       /** 1 bedroom **/
      Max_hh_size = 2;
    when ( 3 )       /** 2 bedroom **/
      Max_hh_size = 3;
    when ( 4 )       /** 3 bedroom **/
      Max_hh_size = 4;
    when ( 5 )       /** 4 bedroom **/
      Max_hh_size = 5;
    when ( 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )       /** 5+ bedroom **/
      Max_hh_size = 7;
    otherwise
      do; 
        %err_put( msg="Invalid bedroom size: " serial= bedrooms= ) 
      end;
  end;
  
  %Hud_inc_RegHsg( hhinc=Max_income, hhsize=Max_hh_size )
  
  label
    Hud_inc = 'HUD income category for unit';

run;

%File_info( data=Housing_needs_baseline_vacant, freqvars=Hud_inc Tenure )

proc freq data=Housing_needs_baseline;
  tables  vacancy * ( hud_inc ) / list missing;
  format hudinc vacancy ;
run;

proc format;
  value hudinc
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

ods tagsets.excelxp file="D:\Libraries\RegHsg\Prog\Housing_needs_baseline_units.xls" style=Minimal options(sheet_interval='Page' );

proc tabulate data=Housing_needs_baseline format=comma12.0 noseps missing;
  class hud_inc Tenure Jurisdiction;
  var Total;
  weight hhwt;
  table 
    /** Pages **/
    all='All units' Tenure=' ',
    /** Rows **/
    all='Total' hud_inc=' ',
    /** Columns **/
    sum='Units' * (all='Total' hud_inc='Unit affordability') * Total=' '
    / box='HH income'
  ;
  format Hud_inc hudinc. tenure tenure.;
run;


ods tagsets.excelxp close;


proc summary data = Housing_needs_baseline_vacant;
	class hud_inc Tenure Jurisdiction;
	var Total;
	weight hhwt;
	output out = Housing_needs_baseline_vacant  sum=;
run;

proc export data = Housing_needs_baseline_vacant
   outfile="&_dcdata_default_path\RegHsg\Prog\Units_affordability_vacant.csv"
   dbms=csv
   replace;
run;


