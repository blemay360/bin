#!/bin/bash

#To do: fix main function to automatically do the length, and add prompted function to update at beginning with the whole 9 yards

function removePackages {
#removes packages that are annoying or aren't used
sudo apt remove deadbeef xscreensaver -y
sudo apt autoremove
}


function setupInstall {
#this is the prep work for installing spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
#and this is the prep work for installing chrome (getting the latest deb file)
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64
}
function installNewStuff {
read -p "Skip setup (Y/n)?" choice
case "$choice" in 
  y|Y|'' ) echo "I like your style";;
  n|N ) echo "You gotta do what you gotta do" & setupInstall;;
  * ) echo "Could you repeat that?";;
esac
#function for installing all the new packages and whatnot I use
#let's just update real quick before installation
sudo apt update -y
#and lets install the list of packages I want
sudo apt install neofetch spotify-client i3 feh firefox sl gnome-screensaver rhythmbox caffeine 'ssh' macchanger git nmap gimp openvpn redshift password-gorilla pmount vim -y
#and just to fix any potential issues (looking at you git)
sudo apt -f install -y
}


function i3Config {
#making directory for i3 config file to go in
mkdir ~/.i3
#copying over i3 config file
cp config ~/.i3/config
}

function xbindkeysrc {
#copying over ~/.xbindkeysrc
cp .xbindkeysrc ~/.xbindkeysrc
}

function main {
#To do: add some sets for the prompts; add a set for responses, positive, negative and invalid; add set for functions to execute; add for loop to run the prompt code for as many functions as it has to run
prompts=( "Remove packages" "Install packages" "Copy over i3 configuration" "Copy over .xbindkeysrc" )
posResponses=( "Cool. Cool cool cool" "Lets do it" "Good stuff" "Sounds good" )
negResponses=( "Well alrighty then" "Then why are you even running this?" "I guess that works too" )
invResponses=( "Excuse me?" "What was that?" "Say again?" )
function=( removePackages installNewStuff i3config xbindkeysrc )
#for i in "${#function[@]}"; do
#for i in {0..$((${#function[*]} - 1))}; do
for i in {0..3}; do
	echo -n ${prompts[i]};
	read -p " (Y/n)?" choice
	case "$choice" in 
	  y|Y|'' ) echo ${posResponses[i]}; ${function[i]};;
	  n|N ) echo ${negResponses[i]};;
	  * ) echo ${invResponses[i]};;
	esac
done
}

main

neofetch
echo "Welcome to your new machine"
