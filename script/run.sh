#!/bin/sh

if [ $# -ne 5 ]; then
	echo "Usage:" $0 "<dataPath>" "<frameSize>" "<seqDir>" "<tableDir>" "logDir" 
	echo "Please run dependency.sh before starting task!"
	exit 1
fi

#workDir=`pwd`
workDir=$(cd "`dirname ${BASH_SOURCE}`"; pwd)


absPath(){
	if [ -d $1 ]; then
		echo `cd $1; pwd`
	elif [ -f $1 ]; then
		base=`basename $1`
		dir=`dirname $1`
		absDir=`cd $dir; pwd`
		echo $absDir"/"$base
	else
		echo $1
	fi

}
target=`absPath $1`
frameSize=$2
seqDir=`absPath $3`
tableDir=`absPath $4`
logDir=`absPath $5`

# $1 validation
if [ ! -e $target ]; then
	echo $1 "doesn't exist!"
	exit 1
fi
echo "Target:" $target "Begin ---------------"
# $3 $4 $5 validation
bash ${workDir}/dependency.sh $seqDir $tableDir $logDir
if [ $? -ne 0 ]; then
	echo "Task: $target dependency error. Abort!"
	exit 1
fi


echo "Slice data Begin ----------"
cd $seqDir
split $target -b $frameSize -d
if [ $? -ne 0 ]; then
	echo "Task: $target split error. Abort!"
	exit 1
fi
cd $workDir

logPath=${logDir}"/run.log"
valLength=24 # length of log/val.log 
             # validate intermediate result from parse.sh
a=`ls -l $seqDir | wc -l`
offset=3 # total + . + .. = 3
total=`expr $a - $offset`


# init
echo '********RUN LOG**********\n\n' > $logPath

echo "-------Main loop begin------\n"
for framePath in $seqDir/*; do
	echo '----------------------'
	echo "Target - $framePath"
	#echo "Name: $name, total: $total"
	#check=`ls $seqDir$name 2>/dev/null`
	if [ -f $framePath ]; then
		./generate.sh ${framePath} ${logDir} > /dev/null
		if [ $? -ne 0 ]; then
			echo "Error: file $framePath generate failed." >> $logPath
			continue	
		fi
		./parse.sh $logDir > /dev/null
		if [ $? -ne 0 ]; then
			echo "Error: file $framePath parse failed." >> $logPath
			continue	
		fi
		tmp=${logDir}'/val.log'
		count=`cat $tmp | wc -l`
		if [ $count -eq $valLength ]; then
			./tupling.py $logDir $tableDir
			if [ $? -ne 0 ]; then
				echo "Error: file $framePath tupling failed." >> $logPath
				continue	
			fi
		fi
	else
		echo "Error: file $framePath does not exist." >> $logPath
	fi

	echo ''
done

echo "****************************"
echo "Run script finished." 
echo -e "Plese check \n$tableDir\n for results and \n$logPath\n for error."

