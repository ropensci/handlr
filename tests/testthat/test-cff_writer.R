context("cff_writer")

z <- system.file('extdata/citation.cff', package = "handlr")

test_that("cff_writer: write text to stdout", {
  skip_on_cran()
  
  w <- cff_reader(z)
  x <- cff_writer(w)

  expect_is(cff_writer, "function")
  expect_is(w, "handl")
  expect_is(x, "character")
  expect_equal(length(x), 1)

  # check that required fields are present
  expect_match(x, "cff-version")
  expect_match(x, "version")
  expect_match(x, "message")
  expect_match(x, "date-released")
  expect_match(x, "title")
  expect_match(x, "authors")
})

test_that("cff_writer: write to a file", {
  skip_on_cran()
  
  w <- cff_reader(z)
  ff <- tempfile(fileext = ".yml")
  x <- cff_writer(w, ff)
  txt <- paste0(readLines(ff), collapse = "\n")

  expect_null(x)
  expect_identical(txt, cff_writer(w))
})
