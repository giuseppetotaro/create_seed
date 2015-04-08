# create_seed

Bash script (*create_seed.sh*) that creates a URL seed list with URLs extracted from a generic file. The URL seed list is written to output file (one URL per line) that can be used as URL list for [Apache Nutch](https://wiki.apache.org/nutch/NutchTutorial#Create_a_URL_seed_list).
This script uses the following tools:
* [Apache Tika](http://tika.apache.org/) (more in detail, tika-app jar file) to extract textual content from the input file
* Unix [grep](http://www.gnu.org/software/grep/) command to search URL using the specified pattern (see below)

This script needs the tika-app jar file. The latest stable release of tika-app jar file can be downloaded [online](http://tika.apache.org/download.html).

## Getting Started

*create_seed.sh* is a bash script that allows to extract URLs from text extracted from a generic file by using Tika and grep command.

To launch create_seed.sh, use the following command:

> ./create_seed.sh -i /path/to/input -o /path/to/output

By default, the script looks for tika-app jar file in the current folder. Optionally, a different pathname for tika-app can be specified using the following command-lline option:

> ./create_seed.sh -i /path/to/input -o /path/to/output -p /path/to/tika-app

## Pattern matching

Pattern matching is perfomed using the Unix *grep* command. More in detail, URLs are detected using the following regular expression:

> grep -ioE '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'

Searching for different URL patterns is possible by changing the regular expression.
