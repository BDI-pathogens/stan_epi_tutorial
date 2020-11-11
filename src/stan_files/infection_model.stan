// the data (and hyper-parameters) which the model will be fit to
data{
  // observed data
  int<lower=1> t_max;              // total number of data points
  int<lower=0> obs_cases[ t_max ]; // observed cases

  // parameters to define priors
  real mu_g_min;                  // minimum for mean of generation time
  real mu_g_max;                  // maximum for mean of generation time
  real sd_g_min;                  // minimum for sd of generation time
  real sd_g_max;                  // maximum for sd of generation time
  real R_0_min;                   // minimum inital R
  real R_0_max;                   // maximum inital R
  real sigma_R_max;               // maximum of R daily change parameter
  real phi_od_max;                // maximum of obersvation over dispersion parameter
  int<lower=1> t_g;               // maximum time at which somebody can infect post-infection
}

// useful transformation of data which are calculated once
transformed data{
  int t_used = t_max - t_g;         // the number of data points estimated
  int obs_cases_used[ t_used ];     // the observed cases which we fit to
  vector[ t_used ] ones_t_used;     // a vector of ones of size t_used

  obs_cases_used = obs_cases[ (t_g+1):t_max ];
  for( i in 1:t_used )
    ones_t_used[ i ] = 1;
}

// sampled parameters (note range priors are set here)
parameters{
  real<lower=mu_g_min,upper=mu_g_max> mu_g; // mean of generation distribution
  real<lower=sd_g_min,upper=sd_g_max> sd_g; // sd of generatioion distribution
  real<lower=0,upper=sigma_R_max> sigma_R;  // size of daily change in R
  real<lower=0.001,upper=phi_od_max> phi_od;// observation over-dispersion parameter
  real<lower=R_0_min,upper=R_0_max> R_0;    // initial value of R
  vector[ t_used - 1 ] z;                   // daily increments of R
}

// transformation of the priors (this code can be in the model section too
transformed parameters{
  // calculate the kernel for the generation equation based on the sampled params
  real alpha_g = mu_g * mu_g / sd_g / sd_g;
  real beta_g  = mu_g / sd_g / sd_g;
  real g[ t_g ];
  real R[ t_used ];

  for( t in 1:t_g )
    g[t] = exp( gamma_lpdf( t | alpha_g, beta_g ) );

  // model of R
  R[1] = R_0;
  for( t in 1:(t_used-1) )
    R[t+1] = exp( log( R[t]) + sigma_R * z[t] );
}

// the likelihood of the data and the priors
model
{
  // calculate the time-series for the (hidden) number of infected people
  real expected;
  real infected[t_max];
  for( t in 1:t_g )
    infected[t] = obs_cases[t];
  for( t in (t_g+1):t_max )
  {
    expected = 0;
    for( t_i in 1:t_g )
      expected += infected[t-t_i] * g[t_i];
    infected[t] = expected * R[t-t_g];
  }

  // likelihood of observed cases given true cases
  obs_cases_used ~neg_binomial_2( infected[ (t_g+1):t_max ], ones_t_used / phi_od );

  // priors (except range priors)
  z ~ normal( 0, 1);
  //or likilhood can be add
  // target += -0.5 * dot_product( z, z);
}
