# Image de base
FROM debian:latest

# Installation de sudo avec apt
RUN apt update && apt -y upgrade && apt -y install sudo
RUN sudo apt update && sudo apt upgrade
RUN sudo apt-get update

# Installation de docker avec apt-get
RUN sudo apt-get install -y ca-certificates curl;
RUN sudo install -m 0755 -d /etc/apt/keyrings
RUN sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc;
RUN sudo chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update
RUN sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Lancement du service docker
#RUN sudo systemctl start docker
#RUN sudo systemctl enable docker

# Ajout du fichier de dépendances package.json
#ADD package.json /app/

# Changement du repertoire courant
WORKDIR /app

# Installation des dépendances
#RUN npm install

# Ajout des sources
ADD . /app/

# On expose le port 3000
EXPOSE 3000

# On partage un dossier de log
VOLUME /app/log

# On lance le serveur quand on démarre le conteneur
# CMD node server.js
