NAME   := seqfu/bam_readcount_helper-cwl:1.1.1-samtools-1.10
TAG    := $$(git log -1 --pretty=%h)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:latest
HOST   := $$(basename ${NAME})
PWD    := $$(pwd)

build:
	@docker build -f Dockerfile -t ${IMG} ../../..
	@docker tag ${IMG} ${LATEST}
 
push:
	@docker push ${NAME}

interact:
	docker run --rm -v "$$(pwd)/../..:/bam-readcount" -w "/bam-readcount" --hostname ${HOST} --detach-keys="ctrl-@" -t -i ${LATEST} /bin/bash

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
