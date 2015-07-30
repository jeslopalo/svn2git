#!/bin/sh

set -e

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m' # No Color



echo -e "\n\nWe are going to push to origin!"



confirmation="N"
while [ "$confirmation" != "Y" ] && [ "$confirmation" != "y" ]; do
	echo -e "Where is the local repository directory? [`pwd`]: "
	read -e local_repository

	if [ "$local_repository" == "" ]; then
		local_repository=`pwd`
	fi

	echo -e "It is ${green}$local_repository${NC} the local repository directory? [Yy]: "
	read -e confirmation
done

confirmation="M"
while [ "$confirmation" != "Y" ] && [ "$confirmation" != "y" ]; do
        echo -e "What is the GIT url?: "
        read -e git_url

        echo -e "It is ${green}$git_url${NC} url correct? [Yy]: "
        read -e confirmation
done

if [ "$git_url" == "" ]; then
        echo -e "${red}¡GAME OVER!${NC} I need a valid GIT url"
        exit
fi

echo -e "${yellow}Changing to $local_repository directory...${NC}"
cd $local_repository

echo -e "${yellow}Adding $git_url as a new remote...${NC}"
git remote add origin $git_url

echo -e "${yellow}Pushing master to origin...${NC}"
git push origin master

echo -e "${yellow}Pushing tags to origin...${NC}"
git push --tags

echo -e "${yellow}Pushing branches to origin...${NC}"
for remote in `git branch -r | grep -v master `; do 
	git checkout --track $remote ; 
done
git push --all


echo -e "${yellow}Changing to initial directory...${NC}"
cd -

echo -e "\nThe repository has been pushed up to origin [${green}$git_url${NC}] successfuly!"
#echo -e "Para empezar a trabajar puedes clonar en tu máquina con: ${green}git clone ssh://[username]@desa-arce.corpme.es/home/usuario/git/$repository_name${NC}\n"

