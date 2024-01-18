SHELL := bash
NAME := owntech
DIST := dist

UNAME := $(shell uname -s)

BOOTSTRAP_VERSION := 0.0.3
BOOTSTRAP_URL := https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v$(BOOTSTRAP_VERSION)/packwiz-installer-bootstrap.jar

ifeq ($(UNAME), Darwin)
	SED ?= gsed
	SHASUM ?= shasum -a 256
else
	SED ?= sed
	SHASUM ?= sha256sum
endif

ifndef OUTPUT
	ifeq ($(GITHUB_REF_TYPE),tag)
		OUTPUT ?= $(subst v,,$(GITHUB_REF_NAME))
	else
		OUTPUT ?= testing
	endif
endif

ifndef VERSION
	ifeq ($(GITHUB_REF_TYPE),tag)
		VERSION ?= $(subst v,,$(GITHUB_REF_NAME))
	else
		VERSION ?= $(shell git rev-parse --short HEAD)
	endif
endif

$(DIST):
	mkdir -p $(DIST)

.PHONY: clean
clean:
	rm -rf $(DIST)

.PHONY: docs
docs:
	cd docs; hugo

.PHONY: build
build: $(DIST)/$(NAME)-$(OUTPUT).zip $(DIST)/$(NAME)-$(OUTPUT).zip.sha256

$(DIST)/$(NAME)-$(OUTPUT).zip: $(DIST)
	$(SED) -i 's|version = ".*"|version = "$(VERSION)"|' pack.toml
	cd $(DIST) && packwiz curseforge export --meta-folder-base $(CURDIR)/ --pack-file $(CURDIR)/pack.toml --yes
	git checkout $(CURDIR)/pack.toml
ifeq ($(OUTPUT), testing)
	mv $(DIST)/$(NAME)-$(VERSION).zip $(DIST)/$(NAME)-$(OUTPUT).zip
endif

$(DIST)/$(NAME)-$(OUTPUT).zip.sha256: $(DIST)
	cd $(DIST) && $(SHASUM) $(NAME)-$(OUTPUT).zip >| $(NAME)-$(OUTPUT).zip.sha256

.PHONY: client
client: packwiz-installer-bootstrap.jar
	java -jar packwiz-installer-bootstrap.jar --no-gui pack.toml --side client

.PHONY: server
server: packwiz-installer-bootstrap.jar
	java -jar packwiz-installer-bootstrap.jar --no-gui pack.toml --side server

packwiz-installer-bootstrap.jar:
	curl -sSLo packwiz-installer-bootstrap.jar $(BOOTSTRAP_URL)
