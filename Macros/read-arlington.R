
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
read_arlington <- function(rmd = TRUE) {
  
  filename <- paste0("L:/Libraries/RegHsg/Data/", filepath,
                     "/", filepath, "-cleaned-data.csv")
  
  if (!file.exists(filename)) {
    stop("cleaned data not found in Data directory")
  } else {
    
    read_csv(filename,
             col_types = cols(county_fips = col_character(),
                              county_name = col_character(),
                              assessorsparcelnumberapnpin = col_character(),
                              propaddress = col_character(),
                              propcity = col_character(),
                              propstate = col_character(),
                              propzip = col_character(),
                              propunitno = col_character(),
                              prophouseno = col_character(),
                              propstreetname = col_character(),
                              propstreetsuffix = col_character(),
                              lat = col_double(),
                              long = col_double(),
                              tract = col_character(),
                              owneroccupiedresidential = col_character(),
                              countylandusedescription = col_character(),
                              zoning = col_character(),
                              buildingarea = col_double(),
                              noofbuildings = col_character(),
                              noofstories = col_character(),
                              numberofunits = col_integer(),
                              yearbuilt = col_integer(),
                              lotsize_acres = col_double(),
                              lotsize_sf = col_double(),
                              address_type = col_character(),
                              category = col_character(),
                              category_detail = col_character(),
                              residential = col_integer(),
                              building_type = col_character(),
                              assessedlandvalue = col_double(),
                              assessedimprovementvalue = col_double(),
                              totalassessedvalue = col_double(),
                              raw_parcelid_prop = col_character(),
                              lotsize_prop = col_double(),
                              propaddress_prop = col_character(),
                              numberofunits_prop = col_character(),
                              parcel_area = col_double(),
                              parcel_length = col_double(),
                              raw_parcelid_par = col_character(),
                              parcel_address = col_character(),
                              vacant_flag = col_integer(),
                              units_address = col_double(),
                              area = col_double()))
  }
}









