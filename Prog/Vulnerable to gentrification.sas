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
%DCData_lib( ACS)
%DCData_lib( Census)
%DCData_lib( NCDB)

%let _years=2012_16;

** Calculate average ratio of gross rent to contract rent for occupied units **;
data demographics16 (where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
	set ACS.Acs_2012_16_dc_sum_tr_tr10 ACS.Acs_2012_16_md_sum_tr_tr10 ACS.Acs_2012_16_va_sum_tr_tr10 ACS.Acs_2012_16_wv_sum_tr_tr10;
keep geo2010 county percentrenter_2016 percentwhite_2016 percentcollege_2016 avghhinc_2016 popwithrace_&_years. popalonew_&_years. numrenteroccupiedhu_&_years. numowneroccupiedhu_&_years. pop25andoverwcollege_&_years. pop25andoveryears_&_years. agghshldincome_&_years.  numhshlds_&_years. medianhomevalue_&_years. ;
county= substr(geo2010,1,5);
percentrenter_2016= numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years.+numowneroccupiedhu_&_years.);
percentwhite_2016= popwhitenonhispbridge_&_years./popwithrace_&_years.;
percentcollege_2016= pop25andoverwcollege_&_years./pop25andoveryears_&_years.;
avghhinc_2016= agghshldincome_&_years./(numhshlds_&_years. );
run;

proc sort data=demographics16;
by geo2010;
run;

data demographics00(where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
set NCDB.Ncdb_master_update;
keep geo2010 county percentrenter_00 percentwhite_00 percentcollege_00 avghhinc_00 sprntoc0 spownoc0 shr0d minwht0n educpp0 educ160 avhhin0 avghhinc_00a;
county= substr(geo2010,1,5);
percentrenter_00= sprntoc0/(sprntoc0+spownoc0);
percentwhite_00= minwht0n/shr0d;
percentcollege_00= educ160/educpp0;
avghhinc_00= avhhin0;

%dollar_convert( avghhinc_00, avghhinc_00a, 1999, 2016, series=CUUR0000SA0 )

run;

proc sort data=demographics00;
by geo2010;
run;

data merged;
merge demographics16 demographics00;
by geo2010;
run;

data changeintime;
	set merged;
deltarenter= percentrenter_2016-percentrenter_00;
deltawhite= percentwhite_2016- percentwhite_00;
deltacollege= percentcollege_2016- percentcollege_00;
deltahhinc= avghhinc_2016-avghhinc_00a;
run;

proc means data=changeintime;
run;
/* identify tracts with higher than average population with characteristics that make resisting displacement more difficult:
renters, POC, lack college degree, lower income*/
/*mean for 2016: percentwhite:0.5249191 percentrenter: 0.3711398 percentcollege 0.5070980 averageincome 123615.75*/

data risk_displacement;
set changeintime;
		if percentrenter_2016 >= 0.37 then vulnerable_renter =1;
	    else if percentrenter_2016< 0.37 then vulnerable_renter =0;
		else if percentrenter_2016=. then vulnerable_renter =.;

if percentwhite_2016<= 0.52 then vulnerable_POC=1;
else if percentwhite_2016> 0.52 then vulnerable_POC=0;
else if percentwhite_2016=. then vulnerable_POC=.;

if percentcollege_2016<=0.51 then vulnerable_college=1;
else if percentcollege_2016 >0.51 then vulnerable_college=0;
else if percentcollege_2016=. then vulnerable_college=.;

if avghhinc_2016 <= 123626 then vulnerable_inc=1;
else if avghhinc_2016> 123626 then vulnerable_inc=0;
else if avghhinc_2016=. then vulnerable_inc=.;

vulnerable= vulnerable_renter + vulnerable_POC + vulnerable_college + vulnerable_inc;

run;

/* identify change of tract demographics that are signalling gentrification:
change in renters, more white people, more college degree, higher income*/
/*means for deltarenter:-0.0195884   deltawhite: -0.0444152 deltacollege: 0.0775480 deltainc: 5516*/

data risk_gentrification;
set risk_displacement;
		if deltarenter <= 0.02 then gentrifier_owner =1;
	    else if deltarenter> 0.02 then vulnerable_renter =0;
		else if deltarenter=. then vulnerable_renter =.;

if deltawhite>=0.04 then gentrifier_white=1;
else if deltawhite<0.04 then gentrifier_white=0;
else if deltawhite=. then gentrifier_white=.;

if deltacollege>=0.08 then gentrifier_college=1;
else if deltacollege <0.08 then gentrifier_college=0;
else if deltacollege=. then gentrifier_college=.;

if deltahhinc >= 5516 then gentrifier_inc=1;
else if deltahhinc < 5516 then gentrifier_inc=0;
else if deltahhinc=. then gentrifier_inc=.;

gentrifier= gentrifier_owner + gentrifier_white = gentrifier_college + gentrifier_inc;

run;


proc format;
  value signofrisk
   .n = 'No complete data'
    1 = 'gentrifying and vulnerable now'
    2 = 'gentrifying but not vulnerable now'
    3 = 'not gentrified but vulnerable'
    4 = 'not gentrified and not vulnerable'
run;

/*signofrisk: 1: gentrifying and vulnerable now 2: gentrifying but not vulnerable now 3; not gentrified but vulnerable 3: not gentrified and not vulnerable*/
data flag_type;
set risk_gentrification;
if vulnerable>=2 then do;
		if gentrifier>=2 then signofrisk= 1;
		else if gentrifier<2 then signofrisk=3;
	end;

if vulnerable<2 then do;
		if gentrifier>=2 then signofrisk= 2;
		else if gentrifier<2 then signofrisk=4;
	end;
format signofrisk signofrisk. ;
run;


/*Calculate appreciation of home values and rank baseline median home values*/

data housing1990(where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
set NCDB.Ncdb_master_update;
keep geo2010 county mdvalhs9 mdvalhs0;
county= substr(geo2010,1,5);
run;

data housingmarket;
merge merged housing1990;
keep geo2010 county mdvalhs9 mdvalhs0 medianhomevalue_2012_16 appre90_16 appre00_16;
by geo2010;
appre90_16 = (medianhomevalue_2012_16- mdvalhs9)/ mdvalhs9;
appre00_16 = (medianhomevalue_2012_16-mdvalhs0)/mdvalhs0;
run;

proc rank data=housingmarket out=valuehousing groups=5;
 var mdvalhs9 mdvalhs0 medianhomevalue_2012_16 appre90_16 appre00_16;
 ranks rank90 rank2000 rank2016 rank90_16 rank00_16;
run;

data appreciationtracts;
set valuehousing;

if mdvalhs9 <= 2 &  medianhomevalue_2012_16 >=3 & appre90_16 >= 3 then appreciated =1;else appreciated =0;
if medianhomevalue_2012_16<=2 & appre00_16>=3 then accelerating=1;else accelerating=0;

run;

proc freq data=appreciationtracts;
run;

proc export data = appreciationtracts
   outfile="&_dcdata_default_path\RegHsg\Prog\Housing market condition.csv"
   dbms=csv
   replace;
run;





