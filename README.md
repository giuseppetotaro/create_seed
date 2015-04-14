# create_seed

This repository includes bash scripts that perform pattern matching against files or webpages aiming at extracting URLs and providing a seed list. The following scripts are provided:

* *create_seed.sh* creates a URL seed list with URLs extracted from a generic file. This script uses [Apache Tika](http://tika.apache.org/) (more in detail, the tika-app jar file) to extract textual content from the input file, and Unix [grep](http://www.gnu.org/software/grep/) command to search URL using the specified pattern. This script needs the tika-app jar file. The latest stable release of tika-app jar file can be downloaded [online](http://tika.apache.org/download.html).

* *create_backpage_seed.sh* creates a URL seed list with (US) URLs extracted from backpage.com webpage. Each URL is combined with the keywrds included in the given file. This script uses the Unix command-line tools [sed](http://www.gnu.org/software/sed/) and [grep](http://www.gnu.org/software/grep/).

All these scripts aim at creating a URLs list (one URL per line) that can be used as seed list for [Apache Nutch](https://wiki.apache.org/nutch/NutchTutorial#Create_a_URL_seed_list).

## Getting Started

*create_seed.sh* is a bash script that allows to extract URLs from text extracted from a generic file by using Tika and grep command.

To launch create_seed.sh, use the following command:

> ./create_seed.sh -i /path/to/input -o /path/to/output

By default, the script looks for tika-app jar file in the current folder. Optionally, a different pathname for tika-app can be specified using the following command-lline option:

> ./create_seed.sh -i /path/to/input -o /path/to/output -p /path/to/tika-app

*create_backpage_seed.sh* is a bash script that allows to extract URLs from backpage.com webpage combining US addresses with a list of keywords.

To launch create_backpage_seed.sh, use the following command:

> ./create_backpage_seed.sh /path/to/keywords /path/to/output

## Pattern matching

Pattern matching is perfomed using the Unix *grep* command. More in detail, URLs are detected using the following regular expression:

> grep -ioE '\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'

Searching for different URL patterns is possible by changing the regular expression.
