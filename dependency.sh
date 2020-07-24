
# bin/compress -> ncompress
# zip,gzip,bzip2 are default software in linux distribution
#sudo apt install ncompress zip gzip bzip2

#export PATH=./bin:$PATH


# set up python interpreter 
echo "---Set up python interpreter---"
pythonPath=`which python3`
sed -i "1c \#\!$pythonPath" tupling.py 
sed -i "1c \#\!$pythonPath" sumUp.py 

# init table/
echo "---Initialize table/---"
head="percentage(no padding),percentage(padding),overflow,compress(ms),decompress(ms),correctness(1/0)"
echo $head > table/lzw.table
echo $head > table/zip.table
echo $head > table/gzip.table
echo $head > table/bz2.table
