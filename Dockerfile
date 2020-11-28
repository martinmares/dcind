# Inspired by https://github.com/mumoshu/dcind
# and by      https://github.com/meAmidos/dcind
FROM alpine:3.10
LABEL maintainer="Martin Mareš <mares@datalite.cz>"

ENV LANG cs_CZ.utf8

ENV DOCKER_VERSION=18.09.8 \
    DOCKER_COMPOSE_VERSION=1.24.1

# Install Docker and Docker Compose
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.10/world" >> /etc/apk/repositories
RUN apk --no-cache add bash curl util-linux device-mapper py-pip python-dev \
    libffi-dev openssl-dev gcc libc-dev make iptables && \
    curl https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar zx && \
    mv /docker/* /bin/ && \
    chmod +x /bin/docker* && \
    pip install docker-compose==${DOCKER_COMPOSE_VERSION} && \
    rm -rf /root/.cache

RUN mkdir -p /root/.docker && mkdir -p "/etc/docker/certs.d/celimregp401.server.cetin:8443"

# Add Docket config
COPY config.json /root/.docker/config.json

# Add CETIN CA
COPY cetin-ca.crt /etc/docker/certs.d/celimregp401.server.cetin:8443/ca.crt

# Include functions to start/stop docker daemon
COPY docker-lib.sh /docker-lib.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
