FROM openmicroscopy/omero-server:5.6.3

USER root
RUN /opt/omero/server/venv3/bin/pip install --upgrade --upgrade-strategy only-if-needed https://github.com/manics/omero-py/archive/process_defaultxml.zip
USER omero-server
