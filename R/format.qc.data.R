#' Convert a GWAS Summary data into a standard format for downstream colocalization analysis 
#' @export format.data
format.data = function(data = NULL, data.path = NULL, TRAIT, 
                       RSID = "RSID", CHR = "CHR", POS = "POS", 
                       EA = "EA", NEA = "NEA", EAF = NULL, MAF = NULL, 
                       BETA = "BETA", SE = "SE", 
                       P = NULL, LOG10P = NULL, N = "N"){
  if(is.null(data) & is.null(data.path)){stop("please provide gwas summary data or path to gwas summary data")}
  if(is.null(data) & !is.null(data.path)){data = data.table::fread(data.path)}
  data = as.data.frame(data)
  std.data = data.frame(rsid = data[, RSID],
                        chr = data[, CHR],
                        pos = data[, POS],
                        ea = data[, EA],
                        nea = data[, NEA],
                        beta = data[, BETA],
                        se = data[, SE])
  ### Trait name
  std.data = std.data %>% dplyr::mutate(trait = TRAIT, .before = "rsid")
  ### P value and log10 P value
  std.data = std.data %>% dplyr::mutate(p = ifelse(!is.null(P), data[, P], NULL))
  std.data = std.data %>% dplyr::mutate(log10p = ifelse(!is.null(LOG10P), data[, LOG10P], NULL))
  ### Sample size
  std.data = std.data %>% dplyr::mutate(n = ifelse(!is.null(N), data[, N], NULL))
  ### EAF and MAF
  std.data = std.data %>% dplyr::mutate(eaf = ifelse(!is.null(EAF), data[, EAF], NULL), .after = nea)
  if(!is.null(MAF)){std.data = std.data %>% dplyr::mutate(maf = data[, MAF], .after = nea)}
  if(is.null(MAF) & !is.null(EAF)){std.data = std.data %>% dplyr::mutate(maf = ifelse(eaf<0.5, eaf, 1-eaf), .after = nea)}
  if(is.null(MAF) & is.null(EAF)){std.data = std.data %>% dplyr::mutate(maf = NULL, .after = nea)}
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