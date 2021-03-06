#'@title Bayesian Beta Regression with RStan
#'@aliases bayesbr
#'@name bayesbr
#'@usage bayesbr(formula=NULL,data=NULL,m_neighborhood = NULL,
#'na.action=c("exclude","replace"),mean_betas = NULL,
#'variance_betas = NULL,mean_gammas = NULL,
#'variance_gammas = NULL ,iter = 10000,warmup = iter/2,
#'chains = 1,pars=NULL,a = NULL,b = NULL,
#'atau_delta = NULL, btau_delta = NULL,atau_xi = NULL,
#'btau_xi = NULL,rho = NULL,spatial_theta = NULL,spatial_zeta=NULL,
#'resid.type = c("quantile","sweighted",
#'             "pearson","ordinary"),...)
#'@param formula symbolic description of the model (of type \code{y ~ x} or \code{y ~ x | z};). See more at \code{\link{formula}}
#'@param data data frame or list with the variables passed in the formula parameter, if \code{data = NULL} the function will use the existing variables in the global environment.
#'@param m_neighborhood A neighborhood matrix with n rows and n columns, with n the number of observations of the model to be adjusted. This matrix should only contain a value of 0 on the main diagonal, and a value of 0 or 1 at position i j, to inform whether observation i is next to observation j. It must be symmetric, because if i is a neighbor of j, j is also a neighbor of i. This matrix will be used to calculate the model's covariance matrix, if one of the conditions is not accepted or the neighborhood matrix is not informed, the model will be adjusted without the spatial effect.
#'@param na.action Characters provided or treatment used in NA values. If \code{na.action} is equal to exclude (default value), the row containing the NA will be excluded in all variables of the model. If \code{na.action} is equal to replace, the row containing the NA will be replaced by the average of the variable in all variables of the model.
#'@param mean_betas,variance_betas vectors including a priori information of mean and variance for the estimated beta respectively, beta is the name given to the coefficient of each covariate that influences theta. PS: the size of the vectors must equal p + 1, p being the number of covariates for theta.
#'@param mean_gammas,variance_gammas vectors including a priori information of mean and variance for the estimated ranges respectively, gamma is the name given to the coefficient of each covariate that influences zeta. PS: the size of the vectors must be equal to q + 1, q being the number of covariates for zeta.
#'@param iter A positive integer specifying the number of iterations for each chain (including warmup). The default is 10000.
#'@param warmup A positive integer specifying the number of iterations that will be in the warm-up period,
#'will soon be discarded when making the estimates and inferences. Warmup must be less than \code{iter} and its default value is \code{iter/2}.
#'@param chains A positive integer specifying the number of Markov chains. The default is 1.
#'@param pars A vector of character strings specifying parameters of interest. The default is NULL indicating all parameters in the model.
#'@param a,b Positive integer specifying the a priori information of the parameters of the gamma distribution for the zeta, if there are covariables explaining zeta \code{a} and \code{b} they will not be used. The default value for \code{a} is 1 and default value for \code{b} is 0.01 .
#'@param atau_delta,btau_delta,atau_xi,btau_xi Positive integer specifying the a priori information of tau parameter of the gamma distribution. The default value for \code{atau_delta} and \code{atau_xi} is 0.1 and default value for \code{btau_delta} and \code{btau_xi} is 0.1.
#'@param spatial_theta,spatial_zeta A Boolean variable to inform whether the adjusted model will have an effect on the theta parameter, or on the zeta parameter or both parameters.
#'@param rho value of the time scaling parameter for calculate the covariance matrix.
#'@param resid.type A character containing the residual type returned by the model among the possibilities. The type of residue can be \emph{quantile}, \emph{sweighted}, \emph{pearson} or \emph{ordinary}. The default is \emph{quantile}.
#'@param ... 	Other optional parameters from RStan
#'@return   \code{bayesbr} return an object of class \emph{bayesbr}, a list of the following items.
#'\describe{\item{coefficients}{a list with the mean and precision elements containing the estimated coefficients of model and table with the means, medians, standard deviations and the Highest Posterior Density (HPD) Interval,}
#'\item{call}{the original function call,}
#'\item{formula}{the original formula,}
#'\item{y}{the response proportion vector,}
#'\item{stancode}{lines of code containing the .STAN file used to estimate the model,}
#'\item{info}{a list containing model information such as the argument pars passed as argument, name of variables, indicator for effect spatial in model, number of: iterations, warmups, chains, covariables for theta, covariables for zeta and observations of the sample. In addition there is an element called samples, with the posterior distribution of the parameters of interest,}
#'\item{fitted.values}{a vector containing the estimates for the values corresponding to the theta of each observation of the variable response, the estimate is made using the mean of the a prior theta distribution,}
#'\item{model}{the full model frame,}
#'\item{residuals}{a vector of residuals,}
#'\item{residuals.type}{the type of returned residual,}
#'\item{delta}{a matrix with the means, medians, standard deviations and the Highest Posterior Density (HPD) Interval of the delta parameter (spatial effect in theta parameter). The estimation for the delta parameter, informs the influence that a given region has on the response variable, neighboring observations are expected to have close estimates for delta.}
#'\item{xi}{a matrix with the means, medians, standard deviations and the Highest Posterior Density (HPD) Interval of the xi parameter (spatial effect in zeta parameter). The estimation for the xi parameter, informs the influence that a given region has on the response variable, neighboring observations are expected to have close estimates for xi.}
#'\item{loglik}{log-likelihood of the fitted model(using the mean of the parameters in the posterior distribution),}
#'\item{AIC}{a value containing the Akaike's Information Criterion (AIC) of the fitted model,}
#'\item{BIC}{a value containing the Bayesian Information Criterion (BIC) of the fitted model,}
#'\item{DIC}{a value containing the Deviance Information Criterion (DIC) of the fitted model,}
#'\item{WAIC}{a vector containing the Widely Applicable Information Criterion (WAIC) of the fitted model and their standard error, see more in \code{\link{waic}}}
#'\item{LOOIC}{a vector containing the LOO (Efficient approximate leave-one-out cross-validation) Information Criterion of the fitted model and their standard error, see more in \code{\link{loo}}}
#'\item{pseudo.r.squared}{pseudo-value of the square R (correlation to the square of the linear predictor and the a posteriori means of theta).}}
#'@description Fit of beta regression model under the view of Bayesian statistics,
#'using the mean of the posterior distribution as estimates for the mean (theta) and the precision parameter (zeta).
#'@seealso \code{\link{summary.bayesbr}}, \code{\link{residuals.bayesbr}}, \code{\link{formula}}
#'@references
#'  \doi{10.1080/0266476042000214501} Ferrari, S.L.P., and Cribari-Neto, F. (2004).
#'Beta Regression for Modeling Rates and Proportions. \emph{Journal of Applied Statistics}, \bold{31}(7), 799--815.
#'@references
#'\href{https://arxiv.org/abs/1111.4246}{arXiv:1111.4246} Hoffman, M. D., and Gelman, A. (2014). The No-U-Turn sampler: adaptively setting path lengths in Hamiltonian Monte Carlo. \emph{Journal of Machine Learning Research}, \bold{15}(1), 1593-1623.
#'@references
#'\doi{10.18637/jss.v076.i01} Carpenter, B., Gelman, A., Hoffman, M. D., Lee, D., Goodrich, B., Betancourt, M., ... & Riddell, A. (2017). Stan: A probabilistic programming language. \emph{Journal of statistical software}, \bold{76}(1).
#'@examples
#'data("StressAnxiety",package="bayesbr")
#'
#'bbr = bayesbr(anxiety ~ stress | stress, data = StressAnxiety,
#'              iter = 100)
#'summary(bbr)
#'residuals(bbr, type="ordinary")
#'print(bbr)
#'
#'
#'\donttest{
#'data("StressAnxiety", package = "bayesbr")
#'bbr2 <- bayesbr(anxiety ~ stress | stress,
#'                data = StressAnxiety, iter = 1000,
#'                warmup= 450, mean_betas = c(0,1),
#'                variance_betas = 15)
#'
#'envelope(bbr2,sim=100,conf=0.95)
#'loglikPlot(bbr2$loglik)
#'}
#'@details   Beta Regression was suggested by Ferrari and Cribari-Neto (2004), but with the look of classical statistics, this package makes use of the \code{Rstan} to, from the prior distribution of the data, obtain the posterior distribution and the estimates from a Bayesian perspective. Beta regression is useful when the response variable is in the range between 0 and 1, being used for adjusting probabilities and proportions.
#'
#'It is possible to estimate coefficients for the explanatory covariates for the theta and zeta parameters of the Beta distribution. Linear predictors are passed as parameters for both zeta and zeta, from these linear predictors a transformation of scales is made.
#'
#'Hamiltonian Monte Carlo (HMC) is a Markov chain Monte Carlo (MCMC) algorithm, from the HMC there is an extension known as the No-U-Turn Sampler (NUTS) that makes use of recursion to obtain its calculations and is used by \code{RStan}. In the context of the \code{bayesbr} package, NUTS was used to obtain a posteriori distribution from model data and a priori distribution.
#'
#'See \code{\link{predict.bayesbr}}, \code{\link{residuals.bayesbr}},\code{\link{summary.bayesbr}},\code{\link{logLik.bayesbr}} and \code{\link{pseudo.r.squared}} for more details on all methods. Because it is in the context of Bayesian statistics, in all calculations that were defined using maximum verisimilitude, this was sub-replaced by the mean of the posterior distribution of the parameters of interest of the formula.
#'@export
bayesbr = function(formula=NULL,data=NULL,m_neighborhood = NULL,
                   na.action=c("exclude","replace"),mean_betas = NULL,
                    variance_betas = NULL,mean_gammas = NULL,
                    variance_gammas = NULL ,iter = 10000,warmup = iter/2,
                    chains = 1,pars=NULL,a = NULL,b = NULL,
                   atau_delta = NULL, btau_delta = NULL,atau_xi = NULL,
                   btau_xi = NULL,rho = NULL,spatial_theta = NULL,spatial_zeta=NULL,
                   resid.type = c("quantile","sweighted",
                                  "pearson","ordinary"),...){
  cl = match.call()
  r_mc_aux = T
  resid.type = match.arg(resid.type)

  aux_m_neig = 0
  if(!is.null(m_neighborhood)){

    if(nrow(m_neighborhood) == ncol(m_neighborhood) &&
       nrow(m_neighborhood) == nrow(data) &&
       isTRUE(all.equal(m_neighborhood,t(m_neighborhood))) &&
       isTRUE(all.equal(diag(m_neighborhood),diag(matrix(0,ncol(m_neighborhood),ncol(m_neighborhood)))))){
        elements = m_neighborhood %>% unique() %>% lapply(unique) %>% do.call(c,.) %>%
              unique()
        Dw = diag(apply(m_neighborhood,1,sum))
        if(length(elements) == 2 && 1 %in% elements && 0 %in% elements){
          if(!(0 %in% diag(Dw))){
            aux_m_neig = 1
          }        }

        }
    if(aux_m_neig == 0){
      warning("The informed neighborhood matrix is invalid, check it. The model will be adjusted with no spatial effect on the data.",call. = T)
      Sys.sleep(3)
    }
  }

  if(!is.null(formula)){
    dados = formula(as.formula(formula),data)
    Y = dados[[1]]
    X = dados[[2]]
    W = dados[[3]]
    name_y  = dados[[4]]
    names_x = dados[[5]]
    names_w = dados[[6]]
    model = data.frame(cbind(Y,X,W))
    char = FALSE
    for (cnames in colnames(model)){
          if(!is.numeric(model[,cnames])){
            char = TRUE
            break;
          }
    }
    if(char == TRUE){
      stop("It is not possible to work with categorical variables, to use this variable you must qualitative variables of interest in quantitative variables.",call.=TRUE)
    }
  }
  else{
    stop("formula not informed",call.=TRUE)
  }
  if(!is.null(a)){
    if(a<0){
      stop("zeta 'a' priori parameter cannot be negative",call.=TRUE)
    }
  }
  if(!is.null(b)){
    if(b<0){
      stop("zeta 'b' priori parameter cannot be negative",call.=TRUE)
    }
  }

  if(!is.null(rho)){
    if(rho<=0 || rho>=1){
      stop("variable 'rho' must be a value between 0 and 1",call.=TRUE)
    }
  }

  if(!is.null(atau_delta)){
    if(atau_delta<=0){
      stop("tau 'a' priori cannot be negative",call.=TRUE)
    }
  }

  if(!is.null(btau_delta)){
    if(btau_delta<=0){
      stop("tau 'b' priori cannot be negative",call.=TRUE)
    }
  }

  if(!is.null(atau_xi)){
    if(atau_xi<=0){
      stop("tau 'a' priori cannot be negative",call.=TRUE)
    }
  }

  if(!is.null(btau_xi)){
    if(btau_xi<=0){
      stop("tau 'b' priori cannot be negative",call.=TRUE)
    }
  }

  if((!is.null(atau_delta) || !is.null(btau_delta) ||
      !is.null(atau_xi) || !is.null(btau_xi) ||
      !is.null(rho)) &&
     is.null(m_neighborhood)){
    warning("You provided prioris for tau or value for rho, but you did not inform the neighborhood matrix. If you want a spatial effect you need to inform the matrix, the model will be adjusted without the spatial effect.",call. = T)
    Sys.sleep(3)
  }

  if((isTRUE(spatial_theta) || isTRUE(spatial_zeta)) && aux_m_neig == 0){
    spatial_theta = F
    spatial_zeta = F
    warning("You reported that you want the spatial estimation for theta or zeta, but you did not report the neighborhood matrix. The model will be adjusted without the spatial effect.",call. = T)
    Sys.sleep(2)
  }

  if((is.null(spatial_theta) && is.null(spatial_zeta)) && aux_m_neig == 1){
    spatial_theta = T
    spatial_zeta = T
    warning('You entered the neighborhood matrix, but you did not say whether you want the spatial effect on the theta parameter or the zeta parameter or both. The model will be adjusted considering the spatial effect in the theta and zeta parameters.',call. = T)
    Sys.sleep(2)
  }

  if(is.null(spatial_theta)){
    if(aux_m_neig == 1){
      spatial_theta = T
    }
    else{
      spatial_theta = F
    }

  }
  if(is.null(spatial_zeta)){
    if(aux_m_neig == 1){
      spatial_zeta = T
    }
    else{
      spatial_zeta = F
    }
  }


  if(is.numeric(warmup)){
    warmup = as.integer(warmup)
  }

  if(!is.null(X)){
    if(is.matrix(X)){
      p = ncol(X)
    }
    else{
      p=1
    }
    if(is.null(mean_betas)){
      mean_betas = rep(0,p)
    }
    if(is.null(variance_betas)){
      variance_betas = rep(10,p)
    }
  }
  else{
    p = 0
  }
  if(!is.null(W)){
    if(is.matrix(W)){
      q = ncol(W)
    }
    else{
      q=1
    }
    if(is.null(mean_gammas)){
      mean_gammas = c(rep(0,q))
    }
    if(is.null(variance_gammas)){
      variance_gammas = c(rep(10,q))
    }
  }
  else{
    q=0
  }
  n = length(Y)


  na.action = match.arg(na.action)
  if(na.action == "exclude"){
    model = data.frame(cbind(Y,X,W))
    na_values = which(is.na(model), arr.ind=TRUE)
    if(nrow(na_values)>0){
      model = drop_na(model)
      Y = model[,1]
      aux1 = 1+p
      aux2 = 2+p
      aux3 = 1+p+q
      if(p>0){
      X = model[,(2:aux1)]
      }
      if(q>0){
        W = model[,(aux2:aux3)]
      }
      warning("The model variables may have changed, for more details check the complete model returned in the item model."
                ,call.=TRUE)
  }
  }
  if(na.action == "replace"){
    model = cbind(Y,X,W)
    na_values = which(is.na(model), arr.ind=TRUE)
    if(nrow(na_values)>0){
      for(i in 1:nrow(na_values)){
        row = na_values[i,1]
        col = na_values[i,2]
        mean = mean(model[,col],na.rm=TRUE)
        model[row,col] = mean
      }
      Y = model[,1]
      aux1 = 1+p
      aux2 = 2+p
      aux3 = 1+p+q
      if(p>0){
        X = model[,(2:aux1)]
      }
      if(q>0){
        W = model[,(aux2:aux3)]
      }
      warning("The model variables may have changed, for more details check the complete model returned in the item model.")
      }
  }

  if(spatial_theta == T || spatial_zeta == T){
    rho = ifelse(is.null(rho),0.9,rho)
    Dw = diag(apply(m_neighborhood,1,sum))
    mat_cov = solve(Dw - rho * m_neighborhood)

    if(spatial_theta == T){
      atau_delta = ifelse(is.null(atau_delta) || is.null(btau_delta),
                          0.1,atau_delta)
      btau_delta = ifelse(is.null(atau_delta) || is.null(btau_delta),
                          0.1,btau_delta)
      atau_xi = 0.1
      btau_xi = 0.1
    }
    else{
      atau_xi = ifelse(is.null(atau_xi) || is.null(btau_xi),
                       0.1,atau_xi)
      btau_xi = ifelse(is.null(atau_xi) || is.null(btau_xi),
                       0.1,btau_xi)
      atau_delta = 0.1
      btau_delta = 0.1
    }
  }
  else{
    mat_cov = matrix(0,n,n)
    atau_delta = 0.1
    btau_delta = 0.1
    atau_xi = 0.1
    btau_xi = 0.1
  }


  if(max(Y)>=1 || min(Y)<=0){
    warning("Some of your data is outside the range between 0 and 1 (extremes not included in the range), so beta regression cannot be applied.")
  }
  if(length(mean_betas)==1 && p>1){
    mean_betas = rep(mean_betas,p)
  }
  if(length(variance_betas)==1 && p>1){
    variance_betas = rep(variance_betas,p)
  }
  if(length(mean_gammas)==1 && q>1){
    mean_gammas = rep(mean_gammas,q)
  }
  if(length(variance_gammas)==1 && q>1){
    variance_gammas = rep(variance_gammas,q)
  }
  if(length(mean_betas)!=p){
    stop("The number of a priori specifications for betas averages must equal the p + 1 (p being the number of covariates for theta)",call.=TRUE)
  }
  if(length(variance_betas)!=p){
    stop("The number of a priori specifications for betas variances must equal the p + 1 (p being the number of covariates for theta)",call.=TRUE)
  }
  if(length(mean_gammas)!=q){
    stop("The number of a priori specifications for gammas averages must equal the q + 1 (q being the number of covariates for zeta)",call.=TRUE)
  }
  if(length(variance_gammas)!=q){
    stop("The number of a priori specifications for gammas variances must equal the q + 1 (q being the number of covariates for zeta)",call.=TRUE)
  }

  if(is.null(a) || is.null(b)){
    a = 1
    b = 0.01
  }
  if(p==0){
    a = 2
    b = 2
  }
  data = list(n=n, p = p, q = q, Y=Y,a=a,b=b,
              spatial_theta = ifelse(spatial_theta==T,1,0),
              spatial_zeta = ifelse(spatial_zeta==T,1,0),
              cov_delta = mat_cov,cov_xi = mat_cov,atau_delta = atau_delta,
              btau_delta = btau_delta,atau_xi = atau_xi,
              btau_xi = btau_xi)

  pars_aux = c()
  if(p==0){
    data$X = matrix(1,n,0)
    data$mean_betas = vector("double",0)
    data$variance_betas = vector("double",0)
    pars_aux = c(pars_aux,"theta_e")
  }
  else{
    data$X = X
    data$mean_betas = array(mean_betas)
    data$variance_betas = array(variance_betas)
    pars_aux = c("betas","theta",pars_aux)
  }
  if(q==0){
    data$W = matrix(1,n,0)
    data$mean_gammas = vector("double",0)
    data$variance_gammas = vector("double",0)
    pars_aux = c(pars_aux,"zeta_e")
  }
  else{
    data$W = W
    data$mean_gammas = array(mean_gammas)
    data$variance_gammas = array(variance_gammas)
    pars_aux = c("gammas","zeta",pars_aux)
  }
  if(spatial_theta == T){
    pars_aux = c("tau_delta","delta",pars_aux)
  }
  if(spatial_zeta == T){
    pars_aux = c("tau_xi","xi",pars_aux)
  }
  if(is.null(pars)){
    pars = c("betas","zeta_e","theta","theta_e","gammas","zeta",'tau_delta',
             'tau_xi','delta','xi','theta')
  }

  if(!("betas" %in% pars) && p>0){
    warning('"betas" has to be included in the pars argument, so that the coefficients are calculated',
            call.= F)
  }
  if(!("gammas" %in% pars) && q>0){
    warning('"gammas" has to be included in the pars argument, so that the coefficients are calculated',
            call.= F)
  }

  object = sampling(stanmodels$bayesbr, data=data,
                    iter=iter, warmup=warmup,pars = pars_aux, chains=chains, ...)

  if(p==0){
    object@sim$samples[[1]]$theta = object@sim$samples[[1]]$theta_e
  }
  if(q==0){
    object@sim$samples[[1]]$zeta = object@sim$samples[[1]]$zeta_e
  }
  betas = values("beta",object,iter,warmup,n,p)
  gammas = values("gamma",object,iter,warmup,n,q)
  theta = values("theta",object,iter,warmup,n,p)
  zeta = values("zeta",object,iter,warmup,n,q)
  tau_delta = values("tau_delta",object,iter,warmup,n,spatial_theta)
  delta = values("delta",object,iter,warmup,n,spatial_theta)
  tau_xi = values("tau_xi",object,iter,warmup,n,spatial_zeta)
  xi = values("xi",object,iter,warmup,n,spatial_zeta)

  model = model.bayesbr(Y,X,W,name_y,names_x,names_w)
  names(Y) = 1:n

  rval = list()
  class(rval) = "bayesbr"

  rval$call = cl
  rval$formula = formula
  rval$y = Y
  rval$stancode = object@stanmodel
  rval$info = list(n = n, iter = iter, warmup = warmup, chains = chains, p = p, q = q,
                   spatial_theta = spatial_theta,spatial_zeta = spatial_zeta)

  rval$info$names = list(name_y=name_y,names_x = names_x, names_w = names_w)
  rval$info$samples$beta = betas
  rval$info$samples$gamma = gammas
  rval$info$samples$theta = theta
  rval$info$samples$delta = delta
  rval$info$samples$tau_delta = tau_delta
  rval$info$samples$xi = xi
  rval$info$samples$tau_xi = tau_xi

  rval$fitted.values = fitted.values(rval)
  rval$info$samples$zeta = zeta
  rval$pars = pars_aux
  rval$model = model

  if(p>0){
    rval$residuals.type = resid.type
    res = residuals.bayesbr(rval,rval$residuals.type)
    rval$residuals = res
  }

  list_mean = summary_mean(rval)
  list_precision = summary_precision(rval)

  rval$coefficients = list(mean = list_mean[['betas']],
                           precision = list_precision[['gammas']],
                           summary_mean = list_mean[['table']],
                           summary_precision = list_precision[['table']])

  if(spatial_theta == T){
    list_tau_delta = summary_tau_delta(rval)
    list_delta = summary_delta(rval)



    rval$coefficients[['tau_delta']] = list_tau_delta[['tau_delta']]
    rval$coefficients[['summary_tau_delta']] = list_tau_delta[['table']]

    rval$coefficients[['deltas']] = list_delta[['deltas']]
    rval$coefficients[['summary_deltas']] = list_delta[['table']]


    rval$delta = list_delta[['table']]
  }

  if(spatial_zeta == T){
    list_tau_xi = summary_tau_xi(rval)
    list_xi = summary_xi(rval)

    rval$coefficients[['tau_xi']] = list_tau_xi[['tau_xi']]
    rval$coefficients[['summary_tau_xi']] = list_tau_xi[['table']]

    rval$coefficients[['xis']] = list_xi[['xis']]
    rval$coefficients[['summary_xis']] = list_xi[['table']]


    rval$xi = list_xi[['table']]
  }

  if(p>0){
    list_loglik = logLik.bayesbr(rval)
    rval$loglik = list_loglik$loglik
    waic_estimates = suppressWarnings(waic(list_loglik$matrix_loglik)$estimates)
    looic_estimates = suppressWarnings(loo(list_loglik$matrix_loglik)$estimates)
    rval$AIC   = AIC_bayesbr(rval)
    rval$BIC   = BIC_bayesbr(rval)
    rval$DIC   = DIC_bayesbr(rval)
    rval$WAIC  = waic_estimates[3,]
    rval$LOOIC = looic_estimates[3,]
    rval$pseudo.r.squared. = pseudo.r.squared(rval)
  }
  if(!("theta" %in% pars)){
    rval$fitted.values = NULL
    rval$info$samples$theta = NULL
  }
  if(!("zeta" %in% pars)){
    rval$info$samples$zeta = NULL
  }
  return(rval)
}
