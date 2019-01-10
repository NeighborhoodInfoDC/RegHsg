
#' Select Black Knight variables
#'
#' @description This function selects a subset of variables that will be used
#' in the Regional Housing Framework analyses.
#' 
#' @param dataset dataframe of Black Knight data
#'
#' @return dataframe with select variables
#' @export
#'
select_vars <- function(dataset) {

  dataset %>% select(county_fips, county_name,
         standardizedlandusecode,
         bkfsinternalpid,
         assessorsparcelnumberapnpin,
         duplicateapn,
         propaddress = propertyfullstreetaddress,
         propcity = propertycityname,
         propstate = propertystate,
         propzip = propertyzipcode,
         propzip4 = propertyzip4,
         propunittype = propertyunittype,
         propunitno = propertyunitnumber,
         prophouseno = propertyhousenumber,
         propstreetname = propertystreetname,
         propstreetsuffix = propertystreetsuffix,
         lat = propertyaddresslatitiude,
         long = propertyaddresslongitude,
         tract = propertyaddresscensustract,
         taxaccountnumber,
         owneroccupiedresidential,
         assessedlandvalue,
         assessedimprovementvalue,
         totalassessedvalue,
         assessmentyear,
         countylandusedescription,
         countylandusecode,
         zoning,
         lotsizeorarea,
         lotsizeareaunit,
         originallotsizeorarea,
         buildingarea,
         yearbuilt,
         noofbuildings,
         noofstories,
         totalnumberofrooms,
         numberofunits,
         numberofbedrooms,
         marketvalueland,
         marketvalueimprovement,
         totalmarketvalue,
         marketvalueyear,
         buildingclass,
         lotsizesquarefeet,
         floorcover,
         lotsizeacres,
         condoprojectbldgname   
  )

}


