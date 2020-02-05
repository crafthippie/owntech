# ownTech

[![Build Status](https://cloud.drone.io/api/badges/crafthippie/owntech/status.svg)](https://cloud.drone.io/crafthippie/owntech)
[![](https://images.microbadger.com/badges/image/crafthippie/owntech.svg)](https://microbadger.com/images/crafthippie/owntech "Get your own image badge on microbadger.com")

This repository provides the whole configuration for the `ownTech` Minecraft mod pack. It's used to automatically build and publish the required files for the Twitch desktop app through [Curseforge](https://www.curseforge.com/minecraft/modpacks/owntech), and to publish a Docker image for the server on [DockerHub](https://hub.docker.com/r/crafthippie/owntech). Some information and documentation about this pack can be found on https://crafthippie.github.io/owntech.

## Versions

To see the available Docker image versions it's best to look at https://hub.docker.com/r/crafthippie/owntech/tags while you can see the available files for the client at https://www.curseforge.com/minecraft/modpacks/owntech/files and https://dl.webhippie.de/minecraft/owntech.

## Volumes

* /var/lib/minecraft
* /etc/minecraft/override

## Ports

* 25565
* 25575
* 8123

## Available environment variables

```bash
MINECRAFT_BACKUPS_DIR = ${MINECRAFT_DATA_DIR}/backups
```

## Inherited environment variables

* [webhippie/minecraft-forge](https://github.com/dockhippie/minecraft-forge#available-environment-variables)
* [webhippie/minecraft-vanilla](https://github.com/dockhippie/minecraft-vanilla#available-environment-variables)
* [webhippie/java](https://github.com/dockhippie/java#available-environment-variables)
* [webhippie/alpine](https://github.com/dockhippie/alpine#available-environment-variables)

## Contributing

Fork -> Patch -> Push -> Pull Request

## Authors

* [Thomas Boerger](https://github.com/tboerger)

## License

MIT

## Copyright

```
Copyright (c) 2020 Thomas Boerger <http://www.webhippie.de>
```
