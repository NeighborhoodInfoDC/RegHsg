
filter_bk <- function(dataset, fips) {
  
  fips <- as.character(fips)
  
  dataset %>% filter(county_fips == fips)
  
}



