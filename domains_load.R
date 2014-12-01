
data_dir = "/media/mbajb/data/Experimental/Confocal/PC_PYRONE_ET_281014"
#data_dir = "/media/mbajb/data/Experimental/Confocal/PC_PYRONE_ZE_051114"

source('~/Programming/R/clusterplot/config.R')
source('~/Programming/R/clusterplot/compound.R')

source('~/Programming/R/clusterplot/exp_match.R')
processed="processed"
exp_dirs = dir(data_dir,pattern="^PY")

for (i in 1:length(exp_dirs)){
  experiment <- exp_dirs[i]
  code = sample_match(experiment)
  path = paste(data_dir,experiment,processed,sep="/")
  data.sources = list.files(path,pattern="*.csv",full.names=TRUE)
  dat <- lapply(data.sources,read.csv)
  imgdat <- do.call(rbind, dat)
  
  assign(code,imgdat)
  
  save_file_name <- paste(code,".rda",sep="")
  save_file_path <- paste(data_dir,"RDA",save_file_name,sep="/")
  save(list = code ,file=save_file_path)
  
}


