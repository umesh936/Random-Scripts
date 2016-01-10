#!/bin/sh
if [ "$#" -ne 1 ]  
then
 echo "Please provide Local port address to redirect"
 exit 1
fi
#adding deafult port on server is 9001
echo " .. you can check on server in 60 seconds"
ssh -nNT -R 9001:localhost:$1 ubuntu2@52.xxx.xxx.106  |  echo "its up"
