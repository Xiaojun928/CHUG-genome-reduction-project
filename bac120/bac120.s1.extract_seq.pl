#bac 120 list
open IN, "bac120.tsv";
<IN>;
while (<IN>) {
	chomp;
	s/PFAM_(PF\d{5})\.\d+/$1/;
	s/TIGR_//;
	($ref) = split "\t";
	$rank++;
	$rank{$ref} = $rank;
}

#gnm list
open IN, "00_genome_list.txt";
while (<IN>) {
	chomp;
	if (/#/) {next}
	$gnm{$_} = 1
}

#pfam annot
open IN, "04_pfam.hmm.table";
while (<IN>) {
	chomp;
	($gene,$pfam) = split "\t";
	($gnm) = split "__", $gene;
	$pfam =~ s/\.\d+$//;
	$hash{"$pfam\t$gnm"} = $gene;
}

#tigr annot
open IN, "04_tigr.hmm.table";
while (<IN>) {
	chomp;
	($gene,$tigr) = split "\t";
	($gnm) = split "__", $gene;
	$hash{"$tigr\t$gnm"} = $gene;
}

#seq
open IN, "01_total.IDtrans.faa";
while (<IN>) {
	s/>//;
	chomp ($gene = $_);
	chomp ($seq = <IN>);
	$seq{$gene} = $seq;
}

#output
`mkdir 10_bac120`;
foreach $ref (sort {$rank{$a} <=> $rank{$b}} keys %rank) {
	$temp_name = $rank{$ref};
	$temp_name = ($temp_name <= 9)? "0$temp_name" : $temp_name;
	$temp_name = ($temp_name >= 100)? $temp_name : "0$temp_name";
	open OUT, ">10_bac120/OG$temp_name.faa";
	foreach $gnm (keys %gnm) {
		unless (exists $hash{"$ref\t$gnm"}) {next}
		$gene = $hash{"$ref\t$gnm"};
		print OUT ">$gnm\____OG$temp_name\n$seq{$gene}\n";
	}
}