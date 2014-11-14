What is Piwik?
============

[Piwik](http://piwik.org/) is a popular open source web analytics platform.

This Docker container strives to be a production-ready flexible solution to use Piwik connected to your choice of MySQL database. It features [nginx](http://nginx.org/) and  [PHP-FPM](http://php-fpm.org/), and is built on top of the [baseimage-docker](http://phusion.github.io/baseimage-docker/) container from Phusion.


Getting Started
----------------

Piwik connects to a MySQL database.  You have your choice of running that in a separate container alongside the Piwik container on the same Docker host, running it on an entirely separate server, or even using a hosted MySQL solution (such as Amazon RDS). All of this information is passed along to the Piwik container in environment variables at container creation time, and the environment variables are listed below.

    DB_HOST
Set ```DB_HOST``` to the IP address or domain name of the MySQL database you would like to connect to.  Alternatively, link the Piwik to a MySQL container with the name ```db_1```.

    DB_PORT
Optionally, set ```DB_PORT``` to the port on which your MySQL database is listening.  Alternatively, link the Piwik container to a MySQL container with the name ```db_1```.

    DB_USER
Set ```DB_USER``` to the MySQL user that Piwik will use.  This does not need to be a superuser, but it does need to have all permissions on the database specified by ```DB_NAME```.

    DB_PASSWORD
Set ```DB_PASSWORD``` to the MySQL password that corresponds with ```DB_USER```.

    DB_NAME
Set this to the MySQL database name that Piwik will use.  This database should already exist, and ```DB_USER``` should have all permissions for it.

    DB_TABLES_PREFIX
Optionally, set ```DB_TABLES_PREFIX``` to whatever you would like Piwik to prefix its table names with.  Default is ```piwik_```.

    DB_CHARSET
Optionally, set the character set that should be used for the MySQL tables.  Default is ```utf8```.

    PIWIK_SEED_DATABASE
Optionally, set ```PIWIK_SEED_DATABASE``` to ```true``` if this is a fresh install to a new database.  The database schema and a sample site will be loaded into the database.

    PIWIK_USER
Set ```PIWIK_USER``` to the administrator username you want to use for Piwik.

    PIWIK_PASSWORD

Set ```PIWIK_PASSWORD``` to the admininistrator account password you want to use.


Licenses
----------------

Piwik is an internationally registered trademark, and copyright and license information is available here: https://github.com/piwik/piwik/blob/master/LEGALNOTICE


This container also includes GeoLite data created by MaxMind, available from [http://www.maxmind.com](http://www.maxmind.com).
