
#' Read in Black Knight data extract
#'
#' This function imports a csv of Black Knight property records data 
#'    for the DC COG region, which includes:
#'    District of Columbia
#'    Charles County
#'    Frederick County
#'    Montgomery County
#'    Prince George's County
#'    Arlington County
#'    Fairfax County
#'    Loudoun County
#'    Prince William County
#'    Alexandria city
#'    Fairfax city
#'    Falls Church city
#'    Manassas city
#'    Manassas Park city
#'    The function then merges the extract with county names and 
#'    standardized land use code descriptions.
#' 
#' @param datafile name of the data extract, including file type (".csv")
#'
#' @return returns a data frame of property records data
#' @examples region <- read_csv("dc-cog-assessment-20181226.csv")
#' @export
#' }

read_bk <- function(datafile) {
    
  # read raw data
    cog_assessment <- read_csv(paste0("L:/Libraries/RegHsg/Raw/", datafile),
                               col_types = cols(.default = col_character()))
    
  # add county names
    county_names <- tibble(
      county_fips = as.character(c(11001, 24017, 24021, 24031, 24033, 
                                   51013, 51059, 51107, 51153, 51510, 
                                   51600, 51610, 51683, 51685)),
      county_name = c("District of Columbia", "Charles County",
                      "Frederick County", "Montgomery County",
                      "Prince George's County", "Arlington County",
                      "Fairfax County", "Loudoun County",
                      "Prince William County", "Alexandria city",
                      "Fairfax city", "Falls Church city",
                      "Manassas city", "Manassas Park city")
      )
    
    cog_assessment <- cog_assessment %>% 
      rename(county_fips = fipscodestatecounty) %>% 
      left_join(county_names, by = "county_fips") %>% 
      select(county_fips, county_name, everything())
    
  # add land use codes
    codes <- read_csv(
      "Doc/assessment_landuse.csv",
      col_names = c("standardizedlandusecode", "codedescription"),
      col_types = cols(standardizedlandusecode = col_character(),
                       codedescription = col_character())
      )
    
    cog_assessment <- cog_assessment %>% 
      left_join(codes, by = "standardizedlandusecode")

  # return dataset  
    cog_assessment
}
read_bk()

