#!/usr/bin/bash
#SBATCH -p batch,intel -N 1 -n 24 --mem 128gb --out logs/ASTRAL.%A.log

CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPUS ]; then
    CPU=1
fi
MEM=128G

module load ASTRAL/5.15.4
module unload miniconda2
module load miniconda3
INDIR=gene_trees
OUTDIR=gene_trees_coalescent
PREF=1KFG
pushd Phylogeny
mkdir -p $OUTDIR
for type in FT_WAG FT_LG FT_JTT VFT_WAG VFT_LG VFT_JTT; do
    if [ ! -s $OUTDIR/$type.trees ]; then
	cat $INDIR/*.$type.tre > $OUTDIR/$type.trees
    fi
    if [ ! -s $OUTDIR/$PREF.$type.ASTRAL.tre ]; then
	echo -i $OUTDIR/$type.trees -t 3 -o $OUTDIR/$PREF.$type.ASTRAL_MP.tre
	java -Xmx${MEM} -D"java.library.path=$ASTRALDIR/lib/" -jar $ASTRALJAR -T $CPU -i $OUTDIR/$type.trees -t 3 -o $OUTDIR/$PREF.$type.ASTRAL_MP.tre
    fi
done

module unload miniconda2
module load miniconda3

for file in $(ls $OUTDIR/*.ASTRAL_MP.tre); do b=$(basename $file .tre); perl ../PHYling_unified/util/rename_tree_nodes.pl $file prefix_full.tab > $OUTDIR/$b.long.tre; done
