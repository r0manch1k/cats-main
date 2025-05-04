-include .env
export

DOCKER_COMPOSE = docker compose --env-file .env

# CLEANING

.PHONY: rm-volumes
rm-volumes:
	$(DOCKER_COMPOSE) down -v
	docker volume prune -a -f

.PHONY: rm-images
rm-images:
	$(DOCKER_COMPOSE) down --rmi all
	docker image prune -a -f

.PHONY: rm-containers
rm-containers:
	docker container prune -f

.PHONY: rm-networks
rm-networks:
	docker network prune -f

.PHONY: rm-system
rm-system: 
	docker system prune --volumes -f

.PHONY: rm-all
rm-all: rm-volumes rm-images rm-containers rm-system rm-networks

# DOCKER

.PHONY: build
build:
	$(DOCKER_COMPOSE) build

.PHONY: build-service
build-service:
	$(DOCKER_COMPOSE) build $(SERVICE)

.PHONY: up
up:
	$(DOCKER_COMPOSE) up -d

.PHONY: up-service
up-service:
	$(DOCKER_COMPOSE) up -d --no-deps $(SERVICE)

.PHONY: up-logs
up-logs:
	$(DOCKER_COMPOSE) up

.PHONY: up-logs-service
up-logs-service:
	$(DOCKER_COMPOSE) up --no-deps $(SERVICE)

.PHONY: down
down:
	$(DOCKER_COMPOSE) down