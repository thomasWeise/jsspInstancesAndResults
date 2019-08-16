logger("beginning to try to load bibliography.");

library(literatureAndResultsGen);

bib.path <- file.path(dir.data.raw, "bibliography", "bibliography.bib");
bib.path <- normalizePath(bib.path, mustWork = TRUE);
stopifnot(file.exists(bib.path),
          file.size(bib.path) > 0L);

logger("now loading bibliography from file '", bib.path, "'.");
jssp.bibliography <- read.bibliography(bib.path);
stopifnot(is.data.frame(jssp.bibliography),
          nrow(jssp.bibliography) > 0L,
          identical(colnames(jssp.bibliography),
                  c("ref.id", "ref.type", "ref.year",
                    "ref.as.bibtex", "ref.as.text")));
logger("finished loading bibliography from file '", bib.path, "', found ", nrow(jssp.bibliography), " entries.");

rm("bib.path");
