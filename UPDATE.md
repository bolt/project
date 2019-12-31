Bolt 4 - Beta Update Instructions
=================================

If you're updating a previous Bolt 4 Beta to the latest, you might bump into 
some quirks. Read below on how to fix these

The base command to update is always: 

```bash
composer update
bin/console cache:clear
```


## PDOException > DriverException

If your database is out of date, you get this error: 

```
An exception occurred while executing '…' with params […]:

SQLSTATE[HY000]: General error:
```

Run the following to update it (by force): 

```bash
bin/console doctrine:schema:update --force
```

## Autowire TimedPublishSubscriber

If you get this error: 

```
 Cannot autowire service "Bolt\Event\Subscriber\TimedPublishSubscriber": argument "$prefix" of method "__construct()" is type-hinted "string", you should
  configure its value explicitly.
```

You can fix this by adding the following to your `config/services.yaml`:

```yaml
    Bolt\Event\Subscriber\TimedPublishSubscriber:
        arguments: [ "%bolt.table_prefix%" ]
```
