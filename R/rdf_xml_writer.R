#' RDF XML writer
#' 
#' @export
#' @param z a `handlr` internal format object
#' @param ... further params passed to [jsonld::jsonld_to_rdf()]
#' @return RDF XML
#' @family writers
#' @family rdf-xml
#' @examples
#' z <- system.file('extdata/citeproc.json', package = "handlr")
#' (tmp <- citeproc_reader(file = z))
#' 
#' (z <- system.file('extdata/bibtex.bib', package = "handlr"))
#' (tmp <- bibtex_reader(z))
#' rdf_xml_writer(z = tmp)
#' cat(rdf_xml_writer(z = tmp))
rdf_xml_writer <- function(z, ...) {
  res <- schema_org(z, pretty = FALSE)
  jsonld::jsonld_to_rdf(res, ...)
}
