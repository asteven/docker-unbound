REGISTRY = docker.io
IMG_NAMESPACE = asteven
IMG_NAME = unbound
#IMG_FQNAME = $(IMG_NAMESPACE)/$(IMG_NAME)
IMG_FQNAME = $(REGISTRY)/$(IMG_NAMESPACE)/$(IMG_NAME)
IMG_VERSION = 0.1.0
#BUILDER = $(shell which docker)
BUILDER = $(shell which podman)

.PHONY: build-runtime push clean
all: build-runtime

build-runtime:
	# Build the runtime stage
	sudo $(BUILDER) build \
		--tag $(IMG_FQNAME):$(IMG_VERSION) \
		--tag $(IMG_FQNAME):latest .

push:
	sudo $(BUILDER) push $(IMG_FQNAME):$(IMG_VERSION) docker://$(IMG_FQNAME):$(IMG_VERSION)
	# Also update :latest
	sudo $(BUILDER) push $(IMG_FQNAME):latest docker://$(IMG_FQNAME):latest

clean:
	sudo $(BUILDER) rmi $(IMG_FQNAME):$(IMG_VERSION)
	sudo $(BUILDER) rmi $(IMG_FQNAME):latest

