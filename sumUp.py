#!/home/tongcheng/anaconda3/bin/python3
import pandas as pd
import sys

def parse(filepath):
    try:
        df = pd.read_csv(filepath)
    except:
        print("Read data error;")
        return
    rst = []
    mean = df[['percentage(no padding)', 'percentage(padding)', 'overflow', 'compress(ms)', 'decompress(ms)']].mean()
    for _, val in mean.iteritems():
        rst.append(val)
    maxTime = df[['compress(ms)', 'decompress(ms)']].max()
    maxCps = maxTime['compress(ms)']
    maxDcps = maxTime['decompress(ms)']
    rst.insert(3, maxCps)
    rst.insert(5, maxDcps)
    correct = len(df[df['correctness(1/0)']==1.0]) / len(df)
    rst.append(correct)
    rst.append(len(df))
    rst.insert(0, 1506)
    return rst

def format(filepath):
    data = parse(filepath)
    head = ['有效数据长度', '平均压缩比（去掉补零位）', '平均压缩比（算上补零位）', '溢出率', '最大压缩时间（ms）', '平均压缩时间（ms）', '最大解压时间（ms）', '平均解压时间（ms）', '正确率', '统计帧数']
    if data is not None:
        tplt1='{0:-^30}: {1:<10}'
        tplt2='{0:-^30}: {1:<.2%}'
        for name, val in zip(head, data):
            if type(val) is int:
                print(tplt1.format(name, val))
            else:
                print(tplt2.format(name, val))
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


