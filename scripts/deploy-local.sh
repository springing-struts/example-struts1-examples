#!/usr/bin/env bash

SCRIPT_DIR=$(realpath $(dirname ${BASH_SOURCE[0]}))
PROJECT_BASE_DIR=$(realpath $SCRIPT_DIR/..)

APP_NAME=struts-examples
CONTAINER_NAME=springing-struts-$APP_NAME
DOCKER=$((which podman &> /dev/null) && echo podman || echo docker)

main() {
  build \
  && deploy_local
}

build() {
  (cd $PROJECT_BASE_DIR
    mvn \
      clean \
      dependency:purge-local-repository \
        -DreResolve=false \
        -DactTransitively=false \
        -DmanualInclude='springing-struts' \
      package -U \
      spring-boot:repackage \
    && java \
      -Djarmode=layertools \
      -jar target/$APP_NAME-*.war \
      extract --destination target/extracted
  )
}

deploy_local() {
  (cd $PROJECT_BASE_DIR
    $DOCKER build -t $CONTAINER_NAME . \
    && ($DOCKER stop -t 0 $CONTAINER_NAME || true) \
    && $DOCKER rm -f $CONTAINER_NAME \
    && $DOCKER run -d \
         -p 8080:8080 \
         -p 5005:5005 \
         --name $CONTAINER_NAME \
         --env DEBUG_PORT=5005 \
         $CONTAINER_NAME \
    && $DOCKER logs -f $CONTAINER_NAME
  )
}

main
