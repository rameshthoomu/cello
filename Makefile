GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

STATIC_FOLDER?=themes\/react\/static
TEMPLATE_FOLDER?=themes\/react\/templates

.PHONY: \
	all \
	check \
	clean \
	log \
	logs \
	redeploy \
	restart \
	setup \

all: check

check: ##@Code Check code format
	tox

clean: ##@Code Clean tox result
	rm -rf .tox

# Use like "make log service=dashboard"
log: ##@Log tail special service log, Use like "make log service=dashboard"
	docker-compose logs -f ${service} --tail=100

logs:
	docker-compose logs -f --tail=100

# Use like "make redeploy service=dashboard"
redeploy: ##@Service Redeploy single service, Use like "make redeploy service=dashboard"
	bash scripts/redeploy.sh ${service}

initial-env: ##@Configuration Initial Configuration for dashboard
	sed -i 's/\(STATIC_FOLDER=\).*/\1${STATIC_FOLDER}/' .env
	sed -i 's/\(TEMPLATE_FOLDER=\).*/\1${TEMPLATE_FOLDER}/' .env

start: ##@Service Start service
	@$(MAKE) initial-env
	bash scripts/start.sh

stop: ##@Service Stop service
	bash scripts/stop.sh

restart: ##@Service Restart service
	stop start

setup: ##@Environment Setup dependency for service environment
	bash scripts/setup.sh

HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }

help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
