#### this script is used to get servers from alibaba LB in or our 
#### it takes tow args .. first is server name and the second is action (in or out)
#### Author: Mohamed Amr (m.amr.cse@gmail.com)
#!/bin/bash

####### Variables Section #####
Node=$1 ### server which you will get it in or out of LB 
Action=$2 ## in or out 
LB= ## Load Balancer Name 
################################
#set -x
function usage(){
        echo please enter valid input
        echo 'input is Node (Node_A , Node_B ) and action is (in , out )'
}
#echo $1 $2

### this function is used to get the server alias from arg and map it to the actual cloud server id  
function verify_input(){
if [ "$Node" == "Node_A" ] ; then
        server_name=\'enter your server name here \'
        echo Node is Node_A
elif [ "$Node" == "Node_B" ] ; then
        server_name=\'enter your server name here\'
        echo Node is Node_B
else
        usage
        exit
fi
}

### this function's action is to get node in or out of LB  
function action(){
if [ "$Action" == "in" ]
then
        echo getting Node $Node in LB
	aliyuncli slb AddBackendServers --LoadBalancerId $LB --BackendServers "[{'ServerId':$server_name}]"

elif [ "$Action" == "out" ]
then
        echo getting Node $Node out of LB
	aliyuncli slb RemoveBackendServers --LoadBalancerId $LB --BackendServers "["$server_name"]"
else
        usage
        exit
fi
}

###### Main Script Starts Here
verify_input
action
