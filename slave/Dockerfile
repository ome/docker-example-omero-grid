# TODO: Switch to openmicroscopy/omero-server when it's merged
FROM test-omero-server
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

USER root
ADD slave.cfg /opt/omero/server/
# Don't configure database in a slave
RUN rm /startup/60-database.sh
# Replace existing 99-run.sh
ADD 99-run.sh /startup/

USER omero-server

# TODO: Not needed?
EXPOSE 4063 4064
