#!/bin/sh
set -e
service ssh start
node /code/server.js
