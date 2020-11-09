data{
  vector[ 10 ] x;
}

parameters{
  real<lower=0,upper=100> mean_x;
  real<lower=0,upper=100> sd_x;
}

model
{
  mean_x ~ normal( 10, 5 );
  x ~ normal( mean_x, sd_x );
}
