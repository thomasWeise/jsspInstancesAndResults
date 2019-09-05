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

index <- vapply(cols.meta$columns, function(f) f$title == "algo.desc", FALSE);
stopifnot(sum(index) == 1L);
index <- which(index);
stopifnot(length(index) == 1L,
          index > 0L,
          index <= length(cols.meta$columns));
col <- cols.meta$columns[[index]]
stopifnot(is.list(col),
          length(col) == 3L,
          names(col) == c("title", "description", "type"));

col <- create.column(col$title,
                     paste0(col$description, ", where the following abbreviations can be used\n#' \\describe{\n#' ",
                            "\\item{ABC}{Artificial Bee Colony algorithm}\n#' ",
                            "\\item{ACO}{Ant Colony Optimization}\n#' ",
                            "\\item{AIS}{Artificial Immune System}\n#' ",
                            "\\item{BA}{Bat Algorithm}\n#' ",
                            "\\item{BBO}{Biogeography-based optimization}\n#' ",
                            "\\item{BFO}{Bacterial Foraging Algorithm}\n#' ",
                            "\\item{CA}{Cultural Algorithm}\n#' ",
                            "\\item{CP}{constraint programming}\n#' ",
                            "\\item{CRO}{Coral Reef Optimization}\n#' ",
                            "\\item{DES}{discrete event simulation}\n#' ",
                            "\\item{DP}{dynamic programming, an exact method}\n#' ",
                            "\\item{EA}{evolutionary algorithm}\n#' ",
                            "\\item{FA}{Firefly Algorithm}\n#' ",
                            "\\item{FDS}{Failure Directed Search}\n#' ",
                            "\\item{forcing}{an improvement step that will try to move jobs in the Gantt chart to the left, if possible, first used by Nakano/Yamada}\n#' ",
                            "\\item{GT}{Giffler and Thompson (GT) procedure}\n#' ",
                            "\\item{GWO}{Grey wolf optimization}\n#' ",
                            "\\item{LP}{linear programming}\n#' ",
                            "\\item{LNS}{large neighborhood search}\n#' ",
                            "\\item{LS}{a local search}\n#' ",
                            "\\item{PSO}{particle swarm optimization}\n#' ",
                            "\\item{SA}{simulated annealing}\n#' ",
                            "\\item{SE}{seach economics}\n#' ",
                            "\\item{TLBO}{teaching-learning based optimization}\n#' ",
                            "\\item{TS}{tabu search}\n#' ",
                            "\\item{VNS}{variable neighborhood search}\n#' ",
                            "}"),
                     col$type);
cols.meta$columns[[index]] <- col;
rm("col");

cols.more <- create.columns(columns=list(
                 create.column("algo.representation",
                               paste0("the representation used for encoding solutions, if any, where the following abbreviations can be used\n#' \\describe{\n#' ",
                                      "\\item{JB}{job-based: the jobs are assigned to machines in the order in which they occur in the string}\n#' ",
                                      "\\item{MB}{machine-based: the encoding is the order in which the machines are used as bottlenecks in a heuristic such as the Shifting Bottleneck Method}\n#' ",
                                      "\\item{OB}{operation-based: each job is represented by m genes with the same value and the chromosome is processed from front to end by assigning jobs to machines at the earliest starting times, following their occurence}\n#' ",
                                      "\\item{OO}{the overall order of all operations is given, infeasible solutions may occur and need to be discarted or repaired}\n#' ",
                                      "\\item{PL}{priority-list: the job order for each machine is given and infeasible schedules are discarted or repaired if needed}\n#' ",
                                      "\\item{PM}{a priority matrix where each job-machine combination has a priority value from which the feasible schedules are constructed}\n#' ",
                                      "\\item{PR}{priority-rules: priorities of dispatching rules to be applied, e.g., in the Giffler and Thompson algorithm}\n#' ",
                                      "\\item{RK}{random keys: real-valued encoding which is translated to an integer encoding by replacing each value by its index in the sorted list of values, usually combined with another integer encoding}\n#' ",
                                      "}"),
                               "character"),
                 create.column("algo.operator.unary",
                               paste0("the unary operator used in the algorithm, if any, where the following abbreviations can be used\n#' \\describe{\n#' ",
                                      "\\item{insert}{extracts one value and inserts it somewhere else, shifting the other values appropriately}\n#' ",
                                      "\\item{N1}{neighborhood function N1 (Van Laarhoven et al., 1992) that performs the permutation of pairs of adjacent operations which belong to the critical path generated in the individual}\n#' ",
                                      "\\item{N4}{N4 critical operation move operator (Grabowski et al., 1988)}\n#' ",
                                      "\\item{N5}{N5 critical path-based move operator (Nowicki and Smutnicki, 1996)}\n#' ",
                                      "\\item{N7}{N7 neightborhood (Zhang et al., 2008)}\n#' ",
                                      "\\item{reverse}{reverse the order of a sub-sequence of values}\n#' ",
                                      "\\item{RRN}{random reverse neighborhood: select multiple pairs of operations and reverse them}\n#' ",
                                      "\\item{RWN}{random whole neighborhood: consider all permutations of lambda genes, by Cheng (1997)}\n#' ",
                                      "\\item{shift}{extracts a sub-list of values and inserts it somewhere else, shifting the other values appropriately}\n#' ",
                                      "\\item{swap}{swap two values, also known as reciprocal exchange mutation}\n#' ",
                                      "}"),
                               "character"),
                 create.column("algo.operator.binary",
                               paste0("the binary operator used in the algorithm, if any, where the following abbreviations can be used\n#' \\describe{\n#' ",
                                      "\\item{none}{no binary operator (such as crossover) is applied in algorithms that would permit doing so (as opposed to 'NA', which means that crossover is not applicable in this algorithm)}\n#' ",
                                      "\\item{JBX}{job-based crossover (Braune et al., 2005)}\n#' ",
                                      "\\item{IR}{intermediate recombination, also known as flat crossover}\n#' ",
                                      "\\item{LCSX}{longest-common subsequence crossover (Cheng et al.,2016)}\n#' ",
                                      "\\item{LOX}{linear order crossover (Falkenauer andd Bouffouix, 1991)}\n#' ",
                                      "\\item{OX}{order-based crossover}\n#' ",
                                      "\\item{PBX}{uniform or position-based crossover}\n#' ",
                                      "\\item{POX}{Precedence Operation Crossover) (Zhang, Li, 2008)}\n#' ",
                                      "\\item{PMX}{partial-mapped crossover}\n#' ",
                                      "\\item{PUX}{parameterized uniform crossover (DeJong and Spears, 1991)}\n#' ",
                                      "\\item{SPX}{single-point crossover}\n#' ",
                                      "\\item{TPX}{two-point crossover}\n#' ",
                                      "\\item{UX}{uniform crossover}\n#' ",
                                      "}"),
                               "character")),
                conditions=c(
                  "all(is.character(x$algo.representation))",
                  "all(is.na(x$algo.representation) | (nchar(x$algo.representation) > 0L))",
                  "all(is.character(x$algo.operator.unary))",
                  "all(is.na(x$algo.operator.unary) | (nchar(x$algo.operator.unary) > 0L))",
                  "all(is.character(x$algo.operator.binary))",
                  "all(is.na(x$algo.operator.binary) | (nchar(x$algo.operator.binary) > 0L))"
                ));

cols.meta$columns <- unlist(list(cols.meta$columns[seq.int(from=1L, to=index)],
                                 cols.more$columns,
                                 cols.meta$columns[seq.int(from=(index+1L), to=length(cols.meta$columns))]),
                            recursive = FALSE);
rm("index");
cols.meta$conditions <- unlist(c(cols.meta$conditions, cols.more$conditions));
rm("cols.more");
cols.meta <- create.columns(cols.meta$columns,
                            cols.meta$conditions,
                            cols.meta$mergers);

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
