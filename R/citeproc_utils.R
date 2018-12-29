get_date_parts <- function(x = NULL) {
  if (is.null(x)) return(list('date-parts' = NULL))
  year <- substring(x, 1, 4)
  month <- substring(x, 6, 7)
  day <- substring(x, 9, 10)
  list('date-parts' = c(year, month, day))
}

get_date_from_date_parts <- function(x) {
  date_parts <- x$`date-parts`[[1]]
  year <- date_parts[[1]]
  month <- tryCatch(date_parts[[2]], error = function(e) e)
  if (inherits(month, "error")) month <- NULL
  day <- tryCatch(date_parts[[3]], error = function(e) e)
  if (inherits(day, "error")) day <- NULL
  get_date_from_parts(year, month, day)
}

get_date_from_parts <- function(year, month = NULL, day = NULL) {  
  paste0(Filter(function(z) z != "00", list(
    sprintf("%4.2d", as.numeric(year)),
    sprintf("%2.2d", as.numeric(month)),
    sprintf("%2.2d", as.numeric(day))
  )), collapse = "-")
}

from_citeproc <- function(element) {
  if (is.null(element)) return(NULL)
  lapply(element, function(w) {
    if (!is.null(w$literal)) {
      w$`@type` <- "Organization"
      w$name <- w$literal
    } else {
      w$`@type` <- "Person"
      w$name <- paste(w$given, w$family)
    }
    w$givenName <- w$given
    w$familyName <- w$family
    except(w, c("given", "family", "literal"))
  })
}

to_citeproc <- function(element) {
  lapply(element, function(a) {
    a$family <- a$familyName
    a$given <- a$givenName
    a$literal <- if (!is.null(a$familyName)) a$familyName else a$name
    ccp(a[c("type", "@type", "id", "@id", "name", "familyName", "givenName") %in% names(a)])
  })
}
