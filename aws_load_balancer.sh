#!/bin/bash 

####### Variables Section #####
Node=$1
Action=$2
LB_Name=""   ### enter the load balancer name
Region="" ### enter the region name 
################################
#set -x 
function usage(){
	echo please enter valid input 
	echo 'input is Node (Node_A , Node_B ) and action is (in , out )'
}
#echo $1 $2 
function verify_input(){
if [ "$Node" == "Node_A" ] ; then 
	server_name='' ### put the aws server id for node 1 
	echo Node is Node_A 
elif [ "$Node" == "Node_B" ] ; then 
	server_name='' ### put the aws server id for node 2 
	echo Node is Node_B
else
	usage
	exit
fi
}

##### Action function
function action(){
if [ "$Action" == "in" ] 
then 
	echo getting Node $Node in LB 
	aws elb register-instances-with-load-balancer --load-balancer-name  $LB_Name --instances $server_name --region $Region	
elif [ "$Action" == "out" ] 
then 
	echo getting Node $Node out of LB 
	aws elb deregister-instances-from-load-balancer --load-balancer-name $LB_Name --instances $server_name --region $Region
else 
	usage 
	exit 
fi
}


###### Main Script Starts Here 
verify_input
action
