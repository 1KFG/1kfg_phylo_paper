#!/usr/bin/bash -l
#SBATCH -p short  --mem 32gb -c 96

# assumes already have run NCBI_fungi processing in the sub-folder
TOPFOLDER=$(realpath NCBI_fungi/source/NCBI_ASM)
TARGET=source/JGI
CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPUS ]; then
    CPU=1
fi
for t in cds pep DNA
do
	mkdir -p $TARGET/$t
done

