library(ggplot2)

dir <- "~/Data/cut/"
#nott4water_sample2_001_1_md8 <- read.csv("~/Data/cut/nott4water_sample2_001_1_md8_no_edge.csv")
#file <- read.csv("~/Data/cut/nott4water_sample2_001_1_md8_no_edge.csv")
#file <- read.csv("~/Data/cut/Nott4water_sample1_005_1 vesicles with no Mg nows.csv")
#file <- read.csv("~/Data/cut/N4_PBS+gly-gly-gly_sample5_004_1-th.csv")
#file <- read.csv("~/Data/cut/N4_PBS+gly-gly-gly_sample5_009_1-th.csv")
file <- read.csv("~/Data/cut/N4_PBS+NaSCN_sample3_003_1.csv")

imgframe <- data.frame(file)

experiment <- "PBS NaSCN Sample 3 001"
chart.binwidth <- 0.5
chart.title <- paste("Domain Area",experiment)

p <- ggplot(data=imgframe,aes(x=Area))
p + geom_histogram(binwidth=chart.binwidth) + ylab("Count") + xlab(expression(paste("Area, ",um^2))) +labs(title = chart.title) + theme_minimal(base_size = 20) +labs(title = chart.title) 

file_name = paste(experiment,"area.png",sep="_")
full_path = paste(dir,file_name,sep="")
ggsave(full_path,width=8,height=8)


#pairs(~Area+Round+Feret,data=imgframe, 
#      main="Simple Scatterplot Matrix")

x<-imgframe$Area
cfd<-ecdf(x)
plot(cfd)

