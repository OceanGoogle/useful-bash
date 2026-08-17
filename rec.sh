#!/usr/bin/env bash

git add -u

if [ "$#" -ne 0 ]; then 
  git commit -m "$1"
else
  git commit -m "$(date) working record"
fi

git push 
