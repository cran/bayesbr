#' Imprecise Probabilities for Sunday Weather and Boeing Stock Task
#'
#'In this study, participants had to respond to the greater and lesser probability of the event happening.
#'@usage data(ImpreciseTask)
#'@details All study participants were from the first or second year, none of the participants had an in-depth knowledge of probability.
#'
#'For the sunday weather task see \code{\link{WeatherTask}}. For the Boeing
#'stock task participants were asked to estimate the probability that
#'Boeing's stock would rise more than those in a list of 30 companies.
#'  For each task participants were asked to provide lower and upper
#'  estimates for the event to occur and not to occur.
#'
#'The \code{task} variable that was a qualitative variable was transformed into a quantitative variable to be used by the package functions.#'
#' @format   A data frame with 242 observations on the following 3 variables.
#'\describe{
#'  \item{\code{task}}{a variable with responses 0 and 1. If 0 \code{task} is \code{Boeing stock}, if 1 \code{task} is \code{Sunday weather}.}
#'  \item{\code{location}}{a numeric vector of the average of the lower
#'    estimate for the event not to occur and the upper estimate for the
#'    event to occur.}
#'  \item{\code{difference}}{a numeric vector of the differences of the
#'    lower and upper estimate for the event to occur.}
#'}
#'@references
#'\doi{10.3102/1076998610396893} Smithson, M., Merkle, E.C., and Verkuilen, J. (2011). Beta
#'Regression Finite Mixture Models of Polarization and Priming.
#'\emph{Journal of Educational and Behavioral Statistics}, \bold{36}(6), 804--831.
#'@references
#'\doi{10.3102/1076998610396893} Smithson, M., and Segale, C. (2009). Partition Priming in Judgments of Imprecise Probabilities. \emph{Journal of Statistical Theory and Practice}, \bold{3}(1), 169--181.
#'\emph{Journal of Educational and Behavioral Statistics}, \bold{36}(6), 804--831.
#' @examples
#'data("ImpreciseTask", package = "bayesbr")
#'
#'bbr = bayesbr(location~difference,iter=100,
#'              data = ImpreciseTask)
"ImpreciseTask"
