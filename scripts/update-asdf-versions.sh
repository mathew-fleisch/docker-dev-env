#!/bin/bash

if ! [[ -f ../.tool-versions ]]; then
  echo "Missing ../.tool-versions file"
  exit 1
fi
touch ../pin
touch updated
while IFS= read -r line; do
  dep=$(echo "$line" | sed 's/\ .*//g')
  installed=$(echo "$line" | sed 's/.*\ //g')
  latest=$(asdf latest $dep)
  if [[ -z "$(cat updated | grep $dep)" ]]; then
    if [[ -z "$(cat ../pin | grep $dep)" ]]; then
      if [[ "$installed" =~ "$latest" ]]; then
        echo "$dep already at latest $latest"
        echo "$dep $installed" >> updated
      else
        echo "Updating $dep from $installed to $latest"
        echo "$dep $latest" >> updated
      fi
    else
      pinned=$(cat ../pin | grep $dep)
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
