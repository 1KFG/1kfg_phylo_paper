#!/usr/bin/bash -l
#SBATCH --ntasks 96 --mem 64G --time 2:00:00 -p short -N 1 --out logs/02_aln_step.%A.log -C xeon
module load parallel
module load miniconda3
conda activate /bigdata/stajichlab/shared/condaenv/phyling

module load workspace/scratch

pushd Phylogeny

# if you don't have $SCRATCH variable on system then ser it to /tmp or other equivalent
if [ ! -f config.txt ]; then
	echo "Need config.txt for PHYling"
	exit
fi

source config.txt
if [ ! -z $PREFIX ]; then
	echo "rm -rf aln/$PREFIX"
fi
# probably should check to see if allseq is newer than newest file in the folder?

if [ ! -s pep/allseq.ssi ]; then
	cat pep/*.aa.fasta > $SCRATCH/allseq
	esl-sfetch --index $SCRATCH/allseq
	mv $SCRATCH/allseq $SCRATCH/allseq.ssi pep
fi

../PHYling_unified/PHYling aln -q parallel
