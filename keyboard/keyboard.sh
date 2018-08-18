#!/bin/bash
key=$1
a_lst=('amazon' 'arduino')
if [ $key = a ]; then
	select opt in ${a_lst[@]};
	do
		if [ $opt = amazon ]; then
			$(command firefox -new-window 'https://www.amazon.com/b/ref=lp_2676882011_nav_youraccount_piv?rh=i%3Aprime-instant-video%2Cn%3A2676882011&ie=UTF8&node=2676882011')
			break
		elif [ $opt = arduino ]; then
			$(command bash ~/arduino-1.8.5/arduino > /dev/null &)
		fi
	done
fi
