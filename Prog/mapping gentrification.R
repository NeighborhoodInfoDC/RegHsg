## Set-up
#### Load libraries and functions

library(tidyverse)
library(DescTools)
library(purrr)


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

countyshp= "L:/Libraries/General/Maps/DMVCounties.shp"

county_sf <- read_sf(dsn= countyshp, layer= "DMVCounties")

COGcounty_sf <- county_sf %>% 
      filter(GEOID %in% c(11001, 24017, 24021, 24031, 24033, 51013, 
                          51059, 51107, 51153, 51510, 51600, 51610, 51683,51685))

plot(COGregion_sf)

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

boundary <- ggplot()+
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#98cf90", size=0.5)+
  theme_urbn_map() +
  coord_sf(crs = 4269, datum = NA)


#Typology by HH income 
ggplot() +
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#98cf90", size=0.05)+
  geom_sf(Typologymap,  mapping = aes(),
          fill = NA, color = "white", size = .05) +
  geom_sf(Typologymap, mapping=aes(fill=factor(neighborhoodtypeHHcode)), color= "#dcdbdb", size = .05)+
  scale_fill_manual(values = c ("#a2d4ec", "#fce39e", "#fccb41", "#eb99c2", "#e9807d", "#db2b27","#d2d2d2" ),
                    labels= c("Susceptible", "Early type 1", "early type 2", "Dynamic", "Late", "Continued Loss", "Low-moderate value: not at risk","Other not at risk")) +
  theme_urbn_map() +
  labs(fill = "Type", color = NULL) +
  labs(title = "Neighborhood Gentrification Typology by HH") + 
  theme(legend.box = "vertical") +
  coord_sf(crs = 4269, datum = NA)+
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#12719e", size=0.5, alpha=0.5)+
  theme_urbn_map() +
  coord_sf(crs = 4269, datum = NA)


#Typology by FAM income
ggplot() +
  geom_sf(COGcounty_sf,  mapping = aes(),
          fill = NA, color = "#9d9d9d", size = .05) +
  geom_sf(Typologymap, mapping=aes(fill=factor(neighborhoodtypeFAMcode)), color= "#dcdbdb", size = .05)+
  scale_fill_manual(values = c ("#a2d4ec", "#fce39e", "#fccb41", "#eb99c2", "#e9807d", "#db2b27","#d2d2d2" ),
                    labels= c("Susceptible", "Early type 1", "early type 2", "Dynamic", "Late", "Continued Loss", "Low-moderate value: not at risk","Other not at risk")) +
  theme_urbn_map() +
  labs(fill = "Type", color = NULL) +
  labs(title = "Neighborhood Gentrification Typology by Family") + 
  theme(legend.box = "vertical") +
  coord_sf(crs = 4269, datum = NA)+
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#12719e", size=0.5, alpha=0.8)+
  theme_urbn_map() +
  coord_sf(crs = 4269, datum = NA)
