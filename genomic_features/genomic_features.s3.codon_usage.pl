%full = (
	'AAA', 'Lys',
	'AAC', 'Asn',
	'AAG', 'Lys',
	'AAT', 'Asn',
	'ACA', 'Thr',
	'ACC', 'Thr',
	'ACG', 'Thr',
	'ACT', 'Thr',
	'AGA', 'Arg',
	'AGC', 'Ser',
	'AGG', 'Arg',
	'AGT', 'Ser',
	'ATA', 'Ile',
	'ATC', 'Ile',
	'ATG', 'Met_start',
	'ATT', 'Ile',
	'CAA', 'Gln',
	'CAC', 'His',
	'CAG', 'Gln',
	'CAT', 'His',
	'CCA', 'Pro',
	'CCC', 'Pro',
	'CCG', 'Pro',
	'CCT', 'Pro',
	'CGA', 'Arg',
	'CGC', 'Arg',
	'CGG', 'Arg',
	'CGT', 'Arg',
	'CTA', 'Leu',
	'CTC', 'Leu',
	'CTG', 'Leu',
	'CTT', 'Leu',
	'GAA', 'Glu',
	'GAC', 'Asp',
	'GAG', 'Glu',
	'GAT', 'Asp',
	'GCA', 'Ala',
	'GCC', 'Ala',
	'GCG', 'Ala',
	'GCT', 'Ala',
	'GGC', 'Gly',
	'GGG', 'Gly',
	'GGT', 'Gly',
	'GGA', 'Gly',
	'GTA', 'Val',
	'GTC', 'Val',
	'GTG', 'Val',
	'GTT', 'Val',
	'TAA', 'stop',
	'TAC', 'Tyr',
	'TAG', 'stop',
	'TAT', 'Tyr',
	'TCA', 'Ser',
	'TCC', 'Ser',
	'TCG', 'Ser',
	'TCT', 'Ser',
	'TGA', 'stop',
	'TGC', 'Cys',
	'TGG', 'Trp',
	'TGT', 'Cys',
	'TTA', 'Leu',
	'TTC', 'Phe',
	'TTG', 'Leu',
	'TTT', 'Phe',
);

%abbrev = (
	'AAA', 'K',
	'AAC', 'N',
	'AAG', 'K',
	'AAT', 'N',
	'ACA', 'T',
	'ACC', 'T',
	'ACG', 'T',
	'ACT', 'T',
	'AGA', 'R',
	'AGC', 'S',
	'AGG', 'R',
	'AGT', 'S',
	'ATA', 'I',
	'ATC', 'I',
	'ATG', 'M',
	'ATT', 'I',
	'CAA', 'Q',
	'CAC', 'H',
	'CAG', 'Q',
	'CAT', 'H',
	'CCA', 'P',
	'CCC', 'P',
	'CCG', 'P',
	'CCT', 'P',
	'CGA', 'R',
	'CGC', 'R',
	'CGG', 'R',
	'CGT', 'R',
	'CTA', 'L',
	'CTC', 'L',
	'CTG', 'L',
	'CTT', 'L',
	'GAA', 'E',
	'GAC', 'D',
	'GAG', 'E',
	'GAT', 'D',
	'GCA', 'A',
	'GCC', 'A',
	'GCG', 'A',
	'GCT', 'A',
	'GGC', 'G',
	'GGG', 'G',
	'GGT', 'G',
	'GGA', 'G',
	'GTA', 'V',
	'GTC', 'V',
	'GTG', 'V',
	'GTT', 'V',
	'TAA', 'stop',
	'TAC', 'Y',
	'TAG', 'stop',
	'TAT', 'Y',
	'TCA', 'S',
	'TCC', 'S',
	'TCG', 'S',
	'TCT', 'S',
	'TGA', 'stop',
	'TGC', 'C',
	'TGG', 'W',
	'TGT', 'C',
	'TTA', 'L',
	'TTC', 'F',
	'TTG', 'L',
	'TTT', 'F',
);

@files = `ls 00_fna`;
foreach $file (@files) {
	chomp $file;
	$file =~ s/\.fna//;
	$file{$file} = 1;
	open IN, "00_fna/$file.fna";
	while (<IN>) {
		chomp;
		if (/>/) { next; }
		@array = split "";
		for ($i=0;exists $array[$i];$i+=3) {
			$codon = "$array[$i]$array[$i+1]$array[$i+2]";
			
			unless (exists $abbrev{$codon}) { next; }
			$aa = $abbrev{$codon};
			$total_aa{"$file\t$aa"}++;
			
			$count{"$file\t$codon"} ++;
			$total{$file} ++;
		}
	}
}

open OUT, ">35_codon_usage.txt";
print OUT "codon_usage";
foreach $file (sort {$a cmp $b} keys %file) { print OUT "\t$file"; }
print OUT "\n";
foreach $codon (keys %codon) {
	print OUT "$codon";
	foreach $file (sort {$a cmp $b} keys %file) {
		$rate = $count{"$file\t$codon"} / $total{$file} * 100;
		print OUT "\t$rate";
	}
	print OUT "\n";
}

open OUT, ">35_codon_usage.txt";
print OUT "codon_usage\taa\taa";
foreach $file (sort {$a cmp $b} keys %file) { print OUT "\t$file"; }
print OUT "\n";
foreach $codon (sort {$a cmp $b} keys %abbrev) {
	print OUT "$codon\t$full{$codon}\t$abbrev{$codon}";
	foreach $file (sort {$a cmp $b} keys %file) {
		$rate = $count{"$file\t$codon"} / $total{$file} * 100;
		print OUT "\t$rate";
	}
	print OUT "\n";
}

open OUT, ">35_codon_fraction.txt";
print OUT "codon_fraction";
foreach $file (sort {$a cmp $b} keys %file) { print OUT "\t$file"; }
print OUT "\n";
foreach $codon (sort {$a cmp $b} keys %abbrev) {
	print OUT "$codon";
	foreach $file (sort {$a cmp $b} keys %file) {
		$aa = $abbrev{$codon};
		$rate = $count{"$file\t$codon"} / $total_aa{"$file\t$aa"} * 100;
		print OUT "\t$rate";
	}
	print OUT "\n";
}
