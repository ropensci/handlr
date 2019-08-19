context("HandlrClient: guesses format")

skip_on_cran()

test_that("guesses correctly: citeproc", {
  z <- system.file("extdata/citeproc.json", package = "handlr")
  x <- HandlrClient$new(z)

  expect_is(x, "HandlrClient")
  expect_is(x$ext, "character")
  expect_equal(x$ext, "json")
  expect_is(x$format_guessed, "character")
  expect_equal(x$format_guessed, "citeproc")
})

test_that("guesses correctly: ris", {
  z <- system.file('extdata/peerj.ris', package = "handlr")
  x <- HandlrClient$new(z)

  expect_is(x, "HandlrClient")
  expect_is(x$ext, "character")
  expect_equal(x$ext, "ris")
  expect_is(x$format_guessed, "character")
  expect_equal(x$format_guessed, "ris")
})

test_that("guesses correctly: bibtex", {
  z <- system.file('extdata/crossref.bib', package = "handlr")
  x <- HandlrClient$new(z)

  expect_is(x, "HandlrClient")
  expect_is(x$ext, "character")
  expect_equal(x$ext, "bib")
  expect_is(x$format_guessed, "character")
  expect_equal(x$format_guessed, "bibtex")
})

test_that("guesses correctly: codemeta", {
  z <- system.file('extdata/codemeta.json', package = "handlr")
  x <- HandlrClient$new(z)

  expect_is(x, "HandlrClient")
  expect_is(x$ext, "character")
  expect_equal(x$ext, "json")
  expect_is(x$format_guessed, "character")
  expect_equal(x$format_guessed, "codemeta")
})

test_that("guesses correctly: unrelated file extension still works", {
  z <- system.file('extdata/citeproc.txt', package = "handlr")
  x <- HandlrClient$new(z)

  expect_is(x, "HandlrClient")
  expect_is(x$ext, "character")
  expect_equal(x$ext, "txt")
  expect_is(x$format_guessed, "character")
  expect_equal(x$format_guessed, "citeproc")
})

