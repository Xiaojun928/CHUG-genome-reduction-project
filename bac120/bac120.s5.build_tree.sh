#!/bin/bash
#SBATCH -n 16
#	usage
echo "sh this.sh"
echo "require concat.phy files namely concat.phy in .\n\n"

#	initialization
FastTree concat.fasta > fasttree.tre
iqtree -nt 16 -m MFP -bb 1000 -alrt 1000 -s concat.phy -redo -mset WAG,LG,JTT,Dayhoff -mrate E,I,G,I+G -mfreq FU -wbtl -pre iqtree
