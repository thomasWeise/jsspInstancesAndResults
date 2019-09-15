library("jsspInstancesAndResults");
library("testthat");
context("jssp.results");

data("jssp.results");
data("jssp.instances");
data("jssp.bibliography");


# an abridged version of the automatically generated validator function
# some columns have been cut because we currently don't have data in them
.result.data.frame.validate <- function(x, instances) {
  old.options <- options(warn=2);
  stopifnot(is.data.frame(x),
            nrow(x) > 0L,
            ncol(x) > 0L,
            is.data.frame(instances),
            nrow(instances) > 0L,
            ncol(instances) > 0L);
stopifnot(all(!is.na(x$algo.id)),
          is.character(x$algo.id),
          all(nchar(x$algo.id) > 0L),
          all(!is.na(x$algo.desc)),
          is.character(x$algo.desc),
          all(nchar(x$algo.desc) > 0L),
          all(!is.na(x$inst.id)),
          is.character(x$inst.id),
          all(nchar(x$inst.id) > 0L),
          all(!is.na(x$ref.id)),
          is.character(x$ref.id),
          all(nchar(x$ref.id) > 0L),
          all(!is.na(x$inst.opt.bound.lower)),
          all(is.finite(x$inst.opt.bound.lower)),
          all(is.character(x$system.cpu.name)),
          all(is.na(x$system.cpu.name) | (nchar(x$system.cpu.name) > 0L)),
          all(is.integer(x$system.cpu.n)),
          all(is.na(x$system.cpu.n) | (is.finite(x$system.cpu.n) & (x$system.cpu.n > 0L))),
          all(is.integer(x$system.cpu.cores)),
          all(is.na(x$system.cpu.cores) | (is.finite(x$system.cpu.cores) & (x$system.cpu.cores > 0L))),
          all(is.integer(x$system.cpu.threads)),
          all(is.na(x$system.cpu.threads) | (is.finite(x$system.cpu.threads) & (x$system.cpu.threads > 0L))),
          all(is.integer(x$system.cpu.mhz)),
          all(is.na(x$system.cpu.mhz) | (is.finite(x$system.cpu.mhz) & (x$system.cpu.mhz > 0L))),
          all(is.integer(x$system.memory.mb)),
          all(is.na(x$system.memory.mb) | (is.finite(x$system.memory.mb) & (x$system.memory.mb > 0L))),
          all(is.character(x$system.os.name)),
          all(is.na(x$system.os.name) | (nchar(x$system.os.name) > 0L)),
          all(is.character(x$system.vm.name)),
          all(is.na(x$system.vm.name) | (nchar(x$system.vm.name) > 0L)),
          all(is.character(x$system.compiler.name)),
          all(is.na(x$system.compiler.name) | (nchar(x$system.compiler.name) > 0L)),
          all(is.character(x$system.programming.language.name)),
          all(is.na(x$system.programming.language.name) | (nchar(x$system.programming.language.name) > 0L)),
          all(is.character(x$system.external.tools.list)),
          all(is.na(x$system.external.tools.list) | (nchar(x$system.external.tools.list) > 0L)),
          all(is.logical(x$system.runs.are.parallel)),
          all(is.character(x$notes)),
          all(is.na(x$notes) | (nchar(x$notes) > 0L)),
          all(is.character(x$algo.representation)),
          all(is.na(x$algo.representation) | (nchar(x$algo.representation) > 0L)),
          all(is.character(x$algo.operator.unary)),
          all(is.na(x$algo.operator.unary) | (nchar(x$algo.operator.unary) > 0L)),
          all(is.character(x$algo.operator.binary)),
          all(is.na(x$algo.operator.binary) | (nchar(x$algo.operator.binary) > 0L)),
          all(is.na(x$n.runs) | is.finite(x$n.runs)),
          is.numeric(x$n.runs),
          is.integer(x$n.runs),
          all(is.na(x$n.runs) | (x$n.runs >= 0L)),
          all(is.na(x$n.runs) | (x$n.runs <= 10000000L)),
          all(is.na(x$best.f.min) | is.finite(x$best.f.min)),
          is.numeric(x$best.f.min),
          is.integer(x$best.f.min),
          all(is.na(x$best.f.min) | (x$best.f.min >= 0L)),
          all(is.na(x$best.f.min) | (x$best.f.min <= 2147483646L)),
          all(is.na(x$best.f.mean) | is.finite(x$best.f.mean)),
          is.numeric(x$best.f.mean),
          all(is.na(x$best.f.mean) | (x$best.f.mean >= 0)),
          all(is.na(x$best.f.mean) | (x$best.f.mean <= 2147483646)),
          all(is.na(x$best.f.med) | is.finite(x$best.f.med)),
          is.numeric(x$best.f.med),
          all(is.na(x$best.f.med) | (x$best.f.med >= 0)),
          all(is.na(x$best.f.med) | (x$best.f.med <= 2147483646)),
          all(is.na(x$best.f.mode) | is.finite(x$best.f.mode)),
          is.numeric(x$best.f.mode),
          all(is.na(x$best.f.mode) | (x$best.f.mode >= 0)),
          all(is.na(x$best.f.mode) | (x$best.f.mode <= 2147483646)),
          all(is.na(x$best.f.max) | is.finite(x$best.f.max)),
          is.numeric(x$best.f.max),
          all(is.na(x$best.f.max) | (x$best.f.max >= 0)),
          all(is.na(x$best.f.max) | (x$best.f.max <= 2147483646)),
          all(is.na(x$best.f.sd) | is.finite(x$best.f.sd)),
          is.numeric(x$best.f.sd),
          all(is.na(x$best.f.sd) | (x$best.f.sd >= 0)),
          all(is.na(x$best.f.min) | is.na(x$best.f.max) | (x$best.f.min <= x$best.f.max)),
          all(is.na(x$best.f.min) | is.na(x$best.f.mean) | (x$best.f.min <= x$best.f.mean)),
          all(is.na(x$best.f.min) | is.na(x$best.f.med) | (x$best.f.min <= x$best.f.med)),
          all(is.na(x$best.f.min) | is.na(x$best.f.mode) | (x$best.f.min <= x$best.f.mode)),
          all(is.na(x$best.f.mean) | is.na(x$best.f.max) | (x$best.f.mean <= x$best.f.max)),
          all(is.na(x$best.f.med) | is.na(x$best.f.max) | (x$best.f.med <= x$best.f.max)),
          all(is.na(x$best.f.mode) | is.na(x$best.f.max) | (x$best.f.mode <= x$best.f.max)),
          all(is.na(x$best.f.min) | is.na(x$best.f.max) | is.na(x$best.f.sd) | xor((x$best.f.sd <= 0) , (x$best.f.min < x$best.f.max))),
          all(is.na(x$best.f.min) | is.na(x$best.f.med) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.min >= x$best.f.med)),
          all(is.na(x$best.f.max) | is.na(x$best.f.med) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.max <= x$best.f.med)),
          all(is.na(x$best.f.min) | is.na(x$best.f.mean) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.min >= x$best.f.mean)),
          all(is.na(x$best.f.max) | is.na(x$best.f.mean) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.max <= x$best.f.mean)),
          all(is.na(x$best.f.min) | is.na(x$best.f.mode) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.min >= x$best.f.mode)),
          all(is.na(x$best.f.max) | is.na(x$best.f.mode) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.max <= x$best.f.mode)),
          all(is.na(x$best.f.mean) | is.na(x$best.f.med) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.mean == x$best.f.med)),
          all(is.na(x$best.f.mean) | is.na(x$best.f.mode) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.mean == x$best.f.mode)),
          all(is.na(x$best.f.mode) | is.na(x$best.f.med) | is.na(x$best.f.sd) | (x$best.f.sd > 0) | (x$best.f.mode == x$best.f.med)),
          all(is.na(x$best.f.sd) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.sd <= 0)),
          all(is.na(x$best.f.min) | is.na(x$best.f.max) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.min >= x$best.f.max)),
          all(is.na(x$best.f.min) | is.na(x$best.f.mean) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.min >= x$best.f.mean)),
          all(is.na(x$best.f.min) | is.na(x$best.f.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.min >= x$best.f.med)),
          all(is.na(x$best.f.min) | is.na(x$best.f.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.min >= x$best.f.mode)),
          all(is.na(x$best.f.max) | is.na(x$best.f.mean) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.max <= x$best.f.mean)),
          all(is.na(x$best.f.max) | is.na(x$best.f.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.max <= x$best.f.med)),
          all(is.na(x$best.f.max) | is.na(x$best.f.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.max <= x$best.f.mode)),
          all(is.na(x$best.f.mean) | is.na(x$best.f.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.mean == x$best.f.med)),
          all(is.na(x$best.f.mean) | is.na(x$best.f.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.mean == x$best.f.mode)),
          all(is.na(x$best.f.mode) | is.na(x$best.f.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$best.f.mode == x$best.f.med)),
          all(is.na(x$last.improvement.time.min) | is.finite(x$last.improvement.time.min)),
          is.numeric(x$last.improvement.time.min),
          is.integer(x$last.improvement.time.min),
          all(is.na(x$last.improvement.time.min) | (x$last.improvement.time.min >= 0L)),
          all(is.na(x$last.improvement.time.min) | (x$last.improvement.time.min <= 2147483646L)),
          all(is.na(x$last.improvement.time.mean) | is.finite(x$last.improvement.time.mean)),
          is.numeric(x$last.improvement.time.mean),
          all(is.na(x$last.improvement.time.mean) | (x$last.improvement.time.mean >= 0)),
          all(is.na(x$last.improvement.time.mean) | (x$last.improvement.time.mean <= 2147483646)),
          all(is.na(x$last.improvement.time.med) | is.finite(x$last.improvement.time.med)),
          is.numeric(x$last.improvement.time.med),
          all(is.na(x$last.improvement.time.med) | (x$last.improvement.time.med >= 0)),
          all(is.na(x$last.improvement.time.med) | (x$last.improvement.time.med <= 2147483646)),
          all(is.na(x$last.improvement.time.mode) | is.finite(x$last.improvement.time.mode)),
          is.numeric(x$last.improvement.time.mode),
          all(is.na(x$last.improvement.time.mode) | (x$last.improvement.time.mode >= 0)),
          all(is.na(x$last.improvement.time.mode) | (x$last.improvement.time.mode <= 2147483646)),
          all(is.na(x$last.improvement.time.max) | is.finite(x$last.improvement.time.max)),
          is.numeric(x$last.improvement.time.max),
          all(is.na(x$last.improvement.time.max) | (x$last.improvement.time.max >= 0)),
          all(is.na(x$last.improvement.time.max) | (x$last.improvement.time.max <= 2147483646)),
          all(is.na(x$last.improvement.time.sd) | is.finite(x$last.improvement.time.sd)),
          is.numeric(x$last.improvement.time.sd),
          all(is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd >= 0)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.max) | (x$last.improvement.time.min <= x$last.improvement.time.max)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.mean) | (x$last.improvement.time.min <= x$last.improvement.time.mean)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.med) | (x$last.improvement.time.min <= x$last.improvement.time.med)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.mode) | (x$last.improvement.time.min <= x$last.improvement.time.mode)),
          all(is.na(x$last.improvement.time.mean) | is.na(x$last.improvement.time.max) | (x$last.improvement.time.mean <= x$last.improvement.time.max)),
          all(is.na(x$last.improvement.time.med) | is.na(x$last.improvement.time.max) | (x$last.improvement.time.med <= x$last.improvement.time.max)),
          all(is.na(x$last.improvement.time.mode) | is.na(x$last.improvement.time.max) | (x$last.improvement.time.mode <= x$last.improvement.time.max)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.max) | is.na(x$last.improvement.time.sd) | xor((x$last.improvement.time.sd <= 0) , (x$last.improvement.time.min < x$last.improvement.time.max))),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.med) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.min >= x$last.improvement.time.med)),
          all(is.na(x$last.improvement.time.max) | is.na(x$last.improvement.time.med) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.max <= x$last.improvement.time.med)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.mean) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.min >= x$last.improvement.time.mean)),
          all(is.na(x$last.improvement.time.max) | is.na(x$last.improvement.time.mean) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.max <= x$last.improvement.time.mean)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.mode) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.min >= x$last.improvement.time.mode)),
          all(is.na(x$last.improvement.time.max) | is.na(x$last.improvement.time.mode) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.max <= x$last.improvement.time.mode)),
          all(is.na(x$last.improvement.time.mean) | is.na(x$last.improvement.time.med) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.mean == x$last.improvement.time.med)),
          all(is.na(x$last.improvement.time.mean) | is.na(x$last.improvement.time.mode) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.mean == x$last.improvement.time.mode)),
          all(is.na(x$last.improvement.time.mode) | is.na(x$last.improvement.time.med) | is.na(x$last.improvement.time.sd) | (x$last.improvement.time.sd > 0) | (x$last.improvement.time.mode == x$last.improvement.time.med)),
          all(is.na(x$last.improvement.time.sd) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.sd <= 0)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.max) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.min >= x$last.improvement.time.max)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.mean) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.min >= x$last.improvement.time.mean)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.min >= x$last.improvement.time.med)),
          all(is.na(x$last.improvement.time.min) | is.na(x$last.improvement.time.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.min >= x$last.improvement.time.mode)),
          all(is.na(x$last.improvement.time.max) | is.na(x$last.improvement.time.mean) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.max <= x$last.improvement.time.mean)),
          all(is.na(x$last.improvement.time.max) | is.na(x$last.improvement.time.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.max <= x$last.improvement.time.med)),
          all(is.na(x$last.improvement.time.max) | is.na(x$last.improvement.time.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.max <= x$last.improvement.time.mode)),
          all(is.na(x$last.improvement.time.mean) | is.na(x$last.improvement.time.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.mean == x$last.improvement.time.med)),
          all(is.na(x$last.improvement.time.mean) | is.na(x$last.improvement.time.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.mean == x$last.improvement.time.mode)),
          all(is.na(x$last.improvement.time.mode) | is.na(x$last.improvement.time.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$last.improvement.time.mode == x$last.improvement.time.med)),

          all(is.na(x$total.time.min) | is.finite(x$total.time.min)),
          is.numeric(x$total.time.min),
          is.integer(x$total.time.min),
          all(is.na(x$total.time.min) | (x$total.time.min >= 0L)),
          all(is.na(x$total.time.min) | (x$total.time.min <= 2147483646L)),
          all(is.na(x$total.time.mean) | is.finite(x$total.time.mean)),
          is.numeric(x$total.time.mean),
          all(is.na(x$total.time.mean) | (x$total.time.mean >= 0)),
          all(is.na(x$total.time.mean) | (x$total.time.mean <= 2147483646)),
          all(is.na(x$total.time.med) | is.finite(x$total.time.med)),
          is.numeric(x$total.time.med),
          all(is.na(x$total.time.med) | (x$total.time.med >= 0)),
          all(is.na(x$total.time.med) | (x$total.time.med <= 2147483646)),
          all(is.na(x$total.time.mode) | is.finite(x$total.time.mode)),
          is.numeric(x$total.time.mode),
          all(is.na(x$total.time.mode) | (x$total.time.mode >= 0)),
          all(is.na(x$total.time.mode) | (x$total.time.mode <= 2147483646)),
          all(is.na(x$total.time.max) | is.finite(x$total.time.max)),
          is.numeric(x$total.time.max),
          all(is.na(x$total.time.max) | (x$total.time.max >= 0)),
          all(is.na(x$total.time.max) | (x$total.time.max <= 2147483646)),
          all(is.na(x$total.time.sd) | is.finite(x$total.time.sd)),
          is.numeric(x$total.time.sd),
          all(is.na(x$total.time.sd) | (x$total.time.sd >= 0)),
          all(is.na(x$total.time.min) | is.na(x$total.time.max) | (x$total.time.min <= x$total.time.max)),
          all(is.na(x$total.time.min) | is.na(x$total.time.mean) | (x$total.time.min <= x$total.time.mean)),
          all(is.na(x$total.time.min) | is.na(x$total.time.med) | (x$total.time.min <= x$total.time.med)),
          all(is.na(x$total.time.min) | is.na(x$total.time.mode) | (x$total.time.min <= x$total.time.mode)),
          all(is.na(x$total.time.mean) | is.na(x$total.time.max) | (x$total.time.mean <= x$total.time.max)),
          all(is.na(x$total.time.med) | is.na(x$total.time.max) | (x$total.time.med <= x$total.time.max)),
          all(is.na(x$total.time.mode) | is.na(x$total.time.max) | (x$total.time.mode <= x$total.time.max)),
          all(is.na(x$total.time.min) | is.na(x$total.time.max) | is.na(x$total.time.sd) | xor((x$total.time.sd <= 0) , (x$total.time.min < x$total.time.max))),
          all(is.na(x$total.time.min) | is.na(x$total.time.med) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.min >= x$total.time.med)),
          all(is.na(x$total.time.max) | is.na(x$total.time.med) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.max <= x$total.time.med)),
          all(is.na(x$total.time.min) | is.na(x$total.time.mean) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.min >= x$total.time.mean)),
          all(is.na(x$total.time.max) | is.na(x$total.time.mean) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.max <= x$total.time.mean)),
          all(is.na(x$total.time.min) | is.na(x$total.time.mode) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.min >= x$total.time.mode)),
          all(is.na(x$total.time.max) | is.na(x$total.time.mode) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.max <= x$total.time.mode)),
          all(is.na(x$total.time.mean) | is.na(x$total.time.med) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.mean == x$total.time.med)),
          all(is.na(x$total.time.mean) | is.na(x$total.time.mode) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.mean == x$total.time.mode)),
          all(is.na(x$total.time.mode) | is.na(x$total.time.med) | is.na(x$total.time.sd) | (x$total.time.sd > 0) | (x$total.time.mode == x$total.time.med)),
          all(is.na(x$total.time.sd) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.sd <= 0)),
          all(is.na(x$total.time.min) | is.na(x$total.time.max) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.min >= x$total.time.max)),
          all(is.na(x$total.time.min) | is.na(x$total.time.mean) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.min >= x$total.time.mean)),
          all(is.na(x$total.time.min) | is.na(x$total.time.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.min >= x$total.time.med)),
          all(is.na(x$total.time.min) | is.na(x$total.time.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.min >= x$total.time.mode)),
          all(is.na(x$total.time.max) | is.na(x$total.time.mean) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.max <= x$total.time.mean)),
          all(is.na(x$total.time.max) | is.na(x$total.time.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.max <= x$total.time.med)),
          all(is.na(x$total.time.max) | is.na(x$total.time.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.max <= x$total.time.mode)),
          all(is.na(x$total.time.mean) | is.na(x$total.time.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.mean == x$total.time.med)),
          all(is.na(x$total.time.mean) | is.na(x$total.time.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.mean == x$total.time.mode)),
          all(is.na(x$total.time.mode) | is.na(x$total.time.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.time.mode == x$total.time.med)),
          all(is.na(x$total.fes.min) | is.finite(x$total.fes.min)),
          is.numeric(x$total.fes.min),
          is.integer(x$total.fes.min),
          all(is.na(x$total.fes.min) | (x$total.fes.min >= 0L)),
          all(is.na(x$total.fes.min) | (x$total.fes.min <= 2147483646L)),
          all(is.na(x$total.fes.mean) | is.finite(x$total.fes.mean)),
          is.numeric(x$total.fes.mean),
          all(is.na(x$total.fes.mean) | (x$total.fes.mean >= 0)),
          all(is.na(x$total.fes.mean) | (x$total.fes.mean <= 2147483646)),
          all(is.na(x$total.fes.med) | is.finite(x$total.fes.med)),
          is.numeric(x$total.fes.med),
          all(is.na(x$total.fes.med) | (x$total.fes.med >= 0)),
          all(is.na(x$total.fes.med) | (x$total.fes.med <= 2147483646)),
          all(is.na(x$total.fes.mode) | is.finite(x$total.fes.mode)),
          is.numeric(x$total.fes.mode),
          all(is.na(x$total.fes.mode) | (x$total.fes.mode >= 0)),
          all(is.na(x$total.fes.mode) | (x$total.fes.mode <= 2147483646)),
          all(is.na(x$total.fes.max) | is.finite(x$total.fes.max)),
          is.numeric(x$total.fes.max),
          all(is.na(x$total.fes.max) | (x$total.fes.max >= 0)),
          all(is.na(x$total.fes.max) | (x$total.fes.max <= 2147483646)),
          all(is.na(x$total.fes.min) | is.na(x$total.fes.max) | (x$total.fes.min <= x$total.fes.max)),
          all(is.na(x$total.fes.min) | is.na(x$total.fes.mean) | (x$total.fes.min <= x$total.fes.mean)),
          all(is.na(x$total.fes.min) | is.na(x$total.fes.med) | (x$total.fes.min <= x$total.fes.med)),
          all(is.na(x$total.fes.min) | is.na(x$total.fes.mode) | (x$total.fes.min <= x$total.fes.mode)),
          all(is.na(x$total.fes.mean) | is.na(x$total.fes.max) | (x$total.fes.mean <= x$total.fes.max)),
          all(is.na(x$total.fes.med) | is.na(x$total.fes.max) | (x$total.fes.med <= x$total.fes.max)),
          all(is.na(x$total.fes.mode) | is.na(x$total.fes.max) | (x$total.fes.mode <= x$total.fes.max)),
          all(is.na(x$total.fes.min) | is.na(x$total.fes.max) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.min >= x$total.fes.max)),
          all(is.na(x$total.fes.min) | is.na(x$total.fes.mean) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.min >= x$total.fes.mean)),
          all(is.na(x$total.fes.min) | is.na(x$total.fes.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.min >= x$total.fes.med)),
          all(is.na(x$total.fes.min) | is.na(x$total.fes.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.min >= x$total.fes.mode)),
          all(is.na(x$total.fes.max) | is.na(x$total.fes.mean) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.max <= x$total.fes.mean)),
          all(is.na(x$total.fes.max) | is.na(x$total.fes.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.max <= x$total.fes.med)),
          all(is.na(x$total.fes.max) | is.na(x$total.fes.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.max <= x$total.fes.mode)),
          all(is.na(x$total.fes.mean) | is.na(x$total.fes.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.mean == x$total.fes.med)),
          all(is.na(x$total.fes.mean) | is.na(x$total.fes.mode) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.mean == x$total.fes.mode)),
          all(is.na(x$total.fes.mode) | is.na(x$total.fes.med) | is.na(x$n.runs) | (x$n.runs > 1L) | (x$total.fes.mode == x$total.fes.med)),
          all(is.na(x$reach.best.f.min.runs) | is.finite(x$reach.best.f.min.runs)),
          is.numeric(x$reach.best.f.min.runs),
          is.integer(x$reach.best.f.min.runs),
          all(is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs >= 1L)),
          all(is.na(x$reach.best.f.min.runs) | is.na(x$n.runs) | (x$reach.best.f.min.runs <= x$n.runs)),
          all(is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs <= 10000000L)),
          all(is.na(x$reach.best.f.min.time.min) | is.finite(x$reach.best.f.min.time.min)),
          is.numeric(x$reach.best.f.min.time.min),
          is.integer(x$reach.best.f.min.time.min),
          all(is.na(x$reach.best.f.min.time.min) | (x$reach.best.f.min.time.min >= 0L)),
          all(is.na(x$reach.best.f.min.time.min) | (x$reach.best.f.min.time.min <= 2147483646L)),
          all(is.na(x$reach.best.f.min.time.mean) | is.finite(x$reach.best.f.min.time.mean)),
          is.numeric(x$reach.best.f.min.time.mean),
          all(is.na(x$reach.best.f.min.time.mean) | (x$reach.best.f.min.time.mean >= 0)),
          all(is.na(x$reach.best.f.min.time.mean) | (x$reach.best.f.min.time.mean <= 2147483646)),
          all(is.na(x$reach.best.f.min.time.med) | is.finite(x$reach.best.f.min.time.med)),
          is.numeric(x$reach.best.f.min.time.med),
          all(is.na(x$reach.best.f.min.time.med) | (x$reach.best.f.min.time.med >= 0)),
          all(is.na(x$reach.best.f.min.time.med) | (x$reach.best.f.min.time.med <= 2147483646)),
          all(is.na(x$reach.best.f.min.time.mode) | is.finite(x$reach.best.f.min.time.mode)),
          is.numeric(x$reach.best.f.min.time.mode),
          all(is.na(x$reach.best.f.min.time.mode) | (x$reach.best.f.min.time.mode >= 0)),
          all(is.na(x$reach.best.f.min.time.mode) | (x$reach.best.f.min.time.mode <= 2147483646)),
          all(is.na(x$reach.best.f.min.time.max) | is.finite(x$reach.best.f.min.time.max)),
          is.numeric(x$reach.best.f.min.time.max),
          all(is.na(x$reach.best.f.min.time.max) | (x$reach.best.f.min.time.max >= 0)),
          all(is.na(x$reach.best.f.min.time.max) | (x$reach.best.f.min.time.max <= 2147483646)),
          all(is.na(x$reach.best.f.min.time.sd) | is.finite(x$reach.best.f.min.time.sd)),
          is.numeric(x$reach.best.f.min.time.sd),
          all(is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd >= 0)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.max) | (x$reach.best.f.min.time.min <= x$reach.best.f.min.time.max)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.mean) | (x$reach.best.f.min.time.min <= x$reach.best.f.min.time.mean)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.med) | (x$reach.best.f.min.time.min <= x$reach.best.f.min.time.med)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.mode) | (x$reach.best.f.min.time.min <= x$reach.best.f.min.time.mode)),
          all(is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.time.max) | (x$reach.best.f.min.time.mean <= x$reach.best.f.min.time.max)),
          all(is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.time.max) | (x$reach.best.f.min.time.med <= x$reach.best.f.min.time.max)),
          all(is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.time.max) | (x$reach.best.f.min.time.mode <= x$reach.best.f.min.time.max)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.max) | is.na(x$reach.best.f.min.time.sd) | xor((x$reach.best.f.min.time.sd <= 0) , (x$reach.best.f.min.time.min < x$reach.best.f.min.time.max))),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.min >= x$reach.best.f.min.time.med)),
          all(is.na(x$reach.best.f.min.time.max) | is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.max <= x$reach.best.f.min.time.med)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.min >= x$reach.best.f.min.time.mean)),
          all(is.na(x$reach.best.f.min.time.max) | is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.max <= x$reach.best.f.min.time.mean)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.min >= x$reach.best.f.min.time.mode)),
          all(is.na(x$reach.best.f.min.time.max) | is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.max <= x$reach.best.f.min.time.mode)),
          all(is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.mean == x$reach.best.f.min.time.med)),
          all(is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.mean == x$reach.best.f.min.time.mode)),
          all(is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.time.sd) | (x$reach.best.f.min.time.sd > 0) | (x$reach.best.f.min.time.mode == x$reach.best.f.min.time.med)),
          all(is.na(x$reach.best.f.min.time.sd) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.sd <= 0)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.max) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.min >= x$reach.best.f.min.time.max)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.min >= x$reach.best.f.min.time.mean)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.min >= x$reach.best.f.min.time.med)),
          all(is.na(x$reach.best.f.min.time.min) | is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.min >= x$reach.best.f.min.time.mode)),
          all(is.na(x$reach.best.f.min.time.max) | is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.max <= x$reach.best.f.min.time.mean)),
          all(is.na(x$reach.best.f.min.time.max) | is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.max <= x$reach.best.f.min.time.med)),
          all(is.na(x$reach.best.f.min.time.max) | is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.max <= x$reach.best.f.min.time.mode)),
          all(is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.mean == x$reach.best.f.min.time.med)),
          all(is.na(x$reach.best.f.min.time.mean) | is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.mean == x$reach.best.f.min.time.mode)),
          all(is.na(x$reach.best.f.min.time.mode) | is.na(x$reach.best.f.min.time.med) | is.na(x$reach.best.f.min.runs) | (x$reach.best.f.min.runs > 1L) | (x$reach.best.f.min.time.mode == x$reach.best.f.min.time.med)),
          all(is.na(x$budget.fes) | is.finite(x$budget.fes)),
          is.numeric(x$budget.fes),
          is.integer(x$budget.fes),
          all(is.na(x$budget.fes) | (x$budget.fes >= 1L)),
          all(is.na(x$budget.fes) | (x$budget.fes <= 2147483646L)),
          all(is.na(x$budget.fes) | is.na(x$total.fes.min) | (x$total.fes.min <= x$budget.fes)),
          all(is.na(x$budget.fes) | is.na(x$total.fes.mean) | (x$total.fes.mean <= x$budget.fes)),
          all(is.na(x$budget.fes) | is.na(x$total.fes.med) | (x$total.fes.med <= x$budget.fes)),
          all(is.na(x$budget.fes) | is.na(x$total.fes.mode) | (x$total.fes.mode <= x$budget.fes)),
          all(is.na(x$budget.fes) | is.na(x$total.fes.max) | (x$total.fes.max <= x$budget.fes)),
          all(is.na(x$budget.time) | is.finite(x$budget.time)),
          is.numeric(x$budget.time),
          is.integer(x$budget.time),
          all(is.na(x$budget.time) | (x$budget.time >= 0L)),
          all(is.na(x$budget.time) | (x$budget.time <= 2147483646L)),
          all(is.na(x$budget.time) | is.na(x$last.improvement.time.min) | (x$last.improvement.time.min <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$last.improvement.time.mean) | (x$last.improvement.time.mean <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$last.improvement.time.med) | (x$last.improvement.time.med <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$last.improvement.time.mode) | (x$last.improvement.time.mode <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$last.improvement.time.max) | (x$last.improvement.time.max <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$reach.best.f.min.time.min) | (x$reach.best.f.min.time.min <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$reach.best.f.min.time.mean) | (x$reach.best.f.min.time.mean <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$reach.best.f.min.time.med) | (x$reach.best.f.min.time.med <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$reach.best.f.min.time.mode) | (x$reach.best.f.min.time.mode <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$reach.best.f.min.time.max) | (x$reach.best.f.min.time.max <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$total.time.min) | (x$total.time.min <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$total.time.mean) | (x$total.time.mean <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$total.time.med) | (x$total.time.med <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$total.time.mode) | (x$total.time.mode <= x$budget.time)),
          all(is.na(x$budget.time) | is.na(x$total.time.max) | (x$total.time.max <= x$budget.time)),
          all(c("inst.id", "inst.opt.bound.lower") %in% colnames(instances)),
          "inst.id" %in% colnames(x),
          all(vapply(x$inst.id, function(cn) { sum(instances$inst.id == cn) == 1L }, FALSE)),
          "best.f.min" %in% colnames(x),
          all(vapply(seq_len(nrow(x)), function(i) { is.na(x$best.f.min[[i]]) || (x$best.f.min[[i]] >= instances$inst.opt.bound.lower[instances$inst.id == x$inst.id[[i]]]) }, FALSE)),
          "best.f.mean" %in% colnames(x),
          all(vapply(seq_len(nrow(x)), function(i) { is.na(x$best.f.mean[[i]]) || (x$best.f.mean[[i]] >= instances$inst.opt.bound.lower[instances$inst.id == x$inst.id[[i]]]) }, FALSE)),
          "best.f.med" %in% colnames(x),
          all(vapply(seq_len(nrow(x)), function(i) { is.na(x$best.f.med[[i]]) || (x$best.f.med[[i]] >= instances$inst.opt.bound.lower[instances$inst.id == x$inst.id[[i]]]) }, FALSE)),
          "best.f.mode" %in% colnames(x),
          all(vapply(seq_len(nrow(x)), function(i) { is.na(x$best.f.mode[[i]]) || (x$best.f.mode[[i]] >= instances$inst.opt.bound.lower[instances$inst.id == x$inst.id[[i]]]) }, FALSE)),
          "best.f.max" %in% colnames(x),
          all(vapply(seq_len(nrow(x)), function(i) { is.na(x$best.f.max[[i]]) || (x$best.f.max[[i]] >= instances$inst.opt.bound.lower[instances$inst.id == x$inst.id[[i]]]) }, FALSE)));
options(old.options);
return(TRUE);
}

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

test_that("Test the results", {
  expect_true(is.data.frame(jssp.results));
  expect_gt(nrow(jssp.results), 0L);
  expect_identical(ncol(jssp.results), 55L);
  expect_identical(
    colnames(jssp.results),
    c(
      "algo.id",
      "algo.desc",
      "algo.representation",
      "algo.operator.unary",
      "algo.operator.binary",
      "ref.id",
      "ref.year",
      "inst.id",
      "inst.opt.bound.lower",
      "system.cpu.name",
      "system.cpu.n",
      "system.cpu.cores",
      "system.cpu.threads",
      "system.cpu.mhz",
      "system.runs.are.parallel",
      "system.memory.mb",
      "system.os.name",
      "system.vm.name",
      "system.compiler.name",
      "system.programming.language.name",
      "system.external.tools.list",
      "notes",
      "n.runs",
      "best.f.min",
      "best.f.mean",
      "best.f.med",
      "best.f.mode",
      "best.f.max",
      "best.f.sd",
      "last.improvement.time.min",
      "last.improvement.time.mean",
      "last.improvement.time.med",
      "last.improvement.time.mode",
      "last.improvement.time.max",
      "last.improvement.time.sd",
      "total.time.min",
      "total.time.mean",
      "total.time.med",
      "total.time.mode",
      "total.time.max",
      "total.time.sd",
      "total.fes.min",
      "total.fes.mean",
      "total.fes.med",
      "total.fes.mode",
      "total.fes.max",
      "reach.best.f.min.runs",
      "reach.best.f.min.time.min",
      "reach.best.f.min.time.mean",
      "reach.best.f.min.time.med",
      "reach.best.f.min.time.mode",
      "reach.best.f.min.time.max",
      "reach.best.f.min.time.sd",
      "budget.fes",
      "budget.time"
    )
  )

  expect_type(jssp.results[,1], "character"); # algo.id
  expect_type(jssp.results[,2], "character"); # algo.desc
  expect_type(jssp.results[,3], "character"); # algo.representation
  expect_type(jssp.results[,4], "character"); # algo.operator.unary
  expect_type(jssp.results[,5], "character"); # algo.operator.binary
  expect_type(jssp.results[,6], "character"); # ref.id
  expect_type(jssp.results[,7], "integer"); # ref.year
  expect_type(jssp.results[,8], "character"); # inst.id
  expect_type(jssp.results[,9], "integer"); # inst.opt.bound.lower
  expect_type(jssp.results[,10], "character"); # system.cpu.name
  expect_type(jssp.results[,11], "integer"); # system.cpu.n
  expect_type(jssp.results[,12], "integer"); # system.cpu.cores
  expect_type(jssp.results[,13], "integer"); # system.cpu.threads
  expect_type(jssp.results[,14], "integer"); # system.cpu.mhz
  expect_type(jssp.results[,15], "logical"); # system.runs.are.parallel
  expect_type(jssp.results[,16], "integer"); # system.memory.mb
  expect_type(jssp.results[,17], "character"); # system.os.name
  expect_type(jssp.results[,18], "character"); # system.vm.name
  expect_type(jssp.results[,19], "character"); # system.compiler.name
  expect_type(jssp.results[,20], "character"); # system.programming.language.name
  expect_type(jssp.results[,21], "character"); # system.external.tools.list
  expect_type(jssp.results[,22], "character"); # notes
  expect_type(jssp.results[,23], "integer"); # n.runs
  expect_type(jssp.results[,24], "integer"); # best.f.min
  expect_type(jssp.results[,25], "double"); # best.f.mean
  expect_type(jssp.results[,26], "double"); # best.f.med
  expect_type(jssp.results[,27], "double"); # best.f.mode
  expect_type(jssp.results[,28], "integer"); # best.f.max
  expect_type(jssp.results[,29], "double"); # best.f.sd
  expect_type(jssp.results[,30], "integer"); # last.improvement.time.min
  expect_type(jssp.results[,31], "double"); # last.improvement.time.mean
  expect_type(jssp.results[,32], "integer"); # last.improvement.time.med
  expect_type(jssp.results[,33], "integer"); # last.improvement.time.mode
  expect_type(jssp.results[,34], "integer"); # last.improvement.time.max
  expect_type(jssp.results[,35], "double"); # last.improvement.time.sd
  expect_type(jssp.results[,36], "integer"); # total.time.min
  expect_type(jssp.results[,37], "double"); # total.time.mean
  expect_type(jssp.results[,38], "integer"); # total.time.med
  expect_type(jssp.results[,39], "integer"); # total.time.mode
  expect_type(jssp.results[,40], "integer"); # total.time.max
  expect_type(jssp.results[,41], "double"); # total.time.sd
  expect_type(jssp.results[,42], "integer"); # total.fes.min
  expect_type(jssp.results[,43], "integer"); # total.fes.mean
  expect_type(jssp.results[,44], "integer"); # total.fes.med
  expect_type(jssp.results[,45], "integer"); # total.fes.mode
  expect_type(jssp.results[,46], "integer"); # total.fes.max
  expect_type(jssp.results[,47], "integer"); # reach.best.f.min.runs
  expect_type(jssp.results[,48], "integer"); # reach.best.f.min.time.min
  expect_type(jssp.results[,49], "integer"); # reach.best.f.min.time.mean
  expect_type(jssp.results[,50], "integer"); # reach.best.f.min.time.med
  expect_type(jssp.results[,51], "integer"); # reach.best.f.min.time.mode
  expect_type(jssp.results[,52], "integer"); # reach.best.f.min.time.max
  expect_type(jssp.results[,53], "double"); # reach.best.f.min.time.sd
  expect_type(jssp.results[,54], "integer"); # budget.fes
  expect_type(jssp.results[,55], "integer"); # budget.time
  .check.bib(jssp.instances$ref.id);

  inst.refs <- vapply(jssp.results$inst.id,
                      function(ii) {
                        found <- jssp.instances$inst.id == ii;
                        expect_identical(sum(found), 1L);
                        expect_true(all(!is.na(found)));
                        found <- which(found);
                        expect_length(found, 1L);
                        expect_true(!is.na(found));
                        expect_true(is.finite(found));
                        expect_gt(found, 0L);
                        expect_lte(found, nrow(jssp.instances));
                        expect_identical(jssp.instances$inst.id[[found]], ii);
                        return(found);
                      }, NA_integer_);
  expect_length(inst.refs, nrow(jssp.results));
  expect_true(all(is.finite(inst.refs)));

  expect_identical(jssp.results$inst.opt.bound.lower, jssp.instances$inst.opt.bound.lower[inst.refs]);
  bks <- jssp.instances$inst.bks[inst.refs];
  expect_true(all(jssp.results$inst.opt.bound.lower <= bks));
  expect_true(all(is.na(jssp.results$best.f.min) | (is.finite(jssp.results$best.f.min) & (jssp.results$best.f.min < .Machine$integer.max) & (jssp.results$best.f.min >= bks))));
  expect_true(all(is.na(jssp.results$best.f.mean) | (is.finite(jssp.results$best.f.mean) & (jssp.results$best.f.mean < .Machine$integer.max) & (jssp.results$best.f.mean >= bks))));
  expect_true(all(is.na(jssp.results$best.f.med) | (is.finite(jssp.results$best.f.med) & (jssp.results$best.f.med < .Machine$integer.max) & (jssp.results$best.f.med >= bks))));
  expect_true(all(is.na(jssp.results$best.f.mode) | (is.finite(jssp.results$best.f.mode) & (jssp.results$best.f.mode < .Machine$integer.max) & (jssp.results$best.f.mode >= bks))));
  expect_true(all(is.na(jssp.results$best.f.max) | (is.finite(jssp.results$best.f.max) & (jssp.results$best.f.max < .Machine$integer.max) & (jssp.results$best.f.max >= bks))));
  expect_true(all(is.na(jssp.results$best.f.sd) | (is.finite(jssp.results$best.f.sd) & (jssp.results$best.f.sd < .Machine$integer.max) & (jssp.results$best.f.sd >= 0))));

  mins <- vapply(seq_len(nrow(jssp.results)),
                 function(i) {
                   a <- jssp.results$best.f.min[[i]];
                   b <- jssp.results$best.f.mean[[i]];
                   expect_true(is.na(a) || is.na(b) || b >= a);
                   if((!is.na(b)) && is.na(a)) { a <- b; }
                   b <- jssp.results$best.f.med[[i]];
                   if((!is.na(b)) && is.na(a)) { a <- b; }
                   b <- jssp.results$best.f.mode[[i]];
                   if((!is.na(b)) && is.na(a)) { a <- b; }
                   b <- jssp.results$best.f.max[[i]];
                   if((!is.na(b)) && is.na(a)) { a <- b; }
                   expect_true(!is.na(a));
                   i <- as.integer(a);
                   expect_lte(i, a);
                   return(i);
                 }, NA_integer_);

  expect_true(all(is.finite(mins)));
  expect_true(all(mins >= bks));
  expect_true(all(mins < .Machine$integer.max));

  mins <- (mins == bks);
  for(inst in jssp.instances$inst.id) {
    expect_gt(sum(mins[inst == jssp.results$inst.id]), 0L);
  }

  .result.data.frame.validate(jssp.results, jssp.instances);
})
