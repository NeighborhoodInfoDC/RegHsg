
get_single_properties <- function(dataset) {
  
  addresses <- dataset %>% 
    group_by(propaddress) %>% 
    count() %>% filter(n == 1) %>% 
    pull(propaddress)
  
  dataset %>% 
    filter(propaddress %in% addresses)
  
}

get_multiple_properties <- function(dataset) {
  
  addresses <- dataset %>% 
    group_by(propaddress) %>% 
    count() %>% filter(n > 1) %>% 
    pull(propaddress)
  
  dataset %>% 
    filter(propaddress %in% addresses)
  
}

check_classification <- function(dataset, 
                                 single_data = singles, 
                                 multiple_data = multiples) {
  
  if (nrow(dataset) != nrow(single_data) + nrow(multiple_data)) {
    
    warning("error in single/multiple classification")
  } else { print("singles and multiples add to total")
  }
}




