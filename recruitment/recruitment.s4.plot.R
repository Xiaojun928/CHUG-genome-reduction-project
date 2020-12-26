setwd("C:/Users/asdfe/Desktop")
library(grid)
library(Hmisc)
library(cowplot)
library(ggplot2)
library(corrplot)
library(reshape2)
library(gridExtra)

data <- read.table("recruitment.s4.plot.txt", header = TRUE, sep = '\t')
data <- melt(data, id = c("rank","type","sample","location"))
colnames(data) <- c("rank","type","sample","location","genome","abundance")
#remove low abundance if any
data <- data[which(data$genome != "SUM"),]
data$genome = factor(data$genome, levels=c("HIMB11","SB2","HTCC2255","HTCC2150","HTCC2083","LE17","RCA23","FZCC0069","HKCCA1065","HKCCD6035","FZCC0188","HKCCA1288","LSUCC0387","LSUCC0246","LSUCC1028","CHUG"))
#data$genome = factor(data$genome, levels=c("CHUG","LSUCC1028","LSUCC0246","LSUCC0387","HKCCA1288","FZCC0188","HKCCD6035","HKCCA1065","FZCC0069","RCA23","LE17","HTCC2083","HTCC2150","HTCC2255","SB2","HIMB11"))
data$abundance[which(data$abundance == 0)] <- 0.000001

#TARA
samples = "TARA"

#TARA recruitment
tmp <- data[which(data$type == samples),]
tmp$abundance <- log10(tmp$abundance)
tmp$abundance <- tmp$abundance+4
tmp$abundance[which(tmp$abundance < 0)] <- 0.01
ggplot(tmp, aes(x = rank, y = genome, fill = abundance)) + 
	geom_tile() +
	scale_fill_distiller(palette = "Reds", direction = 1, breaks = c(0,2,4), labels = c("0.0001%","0.01%","1%")) + 
	scale_x_continuous(limits = c(min(tmp$rank), max(tmp$rank)), breaks = c(-1,-42,-65,-106,-157,-182,-211,-274,-287,-294), labels = c("AO","NAO","SAO","IO","MS","NPO","SPO","RS","SO","SO")) + 
	theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 1))

#TARA bar plot
tmp <- data[which(data$type == samples),]
genome <- dcast(tmp, genome~type, mean)
colnames(genome) <- c("genome","abundance")
genome$genome <- c(1:16)
genome <- rbind(genome,c(17, min(tmp$abundance)))
genome <- rbind(genome,c(18, max(tmp$abundance)))
genome$abundance <- log10(genome$abundance)
genome$abundance <- genome$abundance+4
genome$abundance[which(genome$abundance < 0)] <- 0.01
ggplot(genome, aes(x = genome, y = abundance, fill = abundance)) + 
	geom_bar(stat = "identity", width = 1) + 
	scale_fill_distiller(palette = "Reds", direction = 1, breaks = c(0,2,4), labels = c("0.0001%","0.01%","1%")) + 
	scale_y_continuous(breaks = c(0,0.7,1,1.7,2,2.7), labels = c("0.0001%","0.0005%","0.001%","0.005%","0.01%","0.05%"))

#TARA correlation
df <- read.table("ggplot____correlation.txt", header = TRUE, sep = "\t", na.strings = NA)
df <- as.matrix(df)
rownames(df) <- df[,1]
df <- df[,-1]
dfC <- rcorr(df, type = "pearson")$r
dfP <- rcorr(df, type = "pearson")$P
corrplot(dfC[1:16,1:30], p.mat = dfP[1:16,1:30], sig.level = 1e-4, method = "square", type = "full", 
	order = "original", tl.col = "black", tl.cex = 0.5, tl.srt = 45, cl.lim=c(-1,1), insig = "pch", 
	pch.cex = 1, col=colorRampPalette(c("blue","white","red"))(200))
