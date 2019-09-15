# try to automatically download and build the results from paper SS2018BBOVBCACSOJSS
old.options <- options(warn=2);

library(literatureAndResultsGen);

if(exists("logger")) {
  del.logger <- FALSE;
} else {
  del.logger <- TRUE;
  logger <- function(...) {
    cat(as.character(Sys.time()), ": ", paste(..., sep="", collapse=""), "\n", sep="", collapse="");
    invisible(TRUE);
  }
}

logger("setting up directories.");
if(exists("jssp.results.dir")) {
  del.jssp.results.dir <- FALSE;
} else {
  del.jssp.results.dir <- TRUE;
  jssp.results.dir <- dirname(sys.frame(1)$ofile);
  jssp.results.dir <- normalizePath(jssp.results.dir, mustWork = TRUE);
  stopifnot(dir.exists(jssp.results.dir));
}

if(exists("single.jssp.results.dir")) {
  del.single.jssp.results.dir <- FALSE;
} else {
  del.single.jssp.results.dir <- TRUE;
  single.jssp.results.dir <- file.path(jssp.results.dir, "single");
  single.jssp.results.dir <- normalizePath(single.jssp.results.dir, mustWork = TRUE);
  stopifnot(dir.exists(single.jssp.results.dir));
}
stopifnot(startsWith(single.jssp.results.dir, jssp.results.dir));
logger("the single-result directory is '", single.jssp.results.dir, "'.");

#' @title A Command for Cloning a Git Repository into a New Temporary Directory
#' @description Use the \code{git} system command to clone/download a git
#'   repository.
#' @param repo the repository url
#' @return a \code{list(path=path, commit=commit)} with the \code{path} to the cloned repository
#' and the current \code{commit}.
#' @include logger.R
#' @export git.clone
.git.clone <- function(repo) {
  logger("Begin cloning repo '", repo, "'.");

  destDir <- tempfile();
  dir.create(destDir);
  destDir <- normalizePath(destDir, mustWork = TRUE);
  stopifnot(dir.exists(destDir));

  ret <- system2("git", args=c("-C", destDir, "clone",
                               "--depth", "1",
                               repo, destDir));
  if(ret == 0L) {
    logger("git clone of repo '", repo,
           "' successfully completed to path '",
           destDir);

    # get the commit id
    commit <- system2("git", args=c("-C", destDir, "log",
                                    "--no-abbrev-commit"),
                      stdout = TRUE, stderr = TRUE);
    ret <- attr(commit, "status"); # check return code
    if(is.null(ret) || (is.numeric(ret) && (ret == 0))) {
      if(length(commit) > 0L) { # check loaded data
        grepped <- grep("^\\s*commit\\s+.+", commit);
        if((!(is.null(grepped))) && (length(grepped) > 0L)) {
          # get the discovered commit
          commit <- trimws(commit[[grepped[[1L]]]]);
          commit.l <- nchar(commit);
          if(commit.l > 0L) { # check its trimmed version
            commit <- trimws(substr(commit, 7, commit.l));
            if(nchar(commit) == 40L) { # commit is right length
              logger("Repository '",
                     repo, "' commit is '",
                     commit, "'.");
              return(list(path=destDir, commit=commit));
            }
          }
        }
      }
      unlink(destDir, recursive = TRUE);
      stop(paste0("git log for cloned repo '", repo,
           "' in path '",
           destDir,
           "' resulted in invalid commit id."));
    } else {
      unlink(destDir, recursive = TRUE);
      stop(paste0("git log for cloned repo '", repo,
           "' in path '",
           destDir,
           "' failed with error code ",
           ret, "."));
    }
  } else {
    unlink(destDir, recursive = TRUE);
    stop(paste0("git clone of repo '", repo,
         "' to path '",
         destDir,
         "' failed with error code ",
         ret, "."));
  }
}

# download the git repository
repo.download.dir <- .git.clone("https://github.com/quasiquasar/gta-jobshop-data")$path;
stopifnot(dir.exists(repo.download.dir));
repo.download.dir <- normalizePath(repo.download.dir, mustWork=TRUE);
logger("finished downloading data to '", repo.download.dir, "'.");
data.dir <- file.path(repo.download.dir, "data", "performance");
data.dir <- normalizePath(data.dir, mustWork=TRUE);
stopifnot(dir.exists(data.dir));

rm(".git.clone");

# translate the original naming of the instances to the dmuXX-style naming
.col.translate <- list(
  rcmax_20_15_4='dmu01',
  rcmax_20_15_10='dmu02',
  rcmax_20_15_5='dmu03',
  rcmax_20_15_8='dmu04',
  rcmax_20_15_1='dmu05',
  rcmax_20_20_6='dmu06',
  rcmax_20_20_4='dmu07',
  rcmax_20_20_7='dmu08',
  rcmax_20_20_8='dmu09',
  rcmax_20_20_5='dmu10',
  rcmax_30_15_9='dmu11',
  rcmax_30_15_10='dmu12',
  rcmax_30_15_5='dmu13',
  rcmax_30_15_4='dmu14',
  rcmax_30_15_1='dmu15',
  rcmax_30_20_7='dmu16',
  rcmax_30_20_10='dmu17',
  rcmax_30_20_9='dmu18',
  rcmax_30_20_8='dmu19',
  rcmax_30_20_2='dmu20',
  rcmax_40_15_5='dmu21',
  rcmax_40_15_9='dmu22',
  rcmax_40_15_10='dmu23',
  rcmax_40_15_8='dmu24',
  rcmax_40_15_2='dmu25',
  rcmax_40_20_1='dmu26',
  rcmax_40_20_3='dmu27',
  rcmax_40_20_6='dmu28',
  rcmax_40_20_2='dmu29',
  rcmax_40_20_7='dmu30',
  rcmax_50_15_3='dmu31',
  rcmax_50_15_1='dmu32',
  rcmax_50_15_2='dmu33',
  rcmax_50_15_4='dmu34',
  rcmax_50_15_5='dmu35',
  rcmax_50_20_2='dmu36',
  rcmax_50_20_7='dmu37',
  rcmax_50_20_6='dmu38',
  rcmax_50_20_9='dmu39',
  rcmax_50_20_3='dmu40',
  cscmax_20_15_10='dmu41',
  cscmax_20_15_5='dmu42',
  cscmax_20_15_8='dmu43',
  cscmax_20_15_7='dmu44',
  cscmax_20_15_1='dmu45',
  cscmax_20_20_6='dmu46',
  cscmax_20_20_4='dmu47',
  cscmax_20_20_3='dmu48',
  cscmax_20_20_2='dmu49',
  cscmax_20_20_9='dmu50',
  cscmax_30_15_2='dmu51',
  cscmax_30_15_9='dmu52',
  cscmax_30_15_10='dmu53',
  cscmax_30_15_5='dmu54',
  cscmax_30_15_6='dmu55',
  cscmax_30_20_9='dmu56',
  cscmax_30_20_7='dmu57',
  cscmax_30_20_3='dmu58',
  cscmax_30_20_6='dmu59',
  cscmax_30_20_4='dmu60',
  cscmax_40_15_3='dmu61',
  cscmax_40_15_6='dmu62',
  cscmax_40_15_8='dmu63',
  cscmax_40_15_4='dmu64',
  cscmax_40_15_7='dmu65',
  cscmax_40_20_10='dmu66',
  cscmax_40_20_6='dmu67',
  cscmax_40_20_8='dmu68',
  cscmax_40_20_5='dmu69',
  cscmax_40_20_9='dmu70',
  cscmax_50_15_8='dmu71',
  cscmax_50_15_6='dmu72',
  cscmax_50_15_10='dmu73',
  cscmax_50_15_4='dmu74',
  cscmax_50_15_3='dmu75',
  cscmax_50_20_1='dmu76',
  cscmax_50_20_4='dmu77',
  cscmax_50_20_3='dmu78',
  cscmax_50_20_7='dmu79',
  cscmax_50_20_9='dmu80'
);

# collect data points at the following times if available
# these should be sufficient to get a good impression of the
# capabilities of the algorithm
keep.s <- as.integer(c(3L, 5L, 30L, 60L)*60L*1000L);
stopifnot(all(!is.na(keep.s)),
          all(is.integer(keep.s)),
          all(is.finite(keep.s)),
          all(keep.s > 0L),
          all(keep.s < .Machine$integer.max));

# fix sd for length-1 vectors: we set it to 0 there
.sd <- function(x) {
  stopifnot(length(x) > 0L);
  if(length(x) <= 1L) { return(0L); }
  return(sd(x));
}

# load a single file and return measurements at the interesting points as well
# as at the last point
.load.file <- function(path) {
  logger("loading file '", path, "'.");
  stopifnot(file.exists(path),
            file.size(path) > 0L);
  frame <- read.csv(file=path,header=FALSE,
                    col.names=c("algo",
                                "expid",
                                "problem",
                                "runid",
                                "mpirank",
                                "seed",
                                "obj",
                                "time",
                                "epoch"),
                    strip.white = TRUE,
                    stringsAsFactors = FALSE,
                    colClasses = c("character", "character",
                                   "character", "integer",
                                   "integer", "character", "integer",
                                   "integer", "integer"),
                    row.names=NULL);
  frame <- force(frame);
  stopifnot(is.data.frame(frame),
            !is.null(frame),
            nrow(frame) > 0L,
            ncol(frame) == 9L);
  frame$time <- as.integer(unname(unlist(frame$time)) * 1000L);
  stopifnot(all(is.finite(frame$time)),
            all(!is.na(frame$time)),
            all(is.integer(frame$time)),
            all(frame$time > 0L),
            all(frame$time < .Machine$integer.max),
            all(!is.na(frame$oobj)),
            all(frame$obj > 0L),
            all(frame$obj < .Machine$integer.max),
            all(is.integer(frame$obj)),
            all(is.finite(frame$obj)),
            all(is.character(frame$problem)),
            all(!is.na(frame$problem)),
            all(nchar(frame$problem) > 0L),
            all(is.character(frame$expid)),
            all(!is.na(frame$expid)),
            all(nchar(frame$expid) > 0L),
            all(is.character(frame$algo)),
            all(nchar(frame$algo) > 0L),
            all(!is.na(frame$algo)));
  inst <- basename(dirname(path));
  stopifnot(!is.na(inst),
            nchar(inst) > 1L,
            all(frame$problem == paste0(inst, ".txt")));
  if(startsWith(inst, "ta")) {
    stopifnot(is.finite(as.integer(substring(inst, 3L, 4L))));
  } else {
    stopifnot(startsWith(inst, "cscmax"));
    inst <- .col.translate[[inst]];
    stopifnot(!is.na(inst),
              startsWith(inst, "dmu"),
              is.finite(as.integer(substring(inst, 4L, 5L))));
  }
  frame$problem <- as.character(rep.int(inst, nrow(frame)));

  seeds <- unname(unlist(frame$seed));
  seeds.u <- unique(seeds);
  if(length(seeds.u) > 1L) {
    # in the tabu search experiment, there are multiple runs in one file
    frames <- lapply(seeds.u, function(x) frame[seeds==x,]);
  } else {
    frames <- list(frame);
  }
  rm("frame");

  # check result
  stopifnot(is.list(frames),
            length(frames) > 0L,
            all(vapply(frames, is.data.frame, FALSE)));
  for(frame in frames) {
    stopifnot(all(is.finite(frame$time)),
              all(!is.na(frame$time)),
              all(is.integer(frame$time)),
              all(frame$time > 0L),
              all(frame$time < .Machine$integer.max),
              all(!is.na(frame$oobj)),
              all(frame$obj > 0L),
              all(frame$obj < .Machine$integer.max),
              all(is.integer(frame$obj)),
              all(is.finite(frame$obj)),
              all(is.character(frame$problem)),
              all(!is.na(frame$problem)),
              all(nchar(frame$problem) > 0L),
              all(is.character(frame$expid)),
              all(!is.na(frame$expid)),
              all(nchar(frame$expid) > 0L),
              all(is.character(frame$algo)),
              all(nchar(frame$algo) > 0L),
              all(!is.na(frame$algo)));
  }

  # keep the unique points
  frames <- lapply(frames, function(frame) {
    keep <- unique(findInterval(keep.s, as.integer(unname(unlist(frame$time)))));
    keep <- keep[keep > 0L];
    stopifnot(length(keep) >= 1L,
              all(is.finite(keep)),
              all(keep >= 1L),
              all(keep <= nrow(frame)));
    keep <- sort(unique(c(keep, nrow(frame))));
    stopifnot(length(keep) >= 1L,
              all(is.finite(keep)),
              all(keep >= 1L),
              all(keep <= nrow(frame)));
    frame <- frame[keep, c(2L, 3L, 7L, 8L)];
    stopifnot(identical(colnames(frame), c("expid",
                                           "problem",
                                           "obj",
                                           "time")),
              nrow(frame) == length(keep),
              nrow(frame) > 0L);
    return(frame);
  });
  frames <- force(frames);

  # check result
  stopifnot(is.list(frames),
            length(frames) > 0L,
            all(vapply(frames, is.data.frame, FALSE)));
  for(frame in frames) {
    stopifnot(all(is.finite(frame$time)),
              all(!is.na(frame$time)),
              all(is.integer(frame$time)),
              all(frame$time > 0L),
              all(frame$time < .Machine$integer.max),
              all(!is.na(frame$oobj)),
              all(frame$obj > 0L),
              all(frame$obj < .Machine$integer.max),
              all(is.integer(frame$obj)),
              all(is.finite(frame$obj)),
              all(is.character(frame$problem)),
              all(!is.na(frame$problem)),
              all(nchar(frame$problem) > 0L),
              all(is.character(frame$expid)),
              all(!is.na(frame$expid)),
              all(nchar(frame$expid) > 0L));
  }

  gc();
  return(frames);
}

# the following dirs are interesting
# we merge the experiments with and without a fixed budget if the algorithms are the same
sub.dirs <- list(gtacurve=normalizePath(file.path(data.dir, "gta", "gtacurve"), mustWork=TRUE),
                 gtacurvetime=normalizePath(file.path(data.dir, "gta", "gtacurvetime"), mustWork=TRUE),
                 gtacurve0001=normalizePath(file.path(data.dir, "gta", "gtacurve0001"), mustWork=TRUE),
                 stabu=c(normalizePath(file.path(data.dir, "stabu", "tabu0"), mustWork=TRUE),
                         normalizePath(file.path(data.dir, "stabu", "tabutime"), mustWork=TRUE)));
stopifnot(all(unlist(lapply(sub.dirs, dir.exists))));

# compute the mode: the most-often occuring value
# if multiple values occur most often, we compute their
# median (this is kind of hacky, but it should give a good)
# impression
.mode <- function(data) {
  values <- sort(unique(data));
  count <- vapply(values, function(v) sum(data == v), NA_integer_);
  stopifnot(all(count > 0L),
            all(!is.na(count)),
            all(count <= length(data)));
  count.max <- max(count);
  values <- values[count >= count.max];
  stopifnot(length(values) >= 1L);
  mode <- median(values);
  stopifnot(is.finite(mode),
            mode > 0L);
  return(mode);
}

# load a set of directories belonging to one algorithm and merge
# their data
.load.dir <- function(dirs, sub) {
  logger("loading sub-directory '", sub, "' for directories '", paste(dirs, sep="', '", collapse="', '"), "'.");
  dirs <- vapply(dirs, function(f) normalizePath(file.path(f, sub), mustWork = FALSE), NA_character_);
  dirs <- dirs[dir.exists(dirs)];
  stopifnot(length(dirs) > 0L,
            all(dir.exists(dirs)));

  files <- unname(unlist(list.files(path=dirs, pattern=".+\\.txt", full.names = TRUE, no..=TRUE)));
  files <- sort(unique(files[!startsWith(files, ".")]));
  stopifnot(length(files) > 0L,
            all(nchar(files) > 0L),
            all(!is.na(files)));
  logger("found ", length(files), " log files.");
  loaded <- lapply(files, .load.file);

  stopifnot(is.list(loaded),
            length(loaded) > 0L,
            all(vapply(loaded, is.list, FALSE)),
            all(vapply(loaded, length, NA_integer_) > 0L),
            all(unlist(lapply(loaded, function(l) vapply(l, is.data.frame, FALSE)))));
  loaded <- unlist(loaded, recursive = FALSE);
  stopifnot(is.list(loaded),
            all(vapply(loaded, length, NA_integer_) > 0L),
            all(vapply(loaded, is.data.frame, FALSE)));

  logger("done loading ", length(files), " log files.");
  rm("files");
  i <- unname(unlist(lapply(loaded, function(l) l$problem)));
  inst.id <- i[1L];
  stopifnot(length(i) > 0L,
            all(i == inst.id),
            all(!is.na(i)));
  rm("i");

  # compute the maximum permitted runtime consumed until time
  t.max <- max(unname(unlist(lapply(loaded, function(l) l$time))));
  stopifnot(t.max > 0L,
            is.finite(t.max),
            !is.na(t.max),
            t.max < .Machine$integer.max);
  t.max <- as.integer(t.max);

  t.min <- min(unname(unlist(vapply(loaded, function(l) max(unname(unlist(l$time))), NA_integer_))));
  stopifnot(t.min > 0L,
            is.finite(t.min),
            !is.na(t.min),
            t.min < .Machine$integer.min,
            t.min <= t.max);
  t.min <- as.integer(t.min);

  # compute the time indices to keep: we create one maximum point without budget
  # and simulate budgets from the "interesting list" keep.s for which all runs
  # have measurements
  keep.ss <- sort(unique(c(keep.s[keep.s <= t.min], t.min, t.max)));
  stopifnot(length(keep.ss) > 0L,
            all(is.finite(keep.ss)),
            all(keep.ss > 0L),
            all(keep.ss < .Machine$integer.max),
            all(!is.na(keep.ss)));
  keep.ss <- as.integer(keep.ss);
  logger("found least-maximum time ", t.min, " and largest-maximum time ", t.max,
         " in the ", length(loaded), " runs, leading to interesting points ",
         paste(keep.ss, sep=", ", collapse=", "), ".");

# for each time indice, compute the time statistics
  result <- lapply(keep.ss, function(time) {
# for simulated budget time, first check if we have measurements there
    found <- vapply(loaded, function(l) {
      f <- findInterval(time, l$time);
      if(f <= 0L) { return(NA_integer_); }
      stopifnot(is.finite(f),
                f > 0L,
                f <= nrow(l));
      return(f);
    }, NA_integer_);
# no measurements? quit
    if(all(is.na(found))) { return(NULL); }
# all runs with measurements count as "run", i.e., set n.runs accordingly
    sel <- !is.na(found);
    n.runs <- sum(sel);
    stopifnot(n.runs > 0L);
    found <- found[sel];
    runs <- loaded[sel];
    stopifnot(length(runs) == n.runs,
              length(found) == n.runs);

# for the simulated budget, extract all objective values
    obj  <- vapply(seq_along(runs), function(i) runs[[i]]$obj[[found[[i]]]], NA_integer_);
    stopifnot(all(is.finite(obj)),
              all(!is.na(obj)),
              all(obj > 0L),
              length(obj) == n.runs);
# now check which objective value is the best obtained within the budget
    obj.min <- min(obj);
    stopifnot(is.finite(obj.min));
    obj.min.sel <- (obj == obj.min);
    stopifnot(any(obj.min.sel),
              all(!is.na(obj.min.sel)),
              !any(obj < obj.min));
# and count how many runs reached it
    reach.best.f.min.runs <- sum(obj.min.sel);
    stopifnot(reach.best.f.min.runs > 0L,
              reach.best.f.min.runs <= length(obj));

    stopifnot(all(is.finite(obj)),
              all(!is.na(obj)),
              all(obj > 0L),
              length(obj) == n.runs);

# get the consumed times of the last log point within the runs within the budget, i.e.,
# the last improvement times
    times <- vapply(seq_along(runs), function(i) runs[[i]]$time[[found[[i]]]], NA_integer_);
    stopifnot(all(is.finite(times)),
              all(!is.na(times)),
              all(times > 0L),
              length(times) == n.runs);
# get the total times: if the run consumed at least as much time as the virtual budget, the total
# time is the simulated budget. otherwise, it is total consumed by the run
    times.total <- vapply(seq_along(runs), function(i) as.integer(min(time, max(runs[[i]]$time))), NA_integer_);
    stopifnot(all(is.finite(times.total)),
              all(!is.na(times.total)),
              all(times.total > 0L),
              length(times.total) == n.runs);
# if all runs consumed at least the simulated budget, we set it as true budget, otherwise,
# we do not specify a true budget
    if(all(times.total >= time)) {
      stopifnot(all(times.total <= time));
      budget.time <- time;
    } else {
      budget.time <- NA_integer_;
    }

# compute the times to reach the best solution
    times.min <- times[obj.min.sel];
    stopifnot(length(times.min)==reach.best.f.min.runs,
              all(is.finite(times.min)),
              all(times.min) > 0L);

# return the result
    res <- (list(inst.id=inst.id,
                n.runs=n.runs,
                budget.time=budget.time,
                best.f.min=obj.min,
                best.f.mean=mean(obj),
                best.f.med=median(obj),
                best.f.mode=.mode(obj),
                best.f.max=max(obj),
                best.f.sd=.sd(obj),
                last.improvement.time.min=min(times),
                last.improvement.time.mean=mean(times),
                last.improvement.time.med=median(times),
                last.improvement.time.mode=.mode(times),
                last.improvement.time.max=max(times),
                last.improvement.time.sd=.sd(times),
                total.time.min=min(times.total),
                total.time.mean=mean(times.total),
                total.time.med=median(times.total),
                total.time.mode=.mode(times.total),
                total.time.max=max(times.total),
                total.time.sd=.sd(times.total),
                reach.best.f.min.runs=reach.best.f.min.runs,
                reach.best.f.min.time.min=min(times.min),
                reach.best.f.min.time.mean=min(times.min),
                reach.best.f.min.time.med=median(times.min),
                reach.best.f.min.time.mode=.mode(times.min),
                reach.best.f.min.time.max=max(times.min),
                reach.best.f.min.time.sd=.sd(times.min)
                ));
    res <- force(res);
    return(res);
  });

  result <- result[ (!vapply(result, is.null, FALSE)) ];
  stopifnot(length(result) > 0L);

  result <- do.call(rbind, lapply(result, as.data.frame));
  stopifnot(is.data.frame(result),
            nrow(result) > 0L);
  result <- unique(result);
  stopifnot(is.data.frame(result),
            nrow(result) > 0L);
  rownames(result) <- NULL;
  stopifnot(is.data.frame(result),
            nrow(result) > 0L);
  cc <- colnames(result) == "budget.time";
  stopifnot(sum(cc) %in% c(0L, 1L));
  if(any(cc)) {
    if(!any(is.finite(result$budget.time))) {
      result <- result[, !cc];
      result <- force(result);
    }
  }
  return(result);
}

# load a set of directories
.load.dirs <- function(dirs) {
  sub.sub.dirs <- sort(unique(unname(unlist(lapply(dirs, function(d) {
    d <- unname(unlist(list.dirs(d, full.names = FALSE,recursive = FALSE)));
    d <- sort(unique(d[!startsWith(d, ".")]));
  })))));

  frames <- lapply(sub.sub.dirs, function(ssd) .load.dir(dirs, ssd));
  rows <- vapply(frames, nrow, NA_integer_);
  stopifnot(is.list(frames),
            length(frames) == length(sub.sub.dirs),
            all(rows > 0L),
            all(is.finite(rows)));
  frames <- do.call(rbind, frames);
  stopifnot(is.data.frame(frames),
            nrow(frames) == sum(rows));
  frames <- frames[order(frames$inst.id), ];
  frames <- force(frames);
  stopifnot(is.data.frame(frames),
            nrow(frames) == sum(rows));
  for(i in seq.int(from=2L, to=ncol(frames))) {
    frames[, i] <- try.convert.numeric.to.int(frames[, i], stopIfFails = FALSE, canFloor = FALSE);
  }
  gc();
  return(frames);
}

# some results of gtacurve were not reported in the git repository
# these include some of the bks in the paper
# thus, for bks listed in the paper that we cannot find in the
# results, we add an additional run
gtacurve.not.reported.inst.id = c("dmu12",
                                  "dmu16",
                                  "dmu17",
                                  "dmu19",
                                  "dmu42",
                                  "dmu43",
                                  "dmu44",
                                  "dmu48",
                                  "dmu49",
                                  "dmu51",
                                  "dmu53",
                                  "dmu54",
                                  "dmu55",
                                  "dmu57",
                                  "dmu58",
                                  "dmu59",
                                  "dmu60",
                                  "dmu61",
                                  "dmu62",
                                  "dmu63",
                                  "dmu64",
                                  "dmu65",
                                  "dmu67",
                                  "dmu68",
                                  "dmu70",
                                  "dmu72",
                                  "dmu73",
                                  "dmu74",
                                  "dmu75",
                                  "dmu76",
                                  "dmu77",
                                  "dmu79",
                                  "dmu80",
                                  "ta40",
                                  "ta48");
gtacurve.not.reported.best.f.min = c(3492L,
                                     3751L,
                                     3814L,
                                     3765L,
                                     3390L,
                                     3441L,
                                     3475L,
                                     3763L,
                                     3710L,
                                     4156L,
                                     4390L,
                                     4362L,
                                     4270L,
                                     5655L,
                                     4708L,
                                     4619L,
                                     4739L,
                                     5172L,
                                     5251L,
                                     5323L,
                                     5240L,
                                     5190L,
                                     5779L,
                                     5765L,
                                     5889L,
                                     6463L,
                                     6153L,
                                     6196L,
                                     6189L,
                                     6807L,
                                     6792L,
                                     6952L,
                                     6673L,
                                     1671L,
                                     1937L);
stopifnot(length(gtacurve.not.reported.inst.id) == length(gtacurve.not.reported.best.f.min));

for(name in names(sub.dirs)) {
  frame <- .load.dirs(sub.dirs[[name]]);
  stopifnot(is.data.frame(frame),
            nrow(frame) > 0L);
  dest <- file.path(single.jssp.results.dir, paste0(name, ".txt"));
  write.csv(frame, file=dest, quote=FALSE, row.names = FALSE);
  stopifnot(file.exists(dest),
            file.size(dest)>(nrow(frame)*(1L+ncol(frame))));
  if(startsWith(name, "gta") && length(gtacurve.not.reported.inst.id) > 0L) {
    reported.id <- as.character(unname(unlist(frame$inst.id)));
    reported.bks <- unname(unlist(frame$best.f.min));
    keep <- vapply(seq_along(gtacurve.not.reported.inst.id),
                   function(index) {
                     where <- (reported.id==gtacurve.not.reported.inst.id[index]);
                     if(any(where)) {
                       best <- min(reported.bks[where]);
                       stopifnot(length(best)==1L,
                                 is.integer(best),
                                 best > 0L);
                       return(best > gtacurve.not.reported.best.f.min[index]);
                     } else {
                       return(TRUE);
                     }
                   }, FALSE);
    gtacurve.not.reported.inst.id <- gtacurve.not.reported.inst.id[keep];
    gtacurve.not.reported.best.f.min <- gtacurve.not.reported.best.f.min[keep];
    rm("keep");
    rm("reported.id");
    rm("reported.bks");
  }
  rm("frame");
  rm("dest");
}

stopifnot(length(gtacurve.not.reported.inst.id) > 0L,
          length(gtacurve.not.reported.inst.id) == length(gtacurve.not.reported.best.f.min));
dest <- file.path(single.jssp.results.dir, "gtacurve-not-contained.txt");
write.csv(data.frame(inst.id=gtacurve.not.reported.inst.id,
                     best.f.min=gtacurve.not.reported.best.f.min),
          file=dest, quote=FALSE, row.names = FALSE);
rm("dest");
rm("gtacurve.not.reported.inst.id");
rm("gtacurve.not.reported.best.f.min");

rm("name");
logger("created files '", paste(paste0(names(sub.dirs), ".txt"), sep="', '", collapse="', '"), ".");

logger("done loading and processing data, now purging downloaded files.");
rm("data.dir");
rm("sub.dirs");
unlink(repo.download.dir, recursive = TRUE);
rm("repo.download.dir");
rm(".load.file");
rm(".load.dirs");
rm(".col.translate");
rm("keep.s");

logger("done processing, now clearing all unnecessary data.");
if(del.single.jssp.results.dir) {
  rm("single.jssp.results.dir");
}
rm("del.single.jssp.results.dir");
if(del.jssp.results.dir) {
  rm("jssp.results.dir");
}
rm("del.jssp.results.dir");
if(del.logger) {
  rm("logger");
}
rm("del.logger");
options(old.options);
rm("old.options");
