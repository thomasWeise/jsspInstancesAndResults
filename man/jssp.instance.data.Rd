% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_jssp_instance_data.R
\docType{data}
\name{jssp.instance.data}
\alias{jssp.instance.data}
\title{The Common Benchmark Instances for the Common Benchmark Instances of the Job Shop Scheduling Problem}
\format{
A list with the common benchmark instances for the jssp, where each entry is, itself, a list with the following fields
\describe{
  \item{inst.id}{the unique id identifying the instance (fitting to \link{jssp.instances})}
  \item{inst.jobs}{the number of jobs in the instance}
  \item{inst.machines}{the number of machines in the instance}
  \item{inst.opt.bound.lower}{the lower bound for the optimal solution quality}
  \item{inst.bks}{the best-known solution for the instance \emph{within any paper cited in this study} (or NA if none of the paper has one)}
  \item{inst.data}{an integer matrix where each row stands for one job. The rows consists of sequences of machine-time tuples.}
}
}
\usage{
data(jssp.instance.data)
}
\description{
While we provide the current state-of-the-art results on the JSSP in \link{jssp.instances}, we here
provide the instances themselves.
}
\examples{
data(jssp.instance.data)
\dontrun{
print(jssp.instance.data)
}
}
\keyword{JSSP,}
\keyword{Job}
\keyword{Scheduling,}
\keyword{Shop}
\keyword{instances}
