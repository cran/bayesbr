## ---- include = FALSE---------------------------------------------------------
options(rmarkdown.html_vignette.check_title = FALSE)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(bayesbr)

## ----eval=FALSE---------------------------------------------------------------
#  bayesbr::bayesbr_app()

## ---- echo=FALSE, fig.cap="Application Home", out.width = '100%'--------------
knitr::include_graphics("images/page_initial.png")

## ---- echo=FALSE, fig.cap="Application Data page", out.width = '100%'---------
knitr::include_graphics("images/data_module.png")

## ---- echo=FALSE, fig.cap="Selected file error", out.width = '100%'-----------
knitr::include_graphics("images/shiny_alert_error.png")

## ---- echo=FALSE, fig.cap="Viewing Data box (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/viewing_data.png")

## ---- echo=FALSE, fig.cap="Graphs Box - Histogram (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/graph_data1.png")

## ---- echo=FALSE, fig.cap="Graphs Box - Scatter (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/graph_data2.png")

## ---- echo=FALSE, fig.cap="App Model Fit page", out.width = '100%'------------
knitr::include_graphics("images/model_module.png")

## ---- echo=FALSE, fig.cap="Selecting model variables (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/formula_1.png")

## ---- echo=FALSE, fig.cap="Error response variable with values outside the range between 0 and 1.", out.width = '100%'----
knitr::include_graphics("images/nao_0e1.png")

## ---- echo=FALSE, fig.cap="Adding unlisted potencies (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/covariates.png")

## ---- echo=FALSE, fig.cap="Covariates prior distribution (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/prioris.png")

## ---- echo=FALSE, fig.cap="Default MCMC setup", out.width = '100%'------------
knitr::include_graphics("images/MCMC_setup.png")

## ---- echo=FALSE, fig.cap="Execution loaders", out.width = '100%'-------------
knitr::include_graphics("images/loaders.png")

## ---- echo=FALSE, fig.cap="Selecting model variables with Spatial Effect (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/formula_2.png")

## ---- echo=FALSE, fig.cap="Model summary (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/model_summary.png")

## ---- echo=FALSE, fig.cap="x2 (precision coefficient) posterior density graph (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/r_g1.png")

## ---- echo=FALSE, fig.cap="Loglik traceplot (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/r_g2.png")

## ---- echo=FALSE, fig.cap="HPD intervals for mean (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/r_g3.png")

## ---- echo=FALSE, fig.cap="Envelope graph for quantile residuals (illustrative demonstration)", out.width = '100%'----
knitr::include_graphics("images/envelope.png")

