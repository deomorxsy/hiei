PROTOC_VERSION ?= 24.0
.PHONY help
help: # display available commands
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY proto-clean
proto-clean:
	@rm -rf pb/message
	@rm -rf pb/service

.PHONY: proto-compile
proto-compile:
	PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f oci-spec/compose.yaml run --rm protogen

.PHONY: docker-config
docker-config:
	PLATFORM=$(shell uname -m) PROTOC_VERSION=$(PROTOC_VERSION) docker compose -f oci-spec/compose.yaml config
