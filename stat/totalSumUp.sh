#!/bin/sh

# work directory: home/stat
workDir=$(cd `dirname $0`; pwd)


logFile=${workDir}"/summary.log"
if [ -e $logFile ]; then
	rm $logFile
fi

echo '----------------------------------' > $logFile
echo '-     Summary of total task      -' >> $logFile
echo '----------------------------------' >> $logFile
echo 'Date:' `date` >> $logFile
echo '\n\n' >> $logFile

tableSetPath=${workDir%/*}"/tableSet"
scriptPath=${workDir%/*}"/script"

for dirName in ${tableSetPath}/*
do
	if [ ! -d $dirName ]; then
		# not directory	
		continue
	fi
	echo "*****" ${dirName%-*} "*****" >> summary.log
	python3 ${scriptPath}/sumUp.py $dirName/lzw.table >> summary.log
	python3 ${scriptPath}/sumUp.py $dirName/zip.table >> summary.log
	python3 ${scriptPath}/sumUp.py $dirName/gzip.table >> summary.log
	python3 ${scriptPath}/sumUp.py $dirName/bz2.table >> summary.log

	echo '\n\n' >> $logFile
done

echo "Log:" $logFile "is ready!"
