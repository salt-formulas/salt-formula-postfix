DESTDIR=/
SALTENVDIR=/usr/share/salt-formulas/env
RECLASSDIR=/usr/share/salt-formulas/reclass
FORMULANAME=$(shell grep name: metadata.yml|head -1|cut -d : -f 2|grep -Eo '[a-z0-9\-]*')
KITCHEN_LOCAL_YAML?=.kitchen.yml

all:
	@echo "make install - Install into DESTDIR"
	@echo "make test    - Run tests"
	@echo "make kitchen - Run Kitchen CI tests (create, converge, verify)"
	@echo "make clean   - Cleanup after tests run"

install:
	# Formula
	[ -d $(DESTDIR)/$(SALTENVDIR) ] || mkdir -p $(DESTDIR)/$(SALTENVDIR)
	cp -a $(FORMULANAME) $(DESTDIR)/$(SALTENVDIR)/
	[ ! -d _modules ] || cp -a _modules $(DESTDIR)/$(SALTENVDIR)/
	[ ! -d _states ] || cp -a _states $(DESTDIR)/$(SALTENVDIR)/ || true
	# Metadata
	[ -d $(DESTDIR)/$(RECLASSDIR)/service/$(FORMULANAME) ] || mkdir -p $(DESTDIR)/$(RECLASSDIR)/service/$(FORMULANAME)
	cp -a metadata/service/* $(DESTDIR)/$(RECLASSDIR)/service/$(FORMULANAME)

test:
	[ ! -d tests ] || (cd tests; ./run_tests.sh)

kitchen-create:
	kitchen create
	[ "$(shell echo $(KITCHEN_LOCAL_YAML)|grep -Eo docker)" = "docker" ] || sleep 120

kitchen-converge:
	kitchen converge

kitchen-verify:
	[ ! -d tests/integration ] || kitchen verify -t tests/integration
	[ -d tests/integration ]   || kitchen verify

kitchen-test:
	[ ! -d tests/integration ] || kitchen test -t tests/integration
	[ -d tests/integration ]   || kitchen test

kitchen-list:
	kitchen list

clean:
	[ ! -x "$(shell which kitchen)" ] || kitchen destroy
	[ ! -d tests/build ] || rm -rf tests/build
	[ ! -d build ] || rm -rf build
