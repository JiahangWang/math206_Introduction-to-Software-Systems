#!/bin/bash

#Jiahang Wang
#261011319


#check argument
if [[ $# -ne 1 ]]
then
	echo "Usage ./wparser.bash <weatherdatadir>"
	exit 1
fi

#check directory name 
if [[ ! -d $1 ]]
then
	echo Error! /nosuchdir is not a valid directory name >&2
	exit 1
fi

dir=$1
filelist=$(find $1 -name "weather_info_*.data")


# function of extract data
function extractData(){
echo "Processing Data From $1"
echo "===================================="
echo "Year,Month,Day,Hour,TempS1,TempS2,TempS3,TempS4,TempS5,WindS1,WindS2,WindS3,WinDir"
sed -e '/di/'d -e '/signal/'d -e 's/ \[data log flushed] / /g' -e 's/ observation line //g' -e's/-/,/' < $1 |
sed -e 's/':..:..'//g' -e's/-/,/' -e 's/NOINF/null/g' -e 's/MISSED SYNC STEP/null/g' | 
sed -e 's/ /,/g' |
awk 'BEGIN{FS=",";{for(i=0;i<=13;i++)a[i]=""}} {for(i=0;i<=13;i++)
	{if($i == "null") sub($i,a[i]); else a[i]=$i};
	};{print $0}' |
awk 'BEGIN{FS=","}{
	if ($13==0)
	  sub($13,"N",$13);
	else if ($13==1)
	  sub($13,"NE",$13);
	else if ($13==2)
	  sub($13,"E",$13);
	else if ($13==3)
          sub($13,"SE",$13);
	else if ($13==4)
	  sub($13,"S",$13);
	else if ($13==5)
	  sub($13,"SW",$13);
	else if ($13==6)
          sub($13,"W",$13);
	else if ($13==7)
          sub($13,"NW",$13)
	};{print $0}
' |
sed -e 's/ /,/g' 
echo "===================================="
echo "Observation Summary"
echo "Year,Month,Day,Hour,MaxTemp,MinTemp,MaxWS,MinWS"
sed -e '/di/'d -e '/signal/'d -e 's/ \[data log flushed] / /g' -e 's/ observation line //g' -e's/-/,/' < $1 |
sed -e 's/':..:..'//g' -e's/-/,/' -e 's/NOINF/999/g' -e 's/MISSED SYNC STEP/999/g' |
sed -e 's/ /,/g' |
awk 'BEGIN{FS=",";min=900;max=-900} {for(i=5;i<=9;i++)
	 {if($i != 999)
		{if($i < min) min=$i;
		if($i > max) max=$i}
	 }
	};{sub($5,max,$5)};{sub($6,min,$6)};{sub($7,"",$7)};{sub($8,"",$8)};{sub($9,"",$9)};{sub($13," ",$13)}
	;{print $0};{min=900;max=-900}
' |
sed -e 's/   //g' |
awk 'BEGIN{FS=" ";min=900;max=-900} {for(i=7;i<=9;i++)
                {if($i < min) min=$i;
                if($i > max) max=$i}
        };{sub($7,max,$7)};{sub($8,min,$8)};{sub($9,"  ",$9)}
        ;{print $0};{min=900;max=-900}
' |
sed -e 's/   //g'|
sed -e 's/ /,/g'
echo "===================================="
}

# produce the two statistics for each data file
for i in $filelist
 do
         extractData $i
done

# function of analyze the temperature sensor for each day
function analyze(){
	sed -e '/di/'d -e '/signal/'d -e 's/ \[data log flushed] / /g' -e 's/ observation line //g' -e's/-/,/' < $1 |
	sed -e 's/':..:..'//g' -e's/-/,/' -e 's/NOINF/999/g' -e 's/MISSED SYNC STEP/999/g' |
	sed -e 's/ /,/g' |
	awk ' BEGIN{FS=",";year=0;month=0;day=0;t1=0;t2=0;t3=0;t4=0;t5=0;total=0} {for(i=5;i<=9;i++)
		{if($i==999)
			{if(i==5)
			  t1++;
			 else if(i==6)
			  t2++;
			 else if(i==7)
			  t3++;
			 else if(i==8)
			  t4++;
			 else if(i==9)
			  t5++;
			}
		}
	};{year=$1;month=$2;day=$3}
	END{total=t1+t2+t3+t4+t5;print year "</TD><TD>" month "</TD><TD>" day "</TD><TD>" t1 "</TD><TD>" t2 "</TD><TD>" t3 "</TD><TD>" t4 "</TD><TD>" t5 "</TD><TD>" total}'
}

# sort the data of all the file and put it into the target file
echo -e "<HTML>\n<BODY>\n<H2>Sensor error statistics</H2>\n<TABLE>" > sensorstats.html
echo "<TR><TH>Year</TH><TH>Month</TH><TH>Day</TH><TH>TempS1</TH><TH>TempS2</TH><TH>TempS3</TH><TH>TempS4</TH><TH>TempS5</TH><TH>Total</TH></TR>" >> sensorstats.html

for i in $filelist
 do
         analyze $i 
done |

sed -e 's/'..TD..TD.'/,/g' | 
sort -t "," -k 9nr -k 1n -k 2n -k 3n |
sed -e 's/,/'"<\/TD><TD>"'/g' -e 's/^/'"<TR><TD>"'/' -e 's/$/'"<\/TD><\/TR>"'/' >> sensorstats.html

echo -e "</TABLE>\n</BODY>\n</HTML>" >> sensorstats.html

