context("c.handl")

z <- system.file('extdata/crossref.ris', package = "handlr")
cr <- ris_reader(z)
z <- system.file('extdata/peerj.ris', package = "handlr")
prj <- ris_reader(z)

test_that("bibtec.handl: works", {
  x <- c(cr, prj)

  expect_is(cr, "handl")
  expect_is(prj, "handl")
  expect_is(x, "handl")

  expect_equal(attr(x, "from"), "ris,ris")
  expect_true(attr(x, "many"))
  expect_equal(length(attr(x, "file")), 2)
  expect_match(attr(x, "file")[1], attr(x[[1]], "file"))
  expect_match(attr(x, "file")[2], attr(x[[2]], "file"))

  expect_equal(attr(x[[1]], "from"), "ris")
  expect_equal(attr(x[[2]], "from"), "ris")

  expect_false(attr(x[[1]], "many"))
  expect_false(attr(x[[2]], "many"))
})

test_that("c.handl: fails well", {
  # doesn't trigger c.handl when not first item
  expect_is(c(5, 6, cr), "list")

  # can only pass in handl objects
  expect_error(c(cr, prj, 5), "all inputs to ... must be of class handl")
})
