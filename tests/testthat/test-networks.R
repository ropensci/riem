test_that("riem_networks returns the right output",{
  httptest2::with_mock_dir("fixtures", {
    output <- riem_networks()
  })
  expect_is(output, "tbl_df")
  expect_is(output$code, "character")
  expect_is(output$name, "character")
})
