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
   format CongressionalDistrict best12. ;
   format Latitude best12. ;
   format Longitude best12. ;
   format PropertyStatus $6. ;
   format ActiveSubsidies best12. ;
   format TotalInconclusiveSubsidies best12. ;
   format TotalInactiveSubsidies best12. ;
   format TotalUnits best12. ;
   format EarliestStartDate mmddyy10. ;
   format EarliestEndDate mmddyy10. ;
   format LatestEndDate mmddyy10. ;
   format Owner $34. ;
   format OwnerType $13. ;
   format ManagerName $38. ;
   format ManagerType $1. ;
   format HUDPropertyID best12. ;
   format ReacScore1 $4. ;
   format ReacScore1Date mmddyy10. ;
   format ReacScore2 $3. ;
   format ReacScore2Date mmddyy10. ;
   format ReacScore3 $3. ;
   format ReacScore3Date mmddyy10. ;
   format ZeroOneBedroomUnits best12. ;
   format TwoBedroomUnits best12. ;
   format ThreePlusBedroomUnits best12. ;
   format PercentofELIHouseholds $1. ;
   format TargetTenantType $8. ;
   format FairMarketRent_2BR best12. ;
   format EarliestConstructionDate mmddyy10. ;
   format LatestConstructionDate mmddyy10. ;
   format OccupancyRate $1. ;
   format AverageMonthsOfTenancy $1. ;
   format NumberActiveSection8 best12. ;
   format NumberInconclusiveSection8 best12. ;
   format NumberInactiveSection8 best12. ;
   format S8_1_ID $1. ;
   format S8_1_Status $1. ;
   format S8_1_ProgramName $1. ;
   format S8_1_RenewalStatus $1. ;
   format S8_1_StartDate $1. ;
   format S8_1_EndDate $1. ;
   format S8_1_AssistedUnits $1. ;
   format S8_1_RentToFMR $1. ;
   format S8_1_InacStatusDesc $1. ;
   format S8_2_ID $1. ;
   format S8_2_Status $1. ;
   format S8_2_ProgramName $1. ;
   format S8_2_RenewalStatus $1. ;
   format S8_2_StartDate $1. ;
   format S8_2_EndDate $1. ;
   format S8_2_AssistedUnits $1. ;
   format S8_2_RentToFMR $1. ;
   format S8_2_InacStatusDesc $1. ;
   format NumberActiveSection202 best12. ;
   format NumberInconclusiveSection202 best12. ;
   format NumberInactiveSection202 best12. ;
   format S202_1_ID $1. ;
   format S202_1_Status $1. ;
   format S202_1_ProgramName $1. ;
   format S202_1_StartDate $1. ;
   format S202_1_EndDate $1. ;
   format S202_1_AssistedUnits $1. ;
   format S202_1_PrincipalBalance $1. ;
   format S202_1_InacStatusDesc $1. ;
   format S202_2_ID $1. ;
   format S202_2_Status $1. ;
   format S202_2_ProgramName $1. ;
   format S202_2_StartDate $1. ;
   format S202_2_EndDate $1. ;
   format S202_2_AssistedUnits $1. ;
   format S202_2_PrincipalBalance $1. ;
   format S202_2_InacStatusDesc $1. ;
   format NumberActiveSection236 best12. ;
   format NumberInconclusiveSection236 best12. ;
   format NumberInactiveSection236 best12. ;
   format S236_1_ID $1. ;
   format S236_1_Status $1. ;
   format S236_1_ProgramName $1. ;
   format S236_1_StartDate $1. ;
   format S236_1_EndDate $1. ;
   format S236_1_AssistedUnits $1. ;
   format S236_1_InacStatusDesc $1. ;
   format S236_2_ID $1. ;
   format S236_2_Status $1. ;
   format S236_2_ProgramName $1. ;
   format S236_2_StartDate $1. ;
   format S236_2_EndDate $1. ;
   format S236_2_AssistedUnits $1. ;
   format S236_2_InacStatusDesc $1. ;
   format NumberActiveHUDInsured best12. ;
   format NumberInconclusiveHUDInsured best12. ;
   format NumberInactiveHud best12. ;
   format FHA_1_ID best12. ;
   format FHA_1_Status $6. ;
   format FHA_1_ProgramName $26. ;
   format FHA_1_StartDate mmddyy10. ;
   format FHA_1_EndDate mmddyy10. ;
   format FHA_1_AssistedUnits best12. ;
   format FHA_1_PrincipalBalance best12. ;
   format FHA_1_InacStatusDesc $1. ;
   format FHA_2_ID best12. ;
   format FHA_2_Status $6. ;
   format FHA_2_ProgramName $26. ;
   format FHA_2_StartDate mmddyy10. ;
   format FHA_2_EndDate mmddyy10. ;
   format FHA_2_AssistedUnits best12. ;
   format FHA_2_PrincipalBalance best12. ;
   format FHA_2_InacStatusDesc $1. ;
   format NumberActiveLihtc best12. ;
   format NumberInconclusiveLihtc best12. ;
   format NumberInactiveLihtc best12. ;
   format LIHTC_1_ID $10. ;
   format LIHTC_1_Status $6. ;
   format LIHTC_1_ProgramName $13. ;
   format LIHTC_1_StartDate mmddyy10. ;
   format LIHTC_1_EndDate mmddyy10. ;
   format LIHTC_1_AssistedUnits best12. ;
   format LIHTC_1_ConstructionType $16. ;
   format LIHTC_1_InacStatusDesc $1. ;
   format LIHTC_2_ID $10. ;
   format LIHTC_2_Status $6. ;
   format LIHTC_2_ProgramName $13. ;
   format LIHTC_2_StartDate mmddyy10. ;
   format LIHTC_2_EndDate mmddyy10. ;
   format LIHTC_2_AssistedUnits best12. ;
   format LIHTC_2_ConstructionType $16. ;
   format LIHTC_2_InacStatusDesc $1. ;
   format NumberActiveSection515 best12. ;
   format NumberInconclusiveSection515 best12. ;
   format NumberInactiveSection515 best12. ;
   format RHS515_1_ID best12. ;
   format RHS515_1_Status $6. ;
   format RHS515_1_ProgramName $12. ;
   format RHS515_1_StartDate mmddyy10. ;
   format RHS515_1_EndDate mmddyy10. ;
   format RHS515_1_AssistedUnits best12. ;
   format RHS515_1_PrincipalBalance $1. ;
   format RHS515_1_InacStatusDesc $1. ;
   format RHS515_2_ID best12. ;
   format RHS515_2_Status $6. ;
   format RHS515_2_ProgramName $12. ;
   format RHS515_2_StartDate mmddyy10. ;
   format RHS515_2_EndDate mmddyy10. ;
   format RHS515_2_AssistedUnits best12. ;
   format RHS515_2_PrincipalBalance $1. ;
   format RHS515_2_InacStatusDesc $1. ;
   format NumberActiveSection538 best12. ;
   format NumberInconclusiveSection538 best12. ;
   format NumberInactiveSection538 best12. ;
   format RHS538_1_ID $1. ;
   format RHS538_1_Status $1. ;
   format RHS538_1_ProgramName $1. ;
   format RHS538_1_StartDate $1. ;
   format RHS538_1_EndDate $1. ;
   format RHS538_1_AssistedUnits $1. ;
   format RHS538_1_PrincipalBalance $1. ;
   format RHS538_1_InacStatusDesc $1. ;
   format RHS538_2_ID $1. ;
   format RHS538_2_Status $1. ;
   format RHS538_2_ProgramName $1. ;
   format RHS538_2_StartDate $1. ;
   format RHS538_2_EndDate $1. ;
   format RHS538_2_AssistedUnits $1. ;
   format RHS538_2_PrincipalBalance $1. ;
   format RHS538_2_InacStatusDesc $1. ;
   format NumberActiveHome best12. ;
   format NumberInconclusiveHome best12. ;
   format NumberInactiveHome best12. ;
   format HOME_1_ID best12. ;
   format HOME_1_Status $6. ;
   format HOME_1_ProgramName $4. ;
   format HOME_1_StartDate mmddyy10. ;
   format HOME_1_EndDate mmddyy10. ;
   format HOME_1_AssistedUnits best12. ;
   format HOME_1_ConstructionType $16. ;
   format HOME_1_InacStatusDesc $1. ;
   format HOME_2_ID $1. ;
   format HOME_2_Status $1. ;
   format HOME_2_ProgramName $1. ;
   format HOME_2_StartDate $1. ;
   format HOME_2_EndDate $1. ;
   format HOME_2_AssistedUnits $1. ;
   format HOME_2_ConstructionType $1. ;
   format HOME_2_InacStatusDesc $1. ;
   format NumberActivePublicHousing best12. ;
   format NumberInconclusivePublicHousing best12. ;
   format NumberInactivePublicHousing best12. ;
   format PH_1_ID $1. ;
   format PH_1_Status $1. ;
   format PH_1_ProgramName $1. ;
   format PH_1_StartDate $1. ;
   format PH_1_EndDate $1. ;
   format PH_1_AssistedUnits $1. ;
   format PH_1_InacStatusDesc $1. ;
   format PH_1_PhaCode $1. ;
   format PH_2_ID $1. ;
   format PH_2_Status $1. ;
   format PH_2_ProgramName $1. ;
   format PH_2_StartDate $1. ;
   format PH_2_EndDate $1. ;
   format PH_2_AssistedUnits $1. ;
   format PH_2_InacStatusDesc $1. ;
   format PH_2_PhaCode $1. ;
   format NumberActiveState best12. ;
   format NumberInconclusiveState best12. ;
   format NumberInactiveState best12. ;
   format State_1_ID $6. ;
   format State_1_Status $6. ;
   format State_1_ProgramName $16. ;
   format State_1_StartDate mmddyy10. ;
   format State_1_EndDate mmddyy10. ;
   format State_1_AssistedUnits best12. ;
   format State_1_InacStatusDesc $16. ;
   format State_1_ConstructionType $16. ;
   format State_2_ID $6. ;
   format State_2_Status $6. ;
   format State_2_ProgramName $16. ;
   format State_2_StartDate mmddyy10. ;
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
            S8_1_AssistedUnits $
            S8_1_RentToFMR $
            S8_1_InacStatusDesc $
            S8_2_ID $
            S8_2_Status $
            S8_2_ProgramName $
            S8_2_RenewalStatus $
            S8_2_StartDate $
            S8_2_EndDate $
            S8_2_AssistedUnits $
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
            S202_1_AssistedUnits $
            S202_1_PrincipalBalance $
            S202_1_InacStatusDesc $
            S202_2_ID $
            S202_2_Status $
            S202_2_ProgramName $
            S202_2_StartDate $
            S202_2_EndDate $
            S202_2_AssistedUnits $
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
            S236_1_AssistedUnits $
            S236_1_InacStatusDesc $
            S236_2_ID $
            S236_2_Status $
            S236_2_ProgramName $
            S236_2_StartDate $
            S236_2_EndDate $
            S236_2_AssistedUnits $
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
            RHS538_1_AssistedUnits $
            RHS538_1_PrincipalBalance $
            RHS538_1_InacStatusDesc $
            RHS538_2_ID $
            RHS538_2_Status $
            RHS538_2_ProgramName $
            RHS538_2_StartDate $
            RHS538_2_EndDate $
            RHS538_2_AssistedUnits $
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
            HOME_2_AssistedUnits $
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
            PH_1_AssistedUnits $
            PH_1_InacStatusDesc $
            PH_1_PhaCode $
            PH_2_ID $
            PH_2_Status $
            PH_2_ProgramName $
            PH_2_StartDate $
            PH_2_EndDate $
            PH_2_AssistedUnits $
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


