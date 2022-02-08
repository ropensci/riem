#' @importFrom utils read.table
#' @importFrom magrittr %>%
#' @importFrom rlang !!!

perform_riem_request <- function(path, query = NULL) {
  "https://mesonet.agron.iastate.edu/" %>%
    httr2::request() %>%
    httr2::req_url_path_append(path) %>%
    httr2::req_url_query(!!!query) %>%
    httr2::req_user_agent("riem (https://docs.ropensci.org/riem)") %>%
    httr2::req_retry(max_tries = 3, max_seconds = 120) %>%
    httr2::req_perform()
}
