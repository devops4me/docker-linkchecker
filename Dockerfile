
FROM ubuntu:18.04

# --->
# ---> Install openssl for creating the on-premises Root CA and
# ---> also install the AWS Cli for accessing AWS's Cert Manager
# ---> API to create and use the subordinate cloud-centric CA.
# --->

USER root
RUN apt-get update && apt-get --assume-yes upgrade && apt-get --assume-yes install -qq -o=Dpkg::Use-Pty=0 \
    jq          \
    sudo

# --->
# ---> Create a sudoer(able) user to run the link checker
# --->

RUN adduser --home /var/opt/checker --shell /bin/bash --gecos 'Link Checking User' checker && \
    install -d -m 755 -o checker -g checker /var/opt/checker && \
    usermod -a -G sudo checker

# --->
# ---> Now switch to the lesser permissioned checker user as
# ---> it does not like to run with unnecessary privileges.
# --->

USER checker
WORKDIR /var/opt/checker


# ---------------------> RUN mkdir -p /root/linkcheck
# ---------------------> WORKDIR /root/linkcheck

COPY linkchecker_9.4.0-2_amd64.deb .
RUN sudo apt install --assume-yes /var/opt/checker/linkchecker_9.4.0-2_amd64.deb

RUN ls -lah /var/opt/checker
RUN ls -lah /etc/linkchecker

RUN linkchecker https://www.devopswiki.co.uk/Home


# ---------------------> COPY linkcheckerrc /etc/linkchecker/linkcheckerrc
# ---------------------> ~/.linkchecker/linkcheckerrc
# ---------------------> RUN linkchecker --config=/etc/linkchecker/linkcheckerrc https://www.devopswiki.co.uk/Home



# --------------> RUN pip3 install --upgrade awscli && pip3 --version && aws --version

# --->
# ---> Create 2 directories where the first contains the script
# ---> and other scaffolding artifacts and the second contains
# ---> the key and certificate artifacts.
# --->

# --------------> RUN mkdir -p /root/cert.authority /root/cert.directory
# --------------> RUN chmod 700 /root/cert.directory
# --------------> WORKDIR /root/cert.authority

# --->
# ---> Install the key artifacts from the docker context
# ---> into the staging folder /root/cert.authority
# --->

# --------------> COPY cert-authority-manager.sh .
# --------------> COPY openssl-directives.cnf .
# --------------> COPY subordinate-ca-template.json .

# --------------> RUN chmod u+x cert-authority-manager.sh
# --------------> RUN touch index.txt && echo 1000 > serial


# --->
# ---> docker run invokes the cert authority manager
# --->

# --------------> ENTRYPOINT ["/root/cert.authority/cert-authority-manager.sh"]
# --------------> ENTRYPOINT [ "linkchecker", "http://10.152.183.167" ]
ENTRYPOINT [ "linkchecker", "https://www.devopswiki.co.uk/", "--check-extern", "--config=/etc/linkchecker/linkcheckerrc" ]
