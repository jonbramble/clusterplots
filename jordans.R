#needs adjusting for your local data directory
#windows uses \\ for dir in R
data_dir = "/media/mbajb/data/Experimental/Confocal/Jordan/Analysis Results"

exp_dirs = dir(data_dir,pattern="^JBE")   #loads directories beginning JBE, change accordingly here
for (i in 1:length(exp_dirs)){
  path = paste(data_dir,exp_dirs[i],sep="/")   #creates a path for each directory
  data.sources = list.files(path,pattern="*.csv",full.names=TRUE)   #loads up all the csv files from IJ program
  dat <- lapply(data.sources,read.csv)    #reads all the csv files
  imgdat <- do.call(rbind, dat)           #binds all the csv files for that dir
  code = exp_dirs[i]
  assign(exp_dirs[i],imgdat)              #assigns the data a variable name
  
  save_file_name <- paste(code,".rda",sep="")     #saves the aggregated data as rda files for loading later
  save_file_path <- paste(data_dir,"RDA",save_file_name,sep="/")    # you need a dir called RDA for the output
  save(list = code ,file=save_file_path)
}
