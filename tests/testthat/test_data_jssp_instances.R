library("jsspInstancesAndResults");
library("testthat");
context("jssp.instances");


data("jssp.instances");
data("jssp.bibliography");

.check.bib <- function(vec, maybe.multiple = FALSE) {
  if(maybe.multiple) {
    vec <- strsplit(vec, ";", fixed=TRUE);
  }
  vec <- unname(unlist(vec));
  for(ref in vec) {
    found <- jssp.bibliography$ref.id == ref;
    expect_identical(sum(found), 1L);
    expect_true(all(!is.na(found)));
    found <- which(found);
    expect_length(found, 1L);
    expect_gt(found, 0L);
    expect_lte(found, nrow(jssp.bibliography));
    expect_identical(jssp.bibliography$ref.id[found], ref);
  }
}

test_that("Test the instances meta-data", {
  expect_true(is.data.frame(jssp.instances));
  expect_gt(nrow(jssp.instances), 0L);
  expect_identical(ncol(jssp.instances), 10L);
  expect_identical(colnames(jssp.instances),
                   c("inst.id",
                     "inst.ref",
                     "inst.jobs",
                     "inst.machines",
                     "inst.opt.bound.lower",
                     "inst.opt.bound.lower.ref",
                     "inst.bks",
                     "inst.bks.ref",
                     "inst.bks.time",
                     "inst.bks.time.ref"));
  expect_type(jssp.instances[, 1L], "character");
  expect_type(jssp.instances[, 2L], "character");
  expect_type(jssp.instances[, 3L], "integer");
  expect_type(jssp.instances[, 4L], "integer");
  expect_type(jssp.instances[, 5L], "integer");
  expect_type(jssp.instances[, 6L], "character");
  expect_type(jssp.instances[, 7L], "integer");
  expect_type(jssp.instances[, 8L], "character");
  expect_type(jssp.instances[, 9L], "integer");
  expect_type(jssp.instances[, 10L], "character");
  expect_true(all(nchar(jssp.instances$inst.id) > 0L));
  expect_length(unique(jssp.instances$inst.id), nrow(jssp.instances));
  expect_true(all(nchar(jssp.instances$inst.ref) > 0L));
  .check.bib(jssp.instances$inst.ref);
  expect_true(all(jssp.instances$inst.machines > 0L));
  expect_true(all(jssp.instances$inst.machines < .Machine$integer.max));
  expect_true(all(is.finite(jssp.instances$inst.machines)));
  expect_true(all(jssp.instances$inst.jobs > 0L));
  expect_true(all(is.finite(jssp.instances$inst.jobs)));
  expect_true(all(jssp.instances$inst.jobs < .Machine$integer.max));
  expect_true(all(jssp.instances$inst.opt.bound.lower > 0L));
  expect_true(all(is.finite(jssp.instances$inst.opt.bound.lower)));
  expect_true(all(jssp.instances$inst.opt.bound.lower < .Machine$integer.max));
  expect_true(all(nchar(jssp.instances$inst.opt.bound.lower.ref) > 0L));
  .check.bib(jssp.instances$inst.opt.bound.lower.ref);
  expect_true(all(jssp.instances$inst.bks > 0L));
  expect_true(all(is.finite(jssp.instances$inst.bks)));
  expect_true(all(jssp.instances$inst.bks < .Machine$integer.max));
  expect_true(all(jssp.instances$inst.opt.bound.lower <= jssp.instances$inst.bks));
  expect_true(all(nchar(jssp.instances$inst.bks.ref) > 0L));
  .check.bib(jssp.instances$inst.bks.ref, TRUE);

  .check.bib(jssp.instances$inst.bks.time.ref[!is.na(jssp.instances$inst.bks.time.ref)]);
  expect_true(all(is.na(jssp.instances$inst.bks.time) | (jssp.instances$inst.bks.time >= 0L)));
  expect_true(all(is.na(jssp.instances$inst.bks.time) == is.na(jssp.instances$inst.bks.time.ref)));
  expect_true(all(is.na(jssp.instances$inst.bks.time.ref) | (nchar(jssp.instances$inst.bks.time.ref) > 0L)));
})
