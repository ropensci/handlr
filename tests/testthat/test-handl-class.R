context("handl-class")

test_that("handl class", {
  skip_on_cran()

  z <- system.file('extdata/crossref.bib', package = "handlr")
  x <- bibtex_reader(z)

  expect_is(x, "handl")
  expect_output(print(x), "<handl>")
  expect_output(print(x), "from: bibtex")
  expect_output(print(x), "many: FALSE")
  expect_output(print(x), "count: 1")
  expect_output(print(x), "first 10")
})
