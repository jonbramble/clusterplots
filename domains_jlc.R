rm(list = ls())
library(ggplot2)
library(vcd)
library(xtable)
library(plyr)

source('~/Programming/R/clusterplot/config_jlc.R')
source('~/Programming/R/clusterplot/exp_match.R')

trim.leading <- function (x)  sub("^\\s+", "", x)

dir = "/media/mbajb/data/Experimental/Confocal/DOPCSMChol 111214/RDA"
experiment = "JL"
data.sources = list.files(dir,pattern="*.rda",full.names=TRUE)
sapply(data.sources,load,.GlobalEnv)

lfiles <- as.list(ls(pattern="^JL")) #convert the list of rda files to an R list of names
lnames <- lapply(lfiles,as.name)
ldat <- lapply(lnames,eval)

JLAll <- do.call(rbind,ldat)
JLA <- subset(JLAll,Area > 1)

chart.binwidth <- 1
chart.title <- paste("Domain Area")

#process names to fill in the extra columns
JLA$Experiment <- sapply(JLA$Experiment,trim.leading)
JLA$Sample <- as.integer(substr(JLA$Experiment,7,7))  #get the sample number
JLA$Session <- sapply(JLA$Experiment,exp_match) #find the session from the experiment name from config array
JLA$Buffer <- sapply(JLA$Experiment,buffer_match) #find the session from the experiment name from config array
JLA$ImageCode <- paste(JLA$Experiment,JLA$Batch,sep="-") #create unique image code

#get the counts for data here
jlc.counts <- as.data.frame(count(JLA,c("Sample","Buffer","Batch")))
jlc.counts$freq <- NULL # this gets confusing
jlc.samplecount <- aggregate(Batch~Sample+Buffer,data=jlc.counts,FUN=length)
jlc.buffercount <- aggregate(Batch~Buffer,data=jlc.counts,FUN=length)

jlc_pbs <- subset(JLA,Buffer=="PBS")
jlc_nascn <- subset(JLA,Buffer=="NaSCN")
jlc_3g <- subset(JLA,Buffer=="3G")

#save data files for JL
file_name_pbs = paste(experiment,"pbs_data.csv",sep="_")
file_name_nascn = paste(experiment,"nascn_data.csv",sep="_")
file_name_3g = paste(experiment,"3g_data.csv",sep="_")
write.table(jlc_pbs,paste(dir,file_name_pbs,sep="/"),sep=",")
write.table(jlc_nascn,paste(dir,file_name_nascn,sep="/"),sep=",")
write.table(jlc_3g,paste(dir,file_name_3g,sep="/"),sep=",")

#par(mfrow=c(3,1))
#plot(jlc_pbs$Area,(jlc_pbs$ROIMean/255)*100)
#plot(jlc_nascn$Area,(jlc_nascn$ROIMean/255)*100)
#plot(jlc_3g$Area,(jlc_3g$ROIMean/255)*100)

xlab <- expression(paste("Area  ", mu, m^2))
ylab <- "Domain Mean Brightness %"
plot_limits <- c(2,1000)
ylim <- c(0,50)

ipe <- ggplot(data=JLA,aes(x=Area,y=(ROIMean/255)*100,color=factor(Buffer),shape=factor(Experiment))) 
ipe + geom_point(alpha=0.9) + scale_x_log10() + ylim(ylim) + theme_minimal(base_size = 24) + ylab(ylab) + xlab(xlab) + 
  scale_shape_manual(values = c(0,1,2,3,4,5,6,7)) 
file_name = paste(experiment,"buffer_area_mean.png",sep="_")
full_path = paste(dir,file_name,sep="/")
ggsave(full_path,width=12,height=8)

#anova
#layout(matrix(c(1,2,3,4),2,2)) # optional layout 
#fit <- aov(ROIMean ~ Area, data = jlc_nascn)
#plot(fit)

p <- ggplot(data=JLA,aes(x=Area,fill=factor(Buffer)))
p + geom_density(alpha=0.2) + xlim(0, 100) + xlab(xlab) + labs(title = chart.title) + theme_minimal(base_size = 24) + 
  scale_fill_discrete(name = "Buffer")
file_name = paste(experiment,"buffer_kernel_density.png",sep="_")
full_path = paste(dir,file_name,sep="/")
ggsave(full_path,width=8,height=8)

p + geom_bar(position="dodge",binwidth=0.5) + xlim(0, 25) + xlab(xlab) +labs(title = chart.title) + theme_minimal(base_size = 24) + 
  scale_fill_discrete(name = "Buffer")
file_name = paste(experiment,"buffer_histogram.png",sep="_")
full_path = paste(dir,file_name,sep="/")
ggsave(full_path,width=8,height=8)

r <- ggplot(data=JLA,aes(y=Area,x=factor(Buffer),fill=factor(Buffer))) + coord_flip()
r + geom_boxplot() + scale_y_log10()+ theme_minimal(base_size = 24) + ylab(xlab) + xlab("Buffer") + scale_fill_discrete(name = "Buffer")
file_name = paste(experiment,"buffer_box_plot.png",sep="_") 
full_path = paste(dir,file_name,sep="/")
ggsave(full_path,width=10,height=10)


q <- ggplot(data=JLA,aes(x=Circ.,fill=factor(Buffer)))
q + geom_bar(position="dodge",binwidth=0.05) + xlim(0, 1) + xlab(xlab) +labs(title = chart.title) + theme_minimal(base_size = 24) + 
  scale_fill_discrete(name = "Buffer")
file_name = paste(experiment,"buffer_circ.png",sep="_")
full_path = paste(dir,file_name,sep="/")
ggsave(full_path,width=8,height=8)
