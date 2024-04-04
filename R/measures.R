#' Get weather data from one station
#'
#'
#' @param station station ID, see riem_stations()
#' @param date_start date of start of the desired data, e.g. "2000-01-01"
#' @param date_end date of end of the desired data, e.g. "2016-04-22"
#'
#' @return a data.frame (tibble tibble) with measures, the number of columns can vary from station to station,
#' but possible variables are
#' \itemize{
#' \item station: three or four character site identifier
#' \item valid: timestamp of the observation (UTC)
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
#' \item presentwx: Present Weather Codes (space seperated),
#'  see e.g. Chapter 8 of [this manual](https://www.ofcm.gov/publications/fmh/FMH1/FMH1.pdf) for further explanations.
#' \item feel: Apparent Temperature (Wind Chill or Heat Index) in degF
#' \item ice_accretion_1hr: Ice Accretion over 1 Hour in inch
#' \item ice_accretion_3hr: Ice Accretion over 3 Hour in inch
#' \item ice_accretion_6hr: Ice Accretion over 6 Hour in inch
#' \item relh: Relative Humidity in %
#' \item metar: unprocessed reported observation in METAR format
#' \item peak_wind_gust: Wind gust in knots from the METAR PK WND remark, this value may be different than the value found in the gust field. The gust field is derived from the standard METAR wind report.
#' \item peak_wind_drct: The wind direction in degrees North denoted in the METAR PK WND remark.
#' \item peak_wind_time: The timestamp of the PK WND value in the same timezone as the valid field and controlled by the tz parameter.

#' }
#' @details The data is queried through \url{https://mesonet.agron.iastate.edu/request/download.phtml}.
#' @export
#'
#' @examples
#' \dontrun{
#' riem_measures(station = "VOHY", date_start = "2016-01-01", date_end = "2016-04-22")
#' }
riem_measures <- function(
    station = "VOHY",
    date_start = "2014-01-01",
    date_end = as.character(Sys.Date())) {
  date_start <- format_and_check_date(date_start, "date_start")
  date_end <- format_and_check_date(date_end, "date_end")
  if (date_end < date_start) {
    cli::cli_abort("{.arg date_end} must be bigger than {.arg date_start}.")
  }

  resp <- perform_riem_request(
    path = "cgi-bin/request/asos.py/",
    query = list(
      station = station,
      data = "all",
      year1 = lubridate::year(date_start),
      month1 = lubridate::month(date_start),
      day1 = lubridate::day(date_start),
      year2 = lubridate::year(date_end),
      month2 = lubridate::month(date_end),
      day2 = lubridate::day(date_end),
      format = "tdf",
      latlon = "yes",
      tz = "UTC"
    )
  )

  httr2::resp_check_status(resp)

  content <- httr2::resp_body_string(resp)

  col.names <- read.table(
    text = content,
    skip = 5,
    nrows = 1,
    na.strings = c("", "NA", "M"),
    sep = "\t",
    stringsAsFactors = FALSE
  ) %>%
    t() %>%
    as.character()
  col.names <- gsub(" ", "", col.names)

  result <- read.table(
    text = content,
    skip = 6,
    col.names = col.names,
    na.strings = c("", "NA", "M"),
    sep = "\t",
    stringsAsFactors = FALSE,
    fill = TRUE
  )

  if (nrow(result) == 0) {
    cli::cli_warn("No results for this query.")
    return(NULL)
  }

  result$valid <- lubridate::ymd_hm(result$valid)

  tibble::as_tibble(result)
}

format_and_check_date <- function(date, name) {
  converted_date <- suppressWarnings(lubridate::ymd(date))

  if (is.na(converted_date)) {
    cli::cli_abort(
      message = c(
        x = sprintf("Invalid {.arg %s}: {.value %s}.", name, date),
        i = "Correct format is YYYY-MM-DD."
      )
    )
  }

  converted_date
}
