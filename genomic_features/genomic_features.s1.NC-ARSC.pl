open IN, "NC-ARSC";
while (<IN>) {
	chomp;
	($full,$one,$three,$carbon_total,$nitrogen_total,$carbon,$nitrogen) = split "\t";
	$carbon{$one} = $carbon;
	$nitrogen{$one} = $nitrogen;
}

open OUT, ">34_NC-ARSC.txt";
print OUT "genome\tN-ARSC\tC-ARSC\n";

@files = `ls 00_genome`;
foreach $file (@files) {
	chomp $file;
	unless ($file =~ s/\.faa$//) {next}
	$carbon = 0;
	$nitrogen = 0;
	$total = 0;
	open IN, "00_genome/$file.faa";
	while (<IN>) {
		chomp;
		if (/>/) {next}
		@array = split "";
		foreach $char (@array) {
			$total ++;
			$carbon += $carbon{$char};
			$nitrogen += $nitrogen{$char};
		}
	}
	$carbon /= $total;
	$nitrogen /= $total;
	print OUT "$file\t$carbon\t$nitrogen\n";
}