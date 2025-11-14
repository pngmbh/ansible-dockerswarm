SHELL=/bin/bash

lint:
	act --container-architecture linux/amd64 "pull_request"
