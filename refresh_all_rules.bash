#!/bin/bash
push="0"
cd $(dirname $0)
ping -c 4 github.com > /dev/null
if [ "$?" != "0" ]; then
    exit 1
fi
git pull 2>/dev/null
for script in $(find $PWD -mindepth 2 -type f -iname "*.bash"); do
	printf "\n===== %s =====\n" "$script"
	sname="$(basename $script)"
	$script
	printf "\n##### commiting %s #####\n" "$script"
	git commit -a -m "Updating from $sname"
    exitcode="$?"
    if [ "$exitcode" == "0" ]; then
        export push="1"
    fi
done
if [ "$push" == "1" ]; then
    git push
fi
