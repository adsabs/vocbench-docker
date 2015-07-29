#!/bin/bash
ST_DATADIR="/vocbench/st-server/semanticturkey-0.11/bin"
pushd $ST_DATADIR
./karaf server
popd
