#!/usr/bin/env bash

version1="1.2.3"
version2="1.2.4"

source version-compare.sh

result=$(compare_versions "$version1" "$version2")

case $result in
    1)  echo "$version1 is greater than $version2" ;;
    -1) echo "$version1 is less than $version2" ;;
    0)  echo "$version1 is equal to $version2" ;;
esac

