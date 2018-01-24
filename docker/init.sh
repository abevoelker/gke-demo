#!/bin/bash
set -e

# set correct Ruby path
source /var/www/docker/ruby-path.sh

exec "$@"
