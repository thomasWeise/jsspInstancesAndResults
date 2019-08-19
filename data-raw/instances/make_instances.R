logger("beginning to try to load instance information.");

jssp.instances.path <- file.path(dir.data.raw, "instances", "instances.txt");
stopifnot(file.exists(jssp.instances.path),
          file.size(jssp.instances.path) > 0L);
jssp.instances.path <- normalizePath(jssp.instances.path, mustWork = TRUE);

logger("now loading instances file '", jssp.instances.path, "'.");

jssp.instances <- read.csv(file=jssp.instances.path, stringsAsFactors = FALSE);
stopifnot(is.data.frame(jssp.instances),
          nrow(jssp.instances) > 0L,
          identical(colnames(jssp.instances),
                    c("inst.id",
                    "inst.ref",
                    "inst.jobs",
                    "inst.machines",
                    "inst.opt.bound.lower",
                    "inst.opt.bound.lower.ref")),
          all(!is.na(jssp.instances$inst.jobs)),
          all(jssp.instances$inst.jobs > 0L),
          all(is.finite(jssp.instances$inst.jobs)),
          all(is.integer(jssp.instances$inst.jobs)),
          all(!is.na(jssp.instances$inst.machines)),
          all(jssp.instances$inst.machines > 0L),
          all(is.finite(jssp.instances$inst.machines)),
          all(is.integer(jssp.instances$inst.machines)),
          all(!is.na(jssp.instances$inst.opt.bound.lower)),
          all(jssp.instances$inst.opt.bound.lower > 0L),
          all(is.finite(jssp.instances$inst.opt.bound.lower)),
          all(is.integer(jssp.instances$inst.opt.bound.lower)),
          all(is.character(jssp.instances$inst.id)),
          all(!is.na(jssp.instances$inst.id)),
          all(nchar(jssp.instances$inst.id) > 0),
          all(is.character(jssp.instances$inst.ref)),
          all(!is.na(jssp.instances$inst.ref)),
          all(nchar(jssp.instances$inst.ref) > 0),
          all(is.character(jssp.instances$inst.opt.bound.lower.ref)),
          all(!is.na(jssp.instances$inst.opt.bound.lower.ref)),
          all(nchar(jssp.instances$inst.opt.bound.lower.ref) > 0));

rm("jssp.instances.path");
logger("loaded ", nrow(jssp.instances), " instances.");

jssp.instances.ids <- unname(unlist(jssp.instances$inst.id));
stopifnot(length(unique(jssp.instances.ids)) == nrow(jssp.instances))

jssp.instances <- jssp.instances[order(jssp.instances.ids), ];
rm("jssp.instances.ids");
jssp.instances$inst.id <- as.factor(unname(unlist(jssp.instances$inst.id)));

.finder <- function(i) {
  stopifnot(!is.na(i));
  n <- (jssp.bibliography$ref.id == i);
  stopifnot(sum(n) == 1L);
  stopifnot(length(which(n)) == 1L);
}
for(i in jssp.instances$inst.ref) {
  .finder(i);
}
for(i in jssp.instances$inst.opt.bound.lower.ref) {
  .finder(i);
}
rm(".finder");

stopifnot(is.data.frame(jssp.instances),
          nrow(jssp.instances) > 0L,
          identical(colnames(jssp.instances),
                    c("inst.id",
                    "inst.ref",
                    "inst.jobs",
                    "inst.machines",
                    "inst.opt.bound.lower",
                    "inst.opt.bound.lower.ref")),
          all(!is.na(jssp.instances$inst.jobs)),
          all(jssp.instances$inst.jobs > 0L),
          all(is.finite(jssp.instances$inst.jobs)),
          all(is.integer(jssp.instances$inst.jobs)),
          all(!is.na(jssp.instances$inst.machines)),
          all(jssp.instances$inst.machines > 0L),
          all(is.finite(jssp.instances$inst.machines)),
          all(is.integer(jssp.instances$inst.machines)),
          all(!is.na(jssp.instances$inst.opt.bound.lower)),
          all(jssp.instances$inst.opt.bound.lower > 0L),
          all(is.finite(jssp.instances$inst.opt.bound.lower)),
          all(is.integer(jssp.instances$inst.opt.bound.lower)),
          all(is.factor(jssp.instances$inst.id)),
          all(!is.na(jssp.instances$inst.id)),
          all(is.character(jssp.instances$inst.ref)),
          all(!is.na(jssp.instances$inst.ref)),
          all(nchar(jssp.instances$inst.ref) > 0),
          all(is.character(jssp.instances$inst.opt.bound.lower.ref)),
          all(!is.na(jssp.instances$inst.opt.bound.lower.ref)),
          all(nchar(jssp.instances$inst.opt.bound.lower.ref) > 0));

logger("finished loading jssp instances, now generating documentation");

stopifnot(dir.exists(dir.R));
jssp.instances.docu <- file.path(dir.R, "data_jssp_instances.R");
if(file.exists(jssp.instances.docu)) {
  file.remove(jssp.instances.docu);
}
stopifnot(!file.exists(jssp.instances.docu));

writeLines(text=unname(unlist(c(
  "#' The Instance Data for the Common Benchmark Instances of the Job Shop Scheduling Problem",
  "#'",
  "#' Here we provide baseline data about the benchmark instances that are commonly used in research",
  "#' on the Job Shop Scheduling Problem.",
  "#' Data has in particular been taken from van Hoorn's great website <http://jobshop.jjvh.nl>.",
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
  "#'}",
  "#'",
  "#' @keywords Job Shop Scheduling, JSSP, instances",
  "#'",
  make.r.doc.references(list("vH2015JSIAS", jssp.instances$inst.ref, jssp.instances$inst.opt.bound.lower.ref),
                        jssp.bibliography,
                        logger),
  "#'",
  "#' @examples",
  "#' data(jssp.instances)",
  "#' print(jssp.instances)",
  "\"jssp.instances\""))),
  con=jssp.instances.docu);

stopifnot(file.exists(jssp.instances.docu));
