#'  Result Data from the Literature for Common JSSP Benchmark Instances
#'
#' Here we provide a set of results for the common instances for the Job Shop Scheduling Problem (JSSP) taken from literature.
#'
#' @docType data
#'
#' @usage data(jssp.results)
#'
#' @format A data frame with the result data sets
#' \describe{
#' \item{algo.id}{the ID or short name of the algorithm used to solve the problem instance}
#' \item{ref.id}{the id of the bibliography entry identifying the publication where the result was taken from}
#' \item{ref.year}{the year when the results were published}
#' \item{inst.id}{the ID of the problem instance solved}
#' \item{inst.opt.bound.lower}{lower bound of the optimal objective value}
#' \item{system.cpu.name}{the name of the CPU of the system on which the experiment was run}
#' \item{system.cpu.cores}{the number of cores of the CPU}
#' \item{system.cpu.threads}{the number of threads of the CPU}
#' \item{system.cpu.mhz}{the clock speed of the CPU in MHz}
#' \item{system.memory.mb}{the memory size of the system in MB}
#' \item{system.programming.language.name}{the name of the programming language in which the program was written}
#' \item{n.runs}{the total number of repetitions / runs performed}
#' \item{best.f.min}{the minimum value of the best objective value ever reached during the run}
#' \item{best.f.mean}{the arithmetic mean of the best objective value ever reached during the run}
#' \item{total.time.mean}{the arithmetic mean of the total consumed runtime of the run, i.e., the time until the run was terminated}
#'}
#'
#' @keywords Job Shop Scheduling, JSSP, results
#'
#' @references  Pongchairerks P (2019). “A Two-Level Metaheuristic Algorithm for the Job-Shop Scheduling Problem.” Complexity, 2019(8683472), 1-11. doi: 10.1155/2019/8683472 (URL: http://doi.org/10.1155/2019/8683472), <URL: http://www.hindawi.com/journals/complexity/2019/8683472/>.
#' 
#'
#' @examples
#' data(jssp.results)
#' print(jssp.results)
"jssp.results"
