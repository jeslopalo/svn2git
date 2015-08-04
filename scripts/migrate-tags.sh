#!/bin/sh

set -e

for tag in `git branch -r | grep \/tags\/ `; do
	echo "Processing tag branch:	$tag ...";
	tagname=`echo $tag | sed 's/.*\///'`;
	echo -e "\tTag name: $tagname";
	
	
	echo "git tag $tagname $tag"
	git tag $tagname $tag
	echo "Removing branch ref"
	git branch -r -d $tag
done
