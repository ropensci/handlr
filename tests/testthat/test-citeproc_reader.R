context("citeproc_reader")

test_that("citeproc_reader: works", {
  z <- system.file('extdata/citeproc.json', package = "handlr")
  x <- citeproc_reader(z)

  expect_is(citeproc_reader, "function")
  expect_is(x, "handl")
  expect_named(x)
  expect_is(x$key, "list")
  expect_is(x$id, "character")
  expect_equal(x$type, "BlogPosting")
  expect_equal(x$bibtex_type, "article")
  expect_equal(x$citeproc_type, "post-weblog")
  expect_equal(x$ris_type, "GEN")
  expect_equal(x$doi, "10.5438/4k3m-nyvg")
  expect_is(x$title, "character")
  expect_is(x$author, "list")
  expect_is(x$author[[1]], "list")
  expect_equal(x$author[[1]]$`@type`, "Person")

  expect_equal(attr(x, "from"), "citeproc")
  expect_equal(attr(x, "source_type"), "file")
  expect_match(attr(x, "file"), ".json")
  expect_false(attr(x, "many"))
})

test_that("citeproc_reader fails well", {
  expect_error(citeproc_reader(), "argument \"x\" is missing")
  expect_error(citeproc_reader(5), "x must be of class character")
})
