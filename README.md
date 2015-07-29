Dockerfile for running vobench using https://aims-fao.atlassian.net/wiki/display/VB/Installation as a guideline.
Edit `tomcat-users.xml`, `Dockerfile`, and `config.properties` to contain the correct passwords (Yes, this software wants everything in plain text :| )

Usage:

1. `docker build -t adsabs/vocbench .`
1. `docker run -d --name vocbench -p 8080:8080 -v $PWD/vols/data:/data/:rw -v $PWD/vols/SemanticTurkeyData:/vocbench/st-server/SemanticTurkeyData:rw -v $PWD/vols/aduna/:/usr/share/tomcat7/.aduna/openrdf-sesame/repositories adsabs/vocbench`

To start|stop: `sudo docker start|stop vocbench`

Notes:
This is a fat container; all dependencies and databases run inside of it. This includes:

  - mysql
  - aduna/openrdf
  - Semantic Turkey
  - vocbench

This is great for small installations, but clearly offers no failover or scaleability. Caveat emptor.

Data should be persisted using host mounted volumes.
