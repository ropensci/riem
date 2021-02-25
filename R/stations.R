#' Function for getting stations of an ASOS network
#'
#' @param network A single network code, see riem_networks() for finding the code corresponding to a name.
#' @return a data.frame (tibble tibble) with the id, name, longitude (lon) and latitude (lat) of each station in the network.
#' @details You can see a map of stations in a network at \url{https://mesonet.agron.iastate.edu/request/download.phtml}.
#' @export
#'
#' @examples
#' \dontrun{
#' riem_stations(network = "IN__ASOS")
#' }
riem_stations <- function(network = NULL){

  if(is.null(network)){
    stop("Please provide a network code",
         call. = FALSE)
  }

  if(!(network %in% riem_networks()$code)){
    stop(paste0(network,
                " is not a valid network code. See riem_networks()"),
         call. = FALSE) # nolint
  }

  link <- paste0("http://mesonet.agron.iastate.edu/api/1/network/", network, ".json")

  resp <- httr::GET(link)
  httr::stop_for_status(resp)

  content <- jsonlite::fromJSON(
    httr::content(
      resp, as ="text"
    )
  )

  results <- tibble::as_tibble(content$data)
  results <- results[, !names(results) == "combo"]
  results$lon <- as.numeric(results$longitude)
  results$lat <- as.numeric(results$latitude)

  return(results)
}
