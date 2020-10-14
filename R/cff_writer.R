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
#' @section Converting to CFF from other formats:
#' CFF has required fields that can't be missing. This means that
#' converting from other citation types to CFF will likely require
#' adding the required CFF fields manually. Adding fields to a 
#' `handl` object is easy: it's really just an R list so add
#' named elements to it. The required CFF fields are:
#' 
#' - cff-version: add `cff_version`
#' - message: add `message`
#' - version: add `software_version`
#' - title: add `title`
#' - authors: add `author`
#' - date-released: add `date_published`
#' 
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
#' 
#' # convert from a different citation format
#' ## see "Converting to CFF from other formats" above
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' w <- citeproc_reader(x = z)
#' # cff_writer(w) # fails unless we add required fields
#' w$cff_version <- "1.1.0"
#' w$message <- "Please cite the following works when using this software."
#' w$software_version <- "2.5"
#' w$title <- "A cool library"
#' w$date_published <- "2017-12-18"
#' cff_writer(w)
#' cat(cff_writer(w))
cff_writer <- function(z, path = NULL) {
  assert(z, "handl")
  stopifnot(length(z) > 0)
  cff_write_one(z, path)
}

cff_write_one <- function(z, path) {
  zz <- ccp(list(
    'cff-version' = req(z$cff_version %||% cff_version, "cff-version"),
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
    # rename some fields
    names(w)[names(w) == "familyName"] <- "family-names"
    names(w)[names(w) == "givenName"] <- "given-names"
    # drop unsupported fields
    w <- w[names(w) %in% cff_person_fields]
    # sort fields
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

cff_version <- "1.1.0"

cff_person_fields <- c(
  "family-names",
  "given-names",
  "name-particle",
  "name-suffix",
  "affiliation",
  "address",
  "city ",
  "region ",
  "post-code",
  "country",
  "orcid",
  "email",
  "tel",
  "fax",
  "website"
)
