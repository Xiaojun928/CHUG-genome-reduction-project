#!/bin/bash
#SBATCH -n 1
for i in `ls *faa`
do
		j=$(basename $i .faa)
		echo "#!/bin/bash" > $j.mafft.sh
		echo -e "#SBATCH -n 1" >> $j.mafft.sh
		echo "einsi $i > ${j}.mafft.msa" >> $j.mafft.sh
		chmod +x $j.mafft.sh
		sbatch $j.mafft.sh
done
