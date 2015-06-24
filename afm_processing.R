library(ggplot2)
library(plyr)

dir = "/media/mbajb/data/Experimental/AFM_Leeds/JB_Processed"
data.sources = list.files(dir,pattern="*.txt",full.names=TRUE)
annotate <- function(f){
  dat <- read.table(f)
  name <- basename(f)
  name_list <- unlist(strsplit(name,"_"))
  print(name_list)
  dat$sample <- as.factor(name_list[2])
  dat$image <- as.factor(name_list[3])
  dat$buffer <- as.factor(name_list[1])
  return(dat)
}

pbs <- ldply(data.sources,annotate)

myplot <- ggplot(data=subset(pbs,Area>1.0),aes(x=Area, fill=buffer, group=buffer)) + geom_histogram(binwidth = 0.5)
myplot + theme_minimal(base_size=22) + xlim(c(0,20))+ xlab(expression(paste("Area, ",mu, m^2))) + scale_fill_discrete(name="Media", breaks=c("PBS","3G","NaSCN"),labels=c("PBS","Gly-Gly-Gly","NaSCN"))

myplot <- ggplot(data=subset(pbs,Area>1.0),aes(x=Area, fill=buffer, group=buffer)) + geom_density(alpha = 0.5)
myplot + theme_minimal(base_size=22) +  xlim(c(0,20)) + xlab(expression(paste("Area, ",mu,m^2))) + scale_fill_discrete(name="Media", breaks=c("PBS","3G","NaSCN"),labels=c("PBS","Gly-Gly-Gly","NaSCN"))


#kde_plot <- ggplot(data=subset(pbs,Area>0.2),aes(x=Feret, fill=buffer, group=buffer)) + geom_histogram(binwidth = 0.1)
#kde_plot + theme_minimal() + xlim(c(0,7))

#area.cut = cut(pbs$Area,seq(0.1,20,by=0.05),right=FALSE)
#area.table = table(area.cut)
#plot(area.table)

#feret.cut = cut(pbs$Feret,seq(0.1,20,by=0.05),right=FALSE)
#feret.table = table(feret.cut)
#plot(feret.table)

