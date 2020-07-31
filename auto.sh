#!/bin/sh


if [ $# -ne 2 ] || [ ! -d $1 ]; then
	echo "Usage:" $0 "<dataDir>" "<frameSize>"
	exit 1
fi

workDir=$(cd `dirname $0`; pwd) # script directory

# compile, set python interpreter 
# init xxSet
bash ${workDir}/prepare.sh
if [ $? -ne 0 ]; then
	echo "prepare.sh error. Abort!"
	exit 1
fi

seqSetDir=${workDir}/seqSet
tableSetDir=${workDir}/tableSet
logSetDir=${workDir}/logSet

dataPath=`cd $1;pwd` # abs path
frameSize=$2
logPath=${workDir}/auto.log
echo "Task,PID,Timestamp" > $logPath

# init directory to empty
# dirInit $1
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
for filePath in ${dataPath}/*; do
	echo "Data Path:" $filePath
	if [ ! -f $filePath ]; then
		echo $filePath "is not a file."
		continue # goto next filePath
	fi

	# init
	tmp=${filePath%.*}
	baseName=${tmp##*/} # neither extension nor directory, used for task naming
	echo "Task:" ${baseName} "deployment begin---"
	seqDir=${seqSetDir}/${baseName}-seq
	dirInit $seqDir
	tableDir=${tableSetDir}/${baseName}-table
	dirInit $tableDir
	logDir=${logSetDir}/${baseName}-log
	dirInit $logDir
	bash ${workDir}/script/run.sh $filePath $frameSize $seqDir $tableDir $logDir > /dev/null 2>&1 & # run background
	pid=$!

	echo "Task:" ${baseName} "deployment finished--- PID:" ${pid}
	echo ${baseName}","${pid}","`date` >> $logPath

done


# finish prompt
echo ""
echo "--------------------------------------------"
echo -e "All deployments done! Please check\n${workDir}/auto.log\nfor process information."
