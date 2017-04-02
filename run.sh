#!/bin/sh

docker  ps  -a
docker  run  \
  --detach  \
  --env-file=./docker/env.list  \
  --hostname=localhost  \
  --interactive=true  \
  --name=bb  \
  --publish=10080:80  \
  --publish=10443:443  \
  --restart=always  \
  --tty=true  \
  bb 

# more options:
#
#  --cpus="2"  \
#  --memory="256m"  \
#  --memory-swap="512m"  \
#  --storage-opt size=2G  \
#  --volume=/docker/busybox/data:/data  \
#  --volume=/docker/busybox/nginx.conf:/etc/nginx/nginx.conf  \
