experiments = c("JBE0001","JBE0002","JBE0003","JBE0005","JBE0006","JBE0007","JBE0008","JBE0009")
codes = c("Leeds","PBS","3G","Leeds","3G","PBS","NaSCN","NaSCN")
dye = c("Di8","Di8","Di8","FPE","FPE","FPE","Di8","FPE")
conf = data.frame(cbind(experiments,codes,dye))
colnames(conf)<- c('experiments','codes','dye')

match.sample <- function(experiment) as.character(conf$codes[match(experiment,conf$experiments)])
match.dye <- function(experiment) as.character(conf$dye[match(experiment,conf$experiments)])