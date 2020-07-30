#!/bin/sh



# compile binary
echo "---Compile Binary---"
if [ "$1" = "-f" ]; then
	echo "Fast prepare without compilation."
else
	echo "Full prepare with compilation"
	make
fi
echo ""

# set up python interpreter 
echo "---Set up python interpreter---"
pythonPath=`which python3`
for script in ./script/*
do
	ext=${script##*.}	
	if [ $ext = "py" ]; then
		sed -i "1c \#\!$pythonPath" $script
		echo "Interperter for script:" $script "is set up."
	fi
done
echo ""

# prepare XXSet
clean(){
	trgtDir=$1
		if [ -d $trgtDir ]; then
		rm -rf $trgtDir/* # remove all subdirectory
	else
		mkdir $trgtDir
	fi
	echo "Directory:" $trgtDir "is cleaned."
} 

workDir=`pwd`
clean ${workDir}/seqSet
clean ${workDir}/tableSet
clean ${workDir}/logSet
echo ""

