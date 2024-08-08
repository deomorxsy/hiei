.DEFAULT_GOAL := all

PROTOC_VERSION ?= 24.0

.PHONY: help
help: # display available commands
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: docker-config proto-compile

.PHONY: proto-clean
proto-clean:
	@rm -rf pb/message
	@rm -rf pb/service

.PHONY: proto-compile
proto-compile:
	. ./scripts/ccr.sh; checker; \
	PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f ./oci-spec/compose.yml build protogen
	#PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f ./oci-spec/compose.yml run --rm protogen

.PHONY: docker-config
docker-config:
	. ./scripts/ccr.sh; checker; \
	PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f ./oci-spec/compose.yml config
