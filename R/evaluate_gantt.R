
#' @title Check, Evaluate, and Canonicalize a Gantt Chart, i.e., A Candidate
#'   Solution for a Given JSSP Instance
#' @description This function accepts an instance id and a Gantt chart and
#'   verifies whether the Gantt chart is a proper solution and evaluates its
#'   makespan.
#' @param gantt the gantt chart: a list that contains one sub-list for each
#'   machine. The machine-sub-list, in turn, contains one entry for each job,
#'   with at least the three elements \code{job}, \code{start}, and \code{end}.
#'   These entries must be ordered ascendingly according to \code{start}.
#' @param inst.id the instance id
#' @param get.inst.data a function obtaining the instance data for a given
#'   instance id, by default \link{jssp.get.instance.data}
#' @return the evaluation result, i.e., a list with the following components:
#' \describe{
#' \item{gantt}{the canonicalized gantt chart (with zero-duration jobs removed, if any)}
#' \item{makespan}{the makespan}
#' \item{flowtime}{the flow time}
#' \item{job.start}{for each job, the beginning time of the first sub job}
#' \item{job.end}{for each job, the end time of the last sub job}
#' \item{job.time}{the total runtime of the job (not including waiting time, only raw processing time), which follows directly from the instance}
#' \item{machine.start}{for each machine, the starting time of the first sub-job executed on the machine}
#' \item{machine.end}{for each machine, the completion time of the last sub-job executed on the machine}
#' \item{machine.time}{the total working time of the machine (not including waiting time, only raw processing time), which follows directly from the instance}
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

# get and extract all necessary instance data
  instance <- get.inst.data(inst.id);
  stopifnot(identical(instance$inst.id, inst.id));

  jobs <- instance$inst.jobs;
  stopifnot(is.integer(jobs),
            is.finite(jobs),
            jobs > 0L);

  machines <- instance$inst.machines;
  stopifnot(is.integer(machines),
            is.finite(machines),
            machines > 0L,
            identical(machines, length(gantt)));

  bound <- instance$inst.opt.bound.lower;
  stopifnot(is.integer(bound),
            is.finite(bound),
            bound >= (machines * jobs),
            bound > 0L);

  job.machine.data <- instance$inst.data;
  stopifnot(is.matrix(job.machine.data),
            nrow(job.machine.data) == jobs,
            ncol(job.machine.data) == (2L * machines));

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

# compute the durations on the machines
  job.durations.on.machine <- matrix(data=NA_integer_,
                                     nrow=jobs,
                                     ncol=machines);
  for(job in seq_len(jobs)) {
    for(machine.index in seq_len(machines)) {
      machine <- job.machine.data[job, ((machine.index*2L) - 1L)];
      stopifnot(machine >= 0L,
                machine < machines,
                is.integer(machine),
                is.finite(machine));
      time <- job.machine.data[job, machine.index*2L];
      stopifnot(time >= 0L,
                is.integer(time),
                is.finite(time));
      machine <- as.integer(machine + 1L);
      stopifnot(is.na(job.durations.on.machine[job, machine]));
      job.durations.on.machine[job, machine] <- time;
      job.durations.on.machine[job, machine] <- force(job.durations.on.machine[job, machine]);
    }
  }
  stopifnot(!any(is.na(job.durations.on.machine)));

# the status vectors to fill
  job.start <- as.integer(rep.int(.Machine$integer.max, jobs));
  job.end   <- as.integer(-job.start);
  job.times <- as.integer(rep.int(0L, jobs));
  machine.start <- job.start;
  machine.end   <- job.end;
  machine.times <- job.times;

# process the gantt chart: iterate over machines
  for(machine.id in seq_along(gantt)) {
    machine.data <- gantt[[machine.id]];
    stopifnot(!is.null(machine.data),
              is.list(machine.data),
              length(machine.data) > 0L);
    first.start <- NA_integer_;
    last.end <- NA_integer_;
    keep <- rep.int(FALSE, length(machine.data));

# iterate over the jobs per machine
    for(job.index in seq_along(machine.data)) {
      job.data <- machine.data[[job.index]];
      stopifnot(is.list(job.data),
                length(job.data) >= 3L,
                identical(names(job.data)[1L:3L],
                          c("job", "start", "end")));
      job.id <- job.data[[1L]];
      stopifnot(is.integer(job.id),
                !is.na(job.id),
                is.finite(job.id),
                job.id >= 0L);
      job.id <- as.integer(job.id - min.job.id + 1L);
      stopifnot(is.integer(job.id),
                !is.na(job.id),
                is.finite(job.id),
                job.id >= 1L,
                job.id <= jobs);
      start <- job.data[[2L]];
      stopifnot(is.integer(start),
                !is.na(start),
                is.finite(start),
                start >= 0L);
      end <- job.data[[3L]];
      stopifnot(is.integer(end),
                !is.na(end),
                is.finite(end),
                end >= start);
      duration <- (end - start);
      stopifnot(is.integer(duration),
                is.finite(duration),
                duration == job.durations.on.machine[job.id, machine.id]);
      if(start < job.start[[job.id]]) {
        job.start[[job.id]] <- start;
        job.start[[job.id]] <- force(job.start[[job.id]]);
      }
      if(end > job.end[[job.id]]) {
        job.end[[job.id]] <- end;
        job.end[[job.id]] <- force(job.end[[job.id]]);
      }
      if(is.na(first.start)) {
        first.start <- start;
        first.start <- force(first.start);
        stopifnot(is.na(last.end));
      } else {
        stopifnot(first.start <= start,
                  last.end <= start,
                  !is.na(last.end));
      }
      if(is.na(last.end)) {
        stopifnot(first.start == start);
      } else {
        stopifnot(last.end <= start);
      }
      last.end <- end;
      last.end <- force(last.end);

      machine.times[[machine.id]] <- as.integer(machine.times[[machine.id]] + duration);
      stopifnot(is.integer(machine.times[[machine.id]]),
                is.finite(machine.times[[machine.id]]),
                machine.times[[machine.id]] >= duration);
      job.times[[job.id]] <- as.integer(job.times[[job.id]] + duration);
      stopifnot(is.integer(job.times[[job.id]]),
                is.finite(job.times[[job.id]]),
                job.times[[job.id]] >= duration);

      keep[[job.index]] <- (duration > 0L);
    }

    stopifnot(!is.na(first.start),
              !is.na(last.end),
              !any(is.na(keep)),
              any(keep));
    machine.start[[machine.id]] <- first.start;
    machine.start[[machine.id]] <- force(machine.start[[machine.id]]);
    machine.end[[machine.id]] <- last.end;
    machine.end[[machine.id]] <- force(machine.end[[machine.id]]);

# delete superfluous jobs
    gantt[[machine.id]] <- machine.data[keep];
    gantt[[machine.id]] <- force(gantt[[machine.id]]);
  }

# double-check all the data and then compute results
  stopifnot(all(is.integer(machine.start)),
            all(is.finite(machine.start)),
            all(machine.start >= 0L),
            all(machine.start < .Machine$integer.max),
            all(is.integer(machine.end)),
            all(is.finite(machine.end)),
            all(machine.end > machine.start),
            all(machine.end < .Machine$integer.max),
            all(is.integer(machine.times)),
            all(is.finite(machine.times)),
            all(machine.times > 0L),
            all(machine.times < .Machine$integer.max),
            all( (machine.end - machine.start) >= machine.times),
            all(is.integer(job.start)),
            all(is.finite(job.start)),
            all(job.start >= 0L),
            all(job.start < .Machine$integer.max),
            all(is.integer(job.end)),
            all(is.finite(job.end)),
            all(job.end > job.start),
            all(job.end < .Machine$integer.max),
            all(is.integer(job.times)),
            all(is.finite(job.times)),
            all(job.times > 0L),
            all(job.times < .Machine$integer.max),
            all( (job.end - job.start) >= job.times),
            all(job.times == vapply(seq_len(jobs),
                                    function(i) sum(job.durations.on.machine[i,]),
                                    NA_integer_)));

# compute metrics
  makespan <- as.integer(max(job.end) - min(job.start));
  stopifnot(is.integer(makespan),
            is.finite(makespan),
            makespan > 0L,
            makespan == (max(machine.end) - min(machine.start)),
            makespan >= max(job.times),
            makespan >= max(machine.times),
            makespan >= bound);

  flowtime <- as.integer(sum(job.end));
  stopifnot(is.integer(flowtime),
            is.finite(flowtime),
            flowtime > makespan,
            flowtime < .Machine$integer.max,
            flowtime >= sum(job.times),
            flowtime >= sum(machine.times));

# make the result
  result <- list(gantt=gantt,
                 makespan=makespan,
                 flowtime=flowtime,
                 job.start=job.start,
                 job.end=job.end,
                 job.times=job.times,
                 machine.start=machine.start,
                 machine.end=machine.end,
                 machine.times=machine.times);
  result <- force(result);
  return(result);
}
