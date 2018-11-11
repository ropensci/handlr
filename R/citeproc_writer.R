#' citeproc writer
#' 
#' @export
#' @param z a `handlr` internal format object
#' @param auto_unbox (logical) automatically ‘unbox’ all atomic 
#' vectors of length 1 (default: `TRUE`). passed to [jsonlite::toJSON()]
#' @param pretty (logical) adds indentation whitespace to JSON output 
#' (default: `TRUE`), passed to [jsonlite::toJSON()]
#' @param ... further params passed to [jsonlite::toJSON()]
#' @return citeproc as JSON
#' @family writers
#' @family citeproc
#' @examples
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' (tmp <- citeproc_reader(file = z))
#' citeproc_writer(z = tmp)
#' citeproc_writer(z = tmp, pretty = TRUE)
#' cat(ris_writer(z = tmp))
citeproc_writer <- function(z, auto_unbox = TRUE, pretty = TRUE, ...) {
  jsonlite::toJSON(list(
    type = z$citeproc_type %||% NULL,
    id = z$id,
    categories = lapply(z$keywords, function(k) 
      parse_attributes(k, content = "text", first = TRUE)),
    language = z$language %||% NULL,
    author = to_citeproc(z$author),
    editor = to_citeproc(z$editor),
    issued = get_date_parts(z$date_published) %||% NULL,
    submitted = get_date_parts(z$date_submitted) %||% NULL,
    abstract = parse_attributes(z$description, content = "text", first = TRUE),
    'container-title' = z$container_title,
    DOI = z$doi %||% NULL,
    issue = z$issue %||% NULL,
    page = paste0(z$first_page, z$last_page, collapse = "-"),
    publisher = z$publisher %||% NULL,
    title = parse_attributes(z$title, content = "text", first = TRUE),
    URL = z$b_url %||% NULL,
    version = z$b_version %||% NULL,
    volume = z$volume %||% NULL
  ), auto_unbox = auto_unbox, pretty = pretty, ...)
}
