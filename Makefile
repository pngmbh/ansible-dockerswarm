SHELL=/bin/bash

ROLENAME=ansible-dockerswarm
TESTIMAGENAME=molecule-test

docker_cmd:=docker run --rm -it \
	-v '${PWD}':/tmp/${ROLENAME} \
	-w /tmp/${ROLENAME}

build-testimage:
	docker build -t ${TESTIMAGENAME} .

SCENARIO?=--all
DEBUG_OPTS?=

lint: build-testimage
	$(docker_cmd) \
		${TESTIMAGENAME} \
		molecule lint $(SCENARIO)

test: build-testimage
	$(docker_cmd) \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${TESTIMAGENAME} \
		molecule test $(SCENARIO) $(DEBUG_OPTS)

debug: DEBUG_OPTS:=--destroy=never
debug: build-testimage test
