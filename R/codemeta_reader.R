#' codemeta reader
#' 
#' @export
#' @param x (character) a file path or string (character or json)
#' @return an object of class `handl`; see [handl] for more
#' @family readers
#' @family codemeta
#' @examples
#' # single
#' (z <- system.file('extdata/codemeta.json', package = "handlr"))
#' codemeta_reader(x = z)
#' 
#' # many
#' (z <- system.file('extdata/codemeta-many.json', package = "handlr"))
#' codemeta_reader(x = z)
codemeta_reader <- function(x) {
  assert(x, c("character", "json"))
  meta <- jsonlite::fromJSON(x, FALSE)
  if (!is.null(names(meta))) meta <- list(meta)
  tmp <- lapply(meta, codemeta_read_one)
  many <- length(meta) > 1
  structure(if (many) tmp else tmp[[1]],
    class = "handl", from = "codemeta",
    source_type = if (is_file(x)) "file" else "string", 
    file = if (is_file(x)) x else "", many = many)
}

codemeta_read_one <- function(meta) {
  identifier <- meta$identifier %||% NULL
  id <- normalize_id(meta$`@id` %||% meta$identifier)
  type <- meta$`@type` %||% NULL
  # author <- get_authors(from_schema_org(meta$agents %||% NULL))
  author <- from_schema_org(meta$agents %||% NULL)
  # editor <- get_authors(from_schema_org(meta$editor %||% NULL))
  editor <- from_schema_org(meta$editor %||% NULL)
  date_published <- meta$datePublished %||% NULL
  publisher <- meta$publisher %||% NULL
  state <- if (!is.null(meta)) "findable" else "not_found"

  list(
    "id" = id,
    "type" = type,
    "additional_type" = meta$additionalType %||% NULL,
    "citeproc_type" = SO_TO_CP_TRANSLATIONS[[type]] %||% "article-journal",
    "bibtex_type" = SO_TO_BIB_TRANSLATIONS[[type]] %||% "misc",
    "ris_type" = SO_TO_RIS_TRANSLATIONS[[type]] %||% "GEN",
    "resource_type_general" = SO_TO_DC_TRANSLATIONS[[type]],
    "identifier" = identifier,
    "doi" = validate_doi(id),
    "b_url" = normalize_id(meta$codeRepository %||% NULL),
    "title" = meta$title %||% NULL,
    "author" = author,
    "editor" = editor,
    "publisher" = publisher,
    #{}"is_part_of" = is_part_of,
    "date_created" = meta$dateCreated %||% NULL,
    "date_published" = date_published,
    "date_modified" = meta$dateModified %||% NULL,
    "description" = if (!is.null(meta$description)) {
      # list(text = sanitize(meta$description)) 
      list(text = meta$description)
    } else {
      NULL
    },
    "license" = list(id = meta$license %||% NULL ),
    "b_version" = meta$version %||% NULL,
    "keywords" = meta$tags %||% NULL,
    "state" = state
  )
}

# get_codemeta <- function(id = NULL) {
#   return { "string" = nil, "state" = "not_found" } unless id.present?
#   id = normalize_id(id)
#   response = Maremma.get(github_as_codemeta_url(id), accept: "json", raw: true)
#   string = response.body.fetch("data", nil)
#   { "string" = string }
# }
