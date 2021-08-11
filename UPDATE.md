Bolt 5 - Beta Update Instructions
=================================

If you are experiencing issues with translations, make sure that
you have the following in `config/packages/php_translation.yaml`:

```yaml
# php-translation config

translation:
    configs:
        bolt:
            output_dir: "%kernel.project_dir%/translations"
```
Note this only applies to Bolt 5 beta versions.

Bolt 4 - Beta Update Instructions
=================================

If you're updating a previous Bolt 4 Beta to the latest, you might bump into
some quirks. Read below on how to fix these

The base command to update is always:

```bash
composer update
bin/console cache:clear
```

## From earlier Beta's to more recent versions

### Error: Expected known function, got 'INSTR'"

If you get this error, edit `config/packages/doctrine.yaml` and make sure the following is included:

```yaml
        dql:
            string_functions:
                JSON_EXTRACT: Bolt\Doctrine\Functions\JsonExtract
                CAST: DoctrineExtensions\Query\Mysql\Cast
                INSTR: DoctrineExtensions\Query\Mysql\Instr
            numeric_functions:
                RAND: Bolt\Doctrine\Functions\Rand
```

### The file "../vendor/bolt/core/src/Controller/Backend/" does not exist 

If you get the following error: 

```
The file "../vendor/bolt/core/src/Controller/Backend/" does not exist (in: "…/config/routes") 
in ../vendor/bolt/core/src/Controller/Backend/ 
```

Edit `config/routes/bolt.yaml` to add `../` to each of the `resource:`'s: 

```php 
control_panel:
    resource: '../../vendor/bolt/core/src/Controller/Backend/'
    prefix: '%bolt.backend_url%'
    type: annotation

# Async: Upload, Embed
control_panel_async:
    resource: '../../vendor/bolt/core/src/Controller/Backend/Async'
    prefix: '%bolt.backend_url%/async'
    type: annotation

# ImageController, Currently only used for thumbnails
controllers:
    resource: '../../vendor/bolt/core/src/Controller/ImageController.php'
    type: annotation
```

### Cannot autowire service "Bolt\Controller\ErrorController"

If you get this error:

```
!!  In AbstractRecursivePass.php line 153:
!!
!!    Invalid service "Bolt\Controller\ExceptionController": class "Bolt\Controll
!!    er\ExceptionController" does not exist
```

Replace the following lines in `services.yaml`:

```yaml
    # Override Symfony's error pages (so we can show custom 404's)
    Bolt\Controller\ExceptionController:
        public: true
        arguments:
            $debug: '%kernel.debug%'
```

with: 

```
    Symfony\Component\ErrorHandler\ErrorRenderer\ErrorRendererInterface: '@error_handler.error_renderer.html'
    
    Squirrel\TwigPhpSyntax\PhpSyntaxExtension: ~
```

Replace this line in `packages/twig.yaml`: 

```yaml
    exception_controller: Bolt\Controller\ExceptionController::showAction
```

with: 

```yaml
    exception_controller: ~
```

Next, *delete* the file `config/routes/dev/twig.yaml`

And finally, in `packages/framework.yaml`, add: 

```yaml
    # Override Symfony's error controller, so we can show custom 404's and 503's
    error_controller: Bolt\Controller\ErrorController::showAction
```

### Uncaught …\ClassNotFoundException: Attempted to load class "DoctrineCacheBundle" / "WhiteOctoberPagerfantaBundle"

If you get this error: 

```
!!  Fatal error: Uncaught …\ClassNotFoundException: Attempted to load class "DoctrineCacheBundle" from namespace "Doctrine\Bundle\DoctrineCacheBundle".
!!  Did you forget a "use" statement for another namespace? in /…/src/Kernel.php:32
!!  Stack trace:
```

Or this error: 

```
!!  PHP Fatal error:  Uncaught …\ClassNotFoundException: Attempted to load class "WhiteOctoberPagerfantaBundle" from namespace "WhiteOctober\PagerfantaBundle".
!!  Did you forget a "use" statement for another namespace? in /…/src/Kernel.php:32
```

You can fix this by _removing_ this line from `config/bundles.php`: 

```php
    Doctrine\Bundle\DoctrineCacheBundle\DoctrineCacheBundle::class => ['all' => true],
    …
    WhiteOctober\PagerfantaBundle\WhiteOctoberPagerfantaBundle::class => ['all' => true],
```


### Uncaught Error: Class '…WhiteOctoberPagerfantaBundle' not found

If you get this error:

```
Script cache:clear returned with error code 255
!!  PHP Fatal error:  Uncaught Error: Class 'WhiteOctober\PagerfantaBundle\WhiteOctoberPagerfantaBundle' 
!!  not found in site/vendor/bolt/core/src/Kernel.php:32 
!!  Stack trace:
```

Edit `config/bundles.php`, and replace

```php
    WhiteOctober\PagerfantaBundle\WhiteOctoberPagerfantaBundle::class => ['all' => true],
``` 

with 

```php
    BabDev\PagerfantaBundle\BabDevPagerfantaBundle::class => ['all' => true],
```

### Call to a member function setLocale() on array OR Collection fields not visible

If you get this error when saving a record:
```
    Call to a member function setLocale() on array
```
or, if collection items are not visible after saving them

Update services.yaml, add the 3 lines below:
```yaml
    Bolt\Event\Listener\FieldFillListener:
        tags:
            - { name: doctrine.event_listener, event: postLoad }
```

### "$defaultLocale" of method "__construct()"

If you get this error:

```
Cannot autowire service "Bolt\Canonical": argument "$defaultLocale" of meth
!!    od "__construct()" is type-hinted "string", you should configure its value
!!    explicitly.
```

Update services.yaml, add the line with `$defaultLocale`:

```yaml
services:
    _defaults:
        …
        bind:
            $locales: '%app_locales%'
            $defaultLocale: '%locale%'
            …
```

### "$publicFolder" of method "__construct()"

If you get this error:

```
Cannot autowire service "Bolt\Command\CopyAssetsCommand": argument "$public
!!    Folder" of method "__construct()" is type-hinted "string", you should confi
!!    gure its value explicitly.
```

Update services.yaml, add the line with `$publicFolder`:

```yaml
services:
    _defaults:
        …
        bind:
            …
            $publicFolder: '%bolt.public_folder%'
            $tablePrefix: '%bolt.table_prefix%'
```

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

Or this error:

```
Specified non-existing directory "/…/vendor/gedmo/doctrine-extensions/lib/Gedmo/Translatable/Entity/MappedSuperclass"
as Doctrine mapping source.
```

Remove these two lines from `config/services.yaml`:

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
