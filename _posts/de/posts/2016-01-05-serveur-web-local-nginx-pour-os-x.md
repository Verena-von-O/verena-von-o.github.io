---
title: Serveur web local<br/> <em>Nginx</em> pour OS X
lang: fr
---

Cherchant une solution satisfaisante pour créer un serveur web local permettant de programmer sous OS X avec PHP et MySQL, j'ai été déçu de constater que les solutions «~clés en main~» étaient loin d'égaler les WAMP  qui peuvent exister sous Windows.

C'était oublier qu'OS X est un système Unix, et que contrairement à Windows, il est parfaitement possible d'y créer un serveur local sur mesure avec quelques paquets.

Nous allons voir ici comment installer *Nginx*, PHP-FPM et *MariaDB* (MySQL) sous OS X *El Capitan* grâce au gestionnaire de paquets *Homebrew*.

## *Homebrew*

*HomeBrew* est un gestionnaire de paquets pour OS X, qui permet d'installer facilement les différentes applications Unix.

Pour l'installer, il suffit d'exécuter la commande indiquée sur le [site officiel](http://brew.sh).

Si vous ne les avez pas déjà, OS X vous proposera d'installer préalablement les outils en ligne de commande *Xcode*.

Après installation, la commande suivante permet, le cas échéant, de donner les indications permettant de parfaire l'installation :

```bash
brew doctor
```

On met ensuite à jour tous les paquets avec :

```bash
brew update
brew upgrade
```

## *Nginx*

Bien qu'une version d'*Apache* soit nativement fournie avec OS X, nous nous proposons ici d'installer *Nginx*, particulièrement léger et facilement configurable. Son installation se fait avec :

```bash
brew install nginx
```

Puis, pour démarrer Homebrew automatiquement avec le démarrage de l'ordinateur, on utilise :

```bash
brew services start nginx
```

Nous souhaitons pouvoir stocker notre site internet dans le dossier de notre choix, et y accéder à l'URL `http://localhost/`.

Pour cela, on édite le fichier de configuration :

```bash
nano /usr/local/etc/nginx/nginx.conf
```

Pour commencer, on édite la ligne commençant par `#user` pour donner à *Nginx* la permission d'accéder à nos fichiers, pour la modifier en la ligne suivante, où `<user>` est votre nom d'utilisateur :

```nginx
user <user> staff;
```

Pour utiliser le port 80, on change la ligne commençant par `listen` en :

```nginx
listen 80;
```

Enfin, on indique le dossier où vous souhaitez stocker vos sites grâce à la variable `root` :

```nginx
root <chemin/vers/votre/site>;
```

On peut désormais lancer *Nginx* avec :

```bash
sudo nginx
```

## PHP

Pour utiliser PHP avec *Nginx*, nous allons utiliser PHP-FPM. Pour installer PHP 7.0, on lance les commandes suivantes pour obtenir les bonnes dépendances :

```bash
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
```

Puis on installe :

```bash
brew install php70
```

Une fois installé, on utilise les commandes suivantes pour ne lancer que PHP-FPM au démarrage :

```bash
mkdir -p ~/Library/LaunchAgents
cp /usr/local/opt/php70/homebrew.mxcl.php70.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php70.plist
```

Pour lancer manuellement PHP-FPM, on utilise la commande :

```bash
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
```

On peut s'assurer que le service tourne bien en regardant si la commande suivante produit bien un résultat :

```bash
lsof -Pni4 | grep LISTEN | grep php
```

Enfin, on édite à nouveau le fichier de configuration :

```bash
nano /usr/local/etc/nginx/nginx.conf
```

On modifie la ligne commençant par `index` par :

```nginx
index index.php;
```

Enfin, on ajoute dans la rubrique `server` les lignes suivantes pour faire fonctionner PHP pour tous les fichiers ayant l'extension `.php` :

```nginx
location ~ \.php {
    fastcgi_split_path_info ^(.+?\.php)(/.*)$;
    if (!-f $document_root$fastcgi_script_name) {
        return 404;
    }
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_param SCRIPT_FILENAME $request_filename;
    include fastcgi_params;
}
```

On redémarre *Nginx* pour activer les changements :

```bash
sudo nginx -s reload
```

## MySQL

Plutôt que d'installer la version de *MySQL* réalisée par Oracle, nous allons installer le *fork* libre MariaDB avec les commandes suivantes :

```bash
brew install mariadb
```

Les lignes suivantes permettent de démarrer le serveur au démarrage :

```bash
brew services start mariadb
```

Enfin, on finalise l'installation en choisissant un mot de passe `root` pour MySQL :

```bash
mysql_secure_installation
```

Et voici une installation MAMP idéale !
