#!/bin/sh

# functionality: 
# 1. run compress-decompress cmd on <target-path>;
# 2. dump raw output into log/statistics.log;

if [ $# -ne 3 ]; then
	echo "Usage: $0 <target-path> <logDir> <frameSize>"
	exit 1
fi


# overflow threshold
standard=928
frameSize=$3

workDir=$(cd `dirname $0`; pwd) # XX/script
binDir=${workDir%/*}'/bin'
cmpBin=${binDir}'/cmpBinary'
timeBin=${binDir}'/timer2'
lzwBin=${binDir}'/compress'

logDir=`cd $2; pwd`
logPath=$logDir"/statistics.log"

targetPath=$1
targetName=${targetPath##*/}
echo "Target: $targetPath" 
echo "targetName:" $targetName 


# LZW compression
# inplace compression and decompression; there might be no *.Z output if no compression occurs.
echo "-------------LZW----------------" > ${logPath} # init log
cpsCMD="$lzwBin -v $targetPath >> ${logPath} 2>&1"
dcpsCMD="$lzwBin -d $targetPath.Z >> ${logPath} 2>&1"
cp $targetPath $targetPath.bk # backup source data inplace
$timeBin "$cpsCMD" 1 >> ${logPath} 2>&1
#$timeBin "$cpsCMD" 1 > /dev/null 2>&1
# extract size of output
if [ -e $targetPath.Z ]; then
	size=`ls -l ${targetPath}.Z | awk '{ print $5 }'`
else
	size=`ls -l $targetPath | awk '{ print $5 }'` # no compression
fi
# no padding compression rate 
echo -n "NoPadding: " >> ${logPath}
echo "${size}/${frameSize}" | bc -l >> ${logPath} 
# padding or prune
if [ $size -ge $standard ]; then
	echo -n "Padding: " >> ${logPath} 
	echo "${size}/${frameSize}" | bc -l >> ${logPath} 
	echo "Overflow: 1" >> ${logPath} 
else
	echo -n "Padding: "  >> ${logPath} 
	echo "${standard}/${frameSize}" | bc -l >> ${logPath} 
	echo "Overflow: 0" >> ${logPath} 
fi
if [ -e $targetPath.Z ]; then
	# compression occurs
	$timeBin "$dcpsCMD" 1 >> ${logPath} 2>&1
else
	# echo Usage time into logPath
	echo "Usage time: 0" >> ${logPath}
fi
$cmpBin ${targetPath}.bk ${targetPath} >> ${logPath} 
rm ${targetPath}
mv ${targetPath}.bk ${targetPath}


# zip compression
# copy compression and decompression
echo "-------------ZIP----------------" >> ${logPath}
#cpsCMD="zip -D ${targetPath}.zip $targetPath >> ${logPath} 2>&1" # -D: don't establish directory
#dcpsCMD="unzip -D ${targetPath}.zip ${targetPath} >> ${logPath} 2>&1"
#$timeBin "$cpsCMD" 1 >> ${logPath} 2>&1
#mv $targetPath $targetPath.bk
#size=`ls -l ${targetPath}.zip | awk '{ print $5 }'`
#if [ $size -ge $standard ]; then
#	echo "Padding: 0" >> ${logPath} 
#	echo "Overflow: 1" >> ${logPath} 
#else
#	echo "Padding: \c"  >> ${logPath} 
#	echo "(${standard}-$size)/${standard}" | bc -l >> ${logPath} 
#	echo "Overflow: 0" >> ${logPath} 
#fi
#$timeBin "$dcpsCMD" 1 >> ${logPath} 2>&1
#$cmpBin ${targetPath}.bk ${targetPath} >> ${logPath} 
#rm ${targetPath} ${targetPath}.zip
#mv ${targetPath}.bk ${targetPath}
cd `dirname ${targetPath}`
echo "`pwd`" >> $logPath
cpsCMD="zip -D ${targetName}.zip $targetName >> ${logPath} 2>&1" # -D: don't establish directory
dcpsCMD="unzip ${targetName}.zip ${targetName} >> ${logPath} 2>&1"
$timeBin "$cpsCMD" 1 >> ${logPath} 2>&1
#$timeBin "$cpsCMD" 1 > /dev/null 2>&1
mv $targetName $targetName.bk
size=`ls -l ${targetName}.zip | awk '{ print $5 }'`
# no padding compression rate 
echo -n "NoPadding: " >> ${logPath}
echo "${size}/${frameSize}" | bc -l >> ${logPath} 
# padding or prune
if [ $size -ge $standard ]; then
	echo -n "Padding: " >> ${logPath} 
	echo "${size}/${frameSize}" | bc -l >> ${logPath} 
	echo "Overflow: 1" >> ${logPath} 
else
	echo -n "Padding: "  >> ${logPath} 
	echo "${standard}/${frameSize}" | bc -l >> ${logPath} 
	echo "Overflow: 0" >> ${logPath} 
fi
$timeBin "$dcpsCMD" 1 >> ${logPath} 2>&1
$cmpBin ${targetName}.bk ${targetName} >> ${logPath} 
rm ${targetName} ${targetName}.zip
mv ${targetName}.bk ${targetName}
cd ${workDir}


# gzip compression
# inplace compression and decompression
echo "-------------gZIP----------------" >> ${logPath}
cpsCMD="gzip -v $targetPath >> ${logPath} 2>&1"
dcpsCMD="gzip -d $targetPath.gz >> ${logPath} 2>&1"
cp $targetPath $targetPath.bk
$timeBin "$cpsCMD" 1 >> ${logPath} 2>&1
#$timeBin "$cpsCMD" 1 > /dev/null 2>&1
size=`ls -l $targetPath.gz | awk '{ print $5 }'`
# no padding compression rate 
echo -n "NoPadding: " >> ${logPath}
echo "${size}/${frameSize}" | bc -l >> ${logPath} 
# padding or prune
if [ $size -ge $standard ]; then
	echo -n "Padding: " >> ${logPath} 
	echo "${size}/${frameSize}" | bc -l >> ${logPath} 
	echo "Overflow: 1" >> ${logPath} 
else
	echo -n "Padding: "  >> ${logPath} 
	echo "${standard}/${frameSize}" | bc -l >> ${logPath} 
	echo "Overflow: 0" >> ${logPath} 
fi
$timeBin "$dcpsCMD" 1 >> ${logPath} 2>&1
$cmpBin ${targetPath}.bk ${targetPath} >> ${logPath} 
rm ${targetPath}
mv ${targetPath}.bk ${targetPath}


# bzip2 compression
# inplace compression and decompression
echo "-------------bz2----------------" >> ${logPath}
cpsCMD="bzip2 -v $targetPath >> ${logPath} 2>&1"
dcpsCMD="bzip2 -d $targetPath.bz2 >> ${logPath} 2>&1"
cp $targetPath $targetPath.bk
$timeBin "$cpsCMD" 1 >> ${logPath} 2>&1
#$timeBin "$cpsCMD" 1 > /dev/null 2>&1
size=`ls -l $targetPath.bz2 | awk '{ print $5 }'`
# no padding compression rate 
echo -n "NoPadding: " >> ${logPath}
echo "${size}/${frameSize}" | bc -l >> ${logPath} 
# padding or prune
if [ $size -ge $standard ]; then
	echo -n "Padding: " >> ${logPath} 
	echo "${size}/${frameSize}" | bc -l >> ${logPath} 
	echo "Overflow: 1" >> ${logPath} 
else
	echo -n "Padding: "  >> ${logPath} 
	echo "${standard}/${frameSize}" | bc -l >> ${logPath} 
	echo "Overflow: 0" >> ${logPath} 
fi
$timeBin "$dcpsCMD" 1 >> ${logPath} 2>&1
$cmpBin ${targetPath}.bk ${targetPath} >> ${logPath} 
rm ${targetPath}
mv ${targetPath}.bk ${targetPath}




echo "---------Finished-----------"
