# ebarbeito/php

> Skeleton to bootstrap plain PHP projects with docker

Use this skeleton to create a fresh PHP project without writing the common boilerplate that is often needed in order to start from scratch.

The project is intended to use with the following development environment:

* UNIX-like as operating system
* Docker and Docker compose
* GNU Make

These are not required, but highly recommended. It will allow you not to have to install locally anything, such as PHP by itself, nor Composer, nor PHPUnit, nor a web server, etc. The idea is executing all of this as a _dockerized environment_.

## Start a new project

With `docker` installed, create your new project:

```
docker run --rm -it -v $(pwd):/app \
  composer create-project ebarbeito/php project-name
```

Once created, you can start by customizing the `composer.json` file, taking a look into the `bin/` scripts, or the prepared tasks inside the `Makefile`

```
$ cd project-name
$ tree .
  .
  ├── Makefile
  ├── README.md
  ├── bin
  │   ├── composer
  │   ├── php
  │   ├── phpunit
  │   └── run
  ├── composer.json
  ├── config
  │   └── nginx
  │       └── site.conf
  ├── docker-compose.yml
  ├── phpunit.xml.dist
  ├── public
  │   └── index.php
  ├── src
  ├── tests
  │   ├── Functional
  │   │   └── DummyFunctionalSuiteTest.php
  │   ├── Integration
  │   │   └── DummyIntegrationSuiteTest.php
  │   └── Unit
  │       └── DummyUnitSuiteTest.php
  └── var
```

## bin/ scripts

Due to not having installed any development tool (only Docker), the aim of this scripts is simulate the real commands.

**The ./bin/run script**

`./bin/run` is just the wrapper around the command `docker-compose run`. So, each time you execute it, you are running `docker-compose run` indeed.

```
./bin/run <command> [arguments]
```

The "command" is a service defined in `docker-compose.yml`

* `./bin/run composer [arguments]`: To use composer
* `./bin/run phpunit [arguments]`: To use phpunit
* `./bin/run php [arguments]`: To use php

**The other scripts**

The rest of the commands relies in `./bin/run` to do their job. They make the same, but with less verbosity.

* `./bin/composer [arguments]`: To use composer
* `./bin/phpunit [arguments]`: To use phpunit
* `./bin/php [arguments]`: To use php

So, instead to use a global `php` command (or a `composer` one), this scripts are a replacement to be used in the same way as usual.

## Makefile tasks

...

## Docker compose services

...