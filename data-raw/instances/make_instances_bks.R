stopifnot(is.data.frame(jssp.instances),
          nrow(jssp.instances) > 0L,
          ncol(jssp.instances) > 0L,
          is.data.frame(jssp.results),
          nrow(jssp.results) > 0L,
          ncol(jssp.results) > 0L);

logger("now computing and attaching best-known solutions to instance frame");
jssp.instances <- append.bks.to.instance.frame(jssp.instances, jssp.results,
                                               are.objective.values.ints = TRUE,
                                               is.time.int = TRUE);
logger("done computing and attaching best-known solutions to instance frame");

stopifnot(is.data.frame(jssp.instances),
          nrow(jssp.instances) > 0L,
          ncol(jssp.instances) > 0L,
          is.data.frame(jssp.results),
          nrow(jssp.results) > 0L,
          ncol(jssp.results) > 0L);

logger("now generating csv file with instances and bks");

jssp.instances.bks.file <- file.path(jssp.instances.dir, "instances_with_bks.txt");
if(file.exists(jssp.instances.bks.file)) {
  file.remove(jssp.instances.bks.file);
}
stopifnot(!file.exists(jssp.instances.bks.file));

write.csv(x=jssp.instances,
          file=jssp.instances.bks.file,
          quote = FALSE,
          row.names = FALSE);
stopifnot(file.exists(jssp.instances.bks.file),
          file.size(jssp.instances.bks.file) > (nrow(jssp.instances) * (1L + ncol(jssp.instances))));

rm("jssp.instances.dir");
rm("jssp.instances.bks.file");

logger("done computing and serializing instance bks, now generating documentation");

stopifnot(dir.exists(dir.R));
jssp.instances.docu <- file.path(dir.R, "data_jssp_instances.R");
if(file.exists(jssp.instances.docu)) {
  file.remove(jssp.instances.docu);
}
stopifnot(!file.exists(jssp.instances.docu));

writeLines(text=unname(unlist(c(
  "#' The Instance Meta-Data for the Common Benchmark Instances of the Job Shop Scheduling Problem",
  "#'",
  "#' Here we provide baseline data about the benchmark instances that are commonly used in research",
  "#' on the Job Shop Scheduling Problem.",
  "#' Data on the lower bounds has in particular been taken from van Hoorn's great website \\url{http://jobshop.jjvh.nl}.",
  "#' The data on the best-known solutions (\\code{inst.bks}) has automatically been extracted from the per-instance results, see \\link{jssp.results}.",
  "#' All literature referenced, on the other hand, can be found in \\link{jssp.bibliography}.",
  "#' The benchmark instances themselves are provided in \\link{jssp.instance.data}.",
  "#' We also try to provide the fastest runtime that was reported in any of our referenced papers for finding \\code{inst.bks}.",
  "#' But please, please, take the corresponding \\code{inst.bks.time} column with many grains of salt!",
  "#' First, we just report the time, regardless of which computer was used to obtain the result or even whether parallelism was applied or not.",
  "#' Second sometimes a minimum time to reach the best result of the run is given in a paper, sometimes we just have the maximum runtime used, sometimes we have a buget &ndash; and some publications do not report a runtime at all.",
  "#' Hence, our data here is very incomplete and unreliable and for some instances, we may not have any proper runtime value at all",
  "#' Therefore, this column is not to be understood as a normative a reliable information, more as a very rough guide regarding where we are standing right now.",
  "#' And, needless to say, it is only populated with the information extracted from the papers used in this study, so it may not even be representative.",
  "#'",
  "#' @docType data",
  "#'",
  "#' @usage data(jssp.instances)",
  "#'",
  "#' @format A data frame with the basic information about the JSSP instances",
  "#' \\describe{",
  "#'   \\item{inst.id}{the unique id identifying the instance}",
  "#'   \\item{inst.ref}{the id of the reference of the paper proposing the instance, which points into a row of \\code{jssp.bibliography}}",
  "#'   \\item{inst.jobs}{the number of jobs in the instance}",
  "#'   \\item{inst.machines}{the number of machines in the instance}",
  "#'   \\item{inst.opt.bound.lower}{the lower bound for the optimal solution quality}",
  "#'   \\item{inst.opt.bound.lower.ref}{the id of the reference of the source where this lower bound has been published, which points into a row of \\code{jssp.bibliography}}",
  "#'   \\item{inst.bks}{the best-known solution for the instance \\emph{within any paper cited in this study} (or NA if none of the paper has one)}",
  "#'   \\item{inst.bks.ref}{the reference(s) for the best-known for the instance \\emph{within any paper cited in this study}, only considering references from the earliest year the bks was found in this study, separated by ';' if multiple, NA if none}",
  "#'   \\item{inst.bks.time}{the fasted time (in milliseconds) recorded within the papers cited in this study within which the best-known solution \\code{inst.bks} was found, \\emph{regardless of the computer used}. Not all studies provide runtimes and if they do, the measurements may not be very precise. For some instances, we can therefore only not \\code{NA} and when a value is given, it may be very unreliable. While I tried to be conservative here, consider this column merely as a general guide to get some impression about where we are standing, take it with a grain of salt, and do not consider it as ground truth.}",
  "#'   \\item{inst.bks.time.ref}{the earliest publication reporting the time for discovering the best-known solution.}",
  "#'}",
  "#'",
  "#' @keywords Job Shop Scheduling, JSSP, instances",
  "#'",
  make.r.doc.references(unlist(list("vH2015JSIAS", "S2019JSSPH",
                                    jssp.instances$inst.ref,
                                    jssp.instances$inst.opt.bound.lower.ref,
                                    lapply(unname(unlist(jssp.instances$inst.bks.ref)),
                                           function(ref) {
                                             if(is.na(ref)) { return(character(0)); }
                                             ref <- unname(unlist(ref));
                                             ref <- strsplit(ref, ";", TRUE);
                                             stopifnot(length(ref) == 1L);
                                             ref <- ref[[1L]];
                                             stopifnot(length(ref) > 0L,
                                                       is.character(ref));
                                             return(trimws(unname(unlist(ref))));
                                           }))),
                        jssp.bibliography,
                        logger),
  "#'",
  "#' @examples",
  "#' data(jssp.instances)",
  "#' \\dontrun{",
  "#' print(jssp.instances)",
  "#' }",
  "\"jssp.instances\""))),
  con=jssp.instances.docu);

stopifnot(file.exists(jssp.instances.docu));
rm("jssp.instances.docu");
