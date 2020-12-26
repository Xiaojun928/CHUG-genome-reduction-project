setwd("C:/Users/asdfe/Desktop")
library("ape")
library("phytools")
geotree <- read.tree("enriched_OGs.s1.binaryPGLMM.tre")
geodata <- read.table("enriched_OGs.s1.binaryPGLMM.txt", header = TRUE, sep = "\t")
row.names(geodata) <- geodata[,1]
row.names(geodata) <- geodata$ID
geodata <- geodata[geotree$tip.label,]
tmp <- phylosig(tree = geotree, x = geodata$light, method = "lambda", test = TRUE)
result <- binaryPGLMM(light ~ PRC, data = geodata, phy = geotree)
result$B.pvalue
