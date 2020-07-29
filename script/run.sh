#!/bin/sh

if [ $# -ne 5 ]; then
	echo "Usage:" $0 "<dataPath>" "<frameSize>" "<seqDir>" "<tableDir>" "logDir" 
	echo "Please run dependency.sh before starting task!"
	exit 1
fi

workDir=`pwd`
./dependency.sh $4 $5

target=$1
frameSize=$2
if [ ! -e $target ]; then
	echo $1 "doesn't exist!"
	exit 1
fi
echo "Target:" $target "Begin ---------------"

seqDir=$3
if [ -d $seqDir ]; then
	rm -f $seqDir/*
else
	mkdir $seqDir
fi

echo "Slice data Begin ----------"
cd $seqDir
split $target -b $frameSize -d
cd $workDir

logDir=$5
logPath=${logDir}"/run.log"
valLength=25 # length of log/val.log + 1 = output of parse.sh
             # validate intermediate result from parse.sh
a=`ls -l $seqDir | wc -l`
offset=3 # total + . + .. = 3
total=`expr $a - $offset`


# init
echo '********RUN LOG**********\n\n' > $logPath

name=1
echo "-------Main loop begin------\n"
while [ $name -le $total ]; do
	targetPath=$targetPath
	echo '----------------------'
	echo "Target - $targetPath"
	#echo "Name: $name, total: $total"
	#check=`ls $seqDir$name 2>/dev/null`
	if [ -e $targetPath ]
	then
		./generate.sh $targetPath > /dev/null
		count=`./parse.sh | wc -l`
		if [ $count -eq $valLength ]
		then
			./tupling.py
		else
			echo "Error: file $targetPath parse failed." >> $logPath
		fi
	else
		echo "Error: file $targetPath does not exist." >> $logPath
	fi

	let name+=1
	echo ''
done

echo "Run script finished." 
echo "Plese check table/ for results and $logPath for error."

