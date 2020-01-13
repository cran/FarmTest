## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.


#' @useDynLib FarmTest
#' @importFrom Rcpp evalCpp
#' @exportPattern "^[[:alpha:]]+"
NULL

#' @title FarmTest: Factor-Adjusted Robust Multiple Testing
#' @description FarmTest package performs robust multiple testing for means in the presence of known and unknown latent factors.
#' It implements a series of adaptive Huber methods combined with fast data-drive tuning schemes to estimate model parameters and construct test statistics that are robust against heavy-tailed and/or assymetric error distributions. 
#' Extensions to two-sample simultaneous mean comparison problems are also included. 
#' As by-products, this package also contains functions that compute adaptive Huber mean and covariance matrix estimators that are of independent interest.
#' @details For detailed information on how to use and install see its GitHub page \url{https://github.com/XiaoouPan/FarmTest}.
#' @references Ahn, S. C. and Horenstein, A. R. (2013). Eigenvalue ratio rest for the number of factors. Econometrica, 81(3) 1203–1227.
#' @references Benjamini, Y. and Hochberg, Y. (1995). Controlling the false discovery rate: A practical and powerful approach to multiple testing. J. R. Stat. Soc. Ser. B. Stat. Methodol. 57 289–300.
#' @references Fan, J., Ke, Y., Sun, Q. and Zhou, W-X. (2019). FarmTest: Factor-adjusted robust multiple testing with approximate false discovery control. J. Amer. Statist. Assoc., to appear.
#' @references Huber, P. J. (1964). Robust estimation of a location parameter. Ann. Math. Statist., 35, 73–101.
#' @references Ke, Y., Minsker, S., Ren, Z., Sun, Q. and Zhou, W.-X. (2019). User-friendly covariance estimation for heavy-tailed distributions: A survey and recent results. Statis. Sci. To appear.
#' @references Storey, J. D. (2002). A direct approach to false discovery rates. J. R. Stat. Soc. Ser. B. Stat. Methodol. 64, 479–498.
#' @references Sun, Q., Zhou, W.-X. and Fan, J. (2019). Adaptive Huber regression. J. Amer. Statist. Assoc., to appear.
#' @references Wang, L., Zheng, C., Zhou, W. and Zhou, W.-X. (2018). A New Principle for Tuning-Free Huber Regression. Preprint.
#' @references Zhou, W-X., Bose, K., Fan, J. and Liu, H. (2018). A new perspective on robust M-estimation: Finite sample theory and applications to dependence-adjusted multiple testing. Ann. Statist. 46 1904-1931.
#' @docType package
#' @name FarmTest
NULL

#' @title Tuning-free Huber mean estimation
#' @description The function calculates adaptive Huber mean estimator from a data sample, with robustification parameter \eqn{\tau} determined by a tuning-free principle.
#' @param X An \eqn{n}-dimensional data vector.
#' @return A Huber mean estimator will be returned.
#' @references Huber, P. J. (1964). Robust estimation of a location parameter. Ann. Math. Statist., 35, 73–101.
#' @references Wang, L., Zheng, C., Zhou, W. and Zhou, W.-X. (2018). A New Principle for Tuning-Free Huber Regression. Preprint.
#' @seealso \code{\link{farm.cov}} for tuning-free Huber-type covariance estimation.
#' @examples
#' set.seed(2019)
#' n = 1000
#' X = rlnorm(n, 0, 1.5) - exp(1.5^2 / 2)
#' mu = farm.mean(X)
#' @export
farm.mean = function(X){
  n = length(X)
  return (huberMean(X, n))
}

#' @title Tuning-free Huber-type covariance estimation
#' @description The function calculates adaptive Huber-type covariance estimator from a data sample, with robustification parameter \eqn{\tau} determined by a tuning-free principle.
#' For the input matrix \code{X}, both low-dimension (\eqn{p < n}) and high-dimension (\eqn{p > n}) are allowed.
#' @param X An \eqn{n} by \eqn{p} data matrix.
#' @return A \eqn{p} by \eqn{p} Huber-type covariance matrix estimator will be returned.
#' @references Huber, P. J. (1964). Robust estimation of a location parameter. Ann. Math. Statist., 35, 73–101.
#' @references Ke, Y., Minsker, S., Ren, Z., Sun, Q. and Zhou, W.-X. (2019). User-friendly covariance estimation for heavy-tailed distributions: A survey and recent results. Statis. Sci. To appear.
#' @seealso \code{\link{farm.mean}} for tuning-free Huber mean estimation.
#' @examples
#' set.seed(2019)
#' n = 100
#' d = 50
#' X = matrix(rt(n * d, df = 3), n, d) / sqrt(3)
#' Sigma = farm.cov(X)
#' @export
farm.cov = function(X) {
  n = nrow(X)
  p = ncol(X)
  return (huberCov(X, n, p)$cov)
}

#' @title Factor-adjusted robust multiple testing
#' @description This function conducts factor-adjusted robust multiple testing (FarmTest) for means of multivariate data proposed in Fan et al. (2019) via a tuning-free procedure.
#' @param X An \eqn{n} by \eqn{p} data matrix with each row being a sample.
#' @param fX An \strong{optional} factor matrix with each column being a factor for \code{X}. The number of rows of \code{fX} and \code{X} must be the same.
#' @param KX An \strong{optional} positive number of factors to be estimated for \code{X} when \code{fX} is not specified. \code{KX} cannot exceed the number of columns of \code{X}. If \code{KX} is not specified or specified to be negative, it will be estimated internally. If \code{KX} is specified to be 0, no factor will be adjusted.
#' @param Y An \strong{optional} data matrix used for two-sample FarmTest. The number of columns of \code{X} and \code{Y} must be the same.
#' @param fY An \strong{optional} factor matrix for two-sample FarmTest with each column being a factor for \code{Y}. The number of rows of \code{fY} and \code{Y} must be the same.
#' @param KY An \strong{optional} positive number of factors to be estimated for \code{Y} for two-sample FarmTest when \code{fY} is not specified. \code{KY} cannot exceed the number of columns of \code{Y}. If \code{KY} is not specified or specified to be negative, it will be estimated internally. If \code{KY} is specified to be 0, no factor will be adjusted.
#' @param h0 An \strong{optional} \eqn{p}-vector of true means, or difference in means for two-sample FarmTest. The default is a zero vector.
#' @param alternative An \strong{optional} character string specifying the alternate hypothesis, must be one of "two.sided" (default), "less" or "greater".
#' @param alpha An \strong{optional} level for controlling the false discovery rate. The value of \code{alpha} must be between 0 and 1. The default value is 0.05.
#' @param p.method An \strong{optional} character string specifying the method to calculate p-values when \code{fX} is known or when \code{KX = 0}, possible options are multiplier bootstrap or normal approximation. It must be one of "bootstrap" (default) or "normal".
#' @param nBoot An \strong{optional} positive integer specifying the size of bootstrap sample, only available when \code{p.method = "bootstrap"}. The dafault value is 500.
#' @return An object with S3 class \code{farm.test} containing the following items will be returned:
#' \itemize{
#' \item \code{means} Estimated means, a vector with length \eqn{p}.
#' \item \code{stdDev} Estimated standard deviations, a vector with length \eqn{p}. It's not available for bootstrap method.
#' \item \code{loadings} Estimated factor loadings, a matrix with dimension \eqn{p} by \eqn{K}, where \eqn{K} is the number of factors.
#' \item \code{eigenVal} Eigenvalues of estimated covariance matrix, a vector with length \eqn{p}. It's only available when factors \code{fX} and \code{fY} are not given.
#' \item \code{eigenRatio} Ratios of \code{eigenVal} to estimate \code{nFactors}, a vector with length \eqn{min(n, p) / 2}. It's only available when number of factors \code{KX} and \code{KY} are not given.
#' \item \code{nFactors} Estimated or input number of factors, a positive integer.
#' \item \code{tStat} Values of test statistics, a vector with length \eqn{p}. It's not available for bootstrap method.
#' \item \code{pValues} P-values of tests, a vector with length \eqn{p}.
#' \item \code{significant} Boolean values indicating whether each test is significant, with 1 for significant and 0 for non-significant, a vector with length \eqn{p}.
#' \item \code{reject} Indices of tests that are rejected. It will show "no hypotheses rejected" if none of the tests are rejected.
#' \item \code{type} Indicator of whether factor is known or unknown.
#' \item \code{n} Sample size.
#' \item \code{p} Data dimension.
#' \item \code{h0} Null hypothesis, a vector with length \eqn{p}.
#' \item \code{alpha} \eqn{\alpha} value.
#' \item \code{alternative} Althernative hypothesis.
#' }
#' @details For two-sample FarmTest, \code{means}, \code{stdDev}, \code{loadings}, \code{eigenVal}, \code{eigenRatio}, \code{nfactors} and \code{n} will be lists of items for sample X and Y separately.
#' @details \code{alternative = "greater"} is the alternative that \eqn{\mu > \mu_0} for one-sample test or \eqn{\mu_X > \mu_Y} for two-sample test.
#' @details Setting \code{p.method = "bootstrap"} for factor-known model will slow down the program, but it will achieve lower empirical FDP than setting \code{p.method = "normal"}.
#' @references Ahn, S. C. and Horenstein, A. R. (2013). Eigenvalue ratio test for the number of factors. Econometrica, 81(3) 1203–1227.
#' @references Benjamini, Y. and Hochberg, Y. (1995). Controlling the false discovery rate: A practical and powerful approach to multiple testing. J. R. Stat. Soc. Ser. B. Stat. Methodol. 57 289–300.
#' @references Fan, J., Ke, Y., Sun, Q. and Zhou, W-X. (2019). FarmTest: Factor-adjusted robust multiple testing with approximate false discovery control. J. Amer. Statist. Assoc., to appear.
#' @references Huber, P. J. (1964). Robust estimation of a location parameter. Ann. Math. Statist., 35, 73–101.
#' @references Storey, J. D. (2002). A direct approach to false discovery rates. J. R. Stat. Soc. Ser. B. Stat. Methodol. 64, 479–498.
#' @references Sun, Q., Zhou, W.-X. and Fan, J. (2019). Adaptive Huber regression. J. Amer. Statist. Assoc., to appear.
#' @references Zhou, W-X., Bose, K., Fan, J. and Liu, H. (2018). A new perspective on robust M-estimation: Finite sample theory and applications to dependence-adjusted multiple testing. Ann. Statist. 46 1904-1931.
#' @seealso \code{\link{print.farm.test}}
#' @seealso \code{\link{farm.fdr}}
#' @examples 
#' n = 20
#' p = 50
#' K = 3
#' muX = rep(0, p)
#' muX[1:5] = 2
#' set.seed(2019)
#' epsilonX = matrix(rnorm(p * n, 0, 1), nrow = n)
#' BX = matrix(runif(p * K, -2, 2), nrow = p)
#' fX = matrix(rnorm(K * n, 0, 1), nrow = n)
#' X = rep(1, n) %*% t(muX) + fX %*% t(BX) + epsilonX
#' # One-sample FarmTest with two sided alternative
#' output = farm.test(X)
#' # One-sample FarmTest with one sided alternative
#' output = farm.test(X, alternative = "less")
#' # One-sample FarmTest with known factors
#' output = farm.test(X, fX = fX)
#' 
#' # Two-sample FarmTest
#' muY = rep(0, p)
#' muY[1:5] = 4
#' epsilonY = matrix(rnorm(p * n, 0, 1), nrow = n)
#' BY = matrix(runif(p * K, -2, 2), nrow = p)
#' fY = matrix(rnorm(K * n, 0, 1), nrow = n)
#' Y = rep(1, n) %*% t(muY) + fY %*% t(BY) + epsilonY
#' output = farm.test(X, Y = Y)
#' @export 
farm.test = function(X, fX = NULL, KX = -1, Y = NULL, fY = NULL, KY = -1, h0 = NULL, 
                     alternative = c("two.sided", "less", "greater"), alpha = 0.05, 
                     p.method = c("bootstrap", "normal"), nBoot = 500) {
  p = ncol(X)
  alternative = match.arg(alternative)
  p.method = match.arg(p.method)
  if (is.null(h0)) {
    h0 = rep(0, p)
  }
  if (length(h0) != p) {
    stop("Length of h0 must be the same as number of columns of X")
  }
  if(alpha >= 1 || alpha <= 0) {
    stop("Alpha should be strictly between 0 and 1")
  }
  output = NULL
  rst.list = NULL
  reject = "no hypotheses rejected"
  if (is.null(Y) && !is.null(fX)) {
    if (nrow(fX) != nrow(X)) {
      stop("Number of rows of X and fX must be the same")
    } else {
      eigenVal = "not available when fX is known"
      eigenRatio = "not available when fX is known"
      stdDev = "not available for bootstrap method"
      loadings = "not available for bootstrap method"
      tStat = "not available for bootstrap method"
      if (p.method == "bootstrap") {
        rst.list = farmTestFacBoot(X, fX, h0, alpha, alternative, nBoot)
      } else {
        rst.list = farmTestFac(X, fX, h0, alpha, alternative)
        stdDev = rst.list$stdDev
        loadings = rst.list$loadings
        tStat = rst.list$tStat
      }
      if (sum(rst.list$significant) > 0) {
        reject = which(rst.list$significant == 1)
      }
      output = list(means = rst.list$means, stdDev = stdDev, loadings = loadings, eigenVal = eigenVal, 
                    eigenRatio = eigenRatio, nFactors = rst.list$nfactors, tStat = tStat, 
                    pValues = rst.list$pValues, significant = rst.list$significant, reject = reject, 
                    type = "known", n = nrow(X), p = p, h0 = h0, alpha = alpha, alternative = alternative)
    }
  } else if (is.null(Y) && is.null(fX)) {
    if (KX > p) {
      stop("KX must be smaller than number of columns of X")
    } else if (KX == 0) {
      loadings = "not available when KX = 0"
      eigenVal = "not available when KX = 0"
      eigenRatio = "not available when KX = 0"
      stdDev = "not available for bootstrap method"
      tStat = "not available for bootstrap method"
      if (p.method == "bootstrap") {
        rst.list = rmTestBoot(X, h0, alpha, alternative, nBoot)
      } else {
        rst.list = rmTest(X, h0, alpha, alternative)
        stdDev = rst.list$stdDev
        tStat = rst.list$tStat
      }
      if (sum(rst.list$significant) > 0) {
        reject = which(rst.list$significant == 1)
      }
      output = list(means = rst.list$means, stdDev = stdDev, loadings = loadings, eigenVal = eigenVal, 
                    eigenRatio = eigenRatio, nFactors = 0, tStat = tStat, pValues = rst.list$pValues, 
                    significant = rst.list$significant, reject = reject, type = "unknown", 
                    n = nrow(X), p = p, h0 = h0, alpha = alpha, alternative = alternative)
    } else {
      eigenRatio = "not available when KX is specified"
      rst.list = farmTest(X, h0, KX, alpha, alternative)
      if (sum(rst.list$significant) > 0) {
        reject = which(rst.list$significant == 1)
      }
      if (KX < 0) {
        eigenRatio = rst.list$ratio
      }
      output = list(means = rst.list$means, stdDev = rst.list$stdDev, loadings = rst.list$loadings,
                    eigenVal = rst.list$eigens, eigenRatio = eigenRatio, nFactors = rst.list$nfactors, 
                    tStat = rst.list$tStat, pValues = rst.list$pValues, significant = rst.list$significant, 
                    reject = reject, type = "unknown", n = nrow(X), p = p, h0 = h0, alpha = alpha, 
                    alternative = alternative)
    }
  } else if (!is.null(Y) && !is.null(fX)) {
    if (ncol(X) != ncol(Y)) {
      stop("Number of columns of X and Y must be the same")
    } else if (is.null(fY)) {
      stop("Must provide factors for both or neither data matrices")
    } else if (nrow(fX) != nrow(X)) {
      stop("Number of rows of X and fX must be the same")
    } else if (nrow(fY) != nrow(Y)) {
      stop("Number of rows of Y and fY must be the same")
    } else {
      eigenVal = "not available when fX and fY are known"
      eigenRatio = "not available when fX and fY are known"
      stdDev = "not available for bootstrap method"
      loadings = "not available for bootstrap method"
      tStat = "not available for bootstrap method"
      if (p.method == "bootstrap") {
        rst.list = farmTestTwoFacBoot(X, fX, Y, fY, h0, alpha, alternative, nBoot)
      } else {
        rst.list = farmTestTwoFac(X, fX, Y, fY, h0, alpha, alternative)
        stdDev = list(X.stdDev = rst.list$stdDevX, Y.stdDev = rst.list$stdDevY)
        loadings = list(X.loadings = rst.list$loadingsX, Y.loadings = rst.list$loadingsY)
        tStat = rst.list$tStat
      }
      if (sum(rst.list$significant) > 0) {
        reject = which(rst.list$significant == 1)
      }
      means = list(X.means = rst.list$meansX, Y.means = rst.list$meansY)
      nfactors = list(X.nFactors = rst.list$nfactorsX, Y.nFactors = rst.list$nfactorsY)
      n = list(X.n = nrow(X), Y.n = nrow(Y))
      output = list(means = means, stdDev = stdDev, loadings = loadings, eigenVal = eigenVal, 
                    eigenRatio = eigenRatio, nFactors = nfactors, tStat = tStat, 
                    pValues = rst.list$pValues, significant = rst.list$significant, reject = reject, 
                    type = "known", n = n, p = p, h0 = h0, alpha = alpha, alternative = alternative)
    }
  } else {
    if (ncol(X) != ncol(Y)) {
      stop("Number of columns of X and Y must be the same")
    } else if (!is.null(fY)) {
      stop("Must provide factors for both or neither data matrices")
    } else if (KX > p || KY > p) {
      stop("KX and KY must be smaller than number of columns of X and Y")
    } else if ((KX == 0 && KY != 0) || (KX != 0 && KY == 0)) {
      stop("KX and KY must be both or neither 0")
    } else if (KX == 0 && KY == 0) {
      loadings = "not available when KX = 0 and KY = 0"
      eigenVal = "not available when KX = 0 and KY = 0"
      eigenRatio = "not available when KX = 0 and KY = 0"
      stdDev = "not available for bootstrap method"
      tStat = "not available for bootstrap method"
      if (p.method == "bootstrap") {
        rst.list = rmTestTwoBoot(X, Y, h0, alpha, alternative, nBoot)
      } else {
        rst.list = rmTestTwo(X, Y, h0, alpha, alternative)
        stdDev = list(X.stdDev = rst.list$stdDevX, Y.stdDev = rst.list$stdDevY)
        tStat = rst.list$tStat
      }
      if (sum(rst.list$significant) > 0) {
        reject = which(rst.list$significant == 1)
      }
      means = list(X.means = rst.list$meansX, Y.means = rst.list$meansY)
      nfactors = list(X.nFactors = 0, Y.nFactors = 0)
      n = list(X.n = nrow(X), Y.n = nrow(Y))
      output = list(means = means, stdDev = stdDev, loadings = loadings, eigenVal = eigenVal,
                    eigenRatio = eigenRatio, nFactors = nfactors, tStat = tStat, 
                    pValues = rst.list$pValues, significant = rst.list$significant, reject = reject, 
                    type = "unknown", n = n, p = p, h0 = h0, alpha = alpha, alternative = alternative)
    } else {
      rst.list = farmTestTwo(X, Y, h0, KX, KY, alpha, alternative)
      if (sum(rst.list$significant) > 0) {
        reject = which(rst.list$significant == 1)
      }
      means = list(X.means = rst.list$meansX, Y.means = rst.list$meansY)
      stdDev = list(X.stdDev = rst.list$stdDevX, Y.stdDev = rst.list$stdDevY)
      loadings = list(X.loadings = rst.list$loadingsX, Y.loadings = rst.list$loadingsY)
      nfactors = list(X.nFactors = rst.list$nfactorsX, Y.nFactors = rst.list$nfactorsY)
      eigenVal = list(X.eigenVal = rst.list$eigensX, Y.eigenVal = rst.list$eigensY)
      n = list(X.n = nrow(X), Y.n = nrow(Y))
      ratioX = "not available when KX is specified"
      ratioY = "not available when KY is specified"
      if (KX < 0) {
        ratioX = rst.list$ratioX
      }
      if (KY < 0) {
        ratioY = rst.list$ratioY
      }
      eigenRatio = list(X.eigenRatio = ratioX, Y.eigenRatio = ratioY)
      output = list(means = means, stdDev = stdDev, loadings = loadings, eigenVal = eigenVal,
                    eigenRatio = eigenRatio, nFactors = nfactors, tStat = rst.list$tStat, 
                    pValues = rst.list$pValues, significant = rst.list$significant, reject = reject, 
                    type = "unknown", n = n, p = p, h0 = h0, alpha = alpha, alternative = alternative)
    } 
  }
  attr(output, "class") = "farm.test"
  return (output)
}

#' @title Summary and print function of FarmTest
#' @description This is the print function of S3 objects with class "\code{farm.test}". It summarizes and prints the outputs of \code{farm.test} function.
#' @param x A \code{farm.test} object.
#' @param \dots Further arguments passed to or from other methods.
#' @return No variable will be returned, but a brief summary of FarmTest will be displayed.
#' @seealso \code{\link{farm.test}}
#' @examples 
#' n = 50
#' p = 100
#' K = 3
#' muX = rep(0, p)
#' muX[1:5] = 2
#' set.seed(2019)
#' epsilonX = matrix(rnorm(p * n, 0, 1), nrow = n)
#' BX = matrix(runif(p * K, -2, 2), nrow = p)
#' fX = matrix(rnorm(K * n, 0, 1), nrow = n)
#' X = rep(1, n) %*% t(muX) + fX %*% t(BX) + epsilonX
#' output = farm.test(X)
#' output
#' @export
print.farm.test = function(x, ...) {
  if (x$type == "known" && length(x$n) == 1) {
    cat(paste("One-sample FarmTest with known factors \n"))
    cat(paste("n = ", x$n, ", p = ", x$p, ", nFactors = ", x$nFactors, "\n", sep = ""))
  } else if (x$type == "known" && length(x$n) == 2) {
    cat(paste("Two-sample FarmTest with known factors \n"))
    cat(paste("X.n = ", x$n$X.n, ", Y.n = ", x$n$Y.n, ", p = ", x$p, ", X.nFactors = ", x$nFactors$X.nFactors, ", Y.nFactors = ", x$nFactors$Y.nFactors, "\n", sep = ""))
  } else if (x$type == "unknown" && length(x$n) == 1) {
    if (x$nFactors == 0) {
      cat(paste("One-sample robust multiple test without factor-adjustment \n"))
      cat(paste("n = ", x$n, ", p = ", x$p, "\n", sep = ""))
    } else {
      cat(paste("One-sample FarmTest with unknown factors \n"))
      cat(paste("n = ", x$n, ", p = ", x$p, ", nFactors = ", x$nFactors, "\n", sep = ""))
    }
  } else {
    if (x$nFactors$X.nFactors == 0) {
      cat(paste("Two-sample robust multiple test without factor-adjustment \n"))
      cat(paste("X.n = ", x$n$X.n, ", Y.n = ", x$n$Y.n, ", p = ", x$p, "\n", sep = ""))
    } else {
      cat(paste("Two-sample FarmTest with unknown factors \n"))
      cat(paste("X.n = ", x$n$X.n, ", Y.n = ", x$n$Y.n, ", p = ", x$p, ", X.nFactors = ", x$nFactors$X.nFactors, ", Y.nFactors = ", x$nFactors$Y.nFactors, "\n", sep = ""))
    }
  }
  cat(paste("FDR to be controlled at: ", x$alpha, "\n", sep = ""))
  cat(paste("Alternative hypothesis: ",  x$alternative, "\n", sep = ""))
  cat(paste("Number of hypotheses rejected: ", sum(x$significant), "\n", sep = ""))
}

#' @title FDR control given a sequence of p-values
#' @description Given a sequence of p-values, this function conducts multiple testing and outputs the indices of rejected hypotheses using an adaptive Benjamini-Hochberg procedure proposed by Storey (2002).
#' @param pValues A sequence of p-values, each entry of \code{pValues} must be between 0 and 1.
#' @param alpha An \strong{optional} level for controlling the false discovery rate. The value of \code{alpha} must be strictly between 0 and 1. The default value is 0.05.
#' @return Indices of tests that are rejected will be returned. It will show "no hypotheses rejected" if none of the tests are rejected.
#' @references Benjamini, Y. and Hochberg, Y. (1995). Controlling the false discovery rate: A practical and powerful approach to multiple testing. J. R. Stat. Soc. Ser. B. Stat. Methodol. 57 289–300.
#' @references Storey, J. D. (2002). A direct approach to false discovery rates. J. R. Stat. Soc. Ser. B. Stat. Methodol. 64, 479–498.
#' @examples 
#' set.seed(100)
#' n = 50
#' p = 100
#' X = cbind(matrix(rnorm(n * 10, 1, 1), n, 10), matrix(rnorm(n * (p - 10)), n, p - 10))
#' pValues = apply(X, 2, function(x) t.test(x)$p.value)
#' farm.fdr(pValues)
#' @seealso \code{\link{farm.test}}
#' @export
farm.fdr = function(pValues, alpha = 0.05) {
  if((sum(pValues < 0) != 0) || (sum(pValues > 1) != 0)) {
    stop("Each p-value must be between 0 and 1")
  } else if (alpha >= 1 || alpha <= 0) {
    stop("Alpha should be strictly between 0 and 1")
  } else {
    p = length(pValues)
    significant = getRej(pValues, alpha, p)
    reject = "no hypotheses rejected"
    if (sum(significant) > 0) {
      reject = which(significant == 1)
    }
    return (reject)
  }
}