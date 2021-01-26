#!/bin/bash

set -e
set -u
set -x

# Must be exported by the caller:
# OMERO_USER OMERO_PASS PREFIX

DSNAME=$(date +%Y%m%d-%H%M%S-%N)
FILENAME=$(date +%Y%m%d-%H%M%S-%N).fake
SCRIPT=/omero/util_scripts/Dataset_To_Plate.py
EXEC="docker-compose exec -T omeroserver"
OMERO=/opt/omero/server/OMERO.server/bin/omero

dataset_id=$($EXEC $OMERO obj -q -s localhost -u $OMERO_USER -w $OMERO_PASS new Dataset name=$DSNAME | cut -d: -f2)
# Strip whitespace
dataset_id=${dataset_id//[[:space:]]/}

docker-compose exec -T -w /tmp omeroserver sh -c \
    "touch $FILENAME && $OMERO import -d $dataset_id $FILENAME"

$EXEC $OMERO script launch $SCRIPT \
    IDs=$dataset_id
echo "Completed with code $?"

result=$($EXEC $OMERO hql -q -s localhost -u $OMERO_USER -w $OMERO_PASS "SELECT COUNT(w) FROM WellSample w WHERE w.well.plate.name='$DSNAME' AND w.image.name='$FILENAME'" --style plain)
# Strip whitespace
result=${result//[[:space:]]/}
if [ "$result" != "0,1" ]; then
    echo "Script failed: $result"
    exit 2
fi
