
#' @title Transform a Solution Represented in Form \code{OB} to a Gantt Chart
#' @description A solution in the \code{OB} (operation-based) representation is
#'   given. each job is represented by \\code{m} genes with the same value and
#'   the chromosome is processed from front to end by assigning jobs to machines
#'   at the earliest starting times, following their occurence order. This
#'   solution is then transformed to a Gantt chart à la
#'   \link{jssp.evaluate.gantt}.
#' @param data.ob the operation-based representation of the solution
#' @param inst.id the instance id
#' @param min.job.id the integer minimum job id to be used in the output (for
#'   the input, it is automatically detected). By default, this is \code{1L},
#'   but sometimes you may want to use \code{0L}.
#' @param get.inst.data a function obtaining the instance data for a given
#'   instance id, by default \link{jssp.get.instance.data}
#' @return the canonicalized and evaluated Gantt chart, see
#'   \link{jssp.evaluate.gantt}
#' @seealso jssp.evaluate.gantt
#' @export jssp.ob.to.gantt
#' @include get_instance_data.R
#' @include evaluate_gantt.R
jssp.ob.to.gantt <- function(data.ob, inst.id,
                             min.job.id=1L,
                             get.inst.data=jssp.get.instance.data) {
  stopifnot(is.integer(min.job.id),
            is.finite(min.job.id),
            min.job.id >= 0L,
            is.function(get.inst.data),
            is.character(inst.id),
            !is.na(inst.id),
            nchar(inst.id) > 0L);

  # load the relevant instance data
  instance <- get.inst.data(inst.id);
  stopifnot(is.list(instance),
            all(c("inst.id",
                  "inst.machines",
                  "inst.jobs",
                  "inst.data") %in% names(instance)),
            identical(instance$inst.id, inst.id));

  jobs <- instance$inst.jobs;
  stopifnot(is.integer(jobs),
            is.finite(jobs),
            jobs > 0L);

  machines <- instance$inst.machines;
  stopifnot(is.integer(machines),
            is.finite(machines),
            machines > 0L);

  job.machine.data <- instance$inst.data;
  stopifnot(is.matrix(job.machine.data),
            nrow(job.machine.data) == jobs,
            ncol(job.machine.data) == (2L * machines));

  # normalize the input data
  data.ob <- unname(unlist(data.ob));
  stopifnot(is.integer(data.ob),
            all(is.finite(data.ob)),
            length(data.ob) == (jobs*machines));

  data.ob <- as.integer((data.ob - min(data.ob)) + 1L);

  stopifnot(length(data.ob) == (jobs * machines),
            all(data.ob >= 1L),
            all(data.ob <= jobs),
            all(vapply(seq.int(from=1L, to=jobs),
                       function(i) sum(data.ob == i),
                       NA_integer_) == machines));

  job.times     <- rep.int(x=0L, times=jobs);
  job.index     <- rep.int(x=0L, times=jobs);
  machine.times <- rep.int(x=0L, times=machines);
  machine.index <- rep.int(x=0L, times=machines);

  gantt <- lapply(seq.int(from=0L, to=(machines-1L)),
                  function(m) {
                    lapply(seq.int(from=0L, to=(jobs - 1L)),
                           function(j) {
                             list(job=NA_integer_,
                                  start=NA_integer_,
                                  end=NA_integer_)
                           })
                  });

  for(job in data.ob) {
    index <- job.index[[job]];
    index <- index + 1L;
    stopifnot(index > 0L,
              index <= machines);
    job.index[[job]] <- index;
    machine <- job.machine.data[job, (2L * index) - 1L] + 1L;
    stopifnot(is.integer(machine),
              is.finite(machine),
              machine > 0L,
              machine <= machines);
    time <- job.machine.data[job, (2L * index)];
    stopifnot(is.integer(time),
              is.finite(time),
              time >= 0L,
              time < .Machine$integer.max);
    rm("index");

    job.time <- job.times[[job]];
    stopifnot(is.finite(job.time),
              job.time >= 0L,
              job.time <= .Machine$integer.max);

    machine.time <- machine.times[[machine]];
    stopifnot(is.finite(machine.time),
              machine.time >= 0L,
              machine.time <= .Machine$integer.max);

    start <- as.integer(max(job.time, machine.time));
    stopifnot(is.finite(start),
              start >= 0L,
              start <= .Machine$integer.max);

    end <- as.integer(start + time);
    stopifnot(is.finite(end),
              end >= start,
              end <= .Machine$integer.max);

    job.times[[job]] <- end;
    machine.times[[machine]] <- end;

    index <- machine.index[[machine]];
    index <- index + 1L;
    stopifnot(is.integer(index),
              is.finite(index),
              index > 0L,
              index <= jobs);
    machine.index[[machine]] <- index;

    gantt[[machine]][[index]]$job <- as.integer((job - 1L) + min.job.id);
    gantt[[machine]][[index]]$start <- start;
    gantt[[machine]][[index]]$end <- end;
    gantt <- force(gantt);

    rm("index");
  }

  for(i in unlist(gantt)) {
    stopifnot(is.integer(i),
              is.finite(i),
              i >= 0L);
  }

  result <- jssp.evaluate.gantt(gantt,
                                inst.id,
                                function(name) {
                                  stopifnot(identical(inst.id, name));
                                  return(instance);
                                });
  result <- force(result);

  return(result);
}

#' @title Transform a Solution Represented in the van-Hoorn Version of \code{OO}
#'   to a Gantt Chart
#' @description A solution in the van-Hoorn version of \code{OO} is translated
#'   to a Gantt Chart. Here, the operations are numbered as follows: The first
#'   \code{n} operations refer to the first operation of each job (according to
#'   order of the jobs), operations \code{n+1,...,2n} regard the second
#'   operation of the \code{n} jobs, and so on. So operation \code{i} is the
#'   \code{k}'th operation of job \code{j}, where \code{k = ceil(i/n)} and
#'   \code{j = i mod n}.
#' @param data.oo the overall-order based representation of the solution
#' @param inst.id the instance id
#' @param min.job.id the integer minimum job id to be used in the output (for
#'   the input, it is automatically detected). By default, this is \code{1L},
#'   but sometimes you may want to use \code{0L}.
#' @param get.inst.data a function obtaining the instance data for a given
#'   instance id, by default \link{jssp.get.instance.data}
#' @return the canonicalized and evaluated Gantt chart, see
#'   \link{jssp.evaluate.gantt}
#' @seealso jssp.evaluate.gantt
#' @include evaluate_gantt.R
#' @export jssp.oo.to.gantt
jssp.oo.to.gantt <- function(data.oo, inst.id,
                             min.job.id=1L,
                             get.inst.data=jssp.get.instance.data) {
  stopifnot(is.integer(data.oo),
            is.vector(data.oo),
            all(is.finite(data.oo)));

  instance <- get.inst.data(inst.id);
  stopifnot(is.list(instance),
            all(c("inst.id",
                  "inst.machines",
                  "inst.jobs",
                  "inst.data") %in% names(instance)),
            identical(instance$inst.id, inst.id));

  data.oo <- as.integer((data.oo - min(data.oo)) + 1L);
  stopifnot(length(data.oo) == (instance$inst.jobs * instance$inst.machines),
            all(vapply(seq.int(from=1L,
                               to=(instance$inst.jobs * instance$inst.machines)),
                       function(i) sum(data.oo == i) == 1L,
                       FALSE)));

  job.index <- rep.int(0L, instance$inst.jobs);
  data.ob   <- integer(instance$inst.jobs * instance$inst.machines);

  for(idx in seq_along(data.oo)) {
    i <- data.oo[[idx]];

    op <- as.integer(ceiling(i/instance$inst.jobs));
    stopifnot(is.integer(op),
              is.finite(op),
              op > 0L,
              op <= instance$inst.machines);
    job <- as.integer(as.integer((i - 1L) %% instance$inst.jobs) + 1L);
    stopifnot(is.integer(job),
              is.finite(job),
              job > 0L,
              job <= instance$inst.jobs);

    last <- job.index[[job]];
    stopifnot(last == (op - 1L));
    job.index[[job]] <- op;

    data.ob[[idx]] <- job;
  }

  stopifnot(is.integer(data.ob),
            all(is.finite(data.ob)),
            all(data.ob > 0L),
            all(data.ob <= instance$inst.jobs))

  result <- jssp.ob.to.gantt(data.ob=data.ob,
                             inst.id=inst.id,
                             min.job.id = min.job.id,
                             get.inst.data=function(x) {
                               stopifnot(identical(x, inst.id));
                               return(instance); });
  result <- force(result);

  return(result);
}

# transform the input data array to either a matrix or a vector,
# regardless whether it is given as matrix, data frame, or vector
# all vectors are presented row-by-row, meaning first all elements
# of the first row, then all elements of the second row, and so on
.make.matrix.or.vector <- function(data, nrow, ncol, to.vector=FALSE,
                                   normalize.by.min=FALSE,
                                   normalize.by.min.ofs=1L) {
  stopifnot(is.integer(nrow),
            length(nrow) == 1L,
            is.finite(nrow),
            is.integer(ncol),
            length(ncol) == 1L,
            is.finite(ncol),
            is.logical(to.vector),
            length(to.vector) == 1L,
            !is.na(to.vector),
            is.matrix(data) || is.data.frame(data) || is.vector(data) || is.list(data),
            is.logical(normalize.by.min),
            isTRUE(normalize.by.min) || isFALSE(normalize.by.min),
            is.integer(normalize.by.min.ofs),
            is.finite(normalize.by.min.ofs),
            normalize.by.min.ofs >= 0L);

  data.n <- unname(unlist(c(data)));
  stopifnot(is.integer(data.n),
            all(is.finite(data.n)),
            length(data.n) == (nrow*ncol));

  if(normalize.by.min) {
    data.n <- as.integer(data.n - min(data.n) + normalize.by.min.ofs);
    stopifnot(is.integer(data.n),
              all(is.finite(data.n)),
              all(data.n >= normalize.by.min.ofs),
              length(data.n) == (nrow*ncol));
  }

  if(is.matrix(data) || is.data.frame(data)) {
    data.n <- matrix(data.n, nrow=nrow, ncol=ncol, byrow=FALSE);
  } else {
    data.n <- matrix(data.n, nrow=nrow, ncol=ncol, byrow=TRUE);
  }
  stopifnot(nrow(data.n) == nrow,
            ncol(data.n) == ncol);
  if(to.vector) {
    data.n <- unname(unlist(c(lapply(seq_len(nrow), function(i) data.n[i, ]))));
    stopifnot(length(data.n) == (nrow*ncol));
  }

  data.n <- force(data.n);
  data.n <- do.call(force, list(data.n));
  return(data.n);
}

#' @title Transform a Solution Represented in the van-Hoorn Solution-Start
#'   Method to a Gantt Chart
#' @description The solution start file gives a matrix with one row per job and
#'   a column per machine, the values in this matrix give the start times for
#'   the operations. If the second row starts with a \code{10}, this indicates
#'   that the operation of job \code{2} on machine \code{1} starts at time
#'   \code{10}.
#' @param data.solution.start the solution-start representation
#' @param inst.id the instance id
#' @param min.job.id the integer minimum job id to be used in the output (for
#'   the input, it is automatically detected). By default, this is \code{1L},
#'   but sometimes you may want to use \code{0L}.
#' @param get.inst.data a function obtaining the instance data for a given
#'   instance id, by default \link{jssp.get.instance.data}
#' @return the canonicalized and evaluated Gantt chart, see
#'   \link{jssp.evaluate.gantt}
#' @seealso jssp.evaluate.gantt
#' @export jssp.solution.start.to.gantt
#' @include evaluate_gantt.R
jssp.solution.start.to.gantt <- function(data.solution.start, inst.id,
                                         min.job.id=1L,
                                         get.inst.data=jssp.get.instance.data) {
  instance <- get.inst.data(inst.id);
  stopifnot(is.list(instance),
            all(c("inst.id",
                  "inst.machines",
                  "inst.jobs") %in% names(instance)),
            identical(instance$inst.id, inst.id));

  jobs <- instance$inst.jobs;
  stopifnot(is.integer(jobs),
            is.finite(jobs),
            jobs > 0L);

  machines <- instance$inst.machines;
  stopifnot(is.integer(machines),
            is.finite(machines),
            machines > 0L);

  job.machine.data <- instance$inst.data;
  stopifnot(is.matrix(job.machine.data),
            nrow(job.machine.data) == jobs,
            ncol(job.machine.data) == (2L * machines));

  data.solution.start <- .make.matrix.or.vector(data=data.solution.start,
                                                nrow=jobs,
                                                ncol=machines,
                                                to.vector = FALSE,
                                                normalize.by.min = FALSE);
  stopifnot(is.integer(data.solution.start),
            all(is.finite(data.solution.start)),
            all(data.solution.start >= 0L),
            nrow(data.solution.start) == jobs,
            ncol(data.solution.start) == machines);

# compute the starts of the jobs on the machines
  machine.start <- do.call(rbind, lapply(seq_len(machines),
                          function(machine) {
                            vapply(seq_len(jobs),
                                   function(job) {
                                     data.solution.start[job, machine]
                                   }, NA_integer_)
                          }));

  machine.job <- do.call(rbind, lapply(seq_len(machines),
                                function(machine) seq.int(from=min.job.id,
                                                          to=as.integer(min.job.id+jobs-1L))));

# get the job durations on the machines to compute the machine end times
  job.durations.on.machine <- .get.job.durations.on.machine(jobs, machines, job.machine.data);
  machine.end <- do.call(rbind, lapply(seq_len(machines),
                               function(machine) {
                                 vapply(seq_len(jobs),
                                        function(job) {
                                          data.solution.start[job, machine] +
                                            job.durations.on.machine[job, machine]
                                        }, NA_integer_)
                               }));

# bring everything into the right order
  for(machine in seq_len(machines)) {
    ord <- order(machine.end[machine, ],
                 machine.start[machine, ],
                 machine.job[machine, ]);
    machine.start[machine, ] <- machine.start[machine, ord];
    machine.job[machine, ] <- machine.job[machine, ord];
    machine.end[machine, ] <- machine.end[machine, ord];
  }

# transform to a gantt chart
  result <- lapply(seq_len(machines),
                  function(machine) {
                    lapply(seq_len(jobs), function(job) {
                      list(job=machine.job[machine, job],
                           start=machine.start[machine, job],
                           end=machine.end[machine, job])
                    })
                  });
  result <- force(result);

  result <- jssp.evaluate.gantt(result, inst.id, function(name) {
    stopifnot(identical(name, inst.id));
    return(instance);
  });
  result <- force(result);
  return(result);
}




#' @title Transform a Solution Represented in the \code{PL} Representation to a
#'   Gantt Chart
#' @description In the priority-list (\code{PL}) representation, the job order
#'   for each machine is given. There is one line per machine and for each
#'   machine the orders of the jobs.
#' @param data.pl the pl representation
#' @param inst.id the instance id
#' @param min.job.id the integer minimum job id to be used in the output (for
#'   the input, it is automatically detected). By default, this is \code{1L},
#'   but sometimes you may want to use \code{0L}.
#' @param get.inst.data a function obtaining the instance data for a given
#'   instance id, by default \link{jssp.get.instance.data}
#' @return the canonicalized and evaluated Gantt chart, see
#'   \link{jssp.evaluate.gantt}
#' @seealso jssp.evaluate.gantt
#' @export jssp.pl.to.gantt
#' @include evaluate_gantt.R
jssp.pl.to.gantt <- function(data.pl, inst.id,
                             min.job.id=1L,
                             get.inst.data=jssp.get.instance.data) {

  stopifnot(is.function(get.inst.data),
            is.integer(min.job.id),
            is.finite(min.job.id),
            min.job.id >= 0L);

  instance <- get.inst.data(inst.id);
  stopifnot(is.list(instance),
            all(c("inst.id",
                  "inst.machines",
                  "inst.jobs",
                  "inst.data") %in% names(instance)),
            identical(instance$inst.id, inst.id));

  data.pl <- .make.matrix.or.vector(data=data.pl,
                                    nrow=instance$inst.machines,
                                    ncol=instance$inst.jobs,
                                    to.vector = FALSE,
                                    normalize.by.min = TRUE,
                                    normalize.by.min.ofs = 1L);

  stopifnot(is.integer(data.pl),
            is.matrix(data.pl),
            nrow(data.pl)==instance$inst.machines,
            ncol(data.pl)==instance$inst.jobs,
            all(is.finite(data.pl)));

  job.times     <- rep.int(x=0L, times=instance$inst.jobs);
  job.index     <- rep.int(x=0L, times=instance$inst.jobs);
  machine.times <- rep.int(x=0L, times=instance$inst.machines);
  machine.index <- rep.int(x=0L, times=instance$inst.machines);

  gantt <- lapply(seq.int(from=0L, to=(instance$inst.machines-1L)),
                  function(m) {
                    lapply(seq.int(from=0L, to=(instance$inst.jobs - 1L)),
                           function(j) {
                             list(job=NA_integer_,
                                  start=NA_integer_,
                                  end=NA_integer_)
                           })
                  });

  total <- as.integer(instance$inst.machines * instance$inst.jobs);
  stopifnot(is.integer(total),
            is.finite(total),
            total > 0L);

  while(total > 0L) {
    found <- FALSE;
    for(machine in seq_len(instance$inst.machines)) {
      machine.i <- machine.index[[machine]];
      stopifnot(is.finite(machine.i),
                machine.i >= 0L,
                machine.i <= instance$inst.jobs);
      if(machine.i < instance$inst.jobs) {
        machine.i <- machine.i + 1L;
        machine.job <- data.pl[machine, machine.i];
        stopifnot(is.finite(machine.job),
                  machine.job > 0L,
                  machine.job <= instance$inst.jobs);
        job.i <- job.index[[machine.job]];
        stopifnot(is.finite(job.i),
                  job.i >= 0L,
                  job.i <= instance$inst.machines);
        if(job.i < instance$inst.machines) {
          job.i <- job.i + 1L;
          job.machine <- instance$inst.data[machine.job, 2L*job.i - 1L];
          stopifnot(is.finite(job.machine),
                    job.machine >= 0L,
                    job.machine < instance$inst.machines);
          job.machine <- (job.machine + 1L);

          if(job.machine == machine) {
            job.time <- instance$inst.data[machine.job, 2L*job.i];
            stopifnot(is.integer(job.time),
                      is.finite(job.time),
                      job.time >= 0L);
            start <- as.integer(max(machine.times[[machine]], job.times[[machine.job]]));
            stopifnot(is.integer(start),
                      is.finite(start),
                      start >= 0L);
            end <- as.integer(start + job.time);
            stopifnot(is.integer(end),
                      is.finite(end),
                      end >= start);

            machine.times[[machine]] <- end;
            machine.times[[machine]] <- force(machine.times[[machine]]);
            machine.times <- force(machine.times);

            job.times[[machine.job]] <- end;
            job.times[[machine.job]] <- force(job.times[[machine.job]]);
            job.times <- force(job.times);

            machine.index[[machine]] <- machine.i;
            machine.index[[machine]] <- force(machine.index[[machine]]);
            machine.index <- force(machine.index);

            job.index[[machine.job]] <- job.i;
            job.index[[machine.job]] <- force(job.index[[machine.job]]);
            job.index <- force(job.index);

            gantt[[machine]][[machine.i]]$job <- as.integer((machine.job - 1L) + min.job.id);
            gantt[[machine]][[machine.i]]$start <- start;
            gantt[[machine]][[machine.i]]$end <- end;
            gantt <- force(gantt);

            found <- TRUE;
            found <- force(found);
            break;
          }
        }
      }
      if(found) { break; }
    }

    stopifnot(found);

    total <- total - 1L;
    stopifnot(total >= 0L);
  }

  result <- jssp.evaluate.gantt(gantt,
                                inst.id,
                                function(name) {
                                  stopifnot(identical(name, inst.id));
                                  return(instance);
                                });
  result <- force(result);
  return(result);
}
