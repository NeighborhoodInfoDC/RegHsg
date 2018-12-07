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
          else if 38050 < &hhinc. <= 60816 then hud_inc = 3;
          else if 60816 < &hhinc. <= 91224 then hud_inc = 4;
          else if 91224 < &hhinc. <= 152040 then hud_inc = 5;
		  else if 152040 <&hhinc.  then hudinc=6;
        end;
      when ( 2 )
        do;
          if &hhinc. <= 26100 then hud_inc = 1;
          else if 26100 < &hhinc. <= 43440 then hud_inc = 2;
          else if 43440 < &hhinc. <= 69504 then hud_inc = 3;
          else if 69504 < &hhinc. <= 104256 then hud_inc = 4;
          else if 104256 < &hhinc. <= 173760 then hud_inc = 5;
		  else if 173760 < &hhinc. then hudinc=6;
        end;
      when ( 3 )
        do;
          if &hhinc. <= 29350 then hud_inc = 1;
          else if 29350 < &hhinc. <= 48870 then hud_inc = 2;
          else if 48870 < &hhinc. <= 78192 then hud_inc = 3;
          else if 78192 < &hhinc. <= 117288 then hud_inc = 4;
          else if 117288 < &hhinc. <= 195480 then hud_inc = 5;
          else if 195480 < &hhinc. then hudinc=6;
        end;
      when ( 4 )
        do;
          if &hhinc. <= 32600 then hud_inc = 1;
          else if 32600 < &hhinc. <= 54300 then hud_inc = 2;
          else if 54300 < &hhinc. <= 86880 then hud_inc = 3;
          else if 86880 < &hhinc. <= 130320 then hud_inc = 4;
          else if 130320 < &hhinc. <= 217200 then hud_inc = 5;
		  else if 217200 < &hhinc. then hudinc=6;
        end;
      when ( 5 )
        do;
          if &hhinc. <= 35250 then hud_inc = 1;
          else if 35250 < &hhinc.<= 58644 then hud_inc = 2;
          else if 58644 < &hhinc. <= 93830 then hud_inc = 3;
          else if 93830 < &hhinc. <= 140746 then hud_inc = 4;
          else if 140746 < &hhinc. <= 234576 then hud_inc = 5;
		  else if 234576 < &hhinc. then hudinc=6;
        end;
      when ( 6 )
        do;
          if &hhinc. <= 37850 then hud_inc = 1;
          else if 37850 < &hhinc. <= 62988 then hud_inc = 2;
          else if 62988 < &hhinc. <= 100781 then hud_inc = 3;
          else if 100781 < &hhinc. <= 151171 then hud_inc = 4;
          else if 151171 < &hhinc. <= 251952 then hud_inc = 5;
		  else if 251952 < &hhinc. then hudinc=6;
        end;
      when ( 7 )
        do;
          if &hhinc. <= 40450 then hud_inc = 1;
          else if 40450 < &hhinc. <= 67332 then hud_inc = 2;
          else if 67332 < &hhinc. <= 100781 then hud_inc = 3;
          else if 100781 < &hhinc. <= 151171 then hud_inc = 4;
          else if 151171 < &hhinc. <= 251952 then hud_inc = 5;    
          else if 251952 < &hhinc. then hud_inc = 6;
        end;
      otherwise
        do;
          if &hhinc. <= 43050 then hud_inc = 1;
          else if 43050 < &hhinc. <= 71676 then hud_inc = 2;
          else if 71676 < &hhinc. <= 114682 then hud_inc = 3;
          else if 114682 < &hhinc. <= 172022 then hud_inc = 4;
          else if 172022 < &hhinc. <= 286704 then hud_inc = 5;
          else if 286704 < &hhinc. then hud_inc = 6;
        end;
    end;

  end;

  label Hud_inc = "HUD income categories";
  
%mend Hud_inc_RegHsg;

/** End Macro Definition **/


