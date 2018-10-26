#' citeproc reader
#' 
#' @export
#' @param file (character) a file path
#' @return xxx
#' @examples
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' tmp <- citeproc_reader(file = z)
#' bibtex_writer(tmp)
bibtex_writer <- function(z) {
  # return nil unless valid?
  bib = ccp(list(
    # bibtex_type = z$bibtex_type.presence || "misc",
    bibtype = z$bibtex_type %||% "misc",
    key = z$identifier %||% z$id,
    doi = z$doi,
    url = z$b_url,
    author = authors_as_string(z$author),
    # keywords = z$keywords.present? ? Array.wrap(z$keywords).map { |k| parse_attributes(k, content = "text", first = true) }.join(", ")  = nil,
    keywords = paste0(unlist(z$keywords), collapse = ","),
    language = z$language,
    # title = parse_attributes(z$title, content = "text", first = TRUE),
    title = z$title,
    journal = z$container_title,
    volume = z$volume,
    issue = z$issue,
    pages = paste(z$first_page, z$last_page, collapse = "-"),
    publisher = z$publisher,
    year = z$publication_year
  ))
  # bib
  RefManageR::as.BibEntry(bib)
  # BibTeX::Entry.new(bib).to_s
}
