#!/bin/bash

perl ~/software/BadiRate/BadiRate.pl -treefile prune.tre -sizefile iqtree.txt -anc -bmodel FR -family -rmodel BDI -ep CSP > iqtree.bd
