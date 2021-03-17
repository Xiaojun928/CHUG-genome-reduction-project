setwd("C:/Users/asdfe/Desktop")
library(ggplot2)

data <- read.table("OG_expression.txt", header = TRUE, sep = '\t')
data$CHUG[which(data$CHUG < 0.001)] <- 0.001
data$PRC[which(data$PRC < 0.001)] <- 0.001
max_CHUG <- max(data$CHUG[!(is.na(data$CHUG))])
max_PRC <- max(data$PRC[!(is.na(data$PRC))])
annot <- data[which(!(is.na(data$abbrev))),]

# both
tmp <- data[(!(is.na(data$CHUG)) & !(is.na(data$PRC))),]
ggplot(tmp, aes(x = CHUG, y = PRC, color = expression)) + 
	geom_point() +
	scale_x_log10(limits = c(0.001,max_CHUG)) + 
	scale_y_log10(limits = c(0.001,max_PRC)) + 
	scale_colour_manual(values = c("red", "red", "gray", "red")) + 
	ggrepel::geom_text_repel(aes(label = abbrev), min.segment.length = 0) + 
	guides(color = FALSE) + 
	theme(
		axis.ticks = element_blank(), 
		axis.text.x = element_blank(), 
		axis.text.y = element_blank(), 
		axis.title.x = element_blank(),
		axis.title.y = element_blank()
	)

# CHUG
tmp <- data[(!(is.na(data$CHUG)) & is.na(data$PRC)),]
tmp$PRC <- 1
ggplot(tmp, aes(x = CHUG, y = PRC, color = expression)) + 
	geom_point() +
	scale_x_log10(limits = c(0.001,max_CHUG)) + 
	scale_colour_manual(values = c("red", "gray")) + 
	ggrepel::geom_text_repel(aes(label = abbrev), , min.segment.length = 0) + 
	guides(color = FALSE) + 
	theme(
		axis.ticks = element_blank(), 
		axis.text.x = element_blank(), 
		axis.text.y = element_blank(), 
		axis.title.x = element_blank(),
		axis.title.y = element_blank()
	)

# PRC
tmp <- data[(is.na(data$CHUG) & !(is.na(data$PRC))),]
tmp$CHUG <- 1
ggplot(tmp, aes(x = CHUG, y = PRC, color = expression)) + 
	geom_point() +
	scale_y_log10(limits = c(0.001,max_PRC)) + 
	scale_colour_manual(values = c("gray", "red")) + 
	ggrepel::geom_text_repel(aes(label = abbrev), , min.segment.length = 0) + 
	guides(color = FALSE) + 
	theme(
		axis.ticks = element_blank(), 
		axis.text.x = element_blank(), 
		axis.text.y = element_blank(), 
		axis.title.x = element_blank(),
		axis.title.y = element_blank()
	)

# both annotation
tmp <- data[(!(is.na(data$CHUG)) & !(is.na(data$PRC))),]
ggplot(tmp, aes(x = CHUG, y = PRC, color = expression)) + 
	geom_point() +
	scale_x_log10(limits = c(0.001,max_CHUG)) + 
	scale_y_log10(limits = c(0.001,max_PRC)) + 
	scale_colour_manual(values = c("gray", "red", "blue")) + 
	guides(color = FALSE) + 
	theme(
		axis.ticks = element_blank(), 
		axis.text.x = element_blank(), 
		axis.text.y = element_blank(), 
		axis.title.x = element_blank(),
		axis.title.y = element_blank()
	) +
	annotate("text", x=0.233640625, y=59.88283673, label="livK") + 
	annotate("text", x=0.459385, y=7.067815126, label="coxL") + 
	annotate("text", x=0.497701389, y=1.85855102, label="gae") + 
	annotate("text", x=0.529734375, y=26.26183673, label="mdh") + 
	annotate("text", x=0.650029412, y=8.306252101, label="coxS") + 
	annotate("text", x=0.8070625, y=0.93452381, label="ureA") + 
	annotate("text", x=0.961534091, y=34.09341071, label="pdhB") + 
	annotate("text", x=1.06940625, y=16.04684694, label="leuC") + 
	annotate("text", x=1.0805625, y=2.416214286, label="ureC") + 
	annotate("text", x=1.095203125, y=42.68789796, label="sdhB") + 
	annotate("text", x=1.165265625, y=20.78569388, label="argG") + 
	annotate("text", x=1.30278125, y=5.761214286, label="wbpO") + 
	annotate("text", x=1.32884375, y=414.4819143, label="pufB") + 
	annotate("text", x=1.3349, y=3.956035714, label="rfbF") + 
	annotate("text", x=1.40740625, y=28.7084898, label="cobS") + 
	annotate("text", x=1.476015625, y=31.32557143, label="sucC") + 
	annotate("text", x=1.530138889, y=26.07036735, label="aceB") + 
	annotate("text", x=1.610943182, y=47.0685, label="pdhA") + 
	annotate("text", x=1.658640625, y=74.80644898, label="ilvC") + 
	annotate("text", x=1.759796875, y=33.20114286, label="glyA") + 
	annotate("text", x=1.8008125, y=21.00725824, label="aapP") + 
	annotate("text", x=1.826046875, y=20.08308163, label="amtB") + 
	annotate("text", x=1.931015625, y=0.820142857, label="chlN") + 
	annotate("text", x=2.10190625, y=42.6025102, label="sdhA") + 
	annotate("text", x=2.204484375, y=28.67940816, label="gltA") + 
	annotate("text", x=2.465109375, y=29.84991837, label="sucD") + 
	annotate("text", x=2.7720625, y=30.51422449, label="metH") + 
	annotate("text", x=3.068475, y=14.72885714, label="gmd") + 
	annotate("text", x=3.491525, y=106.3776429, label="icd") + 
	annotate("text", x=4.7045, y=7.518095238, label="ABC.SP") + 
	annotate("text", x=5.202859375, y=46.89738095, label="ABC.SP") + 
	annotate("text", x=8.361546875, y=62.55426786, label="katG") + 
	annotate("text", x=8.725664063, y=61.73565306, label="glnB") + 
	annotate("text", x=9.066015625, y=23.93193878, label="dapD") + 
	annotate("text", x=10.77157813, y=243.421898, label="aapJ") + 
	annotate("text", x=101.5507813, y=214.6904286, label="pufA")

# PRC annotation
tmp <- data[(is.na(data$CHUG) & !(is.na(data$PRC))),]
tmp$CHUG <- 1
ggplot(tmp, aes(x = CHUG, y = PRC, color = expression)) + 
	geom_point() +
	scale_y_log10(limits = c(0.001,8846)) + 
	scale_colour_manual(values = c("gray", "red", "blue")) + 
	guides(color = FALSE) + 
	theme(
		axis.ticks = element_blank(), 
		axis.text.x = element_blank(), 
		axis.text.y = element_blank(), 
		axis.title.x = element_blank(),
		axis.title.y = element_blank()
	) +
	annotate("text", x=1, y=6.389261905, label="motA") + 
	annotate("text", x=1, y=42.32554762, label="fliC") + 
	annotate("text", x=1, y=153.0608286, label="fliS") + 
	annotate("text", x=1, y=60.20177551, label="livK") + 
	annotate("text", x=1, y=26.16728571, label="livK") + 
	annotate("text", x=1, y=40.31857143, label="tauA") + 
	annotate("text", x=1, y=6.947742857, label="urtA")

#https://stackoverflow.com/questions/44991607/how-do-i-label-the-dots-of-a-geom-dotplot-in-ggplot2
#https://ggplot2-book.org/annotations.html
