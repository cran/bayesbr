% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bayesbr.R
\name{bayesbr}
\alias{bayesbr}
\title{Bayesian Beta Regression with RStan}
\usage{
bayesbr(formula=NULL,data=NULL,m_neighborhood = NULL,
na.action=c("exclude","replace"),mean_betas = NULL,
variance_betas = NULL,mean_gammas = NULL,
variance_gammas = NULL ,iter = 10000,warmup = iter/2,
chains = 1,pars=NULL,a = NULL,b = NULL,
atau_delta = NULL, btau_delta = NULL,atau_xi = NULL,
btau_xi = NULL,rho = NULL,spatial_theta = NULL,spatial_zeta=NULL,
resid.type = c("quantile","sweighted",
            "pearson","ordinary"),...)
}
\arguments{
\item{formula}{symbolic description of the model (of type \code{y ~ x} or \code{y ~ x | z};). See more at \code{\link{formula}}}

\item{data}{data frame or list with the variables passed in the formula parameter, if \code{data = NULL} the function will use the existing variables in the global environment.}

\item{m_neighborhood}{A neighborhood matrix with n rows and n columns, with n the number of observations of the model to be adjusted. This matrix should only contain a value of 0 on the main diagonal, and a value of 0 or 1 at position i j, to inform whether observation i is next to observation j. It must be symmetric, because if i is a neighbor of j, j is also a neighbor of i. This matrix will be used to calculate the model's covariance matrix, if one of the conditions is not accepted or the neighborhood matrix is not informed, the model will be adjusted without the spatial effect.}

\item{na.action}{Characters provided or treatment used in NA values. If \code{na.action} is equal to exclude (default value), the row containing the NA will be excluded in all variables of the model. If \code{na.action} is equal to replace, the row containing the NA will be replaced by the average of the variable in all variables of the model.}

\item{mean_betas, variance_betas}{vectors including a priori information of mean and variance for the estimated beta respectively, beta is the name given to the coefficient of each covariate that influences theta. PS: the size of the vectors must equal p + 1, p being the number of covariates for theta.}

\item{mean_gammas, variance_gammas}{vectors including a priori information of mean and variance for the estimated ranges respectively, gamma is the name given to the coefficient of each covariate that influences zeta. PS: the size of the vectors must be equal to q + 1, q being the number of covariates for zeta.}

\item{iter}{A positive integer specifying the number of iterations for each chain (including warmup). The default is 10000.}

\item{warmup}{A positive integer specifying the number of iterations that will be in the warm-up period,
will soon be discarded when making the estimates and inferences. Warmup must be less than \code{iter} and its default value is \code{iter/2}.}

\item{chains}{A positive integer specifying the number of Markov chains. The default is 1.}

\item{pars}{A vector of character strings specifying parameters of interest. The default is NULL indicating all parameters in the model.}

\item{a, b}{Positive integer specifying the a priori information of the parameters of the gamma distribution for the zeta, if there are covariables explaining zeta \code{a} and \code{b} they will not be used. The default value for \code{a} is 1 and default value for \code{b} is 0.01 .}

\item{atau_delta, btau_delta, atau_xi, btau_xi}{Positive integer specifying the a priori information of tau parameter of the gamma distribution. The default value for \code{atau_delta} and \code{atau_xi} is 0.1 and default value for \code{btau_delta} and \code{btau_xi} is 0.1.}

\item{rho}{value of the time scaling parameter for calculate the covariance matrix.}

\item{spatial_theta, spatial_zeta}{A Boolean variable to inform whether the adjusted model will have an effect on the theta parameter, or on the zeta parameter or both parameters.}

\item{resid.type}{A character containing the residual type returned by the model among the possibilities. The type of residue can be \emph{quantile}, \emph{sweighted}, \emph{pearson} or \emph{ordinary}. The default is \emph{quantile}.}

\item{...}{Other optional parameters from RStan}
}
\value{
\code{bayesbr} return an object of class \emph{bayesbr}, a list of the following items.
\describe{\item{coefficients}{a list with the mean and precision elements containing the estimated coefficients of model and table with the means, medians, standard deviations and the Highest Posterior Density (HPD) Interval,}
\item{call}{the original function call,}
\item{formula}{the original formula,}
\item{y}{the response proportion vector,}
\item{stancode}{lines of code containing the .STAN file used to estimate the model,}
\item{info}{a list containing model information such as the argument pars passed as argument, name of variables, indicator for effect spatial in model, number of: iterations, warmups, chains, covariables for theta, covariables for zeta and observations of the sample. In addition there is an element called samples, with the posterior distribution of the parameters of interest,}
\item{fitted.values}{a vector containing the estimates for the values corresponding to the theta of each observation of the variable response, the estimate is made using the mean of the a prior theta distribution,}
\item{model}{the full model frame,}
\item{residuals}{a vector of residuals,}
\item{residuals.type}{the type of returned residual,}
\item{delta}{a matrix with the means, medians, standard deviations and the Highest Posterior Density (HPD) Interval of the delta parameter (spatial effect in theta parameter). The estimation for the delta parameter, informs the influence that a given region has on the response variable, neighboring observations are expected to have close estimates for delta.}
\item{xi}{a matrix with the means, medians, standard deviations and the Highest Posterior Density (HPD) Interval of the xi parameter (spatial effect in zeta parameter). The estimation for the xi parameter, informs the influence that a given region has on the response variable, neighboring observations are expected to have close estimates for xi.}
\item{loglik}{log-likelihood of the fitted model(using the mean of the parameters in the posterior distribution),}
\item{AIC}{a value containing the Akaike's Information Criterion (AIC) of the fitted model,}
\item{BIC}{a value containing the Bayesian Information Criterion (BIC) of the fitted model,}
\item{DIC}{a value containing the Deviance Information Criterion (DIC) of the fitted model,}
\item{WAIC}{a vector containing the Widely Applicable Information Criterion (WAIC) of the fitted model and their standard error, see more in \code{\link{waic}}}
\item{LOOIC}{a vector containing the LOO (Efficient approximate leave-one-out cross-validation) Information Criterion of the fitted model and their standard error, see more in \code{\link{loo}}}
\item{pseudo.r.squared}{pseudo-value of the square R (correlation to the square of the linear predictor and the a posteriori means of theta).}}
}
\description{
Fit of beta regression model under the view of Bayesian statistics,
using the mean of the posterior distribution as estimates for the mean (theta) and the precision parameter (zeta).
}
\details{
Beta Regression was suggested by Ferrari and Cribari-Neto (2004), but with the look of classical statistics, this package makes use of the \code{Rstan} to, from the prior distribution of the data, obtain the posterior distribution and the estimates from a Bayesian perspective. Beta regression is useful when the response variable is in the range between 0 and 1, being used for adjusting probabilities and proportions.

It is possible to estimate coefficients for the explanatory covariates for the theta and zeta parameters of the Beta distribution. Linear predictors are passed as parameters for both zeta and zeta, from these linear predictors a transformation of scales is made.

Hamiltonian Monte Carlo (HMC) is a Markov chain Monte Carlo (MCMC) algorithm, from the HMC there is an extension known as the No-U-Turn Sampler (NUTS) that makes use of recursion to obtain its calculations and is used by \code{RStan}. In the context of the \code{bayesbr} package, NUTS was used to obtain a posteriori distribution from model data and a priori distribution.

See \code{\link{predict.bayesbr}}, \code{\link{residuals.bayesbr}},\code{\link{summary.bayesbr}},\code{\link{logLik.bayesbr}} and \code{\link{pseudo.r.squared}} for more details on all methods. Because it is in the context of Bayesian statistics, in all calculations that were defined using maximum verisimilitude, this was sub-replaced by the mean of the posterior distribution of the parameters of interest of the formula.
}
\examples{
data("StressAnxiety",package="bayesbr")

bbr = bayesbr(anxiety ~ stress | stress, data = StressAnxiety,
             iter = 100)
summary(bbr)
residuals(bbr, type="ordinary")
print(bbr)


\donttest{
data("StressAnxiety", package = "bayesbr")
bbr2 <- bayesbr(anxiety ~ stress | stress,
               data = StressAnxiety, iter = 1000,
               warmup= 450, mean_betas = c(0,1),
               variance_betas = 15)

envelope(bbr2,sim=100,conf=0.95)
loglikPlot(bbr2$loglik)
}
}
\references{
\doi{10.1080/0266476042000214501} Ferrari, S.L.P., and Cribari-Neto, F. (2004).
Beta Regression for Modeling Rates and Proportions. \emph{Journal of Applied Statistics}, \bold{31}(7), 799--815.

\href{https://arxiv.org/abs/1111.4246}{arXiv:1111.4246} Hoffman, M. D., and Gelman, A. (2014). The No-U-Turn sampler: adaptively setting path lengths in Hamiltonian Monte Carlo. \emph{Journal of Machine Learning Research}, \bold{15}(1), 1593-1623.

\doi{10.18637/jss.v076.i01} Carpenter, B., Gelman, A., Hoffman, M. D., Lee, D., Goodrich, B., Betancourt, M., ... & Riddell, A. (2017). Stan: A probabilistic programming language. \emph{Journal of statistical software}, \bold{76}(1).
}
\seealso{
\code{\link{summary.bayesbr}}, \code{\link{residuals.bayesbr}}, \code{\link{formula}}
}
