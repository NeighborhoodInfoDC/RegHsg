/**************************************************************************
 Program:  Hud_inc_RegHsg.sas
 Library:  RegHsg
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  4/12/2018
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Autocall macro to calculate HUD income categories for
 IPUMS data, variable HUD_INC.
 
 Values:
 1  =  <=30% AMI (extremely low)
 2  =  31-50% AMI (very low)
 3  =  51-80% AMI (low)
 4  =  81-120% AMI (middle)
 5  =  120-200% AMI (high)
 6  =  >=200% (extremely high)
 -99  =  N/A (income not reported)

 Modifications: Yipeng Su from Hud_inc_2016 for RegHsg project.
**************************************************************************/

/** Macro Hud_inc_RegHsg - Start Definition **/

%macro Hud_inc_RegHsg(hhinc=, hhsize=  );

  ** HUD income categories (<year>) **;

  if &hhinc. in ( 9999999, .n ) then hud_inc = .n;
  else do;

    select ( &hhsize. );
      when ( 1 )
        do;
          if &hhinc. <= 22850 then hud_inc = 1;
          else if 22850 < &hhinc. <= 38050 then hud_inc = 2;
          else if 38050 < &hhinc. <= 49150 then hud_inc = 3;
          else if 49150 < &hhinc. <= 91320 then hud_inc = 4;
          else if 91320 < &hhinc. <= 152200 then hud_inc = 5;
		  else if 152200 <&hhinc.  then hud_inc=6;
        end;
      when ( 2 )
        do;
          if &hhinc. <= 26100 then hud_inc = 1;
          else if 26100 < &hhinc. <= 43450 then hud_inc = 2;
          else if 43450 < &hhinc. <= 56150 then hud_inc = 3;
          else if 56150 < &hhinc. <= 104280 then hud_inc = 4;
          else if 104280 < &hhinc. <= 173800 then hud_inc = 5;
		  else if 173800 < &hhinc. then hud_inc=6;
        end;
      when ( 3 )
        do;
          if &hhinc. <= 29350 then hud_inc = 1;
          else if 29350 < &hhinc. <= 48900 then hud_inc = 2;
          else if 48900 < &hhinc. <= 63150 then hud_inc = 3;
          else if 63150 < &hhinc. <= 117360 then hud_inc = 4;
          else if 117360 < &hhinc. <= 195600 then hud_inc = 5;
          else if 195600 < &hhinc. then hud_inc=6;
        end;
      when ( 4 )
        do;
          if &hhinc. <= 32600 then hud_inc = 1;
          else if 32600 < &hhinc. <= 54300 then hud_inc = 2;
          else if 54300 < &hhinc. <= 70150 then hud_inc = 3;
          else if 70150 < &hhinc. <= 130320 then hud_inc = 4;
          else if 130320 < &hhinc. <= 217200 then hud_inc = 5;
		  else if 217200 < &hhinc. then hud_inc=6;
        end;
      when ( 5 )
        do;
          if &hhinc. <= 35250 then hud_inc = 1;
          else if 35250 < &hhinc.<= 58650 then hud_inc = 2;
          else if 58650 < &hhinc. <= 75800 then hud_inc = 3;
          else if 75800 < &hhinc. <= 140760 then hud_inc = 4;
          else if 140760 < &hhinc. <= 234600 then hud_inc = 5;
		  else if 234600 < &hhinc. then hud_inc=6;
        end;
      when ( 6 )
        do;
          if &hhinc. <= 37850 then hud_inc = 1;
          else if 37850 < &hhinc. <= 63000 then hud_inc = 2;
          else if 63000 < &hhinc. <= 81400 then hud_inc = 3;
          else if 81400 < &hhinc. <= 151200 then hud_inc = 4;
          else if 151200 < &hhinc. <= 252000 then hud_inc = 5;
		  else if 252000 < &hhinc. then hud_inc=6;
        end;
      when ( 7 )
        do;
          if &hhinc. <= 40450 then hud_inc = 1;
          else if 40450 < &hhinc. <= 67350 then hud_inc = 2;
          else if 67350 < &hhinc. <= 87000 then hud_inc = 3;
          else if 87000 < &hhinc. <= 161640 then hud_inc = 4;
          else if 161640 < &hhinc. <= 269400 then hud_inc = 5;    
          else if 269400 < &hhinc. then hud_inc = 6;
        end;
      otherwise
        do;
          if &hhinc. <= 43050 then hud_inc = 1;
          else if 43050 < &hhinc. <= 71700 then hud_inc = 2;
          else if 71700 < &hhinc. <= 92600 then hud_inc = 3;
          else if 92600 < &hhinc. <= 172080 then hud_inc = 4;
          else if 172080 < &hhinc. <= 286800 then hud_inc = 5;
          else if 286800 < &hhinc. then hud_inc = 6;
        end;
    end;

  end;

  label hud_inc = "HUD income categories";
  
%mend Hud_inc_RegHsg;

/** End Macro Definition **/


