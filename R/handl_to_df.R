#' handl to data.frame conversion
#' 
#' @export
#' @param x an object of class handl
#' @return data.frame with column following [handl], with as many rows
#' as there are citations
#' @note requires the Suggested package `data.table`
#' @examples 
#' z <- system.file('extdata/crossref.ris', package = "handlr")
#' res <- ris_reader(z)
#' handl_to_df(res)
#' 
#' (x <- HandlrClient$new(x = z))
#' x$as_df() # empty data.frame
#' x$read()
#' x$as_df() # data.frame with citation data
#' 
#' (z <- system.file('extdata/bib-many.bib', package = "handlr"))
#' res2 <- bibtex_reader(x = z)
#' handl_to_df(res2)
handl_to_df <- function(x) {
  # data.table not used unitl bind_rows(); using here to fail early
  check_for_package("data.table")
  assert(x, "handl")
  many <- attr(x, "many")
  stopifnot(!is.null(many))
  x <- unclass(x)
  if (!many) x <- list(x)
  parsed <- lapply(x, function(w) {
    out <- list()
    for (i in seq_along(w)) {
      tmp <- convert_each(piece = w[[i]], nm = names(w)[i])
      out[[ names(tmp) ]] <- tmp[[1]]
    }
    out
  })
  bind_rows(parsed)
}

# helpers
handl_empty <- function() {
  lst_nms <- c("id", "type", "citeproc_type", "ris_type",
    "resource_type_general","doi", "b_url", "title", "author", "publisher",
    "journal","is_part_of", "date_created", "date_published", "date_accessed",
    "description", "volume", "issue", "first_page", "last_page",
    "keywords", "language", "state")
  lst <- vector("list", length(lst_nms))
  lst <- lapply(lst, function(z) z <- "")
  structure(stats::setNames(lst, lst_nms),
            class = "handl", from = "", 
            source_type = "", file = "", many = FALSE)
}

# make author name: Last, F.
make_name <- function(m) {
  paste(m$familyName, paste0(substring(m$givenName, 1, 1), "."))
}

# set list name
sln <- function(val, name) {
  stats::setNames(list(val), name)
}

convert_each <- function(piece, nm) {
  if (is.null(piece)) return(sln(NA_character_, nm))
  if (inherits(piece, "character") && length(piece) == 1) return(sln(piece, nm))
  if (inherits(piece, "character") && length(piece) > 1) {
    return(sln(paste(piece, collapse = ","), nm))
  }
  if (inherits(piece, "list")) {
    if (nm == "author") {
      sln(paste0(lapply(piece, make_name), collapse = ", "), nm)
    } else if (nm == "is_part_of") {
      sln(paste0(unlist(unname(piece)), collapse = ";"), nm)
    } else {
      sln(piece[[1]], paste(nm, names(piece), sep = "_", collapse = ""))
    }
  }
}
