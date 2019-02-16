#' **Citation format converter**
#' 
#' A tool for converting among citation formats
#' 
#' @section supported readers:
#' 
#' - citeproc
#' - ris
#' - bibtex
#' - codemeta 
#' 
#' @section supported writers:
#' 
#' - citeproc
#' - ris
#' - bibtex
#' - schema.org
#' - rdfxml (requires suggested package `jsonld`)
#' - codemeta
#' 
#' @section links for citation formats:
#' 
#' - citeproc: <https://en.wikipedia.org/wiki/CiteProc>
#' - codemeta: <https://codemeta.github.io/>
#' - ris: <https://en.wikipedia.org/wiki/RIS_(file_format)>
#' - bibtex: <http://www.bibtex.org/>
#' - schema.org: <https://schema.org/>
#' - rdfxml: <https://en.wikipedia.org/wiki/RDF/XML>
#'
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom xml2 read_xml
#' @importFrom RefManageR ReadBib
#' @importFrom urltools url_encode url_parse
#' @importFrom crul HttpClient
#' @importFrom mime guess_type
#' @name handlr-package
#' @aliases handlr
#' @author Scott Chamberlain \email{sckott@@protonmail.com}
#' @docType package
NULL
