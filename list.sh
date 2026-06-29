#!/bin/bash


# -h --help: help
# -d --dir: list dirs only
# -f --files: list files only
# -h --hide: show hidden (def off)
# -c : change dir (follow dir name)


# main begins
hidden_f=yes
find_type=file
target_dir=$(pwd)
cmd=

# parse arguments
[ "$#" -ne 0  ] && { 
  for i in "$*" ; do
      case "$i" in
         -*) 
            while [[ "$i" = -* ]]; do i="${i#-}";  done
         ;;
      esac 
  done
} 




# process loop
