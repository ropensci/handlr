#' Schema org writer
#' 
#' @name schema_org
#' @param x input
#' @examples
#' (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#' (tmp <- bibtex_reader(z))
#' schema_hsh(tmp)
#' schema_org(tmp)

#' @export
#' @rdname schema_org
schema_hsh <- function(x) {
  ccp(list(
    "@context" = if (!is.null(x$id)) "http://schema.org" else NULL,
    "@type" = x$type,
    "@id" = x$id,
    "identifier" = to_schema_org_identifier(x$id, ccp(list(alternate_identifier = x$alternate_identifier %||% NULL))),
    "url" = x$b_url,
    "additionalType" = x$additional_type,
    "name" = parse_attributes(x$title, content = "text", first = TRUE),
    "author" = to_schema_org(x$author),
    "editor" = to_schema_org(x$editor),
    "description" = parse_attributes(x$description, content = "text", first = TRUE),
    "license" = unlist(ccp(lapply(x$license, function(l) l$id))),
    "version" = x$b_version,
    "keywords" = if (!is.null(x$keywords)) paste0(lapply(x$keywords, function(k) parse_attributes(k, content = "text", first = TRUE)), collapse = ", ") else NULL,
    "inLanguage" = x$language %||% NULL,
    "contentSize" = x$content_size %||% NULL,
    "encodingFormat" = x$content_format %||% NULL,
    "dateCreated" = x$date_created %||% NULL,
    "datePublished" = x$date_published %||% NULL,
    "dateModified" = x$date_modified %||% NULL,
    "pageStart" = x$first_page %||% NULL,
    "pageEnd" = x$last_page %||% NULL,
    "spatialCoverage" = x$spatial_coverage %||% NULL,
    "sameAs" = to_schema_org(x$is_identical_to),
    "isPartOf" = if (x$type == "Dataset") NULL else to_schema_org_container(x$is_part_of, list(container_title = x$container_title, type = x$type)),
    "hasPart" = to_schema_org(x$has_part),
    "predecessor_of" = to_schema_org(x$is_previous_version_of),
    "successor_of" = to_schema_org(x$is_new_version_of),
    "citation" = to_schema_org(x$references),
    "@reverse" = x$reverse.presence,
    "contentUrl" = x$content_url %||% NULL,
    "schemaVersion" = x$schema_version %||% NULL,
    "includedInDataCatalog" = if (x$type == "Dataset") to_schema_org_container(x$is_part_of, list(container_title = x$container_title, type = x$type)) else NULL,
    "publisher" = if (!is.null(x$publisher)) list("@type" = "Organization", "name" = x$publisher) else NULL,
    "funding" = to_schema_org(x$funding),
    "provider" = if (!is.null(x$service_provider)) list("@type" = "Organization", "name" = x$service_provider) else NULL
  ))
}

#' @export
#' @rdname schema_org
schema_org <- function(x, auto_unbox = TRUE, pretty = TRUE, ...) {
  jsonlite::toJSON(schema_hsh(x), auto_unbox = auto_unbox, pretty = pretty)
}


# utils
to_schema_org <- function(element) {
  mapping = list(type = "@type", id = "@id", title = "name")
  map_hash_keys(element = element, mapping = mapping)
}

map_hash_keys <- function(element = NULL, mapping = NULL) {
  # lapply(element, function(a) {
  lapply(wrap_list(element), function(a) {
    for (i in seq_along(a)) {
      rep_key <- mapping[[names(a)[i]]]
      if (!is.null(rep_key)) names(a)[i] <- rep_key
    }
    return(a)
  })
}

wrap_list <- function(m) {
  if (!is.list(m)) return(m)
  if (!is.null(names(m))) list(m) else m
}

to_schema_org_identifier <- function(element, options = list()) {
  ident <- list( 
    "@type" = "PropertyValue",
    propertyID = if (!is.null(normalize_doi(element))) "doi" else "url",
    value = element
  )

  if (is.null(options$alternate_identifier)) return(ident)
  if (!is.null(options$alternate_identifier)) {
    c(ident, lapply(options$alternate_identifier, function(w) {
      if (tolower(ai$type) == "url") {
        ai$name
      } else {
        list(
          "@type" = "PropertyValue",
          propertyID = ai$type,
          value = ai$name
        )
      }
    }))
  }
}

to_schema_org_container <- function(element = NULL, options = list()) {
  if (is.list(element) && (is.null(element) && !is.null(options$container_title))) {
    return(NULL)
  }
  mapping <- list("type" = "@type", "id" = "@id", "title" = "name")
  element <- element %||% list()
  element$type <- if (options$type == "dataset") "DataCatalog" else "Periodical"
  element$title <- element$title %||% options$container_title
  map_hash_keys(element, mapping)
}