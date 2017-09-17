#!/bin/bash
# Author : Karim Vaes
# Github : kvaes
# Version : 0.1

# Variable Check
echo "# Checking Variables"
if [ -z "$1" ];
then
  echo "!!! no hosturl was supplied"
  exit 2
else
  echo "### Host Url detected"
fi

# Variable Setup
echo "# Setting Variables"
HOST_URL=$1
AGENT_VERSION="v1.2.5"
LOCAL_IP=`ifconfig eth0 | awk '/inet addr/{print substr($2,6)}'`
STATUS=255
SLEEP=5
echo "### Server   = $HOST_URL"
echo "### Version  = $AGENT_VERSION"
echo "### Agent IP = $LOCAL_IP"

# Rancher Agent Installation
echo "# Debug"
ps -ef
echo "# Installing Rancher Agent"
while [ $STATUS -gt 0 ]
do
  sleep $SLEEP
  OUTPUT=`sudo docker run -e "CATTLE_AGENT_IP=$LOCAL_IP" -d --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:$AGENT_VERSION $HOST_URL 2>&1`
  STATUS=$?
  echo $OUTPUT
done

exit $STATUS
