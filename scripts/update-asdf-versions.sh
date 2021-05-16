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
  if [[ "$installed" =~ "$latest" ]]; then
    echo "$dep already at latest $latest"
    echo "$dep $installed" >> updated
  else
    if [[ -z "$(cat ../pin | grep $dep)" ]]; then
      echo "Updating $dep from $installed to $latest"
      echo "$dep $latest" >> updated
    else
      echo "$dep pinned to $latest"
      echo "$dep $installed" >> updated
    fi
  fi
done < ../.tool-versions
mv updated ../.tool-versions
echo "--------------------------"
echo "To apply run: asdf install"
echo "--------------------------"
