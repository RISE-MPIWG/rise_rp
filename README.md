# RISE Resource Provider Application

This application allows you to maintain collections, resources, sections and 
content units and make them available through a SHINE-compatible api. It relies on docker for development as well as for deployment.

## Installation

First, you will need to install docker. Please visit https://docs.docker.com/install/ and install the appropriate docker CE package for your operating system.

Then, you will need to run the application stack by running
```bash
docker-compose up --build
```
in the folder in which you have cloned this repository.

You will then have to create and migrate the database. To do this, please run

```bash
docker exec -it rise_rp_web_1 bash
```
This will take you into the container in which the application is running. Then, please run

```bash
bundle exec rake db:create
bundle exec rake db:migrate
```
You should then see a few messages indicating that the database has been created, and that the structure has been migrated. The Application is now ready to be used!

you can deploy the stack to a docker swarm host by doing the following:

```bash
export DOCKER_HOST=<your.docker.host>:2375
docker stack deploy -c docker-compose.production.yml rise_rp --with-registry-auth
```
although you might need to have access to fresh builds of the images required by the stack: please modify docker-compose.production.yml to your convenience.

## Usage

The RISE Resource Provider Reference Implementation allows its users to securely host and serve textual data and connect it to the RISE & SHINE Infrastructure. For more information about this piece of software, please contact the RISE & SHINE Team at swang@mpiwg-berlin.mpg.de.
