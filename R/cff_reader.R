#' Citation File Format (cff) reader
#'
#' @export
#' @param x (character) a file path or a yaml string
#' @return an object of class `handl`; see [handl] for more
#' @family readers
#' @family cff
#' @references CFF format:
#' https://github.com/citation-file-format/citation-file-format
#' @details CFF only supports one citation, so `many` will always be
#' `FALSE`.
#'
#' Required fields:
#' * CFF **v1.1.0**: `cff-version`, `version`, `message`, `date-released`,
#' `title`, `authors`.
#' * CFF **v1.2.0**: `cff-version`, `message`, `title`, `authors`.
#'
#' We'll stop with error if any of these are missing.
#'
#' You can though have many references in your CFF file
#' associated with the citation. `references` is an optional component in
#' cff files. If included, we check the following:
#' - each reference must have the 3 required fields: type, authors, title
#' - type must be in the allowed set, see [cff_reference_types]
#' - the elements within authors must each be an entity or person object
#' https://github.com/citation-file-format/citation-file-format#entity-objects
#' https://github.com/citation-file-format/citation-file-format#person-objects
#' - title must be a string
#' @examples
#' (z <- system.file("extdata/citation.cff", package = "handlr"))
#' res <- cff_reader(x = z)
#' res
#' res$cff_version
#' res$software_version
#' res$message
#' res$id
#' res$doi
#' res$title
#' res$author
#' res$references
#'
#' # no references
#' (z <- system.file("extdata/citation-norefs.cff", package = "handlr"))
#' out <- cff_reader(x = z)
#' out
#' out$references
cff_reader <- function(x) {
  assert(x, "character")
  txt <- if (is_file(x)) yaml::yaml.load_file(x) else yaml::yaml.load(x)
  structure(cff_read_one(txt),
    class = "handl", from = "cff",
    source_type = if (is_file(x)) "file" else "string",
    file = if (is_file(x)) x else "", many = FALSE
  )
}

cff_read_one <- function(x) {
  doi <- x$doi
  author <- lapply(req(x$authors, "authors"), function(z) {
    l <- list(
      type = "Person",
      name = pcsp(pcsp(z$`given-names`), pcsp(z$`family-names`)),
      givenName = pcsp(z$`given-names`),
      familyName = pcsp(z$`family-names`),
      orcid = pcsp(z$orcid)
    )
    # Clean keys with no value
    l[unlist(lapply(l, function(x) x != ""))]
  })
  state <- if (!is.null(doi)) "findable" else "not_found"
  type <- "SoftwareSourceCode"
  cff_v <- req(x$`cff-version`, "cff-version")

  list(
    "cff_version" = req(x$`cff-version`, "cff-version"),
    "message" = req(x$message, "message"),
    # "key" = attr(x, "key"),
    "id" = normalize_doi(doi),
    "type" = type,
    # "additional_type" = CFF_TO_CR_TRANSLATIONS[[type]] %||% type,
    "citeproc_type" = SO_TO_CP_TRANSLATIONS[[type]] %||% "article-journal",
    "bibtex_type" = SO_TO_BIB_TRANSLATIONS[[type]] %||% "misc",
    "ris_type" = SO_TO_RIS_TRANSLATIONS[[type]] %||% "GEN",
    "resource_type_general" = SO_TO_DC_TRANSLATIONS[[type]] %||% "Other",
    "identifier" = doi,
    "doi" = doi,
    "b_url" = x$url %||% NULL,
    "title" = req(x$title, "title"),
    "author" = author,
    "date_published" = if (cff_v == "1.2.0") {
      x$`date-released` %||% NULL
    } else {
      req(x$`date-released`, "date-released")
    },
    "software_version" = if (cff_v == "1.2.0") {
      x$version %||% NULL
    } else {
      req(x$version, "version")
    },
    "description" = list(text = x$abstract %||% NULL),
    "license" = list(id = x$license %||% NULL),
    "keywords" = x$keywords %||% NULL,
    "state" = state,
    "references" = process_refs(x$references)
    # "description" = list(text = x$abstract %||% NULL && sanitize(x$abstract)),
    # "first_page" = NULL,
    # "last_page" = NULL,
    # "publisher" = x$publisher %||% NULL,
    # "is_part_of" = NULL,
    # "volume" = x$volume %||% NULL,
  )
}

process_refs <- function(w) {
  if (is.null(w)) {
    return(NULL)
  }

  # check that required fields are given
  cff_required_nms <- c("type", "authors", "title")
  cff_required_nms_c <- paste0(cff_required_nms, collapse = ", ")
  for (i in seq_along(w)) {
    mtch <- all(cff_required_nms %in% names(w[[i]]))
    if (!mtch) {
      stop(
        "reference ", i, " malformed; must have required fields: ",
        cff_required_nms_c
      )
    }
  }

  # check that title field is a string
  for (i in w) if (!is.character(i$title)) stop("'title' must be a string")

  # check that type values are within allowed set
  types <- vapply(w, "[[", "", "type")
  mtch_type <- types %in% cff_reference_types
  if (!all(mtch_type)) {
    stop("these reference types not in allowed set: ",
      paste0(types[!mtch_type], collapse = ", "),
      " (see ?cff_reader)",
      call. = FALSE
    )
  }

  # check that authors is a list of type entity's or person's
  auths <- unlist(lapply(w, "[[", "authors"), FALSE)
  for (i in auths) {
    if (!is_cff_entity(i) && !is_cff_person(i)) {
      stop("each element in 'authors' must be of type entity or person\n",
        "  see ?cff_reader Details",
        call. = FALSE
      )
    }
  }

  return(w)
}

# check that ALL list elements are named
is_named <- function(x) all(nzchar(names(x)))
is_cff_entity <- function(x) {
  is.list(x) && is_named(x) && "name" %in% names(x)
}
is_cff_person <- function(x) {
  is.list(x) &&
    is_named(x) &&
    all(c("family-names", "given-names") %in% names(x))
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
