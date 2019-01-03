# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
APP_NAME=alertbot
BINARY_UNIX=$(BINARY_NAME)_unix
ENV=dev
GIT_REVISION = $(shell git show -s --pretty=format:%h)

all: build
build:
	docker build --build-arg app_env=$(ENV) -t terry6394/$(APP_NAME)-$(ENV):$(GIT_REVISION) .
	docker tag terry6394/$(APP_NAME)-$(ENV):$(GIT_REVISION) terry6394/$(APP_NAME)-$(ENV):latest

test:
	#$(GOTEST) -v ./...

clean:
	docker images|grep "^terry6394/$(APP_NAME)"|awk '{print $$3}'|xargs docker rmi

run:
	docker run --rm -it -e APP_ENV=production -p 45678:45678 terry6394/$(APP_NAME)

dev:
	docker run --rm -it -e APP_ENV=dev -p 45678:45678 -v$(PWD)/app:/go/src/github.com/terry6394/botAlert/app terry6394/$(APP_NAME)-dev go build
	docker run --rm -it -e APP_ENV=dev -p 45678:45678 -v$(PWD)/app:/go/src/github.com/terry6394/botAlert/app terry6394/$(APP_NAME)-dev
