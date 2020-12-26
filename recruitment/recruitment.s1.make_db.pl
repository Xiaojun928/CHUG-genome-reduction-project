`mkdir 01_ref_merged`;

open IN, "00_genome_list.txt";
while (<IN>) {
	chomp;
	if (/#/) {next}
	($gnm,$tax) = split "\t";
	open SEQ, "../00_fasta/$gnm.fasta";
	open OUT, ">01_ref_merged/$gnm.fasta";
	$contig = 0;
	while (<SEQ>) {
		if (/>/) { $contig++; print OUT ">$tax\__init__$gnm\__contig$contig\n"; }
		else {print OUT}
	}
}

`cat 01_ref_merged/GNM*.fasta > 01_ref_merged/total.fasta`;
`makeblastdb -dbtype nucl -in 01_ref_merged/total.fasta`;
`bowtie2-build 01_ref_merged/total.fasta 01_ref_merged/total.fasta`;
