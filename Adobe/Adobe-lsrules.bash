#!/bin/bash
dirs="/Library/Application_Support /Applications"
libdir="/Library"
ports="443 53"
protocols="TCP UDP"
remotes="adobe.io adobe-identity.com adobess.com typekit.com akamai.net akamaiedge.net fastly.net cloudfront.net"
apps="adoberesourcesynchronizer adobeacrobat adobe_crash_processor adobe_desktop_service core_sync creative_cloud_content_manager.node creative_cloud_helper"

function LSRULEHEAD {
        printf "{\n\t\"name\": \"Adobe\",\n\t\"description\": \"Track all the Adobe Software\",\n\t\"rules\": [\n"
}
function LSRULEFOOT {
        printf "\n\t]\n}\n"
}

function LSRULEGEN {
    LSRULEHEAD
    for dir in $dirs; do
        dir="$(echo "$dir" | sed 's/_/ /g')"
        for adobedir in $(sudo find "$dir" -maxdepth 5 -type d -iname "*adobe*" 2>/dev/null | sed 's/ /_/g'); do
            dir="$(echo "$adobedir" | sed 's/_/ /g')"
            for app in $apps; do
                app="$(echo $app | sed 's/_/ /g')"
                for apppath in $(sudo find "$dir" -type f -iname "$app" 2>/dev/null| sed 's/ /_/g'); do
                    apppath="$(echo $apppath | sed 's/_/ /g')"
                    for port in $ports; do
                        for protocol in $protocols; do
                            for remote in $remotes; do
                                printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"ports\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"remote-domains\" : \"%s\"\n\t},\n" "$port" "$apppath" "$protocol" "$remote"
                            done
                        done
                    done
                done
            done
        done
    done
    LSRULEFOOT
}

LSRULEGEN > $(basename -s.bash $0)