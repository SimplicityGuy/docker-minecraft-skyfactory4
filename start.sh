#!/bin/bash

set -e
FORGE_JAR="forge-1.12.2-14.23.5.2860.jar"

cd /data

if [[ ! -f /data/server.properties ]]; then
    touch /data/server.properties
fi

if [[ -n "${EULA}" ]] || [[ "${EULA}" == "TRUE" ]] || [[ "${EULA}" == "true" ]]; then
    echo "eula=true" > eula.txt
else
    echo "⚠️ Read the EULA first and if you agree, pass the environment variable EULA set to true! ⚠️"
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi

if [[ -n "$LEVEL_NAME" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL_NAME" /data/server.properties
fi

if [[ -n "$LEVEL_TYPE" ]]; then
    sed -i "/level-type\s*=/ c level-type=$LEVEL_TYPE" /data/server.properties
fi

if [[ -n "$GENERATOR_SETTINGS" ]]; then
    sed -i "/generator-settings\s*=/ c generator-settings=$GENERATOR_SETTINGS" /data/server.properties
fi

java "$JVM_OPTS" -jar /feed-the-beast/$FORGE_JAR nogui
