#!/bin/sh
set -eu

docker-compose up -d

export OMERO_USER=root OMERO_PASS=omero

./wait_for_login.sh

# Wait a short time for services to be ready
sleep 30

./test_processor.sh

./test_dropbox.sh
