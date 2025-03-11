#' Convert a GWAS Summary data into a standard format for downstream colocalization analysis 
#' @param data the data frame to be formatted, either data or data.path should be provided
#' @param data.path path to the data frame to be formatted, either data or data.path should be provided
#' @param TRAIT trait name
#' @param RSID the ID column for genetic variants, must be provided 
#' @param CHR column for variant chromosome
#' @param POS column  for variant position
#' @param EA column for the effect allele
#' @param NEA column for the non-effect allele
#' @param EAF column for the effect allele frequency
#' @param MAF column for the minor allele frequency. If not available, MAF can be calculated from EAF
#' @param BETA column for the beta in regression model
#' @param SE column for the standard error of beta in regression model
#' @param Z column for the Z statistics in regression model
#' @param P column for the P value to test beta = 0 
#' @param LOG10P column for the log10P to test beta = 0 
#' @param N column for the sample size in GWAS
#' @return A post-formated data frame
#' @export format.data
format.data = function(data = NULL, data.path = NULL, TRAIT, 
                       RSID = "RSID", CHR = NA, POS = NA, 
                       EA = NA, NEA = NA, EAF = NA, MAF = NA, 
                       BETA = NA, SE = NA, Z = NA,
                       P = NA, LOG10P = NA, N = NA){
  if(is.null(data) & is.null(data.path)){stop("please provide gwas summary data or path to gwas summary data")}
  if(is.null(data) & !is.null(data.path)){data = data.table::fread(data.path)}
  if(is.na(RSID) | !{RSID %in% names(data)}){stop("please provide unique identifiers for genetic variants")}
  data = as.data.frame(data)
  std.data = data.frame(rsid = data[, RSID])
  
  ### Trait name
  std.data = std.data %>% dplyr::mutate(trait = TRAIT, .before = "rsid")
  
  ### Coordinate 
  if(!is.na(CHR) & CHR %in% names(data)){std.data = std.data %>% dplyr::mutate(chr = data[, CHR])}else{std.data = std.data %>% dplyr::mutate(chr = NA)}
  if(!is.na(POS) & POS %in% names(data)){std.data = std.data %>% dplyr::mutate(pos = data[, POS])}else{std.data = std.data %>% dplyr::mutate(pos = NA)}
  
  ### Effect allele and non-effect allele
  if(!is.na(EA) & EA %in% names(data)){std.data = std.data %>% dplyr::mutate(ea = data[, EA])}else{std.data = std.data %>% dplyr::mutate(ea = NA)}
  if(!is.na(NEA) & NEA %in% names(data)){std.data = std.data %>% dplyr::mutate(nea = data[, NEA])}else{std.data = std.data %>% dplyr::mutate(nea = NA)}
  
  ### EAF
  if(!is.na(EAF) & EAF %in% names(data)){std.data = std.data %>% dplyr::mutate(eaf = data[, EAF])}else{std.data = std.data %>% dplyr::mutate(eaf = NA)}
  ### MAF
  if(!is.na(MAF) & MAF %in% names(data)){std.data = std.data %>% dplyr::mutate(maf = data[, MAF], .after = nea)}
  if(is.na(MAF) & !is.na(EAF) & EAF %in% names(data)){std.data = std.data %>% dplyr::mutate(maf = ifelse(eaf<0.5, eaf, 1-eaf))}
  if(is.na(MAF) & {is.na(EAF) | !(EAF %in% names(data))}){std.data = std.data %>% dplyr::mutate(maf = NA)}
  
  ### Beta, Se, and Z statistics
  if(!is.na(BETA) & BETA %in% names(data)){std.data = std.data %>% dplyr::mutate(beta = data[, BETA])}else{std.data = std.data %>% dplyr::mutate(beta = NA)}
  if(!is.na(SE) & SE %in% names(data)){std.data = std.data %>% dplyr::mutate(se = data[, SE])}else{std.data = std.data %>% dplyr::mutate(se = NA)}
  if(!is.na(Z) & Z %in% names(data)){std.data = std.data %>% dplyr::mutate(z = data[, Z])}else{std.data = std.data %>% dplyr::mutate(z = NA)}
  
  ### P value and log10 P value
  if(!is.na(P) & P %in% names(data)){std.data = std.data %>% dplyr::mutate(p = data[, P])}else{std.data = std.data %>% dplyr::mutate(p = NA)}
  if(!is.na(LOG10P) & LOG10P %in% names(data)){std.data = std.data %>% dplyr::mutate(log10p = data[, LOG10P])}else{std.data = std.data %>% dplyr::mutate(log10p = NA)}
  
  ### Sample size
  if(!is.na(N) & N %in% names(data)){std.data = std.data %>% dplyr::mutate(n = data[, N])}else{std.data = std.data %>% dplyr::mutate(n = NA)}
  
  return(std.data)
}

#' Quality Control the post-format standardized data
#' @export
qc.data = function(data, option = "biallelic.snp", id = "rsid"){
  if(option == "biallelic.variant"){
    data = data[!{duplicated(data$rsid, fromLast = TRUE) | duplicated(data$rsid, fromLast = FALSE)},]}
  if(option == "biallelic.snp"){
    data = data[!{duplicated(data$rsid, fromLast = TRUE) | duplicated(data$rsid, fromLast = FALSE)},]
    data = data %>% dplyr::filter(ea %in% c("A", "T", "C", "G") & nea %in% c("A", "T", "C", "G"))}
  return(data)
}