#!/bin/bash

perl ~/software/BadiRate/BadiRate.pl -treefile iqtree.tre -sizefile iqtree.txt -anc -bmodel FR -family -rmodel BDI -ep CSP > iqtree.bd
