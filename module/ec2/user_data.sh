#!/bin/bash
# Run golang docker webapp
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo docker run --name=my-running-webapp -d -p 80:8080 ${dockerhub_repo}:${webapp_version}