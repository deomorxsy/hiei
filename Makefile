.DEFAULT_GOAL := all

PROTOC_VERSION ?= 24.0
DISTRO_CHECK := $(shell lsb_release -is 2>/dev/null || echo "Unknown")

.PHONY: help
help: # display available commands
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: docker-config hiei publish

.PHONY: publish
publish: hiei
	@source ./scripts/ccr.sh && find_oci

.PHONY: upa
upa: hiei
 ifeq ($(DISTRO_CHECK),Arch)
	@. ./scripts/ccr.sh; checker; \
	docker compose --file ./deploy/compose.yml up
else
	docker compose --file ./deploy/compose.yml up
endif

.PHONY: hiei
hiei:
ifeq ($(DISTRO_CHECK),Arch)
	@. ./scripts/ccr.sh; checker; \
	PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f ./deploy/compose.yml build hiei
else
	PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f ./deploy/compose.yml build hiei
endif

	#PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f ./deploy/compose.yml run --rm protogen

.PHONY: docker-config
docker-config:
ifeq ($(DISTRO_CHECK),Arch)
	@. ./scripts/ccr.sh; checker; \
	PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f ./deploy/compose.yml config
else
	PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f ./deploy/compose.yml build protogen
endif


.PHONY: prom
prom:
 ifeq ($(DISTRO_CHECK),Arch)
	@. ./scripts/ccr.sh; checker; \
	docker compose --file=./deploy/compose.yml up prometheus
else
	docker compose --file=./deploy/compose.yml up prometheus
endif



.PHONY: down
down:
 ifeq ($(DISTRO_CHECK),Arch)
	@. ./scripts/ccr.sh; checker; \
	docker compose --file=./deploy/compose.yml down
else
	docker compose --file=./deploy/compose.yml down
endif


.PHONY: proto-clean
proto-clean:
	@rm -rf pb/message
	@rm -rf pb/service
