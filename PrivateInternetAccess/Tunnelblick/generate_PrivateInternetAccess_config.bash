#!/bin/bash
tmp="/tmp/$(basename -s .bash $0)"
tblk="/Applications/Tunnelblick.app"
piazip="$tmp/pia.zip"
piasource="https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip"
lsrule="$tmp/pia.lsrules"
proto="udp"

function GETINFO {
	curl -o $piazip $piasource
	unzip $piazip -d $tmp
	servers="$(awk '$1 == "remote" {printf $2"\n"}' $tmp/*.ovpn)"
	proto="$(awk '$1 == "proto" {printf $2"\n"}' $tmp/*.ovpn | sort | uniq | tr [:lower:] [:upper:] )"
	serverscsv="$(printf "\"%s\"\n" "$(echo $servers | sed 's/ /\", \"/g')")"
	if [ -d "$tblk" ]; then
		ovpn="$(find $tblk -type f -iname "openvpn")"
	fi
}

function CLEANUP {
	for dir in $tmp; do
		rm -rf $dir
	done
}
function PIAGENCFG {
	for dir in $tmp; do
		mkdir -p $dir
	done

	GETINFO

	printf "{\n\t\"name\": \"Private Internet Access\",\n\t\"description\": \"This rule allows access to Private Internet Access servers.\",\n\t\"rules\": [\n" > $lsrule
	
	for vpnbin in $ovpn; do
		for host in $servers; do
            for direction in incoming outgoing; do
                printf "\t\t{\n\t\t\"action\" : \"allow\",\n\t\t\"direction\" : \"%s\",\n\t\t\"protocol\" : \"%s\",\n\t\t\"process\" : \"%s\",\n\t\t\"remote-domains\" : \"%s\"\n\t\t},\n" "$direction" "$proto" "$vpnbin" "$host" >> $lsrule
            done
		done
	done
	
	printf "\t]\n}\n" >> $lsrule
	
	cp $lsrule $PWD
	CLEANUP
}
PIAGENCFG
