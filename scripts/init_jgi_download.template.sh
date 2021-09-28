#!/usr/bin/bash
#SBATCH -p stajichlab --ntasks 1 --nodes 1 --mem 2G --time 8:00:00 -o download_fungixml.log
USERNAME=xxUSERNAMExx
PASSWORD=xxPASSWORDxx
module unload miniconda2
module load miniconda3

curl 'https://signon.jgi.doe.gov/signon/create' --data-urlencode "login=$USERNAME" --data-urlencode "password=$PASSWORD" -c cookies > /dev/null

curl -b cookies -o lib/jgi_names.csv 'https://mycocosm.jgi.doe.gov/ext-api/mycocosm/catalog/download-group?flt=&pub=all&grp=fungi&srt=released&ord=desc'

python3 scripts/jginames_to_tab.py
perl scripts/make_taxonomy_table_jginames.pl  lib/jgi_names.tab  > lib/jgi_names_taxonomy.csv
