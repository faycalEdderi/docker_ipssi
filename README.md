## Installation

```bash
docker build -t wordpress-ipssi-container .
docker run -d -p 8080:80 --name wordpress-container wordpress-ipssi-container
```

## Instructions

Vous devrez, dans un seul conteneur Docker, mettre en place un serveur web.  
Le conteneur devra tourner avec Debian Buster.

### Requirements

- Votre serveur devra être capable de faire tourner plusieurs services en même temps.  
  Les services à installer incluent WordPress, phpMyAdmin, et MySQL. Vous devrez vous assurer que votre base de données SQL fonctionne correctement avec WordPress et phpMyAdmin.

- Vous devez créer un utilisateur avec un nom d'utilisateur et un mot de passe, créer une base de données, et autoriser cet utilisateur à interagir avec la base de données.

- Vous devrez vous assurer que, selon l’URL tapée, votre serveur redirige vers le bon site (index.php / phpMyAdmin / WordPress / (bonus) Nginx).

- Vous devrez aussi vous assurer que votre serveur utilise un index automatique qui doit pouvoir être désactivé. (ENV)
