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


/*********** Code for calculations *************

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( RegHsg )
%DCData_lib( NCDB )
%DCData_lib( Ipums )
 

title2 '-- 2000 --';

proc means data=Ncdb.Ncdb_lf_2000_was15 n sum;
  where ucounty = '51107';
  var trctpop0 tothsun0 occhu0 vachu0;
run;

data ipums2000;

  set 
    Ipums.Ipums_2000_va (keep=year upuma pernum gq vacancy perwt hhwt) 
    Ipums.Ipums_2000_vacant_va (keep=year upuma gq vacancy hhwt); 
  where upuma = '5100600';
  
  if pernum not in ( ., 1 ) or gq not in ( 0, 1, 2 ) then hhwt = .;
  
run;

proc means data=ipums2000 n sum;
  var perwt hhwt;
run;

title2 '-- 2010 --';

proc means data=Ncdb.Ncdb_2010_was15 n sum;
  where ucounty = '51107';
  var trctpop1 tothsun1 occhu1 vachu1;
run;

data ipums2010;

  set 
    Ipums.Acs_2010_va (keep=year upuma pernum gq vacancy perwt hhwt) 
    Ipums.Acs_2010_vacant_va (keep=year upuma gq vacancy hhwt); 
  where upuma = '5100600';
  
  if pernum not in ( ., 1 ) or gq not in ( 0, 1, 2 ) then hhwt = .;
  
run;

proc means data=ipums2010 n sum;
  var perwt hhwt;
run;

title2;

*************************************/
