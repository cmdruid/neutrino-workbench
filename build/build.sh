#!/bin/sh
## Build script template. See accompanying Dockerfile for more build options.

set -E

###############################################################################
# Environment
###############################################################################

BUILDPATH="$(pwd)"

###############################################################################
# Methods
###############################################################################

remove_image() {
   ## If previous docker image exists, remove it.
  [ -n "$(docker image ls | grep $1-build)" ] && docker image rm "$1-build"
}

build() {
  ## Begin building image.
  DOCKER_BUILDKIT=1 docker build \
    --tag "$1-build" \
    --output type=local,dest=$BUILDPATH/out \
    --file "$BUILDPATH/dockerfiles/$1.dockerfile" \
  $BUILDPATH/dockerfiles
}

###############################################################################
# Script
###############################################################################

## Check if a binary already exists for each available build dockerfile.
[ ! -d "out" ] && mkdir out

for file in dockerfiles/*; do
  name="$(basename -s .dockerfile $file)"
  echo "Checking for existing $name binary ..."
  if [ -z "$(ls out | grep $name)" ]; then 
    printf "Binary for $name does not exist! Building it from source ...\n"
    remove_image $name
    build $name
  fi
done
