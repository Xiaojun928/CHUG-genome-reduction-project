#!/bin/bash
#make input files for badirate
perl -ne 'chomp;$keep.="$_ ";END{`nw_prune -v iqtree.tmp $keep > iqtree.tre`}' genome_list.txt
perl -i -ne 'BEGIN{open IN,"genome_list.txt";while(<IN>){chomp;$list{$_}=1}  open IN,"iqtree.OG.txt";while(<IN>){chomp;@array=split "\t";for($i=1;exists $array[$i];$i++){if($list{$array[$i]}){$hash{$i}=1}}last;}}  chomp;@array=split "\t";print $array[0];for($i=1;exists $array[$i];$i++){if($hash{$i}){print "\t$array[$i]"}}print "\n"' iqtree.OG.txt
perl -ne 'if($.==1){print}  chomp;@array=split "\t";$total=0;foreach $count(@array){$total+=$count}if($total>=2){print "$_\n"}' iqtree.OG.txt > iqtree.txt
perl -i -pe 'if($. == 1){$_="OG$_"}' iqtree.txt
