#!/bin/sh
# Make Data Dirs
mkdir -p ${HOST}/${CONFDIR} ${HOST}/${LOGDIR}/httpd ${HOST}/${DATADIR}

# Copy Config
cp -pR /etc/httpd ${HOST}/${CONFDIR}

# Create Container
chroot ${HOST} /usr/bin/docker create -v /sys/fs/cgroup:/sys/fs/cgroup -v /var/log/${NAME}/httpd:/var/log/httpd:Z -v /var/lib/${NAME}:/var/lib/httpd:Z --init=systemd --name ${NAME} ${IMAGE}

# Install systemd unit file for running container
sed -e "s/TEMPLATE/${NAME}/g" etc/systemd/system/httpd_template.service > ${HOST}/etc/systemd/system/httpd_${NAME}.service

# Enabled systemd unit file
chroot ${HOST} /usr/bin/systemctl enable /etc/systemd/system/httpd_${NAME}.service
