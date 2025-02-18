#!/bin/bash
#stop containers
docker stop $(docker ps -a -q)
#remove containers
docker rm $(docker ps -a -q)
#remove images
docker rmi -f $(docker images -a -q)
#clean cache
docker builder prune --all --force