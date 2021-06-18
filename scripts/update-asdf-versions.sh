#!/bin/bash

if ! [[ -f ../.tool-versions ]]; then
  echo "Missing ../.tool-versions file"
  exit 1
fi
echo "Ensure host has plugins installed to grab latest versions"
while IFS= read -r line; do 
  dep=$(echo "$line" | sed 's/\ .*//g')
  asdf plugin add $dep
done < ../.tool-versions
touch ../pin
touch updated
while IFS= read -r line; do
  dep=$(echo "$line" | sed 's/\ .*//g')
  installed=$(echo "$line" | sed 's/.*\ //g')
  echo "----------------------"
  echo "Current Version: $dep $installed"
  latest=$(asdf latest $dep)
  echo " Latest Version: $dep $latest"
  if [[ -z "$latest" ]]; then
    echo "Could not get latest version for $dep. Pinning to $installed"
    echo "$dep $installed" >> updated
  fi
  if [[ -z "$(cat updated | grep "$dep ")" ]]; then
    if [[ -z "$(cat ../pin | grep "$dep ")" ]]; then
      if [[ "$installed" =~ "$latest" ]]; then
        echo "$dep already at latest $latest"
        echo "$dep $installed" >> updated
      else
        echo "Updating $dep from $installed to $latest"
        echo "$dep $latest" >> updated
      fi
    else
      pinned=$(cat ../pin | grep "$dep ")
      echo "Pinned versions:"
      echo "$pinned"
      echo "$pinned" >> updated
    fi
  fi
done < ../.tool-versions
cat updated | sort | uniq > ../.tool-versions
rm updated
echo "--------------------------"
echo "To apply run: asdf install"
echo "--------------------------"
