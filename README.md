Bolt 4 standard project skeleton
================================

Bolt CMS is an open source, adaptable platform for building and running modern websites. Built on PHP, Symfony and more. [Read the site](https://boltcms.io) for more info. 

**To check out Bolt and set up your first Bolt installation, read [Installing Bolt 4][installation].** 

---

## Installing Bolt CMS

### with Composer

You can set up a new Bolt 4 project, using the following command, replacing `myprojectname` with your desired project's name.

```bash
composer create-project bolt/project myprojectname
```

Navigate into the newly created folder, and configure the database and mailer in `.env`. (The configuration is intended to work with Docker.)

```dotenv
# Configure database for doctrine/doctrine-bundle
# SQLite
DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/bolt.sqlite

# MySQL
DATABASE_URL=mysql://db_user:db_password@127.0.0.1:3306/db_name

# PostgreSQL
DATABASE_URL=postgresql://db_user:db_password@127.0.0.1:5432/db_name?serverVersion=11&charset=utf8

# Configure mailer for symfony/mailer
MAILER_DSN=smtp://localhost
```

Set up the database, create the first user and add fixtures (dummy content):

```bash
bin/console doctrine:database:create  # create database
bin/console doctrine:schema:create    # create schema in database

bin/console doctrine:fixtures:load -n # load fixtures in databse (step not compulsory)
bin/console bolt:add-user             # follow the creation steps in the console (warning: fixtures already created an admin user)

composer run post-create-project-cmd  # duplicate themes in the appropriate folder

bin/console bolt:info                 # verify Bolt installation
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

### with Docker

Start by [downloading the Bolt project distribution `.tar.gz` file](https://github.com/bolt/project/releases/latest), or [generate a GitHub repository from the template we provide](https://github.com/bolt/project/generate).
Once you have extracted its content, the resulting directory contains the Bolt project structure. You will add your own code and configuration inside it.

**Note**: Try to avoid using the `.zip` file, as it may cause potential permission issues.

Bolt is shipped with a [Docker](https://docker.com) setup that makes it easy to get a containerized development environment up and running. If you do not already have Docker on your computer, it's the right time to [install it](https://docs.docker.com/get-docker/).

On Mac, only [Docker for Mac](https://docs.docker.com/docker-for-mac/) is supported.
Similarly, on Windows, only [Docker for Windows](https://docs.docker.com/docker-for-windows/) is supported. Docker Machine **is not** supported out of the box.

Open a terminal, and navigate to the directory containing your project skeleton.

Create the `docker-compose.override.yml` file at the root project for development environment and add the following:

```yaml
version: '3.4'

services:
  php:
    environment:
      - RESET_DATABASE=true  # create schema in database or reset database if the value is "true"
      - LAUNCH_FIXTURES=true # load fixtures in databse if the value is "true"
      # create admin user for development environment (warning: fixtures already created an admin user)
      - ADMIN_USERNAME=bolt
      - ADMIN_PASSWORD=!ChangeMe!
      - ADMIN_EMAIL=your@email.com
```

Run the following command to start all services using [Docker Compose](https://docs.docker.com/compose/):

```bash
docker-compose up -d # Running in detached mode
```

This starts the following services:

| Name        | Description                                                                | Port(s)            | Environment(s)                                   |
|-------------|----------------------------------------------------------------------------|--------------------|--------------------------------------------------|
| db          | A MySQL 5.7 database server                                                | 3306               | all (prefer using a managed service in prod)     |
| php         | The Bolt project with PHP, PHP-FPM 7.4, Composer and sensitive configs     | n/a                | all                                              |
| nginx       | The HTTP server for the Bolt project (NGINX)                               | 80                 | all                                              |
| h2-proxy    | A HTTP/2 and HTTPS development proxy for all apps                          | 443                | dev (configure properly your web server in prod) |
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

  docker-compose exec php bin/concole bolt:add-user # follow the creation steps in the console (warning: fixtures already created an admin user)
  ```
</details>

<details>
  <summary>To see the container's logs, run:</summary>

  ```bash
  docker-compose logs        # display the logs of all containers
  docker-compose logs -f     # same but follow the logs
  docker-compose logs -f php # follow the logs for one container
  ```
</details>

Finally, open the new installation in a browser. If you've used one of the commands above, you'll find the frontpage at http://localhost/ or https://localhost/ \
The Bolt admin panel can be found at http://localhost/bolt or https://localhost/bolt

## The tests

### Static analysis
- [**ECS - Easy Coding Standard**](https://github.com/symplify/easy-coding-standard)

[The `ecs.php` configuration file is located at the root of the cms project](./ecs.php)

```bash
composer lint                         # Launch ECS in dry run mode (command to launch in a Continuous Integration)
composer lint:fix                     # Launch ECS in fix mode
docker-compose exec php composer lint # Launch ECS by the php container
```

- [**PHPStan - PHP Static Analysis Tool**](https://github.com/phpstan/phpstan)

[The `phpstan.neon` configuration file is located at the root of the cms project](./phpstan.neon)

```bash
composer phpstan                         # Launch PHPStan (command to launch in a Continuous Integration)
docker-compose exec php composer phpstan # Launch PHPStan by the php container
```


## Contributing

If you'd like to contribute, please check [Bolt's core repository](https://github.com/bolt/core/blob/master/CONTRIBUTING.md) 
and read the ["Contributing to Bolt"](https://docs.bolt.cm/4.0/other/contributing) documentation page.

[installation]: https://docs.bolt.cm/installation
