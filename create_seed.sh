#!/bin/bash
#
# Script     : create_seed.sh
# Usage      : ./create_seed.sh
# Author     : Giuseppe Totaro
# Date       : 04-08-2015 [MM-DD-YYYY]
# Last Edited: 04-08-2015, Giuseppe Totaro
# Description: This script runs tika-app against a generic file and tries to 
#              extract URLs from text extracted using Apache Tika.
# Notes      : Please change the regular expression if you want to extract 
#              different patterns.
#

function usage()
{
	echo "Usage: created_seed.sh -i /path/to/input -o /path/to/output [-p /path/to/tika-app]"
	exit 1
}

if [ $# -lt 4 ]
then
	usage
fi

ARGS=( "$@" )

# Path to tika-app jar file
TIKA_APP=tika-app-1.7.jar
input_file=0
output_file=0

for ((i=0 ; i<${#ARGS[@]}; i++))
do
	case ${ARGS[$i]} in
		-i )	i=$(($i+1))
			INPUT=${ARGS[$i]}
			input_file=1
			;;
		-o )	i=$(($i+1))
			OUTPUT=${ARGS[$i]}
			output_file=1
			;;
		-p )	i=$(($i+1))
			TIKA_APP=${ARGS[$i]}
			;;
		* )	usage
	esac
done

# Checks if both input and output files have been provided
if [ $input_file != 1 ] || [ $output_file != 1 ]
then
	usage
fi

# Checks if tika-app jar file exits
if [ ! -f ${TIKA_APP} ]
then
	echo "Error: the script was not able to find ${TIKA_APP}. Please provide tika-app in the given path or specify another pathname in TIKA_APP variable."
	exit 1
fi

echo "Extracting URLs from ${OUTPUT} using Tika and grep command..." 

java -jar ${TIKA_APP} --text "${INPUT}" | grep -ioE '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' > "${OUTPUT}"

echo "URLs extraction completed. Output: ${OUTPUT}"
