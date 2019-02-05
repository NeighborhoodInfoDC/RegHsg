
#' Sample properties based on county land use code
#'
#' @description This functions will randomly sample a certain county land 
#' use code, to generate addresses to manually look up.
#' 
#' @param dataset dataframe of Black Knight data
#' @param condition county land use code to sample
#' @param number how many properties to return
#'
#' @return dataframe of n observations from designated county land use code.
#' @export
#'
#' @examples
sample_properties <- function(dataset, condition, number) {
  
  len <- nrow(filter(dataset,
                     countylandusedescription == condition))
  
  if (len < number) {
    stop("Only ", len, " obervations: chose a smaller number")
  } else if (len == number) {
    dataset %>% 
      filter(countylandusedescription == condition) %>% 
      sample_n(number, replace = TRUE)
    warning("all observations sampled")
  } else {
    dataset %>% 
      filter(countylandusedescription == condition) %>% 
      sample_n(number)
  }
}



