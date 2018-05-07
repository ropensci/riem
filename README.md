riem
====

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/riem)](http://cran.r-project.org/package=riem)
[![Travis-CI Build
Status](https://travis-ci.org/ropensci/riem.svg?branch=master)](https://travis-ci.org/ropensci/riem)
[![Build
status](https://ci.appveyor.com/api/projects/status/jl8sxr77bi8jnqrm?svg=true)](https://ci.appveyor.com/project/ropensci/riem)
[![codecov](https://codecov.io/gh/ropensci/riem/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/riem)
[![](https://badges.ropensci.org/39_status.svg)](https://github.com/ropensci/onboarding/issues/39)

This package allows to get weather data from ASOS stations (airports)
via the awesome website of the [Iowa Environment
Mesonet](https://mesonet.agron.iastate.edu/request/download.phtml?network=IN__ASOS).

Installation
============

Install the package with:

``` r
install.packages("riem")
```

Or install the development version using
[devtools](https://github.com/hadley/devtools) with:

``` r
library("devtools")
install_github("ropensci/riem")
```

Get available networks
======================

``` r
library("riem")
riem_networks() 
```

    ## # A tibble: 267 x 2
    ##    code     name                     
    ##    <chr>    <chr>                    
    ##  1 AE__ASOS United Arab Emirates ASOS
    ##  2 AF__ASOS Afghanistan ASOS         
    ##  3 AG__ASOS Antigua and Barbuda ASOS 
    ##  4 AI__ASOS Anguilla ASOS            
    ##  5 AK_ASOS  Alaska ASOS              
    ##  6 AL_ASOS  Alabama ASOS             
    ##  7 AL__ASOS Albania ASOS             
    ##  8 AM__ASOS Armenia ASOS             
    ##  9 AN__ASOS Netherlands Antilles ASOS
    ## 10 AO__ASOS Angola ASOS              
    ## # ... with 257 more rows

Get available stations for one network
======================================

``` r
riem_stations(network = "IN__ASOS") 
```

    ## # A tibble: 122 x 4
    ##    id    name                 lon   lat
    ##    <chr> <chr>              <dbl> <dbl>
    ##  1 VEAT  "AGARTALA        "  91.2  23.9
    ##  2 VOAT  Agatti              72.2  10.8
    ##  3 VIAG  "AGRA (IN-AFB)   "  78.0  27.2
    ##  4 VAAH  "AHMADABAD       "  72.6  23.1
    ##  5 VAAK  "AKOLA AIRPORT   "  77.1  20.7
    ##  6 VIAH  "ALIGARH         "  78.1  27.9
    ##  7 VIAL  ALLAHABAD (IN-AF    81.7  25.4
    ##  8 VIAR  "AMRITSAR        "  74.9  31.6
    ##  9 VAOR  Arkonam             79.7  13.1
    ## 10 VOAR  Arkonam             79.7  13.1
    ## # ... with 112 more rows

Get measures for one station
============================

Possible variables are (copied from
[here](https://mesonet.agron.iastate.edu/request/download.phtml), see
also the [ASOS user
guide](http://www.nws.noaa.gov/asos/pdfs/aum-toc.pdf))

-   station: three or four character site identifier

-   valid: timestamp of the observation (UTC)

-   tmpf: Air Temperature in Fahrenheit, typically @ 2 meters

-   dwpf: Dew Point Temperature in Fahrenheit, typically @ 2 meters

-   relh: Relative Humidity in %

-   drct: Wind Direction in degrees from north

-   sknt: Wind Speed in knots

-   p01i: One hour precipitation for the period from the observation
    time to the time of the previous hourly precipitation reset. This
    varies slightly by site. Values are in inches. This value may or may
    not contain frozen precipitation melted by some device on the sensor
    or estimated by some other means. Unfortunately, we do not know of
    an authoritative database denoting which station has which sensor.

-   alti: Pressure altimeter in inches

-   mslp: Sea Level Pressure in millibar

-   vsby: Visibility in miles

-   gust: Wind Gust in knots

-   skyc1: Sky Level 1 Coverage

-   skyc2: Sky Level 2 Coverage

-   skyc3: Sky Level 3 Coverage

-   skyc4: Sky Level 4 Coverage

-   skyl1: Sky Level 1 Altitude in feet

-   skyl2: Sky Level 2 Altitude in feet

-   skyl3: Sky Level 3 Altitude in feet

-   skyl4: Sky Level 4 Altitude in feet

-   presentwx: Present Weather Codes (space seperated), see e.g. [this
    manual](http://www.ofcm.gov/fmh-1/pdf/H-CH8.pdf) for further
    explanations.

-   metar: unprocessed reported observation in METAR format

``` r
measures <- riem_measures(station = "VOHY", date_start = "2000-01-01", date_end = "2016-04-22") 
knitr::kable(head(measures))
```

| station | valid               |      lon|      lat|   tmpf|   dwpf|   relh|  drct|  sknt|  p01i|   alti|    mslp|  vsby|  gust| skyc1 | skyc2 | skyc3 | skyc4 |  skyl1|  skyl2|  skyl3|  skyl4| wxcodes | metar                                                                    |
|:--------|:--------------------|--------:|--------:|------:|------:|------:|-----:|-----:|-----:|------:|-------:|-----:|-----:|:------|:------|:------|:------|------:|------:|------:|------:|:--------|:-------------------------------------------------------------------------|
| VOHY    | 2000-01-01 00:00:00 |  78.4676|  17.4531|  61.52|  57.38|  86.26|     0|     0|    NA|  29.94|  1013.9|  2.50|    NA| NA    | NA    | NA    | NA    |     NA|     NA|     NA|     NA| NA      | VOHY 010000Z AUTO 00000KT 2 1/2SM 16/14 RMK SLP139 T01640141 IEM\_DS3505 |
| VOHY    | 2000-01-01 01:40:00 |  78.4676|  17.4531|  64.40|  60.80|  88.09|     0|     0|    NA|  30.03|      NA|  1.25|    NA| NA    | NA    | NA    | NA    |     NA|     NA|     NA|     NA| NA      | VOHY 010140Z AUTO 00000KT 1 1/4SM 18/16 A3003 RMK T01800160 IEM\_DS3505  |
| VOHY    | 2000-01-01 02:40:00 |  78.4676|  17.4531|  69.80|  60.80|  73.09|   140|     5|    NA|  30.06|      NA|  1.25|    NA| NA    | NA    | NA    | NA    |     NA|     NA|     NA|     NA| NA      | VOHY 010240Z AUTO 14005KT 1 1/4SM 21/16 A3006 RMK T02100160 IEM\_DS3505  |
| VOHY    | 2000-01-01 03:00:00 |  78.4676|  17.4531|  68.00|  61.70|  80.27|   140|     4|    NA|  30.01|  1016.3|  1.25|    NA| NA    | NA    | NA    | NA    |     NA|     NA|     NA|     NA| NA      | VOHY 010300Z AUTO 14004KT 1 1/4SM 20/16 RMK SLP163 T02000165 IEM\_DS3505 |
| VOHY    | 2000-01-01 03:40:00 |  78.4676|  17.4531|  71.60|  62.60|  73.27|   140|     5|    NA|  30.06|      NA|  2.50|    NA| NA    | NA    | NA    | NA    |     NA|     NA|     NA|     NA| NA      | VOHY 010340Z AUTO 14005KT 2 1/2SM 22/17 A3006 RMK T02200170 IEM\_DS3505  |
| VOHY    | 2000-01-01 05:40:00 |  78.4676|  17.4531|  75.20|  55.40|  50.17|    90|     6|    NA|  30.00|      NA|    NA|    NA| NA    | NA    | NA    | NA    |     NA|     NA|     NA|     NA| NA      | VOHY 010540Z AUTO 09006KT 24/13 A3000 RMK T02400130 IEM\_DS3505          |

For conversion of wind speed or temperature into other units, see [this
package](https://github.com/geanders/weathermetrics/).

Meta
----

-   Please [report any issues or
    bugs](https://github.com/ropenscilabs/riem/issues).
-   License: GPL
-   Get citation information for `ropenaq` in R doing
    `citation(package = 'riem')`
-   Please note that this project is released with a [Contributor Code
    of Conduct](CONDUCT.md). By participating in this project you agree
    to abide by its terms.

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
