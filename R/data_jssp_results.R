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
#' \item{total.time.min}{the minimum value of the total consumed runtime of the run, i.e., the time until the run was terminated, measured in milliseconds}
#' \item{total.time.mean}{the arithmetic mean of the total consumed runtime of the run, i.e., the time until the run was terminated, measured in milliseconds}
#' \item{total.time.med}{the median of the total consumed runtime of the run, i.e., the time until the run was terminated, measured in milliseconds}
#' \item{total.time.mode}{the mode, i.e., the most frequent value, of the total consumed runtime of the run, i.e., the time until the run was terminated, measured in milliseconds}
#' \item{total.time.max}{the maximum value of the total consumed runtime of the run, i.e., the time until the run was terminated, measured in milliseconds}
#' \item{total.fes.min}{the minimum value of the total consumed function evaluations (FEs) of the run, i.e., the total number of candidate solutions generated during the run from the beginning to its end}
#' \item{total.fes.mean}{the arithmetic mean of the total consumed function evaluations (FEs) of the run, i.e., the total number of candidate solutions generated during the run from the beginning to its end}
#' \item{total.fes.med}{the median of the total consumed function evaluations (FEs) of the run, i.e., the total number of candidate solutions generated during the run from the beginning to its end}
#' \item{total.fes.mode}{the mode, i.e., the most frequent value, of the total consumed function evaluations (FEs) of the run, i.e., the total number of candidate solutions generated during the run from the beginning to its end}
#' \item{total.fes.max}{the maximum value of the total consumed function evaluations (FEs) of the run, i.e., the total number of candidate solutions generated during the run from the beginning to its end}
#' \item{reach.best.f.min.time.min}{the minimum value of the time needed by the runs which discovered the best solution among all runs (best.f.min) until they reached said solution, measured in milliseconds}
#' \item{reach.best.f.min.time.mean}{the arithmetic mean of the time needed by the runs which discovered the best solution among all runs (best.f.min) until they reached said solution, measured in milliseconds}
#' \item{budget.fes}{the maximum number of function evaluations a run was allowed to perform until forceful termination}
#' \item{budget.time}{the maximum time granted to a run until forceful termination, measured in milliseconds}
#'}
#'
#' @keywords Job Shop Scheduling, JSSP, results
#'
#' @references  Abdelmaguid TF (2010). “Representations in Genetic Algorithm for the Job Shop Scheduling Problem: A Computational Study.” Journal of Software Engineering and Applications (JSEA), 3(12), 1155-1162. doi: 10.4236/jsea.2010.312135 (URL: http://doi.org/10.4236/jsea.2010.312135), <URL: http://www.scirp.org/journal/paperinformation.aspx?paperid=3561>.
#' 
#' Asadzadeh L (2015). “A Local Search Genetic Algorithm for the Job Shop Scheduling Problem with Intelligent Agents.” Computers & Industrial Engineering, 85, 376-383. doi: 10.1016/j.cie.2015.04.006 (URL: http://doi.org/10.1016/j.cie.2015.04.006).
#' 
#' Abdel-Kader RF (2018). “An Improved PSO Algorithm with Genetic and Neighborhood-Based Diversity Operators for the Job Shop Scheduling Problem.” Applied Artificial Intelligence - An International Journal, 32(5), 433-462. doi: 10.1080/08839514.2018.1481903 (URL: http://doi.org/10.1080/08839514.2018.1481903).
#' 
#' Akram K, Kamal K, Zeb A (2016). “Fast Simulated Annealing Hybridized with Quenching for Solving Job Shop Scheduling Problem.” Applied Soft Computing Journal (ASOC), 49, 510-523. doi: 10.1016/j.asoc.2016.08.037 (URL: http://doi.org/10.1016/j.asoc.2016.08.037).
#' 
#' Angel JM, Martínez MR, Castillo LRM, Solis LS (2014). “Un Modelo Híbrido de Inteligencia Computacional para Resolver el Problema de Job Shop Scheduling.” Research in Computing Science, 79(Advances in Intelligent Information Technologies), 9-20. <URL: http://www.rcs.cic.ipn.mx/2014_79/RCS_79_2014.pdf>.
#' 
#' Amirghasemi M, Zamani R (2015). “An Effective Asexual Genetic Algorithm for Solving the Job Shop Scheduling Problem.” Computers & Industrial Engineering, 83, 123-138. doi: 10.1016/j.cie.2015.02.011 (URL: http://doi.org/10.1016/j.cie.2015.02.011).
#' 
#' Bierwirth C (1995). “A Generalized Permutation Approach to Job Shop Scheduling with Genetic Algorithms.” Operations-Research-Spektrum (OR Spectrum), 17(2-3), 87-92. doi: 10.1007/BF01719250 (URL: http://doi.org/10.1007/BF01719250), <URL: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.52.7392&type=pdf>.
#' 
#' Beck JC, Feng TK, Watson J (2011). “Combining Constraint Programming and Local Search for Job-Shop Scheduling.” INFORMS Journal on Computing, 23(1), 1-14. doi: 10.1287/ijoc.1100.0388 (URL: http://doi.org/10.1287/ijoc.1100.0388), <URL: http://cfwebprod.sandia.gov/cfdocs/CompResearch/docs/ists-sgmpcs.pdf>.
#' 
#' Cruz-Chávez MA, Cruz Rosales MH, Zavala-Díaz JC, Aguilar JAH, Rodrıguez-Leó A, Avelino JCP, Orziz MEL, Salinas OH (2019). “Hybrid Micro Genetic Multi-Population Algorithm With Collective Communication for the Job Shop Scheduling Problem.” IEEE Access, 7, 82358-82376. doi: 10.1109/ACCESS.2019.2924218 (URL: http://doi.org/10.1109/ACCESS.2019.2924218), <URL: http://ieeexplore.ieee.org/document/8743353>.
#' 
#' Cheng TCE, Peng B, Lü Z (2016). “A Hybrid Evolutionary Algorithm to Solve the Job Shop Scheduling Problem.” Annals of Operations Research, 242(2), 223-237. doi: 10.1007/s10479-013-1332-5 (URL: http://doi.org/10.1007/s10479-013-1332-5).
#' 
#' Dao T, Pan T, Nguyen T, Pan J (2018). “Parallel Bat Algorithm for Optimizing Makespan in Job Shop Scheduling Problems.” Journal of Intelligent Manufacturing, 29(2), 451-462. doi: 10.1007/s10845-015-1121-x (URL: http://doi.org/10.1007/s10845-015-1121-x).
#' 
#' Gao L, Li X, Wen X, Lu C, Wen F (2015). “A Hybrid Algorithm based on a New Neighborhood Structure Evaluation Method for Job Shop Scheduling Problem.” Computers & Industrial Engineering, 88, 417-429. doi: 10.1016/j.cie.2015.08.002 (URL: http://doi.org/10.1016/j.cie.2015.08.002).
#' 
#' Gonçalves JF, Resende MGC (2014). “An Extended Akers Graphical Method with a Biased Random-Key Genetic Algorithm for Job-Shop Scheduling.” International Transactions on Operational Research (ITOR), 21(2), 215-246. doi: 10.1111/itor.12044 (URL: http://doi.org/10.1111/itor.12044), <URL: http://mauricio.resende.info/doc/brkga-jss2011.pdf>.
#' 
#' Hernández-Ramírez L, Solis JF, Castilla-Valdez G, González-Barbosa JJ, Terán-Villanueva D, Morales-Rodríguez ML (2019). “A Hybrid Simulated Annealing for Job Shop Scheduling Problem.” International Journal of Combinatorial Optimization Problems and Informatics (IJCOPI), 10(1), 6-15. published 2018-08-10, <URL: http://ijcopi.org/index.php/ojs/article/view/111>.
#' 
#' Jorapur V, Puranik VS, Deshpande AS, Sharma MR (2014). “Comparative Study of Different Representations in Genetic Algorithms for Job Shop Scheduling Problem.” Journal of Software Engineering and Applications (JSEA), 7(7), 571-580. doi: 10.4236/jsea.2014.77053 (URL: http://doi.org/10.4236/jsea.2014.77053), <URL: http://www.scirp.org/journal/paperinformation.aspx?paperid=46670>.
#' 
#' Jiang T, Zhang C (2018). “Application of Grey Wolf Optimization for Solving Combinatorial Problems: Job Shop and Flexible Job Shop Scheduling Cases.” IEEE Access, 6, 26231-26240. doi: 10.1109/ACCESS.2018.2833552 (URL: http://doi.org/10.1109/ACCESS.2018.2833552), <URL: http://ieeexplore.ieee.org/document/8355479>.
#' 
#' Kurdi M (2015). “A New Hybrid Island Model Genetic Algorithm for Job Shop Scheduling Problem.” Computers & Industrial Engineering, 88, 273-283. doi: 10.1016/j.cie.2015.07.015 (URL: http://doi.org/10.1016/j.cie.2015.07.015).
#' 
#' Kulkarni K, Venkateswaran J (2014). “Iterative Simulation and Optimization Approach for Job Shop Scheduling.” In Buckley SJ, Miller JA (eds.), Proceedings of the 2014 Winter Simulation Conference, December 7-10, 2014, Savannah, GA, USA, 1620-1631. doi: 10.1109/WSC.2014.7020013 (URL: http://doi.org/10.1109/WSC.2014.7020013), <URL: https://www.anylogic.com/upload/iblock/5aa/5aa2987b839049668eeef8a21c811e6b.pdf>.
#' 
#' Li L, Weng W, Fujimura S (2017). “An Improved Teaching-Learning-based Optimization Algorithm to Solve Job Shop Scheduling Problems.” In Zhu G, Yao S, Cui X, Xu S (eds.), 16th IEEE/ACIS International Conference on Computer and Information Science (ICIS'17), May 24-26, 2017, Wuhan, China, 797-801. ISBN 978-1-5090-5507-4, doi: 10.1109/ICIS.2017.7960101 (URL: http://doi.org/10.1109/ICIS.2017.7960101).
#' 
#' Miller-Todd J, Steinhöfel K, Veenstra P (2018). “Firefly-Inspired Algorithm for Job Shop Scheduling.” In Böckenhauer H, Komm D, Unger W (eds.), Adventures Between Lower Bounds and Higher Altitudes - Essays Dedicated to Juraj Hromkovič on the Occasion of His 60th Birthday, volume 11011 series Lecture Notes in Computer Science (LNCS), 423-433. Springer. ISBN 978-3-319-98354-7, doi: 10.1007/978-3-319-98355-4_24 (URL: http://doi.org/10.1007/978-3-319-98355-4_24).
#' 
#' Nguyen S, Zhang M, Johnston M, Tan KC (2013). “A Computational Study of Representations in Genetic Programming to Evolve Dispatching Rules for the Job Shop Scheduling Problem.” IEEE Transactions on Evolutionary Computation (TEVC), 17(5), 621-639. doi: 10.1109/TEVC.2012.2227326 (URL: http://doi.org/10.1109/TEVC.2012.2227326).
#' 
#' Pongchairerks P (2014). “Variable Neighbourhood Search Algorithms Applied to Job-Shop Scheduling Problems.” International Journal of Mathematics in Operational Research (IJMOR), 6(6), 752-774. doi: 10.1504/IJMOR.2014.065421 (URL: http://doi.org/10.1504/IJMOR.2014.065421).
#' 
#' Pongchairerks P (2019). “A Two-Level Metaheuristic Algorithm for the Job-Shop Scheduling Problem.” Complexity, 2019(8683472), 1-11. doi: 10.1155/2019/8683472 (URL: http://doi.org/10.1155/2019/8683472), <URL: http://www.hindawi.com/journals/complexity/2019/8683472/>.
#' 
#' Peng B, Lü Z, Cheng TCE (2015). “A Tabu Search/Path Relinking Algorithm to Solve the Job Shop Scheduling Problem.” Computers & Operations Research, 53, 154-164. doi: 10.1016/j.cor.2014.08.006 (URL: http://doi.org/10.1016/j.cor.2014.08.006), A February 2014 preprint is available as arXiv:1402.5613v1 [cs.DS], <URL: http://arxiv.org/abs/1402.5613>.
#' 
#' Qiu X, Lau HYK (2014). “An AIS-based Hybrid Algorithm for Static Job Shop Scheduling Problem.” Journal of Intelligent Manufacturing, 25(3), 489-503. doi: 10.1007/s10845-012-0701-2 (URL: http://doi.org/10.1007/s10845-012-0701-2).
#' 
#' Sharma N, Sharma H, Sharma A (2018). “Beer froth Artificial Bee Colony Algorithm for Job-Shop Scheduling Problem.” Applied Soft Computing Journal (ASOC), 68, 507-524. doi: 10.1016/j.asoc.2018.04.001 (URL: http://doi.org/10.1016/j.asoc.2018.04.001).
#' 
#' Wang L, Cai J, Li M (2016). “An Adaptive Multi-Population Genetic Algorithm for Job-Shop Scheduling Problem.” Advances in Manufacturing, 4(2), 142-149. doi: 10.1007/s40436-016-0140-y (URL: http://doi.org/10.1007/s40436-016-0140-y).
#' 
#' Wang X, Duan H (2014). “A Hybrid Biogeography-based Optimization Algorithm for Job Shop Scheduling Problem.” Computers & Industrial Engineering, 73, 96-114. doi: 10.1016/j.cie.2014.04.006 (URL: http://doi.org/10.1016/j.cie.2014.04.006), <URL: http://hbduan.buaa.edu.cn/papers/2014CAIE_Wang_Duan.pdf>.
#' 
#' Wang S, Tsai C, Chiang M (2018). “A High Performance Search Algorithm for Job-Shop Scheduling Problem.” In Shakshuki EM, Yasar A (eds.), The 9th International Conference on Emerging Ubiquitous Systems and Pervasive Networks (EUSPN'18) / The 8th International Conference on Current and Future Trends of Information and Communication Technologies in Healthcare (ICTH'18) / Affiliated Workshops, November 5-8, 2018, Leuven, Belgium, volume 141 series Procedia Computer Science, 119-126. doi: 10.1016/j.procs.2018.10.157 (URL: http://doi.org/10.1016/j.procs.2018.10.157).
#' 
#' Zupan H, Herakovič N, Žerovnik J (2016). “A Heuristic for the Job Shop Scheduling Problem.” In Papa G, Mernik M (eds.), The 7th International Conference on Bioinspired Optimization Methods and their Application (BIOMA'16), May 18-20, 2016, Bled, Slovenia, 187-198. ISBN 978-961-264-093-4, <URL: http://bioma.ijs.si/conference/BIOMA2016Proceedings.pdf>.
#' 
#'
#' @examples
#' data(jssp.results)
#' print(jssp.results)
"jssp.results"
