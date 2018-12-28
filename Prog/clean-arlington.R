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

source("Macros/read-bk.R")
source("Macros/filter-bk.R")
source("Macros/select-vars.R")
source("Macros/sample-properties.R")
source("Macros/collapse-properties.R")

# read and filter ---------------------------------------------------------

region <- read_bk("dc-cog-assessment_20181228.csv")

arlington <- region %>% 
  filter_bk(fips = "51013") %>% 
  select_vars()

# recategorize county land use --------------------------------------------

# county land use description tabulation
arlington_county <- arlington %>% 
  group_by(countylandusedescription) %>% 
  count()

write_csv(arlington_county,
          "Data/arlington-county-land-use.csv")

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

arlington1 <- arlington %>% 
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
count(arlington1, residential)
count(arlington1, is.na(residential))
count(arlington1, category)
count(arlington1, is.na(category))
count(arlington1, category_detail)
count(arlington1, is.na(category_detail))


# collapse properties -----------------------------------------------------

# goal- one observation per property, based on street address
# functions for this section found in "Macros/collapse-properties.R"

# identify properties with more than one observation
singles <- get_single_properties(arlington1)
multiples <- get_multiple_properties(arlington1)
check_classification(arlington1)

count(multiples, is.na(prophouseno))

mult_grouped <- multiples %>% 
  # take out properties without address or street number
  filter(!is.na(propaddress),
         !is.na(prophouseno)) %>% 
  group_by(propaddress, zoning) %>% 
  count()

multiples
  


# filling values ----------------------------------------------------------

boom <- tibble(a = c("a", "a", "a", "b", "b", "b"), 
       b = c(1, NA, 1, NA, 2, 2))
  fill(boom, b)

boom %>%
  group_by(a) %>%
  fill(b) %>%
  fill(b, .direction = "up")
  
  
count(mult_grouped, nn)









# 
# arl_condo <- arlington %>% 
#   filter(standardizedlandusecode == "1004")
# 
# condo_test <- arl_condo %>% 
#   group_by(propadress) %>% 
#   mutate(buildingarea = as.numeric(buildingarea),
#          lotsizeorarea = as.numeric(lotsizeorarea)) %>% 
#   summarize(avgbuildingarea = mean(buildingarea),
#             sumbuildingarea = sum(buildingarea),
#             maxbuildingarea = max(buildingarea),
#             minbuildingarea = min(buildingarea),
#             avglotsize = mean(lotsizeorarea))
# 
# condo_test2 <- arl_condo %>% 
#   group_by(propadress) %>%
#   filter(n() == 1L)
# 
# 
# count(condo_test, numberofunits) %>% sort(desc(n))
