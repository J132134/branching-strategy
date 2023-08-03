#!/bin/bash

git fetch -n origin '+refs/heads/releases/*:refs/remotes/origin/releases/*'

for branch in $(git for-each-ref --format='%(refname:short)' 'refs/heads/releases/*'); do
  base_commit=$(git merge-base main $branch)
  base_commit_time=$(git log -1 --format="%at" $base_commit)
  current_commit_time=$(git log -1 --format="%at" $1)

  if [ $base_commit_time -ge $current_commit_time ]; then
    exit 1;
  fi
done
