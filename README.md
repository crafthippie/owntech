# ownTech

[![Docker Workflow](https://github.com/crafthippie/owntech/actions/workflows/docker.yml/badge.svg)](https://github.com/crafthippie/owntech/actions/workflows/docker.yml) [![GitHub Repo](https://img.shields.io/badge/github-repo-yellowgreen)](https://github.com/crafthippie/owntech)

This repository provides the whole configuration for the `ownTech` Minecraft
mod pack. It's used to automatically build and publish the required files for
[Modrinth][modrinth] and the [Curseforge Client][curse], and to publish a Docker
image for the server on [DockerHub][dockerhub]. Some information and
documentation about this pack can be found on https://crafthippie.github.io/owntech.

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

-   [webhippie/minecraft-vanilla](https://github.com/dockhippie/minecraft-vanilla#available-environment-variables)
-   [webhippie/temurin](https://github.com/dockhippie/adoptopenjdk#available-environment-variables)
-   [webhippie/ubuntu](https://github.com/dockhippie/ubuntu#available-environment-variables)

## Development

We use [mise][mise] to manage all required tools and their versions. Install it
by following the [official installation instructions][mise-install], then run
the following commands inside the repository to activate mise and install all
tools defined in `mise.toml`:

```console
mise trust
mise install
```

## Contributing

Generally we are following [conventional commits][commits] when we apply
changes. That way we are able to generate proper changelogs for every release.
Please use always pull requests to integrate new functionalities or to fix
issues.

For the release process we are following [semantic versioning][semver] which
clearly indicates if a new version just resolves bugs, includes new features or
even includes breaking changes.

After installing the tools via `mise install` as described above set up the
pre-commit hooks so they run automatically on every commit:

```console
pre-commit install --hook-type pre-commit --hook-type commit-msg
```

> `pre-commit` is managed by mise and will be available after `mise install`.

If you have changed something on the source you should simply commit following
the mentioned conventions:

```console
git checkout -b feat/new-feature
git add --all
git commit -m 'feat: added awesome new feature'
git push --set-upstream origin feat/new-feature
```

After pushing your changes into the Git repository you should create a pull
request on GitHub. If the pull request have been merged and everything built
fine it will also create automatically a new release at least once a week.

## Authors

-   [Thomas Boerger](https://github.com/tboerger)

## License

MIT

## Copyright

```console
Copyright (c) 2020 Thomas Boerger <http://www.webhippie.de>
```

[modrinth]: https://modrinth.com/
[curse]: https://download.curseforge.com/
[dockerhub]: https://hub.docker.com/r/crafthippie/owntech
[mise]: https://mise.jdx.dev/
[mise-install]: https://mise.jdx.dev/getting-started.html
[commits]: https://www.conventionalcommits.org/en/v1.0.0/
[semver]: https://semver.org/
