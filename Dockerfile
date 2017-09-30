FROM  alpine:latest

ENV USERNAME=app
ENV USERPASS=app
ENV SSH_PORT=2022

RUN adduser -S -D -H -G root -u 1000 -h /home $USERNAME \
 && echo "$USERNAME:$USERPASS" | chpasswd

RUN apk --no-cache upgrade \
 && apk --no-cache add \
      cmake libuv-dev build-base \
      sudo bash wget curl nano \
      openssh rsync \
      python git nodejs nodejs-npm yarn

# Install dumb-init (avoid PID 1 issues). https://github.com/Yelp/dumb-init
RUN curl -Lo /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 \
 && chmod +x /usr/local/bin/dumb-init 

# Grant privileges
RUN chgrp -R 0     /var /etc /home \
 && chmod -R g+rwX /var /etc /home \
 && chmod 664 /etc/passwd /etc/group

# Prepare SSH service
RUN echo "Port $SSH_PORT" >> /etc/ssh/sshd_config \
 && mkdir -p /var/empty && chmod 700 /var/empty \
 && export SSH_PORT=$SSH_PORT 

# Install React Native CLI
RUN npm install -g react-native-cli

WORKDIR /volume
VOLUME  /volume

EXPOSE $SSH_PORT 3000 3001 8000 8080 8081

USER $USERNAME

ADD entrypoint.sh /
ENTRYPOINT  ["dumb-init","/entrypoint.sh"]
