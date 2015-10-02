FROM fedora
MAINTAINER Daniel Riek <riek@redhat.com>

RUN yum -y update; yum clean all

RUN systemctl mask systemd-remount-fs.service dev-hugepages.mount sys-fs-fuse-connections.mount systemd-logind.service getty.target console-getty.service dnf-makecache.service
RUN cp /usr/lib/systemd/system/dbus.service /etc/systemd/system/; sed -i 's/OOMScoreAdjust=-900//' /etc/systemd/system/dbus.service

VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]

ENV container=docker

CMD ["/usr/sbin/init"]

RUN yum -y install httpd && yum clean all; \
systemctl enable httpd.service

EXPOSE 80

RUN echo "systemd httpd server" > /var/www/html/index.html

#
# Workaround for BZ 1046469
# When running more than one container with systemd and invoked with "--privileged", the agetty process will burn 100% of a cpu.
# Udev and getty can either be disabled in each running container, or simply be removed here.
#
RUN rm -f /lib/systemd/system/systemd*udev* ; \
    rm -f /lib/systemd/system/getty.target;

LABEL INSTALL="docker run --rm --privileged -v /:/host -e HOST=/host -e LOGDIR=${LOGDIR} -e CONFDIR=${CONFDIR} -e DATADIR=${DATADIR} -e IMAGE=IMAGE -e NAME=NAME IMAGE /bin/install.sh"
LABEL UNINSTALL="docker run --rm --privileged -v /:/host -e HOST=/host -e IMAGE=IMAGE -e NAME=NAME IMAGE /bin/uninstall.sh"
LABEL RUN="docker run -v /sys/fs/cgroup:/sys/fs/cgroup -v /var/log/${NAME}/httpd:/var/log/httpd:Z -v /var/lib/${NAME}:/var/lib/httpd:Z --init=systemd --name NAME IMAGE"
ADD root /
