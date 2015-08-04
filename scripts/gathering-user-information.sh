#!/bin/sh

set -e

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m' # No Color



echo -e "\n\nWe are going to extract commiters data from SVN repository!"


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

echo -e "${yellow}Checking out from svn repository $svn_url in repo directory${NC}..."
if [ -d "repo" ]; then
        echo -e "${red}GAME OVER!${NC} Sorry, a ${green}repo${NC} directory already exists, please delete it and start agein."
        exit
fi
svn co $svn_url repo

echo -e "${yellow}Changing directory to `pwd`/repo ${NC}..."
cd repo

echo -e "${yellow}Extracting commit authors${NC}..."
svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > ../authors.txt

echo -e "${yellow}Changing to initial directory...${NC}"
cd - &>/dev/null

echo -e "\nThere is a new file ${green}`pwd`/authors.txt${NC} with committers' data!"