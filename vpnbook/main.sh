#!/bin/bash
#username=vpnbook
#password=x98pc7g
#notify-send "main started"
#echo -n "[sudo] password for blemay360:"
#read -s sysPass
#filename=~/bin/vpnbook/login.txt

function readFile {
	counter=0
	while read line || [[ -n "$line" ]]; do
		if [ $counter -eq 0 ]; then
			username=$line
		elif [ $counter -eq 1 ]; then
			password=$line
		fi
		let counter=$counter+1
	done < $filename 
}

function getCred {
content=$(curl -s https://www.vpnbook.com)
username=${content##*"no p2p downloading"}
username=${username##*sername: }
username=${username%%</strong>*}

password=${content##*"sername"}
password=${password##*assword: }
password=${password%%</strong>*}
}

#if [ "$#" -eq 1 ]; then
#	readFile
#elif [ "$1" = "-f" ]; then
#	getCred
#fi
#notify-send "Starting expect"
#expect -f ~/bin/vpnbook/expectVpnbook.exp $username $password $sysPass

# expect is run here
function expect {
	VAR=$(expect -c "
	set username [lindex $username 0];
	set password [lindex $password 1];
	#set sysPass [lindex $sysPass 2];
	spawn ~/bin/vpnbook/vpnbook.sh
	#expect "password for blemay360: " { send $sysPass\r }
	expect "Enter Auth Username:" { send $username\r }
	expect "Enter Auth Password:" { send $password\r }
	expect "AUTH_FAILED" { return 0 }
	")
}
# This echoes the output of the expect command.
VAR="nested loops loop nestidly"
expect
echo "$VAR"
