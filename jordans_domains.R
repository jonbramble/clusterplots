library(ggplot2)

data_dir = "/media/mbajb/data/Experimental/Confocal/Jordan/Analysis Results/RDA"

data.sources = list.files(data_dir,pattern="*.rda",full.names=TRUE)
sapply(data.sources,load,.GlobalEnv)

lfiles <- as.list(ls(pattern="^JBE")) #convert the list of rda files to an R list of names
#lnames <- lapply(lfiles,as.name)

myload <- function(file) { 
  dat <- data.frame(eval(as.name(file)))
  dat$name <- unlist(rep(file,nrow(dat)))
  return(dat)
}


ldat <- lapply(lfiles,myload)

# need to add an extra column to all to id the experiment


PYAll <- data.frame(do.call(rbind,ldat))
PYA <- subset(PYAll,Area > 1)       # prefilter here

lvls <- levels(PYA$Experiment)

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

PYA$Image <- factor(PYA$Image)
levels(PYA$Image)

PYA$Sample <- factor(PYA$Sample)
levels(PYA$Sample)

lvls <- levels(PYA$Experiment)


m <- ggplot(data=PYA,aes(x=Area,fill=name))
m + geom_bar(position="dodge",binwidth=2) + xlim(0,100 )

