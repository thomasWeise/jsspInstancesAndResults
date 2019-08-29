# jsspInstancesAndResults

A repository with a data set including instances and results from literature.
While the raw data is provided as text files, it is also compiled in an `R` package with an API around it.
The goal is to have an update-able archive of the state-of-the-art results, directly linked with BibTeX entries and the functionality to generate result tables and to compare algorithms with said state-of-the-art.

This is just a preliminary, current version.
I begun searching papers from 2019 backwards, so many important works are still missing.
The best-known-solution (bks) columns in our [enriched instance information file](https://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/instances/instances_with_bks.txt) thus only include the papers used in this study.
Hence, when I am actually get to working through more papers, the references and values will be updated.

While all data is easily accessible within the `R` package, you can also access the raw data as follows:

- all the [results from our literature survey](https://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/results/all_results.txt) as CSV file
- the [plain instance information file](https://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/instances/instances.txt) as CSV file, mainly with infos from Jelke Jeroen van&nbsp;Hoorn's website <http://jobshop.jjvh.nl>
- the [instance information file with the best-known solutions **from this study**](https://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/instances/instances_with_bks.txt)
- the [instances from ORLib](https://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/instances/instance_data_orlib.txt)
- the [raw BibTeX file with all references to literature](https://raw.githubusercontent.com/thomasWeise/jsspInstancesAndResults/master/data-raw/bibliography/bibliography.bib)

Many of the information about the problem instances are taken from incredibly great website <http://jobshop.jjvh.nl> run by Jelke Jeroen van&nbsp;Hoorn, while the results are taken from their individual publications.
Another shout-out to Oleg V. Shylo, who runs <http://optimizizer.com/jobshop.php>, which holds many results on the JSSP as well.
