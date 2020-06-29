DC_RUN ?= docker-compose run --rm

.PHONY: help install build-assets copy-assets server server-stop cache csclear cscheck csfix csfix-tests stancheck test \
behat e2e full-test db-create db-update db-reset docker-install docker-install-deps docker-start docker-assets-serve \
docker-update docker-cache docker-csclear docker-cscheck docker-csfix docker-stancheck docker-db-create docker-db-reset \
docker-db-update docker-npm-fix-env docker-test docker-server-stop docker-behat docker-behat-rerun docker-full-test \
docker-command docker-console

default: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk '{split($$0, a, ":"); printf "\033[36m%-30s\033[0m %-30s %s\n", a[1], a[2], a[3]}'

install: ## to install all project
	cp -n .env.dist .env || true
	composer install
	make db-create

build-assets: ## to install assets
	cd vendor/bolt/core && npm install && npm run build
	rm -rf public/assets
	cp -rf vendor/bolt/core/public/assets public/assets

copy-assets: ## to install copy assets
	rm -rf ../assets/assets
	cp -rf vendor/bolt/core/public/assets ../assets/
	cp vendor/bolt/core/package.json ../assets/

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
	vendor/bin/ecs check src
	make stancheck

csfix: ## to fix coding style
	make csclear
	vendor/bin/ecs check src --fix
	make stancheck

csfix-tests: ## to test with csfixer
	make csclear
	vendor/bin/ecs check tests/php --fix
	make stancheck

stancheck: ## to run phpstan
	vendor/bin/phpstan --memory-limit=1G analyse -c phpstan.neon src

test: ## to run phpunit tests
	vendor/bin/phpspec run
	vendor/bin/phpunit

behat: ## to run behat tests
	make server
	vendor/bin/behat -v

behat-rerun: ## to rerun behat tests
	make server
	vendor/bin/behat -v --rerun

e2e: ## to run kakunin tests
	make server
	cd tests/e2e && npm run kakunin && cd ../..

full-test: ## to run full tests
	make cscheck
	make test
	npm test
	make behat
	make e2e

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

# Dockerized commands:
docker-install: ## to install project with docker
	make docker-start
	make docker-install-deps
	make docker-db-create
	make docker-server

docker-install-deps: ## to install all assets with docker
	docker-compose exec -T php sh -c "composer install"
	$(DC_RUN) node sh -c "make build-assets"
	$(DC_RUN) node sh -c "cd vendor/bolt/core && npm rebuild node-sass"

docker-start: ## to build containers
	cp -n .env.dist .env || true
	docker-compose up -d

docker-assets-serve: ## to run server with npm
	$(DC_RUN) node sh -c "npm run serve"

docker-update: ## to update dependencies with docker
	docker-compose exec -T php sh -c "composer update"

docker-cache: ## to clean cache with docker
	docker-compose exec -T php sh -c "bin/console cache:clear"

docker-csclear: ## to clean cache and check coding style with docker
	docker-compose exec -T php sh -c "mkdir -p var/cache/ecs"
	docker-compose exec -T php sh -c "chmod -R a+rw var/cache/ecs"
	docker-compose exec -T php sh -c "rm -rf var/cache/ecs/*"

docker-cscheck: ## to check coding style with docker
	make docker-csclear
	docker-compose exec -T php sh -c "vendor/bin/ecs check src"
	make docker-stancheck

docker-csfix: ## to fix coding style with docker
	make docker-csclear
	docker-compose exec -T php sh -c "vendor/bin/ecs check src --fix"
	make docker-stancheck

docker-stancheck: ## to run phpstane with docker
	docker-compose exec -T php sh -c "vendor/bin/phpstan analyse -c phpstan.neon src"

docker-db-create: ## to create database and load fixtures with docker
	docker-compose exec -T php sh -c "bin/console doctrine:database:create"
	docker-compose exec -T php sh -c "bin/console doctrine:schema:create"
	docker-compose exec -T php sh -c "bin/console doctrine:fixtures:load -n"

docker-db-reset: ## to delete database with docker
	docker-compose exec -T php sh -c "bin/console doctrine:schema:drop --force --full-database"
	docker-compose exec -T php sh -c "bin/console doctrine:schema:create"
	docker-compose exec -T php sh -c "bin/console doctrine:fixtures:load -n"

docker-db-update: ## to update schema database with docker
	docker-compose exec -T php sh -c "bin/console doctrine:schema:update -v --dump-sql --force --complete"

docker-npm-fix-env: ## to rebuild asset sass
	$(DC_RUN) node sh -c "npm rebuild node-sass"

docker-test: ## to run phpspec and phpunit tests with docker
	docker-compose exec -T php sh -c "vendor/bin/phpspec run"
	docker-compose exec -T php sh -c "vendor/bin/phpunit"

docker-server: ## to start server with docker
	docker-compose exec -T php bin/console server:start 127.0.0.1:8088

docker-server-stop: ## to stop server with docker
	docker-compose exec -T -u www-data php bin/console server:stop

docker-behat: ## to run behat tests with docker
	docker-compose exec -T php vendor/bin/behat -v

docker-behat-rerun: ## to rerun behat tests with docker
	docker-compose exec -T php vendor/bin/behat -v --rerun

docker-full-test: ## to run all test with docker
	make docker-cache
	make docker-cscheck
	make docker-test
	npm test
	make docker-behat
	make e2e

docker-command: ## to run commmand shell in php container
	docker-compose exec -T php sh -c "$(c)"

docker-console: ## to run commmand with console symfony in php container
	docker-compose exec -T php sh -c "bin/console $(c)"
