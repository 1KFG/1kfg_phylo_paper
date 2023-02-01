#!/usr/bin/bash
#SBATCH -N 1 -n 16 --mem 24gb --out logs/gene_tree_VFT.%a.log -p short -C xeon

module load veryfasttree
pushd Phylogeny

if [ -f config.txt ]; then
	source config.txt
else
	echo "Need config for outgroup and prefix"
	exit
fi

CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
	CPU=1
fi

N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
    N=$1
    if [ -z $N ]; then
        echo "Need an array id or cmdline val for the job"
        exit
    fi
fi

OUTDIR=gene_trees
ALN=$ALN_OUTDIR/$HMM
FILEEXT=aa.clipkit
mkdir -p $OUTDIR
FILE=$(ls $ALN/*.${FILEEXT} | sed -n ${N}p )
if [ ! $FILE ]; then
 echo "No input file - check $SLURM_ARRAY_TASK_ID or input number, N=$N FOLDER=$ALN ext=$FILEEXT"
 exit
fi
PHY=$FILE
base=$(basename $FILE .$FILEEXT)
OUTPHY=${base}.mfa
perl -p -e 's/>([^\|]+)\|/>$1 /' $PHY > $OUTDIR/$OUTPHY
if [ ! -s $OUTDIR/$base.VFT_WAG.tre ]; then
	VeryFastTree.AVX2 -threads $CPU -ext avx2 -wag -gamma -mllen -log $OUTDIR/$base.VFT_WAG_topology.log < $OUTDIR/$OUTPHY > $OUTDIR/$base.VFT_WAG.tre
fi
if [ ! -s $OUTDIR/$base.VFT_LG.tre ]; then
	VeryFastTree.AVX2 -threads $CPU -lg -gamma -mllen -log $OUTDIR/$base.VFT_LG_topology.log < $OUTDIR/$OUTPHY > $OUTDIR/$base.VFT_LG.tre
fi
if [ ! -s $OUTDIR/$base.VFT_JTT.tre ]; then
	VeryFastTree.AVX2 -threads $CPU -gamma -mllen -log $OUTDIR/$base.VFT_JTT_topology.log  < $OUTDIR/$OUTPHY > $OUTDIR/$base.VFT_JTT.tre
fi
