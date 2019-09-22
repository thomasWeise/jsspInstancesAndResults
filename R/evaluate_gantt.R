
#' @title Check and Evaluate a Gantt Chart, i.e., A Candidate Solution for a
#'   Given JSSP Instance
#' @description This function accepts an instance id and a Gantt chart and
#'   verifies whether the Gantt chart is a proper solution and evaluates its
#'   makespan.
#' @param gantt the gantt chart
#' @param inst.id the instance id
#' @param get.inst.data a function obtaining the instance data for a given
#'   instance id, by default \link{jssp.get.instance.data}
#' @return the evaluation result
#' @export jssp.evaluate.gantt
jssp.evaluate.gantt <- function(gantt, inst.id,
                                get.inst.data=jssp.get.instance.data) {
  stopifnot(is.character(inst.id),
            length(inst.id) == 1L,
            nchar(inst.id) > 0L,
            is.list(gantt),
            length(gantt) > 0L,
            is.function(get.inst.data));
  data <- get.inst.data(inst.id);
  stopifnot(identical(data$inst.id, inst.id),
            is.integer(data$inst.machines),
            is.finite(data$inst.machines),
            data$inst.machines > 0L,
            is.integer(data$inst.jobs),
            is.finite(data$inst.jobs),
            data$inst.jobs > 0L,
            is.integer(data$inst.opt.bound.lower),
            is.finite(data$inst.opt.bound.lower),
            data$inst.opt.bound.lower > 0L,
            is.matrix(data$inst.data),
            nrow(data$inst.data) == data$inst.jobs,
            ncol(data$inst.data) == (2L * data$inst.machines),
            identical(data$inst.machines, length(gantt)),
            is.integer(data$inst.opt.bound.lower),
            is.finite(data$inst.opt.bound.lower),
            data$inst.opt.bound.lower > 0L);

  min.job.id <- min(unlist(lapply(gantt, function(row) {
                    vapply(row, function(ops) {
                      job <- ops$job;
                      stopifnot(is.integer(job),
                                job >= 0L,
                                is.finite(job));
                      return(job);
                    }, NA_integer_) })));
  stopifnot(is.finite(min.job.id),
            min.job.id >= 0L,
            is.integer(min.job.id));

  makespan <- -1L;
  for(machine.i in seq_along(gantt)) {
    machine <- gantt[[machine.i]];
    stopifnot(length(machine) == data$inst.jobs);
    prev.end <- -1L;
    for(job in machine) {
      stopifnot(identical(c("job", "start", "end"), names(job)),
                is.integer(job$job),
                job$job >= min.job.id,
                job$job < (data$inst.jobs + min.job.id),
                is.finite(job$job),
                is.integer(job$start),
                is.finite(job$start),
                job$start >= 0L,
                job$start >= prev.end,
                is.integer(job$end),
                is.finite(job$end),
                job$start <= job$end,
                job$end < .Machine$integer.max);
      prev.end <- job$end;
      prev.end <- force(prev.end);
      prev.end <- do.call(force, list(prev.end));
      duration <- job$end - job$start;
    }

    makespan <- max(makespan, prev.end);
    makespan <- force(makespan);
    makespan <- do.call(force, list(makespan));
  }

  stopifnot(is.integer(makespan),
            is.finite(makespan),
            makespan > 0L,
            makespan <= .Machine$integer.max,
            makespan <= data$inst.opt.bound.lower);
  return(makespan);
}
