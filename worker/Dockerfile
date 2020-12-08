FROM openmicroscopy/omero-server:5.6.3

COPY ice.config worker.cfg /opt/omero/server/OMERO.server/etc/templates/

USER root
# Replace the default startup scripts
RUN rm /startup/60-database.sh
COPY 99-run.sh /startup/99-run.sh
USER omero-server
