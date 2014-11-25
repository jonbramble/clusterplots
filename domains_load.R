dir = "/media/mbajb/My Passport/Jonathan/Nottingham/common"
#dir = "~/Data/Confocal/PC_PYRONE_ET_281014"
experiment = "PYExp20"
code = "PYZ4003"
datadir = "processed"
filepath = paste(dir,experiment,datadir,code,sep="/")

data.sources = list.files(paste(dir,experiment,datadir,sep="/"),pattern="*.csv",full.names=TRUE)
dat <- lapply(data.sources,read.csv)
imgdat <- do.call(rbind, dat)

assign(code,imgdat)

save_file_name <- paste(code,".rda",sep="")
save_file_path <- paste(dir,save_file_name,sep="/")
save(list = code ,file=save_file_path)
