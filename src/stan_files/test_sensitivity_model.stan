data
{
  int<lower=0> N;
  array[N] int days_since_onset;
  array[N]int<lower=0> pcr_result;
}

transformed data
{
  array[N] int adj_days;
  int min_days;
  int max_days;
  int total_days;

  min_days   = min( days_since_onset );
  max_days   = max( days_since_onset );
  total_days = max_days - min_days + 1;

  for( i in 1:N )
  {
    adj_days[ i ] = days_since_onset[ i ] - min_days + 1;
  }
}

parameters
{
  real<lower=0,upper=1> peak_sensitivity;
  real peak_sensitivity_offset;
  real<lower=0.1> peak_sensitivity_width;
}

transformed parameters
{
  array[ total_days ] real<lower=0> sensitivity;
  real z;
  real factor;

  factor = peak_sensitivity;
  for( i in 1:total_days )
  {
    z = ( i + min_days -1 - peak_sensitivity_offset) / peak_sensitivity_width;
    sensitivity[ i ] = factor * exp( - z * z / 2  );
  }
}

model
{
    pcr_result ~ bernoulli( sensitivity[ adj_days ] );
}

