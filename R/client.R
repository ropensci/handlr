handlr_readers <- c('citeproc', 'ris', 'bibtex', 'codemeta', 'cff')
handlr_writers <- c('citeproc', 'ris', 'bibtex', 'schema_org',
  'rdfxml', 'codemeta', 'cff')

#' @title HandlrClient
#' @description handlr client, read and write to and from all citation formats 
#'
#' @export
#' @details The various inputs to the `x` parameter are handled in different
#' ways:
#'
#' - file: contents read from file, we grab file extension, and we guess
#' format based on combination of contents and file extension because
#' file extensions may belie what's in the file
#' - string: string read in, and we guess format based on contents of
#' the string
#' - DOI: we request citeproc-json format from the Crossref API
#' - DOI url: we request citeproc-json format from the Crossref API
#'
#' @examples
#' # read() can be run with format specified or not
#' # if format not given, we attempt to guess the format and then read
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' (x <- HandlrClient$new(x = z))
#' x$read()
#' x$read("citeproc")
#' x$parsed
#'
#' # you can run read() then write()
#' # or just run write(), and read() will be run for you if possible
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' (x <- HandlrClient$new(x = z))
#' cat(x$write("ris"))
#'
#' # read from a DOI as a url
#' if (interactive()) {
#'   (x <- HandlrClient$new('https://doi.org/10.7554/elife.01567'))
#'   x$parsed
#'   x$read()
#'   x$parsed
#'   x$write('bibtex')
#' }
#'
#' # read from a DOI
#' if (interactive()) {
#'   (x <- HandlrClient$new('10.7554/elife.01567'))
#'   x$parsed
#'   x$read()
#'   x$write('bibtex')
#' }
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
#' x$format_guessed
#' x$read("ris")
#' x$parsed
#' x$write("ris")
#' cat(x$write("ris"))
#'
#' # read in bibtex, write out ris
#' (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#' (x <- HandlrClient$new(x = z))
#' x$path
#' x$format_guessed
#' if (requireNamespace("bibtex", quietly = TRUE)) {
#' x$read("bibtex")
#' x$parsed
#' x$write("ris")
#' cat(x$write("ris"))
#' }
#'
#' # read in bibtex, write out RDF XML
#' if (requireNamespace("bibtex", quietly = TRUE) && interactive()) {
#'   (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#'   (x <- HandlrClient$new(x = z))
#'   x$path
#'   x$format_guessed
#'   x$read("bibtex")
#'   x$parsed
#'   x$write("rdfxml")
#'   cat(x$write("rdfxml"))
#' }
#'
#' # codemeta
#' (z <- system.file('extdata/codemeta.json', package = "handlr"))
#' (x <- HandlrClient$new(x = z))
#' x$path
#' x$format_guessed
#' x$read("codemeta")
#' x$parsed
#' x$write("codemeta")
#' 
#' # cff: Citation File Format
#' (z <- system.file('extdata/citation.cff', package = "handlr"))
#' (x <- HandlrClient$new(x = z))
#' x$path
#' x$format_guessed
#' x$read("cff")
#' x$parsed
#' x$write("codemeta")
#'
#' # > 1 citation
#' z <- system.file('extdata/citeproc-many.json', package = "handlr")
#' (x <- HandlrClient$new(x = z))
#' x$parsed
#' x$read()
#' x$parsed
#' ## schmea org
#' x$write("schema_org")
#' ## bibtex
#' x$write("bibtex")
#' ## bibtex to file
#' f <- tempfile(fileext=".bib")
#' x$write("bibtex", f)
#' readLines(f)
#' unlink(f)
#' ## to RIS
#' x$write("ris")
#' ### only one per file, so not combined
#' files <- replicate(2, tempfile(fileext=".ris"))
#' x$write("ris", files)
#' lapply(files, readLines)
#'
#' # handle strings instead of files
#' z <- system.file('extdata/citeproc-crossref.json', package = "handlr")
#' (x <- HandlrClient$new(x = readLines(z)))
#' x$read("citeproc")
#' x$parsed
#' cat(x$write("bibtex"), sep = "\n")
HandlrClient <- R6::R6Class(
  'HandlrClient',
  public = list(
    #' @field path (character) non-empty if file path passed to initialize
    path = NULL,
    #' @field string (character) non-empty if string (non-file) passed to initialize
    string = NULL,
    #' @field parsed after `read()` is run, the parsed content
    parsed = NULL,
    #' @field file (logical) `TRUE` if a file passed to initialize, else `FALSE`
    file = FALSE,
    #' @field ext (character) the file extension
    ext = NULL,
    #' @field format_guessed (character) the guessed file format
    format_guessed = NULL,
    #' @field doi (character) the DOI, if any found
    doi = NULL,

    #' @description print method for `HandlrClient` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<handlr> ", sep = "\n")
      cat(paste0("  doi: ", self$doi), sep = "\n")
      cat(paste0("  ext: ", self$ext), sep = "\n")
      cat(paste0("  format (guessed): ", self$format_guessed), sep = "\n")
      cat(paste0("  path: ", self$path %||% "none"), sep = "\n")
      cat(paste0("  string (abbrev.): ", private$substring %||% "none"),
        sep = "\n")
      invisible(self)
    },

    #' @description Create a new `HandlrClient` object
    #' @param x (character) a file path (the file must exist), a string
    #' containing contents of the citation, a DOI, or a DOI as a URL.
    #' See Details.
    #' @param format (character) one of citeproc, ris, bibtex, codemeta, cff,
    #' or `NULL`. If `NULL`, we attempt to guess the format, and error if we
    #' can not guess
    #' @param ... curl options passed on to [crul::verb-GET]
    #' @return A new `HandlrClient` object
    initialize = function(x, format = NULL, ...) {
      assert(x, "character")
      if (is_url_doi(x) || is_doi(x)) {
        self$doi <- urltools::url_decode(doi_from_url(normalize_doi(x)))
        x <- get_doi(self$doi, ...)
      }
      if (is_file(x)) {
        self$file <- TRUE
        self$path <- x
      }
      if (!is_file(x)) {
        if (!nzchar(x)) stop("input is zero length string")
        self$string <- x
        private$substring <- substring(x, 1, 80)
      }
      self$ext <- private$find_ext(x)
      self$format_guessed <- if (!is.null(format)) {
        mssg <- sprintf("'format' not in allowed set: %s",
          paste(handlr_readers, collapse=","))
        stopifnot(exprs = stats::setNames(format %in% handlr_readers, mssg))
        format
      }
      else 
        private$guess_format(x)
    },

    #' @description read input
    #' @param format (character) one of citeproc, ris, bibtex, codemeta, cff,
    #' or `NULL`. If `NULL`, we attempt to guess the format, and error if we
    #' can not guess
    #' @param ... further args to the writer fxn, if any
    read = function(format = NULL, ...) {
      if (is.null(format)) format <- self$format_guessed
      self$parsed <- switch(
        format,
        citeproc = citeproc_reader(self$path %||% self$string, ...),
        ris = ris_reader(self$path %||% self$string, ...),
        bibtex = bibtex_reader(self$path %||% self$string, ...),
        codemeta = codemeta_reader(self$path %||% self$string, ...),
        cff = cff_reader(self$path %||% self$string, ...),
        stop("format must be one of ",
          paste(handlr_readers, collapse = ", "))
      )
    },

    #' @description write to std out or file
    #' @param format (character) one of citeproc, ris, bibtex, schema_org,
    #' rdfxml, codemeta, or cff
    #' @param file a file path, if NULL to stdout. for `format=ris`,
    #' number of files must equal number of ris citations
    #' @param ... further args to the writer fxn, if any
    #' @note If `$parsed` is `NULL` then it's likely `$read()` has not
    #' been run - in which case we attempt to run `$read()` to
    #' populate `$parsed`
    write = function(format, file = NULL, ...) {
      if (is.null(self$parsed)) self$read()
      out <- switch(
        format,
        citeproc = citeproc_writer(self$parsed, ...),
        ris = ris_writer(self$parsed, ...),
        bibtex = bibtex_writer(self$parsed, ...),
        schema_org = schema_org_writer(self$parsed, ...),
        rdfxml = rdf_xml_writer(self$parsed, ...),
        codemeta = codemeta_writer(self$parsed, ...),
        cff = cff_writer(self$parsed, ...),
        stop("format must be one of ",
          paste(handlr_writers, collapse = ", "))
      )
      if (is.null(file)) return(out)
      assert(out, c("list", "character", "json"))
      if (!inherits(out, "list") && length(out) == 1) {
        cat(out, "\n", file = file)
      }
      if (inherits(out, c("list", "character"))) {
        if (format == "ris") {
          if (length(out) != length(file)) {
            stop("ris format: number of files to 'file' == no. citations")
          }
        }
        for (i in seq_along(out)) {
          cat(out[[i]], sep = "\n", file = file[i] %||% file, append = TRUE)
        }
      }
    },

    #' @description convert data to a data.frame using [handl_to_df()]
    #' @return a data.frame
    as_df = function() {
      handl_to_df(self$parsed %||% handl_empty())
    }
  ),

  private = list(
    substring = NULL,
    find_ext = function(x) {
      if (!file.exists(x)) return(NULL)
      tmp <- strsplit(basename(x), "\\.")[[1]]
      tmp[length(tmp)]
    },

    guess_format = function(x) {
      reader_funs <- paste0(
        grep("bibtex", handlr_readers, invert = TRUE, value = TRUE), "_reader")
      reader_funs <- c(reader_funs, "bibtex_checker")
      read_attempts <- vapply(reader_funs, function(fun) {
        tmp <- tryCatch(suppressWarnings(eval(parse(text = fun))(x)),
          error = function(e) e)
        !inherits(tmp, "error")
      }, logical(1L))
      if (!any(read_attempts) || length(which(read_attempts)) > 1) {
        if (length(which(read_attempts)) > 1) {
          if (json_val(x)) {
            # json types
            type <- "citeproc"
            if (
              any(grepl("@context", if (file.exists(x)) readLines(x) else x))
            ) type <- "codemeta"
            return(type)
          } else {
            # check for bibtex type
            if (
              "bibtex_checker" %in% names(which(read_attempts))
              # && self$ext == "bib"
            ) {
              return("bibtex")
            } else {
              # decide between ris and cff
              fmt <- if (!is.null(cff_reader(x)$cff_version)) "cff" else "ris"
              return(fmt)
            }
          }
        }
        stop("could not guess format for string; specify format")
      } else {
        handlr_names <- unname(
          vapply(reader_funs, function(z) strsplit(z, "_")[[1]][1], ""))
        return(handlr_names[read_attempts])
      }
    }
  )
)

json_val <- function(x) {
  b <- tryCatch(jsonlite::fromJSON(x), error = function(e) e)
  !inherits(b, "error")
}

bibtex_checker <- function(x) {
  if (!mime::guess_type(x) == "text/x-bibtex") stop("not bibtex")
}
