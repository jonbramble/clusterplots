library(ggplot2)

source('~/Programming/R/clusterplot/jordans_config.R')
#needs adjusting for your local data directory
data_dir = "/media/mbajb/data/Experimental/Confocal/Jordan/Analysis Results/RDA"

#find all the rda files in the data_dir directory
data.sources = list.files(data_dir,pattern="*.rda",full.names=TRUE)
sapply(data.sources,load,.GlobalEnv)  #load these up

lfiles <- as.list(ls(pattern="^JBE")) #convert the list of rda files to an R list of names

#adds the name of the folder to a column in the data for id later
myload <- function(file) { 
  dat <- data.frame(eval(as.name(file)))
  dat$name <- unlist(rep(file,nrow(dat)))
  return(dat)
}

ldat <- lapply(lfiles,myload)
PYAll <- data.frame(do.call(rbind,ldat))
PYA <- subset(PYAll,Area > 1)       # ### !!!! prefilter here of all tiny domains !!!! ####

### fidle with name strings ###
trim.leading <- function (x)  sub("^\\s+", "", x)
trim.backticks <- function (x) sub("`","", x)
split.type <- function (x) unlist(strsplit(as.character(x),"-"))[1]
split.sample <- function (x) unlist(strsplit(as.character(x),"-"))[2]
split.image <- function (x) unlist(strsplit(as.character(x),"-"))[3]

correct.type <- function(x) {
  cor = sub("Pc", "PC", x)  # correct small c
  cor = sub("PCCC", "PCC", cor)  # correct repeated Cs
  cor = sub("CHol", "Chol", cor)  # correct capital Hs
  cor = sub("SM", "Sm", cor)  # correct capital SM
  return(cor)
}

PYA$Experiment <- factor(sapply(PYA$Experiment,trim.backticks))
PYA$Type <- sapply(PYA$Experiment,split.type)
PYA$Type <- sapply(PYA$Type,correct.type)
PYA$Sample <- sapply(PYA$Experiment,split.sample)
PYA$Image <- sapply(PYA$Experiment,split.image)
PYA$Description <- sapply(PYA$name,match.sample)
PYA$Dye <- sapply(PYA$name,match.dye)

#data subsets
LeedsFPE <- subset(PYA,name=="JBE0001")   #subset the data here for each exp
LeedsDi8 <- subset(PYA,name=="JBE0005")

PYA <- subset(PYA,Description!= "Leeds")   


#plotting
m <- ggplot(data=subset(PYA,Dye=="FPE"),aes(x=Area,fill=factor(Description)))
m + geom_bar(position="dodge",binwidth=1) + theme_minimal(base_size = 24) + xlim(0,50) + scale_y_log10()

md <- ggplot(data=subset(PYA,Dye=="Di8"),aes(x=Area,fill=factor(Description)))
md + geom_bar(position="dodge",binwidth=1) + theme_minimal(base_size = 24) + xlim(0,50) + scale_y_log10()

n <- ggplot(data=LeedsFPE,aes(y=Area,x=factor(name),fill=factor(Type))) + coord_flip()
n + geom_boxplot() + scale_y_log10()+ theme_minimal(base_size = 24)

p <- ggplot(data=LeedsDi8,aes(y=Area,x=factor(Type))) + coord_flip()
p + geom_boxplot() + scale_y_log10()+ theme_minimal(base_size = 24)
