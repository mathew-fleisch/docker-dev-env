#!/bin/bash

if ! [[ -f ../.tool-versions ]]; then
  echo "Missing ../.tool-versions file"
  exit 1
fi

while IFS= read -r line; do
  dep=$(echo "$line" | awk '{print $1}' | tr '[[:upper:]]' '[[:lower:]]' | sed -e 's/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')
  expected=$(echo "$line" | awk '{print $2}' | tr '[[:upper:]]' '[[:lower:]]' | sed -e 's/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')
  actual=$(./versions/$dep.sh | tr '[[:upper:]]' '[[:lower:]]' | sed -e 's/v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')
  # echo "--------------------------"
  # echo "$dep: $expected : $actual"
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
