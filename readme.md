# Déploiement de grr avec docker-compose

## 3 conteneurs : php-fpm, nginx, mysql

[sources de grr](https://github.com/JeromeDevome/GRR/tree/master)

[fedaya/grr-docker](https://github.com/fedaya/grr-docker/tree/main) :
exemple de déploiement basé sur docker-compose, a l'air clean

voir pour ne pas faire tourner en root, et adopter d'emblée les
[spécificités nécessaires pour
openshift](https://developers.redhat.com/blog/2020/10/26/adapting-docker-and-kubernetes-containers-to-run-on-red-hat-openshift-container-platform)


## Étude du docker-compose

db : mariadb
1 volume pour /var/lib/mysql
1 volume pour accéder au script sql d'initialisation de la base 

app : à partir d'un Dockerfile


### Parler de comment générer le Dockerfile
- on part d'un Dockerfile initial pour s'inspirer
- revue des composants 
  - image d'origine : à mettre à jour !
  - securité : systématiquement faire tourner en tant qu'utilisateur non root : `USER 1234`
  - openshift : un utilisateur aléatoire est créé pour faire tourner un conteneur. Pour gérer les accès, cet utilisateur est membre du groupe `gid=0`. Un moyen simple pour donner des accès est donc un `chgrp -R 0 /the_good_path`, et enuiste un 
  `chmod -R g=u /the_good_path` (on copie les droits de l'utilisateur).
  - gestion des accès en écriture : déterminer si l'utilisateur conteneur doit pouvoir accéder en écriture
  

### Cas étudié

Liste des changements et raison associée :

docker-compose.yml:

version: '3.2' -> obsolète, trouver la version à jour : plus besoin de spécifier la version
services.db.image -> mariadb:11.4
web.ports : le port interne est à mettre en variable.


web : nginx, sert les fichiers de /var/www/html
proxy vers app:9000 -> mettre le port en variable 
port d'écoute du serveur nginx
80 -> variable > 1024 car le conteneur ne va plus tourner en root

Attention : l'entrypoint du conteneur refait la configuration du port d'écoute



web/Dockerfile
USER non root

app/Dockerfile
app/docker-php-entrypoint

-> modification de /var/www/html/include/connect.inc.php


### À montrer en tp

docker compose pull
docker compose build
docker compose up
docker compose ps

=> beaucoup de commandes docker se généralisent ainsi

Par exemple :
docker exec -ti <container-name> bash

devient

docker compose exec -ti app bash # app : le nom dans docker-compose.yml, pas le vrai nom du conteneur



web/default.conf 

### Commandes

```bash
# retreive all docker images 
docker compose pull
```
