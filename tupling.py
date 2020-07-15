#!/usr/bin/python3
valLength=24 # length of val.log

def percentageProcessor(line):
    rst = eval(line.split('%')[0])
    rst = (100 - rst) / 100
    return rst

def paddingProcessor(line):
    line = line.split("\n")[0]
    keyword = line.split(" ")[-1]
    return eval(keyword)

def overflowProcessor(line):
    return paddingProcessor(line)

def timeProcessor(line):
    line = line.split(' ')[-1]
    sec = eval(line.split('s')[0])
    msec = 1000 * sec
    return msec

def cmpProcessor(line):
    line = line.split(" ")[-1];
    keyword = line.split(".")[0];
    if(keyword == "identical"):
        return 1
    elif(keyword == "different"):
        return 0
    else:
        return -1

def main():
    name = 'log/val.log'
    fd = open(name, 'r')
    if (len(fd.readlines()) != valLength):
        print("Update table/ failed;(val.log too short)")
        return
    fd.seek(0)
        
    tuple_container = [] 
    # compression ratio
    for _ in range(4):
        percentage = percentageProcessor(fd.readline())
        ele = '{:.4}'.format(percentage) + ','
        tuple_container.append(ele)

    # padding
    for ele, i in zip(tuple_container, range(4)):
        padding = paddingProcessor(fd.readline())
        if(padding == 0):
            ele = ele * 2 # copy percentage
        else:
            ele = ele + '{:.4}'.format(padding) + ','
        tuple_container[i] = ele

    # overflow
    for ele, i in zip(tuple_container, range(4)):
        overflow = overflowProcessor(fd.readline())
        if(overflow == 0):
            ele = ele + '0'
        else:
            ele = ele + '{:.4}'.format(overflow) + ','
        tuple_container[i] = ele

    # compress, decompress time
    for ele, i in zip(tuple_container, range(4)):
        cpsTime = timeProcessor(fd.readline())
        dcpsTime = timeProcessor(fd.readline())
        ele = ele + '{:.3}'.format(cpsTime) + ',' + '{:.3}'.format(dcpsTime)
        ele = ele + ","
        tuple_container[i] = ele

    # identical binary 
    for ele, i in zip(tuple_container, range(4)):
        boolean = cmpProcessor(fd.readline())
        ele = ele + str(boolean) + "\n"
        tuple_container[i] = ele

    fd.close()
    paths = ('table/lzw.table', 'table/zip.table', 'table/gzip.table', 'table/bz2.table')
    for path, line in zip(paths, tuple_container):
        with open(path, 'a+') as fd:
            fd.write(line)

    print("Update table/ finished;")
    return




if __name__ == '__main__':
    main()
