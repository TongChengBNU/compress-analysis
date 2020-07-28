#!/bin/sh

# functionality: 
# 1. run compress-decompress cmd on <target-path>;
# 2. dump raw output into log/statistics.log;

if [ $# != 1 ]; then
	echo "Usage: $0 <target-path>"
	exit 1
fi


# overflow threshold
standard=928

cmpBin='bin/cmpBinary'
timeBin='bin/timer2'
lzwBin='bin/compress'

outputDir='output/'
logDir='log/'
binDir='bin/'

logName='statistics.log'
#targetName=`echo $1 | sed -e 's/\// /g;' | awk '{print $NF}'`
targetPath=$1
targetName=${targetPath##*/}
echo "Target: $targetPath" 
echo "targetName:" $targetName 


# LZW compression
# inplace compression and decompression; there might be no *.Z output if no compression occurs.
echo "-------------LZW----------------" > ${logDir}${logName} # init log
cpsCMD="$lzwBin -v $targetPath >> ${logDir}${logName} 2>&1"
dcpsCMD="$lzwBin -d $targetPath.Z >> ${logDir}${logName} 2>&1"
cp $targetPath $targetPath.bk # backup source data inplace
$timeBin "$cpsCMD" 1 >> ${logDir}${logName} 2>&1
# extract size of output
if [ -e $targetPath.Z ]; then
	size=`ls -l ${targetPath}.Z | awk '{ print $5 }'`
else
	size=`ls -l $targetPath | awk '{ print $5 }'` # no compression
fi
# padding or prune
if [ $size -ge $standard ]; then
	echo "Padding: 0" >> ${logDir}${logName} 
	echo "Overflow: 1" >> ${logDir}${logName} 
else
	echo "Padding: \c"  >> ${logDir}${logName} 
	echo "(${standard}-$size)/${standard}" | bc -l >> ${logDir}${logName} 
	echo "Overflow: 0" >> ${logDir}${logName} 
fi
$timeBin "$dcpsCMD" 1 >> ${logDir}${logName} 2>&1
$cmpBin ${targetPath}.bk ${targetPath} >> ${logDir}${logName} 
rm ${targetPath}
mv ${targetPath}.bk ${targetPath}


# zip compression
# copy compression and decompression
echo "-------------ZIP----------------" >> ${logDir}${logName}
cpsCMD="zip -D ${targetPath}.zip $targetPath >> ${logDir}${logName} 2>&1" # -D: don't establish directory
dcpsCMD="unzip ${targetPath}.zip >> ${logDir}${logName} 2>&1"
$timeBin "$cpsCMD" 1 >> ${logDir}${logName} 2>&1
mv $targetPath $targetPath.bk
size=`ls -l ${targetPath}.zip | awk '{ print $5 }'`
if [ $size -ge $standard ]; then
	echo "Padding: 0" >> ${logDir}${logName} 
	echo "Overflow: 1" >> ${logDir}${logName} 
else
	echo "Padding: \c"  >> ${logDir}${logName} 
	echo "(${standard}-$size)/${standard}" | bc -l >> ${logDir}${logName} 
	echo "Overflow: 0" >> ${logDir}${logName} 
fi
$timeBin "$dcpsCMD" 1 >> ${logDir}${logName} 2>&1
$cmpBin ${targetPath}.bk ${targetPath} >> ${logDir}${logName} 
rm ${targetPath} ${targetPath}.zip
mv ${targetPath}.bk ${targetPath}


# gzip compression
# inplace compression and decompression
echo "-------------gZIP----------------" >> ${logDir}${logName}
cpsCMD="gzip -v $targetPath >> ${logDir}${logName} 2>&1"
dcpsCMD="gzip -d $targetPath.gz >> ${logDir}${logName} 2>&1"
cp $targetPath $targetPath.bk
$timeBin "$cpsCMD" 1 >> ${logDir}${logName} 2>&1
size=`ls -l $targetPath.gz | awk '{ print $5 }'`
if [ $size -ge $standard ]; then
	echo "Padding: 0" >> ${logDir}${logName} 
	echo "Overflow: 1" >> ${logDir}${logName} 
else
	echo "Padding: \c"  >> ${logDir}${logName} 
	echo "(${standard}-$size)/${standard}" | bc -l >> ${logDir}${logName} 
	echo "Overflow: 0" >> ${logDir}${logName} 
fi
$timeBin "$dcpsCMD" 1 >> ${logDir}${logName} 2>&1
$cmpBin ${targetPath}.bk ${targetPath} >> ${logDir}${logName} 
rm ${targetPath}
mv ${targetPath}.bk ${targetPath}


# bzip2 compression
# inplace compression and decompression
echo "-------------bZ----------------" >> ${logDir}${logName}
cpsCMD="bzip2 -v $targetPath >> ${logDir}${logName} 2>&1"
dcpsCMD="bzip2 -d $targetPath.bz2 >> ${logDir}${logName} 2>&1"
cp $targetPath $targetPath.bk
$timeBin "$cpsCMD" 1 >> ${logDir}${logName} 2>&1
size=`ls -l $targetPath.bz2 | awk '{ print $5 }'`
if [ $size -ge $standard ]; then
	echo "Padding: 0" >> ${logDir}${logName} 
	echo "Overflow: 1" >> ${logDir}${logName} 
else
	echo "Padding: \c"  >> ${logDir}${logName} 
	echo "(${standard}-$size)/${standard}" | bc -l >> ${logDir}${logName} 
	echo "Overflow: 0" >> ${logDir}${logName} 
fi
$timeBin "$dcpsCMD" 1 >> ${logDir}${logName} 2>&1
$cmpBin ${targetPath}.bk ${targetPath} >> ${logDir}${logName} 
rm ${targetPath}
mv ${targetPath}.bk ${targetPath}




# Display statistics
#rm ${outputDir}*
echo "---------Finished-----------"
