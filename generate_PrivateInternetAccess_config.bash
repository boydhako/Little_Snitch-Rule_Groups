#!/bin/bash
tmp="/tmp/$(basename -s .bash $0)"
tblk="/Applications/Tunnelblick.app"
piazip="$tmp/pia.zip"
piasource="https://www.privateinternetaccess.com/openvpn/openvpn-strong-tcp.zip"
lsrule="$tmp/pia.lsrules"

function GETINFO {
	#curl -s -o $piazip $piasource
	curl -o $piazip $piasource
	#unzip $piazip >/dev/null 2>&1
	unzip $piazip -d $tmp
	servers="$(awk '$1 == "remote" {printf $2"\n"}' $tmp/*.ovpn)"
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
		printf "\t\t{\n\t\t\t\"action\": \"allow\",\n\t\t\t\"direction\": \"outgoing\",\n\t\t\t\"protocol\": \"TCP\",\n\t\t\t\"process\": \"$vpnbin\",\n\t\t\t\"remote-hosts\": [%s]\n\t\t}\n" "$serverscsv" >> $lsrule
	done
	printf "\t]\n}\n" >> $lsrule
	cp $lsrule $PWD
	CLEANUP
}
PIAGENCFG
