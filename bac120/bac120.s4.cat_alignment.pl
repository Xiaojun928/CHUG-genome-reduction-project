`mkdir ptt_fdr.a`;
@files = `ls *trimai`;

#	%taxonomy
@files = `ls *trimai`;
foreach $file (@files) {
	chomp $file;
	open IN, $file;
	while (<IN>) {
		chomp;
		unless (s/>//) {next}
		($gnm) = split "__";
		($og = $file) =~ s/\.trimai//;
		$TAX{$gnm} = 1;
		$og{$og} = 1;
	}
}

foreach $file (@files) {
	#	initialize
	chomp $file;
	open IN, $file;
	%tax = %TAX;
	
	#	main
	while (<IN>) {
		chomp;
		if (s/>//) {
			($tax) = split "__";
			($og = $file) =~ s/\.trimai//;
		}
		else {
			$seq{$tax} .= $_;
			$tax{$tax} = 'done';
			if (length > 0) { $len = length;$len{$og} = $len }
		}
	}
	foreach $tax (keys %TAX) {
		if ($tax{$tax} ne 'done') { $seq{$tax} .= '-' x $len }
	}
}

open OUT, ">ptt_fdr.a/concat.fasta";
foreach $tax (keys %TAX) {
	print OUT ">$tax\n$seq{$tax}\n"
}

