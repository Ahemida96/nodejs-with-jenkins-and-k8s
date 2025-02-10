#!/bin/bash
sudo docker run -p 8080:8080 -p 50000:50000 -d \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v "$(which docker)":/usr/bin/docker jenkins/jenkins:lts

"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"