library(ggplot2)
rm(list = ls())
dir = "/media/mbajb/My Passport/Jonathan/Nottingham/PC + PYRONE ZE 051114"
setwd(dir)
data.sources = list.files(pattern="*.rda")
sapply(data.sources,load,.GlobalEnv)

lfiles <- as.list(ls(pattern="^PY")) #convert the list of rda files to an R list of names
lnames <- lapply(lfiles,as.name)
ldat <- lapply(lnames,eval)

PYA <- do.call(rbind,ldat)


chart.binwidth <- 1
chart.title <- paste("Domain Area")

p <- ggplot(data=PYA,aes(x=Area,fill=Experiment))
p + geom_bar(binwidth=chart.binwidth) + xlim(0, 100) + ylab("Count") + xlab(expression(paste("Area, ",um^2))) +labs(title = chart.title) + theme_minimal(base_size = 20) +labs(title = chart.title) 

ar <- PYA$Area
