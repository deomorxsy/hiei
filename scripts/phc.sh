#!/bin/sh

# this script is supposed to run
# the symlink to busybox's netcat

nc locahost 9090 << EOF
GET /metrics HTTP/1.1
Host: hiei

EOF
