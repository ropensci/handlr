context("bibtex_reader")

test_that("bibtex_reader: works", {
  z <- system.file('extdata/crossref.bib', package = "handlr")
  x <- bibtex_reader(z)

  expect_is(bibtex_reader, "function")
  expect_is(x, "handl")
  expect_named(x)
  expect_is(x$key, "character")
  expect_is(x$id, "character")
  expect_equal(x$type, "article")
  expect_equal(x$bibtex_type, "article")
  expect_equal(x$citeproc_type, "article-journal")
  expect_equal(x$ris_type, "JOUR")
  expect_equal(x$doi, "10.7554/elife.01567")
  expect_is(x$title, "character")
  expect_is(x$author, "list")
  expect_is(x$author[[1]], "list")
  expect_equal(x$author[[1]]$type, "Person")

  expect_equal(attr(x, "from"), "bibtex")
  expect_equal(attr(x, "source_type"), "file")
  expect_match(attr(x, "file"), ".bib")
  expect_false(attr(x, "many"))
})

test_that("bibtex_reader fails well", {
  expect_error(bibtex_reader(), "argument \"x\" is missing")
  expect_error(bibtex_reader(5), "x must be of class character")
})
