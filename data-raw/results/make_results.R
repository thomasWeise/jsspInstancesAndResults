logger("beginning to try to load jssp results.");

jssp.results.dir <- file.path(dir.data.raw, "results");
jssp.results.dir <- normalizePath(jssp.results.dir, mustWork=TRUE);
stopifnot(dir.exists(jssp.results.dir));

library(literatureAndResultsGen);

jssp.results.loader.autogen <- tempfile(fileext = ".R");
logger("First auto-generating loader code to '", jssp.results.loader.autogen, "'.");

are.objective.values.ints <- TRUE;
objective.value.lower.bound <- 0L;
objective.value.upper.bound <- .Machine$integer.max - 1L;
cols.meta <- create.standard.meta.columns(
                are.objective.values.ints = are.objective.values.ints,
                objective.value.lower.bound = objective.value.lower.bound,
                objective.value.upper.bound = objective.value.upper.bound);
cols.stat <- create.standard.result.columns(
                are.objective.values.ints = are.objective.values.ints,
                is.time.int = TRUE,
                objective.value.lower.bound = objective.value.lower.bound,
                objective.value.upper.bound = objective.value.upper.bound);

code <- generate.loader.functions(cols.meta, cols.stat);
rm("are.objective.values.ints");
rm("objective.value.lower.bound");
rm("objective.value.upper.bound");

cols <- unname(unlist(list(cols.meta$columns, cols.stat$columns), recursive = FALSE));
rm("cols.meta");
rm("cols.stat");

stopifnot(!is.null(code),
          is.list(code),
          is.character(code$name),
          is.character(code$code));

writeLines(text=code$code, con=jssp.results.loader.autogen);

stopifnot(file.exists(jssp.results.loader.autogen),
          file.size(jssp.results.loader.autogen) >= (length(code$code) + sum(nchar(code$code))));

func <- code$name;
rm("code");

logger("Finished generating code, now loading code as function '", func, "'.");

source(jssp.results.loader.autogen);
stopifnot(exists(func));
file.remove(jssp.results.loader.autogen);
stopifnot(!file.exists(jssp.results.loader.autogen));
rm("jssp.results.loader.autogen");

single.jssp.results.dir <- file.path(jssp.results.dir, "single");
single.jssp.results.dir <- normalizePath(single.jssp.results.dir, mustWork = TRUE);
stopifnot(dir.exists(single.jssp.results.dir));

jssp.index.file <- file.path(jssp.results.dir, "algorithms.txt");
jssp.index.file <- normalizePath(jssp.index.file, mustWork = TRUE);
stopifnot(file.exists(jssp.index.file));

logger("Function '", func, "' loaded, now trying to apply it to index '",
       jssp.index.file, "' and directory '", single.jssp.results.dir, "'.");

jssp.results <- do.call(func, list(file=jssp.index.file,
                                   directory=single.jssp.results.dir,
                                   bibliography=jssp.bibliography,
                                   instances=jssp.instances));

rm("jssp.index.file");
rm("single.jssp.results.dir")
rm("func");

stopifnot(is.data.frame(jssp.results),
          nrow(jssp.results) > 0L,
          all(c("ref.id", "algo.id", "inst.id", "ref.year") %in% colnames(jssp.results)));

logger("finished loading, expanding, and verifying jssp results, now creating joint CSV file.");

jssp.results.file <- file.path(jssp.results.dir, "all_results.txt");
if(file.exists(jssp.results.file)) {
  file.remove(jssp.results.file);
}
stopifnot(!file.exists(jssp.results.file));

write.csv(x=jssp.results, file=jssp.results.file, quote = FALSE, row.names = FALSE);
stopifnot(file.exists(jssp.results.file),
          file.size(jssp.results.file) > (nrow(jssp.results) * (1L + ncol(jssp.results))));

rm("jssp.results.dir");
rm("jssp.results.file");

stopifnot(dir.exists(dir.R));
jssp.results.docu <- file.path(dir.R, "data_jssp_results.R");
if(file.exists(jssp.results.docu)) {
  file.remove(jssp.results.docu);
}
stopifnot(!file.exists(jssp.results.docu));

writeLines(text=unname(unlist(c(
  "#'  Result Data from the Literature for Common JSSP Benchmark Instances",
  "#'",
  "#' Here we provide a set of results for the common instances for the Job Shop Scheduling Problem (JSSP) taken from literature.",
  "#'",
  "#' @docType data",
  "#'",
  "#' @usage data(jssp.results)",
  "#'",
  "#' @format A data frame with the result data sets",
  "#' \\describe{",
  vapply(colnames(jssp.results),
         function(cn) {
           col <- vapply(cols, function(t) t$title, "") == cn;
           stopifnot(sum(col) == 1L);
           col <- which(col);
           stopifnot(length(col) == 1L);
           return(paste0("#' \\item{", cn, "}{", cols[[col]]$description, "}"));
         }, ""),
  "#'}",
  "#'",
  "#' @keywords Job Shop Scheduling, JSSP, results",
  "#'",
  make.r.doc.references(jssp.results$ref.id, jssp.bibliography, logger),
  "#'",
  "#' @examples",
  "#' data(jssp.results)",
  "#' print(jssp.results)",
  "\"jssp.results\""))),
  con=jssp.results.docu);

stopifnot(file.exists(jssp.results.docu));

rm("cols");
rm("jssp.results.docu");
logger("finished loading jssp results");
