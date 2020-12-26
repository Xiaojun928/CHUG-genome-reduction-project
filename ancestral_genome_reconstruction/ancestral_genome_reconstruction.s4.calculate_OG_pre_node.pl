#tree line
`nohup dos2unix 00_seq_folder/*faa 00_seq_folder/Results_01_blast_folder/*`;
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

#og lines
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
			$hash{$count} += ($num_og)? 1 : 0;
		}
	}
}

#output;
open OUT, ">result1.nodeID.tre";
print OUT $TREE;

open IN, "iqtree.bd";
open OUT, ">result1.total_gene.tre";
while (<IN>) {
	if (s/\t\tTotal Ancestral Size\t//) {print OUT}
}

open OUT, ">result1.total_OG.tre";
for ($count=1, $tree=$TREE; $tree =~ s/\)(node\d+)[:;]/)pro$hash{$count}tect:/; $count++) {}
$tree =~ s/pro(\d+)tect/$1/g;
$tree =~ s/:$/;/;
print OUT $tree;





