#' execute_do_file
#' @importFrom magrittr %>%
#'
execute_do_file<-function(path_to_do_file,log=FALSE) {
  if (is.null(options()$ottakring_stata_path)) options(ottakring_stata_path=find_stata_path())

  path_to_stata15<-options()$ottakring_stata_path

  if(Sys.info()["sysname"]=="Windows") {
    path_to_stata15<-path_to_stata15 %>%
      gsub("/","\\\\",.)
    path_to_do_file<-path_to_do_file %>%
      gsub("/","\\\\",.)
  }

  system2(path_to_stata15,args=c("/e","/q","do",path_to_do_file %>%
                                   paste0("\"",.,"\"")))
  if (!log) unlink(path_to_do_file %>%
                     gsub(".do",".log",.))
}

