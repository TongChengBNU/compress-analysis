
# bin/compress -> ncompress
# zip,gzip,bzip2 are default software in linux distribution
#sudo apt install ncompress zip gzip bzip2

#export PATH=./bin:$PATH

# compile binary
echo "---Compile binary---"
make

# set up python interpreter 
echo "---Set up python interpreter---"
pythonPath=`which python3`
sed -i "1c \#\!$pythonPath" tupling.py 
sed -i "1c \#\!$pythonPath" sumUp.py 

# init table/
trgtDir=`pwd`"/table"
if [ ! -e $trgtDir ]; then 
	mkdir $trgtDir
fi
echo "---Initialize table/---"
head="percentage(no padding),percentage(padding),overflow,compress(ms),decompress(ms),correctness(1/0)"
echo $head > $trgtDir/lzw.table
echo $head > $trgtDir/zip.table
echo $head > $trgtDir/gzip.table
echo $head > $trgtDir/bz2.table
