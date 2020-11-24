# Create the Data of this Package

old.options <- options(warn=2);

logger <- function(...) {
  cat(as.character(Sys.time()), ": ", paste(..., sep="", collapse=""), "\n", sep="", collapse="");
  invisible(TRUE);
}

logger("loading required libraries (installing them if necessary).");
if(!require("usethis")) {
  install.packages("usethis");
}
library("usethis");

if(!require("utils")) {
  install.packages("utils");
}
library("utils");

# setup directories
logger("setting up directories.");
dir.data.raw <- dirname(sys.frame(1)$ofile);
dir.data.raw <- normalizePath(dir.data.raw, mustWork = TRUE);
stopifnot(dir.exists(dir.data.raw));

dir.R <- file.path(dir.data.raw, "..", "R");
dir.R <- normalizePath(dir.R, mustWork = TRUE);
stopifnot(dir.exists(dir.R));

source(file.path(dir.data.raw, "bibliography", "make_bibliography.R"));
stopifnot(is.data.frame(jssp.bibliography));

source(file.path(dir.data.raw, "instances", "make_instances.R"));
stopifnot(is.data.frame(jssp.instances));

source(file.path(dir.data.raw, "results", "make_results.R"));

source(file.path(dir.data.raw, "instances", "make_instances_bks.R"));

source(file.path(dir.data.raw, "readme", "make_readme.R"));

source(file.path(dir.data.raw, "instance-data", "make_instance_data.R"));

# store the data
use_data(jssp.bibliography,
         jssp.instances,
         jssp.results,
         jssp.instance.data,
         compress="xz", version=3L, overwrite = TRUE);

rm("dir.data.raw");
rm("dir.R");
rm("jssp.results");
rm("jssp.bibliography");
rm("jssp.instances");
rm("jssp.instance.data");

logger("all done.");
rm("logger");

options(old.options);
rm("old.options");
