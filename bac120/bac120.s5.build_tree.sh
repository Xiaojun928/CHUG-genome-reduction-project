#!/bin/bash
#SBATCH -n 16

FastTree concat.fasta > fasttree.tre
iqtree -nt 16 -m MFP -bb 1000 -alrt 1000 -s concat.fasta -redo -mset WAG,LG,JTT,Dayhoff -mrate E,I,G,I+G -mfreq FU -wbtl -pre iqtree
