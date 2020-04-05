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
ECHO = echo
MAKE = make
RM = rm

.PHONY: clean
.SILENT: clean
clean: ; $(info Removing all compiled / generated files)
	$(RM) -rfv .phpunit.result.cache
	$(RM) -rfv coverage
	$(RM) -rfv phpunit.xml
	$(RM) -rfv var/*
	$(RM) -rfv vendor

.PHONY: compile
.SILENT: compile
compile: ; $(info Compiling all the application dependencies to be used)
	$(DCR) composer install ${ARGS}

.PHONY: recompile
.SILENT: recompile
recompile: clean compile

.PHONY: stop
.SILENT: stop
stop: ; $(info Stopping the application services)
	$(DC) down

.PHONY: start
.SILENT: start
start: ; $(info Starting the application services)
	$(DCU) -d nginx

.PHONY: restart
.SILENT: restart
restart: stop start

.PHONY: tests
.SILENT: tests
tests: ; $(info Running all the suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist ${ARGS}

.PHONY: tests-acceptance
.SILENT: tests-acceptance
tests-acceptance: ; $(info Running only the acceptance suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist --testsuite=acceptance ${ARGS}

.PHONY: tests-functional
.SILENT: tests-functional
tests-functional: ; $(info Running only the functional suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist --testsuite=functional ${ARGS}

.PHONY: tests-integration
.SILENT: tests-integration
tests-integration: ; $(info Running only the integration suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist --testsuite=integration ${ARGS}

.PHONY: tests-unit
.SILENT: tests-unit
tests-unit: ; $(info Running only the unit suite tests)
	$(DCR) phpunit --configuration=./phpunit.xml.dist --testsuite=unit ${ARGS}

.PHONY: help
.SILENT: help
help:
	$(ECHO) "$(YELLOW)Usage:$(NOCOLOR)"
	$(ECHO) "  $(MAKE) [ARGS='arguments'] command"
	$(ECHO) ""
	$(ECHO) "$(YELLOW)Project:$(NOCOLOR)"
	$(ECHO) "  $(GREEN)clean$(NOCOLOR)              Remove all compiled / generated files"
	$(ECHO) "  $(GREEN)compile$(NOCOLOR)            Compiles the application to be used"
	$(ECHO) "  $(GREEN)recompile$(NOCOLOR)          Cleans and compiles the application to be used"
	$(ECHO) "  $(GREEN)ARGS=name shell$(NOCOLOR)    Opens a shell within the container"
	$(ECHO) ""
	$(ECHO) "$(YELLOW)Tests:$(NOCOLOR)"
	$(ECHO) "  $(GREEN)tests$(NOCOLOR)              Runs all the suite tests"
	$(ECHO) "  $(GREEN)tests-acceptance$(NOCOLOR)   Runs only the acceptance suite tests"
	$(ECHO) "  $(GREEN)tests-functional$(NOCOLOR)   Runs only the functional suite tests"
	$(ECHO) "  $(GREEN)tests-integration$(NOCOLOR)  Runs only the integration suite tests"
	$(ECHO) "  $(GREEN)tests-unit$(NOCOLOR)         Runs only the unit suite tests"
	$(ECHO) ""
	$(ECHO) "$(YELLOW)Web server:$(NOCOLOR)"
	$(ECHO) "  $(GREEN)start$(NOCOLOR)              Starts the web services"
	$(ECHO) "  $(GREEN)stop$(NOCOLOR)               Stops the web services"
	$(ECHO) "  $(GREEN)restart$(NOCOLOR)            Restarts the web services"

.PHONY: shell
.SILENT: shell
shell: ; $(info Opening a shell within the container ${ARGS})
	$(DCR) ${ARGS} sh
