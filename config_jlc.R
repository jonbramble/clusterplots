experiments = paste("JLExp",seq(1,8,by=1),sep="")
exp_codes = c("JLC0001","JLC0002","JLC0003","JLC0004","JLC0006","JLC0007","JLC0008","JLC0009")
buffer = c("PBS","PBS","PBS","NaSCN","NaSCN","3G","3G","3G")
conf_1 <- cbind(experiments,exp_codes,buffer)
conf = data.frame(conf_1)
colnames(conf)<- c('experiments','exp_codes',"buffer")

