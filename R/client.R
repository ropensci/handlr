#' handlr client
#'
#' @export
#' @details
#' **Methods**
#'   \describe{
#'     \item{`read(format = NULL)`}{
#'       read input
#'       format: optionally specify format, e.g., ris. We attempt to 
#'       auto-detect this for you.
#'     }
#'   }
#'
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' # crosscite
#' z <- system.file('extdata/crosscite.json', package = "handlr")
#' (x <- HandlrClient$new(x = z))
#' x$x
#' x$proc
#' 
#' # read in citeproc, write out bibtex
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' (x <- HandlrClient$new(x = z))
#' x$path
#' x$ext
#' x$read("citeproc")
#' x$parsed
#' x$write("bibtex")
#' f <- tempfile(fileext = ".bib")
#' x$write("bibtex", file = f)
#' readLines(f)
#' 
#' # read in ris, write out ris
#' z <- system.file('extdata/peerj.ris', package = "handlr")
#' (x <- HandlrClient$new(x = z))
#' x$path
#' x$format
#' x$read()
#' x$parsed
#' x$write("ris")
#' cat(x$write("ris"))
#' }
HandlrClient <- R6::R6Class(
  'HandlrClient',
  public = list(
    path = NULL,
    parsed = NULL,
    ext = NULL,

    print = function(x, ...) {
      cat("<handlr> ", sep = "\n")
      # cat(paste0("  format: ", self$format), sep = "\n")
      cat(paste0("  ext: ", self$ext), sep = "\n")
      cat(paste0("  path: ", self$path), sep = "\n")
      invisible(self)
    },

    initialize = function(x) {
      # if (!missing(x)) self$path <- x
      self$path <- x
      self$ext <- find_ext(x)
    },

    read = function(format = NULL) {
      # if (!is.null(format)) self$format <- format
      self$parsed <- switch(
        format,
        citeproc = citeproc_reader(self$path),
        ris = ris_reader(self$path),
        stop("format must be one of 'citeproc' or 'ris'")
      )
      return(self$parsed)
    },

    write = function(format = NULL, file = NULL) {
      out <- switch(
        format,
        bibtex = bibtex_writer(self$parsed),
        ris = ris_writer(self$parsed),
        stop("format must be one of 'bibtex' or 'ris'")
      )
      if (is.null(file)) return(out)
      cat(out, "\n", file = file)
    }
  )
)

find_ext <- function(x) {
  tmp <- strsplit(basename(x), "\\.")[[1]]
  tmp[length(tmp)]
}
