logger("beginning to try to load the instance data.");

library(literatureAndResultsGen);

stopifnot(exists("jssp.instances"),
          is.data.frame(jssp.instances),
          nrow(jssp.instances) > 0L);

inst.data.path <- file.path(dir.data.raw, "instance-data");
inst.data.path <- normalizePath(inst.data.path, mustWork = TRUE);
stopifnot(dir.exists(inst.data.path));



# make and validate an instance record
make.instance.record <- function(inst.id, inst.notes, inst.machines, inst.jobs, inst.data) {
  stopifnot(is.character(inst.id),
            length(inst.id) == 1L,
            nchar(inst.id) > 0L,
            !is.na(inst.id),
            is.character(inst.notes),
            length(inst.notes) == 1L,
            nchar(inst.notes) >= 0L,
            !is.na(inst.notes),
            is.integer(inst.machines),
            is.finite(inst.machines),
            inst.machines > 0L,
            is.integer(inst.jobs),
            is.finite(inst.jobs),
            inst.jobs > 0L,
            is.integer(inst.data),
            is.matrix(inst.data),
            all(is.finite(inst.data)),
            nrow(inst.data) == inst.jobs,
            ncol(inst.data) == (2L * inst.machines));

  inst.id <- trimws(inst.id);

  found <- (inst.id == jssp.instances$inst.id);
  stopifnot(sum(found) == 1L);
  found <- which(found);
  stopifnot(length(found) == 1L,
            is.finite(found),
            found > 0L,
            found <= nrow(jssp.instances));
  stopifnot(inst.id == jssp.instances$inst.id[[found]],
            inst.machines == jssp.instances$inst.machines[[found]],
            inst.jobs == jssp.instances$inst.jobs[[found]]);

  # verify lower bounds
  inst.opt.bound.lower <- jssp.instances$inst.opt.bound.lower[[found]];
  inst.bks <- jssp.instances$inst.bks[[found]];
  stopifnot(is.integer(inst.opt.bound.lower),
            length(inst.opt.bound.lower) == 1L,
            is.finite(inst.opt.bound.lower),
            inst.opt.bound.lower > 0L,
            is.integer(inst.bks),
            length(inst.bks) == 1L,
            is.finite(inst.bks),
            inst.bks >= inst.opt.bound.lower,
            inst.bks < .Machine$integer.max);

  machines <- lapply(seq_len(inst.jobs), function(i)
    unname(unlist(inst.data[i, (1L+(2L*seq.int(from=0L, to=(inst.machines-1L))))])));
  stopifnot(all(vapply(machines, function(m) identical(unique(m), m), FALSE)),
            all(vapply(machines, function(m) all((m >= 0L) & (m < inst.machines)), FALSE)),
            all(!is.na(unlist(machines))),
            all(is.finite(unlist(machines))));
  times <- lapply(seq_len(inst.jobs), function(i)
    unname(unlist(inst.data[i, (2L*seq.int(from=1L, to=inst.machines))])));
  stopifnot(all(unlist(times) >= 0L),
            all(is.finite(unlist(times))),
            all(!is.na(unlist(times))));

  lb <- max(vapply(times, sum, NA_integer_));
  stopifnot(lb <= inst.opt.bound.lower);

  m.times <- vapply(seq.int(from=0L, to=(inst.machines-1L)),
               function(m) sum(vapply(seq_along(times),
                                      function(tt) { sel.times <- times[[tt]];
                                                     sel.mach <- machines[[tt]];
                                                     sel.times[sel.mach == m] }, NA_integer_)),
               NA_integer_);
  stopifnot(all(is.finite(m.times)),
            all(m.times>= 0L));

  m.prefix <- vapply(seq.int(from=0L, to=(inst.machines-1L)),
                     function(m) min(vapply(seq_along(times),
                                            function(tt) {
                                              sel.times <- times[[tt]];
                                              sel.mach <- machines[[tt]];
                                              start <- which(sel.mach == m);
                                              stopifnot(length(start) == 1L);
                                              if(start <= 1L) { return(0L); }
                                              return(sum(sel.times[1L:(start-1L)]));
                                            }, NA_integer_)),
                     NA_integer_);
  stopifnot(all(is.finite(m.prefix)),
            all(m.prefix >= 0L));

  m.suffix <- vapply(seq.int(from=0L, to=(inst.machines-1L)),
                     function(m) min(vapply(seq_along(times),
                                            function(tt) {
                                              sel.times <- times[[tt]];
                                              sel.mach <- machines[[tt]];
                                              start <- which(sel.mach == m);
                                              stopifnot(length(start) == 1L);
                                              if(start >= length(sel.times)) { return(0L); }
                                              return(sum(sel.times[(start+1L):length(sel.times)]));
                                            }, NA_integer_)),
                     NA_integer_);
  stopifnot(all(is.finite(m.suffix)),
            all(m.suffix >= 0L));
  m.t <- m.times + m.prefix + m.suffix;
  stopifnot(all(is.finite(m.t)),
            all(m.t >= 0L));

  stopifnot(all(m.t <= inst.opt.bound.lower));

  s <- sum(unname(unlist(c(inst.data))));
  stopifnot(is.finite(s),
            s > 0L,
            s < .Machine$integer.max,
            as.integer(s) == s);

  inst.notes <- trimws(inst.notes);
  inst.notes.2 <- paste0("lower bound: ", inst.opt.bound.lower,
                         "; best known solution: ", inst.bks);
  if(nchar(inst.notes) > 0L) {
    inst.notes <- paste0(gsub(";", ",", inst.notes, fixed=TRUE), "; ", inst.notes.2);
  } else {
    inst.notes <- inst.notes.2;
  }

  inst.record <- list(inst.id = inst.id,
                      inst.notes = inst.notes,
                      inst.machines = inst.machines,
                      inst.jobs = inst.jobs,
                      inst.opt.bound.lower = inst.opt.bound.lower,
                      inst.bks = inst.bks,
                      inst.data = inst.data);
  inst.record <- force(inst.record);
  inst.record <- do.call(force, list(inst.record));
  return(inst.record);
}

logger("now loading and processing orlib instances.");

orlib.path <- file.path(inst.data.path, "instance_data_orlib.txt");
orlib.path <- normalizePath(orlib.path, mustWork = TRUE);
stopifnot(file.exists(orlib.path),
          file.size(orlib.path) > 0L);

orlib.text <- readLines(orlib.path);
rm("orlib.path");

stopifnot(is.character(orlib.text),
          length(orlib.text) > 0L);
orlib.text <- trimws(orlib.text);
orlib.text <- gsub("\t", " ", orlib.text, fixed=TRUE);
orlib.text <- gsub("  ", " ", orlib.text, fixed=TRUE);
orlib.text <- trimws(orlib.text);
orlib.text <- orlib.text[nchar(orlib.text) > 0L];
stopifnot(is.character(orlib.text),
          length(orlib.text) > 0L,
          all(nchar(orlib.text) > 0L));

line.sep <- "+++++++++++++++++++";
separators <- startsWith(orlib.text, line.sep);
stopifnot(is.logical(separators),
          length(separators) == length(orlib.text));
separators <- which(separators);
stopifnot(is.integer(separators),
          length(separators) > 0L);
separators <- separators[-1L];
stopifnot((((2L*as.integer(length(separators) / 2L)))+ 1L) == length(separators));

orlib.instances <- unname(lapply(seq.int(from=0L, to=(as.integer(length(separators) / 2L)-1L)),
  function(index) {
    start <- separators[[(index*2L) + 1L]];
    mid <- separators[[(index*2L) + 2L]];
    end <- separators[[(index*2L) + 3L]];
    stopifnot(start == (mid - 2L),
              mid < (end - 4L));

    inst.id <- orlib.text[[start + 1L]];
    stopifnot(nchar(inst.id) > 0L,
              startsWith(inst.id, "instance "));
    inst.id <- trimws(substr(inst.id, 10L, nchar(inst.id)));
    stopifnot(nchar(inst.id) > 0L);

    inst.notes <- orlib.text[[mid + 1]];
    stopifnot(nchar(inst.notes) > 0L);
    inst.jobs.machines <- orlib.text[[mid + 2L]];
    stopifnot(nchar(inst.jobs.machines) > 0L);
    inst.jobs.machines <- trimws(unname(unlist(strsplit(inst.jobs.machines, "\\s+"))));
    stopifnot(length(inst.jobs.machines) == 2L,
              all(nchar(inst.jobs.machines) > 0L));
    inst.jobs.machines <- as.integer(inst.jobs.machines);
    stopifnot(length(inst.jobs.machines) == 2L,
              all(is.finite(inst.jobs.machines)),
              all(!is.na(inst.jobs.machines)),
              all(inst.jobs.machines > 0L));
    inst.jobs <- inst.jobs.machines[[1L]];
    inst.machines <- inst.jobs.machines[[2L]];
    stopifnot(is.integer(inst.jobs),
              length(inst.jobs) == 1L,
              inst.jobs > 0L,
              is.finite(inst.jobs),
              !is.na(inst.jobs),
              is.integer(inst.machines),
              length(inst.machines) == 1L,
              inst.machines > 0L,
              is.finite(inst.machines),
              !is.na(inst.machines));

    inst.data <- orlib.text[seq.int(from=(mid + 3L), to=(end - 1L))];
    stopifnot(is.character(inst.data),
              length(inst.data) == inst.jobs,
              all(!is.na(inst.data)),
              all(nchar(inst.data) > 0L));
    inst.data <- strsplit(inst.data, "\\s+");
    stopifnot(all(vapply(inst.data, is.character, FALSE)),
              length(inst.data) == inst.jobs,
              all(vapply(inst.data, length, NA_integer_) == (2L * inst.machines)));
    inst.data <- lapply(inst.data, as.integer);
    stopifnot(all(vapply(inst.data, is.integer, FALSE)));
    inst.data <- do.call(rbind, inst.data);
    stopifnot(is.matrix(inst.data),
              is.integer(inst.data),
              ncol(inst.data) == (2L * inst.machines),
              nrow(inst.data) == inst.jobs);

    result <- make.instance.record(inst.id, inst.notes, inst.machines, inst.jobs, inst.data);
    result <- force(result);
    result <- do.call(force, list(result));
    return(result);
  }));

rm("orlib.text");

rm("separators");
rm("line.sep");

logger("finished loading and processing orlib instances, now working on the demirkol instances.");

dir.demirkol <- file.path(inst.data.path, "demirkol");
dir.demirkol <- normalizePath(dir.demirkol, mustWork = TRUE);
stopifnot(dir.exists(dir.demirkol));

# translate the original naming of the instances to the dmuXX-style naming
name.translate <- list(
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

demirkol.instances <- lapply(list.files(dir.demirkol, pattern=".*\\.txt",
                                        full.names = TRUE, recursive = FALSE,
                                        include.dirs = FALSE,
                                        no..=TRUE),
                             function(file) {
                               stopifnot(file.exists(file),
                                         file.size(file) > 0L);
    inst.name <- basename(file);
    inst.name <- substr(inst.name, 1L, nchar(inst.name) - 4L);
    stopifnot(is.character(inst.name),
              nchar(inst.name) > 0L);

    inst.id <- name.translate[[inst.name]];
    stopifnot(length(inst.id)== 1L,
              is.character(inst.id),
              !is.na(inst.id),
              nchar(inst.id) > 0L);

    text <- readLines(file);
    stopifnot(is.character(text),
              length(text) > 0L);
    text <- trimws(text);
    text <- text[nchar(text) > 0L];
    stopifnot(is.character(text),
              length(text) > 0L);

    inst.jobs.machines <- text[[1L]];
    stopifnot(nchar(inst.jobs.machines) > 0L);
    inst.jobs.machines <- trimws(unname(unlist(strsplit(inst.jobs.machines, "\\s+"))));
    stopifnot(length(inst.jobs.machines) == 2L,
              all(nchar(inst.jobs.machines) > 0L));
    inst.jobs.machines <- as.integer(inst.jobs.machines);
    stopifnot(length(inst.jobs.machines) == 2L,
              all(is.finite(inst.jobs.machines)),
              all(!is.na(inst.jobs.machines)),
              all(inst.jobs.machines > 0L));
    inst.jobs <- inst.jobs.machines[[1L]];
    inst.machines <- inst.jobs.machines[[2L]];
    stopifnot(is.integer(inst.jobs),
              length(inst.jobs) == 1L,
              inst.jobs > 0L,
              is.finite(inst.jobs),
              !is.na(inst.jobs),
              is.integer(inst.machines),
              length(inst.machines) == 1L,
              inst.machines > 0L,
              is.finite(inst.machines),
              !is.na(inst.machines));

    inst.data <- text[-1L];
    stopifnot(is.character(inst.data),
              length(inst.data) == inst.jobs,
              all(!is.na(inst.data)),
              all(nchar(inst.data) > 0L));
    inst.data <- strsplit(inst.data, "\\s+");
    stopifnot(all(vapply(inst.data, is.character, FALSE)),
              length(inst.data) == inst.jobs,
              all(vapply(inst.data, length, NA_integer_) == (2L * inst.machines)));
    inst.data <- lapply(inst.data, as.integer);
    stopifnot(all(vapply(inst.data, is.integer, FALSE)));
    inst.data <- do.call(rbind, inst.data);
    stopifnot(is.matrix(inst.data),
              is.integer(inst.data),
              ncol(inst.data) == (2L * inst.machines),
              nrow(inst.data) == inst.jobs);

    result <- make.instance.record(inst.id, paste0("original name: ", inst.name),
                                   inst.machines, inst.jobs, inst.data);
    result <- force(result);
    result <- do.call(force, list(result));
    return(result);
  });

rm("dir.demirkol");
rm("name.translate");

logger("finished loading demirkol instances, now loading taillard instances.");

dir.taillard <- file.path(inst.data.path, "taillard");
dir.taillard <- normalizePath(dir.taillard, mustWork = TRUE);
stopifnot(dir.exists(dir.taillard));

taillard.index <- new.env();
assign(x="i", value=0L, pos=taillard.index);
taillard.instances <- unlist(lapply(sort(list.files(dir.taillard, pattern=".*\\.txt",
                                        full.names = TRUE, recursive = FALSE,
                                        include.dirs = FALSE,
                                        no..=TRUE)),
 function(file) {
   stopifnot(file.exists(file),
             file.size(file) > 0L);

   text <- readLines(file);
   stopifnot(is.character(text),
             length(text) > 0L);
   text <- trimws(text);
   text <- gsub("\t", " ", text, fixed=TRUE);
   text <- gsub("  ", " ", text, fixed=TRUE);
   text <- text[nchar(text) > 0L];
   stopifnot(is.character(text),
             length(text) > 0L);

   found <- startsWith(text, "Nb of jobs");
   stopifnot(is.logical(found),
             length(found) == length(text),
             sum(found) == 10L);

   found <- which(found);
   stopifnot(is.integer(found),
             all(found > 0L),
             length(found) == 10L);

   return(lapply(seq_along(found),
    function(i) {
      start <- found[[i]];
      if(i >= length(found)) {
        end <- length(text);
      } else {
        end <- (found[[i + 1L]] - 1L);
      }

      stopifnot(is.integer(start),
                is.finite(start),
                !is.na(start),
                start > 0L,
                start < length(text),
                is.integer(end),
                is.finite(end),
                !is.na(end),
                end > 0L,
                end <= length(text),
                end > (start + 5L));
      use.text <- text[seq.int(from=start, to=end)];
      stopifnot(is.character(use.text),
                length(use.text) == (end - start + 1L),
                length(use.text) > 5L,
                startsWith(use.text[[1L]], "Nb of jobs"));

      inst.jobs.machines <- use.text[[2L]];
      stopifnot(nchar(inst.jobs.machines) > 0L);
      inst.jobs.machines <- trimws(unname(unlist(strsplit(inst.jobs.machines, "\\s+"))));
      stopifnot(length(inst.jobs.machines) == 6L,
                all(nchar(inst.jobs.machines) > 0L));
      inst.jobs.machines <- as.integer(inst.jobs.machines[1L:2L]);
      stopifnot(length(inst.jobs.machines) == 2L,
                all(is.finite(inst.jobs.machines)),
                all(!is.na(inst.jobs.machines)),
                all(inst.jobs.machines > 0L));
      inst.jobs <- inst.jobs.machines[[1L]];
      inst.machines <- inst.jobs.machines[[2L]];

      stopifnot(identical(use.text[[3L]], "Times"));
      machines <- use.text == "Machines";
      stopifnot(is.logical(machines),
                all(!is.na(machines)),
                sum(machines) == 1L);
      machines <- which(machines);
      stopifnot(is.integer(machines),
                is.finite(machines),
                !is.na(machines),
                machines > 4L,
                machines < length(use.text));
      times <- lapply(strsplit(use.text[4L:(machines-1L)], "\\s+"), as.integer)
      stopifnot(length(times) == inst.jobs,
                all(vapply(times, length, NA_integer_) == inst.machines),
                all(vapply(unlist(times), is.finite, FALSE)),
                all(vapply(unlist(times), function(t) t >= 0L, FALSE)));
      machines <- lapply(strsplit(use.text[(machines+1L):length(use.text)], "\\s+"),
                         function(t) as.integer(t) - 1L);
      stopifnot(length(machines) == inst.jobs,
                all(vapply(machines, length, NA_integer_) == inst.machines),
                all(vapply(unlist(machines), is.finite, FALSE)),
                all(vapply(unlist(machines), function(t) ((t >= 0L) && (t < inst.machines)), FALSE)),
                length(times) == length(machines),
                all(vapply(times, length, NA_integer_) == vapply(machines, length, NA_integer_)));

      inst.data <- lapply(seq_along(times),
                    function(i) c(rbind(machines[[i]], times[[i]])));
      inst.data <- do.call(rbind, inst.data);
      stopifnot(is.matrix(inst.data),
                nrow(inst.data) == inst.jobs,
                ncol(inst.data) == (2L * inst.machines));

      inst.id <- get(x="i", pos=taillard.index);
      stopifnot(is.integer(inst.id),
                is.finite(inst.id));
      inst.id <- inst.id + 1L;
      stopifnot(inst.id > 0L);
      assign(x="i", value=inst.id, pos=taillard.index);
      if(inst.id > 9L) {
        inst.id <- paste0("ta", inst.id);
      } else {
        inst.id <- paste0("ta0", inst.id);
      }


      result <- make.instance.record(inst.id, "",
                                     inst.machines, inst.jobs, inst.data);
      result <- force(result);
      result <- do.call(force, list(result));
      return(result);
    }));
 }), recursive = FALSE);


rm("taillard.index");
rm("dir.taillard");

logger("finished loading taillard instances, now merging and validating instances");

jssp.instance.data <- unlist(list(orlib.instances, demirkol.instances,
                                  taillard.instances), recursive = FALSE);
rm("orlib.instances");
rm("taillard.instances");
rm("demirkol.instances")

names(jssp.instance.data) <- vapply(jssp.instance.data, function(i) i$inst.id, NA_character_);
stopifnot(identical(names(jssp.instance.data), unique(names(jssp.instance.data))));

jssp.instance.data <- jssp.instance.data[order(names(jssp.instance.data))];

stopifnot(identical(names(jssp.instance.data), as.character(jssp.instances$inst.id)));
rm("make.instance.record");

logger("done composing and validating instance data, now creating OR-Lib compatible textual representation.");

stopifnot(exists("jssp.bibliography"),
          is.data.frame(jssp.bibliography));

text <- unname(unlist(c(
          paste0("This file contains a set of ", nrow(jssp.instances), " JSP test instances."),
          "",
          "The original data of these instances stem from: ",
          "- OR-Library (http://people.brunel.ac.uk/~mastjjb/jeb/orlib/jobshopinfo.html) [the abz*, la*, orb*, and yn* instances]",
          "- Oleg V. Shylo's page (http://optimizizer.com/DMU.php) [the dmu* instances]",
          "- Érick Taillard's page (http://mistic.heig-vd.ch/taillard/problemes.dir/ordonnancement.dir/ordonnancement.html) [the ta* instaces]",
          "",
          unname(unlist(lapply(unique(jssp.instances$inst.ref),
                  function(ref) {
                    found <- sort(as.character(jssp.instances$inst.id[jssp.instances$inst.ref == ref]));
                    unname(unlist(c(paste0("o ", found[[1L]], "-", found[[length(found)]],
                           " are from"),
                          paste0("   ",
                            jssp.bibliography$ref.as.text[jssp.bibliography$ref.id == ref]))));
                  }))),
          "",
          "",
          "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++",
          "",
          "Each instance consists of a line of description, a line containing the",
          "number of jobs and the number of machines, and then one line for each job,",
          "listing the machine number and processing time for each step of the job.",
          "The machines are numbered starting with 0.",
          "",
          "",
          unname(unlist(lapply(jssp.instance.data,
                 function(inst) {
                   inst.data <- inst$inst.data;
                   stopifnot(nrow(inst.data) == inst$inst.jobs,
                             ncol(inst.data) == (2L*inst$inst.machines));
                   inst.data <- lapply(seq_len(nrow(inst.data)),
                                       function(v) as.character(inst.data[v, ]));
                   col.width <- vapply(seq_len(2L*inst$inst.machines),
                                       function(i) max(vapply(seq_len(inst$inst.jobs),
                                                              function(j) nchar(inst.data[[j]][[i]]),
                                                              NA_integer_)),
                                       NA_integer_);
                   inst.data <- vapply(inst.data,
                                       function(row) {
                                         row <- vapply(seq_along(row),
                                                       function(i) {
                                                         val <- row[[i]];
                                                         while(nchar(val) < col.width[[i]]) {
                                                           val <- paste0(" ", val);
                                                         }
                                                         return(val);
                                                       },
                                                       NA_character_);
                                         row <- paste0(" ",
                                                       paste(row, sep=" ", collapse=" "));
                                         return(row);
                                       }, NA_character_);

                  unname(unlist(c(
                    " +++++++++++++++++++++++++++++",
                    "",
                    paste0(" instance ", inst$inst.id),
                    "",
                    " +++++++++++++++++++++++++++++",
                    paste0(" ", inst$inst.notes),
                    paste0(" ", inst$inst.jobs, " ", inst$inst.machines),
                    inst.data
                  )))
                 }))),
                 "",
                 "+++++++++++++++++++ EOF ++++++++++++++++++++++++++++++++++++"
          )));

inst.data.file <- file.path(inst.data.path, "instance_data.txt");
inst.data.file <- normalizePath(inst.data.file, mustWork = FALSE);

writeLines(text, inst.data.file);

stopifnot(file.exists(inst.data.file),
          file.size(inst.data.file) >= (sum(vapply(text, nchar, NA_integer_)) + length(text)));

rm("text");
rm("inst.data.file");
rm("inst.data.path");
