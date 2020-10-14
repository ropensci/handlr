#' citeproc writer
#' 
#' @export
#' @param z an object of class `handl`; see [handl] for more
#' @param auto_unbox (logical) automatically "unbox" all atomic 
#' vectors of length 1 (default: `TRUE`). passed to [jsonlite::toJSON()]
#' @param pretty (logical) adds indentation whitespace to JSON output 
#' (default: `TRUE`), passed to [jsonlite::toJSON()]
#' @param ... further params passed to [jsonlite::toJSON()]
#' @return citeproc as JSON
#' @family writers
#' @family citeproc
#' @examples
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' (tmp <- citeproc_reader(z))
#' citeproc_writer(z = tmp)
#' citeproc_writer(z = tmp, pretty = FALSE)
#' cat(ris_writer(z = tmp))
#' 
#' # many
#' z <- system.file('extdata/citeproc-many.json', package = "handlr")
#' w <- citeproc_reader(x = z)
#' citeproc_writer(w)
citeproc_writer <- function(z, auto_unbox = TRUE, pretty = TRUE, ...) {
  assert(z, "handl")
  stopifnot(length(z) > 0)
  w <- if (attr(z, "many") %||% FALSE) {
    lapply(z, citeproc_write_one) 
  } else {
    citeproc_write_one(z)
  }
  jsonlite::toJSON(w, auto_unbox = auto_unbox, pretty = pretty, ...)
}

citeproc_write_one <- function(z) {
  extra_csl <- z[grep("csl_", names(z))]
  names(extra_csl) <- gsub("csl_", "", names(extra_csl))
  extra_csl <- unslugify(extra_csl)
  c(
    list(
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
      page = paste(z$first_page, z$last_page, sep = "-"),
      publisher = z$publisher %||% NULL,
      title = parse_attributes(z$title, content = "text", first = TRUE),
      URL = z$url %||% NULL,
      version = z$software_version %||% NULL,
      volume = z$volume %||% NULL
    ),
    extra_csl
  )
}
