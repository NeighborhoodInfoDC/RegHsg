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

%let _years=2013_17;
%let endyr=17;

/********* Vulnerability **************/
data demographics&endyr. (where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
set ACS.Acs_&_years._dc_sum_tr_tr10 ACS.Acs_&_years._md_sum_tr_tr10 ACS.Acs_&_years._va_sum_tr_tr10 ACS.Acs_&_years._wv_sum_tr_tr10;

keep geo2010 county Jurisdiction percentrenter_20&endyr. percentwhite_20&endyr. percentcollege_20&endyr. avghhinc_20&endyr. popwhitenonhispbridge_&_years. 
	 popwithrace_&_years. numrenteroccupiedhu_&_years. numowneroccupiedhu_&_years. pop25andoverwcollege_&_years. pop25andoveryears_&_years. 
	agghshldincome_&_years.  numhshlds_&_years. medianhomevalue_&_years. percentinclt75000 hshldincunder15000_&_years. hshldinc15000to34999_&_years.
	hshldinc35000to49999_&_years.  hshldinc50000to74999_&_years. medfamincm_&_years. MedHHIncm_&_years. numowneroccupiedhu_&_years. percentrenter_20&endyr. percentwhite_20&endyr. percentcollege_20&endyr. avghhinc_20&endyr.;

	county= substr(geo2010,1,5);
	percentrenter_20&endyr.= numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years.+numowneroccupiedhu_&_years.);
	percentwhite_20&endyr.= popwhitenonhispbridge_&_years./popwithrace_&_years.;
	percentcollege_20&endyr.= pop25andoverwcollege_&_years./pop25andoveryears_&_years.;
	avghhinc_20&endyr.= agghshldincome_&_years./(numhshlds_&_years. );
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

proc sort data=demographics&endyr.;
	by geo2010;
run;

data demographics00(where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
	set NCDB.Ncdb_master_update;
	keep geo2010 county Jurisdiction percentrenter_00 percentwhite_00 percentcollege_00 sprntoc0 spownoc0 shr0d SHRNHW0N educpp0 educ160 
		 AVHHIN0N agghhinc_00a avhhin0 avghhinc_00a avghhinc_00
		 numhhs0 percentinclt75000_00 thy0100 thy0150 thy0200 thy0250 thy0300 thy0350 thy0400 thy0450 thy0500 thy0600 thy0750 mdfamy0 mdhhy0 mdfamy0a mdhhy0a;
	county= substr(geo2010,1,5);
	percentrenter_00= sprntoc0/(sprntoc0+spownoc0);
	percentwhite_00= SHRNHW0N/shr0d;
	percentcollege_00= educ160/educpp0;
	avghhinc_00= avhhin0;
	percentinclt75000_00= (thy0100+thy0150+thy0200+thy0250+thy0300+thy0350+thy0400+thy0450+thy0500+thy0600+thy0750)/numhhs0; 
	
	%dollar_convert( AVHHIN0N, agghhinc_00a, 1999, 20&endyr., series=CUUR0000SA0 )
	%dollar_convert( avghhinc_00, avghhinc_00a, 1999, 20&endyr., series=CUUR0000SA0 )
	%dollar_convert( mdfamy0, mdfamy0a, 1999, 20&endyr., series=CUUR0000SA0 )
    %dollar_convert( mdhhy0, mdhhy0a, 1999, 20&endyr., series=CUUR0000SA0 )

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

proc sort data=demographics00;
by geo2010;
run;

data changeintime;
merge demographics&endyr. demographics00;
by geo2010;
COG=1;
deltarenter = numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years.+numowneroccupiedhu_&_years.)- sprntoc0/(sprntoc0+spownoc0);
deltawhite= percentwhite_20&endyr.- percentwhite_00;
deltacollege= percentcollege_20&endyr.- percentcollege_00;
deltahhinc= (avghhinc_20&endyr.-avghhinc_00a)/avghhinc_00a;
deltahhinc75000= percentinclt75000-percentinclt75000_00; /* 75,000 is as close as we can get to 80% MFI */
deltamedianfaminc= (medfamincm_&_years. - mdfamy0a)/mdfamy0a;
deltamedianHHinc= (MedHHIncm_&_years. - mdhhy0a)/mdhhy0a;
run;

proc means data=changeintime median;
run;
proc sort data=changeintime;
by jurisdiction;
proc summary data= changeintime;
	by Jurisdiction;
	var numrenteroccupiedhu_&_years. numowneroccupiedhu_&_years. popwhitenonhispbridge_&_years. popwithrace_&_years. pop25andoverwcollege_&_years. pop25andoveryears_&_years.
		agghshldincome_&_years. numhshlds_&_years. agghhinc_00a sprntoc0 spownoc0 SHRNHW0N shr0d educ160 educpp0 numhhs0 hshldincunder15000_&_years.  hshldinc15000to34999_&_years.
		hshldinc35000to49999_&_years.  hshldinc50000to74999_&_years. numowneroccupiedhu_&_years. thy0100 thy0150 thy0200 thy0250 thy0300 thy0350 thy0400 thy0450 thy0500 thy0600 thy0750 ;
	output out = vulnerable_20&endyr.  sum=;
run;

/*calculate vulnerability threshold based on Jurisdiction total*/
data vulnerablethreshold (keep = Jurisdiction threshold_renter_20&endyr. threshold_white_20&endyr. threshold_hhinc_20&endyr. threshold_college_20&endyr. threshold_75000_20&endyr. 
								 threshold_deltarenter threshold_deltawhite threshold_deltacollege threshold_deltahhinc threshold_delta75000)
						  ;
	set vulnerable_20&endyr. (drop=_type_ _freq_) ;

	percentrenter_20&endyr.= numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years.+numowneroccupiedhu_&_years.);
	percentwhite_20&endyr.= popwhitenonhispbridge_&_years./popwithrace_&_years.;
	percentcollege_20&endyr.= pop25andoverwcollege_&_years./pop25andoveryears_&_years.;
	avghhinc_20&endyr.= agghshldincome_&_years./(numhshlds_&_years. );
	percentinclt75000= (hshldincunder15000_&_years. + hshldinc15000to34999_&_years.+ hshldinc35000to49999_&_years.+ hshldinc50000to74999_&_years.)/(numhshlds_&_years. );

	deltarenter = numrenteroccupiedhu_&_years./(numrenteroccupiedhu_&_years. +numowneroccupiedhu_&_years.)- sprntoc0/(sprntoc0+spownoc0);
	deltawhite= popwhitenonhispbridge_&_years./popwithrace_&_years.- SHRNHW0N/shr0d;
	deltacollege= pop25andoverwcollege_&_years./pop25andoveryears_&_years. - educ160/educpp0;

	deltahhinc= ((agghshldincome_&_years. /numhshlds_&_years.)-(agghhinc_00a/numhhs0));
	deltahhinc75000= (hshldincunder15000_&_years. + hshldinc15000to34999_&_years.+ hshldinc35000to49999_&_years.+ hshldinc50000to74999_&_years.)/(numhshlds_&_years. )- 
					 (thy0100+thy0150+thy0200+thy0250+thy0300+thy0350+thy0400+thy0450+thy0500+thy0600+thy0750)/numhhs0;

	rename 							percentrenter_20&endyr.=threshold_renter_20&endyr. 
									percentwhite_20&endyr.=threshold_white_20&endyr.
									avghhinc_20&endyr.=threshold_hhinc_20&endyr.
									percentcollege_20&endyr.=threshold_college_20&endyr.
									percentinclt75000=threshold_75000_20&endyr.
									deltarenter=threshold_deltarenter 
									deltawhite=threshold_deltawhite
									deltacollege= threshold_deltacollege
									deltahhinc=threshold_deltahhinc
									deltahhinc75000=threshold_delta75000;
run;

/*compile county level median 2000 and 20&endyr. to calculate Jurisdiction level median income change threshold*/
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
set ACS.Acs_&_years._dc_sum_regcnt_regcnt ACS.Acs_&_years._md_sum_regcnt_regcnt ACS.Acs_&_years._va_sum_regcnt_regcnt ACS.Acs_&_years._wv_sum_regcnt_regcnt ; 
keep Jurisdiction county medfamincm_&_years. MedHHIncm_&_years. mdfamy0a mdhhy0a;
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

	%dollar_convert( mdfamy0, mdfamy0a, 1999, 20&endyr., series=CUUR0000SA0 )
    %dollar_convert( mdhhy0, mdhhy0a, 1999, 20&endyr., series=CUUR0000SA0 )

run;
proc sort data=countylevelmedian;
by jurisdiction;
proc summary data=countylevelmedian;
by Jurisdiction ;
var medfamincm_&_years. MedHHIncm_&_years. mdfamy0a  mdhhy0a;
output out=jurisdictionmedian mean=;
run;


data medianincomechange;
set jurisdictionmedian ;

threshold_deltamedian= (medfamincm_&_years.- mdfamy0a)/mdfamy0a;
threshold_deltamedianH= (MedHHIncm_&_years.- mdhhy0a)/mdhhy0a;
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
		if percentrenter_20&endyr. >= threshold_renter_20&endyr. then vulnerable_renter =1;
	    else if percentrenter_20&endyr.< threshold_renter_20&endyr. then vulnerable_renter =0;
		else if percentrenter_20&endyr.=. then vulnerable_renter =.;

		if percentwhite_20&endyr.<= threshold_white_20&endyr. then vulnerable_POC=1;
		else if percentwhite_20&endyr.> threshold_white_20&endyr. then vulnerable_POC=0;
		else if percentwhite_20&endyr.=. then vulnerable_POC=.;

		if percentcollege_20&endyr.<= threshold_college_20&endyr. then vulnerable_college=1;
		else if percentcollege_20&endyr. > threshold_college_20&endyr. then vulnerable_college=0;
		else if percentcollege_20&endyr.=. then vulnerable_college=.;

		if percentinclt75000 <= threshold_75000_20&endyr. then vulnerable_inc=1; 
		else if percentinclt75000> threshold_75000_20&endyr. then vulnerable_inc=0;
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
keep geo2010 county Jurisdiction vulnerable demographicchange_MFAM demographicchange_MHH percentrenter_20&endyr. percentwhite_20&endyr. percentcollege_20&endyr. avghhinc_20&endyr.
popwhitenonhispbridge_&_years. popwithrace_&_years. numrenteroccupiedhu_&_years. numowneroccupiedhu_&_years. pop25andoverwcollege_&_years. pop25andoveryears_&_years. 
agghshldincome_&_years.  numhshlds_&_years. medianhomevalue_&_years. gentrifier_white gentrifier_college ;

format vulnerable signofrisk. demographicchange_MHH   demographicchange_MFAM signofrisk. ;

if numhshlds_&_years. < 100 then do; vulnerable =.n; demographicchange_MHH=.n; demographicchange_MFAM=.n; end;
run;


/*Calculate appreciation of home values and rank baseline median home values*/

data housing1990(where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
set NCDB.Ncdb_master_update;
keep geo2010 county Jurisdiction mdvalhs9 mdvalhs9_a mdvalhs0 mdvalhs0_a  SPOWNOC9 SPOWNOC0;
county= substr(geo2010,1,5);
%dollar_convert( mdvalhs0, mdvalhs0_a, 2000, 20&endyr., series=CUUR0000SA0L2 )
%dollar_convert( mdvalhs9, mdvalhs9_a, 1990, 20&endyr., series=CUUR0000SA0L2 )
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
keep geo2010 geoid county SPOWNOC9 SPOWNOC0 numowneroccupiedhu_&_years.  Jurisdiction mdvalhs9_a mdvalhs0_a medianhomevalue_&_years. appre90_&endyr. appre00_&endyr.;
by geo2010;

if SPOWNOC9 < 50 then mdvalhs9_a=.n ;
if SPOWNOC0 < 50 then mdvalhs0_a=.n; 
if numowneroccupiedhu_&_years. < 50 then medianhomevalue_&_years.=.n; 

	if (mdvalhs9_a ~= .n and medianhomevalue_&_years. ~=.n) then appre90_&endyr. = (medianhomevalue_&_years.- mdvalhs9_a)/ mdvalhs9_a; else appre90_&endyr.=.n;
	if ( mdvalhs0_a ~= .n and medianhomevalue_&_years. ~=.n) then appre00_&endyr. = (medianhomevalue_&_years.-mdvalhs0_a)/mdvalhs0_a; else appre00_&endyr.=.n; 
	geoid=geo2010;
run;
proc means data=housingmarket;
run;

/*need to rank the tracts by Jurisdiction*/
proc sort data=housingmarket;
by jurisdiction;
proc rank data=housingmarket out=valuehousing groups=5;
 by jurisdiction;
 var mdvalhs9_a mdvalhs0_a medianhomevalue_&_years. appre90_&endyr. appre00_&endyr.;
 ranks rank90 rank2000 rank20&endyr. rank90_&endyr. rank00_&endyr. ;
run;

data appreciationtracts;
set valuehousing;

if rank90 >=0 and rank20&endyr. >=0  & rank90_&endyr. >=0  then do; 
	if rank90 <= 2 &  rank20&endyr. >=3 & rank90_&endyr. >= 3 then appreciated =1; else appreciated =0;
	end; 
else if rank90 < 0 or rank20&endyr. < 0 or rank90_&endyr. < 0 then appreciated=.n; 

if rank20&endyr. >=0 and rank00_&endyr. >=0 then do; 
	if rank20&endyr.<=2 & rank00_&endyr. >=3 then accelerating=1;else accelerating=0;
	end; 
else if rank20&endyr. < 0 or rank00_&endyr. < 0 then accelerating=.n; 

if rank20&endyr. >=0 and rank00_&endyr. >=0 then do;
	if  rank20&endyr.<=2 & rank00_&endyr. <=2 then potentialADJ=1; else potentialADJ=0;
	end;
else if rank20&endyr. < 0 or rank00_&endyr. < 0 then potentialADJ=.n;

if rank20&endyr. >=0 and appre00_&endyr.>=0 then do;
    if rank20&endyr.>=3 or appre00_&endyr.>=3 then adjacentbase=1; else adjacentbase=0;
	end;
else if rank20&endyr. < 0 or appre00_&endyr. < 0 then adjacentbase=.n;

run;

proc freq data=appreciationtracts;
tables appreciated accelerating potentialADJ adjacentbase;
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

data Householdcounts (where=(county in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600","51610", "51683", "51685" )));
set ACS.Acs_&_years._dc_sum_tr_tr10 ACS.Acs_&_years._md_sum_tr_tr10 ACS.Acs_&_years._va_sum_tr_tr10 ACS.Acs_&_years._wv_sum_tr_tr10;

keep geo2010 county Jurisdiction medhhincm_&_years. numhshlds_&_years. hhunder75000 ;

	county= substr(geo2010,1,5);
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

hhunder75000= numhshlds_&_years.- (hshldinc75000to99999_&_years.+hshldinc100000plus_&_years.);

run;

data completetypology;
merge flag_population appreciationtracts Householdcounts ;
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

proc import out=adjacentflag  datafile="L:\Libraries\RegHsg\Maps\adjacent flag.CSV"
            DBMS=CSV REPLACE;
			GUESSINGROWS=MAX;
RUN;

data adjacentflag2 ;
set adjacentflag(drop=GEOID);
geo2010char= put(geo2010, 11.);
run;

data adjacentflag2 ;
set adjacentflag2 ;
keep geoid DCMetroArea2015_tr10_adjacent;
geoid= geo2010char;
run;

proc sort data= adjacentflag2;
by geoid;
run;

data allflags;
merge completetypology adjacentflag2;
by geoid;
run;

proc freq data=allflags;
tables potentialADJ*DCMetroArea2015_tr10_adjacent/missprint;
run;
proc format;

	value type
	1= "Susceptible"
	2= "Early: Type 1"
	3="Early: Type 2"
	4="Dynamic"
	5="Late"
	6="Continued Loss"
	7= "Low-moderate value: not at risk";

	value Jurisdiction
    1= "District of Columbia"
	2= "Charles County"
	3= "Frederick County "
	4="Montgomery County"
	5="Prince George's County"
	6="Arlington County"
	7="Fairfax, Fairfax City, and Falls Church"
	8="Loudoun County"
	9="Prince William, Manassas, and Manassas Park"
    10="City of Alexandria";


run;
data gentrificationstage;
set allflags;
keep Geo2010 geoid Jurisdiction vulnerable demographicchange_MHH demographicchange_MFAM accelerating appreciated potentialADJ DCMetroArea2015_tr10_adjacent neighborhoodtypeFAM 
neighborhoodtypeHH neighborhoodtypeFAMcode neighborhoodtypeHHcode numhshlds_&_years. hhunder75000 ;

if vulnerable=1 and demographicchange_MHH=0 and DCMetroArea2015_tr10_adjacent=1 then neighborhoodtypeHH=1;
if vulnerable=1 and demographicchange_MHH=0 and accelerating=1 then neighborhoodtypeHH=2;
if vulnerable=1 and demographicchange_MHH=1 and DCMetroArea2015_tr10_adjacent=1 then neighborhoodtypeHH=3;
if vulnerable=1 and demographicchange_MHH=1 and accelerating=1 then neighborhoodtypeHH=4;
if vulnerable=1 and demographicchange_MHH=1 and appreciated=1 then neighborhoodtypeHH=5;
if vulnerable=0 and gentrifier_white=1 and gentrifier_college=1 and appreciated=1 then neighborhoodtypeHH=6;
if rank2017 =<2 and neighborhoodtypeHH=. then neighborhoodtypeHH=7;


if vulnerable=1 and demographicchange_MFAM=0 and DCMetroArea2015_tr10_adjacent=1 then neighborhoodtypeFAM=1;
if vulnerable=1 and demographicchange_MFAM=0 and accelerating=1 then neighborhoodtypeFAM=2;
if vulnerable=1 and demographicchange_MFAM=1 and DCMetroArea2015_tr10_adjacent=1 then neighborhoodtypeFAM=3;
if vulnerable=1 and demographicchange_MFAM=1 and accelerating=1 then neighborhoodtypeFAM=4;
if vulnerable=1 and demographicchange_MFAM=1 and appreciated=1 then neighborhoodtypeFAM=5;
if vulnerable=0 and gentrifier_white=1 and gentrifier_college=1 and appreciated=1 then neighborhoodtypeFAM=6;
if rank2017 =<2 and neighborhoodtypeFAM=. then neighborhoodtypeFAM=7;

format neighborhoodtypeFAM neighborhoodtypeHH type. Jurisdiction Jurisdiction. ;

neighborhoodtypeFAMcode= neighborhoodtypeFAM;
neighborhoodtypeHHcode= neighborhoodtypeHH;

run;
proc print data=gentrificationstage;
where jurisdiction=.;
run;

proc export data = gentrificationstage
   outfile="&_dcdata_default_path\RegHsg\Prog\Neighborhood typology for mapping.csv"
   dbms=csv
   replace;
run;

proc sort data=gentrificationstage;
by jurisdiction neighborhoodtypeHH ;
proc summary data=gentrificationstage;
by jurisdiction neighborhoodtypeHH;
var numhshlds_&_years. hhunder75000;
output out=juris_HHcounts_indexHH sum=;
where jurisdiction ne . ;
run;
proc sort data=gentrificationstage;
by neighborhoodtypeHH;
proc summary data=gentrificationstage;
by neighborhoodtypeHH;
var numhshlds_&_years. hhunder75000;
output out=region_HHcounts_indexHH sum=;
where jurisdiction ne . ;

run;

data HHcounts_typologywithHH (drop=_type_);
set region_HHcounts_indexHH juris_HHcounts_indexHH;

rename _freq_=NumTracts;
run; 
proc sort data=gentrificationstage;
by jurisdiction neighborhoodtypeFAM ;
proc summary data=gentrificationstage;
by jurisdiction neighborhoodtypeFAM;
var numhshlds_&_years. hhunder75000;
output out=juris_HHcounts_indexFAM sum=;
where jurisdiction ne . ;
run;
proc sort data=gentrificationstage;
by neighborhoodtypeFAM;
proc summary data=gentrificationstage;
by neighborhoodtypeFAM;
var numhshlds_&_years. hhunder75000;
output out=region_HHcounts_indexFAM sum=;
where jurisdiction ne . ;

run;

data HHcounts_typologywithFAM (drop=_type_);
set region_HHcounts_indexFAM juris_HHcounts_indexFAM;


rename _freq_=NumTracts;
run; 
proc export data = HHcounts_typologywithFAM
   outfile="&_dcdata_default_path\RegHsg\Prog\HH Counts-Typology with Median Family Inc.csv"
   dbms=csv
   replace;
run;
proc export data = HHcounts_typologywithHH
   outfile="&_dcdata_default_path\RegHsg\Prog\HH Counts-Typology with Median HH Inc.csv"
   dbms=csv
   replace;
run;
