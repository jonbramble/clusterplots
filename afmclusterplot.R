library(ggplot2)

dir = "/media/mbajb/Ext Passport/AFM/processed"
data.sources = list.files(dir,pattern="*.csv",full.names=TRUE)
all <- lapply(data.sources,function(i){
  tmp <- read.csv(i,stringsAsFactors=FALSE)
  name <- basename(i)
  name_list <- unlist(strsplit(name,"_"))
  base_buffer <- name_list[2];
  additive <- name_list[3];
  sample <- name_list[4];
  image <- name_list[5];
  size <- name_list[6];
  tmp$base_buffer <- rep(base_buffer,nrow(tmp))
  tmp$Additive <- rep(additive,nrow(tmp))
  tmp$sample <- rep(sample,nrow(tmp))
  tmp$image <- rep(image,nrow(tmp))
  tmp$size <- rep(size,nrow(tmp))
  return(tmp) 
})
#imgframe <- data.frame(file)
imgframe <- data.frame(do.call(rbind,all))

pbs <- subset(imgframe, base_buffer == "PBS")
pbs_3g <- subset(imgframe, Additive == "3G")
pbs_nascn <- subset(imgframe, Additive == "NaSCN")
pbs_control <- subset(imgframe, Additive == "Control")

dn_pbs_3g <- density(pbs_3g$Area)
dn_pbs_nascn <- density(pbs_nascn$Area)
dn_pbs_control <- density(pbs_control$Area)

control <- subset(imgframe, Additive == "Control")
ddn <- dn_pbs_3g$y-dn_pbs_control$y

experiment <- "Summary"
chart.binwidth <- 0.5
chart.title <- paste("Domain Area",experiment)

rb <- ggplot(data=pbs,aes(x=Area,y=factor(Additive),fill=factor(Additive))) 
rb + geom_boxplot() + theme_minimal(base_size = 20)

p <- ggplot(data=pbs,aes(x=Area,fill=Additive))
p + geom_bar(binwidth=chart.binwidth) + xlim(c(0,20)) + xlab(expression(paste("Area, ",um^2))) +labs(title = chart.title) + theme_minimal(base_size = 20) +labs(title = chart.title) 
file_name = paste(experiment,"area_base.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=8,height=8)

q <- ggplot(data=control,aes(x=Area,fill=base_buffer))
q + geom_bar(binwidth=chart.binwidth) + xlim(c(0,7.5)) + xlab(expression(paste("Area, ",um^2))) +labs(title = chart.title) + theme_minimal(base_size = 20) +labs(title = chart.title) +   
  scale_fill_discrete(name = "Buffer")

file_name = paste(experiment,"area_base_buffer.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=8,height=8)





#pairs(~Area+Round+Feret,data=imgframe, 
#      main="Simple Scatterplot Matrix")

#x<-imgframe$Area
#cfd<-ecdf(x)
#plot(cfd)

