#!/bin/bash
#
# Script     : create_backpage_seed.sh
# Usage      : ./create_backpage_seed.sh /path/to/keywords /path/to/output
# Author     : Giuseppe Totaro
# Date       : 04-14-2015 [MM-DD-YYYY]
# Last Edited: 04-14-2015, Giuseppe Totaro
# Description: This script creates a seed list using a combination of US 
#              backpage urls and keywords.
#              extract URLs from text extracted using Apache Tika.
# Notes      : keywords file must include one keyword per line.
#

if [ $# -lt 2 ] || [ ! -f $1 ] || [ -e $2 ]
then
	echo "Usage: $0 /path/to/keywords /path/to/output"
	echo "Be sure that the output file does not already exist!"
	exit 1
fi

KEYWORDS=$1
OUTPUT=$2
QUERY="/buyselltrade/?keyword="

for url in $(curl -s http://www.backpage.com/ | sed -n '/<div class=\"united-states geoBlock\">/,/<div class=\"canada geoBlock\">/p' | grep -ioE '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]')
do
	while read line
	do
		echo ${url}${QUERY}${line// /%20} >> "$OUTPUT"
	done < "$KEYWORDS"
done
