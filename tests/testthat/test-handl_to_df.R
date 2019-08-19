context("handl_to_df")

test_that("handl_to_df: works", {
  skip_on_cran()

  z <- system.file('extdata/crossref.bib', package = "handlr")
  x <- bibtex_reader(z)
  aa <- handl_to_df(x)
  
  expect_is(handl_to_df, "function")
  expect_is(aa, "data.frame")
  expect_named(aa)
  expect_is(aa$key, "character")
  expect_is(aa$id, "character")
  expect_equal(aa$type, "article")
  expect_equal(aa$bibtex_type, "article")
  expect_equal(aa$citeproc_type, "article-journal")
  expect_equal(aa$ris_type, "JOUR")
  expect_equal(aa$doi, "10.7554/elife.01567")
  expect_is(aa$title, "character")
  expect_is(aa$author, "character")
  expect_equal(length(aa$author), 1)
})

test_that("handl_to_df: works with many citations", {
  skip_on_cran()

  z <- system.file('extdata/bib-many.bib', package = "handlr")
  res2 <- bibtex_reader(x = z)
  aa <- handl_to_df(res2)
  
  expect_is(aa, "data.frame")
  expect_named(aa)
  expect_is(aa$key, "character")
  expect_is(aa$id, "character")
  expect_equal(NROW(aa), 2)
})

test_that("handl_to_df: works with HandlrClient", {
  skip_on_cran()
  
  z <- system.file('extdata/bib-many.bib', package = "handlr")
  x <- HandlrClient$new(x = z)
  
  # before reading, as_df gives empty data.frame
  expect_equal(NROW(x$as_df()), 1)
  expect_true(all(x$as_df() == ""))
  
  # read
  x$read()
  
  # as_df again
  aa <- x$as_df()
  
  expect_is(aa, "data.frame")
  expect_named(aa)
  expect_is(aa$key, "character")
  expect_is(aa$id, "character")
  expect_equal(NROW(aa), 2)
})

test_that("handl_to_df: fails well", {
  expect_error(handl_to_df(), "argument \"x\" is missing")
  expect_error(handl_to_df(5), "x must be of class handl")
})
