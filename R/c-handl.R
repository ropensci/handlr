#' combine many handl objects
#' 
#' @export
#' @param ... one or more objects of class `handl`; see [handl] for more.
#' all inputs must be of class `handl`. if the first input is not of class
#' `handl`, you will not get back an object of class `handl`
#' @return an object of class `handl` of length equal to number of
#' `handl` objects passed in
#' @examples
#' z <- system.file('extdata/crossref.ris', package = "handlr")
#' cr <- ris_reader(z)
#' z <- system.file('extdata/peerj.ris', package = "handlr")
#' prj <- ris_reader(z)
#' res <- c(cr, prj)
#' res
#' invisible(lapply(bibtex_writer(res), cat, sep = "\n\n"))
c.handl <- function(...) {
  nw <- list(...)
  clz <- vapply(nw, inherits, logical(1), what = "handl")
  if (!all(clz)) stop("all inputs to ... must be of class handl", 
    call. = FALSE)
  structure(lapply(nw, unclass), class = "handl", 
    many = length(nw) > 1,
    file = vapply(nw, attr, "", which = "file"),
    from = paste0(vapply(nw, attr, "", which = "from"), collapse = ",")
  )
}
