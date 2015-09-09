#!/bin/bash

set -e

red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color

SUFFIX=".git"
REPOSITORY_URL_PREFIX="desaweb.corpme.es/git"

echo -e "\n\n¡Vamos a crear un ${red}nuevo repositorio GIT${NC}!"



confirmation="M"
while [ "$confirmation" != "Y" ] && [ "$confirmation" != "y" ]; do
	echo -e "Nombre del repositorio (ejemplos: library, cool-library, common/cool-library): "
	read -e repository_name

	echo -e "¿Es${green} ${REPOSITORY_URL_PREFIX}/$repository_name${SUFFIX} ${NC}el nombre que quieres? [Yy]: "
	read -e confirmation
done

if [ -d $repository_name$SUFFIX ]; then
	echo -e "${red}¡GAME OVER!${NC} Lo siento pero ese repositorio ya existe."
	exit
fi

echo -e "\nCreando el directorio ${green} $repository_name ${NC}..."
mkdir -p $repository_name$SUFFIX

cd $repository_name$SUFFIX
git init --bare --shared

echo -e "\n¡El repositorio ${green}$repository_name${NC} ha sido creado e iniciado!"
echo -e "Para empezar a trabajar puedes clonar en tu máquina con: ${green}git clone ssh://[username]@${REPOSITORY_URL_PREFIX}/${repository_name}${SUFFIX}${NC}\n"

