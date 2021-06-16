# Docker Development Environment

[![Release CI: multi-arch container build & push](https://github.com/mathew-fleisch/docker-dev-env/actions/workflows/tag-release.yaml/badge.svg)](actions/workflows/tag-release.yaml)
[![Update CI: asdf dependency versions](https://github.com/mathew-fleisch/docker-dev-env/actions/workflows/update-asdf-versions.yaml/badge.svg)](actions/workflows/update-asdf-versions.yaml)

A container definition that will act as a local development environment

<img src="https://i.imgur.com/AGLznZ4.gif" width="100%" />

### Usage

```bash
# Run from docker hub
docker run -it --rm \
    -v /Users/$(whoami)/.kube:/root/.kube \
    -v /Users/$(whoami)/.ssh:/root/.ssh \
    -v /Users/$(whoami)/.aliases:/root/.bash_aliases \
    -v /Users/$(whoami)/src:/root/src \
    --name docker-dev-env \
    mathewfleisch/docker-dev-env:latest

---------------------------------------------------------------------

# Build container
git clone git@github.com:mathew-fleisch/docker-dev-env.git
cd docker-dev-env
docker build -t docker-dev-env .

# Run (local) container
docker run -it --rm \
    -v /Users/$(whoami)/.kube:/root/.kube \
    -v /Users/$(whoami)/.ssh:/root/.ssh \
    -v /Users/$(whoami)/.aliases:/root/.bash_aliases \
    -v /Users/$(whoami)/src:/root/src \
    --name docker-dev-env \
    docker-dev-env:latest

---------------------------------------------------------------------

# zshrc/bashrc aliases
function linux() {
  container_name=docker-dev-env
  container_id=$(docker ps -aqf "name=$container_name")
  if [[ -z "$container_id" ]]; then
    container_id=$(docker run -dit \
      -v /Users/$(whoami)/.kube:/root/.kube \
      -v /Users/$(whoami)/.ssh:/root/.ssh \
      -v /Users/$(whoami)/.aliases:/root/.bash_aliases \
      -v /Users/$(whoami)/src:/root/src \
      --name $container_name \
      mathewfleisch/docker-dev-env:latest)
  fi
  docker exec -it $container_id bash
}
function linuxrm() {
  container_name=docker-dev-env
  container_id=$(docker ps -aqf "name=$container_name")
  if [[ -n "$container_id" ]]; then
    echo "Removing container: $(docker rm -f $container_id)"
  fi
}
```

### Installed Tools

Built on top of [ubuntu:20.04](https://hub.docker.com/layers/ubuntu/library/ubuntu/20.04/images/sha256-b30065ff935c7761707eab66d3edc367e5fc1f3cc82c2e4addd69cee3b9e7c1c?context=explore) the apt repository is updated and upgraded before installation of additional tools. See [Dockerfile](Dockerfile) and [.tool-versions](.tool-versions) to see the tools that are installed in this container.


#### Updates and Tests

The asdf tool makes it easy to install multiple versions of the same tool and switch between the versions with another asdf command. There are also some helper scripts added to update/pin the versions of tools asdf installs.

```bash

```

