#' citeproc reader
#' 
#' @export
#' @param file (character) a file path
#' @return xxx
#' @family readers
#' @family citeproc
#' @examples
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' citeproc_reader(file = z)
citeproc_reader <- function(file) {
  meta <- jsonlite::fromJSON(file, FALSE)
  citeproc_type = meta$type %||% NULL
  type = CP_TO_SO_TRANSLATIONS[[citeproc_type]] %||% "CreativeWork"
  # FIXME: doi = normalize_doi(meta.fetch("DOI", nil))
  doi = meta$DOI %||% NULL
  # FIXME: get_authors(from_citeproc(Array.wrap(meta.fetch("author", nil))))
  # get_authors(from_citeproc(meta$author %||% NULL))
  author = from_citeproc(meta$author %||% NULL)
  # author = meta$author %||% NULL
  # FIXME: get_authors(from_citeproc(Array.wrap(meta.fetch("editor", nil))))
  # get_authors(from_citeproc(meta$editor %||% NULL))
  editor = from_citeproc(meta$editor %||% NULL)
  # editor = meta$editor %||% NULL
  date_published = get_date_from_date_parts(meta$issued %||% NULL)
  container_title = meta$`container-title` %||% NULL
  is_part_of <- if (!is.null(container_title)) {
    ccp(list(type = "Periodical",
      title = container_title,
      issn = meta$ISSN %||% NULL))
  } else {
    NULL
  }
  # FIXME: id = normalize_id(meta.fetch("id", nil))
  id <- meta$id %||% NULL
  state <- if (!is.null(id)) "findable" else "not_found"
  list(
    id = id,
    type = type,
    additional_type = meta$additionalType %||% NULL,
    citeproc_type = citeproc_type,
    bibtex_type = SO_TO_BIB_TRANSLATIONS[[type]] %||% "misc",
    ris_type = CP_TO_RIS_TRANSLATIONS[[type]] %||% "GEN",
    # "resource_type_general" = Bolognese::Utils::SO_TO_DC_TRANSLATIONS[type],
    # "doi" = doi_from_url(doi),
    doi = doi,
    # b_url = normalize_id(meta.fetch("URL", nil)),
    title = meta$title %||% NULL,
    author = author,
    container_title = container_title,
    publisher = meta$publisher %||% NULL,
    is_part_of = is_part_of,
    date_published = date_published,
    volume = meta$volume %||% NULL,
    description = meta$abstract %||% NULL,
    # "description" = meta.fetch("abstract", nil).present? ? { "text" = sanitize(meta.fetch("abstract")) } : nil,
    b_version = meta$version %||% NULL,
    keywords = meta$categories %||% NULL,
    state = state
  )
}

CP_TO_SO_TRANSLATIONS <- list(
  "song" = "AudioObject",
  "post-weblog" = "BlogPosting",
  "dataset" = "Dataset",
  "graphic" = "ImageObject",
  "motion_picture" = "Movie",
  "article-journal" = "ScholarlyArticle",
  "broadcast" = "VideoObject",
  "webpage" = "WebPage"
)

CP_TO_RIS_TRANSLATIONS <- list(
  "post-weblog" = "BLOG",
  "dataset" = "DATA",
  "graphic" = "FIGURE",
  "book" = "BOOK",
  "motion_picture" = "MPCT",
  "article-journal" = "JOUR",
  "broadcast" = "MPCT",
  "webpage" = "ELEC"
)

get_date_from_date_parts <- function(x) {
  date_parts = x$`date-parts`[[1]]
  year = date_parts[[1]]
  month = tryCatch(date_parts[[2]], error = function(e) e)
  if (inherits(month, "error")) month <- NULL
  day = tryCatch(date_parts[[3]], error = function(e) e)
  if (inherits(day, "error")) day <- NULL
  get_date_from_parts(year, month, day)
}

get_date_from_parts <- function(year, month = NULL, day = NULL) {  
  paste0(Filter(function(z) z != "00", list(
    sprintf("%4.2d", as.numeric(year)),
    sprintf("%2.2d", as.numeric(month)),
    sprintf("%2.2d", as.numeric(day))
  )), collapse = "-")
}

from_citeproc <- function(element) {
  if (is.null(element)) return(NULL)
  lapply(element, function(w) {
    if (!is.null(w$literal)) {
      w$`@type` <- "Organization"
      w$name <- w$literal
    } else {
      w$`@type` <- "Person"
      w$name <- paste(w$given, w$family)
    }
    w$givenName <- w$given
    w$familyName <- w$family
    except(w, c("given", "family", "literal"))
  })
}
