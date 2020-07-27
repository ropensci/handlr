split_list <- function(lst, splits) {
  out <- list()
  for (i in seq_along(splits)) {
    start <- if (length(out)) length(out[[1]]) + 2 else 1
    out[[i]] <- lst[seq(from = start, to = splits[i] - 1)]
  }
  return(out)
}


#' ris reader (Research Information Systems)
#'
#' @export
#' @param x (character) a file path or string
#' @return an object of class `handl`; see [handl] for more
#' @family readers
#' @family ris
#' @references RIS tags https://en.wikipedia.org/wiki/RIS_(file_format)
#' @examples
#' z <- system.file('extdata/crossref.ris', package = "handlr")
#' ris_reader(z)
#'
#' z <- system.file('extdata/peerj.ris', package = "handlr")
#' ris_reader(z)
#'
#' z <- system.file('extdata/plos.ris', package = "handlr")
#' ris_reader(z)
#'
#' # from a string
#' z <- system.file('extdata/crossref.ris', package = "handlr")
#' my_string <- ris_writer(ris_reader(z))
#' class(my_string)
#' ris_reader(my_string)
#'
#' # many
#' z <- system.file('extdata/multiple-eg.ris', package = "handlr")
#' ris_reader(z)
ris_reader <- function(x) {
  assert(x, "character")
  txt <- if (file.exists(x)) readLines(x) else strsplit(x, "\n")[[1]]
  if (any(grepl("\\{", txt)) && any(grepl("\\}", txt))) {
    stop("'x' is not likely RIS format",  call. = FALSE)
  }
  meta <- ris_meta(txt)
  if (!"ER" %in% names(meta)) meta <- list(meta)
  if ("ER" %in% names(meta)) {
    splits <- which(names(meta) %in% "ER")
    meta <- split_list(meta, splits)
  }
  tmp <- lapply(meta, ris_read_one)
  many <- length(meta) > 1
  structure(if (many) tmp else tmp[[1]], class = "handl", from = "ris",
    source_type = if (is_file(x)) "file" else "string",
    file = if (is_file(x)) x else "", many = many)
}

ris_read_one <- function(z) {
  ris_type <- z$TY %||% "GEN"
  type <- RIS_TO_SO_TRANSLATIONS[[ris_type]] %||% "CreativeWork"
  doi <- validate_doi(z$DO %||% z$M3)
  # other author codes exist, but just using AU/A1 to stick
  # to main authors (not editors/reviewers/etc.)
  author <- Map(function(a) list(name = a),
    z[names(z) %in% c("AU", "A1")],
    USE.NAMES = FALSE)
  container_title <- z$T2 %||% NULL
  date_parts <- z$PY %||% NULL
  if (!is.null(date_parts)) date_parts <- strsplit(date_parts, "/")[[1]]
  date_published <- get_date_from_parts(date_parts)
  is_part_of <- NULL
  is_part_of <- if (!is.null(container_title)) {
    ccp(list(
      type = "Periodical",
      title = container_title,
      issn = z$SN %||% NULL))
  }
  state <- if (!is.null(doi)) "findable" else "not_found"

  list(
    id = normalize_doi(doi),
    type = type,
    citeproc_type = RIS_TO_CP_TRANSLATIONS[[type]] %||% "misc",
    ris_type = ris_type,
    resource_type_general = SO_TO_DC_TRANSLATIONS[[type]],
    doi = doi,
    b_url = z$UR %||% NULL,
    title = z$TI %||% z$T1 %||% NULL,
    # author = get_authors(author),
    author = author,
    publisher = z$PB %||% NULL,
    journal = z$JO %||% z$JF %||% z$JA %||% z$J1 %||%
      z$J2 %||% z$T2 %||% NULL,
    is_part_of = is_part_of,
    date_created = z$Y1 %||% NULL,
    date_published = date_published,
    date_accessed = z$Y2 %||% NULL,
    description = z$AB %||% z$N2 %||% NULL,
    volume = z$VL %||% NULL,
    issue = z$IS %||% NULL,
    first_page = z$SP %||% NULL,
    last_page = z$EP %||% NULL,
    keywords = unname(unlist(z[names(z) == "KW"])) %||% NULL,
    language = z$LA %||% NULL,
    state = state
  )
}

# x: a string
ris_meta <- function(x) {
  # abstract section kludge
  if (any(grepl("^AB|^N2", x))) {
    # guess if abstract is all likely on the one line or not
    if (!nchar(grep("^AB|^N2", x, value = TRUE)) > 200) {
      ab_start <- grep("^AB|^N2", x)
      indices <- grep("^[A-Z]{2}", x)
      ab_end <- indices[which(indices == ab_start) + 1] - 1
      ab_text <- strtrim(paste0(x[(ab_start + 1):ab_end], collapse = " "))
      x[ab_start] <- paste(x[ab_start], ab_text)
      x <- x[!seq_along(x) %in% (ab_start + 1):ab_end]
    }
  }
  # splitting
  sapply(x, function(z) {
    tt <- strsplit(z, "\\s+-\\s+")[[1]]
    if (any(grepl("-$", tt))) tt <- c(sub("\\s+-$", "", tt), NA_character_)
    as.list(stats::setNames(tt[2], tt[1]))
  }, USE.NAMES = FALSE)
}

RIS_TO_SO_TRANSLATIONS <- list(
  "BLOG" = "BlogPosting",
  "GEN" = "CreativeWork",
  "CTLG" = "DataCatalog",
  "DATA" = "Dataset",
  "FIGURE" = "ImageObject",
  "THES" = "Thesis",
  "MPCT" = "Movie",
  "JOUR" = "ScholarlyArticle",
  "COMP" = "SoftwareSourceCode",
  "VIDEO" = "VideoObject",
  "ELEC" = "WebPage"
)

RIS_TO_CP_TRANSLATIONS <- list(
  "JOUR" = "article-journal"
)

RIS_TO_BIB_TRANSLATIONS <- list(
  "JOUR" = "article",
  "BOOK" = "book",
  "CHAP" = "inbook",
  "CPAPER" = "inproceedings",
  "GEN" = "misc",
  "THES" = "phdthesis",
  "CONF" = "proceedings",
  "RPRT" = "techreport",
  "UNPD" = "unpublished"
)
