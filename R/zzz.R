.onLoad <- function(libname, pkgname) {
   modules <- paste0("stan_fit4", names(stanmodels), "_mod")
   for (m in modules) Rcpp::loadModule(m, what = TRUE)
}
