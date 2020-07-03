#!/bin/bash
cd $(dirname $0)
for script in $(find $PWD -mindepth 2 -type f -iname "*.bash"); do
	sname="$(basename $script)"
	$script
	git commit -a -m "Updating from $sname"
	git push
done
