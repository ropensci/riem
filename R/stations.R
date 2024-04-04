#' Get stations of an ASOS network
#'
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
riem_stations <- function(network = NULL) {
  valid_network_code <- !is.null(network) && (network %in% riem_networks()$code)
  if (!valid_network_code) error_invalid_network(network)

  resp <- perform_riem_request(
    path = sprintf("api/1/network/%s.json", network)
  )

  httr2::resp_check_status(resp)

  content <- httr2::resp_body_json(resp)

  results <- content[["data"]] %>%
    purrr::map_df(function(x) tibble::as_tibble(purrr::compact(x)))


  results <- results[, !names(results) == "combo"]
  results$lon <- as.numeric(results$longitude)
  results$lat <- as.numeric(results$latitude)

  return(results)
}

error_invalid_network <- function(network) {
  rlang::abort(
    c(
      x = sprintf("%s is an invalid network code.", as.character(network %||% "null")),
      i = "See riem_networks() for valid codes."
    )
  )
}
