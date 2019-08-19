handlr
======



[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![cran checks](https://cranchecks.info/badges/worst/handlr)](https://cranchecks.info/pkgs/handlr)
[![Build Status](https://travis-ci.com/ropensci/handlr.svg?branch=master)](https://travis-ci.com/ropensci/handlr)
[![Build status](https://ci.appveyor.com/api/projects/status/iu4r3amtntam4c1b?svg=true)](https://ci.appveyor.com/project/sckott/handlr)
[![codecov.io](https://codecov.io/github/ropensci/handlr/coverage.svg?branch=master)](https://codecov.io/github/ropensci/handlr?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/handlr)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/handlr)](https://cran.r-project.org/package=handlr)


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
#> Registered S3 method overwritten by 'crul':
#>   method                 from
#>   as.character.form_file httr
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
#>   path: /Library/Frameworks/R.framework/Versions/3.6/Resources/library/handlr/extdata/citeproc.json
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
NA
NA
NA
NA
NA
NA
NA
NA
NA
NA
NA
NA
NA
NA
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
handl_to_df(res2)
#>             key                                        id    type
#> 1    Amano_2016 https://doi.org/10.1093%2fbiosci%2fbiw022 article
#> 2 Bachelot_2016       https://doi.org/10.1890%2f15-1397.1 article
#>   bibtex_type   citeproc_type ris_type resource_type_general
#> 1     article article-journal     JOUR                  <NA>
#> 2     article article-journal     JOUR                  <NA>
#>   additional_type                   doi
#> 1  JournalArticle 10.1093/biosci/biw022
#> 2  JournalArticle     10.1890/15-1397.1
#>                                     b_url
#> 1 http://dx.doi.org/10.1093/biosci/biw022
#> 2     http://dx.doi.org/10.1890/15-1397.1
#>                                                                                                        title
#> 1                            Spatial Gaps in Global Biodiversity Information and the Role of Citizen Science
#> 2 Long-lasting effects of land use history on soil fungal communities in second-growth tropical rain forests
#>                                                                                           author
#> 1                                                            Amano T., Lamming J., Sutherland W.
#> 2 Bachelot B., Uriarte M., Zimmerman J., Thompson J., Leff J., Asiaii A., Koshner J., McGuire K.
#>                         publisher                         is_part_of
#> 1 Oxford University Press ({OUP})            Periodical;{BioScience}
#> 2                 Wiley-Blackwell Periodical;Ecological Applications
#>   date_published volume first_page last_page    state
#> 1           <NA>     66        393       400 findable
#> 2           <NA>   <NA>       <NA>      <NA> findable
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/handlr/issues).
* License: MIT
* Get citation information for `handlr` in R doing `citation(package = 'handlr')`
* Please note that this project is released with a [Contributor Code of Conduct][coc].
By participating in this project you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)


[jsonld]: https://github.com/ropensci/jsonld/
[codemeta]: https://codemeta.github.io/
[citeproc]: https://en.wikipedia.org/wiki/CiteProc
[ris]: https://en.wikipedia.org/wiki/RIS_(file_format)
[bibtex]: http://www.bibtex.org/
[schema.org]: https://schema.org/
[rdfxml]: https://en.wikipedia.org/wiki/RDF/XML
[coc]: https://github.com/ropensci/handlr/blob/master/CODE_OF_CONDUCT.md
