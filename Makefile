SHELL := /bin/sh
.DEFAULT_GOAL := help

# Shell colors
GREEN = \033[0;32m
NOCOLOR = \033[0m
YELLOW = \033[0;33m

# Shell commands
DC = docker-compose -f ./docker-compose.yml
DCR = $(DC) run
DCU = $(DC) up
MAKE = make
RM = rm -rf

#############################################################################
## Container tasks
#############################################################################

.PHONY: build
.SILENT: build
build: ; $(info Building the custom images needed)
	$(DC) build ${ARGS}

.PHONY: flush
.SILENT: flush
flush: ; $(info Removing created containers (stopping, if needed))
	$(DC) rm -fs ${ARGS}

.PHONY: inside
.SILENT: inside
inside: ; $(info Opening a shell within the container ${ARGS})
	$(DCR) ${ARGS} sh

.PHONY: list
.SILENT: list
list: ; $(info Listing current containers)
	$(DC) ps -a ${ARGS}

#############################################################################
## Dependency tasks
#############################################################################

.PHONY: install
.SILENT: install
install: ; $(info Installing all the project dependencies)
	$(DCR) composer install ${ARGS}

.PHONY: reinstall
.SILENT: reinstall
reinstall: remove install

.PHONY: remove
.SILENT: remove
remove: ; $(info Removing all content from dependencies)
	$(RM) composer.lock
	$(RM) vendor

.PHONY: update
.SILENT: update
update: ; $(info Updating the project dependencies)
	$(DCR) composer update ${ARGS}

#############################################################################
## Project tasks
#############################################################################

.PHONY: archive
.SILENT: archive
archive: ; $(info Generating a tar archive of the cleaned project)
	$(eval ARCHIVE = $(shell basename "$$PWD"))
	mkdir var/$(ARCHIVE)
	cp -a Makefile README.md bin/ composer.json config/ docker-compose.yml phpunit.xml.dist public src tests var/$(ARCHIVE)
	cd var/$(ARCHIVE)
	tar -czpf $(ARCHIVE).tar.gz -C var $(ARCHIVE)
	rm -rf var/$(ARCHIVE)
	ls -l $(ARCHIVE).tar.gz

.PHONY: clean
.SILENT: clean
clean: ; $(info Cleaning any generated file)
	$(RM) .phpunit.result.cache
	$(RM) composer.lock
	$(RM) coverage
	$(RM) var/*
	$(RM) vendor

.PHONY: help
.SILENT: help
help:
	@printf "$$help"

#############################################################################
## Testing tasks
#############################################################################

.PHONY: tests
.SILENT: tests
tests: ; $(info Running all kind of testing available)
	$(DCR) phpunit --configuration=./phpunit.xml.dist ${ARGS}

.PHONY: acceptance
.SILENT: acceptance
acceptance: start; $(info Running only the acceptance suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist --testsuite=acceptance ${ARGS}

.PHONY: functional
.SILENT: functional
functional: ; $(info Running only the functional suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist --testsuite=functional ${ARGS}

.PHONY: integration
.SILENT: integration
integration: ; $(info Running only the integration suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist --testsuite=integration ${ARGS}

.PHONY: unit
.SILENT: unit
unit: ; $(info Running only the unit suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist --testsuite=unit ${ARGS}

#############################################################################
## Web service tasks
#############################################################################

.PHONY: start
.SILENT: start
start: ; $(info Starting the web services in http://localhost:8080)
	$(DCU) -d nginx

.PHONY: stop
.SILENT: stop
stop: ; $(info Stopping the web services)
	$(DC) down

.PHONY: restart
.SILENT: restart
restart: stop start

#############################################################################
## Prints how to use make within this project
#############################################################################

define help
$(YELLOW)Usage:$(NOCOLOR)
  $(MAKE) task [ARGS=arguments]

$(YELLOW)Container tasks(NOCOLOR)
  $(GREEN)build$(NOCOLOR)             Builds the custom images needed for containers
  $(GREEN)flush$(NOCOLOR)             Removes created containers (stops, if needed)
  $(GREEN)inside ARGS=name$(NOCOLOR)  Opens a shell within the container 'name'
  $(GREEN)list$(NOCOLOR)              List current containers

$(YELLOW)Dependency tasks(NOCOLOR)
  $(GREEN)install$(NOCOLOR)           Resolves and installs the project dependencies
  $(GREEN)reinstall$(NOCOLOR)         Removes and reinstalls the project dependencies
  $(GREEN)remove$(NOCOLOR)            Removes all content from dependencies
  $(GREEN)update$(NOCOLOR)            Updates the project dependencies

$(YELLOW)Project tasks(NOCOLOR)
  $(GREEN)archive$(NOCOLOR)           Generates a tar archive of the cleaned project
  $(GREEN)clean$(NOCOLOR)             Leave the project clean without generated files
  $(GREEN)help$(NOCOLOR)              Shows this help command usage

$(YELLOW)Testing tasks(NOCOLOR)
  $(GREEN)tests$(NOCOLOR)             Runs all kind of testing available
  $(GREEN)acceptance$(NOCOLOR)        Runs only the acceptance suite tests
  $(GREEN)functional$(NOCOLOR)        Runs only the functional suite tests
  $(GREEN)integration$(NOCOLOR)       Runs only the integration suite tests
  $(GREEN)unit$(NOCOLOR)              Runs only the unit suite tests

$(YELLOW)Web service tasks(NOCOLOR)
  $(GREEN)start$(NOCOLOR)             Starts the web services
  $(GREEN)stop$(NOCOLOR)              Stops the web services
  $(GREEN)restart$(NOCOLOR)           Restarts the web services

endef
export help
