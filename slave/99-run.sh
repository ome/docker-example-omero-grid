#!/bin/bash

set -eu

TARGET="${1}"
if [ -z "$TARGET" ]; then
    echo "ERROR: Slave-name required"
    exit 2
fi

omero=/opt/omero/server/OMERO.server/bin/omero
cd /opt/omero/server

CONFIG_omero_master_host=${CONFIG_omero_master_host:-}
if [ -n "$CONFIG_omero_master_host" ]; then
    MASTER_ADDR="$CONFIG_omero_master_host"
else
    MASTER_ADDR=master
    $omero config set omero.master.host "$MASTER_ADDR"
fi

SLAVE_ADDR=$(hostname -i)

# Is this needed on a slave?
#if stat -t /config/* > /dev/null 2>&1; then
#    for f in /config/*; do
#        echo "Loading $f"
#        $omero load "$f"
#    done
#fi

echo "Master addr: $MASTER_ADDR Slave addr: $SLAVE_ADDR"
sed -e "s/@omero.slave.host@/$SLAVE_ADDR/" -e "s/@slave.name@/$TARGET/" \
    slave.cfg > OMERO.server/etc/$TARGET.cfg
grep '^Ice.Default.Router=' OMERO.server/etc/ice.config || \
    echo Ice.Default.Router= >> OMERO.server/etc/ice.config
sed -i -r "s|^(Ice.Default.Router=).*|\1OMERO.Glacier2/router:tcp -p 4063 -h $MASTER_ADDR|" \
    OMERO.server/etc/ice.config

echo "Starting node $TARGET"
exec $omero node $TARGET start --foreground
