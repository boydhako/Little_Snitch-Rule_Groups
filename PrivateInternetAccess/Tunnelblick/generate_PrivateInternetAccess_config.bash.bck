#!/bin/bash
nsservers="208.67.222.222 208.67.220.220"
tmp="/tmp/$(basename -s .bash $0)"
tblk="/Applications/Tunnelblick.app"
piazip="$tmp/pia.zip"
#piasource="https://www.privateinternetaccess.com/openvpn/openvpn-strong-tcp.zip"
piasource="https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip"
lsrule="$tmp/pia.lsrules"
proto="udp"

function GETINFO {
	#curl -s -o $piazip $piasource
	curl -o $piazip $piasource
	#unzip $piazip >/dev/null 2>&1
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
	rawip="$tmp/rawiplist.txt"

	printf "{\n\t\"name\": \"Private Internet Access\",\n\t\"description\": \"This rule allows access to Private Internet Access servers.\",\n\t\"rules\": [\n" > $lsrule
	
	for vpnbin in $ovpn; do
		#printf "\t\t{\n\t\t\t\"action\": \"allow\",\n\t\t\t\"process\": \"$vpnbin\",\n\t\t\t\"remote-hosts\": [%s]\n\t\t}\n" "$serverscsv" >> $lsrule
		for host in $servers; do
			printf "\n\n=== %s ===\n" "$host"
			for namesrv in $nsservers; do
				#dig \@$namesrv $host A 
				dig \@$namesrv $host A | awk '$4 == "A" {printf $NF"\n"}' >> $rawip
			#printf "%s : %s\n" "$vpnbin" "$host"
			done

			printf "\t\t{\n\t\t\t\"notes\": \"IP addresses are for %s.\",\n\t\t\t\"action\": \"allow\",\n\t\t\t\"direction\": \"incoming\",\n\t\t\t\"protocol\": \"%s\",\n\t\t\t\"process\": \"%s\",\n\t\t\t\"remote-addresses\": \"%s\"\n\t\t},\n" "$host" "$proto" "$vpnbin" "$(cat $rawip | sort -n | uniq | awk '{printf $0", "}' | sed 's/\", \"$//' | sed 's/, $//')" >> $lsrule
			printf "\t\t{\n\t\t\t\"notes\": \"IP addresses are for %s.\",\n\t\t\t\"action\": \"allow\",\n\t\t\t\"direction\": \"outgoing\",\n\t\t\t\"protocol\": \"%s\",\n\t\t\t\"process\": \"%s\",\n\t\t\t\"remote-addresses\": \"%s\"\n\t\t},\n" "$host" "$proto" "$vpnbin" "$(cat $rawip | sort -n | uniq | awk '{printf $0", "}' | sed 's/\", \"$//' | sed 's/, $//')" >> $lsrule
			cat $rawip | sort -n | uniq | awk '{printf $0"\", \""}' | sed 's/\", \"$//'
			rm -f $rawip
		done
	done
	
	printf "\t]\n}\n" >> $lsrule
	
	cp $lsrule $PWD
	CLEANUP
}
PIAGENCFG
