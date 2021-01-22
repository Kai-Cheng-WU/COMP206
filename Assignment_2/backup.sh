#!/bin/bash

input=${1}
input2=${2}


if [ "$#"  != 2 ]
then
	echo -e "Error: Expected two input parameters.\nUsage: ./backup.sh <backupdirectory> <fileordirtobackup>"
	exit 1
fi
#########################
if [ ! -d "$input" ]
then
	echo -e "Error: The directory ${input} does not exist.\nUsage: ./backup.sh <backupdirectory> <fileordirtobackup>"
	exit 2
fi
##########################
if [[ ! -d "$input2" && ! -f "$input2" ]]
then
        echo -e "Error: The directory/file  ${input2} does not exist.\nUsage: ./backup.sh <backupdirectory> <fileordirtobackup>"
        exit 2
fi
##########################
if [[ "$input" == "$input2" ]]
then
	echo -e "Error: The two inputs are the same.\nUsage: ./backup.sh <backupdirectory> <fileordirtobackup>"
	exit 2
fi

##########################

now=$(date +%Y%m%d)
base=$( basename "$input2")
filename=$base.$now.tar

if [[ -f "$input"/"$filename" ]]
then
	echo "Backup file '$base.$now.tar' already exists. Overwrite? (y/n)"
	read input3

	if [[ "$input3" == "y" ]]
	then
		tar -cvf $input/$base.$now.tar $input2
		exit 0


	else
		echo -e "Error: backupfile already exists. Not overwriting."
		exit 3
	fi
fi

tar -cvf $input/$base.$now.tar $input2
exit 0
