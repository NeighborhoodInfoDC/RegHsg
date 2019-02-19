## Set-up
#### Load libraries and functions

library(tidyverse)
library(DescTools)
library(purrr)

source("../Macros/read-bk.R")
source("../Macros/filter-bk.R")
source("../Macros/select-vars.R")
source("../Macros/sample-properties.R")
source("../Macros/classify-addresses.R")

#### Create directory for data exports on local computer

if (!dir.exists("../Data")) {
  dir.create("../Data")
}

library(dplyr)
#### Set FIPS code and filepath name

currentfips <- "11001"
filepath <- "DC"
jdir <- paste0("L:/Libraries/RegHsg/Data/", filepath, "/")


#### Load in CG region shapefile
library(rgdal)

library(sf)
shp= "L:/Libraries/RegHsg/Maps/COG_region.shp"
datashp="L:/Libraries/RegHsg/Maps/Export_Output.shp"
COGregion_sf <- read_sf(dsn=shp,layer= basename(strsplit(shp, "\\.")[[1]])[1])

plot(COGregion)

# load in typology dataset output from SAS program
library(readcsv)
Typology <- read.csv(paste0(jdir,"Neighborhood typology for mapping.csv")) 

Typology_df <- Typology  %>% 
         mutate(GEOID=as.character(geoid),
                missing= ifelse(vulnerable=="", 1,0)) %>% 
         filter(missing==0)
  

#spatial join
Typologymap <- left_join (Typology_df, COGregion_sf, by = c("GEOID"="GEOID")) 
  
Typologymap$neighborhoodtypeHH[Typologymap$neighborhoodtypeHH==""] <- "NA"

Typologymap$neighborhoodtypeFAM[Typologymap$neighborhoodtypeFAM==""] <- "NA"

install.packages("colorspace")
library(colorspace)
library(ggplot2)
install.packages("devtools")
devtools::install_github("UI-Research/urbnthemes")
library(urbnthemes)

#Typology by HH income 
ggplot() +
  geom_sf(Typologymap,  mapping = aes(),
          fill = NA, color = "white", size = .05) +
  geom_sf(Typologymap, mapping=aes(fill=factor(neighborhoodtypeHH)), size = .05)+
  scale_fill_manual(values = c ("#46ABDB", "#0A4C6A", "#e88e2d", "#e54096" )) +
  theme_urbn_map() +
  labs(fill = "Type", color = NULL) +
  labs(title = "Neighborhood Gentrification Typology by HH") + 
  theme(legend.box = "vertical") +
  coord_sf(crs = 4269, datum = NA)

#Typology by FAM income
ggplot() +
  geom_sf(Typologymap,  mapping = aes(),
          fill = NA, color = "#9d9d9d", size = .05) +
  geom_sf(Typologymap, mapping=aes(fill=factor(neighborhoodtypeFAM)), size = .05)+
  scale_fill_manual(values = c ("#46ABDB", "#0A4C6A", "#e88e2d", "#e54096" )) +
  theme_urbn_map() +
  labs(fill = "Type", color = NULL) +
  labs(title = "Neighborhood Gentrification Typology by Family") + 
  theme(legend.box = "vertical") +
  coord_sf(crs = 4269, datum = NA)
