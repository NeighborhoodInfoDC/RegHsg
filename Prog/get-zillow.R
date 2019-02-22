
library(tidyverse)
library(lubridate)

# county indicators -------------------------------------------------------


inventory <- read_csv('http://files.zillowstatic.com/research/public/County/InventoryMeasure_SSA_County_Public.csv')


#county %in% c('District of Columbia','Charles','Frederick','Montgomery','Prince Georges','Arlington', 'Fairfax', 'Fairfax City', 'Loudoun','Prince William', 'Alexandria City', 'Falls Church City', 'Manassas City', 'Manassas Park City')

inventoryCOG <- inventory %>% 
  select(-RegionName, -Metro, -DataTypeDescription) %>% 
  rename(type = RegionType, name = CountyName, state = StateFullName) %>% 
  gather(key = 'monthx', value = 'inventory', -type, -state, -name) %>% 
  filter(state %in% c('District of Columbia', 'Maryland', 'Virginia'),
         name %in% c('District of Columbia','Charles','Frederick','Montgomery','Prince Georges','Arlington', 'Fairfax', 'Fairfax City', 'Loudoun','Prince William', 'Alexandria City', 'Falls Church City', 'Manassas City', 'Manassas Park City')
         ) %>%
  arrange(name, monthx) %>% 
  mutate(monthx = as_date(paste0(monthx, '-01')),
         invyoy = lag(inventory, 12) / inventory - 1)



inventorydc %>% 
  ggplot(aes(monthx, rollinv, color = name)) +
  geom_line() +
  scale_y_continuous(expand = c(0,0),
                     limits = c(-1, 1.5),
                     labels = scales::percent) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y",
               limits = as_date(c('2012-01-01', '2018-01-03'))) +
  scale_color_discrete(guide = FALSE) +
  labs(x = NULL, y = 'Change in inventory, year over year') +
  theme_urban_web()
ggsave("graphs/changeinventory_county.png",
       width = 10, height = 6)


pricecut <- read_csv('http://files.zillowstatic.com/research/public/County/County_Listings_PriceCut_SeasAdj_AllHomes.csv')

pricecutdc <- pricecut %>% 
  select(-RegionID, -SizeRank) %>% 
  rename(name = RegionName, state = State) %>% 
  mutate(type = 'county') %>% 
  gather(key = 'monthx', value = 'pcshare', -type, -state, -name) %>% 
  filter(name %in% mt$name,
         state %in% c('DC', 'MD', 'VA')) %>%
  mutate(monthx = as_date(paste0(monthx, '-01')),
         pcrollavg = rollavg(pcshare)) %>% 
  arrange(name, monthx) 

pricecutdc %>% 
  filter(type == "county") %>% 
  ggplot(aes(monthx, pcrollavg, color = name)) +
  geom_line() +
  scale_y_continuous(limits = c(0, 17),
                     expand = c(0,0)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_color_discrete(guide = FALSE) +
  labs(x = NULL, y = 'Share of listing with a price cut') +
  theme_urban_web()
ggsave("graphs/pricecut_county.png",
       width = 10, height = 6)


# metro indicators --------------------------------------------------------

ageinv <- read_csv('http://files.zillowstatic.com/research/public/Metro/AgeOfInventory_Metro_Public.csv')

ageinv_metro <- ageinv %>% 
  select(-RegionType, -StateFullName, -DataTypeDescription) %>% 
  gather(key = "monthx", value = "ageinv", -RegionName) %>% 
  filter(RegionName %in% c("United States", "Seattle, WA", "Washington, DC")) %>% 
  arrange(RegionName, monthx) %>% 
  mutate(monthx = as_date(paste0(monthx, '-01')),
         rollage = rollavg(ageinv))
         
ageinv_metro %>% 
  filter(monthx >= as_date("2013-01-01")) %>% 
  ggplot(aes(monthx, rollage, color = RegionName)) +
  geom_line() +
  scale_y_continuous(expand = c(0,0), limits = c(0,100)) +
  theme_urban_web() +
  labs(x = NULL, y = "Age of inventory, 12-month rolling average")
ggsave("graphs/age_inventory_metro.png", width = 10, height = 7)


# rent trends -------------------------------------------------------------

rent <- read_csv('http://files.zillowstatic.com/research/public/County/County_Zri_AllHomesPlusMultifamily.csv')

region_codes <- c("11001", "24031", "24033", 
                  "51013", "51059", "51600",
                  "51510", "51107")

rentdc <- rent %>% 
  rename(name = RegionName) %>% 
  mutate(county_fips = paste0(StateCodeFIPS, MunicipalCodeFIPS)) %>% 
  select(-RegionID, -Metro, -SizeRank, -StateCodeFIPS, - MunicipalCodeFIPS) %>% 
  filter(county_fips %in% region_codes) %>% 
  gather(key = 'datex', value = 'zri', -name, -county_fips, -State) %>% 
  arrange(name, datex) %>% 
  mutate(datex = as_date(paste0(datex, '-01')))
  
rentwide <- rent %>%
  mutate(county_fips = paste0(StateCodeFIPS, MunicipalCodeFIPS)) %>% 
  filter(county_fips %in% region_codes) %>% 
  select(-RegionID, -Metro, -SizeRank, -StateCodeFIPS, - MunicipalCodeFIPS)
  
oldnames <- names(select(rentwide, -county_fips, -RegionName, -State))
newnames <- paste0("zri", oldnames)

rentwide <- rentwide %>%  
  rename_at(vars(oldnames), ~newnames)

rentdc %>% 
  ggplot(aes(datex, zri, color = name)) +
  geom_line() +
  scale_y_continuous(expand = expand_scale(mult = c(0, .2)),
                     limits = c(0,3000))

countyrentovertime <- rentdc %>% 
  select(-State, - county_fips, - rollrent) %>% 
  spread(key = name, value = zri)

rent_region <- read_csv('http://files.zillowstatic.com/research/public/Metro/Metro_Zri_SingleFamilyResidenceRental.csv')

rentdcnational <- rent_region %>% 
  filter(RegionName %in% c('Washington, DC', 'United States')) %>% 
  select(-RegionID, -SizeRank, name = RegionName) %>% 
  gather(key = 'datex', value = 'zri', -name) %>% 
  arrange(name, datex) %>% 
  mutate(datex = as_date(paste0(datex, '-01')))

rentdcnational %>% 
  ggplot(aes(datex, zri, color = name)) +
  geom_line() +
  theme_urban_web()

rentovertime <- rent_region %>% 
  filter(RegionName %in% c('Washington, DC', 'United States')) %>% 
  select(-RegionID, -SizeRank, name = RegionName) %>% 
  gather(key = 'datex', value = 'zri', -name) %>% 
  arrange(name, datex) %>% 
  mutate(datex = as_date(paste0(datex, '-01'))) %>% 
  spread(key = name, value = zri)


rentMF <- read_csv("http://files.zillowstatic.com/research/public/County/County_Zri_AllHomesPlusMultifamily.csv")

region_codes <- c("11001", "24031", "24033", 
                  "51013", "51059", "51600",
                  "51510", "51107")

rentdcmf <- rentMF %>% 
  rename(name = RegionName) %>% 
  mutate(county_fips = paste0(StateCodeFIPS, MunicipalCodeFIPS)) %>% 
  select(-RegionID, -Metro, -SizeRank, -StateCodeFIPS, - MunicipalCodeFIPS) %>% 
  filter(county_fips %in% region_codes) %>% 
  gather(key = 'datex', value = 'zri', -name, -county_fips, -State) %>% 
  arrange(name, datex) %>% 
  mutate(datex = as_date(paste0(datex, '-01')),
         rollrent = rollavg(zri))

countyrentovertime <- rentdcmf %>% 
  select(-State, -county_fips, -rollrent) %>% 
  spread(key = name, value = zri)

countyyoy <-  rentdcmf %>% 
  mutate(yoyrent = chyoy(zri)) %>% 
  select(-State, -county_fips, -rollrent, -zri) %>% 
  spread(key = name, value = yoyrent)

rentdcmf %>% 
  mutate(yoyrent = chyoy(zri)) %>% 
  ggplot(aes(datex, zri, color = name)) +
  geom_line() +
  theme_urban_web()
