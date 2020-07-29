#!/bin/sh

# compile binary
echo "---Compile Binary---"
make

# set up python interpreter 
echo "---Set up python interpreter---"
pythonPath=`which python3`
for script in ./script/*; do
	ext=${script%*.}	
	if [ $ext -eq "py" ]; then
		sed -i "1c \#\!$pythonPath" script
	fi
done

# prepare XXSet
clean(){
	trgtDir=$1
	if [ -d $trgtDir ]; then
		rm -f $trgtDir/*
	else
		mkdir $trgtDir
	fi
}

workDir=`pwd`
clean ${workDir}/seqSet
clean ${workDir}/tableSet
clean ${workDir}/logSet

