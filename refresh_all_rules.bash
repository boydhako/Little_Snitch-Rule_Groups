#!/bin/bash
cd $(dirname $0)
git pull
for script in $(find $PWD -mindepth 2 -type f -iname "*.bash"); do
	printf "\n===== %s =====\n" "$script"
	sname="$(basename $script)"
	$script
	printf "\n##### commiting %s #####\n" "$script"
	git commit -a -m "Updating from $sname"
	git push
done
git push
