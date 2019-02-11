#' max_narm
#'
#' @param x a (non-empty) vector of data values.
#'
#' @return
#' @export
#'
#' @examples
max_narm <- function(x) {
  if (sum(is.na(x)) == length(x)) {
    NA
  } else if (sum(is.na(x)) != length(x)) {
    dplyr::max(x, na.rm = TRUE)
  } else {
    stop("Invalid vector")
  }
}


