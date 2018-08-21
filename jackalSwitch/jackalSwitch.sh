#!/bin/bash
device=wlp1s0
ifconfig $device down
macchanger $device -a
ifconfig $device up
