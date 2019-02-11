/**************************************************************************
 Program:  Housing_needs_units_targets.sas
 Library:  RegHsg
 Project:  Regional Housing Framework
 Author:   L. Hendey
 Created:  1/22/2019
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Produce numbers for housing needs and targets analysis from 2013-17
 ACS IPUMS data for the COGS region:
 DC (11001)
 Charles County(24017)
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
%DCData_lib( Ipums )

%let date=02102019; 

proc format;

  value hud_inc
   .n = 'Vacant'
    1 = '0-30% AMI'
    2 = '31-50%'
    3 = '51-80%'
    4 = '81-120%'
    5 = '120-200%'
    6 = 'More than 200%'
	;

  value tenure
    1 = 'Renter units'
    2 = 'Owner units'
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
  	;

  value rcost
	  1= "$0 to $749"
	  2= "$750 to $1,199"
	  3= "$1,200 to $1,499"
	  4= "$1,500 to $1,999"
	  5= "$2,000 to $2,499"
	  6= "More than $2,500"
  ;

  value ocost
	  1= "$0 to $1,199"
	  2= "$1,200 to $1,799"
	  3= "$1,800 to $2,499"
	  4= "$2,500 to $3,199"
	  5= "$3,200 to $4,199"
	  6= "More than $4,200"
  ;

  value acost
	  1= "$0 to $799"
	  2= "$800 to $1,299"
	  3= "$1,300 to $1,799"
	  4= "$1,800 to $2,499"
	  5= "$2,500 to $3,499"
	  6= "More than $3,500"
  ;
	
  /*format collapses 80-100% and 100-120% of AMI*/
  value inc_cat

    1 = '$32,600 and below'
    2 = '$32,600-$54,300'
    3 = '$54,300-$70,150'
    4 = '$70,150-$130,320'
	5 = '$70,150-$130,320'
    6 = '$130,320-$217,200'
    7 = 'More than $217,200'
	8 = 'Vacant'
	;
  	  
run;
%macro single_year(year);


	data COGSvacant_&year.(where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
		set Ipums.Acs_&year._vacant_dc Ipums.Acs_&year._vacant_md Ipums.Acs_&year._vacant_va ;

	%assign_jurisdiction; 

	run;

	data COGSarea_&year. (where=(upuma in ("1100101", "1100102", "1100103", "1100104", "1100105", "2401600", "2400301", "2400302","2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007", "2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107", "5101301", "5101302", "5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309", "5110701", "5110702" , "5110703", "5151244", "5151245", "5151246", "5151255")));
		set Ipums.Acs_&year._dc Ipums.Acs_&year._md Ipums.Acs_&year._va;

	%assign_jurisdiction; 

	run;


 %**create ratio for rent to rentgrs to adjust rents on vacant units**;
	 data Ratio;

		  set COGSarea_&year.
		    (keep= rent rentgrs pernum gq ownershpd Jurisdiction
		     where=(pernum=1 and gq in (1,2) and ownershpd in ( 22 )));
		     
		  Ratio_rentgrs_rent_&year. = rentgrs / rent;
		 
		run;

		proc means data=Ratio;
		  var  Ratio_rentgrs_rent_&year. rentgrs rent;
		run;
			%** Value copied from Proc Means output **;
		%if &year=2013 %then %let Ratio_rentgrs_rent_&year.= 1.1429187;
		%if &year=2014 %then %let Ratio_rentgrs_rent_&year.= 1.1600331;
		%if &year=2015 %then %let Ratio_rentgrs_rent_&year.= 1.1556884;
		%if &year=2016 %then %let Ratio_rentgrs_rent_&year.= 1.1425105;
		%if &year=2017 %then %let Ratio_rentgrs_rent_&year.= 1.1193682;

		%put Ratio_rentgrs_rent_&year.=&&Ratio_rentgrs_rent_&year.;

data Housing_needs_baseline_&year.;

  set COGSarea_&year.
        (keep=year serial pernum hhwt hhincome numprec bedrooms gq ownershp owncost ownershpd rentgrs valueh Jurisdiction
         where=(pernum=1 and gq in (1,2) and ownershpd in ( 12,13,21,22 )));

	 *adjust all incomes to 2016 $; 

	  if hhincome ~=.n or hhincome ~=9999999 then do; 
		 %dollar_convert( hhincome, hhincome_a, &year., 2016, series=CUUR0000SA0 )
	   end; 
  
	*create HUD_inc - uses 2016 limits but has categories for 120-200% and 200%+ AMI; 

		%Hud_inc_RegHsg( hhinc=hhincome_a, hhsize=numprec )
  

	/*to match categories used in projections which do not account for household size*/
		if hhincome_a in ( 9999999, .n , . ) then incomecat=.;
			else do; 
			    if hhincome_a<=32600 then incomecat=1;
				else if 32600<hhincome_a<=54300 then incomecat=2;
				else if 54300<hhincome_a<=70150 then incomecat=3;
				else if 70150<hhincome_a<=108600 then incomecat=4;
				else if 108600<hhincome_a<=130320 then incomecat=5;
				else if 130320<hhincome_a<=217200 then incomecat=6;
				else if 217200 < hhincome_a then incomecat=7;
			end;

		  label hud_inc = 'HUD Income Limits category for household (2016)'
			    incomecat='Income Categories based on 2016 HUD Limit for Family of 4';


	 *adjust housing costs for inflation; 

	  %dollar_convert( rentgrs, rentgrs_a, &year., 2016, series=CUUR0000SA0L2 )
	  %dollar_convert( owncost, owncost_a, &year., 2016, series=CUUR0000SA0L2 )
	  %dollar_convert( valueh, valueh_a, &year., 2016, series=CUUR0000SA0L2 )

  	** Cost-burden flag & create cost ratio **;
	    if ownershp = 2  then do;

			Costratio= (rentgrs_a*12)/hhincome_a;
		end;

	    if ownershp = 1 then do;
			Costratio= (owncost_a*12)/hhincome_a;
		end;
	    
			if Costratio >= 0.3 then costburden=1;
		    else if HHIncome_a~=. then costburden=0;
			if costratio >= 0.5 then severeburden=1;
			else if HHIncome_a~=. then severeburden=0; 

		tothh = 1;

    
    ****** Rental units ******;
    
   if ownershpd in (21, 22) then do;
        
    Tenure = 1;

	 *create maximum desired or affordable rent based on HUD_Inc categories*; 

	  if hud_inc in(1 2 3) then max_rent=HHINCOME_a/12*.3; *under 80% of AMI then pay 30% threshold; 
	  if hud_inc =4 then max_rent=HHINCOME_a/12*.25; *avg for all HH hud_inc=4; 
	  if costratio <=.18 and hud_inc = 5 then max_rent=HHINCOME_a/12*.18; *avg for all HH hud_inc=5; 	
		else if hud_inc = 5 then max_rent=HHINCOME_a/12*costratio; *allow 120-200% above average to spend more; 
	  if costratio <=.12 and hud_inc = 6 then max_rent=HHINCOME_a/12*.12; *avg for all HH hud_inc=6; 
	  	else if hud_inc=6 then max_rent=HHINCOME_a/12*costratio; *allow 200%+ above average to spend more; 


    	*rent cost categories that make more sense for rents - no longer used in targets;
			rentlevel=.;
			if 0 <=rentgrs_a<750 then rentlevel=1;
			if 750 <=rentgrs_a<1200 then rentlevel=2;
			if 1200 <=rentgrs_a<1500 then rentlevel=3;
			if 1500 <=rentgrs_a<2000 then rentlevel=4;
			if 2000 <=rentgrs_a<2500 then rentlevel=5;
			if rentgrs_a >= 2500 then rentlevel=6;

			mrentlevel=.;
			if max_rent<750 then mrentlevel=1;
			if 750 <=max_rent<1200 then mrentlevel=2;
			if 1200 <=max_rent<1500 then mrentlevel=3;
			if 1500 <=max_rent<2000 then mrentlevel=4;
			if 2000 <=max_rent<2500 then mrentlevel=5;
			if max_rent >= 2500 then mrentlevel=6;

		 *rent cost categories now used in targets that provide a set of categories useable for renters and owners combined; 
			allcostlevel=.;
			if rentgrs_a<800 then allcostlevel=1;
			if 800 <=rentgrs_a<1300 then allcostlevel=2;
			if 1300 <=rentgrs_a<1800 then allcostlevel=3;
			if 1800 <=rentgrs_a<2500 then allcostlevel=4;
			if 2500 <=rentgrs_a<3500 then allcostlevel=5;
			if rentgrs_a >= 3500 then allcostlevel=6; 


			mallcostlevel=.;
			if max_rent<800 then mallcostlevel=1;
			if 800 <=max_rent<1300 then mallcostlevel=2;
			if 1300 <=max_rent<1800 then mallcostlevel=3;
			if 1800 <=max_rent<2500 then mallcostlevel=4;
			if 2500 <=max_rent<3500 then mallcostlevel=5;
			if max_rent >= 3500 then mallcostlevel=6;


	end;

	
	  		
		
  	else if ownershpd in ( 12,13 ) then do;

	    ****** Owner units ******;
	    
	    Tenure = 2;

		*create maximum desired or affordable owner costs based on HUD_Inc categories*; 

		if hud_inc in(1 2 3) then max_ocost=HHINCOME_a/12*.3; *under 80% of AMI then pay 30% threshold; 
		if hud_inc =4 then max_ocost=HHINCOME_a/12*.25; *avg for all HH hud_inc=4;
		if costratio <=.18 and hud_inc = 5 then max_ocost=HHINCOME_a/12*.18; *avg for all HH HUD_inc=5; 
			else if hud_inc = 5 then max_ocost=HHINCOME_a/12*costratio; *allow 120-200% above average to pay more; 
		if costratio <=.12 and hud_inc=6 then max_ocost=HHINCOME_a/12*.12; *avg for all HH HUD_inc=6;
			else if hud_inc = 6 then max_ocost=HHINCOME_a/12*costratio; *allow 120-200% above average to pay more; 

	    **** 
	    Calculate monthly payment for first-time homebuyers. 
	    Using 3.69% as the effective mortgage rate for DC in 2016, 
	    calculate monthly P & I payment using monthly mortgage rate and compounded interest calculation
	    ******; 
	    
	    loan = .9 * valueh_a;
	    month_mortgage= (3.69 / 12) / 100; 
	    monthly_PI = loan * month_mortgage * ((1+month_mortgage)**360)/(((1+month_mortgage)**360)-1);

	    ****
	    Calculate PMI and taxes/insurance to add to Monthly_PI to find total monthly payment
	    ******;
	    
	    PMI = (.007 * loan ) / 12; **typical annual PMI is .007 of loan amount;
	    tax_ins = .25 * monthly_PI; **taxes assumed to be 25% of monthly PI; 
	    total_month = monthly_PI + PMI + tax_ins; **Sum of monthly payment components;


		*owner cost categories that make more sense for owner costs - no longer used in targets;

		ownlevel=.;
			if 0 <=total_month<1200 then ownlevel=1;
			if 1200 <=total_month<1800 then ownlevel=2;
			if 1800 <=total_month<2500 then ownlevel=3;
			if 2500 <=total_month<3200 then ownlevel=4;
			if 3200 <=total_month<4200 then ownlevel=5;
			if total_month >= 4200 then ownlevel=6;

		mownlevel=.;
			if max_ocost<1200 then mownlevel=1;
			if 1200 <=max_ocost<1800 then mownlevel=2;
			if 1800 <=max_ocost<2500 then mownlevel=3;
			if 2500 <=max_ocost<3200 then mownlevel=4;
			if 3200 <=max_ocost<4200 then mownlevel=5;
			if max_ocost >= 4200 then mownlevel=6;


		 *owner cost categories now used in targets that provide a set of categories useable for renters and owners combined; 
			allcostlevel=.;
			if total_month<800 then allcostlevel=1;
			if 800 <=total_month<1300 then allcostlevel=2;
			if 1300 <=total_month<1800 then allcostlevel=3;
			if 1800 <=total_month<2500 then allcostlevel=4;
			if 2500 <=total_month<3500 then allcostlevel=5;
			if total_month >= 3500 then allcostlevel=6; 

				mallcostlevel=.;
			if max_ocost<800 then mallcostlevel=1;
			if 800 <=max_ocost<1300 then mallcostlevel=2;
			if 1300 <=max_ocost<1800 then mallcostlevel=3;
			if 1800 <=max_ocost<2500 then mallcostlevel=4;
			if 2500 <=max_ocost<3500 then mallcostlevel=5;
			if max_ocost >= 3500 then mallcostlevel=6;


  end;


	total=1;


			label rentlevel = 'Rent Level Categories based on Current Gross Rent'
		 		  mrentlevel='Rent Level Categories based on Max affordable-desired rent'
				  allcostlevel='Housing Cost Categories (tenure combined) based on Current Rent or First-time Buyer Mtg'
				  mallcostlevel='Housing Cost Categories (tenure combined) based on Max affordable-desired Rent-Buyer Mtg'
				  ownlevel = 'Owner Cost Categories based on First-Time HomeBuyer Costs'
				  mownlevel = 'Owner Cost Categories based on Max affordable-desired First-Time HomeBuyer Costs'

				;
	
format mownlevel ownlevel ocost. rentlevel mrentlevel rcost. allcostlevel mallcostlevel acost. hud_inc hud_inc. incomecat inc_cat.; 
run;

data Housing_needs_vacant_&year. Other_vacant_&year. ;

  set COGSvacant_&year.(keep=year serial hhwt bedrooms gq vacancy rent valueh Jurisdiction );

  retain Total 1;

  *reassign vacant but rented or sold based on whether rent or value is available; 	
  vacancy_r=vacancy; 
  if vacancy=3 and rent ~= .n then vacancy_r=1; 
  if vacancy=3 and valueh ~= .u then vacancy_r=2; 
    
    ****** Rental units ******;
	 if  vacancy_r = 1 then do;
	    Tenure = 1;
	    
	    	** Impute gross rent for vacant units **;
	  		rentgrs = rent*&&Ratio_rentgrs_rent_&year.;

			  %dollar_convert( rentgrs, rentgrs_a, &year., 2016, series=CUUR0000SA0L2 )
			

		/*create rent level categories*/ 
		rentlevel=.;
		if 0 <=rentgrs_a<750 then rentlevel=1;
		if 750 <=rentgrs_a<1200 then rentlevel=2;
		if 1200 <=rentgrs_a<1500 then rentlevel=3;
		if 1500 <=rentgrs_a<2000 then rentlevel=4;
		if 2000 <=rentgrs_a<2500 then rentlevel=5;
		if rentgrs_a >= 2500 then rentlevel=6;

		/*create  categories now used in targets for renter/owner costs combined*/ 
				allcostlevel=.;
				if rentgrs_a<800 then allcostlevel=1;
				if 800 <=rentgrs_a<1300 then allcostlevel=2;
				if 1300 <=rentgrs_a<1800 then allcostlevel=3;
				if 1800 <=rentgrs_a<2500 then allcostlevel=4;
				if 2500 <=rentgrs_a<3500 then allcostlevel=5;
				if rentgrs_a >= 3500 then allcostlevel=6;
	  end;


	  else if vacancy_r = 2 then do;

	    ****** Owner units ******;
	    
	    Tenure = 2;

	    **** 
	    Calculate  monthly payment for first-time homebuyers. 
	    Using 3.69% as the effective mortgage rate for DC in 2016, 
	    calculate monthly P & I payment using monthly mortgage rate and compounded interest calculation
	    ******; 
	    %dollar_convert( valueh, valueh_a, &year., 2016, series=CUUR0000SA0L2 )
	    loan = .9 * valueh_a;
	    month_mortgage= (3.69 / 12) / 100; 
	    monthly_PI = loan * month_mortgage * ((1+month_mortgage)**360)/(((1+month_mortgage)**360)-1);

	    ****
	    Calculate PMI and taxes/insurance to add to Monthly_PI to find total monthly payment
	    ******;
	    
	    PMI = (.007 * loan ) / 12; **typical annual PMI is .007 of loan amount;
	    tax_ins = .25 * monthly_PI; **taxes assumed to be 25% of monthly PI; 
	    total_month = monthly_PI + PMI + tax_ins; **Sum of monthly payment components;
		
			/*create owner cost level categories*/ 
			ownlevel=.;
				if 0 <=total_month<1200 then ownlevel=1;
				if 1200 <=total_month<1800 then ownlevel=2;
				if 1800 <=total_month<2500 then ownlevel=3;
				if 2500 <=total_month<3200 then ownlevel=4;
				if 3200 <=total_month<4200 then ownlevel=5;
				if total_month >= 4200 then ownlevel=6;
			
			/*create  categories now used in targets for renter/owner costs combined*/ 
				allcostlevel=.;
				if total_month<800 then allcostlevel=1;
				if 800 <=total_month<1300 then allcostlevel=2;
				if 1300 <=total_month<1800 then allcostlevel=3;
				if 1800 <=total_month<2500 then allcostlevel=4;
				if 2500 <=total_month<3500 then allcostlevel=5;
				if total_month >= 3500 then allcostlevel=6; 


	  end;

		label rentlevel = 'Rent Level Categories based on Current Gross Rent'
		 		  allcostlevel='Housing Cost Categories (tenure combined) based on Current Rent or First-time Buyer Mtg'
				  ownlevel = 'Owner Cost Categories based on First-Time HomeBuyer Costs'
				;
	format ownlevel ocost. rentlevel rcost. vacancy_r VACANCY_F. allcostlevel acost. ; 

	*output other vacant - seasonal separately ;
	if vacancy in (1, 2, 3) then output Housing_needs_vacant_&year.;
	else if vacancy in (4, 7, 9) then output other_vacant_&year.; 
	run;

%mend single_year; 

%single_year(2013);
%single_year(2014);
%single_year(2015); 
%single_year(2016);
%single_year(2017);

/*merge single year data*/ 
data fiveyeartotal;
	set Housing_needs_baseline_2013 Housing_needs_baseline_2014 Housing_needs_baseline_2015 Housing_needs_baseline_2016 Housing_needs_baseline_2017;

hhwt_5=hhwt*.2; 

run; 
proc means data= fiveyeartotal;
class hud_inc;
var Costratio ;
weight hhwt_5;
run;
data fiveyeartotal_vacant;
	set Housing_needs_vacant_2013 Housing_needs_vacant_2014 Housing_needs_vacant_2015 Housing_needs_vacant_2016 Housing_needs_vacant_2017;

hhwt_5=hhwt*.2; 

run; 
data fiveyeartotal_othervacant;
   set other_vacant_2013 other_vacant_2014 other_vacant_2015 other_vacant_2016 other_vacant_2017;

hhwt_5=hhwt*.2;

run; 
proc sort data =fiveyeartotal_othervacant;
by jurisdiction;
proc freq data=fiveyeartotal_othervacant;
by jurisdiction;
tables vacancy /nopercent norow nocol out=other_vacant;
weight hhwt_5;
format jurisdiction jurisdiction.;
run; 
proc export data=other_vacant
 	outfile="&_dcdata_default_path\RegHsg\Prog\other_vacant_&date..csv"
   dbms=csv
   replace;
   run;

/*all  units that we can determine cost level*/ 
data all;
	set fiveyeartotal fiveyeartotal_vacant (in=a);
	if a then incomecat=8; 

run; 

/*output current households by unit cost*/
proc freq data=all;
tables incomecat*allcostlevel /nopercent norow nocol out=region_units;
weight hhwt_5;
 
run;
proc freq data=all;
tables incomecat*allcostlevel /nopercent norow nocol out=region_rental;
where tenure=1;
weight hhwt_5;
run;
proc freq data=all;
tables incomecat*allcostlevel /nopercent norow nocol out=region_owner;
where tenure=2;
weight hhwt_5;

run;

	proc transpose data=region_owner prefix=level out=ro;
	by incomecat;
	var count;
	run;
	proc transpose data=region_rental prefix=level out=rr;
	by incomecat;
	var  count;
	run;
	proc transpose data=region_units  prefix=level  out=ru;
	by incomecat;
	var count;
	run;
	data region (drop=_label_ _name_); 
		set ru (in=a) ro (in=b) rr (in=c);
	
		length name $20.; 
	if _name_="COUNT" & a then name="Actual All";
	if _name_="COUNT" & b then name="Actual Owner";
	if _name_="COUNT" & c then name="Actual Rental";
	run; 


/*randomly select observations to reduce cost burden halfway*/
data all_costb;
	set fiveyeartotal;
	where costburden=1;
	run;

proc surveyselect data=all_costb  groups=2 seed=5000 out=randomgroups noprint;
run; 
proc sort data=randomgroups;
by year serial;
proc sort data=fiveyeartotal;
by year serial;
data fiveyearrandom;
merge fiveyeartotal randomgroups (keep=year serial groupid);
by year serial;

reduced_costb=.;

if incomecat in (1, 2, 3, 4, 5) and groupid=1 then reduced_costb=0;
else reduced_costb=costburden; 



if tenure=1 then do; 

	if reduced_costb=1 then reduced_rent =rentgrs_a;
	if reduced_costb=0 and costburden=1 then reduced_rent=hhincome_a/12*.3;
	if reduced_costb=0 and costburden=0 then reduced_rent=rentgrs_a; 

	 allcostlevel_halfway=.; 

				if reduced_rent<800 then allcostlevel_halfway=1;
				if 800 <=reduced_rent<1300 then allcostlevel_halfway=2;
				if 1300 <=reduced_rent<1800 then allcostlevel_halfway=3;
				if 1800 <=reduced_rent<2500 then allcostlevel_halfway=4;
				if 2500 <=reduced_rent<3500 then allcostlevel_halfway=5;
				if reduced_rent >= 3500 then allcostlevel_halfway=6;

end; 

if tenure=2 then do; 

	if reduced_costb=1 then reduced_totalmonth =total_month;
	if reduced_costb=0 and costburden=1 then reduced_totalmonth=hhincome_a/12*.3;
	if reduced_costb=0 and costburden=0 then reduced_totalmonth=total_month; 

		 allcostlevel_halfway=.; 

				if reduced_totalmonth<800 then allcostlevel_halfway=1;
				if 800 <=reduced_totalmonth<1300 then allcostlevel_halfway=2;
				if 1300 <=reduced_totalmonth<1800 then allcostlevel_halfway=3;
				if 1800 <=reduced_totalmonth<2500 then allcostlevel_halfway=4;
				if 2500 <=reduced_totalmonth<3500 then allcostlevel_halfway=5;
				if reduced_totalmonth >= 3500 then allcostlevel_halfway=6; 
end;

label allcostlevel_halfway ='Housing Cost Categories (tenure combined) based on Current Rent or First-time Buyer Mtg -Reduced Cost Burden by Half';
format allcostlevel_halfway acost.;

run; 
	proc freq data=fiveyeartotal;
	tables incomecat*costburden /nofreq nopercent nocol;
	weight hhwt_5;
	title2 "initial cost burden rates";
	run;
	proc freq data=fiveyearrandom;
	tables incomecat*reduced_costb /nofreq nopercent nocol;
	weight hhwt_5;
	title2 "reduced cost burden rates"; 
	run;
/*output income distributions by cost for desired cost and cost burden halfway solved*/ 

proc freq data=fiveyeartotal;
tables incomecat*mallcostlevel /nofreq nopercent nocol out=region_desire_byinc;
weight hhwt_5;
title2;
run;
proc freq data=fiveyeartotal;
tables incomecat*mallcostlevel /nofreq nopercent nocol out=region_desire_rent;
weight hhwt_5;
where tenure=1;
run;
proc freq data=fiveyeartotal;
tables incomecat*mallcostlevel /nofreq nopercent nocol out=region_desire_own;
weight hhwt_5;
where tenure=2;
run;

proc freq data=fiveyearrandom;
tables incomecat*allcostlevel_halfway /nofreq nopercent nocol out=region_half_byinc;
weight hhwt_5;

run;
proc freq data=fiveyearrandom;
tables incomecat*allcostlevel_halfway /nofreq nopercent nocol out=region_half_rent;
weight hhwt_5;
where tenure=1;
run;
proc freq data=fiveyearrandom;
tables incomecat*allcostlevel_halfway /nofreq nopercent nocol out=region_half_own;
weight hhwt_5;
where tenure=2; 
run;
data rdesire_half_byinc ;
	set region_desire_byinc (in=a rename=(mallcostlevel=allcostlevel) )
		region_desire_rent  (in=b rename=(mallcostlevel=allcostlevel))
		region_desire_own   (in=c rename=(mallcostlevel=allcostlevel))
		region_half_byinc (in=d rename=(allcostlevel_halfway=allcostlevel))
		region_half_rent  (in=e rename=(allcostlevel_halfway=allcostlevel))
		region_half_own   (in=f rename=(allcostlevel_halfway=allcostlevel));

	drop percent;

	length name $20.;

	if a then name="Desired All"; 
	if b then name="Desired Renter";  
	if c then name="Desired Owner";
	
	if d then name="Halfway All"; 
	if e then name="Halfway Renter";  
	if f then name="Halfway Owner"; 

format allcostlevel ; 
run;

proc sort data=rdesire_half_byinc;
by incomecat name;
proc transpose data=rdesire_half_byinc out=desire_half prefix=level; 
by incomecat name;
id allcostlevel ;
var count;
	run;

/*set with region units file (all, renter, owner) */

data region_byinc_actual_to_desired;
set region desire_half (drop=_name_ _label_);

run; 
proc sort data=region_byinc_actual_to_desired;
by name; 
proc export data=region_byinc_actual_to_desired
 	outfile="&_dcdata_default_path\RegHsg\Prog\region_units_&date..csv"
   dbms=csv
   replace;
   run;



/*by jurisdiction -actual unit distribution (all, renter, owner) */
proc sort data=all;
by jurisdiction;
proc freq data=all;
by jurisdiction;
tables incomecat*allcostlevel /nopercent norow nocol out=jurisdiction;
weight hhwt_5;
format jurisdiction Jurisdiction.;
run;
	proc transpose data=jurisdiction out=ju prefix=level;;
	by jurisdiction incomecat;
	var count;

	run;

proc freq data=all;
by jurisdiction;
tables incomecat*allcostlevel /nopercent norow nocol out=jurisdiction_rent;
where tenure=1;
weight hhwt_5;
format jurisdiction Jurisdiction.;
run;
	proc transpose data=jurisdiction_rent out=jr prefix=level;;
	by jurisdiction incomecat;
	var count;

	run;

proc freq data=all;
by jurisdiction;
tables incomecat*allcostlevel /nopercent norow nocol out=jurisdiction_own;
where tenure=2;
weight hhwt_5;
format jurisdiction Jurisdiction.;
run;
	proc transpose data=jurisdiction_own out=jo prefix=level;;
	by jurisdiction incomecat;
	var count;

	run;
data jurisdiction_units (drop=_label_ _name_); 
		set ju (in=a) jo (in=b) jr (in=c);

	length name $20.;

	if _name_="COUNT" & a then name="Actual All";
	if _name_="COUNT" & b then name="Actual Owner";
	if _name_="COUNT" & c then name="Actual Rental";
	run; 


/*jurisdiction desire and halfway (by tenure)*/
proc sort data=fiveyeartotal;
by jurisdiction; 
proc freq data=fiveyeartotal;
by jurisdiction;
tables incomecat*mallcostlevel /nopercent norow nocol out=jurisdiction_desire;
weight hhwt_5;
format jurisdiction Jurisdiction. mallcostlevel;
run;
	proc transpose data=jurisdiction_desire out=jd
	prefix=level;
	id mallcostlevel;
	by jurisdiction incomecat;
	var count;
	run;

proc freq data=fiveyeartotal;
by jurisdiction;
tables incomecat*mallcostlevel /nopercent norow nocol out=jurisdiction_desire_rent;
weight hhwt_5;
where tenure=1 ;
format jurisdiction Jurisdiction. mallcostlevel;
run;
	proc transpose data=jurisdiction_desire_rent out=jdr
	prefix=level;
	id mallcostlevel;
	by jurisdiction incomecat;
	var count;
	run;

proc freq data=fiveyeartotal;
by jurisdiction;
tables incomecat*mallcostlevel /nopercent norow nocol out=jurisdiction_desire_own;
weight hhwt_5;
where tenure=2 ;
format jurisdiction Jurisdiction. mallcostlevel;
run;
	proc transpose data=jurisdiction_desire_own out=jdo
	prefix=level;
	id mallcostlevel;
	by jurisdiction incomecat;
	var count;
	run;
data jurisdiction_desire_units (drop=_label_ _name_); 
		set jd (in=a) jdo (in=b) jdr (in=c);

	length name $20.;

	if _name_="COUNT" & a then name="Desired All";
	if _name_="COUNT" & b then name="Desired Owner";
	if _name_="COUNT" & c then name="Desired Renter";
	run; 
proc sort data=fiveyearrandom;
by jurisdiction;
proc freq data=fiveyearrandom;
by jurisdiction;
tables incomecat*allcostlevel_halfway /nofreq nopercent nocol out=jurisdiction_half_byinc;
weight hhwt_5;

format jurisdiction Jurisdiction. allcostlevel_halfway;
run;
proc transpose data=jurisdiction_half_byinc out=jhalf
	prefix=level;
	id allcostlevel_halfway;
	by jurisdiction incomecat;
	var count;
	run;
proc freq data=fiveyearrandom;
by jurisdiction;
tables incomecat*allcostlevel_halfway /nofreq nopercent nocol out=jurisdiction_half_rent;
weight hhwt_5;
where tenure=1; 
format jurisdiction Jurisdiction. allcostlevel_halfway;
run;
proc transpose data=jurisdiction_half_rent out=jhalfr
	prefix=level;
	id allcostlevel_halfway;
	by jurisdiction incomecat;
	var count;
	run;
proc freq data=fiveyearrandom;
by jurisdiction;
tables incomecat*allcostlevel_halfway /nofreq nopercent nocol out=jurisdiction_half_own;
weight hhwt_5;
where tenure=2; 
format jurisdiction Jurisdiction. allcostlevel_halfway;
run;
proc transpose data=jurisdiction_half_own out=jhalfo
	prefix=level;
	id allcostlevel_halfway;
	by jurisdiction incomecat;
	var count;
	run;

data jurisdiction_half_units (drop=_label_ _name_); 
		set jhalf (in=a) jhalfo (in=b) jhalfr (in=c);

	length name $20.;

	if _name_="COUNT" & a then name="Halfway All";
	if _name_="COUNT" & b then name="Halfway Owner";
	if _name_="COUNT" & c then name="Halfway Rental";
	run; 

/*export jurisidiction units*/ 
data jurisdiction_all;
set jurisdiction_units jurisdiction_desire_units jurisdiction_half_units;
run; 
proc sort data= jurisdiction_all;
by jurisdiction name incomecat;
proc export data=jurisdiction_all
 	outfile="&_dcdata_default_path\RegHsg\Prog\jurisdiction_units_&date..csv"
   dbms=csv
   replace;
   run;

