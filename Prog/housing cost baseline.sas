
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RegHsg)
%DCData_lib( Ipums)


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

data Housing_cost_baseline;

  set COGSarea
        (keep=year serial pernum hhwt hhincome numprec bedrooms gq ownershp owncost ownershpd rentgrs valueh Jurisdiction
         where=(pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));
  
  %Hud_inc_RegHsg( hhinc=hhincome, hhsize=numprec )
  
  label
    hud_inc = 'HUD income category for household';

** Calculate cost ratio **;

    if ownershp = 2 then do;
		Costratio= (rentgrs*12)/hhincome;
	end;

    if ownershp = 1 then do;
		Costratio= (owncost*12)/hhincome;
    end;
	tothh = 1;

format hud_inc hudinc. Jurisdiction Jurisdiction. ownershp tenure.;

run;

proc univariate data= Housing_cost_baseline;
var Costratio;
weight hhwt;
output out=costall;
run;


proc univariate data= Housing_cost_baseline (where=(tenure=1));
var Costratio;
weight hhwt;
output out=costrenter;
run;


proc univariate data= Housing_cost_baseline (where=(tenure=2));
var Costratio;
weight hhwt;
output out=costowner;
run;
























data Housing_needs_baseline_avail;

  set COGSarea
        (keep=year serial pernum hhwt hhincome numprec bedrooms gq ownershp ownershpd rentgrs valueh Jurisdiction
         where=(pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));

  if ownershpd in (21, 22) then do;
    
    ****** Rental units ******;
    
    Tenure = 1;

    Max_income = ( rentgrs * 12 ) / 0.30;

	Costratio= hhincome/( rentgrs * 12 );
    
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

	Costratio= hhincome/(12 * total_month);

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

proc summary data = Housing_needs_baseline_avail;
	class hud_inc Tenure availability Jurisdiction;
	var Total ;
	weight hhwt;
	output out = Housing_needs_baseline_units  sum=;
	format hud_inc hud_inc. Tenure tenure. availability availability. Jurisdiction Jurisdiction.;
run;

proc export data = Housing_needs_baseline_units 
   outfile="&_dcdata_default_path\RegHsg\Prog\Units_affordability_avail.csv"
   dbms=csv
   replace;
run;
