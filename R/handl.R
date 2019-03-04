#' handl object
#'
#' @name handl
#' @details
#' A `handl` object is what's returned from the reader functions,
#' and what is passed to the writer functions. The `handl` object is a list,
#' but using the `print.handl` method makes it look something like:
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
#' You can always `unclass()` the object to get the list itself.
#' 
#' The `handl` object follows <https://github.com/datacite/bolognese>, which
#' uses the Crosscite format as its internal representation. Note that we 
#' don't currently supporting writing to or reading from Crosscite.
#'
#' Details on each entry are stored in the named attributes:
#'
#' - from: the data type the citations come from
#' - many: is there more than 1 citation?
#' - count: number of citations
#' - finally, some details of the first 10 are printed
#' 
#' If you have a `handl` object with 1 citation, it is a named list that
#' you can access with normal key indexing. If the result is length > 1,
#' the data is an unnamed list of named lists; the top level 
#' list is unnamed, with each list within it being named.
#' 
#' Each named list should have the following components:
#' 
#' - key: (string) a key for the citation, e.g., in a bibtex file
#' - id: (string) an id for the work being referenced, often a DOI
#' - type: (string) type of work
#' - bibtex_type: (string) bibtex type
#' - citeproc_type: (string) citeproc type
#' - ris_type: (string) ris type
#' - resource_type_general
#' - additional_type: (string) additional type
#' - doi: (string) DOI
#' - b_url: (string) additional URL
#' - title: (string) the title of the work
#' - author: (list) authors, with each author a named list of
#'     - type: type, typically "Person"
#'     - name: full name
#'     - givenName: given (first) name
#'     - familyName: family (last) name
#' - publisher: (string) the publisher name
#' - is_part_of: (list) what the work is published in, or part of, a 
#' named list with:
#'     - type: (string) the type of work
#'     - title: (string) title of the work, often a journal or edited book
#'     - issn: (string) the ISSN
#' - date_published: (string) 
#' - volume: (string) the volume, if applicable
#' - first_page: (string) the first page
#' - last_page: (string) the last page
#' - description: (string) description of the work, often an abstract
#' - license: (string) license of the work, a named list
#' - state: (string) the state of the list
NULL

#' @export
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
