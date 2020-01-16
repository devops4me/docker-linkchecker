
FROM ubuntu:18.04
USER root

# --->
# ---> Update the packages within this machine and create a user
# ---> that can run linkchecker with minimal privileges.
# --->

RUN apt-get update && \
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


# -------------------------------------> RUN linkchecker https://www.devopswiki.co.uk/Home
# -------------------------------------> RUN linkchecker https://devopswiki.co.uk/Home
# -------------------------------------> RUN linkchecker https://www.devopswiki.co.uk/Home#how-to-build-a-terraform-jenkins2-docker-pipeline
# -------------------------------------> RUN linkchecker https://www.devopswiki.co.uk/wiki/openvpn/openvpn
# -------------------------------------> RUN linkchecker http://10.152.183.167/Home
# -------------------------------------> RUN linkchecker http://10.152.183.102/
# -------------------------------------> RUN linkchecker https://dzone.com/articles/kafka-producer-and-consumer-example

RUN linkchecker http://10.152.183.167/


# --------------> ENTRYPOINT ["/root/cert.authority/cert-authority-manager.sh"]
# --------------> ENTRYPOINT [ "linkchecker", "http://10.152.183.167" ]
ENTRYPOINT [ "linkchecker", "https://www.devopswiki.co.uk/", "--check-extern", "--config=/etc/linkchecker/linkcheckerrc" ]
