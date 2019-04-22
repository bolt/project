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

Run Bolt using the built-in webserver, Docker or your own preferred webserver:

```bash
bin/console server:start
```

or…

```bash
make docker-install
```

Finally, open the new installation in a browser. If you've used one of the
commands above, you'll find the frontpage at http://127.0.0.1:8000/
The Bolt admin panel can be found at http://127.0.0.1:8000/bolt

The installation process created the first user. The username is `admin` and
the default password is `admin%1`
