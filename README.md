# Compression Analysis
This project aims to analyze the efficiency of 4 compression algorithms: lzw, zip, gzip, bzip2 over binary data.

## Structure
dependency.sh: check dependency and initialize  
generate.sh: run compress-decompress cmd and dump raw output into log/statistics.log  
parse.sh: extract useful information from log/statistics.log into line-based data log/val.log  
tupling.py: extract tuples from log/val.log and append them in table/\*.table(csv file)  
sumUp.py: show analysis info about specific csv file from directory table  

## Dependency
```bash
$ sudo apt install ncompress 
$ pip install pandas
$ make # update bin/* in target machine
$ tar xvf seq.tar
```

## Basic running:

```bash
$ nohup ./run.sh & 
$ ls table/
$ ./sumUp.py table/bz2.table
```


