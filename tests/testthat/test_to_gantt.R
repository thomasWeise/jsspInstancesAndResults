library("jsspInstancesAndResults");
library("testthat");
context("jssp.to.gantt");

data("jssp.instance.data");

test_that("Test the to-Gantt methods ft06", {
  inst.id <- "ft06";
  opt.f <- 55L;

  data.oo <- c(1L,3L,2L,9L,4L,8L,6L,10L,15L,12L,5L,14L,11L,21L,16L,18L,7L,22L,17L,13L,27L,28L,20L,24L,23L,19L,33L,25L,30L,26L,36L,29L,32L,35L,31L,34L);
  g1 <- jssp.oo.to.gantt(data.oo, inst.id);
  expect_identical(g1$makespan, opt.f);

  data.solution.start <- c(27L,30L,0L,36L,49L,43L,40L,0L,8L,50L,13L,28L,18L,36L,1L,6L,38L,10L,13L,8L,22L,27L,30L,46L,50L,22L,13L,54L,25L,38L,30L,13L,49L,16L,45L,19L);
  g2 <- jssp.solution.start.to.gantt(data.solution.start, inst.id);
  expect_identical(g1, g2);


  data.pl<- c(4L,3L,1L,6L,2L,5L,2L,4L,6L,5L,1L,3L,1L,3L,2L,5L,4L,6L,3L,6L,4L,1L,2L,5L,2L,5L,4L,3L,6L,1L,3L,6L,2L,5L,1L,4L);
  g3 <- jssp.pl.to.gantt(data.pl, inst.id);
  expect_identical(g1, g3);
  expect_identical(g2, g3);
})


test_that("Test the to-Gantt methods orb07", {
  inst.id <- "orb07";
  opt.f <- 397L;

  data.oo <- c(2L,8L,10L,12L,7L,20L,18L,1L,6L,11L,17L,9L,28L,5L,30L,19L,21L,38L,22L,3L,40L,15L,48L,13L,31L,27L,37L,16L,58L,41L,50L,32L,25L,23L,47L,4L,68L,60L,29L,39L,51L,26L,42L,35L,33L,49L,57L,70L,36L,45L,61L,14L,55L,67L,78L,43L,71L,53L,52L,80L,59L,63L,24L,81L,46L,90L,62L,100L,73L,65L,88L,56L,72L,77L,34L,87L,44L,98L,69L,66L,75L,79L,54L,83L,89L,82L,76L,64L,91L,74L,99L,93L,92L,86L,84L,85L,96L,95L,97L,94L);
  g1 <- jssp.oo.to.gantt(data.oo, inst.id);
  expect_identical(g1$makespan, opt.f);

  data.solution.start <- c(8L,40L,61L,77L,114L,132L,184L,203L,230L,312L,0L,335L,318L,8L,40L,268L,224L,243L,110L,134L,67L,239L,145L,114L,224L,252L,203L,92L,287L,343L,132L,196L,301L,214L,318L,287L,356L,341L,258L,374L,40L,100L,202L,166L,374L,187L,71L,287L,330L,251L,117L,368L,217L,263L,23L,338L,133L,313L,184L,279L,92L,145L,132L,23L,8L,368L,287L,266L,201L,117L,266L,277L,110L,62L,0L,202L,8L,132L,93L,37L,331L,305L,20L,279L,171L,315L,61L,166L,134L,192L,266L,252L,0L,141L,239L,27L,100L,171L,71L,20L);
  g2 <- jssp.solution.start.to.gantt(data.solution.start, inst.id);
  expect_identical(g1, g2);

  data.pl <- c(2L,1L,5L,3L,7L,6L,4L,10L,8L,9L,1L,5L,7L,4L,3L,10L,8L,9L,2L,6L,10L,9L,1L,8L,7L,3L,5L,6L,4L,2L,2L,7L,8L,1L,3L,10L,5L,4L,6L,9L,8L,7L,6L,2L,1L,9L,3L,10L,4L,5L,10L,1L,5L,8L,3L,2L,4L,9L,6L,7L,8L,9L,5L,10L,6L,1L,3L,2L,7L,4L,3L,8L,9L,10L,1L,2L,7L,5L,6L,4L,10L,8L,2L,9L,6L,7L,1L,4L,3L,5L,10L,8L,7L,2L,9L,5L,6L,1L,3L,4L);
  g3 <- jssp.pl.to.gantt(data.pl, inst.id);
  expect_identical(g1, g3);
  expect_identical(g2, g3);
})


test_that("Test the to-Gantt methods dmu05", {
  data.pl <- c(9L, 15L, 8L, 12L, 10L, 14L, 16L, 4L, 1L, 19L, 2L, 7L, 18L, 0L, 5L, 11L, 3L, 13L, 17L, 6L, 19L, 15L, 4L, 8L, 1L, 11L, 7L, 10L, 13L, 9L, 2L, 12L, 14L, 5L, 0L, 17L, 18L, 3L, 16L, 6L, 2L, 14L, 17L, 13L, 10L, 4L, 6L, 8L, 12L, 3L, 11L, 5L, 9L, 0L, 16L, 18L, 15L, 1L, 19L, 7L, 14L, 2L, 9L, 10L, 1L, 8L, 12L, 5L, 16L, 4L, 15L, 0L, 3L, 6L, 18L, 13L, 11L, 7L, 19L, 17L, 9L, 14L, 19L, 11L, 5L, 2L, 7L, 4L, 1L, 15L, 8L, 6L, 0L, 3L, 18L, 12L, 13L, 17L, 16L, 10L, 5L, 18L, 2L, 16L, 1L, 10L, 6L, 14L, 4L, 15L, 3L, 8L, 13L, 17L, 19L, 12L, 0L, 9L, 7L, 11L, 10L, 2L, 4L, 19L, 7L, 0L, 15L, 14L, 5L, 1L, 12L, 13L, 3L, 8L, 9L, 18L, 6L, 16L, 17L, 11L, 6L, 17L, 12L, 19L, 9L, 13L, 15L, 5L, 1L, 0L, 7L, 14L, 16L, 4L, 10L, 3L, 11L, 2L, 8L, 18L, 5L, 0L, 18L, 14L, 7L, 9L, 19L, 6L, 2L, 12L, 8L, 11L, 3L, 13L, 16L, 10L, 1L, 15L, 17L, 4L, 8L, 17L, 2L, 11L, 9L, 5L, 15L, 19L, 14L, 13L, 7L, 0L, 1L, 18L, 16L, 4L, 12L, 10L, 6L, 3L, 4L, 18L, 7L, 16L, 12L, 2L, 3L, 13L, 6L, 0L, 19L, 14L, 11L, 17L, 9L, 8L, 5L, 10L, 1L, 15L, 15L, 16L, 3L, 8L, 12L, 5L, 4L, 7L, 2L, 14L, 1L, 11L, 10L, 18L, 0L, 6L, 13L, 17L, 9L, 19L, 15L, 9L, 16L, 8L, 2L, 4L, 14L, 10L, 12L, 13L, 6L, 18L, 3L, 7L, 17L, 11L, 1L, 19L, 0L, 5L, 19L, 16L, 5L, 11L, 14L, 7L, 13L, 0L, 8L, 3L, 9L, 12L, 18L, 15L, 4L, 10L, 2L, 17L, 1L, 6L, 18L, 8L, 19L, 10L, 5L, 12L, 2L, 0L, 6L, 13L, 14L, 15L, 16L, 4L, 7L, 9L, 3L, 17L, 11L, 1L);
  inst.id <- "dmu05";
  opt.f <- 2749L;

  g1 <- jssp.pl.to.gantt(data.pl, inst.id);
  expect_identical(g1$makespan, opt.f);
})
