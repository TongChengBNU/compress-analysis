#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage:" $0 "<logDir>"
	exit 1
fi

workDir=$( cd `dirname $0`; pwd )
logDir=$1

srcPath=${logDir}'/statistics.log'
trgtPath=${logDir}'/val.log'

parseBin=${workDir%/*}/bin/parse
$parseBin $srcPath > $trgtPath
grep 'Padding' $srcPath >> $trgtPath
grep 'Overflow' $srcPath >> $trgtPath
grep 'time' $srcPath >> $trgtPath
grep 'Comparison' $srcPath >> $trgtPath

echo "Content of $trgtPath-------------"
cat $trgtPath
