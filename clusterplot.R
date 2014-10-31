library(ggplot2)

experiment = "PYT4001"
dir = "~/Data/Confocal/PC + PYRONE ET 281014/PYExp10/processed/"

file_root = paste(dir,"AVG_PYExp10.lei - ",sep = "")
file_name = paste(file_root,experiment,sep = "")

#imgdat <- list()
imgdat1 <- read.csv(paste(file_name,"-1-dat.csv",sep = ""))
imgdat2 <- read.csv(paste(file_name,"-2-dat.csv",sep = ""))
imgdat3 <- read.csv(paste(file_name,"-3-dat.csv",sep = ""))
imgdat4 <- read.csv(paste(file_name,"-4-dat.csv",sep = ""))
imgdat5 <- read.csv(paste(file_name,"-5-dat.csv",sep = ""))
imgdat6 <- read.csv(paste(file_name,"-6-dat.csv",sep = ""))
imgdat7 <- read.csv(paste(file_name,"-7-dat.csv",sep = ""))

#imgdat <- do.call(rbind, list(imgdat1,imgdat2,imgdat3,imgdat4,imgdat5,imgdat6))
imgdat <- do.call(rbind, list(imgdat1,imgdat2,imgdat3,imgdat4,imgdat5,imgdat6,imgdat7))

imgframe <- data.frame(imgdat)

chart.binwidth <- 1
chart.title <- paste("Domain Area",experiment)

p <- ggplot(data=imgframe,aes(x=Area))
p + geom_histogram(binwidth=chart.binwidth) + xlab(expression(paste("Area, ",um^2))) +labs(title = chart.title) + theme_minimal(base_size = 16) +labs(title = chart.title) 
file_name = paste(experiment,"area.png")
full_path = paste(dir,file_name)
ggsave(full_path)


chart.title <- paste("Domain Feret Diameter",experiment)
q <- ggplot(data=imgframe,aes(x=Feret))
q + geom_histogram(binwidth=chart.binwidth) + xlab(expression(paste("Feret Diameter, ",um))) +labs(title = chart.title) + theme_minimal(base_size = 16) +labs(title = chart.title)
file_name = paste(experiment,"feret.png")
full_path = paste(dir,file_name)
ggsave(full_path)