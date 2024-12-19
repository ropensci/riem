#' Get weather data from one station
#'
#' @importFrom rlang `%||%`
#'
#' @param station station ID, see riem_stations()
#' @param date_start date of start of the desired data, e.g. "2016-01-01"
#' @inheritParams rlang::args_dots_empty
#' @param date_end date of end of the desired data, e.g. "2016-04-22"
#' @param data The data columns to return. The available options are: all, tmpf, dwpf, relh, drct, sknt, p01i, alti, mslp, vsby, gust, skyc1, skyc2, skyc3, skyc4, skyl1, skyl2, skyl3, skyl4, wxcodes, ice_accretion_1hr, ice_accretion_3hr, ice_accretion_6hr, peak_wind_gust, peak_wind_drct, peak_wind_time, feel, metar, snowdepth # nolint: line_length_linter
#' @param elev If TRUE, the elevation (m) of the station will be included in the output. # nolint: line_length_linter
#' @param latlon If TRUE, the latitude and longitude of the station will be included in the output. # nolint: line_length_linter
#' @param report_type The report type to query. The available options are "hfmetar" (skipped by default), "routine", "specials". # nolint: line_length_linter
#'
#' @return a data.frame (tibble tibble) with measures,
#' the number of columns can vary from station to station,
#' but possible variables are
#' \itemize{
#' \item station: three or four character site identifier
#' \item valid: timestamp of the observation (UTC)
#' \item tmpf: Air Temperature in Fahrenheit, typically @ 2 meters
#' \item dwpf: Dew Point Temperature in Fahrenheit, typically @ 2 meters
#' \item relh: Relative Humidity in %
#' \item drct: Wind Direction in degrees from north
#' \item sknt: Wind Speed in knots
#' \item p01i: One hour precipitation for the period from the observation time
#' to the time of the previous hourly precipitation reset.
#' This varies slightly by site. Values are in inches.
#' This value may or may not contain frozen precipitation melted by some device
#' on the sensor or estimated by some other means. Unfortunately, we do not know
#'  of an authoritative database denoting which station has which sensor.
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
#'  see e.g. Chapter 8 of [this manual](https://www.ofcm.gov/publications/fmh/FMH1/FMH1.pdf) for further explanations.# nolint: line_length_linter
#' \item feel: Apparent Temperature (Wind Chill or Heat Index) in degF
#' \item ice_accretion_1hr: Ice Accretion over 1 Hour in inch
#' \item ice_accretion_3hr: Ice Accretion over 3 Hour in inch
#' \item ice_accretion_6hr: Ice Accretion over 6 Hour in inch
#' \item relh: Relative Humidity in %
#' \item metar: unprocessed reported observation in METAR format
#' \item peak_wind_gust: Wind gust in knots from the METAR PK WND remark,
#' this value may be different than the value found in the gust field.
#' The gust field is derived from the standard METAR wind report.
#' \item peak_wind_drct: The wind direction in degrees North denoted
#' in the METAR PK WND remark.
#' \item peak_wind_time: The timestamp of the PK WND value in the same timezone
#' as the valid field and controlled by the tz parameter.

#' }
#' @details The data is queried through \url{https://mesonet.agron.iastate.edu/request/download.phtml}.# nolint: line_length_linter
#' @export
#'
#' @examples
#' \dontrun{
#' riem_measures(
#'   station = "VOHY",
#'   date_start = "2016-01-01",
#'   date_end = "2016-04-22"
#' )
#' }
riem_measures <- function(
    station,
    date_start,
    ...,
    date_end = as.character(Sys.Date()),
    data = "all",
    elev = FALSE,
    latlon = TRUE,
    report_type = NULL) {
  if (!rlang::is_character(station, n = 1L)) {
    cli::cli_abort("{.arg station} must be a string.")
  }
  date_start <- format_and_check_date(date_start, "date_start")
  rlang::check_dots_empty()
  date_end <- format_and_check_date(date_end, "date_end")
  if (date_end < date_start) {
    cli::cli_abort("{.arg date_end} must be bigger than {.arg date_start}.")
  }
  if (!rlang::is_character(data, n = 1L)) {
    cli::cli_abort("{.arg data} must be a string.")
  }
  if (!is.logical(elev)) {
    cli::cli_abort("{.arg elev} must be a logical (TRUE/FALSE)") # nolint: nonportable_path_linter
  }
  if (!is.logical(latlon)) {
    cli::cli_abort("{.arg latlon} must be a logical (TRUE/FALSE)") # nolint: nonportable_path_linter
  }

  report_type <- report_type %||% c("routine", "specials")
  report_type <- tolower(report_type) # not case-sensitive
  report_type <- rlang::arg_match(
    report_type,
    values = c("hfmetar", "routine", "specials"),
    multiple = TRUE
  )
  report_type <- purrr::map_int(
    report_type,
    \(x) switch(x, hfmetar = 1L, routine = 3L, specials = 4L) # nolint: unnecessary_lambda_linter
  )
  report_type <- paste(report_type, collapse = ",")

  resp <- perform_riem_request(
    path = "cgi-bin/request/asos.py/", # nolint: nonportable_path_linter
    # query fields per https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py?help # nolint: line_length_linter
    query = list(
      station = station,
      data = data,
      elev = ifelse(elev, "yes", "no"),
      latlon = ifelse(latlon, "yes", "no"),
      year1 = lubridate::year(date_start),
      month1 = lubridate::month(date_start),
      day1 = lubridate::day(date_start),
      year2 = lubridate::year(date_end),
      month2 = lubridate::month(date_end),
      day2 = lubridate::day(date_end),
      report_type = report_type,
      format = "tdf",
      nometa = "no",
      tz = "UTC"
    )
  )

  httr2::resp_check_status(resp)

  content <- httr2::resp_body_string(resp)

  col_names <- read.table(
    text = content,
    skip = 5L,
    nrows = 1L,
    na.strings = c("", "NA", "M"),
    sep = "\t",
    stringsAsFactors = FALSE
  ) %>%
    t() %>%
    as.character()
  col_names <- gsub(" ", "", col_names, fixed = TRUE)

  result <- read.table(
    text = content,
    skip = 6L,
    col.names = col_names,
    na.strings = c("", "NA", "M"),
    sep = "\t",
    stringsAsFactors = FALSE,
    fill = TRUE
  )

  if (nrow(result) == 0L) {
    cli::cli_warn("No results for this query.")
    return(NULL)
  }

  result$valid <- lubridate::ymd_hm(result$valid) # nolint: extraction_operator_linter

  tibble::as_tibble(result)
}

format_and_check_date <- function(date, name) {
  converted_date <- suppressWarnings(lubridate::ymd(date))

  if (is.na(converted_date)) {
    cli::cli_abort(
      message = c(
        x = "Invalid {.arg {name}}: {.value {date}}.",
        i = "Correct format is YYYY-MM-DD."
      )
    )
  }

  converted_date
}
