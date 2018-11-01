#' ris writer
#' 
#' @export
#' @param z a `handlr` internal format object
#' @return xxx
#' @family writers
#' @family ris
#' @references RIS tags https://en.wikipedia.org/wiki/RIS_(file_format)
#' @examples
#' # from a RIS file
#' z <- system.file('extdata/crossref.ris', package = "handlr")
#' tmp <- ris_reader(file = z)
#' cat(ris_writer(z = tmp))
#' 
#' # peerj
#' z <- system.file('extdata/peerj.ris', package = "handlr")
#' tmp <- ris_reader(file = z)
#' cat(ris_writer(z = tmp))
#' 
#' # plos
#' z <- system.file('extdata/plos.ris', package = "handlr")
#' tmp <- ris_reader(file = z)
#' cat(ris_writer(z = tmp))
#' 
#' # elsevier
#' z <- system.file('extdata/elsevier.ris', package = "handlr")
#' tmp <- ris_reader(file = z)
#' cat(ris_writer(z = tmp))
#' 
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' res <- citeproc_reader(file = z)
#' cat(ris_writer(z = res))
ris_writer <- function(z) {
  zz <- ccp(list(
    TY = z$ris_type %||% "",
    T1 = parse_attributes(z$title, content = "text", first = TRUE),
    T2 = z$container_title,
    AU = to_ris(z$author),
    DO = z$doi,
    UR = z$b_url,
    AB = parse_attributes(z$description, content = "text", first = TRUE),
    KW = vapply(z$keywords, function(w) parse_attributes(w, content = "text", first = TRUE), ""),
    PY = z$publication_year,
    Y1 = z$date_created,
    PB = z$publisher,
    JO = z$journal,
    LA = z$language,
    VL = z$volume,
    IS = z$issue,
    SP = z$first_page,
    EP = z$last_page,
    SN = z$is_part_of$issn,
    ER = ""
  ))
  out <- unlist(unname(Map(function(k, v) {
    if (length(v) > 1) {
      paste0(vapply(v, function(b) sprintf("%s  - %s", k, b), ""), collapse = "\r\n")
    } else {
      sprintf("%s  - %s", k, v)
    }
  }, names(zz), zz)))
  paste0(out, collapse = "\r\n")
}

to_ris <- function(e) {
  sapply(e, function(w) {
    if (!is.null(w$familyName)) {
      paste0(w$familyName, w$givenName, collapse = ", ")
    } else {
      w$name
    }
  })
}
