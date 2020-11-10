###################################################################################/
# stanepi.uk_covid_ts
#
# UK covid postiive test by specimen
# Use weekly symmetric smoothing because of large weekend effect
###################################################################################/
stanepi.uk_covid_ts = function( start = as.Date( "2020-08-01" ), end = as.Date( "2020-11-04") )
{
  file = system.file(  "data_2020-Nov-09.csv", package = "stanEpiTutorial")
  data = fread( file )
  data[ , date := as.Date( date )]
  data = data[ date >= start & date <= end, .( date, cases_raw = newCasesBySpecimenDate) ]
  data[ , cases_1wMA := round( ( shift( cumsum( cases_raw), 3, type = "lead" ) - shift( cumsum( cases_raw), 3, type = "lag" ) ) / 7 ) ]
  return( data )
}