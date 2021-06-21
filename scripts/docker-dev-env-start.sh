#!/bin/bash

function linuxrm() {
  container_name=docker-dev-env
  container_id=$(docker ps -aqf "name=$container_name")
  if [[ -n "$container_id" ]]; then
    echo "Removing container: $(docker rm -f $container_id)"
  fi
}
function linux() {
  container_name=docker-dev-env
  latest_version=$(curl -s -H "Authorization: token $GIT_TOKEN" "https://api.github.com/repos/mathew-fleisch/docker-dev-env/tags" \
    | grep name \
    | sed -e 's/.*\ \"v\(.*\)\",.*$/v\1/g' \
    | head -1)
  if [[ -z $(docker images | grep $container_name | awk '{print $2}' | grep $latest_version) ]]; then
    read -p "Download latest version $latest_version and remove current? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
      echo "Downloading latest version: $latest_version"
      linuxrm
      docker images | grep $container_name | awk '{print $3}' | xargs -I {} docker rmi -f {}
    then
        echo "Skipping latest version $latest_version for now..."
    fi
  fi

  container_id=$(docker ps -aqf "name=$container_name")
  if [[ -z "$container_id" ]]; then
    container_id=$(docker run -dit --rm \
      -v /Users/$USER/.kube:/root/.kube \
      -v /Users/$USER/.ssh:/root/.ssh \
      -v /Users/$USER/.aliases:/root/.bash_aliases \
      -v /Users/$USER/src:/root/src \
      --name $container_name \
      mathewfleisch/docker-dev-env:$latest_version)
  fi
  docker exec -it $container_id bash
}
