handlr
======



[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.com/ropensci/handlr.svg?branch=master)](https://travis-ci.com/ropensci/handlr)

a tool for converting among citation formats.

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
(x <- HandlrClient$new(x = z, from ="citeproc"))
#> <handlr> 
#>   path: /Library/Frameworks/R.framework/Versions/3.5/Resources/library/handlr/extdata/citeproc.json
x$path
#> [1] "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/handlr/extdata/citeproc.json"
x$read()
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
#> $ris_type
#> [1] "GEN"
#> 
#> $doi
#> [1] "10.5438/4k3m-nyvg"
#> 
#> $title
#> [1] "Eating your own Dog Food"
#> 
#> $author
#> $author[[1]]
#> $author[[1]]$`@type`
#> [1] "Person"
#> 
#> $author[[1]]$name
#> [1] "Martin Fenner"
#> 
#> $author[[1]]$givenName
#> [1] "Martin"
#> 
#> $author[[1]]$familyName
#> [1] "Fenner"
#> 
#> 
#> 
#> $container_title
#> [1] "DataCite Blog"
#> 
#> $publisher
#> [1] "DataCite"
#> 
#> $is_part_of
#> $is_part_of$type
#> [1] "Periodical"
#> 
#> $is_part_of$title
#> [1] "DataCite Blog"
#> 
#> 
#> $date_published
#> [1] "2016-12-20"
#> 
#> $volume
#> NULL
#> 
#> $description
#> [1] "Eating your own dog food is a slang term to describe that an organization should itself use the products and services it provides. For DataCite this means that we should use DOIs with appropriate metadata and strategies for long-term preservation for..."
#> 
#> $b_version
#> NULL
#> 
#> $keywords
#> $keywords[[1]]
#> [1] "Phylogeny"
#> 
#> $keywords[[2]]
#> [1] "Malaria"
#> 
#> $keywords[[3]]
#> [1] "Parasites"
#> 
#> $keywords[[4]]
#> [1] "Taxonomy"
#> 
#> $keywords[[5]]
#> [1] "Mitochondrial genome"
#> 
#> $keywords[[6]]
#> [1] "Africa"
#> 
#> $keywords[[7]]
#> [1] "Plasmodium"
#> 
#> 
#> $state
#> [1] "findable"
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
#> $ris_type
#> [1] "GEN"
#> 
#> $doi
#> [1] "10.5438/4k3m-nyvg"
#> 
#> $title
#> [1] "Eating your own Dog Food"
#> 
#> $author
#> $author[[1]]
#> $author[[1]]$`@type`
#> [1] "Person"
#> 
#> $author[[1]]$name
#> [1] "Martin Fenner"
#> 
#> $author[[1]]$givenName
#> [1] "Martin"
#> 
#> $author[[1]]$familyName
#> [1] "Fenner"
#> 
#> 
#> 
#> $container_title
#> [1] "DataCite Blog"
#> 
#> $publisher
#> [1] "DataCite"
#> 
#> $is_part_of
#> $is_part_of$type
#> [1] "Periodical"
#> 
#> $is_part_of$title
#> [1] "DataCite Blog"
#> 
#> 
#> $date_published
#> [1] "2016-12-20"
#> 
#> $volume
#> NULL
#> 
#> $description
#> [1] "Eating your own dog food is a slang term to describe that an organization should itself use the products and services it provides. For DataCite this means that we should use DOIs with appropriate metadata and strategies for long-term preservation for..."
#> 
#> $b_version
#> NULL
#> 
#> $keywords
#> $keywords[[1]]
#> [1] "Phylogeny"
#> 
#> $keywords[[2]]
#> [1] "Malaria"
#> 
#> $keywords[[3]]
#> [1] "Parasites"
#> 
#> $keywords[[4]]
#> [1] "Taxonomy"
#> 
#> $keywords[[5]]
#> [1] "Mitochondrial genome"
#> 
#> $keywords[[6]]
#> [1] "Africa"
#> 
#> $keywords[[7]]
#> [1] "Plasmodium"
#> 
#> 
#> $state
#> [1] "findable"
x$write("bibtex")
#> [1] FennerMartin. _Eating your own Dog Food_. DOI:
#> 10.5438/4k3m-nyvg.
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/handlr/issues).
* License: MIT
* Get citation information for `handlr` in R doing `citation(package = 'handlr')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
