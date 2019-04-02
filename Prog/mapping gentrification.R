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
COGregion_sf <- read_sf(dsn=shp,layer= basename(strsplit(shp, "\\.")[[1]])[1])

countyshp= "L:/Libraries/General/Maps/DMVCounties.shp"

county_sf <- read_sf(dsn= countyshp, layer= "DMVCounties")

COGcounty_sf <- county_sf %>% 
      filter(GEOID %in% c(11001, 24017, 24021, 24031, 24033, 51013, 
                          51059, 51107, 51153, 51510, 51600, 51610, 51683,51685))

plot(COGregion_sf)

watershp = "L:/Libraries/RegHsg/Maps/COG_water.shp"
water_sf <- read_sf(dsn= watershp, layer= basename(strsplit(watershp, "\\.")[[1]])[1])

plot(water_sf)

# load in typology dataset output from SAS program

Typology <- read.csv(paste0(jdir,"Neighborhood typology for mapping.csv")) 

Typology_df <- Typology  %>% 
         mutate(GEOID=as.character(geoid))


                #missing= ifelse(vulnerable=="", 1,0)) %>% 
         #filter(missing==0)
  

#spatial join
Typologymap <- left_join (Typology_df, COGregion_sf, by = c("GEOID"="GEOID")) 
  
Typologymap$neighborhoodtypeHH[Typologymap$neighborhoodtypeHH==""] <- "NA"
Typologymap$neighborhoodtypeFAM[Typologymap$neighborhoodtypeFAM==""] <- "NA"
Typologymap$neighborhoodtypeHH[Typologymap$neighborhoodtypeHHcode==""] <- "NA"
Typologymap$neighborhoodtypeFAM[Typologymap$neighborhoodtypeFAMcode==""] <- "NA"

#assign tracts to two large categories: at risk and already gentrified
Typologymap2 <- Typologymap %>% 
  mutate(twocat= case_when(neighborhoodtypeHHcode== 6| neighborhoodtypeHHcode== 7 ~ 1,
                           neighborhoodtypeHHcode== 2|neighborhoodtypeHHcode== 3|neighborhoodtypeHHcode== 4|neighborhoodtypeHHcode== 5 ~ 2,
                           TRUE ~ 3))  %>% 
  mutate(threecat= case_when(neighborhoodtypeHHcode== 6| neighborhoodtypeHHcode== 7 ~ 1,
                           neighborhoodtypeHHcode== 2|neighborhoodtypeHHcode== 3|neighborhoodtypeHHcode== 4|neighborhoodtypeHHcode== 5 ~ 2,
                           neighborhoodtypeHHcode== 1 ~ 3,
                           TRUE ~ 4))  

#You need to install these if the library after these don't exist'
#install.packages("colorspace")
#install.packages("devtools")
#devtools::install_github("UI-Research/urbnthemes")

library(colorspace)
library(ggplot2)
library(urbnthemes)

boundary <- ggplot()+
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#0a4c6a", size=0.5)+
  theme_urbn_map() +
  coord_sf(crs = 4269, datum = NA)


#Detailed Typology by HH income 
ggplot() +
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#98cf90", size=0.05)+
  geom_sf(Typologymap,  mapping = aes(),
          fill = NA, color = "white", size = .05) +
  geom_sf(Typologymap, mapping=aes(fill=factor(neighborhoodtypeHHcode)), color= "#dcdbdb", size = .05)+
  scale_fill_manual(values = c ("#cfe8f3", "#a2d4ec", "#73bfe2", "#46abdb", "#1696d2", "#12719e","#332d2f", "#9d9d9d" ),
                    labels= c("Low-mod value, no demographic chg","Low-mod value, adj. to high value/apprec., no demographic chg", "Low-mod value but accelerating mkt., no demographic chg", "Low-mod value, adj. to high value/apprec., demographic chg", "Low-mod value but accelerating mkt., demographic chg", "High value, appreciated mkt., demographic chg", "High value, appreciated mkt., demographic chg., smaller vulnerable pop", "Less than 50 owner-occupied units in at least 1 reference period","Not at risk: High value, smaller vulnerable pop" )) +
  theme_urbn_map() +
  labs(fill = "Tract Gentrification and Displacement Risk for Vulnerable Populations", color = NULL) +
  labs(title = "Neighborhood Gentrification Typology by HH") + 
  theme(legend.position ="bottom", legend.direction = "vertical", legend.text = element_text(size=8)) +
  coord_sf(crs = 4269, datum = NA)+
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#12719e", size=0.3, alpha=0.5)+
  coord_sf(crs = 4269, datum = NA)   


#Detailed Typology by FAM income
ggplot() +
  geom_sf(COGcounty_sf,  mapping = aes(),
          fill = NA, color = "#9d9d9d", size = .05) +
  geom_sf(Typologymap, mapping=aes(fill=factor(neighborhoodtypeFAMcode)), color= "#dcdbdb", size = .05)+
  scale_fill_manual(values = c ("#cfe8f3", "#a2d4ec", "#73bfe2", "#46abdb", "#1696d2", "#12719e","#332d2f", "#9d9d9d" ),
                    labels= c("Low-mod value, no demographic chg","Low-mod value, adj. to high value/apprec., no demographic chg", "Low-mod value but accelerating mkt., no demographic chg", "Low-mod value, adj. to high value/apprec., demographic chg", "Low-mod value but accelerating mkt., demographic chg", "High value, appreciated mkt., demographic chg", "High value, appreciated mkt., demographic chg., smaller vulnerable pop", "Less than 50 owner-occupied units in at least 1 reference period","Not at risk: High value, smaller vulnerable pop" )) +
  theme_urbn_map() +
  labs(fill = "Tract Gentrification and Displacement Risk for Vulnerable Populations", color = NULL) +
  labs(title = "Neighborhood Gentrification Typology by Family") + 
  theme(legend.position ="bottom", legend.box = "vertical", legend.text = element_text(size=8)) +
  coord_sf(crs = 4269, datum = NA)+
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#12719e", size=0.3, alpha=0.5)+
  coord_sf(crs = 4269, datum = NA)+
  ggsave("L:/Libraries/RegHsg/Maps/Detailed Typology by FAM_0402.pdf", device = cairo_pdf)


#Two category Typology by HH income 
ggplot() +
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#9d9d9d", size=0.05)+
  geom_sf(Typologymap2,  mapping = aes(),
          fill = NA, color = "white", size = .05) +
  geom_sf(Typologymap2, mapping=aes(fill=factor(twocat)), color= "#dcdbdb", size = .05)+
  scale_fill_manual(values = c ("#fdbf11", "#1696d2", "white"),
                    labels= c("At risk of dispalcement","Already gentrifying/gentrified", "Not at risk" )) +
  geom_sf(water_sf, mapping=aes(), fill="#dcdbdb", color="#dcdbdb", size=0.05)+
  theme_urbn_map() +
  labs(fill = "Tract Gentrification and Displacement Risk", color = NULL) +
  labs(title = "Neighborhood Gentrification Typology by HH") + 
  theme(legend.position ="bottom", legend.direction = "vertical", legend.text = element_text(size=8)) +
  coord_sf(crs = 4269, datum = NA)+
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#12719e", size=0.3, alpha=0.5)+
  coord_sf(crs = 4269, datum = NA)


#Three category typology  by HH income
ggplot() +
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#9d9d9d", size=0.05)+
  geom_sf(Typologymap2,  mapping = aes(),
          fill = NA, color = "white", size = .05) +
  geom_sf(Typologymap2, mapping=aes(fill=factor(threecat)), color= "#dcdbdb", size = .05)+
  scale_fill_manual(values = c ("#a2d4ec", "#1696d2", "#0a4c6a", "white"),
                    labels= c("At risk of dispalcement","Already gentrifying/gentrified", "Vulnerable", "Not at risk" )) +
  geom_sf(water_sf, mapping=aes(), fill="#dcdbdb", color="#dcdbdb", size=0.05)+
  theme_urbn_map() +
  labs(fill = "Tract Gentrification and Displacement Risk", color = NULL) +
  labs(title = "Neighborhood Gentrification Typology by HH") + 
  theme(legend.position ="bottom", legend.direction = "vertical", legend.text = element_text(size=8)) +
  coord_sf(crs = 4269, datum = NA)+
  geom_sf(COGcounty_sf, mapping=aes(), fill=NA, color="#12719e", size=0.3, alpha=0.5)+
  coord_sf(crs = 4269, datum = NA)
          

