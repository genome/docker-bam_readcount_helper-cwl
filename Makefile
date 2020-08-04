NAME   := seqfu/bam_readcount_helper-cwl:1.1.1-samtools-1.10
IMG    := ${NAME}
LATEST := ${NAME}
HOST   := $$(basename ${NAME})
PWD    := $$(pwd)

build:
	@docker build -f Dockerfile -t ${IMG} .
	@docker tag ${IMG} ${LATEST}
 
push:
	@docker push ${NAME}

interact:
	docker run --rm --hostname ${HOST} --detach-keys="ctrl-@" -t -i ${LATEST} /bin/bash

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
