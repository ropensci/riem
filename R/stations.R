#' Function for getting stations of an ASOS network
#'
#' @importFrom dplyr select_ "%>%" tbl_df mutate_
#' @importFrom lazyeval interp
#'
#' @param network A single network code, see riem_networks() for finding the code corresponding to a name.
#' @return a data.frame (dplyr tbl_df) with the id, name, longitude (lon) and latitude (lat) of each station in the network.
#' @details You can see a map of stations in a network at \url{https://mesonet.agron.iastate.edu/request/download.phtml}.
#' @export
#'
#' @examples
#' riem_stations(network = "IN__ASOS")
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

  link <- paste0("http://mesonet.agron.iastate.edu/json/network.php?network=",
                 network)

  content <- fromJSON(link)
  tbl_df(content$stations) %>%
    select_(quote(- combo)) %>%
    mutate_(lon = interp(~ as.numeric(lon))) %>%
    mutate_(lat = interp(~ as.numeric(lat)))
}
