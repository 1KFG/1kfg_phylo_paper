#!/usr/bin/bash
#SBATCH -p gpu --mem=48g --gres=gpu:4 -N 1 -n 16 --time 72:00:00 --out logs/ASTRAL_MP_GPU.%A.log

CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPUS ]; then
    CPU=1
fi
MEM=48G
module load java/8
module load ASTRAL/5.15.4
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
  	java -Xmx${MEM} -D"java.library.path=$ASTRALDIR/lib" -jar $ASTRALJAR  -T $CPU -i $OUTDIR/$type.trees -o $OUTDIR/$PREF.$type.ASTRAL_MP.tre
    fi
done

module unload miniconda2
module load miniconda3

for file in $(ls $OUTDIR/*.ASTRAL_MP.tre); do b=$(basename $file .tre); perl ../PHYling_unified/util/rename_tree_nodes.pl $file prefix_full.tab > $OUTDIR/$b.long.tre; done
