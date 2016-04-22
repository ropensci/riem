#' Function for getting weather data from one station
#'
#' @param station station ID, see riem_stations()
#' @param date_start date of start of the desired data, e.g. "2000-01-01"
#' @param date_end date of end of the desired data, e.g. "2016-04-22"
#'
#' @return a data.frame (dplyr tbl_df) with measures, the number of columns can vary from station to station.
#' @export
#'
#' @examples
#' riem_measures(station = "VOHY", date_start = "2000-01-01", date_end = "2016-04-22")
riem_measures <- function(station = "VOHY",
                          date_start = "2014-01-01",
                          date_end = "2016-04-22"){

  base_link <- "https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py/"

  date_start <- strsplit(date_start, "-")[[1]]
  date_end <- strsplit(date_end, "-")[[1]]

  page <- httr::GET(url = base_link,
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
  content <- httr::content(page)
  suppressWarnings(readr::read_tsv(content, skip = 5,
                                  na = c("", "NA", "M")))
  }
