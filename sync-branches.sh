#!/bin/bash

git branch -D tmp-master
git checkout -b tmp-master
git commit -a -m "Comment not provided! Don't forget to commit next time."

git remote add upstream git@github.com:hazelcast-dockerfiles/hazelcast-enterprise-snapshot.git

git fetch upstream
for branchref in $(git branch -r --list 'upstream/*' | grep -v upstream/HEAD); do
  branch="${branchref##upstream/}"
  git checkout "$branch"
  git reset --hard tmp-master
  git push upstream $branch
done

git checkout master
git branch -D tmp-master
