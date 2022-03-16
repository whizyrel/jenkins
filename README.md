# Jenkins Setup

I have used Docker Compose to write the configuration. This setup uses Jenkins and Docker in Docker.

## Agents

Set up Agent Configuration on Jenkins Console

### Configure Clouds

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

<!-- 
### Agent Program

Not certain though [here](http://localhost:5353/jnlpJars/agent.jar). Not sure a single build works for all agent instances.

```bash
docker cp path/to/agent.jar jenkins-container/name:/var/jenkins_home/nodes/agent-directory

docker exec -it jenkins-docker mkdir -p var/jenkins_home/nodes/agent-directory/remoting

docker exec -it jenkins-docker java -jar agent.jar -jnlpUrl http://localhost:8080/computer/agent%2Dnode%2D1/jenkins-agent.jnlp -secret 2a888a8e790afc93ea769dd6ce2cdc865ada42d8d12fa30fb137618206b0e2d6 -workDir "/var/jenkins_home/nodes/agent-directory" -failIfWorkDirIsMissing
```

### Agent Directory in Container

```bash
/var/jenkins_home/nodes/**/*
``` -->
