#' @title Get the Data for a Given Instance
#' @description For an instance name, get the corresponding data
#' @param inst.id the id/name of the JSSP instance
#' @return the instance data entry, formatted according to
#'   \link{jssp.instance.data}
#' @export jssp.get.instance.data
jssp.get.instance.data <- function(inst.id) {
  stopifnot(is.character(inst.id),
            length(inst.id) == 1L,
            nchar(inst.id) > 0L);
  found <- (names(jssp.instance.data) == inst.id);
  stopifnot(length(found) == length(jssp.instance.data),
            sum(found) == 1L);
  found <- which(found);
  stopifnot(is.integer(found) == 1L,
            is.finite(found),
            found >= 1L,
            found <= length(jssp.instance.data));
  data <- jssp.instance.data[[found]];
  data <- force(data);
  stopifnot(identical(data$inst.id, inst.id),
            is.integer(data$inst.machines),
            is.finite(data$inst.machines),
            data$inst.machines > 0L,
            is.integer(data$inst.jobs),
            is.finite(data$inst.jobs),
            data$inst.jobs > 0L,
            is.integer(data$inst.opt.bound.lower),
            is.finite(data$inst.opt.bound.lower),
            data$inst.opt.bound.lower > 0L,
            is.matrix(data$inst.data),
            nrow(data$inst.data) == data$inst.jobs,
            ncol(data$inst.data) == (2L * data$inst.machines));
  return(data);
}
