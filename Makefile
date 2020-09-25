.PHONY: help install server server-stop cache csclear cscheck csfix stancheck db-create db-update db-reset

default: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk '{split($$0, a, ":"); printf "\033[36m%-30s\033[0m %-30s %s\n", a[1], a[2], a[3]}'

install: ## to install all project
	cp -n .env.dist .env || true
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
	bin/console doctrine:schema:create
	bin/console doctrine:fixtures:load -n

db-update: ## to update schema database
	bin/console doctrine:schema:update -v --dump-sql --force --complete

db-reset: ## to delete database and load fixtures
	bin/console doctrine:schema:drop --force --full-database
	bin/console doctrine:schema:create
	bin/console doctrine:fixtures:load -n
