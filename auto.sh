#!/bin/sh


if [ $# -ne 2 ] || [ ! -d $1 ]; then
	echo "Usage:" $0 "<dataDir>" "<frameSize>"
	exit 1
fi

# init xxSet
./dependency.sh

workDir=`pwd`
seqSetDir=${workDir}/seqSet
tableSetDir=${workDir}/tableSet
logSetDir=${workDir}/logSet

dataPath=`cd $1;pwd`
frameSize=$2
logPath=${workDir}/auto.log
echo "Task,PID,Timestamp" > $logPath

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

	# init
	tmp=${filePath%.*}
	baseName=${tmp##*/}
	echo "Task:" ${baseName} "deployment begin---"
	seqDir=${seqSetDir}/${baseName}-seq
	mkdir $seqDir
	tableDir=${tableSetDir}/${baseName}-seq
	mkdir $seqDir
	logDir=${logSetDir}/${baseName}-seq
	mkdir $seqDir
	bash ${workDir}/script/run.sh $filePath $frameSize $seqDir $tableDir $logDir & # run background
	pid=$!

	echo "Task:" ${baseName} "deployment finished--- PID:" ${pid}
	echo ${basename}","${pid}","`date` >> $logPath

done

