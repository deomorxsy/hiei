#!/bin/sh

# this script is supposed to run
# the symlink to busybox's netcat

nc locahost 9000 << EOF
GET /metrics HTTP/1.1
Host: asari

EOF
