###################################################################################/
# stanepi.infection_model
#
# Stan model for estimating R
###################################################################################/
stanepi.infection_model= function()
{
  return( stanmodels$infection_model )
}

###################################################################################/
# stanepi.test_sensitivity_model
#
# Stan model for test sensitivity
###################################################################################/
stanepi.test_sensitivity_model= function()
{
  return( stanmodels$test_sensitivity_model )
}
