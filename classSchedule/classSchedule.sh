#!/bin/bash
filename=~/bin/classSchedule/classSchedule.txt
rough=$(cat $filename)
sentFile=~/bin/classSchedule/sent
sent=$(cat $sentFile)

function makeArray {
#function that will take the rough text from the class schedule text file and parse each item into one long array
	numClasses=0
	while [ ${#rough} -gt 1 ]; do
		class[$numClasses]=${rough%%=*}
		rough=${rough#*=}
		let numClasses=$numClasses+1
	done
}

function orgArray {
#organizes the array from makeArray into 3 different arrays for class time, class name, and classroom
	counter=0
	while [ $counter -lt $numClasses ]; do
		remainder=$[counter % 3]
		classNum=$[counter / 3]
		if [ $remainder -eq 0 ]; then #time
			time[$classNum]=$(convertTime ${class[$counter]})
		elif [ $remainder -eq 1 ]; then #name
			name[$classNum]=${class[$counter]}
		elif [ $remainder -eq 2 ]; then #room
			room[$classNum]=${class[$counter]}
		fi
		let counter=$counter+1
	done
}

function convertTime {
#converts input of form hh:mm into minutes
	input=$1
	if [ ${#input} -lt 1 ]; then
		input=$(currentTime)
	fi
	hours=${input%:??}
	minutes=${input: -2}
	time=$[10#$hours*60+10#$minutes]
	echo $time
}

function currentTime {
#grabs the current date and extracts the time
	date="$(date)"
	tmp=${date%:??' E'*'T'*}
	len=${#tmp}
	time=${tmp:len-6}
	echo $time
}

function getAscendingTime {
#adds some multiple of 1440 to the items in the time array so that each one greater than the last and the time until next class thing works
	counter=1
	while [ $counter -le $[classNum] ]; do
		previous=$[counter-1]
		while [ ${time[$previous]} -gt ${time[$counter]} ]; do
			let time[$counter]=${time[$counter]}+1440
		done
		let counter=$counter+1
	done
}

function getTime {
#takes current time and converts it to an amount of minutes since Monday
	time=$(convertTime)
	date="$(date)"
	counter=0
	for i in Mon Tue Wed Thu Fri Sat Sun; do
		if [ ${date::3} = $i ]; then
			let time=$time+1440*$counter
		fi
		let counter=$counter+1
	done
	echo $time
}

function getNextClass {
#goes through the list of my classes and figures out which one is next based on current time
	counter=0
	while [ $counter -le $[classNum] ]; do
		if [ $(getTime) -lt ${time[$counter]} ]; then	
			nextClass=$counter
			echo $nextClass
			return
		fi
		let counter=$counter+1
	done
}

function getDifference {
#takes the difference from the next class and the current time
	counter=0
	currentTime=$(getTime)
	if [ $currentTime -gt ${time[$[${#time[@]}-1]]} ]; then
		echo $[10080+${time[0]}-$currentTime]
	else
		while [ $counter -le $[classNum] ]; do
			if [ $currentTime -lt ${time[$counter]} ]; then
				echo $[${time[$counter]}-$(getTime)]
				nextClass=$counter
				return
			fi
			let counter=$counter+1
		done
	fi
}

function output {
#prints out the useful stuff
	day=0
	difference=$(getDifference)
	if [ $[$difference/60] -ge 24 ]; then
		day=$[difference/1440]
		difference=$[difference-$day*1440]
		hour=$[difference/60]
		minute=$[difference%60]
	else
		hour=$[difference/60]
		minute=$[difference%60]
	fi
	if [ ${#minute} -eq 1 ]; then
		minute=0$minute
	fi
	if [ ${#hour} -eq 1 ]; then
		hour="0$hour"
	fi
	if [ $day -ne 0 ]; then
		echo $day:$hour:$minute
	else
		echo $hour:$minute
	fi
}

function writeSent {
	rm $sentFile
	echo $1 >> $sentFile
}

function sendNotification {
#sends a notification with class name and room 1 hour 30 minutes, one hour, and 30 minutes in advance
	difference=$(getDifference)
	seconds=$(date)
	seconds=${seconds##*:}
	seconds=${seconds::2}
	nextClass=$(getNextClass)
	if [ $difference = 90 ]; then
		if [ $sent -eq 0 ]; then
			notify-send --urgency=normal --expire-time=30000 "${name[$nextClass]} in an hour and a half" "${room[$nextClass]}"
			writeSent 1
		fi
	elif [ $difference = 60 ]; then
		if [ $sent -eq 0 ]; then
			notify-send --urgency=normal --expire-time=30000 "${name[$nextClass]} in an hour" "${room[$nextClass]}"
			writeSent 1
		fi
	elif [ $difference = 30 ]; then
		if [ $sent -eq 0 ]; then	
			notify-send --urgency=normal --expire-time=30000 "${name[$nextClass]} in a half hour" "${room[$nextClass]}"
			writeSent 1
		fi
	else
		writeSent 0
	fi
}

function main {
	makeArray
	orgArray
	getAscendingTime 
	output
	sendNotification 
}

main
