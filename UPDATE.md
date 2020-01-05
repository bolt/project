Bolt 4 - Beta Update Instructions
=================================

If you're updating a previous Bolt 4 Beta to the latest, you might bump into 
some quirks. Read below on how to fix these

The base command to update is always: 

```bash
composer update
bin/console cache:clear
```

## From earlier Beta's to Beta 5

### "Notice: Undefined index: location"

If you get this error: 

```
 Notice: Undefined index: location
```

You can fix this by adding the following to your `config/services.yaml`:

```yaml
    monolog.processor.request:
        class: Bolt\Log\RequestProcessor
        tags:
            - { name: monolog.processor, method: processRecord, handler: db }
```

### Add `monolog.yaml`

Create a new file `config/packages/monolog.yaml`, to configure the new logging:

```yaml
monolog:
    channels: ['db']
    handlers:
        db:
            channels: ['db']
            type: service
            id: Bolt\Log\LogHandler
```

### PDOException > DriverException

If your database is out of date, you get this error: 

```
An exception occurred while executing '…' with params […]:

SQLSTATE[HY000]: General error:
```

Run the following to update it (by force): 

```bash
bin/console doctrine:schema:update --force
```

### Autowire TimedPublishSubscriber

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
