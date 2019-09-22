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
#' @return the Gantt chart
#' @export jssp.ob.to.gantt
jssp.ob.to.gantt <- function(data.ob, inst.id,
                             min.job.id=1L,
                             get.inst.data=jssp.get.instance.data) {
  stopifnot(is.integer(data.ob),
            is.vector(data.ob),
            length(data.ob) > 0L,
            all(is.finite(data.ob)),
            all(data.ob >= 0L),
            is.function(get.inst.data),
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

  data.ob <- as.integer((data.ob - min(data.ob)) + 1L);
  stopifnot(length(data.ob) == (instance$inst.jobs * instance$inst.machines),
            all(data.ob >= 1L),
            all(data.ob <= instance$inst.jobs),
            all(vapply(seq.int(from=1L, to=instance$inst.jobs),
                   function(i) sum(data.ob == i),
                   NA_integer_) == instance$inst.machines));

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

  for(job in data.ob) {
    index <- job.index[[job]];
    index <- index + 1L;
    stopifnot(index > 0L,
              index <= instance$inst.machines);
    job.index[[job]] <- index;
    machine <- instance$inst.data[job, (2L * index) - 1L] + 1L;
    stopifnot(is.integer(machine),
              is.finite(machine),
              machine > 0L,
              machine <= instance$inst.machines);
    time <- instance$inst.data[job, (2L * index)];
    stopifnot(is.integer(time),
              is.finite(time)  ,
              time >= 0L,
              time < .Machine$integer.max);
    rm("index");

    job.time <- job.times[[job]];
    stopifnot(is.finite(job.time), job.time >= 0L, job.time <= .Machine$integer.max);

    machine.time <- machine.times[[machine]];
    stopifnot(is.finite(machine.time), machine.time >= 0L, machine.time <= .Machine$integer.max);

    start <- as.integer(max(job.time, machine.time));
    stopifnot(is.finite(start), start >= 0L, start <= .Machine$integer.max);

    end <- as.integer(start + time);
    stopifnot(is.finite(end), end >= start, end <= .Machine$integer.max);

    job.times[[job]] <- end;
    machine.times[[machine]] <- end;

    index <- machine.index[[machine]];
    index <- index + 1L;
    stopifnot(is.integer(index),
              is.finite(index),
              index > 0L,
              index <= instance$inst.jobs);
    machine.index[[machine]] <- index;

    gantt[[machine]][[index]]$job <- as.integer((job - 1L) + min.job.id);
    gantt[[machine]][[index]]$start <- start;
    gantt[[machine]][[index]]$end <- end;
    gantt <- force(gantt);

    rm("index");
  }

  for(i in unlist(gantt)) {
    stopifnot(is.integer(i),
              i >= 0L,
              is.finite(i));
  }

  return(gantt);
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
#' @param data.oo.vH the operation-based representation of the solution
#' @param inst.id the instance id
#' @param min.job.id the integer minimum job id to be used in the output (for
#'   the input, it is automatically detected). By default, this is \code{1L},
#'   but sometimes you may want to use \code{0L}.
#' @param get.inst.data a function obtaining the instance data for a given
#'   instance id, by default \link{jssp.get.instance.data}
#' @return the Gantt chart
#' @export jssp.oo.vH.to.gantt
jssp.oo.vH.to.gantt <- function(data.oo.vH, inst.id,
                                min.job.id=1L,
                                get.inst.data=jssp.get.instance.data) {
  stopifnot(is.integer(data.oo.vH),
            is.vector(data.oo.vH),
            all(is.finite(data.oo.vH)));

  instance <- get.inst.data(inst.id);
  stopifnot(is.list(instance),
            all(c("inst.id",
                  "inst.machines",
                  "inst.jobs",
                  "inst.data") %in% names(instance)),
            identical(instance$inst.id, inst.id));

  data.oo.vH <- as.integer((data.oo.vH - min(data.oo.vH)) + 1L);
  stopifnot(length(data.oo.vH) == (instance$inst.jobs * instance$inst.machines),
            all(vapply(seq.int(from=1L,
                               to=(instance$inst.jobs * instance$inst.machines)),
                       function(i) sum(data.oo.vH == i) == 1L,
                       FALSE)));

  job.index <- rep.int(0L, instance$inst.jobs);
  data.ob   <- integer(instance$inst.jobs * instance$inst.machines);

  for(idx in seq_along(data.oo.vH)) {
    i <- data.oo.vH[[idx]];

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
                               instance });
  return(result);
}
