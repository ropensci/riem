library("riem")
context("stations")
test_that("riem_stations returns the right output",{
  vcr::use_cassette("stations", {
  output <- riem_stations(network = "IN__ASOS")
  })
  expect_is(output, "tbl_df")
  expect_is(output$id, "character")
  expect_is(output$name, "character")
  expect_is(output$lon, "numeric")
  expect_is(output$lat, "numeric")
})


test_that("riem_stations returns error if code does not exist",{
  vcr::use_cassette("stations-wrong-code", {
    expect_error(riem_stations(network = "IN__ASOS2"),
                 "IN__ASOS2 is not a valid network code")
  })

})
