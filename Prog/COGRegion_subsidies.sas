/**************************************************************************
 Program:  COGRegion_subsidies.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   W. Oliver
 Created:  01/30/19
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

/*****************************************
/*where properties are located,
how many units are subsidized (at what level if known), subsidy programs involved, 
and any expiration dates for the subsidies.*/

/*where properties are located*/

proc summary data=all_finalize (where=(PropertyStatus="Active"));
	class COGregion CountyCode ;
	var TotalUnits;
	output out = properties_sum  sum=;
run;

/*how many units are subsidized (at what level if known)*/
proc summary data=all_finalize (where=(PropertyStatus="Active"));
	class COGregion OwnerType;
	var NumberActiveSection8 NumberActiveSection202 NumberActiveSection236 NumberActiveHUDInsured NumberActiveLihtc;
	output out = Units_subsidiestype  sum=;
run;

/*expiration dates for the subsidies*/
proc summary data=all_finalize (where=(TotalInactiveSubsidies>=1));
	class COGRegion ;
	var ;
	run;

/*subsidy programs involved*/
proc summary data=all_finalize (where=(PropertyStatus="Active"));
	class COGregion;
	var FHA_1_ProgramName FHA_2_ProgramName HOME_1_ProgramName HOME_2_ProgramName LIHTC_1_ProgramName LIHTC_2_ProgramName PH_1_ProgramName
		PH_2_ProgramName RHS515_1_ProgramName RHS515_2_ProgramName RHS538_1_ProgramName RHS538_2_ProgramName S202_1_ProgramName S202_2_ProgramName
		S236_1_ProgramName S236_2_ProgramName S8_1_ProgramName S8_2_ProgramName State_1_ProgramName State_2_ProgramName;
	run;
