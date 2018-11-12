#' handlr client
#'
#' @export
#' @param x (character) a file path
#' @details
#' **Methods**
#'   \describe{
#'     \item{`read(format)`}{
#'       read input
#'       format: one of citeproc, ris, bibtex
#'     }
#'     \item{`write(format, file = NULL)`}{
#'       write
#'       format: one of citeproc, ris, bibtex, rdfxml
#'       file: a file path, if NULL to stdout
#'     }
#'   }
#'
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' # crosscite
#' z <- system.file('extdata/crosscite.json', package = "handlr")
#' (x <- HandlrClient$new(x = z))
#' x$path
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
#' unlink(f)
#' 
#' # read in ris, write out ris
#' z <- system.file('extdata/peerj.ris', package = "handlr")
#' (x <- HandlrClient$new(x = z))
#' x$path
#' x$format
#' x$read("ris")
#' x$parsed
#' x$write("ris")
#' cat(x$write("ris"))
#' 
#' # read in bibtex, write out ris
#' (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#' (x <- HandlrClient$new(x = z))
#' x$path
#' x$format
#' x$read("bibtex")
#' x$parsed
#' x$write("ris")
#' cat(x$write("ris"))
#' 
#' # read in bibtex, write out RDF XML
#' (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#' (x <- HandlrClient$new(x = z))
#' x$path
#' x$format
#' x$read("bibtex")
#' x$parsed
#' x$write("rdfxml")
#' cat(x$write("rdfxml"))
#' 
#' # handle strings instead of files
#' z <- system.file('extdata/citeproc-crossref.json', package = "handlr")
#' (x <- HandlrClient$new(x = readLines(z)))
#' x$read("citeproc")
#' x$parsed
#' cat(x$write("bibtex"), sep = "\n")
#' }
HandlrClient <- R6::R6Class(
  'HandlrClient',
  public = list(
    path = NULL,
    string = NULL,
    substring = NULL,
    parsed = NULL,
    ext = NULL,

    print = function(x, ...) {
      cat("<handlr> ", sep = "\n")
      # cat(paste0("  format: ", self$format), sep = "\n")
      cat(paste0("  ext: ", self$ext), sep = "\n")
      cat(paste0("  path: ", self$path %||% "none"), sep = "\n")
      cat(paste0("  string (abbrev.): ", self$substring %||% "none"), sep = "\n")
      invisible(self)
    },

    initialize = function(x) {
      # if (!missing(x)) self$path <- x
      if (is_file(x)) self$path <- x
      if (!is_file(x)) {
        self$string <- x
        self$substring <- substring(x, 1, 80)
      }
      self$ext <- find_ext(x)
    },

    read = function(format) {
      # if (!is.null(format)) self$format <- format
      self$parsed <- switch(
        format,
        citeproc = citeproc_reader(self$path %||% self$string),
        ris = ris_reader(self$path %||% self$string),
        bibtex = bibtex_reader(self$path %||% self$string),
        stop("format must be one of 'citeproc', 'ris', 'bibtex'")
      )
    },

    write = function(format, file = NULL) {
      out <- switch(
        format,
        citeproc = citeproc_writer(self$parsed),
        ris = ris_writer(self$parsed),
        bibtex = bibtex_writer(self$parsed),
        rdfxml = rdf_xml_writer(self$parsed),
        stop("format must be one of 'citeproc', 'ris', 'bibtex', 'rdfxml'")
      )
      if (is.null(file)) return(out)
      cat(out, "\n", file = file)
    }
  )
)

is_file <- function(x) file.exists(x)

find_ext <- function(x) {
  if (!file.exists(x)) return(NULL)
  tmp <- strsplit(basename(x), "\\.")[[1]]
  tmp[length(tmp)]
}
