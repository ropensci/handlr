#' bibtex reader
#' 
#' @export
#' @param x (character) a file path or a bibtex string
#' @return an object of class `handl`; see [handl] for more
#' @family readers
#' @family bibtex
#' @examples
#' (z <- system.file('extdata/crossref.bib', package = "handlr"))
#' bibtex_reader(x = z)
#' (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#' bibtex_reader(x = z)
#' 
#' # many at once 
#' (z <- system.file('extdata/bib-many.bib', package = "handlr"))
#' bibtex_reader(x = z)
bibtex_reader <- function(x) {
  assert(x, "character")
  x <- paste0(x, collapse = "\n")
  file <- tempfile(fileext = ".bib")
  if (!is_file(x)) cat(x, sep = "\n", file = file)
  if (is_file(x)) file <- x
  meta <- unclass(RefManageR::ReadBib(file))
  tmp <- lapply(meta, bibtex_read_one)
  many <- length(meta) > 1
  structure(if (many) tmp else tmp[[1]], 
    class = "handl", from = "bibtex", 
    source_type = if (is_file(x)) "file" else "string", 
    file = if (is_file(x)) x else "", many = many)
}

bibtex_read_one <- function(x) {
  type <- tolower(attr(x, "bibtype") %||% NULL)
  ttype <- BIB_TO_SO_TRANSLATIONS[[type]] %||% "ScholarlyArticle"
  doi <- x$doi

  author <- lapply(x$author, function(z) {
    list(
      type = "Person",
      name = pcsp(pcsp(z$given), pcsp(z$family)),
      givenName = pcsp(z$given),
      familyName = pcsp(z$family)
    )
  })

  is_part_of <- if (!is.null(x$journal)) {
    ccp(list(
      type = "Periodical", 
      title = x$journal,
      issn = x$issn))
  } else {
    NULL
  }

  first_page <- last_page <- NULL
  if (!is.null(x$pages)) {
    pp <- strsplit(x$pages, "--")[[1]]
    first_page <- try_with_warn(pp[1], as.numeric)
    last_page <- try_with_warn(pp[2], as.numeric)
  }
  
  state <- if (!is.null(doi)) "findable" else "not_found"

  list(
    "key" = attr(x, "key"),
    "id" = normalize_doi(doi),
    "type" = type,
    "bibtex_type" = type,
    "citeproc_type" = BIB_TO_CP_TRANSLATIONS[[type]] %||% "misc",
    "ris_type" = BIB_TO_RIS_TRANSLATIONS[[type]] %||% "GEN",
    "resource_type_general" = SO_TO_DC_TRANSLATIONS[[type]],
    "additional_type" = BIB_TO_CR_TRANSLATIONS[[type]] %||% type,
    "doi" = doi,
    "b_url" = x$url %||% NULL,
    "title" = x$title %||% NULL,
    "author" = author,
    "publisher" = x$publisher %||% NULL,
    "is_part_of" = is_part_of,
    "date_published" = x$date %||% NULL,
    "volume" = x$volume %||% NULL,
    "first_page" = first_page,
    "last_page" = last_page,
    # "description" = list(text = x$abstract %||% NULL && sanitize(x$abstract)),
    "description" = list(text = x$abstract %||% NULL),
    "license" = list(id = x$copyright %||% NULL),
    "state" = state
  )
}

BIB_TO_CP_TRANSLATIONS <- list(
  article = "article-journal",  
  phdthesis = "thesis"
)

BIB_TO_RIS_TRANSLATIONS <- list(
  article = "JOUR",
  book = "BOOK",
  inbook = "CHAP",
  inproceedings = "CPAPER",
  manual = NULL,
  misc = "GEN",
  phdthesis = "THES",
  proceedings = "CONF",
  techreport = "RPRT",
  unpublished = "UNPD"
)

BIB_TO_SO_TRANSLATIONS <- list(
  article = "ScholarlyArticle",
  phdthesis = "Thesis"
)

SO_TO_DC_TRANSLATIONS <- list(
  article = "Text",
  audioObject = "Sound",
  blog = "Text",
  blogPosting = "Text",
  chapter = "Text",
  collection = "Collection",
  creativeWork = "Other",
  dataCatalog = "Dataset",
  dataset = "Dataset",
  event = "Event",
  imageObject = "Image",
  movie = "Audiovisual",
  publicationIssue = "Text",
  scholarlyArticle = "Text",
  thesis = "Text",
  service = "Service",
  softwareSourceCode = "Software",
  videoObject = "Audiovisual",
  webPage = "Text",
  webSite = "Text"
)

pcsp <- function(...) paste(..., collapse = " ")

try_with_warn <- function(x, fun) {
  res <- tryCatch(eval(fun)(x), warning = function(w) w)
  if (inherits(res, "warning")) return(x)
  x
}
