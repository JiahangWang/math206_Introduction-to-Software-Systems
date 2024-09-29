#!/bin/bash
# Jiahang Wang
# Faculty of science
# 261011319

location=$1
file=$2

date=$(date +%Y%m%d)

name=$(basename $file)

# Determine whether the script is invoked with 2 arguments
if [[ $# -lt 2 ]]
then
	echo "Error: Expected two input parameters."
	echo "Usage: ./coderback.bash <backupdirectory> <fileordirtobackup>"
	exit 1
fi

# change the path to an absolute one if it's a relative path
if [[ ! $file =~ ^"/".* ]]
then
	file="$(pwd)/$file"
fi

if [[ ! $location =~ ^"/".* ]]
then
	location="$(pwd)/$location"
fi

dirname=$(dirname $file)
locname=$(basename $location)

# Determine whether the file or directory exist or coexist at same directory
if [[ ! -e $file ]]
then
	echo "Error: the file or directory '$name' does not exist."
	exit 2
elif [[ ! -d $location ]]
then
	echo "Error: The directory '$locname' does not exist."
	exit 2
elif [[ $name = $locname ]]
then
	echo "both directory are the same directory."
	exit 2
fi

# Determine whether the file have already exist and ask the user if they want to overwrite
newname="$name.$date.tar"
if [[ -n $( ls $location | grep $newname ) ]]
then
	echo "Backup file '$newname' already exists. Overwrite? (y/n)"
	read local answer
	if [[ $answer = y ]]
	then
		tar -cPf "$location/$newname" $file
	else
		exit 3
	fi
else
	tar -cPf "$location/$newname" $file
fi















