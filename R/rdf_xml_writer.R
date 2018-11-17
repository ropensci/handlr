#' RDF XML writer
#' 
#' @export
#' @param z a `handlr` internal format object
#' @param ... further params passed to [jsonld::jsonld_to_rdf()]
#' @details package `jsonld` required for this writer
#' @return RDF XML
#' @family writers
#' @family rdf-xml
#' @examples
#' if (requireNamespace("jsonld")) {
#'   library("jsonld")
#'   z <- system.file('extdata/citeproc.json', package = "handlr")
#'   (tmp <- citeproc_reader(file = z))
#' 
#'   (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#'   (tmp <- bibtex_reader(z))
#'   rdf_xml_writer(z = tmp)
#'   cat(rdf_xml_writer(z = tmp))
#' }
rdf_xml_writer <- function(z, ...) {
  check_for_package("jsonld")
  res <- schema_org_writer(z, pretty = FALSE)
  jsonld::jsonld_to_rdf(res, ...)
}
