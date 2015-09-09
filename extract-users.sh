#!/bin/bash

usage() {
    echo "usage: ./extract-users.sh svn_url [output file]"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

svn_url=$1

output_file="authors"
if [ $# -gt 1 ]; then
    output_file=$2
fi

set -e
echo -e

if [ -d "temporal-svn-repo" ]; then
    echo -e "Eliminando el directorio temporal temporal-svn-repo de una ejecución anterior..."
    rm -rf temporal-svn-repo
fi

echo -e "Extrayendo los usuarios del repositorio svn $svn_url en el fichero $output_file ..."
svn co $svn_url temporal-svn-repo 1>/dev/null

#Changing directory to temporal-svn-repo
cd temporal-svn-repo

#Extracting commit authors
svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > temporal_authors

#Changing to initial directory
cd - &>/dev/null

#Logging new authors
echo -e "\nCommiters encontrados: "
cat temporal-svn-repo/temporal_authors

#Appending new authors
cat temporal-svn-repo/temporal_authors >> "$output_file"

#Deleting duplicates
sort -u "$output_file" -o "$output_file"

#Deleting working directory
rm -rf temporal-svn-repo

echo -e "\nSe han añadido los nuevos commiters al fichero $output_file"
