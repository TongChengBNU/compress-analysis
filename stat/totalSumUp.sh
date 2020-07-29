#!/bin/sh

logFile="summary.log"

if [ -e $logFile ]; then
	rm $logFile
fi

echo '----------------------------------' > $logFile
echo '-     Summary of total task      -' >> $logFile
echo '----------------------------------' >> $logFile
echo 'Date:' `date` >> $logFile
echo '\n\n' >> $logFile

for dirName in *
do
	if [ ! -d $dirName ]; then
		# not directory	
		continue
	fi
	echo "*****" $dirName "*****" >> summary.log
	python3 $dirName/sumUp.py $dirName/table/lzw.table >> summary.log
	python3 $dirName/sumUp.py $dirName/table/zip.table >> summary.log
	python3 $dirName/sumUp.py $dirName/table/gzip.table >> summary.log
	python3 $dirName/sumUp.py $dirName/table/bz2.table >> summary.log

	echo '\n\n' >> $logFile
done

echo "Log:" $logFile "is ready!"
