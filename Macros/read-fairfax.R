
#' Read in cleaned Black Knight data for Fairfax County
#'
#'
#'
#' @param rmd indicates whether or not function is being called from an 
#' Rmd document or not. Default is set to TRUE.
#'
#' @return dataframe of black knight data for Fairfax county, with all variables that were created in the clean and preclean phase.
#' @export
#'
#' @examples jur <- read_jurisdiction("fairfax", rmd = TRUE)
read_fairfax <- function(rmd = TRUE) {
  
  filename <- paste0("L:/Libraries/RegHsg/Data/", filepath,
                     "/", filepath, "-cleaned-data.csv")
  
  if (!file.exists(filename)) {
    stop("cleaned data not found in Data directory")
  } else {
    
    read_csv(filename,
             col_types = cols(county_fips = col_integer(),
                         county_name = col_character(),
                         assessorsparcelnumberapnpin = col_character(),
                         propaddress = col_character(),
                         propcity = col_character(),
                         propstate = col_character(),
                         propzip = col_integer(),
                         propunitno = col_character(),
                         prophouseno = col_character(),
                         propstreetname = col_character(),
                         propstreetsuffix = col_character(),
                         lat = col_double(),
                         long = col_double(),
                         tract = col_double(),
                         owneroccupiedresidential = col_character(),
                         countylandusedescription = col_character(),
                         zoning = col_character(),
                         buildingarea = col_double(),
                         noofbuildings = col_integer(),
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
                         area_tax = col_double(),
                         zone_tax = col_character(),
                         possibleSF_tax = col_double(),
                         stories_tax = col_character(),
                         category_tax = col_character(),
                         parcel_id = col_character(),
                         num_livunit = col_integer(),
                         dwellings_per_parcel = col_integer(),
                         land_per_parcel = col_integer(),
                         parcel_address = col_character(),
                         parcel_area = col_character(),
                         sf_area = col_character(),
                         containsLarge = col_character(),
                         maxsize = col_character(),
                         numberofunits_tax = col_character(),
                         vacant_flag = col_character()
             ))
    } 
  }
  
                









