#' citeproc reader
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
ris_reader <- function(x) {
  txt <- if (file.exists(x)) readLines(x) else strsplit(x, "\n")[[1]]
  meta <- ris_meta(txt)
  ris_type <- meta$TY %||% "GEN"
  type <- RIS_TO_SO_TRANSLATIONS[[ris_type]] %||% "CreativeWork"
  doi <- validate_doi(meta$DO %||% meta$M3)
  # other author codes exist, but just using AU/A1 to stick 
  # to main authors (not editors/reviewers/etc.)
  author <- Map(function(a) list(name = a), 
    meta[names(meta) %in% c("AU", "A1")], 
    USE.NAMES = FALSE)
  container_title <- meta$T2 %||% NULL
  date_parts <- meta$PY %||% NULL
  if (!is.null(date_parts)) date_parts <- strsplit(date_parts, "/")[[1]]
  date_published <- get_date_from_parts(date_parts)
  is_part_of <- NULL
  is_part_of <- if (!is.null(container_title)) {
    ccp(list(
      type = "Periodical", 
      title = container_title, 
      issn = meta$SN %||% NULL))
  }
  state <- if (!is.null(doi)) "findable" else "not_found"
  
  structure(list(
    id = normalize_doi(doi),
    type = type,
    citeproc_type = RIS_TO_CP_TRANSLATIONS[[type]] %||% "misc",
    ris_type = ris_type,
    resource_type_general = SO_TO_DC_TRANSLATIONS[[type]],
    doi = doi,
    b_url = meta$UR %||% NULL,
    title = meta$TI %||% meta$T1 %||% NULL,
    # author = get_authors(author),
    author = author,
    publisher = meta$PB %||% NULL,
    journal = meta$JO %||% meta$JF %||% meta$JA %||% meta$J1 %||% meta$J2 %||% meta$T2 %||% NULL,
    is_part_of = is_part_of,
    date_created = meta$Y1 %||% NULL,
    date_published = date_published,
    date_accessed = meta$Y2 %||% NULL,
    description = meta$AB %||% meta$N2 %||% NULL,
    volume = meta$VL %||% NULL,
    issue = meta$IS %||% NULL,
    first_page = meta$SP %||% NULL,
    last_page = meta$EP %||% NULL,
    keywords = unname(unlist(meta[names(meta) == "KW"])) %||% NULL,
    language = meta$LA %||% NULL,
    state = state
  ), class = "handl", from = "ris", file = x, many = FALSE)
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
      ab_text <- strtrim(paste0(x[(ab_start+1):ab_end], collapse = " "))
      x[ab_start] <- paste(x[ab_start], ab_text)
      x <- x[!seq_along(x) %in% (ab_start+1):ab_end]
    }
  }
  # splitting
  sapply(x, function(z) {
    tt <- strsplit(z, "\\s+-\\s+")[[1]]
    as.list(stats::setNames(tt[2], tt[1]))
  }, USE.NAMES = FALSE)
}

# def ris_meta(string: nil)
#   h = Hash.new { |h,k| h[k] = [] }
#   string.split("\n").reduce(h) do |sum, line|
#     k, v = line.split("-")
#     h[k.strip] << v.to_s.strip
#     sum
#   end.map { |k,v| [k, v.unwrap] }.to_h.compact
# end

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
