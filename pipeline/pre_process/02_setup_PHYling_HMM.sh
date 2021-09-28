#!/usr/bin/bash -l
#SBATCH -p short

BUSCODB=https://busco-data.ezlab.org/v4/data/lineages/fungi_odb10.2020-09-10.tar.gz

mkdir -p Phylogeny/HMM/
pushd Phylogeny/HMM/
if [ ! -d fungi_odb10 ]; then
	curl https://busco-data.ezlab.org/v4/data/lineages/fungi_odb10.2020-09-10.tar.gz | tar zxf -
fi
cd fungi_odb10
ln -s hmms HMM3
module load hmmer/3
cat HMM3/*.hmm > markers_3.hmm
hmmconvert -b markers_3.hmm > markers_3.hmmb

