#!/bin/sh

set -e

red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color



echo -e "\n\nWe are going to migrate a SVN repository to GIT!"



confirmation="M"
while [ "$confirmation" != "Y" ] && [ "$confirmation" != "y" ]; do
        echo -e "What is the SVN url?: "
        read -e svn_url

        echo -e "It is ${green}$svn_url${NC} url correct? [Yy]: "
        read -e confirmation
done

if [ "$svn_url" == "" ]; then
        echo -e "${red}¡GAME OVER!${NC} I need a SVN url"
        exit
fi

#echo -e "\nCreando el directorio ${green} $repository_name ${NC}..."
#mkdir -p $repository_name

#cd $repository_name
#git init --bare --shared

#echo -e "\n¡El repositorio ${green}$repository_name${NC} ha sido creado e iniciado!"
#echo -e "Para empezar a trabajar puedes clonar en tu máquina con: ${green}git clone ssh://[username]@desa-arce.corpme.es/home/usuario/git/$repository_name${NC}\n"

#echo "Gathering user information from [$1] svn repository..."
