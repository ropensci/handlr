#' bibtex reader
#' 
#' @export
#' @param x a `handlr` internal format object
#' @return an object of class `BibEntry`
#' @family readers
#' @family bibtex
#' @examples
#' (z <- system.file('extdata/crossref.bib', package = "handlr"))
#' bibtex_reader(x = z)
#' (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#' bibtex_reader(x = z)
bibtex_reader <- function(x) {
  # meta = string.present? ? BibTeX.parse(string).first %||% list()
  meta <- unclass(RefManageR::ReadBib(x))[[1]]

  type <- tolower(attr(meta, "bibtype") %||% NULL)
  ttype <- BIB_TO_SO_TRANSLATIONS[[type]] %||% "ScholarlyArticle"
  doi <- meta$doi

  author <- lapply(meta$author, function(z) {
    list(
      type = "Person",
      name = pcsp(pcsp(z$given), pcsp(z$family)),
      givenName = pcsp(z$given),
      familyName = pcsp(z$family)
    )
  })

  is_part_of <- if (!is.null(meta$journal)) {
    ccp(list(
      type = "Periodical", 
      title = meta$journal,
      issn = meta$issn))
  } else {
    NULL
  }

  first_page <- last_page <- NULL
  if (!is.null(meta$pages)) {
    pp <- strsplit(meta$pages, "--")[[1]]
    first_page <- as.numeric(pp[1])
    last_page <- as.numeric(pp[2])
  }
  
  state <- if (!is.null(doi)) "findable" else "not_found"
  # state = doi.present? ? "findable" : "not_found"

  list(
    "key" = attr(meta, "key"),
    "id" = normalize_doi(doi),
    "type" = type,
    "bibtex_type" = type,
    "citeproc_type" = BIB_TO_CP_TRANSLATIONS[[type]] %||% "misc",
    "ris_type" = BIB_TO_RIS_TRANSLATIONS[[type]] %||% "GEN",
    "resource_type_general" = SO_TO_DC_TRANSLATIONS[[type]],
    "additional_type" = BIB_TO_CR_TRANSLATIONS[[type]] %||% type,
    "doi" = doi,
    "b_url" = meta$url %||% NULL,
    "title" = meta$title %||% NULL,
    "author" = author,
    "publisher" = meta$publisher %||% NULL,
    "is_part_of" = is_part_of,
    "date_published" = meta$date %||% NULL,
    "volume" = meta$volume %||% NULL,
    "first_page" = first_page,
    "last_page" = last_page,
    # "description" = list(text = meta$abstract %||% NULL && sanitize(meta$abstract)),
    "description" = list(text = meta$abstract %||% NULL),
    "license" = list(id = meta$copyright %||% NULL),
    "state" = state
  )
}

BIB_TO_CP_TRANSLATIONS = list(
  article = "article-journal",  
  phdthesis = "thesis"
)

BIB_TO_RIS_TRANSLATIONS = list(
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

BIB_TO_SO_TRANSLATIONS = list(
  article = "ScholarlyArticle",
  phdthesis = "Thesis"
)

SO_TO_DC_TRANSLATIONS = list(
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
