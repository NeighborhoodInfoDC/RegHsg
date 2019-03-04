/**************************************************************************
 Program:  oldpuma_jurisdiction.sas
 Library:  RegHsg
 Project:  Regional Housing Framework
 Author:   Rob Pitingolo
 Created:  03/04/2019
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description: Assign jurisdiction to PUMAS for ACS IPUMS data for the COGS region:
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

%macro oldpuma_jurisdiction;

  if upuma in ("1100101", "1100102", "1100103", "1100104", "1100105") then Jurisdiction =1;
  if upuma in ("2401600") then Jurisdiction =2;
  if upuma in ("2400300") then Jurisdiction =3;
  if upuma in ("2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007") then Jurisdiction =4;
  if upuma in ("2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107") then Jurisdiction =5;
  if upuma in ("5100100") then Jurisdiction =6;
  if upuma in ("5100301", "5100302", "5100303", "5100304", "5100305", "5100303", "5100301") then Jurisdiction =7;
  if upuma in ("5100600") then Jurisdiction =8;
  if upuma in ("5100501", "5100502", "5100501") then Jurisdiction =9; 
  if upuma in ("5100200") then Jurisdiction =10;

 
%mend oldpuma_jurisdiction;
