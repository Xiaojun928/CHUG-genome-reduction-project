#!/bin/bash
#SBATCH -n 1

#	usage
echo "sh this.sh"
echo "require cog namely .faa in .(single_copy_gene)"

#	initialization

#	operation
for i in `ls *faa`
do
		j=$(basename $i .faa)
		echo "#!/bin/bash" > $j.mafft.sh
		echo -e "#SBATCH -n 1" >> $j.mafft.sh
		echo "einsi $i > ${j}.mafft.msa" >> $j.mafft.sh
		chmod +x $j.mafft.sh
		sbatch $j.mafft.sh
#		sh $j.mafft.sh
done
