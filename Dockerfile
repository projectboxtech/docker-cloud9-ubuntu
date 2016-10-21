# Cloud9 server
# Inspired by https://github.com/sapk/dockerfiles/blob/master/cloud9/Dockerfile

FROM ubuntu:xenial
MAINTAINER Jonathan Camenzuli <jrcamenzuli@gmail.com>

RUN buildDeps='make build-essential g++ gcc python2.7' && softDeps="tmux git curl" \
 && apt-get update && apt-get upgrade -y \
 && apt-get install -y $buildDeps $softDeps --no-install-recommends \
 && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
 && apt-get install -y nodejs npm \
 && ln -s /usr/bin/nodejs /usr/bin/node \
 && npm install -g forever && npm cache clean \
 && git clone https://github.com/c9/core.git /cloud9 && cd /cloud9 \
 && scripts/install-sdk.sh \
 && apt-get clean -y \
 && rm -rf /tmp/* /var/tmp/* \
 && npm cache clean
 
VOLUME /workspace
EXPOSE 8181 
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]

#CMD["--auth","username:password"]