print "perl this.pl input.tre\n";

($tre = $ARGV[0]) =~ s/.tre$//;
open IN, "$tre.tre";
`cp $tre.tre $tre.tre.txt`;
open OUT, ">$tre.sort.tre";
open OUTT, ">$tre.sort.tre.txt";

while (<IN>) {
	chomp;
	
	#while match a sister clade
	while (/\(([^(]+?)\)/) {
		#if contain 3+ clades
		$now = $1;
		$clades = ($now =~ tr/,/,/);
		if ($clades > 1) {
			($change = $now) =~ tr/:,/#&/;
			s/\($now\)/\{$change\}/;
			print OUTT "3+clade\t$now\t$change\n";
			next;
		}
		#extract information for cladeA and cladeB
		($A, $B) = split ',', $now;
		($a, $av) = split ':', $A;
		($b, $bv) = split ':', $B;
		$numA = ($a=~tr/&/&/);
		$numB = ($b=~tr/&/&/);
		#if number of leaf node from cladeA and cladeB are not same
		if ($numA > $numB) {
			$change = "$a#$av&$b#$bv";
			print OUTT "($now)\t$a\t$b\t$av\t$bv\t{$change}\n";
		}
		elsif ($numA < $numB) {
			$change = "$b#$bv&$a#$av";
			print OUTT "($now)\t$a\t$b\t$av\t$bv\t{$change}\n";
		}
		#if number of leaf node from cladeA and cladeB are same
		#then compare length
		else {
			$change = ($av > $bv)? "$a#$av&$b#$bv" : "$b#$bv&$a#$av";
			print OUTT "($now)\t$a\t$b\t$av\t$bv\t{$change}\n";
		}
		s/\($now\)/\{$change\}/;
	}
	s/{/(/g;
	s/}/)/g;
	s/\&/,/g;
	s/#/:/g;
	print OUT;
	print OUTT;
}
