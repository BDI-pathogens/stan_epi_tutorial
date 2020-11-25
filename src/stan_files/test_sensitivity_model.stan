data
{
  int<lower=0> N;
  int days_since_onset[N];
  int<lower=0> pcr_result[N];
}

transformed data
{
  int adj_days[N];
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
  real<lower=0> sensitivity[ total_days ];
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

