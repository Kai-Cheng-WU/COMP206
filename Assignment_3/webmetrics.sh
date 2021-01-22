#!/bin/bash
input=${1}

if [ "$#" = 0 ]
then
	echo -e "Error: No log file given.\nUsage: ./webmetrics.sh <logfile>"
	exit 1
fi

if [ ! -f "$input" ]
then
	echo -e "Error: File '$input' does not exist.\nUsage: ./webmetrics.sh <logfile>"
	exit 2
fi

numS=$(grep -c "Safari" "$input")
numF=$(grep -c "Firefox" "$input")
numC=$(grep -c "Chrome" "$input")

echo -e "Number of requests per web browser"
echo -e "Safari,$numS"
echo -e "Firefox,$numF"
echo -e "Chrome,$numC"
echo -e

echo -e "Number of distinct users per day"
datels=$(awk -F ' |:' '{ ls[$4]++} END { for (i in ls) {print i}}' "$input")
datels=$(sed 's/[][]//g' <<< "$datels")
newdatels=${datels//$' '/\n}
sorted=$(echo "$newdatels" | sort -nu)

for i in $sorted
do
	grep $i "$input" >tmpfile.txt
	awk -F ' |:' '{ ls[$1]++} END { for (i in ls) {print i}}' tmpfile.txt > tmpfile2.txt
	number=$(wc -l tmpfile2.txt | awk '{print $1}')
	echo -e "$i,$number"
	rm tmpfile.txt
	rm tmpfile2.txt
done

echo -e
echo -e "Top 20 popular product requests"
grep "GET /product/[0-9]*/" "$input" >productls.txt
awk -F '/| ' '{ print $11}' productls.txt > ID.txt
awk '{print$1}' ID.txt | sort | uniq -c | sort -b -n -r >sorted.txt
tr -s " " < sorted.txt > sorted2.txt
sort -n -r -k1,1 -k2,2 sorted2.txt -o sorted3.txt
rm ID.txt
rm productls.txt
rm productlsproto.txt
rm sorted.txt
rm sorted2.txt

i=1
while (( i < 21 ))
do
	product=$(awk -v line="$i" 'NR==line{print $2}' sorted3.txt)
	occurence=$(awk -v line="$i" 'NR==line{print $1}' sorted3.txt)
	((i ++))
	echo -e "$product,$occurence"
done
rm sorted3.txt
exit 0


