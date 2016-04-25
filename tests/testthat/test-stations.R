library("riem")
context("stations")
test_that("riem_stations returns the right output",{
  skip_on_cran()
  output <- riem_stations(network = "IN__ASOS")
  expect_is(output, "tbl_df")
  expect_is(output$id, "character")
  expect_is(output$name, "character")
  expect_is(output$lon, "numeric")
  expect_is(output$lat, "numeric")
})


test_that("riem_stations returns error if code does not exist",{
  skip_on_cran()
  expect_error(riem_stations(network = "IN__ASOS2"),
               "IN__ASOS2 is not a valid network code")
})
