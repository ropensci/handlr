#' codemeta writer
#' 
#' @export
#' @param z an object of class `handl`; see [handl] for more
#' @param auto_unbox (logical) automatically "unbox" all atomic 
#' vectors of length 1 (default: `TRUE`). passed to [jsonlite::toJSON()]
#' @param pretty (logical) adds indentation whitespace to JSON output 
#' (default: `TRUE`), passed to [jsonlite::toJSON()]
#' @param ... further params passed to [jsonlite::toJSON()]
#' @return an object of class `json`
#' @family writers
#' @family codemeta
#' @examples
#' if (requireNamespace("bibtex", quietly=TRUE)) {
#' (x <- system.file('extdata/crossref.bib', package = "handlr"))
#' (z <- bibtex_reader(x))
#' codemeta_writer(z)
#' }
#' 
#' # many citeproc to schema 
#' z <- system.file('extdata/citeproc-many.json', package = "handlr")
#' w <- citeproc_reader(x = z)
#' codemeta_writer(w)
#' codemeta_writer(w, pretty = FALSE)
codemeta_writer <- function(z, auto_unbox = TRUE, pretty = TRUE, ...) {
  assert(z, "handl")
  stopifnot(length(z) > 0)
  w <- if (attr(z, "many") %||% FALSE) {
    lapply(z, codemeta_write_one) 
  } else {
    codemeta_write_one(z)
  }
  jsonlite::toJSON(w, auto_unbox = auto_unbox, pretty = pretty, ...)
}

codemeta_write_one <- function(z) {
  ccp(list(
    "@context" = if (!is.null(z$id)) cm_urls else NULL,
    "@type" = z$type,
    "@id" = z$id %||% z$identifier,
    "identifier" = z$id %||% z$identifier,
    "codeRepository" = z$b_url,
    "title" = z$title,
    "agents" = z$author,
    "description" = parse_attributes(z$description, 
      content = "text", first = TRUE),
    "version" = z$software_version,
    # FIXME: not sure what's going on here
    "tags" = if (!is.null(z$keywords)) unlist(z$keywords) else NULL,
    "dateCreated" = z$date_created,
    "datePublished" = z$date_published,
    "dateModified" = z$date_modified,
    "publisher" = z$publisher
  ))
}

cm_urls <- c("http://purl.org/codemeta/2.0", "http://schema.org")
