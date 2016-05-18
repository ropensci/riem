#' Function for getting ASOS and AWOS networks
#'
#' @return a data.frame (dplyr tbl_df) with the names and codes of available networks.
#' @export
#'
#' @examples
#' riem_networks()
riem_networks <- function(){
  content <- jsonlite::fromJSON("http://mesonet.agron.iastate.edu/geojson/networks.geojson")# nolint
  names <- content$features$properties$name
  codes <- content$features$id
  whichASOS <- grepl("ASOS", codes) | grepl("AWOS", codes)
  codes <- codes[whichASOS]
  names <- names[whichASOS]
  dplyr::tbl_df(data.frame(code = codes,
                           name = names))
}
