/**************************************************************************
 Program:  Ipums_wt_adjust.sas
 Library:  RegHsg
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  04/02/19
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  
 
 Description:  Autocall macro to adjust IPUMS person and HH weights
 for COG jurisdictions. 
 
 Population and housing unit adjustment for Loudoun County 
 
   -- 2000 --

  The MEANS Procedure

  Variable    Label                                            N             Sum
  ------------------------------------------------------------------------------
  TRCTPOP0    Total population, 2000                          32       169599.00
  TOTHSUN0    Total housing units, 2000                       32        62160.00
  OCCHU0      Total occupied housing units, 2000              32        59900.00
  ------------------------------------------------------------------------------

  The MEANS Procedure

  Variable    Label                   N             Sum
  -----------------------------------------------------
  perwt       Person weight       13734       268888.00
  hhwt        Household weight     5225       102190.00
  -----------------------------------------------------

  -- 2010 --

  The MEANS Procedure

  Variable    Label                                    N             Sum
  ----------------------------------------------------------------------
  TRCTPOP1    Total population, 2010                  65       312311.00
  TOTHSUN1    Total housing units, 2010               65       109442.00
  OCCHU1      Total occupied housing units, 2010      65       104583.00
  ----------------------------------------------------------------------

  The MEANS Procedure

  Variable    Label                  N             Sum
  ----------------------------------------------------
  PERWT       Person weight       4305       432211.00
  HHWT        Household weight    1553       157855.00
  ----------------------------------------------------

 Modifications:
**************************************************************************/


%macro Ipums_wt_adjust(  );

  if upuma = '5100600' then do;
    if ( 0 <= year <= 9 ) or ( 2000 <= year <= 2009 ) then do;
      perwt = (169599/268888) * perwt;
      hhwt = (62160/102190) * hhwt;
    end;
    else if ( 10 <= year <= 11 ) or ( 2010 <= year <= 2011 ) then do;
      perwt = (312311/432211) * perwt;
      hhwt = (109442/157855) * hhwt;
    end;
  end;

%mend Ipums_wt_adjust;

