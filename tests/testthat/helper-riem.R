library(httptest2)
httptest2::set_redactor(function (x) {
  httptest2::gsub_response(x, "mesonet.agron.iastate.edu/cgi-bin/request/", "api/")
})
