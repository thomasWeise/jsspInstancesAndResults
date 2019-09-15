stopifnot(is.data.frame(jssp.instances),
          nrow(jssp.instances) > 0L,
          ncol(jssp.instances) > 0L,
          is.data.frame(jssp.results),
          nrow(jssp.results) > 0L,
          ncol(jssp.results) > 0L);

logger("now computing and attaching best-known solutions to instance frame");
jssp.instances <- append.bks.to.instance.frame(jssp.instances, jssp.results,
                                               are.objective.values.ints = TRUE);
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

write.csv(x=jssp.instances, file=jssp.instances.bks.file, quote = FALSE, row.names = FALSE);
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
  "#' The data on the best-known solutions (BKS) has automatically been extracted from the per-instance results, see \\link{jssp.results}.",
  "#' All literature referenced, on the other hand, can be found in \\link{jssp.bibliography}.",
  "#' The benchmark instances themselves are provided in \\link{jssp.instance.data}.",
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
  "#' print(jssp.instances)",
  "\"jssp.instances\""))),
  con=jssp.instances.docu);

stopifnot(file.exists(jssp.instances.docu));
rm("jssp.instances.docu");
