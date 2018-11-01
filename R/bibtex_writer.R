#' bibtex writer
#' 
#' @export
#' @param z a `handlr` internal format object
#' @return an object of class `BibEntry`
#' @family writers
#' @family bibtex
#' @examples
#' (z <- system.file('extdata/citeproc.json', package = "handlr"))
#' (tmp <- citeproc_reader(file = z))
#' bibtex_writer(z = tmp)
bibtex_writer <- function(z) {
  # return nil unless valid?
  bib = ccp(list(
    bibtype = z$bibtex_type %||% "misc",
    key = z$identifier %||% z$id %||% z$doi,
    doi = z$doi,
    url = z$b_url,
    # author = authors_as_string(z$author),
    author = z$author,
    keywords = paste0(vapply(z$keywords, function(w) parse_attributes(w, content = "text", first = TRUE), ""), collapse = ", "),
    language = z$language,
    # title = parse_attributes(z$title, content = "text", first = TRUE),
    title = z$title,
    journal = z$container_title,
    volume = z$volume,
    issue = z$issue,
    pages = paste(z$first_page, z$last_page, collapse = "-"),
    publisher = z$publisher,
    year = if (!is.null(z$date_published)) substring(z$date_published, 1, 4) else NULL,
    date = z$date_published
  ))
  # bib
  # RefManageR::as.BibEntry(bib)
  convert_to_bibtex(bib)
}

# as_bib <- function(x) { 
# }
