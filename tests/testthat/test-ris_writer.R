context("ris_writer")

test_that("ris_writer: works", {
  skip_on_cran()

  z <- system.file("extdata/crossref.ris", package = "handlr")
  tmp <- ris_reader(z)
  x <- ris_writer(tmp)

  expect_is(ris_writer, "function")
  expect_is(x, "character")
})

test_that("ris_writer: write from citeproc json", {
  skip_on_cran()

  z <- system.file("extdata/citeproc.json", package = "handlr")
  tmp <- citeproc_reader(z)
  x <- ris_writer(tmp)
  expect_is(ris_reader(x), "handl")
})

test_that("ris_writer: output gives back same as input from ris_reader", {
  skip_on_cran()
  
  z <- system.file("extdata/peerj.ris", package = "handlr")
  w <- ris_reader(z)
  bw_out <- ris_writer(w)
  og_out <- readLines(z)

  # should be pretty close other than minor spacing issues
  expect_true(agrep(w$title, bw_out) > 0)
  expect_true(agrep(w$title, og_out) > 0)

  expect_true(any(grepl(w$journal, bw_out)))
  expect_true(any(grepl(w$journal, og_out)))
})

test_that("ris_writer fails well", {
  expect_error(ris_writer(), "\"z\" is missing")
  expect_error(ris_writer(5), "z must be of class handl")
})
