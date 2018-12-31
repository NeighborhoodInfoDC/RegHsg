********************************************************************************
* Author: Yipeng Su
* Project: Regional Housing Framework
* Date: 12/28/2018
* Moderation:
********************************************************************************

import excel "L:\Libraries\RegHsg\Raw\ACS 1 year estimate\All_1year.xlsx", sheet("Sheet1") firstrow

label variable HC01_EST_VC01 "Total population"
label variable HC02_EST_VC01 "Total male population"
label variable HC03_EST_VC01 "Total female population"

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

label variable totunder5 "Total population under 5 years old"
label variable mtotunder5 "Total Male population under 5 years old"
label variable ftotunder5 "Total Femal population under 5 years old"
label variable tot5to9 "Total population 5-9 years old"
label variable mtot5to9 "Total male population 5-9 years old"
label variable ftot5to9 "Total female population 5-9 years old"
label variable tot10to14 "Total population 10-14 years old"
label variable mtot10to14 "Total male population 10-14 years old"
label variable ftot10to14 "Total female population 10-14 years old"
label variable tot15to19 "Total population 15-19 years old"
label variable mtot15to19 "Total male population 15-19 years old"
label variable ftot15to19 "Total female population 15-19 years old"
label variable tot20to24 "Total population 20-24 years old"
label variable mtot20to24 "Total male population 20-24 years old"
label  variable ftot20to24 "Total female population 20-24 years old"
label variable tot25to29 "Total population 25-29 years old"
label variable mtot25to29 "Total male population 25-29 years old"
label variable ftot25to29 "Total female population 25-29 years old"
label variable tot30to34 "Total population 30-34 years old"
label variable mtot30to34 "Total male population 30-34 years old"
label  variable ftot30to34 "Total female population 30-34 years old"
label variable tot35to39 "Total population 35-39 years old"
label variable mtot35to39 "Total male population 35-39 years old"
label variable ftot35to39 "Total female population 35-39 years old"
label variable tot40to44 "Total population 40-44 years old"
label variable mtot40to44 "Total male population 40-44 years old"
label variable ftot40to44 "Total female population 40-44 years old"
label variable tot45to49 "Total population 45-49 years old"
label variable mtot45to49 "Total male population 45-49 years old"
label variable ftot45to49 "Total female population 45-49 years old"
label variable tot50to54 "Total population 50-54  years old"
label variable mtot50to54 "Total male population 50-54  years old"
label variable ftot50to54 "Total female population 50-54  years old"
label variable tot55to59 "Total population 55-59 years old"
label  variable mtot55to59 "Total male population 55-59 years old"
label variable ftot55to59 "Total female population 55-59 years old"
label  variable tot60to64 "Total population 60-64 years old"
label  variable mtot60to64 "Total male population 60-64 years old"
label  variable ftot60to64 "Total female population 60-64 years old"
label  variable tot65to69 "Total population 65-69 years old"
label  variable mtot65to69 "Total male population 65-69 years old"
label  variable ftot65to69 "Total female population 65-69 years old"
label  variable tot70to74 "Total population 70-74 years old"
label  variable mtot70to74 "Total male population 70-74 years old"
label  variable ftot70to74 "Total female population 70-74 years old"
label variable tot75to79 "Total population 75-79 years old"
label variable mtot75to79 "Total male population 75-79 years old"
label variable ftot75to79 "Total female population 75-79 years old"
label variable tot80to84 "Total population 80-84 years old"
label variable mtot80to84 "Total male population 80-84 years old"
label variable ftot80to84 "Total female population 80-84 years old"
label variable tot85up "Total population 85+ years old"
label variable mtot85up "Total male population 85+ years old"
label variable ftot85up "Total female population 85+ years old"

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
			   

label variable HC01_EST_VC01 "Total population"
label variable HC02_EST_VC01 "Total male population"
label variable HC03_EST_VC01 "Total female population"
label variable totunder5 "Total population under 5 years old"
label variable mtotunder5 "Total Male population under 5 years old"
label variable ftotunder5 "Total Femal population under 5 years old"
label variable tot5to9 "Total population 5-9 years old"
label variable mtot5to9 "Total male population 5-9 years old"
label variable ftot5to9 "Total female population 5-9 years old"
label variable tot10to14 "Total population 10-14 years old"
label variable mtot10to14 "Total male population 10-14 years old"
label variable ftot10to14 "Total female population 10-14 years old"
label variable tot15to19 "Total population 15-19 years old"
label variable mtot15to19 "Total male population 15-19 years old"
label variable ftot15to19 "Total female population 15-19 years old"
label variable tot20to24 "Total population 20-24 years old"
label variable mtot20to24 "Total male population 20-24 years old"
label  variable ftot20to24 "Total female population 20-24 years old"
label variable tot25to29 "Total population 25-29 years old"
label variable mtot25to29 "Total male population 25-29 years old"
label variable ftot25to29 "Total female population 25-29 years old"
label variable tot30to34 "Total population 30-34 years old"
label variable mtot30to34 "Total male population 30-34 years old"
label  variable ftot30to34 "Total female population 30-34 years old"
label variable tot35to39 "Total population 35-39 years old"
label variable mtot35to39 "Total male population 35-39 years old"
label variable ftot35to39 "Total female population 35-39 years old"
label variable tot40to44 "Total population 40-44 years old"
label variable mtot40to44 "Total male population 40-44 years old"
label variable ftot40to44 "Total female population 40-44 years old"
label variable tot45to49 "Total population 45-49 years old"
label variable mtot45to49 "Total male population 45-49 years old"
label variable ftot45to49 "Total female population 45-49 years old"
label variable tot50to54 "Total population 50-54  years old"
label variable mtot50to54 "Total male population 50-54  years old"
label variable ftot50to54 "Total female population 50-54  years old"
label variable tot55to59 "Total population 55-59 years old"
label  variable mtot55to59 "Total male population 55-59 years old"
label variable ftot55to59 "Total female population 55-59 years old"
label  variable tot60to64 "Total population 60-64 years old"
label  variable mtot60to64 "Total male population 60-64 years old"
label  variable ftot60to64 "Total female population 60-64 years old"
label  variable tot65to69 "Total population 65-69 years old"
label  variable mtot65to69 "Total male population 65-69 years old"
label  variable ftot65to69 "Total female population 65-69 years old"
label  variable tot70to74 "Total population 70-74 years old"
label  variable mtot70to74 "Total male population 70-74 years old"
label  variable ftot70to74 "Total female population 70-74 years old"
label variable tot75to79 "Total population 75-79 years old"
label variable mtot75to79 "Total male population 75-79 years old"
label variable ftot75to79 "Total female population 75-79 years old"
label variable tot80to84 "Total population 80-84 years old"
label variable mtot80to84 "Total male population 80-84 years old"
label variable ftot80to84 "Total female population 80-84 years old"
label variable tot85up "Total population 85+ years old"
label variable mtot85up "Total male population 85+ years old"
label variable ftot85up "Total female population 85+ years old"

save "D:\DCData\Libraries\RegHsg\Data\08-16 ACS 1year.dta", replace

clear

import excel "L:\Libraries\RegHsg\Raw\ACS 1 year estimate\ACS_17_1YR_2017.xlsx", sheet("Sheet1") firstrow

label variable HC01_EST_VC01 "Total population"
label variable HC03_EST_VC01 "Total male population"
label variable HC05_EST_VC01 "Total female population"


gen totunder5= HC02_EST_VC03*HC01_EST_VC01/100
gen mtotunder5= HC04_EST_VC03*HC01_EST_VC01/100
gen ftotunder5= HC06_EST_VC03*HC01_EST_VC01/100
gen tot5to9 = HC02_EST_VC04*HC01_EST_VC01/100
gen mtot5to9 = HC04_EST_VC04*HC01_EST_VC01/100
gen ftot5to9 = HC06_EST_VC04*HC01_EST_VC01/100
gen tot10to14 = HC02_EST_VC05*HC01_EST_VC01/100
gen mtot10to14 = HC04_EST_VC05*HC01_EST_VC01/100
gen ftot10to14 = HC06_EST_VC05*HC01_EST_VC01/100
gen tot15to19 = HC02_EST_VC06*HC01_EST_VC01/100
gen mtot15to19 = HC04_EST_VC06*HC01_EST_VC01/100
gen ftot15to19 = HC06_EST_VC06*HC01_EST_VC01/100
gen tot20to24 = HC02_EST_VC07*HC01_EST_VC01/100
gen mtot20to24 = HC04_EST_VC07*HC01_EST_VC01/100
gen ftot20to24 = HC06_EST_VC07*HC01_EST_VC01/100
gen tot25to29 = HC02_EST_VC08*HC01_EST_VC01/100
gen mtot25to29 = HC04_EST_VC08*HC01_EST_VC01/100
gen ftot25to29 = HC06_EST_VC08*HC01_EST_VC01/100
gen tot30to34 = HC02_EST_VC09*HC01_EST_VC01/100
gen mtot30to34 = HC04_EST_VC09*HC01_EST_VC01/100
gen ftot30to34 = HC06_EST_VC09*HC01_EST_VC01/100
gen tot35to39 = HC02_EST_VC10*HC01_EST_VC01/100
gen mtot35to39 = HC04_EST_VC10*HC01_EST_VC01/100
gen ftot35to39 = HC06_EST_VC10*HC01_EST_VC01/100
gen tot40to44 = HC02_EST_VC11*HC01_EST_VC01/100
gen mtot40to44 = HC04_EST_VC11*HC01_EST_VC01/100
gen ftot40to44 = HC06_EST_VC11*HC01_EST_VC01/100
gen tot45to49 = HC02_EST_VC12*HC01_EST_VC01/100
gen mtot45to49 = HC04_EST_VC12*HC01_EST_VC01/100
gen ftot45to49 = HC06_EST_VC12*HC01_EST_VC01/100
gen tot50to54 = HC02_EST_VC13*HC01_EST_VC01/100
gen mtot50to54 = HC04_EST_VC13*HC01_EST_VC01/100
gen ftot50to54 = HC06_EST_VC13*HC01_EST_VC01/100
gen tot55to59 = HC02_EST_VC14*HC01_EST_VC01/100
gen mtot55to59 = HC04_EST_VC14*HC01_EST_VC01/100
gen ftot55to59 = HC06_EST_VC14*HC01_EST_VC01/100
gen tot60to64 = HC02_EST_VC15*HC01_EST_VC01/100
gen mtot60to64 = HC04_EST_VC15*HC01_EST_VC01/100
gen ftot60to64 = HC06_EST_VC15*HC01_EST_VC01/100
gen tot65to69 = HC02_EST_VC16*HC01_EST_VC01/100
gen mtot65to69 = HC04_EST_VC16*HC01_EST_VC01/100
gen ftot65to69 = HC06_EST_VC16*HC01_EST_VC01/100
gen tot70to74 = HC02_EST_VC17*HC01_EST_VC01/100
gen mtot70to74 = HC04_EST_VC17*HC01_EST_VC01/100
gen ftot70to74 = HC06_EST_VC17*HC01_EST_VC01/100
gen tot75to79 = HC02_EST_VC18*HC01_EST_VC01/100
gen mtot75to79 = HC04_EST_VC18*HC01_EST_VC01/100
gen ftot75to79 = HC06_EST_VC18*HC01_EST_VC01/100
gen tot80to84 = HC02_EST_VC19*HC01_EST_VC01/100
gen mtot80to84 = HC04_EST_VC19*HC01_EST_VC01/100
gen ftot80to84 = HC06_EST_VC19*HC01_EST_VC01/100
gen tot85up = HC02_EST_VC20*HC01_EST_VC01/100
gen mtot85up = HC04_EST_VC20*HC01_EST_VC01/100
gen ftot85up = HC06_EST_VC20*HC01_EST_VC01/100


label variable totunder5 "Total population under 5 years old"
label variable mtotunder5 "Total Male population under 5 years old"
label variable ftotunder5 "Total Femal population under 5 years old"
label variable tot5to9 "Total population 5-9 years old"
label variable mtot5to9 "Total male population 5-9 years old"
label variable ftot5to9 "Total female population 5-9 years old"
label variable tot10to14 "Total population 10-14 years old"
label variable mtot10to14 "Total male population 10-14 years old"
label variable ftot10to14 "Total female population 10-14 years old"
label variable tot15to19 "Total population 15-19 years old"
label variable mtot15to19 "Total male population 15-19 years old"
label variable ftot15to19 "Total female population 15-19 years old"
label variable tot20to24 "Total population 20-24 years old"
label variable mtot20to24 "Total male population 20-24 years old"
label  variable ftot20to24 "Total female population 20-24 years old"
label variable tot25to29 "Total population 25-29 years old"
label variable mtot25to29 "Total male population 25-29 years old"
label variable ftot25to29 "Total female population 25-29 years old"
label variable tot30to34 "Total population 30-34 years old"
label variable mtot30to34 "Total male population 30-34 years old"
label  variable ftot30to34 "Total female population 30-34 years old"
label variable tot35to39 "Total population 35-39 years old"
label variable mtot35to39 "Total male population 35-39 years old"
label variable ftot35to39 "Total female population 35-39 years old"
label variable tot40to44 "Total population 40-44 years old"
label variable mtot40to44 "Total male population 40-44 years old"
label variable ftot40to44 "Total female population 40-44 years old"
label variable tot45to49 "Total population 45-49 years old"
label variable mtot45to49 "Total male population 45-49 years old"
label variable ftot45to49 "Total female population 45-49 years old"
label variable tot50to54 "Total population 50-54  years old"
label variable mtot50to54 "Total male population 50-54  years old"
label variable ftot50to54 "Total female population 50-54  years old"
label variable tot55to59 "Total population 55-59 years old"
label  variable mtot55to59 "Total male population 55-59 years old"
label variable ftot55to59 "Total female population 55-59 years old"
label  variable tot60to64 "Total population 60-64 years old"
label  variable mtot60to64 "Total male population 60-64 years old"
label  variable ftot60to64 "Total female population 60-64 years old"
label  variable tot65to69 "Total population 65-69 years old"
label  variable mtot65to69 "Total male population 65-69 years old"
label  variable ftot65to69 "Total female population 65-69 years old"
label  variable tot70to74 "Total population 70-74 years old"
label  variable mtot70to74 "Total male population 70-74 years old"
label  variable ftot70to74 "Total female population 70-74 years old"
label variable tot75to79 "Total population 75-79 years old"
label variable mtot75to79 "Total male population 75-79 years old"
label variable ftot75to79 "Total female population 75-79 years old"
label variable tot80to84 "Total population 80-84 years old"
label variable mtot80to84 "Total male population 80-84 years old"
label variable ftot80to84 "Total female population 80-84 years old"
label variable tot85up "Total population 85+ years old"
label variable mtot85up "Total male population 85+ years old"
label variable ftot85up "Total female population 85+ years old"

collapse (sum) HC01_EST_VC01 HC03_EST_VC01 HC05_EST_VC01 totunder5 mtotunder5 ftotunder5 tot5to9 mtot5to9 ftot5to9 tot10to14 mtot10to14 ftot10to14 ///
              tot15to19  mtot15to19 ftot15to19 tot20to24 mtot20to24 ftot20to24 tot25to29 mtot25to29 ftot25to29 ///
			  tot30to34  mtot30to34 ftot30to34 tot35to39 mtot35to39 ftot35to39 tot40to44 mtot40to44 ftot40to44 ///
			   tot45to49  mtot45to49 ftot45to49 tot50to54 mtot50to54 ftot50to54 tot55to59 mtot55to59 ftot55to59 ///
			   tot60to64 mtot60to64 ftot60to64 tot65to69 mtot65to69 ftot65to69 tot70to74 mtot70to74 ftot70to74 ///
			   tot75to79 mtot75to79 ftot75to79 tot80to84 mtot80to84 ftot80to84 tot85up mtot85up ftot85up, by (Year)
		
		
label variable HC01_EST_VC01 "Total population"
label variable HC03_EST_VC01 "Total male population"
label variable HC05_EST_VC01 "Total female population"
label variable totunder5 "Total population under 5 years old"
label variable mtotunder5 "Total Male population under 5 years old"
label variable ftotunder5 "Total Femal population under 5 years old"
label variable tot5to9 "Total population 5-9 years old"
label variable mtot5to9 "Total male population 5-9 years old"
label variable ftot5to9 "Total female population 5-9 years old"
label variable tot10to14 "Total population 10-14 years old"
label variable mtot10to14 "Total male population 10-14 years old"
label variable ftot10to14 "Total female population 10-14 years old"
label variable tot15to19 "Total population 15-19 years old"
label variable mtot15to19 "Total male population 15-19 years old"
label variable ftot15to19 "Total female population 15-19 years old"
label variable tot20to24 "Total population 20-24 years old"
label variable mtot20to24 "Total male population 20-24 years old"
label  variable ftot20to24 "Total female population 20-24 years old"
label variable tot25to29 "Total population 25-29 years old"
label variable mtot25to29 "Total male population 25-29 years old"
label variable ftot25to29 "Total female population 25-29 years old"
label variable tot30to34 "Total population 30-34 years old"
label variable mtot30to34 "Total male population 30-34 years old"
label  variable ftot30to34 "Total female population 30-34 years old"
label variable tot35to39 "Total population 35-39 years old"
label variable mtot35to39 "Total male population 35-39 years old"
label variable ftot35to39 "Total female population 35-39 years old"
label variable tot40to44 "Total population 40-44 years old"
label variable mtot40to44 "Total male population 40-44 years old"
label variable ftot40to44 "Total female population 40-44 years old"
label variable tot45to49 "Total population 45-49 years old"
label variable mtot45to49 "Total male population 45-49 years old"
label variable ftot45to49 "Total female population 45-49 years old"
label variable tot50to54 "Total population 50-54  years old"
label variable mtot50to54 "Total male population 50-54  years old"
label variable ftot50to54 "Total female population 50-54  years old"
label variable tot55to59 "Total population 55-59 years old"
label  variable mtot55to59 "Total male population 55-59 years old"
label variable ftot55to59 "Total female population 55-59 years old"
label  variable tot60to64 "Total population 60-64 years old"
label  variable mtot60to64 "Total male population 60-64 years old"
label  variable ftot60to64 "Total female population 60-64 years old"
label  variable tot65to69 "Total population 65-69 years old"
label  variable mtot65to69 "Total male population 65-69 years old"
label  variable ftot65to69 "Total female population 65-69 years old"
label  variable tot70to74 "Total population 70-74 years old"
label  variable mtot70to74 "Total male population 70-74 years old"
label  variable ftot70to74 "Total female population 70-74 years old"
label variable tot75to79 "Total population 75-79 years old"
label variable mtot75to79 "Total male population 75-79 years old"
label variable ftot75to79 "Total female population 75-79 years old"
label variable tot80to84 "Total population 80-84 years old"
label variable mtot80to84 "Total male population 80-84 years old"
label variable ftot80to84 "Total female population 80-84 years old"
label variable tot85up "Total population 85+ years old"
label variable mtot85up "Total male population 85+ years old"
label variable ftot85up "Total female population 85+ years old"

rename HC03_EST_VC01 HC02_EST_VC01
rename HC05_EST_VC01 HC03_EST_VC01
			   
append using "D:\DCData\Libraries\RegHsg\Data\08-16 ACS 1year.dta", force

sort Year

rename HC01_EST_VC01 totpop
rename HC02_EST_VC01 totmalepop
rename HC03_EST_VC01 totfemalepop

xpose, clear varname format

order _varname v1-v11

save "D:\DCData\Libraries\RegHsg\Data\ACS_1year_gender.dta", replace

export excel using "D:\DCData\Libraries\RegHsg\Prog\ACS_1year_gender.xlsx", replace

clear

***************************population by gender 5 year estimate ****************

import excel "L:\Libraries\RegHsg\Raw\ACS 5 year estimate\All_5year.xlsx", sheet("Sheet1") firstrow

label variable HC01_EST_VC01 "Total population"
label variable HC02_EST_VC01 "Total male population"
label variable HC03_EST_VC01 "Total female population"

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

label variable totunder5 "Total population under 5 years old"
label variable mtotunder5 "Total Male population under 5 years old"
label variable ftotunder5 "Total Femal population under 5 years old"
label variable tot5to9 "Total population 5-9 years old"
label variable mtot5to9 "Total male population 5-9 years old"
label variable ftot5to9 "Total female population 5-9 years old"
label variable tot10to14 "Total population 10-14 years old"
label variable mtot10to14 "Total male population 10-14 years old"
label variable ftot10to14 "Total female population 10-14 years old"
label variable tot15to19 "Total population 15-19 years old"
label variable mtot15to19 "Total male population 15-19 years old"
label variable ftot15to19 "Total female population 15-19 years old"
label variable tot20to24 "Total population 20-24 years old"
label variable mtot20to24 "Total male population 20-24 years old"
label  variable ftot20to24 "Total female population 20-24 years old"
label variable tot25to29 "Total population 25-29 years old"
label variable mtot25to29 "Total male population 25-29 years old"
label variable ftot25to29 "Total female population 25-29 years old"
label variable tot30to34 "Total population 30-34 years old"
label variable mtot30to34 "Total male population 30-34 years old"
label  variable ftot30to34 "Total female population 30-34 years old"
label variable tot35to39 "Total population 35-39 years old"
label variable mtot35to39 "Total male population 35-39 years old"
label variable ftot35to39 "Total female population 35-39 years old"
label variable tot40to44 "Total population 40-44 years old"
label variable mtot40to44 "Total male population 40-44 years old"
label variable ftot40to44 "Total female population 40-44 years old"
label variable tot45to49 "Total population 45-49 years old"
label variable mtot45to49 "Total male population 45-49 years old"
label variable ftot45to49 "Total female population 45-49 years old"
label variable tot50to54 "Total population 50-54  years old"
label variable mtot50to54 "Total male population 50-54  years old"
label variable ftot50to54 "Total female population 50-54  years old"
label variable tot55to59 "Total population 55-59 years old"
label  variable mtot55to59 "Total male population 55-59 years old"
label variable ftot55to59 "Total female population 55-59 years old"
label  variable tot60to64 "Total population 60-64 years old"
label  variable mtot60to64 "Total male population 60-64 years old"
label  variable ftot60to64 "Total female population 60-64 years old"
label  variable tot65to69 "Total population 65-69 years old"
label  variable mtot65to69 "Total male population 65-69 years old"
label  variable ftot65to69 "Total female population 65-69 years old"
label  variable tot70to74 "Total population 70-74 years old"
label  variable mtot70to74 "Total male population 70-74 years old"
label  variable ftot70to74 "Total female population 70-74 years old"
label variable tot75to79 "Total population 75-79 years old"
label variable mtot75to79 "Total male population 75-79 years old"
label variable ftot75to79 "Total female population 75-79 years old"
label variable tot80to84 "Total population 80-84 years old"
label variable mtot80to84 "Total male population 80-84 years old"
label variable ftot80to84 "Total female population 80-84 years old"
label variable tot85up "Total population 85+ years old"
label variable mtot85up "Total male population 85+ years old"
label variable ftot85up "Total female population 85+ years old"

collapse (sum) HC01_EST_VC01 HC02_EST_VC01 HC03_EST_VC01 totunder5 mtotunder5 ftotunder5 tot5to9 mtot5to9 ftot5to9 tot10to14 mtot10to14 ftot10to14 ///
              tot15to19  mtot15to19 ftot15to19 tot20to24 mtot20to24 ftot20to24 tot25to29 mtot25to29 ftot25to29 ///
			  tot30to34  mtot30to34 ftot30to34 tot35to39 mtot35to39 ftot35to39 tot40to44 mtot40to44 ftot40to44 ///
			   tot45to49  mtot45to49 ftot45to49 tot50to54 mtot50to54 ftot50to54 tot55to59 mtot55to59 ftot55to59 ///
			   tot60to64 mtot60to64 ftot60to64 tot65to69 mtot65to69 ftot65to69 tot70to74 mtot70to74 ftot70to74 ///
			   tot75to79 mtot75to79 ftot75to79 tot80to84 mtot80to84 ftot80to84 tot85up mtot85up ftot85up, by (Year)
			   
label variable HC01_EST_VC01 "Total population"
label variable HC02_EST_VC01 "Total male population"
label variable HC03_EST_VC01 "Total female population"	
label variable totunder5 "Total population under 5 years old"
label variable mtotunder5 "Total Male population under 5 years old"
label variable ftotunder5 "Total Femal population under 5 years old"
label variable tot5to9 "Total population 5-9 years old"
label variable mtot5to9 "Total male population 5-9 years old"
label variable ftot5to9 "Total female population 5-9 years old"
label variable tot10to14 "Total population 10-14 years old"
label variable mtot10to14 "Total male population 10-14 years old"
label variable ftot10to14 "Total female population 10-14 years old"
label variable tot15to19 "Total population 15-19 years old"
label variable mtot15to19 "Total male population 15-19 years old"
label variable ftot15to19 "Total female population 15-19 years old"
label variable tot20to24 "Total population 20-24 years old"
label variable mtot20to24 "Total male population 20-24 years old"
label  variable ftot20to24 "Total female population 20-24 years old"
label variable tot25to29 "Total population 25-29 years old"
label variable mtot25to29 "Total male population 25-29 years old"
label variable ftot25to29 "Total female population 25-29 years old"
label variable tot30to34 "Total population 30-34 years old"
label variable mtot30to34 "Total male population 30-34 years old"
label  variable ftot30to34 "Total female population 30-34 years old"
label variable tot35to39 "Total population 35-39 years old"
label variable mtot35to39 "Total male population 35-39 years old"
label variable ftot35to39 "Total female population 35-39 years old"
label variable tot40to44 "Total population 40-44 years old"
label variable mtot40to44 "Total male population 40-44 years old"
label variable ftot40to44 "Total female population 40-44 years old"
label variable tot45to49 "Total population 45-49 years old"
label variable mtot45to49 "Total male population 45-49 years old"
label variable ftot45to49 "Total female population 45-49 years old"
label variable tot50to54 "Total population 50-54  years old"
label variable mtot50to54 "Total male population 50-54  years old"
label variable ftot50to54 "Total female population 50-54  years old"
label variable tot55to59 "Total population 55-59 years old"
label  variable mtot55to59 "Total male population 55-59 years old"
label variable ftot55to59 "Total female population 55-59 years old"
label  variable tot60to64 "Total population 60-64 years old"
label  variable mtot60to64 "Total male population 60-64 years old"
label  variable ftot60to64 "Total female population 60-64 years old"
label  variable tot65to69 "Total population 65-69 years old"
label  variable mtot65to69 "Total male population 65-69 years old"
label  variable ftot65to69 "Total female population 65-69 years old"
label  variable tot70to74 "Total population 70-74 years old"
label  variable mtot70to74 "Total male population 70-74 years old"
label  variable ftot70to74 "Total female population 70-74 years old"
label variable tot75to79 "Total population 75-79 years old"
label variable mtot75to79 "Total male population 75-79 years old"
label variable ftot75to79 "Total female population 75-79 years old"
label variable tot80to84 "Total population 80-84 years old"
label variable mtot80to84 "Total male population 80-84 years old"
label variable ftot80to84 "Total female population 80-84 years old"
label variable tot85up "Total population 85+ years old"
label variable mtot85up "Total male population 85+ years old"
label variable ftot85up "Total female population 85+ years old"   
			  
save "D:\DCData\Libraries\RegHsg\Data\09-16 ACS 5year.dta", replace

clear

import excel "L:\Libraries\RegHsg\Raw\ACS 5 year estimate\ACS_17_5YR.xlsx", sheet("Sheet1") firstrow


label variable HC01_EST_VC01 "Total population"
label variable HC03_EST_VC01 "Total male population"
label variable HC05_EST_VC01 "Total female population"

gen totunder5= HC02_EST_VC03*HC01_EST_VC01/100
gen mtotunder5= HC04_EST_VC03*HC01_EST_VC01/100
gen ftotunder5= HC06_EST_VC03*HC01_EST_VC01/100
gen tot5to9 = HC02_EST_VC04*HC01_EST_VC01/100
gen mtot5to9 = HC04_EST_VC04*HC01_EST_VC01/100
gen ftot5to9 = HC06_EST_VC04*HC01_EST_VC01/100
gen tot10to14 = HC02_EST_VC05*HC01_EST_VC01/100
gen mtot10to14 = HC04_EST_VC05*HC01_EST_VC01/100
gen ftot10to14 = HC06_EST_VC05*HC01_EST_VC01/100
gen tot15to19 = HC02_EST_VC06*HC01_EST_VC01/100
gen mtot15to19 = HC04_EST_VC06*HC01_EST_VC01/100
gen ftot15to19 = HC06_EST_VC06*HC01_EST_VC01/100
gen tot20to24 = HC02_EST_VC07*HC01_EST_VC01/100
gen mtot20to24 = HC04_EST_VC07*HC01_EST_VC01/100
gen ftot20to24 = HC06_EST_VC07*HC01_EST_VC01/100
gen tot25to29 = HC02_EST_VC08*HC01_EST_VC01/100
gen mtot25to29 = HC04_EST_VC08*HC01_EST_VC01/100
gen ftot25to29 = HC06_EST_VC08*HC01_EST_VC01/100
gen tot30to34 = HC02_EST_VC09*HC01_EST_VC01/100
gen mtot30to34 = HC04_EST_VC09*HC01_EST_VC01/100
gen ftot30to34 = HC06_EST_VC09*HC01_EST_VC01/100
gen tot35to39 = HC02_EST_VC10*HC01_EST_VC01/100
gen mtot35to39 = HC04_EST_VC10*HC01_EST_VC01/100
gen ftot35to39 = HC06_EST_VC10*HC01_EST_VC01/100
gen tot40to44 = HC02_EST_VC11*HC01_EST_VC01/100
gen mtot40to44 = HC04_EST_VC11*HC01_EST_VC01/100
gen ftot40to44 = HC06_EST_VC11*HC01_EST_VC01/100
gen tot45to49 = HC02_EST_VC12*HC01_EST_VC01/100
gen mtot45to49 = HC04_EST_VC12*HC01_EST_VC01/100
gen ftot45to49 = HC06_EST_VC12*HC01_EST_VC01/100
gen tot50to54 = HC02_EST_VC13*HC01_EST_VC01/100
gen mtot50to54 = HC04_EST_VC13*HC01_EST_VC01/100
gen ftot50to54 = HC06_EST_VC13*HC01_EST_VC01/100
gen tot55to59 = HC02_EST_VC14*HC01_EST_VC01/100
gen mtot55to59 = HC04_EST_VC14*HC01_EST_VC01/100
gen ftot55to59 = HC06_EST_VC14*HC01_EST_VC01/100
gen tot60to64 = HC02_EST_VC15*HC01_EST_VC01/100
gen mtot60to64 = HC04_EST_VC15*HC01_EST_VC01/100
gen ftot60to64 = HC06_EST_VC15*HC01_EST_VC01/100
gen tot65to69 = HC02_EST_VC16*HC01_EST_VC01/100
gen mtot65to69 = HC04_EST_VC16*HC01_EST_VC01/100
gen ftot65to69 = HC06_EST_VC16*HC01_EST_VC01/100
gen tot70to74 = HC02_EST_VC17*HC01_EST_VC01/100
gen mtot70to74 = HC04_EST_VC17*HC01_EST_VC01/100
gen ftot70to74 = HC06_EST_VC17*HC01_EST_VC01/100
gen tot75to79 = HC02_EST_VC18*HC01_EST_VC01/100
gen mtot75to79 = HC04_EST_VC18*HC01_EST_VC01/100
gen ftot75to79 = HC06_EST_VC18*HC01_EST_VC01/100
gen tot80to84 = HC02_EST_VC19*HC01_EST_VC01/100
gen mtot80to84 = HC04_EST_VC19*HC01_EST_VC01/100
gen ftot80to84 = HC06_EST_VC19*HC01_EST_VC01/100
gen tot85up = HC02_EST_VC20*HC01_EST_VC01/100
gen mtot85up = HC04_EST_VC20*HC01_EST_VC01/100
gen ftot85up = HC06_EST_VC20*HC01_EST_VC01/100


label variable totunder5 "Total population under 5 years old"
label variable mtotunder5 "Total Male population under 5 years old"
label variable ftotunder5 "Total Femal population under 5 years old"
label variable tot5to9 "Total population 5-9 years old"
label variable mtot5to9 "Total male population 5-9 years old"
label variable ftot5to9 "Total female population 5-9 years old"
label variable tot10to14 "Total population 10-14 years old"
label variable mtot10to14 "Total male population 10-14 years old"
label variable ftot10to14 "Total female population 10-14 years old"
label variable tot15to19 "Total population 15-19 years old"
label variable mtot15to19 "Total male population 15-19 years old"
label variable ftot15to19 "Total female population 15-19 years old"
label variable tot20to24 "Total population 20-24 years old"
label variable mtot20to24 "Total male population 20-24 years old"
label  variable ftot20to24 "Total female population 20-24 years old"
label variable tot25to29 "Total population 25-29 years old"
label variable mtot25to29 "Total male population 25-29 years old"
label variable ftot25to29 "Total female population 25-29 years old"
label variable tot30to34 "Total population 30-34 years old"
label variable mtot30to34 "Total male population 30-34 years old"
label  variable ftot30to34 "Total female population 30-34 years old"
label variable tot35to39 "Total population 35-39 years old"
label variable mtot35to39 "Total male population 35-39 years old"
label variable ftot35to39 "Total female population 35-39 years old"
label variable tot40to44 "Total population 40-44 years old"
label variable mtot40to44 "Total male population 40-44 years old"
label variable ftot40to44 "Total female population 40-44 years old"
label variable tot45to49 "Total population 45-49 years old"
label variable mtot45to49 "Total male population 45-49 years old"
label variable ftot45to49 "Total female population 45-49 years old"
label variable tot50to54 "Total population 50-54  years old"
label variable mtot50to54 "Total male population 50-54  years old"
label variable ftot50to54 "Total female population 50-54  years old"
label variable tot55to59 "Total population 55-59 years old"
label  variable mtot55to59 "Total male population 55-59 years old"
label variable ftot55to59 "Total female population 55-59 years old"
label  variable tot60to64 "Total population 60-64 years old"
label  variable mtot60to64 "Total male population 60-64 years old"
label  variable ftot60to64 "Total female population 60-64 years old"
label  variable tot65to69 "Total population 65-69 years old"
label  variable mtot65to69 "Total male population 65-69 years old"
label  variable ftot65to69 "Total female population 65-69 years old"
label  variable tot70to74 "Total population 70-74 years old"
label  variable mtot70to74 "Total male population 70-74 years old"
label  variable ftot70to74 "Total female population 70-74 years old"
label variable tot75to79 "Total population 75-79 years old"
label variable mtot75to79 "Total male population 75-79 years old"
label variable ftot75to79 "Total female population 75-79 years old"
label variable tot80to84 "Total population 80-84 years old"
label variable mtot80to84 "Total male population 80-84 years old"
label variable ftot80to84 "Total female population 80-84 years old"
label variable tot85up "Total population 85+ years old"
label variable mtot85up "Total male population 85+ years old"
label variable ftot85up "Total female population 85+ years old"

collapse (sum) HC01_EST_VC01 HC03_EST_VC01 HC05_EST_VC01 totunder5 mtotunder5 ftotunder5 tot5to9 mtot5to9 ftot5to9 tot10to14 mtot10to14 ftot10to14 ///
              tot15to19  mtot15to19 ftot15to19 tot20to24 mtot20to24 ftot20to24 tot25to29 mtot25to29 ftot25to29 ///
			  tot30to34  mtot30to34 ftot30to34 tot35to39 mtot35to39 ftot35to39 tot40to44 mtot40to44 ftot40to44 ///
			   tot45to49  mtot45to49 ftot45to49 tot50to54 mtot50to54 ftot50to54 tot55to59 mtot55to59 ftot55to59 ///
			   tot60to64 mtot60to64 ftot60to64 tot65to69 mtot65to69 ftot65to69 tot70to74 mtot70to74 ftot70to74 ///
			   tot75to79 mtot75to79 ftot75to79 tot80to84 mtot80to84 ftot80to84 tot85up mtot85up ftot85up, by (Year)
			   
			   
label variable HC01_EST_VC01 "Total population"
label variable HC03_EST_VC01 "Total male population"
label variable HC05_EST_VC01 "Total female population"
label variable totunder5 "Total population under 5 years old"
label variable mtotunder5 "Total Male population under 5 years old"
label variable ftotunder5 "Total Femal population under 5 years old"
label variable tot5to9 "Total population 5-9 years old"
label variable mtot5to9 "Total male population 5-9 years old"
label variable ftot5to9 "Total female population 5-9 years old"
label variable tot10to14 "Total population 10-14 years old"
label variable mtot10to14 "Total male population 10-14 years old"
label variable ftot10to14 "Total female population 10-14 years old"
label variable tot15to19 "Total population 15-19 years old"
label variable mtot15to19 "Total male population 15-19 years old"
label variable ftot15to19 "Total female population 15-19 years old"
label variable tot20to24 "Total population 20-24 years old"
label variable mtot20to24 "Total male population 20-24 years old"
label  variable ftot20to24 "Total female population 20-24 years old"
label variable tot25to29 "Total population 25-29 years old"
label variable mtot25to29 "Total male population 25-29 years old"
label variable ftot25to29 "Total female population 25-29 years old"
label variable tot30to34 "Total population 30-34 years old"
label variable mtot30to34 "Total male population 30-34 years old"
label  variable ftot30to34 "Total female population 30-34 years old"
label variable tot35to39 "Total population 35-39 years old"
label variable mtot35to39 "Total male population 35-39 years old"
label variable ftot35to39 "Total female population 35-39 years old"
label variable tot40to44 "Total population 40-44 years old"
label variable mtot40to44 "Total male population 40-44 years old"
label variable ftot40to44 "Total female population 40-44 years old"
label variable tot45to49 "Total population 45-49 years old"
label variable mtot45to49 "Total male population 45-49 years old"
label variable ftot45to49 "Total female population 45-49 years old"
label variable tot50to54 "Total population 50-54  years old"
label variable mtot50to54 "Total male population 50-54  years old"
label variable ftot50to54 "Total female population 50-54  years old"
label variable tot55to59 "Total population 55-59 years old"
label  variable mtot55to59 "Total male population 55-59 years old"
label variable ftot55to59 "Total female population 55-59 years old"
label  variable tot60to64 "Total population 60-64 years old"
label  variable mtot60to64 "Total male population 60-64 years old"
label  variable ftot60to64 "Total female population 60-64 years old"
label  variable tot65to69 "Total population 65-69 years old"
label  variable mtot65to69 "Total male population 65-69 years old"
label  variable ftot65to69 "Total female population 65-69 years old"
label  variable tot70to74 "Total population 70-74 years old"
label  variable mtot70to74 "Total male population 70-74 years old"
label  variable ftot70to74 "Total female population 70-74 years old"
label variable tot75to79 "Total population 75-79 years old"
label variable mtot75to79 "Total male population 75-79 years old"
label variable ftot75to79 "Total female population 75-79 years old"
label variable tot80to84 "Total population 80-84 years old"
label variable mtot80to84 "Total male population 80-84 years old"
label variable ftot80to84 "Total female population 80-84 years old"
label variable tot85up "Total population 85+ years old"
label variable mtot85up "Total male population 85+ years old"
label variable ftot85up "Total female population 85+ years old"	   

rename HC03_EST_VC01 HC02_EST_VC01
rename HC05_EST_VC01 HC03_EST_VC01

append using "D:\DCData\Libraries\RegHsg\Data\09-16 ACS 5year.dta", force

sort Year

rename HC01_EST_VC01 totpop
rename HC02_EST_VC01 totmalepop
rename HC03_EST_VC01 totfemalepop

xpose, clear varname format

order _varname v1-v9

save "D:\DCData\Libraries\RegHsg\Data\ACS_5year_gender.dta", replace

export excel using "D:\DCData\Libraries\RegHsg\Prog\ACS_5year_gender.xlsx", replace

clear
