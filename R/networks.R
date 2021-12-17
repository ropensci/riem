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
  resp <- httr::GET("http://mesonet.agron.iastate.edu/api/1/networks.json")# nolint
  httr::stop_for_status(resp)

  content <- jsonlite::fromJSON(
    httr::content(
      resp, as ="text"
      )
    )

  names <- content$data$name
  codes <- content$data$id
  whichASOS <- grepl("ASOS", codes) | grepl("AWOS", codes)
  codes <- codes[whichASOS]
  names <- names[whichASOS]
  tibble::tibble(code = codes,
                 name = names)
}
