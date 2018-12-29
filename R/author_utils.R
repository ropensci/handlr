# get_one_author <- function(author) {
#   if (is.null(author$creatorName)) {
#     # malformed XML
#     return(NULL)
#   } else if (!is.null(author$type)) {
#     type <- author$type
#   } else if (author$creatorName) { # fixme
#     z <- author["creatorName"]["nameType"]
#     type <- if (z == "Organizational") "Organization" else "Person"
#   } else
#     type <- NULL
#   }

#   name_identifiers = get_name_identifiers(author)
#   id = author.fetch("id", nil).presence || name_identifiers.first
#   identifier = name_identifiers.length > 1 ? name_identifiers.unwrap : nil
#   name = parse_attributes(author.fetch("creatorName", nil)) ||
#          parse_attributes(author.fetch("contributorName", nil)) ||
#          author.fetch("name", nil)

#   given_name = parse_attributes(author.fetch("givenName", nil))
#   family_name = parse_attributes(author.fetch("familyName", nil))
#   name = cleanup_author(name)
#   name = [family_name, given_name].join(", ") if name.blank? && family_name.present?

#   author = { "type" => type || "Person",
#              "id" => id,
#              "name" => name,
#              "givenName" => given_name,
#              "familyName" => family_name,
#              "identifier" => identifier }.compact

#   return author if family_name.present?

#   if is_personal_name?(author)
#     names = Namae.parse(name)
#     parsed_name = names.first

#     if parsed_name.present?
#       given_name = parsed_name.given
#       family_name = parsed_name.family
#       name = [given_name, family_name].join(" ")
#     else
#       given_name = nil
#       family_name = nil
#     end

#     { "type" => "Person",
#       "id" => id,
#       "name" => name,
#       "givenName" => given_name,
#       "familyName" => family_name,
#       "identifier" => identifier }.compact
#   else
#     { "type" => type, "name" => name }.compact
#   end
# }

# cleanup_author <- function(author) {
#   return nil unless author.present?

#   # detect pattern "Smith J.", but not "Smith, John K."
#   author = author.gsub(/[[:space:]]([A-Z]\.)?(-?[A-Z]\.)$/, ', \1\2') unless author.include?(",")

#   # remove spaces around hyphens
#   author = author.gsub(" - ", "-")

#   # titleize strings
#   # remove non-standard space characters
#   author.my_titleize.gsub(/[[:space:]]/, ' ')
# }

# is_personal_name <- function(author) {
#   return FALSE if author.fetch("type", "").downcase == "organization"
#   return TRUE if author.fetch("id", "").start_with?("https://orcid.org") ||
#                  author.fetch("familyName", "").present? ||
#                  (author.fetch("name", "").include?(",") &&
#                  author.fetch("name", "").exclude?(";")) ||
#                  name_exists?(author.fetch("name", "").split(" ").first)
#   return(FALSE)
# }

# get_name_identifiers <- function(author) {
#   name_identifiers = Array.wrap(author.fetch("nameIdentifier", nil)).reduce([]) do |sum, n|
#     n = { "__content__" => n } if n.is_a?(String)

#     scheme = n.fetch("nameIdentifierScheme", nil)
#     scheme_uri = n.fetch("schemeURI", nil) || IDENTIFIER_SCHEME_URIS.fetch(scheme, "https://orcid.org")
#     scheme_uri = "https://orcid.org/" if validate_orcid_scheme(scheme_uri)
#     scheme_uri << '/' unless scheme_uri.present? && scheme_uri.end_with?('/')

#     identifier = n.fetch("__content__", nil)
#     if scheme_uri == "https://orcid.org/"
#       identifier = validate_orcid(identifier)
#     else
#       identifier = identifier.gsub(" ", "-")
#     end

#     if identifier.present? && scheme_uri.present?
#       sum << scheme_uri + identifier
#     else
#       sum
#     end
#   end

#   # return array of name identifiers, ORCID ID is first element if multiple
#   name_identifiers.select { |n| n.start_with?("https://orcid.org") } +
#   name_identifiers.reject { |n| n.start_with?("https://orcid.org") }
# }

# NOT SURE WHAT THIS IS DOING
# name_exists <- function(name) {
#   return false unless name_detector.present?
#   name_detector.name_exists?(name)
# }

# get_authors <- function(authors) Map(get_one_author, authors)

authors_as_string <- function(authors) {
  tmp <- lapply(authors, function(z) {
    if (!is.null(z$familyName)) {
      paste(z$givenName, z$familyName)
    } else if (!is.null(z$`@type`)) {
      z$name
    } else if (!is.null(z$name)) {
      paste0("{", z$name, "}")
    } else {
      NULL
    }
  })
  paste0(tmp, collapse = " and ")
}
