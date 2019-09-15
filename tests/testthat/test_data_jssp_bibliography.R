library("jsspInstancesAndResults");
library("testthat");
context("jssp.bibliography");

data("jssp.bibliography");

test_that("Test the bibliography", {
  expect_true(is.data.frame(jssp.bibliography));
  expect_gt(nrow(jssp.bibliography), 0L);
  expect_identical(ncol(jssp.bibliography), 5L);
  expect_identical(colnames(jssp.bibliography), c("ref.id", "ref.type", "ref.year", "ref.as.bibtex", "ref.as.text"));
  expect_type(jssp.bibliography[, 1L], "character");
  expect_type(jssp.bibliography[, 2L], "integer");
  expect_type(jssp.bibliography[, 3L], "integer");
  expect_type(jssp.bibliography[, 4L], "character");
  expect_type(jssp.bibliography[, 5L], "character");
  expect_true(is.factor(jssp.bibliography[, 2L]));
  expect_true(all(nchar(jssp.bibliography[, 1L]) > 0L));
  expect_true(all(jssp.bibliography[, 3L] > 1900L));
  expect_true(all(jssp.bibliography[, 3L] < 3000L));
  expect_true(all(nchar(jssp.bibliography[, 4L]) > 0L));
  expect_true(all(nchar(jssp.bibliography[, 5L]) > 0L));
  expect_false(any(is.na(jssp.bibliography[, 1L])));
  expect_false(any(is.na(jssp.bibliography[, 2L])));
  expect_false(any(is.na(jssp.bibliography[, 3L])));
  expect_false(any(is.na(jssp.bibliography[, 4L])));
  expect_false(any(is.na(jssp.bibliography[, 5L])));
  expect_identical(length(unique(unname(unlist(jssp.bibliography[, 1L])))), nrow(jssp.bibliography));
})

