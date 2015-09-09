#!/bin/bash

usage() {
    echo "usage: ./extract-users-from-repositories.sh svn_host repositories_path svn_url_prefix [output file]"
}

if [ $# -lt 3 ]; then
    usage
    exit 1
fi

SCRIPT_DIRECTORY="$(dirname "$(readlink -f "$0")")"
YELLOW='\033[0;33m'
NC='\033[0m' # No Color


svn_host=$1
repositories_path=$2
svn_url_prefix=$3

output_file="authors"
if [ $# -gt 3 ]; then
    output_file=$4
fi

set -e

REPOSITORY_NAMES_FILE="repositories.tmp"

repository_names() {
    local svn_host=$1
    local repositories_path=$2
    local repository_names_file=$3

    ssh $svn_host ls -1A $repositories_path | grep -v ^passwd.*$ > $repository_names_file
}

if [[ ! -f $REPOSITORY_NAMES_FILE ]] || [[ ! -s $REPOSITORY_NAMES_FILE ]]; then
    echo -e "Buscando los repositorios del servidor SVN..."
    $(repository_names $svn_host $repositories_path $REPOSITORY_NAMES_FILE)
else
    echo -e "Continuando con la ejecución anterior..."
fi
repositories=`cat $REPOSITORY_NAMES_FILE`

for repository in $repositories; do
    echo -e "\n\n${YELLOW}Extrayendo usuarios del repositorio $svn_url_prefix/$repository ...${NC}"
    $SCRIPT_DIRECTORY/extract-users.sh $svn_url_prefix/$repository $output_file

    # Remove the first line
    sed -i '1d' $REPOSITORY_NAMES_FILE
done

rm "$REPOSITORY_NAMES_FILE"