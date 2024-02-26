#!/bin/bash
appsupdir="$HOME/Library/Application Support"
domains="googleapis.com gvt1.com"
ports="443 80"

function GENGOOGLEUPDATERRULES {
    printf "{\n\t\"name\": \"Google Updater\",\n\t\"description\": \"Google updater keeps changing it\'s path\",\n\t\"rules\": [\n"
    for port in $ports; do
        for protocol in TCP UDP; do
            for domain in $domains; do
                for file in $(find "$appsupdir" -type f -name "GoogleUpdater" 2>/dev/null | sed 's/ /#/g'); do
                    if [ "$port" = "80" -a "$protocol" = "TCP" -a "$domain" = "gvt1.com" ]; then
                        printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"ports\" : \"%s\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"remote-domains\" : \"%s\"\n\t},\n" "$port" "$protocol" "$(echo $file | sed -e 's/#/ /g' -e 's#/#\\/#g')" "$domain"
                    elif [ "$port" = "443" ]; then
                        printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"ports\" : \"%s\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"remote-domains\" : \"%s\"\n\t},\n" "$port" "$protocol" "$(echo $file | sed -e 's/#/ /g' -e 's#/#\\/#g')" "$domain"
                    fi 
                done
            done
        done
    done
    printf "\n\t]\n}\n"
}
GENGOOGLEUPDATERRULES > $(basename -s.bash $0).lsrules