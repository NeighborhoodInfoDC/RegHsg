
get_single_properties <- function(dataset) {
  
  addresses <- dataset %>% 
    group_by(propaddress) %>% 
    count() %>% filter(n == 1) %>% 
    pull(propaddress)
  
  dataset %>% 
    filter(propaddress %in% addresses,
           !is.na(prophouseno),
           !is.na(propaddress))
  
}

get_multiple_properties <- function(dataset) {
  
  addresses <- dataset %>% 
    group_by(propaddress) %>% 
    count() %>% filter(n > 1) %>% 
    pull(propaddress)
  
  dataset %>% 
    filter(propaddress %in% addresses,
           !is.na(prophouseno),
           !is.na(propaddress))
  
}

get_missing_address <- function(dataset) {
  
  dataset %>% 
    filter(is.na(prophouseno) |
           is.na(propaddress))
  
}

check_classification <- function(dataset, 
                                 single_data = singles, 
                                 multiple_data = multiples,
                                 missing_data = missing_address) {
  
  if (nrow(dataset) != nrow(single_data) + nrow(multiple_data)
                     + nrow(missing_data)) {
    
    warning("error in single/multiple/missing classification")
  } else { print("singles, multiples, and missing add to total")
  }
}




