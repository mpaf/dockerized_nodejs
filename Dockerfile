FROM centos:centos6

# Enable EPEL for Node.js
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# Install Node.js and npm
RUN yum install -y tar
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | bash
RUN source ~/.nvm/nvm.sh && nvm install 0.12
RUN source ~/.nvm/nvm.sh && nvm use 0.12
RUN yum install -y npm

# Install MEAN.js required packages
npm install -g grunt
npm install -g bower
npm install -g express

# Bundle app source
COPY nodeapp/. /src
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

RUN npm install mongoose
RUN npm install angular-ui-router
RUN npm install bootstrap

# Open port 8080
EXPOSE 8080
CMD supervisord -n
