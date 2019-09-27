
#' @title Check and Evaluate a Gantt Chart, i.e., A Candidate Solution for a
#'   Given JSSP Instance
#' @description This function accepts an instance id and a Gantt chart and
#'   verifies whether the Gantt chart is a proper solution and evaluates its
#'   makespan.
#' @param gantt the gantt chart
#' @param inst.id the instance id
#' @param get.inst.data a function obtaining the instance data for a given
#'   instance id, by default \link{jssp.get.instance.data}
#' @return the evaluation result, i.e., a list with the following components:
#' \describe{
#' \item{gantt}{the canonicalized gantt chart (with zero-duration jobs removed, if any)}
#' \item{makespan}{the makespan}
#' }
#' @export jssp.evaluate.gantt
#' @include get_instance_data.R
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

# compute the minimum job id
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

# delete all zero-duration jobs
  gantt <- lapply(seq_along(gantt),
                  function(i) {
                    machine   <- gantt[[i]];

                    sel <- vapply(seq_along(machine), function(j) {
                      x <- machine[[j]];
                      jj <- x$job;
                      stopifnot(is.integer(jj),
                                is.finite(jj),
                                jj >= min.job.id);
                      jj <- as.integer(jj - min.job.id + 1L);
                      stopifnot(jj > 0L,
                                jj <= data$inst.jobs,
                                is.integer(x$start),
                                is.finite(x$start),
                                x$start >= 0L,
                                is.integer(x$end),
                                is.finite(x$end),
                                x$end >= x$start);
                      duration <- (x$end - x$start);
                      stopifnot(is.integer(duration),
                                is.finite(duration),
                                duration >= 0L);

                      jobdata <- data$inst.data[jj,];
                      mi <- i - 1L;
                      k <- which(jobdata[((2L*seq_len(data$inst.machines))-1L)] == mi);
                      stopifnot(is.integer(k),
                                length(k) == 1L,
                                k > 0L,
                                jobdata[((k*2L)-1L)] == mi,
                                jobdata[(k*2L)] == duration);
                      return(duration > 0L);
                    }, FALSE);

                    stopifnot(is.logical(sel),
                              all(!is.na(sel)),
                              any(sel));
                    machine <- machine[sel];
                    stopifnot(length(machine) > 0L);
                    return(machine);
                  });

# ok, all jobs in gantt chart have the right duration

# compute the makespan
  makespan <- -1L;
  for(machine.i in seq_along(gantt)) {
    machine <- gantt[[machine.i]];
    stopifnot(length(machine) > 0L,
              length(machine) <= data$inst.jobs);
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
    }

    makespan <- max(makespan, prev.end);
    makespan <- force(makespan);
    makespan <- do.call(force, list(makespan));
  }

  stopifnot(is.integer(makespan),
            is.finite(makespan),
            makespan > 0L,
            makespan <= .Machine$integer.max,
            makespan >= data$inst.opt.bound.lower);

# make the result
  result <- list(gantt=gantt,
                 makespan=makespan);
  result <- force(result);
  return(result);
}
