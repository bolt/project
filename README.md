Bolt 4 standard project skeleton
================================

Set up a new Bolt 4 project, using the following command:

```bash
composer create-project bolt/standard-project project -s dev
```

Navigate into the newly created folder, and configure the database in `.env`:

```dotenv
# SQLite
DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/bolt.sqlite

# MySQL
DATABASE_URL=mysql://root:"root%1"@127.0.0.1:3306/four
```

Then, build and copy assets, create the database and add fixtures: 

```bash
make install
make db-reset
```

Run Bolt using the built-in webserver, or Docker: 

```bash
bin/console server:start
```

or 

```bash
make docker-install
```

… And you're good to go! 
