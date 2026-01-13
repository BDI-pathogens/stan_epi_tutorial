data {
  int<lower=0> t1;
  int<lower=0> t2;
  int<lower=0> tmax;
  array[tmax] int observed;
  real prior_R0_min;
    real prior_R0_max;
  real prior_infections0_min;
  real prior_infections0_max;
  real prior_sigma_dR_max;
}

parameters {
  real<lower=prior_infections0_min,upper=prior_infections0_max> infections0;
  real<lower=prior_R0_min,upper=prior_R0_max> R0;
  real<lower=0,upper=prior_sigma_dR_max> sigma_dR;
  array[tmax] real<lower=-prior_sigma_dR_max*4,upper=prior_sigma_dR_max*4> dR;
}

transformed parameters {
  array[tmax] real R;
  array[tmax+t2] real infections;
  real new_infections;

  // calculate R
  R[1] = R0;
  for( t in 2:tmax )
    R[t] = R[t-1] + dR[t];

  // calculate infections
  for( t in 1:t2 )
    infections[ t ] = infections0;

  for( t in 1:tmax)
  {
    new_infections = 0;
    for( tau in t1:t2 )
      new_infections = new_infections + infections[ t + t2 - tau ];
    new_infections = new_infections / (t2 - t1 + 1);
    infections[ t + t2 ] = new_infections * R[ t ];
  }
}

model {
  // increments are normal (Gaussian process)
  dR ~ normal( 0, sigma_dR );

  // observed is poisson distributed
  observed ~ poisson( infections[ (t2+1):(t2+tmax)] );
}

