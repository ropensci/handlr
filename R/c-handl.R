#' combine many handl objects
#' 
#' @export
#' @param ... one or more objects of class `handl`; see [handl] for more
#' @return text if one RIS citation or list of many 
#' @examples
#' z <- system.file('extdata/crossref.ris', package = "handlr")
#' cr <- ris_reader(z)
#' z <- system.file('extdata/peerj.ris', package = "handlr")
#' prj <- ris_reader(z)
#' c(cr, prj)
c.handl <- function(...) {
  # assert(z, "handl")
  nw <- list(...)
  structure(lapply(nw, unclass), class = "handl", 
    many = length(nw) > 1,
    file = vapply(nw, attr, "", which = "file"),
    from = paste0(vapply(nw, attr, "", which = "from"), collapse = ",")
  )
}
