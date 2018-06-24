#' svy_mean
#' @importFrom magrittr %>%

svy_mean<-function(data,
                        mean_var,
                        over,
                        recodes=NA,
                        subpop=NA,
                        svyset=NA
) {
  if (is.na(svyset)) stop("No svyset specified.")


  temp_folder<-reduce_data_and_temp_folder(data,mean_var,over,subpop,svyset)

  # create beginning of do file
  do_file_step1<-c(paste0("clear all\nset maxvar 32000\nset more off\nglobal path \"",getwd(),"/",temp_folder,"/\""),
                   "import delimited \"${path}data.csv\", delimiter(comma) bindquote(strict) varnames(1) case(preserve) clear",
                   svyset)
  if (!is.na(recodes)) do_file_step1<-c(do_file_step1,recodes)
  do_file<-c(do_file_step1,
             "program def write_mean_table\n	if  (missing(\"`3'\")) {\n		capture svy: mean `1', over(`2')\n	}\n	else {\n		capture svy, subpop(if `3'): mean `1', over(`2')\n	}\nif !_rc {\n	mat A = r(table)\n	mat2txt, matrix(A) saving(\"${path}/`1'_over_`2'.txt\") replace\n} \nelse {\nlocal errorm = _rc\nfile open out1 using `\"${path}/`1'_over_`2'.txt\"', w replace\nfile write out1 \"errorcode: `errorm'\"\nfile close out1\n}\nend\n")
  if (is.na(subpop)) {
    do_file<-c(do_file,paste("write_mean_table",mean_var,over))
  } else {
    do_file<-c(do_file,paste("write_mean_table",mean_var,over,subpop))
  }
  do_file2<-paste0(do_file,collapse="\n")


  # write do file
  file1<-file(paste0(temp_folder,"/do_file.do"))
  writeLines(iconv(do_file2,"latin1","UTF-8"),file1,useBytes = FALSE)
  #write(do_file2,file1)
  close(file1)

  # execute do file
  execute_do_file(path_to_do_file = paste0(getwd(),"/",temp_folder,"/do_file.do"))

  # read in results
  if (!file.exists(paste0(temp_folder,"/",mean_var,"_over_",over,".txt"))) {
    # clean up
    unlink(paste0(getwd(),"/",temp_folder),force = TRUE,recursive = TRUE)

    stop("Execution failed. No Errorcode in Stata generated. Was the do file execute in Stata?")
  }

  check_error<-readLines(paste0(temp_folder,"/",mean_var,"_over_",over,".txt"),warn=FALSE)
  if (check_error %>% length==1&grepl("errorcode: ",check_error[1])) {
    # clean up
    unlink(paste0(getwd(),"/",temp_folder),force = TRUE,recursive = TRUE)

    stop(paste("Execution failed. Stata returns errorcode",check_error[1] %>% gsub("errorcode: ","",.)))

  }
  tab<-read.table(paste0(temp_folder,"/",mean_var,"_over_",over,".txt"))

  # clean up
  unlink(paste0(getwd(),"/",temp_folder),force = TRUE,recursive = TRUE)

  # results to table
  tab<-tab %>%
    t %>%
    as.data.frame()
  tab$var<-row.names(tab) %>%
    gsub(mean_var,"",.) %>%
    gsub(".","",.,fixed=TRUE)
  tab %>%
    dplyr::select(var,b,se,t,pvalue)

  #
}


