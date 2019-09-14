logger("beginning to construct README.md.");

readme.dir <- file.path(dir.data.raw, "readme");
readme.dir <- normalizePath(readme.dir, mustWork = TRUE);
stopifnot(dir.exists(readme.dir));

readme.prefix <- file.path(readme.dir, "README.md_prefix");
readme.prefix <- normalizePath(readme.prefix, mustWork = TRUE);
stopifnot(file.exists(readme.prefix));

readme.prefix <- trimws(readLines(con=readme.prefix), which="right");
stopifnot(is.character(readme.prefix),
          length(readme.prefix) > 0L);

readme.suffix <- file.path(readme.dir, "README.md_suffix");
readme.suffix <- normalizePath(readme.suffix, mustWork = TRUE);
stopifnot(file.exists(readme.suffix));

readme.suffix <- trimws(readLines(con=readme.suffix), which="right");
stopifnot(is.character(readme.suffix),
          length(readme.suffix) > 0L);

rm("readme.dir");

stopifnot(exists("jssp.bibliography"),
          is.data.frame(jssp.bibliography));

library(literatureAndResultsGen);

# make short ref keys
ref.keys <- as.character(unname(unlist(jssp.bibliography$ref.id)));
ref.years <- as.integer(unname(unlist(jssp.bibliography$ref.year)));
stopifnot(is.character(ref.keys),
          all(!is.na(ref.keys)),
          all(nchar(ref.keys > 0L)),
          is.integer(ref.years),
          all(is.finite(ref.years)),
          all(ref.years > 0L));
n.start <- as.integer(unname(unlist(regexpr("[0-9]", ref.keys))));
stopifnot(all(is.integer(n.start)),
          all(is.finite(n.start)));
n.start[n.start <= 0L] <- 1L;
n.start[n.start > 1L] <- (n.start[n.start > 1L] - 1L);
n.start <- vapply(n.start, function(m) min(m, 3L), NA_integer_);
stopifnot(all(is.integer(n.start)),
          all(is.finite(n.start)),
          all(n.start > 0L),
          all(n.start <= nchar(ref.keys)));
ref.usekeys <- substr(ref.keys, 1L, n.start);
stopifnot(all(is.character(ref.usekeys)),
          all(!is.na(ref.usekeys)));
for(i in seq_along(ref.usekeys)) {
  while(TRUE) {
    same <- which(ref.usekeys == ref.usekeys[[i]]);
    stopifnot(is.integer(same),
              all(is.finite(same)),
              all(same >= 1L),
              length(same) >= 1L);
    if(length(same) > 1L) {
      stopifnot(all(n.start[same]==(n.start[same][[1L]])));
      same.years <- ref.years[same];
      min.year <- min(same.years);
      min.year <- which(same.years <= min.year);
      same <- same[-(min.year[[1L]])];
      rm("same.years");
      rm("min.year");
      n.start[same] <- (n.start[same] + 1L);
      stopifnot(all(n.start[same]==(n.start[same][[1L]])));
      n.start <- force(n.start);
      n.start <- do.call(force, list(n.start));
      ref.usekeys[same] <- substr(ref.keys[same], 1L, n.start[same]);
      ref.usekeys <- force(ref.usekeys);
      ref.usekeys <- do.call(force, list(ref.usekeys));
    } else {
      break;
    }
  }
}
rm("same");
rm("n.start");
rm("ref.years")

stopifnot(length(ref.usekeys) == length(ref.keys),
          length(unique(ref.usekeys)) == length(ref.usekeys),
          all(unique(ref.usekeys) == ref.usekeys),
          all(vapply(seq_along(ref.keys), function(i) startsWith(ref.keys[[i]], ref.usekeys[[i]]), FALSE)),
          all(nchar(ref.usekeys) > 0),
          all(!is.na(ref.usekeys)));

.key <- function(ref) {
  i <- ref.keys == ref;
  stopifnot(sum(i) == 1L);
  i <- which(i);
  stopifnot(is.finite(i),
            length(i) == 1L);
  i <- ref.usekeys[[i]];
  stopifnot(startsWith(ref, i),
            nchar(i) > 0L);
  return(i);
}

# make a references list
use.bib <-  jssp.bibliography[order(ref.usekeys), ];
use.bib <- force(use.bib);
use.bib <- do.call(force, list(use.bib));
stopifnot(all(vapply(seq_len(nrow(use.bib)), function(i) startsWith(use.bib$ref.id[[i]], ref.usekeys[[i]]), FALSE)));
references <- make.references.text(refs=NULL,
                                   bibliography = use.bib,
                                   subst.doi = "doi:<a href=\\\"\\2\\\">\\1</a>",
                                   subst.url = "<a href=\\\"\\1\\\">\\1</a>",
                                   first.line.as.separate.line = FALSE,
                                   logger = logger,
                                   first.line.start=NULL,
                                   first.line.end="</dd>",
                                   make.text.before=function(ref) {
                                     stopifnot(is.character(ref),
                                               nchar(ref) > 0L,
                                               length(ref) == 1L,
                                               !is.na(ref));
                                     ref <- .key(ref);
                                     stopifnot(is.character(ref),
                                               nchar(ref) > 0L,
                                               length(ref) == 1L,
                                               !is.na(ref));
                                     return(paste0("<dt name=\"", ref, "\" id=\"", ref, "\">",
                                                   ref, "</dt><dd>"));
                                   },
                                   make.text.after=NULL,
                                   normal.line.start=NULL,
                                   normal.line.end="</li>",
                                   between.two.lines=NULL,
                                   after.first.line=NULL,
                                   sort=FALSE);
rm("use.bib");
stopifnot(is.character(references),
          length(references) > 0L);
references <- unname(unlist(c(paste0("## Literature Sources"),
                              "",
                              "The data has been taken from the following literature sources.",
                              "We used <http://jobshop.jjvh.nl> as starting point for the search, but included additional papers.",
                              "You can find the full BibTeX entries for the below references in our [bibliography](https://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/bibliography/bibliography.bib).",
                              "The bibliography keys there will start with the same mnemonic used here, but here we shortened these keys for the sake of brevity.",
                              "",
                              "<dl>",
                              references,
                              "</dl>")));

ref.fun <- function(ref.id) {
  ref.ids <- trimws(unname(unlist(strsplit(unname(unlist(ref.id)), ";", fixed=TRUE))));
  ref.links <- vapply(ref.ids,
                      function(ref) {
                        stopifnot(is.character(ref),
                                  nchar(ref) > 0L,
                                  length(ref) == 1L,
                                  !is.na(ref));
                        ref <- .key(ref);
                        stopifnot(is.character(ref),
                                  nchar(ref) > 0L,
                                  length(ref) == 1L,
                                  !is.na(ref));
                        return(paste0("<a href=\"#", ref, "\">", ref, "</a>"));
                      }, NA_character_);
  return(paste(ref.links, sep=", ", collapse=", "));
}

table <- vapply(seq_len(nrow(jssp.instances)),
                function(i) {
                  row <- jssp.instances[i,];

                  if(row$inst.opt.bound.lower < row$inst.bks) {
                    fix <- "**";
                  } else {
                    fix <- "";
                  }

                  return(paste0("|", fix, row$inst.id, fix, "|",
                                ref.fun(row$inst.ref), "|",
                                row$inst.jobs, "|",
                                row$inst.machines, "|",
                                fix,  row$inst.opt.bound.lower, fix, "|",
                                ref.fun(row$inst.opt.bound.lower.ref),
                                "|",
                                fix, row$inst.bks, fix,
                                "|",
                                ref.fun(row$inst.bks.ref),
                                "|"));
                }, NA_character_);

rm("ref.fun");
rm(".key");
rm("ref.usekeys");

stopifnot(is.character(table),
          all(!is.na(table)),
          all(nchar(table) > 0L));

table <- unname(unlist(c(
  paste0("## Instance Information and Statistics"),
  "",
  "Computer-processable information about the JSSP instances can be found [here as CSV](https://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/instances/instances_with_bks.txt) and in the data frame `jssp.instances` in the `R` package.",
  "",
  "The rows have the following meaning:",
  "",
  "- `id` the unique identifier of the instance, as used in the literature (unsolved instances are marked in **bold**)",
  "- `ref` the reference to the publication where the instance was first mentioned/created",
  "- `jobs` the number of jobs in the instance",
  "- `machines` the number of machines in the instance",
  "- `lb` the lower bound for the makespan of any solution for the instance",
  "- `lb ref` the reference to the earliest publication (in this survey) that mentioned this lower bound",
  "- `bks` the makespan of the best-known solution (in terms of the makespan), based on this survey",
  "- `bks ref` the reference to the earliest publication(s) in this survey that mentioned the bks",
  "",
  "|id|ref|jobs|machines|lb|lb ref|bks|bks ref|",
  "|--:|-:-|--:|--:|--:|-:-|--:|-:-|",
  table)));

logger("got all readme components, now merging text.");
text <- unname(unlist(c(readme.prefix, table, references, readme.suffix)));
stopifnot(is.character(text),
          all(!is.na(text)));
rm("readme.prefix");
rm("table");
rm("references");
rm("readme.suffix");

logger("got merged text, now numbering sections and making table of contents.");
text <- make.readme.toc(text);
stopifnot(is.character(text),
          all(!is.na(text)));

readme.dest <- file.path(dir.data.raw, "..", "README.md");
readme.dest <- normalizePath(readme.dest, mustWork = FALSE);

writeLines(text=text, con=readme.dest);
stopifnot(file.exists(readme.dest),
          file.size(readme.dest) >= (length(text) + sum(nchar(text))));
rm("text");
rm("readme.dest");

logger("finished making README.md");