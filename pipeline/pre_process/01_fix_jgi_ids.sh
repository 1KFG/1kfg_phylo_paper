#!/usr/bin/bash -l
#SBATCH -p short -N 1 -n 16 --mem 8gb
module load parallel

pushd JGI_freeze_2021-08-31
if [ ! -d pep.backup ]; then
	rsync -a pep/ pep.backup/
fi
parallel -j 8 pigz {} ::: $(ls pep.backup/*.fasta)

# could also use parallel here but its also pretty fast
perl -i -p -e 's/>jgi\|(\S+)\|(\d+)\|/>$1|$1_$2 /' pep/*.fasta
