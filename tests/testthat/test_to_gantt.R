library("jsspInstancesAndResults");
library("testthat");
context("jssp.to.gantt");

data("jssp.instance.data");

test_that("Test the to-Gantt methods", {
  data.oo <- c(1L,3L,2L,9L,4L,8L,6L,10L,15L,12L,5L,14L,11L,21L,16L,18L,7L,22L,17L,13L,27L,28L,20L,24L,23L,19L,33L,25L,30L,26L,36L,29L,32L,35L,31L,34L);
  inst.id <- "ft06";

  expect_identical(jssp.evaluate.gantt(
    jssp.oo.to.gantt(data.oo, inst.id),
    inst.id), 55L);

  data.solution.start <- c(27L,30L,0L,36L,49L,43L,40L,0L,8L,50L,13L,28L,18L,36L,1L,6L,38L,10L,13L,8L,22L,27L,30L,46L,50L,22L,13L,54L,25L,38L,30L,13L,49L,16L,45L,19L);
  expect_identical(jssp.evaluate.gantt(
    jssp.solution.start.to.gantt(data.solution.start, inst.id),
    inst.id), 55L);

})

