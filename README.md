# handlr

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![codecov.io](https://codecov.io/github/ropensci/handlr/coverage.svg?branch=master)](https://app.codecov.io/github/ropensci/handlr?branch=master)
[![rstudio mirror
downloads](https://cranlogs.r-pkg.org/badges/handlr)](https://github.com/r-hub/cranlogs.app)
[![cran
version](https://www.r-pkg.org/badges/version/handlr)](https://cran.r-project.org/package=handlr)

a tool for converting among citation formats.

heavily influenced by, and code ported from the Ruby gem `bolognese`

supported readers:

-   citeproc
-   ris
-   bibtex
-   codemeta
-   cff

supported writers:

-   citeproc
-   ris
-   bibtex
-   schemaorg
-   rdfxml
-   codemeta
-   cff

not supported yet, but plan to:

-   crosscite

## Installation

stable version

    install.packages("handlr")

dev version

    remotes::install_github("ropensci/handlr")

    library("handlr")

## Meta

-   Please [report any issues or
    bugs](https://github.com/ropensci/handlr/issues).
-   License: MIT
-   Get citation information for `handlr` in R doing
    `citation(package = 'handlr')`
-   Please note that this package is released with a [Contributor Code
    of Conduct](https://ropensci.org/code-of-conduct/). By contributing
    to this project, you agree to abide by its terms.

[![ropensci\_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
