#' bibtex writer
#' 
#' @export
#' @param z an object of class `handl`; see [handl] for more
#' @param key (character) optional bibtex key to use. if `NULL` we 
#' attempt try the following fields in order: `key`, `identifier`, 
#' `id`, `doi`. if you pass in ouput from [bibtex_reader()] you're
#' likely to have a `key` field, but otherwise probably not
#' @return an object of class `BibEntry`
#' @family writers
#' @family bibtex
#' @examples
#' (z <- system.file('extdata/citeproc.json', package = "handlr"))
#' (tmp <- citeproc_reader(z))
#' bibtex_writer(z = tmp)
#' cat(bibtex_writer(z = tmp), sep = "\n")
#' 
#' (z <- system.file('extdata/bibtex2.bib', package = "handlr"))
#' z <- bibtex_reader(z)
#' bibtex_writer(z)
#' cat(bibtex_writer(z), sep = "\n")
#' 
#' # give a bibtex key
#' cat(bibtex_writer(z, "foobar89"), sep = "\n")
#' 
#' # many at once 
#' (z <- system.file('extdata/bib-many.bib', package = "handlr"))
#' out <- bibtex_reader(x = z)
#' bibtex_writer(out)
bibtex_writer <- function(z, key = NULL) {
  assert(z, "handl")
  stopifnot(length(z) > 0)
  if (attr(z, "many") %||% FALSE) {
    if (!is.null(key)) {
      if (length(z) != length(key)) {
        stop("if 'key' is given, it must be the same length as 'z'")
      }
    }
    return(lapply(z, bibtex_write_one, key = key))
  } 
  bibtex_write_one(z, key)
}

bibtex_write_one <- function(z, key) {
  if (is.null(key)) 
    key <- z[["key"]] %||% z$identifier %||% z$id %||% z[["doi"]]
  bib <- ccp(list(
    bibtype = z$bibtex_type %||% "misc",
    key = key,
    doi = z$doi,
    url = z$b_url,
    # author = authors_as_string(z$author),
    author = z$author,
    keywords = paste0(vapply(z$keywords, function(w) 
      parse_attributes(w, content = "text", first = TRUE), ""), 
      collapse = ", "),
    language = z$language,
    # title = parse_attributes(z$title, content = "text", first = TRUE),
    title = z$title,
    journal = z$container_title,
    volume = z$volume,
    issue = z$issue,
    pages = paste(z$first_page, z$last_page, sep = "--"),
    publisher = z$publisher,
    year = if (!is.null(z$date_published)) 
      substring(z$date_published, 1, 4) else NULL,
    date = z$date_published
  ))
  convert_to_bibtex(bib)
}
