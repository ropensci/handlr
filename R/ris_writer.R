#' ris writer (Research Information Systems)
#'
#' @export
#' @param z an object of class `handl`; see [handl] for more
#' @return text if one RIS citation or list of many
#' @family writers
#' @family ris
#' @references RIS tags https://en.wikipedia.org/wiki/RIS_(file_format)
#' @examples
#' # from a RIS file
#' z <- system.file('extdata/crossref.ris', package = "handlr")
#' tmp <- ris_reader(z)
#' cat(ris_writer(z = tmp))
#'
#' # peerj
#' z <- system.file('extdata/peerj.ris', package = "handlr")
#' tmp <- ris_reader(z)
#' cat(ris_writer(z = tmp))
#'
#' # plos
#' z <- system.file('extdata/plos.ris', package = "handlr")
#' tmp <- ris_reader(z)
#' cat(ris_writer(z = tmp))
#'
#' # elsevier
#' z <- system.file('extdata/elsevier.ris', package = "handlr")
#' tmp <- ris_reader(z)
#' cat(ris_writer(z = tmp))
#'
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' res <- citeproc_reader(z)
#' cat(ris_writer(z = res))
#'
#' # many
#' ## combine many RIS in a handl object
#' z <- system.file('extdata/crossref.ris', package = "handlr")
#' cr <- ris_reader(z)
#' z <- system.file('extdata/peerj.ris', package = "handlr")
#' prj <- ris_reader(z)
#' c(cr, prj)
#'
#' # many bibtex to ris via c method
#' if (requireNamespace("bibtex", quietly=TRUE)) {
#' a <- system.file('extdata/bibtex.bib', package = "handlr")
#' b <- system.file('extdata/crossref.bib', package = "handlr")
#' aa <- bibtex_reader(a)
#' bb <- bibtex_reader(a)
#' (res <- c(aa, bb))
#' cat(ris_writer(res), sep = "\n\n")
#' }
#'
#' ## manhy Citeproc to RIS
#' z <- system.file('extdata/citeproc-many.json', package = "handlr")
#' w <- citeproc_reader(x = z)
#' ris_writer(w)
#' cat(ris_writer(w), sep = "\n")
ris_writer <- function(z) {
  assert(z, "handl")
  stopifnot(length(z) > 0)
  if (!attr(z, "many") %||% FALSE) return(ris_write_one(z))
  vapply(z, ris_write_one, character(1))
}

ris_write_one <- function(z) {
  zz <- ccp(list(
    TY = z$ris_type %||% "",
    T1 = parse_attributes(z$title, content = "text", first = TRUE),
    T2 = z$container_title,
    AU = to_ris(z$author),
    DO = z$doi,
    UR = z$b_url,
    AB = parse_attributes(z$description, content = "text", first = TRUE),
    KW = vapply(z$keywords, function(w)
      parse_attributes(w, content = "text", first = TRUE), ""),
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
      paste0(vapply(v, function(b) sprintf("%s  - %s", k, b), ""),
        collapse = "\r\n")
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
