handlr 0.3.0
============

### DEPENDENCIES

* drop `RefManageR` from package Imports as it will likely be archived soon - add package `bibtex` to Suggests for reading/writing bibtex (can't be in Imports because it's Orphaned on CRAN) (#22)

### NEW FEATURES

* handlr gains support for Citation File Format (CFF), "plain text files with human- and machine-readable citation information for software". See https://citation-file-format.github.io/ for more info - new functions: `cff_reader()` and `cff_writer()` and associated changes in `HandlrClient`. Associated with CFF support, handlr gains new Import package `yaml`  (#16)

### MINOR IMPROVEMENTS

* improvements to Citeproc parsing: previously dropped many fields that we didn't support; now including all Citeproc fields that we don't specifically parse into extra fields prefixed with `csl_`  (#20)
* nothing changed, but see discussion of bibtex errors in case you run into them (#9)


handlr 0.2.0
============

### NEW FEATURES

* gains function `handl_to_df()`; converts any `handl` object (output from `HandlClient` or any `*_reader()` functions) to a data.frame for easier downstream data munging; `HandlClient` gains `$as_df()` method which runs `handl_to_df()`; to support this, now importing data.table package (#15) (#19) feature request by @GeraldCNelson

### MINOR IMPROVEMENTS

* now exporting the `print.handl` method. it only affects how a `handl` class object prints in the console, but is useful for making output more brief/concise (#14)
* filled out a lot more details of what a `handl` object contains. see `?handl` for the documentation (#17)


handlr 0.1.0
============

### NEW FEATURES

* Released to CRAN
