# Container image that runs your code
FROM alpine:3.19

RUN apk add --no-cache bash

# Install curl
RUN apk add --no-cache curl

# Install jq
RUN apk add --no-cache jq

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
