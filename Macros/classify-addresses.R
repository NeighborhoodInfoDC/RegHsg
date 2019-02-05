
#' Classifly address types
#' 
#' @description This function creates a new variables that indicates if the
#' address is unique in the Black Knight data- it classifies addressess as 
#' "missing" (lacks either the entire address or the house number), "single",
#' or "multiple"
#'
#' @param dataset 
#'
#' @return dataset with additional `address_type` variable
#' @export
classify_addresses <- function(dataset) {
  
  group <- dataset %>% 
    group_by(propaddress) %>% 
    count()
  
  singles <- group %>% 
    filter(n == 1) %>% 
    pull(propaddress)
  
  multiples <- group %>% 
    filter(n > 1) %>% 
    pull(propaddress)
  
  dataset %>% 
    mutate(address_type = case_when(
      is.na(propaddress) | is.na(prophouseno) ~ "missing",
      propaddress %in% singles ~ "single",
      propaddress %in% multiples ~ "multiple"))
  
}




