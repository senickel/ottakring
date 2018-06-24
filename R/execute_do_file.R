#' execute_do_file
#' @importFrom magrittr %>%
#'
execute_do_file<-function(path_to_do_file,log=FALSE) {
  path_to_stata15<-"C:/Program Files (x86)/Stata15/StataSE-64" %>%
    gsub("/","\\\\",.)

  system2(path_to_stata15,args=c("/e","/q","do",path_to_do_file %>%
                                   gsub("/","\\\\",.) %>%
                                   paste0("\"",.,"\"")))
  if (!log) unlink(path_to_do_file %>%
                     gsub(".do",".log",.))
}

