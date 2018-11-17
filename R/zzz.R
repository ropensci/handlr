`%||%` <- function(x, y) if (is.null(x)) y else x

ccp <- function(x) Filter(Negate(is.null), x)

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!class(x) %in% y) {
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
    tmp <- lapply(e, function(z) if (inherits(z, "xx")) z[[content]] %||% NULL else z)
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
