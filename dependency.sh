
#sudo apt install ncompress zip gzip bzip2

#export PATH=./bin:$PATH

pythonPath=`which python3`
sed -i "1c \#\!$pythonPath" tupling.py 
sed -i "1c \#\!$pythonPath" sumUp.py 

# init table/
head="percentage(no padding),percentage(padding),overflow,compress(ms),decompress(ms),correctness(1/0)"
echo $head > table/lzw.table
echo $head > table/zip.table
echo $head > table/gzip.table
echo $head > table/bz2.table
