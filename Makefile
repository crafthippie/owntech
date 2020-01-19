SHELL := bash
NAME := ownTech
DIST := dist

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
	cp -rf client $(DIST)/$(NAME)-$(OUTPUT)
	$(SED) -i 's/VERSION/$(VERSION)/' $(DIST)/$(NAME)-$(OUTPUT)/manifest.json
	cd $(DIST) && zip -rm $(NAME)-$(OUTPUT).zip $(NAME)-$(OUTPUT) -x \*.DS_Store
	cd $(DIST) && $(SHASUM) $(NAME)-$(OUTPUT).zip >| $(NAME)-$(OUTPUT).zip.sha256
	rm -rf $(DIST)/$(NAME)-$(OUTPUT)
