library(ggplot2)

dat <- read.csv("/media/mbajb/data/Experimental/AFM_Leeds/AFM 2 most of the sample runs/N4_PBS_sample4_007_profile_data", sep=";",skip=1)

df <- data.frame(dat)
colnames(df)<- c("x","z")
df$xs <- df$x*1e6
df$zs <- (df$z+0.5e-9)*1e9

p <- ggplot(data=df, aes(x=xs,y=zs))
p + geom_line() + theme_minimal(base_size=22) + xlab(expression(paste("Distance, ",mu,m))) + ylab('Height, nm')
