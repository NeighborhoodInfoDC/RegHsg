
#' Read in cleaned Black Knight data for Montgomery County
#'
#'
#'
#'
#' @return dataframe of black knight data for Montgomery county, with all variables that were created in the clean and preclean phase.
#' @export
#'
#' @examples jur <- read_jurisdiction("montgomery", rmd = TRUE)
read_montgomery<- function() {
  
  filepath <- "montgomery"
  
  filename <- paste0("L:/Libraries/RegHsg/Data/", filepath,
                     "/", "postcleaned-", filepath, "-data.csv")
  
  if (!file.exists(filename)) {
    stop("cleaned data not found in Data directory")
  } else {
    
    read_csv(filename,
             col_types = cols(
               county_fips = col_character(),
               county_name = col_character(),
               assessorsparcelnumberapnpin = col_character(),
               propaddress = col_character(),
               propcity = col_character(),
               propstate = col_character(),
               propzip = col_double(),
               propunitno = col_character(),
               prophouseno = col_character(),
               propstreetname = col_character(),
               propstreetsuffix = col_character(),
               tract = col_double(),
               owneroccupiedresidential = col_character(),
               countylandusedescription = col_character(),
               zoning = col_character(),
               buildingarea = col_double(),
               noofbuildings = col_double(),
               noofstories = col_character(),
               numberofunits = col_double(),
               yearbuilt = col_double(),
               lotsize_acres = col_double(),
               lotsize_sf = col_double(),
               address_type = col_character(),
               category = col_character(),
               category_detail = col_character(),
               residential = col_double(),
               building_type = col_character(),
               totalassessedvalue = col_double(),
               assessedlandvalue = col_double(),
               assessedimprovementvalue = col_double(),
               parcel_address = col_character(),
               lsmax = col_double(),
               vac2 = col_logical(),
               vacant_flag = col_logical(),
               missing_houseno = col_logical(),
               DISTRICT = col_character(),
               ACCT = col_character(),
               LU_CATEGORY = col_character(),
               CONDO_UNIT_NO = col_character(),
               NO_DWELLINGS = col_double(),
               DWELLING_TYPE = col_character(),
               PLANNING = col_character(),
               POLICY = col_character(),
               MASTER_PLAN = col_character(),
               RES_DWELLU = col_character(),
               Shape_Area = col_double(),
               cflag = col_logical(),
               propflag = col_logical(),
               cflag.x = col_logical(),
               propflag.x = col_logical(),
               ACCT_address = col_character(),
               parcel_id = col_character(),
               cflag.y = col_logical(),
               propflag.y = col_logical(),
               lot_acct = col_character(),
               clotflag = col_double(),
               arc_lotsize = col_double(),
               missing_coord = col_double(),
               latarc = col_double(),
               longarc = col_double(),
               lat1 = col_double(),
               long1 = col_double(),
               lat2 = col_double(),
               long2 = col_double(),
               OBJECTID.x = col_double(),
               GISADMIN_Z = col_double(),
               ZONE_ = col_character(),
               CODE = col_character(),
               PERIMETER = col_double(),
               ACRES = col_double(),
               ZONE1 = col_character(),
               ZONING_ID = col_double(),
               BEGINDATE = col_date(format = ""),
               BEGINREASO = col_character(),
               BEGINPLANN = col_character(),
               ENDDATE = col_character(),
               ENDREASON = col_character(),
               ENDPLANNER = col_character(),
               LONGZONE = col_character(),
               SHAPE_AREA = col_double(),
               SHAPE_LEN = col_double(),
               validgeo.x = col_double(),
               notinmont = col_double(),
               OBJECTID.y = col_character(),
               ZONE = col_character(),
               ZONE_DESC = col_character(),
               ZONE_Conca = col_character(),
               validgeo.y = col_logical(),
               rockflag = col_double(),
               STATEFP = col_double(),
               PLACEFP = col_double(),
               PLACENS = col_character(),
               GEOID = col_double(),
               NAME = col_character(),
               NAMELSAD = col_character(),
               LSAD = col_double(),
               CLASSFP = col_character(),
               PCICBSA = col_character(),
               PCINECTA = col_character(),
               MTFCC = col_character(),
               FUNCSTAT = col_character(),
               ALAND = col_double(),
               AWATER = col_double(),
               INTPTLAT = col_double(),
               INTPTLON = col_double(),
               validgeo = col_double(),
               gaitflag = col_double(),
               arc_zoning = col_character()
             ))
  } 
}











