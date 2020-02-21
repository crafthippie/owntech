SHELL := bash
NAME := ownTech
DIST := dist
CLIENT := client

UNAME := $(shell uname -s)

ifeq ($(UNAME), Darwin)
	SED ?= gsed
	SHASUM ?= shasum -a 256
else
	SED ?= sed
	SHASUM ?= sha256sum
endif

ifndef OUTPUT
	ifneq ($(DRONE_TAG),)
		OUTPUT ?= $(subst v,,$(DRONE_TAG))
	else
		OUTPUT ?= testing
	endif
endif

ifndef VERSION
	ifneq ($(DRONE_TAG),)
		VERSION ?= $(subst v,,$(DRONE_TAG))
	else
		VERSION ?= $(shell git rev-parse --short HEAD)
	endif
endif

$(DIST):
	mkdir -p $(DIST)

.PHONY: clean
clean:
	rm -rf $(DIST)

.PHONY: changelog
changelog:
	calens >| CHANGELOG.md

.PHONY: docs
docs:
	cd docs; hugo

.PHONY: package
package: $(DIST)
	$(SED) -i 's/VERSION/$(VERSION)/' $(CLIENT)/manifest.json
	cd $(CLIENT) && zip -r ../$(DIST)/$(NAME)-$(OUTPUT).zip * -x \*.DS_Store
	$(SED) -i 's/$(VERSION)/VERSION/' $(CLIENT)/manifest.json
	cd $(DIST) && $(SHASUM) $(NAME)-$(OUTPUT).zip >| $(NAME)-$(OUTPUT).zip.sha256
