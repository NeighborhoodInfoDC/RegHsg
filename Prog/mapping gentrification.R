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


#### Load in precleaned Black Knight data for the region, select jurisdiction and standard variables
library(rgdal)
shp= "L:/Libraries/RegHsg/Maps/COG_region.shp"
datashp="L:/Libraries/RegHsg/Maps/Export_Output.shp"
COGregion <- readOGR(dsn=shp,layer= basename(strsplit(shp, "\\.")[[1]])[1])

plot(COGregion_proj)


# Convert to lat long
COGregion_proj = spTransform(COGregion, CRS("+proj=longlat +datum=WGS84"))


library(readcsv)

Typology <- read.csv(paste0(jdir,"Neighborhood typology for mapping.csv")) %>% 
   mutate(GEOID=geoid)

Typologymap <- left_join (Typology, COGregion_proj, by = ("GEOID"="GEOID"))


ggplot() +
  geom_sf(ctracts,  mapping = aes(),
          fill = NA, color = "#5c5859", size = .1) +
  geom_sf(acsgeotest, mapping = aes(fill = pctearningover75K)) +
  geom_point(dc_bikeshare, mapping = aes(long, lat, color = "Bikeshare station"),
             alpha = .5, color="#ec008b", size=1.1) +
  scale_color_manual(values = "black",
                     guide = guide_legend()) +
  scale_fill_gradientn(labels = scales::percent) +
  theme_urbn_map() +
  labs(fill = "Percent population with\n earning over 75K", color = NULL) +
  #labs(title = "Stations are clustered in higher income neighborhoods") + 
  theme(legend.box = "vertical") +
  coord_sf(crs = 4269, datum = NA)


