#!/bin/bash
#SBATCH -n 16

orthofinder -og -t 16 -a 16 -S diamond -M msa -T iqtree -f input_faa -n output
