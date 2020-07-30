


# bin/compress -> ncompress
# zip,gzip,bzip2 are default software in linux distribution
# sudo apt install ncompress zip gzip bzip2


Usage(){
	cat << EOF
./dependency.sh <seqDir> <tableDir> <logDir>
Functionality: init <seqDir> <tableDir> <logDir>
EOF
}

if [ $# -ne 3 ]; then
	Usage
	exit 1
fi

seqDir=$1
tableDir=$2
logDir=$3
if [ -d $seqDir ]; then
	rm -f $seqDir/*
else
	mkdir $seqDir
fi
if [ -d $tableDir ]; then
	rm -f $tableDir/*
else
	mkdir $tableDir
fi
if [ -d $logDir ]; then
	rm -f $logDir/*
else
	mkdir $logDir
fi

# init table/
echo "---Initialize $tableDir---"
head="percentage(no padding),percentage(padding),overflow,compress(ms),decompress(ms),correctness(1/0)"
echo $head > $tableDir/lzw.table
echo $head > $tableDir/zip.table
echo $head > $tableDir/gzip.table
echo $head > $tableDir/bz2.table

# init log/
echo "---Initialize $logDir---"
touch $logDir/statistics.log
touch $logDir/val.log
touch $logDir/run.log

