#rm(list = ls())
library(ggplot2)
library(plyr)
source('~/Programming/R/clusterplot/config.R')
source('~/Programming/R/clusterplot/compound.R')
source('~/Programming/R/clusterplot/exp_match.R')

dir = "/media/mbajb/My Passport/Jonathan/Nottingham/common"
data.sources = list.files(dir,pattern="*.rda")
full_path_sources = paste(dir,data.sources,sep="/")
sapply(full_path_sources,load,.GlobalEnv)

lfiles <- as.list(ls(pattern="^PY")) #convert the list of rda files to an R list of names
lnames <- lapply(lfiles,as.name)
ldat <- lapply(lnames,eval)

PYA <- do.call(rbind,ldat)
PYA <- PYA[order(PYA$Experiment),]
save(PYA,file="PYA.rda")

chart.binwidth <- 1
chart.title <- paste("Domain Area")

#process names to fill in the extra columns
PYA$Compound <- substr(PYA$Experiment,3,3) #extract from string
codes <- as.integer(substr(PYA$Experiment,4,4))
PYA$Sample <- as.integer(substr(PYA$Experiment,7,7))  #get the sample number
PYA$Amount <- sapply(codes,compound)  #compound function converts to correct amount
PYA$Session <- sapply(PYA$Experiment,exp_match) #find the session from the experiment name from config array
PYA$ImageCode <- paste(PYA$Experiment,PYA$Batch,sep="-") #create unique image code

dis <- as.data.frame(table(PYA$ImageCode), responseName="Count")
colnames(dis) <- c("ImageName","Count")
dis$Session <- sapply(dis$ImageName,session_match)
dis$path <- paste(paste('"',paste(dir,dis$Session,'processed',paste(dis$ImageName,'-mask"',sep=''),sep='/'),sep=''),"png",sep=".")


p <- ggplot(data=PYA,aes(x=Area,fill=factor(Amount)))
p + geom_bar(position="dodge",binwidth=chart.binwidth) + xlim(0, 50) + ylab("Count") + xlab(expression(paste("Area, ",um^2))) +labs(title = chart.title) + theme_minimal(base_size = 20) +labs(title = chart.title) 

