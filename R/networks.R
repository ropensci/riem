#' Function for getting ASOS and AWOS networks
#'
#' @return a data.frame (tibble tibble) with the names and codes of available networks.
#' @export
#'
#' @examples
#' \dontrun{
#' riem_networks()
#' }
riem_networks <- function(){
  resp <- httr::GET("http://mesonet.agron.iastate.edu/geojson/networks.geojson")# nolint
  httr::stop_for_status(resp)

  content <- jsonlite::fromJSON(
    httr::content(
      resp, as ="text"
      )
    )

  names <- content$features$properties$name
  codes <- content$features$id
  whichASOS <- grepl("ASOS", codes) | grepl("AWOS", codes)
  codes <- codes[whichASOS]
  names <- names[whichASOS]
  tibble::tibble(code = codes,
                 name = names)
}
