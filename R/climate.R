#' Function for getting climate data from one place or state
#'
#' @importFrom htmltab htmltab
#'
#' @param the_state two-letter abbreviation for U.S. state, such as "MA". See https://mesonet.agron.iastate.edu/COOP/extremes.php for available states and stations, since not all U.S. states are available.
#' @param the_place Name of a city or town station name in the U.S. that has an available station ID. Leave as default "" to return entire state's results.
#' @param the_date date of desired records in yyyy-mm-dd or mm-dd format, e.g. "2016-04-22" or "04-22".
#'
#' @return a data.frame with 1 row of climate data for a specific date.
#' \itemize{
#' \item Place: Name of a city or town
#' \item Years: Number of years data available for that station
#' \item AvgHighTemp: Average high temperature in Fahrenheit over those years
#' \item MaxHighTemp: Maximum high temperature in Fahrenheit over those years
#' \item YearMaxHighTemp: Year maximum high temperature was recorded
#' \item MinHighTemp: Minimum high temperature in Fahrenheit over those years
#' \item YearMinHighTemp: Year that minimum high temperature was recorded
#'
#' \item AvgLowTemp: Average low temperature in Fahrenheit over those years
#' \item MaxLowTemp: Maximum low temperature in Fahrenheit over those years
#' \item YearMaxLowTemp: Year maximum low temperature was recorded
#' \item MinLowTemp: Minimum low temperature in Fahrenheit over those years
#' \item YearMinLowTemp: Year that minimum low temperature was recorded
#'
#' \item AvgPrecip: Average precipitation in inches over those years
#' \item MaxPrecip: Maximum precipitation in inches over those years
#' \item YearMaxPrecip: Year maximum precipitation was recorded
#' @details The data is queried through \url{https://mesonet.agron.iastate.edu/COOP/extremes.php}.
#' @export
#'
#' @examples
#' \dontrun{
#' riem_climate(the_place = "Boston area", the_state = "MA")
#' }
riem_climate <- function(the_state = "MA",
                         the_place = "",
                          the_date = as.character(Sys.Date())
                         ) {

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

   if(the_place == "Tampa"){
     the_place <- "TAMPA WSCMO AP"
   }

baseurl <- "https://mesonet.agron.iastate.edu/COOP/extremes.php"
queryurl <- paste0(baseurl,"?network=", the_state, "CLIMATE&month=", the_month, "&day=", the_day, "&tbl=climate" )

all_results <- suppressWarnings(htmltab::htmltab(queryurl, 2))
all_results$Place <- gsub("\\s\\(.+\\)", "", all_results$Station)

if(the_place != ""){
myresults <- dplyr::filter(all_results, toupper(Place) == toupper(the_place))
} else{
  myresults <- all_results
}
myresults <- dplyr::select(myresults, 16, 2:15)
names(myresults) <- c("Place", "Years", "AvgHighTemp", "MaxHighTemp", "YearMaxHighTemp", "MinHighTemp", "YearMinHighTemp", "AvgLowTemp", "MaxLowTemp", "YearMaxLowTemp", "MinLowTemp", "YearMinLowTemp", "AvgPrecip", "MaxPrecip", "YearMaxPrecip")


  if(nrow(myresults) == 0){
    warning("No results for this query.", call. = FALSE)
  } else {
  return(myresults)
  }
 }
