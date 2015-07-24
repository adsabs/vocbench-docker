Dockerfile for running vobench as per https://aims-fao.atlassian.net/wiki/display/VB/Installation

Usage:

1. `docker build -t adsabs/vocbench .`
1. `docker run -d --name vocbench -p 8080:8080 -v $PWD/vols/data:/data/:rw -v $PWD/vols/st-server:/vocbench/st-server/semanticturkey-0.11/SemanticTurkeyData/:rw -v $PWD/vols/aduna/:/usr/share/tomcat7/.aduna/openrdf-sesame/repositories adsabs/vocbench`

To start|stop: `sudo docker start|stop vocbench`
