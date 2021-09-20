context("HandlrClient")

skip_on_cran()

test_that("HandlrClient class: after initializing, but before reading", {
  expect_is(HandlrClient, "R6ClassGenerator")
  expect_is(HandlrClient$new, "function")

  z <- system.file('extdata/citeproc.json', package = "handlr")
  x <- HandlrClient$new(x = z)

  expect_is(x, "HandlrClient")
  expect_is(x$path, "character")
  expect_null(x$string)
  expect_null(x$substring)
  expect_is(x$ext, "character")
  expect_equal(x$ext, "json")
  expect_null(x$parsed)
  expect_is(x$write, "function")
  expect_is(x$read, "function")
})

test_that("HandlrClient class: after initializing and reading", {
  z <- system.file('extdata/citeproc.json', package = "handlr")
  x <- HandlrClient$new(x = z)

  expect_is(x$read("citeproc"), "handl")
  expect_is(x$parsed, "handl")
})

test_that("HandlrClient class: writing", {
  z <- system.file('extdata/citeproc.json', package = "handlr")
  x <- HandlrClient$new(x = z)
  x$read("citeproc")

  expect_is(x$write("citeproc"), "json")
  expect_null(x$write("citeproc", (f<-tempfile())))
  expect_is(f, "character")
  expect_equal(jsonlite::fromJSON(f, FALSE)$categories, x$parsed$keywords)
})

test_that("HandlrClient fails well", {
  expect_error(HandlrClient$new(), "argument \"x\" is missing")
  expect_error(HandlrClient$new(5), "x must be of class character")
  # expect_error(HandlrClient$new("apple"), "invalid 'file' argument")
})

test_that("HandlrClient fails well: file does not exist", {
  z <- system.file('extdata/codemeta.txt', package = "handlr")
  expect_error(HandlrClient$new(z), "input is zero length string")
})

test_that("handlr_readers", {
  expect_is(handlr_readers, "character")
  expect_is(handlr_writers, "character")
})


test_that("HandlrClient class: works with DOIs", {
  skip_if_net_down()

  a <- HandlrClient$new('https://doi.org/10.7554/elife.01567')
  a$read()
  a$parsed

  # read from a DOI
  b <- HandlrClient$new('10.7554/elife.01567')
  b$read()
  b$parsed

  # result from DOI and DOI as url the same
  expect_identical(a$parsed, b$parsed)
  # can convert to bibtex
  expect_true(any(grepl("journal = \\{eLife\\}", a$write('bibtex'))))

  # fails as expected
  expect_error(
    HandlrClient$new('10.7554/elife.01567', timeout_ms = 10))
})
