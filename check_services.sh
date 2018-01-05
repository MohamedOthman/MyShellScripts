### this script is to monitor services and its consumed memory
### if the process exceeded its threshold in mega bytes it will be restarted 
### the script will work with line of three inputs name which will be the name of the process , threshold in megabytes , OS service name 

### created by Mohamed Amr , m.amr.cse@gmail.com 
flag="True"
trial_count=0
max_trials=3 ### maximum number of trials the script will do before restarting the service 
scripts_path="" ### enter the script path 
function check_service(){
	svc_line=$1 
	trial_count=0 ### reset the value of trial_count before checking the services 
	flag="True"  ### Making flag value true to enter the while loop 
	name=`echo $svc_line | cut -d',' -f1`   ### name which we will get from list of OS processes .. it should be unique 
	threshold=`echo $svc_line | cut -d',' -f2`  ### threshold
	service_name=`echo $svc_line | cut -d',' -f3` ### OS service name which will be called to restart the process .. the name should be exact because it will be used from the script .. any issue with name the script will not restart the service 
	#echo $name ..... $threshold ..... $service_name
	while [ $flag == "True" ]
	do
		mem_utl=`ps -eo rss,pid,euser,args:100 --sort %mem | grep -v grep | grep -i $name | awk '{printf $1/1024 "MB"; $1=""; print }' | awk '{ print $1 }' | cut -d'.' -f1 | awk '{ print $1 }'`
		echo current memroy utilization of $name process is $mem_utl
		if [ $mem_utl -ge $threshold ] 
		then
			trial_count=$(expr $trial_count + 1)
			echo $(date) $name  service reached its maximum and will be restarted after three trials >> ${scripts_path}/logs/services_restart.log 
			if [ $trial_count -eq $max_trials ]
			then
				sudo service $service_name restart 
				echo $(date) $name  service reached its maximum and will be restarted its memory now is $mem_utl >> ${scripts_path}/logs/services_restart.log 
				flag="False"
			else 
				echo service memory utilization is over threshold and will be restarted after three checks 
				sleep 30 
			fi 
	else
		echo $ is working within threshold 
		flag="False"
	fi 
	done 
	
}

### MAIN Script Starts Here 
cat ${scripts_path}/config/services.cfg | while read service_line 
do 
	check_service $service_line
done 
