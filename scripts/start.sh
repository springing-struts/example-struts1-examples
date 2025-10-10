#!/usr/bin/env bash

set -eu

SCRIPT_DIR=$(realpath "$(dirname $BASH_SOURCE)")
PROJECT_BASE_DIR=$(realpath "$SCRIPT_DIR/..")

APP_NAME=struts-examples
CONTAINER_NAME=springing-struts-$APP_NAME
DOCKER=$( (command -v podman &> /dev/null) && echo podman || echo docker )

main() {
  build && start
}

build() {
  mvn \
    clean \
    dependency:purge-local-repository \
      -DreResolve=false \
      -DactTransitively=false \
      -DmanualInclude='io.github.iwauo.springing-struts' \
    package -U \
    spring-boot:repackage \
  && java \
    -Djarmode=layertools \
    -jar target/$APP_NAME-*.war \
    extract --destination target/extracted
}

start() {
  $DOCKER build -t $CONTAINER_NAME . \
  && ($DOCKER stop -t 0 $CONTAINER_NAME || true) \
  && $DOCKER rm -f $CONTAINER_NAME \
  && $DOCKER run -d \
       -p 8080:8080 \
       -p 5005:5005 \
       --name $CONTAINER_NAME \
       --env DEBUG_PORT=${DEBUG_PORT} \
       $CONTAINER_NAME \
  && $DOCKER logs -f $CONTAINER_NAME
}

(cd "$PROJECT_BASE_DIR" \
  && eval "$(mise env)" \
  && main
)
