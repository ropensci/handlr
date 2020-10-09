handlr
======



[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/handlr)](https://cranchecks.info/pkgs/handlr)
[![R-check](https://github.com/ropensci/handlr/workflows/R-check/badge.svg)](https://github.com/ropensci/handlr/actions?query=workflow%3AR-check)
[![codecov.io](https://codecov.io/github/ropensci/handlr/coverage.svg?branch=master)](https://codecov.io/github/ropensci/handlr?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/handlr)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/handlr)](https://cran.r-project.org/package=handlr)


a tool for converting among citation formats.

heavily influenced by, and code ported from <https://github.com/datacite/bolognese>

supported readers:

- [citeproc][]
- [ris][]
- [bibtex][] (requires suggested package `bibtex`)
- [codemeta][]
- [cff][]

supported writers:

- [citeproc][]
- [ris][]
- [bibtex][]
- [schema.org][]
- [rdfxml][] (requires suggested package [jsonld][])
- [codemeta][]
- [cff][]

not supported yet, but plan to:

- crosscite

## Installation

stable version


```r
install.packages("handlr")
```

dev version


```r
remotes::install_github("ropensci/handlr")
```


```r
library("handlr")
```

## All in one

There's a single R6 interface to all readers and writers


```r
z <- system.file("extdata/citeproc.json", package = "handlr")
x <- HandlrClient$new(x = z)
x
#> <handlr> 
#>   doi: 
#>   ext: json
#>   format (guessed): citeproc
#>   path: /Library/Frameworks/R.framework/Versions/4.0/Resources/library/handlr/extdata/citeproc.json
#>   string (abbrev.): none
```

read the file


```r
x$read(format = "citeproc")
```

the parsed content


```r
x$parsed
#> <handl> 
#>   from: citeproc
#>   many: FALSE
#>   count: 1
#>   first 10 
#>     id/doi: https://doi.org/10.5438/4k3m-nyvg
```

write out bibtex


```r
cat(x$write("bibtex"), sep = "\n")
#> @article{https://doi.org/10.5438/4k3m-nyvg,
#>   doi = {10.5438/4k3m-nyvg},
#>   author = {Martin Fenner},
#>   title = {Eating your own Dog Food},
#>   journal = {DataCite Blog},
#>   pages = {},
#>   publisher = {DataCite},
#>   year = {2016},
#> }
```

## Choose your own adventure

Instead of using the `HandlrClient`, you can use the regular functions for each 
reader or writer. They are:

- `citeproc_reader()` / `citeproc_writer()`
- `ris_reader()` / `ris_writer()`
- `bibtex_reader()` / `bibtex_writer()`
- `codemeta_reader()` / `codemeta_writer()`
- `schema_org_writer()`
- `rdf_xml_writer()`

## Convert data to data.frame


```r
z <- system.file('extdata/bib-many.bib', package = "handlr")
res2 <- bibtex_reader(x = z)
#> Error: Please install bibtex
handl_to_df(res2)
#> Error in assert(x, "handl"): object 'res2' not found
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/handlr/issues).
* License: MIT
* Get citation information for `handlr` in R doing `citation(package = 'handlr')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)


[jsonld]: https://github.com/ropensci/jsonld/
[codemeta]: https://codemeta.github.io/
[citeproc]: https://en.wikipedia.org/wiki/CiteProc
[ris]: https://en.wikipedia.org/wiki/RIS_(file_format)
[bibtex]: http://www.bibtex.org/
[schema.org]: https://schema.org/
[rdfxml]: https://en.wikipedia.org/wiki/RDF/XML
[cff]: https://citation-file-format.github.io/
