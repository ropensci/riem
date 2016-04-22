check_network <- function(network_code){
  codes <- riem_networks()$codes

  if(network_code %in% codes){
    stop(paste(network_code, "is not the code of an ASOS network"))
  }
}
