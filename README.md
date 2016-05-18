riem
====

[![Travis-CI Build Status](https://travis-ci.org/masalmon/riem.svg?branch=master)](https://travis-ci.org/masalmon/riem) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/masalmon/riem?branch=master&svg=true)](https://ci.appveyor.com/project/masalmon/riem) [![codecov](https://codecov.io/gh/masalmon/riem/branch/master/graph/badge.svg)](https://codecov.io/gh/masalmon/riem)

This package allows to get weather data from ASOS stations (airports) via the awesome website of the [Iowa Environment Mesonet](https://mesonet.agron.iastate.edu/request/download.phtml?network=IN__ASOS).

Installation
============

To install the package, you will need the devtools package.

``` r
library("devtools")
install_github("masalmon/riem")
```

Get available networks
======================

``` r
library("riem")
library("dplyr")
riem_networks() %>% head() %>% knitr::kable()
```

| code       | name                      |
|:-----------|:--------------------------|
| AE\_\_ASOS | United Arab Emirates ASOS |
| AF\_\_ASOS | Afghanistan ASOS          |
| AG\_\_ASOS | Antigua and Barbuda ASOS  |
| AI\_\_ASOS | Anguilla ASOS             |
| AK\_ASOS   | Alaska ASOS               |
| AL\_ASOS   | Alabama ASOS              |

Get available stations for one network
======================================

``` r
riem_stations(network = "IN__ASOS") %>% head() %>% knitr::kable()
```

| id   | name             |       lon|       lat|
|:-----|:-----------------|---------:|---------:|
| VEAT | AGARTALA         |  91.24045|  23.88698|
| VIAG | AGRA (IN-AFB)    |  77.96089|  27.15583|
| VAAH | AHMADABAD        |  72.63465|  23.07724|
| VAAK | AKOLA AIRPORT    |  77.05863|  20.69901|
| VIAH | ALIGARH          |  78.06667|  27.88333|
| VIAL | ALLAHABAD (IN-AF |  81.73387|  25.44006|

Get measures for one station
============================

Possible variables are

-   station: three or four character site identifier

-   valid: timestamp of the observation (UTC)

-   tmpf: Air Temperature in Fahrenheit, typically @ 2 meters

-   dwpf: Dew Point Temperature in Fahrenheit, typically @ 2 meters

-   relh: Relative Humidity in %

-   drct: Wind Direction in degrees from north

-   sknt: Wind Speed in knots

-   p01i: One hour precipitation for the period from the observation time to the time of the previous hourly precipitation reset. This varies slightly by site. Values are in inches. This value may or may not contain frozen precipitation melted by some device on the sensor or estimated by some other means. Unfortunately, we do not know of an authoritative database denoting which station has which sensor.

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

-   presentwx: Present Weather Codes (space seperated), see e.g. [this manual](http://www.ofcm.gov/fmh-1/pdf/H-CH8.pdf) for further explanations.

-   metar: unprocessed reported observation in METAR format

``` r
riem_measures(station = "VOHY", date_start = "2000-01-01", date_end = "2016-04-22") %>% head() %>% knitr::kable()
```

| station | valid               |      lon|      lat|  tmpf|  dwpf|   relh|  drct|  sknt| p01i |   alti| mslp |  vsby| gust | skyc1 | skyc2 | skyc3 | skyc4 |  skyl1|  skyl2|  skyl3|  skyl4| presentwx | metar                                                        |
|:--------|:--------------------|--------:|--------:|-----:|-----:|------:|-----:|-----:|:-----|------:|:-----|-----:|:-----|:------|:------|:------|:------|------:|------:|------:|------:|:----------|:-------------------------------------------------------------|
| VOHY    | 2011-08-23 00:40:00 |  78.4676|  17.4531|  73.4|  69.8|  88.51|     0|     0| NA   |  29.83| NA   |  3.11| NA   | SCT   | BKN   | NA    | NA    |   1000|  20000|     NA|     NA| HZ        | VOHY 230040Z 00000KT 5000 HZ SCT010 BKN200 23/21 Q1010 NOSIG |
| VOHY    | 2011-08-23 01:40:00 |  78.4676|  17.4531|  73.4|  69.8|  88.51|     0|     0| NA   |  29.83| NA   |  3.11| NA   | SCT   | BKN   | NA    | NA    |   2000|  20000|     NA|     NA| HZ        | VOHY 230140Z 00000KT 5000 HZ SCT020 BKN200 23/21 Q1010 NOSIG |
| VOHY    | 2011-08-23 05:10:00 |  78.4676|  17.4531|  82.4|  68.0|  61.81|   270|     7| NA   |  29.85| NA   |  3.73| NA   | SCT   | SCT   | NA    | NA    |   1500|   2500|     NA|     NA| NA        | VOHY 230510Z 27007KT 6000 SCT015 SCT025 28/20 Q1011 NOSIG    |
| VOHY    | 2011-08-23 05:40:00 |  78.4676|  17.4531|  84.2|  66.2|  54.80|   270|     9| NA   |  29.83| NA   |  3.73| NA   | SCT   | SCT   | NA    | NA    |   1500|   2500|     NA|     NA| NA        | VOHY 230540Z 27009KT 6000 SCT015 SCT025 29/19 Q1010 NOSIG    |
| VOHY    | 2011-08-23 06:40:00 |  78.4676|  17.4531|  84.2|  68.0|  58.32|   260|     5| NA   |  29.83| NA   |  3.73| NA   | SCT   | SCT   | NA    | NA    |   1500|   2500|     NA|     NA| NA        | VOHY 230640Z 26005KT 6000 SCT015 SCT025 29/20 Q1010 NOSIG    |
| VOHY    | 2011-08-23 07:40:00 |  78.4676|  17.4531|  84.2|  66.2|  54.80|   250|     7| NA   |  29.77| NA   |  3.73| NA   | SCT   | SCT   | NA    | NA    |   2000|   2500|     NA|     NA| NA        | VOHY 230740Z 25007KT 6000 SCT020 SCT025 29/19 Q1008 NOSIG    |

For conversion of wind speed or temperature into other units, see [this package](https://github.com/geanders/weathermetrics/).
