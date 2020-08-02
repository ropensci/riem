library("riem")
context("measures")
test_that("riem_measures returns the right output",{
  skip_on_cran()
  output <- riem_measures(station = "VOHY", date_start = "2014-01-01",
                          date_end = "2016-04-22")
  expect_is(output, "tbl_df")
  expect_is(output$station, "character")
  expect_is(output$valid, "POSIXct")
  expect_is(output$lon, "numeric")
  expect_is(output$lat, "numeric")
  expect_is(output$tmpf, "numeric")
  expect_is(output$dwpf, "numeric")
  expect_is(output$relh, "numeric")
  expect_is(output$drct, "numeric")
  expect_is(output$sknt, "numeric")
  expect_is(output$p01i, "numeric")
  expect_is(output$alti, "numeric")
  expect_true(class(output$mslp) %in% c("character", "logical"))
  expect_is(output$vsby, "numeric")
  expect_true(class(output$gust) %in% c("character", "numeric"))
  expect_is(output$skyc1, "character")
  expect_is(output$skyc2, "character")
  expect_is(output$skyc3, "character")
  expect_is(output$skyc4, "character")
  expect_is(output$skyl1, "numeric")
  expect_is(output$skyl2, "numeric")
  expect_is(output$skyl3, "numeric")
  expect_is(output$skyl4, "numeric")
  expect_is(output$wxcodes, "character")
  expect_is(output$metar, "character")})

test_that("riem_measures outputs warning if no results",{
  skip_on_cran()
  expect_warning(riem_measures(date_start = "3050-12-01",
                               date_end = "3055-12-01"),
                 "No results for this query.")
})

test_that("riem_measures checks dates",{
  expect_error(riem_measures(date_start = "somethingelse"),
               "date_start has to be formatted")
  expect_error(riem_measures(date_end = "somethingelse"),
               "date_end has to be formatted like")
  expect_error(riem_measures(date_start = "2015 31 01"),
               "date_start has to be formatted like")
  expect_error(riem_measures(date_end = "2015 31 01"),
               "date_end has to be formatted like")
  expect_error(riem_measures(date_start = "2015-12-01",
                             date_end = "2013-12-01"),
               "date_end has to be bigger than date_start")
})

test_that("riem_measures returns correct values when alternate arguments to missing are passed",{
  skip_on_cran()
  output <- riem_measures(station = "VOHY", date_start = "2014-01-01",
                          date_end = "2016-04-22", missing = "M")
  expect_is(output$mslp, "character")
})

test_that("riem_measures returns correct values when alternate arguments to trace are passed, if possible",{
  skip_on_cran()
  output <- riem_measures(station = "KGTF", date_start = "2014-01-01",
                          date_end = "2016-04-22", trace = "T")
  expect_is(output$poli, "character")
})
