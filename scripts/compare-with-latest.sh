#!/bin/bash

function parse {
  local VERSION=$1
  # remove v prefix
  VERSION="${VERSION#[vV]}"

  local BUILD=$(echo $VERSION | cut -d'.' -f1-3)
  local HOTFIX=$(echo $VERSION | cut -d'.' -f4)

  # return 0 if hotfix is null
  echo "$BUILD ${HOTFIX:-0}"
}

read -ra THIS <<< "$(parse $1)"
THIS_BUILD=${THIS[0]}

read -ra LATEST <<< "$(parse $2)"
LATEST_BUILD=${LATEST[0]}
LATEST_HOTFIX=${LATEST[1]}

if [[ $LATEST_BUILD == $THIS_BUILD ]]; then
  LATEST_HOTFIX=$((LATEST_HOTFIX + 1))
  echo $LATEST_BUILD.$LATEST_HOTFIX
  exit 0
fi

IFS='.' read -ra THIS_VERSION_PARTS <<< "$THIS_BUILD"
IFS='.' read -ra LATEST_VERSION_PARTS <<< "$LATEST_BUILD"

for (( i=0; i<3; i++ )); do
  if (( ${LATEST_VERSION_PARTS[i]} < ${THIS_VERSION_PARTS[i]} )); then
    break
  elif (( ${LATEST_VERSION_PARTS[i]} > ${THIS_VERSION_PARTS[i]} )); then
    exit 1
  fi
done

echo $THIS_BUILD
