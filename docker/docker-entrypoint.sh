#!/bin/bash
set -e

cp -a /var/www/public /data/

exec su-exec web /var/www/docker/init.sh "$@"
