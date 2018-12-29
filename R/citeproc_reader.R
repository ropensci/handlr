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
  # FIXME: doi = normalize_doi(meta.fetch("DOI", nil))
  doi <- meta$DOI %||% NULL
  # FIXME: get_authors(from_citeproc(Array.wrap(meta.fetch("author", nil))))
  # get_authors(from_citeproc(meta$author %||% NULL))
  author <- from_citeproc(meta$author %||% NULL)
  # author = meta$author %||% NULL
  # FIXME: get_authors(from_citeproc(Array.wrap(meta.fetch("editor", nil))))
  # get_authors(from_citeproc(meta$editor %||% NULL))
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

