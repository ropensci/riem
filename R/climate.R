#' Function for getting climate data from one place or state
#'
#' This function gets unofficial daily records from U.S. National Weather Service COOP stations. Note this is unofficial data.
#'
#'#' @param place COOP station ID. You can also look up by name of a city or town station nameby setting the is_station_id argument to FALSE. Leave as default "" to return entire state's results. See https://mesonet.agron.iastate.edu/COOP/extremes.php for available states and stations
#' @param state two-letter abbreviation for U.S. state, such as "MA" for Massachusetts or "NY" for New York. See https://mesonet.agron.iastate.edu/COOP/extremes.php for available states and stations. Not all U.S. states are available. Can be left blank when looking up by station ID.
#' @param the_date date of desired records in yyyy-mm-dd or mm-dd format, e.g. "2016-04-22" or "04-22".
#' @param is_station_id logical, defaults to TRUE. If TRUE, look up by station ID. If FALSE, looks up by place name. To see all station IDs for a state, run riem_climate_coop_coop() on a state, such as riem_climate_coop_coop("NY").
#'
#' @return a data.frame with 1 row of climate data for a specific date.
#' \itemize{
#' \item Place: Name of a city or town, character string
#' \item StationID Station ID, character string
#' \item Years: Number of years data available for that station, integer
#' \item AvgHighTemp: Average high temperature in Fahrenheit over those years, numeric
#' \item MaxHighTemp: Maximum high temperature in Fahrenheit over those years, numeric
#' \item YearMaxHighTemp: Year maximum high temperature was recorded, character
#' \item MinHighTemp: Minimum high temperature in Fahrenheit over those years, numeric
#' \item YearMinHighTemp: Year that minimum high temperature was recorded, numeric
#' \item AvgLowTemp: Average low temperature in Fahrenheit over those years, numeric
#' \item MaxLowTemp: Maximum low temperature in Fahrenheit over those years, numeric
#' \item YearMaxLowTemp: Year maximum low temperature was recorded, character
#' \item MinLowTemp: Minimum low temperature in Fahrenheit over those years, numeric
#' \item YearMinLowTemp: Year that minimum low temperature was recorded, numeric
#' \item AvgPrecip: Average precipitation in inches over those years, numeric
#' \item MaxPrecip: Maximum precipitation in inches over those years, numeric
#' \item YearMaxPrecip: Year maximum precipitation was recorded, character
#' \item Date: Day and Month of year for records table, character
#' }
#' @details The data is queried through \url{https://mesonet.agron.iastate.edu/COOP/extremes.php}.
#' @export
#'
#' @examples
#' \dontrun{
#' riem_climate_coop(place = "Boston area", state = "MA", is_station_id = FALSE)
#' }
riem_climate_coop <- function(place = "", state = "", the_date = as.character(Sys.Date()), is_station_id = TRUE) {

   base_link <- "https://mesonet.agron.iastate.edu/COOP/extremes.php"

   if(nchar(the_date) == 10){
   the_month <- substr(the_date, 6,7)
   the_day <- substr(the_date, 9,10)
   } else if(nchar(the_date == 5)){
     the_month <- substr(the_date, 1,2)
     the_day <- substr(the_date, 4, 5)
   } else {
     stop(call. = FALSE,
          "if you are supplying a date, the_date has to be formatted like \"2014-12-14\", that is year-month-day, or 12-24, month-day.") # nolint
   }

   if(state == ""){
      state <- substr(place, 1, 2)
   }



 table_date <- paste(month.abb[as.integer(the_month)], the_day)

baseurl <- "https://mesonet.agron.iastate.edu/COOP/extremes.php"
queryurl <- paste0(baseurl,"?network=", state, "CLIMATE&month=", the_month, "&day=", the_day, "&tbl=climate" )

 all_results <- suppressWarnings(htmltab::htmltab(queryurl, 2))
 if(nrow(all_results) > 0){
   resultsdf = TRUE
   all_results$Place <- gsub("\\s\\(.+\\)", "", all_results$Station)
   all_results$StationID <- gsub(".*\\s\\((.*?)\\)", "\\1", all_results$Station)
 } else {
   resultsdf = FALSE
   warning("No results for this query.", call. = FALSE)
 }

 if(place == "" & resultsdf == TRUE){
    myresults <- all_results
    resultsdf <- TRUE
 } else if (is_station_id == FALSE & place != "" & resultsdf == TRUE){
    myresults <- dplyr::filter(all_results, toupper(Place) == toupper(place))
    if(nrow(myresults) == 0){
       resultsdf <- FALSE
       warning("No results for this query.", call. = FALSE)
       }
 } else if(is_station_id == TRUE & place != "" & resultsdf == TRUE){
    myresults <- dplyr::filter(all_results, toupper(StationID) == toupper(place))
    if(nrow(myresults) == 0){
       resultsdf <- FALSE
       warning("No results for this query.", call. = FALSE)
       }
 }

 if(resultsdf == TRUE){
    myresults <- dplyr::select(myresults, 16, 17, 2:15)
    names(myresults) <- c("Place", "StationID", "Years", "AvgHighTemp", "MaxHighTemp", "YearMaxHighTemp", "MinHighTemp", "YearMinHighTemp", "AvgLowTemp", "MaxLowTemp", "YearMaxLowTemp", "MinLowTemp", "YearMinLowTemp", "AvgPrecip", "MaxPrecip", "YearMaxPrecip")
    myresults$Date <- table_date
    # mydf[,2:3] <- lapply(mydf[,2:3], as.factor)
    myresults$Years <- as.integer(myresults$Years)
    myresults[,c(4,5,7,9,10,12,14,15)] <- lapply(myresults[,c(4,5,7,9,10,12,14,15)], as.numeric)

    if(nrow(myresults) == 0){
     warning("No results for this query.", call. = FALSE)
      return(NA)
    } else {
     return(myresults)
    }
 }



 }
