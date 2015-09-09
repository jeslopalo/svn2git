#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

WORKING_DIRECTORY="temporal-svngit-repo"

usage() {
    echo "usage: ./migrate-to-git.sh svn_url git_url [authors-file]"
}

check_svn_repository() {
    local url="$1"

    svn ls $url --depth empty
    echo $?
}

check_git_repository() {
    local url="$1"

    git ls-remote -h $url HEAD
    echo $?
}

migrate_tags() {

    for tag in `git branch -r | grep tags `; do
        tagname=`echo $tag | sed 's/.*\///'`;
        echo -e "Creando un Tag a partir del branch:\t$tag,\ttagname: $tagname...";
        echo -e "${YELLOW}"
        git tag $tagname $tag
        git branch -r -d $tag
        echo -e "${NC}"
    done

    # Deleting trunk branch reference
    for branch in `git branch -r | grep trunk `; do
	echo -e "Eliminando la rama $branch...";
    	echo -e "${YELLOW}"
    	git branch -r -d $branch
    	#git branch -r -d trunk
    	echo -e "${NC}"
    done

    echo -e "\nBranches:"
    git branch -a
    echo -e "\nTags:${GREEN}"
    git tag
    echo -e "${NC}\n"
}

pushing_to_origin() {

    echo -e "Estableciendo un nuevo remote (origin: $git_url)"
    echo -e "${YELLOW}"
    git remote add origin $git_url
    echo -e "${NC}"

    echo -e "Pushing master al remote origin..."
    echo -e "${YELLOW}"
    git push origin master
    echo -e "${NC}"

    echo -e "Pushing tags al remote origin..."
    echo -e "${YELLOW}"
    git push --tags
    echo -e "${NC}"

    echo -e "Pushing branches al remote origin..."
    echo -e "${YELLOW}"
    for remote in `git branch -a | grep -v master `; do
	    echo -e "Checkouting branch: $remote"
	    git checkout --track $remote;
    done
    git push --all
    echo -e "${NC}"
}

if [ $# -lt 2 ]; then
    usage
    exit 1
fi

svn_url=$1
git_url=$2

authors_file="authors"
if [ $# -gt 1 ]; then
    authors_file=$3
fi

# Check if svn repository exists
if [ "$(check_svn_repository $svn_url)" != 0 ]; then
    echo -e "\nEl repositorio $svn_url no existe o no es accesible"
    exit 1
fi

# Check if git repository exists
if [ "$(check_git_repository $git_url)" != 0 ]; then
    echo -e "\nEl repositorio $git_url no existe o no es accesible"
    exit 1
fi

set -e
echo -e

if [ -d $WORKING_DIRECTORY ]; then
    echo -e "Eliminando el directorio temporal $WORKING_DIRECTORY de una ejecución anterior..."
    rm -rf $WORKING_DIRECTORY
fi

# Cloning the SVN Repository
if [ -f "$authors_file" ]; then
    echo -e "Clonando el repositorio SVN cómo si de uno Git se tratara, haciendo uso del diccionario de commiters $authors_file..."
    echo -e "${YELLOW}"
    git svn clone $svn_url --stdlayout --no-metadata -A $authors_file ./$WORKING_DIRECTORY
    echo -e "${NC}"
else
    echo -e "Clonando el repositorio SVN cómo si de uno Git se tratara..."
    echo -e "${YELLOW}"
    git svn clone $svn_url --stdlayout --no-metadata ./$WORKING_DIRECTORY
    echo -e "${NC}"
fi

# Changing to working directory
cd $WORKING_DIRECTORY

# Migrating tags
migrate_tags

# Pushing to origin
pushing_to_origin

# Changing to initial directory
cd - &>/dev/null

# Deleting working directory
rm -rf $WORKING_DIRECTORY

echo -e "\nSe ha migrado el repositorio SVN ($svn_url) a Git ($git_url)!"
echo -e "\nPara comenzar a trabajar puede clonar con:"
echo -e "\n\t${GREEN}git clone $git_url${NC}\n"
