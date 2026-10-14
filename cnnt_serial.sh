#!/usr/bin/env bash

set -eu

device="/dev/cu.usbserial-1230"
baud=115200

exec screen "$device" "$baud"
