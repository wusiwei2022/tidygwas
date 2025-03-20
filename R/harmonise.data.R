#' To harmonise 2 GWAS summary data
#' 
#' Harmonise 2 GWAS summary data primarily for conventional coloc analysis.
#' By default, the RSID, EA, and NEA will be referred to the first data set.
#' @param data.a The 1st gwas summary data you want to harmonise. 
#'               We recommend to format the gwas data with 'format.data' function in 'tidygwas' pcakge. 
#'               Column trait, rsid, ea, and nea must be available in the gwas summary while eaf is optional. 
#' @param data.b The 2nd gwas summary data you want to harmonise.
#'               We recommend to format the gwas data with 'format.data' function in 'tidygwas' pcakge. 
#'               Column trait, rsid, ea, and nea must be available in the gwas summary while eaf is optional. 
#' @return A harmonised data with 2 gwas summary data.
#' @export
harmonise.coloc.data = function(data.a, data.b){
  if("trait" %in% names(data.a) & "trait" %in% names(data.b)){
    trait.a = unique(data.a$trait)
    trait.b = unique(data.b$trait)}
  else{
    stop("trait should be available in both 2 gwas dataset")
  }
  ## Check rsid, ea, and nea 
  if(!{"rsid" %in% names(data.a)} | !{"ea" %in% names(data.a)} | !{"nea" %in% names(data.a)}){
    stop("rsid, ea, and nea must be provided in the 1st GWAS summary to harmonise")}
  if(!{"rsid" %in% names(data.b)} | !{"ea" %in% names(data.b)} | !{"nea" %in% names(data.b)}){
    stop("rsid, ea, and nea must be provided in the 2nd GWAS summary to harmonise")}
  ## Message
  message(paste0("harmonise ", trait.a, " and ", trait.b))
  ## merge trait 1 and trait 2
  data.a = data.a[ ,c("rsid", names(data.a)[names(data.a) != "rsid"])]
  data.b = data.b[ ,c("rsid", names(data.b)[names(data.b) != "rsid"])]
  colnames(data.a)[2:length(colnames(data.a))] = paste0(colnames(data.a)[2:length(colnames(data.a))], ".a")
  colnames(data.b)[2:length(colnames(data.b))] = paste0(colnames(data.b)[2:length(colnames(data.b))], ".b")
  coloc.data = inner_join(data.a, data.b, by = c("rsid" = "rsid"))
  ## harmonise the beta in reference to the allele
  ### subset of data where both effect allele and non-effect allele in trait 1 and trait b match 
  coloc.data.1 = coloc.data %>% filter(ea.a == ea.b & nea.a == nea.b)
  coloc.data.1 = coloc.data.1 %>% mutate(ea = ea.a, nea = nea.a, .after = rsid) %>% select(-c("ea.a", "nea.a", "ea.b", "nea.b"))
  ### subset of data where effect allele in trait 1 matches non-effect allele in trait b and non-effect allele in trait 1 matches effect allele in trait 2  
  coloc.data.2 = coloc.data %>% filter(ea.a == nea.b & nea.a == ea.b)
  if("beta.b" %in% names(coloc.data.2)){coloc.data.2 = coloc.data.2 %>% mutate(beta.b = - beta.b)}
  if("z.b" %in% names(coloc.data.2)){coloc.data.2 = coloc.data.2 %>% mutate(z.b = - z.b)}
  if("eaf.b" %in% names(coloc.data.2)){coloc.data.2 = coloc.data.2 %>% mutate(eaf.b = 1-eaf.b)}
  coloc.data.2 = coloc.data.2 %>% mutate(ea = ea.a, nea = nea.a, .after = rsid) %>% select(-c("ea.a", "nea.a", "ea.b", "nea.b"))
  ### combine harmonised data
  coloc.data.12 = rbind(coloc.data.1, coloc.data.2)
  ### subset of data where effect allele or non-effect allele are incompatible
  coloc.data.3 = coloc.data %>% filter(!{rsid %in% coloc.data.12$rsid})
  
  if(dim(coloc.data.3)[1] > 0){message(paste0(dim(coloc.data.3)[1], " variants have incompatible effect allele and non-effect allele"))}
  ### output
  return(coloc.data.12)
}

#' To harmonise across 3 GWAS summary data
#' 
#' Harmonise across 3 GWAS summary data primarily for multi-trait colocalization analysis.
#' By default, the RSID, EA, and NEA will be referred to the first data set.
#' 
#' @param data.a The first gwas summary data set you want to harmonise. Trait, rsid, ea, and nea must be available in the gwas summary while eaf is optional. 
#' @param data.b The second gwas summary data set you want to harmonise. Trait, rsid, ea, and nea must be available in the gwas summary while eaf is optional.
#' @param data.c The second gwas summary data set you want to harmonise. Trait, rsid, ea, and nea must be available in the gwas summary while eaf is optional.
#' @return A harmonised data with 3 gwas summary data.
#' @export
harmonise.moloc.data = function(data.a, data.b, data.c){
  # if("trait" %in% names(data.a) & "trait" %in% names(data.b) & "trait" %in% names(data.c)){
  #   trait.a = unique(data.a$trait)
  #   trait.b = unique(data.b$trait)
  #   trait.c = unique(data.c$trait)
  #   message(paste0("harmonise ", trait.a, " ", trait.b, ", and ", trait.c))
  #   }
  # else{
  #   stop("trait should be available in all the 3 gwas dataset")
  # }
  ## harmonise trait.a and trait.b
  coloc.data.ab = harmonise.coloc.data(data.a, data.b)
  ## harmonise trait.a and trait.c
  coloc.data.ac = harmonise.coloc.data(data.a, data.c)
  colnames(coloc.data.ac) = gsub(".b", ".c", colnames(coloc.data.ac))
  ## merge data.ab with data.ac
  coloc.data.abc = inner_join(coloc.data.ab, coloc.data.ac)
  ## output
  return(coloc.data.abc)
}