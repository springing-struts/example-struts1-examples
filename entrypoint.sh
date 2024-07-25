#!/usr/bin/env bash

main() {
  launch
}

launch() {
  java \
    ${DEBUG_PORT:+ -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:${DEBUG_PORT}} \
    "org.springframework.boot.loader.launch.WarLauncher"
}

main