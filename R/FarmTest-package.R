#' @docType package
#' @name FarmTest-package
#' @title FarmTest: Factor-Adjusted Robust Multiple Testing
#' @description FarmTest package performs robust multiple testing for means in the presence of known and unknown latent factors (Fan et al, 2019).
#' It implements a series of adaptive Huber methods combined with fast data-drive tuning schemes (Wang et al, 2020; Ke et al, 2019) to estimate model parameters and construct test statistics that are robust against heavy-tailed and/or assymetric error distributions. 
#' Extensions to two-sample simultaneous mean comparison problems are also included. 
#' As by-products, this package also contains functions that compute adaptive Huber mean, covariance and regression estimators that are of independent interest.
#' @details See its GitHub page \url{https://github.com/XiaoouPan/FarmTest} for details.
#' @references Ahn, S. C. and Horenstein, A. R. (2013). Eigenvalue ratio rest for the number of factors. Econometrica, 81(3) 1203–1227.
#' @references Benjamini, Y. and Hochberg, Y. (1995). Controlling the false discovery rate: A practical and powerful approach to multiple testing. J. R. Stat. Soc. Ser. B. Stat. Methodol., 57 289–300.
#' @references Bose, K., Fan, J., Ke, Y., Pan, X. and Zhou, W.-X. (2019). FarmTest: An R package for factor-adjusted robust multiple testing, Preprint.
#' @references Fan, J., Ke, Y., Sun, Q. and Zhou, W-X. (2019). FarmTest: Factor-adjusted robust multiple testing with approximate false discovery control. J. Amer. Statist. Assoc., 114, 1880-1893.
#' @references Huber, P. J. (1964). Robust estimation of a location parameter. Ann. Math. Statist., 35, 73–101.
#' @references Ke, Y., Minsker, S., Ren, Z., Sun, Q. and Zhou, W.-X. (2019). User-friendly covariance estimation for heavy-tailed distributions. Statis. Sci., 34, 454-471.
#' @references Storey, J. D. (2002). A direct approach to false discovery rates. J. R. Stat. Soc. Ser. B. Stat. Methodol., 64 479–498.
#' @references Sun, Q., Zhou, W.-X. and Fan, J. (2020). Adaptive Huber regression. J. Amer. Statist. Assoc., 115, 254-265.
#' @references Wang, L., Zheng, C., Zhou, W. and Zhou, W.-X. (2020). A new principle for tuning-free Huber regression. Stat. Sin., to appear.
#' @references Zhou, W-X., Bose, K., Fan, J. and Liu, H. (2018). A new perspective on robust M-estimation: Finite sample theory and applications to dependence-adjusted multiple testing. Ann. Statist., 46 1904-1931.
NULL
