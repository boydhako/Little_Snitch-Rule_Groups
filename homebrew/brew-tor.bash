#!/bin/bash
dirs="/usr/local/Cellar /usr/local/Caskroom"
lsrules="$(echo "$(dirname $(echo $0))/$(basename -s .bash $0).lsrules")"
printf "{\n\t\"name\": \"TOR from Homebrew\",\n\t\"description\": \"This rule allows tor from homebrew.\",\n\t\"rules\": [\n" > $lsrules

for dir in $dirs; do
    for bin in $(find $dir -type f -name tor); do
        printf "\t\t{\n\t\t\"action\" : \"allow\",\n\t\t\"ports\" : \"any\",\n\t\t\"process\" : \"%s\",\n\t\t\"protocol\" : \"any\",\n\t\t\"remote\" : \"any\"\n\t\t},\n" "$bin" >> $lsrules
    done
done

printf "\t]\n}\n" >> $lsrules

