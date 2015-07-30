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

#echo -e "${yellow} ${NC}..."
echo -e "${yellow}Checking out from svn repository $svn_url in repo directory${NC}..."
if [ -d "repo" ]; then
        echo -e "${red}GAME OVER!${NC} Sorry, a ${green}repo${NC} directory already exists, please delete it and start agein."
        exit
fi
svn co $svn_url repo

echo -e "${yellow}Changing directory to `pwd`/repo ${NC}..."
cd repo

echo -e "${yellow}Extracting commit authors${NC}..."
svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > authors-transform.txt

#echo -e "\nCreando el directorio ${green} $repository_name ${NC}..."
#mkdir -p $repository_name

#cd $repository_name
#git init --bare --shared

#echo -e "\n¡El repositorio ${green}$repository_name${NC} ha sido creado e iniciado!"
#echo -e "Para empezar a trabajar puedes clonar en tu máquina con: ${green}git clone ssh://[username]@desa-arce.corpme.es/home/usuario/git/$repository_name${NC}\n"

#echo "Gathering user information from [$1] svn repository..."
