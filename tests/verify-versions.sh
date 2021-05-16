#!/bin/bash

if ! [[ -f ../.tool-versions ]]; then
  echo "Missing ../.tool-versions file"
  exit 1
fi

while IFS= read -r line; do
  dep=$(echo "$line" | sed 's/\ .*//g')
  expected=$(echo "$line" | sed 's/.*\ //g')
  actual=$(./versions/$dep.sh)
#   echo "$dep: $expected : $actual"
  if [[ -n "$actual" ]]; then
    if [[ "$actual" =~ $expected ]]; then
    # if [[ "$expected" =~ $actual ]]; then
      echo "$dep $expected verified"
    else
      echo "$dep $expected NOT FOUND"
      echo "$actual"
      echo "--------------------"
    fi
  else
    echo "$dep $expected COULD NOT VERIFY"
    echo "$actual"
    echo "--------------------"
  fi
done < ../.tool-versions
