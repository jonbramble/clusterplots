rm(list = ls())
library(ggplot2)
library(vcd)
library(xtable)
library(plyr)

source('~/Programming/R/clusterplot/config.R')
source('~/Programming/R/clusterplot/compound.R')
source('~/Programming/R/clusterplot/exp_match.R')

trim.leading <- function (x)  sub("^\\s+", "", x)

dir = "/media/mbajb/data/Experimental/Confocal/common/RDA"
experiment = "PY"
data.sources = list.files(dir,pattern="*.rda",full.names=TRUE)
sapply(data.sources,load,.GlobalEnv)

lfiles <- as.list(ls(pattern="^PY")) #convert the list of rda files to an R list of names
lnames <- lapply(lfiles,as.name)
ldat <- lapply(lnames,eval)

PYAll <- do.call(rbind,ldat)
PYA <- subset(PYAll,Area > 1)
#PYA <- PYA[order(PYA$Experiment),]
#save(PYA,file=paste(dir,"PYA.rda",sep="/"))

chart.binwidth <- 1
chart.title <- paste("Domain Area")

#process names to fill in the extra columns
PYA$Experiment <- sapply(PYA$Experiment,trim.leading)
PYA$Compound <- substr(PYA$Experiment,3,3) #extract from string
codes <- as.integer(substr(PYA$Experiment,4,4))
PYA$Sample <- as.integer(substr(PYA$Experiment,7,7))  #get the sample number
PYA$Amount <- sapply(codes,compound)  #compound function converts to correct amount
PYA$Session <- sapply(PYA$Experiment,exp_match) #find the session from the experiment name from config array
PYA$ImageCode <- paste(PYA$Experiment,PYA$Batch,sep="-") #create unique image code

#get the counts for data here
pya.counts <- as.data.frame(count(PYA,c("Amount","Sample","Compound","Batch")))
pya.counts$freq <- NULL # this gets confusing
pya.samplecount <- aggregate(Batch~Sample+Amount+Compound,data=pya.counts,FUN=length)
pya.compoundsamplecount <- aggregate(Batch~Amount+Compound,data=pya.counts,FUN=length)
pya.amountcount <- aggregate(Batch~Amount,data=pya.counts,FUN=length)
pya.compoundcount <- aggregate(Batch~Compound,data=pya.counts,FUN=length)

#select_amount <- "10"
pye <- subset(PYA,Compound=="E")
pyt <- subset(PYA,Compound=="T")
pyz <- subset(PYA,Compound=="Z")


par(mfrow=c(3,1))
plot(pye$Area,(pye$ROIMean/255)*100)
plot(pyt$Area,(pyt$ROIMean/255)*100)
plot(pyz$Area,(pyz$ROIMean/255)*100)

xlab <- expression(paste("Area  ", mu, m^2))
ylab <- "Domain Mean Brightness %"
plot_limits <- c(2,1000)
ylim <- c(0,50)

ipe <- ggplot(data=pye,aes(x=Area,y=(ROIMean/255)*100,shape=factor(Experiment),color=factor(Amount))) 
ipe + geom_point(alpha=0.9) + scale_x_log10() + ylim(ylim) + theme_minimal(base_size = 24) + ylab(ylab) + xlab(xlab) +labs(title = "Compound E")  +
  scale_shape_manual(values = c(0,1,2,3,4,5,6,7,8)) 
file_name = paste(experiment,"compound_e_area_mean.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=12,height=8)

ipt <- ggplot(data=pyt,aes(x=Area,y=(ROIMean/255)*100,shape=factor(Experiment),color=factor(Amount)))
ipt + geom_point(alpha=0.9) + scale_x_log10() + ylim(ylim) + theme_minimal(base_size = 24) + ylab(ylab) + xlab(xlab) +labs(title = "Compound T")
file_name = paste(experiment,"compound_t_area_mean.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=12,height=8)

ipz <- ggplot(data=pyz,aes(x=Area,y=(ROIMean/255)*100,shape=factor(Experiment),color=factor(Amount)))
ipz + geom_point(alpha=0.9) + scale_x_log10() + ylim(ylim) + theme_minimal(base_size = 24) + ylab(ylab) + xlab(xlab) +labs(title =  "Compound Z")
file_name = paste(experiment,"compound_z_area_mean.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=12,height=8)

layout(matrix(c(1,2,3,4),2,2)) # optional layout 
fit <- aov(ROIMean ~ Area*Amount, data = pye)
plot(fit)
par(mfrow=c(1,1))

#cumulative thingy
# edcf_pye <- ecdf(pye$Area)
# edcf_pyt <- ecdf(pyt$Area)
# edcf_pyz <- ecdf(pyz$Area)
# par(mfrow=c(3,1))
# plot(edcf_pye,xlim=c(0,100))
# plot(edcf_pyt,xlim=c(0,100))
# plot(edcf_pyz,xlim=c(0,100))
# 
# img_size = 238
# total_area_pye <- pya.compoundcount[1,2]*img_size^2
# total_area_pyt <- pya.compoundcount[2,2]*img_size^2
# total_area_pyz <- pya.compoundcount[3,2]*img_size^2
# 
# #find the total fraction taken up by all the domains for each compound
# fraction_pye <- sum(pye$Area)/total_area_pye 
# fraction_pyt <- sum(pyt$Area)/total_area_pyt 
# fraction_pyz <- sum(pyz$Area)/total_area_pyz 
# 
# normalised_pye <- (total_area_pye-sort(pye$Area))
# normalised_pyt <- (total_area_pyt-sort(pyt$Area))
# normalised_pyz <- (total_area_pyz-sort(pyz$Area))
# 
# par(mfrow=c(3,1))
# plot(normalised_pye,type="l")
# plot(normalised_pyt,type="l")
# plot(normalised_pyz,type="l") 

#par(mfrow=c(1,1))

#dis <- as.data.frame(table(pyt$ImageCode), responseName="Count")
#colnames(dis) <- c("ImageName","Count")
#dis$Session <- sapply(dis$ImageName,session_match)
#dis$path <- paste(paste('"',paste(dir,dis$Session,'processed',paste(dis$ImageName,'-mask"',sep=''),sep='/'),sep=''),"png",sep=".")
#xtable(dis)

m <- ggplot(data=pyz,aes(x=Area,fill=factor(Amount)))
m + geom_bar(position="dodge",binwidth=2) + xlim(0, 100) + xlab(xlab) +labs(title = paste(chart.title," Compound Z")) + theme_minimal(base_size = 24) +
  scale_fill_discrete(name = "Compound") #+ scale_y_log10()
file_name = paste(experiment,"hist_z.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=12,height=8)

p <- ggplot(data=PYA,aes(x=Area,fill=factor(Compound)))
p + geom_density(alpha=0.2) + xlim(0, 100) + xlab(xlab) +labs(title = chart.title) + theme_minimal(base_size = 24) + 
  scale_fill_discrete(name = "Compound")
file_name = paste(experiment,"area_base_compound.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=8,height=8)

pc <- ggplot(data=PYA,aes(x=Area,fill=factor(Amount)))
pc + geom_density(alpha=0.2) + xlim(0, 100) + xlab(xlab) +labs(title = chart.title) + theme_minimal(base_size = 24) +
  scale_fill_discrete(name = "Amount %")
file_name = paste(experiment,"area_base_amount.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=8,height=8)

#scaled data test
# pd <- ggplot()
# pd +  geom_bar(data=subset(PYA,Compound=="E"),aes(x=Area,fill=factor(Compound)),weight=71/33,binwidth=1) +
#   geom_bar(data=subset(PYA,Compound=="T"),aes(x=Area,fill=factor(Compound)),weight=71/17,binwidth=1) +
#   geom_bar(data=subset(PYA,Compound=="Z"),aes(x=Area,fill=factor(Compound)),weight=71/21,binwidth=1) +
#   xlim(0, 100) + xlab(xlab) +labs(title = chart.title) + theme_minimal(base_size = 24) + labs(title = chart.title) + 
#   scale_fill_discrete(name = "Compound")
# 
r <- ggplot(data=PYA,aes(y=Area,x=factor(Compound),fill=factor(Amount))) + coord_flip()
r + geom_boxplot() + scale_y_log10()+ theme_minimal(base_size = 24) +   scale_fill_discrete(name = "Amount %") + ylab(xlab) + xlab("Compound")
 file_name = paste(experiment,"compound_amount.png",sep="_")
 full_path = paste(dir,file_name,sep="")
 ggsave(full_path,width=10,height=10)
# 
s <- ggplot(data=PYA,aes(y=Area,x=factor(Amount),fill=factor(Compound))) + coord_flip()
s + geom_boxplot() + scale_y_log10()+ theme_minimal(base_size = 24) +   
   scale_fill_discrete(name = "Compound") + ylab(xlab) + xlab("Amount %")
 file_name = paste(experiment,"amount_compound.png",sep="_")
 full_path = paste(dir,file_name,sep="")
 ggsave(full_path,width=10,height=10)

# generate some filenames
#dis <- as.data.frame(table(PYA$ImageCode), responseName="Count")
#colnames(dis) <- c("ImageName","Count")
#dis$Session <- sapply(dis$ImageName,session_match)
#dis$path <- paste(paste('"',paste(dir,dis$Session,'processed',paste(dis$ImageName,'-mask"',sep=''),sep='/'),sep=''),"png",sep=".")
