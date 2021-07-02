# Docker Development Environment

[![Release CI: multi-arch container build & push](https://github.com/mathew-fleisch/docker-dev-env/actions/workflows/tag-release.yaml/badge.svg)](https://github.com/mathew-fleisch/docker-dev-env/actions/workflows/tag-release.yaml)
[![Update CI: asdf dependency versions](https://github.com/mathew-fleisch/docker-dev-env/actions/workflows/update-asdf-versions.yaml/badge.svg)](https://github.com/mathew-fleisch/docker-dev-env/actions/workflows/update-asdf-versions.yaml)
[Docker Hub](https://hub.docker.com/r/mathewfleisch/docker-dev-env/tags?page=1&ordering=last_updated)

A container definition that will act as a local development environment

<img src="https://i.imgur.com/AGLznZ4.gif" width="100%" />

### Usage

***Quick start: Add start/stop helper scripts to /usr/local/bin***

```bash
wget https://raw.githubusercontent.com/mathew-fleisch/docker-dev-env/main/scripts/dockstart -P /usr/local/bin
wget https://raw.githubusercontent.com/mathew-fleisch/docker-dev-env/main/scripts/dockstop -P /usr/local/bin
chmod +x /usr/local/bin/dockstart
chmod +x /usr/local/bin/dockstop
dockstart
```

Or, you can run the container from docker hub


```bash
# Run from docker hub
docker run -it --rm \
    -v /Users/$USER/.kube:/root/.kube \
    -v /Users/$USER/.ssh:/root/.ssh \
    -v /Users/$USER/.aliases:/root/.bash_aliases \
    -v /Users/$USER/src:/root/src \
    --name docker-dev-env \
    mathewfleisch/docker-dev-env:latest

---------------------------------------------------------------------

# Build container
git clone git@github.com:mathew-fleisch/docker-dev-env.git
cd docker-dev-env
docker build -t docker-dev-env .

# Run (local) container
docker run -it --rm \
    -v /Users/$USER/.kube:/root/.kube \
    -v /Users/$USER/.ssh:/root/.ssh \
    -v /Users/$USER/.aliases:/root/.bash_aliases \
    -v /Users/$USER/src:/root/src \
    --name docker-dev-env \
    docker-dev-env:latest

```


### Installed Tools

Built on top of [ubuntu:20.04](https://hub.docker.com/layers/ubuntu/library/ubuntu/20.04/images/sha256-b30065ff935c7761707eab66d3edc367e5fc1f3cc82c2e4addd69cee3b9e7c1c?context=explore) the apt repository is updated and upgraded before installation of additional tools. See [Dockerfile](Dockerfile) and [.tool-versions](.tool-versions) to see the tools that are installed in this container.


### Automation

There are [two github-action jobs](https://github.com/mathew-fleisch/docker-dev-env/actions) set up to build, push and update the container and dependencies baked into the container. These jobs are configured to run on self-hosted runners and will use the plugin, dockerx, to build multi-arch containers.

***[Release on git tags (tag-release.yaml)](.github/workflows/tag-release.yaml)***

The main branch is used to `git tag` stable versions and trigger a build+push to docker hub.

```bash
git tag v1.0.0
git push origin v1.0.0
```

On new major/minor versions of of this tag, the apt dependencies will be upgraded, and on patches, asdf dependencies will be upgraded.

***[Automatic dependency updates (update-asdf-versions.yaml)](.github/workflows/update-asdf-versions.yaml)***

This github action is triggered via [cron](.github/workflows/update-asdf-versions.yaml#L10) will use asdf to update the versions in [.tool-versions](.tool-versions), ignoring those tools pinned in [pin](pin), and trigger a new `git tag` patch, if [.tool-versions](.tool-versions) changes (the tag triggers the [tag-release.yaml](.github/workflows/tag-release.yaml) action).

