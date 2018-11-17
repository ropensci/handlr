#' **Citation format converter**
#' 
#' A tool for converting among citation formats
#' 
#' @section supported readers:
#' 
#' - citeproc
#' - ris
#' - bibtex
#' 
#' @section supported writers:
#' 
#' - citeproc
#' - ris
#' - bibtex
#' - schema.org
#' - rdfxml (requires suggested package `jsonld`)
#'
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom xml2 read_xml
#' @importFrom RefManageR ReadBib
#' @importFrom urltools url_encode url_parse
#' @name handlr-package
#' @aliases handlr
#' @author Scott Chamberlain \email{sckott@@protonmail.com}
#' @docType package
NULL
