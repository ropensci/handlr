#' handl object
#'
#' @name handl
#' @details
#' a handl object is what's returned from the reader functions,
#' and looks something like:
#'
#' ```
#' <handl>
#'   from: codemeta
#'   many: TRUE
#'   count: 2
#'   first 10
#'     id/doi: https://doi.org/10.5063%2ff1m61h5x
#'     id/doi: https://doi.org/10.5063%2ff1m61h5x
#' ```
#'
#' Details on each entry:
#'
#' - from: the data type the citations come from
#' - many: is there more than 1 citation?
#' - count: number of citations
#' - finally, some details of the first 10 are printed
NULL


print.handl <- function(x, ...) {
  many <- attr(x, "many")
  cat("<handl> ", sep = "\n")
  cat(paste0("  from: ", attr(x, "from")), sep = "\n")
  cat(paste0("  many: ", many), sep = "\n")
  cat(paste0("  count: ", if (many) length(x) else 1), sep = "\n")
  if (!is.null(names(x))) x <- list(x)
  cat("  first 10 ", sep = "\n")
  for (i in seq_along_n(x, 10)) {
    cat(paste0("    id/doi: ", x[[i]]$id %||% x[[i]]$doi), sep = "\n")
  }
}

# x: a vector
# seq_along_n(1:10, 5)
# seq_along_n(1:3, 5)
# seq_along_n(1:3, 2)
seq_along_n <- function(x, n) {
  n <- min(length(x), n)
  seq_along(x[1:n])
}
