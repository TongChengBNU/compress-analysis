#!/usr/bin/python3
import os

# return pid str
def pidExtract(line):
	pid = line.split(",")[1]
	return pid

def main():
	fd = open("../auto.log", 'r')
	content = fd.readlines()
	content.pop(0)
	for line in content:
		pid = pidExtract(line)
		cmd = "kill " + pid
		print("CMD: " + cmd)
		os.system(cmd)

	return

if __name__ == "__main__":
	main()

