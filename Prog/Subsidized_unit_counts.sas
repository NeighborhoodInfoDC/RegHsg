/**************************************************************************
 Program:  Subsidized_units_counts.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   W. Oliver
 Created:  02/7/19
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
*Create property and unit counts for individual programs**;

proc format;
	value ActiveUnits
    1= "Active subsidies"
    0="No active subsidies";
	run;
proc format;
	value ProgCat
	1= "Public housing"
	2= "Section 8 only"
	3= "Section 8 and HUD mortgage (FHA or S236) only"
	4= "Section 8 and other subsidy combinations"
	5= "LIHTC only"
	6= "LIHTC and other subsidies"
	7= "HOME only"
	8= "RHS only"
	9= "S202/811 only"
	10= "All other subsidy combination";

run;

data Work.Allassistedunits;
	set RegHsg.Natlpres_activeandinc_prop;
	s8_all_assistedunits=min(sum(s8_1_AssistedUnits, s8_2_AssistedUnits),TotalUnits);
	s202_all_assistedunits=min(sum(s202_1_AssistedUnits, s202_2_AssistedUnits),TotalUnits);
	s236_all_assistedunits=min(sum(s236_1_AssistedUnits, s236_2_AssistedUnits),TotalUnits);
	FHA_all_assistedunits=min(sum(FHA_1_AssistedUnits, FHA_2_AssistedUnits),TotalUnits);
	LIHTC_all_assistedunits=min(sum(LIHTC_1_AssistedUnits,LIHTC_2_AssistedUnits),TotalUnits);
	s515_all_assistedunits=min(sum(RHS515_1_AssistedUnits,RHS515_2_AssistedUnits),TotalUnits);
	s538_all_assistedunits=min(sum(RHS538_1_AssistedUnits,RHS538_2_AssistedUnits),TotalUnits);
	HOME_all_assistedunits=min(sum(HOME_1_AssistedUnits, HOME_2_AssistedUnits),TotalUnits);
	PH_all_assistedunits=min(sum(PH_1_AssistedUnits, PH_2_AssistedUnits),TotalUnits);
	State_all_assistedunits=min(sum(State_1_AssistedUnits, State_2_AssistedUnits),TotalUnits);
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

	if s515_all_assistedunits > 0
	then s515_activeunits = 1;
	else s515_activeunits = 0;

	if s538_all_assistedunits > 0
	then s538_activeunits = 1;
	else s538_activeunits = 0;

	if HOME_all_assistedunits > 0
	then HOME_activeunits = 1;
	else HOME_activeunits = 0;

	if PH_all_assistedunits > 0
	then PH_activeunits = 1;
	else PH_activeunits = 0;

	if State_all_assistedunits > 0
	then State_activeunits = 1;
	else State_activeunits = 0;

	format State_activeunits PH_activeunits HOME_activeunits s538_activeunits s515_activeunits
	LIHTC_activeunits FHA_activeunits s236_activeunits s202_activeunits s8_activeunits ActiveUnits.;
run;
data Work.SubsidyCategories;
	set Work.Allassistedunits;

	if PH_activeunits  then ProgCat = 1;

	else if s8_all_activeunits and not( fha_all_activeunits or home_all_activeunits or 
	lihtc_all_activeunits or rhs515_all_activeunits or rhs538_all_activeunits or 
	s202_all_activeunits or s236_all_activeunits ) 
	then ProgCat = 2;

	else if s8_all_activeunits and ( fha_all_activeunits or s236_all_activeunits ) and 
	not( home_all_activeunits or lihtc_all_activeunits or rhs515_all_activeunits or 
	rhs538_all_activeunits or s202_all_activeunits ) 
	then ProgCat = 3;

	else if s8_all_activeunits then ProgCat = 4;

	else if lihtc_all_activeunits and not( fha_all_activeunits or home_all_activeunits or 
	rhs515_all_activeunits or rhs538_all_activeunits or s202_all_activeunits or 
	s236_all_activeunits ) 
	then ProgCat = 5;

	else if lihtc_all_activeunits then ProgCat = 6;

	else if home_all_activeunits and not ( fha_all_activeunits or s8_all_activeunits or 
	rhs515_all_activeunits or rhs538_all_activeunits or s202_all_activeunits or 
	s236_all_activeunits ) 
	then ProgCat = 7;

	
    else if rhs515_all_activeunits or rhs538 and not (fha_all_activeunits or s8_all_activeunits or 
	home_all_activeunits or s202_all_activeunits or s236_all_activeunits ) 
	then ProgCat = 8;

	
	format ProgCat ProgCat.;



	run;

