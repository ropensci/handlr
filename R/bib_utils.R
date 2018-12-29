# from RefManageR
convert_to_bibtex <- function(object) {
  object <- unclass(object)
  bibtype <- tolower(object$bibtype)
  obj_names <- names(object)
  if ("author" %in% obj_names) {
    object$author <- authors_as_string(object$author)
  }
  if ("editor" %in% obj_names) {
    object$editor <- authors_as_string(object$author)
  }
  
  if (bibtype == "article" && 'journaltitle' %in% obj_names  &&
      is.null(object$journal))
    object$journal <- object$journaltitle
  
  if ("location" %in% obj_names  && is.null(object$address))
    object$address <- object$location

  # object <- ConvertDate(object)
  
  if ("institution" %in% obj_names && bibtype == 'thesis' &&
      is.null(object$school)){
    object$school <- object$institution
    object$institution <- NULL 
  }
  if ("eprinttype" %in% obj_names && is.null(object$archiveprefix))
    object$archiveprefix <- object$eprinttype
  if ("eprintclass" %in% obj_names && is.null(object$primaryclass))
    object$primaryclass <- object$eprintclass
  if ("sortkey" %in% obj_names && !"key" %in% obj_names)
    object$key <- object$sortkey
  if ("maintitle" %in% obj_names && !"series" %in% obj_names)
    object$series <- object$maintitle
  if ("issuetitle" %in% obj_names && !"booktitle" %in% obj_names)
    object$booktitle <- object$issuetitle
  if ("eventtitle" %in% obj_names && !"booktitle" %in% obj_names)
    object$booktitle <- object$eventtitle
  
  if (bibtype == "thesis" && length(object$type)){
    bibtype <- switch(object$type, mathesis = { 
      object$type <- NULL
      "mastersthesis" 
    }, phdthesis = { 
      object$type  <- NULL
      "phdthesis"
    }, "phdthesis")
  }

  bibtype <- ConvertBibtype(bibtype)
  
  rval <- paste0("@", bibtype, "{", object$key, ",")
  # drop key
  object$key <- NULL
  rval <- c(rval, vapply(names(object)[names(object) %in% .Bibtex_fields],
                         function(n) paste0("  ", n, " = {", object[[n]],
                                            "},"), ""), "}", "")
  return(unname(rval))
}

# from RefManageR
ConvertBibtype <- function(bibtype){
  types <- tolower(names(BibTeX_entry_field_db))
  if (length(pos <- which(types %in% bibtype))) {
    types[pos]
  } else {
    switch(bibtype, "mvbook" = "Book", "bookinbook" = "InBook",
                  "suppbook" = "InBook", "collection" = "Book",
                  "mvcollection" = "Book",
                  "suppcollection" = "InCollection",
                  "reference" = "Book", "mvreference" = "Book",
                  "inreference" = "InBook", "report" = "TechReport",
                  "proceedings" = "Book", "mvproceedings" = "Book",
                  "periodical" = "Book", "suppperiodical" = "InBook",
                  "patent" = "TechReport", "Misc")
  }
}

# from utils:::toBibtex, good for matching by given name initials only
format_author <- function(author) paste(vapply(author, function(p) {
  fnms <- p$familyName
  only_given_or_family <- is.null(fnms) || is.null(p$givenName)
  fbrc <- if (length(fnms) > 1L || any(grepl("[[:space:]]",
                                             fnms, useBytes = TRUE)) ||
              only_given_or_family)
    c("{", "}")
  else ""
  gbrc <- if (only_given_or_family)
    c("{", "}")
  else ""
  format(p, 
    include = c("givenName", "familyName"), 
    braces = list(givenName = gbrc, familyName = fbrc))
}, ""), collapse = " and ")

BibTeX_entry_field_db <- list(
  Article = c("author", "title", "journal", "year"),
  Book = c("author|editor", "title", "publisher", "year"),
  Booklet = "title",
  InBook = c("author|editor", "title", "chapter|pages", "publisher",  "year"),
  InCollection = c("author", "title", "booktitle", "publisher", "year"),
  InProceedings = c("author", "title", "booktitle", "year"),
  Manual = "title",
  MastersThesis = c("author", "title", "school", "year"),
  Misc = character(0),
  PhdThesis = c("author", "title",  "school", "year"),
  Proceedings =  c("title", "year"),
  TechReport = c("author", "title", "institution", "year"),
  Unpublished = c("author", "title",  "note")
)

.Bibtex_fields <- c("address", "author", "annote", "booktitle", "chapter",
                    "crossref", "edition", "editor", "eprint", "year",
                    "howpublished", "institution", "journal", "month", "key",
                    "note", "primaryclass", "archiveprefix", "doi",
                    "number", "organization", "pages", "publisher", "school",
                    "series", "title", "type", "url", "volume")
