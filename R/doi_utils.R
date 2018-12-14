doi_url_pattern <- "\\b((http|https):\\/\\/(dx.)?(doi.org)?\\/10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?![\"&\'<>])\\S)+)\\b"
doi_pattern <- "\\b(10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?![\"&\'<>])\\S)+)\\b"
doi_prefix_pattern <- "\\b(10[.][0-9]{4,5})\\b"
doi_resolver <- "https://doi.org"

# validate_doi: should extract DOI if it's in a URL
# validate_doi(doi = "10.1371/journal.pone.0025995") # valid
# validate_doi(doi = "10/journal.pone.0025995") # invalid
# validate_doi(doi = "http://dx.doi.org/10.5063/F1M61H5X") # valid url
# validate_doi(doi = "http://dx.doi.org/30.5063/F1M61H5X") # invalid url
validate_doi <- function(doi) {
  # doi <- grep(doi_pattern, doi, perl = TRUE, value = TRUE)
  doi <- regmatches(doi, regexpr(doi_pattern, doi, perl=TRUE))
  if (length(doi) > 0) tolower(sub("\u200B|doi:", "", doi)) else NULL
}

is_url_doi <- function(x) {
  grepl(doi_url_pattern, urltools::url_decode(x), perl = TRUE)
}
is_doi <- function(doi) {
  grepl(doi_pattern, doi, perl = TRUE)
}

# validate_prefix(doi = "10.1371/journal.pone.0025995")
# validate_prefix(doi = "10/journal.pone.0025995")
validate_prefix <- function(doi) {
  strextract(doi, doi_prefix_pattern)
}

# def doi_search(doi, options = {})
#   sandbox = Array(/handle.test.datacite.org/.match(doi)).last
#   sandbox.present? || options[:sandbox] ? "https://search.test.datacite.org/api" : "https://search.datacite.org/api"
# end

# normalize_doi("10.1371/journal.pone.0025995")
normalize_doi <- function(doi) {
  doi_str <- validate_doi(doi)
  if (is.null(doi_str)) return(NULL)
  file.path(doi_resolver, urltools::url_encode(doi_str))
}

# is_url_doi("http://doi.org/10.1371/journal.pone.0025995")
# doi_from_url(url = "http://doi.org/10.1371/journal.pone.0025995")
doi_from_url <- function(url) {
  if (is_url_doi(url)) {
    df <- urltools::url_parse(url)
    tolower(df$path)
  }
}

# doi_as_url("10.1371/journal.pone.0025995")
doi_as_url <- function(doi) {  
  if (!is.null(doi)) file.path(doi_resolver, doi) else NULL
}

# get DOI registration agency
# def get_doi_ra(doi)
#   prefix = validate_prefix(doi)
#   return nil if prefix.blank?
#
#   url = "https://app.datacite.org/prefixes/#{prefix}"
#   result = Maremma.get(url)
#
#   result.body.fetch("data", {}).fetch('attributes', {}).fetch('registration-agency', nil)
# end

normalize_id <- function(id = NULL) {
  if (is.null(id)) return(NULL)

  # check for valid DOI
  doi <- normalize_doi(id)
  if (!is.null(doi)) return(doi)

  # check for valid HTTP uri
  uri <- urltools::url_parse(id)
  if (is.null(uri$domain) && !any(c("http", "https") %in% uri$scheme)) {
    return(NULL)
  }

  # clean up URL
  # FIXME - clean the url
  res <- tryCatch(urltools::url_encode(id), error = function(e) e)
  if (inherits(res, "error")) stop("invalid URL") else res
  # PostRank::URI.clean(id)
  #   rescue Addressable::URI::InvalidURIError
}
