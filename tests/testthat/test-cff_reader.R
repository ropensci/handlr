context("cff_reader")

z <- system.file('extdata/citation.cff', package = "handlr")

test_that("cff_reader: works", {
  skip_on_cran()
  
  x <- cff_reader(z)

  expect_is(cff_reader, "function")
  expect_is(x, "handl")
  expect_named(x)
  expect_null(x[["key"]])
  expect_is(x$keywords, "character")
  expect_gt(length(x$keywords), 1)
  expect_is(x$id, "character")
  expect_equal(x$type, "SoftwareSourceCode")
  expect_equal(x$bibtex_type, "misc")
  expect_equal(x$citeproc_type, "article-journal")
  expect_equal(x$ris_type, "COMP")
  expect_equal(x$doi, "10.5281/zenodo.1234")
  expect_is(x$title, "character")
  expect_is(x$author, "list")
  expect_is(x$author[[1]], "list")
  expect_equal(x$author[[1]]$type, "Person")

  expect_equal(attr(x, "from"), "cff")
  expect_equal(attr(x, "source_type"), "file")
  expect_match(attr(x, "file"), ".cff")
  expect_false(attr(x, "many"))
})

# main field checks
test_that("cff_reader: required fields", {
  skip_on_cran()
  
  zy <- yaml::yaml.load_file(z)
  zy$`cff-version` <- NULL
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  expect_error(cff_reader(tf), "'cff-version' is required")

  zy <- yaml::yaml.load_file(z)
  zy$version <- NULL
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  expect_error(cff_reader(tf), "'version' is required")

  zy <- yaml::yaml.load_file(z)
  zy$message <- NULL
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  expect_error(cff_reader(tf), "'message' is required")

  zy <- yaml::yaml.load_file(z)
  zy$`date-released` <- NULL
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  expect_error(cff_reader(tf), "'date-released' is required")

  zy <- yaml::yaml.load_file(z)
  zy$title <- NULL
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  expect_error(cff_reader(tf), "'title' is required")

  zy <- yaml::yaml.load_file(z)
  zy$authors <- NULL
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  expect_error(cff_reader(tf), "'authors' is required")
})

# reference checks
test_that("cff_reader: reference types are checked", {
  skip_on_cran()
  
  zy <- yaml::yaml.load_file(z)
  zy$references[[1]]$type <- "foobar"
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  
  expect_error(cff_reader(tf), "reference")
})

test_that("cff_reader: reference title type is checked", {
  skip_on_cran()
  
  zy <- yaml::yaml.load_file(z)
  zy$references[[1]]$title <- 234
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  
  expect_error(cff_reader(tf), "'title' must be a string")
})

test_that("cff_reader: reference author elements each must be entity or person", {
  skip_on_cran()
  
  zy <- yaml::yaml.load_file(z)
  names(zy$references[[1]]$authors[[1]])[1] <- "foobar"
  tf <- tempfile(fileext = ".yml")
  yaml::write_yaml(zy, tf)
  
  expect_error(cff_reader(tf), "each element in 'authors'")
})

test_that("cff_reader fails well", {
  expect_error(cff_reader(), "argument \"x\" is missing")
  expect_error(cff_reader(5), "x must be of class character")
})
