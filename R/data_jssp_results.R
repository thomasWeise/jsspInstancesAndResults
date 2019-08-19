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
#' \item{system.cpu.n}{the number of CPUs used}
#' \item{system.cpu.cores}{the number of cores of per CPU}
#' \item{system.cpu.threads}{the number of threads of per CPU}
#' \item{system.cpu.mhz}{the clock speed of the CPU in MHz}
#' \item{system.runs.are.parallel}{are the single runs making use of parallelization, i.e., do they use multiple threads?}
#' \item{system.memory.mb}{the memory size of the system in MB}
#' \item{system.os.name}{the name of the CPU of the system on which the experiment was run}
#' \item{system.compiler.name}{the name of the compiler used to compile the programs for the experiment}
#' \item{system.programming.language.name}{the name of the programming language in which the program was written}
#' \item{system.external.tools.list}{the name of the external tools, such as deterministic solvers or CPLEX, whatever was used in the experiments}
#' \item{n.runs}{the total number of repetitions / runs performed}
#' \item{best.f.min}{the minimum value of the best objective value ever reached during the run}
#' \item{best.f.mean}{the arithmetic mean of the best objective value ever reached during the run}
#' \item{best.f.med}{the median of the best objective value ever reached during the run}
#' \item{best.f.mode}{the mode, i.e., the most frequent value, of the best objective value ever reached during the run}
#' \item{best.f.max}{the maximum value of the best objective value ever reached during the run}
#' \item{best.f.sd}{the standard deviation of the best objective value ever reached during the run}
#' \item{total.time.mean}{the arithmetic mean of the total consumed runtime of the run, i.e., the time until the run was terminated}
#' \item{reach.best.f.min.time.min}{the minimum value of the time needed by the runs which discovered the best solution among all runs (best.f.min) until they reached said solution}
#'}
#'
#' @keywords Job Shop Scheduling, JSSP, results
#'
#' @references  Cruz-Chávez MA, Cruz Rosales MH, Zavala-Díaz JC, Aguilar JAH, Rodrıguez-Leó A, Avelino JCP, Orziz MEL, Salinas OH (2019). “Hybrid Micro Genetic Multi-Population Algorithm With Collective Communication for the Job Shop Scheduling Problem.” IEEE Access, 7, 82358-82376. doi: 10.1109/ACCESS.2019.2924218 (URL: http://doi.org/10.1109/ACCESS.2019.2924218), <URL: http://ieeexplore.ieee.org/document/8743353>.
#' 
#' Pongchairerks P (2019). “A Two-Level Metaheuristic Algorithm for the Job-Shop Scheduling Problem.” Complexity, 2019(8683472), 1-11. doi: 10.1155/2019/8683472 (URL: http://doi.org/10.1155/2019/8683472), <URL: http://www.hindawi.com/journals/complexity/2019/8683472/>.
#' 
#'
#' @examples
#' data(jssp.results)
#' print(jssp.results)
"jssp.results"
