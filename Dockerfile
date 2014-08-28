# Please make sure you have the following:
# 1) a manta environment file /root/.ssh/mantaEnv/sh
#	The file should contain the environment varibles for manta e.g.
#       export MANTA_USER=jschutt;
#       export MANTA_KEY_ID=10:5b:f6:6d:bb:e0:ee:ed:b8:4b:d8:81:bb:0b:6e:e8 ;
#       export MANTA_URL=https://us-east.manta.joyent.com ;
#
# 2) Valid keys for the JPC should be stored in /root/.ssh
#
# 3) Map the following volumes 
#	/var/lib/docker (This is the standard directory for docker)
#	/mnt/manta (This is used as a temp space for the log files
#
# 4) To ensure all the log files for a given unix instance are stored under the same directory use the 
#    environment valible $DOCKER_HOST
#
# 5) Make sure ~~/store/dockerLogs is a valid Manta path
#
# An example of how to start the log4 manta container
# docker run --name=log4manta -v /var/lib/docker/:/var/lib/docker -d -v /mnt/manta:/mnt/manta -v /root/.ssh/:/.ssh/ -e DOCKER_HOST=`hostname` log4manta
#
# To reassamble a containers log file you cna use the following command
# mfind /jens/stor/dockerLogs/<Host ID> | grep <Container ID> | sort | xargs mget -- >> /tmp/alllogs.log

FROM ubuntu:14.04

# make sure apt is up to date
RUN apt-get update

# install nodejs and npm
RUN apt-get install -y nodejs npm 

RUN cp /usr/bin/nodejs  /usr/bin/node
RUN npm install -g manta

RUN mkdir /logManager
ADD lrotate.sh  /logManager/lrotate.sh
RUN chmod 700 /logManager/lrotate.sh
ADD logrotate.conf  /logManager/logrotate.conf
CMD cd /logManager; ./lrotate.sh
