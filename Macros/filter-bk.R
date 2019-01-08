
#' Filter Black Knight data by geography
#'
#' @param dataset the name of the dataframe of Black Knight data
#' @param fips desired fips code
#'
#' @return filtered dataframe
#' @export
#'
#' @examples arlington <- filter_bk(region, "51013")
filter_bk <- function(dataset, fips) {
  
  fips <- as.character(fips)
  
  dataset %>% filter(county_fips == fips)
  
}



