#' The Instance Data for the Common Benchmark Instances of the Job Shop Scheduling Problem
#'
#' Here we provide baseline data about the benchmark instances that are commonly used in research
#' on the Job Shop Scheduling Problem.
#'
#' @docType data
#'
#' @usage data(jssp.instances)
#'
#' @format A data frame with the bibliographic references
#' \describe{
#'   \item{inst.id}{the unique id identifying the instance}
#'   \item{inst.ref}{the id of the reference of the paper proposing the instance, which points into a row of \code{jssp.bibliography}}
#'   \item{inst.jobs}{the number of jobs in the instance}
#'   \item{inst.machines}{the number of machines in the instance}
#'   \item{inst.opt.bound.lower}{the lower bound for the optimal solution quality}
#'   \item{inst.opt.bound.lower.ref}{the id of the reference of the source where this lower bound has been published, which points into a row of \code{jssp.bibliography}}
#'}
#'
#' @keywords Job Shop Scheduling, JSSP, instances
#'
#' @examples
#' data(jssp.instances)
#' print(jssp.instances)
"jssp.instances"
