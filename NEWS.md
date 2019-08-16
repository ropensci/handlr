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
