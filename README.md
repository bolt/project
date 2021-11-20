Bolt 5 standard project skeleton
================================

Bolt CMS is an open source, adaptable platform for building and running modern websites. Built on PHP, Symfony and more. [Read the site](https://boltcms.io) for more info. 

**To check out Bolt and set up your first Bolt installation, read [Installing Bolt 5][installation].** 

---

## Installing Bolt CMS

### with Composer

**Note**: Installing with composer and running the site on your local machine using the method described below is the preferred method of the Bolt core development team.

You can set up a new Bolt 5 project, using the following command, replacing `myprojectname` with your desired project's name.

```bash
composer create-project bolt/project myprojectname
```

Navigate into the newly created folder, and configure the database in `.env` (The configuration is intended to work with the database SQLite).

```dotenv
# Configure database for doctrine/doctrine-bundle
# SQLite (note: _three_ slashes)
DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/bolt.sqlite

# MYSQL / MariaDB
#DATABASE_URL=mysql://db_user:"db_password"@127.0.0.1:3306/db_name?serverVersion=5.7

# Postgres
#DATABASE_URL=postgresql://db_user:"db_password"@127.0.0.1:5432/db_name?serverVersion=11&charset=utf8
```

Set up the database, create the first user and add fixtures (dummy content):

```bash
bin/console doctrine:database:create # Create database
bin/console doctrine:schema:create # Create schema in database

bin/console doctrine:fixtures:load --no-interaction # Load fixtures in databse (step not compulsory)
bin/console bolt:add-user --admin # Follow the creation steps in the console (warning: fixtures already created an admin user)

composer run post-create-project-cmd # Duplicate themes in the appropriate folder

bin/console bolt:info # Verify Bolt installation
```

Run Bolt using the built-in webserver, Symfony CLI or your own preferred webserver:

```bash
bin/console server:start
```

or…

```bash
symfony server:start -d
symfony open:local
```

Finally, open the new installation in a browser. If you've used one of the commands above, you'll find the frontpage at http://127.0.0.1:8000/ \
The Bolt admin panel can be found at http://127.0.0.1:8000/bolt

Log in using the credentials you created when setting up the first user.

> Note: If you don't want to use Docker, don't forget to remove what isn't necessary: \
    - remove `.dockerignore` file \
    - remove `docker-composer.yml` file \
    - remove `Dockerfile` file \
    - remove `docker` folder

### with Docker

**Disclaimer**: Docker is not used by the Bolt core development team. Bolt _can_ be run using docker, but you are advised to only attempt this if you have enough experience with Docker yourself to understand what is going on in the `Dockerfile` and in `docker-compose.yml`. The included setup might not be a good fit for _your_ Dockerized setup. When in doubt, follow general advice on running Symfony projects in docker, as Bolt is built using Symfony. The Bolt team doesn't provide pre-built containers.

Start by [downloading the Bolt project distribution `.tar.gz` file](https://github.com/bolt/project/releases/latest), or [generate a GitHub repository from the template we provide](https://github.com/bolt/project/generate).
Once you have extracted its content, the resulting directory contains the Bolt project structure. You will add your own code and configuration inside it.

**Note**: Try to avoid using the `.zip` file, as it may cause potential permission issues.

Bolt is shipped with a [Docker](https://docker.com) setup that makes it easy to get a containerized development environment up and running. If you do not already have Docker on your computer, it's the right time to [install it](https://docs.docker.com/get-docker/).

On Mac, only [Docker for Mac](https://docs.docker.com/docker-for-mac/) is supported.
Similarly, on Windows, only [Docker for Windows](https://docs.docker.com/docker-for-windows/) is supported. Docker Machine **is not** supported out of the box.

Open a terminal, and navigate to the directory containing your project skeleton.

Navigate into the newly created folder, and configure environment variables in the `.env` file for Docker & the database MySQL version 5.7.

```dotenv
###> symfony/framework-bundle ###
APP_ENV=dev
APP_DEBUG=1
APP_SECRET=!ChangeMe!
TRUSTED_PROXIES=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
TRUSTED_HOSTS='^(localhost|nginx)$'
###< symfony/framework-bundle ###

###> doctrine/doctrine-bundle ###
DATABASE_URL=mysql://bolt:!ChangeMe!@db:3306/bolt?serverVersion=5.7
###< doctrine/doctrine-bundle ###

###> symfony/mailer ###
MAILER_DSN=smtp://mailcatcher:1025
###< symfony/mailer ###
```

Run the following command to start all services using [Docker Compose](https://docs.docker.com/compose/):

```bash
docker-compose up -d # Running in detached mode
docker-compose exec php bin/console doctrine:schema:create # Create schema in database
docker-compose exec php bin/console doctrine:fixtures:load --no-interaction # Load fixtures in databse (step not compulsory)
docker-compose exec php bin/console bolt:add-user --admin # Follow the creation steps in the console (warning: fixtures already created an admin user)
```

This starts the following services:

| Name        | Description                                                                | Port(s)            | Environment(s)                                   |
|-------------|----------------------------------------------------------------------------|--------------------|--------------------------------------------------|
| db          | A MySQL 5.7 database server                                                | 3306               | all (prefer using a managed service in prod)     |
| php         | The Bolt project with PHP, PHP-FPM 7.4, Composer and sensitive configs     | n/a                | all                                              |
| nginx       | The HTTP server for the Bolt project (NGINX)                               | 8080               | all                                              |
| h2-proxy    | A HTTP/2 and HTTPS development proxy for all apps                          | 8443               | dev (configure properly your web server in prod) |
| mailcatcher | MailCatcher runs a super simple SMTP server delivered with a web interface | 1025 for smtp port<br/>1080 for interface    | only for dev           |

<details>
  <summary>To see the status of the containers, run:</summary>

  ```bash
  docker-compose ps
  ```
</details>

<details>
  <summary>To execute commands in a container, run:</summary>

  ```bash
  docker-compose exec <container name> <command>
  docker-compose exec php sh # To enter the container directly, you will be placed at the root of the project
  docker-compose exec php bin/console bolt:add-user # Follow the creation steps in the console (warning: fixtures already created an admin user)
  ```
</details>

<details>
  <summary>To see the container's logs, run:</summary>

  ```bash
  docker-compose logs        # Display the logs of all containers
  docker-compose logs -f     # Same but follow the logs
  docker-compose logs -f php # Follow the logs for one container
  ```
</details>

Finally, open the new installation in a browser. If you've used one of the commands above, you'll find the frontpage at http://localhost:8080/ or https://localhost:8443/ \
The Bolt admin panel can be found at http://localhost:8080/bolt or https://localhost:8443/bolt

## The tests

### Static analysis
- [**ECS - Easy Coding Standard**](https://github.com/symplify/easy-coding-standard)

[The `ecs.php` configuration file is located at the root of the cms project](./ecs.php)

```bash
# With Composer
composer lint                         # Launch ECS in dry run mode (command to launch in a Continuous Integration)
composer lint:fix                     # Launch ECS in fix mode

# With Docker
docker-compose exec php composer lint # Launch ECS by the php container
```

- [**PHPStan - PHP Static Analysis Tool**](https://github.com/phpstan/phpstan)

[The `phpstan.neon` configuration file is located at the root of the cms project](./phpstan.neon)

```bash
# With Composer
composer phpstan                         # Launch PHPStan (command to launch in a Continuous Integration)

# With Docker
docker-compose exec php composer phpstan # Launch PHPStan by the php container
```

## Contributing

If you'd like to contribute, please check [Bolt's core repository](https://github.com/bolt/core/blob/master/CONTRIBUTING.md) 
and read the ["Contributing to Bolt"](https://docs.bolt.cm/4.0/other/contributing) documentation page.

[installation]: https://docs.bolt.cm/installation
