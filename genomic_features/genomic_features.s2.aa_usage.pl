open IN, "00_genome_list.txt";
while (<IN>) {
	chomp;
	($file) = split "\t";
	open INN, "00_genome/$file.faa";
	while (<INN>) {
		chomp;
		if (/>/) { next; }
		@array = split "";
		foreach $char (@array) {
			if ($char eq '*' or $char eq 'X') { next; }
			$char{$char} = 1;
			$count{"$file\t$char"} ++;
			$total{$file} ++;
		}
	}
}

open OUT, ">35_aa_usage.txt";
print OUT "aa_usage";
foreach $file (sort {$a cmp $b} keys %total) { print OUT "\t$file"; }
print OUT "\n";
foreach $char (keys %char) {
	print OUT "$char";
	foreach $file (sort {$a cmp $b} keys %total) {
		$rate = $count{"$file\t$char"} / $total{$file} * 100;
		print OUT "\t$rate";
	}
	print OUT "\n";
}
