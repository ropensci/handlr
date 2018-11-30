#' codemeta writer
#' 
#' @export
#' @param z a `handlr` internal format object
#' @param auto_unbox (logical) automatically ‘unbox’ all atomic 
#' vectors of length 1 (default: `TRUE`). passed to [jsonlite::toJSON()]
#' @param pretty (logical) adds indentation whitespace to JSON output 
#' (default: `TRUE`), passed to [jsonlite::toJSON()]
#' @param ... further params passed to [jsonlite::toJSON()]
#' @return an object of class `json`
#' @family writers
#' @family codemeta
#' @examples
#' (x <- system.file('extdata/crossref.bib', package = "handlr"))
#' (z <- bibtex_reader(x))
#' codemeta_writer(z)
codemeta_writer <- function(z, auto_unbox = TRUE, pretty = TRUE, ...) {
  jsonlite::toJSON(list(
    "@context" = if (!is.null(z$id)) url_cm else NULL,
    "@type" = z$type,
    "@id" = z$identifier,
    "identifier" = z$identifier,
    "codeRepository" = z$b_url,
    "title" = z$title,
    "agents" = z$author,
    "description" = parse_attributes(z$description, content = "text", first = TRUE),
    "version" = z$b_version,
    # FIXME: not sure what's going on here
    "tags" = if (!is.null(z$keywords)) unlist(z$keywords) else NULL,
    "dateCreated" = z$date_created,
    "datePublished" = z$date_published,
    "dateModified" = z$date_modified,
    "publisher" = z$publisher
  ), auto_unbox = auto_unbox, pretty = pretty, ...)
}

url_cm <- 
  "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld"
