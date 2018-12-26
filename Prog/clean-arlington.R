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

# read and filter ---------------------------------------------------------

region <- read_bk("dc-cog-assessment-20181226.csv")

arlington <- region %>% 
  filter_bk(fips = "51013") %>% 
  select_vars()


# recategorize county land use --------------------------------------------

arlington_county <- arlington %>% 
  group_by(countylandusedescription) %>% 
  count()

write_csv(arlington_county,
          "Data/arlington-county-land-use.csv")

# collapse condos ---------------------------------------------------------

arl_condo <- arlington %>% 
  filter(standardizedlandusecode == "1004")

condo_test <- arl_condo %>% 
  group_by(propadress) %>% 
  mutate(buildingarea = as.numeric(buildingarea),
         lotsizeorarea = as.numeric(lotsizeorarea)) %>% 
  summarize(avgbuildingarea = mean(buildingarea),
            sumbuildingarea = sum(buildingarea),
            maxbuildingarea = max(buildingarea),
            minbuildingarea = min(buildingarea),
            avglotsize = mean(lotsizeorarea))

condo_test2 <- arl_condo %>% 
  group_by(propadress) %>%
  filter(n() == 1L)


count(condo_test, numberofunits) %>% sort(desc(n))
