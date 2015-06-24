library(ggplot2)
library(plyr)
library(reshape2)

dir = "/media/mbajb/data/Experimental/Confocal/lanthanide processed"
data.sources = list.files(dir,pattern="*.txt",full.names=TRUE)
annotate <- function(f){
  dat <- read.table(f)
  name <- basename(f)
  name_list <- unlist(strsplit(name,"_"))
  print(name_list)
  dat$sample <- as.factor(name_list[3])
  dat$stage <- as.factor(name_list[4])
  dat$image <- as.factor(name_list[5])
  #dat$buffer <- as.factor(name_list[1])
  return(dat)
}

yb <- ldply(data.sources,annotate)
head(yb)

myplot <- ggplot(data=subset(yb),aes(x=Area,fill=image)) + geom_histogram(position="dodge",binwidth = 0.5) 
myplot + theme_minimal() + scale_x_continuous(limits = c(0, 3))

xlabel = expression(paste("Area ", mu,m^2))

kde_plot <- ggplot(data=subset(yb),aes(x=Area,fill=factor(image))) + geom_density(alpha = 0.5)
kde_plot + theme_minimal() + xlab(xlabel)


myplot <- ggplot(data=subset(yb,stage==2),aes(x=Area,fill=factor(image))) + geom_histogram(position="dodge",binwidth = 0.5)
myplot + theme_minimal(base_size=20) + xlab(xlabel)  + scale_x_continuous(limits = c(-0.5, 3.5)) + scale_fill_discrete(name='Time after\n addition (minutes)')

kde_plot <- ggplot(data=subset(yb,stage==2),aes(x=Area,fill=factor(image))) + geom_density(alpha = 0.5)
kde_plot + theme_minimal() + xlab(xlabel) 

area_counts <- count(subset(yb, stage==2  & Area > 2 & Area < 3),vars=c("image"))
plot(area_counts$image,area_counts$freq, ylab = "Frequency", xlab="Time /min")

##### Processing Shifts

yt <- subset(yb,stage==2)

#not nice method - what is a better method?

#subset dataframes for the frequency analysis
yt0 <- subset(yt,image==0)
yt15 <- subset(yt,image==15)
yt30 <- subset(yt,image==30)
yt45 <- subset(yt,image==45)
yt60 <- subset(yt,image==60)

xl = 4
step = 0.1

breaks <- seq(0,xl,by=step)
labs <- as.character(seq(0,xl-step,by=step))

bin0 <- data.frame(table(cut(yt0$Area,breaks,include.lowest=TRUE,labels= labs)))
bin15<- data.frame(table(cut(yt15$Area,breaks,include.lowest=TRUE,labels= labs)))
bin30<- data.frame(table(cut(yt30$Area,breaks,include.lowest=TRUE,labels= labs)))
bin45<- data.frame(table(cut(yt45$Area,breaks,include.lowest=TRUE,labels= labs)))
bin60<- data.frame(table(cut(yt60$Area,breaks,include.lowest=TRUE,labels= labs)))

#add some extra columns
bin0$image <- "0"
bin15$image <- "15"
bin30$image <- "30"
bin45$image <- "45"
bin60$image <- "60"

ytb <- rbind(bin0,bin15,bin30,bin45,bin60)
colnames(ytb) <- c("Area","Counts","Image")
ytwide <- dcast(ytb,Area~Image,value.var="Counts")

ytwide[["+15"]] =  ytwide[["15"]] - ytwide[["0"]]
ytwide[["+30"]] =  ytwide[["30"]] - ytwide[["15"]]
ytwide[["+45"]] =  ytwide[["45"]] - ytwide[["30"]]
ytwide[["+60"]] =  ytwide[["60"]] - ytwide[["45"]]

#ytwide[["+15"]] =  ytwide[["15"]] - ytwide[["0"]]
#ytwide[["+30"]] =  ytwide[["30"]] - ytwide[["0"]]
#ytwide[["+45"]] =  ytwide[["45"]] - ytwide[["0"]]
#ytwide[["+60"]] =  ytwide[["60"]] - ytwide[["0"]]

#remove the old columns here
ytwide[["0"]] <- NULL
ytwide[["15"]] <- NULL
ytwide[["30"]] <- NULL
ytwide[["45"]] <- NULL
ytwide[["60"]] <- NULL

#melt the wide data for ggplot
yts <- melt(ytwide, id=c("Area"),variable.name="Image",value.name="Shift")
#sort out numerical labels
yts$Area <- as.numeric(as.character(yts$Area))

p <- ggplot(yts,aes(x=Area,y=Shift,group=Image,fill=Image))
p + geom_bar(stat="identity",position="dodge") + theme_minimal(base_size=18) + scale_x_continuous(limits=c(-0.1,2))

