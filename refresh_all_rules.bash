#!/bin/bash
cd $(dirname $0)
for script in $(find $PWD -mindepth 2 -type f -iname "*.bash"); do
    git pull
	printf "\n===== %s =====\n" "$script"
	sname="$(basename $script)"
	$script
	printf "\n##### commiting %s #####\n" "$script"
	git commit -a -m "Updating from $sname"
	git push
done
