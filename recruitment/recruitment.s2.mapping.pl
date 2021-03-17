#select databases
#tara					$dir = "22_tara";            $prefix = "fq.gz"; $reads_folder = "/share/database/public_sequencing/TaraOcean____metaG____PRJEB1787";
#tara RNA				$dir = "22_tara_metaT";      $prefix = "fq.gz"; $reads_folder = "/share/database/public_sequencing/TaraOcean____metaT____PRJEB6608";
#tara polar				$dir = "22_tara_polar";      $prefix = "fq.gz"; $reads_folder = "/share/database/public_sequencing/TaraOcean_polar____metaG____PRJEB9740/03_trimmed2";
#tara polar RNA			$dir = "22_tara_polar_metaT";$prefix = "fq.gz"; $reads_folder = "/share/home-user/xyfeng/database/public_sequencing/TaraOcean_polar____metaT____PRJEB9741";
#kwang					$dir = "22_kwangyang";       $prefix = "fq.gz"; $reads_folder = "/share/database/public_sequencing/CHUG____metaG____kwangyang_PRJEB22097/03_trimmed";
#red_sea				$dir = "22_red_sea";         $prefix = "fq.gz"; $reads_folder = "/share/database/public_sequencing/CHUG____metaG____red_sea_PRJNA395437/03_trimmed2";

$phred = 4;
`mkdir $dir`;
$query = "01_ref_merged/total.fasta";

#	operation
@SAMPLE = `ls $reads_folder/*.$prefix`;
foreach $srr (@SAMPLE) {
	chomp $srr;
	$srr =~ s/^.*\///;
	
	#pair-end
	if ($srr =~ s/_2.$prefix//) { next; }
	elsif ($srr =~ s/_1.$prefix//) {
		if (-e "$dir/$srr.blastn.table") { next; }
		$script = "$dir/$srr.recruitment.sh";
		open OUT, ">$script";
		print OUT "#!/bin/bash\n";
		print OUT "#SBATCH -n $phred\n";
		print OUT "bowtie2 --very-sensitive-local -x $query -1 $reads_folder/$srr\_1.$prefix -2 $reads_folder/$srr\_2.$prefix -S $dir/$srr.sam -p $phred\n";
	}
	elsif ($srr =~ s/.$prefix//) {
		if (-e "$dir/$srr.blastn.table") { next; }
		$script = "$dir/$srr.recruitment.sh";
		open OUT, ">$script";
		print OUT "#!/bin/bash\n";
		print OUT "#SBATCH -n $phred\n";
		print OUT "bowtie2 --very-sensitive-local -x $query -U $reads_folder/$srr.$prefix -S $dir/$srr.sam -p $phred\n";
	}
	print OUT "samtools flagstat $dir/$srr.sam > $dir/$srr.summary.txt\n";
	print OUT "samtools view -bSF 4 -@ $phred $dir/$srr.sam > $dir/$srr.bam\n";
	print OUT "rm $dir/$srr.sam\n";
	print OUT "samtools sort -@ $phred $dir/$srr.bam > $dir/$srr.sort.bam\n";
	print OUT "rm $dir/$srr.bam\n";
	print OUT "samtools fasta -N $dir/$srr.sort.bam > $dir/$srr.mapped.fasta\n";
	print OUT "blastn -db $query -query $dir/$srr.mapped.fasta -out $dir/$srr.blastn.table -evalue 1e-5 -perc_identity 95 -qcov_hsp_perc 80 -outfmt 6 -num_threads $phred\n";

	`chmod +x $script`;
	print "nohup sh $script &\n";
}
