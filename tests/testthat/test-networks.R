library("riem")
context("networks")
test_that("riem_networks returns the right output",{
  output <- riem_networks()
  expect_is(output, "tbl_df")
  expect_is(output$code, "factor")
  expect_is(output$name, "factor")
})
