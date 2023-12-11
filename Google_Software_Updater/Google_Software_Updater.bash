#!/bin/bash 
libdir='/Library/Application*'
domains="googleapis.com gvt1.com"
ports="80 443"

function PRINTCFGSTART {
    printf "{\n\t\"description\" : \"\",\n\t\"name\" : \"Google Updater\",\n\t\"rules\" : [\n"
}

function GENRULES {
    updatebin="$(find $libdir -type f -iname "googleupdater" 2>/dev/null | head -n 1)"
    for domain in $domains; do
        for port in $ports; do
            printf "\t\t{\n\t\t\t\"action\" : \"allow\",\n\t\t\t\"ports\" : \"%s\",\n\t\t\t\"process\" :\"%s\",\n\t\t\t\"protocol\" : \"tcp\",\n\t\t\t\"remote-domains\" : \"%s\"\n\t\t},\n" "$port" "$(echo $updatebin | sed -e 's#/#\\/#g' )" "$domain"
        done
    done
} 

function PRINTCFGEND {
    printf "\t]\n}\n"
}

function GOOGLERULES {
    PRINTCFGSTART
    GENRULES
    PRINTCFGEND
}
GOOGLERULES > $(dirname $0)/google_updater.lsrules
