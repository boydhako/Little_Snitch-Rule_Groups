#!/bin/bash
appdir="/Applications"
gc="$(find "$appdir" -type f -name "Google Chrome")"
gcdir="$(dirname "$gc" | sed 's#/Contents/.*##g')"
gch="$(find "$gcdir" -type f -name "Google Chrome Helper")"
function GCHROMEHEAD {
	printf "{\n\t\"name\": \"Google Chrome\",\n\t\"description\": \"Google Chrome keeps changing it\'s path\",\n\t\"rules\": [\n"
}

function GCHROMERULES {
	for port in 80 443 5228; do
		for protocol in TCP UDP; do
			if [ "$port" == "5228" -a "$protocol" == "UDP" ]; then
				printf "\t{\n\t\t\"action\" : \"deny\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"ports\" : \"%s\",\n\t\t\"remote\" : \"any\"\n\t}," "$protocol" "$gc" "$port"
				printf "\t{\n\t\t\"action\" : \"deny\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"ports\" : \"%s\",\n\t\t\"via\" : \"%s\",\n\t\t\"remote\" : \"any\"\n\t}," "$protocol" "$gc" "$port" "$gch"
			elif [ "$port" == "80" ]; then
				printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"ports\" : \"%s\",\n\t\t\"remote\" : \"redirector.gvt1.com\"\n\t}," "$protocol" "$gc" "$port"
				printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"ports\" : \"%s\",\n\t\t\"via\" : \"%s\",\n\t\t\"remote\" : \"redirector.gvt1.com\"\n\t}," "$protocol" "$gc" "$port" "$gch"
			else
				printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"ports\" : \"%s\",\n\t\t\"remote\" : \"any\"\n\t}," "$protocol" "$gc" "$port"
				printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"ports\" : \"%s\",\n\t\t\"via\" : \"%s\"\n,\t\t\"remote\" : \"any\"\n\t}," "$protocol" "$gc" "$port" "$gch"
			fi
		done
	done
}

function GCHROMEFOOT {
	printf "\n\t]\n}\n"
}

function GCHROME {
	GCHROMEHEAD
	GCHROMERULES
	GCHROMEFOOT
}
GCHROME > $(basename -s.bash $0)
#GCHROME