library(ggplot2)

data_dir = "/media/mbajb/data/Experimental/Confocal/Jordan/Analysis Results/RDA"
source('~/Programming/R/clusterplot/jordans_config.R')

data.sources = list.files(data_dir,pattern="*.rda",full.names=TRUE)
sapply(data.sources,load,.GlobalEnv)

lfiles <- as.list(ls(pattern="^JBE")) #convert the list of rda files to an R list of names

myload <- function(file) { 
  dat <- data.frame(eval(as.name(file)))
  dat$name <- unlist(rep(file,nrow(dat)))
  return(dat)
}

ldat <- lapply(lfiles,myload)
PYAll <- data.frame(do.call(rbind,ldat))
PYA <- subset(PYAll,Area > 1)       # prefilter here

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

LeedsFPE <- subset(PYA,name=="JBE0001")   #subset the data here for each exp
LeedsDi8 <- subset(PYA,name=="JBE0005")

PYA <- subset(PYA,Description!= "Leeds")   

m <- ggplot(data=subset(PYA,dye="FPE"),aes(x=Area,fill=factor(Description)))
m + geom_bar(position="dodge",binwidth=1) + theme_minimal(base_size = 24)

n <- ggplot(data=LeedsFPE,aes(y=Area,x=factor(name),fill=factor(Type))) + coord_flip()
n + geom_boxplot() + scale_y_log10()+ theme_minimal(base_size = 24)

p <- ggplot(data=LeedsDi8,aes(y=Area,x=factor(Type))) + coord_flip()
p + geom_boxplot() + scale_y_log10()+ theme_minimal(base_size = 24)
