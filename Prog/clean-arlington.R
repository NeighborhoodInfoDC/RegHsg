# /****************************************************************************
# Program:  clean-arlington.R
# Library:  RegHsg
# Project:  Regional Housing Framework
# Author:   Sarah Strochak 
# Created:  12/26/2018
# Version:  R 3.5.1, RStudio 1.1.423
# Environment:  Local Windows session (desktop)
# 
# Description:  Clean and reorganize property records data for
# Arlington County (51013)
# 
# Modifications:
# ****************************************************************************/


# load libraries and functions --------------------------------------------

library(tidyverse)
library(DescTools)
library(purrr)

source("Macros/read-bk.R")
source("Macros/filter-bk.R")
source("Macros/select-vars.R")
source("Macros/sample-properties.R")
source("Macros/collapse-properties.R")


# set fips and filepath ---------------------------------------------------

currentfips <- "51013"
filepath <- "arlington"

# read and filter ---------------------------------------------------------

region <- read_bk("dc-cog-assessment_20181228.csv")

currentjur <- region %>% 
  filter_bk(fips = "51013") %>% 
  select_vars()

# recategorize county land use --------------------------------------------

# county land use description tabulation
currentjur_county <- currentjur %>% 
  group_by(countylandusedescription) %>% 
  count()

# check if this file has already been written- this will avoid writing over
# land use codes that have already been categorized

if (!file.exists(paste0("Data/", filepath, "-county-land-use.csv"))) {
  write_csv(currentjur_county,
            paste0("Data/", filepath, "-county-land-use.csv"))
} else {
  stop("land use file already exists")
}

# create three variables:
# 1. residential indicator
# 2. category
# 3. category_detail

# recode variables
res_codes <- 
  c("AFFORDABLE DWELLING UNIT",
    "APARTMENT - GARDEN",
    "APARTMENT - HIGH-RISE",
    "APARTMENT - MID-RISE",
    "APARTMENT - PARKING",
    "COMMUNITY BENEFIT UNIT",
    "MULTI-FAM IMPR/NO SITE PLAN",
    "MULTI-FAM IMPR/SITE PLAN",
    "MULTI-FAM VACANT/NO SITE PLAN",
    "MULTI-FAM VACANT/SITE PLAN",
    "NOT VALUED CONDO HOA",
    "NOT VALUED COSTED - HOA/SITE PLAN",
    "RESIDENTIAL COST-VAL - DUPLEX",
    "RESIDENTIAL COST-VAL - IMPR/SF & TW",
    "RESIDENTIAL COST-VAL - SIDE BY SIDE",
    "RESIDENTIAL COST-VAL - SINGLE-FAM DET",
    "RESIDENTIAL COST-VAL - TOWNHOUSE/CO",
    "RESIDENTIAL COST-VAL - TOWNHOUSE/FSO",
    "RESIDENTIAL COST-VAL - VAC/SF & TW",
    "SALES APPR CONDO/CO-OP",
    "SALES APPR CONDO/GARDEN",
    "SALES APPR CONDO/HIGH RISE",
    "SALES APPR CONDO/MID RISE",
    "SALES APPR CONDO/STACKED",
    "SFD - APT ZONED/NO SITE PLAN",
    "SFD - APT ZONED/SITE PLAN",
    "VACANT RESIDENTIAL")

currentjur_cat <- currentjur %>% 
  mutate(residential =
           ifelse(countylandusedescription %in% res_codes, 1, 0),
         category = case_when(
           countylandusedescription %in%
             c("COMMERCIAL CONDO",
               "GEN COMM-IND - AUTO DEALERSHIP",
               "GEN COMM-IND - SELF-STORAGE",
               "GEN COMM-IND - SERVICE STATION",
               "GEN COMM-IND - WAREHOUSE",
               "GEN COMM - BANK",
               "GEN COMM - FAST FOOD",
               "GEN COMM - HEALTH CARE FACILITY",
               "GEN COMM - MIXED OFFICE/COMM",
               "GEN COMM - NEIGHBORHOOD CTR",
               "GEN COMM - OTHER",
               "GEN COMM - REST/EATING FACILITY",
               "GEN COMM - RETAIL/STRIP",
               "GEN COMM - SMALL OFFICE",
               "GEN COMM IMPR-LAND/NO SITE PLAN",
               "GEN COMM IMPR-LAND/SITE PLAN",
               "GEN COMM/PARKING",
               "HOTEL - FULL SERVICE",
               "HOTEL - LAND/OTHER",
               "HOTEL - LIMITED SERVICE",
               "HOTEL - LODGING",
               "HOTEL - SELECT DRIVE",
               "HOTEL RESIDENCE SUITES",
               "MIXED USE",
               "SFD - COMM ZONED/NO SITE PLAN",
               "SFD - COMM ZONED/SITE PLAN") ~ "commercial",
           countylandusedescription %in%
             c("AFFORDABLE DWELLING UNIT",
               "APARTMENT - GARDEN",
               "APARTMENT - HIGH-RISE",
               "APARTMENT - MID-RISE",
               "APARTMENT - PARKING",
               "COMMUNITY BENEFIT UNIT",
               "MULTI-FAM IMPR/NO SITE PLAN",
               "MULTI-FAM IMPR/SITE PLAN",
               "NOT VALUED CONDO HOA",
               "RESIDENTIAL COST-VAL - DUPLEX",
               "SALES APPR CONDO/CO-OP",
               "SALES APPR CONDO/GARDEN",
               "SALES APPR CONDO/HIGH RISE",
               "SALES APPR CONDO/MID RISE",
               "SALES APPR CONDO/STACKED",
               "SFD - APT ZONED/NO SITE PLAN",
               "SFD - APT ZONED/SITE PLAN") ~ "mf",
           countylandusedescription %in%
             c("OFFICE BLDG IMPR-LAND/SITE PLAN",
               "OFFICE BLDG/7 OR MORE STORIES",
               "OFFICE BLDG/PARKING",
               "OFFICE BLDG/UNDER 7 STORIES") ~ "office",
           countylandusedescription %in%
             c("NOT VALUED COSTED - HOA/SITE PLAN",
               "RESIDENTIAL COST-VAL - IMPR/SF & TW",
               "RESIDENTIAL COST-VAL - SIDE BY SIDE",
               "RESIDENTIAL COST-VAL - SINGLE-FAM DET",
               "RESIDENTIAL COST-VAL - TOWNHOUSE/CO",
               "RESIDENTIAL COST-VAL - TOWNHOUSE/FSO") ~ "sf",
           countylandusedescription %in% 
             c("MULTI-FAM VACANT/NO SITE PLAN",
               "MULTI-FAM VACANT/SITE PLAN",
               "RESIDENTIAL COST-VAL - VAC/SF & TW",
               "VACANT RESIDENTIAL",
               "GEN COMM VAC-LAND/NO SITE PLAN",
               "GEN COMM VAC-LAND/SITE PLAN",
               "OFFICE BLDG VAC-LAND/NO SITE PLAN",
               "OFFICE BLDG VAC-LAND/SITE PLAN",
               "VACANT COMMERCIAL",
               "VACANT EXEMPT",
               "VACANT LIGHT INDUSTRIAL",
               "VACANT OFFICE") ~ "vacant"),
         category_detail = case_when(
           countylandusedescription %in%
             c("AFFORDABLE DWELLING UNIT",
               "APARTMENT - GARDEN",
               "APARTMENT - HIGH-RISE",
               "APARTMENT - MID-RISE",
               "APARTMENT - PARKING",
               "COMMUNITY BENEFIT UNIT",
               "MULTI-FAM IMPR/NO SITE PLAN",
               "MULTI-FAM IMPR/SITE PLAN",
               "SFD - APT ZONED/NO SITE PLAN",
               "SFD - APT ZONED/SITE PLAN") ~ "apartment",
           countylandusedescription %in% 
             c("COMMERCIAL CONDO",
               "GEN COMM-IND - AUTO DEALERSHIP",
               "GEN COMM-IND - SELF-STORAGE",
               "GEN COMM-IND - SERVICE STATION",
               "GEN COMM-IND - WAREHOUSE",
               "GEN COMM - BANK",
               "GEN COMM - FAST FOOD",
               "GEN COMM - HEALTH CARE FACILITY",
               "GEN COMM - MIXED OFFICE/COMM",
               "GEN COMM - NEIGHBORHOOD CTR",
               "GEN COMM - OTHER",
               "GEN COMM - REST/EATING FACILITY",
               "GEN COMM - RETAIL/STRIP",
               "GEN COMM - SMALL OFFICE",
               "GEN COMM IMPR-LAND/NO SITE PLAN",
               "GEN COMM IMPR-LAND/SITE PLAN",
               "GEN COMM/PARKING",
               "HOTEL - FULL SERVICE",
               "HOTEL - LAND/OTHER",
               "HOTEL - LIMITED SERVICE",
               "HOTEL - LODGING",
               "HOTEL - SELECT DRIVE",
               "HOTEL RESIDENCE SUITES",
               "MIXED USE",
               "SFD - COMM ZONED/NO SITE PLAN",
               "SFD - COMM ZONED/SITE PLAN") ~ "commercial",
           countylandusedescription %in% 
             c("NOT VALUED CONDO HOA",
               "SALES APPR CONDO/CO-OP",
               "SALES APPR CONDO/GARDEN",
               "SALES APPR CONDO/HIGH RISE",
               "SALES APPR CONDO/MID RISE",
               "SALES APPR CONDO/STACKED") ~ "condo",
           countylandusedescription %in% 
             c("RESIDENTIAL COST-VAL - DUPLEX") ~ "duplex",
           countylandusedescription %in%
             c("OFFICE BLDG IMPR-LAND/SITE PLAN",
               "OFFICE BLDG/7 OR MORE STORIES",
               "OFFICE BLDG/PARKING",
               "OFFICE BLDG/UNDER 7 STORIES") ~ "office",
           countylandusedescription %in%
             c("RESIDENTIAL COST-VAL - SIDE BY SIDE") ~ "sf attached",
           countylandusedescription %in% 
             c("NOT VALUED COSTED - HOA/SITE PLAN",
               "RESIDENTIAL COST-VAL - IMPR/SF & TW",
               "RESIDENTIAL COST-VAL - SINGLE-FAM DET") ~ "sf detached",
           countylandusedescription %in% 
             c("RESIDENTIAL COST-VAL - TOWNHOUSE/CO",
               "RESIDENTIAL COST-VAL - TOWNHOUSE/FSO") ~ "townhouse",
           countylandusedescription %in% 
             c("GEN COMM VAC-LAND/NO SITE PLAN",
               "GEN COMM VAC-LAND/SITE PLAN",
               "VACANT COMMERCIAL") ~ "vacant commercial",
           countylandusedescription %in% 
             c("VACANT EXEMPT") ~ "Vacant exempt",
           countylandusedescription %in% 
             c("VACANT LIGHT INDUSTRIAL") ~ "vacant light industrial",
           countylandusedescription %in%
             c("MULTI-FAM VACANT/NO SITE PLAN",
               "MULTI-FAM VACANT/SITE PLAN") ~ "vacant mf",
           countylandusedescription %in%
             c("OFFICE BLDG VAC-LAND/NO SITE PLAN",
               "OFFICE BLDG VAC-LAND/SITE PLAN",
               "VACANT OFFICE") ~ "vacant office",
           countylandusedescription %in%
             c("VACANT RESIDENTIAL") ~ "vacant residential",
           countylandusedescription %in%
             c("RESIDENTIAL COST-VAL - VAC/SF & TW") ~ "vacant sf")
         )

# check for missing values
count(currentjur_cat, residential)
count(currentjur_cat, is.na(residential))
count(currentjur_cat, category)
count(currentjur_cat, is.na(category))
count(currentjur_cat, category_detail)
count(currentjur_cat, is.na(category_detail))


# collapse properties -----------------------------------------------------

# goal- one observation per property, based on street address
# functions for this section found in "Macros/collapse-properties.R"

# identify properties with letters in address- remove for collapse
currentjur_cat2 <- currentjur_cat %>% 
  mutate(house_letter = ifelse(str_detect(prophouseno, "[:alpha:]") == 1, 1, 0),
         oldadd = propaddress,
         new_houseno = ifelse(house_letter == 1,
                              str_replace(prophouseno, "[:alpha:]", ""), prophouseno),
         propaddress = ifelse(house_letter == 1, 
                              paste(str_replace_all(new_houseno, "-", ""),
                                    propstreetname, 
                                    propstreetsuffix,
                                    sep = " "),
                              propaddress),
         propaddress = ifelse(is.na(propaddress), oldadd, propaddress))

currentjur_cat2 %>% filter(house_letter == 1) %>% select(oldadd, propaddress) %>% head(20)

# test to make sure we did not introduce any NAs
if (sum(is.na(currentjur_cat2$propaddress)) > 
    sum(is.na(currentjur_cat$propaddress))) {
  warning("additional NAs are introduced") 
  } else if (sum(is.na(currentjur_cat2$propaddress)) < 
             sum(is.na(currentjur_cat$propaddress))) {
  warning("less NAs than original")
    } else if (sum(is.na(currentjur_cat2$propaddress)) == 
               sum(is.na(currentjur_cat$propaddress))) {
      print("no additional NAs")
    }

    
# identify properties with more than one observation, those with missing
# addresses or house numbers
singles <- get_single_properties(currentjur_cat2)
multiples <- get_multiple_properties(currentjur_cat2)
missing_address <- get_missing_address(currentjur_cat2)
check_classification(currentjur_cat2)

# first- fill in missing zoning
multiples <- multiples %>% 
  group_by(propaddress) %>% 
  fill(zoning) %>% 
  fill(zoning, .direction = "up") %>% 
  ungroup()

# check
mult_grouped <- multiples %>% 
  group_by(propaddress) %>% 
  count()


# take most common zoning variable, categorization
# sum building areas and 
nested <- multiples %>% 
  group_by(propaddress) %>%
  summarise_at(vars(zoning, lotsizeorarea, lotsizesquarefeet,
                    buildingarea, countylandusedescription,
                    residential, category, category_detail,
                    yearbuilt, long, lat), list) %>% 
  rename_at(vars(-propaddress), ~ paste0(., "_list")) %>% 
  mutate(nprops = map(zoning_list, length),
         zoning = map(zoning_list, Mode),
         lotsizeorarea = map(lotsizeorarea_list, sum),
         lotsizesquarefeet = map(lotsizesquarefeet_list, sum),
         buildingarea = map(buildingarea_list, sum),
         countylandusedescription = map(countylandusedescription_list, Mode),
         residential = map(residential_list, max),
         category = map(category_list, Mode),
         category_detail = map(category_detail_list, Mode),
         yearbuilt = map(yearbuilt_list, max),
         long = map(long_list, median),
         lat = map(lat_list, median))

# figure out if every lot size is the same (should be averaged and not summed)
nested <- nested %>% 
  mutate(unqlotsize = map(lotsizesquarefeet_list, 
                            function(x) length(unique(x))),
         lotsizesquarefeet = ifelse(lotsizesquarefeet == 0,
                                    NA, 0)) 


finalvar <- newvars %>% 
  mutate(lotsize_final = case_when(
    unqlotsize == 1 ~ lot_mode,
    lot_alwayssum == 1 ~ lot_sum,
    lot_sum == 0 ~ NA
  ))



ties <- nested %>% 
  mutate(ties_z = ifelse(map(zoning, length) > 1, 1, 0)) %>% 
  filter(ties_z == 1) %>% 
  mutate(z1 = map(zoning, function(x) x[1]),
         z2 = map(zoning, function(x) x[2]),
         z3 = map(zoning, function(x) x[3]),
         cl1 = map(countylandusedescription, function(x) x[1]),
         cl2 = map(countylandusedescription, function(x) x[2]),
         cl3 = map(countylandusedescription, function(x) x[3])) %>% 
  select(propaddress, nprops,
         z1, z2, z3,
         cl1, cl2, cl3) %>% 
  unnest()

if (!file.exists(paste0("Data/", filepath, "-zoning-ties.csv"))) { 
    write_csv(ties,
          paste0("Data/", filepath, "-zoning-ties.csv"))
  } else {
  stop("ties file already exists")
}


# test if there are condos that need to be re-labeled
singles %>% count(category_detail)
singles <- singles %>% 
  mutate(category = ifelse(category_detail == "condo",
                           "sf",
                           category),
         category_detail = ifelse(category_detail == "condo",
                                  "sf attached",
                                  category_detail))

dup <- singles %>% filter(category_detail == "duplex")

multiples %>% count(category_detail)
msf <- multiples %>% filter(category_detail == "sf detached")
a <- multiples %>% filter(propaddress == "1006 N QUINTANA ST")

check <- multiples %>% group_by(propaddress) %>% count()

sapt <- singles %>% 
  group_by(category_detail) %>% 
  summarize(maxlot = max(lotsizesquarefeet),
            avglot = mean(lotsizesquarefeet))

sapt1 <- singles %>% 
  filter(category_detail == "apartment") %>% 
  select(propaddress, numberofunits, 
         lotsizeorarea, lotsizesquarefeet)


# filling values ----------------------------------------------------------

boom <- tibble(a = c("a", "a", "a", "b", "b", "b"), 
       b = c(1, NA, 1, NA, 2, 2))
  fill(boom, b)

boom %>%
  group_by(a) %>%
  fill(b) %>%
  fill(b, .direction = "up")
  
  
count(mult_grouped, nn)




