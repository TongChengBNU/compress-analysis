#!/usr/bin/python3
import pandas as pd
import sys

def parse(filepath):
    try:
        df = pd.read_csv(filepath)
    except:
        print("Read data error;")
        return
    rst = []
    mean = df[['percentage(no padding)', 'percentage(padding)', 'compress(ms)', 'decompress(ms)']].mean()
    for _, val in mean.iteritems():
        rst.append(val)

    df['overflow'].astype('int64')
    tmp = df[df['overflow'] == 1]['overflow'].count()
    rst.insert(2, tmp / len(df) )

    maxTime = df[['compress(ms)', 'decompress(ms)']].max()
    maxCps = maxTime['compress(ms)']
    maxDcps = maxTime['decompress(ms)']
    rst.insert(3, maxCps)
    rst.insert(5, maxDcps)
    correct = len(df[df['correctness(1/0)']==1]) / len(df)
    rst.append(correct)
    rst.append(len(df))
    rst.insert(0, 1506)
    return rst

def format(filepath):
    data = parse(filepath)
    head = ['有效数据长度', '平均压缩比（去掉补零位）', '平均压缩比（算上补零位）', '溢出率（溢出帧占比）', '最大压缩时间（ms）', '平均压缩时间（ms）', '最大解压时间（ms）', '平均解压时间（ms）', '正确率', '统计帧数']
    if data is not None:
        tplt1='{0:-^30}: {1:<10}'
        tplt2='{0:-^30}: {1:<.2%}'
        tplt3='{0:-^30}: {1:<.2}'
        index=0
        for name, val in zip(head, data):
            if index == 0:
                print(tplt1.format(name, val))
            elif index == 1:
                print(tplt2.format(name, val))
            elif index == 2:
                print(tplt2.format(name, val))
            elif index == 3:
                print(tplt2.format(name, val))
            elif index == 4:
                print(tplt3.format(name, val))
            elif index == 5:
                print(tplt3.format(name, val))
            elif index == 6:
                print(tplt3.format(name, val))
            elif index == 7:
                print(tplt3.format(name, val))
            elif index == 8:
                print(tplt2.format(name, val))
            elif index == 9:
                print(tplt1.format(name, val))

            index=index+1
    else:
        print("Data error")
    return 


def main(): 
    if(len(sys.argv) != 2):
        print("Usage: " + sys.argv[0] + " <csv>")
        return
    print("Target: " + sys.argv[1])
    format(sys.argv[1])


if __name__ == '__main__':
    main()


