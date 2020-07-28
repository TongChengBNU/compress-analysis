#!/bin/sh

if [ $# -ne 2 ]; then
	echo "Usage:" $0 "<dataPath>" "<frameSize>"
	echo "Please run dependency.sh before starting task!"
	exit 1
fi

target=$1
frameSize=$2
if [ ! -e $target ]; then
	echo $1 "doesn't exist!"
	exit 1
fi
echo "Target:" $target "Begin ---------------"

seqDir=`pwd`/"sequence"
if [ -d $seqDir ]; then
	rm -f $seqDir/*
else
	mkdir $seqDir
fi

binDir=`pwd`/"bin"
echo "Slice data Begin ----------"
${binDir}/split $target $frameSize

logPath='log/run.log'
valLength=25 # length of log/val.log + 1 = output of parse.sh
             # validate intermediate result from parse.sh
a=`ls -l $seqDir | wc -l`
offset=3 # total + . + .. = 3
total=`expr $a - $offset`


# init
echo '********RUN LOG**********\n\n' > $logPath

name=1
echo "-------Main loop begin------"
echo ""
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

	#let 'name++'
	name=`expr $name + 1`
	echo ''
done

echo "Run script finished." 
echo "Plese check table/ for results and $logPath for error."

