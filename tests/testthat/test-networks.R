library("riem")
context("networks")
test_that("riem_networks returns the right output",{
  vcr::use_cassette("networks", {
  output <- riem_networks()
  })
  expect_is(output, "tbl_df")
  expect_is(output$code, "character")
  expect_is(output$name, "character")
})
