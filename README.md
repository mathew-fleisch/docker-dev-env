# Docker Development Environment

A container definition that will act as a local development environment


### Usage

```
# Build container
git clone git@github.com:mathew-fleisch/docker-dev-env.git
cd docker-dev-env
docker build -t linux-dev-env .

 
# Run container
docker run -it --rm \
    -v /Users/$(whoami)/.vimrc:/root/.vimrc \
    -v /Users/$(whoami)/.kube:/root/.kube \
    -v /Users/$(whoami)/.ssh:/root/.ssh \
    -v /Users/$(whoami)/.aliases:/root/.bash_aliases \
    -v /Users/$(whoami)/src:/root/src \
    --name linux-dev-env \
    linux-dev-env:latest

# zshrc/bashrc aliases
function linux() {
  container_name=linux-dev-env
  container_id=$(docker ps -aqf "name=$container_name")
  if [[ -z "$container_id" ]]; then
    container_id=$(docker run -dit --rm \
      -v /Users/$(whoami)/.vimrc:/root/.vimrc \
      -v /Users/$(whoami)/.kube:/root/.kube \
      -v /Users/$(whoami)/.ssh:/root/.ssh \
      -v /Users/$(whoami)/.aliases:/root/.bash_aliases \
      -v /Users/$(whoami)/src:/root/src \
      --name $container_name \
      linux-dev-env:latest)
  fi
  docker exec -it $container_id bash
}
function linuxrm() {
  container_name=linux-dev-env
  container_id=$(docker ps -aqf "name=$container_name")
  if [[ -n "$container_id" ]]; then
    echo "Removing container: $(docker rm -f $container_id)"
  fi
}
```
