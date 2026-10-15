#!/usr/bin/env bash

set -eu

 # 1520
# ip="169.254.9.41";  port=24

# 1520 -- hostname
ip="ast3-client485DEB057CFE.local";  port=24 # 1520

exec telnet "$ip" "$port"
