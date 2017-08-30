### this script is used to validate environment variables file with values.
### if there any variable without value it will notify the user 

#!/bin/bash 
#set -x 
not_found_flag=0  ### its flag to set to another value if script finds a variable without value 
### reading environment file 
while read value
do 
variable=`echo $value | cut -d'=' -f1`
value=`echo $value | cut -d'=' -f2`
if [ "$value" == "" ]
then 
	export not_found_flag=1
	if [ "$var" == "" ]
	then 
		var=$variable
	else 
		var=$var:$variable
	fi 
fi
done < txt.txt

if [ $not_found_flag -eq 1 ] 
then 
	echo the variables file contains null values .. please check 
	echo $var
fi 
