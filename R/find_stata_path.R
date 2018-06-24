find_stata_path<-function() {
  lookfor<-glob2rx("Stata*.exe")

  stata_folder<-c(list.dirs("C:/Program Files/",),
    list.dirs("C:/Program Files (x86)/"))
  stata_folder<-stata_folder[grepl("Stata",stata_folder)]
  newest_version<-suppressWarnings(strsplit(stata_folder,"Stata") %>%
    sapply(function(x) x[2]) %>%
    substr(1,2) %>%
    as.numeric) %>% max(na.rm = TRUE)
  stata_folder<-stata_folder[grepl(paste0("Stata",newest_version),stata_folder)]
  stata_folder<-stata_folder[grepl(paste0("Stata",newest_version,"$"),stata_folder)]
  stata_file<-list.files(stata_folder,full.names = TRUE,pattern = glob2rx(paste0("Stata*.exe$")))
  stata_file<-stata_file[!grepl("_old.exe",stata_file)] %>%
    gsub(".exe","",.)
  if (stata_file %>% length==0) stop("Stata file could not be found. Please set Stata path manually .")
  stata_file
}
