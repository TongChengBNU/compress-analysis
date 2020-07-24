# Compression Analysis
This project aims to analyze the efficiency of 4 compression algorithms: lzw, zip, gzip, bzip2 over binary data.

## Structure
1. dependency.sh: check dependency and initialize  
2. generate.sh: run compress-decompress cmd and dump raw output into log/statistics.log  
3. parse.sh: extract useful information from log/statistics.log into line-based data log/val.log  
4. tupling.py: extract tuples from log/val.log and append them in table/\*.table(csv file)  
5. sumUp.py: show analysis info about specific csv file from directory table  

### bin: directory for binary executables
* cmpBinary: compare binary data files
* compress: ncompress algorithm exectuable
* parse: parse log/statistical.log, called by script parse.sh
* split: split arbitrary raw data into customized frames, being dumped into directory: sequence
* timer: estimate cmd execution time (measure)

## Dependency
```bash
# $ sudo apt install ncompress 
$ pip install pandas # sumUp.py dependency
$ make # update bin/* in target machine
```

## Basic running:

```bash
$ makedir sequence
$ ./bin/split input/<target> <framesize> ex. 1506
$ nohup ./run.sh & 
$ ls table/
$ ./sumUp.py table/bz2.table
```

## To be continued...
padding makes nonsense;
add feature about 算上补零位;
