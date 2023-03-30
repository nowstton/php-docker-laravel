# Recipes
SHELL := /bin/bash
include .env

export USERID=$(shell id -u)

all: init

init:
	@./.docker/scripts/docker-compose-cmd.sh up -d

dcompose-buid:
	@./.docker/scripts/docker-compose-cmd.sh up --build --force-recreate -d

dcompose-rebuid:
	@make down
	@./.docker/scripts/docker-compose-cmd.sh build --no-cache
	@./.docker/scripts/docker-compose-cmd.sh up -d

dcompose:
	@./.docker/scripts/docker-compose-cmd.sh $@

container:
	@docker exec -u $(USER) -it $(APP_HOST) bash

artisan:
	@docker exec -it $(APP_HOST) php artisan $@

composer:
	@docker exec -it $(APP_HOST) composer $@

php-lint:
	@docker exec -it $(APP_HOST) composer cs:fix
	@docker exec -it $(APP_HOST) composer cs

clear-cache:
	@docker exec -it $(APP_HOST) composer dump
	@clear
	@docker exec -it $(APP_HOST) php artisan cache:clear
	@docker exec -it $(APP_HOST) php artisan route:clear
	@docker exec -it $(APP_HOST) php artisan config:clear

.PHONY: all
