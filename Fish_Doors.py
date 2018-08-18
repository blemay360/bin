#!/usr/bin/python
import pygame, sys
import pygame.locals
import serial
import syslog
import time

def connectSerial():
	port0 = '/dev/ttyACM0'
	port1 = '/dev/ttyACM1'
	global ard
	try:
		ard = serial.Serial(port0,9600,timeout=0.25)
	except:
		try:
			ard = serial.Serial(port1,9600,timeout=0.25)
		except:
			print("No serial port available")
			return 0
		return 1
	return 1

def initializePygame():
	print("Initalizing")
	pygame.init()
	BLACK = (0,0,0)
	WIDTH = 100
	HEIGHT = 100
	windowSurface = pygame.display.set_mode((WIDTH, HEIGHT), 0, 32)
	windowSurface.fill(BLACK)
	print("Ready")

def main():
	global ard
	if connectSerial():
		initializePygame()
		while True:
			ardInput=ard.readline()
			if (ardInput != ''):
				print(ardInput);
			keys_pressed = pygame.event.get(pygame.KEYDOWN)
			for event in keys_pressed:
				if event.key == 27:
					return
				elif event.type == pygame.KEYDOWN and event.key < 256:
					ard.write(chr(event.key))
					print(chr(event.key)+" sent")

if (__name__ == "__main__"):
	main();
