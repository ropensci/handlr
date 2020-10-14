`%||%` <- function(x, y) if (is.null(x) || all(is.na(x))) y else x

ccp <- function(x) Filter(Negate(is.null), x)

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

except <- function(x, nms) x[!names(x) %in% nms]

strextract <- function(str, pattern) {
  regmatches(str, regexpr(pattern, str))
}

strtrim <- function(str) gsub("^\\s+|\\s+$", "", str)

parse_attributes <- function(e, content = "__content__", first = FALSE) {
  if (is.null(e)) return(NULL)
  if (is.character(e)) {
    return(e)
  } else if (is.list(e)) {
    e[[content]] %||% NULL
  } else {
    tmp <- lapply(e, function(z) 
      if (inherits(z, "xx")) z[[content]] %||% NULL else z)
    tmp <- unique(unlist(tmp))
    if (first) tmp[[1]] else tmp
  }
}

check_for_package <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

is_file <- function(x) file.exists(x)

is_url <- function(x) {
  grepl("https?://", x, ignore.case = TRUE) || 
    grepl("localhost:[0-9]{4}", x, ignore.case = TRUE)
}

get_doi <- function(x, ...) {
  base <- "https://api.crossref.org"
  path <- file.path("works", x, 
    "transform/application/vnd.citationstyles.csl+json")
  con <- crul::HttpClient$new(
    url = base,
    headers = list(
      `User-Agent` = handlr_ua(),
      `X-USER-AGENT` = handlr_ua()
    ),
    opts = list(...)
  )
  tmp <- con$get(path = path)
  tmp$raise_for_status()
  tmp$parse("UTF-8")
}

handlr_ua <- function() {
  versions <- c(paste0("r-curl/", utils::packageVersion("curl")),
                paste0("crul/", utils::packageVersion("crul")),
                sprintf("rOpenSci(handlr/%s)", 
                        utils::packageVersion("handlr"))
              )
                # get_email())
  paste0(versions, collapse = " ")
}

bind_rows <- function(x) {
  (data.table::setDF(data.table::rbindlist(x, fill = TRUE, use.names = TRUE)))
}

unslugify <- function(x) {
  nmz <- unname(vapply(names(x), function(w) {
    if (w != "archive_location") gsub("_", "-", w) else w
  }, character(1)))
  stats::setNames(x, nmz)
}
