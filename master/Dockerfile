# TODO: Switch to openmicroscopy/omero-server when it's merged
FROM test-omero-server
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

USER root
ADD process_defaultxml.py /opt/omero/server/
ADD 70-grid-xml.sh /startup/

USER omero-server

# default.xml may be modified at runtime for a multinode configuration
RUN cp /opt/omero/server/OMERO.server/etc/templates/grid/default.xml /opt/omero/server/OMERO.server/etc/templates/grid/default.xml.orig

# TODO: Don't expose 4061 (internal links only)
EXPOSE 4061 4063 4064
