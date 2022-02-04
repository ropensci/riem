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
  resp <- "http://mesonet.agron.iastate.edu/api/1/networks.json" %>%
    httr2::request() %>%
    httr2::req_user_agent("riem (https://docs.ropensci.org/riem)") %>%
    httr2::req_retry(max_tries = 3, max_seconds = 120) %>%
    httr2::req_perform()

  httr2::resp_check_status(resp)

  content <- httr2::resp_body_json(resp)

  networks_data <- tibble::tibble(
    code = purrr::map_chr(content[["data"]], "id"),
    name = purrr::map_chr(content[["data"]], "name")
  )

  is_asos_or_awos <- grepl("A[SW]OS", networks_data$code)

  networks_data[is_asos_or_awos,]
}
