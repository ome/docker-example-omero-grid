#!/bin/bash

set -eu

# Must be exported by the caller:
# OMERO_USER OMERO_PASS PREFIX

OMERO=/opt/omero/server/OMERO.server/bin/omero

# Wait up to 2 mins
docker-compose exec -T omeroserver $OMERO login -C -s localhost -u "$OMERO_USER" -q -w "$OMERO_PASS" --retry 120
echo "OMERO.server connection established"
