# Docker Development Environment

A container definition that will act as a local development environment

<img src="https://i.imgur.com/AGLznZ4.gif" width="100%" />

### Usage

```bash
# Run from docker hub
docker run -it --rm \
    -v /Users/$(whoami)/.vimrc:/root/.vimrc \
    -v /Users/$(whoami)/.kube:/root/.kube \
    -v /Users/$(whoami)/.ssh:/root/.ssh \
    -v /Users/$(whoami)/.aliases:/root/.bash_aliases \
    -v /Users/$(whoami)/src:/root/src \
    --name docker-dev-env \
    mathewfleisch/docker-dev-env:latest


# Build container
git clone git@github.com:mathew-fleisch/docker-dev-env.git
cd docker-dev-env
docker build -t docker-dev-env .

 
# Run container
docker run -it --rm \
    -v /Users/$(whoami)/.vimrc:/root/.vimrc \
    -v /Users/$(whoami)/.kube:/root/.kube \
    -v /Users/$(whoami)/.ssh:/root/.ssh \
    -v /Users/$(whoami)/.aliases:/root/.bash_aliases \
    -v /Users/$(whoami)/src:/root/src \
    --name docker-dev-env \
    docker-dev-env:latest

# zshrc/bashrc aliases
function linux() {
  container_name=docker-dev-env
  container_id=$(docker ps -aqf "name=$container_name")
  if [[ -z "$container_id" ]]; then
    container_id=$(docker run -dit --rm \
      -v /Users/$(whoami)/.vimrc:/root/.vimrc \
      -v /Users/$(whoami)/.kube:/root/.kube \
      -v /Users/$(whoami)/.ssh:/root/.ssh \
      -v /Users/$(whoami)/.aliases:/root/.bash_aliases \
      -v /Users/$(whoami)/src:/root/src \
      --name $container_name \
      docker-dev-env:latest)
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

Built on top of ubuntu:20.04 the apt repository is updated and upgraded before installation of additional tools.

**apt**

 - curl
 - wget
 - apt-utils
 - python3
 - python3-pip
 - make
 - build-essential
 - openssl
 - lsb-release
 - libssl-dev
 - apt-transport-https
 - ca-certificates
 - iputils-ping
 - git
 - vim
 - zip

**asdf**

 - awscli 2.1.32
 - golang 1.16.2
 - helm 3.5.3
 - helmfile 0.138.7
 - k9s 0.24.6
 - kubectl 1.20.5
 - kubectx 0.9.3
 - shellcheck 0.7.1
 - terraform 0.12.30
 - terragrunt 0.28.18
 - tflint 0.25.0
 - yq 4.0.0
