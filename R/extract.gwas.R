#' @export
extract.data = function(data.path, 
                        data.type = c(".txt", ".txt.gz"), 
                        extract.by = c("ID", "Coord"), 
                        id.index, 
                        ref.id, 
                        chr.index, 
                        pos.index,
                        chr,
                        pos.lower,
                        pos.upper){
  if(!{extract.by %in% c("ID", "Coord")}){stop("Please clarify how GWAS summary data should be extracted, either by ID (e.g. RSID) or Coordinate")}
  if(extract.by == "ID"){
    # Extract data by ID
    ## Check if all the IDs are RSIDs
    if(all(startsWith(ref.id, "rs"))){message("all the IDs are rsid")}else{warning("Not all the IDs are rsid")}
    ## Create a temporary file to save the IDs to match
    fn = tempfile()
    write.table(data.frame(ref.id), file=fn, row.names=FALSE, col.names=FALSE, quote=FALSE)
    ## Extract data matched to the RSID
    cmd = case_when(data.type == ".txt" ~ paste0("awk 'NR==FNR {AssoArray[$1]=$1; next} $", id.index, " in AssoArray {print $0}' ", fn, " ", data.path), 
                    data.type == ".txt.gz" ~ paste0("zcat ", data.path, " | awk 'NR==FNR {AssoArray[$1]=$1; next} $", id.index, " in AssoArray {print $0}' ", fn, " -")
    )
    data = read.table(pipe(cmd))
    cmd_header = case_when(data.type == ".txt" ~ paste0("head -n1 ", data.path),
                           data.type == ".txt.gz" ~ paste0("zcat ", data.path, " | head -n1")
    )
    data.header = read.table(pipe(cmd_header), header = TRUE) # Extract header from the raw data
    colnames(data) = colnames(data.header)
    return(data)
  }else{
    # Extract data by coordinate
    cmd = case_when(data.type == ".txt" ~ paste0("awk 'NR==1 || (($", chr.index, "==", chr, " && $", pos.index, ">", pos.lower, " && $", pos.index, "<", pos.upper, "))' ", data.path),
                    data.type == ".txt.gz" ~ paste0("zcat ", data.path, " | awk 'NR==1 || (($", chr.index, "==", chr, " && $", pos.index, ">", pos.lower, " && $", pos.index, "<", pos.upper, "))'")
    )
    data = read.table(pipe(cmd), header = TRUE)
    return(data)
  }
}