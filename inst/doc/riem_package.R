## ---- echo = FALSE-------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

## ----eval = FALSE--------------------------------------------------------
#  install.packages("riem")

## ---- eval = FALSE-------------------------------------------------------
#  library("devtools")
#  install_github("ropenscilabs/riem")
#  

## ---- warning = FALSE, message = FALSE-----------------------------------
library("riem")
riem_networks() 

## ------------------------------------------------------------------------
riem_stations(network = "IN__ASOS") 

## ------------------------------------------------------------------------
measures <- riem_measures(station = "VOHY", date_start = "2000-01-01", date_end = "2016-04-22") 
head(measures)

