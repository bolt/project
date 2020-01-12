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

### Unable to find file "@TranslationBundle/Resources/config/routing_webui.yml"

If you get this error: 

```
Unable to find file "@TranslationBundle/Resources/config/routing_webui.yml" in 
@TranslationBundle/Resources/config/routing_webui.yml (which is being imported 
from "/Users/bob/Sites/Bolt/standard-project/config/routes/translation.yml").
```

Update `config/routes/translation.yml`:

```
    resource: "@TranslationBundle/Resources/config/routing_webui.yaml"
```

and `config/routes/dev/translation.yml`:

```
    resource: '@TranslationBundle/Resources/config/routing_symfony_profiler.yaml'
```

In both cases, you just need to update `.yml` to `.yaml`


### Attempted to load class "StofDoctrineExtensionsBundle"

If you get this error: 

```
PHP Fatal error:  Uncaught Symfony\Component\Debug\Exception\ClassNotFoundException: Attempted to load class "StofDoctrineExtensionsBundle" from namespace "Stof\DoctrineExtensionsBundle".
```

Remove these two lines from `comfig/services.yaml`:

```yaml
    doctrine.orm.entity_manager.class: Bolt\Doctrine\TranslatableEntityManager
    stof_doctrine_extensions.listener.translatable.class: Bolt\Event\Listener\PreTranslatableListener
```

In `config/bundles.php`, remove one line, and add another. Remove: 

```php
Stof\DoctrineExtensionsBundle\StofDoctrineExtensionsBundle::class => ['all' => true],
```

and replace it with: 

```php
Knp\DoctrineBehaviors\Bundle\DoctrineBehaviorsBundle::class => ['all' => true],
```

Then, delete the file `config/packages/stof_doctrine_extensions.yaml`

Then, in `config/packages/doctrine.yaml`, remove these sections: 

```yaml
            gedmo_translatable:
                type: annotation
                prefix: Gedmo\Translatable\Entity
                dir: "%kernel.project_dir%/vendor/gedmo/doctrine-extensions/lib/Gedmo/Translatable/Entity/MappedSuperclass"
                is_bundle: false
            gedmo_translator:
                type: annotation
                prefix: Gedmo\Translator\Entity
                dir: "%kernel.project_dir%/vendor/gedmo/doctrine-extensions/lib/Gedmo/Translator/Entity"
                is_bundle: false
```

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
