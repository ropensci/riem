test_that("riem_stations returns the right output",{
  httptest2::with_mock_dir(file.path("fixtures", "stations"), {
    output <- riem_stations(network = "IN__ASOS")
  })
  expect_s3_class(output, "tbl_df")
  expect_type(output$id, "character")
  expect_type(output$name, "character")
  expect_type(output$longitude, "double")
  expect_type(output$latitude, "double")
})


test_that("riem_stations returns error if code does not exist",{
  httptest2::with_mock_dir(file.path("fixtures", "networks"), {
    expect_snapshot_error(riem_stations(network = NULL))
    expect_snapshot_error(riem_stations(network = "IN__ASOS2"))
  })

})
