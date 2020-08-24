Bolt 4 standard project skeleton
================================

Bolt CMS is an open source, adaptable platform for building and running modern 
websites. Built on PHP, Symfony and more. [Read the site](https://boltcms.io) 
for more info. 

To check out Bolt and set up your first Bolt installation, read 
[Installing Bolt 4][installation]. 

You can set up a new Bolt 4 project, using the following command, replacing
`myprojectname` with your desired project's name.

```bash
composer create-project bolt/project myprojectname
```

Navigate into the newly created folder, and configure the database in `.env`.
You can skip this step, if you'd like to use SQLite.

```dotenv
# SQLite
DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/bolt.sqlite

# MySQL
DATABASE_URL=mysql://root:"root%1"@127.0.0.1:3306/four
```

Set up the database, create the first user and add fixtures (dummy content):

```bash
bin/console bolt:setup
```

Run Bolt using the built-in webserver, Symfony CLI, Docker or your own
preferred webserver:

```bash
bin/console server:start
```

or…

```bash
symfony server:start -d
symfony open:local
```

or…

```bash
make docker-install
```

Finally, open the new installation in a browser. If you've used one of the
commands above, you'll find the frontpage at http://127.0.0.1:8000/ \
The Bolt admin panel can be found at http://127.0.0.1:8000/bolt

Log in using the credentials you created when setting up the first user.

## Contributing

If you'd like to contribute, please check [Bolt's core repository](https://github.com/bolt/core/blob/master/CONTRIBUTING.md) 
and read the ["Contributing to Bolt"](https://docs.bolt.cm/4.0/other/contributing) documentation page.
