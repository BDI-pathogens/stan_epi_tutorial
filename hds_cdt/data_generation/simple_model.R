# generate sample data for tasks for the HDS CDT tutorial
library( data.table )
set.seed( 1 )

# the simple renewal equation model with imperfect observations
# c_t = R_t sum_tau 1(tau >= t1)  !( tau<=t2) / (t2-t1+1)
# o_t \sim P( c_t )

t1 = 4
t2 = 8

Rm   = 2
R_min = 0.5
tR_0 = 30
tmax = 50
infections0   = 0.2
t_burn = 20

# calculate c(t)
infections = rep( infections0, t2)
for( tdx in 1:(tmax+t_burn))
{
  t = length( infections ) + 1
  new_infections = 0
  for( tau in t1:t2 )
    new_infections = new_infections + infections[ t - tau ]
  new_infections = new_infections / (t2 - t1 + 1)

  R = max( Rm - (Rm-1) * (max( tdx - t_burn, 1 ) /tR_0)^2, R_min )
  infections[ t ] = new_infections * R
}
observed = rpois( tmax, infections[ (1:tmax)+t2+t_burn ] )

file = "hds_cdt/data/task1a.RData"
data = list( tmax = tmax, observed = observed, t1 = t1, t2 = t2 )
save( data, file = file )




