context("codemeta_reader")

z <- system.file('extdata/codemeta.json', package = "handlr")

test_that("codemeta_reader: works", {
  x <- codemeta_reader(z)

  expect_is(codemeta_reader, "function")
  expect_is(x, "handl")
  expect_is(x$id, "character")
  expect_match(x$id, "doi.org")
  expect_match(attr(x, "from"), "codemeta")
  expect_match(attr(x, "source_type"), "file")
  expect_match(attr(x, "file"), ".json")
  expect_false(attr(x, "many"))
})

test_that("codemeta_reader: read from string", {
  str <- paste0(readLines(z), collapse = "")
  x <- codemeta_reader(str)
  
  expect_is(x, "handl")
  expect_is(x$id, "character")
  expect_match(x$id, "doi.org")
  expect_match(attr(x, "from"), "codemeta")
  expect_match(attr(x, "source_type"), "string")
  expect_equal(attr(x, "file"), "")
  expect_false(attr(x, "many"))
})

test_that("codemeta_reader fails well", {
  expect_error(codemeta_reader(), "\"x\" is missing")
  expect_error(codemeta_reader(5), "x must be of class character, json")
})
