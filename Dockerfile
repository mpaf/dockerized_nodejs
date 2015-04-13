FROM centos:centos6

# Enable EPEL for Node.js
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# Install Node.js and npm
RUN yum install -y npm

# Install MEAN.js required packages
npm install -g grunt
npm install -g bower

# Bundle app source
COPY . /src
# Install app dependencies
RUN cd /src; npm install

# Install and run mongodb 3.0
ADD ./files/mongodb-org-3.0.repo /etc/yum.repos.d/mongodb-org-3.0.repo
RUN yum install -y mongodb-org
RUN mkdir -p /data/db

# Install supervisor to run mongodb and nodejs simultaneously in
# the container
RUN yum install -y python-setuptools
RUN easy_install supervisor
RUN mkdir -p /var/log/supervisor
ADD ./files/supervisord.conf /etc/supervisord.conf

npm install mongoose
npm install angular-ui-router
npm install bootsrap

# Open port 8080
EXPOSE 8080
CMD supervisord -n
