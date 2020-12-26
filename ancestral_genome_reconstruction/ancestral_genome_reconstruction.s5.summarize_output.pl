#tree line
open IN, "iqtree.bd";
<IN>;
while (<IN>) {
	chomp;
	s/(GNM\d+)_\d+/$1/g;
	while (s/\)(\d+)([:;])/)node$1$2/) {
		$count++;
		$node{$count} = "node$1";
	}
	$TREE = $_;
	last;
}

#gnm OG list
open IN, "iqtree.txt";
while (<IN>) {
	chomp;
	s/(GNM\d+)_\d+/$1/g;
	@title = split "\t";
	last;
}
open IN, "iqtree.txt";
<IN>;
while (<IN>) {
	chomp;
	s/(GNM\d+)_\d+/$1/g;
	@array = split "\t";
	$LIST_OG .= "$array[0]\t";
	for ($i=1; exists $title[$i]; $i++) {
#		$gnm_OG{$title[$i]} .= ($array[$i]) ? "1\t" : "0\t";
		$gnm_OG{$title[$i]} .= "$array[$i]\t";
	}
}

#node OG list
open IN, "iqtree.bd";
while (<IN>) {
	chomp;
	s/(GNM\d+)_\d+/$1/g;
	if(/(OG\d+)\t(.*)$/) {
		($og, $tree) = ($1, $2);
		$count = 0;
		while ($tree =~ s/\)(\d+)[:;]//) {
			$num_og = $1;
			$count++;
#			$gnm_node{$node{$count}} .= ($num_og) ? "1\t" : "0\t";
			$gnm_node{$node{$count}} .= "$num_og\t";
		}
	}
}

#find parent
$tree = $TREE;
open OUT, ">result2.parent_summary.txt";
print OUT "child\tparent\tOG\tadd\tdelete\tplus\tminus\n";
open FAMILY, ">result2.parent_family.txt";
open FAMILY_TOTAL, ">result2.parent_family.total.txt";
print FAMILY "child\tparent\tOG\ttype	number\n";
print FAMILY_TOTAL "child\tparent\tOG\ttype	number\n";
while ($tree =~ s/^(.*)\((\w+?):.*?,(\w+?):.*?\)(\w+?)[:;](.*)$/$1$4:$5/) {
	($CHILD1, $CHILD2, $parent) = ($2, $3, $4);
	foreach $CHILD ($CHILD1, $CHILD2) {
		($child = $CHILD) =~ s/(GNM\d+)_\d+/$1/;
		$parent{$child} = $parent;
		$child_og = ($child =~ /GNM/) ? $gnm_OG{$child} : $gnm_node{$child};
		$parent_og = $gnm_node{$parent};
		@child_og = split "\t", $child_og;
		@parent_og = split "\t", $parent_og;
		@list_og = split "\t", $LIST_OG;
		for ($i=0, $add=0, $del=0, $total=0, $plus=0, $minus=0, $nochange=0; exists $parent_og[$i]; $i++) {
			$total += ($child_og[$i]) ? 1 : 0;
			if ($parent_og[$i] == 0 and $child_og[$i] == 0) {next}
			elsif ($parent_og[$i] == 0 and $child_og[$i]) {
				$add++;
				print FAMILY "$CHILD\t$parent\t$list_og[$i]\tadd	$child_og[$i]\n";
				print FAMILY_TOTAL "$CHILD\t$parent\t$list_og[$i]\tadd	$child_og[$i]	$parent_og[$i]\n";
			}
			elsif ($parent_og[$i] and $child_og[$i] == 0) {
				$del++;
				print FAMILY "$CHILD\t$parent\t$list_og[$i]\tdel	-$parent_og[$i]\n";
				print FAMILY_TOTAL "$CHILD\t$parent\t$list_og[$i]\tdel	$child_og[$i]	$parent_og[$i]\n";
			}
			elsif ($parent_og[$i] < $child_og[$i]) {
				$plus++;
				$temp_count = $child_og[$i] - $parent_og[$i];
				print FAMILY "$CHILD\t$parent\t$list_og[$i]\tplus	$temp_count\n";
				print FAMILY_TOTAL "$CHILD\t$parent\t$list_og[$i]\tplus	$child_og[$i]	$parent_og[$i]\n";
			}
			elsif ($parent_og[$i] > $child_og[$i]) {
				$minus++;
				$temp_count = $parent_og[$i] - $child_og[$i];
				print FAMILY "$CHILD\t$parent\t$list_og[$i]\tminus	-$temp_count\n";
				print FAMILY_TOTAL "$CHILD\t$parent\t$list_og[$i]\tminus	$child_og[$i]	$parent_og[$i]\n";
			}
			else {
				$nochange++;
				$temp_count = $parent_og[$i] - $child_og[$i];
				print FAMILY_TOTAL "$CHILD\t$parent\t$list_og[$i]\tnochange	$child_og[$i]	$parent_og[$i]\n";
			}
		}
		#output
		print OUT "$CHILD\t$parent\t$total\t+$add\t-$del\t+$plus\t-$minus\n";
	}
}

#most parent node
open IN, "iqtree.bd";
$total = 0;
while (<IN>) {
	chomp;
	s/(GNM\d+)_\d+/$1/g;
	unless (/\t\tOG/) {next}
	if (/\)(\d+);/) {
		$gene = $1;
		$total += ($gene == 0) ? 0 : 1
	}
}
print OUT "$parent\t$parent\t$total\n";