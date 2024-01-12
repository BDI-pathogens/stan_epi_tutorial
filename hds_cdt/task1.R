########################################################################
#
#  Task 1 - implement simple model to estimate R(t)
#
#
#########################################################################
library( rstan )
library( plotly )
library( matrixStats )

# load the data to model
file_data <- "hds_cdt/data/task1.R"
load( file_data )

# STEP1 - plot the observed data
plot_ly( x = 1:data$tmax, y = data$observed, type = "scatter", mode = "points")

# STEP2 - implement the Stan model and compile the code
file_stan <- "hds_cdt/model.stan"
model     <- stan_model( file_stan )

# STEP3 - build the input data
tmax <- data$tmax
stan_data <- list(
  t1   = data$t1,
  t2   = data$t2,
  tmax = tmax,
  observed = data$observed[1:tmax],
  prior_R0_min       = 1,
  prior_R0_max       = 2.5,
  prior_infections0_min   = 0.5,
  prior_infections0_max   = 10,
  prior_sigma_dR_max = 0.15
)

# STEP4 - run the stan simulation
raw <- sampling(
  model,
  data = stan_data,
  pars = c( "R"),
  chains = 2,
  iter   = 1e3
)
ext <- extract( raw )

# STEP5 - plot the 90% confidence interval for R(t)
R_05 <- colQuantiles( ext$R, probs = 0.05)
R_50 <- colQuantiles( ext$R, probs = 0.50)
R_95 <- colQuantiles( ext$R, probs = 0.95)
plot_ly( x = 1:tmax, y = ~R_05, type = "scatter", mode = "lines", showlegend = FALSE, line = list( width = 0 ) ) %>%
  add_trace( y = ~R_95,  fill = "tonexty", fillcolor = "rgba(0,0,0.5,0.3)") %>%
  add_trace( y = ~R_50, line = list( color = rgb(0,0,0.5), width= 3 ) ) %>%
  layout( xaxis = list( title = "time"), yaxis = list( totle = "R(t)"))




