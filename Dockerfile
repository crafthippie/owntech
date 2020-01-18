FROM webhippie/java:8

LABEL maintainer="Thomas Boerger <thomas@webhippie.de>" \
  org.label-schema.name="Minecraft ownTech" \
  org.label-schema.vendor="Thomas Boerger" \
  org.label-schema.schema-version="1.0"

EXPOSE 25565 25575 8123
VOLUME ["/var/lib/minecraft", "/etc/override"]

WORKDIR /var/lib/minecraft
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

ENV MINECRAFT_VERSION 1.12.2
ENV FORGE_VERSION 14.23.5.2847

RUN groupadd -g 1000 minecraft && \
  useradd -u 1000 -d /var/lib/minecraft -g minecraft -s /bin/bash -M minecraft && \
  curl --create-dirs -sLo /usr/share/minecraft/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar http://files.minecraftforge.net/maven/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar && \
  cd /usr/share/minecraft && \
  java -jar forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar --installServer && \
  rm -f forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar.log

COPY ./overlay  /
