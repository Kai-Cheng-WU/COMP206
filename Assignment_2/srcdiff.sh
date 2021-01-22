#!/bin/bash
input=${1}
input2=${2}
if [ "$#"  != 2 ]
then
        echo -e "Error: Expected two input parameters.\nUsage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
        exit 1
fi
#########################
if [ ! -d "$input" ]
then
        echo -e "Error: Input parameter #1 '$input' is not a directory.\nUsage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
        exit 2
fi
##########################
if [ ! -d "$input2" ]
then
        echo -e "Error: Input parameter #1 '$input2' is not a directory.\nUsage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
        exit 2
fi
#########################
if [[ "$input" == "$input2" ]]
then
        echo -e "Error: The two inputs are the same.\nUsage: ./srcdiff.sh <originaldirectory> <comparisondirtobackup>"
        exit 2
fi

##########################
#Got the permission of using the find command from piazza
#First loop to check if there are files missing from the second dir
#Also checks for files with same name but diff. content

flag=true
name=true
content=true
for i in $(ls $input)
do
	name=false
	content=false

	Find=$(find $input2 -name $i)
	base=$( basename "$Find")
	if [ "$i" = "$base" ]
	then
		name=true
		Diff=$(diff $input/$i $input2/$base)
		if  [ "$Diff" = "" ]
		then
			content=true
		else
			echo "$input2/$i differs"
			content=false
			flag=false
		fi
	fi

	if [ "$name" = false ]
	then
		echo "$input2/$i is missing"
		flag=false
	fi
done

######################
#Second loop to check if there are files missing from the first dir
for i in $(ls $input2)
do
        name=false
	Find=$(find $input -name $i)
	base=$( basename "$Find")
        if [ "$i" = "$base" ]
	then
		 name=true
	fi


        if [ "$name" = false ]
        then
                echo "$input/$i is missing"
		flag=false
        fi
done

if [ "$content" = false ]
	then
	flag=false
fi

if [ "$name" = false ]
	then
	flag=false
fi

if [ "$flag" = false ]
	then
	exit 3
fi

exit 0

