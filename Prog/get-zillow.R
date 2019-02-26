
library(tidyverse)
library(lubridate)

# Inventory -------------------------------------------------------


inventory <- read_csv('http://files.zillowstatic.com/research/public/County/MonthlyListings_SSA_AllHomes_County.csv')
inventoryMSA <- read_csv('http://files.zillowstatic.com/research/public/Metro/MonthlyListings_SSA_AllHomes_Metro.csv')

#county %in% c('District of Columbia','Charles','Frederick','Montgomery','Prince Georges','Arlington', 'Fairfax', 'Fairfax City', 'Loudoun','Prince William', 'Alexandria City', 'Falls Church City', 'Manassas City', 'Manassas Park City')

inventoryCOGmonth <- inventory %>% 
  select(-RegionType, -SizeRank, -RegionID) %>% 
  rename(county = RegionName, state = StateName) %>% 
  gather(key = 'monthx', value = 'inventoryCOG', -state, -county) %>% 
  filter(state %in% c('DC', 'MD', 'VA'),
         county %in% c('District of Columbia','Charles County','Frederick County','Montgomery County','Prince Georges County','Arlington County', 'Fairfax County', 'Fairfax City', 'Loudoun County','Prince William County', 'Alexandria City', 'Falls Church City', 'Manassas City', 'Manassas Park City')
         ) %>%
  arrange(county, monthx) %>% 
  mutate(month = substr(monthx, 6, 7),
         year= substr(monthx, 1,4))

inventoryMSAJuly <- inventoryMSA %>% 
  select(-RegionType, -SizeRank, -RegionID, -StateName) %>% 
  rename(Metro = RegionName) %>% 
  gather(key = 'monthx', value = 'inventoryMetro', -Metro) %>% 
  filter(Metro=="Washington, DC") %>% 
  arrange(Metro, monthx) %>% 
  mutate(month = substr(monthx, 6, 7),
         year= substr(monthx, 1,4)) %>% 
  filter(month=="07") %>% 
  select(-monthx, -Metro, -month)

#### inventory for COG region
inventoryCOGJuly <- inventoryCOGmonth %>% 
    filter(month=="07") %>% 
    group_by(year) %>% 
    summarize(JulyInventory= sum(inventory))


# Sale prices --------------------------------------------------------

price <- read_csv('http://files.zillowstatic.com/research/public/Metro/Sale_Prices_Msa.csv')

priceMSAJuly <- price %>% 
  select(-RegionID, -SizeRank) %>% 
  rename(name = RegionName) %>% 
  gather(key = 'monthx', value = 'Mediansaleprice', -name) %>% 
  filter(name =="Washington, DC") %>%
  mutate(month = substr(monthx, 6, 7), 
         year= substr(monthx, 1,4)) %>% 
  filter(month=="07") %>% 
  select(-name, -monthx, -month)%>% 
  arrange(year, Mediansaleprice, -month)

# Rent for SF and MF residents --------------------------------------------------------

rentSF <- read_csv('http://files.zillowstatic.com/research/public/Metro/Metro_MedianRentalPrice_Sfr.csv')
rentlargeMF <- read_csv('http://files.zillowstatic.com/research/public/Metro/Metro_MedianRentalPrice_Mfr5Plus.csv')
rentcondo <-read_csv('http://files.zillowstatic.com/research/public/Metro/Metro_MedianRentalPrice_CondoCoop.csv')
rentduplex <-read_csv('http://files.zillowstatic.com/research/public/Metro/Metro_MedianRentalPrice_DuplexTriplex.csv')


MetroRentSF <- rentSF %>% 
  rename(Metro = RegionName) %>% 
  select(-SizeRank) %>% 
  filter(Metro=="Washington, DC") %>% 
  gather(key = 'monthx', value = 'MedianSFRent', -Metro) %>% 
  filter(Metro=="Washington, DC") %>% 
  arrange(Metro, monthx) %>% 
  mutate(month = substr(monthx, 6, 7),
         year= substr(monthx, 1,4)) %>% 
  filter(month=="07") %>% 
  select(-monthx, -Metro, -month)


MetroRentMF <- rentlargeMF %>% 
  rename(Metro = RegionName) %>% 
  select(-SizeRank) %>% 
  filter(Metro=="Washington, DC") %>% 
  gather(key = 'monthx', value = 'MedianMFRent', -Metro) %>% 
  filter(Metro=="Washington, DC") %>% 
  arrange(Metro, monthx) %>% 
  mutate(month = substr(monthx, 6, 7),
         year= substr(monthx, 1,4)) %>% 
  filter(month=="07") %>% 
  select(-monthx, -Metro, -month)

MetroRentCondo <- rentcondo %>% 
  rename(Metro = RegionName) %>% 
  select(-SizeRank) %>% 
  filter(Metro=="Washington, DC") %>% 
  gather(key = 'monthx', value = 'MedianCondoRent', -Metro) %>% 
  filter(Metro=="Washington, DC") %>% 
  arrange(Metro, monthx) %>% 
  mutate(month = substr(monthx, 6, 7),
         year= substr(monthx, 1,4)) %>% 
  filter(month=="07") %>% 
  select(-monthx, -Metro, -month)

MetroRentduplex <- rentduplex %>% 
  rename(Metro = RegionName) %>% 
  select(-SizeRank) %>% 
  filter(Metro=="Washington, DC") %>% 
  gather(key = 'monthx', value = 'MedianDuplexRent', -Metro) %>% 
  filter(Metro=="Washington, DC") %>% 
  arrange(Metro, monthx) %>% 
  mutate(month = substr(monthx, 6, 7),
         year= substr(monthx, 1,4)) %>% 
  filter(month=="07") %>% 
  select(-monthx, -Metro, -month)

data1 <- full_join(inventoryMSAJuly, priceMSAJuly, by= c("year","year"))
data2<- full_join(data1,  MetroRentSF,by= c("year","year") )
data3<- full_join(data2,  MetroRentMF,by= c("year","year") )
data4<- full_join(data3,  MetroRentCondo,by= c("year","year") )
data5<- full_join(data4,  MetroRentduplex,by= c("year","year") )

filepath <- paste0("L:/Libraries/RegHsg/Data/")

write_csv(data5, 
          paste0(filepath, "Housing market_Zillow data.csv"))


