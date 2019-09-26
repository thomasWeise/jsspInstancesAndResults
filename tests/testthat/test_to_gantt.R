library("jsspInstancesAndResults");
library("testthat");
context("jssp.to.gantt");

data("jssp.instance.data");

test_that("Test the to-Gantt methods ft06", {
  inst.id <- "ft06";
  opt.f <- 55L;

  data.oo <- c(1L,3L,2L,9L,4L,8L,6L,10L,15L,12L,5L,14L,11L,21L,16L,18L,7L,22L,17L,13L,27L,28L,20L,24L,23L,19L,33L,25L,30L,26L,36L,29L,32L,35L,31L,34L);
  expect_identical(jssp.evaluate.gantt(
    jssp.oo.to.gantt(data.oo, inst.id),
    inst.id), opt.f);

  data.solution.start <- c(27L,30L,0L,36L,49L,43L,40L,0L,8L,50L,13L,28L,18L,36L,1L,6L,38L,10L,13L,8L,22L,27L,30L,46L,50L,22L,13L,54L,25L,38L,30L,13L,49L,16L,45L,19L);
  expect_identical(jssp.evaluate.gantt(
    jssp.solution.start.to.gantt(data.solution.start, inst.id),
    inst.id), opt.f);

})


test_that("Test the to-Gantt methods orb07", {
  inst.id <- "orb07";
  opt.f <- 397L;

  data.oo <- c(2L,8L,10L,12L,7L,20L,18L,1L,6L,11L,17L,9L,28L,5L,30L,19L,21L,38L,22L,3L,40L,15L,48L,13L,31L,27L,37L,16L,58L,41L,50L,32L,25L,23L,47L,4L,68L,60L,29L,39L,51L,26L,42L,35L,33L,49L,57L,70L,36L,45L,61L,14L,55L,67L,78L,43L,71L,88L,53L,52L,80L,77L,59L,63L,24L,81L,46L,87L,90L,100L,73L,62L,65L,56L,34L,98L,44L,75L,69L,66L,79L,54L,72L,83L,89L,82L,76L,64L,91L,74L,93L,99L,86L,92L,84L,85L,97L,96L,95L,94L);
  expect_identical(jssp.evaluate.gantt(
    jssp.oo.to.gantt(data.oo, inst.id),
    inst.id), opt.f);

  data.solution.start <- c(8L,40L,61L,77L,114L,132L,184L,203L,230L,312L,0L,337L,320L,8L,40L,301L,224L,251L,110L,134L,67L,239L,145L,114L,224L,252L,203L,92L,287L,343L,132L,196L,301L,214L,318L,287L,356L,341L,258L,374L,40L,100L,202L,166L,374L,187L,71L,276L,330L,251L,117L,369L,217L,263L,23L,337L,133L,312L,184L,279L,92L,145L,132L,23L,8L,367L,251L,230L,201L,117L,222L,266L,110L,62L,0L,202L,8L,132L,93L,37L,336L,305L,20L,279L,171L,320L,61L,166L,134L,192L,266L,252L,0L,141L,239L,27L,100L,171L,71L,20L);
  expect_identical(jssp.evaluate.gantt(
    jssp.solution.start.to.gantt(data.solution.start, inst.id),
    inst.id), opt.f);
})

