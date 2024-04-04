#' Get ASOS and AWOS networks
#'
#' @return a data.frame (tibble tibble) with the names and codes of
#' available networks.
#' @export
#'
#' @examples
#' \dontrun{
#' riem_networks()
#' }
riem_networks <- function() {
  resp <- perform_riem_request(path = "api/1/networks.json") # nolint: nonportable_path_linter

  httr2::resp_check_status(resp)

  content <- httr2::resp_body_json(resp)

  networks_data <- tibble::tibble(
    code = purrr::map_chr(content[["data"]], "id"),
    name = purrr::map_chr(content[["data"]], "name")
  )

  is_asos_or_awos <- grepl("A[SW]OS", networks_data[["code"]])

  networks_data[is_asos_or_awos, ]
}
