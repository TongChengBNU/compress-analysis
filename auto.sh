#!/bin/sh
# Usage: . auto.sh


if [ $# -ne 2 ] || [ ! -d $1 ]; then
	echo "Usage:" $0 "<dataDir>" "<frameSize>"
	exit 1
fi

# init xxSet
./dependency.sh

workDir=`pwd`
dataPath=`cd $1;pwd`
frameSize=$2

for filePath in ${dataPath}/*
do
	echo $filePath
	if [ ! -f $filePath ]; then
		echo $filePath "is not file"
		continue
	fi
	#extension=${filePath##*.}
	#if [ $extension != "dat" ]; then
	#	continue
	#fi

	tmp=${filePath%.*}
	baseName=${tmp##*/}
	echo "Task:" ${baseName} "deployment begin---"



	echo "Task:" ${baseName} "deployment finished---"
	cd ..

done

