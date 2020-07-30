#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage:" $0 "<logDir>"
	exit 1
fi

logDir=$1

srcPath=${logDir}'/statistics.log'
trgtPath=${logDir}'/val.log'

../bin/parse $srcPath > $trgtPath
grep 'Padding' $srcPath >> $trgtPath
grep 'Overflow' $srcPath >> $trgtPath
grep 'time' $srcPath >> $trgtPath
grep 'Comparison' $srcPath >> $trgtPath

echo "Content of $trgtPath-------------"
cat $trgtPath
