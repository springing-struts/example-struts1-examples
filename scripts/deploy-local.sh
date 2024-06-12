#!/usr/bin/env bash

SCRIPT_DIR=$(realpath $(dirname ${BASH_SOURCE[0]}))
PROJECT_BASE_DIR=$(realpath $SCRIPT_DIR/..)

APP_NAME=struts-examples
CONTAINER_NAME=springing-struts1-$APP_NAME
DOCKER=$((which podman &> /dev/null) && echo podman || echo docker)

main() {
  build \
  && deploy_local
}

build() {
  (cd $PROJECT_BASE_DIR
    mvn clean package -U
  )
}

deploy_local() {
  (cd $PROJECT_BASE_DIR
    $DOCKER build -t $CONTAINER_NAME . \
    && $DOCKER rm -f $CONTAINER_NAME \
    && $DOCKER run -d \
         -p 8080:8080 \
         -p 5005:5005 \
         --name $CONTAINER_NAME \
         --env DEBUG_PORT=5005 \
         $CONTAINER_NAME
  )
}

main
