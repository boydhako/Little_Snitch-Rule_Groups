#!/bin/bash
push="0"
cd $(dirname $0)
ping -c 1 github.com > /dev/null 2>&1
if [ "$?" != "0" ]; then
    exit 1
fi
git pull 2>/dev/null
for script in $(find $PWD -mindepth 2 -type f -iname "*.bash"); do
	printf "\n===== %s =====\n" "$script"
	sname="$(basename $script)"
	$script
	git commit -a -m "Updating from $sname"
    exitcode="$?"
    if [ "$exitcode" == "0" ]; then
        export push="1"
        printf "\n##### commiting %s #####\n" "$script"
    fi
done
if [ "$push" == "1" ]; then
    git push
fi
