# Vagrant LEMP stack

This is a simple PHP 7 development environment based on Ubuntu Xenial (16.04)

### This Vagrant VM config includes:

- nginx
- MySQL
- php-fpm 7.0
- MongoDB

### Environment description

Nginx serves your php scripts from your `./public` located in your project folder on port 8888 on your host machine.
MySQL port 3306 is also forwarded to your host machine.

The provisioning script creates a `WEBAPP` database for you.
It also creates two users for you: `'webappuser'@'localhost'` and `'webappuser'@'10.0.2.2'` - the first one has full access to `WEBAPP` database on your gues OS and the second one has full access to your DB from your host machine.
Both users share the same password: `P@ssw0rd`.

MongoDB was recently added as an alternative NoSQL database.

### Getting the environment up
```shell
$vagrant up
```

### Checking if everything works as it should
To check nginx and php simply run:
```shell
$ curl localhost:8888
```
 
To check the db connection:

``` 
$ mysql --host=127.0.0.1 --user=webappuser --password=P@ssw0rd WEBAPP
```

Feel free to tweak all the settings.

NOTE: This environment was created mainly in order to get the hang of Vagrant in general. If you have any tips, I would be really greatful to accept any reasonable pull request :)

TODO:

- [ ] Create a MongoDB database 
