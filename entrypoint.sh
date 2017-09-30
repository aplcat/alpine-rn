#!/bin/sh

# Default User
USERNAME=${USERNAME:-app}
USERID=${USERID:-`id -u`}

# Adjust user id (Useful if host assign random uid) 
sed -i "s/$USERNAME:x:[^:]*/$USERNAME:x:$USERID/" /etc/passwd

# Run SSH service
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa && \
ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
/usr/sbin/sshd

# Default execution command
EXEC=${EXEC:-bash}

# Run execution command
${@:-$EXEC}
