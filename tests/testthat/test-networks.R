test_that("riem_networks returns the right output", {
  httptest2::with_mock_dir(file.path("fixtures", "networks"), {
    output <- riem_networks()
  })
  expect_s3_class(output, "tbl_df")
  expect_type(output$code, "character")
  expect_type(output$name, "character")
})

test_that("riem_networks errors if API error", {
  my_mock <- function(req) {
    httr2::response(status_code = 502)
  }
  httr2::local_mocked_responses(my_mock)
  expect_snapshot_error(riem_networks())
})
