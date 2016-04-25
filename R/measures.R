#' Function for getting weather data from one station
#'
#' @importFrom lubridate ymd
#' @importFrom readr read_tsv
#' @importFrom httr GET content
#' @param station station ID, see riem_stations()
#' @param date_start date of start of the desired data, e.g. "2000-01-01"
#' @param date_end date of end of the desired data, e.g. "2016-04-22"
#'
#' @return a data.frame (dplyr tbl_df) with measures, the number of columns can vary from station to station,
#' but possible variables are
#' \itemize{
#' \item station: three or four character site identifier
#' \item valid: timestamp of the observation
#' \item tmpf: Air Temperature in Fahrenheit, typically @ 2 meters
#' \item dwpf: Dew Point Temperature in Fahrenheit, typically @ 2 meters
#' \item relh: Relative Humidity in %
#' \item drct: Wind Direction in degrees from north
#' \item sknt: Wind Speed in knots
#' \item p01i: One hour precipitation for the period from the observation time to the time of the previous hourly precipitation reset. This varies slightly by site. Values are in inches. This value may or may not contain frozen precipitation melted by some device on the sensor or estimated by some other means. Unfortunately, we do not know of an authoritative database denoting which station has which sensor.
#' \item alti: Pressure altimeter in inches
#' \item mslp: Sea Level Pressure in millibar
#' \item vsby: Visibility in miles
#' \item gust: Wind Gust in knots
#' \item skyc1: Sky Level 1 Coverage
#' \item skyc2: Sky Level 2 Coverage
#' \item skyc3: Sky Level 3 Coverage
#' \item skyc4: Sky Level 4 Coverage
#' \item skyl1: Sky Level 1 Altitude in feet
#' \item skyl2: Sky Level 2 Altitude in feet
#' \item skyl3: Sky Level 3 Altitude in feet
#' \item skyl4: Sky Level 4 Altitude in feet
#' \item presentwx: Present Weather Codes (space seperated)
#' \item metar: unprocessed reported observation in METAR format
#' }
#' @export
#'
#' @examples
#' riem_measures(station = "VOHY", date_start = "2000-01-01", date_end = "2016-04-22")
riem_measures <- function(station = "VOHY",
                          date_start = "2014-01-01",
                          date_end = "2016-04-22"){

  base_link <- "https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py/"


  # dates
  if(is.na(ymd(date_start))){
    stop(call. = FALSE, "date_start has to be formatted like \"2014-12-14\"")
  }


  if(is.na(ymd(date_end))){
    stop(call. = FALSE, "date_end has to be formatted like \"2014-12-14\"")
  }

  if(ymd(date_end) < ymd(date_start)){
    stop(call. = FALSE, "date_end has to be bigger than date_start")
  }

  date_start <- strsplit(date_start, "-")[[1]]

  if(length(date_start) != 3){
    stop(call. = FALSE, "date_start has to be formatted like \"2014-12-14\", with hyphens.")
  }
  date_end <- strsplit(date_end, "-")[[1]]
  if(length(date_end) != 3){
    stop(call. = FALSE, "date_end has to be formatted like \"2014-12-14\", with hyphens.")
  }



  # query
  page <- GET(url = base_link,
                    query = list(station = station,
                                 data = "all",
                                 year1 = date_start[1],
                                 month1 = date_start[2],
                                 day1 = date_start[3],
                                 year2 = date_end[1],
                                 month2 = date_end[2],
                                 day2 = date_end[3],
                                 format = "tdf",
                                 latlon = "yes"))
  content <- content(page)
  result <- suppressWarnings(read_tsv(content, skip = 5,
                                  na = c("", "NA", "M")))
  if(nrow(result) == 0){
    warning("No results for this query.", call. = FALSE)
  }
  return(result)
  }
