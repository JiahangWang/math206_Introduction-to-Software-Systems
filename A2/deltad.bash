#!/bin/bash

# Jiahang Wang
# Faculty of science
# 261011319

ori=$1
com=$2


# Check If the script receive 2 input parameters
if [[ $# -lt 2 ]]
then
	echo "Error: Expected two input parameters."
	echo "Usage: ./deltad.bash <originaldirectory> <comparisondirectory>"
	exit 1
fi

oriName=$(basename $ori)
comName=$(basename $com)

# Chenge the path to an absolute path if it's not
if [[ ! $ori =~ ^"/".* ]]
then 
	ori="$(pwd)/$ori"
fi

if [[ ! $com =~ ^"/".* ]]
then
	com="$(pwd)/$com"
fi


# Check if two parameters are not directories or the same directory
if [[ ! -d $ori ]]
then
	echo "Input parameter #1 $oriName is not a directory."
	exit 2
elif [[ ! -d $com ]]
then	
	echo "Input parameter #2 $comName is not a directory."
	exit 2
elif [[ $oriName = $comName ]]
then 
	echo "Input parameter #1 $oriName and #2 $comName are the same directory"
	exit 2
fi


# Determine whether there are differences in the two directories

oriFile=$(ls -p $ori)
comFile=$(ls -p $com)

count1=0
count2=0
for i in $comFile
do
	if [[ -d "$com/$i" ]]
	then
		echo >/dev/null
	elif [[ -z $(ls -p $ori | grep $i) ]]
	then
		echo "$ori/$i is missing"
		count1=$[$count1+1]
	elif [[ ! -z $(diff "$ori/$i" "$com/$i") ]]
	then
		echo "$ori/$i differs"
		count1=$[$count1+1]
	fi
done



for i in $oriFile
do
	if [[ -d "$ori/$i" ]]
	then
		echo >/dev/null
	elif [[ -z $(ls -p $com | grep $i ) ]]
	then
		echo "$com/$i is missing"
		count2=$[$count2+1]
	fi
done

# Exit the script
if [[ $count1 -gt 0 ]]
then
	exit 3
elif [[ $count2 -gt 0 ]]
then
	exit 3
fi

exit 0


