
FROM ubuntu:18.04
USER root

# --->
# ---> Update the packages within this machine and create a user
# ---> that can run linkchecker with minimal privileges.
# --->

RUN apt-get update && \
    apt-get --assume-yes install -qq -o=Dpkg::Use-Pty=0 wget && \
    adduser --home /var/opt/checker --shell /bin/bash --gecos 'Link Checking User' checker && \
    install -d -m 755 -o checker -g checker /var/opt/checker && \
    usermod -a -G sudo checker


# --->
# ---> Copy the linkchecker configuration file and the installable
# ---> package and then install it.
# --->

COPY linkcheckerrc /var/opt/checker/.linkchecker/linkcheckerrc
COPY linkchecker_9.4.0-2_amd64.deb /tmp
RUN apt install --assume-yes /tmp/linkchecker_9.4.0-2_amd64.deb


# --->
# ---> Now switch to the lesser permissioned checker user as
# ---> it does not like to run with unnecessary privileges.
# --->

USER checker
WORKDIR /var/opt/checker


# --->
# ---> Checking begins when docker run passes the source site url
# ---> in LINK_CHECKER_SITE_URL as an --env variable.
# --->

ENTRYPOINT linkchecker "$LINK_CHECKER_URL"
