#!/bin/bash
#
# Script     : create_backpage_seed.sh
# Usage      : ./create_backpage_seed.sh /path/to/keywords /path/to/output
# Usage      : ./create_backpage_seed.sh -k /path/to/keywords -o /path/to/output [-c category] [-e]
# Author     : Giuseppe Totaro
# Date       : 04-14-2015 [MM-DD-YYYY]
# Last Edited: 04-24-2015, Giuseppe Totaro
# Description: This script creates a seed list by combining URLs extracted from 
#              www.backpage.com with keywords. Optionally, this script extracts 
#              URLs related to the search results and then creates a seed list 
#              using those URLs (option '-e').
# Notes      : The 'keywords' file must include one keyword per line.
#

function usage() {
	echo "Usage: create_backpage_seed.sh -k /path/to/keywords -o /path/to/output [-c category] [-e]"
	exit 1
}

INPUT=""
OUTPUT=""
CATEGORY="buyselltrade"
EXTRACT=false

while [ "$1" != ""  ]
do
	case $1 in
		-k|--keywords)
		KEYWORDS="$2"
		shift
		;;
		-o|--output)
		OUTPUT="$2"
		shift
		;;
		-c|--category)
		CATEGORY=$2
		shift
		;;
		-e|--extract)
		EXTRACT=true
		shift
		;;
		*)
		usage
		;;
	esac
	shift
done

if [ $KEYWORDS == "" ] || [ $OUTPUT == "" ]
then
	usage
fi

if [ -f $OUTPUT ]
then
	echo "Error: output file already exists!"
	exit 1
fi

QUERY="${CATEGORY}/?keyword="
if [ $EXTRACT = true ]
then
	$TMPFILE=$(mktemp "${OUTPUT}".XXXXXXXXXX) || { echo "Error: failed to create temp file"; exit 1; }
fi

echo "Fetching URLs from '${CATEGORY}' category on backpage..."

for url in $(curl -s http://www.backpage.com/ | sed -n '/<div class=\"united-states geoBlock\">/,/<div class=\"canada geoBlock\">/p' | grep -ioE '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]')
do
	while read line
	do
		# ignores if line starts with # (comment)
		[[ $line == "#"* ]] && continue
		# checks whether extraction of results is enabled
		if [ $EXTRACT = false ]
		then
			echo ${url}${QUERY}${line// /%20} >> "$OUTPUT"
		else
			echo "Extracting results from ${url}${QUERY}${line// /%20}"
			for result in $(curl -s ${url}${QUERY}${line// /%20} | sed -n '/<span class=\"summaryHeader\">/,/<\/span>/p' | grep -ioE '\b(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]')
			do
				echo ${result} >> $TMPFILE
			done
		fi
	done < "$KEYWORDS"
done

if [ ! -f $OUTPUT ]
then
	echo "Error: the output file has not been created!"
	exit 1
fi

if [ $EXTRACT = true ]
then
	sort "$TMPFILE" | uniq -i > "$OUTPUT"
	rm -f "$TMPFILE"
fi

echo "Completed. Output: $OUTPUT"
