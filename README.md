# tidygwas
Package tidygwas is to clean up GWAS summary data and specifically format and fit the data to conventional [Bayesian colocalization](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1004383) and [multi-trait colocalization](https://academic.oup.com/bioinformatics/article/34/15/2538/4944428).  

## Background
* GWAS run by different tools always produce summary statistics in different format. Therefore, the 1st significance of this package is to format the GWAS summary into a standardised format.
* Secondly, tidygwas allows us to harmonise GWAS summary data across up to 3 traits, which can further be fed into colocalization or multi-trait colocalization respectively in ['coloc'](https://github.com/chr1swallace/coloc) and ['moloc'](https://github.com/clagiamba/moloc) package.
* Lastly, tidygwas can help extract a subset of GWAS summary by RSID or Coordinate without reading the complete into R.

## Usage
Install package:
```{r}
if(!require(devtools)){install.packages("devtools")}
devtools::install_github("wusiwei2022/tidygwas")
```

Load built-in data without any formatting or quality control:
```{r}
data(pQTL_BRAP_RAW)
data(eQTL_BRAP_RAW)
data(SBP_BRAP_RAW)
data(CAD_BRAP_RAW)
```

Format and quality control:
```{r}
# pQTL
pQTL_BRAP = format.data(data = pQTL_BRAP_RAW, TRAIT = "BRAP pQTL", RSID = "SNP", CHR = "CHROM", POS = "GENPOS", EA = "ALLELE1", NEA = "ALLELE0", EAF = "A1FREQ", P = "P", LOG10P = "LOG10P", N = "N")
pQTL_BRAP = qc.data(pQTL_BRAP, option = "biallelic.snp")

# eQTL
eQTL_BRAP = format.data(data = eQTL_BRAP_RAW, TRAIT = "BRAP eQTL", RSID = "SNP", CHR = "SNPChr", POS = "SNPPOS", EA = "AssessedAllele", NEA = "OtherAllele", EAF = "AssessedAlleleFrq", Z = "Zscore", P = "Pvalue", N = "NrSamples")
eQTL_BRAP = qc.data(eQTL_BRAP, option = "biallelic.snp")

# SBP
SBP_BRAP = format.data(data = SBP_BRAP_RAW, TRAIT = "SBP", RSID = "SNP", EA = "effect_allele", NEA = "other_allele", EAF = "eaf", BETA = "beta", SE = "se", P = "pval", N = "samplesize")
SBP_BRAP = qc.data(SBP_BRAP, option = "biallelic.snp")

# CAD
CAD_BRAP = format.data(data = CAD_BRAP_RAW, TRAIT = "CAD", RSID = "SNP", CHR = "chr", POS = "pos", EA = "effect_allele", NEA = "other_allele", EAF = "eaf", BETA = "beta", SE = "se", P = "pval", N = "samplesize", NCASE = "ncase", NCTRL = "ncontrol")
CAD_BRAP = qc.data(CAD_BRAP, option = "biallelic.snp")
```

There are also cleaned data available in the package:
```{r}
data(pQTL_BRAP)
data(eQTL_BRAP)
data(SBP_BRAP)
data(CAD_BRAP)
```

Harmonize for either conventional Bayesian Colocalization or multi-trait colocalization:
```{r}
# Harmonize 2 dataset to run Bayesian Colocalization
coloc.data.brap.eQTL.sbp = harmonise.coloc.data(eQTL_BRAP, SBP_BRAP)
# Harmonize across 3 dataset to run multi-trait colocalization
moloc.data.brap.eQTL.pQTL.sbp = harmonise.moloc.data(eQTL_BRAP, pQTL_BRAP, SBP_BRAP)
```

## Citation
Please cite this R package using this link [https://github.com/wusiwei2022/tidygwas](https://github.com/wusiwei2022/tidygwas).
