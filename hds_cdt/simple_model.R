########################################################################
#
#  Run the simple code example from the lecture
#
#
#########################################################################

library( rstan )

# STEP1 - simulate some data
set.seed(2)
n1 <- 30
r1 <- 5
my_array <- rpois( n1, r1 + cumsum( rnorm( n1, sd = r1 )))

# STEP2 - implement the Stan model and compile the code
file_stan <- "hds_cdt/simple_model.stan"
model     <- stan_model( file_stan )

# STEP3 - build the input data
stan_data <- list(
  r1 = r1,
  n1 = n1,
  my_array = my_array
)

# STEP4 - run the stan simulation
raw <- sampling(
  model,
  data = stan_data,
  pars = c( "p1", "walk"),
  chains = 2,
  iter   = 1e3
)
ext <- extract( raw )

# STEP5 - plot the means
plot( 1:n1, colMeans( ext$walk))
plot( 1:n1, my_array)




