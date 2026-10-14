#!/usr/bin/env bash

set -eu

ip="ast3-client485deb057cfe.local";  port=24

exec telnet "$ip" "$port"
