#' reduce_data_and_temp_folder
#' @importFrom magrittr %>%

reduce_data_and_temp_folder<-function(data#,mean_var,over,subpop=NA,svyset=NULL
                                      ) {
  # create random folder
  temp_folder<-paste0(sample(c(letters,LETTERS,0:9),10),collapse="")
  while(dir.exists(temp_folder)) temp_folder<-
      paste0(sample(c(letters,LETTERS,0:9),10),collapse="")
  dir.create(temp_folder)

  # # shorten data to only necessary vars:
  # vars<-svyset
  # remove<-c("svyset","fpc(","_n","singleunit(",
  #           "poststrata(","postweight(","strata(","scaled)")
  # for (i in seq_len(length(remove))) vars<-
  #   vars %>% gsub(remove[i],"",.,fixed=TRUE)
  #
  # svyset_vars<-vars %>%
  #   gsub("[[:punct:]]","",.) %>%
  #   strsplit(" ") %>%
  #   unlist %>%
  #   data.frame(r=.) %>%
  #   filter(r!="") %>%
  #   unlist
  #
  # if (!is.na(subpop)) {
  #   subpop_var<-subpop %>%
  #     unlist %>%
  #     strsplit("=") %>%
  #     unlist %>%
  #     strsplit("!") %>%
  #     unlist %>%
  #     data.frame(r=.) %>%
  #     slice(1) %>%
  #     unlist
  #   keep_vars<-c(svyset_vars,subpop_var,mean_var,over)
  #
  # } else {
  #   keep_vars<-c(svyset_vars,mean_var,over)
  #
  # }
  #
  #
  # data<-data[,keep_vars]
  #


  # save data in that folder
  data.table::fwrite(data,paste0(temp_folder,"/data.csv"),na=".")
  return(temp_folder)
}
