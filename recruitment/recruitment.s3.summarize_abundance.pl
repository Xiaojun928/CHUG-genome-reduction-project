#genome list
open IN, "../00_genome_list.txt";
while (<IN>) {
	chomp;
	if (/#/) {next}
	($gnm,$group) = split "\t";
	$gnm{$gnm} = 1;
	$group{$group} = 1;
}

@files = `ls *blastn.table`;
foreach $file (@files) {
	chomp $file;
	$file =~ s/\.blastn\.table//;
	$file{$file} = 1;
	open SUM, "$file.summary.txt";
	while (<SUM>) {
		chomp;
		($total{$file}) = split " ";
		last;
	}
	
	undef %already;
	open IN, "$file.blastn.table";
	while (<IN>) {
		chomp;
		($reads,$gnm,$identy) = split "\t";
		if ($identy < 95) {next}
		if ($already{$reads}) {next}
		$already{$reads} = 1;
		($group,$gnm) = split "__init__", $gnm;
		($gnm,$contig) = split "__", $gnm;
		$count{"$file\t$group"} ++;
		$count{"$file\t$gnm"} ++;
	}
}

#output
open OUT, ">23_recruitment_result_GNM.txt";
#title
print OUT "sample	total_reads";
foreach $gnm (sort {$a cmp $b} keys %gnm) {print OUT "\t$gnm\t$gnm"}
print OUT "\n";
#body
foreach $file (sort {$a cmp $b} keys %file) {
	unless ($total{$file}){next}
	print OUT "$file	$total{$file}";
	foreach $gnm (sort {$a cmp $b} keys %gnm) {
		$count = $count{"$file\t$gnm"};
		$precent = $count / $total{$file} * 100;
		print OUT "\t$count\t$precent";
	}
	print OUT "\n";
}
 
