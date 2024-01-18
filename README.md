# ownTech

[![Docker Workflow](https://github.com/crafthippie/owntech/actions/workflows/docker.yml/badge.svg)](https://github.com/crafthippie/owntech/actions/workflows/docker.yml) [![GitHub Repo](https://img.shields.io/badge/github-repo-yellowgreen)](https://github.com/crafthippie/owntech)

This repository provides the whole configuration for the `ownTech` Minecraft
mod pack. It's used to automatically build and publish the required files for
the [Curseforge Client][curse], and to publish a Docker image for the server on
[DockerHub][dockerhub]. Some information and documentation about this pack can
be found on https://crafthippie.github.io/owntech.

## Versions

To see the available Docker image versions it's best to look at
https://hub.docker.com/r/crafthippie/owntech/tags while you can see the
available files for the client at https://dl.webhippie.de/#minecraft/owntech/.

## Volumes

-   /var/lib/minecraft
-   /etc/minecraft/override

## Ports

-   25565
-   25575
-   8123

## Available environment variables

```console
MINECRAFT_BACKUPS_DIR = ${MINECRAFT_DATA_DIR}/backups
```

## Inherited environment variables

-   [webhippie/minecraft-forge](https://github.com/dockhippie/minecraft-forge#available-environment-variables)
-   [webhippie/minecraft-vanilla](https://github.com/dockhippie/minecraft-vanilla#available-environment-variables)
-   [webhippie/adoptopenjdk](https://github.com/dockhippie/adoptopenjdk#available-environment-variables)
-   [webhippie/ubuntu](https://github.com/dockhippie/ubuntu#available-environment-variables)

## Contributing

Fork -> Patch -> Push -> Pull Request

## Authors

-   [Thomas Boerger](https://github.com/tboerger)

## License

MIT

## Copyright

```console
Copyright (c) 2020 Thomas Boerger <http://www.webhippie.de>
```

[curse]: https://download.curseforge.com/
[dockerhub]: https://hub.docker.com/r/crafthippie/owntech
