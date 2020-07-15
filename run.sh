#!/bin/sh

seqDir='sequence/'
logPath='log/run.log'
a=`ls -l $seqDir | wc -l`
offset=2
valLength=25 # length of log/val.log + 1 = output of parse
total=`expr $a - $offset`
#total=3


# init
#./dependency.sh
echo '********RUN LOG**********\n\n' > $logPath

name=1
echo "-------Main loop begin------"
echo ""
while [ $name -le $total ]
do
	echo '----------------------'
	echo "Target - $seqDir$name"
	#echo "Name: $name, total: $total"
	#check=`ls $seqDir$name 2>/dev/null`
	if [ -e $seqDir$name ]
	then
		./generate.sh $seqDir$name > /dev/null
		count=`./parse.sh | wc -l`
		if [ $count -eq $valLength ]
		then
			./tupling.py
		else
			echo "Error: file $seqDir$name parse failed." >> $logPath
		fi
	else
		echo "Error: file $seqDir$name does not exist." >> $logPath
	fi

	#let 'name++'
	name=`expr $name + 1`
	echo ''
	sleep 5s
done

echo "Run script finished." 
echo "Plese check table/ for results and $logPath for error."

