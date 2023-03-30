# Recipes
SHELL := /bin/bash
include .env

export USERID=$(shell id -u)

all: $(ENV) init

$(ENV):
	@cp .env.example .env

init:
	@./.docker/scripts/docker-compose-cmd.sh up -d

build:
	@./.docker/scripts/docker-compose-cmd.sh up --build --force-recreate -d

key-generate:
	@docker exec -it $(APP_HOST) php artisan key:generate

compose:
	@docker exec -it $(APP_HOST) composer install

migrate:
	@docker exec -it $(APP_HOST) php artisan migrate

migrate-refresh:
	@docker exec -it $(APP_HOST) php artisan migrate:refresh

seed:
	@docker exec -it $(APP_HOST) php artisan db:seed

docker-login:
	@docker exec -u $(USER) -it $(APP_HOST) bash

tinker:
	@docker exec -it $(APP_HOST) php artisan tinker

serve:
	php artisan serve

down:
	@./.docker/scripts/docker-compose-cmd.sh down --remove-orphans

ps:
	@./.docker/scripts/docker-compose-cmd.sh ps

watch:
	@./.docker/scripts/docker-compose-cmd.sh logs -f

rebuild:
	@make down
	@./.docker/scripts/docker-compose-cmd.sh build --no-cache
	@./.docker/scripts/docker-compose-cmd.sh up -d

clear:
	@docker exec -it $(APP_HOST) composer dump
	@clear
	@docker exec -it $(APP_HOST) php artisan cache:clear
	@docker exec -it $(APP_HOST) php artisan route:clear
	@docker exec -it $(APP_HOST) php artisan config:clear

cs-fix:
	@docker exec -it $(APP_HOST) composer cs:fix
	@docker exec -it $(APP_HOST) composer cs

teste:
	@docker exec -it $(APP_HOST) composer test

teste-coverage:
	@docker exec -it $(APP_HOST) composer test:coverage

coverage:
	@open storage/coverage/report/index.html

.PHONY: all
