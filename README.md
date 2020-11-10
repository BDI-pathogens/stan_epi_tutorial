# Bayesian Modelling in Epidemiology using Stan

This is a tutorial on using the Bayesian modelling package Stan (and its R interface) in epidemiology modelling.
Stan is a widely used package for Bayesian modelling in many fields (e.g. economics, finance, statistical genetics).
It is continually being developed, in general is exceedingly fast and has excellent documentation (https://mc-stan.org/).

The key features of STAN are:
1. **Advanced MCMC sampling methods** - the default MCMC sampler used by the Stan is the NUTS alogrithm (no u-turn sampling). This is based on the Hamiltonian MCMC algorithm, but with additional initial steps to optimise the parameters used in the Hamiltonion MCMC algorithm. In practice this gives a state-of-the-art sampling method which is exceedinly efficient out-of-the-box without additional tuning. 
2. **Numerical Optimisation methods** - Stan contains numerical optmisers (e.g. L-BFGS method) which allows the MAP estimate to be immediately calculated for any model (which is set up for MCMC).
3. **Compiles Models to C++** - all models in Stan are pre-compiled and then sampling/optimisation is run natively in C++. This gives huge speed-ups compared to running code directly in a scripting language such as R.
4. **Reverse-Mode Automated Differentiaion (AD)** - the Hamiltonian MCMC method requires the derivative of the likelihood function with resepct to all the parameters, which for complicated models can be quite challenging both in terms of speed and numerical accuracy. AD is a method which does use numerical finite differencing for calculating gradients so does not have the standard numerical accuracy issues.
5. **Clean Interfaces** - Stan provides a high level language for describing statistical models (which it then compiles to C++). Whilst there is an initital small learning curve, the interfaces require the data, parameters and the model to be clearly stated which makes code much easier to understand.
6. **R Interface** - R contains an interface for Stan which allows for models to be written, built and run directly from R. Models can also be integrated in to R pacakges which mean that they are only compiled when the package is installed.
7. **Documentation/Community** - the Stan website (https://mc-stan.org/) contains extensive (500+ pages) of documentation and examples, showing you how to build models. Additionally, there are a large number of users worldwide, so Googling/StackOverflow etc.. will provide answers to your questions.

[We will now build a model for estimating R(t) using a state-space model in Stan](/https://github.com/BDI-pathogens/stan_epi_tutorial/edit/main/infection_model.md).
