#!/bin/bash
VERSION="${1#[vV]}"

BUILD=$(echo $VERSION | cut -d'.' -f1-3)
HOTFIX=$(echo $VERSION | awk -F. '{print ($4=="") ? 1 : $4+1}')

echo $BUILD.$HOTFIX
