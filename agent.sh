#!/bin/bash

JEKINS_BASE=$1
AGENT_SECRET=$2
JNLP_PATH=$3
AGENT_SOURCE=$4
# NODE_NAME=$5
JENKINS_HOME=/home/$USER/jenkins_home/my_agents

set -ex | mkdir -p $JENKINS_HOME
# set -ex | echo -e "Node name must be encoded\n"

if [ "$1" == '' ]
then
    echo 'JENKINS base URL does not exist';
    exit 127;
fi

if [ "$2" == '' ]
then
    echo 'No secret provided';
    exit 127;
fi

if [ "$3" == '' ]
then
    echo 'No JNLP Path';
    exit 127;
fi

if [ "$4" == '' ]
then
    echo 'No Password provided';
    exit 127;
fi

if [ "$5" == '' ]
then
    echo 'No Agent source provided, retrieving from Jenkins...';
    set -ex | wget $JEKINS_BASE/jnlpJars/agent.jar -O $JENKINS_HOME/$AGENT_SECRET/agent.jar
    AGENT_SOURCE=$JENKINS_HOME/$AGENT_SECRET/"agent.jar"
fi

# java -jar [path/to/agent] -jnlpUrl http://localhost:5353/computer/node%2D1/jenkins-agent.jnlp -secret [secret] -workDir [absolute workdir] -internalDir "node-n"

echo "agent source: "$AGENT_SOURCE
echo "jenkins base: "$JEKINS_BASE
echo "jnlp path: "$JNLP_PATH
echo "full jnlp path: "$JEKINS_BASE/$JNLP_PATH/jenkins-agent.jnlp

set -ex | mkdir -p $JENKINS_HOME/$AGENT_SECRET && cd $JENKINS_HOME/$AGENT_SECRET

echo java -jar $AGENT_SOURCE -jnlpUrl $JEKINS_BASE/$JNLP_PATH/jenkins-agent.jnlp -secret $AGENT_SECRET > $JENKINS_HOME/$AGENT_SECRET/agent.sh
set -ex | chmod +x $JENKINS_HOME/$AGENT_SECRET/agent.sh

echo "starting agent at => "$(pwd)...

AGENT_SERVICE="[Unit]\nDescription=Jenkins Host Agent\n
\n[Service]\nUser=$USER\nWorkingDirectory=$JENKINS_HOME/$AGENT_SECRET\nExecStart=/bin/bash $JENKINS_HOME/$AGENT_SECRET/agent.sh\nRestart=always\n
\n[Install]\nWantedBy=multi-user.target"

set -ex | echo -e $AGENT_SERVICE > jenkins-agent-$AGENT_SECRET.service
set -ex | echo $4 | sudo -S systemctl enable $JENKINS_HOME/$AGENT_SECRET/jenkins-agent-$AGENT_SECRET.service
# set -ex | sudo systemctl stop jenkins-agent-$AGENT_SECRET.service
set -ex | echo $4 | sudo -S systemctl start jenkins-agent-$AGENT_SECRET.service
exit 0
