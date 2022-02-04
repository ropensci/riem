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
  req <- "http://mesonet.agron.iastate.edu/api/1/networks.json" %>%
    httr2::request() %>%
    httr2::req_user_agent("riem (https://docs.ropensci.org/riem)") %>%
    httr2::req_perform()

  content <- httr2::resp_body_json(req)

  networks_data <- tibble::tibble(
    code = purrr::map_chr(content[["data"]], "id"),
    name = purrr::map_chr(content[["data"]], "name")
  )

  is_ASOS <- grepl("A[SW]OS", networks_data$code)

  networks_data[is_ASOS,]
}
