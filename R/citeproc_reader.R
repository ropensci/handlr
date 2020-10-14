#' citeproc reader
#' 
#' @export
#' @param x (character) a file path or string
#' @return an object of class `handl`; see [handl] for more
#' @family readers
#' @family citeproc
#' @examples
#' # single
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' citeproc_reader(x = z)
#' w <- system.file('extdata/citeproc2.json', package = "handlr")
#' citeproc_reader(x = w)
#' 
#' # many
#' z <- system.file('extdata/citeproc-many.json', package = "handlr")
#' citeproc_reader(x = z)
citeproc_reader <- function(x) {
  assert(x, "character")
  meta <- jsonlite::fromJSON(x, FALSE)
  if (!is.null(names(meta))) meta <- list(meta)
  tmp <- lapply(meta, citeproc_read_one)
  many <- length(meta) > 1
  structure(if (many) tmp else tmp[[1]], 
    class = "handl", from = "citeproc", 
    source_type = if (is_file(x)) "file" else "string", 
    file = if (is_file(x)) x else "", many = many)
}

citeproc_read_one <- function(meta) {
  citeproc_type <- meta$type %||% NULL
  type <- CP_TO_SO_TRANSLATIONS[[citeproc_type]] %||% "CreativeWork"
  doi <- meta$DOI %||% NULL
  author <- from_citeproc(meta$author %||% NULL)
  editor <- from_citeproc(meta$editor %||% NULL)
  # editor = meta$editor %||% NULL
  date_published <- get_date_from_date_parts(meta$issued %||% NULL)
  container_title <- meta$`container-title` %||% NULL
  is_part_of <- if (!is.null(container_title)) {
    ccp(list(type = "Periodical",
      title = container_title,
      issn = meta$ISSN %||% NULL))
  } else {
    NULL
  }
  id <- meta$id %||% NULL
  state <- if (!is.null(id)) "findable" else "not_found"

  first_page <- last_page <- NULL
  if (!is.null(meta$page)) {
    pp <- strsplit(meta$page, "-")[[1]]
    first_page <- try_with_warn(pp[1], as.numeric)
    last_page <- try_with_warn(pp[2], as.numeric)
  }

  csl_extras <- unname(unlist(csl_vars))
  csl_extras_remain <- csl_extras[!csl_extras %in% names(meta)]
  others <- meta[names(meta) %in% csl_extras_remain]
  if (length(others)) {
    others <- stats::setNames(others,
      gsub("-", "_", paste0("csl_", names(others)))
    )
  }

  c(list(
    id = id,
    type = type,
    additional_type = meta$additionalType %||% NULL,
    citeproc_type = citeproc_type,
    bibtex_type = SO_TO_BIB_TRANSLATIONS[[type]] %||% "misc",
    ris_type = CP_TO_RIS_TRANSLATIONS[[type]] %||% "GEN",
    doi = doi,
    url = normalize_id(meta$URL) %||% NULL,
    title = meta$title %||% NULL,
    author = author,
    container_title = container_title,
    publisher = meta$publisher %||% NULL,
    is_part_of = is_part_of,
    date_published = date_published,
    volume = meta$volume %||% NULL,
    issue = meta$issue %||% NULL,
    description = meta$abstract %||% NULL,
    software_version = meta$version %||% NULL,
    keywords = meta$categories %||% NULL,
    state = state,
    first_page = first_page,
    last_page = last_page
  ), others)
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
