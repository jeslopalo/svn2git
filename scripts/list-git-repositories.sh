#!/bin/bash

set -e

username=$([ $# -gt 0 ] && echo "$1" || echo "<user>")
GIT_REPOSITORY="ssh://$username@desaweb.corpme.es/git"

list_git_repos() {
  local directory=$1

  if [ -f "$directory" ]; then
    return 0
  fi

  if [ "$directory" != "" ] && [ -d "$directory" ] && [[ "$directory" == *\.git ]]; then
      echo -e "> $GIT_REPOSITORY/$directory"
      return 0
  else
      for child in `ls -1A $directory`; do
        child_directory=$([ "$directory" != "" ] && echo "$directory/$child" || echo "$child")
        list_git_repos "$child_directory"
      done
  fi
}

if [ "$username" == "<user>" ]; then
  echo -e "¡Atención! Si añades tu nombre de usuario como argumento, las urls generadas contendrán el usuario, siendo posible usarlas directamente."
fi

cwd=`pwd`
echo -e "\nListando los repositorios Git en $cwd..."
list_git_repos
