/**************************************************************************
 Program:  Assign_jurisdiction00.sas
 Library:  RegHsg
 Project:  Regional Housing Framework
 Author:   P. Tatian
 Created:  3/1/2019
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
Description: Assign jurisdiction based on 2000 PUMAS for ACS IPUMS data for the COGS region:
  1="DC"
  2="Charles County"
  3="Frederick County "
  4="Montgomery County"
  5="Prince Georges "
  6="Arlington"
  7="Fairfax, Fairfax city and Falls Church"
  8="Loudoun"
  9="Prince William, Manassas and Manassas Park"
  10="Alexandria"

 Modifications:
**************************************************************************/

%macro Assign_jurisdiction00;

  select ( upuma );
    when ("1100101", "1100102", "1100103", "1100104", "1100105") 
      Jurisdiction =1;
    when ("2401600") 
      Jurisdiction =2;
    when ("2400300") 
      Jurisdiction =3;
    when ("2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007") 
      Jurisdiction =4;
    when ("2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107") 
      Jurisdiction =5;
    when ("5100100") 
      Jurisdiction =6;
    when ("5100301", "5100302", "5100303", "5100304", "5100305", "5100303", "5100301") 
      Jurisdiction =7;
    when ("5100600") 
      Jurisdiction =8;
    when ("5100501", "5100502", "5100501") 
      Jurisdiction =9; 
    when ("5100200") 
      Jurisdiction =10; 
    otherwise
        ;
  end;
 
%mend Assign_jurisdiction00;
