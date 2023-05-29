FROM amazoncorretto:8

LABEL org.opencontainers.image.title="SkyFactory 4 Minecraft Server" \
      org.opencontainers.image.description="Modern docker-based SkyFactory 4 Minecraft server." \
      org.opencontainers.image.authors="robert@simplicityguy.com" \
      org.opencontainers.image.source="https://github.com/SimplicityGuy/docker-minecraft-skyfactory4/blob/main/Dockerfile" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.created="$(date +'%Y-%m-%d')" \
      org.opencontainers.image.base.name="docker.io/library/amazoncorretto:8"

RUN yum update -q -y && \
    yum install -q -y shadow-utils unzip wget && \
    yum upgrade -q -y && \
    useradd -U minecraft && \
    mkdir /feed-the-beast && \
    mkdir /data && \
    chown -R minecraft:minecraft /feed-the-beast && \
    chown -R minecraft:minecraft /data

USER minecraft:minecraft

COPY start.sh /runtime/start.sh

#   Pull file redirected from https://www.curseforge.com/minecraft/modpacks/skyfactory-4/download/3012800/file
RUN wget -q -c https://edge.forgecdn.net/files/3565/687/SkyFactory-4_Server_4_2_4.zip -O /tmp/SkyFactory_4_Server.zip && \
    unzip -q /tmp/SkyFactory_4_Server.zip -d /feed-the-beast && \
    rm /tmp/SkyFactory_4_Server.zip

RUN cd /feed-the-beast && \
    bash -x Install.sh

VOLUME /data
WORKDIR /data

EXPOSE 25565

# Common settings set in the server.properties file.
ENV GENERATOR_SETTINGS=""
ENV LEVEL_NAME=""
ENV LEVEL_TYPE=DEFAULT
ENV MOTD="SkyFactory 4.2.4 Minecraft Server"

ENV JVM_OPTS="-Xms4048m -Xmx4048m"

ENV EULA=FALSE

CMD ["/runtime/start.sh"]
