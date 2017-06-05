OMERO.grid Docker
=================

This is an example of using OMERO on multiple nodes (such as running the Processor service on a separate node from the main OMERO.server), based on
http://www.openmicroscopy.org/site/support/omero/sysadmins/grid.html#nodes-on-multiple-hosts


Running the images
------------------

To run the Docker images start a postgres DB:

    docker run -d --name postgres -e POSTGRES_PASSWORD=postgres postgres

Then either run a single all-in-one master:

    docker run -d --name omero-server --link postgres:db
        -e CONFIG_omero_db_user=postgres \
        -e CONFIG_omero_db_pass=postgres \
        -e CONFIG_omero_db_name=postgres \
        -e ROOTPASS=omero-root-password \
        -p 4063:4063 -p 4064:4064 \
        -e ROOTPASS=omero openmicroscopy/omero-server
        -p 4063:4063 -p 4064:4064 \
        openmicroscopy/omero-grid-master master

Or run a master and one or more slaves
- the configuration must be provided to the master node
- slave modes must be passed a parameter matching the a slave defined in the master configuration

For example, to run two Processors on separate slaves and all other servers on master:

    docker run -d --name omero-server --link postgres:db
        ...
        openmicroscopy/omero-grid-master
        master:Blitz-0,Indexer-0,DropBox,MonitorServer,FileServer,Storm,PixelData-0,Tables-0
        slave-1:Processor-0 slave-2:Processor-1
    docker run -d --name omero-slave-1 --link omero-server:master
        openmicroscopy/omero-grid-slave slave-1
    docker run -d --name omero-slave-2 --link omero-server:master
        openmicroscopy/omero-grid-slave slave-2


See the parent [openmicroscopy/omero-server README.md](https://github.com/openmicroscopy/omero-server-docker/blob/master/README.md) for additional information.
