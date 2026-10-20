#!/usr/bin/env bash

set -eu
cmp_ptn=""

if [[ $(uname -s) == Darwin ]]; then
   type='Mac'; cmp_ptn='cu.usb*' ;
else
   type='Linux' ; cmp_ptn='ttyUSB*' ;
fi

if [ $# -lt 1 ]; then tar_no=1; else tar_no="$1"; fi
baud=115200

tar_cnt=0; r_line= ; r_line= ;
while read -r r_line; do
  if [[ "$r_line" = $cmp_ptn ]];  then 
    ((++tar_cnt))
    [ "$tar_cnt" -ge $tar_no ] && { line="$r_line"; break; }
  fi
done < <(list -c /dev 'cu.usb*')

[[ -z "$line" ]] && { echo fail finding in /dev; exit 0; }

echo found line is "$line"
device=/dev/"$line"
screen "$device" "$baud"
