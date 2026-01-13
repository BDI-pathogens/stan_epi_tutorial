data {
 // In the data block all data and constants must be listed with data types
 // Examples

 // A real variable called r1
 real r1;

 // A integer variable called n1
 int<lower=0> n1;

 // An array called my_array of n1 intergers
 array[n1] int my_array;
}

parameters {
  // All parameters in the model which are sampled directly are listed here
  // Examples:

  // A real vairable called p1 which is between 0 and r1 in value
  real<lower=0,upper=r1> p1;

  // An array of reals called p_array of n1 values between 0 and r1
  array[n1] real<lower=0,upper=r1> p_array;
}

transformed parameters {
  // Derived variables from the sampled parametrs
  // Examples - a simple randomw walk

  // An array of reals called walk and length n1
  array[n1] real walk;

  walk[1] = p1;
  for( idx in 2:n1 )
     walk[idx] = walk[idx-1] + p_array[idx];
}

model {
  // Calculate the posterior liklihood of the model given the data

  // p_array is normall distributed with mean 0 and s.d. r1
  p_array ~ normal( 0, r1 );

  // observed is poisson distributed
  my_array ~ poisson( walk );
}

