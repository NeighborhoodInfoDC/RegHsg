/**************************************************************************
 Program:  Vulnerable to gentrification_Jurisdiction.sas
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
%DCData_lib( Ipums)

%let _years=2012_16;

/********* 2016 Vulnerability **************/
data demographics16 (where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
set ACS.Acs_2012_16_dc_sum_tr_tr10 ACS.Acs_2012_16_md_sum_tr_tr10 ACS.Acs_2012_16_va_sum_tr_tr10 ACS.Acs_2012_16_wv_sum_tr_tr10;

keep geo2010 county Jurisdiction percentrenter_2016 percentwhite_2016 percentcollege_2016 avghhinc_2016 popwhitenonhispbridge_&_years. 
	 popwithrace_&_years. numrenteroccupiedhu_&_years. numowneroccupiedhu_&_years. pop25andoverwcollege_&_years. pop25andoveryears_&_years. 
	agghshldincome_&_years.  numhshlds_&_years. medianhomevalue_&_years. percentinclt75000 hshldincunder15000_&_years. hshldinc15000to34999_&_years.
	hshldinc35000to49999_&_years.  hshldinc50000to74999_&_years. medfamincm_2012_16 MedHHIncm_2012_16 numowneroccupiedhu_&_years.;

	county= substr(geo2010,1,5);
	percentrenter_2016= numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years.+numowneroccupiedhu_&_years.);
	percentwhite_2016= popwhitenonhispbridge_&_years./popwithrace_&_years.;
	percentcollege_2016= pop25andoverwcollege_&_years./pop25andoveryears_&_years.;
	avghhinc_2016= agghshldincome_&_years./(numhshlds_&_years. );
	percentinclt75000 = (hshldincunder15000_&_years. + hshldinc15000to34999_&_years.+ hshldinc35000to49999_&_years.+ hshldinc50000to74999_&_years.)/(numhshlds_&_years. );
	if county in ("11001") then Jurisdiction=1;
	if county in ("24017") then Jurisdiction=2;
	if county in ("24021") then Jurisdiction=3;
	if county in ("24031") then Jurisdiction=4;
	if county in ("24033") then Jurisdiction=5;
	if county in ("51013") then Jurisdiction=6;
	if county in ("51600", "51059","51610") then Jurisdiction=7;
	if county in ("51107") then Jurisdiction=8;
	if county in ("51153", "51683","51685") then Jurisdiction=9;
	if county in ("51510") then Jurisdiction=10;
run;

proc sort data=demographics16;
	by geo2010;
run;

data demographics00(where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
	set NCDB.Ncdb_master_update;
	keep geo2010 county Jurisdiction percentrenter_00 percentwhite_00 percentcollege_00 avghhinc_00 sprntoc0 spownoc0 shr0d SHRNHW0N educpp0 educ160 avhhin0 avghhinc_00a 
		 numhhs0 percentinclt75000_00 thy0100 thy0150 thy0200 thy0250 thy0300 thy0350 thy0400 thy0450 thy0500 thy0600 thy0750 mdfamy0 mdhhy0 mdfamy0a mdhhy0a;
	county= substr(geo2010,1,5);
	percentrenter_00= sprntoc0/(sprntoc0+spownoc0);
	percentwhite_00= SHRNHW0N/shr0d;
	percentcollege_00= educ160/educpp0;
	avghhinc_00= avhhin0;
	percentinclt75000_00= (thy0100+thy0150+thy0200+thy0250+thy0300+thy0350+thy0400+thy0450+thy0500+thy0600+thy0750)/numhhs0; 

	%dollar_convert( avghhinc_00, avghhinc_00a, 1999, 2016, series=CUUR0000SA0 )
	%dollar_convert( mdfamy0, mdfamy0a, 1999, 2016, series=CUUR0000SA0 )
    %dollar_convert( mdhhy0, mdhhy0a, 1999, 2016, series=CUUR0000SA0 )
run;

proc sort data=demographics00;
by geo2010;
run;

data changeintime;
merge demographics16 demographics00;
by geo2010;
COG=1;
deltarenter = numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years.+numowneroccupiedhu_&_years.)- sprntoc0/(sprntoc0+spownoc0);
deltawhite= percentwhite_2016- percentwhite_00;
deltacollege= percentcollege_2016- percentcollege_00;
deltahhinc= (avghhinc_2016-avghhinc_00a)/avghhinc_00a;
deltahhinc75000= percentinclt75000-percentinclt75000_00; /* 75,000 is roughly the same as 80% MFI */
deltamedianfaminc= (medfamincm_2012_16- mdfamy0a)/mdfamy0a;
deltamedianHHinc= (MedHHIncm_2012_16- mdhhy0a)/mdhhy0a;
run;

proc means data=changeintime median;
run;
proc sort data=changeintime;
by jurisdiction;
proc summary data= changeintime;
	by Jurisdiction;
	var numrenteroccupiedhu_&_years. numowneroccupiedhu_&_years. popwhitenonhispbridge_&_years. popwithrace_&_years. pop25andoverwcollege_&_years. pop25andoveryears_&_years.
		agghshldincome_&_years. numhshlds_&_years. avghhinc_00a sprntoc0 spownoc0 SHRNHW0N shr0d educ160 educpp0 numhhs0 hshldincunder15000_&_years.  hshldinc15000to34999_&_years.
		hshldinc35000to49999_&_years.  hshldinc50000to74999_&_years. numowneroccupiedhu_&_years. thy0100 thy0150 thy0200 thy0250 thy0300 thy0350 thy0400 thy0450 thy0500 thy0600 thy0750 ;
	output out = vulnerable_2016  sum=;
run;

/*calculate vulnerability threshold based on Jurisdiction total*/
data vulnerablethreshold (keep = Jurisdiction threshold_renter_2016 threshold_white_2016 threshold_hhinc_2016 threshold_college_2016 threshold_75000_2016 
								 threshold_deltarenter threshold_deltawhite threshold_deltacollege /*threshold_deltahhinc*/ threshold_delta75000)
						  ;
	set vulnerable_2016 (drop=_type_ _freq_) ;

	percentrenter_2016= numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years.+numowneroccupiedhu_&_years.);
	percentwhite_2016= popwhitenonhispbridge_&_years./popwithrace_&_years.;
	percentcollege_2016= pop25andoverwcollege_&_years./pop25andoveryears_&_years.;
	avghhinc_2016= agghshldincome_&_years./(numhshlds_&_years. );
	percentinclt75000= (hshldincunder15000_&_years. + hshldinc15000to34999_&_years.+ hshldinc35000to49999_&_years.+ hshldinc50000to74999_&_years.)/(numhshlds_&_years. );

	deltarenter = numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years. +numowneroccupiedhu_&_years.)- sprntoc0/(sprntoc0+spownoc0);
	deltawhite= popwhitenonhispbridge_&_years./popwithrace_&_years.- SHRNHW0N/shr0d;
	deltacollege= pop25andoverwcollege_&_years./pop25andoveryears_&_years. - educ160/educpp0;
	/*this is incorrect - should not sum average in proc summary 
		deltahhinc= ((agghshldincome_&_years. /numhshlds_&_years.)-avghhinc_00a)/avghhinc_00a;*/
	deltahhinc75000= (hshldincunder15000_&_years. + hshldinc15000to34999_&_years.+ hshldinc35000to49999_&_years.+ hshldinc50000to74999_&_years.)/(numhshlds_&_years. )- (thy0100+thy0150+thy0200+thy0250+thy0300+thy0350+thy0400+thy0450+thy0500+thy0600+thy0750)/numhhs0;

	rename 							percentrenter_2016=threshold_renter_2016 
									percentwhite_2016=threshold_white_2016
									avghhinc_2016=threshold_hhinc_2016
									percentcollege_2016=threshold_college_2016
									percentinclt75000=threshold_75000_2016
									deltarenter=threshold_deltarenter 
									deltawhite=threshold_deltawhite
									deltacollege= threshold_deltacollege
									/*deltahhinc=threshold_deltahhinc*/
									deltahhinc75000=threshold_delta75000;
run;

/*compile county level median 2000 and 2016 to calculate Jurisdiction level median income change threshold*/
/*2000 SF3 from factfinder
Id2	Geography	Median family income in 1999	Median household income in 1999
11001	District of Columbia, District of Columbia	46283	40127
24017	Charles County, Maryland	67602	62199
24021	Frederick County, Maryland	67879	60276
24031	Montgomery County, Maryland	84035	71551
24033	Prince George's County, Maryland	62467	55256
51013	Arlington County, Virginia	78877	63001
51059	Fairfax County, Virginia	92146	81050
51107	Loudoun County, Virginia	88387	80648
51153	Prince William County, Virginia	71622	65960
51510	Alexandria city, Virginia	67023	56054
51600	Fairfax city, Virginia	78921	67642
51610	Falls Church city, Virginia	97225	74924
51683	Manassas city, Virginia	70141	60409
51685	Manassas Park city, Virginia	61075	60794
*/

data countylevelmedian(where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685")));
set ACS.Acs_2012_16_dc_sum_regcnt_regcnt ACS.Acs_2012_16_md_sum_regcnt_regcnt ACS.Acs_2012_16_va_sum_regcnt_regcnt ACS.Acs_2012_16_wv_sum_regcnt_regcnt ; 
keep Jurisdiction county medfamincm_2012_16 MedHHIncm_2012_16 mdfamy0a mdhhy0a;
	if county in ("11001") then Jurisdiction=1;
	if county in ("24017") then Jurisdiction=2;
	if county in ("24021") then Jurisdiction=3;
	if county in ("24031") then Jurisdiction=4;
	if county in ("24033") then Jurisdiction=5;
	if county in ("51013") then Jurisdiction=6;
	if county in ("51600", "51059","51610") then Jurisdiction=7;
	if county in ("51107") then Jurisdiction=8;
	if county in ("51153", "51683","51685") then Jurisdiction=9;
	if county in ("51510") then Jurisdiction=10;

	if county ="11001" then do;  mdfamy0=46283; mdhhy0=40127; end;
	if county ="24017" then do; mdfamy0=67602; mdhhy0=62199; end;
	if county="24021" then do; mdfamy0=67879; mdhhy0=60276; end;
	if county ="24031" then do; mdfamy0=84035; mdhhy0=71551; end;
	if county ="24033" then do; mdfamy0=62467; mdhhy0=55256; end;
	if county ="51013" then do; mdfamy0=78877; mdhhy0=63001; end;
	if county ="51600" then do;  mdfamy0=78921; mdhhy0=67642; end;
	if county ="51059" then do; mdfamy0=92146; mdhhy0=81050; end;
	if county="51610" then do; 	mdfamy0=97225; mdhhy0=74924; end;
	if county="51107" then do; mdfamy0=88387; mdhhy0=80648; end;
	if county="51153" then do;mdfamy0=71622; mdhhy0=65960; end;
	if county="51683" then do; mdfamy0=70141; mdhhy0=60409; end;
	if county="51685" then do;mdfamy0=61075; mdhhy0=60794; end;
	if county="51510" then do; mdfamy0=67023; mdhhy0=56054; end;

	%dollar_convert( mdfamy0, mdfamy0a, 1999, 2016, series=CUUR0000SA0 )
    %dollar_convert( mdhhy0, mdhhy0a, 1999, 2016, series=CUUR0000SA0 )

run;
proc sort data=countylevelmedian;
by jurisdiction;
proc summary data=countylevelmedian;
by Jurisdiction ;
var medfamincm_2012_16 MedHHIncm_2012_16 mdfamy0a  mdhhy0a;
output out=jurisdictionmedian mean=;
run;


data medianincomechange;
set jurisdictionmedian ;

threshold_deltamedian= (medfamincm_2012_16- mdfamy0a)/mdfamy0a;
threshold_deltamedianH= (MedHHIncm_2012_16- mdhhy0a)/mdhhy0a;
run;

proc sort data=changeintime;
by Jurisdiction;
data masterdata_1;
merge changeintime vulnerablethreshold medianincomechange;
by Jurisdiction;
run;


/* identify tracts with higher than average population with characteristics that make resisting displacement more difficult:
renters, POC, lack college degree, lower income*/

data risk_displacement;
set masterdata_1;
		if percentrenter_2016 >= threshold_renter_2016 then vulnerable_renter =1;
	    else if percentrenter_2016< threshold_renter_2016 then vulnerable_renter =0;
		else if percentrenter_2016=. then vulnerable_renter =.;

		if percentwhite_2016<= threshold_white_2016 then vulnerable_POC=1;
		else if percentwhite_2016> threshold_white_2016 then vulnerable_POC=0;
		else if percentwhite_2016=. then vulnerable_POC=.;

		if percentcollege_2016<= threshold_college_2016 then vulnerable_college=1;
		else if percentcollege_2016 > threshold_college_2016 then vulnerable_college=0;
		else if percentcollege_2016=. then vulnerable_college=.;

		if percentinclt75000 <= threshold_75000_2016 then vulnerable_inc=1; 
		else if percentinclt75000> threshold_75000_2016 then vulnerable_inc=0;
		else if percentinclt75000=. then vulnerable_inc=.;

		vulnerablesum= vulnerable_renter + vulnerable_POC + vulnerable_college + vulnerable_inc;

		if vulnerablesum>=3 then vulnerable=1; else vulnerable=0;

/* identify change of tract demographics that are signalling gentrification:
change in renters, more white people, more college degree, higher income*/


/*calculate demographic change threshold and flag based on region total*/

		if deltarenter <= threshold_deltarenter then gentrifier_owner =1;
	    else if deltarenter> threshold_deltarenter then gentrifier_owner =0;
		else if deltarenter=. then gentrifier_owner =.;

		if deltawhite>= threshold_deltawhite then gentrifier_white=1;
		else if deltawhite< threshold_deltawhite then gentrifier_white=0;
		else if deltawhite=. then gentrifier_white=.;

		if deltacollege>= threshold_deltacollege then gentrifier_college=1;
		else if deltacollege < threshold_deltacollege then gentrifier_college=0;
		else if deltacollege=. then gentrifier_college=.;

		if  deltamedianfaminc >= threshold_deltamedian then gentrifier_inc=1;  
		else if  deltamedianfaminc < threshold_deltamedian then gentrifier_inc=0;
		else if  deltamedianfaminc=. then gentrifier_inc=.;

		if  deltamedianHHinc >= threshold_deltamedianH then gentrifier_incH=1;  
		else if  deltamedianHHinc < threshold_deltamedianH then gentrifier_incH=0;
		else if  deltamedianHHinc=. then gentrifier_incH=.;

		gentrifier_MFAM= gentrifier_owner + gentrifier_white + gentrifier_college + gentrifier_inc;
		gentrifier_MHH=gentrifier_owner + gentrifier_white + gentrifier_college + gentrifier_incH;

		if gentrifier_MFAM>=3 then demographicchange_MFAM=1; else demographicchange_MFAM=0;
		if gentrifier_white=1 & gentrifier_college=1 then demographicchange_MFAM=1;

		if gentrifier_MHH>=3 then demographicchange_MHH=1; else demographicchange_MHH=0;
		if gentrifier_white=1 & gentrifier_college=1 then demographicchange_MHH=1;

run;

proc format;
  value signofrisk
   .n = 'No complete data'
    1 = 'Yes'
    0 = 'No';
run;

/*signofrisk: 1: gentrifying and vulnerable now 2: gentrifying but not vulnerable now 3; not gentrified but vulnerable 3: not gentrified and not vulnerable*/
data flag_population;
set risk_displacement;
keep geo2010 county Jurisdiction vulnerable demographicchange_MFAM demographicchange_MHH percentrenter_2016 percentwhite_2016 percentcollege_2016 avghhinc_2016
popwhitenonhispbridge_&_years. popwithrace_&_years. numrenteroccupiedhu_&_years. numowneroccupiedhu_&_years. pop25andoverwcollege_&_years. pop25andoveryears_&_years. 
agghshldincome_&_years.  numhshlds_&_years. medianhomevalue_&_years. ;

format vulnerable signofrisk. demographicchange_MHH   demographicchange_MFAM signofrisk. ;

if numhshlds_&_years. < 100 then do; vulnerable =.n; demographicchange_MHH=.n; demographicchange_MFAM=.n; end;
run;


/*Calculate appreciation of home values and rank baseline median home values*/

data housing1990(where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
set NCDB.Ncdb_master_update;
keep geo2010 county Jurisdiction mdvalhs9 mdvalhs9_a mdvalhs0 mdvalhs0_a  SPOWNOC9 SPOWNOC0;
county= substr(geo2010,1,5);
%dollar_convert( mdvalhs0, mdvalhs0_a, 2000, 2016, series=CUUR0000SA0L2 )
%dollar_convert( mdvalhs9, mdvalhs9_a, 1990, 2016, series=CUUR0000SA0L2 )
	if county in ("11001") then Jurisdiction=1;
	if county in ("24017") then Jurisdiction=2;
	if county in ("24021") then Jurisdiction=3;
	if county in ("24031") then Jurisdiction=4;
	if county in ("24033") then Jurisdiction=5;
	if county in ("51013") then Jurisdiction=6;
	if county in ("51600", "51059","51610") then Jurisdiction=7;
	if county in ("51107") then Jurisdiction=8;
	if county in ("51153", "51683","51685") then Jurisdiction=9;
	if county in ("51510") then Jurisdiction=10;
run;
proc sort data=changeintime;
by geo2010;
data housingmarket;
merge changeintime housing1990;
keep geo2010 geoid county SPOWNOC9 SPOWNOC0 numowneroccupiedhu_&_years.  Jurisdiction mdvalhs9_a mdvalhs0_a medianhomevalue_2012_16 appre90_16 appre00_16;
by geo2010;

if SPOWNOC9 < 50 then mdvalhs9_a=.n ;
if SPOWNOC0 < 50 then mdvalhs0_a=.n; 
if numowneroccupiedhu_&_years. < 50 then medianhomevalue_2012_16=.n; 

	appre90_16 = (medianhomevalue_2012_16- mdvalhs9_a)/ mdvalhs9_a;
	appre00_16 = (medianhomevalue_2012_16-mdvalhs0_a)/mdvalhs0_a;
	geoid=geo2010;
run;
proc means data=housingmarket;
run;

/*need to rank the tracts by Jurisdiction*/
proc sort data=housingmarket;
by jurisdiction;
proc rank data=housingmarket out=valuehousing groups=5;
 by jurisdiction;
 var mdvalhs9_a mdvalhs0_a medianhomevalue_2012_16 appre90_16 appre00_16;
 ranks rank90 rank2000 rank2016 rank90_16 rank00_16 ;
run;

data appreciationtracts;
set valuehousing;

if rank90~=. and rank2016 ~=. & rank90_16 ~=. then do; 
	if rank90 <= 2 &  rank2016 >=3 & rank90_16 >= 3 then appreciated =1; else appreciated =0;
	end; 
else if rank90=. or rank2016=. or rank90_16=. then appreciated=.n; 

if rank2016~=. and rank00_16 ~=. then do; 
	if rank2016<=2 & rank00_16 >=3 then accelerating=1;else accelerating=0;
	end; 
else if rank2016=. or rank00_16=. then accelerating=.n; 

run;

proc freq data=appreciationtracts;
tables appreciated accelerating;
run;

proc export data = appreciationtracts
   outfile="&_dcdata_default_path\RegHsg\Prog\Housing market condition_jurisdiction.csv"
   dbms=csv
   replace;
run;
proc sort data=appreciationtracts;
by geo2010;
run;

proc sort data=flag_population;
by geo2010;
run;
data completetypology;
merge flag_population appreciationtracts;
by geo2010;
run;

proc export data = completetypology
   outfile="&_dcdata_default_path\RegHsg\Prog\completetypology_Jurisdiction.csv"
   dbms=csv
   replace;
run;

data comparison;
set completetypology;
diff= demographicchange_MFAM-demographicchange_MHH;
run;
proc freq data=comparison;
tables diff;
run;

/* need to import appreciated and accelerating tract flag to ArcGIS to finish the housing market change typoloy*/
/* Then with the complete typology flag, we can either import the data back to SAS or just use excel to assign tracts to the 6 different categories*/

/*******************end of the main program**********************************************************/
