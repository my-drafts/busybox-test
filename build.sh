#!/bin/sh

docker  build  \
  --compress  \
  --tag=bb  \
  .

docker images
