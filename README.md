# jenkins-pipeline-ansible

## Objectives

1. Deploy a CI/CD pipeline of deployment of a server odoo.
1. Use jenkins, github, docker, ansible.

## Architecture

![ ](img/PR-20250321-jenkins-n-nzapa-V1.drawio.png)

## To deploy

1. execute command docker-compose

```md
sudo docker-compose up -d

 ```

## Version

1. 23/03/2025 18:00 : Creation of sign up Github.
1. 24/03/2025 12:00 : Maj README.md et remplacement de 'master' par 'main'.
1. 24/03/2025 18:00 : Maj du mdp.
1. 24/03/2025 14:00 : Maj fichier ansible.cfg. Remplacer:
1. 27/03/2025 21:00 : Maj fichier jenkinsfile.
1. 27/03/2025 22:00 : Maj de l'image server.

md``̀
chmod 666 /var/run/docker.sock : `https://stackoverflow.com/questions/72990497/getting-glibc-2-32-and-glibc-2-34-not-found-in-jenkins-docker-with-dind-on`
\[defaults\] inventory:$PWD/inventory.yml par inventory:$PWD/hosts.yml. /
et maj du fic hosts.yml pour configurer une connexion directe dckr au ctnr serveur_debian_test.
`̀``
