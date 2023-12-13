#!/usr/bin/bash -l
#SBATCH -p short -c 128 -N 1 -n 1 --mem 128gb --out logs/tantan.log
CPU=128
module load funannotate
module load parallel

parallel -j $CPU tantan {} \> RM/{/.}.tantan ::: $(ls DNA/*.gz)
