
# bin/compress -> ncompress
# zip,gzip,bzip2 are default software in linux distribution
# sudo apt install ncompress zip gzip bzip2


Usage(){
	cat << EOF
./dependency.sh <tableDir> <logDir>
EOF
}

if [ $# -ne 2 ]; then
	Usage
	exit 1
fi

tableDir=$1
logDir=$2
if [ ! -d $tableDir ] || [ ! -d $logDir ]; then
	echo "$tableDir or $logDir INVALID!!"
	exit 2
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

