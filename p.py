#!/home/chengtong/Software/anaconda3/bin/python3
import sys

def format(line):
    tokens = line.split(',')
    error_token = tokens[2]

    if(error_token.split('.')[0] == '00'):
        tokens.insert(2, '0')

    return ','.join(tokens)

def main():
    if(len(sys.argv) != 2):
        print("Usage: " + sys.argv[0] + " <filepath>")
        return
    print("Target: " + sys.argv[1])
    rd = open(sys.argv[1], 'r')
    wrt = open('wrt'+sys.argv[1], 'w')
    for line in rd.readlines():
        new_line = format(line)
        wrt.write(new_line);
    wrt.close()
    rd.close()
    return

if __name__ == '__main__':
    main()
    

