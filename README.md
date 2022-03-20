# Jenkins Setup

I have used Docker Compose to write the configuration. This setup uses Jenkins and Docker in Docker.

## Configure Host Agent

Set up Host Agent Node Configuration on Jenkins Console and keep the required parameters like `-secret`. You first need to have java installed in the host. The Github actions have that step to install JDK though. Freely look into the script to see what it is doing.

```bash
sudo apt install openjdk-11-jdk -y
```

A lot of the steps are in the shell script [agent](./agent.sh) the workflow. But, to use the script some arguments are required.

- JENKINS_BASE_URL: the base URL where JENKINS is served. Example `http://localhost:8080`
- JENKINS_AGENT_SECRET: the secret generated after you have configured the agent on the Jenkins Console
- JENKINS_JNLP_PATH: the path after Jenkins base URL just before the jnlp file (jenkins-agent.jnlp). Example `computer/node%2Dinitial`
- PASSWORD: Root user password for starting the service that keeps the host agent running.
- PATH_TO_AGENT (Optional): Path to where the agent is saved on disk. Example /path/to/agent.jar. If not provided, script attempts to get it by
```
wget $JEKINS_BASE_URL/jnlpJars/agent.jar
```

To execute script
```bash
# make it excutable
chmod +x ./agent.sh
./agent.sh $JENKINS_BASE_URL $JENKINS_AGENT_SECRET $JENKINS_JNLP_PATH $PASSWORD [$PATH_TO_AGENT]
```

## Configure Clouds

Go to Configure Clouds [Here](http://localhost:5353/configureClouds/) and follow instructions in this [guide](https://davelms.medium.com/run-jenkins-in-a-docker-container-part-1-docker-in-docker-7ca75262619d)

### Docker Host

Should be tcp://[docker in docker hostname in compose config]:[docker in docker port in compose config]

### Certificates

Specifically certificates can be found here

```bash
docker exec jenkins-docker cat /certs/client/key.pem
docker exec jenkins-docker cat /certs/client/cert.pem
docker exec jenkins-docker cat /certs/client/ca.pem
```
