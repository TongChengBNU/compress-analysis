#!/home/chengtong/Software/anaconda3/bin/python3
import argparse
valLength=24 # length of val.log

def percentageProcessor(line):
    rst = eval(line.split('%')[0])
    rst = (100.0 - rst) / 100.0 # float arithematic
    return rst

# line format -- Name: XX\n
def paddingProcessor(line):
    line = line.split("\n")[0]
    keyword = line.split(" ")[-1]
    return keyword

def overflowProcessor(line):
    line = line.split("\n")[0]
    keyword = line.split(" ")[-1]
    return keyword

def timeProcessor(line):
    line = line.split(' ')[-1]
    sec = eval(line.split('s')[0])
    msec = 1000.0 * sec
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
    parser = argparse.ArgumentParser()
    parser.add_argument("logDir")
    parser.add_argument("tableDir")
    args = parser.parse_args()

    name = args.logDir + '/val.log'
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
            ele = ele * 2 # copy no-padding percentage, type(ele)=str
        else:
            ele = ele + '{:.4}'.format(padding) + ','
        tuple_container[i] = ele

    # overflow
    for ele, i in zip(tuple_container, range(4)):
        overflowVal = overflowProcessor(fd.readline())
        if(overflowVal == 0):
            ele = ele + '0' + ','
        else:
            ele = ele + '{:.4}'.format(overflowVal) + ','
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

    # paths should be consistent with order in generate.sh

    paths = (
            args.tableDir + '/lzw.table', 
            args.tableDir + '/zip.table', 
            args.tableDir + '/gzip.table', 
            args.tableDir + '/bz2.table', 
            )
    for path, line in zip(paths, tuple_container):
        with open(path, 'a+') as fd:
            fd.write(line)

    print("Update table/ finished;")
    return




if __name__ == '__main__':
    main()
