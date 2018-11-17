handlr
======



[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.com/ropensci/handlr.svg?branch=master)](https://travis-ci.com/ropensci/handlr)

a tool for converting among citation formats.

heavily influenced by, and code ported from <https://github.com/datacite/bolognese>

supported readers:

- citeproc
- ris
- bibtex

supported writers:

- citeproc
- ris
- bibtex
- schema.org
- rdfxml (requires suggested package [jsonld][])

## Installation


```r
devtools::install_github("ropensci/handlr")
```


```r
library("handlr")
```

## the client


```r
z <- system.file('extdata/citeproc.json', package = "handlr")
x <- HandlrClient$new(x = z)
x
#> <handlr> 
#>   ext: json
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

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/handlr/issues).
* License: MIT
* Get citation information for `handlr` in R doing `citation(package = 'handlr')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)


[jsonld]: https://github.com/ropensci/jsonld/
