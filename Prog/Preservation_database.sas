/**************************************************************************
 Program:  Preservation_database.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   W. Oliver
 Created:  01/11/19
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
download for whole metro area or states if easier. We would like to be able to understand where properties are located, how many units are subsidized (at what level if known), subsidy programs involved, and any expiration dates for the subsidies.

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
%DCData_lib( RegHsg, local=n )
 
data WORK.Test (where=(CBSACode="47900"))    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'L:\Libraries\RegHsg\Raw\Preservation Database\Active and Inconclusive Properties.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2;
   format NHPDPropertyID $36. ;
   format PropertyName $25. ;
   format PropertyAddress $32. ;
   format City $15. ;
   format State $2. ;
   format Zip $10. ;
   format CBSACode $5. ;
   format CBSAType $29. ;
   format County $25. ;
   format CountyCode $5. ;
   format CensusTract best12. ;
   format CongressionalDistrict $10. ;
   format Latitude best12. ;
   format Longitude best12. ;
   format PropertyStatus $15. ;
   format ActiveSubsidies best12. ;
   format TotalInconclusiveSubsidies best12. ;
   format TotalInactiveSubsidies best12. ;
   format TotalUnits best12. ;
   informat EarliestStartDate mmddyy10. ;
   format EarliestStartDate mmddyy10. ;
   informat EarliestEndDate mmddyy10. ;
   format EarliestEndDate mmddyy10. ;
   informat LatestEndDate mmddyy10. ;
   format LatestEndDate mmddyy10. ;
   format Owner $34. ;
   format OwnerType $15. ;
   format ManagerName $38. ;
   format ManagerType $15. ;
   format HUDPropertyID best12. ;
   format ReacScore1 $4. ;
   informat ReacScore1Date mmddyy10. ;
   format ReacScore1Date mmddyy10. ;
   format ReacScore2 $3. ;
   informat ReacScore2Date mmddyy10. ;
   format ReacScore2Date mmddyy10. ;
   format ReacScore3 $3. ;
   informat ReacScore3Date mmddyy10. ;
   format ReacScore3Date mmddyy10. ;
   format ZeroOneBedroomUnits best12. ;
   format TwoBedroomUnits best12. ;
   format ThreePlusBedroomUnits best12. ;
   format PercentofELIHouseholds $15. ;
   format TargetTenantType $8. ;
   format FairMarketRent_2BR best12. ;
   informat EarliestConstructionDate mmddyy10. ;
   format EarliestConstructionDate mmddyy10. ;
   informat LatestConstructionDate mmddyy10. ;
   format LatestConstructionDate mmddyy10. ;
   format OccupancyRate $15. ;
   format AverageMonthsOfTenancy $15. ;
   format NumberActiveSection8 best12. ;
   format NumberInconclusiveSection8 best12. ;
   format NumberInactiveSection8 best12. ;
   format S8_1_ID $15. ;
   format S8_1_Status $15. ;
   format S8_1_ProgramName $15. ;
   format S8_1_RenewalStatus $15. ;
   informat S8_1_StartDate mmddyy10. ;
   format S8_1_StartDate mmddyy10. ;
   informat S8_1_EndDate mmddyy10. ;
   format S8_1_EndDate mmddyy10. ;
   format S8_1_AssistedUnits best12. ;
   format S8_1_RentToFMR $15. ;
   format S8_1_InacStatusDesc $15. ;
   format S8_2_ID $15. ;
   format S8_2_Status $15. ;
   format S8_2_ProgramName $15. ;
   format S8_2_RenewalStatus $15. ;
   informat S8_2_StartDate mmddyy10. ;
   format S8_2_StartDate mmddyy10. ;
   informat S8_2_EndDate mmddyy10.;
   format S8_2_EndDate mmddyy10.;
   format S8_2_AssistedUnits best12. ;
   format S8_2_RentToFMR $15. ;
   format S8_2_InacStatusDesc $15. ;
   format NumberActiveSection202 best12. ;
   format NumberInconclusiveSection202 best12. ;
   format NumberInactiveSection202 best12. ;
   format S202_1_ID $15. ;
   format S202_1_Status $15. ;
   format S202_1_ProgramName $15. ;
   informat S202_1_StartDate mmddyy10. ;
   format S202_1_StartDate mmddyy10. ;
   informat S202_1_EndDate mmddyy10.;
   format S202_1_EndDate mmddyy10.;
   format S202_1_AssistedUnits best12. ;
   format S202_1_PrincipalBalance $15. ;
   format S202_1_InacStatusDesc $15. ;
   format S202_2_ID $15. ;
   format S202_2_Status $15. ;
   format S202_2_ProgramName $15. ;
   informat S202_2_StartDate mmddyy10. ;
   format S202_2_StartDate mmddyy10. ;
   informat S202_2_EndDate mmddyy10.;
   format S202_2_EndDate mmddyy10.;
   format S202_2_AssistedUnits best12. ;
   format S202_2_PrincipalBalance $15. ;
   format S202_2_InacStatusDesc $15. ;
   format NumberActiveSection236 best12. ;
   format NumberInconclusiveSection236 best12. ;
   format NumberInactiveSection236 best12. ;
   format S236_1_ID $15. ;
   format S236_1_Status $15. ;
   format S236_1_ProgramName $15. ;
   informat S236_1_StartDate mmddyy10. ;
   format S236_1_StartDate mmddyy10. ;
   informat S236_1_EndDate mmddyy10. ;
   format S236_1_EndDate mmddyy10. ;
   format S236_1_AssistedUnits best12. ;
   format S236_1_InacStatusDesc $15. ;
   format S236_2_ID $15. ;
   format S236_2_Status $15. ;
   format S236_2_ProgramName $15. ;
   informat S236_2_StartDate mmddyy10. ;
   format S236_2_StartDate mmddyy10. ;
   informat S236_2_EndDate mmddyy10. ;
   format S236_2_EndDate mmddyy10. ;
   format S236_2_AssistedUnits best12. ;
   format S236_2_InacStatusDesc $15. ;
   format NumberActiveHUDInsured best12. ;
   format NumberInconclusiveHUDInsured best12. ;
   format NumberInactiveHud best12. ;
   format FHA_1_ID best12. ;
   format FHA_1_Status $15. ;
   format FHA_1_ProgramName $26. ;
   informat FHA_1_StartDate mmddyy10. ;
   format FHA_1_StartDate mmddyy10. ;
   informat FHA_1_EndDate mmddyy10. ;
   format FHA_1_EndDate mmddyy10. ;
   format FHA_1_AssistedUnits best12. ;
   format FHA_1_PrincipalBalance best12. ;
   format FHA_1_InacStatusDesc $15. ;
   format FHA_2_ID $15. ;
   format FHA_2_Status $15. ;
   format FHA_2_ProgramName $26. ;
   informat FHA_2_StartDate mmddyy10. ;
   format FHA_2_StartDate mmddyy10. ;
   informat FHA_2_EndDate mmddyy10. ;
   format FHA_2_EndDate mmddyy10. ;
   format FHA_2_AssistedUnits best12. ;
   format FHA_2_PrincipalBalance best12. ;
   format FHA_2_InacStatusDesc $15. ;
   format NumberActiveLihtc best12. ;
   format NumberInconclusiveLihtc best12. ;
   format NumberInactiveLihtc best12. ;
   format LIHTC_1_ID $15. ;
   format LIHTC_1_Status $15. ;
   format LIHTC_1_ProgramName $15. ;
   informat LIHTC_1_StartDate mmddyy10. ;
   format LIHTC_1_StartDate mmddyy10. ;
   informat LIHTC_1_EndDate mmddyy10. ;
   format LIHTC_1_EndDate mmddyy10. ;
   format LIHTC_1_AssistedUnits best12. ;
   format LIHTC_1_ConstructionType $25. ;
   format LIHTC_1_InacStatusDesc $15. ;
   format LIHTC_2_ID $10. ;
   format LIHTC_2_Status $6. ;
   format LIHTC_2_ProgramName $15. ;
   informat LIHTC_2_StartDate mmddyy10. ;
   format LIHTC_2_StartDate mmddyy10. ;
   informat LIHTC_2_EndDate mmddyy10. ;
   format LIHTC_2_EndDate mmddyy10. ;
   format LIHTC_2_AssistedUnits best12. ;
   format LIHTC_2_ConstructionType $25. ;
   format LIHTC_2_InacStatusDesc $15. ;
   format NumberActiveSection515 best12. ;
   format NumberInconclusiveSection515 best12. ;
   format NumberInactiveSection515 best12. ;
   format RHS515_1_ID best12. ;
   format RHS515_1_Status $6. ;
   format RHS515_1_ProgramName $15. ;
   informat RHS515_1_StartDate mmddyy10. ;
   format RHS515_1_StartDate mmddyy10. ;
   informat RHS515_1_EndDate mmddyy10. ;
   format RHS515_1_EndDate mmddyy10. ;
   format RHS515_1_AssistedUnits best12. ;
   format RHS515_1_PrincipalBalance $1. ;
   format RHS515_1_InacStatusDesc $1. ;
   format RHS515_2_ID best12. ;
   format RHS515_2_Status $6. ;
   format RHS515_2_ProgramName $15. ;
   informat RHS515_2_StartDate mmddyy10. ;
   format RHS515_2_StartDate mmddyy10. ;
   informat RHS515_2_EndDate mmddyy10. ;
   format RHS515_2_EndDate mmddyy10. ;
   format RHS515_2_AssistedUnits best12. ;
   format RHS515_2_PrincipalBalance $1. ;
   format RHS515_2_InacStatusDesc $1. ;
   format NumberActiveSection538 best12. ;
   format NumberInconclusiveSection538 best12. ;
   format NumberInactiveSection538 best12. ;
   format RHS538_1_ID $15. ;
   format RHS538_1_Status $15. ;
   format RHS538_1_ProgramName $15. ;
   informat RHS538_1_StartDate mmddyy10. ;
   format RHS538_1_StartDate mmddyy10. ;
   informat RHS538_1_EndDate mmddyy10. ;
   format RHS538_1_EndDate mmddyy10. ;
   format RHS538_1_AssistedUnits best12. ;
   format RHS538_1_PrincipalBalance $1. ;
   format RHS538_1_InacStatusDesc $15. ;
   format RHS538_2_ID $15. ;
   format RHS538_2_Status $15. ;
   format RHS538_2_ProgramName $15. ;
   informat RHS538_2_StartDate mmddyy10. ;
   format RHS538_2_StartDate mmddyy10. ;
   informat RHS538_2_EndDate mmddyy10. ;
   format RHS538_2_EndDate mmddyy10. ;
   format RHS538_2_AssistedUnits best12. ;
   format RHS538_2_PrincipalBalance $1. ;
   format RHS538_2_InacStatusDesc $15. ;
   format NumberActiveHome best12. ;
   format NumberInconclusiveHome best12. ;
   format NumberInactiveHome best12. ;
   format HOME_1_ID best12. ;
   format HOME_1_Status $6. ;
   format HOME_1_ProgramName $15. ;
   informat HOME_1_StartDate mmddyy10. ;
   format HOME_1_StartDate mmddyy10. ;
   informat HOME_1_EndDate mmddyy10. ;
   format HOME_1_EndDate mmddyy10. ;
   format HOME_1_AssistedUnits best12. ;
   format HOME_1_ConstructionType $16. ;
   format HOME_1_InacStatusDesc $15. ;
   format HOME_2_ID $15. ;
   format HOME_2_Status $15. ;
   format HOME_2_ProgramName $15. ;
   informat HOME_2_StartDate mmddyy10. ;
   format HOME_2_StartDate mmddyy10. ;
   informat HOME_2_EndDate mmddyy10. ;
   format HOME_2_EndDate mmddyy10. ;
   format HOME_2_AssistedUnits best12. ;
   format HOME_2_ConstructionType $15. ;
   format HOME_2_InacStatusDesc $15. ;
   format NumberActivePublicHousing best12. ;
   format NumberInconclusivePublicHousing best12. ;
   format NumberInactivePublicHousing best12. ;
   format PH_1_ID $15. ;
   format PH_1_Status $15. ;
   format PH_1_ProgramName $15. ;
   informat PH_1_StartDate mmddyy10. ;
   format PH_1_StartDate mmddyy10. ;
   informat PH_1_EndDate mmddyy10. ;
   format PH_1_EndDate mmddyy10. ;
   format PH_1_AssistedUnits best12. ;
   format PH_1_InacStatusDesc $15. ;
   format PH_1_PhaCode $15. ;
   format PH_2_ID $15. ;
   format PH_2_Status $15. ;
   format PH_2_ProgramName $15. ;
   informat PH_2_StartDate mmddyy10. ;
   format PH_2_StartDate mmddyy10. ;
   informat PH_2_EndDate mmddyy10. ;
   format PH_2_EndDate mmddyy10. ;
   format PH_2_AssistedUnits best12. ;
   format PH_2_InacStatusDesc $15. ;
   format PH_2_PhaCode $15. ;
   format NumberActiveState best12. ;
   format NumberInconclusiveState best12. ;
   format NumberInactiveState best12. ;
   format State_1_ID $15. ;
   format State_1_Status $15. ;
   format State_1_ProgramName $16. ;
   informat State_1_StartDate mmddyy10. ;
   format State_1_StartDate mmddyy10. ;
   informat State_1_EndDate mmddyy10. ;
   format State_1_EndDate mmddyy10. ;
   format State_1_AssistedUnits best12. ;
   format State_1_InacStatusDesc $16. ;
   format State_1_ConstructionType $16. ;
   format State_2_ID $15. ;
   format State_2_Status $15. ;
   format State_2_ProgramName $16. ;
   informat State_2_StartDate mmddyy10. ;
   format State_2_StartDate mmddyy10. ;
   informat State_2_EndDate mmddyy10. ;
   format State_2_EndDate mmddyy10. ;
   format State_2_AssistedUnits best12. ;
   format State_2_InacStatusDesc $16. ;
   format State_2_ConstructionType $16. ;
input
            NHPDPropertyID $
            PropertyName $
            PropertyAddress $
            City $
            State $
            Zip $
            CBSACode $
            CBSAType $
            County $
            CountyCode $
            CensusTract
            CongressionalDistrict
            Latitude
            Longitude
            PropertyStatus $
            ActiveSubsidies
            TotalInconclusiveSubsidies
            TotalInactiveSubsidies
            TotalUnits
            EarliestStartDate
            EarliestEndDate
            LatestEndDate
            Owner $
            OwnerType $
            ManagerName $
            ManagerType $
            HUDPropertyID
            ReacScore1 $
            ReacScore1Date
            ReacScore2 $
            ReacScore2Date
            ReacScore3 $
            ReacScore3Date
            ZeroOneBedroomUnits
            TwoBedroomUnits
            ThreePlusBedroomUnits
            PercentofELIHouseholds $
            TargetTenantType $
            FairMarketRent_2BR
            EarliestConstructionDate
            LatestConstructionDate
            OccupancyRate $
            AverageMonthsOfTenancy $
            NumberActiveSection8
            NumberInconclusiveSection8
            NumberInactiveSection8
            S8_1_ID $
            S8_1_Status $
            S8_1_ProgramName $
            S8_1_RenewalStatus $
            S8_1_StartDate $
            S8_1_EndDate $
            S8_1_AssistedUnits 
            S8_1_RentToFMR $
            S8_1_InacStatusDesc $
            S8_2_ID $
            S8_2_Status $
            S8_2_ProgramName $
            S8_2_RenewalStatus $
            S8_2_StartDate $
            S8_2_EndDate $
            S8_2_AssistedUnits 
            S8_2_RentToFMR $
            S8_2_InacStatusDesc $
            NumberActiveSection202
            NumberInconclusiveSection202
            NumberInactiveSection202
            S202_1_ID $
            S202_1_Status $
            S202_1_ProgramName $
            S202_1_StartDate $
            S202_1_EndDate $
            S202_1_AssistedUnits 
            S202_1_PrincipalBalance $
            S202_1_InacStatusDesc $
            S202_2_ID $
            S202_2_Status $
            S202_2_ProgramName $
            S202_2_StartDate $
            S202_2_EndDate $
            S202_2_AssistedUnits 
            S202_2_PrincipalBalance $
            S202_2_InacStatusDesc $
            NumberActiveSection236
            NumberInconclusiveSection236
            NumberInactiveSection236
            S236_1_ID $
            S236_1_Status $
            S236_1_ProgramName $
            S236_1_StartDate $
            S236_1_EndDate $
            S236_1_AssistedUnits 
            S236_1_InacStatusDesc $
            S236_2_ID $
            S236_2_Status $
            S236_2_ProgramName $
            S236_2_StartDate $
            S236_2_EndDate $
            S236_2_AssistedUnits 
            S236_2_InacStatusDesc $
            NumberActiveHUDInsured
            NumberInconclusiveHUDInsured
            NumberInactiveHud
            FHA_1_ID
            FHA_1_Status $
            FHA_1_ProgramName $
            FHA_1_StartDate
            FHA_1_EndDate
            FHA_1_AssistedUnits
            FHA_1_PrincipalBalance
            FHA_1_InacStatusDesc $
            FHA_2_ID
            FHA_2_Status $
            FHA_2_ProgramName $
            FHA_2_StartDate
            FHA_2_EndDate
            FHA_2_AssistedUnits
            FHA_2_PrincipalBalance
            FHA_2_InacStatusDesc $
            NumberActiveLihtc
            NumberInconclusiveLihtc
            NumberInactiveLihtc
            LIHTC_1_ID $
            LIHTC_1_Status $
            LIHTC_1_ProgramName $
            LIHTC_1_StartDate
            LIHTC_1_EndDate
            LIHTC_1_AssistedUnits
            LIHTC_1_ConstructionType $
            LIHTC_1_InacStatusDesc $
            LIHTC_2_ID $
            LIHTC_2_Status $
            LIHTC_2_ProgramName $
            LIHTC_2_StartDate
            LIHTC_2_EndDate
            LIHTC_2_AssistedUnits
            LIHTC_2_ConstructionType $
            LIHTC_2_InacStatusDesc $
            NumberActiveSection515
            NumberInconclusiveSection515
            NumberInactiveSection515
            RHS515_1_ID
            RHS515_1_Status $
            RHS515_1_ProgramName $
            RHS515_1_StartDate
            RHS515_1_EndDate
            RHS515_1_AssistedUnits
            RHS515_1_PrincipalBalance $
            RHS515_1_InacStatusDesc $
            RHS515_2_ID
            RHS515_2_Status $
            RHS515_2_ProgramName $
            RHS515_2_StartDate
            RHS515_2_EndDate
            RHS515_2_AssistedUnits
            RHS515_2_PrincipalBalance $
            RHS515_2_InacStatusDesc $
            NumberActiveSection538
            NumberInconclusiveSection538
            NumberInactiveSection538
            RHS538_1_ID $
            RHS538_1_Status $
            RHS538_1_ProgramName $
            RHS538_1_StartDate $
            RHS538_1_EndDate $
            RHS538_1_AssistedUnits 
            RHS538_1_PrincipalBalance $
            RHS538_1_InacStatusDesc $
            RHS538_2_ID $
            RHS538_2_Status $
            RHS538_2_ProgramName $
            RHS538_2_StartDate $
            RHS538_2_EndDate $
            RHS538_2_AssistedUnits 
            RHS538_2_PrincipalBalance $
            RHS538_2_InacStatusDesc $
            NumberActiveHome
            NumberInconclusiveHome
            NumberInactiveHome
            HOME_1_ID
            HOME_1_Status $
            HOME_1_ProgramName $
            HOME_1_StartDate
            HOME_1_EndDate
            HOME_1_AssistedUnits
            HOME_1_ConstructionType $
            HOME_1_InacStatusDesc $
            HOME_2_ID $
            HOME_2_Status $
            HOME_2_ProgramName $
            HOME_2_StartDate $
            HOME_2_EndDate $
            HOME_2_AssistedUnits 
            HOME_2_ConstructionType $
            HOME_2_InacStatusDesc $
            NumberActivePublicHousing
            NumberInconclusivePublicHousing
            NumberInactivePublicHousing
            PH_1_ID $
            PH_1_Status $
            PH_1_ProgramName $
            PH_1_StartDate $
            PH_1_EndDate $
            PH_1_AssistedUnits 
            PH_1_InacStatusDesc $
            PH_1_PhaCode $
            PH_2_ID $
            PH_2_Status $
            PH_2_ProgramName $
            PH_2_StartDate $
            PH_2_EndDate $
            PH_2_AssistedUnits 
            PH_2_InacStatusDesc $
            PH_2_PhaCode $
            NumberActiveState
            NumberInconclusiveState
            NumberInactiveState
            State_1_ID $
            State_1_Status $
            State_1_ProgramName $
            State_1_StartDate
            State_1_EndDate
            State_1_AssistedUnits
            State_1_InacStatusDesc $
            State_1_ConstructionType $
            State_2_ID $
            State_2_Status $
            State_2_ProgramName $
            State_2_StartDate
            State_2_EndDate
            State_2_AssistedUnits
            State_2_InacStatusDesc $
            State_2_ConstructionType $
;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */;
if NHPDPropertyID = "aa24d43d-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24031;
	County = 'Montgomery';
	End;
if NHPDPropertyID = "8523d43d-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24031;
	County = 'Montgomery';
	End;
if NHPDPropertyID = "c624d43d-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24033;
	County = 'Prince Georges';
	End;
if NHPDPropertyID = "77964eb6-d1ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 51059;
	County = 'Fairfax';
	End;
if NHPDPropertyID = "15fbdb37-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24033;
	County = 'Prince Georges';
	End;
if NHPDPropertyID = "d023d43d-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = '24033';
	County = 'Prince Georges';
	End;
if NHPDPropertyID = "7f9fea25-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24031;
	County = 'Montgomery';
	End;
if NHPDPropertyID = "d3da0713-baff-e611-8115-74d435edc0c2" then do;
	CountyCode = 11001;
	County = 'Washington';
	End;
if NHPDPropertyID = "0f7cfe18-baff-e611-8115-74d435edc0c2" then do;
	CountyCode = 11001;
	County = 'Washington';
	End;
if NHPDPropertyID = "1123d43d-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24033;
	County = 'Prince Georges';
	End;
if NHPDPropertyID = "d624d43d-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24033;
	County = 'Prince Georges';
	End;
if NHPDPropertyID = "ad23d43d-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24033;
	County = 'Prince Georges';
	End;
if NHPDPropertyID = "95fadb37-c2ff-e611-8115-74d435edc0c2" then do;
	CountyCode = 24009;
	County = 'Calvert';
	End;
run;

proc contents data=test;
run;

/*create labels for variables*/

proc format;
	value COG
    1= "COG county"
    0="Non COG county";

run;

/*create COG region flag*/
data all;
set test;
  if CountyCode in ("11001", "24017", "24021", "24031", "24033", "51013", "51059", "51107", "51153", "51510", "51600", "51610", "51683", "51685") then COGregion =1;
  else COGregion=0;
  format COGregion COG. ;
label NHPDPropertyID="Unique ID assigned to each property by NHPD staff";
label PropertyName="Name of the property ";
label PropertyAddress="Physical street address of property";
label City="Property city";
label State="Property state";
label Zip="Property zip code";
label PropertyStatus="Status of property";
label CBSACode="CBSA code";
label CBSAType="Type of CBSA";
label County="Name of county";
label CountyCode="Census designated county code";
label CensusTract="Census designated census tract code";
label CongressionalDistrict="Congressional district";
label Latitude="Property latitute";
label Longitude="Property longitude";
label ActiveSubsidies="Total number of subsidies attached to a property
that have not yet expired";
label TotalInconclusiveSubsidies="Total number of subsidies attached to a property
that is classified as inconclusive";
label TotalInactiveSubsidies="Total number of subsidies attached to a property
that have expired";
label TotalUnits="Total number of units in the property";
label EarliestStartDate="Earliest date that any of a property’s subsidies
went into effect";
label EarliestEndDate="Earliest date that any of a property’s subsidies is
set to expire";
label LatestEndDate="Latest date that any of a property’s subsidies is set
to expire";
label Owner="Name of property owner";
label OwnerType="Organization type of owner";
label ManagerName="Name of property manager";
label ManagerType="Organization type of manager";
label HUDPropertyID="HUD property ID";
label REACScore1="Score received on most recent REAC inspection";
label REACScore1Date="Date of most recent REAC inspection";
label ReacScore2="Score received on previous REAC inspection*"; 
label ReacScore2Date="Date of previous REAC inspection";
label ReacScore3="Score received on REAC inspection two
inspections ago";
label ReacScore3Date="Date of REAC inspection two inspections ago";
label ZeroOneBedroomUnits="Number of studio or one bedroom units at the
property";
label TwoBedroomUnits="Number of two bedrooms units at the property";
label ThreePlusBedroomUnits="Number of units at the property with three or more
bedrooms";
label PercentofELIHouseholds="Percent of extremely low-income residents living at
the property";  
label TargetTenantType="Target tenant population served by the property";  
label FairMarketRent_2BR="Ratio of average rent of units to the local FMR";
label EarliestConstructionDate="The
construction date of the oldest building at the
property";
label LatestConstructionDate="The
construction date of the newest building at the
property";
label OccupancyRate="Percent of units at the property that are occupied";  
label AverageMonthsOfTenancy="Average amount of months tenants have lived at
property";  
label NumberActiveSection8="Total number of active HUD Project-based
(Section 8) contracts attached to a property";
label NumberInconclusiveSection8="Total number of inconclusive Section 8 subsidies
attached to the property";
label NumberInactiveSection8="Total number of inactive Section 8 subsidies
attached to the property";
label S8_1_ID="Contract ID assigned to subsidy";
label S8_1_Status="Current status of contract";  
label S8_1_ProgramName="Specific program name";  
label S8_1_RenewalStatus="Current status of renewal or non-renewal of
contract";  
label S8_1_StartDate="Start date of contract";  
label S8_1_EndDate="Expiration date of contract";  
label S8_1_AssistedUnits="Number of units covered by contract";  
label S8_1_RentToFMR="Ratio of average rent of units to the local FMR";  
label S8_1_InacStatusDesc="Subsidy status description";  
label S8_2_ID="Contract ID assigned to subsidy";  
label S8_2_Status="Current status of contract";  
label S8_2_ProgramName="Specific program name";  
label S8_2_RenewalStatus="Current status of renewal or non-renewal of contract";  
label S8_2_StartDate="Start date of contract";  
label S8_2_EndDate="Expiration date of contract";  
label S8_2_AssistedUnits="Number of units covered by contract";  
label S8_2_RentToFMR="Ratio of average rent of units to the local FMR";  
label S8_2_InacStatusDesc="Subsidy status description";  
label NumberActiveSection202="Total number of active Section 202 subsidies
attached to the property";
label NumberInconclusiveSection202="Total number of inconclusive Section 202
subsidies attached to the property";
label NumberInactiveSection202="Total number of inactive Section 202 subsidies attached to the property";
label S202_1_ID="HUD REMS Property ID";  
label S202_1_Status="Current status of S.202 subsidy";  
label S202_1_ProgramName="Specific program name";  
label S202_1_StartDate="Start date of subsidy";  
label S202_1_EndDate="Expiration date of subsidy";  
label S202_1_AssistedUnits="Total number of units covered by subsidy";  
label S202_1_PrincipalBalance="Balance remaining on loan";  
label S202_1_InacStatusDesc="Subsidy status description";  
label S202_2_ID="HUD REMS Property ID";  
label S202_2_Status="Current status of S.202 subsidy";  
label S202_2_ProgramName="Specific program name";  
label S202_2_StartDate="Start date of subsidy";  
label S202_2_EndDate="Expiration date of subsidy";  
label S202_2_AssistedUnits="Total number of units covered by subsidy";  
label S202_2_PrincipalBalance="Balance remaining on loan";  
label S202_2_InacStatusDesc="Subsidy status description";  
label NumberActiveSection236="Total number of active State HFA financed Section
236 subsidies attached to property";
label NumberInconclusiveSection236="Total number of inconclusive State HFA financed
Section 236 subsidies attached to property";
label NumberInactiveSection236="Total number of inactive State HFA financed
Section 236 subsidies attached to property";
label S236_1_ID="Section 236 program property ID";  
label S236_1_Status="Current status of S236 subsidy";  
label S236_1_ProgramName="Name of S236 sub-program ";  
label S236_1_StartDate="Start date of subsidy";  
label S236_1_EndDate="Expiration date of subsidy";  
label S236_1_AssistedUnits="Total number of units covered by subsidy";  
label S236_1_InacStatusDesc="Subsidy status description";  
label S236_2_ID="Section 236 program property ID";  
label S236_2_Status="Current status of S236 subsidy";  
label S236_2_ProgramName="Name of S236 sub-program ";  
label S236_2_StartDate="Start date of subsidy";  
label S236_2_EndDate="Expiration date of subsidy";  
label S236_2_AssistedUnits="Section 236 program property ID";  
label S236_2_InacStatusDesc="Subsidy status description";  
label NumberActiveHUDInsured="Total Number active of FHA subsidies";
label NumberInconclusiveHUDInsured="Total Number inconclusive of FHA subsidies";
label NumberInactiveHud="Total Number inactive of FHA subsidies";
label FHA_1_ID="FHA property ID";
label FHA_1_Status="Current status of FHA subsidy";  
label FHA_1_ProgramName="Specific name of FHA sub-program";  
label FHA_1_StartDate="Start date of subsidy";
label FHA_1_EndDate="Expiration date of subsidy";
label FHA_1_AssistedUnits="Total number of units covered by subsidy";
label FHA_1_PrincipalBalance="Balance remaining on loan";
label FHA_1_InacStatusDesc="Subsidy status description";  
label FHA_2_ID="FHA property ID";
label FHA_2_Status="Current status of FHA subsidy";  
label FHA_2_ProgramName="Specific name of FHA sub-program";  
label FHA_2_StartDate="Start date of subsidy";
label FHA_2_EndDate="Expiration date of subsidy";
label FHA_2_AssistedUnits="Total number of units covered by subsidy";
label FHA_2_PrincipalBalance="Balance remaining on loan";
label FHA_2_InacStatusDesc="Subsidy status description";  
label NumberActiveLihtc="Total number of active LIHTC subsidies attached
to property";
label NumberInconclusiveLihtc="Total number of inconclusive LIHTC subsidies
attached to property";
label NumberInactiveLihtc="Total number of inactive LIHTC subsidies attached
to property";
label LIHTC_1_ID="LIHTC property ID";  
label LIHTC_1_Status="Current status of LIHTC subsidy";  
label LIHTC_1_ProgramName="Name of program";  
label LIHTC_1_StartDate="Start date of subsidy";
label LIHTC_1_EndDate="Expiration date of subsidy";
label LIHTC_1_AssistedUnits="Total number of units covered by subsidy";
label LIHTC_1_ConstructionType="LIHTC construction type";  
label LIHTC_1_InacStatusDesc="Current status of LIHTC subsidy";  
label LIHTC_2_ID="LIHTC property ID";  
label LIHTC_2_Status="Current status of LIHTC subsidy";  
label LIHTC_2_ProgramName="Name of program";  
label LIHTC_2_StartDate="Start date of subsidy";
label LIHTC_2_EndDate="Expiration date of subsidy";
label LIHTC_2_AssistedUnits="Total number of units covered by subsidy";
label LIHTC_2_ConstructionType="LIHTC construction type";  
label LIHTC_2_InacStatusDesc="Subsidy status description";  
label NumberActiveSection515="Total number of active RHS 515 subsidies attached
to property";
label NumberInconclusiveSection515="Total number of inconclusive RHS 515 subsidies
attached to property";
label NumberInactiveSection515="Total number of inactive RHS 515 subsidies
attached to property";
label RHS515_1_ID="RHS515 Property ID";
label RHS515_1_Status="Current status of RHS515 subsidy";  
label RHS515_1_ProgramName="Name of program";  
label RHS515_1_StartDate="Start date of subsidy";
label RHS515_1_EndDate="Expiration date of subsidy";
label RHS515_1_AssistedUnits="Total number of units covered by subsidy";
label RHS515_1_PrincipalBalance="Balance remaining on loan";  
label RHS515_1_InacStatusDesc="Subsidy status description";  
label RHS515_2_ID="RHS515 Property ID";
label RHS515_2_Status="Current status of RHS515 subsidy";  
label RHS515_2_ProgramName="Name of program";  
label RHS515_2_StartDate="Start date of subsidy";
label RHS515_2_EndDate="Expiration date of subsidy";
label RHS515_2_AssistedUnits="Total number of units covered by subsidy";
label RHS515_2_PrincipalBalance="Balance remaining on loan";  
label RHS515_2_InacStatusDesc="Subsidy status description";  
label NumberActiveSection538="Total number of active RHS538 subsidies attached to property";
label NumberInconclusiveSection538="Total number of inconclusive RHS538 subsidies
attached to property";
label NumberInactiveSection538="Total number of inactive RHS538 subsidies
attached to property";
label RHS538_1_ID="Unique RHS538 ID created by NHPD ";  
label RHS538_1_Status="Current status of RHS538 subsidy";  
label RHS538_1_ProgramName="Name of program";  
label RHS538_1_StartDate="Start date of subsidy";  
label RHS538_1_EndDate="Expiration date of subsidy";  
label RHS538_1_AssistedUnits="Total number of units covered by subsidy";  
label RHS538_1_PrincipalBalance="Balance remaining on loan";  
label RHS538_1_InacStatusDesc="Subsidy status description";  
label RHS538_2_ID="Unique RHS538 ID created by NHPD";  
label RHS538_2_Status="Current status of RHS538 subsidy";  
label RHS538_2_ProgramName="Name of program";  
label RHS538_2_StartDate="Start date of subsidy";  
label RHS538_2_EndDate="Expiration date of subsidy";  
label RHS538_2_AssistedUnits="Total number of units covered by subsidy";  
label RHS538_2_PrincipalBalance="Balance remaining on loan";  
label RHS538_2_InacStatusDesc="Subsidy status description";  
label NumberActiveHome="Total number of active HOME subsidies attached
to property";
label NumberInconclusiveHome="Total number of HOME inconclusive subsidies
attached to property";
label NumberInactiveHome="Total number of inactive HOME subsidies attached
to property";
label HOME_1_ID="HOME subsidy ID";
label HOME_1_Status="Current status of HOME subsidy";  
label HOME_1_ProgramName="Name of program";  
label HOME_1_StartDate="Start date of subsidy";
label HOME_1_EndDate="Expiration date of subsidy";
label HOME_1_AssistedUnits="Total number of units covered by subsidy";
label HOME_1_ConstructionType="HOME construction type";  
label HOME_1_InacStatusDesc="Subsidy status description";  
label HOME_2_ID="HOME subsidy ID";  
label HOME_2_Status="Current status of HOME subsidy";  
label HOME_2_ProgramName="Name of program";  
label HOME_2_StartDate="Start date of subsidy";  
label HOME_2_EndDate="Expiration date of subsidy";  
label HOME_2_AssistedUnits="Total number of units covered by subsidy";  
label HOME_2_ConstructionType="HOME construction type";  
label HOME_2_InacStatusDesc="Subsidy status description";  
label NumberActivePublicHousing="Total number of active Public Housing subsidies attached
to property";
label NumberInconclusivePublicHousing="Total number of inconclusive Public Housing subsidies
attached to property";
label NumberInactivePublicHousing="Total number of inactive Public Housing subsidies
attached to property";
label PH_1_ID="HUD assigned AMP number";  
label PH_1_Status="Current status of Public Housing subsidy";  
label PH_1_ProgramName="Name of program";  
label PH_1_StartDate="Public housing subsidy start date";  
label PH_1_EndDate="Expiration date of subsidy";  
label PH_1_AssistedUnits="Total number of ACC units at property";  
label PH_1_InacStatusDesc="Subsidy status description";  
label PH_1_PhaCode="Subsidy code";  
label PH_2_ID="HUD assigned AMP number";  
label PH_2_Status="Current status of Public Housing subsidy";  
label PH_2_ProgramName="Name of program";  
label	PH_2_StartDate="Public housing subsidy start date";  
label	PH_2_EndDate="Expiration date of subsidy";  
label	PH_2_AssistedUnits="Total number of ACC units at property";  
label	PH_2_InacStatusDesc="Subsidy status description";  
label	PH_2_PhaCode="Subsidy code";  
label	NumberActiveState="Total number of active state subsidies attached to
property";
label	NumberInconclusiveState="Total number of inconclusive state subsidies
attached to property";
label	NumberInactiveState="Total number of inactive state subsidies attached
to property";
label	State_1_ID="Unique state provided subsidy ID";  
label	State_1_Status="Current status of State subsidy";  
label	State_1_ProgramName="Name of program";  
label	State_1_StartDate="Start date of subsidy";
label	State_1_EndDate="Expiration date of subsidy";
label	State_1_AssistedUnits="Total number of units covered by subsidy";
label	State_1_InacStatusDesc="Subsidy status description";  
label	State_1_ConstructionType="State construction type";  
label	State_2_ID="Unique state provided subsidy ID";  
label	State_2_Status="Current status of State subsidy";  
label	State_2_ProgramName="Name of program";  
label	State_2_StartDate="Start date of subsidy";
label	State_2_EndDate="Expiration date of subsidy";
label	State_2_AssistedUnits="Total number of units covered by subsidy";
label	State_2_InacStatusDesc="Subsidy status description";  
label	State_2_ConstructionType="State construction type";  
label   COGregion="COG county";
run;

/*assign label to variables
data all;
set all;
  format  ;
run;*/

/*finalize dataset*/

%Finalize_data_set(
/** Finalize data set parameters **/
data=all,
out=natlpres_ActiveandInc_prop,
outlib=RegHsg,
label="National Preservation Database Active and Inconclusive Properties 1/2019",
sortby=EarliestStartDate,
/** Metadata parameters **/
revisions=%str(Correct character vars for assisted unit counts),
printobs=5
)

