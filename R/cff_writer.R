#' Citation File Format (cff) writer
#'
#' @export
#' @param z an object of class `handl`; see [handl] for more
#' @param path a file path or connection; default: `stdout()`
#' @return text if one cff citation or list of many
#' @family writers
#' @family cff
#' @references CFF format:
#' https://github.com/citation-file-format/citation-file-format
#' @details uses `yaml::write_yaml` to write to yaml format that 
#' CFF uses
#' @examples
#' (z <- system.file('extdata/citation.cff', package = "handlr"))
#' res <- cff_reader(x = z)
#' res
#' unclass(res)
#' cff_writer(res)
#' cat(cff_writer(res))
#' f <- tempfile()
#' cff_writer(res, f)
#' readLines(f)
#' unlink(f)
cff_writer <- function(z, path = NULL) {
  assert(z, "handl")
  stopifnot(length(z) > 0)
  cff_write_one(z, path)
}

cff_write_one <- function(z, path) {
  zz <- ccp(list(
    'cff-version' = req(z$cff_version, "cff-version"),
    message = req(z$message, "message"),
    version = req(z$software_version, "version"),
    title = req(
      parse_attributes(z$title, content = "text", first = TRUE), "title"),
    authors = req(cff_auths(z$author), "authors"),
    doi = z$doi,
    'date-released' = req(z$date_published, "date-released"),
    url = z$b_url,
    keywords = z$keywords,
    references = z$references
  ))
  if (is.null(path)) {
    txt <- utils::capture.output(yaml::write_yaml(zz, stdout()))
    return(paste0(txt, collapse = "\n"))
  }
  yaml::write_yaml(zz, file = path)
}

cff_auths <- function(e) {
  lapply(e, function(w) {
    names(w)[names(w) == "familyName"] <- "family-names"
    names(w)[names(w) == "givenName"] <- "given-names"
    w$type <- NULL
    w$name <- NULL
    w[order(names(w))]
  })
}

# check for required variables for CFF
req <- function(x, var) {
  if (is.null(x) || length(x) == 0 || !nzchar(x)) {
    stop("'", var, "' is required", call. = FALSE)
  }
  return(x)
}
