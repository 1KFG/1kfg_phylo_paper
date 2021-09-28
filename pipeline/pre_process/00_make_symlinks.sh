#!/usr/bin/bash -l

mkdir -p Phylogeny/pep
pushd Phylogeny/pep
for file in /bigdata/stajichlab/shared/projects/1KFG/2021/JGI_freeze_2021-08-31/pep/*.fasta; do b=$(basename $file .fasta | perl -p -e 's/_(Filtered|External|broad|Gene|Broad|Maker|Frozen|PGModels1|Chagl_1_Broad|AGD|AspGD|INRA|Genoscope|JCVI)\S+//'); ln -s $file $b.aa.fasta; done

