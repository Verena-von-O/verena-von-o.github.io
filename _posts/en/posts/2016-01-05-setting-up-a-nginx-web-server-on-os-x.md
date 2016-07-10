---
title: Setting up a <em>Nginx</em> <br/>web server on OS X
lang: en
---

Seeking a satisfactory solution to create a local web server for programming in OS X with PHP and MySQL, I was disappointed that the turnkey solutions were far from equaling the WAMP that may exist on Windows.

But I forgot OS X is a Unix system, and unlike Windows, it's perfectly possible to create a customized local server with some packages.

We will see how to install *Nginx*, PHP-FPM and *MariaDB* (MySQL) on OS X *El Capitan* thanks to *Homebrew* package manager.

## *Homebrew*

*HomeBrew* is a package manager for OS X, that allows to easily install various Unix applications.

To install, simply execute the command shown on the [official website](http://brew.sh).

If you do not already have them, OS X will prompt you to first install Xcode Command Line Tools.

After installation, the following command, if necessary, will tell you how to complete the installation:

```bash
brew doctor
```

Then updates all packages with:

```bash
brew update
brew upgrade
```

## *Nginx*

Although *Apache* is natively included with OS X, we propose here to install *Nginx*, particularly lightweight and easily configurable. Its installation is done with:

```bash
brew install nginx
```

The following will automatically launch *Nginx* at startup:

```bash
brew services start nginx
```

We want to store our web site in the folder of our choice, and access to the URL `http://localhost/`.

To do this, edit the configuration file:

```bash
nano /usr/local/etc/nginx/nginx.conf
```

To begin, we edit the line beginning with *Nginx* `#user` to give permission to access our files, to modify the following line, where `<user>` is your username:

```nginx
user <user> staff;
```

To use port 80, changing the line beginning with `listen` in :

```nginx
listen 80;
```

Finally, it indicates the folder where you want to store your sites through the variable `root` :

```nginx
root <chemin/vers/votre/site>;
```

We can now start *Nginx*:

```bash
sudo nginx
```

## PHP

To use PHP with *Nginx* we will use PHP-FPM. To install PHP 7.0, launch the following commands:

Setup the homebrew taps which has dependencies we need:

```bash
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
```

Then we install :

```bash
brew install php70
```

Once installed, use the following commands to run only PHP-FPM on startup:

```bash
mkdir -p ~/Library/LaunchAgents
cp /usr/local/opt/php70/homebrew.mxcl.php70.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php70.plist
```


One can ensure that the service runs well watching if the following command produces a result:

```bash
lsof -Pni4 | grep LISTEN | grep php
```

Finally, re-edit the configuration file:

```bash
nano /usr/local/etc/nginx/nginx.conf
```

We modify the line starting with `index` by:

```nginx
index index.php;
```

Finally, add in the section `server` the following lines to run PHP for all files with the extension` .php`:

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

Restart *Nginx* to activate the changes:

```bash
sudo nginx -s reload
```

## MySQL

Rather than installing the version of *MySQL* by Oracle achieved, we will install the free *MariaDB* fork with the following commands:

```bash
brew install mariadb
```

The following lines are used to start the server at startup:

```bash
brew services start mariadb
```

Finally, complete the installation by choosing a `root` password for MySQL:

```bash
mysql_secure_installation
```

Here is the perfect MAMP installation !
