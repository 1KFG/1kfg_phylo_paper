#!/usr/bin/bash -l
#SBATCH -p short  --mem 32gb -c 96 --out logs/preprocess_ncbi.log

# assumes already have run NCBI_fungi processing in the sub-folder
TOPFOLDER=$(realpath NCBI_fungi/source/NCBI_ASM)
TARGET=source/NCBI
CPU=$SLURM_CPUS_ON_NODE
if [ -z "${CPU}" ]; then
    CPU=1
fi
for t in cds pep DNA
do
	mkdir -p $TARGET/$t
done

ln -s $(ls $TOPFOLDER/*/*_genomic.fna.gz | grep -P -v '_(cds|rna)_from_genomic') $TARGET/DNA/

# we could still have same locus 2x so need to check on that in processing
fixheader() {
	f="$1"
	OUT="$2"
	pigz -dc $f | perl -p -e 's/>(\S+).+\[locus_tag=([^\]]+)\]/>$2 $1/' | pigz -c > $OUT/$(basename $f)
}
export -f fixheader
parallel -j $CPU fixheader {} $TARGET/cds ::: $(ls $TOPFOLDER/*/*_cds_from_genomic.fna.gz)
parallel -j $CPU fixheader {} $TARGET/pep ::: $(ls $TOPFOLDER/*/*_translated_cds.faa.gz)

