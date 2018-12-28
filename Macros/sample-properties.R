
sample_properties <- function(dataset, condition, number) {
  
  dataset %>% 
    filter(countylandusedescription == condition) %>% 
    sample_n(number)

}



