#' Cis-pQTLs within +/- 1MB from each side of BRAP gene without any formatting and quality control 
#' @docType data
#' @usage data(pQTL_BRAP_RAW)
#' @format An object of class data.frame. 
#' @source \href{https://metabolomips.org/ukbbpgwas/}
#' @keywords pQTL
"pQTL_BRAP_RAW"

#' Cis-pQTLs within +/- 1MB from each side of BRAP gene after proper re-formatting and quality control 
#' @docType data
#' @usage data(pQTL_BRAP)
#' @format An object of class data.frame. 
#' @source \href{https://metabolomips.org/ukbbpgwas/}
#' @keywords pQTL
"pQTL_BRAP"

#' Cis-eQTLs from the +/-1MB from the center of BRAP gene without any formatting and quality control 
#' @docType data
#' @usage data(eQTL_BRAP_RAW)
#' @format An object of class data.frame. 
#' @source \href{https://eqtlgen.org/cis-eqtls.html}
#' @keywords eQTL
"eQTL_BRAP_RAW"

#' Cis-eQTLs from the +/-1MB from the center of BRAP gene after proper re-formatting and quality control 
#' @docType data
#' @usage data(eQTL_BRAP)
#' @format An object of class data.frame. 
#' @source \href{https://eqtlgen.org/cis-eqtls.html}
#' @keywords eQTL
"eQTL_BRAP"

#' SBP GWAS summary data within +/-1MB from each side of BRAP gene without any formatting and quality control 
#' @docType data
#' @usage data(SBP_BRAP_RAW)
#' @format An object of class data.frame. 
#' @source \href{https://www.nealelab.is/uk-biobank}
#' @keywords SBP
"SBP_BRAP_RAW"

#' SBP GWAS summary data within +/-1MB from each side of BRAP gene after proper re-formatting and quality control 
#' @docType data
#' @usage data(SBP_BRAP)
#' @format An object of class data.frame. 
#' @source \href{https://www.nealelab.is/uk-biobank}
#' @keywords GWAS summary data
"SBP_BRAP"

#' CAD GWAS summary data within +/-1MB from each side of BRAP gene without any formatting and quality control 
#' @docType data
#' @usage data(CAD_BRAP_RAW)
#' @format An object of class data.frame. 
#' @source \href{https://www.cardiogramplusc4d.org/data-downloads/}
#' @keywords CAD
"CAD_BRAP_RAW"

#' CAD GWAS summary data within +/-1MB from each side of BRAP gene after proper re-formatting and quality control 
#' @docType data
#' @usage data(CAD_BRAP)
#' @format An object of class data.frame. 
#' @source \href{https://www.cardiogramplusc4d.org/data-downloads/}
#' @keywords CAD
"CAD_BRAP"

# library(tidygwas)
# # Coordinate of BRAP (Ensemble ID ENSG00000089234) is chr12:111,642,146-111,685,956 (hg38) or chr12:112,079,950-112,123,760 (hg37)
# # pQTL data
# pQTL_BRAP_RAW = extract.data(data.path = "/rds/general/project/medbio-epiukb-archive-2018/live/pickup/Siwei/GWAS_Proteomics/06_01_UKBPPP_Combined/03_Data/04_CleanData_hg38/OID31506_Q7Z569_BRAP.txt.gz",
#                              data.type = ".txt.gz",
#                              extract.by = "Coord",
#                              chr.index = 3,
#                              pos.index = 4,
#                              chr = 12,
#                              pos.lower = 111642146 - 1000000,
#                              pos.upper = 111685956 + 1000000)
# save(pQTL_BRAP_RAW, file = "../data/pQTL_BRAP_RAW.rda")
# pQTL_BRAP = format.data(data = pQTL_BRAP_RAW,
#                         TRAIT = "BRAP pQTL",
#                         RSID = "SNP",
#                         CHR = "CHROM",
#                         POS = "GENPOS",
#                         EA = "ALLELE1",
#                         NEA = "ALLELE0",
#                         EAF = "A1FREQ",
#                         P = "P",
#                         LOG10P = "LOG10P",
#                         N = "N")
# pQTL_BRAP = qc.data(pQTL_BRAP, option = "biallelic.snp")
# save(pQTL_BRAP, file = "../data/pQTL_BRAP.rda")

# # eQTL data
# eQTL_BRAP_RAW = fread("/rds/general/project/medbio-epiukb-archive-2018/live/pickup/Siwei/GWAS_Summary/eQTLGen/02_Data/02_CleanData/eQTLGen_ciseQTL_2018/ENSG00000089234_BRAP.txt", header = TRUE)
# save(eQTL_BRAP_RAW, file = "../data/eQTL_BRAP_RAW.rda")
# eQTL_BRAP = format.data(data = eQTL_BRAP_RAW,
#                         TRAIT = "BRAP eQTL",
#                         RSID = "SNP",
#                         CHR = "SNPChr",
#                         POS = "SNPPOS",
#                         EA = "AssessedAllele",
#                         NEA = "OtherAllele",
#                         EAF = "AssessedAlleleFrq",
#                         Z = "Zscore",
#                         P = "Pvalue",
#                         N = "NrSamples")
# eQTL_BRAP = qc.data(eQTL_BRAP, option = "biallelic.snp")
# save(eQTL_BRAP, file = "../data/eQTL_BRAP.rda")

# # SBP GWAS data in +/- 1MB BRAP gene locus
# SBP_BRAP_RAW = extract.data(data.path = "/rds/general/project/medbio-epiukb-archive-2018/live/pickup/Siwei/GWAS_Phenotypes/04_01_BP_EUR/01_Data/02_CleanData/SBP.txt",
#                             data.type = ".txt",
#                             extract.by = "ID",
#                             id.index = 1,
#                             ref.id = pQTL_BRAP$rsid)
# save(SBP_BRAP_RAW, file = "../data/SBP_BRAP_RAW.rda")
# SBP_BRAP = format.data(data = SBP_BRAP_RAW,
#                        TRAIT = "SBP",
#                        RSID = "SNP",
#                        EA = "effect_allele",
#                        NEA = "other_allele",
#                        EAF = "eaf",
#                        BETA = "beta",
#                        SE = "se",
#                        P = "pval",
#                        N = "samplesize")
# SBP_BRAP = qc.data(SBP_BRAP, option = "biallelic.snp")
# save(SBP_BRAP, file = "../data/SBP_BRAP.rda")

# # CAD GWAS data in +/- 1MB BRAP gene locus
# CAD_BRAP_RAW = extract.data(data.path = "/rds/general/project/medbio-epiukb-archive-2018/live/pickup/Siwei/GWAS_Phenotypes/06_01_CAD_EUR/01_Data/02_CleanData_AllVariants/CAD_META.txt",
#                             data.type = ".txt",
#                             extract.by = "ID",
#                             id.index = 1,
#                             ref.id = pQTL_BRAP$rsid)
# save(CAD_BRAP_RAW, file="../data/CAD_BRAP_RAW.rda")
# CAD_BRAP = format.data(data = CAD_BRAP_RAW,
#                        TRAIT = "CAD",
#                        RSID = "SNP",
#                        CHR = "chr",
#                        POS = "pos",
#                        EA = "effect_allele",
#                        NEA = "other_allele",
#                        EAF = "eaf",
#                        BETA = "beta",
#                        SE = "se",
#                        P = "pval",
#                        N = "samplesize",
#                        NCASE = "ncase",
#                        NCTRL = "ncontrol")
# CAD_BRAP = qc.data(CAD_BRAP, option = "biallelic.snp")
# save(CAD_BRAP, file = "../data/CAD_BRAP.rda")
