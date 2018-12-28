********************************************************************************
* Author: Yipeng Su
* Project: Regional Housing Framework
* Date: 12/28/2018
* Moderation:
********************************************************************************

import excel "L:\Libraries\RegHsg\Raw\ACS 1 year estimate\All_1year.xlsx", sheet("Sheet1") firstrow

label variable HC01_EST_VC01 "totpop"
label variable HC02_EST_VC01 "mtotpop"
label variable HC03_EST_VC01 "ftotpop"
label variable HC01_EST_VC03 "totunder5"
label variable HC02_EST_VC03 "mtotunder5"
label variable HC03_EST_VC03 "ftotunder5"
label variable HC01_EST_VC04 "tot5to9"
label variable HC02_EST_VC04 "mtot5to9"
label variable HC03_EST_VC04 "ftot5to9"
label variable HC01_EST_VC05 "tot10to14"
label variable HC02_EST_VC05 "mtot10to14"
label variable HC03_EST_VC05 "fot10to14"
label variable HC01_EST_VC06 "tot15to19"
label variable HC02_EST_VC06 "mtot15to19"
label variable HC03_EST_VC06 "ftot15to19"
label variable HC01_EST_VC07 "tot20to24"
label variable HC02_EST_VC07 "mtot20to24"
label variable HC03_EST_VC07 "ftot20to24"
label variable HC01_EST_VC08 "tot25to29"
label variable HC02_EST_VC08 "mtot25to29"
label variable HC03_EST_VC08 "ftot25to29"
label variable HC01_EST_VC09 "tot30to34"
label variable HC02_EST_VC09 "mtot30to34"
label variable HC03_EST_VC09 "ftot30to34"
label variable HC01_EST_VC10 "tot35to39"
label variable HC02_EST_VC10 "mtot35to39"
label variable HC03_EST_VC10 "ftot35to39"
label variable HC01_EST_VC11 "tot40to44"
label variable HC02_EST_VC11 "mtot40to44"
label variable HC03_EST_VC11 "ftot40to44"
label variable HC01_EST_VC12 "tot45to49"
label variable HC02_EST_VC12 "mtot45to49"
label variable HC03_EST_VC12 "ftot45to49"
label variable HC01_EST_VC13 "tot50to54"
label variable HC02_EST_VC13 "mtot50to54"
label variable HC03_EST_VC13 "ftot50to54"
label variable HC01_EST_VC14 "tot50to59"
label variable HC02_EST_VC14 "mtot50to59"
label variable HC03_EST_VC14 "ftot50to59"
label variable HC01_EST_VC15 "tot60to64"
label variable HC02_EST_VC15 "mtot60to64"
label variable HC03_EST_VC15 "ftot60to64"
label variable HC01_EST_VC16 "tot65to69"
label variable HC02_EST_VC16 "mtot65to69"
label variable HC03_EST_VC16 "ftot65to69"
label variable HC01_EST_VC17 "tot70to74"
label variable HC02_EST_VC17 "mtot70to74"
label variable HC03_EST_VC17 "ftot70to74"
label variable HC01_EST_VC18 "tot75to79"
label variable HC02_EST_VC18 "mtot75to79"
label variable HC03_EST_VC18 "ftot75to79"
label variable HC01_EST_VC19 "tot80to84"
label variable HC02_EST_VC19 "mtot80to84"
label variable HC03_EST_VC19 "ftot80to84"
label variable HC01_EST_VC20 "tot85up"
label variable HC02_EST_VC20 "mtot85up"
label variable HC03_EST_VC20 "ftot85up"


gen totunder5= HC01_EST_VC03*HC01_EST_VC01/100
gen mtotunder5= HC02_EST_VC03*HC01_EST_VC01/100
gen ftotunder5= HC03_EST_VC03*HC01_EST_VC01/100
gen tot5to9 = HC01_EST_VC04*HC01_EST_VC01/100
gen mtot5to9 = HC02_EST_VC04*HC01_EST_VC01/100
gen ftot5to9 = HC03_EST_VC04*HC01_EST_VC01/100
gen tot10to14 = HC01_EST_VC05*HC01_EST_VC01/100
gen mtot10to14 = HC02_EST_VC05*HC01_EST_VC01/100
gen ftot10to14 = HC03_EST_VC05*HC01_EST_VC01/100
gen tot15to19 = HC01_EST_VC06*HC01_EST_VC01/100
gen mtot15to19 = HC02_EST_VC06*HC01_EST_VC01/100
gen ftot15to19 = HC03_EST_VC06*HC01_EST_VC01/100
gen tot20to24 = HC01_EST_VC07*HC01_EST_VC01/100
gen mtot20to24 = HC02_EST_VC07*HC01_EST_VC01/100
gen ftot20to24 = HC03_EST_VC07*HC01_EST_VC01/100
gen tot25to29 = HC01_EST_VC08*HC01_EST_VC01/100
gen mtot25to29 = HC02_EST_VC08*HC01_EST_VC01/100
gen ftot25to29 = HC03_EST_VC08*HC01_EST_VC01/100
gen tot30to34 = HC01_EST_VC09*HC01_EST_VC01/100
gen mtot30to34 = HC02_EST_VC09*HC01_EST_VC01/100
gen ftot30to34 = HC03_EST_VC09*HC01_EST_VC01/100
gen tot35to39 = HC01_EST_VC10*HC01_EST_VC01/100
gen mtot35to39 = HC02_EST_VC10*HC01_EST_VC01/100
gen ftot35to39 = HC03_EST_VC10*HC01_EST_VC01/100
gen tot40to44 = HC01_EST_VC11*HC01_EST_VC01/100
gen mtot40to44 = HC02_EST_VC11*HC01_EST_VC01/100
gen ftot40to44 = HC03_EST_VC11*HC01_EST_VC01/100
gen tot45to49 = HC01_EST_VC12*HC01_EST_VC01/100
gen mtot45to49 = HC02_EST_VC12*HC01_EST_VC01/100
gen ftot45to49 = HC03_EST_VC12*HC01_EST_VC01/100
gen tot50to54 = HC01_EST_VC13*HC01_EST_VC01/100
gen mtot50to54 = HC02_EST_VC13*HC01_EST_VC01/100
gen ftot50to54 = HC03_EST_VC13*HC01_EST_VC01/100
gen tot55to59 = HC01_EST_VC14*HC01_EST_VC01/100
gen mtot55to59 = HC02_EST_VC14*HC01_EST_VC01/100
gen ftot55to59 = HC03_EST_VC14*HC01_EST_VC01/100
gen tot60to64 = HC01_EST_VC15*HC01_EST_VC01/100
gen mtot60to64 = HC02_EST_VC15*HC01_EST_VC01/100
gen ftot60to64 = HC03_EST_VC15*HC01_EST_VC01/100
gen tot65to69 = HC01_EST_VC16*HC01_EST_VC01/100
gen mtot65to69 = HC02_EST_VC16*HC01_EST_VC01/100
gen ftot65to69 = HC03_EST_VC16*HC01_EST_VC01/100
gen tot70to74 = HC01_EST_VC17*HC01_EST_VC01/100
gen mtot70to74 = HC02_EST_VC17*HC01_EST_VC01/100
gen ftot70to74 = HC03_EST_VC17*HC01_EST_VC01/100
gen tot75to79 = HC01_EST_VC18*HC01_EST_VC01/100
gen mtot75to79 = HC02_EST_VC18*HC01_EST_VC01/100
gen ftot75to79 = HC03_EST_VC18*HC01_EST_VC01/100
gen tot80to84 = HC01_EST_VC19*HC01_EST_VC01/100
gen mtot80to84 = HC02_EST_VC19*HC01_EST_VC01/100
gen ftot80to84 = HC03_EST_VC19*HC01_EST_VC01/100
gen tot85up = HC01_EST_VC20*HC01_EST_VC01/100
gen mtot85up = HC02_EST_VC20*HC01_EST_VC01/100
gen ftot85up = HC03_EST_VC20*HC01_EST_VC01/100


/*
collapse (sum) HC01_EST_VC01  HC02_EST_VC01 HC03_EST_VC01 HC01_EST_VC03 HC02_EST_VC03 HC03_EST_VC03 HC01_EST_VC04 HC02_EST_VC04 HC03_EST_VC04 ///
               HC01_EST_VC05 HC02_EST_VC05 HC03_EST_VC05 HC01_EST_VC06 HC02_EST_VC06 HC03_EST_VC06 HC01_EST_VC07 HC02_EST_VC07 HC03_EST_VC07 ///
			   HC01_EST_VC08 HC02_EST_VC08 HC03_EST_VC08 HC01_EST_VC09 HC02_EST_VC09 HC03_EST_VC09 HC01_EST_VC10 HC02_EST_VC10 HC03_EST_VC10 ///
			   HC01_EST_VC11 HC02_EST_VC11 HC03_EST_VC11 HC01_EST_VC12 HC02_EST_VC12 HC03_EST_VC12 HC01_EST_VC13 HC02_EST_VC13 HC03_EST_VC13 ///
			   HC01_EST_VC14  HC02_EST_VC14  HC03_EST_VC14 HC01_EST_VC15 HC02_EST_VC15 HC03_EST_VC15 HC01_EST_VC16 HC02_EST_VC16 HC03_EST_VC16 ///
			   HC01_EST_VC17  HC02_EST_VC17  HC03_EST_VC17  HC01_EST_VC18 HC02_EST_VC18 HC03_EST_VC18 HC01_EST_VC19 HC02_EST_VC19 HC03_EST_VC19 ///
			   HC01_EST_VC20 HC02_EST_VC20 HC03_EST_VC20 , by (Year)

*/


collapse (sum) HC01_EST_VC01 HC02_EST_VC01 HC03_EST_VC01 totunder5 mtotunder5 ftotunder5 tot5to9 mtot5to9 ftot5to9 tot10to14 mtot10to14 ftot10to14 ///
              tot15to19  mtot15to19 ftot15to19 tot20to24 mtot20to24 ftot20to24 tot25to29 mtot25to29 ftot25to29 ///
			  tot30to34  mtot30to34 ftot30to34 tot35to39 mtot35to39 ftot35to39 tot40to44 mtot40to44 ftot40to44 ///
			   tot45to49  mtot45to49 ftot45to49 tot50to54 mtot50to54 ftot50to54 tot55to59 mtot55to59 ftot55to59 ///
			   tot60to64 mtot60to64 ftot60to64 tot65to69 mtot65to69 ftot65to69 tot70to74 mtot70to74 ftot70to74 ///
			   tot75to79 mtot75to79 ftot75to79 tot80to84 mtot80to84 ftot80to84 tot85up mtot85up ftot85up, by (Year)








