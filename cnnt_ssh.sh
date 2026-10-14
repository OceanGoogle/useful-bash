#!/usr/bin/env bash

set -eu

ip="ocean@Ubuntu-i5-2.local";  port=22

exec ssh  "$ip"  -p "$port"
