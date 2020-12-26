`mkdir ptt_fdr.a`;
@files = `ls *trimai`;

#remove empty, if any
foreach $file (@files) {
	chomp $file;
	open IN, $file;
	while (<IN>) {
		if (/>/) {last}
		else {`rm $file`}
	}
}

#	%taxonomy
@files = `ls *trimai`;
foreach $file (@files) {
	chomp $file;
	open IN, $file;
	while (<IN>) {
		chomp;
		unless (s/>//) {next}
		#($gnm,$og) = split "____";
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
		#if (/^>(\S+)____(OG\d+)$/) { ($tax,$og) = ($1,$2) }
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

open OUT, ">ptt_fdr.a/concat.txt";
$end = 0;
print OUT "#nexus\n";
print OUT "begin sets;\n";
for $file (@files) {
	chomp $file;
	$file =~ s/.trimai//;
	$start = $end + 1;
	$end = $start + $len{$file} - 1;
	print OUT "\tcharset $file = $start-$end;\n";
}
print OUT "end;\n";

open OUT, ">ptt_fdr.a/concat.fasta";
foreach $tax (keys %TAX) {
	print OUT ">$tax\n$seq{$tax}\n"
}

