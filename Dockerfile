# Image de base
FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV USER cpa

ENV pip_packages "ansible cryptography"

USER root
# Installation de sudo avec apt
RUN apt update && apt -y upgrade && apt -y \
    install\
    sudo

# Installation de docker avec apt-get
RUN apt-get install -y ca-certificates curl
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc;
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    python3 \
    flake8 \
    pylint \
    python3-pip \
    openssh-server

# Combine USER with WORKDIR

# RUN sudo adduser $USER
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers

RUN mkdir /app
RUN mkdir -p "/opt/jenkins-training/odoo17"

RUN useradd -ms /bin/bash -p ${USER} ${USER}
RUN mkdir /home/${USER}/.ssh
RUN chown -R ${USER}:${USER} /app
RUN chown -R ${USER}:${USER} /home/${USER}
RUN chmod -R 700 "/home/${USER}/.ssh"

USER ${USER}
USER 1001:1001

# Print the UID and GID
CMD sh -c "echo 'Inside Container:' && echo 'User: $(whoami) UID: $(id -u) GID: $(id -g)'"

# Setup running user on the container with sudo rights and
# password-less ssh login
# RUN sudo useradd -ms /bin/bash $USER
# Create a custom user with UID 1234 and GID 1234
#RUN groupadd -g 1234 ${USER} && \
#    useradd -m -u 1234 -g ${USER} ${USER}
# RUN useradd -ms /bin/bash ${USER}



# As the user setup the ssh identity using the key in the tmp folder
# Switch to the custom user
COPY --chown=${USER}:sudo id_rsa.pub /home/${USER}/.ssh/id_rsa.pub


USER root
RUN cat /home/${USER}/.ssh/id_rsa.pub >>/home/${USER}/.ssh/authorized_keys
RUN chmod 644 /home/${USER}/.ssh/id_rsa.pub
RUN chmod 644 /home/${USER}/.ssh/authorized_keys

#RUN sudo /etc/init.d/docker start


# Print the UID and GID
CMD sh -c "echo 'Inside Container:' && echo 'User: $(whoami) UID: $(id -u) GID: $(id -g)'"

# start ssh with port exposed
USER root
RUN service ssh start
# RUN service docker start
RUN sudo service docker start

EXPOSE 22
EXPOSE 80
EXPOSE 30016
EXPOSE 40016

#CMD [["/lib/systemd/systemd"]
#CMD ["/usr/sbin/sshd", "-D"]
#CMD ["sudo", "/etc/init.d/docker", "start"]


# Lancement du service docker
#RUN sudo systemctl start docker
#RUN sudo systemctl enable docker

# Ajout du fichier de dépendances package.json
#ADD package.json /app/

# Changement du repertoire courant
#WORKDIR /app
# Set the workdir
WORKDIR /home/${USER}

# Installation des dépendances
#RUN npm install

# Ajout des sources
ADD . /app/

WORKDIR /opt/jenkins-training/odoo17/

# On expose le port 3000
# EXPOSE 3000

# On partage un dossier de log
# VOLUME /app/log

# On lance le serveur quand on démarre le conteneur
# CMD node server.js

#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/lib/systemd/systemd"]
CMD ["tail", "-f", "/dev/null"]

