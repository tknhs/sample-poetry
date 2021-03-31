# env
## default
export SHELL=/bin/bash
.DEFAULT_GOAL := help
## build/run
export CONTAINER_NAME=sample-poetry
export DOCKER_FILE_PATH=docker/Dockerfile
export PWD=`pwd`
## clean
export NONE_DOCKER_IMAGES=`docker images -f dangling=true -q`
export STOPPED_DOCKER_CONTAINERS=`docker ps -a -q`

.PHONY: help

build: ## build docker
	docker build --pull --target prod -f $(DOCKER_FILE_PATH) -t $(CONTAINER_NAME) .
build-nc: ## build docker (no-cache)
	docker build --pull --target prod --no-cache -f $(DOCKER_FILE_PATH) -t $(CONTAINER_NAME) .
build-dev: ## build docker (test/lint image)
	docker build --pull --target dev -f $(DOCKER_FILE_PATH) -t $(CONTAINER_NAME) .

run: ## run docker
	docker run -it --rm $(CONTAINER_NAME)
run-local: ## run docker (mount local dir)
	docker run -it --rm -v $(PWD):/app $(CONTAINER_NAME)

test: build-dev ## run test
	docker run --rm $(CONTAINER_NAME) poetry run pytest

lint: build-dev ## run lint
	@make run-isort
	@make run-black
	@make run-flake8
	@make run-mypy
lint-isort:
	docker run --rm $(CONTAINER_NAME) poetry run isort . --check --diff
lint-black:
	docker run --rm $(CONTAINER_NAME) poetry run black . --check --diff
lint-flake8:
	docker run --rm $(CONTAINER_NAME) poetry run flake8 .
lint-mypy:
	docker run --rm $(CONTAINER_NAME) poetry run mypy .

clean: ## clean images/containers
	-@make clean-images
	-@make clean-containers
clean-images:
	docker rmi -f $(NONE_DOCKER_IMAGES)
clean-containers:
	docker rm -f $(STOPPED_DOCKER_CONTAINERS)

help: ## this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
