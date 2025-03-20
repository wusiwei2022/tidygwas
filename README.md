# tidygwas
Package tidygwas is to clean up GWAS summary data and specifically format and fit the data to conventional [Bayesian colocalization](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1004383) and [multi-trait colocalization](https://academic.oup.com/bioinformatics/article/34/15/2538/4944428).  

## Background
* GWAS run by different tools always produce summary statistics in different format. Therefore, the 1st significance of this package is to format the GWAS summary into a standardised format.
* Secondly, tidygwas allows us to harmonise GWAS summary data across up to 3 traits, which can further be fed into colocalization or multi-trait colocalization respectively in ['coloc'](https://github.com/chr1swallace/coloc) and ['moloc'](https://github.com/clagiamba/moloc) package.
* Lastly, tidygwas can help extract a subset of GWAS summary by RSID or Coordinate without reading the complete into R.

## Usage
```{r}
if(!require(devtools)){install.packages("devtools")}
devtools::install_github("wusiwei2022/tidygwas")
```

## Citation
Please cite this R package using this link [https://github.com/wusiwei2022/tidygwas](https://github.com/wusiwei2022/tidygwas).
