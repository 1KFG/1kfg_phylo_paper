#!/usr/bin/env python3
import csv,re

infile="lib/jgi_names.csv"
outfile="lib/jgi_names.tab"
enc = 'iso-8859-15'
with open(infile,"rt",encoding=enc) as ifh:
    with open(outfile,"w") as ofh:
        reader = csv.reader(ifh,delimiter=",")
        writer = csv.writer(ofh,delimiter="\t",lineterminator='\n')
        names = []
        for line in reader:
            if line[0].startswith("#"):
                continue
#            print(line)
            name=re.sub(" ","_",line[1])
            name=re.sub(r'[\?;,/\r]',"",name)
            name=re.sub(r'__','_',name)
            name=re.sub(r'[\(\)]','',name)
            names.append([line[2],name])
        for row in sorted(names):
            writer.writerow(row)
