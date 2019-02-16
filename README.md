handlr
======



[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.com/ropensci/handlr.svg?branch=master)](https://travis-ci.com/ropensci/handlr)
[![Build status](https://ci.appveyor.com/api/projects/status/iu4r3amtntam4c1b?svg=true)](https://ci.appveyor.com/project/sckott/handlr)
[![codecov.io](https://codecov.io/github/ropensci/handlr/coverage.svg?branch=master)](https://codecov.io/github/ropensci/handlr?branch=master)

a tool for converting among citation formats.

heavily influenced by, and code ported from <https://github.com/datacite/bolognese>

supported readers:

- [citeproc][]
- [ris][]
- [bibtex][]
- [codemeta][]

supported writers:

- [citeproc][]
- [ris][]
- [bibtex][]
- [schema.org][]
- [rdfxml][] (requires suggested package [jsonld][])
- [codemeta][]

not supported yet, but plan to:

- crosscite

## Installation

stable version


```r
install.packages("handlr")
```

dev version


```r
devtools::install_github("ropensci/handlr")
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
#>   path: /Library/Frameworks/R.framework/Versions/3.5/Resources/library/handlr/extdata/citeproc.json
#>   string (abbrev.): none
```

read the file


```r
x$read(format = "citeproc")
```

the parsed content


```r
x$parsed
#> $id
#> [1] "https://doi.org/10.5438/4k3m-nyvg"
#> 
#> $type
#> [1] "BlogPosting"
#> 
#> $additional_type
#> NULL
#> 
#> $citeproc_type
#> [1] "post-weblog"
#> 
#> $bibtex_type
#> [1] "article"
#> 
#> $ris_type
#> [1] "GEN"
#> 
#> $doi
#> [1] "10.5438/4k3m-nyvg"
...
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

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/handlr/issues).
* License: MIT
* Get citation information for `handlr` in R doing `citation(package = 'handlr')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)


[jsonld]: https://github.com/ropensci/jsonld/
[codemeta]: https://codemeta.github.io/
[citeproc]: https://en.wikipedia.org/wiki/CiteProc
[ris]: https://en.wikipedia.org/wiki/RIS_(file_format)
[bibtex]: http://www.bibtex.org/
[schema.org]: https://schema.org/
[rdfxml]: https://en.wikipedia.org/wiki/RDF/XML
