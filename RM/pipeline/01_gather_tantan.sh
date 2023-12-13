#!/usr/bin/bash -l
#SBATCH -p short -c 128 -N 1 -n 1 --mem 128gb --out logs/tantan_gather.log
CPU=128
module load parallel
module load biopython

./scripts/count_repeats_individ.py --header --input $(ls RM/*.tantan | head -n 1) | head -n 1 > repeat_summary.tsv
parallel -j $CPU ./scripts/count_repeats_individ.py --input {} ::: $(ls RM/*.tantan) >> repeat_summary.tsv
