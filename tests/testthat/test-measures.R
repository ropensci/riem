#######################
# test required params
#######################

test_that("riem_measures fails if required 'station' param is absent", {
  expect_snapshot_error(riem_measures(date_start = "2014-03-01"))
})

test_that("riem_measures fails if required 'date_start' param is absent", {
  expect_snapshot_error(riem_measures(station = "VOHY"))
})


###################
# param validation
###################

test_that("riem_measures validates 'station' param", {
  # wrong type
  expect_snapshot_error(riem_measures(station = 11111L,
                                      date_start = "2014-03-01"))
  # invalid value
  expect_snapshot_error(riem_measures(station = "ZZZZZ",
                                      date_start = "2014-03-01"))
})

test_that("riem_measures validates dates", {
  # date_start is invalid value
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "somethingelse"))
  # date_start is badly formatted
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2015 31 01"))

  # date_end is invalid value
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      date_end = "somethingelse"))
  # date_end is badly formatted
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      date_end = "2015 31 01"))

  # date_end is before date_start
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2015-12-01",
                                      date_end = "2013-12-01"))
})

test_that("riem_measures validates 'elev' param", {
  # wrong type
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      elev = 11111L))
  # wrong type
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      elev = "ZZZZZ"))
})

test_that("riem_measures validates 'latlon' param", {
  # wrong type
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      latlon = 11111L))
  # wrong type
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      latlon = "ZZZZZ"))
})

test_that("riem_measures validates 'report_type' param", {
  # wrong type
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      report_type = 11111L))
  # 1 invalid value (of 1)
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      report_type = "ZZZZZ"))
  # 1 invalid value (of multiple)
  expect_snapshot_error(riem_measures(station = "VOHY",
                                      date_start = "2014-03-01",
                                      report_type = c("routine", "ZZZZZ")))
})


###################
# nominal behavior
###################

test_that("riem_measures returns the right output for a default query", {
  httptest2::with_mock_dir(file.path("fixtures", "measures"), {
    output <- riem_measures(
      station = "VOHY",
      date_start = "2014-03-01",
      date_end = "2014-04-05" # keep it bounded and deterministic
    )
  })
  expect_s3_class(output, "tbl_df")

  expect_setequal(names(output), c("station", "valid", "lon", "lat", "tmpf", "dwpf", "relh", "drct", "sknt", "p01i", "alti", "mslp", "vsby", "gust", "skyc1", "skyc2", "skyc3", "skyc4", "skyl1", "skyl2", "skyl3", "skyl4", "wxcodes", "feel", "ice_accretion_1hr", "ice_accretion_3hr", "ice_accretion_6hr", "peak_wind_gust", "peak_wind_drct", "peak_wind_time", "metar", "snowdepth")) # nolint: line_length_linter

  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["lon"]], "double")
  expect_type(output[["lat"]], "double")
  expect_type(output[["tmpf"]], "double")
  expect_type(output[["dwpf"]], "double")
  expect_type(output[["relh"]], "double")
  expect_type(output[["drct"]], "double")
  expect_type(output[["sknt"]], "double")
  expect_type(output[["p01i"]], "double")
  expect_type(output[["alti"]], "double")
  expect_true(class(output[["mslp"]]) %in% c("character", "logical")) # nolint: class_equals_linter
  expect_type(output[["vsby"]], "double")
  expect_true(class(output[["gust"]]) %in% c("character", "numeric", "logical")) # nolint: class_equals_linter
  expect_type(output[["skyc1"]], "character")
  expect_type(output[["skyc2"]], "character")
  expect_type(output[["skyc3"]], "character")
  expect_type(output[["skyc4"]], "character")
  expect_type(output[["skyl1"]], "double")
  expect_type(output[["skyl2"]], "double")
  expect_type(output[["skyl3"]], "double")
  expect_type(output[["skyl4"]], "double")
  expect_type(output[["wxcodes"]], "character")
  expect_type(output[["metar"]], "character")
})

test_that("riem_measures parses all params", {
  httptest2::with_mock_dir(file.path("fixtures", "measures2"), {
    output <- riem_measures(
      station = "VOHY",
      date_start = "2014-03-01",
      date_end = "2014-04-05", # keep it bounded and deterministic
      data = "tmpf", # single field (not 'all')
      elev = TRUE, # opposite default value
      latlon = FALSE, # opposite default value
      report_type = "specials"
    )
  })
  expect_s3_class(output, "tbl_df")

  expect_setequal(names(output), c("station", "valid", "elevation", "tmpf"))

  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["tmpf"]], "double")
  expect_type(output[["elevation"]], "double")

  httptest2::with_mock_dir(file.path("fixtures", "measures2"), {
    output <- riem_measures(
      station = "VOHY",
      date_start = "2014-03-01",
      date_end = "2014-04-05", # keep it bounded and deterministic
      data = c("tmpf", "dwpf"), # multiple fields
      elev = TRUE, # opposite default value
      latlon = FALSE, # opposite default value
      report_type = "specials"
    )
  })
  expect_s3_class(output, "tbl_df")

  expect_setequal(names(output), c("station", "valid", "elevation", "tmpf", "dwpf"))

  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["tmpf"]], "double")
  expect_type(output[["dwpf"]], "double")
  expect_type(output[["elevation"]], "double")
})

test_that("riem_measures provides proper report types (6 combinations)", {
  # report_type = hfmetar
  httptest2::with_mock_dir(file.path("fixtures", "measures3"), {
    output <- riem_measures(
      station = "KCVG", # choose a second station (VOHY used elsewhere)
      date_start = "2024-03-01",
      date_end = "2024-03-02", # keep it bounded and deterministic
      data = "metar", # single field (not 'all')
      elev = FALSE,
      latlon = FALSE,
      report_type = "hfmetar"
    )
  })
  expect_s3_class(output, "tbl_df")
  expect_setequal(names(output), c("station", "valid", "metar"))
  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["metar"]], "character")

  # report_type = routine
  httptest2::with_mock_dir(file.path("fixtures", "measures3"), {
    output <- riem_measures(
      station = "KCVG", # choose a second station (VOHY used elsewhere)
      date_start = "2024-03-01",
      date_end = "2024-03-02", # keep it bounded and deterministic
      data = "metar", # single field (not 'all')
      elev = FALSE,
      latlon = FALSE,
      report_type = "routine"
    )
  })
  expect_s3_class(output, "tbl_df")
  expect_setequal(names(output), c("station", "valid", "metar"))
  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["metar"]], "character")

  # report_type = specials
  httptest2::with_mock_dir(file.path("fixtures", "measures3"), {
    output <- riem_measures(
      station = "KCVG", # choose a second station (VOHY used elsewhere)
      date_start = "2024-03-01",
      date_end = "2024-03-02", # keep it bounded and deterministic
      data = "metar", # single field (not 'all')
      elev = FALSE,
      latlon = FALSE,
      report_type = "specials"
    )
  })
  expect_s3_class(output, "tbl_df")
  expect_setequal(names(output), c("station", "valid", "metar"))
  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["metar"]], "character")

  # report_type = hfmetar, routine
  httptest2::with_mock_dir(file.path("fixtures", "measures3"), {
    output <- riem_measures(
      station = "KCVG", # choose a second station (VOHY used elsewhere)
      date_start = "2024-03-01",
      date_end = "2024-03-02", # keep it bounded and deterministic
      data = "metar", # single field (not 'all')
      elev = FALSE,
      latlon = FALSE,
      report_type = c("hfmetar", "routine")
    )
  })
  expect_s3_class(output, "tbl_df")
  expect_setequal(names(output), c("station", "valid", "metar"))
  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["metar"]], "character")

  # report_type = hfmetar, specials
  httptest2::with_mock_dir(file.path("fixtures", "measures3"), {
    output <- riem_measures(
      station = "KCVG", # choose a second station (VOHY used elsewhere)
      date_start = "2024-03-01",
      date_end = "2024-03-02", # keep it bounded and deterministic
      data = "metar", # single field (not 'all')
      elev = FALSE,
      latlon = FALSE,
      report_type = c("hfmetar", "specials")
    )
  })
  expect_s3_class(output, "tbl_df")
  expect_setequal(names(output), c("station", "valid", "metar"))
  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["metar"]], "character")

  # report_type = hfmetar, routine, specials
  httptest2::with_mock_dir(file.path("fixtures", "measures3"), {
    output <- riem_measures(
      station = "KCVG", # choose a second station (VOHY used elsewhere)
      date_start = "2024-03-01",
      date_end = "2024-03-02", # keep it bounded and deterministic
      data = "metar", # single field (not 'all')
      elev = FALSE,
      latlon = FALSE,
      report_type = c("hfmetar", "routine", "specials")
    )
  })
  expect_s3_class(output, "tbl_df")
  expect_setequal(names(output), c("station", "valid", "metar"))
  expect_type(output[["station"]], "character")
  expect_s3_class(output[["valid"]], "POSIXct")
  expect_type(output[["metar"]], "character")
})

test_that("riem_measures outputs warning if no results", {
  httptest2::with_mock_dir(file.path("fixtures", "warnings"), {
    expect_warning(
      riem_measures(
        station = "VOHY",
        date_start = "3050-12-01",
        date_end = "3055-12-01"
      ),
      "No results for this query."
    )
  })
})
