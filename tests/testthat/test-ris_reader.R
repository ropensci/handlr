context("ris_reader")

test_that("ris_reader: works", {
  skip_on_cran()

  z <- system.file("extdata/crossref.ris", package = "handlr")
  x <- ris_reader(z)

  expect_is(ris_reader, "function")
  expect_is(x, "handl")
  expect_named(x)
  expect_is(x$id, "character")
  expect_equal(x$type, "ScholarlyArticle")
  expect_null(x$bibtex_type)
  expect_equal(x$citeproc_type, "misc")
  expect_equal(x$ris_type, "JOUR")
  expect_equal(x$doi, "10.7554/elife.01567")
  expect_is(x$title, "character")
  expect_is(x$author, "list")
  expect_is(x$author[[1]], "list")
  expect_is(x$author[[1]]$name, "character")

  expect_equal(attr(x, "from"), "ris")
  expect_equal(attr(x, "source_type"), "file")
  expect_match(attr(x, "file"), ".ris")
  expect_false(attr(x, "many"))
})

test_that("ris_reader: many inputs", {
  skip_on_cran()
  
  z <- system.file("extdata/multiple-eg.ris", package = "handlr")
  x <- ris_reader(z)

  expect_is(ris_reader, "function")
  expect_is(x, "handl")
  expect_named(x, NULL)

  expect_equal(attr(x, "from"), "ris")
  expect_equal(attr(x, "source_type"), "file")
  expect_match(attr(x, "file"), ".ris")
  expect_true(attr(x, "many"))
})

test_that("ris_reader fails well", {
  expect_error(ris_reader(), "argument \"x\" is missing")
  expect_error(ris_reader(5), "x must be of class character")
})
