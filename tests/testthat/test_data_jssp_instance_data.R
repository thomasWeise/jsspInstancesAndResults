library("jsspInstancesAndResults");
library("testthat");
context("jssp.instance.data");

data("jssp.instances");
data("jssp.instance.data");

.check.bib <- function(vec) {
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

test_that("Test the instance data", {
  expect_true(is.list(jssp.instance.data));
  expect_length(jssp.instance.data, nrow(jssp.instances));
  expect_identical(names(jssp.instance.data), jssp.instances$inst.id);

  for(i in seq_along(jssp.instance.data)) {
    data <- jssp.instance.data[[i]];
    inst <- jssp.instances[i,];
    expect_identical(data$inst.id, inst$inst.id);
    expect_identical(data$inst.jobs, inst$inst.jobs);
    expect_identical(data$inst.machines, inst$inst.machines);
    expect_identical(data$inst.opt.bound.lower, inst$inst.opt.bound.lower);
    expect_identical(data$inst.bks, inst$inst.bks);
    expect_identical(nrow(data$inst.data), inst$inst.jobs);
    expect_identical(ncol(data$inst.data), 2L*inst$inst.machines);
    expect_type(data$inst.id, "character");
    expect_type(data$inst.notes, "character");
    expect_gt(nchar(data$inst.notes), 0L);
    expect_true(!is.na(data$inst.notes));
    expect_type(data$inst.machines, "integer");
    expect_type(data$inst.jobs, "integer");
    expect_type(data$inst.opt.bound.lower, "integer");
    expect_type(data$inst.bks, "integer");
    expect_type(data$inst.data, "integer");

    machines <- lapply(seq_len(inst$inst.jobs), function(i)
      unname(unlist(data$inst.data[i, (1L+(2L*seq.int(from=0L, to=(inst$inst.machines-1L))))])));
    expect_true(all(vapply(machines, function(m) identical(unique(m), m), FALSE)));
    expect_true(all(vapply(machines, function(m) all((m >= 0L) & (m < inst$inst.machines)), FALSE)));
    expect_true(all(!is.na(unlist(machines))));
    expect_true(all(is.finite(unlist(machines))));
    times <- lapply(seq_len(inst$inst.jobs), function(i)
      unname(unlist(data$inst.data[i, (2L*seq.int(from=1L, to=inst$inst.machines))])));
    expect_true(all(unlist(times) >= 0L));
    expect_true(all(is.finite(unlist(times))));
    expect_true(all(!is.na(unlist(times))));
  }
})
