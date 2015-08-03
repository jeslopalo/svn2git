#!/bin/sh

set -e

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m' # No Color



echo -e "\n\nWe are going to clone SVN repository directly using git svn clone!"


confirmation="M"
while [ "$confirmation" != "Y" ] && [ "$confirmation" != "y" ]; do
        echo -e "What is the SVN url?: "
        read -e svn_url

        echo -e "It is ${green}$svn_url${NC} url correct? [Yy]: "
        read -e confirmation
done

if [ "$svn_url" == "" ]; then
        echo -e "${red}GAME OVER!${NC} Sorry, an SVN url is mandatory!"
        exit
fi


confirmation="N"
while [ "$confirmation" != "Y" ] && [ "$confirmation" != "y" ]; do
        echo -e "What is the authors/commiters translation file? [default none]: "
        read -e authors_file

        if [ "$authors_file" == "" ] || ![ -f "$authors_file" ] ]; then
            echo -e "Are you sure that you dont want to provide a commiters translation file? [Yy]: "
        else
            echo -e "It is ${green}$authors_file${NC} correct? [Yy]: "
        fi
        read -e confirmation
done

if [ "$authors_file" == "" ]; then
        git svn clone $svn_url --stdlayout --no-metadata ./git-svn-repo
        exit
else
        git svn clone $svn_url --stdlayout --no-metadata -A $authors_file ./git-svn-repo
        exit
fi


