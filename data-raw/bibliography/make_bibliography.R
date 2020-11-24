logger("beginning to try to load bibliography.");

if(!require("literatureAndResultsGen")) {
  if(!require("devtools")) {
    install.packages("devtools");
  }
  library("devtools");
  devtools::install_github("thomasWeise/literatureAndResultsGen");
}
library("literatureAndResultsGen");

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

bib.raw <- readLines(con=bib.path);

bib.path.relative <- substr(bib.path,
                            start=(nchar(dirname(dir.data.raw)) + 2L),
                            stop=nchar(bib.path));
stopifnot(is.character(bib.path.relative),
          length(bib.path.relative) == 1L,
          !is.na(bib.path.relative),
          nchar(bib.path.relative) > 10L);

rm("bib.path");

bib.lines <- unname(unlist(vapply(unname(unlist(jssp.bibliography$ref.id)),
                    function(ref.id) {
                      stopifnot(is.character(ref.id),
                                nchar(ref.id) > 0L);
                      line <- grep(paste0("^\\@[a-zA-Z]+\\{", ref.id, "\\,"),
                                   bib.raw, fixed = FALSE);
                      stopifnot(is.integer(line),
                                length(line) == 1L,
                                is.finite(line),
                                line > 0L,
                                line < length(bib.raw));
                      return(line);
                    }, NA_integer_)));
stopifnot(all(!is.na(bib.lines)),
          is.integer(bib.lines),
          length(bib.lines) == nrow(jssp.bibliography),
          all(is.finite(bib.lines)),
          all(bib.lines > 0L),
          all(bib.lines < length(bib.raw)));

rm("bib.raw");
