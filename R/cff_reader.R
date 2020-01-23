#' Citation File Format (cff) reader
#'
#' @export
#' @param x (character) a file path or a yaml string
#' @return an object of class `handl`; see [handl] for more
#' @family readers
#' @family cff
#' @references CFF format:
#' https://github.com/citation-file-format/citation-file-format/blob/master/README.md
#' @examples
#' (z <- system.file('extdata/citation.cff', package = "handlr"))
#' cff_reader(x = z)
cff_reader <- function(x) {
  assert(x, "character")
  txt <- if (is_file(x)) yaml::yaml.load_file(x) else yaml::yaml.load(x)
  structure(cff_read_one(txt),
    class = "handl", from = "cff",
    source_type = if (is_file(x)) "file" else "string",
    file = if (is_file(x)) x else "", many = FALSE)
}

cff_read_one <- function(x) {
  doi <- x$doi
  author <- lapply(x$authors, function(z) {
    list(
      type = "Person",
      name = pcsp(pcsp(z$`given-names`), pcsp(z$`family-names`)),
      givenName = pcsp(z$`given-names`),
      familyName = pcsp(z$`family-names`)
    )
  })
  state <- if (!is.null(doi)) "findable" else "not_found"

  list(
    "cff_version" = x$`cff-version`,
    "message" = x$message,
    # "key" = attr(x, "key"),
    "id" = normalize_doi(doi),
    # "type" = type,
    # "bibtex_type" = type,
    # "citeproc_type" = CFF_TO_CP_TRANSLATIONS[[type]] %||% "misc",
    # "ris_type" = CFF_TO_RIS_TRANSLATIONS[[type]] %||% "GEN",
    # "resource_type_general" = SO_TO_DC_TRANSLATIONS[[type]],
    # "additional_type" = CFF_TO_CR_TRANSLATIONS[[type]] %||% type,
    "doi" = doi,
    "b_url" = x$url %||% NULL,
    "title" = x$title %||% NULL,
    "author" = author,
    "publisher" = x$publisher %||% NULL,
    "is_part_of" = NULL,
    "date_published" = x$`date-released` %||% NULL,
    "b_version" = x$version %||% NULL,
    "volume" = x$volume %||% NULL,
    "first_page" = NULL,
    "last_page" = NULL,
    # "description" = list(text = x$abstract %||% NULL && sanitize(x$abstract)),
    "description" = list(text = x$abstract %||% NULL),
    "license" = list(id = x$copyright %||% NULL),
    "state" = state
  )
}

# CFF_TO_CP_TRANSLATIONS <- list(
#   article = "article-journal",
#   phdthesis = "thesis"
# )

# CFF_TO_RIS_TRANSLATIONS <- list(
#   article = "JOUR",
#   book = "BOOK",
#   inbook = "CHAP",
#   inproceedings = "CPAPER",
#   manual = NULL,
#   misc = "GEN",
#   phdthesis = "THES",
#   proceedings = "CONF",
#   techreport = "RPRT",
#   unpublished = "UNPD"
# )

# CFF_TO_SO_TRANSLATIONS <- list(
#   article = "ScholarlyArticle",
#   phdthesis = "Thesis"
# )
