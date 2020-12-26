setwd("C:/Users/asdfe/Desktop")
library("phytools")
geotree <- read.tree("genomic_features.s4.phyloANOVA.tre")
geodata <- read.table("genomic_features.s4.phyloANOVA.txt", header = TRUE, sep = "\t")
row.names(geodata) <- geodata$ID
geodata <- geodata[geotree$tip.label,]

ps <- c()
for(groupA in c("CHUG members", "other Roseobacter", "outgroup", "PRC members", "sister group")) {
	for(groupB in c("CHUG members", "other Roseobacter", "outgroup", "PRC members", "sister group")) {
		tmpdata <- geodata[c(which(geodata$Group == groupA),which(geodata$Group == groupB)),]
		tmptree <- drop.tip(geotree, geotree$tip.label[-match(tmpdata$ID, geotree$tip.label)])
		for (i in c(4:13)) {
			tmptext <- phylANOVA(tmptree, tmpdata$Group, tmpdata[,i], nsim=1000)
			ps <- c(ps, groupA, groupB, colnames(geodata)[i], tmptext$Pf, "\n")
		}		
	}
}

write.table(file = "output.txt", ps)
