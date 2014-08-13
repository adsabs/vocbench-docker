Dockerfile for running vobench as per https://aims-fao.atlassian.net/wiki/display/VB/Installation

Usage:

1. `docker build -t adsabs/vocbench .`
1. `docker run -d --name vocbench -p 8080:8080 -v $PWD/data:/data/:rw -v $PWD/st-server:/st-server:rw adsabs/vocbench`

To start|stop: `sudo docker start|stop vocbench`
