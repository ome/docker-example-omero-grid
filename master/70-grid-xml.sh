#!/bin/bash

set -eu

omero=/opt/omero/server/OMERO.server/bin/omero
cd /opt/omero/server

# Args are the servers to run, default (no args) is to run all
./process_defaultxml.py OMERO.server/etc/templates/grid/default.xml.orig \
    "$@" > OMERO.server/etc/templates/grid/default.xml

MASTER_IP=$(hostname -i)
$omero config set omero.master.host "$MASTER_IP"
