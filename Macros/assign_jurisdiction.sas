/**************************************************************************
 Program:  assign_jurisdiction.sas
 Library:  RegHsg
 Project:  Regional Housing Framework
 Author:   L. Hendey
 Created:  1/09/2019
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description: Assign jurisdiction based on 2010 PUMAS for ACS IPUMS data for the COGS region:
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

%macro assign_jurisdiction;

  select ( upuma );
    when ("1100101", "1100102", "1100103", "1100104", "1100105") 
      Jurisdiction =1;
    when ("2401600") 
      Jurisdiction =2;
    when ("2400301", "2400302") 
      Jurisdiction =3;
    when ("2401001", "2401002", "2401003", "2401004", "2401005", "2401006", "2401007") 
      Jurisdiction =4;
    when ("2401101", "2401102", "2401103", "2401104", "2401105", "2401106", "2401107") 
      Jurisdiction =5;
    when ("5101301", "5101302") 
      Jurisdiction =6;
    when ("5159301", "5159302", "5159303", "5159304", "5159305", "5159306", "5159307", "5159308", "5159309") 
      Jurisdiction =7;
    when ("5110701", "5110702" , "5110703") 
      Jurisdiction =8;
    when ("5151244", "5151245", "5151246") 
      Jurisdiction =9; 
    when ("5151255") 
      Jurisdiction =10; 
    otherwise
        ;
  end;
 
%mend assign_jurisdiction;
