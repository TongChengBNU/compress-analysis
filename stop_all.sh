number=1
while [ $number -le 76 ]; do
	kill -s SIGSTOP %${number}
	number=`expr $number + 1`
done
