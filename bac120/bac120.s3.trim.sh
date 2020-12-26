#!/bin/bash
#SBATCH -n 1

#	usage
echo "sh this.sh"
echo "require mafft namely .mafft.msa in ."

#	initialization

#	operation
for i in `ls *.mafft.msa`
do
		j=$(basename $i .mafft.msa)
		trimal -in $i -out ${j}.trimai -automated1 -resoverlap 0.55 -seqoverlap 60
		perl ~/pipeline/trans_fasta_2_one_line.pl ${j}.trimai
		mv ${j}.oneline.trimai ${j}.trimai
done

