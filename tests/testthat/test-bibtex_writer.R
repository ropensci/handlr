context("bibtex_writer")

skip_if_not_installed("bibtex")

test_that("bibtex_writer: works", {
  skip_on_cran()

  z <- system.file('extdata/citeproc.json', package = "handlr")
  tmp <- citeproc_reader(z)
  x <- bibtex_writer(z = tmp)

  expect_is(bibtex_writer, "function")
  expect_is(x, "character")
})

test_that("bibtex_writer: write from citeproc json", {
  skip_on_cran()

  z <- system.file('extdata/citeproc.json', package = "handlr")
  tmp <- citeproc_reader(z)
  x <- bibtex_writer(z = tmp)
  expect_is(bibtex_reader(x), "handl")
})

test_that("bibtex_writer: output gives back same as input from bibtex_reader", {
  skip_on_cran()
  
  z <- system.file('extdata/bibtex.bib', package = "handlr")
  w <- bibtex_reader(z)
  bw_out <- bibtex_writer(w)
  og_out <- readLines(z)

  # should be pretty close other than minor spacing issues
  expect_true(any(grepl(w$title, bw_out, perl = TRUE)))
  expect_true(any(grepl(w$title, og_out, perl = TRUE)))

  expect_true(any(grepl(w$publisher, bw_out)))
  expect_true(any(grepl(w$publisher, og_out)))
})

test_that("bibtex_writer fails well", {
  expect_error(bibtex_writer(), "\"z\" is missing")
  expect_error(bibtex_writer(5), "z must be of class handl")
  # expect_error(bibtex_writer(list(a = 5)), "z must be of class list")
})
