bash auto.sh ./data 10 # very fast
echo ""

for ((i=5;i>0;i-=1)); do
	printf "Progress: %d s left\r" $i
	sleep 1
done
echo -e "\n\n"

cd stat
bash totalSumUp.sh
echo ""
python3 parse.py
echo ""
