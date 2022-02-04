test_that("riem_measures returns the right output",{
  httptest2::with_mock_dir(file.path("fixtures", "measures"), {
    output <- riem_measures(
      station = "VOHY",
      date_start = "2014-03-01",
      date_end = "2014-04-05"
    )
  })
  expect_s3_class(output, "tbl_df")
  expect_type(output$station, "character")
  expect_s3_class(output$valid, "POSIXct")
  expect_type(output$lon, "double")
  expect_type(output$lat, "double")
  expect_type(output$tmpf, "double")
  expect_type(output$dwpf, "double")
  expect_type(output$relh, "double")
  expect_type(output$drct, "double")
  expect_type(output$sknt, "double")
  expect_type(output$p01i, "double")
  expect_type(output$alti, "double")
  expect_true(class(output$mslp) %in% c("character", "logical"))
  expect_type(output$vsby, "double")
  expect_true(class(output$gust) %in% c("character", "numeric", "logical"))
  expect_type(output$skyc1, "character")
  expect_type(output$skyc2, "character")
  expect_type(output$skyc3, "character")
  expect_type(output$skyc4, "character")
  expect_type(output$skyl1, "double")
  expect_type(output$skyl2, "double")
  expect_type(output$skyl3, "double")
  expect_type(output$skyl4, "double")
  expect_type(output$wxcodes, "character")
  expect_type(output$metar, "character")
})


test_that("riem_measures outputs warning if no results",{
  vcr::use_cassette("measures-warnings", {
    expect_warning(
      riem_measures(
        date_start = "3050-12-01",
        date_end = "3055-12-01"),
      "No results for this query."
    )
  })
})

test_that("riem_measures checks dates",{
  expect_snapshot_error(riem_measures(date_start = "somethingelse"))

  expect_snapshot_error(riem_measures(date_end = "somethingelse"))

  expect_snapshot_error(riem_measures(date_start = "2015 31 01"))

  expect_snapshot_error(riem_measures(date_end = "2015 31 01"))

  expect_snapshot_error(
    riem_measures(
      date_start = "2015-12-01",
      date_end = "2013-12-01"
    )
  )
})

