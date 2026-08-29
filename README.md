# Home Assistant App/Add-on: Wallabag

Wallabag app (older 'add-on') for Home Assistant (HA) - a web application allowing you to save web pages for later reading. Similar to Instapaper, ReadLater self-hosted functionality. Click, save and read it when you want.

- Further information can be found at https://wallabag.org
- Install details: https://github.com/banditto9/addon-wallabag/blob/main/wallabag/DOCS.md

##
**(!)For clean installations - onetime DB manual steps required (not yet solved):**

1) MariaDB requires manual user creation (with some password) - easy to do via 'phpmyadmin'
2) Then create wallabag' db in phpmyadmin
3) Add priviliges for the created user to the 'wallabag' DB
4) Connect to the created wallabag db with the created user as a remote connection

SSL certs (if exposed to the Internet) easier to handle via NGINX Proxy Manager (NPM).
I have exposed the app and my settings are as follows, SSL cert is managed by NPM (&port forward on router) so SSL is false here.
Deletion of app/add-on doesn't touch the DB data. You can reinstall the app/add-on and use the existing wallabag db later if required.
```
ssl: false
certfile: fullchain.pem
keyfile: privkey.pem
twofactor_auth: false
anyone_can_register: false
locale: en
fosuser_confirmation: true
app_url: https://wallabag.example.com
remote_mysql_host: core-mariadb
remote_mysql_database: wallabag
remote_mysql_username: wallabag
remote_mysql_password: changemenow
remote_mysql_port: 3306
```

## Authors

- The original setup of this HA app/add-on was done by Paulo Costa https://github.com/coostax/addon-wallabag
- Wallabag repo: https://github.com/wallabag/wallabag

## Environment versions:
- Wallabag: 2.6.14 (current as per August 2026)
- Base image 9.4.0 (Debian 13 trixie)
- PHP 8.3
- Node.js 2x
