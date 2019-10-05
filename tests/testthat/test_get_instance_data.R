library("jsspInstancesAndResults");
library("testthat");
context("jssp.get.instance.data");

data("jssp.instance.data");

test_that("Test the jssp.get.instance.data method ft06", {
  data <- jssp.get.instance.data("ft06");
  expect_identical(data$inst.id, "ft06");
  expect_identical(data$inst.opt.bound.lower, 55L);
  expect_identical(data$inst.bks, 55L);
  expect_identical(data$inst.machines, 6L);
  expect_identical(data$inst.jobs, 6L);
  expect_identical(data$inst.data,
      matrix(c(2L, 1L, 2L, 1L, 2L, 1L, 1L, 8L, 5L, 5L, 9L, 3L, 0L,
               2L, 3L, 0L, 1L, 3L, 3L, 5L, 4L, 5L, 3L, 3L, 1L, 4L, 5L, 2L, 4L,
               5L, 6L, 10L, 8L, 5L, 5L, 9L, 3L, 5L, 0L, 3L, 5L, 0L, 7L, 10L,
               9L, 3L, 4L, 10L, 5L, 0L, 1L, 4L, 0L, 4L, 3L, 10L, 1L, 8L, 3L,
               4L, 4L, 3L, 4L, 5L, 3L, 2L, 6L, 4L, 7L, 9L, 1L, 1L),
             nrow=6L, ncol=12L, byrow = FALSE));
})
