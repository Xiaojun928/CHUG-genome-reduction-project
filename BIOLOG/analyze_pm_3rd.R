require(opm)

setwd("F:/project/population/Analysis/s91_experiment/PM_experiment/PM_d517_v204_m314/d517_v204_m314_PM1_PM2_raw_data/csv_data/")

pm <- read_opm('A1288.csv', convert = 'grp')

ff <- '4strain_PM3_without_A0.csv'
ff <- '4strain_PM1_PM2_without_A0.csv'
pm <- read_opm(ff, convert= 'grp')
pm.meta <- collect_template(ff, include= '*.csv')
pm
class(pm)

#pm <- read_opm("PM1_PM2_allplate_allHours_kinetic_clean.csv", convert= 'grp')
#pm.meta <- collect_template('PM1_PM2_allplate_allHours_kinetic_clean.csv', include= "*.csv")
#pm.meta <- collect_template('DSS3__allHours_kinetic.csv')
#pm.meta <- collect_template('d517_R1_allHours_kinetic.csv')
pm.meta
class(pm.meta)

tmp <- csv_data(pm)
#class(tmp)
tmp
#pm.meta$Species <- paste(tmp[, "Strain Name"], 'sp.', tmp[, "Strain Number"], sep= " ")
#pm.meta$Species <- paste('Roseovarius sp.', tmp[, "Strain Number"], sep= " ")
#pm.meta$Strain <- tmp[, "Strain Number"]
#pm.meta$Experiment <- rep(c('Replicate1', 'Replicate2', 'Replicate3'), 4)
#pm.meta <- pm.meta[, -(1:3)]

pm.meta$Species <- c(
  rep(c('Roseovarius sp. d-517', 'Roseovarius sp. m-314', 'Roseovarius sp. v-204'), each=3),
  rep(c('Roseovarius sp. d-517', 'Roseovarius sp. m-314', 'Roseovarius sp. v-204'), each=3),
  rep('Roseovarius sp. m-339', each= 6)
)

pm.meta$Species <- rep(c('Roseovarius sp. d-517', 'Roseovarius sp. m-314', 'Roseovarius sp. v-204','Roseovarius sp. m-339'), each=3)


pm.meta$Strain <- sub("Roseovarius sp.", "", pm.meta$Species)
pm.meta$Experiment <- rep(c('Replicate1', 'Replicate2', 'Replicate3'), 4)

## inconsistent time (two experiments) cause error!
#pm.meta$`Setup Time`[19:24] <- pm.meta$`Setup Time`[1]

pm1 <- pm$PM01
pm1 <- include_metadata(pm1, md= pm.meta[c(1:9, 19:21), ])
pm2 <- pm$PM02
pm2 <- include_metadata(pm2, md= pm.meta[c(9:18, 22:24), ])

pm3 <- pm$PM03
pm3 <- include_metadata(pm3, md= pm.meta)

to_metadata(pm1)
to_metadata(pm2)
to_metadata(pm3)


#####################
########## Growth curve for each plate (each strain and replciate)
xy_plot(pm1, include= "Species",col= c('darkorchid1',  'darkolivegreen2', 'plum1','darkgreen'))
xy_plot(pm1[, , c('A01', 'C02', 'D01', 'D07', 'H02', 'D06', 'E01', 
                  'G04', 'F07', 'F02', 'F05', 'E11', 'E12',
                  'C05', 'D05')], 
        include= "Species",col= c('darkorchid1',  'darkolivegreen2', 'plum1','darkgreen'))

#        col= c('violet', 'red','darkgreen', 'blue')
dev.copy(pdf, "../PM1_growth_without_zero.pdf", width= 20, height= 15)
dev.copy(pdf, "../part_PM1.pdf", width= 10, height= 8)
dev.off()

xy_plot(pm2, include= "Species", col=  c('darkorchid1',  'darkolivegreen2', 'plum1','darkgreen'))
xy_plot(pm2[,, c('A01', 'H01', 'G12', 'G11', 'B12', 'E03', 'G06', 'G07', 
                 'H08', 'C12', 'E02')], include= "Species", col=  c('darkorchid1',  'darkolivegreen2', 'plum1','darkgreen'))
dev.copy(pdf, "../PM2_growth_without_zero.pdf", width= 20, height= 15)
dev.copy(pdf, "../part_PM2.pdf", width= 10, height= 8)
dev.off()

xy_plot(pm3, include= "Species", col= c('darkorchid1',  'darkolivegreen2', 'plum1','darkgreen'))
dev.copy(pdf, "../PM3_growth_without_zero.pdf", width= 20, height= 15)
dev.off()

# single strain
#pm3.s <- subset(pm3, query = list(Strain= 'v204', Experiment= 'Replicate1'))
#xy_plot(pm3.s, include= "Species", col= 'red')
#dev.copy(pdf, "PM3_growth_v204_pyruvate_20mM.pdf", width= 20, height= 15)
dev.copy(pdf, "PM3_growth_pyruvate_5mM.pdf", width= 20, height= 15)
dev.off()



#####################
###### Differentiate the each strain
pm1.agg <- do_aggr(pm1, boot= 100, method= 'opm-fast')
pm2.agg <- do_aggr(pm2, boot= 100, method= 'opm-fast')
pm3.agg <- do_aggr(pm3, boot= 100, method= 'opm-fast')


p1.mcp <- opm_mcp(pm1.agg, model= ~J(Strain+Well), linfct= c(Pairs.Well= 1))
p2.mcp <- opm_mcp(pm2.agg, model= ~ J(Strain+Well), linfct= c(Pairs.Well=1))
p3.mcp <- opm_mcp(pm3.agg, model= ~J(Strain+Well), linfct= c(Pairs.Well=1))

olpar <- par(mar= c(3, 25, 2, 1))

plot(p1.mcp)
plot(p2.mcp)  # Putrescine
plot(p3.mcp)



dev.copy(pdf, '../PM1_well_compairson.pdf', width= 25, height=80)
dev.off()
dev.copy(pdf, '../PM2_well_compairson.pdf', width= 25, height=80)
dev.off()
dev.copy(pdf, '../PM3_well_compairson.pdf', width= 25, height=80)
dev.off()
par(olpar)
##------------------





########### Pathway mapping
## 
setwd("F:/project/population/Analysis/s91_experiment/PM_experiment/PM_d517_v204_m314/")

# Get the mapping betwee well and plates
PM <- read.csv("PM.csv", header=F, as.is=T)
str(PM)
PM <- PM[, c(1,2,3,6)]
head(PM)
names(PM) <- c('plate', 'well', 'substrate','kegg_cmp')

## Differentiate wells
rose.well <- read.csv("Differentiated_wells.csv", as.is=T)
rose.well <- rose.well[, c(1,2,4)]
head(rose.well)
rose.well$Plate.Type <- sub("PM02", "PM02A", rose.well$Plate.Type)
rose.well$Plate.Type <- sub("PM03", "PM03B", rose.well$Plate.Type)

z <- merge(rose.well, PM, by.x= c('Plate.Type', 'Wells'), by.y= c('plate', 'well'))
str(z)
z

pm1.agg <- do_aggr(pm1, boot= 100, method= 'opm-fast')
pm2.agg <- do_aggr(pm2, boot= 100, method= 'opm-fast')
pm3.agg <- do_aggr(pm3, boot= 100, method= 'opm-fast')

d517.pm1 <- subset(pm1.agg, list(Strain_name= 'd517'))
d517.pm2 <- subset(pm2.agg, list(Strain_name= 'd517'))
d517.pm3 <- subset(pm3.agg, list(Strain= 'd517'))

d517.pm1.ann <- annotated(d517.pm1, how= 'value')
d517.pm2.ann <- annotated(d517.pm2, how= 'value')
d517.pm3.ann <- annotated(d517.pm3, how= 'value')

sig.pm1 <- c('C02', 'C05', 'D01', 'D05', 'D06', 'D07', 'C12', 'E01', 'G04')
idx <- match(sig.pm1, PM$well)
PM[idx, ]
PM$substrate[idx]
x <- d517.pm1.ann[, 2:155]
x.p <- colnames(x)[colSums(x[idx, ], na.rm = T)>0]

sig.pm2 <- c('E03', 'G06', 'G07', 'F10', 'H08')
tmp <- subset(PM, plate=='PM02A')
idx2 <- match(sig.pm2, tmp$well)
tmp[idx2, ]
tmp$substrate[idx2]
x2 <- d517.pm2.ann[, 2:102]
x2.p <- colnames(x2)[colSums(x2[idx2, ], na.rm = T)>0]

sig.pm3 <- rose.well[rose.well$Plate.Type=='PM03B', 'Wells']
tmp <- subset(PM, plate=='PM03B')
idx3 <- match(sig.pm3, tmp$well)
tmp[idx3, ]
x3 <- d517.pm3.ann[, 2:102]
x3.p <- colnames(x3)[colSums(x3[idx3, ], na.rm = T)>0]
x3.p
p <- unique(c(x.p, x2.p))
length(p)
p <- sub("map", "", p)
p


setwd("kegg_pathway_mapping/")
for (i in p) {
  
  # opm_path(cpd.data = c(annotated(p1.mcp, output= "'-50", lmap=1:3), 
  #                       annotated(p2.mcp, output= "'-50", lmap=1:3)), 
  #          species= 'ko', out.suffix = 'difference_category', pathway.id= i,
  #          limit= list(gene= 2, cpd= 4), bins= list(gene= 1, cpd= 4))
  
  opm_path(cpd.data = annotated(p3.mcp, output= "'50", lmap=1:3), 
           species= 'ko', out.suffix = 'map', pathway.id= i,
           limit= list(gene= 2, cpd= 4), bins= list(gene= 1, cpd= 4))
  
  
  
}

############################################################################
## Copied from the manual
opm_path <- function(cpd.data, gene.data = NULL,
                     high = list(gene = "green4", cpd = "blue"),
                     mid = list(gene = "lightsteelblue1", cpd = "yellow"),
                     low = list(gene = "white", cpd = "yellow"),
                     species = "ko", out.suffix = "non-native",
                     key.pos = "topright", afactor = 1000,
                     limit = list(gene = 2, cpd = 400),
                     bins = list(gene = 0.5, cpd = 40),
                     both.dirs = list(gene = FALSE, cpd = FALSE),
                     sign.pos = "topleft", cpd.lab.offset = 0,
                     same.layer = FALSE,
                     na.col = "white", ...) {
  pathview(cpd.data = cpd.data, gene.data = gene.data,
           high = high, mid = mid, low = low,
           species = species, out.suffix = out.suffix, key.pos = key.pos,
           afactor = afactor, limit = limit, bins = bins,
           both.dirs = both.dirs, sign.pos = sign.pos,
           cpd.lab.offset = cpd.lab.offset, same.layer = same.layer,
           na.col = na.col, ...)
}



