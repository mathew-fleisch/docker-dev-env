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
    container_id=$(docker run -dit \
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

Built on top of [ubuntu:20.04](https://hub.docker.com/layers/ubuntu/library/ubuntu/20.04/images/sha256-b30065ff935c7761707eab66d3edc367e5fc1f3cc82c2e4addd69cee3b9e7c1c?context=explore) the apt repository is updated and upgraded before installation of additional tools.

apt | asdf
---------|-----
curl | awscli 2.1.32
wget | golang 1.16.2
apt-utils | helm 3.5.3
python3 | helmfile 0.138.7
python3-pip | k9s 0.24.6
make | kubectl 1.20.5
build-essential | kubectx 0.9.3
openssl | shellcheck 0.7.1
lsb-release | terraform 0.12.30
libssl-dev | terragrunt 0.28.18
apt-transport-https | tflint 0.25.0
ca-certificates | yq 4.0.0
iputils-ping |
git |
vim |
zip |

