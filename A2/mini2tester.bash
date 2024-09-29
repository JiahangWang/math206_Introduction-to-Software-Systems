#!/bin/bash

### WARNING !!!!! STUDENTS MUST NOT CHANGE/EDIT THIS FILE !!!
### You might accidentally delete/change your files or change the intention of the test case
###   if you make changes to this sript without understanding the consequences.
### This script is intended to be executed in mimi using the bash shell.

# BEGIN SETUP
umask 077
testcaseprefix=""
testcasenum=0
function printTestCaseNum
{
		testcasenum=`expr $testcasenum + 1`
		echo "[$testcaseprefix] --> Test Case "`printf "%02d" $testcasenum`' <--'
}

tmpdir=/tmp/__tmp_comp206_${LOGNAME}_$$
mkdir -p $tmpdir
rc=$?

if [[ $rc -ne 0 ]]
then
	echo "FATAL ERROR during setup !!" 1>&2
	exit 1
fi

function cleanup()
{
# BEGIN CLEANUP
	if [[ -d $tmpdir ]]
	then
  	rm -r $tmpdir
	fi
# END CLEANUP
}

scriptdir=$PWD

# END SETUP


if [[ ! -f coderback.bash ]]
then
	echo "WARNING !! could not locate backup.sh in $scriptdir - those test cases will be skipped" 1>&2
else
	cp -p coderback.bash $tmpdir
	chmod u+x $tmpdir/coderback.bash
	cd $tmpdir
	export testcaseprefix="Ex1"

echo '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  coderback.bash Tests  @@@@@@@@@@@@@@@@@@@@@@@@'
echo ''
echo '********************************************************************************'
echo '[[[ Usage tests - all must fail ]]]'
printTestCaseNum
echo ./coderback.bash
./coderback.bash
prc=$?
echo "Return code from the program is $prc"
echo ''

mkdir $tmpdir/cb
mkdir $tmpdir/cb/bakdir

printTestCaseNum
echo ./coderback.bash $tmpdir/cb/bakdir 
./coderback.bash $tmpdir/cb/bakdir 
prc=$?
echo "Return code from the program is $prc"
echo ''

printTestCaseNum
echo ./coderback.bash $tmpdir/cb/bakdir nosuchdir
./coderback.bash $tmpdir/cb/bakdir nosuchdir
prc=$?
echo "Return code from the program is $prc"
echo ''

mkdir $tmpdir/cb/srcdir
mkdir $tmpdir/cb/srcdir/data
echo "A simple file" > $tmpdir/cb/srcdir/msg1.txt
echo "print('hello')" > $tmpdir/cb/srcdir/hello.py
echo "Data contents" > $tmpdir/cb/srcdir/data/contents.txt
printTestCaseNum
echo ./coderback.bash $tmpdir/cb/bakdirnot $tmpdir/cb/srcdir
./coderback.bash $tmpdir/cb/bakdirnot $tmpdir/cb/srcdir
prc=$?
echo "Return code from the program is $prc"
echo ''

printTestCaseNum
mkdir $tmpdir/cb/srcdir2
echo "hello" > $tmpdir/cb/srcdir2/msg.txt
echo "Present working directory is $PWD"
echo ./coderback.bash $tmpdir/cb/srcdir2 cb/srcdir2/
./coderback.bash $tmpdir/cb/srcdir2 cb/srcdir2/
prc=$?
echo "Return code from the program is $prc"
echo ''

printTestCaseNum
echo ./coderback.bash $tmpdir/cb/srcdir2/ $tmpdir/cb/srcdir2
./coderback.bash $tmpdir/cb/srcdir2/ $tmpdir/cb/srcdir2
prc=$?
echo "Return code from the program is $prc"
echo ''

echo '********************************************************************************'

echo "Dummy data" > $tmpdir/cb/bakdir/srcdir.20220120.tar
touch -d "Jan 20 2022" $tmpdir/cb/bakdir/srcdir.20220120.tar
echo "Something else to add" > $tmpdir/cb/bakdir/srcdir.20220202.tar
touch -d "Feb 2 2022" $tmpdir/cb/bakdir/srcdir.20220202.tar
echo "One more" >  $tmpdir/cb/bakdir/anothersrcdir.20220203.tar
touch -d "Feb 3 2022" $tmpdir/cb/bakdir/anothersrcdir.20220203.tar

echo '[[[ Valid Scenario ]]]'
printTestCaseNum
echo "Backup dir contents"
echo "ls -l $tmpdir/cb/bakdir/"
ls -l $tmpdir/cb/bakdir/
echo "Source dir contents"
echo "ls -l $tmpdir/cb/srcdir"
ls -l $tmpdir/cb/srcdir
echo ./coderback.bash $tmpdir/cb/bakdir $tmpdir/cb/srcdir
./coderback.bash $tmpdir/cb/bakdir $tmpdir/cb/srcdir
prc=$?
echo "Return code from the program is $prc"
echo "Backup dir contents"
echo "ls -l $tmpdir/cb/bakdir/"
ls -l $tmpdir/cb/bakdir/
if [[ -f $tmpdir/cb/bakdir/srcdir.$(date '+%Y%m%d').tar ]]
then
	echo "Contents of $tmpdir/cb/bakdir/srcdir.$(date '+%Y%m%d').tar"
	tar -vPtf $tmpdir/cb/bakdir/srcdir.$(date '+%Y%m%d').tar
else
	echo "Error $tmpdir/cb/bakdir/srcdir.$(date '+%Y%m%d').tar cannot be located"
fi
echo ''


echo '[[[ Valid Scenario  - do not overwrite ]]]'
printTestCaseNum
touch -d "Jan 21 2022" $tmpdir/cb/bakdir/srcdir.$(date '+%Y%m%d').tar
echo "ls -l $tmpdir/cb/bakdir/"
ls -l $tmpdir/cb/bakdir/
echo "echo n | ./coderback.bash $tmpdir/cb/bakdir $tmpdir/cb/srcdir"
echo n | ./coderback.bash $tmpdir/cb/bakdir $tmpdir/cb/srcdir
prc=$?
echo "Return code from the program is $prc"
echo "Backup dir contents - timestamp of the archive file $tmpdir/cb/bakdir/srcdir.$(date '+%Y%m%d').tar should not have changed"
echo "ls -l $tmpdir/cb/bakdir/"
ls -l $tmpdir/cb/bakdir/
echo ''


echo '[[[ Valid Scenario  - overwrite ]]]'
printTestCaseNum
touch -d "Jan 21 2022" $tmpdir/cb/bakdir/srcdir.$(date '+%Y%m%d').tar
echo "ls -l $tmpdir/cb/bakdir/"
ls -l $tmpdir/cb/bakdir/
echo "echo y | ./coderback.bash $tmpdir/cb/bakdir $tmpdir/cb/srcdir"
echo y | ./coderback.bash $tmpdir/cb/bakdir $tmpdir/cb/srcdir
prc=$?
echo "Return code from the program is $prc"
echo "Backup dir contents - timestamp of the archive file $tmpdir/cb/bakdir/srcdir.$(date '+%Y%m%d').tar should have changed"
echo "ls -l $tmpdir/cb/bakdir/"
ls -l $tmpdir/cb/bakdir/
echo ''

echo '[[[ Valid Scenario  - archive a file ]]]'
printTestCaseNum
mkdir -p $tmpdir/cb/srcdir3
echo "Test data" > $tmpdir/cb/srcdir3/data
echo "ls -l $tmpdir/cb/bakdir/"
ls -l $tmpdir/cb/bakdir/
echo ./coderback.bash $tmpdir/cb/bakdir cb/srcdir3/data
./coderback.bash $tmpdir/cb/bakdir cb/srcdir3/data
echo "ls -l cb/bakdir/"
ls -l cb/bakdir/
if [[ -f $tmpdir/cb/bakdir/data.$(date '+%Y%m%d').tar ]]
then
	echo "Contents of $tmpdir/cb/bakdir/data.$(date '+%Y%m%d').tar"
	tar -vtf $tmpdir/cb/bakdir/data.$(date '+%Y%m%d').tar
else
	echo "Error $tmpdir/cb/bakdir/data.$(date '+%Y%m%d').tar cannot be located"
fi

fi #End of coderback.bash test cases.


cd $scriptdir

if [[ ! -f deltad.bash ]]
then
	echo "WARNING !! could not locate backup.sh in $scriptdir - those test cases will be skipped" 1>&2
else
	cp -p deltad.bash $tmpdir
	chmod u+x $tmpdir/deltad.bash
	cd $tmpdir
	export testcaseprefix="Ex2"

echo '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  deltad.bash Tests  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
echo ''
echo '********************************************************************************'
echo '[[[ Usage tests - all must fail ]]]'
printTestCaseNum
echo ./deltad.bash
./deltad.bash
prc=$?
echo "Return code from the program is $prc"
echo ''

mkdir -p $tmpdir/dd/src1 $tmpdir/dd/src2

printTestCaseNum
echo ./deltad.bash $tmpdir/dd/src1
./deltad.bash $tmpdir/dd/src1
prc=$?
echo "Return code from the program is $prc"
echo ''

echo '[[[ Directory not exists - all must fail ]]]'
printTestCaseNum
echo ./deltad.bash dd/src1 dd/srcn
./deltad.bash dd/src1 dd/srcn
prc=$?
echo "Return code from the program is $prc"
echo ''

printTestCaseNum
echo ./deltad.bash $tmpdir/dd/srcn dd/src2
./deltad.bash $tmpdir/dd/srcn dd/src2
prc=$?
echo "Return code from the program is $prc"
echo ''

echo '[[[ Both directories are the same - must fail ]]]'
printTestCaseNum
echo ./deltad.bash dd/src1 $tmpdir/dd/src1
./deltad.bash dd/src1 $tmpdir/dd/src1
prc=$?
echo "Return code from the program is $prc"
echo ''

echo '[[[ argument(s) not directory - must fail ]]]'
printTestCaseNum
echo ./deltad.bash dd/src1 /bin/ls
./deltad.bash dd/src1 /bin/ls
prc=$?
echo "Return code from the program is $prc"
echo ''

printTestCaseNum
echo ./deltad.bash /bin/ls $tmpdir/dd/src1 
./deltad.bash /bin/ls $tmpdir/dd/src1 
prc=$?
echo "Return code from the program is $prc"
echo ''

echo '[[[ both directories empty - must work - no output should be displayed ]]]'
printTestCaseNum
echo ./deltad.bash dd/src1 $tmpdir/dd/src2
./deltad.bash dd/src1 $tmpdir/dd/src2
prc=$?
echo "Return code from the program is $prc"
echo ''

echo '[[[ directories have contents - must work - output should be displayed ]]]'
echo "This is one file" > $tmpdir/dd/src1/file1.txt; echo "This is one file" > $tmpdir/dd/src2/file1.txt
echo "This is second file" > $tmpdir/dd/src1/file2.txt; echo "This is the second file" > $tmpdir/dd/src2/file2.txt
echo "This is the 3rd file" > $tmpdir/dd/src1/file3.txt;
echo "This is the fourth file" > $tmpdir/dd/src2/file4.txt
echo "This is the fifth file" > $tmpdir/dd/src2/file5.txt
printTestCaseNum
echo ./deltad.bash $tmpdir/dd/src1 dd/src2
./deltad.bash $tmpdir/dd/src1 dd/src2
prc=$?
echo "Return code from the program is $prc"
echo ''

echo '[[[ directories have subdirectories - must not include them in the output ]]]'
mkdir $tmpdir/dd/src1/subdir1
mkdir $tmpdir/dd/src1/subdir2
mkdir $tmpdir/dd/src2/subdir2
printTestCaseNum
echo ./deltad.bash dd/src1 dd/src2
./deltad.bash dd/src1 dd/src2
prc=$?
echo "Return code from the program is $prc"
echo ''

fi # end deltad.bash test cases


cleanup
