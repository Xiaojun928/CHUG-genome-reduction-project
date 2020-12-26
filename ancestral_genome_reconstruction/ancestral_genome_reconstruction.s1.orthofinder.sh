#!/bin/bash
#SBATCH -n 32

#	initialization
threads=32

#	operation
orthofinder -og -t $threads -a $threads -S diamond -M msa -T iqtree -f 10_orthofinder -n 01_blast_folder
