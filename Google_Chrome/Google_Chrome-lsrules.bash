#!/bin/bash 
gcdir="/Applications/Google Chrome.app"

function GCHROMEHEAD {
	printf "{\n\t\"name\": \"Google Chrome\",\n\t\"description\": \"Google Chrome keeps changing it\'s path\",\n\t\"rules\": [\n"
}

function GCHROMERULES {
	if [ -d "$gcdir" ]; then
		proc="$(find "$gcdir" -name "Google Chrome" | sed -e 's~/~\\/~g')"
		#find "$gcdir" -type f -name "Google Chrome Helper" | sed 's~/~\\/~g'
		for bin in $(find "$gcdir" -type f -name "Google Chrome Helper" | sed 's~ ~_~g'); do
			gbin="$(echo $bin | sed -e 's~/~\\/~g' -e 's~_~ ~g')"
			for proto in UDP TCP; do
				for dport in 443 5228; do
					printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"ports\" : \"%s\",\n\t\t\"via\" : \"%s\",\n\t\t\"remote\" : \"any\"\n\t},\n" "$proto" "$proc" "$dport" "$gbin"
				done
			done
			printf "\t{\n\t\t\"action\" : \"allow\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"ports\" : \"%s\",\n\t\t\"via\" : \"%s\",\n\t\t\"remote-hosts\" : \"redirector.gvt1.com\"\n\t},\n" "TCP" "$proc" "80" "$gbin"
		done
	fi
}

function GCHROMEFOOT {
	printf "\t]\n}\n"
}

function GCHROME {
	GCHROMEHEAD
	GCHROMERULES
	GCHROMEFOOT
}
GCHROME > $(basename -s.bash $0)
