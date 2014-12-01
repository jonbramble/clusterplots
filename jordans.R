data_dir = "/media/mbajb/data/Experimental/Confocal/Jordan/Analysis Results"

exp_dirs = dir(data_dir,pattern="^JBE")
for (i in 1:length(exp_dirs)){
  path = paste(data_dir,exp_dirs[i],sep="/")
  data.sources = list.files(path,pattern="*.csv",full.names=TRUE)
  dat <- lapply(data.sources,read.csv)
  imgdat <- do.call(rbind, dat)
  code = exp_dirs[i]
  assign(exp_dirs[i],imgdat)
  
  save_file_name <- paste(code,".rda",sep="")
  save_file_path <- paste(data_dir,"RDA",save_file_name,sep="/")
  save(list = code ,file=save_file_path)
}
