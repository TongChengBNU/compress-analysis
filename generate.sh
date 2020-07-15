#!/bin/sh

if [ $# != 1 ]
then
	echo "Usage: $0 <target>"
	exit
fi
standard=928

cmpBin='bin/cmpBinary'
timeBin='bin/timer2'
lzwBin='bin/compress'

outputDir='output/'
logDir='log/'
binDir='bin/'

logName='statistics.log'
targetName=`echo $1 | sed -e 's/\// /g;' | awk '{print $NF}'`
echo "Target: $1" # $1 is a path (full or relative)
echo "targetName:" $targetName # $1 is a path (full or relative)

# LZW compression: 
echo "-------------LZW----------------" > ${logDir}${logName}
cpsCMD="$lzwBin -v $1 >> ${logDir}${logName} 2>&1"
dcpsCMD="$lzwBin -d $1.Z >> ${logDir}${logName} 2>&1"
cp $1 $1.bk # backup source data inplace
$timeBin "$cpsCMD" 1 >> ${logDir}${logName} 2>&1
# extract size of output
if [ -e $1.Z ]
then
	size=`ls -l $1.Z | awk '{ print $5 }'`
else
	size=`ls -l $1 | awk '{ print $5 }'` # no compression
fi
# padding or prune
if [ $size -ge $standard ]
then
	echo "Padding: 0" >> ${logDir}${logName} 
	echo "Overflow: \c" >> ${logDir}${logName} 
	echo "($size-928)/928" | bc -l >> ${logDir}${logName} 
else
	echo "Padding: \c"  >> ${logDir}${logName} 
	echo "(928-$size)/928" | bc -l >> ${logDir}${logName} 
	echo "Overflow: 0" >> ${logDir}${logName} 
fi
$timeBin "$dcpsCMD" 1 >> ${logDir}${logName} 2>&1
mv $1 ${outputDir}${targetName}.lzw
mv $1.bk $1
$cmpBin $1 ${outputDir}${targetName}.lzw >> ${logDir}${logName} 

# ZIP compression
echo "-------------ZIP----------------" >> ${logDir}${logName}
cpsCMD="zip $1.zip $1 >> ${logDir}${logName} 2>&1"
dcpsCMD="unzip $1.zip -d $outputDir >> ${logDir}${logName} 2>&1"
$timeBin "$cpsCMD" 1 >> ${logDir}${logName} 2>&1
size=`ls -l $1.zip | awk '{ print $5 }'`
if [ $size -ge $standard ]
then
	echo "Padding: 0" >> ${logDir}${logName} 
	echo "Overflow: \c" >> ${logDir}${logName} 
	echo "($size-928)/928" | bc -l >> ${logDir}${logName} 
else
	echo "Padding: \c"  >> ${logDir}${logName} 
	echo "(928-$size)/928" | bc -l >> ${logDir}${logName} 
	echo "Overflow: 0" >> ${logDir}${logName} 
fi
$timeBin "$dcpsCMD" 1 >> ${logDir}${logName} 2>&1
mv $outputDir$1 $outputDir${targetName}.zip
rm $1.zip
$cmpBin $1 ${outputDir}${targetName}.zip >> ${logDir}${logName} 2>&1

# gzip compression
echo "-------------gZIP----------------" >> ${logDir}${logName}
cpsCMD="gzip -v $1 >> ${logDir}${logName} 2>&1"
dcpsCMD="gzip -d $1.gz >> ${logDir}${logName} 2>&1"
cp $1 $1.bk
$timeBin "$cpsCMD" 1 >> ${logDir}${logName} 2>&1
size=`ls -l $1.gz | awk '{ print $5 }'`
if [ $size -ge $standard ]
then
	echo "Padding: 0" >> ${logDir}${logName} 
	echo "Overflow: \c" >> ${logDir}${logName} 
	echo "($size-928)/928" | bc -l >> ${logDir}${logName} 
else
	echo "Padding: \c"  >> ${logDir}${logName} 
	echo "(928-$size)/928" | bc -l >> ${logDir}${logName} 
	echo "Overflow: 0" >> ${logDir}${logName} 
fi
$timeBin "$dcpsCMD" 1 >> ${logDir}${logName} 2>&1
mv $1 ${outputDir}${targetName}.gzip
mv $1.bk $1
$cmpBin $1 ${outputDir}${targetName}.gzip >> ${logDir}${logName} 2>&1

# bz compression
echo "-------------bZ----------------" >> ${logDir}${logName}
cpsCMD="bzip2 -v $1 >> ${logDir}${logName} 2>&1"
dcpsCMD="bzip2 -d $1.bz2 >> ${logDir}${logName} 2>&1"
cp $1 $1.bk
$timeBin "$cpsCMD" 1 >> ${logDir}${logName} 2>&1
size=`ls -l $1.bz2 | awk '{ print $5 }'`
if [ $size -ge $standard ]
then
	echo "Padding: 0" >> ${logDir}${logName} 
	echo "Overflow: \c" >> ${logDir}${logName} 
	echo "($size-928)/928" | bc -l >> ${logDir}${logName} 
else
	echo "Padding: \c"  >> ${logDir}${logName} 
	echo "(928-$size)/928" | bc -l >> ${logDir}${logName} 
	echo "Overflow: 0" >> ${logDir}${logName} 
fi
$timeBin "$dcpsCMD" 1 >> ${logDir}${logName} 2>&1
mv $1 ${outputDir}${targetName}.bz2
mv $1.bk $1
$cmpBin $1 ${outputDir}${targetName}.bz2 >> ${logDir}${logName} 2>&1




# Display statistics
#rm ${outputDir}*
echo "---------Finished-----------"
