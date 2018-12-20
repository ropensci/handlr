skip_if_net_down <- function() {
  testthat::skip_if(!crul::ok("https://httpbin.org/get"),
    "internet down")
}
