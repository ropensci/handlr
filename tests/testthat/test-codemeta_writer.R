context("codemeta_writer")

test_that("codemeta_writer: works", {
  z <- system.file('extdata/codemeta.json', package = "handlr")
  tmp <- codemeta_reader(z)
  x <- codemeta_writer(tmp)

  expect_is(codemeta_writer, "function")
  expect_is(x, "json")
  expect_is(unclass(x), "character")
})

test_that("codemeta_writer: write from citeproc json", {
  z <- system.file('extdata/citeproc.json', package = "handlr")
  tmp <- citeproc_reader(z)
  x <- codemeta_writer(z = tmp)
  expect_is(codemeta_reader(x), "handl")
})

test_that("codemeta_writer: output gives back same as 
  input from codemeta_reader", {

  z <- system.file('extdata/codemeta.json', package = "handlr")
  w <- codemeta_reader(z)
  bw_out <- codemeta_writer(w)
  og_out <- readLines(z)

  # should be pretty close other than minor spacing issues
  expect_true(agrep(w$title, bw_out) > 0)
  expect_true(agrep(w$title, og_out) > 0)

  expect_true(any(grepl(w$publisher, bw_out)))
  expect_true(any(grepl(w$publisher, og_out)))
})

test_that("codemeta_writer fails well", {
  expect_error(codemeta_writer(), "\"z\" is missing")
  expect_error(codemeta_writer(5), "z must be of class handl")
})
