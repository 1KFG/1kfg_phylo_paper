#!/usr/bin/env python3
from Bio import SeqIO
import sys
import os
import csv
import re

import argparse

parser = argparse.ArgumentParser(prog="count_repeats.py", description="A program to count repeats")
parser.add_argument("--input", required=True,help="Input file", type=str)
parser.add_argument("--ext", default='tantan',help="Extension of output file", type=str)
parser.add_argument("--accfile",default="ncbi_accessions_taxonomy.csv",type=str)
parser.add_argument("--header",default=False, action='store_true')


args = parser.parse_args()
acc2names={}
header = []
with open(args.accfile,"rt") as infh:
    inacc = csv.reader(infh,delimiter=",")
    header = next(inacc)
    for row in inacc:
        acc2names[row[0]] = row[1:]
outtsv = csv.writer(sys.stdout,delimiter="\t")
if args.header:
    headerrow = ['ASSEMBLY','SIZE','REPEAT_SIZE','REPEAT_PERCENT']
    headerrow.extend(header[1:])
    outtsv.writerow(headerrow)

dfile = args.input
stem=re.sub(r'_genomic\.fna\S*','',os.path.basename(dfile))
size = 0
repeat_size = 0
for seq_record in SeqIO.parse(dfile, "fasta"):
    size += len(seq_record.seq)
    for s in seq_record.seq:
        if s.islower():
            repeat_size += 1
outrow = [stem,"%.2f"%(size/1000000),"%.2f"%(repeat_size/1000000),'%.2f'%(100*repeat_size/size)]
outrow.extend(acc2names[stem])
outtsv.writerow(outrow)
