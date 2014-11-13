#dir = "/media/mbajb/My Passport/Jonathan/Nottingham/PC + PYRONE ZE 051114"
dir = "~/Data/Confocal/PC_PYRONE_ET_281014"
experiment = "PYExp12"
code = "PYE4002"
datadir = "processed"
setwd(paste(dir,experiment,datadir,sep="/"))
filepath = paste(dir,experiment,datadir,code,sep="/")

data.sources = list.files(pattern="*.csv")
dat <- lapply(data.sources,read.csv)
imgdat <- do.call(rbind, dat)

assign(code,imgdat)

save_file_name <- paste(code,".rda",sep="")
save_file_path <- paste(dir,save_file_name,sep="/")
save(list = code ,file=save_file_path)
