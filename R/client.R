#' handlr client
#'
#' @export
#' @details
#' **Methods**
#'   \describe{
#'     \item{`parse()`}{
#'       parse input
#'     }
#'   }
#'
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' # crosscite
#' z <- system.file('extdata/crosscite.json', package = "handlr")
#' (x <- HandlrClient$new(x = z, from ="crosscite"))
#' x$x
#' x$proc
#' 
#' # read in citeproc, write out bibtex
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' (x <- HandlrClient$new(x = z, from ="citeproc"))
#' x$path
#' x$read()
#' x$write("bibtex")
#' }
HandlrClient <- R6::R6Class(
  'HandlrClient',
  public = list(
    path = NULL,
    parsed = NULL,

    print = function(x, ...) {
      cat("<handlr> ", sep = "\n")
      cat(paste0("  path: ", self$path), sep = "\n")
      invisible(self)
    },

    initialize = function(x, from = NULL) {
      if (!missing(x))self$path <- x
    },

    read = function() {
      self$parsed <- citeproc_reader(self$path)
      return(self$parsed)
    },

    write = function(format) {
      switch(
        format,
        bibtex = bibtex_writer(self$parsed)
      )
    }
  )
)
