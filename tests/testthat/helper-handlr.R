# skip_if_net_down <- function() {
#   testthat::skip_if(!crul::ok("https://httpbin.org/get"),
#     "internet down")
# }

has_internet <- function() {
  !is.null(suppressWarnings(utils::nsl("www.google.com")))
}

skip_if_net_down <- function() {
  if (has_internet()) {
    return()
  }
  testthat::skip("no internet")
}
