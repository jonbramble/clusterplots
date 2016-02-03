library(ggplot2)
library(plyr)
library(reshape2)

#assumes a single dir containing dirs with each lei file and a processed dir
#path in windows must be escaped c://path//to//folder

#data_dir <- "/media/mbzjpb/data/Experimental/Confocal/PolyQ"
data_dir <- "E:\\Confocal Data\\Processed Data\\FPE_PC_NaSCN\\processed"
#get all the directories in this folder
data_dirs <- list.files(data_dir)  
#construct a file path to the processed dir
#data_processed_dirs <- file.path(data_dir,data_dirs,"processed")
#find all the files with ending *.csv, to exclude, rename the ending or delete the csv file
#data.sources <- list.files(data_processed_dirs,pattern="*.csv",full.names=TRUE)
data.sources <- list.files(data_dir,pattern="*.csv",full.names=TRUE)
#read in all the data and convert to a dataframe - this is potentially slow - it might break here if
#there are csv files with the wrong names or missing columns
df_all <- data.frame(do.call("rbind", lapply(data.sources,read.csv,header=TRUE)))

df_filter <- subset(df_all,Area > 1)       # ### !!!! prefilter here of all tiny domains !!!! ####
df_pbs <- subset(df_filter,media == 'PBS') 
df_nascn <- subset(df_filter,media == 'NaSCN') 

count(df_pbs$lipid)
count(df_nascn$lipid)

#plotting

#m <- ggplot(data=subset(df_filter,Lipid=="PC"),aes(x=Area,fill=factor(Lipid)))
#m + geom_bar(position="dodge",binwidth=1) + xlim(0,50) + theme_minimal(base_size = 24)

m <- ggplot(data=df_pbs,aes(x=Area,fill=factor(lipid)))
m + geom_bar(position="dodge",binwidth=2) + xlim(0,20) + theme_minimal(base_size = 24)

n <- ggplot(data=df_nascn,aes(x=Area,fill=factor(lipid)))
n + geom_bar(position="dodge",binwidth=2) + xlim(0,20) + theme_minimal(base_size = 24)

p <- n + geom_density(alpha=0.3) + xlim(0,20) + ylim(0,0.5) + theme_minimal(base_size = 24)
q <- m + geom_density(alpha=0.3) + xlim(0,20) + ylim(0,0.5) + theme_minimal(base_size = 24)
p
q
