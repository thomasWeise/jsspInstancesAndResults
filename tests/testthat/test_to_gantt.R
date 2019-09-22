library("jsspInstancesAndResults");
library("testthat");
context("jssp.to.gantt");

data("jssp.instance.data");

test_that("Test the to-Gantt methods", {
  data.oo.vH <- c(1L,3L,2L,9L,4L,8L,6L,10L,15L,12L,5L,14L,11L,21L,16L,18L,7L,22L,17L,13L,27L,28L,20L,24L,23L,19L,33L,25L,30L,26L,36L,29L,32L,35L,31L,34L);
  inst.id <- "ft06";

  expect_identical(jssp.evaluate.gantt(
    jssp.oo.vH.to.gantt(data.oo.vH, inst.id),
    inst.id), 55L);
})

