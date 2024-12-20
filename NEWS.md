# riem (development version)

* Breaking change: `date_start` and `station` no longer have default values.

* New arguments `data`, `report_type`, `elev` (#49, @JElchison).

# riem 0.3.2

* Remove last usage of vcr as the choice was made to use httptest2 instead.

# riem 0.3.1

* set tz=UTC on request to ensure tz result (#43, @akrherz)

* Fixes timestamp parsing bug in riem_measures() caused by a lubridate 1.9.0 bug (#40, @BenoitFayolle)

# riem 0.3.0

* Switches to httr2 and httptest2 under the hood.
* Improves error messages.

# riem 0.2.0

* Switches to newer IEM metadata web services (#35, @akrherz)

# riem 0.1.1

* Eliminates a few dependencies (dplyr, lazyeval, readr) to make installation easier.

* Now the default end date for `riem_measures` is the current date as given by `Sys.Date()`.

# riem 0.1.0

* Added a `NEWS.md` file to track changes to the package.



