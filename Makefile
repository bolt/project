.PHONY: help install server server-stop cache csclear cscheck csfix stancheck db-create db-update db-reset
.DEFAULT_GOAL := help

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

install: ## to install all project
	composer install
	make db-create

server: ## to start server
	bin/console server:start 127.0.0.1:8088 || true

server-stop: ## to stop server
	bin/console server:stop

cache: ## to clean cache
	bin/console cache:clear

csclear: ## to clean cache and check coding style
	mkdir -p var/cache/ecs
	chmod -R a+rw var/cache/ecs
	rm -rf var/cache/ecs/*

cscheck: ## to check coding style
	make csclear
	composer lint
	make stancheck

csfix: ## to fix coding style
	make csclear
	composer lint:fix
	make stancheck

stancheck: ## to run phpstan
	composer phpstan

db-create: ## to create database and load fixtures
	bin/console doctrine:database:create
	bin/console doctrine:schema:create -q
	bin/console doctrine:migrations:sync-metadata-storage -q
	bin/console doctrine:migrations:version --add --all --no-interaction -q
	bin/console doctrine:fixtures:load --no-interaction -q

db-update: ## to update schema database
	bin/console doctrine:schema:update --complete --dump-sql --force --version
	bin/console doctrine:migrations:sync-metadata-storage -q
	bin/console doctrine:migrations:version --add --all --no-interaction -q

db-reset: ## to delete database and load fixtures
	bin/console doctrine:schema:drop --force --full-database
	bin/console doctrine:schema:create -q
	bin/console doctrine:migrations:sync-metadata-storage -q
	bin/console doctrine:migrations:version --add --all --no-interaction -q
	bin/console doctrine:fixtures:load --no-interaction
