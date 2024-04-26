#' qPCR data sets by Karlen et al. (2007)
#'
#' @description
#' One single tabular tidy data set in long format, encompassing 32 dilution
#' series, for seven PCR targets and four biological samples. The targeted
#' amplicons are within the murine genes: Cav1, Ccn2, Eln, Fn1, Rpl27, Hspg2, and
#' Serpine1, respectively. Dilution series: scheme 1 (Cav1, Eln, Hspg2,
#' Serpine1): 1-fold, 10-fold, 50-fold, and 100-fold; scheme 2 (Ccn2, Rpl27,
#' Fn1): 1-fold, 10-fold, 50-fold, 100-fold and 1000-fold. For each concentration
#' there are five replicates, except for the 1000-fold concentration, where only
#' two replicates were performed. Each amplification curve is 40 cycles long.
#' Please read the sections _Experimental set of qPCR data_ and _Quantitative
#' PCR assays_ of Karlen et al. (2007) for more details.
#'
#' @format A [tibble][tibble::tibble-package] providing amplification curve data
#' in long format.
#' \describe{
#' \item{`plate`}{Plate identifier. This corresponds, loosely, to the name of
#' the targets. In the original publication the amplicons are indicated by gene
#' symbol synonyms which we do use here for naming each plate. This differs from
#' the names used in the column `target` where actual murine gene symbols are
#' used.}
#' \item{`well`}{Well identifier, i.e. the position within the 96-well plate.}
#' \item{`target`}{Target identifier: murine gene symbol where the amplicon maps
#' to.}
#' \item{`dye`}{Type of fluorescence dye, in this data set it is always SYBR
#' Green I master mix (Roche) (`"SYBR"`).}
#' \item{`sample`}{Name of the biological sample.}
#' \item{`sample_type`}{Sample type. Most reactions in this data set are
#' standard curves, i.e. `"std"`, but a few no template controls (`"ntc"`) are
#' also included.}
#' \item{`replicate`}{Replicate identifier: 1 thru 5.}
#' \item{`copies`}{Standard copy number.}
#' \item{`dilution`}{Dilution factor. Higher number means greater dilution, e.g.
#' `10` means a 1:10 (ten-fold) dilution.}
#' \item{`cycle`}{PCR cycle.}
#' \item{`fluor`}{Raw fluorescence values.}
#' }
#'
#' @examples
#' karlen
#'
#' @source \doi{10.1186/1471-2105-8-131}
#' @name karlen
#' @keywords datasets
NULL
