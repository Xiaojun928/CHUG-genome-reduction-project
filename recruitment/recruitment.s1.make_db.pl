`cat 01_ref_merged/GNM*.fasta > 01_ref_merged/total.fasta`;
`makeblastdb -dbtype nucl -in 01_ref_merged/total.fasta`;
`bowtie2-build 01_ref_merged/total.fasta 01_ref_merged/total.fasta`;
