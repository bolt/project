#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/console' ]; then
	PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-production"
	if [ "$APP_ENV" != 'prod' ]; then
		PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-development"
	fi
	ln -sf "$PHP_INI_RECOMMENDED" "$PHP_INI_DIR/php.ini"

	mkdir -p public/files public/theme public/thumbs var/cache var/log
	setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX config public/files public/theme public/thumbs var
	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX config public/files public/theme public/thumbs var

	if [ "$APP_ENV" != 'prod' ]; then
		composer install --prefer-dist --no-progress --no-suggest --no-interaction
	fi

	echo "Waiting for db to be ready..."
	ATTEMPTS_LEFT_TO_REACH_DATABASE=60
	until [ $ATTEMPTS_LEFT_TO_REACH_DATABASE -eq 0 ] || bin/console doctrine:query:sql "SELECT 1" > /dev/null 2>&1; do
		sleep 1
		ATTEMPTS_LEFT_TO_REACH_DATABASE=$((ATTEMPTS_LEFT_TO_REACH_DATABASE-1))
		echo "Still waiting for db to be ready... Or maybe the db is not reachable. $ATTEMPTS_LEFT_TO_REACH_DATABASE attempts left"
	done

	if [ $ATTEMPTS_LEFT_TO_REACH_DATABASE -eq 0 ]; then
		echo "The db is not up or not reachable"
		exit 1
	else
		echo "The db is now ready and reachable"
		php bin/console bolt:info
	fi

	if ! ls -A public/theme/* > /dev/null 2>&1; then
		composer run post-create-project-cmd
	fi

	if ls -A migrations/*.php > /dev/null 2>&1; then
		bin/console doctrine:migrations:migrate --no-interaction
	fi

	if [ "$APP_ENV" != 'prod' ]; then
		if [ ! -z $RESET_DATABASE ]; then
			bin/console doctrine:schema:drop --force --full-database
			bin/console doctrine:schema:create
		fi

		if [ ! -z $LAUNCH_FIXTURES ]; then
			bin/console doctrine:fixtures:load --no-interaction
		fi

		if [ ! -z $ADMIN_USERNAME ] && [ ! -z $ADMIN_PASSWORD ] && [ ! -z $ADMIN_EMAIL ]; then
			bin/console bolt:add-user $ADMIN_USERNAME $ADMIN_PASSWORD $ADMIN_EMAIL $ADMIN_USERNAME --admin --no-interaction
		fi
	fi
fi

exec docker-php-entrypoint "$@"
