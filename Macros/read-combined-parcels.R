
#' Read in cleaned Black Knight data for Arlington County
#'
#'
#'
#' @param rmd indicates whether or not function is being called from an 
#' Rmd document or not. Default is set to TRUE.
#'
#' @return dataframe of black knight data for Arlington county, with all variables that were created in the clean and preclean phase.
#' @export
#'
#' @examples jur <- read_jurisdiction("arlington", rmd = TRUE)
read_combined_parcels <- function(rmd = TRUE) {
  
  filename <- "L:/Libraries/RegHsg/Data/parcel-all-cleaned-data.csv"
  
  if (!file.exists(filename)) {
    stop("cleaned data not found in Data directory")
  } else {
    
    read_csv(filename,
             col_types = cols(
               county_fips = col_character(),
               county_name = col_character(),
               assessorsparcelnumberapnpin = col_character(),
               propaddress = col_character(),
               zoning = col_character(),
               lotsize_sf = col_double(),
               parcel_area = col_double(),
               numberofunits = col_double(),
               category = col_character(),
               category_detail = col_character(),
               countylandusedescription = col_character(),
               residential = col_double(),
               lat = col_double(),
               long = col_double(),
               parcelgeo_x = col_double(),
               parcelgeo_y = col_double()
             ))
  }
}









