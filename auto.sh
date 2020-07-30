#!/bin/sh


if [ $# -ne 2 ] || [ ! -d $1 ]; then
	echo "Usage:" $0 "<dataDir>" "<frameSize>"
	exit 1
fi

# compile, set python interpreter 
# init xxSet
bash prepare.sh
if [ $? -nq 0 ]; then
	echo "./prepare.sh error. Abort!"
	exit 1
fi

workDir=`pwd`
seqSetDir=${workDir}/seqSet
tableSetDir=${workDir}/tableSet
logSetDir=${workDir}/logSet

dataPath=`cd $1;pwd` # abs path
frameSize=$2
logPath=${workDir}/auto.log
echo "Task,PID,Timestamp" > $logPath

dirInit(){
	if [ -d $1 ]; then
		rm -f $1/*
	elif [ -f $1 ]; then
		rm -f $1
		mkdir $1
	else
		mkdir $1
	fi
	return 0
}

# ---- Task Loop ------------
for filePath in ${dataPath}/*
do
	echo $filePath
	if [ ! -f $filePath ]; then
		echo $filePath "is not a file."
		continue
	fi

	# init
	tmp=${filePath%.*}
	baseName=${tmp##*/}
	echo "Task:" ${baseName} "deployment begin---"
	seqDir=${seqSetDir}/${baseName}-seq
	dirInit $seqDir
	tableDir=${tableSetDir}/${baseName}-seq
	dirInit $tableDir
	logDir=${logSetDir}/${baseName}-seq
	dirInit $logDir
	bash ${workDir}/script/run.sh $filePath $frameSize $seqDir $tableDir $logDir & # run background
	pid=$!

	echo "Task:" ${baseName} "deployment finished--- PID:" ${pid}
	echo ${basename}","${pid}","`date` >> $logPath

done

