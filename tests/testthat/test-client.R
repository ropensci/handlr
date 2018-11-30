context("HandlrClient")

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

  expect_is(x$read("citeproc"), "list")
  expect_is(x$parsed, "list")
})

test_that("HandlrClient class: writing", {
  z <- system.file('extdata/citeproc.json', package = "handlr")
  x <- HandlrClient$new(x = z)
  x$read("citeproc")

  expect_is(x$write("citeproc"), "json")
  expect_null(x$write("citeproc", (f=tempfile())))
  expect_is(f, "character")
  expect_equal(jsonlite::fromJSON(f, FALSE)$categories, x$parsed$keywords)
})

test_that("HandlrClient fails well", {
  expect_error(HandlrClient$new(), "argument \"x\" is missing")
  expect_error(HandlrClient$new(5), "x must be of class character")
  # expect_error(HandlrClient$new("apple"), "invalid 'file' argument")
})

test_that("handlr_readers", {
  expect_is(handlr_readers, "character")
  expect_is(handlr_writers, "character")
})
